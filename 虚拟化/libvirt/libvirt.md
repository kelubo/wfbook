# libvirt

[TOC]

## 概述

 ![](../../../Image/l/libvirt-logo.png)



libvirt 库用于与许多不同的虚拟化技术进行交互。在开始使用 libvirt 之前，最好确保硬件支持基于内核的虚拟机 （KVM） 的必要虚拟化扩展。要检查这一点，请在终端提示符下输入以下内容：

```bash
kvm-ok
```

将打印一条消息，通知 CPU 是否支持硬件虚拟化。

> **Note**:
>
> 在许多处理器支持硬件辅助虚拟化的计算机上，必须先激活 BIOS 中的选项才能启用它。

## 虚拟网络

The default virtual network configuration includes **bridging** and **iptables** rules implementing **usermode** networking.
有几种不同的方法可以允许虚拟机访问外部网络。默认虚拟网络配置包括桥接和实现用户模式网络的 iptables 规则，该规则使用 SLiRP 协议。流量通过主机接口对外部网络进行 NAT 处理。

To enable external hosts to directly access services on virtual machines a different type of *bridge* than the default needs to be configured. This allows the virtual  interfaces to connect to the outside network through the physical  interface, making them appear as normal hosts to the rest of the  network.
要使外部主机能够直接访问虚拟机上的服务，需要配置与默认类型不同的网桥。这允许虚拟接口通过物理接口连接到外部网络，使它们在网络的其余部分显示为普通主机。

There is a great example of [how to configure a bridge](https://netplan.readthedocs.io/en/latest/netplan-yaml/#properties-for-device-type-bridges) and combine it with libvirt so that guests will use it at the [netplan.io documentation](https://netplan.readthedocs.io/en/latest/).
有一个很好的例子，说明如何配置一个桥接器并将其与 libvirt 结合使用，以便来宾在 netplan.io 文档中使用它。

## 安装 libvirt

要安装必要的软件包，请在终端提示符下输入：

```bash
sudo apt update
sudo apt install qemu-kvm libvirt-daemon-system
```

This is done automatically for members of the *sudo* group, but needs to be done in addition for anyone else that should  access system-wide libvirt resources. Doing so will grant the user  access to the advanced networking options.
安装 `libvirt-daemon-system` 后，需要将用于管理虚拟机的用户添加到 libvirt 组中。这是为 sudo 组的成员自动完成的，但对于应该访问系统范围的 libvirt 资源的任何其他人，还需要这样做。这样做将授予用户对高级网络选项的访问权限。

在终端中输入：

```bash
sudo adduser $USER libvirt
```

> **Note**: 
> If the chosen user is the current user, you will need to log out and back in for the new group membership to take effect.
> 如果所选用户是当前用户，则需要注销并重新登录，新组成员身份才能生效。

现在，可以安装客户机操作系统了。安装虚拟机的过程与直接在硬件上安装操作系统的过程相同。

将需要以下其中一项：

- 一种自动安装的方法。
- 连接到物理机的键盘和显示器。
- To use cloud images which are meant to self-initialise (see [Multipass](https://ubuntu.com/server/docs/how-to-create-a-vm-with-multipass) and [UVTool](https://ubuntu.com/server/docs/create-cloud-image-vms-with-uvtool)).
  使用用于自我初始化的云映像（请参阅 Multipass 和 UVTool）。

对于虚拟机，图形用户界面 （GUI） 类似于在真实计算机上使用物理键盘和鼠标。`virt-viewer` 或 `virt-manager` 应用程序可用于使用 VNC 连接到虚拟机的控制台，而不是安装 GUI  。

## 虚拟机管理

以下部分介绍了 libvirt 本身的命令行工具 `virsh` 。但是，在不同的复杂性和功能集级别上有各种选项，例如：

- Multipass
- UVTool
- virt-* 工具
- OpenStack

## Manage VMs with `virsh` 使用 `virsh` 

There are several utilities available to manage virtual machines and libvirt. The `virsh` utility can be used from the command line. Some examples:
有几个实用程序可用于管理虚拟机和 libvirt。可以从命令行使用该 `virsh` 实用程序。一些例子：

- To list running virtual machines:
  要列出正在运行的虚拟机，请执行以下操作：

  ```console
  virsh list
  ```

- To start a virtual machine:
  要启动虚拟机，请执行以下操作：

  ```console
  virsh start <guestname>
  ```

- Similarly, to start a virtual machine at boot:
  同样，要在启动时启动虚拟机，请执行以下操作：

  ```console
  virsh autostart <guestname>
  ```

- Reboot a virtual machine with:
  使用以下命令重新引导虚拟机：

  ```console
  virsh reboot <guestname>
  ```

- The **state** of virtual machines can be saved to a file in order to be restored  later. The following will save the virtual machine state into a file  named according to the date:
  虚拟机的状态可以保存到文件中，以便以后还原。以下内容会将虚拟机状态保存到根据日期命名的文件中：

  ```console
  virsh save <guestname> save-my.state
  ```

  Once saved, the virtual machine will no longer be running.
  保存后，虚拟机将不再运行。

- A saved virtual machine can be restored using:
  可以使用以下命令还原已保存的虚拟机：

  ```console
  virsh restore save-my.state
  ```

- To shut down a virtual machine you can do:
  若要关闭虚拟机，可以执行以下操作：

  ```console
  virsh shutdown <guestname>
  ```

- A CD-ROM device can be mounted in a virtual machine by entering:
  CD-ROM设备可以通过输入以下命令挂载到虚拟机中：

  ```console
  virsh attach-disk <guestname> /dev/cdrom /media/cdrom
  ```

- To change the definition of a guest, `virsh` exposes the domain via:
  要更改来宾的定义， `virsh` 请通过以下方式公开域：

  ```console
  virsh edit <guestname>
  ```

This will allow you to edit the [XML representation that defines the guest](https://libvirt.org/formatdomain.html). When saving, it will apply format and integrity checks on these definitions.
这将允许您编辑定义客户机的 XML 表示形式。保存时，它将对这些定义应用格式和完整性检查。

Editing the XML directly certainly is the most powerful way, but also the most complex one. Tools like [Virtual Machine Manager / Viewer](https://ubuntu.com/server/docs/virtual-machine-manager#libvirt-virt-manager) can help inexperienced users to do most of the common tasks.
直接编辑 XML 当然是最强大的方法，但也是最复杂的方法。Virtual Machine Manager / Viewer等工具可以帮助没有经验的用户完成大多数常见任务。

> **Note**: 注意：
>  If `virsh` (or other `vir*` tools) connect to something other than the default `qemu-kvm`/system hypervisor, one can find alternatives for the `--connect` option using `man virsh` or the [libvirt docs](http://libvirt.org/uri.html).
> 如果 `virsh` （或其他 `vir*` 工具）连接到默认 `qemu-kvm` /system 虚拟机管理程序以外的其他内容，则可以使用 或 `man virsh` libvirt 文档找到该 `--connect` 选项的替代方案。

### `system` and `session` scope  `system` 和 `session` 范围

You can pass connection strings to `virsh` - as well as to most other tools for managing virtualisation.
您可以将连接字符串传递给 `virsh` - 以及用于管理虚拟化的大多数其他工具。

```console
virsh --connect qemu:///system
```

There are two options for the connection.
连接有两个选项。

- `qemu:///system` - connect locally as **root** to the daemon supervising QEMU and KVM domains
   `qemu:///system` - 以 root 身份本地连接到监督 QEMU 和 KVM 域的守护进程
- `qemu:///session` - connect locally as a **normal user** to their own set of QEMU and KVM domains
   `qemu:///session` - 以普通用户身份在本地连接到他们自己的一组 QEMU 和 KVM 域

The *default* was always (and still is) `qemu:///system` as that is the behavior most users are accustomed to. But there are a few benefits (and drawbacks) to `qemu:///session` to consider.
默认值始终是（现在仍然是）， `qemu:///system` 因为这是大多数用户习惯的行为。但是有一些优点（和缺点）需要 `qemu:///session` 考虑。

`qemu:///session` is per user and can – on a multi-user system – be used to separate the people.
 `qemu:///session` 是按用户计算的，并且可以在多用户系统上用于分离人员。
 Most importantly, processes run under the permissions of the user, which means no permission struggle on the just-downloaded image in your `$HOME` or the just-attached USB-stick.
最重要的是，进程在用户的权限下运行，这意味着您 `$HOME` 或刚刚连接的 U 盘中刚刚下载的图像不会遇到权限问题。

On the other hand it can’t access system resources very well, which includes network setup that is known to be hard with `qemu:///session`. It falls back to [SLiRP networking](https://en.wikipedia.org/wiki/Slirp) which is functional but slow, and makes it impossible to be reached from other systems.
另一方面，它不能很好地访问系统资源，其中包括已知很难的 `qemu:///session` 网络设置。它回退到SLiRP网络，该网络功能正常但速度较慢，并且无法从其他系统访问。

`qemu:///system` is different in that it is run by the global system-wide libvirt that can arbitrate resources as needed. But you might need to `mv` and/or `chown` files to the right places and change permissions to make them usable.
 `qemu:///system` 不同的是，它由全局系统范围的 libvirt 运行，可以根据需要对资源进行仲裁。但是，您可能需要 `mv` 和/或 `chown` 文件到正确的位置，并更改权限以使其可用。

Applications will usually decide on their primary use-case. Desktop-centric applications often choose `qemu:///session` while most solutions that involve an administrator anyway continue to default to `qemu:///system`.
应用程序通常会决定其主要用例。以桌面为中心的应用程序通常会选择 `qemu:///session` ，而大多数涉及管理员的解决方案仍会默认为 `qemu:///system` 。

## 迁移

There are different types of migration available depending on the versions of libvirt and the hypervisor being used. In general those types are:
根据 libvirt 的版本和所使用的虚拟机管理程序，有不同类型的迁移可用。通常，这些类型是：

- [Offline migration 脱机迁移](https://libvirt.org/migration.html#offline)
- [Live migration 实时迁移](https://libvirt.org/migration.html)
- [Postcopy migration 复制后迁移](http://wiki.qemu.org/Features/PostCopyLiveMigration)

There are various options to those methods, but the entry point for all of them is `virsh migrate`. Read the integrated help for more detail.
这些方法有多种选择，但所有这些方法的入口点都是 `virsh migrate` 。有关详细信息，请阅读集成帮助。

```bash
 virsh migrate --help 
```

Some useful documentation on the constraints and considerations of live migration can be found at the [Ubuntu Wiki](https://wiki.ubuntu.com/QemuKVMMigration).
可以在 Ubuntu Wiki 上找到一些关于实时迁移的约束和注意事项的有用文档。

## Device passthrough/hotplug 设备直通/热插拔

If, rather than the hotplugging described here, you want to always pass  through a device then add the XML content of the device to your static  guest XML representation via `virsh edit <guestname>`. In that case you won’t need to use *attach/detach*. There are different kinds of passthrough. Types available to you depend on your hardware and software setup.
如果您希望始终通过设备，而不是此处描述的热插拔，则通过 `virsh edit <guestname>` 将设备的 XML 内容添加到静态客户机 XML 表示形式中。在这种情况下，您无需使用附加/分离。有不同种类的直通。可用的类型取决于您的硬件和软件设置。

- USB hotplug/passthrough USB 热插拔/直通
- VF hotplug/Passthrough VF 热插拔/直通

Both kinds are handled in a very similar way and while there are various way to do it (e.g. also via QEMU monitor) driving such a change via libvirt is recommended. That way, libvirt can try to manage all sorts of  special cases for you and also somewhat masks version differences.
这两种类型的处理方式非常相似，虽然有多种方法可以做到这一点（例如，也通过 QEMU 监视器），但建议通过 libvirt 来驱动这种更改。这样，libvirt 可以尝试为您管理各种特殊情况，并在一定程度上掩盖版本差异。

In general when driving hotplug via libvirt you create an XML snippet that describes the device just as you would do in a static [guest description](https://libvirt.org/formatdomain.html). A USB device is usually identified by vendor/product ID:
通常，通过 libvirt 驱动热插拔时，您可以创建一个 XML 代码段来描述设备，就像在静态客户机描述中所做的那样。USB 设备通常由供应商/产品 ID 标识：

```xml
<hostdev mode='subsystem' type='usb' managed='yes'>
  <source>
    <vendor id='0x0b6d'/>
    <product id='0x3880'/>
  </source>
</hostdev>
```

Virtual functions are usually assigned via their PCI ID (domain, bus, slot, function).
虚拟功能通常通过其 PCI ID（域、总线、插槽、功能）进行分配。

```xml
<hostdev mode='subsystem' type='pci' managed='yes'>
  <source>
    <address domain='0x0000' bus='0x04' slot='0x10' function='0x0'/>
  </source>
</hostdev>
```

> **Note**: 注意：
>  To get the virtual function in the first place is very device dependent  and can therefore not be fully covered here. But in general it involves  setting up an IOMMU, registering via [VFIO](https://www.kernel.org/doc/Documentation/vfio.txt) and sometimes requesting a number of VFs. Here an example on ppc64el to get 4 VFs on a device:
> 首先要获得虚拟功能非常依赖于设备，因此这里不能完全涵盖。但一般来说，它涉及设置 IOMMU、通过 VFIO 注册以及有时请求多个 VF。以下是 ppc64el 上的一个示例，用于在设备上获取 4 个 VF：
>
> ```bash
> $ sudo modprobe vfio-pci
> # identify device
> $ lspci -n -s 0005:01:01.3
> 0005:01:01.3 0200: 10df:e228 (rev 10)
> # register and request VFs
> $ echo 10df e228 | sudo tee /sys/bus/pci/drivers/vfio-pci/new_id
> $ echo 4 | sudo tee /sys/bus/pci/devices/0005\:01\:00.0/sriov_numvfs
> ```

You then attach or detach the device via libvirt by relating the guest with the XML snippet.
然后，通过将客户机与 XML 代码段相关联，通过 libvirt 附加或分离设备。

```bash
virsh attach-device <guestname> <device-xml>
# Use the Device in the Guest
virsh detach-device <guestname> <device-xml>
```

## 通过 libvirt 访问 QEMU Monitor

The [QEMU Monitor](https://en.wikibooks.org/wiki/QEMU/Monitor) is the way to interact with QEMU/KVM while a guest is running. This  interface has many powerful features for experienced users. When running under libvirt, the monitor interface is bound by libvirt itself for  management purposes, but a user can still run QEMU monitor commands via  libvirt. The general syntax is `virsh qemu-monitor-command [options] [guest] 'command'`.
QEMU 监视器是在客户机运行时与 QEMU/KVM 交互的方式。对于有经验的用户，此界面具有许多强大的功能。在 libvirt  下运行时，出于管理目的，监控接口由 libvirt 本身绑定，但用户仍可以通过 libvirt 运行 QEMU 监控命令。一般语法为 `virsh qemu-monitor-command [options] [guest] 'command'` 。

Libvirt covers most use cases needed, but if you ever want/need to work around  libvirt or want to tweak very special options you can e.g. add a device  as follows:
Libvirt 涵盖了所需的大多数用例，但如果您想/需要绕过 libvirt 或想要调整非常特殊的选项，您可以添加设备，如下所示：

```bash
virsh qemu-monitor-command --hmp focal-test-log 'drive_add 0 if=none,file=/var/lib/libvirt/images/test.img,format=raw,id=disk1'
```

But since the monitor is so powerful, you can do a lot – especially for debugging purposes like showing the guest registers:
但是，由于监视器功能强大，您可以做很多事情 - 特别是对于调试目的，例如显示访客寄存器：

```bash
virsh qemu-monitor-command --hmp y-ipns 'info registers'
RAX=00ffffc000000000 RBX=ffff8f0f5d5c7e48 RCX=0000000000000000 RDX=ffffea00007571c0
RSI=0000000000000000 RDI=ffff8f0fdd5c7e48 RBP=ffff8f0f5d5c7e18 RSP=ffff8f0f5d5c7df8
[...]
```

## Huge pages 大页面

Using huge pages can help to reduce TLB pressure, page table overhead and  speed up some further memory relate actions. Furthermore by default [transparent huge pages](https://www.kernel.org/doc/Documentation/vm/transhuge.txt) are useful, but can be quite some overhead - so if it is clear that  using huge pages is preferred then making them explicit usually has some gains.
使用大页面可以帮助减少 TLB 压力、页表开销并加快一些进一步的内存相关操作。此外，默认情况下，透明的大页面很有用，但可能会有相当大的开销 - 因此，如果很明显使用大页面是首选，那么明确使用它们通常会有一些好处。

While huge page are admittedly harder to manage (especially later in the  system’s lifetime if memory is fragmented) they provide a useful boost  especially for rather large guests.
诚然，大页面更难管理（尤其是在系统生命周期的后期，如果内存是碎片化的），但它们提供了一个有用的提升，特别是对于相当大的客人。

> **Bonus**: 奖金：
>  When using device passthrough on very large guests there is an extra  benefit of using huge pages as it is faster to do the initial memory  clear on VFIO DMA pin.
> 在非常大的客户机上使用设备直通时，使用大页面还有一个额外的好处，因为在 VFIO DMA 引脚上清除初始内存的速度更快。

### Huge page allocation 巨大的页面分配

Huge pages come in different sizes. A *normal* page is usually 4k and huge pages are either 2M or 1G, but depending on the architecture other options are possible.
大页面有不同的大小。普通页面通常是 4k，大页面是 2M 或 1G，但根据架构的不同，其他选项也是可能的。

The simplest yet least reliable way to allocate some huge pages is to just echo a value to `sysfs`:
分配一些大页面的最简单但最不可靠的方法是将一个值回显为 `sysfs` ：

```bash
echo 256 | sudo tee /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
```

Be sure to re-check if it worked:
请务必重新检查它是否有效：

```bash
cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

256
```

There one of these sizes is “default huge page size” which will be used in the auto-mounted `/dev/hugepages`. Changing the default size requires a reboot and is set via [default_hugepagesz](https://www.kernel.org/doc/html/v5.4/admin-guide/kernel-parameters.html).
其中一种大小是“默认大页面大小”，它将用于自动挂载 `/dev/hugepages` 。更改默认大小需要重新启动，并通过default_hugepagesz进行设置。

You can check the current default size:
您可以检查当前默认大小：

```bash
grep Hugepagesize /proc/meminfo

Hugepagesize:       2048 kB
```

But there can be more than one at the same time – so it’s a good idea to check:
但是可以同时有多个 - 因此最好检查一下：

```bash
$ tail /sys/kernel/mm/hugepages/hugepages-*/nr_hugepages` 
==> /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages <==
0
==> /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages <==
2
```

And even that could – on bigger systems – be further split per [Numa node](https://www.kernel.org/doc/html/v5.4/vm/numa.html).
甚至在更大的系统上，每个 Numa 节点都可以进一步拆分。

One can allocate huge pages at [boot or runtime](https://www.kernel.org/doc/Documentation/vm/hugetlbpage.txt), but due to fragmentation there are no guarantees it works later. The [kernel documentation](https://www.kernel.org/doc/Documentation/vm/hugetlbpage.txt) lists details on both ways.
人们可以在启动或运行时分配大页面，但由于碎片化，不能保证它以后可以工作。内核文档列出了这两种方式的详细信息。

Huge pages need to be allocated by the kernel as mentioned above but to be consumable they also have to be mounted. By default, `systemd` will make `/dev/hugepages` available for the default huge page size.
如上所述，大页面需要由内核分配，但为了使用，它们也必须挂载。默认情况下， `systemd` 将 `/dev/hugepages` 提供默认的大页面大小。

Feel free to add more mount points if you need different sized ones. An overview can be queried with:
如果您需要不同尺寸的挂载点，请随意添加更多挂载点。可以通过以下方式查询概述：

```bash
hugeadm --list-all-mounts

Mount Point          Options
/dev/hugepages       rw,relatime,pagesize=2M
```

A one-stop info for the overall huge page status of the system can be reported with:
可以通过以下方式报告系统整体大页面状态的一站式信息：

```bash
hugeadm --explain
```

### Huge page usage in libvirt libvirt 中的大量页面使用率

With the above in place, libvirt can map guest memory to huge pages. In a guest definition add the most simple form of:
有了上述条件，libvirt 就可以将客户机内存映射到大页面。在来宾定义中，添加最简单的形式：

```xml
<memoryBacking>
  <hugepages/>
</memoryBacking>
```

That will allocate the huge pages using the default huge page size from an autodetected mount point.
这将使用自动检测的挂载点的默认大页面大小来分配大页面。
 For more control, e.g. how memory is spread over [Numa nodes](https://www.kernel.org/doc/html/v5.4/vm/numa.html) or which page size to use, check out the details at the [libvirt docs](https://libvirt.org/formatdomain.html#elementsMemoryBacking).
如需更多控制，例如内存如何分布在 Numa 节点上或使用哪种页面大小，请查看 libvirt 文档中的详细信息。

## Controlling addressing bits 控制寻址位

This is a topic that rarely matters on a single computer with virtual  machines for generic use; libvirt will automatically use the hypervisor  default, which in the case of QEMU is 40 bits. This default aims for  compatibility since it will be the same on all systems, which simplifies migration between them and usually is compatible even with older  hardware.
在具有通用虚拟机的单台计算机上，这是一个很少重要的主题;libvirt 将自动使用虚拟机管理程序默认值，在 QEMU 的情况下为 40 位。此默认值旨在实现兼容性，因为它在所有系统上都是相同的，这简化了它们之间的迁移，并且通常甚至与较旧的硬件兼容。

However, it can be very important when driving more advanced use cases. If one  needs bigger guest sizes with more than a terabyte of memory then  controlling the addressing bits is crucial.
但是，在驱动更高级的用例时，它可能非常重要。如果需要更大的客户机大小和超过 1 TB 的内存，那么控制寻址位至关重要。

### -hpb machine types -HPB机器类型 （HPB machine types）

Since Ubuntu 18.04 the QEMU in Ubuntu has [provided special machine-types](https://bugs.launchpad.net/ubuntu/+source/qemu/+bug/1776189). These have been the Ubuntu machine type like `pc-q35-jammy` or `pc-i440fx-jammy` but with a `-hpb` suffix. The “hpb” abbreviation stands for “host-physical-bits”, which is the QEMU option that this represents.
从 Ubuntu 18.04 开始，Ubuntu 中的 QEMU 提供了特殊的机器类型。这些是 Ubuntu 机器类型，类似于 `pc-q35-jammy` or `pc-i440fx-jammy` 但带有 `-hpb` 后缀。“hpb”缩写代表“host-physical-bits”，这是它所代表的 QEMU 选项。

For example, by using `pc-q35-jammy-hpb` the guest would use the number of physical bits that the Host CPU has available.
例如，通过使用 `pc-q35-jammy-hpb` Guest 将使用主机 CPU 可用的物理位数。

Providing the configuration that a guest should use more address bits as a  machine type has the benefit that many higher level management stacks  like for example openstack, are already able to control it through  libvirt.
提供客户机应使用更多地址位作为机器类型的配置的好处是，许多更高级别的管理堆栈（例如 openstack）已经能够通过 libvirt 对其进行控制。

One can check the bits available to a given CPU via the procfs:
可以通过 procfs 检查给定 CPU 的可用位：

```bash
$ cat /proc/cpuinfo | grep '^address sizes'
...
# an older server with a E5-2620
address sizes   : 46 bits physical, 48 bits virtual
# a laptop with an i7-8550U
address sizes   : 39 bits physical, 48 bits virtual
```

### maxphysaddr guest configuration MaxPhysaddr 客户机配置

Since libvirt version 8.7.0 (>= Ubuntu 22.10 Lunar), `maxphysaddr` can be controlled via the [CPU model and topology section](https://libvirt.org/formatdomain.html#cpu-model-and-topology) of the guest configuration.
由于 libvirt 版本 8.7.0 （>= Ubuntu 22.10 Lunar）， `maxphysaddr` 可以通过客户机配置的 CPU 模型和拓扑部分进行控制。
 If one needs just a large guest, like before when using the `-hpb` types, all that is needed is the following libvirt guest xml configuration:
如果只需要一个大客户机，就像以前使用 `-hpb` 类型时一样，只需要以下 libvirt 客户机 xml 配置：

```auto
  <maxphysaddr mode='passthrough' />
```

Since libvirt 9.2.0 and 9.3.0 (>= Ubuntu 23.10 Mantic), an explicit number of emulated bits or a limit to the passthrough can be specified.  Combined, this pairing can be very useful for computing clusters where  the CPUs have different hardware physical addressing bits. Without these features guests could be large, but potentially unable to migrate  freely between all nodes since not all systems would support the same  amount of addressing bits.
由于 libvirt 9.2.0 和 9.3.0 （>= Ubuntu 23.10  Mantic），因此可以指定显式数量的模拟位或对直通的限制。结合在一起，这种配对对于 CPU  具有不同硬件物理寻址位的计算集群非常有用。如果没有这些功能，客户机可能会很大，但可能无法在所有节点之间自由迁移，因为并非所有系统都支持相同数量的寻址位。

But now, one can either set a fix value of addressing bits:
但是现在，可以设置寻址位的固定值：

```auto
  <maxphysaddr mode='emulate' bits='42'/>
```

Or use the best available by a given hardware, without going over a certain limit to retain some compute node compatibility.
或者使用给定硬件提供的最佳功能，而不超出特定限制，以保持某些计算节点兼容性。

```auto
  <maxphysaddr mode='passthrough' limit='41/>
```

## AppArmor isolation AppArmor 隔离

By default libvirt will spawn QEMU guests using AppArmor isolation for enhanced security. The [AppArmor rules for a guest](https://gitlab.com/apparmor/apparmor/-/wikis/Libvirt#implementation-overview) will consist of multiple elements:
默认情况下，libvirt 将使用 AppArmor 隔离生成 QEMU 客户机以增强安全性。客户机的 AppArmor 规则将由多个元素组成：

- A static part that all guests share => `/etc/apparmor.d/abstractions/libvirt-qemu`
  所有来宾共享的静态部件 => `/etc/apparmor.d/abstractions/libvirt-qemu` 
- A dynamic part created at guest start time and modified on hotplug/unplug => `/etc/apparmor.d/libvirt/libvirt-f9533e35-6b63-45f5-96be-7cccc9696d5e.files`
  在客户机启动时创建并在热插拔上修改的动态部件 => `/etc/apparmor.d/libvirt/libvirt-f9533e35-6b63-45f5-96be-7cccc9696d5e.files` 

Of the above, the former is provided and updated by the `libvirt-daemon` package and the latter is generated on guest start. Neither of the two  should be manually edited. They will, by default, cover the vast  majority of use cases and work fine. But there are certain cases where  users either want to:
其中，前者由 `libvirt-daemon` 包提供和更新，后者在客户机启动时生成。两者都不应手动编辑。默认情况下，它们将涵盖绝大多数用例并且工作正常。但在某些情况下，用户希望：

- Further lock down the guest, e.g. by explicitly denying access that usually would be allowed.
  进一步锁定访客，例如明确拒绝通常允许的访问。
- Open up the guest isolation. Most of the time this is needed if the setup on the local machine does not follow the commonly used paths.
  打开访客隔离。大多数情况下，如果本地计算机上的设置不遵循常用路径，则需要这样做。

To do so there are two files. Both are local overrides which allow you to  modify them without getting them clobbered or command file prompts on  package upgrades.
为此，有两个文件。两者都是本地覆盖，允许您修改它们，而不会在包升级时弄乱它们或命令文件提示。

- `/etc/apparmor.d/local/abstractions/libvirt-qemu`
   This will be applied to every guest. Therefore it is a rather powerful  (if blunt) tool. It is a quite useful place to add additional [deny rules](https://gitlab.com/apparmor/apparmor/-/wikis/FAQ#what-is-default-deny-white-listing).
  这将适用于每位客人。因此，它是一个相当强大（如果钝）的工具。这是添加其他拒绝规则的一个非常有用的地方。
- `/etc/apparmor.d/local/usr.lib.libvirt.virt-aa-helper`
   The above-mentioned *dynamic part* that is individual per guest is generated by a tool called `libvirt.virt-aa-helper`. That is under AppArmor isolation as well. This is most commonly used if you want to use uncommon paths as it allows one to have those uncommon  paths in the [guest XML](https://libvirt.org/formatdomain.html) (see `virsh edit`) and have those paths rendered to the per-guest dynamic rules.
  上述每个客户机的动态部分由一个名为 `libvirt.virt-aa-helper` 的工具生成。这也是在 AppArmor 隔离下。如果要使用不常见的路径，则最常使用此方法，因为它允许在客户机 XML 中包含这些不常见的路径（请参阅 `virsh edit` ），并将这些路径呈现到每个客户机的动态规则中。

## 在 Host<->Guest 之间共享文件

To be able to exchange data, the memory of the guest has to be allocated  as “shared”. To do so you need to add the following to the guest config:
为了能够交换数据，必须将客户机的内存分配为“共享”。为此，您需要将以下内容添加到客户机配置中：

```xml
<memoryBacking>
  <access mode='shared'/>
</memoryBacking>
```

For performance reasons (it helps `virtiofs`, but also is generally wise to consider) it
出于性能原因（它有帮助 `virtiofs` ，但通常也是明智的考虑）它
 is recommended to use huge pages which then would look like:
建议使用大页面，然后看起来像：

```xml
<memoryBacking>
  <hugepages>
    <page size='2048' unit='KiB'/>
  </hugepages>
  <access mode='shared'/>
</memoryBacking>
```

In the guest definition one then can add `filesytem` sections to specify host paths to share with the guest. The *target dir* is a bit special as it isn’t really a directory – instead it is a *tag* that in the guest can be used to access this particular `virtiofs` instance.
然后，在来宾定义中，可以添加 `filesytem` 部分来指定要与来宾共享的主机路径。目标目录有点特殊，因为它不是真正的目录——相反，它是一个标签，在客户机中可用于访问此特定 `virtiofs` 实例。

```xml
<filesystem type='mount' accessmode='passthrough'>
  <driver type='virtiofs'/>
  <source dir='/var/guests/h-virtiofs'/>
  <target dir='myfs'/>
</filesystem>
```

And in the guest this can now be used based on the tag `myfs` like:
在客户机中，现在可以根据以下标签 `myfs` 使用：

```bash
sudo mount -t virtiofs myfs /mnt/
```

Compared to other Host/Guest file sharing options – commonly Samba, NFS or 9P – `virtiofs` is usually much faster and also more compatible with usual file system  semantics. For some extra compatibility in regard to filesystem  semantics one can add:
与其他主机/客户机文件共享选项（通常是 Samba、NFS 或 9P）相比， `virtiofs` 通常速度更快，并且与通常的文件系统语义更兼容。对于文件系统语义的一些额外兼容性，可以添加：

```xml
<binary xattr='on'>
  <lock posix='on' flock='on'/>
</binary>
```

See the [libvirt domain/filesytem](https://libvirt.org/formatdomain.html#filesystems) documentation for further details on these.
有关这些内容的更多详细信息，请参见 libvirt domain/filesytem 文档。

> **Note**: 注意：
>  While `virtiofs` works with >=20.10 (Groovy), with >=21.04 (Hirsute) it became  more comfortable, especially in small environments (no hard requirement  to specify guest Numa topology, no hard requirement to use huge pages).  If needed to set up on 20.10 or just interested in those details - the  libvirt [knowledge-base about virtiofs](https://libvirt.org/kbase/virtiofs.html) holds more details about these.
> 虽然 `virtiofs` 适用于 >=20.10 （Groovy），但 >=21.04 （Hirsute）  它变得更加舒适，尤其是在小型环境中（没有硬性要求指定来宾 Numa 拓扑，没有硬性要求使用大页面）。如果需要在 20.10  上设置，或者只是对这些细节感兴趣 - 关于 virtiofs 的 libvirt 知识库包含有关这些细节的更多详细信息。

## Libvirt 守护程序

A libvirt deployment for accessing one of the stateful drivers will require one or more daemons to be deployed on the virtualization host. There are a number of ways the daemons can be configured which will be outlined in this page.用于访问一个有状态驱动程序的libvirt部署需要在虚拟化主机上部署一个或多个守护程序。可以通过多种方式配置守护程序，这将在本页中概述。



### 体系结构选项

#### Monolithic vs modular daemons 单片与模块化守护程序

Traditionally libvirt provided a single monolithic daemon called libvirtd which exposed support for all the stateful drivers, both primary hypervisor drivers and secondary supporting drivers. It also enables secure remote access from clients running off host.传统上，libvirt提供了一个名为libvirtd的单片守护程序，它公开了对所有有状态驱动程序的支持，包括主管理程序驱动程序和辅助支持驱动程序。它还支持从脱离主机的客户端进行安全的远程访问。

Work is underway for the monolithic daemon to be replaced by a new set of modular daemons virt${DRIVER}d, each one servicing a single stateful driver. A further virtproxyd daemon will provide secure remote access, as well as backcompatibility for clients using the UNIX socket path of the monolithic daemon.正在进行工作，将单片守护进程替换为一组新的模块化守护进程virt${DRIVER}d，每个守护进程都为一个有状态的驱动程序提供服务。另一个virtproxyd守护程序将为使用单片守护程序的UNIX套接字路径的客户端提供安全的远程访问以及向后兼容性。

The change to modular daemons should not affect API functionality used by management applications. It will, however, have an impact on host provisioning tools since there are new systemd services and configuration files to be managed.对模块化守护程序的更改不应影响管理应用程序使用的API功能。但是，这将对主机配置工具产生影响，因为需要管理新的systemd服务和配置文件。

Currently both monolithic and modular daemons are built by default, but the RPC client still prefers connecting to the monolithic daemon. It is intended to switch the RPC client to prefer the modular daemons in the near future. At least 1 year after this switch (but not more than 2 years), the monolithic daemon will be deleted entirely.目前，默认情况下构建了单片和模块化守护程序，但RPC客户端仍然倾向于连接到单片守护程序。它打算在不久的将来将RPC客户端切换为更喜欢模块化守护进程。切换后至少1年（但不超过2年），单片守护程序将被完全删除。

#### [Operating modes](https://libvirt.org/daemons.html#id3)

The libvirt daemons, whether monolithic or modular, can often operate in two modes

- *System mode* - the daemon is running as the root user account, enabling access to its full range of functionality. A read-write connection to daemons in system mode **typically implies privileges equivalent to having a root shell**. Suitable [authentication mechanisms](https://libvirt.org/auth.html) **must be enabled** to secure it against untrustworthy clients/users.

- *Session mode* - the daemon is running as any non-root user account, providing access to a more restricted range of functionality. Only client apps/users running under **the same UID are permitted to connect**, thus a connection does not imply any elevation of privileges.

  Not all drivers support session mode and as such the corresponding modular daemon may not support running in this mode

### [Monolithic driver daemon](https://libvirt.org/daemons.html#id4)

The monolithic daemon is known as libvirtd and has historically been the default in libvirt. It is configured via the file /etc/libvirt/libvirtd.conf

#### [Monolithic sockets](https://libvirt.org/daemons.html#id5)

When running in system mode, libvirtd exposes three UNIX domain sockets, and optionally, one or two TCP sockets:

- /var/run/libvirt/libvirt-sock - the primary socket for accessing libvirt APIs, with full read-write privileges. A connection to this socket gives the client privileges that are equivalent to having a root shell. This is the socket that most management applications connect to by default.
- /var/run/libvirt/libvirt-sock-ro - the secondary socket for accessing libvirt APIs, with limited read-only privileges. A connection to this socket gives the ability to query the existence of objects and monitor some aspects of their operation. This is the socket that most management applications connect to when requesting read only mode. Typically this is what a monitoring app would use.
- /var/run/libvirt/libvirt-admin-sock - the administrative socket for controlling operation of the daemon itself (as opposed to drivers it is running). This can be used to dynamically reconfigure some aspects of the daemon and monitor/control connected clients.
- TCP 16509 - the non-TLS socket for remotely accessing the libvirt APIs, with full read-write privileges. A connection to this socket gives the client privileges that are equivalent to having a root shell. Since it does not use TLS, an [authentication mechanism](https://libvirt.org/auth.html) that provides encryption must be used. Only the GSSAPI/Kerberos mechanism is capable of satisfying this requirement. In general applications should not use this socket except for debugging in a development/test environment.
- TCP 16514 - the TLS socket for remotely accessing the libvirt APIs, with full read-write privileges. A connection to this socket gives the client privileges that are equivalent to having a root shell. Access control can be enforced either through validation of [x509 certificates](https://libvirt.org/kbase/tlscerts.html), and/or by enabling an [authentication mechanism](https://libvirt.org/auth.html).

NB, some distros will use /run instead of /var/run.

When running in session mode, libvirtd exposes two UNIX domain sockets:

- $XDG_RUNTIME_DIR/libvirt/libvirt-sock - the primary socket for accessing libvirt APIs, with full read-write privileges. A connection to this socket does not alter the privileges that the client already has. This is the socket that most management applications connect to by default.
- $XDG_RUNTIME_DIR/libvirt/libvirt-admin-sock - the administrative socket for controlling operation of the daemon itself (as opposed to drivers it is running). This can be used to dynamically reconfigure some aspects of the daemon and monitor/control connected clients.

Notice that the session mode does not have a separate read-only socket. Since the clients must be running as the same user as the daemon itself, there is not any security benefit from attempting to enforce a read-only mode.

$XDG_RUNTIME_DIR commonly points to a per-user private location on tmpfs, such as /run/user/$UID.

#### [Monolithic Systemd Integration](https://libvirt.org/daemons.html#id6)

When the libvirtd daemon is managed by systemd a number of desirable features are available, most notably socket activation.

Libvirt ships a number of unit files for controlling libvirtd:

- libvirtd.service - the main unit file for launching the libvirtd daemon in system mode. The command line arguments passed can be configured by editing /etc/sysconfig/libvirtd. This is typically only needed to control the use of the auto shutdown timeout value. It is recommended that this service unit be configured to start on boot. This is because various libvirt drivers support autostart of their objects. If it is known that autostart is not required, this unit can be left to start on demand.
- libvirtd.socket - the unit file corresponding to the main read-write UNIX socket /var/run/libvirt/libvirt-sock. This socket is recommended to be started on boot by default.
- libvirtd-ro.socket - the unit file corresponding to the main read-only UNIX socket /var/run/libvirt/libvirt-sock-ro. This socket is recommended to be started on boot by default.
- libvirtd-admin.socket - the unit file corresponding to the administrative UNIX socket /var/run/libvirt/libvirt-admin-sock. This socket is recommended to be started on boot by default.
- libvirtd-tcp.socket - the unit file corresponding to the TCP 16509 port for non-TLS remote access. This socket should not be configured to start on boot until the administrator has configured a suitable authentication mechanism.
- libvirtd-tls.socket - the unit file corresponding to the TCP 16509 port for TLS remote access. This socket should not be configured to start on boot until the administrator has deployed x509 certificates and optionally configured a suitable authentication mechanism.

NB, some distros will use /etc/default instead of /etc/sysconfig.

The socket unit files are newly introduced in 5.6.0. On newly installed hosts the UNIX socket units should be enabled by default. When upgrading an existing host from a previous version of libvirt, the socket unit files will be masked if libvirtd is currently configured to use the --listen argument, since the --listen argument is mutually exclusive with use of socket activation.

When systemd socket activation is used a number of configuration settings in libvirtd.conf are no longer honoured. Instead these settings must be controlled via the system unit files

- listen_tcp - TCP socket usage is enabled by starting the libvirtd-tcp.socket unit file.
- listen_tls - TLS socket usage is enabled by starting the libvirtd-tls.socket unit file.
- tcp_port - Port for the non-TLS TCP socket, controlled via the ListenStream parameter in the libvirtd-tcp.socket unit file.
- tls_port - Port for the TLS TCP socket, controlled via the ListenStream parameter in the libvirtd-tls.socket unit file.
- listen_addr - IP address to listen on, independently controlled via the ListenStream parameter in the libvirtd-tcp.socket  or libvirtd-tls.socket unit files.
- unix_sock_group - UNIX socket group owner, controlled via the SocketGroup parameter in the libvirtd.socket and libvirtd-ro.socket unit files
- unix_sock_ro_perms - read-only UNIX socket permissions, controlled via the SocketMode parameter in the libvirtd-ro.socket unit file
- unix_sock_rw_perms - read-write UNIX socket permissions, controlled via the SocketMode parameter in the libvirtd.socket unit file
- unix_sock_admin_perms - admin UNIX socket permissions, controlled via the SocketMode parameter in the libvirtd-admin.socket unit file
- unix_sock_dir - directory in which all UNIX sockets are created independently controlled via the ListenStream parameter in any of the libvirtd.socket, libvirtd-ro.socket and libvirtd-admin.socket unit files.

### [Modular driver daemons](https://libvirt.org/daemons.html#id7)

The modular daemons are named after the driver which they are running, with the pattern virt${DRIVER}d and will become the default in future libvirt. They are configured via the files /etc/libvirt/virt${DRIVER}d.conf

The following modular daemons currently exist for hypervisor drivers

- virtqemud - the QEMU management daemon, for running virtual machines on UNIX platforms, optionally with KVM acceleration, in either system or session mode
- virtxend - the Xen management daemon, for running virtual machines on the Xen hypervisor, in system mode only
- virtlxcd - the Linux Container management daemon, for running LXC guests in system mode only
- virtbhyved - the BHyve management daemon, for running virtual machines on FreeBSD with the BHyve hypervisor, in system mode.
- virtvboxd - the VirtualBox management daemon, for running virtual machines on UNIX platforms.

The additional modular daemons service secondary drivers

- virtinterfaced - the host NIC management daemon, in system mode only
- virtnetworkd - the virtual network management daemon, in system mode only
- virtnodedevd - the host physical device management daemon, in system mode only
- virtnwfilterd - the host firewall management daemon, in system mode only
- virtsecretd - the host secret management daemon, in system or session mode
- virtstoraged - the host storage management daemon, in system or session mode

#### [Modular Sockets](https://libvirt.org/daemons.html#id8)

When running in system mode, virt${DRIVER}d exposes three UNIX domain sockets:

- /var/run/libvirt/virt${DRIVER}d-sock - the primary socket for accessing libvirt APIs, with full read-write privileges. For many of the daemons, a connection to this socket gives the client privileges that are equivalent to having a root shell. This is the socket that most management applications connect to by default.
- /var/run/libvirt/virt${DRIVER}d-sock-ro - the secondary socket for accessing libvirt APIs, with limited read-only privileges. A connection to this socket gives the ability to query the existence of objects and monitor some aspects of their operation. This is the socket that most management applications connect to when requesting read only mode. Typically this is what a monitoring app would use.
- /var/run/libvirt/virt${DRIVER}d-admin-sock - the administrative socket for controlling operation of the daemon itself (as opposed to drivers it is running). This can be used to dynamically reconfigure some aspects of the daemon and monitor/control connected clients.

NB, some distros will use /run instead of /var/run.

When running in session mode, virt${DRIVER}d exposes two UNIX domain sockets:

- $XDG_RUNTIME_DIR/libvirt/virt${DRIVER}d-sock - the primary socket for accessing libvirt APIs, with full read-write privileges. A connection to this socket does not alter the privileges that the client already has. This is the socket that most management applications connect to by default.
- $XDG_RUNTIME_DIR/libvirt/virt${DRIVER}d-admin-sock - the administrative socket for controlling operation of the daemon itself (as opposed to drivers it is running). This can be used to dynamically reconfigure some aspects of the daemon and monitor/control connected clients.

Notice that the session mode does not have a separate read-only socket. Since the clients must be running as the same user as the daemon itself, there is not any security benefit from attempting to enforce a read-only mode.

$XDG_RUNTIME_DIR commonly points to a per-user private location on tmpfs, such as /run/user/$UID.

#### [Modular Systemd Integration](https://libvirt.org/daemons.html#id9)

When the virt${DRIVER}d daemon is managed by systemd a number of desirable features are available, most notably socket activation.

Libvirt ships a number of unit files for controlling virt${DRIVER}d:

- virt${DRIVER}d.service - the main unit file for launching the virt${DRIVER}d daemon in system mode. The command line arguments passed can be configured by editing /etc/sysconfig/virt${DRIVER}d. This is typically only needed to control the use of the auto shutdown timeout value. It is recommended that this service unit be configured to start on boot. This is because various libvirt drivers support autostart of their objects. If it is known that autostart is not required, this unit can be left to start on demand.
- virt${DRIVER}d.socket - the unit file corresponding to the main read-write UNIX socket /var/run/libvirt/virt${DRIVER}d-sock. This socket is recommended to be started on boot by default.
- virt${DRIVER}d-ro.socket - the unit file corresponding to the main read-only UNIX socket /var/run/libvirt/virt${DRIVER}d-sock-ro. This socket is recommended to be started on boot by default.
- virt${DRIVER}d-admin.socket - the unit file corresponding to the administrative UNIX socket /var/run/libvirt/virt${DRIVER}d-admin-sock. This socket is recommended to be started on boot by default.

NB, some distros will use /etc/default instead of /etc/sysconfig.

The socket unit files are newly introduced in 5.6.0. On newly installed hosts the UNIX socket units should be enabled by default. When upgrading an existing host from a previous version of libvirt, the socket unit files will be masked if virt${DRIVER}d is currently configured to use the --listen argument, since the --listen argument is mutually exclusive with use of socket activation.

When systemd socket activation is used a number of configuration settings in virt${DRIVER}d.conf are no longer honoured. Instead these settings must be controlled via the system unit files:

- unix_sock_group - UNIX socket group owner, controlled via the SocketGroup parameter in the virt${DRIVER}d.socket and virt${DRIVER}d-ro.socket unit files
- unix_sock_ro_perms - read-only UNIX socket permissions, controlled via the SocketMode parameter in the virt${DRIVER}d-ro.socket unit file
- unix_sock_rw_perms - read-write UNIX socket permissions, controlled via the SocketMode parameter in the virt${DRIVER}d.socket unit file
- unix_sock_admin_perms - admin UNIX socket permissions, controlled via the SocketMode parameter in the virt${DRIVER}d-admin.socket unit file
- unix_sock_dir - directory in which all UNIX sockets are created independently controlled via the ListenStream parameter in any of the virt${DRIVER}d.socket, virt${DRIVER}d-ro.socket and virt${DRIVER}d-admin.socket unit files.

#### [Switching to modular daemons](https://libvirt.org/daemons.html#id10)

If a host is currently set to use the monolithic libvirtd daemon and needs to be migrated to the modular daemons a number of services need to be changed. The steps below outline the process on hosts using the systemd init service.

While it is technically possible to do this while virtual machines are running, it is recommended that virtual machines be stopped or live migrated to a new host first.

1. Stop the current monolithic daemon and its socket units

   ```
   $ systemctl stop libvirtd.service
   $ systemctl stop libvirtd{,-ro,-admin,-tcp,-tls}.socket
   ```

2. Disable future start of the monolithic daemon

   ```
   $ systemctl disable libvirtd.service
   $ systemctl disable libvirtd{,-ro,-admin,-tcp,-tls}.socket
   ```

   For stronger protection it is valid to use mask instead of disable too.

3. Enable the new daemons for the particular virtualizationd driver desired, and any of the secondary drivers to accompany it. The following example enables the QEMU driver and all the secondary drivers:

   ```
   $ for drv in qemu interface network nodedev nwfilter secret storage
     do
       systemctl unmask virt${drv}d.service
       systemctl unmask virt${drv}d{,-ro,-admin}.socket
       systemctl enable virt${drv}d.service
       systemctl enable virt${drv}d{,-ro,-admin}.socket
     done
   ```

4. Start the sockets for the same set of daemons. There is no need to start the services as they will get started when the first socket connection is established

   ```
   $ for drv in qemu network nodedev nwfilter secret storage
     do
       systemctl start virt${drv}d{,-ro,-admin}.socket
     done
   ```

5. If connections from remote hosts need to be supported the proxy daemon must be enabled and started

   ```
   $ systemctl unmask virtproxyd.service
   $ systemctl unmask virtproxyd{,-ro,-admin}.socket
   $ systemctl enable virtproxyd.service
   $ systemctl enable virtproxyd{,-ro,-admin}.socket
   $ systemctl start virtproxyd{,-ro,-admin}.socket
   ```

   The UNIX sockets allow for remote access using SSH tunneling. If libvirtd had TCP or TLS sockets configured, those should be started too

   ```
   $ systemctl unmask virtproxyd-tls.socket
   $ systemctl enable virtproxyd-tls.socket
   $ systemctl start virtproxyd-tls.socket
   ```

### [Checking whether modular/monolithic mode is in use](https://libvirt.org/daemons.html#id11)

New distributions are likely to use the modular mode although the upgrade process preserves whichever mode was in use before the upgrade.

To determine whether modular or monolithic mode is in use on a host running systemd as the init system you can take the following steps:

1. Check whether the modular daemon infrastructure is in use

   First check whether the modular daemon you are interested (see [Modular driver daemons](https://libvirt.org/daemons.html#modular-driver-daemons) for a summary of which daemons are provided by libvirt) in is running:

   1. Check .socket for socket activated services

   > ```
   > # systemctl is-active virtqemud.socket
   > active
   > ```

   1. Check .service for always-running daemons

   > ```
   > # systemctl is-active virtqemud.service
   > active
   > ```

   If either of the above is active your system is using the modular daemons.

2. Check whether the monolithic daemon is in use

   1. Check libvirtd.socket

   > ```
   > # systemctl is-active libvirtd.socket
   > active
   > ```

   1. Check libvirtd.service for always-running daemon

   > ```
   > # systemctl is-active libvirtd.service
   > active
   > ```

   If either of the above is active your system is using the monolithic daemon.

3. To determine which of the above will be in use on the next boot of the system, substitute is-enabled for is-active in the above examples.

### [Proxy daemon](https://libvirt.org/daemons.html#id12)

#### [Proxy sockets](https://libvirt.org/daemons.html#id13)

When running in system mode, virtproxyd exposes three UNIX domain sockets, and optionally, one or two TCP sockets. These sockets are identical to those provided by the traditional libvirtd so refer to earlier documentation in this page.

When running in session mode, virtproxyd exposes two UNIX domain sockets, which are again identical to those provided by libvirtd.

#### [Proxy Systemd Integration](https://libvirt.org/daemons.html#id14)

When the virtproxyd daemon is managed by systemd a number of desirable features are available, most notably socket activation.

Libvirt ships a number of unit files for controlling virtproxyd:

- virtproxyd.service - the main unit file for launching the virtproxyd daemon in system mode. The command line arguments passed can be configured by editing /etc/sysconfig/virtproxyd. This is typically only needed to control the use of the auto shutdown timeout value.
- virtproxyd.socket - the unit file corresponding to the main read-write UNIX socket /var/run/libvirt/libvirt-sock. This socket is recommended to be started on boot by default.
- virtproxyd-ro.socket - the unit file corresponding to the main read-only UNIX socket /var/run/libvirt/libvirt-sock-ro. This socket is recommended to be started on boot by default.
- virtproxyd-admin.socket - the unit file corresponding to the administrative UNIX socket /var/run/libvirt/libvirt-admin-sock. This socket is recommended to be started on boot by default.
- virtproxyd-tcp.socket - the unit file corresponding to the TCP 16509 port for non-TLS remote access. This socket should not be configured to start on boot until the administrator has configured a suitable authentication mechanism.
- virtproxyd-tls.socket - the unit file corresponding to the TCP 16509 port for TLS remote access. This socket should not be configured to start on boot until the administrator has deployed x509 certificates and optionally configured a suitable authentication mechanism.

NB, some distros will use /etc/default instead of /etc/sysconfig.

The socket unit files are newly introduced in 5.6.0. On newly installed hosts the UNIX socket units should be enabled by default. When upgrading an existing host from a previous version of libvirt, the socket unit files will be masked if virtproxyd is currently configured to use the --listen argument, since the --listen argument is mutually exclusive with use of socket activation.

When systemd socket activation is used a number of configuration settings in virtproxyd.conf are no longer honoured. Instead these settings must be controlled via the system unit files. Refer to the earlier documentation on the libvirtd service socket configuration for further information.

### [Logging daemon](https://libvirt.org/daemons.html#id15)

The virtlogd daemon provides a service for managing log files associated with QEMU virtual machines. The QEMU process is given one or more pipes, the other end of which are owned by the virtlogd daemon. It will then write data on those pipes to log files, while enforcing a maximum file size and performing log rollover at the size limit.

Since the daemon holds open anonymous pipe file descriptors, it must never be stopped while any QEMU virtual machines are running. To enable software updates to be applied, the daemon is capable of re-executing itself while keeping all file descriptors open. This can be triggered by sending the daemon SIGUSR1

#### [Logging Sockets](https://libvirt.org/daemons.html#id16)

When running in system mode, virtlogd exposes two UNIX domain sockets:

- /var/run/libvirt/virtlogd-sock - the primary socket for accessing libvirt APIs, with full read-write privileges. Access to the socket is restricted to the root user.
- /var/run/libvirt/virtlogd-admin-sock - the administrative socket for controlling operation of the daemon itself (as opposed to drivers it is running). This can be used to dynamically reconfigure some aspects of the daemon and monitor/control connected clients.

NB, some distros will use /run instead of /var/run.

When running in session mode, virtlogd exposes two UNIX domain sockets:

- $XDG_RUNTIME_DIR/libvirt/virtlogd-sock - the primary socket for accessing libvirt APIs, with full read-write privileges. Access to the socket is restricted to the unprivileged user running the daemon.
- $XDG_RUNTIME_DIR/libvirt/virtlogd-admin-sock - the administrative socket for controlling operation of the daemon itself (as opposed to drivers it is running). This can be used to dynamically reconfigure some aspects of the daemon and monitor/control connected clients.

$XDG_RUNTIME_DIR commonly points to a per-user private location on tmpfs, such as /run/user/$UID.

#### [Logging Systemd Integration](https://libvirt.org/daemons.html#id17)

When the virtlogd daemon is managed by systemd a number of desirable features are available, most notably socket activation.

Libvirt ships a number of unit files for controlling virtlogd:

- virtlogd.service - the main unit file for launching the virtlogd daemon in system mode. The command line arguments passed can be configured by editing /etc/sysconfig/virtlogd. This is typically only needed to control the use of the auto shutdown timeout value.
- virtlogd.socket - the unit file corresponding to the main read-write UNIX socket /var/run/libvirt/virtlogd-sock. This socket is recommended to be started on boot by default.
- virtlogd-admin.socket - the unit file corresponding to the administrative UNIX socket /var/run/libvirt/virtlogd-admin-sock. This socket is recommended to be started on boot by default.

NB, some distros will use /etc/default instead of /etc/sysconfig.

When systemd socket activation is used a number of configuration settings in virtlogd.conf are no longer honoured. Instead these settings must be controlled via the system unit files:

- unix_sock_group - UNIX socket group owner, controlled via the SocketGroup parameter in the virtlogd.socket and virtlogd-ro.socket unit files
- unix_sock_ro_perms - read-only UNIX socket permissions, controlled via the SocketMode parameter in the virtlogd-ro.socket unit file
- unix_sock_rw_perms - read-write UNIX socket permissions, controlled via the SocketMode parameter in the virtlogd.socket unit file
- unix_sock_admin_perms - admin UNIX socket permissions, controlled via the SocketMode parameter in the virtlogd-admin.socket unit file
- unix_sock_dir - directory in which all UNIX sockets are created independently controlled via the ListenStream parameter in any of the virtlogd.socket and virtlogd-admin.socket unit files.

### [Locking daemon](https://libvirt.org/daemons.html#id18)

The virtlockd daemon provides a service for holding locks against file images and devices serving as backing storage for virtual disks. The locks will be held for as long as there is a QEMU process running with the disk open.

To ensure continuity of locking, the daemon holds open anonymous file descriptors, it must never be stopped while any QEMU virtual machines are running. To enable software updates to be applied, the daemon is capable of re-executing itself while keeping all file descriptors open. This can be triggered by sending the daemon SIGUSR1

#### [Locking Sockets](https://libvirt.org/daemons.html#id19)

When running in system mode, virtlockd exposes two UNIX domain sockets:

- /var/run/libvirt/virtlockd-sock - the primary socket for accessing libvirt APIs, with full read-write privileges. Access to the socket is restricted to the root user.
- /var/run/libvirt/virtlockd-admin-sock - the administrative socket for controlling operation of the daemon itself (as opposed to drivers it is running). This can be used to dynamically reconfigure some aspects of the daemon and monitor/control connected clients.

NB, some distros will use /run instead of /var/run.

When running in session mode, virtlockd exposes two UNIX domain sockets:

- $XDG_RUNTIME_DIR/libvirt/virtlockd-sock - the primary socket for accessing libvirt APIs, with full read-write privileges. Access to the socket is restricted to the unprivileged user running the daemon.
- $XDG_RUNTIME_DIR/libvirt/virtlockd-admin-sock - the administrative socket for controlling operation of the daemon itself (as opposed to drivers it is running). This can be used to dynamically reconfigure some aspects of the daemon and monitor/control connected clients.

$XDG_RUNTIME_DIR commonly points to a per-user private location on tmpfs, such as /run/user/$UID.

#### [Locking Systemd Integration](https://libvirt.org/daemons.html#id20)

When the virtlockd daemon is managed by systemd a number of desirable features are available, most notably socket activation.

Libvirt ships a number of unit files for controlling virtlockd:

- virtlockd.service - the main unit file for launching the virtlockd daemon in system mode. The command line arguments passed can be configured by editing /etc/sysconfig/virtlockd. This is typically only needed to control the use of the auto shutdown timeout value.
- virtlockd.socket - the unit file corresponding to the main read-write UNIX socket /var/run/libvirt/virtlockd-sock. This socket is recommended to be started on boot by default.
- virtlockd-admin.socket - the unit file corresponding to the administrative UNIX socket /var/run/libvirt/virtlockd-admin-sock. This socket is recommended to be started on boot by default.

NB, some distros will use /etc/default instead of /etc/sysconfig.

When systemd socket activation is used a number of configuration settings in virtlockd.conf are no longer honoured. Instead these settings must be controlled via the system unit files:

- unix_sock_group - UNIX socket group owner, controlled via the SocketGroup parameter in the virtlockd.socket and virtlockd-ro.socket unit files
- unix_sock_ro_perms - read-only UNIX socket permissions, controlled via the SocketMode parameter in the virtlockd-ro.socket unit file
- unix_sock_rw_perms - read-write UNIX socket permissions, controlled via the SocketMode parameter in the virtlockd.socket unit file
- unix_sock_admin_perms - admin UNIX socket permissions, controlled via the SocketMode parameter in the virtlockd-admin.socket unit file
- unix_sock_dir - directory in which all UNIX sockets are created independently controlled via the ListenStream parameter in any of the virtlockd.socket and virtlockd-admin.socket unit files.

### [Changing command line options for daemons](https://libvirt.org/daemons.html#id21)

Two ways exist to override the defaults in the provided service files: either a systemd "drop-in" configuration file, or a /etc/sysconfig/$daemon file must be created.  For example, to change the command line option for a debug session of libvirtd, create a file /etc/systemd/system/libvirtd.service.d/debug.conf with the following content:

> ```
> [Unit]
> Description=Virtualization daemon, with override from debug.conf
> 
> [Service]
> Environment=G_DEBUG=fatal-warnings
> Environment=LIBVIRTD_ARGS="--listen --verbose"
> ```

After changes to systemd "drop-in" configuration files it is required to run systemctl daemon-reload.

## 虚拟机迁移

虚拟机在宿主机之间的迁移是一个复杂的问题，有许多可能的解决方案，每个方案都有其积极和消极的方面。For maximum flexibility of both hypervisor integration, and administrator deployment, libvirt implements several options for migration.为了实现管理程序集成和管理员部署的最大灵活性，libvirt 实现了几个迁移选项。

### 网络数据传输

迁移期间使用的数据传输有两种选择，一种是管理程序自己的本地传输（ hypervisor's own **native** transport），另一种是通过 libvirtd 连接进行隧道传输（ **tunnelled** over a libvirtd connection）。

#### Hypervisor native transport

*Native* data transports may or may not support encryption, depending on the hypervisor in question, but will typically have the lowest computational costs by minimising the number of data copies involved. The native data transports will also require extra hypervisor-specific network configuration steps by the administrator when deploying a host. For some hypervisors, it might be necessary to open up a large range of ports on the firewall to allow multiple concurrent migration operations.本机数据传输可能支持加密，也可能不支持加密，具体取决于所讨论的虚拟机管理程序，但通常通过最小化所涉及的数据副本数量来实现最低的计算成本。在部署主机时，本地数据传输还需要管理员执行额外的管理程序特定网络配置步骤。对于某些管理程序，可能需要在防火墙上打开大量端口，以允许多个并发迁移操作。

Modern hypervisors support TLS for encryption and authentication of the migration connections which can be enabled using the VIR_MIGRATE_TLS flag. The *qemu* hypervisor driver allows users to force use of TLS via the migrate_tls_force knob configured in /etc/libvirt/qemu.conf.

现代虚拟机监控程序支持TLS来加密和验证迁移连接，可以使用VIR MIGRATE TLS标志启用。qemu管理程序驱动程序允许用户通过/etc/libvirt/qemu.conf中配置的迁移TLS强制旋钮强制使用TLS。

 ![](../../../Image/m/migration-native.png)

#### libvirt tunnelled transport

*Tunnelled* data transports will always be capable of strong encryption since they are able to leverage the capabilities built in to the libvirt RPC protocol. The downside of a tunnelled transport, however, is that there will be extra data copies involved on both the source and destinations hosts as the data is moved between libvirtd and the hypervisor. This is likely to be a more significant problem for guests with very large RAM sizes, which dirty memory pages quickly. On the deployment side, tunnelled transports do not require any extra network configuration over and above what's already required for general libvirtd [remote access](https://libvirt.org/remote.html), and there is only need for a single port to be open on the firewall to support multiple concurrent migration operations.

隧道数据传输将始终能够进行强加密，因为它们能够利用libvirt  RPC协议中内置的功能。然而，隧道传输的缺点是，当数据在libvirtd和hypervisor之间移动时，源主机和目标主机上都会有额外的数据副本。对于拥有非常大的RAM大小的客户来说，这可能是一个更严重的问题，因为它会很快弄脏内存页。在部署端，隧道传输不需要任何超出常规libvirtd远程访问所需的额外网络配置，并且只需要在防火墙上打开一个端口即可支持多个并发迁移操作。

> **Note:**
>
> Certain features such as migration of non-shared storage (VIR_MIGRATE_NON_SHARED_DISK), the multi-connection migration (VIR_MIGRATE_PARALLEL), or post-copy migration (VIR_MIGRATE_POSTCOPY) may not be available when using libvirt's tunnelling.
>
> 使用libvirt的隧道传输时，某些功能（如非共享存储迁移（VIR MIGRATE non shared DISK）、多连接迁移（VIL MIGRATE PARALLEL）或复制后迁移（VIV MIGRATE POSTCOPY））可能不可用。

 ![](../../../Image/m/migration-tunnel.png)

### Communication control paths/flows 通信控制路径/流程

Migration of virtual machines requires close co-ordination of the two hosts involved, as well as the application invoking the migration, which may be on the source, the destination, or a third host.

虚拟机的迁移需要所涉及的两个主机以及调用迁移的应用程序的密切协调，迁移可能位于源、目标或第三个主机上。

#### Managed direct migration 托管直接迁移

With *managed direct* migration, the libvirt client process controls the various phases of migration. The client application must be able to connect and authenticate with the libvirtd daemons on both the source and destination hosts. There is no need for the two libvirtd daemons to communicate with each other. If the client application crashes, or otherwise loses its connection to libvirtd during the migration process, an attempt will be made to abort the migration and restart the guest CPUs on the source host. There may be scenarios where this cannot be safely done, in which cases the guest will be left paused on one or both of the hosts.

通过托管直接迁移，libvirt客户端进程控制迁移的各个阶段。客户端应用程序必须能够连接源主机和目标主机上的libvirtd守护程序并进行身份验证。两个libvirtd守护进程不需要彼此通信。如果客户端应用程序在迁移过程中崩溃，或者失去与libvirtd的连接，将尝试中止迁移并重新启动源主机上的来宾CPU。在某些情况下，这可能无法安全完成，在这种情况下，客人将在一个或两个主机上暂停。

 ![](../../../Image/m/migration-managed-direct.png)

#### Managed peer to peer migration 受管理的对等迁移

With *peer to peer* migration, the libvirt client process only talks to the libvirtd daemon on the source host. The source libvirtd daemon controls the entire migration process itself, by directly connecting the destination host libvirtd. If the client application crashes, or otherwise loses its connection to libvirtd, the migration process will continue uninterrupted until completion. Note that the source libvirtd uses its own credentials (typically root) to connect to the destination, rather than the credentials used by the client to connect to the source; if these differ, it is common to run into a situation where a client can connect to the destination directly but the source cannot make the connection to set up the peer-to-peer migration.

通过对等迁移，libvirt客户端进程只与源主机上的libvirtd守护进程进行通信。源libvirtd守护程序通过直接连接目标主机libvirtd来控制整个迁移过程本身。如果客户端应用程序崩溃，或以其他方式失去与libvirtd的连接，迁移过程将不间断地继续，直到完成。注意，源libvirtd使用自己的凭据（通常是root）连接到目标，而不是客户端用于连接到源的凭据；如果两者不同，通常会遇到这样的情况：客户端可以直接连接到目的地，但源无法建立连接以设置对等迁移。

 ![](../../../Image/m/migration-managed-p2p.png)

#### Unmanaged direct migration 非托管直接迁移

With *unmanaged direct* migration, neither the libvirt client or libvirtd daemon control the migration process. Control is instead delegated to the hypervisor's over management services (if any). The libvirt client merely initiates the migration via the hypervisor's management layer. If the libvirt client or libvirtd crash, the migration process will continue uninterrupted until completion.

对于非托管直接迁移，libvirt客户端或libvirtd守护程序都无法控制迁移过程。而是将控制权委托给管理程序的管理服务（如果有的话）。libvirt客户端仅通过管理程序的管理层启动迁移。如果libvirt客户端或libvirtd崩溃，迁移过程将不间断地继续，直到完成。

 ![](../../../Image/m/migration-unmanaged-direct.png)

### 数据安全

Since the migration data stream includes a complete copy of the guest OS RAM, snooping of the migration data stream may allow compromise of sensitive guest information. If the virtualization hosts have multiple network interfaces, or if the network switches support tagged VLANs, then it is very desirable to separate guest network traffic from migration or management traffic.

由于迁移数据流包括访客OS RAM的完整副本，所以对迁移数据流的窥探可能允许泄露敏感的访客信息。如果虚拟化主机具有多个网络接口，或者如果网络交换机支持标记的VLAN，那么非常希望将客户网络流量与迁移或管理流量分开。

In some scenarios, even a separate network for migration data may not offer sufficient security. In this case it is possible to apply encryption to the migration data stream. If the hypervisor does not itself offer encryption, then the libvirt tunnelled migration facility should be used.

在某些情况下，即使是用于迁移数据的单独网络也可能无法提供足够的安全性。在这种情况下，可以对迁移数据流应用加密。如果管理程序本身不提供加密，则应使用libvirt隧道迁移工具。

### Offline migration 脱机迁移

Offline migration transfers the inactive definition of a domain (which may or may not be active). After successful completion, the domain remains in its current state on the source host and is defined but inactive on the destination host. It's a bit more clever than virsh dumpxml on source host followed by virsh define on destination host, as offline migration will run the pre-migration hook to update the domain XML on destination host. Currently, copying non-shared storage or other file based storages (e.g. UEFI variable storage) is not supported during offline migration.

脱机迁移传输域的非活动定义（可能是活动的，也可能不是活动的）。成功完成后，域在源主机上保持当前状态，并且在目标主机上已定义但处于非活动状态。它比源主机上的virsh-dumpxml和目标主机上的virsh-define更聪明，因为离线迁移将运行迁移前挂钩来更新目标主机上域XML。当前，离线迁移期间不支持复制非共享存储或其他基于文件的存储（例如UEFI变量存储）。

### Migration URIs  迁移URI

Initiating a guest migration requires the client application to specify up to three URIs, depending on the choice of control flow and/or APIs used. The first URI is that of the libvirt connection to the source host, where the virtual guest is currently running. The second URI is that of the libvirt connection to the destination host, where the virtual guest will be moved to (and in peer-to-peer migrations, this is from the perspective of the source, not the client). The third URI is a hypervisor specific URI used to control how the guest will be migrated. With any managed migration flow, the first and second URIs are compulsory, while the third URI is optional. With the unmanaged direct migration mode, the first and third URIs are compulsory and the second URI is not used.

启动来宾迁移需要客户端应用程序指定最多三个URI，具体取决于所使用的控制流和/或API的选择。第一个URI是到源主机的libvirt连接的URI，虚拟来宾当前正在该主机上运行。第二个URI是到目标主机的libvirt连接的URI，虚拟客户机将被移动到目标主机（在对等迁移中，这是从源的角度，而不是从客户端的角度）。第三个URI是管理程序特定的URI，用于控制如何迁移来宾。对于任何托管迁移流，第一个和第二个URI是必需的，而第三个URI是可选的。对于非托管直接迁移模式，第一个和第三个URI是必需的，第二个URI不使用。

Ordinarily management applications only need to care about the first and second URIs, which are both in the normal libvirt connection URI format. Libvirt will then automatically determine the hypervisor specific URI, by looking up the target host's configured hostname. There are a few scenarios where the management application may wish to have direct control over the third URI.

通常，管理应用程序只需要关心第一个和第二个URI，它们都是正常的libvirt连接URI格式。然后，Libvirt将通过查找目标主机的配置主机名来自动确定虚拟机管理程序特定的URI。在一些情况下，管理应用程序可能希望直接控制第三URI。

1. The configured hostname is incorrect, or DNS is broken. If a host has a hostname which will not resolve to match one of its public IP addresses, then libvirt will generate an incorrect URI. In this case the management application should specify the hypervisor specific URI explicitly, using an IP address, or a correct hostname.
2. 配置的主机名不正确，或者DNS已损坏。如果主机名无法解析为与其公共IP地址之一匹配，则libvirt将生成不正确的URI。在这种情况下，管理应用程序应该使用IP地址或正确的主机名显式指定管理程序特定的URI。
3. The host has multiple network interfaces. If a host has multiple network interfaces, it might be desirable for the migration data stream to be sent over a specific interface for either security or performance reasons. In this case the management application should specify the hypervisor specific URI, using an IP address associated with the network to be used.
4. 主机具有多个网络接口。如果主机具有多个网络接口，出于安全或性能原因，可能需要通过特定接口发送迁移数据流。在这种情况下，管理应用程序应使用与要使用的网络相关联的IP地址指定管理程序特定的URI。
5. The firewall restricts what ports are available. When libvirt generates a migration URI it will pick a port number using hypervisor specific rules. Some hypervisors only require a single port to be open in the firewalls, while others require a whole range of port numbers. In the latter case the management application may wish to choose a specific port number outside the default range in order to comply with local firewall policies.
6. 防火墙限制可用的端口。当libvirt生成迁移URI时，它将使用管理程序特定的规则选择端口号。一些虚拟机监控程序只需要在防火墙中打开一个端口，而另一些则需要一系列端口号。在后一种情况下，管理应用程序可能希望选择默认范围之外的特定端口号，以便遵守本地防火墙策略。
7. The second URI uses UNIX transport method. In this advanced case libvirt should not guess a *migrateuri* and it should be specified using UNIX socket path URI: unix:///path/to/socket.
8. 第二个URI使用UNIX传输方法。在这种高级情况下，libvirt不应该猜测*migrateuri*，应该使用UNIX套接字路径URI指定它：unix:///path/to/socket.

### Configuration file handling 配置文件处理

There are two types of virtual machines known to libvirt. A *transient* guest only exists while it is running, and has no configuration file stored on disk. A *persistent* guest maintains a configuration file on disk even when it is not running.libvirt已知有两种类型的虚拟机。临时来宾仅在运行时存在，磁盘上没有存储任何配置文件。持久客户机在磁盘上维护配置文件，即使它没有运行。

By default, a migration operation will not attempt to modify any configuration files that may be stored on either the source or destination host. It is the administrator, or management application's, responsibility to manage distribution of configuration files (if desired). It is important to note that the /etc/libvirt directory **MUST NEVER BE SHARED BETWEEN HOSTS**. There are some typical scenarios that might be applicable:默认情况下，迁移操作不会尝试修改可能存储在源主机或目标主机上的任何配置文件。管理员或管理应用程序负责管理配置文件的分发（如果需要）。需要注意的是，主机之间绝对不能共享/etc/libvirt目录。有一些典型的场景可能适用：

- Centralized configuration files outside libvirt, in shared storage. A cluster aware management application may maintain all the master guest configuration files in a cluster filesystem. When attempting to start a guest, the config will be read from the cluster FS and used to deploy a persistent guest. For migration the configuration will need to be copied to the destination host and removed on the original.在libvirt之外的共享存储中集中配置文件。集群感知管理应用程序可以在集群文件系统中维护所有主客户机配置文件。当尝试启动来宾时，将从集群FS中读取配置并用于部署持久来宾。对于迁移，需要将配置复制到目标主机并从原始主机上删除。
- Centralized configuration files outside libvirt, in a database. A data center management application may not store configuration files at all. Instead it may generate libvirt XML on the fly when a guest is booted. It will typically use transient guests, and thus not have to consider configuration files during migration.数据库中libvirt外部的集中配置文件。数据中心管理应用程序可能根本不存储配置文件。相反，它可以在引导来宾时动态生成libvirt XML。它通常使用临时来宾，因此在迁移期间不必考虑配置文件。
- Distributed configuration inside libvirt. The configuration file for each guest is copied to every host where the guest is able to run. Upon migration the existing config merely needs to be updated with any changes.libvirt内部的分布式配置。将每个来宾的配置文件复制到来宾能够运行的每个主机。迁移后，只需使用任何更改来更新现有配置。
- Ad-hoc configuration management inside libvirt. Each guest is tied to a specific host and rarely migrated. When migration is required, the config is moved from one host to the other.libvirt内部的特殊配置管理。每个来宾都绑定到特定的主机，很少迁移。当需要迁移时，配置将从一个主机移动到另一个主机。

As mentioned above, libvirt will not modify configuration files during migration by default. The virsh command has two flags to influence this behaviour. The --undefinesource flag will cause the configuration file to be removed on the source host after a successful migration. The --persistent flag will cause a configuration file to be created on the destination host after a successful migration. The following table summarizes the configuration file handling in all possible state and flag combinations.

如上所述，默认情况下，libvirt不会在迁移期间修改配置文件。virsh命令有两个标志来影响此行为。--undefinesource标志将导致在成功迁移后在源主机上删除配置文件。成功迁移后，--persistent标志将导致在目标主机上创建配置文件。下表总结了所有可能的状态和标志组合中的配置文件处理。

| 迁移前      |               |             | Flags            |              | 迁移后     |               |                           |
| ----------- | ------------- | ----------- | ---------------- | ------------ | ---------- | ------------- | ------------------------- |
| Source type | Source config | Dest config | --undefinesource | --persistent | Dest type  | Source config | Dest config               |
| Transient   | N             | N           | N                | N            | Transient  | N             | N                         |
| Transient   | N             | N           | Y                | N            | Transient  | N             | N                         |
| Transient   | N             | N           | N                | Y            | Persistent | N             | Y                         |
| Transient   | N             | N           | Y                | Y            | Persistent | N             | Y                         |
| Transient   | N             | Y           | N                | N            | Persistent | N             | Y (unchanged dest config) |
| Transient   | N             | Y           | Y                | N            | Persistent | N             | Y (unchanged dest config) |
| Transient   | N             | Y           | N                | Y            | Persistent | N             | Y (replaced with source)  |
| Transient   | N             | Y           | Y                | Y            | Persistent | N             | Y (replaced with source)  |
| Persistent  | Y             | N           | N                | N            | Transient  | Y             | N                         |
| Persistent  | Y             | N           | Y                | N            | Transient  | N             | N                         |
| Persistent  | Y             | N           | N                | Y            | Persistent | Y             | Y                         |
| Persistent  | Y             | N           | Y                | Y            | Persistent | N             | Y                         |
| Persistent  | Y             | Y           | N                | N            | Persistent | Y             | Y (unchanged dest config) |
| Persistent  | Y             | Y           | Y                | N            | Persistent | N             | Y (unchanged dest config) |
| Persistent  | Y             | Y           | N                | Y            | Persistent | Y             | Y (replaced with source)  |
| Persistent  | Y             | Y           | Y                | Y            | Persistent | N             | Y (replaced with source)  |

### 迁移方案

#### Native migration, client to two libvirtd servers

At an API level this requires use of virDomainMigrate, without the VIR_MIGRATE_PEER2PEER flag set. The destination libvirtd server will automatically determine the native hypervisor URI for migration based off the primary hostname. To force migration over an alternate network interface the optional hypervisor specific URI must be provided

在API级别，这需要使用vir-Domain Migrate，而不设置vir Migrate PEER2PEER标志。目标libvirtd服务器将根据主主机名自动确定用于迁移的本机管理程序URI。要通过备用网络接口强制迁移，必须提供可选的管理程序特定URI

```bash
virsh migrate GUESTNAME DEST-LIBVIRT-URI [HV-URI]


#eg using default network interface

virsh migrate web1 qemu+ssh://desthost/system
virsh migrate web1 xen+tls://desthost/system


#eg using secondary network interface

virsh migrate web1 qemu://desthost/system tcp://10.0.0.1/
```

Supported by Xen, QEMU, VMware and VirtualBox drivers

由Xen、QEMU、VMware和Virtual Box驱动程序支持

#### Native migration, client to and peer2peer between, two libvirtd servers
virDomainMigrate, with the VIR_MIGRATE_PEER2PEER flag set, using the libvirt URI format for the 'uri' parameter. The destination libvirtd server will automatically determine the native hypervisor URI for migration, based off the primary hostname. The optional uri parameter controls how the source libvirtd connects to the destination libvirtd, in case it is not accessible using the same address that the client uses to connect to the destination, or a different encryption/auth scheme is required. There is no scope for forcing an alternative network interface for the native migration data with this method.

This mode cannot be invoked from virsh

Supported by QEMU driver

vir Domain Migrate，设置了vir Migrate PEER2PEER标志，使用libvirt  URI格式作为“URI”参数。目标libvirtd服务器将根据主主机名自动确定用于迁移的本机管理程序URI。可选uri参数控制源libvirtd如何连接到目标libvirtd，以防无法使用客户端用于连接到目标的相同地址访问，或者需要不同的加密/身份验证方案。使用此方法无法强制为本机迁移数据提供替代网络接口。

无法从virsh调用此模式

由QEMU驱动程序支持

#### Tunnelled migration, client and peer2peer between two libvirtd servers

virDomainMigrate, with the VIR_MIGRATE_PEER2PEER & VIR_MIGRATE_TUNNELLED flags set, using the libvirt URI format for the 'uri' parameter. The destination libvirtd server will automatically determine the native hypervisor URI for migration, based off the primary hostname. The optional uri parameter controls how the source libvirtd connects to the destination libvirtd, in case it is not accessible using the same address that the client uses to connect to the destination, or a different encryption/auth scheme is required. The native hypervisor URI format is not used at all.

This mode cannot be invoked from virsh

Supported by QEMU driver

vir域迁移，设置了vir Migrate PEER2PEER和vir Migrate TUNNELED标志，使用libvirt  URI格式作为“URI”参数。目标libvirtd服务器将根据主主机名自动确定用于迁移的本机管理程序URI。可选uri参数控制源libvirtd如何连接到目标libvirtd，以防无法使用客户端用于连接到目标的相同地址访问，或者需要不同的加密/身份验证方案。根本不使用本机管理程序URI格式。

无法从virsh调用此模式

由QEMU驱动程序支持

#### Native migration, client to one libvirtd server

virDomainMigrateToURI, without the VIR_MIGRATE_PEER2PEER flag set, using a hypervisor specific URI format for the 'uri' parameter. There is no use or requirement for a destination libvirtd instance at all. This is typically used when the hypervisor has its own native management daemon available to handle incoming migration attempts on the destination.vir Domain Migrate To URI，未设置vir Migrate  PEER2PEER标志，使用“URI”参数的管理程序特定URI格式。根本没有使用或要求目标libvirtd实例。当管理程序有自己的本机管理守护程序可用于处理目标上的传入迁移尝试时，通常会使用此选项。

```bash
virsh migrate GUESTNAME HV-URI


eg using same libvirt URI for all connections
```

#### Native migration, peer2peer between two libvirtd servers

virDomainMigrateToURI, with the VIR_MIGRATE_PEER2PEER flag set, using the libvirt URI format for the 'uri' parameter. The destination libvirtd server will automatically determine the native hypervisor URI for migration, based off the primary hostname. There is no scope for forcing an alternative network interface for the native migration data with this method. The destination URI must be reachable using the source libvirtd credentials (which are not necessarily the same as the credentials of the client in connecting to the source).

vir Domain Migrate To URI，设置了vir Migrate PEER2PEER标志，使用libvirt  URI格式作为“URI”参数。目标libvirtd服务器将根据主主机名自动确定用于迁移的本机管理程序URI。使用此方法无法强制为本机迁移数据提供替代网络接口。必须使用源libvirtd凭据（不一定与客户端连接到源时的凭据相同）访问目标URI。

```
virsh migrate GUESTNAME DEST-LIBVIRT-URI [ALT-DEST-LIBVIRT-URI]


eg using same libvirt URI for all connections

virsh migrate --p2p web1 qemu+ssh://desthost/system


eg using different libvirt URI auth scheme for peer2peer connections

virsh migrate --p2p web1 qemu+ssh://desthost/system qemu+tls:/desthost/system


eg using different libvirt URI hostname for peer2peer connections

virsh migrate --p2p web1 qemu+ssh://desthost/system qemu+ssh://10.0.0.1/system
```

Supported by the QEMU driver

由QEMU驱动程序支持

#### Tunnelled migration, peer2peer between two libvirtd servers

virDomainMigrateToURI, with the VIR_MIGRATE_PEER2PEER & VIR_MIGRATE_TUNNELLED flags set, using the libvirt URI format for the 'uri' parameter. The destination libvirtd server will automatically determine the native hypervisor URI for migration, based off the primary hostname. The optional uri parameter controls how the source libvirtd connects to the destination libvirtd, in case it is not accessible using the same address that the client uses to connect to the destination, or a different encryption/auth scheme is required. The native hypervisor URI format is not used at all. The destination URI must be reachable using the source libvirtd credentials (which are not necessarily the same as the credentials of the client in connecting to the source).

vir域迁移到URI，设置了vir Migrate PEER2PEER和vir Migrate TUNNELED标志，使用libvirt  URI格式作为“URI”参数。目标libvirtd服务器将根据主主机名自动确定用于迁移的本机管理程序URI。可选uri参数控制源libvirtd如何连接到目标libvirtd，以防无法使用客户端用于连接到目标的相同地址访问，或者需要不同的加密/身份验证方案。根本不使用本机管理程序URI格式。必须使用源libvirtd凭据（不一定与客户端连接到源时的凭据相同）访问目标URI。

```bash
syntax: virsh migrate GUESTNAME DEST-LIBVIRT-URI [ALT-DEST-LIBVIRT-URI]


eg using same libvirt URI for all connections

virsh migrate --p2p --tunnelled web1 qemu+ssh://desthost/system


eg using different libvirt URI auth scheme for peer2peer connections

virsh migrate --p2p --tunnelled web1 qemu+ssh://desthost/system qemu+tls:/desthost/system


eg using different libvirt URI hostname for peer2peer connections

virsh migrate --p2p --tunnelled web1 qemu+ssh://desthost/system qemu+ssh://10.0.0.1/system
```

Supported by QEMU driver

#### Migration using only UNIX sockets

In niche scenarios where libvirt daemon does not have access to the network (e.g. running in a restricted container on a host that has accessible network), when a management application wants to have complete control over the transfer or when migrating between two containers on the same host all the communication can be done using UNIX sockets. This includes connecting to non-standard socket path for the destination daemon, using UNIX sockets for hypervisor's communication or for the NBD data transfer. All of that can be used with both peer2peer and direct migration options.

Example using /tmp/migdir as a directory representing the same path visible from both libvirt daemons. That can be achieved by bind-mounting the same directory to different containers running separate daemons or forwarding connections to these sockets manually (using socat, netcat or a custom piece of software):

在libvirt守护程序无法访问网络的利基场景中（例如，在具有可访问网络的主机上的受限容器中运行），当管理应用程序想要完全控制传输或在同一主机上的两个容器之间迁移时，可以使用UNIX套接字完成所有通信。这包括连接到目标守护进程的非标准套接字路径，使用UNIX套接字进行管理程序通信或NBD数据传输。所有这些都可以与peer2peer和直接迁移选项一起使用。

示例使用/tmp/migdir作为目录，表示两个libvirt守护进程中可见的相同路径。这可以通过将同一目录绑定到运行单独守护进程的不同容器或手动将连接转发到这些套接字（使用socat、netcat或自定义软件）来实现：

```bash
virsh migrate --domain web1 [--p2p] --copy-storage-all
  --desturi 'qemu+unix:///system?socket=/tmp/migdir/test-sock-driver'
  --migrateuri 'unix:///tmp/migdir/test-sock-qemu'
  --disks-uri unix:///tmp/migdir/test-sock-nbd
```

One caveat is that on SELinux-enabled systems all the sockets that the hypervisor is going to connect to needs to have the proper context and that is chosen before its creation by the process that creates it. That is usually done by using setsockcreatecon{,raw}() functions. Generally *system_r:system_u:svirt_socket_t:s0* should do the trick, but check the SELinux rules and settings of your system.

Supported by QEMU driver

一个警告是，在启用SELinux的系统上，管理程序要连接到的所有套接字都需要具有适当的上下文，并且在创建之前由创建它的进程选择。这通常通过使用setsockcreatecon｛，raw｝（）函数来完成。一般来说，*systemr:systemu:svirt-sockett:s0*应该做到这一点，但要检查系统的SELinux规则和设置。

由QEMU驱动程序支持

#### Migration of VMs using non-shared images for disks

Libvirt by default expects that the disk images which are not explicitly network accessed are shared between the hosts by means of a network filesystem or remote block storage.默认情况下，Libvirt期望通过网络文件系统或远程块存储在主机之间共享未明确网络访问的磁盘映像。

By default it's expected that they are in the same location, but this can be modified by providing an updated domain XML with appropriate paths to the images using --xml argument for virsh migrate.默认情况下，它们应该位于同一位置，但可以通过使用virshmigrate的--XML参数提供更新的域XML以及到图像的适当路径来修改这一点。

In case when one or more of the images are residing on local storage libvirt can migrate them as part of the migration flow. This is enabled using --copy-storage-all flag for virsh migrate. Additionally --migrate-disks parameter allows control which disks need to actually be migrated. Without the flag all read-write disks are migrated.如果一个或多个映像驻留在本地存储上，libvirt可以将它们作为迁移流的一部分进行迁移。这是使用virsh迁移的--copy storage all标志启用的。此外，migratedisks参数允许控制实际需要迁移哪些磁盘。如果没有该标志，则迁移所有读写磁盘。

On the destination the images must be either pre-created by the user having correct format and size or alternatively if the target path resides within a libvirt storage pool they will be automatically created.在目标上，映像必须由具有正确格式和大小的用户预先创建，或者如果目标路径位于libvirt存储池中，则将自动创建映像。

In case when the user wishes to migrate only the topmost image from a backing chain of images for each disks --copy-storage-inc can be used instead. User must pre-create the images unconditionally.如果用户希望只迁移每个磁盘的备份映像链中最顶层的映像，则可以使用copy-storage-inc。用户必须无条件地预先创建图像。

In order to ensure that the migration of disks will not be overwhelmed by a guest doing a lot of I/O to a local fast storage the --copy-storage-synchronous-writes flag ensures that newly written data is synchronously written to the destination. This may harm I/O performance during the migration.为了确保磁盘迁移不会因客户机对本地快速存储进行大量I/O而不堪重负，--copy storage synchronous writes标志可确保新写入的数据被同步写入目标。这可能会在迁移期间损害I/O性能。

## macOS support

- [Installation](https://libvirt.org/macos.html#installation)
- [Running libvirtd locally](https://libvirt.org/macos.html#running-libvirtd-locally)

Libvirt works both as client (for most drivers) and server (for the [QEMU driver](https://libvirt.org/drvqemu.html)) on macOS.

Since 8.1.0, the "hvf" domain type can be used to run hardware-accelerated VMs on macOS via [Hypervisor.framework](https://developer.apple.com/documentation/hypervisor). QEMU version 2.12 or newer is needed for this to work.

### Installation

libvirt client (virsh), server (libvirtd) and development headers can be installed from [Homebrew](https://brew.sh):

```
brew install libvirt
```

### Running libvirtd locally

The server can be started manually:

```
$ libvirtd
```

or on system boot:

```
$ brew services start libvirt
```

Once started, you can use virsh as you would on Linux.

## Windows 支持

Libvirt is known to work as a client (not server) on Windows XP (32-bit), and Windows 7 (64-bit). Other Windows variants likely work as well but we either haven't tested or received reports for them.

### Installation packages

Users who need pre-built Windows DLLs of libvirt are advised to use the [Virt Viewer](https://virt-manager.org) pre-compiled [Windows MSI packages](https://virt-manager.org/download/)

These installers include the libvirt, gtk-vnc and spice-gtk DLLs along with any of their pre-requisite supporting DLLs, the virsh command line tool and the virt-viewer & remote-viewer graphical tools. The development headers are not currently provided in this installer, so this cannot be used for compiling new applications against libvirt.

### Connection types

These connection types are known to work:

- QEMU with TLS (qemu+tls://)
- QEMU with direct TCP (qemu+tcp://)
- VMware ESX (esx://)
- VMware VPX (vpx://)

These connection types are known not to work:

- QEMU with SSH (qemu+ssh://)

All other connection types may or may not work, and haven't been tested.

Please let us know either the results (either way) if you do.

**Special note** - Support for VirtualBox *on windows* was added in libvirt 0.8.7, so reports on success and failure if you're using that would be really helpful and appreciated.

**WARNING - The qemu+tcp:// connection type passes all traffic without encryption. This is a security hazard, and should not be used in security sensitive environments.**

### Connecting to VMware ESX/vSphere

Details on the capabilities, certificates, and connection string syntax used for connecting to VMware ESX and vSphere can be found online here:

https://libvirt.org/drvesx.html

### TLS Certificates

TLS certificates need to have been created and placed in the correct locations, before you will be able to connect to QEMU servers over TLS.

Information on generating TLS certificates can be found here:

https://wiki.libvirt.org/page/TLSSetup

These instructions are for *nix, and have not yet been adapted for Windows. You'll need to figure out the Windows equivalents until that's done (sorry). If you can help us out with this, that would be really welcome.

The locations of the TLS certificates and key file on Windows are hard coded, rather than being configurable.

The Certificate Authority (CA) certificate file must be placed in:

- %APPDATA%libvirtpkiCAcacert.pem

The Client certificate file must be placed in:

- %APPDATA%libvirtpkilibvirtclientcert.pem

The Client key file must be placed in:

- %APPDATA%libvirtpkilibvirtprivateclientkey.pem

On an example Windows 7 x64 system here, this resolves to these paths:

- C:UserssomeuserAppDataRoaminglibvirtpkiCAcacert.pem
- C:UserssomeuserAppDataRoaminglibvirtpkilibvirtclientcert.pem
- C:UserssomeuserAppDataRoaminglibvirtpkilibvirtprivateclientkey.pem

### Feedback

Feedback and suggestions on changes to make and what else to include [are desired](https://libvirt.org/contact.html).

### Compiling yourself

Libvirt can be compiled on Windows using the free [MinGW-w64 compiler](https://www.mingw-w64.org/).

#### MSYS Build script

The easiest way is to use the **msys_setup** script, developed by Matthias Bolte. This is actively developed and kept current with libvirt releases:

https://github.com/photron/msys_setup

#### Cross compiling

You can also cross-compile to a Windows target from a Fedora machine using the packages available in the Fedora repos.

#### By hand

Use these options when following the instructions on the [Compiling](https://libvirt.org/compiling.html) page.

```
meson build \
  -Dsasl=disabled \
  -Dpolkit=disabled \
  -Ddriver_libxl=disabled \
  -Ddriver_qemu=disabled \
  -Ddriver_lxc=disabled \
  -Ddriver_openvz=disabled \
  -Ddriver_libvirtd=disabled
```

## 应用程序

### 命令行工具

- [guestfish](https://libguestfs.org)

  Guestfish 是一个交互式 shell 和命令行工具，用于检查和修改虚拟机文件系统。它使用 libvirt 查找来宾客户机及其关联的磁盘。

- virsh

  An interactive shell, and batch scriptable tool for performing management tasks on all libvirt managed domains, networks and storage. This is part of the libvirt core distribution.一个交互式shell和批脚本化工具，用于在所有libvirt管理的域、网络和存储上执行管理任务。这是libvirt核心发行版的一部分。

- [virt-clone](https://virt-manager.org/)

  Allows the disk image(s) and configuration for an existing virtual machine to be cloned to form a new virtual machine. It automates copying of data across to new disk images, and updates the UUID, MAC address, and name in the configuration.允许克隆现有虚拟机的磁盘映像和配置以形成新的虚拟机。它自动将数据复制到新的磁盘映像，并更新配置中的UUID、MAC地址和名称。

- [virt-df](https://people.redhat.com/rjones/virt-df/)

  Examine the utilization of each filesystem in a virtual machine from the comfort of the host machine. This tool peeks into the guest disks and determines how much space is used. It can cope with common Linux filesystems and LVM volumes.从主机的角度检查虚拟机中每个文件系统的利用率。该工具会窥探来宾磁盘并确定使用了多少空间。它可以处理常见的Linux文件系统和LVM卷。

- [virt-image](https://virt-manager.org/)

  Provides a way to deploy virtual appliances. It defines a simplified portable XML format describing the pre-requisites of a virtual machine. At time of deployment this is translated into the domain XML format for execution under any libvirt hypervisor meeting the pre-requisites.提供一种部署虚拟设备的方法。它定义了一种简化的可移植XML格式，描述了虚拟机的先决条件。在部署时，这将被转换为域XML格式，以便在满足先决条件的任何libvirt管理程序下执行。

- [virt-install](https://virt-manager.org/)

  Provides a way to provision new virtual machines from a OS distribution install tree. It supports provisioning from local CD images, and the network over NFS, HTTP and FTP.提供从OS分发安装树配置新虚拟机的方法。它支持通过NFS、HTTP和FTP从本地CD映像和网络进行资源调配。

- [virt-top](https://people.redhat.com/rjones/virt-top/)

  Watch the CPU, memory, network and disk utilization of all virtual machines running on a host.监视主机上运行的所有虚拟机的CPU、内存、网络和磁盘利用率。

- [virt-what](https://people.redhat.com/~rjones/virt-what/)

  virt-what is a shell script for detecting if the program is running in a virtual machine. It prints out a list of facts about the virtual machine, derived from heuristics.virt什么是用于检测程序是否在虚拟机中运行的shell脚本。它打印出一个关于虚拟机的事实列表，这些事实来自启发法。

- [stap](https://sourceware.org/systemtap/)

  SystemTap is a tool used to gather rich information about a running system through the use of scripts. Starting from v2.4, the front-end application stap can use libvirt to gather data within virtual machines.

- [vagrant-libvirt](https://github.com/pradels/vagrant-libvirt/)

  Vagrant-Libvirt is a Vagrant plugin that uses libvirt to manage virtual machines. It is a command line tool for developers that makes it very fast and easy to deploy and re-deploy an environment of vm's.

- [virt-lightning](https://github.com/virt-lightning/virt-lightning)

  Virt-Lightning uses libvirt, cloud-init and libguestfs to allow anyone to quickly start a new VM. Very much like a container CLI, but with a virtual machine.

- [vms](https://github.com/cbosdo/vms)

  vms is a tool wrapping around the libvirt API to manage multiple virtual machines at once with name patterns.

### 配置管理

- [LCFG](https://wiki.lcfg.org/bin/view/LCFG/LcfgLibvirt)

  LCFG is a system for automatically installing and managing the configuration of large numbers of Unix systems. It is particularly suitable for sites with very diverse and rapidly changing configurations. The lcfg-libvirt package adds support for virtualized systems to LCFG, with both Xen and KVM known to work. Cloning guests is supported, as are the bridged, routed, and isolated modes for Virtual Networking.

### 持续集成

- [BuildBot](https://docs.buildbot.net/latest/manual/configuration/workers-libvirt.html)

  BuildBot is a system to automate the compile/test cycle required by most software projects. CVS commits trigger new builds, run on a variety of client machines. Build status (pass/fail/etc) are displayed on a web page or through other protocols.

- [Jenkins](https://plugins.jenkins.io/libvirt-slave/)

  This plugin for Jenkins adds a way to control guest domains hosted on Xen or QEMU/KVM. You configure a Jenkins Agent, selecting the guest domain and hypervisor. When you need to build a job on a specific Agent, its guest domain is started, then the job is run. When the build process is finished, the guest domain is shut down, ready to be used again as required.

### Conversion

- [virt-p2v](https://libguestfs.org/virt-p2v.1.html)

  Convert a physical machine to run on KVM. It is a LiveCD which is booted on the machine to be converted. It collects a little information from the user, then copies the disks over to a remote machine and defines the XML for a domain to run the guest. (Note this tool is included with libguestfs)

- [virt-v2v](https://libguestfs.org/virt-v2v.1.html)

  virt-v2v converts guests from a foreign hypervisor to run on KVM, managed by libvirt. It can convert guests from VMware or Xen to run on OpenStack, oVirt (RHEV-M), or local libvirt. It will enable VirtIO drivers in the converted guest if possible. (Note this tool is included with libguestfs) For RHEL customers of Red Hat, conversion of Windows guests is also possible. This conversion requires some Microsoft signed pieces, that Red Hat can provide.

- [vmware2libvirt](https://launchpad.net/virt-goodies)

  Part of the *virt-goodies* package, vmware2libvirt is a python script for migrating a vmware image to libvirt.

### 桌面应用

- [virt-manager](https://virt-manager.org/)

  A general purpose desktop management tool, able to manage virtual machines across both local and remotely accessed hypervisors. It is targeted at home and small office usage up to managing 10-20 hosts and their VMs.

- [virt-viewer](https://virt-manager.org/)

  A lightweight tool for accessing the graphical console associated with a virtual machine. It can securely connect to remote consoles supporting the VNC protocol. Also provides an optional mozilla browser plugin.

- [qt-virt-manager](https://f1ash.github.io/qt-virt-manager)

  The Qt GUI for create and control VMs and another virtual entities (aka networks, storages, interfaces, secrets, network filters). Contains integrated LXC/SPICE/VNC viewer for accessing the graphical or text console associated with a virtual machine or container.

- [qt-remote-viewer](https://f1ash.github.io/qt-virt-manager/#virtual-machines-viewer)

  The Qt VNC/SPICE viewer for access to remote desktops or VMs.

- [GNOME Boxes](https://gnomeboxes.org/)

  A GNOME application to access virtual machines.

### IaaS

- [Eucalyptus](https://github.com/eucalyptus/eucalyptus)

  Eucalyptus is an on-premise Infrastructure as a Service cloud software platform that is open source and AWS-compatible. Eucalyptus uses libvirt virtualization API to directly interact with Xen and KVM hypervisors.

- [Nimbus](https://www.nimbusproject.org/)

  Nimbus is an open-source toolkit focused on providing Infrastructure-as-a-Service (IaaS) capabilities to the scientific community. It uses libvirt for communication with all KVM and Xen virtual machines.

- [OpenStack](https://www.openstack.org)

  OpenStack is a "cloud operating system" usable for both public and private clouds. Its various parts take care of compute, storage and networking resources and interface with the user using a dashboard. Compute part uses libvirt to manage VM life-cycle, monitoring and so on.

- [KubeVirt](https://kubevirt.io/)

  KubeVirt is a virtual machine management add-on for Kubernetes. The aim is to provide a common ground for virtualization solutions on top of Kubernetes.

- [Cherrypop](https://github.com/gustavfranssonnyvell/cherrypop)

  A cloud software with no masters or central points. Nodes autodetect other nodes and autodistribute virtual machines and autodivide up the workload. Also there is no minimum limit for hosts, well, one might be nice. It's perfect for setting up low-end servers in a cloud or a cloud where you want the most bang for the bucks.

- [ZStack](https://en.zstack.io/)

  ZStack is an open source IaaS software that aims to automate the management of all resources (compute, storage, networking, etc.) in a datacenter by using APIs, thus conforming to the principles of a software-defined datacenter. The key strengths of ZStack in terms of management are scalability, performance, and a fast, user-friendly deployment.

### 库文件

- [libguestfs](https://libguestfs.org)

  A library and set of tools for accessing and modifying virtual machine disk images. It can be linked with C and C++ management programs, and has bindings for Perl, Python, Ruby, Java, OCaml, PHP, Haskell, and C#. Using its FUSE module, you can also mount guest filesystems on the host, and there is a subproject to allow merging changes into the Windows Registry in Windows guests.

- [libvirt-sandbox](https://sandbox.libvirt.org)

  A library and command line tools for simplifying the creation of application sandboxes using virtualization technology. It currently supports either KVM, QEMU or LXC as backends. Integration with systemd facilitates sandboxing of system services like apache.

- [Ruby Libvirt Object bindings](https://github.com/ohadlevy/virt#readme)

  Allows using simple ruby objects to manipulate hypervisors, guests, storage, network etc. It is based on top of the [native ruby bindings](https://libvirt.org/ruby).

### LiveCD / Appliances

- [virt-p2v](https://libguestfs.org/virt-v2v/)

  An older tool for converting a physical machine into a virtual machine. It is a LiveCD which is booted on the machine to be converted. It collects a little information from the user, then copies the disks over to a remote machine and defines the XML for a domain to run the guest.

### Monitoring

- [collectd](https://collectd.org/plugins/libvirt.shtml)

  The libvirt-plugin is part of [collectd](https://collectd.org/) and gathers statistics about virtualized guests on a system. This way, you can collect CPU, network interface and block device usage for each guest without installing collectd on the guest systems. For a full description, please refer to the libvirt section in the collectd.conf(5) manual page.

- [Host sFlow](https://sflow.net/)

  Host sFlow is a lightweight agent running on KVM hypervisors that links to libvirt library and exports standardized cpu, memory, network and disk metrics for all virtual machines.

- [Munin](https://honk.sigxcpu.org/projects/libvirt/#munin)

  The plugins provided by Guido Günther allow to monitor various things like network and block I/O with [Munin](https://munin-monitoring.org/).

- [Nagios-virt](https://people.redhat.com/rjones/nagios-virt/)

  Nagios-virt is a configuration tool to add monitoring of your virtualised domains to [Nagios](https://www.nagios.org/). You can use this tool to either set up a new Nagios installation for your Xen or QEMU/KVM guests, or to integrate with your existing Nagios installation.

- [PCP](https://pcp.io/man/man1/pmdalibvirt.1.html)

  The PCP libvirt PMDA (plugin) is part of the [PCP](https://pcp.io/) toolkit and provides hypervisor and guest information and complete set of guest performance metrics. It supports pCPU, vCPU, memory, block device, network interface, and performance event metrics for each virtual guest.

### Provisioning

- [Foreman](https://theforeman.org)

  Foreman is an open source web based application aimed to be a Single Address For All Machines Life Cycle Management. Foreman: Creates everything you need when adding a new machine to your network, its goal being automatically managing everything you would normally manage manually (DNS, DHCP, TFTP, Virtual Machines,CA, CMDB...) Integrates with Puppet (and acts as web front end to it). Takes care of provisioning until the point puppet is running, allowing Puppet to do what it does best. Shows you Systems Inventory (based on Facter) and provides real time information about hosts status based on Puppet reports.

### Web 应用

- [AbiCloud](https://www.abiquo.com/)

  AbiCloud is an open source cloud platform manager which allows to easily deploy a private cloud in your datacenter. One of the key differences of AbiCloud is the web rich interface for managing the infrastructure. You can deploy a new service just dragging and dropping a VM.

- [Kimchi](https://kimchi-project.github.io/kimchi/)

  Kimchi is an HTML5 based management tool for KVM. It is designed to make it as easy as possible to get started with KVM and create your first guest. Kimchi manages KVM guests through libvirt. The management interface is accessed over the web using a browser that supports HTML5.

- [oVirt](https://ovirt.org/)

  oVirt provides the ability to manage large numbers of virtual machines across an entire data center of hosts. It integrates with FreeIPA for Kerberos authentication, and in the future, certificate management.

- [VMmanager](https://ispsystem.com/en/software/vmmanager)

  VMmanager is a software solution for virtualization management that can be used both for hosting virtual machines and building a cloud. VMmanager can manage not only one server, but a large cluster of hypervisors. It delivers a number of functions, such as live migration that allows for load balancing between cluster nodes, monitoring CPU, memory.

- [mist.io](https://mist.io/)

  Mist.io is an open source project and a service that can assist you in managing your virtual machines on a unified way, providing a simple interface for all of your infrastructure (multiple public cloud providers, OpenStack based public/private clouds, Docker servers, bare metal servers and now KVM hypervisors).

- [Ravada](https://ravada.upc.edu/)

  Ravada is an open source tool for managing Virtual Desktop Infrastructure (VDI). It is very easy to install and use. Following the documentation, you'll be ready to deploy virtual machines in minutes. The only requirements for the users are a Web browser and a lightweight remote viewer.

- [Virtlyst](https://github.com/cutelyst/Virtlyst)

  Virtlyst is an open source web application built with C++11, Cutelyst and Qt. It features: Low memory usage (around 5 MiB of RAM) Look and feel easily customized with HTML templates that use the Django syntax VNC/Spice console directly in the browser using websockets on the same HTTP port Host and Domain statistics graphs (CPU, Memory, IO, Network) Connect to multiple libvirtd instances (over local Unix domain socket, SSH, TCP and TLS) Manage Storage Pools, Storage Volumes, Networks, Interfaces, and Secrets Create and launch VMs Configure VMs with easy panels or go pro and edit the VM's XML

- [Cockpit](https://cockpit-project.org/)

  Cockpit is a web-based graphical interface for servers. With [cockpit-machines](https://github.com/cockpit-project/cockpit-machines) it can create and manage virtual machines via libvirt.

### 其他

- [Cuckoo Sandbox](https://cuckoosandbox.org/)

  Cuckoo Sandbox is a malware analysis system. You can throw any suspicious file at it and in a matter of seconds Cuckoo will provide you back some detailed results outlining what such file did when executed inside an isolated environment. And libvirt is one of the backends that can be used for the isolated environment.