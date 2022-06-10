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
- 设备不能包含 Ceph BlueStore OSD。
- 设备必须大于5 GB。

Ceph不会在不可用的设备上提供OSD。

## OSD 后端

Prior to the  release, the default (and only option) was *Filestore*.

OSD 有两种方式管理其存储的数据。Luminous 12.2.z 版本以后，默认（推荐）后端是 BlueStore 。在 Luminous 版本之前，默认（也是唯一的选项）是 Filestore 。

### BlueStore

是一种特殊用途的存储后端，专门为 Ceph OSD workloads 管理磁盘上的数据而设计。BlueStore 的设计基于（a decade of experience of supporting and managing Filestore OSDs）十年来支持和管理文件存储 OSD 的经验。

主要功能包括：

* 直接管理存储设备。BlueStore consumes raw block devices or partitions. BlueStore 使用原始块设备或分区。这避免了可能限制性能或增加复杂性的中间抽象层（如 XFS 之类的本地文件系统）。
* 使用RocksDB进行元数据管理。RocksDB 的键/值数据库被嵌入以管理内部元数据，包括对象名称到磁盘上块的位置的映射。
* 完整数据和元数据校验和。默认情况下，写入 BlueStore 的所有数据和元数据都受一个或多个校验和的保护。未经验证，不会从磁盘读取任何数据或元数据，也不会将其返回给用户。
* Inline compression内联压缩。数据可以在写入磁盘之前进行选择性压缩。
* Multi-device metadata tiering多设备元数据分层。BlueStore 允许将其内部日志（预写日志）写入单独的高速设备（如 SSD、NVMe 或 NVDIMM），以提高性能。如果有大量更快的存储可用，则可以在更快的设备上存储内部元数据。
* 高效的写时拷贝。RBD 和 CephFS 快照依赖于在 BlueStore 中高效实现的写时拷贝克隆机制。This results in efficient I/O both for regular snapshots and for erasure-coded pools (which rely on cloning to implement efficient two-phase commits).这将为常规快照和擦除编码池（依靠克隆实现高效的两阶段提交）带来高效的 I/O。

### FileStore

FileStore 是在 Ceph 中存储对象的传统方法。它依赖于一个标准文件系统（通常是 XFS ）和一个键/值数据库（传统上是级别 LevelDB，现在是 RocksDB ）来获取一些元数据。

FileStore 经过良好测试，并在生产中广泛使用。然而，it suffers from many performance deficiencies due to its overall design and its reliance on a traditional file system for object data storage.由于其总体设计和对对象数据存储的传统文件系统的依赖，它存在许多性能缺陷。

尽管 FileStore 能够在大多数 POSIX 兼容的文件系统（包括 btrfs 和 ext4 ）上运行，但我们建议仅将 XFS 文件系统用于 Ceph 。btrfs 和 ext4 都有已知的 bug 和缺陷，使用它们可能会导致数据丢失。默认情况下，所有 Ceph 资源调配工具都使用 XFS 。

## 列出设备

`ceph-volume` 不时扫描集群中的每个主机，以确定存在哪些设备以及这些设备是否有资格用作 OSD 。

打印设备列表：

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

> Note
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

  这将消耗`Ceph`集群中通过所有安全检查的任何主机上的任何设备（`HDD`或`SSD`），这意味着没有分区、没有`LVM`卷、没有文件系统等。每个设备将部署一个`OSD`，这是适用于大多数用户的最简单情况。

- 从特定主机上的特定设备创建 OSD：

  ```bash
  ceph orch daemon add osd <host>:<device-path>
  
  ceph orch daemon add osd host1:/dev/sdb
  ```

  Advanced OSD creation from specific devices on a specific host:

  ```bash
  ceph orch daemon add osd host1:data_devices=/dev/sda,/dev/sdb,db_devices=/dev/sdc,osds_per_device=2
  ```

- 使用 [Advanced OSD Service Specifications](https://docs.ceph.com/en/latest/cephadm/osd/#drivegroups) 根据设备的属性对设备进行分类。这可能有助于更清楚地了解哪些设备可以使用。属性包括设备类型（SSD或HDD）、设备型号名称、大小以及设备所在的主机：

  ```bash
  ceph orch apply -i spec.yml
  ```

### Dry Run 试运行

`--dry-run` 标志使 orchestrator 在不实际创建 OSD 的情况下呈现将要发生的事情的预览。

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
> - 设置 `unmanaged: True` 将禁用 OSD 的创建。如果设置了 `unmanaged: True` ，即使应用新的OSD 服务，也不会发生任何事情。
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

> Note
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

ceph orch osd rm 0 --replace
Scheduled OSD(s) for replacement
```

> Note
>
> The new OSD that will replace the removed OSD must be created on the same host as the OSD that was removed.

**保留 OSD ID**

“destroyed” 标志用于确定下一个 OSD 部署中将重用哪些 OSD id。

如果将 OSDSpecs 用于 OSD 部署，则新添加的磁盘将被分配其替换的对应磁盘的 OSD id 。这假设新磁盘仍然与 OSDSpecs 匹配。

使用 `--dry-run` 标志确保 `ceph orch apply osd` 命令执行您想要的操作。 `--dry-run` 标志显示命令的结果，而不进行指定的更改。当您确信该命令将执行所需的操作时，运行该命令时不要使用 `--dry-run` 标志。

> Tip
>
> OSDSpec 的名称可以通过 `ceph orch ls`命令检索。

或者，您可以使用OSDSpec文件：

```bash
ceph orch apply osd -i <osd_spec_file> --dry-run

NAME                  HOST  DATA     DB WAL
<name_of_osd_spec>    node1 /dev/vdb -  -
```

## 擦除设备 (Zapping Devices)

擦除（清除）一个设备以便它能被重用。 `zap` 在远程主机上调用 `ceph-volume zap` 。

```bash
ceph orch device zap <hostname> <path>

ceph orch device zap my_hostname /dev/sdx
```

> Note
>
> 如果未设置unmanaged标志，cephadm会自动部署与 OSDSpec 中的驱动器组匹配的驱动器。例如，如果您在创建OSD时使用 `all-available-devices` 选项，那么当您对一个设备执行 `zap` 操作时，cephadm  orchestrator 会自动在该设备中创建一个新的 OSD 。

## 激活现有 OSD

如果重新安装了主机的操作系统，则需要重新激活现有的 OSD 。对于这个用例，cephadm为 activate 提供了一个 wrapper，用于激活主机上所有现有的 OSD 。

```bash
ceph cephadm osd activate <host>...
```

这将扫描所有 OSD 的现有磁盘，并部署相应的守护进程。

## 自动调整OSD内存

OSD 守护进程将根据 `osd_memory_target` 配置选项（默认为几 GB）调整它们的内存消耗。如果 Ceph 部署在不与其他服务共享内存的专用节点上，cephadm 可以根据 RAM 总量和部署的 OSD 数量自动调整每个 OSD 的内存消耗。

> Warning
>
> Cephadm sets `osd_memory_target_autotune` to `true` by default which is unsuitable for hyperconverged infrastructures.

此选项通过以下方式全局启用：

```bash
ceph config set osd osd_memory_target_autotune true
```

Cephadm 将从系统总 RAM 的一小部分（`mgr/cephadm/autotune_memory_target_ratio`，默认为 `.7`）开始，减去非自动调优守护进程（非 OSD，对于 `osd_memory_target_autotune` 为 false 的  OSD）消耗的任何内存，然后除以剩余的 OSD。

最终目标反映在配置数据库中，其中包含以下选项：

```bash
WHO   MASK      LEVEL   OPTION              VALUE
osd   host:foo  basic   osd_memory_target   126092301926
osd   host:bar  basic   osd_memory_target   6442450944
```

每个守护进程消耗的限制和当前内存都可以从 `ceph orch ps` 输出的 MEM LIMIT 列中看到：

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

## 高级OSD服务规范

OSD 类型的服务规格是利用磁盘属性描述集群布局的一种方式。为用户提供一个抽象的方式，告知 Ceph 哪些磁盘应该转换成具有所需配置的 OSD，而不必知道设备名称和路径的具体细节。对于每个设备和每个主机，定义一个 `yaml` 文件或一个 `json` 文件。 		

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

**指定设备的过滤器**

过滤器与 `data_devices、wal_devices 和 db_devices 参数` 搭配使用。 			

| 过滤器的名称 | 描述                                                         | 语法                       | 示例              |
| ------------ | ------------------------------------------------------------ | -------------------------- | ----------------- |
| Model        | 目标特定磁盘.您可以通过运行 `lsblk -o NAME,FSTYPE,LABEL,MOUNTPOINT,SIZE,MODEL` 命令或 `smartctl -i /*DEVIVE_PATH*`获取模型详情 | Model： *DISK_MODEL_NAME*  | 型号：MC-55-44-XZ |
| vendor       | 目标特定磁盘                                                 | vendor: *DISK_VENDOR_NAME* | 供应商：供应商 C  |
| 大小规格     | 包括具有准确大小的磁盘                                       | 大小： *EXACT*             | 大小："10G"       |
| 大小规格     | 包括 的磁盘大小，其位于范围内                                | 大小： *LOW:HIGH*          | 大小："10G:40G"   |
| 大小规格     | 包括小于或等于大小的磁盘                                     | 大小 *::HIGH*              | 大小：':10G'      |
| 大小规格     | 包括等于或大于大小的磁盘                                     | 大小： *LOW:*              | 大小："40G:'      |
| rotational   | 磁盘的轮转属性。1 匹配所有旋转磁盘，0 匹配所有非轮转磁盘。如果轮转 =1，则 OSD 配置为使用 SSD 或 NVME。如果轮转=0，则 OSD 配置为使用 HDD。 | 轮转：0 或 1               | rotational: 0     |
| All          | 考虑所有可用的磁盘                                           | All: true                  | All: true         |
| limiter      | 当您指定有效过滤器但希望限制匹配磁盘的数量时，您可以使用"limit"指令。仅应作为最后的手段使用。 | limit: *NUMBER*            | 限制：2           |

**注意：**

若要在同一主机上创建带有非并置组件的 OSD，您必须指定所使用的不同类型的设备，设备应位于同一主机上。 			

`libstoragemgmt` 支持用于部署 OSD 的设备。 			

[Service Specification](https://docs.ceph.com/en/latest/cephadm/service-management/#orchestrator-cli-service-spec) of type `osd` are a way to describe a cluster layout using the properties of disks. It gives the user an abstract way tell ceph which disks should turn into an OSD with which configuration without knowing the specifics of device names and paths.

Instead of doing this

```
ceph orch daemon add osd <host>:<path-to-device>
```

for each device and each host, we can define a yaml|json file that allows us to describe the layout. Here’s the most basic example.

Create a file called i.e. osd_spec.yml

```yaml
service_type: osd
service_id: default_drive_group  #name of the drive_group (name can be custom)
placement:
  host_pattern: '*'              #which hosts to target, currently only supports globs
spec:
  data_devices:                  #the type of devices you are applying specs to
    all: true                    #a filter, check below for a full list
```

This would translate to:

Turn any available(ceph-volume decides what ‘available’ is) into an OSD on all hosts that match the glob pattern ‘*’. (The glob pattern matches against the registered hosts from host ls) There will be a more detailed section on host_pattern down below.

and pass it to osd create like so

```bash
ceph orch apply osd -i /path/to/osd_spec.yml
```

This will go out on all the matching hosts and deploy these OSDs.

Since we want to have more complex setups, there are more filters than just the ‘all’ filter.

Also, there is a –dry-run flag that can be passed to the apply osd command, which gives you a synopsis of the proposed layout.

例如：

```bash
ceph orch apply -i /path/to/osd_spec.yml --dry-run
```

### Filters

> Note
>
> Filters are applied using a AND gate by default. This essentially means that a drive needs to fulfill all filter criteria in order to get selected. If you wish to change this behavior you can adjust this behavior by setting `filter_logic: OR`  # valid arguments are AND, OR in the OSD Specification.

You can assign disks to certain groups by their attributes using filters.

The attributes are based off of ceph-volume’s disk query. You can retrieve the information with

```
ceph-volume inventory </path/to/disk>
```

#### Vendor or Model:

You can target specific disks by their Vendor or by their Model

```
model: disk_model_name
```

or

```
vendor: disk_vendor_name
```

#### Size:

You can also match by disk Size.

```
size: size_spec
```

##### Size specs:

Size specification of format can be of form:

- LOW:HIGH
- :HIGH
- LOW:
- EXACT

Concrete examples:

Includes disks of an exact size

```
size: '10G'
```

Includes disks which size is within the range

```
size: '10G:40G'
```

Includes disks less than or equal to 10G in size

```
size: ':10G'
```

Includes disks equal to or greater than 40G in size

```
size: '40G:'
```

Sizes don’t have to be exclusively in Gigabyte(G).

Supported units are Megabyte(M), Gigabyte(G) and Terrabyte(T). Also appending the (B) for byte is supported. MB, GB, TB

#### Rotational:

This operates on the ‘rotational’ attribute of the disk.

```bash
rotational: 0 | 1
```

1 to match all disks that are rotational

0 to match all disks that are non-rotational (SSD, NVME etc)

#### All:

This will take all disks that are ‘available’

Note: This is exclusive for the data_devices section.

```
all: true
```

#### Limiter:

When you specified valid filters but want to limit the amount of matching disks you can use the ‘limit’ directive.

```
limit: 2
```

For example, if you used vendor to match all disks that are from VendorA but only want to use the first two you could use limit.

```
data_devices:
  vendor: VendorA
  limit: 2
```

> Note:
>
> Be aware that limit is really just a last resort and shouldn’t be used if it can be avoided.

### Additional Options

There are multiple optional settings you can use to change the way OSDs are deployed. You can add these options to the base level of a OSD spec for it to take effect.

This example would deploy all OSDs with encryption enabled.

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

See a full list in the DriveGroupSpecs

`class ceph.deployment.drive_group.DriveGroupSpec(*args: Any,**kwargs: Any)`

Describe a drive group in the same form that ceph-volume understands.  

* block_db_size*: Optional[Union[int, str]]*

  Set (or override) the “bluestore_block_db_size” value, in bytes

- block_wal_size*: Optional[Union[int, str]]*

  Set (or override) the “bluestore_block_wal_size” value, in bytes

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

  How many OSDs per DB device

- encrypted

  `true` or `false`

- filter_logic

  The logic gate we use to match disks with filters. defaults to ‘AND’

- journal_devices

  A `ceph.deployment.drive_group.DeviceSelection`

- journal_size*: Optional[Union[int, str]]*

  set journal_size in bytes

- objectstore

  `filestore` or `bluestore`

- osd_id_claims

  Optional: mapping of host -> List of osd_ids that should be replaced See [OSD Replacement](https://docs.ceph.com/en/latest/mgr/orchestrator_modules/#orchestrator-osd-replace)

- osds_per_device

  Number of osd daemons per “DATA” device. To fully utilize nvme devices multiple osds are required. Can be used to split dual-actuator devices across 2 OSDs, by setting the option to 2.

- preview_only

  If this should be treated as a ‘preview’ spec

- wal_devices

  A `ceph.deployment.drive_group.DeviceSelection`

- wal_slots

  How many OSDs per WAL device

### Examples

#### The simple case

All nodes with the same setup

```
20 HDDs
Vendor: VendorA
Model: HDD-123-foo
Size: 4TB

2 SSDs
Vendor: VendorB
Model: MC-55-44-ZX
Size: 512GB
```

This is a common setup and can be described quite easily:

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

However, we can improve it by reducing the filters on core properties of the drives:

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

Now, we enforce all rotating devices to be declared as ‘data devices’ and all non-rotating devices will be used as shared_devices (wal, db)

If you know that drives with more than 2TB will always be the slower data devices, you can also filter by size:

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

> Note:
>
> All of the above DriveGroups are equally valid. Which of those  you want to use depends on taste and on how much you expect your node  layout to change.

#### Multiple OSD specs for a single host

Here we have two distinct setups

```bash
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

This can be described with two layouts.

```yaml
service_type: osd
service_id: osd_spec_hdd
placement:
  host_pattern: '*'
spec:
  data_devices:
    rotational: 0
  db_devices:
    model: MC-55-44-XZ
    limit: 2 (db_slots is actually to be favoured here, but it's not implemented yet)
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

This would create the desired layout by using all HDDs as data_devices with two SSD assigned as dedicated db/wal devices. The remaining SSDs(8) will be data_devices that have the ‘VendorC’ NVMEs assigned as dedicated db/wal devices.

#### Multiple hosts with the same disk layout

Assuming the cluster has different kinds of hosts each with similar disk layout, it is recommended to apply different OSD specs matching only one set of hosts. Typically you will have a spec for multiple hosts with the same layout.

he service id as the unique key: In case a new OSD spec with an already applied service id is applied, the existing OSD spec will be superseded. cephadm will now create new OSD daemons based on the new spec definition. Existing OSD daemons will not be affected. See [Declarative State](https://docs.ceph.com/en/latest/cephadm/services/osd/#cephadm-osd-declarative).

Node1-5

```
20 HDDs
Vendor: Intel
Model: SSD-123-foo
Size: 4TB
2 SSDs
Vendor: VendorA
Model: MC-55-44-ZX
Size: 512GB
```

Node6-10

```
5 NVMEs
Vendor: Intel
Model: SSD-123-foo
Size: 4TB
20 SSDs
Vendor: VendorA
Model: MC-55-44-ZX
Size: 512GB
```

You can use the ‘host_pattern’ key in the layout to target certain nodes. Salt target notation helps to keep things easy.

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

This applies different OSD specs to different hosts depending on the host_pattern key.

> Note
>
> Assuming each host has a unique disk layout, each OSD spec needs to have a different service id

#### Dedicated wal + db

All previous cases co-located the WALs with the DBs. It’s however possible to deploy the WAL on a dedicated device as well, if it makes sense.

```
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

The OSD spec for this case would look like the following (using the model filter):

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

It is also possible to specify directly device paths in specific hosts like the following:

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

This can easily be done with other filters, like size or vendor as well.		



1. 创建 `osd_spec.yml` 文件：

   ```bash
   touch osd_spec.yml
   ```

2. 编辑 `osd_spec.yml` 文件，使其包含以下详情： 				

   1. 简单场景：在这种情况下，所有节点都有相同的设置。				

      ```none
      service_type: osd
      service_id: SERVICE_ID
      placement:
        host_pattern: '*' # optional
      data_devices: # optional
        model: DISK_MODEL_NAME # optional
      db_devices: # optional
        size: # optional
        all: true # optional
      encrypted: true
      ```

      ```none
      service_type: osd
      service_id: osd_spec_default
      placement:
        host_pattern: '*'
      data_devices:
        all: true
      encrypted: true
      ```

      ```none
      service_type: osd
      service_id: osd_spec_default
      placement:
        host_pattern: '*'
      data_devices:
        size: '80G'
      db_devices:
        size: '40G:'
      ```

   2. 高级情景：这会使用所有 HDD 作为 `data_devices` 来创建所需的布局，其中有两个 SSD 分配为专用 DB 或 WAL 设备。剩余的 SSD 是 `data_devices`，其 NVME 供应商被分配为专用的 DB 或 WAL 设备。		

      ```none
      service_type: osd
      service_id: osd_spec_hdd
      placement:
        host_pattern: '*'
      data_devices:
        rotational: 0
      db_devices:
        model: Model-name
        limit: 2
      ---
      service_type: osd
      service_id: osd_spec_ssd
      placement:
        host_pattern: '*'
      data_devices:
        model: Model-name
      db_devices:
        vendor: Vendor-name
      ```

   3. 具有非统一节点的高级场景：根据 host_pattern 键，这会将不同的 OSD 规格应用到不同的主机。

      ```none
      service_type: osd
      service_id: osd_spec_node_one_to_five
      placement:
        host_pattern: 'node[1-5]'
      data_devices:
        rotational: 1
      db_devices:
        rotational: 0
      ---
      service_type: osd
      service_id: osd_spec_six_to_ten
      placement:
        host_pattern: 'node[6-10]'
      data_devices:
        model: Model-name
      db_devices:
        model: Model-name
      ```

   4. 具有专用 WAL 和 DB 设备的高级场景： 

      ```none
      service_type: osd
      service_id: osd_using_paths
      placement:
        hosts:
          - host01
          - host02
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

3. 在部署 OSD 之前，先进行空运行： 				

   注意此步骤提供部署预览，而无需部署守护进程。 				

   ```none
   [ceph: root@host01 osd]# ceph orch apply -i osd_spec.yml --dry-run
   ```

4. 使用服务规格部署 OSD：

   ```none
   ceph orch apply -i FILE_NAME.yml
   ceph orch apply -i osd_spec.yml
   ```