# OSD

## 列出设备

`ceph-volume` scans each cluster in the host from time to time 不时扫描主机中的每个集群，以确定存在哪些设备以及这些设备是否有资格用作 OSD 。

打印设备列表：

```bash
ceph orch device ls [--hostname=...] [--wide] [--refresh]

--wide  # 提供与设备相关的所有详细信息，包括设备不适合用作OSD的任何原因。
```

例如：

```bash
Hostname  Path      Type  Serial              Size   Health   Ident  Fault  Available
srv-01    /dev/sdb  hdd   15P0A0YFFRD6         300G  Unknown  N/A    N/A    No
srv-01    /dev/sdc  hdd   15R0A08WFRD6         300G  Unknown  N/A    N/A    No
srv-01    /dev/sdd  hdd   15R0A07DFRD6         300G  Unknown  N/A    N/A    No
srv-01    /dev/sde  hdd   15P0A0QDFRD6         300G  Unknown  N/A    N/A    No
srv-02    /dev/sdb  hdd   15R0A033FRD6         300G  Unknown  N/A    N/A    No
srv-02    /dev/sdc  hdd   15R0A05XFRD6         300G  Unknown  N/A    N/A    No
srv-02    /dev/sde  hdd   15R0A0ANFRD6         300G  Unknown  N/A    N/A    No
srv-02    /dev/sdf  hdd   15R0A06EFRD6         300G  Unknown  N/A    N/A    No
srv-03    /dev/sdb  hdd   15R0A0OGFRD6         300G  Unknown  N/A    N/A    No
srv-03    /dev/sdc  hdd   15R0A0P7FRD6         300G  Unknown  N/A    N/A    No
srv-03    /dev/sdd  hdd   15R0A0O7FRD6         300G  Unknown  N/A    N/A    No
```

在上面的示例中，您可以看到名为“Health”、“Ident”和“Fault”的字段。此信息是通过与 libstoragemgmt 集成提供的。默认情况下，此集成处于禁用状态（因为libstoragemgmt 可能与您的硬件不完全兼容）。要使 cephadm 包含这些字段，启用cephadm的 “enhanced device scan” 选项。

```bash
ceph config set mgr mgr/cephadm/device_enhanced_scan true
```

> **Warning**
>
> 尽管 libstoragemgmt 库执行标准的SCSI查询调用，但不能保证固件完全实现这些标准。可能导致不稳定的行为，甚至在一些旧硬件上总线复位 bus resets 。因此，建议您在启用此功能之前，首先测试硬件与 libstoragemgmt 的兼容性，以避免对服务的意外中断。
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

## 部署 OSD

### 列出存储设备

列出存储设备：

```bash
ceph orch device ls
```

如满足以下所有条件，认为存储设备可用：

- 设备上不能有分区。
- 设备不能有任何 LVM 状态。
- 设备不能被 mount 。
- 设备不能包含文件系统。
- 设备不能包含Ceph BlueStore OSD。
- 设备必须大于5 GB。

Ceph不会在不可用的设备上提供OSD。

### 创建新的 OSD

多种方式：

- 告诉Ceph使用任何可用和未使用的存储设备：

  ```bash
  ceph orch apply osd --all-available-devices
  ```

- 从特定主机上的特定设备创建 OSD：

  ```bash
  ceph orch daemon add osd <host>:<device-path>
  
  ceph orch daemon add osd host1:/dev/sdb
  ```

- 可以使用 [Advanced OSD Service Specifications](https://docs.ceph.com/en/latest/cephadm/osd/#drivegroups) 根据设备的属性对设备进行分类。这可能有助于更清楚地了解哪些设备可以使用。属性包括设备类型（SSD或HDD）、设备型号名称、大小以及设备所在的主机：

  ```bash
  ceph orch apply -i spec.yml
  ```

### Dry Run

`--dry-run` 标志使 orchestrator 在不实际创建 OSD 的情况下呈现将要发生的事情的预览。

```bash
ceph orch apply osd --all-available-devices --dry-run

NAME                  HOST  DATA      DB  WAL
all-available-devices node1 /dev/vdb  -   -
all-available-devices node2 /dev/vdc  -   -
all-available-devices node3 /dev/vdd  -   -
```

### 声明状态

`ceph orch apply` 作用是持久的。that is, drives which are added to the system or become available (say, by zapping) after the command is complete will be automatically found and added to the cluster.这意味着在命令完成后添加到系统中的驱动器将被自动找到并添加到集群中。这也意味着在ceph orch apply命令完成后可用的驱动器（例如通过zapping）将被自动找到并添加到集群中。

```bash
ceph orch apply osd --all-available-devices
```

- 如果向集群添加新磁盘，它们将自动用于创建新的 OSD 。
- 如果删除 OSD 并清理 LVM 物理卷，将自动创建新的 OSD 。

如要避免此行为（禁用在可用设备上自动创建OSD），请使用unmanaged参数：

```bash
ceph orch apply osd --all-available-devices --unmanaged=true
```

> 注意
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
ceph orch osd rm <osd_id(s)> [--replace] [--force]

ceph orch osd rm 0
Scheduled OSD(s) for removal
```

无法安全销毁的 OSD 将被拒绝。

### 监控 OSD 状态

使用以下命令查询 OSD 操作的状态：

```bash
ceph orch osd rm status

# 预期输出
OSD_ID  HOST         STATE                    PG_COUNT  REPLACE  FORCE  STARTED_AT
2       cephadm-dev  done, waiting for purge  0         True     False  2020-07-17 13:01:43.147684
3       cephadm-dev  draining                 17        False    True   2020-07-17 13:01:45.162158
4       cephadm-dev  started                  42        False    True   2020-07-17 13:01:45.162158
```

当 OSD 上没有 PG 时，它将退役并从集群中移除。

> Note
>
> 删除 OSD 后，如果擦除已删除 OSD 使用的设备中的 LVM 物理卷，将创建新的 OSD 。有关此问题的详细信息，请阅读声明状态下的 `unmanaged` 参数。

### 停止 OSD 删除

使用以下命令停止排队的OSD删除：

```bash
ceph orch osd rm stop <svc_id(s)>

ceph orch osd rm stop 4
Stopped OSD(s) removal
```

这将重置 OSD 的初始状态并将其从删除队列中移除。

### 替换 OSD

```bash
orch osd rm <svc_id(s)> --replace [--force]

ceph orch osd rm 4 --replace
Scheduled OSD(s) for replacement
```

这与“删除OSD”部分中的过程相同，但有一个例外：OSD 不是从 CRUSH 层次结构中永久删除的，而是被分配了一个 “destroyed” 标志。

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

### 擦除设备 (Zapping Devices)

擦除（清除）一个设备以便它能被重用。 `zap` 在远程主机上调用 `ceph-volume zap` 。

```bash
ceph orch device zap <hostname> <path>

ceph orch device zap my_hostname /dev/sdx
```

> Note
>
> 如果未设置unmanaged标志，cephadm会自动部署与 OSDSpec 中的驱动器组匹配的驱动器。例如，如果您在创建OSD时使用 `all-available-devices` 选项，那么当您对一个设备执行 `zap` 操作时，cephadm  orchestrator 会自动在该设备中创建一个新的OSD。要禁用此行为，请参阅声明性状态。

## 自动调整OSD内存

OSD daemons will adjust their memory consumption based on the `osd_memory_target` config option (several gigabytes, by default).  If Ceph is deployed on dedicated nodes that are not sharing memory with other services, cephadm can automatically adjust the per-OSD memory consumption based on the total amount of RAM and the number of deployed OSDs.

This option is enabled globally with:

```
ceph config set osd osd_memory_target_autotune true
```

Cephadm will start with a fraction (`mgr/cephadm/autotune_memory_target_ratio`, which defaults to `.7`) of the total RAM in the system, subtract off any memory consumed by non-autotuned daemons (non-OSDs, for OSDs for which `osd_memory_target_autotune` is false), and then divide by the remaining OSDs.

The final targets are reflected in the config database with options like:

```
WHO   MASK      LEVEL   OPTION              VALUE
osd   host:foo  basic   osd_memory_target   126092301926
osd   host:bar  basic   osd_memory_target   6442450944
```

Both the limits and the current memory consumed by each daemon are visible from the `ceph orch ps` output in the `MEM LIMIT` column:

```
NAME        HOST  PORTS  STATUS         REFRESHED  AGE  MEM USED  MEM LIMIT  VERSION                IMAGE ID      CONTAINER ID
osd.1       dael         running (3h)     10s ago   3h    72857k     117.4G  17.0.0-3781-gafaed750  7015fda3cd67  9e183363d39c
osd.2       dael         running (81m)    10s ago  81m    63989k     117.4G  17.0.0-3781-gafaed750  7015fda3cd67  1f0cc479b051
osd.3       dael         running (62m)    10s ago  62m    64071k     117.4G  17.0.0-3781-gafaed750  7015fda3cd67  ac5537492f27
```

To exclude an OSD from memory autotuning, disable the autotune option for that OSD and also set a specific memory target.  For example,

```bash
ceph config set osd.123 osd_memory_target_autotune false
ceph config set osd.123 osd_memory_target 16G
```

## 高级OSD服务规范

[Service Specification](https://docs.ceph.com/en/latest/cephadm/service-management/#orchestrator-cli-service-spec) of type `osd` are a way to describe a cluster layout using the properties of disks. It gives the user an abstract way tell ceph which disks should turn into an OSD with which configuration without knowing the specifics of device names and paths.

Instead of doing this

```
ceph orch daemon add osd <host>:<path-to-device>
```

for each device and each host, we can define a yaml|json file that allows us to describe the layout. Here’s the most basic example.

Create a file called i.e. osd_spec.yml

```yaml
service_type: osd
service_id: default_drive_group  <- name of the drive_group (name can be custom)
placement:
  host_pattern: '*'              <- which hosts to target, currently only supports globs
data_devices:                    <- the type of devices you are applying specs to
  all: true                      <- a filter, check below for a full list
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
[monitor.1]# ceph orch apply osd -i /path/to/osd_spec.yml --dry-run
```

### Filters

Note

Filters are applied using a AND gate by default. This essentially means that a drive needs to fulfill all filter criteria in order to get selected. If you wish to change this behavior you can adjust this behavior by setting

> filter_logic: OR  # valid arguments are AND, OR

in the OSD Specification.

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

```
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

Note: Be aware that limit is really just a last resort and shouldn’t be used if it can be avoided.

### Additional Options

There are multiple optional settings you can use to change the way OSDs are deployed. You can add these options to the base level of a DriveGroup for it to take effect.

This example would deploy all OSDs with encryption enabled.

```
service_type: osd
service_id: example_osd_spec
placement:
  host_pattern: '*'
data_devices:
  all: true
encrypted: true
```

See a full list in the DriveGroupSpecs

- *class* `ceph.deployment.drive_group.``DriveGroupSpec`(**args: Any*, ***kwargs: Any*)

  Describe a drive group in the same form that ceph-volume understands.  `block_db_size`*: Union[int, str, None]* Set (or override) the “bluestore_block_db_size” value, in bytes   `block_wal_size`*: Union[int, str, None]* Set (or override) the “bluestore_block_wal_size” value, in bytes   `data_devices` A `ceph.deployment.drive_group.DeviceSelection`   `data_directories` A list of strings, containing paths which should back OSDs   `db_devices` A `ceph.deployment.drive_group.DeviceSelection`   `db_slots` How many OSDs per DB device   `encrypted` `true` or `false`   `filter_logic` The logic gate we use to match disks with filters. defaults to ‘AND’   `journal_devices` A `ceph.deployment.drive_group.DeviceSelection`   `journal_size`*: Union[int, str, None]* set journal_size in bytes   `objectstore` `filestore` or `bluestore`   `osd_id_claims` Optional: mapping of host -> List of osd_ids that should be replaced See [OSD Replacement](https://docs.ceph.com/en/latest/mgr/orchestrator_modules/#orchestrator-osd-replace)   `osds_per_device` Number of osd daemons per “DATA” device. To fully utilize nvme devices multiple osds are required.   `preview_only` If this should be treated as a ‘preview’ spec   `wal_devices` A `ceph.deployment.drive_group.DeviceSelection`   `wal_slots` How many OSDs per WAL device

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

```
service_type: osd
service_id: osd_spec_default
placement:
  host_pattern: '*'
data_devices:
  model: HDD-123-foo <- note that HDD-123 would also be valid
db_devices:
  model: MC-55-44-XZ <- same here, MC-55-44 is valid
```

However, we can improve it by reducing the filters on core properties of the drives:

```
service_type: osd
service_id: osd_spec_default
placement:
  host_pattern: '*'
data_devices:
  rotational: 1
db_devices:
  rotational: 0
```

Now, we enforce all rotating devices to be declared as ‘data devices’ and all non-rotating devices will be used as shared_devices (wal, db)

If you know that drives with more than 2TB will always be the slower data devices, you can also filter by size:

```
service_type: osd
service_id: osd_spec_default
placement:
  host_pattern: '*'
data_devices:
  size: '2TB:'
db_devices:
  size: ':2TB'
```

Note: All of the above DriveGroups are equally valid. Which of those  you want to use depends on taste and on how much you expect your node  layout to change.

#### The advanced case

Here we have two distinct setups

```
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

```
service_type: osd
service_id: osd_spec_hdd
placement:
  host_pattern: '*'
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
data_devices:
  model: MC-55-44-XZ
db_devices:
  vendor: VendorC
```

This would create the desired layout by using all HDDs as data_devices with two SSD assigned as dedicated db/wal devices. The remaining SSDs(8) will be data_devices that have the ‘VendorC’ NVMEs assigned as dedicated db/wal devices.

#### The advanced case (with non-uniform nodes)

The examples above assumed that all nodes have the same drives. That’s however not always the case.

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

```
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
  model: MC-55-44-XZ
db_devices:
  model: SSD-123-foo
```

This applies different OSD specs to different hosts depending on the host_pattern key.

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

```
service_type: osd
service_id: osd_spec_default
placement:
  host_pattern: '*'
data_devices:
  model: MC-55-44-XZ
db_devices:
  model: SSD-123-foo
wal_devices:
  model: NVME-QQQQ-987
```

It is also possible to specify directly device paths in specific hosts like the following:

```
service_type: osd
service_id: osd_using_paths
placement:
  hosts:
    - Node01
    - Node02
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

## 激活现有 OSD

如果重新安装了主机的操作系统，则需要重新激活现有的 OSD 。对于这个用例，cephadm为 activate 提供了一个 wrapper，用于激活主机上所有现有的 OSD 。

```bash
ceph cephadm osd activate <host>...
```

这将扫描所有 OSD 的现有磁盘，并部署相应的守护进程。
