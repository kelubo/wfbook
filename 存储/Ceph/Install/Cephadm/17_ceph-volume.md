# ceph-volume

[TOC]
Deploy OSDs with different device technologies like lvm or physical disks using pluggable tools ([lvm](https://docs.ceph.com/en/latest/ceph-volume/lvm/) itself is treated like a plugin) and trying to follow a predictable, and robust way of preparing, activating, and starting OSDs.

`ceph-volume` 工具旨在成为一个单一用途的命令行工具，来将 logical volumes 部署为 OSD，并在准备、激活和创建 OSD 时，尝试维护与 `ceph-disk` 类似的 API 。

It deviates from `ceph-disk` by not interacting or relying on the udev rules that come installed for Ceph. These rules allow automatic detection of previously setup devices that are in turn fed into `ceph-disk` to activate them.它与ceph磁盘的不同之处在于没有交互或依赖为ceph安装的udev规则。这些规则允许自动检测先前设置的设备，这些设备反过来被送入ceph磁盘以激活它们。

Deploy OSDs  with different device technologies like lvm or physical disks using pluggable tools ([lvm](https://docs.ceph.com/en/latest/ceph-volume/lvm/) itself is treated like a plugin) and trying to follow a predictable, and robust way of preparing, activating, and starting OSDs.使用不同的设备技术（如lvm）部署 osd或使用可插拔工具（lvm本身被视为插件）部署物理磁盘，并尝试遵循一种可预测的、健壮的方法来准备、激活和启动osd。

**Command Line Subcommands**命令行子命令

There is currently support for `lvm`, and plain disks (with GPT partitions) that may have been deployed with `ceph-disk`.目前支持lvm和普通磁盘（带有GPT分区），这些磁盘可能已与ceph disk一起部署。

`zfs` support is available for running a FreeBSD cluster.zfs支持可用于运行免费的BSD集群。

- [lvm](https://docs.ceph.com/en/latest/ceph-volume/lvm/#ceph-volume-lvm)
- [simple](https://docs.ceph.com/en/latest/ceph-volume/simple/#ceph-volume-simple)
- [zfs](https://docs.ceph.com/en/latest/ceph-volume/zfs/#ceph-volume-zfs)

**Node inventory**节点资源清单

The [inventory](https://docs.ceph.com/en/latest/ceph-volume/inventory/#ceph-volume-inventory) subcommand provides information and metadata about a nodes physical disk inventory.inventory子命令提供有关节点物理磁盘清单的信息和元数据。

## 迁移

从Ceph 13.0.0 开始， `ceph-disk` 已被弃用。Deprecation warnings will show up that will link to this page. 将显示链接到此页的弃用警告。It is strongly suggested that users start consuming `ceph-volume`. 强烈建议用户开始消费 `ceph-volume`。有两种迁移路径：

1. Keep OSDs deployed with `ceph-disk`: The [simple](https://docs.ceph.com/en/latest/ceph-volume/simple/#ceph-volume-simple) command provides a way to take over the management while disabling `ceph-disk` triggers.这个简单的命令提供了一种在禁用ceph disk触发器的同时接管管理的方法。
2. 用 `ceph-volume` 重新部署现有的OSD：这将在替换OSD时详细介绍。 This is covered in depth on [Replacing an OSD](https://docs.ceph.com/en/latest/rados/operations/add-or-rm-osds/#rados-replacing-an-osd)

### 新的部署

对于新部署，建议使用 lvm 。it can use any logical volume as input for data OSDs, or it can setup a minimal/naive logical volume from a device.它可以使用任何逻辑卷作为数据osd的输入，也可以从设备设置最小/原始逻辑卷。

### 已有的 OSD

如果集群具有用 `ceph-disk` 配置的 OSD ，那么 `ceph-volume` 可以用 simple 的方法接管这些 OSD 的管理。A scan is done on the data device or OSD directory, and `ceph-disk` is fully disabled. 扫描在数据设备或OSD目录上完成，ceph磁盘被完全禁用。完全支持加密。

## 替代 ceph-disk

The `ceph-disk` tool was created at a time were the project was required to support many different types of init systems (upstart, sysvinit, etc…) while being able to discover devices. This caused the tool to concentrate initially (and exclusively afterwards) on GPT partitions. Specifically on GPT GUIDs, which were used to label devices in a unique way to answer questions like:ceph disk工具是在项目需要支持许多不同类型的init系统（upstart、sysvinit等）同时能够发现设备的时候创建的。这导致该工具最初（以及之后）将注意力集中在GPT分区上。特别是GPT GUI，用于以独特的方式标记设备，以回答以下问题：

- is this device a Journal?这个设备是日记吗？
- 加密的数据分区？
- was the device left partially prepared?设备是否部分准备就绪？

为了解决这些问题，它使用 `UDEV` 规则来匹配 GUID ， that would call `ceph-disk`, and end up in a back and forth between the `ceph-disk` systemd unit and the `ceph-disk` executable. 这将调用ceph disk，并最终在ceph disk systemd单元和ceph  disk可执行文件之间来回切换。这个过程是非常不可靠和耗时的（a timeout of close to three hours **per OSD** had to be put in place），并且会导致 OSD 在节点的引导过程中 to not come up at all 根本不会出现。

It was hard to debug, or even replicate these problems given the asynchronous behavior of `UDEV`.考虑到UDEV的异步行为，很难调试甚至复制这些问题。

Since the world-view of `ceph-disk` had to be GPT partitions exclusively, it meant that it couldn’t work with other technologies like LVM, or similar device mapper devices. It was ultimately decided to create something modular, starting with LVM support, and the ability to expand on other technologies as needed.由于ceph磁盘的世界视图必须是GPT分区，这意味着它不能与LVM或类似的设备映射器设备等其他技术一起工作。最终决定创建一些模块化的东西，首先是LVM支持，以及根据需要扩展到其他技术的能力。

## GPT分区简单吗？

Although partitions in general are simple to reason about, `ceph-disk` partitions were not simple by any means.尽管分区通常很容易推理，但ceph磁盘分区无论如何都不简单。 It required a tremendous amount of special flags in order to get them to work correctly with the device discovery workflow. 它需要大量的特殊标志才能使它们正确地使用设备发现工作流。下面是创建数据分区的调用示例：

```bash
/sbin/sgdisk --largest-new=1 --change-name=1:ceph data --partition-guid=1:f0fc39fd-eeb2-49f1-b922-a11939cf8a0f --typecode=1:89c57f98-2fe5-4dc0-89c1-f3ad0ceff2be --mbrtogpt -- /dev/sdb
```

不仅创建这些分区很困难，而且这些分区要求设备由Ceph独占。in some cases a special partition would be created when devices were encrypted, which would contain unencrypted keys. 例如，在某些情况下，加密设备时会创建一个特殊分区，其中包含未加密的密钥。This was `ceph-disk` domain knowledge, which would not translate to a “GPT partitions are simple” understanding. 这是ceph磁盘领域的知识，这并不能转化为“GPT分区都很简单”的理解。下面是正在创建的特殊分区的示例：

```bash
/sbin/sgdisk --new=5:0:+10M --change-name=5:ceph lockbox --partition-guid=5:None --typecode=5:fb3aabf9-d25f-47cc-bf5e-721d181642be --mbrtogpt -- /dev/sdad
```

## Modularity 模块度

`ceph-volume` 被设计成一个模块化工具，because we anticipate that there are going to be lots of ways that people provision the hardware devices that we need to consider. 因为我们预期人们将有很多方法来提供我们需要考虑的硬件设备。目前已经有两种：

* 仍在使用且具有GPT分区（由 simple 处理）的遗留 ceph-disk 设备和lvm。
* SPDK devices where we manage NVMe devices directly from userspace are on the immediate horizon, where LVM won’t work there since the kernel isn’t involved at all.我们直接从用户空间管理NVMe设备的SPDK设备即将面世，LVM将无法在那里工作，因为根本不涉及内核。

## ceph-volume lvm

通过使用 LVM 标记，LVM 子命令能够存储和稍后重新发现并查询与 OSD 相关联的设备，以便稍后激活它们。

## LVM performance penalty

简而言之：我们还没有注意到任何与 LVM 更改相关的重大性能损失。By being able to work closely with LVM, the ability to work with other device mapper technologies was a given: 由于能够与LVM密切合作，与其他设备映射器技术合作的能力已经具备：处理任何可以位于逻辑卷之下的内容都没有技术困难。there is no technical difficulty in working with anything that can sit below a Logical Volume.

## systemd

As part of the activation process (either with [activate](https://docs.ceph.com/en/latest/ceph-volume/lvm/activate/#ceph-volume-lvm-activate) or [activate](https://docs.ceph.com/en/latest/ceph-volume/simple/activate/#ceph-volume-simple-activate)), systemd units will get enabled that will use the OSD id and uuid as part of their name. These units will be run when the system boots, and will proceed to activate their corresponding volumes via their sub-command implementation.作为激活过程的一部分（使用activate或activate），systemd单元将启用，并使用OSD id和uuid作为其名称的一部分。这些单元将在系统引导时运行，并通过其子命令实现继续激活相应的卷。

The API for activation is a bit loose, it only requires two parts: the subcommand to use and any extra meta information separated by a dash.激活的API有点松散，它只需要两部分：要使用的子命令和任何用破折号分隔的额外元信息。 This convention makes the units look like:此约定使单位看起来像：

```bash
ceph-volume@{command}-{extra metadata}
```

The *extra metadata* can be anything needed that the subcommand implementing the processing might need. In the case of [lvm](https://docs.ceph.com/en/latest/ceph-volume/lvm/#ceph-volume-lvm) and [simple](https://docs.ceph.com/en/latest/ceph-volume/simple/#ceph-volume-simple), both look to consume the [OSD id](https://docs.ceph.com/en/latest/glossary/#term-OSD-id) and [OSD uuid](https://docs.ceph.com/en/latest/glossary/#term-OSD-uuid), but this is not a hard requirement, it is just how the sub-commands are implemented.

Both the command and extra metadata gets persisted by systemd as part of the *“instance name”* of the unit.  For example an OSD with an ID of 0, for the `lvm` sub-command would look like:

```
systemctl enable ceph-volume@lvm-0-0A3E1ED2-DA8A-4F0E-AA95-61DEC71768D6
```

The enabled unit is a [systemd oneshot](https://docs.ceph.com/en/latest/glossary/#term-systemd-oneshot) service, meant to start at boot after the local file system is ready to be used.

### Failure and Retries

It is common to have failures when a system is coming up online. The devices are sometimes not fully available and this unpredictable behavior may cause an OSD to not be ready to be used.

There are two configurable environment variables used to set the retry behavior:

- `CEPH_VOLUME_SYSTEMD_TRIES`: Defaults to 30
- `CEPH_VOLUME_SYSTEMD_INTERVAL`: Defaults to 5

The *“tries”* is a number that sets the maximum number of times the unit will attempt to activate an OSD before giving up.

The *“interval”* is a value in seconds that determines the waiting time before initiating another try at activating the OSD.







额外的元数据可以是实现处理的子命令可能需要的任何东西。在lvm和simple的情况下，两者都希望使用OSD id和OSD uuid，但这不是一个硬性要求，它只是子命令的实现方式。

命令和额外的元数据都由systemd持久化为单元的“实例名”的一部分。例如，对于lvm子命令，ID为0的OSD如下所示：

系统控制启用ceph-volume@lvm-0-0A3E1ED2-DA8A-4F0E-AA95-61DEC71768D6

启用的单元是systemd oneshot服务，意味着在本地文件系统准备好使用后在引导时启动。

失败和重试

当系统上线时，出现故障是很常见的。这些设备有时不完全可用，这种不可预知的行为可能会导致OSD无法准备好使用。

有两个可配置的环境变量用于设置重试行为：

CEPH VOLUME SYSTEMD TRIES：默认为30

CEPH VOLUME SYSTEMD INTERVAL：默认为5

“tries”是一个数字，用于设置设备在放弃前尝试激活OSD的最大次数。

“间隔”是一个以秒为单位的值，用于确定在启动另一次尝试激活OSD之前的等待时间。



# `inventory`

The `inventory` subcommand queries a host’s disc inventory and provides hardware information and metadata on every physical device.

By default the command returns a short, human-readable report of all physical disks.

For programmatic consumption of this report pass `--format json` to generate a JSON formatted report. This report includes extensive information on the physical drives such as disk metadata (like model and size), logical volumes and whether they are used by ceph, and if the disk is usable by ceph and reasons why not.

A device path can be specified to report extensive information on a device in both plain and json format.

# `drive-group`

The drive-group subcommand allows for passing :ref:’drivegroups’ specifications straight to ceph-volume as json. ceph-volume will then attempt to deploy this drive groups via the batch subcommand.

The specification can be passed via a file, string argument or on stdin. See the subcommand help for further details:

```
# ceph-volume drive-group --help
```

# `lvm`

Implements the functionality needed to deploy OSDs from the `lvm` subcommand: `ceph-volume lvm`

**Command Line Subcommands**

- [prepare](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#ceph-volume-lvm-prepare)
- [activate](https://docs.ceph.com/en/latest/ceph-volume/lvm/activate/#ceph-volume-lvm-activate)
- [create](https://docs.ceph.com/en/latest/ceph-volume/lvm/create/#ceph-volume-lvm-create)
- [list](https://docs.ceph.com/en/latest/ceph-volume/lvm/list/#ceph-volume-lvm-list)

**Internal functionality**

There are other aspects of the `lvm` subcommand that are internal and not exposed to the user, these sections explain how these pieces work together, clarifying the workflows of the tool.

[Systemd Units](https://docs.ceph.com/en/latest/ceph-volume/lvm/systemd/#ceph-volume-lvm-systemd) | [lvm](https://docs.ceph.com/en/latest/dev/ceph-volume/lvm/#ceph-volume-lvm-api)

​              

# `activate`

Once [prepare](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#ceph-volume-lvm-prepare) is completed, and all the various steps that entails are done, the volume is ready to get “activated”.

This activation process enables a systemd unit that persists the OSD ID and its UUID (also called `fsid` in Ceph CLI tools), so that at boot time it can understand what OSD is enabled and needs to be mounted.

Note

The execution of this call is fully idempotent, and there is no side-effects when running multiple times

## New OSDs

To activate newly prepared OSDs both the [OSD id](https://docs.ceph.com/en/latest/glossary/#term-OSD-id) and [OSD uuid](https://docs.ceph.com/en/latest/glossary/#term-OSD-uuid) need to be supplied. For example:

```
ceph-volume lvm activate --bluestore 0 0263644D-0BF1-4D6D-BC34-28BD98AE3BC8
```

Note

The UUID is stored in the `fsid` file in the OSD path, which is generated when [prepare](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#ceph-volume-lvm-prepare) is used.

## Activating all OSDs

It is possible to activate all existing OSDs at once by using the `--all` flag. For example:

```
ceph-volume lvm activate --all
```

This call will inspect all the OSDs created by ceph-volume that are inactive and will activate them one by one. If any of the OSDs are already running, it will report them in the command output and skip them, making it safe to rerun (idempotent).

### requiring uuids

The [OSD uuid](https://docs.ceph.com/en/latest/glossary/#term-OSD-uuid) is being required as an extra step to ensure that the right OSD is being activated. It is entirely possible that a previous OSD with the same id exists and would end up activating the incorrect one.

### dmcrypt

If the OSD was prepared with dmcrypt by ceph-volume, there is no need to specify `--dmcrypt` on the command line again (that flag is not available for the `activate` subcommand). An encrypted OSD will be automatically detected.

## Discovery

With OSDs previously created by `ceph-volume`, a *discovery* process is performed using [LVM tags](https://docs.ceph.com/en/latest/glossary/#term-LVM-tags) to enable the systemd units.

The systemd unit will capture the [OSD id](https://docs.ceph.com/en/latest/glossary/#term-OSD-id) and [OSD uuid](https://docs.ceph.com/en/latest/glossary/#term-OSD-uuid) and persist it. Internally, the activation will enable it like:

```
systemctl enable ceph-volume@lvm-$id-$uuid
```

For example:

```
systemctl enable ceph-volume@lvm-0-8715BEB4-15C5-49DE-BA6F-401086EC7B41
```

Would start the discovery process for the OSD with an id of `0` and a UUID of `8715BEB4-15C5-49DE-BA6F-401086EC7B41`.

Note

for more details on the systemd workflow see [systemd](https://docs.ceph.com/en/latest/ceph-volume/lvm/systemd/#ceph-volume-lvm-systemd)

The systemd unit will look for the matching OSD device, and by looking at its [LVM tags](https://docs.ceph.com/en/latest/glossary/#term-LVM-tags) will proceed to:

- # mount the device in the corresponding location (by convention this is

  `/var/lib/ceph/osd/<cluster name>-<osd id>/`)

\# ensure that all required devices are ready for that OSD. In the case of a journal (when `--filestore` is selected) the device will be queried (with `blkid` for partitions, and lvm for logical volumes) to ensure that the correct device is being linked. The symbolic link will *always* be re-done to ensure that the correct device is linked.

\# start the `ceph-osd@0` systemd unit

Note

The system infers the objectstore type (filestore or bluestore) by inspecting the LVM tags applied to the OSD devices

## Existing OSDs

For existing OSDs that have been deployed with `ceph-disk`, they need to be scanned and activated [using the simple sub-command](https://docs.ceph.com/en/latest/ceph-volume/simple/#ceph-volume-simple). If a different tooling was used then the only way to port them over to the new mechanism is to prepare them again (losing data). See [Existing OSDs](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#ceph-volume-lvm-existing-osds) for details on how to proceed.

## Summary

To recap the `activate` process for [bluestore](https://docs.ceph.com/en/latest/glossary/#term-bluestore):

1. require both [OSD id](https://docs.ceph.com/en/latest/glossary/#term-OSD-id) and [OSD uuid](https://docs.ceph.com/en/latest/glossary/#term-OSD-uuid)
2. enable the system unit with matching id and uuid
3. Create the `tmpfs` mount at the OSD directory in `/var/lib/ceph/osd/$cluster-$id/`
4. Recreate all the files needed with `ceph-bluestore-tool prime-osd-dir` by pointing it to the OSD `block` device.
5. the systemd unit will ensure all devices are ready and linked
6. the matching `ceph-osd` systemd unit will get started

And for [filestore](https://docs.ceph.com/en/latest/glossary/#term-filestore):

1. require both [OSD id](https://docs.ceph.com/en/latest/glossary/#term-OSD-id) and [OSD uuid](https://docs.ceph.com/en/latest/glossary/#term-OSD-uuid)
2. enable the system unit with matching id and uuid
3. the systemd unit will ensure all devices are ready and mounted (if needed)
4. the matching `ceph-osd` systemd unit will get started

# `batch`

The subcommand allows to create multiple OSDs at the same time given an input of devices. The `batch` subcommand is closely related to drive-groups. One individual drive group specification translates to a single `batch` invocation.

The subcommand is based to [create](https://docs.ceph.com/en/latest/ceph-volume/lvm/create/#ceph-volume-lvm-create), and will use the very same code path. All `batch` does is to calculate the appropriate sizes of all volumes and skip over already created volumes.

All the features that `ceph-volume lvm create` supports, like `dmcrypt`, avoiding `systemd` units from starting, defining bluestore or filestore, are supported.



## Automatic sorting of disks

If `batch` receives only a single list of data devices and other options are passed , `ceph-volume` will auto-sort disks by its rotational property and use non-rotating disks for `block.db` or `journal` depending on the objectstore used. If all devices are to be used for standalone OSDs, no matter if rotating or solid state, pass `--no-auto`. For example assuming [bluestore](https://docs.ceph.com/en/latest/glossary/#term-bluestore) is used and `--no-auto` is not passed, the deprecated behavior would deploy the following, depending on the devices passed:

1. Devices are all spinning HDDs: 1 OSD is created per device
2. Devices are all SSDs: 2 OSDs are created per device
3. Devices are a mix of HDDs and SSDs: data is placed on the spinning device, the `block.db` is created on the SSD, as large as possible.

Note

Although operations in `ceph-volume lvm create` allow usage of `block.wal` it isn’t supported with the `auto` behavior.

This default auto-sorting behavior is now DEPRECATED and will be changed in future releases. Instead devices are not automatically sorted unless the `--auto` option is passed

- It is recommended to make use of the explicit device lists for `block.db`,

  `block.wal` and `journal`.



# Reporting

By default `batch` will print a report of the computed OSD layout and ask the user to confirm. This can be overridden by passing `--yes`.

If one wants to try out several invocations with being asked to deploy `--report` can be passed. `ceph-volume` will exit after printing the report.

Consider the following invocation:

```
$ ceph-volume lvm batch --report /dev/sdb /dev/sdc /dev/sdd --db-devices /dev/nvme0n1
```

This will deploy three OSDs with external `db` and `wal` volumes on an NVME device.

**pretty reporting** The `pretty` report format (the default) would look like this:

```bash
$ ceph-volume lvm batch --report /dev/sdb /dev/sdc /dev/sdd --db-devices /dev/nvme0n1
--> passed data devices: 3 physical, 0 LVM
--> relative data size: 1.0
--> passed block_db devices: 1 physical, 0 LVM

Total OSDs: 3

  Type            Path                                                    LV Size         % of device
----------------------------------------------------------------------------------------------------
  data            /dev/sdb                                              300.00 GB         100.00%
  block_db        /dev/nvme0n1                                           66.67 GB         33.33%
----------------------------------------------------------------------------------------------------
  data            /dev/sdc                                              300.00 GB         100.00%
  block_db        /dev/nvme0n1                                           66.67 GB         33.33%
----------------------------------------------------------------------------------------------------
  data            /dev/sdd                                              300.00 GB         100.00%
  block_db        /dev/nvme0n1                                           66.67 GB         33.33%
```

**JSON reporting** Reporting can produce a structured output with `--format json` or `--format json-pretty`:

```json
$ ceph-volume lvm batch --report --format json-pretty /dev/sdb /dev/sdc /dev/sdd --db-devices /dev/nvme0n1
--> passed data devices: 3 physical, 0 LVM
--> relative data size: 1.0
--> passed block_db devices: 1 physical, 0 LVM
[
    {
        "block_db": "/dev/nvme0n1",
        "block_db_size": "66.67 GB",
        "data": "/dev/sdb",
        "data_size": "300.00 GB",
        "encryption": "None"
    },
    {
        "block_db": "/dev/nvme0n1",
        "block_db_size": "66.67 GB",
        "data": "/dev/sdc",
        "data_size": "300.00 GB",
        "encryption": "None"
    },
    {
        "block_db": "/dev/nvme0n1",
        "block_db_size": "66.67 GB",
        "data": "/dev/sdd",
        "data_size": "300.00 GB",
        "encryption": "None"
    }
]
```

# Sizing

When no sizing arguments are passed, ceph-volume will derive the sizing from the passed device lists (or the sorted lists when using the automatic sorting). ceph-volume batch will attempt to fully utilize a device’s available capacity. Relying on automatic sizing is recommended.

If one requires a different sizing policy for wal, db or journal devices, ceph-volume offers implicit and explicit sizing rules.

## Implicit sizing

Scenarios in which either devices are under-comitted or not all data devices are currently ready for use (due to a broken disk for example), one can still rely on ceph-volume automatic sizing. Users can provide hints to ceph-volume as to how many data devices should have their external volumes on a set of fast devices. These options are:

- `--block-db-slots`
- `--block-wal-slots`
- `--journal-slots`

For example, consider an OSD host that is supposed to contain 5 data devices and one device for wal/db volumes. However, one data device is currently broken and is being replaced. Instead of calculating the explicit sizes for the wal/db volume, one can simply call:

```
$ ceph-volume lvm batch --report /dev/sdb /dev/sdc /dev/sdd /dev/sde --db-devices /dev/nvme0n1 --block-db-slots 5
```

## Explicit sizing

It is also possible to provide explicit sizes to ceph-volume via the arguments

- `--block-db-size`
- `--block-wal-size`
- `--journal-size`

ceph-volume will try to satisfy the requested sizes given the passed disks. If this is not possible, no OSDs will be deployed.

# Idempotency and disk replacements

ceph-volume lvm batch intends to be idempotent, i.e. calling the same command repeatedly must result in the same outcome. For example calling:

```
$ ceph-volume lvm batch --report /dev/sdb /dev/sdc /dev/sdd --db-devices /dev/nvme0n1
```

will result in three deployed OSDs (if all disks were available). Calling this command again, you will still end up with three OSDs and ceph-volume will exit with return code 0.

Suppose /dev/sdc goes bad and needs to be replaced. After destroying the OSD and replacing the hardware, you can again call the same command and ceph-volume will detect that only two out of the three wanted OSDs are setup and re-create the missing OSD.

This idempotency notion is tightly coupled to and extensively used by [Advanced OSD Service Specifications](https://docs.ceph.com/en/latest/cephadm/osd/#drivegroups).

# Encryption

Logical volumes can be encrypted using `dmcrypt` by specifying the `--dmcrypt` flag when creating OSDs. Encryption can be done in different ways, specially with LVM. `ceph-volume` is somewhat opinionated with the way it sets up encryption with logical volumes so that the process is consistent and robust.

In this case, `ceph-volume lvm` follows these constraints:

- only LUKS (version 1) is used
- Logical Volumes are encrypted, while their underlying PVs (physical volumes) aren’t
- Non-LVM devices like partitions are also encrypted with the same OSD key

## LUKS

There are currently two versions of LUKS, 1 and 2. Version 2 is a bit easier to implement but not widely available in all distros Ceph supports. LUKS 1 is not going to be deprecated in favor of LUKS 2, so in order to have as wide support as possible, `ceph-volume` uses LUKS version 1.

Note

Version 1 of LUKS is just referenced as “LUKS” whereas version 2 is referred to as LUKS2

## LUKS on LVM

Encryption is done on top of existing logical volumes (unlike encrypting the physical device). Any single logical volume can be encrypted while other volumes can remain unencrypted. This method also allows for flexible logical volume setups, since encryption will happen once the LV is created.

## Workflow

When setting up the OSD, a secret key will be created, that will be passed along to the monitor in JSON format as `stdin` to prevent the key from being captured in the logs.

The JSON payload looks something like:

```
{
    "cephx_secret": CEPHX_SECRET,
    "dmcrypt_key": DMCRYPT_KEY,
    "cephx_lockbox_secret": LOCKBOX_SECRET,
}
```

The naming convention for the keys is **strict**, and they are named like that for the hardcoded (legacy) names ceph-disk used.

- `cephx_secret` : The cephx key used to authenticate
- `dmcrypt_key` : The secret (or private) key to unlock encrypted devices
- `cephx_lockbox_secret` : The authentication key used to retrieve the `dmcrypt_key`. It is named *lockbox* because ceph-disk used to have an unencrypted partition named after it, used to store public keys and other OSD metadata.

The naming convention is strict because Monitors supported the naming convention by ceph-disk, which used these key names. In order to keep compatibility and prevent ceph-disk from breaking, ceph-volume will use the same naming convention *although they don’t make sense for the new encryption workflow*.

After the common steps of setting up the OSD during the prepare stage, either with [filestore](https://docs.ceph.com/en/latest/glossary/#term-filestore) or [bluestore](https://docs.ceph.com/en/latest/glossary/#term-bluestore), the logical volume is left ready to be activated, regardless of the state of the device (encrypted or decrypted).

At activation time, the logical volume will get decrypted and the OSD started once the process completes correctly.

Summary of the encryption workflow for creating a new OSD:

1. OSD is created, both lockbox and dmcrypt keys are created, and sent along with JSON to the monitors, indicating an encrypted OSD.
2. All complementary devices (like journal, db, or wal) get created and encrypted with the same OSD key. Key is stored in the LVM metadata of the OSD
3. Activation continues by ensuring devices are mounted, retrieving the dmcrypt secret key from the monitors and decrypting before the OSD gets started.

# `prepare`

This subcommand allows a [filestore](https://docs.ceph.com/en/latest/glossary/#term-filestore) or [bluestore](https://docs.ceph.com/en/latest/glossary/#term-bluestore) setup. It is recommended to pre-provision a logical volume before using it with `ceph-volume lvm`.

Logical volumes are not altered except for adding extra metadata.

Note

This is part of a two step process to deploy an OSD. If looking for a single-call way, please see [create](https://docs.ceph.com/en/latest/ceph-volume/lvm/create/#ceph-volume-lvm-create)

To help identify volumes, the process of preparing a volume (or volumes) to work with Ceph, the tool will assign a few pieces of metadata information using [LVM tags](https://docs.ceph.com/en/latest/glossary/#term-LVM-tags).

[LVM tags](https://docs.ceph.com/en/latest/glossary/#term-LVM-tags) makes volumes easy to discover later, and help identify them as part of a Ceph system, and what role they have (journal, filestore, bluestore, etc…)

Although [bluestore](https://docs.ceph.com/en/latest/glossary/#term-bluestore) is the default, the back end can be specified with:

- [–filestore](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#ceph-volume-lvm-prepare-filestore)
- [–bluestore](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#ceph-volume-lvm-prepare-bluestore)



## `bluestore`

The [bluestore](https://docs.ceph.com/en/latest/glossary/#term-bluestore) objectstore is the default for new OSDs. It offers a bit more flexibility for devices compared to [filestore](https://docs.ceph.com/en/latest/glossary/#term-filestore). Bluestore supports the following configurations:

- A block device, a block.wal, and a block.db device
- A block device and a block.wal device
- A block device and a block.db device
- A single block device

The bluestore subcommand accepts physical block devices, partitions on physical block devices or logical volumes as arguments for the various device parameters If a physical device is provided, a logical volume will be created. A volume group will either be created or reused it its name begins with `ceph`. This allows a simpler approach at using LVM but at the cost of flexibility: there are no options or configurations to change how the LV is created.

The `block` is specified with the `--data` flag, and in its simplest use case it looks like:

```
ceph-volume lvm prepare --bluestore --data vg/lv
```

A raw device can be specified in the same way:

```
ceph-volume lvm prepare --bluestore --data /path/to/device
```

For enabling [encryption](https://docs.ceph.com/en/latest/ceph-volume/lvm/encryption/#ceph-volume-lvm-encryption), the `--dmcrypt` flag is required:

```
ceph-volume lvm prepare --bluestore --dmcrypt --data vg/lv
```

If a `block.db` or a `block.wal` is needed (they are optional for bluestore) they can be specified with `--block.db` and `--block.wal` accordingly. These can be a physical device, a partition  or a logical volume.

For both `block.db` and `block.wal` partitions aren’t made logical volumes because they can be used as-is.

While creating the OSD directory, the process will use a `tmpfs` mount to place all the files needed for the OSD. These files are initially created by `ceph-osd --mkfs` and are fully ephemeral.

A symlink is always created for the `block` device, and optionally for `block.db` and `block.wal`. For a cluster with a default name, and an OSD id of 0, the directory could look like:

```bash
# ls -l /var/lib/ceph/osd/ceph-0
lrwxrwxrwx. 1 ceph ceph 93 Oct 20 13:05 block -> /dev/ceph-be2b6fbd-bcf2-4c51-b35d-a35a162a02f0/osd-block-25cf0a05-2bc6-44ef-9137-79d65bd7ad62
lrwxrwxrwx. 1 ceph ceph 93 Oct 20 13:05 block.db -> /dev/sda1
lrwxrwxrwx. 1 ceph ceph 93 Oct 20 13:05 block.wal -> /dev/ceph/osd-wal-0
-rw-------. 1 ceph ceph 37 Oct 20 13:05 ceph_fsid
-rw-------. 1 ceph ceph 37 Oct 20 13:05 fsid
-rw-------. 1 ceph ceph 55 Oct 20 13:05 keyring
-rw-------. 1 ceph ceph  6 Oct 20 13:05 ready
-rw-------. 1 ceph ceph 10 Oct 20 13:05 type
-rw-------. 1 ceph ceph  2 Oct 20 13:05 whoami
```

In the above case, a device was used for `block` so `ceph-volume` create a volume group and a logical volume using the following convention:

- volume group name: `ceph-{cluster fsid}` or if the vg exists already `ceph-{random uuid}`
- logical volume name: `osd-block-{osd_fsid}`



## `filestore`

This is the OSD backend that allows preparation of logical volumes for a [filestore](https://docs.ceph.com/en/latest/glossary/#term-filestore) objectstore OSD.

It can use a logical volume for the OSD data and a physical device, a partition or logical volume for the journal. A physical device will have a logical volume created on it. A volume group will either be created or reused it its name begins with `ceph`.  No special preparation is needed for these volumes other than following the minimum size requirements for data and journal.

The CLI call looks like this of a basic standalone filestore OSD:

```
ceph-volume lvm prepare --filestore --data <data block device>
```

To deploy file store with an external journal:

```
ceph-volume lvm prepare --filestore --data <data block device> --journal <journal block device>
```

For enabling [encryption](https://docs.ceph.com/en/latest/ceph-volume/lvm/encryption/#ceph-volume-lvm-encryption), the `--dmcrypt` flag is required:

```
ceph-volume lvm prepare --filestore --dmcrypt --data <data block device> --journal <journal block device>
```

Both the journal and data block device can take three forms:

- a physical block device
- a partition on a physical block device
- a logical volume

When using logical volumes the value *must* be of the format `volume_group/logical_volume`. Since logical volume names are not enforced for uniqueness, this prevents accidentally choosing the wrong volume.

When using a partition, it *must* contain a `PARTUUID`, that can be discovered by `blkid`. THis ensure it can later be identified correctly regardless of the device name (or path).

For example: passing a logical volume for data and a partition `/dev/sdc1` for the journal:

```
ceph-volume lvm prepare --filestore --data volume_group/lv_name --journal /dev/sdc1
```

Passing a bare device for data and a logical volume ias the journal:

```
ceph-volume lvm prepare --filestore --data /dev/sdc --journal volume_group/journal_lv
```

A generated uuid is used to ask the cluster for a new OSD. These two pieces are crucial for identifying an OSD and will later be used throughout the [activate](https://docs.ceph.com/en/latest/ceph-volume/lvm/activate/#ceph-volume-lvm-activate) process.

The OSD data directory is created using the following convention:

```
/var/lib/ceph/osd/<cluster name>-<osd id>
```

At this point the data volume is mounted at this location, and the journal volume is linked:

```
ln -s /path/to/journal /var/lib/ceph/osd/<cluster_name>-<osd-id>/journal
```

The monmap is fetched using the bootstrap key from the OSD:

```
/usr/bin/ceph --cluster ceph --name client.bootstrap-osd
--keyring /var/lib/ceph/bootstrap-osd/ceph.keyring
mon getmap -o /var/lib/ceph/osd/<cluster name>-<osd id>/activate.monmap
```

`ceph-osd` will be called to populate the OSD directory, that is already mounted, re-using all the pieces of information from the initial steps:

```
ceph-osd --cluster ceph --mkfs --mkkey -i <osd id> \
--monmap /var/lib/ceph/osd/<cluster name>-<osd id>/activate.monmap --osd-data \
/var/lib/ceph/osd/<cluster name>-<osd id> --osd-journal /var/lib/ceph/osd/<cluster name>-<osd id>/journal \
--osd-uuid <osd uuid> --keyring /var/lib/ceph/osd/<cluster name>-<osd id>/keyring \
--setuser ceph --setgroup ceph
```



## Partitioning

`ceph-volume lvm` does not currently create partitions from a whole device. If using device partitions the only requirement is that they contain the `PARTUUID` and that it is discoverable by `blkid`. Both `fdisk` and `parted` will create that automatically for a new partition.

For example, using a new, unformatted drive (`/dev/sdd` in this case) we can use `parted` to create a new partition. First we list the device information:

```
$ parted --script /dev/sdd print
Model: VBOX HARDDISK (scsi)
Disk /dev/sdd: 11.5GB
Sector size (logical/physical): 512B/512B
Disk Flags:
```

This device is not even labeled yet, so we can use `parted` to create a `gpt` label before we create a partition, and verify again with `parted print`:

```
$ parted --script /dev/sdd mklabel gpt
$ parted --script /dev/sdd print
Model: VBOX HARDDISK (scsi)
Disk /dev/sdd: 11.5GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:
```

Now lets create a single partition, and verify later if `blkid` can find a `PARTUUID` that is needed by `ceph-volume`:

```
$ parted --script /dev/sdd mkpart primary 1 100%
$ blkid /dev/sdd1
/dev/sdd1: PARTLABEL="primary" PARTUUID="16399d72-1e1f-467d-96ee-6fe371a7d0d4"
```



## Existing OSDs

For existing clusters that want to use this new system and have OSDs that are already running there are a few things to take into account:

Warning

this process will forcefully format the data device, destroying existing data, if any.

- OSD paths should follow this convention:

  ```
  /var/lib/ceph/osd/<cluster name>-<osd id>
  ```

- Preferably, no other mechanisms to mount the volume should exist, and should be removed (like fstab mount points)

The one time process for an existing OSD, with an ID of 0 and using a `"ceph"` cluster name would look like (the following command will **destroy any data** in the OSD):

```
ceph-volume lvm prepare --filestore --osd-id 0 --osd-fsid E3D291C1-E7BF-4984-9794-B60D9FA139CB
```

The command line tool will not contact the monitor to generate an OSD ID and will format the LVM device in addition to storing the metadata on it so that it can be started later (for detailed metadata description see [Metadata](https://docs.ceph.com/en/latest/dev/ceph-volume/lvm/#ceph-volume-lvm-tags)).

## Crush device class

To set the crush device class for the OSD, use the `--crush-device-class` flag. This will work for both bluestore and filestore OSDs:

```
ceph-volume lvm prepare --bluestore --data vg/lv --crush-device-class foo
```



## `multipath` support

`multipath` devices are support if `lvm` is configured properly.

**Leave it to LVM**

Most Linux distributions should ship their LVM2 package with `multipath_component_detection = 1` in the default configuration. With this setting `LVM` ignores any device that is a multipath component and `ceph-volume` will accordingly not touch these devices.

**Using filters**

Should this setting be unavailable, a correct `filter` expression must be provided in `lvm.conf`. `ceph-volume` must not be able to use both the multipath device and its multipath components.

## Storing metadata

The following tags will get applied as part of the preparation process regardless of the type of volume (journal or data) or OSD objectstore:

- `cluster_fsid`
- `encrypted`
- `osd_fsid`
- `osd_id`
- `crush_device_class`

For [filestore](https://docs.ceph.com/en/latest/glossary/#term-filestore) these tags will be added:

- `journal_device`
- `journal_uuid`

For [bluestore](https://docs.ceph.com/en/latest/glossary/#term-bluestore) these tags will be added:

- `block_device`
- `block_uuid`
- `db_device`
- `db_uuid`
- `wal_device`
- `wal_uuid`

Note

For the complete lvm tag conventions see [Tag API](https://docs.ceph.com/en/latest/dev/ceph-volume/lvm/#ceph-volume-lvm-tag-api)

## Summary

To recap the `prepare` process for [bluestore](https://docs.ceph.com/en/latest/glossary/#term-bluestore):

1. Accepts raw physical devices, partitions on physical devices or logical volumes as arguments.
2. Creates logical volumes on any raw physical devices.
3. Generate a UUID for the OSD
4. Ask the monitor get an OSD ID reusing the generated UUID
5. OSD data directory is created on a tmpfs mount.
6. `block`, `block.wal`, and `block.db` are symlinked if defined.
7. monmap is fetched for activation
8. Data directory is populated by `ceph-osd`
9. Logical Volumes are assigned all the Ceph metadata using lvm tags

And the `prepare` process for [filestore](https://docs.ceph.com/en/latest/glossary/#term-filestore):

1. Accepts raw physical devices, partitions on physical devices or logical volumes as arguments.
2. Generate a UUID for the OSD
3. Ask the monitor get an OSD ID reusing the generated UUID
4. OSD data directory is created and data volume mounted
5. Journal is symlinked from data volume to journal location
6. monmap is fetched for activation
7. devices is mounted and data directory is populated by `ceph-osd`
8. data and journal volumes are assigned all the Ceph metadata using lvm tags

# `create`

This subcommand wraps the two-step process to provision a new osd (calling `prepare` first and then `activate`) into a single one. The reason to prefer `prepare` and then `activate` is to gradually introduce new OSDs into a cluster, and avoiding large amounts of data being rebalanced.

The single-call process unifies exactly what [prepare](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#ceph-volume-lvm-prepare) and [activate](https://docs.ceph.com/en/latest/ceph-volume/lvm/activate/#ceph-volume-lvm-activate) do, with the convenience of doing it all at once.

There is nothing different to the process except the OSD will become up and in immediately after completion.

The backing objectstore can be specified with:

- [–filestore](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#ceph-volume-lvm-prepare-filestore)
- [–bluestore](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#ceph-volume-lvm-prepare-bluestore)

All command line flags and options are the same as `ceph-volume lvm prepare`. Please refer to [prepare](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#ceph-volume-lvm-prepare) for details.



# scan

This sub-command will allow to discover Ceph volumes previously setup by the tool by looking into the system’s logical volumes and their tags.

As part of the [prepare](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#ceph-volume-lvm-prepare) process, the logical volumes are assigned a few tags with important pieces of information.

Note

This sub-command is not yet implemented



# systemd

Upon startup, it will identify the logical volume using [LVM tags](https://docs.ceph.com/en/latest/glossary/#term-LVM-tags), finding a matching ID and later ensuring it is the right one with the [OSD uuid](https://docs.ceph.com/en/latest/glossary/#term-OSD-uuid).

After identifying the correct volume it will then proceed to mount it by using the OSD destination conventions, that is:

```
/var/lib/ceph/osd/<cluster name>-<osd id>
```

For our example OSD with an id of `0`, that means the identified device will be mounted at:

```
/var/lib/ceph/osd/ceph-0
```

Once that process is complete, a call will be made to start the OSD:

```
systemctl start ceph-osd@0
```

The systemd portion of this process is handled by the `ceph-volume lvm trigger` sub-command, which is only in charge of parsing metadata coming from systemd and startup, and then dispatching to `ceph-volume lvm activate` which would proceed with activation.



# `list`

This subcommand will list any devices (logical and physical) that may be associated with a Ceph cluster, as long as they contain enough metadata to allow for that discovery.

Output is grouped by the OSD ID associated with the devices, and unlike `ceph-disk` it does not provide any information for devices that aren’t associated with Ceph.

Command line options:

- `--format` Allows a `json` or `pretty` value. Defaults to `pretty` which will group the device information in a human-readable format.

## Full Reporting

When no positional arguments are used, a full reporting will be presented. This means that all devices and logical volumes found in the system will be displayed.

Full `pretty` reporting for two OSDs, one with a lv as a journal, and another one with a physical device may look similar to:

```
# ceph-volume lvm list


====== osd.1 =======

  [journal]    /dev/journals/journal1

      journal uuid              C65n7d-B1gy-cqX3-vZKY-ZoE0-IEYM-HnIJzs
      osd id                    1
      cluster fsid              ce454d91-d748-4751-a318-ff7f7aa18ffd
      type                      journal
      osd fsid                  661b24f8-e062-482b-8110-826ffe7f13fa
      data uuid                 SlEgHe-jX1H-QBQk-Sce0-RUls-8KlY-g8HgcZ
      journal device            /dev/journals/journal1
      data device               /dev/test_group/data-lv2
      devices                   /dev/sda

  [data]    /dev/test_group/data-lv2

      journal uuid              C65n7d-B1gy-cqX3-vZKY-ZoE0-IEYM-HnIJzs
      osd id                    1
      cluster fsid              ce454d91-d748-4751-a318-ff7f7aa18ffd
      type                      data
      osd fsid                  661b24f8-e062-482b-8110-826ffe7f13fa
      data uuid                 SlEgHe-jX1H-QBQk-Sce0-RUls-8KlY-g8HgcZ
      journal device            /dev/journals/journal1
      data device               /dev/test_group/data-lv2
      devices                   /dev/sdb

====== osd.0 =======

  [data]    /dev/test_group/data-lv1

      journal uuid              cd72bd28-002a-48da-bdf6-d5b993e84f3f
      osd id                    0
      cluster fsid              ce454d91-d748-4751-a318-ff7f7aa18ffd
      type                      data
      osd fsid                  943949f0-ce37-47ca-a33c-3413d46ee9ec
      data uuid                 TUpfel-Q5ZT-eFph-bdGW-SiNW-l0ag-f5kh00
      journal device            /dev/sdd1
      data device               /dev/test_group/data-lv1
      devices                   /dev/sdc

  [journal]    /dev/sdd1

      PARTUUID                  cd72bd28-002a-48da-bdf6-d5b993e84f3f
```

For logical volumes the `devices` key is populated with the physical devices associated with the logical volume. Since LVM allows multiple physical devices to be part of a logical volume, the value will be comma separated when using `pretty`, but an array when using `json`.

Note

Tags are displayed in a readable format. The `osd id` key is stored as a `ceph.osd_id` tag. For more information on lvm tag conventions see [Tag API](https://docs.ceph.com/en/latest/dev/ceph-volume/lvm/#ceph-volume-lvm-tag-api)

## Single Reporting

Single reporting can consume both devices and logical volumes as input (positional parameters). For logical volumes, it is required to use the group name as well as the logical volume name.

For example the `data-lv2` logical volume, in the `test_group` volume group can be listed in the following way:

```
# ceph-volume lvm list test_group/data-lv2


====== osd.1 =======

  [data]    /dev/test_group/data-lv2

      journal uuid              C65n7d-B1gy-cqX3-vZKY-ZoE0-IEYM-HnIJzs
      osd id                    1
      cluster fsid              ce454d91-d748-4751-a318-ff7f7aa18ffd
      type                      data
      osd fsid                  661b24f8-e062-482b-8110-826ffe7f13fa
      data uuid                 SlEgHe-jX1H-QBQk-Sce0-RUls-8KlY-g8HgcZ
      journal device            /dev/journals/journal1
      data device               /dev/test_group/data-lv2
      devices                   /dev/sdc
```

Note

Tags are displayed in a readable format. The `osd id` key is stored as a `ceph.osd_id` tag. For more information on lvm tag conventions see [Tag API](https://docs.ceph.com/en/latest/dev/ceph-volume/lvm/#ceph-volume-lvm-tag-api)

For plain disks, the full path to the device is required. For example, for a device like `/dev/sdd1` it can look like:

```
# ceph-volume lvm list /dev/sdd1


====== osd.0 =======

  [journal]    /dev/sdd1

      PARTUUID                  cd72bd28-002a-48da-bdf6-d5b993e84f3f
```

## `json` output

All output using `--format=json` will show everything the system has stored as metadata for the devices, including tags.

No changes for readability are done with `json` reporting, and all information is presented as-is. Full output as well as single devices can be listed.

For brevity, this is how a single logical volume would look with `json` output (note how tags aren’t modified):

```json
# ceph-volume lvm list --format=json test_group/data-lv1
{
    "0": [
        {
            "devices": ["/dev/sda"],
            "lv_name": "data-lv1",
            "lv_path": "/dev/test_group/data-lv1",
            "lv_tags": "ceph.cluster_fsid=ce454d91-d748-4751-a318-ff7f7aa18ffd,ceph.data_device=/dev/test_group/data-lv1,ceph.data_uuid=TUpfel-Q5ZT-eFph-bdGW-SiNW-l0ag-f5kh00,ceph.journal_device=/dev/sdd1,ceph.journal_uuid=cd72bd28-002a-48da-bdf6-d5b993e84f3f,ceph.osd_fsid=943949f0-ce37-47ca-a33c-3413d46ee9ec,ceph.osd_id=0,ceph.type=data",
            "lv_uuid": "TUpfel-Q5ZT-eFph-bdGW-SiNW-l0ag-f5kh00",
            "name": "data-lv1",
            "path": "/dev/test_group/data-lv1",
            "tags": {
                "ceph.cluster_fsid": "ce454d91-d748-4751-a318-ff7f7aa18ffd",
                "ceph.data_device": "/dev/test_group/data-lv1",
                "ceph.data_uuid": "TUpfel-Q5ZT-eFph-bdGW-SiNW-l0ag-f5kh00",
                "ceph.journal_device": "/dev/sdd1",
                "ceph.journal_uuid": "cd72bd28-002a-48da-bdf6-d5b993e84f3f",
                "ceph.osd_fsid": "943949f0-ce37-47ca-a33c-3413d46ee9ec",
                "ceph.osd_id": "0",
                "ceph.type": "data"
            },
            "type": "data",
            "vg_name": "test_group"
        }
    ]
}
```

## Synchronized information

Before any listing type, the lvm API is queried to ensure that physical devices that may be in use haven’t changed naming. It is possible that non-persistent devices like `/dev/sda1` could change to `/dev/sdb1`.

The detection is possible because the `PARTUUID` is stored as part of the metadata in the logical volume for the data lv. Even in the case of a journal that is a physical device, this information is still stored on the data logical volume associated with it.

If the name is no longer the same (as reported by `blkid` when using the `PARTUUID`), the tag will get updated and the report will use the newly refreshed information.

​              

# `zap`

This subcommand is used to zap lvs, partitions or raw devices that have been used by ceph OSDs so that they may be reused. If given a path to a logical volume it must be in the format of vg/lv. Any file systems present on the given lv or partition will be removed and all data will be purged.

Note

The lv or partition will be kept intact.

Note

If the logical volume, raw device or partition is being used for any ceph related mount points they will be unmounted.

Zapping a logical volume:

```
ceph-volume lvm zap {vg name/lv name}
```

Zapping a partition:

```
ceph-volume lvm zap /dev/sdc1
```

## Removing Devices

When zapping, and looking for full removal of the device (lv, vg, or partition) use the `--destroy` flag. A common use case is to simply deploy OSDs using a whole raw device. If you do so and then wish to reuse that device for another OSD you must use the `--destroy` flag when zapping so that the vgs and lvs that ceph-volume created on the raw device will be removed.

Note

Multiple devices can be accepted at once, to zap them all

Zapping a raw device and destroying any vgs or lvs present:

```
ceph-volume lvm zap /dev/sdc --destroy
```

This action can be performed on partitions, and logical volumes as well:

```
ceph-volume lvm zap /dev/sdc1 --destroy
ceph-volume lvm zap osd-vg/data-lv --destroy
```

Finally, multiple devices can be detected if filtering by OSD ID and/or OSD FSID. Either identifier can be used or both can be used at the same time. This is useful in situations where multiple devices associated with a specific ID need to be purged. When using the FSID, the filtering is stricter, and might not match other (possibly invalid) devices associated to an ID.

By ID only:

```
ceph-volume lvm zap --destroy --osd-id 1
```

By FSID:

```
ceph-volume lvm zap --destroy --osd-fsid 2E8FBE58-0328-4E3B-BFB7-3CACE4E9A6CE
```

By both:

```
ceph-volume lvm zap --destroy --osd-fsid 2E8FBE58-0328-4E3B-BFB7-3CACE4E9A6CE --osd-id 1
```

Warning

If the systemd unit associated with the OSD ID to be zapped is detected as running, the tool will refuse to zap until the daemon is stopped.



# `simple`

Implements the functionality needed to manage OSDs from the `simple` subcommand: `ceph-volume simple`

**Command Line Subcommands**

- [scan](https://docs.ceph.com/en/latest/ceph-volume/simple/scan/#ceph-volume-simple-scan)
- [activate](https://docs.ceph.com/en/latest/ceph-volume/simple/activate/#ceph-volume-simple-activate)
- [systemd](https://docs.ceph.com/en/latest/ceph-volume/simple/systemd/#ceph-volume-simple-systemd)

By *taking over* management, it disables all `ceph-disk` systemd units used to trigger devices at startup, relying on basic (customizable) JSON configuration and systemd for starting up OSDs.

This process involves two steps:

1. [Scan](https://docs.ceph.com/en/latest/ceph-volume/simple/scan/#ceph-volume-simple-scan) the running OSD or the data device
2. [Activate](https://docs.ceph.com/en/latest/ceph-volume/simple/activate/#ceph-volume-simple-activate) the scanned OSD

The scanning will infer everything that `ceph-volume` needs to start the OSD, so that when activation is needed, the OSD can start normally without getting interference from `ceph-disk`.

As part of the activation process the systemd units for `ceph-disk` in charge of reacting to `udev` events, are linked to `/dev/null` so that they are fully inactive.

​              

# `activate`

Once [scan](https://docs.ceph.com/en/latest/ceph-volume/simple/scan/#ceph-volume-simple-scan) has been completed, and all the metadata captured for an OSD has been persisted to `/etc/ceph/osd/{id}-{uuid}.json` the OSD is now ready to get “activated”.

This activation process **disables** all `ceph-disk` systemd units by masking them, to prevent the UDEV/ceph-disk interaction that will attempt to start them up at boot time.

The disabling of `ceph-disk` units is done only when calling `ceph-volume simple activate` directly, but is avoided when being called by systemd when the system is booting up.

The activation process requires using both the [OSD id](https://docs.ceph.com/en/latest/glossary/#term-OSD-id) and [OSD uuid](https://docs.ceph.com/en/latest/glossary/#term-OSD-uuid) To activate parsed OSDs:

```
ceph-volume simple activate 0 6cc43680-4f6e-4feb-92ff-9c7ba204120e
```

The above command will assume that a JSON configuration will be found in:

```
/etc/ceph/osd/0-6cc43680-4f6e-4feb-92ff-9c7ba204120e.json
```

Alternatively, using a path to a JSON file directly is also possible:

```
ceph-volume simple activate --file /etc/ceph/osd/0-6cc43680-4f6e-4feb-92ff-9c7ba204120e.json
```

## requiring uuids

The [OSD uuid](https://docs.ceph.com/en/latest/glossary/#term-OSD-uuid) is being required as an extra step to ensure that the right OSD is being activated. It is entirely possible that a previous OSD with the same id exists and would end up activating the incorrect one.

### Discovery

With OSDs previously scanned by `ceph-volume`, a *discovery* process is performed using `blkid` and `lvm`. There is currently support only for devices with GPT partitions and LVM logical volumes.

The GPT partitions will have a `PARTUUID` that can be queried by calling out to `blkid`, and the logical volumes will have a `lv_uuid` that can be queried against `lvs` (the LVM tool to list logical volumes).

This discovery process ensures that devices can be correctly detected even if they are repurposed into another system or if their name changes (as in the case of non-persisting names like `/dev/sda1`)

The JSON configuration file used to map what devices go to what OSD will then coordinate the mounting and symlinking as part of activation.

To ensure that the symlinks are always correct, if they exist in the OSD directory, the symlinks will be re-done.

A systemd unit will capture the [OSD id](https://docs.ceph.com/en/latest/glossary/#term-OSD-id) and [OSD uuid](https://docs.ceph.com/en/latest/glossary/#term-OSD-uuid) and persist it. Internally, the activation will enable it like:

```
systemctl enable ceph-volume@simple-$id-$uuid
```

For example:

```
systemctl enable ceph-volume@simple-0-8715BEB4-15C5-49DE-BA6F-401086EC7B41
```

Would start the discovery process for the OSD with an id of `0` and a UUID of `8715BEB4-15C5-49DE-BA6F-401086EC7B41`.

The systemd process will call out to activate passing the information needed to identify the OSD and its devices, and it will proceed to:

- # mount the device in the corresponding location (by convention this is

  `/var/lib/ceph/osd/<cluster name>-<osd id>/`)

\# ensure that all required devices are ready for that OSD and properly linked, regardless of objectstore used (filestore or bluestore). The symbolic link will **always** be re-done to ensure that the correct device is linked.

\# start the `ceph-osd@0` systemd unit



# `scan`

Scanning allows to capture any important details from an already-deployed OSD so that `ceph-volume` can manage it without the need of any other startup workflows or tools (like `udev` or `ceph-disk`). Encryption with LUKS or PLAIN formats is fully supported.

The command has the ability to inspect a running OSD, by inspecting the directory where the OSD data is stored, or by consuming the data partition. The command can also scan all running OSDs if no path or device is provided.

Once scanned, information will (by default) persist the metadata as JSON in a file in `/etc/ceph/osd`. This `JSON` file will use the naming convention of: `{OSD ID}-{OSD FSID}.json`. An OSD with an id of 1, and an FSID like `86ebd829-1405-43d3-8fd6-4cbc9b6ecf96` the absolute path of the file would be:

```
/etc/ceph/osd/1-86ebd829-1405-43d3-8fd6-4cbc9b6ecf96.json
```

The `scan` subcommand will refuse to write to this file if it already exists. If overwriting the contents is needed, the `--force` flag must be used:

```
ceph-volume simple scan --force {path}
```

If there is no need to persist the `JSON` metadata, there is support to send the contents to `stdout` (no file will be written):

```
ceph-volume simple scan --stdout {path}
```



## Running OSDs scan

Using this command without providing an OSD directory or device will scan the directories of any currently running OSDs. If a running OSD was not created by ceph-disk it will be ignored and not scanned.

To scan all running ceph-disk OSDs, the command would look like:

```
ceph-volume simple scan
```

## Directory scan

The directory scan will capture OSD file contents from interesting files. There are a few files that must exist in order to have a successful scan:

- `ceph_fsid`
- `fsid`
- `keyring`
- `ready`
- `type`
- `whoami`

If the OSD is encrypted, it will additionally add the following keys:

- `encrypted`
- `encryption_type`
- `lockbox_keyring`

In the case of any other file, as long as it is not a binary or a directory, it will also get captured and persisted as part of the JSON object.

The convention for the keys in the JSON object is that any file name will be a key, and its contents will be its value. If the contents are a single line (like in the case of the `whoami`) the contents are trimmed, and the newline is dropped. For example with an OSD with an id of 1, this is how the JSON entry would look like:

```
"whoami": "1",
```

For files that may have more than one line, the contents are left as-is, except for keyrings which are treated specially and parsed to extract the keyring. For example, a `keyring` that gets read as:

```
[osd.1]\n\tkey = AQBBJ/dZp57NIBAAtnuQS9WOS0hnLVe0rZnE6Q==\n
```

Would get stored as:

```
"keyring": "AQBBJ/dZp57NIBAAtnuQS9WOS0hnLVe0rZnE6Q==",
```

For a directory like `/var/lib/ceph/osd/ceph-1`, the command could look like:

```
ceph-volume simple scan /var/lib/ceph/osd/ceph1
```



## Device scan

When an OSD directory is not available (OSD is not running, or device is not mounted) the `scan` command is able to introspect the device to capture required data. Just like [Running OSDs scan](https://docs.ceph.com/en/latest/ceph-volume/simple/scan/#ceph-volume-simple-scan-directory), it would still require a few files present. This means that the device to be scanned **must be** the data partition of the OSD.

As long as the data partition of the OSD is being passed in as an argument, the sub-command can scan its contents.

In the case where the device is already mounted, the tool can detect this scenario and capture file contents from that directory.

If the device is not mounted, a temporary directory will be created, and the device will be mounted temporarily just for scanning the contents. Once contents are scanned, the device will be unmounted.

For a device like `/dev/sda1` which **must** be a data partition, the command could look like:

```
ceph-volume simple scan /dev/sda1
```



## `JSON` contents

The contents of the JSON object is very simple. The scan not only will persist information from the special OSD files and their contents, but will also validate paths and device UUIDs. Unlike what `ceph-disk` would do, by storing them in `{device type}_uuid` files, the tool will persist them as part of the device type key.

For example, a `block.db` device would look something like:

```
"block.db": {
    "path": "/dev/disk/by-partuuid/6cc43680-4f6e-4feb-92ff-9c7ba204120e",
    "uuid": "6cc43680-4f6e-4feb-92ff-9c7ba204120e"
},
```

But it will also persist the `ceph-disk` special file generated, like so:

```
"block.db_uuid": "6cc43680-4f6e-4feb-92ff-9c7ba204120e",
```

This duplication is in place because the tool is trying to ensure the following:

\# Support OSDs that may not have ceph-disk special files # Check the most up-to-date information on the device, by querying against LVM and `blkid` # Support both logical volumes and GPT devices

This is a sample `JSON` metadata, from an OSD that is using `bluestore`:

```json
{
    "active": "ok",
    "block": {
        "path": "/dev/disk/by-partuuid/40fd0a64-caa5-43a3-9717-1836ac661a12",
        "uuid": "40fd0a64-caa5-43a3-9717-1836ac661a12"
    },
    "block.db": {
        "path": "/dev/disk/by-partuuid/6cc43680-4f6e-4feb-92ff-9c7ba204120e",
        "uuid": "6cc43680-4f6e-4feb-92ff-9c7ba204120e"
    },
    "block.db_uuid": "6cc43680-4f6e-4feb-92ff-9c7ba204120e",
    "block_uuid": "40fd0a64-caa5-43a3-9717-1836ac661a12",
    "bluefs": "1",
    "ceph_fsid": "c92fc9eb-0610-4363-aafc-81ddf70aaf1b",
    "cluster_name": "ceph",
    "data": {
        "path": "/dev/sdr1",
        "uuid": "86ebd829-1405-43d3-8fd6-4cbc9b6ecf96"
    },
    "fsid": "86ebd829-1405-43d3-8fd6-4cbc9b6ecf96",
    "keyring": "AQBBJ/dZp57NIBAAtnuQS9WOS0hnLVe0rZnE6Q==",
    "kv_backend": "rocksdb",
    "magic": "ceph osd volume v026",
    "mkfs_done": "yes",
    "ready": "ready",
    "systemd": "",
    "type": "bluestore",
    "whoami": "3"
}
```

# systemd

Upon startup, it will identify the logical volume by loading the JSON file in `/etc/ceph/osd/{id}-{uuid}.json` corresponding to the instance name of the systemd unit.

After identifying the correct volume it will then proceed to mount it by using the OSD destination conventions, that is:

```
/var/lib/ceph/osd/{cluster name}-{osd id}
```

For our example OSD with an id of `0`, that means the identified device will be mounted at:

```
/var/lib/ceph/osd/ceph-0
```

Once that process is complete, a call will be made to start the OSD:

```
systemctl start ceph-osd@0
```

The systemd portion of this process is handled by the `ceph-volume simple trigger` sub-command, which is only in charge of parsing metadata coming from systemd and startup, and then dispatching to `ceph-volume simple activate` which would proceed with activation.

# `zfs`

Implements the functionality needed to deploy OSDs from the `zfs` subcommand: `ceph-volume zfs`

The current implementation only works for ZFS on FreeBSD

**Command Line Subcommands**

- [inventory](https://docs.ceph.com/en/latest/ceph-volume/zfs/inventory/#ceph-volume-zfs-inventory)

**Internal functionality**

There are other aspects of the `zfs` subcommand that are internal and not exposed to the user, these sections explain how these pieces work together, clarifying the workflows of the tool.

[zfs](https://docs.ceph.com/en/latest/dev/ceph-volume/zfs/#ceph-volume-zfs-api)



# `inventory`

The `inventory` subcommand queries a host’s disc inventory through GEOM and provides hardware information and metadata on every physical device.

This only works on a FreeBSD platform.

By default the command returns a short, human-readable report of all physical disks.

For programmatic consumption of this report pass `--format json` to generate a JSON formatted report. This report includes extensive information on the physical drives such as disk metadata (like model and size), logical volumes and whether they are used by ceph, and if the disk is usable by ceph and reasons why not.

A device path can be specified to report extensive information on a device in both plain and json format.

