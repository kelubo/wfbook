# ceph-volume[](https://docs.ceph.com/en/latest/ceph-volume/#ceph-volume)

Deploy OSDs with different device technologies like lvm or physical disks using pluggable tools ([lvm](https://docs.ceph.com/en/latest/ceph-volume/lvm/) itself is treated like a plugin) and trying to follow a predictable, and robust way of preparing, activating, and starting OSDs.

[Overview](https://docs.ceph.com/en/latest/ceph-volume/intro/#ceph-volume-overview) | [Plugin Guide](https://docs.ceph.com/en/latest/dev/ceph-volume/plugins/#ceph-volume-plugins) |

**Command Line Subcommands**

There is currently support for `lvm`, and plain disks (with GPT partitions) that may have been deployed with `ceph-disk`.

`zfs` support is available for running a FreeBSD cluster.

- [lvm](https://docs.ceph.com/en/latest/ceph-volume/lvm/#ceph-volume-lvm)
- [simple](https://docs.ceph.com/en/latest/ceph-volume/simple/#ceph-volume-simple)
- [zfs](https://docs.ceph.com/en/latest/ceph-volume/zfs/#ceph-volume-zfs)

**Node inventory**

The [inventory](https://docs.ceph.com/en/latest/ceph-volume/inventory/#ceph-volume-inventory) subcommand provides information and metadata about a nodes physical disk inventory.

## Migrating[](https://docs.ceph.com/en/latest/ceph-volume/#migrating)

Starting on Ceph version 13.0.0, `ceph-disk` is deprecated. Deprecation warnings will show up that will link to this page. It is strongly suggested that users start consuming `ceph-volume`. There are two paths for migrating:

1. Keep OSDs deployed with `ceph-disk`: The [simple](https://docs.ceph.com/en/latest/ceph-volume/simple/#ceph-volume-simple) command provides a way to take over the management while disabling `ceph-disk` triggers.
2. Redeploy existing OSDs with `ceph-volume`: This is covered in depth on [Replacing an OSD](https://docs.ceph.com/en/latest/rados/operations/add-or-rm-osds/#rados-replacing-an-osd)

For details on why `ceph-disk` was removed please see the [Why was ceph-disk replaced?](https://docs.ceph.com/en/latest/ceph-volume/intro/#ceph-disk-replaced) section.

### New deployments[](https://docs.ceph.com/en/latest/ceph-volume/#new-deployments)

For new deployments, [lvm](https://docs.ceph.com/en/latest/ceph-volume/lvm/#ceph-volume-lvm) is recommended, it can use any logical volume as input for data OSDs, or it can setup a minimal/naive logical volume from a device.

### Existing OSDs[](https://docs.ceph.com/en/latest/ceph-volume/#existing-osds)

If the cluster has OSDs that were provisioned with `ceph-disk`, then `ceph-volume` can take over the management of these with [simple](https://docs.ceph.com/en/latest/ceph-volume/simple/#ceph-volume-simple). A scan is done on the data device or OSD directory, and `ceph-disk` is fully disabled. Encryption is fully supported.

ceph体积

使用可插拔工具（lvm本身被视为插件），使用不同的设备技术（如lvm或物理磁盘）部署OSD，并尝试遵循一种可预测、可靠的方式来准备、激活和启动OSD。

概述|插件指南|

命令行子命令

目前支持lvm和普通磁盘（带有GPT分区），这些磁盘可能已与ceph磁盘一起部署。

zfs支持可用于运行FreeBSD集群。

lvm公司

易于理解的

zfs公司

节点库存

inventory子命令提供有关节点物理磁盘资源清册的信息和元数据。

正在迁移

从Ceph 13.0.0版开始，Ceph磁盘已弃用。将显示将链接到此页面的弃用警告。强烈建议用户开始消费ceph音量。有两种迁移路径：

使用ceph磁盘部署OSD：简单的命令提供了一种在禁用ceph磁盘触发器的同时接管管理的方法。

使用ceph卷重新部署现有的OSD：这将在替换OSD中详细介绍

有关为什么要删除ceph磁盘的详细信息，请参阅为什么要更换ceph磁盘？部分

新部署

对于新的部署，建议使用lvm，它可以使用任何逻辑卷作为数据OSD的输入，也可以从设备设置最小/原始逻辑卷。

现有OSD

如果集群具有配置了ceph磁盘的OSD，那么ceph卷可以通过简单的方式接管这些OSD的管理。扫描在数据设备或OSD目录上完成，并且ceph磁盘被完全禁用。完全支持加密。

# Overview[](https://docs.ceph.com/en/latest/ceph-volume/intro/#overview)

The `ceph-volume` tool aims to be a single purpose command line tool to deploy logical volumes as OSDs, trying to maintain a similar API to `ceph-disk` when preparing, activating, and creating OSDs.

It deviates from `ceph-disk` by not interacting or relying on the udev rules that come installed for Ceph. These rules allow automatic detection of previously setup devices that are in turn fed into `ceph-disk` to activate them.



# Replacing `ceph-disk`[](https://docs.ceph.com/en/latest/ceph-volume/intro/#replacing-ceph-disk)

The `ceph-disk` tool was created at a time when the project was required to support many different types of init systems (upstart, sysvinit, etc…) while being able to discover devices. This caused the tool to concentrate initially (and exclusively afterwards) on GPT partitions. Specifically on GPT GUIDs, which were used to label devices in a unique way to answer questions like:

- is this device a Journal?
- an encrypted data partition?
- was the device left partially prepared?

To solve these, it used `UDEV` rules to match the GUIDs, that would call `ceph-disk`, and end up in a back and forth between the `ceph-disk` systemd unit and the `ceph-disk` executable. The process was very unreliable and time consuming (a timeout of close to three hours **per OSD** had to be put in place), and would cause OSDs to not come up at all during the boot process of a node.

It was hard to debug, or even replicate these problems given the asynchronous behavior of `UDEV`.

Since the world-view of `ceph-disk` had to be GPT partitions exclusively, it meant that it couldn’t work with other technologies like LVM, or similar device mapper devices. It was ultimately decided to create something modular, starting with LVM support, and the ability to expand on other technologies as needed.

# GPT partitions are simple?[](https://docs.ceph.com/en/latest/ceph-volume/intro/#gpt-partitions-are-simple)

Although partitions in general are simple to reason about, `ceph-disk` partitions were not simple by any means. It required a tremendous amount of special flags in order to get them to work correctly with the device discovery workflow. Here is an example call to create a data partition:

```
/sbin/sgdisk --largest-new=1 --change-name=1:ceph data --partition-guid=1:f0fc39fd-eeb2-49f1-b922-a11939cf8a0f --typecode=1:89c57f98-2fe5-4dc0-89c1-f3ad0ceff2be --mbrtogpt -- /dev/sdb
```

Not only creating these was hard, but these partitions required devices to be exclusively owned by Ceph. For example, in some cases a special partition would be created when devices were encrypted, which would contain unencrypted keys. This was `ceph-disk` domain knowledge, which would not translate to a “GPT partitions are simple” understanding. Here is an example of that special partition being created:

```
/sbin/sgdisk --new=5:0:+10M --change-name=5:ceph lockbox --partition-guid=5:None --typecode=5:fb3aabf9-d25f-47cc-bf5e-721d181642be --mbrtogpt -- /dev/sdad
```

# Modularity[](https://docs.ceph.com/en/latest/ceph-volume/intro/#modularity)

`ceph-volume` was designed to be a modular tool because we anticipate that there are going to be lots of ways that people provision the hardware devices that we need to consider. There are already two: legacy ceph-disk devices that are still in use and have GPT partitions (handled by [simple](https://docs.ceph.com/en/latest/ceph-volume/simple/#ceph-volume-simple)), and lvm. SPDK devices where we manage NVMe devices directly from userspace are on the immediate horizon, where LVM won’t work there since the kernel isn’t involved at all.

# `ceph-volume lvm`[](https://docs.ceph.com/en/latest/ceph-volume/intro/#ceph-volume-lvm)

By making use of [LVM tags](https://docs.ceph.com/en/latest/glossary/#term-LVM-tags), the [lvm](https://docs.ceph.com/en/latest/ceph-volume/lvm/#ceph-volume-lvm) sub-command is able to store and later re-discover and query devices associated with OSDs so that they can later be activated.

# LVM performance penalty[](https://docs.ceph.com/en/latest/ceph-volume/intro/#lvm-performance-penalty)

In short: we haven’t been able to notice any significant performance penalties associated with the change to LVM. By being able to work closely with LVM, the ability to work with other device mapper technologies was a given: there is no technical difficulty in working with anything that can sit below a Logical Volume.

概述

ceph卷工具旨在成为一个将逻辑卷部署为OSD的单用途命令行工具，在准备、激活和创建OSD时，尝试维护与ceph磁盘类似的API。

它与ceph磁盘不同，因为它没有交互或依赖于为ceph安装的udev规则。这些规则允许自动检测先前设置的设备，这些设备依次被馈送到ceph磁盘以激活它们。

更换ceph磁盘

ceph磁盘工具是在项目需要支持许多不同类型的init系统（upstart、sysvinit等）同时能够发现设备时创建的。这导致该工具最初（以及之后）专注于GPT分区。特别是GPT GUID，用于以独特的方式标记设备，以回答以下问题：

这个设备是日记本吗？

加密数据分区？

器械是否部分准备好？

为了解决这些问题，它使用UDEV规则来匹配GUID，GUID将调用ceph-disk，并在ceph-disksystemd单元和ceph-disk可执行文件之间来回移动。该过程非常不可靠且耗时（每个OSD必须设置接近三个小时的超时），并且会导致在节点的启动过程中OSD根本无法启动。

考虑到UDEV的异步行为，很难调试甚至复制这些问题。

由于ceph磁盘的世界观必须是GPT分区，这意味着它不能与LVM等其他技术或类似的设备映射器设备一起工作。最终决定创建模块化的东西，从LVM支持开始，并根据需要扩展其他技术。

GPT分区很简单？

尽管分区一般来说很简单，但ceph磁盘分区无论如何都不简单。它需要大量的特殊标志才能使它们正确地与设备发现工作流一起工作。下面是创建数据分区的示例调用：

/sbin/sgdisk--最大新=1--更改名称=1:ceph  data--分区guid=1:f0fc39fd-eeb2-49f1-b922-a11939cf8a0f--类型代码=1:89c57f98-2fe5-4dc0-89c1-f3ad0eff2be--mbrtogpt--/dev/sdb

不仅创建这些分区很困难，而且这些分区要求设备由Ceph独家拥有。例如，在某些情况下，当设备加密时会创建一个特殊分区，其中包含未加密的密钥。这是ceph磁盘域知识，它不会转化为“GPT分区很简单”的理解。下面是正在创建的特殊分区的示例：

/sbin/sgdisk--new=5:0:+10M--change-name=5:ceph lockbox--partition  guid=5:None--typecode=5:fb3aabf9-d25f-47cc-bf5e-721d181642be--mbrtogpt--/dev/sdad

模块化

ceph  volume被设计成一个模块化工具，因为我们预计人们将有很多方式来提供我们需要考虑的硬件设备。已经有两个：仍在使用并具有GPT分区（由simple处理）的传统ceph磁盘设备和lvm。我们直接从用户空间管理NVMe设备的SPDK设备即将出现，LVM将无法在那里工作，因为根本不涉及内核。

ceph体积lvm

通过使用LVM标签，LVM子命令能够存储并稍后重新发现和查询与OSD相关的设备，以便稍后激活它们。

LVM性能损失

简而言之：我们还没有注意到与LVM变更相关的任何重大性能损失。通过能够与LVM紧密合作，可以与其他设备映射器技术合作：处理逻辑卷以下的任何东西都没有技术难度。

# systemd[](https://docs.ceph.com/en/latest/ceph-volume/systemd/#systemd)

As part of the activation process (either with [activate](https://docs.ceph.com/en/latest/ceph-volume/lvm/activate/#ceph-volume-lvm-activate) or [activate](https://docs.ceph.com/en/latest/ceph-volume/simple/activate/#ceph-volume-simple-activate)), systemd units will get enabled that will use the OSD id and uuid as part of their name. These units will be run when the system boots, and will proceed to activate their corresponding volumes via their sub-command implementation.

The API for activation is a bit loose, it only requires two parts: the subcommand to use and any extra meta information separated by a dash. This convention makes the units look like:

```
ceph-volume@{command}-{extra metadata}
```

The *extra metadata* can be anything needed that the subcommand implementing the processing might need. In the case of [lvm](https://docs.ceph.com/en/latest/ceph-volume/lvm/#ceph-volume-lvm) and [simple](https://docs.ceph.com/en/latest/ceph-volume/simple/#ceph-volume-simple), both look to consume the [OSD id](https://docs.ceph.com/en/latest/glossary/#term-OSD-id) and [OSD uuid](https://docs.ceph.com/en/latest/glossary/#term-OSD-uuid), but this is not a hard requirement, it is just how the sub-commands are implemented.

Both the command and extra metadata gets persisted by systemd as part of the *“instance name”* of the unit.  For example an OSD with an ID of 0, for the `lvm` sub-command would look like:

```
systemctl enable ceph-volume@lvm-0-0A3E1ED2-DA8A-4F0E-AA95-61DEC71768D6
```

The enabled unit is a [systemd oneshot](https://docs.ceph.com/en/latest/glossary/#term-systemd-oneshot) service, meant to start at boot after the local file system is ready to be used.

## Failure and Retries[](https://docs.ceph.com/en/latest/ceph-volume/systemd/#failure-and-retries)

It is common to have failures when a system is coming up online. The devices are sometimes not fully available and this unpredictable behavior may cause an OSD to not be ready to be used.

There are two configurable environment variables used to set the retry behavior:

- `CEPH_VOLUME_SYSTEMD_TRIES`: Defaults to 30
- `CEPH_VOLUME_SYSTEMD_INTERVAL`: Defaults to 5

The *“tries”* is a number that sets the maximum number of times the unit will attempt to activate an OSD before giving up.

The *“interval”* is a value in seconds that determines the waiting time before initiating another try at activating the OSD.

systemd

![img](moz-extension://e2e4c729-fe25-403a-a8cb-e6b819e0ad9b/assets/img/sound.svg)

系统d

作为激活过程的一部分（使用activate或activate），systemd单元将被启用，并将OSD id和uuid作为其名称的一部分。这些单元将在系统启动时运行，并通过其子命令实现激活相应的卷。

用于激活的API有点松散，它只需要两个部分：要使用的子命令和用破折号分隔的任何额外的元信息。这种惯例使单位看起来像：

ceph卷@｛命令｝-｛额外元数据｝

额外的元数据可以是实现处理的子命令可能需要的任何内容。在lvm和simple的情况下，两者都希望使用OSD id和OSD uuid，但这不是硬性要求，这只是子命令的实现方式。

命令和额外的元数据都由systemd作为单元“实例名称”的一部分持久化。例如，对于lvm子命令，ID为0的OSD如下所示：

systemctl启用ceph-volume@lvm-0-0A3E1ED2-DA8A-4F0E-AA95-61DEC71768D6

启用的单元是一个systemd-oneshot服务，用于在本地文件系统准备就绪后启动。

失败和重试

当系统上线时，通常会出现故障。设备有时不完全可用，这种不可预测的行为可能会导致OSD无法使用。

有两个可配置的环境变量用于设置重试行为：

CEPH VOLUME SYSTEMD TRIES:默认值为30

CEPH VOLUME SYSTEMD INTERVAL:默认值为5

“trys”是一个数字，用于设置设备在放弃前尝试激活OSD的最大次数。

“间隔”是一个以秒为单位的值，用于确定在启动另一次激活OSD之前的等待时间。

# `inventory`[](https://docs.ceph.com/en/latest/ceph-volume/inventory/#inventory)

The `inventory` subcommand queries a host’s disc inventory and provides hardware information and metadata on every physical device.

By default the command returns a short, human-readable report of all physical disks.

For programmatic consumption of this report pass `--format json` to generate a JSON formatted report. This report includes extensive information on the physical drives such as disk metadata (like model and size), logical volumes and whether they are used by ceph, and if the disk is usable by ceph and reasons why not.

A device path can be specified to report extensive information on a device in both plain and json format.

库存

inventory子命令查询主机的磁盘资源清册，并提供每个物理设备上的硬件信息和元数据。

默认情况下，该命令会返回所有物理磁盘的简短可读报告。

对于该报告的编程使用，传递--format json以生成json格式的报告。此报告包含有关物理驱动器的大量信息，如磁盘元数据（如型号和大小）、逻辑卷以及ceph是否使用这些磁盘，ceph是否可以使用磁盘以及原因。

可以指定设备路径以报告设备上的大量信息，包括普通格式和json格式。

# `drive-group`[](https://docs.ceph.com/en/latest/ceph-volume/drive-group/#drive-group)

The drive-group subcommand allows for passing [Advanced OSD Service Specifications](https://docs.ceph.com/en/latest/cephadm/services/osd/#drivegroups) specifications straight to ceph-volume as json. ceph-volume will then attempt to deploy this drive groups via the batch subcommand.

The specification can be passed via a file, string argument or on stdin. See the subcommand help for further details:

```
# ceph-volume drive-group --help
```

驱动器组

驱动器组子命令允许将高级OSD服务规范规范直接作为json传递给ceph卷。然后，ceph卷将尝试通过批处理子命令部署此驱动器组。

规范可以通过文件、字符串参数或stdin传递。有关详细信息，请参阅子命令帮助：

\#ceph卷驱动器组--帮助

# `lvm`[](https://docs.ceph.com/en/latest/ceph-volume/lvm/#lvm)

Implements the functionality needed to deploy OSDs from the `lvm` subcommand: `ceph-volume lvm`

**Command Line Subcommands**

- [prepare](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#ceph-volume-lvm-prepare)
- [activate](https://docs.ceph.com/en/latest/ceph-volume/lvm/activate/#ceph-volume-lvm-activate)
- [create](https://docs.ceph.com/en/latest/ceph-volume/lvm/create/#ceph-volume-lvm-create)
- [list](https://docs.ceph.com/en/latest/ceph-volume/lvm/list/#ceph-volume-lvm-list)
- [migrate](https://docs.ceph.com/en/latest/ceph-volume/lvm/migrate/#ceph-volume-lvm-migrate)
- [new-db](https://docs.ceph.com/en/latest/ceph-volume/lvm/newdb/#ceph-volume-lvm-newdb)
- [new-wal](https://docs.ceph.com/en/latest/ceph-volume/lvm/newwal/#ceph-volume-lvm-newwal)

**Internal functionality**

There are other aspects of the `lvm` subcommand that are internal and not exposed to the user, these sections explain how these pieces work together, clarifying the workflows of the tool.

lvm公司

实现从lvm子命令部署OSD所需的功能：ceph volume lvm

命令行子命令

准备

激活

创造

列表

迁徙

新建数据库

新墙

内部功能

lvm子命令还有其他方面是内部的，不向用户公开，这些部分解释了这些部分是如何协同工作的，阐明了该工具的工作流程。

# `activate`[](https://docs.ceph.com/en/latest/ceph-volume/lvm/activate/#activate)

Once [prepare](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#ceph-volume-lvm-prepare) is completed, and all the various steps that entails are done, the volume is ready to get “activated”.

This activation process enables a systemd unit that persists the OSD ID and its UUID (also called `fsid` in Ceph CLI tools), so that at boot time it can understand what OSD is enabled and needs to be mounted.

Note

The execution of this call is fully idempotent, and there is no side-effects when running multiple times

For OSDs deployed by cephadm, please refer to [Activate existing OSDs](https://docs.ceph.com/en/latest/cephadm/services/osd/#cephadm-osd-activate) instead.

## New OSDs[](https://docs.ceph.com/en/latest/ceph-volume/lvm/activate/#new-osds)

To activate newly prepared OSDs both the [OSD id](https://docs.ceph.com/en/latest/glossary/#term-OSD-id) and [OSD uuid](https://docs.ceph.com/en/latest/glossary/#term-OSD-uuid) need to be supplied. For example:

```
ceph-volume lvm activate --bluestore 0 0263644D-0BF1-4D6D-BC34-28BD98AE3BC8
```

Note

The UUID is stored in the `fsid` file in the OSD path, which is generated when [prepare](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#ceph-volume-lvm-prepare) is used.

## Activating all OSDs[](https://docs.ceph.com/en/latest/ceph-volume/lvm/activate/#activating-all-osds)

Note

For OSDs deployed by cephadm, please refer to [Activate existing OSDs](https://docs.ceph.com/en/latest/cephadm/services/osd/#cephadm-osd-activate) instead.

It is possible to activate all existing OSDs at once by using the `--all` flag. For example:

```
ceph-volume lvm activate --all
```

This call will inspect all the OSDs created by ceph-volume that are inactive and will activate them one by one. If any of the OSDs are already running, it will report them in the command output and skip them, making it safe to rerun (idempotent).

### requiring uuids[](https://docs.ceph.com/en/latest/ceph-volume/lvm/activate/#requiring-uuids)

The [OSD uuid](https://docs.ceph.com/en/latest/glossary/#term-OSD-uuid) is being required as an extra step to ensure that the right OSD is being activated. It is entirely possible that a previous OSD with the same id exists and would end up activating the incorrect one.

### dmcrypt[](https://docs.ceph.com/en/latest/ceph-volume/lvm/activate/#dmcrypt)

If the OSD was prepared with dmcrypt by ceph-volume, there is no need to specify `--dmcrypt` on the command line again (that flag is not available for the `activate` subcommand). An encrypted OSD will be automatically detected.

## Discovery[](https://docs.ceph.com/en/latest/ceph-volume/lvm/activate/#discovery)

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

\#. Mount the device in the corresponding location (by convention this is `/var/lib/ceph/osd/<cluster name>-<osd id>/`)

\#. Ensure that all required devices are ready for that OSD. In the case of a journal (when `--filestore` is selected) the device will be queried (with `blkid` for partitions, and lvm for logical volumes) to ensure that the correct device is being linked. The symbolic link will *always* be re-done to ensure that the correct device is linked.

1. Start the `ceph-osd@0` systemd unit

Note

The system infers the objectstore type (filestore or bluestore) by inspecting the LVM tags applied to the OSD devices

## Existing OSDs[](https://docs.ceph.com/en/latest/ceph-volume/lvm/activate/#existing-osds)

For existing OSDs that have been deployed with `ceph-disk`, they need to be scanned and activated [using the simple sub-command](https://docs.ceph.com/en/latest/ceph-volume/simple/#ceph-volume-simple). If a different tool was used then the only way to port them over to the new mechanism is to prepare them again (losing data). See [Existing OSDs](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#ceph-volume-lvm-existing-osds) for details on how to proceed.

## Summary[](https://docs.ceph.com/en/latest/ceph-volume/lvm/activate/#summary)

To recap the `activate` process for [bluestore](https://docs.ceph.com/en/latest/glossary/#term-BlueStore):

1. Require both [OSD id](https://docs.ceph.com/en/latest/glossary/#term-OSD-id) and [OSD uuid](https://docs.ceph.com/en/latest/glossary/#term-OSD-uuid)
2. Enable the system unit with matching id and uuid
3. Create the `tmpfs` mount at the OSD directory in `/var/lib/ceph/osd/$cluster-$id/`
4. Recreate all the files needed with `ceph-bluestore-tool prime-osd-dir` by pointing it to the OSD `block` device.
5. The systemd unit will ensure all devices are ready and linked
6. The matching `ceph-osd` systemd unit will get started

And for [filestore](https://docs.ceph.com/en/latest/glossary/#term-filestore):

1. Require both [OSD id](https://docs.ceph.com/en/latest/glossary/#term-OSD-id) and [OSD uuid](https://docs.ceph.com/en/latest/glossary/#term-OSD-uuid)
2. Enable the system unit with matching id and uuid
3. The systemd unit will ensure all devices are ready and mounted (if needed)
4. The matching `ceph-osd` systemd unit will get started

激活

一旦准备工作完成，所需的所有步骤都完成了，卷就可以“激活”了。

此激活过程启用了一个保留OSD ID及其UUID（在Ceph CLI工具中也称为fsid）的systemd单元，以便在启动时了解启用了什么OSD以及需要安装什么OSD。

笔记

此调用的执行是完全幂等的，并且在多次运行时没有副作用

对于cephadm部署的OSD，请参考激活现有OSD。

新OSD

要激活新准备的OSD，需要提供OSD id和OSD uuid。例如：

ceph音量lvm激活--bluestore 0 0263644D-0BF1-4D6D-BC34-28BD98AE3BC8

笔记

UUID存储在OSD路径中的fsid文件中，该文件在使用prepare时生成。

激活所有OSD

笔记

对于cephadm部署的OSD，请参考激活现有OSD。

使用--all标志可以一次激活所有现有的OSD。例如：

ceph音量lvm激活--全部

此调用将检查ceph卷创建的所有非活动OSD，并逐一激活它们。如果任何OSD已经在运行，它将在命令输出中报告它们并跳过它们，这样可以安全地重新运行（幂等）。

需要uuid

OSD uuid是确保激活正确OSD的额外步骤。完全有可能存在具有相同id的前一个OSD，并最终激活不正确的OSD。

dmcrypt

如果OSD是用dmcrypt by ceph volume准备的，则无需再次在命令行上指定--dmcryp（该标志不适用于activate子命令）。将自动检测加密的OSD。

发现

对于之前由ceph卷创建的OSD，使用LVM标记执行发现过程以启用systemd单元。

systemd单元将捕获OSD id和OSD uuid并将其持久化。在内部，激活将启用它，如：

systemctl启用ceph-volume@lvm-$id-$uuid

例如：

systemctl启用ceph-volume@lvm-0-8715BEB4-15C5-49DE-BA6F-401086EC7B41

将启动OSD的发现过程，id为0，UUID为8715BEB4-15C5-49DE-BA6F-401086EC7B41。

笔记

有关systemd工作流的详细信息，请参阅systemd

systemd单元将查找匹配的OSD设备，通过查看其LVM标签，将继续：

\#. 将设备安装到相应的位置（按照惯例，这是/var/lib/ceph/osd/-/）

\#. 确保所有所需设备都已准备好进行OSD。对于日志（当选择--filestore时），将查询设备（分区使用blkid，逻辑卷使用lvm），以确保链接了正确的设备。将始终重新进行符号链接，以确保链接了正确的设备。

启动ceph-osd@0systemd单位

笔记

系统通过检查应用于OSD设备的LVM标签来推断对象存储类型（文件存储或bluestore）

现有OSD

对于已经部署了ceph磁盘的现有OSD，需要使用简单的子命令扫描并激活它们。如果使用了不同的工具，那么将它们移植到新机制的唯一方法是再次准备它们（丢失数据）。有关如何继续的详细信息，请参阅现有OSD。

总结

回顾bluestore的激活过程：

需要OSD id和OSD uuid

启用具有匹配id和uuid的系统单元

在/var/lib/ceph/OSD/$cluster-$id中的OSD目录中创建tmpfs装载/

通过将ceph bluestore工具prime osd dir指向osd块设备，重新创建所需的所有文件。

systemd单元将确保所有设备均已就绪并连接

匹配的ceph-osd-systemd单元将启动

对于文件存储：

需要OSD id和OSD uuid

启用具有匹配id和uuid的系统单元

systemd单元将确保所有设备就绪并安装（如果需要）

匹配的ceph-osd-systemd单元将启动

# `batch`[](https://docs.ceph.com/en/latest/ceph-volume/lvm/batch/#batch)

The subcommand allows to create multiple OSDs at the same time given an input of devices. The `batch` subcommand is closely related to drive-groups. One individual drive group specification translates to a single `batch` invocation.

The subcommand is based to [create](https://docs.ceph.com/en/latest/ceph-volume/lvm/create/#ceph-volume-lvm-create), and will use the very same code path. All `batch` does is to calculate the appropriate sizes of all volumes and skip over already created volumes.

All the features that `ceph-volume lvm create` supports, like `dmcrypt`, avoiding `systemd` units from starting, defining bluestore or filestore, are supported.



## Automatic sorting of disks[](https://docs.ceph.com/en/latest/ceph-volume/lvm/batch/#automatic-sorting-of-disks)

If `batch` receives only a single list of data devices and other options are passed , `ceph-volume` will auto-sort disks by its rotational property and use non-rotating disks for `block.db` or `journal` depending on the objectstore used. If all devices are to be used for standalone OSDs, no matter if rotating or solid state, pass `--no-auto`. For example assuming [bluestore](https://docs.ceph.com/en/latest/glossary/#term-BlueStore) is used and `--no-auto` is not passed, the deprecated behavior would deploy the following, depending on the devices passed:

1. Devices are all spinning HDDs: 1 OSD is created per device
2. Devices are all SSDs: 2 OSDs are created per device
3. Devices are a mix of HDDs and SSDs: data is placed on the spinning device, the `block.db` is created on the SSD, as large as possible.

Note

Although operations in `ceph-volume lvm create` allow usage of `block.wal` it isn’t supported with the `auto` behavior.

This default auto-sorting behavior is now DEPRECATED and will be changed in future releases. Instead devices are not automatically sorted unless the `--auto` option is passed

- It is recommended to make use of the explicit device lists for `block.db`,

  `block.wal` and `journal`.



# Reporting[](https://docs.ceph.com/en/latest/ceph-volume/lvm/batch/#reporting)

By default `batch` will print a report of the computed OSD layout and ask the user to confirm. This can be overridden by passing `--yes`.

If one wants to try out several invocations with being asked to deploy `--report` can be passed. `ceph-volume` will exit after printing the report.

Consider the following invocation:

```
$ ceph-volume lvm batch --report /dev/sdb /dev/sdc /dev/sdd --db-devices /dev/nvme0n1
```

This will deploy three OSDs with external `db` and `wal` volumes on an NVME device.

## Pretty reporting[](https://docs.ceph.com/en/latest/ceph-volume/lvm/batch/#pretty-reporting)

The `pretty` report format (the default) would look like this:

```
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

## JSON reporting[](https://docs.ceph.com/en/latest/ceph-volume/lvm/batch/#json-reporting)

Reporting can produce a structured output with `--format json` or `--format json-pretty`:

```
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

# Sizing[](https://docs.ceph.com/en/latest/ceph-volume/lvm/batch/#sizing)

When no sizing arguments are passed, ceph-volume will derive the sizing from the passed device lists (or the sorted lists when using the automatic sorting). ceph-volume batch will attempt to fully utilize a device’s available capacity. Relying on automatic sizing is recommended.

If one requires a different sizing policy for wal, db or journal devices, ceph-volume offers implicit and explicit sizing rules.

## Implicit sizing[](https://docs.ceph.com/en/latest/ceph-volume/lvm/batch/#implicit-sizing)

Scenarios in which either devices are under-committed or not all data devices are currently ready for use (due to a broken disk for example), one can still rely on ceph-volume automatic sizing. Users can provide hints to ceph-volume as to how many data devices should have their external volumes on a set of fast devices. These options are:

- `--block-db-slots`
- `--block-wal-slots`
- `--journal-slots`

For example, consider an OSD host that is supposed to contain 5 data devices and one device for wal/db volumes. However, one data device is currently broken and is being replaced. Instead of calculating the explicit sizes for the wal/db volume, one can simply call:

```
$ ceph-volume lvm batch --report /dev/sdb /dev/sdc /dev/sdd /dev/sde --db-devices /dev/nvme0n1 --block-db-slots 5
```

## Explicit sizing[](https://docs.ceph.com/en/latest/ceph-volume/lvm/batch/#explicit-sizing)

It is also possible to provide explicit sizes to ceph-volume via the arguments

- `--block-db-size`
- `--block-wal-size`
- `--journal-size`

ceph-volume will try to satisfy the requested sizes given the passed disks. If this is not possible, no OSDs will be deployed.

# Idempotency and disk replacements[](https://docs.ceph.com/en/latest/ceph-volume/lvm/batch/#idempotency-and-disk-replacements)

ceph-volume lvm batch intends to be idempotent, i.e. calling the same command repeatedly must result in the same outcome. For example calling:

```
$ ceph-volume lvm batch --report /dev/sdb /dev/sdc /dev/sdd --db-devices /dev/nvme0n1
```

will result in three deployed OSDs (if all disks were available). Calling this command again, you will still end up with three OSDs and ceph-volume will exit with return code 0.

Suppose /dev/sdc goes bad and needs to be replaced. After destroying the OSD and replacing the hardware, you can again call the same command and ceph-volume will detect that only two out of the three wanted OSDs are setup and re-create the missing OSD.

This idempotency notion is tightly coupled to and extensively used by [Advanced OSD Service Specifications](https://docs.ceph.com/en/latest/cephadm/services/osd/#drivegroups).

一批

子命令允许在给定设备输入的同时创建多个OSD。批处理子命令与驱动器组密切相关。单个驱动器组规范转换为单个批处理调用。

子命令基于create，并将使用完全相同的代码路径。所有批处理都是计算所有卷的适当大小，并跳过已创建的卷。

ceph volume lvm创建的所有功能都受支持，如dmcrypt、避免系统d单元启动、定义bluestore或文件存储。

磁盘的自动排序

如果批处理仅接收到一个数据设备列表，并且传递了其他选项，ceph卷将根据其旋转属性自动对磁盘进行排序，并根据使用的对象存储将非旋转磁盘用于block.db或日志。如果所有设备都用于独立的OSD，无论是旋转的还是固态的，都要通过--不自动。例如，假设使用了bluestore并且--没有传递auto，则不推荐的行为将部署以下内容，具体取决于传递的设备：

设备都在旋转硬盘：每个设备创建1个OSD

设备都是SSD：每个设备创建2个OSD

设备是HDD和SSD的混合体：数据放在旋转设备上，block.db在SSD上创建，尽可能大。

笔记

尽管ceph volume lvm create中的操作允许使用block.wal，但自动行为不支持它。

此默认自动排序行为现在已弃用，并将在将来的版本中更改。相反，除非传递--auto选项，否则设备不会自动排序

建议使用block.db的显式设备列表，

block.wal和journal。

报告

默认情况下，批处理将打印计算OSD布局的报告，并要求用户确认。这可以通过传递--yes来覆盖。

若要尝试多次调用并被要求部署，则可以传递报告。ceph卷将在打印报告后退出。

考虑以下调用：

$ceph卷lvm批处理--报告/dev/sdb/dev/sdc/dev/sdd--db设备/dev/nvme0n1

这将在NVME设备上部署三个具有外部db和wal卷的OSD。

漂亮的报告

漂亮的报告格式（默认）如下所示：

$ceph卷lvm批处理--报告/dev/sdb/dev/sdc/dev/sdd--db设备/dev/nvme0n1

-->通过的数据设备：3个物理设备，0个LVM

-->相对数据大小：1.0

-->传递的块db设备：1个物理，0个LVM

OSD总数：3

类型路径LV设备大小%

\----------------------------------------------------------------------------------------------------

数据/dev/sdb 300.00 GB 100.00%

块db/dev/nvme0n1 66.67 GB 33.33%

\----------------------------------------------------------------------------------------------------

数据/dev/sdc 300.00 GB 100.00%

块db/dev/nvme0n1 66.67 GB 33.33%

\----------------------------------------------------------------------------------------------------

数据/dev/sdd 300.00 GB 100.00%

块db/dev/nvme0n1 66.67 GB 33.33%

JSON报告

报告可以生成具有--format json或--format json格式的结构化输出：

$ceph volume lvm batch--报告--格式json pretty/dev/sdb/dev/sdc/dev/sdd--db devices/dev/nvme0n1

-->通过的数据设备：3个物理设备，0个LVM

-->相对数据大小：1.0

-->传递的块db设备：1个物理，0个LVM

[

{

“block db”：“/dev/nvme0n1”，

“块db大小”：“66.67 GB”，

“data”：“/dev/sdb”，

“数据大小”：“300.00 GB”，

“加密”：“无”

},

{

“block db”：“/dev/nvme0n1”，

“块db大小”：“66.67 GB”，

“data”：“/dev/sdc”，

“数据大小”：“300.00 GB”，

“加密”：“无”

},

{

“block db”：“/dev/nvme0n1”，

“块db大小”：“66.67 GB”，

“data”：“/dev/sdd”，

“数据大小”：“300.00 GB”，

“加密”：“无”

}

]

尺寸

如果没有传递大小调整参数，ceph卷将从传递的设备列表（或使用自动排序时的排序列表）中导出大小调整。ceph卷批处理将尝试充分利用设备的可用容量。建议依靠自动调整大小。

如果需要对wal、db或日志设备使用不同的大小调整策略，ceph-volume提供了隐式和显式的大小调整规则。

隐式调整大小

任一设备未提交或未全部提交的情况

# Encryption[](https://docs.ceph.com/en/latest/ceph-volume/lvm/encryption/#encryption)

Logical volumes can be encrypted using `dmcrypt` by specifying the `--dmcrypt` flag when creating OSDs. When using LVM, logical volumes can be encrypted in different ways. `ceph-volume` does not offer as many options as LVM does, but it encrypts logical volumes in a way that  is consistent and robust.

In this case, `ceph-volume lvm` follows this constraint:

- Non-LVM devices (such as partitions) are encrypted with the same OSD key.

## LUKS[](https://docs.ceph.com/en/latest/ceph-volume/lvm/encryption/#luks)

There are currently two versions of LUKS, 1 and 2. Version 2 is a bit easier to implement but not widely available in all Linux distributions supported by Ceph.

Note

Version 1 of LUKS is referred to in this documentation as “LUKS”. Version 2 is of LUKS is referred to in this documentation as “LUKS2”.

## LUKS on LVM[](https://docs.ceph.com/en/latest/ceph-volume/lvm/encryption/#luks-on-lvm)

Encryption is done on top of existing logical volumes (this is not the same as encrypting the physical device). Any single logical volume can be encrypted, leaving other volumes unencrypted. This method also allows for flexible logical volume setups, since encryption will happen once the LV is created.

## Workflow[](https://docs.ceph.com/en/latest/ceph-volume/lvm/encryption/#workflow)

When setting up the OSD, a secret key is created. That secret key is passed to the monitor in JSON format as `stdin` to prevent the key from being captured in the logs.

The JSON payload looks something like this:

```
{
    "cephx_secret": CEPHX_SECRET,
    "dmcrypt_key": DMCRYPT_KEY,
    "cephx_lockbox_secret": LOCKBOX_SECRET,
}
```

The naming convention for the keys is **strict**, and they are named like that for the hardcoded (legacy) names used by ceph-disk.

- `cephx_secret` : The cephx key used to authenticate
- `dmcrypt_key` : The secret (or private) key to unlock encrypted devices
- `cephx_lockbox_secret` : The authentication key used to retrieve the `dmcrypt_key`. It is named *lockbox* because ceph-disk used to have an unencrypted partition named after it, which was used to store public keys and other OSD metadata.

The naming convention is strict because Monitors supported the naming convention of ceph-disk, which used these key names. In order to maintain compatibility and prevent ceph-disk from breaking, ceph-volume uses the same naming convention *although it does not make sense for the new encryption workflow*.

After the common steps of setting up the OSD during the “prepare stage” (either with [filestore](https://docs.ceph.com/en/latest/glossary/#term-filestore) or [bluestore](https://docs.ceph.com/en/latest/glossary/#term-BlueStore)), the logical volume is left ready to be activated, regardless of the state of the device (encrypted or decrypted).

At the time of its activation, the logical volume is decrypted. The OSD starts after the process completes correctly.

## Summary of the encryption workflow for creating a new OSD[](https://docs.ceph.com/en/latest/ceph-volume/lvm/encryption/#summary-of-the-encryption-workflow-for-creating-a-new-osd)

1. OSD is created. Both lockbox and dmcrypt keys are created and sent to the monitors in JSON format, indicating an encrypted OSD.
2. All complementary devices (like journal, db, or wal) get created and encrypted with the same OSD key. Key is stored in the LVM metadata of the OSD.
3. Activation continues by ensuring devices are mounted, retrieving the dmcrypt secret key from the monitors, and decrypting before the OSD gets started.

加密

通过在创建OSD时指定--dmcrypt标志，可以使用dmcryp加密逻辑卷。使用LVM时，可以用不同的方式对逻辑卷进行加密。ceph-volume没有LVM提供的那么多选项，但它以一致和健壮的方式加密逻辑卷。

在这种情况下，ceph体积lvm遵循以下约束：

非LVM设备（如分区）使用相同的OSD密钥加密。

卢克

目前有两种版本的LUKS，1和2。版本2更容易实现，但在Ceph支持的所有Linux发行版中并不广泛。

笔记

LUKS版本1在本文件中称为“LUKS”。LUKS版本2在本文件中称为“LUKS2”。

LVM上的行李

加密是在现有逻辑卷之上完成的（这与加密物理设备不同）。任何单个逻辑卷都可以加密，而其他卷不加密。这种方法还允许灵活的逻辑卷设置，因为一旦创建LV，就会进行加密。

工作流

设置OSD时，会创建一个密钥。该密钥以JSON格式作为stdin传递给监视器，以防止在日志中捕获密钥。

JSON有效负载如下所示：

{

“cephx secret”：cephx secret，

“dmcrypt key”：dmcrypt key，

“cephx锁箱机密”：锁箱机密，

}

密钥的命名约定是严格的，它们的命名方式与ceph磁盘使用的硬编码（传统）名称相同。

cephx secret：用于身份验证的cephx密钥

dmcrypt密钥：用于解锁加密设备的密钥

cephx lockbox secret：用于检索dmcrypt密钥的身份验证密钥。它之所以被命名为lockbox，是因为ceph磁盘曾经有一个未加密的分区以其命名，用于存储公钥和其他OSD元数据。

命名约定是严格的，因为监视器支持使用这些密钥名称的ceph磁盘的命名约定。为了保持兼容性并防止ceph磁盘损坏，ceph卷使用了相同的命名约定，尽管它对新的加密工作流没有意义。

在“准备阶段”（使用文件存储或bluestore）设置OSD的常见步骤之后，无论设备的状态如何（加密或解密），逻辑卷都可以随时激活。

在其激活时，逻辑卷被解密。OSD在过程正确完成后启动。

创建新OSD的加密工作流摘要

OSD已创建。lockbox和dmcrypt密钥都是以JSON格式创建并发送给监视器的，表示一个加密的OSD。

所有补充设备（如日志、数据库或沃尔）都使用相同的OSD密钥创建和加密。密钥存储在OSD的LVM元数据中。

通过确保设备已安装，从监视器中检索dmcrypt密钥，并在OSD开始之前解密，激活将继续。

# `prepare`[](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#prepare)

Before you run `ceph-volume lvm prepare`, we recommend that you provision a logical volume. Then you can run `prepare` on that logical volume.

`prepare` adds metadata to logical volumes but does not alter them in any other way.

Note

This is part of a two-step process to deploy an OSD. If you prefer to deploy an OSD by using only one command, see [create](https://docs.ceph.com/en/latest/ceph-volume/lvm/create/#ceph-volume-lvm-create).

`prepare` uses [LVM tags](https://docs.ceph.com/en/latest/glossary/#term-LVM-tags) to assign several pieces of metadata to a logical volume. Volumes tagged in this way are easier to identify and easier to use with Ceph. [LVM tags](https://docs.ceph.com/en/latest/glossary/#term-LVM-tags) identify logical volumes by the role that they play in the Ceph cluster (for example: BlueStore data or BlueStore WAL+DB).

[BlueStore](https://docs.ceph.com/en/latest/glossary/#term-BlueStore) is the default backend. Ceph permits changing the backend, which can be done by using the following flags and arguments:

- [--filestore](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#ceph-volume-lvm-prepare-filestore)
- [--bluestore](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#ceph-volume-lvm-prepare-bluestore)



## `bluestore`[](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#bluestore)

[Bluestore](https://docs.ceph.com/en/latest/glossary/#term-BlueStore) is the default backend for new OSDs. It offers more flexibility for devices than [filestore](https://docs.ceph.com/en/latest/glossary/#term-filestore) does.  Bluestore supports the following configurations:

- a block device, a block.wal device, and a block.db device
- a block device and a block.wal device
- a block device and a block.db device
- a single block device

The `bluestore` subcommand accepts physical block devices, partitions on physical block devices, or logical volumes as arguments for the various device parameters. If a physical block device is provided, a logical volume will be created. If the provided volume group’s name begins with ceph, it will be created if it does not yet exist and it will be clobbered and reused if it already exists. This allows for a simpler approach to using LVM but at the cost of flexibility: no option or configuration can be used to change how the logical volume is created.

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

If a `block.db` device or a `block.wal` device is needed, it can be specified with `--block.db` or `--block.wal`. These can be physical devices, partitions, or logical volumes. `block.db` and `block.wal` are optional for bluestore.

For both `block.db` and `block.wal`, partitions can be used as-is, and therefore are not made into logical volumes.

While creating the OSD directory, the process uses a `tmpfs` mount to hold the files needed for the OSD. These files are created by `ceph-osd --mkfs` and are ephemeral.

A symlink is created for the `block` device, and is optional for `block.db` and `block.wal`. For a cluster with a default name and an OSD ID of 0, the directory looks like this:

```
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

In the above case, a device was used for `block`, so `ceph-volume` created a volume group and a logical volume using the following conventions:

- volume group name: `ceph-{cluster fsid}` (or if the volume group already exists: `ceph-{random uuid}`)
- logical volume name: `osd-block-{osd_fsid}`



## `filestore`[](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#filestore)

`Filestore<filestore>` is the OSD backend that prepares logical volumes for a [filestore](https://docs.ceph.com/en/latest/glossary/#term-filestore)-backed object-store OSD.

`Filestore<filestore>` uses a logical volume to store OSD data and it uses physical devices, partitions, or logical volumes to store the journal.  If a physical device is used to create a filestore backend, a logical volume will be created on that physical device. If the provided volume group’s name begins with ceph, it will be created if it does not yet exist and it will be clobbered and reused if it already exists. No special preparation is needed for these volumes, but be sure to meet the minimum size requirements for OSD data and for the journal.

Use the following command to create a basic filestore OSD:

```
ceph-volume lvm prepare --filestore --data <data block device>
```

Use this command to deploy filestore with an external journal:

```
ceph-volume lvm prepare --filestore --data <data block device> --journal <journal block device>
```

Use this command to enable [encryption](https://docs.ceph.com/en/latest/ceph-volume/lvm/encryption/#ceph-volume-lvm-encryption), and note that the `--dmcrypt` flag is required:

```
ceph-volume lvm prepare --filestore --dmcrypt --data <data block device> --journal <journal block device>
```

The data block device and the journal can each take one of three forms:

- a physical block device
- a partition on a physical block device
- a logical volume

If you use a logical volume to deploy filestore, the value that you pass in the command *must* be of the format `volume_group/logical_volume_name`. Since logical volume names are not enforced for uniqueness, using this format is an important safeguard against accidentally choosing the wrong volume (and clobbering its data).

If you use a partition to deploy filestore, the partition *must* contain a `PARTUUID` that can be discovered by `blkid`. This ensures that the partition can be identified correctly regardless of the device’s name (or path).

For example, to use a logical volume for OSD data and a partition (`/dev/sdc1`) for the journal, run a command of this form:

```
ceph-volume lvm prepare --filestore --data volume_group/logical_volume_name --journal /dev/sdc1
```

Or, to use a bare device for data and a logical volume for the journal:

```
ceph-volume lvm prepare --filestore --data /dev/sdc --journal volume_group/journal_lv
```

A generated UUID is used when asking the cluster for a new OSD. These two pieces of information (the OSD ID and the OSD UUID) are necessary for identifying a given OSD and will later be used throughout the [activation](https://docs.ceph.com/en/latest/ceph-volume/lvm/activate/#ceph-volume-lvm-activate) process.

The OSD data directory is created using the following convention:

```
/var/lib/ceph/osd/<cluster name>-<osd id>
```

To link the journal volume to the mounted data volume, use this command:

```
ln -s /path/to/journal /var/lib/ceph/osd/<cluster_name>-<osd-id>/journal
```

To fetch the monmap by using the bootstrap key from the OSD, use this command:

```
/usr/bin/ceph --cluster ceph --name client.bootstrap-osd --keyring
/var/lib/ceph/bootstrap-osd/ceph.keyring mon getmap -o
/var/lib/ceph/osd/<cluster name>-<osd id>/activate.monmap
```

To populate the OSD directory (which has already been mounted), use this `ceph-osd` command: .. prompt:: bash #

> ceph-osd --cluster ceph --mkfs --mkkey -i <osd id>  --monmap /var/lib/ceph/osd/<cluster name>-<osd id>/activate.monmap  --osd-data /var/lib/ceph/osd/<cluster name>-<osd id>  --osd-journal /var/lib/ceph/osd/<cluster name>-<osd id>/journal --osd-uuid <osd uuid> --keyring /var/lib/ceph/osd/<cluster name>-<osd id>/keyring  --setuser ceph --setgroup ceph

All of the information from the previous steps is used in the above command.



## Partitioning[](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#partitioning)

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



## Existing OSDs[](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#existing-osds)

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

## Crush device class[](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#crush-device-class)

To set the crush device class for the OSD, use the `--crush-device-class` flag. This will work for both bluestore and filestore OSDs:

```
ceph-volume lvm prepare --bluestore --data vg/lv --crush-device-class foo
```



## `multipath` support[](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#multipath-support)

`multipath` devices are supported if `lvm` is configured properly.

**Leave it to LVM**

Most Linux distributions should ship their LVM2 package with `multipath_component_detection = 1` in the default configuration. With this setting `LVM` ignores any device that is a multipath component and `ceph-volume` will accordingly not touch these devices.

**Using filters**

Should this setting be unavailable, a correct `filter` expression must be provided in `lvm.conf`. `ceph-volume` must not be able to use both the multipath device and its multipath components.

## Storing metadata[](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#storing-metadata)

The following tags will get applied as part of the preparation process regardless of the type of volume (journal or data) or OSD objectstore:

- `cluster_fsid`
- `encrypted`
- `osd_fsid`
- `osd_id`
- `crush_device_class`

For [filestore](https://docs.ceph.com/en/latest/glossary/#term-filestore) these tags will be added:

- `journal_device`
- `journal_uuid`

For [bluestore](https://docs.ceph.com/en/latest/glossary/#term-BlueStore) these tags will be added:

- `block_device`
- `block_uuid`
- `db_device`
- `db_uuid`
- `wal_device`
- `wal_uuid`

Note

For the complete lvm tag conventions see [Tag API](https://docs.ceph.com/en/latest/dev/ceph-volume/lvm/#ceph-volume-lvm-tag-api)

## Summary[](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#summary)

To recap the `prepare` process for [bluestore](https://docs.ceph.com/en/latest/glossary/#term-BlueStore):

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

准备

在运行ceph volume lvm prepare之前，我们建议您配置一个逻辑卷。然后可以在该逻辑卷上运行prepare。

prepare将元数据添加到逻辑卷，但不会以任何其他方式更改它们。

笔记

这是部署OSD的两步过程的一部分。如果您希望仅使用一个命令部署OSD，请参阅创建。

prepare使用LVM标记将若干元数据分配给逻辑卷。以这种方式标记的卷更容易识别，也更容易与Ceph一起使用。LVM标签根据逻辑卷在Ceph集群中扮演的角色来标识逻辑卷（例如：Blue Store数据或Blue Store WAL+DB）。

Blue Store是默认后端。Ceph允许更改后端，这可以通过使用以下标志和参数来完成：

--文件存储区

--蓝色商店

蓝色商店

Bluestore是新OSD的默认后端。它为设备提供了比文件存储更大的灵活性。Bluestore支持以下配置：

块设备、block.wal设备和block.db设备

block设备和block.wal设备

块设备和block.db设备

单块设备

bluestore子命令接受物理块设备、物理块设备上的分区或逻辑卷作为各种设备参数的参数。如果提供了物理块设备，则将创建逻辑卷。如果提供的卷组的名称以ceph开头，那么如果它还不存在，将创建它；如果它已经存在，则将删除并重新使用它。这为使用LVM提供了一种更简单的方法，但代价是灵活性：不能使用任何选项或配置来更改逻辑卷的创建方式。

块用--data标志指定，在最简单的用例中，它看起来像：

ceph卷lvm准备--bluestore--data-vg/lv

可以以相同的方式指定原始设备：

ceph volume lvm prepare--bluestore--data/path/to/device

要启用加密，需要--dmcrypt标志：

ceph卷lvm准备--bluestore--dmcrypt--data-vg/lv

如果需要block.db设备或block.wal设备，则可以使用-block.db或-block.wal指定。这些设备可以是物理设备、分区或逻辑卷。block.db和block.wal对于bluestore是可选的。

对于block.db和block.wal，分区可以按原样使用，因此不会被划分为逻辑卷。

在创建OSD目录时，该过程使用tmpfs装载来保存OSD所需的文件。这些文件是由ceph-osd-mkfs创建的，并且是临时的。

将为块设备创建符号链接，对于block.db和block.wal是可选的。对于默认名称和OSD ID为0的群集，目录如下所示：

\#ls-l/var/lib/ceph/osd/ceph-0

lrwxrwxrwx。1 ceph ceph 93 Oct 20  13:05块->/dev/ceph-be2b6fbd-bcf2-4c51-b35d-a35a162a02f0/osd-block-25cf0a005-2bc6-4ef-9137-79d65bd7ad62

lrwxrwxrwx。1 ceph ceph 93 Oct 20 13:05 block.db->/dev/sda1

lrwxrwxrwx。1 ceph ceph 93 Oct 20 13:05 block.wal->/dev/ceph/osd-wal-0

-rw-------。1 ceph ceph 20年10月37日13:05 ceph fsid

-rw-------。1 ceph ceph 37 10月20日13:05 fsid

-rw-------。1 ceph ceph 55 Oct 20 13:05钥匙环

-rw-------。1 ceph ceph 6 Oct 20 13:05准备就绪

-rw-------。1 ceph ceph 10 Oct 20 13:05型

-rw-------。10月20日13:05下午1点

在上述情况下，一个设备用于块，因此ceph volume使用以下约定创建了一个卷组和一个逻辑卷：

卷组名称：ceph-｛cluster fsid｝（如果卷组已存在：ceph-{random uuid｝）

逻辑卷名：osd块-｛osd fsid｝

文件存储器

Filestore＜Filestore＞是OSD后端，它为支持文件存储的对象存储OSD准备逻辑卷。

Filestore＜Filestore＞使用逻辑卷存储OSD数据，并使用物理设备、分区或逻辑卷存储日志。如果使用物理设备创建文件存储后端，则将在该物理设备上创建逻辑卷。如果提供的卷组的名称以ceph开头，那么如果它还不存在，将创建它；如果它已经存在，则将删除并重新使用它。这些卷不需要特别准备，但确保满足OSD数据和日志的最小尺寸要求。

使用以下命令创建基本文件存储OSD：

ceph卷lvm准备--文件存储--数据<数据块设备>

使用此命令部署具有外部日志的文件存储：

ceph卷lvm准备--文件存储--数据<数据块设备>--日志<日志块设备>

使用此命令启用加密，并注意需要--dmcrypt标志：

ceph卷lvm准备--文件存储--dmcrypt--数据<数据块设备>--日志<日志块设备>

数据块设备和日志可以采用以下三种形式之一：

物理块设备

# `create`[](https://docs.ceph.com/en/latest/ceph-volume/lvm/create/#create)

This subcommand wraps the two-step process to provision a new osd (calling `prepare` first and then `activate`) into a single one. The reason to prefer `prepare` and then `activate` is to gradually introduce new OSDs into a cluster, and avoiding large amounts of data being rebalanced.

The single-call process unifies exactly what [prepare](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#ceph-volume-lvm-prepare) and [activate](https://docs.ceph.com/en/latest/ceph-volume/lvm/activate/#ceph-volume-lvm-activate) do, with the convenience of doing it all at once.

There is nothing different to the process except the OSD will become up and in immediately after completion.

The backing objectstore can be specified with:

- [--filestore](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#ceph-volume-lvm-prepare-filestore)
- [--bluestore](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#ceph-volume-lvm-prepare-bluestore)

All command line flags and options are the same as `ceph-volume lvm prepare`. Please refer to [prepare](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#ceph-volume-lvm-prepare) for details.

创造

此子命令将两步过程打包为一个单独的osd（先调用prepare，然后调用activate）。之所以选择先准备然后激活，是为了逐步将新的OSD引入集群，避免大量数据被重新平衡。

单次调用过程完全统一了准备和激活所做的事情，方便了一次完成所有操作。

除了OSD将在完成后立即启动外，这个过程没有什么不同。

支持对象存储可以通过以下方式指定：

--文件存储区

--蓝色商店

所有命令行标志和选项都与ceph volume lvm prepare相同。有关详细信息，请参阅准备。

# scan[](https://docs.ceph.com/en/latest/ceph-volume/lvm/scan/#scan)

This sub-command will allow to discover Ceph volumes previously setup by the tool by looking into the system’s logical volumes and their tags.

As part of the [prepare](https://docs.ceph.com/en/latest/ceph-volume/lvm/prepare/#ceph-volume-lvm-prepare) process, the logical volumes are assigned a few tags with important pieces of information.

Note

This sub-command is not yet implemented

扫描

该子命令将允许通过查看系统的逻辑卷及其标记来发现工具先前设置的Ceph卷。

作为准备过程的一部分，逻辑卷被分配了一些带有重要信息的标签。

笔记

此子命令尚未实现

# systemd[](https://docs.ceph.com/en/latest/ceph-volume/lvm/systemd/#systemd)

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

系统d

启动后，它将使用LVM标记识别逻辑卷，找到匹配的ID，然后确保它是正确的OSD uuid。

识别正确的卷后，它将继续使用OSD目标约定进行装载，即：

/var/lib/ceph/osd/-

对于id为0的示例OSD，这意味着识别的设备将安装在：

/var/lib/ceph/osd/ceph-0

该过程完成后，将调用启动OSD：

systemctl启动ceph-osd@0

这个过程的systemd部分由ceph volume lvm trigger子命令处理，它只负责解析来自systemd和启动的元数据，然后分派给ceph volumelvm activate，后者将继续激活。

# `list`[](https://docs.ceph.com/en/latest/ceph-volume/lvm/list/#list)

This subcommand will list any devices (logical and physical) that may be associated with a Ceph cluster, as long as they contain enough metadata to allow for that discovery.

Output is grouped by the OSD ID associated with the devices, and unlike `ceph-disk` it does not provide any information for devices that aren’t associated with Ceph.

Command line options:

- `--format` Allows a `json` or `pretty` value. Defaults to `pretty` which will group the device information in a human-readable format.

## Full Reporting[](https://docs.ceph.com/en/latest/ceph-volume/lvm/list/#full-reporting)

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

## Single Reporting[](https://docs.ceph.com/en/latest/ceph-volume/lvm/list/#single-reporting)

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

## `json` output[](https://docs.ceph.com/en/latest/ceph-volume/lvm/list/#json-output)

All output using `--format=json` will show everything the system has stored as metadata for the devices, including tags.

No changes for readability are done with `json` reporting, and all information is presented as-is. Full output as well as single devices can be listed.

For brevity, this is how a single logical volume would look with `json` output (note how tags aren’t modified):

```
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

## Synchronized information[](https://docs.ceph.com/en/latest/ceph-volume/lvm/list/#synchronized-information)

Before any listing type, the lvm API is queried to ensure that physical devices that may be in use haven’t changed naming. It is possible that non-persistent devices like `/dev/sda1` could change to `/dev/sdb1`.

The detection is possible because the `PARTUUID` is stored as part of the metadata in the logical volume for the data lv. Even in the case of a journal that is a physical device, this information is still stored on the data logical volume associated with it.

If the name is no longer the same (as reported by `blkid` when using the `PARTUUID`), the tag will get updated and the report will use the newly refreshed information.

列表

此子命令将列出可能与Ceph集群关联的任何设备（逻辑和物理），只要它们包含足够的元数据以允许该发现。

输出按与设备相关的OSD ID分组，与ceph磁盘不同，它不为与ceph无关的设备提供任何信息。

命令行选项：

--format允许json或漂亮值。默认值为“漂亮”，它将以可读格式对设备信息进行分组。

完整报告

当不使用位置参数时，将显示完整的报告。这意味着将显示系统中找到的所有设备和逻辑卷。

两个OSD的完整漂亮报告，一个以lv为日志，另一个以物理设备为日志，看起来可能类似于：

\#ceph卷lvm列表

=====对象1=======

[journal]/dev/journal/journal1

期刊uuid C65n7d-B1gy-cq X3-v ZKY Zo E0 IEYM Hn IJzs

osd id 1

集群fsid ce454d91-d748-4751-a318-ff7f7aa18ffd

类型日记帐

osd fsid 661b24f8-e062-482b-8110-826ffe7f13fa

数据uuid Sl Eg He-j X1H-QBQk-Sce0-RUls-8Kl Y-g8Hgc Z

日志设备/dev/journal/journal1

数据设备/dev/test group/data-lv2

设备/dev/sda

[data]/dev/test group/data-lv2

期刊uuid C65n7d-B1gy-cq X3-v ZKY Zo E0 IEYM Hn IJzs

osd id 1

集群fsid ce454d91-d748-4751-a318-ff7f7aa18ffd

类型数据

osd fsid 661b24f8-e062-482b-8110-826ffe7f13fa

数据uuid Sl Eg He-j X1H-QBQk-Sce0-RUls-8Kl Y-g8Hgc Z

日志设备/dev/journal/journal1

数据设备/dev/test group/data-lv2

设备/dev/sdb

=====对象0=======

[data]/dev/test group/data-lv1

期刊uuid cd72bd28-002a-48da-bdf6-d5b993e84f3f

osd id 0

集群fsid ce454d91-d748-4751-a318-ff7f7aa18ffd

类型数据

osd fsid 943949f0-ce37-47ca-a33c-3413d46ee9秒

数据uuid TUpfel-Q5ZT-e Fph bd GW Si NW-l0ag-f5kh00

日志设备/dev/sdd1

数据设备/dev/test group/data-lv1

设备/dev/sdc

[日志]/dev/sdd1

零件号cd72bd28-002a-48da-bdf6-d5b993e84f3f

对于逻辑卷，设备密钥由与逻辑卷关联的物理设备填充。由于LVM允许多个物理设备成为一个逻辑卷的一部分，因此当使用pretty时，值将以逗号分隔，而当使用json时，值是一个数组。

笔记

标记以可读格式显示。osd id密钥存储为ceph.osd id标签。有关lvm标记约定的更多信息，请参阅标记API

单一报告

单个报告可以使用设备和逻辑卷作为输入（位置参数）。对于逻辑卷，需要使用组名和逻辑卷名。

例如，测试组卷组中的data-lv2逻辑卷可以按以下方式列出：

\#ceph卷lvm列表测试组/data-lv2

=====对象1=======

[data]/dev/test group/data-lv2

期刊uuid C65n7d-B1gy-cq X3-v ZKY Zo E0 IEYM Hn IJzs

osd id 1

集群fsid ce454d91-d748-4751-a318-ff7f7aa18ffd

类型数据

osd fsid 661b24f8-e062-482b-8110-826ffe7f13fa

数据uuid Sl Eg He-j X1H-QBQk-Sce0-RUls-8Kl Y-g8Hgc Z

日志设备/dev/journal/journal1

数据设备/dev/test group/data-lv2

设备/dev/sdc

笔记

标记以可读格式显示。osd id密钥存储为ceph.osd id标签。有关lvm标记约定的更多信息，请参阅标记API

对于普通磁盘，需要设备的完整路径。例如，对于/dev/sdd1这样的设备，它可能看起来像：

\#ceph卷lvm列表/dev/sdd1

=====对象0=======

[日志]/dev/sdd1

零件号cd72bd28-002a-48da-bdf6-d5b993e84f3f

json输出

所有使用--format=json的输出都将显示系统作为设备元数据存储的所有内容，包括标签。

json报告没有对可读性进行任何更改，所有信息都按原样显示。可以列出全部输出以及单个设备。

为了简洁起见，这是一个逻辑卷在json输出时的样子（注意标记是如何被修改的）：

\#ceph卷lvm列表--format=json测试组/data-lv1

{

"0": [

{

“去

# `zap`[](https://docs.ceph.com/en/latest/ceph-volume/lvm/zap/#zap)

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

## Removing Devices[](https://docs.ceph.com/en/latest/ceph-volume/lvm/zap/#removing-devices)

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

扎普

此子命令用于清除ceph OSD使用过的lv、分区或原始设备，以便它们可以重用。如果给定逻辑卷的路径，则其格式必须为vg/lv。给定lv或分区上存在的任何文件系统都将被删除，所有数据都将被清除。

笔记

lv或隔板应保持完整。

笔记

如果逻辑卷、原始设备或分区正用于任何与ceph相关的装载点，则将卸载它们。

拆分逻辑卷：

ceph卷lvm-zap｛vg名称/lv名称｝

拆分分区：

ceph卷lvm zap/dev/sdc1

正在删除设备

在切换和查找设备（lv、vg或分区）的完全删除时，使用--destroy标志。一个常见的用例是使用整个原始设备简单地部署OSD。如果您这样做，然后希望将该设备重新用于另一个OSD，则在切换时必须使用--destroy标志，以便删除在原始设备上创建的ceph卷的vgs和lvs。

笔记

一次可以接受多个设备，将其全部清除

拆下一个原始设备并销毁所有存在的vg或lv：

ceph volume lvm zap/dev/sdc—销毁

此操作可以在分区和逻辑卷上执行：

ceph volume lvm zap/dev/sdc1—销毁

ceph volume lvm zap osd vg/data lv—销毁

最后，如果通过OSD ID和/或OSD FSID进行过滤，则可以检测到多个设备。可以使用任一标识符，也可以同时使用两者。这在需要清除与特定ID关联的多个设备的情况下非常有用。使用FSID时，过滤更严格，可能与ID关联的其他（可能无效）设备不匹配。

仅按ID：

ceph卷lvm zap—销毁—osd id 1

通过FSID：

ceph volume lvm zap--销毁--osd fsid 2E8FBE58-0328-4E3B-BFB7-3CACE4E9A6CE

双方签字：

ceph volume lvm zap--destroy--osd fsid 2E8FBE58-0328-4E3B-BFB7-3CACE4E9A6CE--osd id 1

警告

如果检测到与要删除的OSD ID相关联的systemd单元正在运行，则该工具将拒绝删除，直到守护程序停止。

# `migrate`[](https://docs.ceph.com/en/latest/ceph-volume/lvm/migrate/#migrate)

Moves BlueFS data from source volume(s) to the target one, source volumes (except the main, i.e. data or block one) are removed on success.

LVM volumes are permitted for Target only, both already attached or new one.

In the latter case it is attached to the OSD replacing one of the source devices.

Following replacement rules apply (in the order of precedence, stop on the first match):

> - if source list has DB volume - target device replaces it.
> - if source list has WAL volume - target device replaces it.
> - if source list has slow volume only - operation is not permitted, requires explicit allocation via new-db/new-wal command.

Moves BlueFS data from main device to LV already attached as DB:

```
ceph-volume lvm migrate --osd-id 1 --osd-fsid <uuid> --from data --target vgname/db
```

Moves BlueFS data from shared main device to LV which will be attached as a new DB:

```
ceph-volume lvm migrate --osd-id 1 --osd-fsid <uuid> --from data --target vgname/new_db
```

Moves BlueFS data from DB device to new LV, DB is replaced:

```
ceph-volume lvm migrate --osd-id 1 --osd-fsid <uuid> --from db --target vgname/new_db
```

Moves BlueFS data from main and DB devices to new LV, DB is replaced:

```
ceph-volume lvm migrate --osd-id 1 --osd-fsid <uuid> --from data db --target vgname/new_db
```

Moves BlueFS data from main, DB and WAL devices to new LV, WAL is  removed and DB is replaced:

```
ceph-volume lvm migrate --osd-id 1 --osd-fsid <uuid> --from data db wal --target vgname/new_db
```

Moves BlueFS data from main, DB and WAL devices to main device, WAL and DB are removed:

```
ceph-volume lvm migrate --osd-id 1 --osd-fsid <uuid> --from db wal --target vgname/data
```

迁徙

将蓝色FS数据从源卷移动到目标卷，成功后将删除源卷（除了主卷，即数据或块卷）。

LVM卷仅允许用于目标，既可以是已连接的卷，也可以是新的卷。

在后一种情况下，它被连接到OSD以替换源设备之一。

以下替换规则适用（按优先顺序，在第一场比赛时停止）：

如果源列表具有DB卷，则目标设备将替换它。

如果源列表具有WAL卷，则目标设备将替换它。

如果源列表只有慢速卷，则不允许操作，需要通过newdb/new-wal命令进行显式分配。

将蓝色FS数据从主设备移动到已作为DB连接的LV：

ceph卷lvm迁移--osd id 1--osd fsid--从数据--目标vgname/db

将蓝色FS数据从共享主设备移动到LV，LV将作为新数据库附加：

ceph卷lvm迁移--osd id 1--osd fsid--来自数据--target vgname/new db

将蓝色FS数据从DB设备移动到新LV，替换DB：

ceph卷lvm迁移--osd id 1--osd fsid--来自数据库--目标vgname/新数据库

将蓝色FS数据从主设备和DB设备移动到新LV，DB被替换：

ceph卷lvm迁移--osd id 1--osd fsid--从数据数据库--目标vgname/新数据库

将蓝色FS数据从主、DB和WAL设备移动到新LV，WAL被删除，DB被替换：

ceph卷lvm迁移--osd id 1--osd fsid--来自数据数据库wal--目标vgname/新数据库

将蓝色FS数据从主设备、DB和WAL设备移动到主设备，WAL和DB被删除：

ceph卷lvm迁移--osd id 1--osd fsid--来自db-wal--目标vgname/data

# `new-db`[](https://docs.ceph.com/en/latest/ceph-volume/lvm/newdb/#new-db)

Attaches the given logical volume to OSD as a DB. Logical volume name format is vg/lv. Fails if OSD has already got attached DB.

Attach vgname/lvname as a DB volume to OSD 1:

```
ceph-volume lvm new-db --osd-id 1 --osd-fsid 55BD4219-16A7-4037-BC20-0F158EFCC83D --target vgname/new_db
```

新建数据库

将给定的逻辑卷作为DB附加到OSD。逻辑卷名格式为vg/lv。如果OSD已连接DB，则失败。

将vgname/lvname作为DB卷附加到OSD 1：

ceph volume lvm new db--osd id 1--osd fsid 55BD4219-16A7-4037-BC20-0F158EFCC83D--目标vgname/new db

# `new-wal`[](https://docs.ceph.com/en/latest/ceph-volume/lvm/newwal/#new-wal)

Attaches the given logical volume to the given OSD as a WAL volume. Logical volume format is vg/lv. Fails if OSD has already got attached DB.

Attach vgname/lvname as a WAL volume to OSD 1:

```
ceph-volume lvm new-wal --osd-id 1 --osd-fsid 55BD4219-16A7-4037-BC20-0F158EFCC83D --target vgname/new_wal
```

新墙

将给定逻辑卷作为WAL卷附加到给定OSD。逻辑卷格式为vg/lv。如果OSD已连接DB，则失败。

将vgname/lvname作为WAL卷附加到OSD 1：

ceph volume lvm new wal--osd id 1--osd fsid 55BD4219-16A7-4037-BC20-0F158EFCC83D--target vgname/new wal

# `simple`[](https://docs.ceph.com/en/latest/ceph-volume/simple/#simple)

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

易于理解的

通过简单子命令实现管理OSD所需的功能：ceph volume simple

命令行子命令

扫描

激活

系统d

通过接管管理，它禁用了启动时用于触发设备的所有ceph磁盘systemd单元，依赖于基本（可定制）JSON配置和systemd来启动OSD。

该过程包括两个步骤：

扫描正在运行的OSD或数据设备

激活扫描的OSD

扫描将推断出ceph音量启动OSD所需的一切，这样当需要激活时，OSD可以正常启动，而不会受到ceph磁盘的干扰。

作为激活过程的一部分，负责对udev事件做出反应的ceph磁盘的systemd单元链接到/dev/null，以便它们完全不活动。

# `activate`[](https://docs.ceph.com/en/latest/ceph-volume/simple/activate/#activate)

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

## requiring uuids[](https://docs.ceph.com/en/latest/ceph-volume/simple/activate/#requiring-uuids)

The [OSD uuid](https://docs.ceph.com/en/latest/glossary/#term-OSD-uuid) is being required as an extra step to ensure that the right OSD is being activated. It is entirely possible that a previous OSD with the same id exists and would end up activating the incorrect one.

### Discovery[](https://docs.ceph.com/en/latest/ceph-volume/simple/activate/#discovery)

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

激活

一旦扫描完成，并且为OSD捕获的所有元数据都保存到/etc/ceph/OSD/{id}-{uuid}.json，OSD现在就可以“激活”了。

此激活过程通过屏蔽所有ceph磁盘系统单元来禁用它们，以防止UDEV/ceph磁盘交互在启动时尝试启动它们。

只有在直接调用ceph卷简单激活时，才能禁用ceph磁盘单元，但在系统启动时由systemd调用时，可以避免禁用。

激活过程需要同时使用OSD id和OSD uuid来激活解析的OSD：

ceph体积简单激活0 6cc43680-4f6e-4feb-92ff-9c7ba204120e

上述命令将假设JSON配置位于：

/etc/ceph/osd/0-6cc43680-4f6e-4feb-92ff-9c7ba204120e.json

或者，也可以直接使用JSON文件的路径：

ceph卷简单激活--文件/etc/ceph/osd/0-6cc43680-4f6e-4feb-92ff-9c7ba204120e.json

需要uuid

OSD uuid是确保激活正确OSD的额外步骤。完全有可能存在具有相同id的前一个OSD，并最终激活不正确的OSD。

发现

使用ceph卷之前扫描的OSD，使用blkid和lvm执行发现过程。目前仅支持具有GPT分区和LVM逻辑卷的设备。

GPT分区将具有PARTUUID，可以通过调用blkid进行查询，逻辑卷将具有lv-uid，可以针对lv（列出逻辑卷的LVM工具）进行查询。

此发现过程可确保即使设备被重新用于另一个系统或其名称发生更改（如/dev/sda1等非持久化名称），也能正确检测到设备

JSON配置文件用于将哪些设备映射到OSD，然后作为激活的一部分协调安装和符号链接。

为了确保符号链接始终正确，如果它们存在于OSD目录中，将重新执行符号链接。

一个systemd单元将捕获OSD id和OSD uuid并将其持久化。在内部，激活将启用它，如：

systemctl启用ceph-volume@simple-$id-$uuid

例如：

systemctl启用ceph-volume@simple-0-8715BEB4-15C5-49DE-BA6F-401086EC7B41

将启动OSD的发现过程，id为0，UUID为8715BEB4-15C5-49DE-BA6F-401086EC7B41。

systemd过程将调用以激活传递识别OSD及其设备所需的信息，并将继续：

\#将设备安装在相应的位置（按照惯例

/var/lib/ceph/osd/-/）

\#确保所有所需的设备都已准备好用于该OSD并正确链接，无论使用的是对象存储（文件存储或bluestore）。将始终重新进行符号链接，以确保链接了正确的设备。

\#启动ceph-osd@0systemd单位

# `scan`[](https://docs.ceph.com/en/latest/ceph-volume/simple/scan/#scan)

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



## Running OSDs scan[](https://docs.ceph.com/en/latest/ceph-volume/simple/scan/#running-osds-scan)

Using this command without providing an OSD directory or device will scan the directories of any currently running OSDs. If a running OSD was not created by ceph-disk it will be ignored and not scanned.

To scan all running ceph-disk OSDs, the command would look like:

```
ceph-volume simple scan
```

## Directory scan[](https://docs.ceph.com/en/latest/ceph-volume/simple/scan/#directory-scan)

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



## Device scan[](https://docs.ceph.com/en/latest/ceph-volume/simple/scan/#device-scan)

When an OSD directory is not available (OSD is not running, or device is not mounted) the `scan` command is able to introspect the device to capture required data. Just like [Running OSDs scan](https://docs.ceph.com/en/latest/ceph-volume/simple/scan/#ceph-volume-simple-scan-directory), it would still require a few files present. This means that the device to be scanned **must be** the data partition of the OSD.

As long as the data partition of the OSD is being passed in as an argument, the sub-command can scan its contents.

In the case where the device is already mounted, the tool can detect this scenario and capture file contents from that directory.

If the device is not mounted, a temporary directory will be created, and the device will be mounted temporarily just for scanning the contents. Once contents are scanned, the device will be unmounted.

For a device like `/dev/sda1` which **must** be a data partition, the command could look like:

```
ceph-volume simple scan /dev/sda1
```



## `JSON` contents[](https://docs.ceph.com/en/latest/ceph-volume/simple/scan/#json-contents)

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

```
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

  扫描

扫描允许从已部署的OSD中捕获任何重要细节，以便ceph卷可以管理它，而无需任何其他启动工作流或工具（如udev或ceph磁盘）。完全支持LUKS或PLAIN格式的加密。

该命令能够通过检查存储OSD数据的目录或使用数据分区来检查正在运行的OSD。如果没有提供路径或设备，该命令还可以扫描所有正在运行的OSD。

扫描后，信息将（默认情况下）将元数据作为JSON保存在/etc/ceph/osd文件中。此JSON文件将使用命名约定：｛OSD ID｝-｛OSD  FSID｝.JSON。ID为1的OSD和类似于86ebd829-1405-43d3-8fd6-4cbc9b6ecf96的FSID，文件的绝对路径为：

/etc/ceph/osd/1-86ebd829-1405-43d3-8fd6-4cbc9b6ecf96.json

如果该文件已经存在，scan子命令将拒绝写入该文件。如果需要覆盖内容，则必须使用--force标志：

ceph卷简单扫描--力｛路径｝

如果不需要持久化JSON元数据，则支持将内容发送到stdout（不会写入任何文件）：

ceph卷简单扫描--stdout｛path｝

正在运行OSD扫描

使用此命令而不提供OSD目录或设备将扫描当前运行的任何OSD的目录。如果正在运行的OSD不是由ceph磁盘创建的，它将被忽略并且不会被扫描。

要扫描所有正在运行的ceph磁盘OSD，命令如下所示：

ceph体积简单扫描

目录扫描

目录扫描将从感兴趣的文件中捕获OSD文件内容。要成功扫描，必须存在以下几个文件：

ceph-fsid

金融服务识别码

钥匙环

准备好的

类型

哇哦

如果OSD被加密，它将额外添加以下密钥：

加密的

加密类型

锁箱钥匙环

对于任何其他文件，只要它不是二进制文件或目录，它也会被捕获并作为JSON对象的一部分持久化。

JSON对象中的键的约定是，任何文件名都将是键，其内容将是其值。如果内容是单行（如whoami的情况），内容将被删除，换行符将被删除。例如，对于id为1的OSD，JSON条目的外观如下：

“whoami”：“1”，

对于可能有多行的文件，内容保持原样，但keyring除外，keyring经过特殊处理并解析以提取keyring。例如，一个密钥环，它被读取为：

[osd.1]\n\tkey=AQBBJ/d Zp57NIBAAtnu QS9WOS0hn LVe0r Zn E6Q==\n

将存储为：

“keyring”：“AQBBJ/d Zp57NIBAAtnu QS9WOS0hn LVe0r Zn E6Q==”，

对于/var/lib/ceph/osd/ceph-1这样的目录，命令可能如下所示：

ceph卷简单扫描/var/lib/ceph/osd/ceph1

设备扫描

当OSD目录不可用时（OSD未运行，或设备未安装），扫描命令能够内省设备以捕获所需数据。就像运行OSD扫描一样，它仍然需要一些文件。这意味着要扫描的设备必须是OSD的数据分区。

只要OSD的数据分区作为参数传入，子命令就可以扫描其内容。

在设备已经安装的情况下，该工具可以检测到这种情况，并从该目录中捕获文件内容。

如果设备未安装，将创建一个临时目录，并且设备将临时安装，仅用于扫描内容。扫描内容后，将卸载设备。

对于像/dev/sda1这样必须是数据分区的设备，命令可能如下所示：

ceph卷简单扫描/dev/sda1

JSON内容

JSON对象的内容非常简单。扫描不仅将保存来自特殊OSD文件及其内容的信息，还将验证路径和设备UUID。与ceph磁盘不同的是，通过将它们存储在｛device-type｝uuid文件中，该工具将它们作为设备类型密钥的一部分持久化。

例如，block.db设备看起来像：

“block.db”：{

“path”：“/dev/disk/by-partuid/6cc43680-4f6e-4feb-92ff-9c7ba204120e”，

“uuid”：“6cc43680-4f6e-4feb-92ff-9c7ba204120e”

},

但它也会保存生成的ceph磁盘特殊文件，如下所示：

“block.db uuid”：“6cc43680-4f6e-4feb-92ff-9c7ba204120e”，

之所以进行重复，是因为该工具正在努力确保以下内容：

\#支持可能没有ceph磁盘特殊文件的OSD#通过查询LVM和blkid检查设备上的最新信息#同时支持逻辑卷和GPT设备

这是一个示例JSON元数据，来自使用bluestore的OSD：

{

“活动”：“正常”，

“块”：{

“path”：“/dev/disk/by-partuid/40fd0a64-caa5-43a3-9717-1836ac661a12”，

“uuid”：“4      

# systemd[](https://docs.ceph.com/en/latest/ceph-volume/simple/systemd/#systemd)

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

系统d

启动时，它将通过加载/etc/ceph/osd/{id}-{uuid}.JSON中与systemd单元的实例名称对应的JSON文件来标识逻辑卷。

识别正确的卷后，它将继续使用OSD目标约定进行装载，即：

/var/lib/ceph/osd/｛集群名称｝-｛osd id｝

对于id为0的示例OSD，这意味着识别的设备将安装在：

/var/lib/ceph/osd/ceph-0

该过程完成后，将调用启动OSD：

systemctl启动ceph-osd@0

该过程的systemd部分由ceph-volumesimpletrigger子命令处理，该子命令仅负责解析来自systemd和启动的元数据，然后将其分派给ceph-volume simple-activate，继续激活。

# `zfs`[](https://docs.ceph.com/en/latest/ceph-volume/zfs/#zfs)

Implements the functionality needed to deploy OSDs from the `zfs` subcommand: `ceph-volume zfs`

The current implementation only works for ZFS on FreeBSD

**Command Line Subcommands**

- [inventory](https://docs.ceph.com/en/latest/ceph-volume/zfs/inventory/#ceph-volume-zfs-inventory)

**Internal functionality**

There are other aspects of the `zfs` subcommand that are internal and not exposed to the user, these sections explain how these pieces work together, clarifying the workflows of the tool.

[zfs](https://docs.ceph.com/en/latest/dev/ceph-volume/zfs/#ceph-volume-zfs-api)

zfs公司

实现从zfs子命令部署OSD所需的功能：ceph volume zfs

当前的实现仅适用于FreeBSD上的ZFS

命令行子命令

库存

内部功能

zfs子命令还有其他方面是内部的，不向用户公开，这些部分解释了这些部分是如何协同工作的，阐明了该工具的工作流程。

zfs公司

# `inventory`[](https://docs.ceph.com/en/latest/ceph-volume/zfs/inventory/#inventory)

The `inventory` subcommand queries a host’s disc inventory through GEOM and provides hardware information and metadata on every physical device.

This only works on a FreeBSD platform.

By default the command returns a short, human-readable report of all physical disks.

For programmatic consumption of this report pass `--format json` to generate a JSON formatted report. This report includes extensive information on the physical drives such as disk metadata (like model and size), logical volumes and whether they are used by ceph, and if the disk is usable by ceph and reasons why not.

A device path can be specified to report extensive information on a device in both plain and json format.

库存

清单子命令通过GEOM查询主机的磁盘清单，并提供每个物理设备上的硬件信息和元数据。

这只适用于FreeBSD平台。

默认情况下，该命令会返回所有物理磁盘的简短可读报告。

对于该报告的编程使用，传递--format json以生成json格式的报告。此报告包含有关物理驱动器的大量信息，如磁盘元数据（如型号和大小）、逻辑卷以及ceph是否使用这些磁盘，ceph是否可以使用磁盘以及原因。

可以指定设备路径以报告设备上的大量信息，包括普通格式和json格式。