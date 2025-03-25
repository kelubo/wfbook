# OSD

[TOC]

## 概述 

Ceph OSD 通常包含一个 `ceph-osd` 守护进程，用于一个存储驱动器以及节点中关联的日志。如果节点有多个存储驱动器，则为每个驱动器映射一个 `ceph-osd` 守护进程。

建议定期检查集群的容量，以查看它是否达到其存储容量的上限。当存储集群达到 `接近满` 比率时，添加一个或多个 OSD 以扩展存储集群的容量。

如果要减小红帽 Ceph 存储集群的大小或替换硬件，也可以在运行时移除 OSD。如果节点有多个存储驱动器，可能还需要删除该驱动器的一个 `ceph-osd` 守护进程。通常，最好检查存储群集的容量，以查看其容量是否达到其容量的上限。在移除存储集群未达到接近满比率的 OSD 时，确保该存储集群没有 `接近满` 比率。

**重要：**

在添加 OSD 之前，请勿让存储集群达到 `完整的` 比率。存储集群达到 `接近满` 比率后出现的 OSD 故障可能会导致存储集群超过 `满` 比率。Ceph 会通过阻止写入访问来保护数据，直到您解决存储容量问题为止。不要先考虑对 `满` 比率的影响，否则不要移除 OSD。 			

将 Ceph OSD 和支持的硬件配置为将使用 OSD 的池的存储策略。Ceph 喜欢池间的统一硬件，以实现一致的性能配置集。为获得最佳性能，请考虑 CRUSH 层次结构，其驱动器类型或大小相同。

如果您添加不同大小的驱动器，请相应地调整其权重。将 OSD 添加到 CRUSH map 时，请考虑新 OSD 的权重。硬盘驱动器容量每年增长约 40%，因此较新的 OSD 节点的硬盘驱动器可能比存储集群中的旧节点大，也就是说，它们的权重可能更大。 		

如满足以下所有条件，认为存储设备可用：

- 设备上不能有分区。
- 设备不能有任何 LVM 状态。
- 设备不能被 mount 。
- 设备不能包含文件系统。
- 设备不能包含 BlueStore OSD。
- 设备必须大于 5 GB。

Ceph 不会在不可用的设备上提供 OSD。

## OSD 后端

OSD 有两种方式管理其存储的数据。Luminous 12.2.z 版本以后，默认（推荐）后端是 BlueStore 。在 Luminous 版本之前，默认（也是唯一的选项）是 Filestore 。

### BlueStore

是一种专门为 Ceph OSD workloads 管理磁盘上的数据而设计的专用存储后端。BlueStore 的设计基于十年来支持和管理 Filestore OSD 的经验。

主要功能包括：

* 直接管理存储设备。BlueStore 使用原始块设备或分区。这避免了可能限制性能或增加复杂性的中间抽象层（如 XFS 之类的本地文件系统）。
* 使用 RocksDB 进行元数据管理。RocksDB 的键/值数据库被嵌入，以管理内部元数据，包括将对象名称映射到磁盘上的块位置。
* 完整数据和元数据校验和。默认情况下，写入 BlueStore 的所有数据和元数据都受一个或多个校验和的保护。未经验证，不会从磁盘读取任何数据或元数据，也不会将其返回给用户。
* Inline compression内联压缩。数据可以在写入磁盘之前进行选择性压缩。
* 多设备元数据分层。BlueStore 允许将其内部日志（预写日志）写入单独的高速设备（如 SSD、NVMe 或 NVDIMM），以提高性能。如果有大量更快的存储可用，则可以在更快的设备上存储内部元数据。
* 高效的写时拷贝。RBD 和 CephFS 快照依赖于在 BlueStore 中高效实现的写时拷贝克隆机制。This results in efficient I/O both for regular snapshots and for erasure-coded pools (which rely on cloning to implement efficient two-phase commits).这将为常规快照和擦除编码池（依靠克隆实现高效的两阶段提交）带来高效的 I/O。

### FileStore

FileStore 是在 Ceph 中存储对象的传统方法。它依赖于一个标准文件系统（通常是 XFS ）和一个键/值数据库（传统上是 LevelDB，现在是 RocksDB ）来获取一些元数据。

FileStore 经过良好测试，并在生产中广泛使用。然而，由于其总体设计和对传统文件系统的依赖，它存在许多性能缺陷。

尽管 FileStore 能够在大多数 POSIX 兼容的文件系统（包括 btrfs 和 ext4 ）上运行，但我们建议仅将 XFS 文件系统用于 Ceph 。btrfs 和 ext4 都有已知的 bug 和缺陷，使用它们可能会导致数据丢失。默认情况下，所有 Ceph 资源调配工具都使用 XFS 。

## 列出设备

`ceph-volume` 会定期扫描集群中的每个主机，以确定存在且响应的设备。It is also determined whether each is eligible to be used for new OSDs in a block, DB, or WAL role.它还将确定每个是否有资格用于块、DB 或 WAL 角色中的新 OSD 。

显示发现的存储设备列表：

```bash
ceph orch device ls [--hostname=...] [--wide] [--refresh]

--wide  # 提供与设备相关的所有详细信息，包括设备不适合用作 OSD 的任何原因。不支持 NVMe 设备。
```

例如：

```bash
Hostname  Path      Type  Serial              Size   Health   Ident  Fault  Available
srv-01    /dev/sdb  hdd   15P0A0YFFRD6         300G  Unknown  N/A    N/A    No
srv-02    /dev/sdb  hdd   15R0A033FRD6         300G  Unknown  N/A    N/A    No
srv-03    /dev/sdb  hdd   15R0A0OGFRD6         300G  Unknown  N/A    N/A    No
```

请注意，`ceph orch device ls` 报告的列可能因版本而异。

在上面的示例中，可以看到名为 “Health”、“Ident” 和 “Fault” 的字段。此信息是通过与 libstoragemgmt 集成提供的。默认情况下，此集成处于禁用状态（因为 libstoragemgmt 可能与您的硬件不是 100% 兼容）。要使 ceph 包含这些字段，启用 cephadm 的 “enhanced device scan” 选项。

```bash
ceph config set mgr mgr/cephadm/device_enhanced_scan true
```

> **Warning**
>
> 尽管 libstoragemgmt 库执行标准的 SCSI （SES）查询调用，但不能保证固件完全实现这些标准。可能导致某些较旧的硬件上出现不稳定的行为，甚至 bus resets 总线重置。因此，建议在启用此功能之前，首先测试硬件与 libstoragemgmt 的兼容性，以避免服务意外中断。
>
> 测试兼容性的方法有很多种，但最简单的方法可能是使用 cephadm shell 直接调用 libstoragemgmt ： `cephadm shell lsmcli ldl` 。
>
> 如果硬件受支持，应该看到如下内容：
>
> ```bash
> Path     | SCSI VPD 0x83    | Link Type | Serial Number      | Health Status
> ----------------------------------------------------------------------------
> /dev/sda | 50000396082ba631 | SAS       | 15P0A0R0FRD6       | Good
> /dev/sdb | 50000396082bbbf9 | SAS       | 15P0A0YFFRD6       | Good
> ```

启用 libstoragemgmt 支持后，输出将如下所示：

```bash
ceph orch device ls
Hostname   Path      Type  Serial              Size   Health   Ident  Fault  Available
srv-01     /dev/sdb  hdd   15P0A0YFFRD6         300G  Good     Off    Off    No
srv-01     /dev/sdc  hdd   15R0A08WFRD6         300G  Good     Off    Off    No
```

在此示例中，libstoragemgmt 已确认驱动器的运行状况以及与驱动器机柜上的标识和故障指示灯进行交互的能力。

> **Note：**
>
> 当前版本的 libstoragemgmt（1.8.8）仅支持基于 SCSI、SAS 和 SATA 的本地磁盘。There is no official support for NVMe devices (PCIe), SAN LUNs, or exotic/complex metadevices.没有对 NVMe 设备（PCIe）、SAN LUN 或奇异/复杂元设备的官方支持。。

查看节点和设备详情：

```bash
ceph osd tree
```

列出服务：

```bash
ceph orch ls osd
```

列出主机、守护进程和进程：

```bash
ceph orch ps --service_name=SERVICE_NAME

ceph orch ps --service_name=osd
```

## 检索块设备的确切大小

The value returned here is used by the orchestrator when filtering based on size:
运行以下形式的命令以发现块设备的确切大小。此处返回的值由业务流程协调程序在根据大小进行筛选时使用：

```bash
cephadm shell ceph-volume inventory </dev/sda> --format json | jq .sys_api.human_readable_size
```

The exact size in GB is the size reported in TB, multiplied by 1024.
以 GB 为单位的确切大小是以 TB 为单位报告的大小乘以 1024。

### 示例

下面根据上述命令的一般形式提供了此命令的具体示例：

```bash
cephadm shell ceph-volume inventory /dev/sdc --format json | jq .sys_api.human_readable_size
"3.64 TB"
```

这表示确切的设备大小为 3.64 TB 或 3727.36 GB。

该程序由 Frédéric Nass 开发。在 [[ceph-users\] 邮件列表中查看此帖子](https://lists.ceph.io/hyperkitty/list/ceph-users@ceph.io/message/5BAAYFCQAZZDRSNCUPCVBNEPGJDARRZA/) 讨论这个问题。

## 部署 OSD

要部署 OSD，必须有一个或多个可用的存储设备来部署 OSD 。

### 创建新的 OSD

多种方式：

- 使用任何可用和未使用的存储设备：

  ```bash
  ceph orch apply osd --all-available-devices
  ```

  这将消耗 `Ceph` 集群中通过所有安全检查的任何主机上的任何设备（`HDD` 或 `SSD`），这意味着没有分区、没有 `LVM` 卷、没有文件系统等。每个设备将部署一个 `OSD`，这是适用于大多数用户的最简单情况。

- 从特定主机上的特定设备创建 OSD：

  ```bash
  ceph orch daemon add osd <host>:<device-path>
  
  ceph orch daemon add osd host1:/dev/sdb
  ```

- 从特定主机上的特定设备创建高级 OSD：

  ```bash
  ceph orch daemon add osd host1:data_devices=/dev/sda,/dev/sdb,db_devices=/dev/sdc,osds_per_device=2
  ```
  
- 在特定主机上的特定 LVM 逻辑卷上创建 OSD ：

  ```bash
  ceph orch daemon add osd <host>:<lvm-path>
  
  ceph orch daemon add osd host1:/dev/vg_osd/lvm_osd1701
  ```
  
- 使用 [Advanced OSD Service Specifications](https://docs.ceph.com/en/latest/cephadm/osd/#drivegroups) 根据设备的属性对设备进行分类。这可能有助于更清楚地了解哪些设备可以使用。属性包括设备类型（SSD 或 HDD）、设备型号名称、大小以及设备所在的主机：

  ```bash
  ceph orch apply -i spec.yml
  ```

> 警告
>
> 使用 `cephadm` 部署新的 OSD 时，请确保目标主机上未安装 `ceph-osd` 软件包。如果安装了 OSD，则 OSD 的管理和控制可能会出现冲突，从而导致错误或意外行为。

- 默认情况下，通过 `ceph orch daemon add` 创建的 OSD 不会添加到 Orchestrator 的 OSD 服务中。要将 OSD 附加到其他现有 OSD 服务，请发出以下形式的命令：
  
  ```
  ceph orch osd set-spec-affinity <service_name> <osd_id(s)>
  ```
  
  例如：
  
  ```
  ceph orch osd set-spec-affinity osd.default_drive_group 0 1
  ```

### Dry Run 试运行

`--dry-run` 标志使编排器在不实际创建 OSD 的情况下呈现将要发生的事情的预览。

```bash
ceph orch apply osd --all-available-devices --dry-run

NAME                  HOST  DATA      DB  WAL
all-available-devices node1 /dev/vdb  -   -
all-available-devices node2 /dev/vdc  -   -
all-available-devices node3 /dev/vdd  -   -
```

### 声明状态

`ceph orch apply` 作用是持久的。这意味着在命令完成后添加到系统中的驱动器将被自动发现并添加到集群中。这也意味着在 `ceph orch apply` 命令完成后可用的驱动器（例如通过 zapping）将被自动发现并添加到集群中。

```bash
ceph orch apply osd --all-available-devices
```

- 如果向集群添加新磁盘，它们将自动用于创建新的 OSD 。
- 如果删除 OSD 并清理 LVM 物理卷，将自动创建新的 OSD 。

如要禁用在可用设备上自动创建 OSD ，请使用 unmanaged 参数：

```bash
ceph orch apply osd --all-available-devices --unmanaged=true
```

> **注意：**
>
> 记住这三个事实：
>
> -  `ceph orch apply` 的默认行为导致 cephadm constantly to reconcile. 这意味着 cephadm 会在检测到新驱动器后立即创建 OSD 。
> - 设置 `unmanaged: True` 将禁用 OSD 的创建。如果设置了 `unmanaged: True` ，即使应用新的 OSD 服务，也不会发生任何事情。
> - `ceph orch daemon add` 创建 OSD，但不添加 OSD 服务。

## 删除 OSD

从群集中删除 OSD 需要两个步骤：

1.  从群集中疏散所有归置组（PG）。
2.  从群集中移除无 PG 的 OSD 。

以下命令执行这两个步骤：

```bash
# 查看要移除的 OSD 的 ID
ceph osd tree

# 移除 OSD
ceph orch osd rm <osd_id(s)> [--replace] [--force] [--zap]
# eg:
ceph orch osd rm 0
ceph orch osd rm 1138 --zap
# 输出
Scheduled OSD(s) for removal
# 批量删除脚本
for osd_id in $(ceph orch ps --host HOST_NAME --service_type osd) ; do ceph orch osd rm OSD_ID ; done
```

无法安全销毁的 OSD 将被拒绝。添加 `--zap` 标志可指示编排器从 OSD 的驱动器中删除所有 LVM 和分区信息，将其留作空白，以便重新部署或其他重用。

> 注意
>
> After removing OSDs, if the OSDs’ drives become available, `cephadm` may automatically try to deploy more OSDs on these drives if they match an existing drivegroup spec. If you deployed the OSDs you are removing with a spec and don’t want any new OSDs deployed on the drives after removal, it’s best to modify the drivegroup spec before removal. Either set `unmanaged: true` to stop it from picking up new drives, or modify it in some way that it no longer matches the drives used for the OSDs you wish to remove. Then re-apply the spec. For more info on drivegroup specs see [Advanced OSD Service Specifications](https://docs.ceph.com/en/latest/cephadm/services/osd/#drivegroups). For more info on the declarative nature of `cephadm` in reference to deploying OSDs, see [Declarative State](https://docs.ceph.com/en/latest/cephadm/services/osd/#cephadm-osd-declarative)
> 删除 OSD 后，如果 OSD 的驱动器可用，`则 cephadm` 可能会自动尝试在这些驱动器上部署更多 OSD（如果它们与现有驱动器组规范匹配）。如果您使用 spec 部署了要删除的 OSD，并且不希望在删除后在驱动器上部署任何新的 OSD，则最好在删除之前修改驱动器组 spec。设置 `unmanaged： true` 以阻止它获取新驱动器，或者以某种方式对其进行修改，使其不再与用于要删除的 OSD 的驱动器匹配。然后重新应用该等级库。有关 drivegroup 规格的更多信息，请参阅[高级 OSD 服务规格](https://docs.ceph.com/en/latest/cephadm/services/osd/#drivegroups)。有关 的声明性性质的更多信息 `cephadm` 中，请参阅[声明式状态](https://docs.ceph.com/en/latest/cephadm/services/osd/#cephadm-osd-declarative)

### 监控 OSD 移除状态

在删除 OSD 的过程中，可以通过运行以下命令来查询 OSD 的状态：

```bash
ceph orch osd rm status

# 预期输出
OSD_ID  HOST         STATE                    PG_COUNT  REPLACE  FORCE  STARTED_AT
2       cephadm-dev  done, waiting for purge  0         True     False  2020-07-17 13:01:43.147684
3       cephadm-dev  draining                 17        False    True   2020-07-17 13:01:45.162158
4       cephadm-dev  started                  42        False    True   2020-07-17 13:01:45.162158
```

当 OSD 上没有 PG 时，它将停用并从集群中移除。

> **Note：**
>
> 删除 OSD 后，如果擦除已删除 OSD 使用的设备中的 LVM 物理卷，将创建新的 OSD 。有关此问题的详细信息，请阅读声明状态下的 `unmanaged` 参数。

### 停止 OSD 删除

使用以下命令停止排队的 OSD 删除：

```bash
ceph orch osd rm stop <osd_id(s)>

ceph orch osd rm stop 4
Stopped OSD(s) removal
```

这将重置 OSD 的初始状态并将其从删除队列中移除。

## 替换 OSD

可以使用 `ceph orch rm` 命令保留 OSD ID，以替换集群中的 OSD。这与“删除 OSD ”部分中的过程相同，但有一个例外：OSD 不会永久从 CRUSH 层次结构中移除，而是被分配有 `destroy` 标志。此标志用于确定可在下一次 OSD 部署中重复使用的 OSD ID 。"destroyed"标志用于决定在下一次 OSD 部署中重复使用哪些 OSD ID。 		

如果使用 OSD 规格进行部署，则会为新添加的磁盘分配其替换的对等点的 OSD ID。

```bash
orch orch osd rm <osd_id(s)> --replace [--force]

ceph orch osd rm 4 --replace
Scheduled OSD(s) for replacement
```

> Note
>
> The new OSD that will replace the removed OSD must be created on the same host as the OSD that was removed.
>
> 必须在与已删除的 OSD 相同的主机上创建将替换删除的 OSD 的新 OSD 。

**保留 OSD ID**

“destroyed” 标志用于确定哪些 OSD ID 将在下一次 OSD 部署中重复使用。

如果将 OSD Specs 用于 OSD 部署，则新添加的磁盘将被分配其替换的对应磁盘的 OSD ID 。这假设新磁盘仍然与 OSD Specs 匹配。

使用 `--dry-run` 标志确保 `ceph orch apply osd` 命令执行您想要的操作。 `--dry-run` 标志显示命令的结果，而不进行指定的更改。当确信该命令将执行所需的操作时，运行该命令时不要使用 `--dry-run` 标志。

> **Tip：**
>
> OSD Spec 的名称可以通过 `ceph orch ls` 命令检索。

或者，您可以使用 OSD Spec 文件：

```bash
ceph orch apply -i <osd_spec_file> --dry-run

NAME                  HOST  DATA     DB WAL
<name_of_osd_spec>    node1 /dev/vdb -  -
```

## 擦除设备 (Zapping Devices)

擦除（清除）一个设备以便它能被重用。 `zap` 在远程主机上调用 `ceph-volume zap` 。

```bash
ceph orch device zap <hostname> <path>

ceph orch device zap my_hostname /dev/sdx
```

> **Note：**
>
> 如果未设置 unmanaged 标志，cephadm 会自动部署与 OSD Spec 中的驱动器组匹配的驱动器。例如，如果您在创建 OSD 时使用 `all-available-devices` 选项，那么当您对一个设备执行 `zap` 操作时，cephadm  orchestrator 会自动在该设备中创建一个新的 OSD 。

## 激活现有 OSD

如果重新安装了主机的操作系统，则需要重新激活现有的 OSD 。对于这个用例，cephadm 为 activate 提供了一个 wrapper，用于激活主机上所有现有的 OSD 。

以下过程说明如何使用 `cephadm` 在重新安装了作系统的主机上激活 OSD。

此示例适用于两个主机：`ceph01` 和 `ceph04`。

- `ceph01` 是配备有管理员密钥环的主机。
- `ceph04` 是最近重新安装操作系统的主机。

1. 在主机上安装 `cephadm` 和 `podman`。安装这些实用程序的命令将取决于主机的作系统。

2. Retrieve the public key. 检索公钥。

   ```bash
   cd /tmp ; ceph cephadm get-pub-key > ceph.pub
   ```

3. 将密钥（从 `ceph01`）复制到新重新安装的主机 （`ceph04`）：

   ```bash
   ssh-copy-id -f -i ceph.pub root@<hostname>
   ```

4. Retrieve the private key in order to test the connection:
   检索私钥以测试连接：

   ```bash
   cd /tmp ; ceph config-key get mgr/cephadm/ssh_identity_key > ceph-private.key
   ```

5. 在 `ceph01` 上，修改 `ceph-private.key` 的权限：

   ```bash
   chmod 400 ceph-private.key
   ```

6. 从 `ceph01` 登录到 `ceph04` 以测试连接和配置：

   ```bash
   ssh -i /tmp/ceph-private.key ceph04
   ```

7. 登录到 `ceph01` 后，删除 `ceph.pub` 和 `ceph-private.key`：

   ```bash
   cd /tmp ; rm ceph.pub ceph-private.key
   ```

8. If you run your own container registry, instruct the orchestrator to log into it on each host:
   如果您运行自己的容器注册表，请指示编排器在每个主机上登录它：

   ```bash
   ceph cephadm registry-login my-registry.domain <user> <password>
   ```

   When the orchestrator performs the registry login, it will attempt to deploy any missing daemons to the host. This includes `crash`, `node-exporter`, and any other daemons that the host ran before its operating system was reinstalled.
   当 Orchestrator 执行注册表登录时，它将尝试将任何缺失的守护程序部署到主机。这包括 `crash`、`node-exporter` 以及主机在重新安装其作系统之前运行的任何其他守护进程。

   To be clea: `cephadm` attempts to deploy missing daemons to all hosts managed by cephadm, when `cephadm` determines that the hosts are online. In this context, “online” means “present in the output of the `ceph orch host ls` command and with a status that is not `offline` or `maintenance`. If it is necessary to log in to the registry in order to pull the images for the missing daemons, then deployment of the missing daemons will fail until the process of logging in to the registry has been completed.
   要成为 clea：`cephadm` 会尝试将缺失的守护进程部署到由 cephadm 管理的所有主机，当 `cephadm` 确定主机处于联机状态。在此上下文中，“online” 是指 “存在于 `Ceph Orch Host ls` 命令的输出中，并且状态为非`脱机`或`维护`。如果必须登录到注册表才能提取缺失守护程序的镜像，则缺失守护程序的部署将失败，直到登录到注册表的过程完成。

   Note 注意

   This step is not necessary if you do not run your own container registry. If your host is still in the “host list”, which can be retrieved by running the command `ceph orch host ls`, you do not need to run this command.
   如果您不运行自己的容器注册表，则无需执行此步骤。如果您的主机仍在“主机列表”中（可以通过运行命令 `ceph orch host ls` 来检索），则无需运行此命令。

9. 在最近重新安装了操作系统的主机上激活 OSD：

   ```bash
   ceph cephadm osd activate ceph04
   ```

   此命令使 `cephadm` 扫描所有现有磁盘以查找 OSD。此命令将使 `cephadm` 将任何缺失的守护进程部署到指定的主机。

*This procedure was developed by Eugen Block in Feburary of 2025, and a blog post pertinent to its development can be seen here:* [Eugen Block’s “Cephadm: Activate existing OSDs” blog post](https://heiterbiswolkig.blogs.nde.ag/2025/02/06/cephadm-activate-existing-osds/).
*该程序由 Eugen Block 于 2025 年 2 月开发，可以在此处查看与其开发相关的博客文章：*[Eugen Block 的“Cephadm：激活现有 OSD”博客文章](https://heiterbiswolkig.blogs.nde.ag/2025/02/06/cephadm-activate-existing-osds/)。

## 自动调整 OSD 内存

OSD 守护进程将根据 `osd_memory_target` 配置选项调整它们的内存消耗。如果 Ceph 部署在不与其他服务共享内存的专用节点上，cephadm 可以根据 RAM 总量和部署的 OSD 数量自动调整每个 OSD 的内存消耗。这允许充分利用可用内存，并在添加或删除 OSD 或 RAM 时进行调整。

> **注意：**
>
> 默认情况下，Cephadm 启用 `osd_memory_target_autotune` 。这通常不适用于融合架构，其中给定节点同时用于 Ceph 和计算目的。
>

此选项通过以下方式全局启用：

```bash
ceph config set osd osd_memory_target_autotune true
```

`Cephadm` will use a fraction `mgr/cephadm/autotune_memory_target_ratio` of available memory, subtracting memory consumed by non-autotuned daemons (non-OSDs and OSDs for which `osd_memory_target_autotune` is false), and then divide the balance by the number of OSDs.

Cephadm 将从系统总 RAM 的一小部分（`mgr/cephadm/autotune_memory_target_ratio`，默认为 `.7`）开始，减去非自动调优守护进程（非 OSD，对于 `osd_memory_target_autotune` 为 false 的  OSD）消耗的任何内存，然后除以剩余的 OSD。

在其他情况下，如果集群硬件不被 Ceph 专门使用（hyperconverged，超融合？），请减少 Ceph 的内存消耗，如下所示：

```bash
# hyperconverged only:
ceph config set mgr mgr/cephadm/autotune_memory_target_ratio 0.2
```

最终目标反映在配置数据库中，其中包含以下选项：

```bash
WHO   MASK      LEVEL   OPTION              VALUE
osd   host:foo  basic   osd_memory_target   126092301926
osd   host:bar  basic   osd_memory_target   6442450944
```

每个守护进程消耗的限制和当前内存都可以从 `ceph orch ps` 输出的 `MEM LIMIT` 列中看到：

```bash
NAME        HOST  PORTS  STATUS         REFRESHED  AGE  MEM USED  MEM LIMIT  VERSION                IMAGE ID      CONTAINER ID
osd.1       dael         running (3h)     10s ago   3h    72857k     117.4G  17.0.0-3781-gafaed750  7015fda3cd67  9e183363d39c
osd.2       dael         running (81m)    10s ago  81m    63989k     117.4G  17.0.0-3781-gafaed750  7015fda3cd67  1f0cc479b051
osd.3       dael         running (62m)    10s ago  62m    64071k     117.4G  17.0.0-3781-gafaed750  7015fda3cd67  ac5537492f27
```

要从内存自动调整中排除某个 OSD，请禁用该 OSD 的自动调整选项并设置特定的内存目标。例如，

```bash
ceph config set osd.123 osd_memory_target_autotune false
ceph config set osd.123 osd_memory_target 16G
```

`osd_memory_target` 参数计算如下：

```bash
osd_memory_target = TOTAL_RAM_OF_THE_OSD * (1048576) * (0.7)/ NUMBER_OF_OSDS_IN_THE_OSD_NODE
```

## 高级 OSD 服务规范

OSD 类型的服务规格是利用磁盘属性描述集群布局的一种方式。为用户提供一个抽象的方式，告知 Ceph 哪些磁盘应该转换成具有所需配置的 OSD，而不必知道设备名称和路径的具体细节。

服务规范使定义一个 yaml 或 json 文件用于减少创建 OSD 所涉及的手动工作量成为可能。

> 注意
>
> OSDs created using `ceph orch daemon add` or `ceph orch apply osd --all-available-devices` are placed in the plain `osd` service. Failing to include a `service_id` in your OSD spec causes the Ceph cluster to mix the OSDs from your spec with those OSDs, which can potentially result in the overwriting of service specs created by `cephadm` to track them. Newer versions of `cephadm` block OSD specs that do not include the `service_id`.
> 我们建议高级 OSD 规范包括 `service_id` 字段。使用 `ceph orch daemon OSD add`或 `ceph orch apply osd --all-available-devices` 放置在普通 `OSD` 服务中。未能在 OSD 规`service_id`中包含会导致 Ceph 集群将 Spec 中的 OSD 与这些 OSD 混合，这可能会导致 `cephadm` 为跟踪它们而创建的服务规约被覆盖。较新版本的 `cephadm` 块 OSD 规范不包含 `service_id`。

例如，替代运行以下命令：

```bash
ceph orch daemon add osd <host>:<path-to-device>
```

对于每个设备和每个主机，我们可以定义一个 yaml 或 json 文件来描述布局。这是最基本的例子。

创建一个示例文件 osd_spec.yml ：

```yaml
service_type: osd
service_id: default_drive_group  #osd spec 自定义名称
placement:
  host_pattern: '*'              #which hosts to target
spec:
  data_devices:                  #the type of devices you are applying specs to
    all: true                    #a filter, check below for a full list
```

这意味着：

1. 在所有符合 glob 模式 `*` 的主机上，将任何可用设备（ceph-volume 决定什么是“可用”）转换为OSD。（glob 模式与来自主机 ls 的注册主机相匹配）下面提供了关于主机模式的更详细部分。(The glob pattern matches against the registered hosts from host ls) There will be a more detailed section on host_pattern down below.（glob 模式与来自 host ls 的注册主机相匹配）下面提供了关于主机模式的更详细部分。

2. 然后将其传递给 osd create，如下所示：

   ```bash
   ceph orch apply -i /path/to/osd_spec.yml
   ```

   此指令将发布给所有匹配的主机，并将部署这些 OSD 。

   可以使用比 `all` 过滤器指定的策略更复杂的策略。

   可以将 `--dry-run` 标志传递给 `apply osd` 命令，以显示建议布局的概要。

**OSD 规格的一般设置**

- **service_type**: 'osd'：这是创建 OSDS 所必需的	

- **service_id** ：使用您首选的服务名称或身份识别。使用 规格文件创建一组 OSD。此名称用于将所有 OSD 一起管理并代表编排器服务。

- **placement** ：这用于定义需要在其上部署 OSD 的主机。

  您可以在以下选项中使用： 

  - **host_pattern**: '*' 

    用于选择主机的主机名模式。 						

  - **label**: 'osd_host'

    需要部署 OSD 的主机中使用的标签。 						

  - **hosts**: 'host01', 'host02'

    需要部署 OSD 的主机名的显式列表。 						

- **设备选择** ：创建 OSD 的设备。这样，可以将 OSD 与不同的设备分开。您只能创建具有三个组件的 BlueStore OSD： 				

  - OSD 数据：包含所有 OSD 数据 						
  - WAL: BlueStore 内部日志或 write-ahead Log 						
  - DB: BlueStore 内部元数据 						

- **data_devices** ：定义要部署 OSD 的设备。在这种情形中，OSD 在并置架构中创建。您可以使用过滤器来选择设备和文件夹。 				

- **wal_devices** ：定义用于 WAL OSD 的设备。您可以使用过滤器来选择设备和文件夹。 				

- **db_devices** ：定义用于 DB OSD 的设备。您可以使用过滤器来选择设备和文件夹。 				

- **加密** ：一个可选参数，用于加密 OSD 的信息，它可以设置为 `True` 或 `False` 				

- **Unmanaged**: 可选参数，默认设置为 False。如果您不希望 Orchestrator 管理 OSD 服务，您可以将其设置为 True。 				

- **block_wal_size** ：用户定义的值，以字节为单位。 				
- **block_db_size** ：用户定义的值，以字节为单位。 				

### 过滤器

> **Note：**
>
> 默认情况下，使用 AND作应用筛选条件。这意味着驱动器必须满足所有筛选条件才能被选中。可以通过在 OSD 规范中设置 `filter_logic:OR` 来调整此行为。

Filters are used to select sets of drives for OSD data or WAL+DB offload based on various attributes. 过滤器用于根据各种属性为 OSD 数据或 WAL+DB 卸载选择驱动器集。

这些属性基于 ceph-volume 的磁盘查询。可以使用以下命令检索有关属性的信息：

```bash
ceph-volume inventory </path/to/disk>
```

#### 供应商或型号

利用供应商品牌、制造商或型号（SKU）可以将特定磁盘作为目标：

```yaml
model: disk_model_name
```

或

```yaml
vendor: disk_vendor_name
```

#### 大小

特定磁盘可以按大小作为目标：

```yaml
size: size_spec
```

##### Size specs尺寸规格

尺寸规格可以采用以下形式：

- LOW:HIGH
- :HIGH
- LOW:
- EXACT

具体示例：

要包括精确大小的磁盘

```yaml
size: '10T'
```

请注意，驱动器容量通常不是确切的单元倍数，因此最佳做法通常是在大小范围内匹配驱动器，如下所示。这将处理同一类的未来驱动器，这些驱动器可能属于不同的型号，因此大小略有不同。或者假设现在有 10 TB 驱动器，但明年可能会增加 16 TB 驱动器：

```yaml
size: '10G:40G'
```

要匹配小于或等于 1701G 的磁盘

```yaml
size: ':1701G'
```

要包括等于或大于 666G 的磁盘

```yaml
size: '666G:'
```

支持单位：兆字节（M）、千兆字节（G）和兆字节（T）。还支持为字节追加（B）：MB、GB、TB。

#### Rotational 旋转

这基于每个驱动器的 'rotational' 属性，如内核所示。对于每个节点中安装的裸 HDD 和 SSD，此属性通常符合预期。Exotic or layered device presentations may however be reported differently than you might expect or desire:但是，异国情调或分层的设备演示的报告方式可能与您预期或希望的不同：

- Network-accessed SAN LUNs attached to the node
  连接到节点的网络访问 SAN LUN
- Composite devices presented by dCache, Bcache, OpenCAS, etc.
  由 dCache、Bcache、OpenCAS 等提供的复合设备。

The below rule was used for this purpose to override the `rotational` attribute on OSD nodes with no local physical drives and only attached SAN LUNs. It is not intended for deployment in all scenarios; you will have to determine what is right for your systems.  If by emplacing such a rule you summon eldritch horrors from beyond spacetime, that’s on you.
在这种情况下，可以通过添加 `udev` 规则来覆盖默认行为，从而使内核的报告与您的预期保持一致。以下规则用于此目的，用于覆盖没有本地物理驱动器且仅连接的 SAN LUN 的 OSD 节点上的 `rotational` 属性。它并非适用于所有方案中的部署。必须确定什么适合您的系统。如果通过制定这样的规则，你从时空之外召唤了可怕的恐怖，那你就有责任。

```bash
ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}="0"
ACTION=="add|change", KERNEL=="dm*", ATTR{queue/rotational}="0"
ACTION=="add|change", KERNEL=="nbd*", ATTR{queue/rotational}="0"
```

spec 文件语法：

```yaml
rotational: 0 | 1
```

* 1    以匹配所有旋转的磁盘。
* 0    以匹配所有非旋转磁盘（SATA 、NVMe SSD、SAN LUN 等）

#### All

这将匹配所有可用的驱动器，即它们没有分区、GPT 标签等。

> **Note:**
>
> 这只能为 `data_devices` 指定。

```yaml
all: true
```

#### 限制

如果您指定了一些有效的筛选器，但希望限制它们匹配的磁盘数量，请使用 `limit` 属性。当将某些驱动器用于非 Ceph 目的时，或者当需要多个 OSD 策略时，这非常有用。

```yaml
limit: 2
```

例如，如果您使用 vendor 匹配来自供应商 A 的所有磁盘，但希望仅使用前两个磁盘，则可以使用 `limit`：

```yaml
data_devices:
  vendor: VendorA
  limit: 2
```

> **Note:**
>
> 限制是最后的手段，如果可以避免，就不应该使用。`limit` 通常仅适用于某些特定场景。

**指定设备的过滤器**

过滤器与 `data_devices`、`wal_devices` 和 `db_devices` 参数搭配使用。 			

**注意：**

若要在同一主机上创建带有非并置组件的 OSD，您必须指定所使用的不同类型的设备，设备应位于同一主机上。 

`libstoragemgmt` 支持用于部署 OSD 的设备。 			

### 附加选项

可以使用多种可选设置来更改部署 OSD 的方式。可以将这些选项添加到 OSD 规范，使其生效。

此示例在所有未使用的驱动器上部署加密的 OSD。请注意，如果 Linux MD 镜像用于引导、`/var/log` 或其他卷，则此规范*可能会* 在将替换或添加的驱动器用于非 OSD 目的之前，请先获取它们。 `unmanaged` 属性可以设置为暂停自动部署，直到您准备就绪。

```yaml
service_type: osd
service_id: example_osd_spec
placement:
  host_pattern: '*'
spec:
  data_devices:
    all: true
  encrypted: true
```

Ceph Squid 及更高版本支持 LUKS2 设备的 TPM2 令牌注册。将 tpm2 属性添加到 OSD 规范中：

```yaml
service_type: osd
service_id: example_osd_spec_with_tpm2
placement:
  host_pattern: '*'
spec:
  data_devices:
    all: true
  encrypted: true
  tpm2: true
```

请参阅驱动器组规格中的完整列表

`class ceph.deployment.drive_group.DriveGroupSpec(placement=None, service_id=None, data_devices=None, db_devices=None, wal_devices=None, journal_devices=None, data_directories=None, osds_per_device=None, objectstore='bluestore', encrypted=False, db_slots=None, wal_slots=None, osd_id_claims=None, block_db_size=None, block_wal_size=None, journal_size=None, service_type=None, unmanaged=False, filter_logic='AND', preview_only=False, extra_container_args=None, extra_entrypoint_args=None, data_allocate_fraction=None, method=None, crush_device_class=None, config=None, custom_configs=Non)`

以 ceph-volume 理解的相同形式描述驱动器组。

* block_db_size: int | str | None

   设置（或覆盖）“bluestore_block_db_size” 的值，以字节为单位

- block_wal_size: int | str | None

  设置（或覆盖）“bluestore_block_wal_size” 的值，以字节为单位

- crush_device_class

  要分配给 OSD 的 Crush 设备类

- data_allocate_fraction

  Allocate a fraction of the data device (0,1.0] 分配数据设备的一小部分 （0,1.0]

- data_devices

  A `ceph.deployment.drive_group.DeviceSelection`

- data_directories

  字符串列表，包含应支持 OSD 的路径

- db_devices

  A `ceph.deployment.drive_group.DeviceSelection`

- db_slots

  每个 DB 设备有多少个 OSD

- encrypted

  加密 `true` / `false`

- filter_logic

  用来匹配 disk 的 filters 的 logic gate。默认为 'AND'

- journal_devices

  A `ceph.deployment.drive_group.DeviceSelection`

- journal_size: int | str | None

  以字节为单位设置 journal_size

- networks*: List[str]*

  A list of network identities instructing the daemons to only bind on the particular networks in that list. In case the cluster is distributed across multiple networks, you can add multiple networks. See [Networks and Ports](https://docs.ceph.com/en/latest/cephadm/services/monitoring/#cephadm-monitoring-networks-ports), [Specifying Networks](https://docs.ceph.com/en/latest/cephadm/services/rgw/#cephadm-rgw-networks) and [Specifying Networks](https://docs.ceph.com/en/latest/cephadm/services/mgr/#cephadm-mgr-networks). 

  一个网络身份列表，指示守护进程仅绑定 在该列表中的特定网络上。集群分布时 在多个网络中，您可以添加多个网络。看 [网络和端口](https://docs.ceph.com/en/latest/cephadm/services/monitoring/#cephadm-monitoring-networks-ports)， [指定网络](https://docs.ceph.com/en/latest/cephadm/services/rgw/#cephadm-rgw-networks)和[指定网络](https://docs.ceph.com/en/latest/cephadm/services/mgr/#cephadm-mgr-networks)。

- objectstore

  `filestore` / `bluestore`

- osd_id_claims

  Optional: mapping of host -> List of osd_ids that should be replaced See [OSD Replacement](https://docs.ceph.com/en/latest/mgr/orchestrator_modules/#orchestrator-osd-replace)

  可选： 主机映射 -> 应替换的osd_ids列表 请参阅 [OSD 替换](https://docs.ceph.com/en/latest/mgr/orchestrator_modules/#orchestrator-osd-replace)

- osds_per_device

  Number of osd daemons per “DATA” device. To fully utilize nvme devices multiple osds are required. Can be used to split dual-actuator devices across 2 OSDs, by setting the option to 2.

  每个 “DATA” 设备的 osd 守护进程数。要充分利用 nvme 设备，需要多个 osd 。通过将选项设置为 2 ，可用于在 2 个 OSD 上拆分双执行器设备。

- placement*: [PlacementSpec](https://docs.ceph.com/en/latest/mgr/orchestrator_modules/#ceph.deployment.service_spec.PlacementSpec)*

  请参见[守护程序放置](https://docs.ceph.com/en/latest/cephadm/services/#orchestrator-cli-placement-spec)。

- preview_only

  If this should be treated as a ‘preview’ spec 如果这应该被视为 'preview' 规范

- tpm2

   `true` / `false`

- wal_devices

  A `ceph.deployment.drive_group.DeviceSelection`

- wal_slots

  每个 WAL 设备有多少个 OSD

### 示例

#### 简单的案例

we wish to use them all as OSDs with offloaded WAL+DB:
当所有集群节点都有相同的驱动器，并且我们希望将它们全部用作具有卸载 WAL+DB 的 OSD 时：

```yaml
10 HDDs
Vendor: VendorA
Model: HDD-123-foo
Size: 4TB

2 SAS/SATA SSDs
Vendor: VendorB
Model: MC-55-44-ZX
Size: 512GB
```

这是一种常见的设置，可以很容易地描述：

```yaml
service_type: osd
service_id: osd_spec_default
placement:
  host_pattern: '*'
spec
  data_devices:
    model: HDD-123-foo   #note that HDD-123 would also be valid
  db_devices:
    model: MC-55-44-XZ   #same here, MC-55-44 is valid
```

但是，可以通过根据驱动器的属性而不是特定型号进行筛选来改进 OSD 规范，因为随着驱动器的更换或添加，型号可能会随着时间的推移而变化：

```yaml
service_type: osd
service_id: osd_spec_default
placement:
  host_pattern: '*'
spec:
  data_devices:
    rotational: 1
  db_devices:
    rotational: 0
```

Here designate all HDDs to be data devices (OSDs) and all SSDs to be used for WAL+DB offload.
在这里，将所有 HDD 指定为数据设备 （OSD），并将所有 SSD 用于 WAL+DB 卸载。

如果知道应始终将大于 2 TB 的驱动器用作数据设备，应始终将小于 2 TB 的驱动器用作 WAL/DB 设备，则可以按大小进行筛选：

```yaml
service_type: osd
service_id: osd_spec_default
placement:
  host_pattern: '*'
spec:
  data_devices:
    size: '2TB:'
  db_devices:
    size: ':2TB'
```

> **Note:**
>
> Which of those you want  to use depends on taste and on how much you expect your node layout to  change.
>
> 上述所有 OSD 规范均同等有效。您希望使用哪一种取决于您的口味，以及您希望节点布局更改的程度。

#### 单个主机的多种 OSD 规格

在这里，指定了两种不同的策略，用于跨多种类型的介质部署 OSD，通常由单独的存储池使用：

```yaml
10 HDDs
Vendor: VendorA
Model: HDD-123-foo
Size: 4TB

12 SAS/SATA SSDs
Vendor: VendorB
Model: MC-55-44-ZX
Size: 512GB

2 NVME SSDs
Vendor: VendorC
Model: NVME-QQQQ-987
Size: 256GB
```

- 10 HDD OSDs use 2 SATA/SAS SSDs for WAL+DB offload
  10 个 HDD OSD 使用 2 个 SATA/SAS SSD 进行 WAL+DB 卸载
- 10 SATA/SAS SSD OSDs share 2 NVMe SSDs for WAL+DB offload
  10 个 SATA/SAS SSD OSD 共享 2 个 NVMe SSD，用于 WAL+DB 卸载

这可以用两种布局来描述。

```yaml
service_type: osd
service_id: osd_spec_hdd
placement:
  host_pattern: '*'
spec:
  data_devices:             # Select all drives the kernel identifies as HDDs
    rotational: 1           #  for OSD data
  db_devices:
    model: MC-55-44-XZ      # Select only this model for WAL+DB offload
    limit: 2                # Select at most two for this purpose
  db_slots: 5               # Chop the DB device into this many slices and
                            #  use one for each of this many HDD OSDs
---
service_type: osd
service_id: osd_spec_ssd    # Unique so it doesn't overwrite the above
placement:
  host_pattern: '*'
spec:                       # This scenario is uncommon
  data_devices:
    model: MC-55-44-XZ      # Select drives of this model for OSD data
  db_devices:               # Select drives of this brand for WAL+DB. Since the
    vendor: VendorC         #   data devices are SAS/SATA SSDs this would make sense for NVMe SSDs
  db_slots: 2               # Back two slower SAS/SATA SSD data devices with each NVMe slice
```

这将通过使用所有 HDD 作为数据设备来创建所需的布局，其中两个 SATA/SAS SSD 分配为专用 DB/WAL 设备，每个 SSD 支持五个 HDD OSD。其余十个 SAS/SATA SSD 将用作 OSD 数据设备，`VendorC` NVMEs SSD 分配为专用 DB/WAL 设备，每个设备为两个 SAS/SATA OSD 提供服务。We call these _hybrid OSDs.我们称这些 _hybrid OSD。

#### 具有相同磁盘布局的多个主机

When a cluster comprises hosts with different drive layouts, or a complex constellation of multiple media types, it is recommended to apply multiple OSD specs, each matching only one set of hosts. Typically you will have a single spec for each type of host.
当群集包含具有不同驱动器布局的主机或具有多种介质类型的复杂星座时，建议应用多个 OSD 规范，每个规范仅匹配一组主机。通常，每种类型的主机都有一个 spec。

The `service_id` must be unique: if a new OSD spec with an already applied `service_id` is applied, the existing OSD spec will be superseded. Cephadm will then create new OSD daemons on unused drives based on the new spec definition. Existing OSD daemons will not be affected. See [Declarative State](https://docs.ceph.com/en/latest/cephadm/services/osd/#cephadm-osd-declarative).
`service_id` 必须是唯一的：如果应用了已应用`service_id`的新 OSD 规范，则现有 OSD 规范将被取代。然后，Cephadm 将根据新的规范定义在未使用的驱动器上创建新的 OSD 守护进程。现有的 OSD 守护进程不会受到影响。请参见 [Declarative State](https://docs.ceph.com/en/latest/cephadm/services/osd/#cephadm-osd-declarative)。

Node 1-5

```yaml
20 HDDs
Vendor: 
Model: SSD-123-foo
Size: 4TB
2 SSDs
Vendor: VendorB
Model: MC-55-44-ZX
Size: 512GB
```

Node 6-10

```yaml
5 NVMEs
Vendor: VendorA
Model: SSD-123-foo
Size: 4TB
20 SSDs
Vendor: VendorB
Model: MC-55-44-ZX
Size: 512GB
```

您可以使用布局中的 “ placement” 键以特定节点为目标。

```yaml
service_type: osd
service_id: disk_layout_a
placement:
  label: disk_layout_a
spec:
  data_devices:
    rotational: 1           # All drives identified as HDDs
  db_devices:
    rotational: 0           # All drives identified as SSDs
---
service_type: osd
service_id: disk_layout_b
placement:
  label: disk_layout_b
spec:
  data_devices:
    model: MC-55-44-XZ      # Only this model
  db_devices:
    model: SSD-123-foo      # Only this model
```

这会将不同的 OSD 规范应用于通过 `placement` 筛选条件匹配使用 `ceph orch` 标签标记的主机的不同主机。

> **Note:**
>
> Assuming each host has a unique disk layout, each OSD spec needs to have a different service id
>
> 假设每个主机都有唯一的磁盘布局，每个 OSD 规范都需要有不同的 `dervice_id` 。

#### 专用 WAL + DB

所有以前的案例都将 WAL 与 DB 放在一起。然而，如果可行，也可以在专用设备上部署 WAL。

```yaml
20 HDDs
Vendor: VendorA
Model: SSD-123-foo
Size: 4TB

2 SAS/SATA SSDs
Vendor: VendorB
Model: MC-55-44-ZX
Size: 512GB

2 NVME SSDs
Vendor: VendorC
Model: NVME-QQQQ-987
Size: 256GB
```

这种情况下的 OSD 规格如下（使用 model 过滤器）

```yaml
service_type: osd
service_id: osd_spec_default
placement:
  host_pattern: '*'
spec:
  data_devices:
    model: MC-55-44-XZ
  db_devices:
    model: SSD-123-foo
  wal_devices:
    model: NVME-QQQQ-987
```

还可以按如下所示指定设备路径，此时每个匹配的主机都应以相同的方式显示设备。

```yaml
service_type: osd
service_id: osd_using_paths
placement:
  hosts:
    - Node01
    - Node02
spec:
  data_devices:
    paths:
    - /dev/sdb
  db_devices:
    paths:
    - /dev/sdc
  wal_devices:
    paths:
    - /dev/sdd
```

这可以很容易地与其他过滤器一起完成，如尺寸或供应商。

In most cases it is preferable to accomplish this with other filters including `size` or `vendor` so that OSD services adapt when Linux or an HBA may enumerate devices differently across boots, or when drives are added or replaced.
在大多数情况下，最好使用其他过滤器（包括`大小`或`供应商`）来实现这一点，这样当 Linux 或 HBA 可能在引导之间以不同的方式枚举设备时，或者当添加或更换驱动器时，OSD 服务就会适应。

It is possible to specify a `crush_device_class` parameter to be applied to OSDs created on devices matched by the `paths` filter:
可以指定要应用于在与 `paths` 过滤器匹配的设备上创建的 OSD 的 `crush_device_class` 参数：

```yaml
service_type: osd
service_id: osd_using_paths
placement:
  hosts:
    - node01
    - node02
crush_device_class: ssd
spec:
  data_devices:
    paths:
    - /dev/sdb
    - /dev/sdc
  db_devices:
    paths:
    - /dev/sdd
  wal_devices:
    paths:
    - /dev/sde
```

The `crush_device_class` attribute may be specified at OSD granularity via the `paths` keyword with the following syntax:
`crush_device_class` 属性可以通过 `paths` 关键字以 OSD 粒度指定，语法如下：

```yaml
service_type: osd
service_id: osd_using_paths
placement:
  hosts:
    - node01
    - node02
crush_device_class: ssd
spec:
  data_devices:
    paths:
    - path: /dev/sdb
      crush_device_class: ssd
    - path: /dev/sdc
      crush_device_class: nvme
  db_devices:
    paths:
    - /dev/sdd
  wal_devices:
    paths:
    - /dev/sde
```

## other

Ceph 生产集群通常部署 Ceph OSD 守护程序，one node has one OSD daemon running a Filestore on one storage device其中一个节点有一个 OSD 守护程序在一个存储设备上运行文件存储。BlueStore 后端现在是默认的，但在使用 Filestore 时，需要指定日志大小。例如：

```ini
[osd]
osd_journal_size = 10000

[osd.0]
host = {hostname} #manual deployments only.
```

默认情况下，Ceph 希望在以下路径存储 Ceph OSD 守护程序的数据：

```bash
/var/lib/ceph/osd/$cluster-$id
```

You or a deployment tool (e.g., `cephadm`) must create the corresponding directory. With metavariables fully expressed and a cluster named “ceph”, this example would evaluate to:您或部署工具（例如cephadm）必须创建相应的目录。使用完全表达的元变量和名为“ceph”的集群，此示例的计算结果如下：

```bash
/var/lib/ceph/osd/ceph-0
```

You may override this path using the `osd_data` setting. We recommend not changing the default location. Create the default directory on your OSD host.您可以使用osd数据设置覆盖此路径。建议不要更改默认位置。在OSD主机上创建默认目录。

```bash
ssh {osd-host}
sudo mkdir /var/lib/ceph/osd/ceph-{osd-number}
```

The `osd_data` path ideally leads to a mount point with a device that is separate from the device that contains the operating system and daemons. If an OSD is to use a device other than the OS device, prepare it for use with Ceph, and mount it to the directory you just created

理想情况下，osd数据路径通向一个装载点，该装载点的设备与包含操作系统和守护程序的设备分离。如果OSD要使用OS设备以外的设备，请准备好与Ceph一起使用，并将其安装到您刚刚创建的目录中

```bash
ssh {new-osd-host}
sudo mkfs -t {fstype} /dev/{disk}
sudo mount -o user_xattr /dev/{hdd} /var/lib/ceph/osd/ceph-{osd-number}
```

建议在运行 mkfs 时使用 xfs 文件系统。（不建议使用  btrfs 和 ext4，并且不再进行测试。）

## Pools

存储池是一种抽象，可以指定为 “replicated” 或 “erasure coded” 。在 Ceph 中，数据保护方法在存储池级别设置。Ceph  提供并支持两种类型的数据保护：复制和纠删码。对象存储在池中。“存储池是存储卷的集合。存储卷是基本的存储单位，例如在磁盘或单个盒式磁带上分配的空间。服务器使用存储卷来存储备份、存档或空间管理的文件。
