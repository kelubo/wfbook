# RBD

[TOC]

## 概述

Ceph 块设备也叫 RBD 或 RADOS 块设备。

块是一个字节序列（通常为 512）。基于块的存储接口，是一种成熟而常见的在介质（包括 HDD、SSD、CD、软盘甚至磁带）上存储数据的方法。块设备接口的普遍性非常适合与包括 Ceph 在内的海量数据存储进行交互。

Ceph 块设备是精简配置的，可调整大小，并在多个 OSD 上存储条带化数据。Ceph 块设备利用 RADOS 功能，包括快照、复制和强一致性。Ceph 块存储客户端通过内核模块或 librbd 库与 Ceph 集群通信。

 ![img](../../Image/d/ditaa-9c4dce3fc347721433a81021ea03daac92997c1a.png)

> Note:
>
> 内核模块可以使用 Linux 页面缓存。对于基于 librbd 的应用程序，Ceph 支持 RBD 缓存。

Ceph 的块设备为内核模块或 KVM（如 QEMU ）以及基于云的计算系统（如 OpenStack 和 CloudStack ）提供了高性能和巨大的可扩展性，这些系统依赖于 libvirt 和 QEMU 与 Ceph 块设备集成。

 ![](../../Image/c/ceph_rados_rbd.jpg)

rbd 命令允许您创建、列出、内省introspect和删除块设备映像。还可以使用它克隆镜像、创建快照、rollback an image to a snapshot将镜像回滚到快照、查看快照等。

## 创建块设备池

1. 在管理节点，使用 `ceph` 工具创建池。

   ```bash
   ceph osd pool create {pool-name}
   ```

2. 在管理节点，使用 `rbd` 工具初始化池以供 RBD 使用：

   ```bash
   rbd pool init <pool-name>
   ```

> Note：
>
> 未提供池的名称时，rbd 工具假定默认池名为 “`rbd`” 。

## 创建块设备用户

除非另有说明，否则 rbd 命令将使用 ID 为 `admin` 的用户访问 Ceph 集群。此 ID 允许对群集进行完全管理访问。建议尽可能使用更受限的用户。将此非管理 Ceph 用户 ID 称为 “块设备用户” 或 “Ceph 用户”。

要创建 Ceph 用户，请使用 `ceph auth get-or-create` 命令指定 Ceph 用户 ID 名称、MON caps（功能）和 OSD caps（功能）：

```bash
ceph auth get-or-create client.{ID} mon 'profile rbd' osd 'profile {profile name} [pool={pool-name}][, profile ...]' mgr 'profile rbd [pool={pool-name}]'
```

例如要创建一个名为 `qemu` 的 Ceph 用户 ID ，该用户 ID 对池 `vms` 具有读写访问权限，对池 `images` 具有只读访问权限，请运行以下命令：

```bash
ceph auth get-or-create client.qemu mon 'profile rbd' osd 'profile rbd pool=vms, profile rbd-read-only pool=images' mgr 'profile rbd pool=images'
```

`ceph auth get-or-create` 命令的输出将是指定用户的 keyring ，可以写入到 `/etc/ceph/ceph.client.{ID}.keyring` 。

> Note:
>
> 使用 rbd 命令时，可以通过提供 `--id {id}` 可选参数来指定用户 ID 。

## 创建块设备 Image

在将块设备添加到节点之前，必须先在 Ceph 存储群集中为其创建映像 image 。要创建块设备映像，请执行以下操作：

```bash
rbd create --size {megabytes} {pool-name}/{image-name}
```

例如，要创建名为 `bar` 的 1GB 映像，该映像将信息存储在名为 `swimingpool` 的池中，请执行以下操作：

```bash
rbd create --size 1024 swimmingpool/bar
```

如果在创建映像时未指定池，则它将存储在默认池 rbd 中。例如，要创建存储在默认池 rbd 中名为 foo 的 1GB 映像，请执行以下操作：

```bash
rbd create --size 1024 foo
```

> Note
>
> 必须先创建池，然后才能将其指定为源。

## 列出块设备 Image

要列出 rbd 池中的块设备，请执行以下操作（即 rbd 是默认池名称）：

```bash
rbd ls
```

要列出特定池中的块设备，请执行以下操作，但将 {poolname} 替换为池的名称：

```bash
rbd ls {poolname}

rbd ls swimmingpool
```

要列出 rbd 池中的延迟删除deferred delete 块设备，请执行以下操作：

```bash
rbd trash ls
```

要列出特定池中的延迟删除deferred delete 块设备，请执行以下操作，但将 {poolname} 替换为池的名称：

```bash
rbd trash ls {poolname}

rbd trash ls swimmingpool
```

## 检索 Image 信息

要从特定 image 检索信息，请执行以下操作，但将 `{image-name}` 替换为 image 的名称：

```bash
rbd info {image-name}

rbd info foo
```

从池中的 image 中检索信息，执行以下操作，但将 `{image-name}` 替换为映像的名称，并将 {pool name} 替换为池的名称：

```bash
rbd info {pool-name}/{image-name}

rbd info swimmingpool/bar
```

> 注意
>
> 其他命名约定也是可能的，并且可能与这里描述的命名约定冲突。例如，`userid/<uuid>` 是 RBD image 的一个可能的名称，这样的名称可能（至少）令人困惑。

## 调整块设备 Image 的大小

Ceph 块设备映像 image 是精简配置的。在开始向它们保存数据之前，它们实际上不会使用任何物理存储。

但是，它们确实有一个最大容量，可以使用 `--size` 选项设置。如果要增大（或减小）Ceph 块设备映像的最大大小，请执行以下操作：

```bash
# 增加
rbd resize --size 2048 foo
# 减少
rbd resize --size 2048 foo --allow-shrink
```

## 删除块设备 Image

要删除块设备，请执行以下操作，但将 `{image-name}` 替换为要删除的 image 的名称：

```bash
rbd rm {image-name}

rbd rm foo
```

要从池中删除块设备，请执行以下操作，但将 `{image-name}` 替换为要删除的映像的名称，并将 `{pool-name}` 替换为池的名称：

```bash
rbd rm {pool-name}/{image-name}

rbd rm swimmingpool/bar
```

要延迟从池中删除块设备，请执行以下操作，但将 {image-name} 替换为要移动的映像的名称，并将 {pool-name} 替换为池的名称：

```bash
rbd trash mv {pool-name}/{image-name}

rbd trash mv swimmingpool/bar
```

要从池中删除延迟块设备，请执行以下操作，但将 {image-id} 替换为要删除的映像的 id ，并将 {pool-name} 替换为池的名称：

```bash
rbd trash rm {pool-name}/{image-id}

rbd trash rm swimmingpool/2bf4474b0dc51
```

> Note
>
> * 即使映像具有快照或正被克隆使用，也可以将其移到垃圾箱中。但是，不能在这些条件下将其从垃圾箱中删除。
> * 可以使用 `--expires-at` 设置延迟时间（默认为 now ）。如果延迟时间还没有到，不能删除，除非使用 `--force` 。

## 恢复块设备 Image

要恢复 rbd 池中的延迟删除块设备，请执行以下操作，但将 `{image-id}` 替换为映像的 id：

```bash
rbd trash restore {image-id}

rbd trash restore 2bf4474b0dc51
```

要从池中恢复延迟删除块设备，请执行以下操作，但将 `{image-id}` 替换为映像的 id，并将 {pool-name} 替换为池的名称：

```bash
rbd trash restore {pool-name}/{image-id}

rbd trash restore swimmingpool/2bf4474b0dc51
```

可以使用 `--image` 在还原 images 时进行重命名。

```bash
rbd trash restore swimmingpool/2bf4474b0dc51 --image new-name
```

## RBD Replay

RBD Replay is a set of tools for capturing and replaying RADOS Block Device (RBD) workloads. To capture an RBD workload, `lttng-tools` must be installed on the client, and `librbd` on the client must be the v0.87 (Giant) release or later. To replay an RBD workload, `librbd` on the client must be the Giant release or later.

Capture and replay takes three steps:

1. Capture the trace.  Make sure to capture `pthread_id` context:

   ```
   mkdir -p traces
   lttng create -o traces librbd
   lttng enable-event -u 'librbd:*'
   lttng add-context -u -t pthread_id
   lttng start
   # run RBD workload here
   lttng stop
   ```

2. Process the trace with [rbd-replay-prep](https://docs.ceph.com/en/latest/man/8/rbd-replay-prep):

   ```
   rbd-replay-prep traces/ust/uid/*/* replay.bin
   ```

3. Replay the trace with [rbd-replay](https://docs.ceph.com/en/latest/man/8/rbd-replay). Use read-only until you know it’s doing what you want:

   ```
   rbd-replay --read-only replay.bin
   ```

Important

`rbd-replay` will destroy data by default.  Do not use against an image you wish to keep, unless you use the `--read-only` option.

The replayed workload does not have to be against the same RBD image or even the same cluster as the captured workload. To account for differences, you may need to use the `--pool` and `--map-image` options of `rbd-replay`.        

## Ceph Block Device 3rd Party Integration

## Kernel Module Operations

Important

To use kernel module operations, you must have a running Ceph cluster.

### Get a List of Images

To mount a block device image, first return a list of the images.

```
rbd list
```

### Map a Block Device

Use `rbd` to map an image name to a kernel module. You must specify the image name, the pool name, and the user name. `rbd` will load RBD kernel module on your behalf if it’s not already loaded.

```
sudo rbd device map {pool-name}/{image-name} --id {user-name}
```

For example:

```
sudo rbd device map rbd/myimage --id admin
```

If you use [cephx](https://docs.ceph.com/en/latest/rados/operations/user-management/) authentication, you must also specify a secret.  It may come from a keyring or a file containing the secret.

```
sudo rbd device map rbd/myimage --id admin --keyring /path/to/keyring
sudo rbd device map rbd/myimage --id admin --keyfile /path/to/file
```

### Show Mapped Block Devices

To show block device images mapped to kernel modules with the `rbd`, specify `device list` arguments.

```
rbd device list
```

### Unmapping a Block Device

To unmap a block device image with the `rbd` command, specify the `device unmap` arguments and the device name (i.e., by convention the same as the block device image name).

```
sudo rbd device unmap /dev/rbd/{poolname}/{imagename}
```

For example:

```
sudo rbd device unmap /dev/rbd/rbd/foo
```

## QEMU and Block Devices

The most frequent Ceph Block Device use case involves providing block device images to virtual machines. For example, a user may create  a “golden” image with an OS and any relevant software in an ideal configuration. Then the user takes a snapshot of the image. Finally the user clones the snapshot (potentially many times). See [Snapshots](https://docs.ceph.com/en/latest/rbd/rbd-snapshot/) for details. The ability to make copy-on-write clones of a snapshot means that Ceph can provision block device images to virtual machines quickly, because the client doesn’t have to download the entire image each time it spins up a new virtual machine.

 ![img](../../Image/d/ditaa-bbd41a7cab7cb23689a82425f7f13c4ac09eaefc.png)

Ceph Block Devices attach to QEMU virtual machines. For details on QEMU, see  [QEMU Open Source Processor Emulator](http://wiki.qemu.org/Main_Page). For QEMU documentation, see [QEMU Manual](http://wiki.qemu.org/Manual). For installation details, see [Installation](https://docs.ceph.com/en/latest/install).

Important

To use Ceph Block Devices with QEMU, you must have access to a running Ceph cluster.

### Usage[](https://docs.ceph.com/en/latest/rbd/qemu-rbd/#usage)

The QEMU command line expects you to specify the Ceph pool and image name. You may also specify a snapshot.

QEMU will assume that Ceph configuration resides in the default location (e.g., `/etc/ceph/$cluster.conf`) and that you are executing commands as the default `client.admin` user unless you expressly specify another Ceph configuration file path or another user. When specifying a user, QEMU uses the `ID` rather than the full `TYPE:ID`. See [User Management - User](https://docs.ceph.com/en/latest/rados/operations/user-management#user) for details. Do not prepend the client type (i.e., `client.`) to the beginning of the user  `ID`, or you will receive an authentication error. You should have the key for the `admin` user or the key of another user you specify with the `:id={user}` option in a keyring file stored in default path (i.e., `/etc/ceph` or the local directory with appropriate file ownership and permissions. Usage takes the following form:

```
qemu-img {command} [options] rbd:{pool-name}/{image-name}[@snapshot-name][:option1=value1][:option2=value2...]
```

For example, specifying the `id` and `conf` options might look like the following:

```
qemu-img {command} [options] rbd:glance-pool/maipo:id=glance:conf=/etc/ceph/ceph.conf
```

Tip

Configuration values containing `:`, `@`, or `=` can be escaped with a leading `\` character.

### Creating Images with QEMU

You can create a block device image from QEMU. You must specify `rbd`,  the pool name, and the name of the image you wish to create. You must also specify the size of the image.

```
qemu-img create -f raw rbd:{pool-name}/{image-name} {size}
```

For example:

```
qemu-img create -f raw rbd:data/foo 10G
```

Important

The `raw` data format is really the only sensible `format` option to use with RBD. Technically, you could use other QEMU-supported formats (such as `qcow2` or `vmdk`), but doing so would add additional overhead, and would also render the volume unsafe for virtual machine live migration when caching (see below) is enabled.

### Resizing Images with QEMU

You can resize a block device image from QEMU. You must specify `rbd`, the pool name, and the name of the image you wish to resize. You must also specify the size of the image.

```
qemu-img resize rbd:{pool-name}/{image-name} {size}
```

For example:

```
qemu-img resize rbd:data/foo 10G
```

## Retrieving Image Info with QEMU

You can retrieve block device image information from QEMU. You must specify `rbd`, the pool name, and the name of the image.

```
qemu-img info rbd:{pool-name}/{image-name}
```

For example:

```
qemu-img info rbd:data/foo
```

### Running QEMU with RBD

QEMU can pass a block device from the host on to a guest, but since QEMU 0.15, there’s no need to map an image as a block device on the host. Instead, QEMU attaches an image as a virtual block device directly via `librbd`. This strategy increases performance by avoiding context switches and taking advantage of [RBD caching](https://docs.ceph.com/en/latest/rbd/rbd-config-ref/#rbd-cache-config-settings).

You can use `qemu-img` to convert existing virtual machine images to Ceph block device images. For example, if you have a qcow2 image, you could run:

```
qemu-img convert -f qcow2 -O raw debian_squeeze.qcow2 rbd:data/squeeze
```

To run a virtual machine booting from that image, you could run:

```
qemu -m 1024 -drive format=raw,file=rbd:data/squeeze
```

[RBD caching](https://docs.ceph.com/en/latest/rbd/rbd-config-ref/#rbd-cache-config-settings) can significantly improve performance. Since QEMU 1.2, QEMU’s cache options control `librbd` caching:

```
qemu -m 1024 -drive format=rbd,file=rbd:data/squeeze,cache=writeback
```

If you have an older version of QEMU, you can set the `librbd` cache configuration (like any Ceph configuration option) as part of the ‘file’ parameter:

```
qemu -m 1024 -drive format=raw,file=rbd:data/squeeze:rbd_cache=true,cache=writeback
```

Important

If you set rbd_cache=true, you must set cache=writeback or risk data loss. Without cache=writeback, QEMU will not send flush requests to librbd. If QEMU exits uncleanly in this configuration, file systems on top of rbd can be corrupted.



## Enabling Discard/TRIM

Since Ceph version 0.46 and QEMU version 1.1, Ceph Block Devices support the discard operation. This means that a guest can send TRIM requests to let a Ceph block device reclaim unused space. This can be enabled in the guest by mounting `ext4` or `XFS` with the `discard` option.

For this to be available to the guest, it must be explicitly enabled for the block device. To do this, you must specify a `discard_granularity` associated with the drive:

```
qemu -m 1024 -drive format=raw,file=rbd:data/squeeze,id=drive1,if=none \
     -device driver=ide-hd,drive=drive1,discard_granularity=512
```

Note that this uses the IDE driver. The virtio driver does not support discard.

If using libvirt, edit your libvirt domain’s configuration file using `virsh edit` to include the `xmlns:qemu` value. Then, add a `qemu:commandline` block as a child of that domain. The following example shows how to set two devices with `qemu id=` to different `discard_granularity` values.

```
<domain type='kvm' xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>
        <qemu:commandline>
                <qemu:arg value='-set'/>
                <qemu:arg value='block.scsi0-0-0.discard_granularity=4096'/>
                <qemu:arg value='-set'/>
                <qemu:arg value='block.scsi0-0-1.discard_granularity=65536'/>
        </qemu:commandline>
</domain>
```



## QEMU Cache Options

QEMU’s cache options correspond to the following Ceph [RBD Cache](https://docs.ceph.com/en/latest/rbd/rbd-config-ref/) settings.

Writeback:

```
rbd_cache = true
```

Writethrough:

```
rbd_cache = true
rbd_cache_max_dirty = 0
```

None:

```
rbd_cache = false
```

QEMU’s cache settings override Ceph’s cache settings (including settings that are explicitly set in the Ceph configuration file).

Note

Prior to QEMU v2.4.0, if you explicitly set [RBD Cache](https://docs.ceph.com/en/latest/rbd/rbd-config-ref/) settings in the Ceph configuration file, your Ceph settings override the QEMU cache settings.

# Using libvirt with Ceph RBD

The `libvirt` library creates a virtual machine abstraction layer between hypervisor interfaces and the software applications that use them. With `libvirt`, developers and system administrators can focus on a common management framework, common API, and common shell interface (i.e., `virsh`) to many different hypervisors, including:

- QEMU/KVM
- XEN
- LXC
- VirtualBox
- etc.

Ceph block devices support QEMU/KVM. You can use Ceph block devices with software that interfaces with `libvirt`. The following stack diagram illustrates how `libvirt` and QEMU use Ceph block devices via `librbd`.

 ![img](../../Image/d/ditaa-85d66af9d7a5acde5cc8e5621fd253044b078e0d.png)

The most common `libvirt` use case involves providing Ceph block devices to cloud solutions like OpenStack or CloudStack. The cloud solution uses `libvirt` to  interact with QEMU/KVM, and QEMU/KVM interacts with Ceph block devices via  `librbd`. See [Block Devices and OpenStack](https://docs.ceph.com/en/latest/rbd/rbd-openstack) and [Block Devices and CloudStack](https://docs.ceph.com/en/latest/rbd/rbd-cloudstack) for details. See [Installation](https://docs.ceph.com/en/latest/install) for installation details.

You can also use Ceph block devices with `libvirt`, `virsh` and the `libvirt` API. See [libvirt Virtualization API](http://www.libvirt.org) for details.

To create VMs that use Ceph block devices, use the procedures in the following sections. In the exemplary embodiment, we have used `libvirt-pool` for the pool name, `client.libvirt` for the user name, and `new-libvirt-image` for  the image name. You may use any value you like, but ensure you replace those values when executing commands in the subsequent procedures.

## Configuring Ceph

To configure Ceph for use with `libvirt`, perform the following steps:

1. [Create a pool](https://docs.ceph.com/en/latest/rados/operations/pools#create-a-pool). The following example uses the pool name `libvirt-pool`.:

   ```
   ceph osd pool create libvirt-pool
   ```

   Verify the pool exists.

   ```
   ceph osd lspools
   ```

2. Use the `rbd` tool to initialize the pool for use by RBD:

   ```
   rbd pool init <pool-name>
   ```

3. [Create a Ceph User](https://docs.ceph.com/en/latest/rados/operations/user-management#add-a-user) (or use `client.admin` for version 0.9.7 and earlier). The following example uses the Ceph user name `client.libvirt` and references `libvirt-pool`.

   ```
   ceph auth get-or-create client.libvirt mon 'profile rbd' osd 'profile rbd pool=libvirt-pool'
   ```

   Verify the name exists.

   ```
   ceph auth ls
   ```

   **NOTE**: `libvirt` will access Ceph using the ID `libvirt`, not the Ceph name `client.libvirt`. See [User Management - User](https://docs.ceph.com/en/latest/rados/operations/user-management#user) and [User Management - CLI](https://docs.ceph.com/en/latest/rados/operations/user-management#command-line-usage) for a detailed explanation of the difference between ID and name.

4. Use QEMU to [create an image](https://docs.ceph.com/en/latest/rbd/qemu-rbd#creating-images-with-qemu) in your RBD pool. The following example uses the image name `new-libvirt-image` and references `libvirt-pool`.

   ```
   qemu-img create -f rbd rbd:libvirt-pool/new-libvirt-image 2G
   ```

   Verify the image exists.

   ```
   rbd -p libvirt-pool ls
   ```

   **NOTE:** You can also use [rbd create](https://docs.ceph.com/en/latest/rbd/rados-rbd-cmds#creating-a-block-device-image) to create an image, but we recommend ensuring that QEMU is working properly.

Tip

Optionally, if you wish to enable debug logs and the admin socket for this client, you can add the following section to `/etc/ceph/ceph.conf`:

```
[client.libvirt]
log file = /var/log/ceph/qemu-guest-$pid.log
admin socket = /var/run/ceph/$cluster-$type.$id.$pid.$cctid.asok
```

The `client.libvirt` section name should match the cephx user you created above. If SELinux or AppArmor is enabled, note that this could prevent the client process (qemu via libvirt) from doing some operations, such as writing logs or operate the images or admin socket to the destination locations (`/var/ log/ceph` or `/var/run/ceph`). Additionally, make sure that the libvirt and qemu users have appropriate access to the specified directory.

## Preparing the VM Manager

You may use `libvirt` without a VM manager, but you may find it simpler to create your first domain with `virt-manager`.

1. Install a virtual machine manager. See [KVM/VirtManager](https://help.ubuntu.com/community/KVM/VirtManager) for details.

   ```
   sudo apt-get install virt-manager
   ```

2. Download an OS image (if necessary).

3. Launch the virtual machine manager.

   ```
   sudo virt-manager
   ```

## Creating a VM

To create a VM with `virt-manager`, perform the following steps:

1. Press the **Create New Virtual Machine** button.

2. Name the new virtual machine domain. In the exemplary embodiment, we use the name `libvirt-virtual-machine`. You may use any name you wish, but ensure you replace `libvirt-virtual-machine` with the name you choose in subsequent commandline and configuration examples.

   ```
   libvirt-virtual-machine
   ```

3. Import the image.

   ```
   /path/to/image/recent-linux.img
   ```

   **NOTE:** Import a recent image. Some older images may not rescan for virtual devices properly.

4. Configure and start the VM.

5. You may use `virsh list` to verify the VM domain exists.

   ```
   sudo virsh list
   ```

6. Login to the VM (root/root)

7. Stop the VM before configuring it for use with Ceph.

## Configuring the VM

When configuring the VM for use with Ceph, it is important  to use `virsh` where appropriate. Additionally, `virsh` commands often require root privileges  (i.e., `sudo`) and will not return appropriate results or notify you that root privileges are required. For a reference of `virsh` commands, refer to [Virsh Command Reference](http://www.libvirt.org/virshcmdref.html).

1. Open the configuration file with `virsh edit`.

   ```
   sudo virsh edit {vm-domain-name}
   ```

   Under `<devices>` there should be a `<disk>` entry.

   ```
   <devices>
           <emulator>/usr/bin/kvm</emulator>
           <disk type='file' device='disk'>
                   <driver name='qemu' type='raw'/>
                   <source file='/path/to/image/recent-linux.img'/>
                   <target dev='vda' bus='virtio'/>
                   <address type='drive' controller='0' bus='0' unit='0'/>
           </disk>
   ```

   Replace `/path/to/image/recent-linux.img` with the path to the OS image. The minimum kernel for using the faster `virtio` bus is 2.6.25. See [Virtio](http://www.linux-kvm.org/page/Virtio) for details.

   **IMPORTANT:** Use `sudo virsh edit` instead of a text editor. If you edit the configuration file under `/etc/libvirt/qemu` with a text editor, `libvirt` may not recognize the change. If there is a discrepancy between the contents of the XML file under `/etc/libvirt/qemu` and the result of `sudo virsh dumpxml {vm-domain-name}`, then your VM may not work properly.

2. Add the Ceph RBD image you created as a `<disk>` entry.

   ```
   <disk type='network' device='disk'>
           <source protocol='rbd' name='libvirt-pool/new-libvirt-image'>
                   <host name='{monitor-host}' port='6789'/>
           </source>
           <target dev='vdb' bus='virtio'/>
   </disk>
   ```

   Replace `{monitor-host}` with the name of your host, and replace the pool and/or image name as necessary. You may add multiple `<host>` entries for your Ceph monitors. The `dev` attribute is the logical device name that will appear under the `/dev` directory of your VM. The optional `bus` attribute indicates the type of disk device to emulate. The valid settings are driver specific (e.g., “ide”, “scsi”, “virtio”, “xen”, “usb” or “sata”).

   See [Disks](http://www.libvirt.org/formatdomain.html#elementsDisks) for details of the `<disk>` element, and its child elements and attributes.

3. Save the file.

4. If your Ceph Storage Cluster has [Ceph Authentication](https://docs.ceph.com/en/latest/rados/configuration/auth-config-ref) enabled (it does by default), you must generate a secret.

   ```
   cat > secret.xml <<EOF
   <secret ephemeral='no' private='no'>
           <usage type='ceph'>
                   <name>client.libvirt secret</name>
           </usage>
   </secret>
   EOF
   ```

5. Define the secret.

   ```
   sudo virsh secret-define --file secret.xml
   {uuid of secret}
   ```

6. Get the `client.libvirt` key and save the key string to a file.

   ```
   ceph auth get-key client.libvirt | sudo tee client.libvirt.key
   ```

7. Set the UUID of the secret.

   ```
   sudo virsh secret-set-value --secret {uuid of secret} --base64 $(cat client.libvirt.key) && rm client.libvirt.key secret.xml
   ```

   You must also set the secret manually by adding the following `<auth>` entry to the `<disk>` element you entered earlier (replacing the `uuid` value with the result from the command line example above).

   ```
   sudo virsh edit {vm-domain-name}
   ```

   Then, add `<auth></auth>` element to the domain configuration file:

   ```
   ...
   </source>
   <auth username='libvirt'>
           <secret type='ceph' uuid='{uuid of secret}'/>
   </auth>
   <target ...
   ```

   **NOTE:** The exemplary ID is `libvirt`, not the Ceph name `client.libvirt` as generated at step 2 of [Configuring Ceph](https://docs.ceph.com/en/latest/rbd/libvirt/#configuring-ceph). Ensure you use the ID component of the Ceph name you generated. If for some reason you need to regenerate the secret, you will have to execute `sudo virsh secret-undefine {uuid}` before executing `sudo virsh secret-set-value` again.

## Summary

Once you have configured the VM for use with Ceph, you can start the VM. To verify that the VM and Ceph are communicating, you may perform the following procedures.

1. Check to see if Ceph is running:

   ```
   ceph health
   ```

2. Check to see if the VM is running.

   ```
   sudo virsh list
   ```

3. Check to see if the VM is communicating with Ceph. Replace `{vm-domain-name}` with the name of your VM domain:

   ```
   sudo virsh qemu-monitor-command --hmp {vm-domain-name} 'info block'
   ```

4. Check to see if the device from `<target dev='vdb' bus='virtio'/>` exists:

   ```
   virsh domblklist {vm-domain-name} --details
   ```

If everything looks okay, you may begin using the Ceph block device within your VM.

# Block Devices and Kubernetes

You may use Ceph Block Device images with Kubernetes v1.13 and later through [ceph-csi](https://github.com/ceph/ceph-csi/), which dynamically provisions RBD images to back Kubernetes [volumes](https://kubernetes.io/docs/concepts/storage/volumes/) and maps these RBD images as block devices (optionally mounting a file system contained within the image) on worker nodes running [pods](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/) that reference an RBD-backed volume. Ceph stripes block device images as objects across the cluster, which means that large Ceph Block Device images have better performance than a standalone server!

To use Ceph Block Devices with Kubernetes v1.13 and higher, you must install and configure `ceph-csi` within your Kubernetes environment. The following diagram depicts the Kubernetes/Ceph technology stack.

 ![img](../../Image/d/ditaa-b2ae4b6fe24a5fb214de31111e1dd566eb60e83e.png)

Important

`ceph-csi` uses the RBD kernel modules by default which may not support all Ceph [CRUSH tunables](https://docs.ceph.com/en/latest/rados/operations/crush-map/#tunables) or [RBD image features](https://docs.ceph.com/en/latest/rbd/rbd-config-ref/#image-features).

## Create a Pool

By default, Ceph block devices use the `rbd` pool. Create a pool for Kubernetes volume storage. Ensure your Ceph cluster is running, then create the pool.

```
$ ceph osd pool create kubernetes
```

See [Create a Pool](https://docs.ceph.com/en/latest/rados/operations/pools#createpool) for details on specifying the number of placement groups for your pools, and [Placement Groups](https://docs.ceph.com/en/latest/rados/operations/placement-groups) for details on the number of placement groups you should set for your pools.

A newly created pool must be initialized prior to use. Use the `rbd` tool to initialize the pool:

```
$ rbd pool init kubernetes
```

## Configure ceph-csi

### Setup Ceph Client Authentication[](https://docs.ceph.com/en/latest/rbd/rbd-kubernetes/#setup-ceph-client-authentication)

Create a new user for Kubernetes and ceph-csi. Execute the following and record the generated key:

```
$ ceph auth get-or-create client.kubernetes mon 'profile rbd' osd 'profile rbd pool=kubernetes' mgr 'profile rbd pool=kubernetes'
[client.kubernetes]
    key = AQD9o0Fd6hQRChAAt7fMaSZXduT3NWEqylNpmg==
```

### Generate ceph-csi ConfigMap

The ceph-csi requires a ConfigMap object stored in Kubernetes to define the the Ceph monitor addresses for the Ceph cluster. Collect both the Ceph cluster unique fsid and the monitor addresses:

```
$ ceph mon dump
<...>
fsid b9127830-b0cc-4e34-aa47-9d1a2e9949a8
<...>
0: [v2:192.168.1.1:3300/0,v1:192.168.1.1:6789/0] mon.a
1: [v2:192.168.1.2:3300/0,v1:192.168.1.2:6789/0] mon.b
2: [v2:192.168.1.3:3300/0,v1:192.168.1.3:6789/0] mon.c
```

Note

`ceph-csi` currently only supports the [legacy V1 protocol](https://docs.ceph.com/en/latest/rados/configuration/msgr2/#address-formats).

Generate a csi-config-map.yaml file similar to the example below, substituting the fsid for “clusterID”, and the monitor addresses for “monitors”:

```
$ cat <<EOF > csi-config-map.yaml
---
apiVersion: v1
kind: ConfigMap
data:
  config.json: |-
    [
      {
        "clusterID": "b9127830-b0cc-4e34-aa47-9d1a2e9949a8",
        "monitors": [
          "192.168.1.1:6789",
          "192.168.1.2:6789",
          "192.168.1.3:6789"
        ]
      }
    ]
metadata:
  name: ceph-csi-config
EOF
```

Once generated, store the new ConfigMap object in Kubernetes:

```
$ kubectl apply -f csi-config-map.yaml
```

Recent versions of ceph-csi also require an additional ConfigMap object to define Key Management Service (KMS) provider details.  If KMS isn’t set up, put an empty configuration in a csi-kms-config-map.yaml file or refer to examples at https://github.com/ceph/ceph-csi/tree/master/examples/kms:

```
$ cat <<EOF > csi-kms-config-map.yaml
---
apiVersion: v1
kind: ConfigMap
data:
  config.json: |-
    {}
metadata:
  name: ceph-csi-encryption-kms-config
EOF
```

Once generated, store the new ConfigMap object in Kubernetes:

```
$ kubectl apply -f csi-kms-config-map.yaml
```

Recent versions of ceph-csi also require yet another ConfigMap object to define Ceph configuration to add to ceph.conf file inside CSI containers:

```
$ cat <<EOF > ceph-config-map.yaml
---
apiVersion: v1
kind: ConfigMap
data:
  ceph.conf: |
    [global]
    auth_cluster_required = cephx
    auth_service_required = cephx
    auth_client_required = cephx
  # keyring is a required key and its value should be empty
  keyring: |
metadata:
  name: ceph-config
EOF
```

Once generated, store the new ConfigMap object in Kubernetes:

```
$ kubectl apply -f ceph-config-map.yaml
```

### Generate ceph-csi cephx Secret

ceph-csi requires the cephx credentials for communicating with the Ceph cluster. Generate a csi-rbd-secret.yaml file similar to the example below, using the newly created Kubernetes user id and cephx key:

```
$ cat <<EOF > csi-rbd-secret.yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: csi-rbd-secret
  namespace: default
stringData:
  userID: kubernetes
  userKey: AQD9o0Fd6hQRChAAt7fMaSZXduT3NWEqylNpmg==
EOF
```

Once generated, store the new Secret object in Kubernetes:

```
$ kubectl apply -f csi-rbd-secret.yaml
```

### Configure ceph-csi Plugins

Create the required ServiceAccount and RBAC ClusterRole/ClusterRoleBinding Kubernetes objects. These objects do not necessarily need to be customized for your Kubernetes environment and therefore can be used as-is from the ceph-csi deployment YAMLs:

```
$ kubectl apply -f https://raw.githubusercontent.com/ceph/ceph-csi/master/deploy/rbd/kubernetes/csi-provisioner-rbac.yaml
$ kubectl apply -f https://raw.githubusercontent.com/ceph/ceph-csi/master/deploy/rbd/kubernetes/csi-nodeplugin-rbac.yaml
```

Finally, create the ceph-csi provisioner and node plugins. With the possible exception of the ceph-csi container release version, these objects do not necessarily need to be customized for your Kubernetes environment and therefore can be used as-is from the ceph-csi deployment YAMLs:

```
$ wget https://raw.githubusercontent.com/ceph/ceph-csi/master/deploy/rbd/kubernetes/csi-rbdplugin-provisioner.yaml
$ kubectl apply -f csi-rbdplugin-provisioner.yaml
$ wget https://raw.githubusercontent.com/ceph/ceph-csi/master/deploy/rbd/kubernetes/csi-rbdplugin.yaml
$ kubectl apply -f csi-rbdplugin.yaml
```

Important

The provisioner and node plugin YAMLs will, by default, pull the development release of the ceph-csi container (quay.io/cephcsi/cephcsi:canary). The YAMLs should be updated to use a release version container for production workloads.

## Using Ceph Block Devices

### Create a StorageClass

The Kubernetes StorageClass defines a class of storage. Multiple StorageClass objects can be created to map to different quality-of-service levels (i.e. NVMe vs HDD-based pools) and features.

For example, to create a ceph-csi StorageClass that maps to the kubernetes pool created above, the following YAML file can be used after ensuring that the “clusterID” property matches your Ceph cluster’s fsid:

```
$ cat <<EOF > csi-rbd-sc.yaml
---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
   name: csi-rbd-sc
provisioner: rbd.csi.ceph.com
parameters:
   clusterID: b9127830-b0cc-4e34-aa47-9d1a2e9949a8
   pool: kubernetes
   imageFeatures: layering
   csi.storage.k8s.io/provisioner-secret-name: csi-rbd-secret
   csi.storage.k8s.io/provisioner-secret-namespace: default
   csi.storage.k8s.io/controller-expand-secret-name: csi-rbd-secret
   csi.storage.k8s.io/controller-expand-secret-namespace: default
   csi.storage.k8s.io/node-stage-secret-name: csi-rbd-secret
   csi.storage.k8s.io/node-stage-secret-namespace: default
reclaimPolicy: Delete
allowVolumeExpansion: true
mountOptions:
   - discard
EOF
$ kubectl apply -f csi-rbd-sc.yaml
```

Note that in Kubernetes v1.14 and v1.15 volume expansion feature was in alpha status and required enabling ExpandCSIVolumes feature gate.

### Create a PersistentVolumeClaim

A PersistentVolumeClaim is a request for abstract storage resources by a user. The PersistentVolumeClaim would then be associated to a Pod resource to provision a PersistentVolume, which would be backed by a Ceph block image. An optional volumeMode can be included to select between a mounted file system (default) or raw block device-based volume.

Using ceph-csi, specifying Filesystem for volumeMode can support both ReadWriteOnce and ReadOnlyMany accessMode claims, and specifying Block for volumeMode can support ReadWriteOnce, ReadWriteMany, and ReadOnlyMany accessMode claims.

For example, to create a block-based PersistentVolumeClaim that utilizes the ceph-csi-based StorageClass created above, the following YAML can be used to request raw block storage from the csi-rbd-sc StorageClass:

```
$ cat <<EOF > raw-block-pvc.yaml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: raw-block-pvc
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Block
  resources:
    requests:
      storage: 1Gi
  storageClassName: csi-rbd-sc
EOF
$ kubectl apply -f raw-block-pvc.yaml
```

The following demonstrates and example of binding the above PersistentVolumeClaim to a Pod resource as a raw block device:

```
$ cat <<EOF > raw-block-pod.yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: pod-with-raw-block-volume
spec:
  containers:
    - name: fc-container
      image: fedora:26
      command: ["/bin/sh", "-c"]
      args: ["tail -f /dev/null"]
      volumeDevices:
        - name: data
          devicePath: /dev/xvda
  volumes:
    - name: data
      persistentVolumeClaim:
        claimName: raw-block-pvc
EOF
$ kubectl apply -f raw-block-pod.yaml
```

To create a file-system-based PersistentVolumeClaim that utilizes the ceph-csi-based StorageClass created above, the following YAML can be used to request a mounted file system (backed by an RBD image) from the csi-rbd-sc StorageClass:

```
$ cat <<EOF > pvc.yaml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: rbd-pvc
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 1Gi
  storageClassName: csi-rbd-sc
EOF
$ kubectl apply -f pvc.yaml
```

The following demonstrates and example of binding the above PersistentVolumeClaim to a Pod resource as a mounted file system:

```
$ cat <<EOF > pod.yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: csi-rbd-demo-pod
spec:
  containers:
    - name: web-server
      image: nginx
      volumeMounts:
        - name: mypvc
          mountPath: /var/lib/www/html
  volumes:
    - name: mypvc
      persistentVolumeClaim:
        claimName: rbd-pvc
        readOnly: false
EOF
$ kubectl apply -f pod.yaml
```

# Block Devices and Nomad

Like Kubernetes, Nomad can use Ceph Block Device. This is made possible by [ceph-csi](https://github.com/ceph/ceph-csi/), which allows you to dynamically provision RBD images or import existing RBD images.

Every version of Nomad is compatible with [ceph-csi](https://github.com/ceph/ceph-csi/), but the reference version of Nomad that was used to generate the procedures and guidance in this document is Nomad v1.1.2, the latest version available at the time of the writing of the document.

To use Ceph Block Devices with Nomad, you must install and configure `ceph-csi` within your Nomad environment. The following diagram shows the Nomad/Ceph technology stack.

 ![img](../../Image/d/ditaa-0434c70dc528ffec84868ffe221809bbac26fd1a.png)

Note

Nomad has many possible task drivers, but this example uses only a Docker container.

Important

`ceph-csi` uses the RBD kernel modules by default, which may not support all Ceph [CRUSH tunables](https://docs.ceph.com/en/latest/rados/operations/crush-map/#tunables) or [RBD image features](https://docs.ceph.com/en/latest/rbd/rbd-config-ref/#image-features).

## Create a Pool

By default, Ceph block devices use the `rbd` pool. Ensure that your Ceph cluster is running, then create a pool for Nomad persistent storage:

```
ceph osd pool create nomad
```

See [Create a Pool](https://docs.ceph.com/en/latest/rados/operations/pools#createpool) for details on specifying the number of placement groups for your pools. See [Placement Groups](https://docs.ceph.com/en/latest/rados/operations/placement-groups) for details on the number of placement groups you should set for your pools.

A newly created pool must be initialized prior to use. Use the `rbd` tool to initialize the pool:

```
rbd pool init nomad
```

## Configure ceph-csi

### Ceph Client Authentication Setup

Create a new user for Nomad and ceph-csi. Execute the following command and record the generated key:

```
ceph auth get-or-create client.nomad mon 'profile rbd' osd 'profile rbd pool=nomad' mgr 'profile rbd pool=nomad'
[client.nomad]
        key = AQAlh9Rgg2vrDxAARy25T7KHabs6iskSHpAEAQ==
```

### Configure Nomad

#### Configuring Nomad to Allow Containers to Use Privileged Mode[](https://docs.ceph.com/en/latest/rbd/rbd-nomad/#configuring-nomad-to-allow-containers-to-use-privileged-mode)

By default, Nomad doesn’t allow containers to use privileged mode. We must configure Nomad so that it allows containers to use privileged mode. Edit the Nomad configuration file by adding the following configuration block to /etc/nomad.d/nomad.hcl:

```
plugin "docker" {
  config {
    allow_privileged = true
  }
}
```

#### Loading the rbd module

Nomad must have the rbd module loaded. Run the following command to confirm that the rbd module is loaded:

```
lsmod | grep rbd
rbd                    94208  2
libceph               364544  1 rbd
```

If the rbd module is not loaded, load it:

```
sudo modprobe rbd
```

#### Restarting Nomad

Restart Nomad:

```
sudo systemctl restart nomad
```

## Create ceph-csi controller and plugin nodes

The [ceph-csi](https://github.com/ceph/ceph-csi/) plugin requires two components:

- **Controller plugin**: communicates with the provider’s API.
- **Node plugin**: executes tasks on the client.

Note

We’ll set the ceph-csi’s version in those files. See [ceph-csi release](https://github.com/ceph/ceph-csi#ceph-csi-container-images-and-release-compatibility) for information about ceph-csi’s compatibility with other versions.

### Configure controller plugin

The controller plugin requires the Ceph monitor addresses of the Ceph cluster. Collect both (1) the Ceph cluster unique fsid and (2) the monitor addresses:

```
ceph mon dump
<...>
fsid b9127830-b0cc-4e34-aa47-9d1a2e9949a8
<...>
0: [v2:192.168.1.1:3300/0,v1:192.168.1.1:6789/0] mon.a
1: [v2:192.168.1.2:3300/0,v1:192.168.1.2:6789/0] mon.b
2: [v2:192.168.1.3:3300/0,v1:192.168.1.3:6789/0] mon.c
```

Generate a `ceph-csi-plugin-controller.nomad` file similar to the example below. Substitute the fsid for “clusterID”, and the monitor addresses for “monitors”:

```
job "ceph-csi-plugin-controller" {
  datacenters = ["dc1"]
  group "controller" {
    network {
      port "metrics" {}
    }
    task "ceph-controller" {
      template {
        data        = <<EOF
[{
    "clusterID": "b9127830-b0cc-4e34-aa47-9d1a2e9949a8",
    "monitors": [
        "192.168.1.1",
        "192.168.1.2",
        "192.168.1.3"
    ]
}]
EOF
        destination = "local/config.json"
        change_mode = "restart"
      }
      driver = "docker"
      config {
        image = "quay.io/cephcsi/cephcsi:v3.3.1"
        volumes = [
          "./local/config.json:/etc/ceph-csi-config/config.json"
        ]
        mounts = [
          {
            type     = "tmpfs"
            target   = "/tmp/csi/keys"
            readonly = false
            tmpfs_options = {
              size = 1000000 # size in bytes
            }
          }
        ]
        args = [
          "--type=rbd",
          "--controllerserver=true",
          "--drivername=rbd.csi.ceph.com",
          "--endpoint=unix://csi/csi.sock",
          "--nodeid=${node.unique.name}",
          "--instanceid=${node.unique.name}-controller",
          "--pidlimit=-1",
          "--logtostderr=true",
          "--v=5",
          "--metricsport=$${NOMAD_PORT_metrics}"
        ]
      }
      resources {
        cpu    = 500
        memory = 256
      }
      service {
        name = "ceph-csi-controller"
        port = "metrics"
        tags = [ "prometheus" ]
      }
      csi_plugin {
        id        = "ceph-csi"
        type      = "controller"
        mount_dir = "/csi"
      }
    }
  }
}
```

### Configure plugin node

Generate a `ceph-csi-plugin-nodes.nomad` file similar to the example below. Substitute the fsid for “clusterID” and the monitor addresses for “monitors”:

```
job "ceph-csi-plugin-nodes" {
  datacenters = ["dc1"]
  type        = "system"
  group "nodes" {
    network {
      port "metrics" {}
    }
    task "ceph-node" {
      driver = "docker"
      template {
        data        = <<EOF
[{
    "clusterID": "b9127830-b0cc-4e34-aa47-9d1a2e9949a8",
    "monitors": [
        "192.168.1.1",
        "192.168.1.2",
        "192.168.1.3"
    ]
}]
EOF
        destination = "local/config.json"
        change_mode = "restart"
      }
      config {
        image = "quay.io/cephcsi/cephcsi:v3.3.1"
        volumes = [
          "./local/config.json:/etc/ceph-csi-config/config.json"
        ]
        mounts = [
          {
            type     = "tmpfs"
            target   = "/tmp/csi/keys"
            readonly = false
            tmpfs_options = {
              size = 1000000 # size in bytes
            }
          }
        ]
        args = [
          "--type=rbd",
          "--drivername=rbd.csi.ceph.com",
          "--nodeserver=true",
          "--endpoint=unix://csi/csi.sock",
          "--nodeid=${node.unique.name}",
          "--instanceid=${node.unique.name}-nodes",
          "--pidlimit=-1",
          "--logtostderr=true",
          "--v=5",
          "--metricsport=$${NOMAD_PORT_metrics}"
        ]
        privileged = true
      }
      resources {
        cpu    = 500
        memory = 256
      }
      service {
        name = "ceph-csi-nodes"
        port = "metrics"
        tags = [ "prometheus" ]
      }
      csi_plugin {
        id        = "ceph-csi"
        type      = "node"
        mount_dir = "/csi"
      }
    }
  }
}
```

### Start plugin controller and node

To start the plugin controller and the Nomad node, run the following commands:

```
nomad job run ceph-csi-plugin-controller.nomad
nomad job run ceph-csi-plugin-nodes.nomad
```

The [ceph-csi](https://github.com/ceph/ceph-csi/) image will be downloaded.

Check the plugin status after a few minutes:

```
nomad plugin status ceph-csi
ID                   = ceph-csi
Provider             = rbd.csi.ceph.com
Version              = 3.3.1
Controllers Healthy  = 1
Controllers Expected = 1
Nodes Healthy        = 1
Nodes Expected       = 1

Allocations
ID        Node ID   Task Group  Version  Desired  Status   Created    Modified
23b4db0c  a61ef171  nodes       4        run      running  3h26m ago  3h25m ago
fee74115  a61ef171  controller  6        run      running  3h26m ago  3h25m ago
```

## Using Ceph Block Devices

### Create rbd image

`ceph-csi` requires the cephx credentials for communicating with the Ceph cluster. Generate a `ceph-volume.hcl` file similar to the example below, using the newly created nomad user id and cephx key:

```
id = "ceph-mysql"
name = "ceph-mysql"
type = "csi"
plugin_id = "ceph-csi"
capacity_max = "200G"
capacity_min = "100G"

capability {
  access_mode     = "single-node-writer"
  attachment_mode = "file-system"
}

secrets {
  userID  = "admin"
  userKey = "AQAlh9Rgg2vrDxAARy25T7KHabs6iskSHpAEAQ=="
}

parameters {
  clusterID = "b9127830-b0cc-4e34-aa47-9d1a2e9949a8"
  pool = "nomad"
  imageFeatures = "layering"
}
```

After the `ceph-volume.hcl` file has been generated, create the volume:

```
nomad volume create ceph-volume.hcl
```

### Use rbd image with a container

As an exercise in using an rbd image with a container, modify the Hashicorp [nomad stateful](https://learn.hashicorp.com/tutorials/nomad/stateful-workloads-csi-volumes?in=nomad/stateful-workloads#create-the-job-file) example.

Generate a `mysql.nomad` file similar to the example below:

```
job "mysql-server" {
  datacenters = ["dc1"]
  type        = "service"
  group "mysql-server" {
    count = 1
    volume "ceph-mysql" {
      type      = "csi"
      attachment_mode = "file-system"
      access_mode     = "single-node-writer"
      read_only = false
      source    = "ceph-mysql"
    }
    network {
      port "db" {
        static = 3306
      }
    }
    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }
    task "mysql-server" {
      driver = "docker"
      volume_mount {
        volume      = "ceph-mysql"
        destination = "/srv"
        read_only   = false
      }
      env {
        MYSQL_ROOT_PASSWORD = "password"
      }
      config {
        image = "hashicorp/mysql-portworx-demo:latest"
        args  = ["--datadir", "/srv/mysql"]
        ports = ["db"]
      }
      resources {
        cpu    = 500
        memory = 1024
      }
      service {
        name = "mysql-server"
        port = "db"
        check {
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
```

Start the job:

```
nomad job run mysql.nomad
```

Check the status of the job:

```
nomad job status mysql-server
...
Status        = running
...
Allocations
ID        Node ID   Task Group    Version  Desired  Status   Created  Modified
38070da7  9ad01c63  mysql-server  0        run      running  6s ago   3s ago
```

To check that data are persistent, modify the database, purge the job, then create it using the same file. The same RBD image will be used (re-used, really).

# Block Devices and OpenStack

You can attach Ceph Block Device images to OpenStack instances through `libvirt`, which configures the QEMU interface to `librbd`. Ceph stripes block volumes across multiple OSDs within the cluster, which means that large volumes can realize better performance than local drives on a standalone server!

To use Ceph Block Devices with OpenStack, you must install QEMU, `libvirt`, and OpenStack first. We recommend using a separate physical node for your OpenStack installation. OpenStack recommends a minimum of 8GB of RAM and a quad-core processor. The following diagram depicts the OpenStack/Ceph technology stack.

 ![img](../../Image/d/ditaa-b5b3c1e5436bc4194b054c832b1538529c89979f.png)

Important

To use Ceph Block Devices with OpenStack, you must have access to a running Ceph Storage Cluster.

Three parts of OpenStack integrate with Ceph’s block devices:

- **Images**: OpenStack Glance manages images for VMs. Images are immutable. OpenStack treats images as binary blobs and downloads them accordingly.
- **Volumes**: Volumes are block devices. OpenStack uses volumes to boot VMs, or to attach volumes to running VMs. OpenStack manages volumes using Cinder services.
- **Guest Disks**: Guest disks are guest operating system disks. By default, when you boot a virtual machine, its disk appears as a file on the file system of the hypervisor (usually under `/var/lib/nova/instances/<uuid>/`). Prior to OpenStack Havana, the only way to boot a VM in Ceph was to use the boot-from-volume functionality of Cinder. However, now it is possible to boot every virtual machine inside Ceph directly without using Cinder, which is advantageous because it allows you to perform maintenance operations easily with the live-migration process. Additionally, if your hypervisor dies it is also convenient to trigger `nova evacuate` and reinstate the virtual machine elsewhere almost seamlessly. In doing so, [exclusive locks](https://docs.ceph.com/en/latest/rbd/rbd-exclusive-locks/#rbd-exclusive-locks) prevent multiple compute nodes from concurrently accessing the guest disk.

You can use OpenStack Glance to store images as Ceph Block Devices, and you can use Cinder to boot a VM using a copy-on-write clone of an image.

The instructions below detail the setup for Glance, Cinder and Nova, although they do not have to be used together. You may store images in Ceph block devices while running VMs using a local disk, or vice versa.

Important

Using QCOW2 for hosting a virtual machine disk is NOT recommended. If you want to boot virtual machines in Ceph (ephemeral backend or boot from volume), please use the `raw` image format within Glance.



## Create a Pool

By default, Ceph block devices live within the `rbd` pool. You may use any suitable pool by specifying it explicitly. We recommend creating a pool for Cinder and a pool for Glance. Ensure your Ceph cluster is running, then create the pools.

```
ceph osd pool create volumes
ceph osd pool create images
ceph osd pool create backups
ceph osd pool create vms
```

See [Create a Pool](https://docs.ceph.com/en/latest/rados/operations/pools#createpool) for detail on specifying the number of placement groups for your pools, and [Placement Groups](https://docs.ceph.com/en/latest/rados/operations/placement-groups) for details on the number of placement groups you should set for your pools.

Newly created pools must be initialized prior to use. Use the `rbd` tool to initialize the pools:

```
rbd pool init volumes
rbd pool init images
rbd pool init backups
rbd pool init vms
```

## Configure OpenStack Ceph Clients

The nodes running `glance-api`, `cinder-volume`, `nova-compute` and `cinder-backup` act as Ceph clients. Each requires the `ceph.conf` file:

```
ssh {your-openstack-server} sudo tee /etc/ceph/ceph.conf </etc/ceph/ceph.conf
```

### Install Ceph client packages

On the `glance-api` node, you will need the Python bindings for `librbd`:

```
sudo apt-get install python-rbd
sudo yum install python-rbd
```

On the `nova-compute`, `cinder-backup` and on the `cinder-volume` node, use both the Python bindings and the client command line tools:

```
sudo apt-get install ceph-common
sudo yum install ceph-common
```

### Setup Ceph Client Authentication

If you have [cephx authentication](https://docs.ceph.com/en/latest/rados/configuration/auth-config-ref/#enabling-disabling-cephx) enabled, create a new user for Nova/Cinder and Glance. Execute the following:

```
ceph auth get-or-create client.glance mon 'profile rbd' osd 'profile rbd pool=images' mgr 'profile rbd pool=images'
ceph auth get-or-create client.cinder mon 'profile rbd' osd 'profile rbd pool=volumes, profile rbd pool=vms, profile rbd-read-only pool=images' mgr 'profile rbd pool=volumes, profile rbd pool=vms'
ceph auth get-or-create client.cinder-backup mon 'profile rbd' osd 'profile rbd pool=backups' mgr 'profile rbd pool=backups'
```

Add the keyrings for `client.cinder`, `client.glance`, and `client.cinder-backup` to the appropriate nodes and change their ownership:

```
ceph auth get-or-create client.glance | ssh {your-glance-api-server} sudo tee /etc/ceph/ceph.client.glance.keyring
ssh {your-glance-api-server} sudo chown glance:glance /etc/ceph/ceph.client.glance.keyring
ceph auth get-or-create client.cinder | ssh {your-volume-server} sudo tee /etc/ceph/ceph.client.cinder.keyring
ssh {your-cinder-volume-server} sudo chown cinder:cinder /etc/ceph/ceph.client.cinder.keyring
ceph auth get-or-create client.cinder-backup | ssh {your-cinder-backup-server} sudo tee /etc/ceph/ceph.client.cinder-backup.keyring
ssh {your-cinder-backup-server} sudo chown cinder:cinder /etc/ceph/ceph.client.cinder-backup.keyring
```

Nodes running `nova-compute` need the keyring file for the `nova-compute` process:

```
ceph auth get-or-create client.cinder | ssh {your-nova-compute-server} sudo tee /etc/ceph/ceph.client.cinder.keyring
```

They also need to store the secret key of the `client.cinder` user in `libvirt`. The libvirt process needs it to access the cluster while attaching a block device from Cinder.

Create a temporary copy of the secret key on the nodes running `nova-compute`:

```
ceph auth get-key client.cinder | ssh {your-compute-node} tee client.cinder.key
```

Then, on the compute nodes, add the secret key to `libvirt` and remove the temporary copy of the key:

```
uuidgen
457eb676-33da-42ec-9a8c-9293d545c337

cat > secret.xml <<EOF
<secret ephemeral='no' private='no'>
  <uuid>457eb676-33da-42ec-9a8c-9293d545c337</uuid>
  <usage type='ceph'>
    <name>client.cinder secret</name>
  </usage>
</secret>
EOF
sudo virsh secret-define --file secret.xml
Secret 457eb676-33da-42ec-9a8c-9293d545c337 created
sudo virsh secret-set-value --secret 457eb676-33da-42ec-9a8c-9293d545c337 --base64 $(cat client.cinder.key) && rm client.cinder.key secret.xml
```

Save the uuid of the secret for configuring `nova-compute` later.

Important

You don’t necessarily need the UUID on all the compute nodes. However from a platform consistency perspective, it’s better to keep the same UUID.

## Configure OpenStack to use Ceph

### Configuring Glance

Glance can use multiple back ends to store images. To use Ceph block devices by default, configure Glance like the following.

#### Kilo and after

Edit `/etc/glance/glance-api.conf` and add under the `[glance_store]` section:

```
[glance_store]
stores = rbd
default_store = rbd
rbd_store_pool = images
rbd_store_user = glance
rbd_store_ceph_conf = /etc/ceph/ceph.conf
rbd_store_chunk_size = 8
```

For more information about the configuration options available in Glance please refer to the OpenStack Configuration Reference: http://docs.openstack.org/.

#### Enable copy-on-write cloning of images

Note that this exposes the back end location via Glance’s API, so the endpoint with this option enabled should not be publicly accessible.

##### Any OpenStack version except Mitaka

If you want to enable copy-on-write cloning of images, also add under the `[DEFAULT]` section:

```
show_image_direct_url = True
```

#### Disable cache management (any OpenStack version)

Disable the Glance cache management to avoid images getting cached under `/var/lib/glance/image-cache/`, assuming your configuration file has `flavor = keystone+cachemanagement`:

```
[paste_deploy]
flavor = keystone
```

#### Image properties

We recommend to use the following properties for your images:

- `hw_scsi_model=virtio-scsi`: add the virtio-scsi controller and get better performance and support for discard operation
- `hw_disk_bus=scsi`: connect every cinder block devices to that controller
- `hw_qemu_guest_agent=yes`: enable the QEMU guest agent
- `os_require_quiesce=yes`: send fs-freeze/thaw calls through the QEMU guest agent

### Configuring Cinder

OpenStack requires a driver to interact with Ceph block devices. You must also specify the pool name for the block device. On your OpenStack node, edit `/etc/cinder/cinder.conf` by adding:

```
[DEFAULT]
...
enabled_backends = ceph
glance_api_version = 2
...
[ceph]
volume_driver = cinder.volume.drivers.rbd.RBDDriver
volume_backend_name = ceph
rbd_pool = volumes
rbd_ceph_conf = /etc/ceph/ceph.conf
rbd_flatten_volume_from_snapshot = false
rbd_max_clone_depth = 5
rbd_store_chunk_size = 4
rados_connect_timeout = -1
```

If you are using [cephx authentication](https://docs.ceph.com/en/latest/rados/configuration/auth-config-ref/#enabling-disabling-cephx), also configure the user and uuid of the secret you added to `libvirt` as documented earlier:

```
[ceph]
...
rbd_user = cinder
rbd_secret_uuid = 457eb676-33da-42ec-9a8c-9293d545c337
```

Note that if you are configuring multiple cinder back ends, `glance_api_version = 2` must be in the `[DEFAULT]` section.

### Configuring Cinder Backup

OpenStack Cinder Backup requires a specific daemon so don’t forget to install it. On your Cinder Backup node, edit `/etc/cinder/cinder.conf` and add:

```
backup_driver = cinder.backup.drivers.ceph
backup_ceph_conf = /etc/ceph/ceph.conf
backup_ceph_user = cinder-backup
backup_ceph_chunk_size = 134217728
backup_ceph_pool = backups
backup_ceph_stripe_unit = 0
backup_ceph_stripe_count = 0
restore_discard_excess_bytes = true
```

### Configuring Nova to attach Ceph RBD block device

In order to attach Cinder devices (either normal block or by issuing a boot from volume), you must tell Nova (and libvirt) which user and UUID to refer to when attaching the device. libvirt will refer to this user when connecting and authenticating with the Ceph cluster.

```
[libvirt]
...
rbd_user = cinder
rbd_secret_uuid = 457eb676-33da-42ec-9a8c-9293d545c337
```

These two flags are also used by the Nova ephemeral back end.

### Configuring Nova

In order to boot virtual machines directly from Ceph volumes, you must configure the ephemeral backend for Nova.

It is recommended to enable the RBD cache in your Ceph configuration file; this has been enabled by default since the Giant release. Moreover, enabling the client admin socket allows the collection of metrics and can be invaluable for troubleshooting.

This socket can be accessed on the hypervisor (Nova compute) node:

```
ceph daemon /var/run/ceph/ceph-client.cinder.19195.32310016.asok help
```

To enable RBD cache and admin sockets, ensure that on each hypervisor’s `ceph.conf` contains:

```
[client]
    rbd cache = true
    rbd cache writethrough until flush = true
    admin socket = /var/run/ceph/guests/$cluster-$type.$id.$pid.$cctid.asok
    log file = /var/log/qemu/qemu-guest-$pid.log
    rbd concurrent management ops = 20
```

Configure permissions for these directories:

```
mkdir -p /var/run/ceph/guests/ /var/log/qemu/
chown qemu:libvirtd /var/run/ceph/guests /var/log/qemu/
```

Note that user `qemu` and group `libvirtd` can vary depending on your system. The provided example works for RedHat based systems.

Tip

If your virtual machine is already running you can simply restart it to enable the admin socket

## Restart OpenStack

To activate the Ceph block device driver and load the block device pool name into the configuration, you must restart the related OpenStack services. For Debian based systems execute these commands on the appropriate nodes:

```
sudo glance-control api restart
sudo service nova-compute restart
sudo service cinder-volume restart
sudo service cinder-backup restart
```

For Red Hat based systems execute:

```
sudo service openstack-glance-api restart
sudo service openstack-nova-compute restart
sudo service openstack-cinder-volume restart
sudo service openstack-cinder-backup restart
```

Once OpenStack is up and running, you should be able to create a volume and boot from it.

## Booting from a Block Device

You can create a volume from an image using the Cinder command line tool:

```
cinder create --image-id {id of image} --display-name {name of volume} {size of volume}
```

You can use [qemu-img](https://docs.ceph.com/en/latest/rbd/qemu-rbd/#running-qemu-with-rbd) to convert from one format to another. For example:

```
qemu-img convert -f {source-format} -O {output-format} {source-filename} {output-filename}
qemu-img convert -f qcow2 -O raw precise-cloudimg.img precise-cloudimg.raw
```

When Glance and Cinder are both using Ceph block devices, the image is a copy-on-write clone, so new volumes are created quickly. In the OpenStack dashboard, you can boot from that volume by performing the following steps:

1. Launch a new instance.
2. Choose the image associated to the copy-on-write clone.
3. Select ‘boot from volume’.
4. Select the volume you created.

# Block Devices and CloudStack

You may use Ceph Block Device images with CloudStack 4.0 and higher through `libvirt`, which configures the QEMU interface to `librbd`. Ceph stripes block device images as objects across the cluster, which means that large Ceph Block Device images have better performance than a standalone server!

To use Ceph Block Devices with CloudStack 4.0 and higher, you must install QEMU, `libvirt`, and CloudStack first. We recommend using a separate physical host for your CloudStack installation. CloudStack recommends a minimum of 4GB of RAM and a dual-core processor, but more CPU and RAM will perform better. The following diagram depicts the CloudStack/Ceph technology stack.

 ![img](../../Image/d/ditaa-7b38dc591b42b911dce0d516dcd89df9347de0dc.png)

Important

To use Ceph Block Devices with CloudStack, you must have access to a running Ceph Storage Cluster.

CloudStack integrates with Ceph’s block devices to provide CloudStack with a back end for CloudStack’s Primary Storage. The instructions below detail the setup for CloudStack Primary Storage.

Note

We recommend installing with Ubuntu 14.04 or later so that you can use package installation instead of having to compile libvirt from source.

Installing and configuring QEMU for use with CloudStack doesn’t require any special handling. Ensure that you have a running Ceph Storage Cluster. Install QEMU and configure it for use with Ceph; then, install `libvirt` version 0.9.13 or higher (you may need to compile from source) and ensure it is running with Ceph.

Note

Ubuntu 14.04 and CentOS 7.2 will have `libvirt` with RBD storage pool support enabled by default.



## Create a Pool

By default, Ceph block devices use the `rbd` pool. Create a pool for CloudStack NFS Primary Storage. Ensure your Ceph cluster is running, then create the pool.

```
ceph osd pool create cloudstack
```

See [Create a Pool](https://docs.ceph.com/en/latest/rados/operations/pools#createpool) for details on specifying the number of placement groups for your pools, and [Placement Groups](https://docs.ceph.com/en/latest/rados/operations/placement-groups) for details on the number of placement groups you should set for your pools.

A newly created pool must be initialized prior to use. Use the `rbd` tool to initialize the pool:

```
rbd pool init cloudstack
```

## Create a Ceph User

To access the Ceph cluster we require a Ceph user which has the correct credentials to access the `cloudstack` pool we just created. Although we could use `client.admin` for this, it’s recommended to create a user with only access to the `cloudstack` pool.

```
ceph auth get-or-create client.cloudstack mon 'profile rbd' osd 'profile rbd pool=cloudstack'
```

Use the information returned by the command in the next step when adding the Primary Storage.

See [User Management](https://docs.ceph.com/en/latest/rados/operations/user-management) for additional details.

## Add Primary Storage

To add a Ceph block device as Primary Storage, the steps include:

1. Log in to the CloudStack UI.
2. Click **Infrastructure** on the left side navigation bar.
3. Select **View All** under **Primary Storage**.
4. Click the **Add Primary Storage** button on the top right hand side.
5. Fill in the following information, according to your infrastructure setup:
   - Scope (i.e. Cluster or Zone-Wide).
   - Zone.
   - Pod.
   - Cluster.
   - Name of Primary Storage.
   - For **Protocol**, select `RBD`.
   - For **Provider**, select the appropriate provider  type (i.e. DefaultPrimary, SolidFire, SolidFireShared, or CloudByte).   Depending on the provider chosen, fill out the information pertinent to  your setup.
6. Add cluster information (`cephx` is supported).
   - For **RADOS Monitor**, provide the IP address of a Ceph monitor node.
   - For **RADOS Pool**, provide the name of an RBD pool.
   - For **RADOS User**, provide a user that has sufficient rights to the RBD pool. Note: Do not include the `client.` part of the user.
   - For **RADOS Secret**, provide the secret the user’s secret.
   - **Storage Tags** are optional. Use tags at your own discretion. For more information about storage tags in CloudStack, refer to [Storage Tags](http://docs.cloudstack.apache.org/en/latest/adminguide/storage.html#storage-tags).
7. Click **OK**.

## Create a Disk Offering

To create a new disk offering, refer to [Create a New Disk Offering](http://docs.cloudstack.apache.org/en/latest/adminguide/service_offerings.html#creating-a-new-disk-offering). Create a disk offering so that it matches the `rbd` tag. The `StoragePoolAllocator` will choose the  `rbd` pool when searching for a suitable storage pool. If the disk offering doesn’t match the `rbd` tag, the `StoragePoolAllocator` may select the pool you created (e.g., `cloudstack`).

## Limitations

- CloudStack will only bind to one monitor (You can however create a Round Robin DNS record over multiple monitors)

# Ceph iSCSI Gateway

The iSCSI Gateway presents a Highly Available (HA) iSCSI target that exports RADOS Block Device (RBD) images as SCSI disks. The iSCSI protocol allows clients (initiators) to send SCSI commands to storage devices (targets) over a TCP/IP network, enabling clients without native Ceph client support to access Ceph block storage.  These include Microsoft Windows and even BIOS.

Each iSCSI gateway exploits the Linux IO target kernel subsystem (LIO) to provide iSCSI protocol support. LIO utilizes userspace passthrough (TCMU) to interact with Ceph’s librbd library and expose RBD images to iSCSI clients. With Ceph’s iSCSI gateway you can provision a fully integrated block-storage infrastructure with all the features and benefits of a conventional Storage Area Network (SAN).

 ![img](../../Image/d/ditaa-564a237d5600d8518d6def6745857796a057ca08.png)

- [Requirements](https://docs.ceph.com/en/latest/rbd/iscsi-requirements/)
- [Configuring the iSCSI Target](https://docs.ceph.com/en/latest/rbd/iscsi-targets/)
- [Configuring the iSCSI Initiators](https://docs.ceph.com/en/latest/rbd/iscsi-initiators/)
- [Monitoring the iSCSI Gateways](https://docs.ceph.com/en/latest/rbd/iscsi-monitoring/)

# iSCSI Gateway Requirements

It is recommended to provision two to four iSCSI gateway nodes to realize a highly available Ceph iSCSI gateway solution.

For hardware recommendations, see [Hardware Recommendations](https://docs.ceph.com/en/latest/start/hardware-recommendations/#hardware-recommendations) .

Note

On iSCSI gateway nodes the memory footprint is a function of of the RBD images mapped and can grow to be large. Plan memory requirements accordingly based on the number RBD images to be mapped.

There are no specific iSCSI gateway options for the Ceph Monitors or OSDs, but it is important to lower the default heartbeat interval for detecting down OSDs to reduce the possibility of initiator timeouts. The following configuration options are suggested:

```
[osd]
osd heartbeat grace = 20
osd heartbeat interval = 5
```

- Updating Running State From a Ceph Monitor Node

> ```
> ceph tell <daemon_type>.<id> config set <parameter_name> <new_value>
> ceph tell osd.* config set osd_heartbeat_grace 20
> ceph tell osd.* config set osd_heartbeat_interval 5
> ```

- Updating Running State On Each OSD Node

  ```
  ceph daemon <daemon_type>.<id> config set osd_client_watch_timeout 15
  ```

  ```
  ceph daemon osd.0 config set osd_heartbeat_grace 20
  ceph daemon osd.0 config set osd_heartbeat_interval 5
  ```

For more details on setting Ceph’s configuration options, see [Configuring Ceph](https://docs.ceph.com/en/latest/rados/configuration/ceph-conf/#configuring-ceph).  Be sure to persist these settings in `/etc/ceph.conf` or, on Mimic and later releases, in the centralized config store.

# iSCSI Targets

Traditionally, block-level access to a Ceph storage cluster has been limited to QEMU and `librbd`, which is a key enabler for adoption within OpenStack environments. Starting with the Ceph Luminous release, block-level access is expanding to offer standard iSCSI support allowing wider platform usage, and potentially opening new use cases.

- Red Hat Enterprise Linux/CentOS 7.5 (or newer); Linux kernel v4.16 (or newer)
- A working Ceph Storage cluster, deployed with `ceph-ansible` or using the command-line interface
- iSCSI gateways nodes, which can either be colocated with OSD nodes or on dedicated nodes
- Separate network subnets for iSCSI front-end traffic and Ceph back-end traffic

A choice of using Ansible or the command-line interface are the available deployment methods for installing and configuring the Ceph iSCSI gateway:

- [Using Ansible](https://docs.ceph.com/en/latest/rbd/iscsi-target-ansible/)
- [Using the Command Line Interface](https://docs.ceph.com/en/latest/rbd/iscsi-target-cli/)

# Configuring the iSCSI Target using Ansible

The Ceph iSCSI gateway is the iSCSI target node and also a Ceph client node. The Ceph iSCSI gateway can be provisioned on dedicated node or be colocated on a Ceph Object Store Disk (OSD) node. The following steps will install and configure the Ceph iSCSI gateway for basic operation.

**Requirements:**

- A running Ceph Luminous (12.2.x) cluster or newer
- Red Hat Enterprise Linux/CentOS 7.5 (or newer); Linux kernel v4.16 (or newer)
- The `ceph-iscsi` package installed on all the iSCSI gateway nodes

**Installation:**

1. On the Ansible installer node, which could be either the administration node or a dedicated deployment node, perform the following steps:

   1. As `root`, install the `ceph-ansible` package:

      ```
      # yum install ceph-ansible
      ```

   2. Add an entry in `/etc/ansible/hosts` file for the gateway group:

      ```
      [iscsigws]
      ceph-igw-1
      ceph-igw-2
      ```

Note

If co-locating the iSCSI gateway with an OSD node, then add the OSD node to the `[iscsigws]` section.

**Configuration:**

The `ceph-ansible` package places a file in the `/usr/share/ceph-ansible/group_vars/` directory called `iscsigws.yml.sample`. Create a copy of this sample file named `iscsigws.yml`. Review the following Ansible variables and descriptions, and update accordingly. See the `iscsigws.yml.sample` for a full list of advanced variables.

| Variable                | Meaning/Purpose                                              |
| ----------------------- | ------------------------------------------------------------ |
| `seed_monitor`          | Each gateway needs access to the ceph cluster for rados and rbd calls. This means the iSCSI gateway must have an appropriate `/etc/ceph/` directory defined. The `seed_monitor` host is used to populate the iSCSI gateway’s `/etc/ceph/` directory. |
| `cluster_name`          | Define a custom storage cluster name.                        |
| `gateway_keyring`       | Define a custom keyring name.                                |
| `deploy_settings`       | If set to `true`, then deploy the settings when the playbook is ran. |
| `perform_system_checks` | This is a boolean value that checks for multipath and lvm configuration settings on each gateway. It must be set to true for at least the first run to ensure multipathd and lvm are configured properly. |
| `api_user`              | The user name for the API. The default is admin.             |
| `api_password`          | The password for using the API. The default is admin.        |
| `api_port`              | The TCP port number for using the API. The default is 5000.  |
| `api_secure`            | True if TLS must be used. The default is false. If true the user must create the necessary certificate and key files. See the gwcli man file for details. |
| `trusted_ip_list`       | A list of IPv4 or IPv6 addresses who have access to the API. By default, only the iSCSI gateway nodes have access. |

**Deployment:**

Perform the following steps on the Ansible installer node.

1. As `root`, execute the Ansible playbook:

   ```
   cd /usr/share/ceph-ansible
   ansible-playbook site.yml --limit iscsigws
   ```

   Note

   The Ansible playbook will handle RPM dependencies, setting up daemons, and installing gwcli so it can be used to create iSCSI targets and export RBD images as LUNs. In past versions, `iscsigws.yml` could define the iSCSI target and other objects like clients, images and LUNs, but this is no longer supported.

2. Verify the configuration from an iSCSI gateway node:

   ```
   gwcli ls
   ```

   Note

   See the [Configuring the iSCSI Target using the Command Line Interface](https://docs.ceph.com/en/latest/rbd/iscsi-target-cli) section to create gateways, LUNs, and clients using the gwcli tool.

   Important

   Attempting to use the `targetcli` tool to change the configuration will cause problems including ALUA misconfiguration and path failover issues. There is the potential to corrupt data, to have mismatched configuration across iSCSI gateways, and to have mismatched WWN information, leading to client multipath problems.

**Service Management:**

The `ceph-iscsi` package installs the configuration management logic and a Systemd service called `rbd-target-api`. When the Systemd service is enabled, the `rbd-target-api` will start at boot time and will restore the Linux IO state. The Ansible playbook disables the target service during the deployment. Below are the outcomes of when interacting with the `rbd-target-api` Systemd service.

```
systemctl <start|stop|restart|reload> rbd-target-api
```

- `reload`

  A reload request will force `rbd-target-api` to reread the configuration and apply it to the current running environment. This is normally not required, since changes are deployed in parallel from Ansible to all iSCSI gateway nodes

- `stop`

  A stop request will close the gateway’s portal interfaces, dropping connections to clients and wipe the current LIO configuration from the kernel. This returns the iSCSI gateway to a clean state. When clients are disconnected, active I/O is rescheduled to the other iSCSI gateways by the client side multipathing layer.

**Removing the Configuration:**

The `ceph-ansible` package provides an Ansible playbook to remove the iSCSI gateway configuration and related RBD images. The Ansible playbook is `/usr/share/ceph-ansible/purge_gateways.yml`. When this Ansible playbook is ran a prompted for the type of purge to perform:

*lio* :

In this mode the LIO configuration is purged on all iSCSI gateways that are defined. Disks that were created are left untouched within the Ceph storage cluster.

*all* :

When `all` is chosen, the LIO configuration is removed together with **all** RBD images that were defined within the iSCSI gateway environment, other unrelated RBD images will not be removed. Ensure the correct mode is chosen, this operation will delete data.

Warning

A purge operation is destructive action against your iSCSI gateway environment.

Warning

A purge operation will fail, if RBD images have snapshots or clones and are exported through the Ceph iSCSI gateway.

```
ansible-playbook purge_gateways.yml
Which configuration elements should be purged? (all, lio or abort) [abort]: all


PLAY [Confirm removal of the iSCSI gateway configuration] *********************


GATHERING FACTS ***************************************************************
ok: [localhost]


TASK: [Exit playbook if user aborted the purge] *******************************
skipping: [localhost]


TASK: [set_fact ] *************************************************************
ok: [localhost]


PLAY [Removing the gateway configuration] *************************************


GATHERING FACTS ***************************************************************
ok: [ceph-igw-1]
ok: [ceph-igw-2]


TASK: [igw_purge | purging the gateway configuration] *************************
changed: [ceph-igw-1]
changed: [ceph-igw-2]


TASK: [igw_purge | deleting configured rbd devices] ***************************
changed: [ceph-igw-1]
changed: [ceph-igw-2]


PLAY RECAP ********************************************************************
ceph-igw-1                 : ok=3    changed=2    unreachable=0    failed=0
ceph-igw-2                 : ok=3    changed=2    unreachable=0    failed=0
localhost                  : ok=2    changed=0    unreachable=0    failed=0
```

 Configuring the iSCSI Target using the Command Line Interface[](https://docs.ceph.com/en/latest/rbd/iscsi-target-cli/#configuring-the-iscsi-target-using-the-command-line-interface)

The Ceph iSCSI gateway is both an iSCSI target  and a Ceph client; think of it as a “translator” between Ceph’s RBD interface and the iSCSI standard. The Ceph iSCSI gateway can run on a standalone node or be colocated with other daemons eg. on a Ceph Object Store Disk (OSD) node.  When co-locating, ensure that sufficient CPU and memory are available to share. The following steps install and configure the Ceph iSCSI gateway for basic operation.

**Requirements:**

- A running Ceph Luminous or later storage cluster

- Red Hat Enterprise Linux/CentOS 7.5 (or newer); Linux kernel v4.16 (or newer)

- The following packages must be installed from your Linux distribution’s software repository:

  - `targetcli-2.1.fb47` or newer package
  - `python-rtslib-2.1.fb68` or newer package
  - `tcmu-runner-1.4.0` or newer package
  - `ceph-iscsi-3.2` or newer package

  > Important
  >
  > If previous versions of these packages exist, then they must be removed first before installing the newer versions.

Do the following steps on the Ceph iSCSI gateway node before proceeding to the *Installing* section:

1. If the Ceph iSCSI gateway is not colocated on an OSD node, then copy the Ceph configuration files, located in `/etc/ceph/`, from a running Ceph node in the storage cluster to the iSCSI Gateway node. The Ceph configuration files must exist on the iSCSI gateway node under `/etc/ceph/`.

2. Install and configure the [Ceph Command-line Interface](https://docs.ceph.com/en/latest/start/quick-rbd/#install-ceph)

3. If needed, open TCP ports 3260 and 5000 on the firewall.

   Note

   Access to port 5000 should be restricted to a trusted internal network or only the individual hosts where `gwcli` is used or `ceph-mgr` daemons are running.

4. Create a new or use an existing RADOS Block Device (RBD).

**Installing:**

If you are using the upstream ceph-iscsi package follow the [manual install instructions](https://docs.ceph.com/en/latest/rbd/iscsi-target-cli-manual-install).



For rpm based instructions execute the following commands:

1. As `root`, on all iSCSI gateway nodes, install the `ceph-iscsi` package:

   ```
   yum install ceph-iscsi
   ```

2. As `root`, on all iSCSI gateway nodes, install the `tcmu-runner` package:

   ```
   yum install tcmu-runner
   ```

**Setup:**

1. gwcli requires a pool with the name `rbd`, so it can store metadata like the iSCSI configuration. To check if this pool has been created run:

   ```
   ceph osd lspools
   ```

   If it does not exist instructions for creating pools can be found on the [RADOS pool operations page](http://docs.ceph.com/en/latest/rados/operations/pools/).

2. As `root`, on a iSCSI gateway node, create a file named `iscsi-gateway.cfg` in the `/etc/ceph/` directory:

   ```
   touch /etc/ceph/iscsi-gateway.cfg
   ```

   1. Edit the `iscsi-gateway.cfg` file and add the following lines:

      ```
      [config]
      # Name of the Ceph storage cluster. A suitable Ceph configuration file allowing
      # access to the Ceph storage cluster from the gateway node is required, if not
      # colocated on an OSD node.
      cluster_name = ceph
      
      # Place a copy of the ceph cluster's admin keyring in the gateway's /etc/ceph
      # drectory and reference the filename here
      gateway_keyring = ceph.client.admin.keyring
      
      
      # API settings.
      # The API supports a number of options that allow you to tailor it to your
      # local environment. If you want to run the API under https, you will need to
      # create cert/key files that are compatible for each iSCSI gateway node, that is
      # not locked to a specific node. SSL cert and key files *must* be called
      # 'iscsi-gateway.crt' and 'iscsi-gateway.key' and placed in the '/etc/ceph/' directory
      # on *each* gateway node. With the SSL files in place, you can use 'api_secure = true'
      # to switch to https mode.
      
      # To support the API, the bare minimum settings are:
      api_secure = false
      
      # Additional API configuration options are as follows, defaults shown.
      # api_user = admin
      # api_password = admin
      # api_port = 5001
      # trusted_ip_list = 192.168.0.10,192.168.0.11
      ```

      Note

      trusted_ip_list is a list of IP addresses on each iSCSI gateway that will be used for management operations like target creation, LUN exporting, etc. The IP can be the same that will be used for iSCSI data, like READ/WRITE commands to/from the RBD image, but using separate IPs is recommended.

      Important

      The `iscsi-gateway.cfg` file must be identical on all iSCSI gateway nodes.

   2. As `root`, copy the `iscsi-gateway.cfg` file to all iSCSI gateway nodes.

3. As `root`, on all iSCSI gateway nodes, enable and start the API service:

   ```
   systemctl daemon-reload
   
   systemctl enable rbd-target-gw
   systemctl start rbd-target-gw
   
   systemctl enable rbd-target-api
   systemctl start rbd-target-api
   ```

**Configuring:**

gwcli will create and configure the iSCSI target and RBD images and copy the configuration across the gateways setup in the last section. Lower level tools including targetcli and rbd can be used to query the local configuration, but should not be used to modify it. This next section will demonstrate how to create a iSCSI target and export a RBD image as LUN 0.

1. As `root`, on a iSCSI gateway node, start the iSCSI gateway command-line interface:

   ```
   gwcli
   ```

2. Go to iscsi-targets and create a target with the name iqn.2003-01.com.redhat.iscsi-gw:iscsi-igw:

   ```
   > /> cd /iscsi-targets
   > /iscsi-targets>  create iqn.2003-01.com.redhat.iscsi-gw:iscsi-igw
   ```

3. Create the iSCSI gateways. The IPs used below are the ones that will be used for iSCSI data like READ and WRITE commands. They can be the same IPs used for management operations listed in trusted_ip_list, but it is recommended that different IPs are used.

   ```
   > /iscsi-targets> cd iqn.2003-01.com.redhat.iscsi-gw:iscsi-igw/gateways
   > /iscsi-target...-igw/gateways>  create ceph-gw-1 10.172.19.21
   > /iscsi-target...-igw/gateways>  create ceph-gw-2 10.172.19.22
   ```

   If not using RHEL/CentOS or using an upstream or ceph-iscsi-test kernel, the skipchecks=true argument must be used. This will avoid the Red Hat kernel and rpm checks:

   ```
   > /iscsi-targets> cd iqn.2003-01.com.redhat.iscsi-gw:iscsi-igw/gateways
   > /iscsi-target...-igw/gateways>  create ceph-gw-1 10.172.19.21 skipchecks=true
   > /iscsi-target...-igw/gateways>  create ceph-gw-2 10.172.19.22 skipchecks=true
   ```

4. Add a RBD image with the name disk_1 in the pool rbd:

   ```
   > /iscsi-target...-igw/gateways> cd /disks
   > /disks> create pool=rbd image=disk_1 size=90G
   ```

5. Create a client with the initiator name iqn.1994-05.com.redhat:rh7-client:

   ```
   > /disks> cd /iscsi-targets/iqn.2003-01.com.redhat.iscsi-gw:iscsi-igw/hosts
   > /iscsi-target...eph-igw/hosts>  create iqn.1994-05.com.redhat:rh7-client
   ```

6. Set the initiator CHAP username and password which the target would use when authenticating the initiator:

   ```
   > /iscsi-target...at:rh7-client>  auth username=myusername password=mypassword
   ```

   Warning

   CHAP must always be configured. Without CHAP, the target will reject any login requests.

   To use mutual (bidirectional) authentication, also set the target CHAP username and password which the initiator would use when authenticating the target:

   ```
   > /iscsi-target...at:rh7-client>  auth username=myusername password=mypassword mutual_username=mytgtusername mutual_password=mytgtpassword
   ```

   Note

   CHAP usernames must be between 8 and 64 characters long.  Valid characters: `0` to `9`, `a` to `z`, `A` to `Z`, `@`, `_`, `-`, `.`, `:`.

   Note

   CHAP passwords must be between 12 and 16 characters long.  Valid characters: `0` to `9`, `a` to `z`, `A` to `Z`, `@`, `_`, `-`, `/`.

   Note

   For mutual CHAP, initiator and target usernames and passwords must not be the same.

7. Add the disk to the client:

   ```
   > /iscsi-target...at:rh7-client> disk add rbd/disk_1
   ```

The next step is to configure the iSCSI initiators.       

# Manual ceph-iscsi Installation

**Requirements**

To complete the installation of ceph-iscsi, there are 4 steps:

1. Install common packages from your Linux distribution’s software repository
2. Install Git to fetch the remaining packages directly from their Git repositories
3. Ensure a compatible kernel is used
4. Install all the components of ceph-iscsi and start associated daemons:
   - tcmu-runner
   - rtslib-fb
   - configshell-fb
   - targetcli-fb
   - ceph-iscsi

## 1. Install Common Packages

The following packages will be used by ceph-iscsi and target tools. They must be installed from your Linux distribution’s software repository on each machine that will be a iSCSI gateway:

- libnl3
- libkmod
- librbd1
- pyparsing
- python kmod
- python pyudev
- python gobject
- python urwid
- python pyparsing
- python rados
- python rbd
- python netifaces
- python crypto
- python requests
- python flask
- pyOpenSSL

## 2. Install Git

In order to install all the packages needed to run iSCSI with Ceph,  you need to download them directly from their repository by using Git. On CentOS/RHEL execute:

```
sudo yum install git
```

On Debian/Ubuntu execute:

```
sudo apt install git
```

To know more about Git and how it works, please, visit https://git-scm.com

## 3. Ensure a compatible kernel is used

Ensure you use a supported kernel that contains the required Ceph iSCSI patches:

- all Linux distribution with a kernel v4.16 or newer, or
- Red Hat Enterprise Linux or CentOS 7.5 or later (in these distributions ceph-iscsi support is backported)

If you are already using a compatible kernel, you can go to next step. However, if you are NOT using a compatible kernel then check your distro’s documentation for specific instructions on how to build this kernel. The only Ceph iSCSI specific requirements are that the following build options must be enabled:

> ```
> CONFIG_TARGET_CORE=m
> CONFIG_TCM_USER2=m
> CONFIG_ISCSI_TARGET=m
> ```

## 4. Install ceph-iscsi

Finally, the remaining tools can be fetched directly from their Git repositories and their associated services started

### tcmu-runner

> Installation:
>
> ```
> git clone https://github.com/open-iscsi/tcmu-runner
> cd tcmu-runner
> ```
>
> Run the following command to install all the needed dependencies:
>
> ```
> ./extra/install_dep.sh
> ```
>
> Now you can build the tcmu-runner. To do so, use the following build command:
>
> ```
> cmake -Dwith-glfs=false -Dwith-qcow=false -DSUPPORT_SYSTEMD=ON -DCMAKE_INSTALL_PREFIX=/usr
> make install
> ```
>
> Enable and start the daemon:
>
> ```
> systemctl daemon-reload
> systemctl enable tcmu-runner
> systemctl start tcmu-runner
> ```

### rtslib-fb

> Installation:
>
> ```
> git clone https://github.com/open-iscsi/rtslib-fb.git
> cd rtslib-fb
> python setup.py install
> ```

### configshell-fb

> Installation:
>
> ```
> git clone https://github.com/open-iscsi/configshell-fb.git
> cd configshell-fb
> python setup.py install
> ```

### targetcli-fb

> Installation:
>
> ```
> git clone https://github.com/open-iscsi/targetcli-fb.git
> cd targetcli-fb
> python setup.py install
> mkdir /etc/target
> mkdir /var/target
> ```
>
> Warning
>
> The ceph-iscsi tools assume they are managing all targets on the system. If targets have been setup and are being managed by targetcli the target service must be disabled.

### ceph-iscsi

> Installation:
>
> ```
> git clone https://github.com/ceph/ceph-iscsi.git
> cd ceph-iscsi
> python setup.py install --install-scripts=/usr/bin
> cp usr/lib/systemd/system/rbd-target-gw.service /lib/systemd/system
> cp usr/lib/systemd/system/rbd-target-api.service /lib/systemd/system
> ```
>
> Enable and start the daemon:
>
> ```
> systemctl daemon-reload
> systemctl enable rbd-target-gw
> systemctl start rbd-target-gw
> systemctl enable rbd-target-api
> systemctl start rbd-target-api
> ```

Installation is complete. Proceed to the setup section in the [main ceph-iscsi CLI page](https://docs.ceph.com/en/latest/rbd/iscsi-target-cli).

# Block Device Quick Start

Ensure your [Ceph Storage Cluster](https://docs.ceph.com/en/latest/glossary/#term-Ceph-Storage-Cluster) is in an `active + clean` state before working with the [Ceph Block Device](https://docs.ceph.com/en/latest/glossary/#term-Ceph-Block-Device).

Note

The Ceph Block Device is also known as [RBD](https://docs.ceph.com/en/latest/glossary/#term-RBD) or [RADOS](https://docs.ceph.com/en/latest/glossary/#term-RADOS) Block Device.

You may use a virtual machine for your `ceph-client` node, but do not execute the following procedures on the same physical node as your Ceph Storage Cluster nodes (unless you use a VM). See [FAQ](http://wiki.ceph.com/How_Can_I_Give_Ceph_a_Try) for details.

## Create a Block Device Pool

1. On the admin node, use the `ceph` tool to [create a pool](https://docs.ceph.com/en/latest/rados/operations/pools/#create-a-pool) (we recommend the name ‘rbd’).

2. On the admin node, use the `rbd` tool to initialize the pool for use by RBD:

   ```
   rbd pool init <pool-name>
   ```

## Configure a Block Device

1. On the `ceph-client` node, create a block device image.

   ```
   rbd create foo --size 4096 --image-feature layering [-m {mon-IP}] [-k /path/to/ceph.client.admin.keyring] [-p {pool-name}]
   ```

2. On the `ceph-client` node, map the image to a block device.

   ```
   sudo rbd map foo --name client.admin [-m {mon-IP}] [-k /path/to/ceph.client.admin.keyring] [-p {pool-name}]
   ```

3. Use the block device by creating a file system on the `ceph-client` node.

   ```
   sudo mkfs.ext4 -m0 /dev/rbd/{pool-name}/foo
   
   This may take a few moments.
   ```

4. Mount the file system on the `ceph-client` node.

   ```
   sudo mkdir /mnt/ceph-block-device
   sudo mount /dev/rbd/{pool-name}/foo /mnt/ceph-block-device
   cd /mnt/ceph-block-device
   ```

5. Optionally configure the block device to be automatically mapped and mounted at boot (and unmounted/unmapped at shutdown) - see the [rbdmap manpage](https://docs.ceph.com/en/latest/man/8/rbdmap).

See [block devices](https://docs.ceph.com/en/latest/rbd) for additional details.

# Configuring the iSCSI Initiators

- [iSCSI Initiator for Linux](https://docs.ceph.com/en/latest/rbd/iscsi-initiator-linux)

- [iSCSI Initiator for Microsoft Windows](https://docs.ceph.com/en/latest/rbd/iscsi-initiator-win)

- [iSCSI Initiator for VMware ESX](https://docs.ceph.com/en/latest/rbd/iscsi-initiator-esx)

  > Warning
  >
  > Applications that use SCSI persistent group reservations (PGR) and SCSI 2 based reservations are not supported when exporting a RBD image through more than one iSCSI gateway.

# iSCSI Initiator for Linux

**Prerequisite:**

- Package `iscsi-initiator-utils`
- Package `device-mapper-multipath`

**Installing:**

Install the iSCSI initiator and multipath tools:

> ```
> # yum install iscsi-initiator-utils
> # yum install device-mapper-multipath
> ```

**Configuring:**

1. Create the default `/etc/multipath.conf` file and enable the `multipathd` service:

   ```
   # mpathconf --enable --with_multipathd y
   ```

2. Add the following to `/etc/multipath.conf` file:

   ```
   devices {
           device {
                   vendor                 "LIO-ORG"
                   product                "TCMU device"
                   hardware_handler       "1 alua"
                   path_grouping_policy   "failover"
                   path_selector          "queue-length 0"
                   failback               60
                   path_checker           tur
                   prio                   alua
                   prio_args              exclusive_pref_bit
                   fast_io_fail_tmo       25
                   no_path_retry          queue
           }
   }
   ```

3. Restart the `multipathd` service:

   ```
   # systemctl reload multipathd
   ```

**iSCSI Discovery and Setup:**

1. Enable CHAP authentication and provide the initiator CHAP username and password by uncommenting and setting the following options in `/etc/iscsi/iscsid.conf` file:

   ```
   node.session.auth.authmethod = CHAP
   node.session.auth.username = myusername
   node.session.auth.password = mypassword
   ```

   If mutual (bidirectional) authentication is used, also provide the target CHAP username and password:

   ```
   node.session.auth.username_in = mytgtusername
   node.session.auth.password_in = mytgtpassword
   ```

2. Discover the target portals:

   ```
   # iscsiadm -m discovery -t st -p 192.168.56.101
   192.168.56.101:3260,1 iqn.2003-01.org.linux-iscsi.rheln1
   192.168.56.102:3260,2 iqn.2003-01.org.linux-iscsi.rheln1
   ```

3. Login to target:

   ```
   # iscsiadm -m node -T iqn.2003-01.org.linux-iscsi.rheln1 -l
   ```

**Multipath IO Setup:**

The multipath daemon (`multipathd`), will set up devices automatically based on the `multipath.conf` settings. Running the `multipath` command show devices setup in a failover configuration with a priority group for each path.

```
# multipath -ll
mpathbt (360014059ca317516a69465c883a29603) dm-1 LIO-ORG ,IBLOCK
size=1.0G features='0' hwhandler='1 alua' wp=rw
|-+- policy='queue-length 0' prio=50 status=active
| `- 28:0:0:1 sde  8:64  active ready running
`-+- policy='queue-length 0' prio=10 status=enabled
  `- 29:0:0:1 sdc  8:32  active ready running
```

You should now be able to use the RBD image like you would a normal multipath’d iSCSI disk.

1. Logout from target:

   ```
   # iscsiadm -m node -T iqn.2003-01.org.linux-iscsi.rheln1 -u
   ```

# iSCSI Initiator for Microsoft Windows

**Prerequisite:**

- Microsoft Windows Server 2016 or later

**iSCSI Initiator, Discovery and Setup:**

1. Install the iSCSI initiator driver and MPIO tools.
2. Launch the MPIO program, click on the “Discover Multi-Paths” tab, check the “Add support for iSCSI devices” box, and click “Add”. This will require a reboot.
3. On the iSCSI Initiator Properties window, on the “Discovery” tab, add a target portal. Enter the IP address or DNS name and Port of the Ceph iSCSI gateway.
4. On the “Targets” tab, select the target and click on “Connect”.
5. On the “Connect To Target” window, select the “Enable multi-path” option, and click the “Advanced” button.
6. Under the “Connet using” section, select a “Target portal IP” . Select the “Enable CHAP login on” and enter the “Name” and “Target secret” values from the Ceph iSCSI Ansible client credentials section, and click OK.
7. Repeat steps 5 and 6 for each target portal defined when setting up the iSCSI gateway.

**Multipath IO Setup:**

Configuring the MPIO load balancing policy, setting the timeout and retry options are using PowerShell with the `mpclaim` command. The rest is done in the iSCSI Initiator tool.

Note

It is recommended to increase the `PDORemovePeriod` option to 120 seconds from PowerShell. This value might need to be adjusted based on the application. When all paths are down, and 120 seconds expires, the operating system will start failing IO requests.

```
Set-MPIOSetting -NewPDORemovePeriod 120
mpclaim.exe -l -m 1
mpclaim -s -m
MSDSM-wide Load Balance Policy: Fail Over Only
```

1. Using the iSCSI Initiator tool, from the “Targets” tab, click on the “Devices…” button.
2. From the Devices window, select a disk and click the “MPIO…” button.
3. On the “Device Details” window the paths to each target portal is displayed. If using the `ceph-ansible` setup method, the iSCSI gateway will use ALUA to tell the iSCSI initiator which path and iSCSI gateway should be used as the primary path. The Load Balancing Policy “Fail Over Only” must be selected

```
mpclaim -s -d $MPIO_DISK_ID
```

Note

For the `ceph-ansible` setup method, there will be one Active/Optimized path which is the path to the iSCSI gateway node that owns the LUN, and there will be an Active/Unoptimized path for each other iSCSI gateway node.

**Tuning:**

Consider using the following registry settings:

- Windows Disk Timeout

  ```
  HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Disk
  ```

  ```
  TimeOutValue = 65
  ```

- Microsoft iSCSI Initiator Driver

  ```
  HKEY_LOCAL_MACHINE\\SYSTEM\CurrentControlSet\Control\Class\{4D36E97B-E325-11CE-BFC1-08002BE10318}\<Instance_Number>\Parameters
  ```

  ```
  LinkDownTime = 25
  SRBTimeoutDelta = 15
  ```

# iSCSI Initiator for VMware ESX

**Prerequisite:**

- VMware ESX 6.5 or later using Virtual Machine compatibility 6.5 with VMFS 6.

**iSCSI Discovery and Multipath Device Setup:**

The following instructions will use the default vSphere web client and esxcli.

1. Enable Software iSCSI

   

   Click on “Storage” from “Navigator”, and select the “Adapters” tab. From there right click “Configure iSCSI”.

2. Set Initiator Name

   

   If the initiator name in the “Name & alias” section is not the same name used when creating the client during gwcli setup or the initiator name used in the ansible client_connections client variable, then ssh to the ESX host and run the following esxcli commands to change the name.

   Get the adapter name for Software iSCSI:

   ```
   > esxcli iscsi adapter list
   > Adapter  Driver     State   UID            Description
   > -------  ---------  ------  -------------  ----------------------
   > vmhba64  iscsi_vmk  online  iscsi.vmhba64  iSCSI Software Adapter
   ```

   In this example the software iSCSI adapter is vmhba64 and the initiator name is iqn.1994-05.com.redhat:rh7-client:

   > ```
   > > esxcli iscsi adapter set -A vmhba64 -n iqn.1994-05.com.redhat:rh7-client
   > ```

3. Setup CHAP

   

   Expand the CHAP authentication section, select “Do not use CHAP unless required by target” and enter the CHAP credentials used in the gwcli auth command or ansible client_connections credentials variable.

   The Mutual CHAP authentication section should have “Do not use CHAP” selected.

   Warning: There is a bug in the web client where the requested CHAP settings are not always used initially. On the iSCSI gateway kernel logs you will see the error:

   > ```
   > > kernel: CHAP user or password not set for Initiator ACL
   > > kernel: Security negotiation failed.
   > > kernel: iSCSI Login negotiation failed.
   > ```

   To workaround this set the CHAP settings with the esxcli command. Here authname is the username and secret is the password used in previous examples:

   ```
   > esxcli iscsi adapter auth chap set --direction=uni --authname=myiscsiusername --secret=myiscsipassword --level=discouraged -A vmhba64
   ```

4. Configure iSCSI Settings

   

   Expand Advanced settings and set the “RecoveryTimeout” to 25.

5. Set the discovery address

   

   In the Dynamic targets section, click “Add dynamic target” and under Addresses add one of the gateway IP addresses added during the iSCSI gateway setup stage in the gwcli section or an IP set in the ansible gateway_ip_list variable. Only one address needs to be added as the gateways have been setup so all the iSCSI portals are returned during discovery.

   Finally, click the “Save configuration” button. In the Devices tab, you should see the RBD image.

   The LUN should be automatically configured and using the ALUA SATP and MRU PSP. Other SATPs and PSPs must not be used. This can be verified with the esxcli command:

   ```
   > esxcli storage nmp path list -d eui.your_devices_id
   ```

**Prerequisite:**

- VMware ESX 6.5 or later using Virtual Machine compatibility 6.5 with VMFS 6.

**iSCSI Discovery and Multipath Device Setup:**

The following instructions will use the default vSphere web client and esxcli.

1. Enable Software iSCSI

   

   Click on “Storage” from “Navigator”, and select the “Adapters” tab. From there right click “Configure iSCSI”.

2. Set Initiator Name

   

   If the initiator name in the “Name & alias” section is not the same name used when creating the client during gwcli setup or the initiator name used in the ansible client_connections client variable, then ssh to the ESX host and run the following esxcli commands to change the name.

   Get the adapter name for Software iSCSI:

   ```
   > esxcli iscsi adapter list
   > Adapter  Driver     State   UID            Description
   > -------  ---------  ------  -------------  ----------------------
   > vmhba64  iscsi_vmk  online  iscsi.vmhba64  iSCSI Software Adapter
   ```

   In this example the software iSCSI adapter is vmhba64 and the initiator name is iqn.1994-05.com.redhat:rh7-client:

   > ```
   > > esxcli iscsi adapter set -A vmhba64 -n iqn.1994-05.com.redhat:rh7-client
   > ```

3. Setup CHAP

   

   Expand the CHAP authentication section, select “Do not use CHAP unless required by target” and enter the CHAP credentials used in the gwcli auth command or ansible client_connections credentials variable.

   The Mutual CHAP authentication section should have “Do not use CHAP” selected.

   Warning: There is a bug in the web client where the requested CHAP settings are not always used initially. On the iSCSI gateway kernel logs you will see the error:

   > ```
   > > kernel: CHAP user or password not set for Initiator ACL
   > > kernel: Security negotiation failed.
   > > kernel: iSCSI Login negotiation failed.
   > ```

   To workaround this set the CHAP settings with the esxcli command. Here authname is the username and secret is the password used in previous examples:

   ```
   > esxcli iscsi adapter auth chap set --direction=uni --authname=myiscsiusername --secret=myiscsipassword --level=discouraged -A vmhba64
   ```

4. Configure iSCSI Settings

   

   Expand Advanced settings and set the “RecoveryTimeout” to 25.

5. Set the discovery address

   

   In the Dynamic targets section, click “Add dynamic target” and under Addresses add one of the gateway IP addresses added during the iSCSI gateway setup stage in the gwcli section or an IP set in the ansible gateway_ip_list variable. Only one address needs to be added as the gateways have been setup so all the iSCSI portals are returned during discovery.

   Finally, click the “Save configuration” button. In the Devices tab, you should see the RBD image.

   The LUN should be automatically configured and using the ALUA SATP and MRU PSP. Other SATPs and PSPs must not be used. This can be verified with the esxcli command:

   ```
   > esxcli storage nmp path list -d eui.your_devices_id
   ```

# Monitoring Ceph iSCSI gateways

Ceph provides a tool for iSCSI gateway environments to monitor performance of exported RADOS Block Device (RBD) images.

The `gwtop` tool is a `top`-like tool that displays aggregated performance metrics of RBD images that are exported to clients over iSCSI. The metrics are sourced from a Performance Metrics Domain Agent (PMDA). Information from the Linux-IO target (LIO) PMDA is used to list each exported RBD image, the connected client, and its associated I/O metrics.

**Requirements:**

- A running Ceph iSCSI gateway

**Installing:**

1. As `root`, install the `ceph-iscsi-tools` package on each iSCSI gateway node:

   ```
   # yum install ceph-iscsi-tools
   ```

2. As `root`, install the performance co-pilot package on each iSCSI gateway node:

   ```
   # yum install pcp
   ```

3. As `root`, install the LIO PMDA package on each iSCSI gateway node:

   ```
   # yum install pcp-pmda-lio
   ```

4. As `root`, enable and start the performance co-pilot service on each iSCSI gateway node:

   ```
   # systemctl enable pmcd
   # systemctl start pmcd
   ```

5. As `root`, register the `pcp-pmda-lio` agent:

   ```
   cd /var/lib/pcp/pmdas/lio
   ./Install
   ```

By default, `gwtop` assumes the iSCSI gateway configuration object is stored in a RADOS object called `gateway.conf` in the `rbd` pool. This configuration defines the iSCSI gateways to contact for gathering the performance statistics. This can be overridden by using either the `-g` or `-c` flags. See `gwtop --help` for more details.

The LIO configuration determines which type of performance statistics to extract from performance co-pilot. When `gwtop` starts it looks at the LIO configuration, and if it find user-space disks, then `gwtop` selects the LIO collector automatically.

**Example ``gwtop`` Outputs**

```
gwtop  2/2 Gateways   CPU% MIN:  4 MAX:  5    Network Total In:    2M  Out:    3M   10:20:00
Capacity:   8G    Disks:   8   IOPS:  503   Clients:  1   Ceph: HEALTH_OK          OSDs:   3
Pool.Image       Src    Size     iops     rMB/s     wMB/s   Client
iscsi.t1703             500M        0      0.00      0.00
iscsi.testme1           500M        0      0.00      0.00
iscsi.testme2           500M        0      0.00      0.00
iscsi.testme3           500M        0      0.00      0.00
iscsi.testme5           500M        0      0.00      0.00
rbd.myhost_1      T       4G      504      1.95      0.00   rh460p(CON)
rbd.test_2                1G        0      0.00      0.00
rbd.testme              500M        0      0.00      0.00
```

In the *Client* column, `(CON)` means the iSCSI initiator (client) is currently logged into the iSCSI gateway. If `-multi-` is displayed, then multiple clients are mapped to the single RBD image.

# RBD on Windows

The `rbd` command can be used to create, remove, import, export, map or unmap images exactly like it would on Linux. Make sure to check the [RBD basic commands](https://docs.ceph.com/en/latest/rbd/rados-rbd-cmds) guide.

`librbd.dll` is also available for applications that can natively use Ceph.

Please check the [installation guide](https://docs.ceph.com/en/latest/install/windows-install) to get started.

## Windows service

On Windows, `rbd-wnbd` daemons are managed by a centralized service. This allows decoupling the daemons from the Windows session from which they originate. At the same time, the service is responsible of recreating persistent mappings, usually when the host boots.

Note that only one such service may run per host.

By default, all image mappings are persistent. Non-persistent mappings can be requested using the `-onon-persistent` `rbd` flag.

Persistent mappings are recreated when the service starts, unless explicitly unmapped. The service disconnects the mappings when being stopped. This also allows adjusting the Windows service start order so that RBD images can be mapped before starting services that may depend on it, such as VMMS.

In order to be able to reconnect the images, `rbd-wnbd` stores mapping information in the Windows registry at the following location: `SYSTEM\CurrentControlSet\Services\rbd-wnbd`.

The following command can be used to configure the service. Please update the `rbd-wnbd.exe` path accordingly:

```
New-Service -Name "ceph-rbd" `
            -Description "Ceph RBD Mapping Service" `
            -BinaryPathName "c:\ceph\rbd-wnbd.exe service" `
            -StartupType Automatic
```

Note that the Ceph MSI installer takes care of creating the `ceph-rbd` Windows service.

## Usage

### Integration

RBD images can be exposed to the OS and host Windows partitions or they can be attached to Hyper-V VMs in the same way as iSCSI disks.

Starting with Openstack Wallaby, the Nova Hyper-V driver can attach RBD Cinder volumes to Hyper-V VMs.

### Mapping images

The workflow and CLI is similar to the Linux counterpart, with a few notable differences:

- device paths cannot be requested. The disk number and path will be picked by Windows. If a device path is provided by the used when mapping an image, it will be used as an identifier, which can also be used when unmapping the image.
- the `show` command was added, which describes a specific mapping. This can be used for retrieving the disk path.
- the `service` command was added, allowing `rbd-wnbd` to run as a Windows service. All mappings are by default persistent, being recreated when the service stops, unless explicitly unmapped. The service disconnects the mappings when being stopped.
- the `list` command also includes a `status` column.

The purpose of the `service` mode is to ensure that mappings survive reboots and that the Windows service start order can be adjusted so that RBD images can be mapped before starting services that may depend on it, such as VMMS.

The mapped images can either be consumed by the host directly or exposed to Hyper-V VMs.

### Hyper-V VM disks

The following sample imports an RBD image and boots a Hyper-V VM using it:

```
# Feel free to use any other image. This one is convenient to use for
# testing purposes because it's very small (~15MB) and the login prompt
# prints the pre-configured password.
wget http://download.cirros-cloud.net/0.5.1/cirros-0.5.1-x86_64-disk.img `
     -OutFile cirros-0.5.1-x86_64-disk.img

# We'll need to make sure that the imported images are raw (so no qcow2 or vhdx).
# You may get qemu-img from https://cloudbase.it/qemu-img-windows/
# You can add the extracted location to $env:Path or update the path accordingly.
qemu-img convert -O raw cirros-0.5.1-x86_64-disk.img cirros-0.5.1-x86_64-disk.raw

rbd import cirros-0.5.1-x86_64-disk.raw
# Let's give it a hefty 100MB size.
rbd resize cirros-0.5.1-x86_64-disk.raw --size=100MB

rbd device map cirros-0.5.1-x86_64-disk.raw

# Let's have a look at the mappings.
rbd device list
Get-Disk

$mappingJson = rbd-wnbd show cirros-0.5.1-x86_64-disk.raw --format=json
$mappingJson = $mappingJson | ConvertFrom-Json

$diskNumber = $mappingJson.disk_number

New-VM -VMName BootFromRBD -MemoryStartupBytes 512MB
# The disk must be turned offline before it can be passed to Hyper-V VMs
Set-Disk -Number $diskNumber -IsOffline $true
Add-VMHardDiskDrive -VMName BootFromRBD -DiskNumber $diskNumber
Start-VM -VMName BootFromRBD
```

### Windows partitions

The following sample creates an empty RBD image, attaches it to the host and initializes a partition:

```
rbd create blank_image --size=1G
rbd device map blank_image -onon-persistent

$mappingJson = rbd-wnbd show blank_image --format=json
$mappingJson = $mappingJson | ConvertFrom-Json

$diskNumber = $mappingJson.disk_number

# The disk must be online before creating or accessing partitions.
Set-Disk -Number $diskNumber -IsOffline $false

# Initialize the disk, partition it and create a filesystem.
Get-Disk -Number $diskNumber | `
    Initialize-Disk -PassThru | `
    New-Partition -AssignDriveLetter -UseMaximumSize | `
    Format-Volume -Force -Confirm:$false
```

### Limitations

#### CSV support

At the moment, the Microsoft Failover Cluster can’t use WNBD disks as Cluster Shared Volumes (CSVs) underlying storage. The main reason is that `WNBD` and `rbd-wnbd` don’t support the *SCSI Persistent Reservations* feature yet.

#### Hyper-V disk addressing

Warning

Hyper-V identifies passthrough VM disks by number instead of SCSI ID, although the disk number can change across host reboots. This means that the VMs can end up using incorrect disks after rebooting the host, which is an important security concern. This issue also affects iSCSI and Fibre Channel disks.

There are a few possible ways of avoiding this Hyper-V limitation:

- use an NTFS/ReFS partition to store VHDX image files instead of directly attaching the RBD image. This may slightly impact the IO performance.
- use the Hyper-V `AutomaticStartAction` setting to prevent the VMs from booting with the incorrect disks and have a script that updates VM disks attachments before powering them back on. The `ElementName` field of the [Msvm_StorageAllocationSettingData](https://docs.microsoft.com/en-us/windows/win32/hyperv_v2/msvm-storageallocationsettingdata) [WMI](https://docs.microsoft.com/en-us/windows/win32/wmisdk/wmi-start-page) class may be used to label VM disk attachments.
- use the Openstack Hyper-V driver, which automatically refreshes the VM disk attachments before powering them back on.

## Troubleshooting

Please consult the [Windows troubleshooting](https://docs.ceph.com/en/latest/install/windows-troubleshooting) page.

## Ceph Block Device Manpages

- rbd
- rbd-fuse
- rbd-nbd
- rbd-ggate
- rbd-map
- ceph-rbdnamer
- rbd-replay-prep
- rbd-replay
- rbd-replay-many

###  rbd -- manage rados block device (RBD) images

**rbd** is a utility for manipulating rados block device (RBD) images, used by the Linux rbd driver and the rbd storage driver for QEMU/KVM. RBD images are simple block devices that are striped over objects and stored in a RADOS object store. The size of the objects the image is striped over must be a power of two.

```bash
rbd [ -c ceph.conf ] [ -m monaddr ] [--cluster cluster-name] [ -p | --pool pool ] [ command … ]
```

**Options:**

- -c ceph.conf, --conf ceph.conf

  Use ceph.conf configuration file instead of the default /etc/ceph/ceph.conf to determine monitor addresses during startup.

- -m monaddress[:port]

  Connect to specified monitor (instead of looking through ceph.conf).

- --cluster cluster-name

  Use different cluster name as compared to default cluster name *ceph*.

- -p pool-name, --pool pool-name

  Interact with the given pool. Required by most commands.

- --namespace namespace-name

  Use a pre-defined image namespace within a pool

- --no-progress

  Do not output progress information (goes to standard error by default for some commands).

**Parameters:**

- --image-format format-id

  Specifies which object layout to use. The default is 2. format 1 - (deprecated) Use the original format for a new rbd image. This format is understood by all versions of librbd and the kernel rbd module, but does not support newer features like cloning. format 2 - Use the second rbd format, which is supported by librbd since the Bobtail release and the kernel rbd module since kernel 3.10 (except for “fancy” striping, which is supported since kernel 4.17). This adds support for cloning and is more easily extensible to allow more features in the future.

- -s size-in-M/G/T, --size size-in-M/G/T

  Specifies the size of the new rbd image or the new size of the existing rbd image in M/G/T.  If no suffix is given, unit M is assumed.

- --object-size size-in-B/K/M

  Specifies the object size in B/K/M.  Object size will be rounded up the nearest power of two; if no suffix is given, unit B is assumed.  The default object size is 4M, smallest is 4K and maximum is 32M. The default value can be changed with the configuration option `rbd_default_order`, which takes a power of two (default object size is `2 ^ rbd_default_order`).

- --stripe-unit size-in-B/K/M

  Specifies the stripe unit size in B/K/M.  If no suffix is given, unit B is assumed.  See striping section (below) for more details.

- --stripe-count num

  Specifies the number of objects to stripe over before looping back to the first object.  See striping section (below) for more details.

- --snap snap

  Specifies the snapshot name for the specific operation.

- --id username

  Specifies the username (without the `client.` prefix) to use with the map command.

- --keyring filename

  Specifies a keyring file containing a secret for the specified user to use with the map command.  If not specified, the default keyring locations will be searched.

- --keyfile filename

  Specifies a file containing the secret key of `--id user` to use with the map command. This option is overridden by `--keyring` if the latter is also specified.

- --shared lock-tag

  Option for lock add that allows multiple clients to lock the same image if they use the same tag. The tag is an arbitrary string. This is useful for situations where an image must be open from more than one client at once, like during live migration of a virtual machine, or for use underneath a clustered file system.

- --format format

  Specifies output formatting (default: plain, json, xml)

- --pretty-format

  Make json or xml formatted output more human-readable.

- -o krbd-options, --options krbd-options

  Specifies which options to use when mapping or unmapping an image via the rbd kernel driver.  krbd-options is a comma-separated list of options (similar to mount(8) mount options).  See kernel rbd (krbd) options section below for more details.

- --read-only

  Map the image read-only.  Equivalent to -o ro.

- --image-feature feature-name

  Specifies which RBD format 2 feature should be enabled when creating an image. Multiple features can be enabled by repeating this option multiple times. The following features are supported: layering: layering support striping: striping v2 support exclusive-lock: exclusive locking support object-map: object map support (requires exclusive-lock) fast-diff: fast diff calculations (requires object-map) deep-flatten: snapshot flatten support journaling: journaled IO support (requires exclusive-lock) data-pool: erasure coded pool support

- --image-shared[](https://docs.ceph.com/en/latest/man/8/rbd/#cmdoption-rbd-image-shared)

  Specifies that the image will be used concurrently by multiple clients. This will disable features that are dependent upon exclusive ownership of the image.

- --whole-object[](https://docs.ceph.com/en/latest/man/8/rbd/#cmdoption-rbd-whole-object)

  Specifies that the diff should be limited to the extents of a full object instead of showing intra-object deltas. When the object map feature is enabled on an image, limiting the diff to the object extents will dramatically improve performance since the differences can be computed by examining the in-memory object map instead of querying RADOS for each object within the image.

- --limit[](https://docs.ceph.com/en/latest/man/8/rbd/#cmdoption-rbd-limit)

  Specifies the limit for the number of snapshots permitted.

**Commands**

- **bench** --io-type <read | write | readwrite | rw> [--io-size *size-in-B/K/M/G/T*] [--io-threads *num-ios-in-flight*] [--io-total *size-in-B/K/M/G/T*] [--io-pattern seq | rand] [--rw-mix-read *read proportion in readwrite*] *image-spec*

  Generate a series of IOs to the image and measure the IO throughput and latency.  If no suffix is given, unit B is assumed for both --io-size and --io-total.  Defaults are: --io-size 4096, --io-threads 16, --io-total 1G, --io-pattern seq, --rw-mix-read 50.

- **children** *snap-spec*

  List the clones of the image at the given snapshot. This checks every pool, and outputs the resulting poolname/imagename. This requires image format 2.

- **clone** [--object-size *size-in-B/K/M*] [--stripe-unit *size-in-B/K/M* --stripe-count *num*] [--image-feature *feature-name*] [--image-shared] *parent-snap-spec* *child-image-spec*

  Will create a clone (copy-on-write child) of the parent snapshot. Object size will be identical to that of the parent image unless specified. Size will be the same as the parent snapshot. The --stripe-unit and --stripe-count arguments are optional, but must be used together. The parent snapshot must be protected (see rbd snap protect). This requires image format 2.

- **config global get** *config-entity* *key*

  Get a global-level configuration override.

- **config global list** [--format plain | json | xml] [--pretty-format] *config-entity*

  List global-level configuration overrides.

- **config global set** *config-entity* *key* *value*

  Set a global-level configuration override.

- **config global remove** *config-entity* *key*

  Remove a global-level configuration override.

- **config image get** *image-spec* *key*

  Get an image-level configuration override.

- **config image list** [--format plain | json | xml] [--pretty-format] *image-spec*

  List image-level configuration overrides.

- **config image set** *image-spec* *key* *value*

  Set an image-level configuration override.

- **config image remove** *image-spec* *key*

  Remove an image-level configuration override.

- **config pool get** *pool-name* *key*

  Get a pool-level configuration override.

- **config pool list** [--format plain | json | xml] [--pretty-format] *pool-name*

  List pool-level configuration overrides.

- **config pool set** *pool-name* *key* *value*

  Set a pool-level configuration override.

- **config pool remove** *pool-name* *key*

  Remove a pool-level configuration override.

- **cp** (*src-image-spec* | *src-snap-spec*) *dest-image-spec*

  Copy the content of a src-image into the newly created dest-image. dest-image will have the same size, object size, and image format as src-image. Note: snapshots are not copied, use deep cp command to include snapshots.

- **create** (-s | --size *size-in-M/G/T*) [--image-format *format-id*] [--object-size *size-in-B/K/M*] [--stripe-unit *size-in-B/K/M* --stripe-count *num*] [--thick-provision] [--no-progress] [--image-feature *feature-name*]… [--image-shared] *image-spec*

  Will create a new rbd image. You must also specify the size via --size.  The --stripe-unit and --stripe-count arguments are optional, but must be used together. If the --thick-provision is enabled, it will fully allocate storage for the image at creation time. It will take a long time to do. Note: thick provisioning requires zeroing the contents of the entire image.

- **deep cp** (*src-image-spec* | *src-snap-spec*) *dest-image-spec*

  Deep copy the content of a src-image into the newly created dest-image. Dest-image will have the same size, object size, image format, and snapshots as src-image.

- **device list** [-t | --device-type *device-type*] [--format plain | json | xml] --pretty-format

  Show the rbd images that are mapped via the rbd kernel module (default) or other supported device.

- **device map** [-t | --device-type *device-type*] [--cookie *device-cookie*] [--show-cookie] [--read-only] [--exclusive] [-o | --options *device-options*] *image-spec* | *snap-spec*

  Map the specified image to a block device via the rbd kernel module (default) or other supported device (*nbd* on Linux or *ggate* on FreeBSD). The --options argument is a comma separated list of device type specific options (opt1,opt2=val,…).

- **device unmap** [-t | --device-type *device-type*] [-o | --options *device-options*] *image-spec* | *snap-spec* | *device-path*

  Unmap the block device that was mapped via the rbd kernel module (default) or other supported device. The --options argument is a comma separated list of device type specific options (opt1,opt2=val,…).

- **device attach** [-t | --device-type *device-type*] --device *device-path* [--cookie *device-cookie*] [--show-cookie] [--read-only] [--exclusive] [--force] [-o | --options *device-options*] *image-spec* | *snap-spec*

  Attach the specified image to the specified block device (currently only nbd on Linux). This operation is unsafe and should not be normally used. In particular, specifying the wrong image or the wrong block device may lead to data corruption as no validation is performed by nbd kernel driver. The --options argument is a comma separated list of device type specific options (opt1,opt2=val,…).

- **device detach** [-t | --device-type *device-type*] [-o | --options *device-options*] *image-spec* | *snap-spec* | *device-path*

  Detach the block device that was mapped or attached (currently only nbd on Linux). This operation is unsafe and should not be normally used. The --options argument is a comma separated list of device type specific options (opt1,opt2=val,…).

- **diff** [--from-snap *snap-name*] [--whole-object] *image-spec* | *snap-spec*

  Dump a list of byte extents in the image that have changed since the specified start snapshot, or since the image was created.  Each output line includes the starting offset (in bytes), the length of the region (in bytes), and either ‘zero’ or ‘data’ to indicate whether the region is known to be zeros or may contain other data.

- **du** [-p | --pool *pool-name*] [*image-spec* | *snap-spec*] [--merge-snapshots]

  Will calculate the provisioned and actual disk usage of all images and associated snapshots within the specified pool.  It can also be used against individual images and snapshots. If the RBD fast-diff feature is not enabled on images, this operation will require querying the OSDs for every potential object within the image. The --merge-snapshots will merge snapshots used space into their parent images.

- **encryption format** *image-spec* *format* *passphrase-file* [--cipher-alg *alg*]

  Formats image to an encrypted format. All data previously written to the image will become unreadable. A cloned image cannot be formatted, although encrypted images can be cloned. Supported formats: *luks1*, *luks2*. Supported cipher algorithms: *aes-128*, *aes-256* (default).

- **export** [--export-format *format (1 or 2)*] (*image-spec* | *snap-spec*) [*dest-path*]

  Export image to dest path (use - for stdout). The --export-format accepts ‘1’ or ‘2’ currently. Format 2 allow us to export not only the content of image, but also the snapshots and other properties, such as image_order, features.

- **export-diff** [--from-snap *snap-name*] [--whole-object] (*image-spec* | *snap-spec*) *dest-path*

  Export an incremental diff for an image to dest path (use - for stdout).  If an initial snapshot is specified, only changes since that snapshot are included; otherwise, any regions of the image that contain data are included.  The end snapshot is specified using the standard --snap option or @snap syntax (see below).  The image diff format includes metadata about image size changes, and the start and end snapshots.  It efficiently represents discarded or ‘zero’ regions of the image.

- **feature disable** *image-spec* *feature-name*…

  Disable the specified feature on the specified image. Multiple features can be specified.

- **feature enable** *image-spec* *feature-name*…

  Enable the specified feature on the specified image. Multiple features can be specified.

- **flatten** *image-spec*

  If image is a clone, copy all shared blocks from the parent snapshot and make the child independent of the parent, severing the link between parent snap and child.  The parent snapshot can be unprotected and deleted if it has no further dependent clones. This requires image format 2.

- **group create** *group-spec*

  Create a group.

- **group image add** *group-spec* *image-spec*

  Add an image to a group.

- **group image list** *group-spec*

  List images in a group.

- **group image remove** *group-spec* *image-spec*

  Remove an image from a group.

- **group ls** [-p | --pool *pool-name*]

  List rbd groups.

- **group rename** *src-group-spec* *dest-group-spec*

  Rename a group.  Note: rename across pools is not supported.

- **group rm** *group-spec*

  Delete a group.

- **group snap create** *group-snap-spec*

  Make a snapshot of a group.

- **group snap list** *group-spec*

  List snapshots of a group.

- **group snap rm** *group-snap-spec*

  Remove a snapshot from a group.

- **group snap rename** *group-snap-spec* *snap-name*

  Rename group’s snapshot.

- **group snap rollback** *group-snap-spec*

  Rollback group to snapshot.

- **image-meta get** *image-spec* *key*

  Get metadata value with the key.

- **image-meta list** *image-spec*

  Show metadata held on the image. The first column is the key and the second column is the value.

- **image-meta remove** *image-spec* *key*

  Remove metadata key with the value.

- **image-meta set** *image-spec* *key* *value*

  Set metadata key with the value. They will displayed in image-meta list.

- **import** [--export-format *format (1 or 2)*] [--image-format *format-id*] [--object-size *size-in-B/K/M*] [--stripe-unit *size-in-B/K/M* --stripe-count *num*] [--image-feature *feature-name*]… [--image-shared] *src-path* [*image-spec*]

  Create a new image and imports its data from path (use - for stdin).  The import operation will try to create sparse rbd images if possible.  For import from stdin, the sparsification unit is the data block size of the destination image (object size). The --stripe-unit and --stripe-count arguments are optional, but must be used together. The --export-format accepts ‘1’ or ‘2’ currently. Format 2 allow us to import not only the content of image, but also the snapshots and other properties, such as image_order, features.

- **import-diff** *src-path* *image-spec*

  Import an incremental diff of an image and applies it to the current image.  If the diff was generated relative to a start snapshot, we verify that snapshot already exists before continuing.  If there was an end snapshot we verify it does not already exist before applying the changes, and create the snapshot when we are done.

- **info** *image-spec* | *snap-spec*

  Will dump information (such as size and object size) about a specific rbd image. If image is a clone, information about its parent is also displayed. If a snapshot is specified, whether it is protected is shown as well.

- **journal client disconnect** *journal-spec*

  Flag image journal client as disconnected.

- **journal export** [--verbose] [--no-error] *src-journal-spec* *path-name*

  Export image journal to path (use - for stdout). It can be make a backup of the image journal especially before attempting dangerous operations. Note that this command may not always work if the journal is badly corrupted.

- **journal import** [--verbose] [--no-error] *path-name* *dest-journal-spec*

  Import image journal from path (use - for stdin).

- **journal info** *journal-spec*

  Show information about image journal.

- **journal inspect** [--verbose] *journal-spec*

  Inspect and report image journal for structural errors.

- **journal reset** *journal-spec*

  Reset image journal.

- **journal status** *journal-spec*

  Show status of image journal.

- **lock add** [--shared *lock-tag*] *image-spec* *lock-id*

  Lock an image. The lock-id is an arbitrary name for the user’s convenience. By default, this is an exclusive lock, meaning it will fail if the image is already locked. The --shared option changes this behavior. Note that locking does not affect any operation other than adding a lock. It does not protect an image from being deleted.

- **lock ls** *image-spec*

  Show locks held on the image. The first column is the locker to use with the lock remove command.

- **lock rm** *image-spec* *lock-id* *locker*

  Release a lock on an image. The lock id and locker are as output by lock ls.

- **ls** [-l | --long] [*pool-name*]

  Will list all rbd images listed in the rbd_directory object.  With -l, also show snapshots, and use longer-format output including size, parent (if clone), format, etc.

- **merge-diff** *first-diff-path* *second-diff-path* *merged-diff-path*

  Merge two continuous incremental diffs of an image into one single diff. The first diff’s end snapshot must be equal with the second diff’s start snapshot. The first diff could be - for stdin, and merged diff could be - for stdout, which enables multiple diff files to be merged using something like ‘rbd merge-diff first second - | rbd merge-diff - third result’. Note this command currently only support the source incremental diff with stripe_count == 1

- **migration abort** *image-spec*

  Cancel image migration. This step may be run after successful or failed migration prepare or migration execute steps and returns the image to its initial (before migration) state. All modifications to the destination image are lost.

- **migration commit** *image-spec*

  Commit image migration. This step is run after a successful migration prepare and migration execute steps and removes the source image data.

- **migration execute** *image-spec*

  Execute image migration. This step is run after a successful migration prepare step and copies image data to the destination.

- **migration prepare** [--order *order*] [--object-size *object-size*] [--image-feature *image-feature*] [--image-shared] [--stripe-unit *stripe-unit*] [--stripe-count *stripe-count*] [--data-pool *data-pool*] [--import-only] [--source-spec *json*] [--source-spec-path *path*] *src-image-spec* [*dest-image-spec*]

  Prepare image migration. This is the first step when migrating an image, i.e. changing the image location, format or other parameters that can’t be changed dynamically. The destination can match the source, and in this case *dest-image-spec* can be omitted. After this step the source image is set as a parent of the destination image, and the image is accessible in copy-on-write mode by its destination spec. An image can also be migrated from a read-only import source by adding the *--import-only* optional and providing a JSON-encoded *--source-spec* or a path to a JSON-encoded source-spec file using the *--source-spec-path* optionals.

- **mirror image demote** *image-spec*

  Demote a primary image to non-primary for RBD mirroring.

- **mirror image disable** [--force] *image-spec*

  Disable RBD mirroring for an image. If the mirroring is configured in `image` mode for the image’s pool, then it can be explicitly disabled mirroring for each image within the pool.

- **mirror image enable** *image-spec* *mode*

  Enable RBD mirroring for an image. If the mirroring is configured in `image` mode for the image’s pool, then it can be explicitly enabled mirroring for each image within the pool. The mirror image mode can either be `journal` (default) or `snapshot`. The `journal` mode requires the RBD journaling feature.

- **mirror image promote** [--force] *image-spec*

  Promote a non-primary image to primary for RBD mirroring.

- **mirror image resync** *image-spec*

  Force resync to primary image for RBD mirroring.

- **mirror image status** *image-spec*

  Show RBD mirroring status for an image.

- **mirror pool demote** [*pool-name*]

  Demote all primary images within a pool to non-primary. Every mirroring enabled image will demoted in the pool.

- **mirror pool disable** [*pool-name*]

  Disable RBD mirroring by default within a pool. When mirroring is disabled on a pool in this way, mirroring will also be disabled on any images (within the pool) for which mirroring was enabled explicitly.

- **mirror pool enable** [*pool-name*] *mode*

  Enable RBD mirroring by default within a pool. The mirroring mode can either be `pool` or `image`. If configured in `pool` mode, all images in the pool with the journaling feature enabled are mirrored. If configured in `image` mode, mirroring needs to be explicitly enabled (by `mirror image enable` command) on each image.

- **mirror pool info** [*pool-name*]

  Show information about the pool mirroring configuration. It includes mirroring mode, peer UUID, remote cluster name, and remote client name.

- **mirror pool peer add** [*pool-name*] *remote-cluster-spec*

  Add a mirroring peer to a pool. *remote-cluster-spec* is [*remote client name*@]*remote cluster name*. The default for *remote client name* is “client.admin”. This requires mirroring mode is enabled.

- **mirror pool peer remove** [*pool-name*] *uuid*

  Remove a mirroring peer from a pool. The peer uuid is available from `mirror pool info` command.

- **mirror pool peer set** [*pool-name*] *uuid* *key* *value*

  Update mirroring peer settings. The key can be either `client` or `cluster`, and the value is corresponding to remote client name or remote cluster name.

- **mirror pool promote** [--force] [*pool-name*]

  Promote all non-primary images within a pool to primary. Every mirroring enabled image will promoted in the pool.

- **mirror pool status** [--verbose] [*pool-name*]

  Show status for all mirrored images in the pool. With --verbose, also show additionally output status details for every mirroring image in the pool.

- **mirror snapshot schedule add** [-p | --pool *pool*] [--namespace *namespace*] [--image *image*] *interval* [*start-time*]

  Add mirror snapshot schedule.

- **mirror snapshot schedule list** [-R | --recursive] [--format *format*] [--pretty-format] [-p | --pool *pool*] [--namespace *namespace*] [--image *image*]

  List mirror snapshot schedule.

- **mirror snapshot schedule remove** [-p | --pool *pool*] [--namespace *namespace*] [--image *image*] *interval* [*start-time*]

  Remove mirror snapshot schedule.

- **mirror snapshot schedule status** [-p | --pool *pool*] [--format *format*] [--pretty-format] [--namespace *namespace*] [--image *image*]

  Show mirror snapshot schedule status.

- **mv** *src-image-spec* *dest-image-spec*

  Rename an image.  Note: rename across pools is not supported.

- **namespace create** *pool-name*/*namespace-name*

  Create a new image namespace within the pool.

- **namespace list** *pool-name*

  List image namespaces defined within the pool.

- **namespace remove** *pool-name*/*namespace-name*

  Remove an empty image namespace from the pool.

- **object-map check** *image-spec* | *snap-spec*

  Verify the object map is correct.

- **object-map rebuild** *image-spec* | *snap-spec*

  Rebuild an invalid object map for the specified image. An image snapshot can be specified to rebuild an invalid object map for a snapshot.

- **pool init** [*pool-name*] [--force]

  Initialize pool for use by RBD. Newly created pools must initialized prior to use.

- **resize** (-s | --size *size-in-M/G/T*) [--allow-shrink] *image-spec*

  Resize rbd image. The size parameter also needs to be specified. The --allow-shrink option lets the size be reduced.

- **rm** *image-spec*

  Delete an rbd image (including all data blocks). If the image has snapshots, this fails and nothing is deleted.

- **snap create** *snap-spec*

  Create a new snapshot. Requires the snapshot name parameter specified.

- **snap limit clear** *image-spec*

  Remove any previously set limit on the number of snapshots allowed on an image.

- **snap limit set** [--limit] *limit* *image-spec*

  Set a limit for the number of snapshots allowed on an image.

- **snap ls** *image-spec*

  Dump the list of snapshots inside a specific image.

- **snap protect** *snap-spec*

  Protect a snapshot from deletion, so that clones can be made of it (see rbd clone).  Snapshots must be protected before clones are made; protection implies that there exist dependent cloned children that refer to this snapshot.  rbd clone will fail on a nonprotected snapshot. This requires image format 2.

- **snap purge** *image-spec*

  Remove all unprotected snapshots from an image.

- **snap rename** *src-snap-spec* *dest-snap-spec*

  Rename a snapshot. Note: rename across pools and images is not supported.

- **snap rm** [--force] *snap-spec*

  Remove the specified snapshot.

- **snap rollback** *snap-spec*

  Rollback image content to snapshot. This will iterate through the entire blocks array and update the data head content to the snapshotted version.

- **snap unprotect** *snap-spec*

  Unprotect a snapshot from deletion (undo snap protect).  If cloned children remain, snap unprotect fails.  (Note that clones may exist in different pools than the parent snapshot.) This requires image format 2.

- **sparsify** [--sparse-size *sparse-size*] *image-spec*

  Reclaim space for zeroed image extents. The default sparse size is 4096 bytes and can be changed via --sparse-size option with the following restrictions: it should be power of two, not less than 4096, and not larger than image object size.

- **status** *image-spec*

  Show the status of the image, including which clients have it open.

- **trash ls** [*pool-name*]

  List all entries from trash.

- **trash mv** *image-spec*

  Move an image to the trash. Images, even ones actively in-use by clones, can be moved to the trash and deleted at a later time.

- **trash purge** [*pool-name*]

  Remove all expired images from trash.

- **trash restore** *image-id*

  Restore an image from trash.

- **trash rm** *image-id*

  Delete an image from trash. If image deferment time has not expired you can not removed it unless use force. But an actively in-use by clones or has snapshots can not be removed.

- **trash purge schedule add** [-p | --pool *pool*] [--namespace *namespace*] *interval* [*start-time*]

  Add trash purge schedule.

- **trash purge schedule list** [-R | --recursive] [--format *format*] [--pretty-format] [-p | --pool *pool*] [--namespace *namespace*]

  List trash purge schedule.

- **trash purge schedule remove** [-p | --pool *pool*] [--namespace *namespace*] *interval* [*start-time*]

  Remove trash purge schedule.

- **trash purge schedule status** [-p | --pool *pool*] [--format *format*] [--pretty-format] [--namespace *namespace*]

  Show trash purge schedule status.

- **watch** *image-spec*

  Watch events on image.

**Image, snap, group and journal specs**

*image-spec*      is [*pool-name*/[*namespace-name*/]]*image-name*

*snap-spec*       is [*pool-name*/[*namespace-name*/]]*image-name*@*snap-name*

*group-spec*      is [*pool-name*/[*namespace-name*/]]*group-name*

*group-snap-spec* is [*pool-name*/[*namespace-name*/]]*group-name*@*snap-name*

*journal-spec*    is [*pool-name*/[*namespace-name*/]]*journal-name*

The default for *pool-name* is “rbd” and *namespace-name* is “”. If an image name contains a slash character (‘/’), *pool-name* is required.

The *journal-name* is *image-id*.

You may specify each name individually, using --pool, --namespace, --image, and --snap options, but this is discouraged in favor of the above spec syntax.

**Striping**

RBD images are striped over many objects, which are then stored by the Ceph distributed object store (RADOS).  As a result, read and write requests for the image are distributed across many nodes in the cluster, generally preventing any single node from becoming a bottleneck when individual images get large or busy.

The striping is controlled by three parameters:

- object-size[](https://docs.ceph.com/en/latest/man/8/rbd/#cmdoption-rbd-arg-object-size)

  The size of objects we stripe over is a power of two. It will be rounded up the nearest power of two. The default object size is 4 MB, smallest is 4K and maximum is 32M.

- stripe_unit[](https://docs.ceph.com/en/latest/man/8/rbd/#cmdoption-rbd-arg-stripe_unit)

  Each [*stripe_unit*] contiguous bytes are stored adjacently in the same object, before we move on to the next object.

- stripe_count[](https://docs.ceph.com/en/latest/man/8/rbd/#cmdoption-rbd-arg-stripe_count)

  After we write [*stripe_unit*] bytes to [*stripe_count*] objects, we loop back to the initial object and write another stripe, until the object reaches its maximum size.  At that point, we move on to the next [*stripe_count*] objects.

By default, [*stripe_unit*] is the same as the object size and [*stripe_count*] is 1.  Specifying a different [*stripe_unit*] and/or [*stripe_count*] is often referred to as using “fancy” striping and requires format 2.

**Kernel rbd (krbd) options**

Most of these options are useful mainly for debugging and benchmarking.  The default values are set in the kernel and may therefore depend on the version of the running kernel.

Per client instance rbd device map options:

- fsid=aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee - FSID that should be assumed by the client.
- ip=a.b.c.d[:p] - IP and, optionally, port the client should use.
- share - Enable sharing of client instances with other mappings (default).
- noshare - Disable sharing of client instances with other mappings.
- crc - Enable CRC32C checksumming for msgr1 on-the-wire protocol (default). For msgr2.1 protocol this option is ignored: full checksumming is always on in ‘crc’ mode and always off in ‘secure’ mode.
- nocrc - Disable CRC32C checksumming for msgr1 on-the-wire protocol.  Note that only payload checksumming is disabled, header checksumming is always on. For msgr2.1 protocol this option is ignored.
- cephx_require_signatures - Require msgr1 message signing feature (since 3.19, default).  This option is deprecated and will be removed in the future as the feature has been supported since the Bobtail release.
- nocephx_require_signatures - Don’t require msgr1 message signing feature (since 3.19).  This option is deprecated and will be removed in the future.
- tcp_nodelay - Disable Nagle’s algorithm on client sockets (since 4.0, default).
- notcp_nodelay - Enable Nagle’s algorithm on client sockets (since 4.0).
- cephx_sign_messages - Enable message signing for msgr1 on-the-wire protocol (since 4.4, default).  For msgr2.1 protocol this option is ignored: message signing is built into ‘secure’ mode and not offered in ‘crc’ mode.
- nocephx_sign_messages - Disable message signing for msgr1 on-the-wire protocol (since 4.4).  For msgr2.1 protocol this option is ignored.
- mount_timeout=x - A timeout on various steps in rbd device map and rbd device unmap sequences (default is 60 seconds).  In particular, since 4.2 this can be used to ensure that rbd device unmap eventually times out when there is no network connection to a cluster.
- osdkeepalive=x - OSD keepalive timeout (default is 5 seconds).
- osd_idle_ttl=x - OSD idle TTL (default is 60 seconds).

Per mapping (block device) rbd device map options:

- rw - Map the image read-write (default).  Overridden by --read-only.

- ro - Map the image read-only.  Equivalent to --read-only.

- queue_depth=x - queue depth (since 4.2, default is 128 requests).

- lock_on_read - Acquire exclusive lock on reads, in addition to writes and discards (since 4.9).

- exclusive - Disable automatic exclusive lock transitions (since 4.12). Equivalent to --exclusive.

- lock_timeout=x - A timeout on waiting for the acquisition of exclusive lock (since 4.17, default is 0 seconds, meaning no timeout).

- notrim - Turn off discard and write zeroes offload support to avoid deprovisioning a fully provisioned image (since 4.17). When enabled, discard requests will fail with -EOPNOTSUPP, write zeroes requests will fall back to manually zeroing.

- abort_on_full - Fail write requests with -ENOSPC when the cluster is full or the data pool reaches its quota (since 5.0).  The default behaviour is to block until the full condition is cleared.

- alloc_size - Minimum allocation unit of the underlying OSD object store backend (since 5.1, default is 64K bytes).  This is used to round off and drop discards that are too small.  For bluestore, the recommended setting is bluestore_min_alloc_size (typically 64K for hard disk drives and 16K for solid-state drives).  For filestore with filestore_punch_hole = false, the recommended setting is image object size (typically 4M).

- crush_location=x - Specify the location of the client in terms of CRUSH hierarchy (since 5.8).  This is a set of key-value pairs separated from each other by ‘|’, with keys separated from values by ‘:’.  Note that ‘|’ may need to be quoted or escaped to avoid it being interpreted as a pipe by the shell.  The key is the bucket type name (e.g. rack, datacenter or region with default bucket types) and the value is the bucket name.  For example, to indicate that the client is local to rack “myrack”, data center “mydc” and region “myregion”:

  ```
  crush_location=rack:myrack|datacenter:mydc|region:myregion
  ```

  Each key-value pair stands on its own: “myrack” doesn’t need to reside in “mydc”, which in turn doesn’t need to reside in “myregion”.  The location is not a path to the root of the hierarchy but rather a set of nodes that are matched independently, owning to the fact that bucket names are unique within a CRUSH map.  “Multipath” locations are supported, so it is possible to indicate locality for multiple parallel hierarchies:

  ```
  crush_location=rack:myrack1|rack:myrack2|datacenter:mydc
  ```

- read_from_replica=no - Disable replica reads, always pick the primary OSD (since 5.8, default).

- read_from_replica=balance - When issued a read on a replicated pool, pick a random OSD for serving it (since 5.8).

  This mode is safe for general use only since Octopus (i.e. after “ceph osd require-osd-release octopus”).  Otherwise it should be limited to read-only workloads such as images mapped read-only everywhere or snapshots.

- read_from_replica=localize - When issued a read on a replicated pool, pick the most local OSD for serving it (since 5.8).  The locality metric is calculated against the location of the client given with crush_location; a match with the lowest-valued bucket type wins.  For example, with default bucket types, an OSD in a matching rack is closer than an OSD in a matching data center, which in turn is closer than an OSD in a matching region.

  This mode is safe for general use only since Octopus (i.e. after “ceph osd require-osd-release octopus”).  Otherwise it should be limited to read-only workloads such as images mapped read-only everywhere or snapshots.

- compression_hint=none - Don’t set compression hints (since 5.8, default).

- compression_hint=compressible - Hint to the underlying OSD object store backend that the data is compressible, enabling compression in passive mode (since 5.8).

- compression_hint=incompressible - Hint to the underlying OSD object store backend that the data is incompressible, disabling compression in aggressive mode (since 5.8).

- ms_mode=legacy - Use msgr1 on-the-wire protocol (since 5.11, default).

- ms_mode=crc - Use msgr2.1 on-the-wire protocol, select ‘crc’ mode, also referred to as plain mode (since 5.11).  If the daemon denies ‘crc’ mode, fail the connection.

- ms_mode=secure - Use msgr2.1 on-the-wire protocol, select ‘secure’ mode (since 5.11).  ‘secure’ mode provides full in-transit encryption ensuring both confidentiality and authenticity.  If the daemon denies ‘secure’ mode, fail the connection.

- ms_mode=prefer-crc - Use msgr2.1 on-the-wire protocol, select ‘crc’ mode (since 5.11).  If the daemon denies ‘crc’ mode in favor of ‘secure’ mode, agree to ‘secure’ mode.

- ms_mode=prefer-secure - Use msgr2.1 on-the-wire protocol, select ‘secure’ mode (since 5.11).  If the daemon denies ‘secure’ mode in favor of ‘crc’ mode, agree to ‘crc’ mode.

- rxbounce - Use a bounce buffer when receiving data (since 5.17).  The default behaviour is to read directly into the destination buffer.  A bounce buffer is needed if the destination buffer isn’t guaranteed to be stable (i.e. remain unchanged while it is being read to).  In particular this is the case for Windows where a system-wide “dummy” (throwaway) page may be mapped into the destination buffer in order to generate a single large I/O.  Otherwise, “libceph: … bad crc/signature” or “libceph: … integrity error, bad crc” errors and associated performance degradation are expected.

- udev - Wait for udev device manager to finish executing all matching “add” rules and release the device before exiting (default).  This option is not passed to the kernel.

- noudev - Don’t wait for udev device manager.  When enabled, the device may not be fully usable immediately on exit.

rbd device unmap options:

- force - Force the unmapping of a block device that is open (since 4.9).  The driver will wait for running requests to complete and then unmap; requests sent to the driver after initiating the unmap will be failed.
- udev - Wait for udev device manager to finish executing all matching “remove” rules and clean up after the device before exiting (default). This option is not passed to the kernel.
- noudev - Don’t wait for udev device manager.

**Examples**

To create a new rbd image that is 100 GB:

```
rbd create mypool/myimage --size 102400
```

To use a non-default object size (8 MB):

```
rbd create mypool/myimage --size 102400 --object-size 8M
```

To delete an rbd image (be careful!):

```
rbd rm mypool/myimage
```

To create a new snapshot:

```
rbd snap create mypool/myimage@mysnap
```

To create a copy-on-write clone of a protected snapshot:

```
rbd clone mypool/myimage@mysnap otherpool/cloneimage
```

To see which clones of a snapshot exist:

```
rbd children mypool/myimage@mysnap
```

To delete a snapshot:

```
rbd snap rm mypool/myimage@mysnap
```

To map an image via the kernel with cephx enabled:

```
rbd device map mypool/myimage --id admin --keyfile secretfile
```

To map an image via the kernel with different cluster name other than default *ceph*:

```
rbd device map mypool/myimage --cluster cluster-name
```

To unmap an image:

```
rbd device unmap /dev/rbd0
```

To create an image and a clone from it:

```
rbd import --image-format 2 image mypool/parent
rbd snap create mypool/parent@snap
rbd snap protect mypool/parent@snap
rbd clone mypool/parent@snap otherpool/child
```

To create an image with a smaller stripe_unit (to better distribute small writes in some workloads):

```
rbd create mypool/myimage --size 102400 --stripe-unit 65536B --stripe-count 16
```

To change an image from one image format to another, export it and then import it as the desired image format:

```
rbd export mypool/myimage@snap /tmp/img
rbd import --image-format 2 /tmp/img mypool/myimage2
```

To lock an image for exclusive use:

```
rbd lock add mypool/myimage mylockid
```

To release a lock:

```
rbd lock remove mypool/myimage mylockid client.2485
```

To list images from trash:

```
rbd trash ls mypool
```

To defer delete an image (use *--expires-at* to set expiration time, default is now):

```
rbd trash mv mypool/myimage --expires-at "tomorrow"
```

To delete an image from trash (be careful!):

```
rbd trash rm mypool/myimage-id
```

To force delete an image from trash (be careful!):

```
rbd trash rm mypool/myimage-id  --force
```

To restore an image from trash:

```
rbd trash restore mypool/myimage-id
```

To restore an image from trash and rename it:

```
rbd trash restore mypool/myimage-id --image mynewimage
```

**Availability**

**rbd** is part of Ceph, a massively scalable, open-source, distributed storage system. Please refer to the Ceph documentation at https://docs.ceph.com for more information.

### rbd-fuse -- expose rbd images as files

**rbd-fuse** is a FUSE (“Filesystem in USErspace”) client for RADOS block device (rbd) images.  Given a pool containing rbd images, it will mount a userspace file system allowing access to those images as regular files at **mountpoint**.

The file system can be unmounted with:

```
fusermount -u mountpoint
```

or by sending `SIGINT` to the `rbd-fuse` process.

```bash
rbd-fuse [ -p pool ] [-c conffile] mountpoint [ fuse options ]
```

> Note
>
> rbd-fuse is not recommended for any production or high performance workloads.

**Options**

Any options not recognized by rbd-fuse will be passed on to libfuse.

- -c ceph.conf

  Use *ceph.conf* configuration file instead of the default `/etc/ceph/ceph.conf` to determine monitor addresses during startup.

- -p pool

  Use *pool* as the pool to search for rbd images.  Default is `rbd`.

**Availability**

**rbd-fuse** is part of Ceph, a massively scalable, open-source, distributed storage system. Please refer to the Ceph documentation at https://docs.ceph.com for more information.

### rbd-nbd -- map rbd images to nbd device

**rbd-nbd** is a client for RADOS block device (rbd) images like rbd kernel module. It will map a rbd image to a nbd (Network Block Device) device, allowing access it as regular local block device.

```bash
**rbd-nbd** [-c conf] [--read-only] [--device *nbd device*] [--nbds_max *limit*] [--max_part *limit*] [--exclusive] [--notrim] [--encryption-format *format*] [--encryption-passphrase-file *passphrase-file*] [--io-timeout *seconds*] [--reattach-timeout *seconds*] map *image-spec* | *snap-spec*

rbd-nbd** unmap *nbd device* | *image-spec* | *snap-spec*

**rbd-nbd** list-mapped

**rbd-nbd** attach --device *nbd device* *image-spec* | *snap-spec*

**rbd-nbd** detach *nbd device* | *image-spec* | *snap-spec*
```

**Options**

- -c ceph.conf

  Use *ceph.conf* configuration file instead of the default `/etc/ceph/ceph.conf` to determine monitor addresses during startup.

- --read-only

  Map read-only.

- --nbds_max *limit*

  Override the parameter nbds_max of NBD kernel module when modprobe, used to limit the count of nbd device.

- --max_part *limit*

  Override for module param max_part.

- --exclusive

  Forbid writes by other clients.

- --notrim

  Turn off trim/discard.

- --encryption-format

  Image encryption format. Possible values: *luks1*, *luks2*

- --encryption-passphrase-file

  Path of file containing a passphrase for unlocking image encryption.

- --io-timeout *seconds*

  Override device timeout. Linux kernel will default to a 30 second request timeout. Allow the user to optionally specify an alternate timeout.

- --reattach-timeout *seconds*

  Specify timeout for the kernel to wait for a new rbd-nbd process is attached after the old process is detached. The default is 30 second.

**Image and snap specs**

*image-spec* is [*pool-name*]/*image-name*

*snap-spec*  is [*pool-name*]/*image-name*@*snap-name*

The default for *pool-name* is “rbd”.  If an image name contains a slash character (‘/’), *pool-name* is required.

**Availability**

**rbd-nbd** is part of Ceph, a massively scalable, open-source, distributed storage system. Please refer to the Ceph documentation at https://docs.ceph.com/ for more information.

### rbd-ggate -- map rbd images via FreeBSD GEOM Gate

**rbd-ggate** is a client for RADOS block device (rbd) images. It will map a rbd image to a ggate (FreeBSD GEOM Gate class) device, allowing access it as regular local block device.

```
**rbd-ggate** [--read-only] [--exclusive] [--device *ggate device*] map *image-spec* | *snap-spec*

**rbd-ggate** unmap *ggate device*

rbd-ggate** list
```

**Commands**

### map

Spawn a process responsible for the creation of ggate device and forwarding I/O requests between the GEOM Gate kernel subsystem and RADOS.

### unmap

Destroy ggate device and terminate the process responsible for it.

### list

List mapped ggate devices.

## Options

- --device *ggate device*

  Specify ggate device path.

- --read-only

  Map read-only.

- --exclusive

  Forbid writes by other clients.

## Image and snap specs

*image-spec* is [*pool-name*]/*image-name*

*snap-spec*  is [*pool-name*]/*image-name*@*snap-name*

The default for *pool-name* is “rbd”.  If an image name contains a slash character (‘/’), *pool-name* is required.

## Availability

**rbd-ggate** is part of Ceph, a massively scalable, open-source, distributed storage system. Please refer to the Ceph documentation at https://docs.ceph.com for more information.

# rbdmap -- map RBD devices at boot time

## Synopsis

**rbdmap map**

**rbdmap unmap**

## Description

**rbdmap** is a shell script that automates `rbd map` and `rbd unmap` operations on one or more RBD (RADOS Block Device) images. While the script can be run manually by the system administrator at any time, the principal use case is automatic mapping/mounting of RBD images at boot time (and unmounting/unmapping at shutdown), as triggered by the init system (a systemd unit file, `rbdmap.service` is included with the ceph-common package for this purpose).

The script takes a single argument, which can be either “map” or “unmap”. In either case, the script parses a configuration file (defaults to `/etc/ceph/rbdmap`, but can be overridden via an environment variable `RBDMAPFILE`). Each line of the configuration file corresponds to an RBD image which is to be mapped, or unmapped.

The configuration file format is:

```
IMAGESPEC RBDOPTS
```

where `IMAGESPEC` should be specified as `POOLNAME/IMAGENAME` (the pool name, a forward slash, and the image name), or merely `IMAGENAME`, in which case the `POOLNAME` defaults to “rbd”. `RBDOPTS` is an optional list of parameters to be passed to the underlying `rbd map` command. These parameters and their values should be specified as a comma-separated string:

```
PARAM1=VAL1,PARAM2=VAL2,...,PARAMN=VALN
```

This will cause the script to issue an `rbd map` command like the following:

```
rbd map POOLNAME/IMAGENAME --PARAM1 VAL1 --PARAM2 VAL2
```

(See the `rbd` manpage for a full list of possible options.) For parameters and values which contain commas or equality signs, a simple apostrophe can be used to prevent replacing them.

When run as `rbdmap map`, the script parses the configuration file, and for each RBD image specified attempts to first map the image (using the `rbd map` command) and, second, to mount the image.

When run as `rbdmap unmap`, images listed in the configuration file will be unmounted and unmapped.

`rbdmap unmap-all` attempts to unmount and subsequently unmap all currently mapped RBD images, regardless of whether or not they are listed in the configuration file.

If successful, the `rbd map` operation maps the image to a `/dev/rbdX` device, at which point a udev rule is triggered to create a friendly device name symlink, `/dev/rbd/POOLNAME/IMAGENAME`, pointing to the real mapped device.

In order for mounting/unmounting to succeed, the friendly device name must have a corresponding entry in `/etc/fstab`.

When writing `/etc/fstab` entries for RBD images, it’s a good idea to specify the “noauto” (or “nofail”) mount option. This prevents the init system from trying to mount the device too early - before the device in question even exists. (Since `rbdmap.service` executes a shell script, it is typically triggered quite late in the boot sequence.)

## Examples

Example `/etc/ceph/rbdmap` for three RBD images called “bar1”, “bar2” and “bar3”, which are in pool “foopool”:

```
foopool/bar1    id=admin,keyring=/etc/ceph/ceph.client.admin.keyring
foopool/bar2    id=admin,keyring=/etc/ceph/ceph.client.admin.keyring
foopool/bar3    id=admin,keyring=/etc/ceph/ceph.client.admin.keyring,options='lock_on_read,queue_depth=1024'
```

Each line in the file contains two strings: the image spec and the options to be passed to `rbd map`. These two lines get transformed into the following commands:

```
rbd map foopool/bar1 --id admin --keyring /etc/ceph/ceph.client.admin.keyring
rbd map foopool/bar2 --id admin --keyring /etc/ceph/ceph.client.admin.keyring
rbd map foopool/bar2 --id admin --keyring /etc/ceph/ceph.client.admin.keyring --options lock_on_read,queue_depth=1024
```

If the images had XFS file systems on them, the corresponding `/etc/fstab` entries might look like this:

```
/dev/rbd/foopool/bar1 /mnt/bar1 xfs noauto 0 0
/dev/rbd/foopool/bar2 /mnt/bar2 xfs noauto 0 0
/dev/rbd/foopool/bar3 /mnt/bar3 xfs noauto 0 0
```

After creating the images and populating the `/etc/ceph/rbdmap` file, making the images get automatically mapped and mounted at boot is just a matter of enabling that unit:

```
systemctl enable rbdmap.service
```

## Options

None

## Availability

**rbdmap** is part of Ceph, a massively scalable, open-source, distributed storage system. Please refer to the Ceph documentation at https://docs.ceph.com for more information.

# ceph-rbdnamer -- udev helper to name RBD devices

## Synopsis

**ceph-rbdnamer** *num*

## Description

**ceph-rbdnamer** prints the pool and image name for the given RBD devices to stdout. It is used by udev (using a rule like the one below) to set up a device symlink.

```
KERNEL=="rbd[0-9]*", PROGRAM="/usr/bin/ceph-rbdnamer %n", SYMLINK+="rbd/%c{1}/%c{2}"
```

## Availability

**ceph-rbdnamer** is part of Ceph, a massively scalable, open-source, distributed storage system.  Please refer to the Ceph documentation at https://docs.ceph.com for more information.

# rbd-replay-prep -- prepare captured rados block device (RBD) workloads for replay

## Synopsis

**rbd-replay-prep** [ --window *seconds* ] [ --anonymize ] *trace_dir* *replay_file*

## Description

**rbd-replay-prep** processes raw rados block device (RBD) traces to prepare them for **rbd-replay**.

## Options

- --window seconds

  Requests further apart than ‘seconds’ seconds are assumed to be independent.

- --anonymize

  Anonymizes image and snap names.

- --verbose

  Print all processed events to console

## Examples

To prepare workload1-trace for replay:

```
rbd-replay-prep workload1-trace/ust/uid/1000/64-bit workload1
```

## Availability

**rbd-replay-prep** is part of Ceph, a massively scalable, open-source, distributed storage system. Please refer to the Ceph documentation at https://docs.ceph.com for more information.

# rbd-replay -- replay rados block device (RBD) workloads

## Synopsis

**rbd-replay** [ *options* ] *replay_file*

## Description

**rbd-replay** is a utility for replaying rados block device (RBD) workloads.

## Options

- -c ceph.conf, --conf ceph.conf

  Use ceph.conf configuration file instead of the default /etc/ceph/ceph.conf to determine monitor addresses during startup.

- -p pool, --pool pool

  Interact with the given pool.  Defaults to ‘rbd’.

- --latency-multiplier

  Multiplies inter-request latencies.  Default: 1.

- --read-only

  Only replay non-destructive requests.

- --map-image rule

  Add a rule to map image names in the trace to image names in the replay cluster. A rule of image1@snap1=image2@snap2 would map snap1 of image1 to snap2 of image2.

- --dump-perf-counters

  **Experimental** Dump performance counters to standard out before an image is closed. Performance counters may be dumped multiple times if multiple images are closed, or if the same image is opened and closed multiple times. Performance counters and their meaning may change between versions.

## Examples

To replay workload1 as fast as possible:

```
rbd-replay --latency-multiplier=0 workload1
```

To replay workload1 but use test_image instead of prod_image:

```
rbd-replay --map-image=prod_image=test_image workload1
```

## Availability

**rbd-replay** is part of Ceph, a massively scalable, open-source, distributed storage system. Please refer to the Ceph documentation at https://docs.ceph.com for more information.



# rbd-replay-many -- replay a rados block device (RBD) workload on several clients

## Synopsis

**rbd-replay-many** [ *options* ] --original-image *name* *host1* [ *host2* [ … ] ] -- *rbd_replay_args*

## Description

**rbd-replay-many** is a utility for replaying a rados block device (RBD) workload on several clients. Although all clients use the same workload, they replay against separate images. This matches normal use of librbd, where each original client is a VM with its own image.

Configuration and replay files are not automatically copied to clients. Replay images must already exist.

## Options

- --original-image name

  Specifies the name (and snap) of the originally traced image. Necessary for correct name mapping.

- --image-prefix prefix

  Prefix of image names to replay against. Specifying --image-prefix=foo results in clients replaying against foo-0, foo-1, etc. Defaults to the original image name.

- --exec program

  Path to the rbd-replay executable.

- --delay seconds

  Delay between starting each client.  Defaults to 0.

## Examples

Typical usage:

```
rbd-replay-many host-0 host-1 --original-image=image -- -c ceph.conf replay.bin
```

This results in the following commands being executed:

```
ssh host-0 'rbd-replay' --map-image 'image=image-0' -c ceph.conf replay.bin
ssh host-1 'rbd-replay' --map-image 'image=image-1' -c ceph.conf replay.bin
```

## Availability

**rbd-replay-many** is part of Ceph, a massively scalable, open-source, distributed storage system. Please refer to the Ceph documentation at https://docs.ceph.com for more information.

## Ceph Block Device API

### Librbd (Python)

The rbd python module provides file-like access to RBD images.

#### Creating and writing to an image

To use rbd, you must first connect to RADOS and open an IO context:

```python
cluster = rados.Rados(conffile='my_ceph.conf')
cluster.connect()
ioctx = cluster.open_ioctx('mypool')
```

Then you instantiate an :class:rbd.RBD object, which you use to create the image:

```python
rbd_inst = rbd.RBD()
size = 4 * 1024**3  # 4 GiB
rbd_inst.create(ioctx, 'myimage', size)
```

To perform I/O on the image, you instantiate an :class:rbd.Image object:

```python
image = rbd.Image(ioctx, 'myimage')
data = b'foo' * 200
image.write(data, 0)
```

This writes ‘foo’ to the first 600 bytes of the image. Note that data cannot be :type:unicode - Librbd does not know how to deal with characters wider than a :c:type:char.

In the end, you will want to close the image, the IO context and the connection to RADOS:

```python
image.close()
ioctx.close()
cluster.shutdown()
```

To be safe, each of these calls would need to be in a separate :finally block:

```python
cluster = rados.Rados(conffile='my_ceph_conf')
try:
    cluster.connect()
    ioctx = cluster.open_ioctx('my_pool')
    try:
        rbd_inst = rbd.RBD()
        size = 4 * 1024**3  # 4 GiB
        rbd_inst.create(ioctx, 'myimage', size)
        image = rbd.Image(ioctx, 'myimage')
        try:
            data = b'foo' * 200
            image.write(data, 0)
        finally:
            image.close()
    finally:
        ioctx.close()
finally:
    cluster.shutdown()
```

This can be cumbersome, so the `Rados`, `Ioctx`, and `Image` classes can be used as context managers that close/shutdown automatically (see [**PEP 343**](https://peps.python.org/pep-0343/)). Using them as context managers, the above example becomes:

```python
with rados.Rados(conffile='my_ceph.conf') as cluster:
    with cluster.open_ioctx('mypool') as ioctx:
        rbd_inst = rbd.RBD()
        size = 4 * 1024**3  # 4 GiB
        rbd_inst.create(ioctx, 'myimage', size)
        with rbd.Image(ioctx, 'myimage') as image:
            data = b'foo' * 200
            image.write(data, 0)
```



## API Reference

This module is a thin wrapper around librbd.

It currently provides all the synchronous methods of librbd that do not use callbacks.

Error codes from librbd are turned into exceptions that subclass `Error`. Almost all methods may raise `Error` (the base class of all rbd exceptions), `PermissionError` and `IOError`, in addition to those documented for the method.

- *class* rbd.Image(*ioctx*, *name=None*, *snapshot=None*, *read_only=False*, *image_id=None*, *_oncomplete=None*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.Image)

  This class represents an RBD image. It is used to perform I/O on the image and interact with snapshots. **Note**: Any method of this class may raise `ImageNotFound` if the image has been deleted.  close(*self*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.Image.close) Release the resources used by this image object. After this is called, this object should not be used.   require_not_closed(*self*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.Image.require_not_closed) Checks if the Image is not closed Raises `InvalidArgument`

- *class* rbd.RBD[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD)

  This class wraps librbd CRUD functions.  aio_open_image(*self*, *oncomplete*, *ioctx*, *name=None*, *snapshot=None*, *read_only=False*, *image_id=None*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.aio_open_image) Asynchronously open the image at the given snapshot. Specify either name or id, otherwise `InvalidArgument` is raised. oncomplete will be called with the created Image object as well as the completion: oncomplete(completion, image) If a snapshot is specified, the image will be read-only, unless `Image.set_snap()` is called later. If read-only mode is used, metadata for the [`Image`](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.Image) object (such as which snapshots exist) may become obsolete. See the C api for more details. To clean up from opening the image, [`Image.close()`](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.Image.close) or `Image.aio_close()` should be called. Parameters **oncomplete** (*completion*) -- what to do when open is complete **ioctx** (`rados.Ioctx`) -- determines which RADOS pool the image is in **name** (*str*) -- the name of the image **snapshot** -- which snapshot to read from **read_only** (*bool*) -- whether to open the image in read-only mode **image_id** (*str*) -- the id of the image  Returns `Completion` - the completion object    clone(*self*, *p_ioctx*, *p_name*, *p_snapname*, *c_ioctx*, *c_name*, *features=None*, *order=None*, *stripe_unit=None*, *stripe_count=None*, *data_pool=None*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.clone) Clone a parent rbd snapshot into a COW sparse child. Parameters **p_ioctx** -- the parent context that represents the parent snap **p_name** -- the parent image name **p_snapname** -- the parent image snapshot name **c_ioctx** -- the child context that represents the new clone **c_name** -- the clone (child) name **features** (*int*) -- bitmask of features to enable; if set, must include layering **order** (*int*) -- the image is split into (2**order) byte objects **stripe_unit** (*int*) -- stripe unit in bytes (default None to let librbd decide) **stripe_count** (*int*) -- objects to stripe over before looping **data_pool** (*str*) -- optional separate pool for data blocks  Raises `TypeError` Raises `InvalidArgument` Raises `ImageExists` Raises `FunctionNotSupported` Raises `ArgumentOutOfRange`    config_get(*self*, *ioctx*, *key*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.config_get) Get a pool-level configuration override. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool is read **key** (*str*) -- key  Returns str - value    config_list(*self*, *ioctx*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.config_list) List pool-level config overrides. Returns `ConfigPoolIterator`    config_remove(*self*, *ioctx*, *key*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.config_remove) Remove a pool-level configuration override. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool is read **key** (*str*) -- key  Returns str - value    config_set(*self*, *ioctx*, *key*, *value*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.config_set) Get a pool-level configuration override. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool is read **key** (*str*) -- key **value** (*str*) -- value    create(*self*, *ioctx*, *name*, *size*, *order=None*, *old_format=False*, *features=None*, *stripe_unit=None*, *stripe_count=None*, *data_pool=None*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.create) Create an rbd image. Parameters **ioctx** (`rados.Ioctx`) -- the context in which to create the image **name** (*str*) -- what the image is called **size** (*int*) -- how big the image is in bytes **order** (*int*) -- the image is split into (2**order) byte objects **old_format** (*bool*) -- whether to create an old-style image that is accessible by old clients, but can’t use more advanced features like layering. **features** (*int*) -- bitmask of features to enable **stripe_unit** (*int*) -- stripe unit in bytes (default None to let librbd decide) **stripe_count** (*int*) -- objects to stripe over before looping **data_pool** (*str*) -- optional separate pool for data blocks  Raises `ImageExists` Raises `TypeError` Raises `InvalidArgument` Raises `FunctionNotSupported`    features_from_string(*self*, *str_features*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.features_from_string) Get features bitmask from str, if str_features is empty, it will return RBD_FEATURES_DEFAULT. Parameters **str_features** (*str*) -- feature str Returns int - the features bitmask of the image Raises `InvalidArgument`    features_to_string(*self*, *features*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.features_to_string) Convert features bitmask to str. Parameters **features** (*int*) -- feature bitmask Returns str - the features str of the image Raises `InvalidArgument`    group_create(*self*, *ioctx*, *name*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.group_create) Create a group. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool is used **name** (*str*) -- the name of the group  Raises `ObjectExists` Raises `InvalidArgument` Raises `FunctionNotSupported`    group_list(*self*, *ioctx*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.group_list) List groups. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool is read Returns list -- a list of groups names Raises `FunctionNotSupported`    group_remove(*self*, *ioctx*, *name*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.group_remove) Delete an RBD group. This may take a long time, since it does not return until every image in the group has been removed from the group. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool the group is in **name** (*str*) -- the name of the group to remove  Raises `ObjectNotFound` Raises `InvalidArgument` Raises `FunctionNotSupported`    group_rename(*self*, *ioctx*, *src*, *dest*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.group_rename) Rename an RBD group. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool the group is in **src** (*str*) -- the current name of the group **dest** (*str*) -- the new name of the group  Raises `ObjectExists` Raises `ObjectNotFound` Raises `InvalidArgument` Raises `FunctionNotSupported`    list(*self*, *ioctx*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.list) List image names. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool is read Returns list -- a list of image names    list2(*self*, *ioctx*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.list2) Iterate over the images in the pool. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool the image is in Returns `ImageIterator`    migration_abort(*self*, *ioctx*, *image_name*, *on_progress=None*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.migration_abort) Cancel a previously started but interrupted migration. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool the image is in **image_name** (*str*) -- the name of the image **on_progress** (*callback function*) -- optional progress callback function  Raises `ImageNotFound`    migration_commit(*self*, *ioctx*, *image_name*, *on_progress=None*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.migration_commit) Commit an executed RBD image migration. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool the image is in **image_name** (*str*) -- the name of the image **on_progress** (*callback function*) -- optional progress callback function  Raises `ImageNotFound`    migration_execute(*self*, *ioctx*, *image_name*, *on_progress=None*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.migration_execute) Execute a prepared RBD image migration. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool the image is in **image_name** (*str*) -- the name of the image **on_progress** (*callback function*) -- optional progress callback function  Raises `ImageNotFound`    migration_prepare(*self*, *ioctx*, *image_name*, *dest_ioctx*, *dest_image_name*, *features=None*, *order=None*, *stripe_unit=None*, *stripe_count=None*, *data_pool=None*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.migration_prepare) Prepare an RBD image migration. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool the image is in **image_name** -- the current name of the image **dest_ioctx** (`rados.Ioctx`) -- determines which pool to migration into **dest_image_name** (*str*) -- the name of the destination image (may be the same image) **features** (*int*) -- bitmask of features to enable; if set, must include layering **order** (*int*) -- the image is split into (2**order) byte objects **stripe_unit** (*int*) -- stripe unit in bytes (default None to let librbd decide) **stripe_count** (*int*) -- objects to stripe over before looping **data_pool** (*str*) -- optional separate pool for data blocks  Raises `TypeError` Raises `InvalidArgument` Raises `ImageExists` Raises `FunctionNotSupported` Raises `ArgumentOutOfRange`    migration_prepare_import(*self*, *source_spec*, *dest_ioctx*, *dest_image_name*, *features=None*, *order=None*, *stripe_unit=None*, *stripe_count=None*, *data_pool=None*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.migration_prepare_import) Prepare an RBD image migration. Parameters **source_spec** (*str*) -- JSON-encoded source-spec **dest_ioctx** (`rados.Ioctx`) -- determines which pool to migration into **dest_image_name** (*str*) -- the name of the destination image (may be the same image) **features** (*int*) -- bitmask of features to enable; if set, must include layering **order** (*int*) -- the image is split into (2**order) byte objects **stripe_unit** (*int*) -- stripe unit in bytes (default None to let librbd decide) **stripe_count** (*int*) -- objects to stripe over before looping **data_pool** (*str*) -- optional separate pool for data blocks  Raises `TypeError` Raises `InvalidArgument` Raises `ImageExists` Raises `FunctionNotSupported` Raises `ArgumentOutOfRange`    migration_status(*self*, *ioctx*, *image_name*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.migration_status) Return RBD image migration status. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool the image is in **image_name** (*str*) -- the name of the image  Returns dict - contains the following keys: `source_pool_id` (int) - source image pool id `source_pool_namespace` (str) - source image pool namespace `source_image_name` (str) - source image name `source_image_id` (str) - source image id `dest_pool_id` (int) - destination image pool id `dest_pool_namespace` (str) - destination image pool namespace `dest_image_name` (str) - destination image name `dest_image_id` (str) - destination image id `state` (int) - current migration state `state_description` (str) - migration state description  Raises `ImageNotFound`    mirror_image_info_list(*self*, *ioctx*, *mode_filter=None*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.mirror_image_info_list) Iterate over the mirror image instance ids of a pool. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool is read **mode_filter** -- list images in this image mirror mode  Returns `MirrorImageInfoIterator`    mirror_image_instance_id_list(*self*, *ioctx*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.mirror_image_instance_id_list) Iterate over the mirror image instance ids of a pool. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool is read Returns `MirrorImageInstanceIdIterator`    mirror_image_status_list(*self*, *ioctx*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.mirror_image_status_list) Iterate over the mirror image statuses of a pool. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool is read Returns `MirrorImageStatusIterator`    mirror_image_status_summary(*self*, *ioctx*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.mirror_image_status_summary) Get mirror image status summary of a pool. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool is read Returns list - a list of (state, count) tuples    mirror_mode_get(*self*, *ioctx*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.mirror_mode_get) Get pool mirror mode. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool is read Returns int - pool mirror mode    mirror_mode_set(*self*, *ioctx*, *mirror_mode*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.mirror_mode_set) Set pool mirror mode. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool is written **mirror_mode** (*int*) -- mirror mode to set    mirror_peer_add(*self*, *ioctx*, *site_name*, *client_name*, *direction=RBD_MIRROR_PEER_DIRECTION_RX_TX*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.mirror_peer_add) Add mirror peer. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool is used **site_name** (*str*) -- mirror peer site name **client_name** (*str*) -- mirror peer client name **direction** (*int*) -- the direction of the mirroring  Returns str - peer uuid    mirror_peer_bootstrap_create(*self*, *ioctx*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.mirror_peer_bootstrap_create) Creates a new RBD mirroring bootstrap token for an external cluster. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool is written Returns str - bootstrap token    mirror_peer_bootstrap_import(*self*, *ioctx*, *direction*, *token*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.mirror_peer_bootstrap_import) Import a bootstrap token from an external cluster to auto-configure the mirror peer. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool is written **direction** (*int*) -- mirror peer direction **token** (*str*) -- bootstrap token    mirror_peer_get_attributes(*self*, *ioctx*, *uuid*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.mirror_peer_get_attributes) Get optional mirror peer attributes Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool is written **uuid** (*str*) -- uuid of the mirror peer  Returns dict - contains the following keys: `mon_host` (str) - monitor addresses `key` (str) - CephX key     mirror_peer_list(*self*, *ioctx*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.mirror_peer_list) Iterate over the peers of a pool. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool is read Returns `MirrorPeerIterator`    mirror_peer_remove(*self*, *ioctx*, *uuid*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.mirror_peer_remove) Remove mirror peer. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool is used **uuid** (*str*) -- peer uuid    mirror_peer_set_attributes(*self*, *ioctx*, *uuid*, *attributes*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.mirror_peer_set_attributes) Set optional mirror peer attributes Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool is written **uuid** (*str*) -- uuid of the mirror peer **attributes** (*dict*) -- ‘mon_host’ and ‘key’ attributes    mirror_peer_set_client(*self*, *ioctx*, *uuid*, *client_name*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.mirror_peer_set_client) Set mirror peer client name Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool is written **uuid** (*str*) -- uuid of the mirror peer **client_name** (*str*) -- client name of the mirror peer to set    mirror_peer_set_cluster(*self*, *ioctx*, *uuid*, *cluster_name*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.mirror_peer_set_cluster)   mirror_peer_set_name(*self*, *ioctx*, *uuid*, *site_name*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.mirror_peer_set_name) Set mirror peer site name Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool is written **uuid** (*str*) -- uuid of the mirror peer **site_name** (*str*) -- site name of the mirror peer to set    mirror_site_name_get(*self*, *rados*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.mirror_site_name_get) Get the local cluster’s friendly site name Parameters **rados** -- cluster connection Returns str - local site name    mirror_site_name_set(*self*, *rados*, *site_name*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.mirror_site_name_set) Set the local cluster’s friendly site name Parameters **rados** -- cluster connection **site_name** -- friendly site name    mirror_uuid_get(*self*, *ioctx*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.mirror_uuid_get) Get pool mirror uuid Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool is read Returns ste - pool mirror uuid    namespace_create(*self*, *ioctx*, *name*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.namespace_create) Create an RBD namespace within a pool Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool **name** (*str*) -- namespace name    namespace_exists(*self*, *ioctx*, *name*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.namespace_exists) Verifies if a namespace exists within a pool Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool **name** (*str*) -- namespace name  Returns bool - true if namespace exists    namespace_list(*self*, *ioctx*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.namespace_list) List all namespaces within a pool Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool Returns list - collection of namespace names    namespace_remove(*self*, *ioctx*, *name*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.namespace_remove) Remove an RBD namespace from a pool Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool **name** (*str*) -- namespace name    pool_init(*self*, *ioctx*, *force*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.pool_init) Initialize an RBD pool :param ioctx: determines which RADOS pool :type ioctx: `rados.Ioctx` :param force: force init :type force: bool   pool_metadata_get(*self*, *ioctx*, *key*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.pool_metadata_get) Get pool metadata for the given key. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool is read **key** (*str*) -- metadata key  Returns str - metadata value    pool_metadata_list(*self*, *ioctx*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.pool_metadata_list) List pool metadata. Returns `PoolMetadataIterator`    pool_metadata_remove(*self*, *ioctx*, *key*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.pool_metadata_remove) Remove pool metadata for the given key. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool is read **key** (*str*) -- metadata key  Returns str - metadata value    pool_metadata_set(*self*, *ioctx*, *key*, *value*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.pool_metadata_set) Set pool metadata for the given key. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool is read **key** (*str*) -- metadata key **value** (*str*) -- metadata value    pool_stats_get(*self*, *ioctx*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.pool_stats_get) Return RBD pool stats Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool Returns dict - contains the following keys: `image_count` (int) - image count `image_provisioned_bytes` (int) - image total HEAD provisioned bytes `image_max_provisioned_bytes` (int) - image total max provisioned bytes `image_snap_count` (int) - image snap count `trash_count` (int) - trash image count `trash_provisioned_bytes` (int) - trash total HEAD provisioned bytes `trash_max_provisioned_bytes` (int) - trash total max provisioned bytes `trash_snap_count` (int) - trash snap count     remove(*self*, *ioctx*, *name*, *on_progress=None*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.remove) Delete an RBD image. This may take a long time, since it does not return until every object that comprises the image has been deleted. Note that all snapshots must be deleted before the image can be removed. If there are snapshots left, `ImageHasSnapshots` is raised. If the image is still open, or the watch from a crashed client has not expired, `ImageBusy` is raised. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool the image is in **name** (*str*) -- the name of the image to remove **on_progress** (*callback function*) -- optional progress callback function  Raises `ImageNotFound`, `ImageBusy`, `ImageHasSnapshots`    rename(*self*, *ioctx*, *src*, *dest*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.rename) Rename an RBD image. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool the image is in **src** (*str*) -- the current name of the image **dest** (*str*) -- the new name of the image  Raises `ImageNotFound`, `ImageExists`    trash_get(*self*, *ioctx*, *image_id*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.trash_get) Retrieve RBD image info from trash. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool the image is in **image_id** (*str*) -- the id of the image to restore  Returns dict - contains the following keys: `id` (str) - image id `name` (str) - image name `source` (str) - source of deletion `deletion_time` (datetime) - time of deletion `deferment_end_time` (datetime) - time that an image is allowed to be removed from trash  Raises `ImageNotFound`    trash_list(*self*, *ioctx*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.trash_list) List all entries from trash. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool the image is in Returns `TrashIterator`    trash_move(*self*, *ioctx*, *name*, *delay=0*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.trash_move) Move an RBD image to the trash. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool the image is in **name** (*str*) -- the name of the image to remove **delay** (*int*) -- time delay in seconds before the image can be deleted from trash  Raises `ImageNotFound`    trash_purge(*self*, *ioctx*, *expire_ts=None*, *threshold=- 1*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.trash_purge) Delete RBD images from trash in bulk. By default it removes images with deferment end time less than now. The timestamp is configurable, e.g. delete images that have expired a week ago. If the threshold is used it deletes images until X% pool usage is met. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool the image is in **expire_ts** (*datetime*) -- timestamp for images to be considered as expired (UTC) **threshold** (*float*) -- percentage of pool usage to be met (0 to 1)    trash_remove(*self*, *ioctx*, *image_id*, *force=False*, *on_progress=None*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.trash_remove) Delete an RBD image from trash. If image deferment time has not expired `PermissionError` is raised. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool the image is in **image_id** (*str*) -- the id of the image to remove **force** (*bool*) -- force remove even if deferment time has not expired **on_progress** (*callback function*) -- optional progress callback function  Raises `ImageNotFound`, `PermissionError`    trash_restore(*self*, *ioctx*, *image_id*, *name*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.trash_restore) Restore an RBD image from trash. Parameters **ioctx** (`rados.Ioctx`) -- determines which RADOS pool the image is in **image_id** (*str*) -- the id of the image to restore **name** (*str*) -- the new name of the restored image  Raises `ImageNotFound`    version(*self*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.RBD.version) Get the version number of the `librbd` C library. Returns a tuple of `(major, minor, extra)` components of the librbd version

- *class* rbd.SnapIterator(*Image image*)[](https://docs.ceph.com/en/latest/rbd/api/librbdpy/#rbd.SnapIterator)

  Iterator over snapshot info for an image. Yields a dictionary containing information about a snapshot. Keys are: `id` (int) - numeric identifier of the snapshot `size` (int) - size of the image at the time of snapshot (in bytes) `name` (str) - name of the snapshot `namespace` (int) - enum for snap namespace `group` (dict) - optional for group namespace snapshots `trash` (dict) - optional for trash namespace snapshots `mirror` (dict) - optional for mirror namespace snapshots

## Cephx

当启用 cephx 身份验证时（默认情况下），必须指定用户名或 ID 以及指向包含相应密钥的密钥环的路径。还可以设置 CEPH_ARGS 环境变量，以避免重新输入这些参数。

```bash
rbd --id {user-ID} --keyring=/path/to/secret [commands]
rbd --name {username} --keyring=/path/to/secret [commands]

rbd --id admin --keyring=/etc/ceph/ceph.keyring [commands]
rbd --name client.admin --keyring=/etc/ceph/ceph.keyring [commands]
```

> Tip：
>
> 将 user 和 secret 添加到 CEPH_ARGS 环境变量中，这样就不需要每次都输入它们。

## 配置块设备

1. 在 `ceph-client` 节点上创建一个块设备 image 。

   ```bash
   rbd create foo --size 4096 [-m {mon-IP}] [-k /path/to/ceph.client.admin.keyring]
   ```

2. 在 `ceph-client` 节点上，把 image 映射为块设备。

   ```bash
   sudo rbd map foo --name client.admin [-m {mon-IP}] [-k /path/to/ceph.client.admin.keyring]
   ```

3. 在 `ceph-client` 节点上，创建文件系统后就可以使用块设备了。

   ```bash
   sudo mkfs.ext4 -m0 /dev/rbd/rbd/foo
   ```

   此命令可能耗时较长。

4. 在 `ceph-client` 节点上挂载此文件系统。

   ```bash
   sudo mkdir /mnt/ceph-block-device
   sudo mount /dev/rbd/rbd/foo /mnt/ceph-block-device
   cd /mnt/ceph-block-device
   ```
