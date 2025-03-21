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

`ceph-volume` 不时扫描集群中的每个主机，以确定存在哪些设备以及这些设备是否有资格用作 OSD 。

显示所有群集主机上存储设备的资源清册：

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

在上面的示例中，您可以看到名为 “Health”、“Ident” 和 “Fault” 的字段。此信息是通过与 libstoragemgmt 集成提供的。默认情况下，此集成处于禁用状态（因为 libstoragemgmt 可能与您的硬件不完全兼容）。要使 cephadm 包含这些字段，启用 cephadm 的 “enhanced device scan” 选项。

```bash
ceph config set mgr mgr/cephadm/device_enhanced_scan true
```

> **Warning**
>
> 尽管 libstoragemgmt 库执行标准的 SCSI 查询调用，但不能保证固件完全实现这些标准。可能导致不稳定的行为，甚至在一些旧硬件上 bus resets 。因此，建议您在启用此功能之前，首先测试硬件与 libstoragemgmt 的兼容性，以避免对服务的意外中断。
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
> 当前版本的 libstoragemgmt（1.8.8）仅支持基于 SCSI、SAS 和 SATA 的本地磁盘。没有对 NVMe 设备（PCIe）的官方支持。

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

## 部署 OSD

### 创建新的 OSD

多种方式：

- 告诉 Ceph 使用任何可用和未使用的存储设备：

  ```bash
  ceph orch apply osd --all-available-devices
  ```

  这将消耗 `Ceph` 集群中通过所有安全检查的任何主机上的任何设备（`HDD` 或 `SSD`），这意味着没有分区、没有 `LVM` 卷、没有文件系统等。每个设备将部署一个 `OSD`，这是适用于大多数用户的最简单情况。

- 从特定主机上的特定设备创建 OSD：

  ```bash
  ceph orch daemon add osd <host>:<device-path>
  
  ceph orch daemon add osd host1:/dev/sdb
  ```

  从特定主机上的特定设备创建高级 OSD：

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

如要禁用在可用设备上自动创建OSD ，请使用 unmanaged 参数：

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
ceph orch osd rm <osd_id(s)> [--replace] [--force]
# eg:
ceph orch osd rm 0
Scheduled OSD(s) for removal
# 批量删除脚本
for osd_id in $(ceph orch ps --host HOST_NAME --service_type osd) ; do ceph orch osd rm OSD_ID ; done
```

无法安全销毁的 OSD 将被拒绝。

### 监控 OSD 状态

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
ceph orch osd rm stop <svc_id(s)>

ceph orch osd rm stop 4
Stopped OSD(s) removal
```

这将重置 OSD 的初始状态并将其从删除队列中移除。

## 替换 OSD

可以使用 `ceph orch rm` 命令保留 OSD ID，以替换集群中的 OSD。这与“删除 OSD ”部分中的过程相同，但有一个例外：OSD 不会永久从 CRUSH 层次结构中移除，而是被分配有 `destroy` 标志。此标志用于确定可在下一次 OSD 部署中重复使用的 OSD ID。"destroyed"标志用于决定在下一次 OSD 部署中重复使用哪些 OSD ID。 		

如果使用 OSD 规格进行部署，则会为新添加的磁盘分配其替换的对等点的 OSD ID。

```bash
orch orch osd rm <svc_id(s)> --replace [--force]

ceph orch osd rm 4 --replace
Scheduled OSD(s) for replacement
```

> Note
>
> The new OSD that will replace the removed OSD must be created on the same host as the OSD that was removed.
>
> 必须在与删除的 OSD 相同的主机上创建将替换删除的 OSD 的新 OSD 。

**保留 OSD ID**

“destroyed” 标志用于确定下一个 OSD 部署中将重用哪些 OSD id。

如果将 OSD Specs 用于 OSD 部署，则新添加的磁盘将被分配其替换的对应磁盘的 OSD id 。这假设新磁盘仍然与 OSD Specs 匹配。

使用 `--dry-run` 标志确保 `ceph orch apply osd` 命令执行您想要的操作。 `--dry-run` 标志显示命令的结果，而不进行指定的更改。当您确信该命令将执行所需的操作时，运行该命令时不要使用 `--dry-run` 标志。

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

```bash
ceph cephadm osd activate <host>...
```

这将扫描所有 OSD 的现有磁盘，并部署相应的守护进程。

## 自动调整 OSD 内存

OSD 守护进程将根据 `osd_memory_target` 配置选项（默认为几 GB）调整它们的内存消耗。如果 Ceph 部署在不与其他服务共享内存的专用节点上，cephadm 可以根据 RAM 总量和部署的 OSD 数量自动调整每个 OSD 的内存消耗。

> **注意：**
>
> 默认情况下，Cephadm 在引导时启用 `osd_memory_target_autotune` 。这不适用于超融合基础架构。
>

此选项通过以下方式全局启用：

```bash
ceph config set osd osd_memory_target_autotune true
```

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

   Setups more complex than the one specified by the `all` filter are possible.设置可能比all筛选器指定的设置更复杂。

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
> Filters are applied using a AND gate by default. 默认情况下，使用与门应用过滤器。这意味着驱动器必须满足所有筛选条件才能被选中。可以通过在 OSD 规范中设置 `filter_logic: OR` 来调整此行为。

过滤器用于将磁盘分配给组，并使用其属性对其进行分组。

这些属性基于 ceph-volume 的磁盘查询。可以使用以下命令检索有关属性的信息：

```bash
ceph-volume inventory </path/to/disk>
```

#### 供应商或型号

利用供应商或型号可以将特定磁盘作为目标：

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

##### Size specs

尺寸规格可以采用以下形式：

- LOW:HIGH
- :HIGH
- LOW:
- EXACT

具体示例：

要包括精确大小的磁盘

```yaml
size: '10G'
```

要包括给定大小范围内的磁盘

```yaml
size: '10G:40G'
```

要包括大小小于或等于 10G 的磁盘

```yaml
size: ':10G'
```

要包括大小等于或大于 40G 的磁盘

```yaml
size: '40G:'
```

大小不必仅以千兆字节（G）为单位指定。

支持其他大小单位：兆字节（M）、千兆字节（G）和兆字节（T）。还支持为字节追加（B）：MB、GB、TB。

#### Rotational 旋转

这对磁盘的“旋转”属性进行操作。

```yaml
rotational: 0 | 1
```

* 1    以匹配所有旋转的磁盘。
* 0    以匹配所有非旋转磁盘（SSD、NVME 等）

#### All

This will take all disks that are ‘available’。这将占用所有“可用”的磁盘。

> **Note:**
>
> This is exclusive for the data_devices section.这是数据设备部分专用的。

```yaml
all: true
```

#### 限制

如果您指定了一些有效的筛选器，但希望限制它们匹配的磁盘数量，请使用 `limit` 指令：

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
> 限制是最后的手段，如果可以避免，就不应该使用。

**指定设备的过滤器**

过滤器与 `data_devices`、`wal_devices` 和 `db_devices` 参数搭配使用。 			

**注意：**

若要在同一主机上创建带有非并置组件的 OSD，您必须指定所使用的不同类型的设备，设备应位于同一主机上。 

`libstoragemgmt` 支持用于部署 OSD 的设备。 			

### 附加选项

可以使用多种可选设置来更改部署 OSD 的方式。可以将这些选项添加到 OSD 规范的基本级别，使其生效。 to the base level of a OSD spec for it to take effect.

此示例将部署所有启用加密的 OSD 。

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

请参阅驱动器组规格中的完整列表

`class ceph.deployment.drive_group.DriveGroupSpec(placement=None, service_id=None, data_devices=None, db_devices=None, wal_devices=None, journal_devices=None, data_directories=None, osds_per_device=None, objectstore='bluestore', encrypted=False, db_slots=None, wal_slots=None, osd_id_claims=None, block_db_size=None, block_wal_size=None, journal_size=None, service_type=None, unmanaged=False, filter_logic='AND', preview_only=False, extra_container_args=None, extra_entrypoint_args=None, data_allocate_fraction=None, method=None, crush_device_class=None, config=None, custom_configs=Non)`

以 ceph-volume 理解的相同形式描述驱动器组。

* block_db_size*: Optional[Union[int, str]]*

   设置（或覆盖）“bluestore_block_db_size” 的值，以字节为单位

- block_wal_size*: Optional[Union[int, str]]*

  设置（或覆盖）“bluestore_block_wal_size” 的值，以字节为单位

- crush_device_class

  Crush device class to assign to OSDs

- data_allocate_fraction

  Allocate a fraction of the data device (0,1.0]

- data_devices

  A `ceph.deployment.drive_group.DeviceSelection`

- data_directories

  A list of strings, containing paths which should back OSDs

- db_devices

  A `ceph.deployment.drive_group.DeviceSelection`

- db_slots

  每个DB设备有多少个OSD

- encrypted

  `true` / `false`

- filter_logic

  The logic gate we use to match disks with filters. defaults to ‘AND’

- journal_devices

  A `ceph.deployment.drive_group.DeviceSelection`

- journal_size*: Optional[Union[int, str]]*

  set journal_size in bytes

- objectstore

  `filestore` / `bluestore`

- osd_id_claims

  Optional: mapping of host -> List of osd_ids that should be replaced See [OSD Replacement](https://docs.ceph.com/en/latest/mgr/orchestrator_modules/#orchestrator-osd-replace)

- osds_per_device

  Number of osd daemons per “DATA” device. To fully utilize nvme devices multiple osds are required. Can be used to split dual-actuator devices across 2 OSDs, by setting the option to 2.

  每个“DATA”设备的osd守护进程数。要充分利用nvme设备，需要多个osd。通过将选项设置为2，可用于在2个OSD上拆分双执行器设备。

- preview_only

  If this should be treated as a ‘preview’ spec

- wal_devices

  A `ceph.deployment.drive_group.DeviceSelection`

- wal_slots

  How many OSDs per WAL device

### 示例

#### 简单的案例

所有节点具有相同的设置

```yaml
20 HDDs
Vendor: VendorA
Model: HDD-123-foo
Size: 4TB

2 SSDs
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

但是，可以通过减少对驱动器核心属性的过滤来改进它：

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

现在，我们强制所有旋转设备声明为“数据设备”，所有非旋转设备将用作共享设备（wal，db）

If you know that drives with more than 2TB will always be the slower data devices, you can also filter by size:如果您知道2TB以上的驱动器总是速度较慢的数据设备，您还可以按大小进行筛选：

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

这里有两种不同的设置

```yaml
20 HDDs
Vendor: VendorA
Model: HDD-123-foo
Size: 4TB

12 SSDs
Vendor: VendorB
Model: MC-55-44-ZX
Size: 512GB

2 NVMEs
Vendor: VendorC
Model: NVME-QQQQ-987
Size: 256GB
```

- 20 HDDs should share 2 SSDs
- 10 SSDs should share 2 NVMes

这可以用两种布局来描述。

```yaml
service_type: osd
service_id: osd_spec_hdd
placement:
  host_pattern: '*'
spec:
  data_devices:
    rotational: 1
  db_devices:
    model: MC-55-44-XZ
    limit: 2             #db_slots is actually to be favoured here, but it's not implemented yet
---
service_type: osd
service_id: osd_spec_ssd
placement:
  host_pattern: '*'
spec:
  data_devices:
    model: MC-55-44-XZ
  db_devices:
    vendor: VendorC
```

这将通过将所有 HDD 用作数据设备，并将两个 SSD 指定为专用 db / wal 设备，从而创建所需的布局。剩余的SSD（10）将是数据设备，其 “VendorC” NVME 分配为专用 db / wal 设备。

#### 具有相同磁盘布局的多个主机

假设集群有不同类型的主机，每个主机都具有相似的磁盘布局，建议应用仅与一组主机匹配的不同 OSD 规格。it is recommended to apply different OSD specs matching only one set of hosts. 通常，您将为具有相同布局的多个主机创建规范。

服务 id 作为唯一密钥：如果应用了具有已应用服务 id 的新 OSD 规范，则现有 OSD 规范将被取代。cephadm 现在将根据新的规范定义创建新的 OSD 守护进程。现有的 OSD 守护程序不会受到影响。

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
    rotational: 1
  db_devices:
    rotational: 0
---
service_type: osd
service_id: disk_layout_b
placement:
  label: disk_layout_b
spec:
  data_devices:
    model: MC-55-44-XZ
  db_devices:
    model: SSD-123-foo
```

这会根据放置键将不同的 OSD 规格应用于不同的主机。

> **Note:**
>
> Assuming each host has a unique disk layout, each OSD spec needs to have a different service id
>
> 假设每个主机都有唯一的磁盘布局，每个OSD规范都需要有不同的服务id

#### 专用 wal + db

所有以前的案例都将 WAL 与 DB 放在一起。然而，如果可行，也可以在专用设备上部署 WAL。

```yaml
20 HDDs
Vendor: VendorA
Model: SSD-123-foo
Size: 4TB

2 SSDs
Vendor: VendorB
Model: MC-55-44-ZX
Size: 512GB

2 NVMEs
Vendor: VendorC
Model: NVME-QQQQ-987
Size: 256GB
```

这种情况下的 OSD 规格如下（使用模型过滤器） (using the model filter)

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

还可以直接指定特定主机中的设备路径，如下所示：

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
