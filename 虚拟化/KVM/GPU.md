# GPU virtualization with QEMU/KVM 使用 QEMU/KVM 实现 GPU 虚拟化

## Graphics 图形

Graphics for QEMU/KVM always comes in two pieces: a front end and a back end.
QEMU/KVM 的图形始终分为两部分：前端和后端。

- `frontend`: Controlled via the `-vga` argument, which is provided to the guest. Usually one of `cirrus`, `std`, `qxl`, or `virtio`. The default these days is `qxl` which strikes a good balance between guest compatibility and  performance. The guest needs a driver for whichever option is selected – this is the most common reason to not use the default (e.g., on very  old Windows versions).
   `frontend` ：通过提供给来宾的 `-vga` 参数进行控制。通常是 `cirrus` 、 `std` 、 `qxl` 或 `virtio` 之一。如今的默认设置是在 `qxl` 来宾兼容性和性能之间取得良好平衡。无论选择哪个选项，客户机都需要驱动程序 - 这是不使用默认值的最常见原因（例如，在非常旧的 Windows 版本上）。
- `backend`: Controlled via the `-display` argument. This is what the host uses to actually display the graphical content, which can be an application window via `gtk` or a `vnc`.
   `backend` ：通过 `-display` 参数控制。这是主机用于实际显示图形内容的内容，它可以是应用程序窗口，也可以是 `vnc` . `gtk` 
- In addition, one can enable the `-spice` back end (which can be done in addition to `vnc`). This can be faster and provides more authentication methods than `vnc`.
  此外，还可以启用 `-spice` 后端（除了 `vnc` 之外还可以这样做）。这可能比 更快，并提供更多的 `vnc` 身份验证方法。
- If you want no graphical output at all, you can save some memory and CPU cycles by setting `-nographic`.
  如果根本不想要图形输出，可以通过设置 `-nographic` 来节省一些内存和 CPU 周期。

If you run with `spice` or `vnc` you can use native `vnc` tools or virtualization-focused tools like `virt-viewer`. You can read more about these in the [libvirt section](https://ubuntu.com/server/docs/libvirt).
如果您使用 `spice` 本机工具或以虚拟化为重点的工具运行， `vnc` 或者可以使用本机 `vnc` 工具或以虚拟化为中心的工具，例如 `virt-viewer` .您可以在 libvirt 部分阅读有关这些内容的更多信息。

All these options  are considered basic usage of graphics, but there are  also advanced options for more specific use-cases. Those cases usually  differ in their [ease-of-use and capability](https://cpaelzer.github.io/blogs/006-mediated-device-to-pass-parts-of-your-gpu-to-a-guest/), such as:
所有这些选项都被视为图形的基本用法，但对于更具体的用例，也有高级选项。这些案例的易用性和功能通常不同，例如：

- *Need 3D acceleration*: Use `-vga virtio` with a local display having a GL context `-display gtk,gl=on`. This will use [virgil3d](https://virgil3d.github.io/) on the host, and guest drivers are needed (which are common in Linux since [Kernels >= 4.4](https://www.kraxel.org/blog/2016/09/using-virtio-gpu-with-libvirt-and-spice/) but can be hard to come by for other cases). While not as fast as the  next two options, the major benefit is that it can be used without  additional hardware and without a proper input-output memory management  unit (IOMMU) [set up for device passthrough](https://www.kernel.org/doc/Documentation/vfio-mediated-device.txt).
  需要 3D 加速：与具有 GL 上下文 `-display gtk,gl=on` 的本地显示器一起使用 `-vga virtio` 。这将在主机上使用 virgil3d，并且需要客户机驱动程序（这在 Linux 中很常见，因为内核 >=  4.4，但在其他情况下可能很难获得）。虽然不如接下来的两个选项快，但主要优点是无需额外的硬件即可使用，并且无需为设备直通设置适当的输入输出内存管理单元 （IOMMU）。

- *Need native performance*: Use PCI passthrough of additional GPUs in the system. You’ll need an  IOMMU set up, and you’ll need to unbind the cards from the host before  you can pass it through, like so:
  需要本机性能：使用系统中其他 GPU 的 PCI 直通。您需要设置 IOMMU，并且需要先从主机上解绑卡，然后才能将其传递，如下所示：

  ```bash
  -device vfio-pci,host=05:00.0,bus=1,addr=00.0,multifunction=on,x-vga=on -device vfio-pci,host=05:00.1,bus=1,addr=00.1
  ```

- *Need native performance, but multiple guests per card*: Like with PCI passthrough, but using mediated devices to shard a card on the host into multiple devices, then passing those:
  需要本机性能，但每张卡有多个客户机：与 PCI 直通类似，但使用中介设备将主机上的卡分片到多个设备中，然后传递这些设备：

  ```bash
  -display gtk,gl=on -device vfio-pci,sysfsdev=/sys/bus/pci/devices/0000:00:02.0/4dd511f6-ec08-11e8-b839-2f163ddee3b3,display=on,rombar=0
  ```

  You can read more [about vGPU at kraxel](https://www.kraxel.org/blog/2018/04/vgpu-display-support-finally-merged-upstream/) and [Ubuntu GPU mdev evaluation](https://cpaelzer.github.io/blogs/006-mediated-device-to-pass-parts-of-your-gpu-to-a-guest/). The sharding of the cards is driver-specific and therefore will differ per manufacturer – [Intel](https://github.com/intel/gvt-linux/wiki/GVTg_Setup_Guide), [Nvidia](https://docs.nvidia.com/grid/latest/grid-vgpu-user-guide/index.html), or AMD.
  您可以在 kraxel 和 Ubuntu GPU mdev 评估中阅读有关 vGPU 的更多信息。显卡的分片是特定于驱动程序的，因此因制造商（Intel、Nvidia 或 AMD）而异。

The advanced cases in particular can get pretty complex – it is recommended to use QEMU through [libvirt](https://ubuntu.com/server/docs/libvirt) for those cases. libvirt will take care of all but the host kernel/BIOS tasks of such configurations. Below are the common basic actions needed for faster options (i.e., passthrough and mediated devices  passthrough).
特别是高级情况可能会变得非常复杂——对于这些情况，建议通过 libvirt 使用 QEMU。libvirt 将处理此类配置中除主机内核/BIOS 任务之外的所有任务。以下是更快选项（即直通和中介设备直通）所需的常见基本操作。

The initial step for both options is the same; you want to ensure your  system has its IOMMU enabled and the device to pass should be in a group of its own. Enabling the VT-d and IOMMU is usually a BIOS action and  thereby manufacturer dependent.
两个选项的初始步骤是相同的;你要确保系统已启用其 IOMMU，并且要传递的设备应位于其自己的组中。启用 VT-d 和 IOMMU 通常是 BIOS 操作，因此取决于制造商。

## Preparing the input-output memory management unit (IOMMU) 准备输入输出内存管理单元 （IOMMU）

On the kernel side, there are various [options you can enable/configure](https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html?highlight=iommu) for the [IOMMU feature](https://www.kernel.org/doc/html/latest/arch/x86/iommu.html). In recent Ubuntu kernels (>=5.4 => Focal or Bionic-HWE kernels)  everything usually works by default, unless your hardware setup makes  you need any of those tuning options.
在内核端，您可以为 IOMMU 功能启用/配置各种选项。在最近的 Ubuntu 内核（>=5.4 => Focal 或 Bionic-HWE 内核）中，默认情况下一切正常，除非您的硬件设置使您需要任何这些调整选项。

> **Note**: 注意：
>  The card used in all examples below e.g. when filtering for or assigning PCI IDs, is an NVIDIA V100 on PCI ID 41.00.0
> 以下所有示例中使用的卡（例如，在过滤或分配 PCI ID 时）是 PCI ID 41.00.0 上的 NVIDIA V100
>  $ lspci | grep 3D
> $ lspci |grep 3D模型
>  41:00.0 3D controller: NVIDIA Corporation GV100GL [Tesla V100 PCIe 16GB] (rev a1)
> 41：00.0 3D 控制器：NVIDIA Corporation GV100GL [Tesla V100 PCIe 16GB] （rev a1）

You can check your boot-up kernel messages for IOMMU/DMAR messages or even filter it for a particular PCI ID.
您可以检查启动内核消息中是否有 IOMMU/DMAR 消息，甚至可以过滤它以查找特定的 PCI ID。

To list all: 要列出所有内容：

```bash
dmesg | grep -i -e DMAR -e IOMMU
```

Which produces an output like this:
这会产生如下输出：

```plaintext
[    3.509232] iommu: Default domain type: Translated
...
[    4.516995] pci 0000:00:01.0: Adding to iommu group 0
...
[    4.702729] perf/amd_iommu: Detected AMD IOMMU #0 (2 banks, 4 counters/bank).
```

To filter for the installed 3D card:
要筛选已安装的 3D 卡：

```bash
dmesg | grep -i -e DMAR -e IOMMU | grep $(lspci | awk '/ 3D / {print $1}' )
```

Which shows the following output:
显示以下输出：

```plaintext
[    4.598150] pci 0000:41:00.0: Adding to iommu group 66
```

If you have a particular device and want to check for its group you can do that via `sysfs`. If you have multiple cards or want the full list you can traverse the same `sysfs` paths for that.
如果您有特定设备并想检查其组，则可以通过 `sysfs` .如果您有多张卡片或想要完整列表，您可以遍历相同的 `sysfs` 路径。

For example, to find the group for our example card:
例如，要查找示例卡片的组，请执行以下操作：

```bash
find /sys/kernel/iommu_groups/ -name "*$(lspci | awk '/ 3D / {print $1}')*"
```

Which it tells us is found here:
它告诉我们的可以在这里找到：

```plaintext
/sys/kernel/iommu_groups/66/devices/0000:41:00.0
```

We can also check if there are other devices in this group:
我们还可以检查此组中是否有其他设备：

```auto
ll /sys/kernel/iommu_groups/66/devices/
lrwxrwxrwx 1 root root 0 Jan  3 06:57 0000:41:00.0 -> ../../../../devices/pci0000:40/0000:40:03.1/0000:41:00.0/
```

Another useful tool for this stage (although the details are beyond the scope of this article) can be `virsh node*`, especially `virsh nodedev-list --tree` and `virsh nodedev-dumpxml <pcidev>`.
此阶段的另一个有用工具（尽管详细信息超出了本文的范围）可以是 `virsh node*` ，尤其是 `virsh nodedev-list --tree` 和 `virsh nodedev-dumpxml <pcidev>` 。

> **Note**: 注意：
>  Some older or non-server boards tend to group devices in one IOMMU  group, which isn’t very useful as it means you’ll need to pass “all or  none of them” to the same guest.
> 一些较旧的或非服务器主板倾向于将设备分组到一个 IOMMU 组中，这不是很有用，因为这意味着您需要将“全部或全部”传递给同一个客户机。

## Preparations for PCI and mediated devices pass-through – block host drivers PCI 和中介设备直通的准备工作 – 块主机驱动程序

For both, you’ll want to ensure the normal driver isn’t loaded. In some cases you can do that at runtime via `virsh nodedev-detach <pcidevice>`. `libvirt` will even do that automatically if, on the passthrough configuration, you have set `<hostdev mode='subsystem' type='pci' managed='yes'>`.
对于这两种情况，您都需要确保未加载普通驱动程序。在某些情况下，您可以在运行时通过 `virsh nodedev-detach <pcidevice>` . `libvirt` 如果在直通配置中设置了 `<hostdev mode='subsystem' type='pci' managed='yes'>` .

This usually works fine for e.g. network cards, but some other devices like  GPUs do not like to be unassigned, so there the required step usually is block loading the drivers you do not want to be loaded. In our GPU  example the `nouveau` driver would load and that has to be blocked. To do so you can create a `modprobe` blacklist.
这通常适用于网卡，但其他一些设备（如 GPU）不喜欢取消分配，因此所需的步骤通常是阻止加载您不想加载的驱动程序。在我们的 GPU 示例中， `nouveau` 驱动程序将加载，并且必须阻止。为此， `modprobe` 您可以创建黑名单。

```bash
echo "blacklist nouveau" | sudo tee /etc/modprobe.d/blacklist-nouveau.conf          
echo "options nouveau modeset=0" | sudo tee -a /etc/modprobe.d/blacklist-nouveau.conf
sudo update-initramfs -u                                                         
sudo reboot                                                                      
```

You can check which kernel modules are loaded and available via `lspci -v`:
您可以通过以下方式 `lspci -v` 检查哪些内核模块已加载和可用：

```bash
lspci -v | grep -A 10 " 3D "
```

Which in our example shows:
在我们的示例中显示：

```plaintext
41:00.0 3D controller: NVIDIA Corporation GV100GL [Tesla V100 PCIe 16GB] (rev a1)
...
Kernel modules: nvidiafb, nouveau
```

If the configuration did not work instead it would show:
如果配置不起作用，它将显示：

```plaintext
Kernel driver in use: nouveau
```

## Preparations for mediated devices pass-through - driver 中介设备直通的准备工作 - 驱动程序

For PCI passthrough, the above steps would be all the preparation needed,  but for mediated devices one also needs to install and set up the host  driver. The example here continues with our NVIDIA V100 which is [supported and available from Nvidia](https://docs.nvidia.com/grid/latest/product-support-matrix/index.html#abstract__ubuntu).
对于 PCI 直通，上述步骤将是所需的所有准备工作，但对于中介设备，还需要安装和设置主机驱动程序。这里的示例继续使用我们的 NVIDIA V100，它由 Nvidia 支持和提供。

There is also an Nvidia document about the same steps available on [installation and configuration of vGPU on Ubuntu](https://docs.nvidia.com/grid/latest/grid-vgpu-user-guide/index.html#ubuntu-install-configure-vgpu).
还有一个 Nvidia 文档，介绍了在 Ubuntu 上安装和配置 vGPU 的相同步骤。

Once you have the drivers from Nvidia, like `nvidia-vgpu-ubuntu-470_470.68_amd64.deb`, then install them and check (as above) that that driver is loaded. The one you need to see is `nvidia_vgpu_vfio`:
获得 Nvidia 的驱动程序后，例如 `nvidia-vgpu-ubuntu-470_470.68_amd64.deb` ，然后安装它们并检查（如上所述）该驱动程序是否已加载。你需要看到的是 `nvidia_vgpu_vfio` ：

```bash
lsmod | grep nvidia
```

Which we can see in the output:
我们可以在输出中看到：

```plaintext
nvidia_vgpu_vfio       53248  38
nvidia              35282944  586 nvidia_vgpu_vfio
mdev                   24576  2 vfio_mdev,nvidia_vgpu_vfio
drm                   491520  6 drm_kms_helper,drm_vram_helper,nvidia
```

> **Note**: 注意：
>  While it works without a vGPU manager, to get the full capabilities you’ll need to configure the [vGPU manager (that came with above package)](https://docs.nvidia.com/grid/latest/grid-vgpu-user-guide/index.html#install-vgpu-package-ubuntu) and a license server so that each guest can get a license for the vGPU provided to it. Please see [Nvidia’s documentation for the license server](https://docs.nvidia.com/grid/ls/latest/grid-license-server-user-guide/index.html). While not officially supported on Linux (as of Q1 2022), it’s worthwhile to note that it runs fine on Ubuntu with `sudo apt install unzip default-jre tomcat9 liblog4j2-java libslf4j-java` using `/var/lib/tomcat9` as the server path in the license server installer.
> 虽然它没有 vGPU 管理器即可工作，但要获得全部功能，您需要配置 vGPU  管理器（随上述软件包一起提供）和许可证服务器，以便每个客户机都可以获得提供给它的 vGPU 的许可证。请参阅 Nvidia  的许可证服务器文档。虽然在 Linux 上不受官方支持（截至 2022 年第一季度），但值得注意的是，它在 Ubuntu `sudo apt install unzip default-jre tomcat9 liblog4j2-java libslf4j-java` `/var/lib/tomcat9` 上运行良好，用作许可证服务器安装程序中的服务器路径。
>
> It’s also worth mentioning that the Nvidia license server went [EOL on 31 July 2023](https://docs.nvidia.com/grid/news/vgpu-software-license-server-eol-notice/index.html). At that time, it was replaced by the [NVIDIA License System](https://docs.nvidia.com/license-system/latest/nvidia-license-system-quick-start-guide/index.html).
> 还值得一提的是，Nvidia 许可证服务器于 2023 年 7 月 31 日停产。当时，它被NVIDIA许可证系统所取代。

Here is an example of those when running fine:
以下是运行正常时的示例：

```plaintext
# general status
$ systemctl status nvidia-vgpu-mgr
     Loaded: loaded (/lib/systemd/system/nvidia-vgpu-mgr.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2021-09-14 07:30:19 UTC; 3min 58s ago
    Process: 1559 ExecStart=/usr/bin/nvidia-vgpu-mgr (code=exited, status=0/SUCCESS)
   Main PID: 1564 (nvidia-vgpu-mgr)
      Tasks: 1 (limit: 309020)
     Memory: 1.1M
     CGroup: /system.slice/nvidia-vgpu-mgr.service
             └─1564 /usr/bin/nvidia-vgpu-mgr

Sep 14 07:30:19 node-watt systemd[1]: Starting NVIDIA vGPU Manager Daemon...
Sep 14 07:30:19 node-watt systemd[1]: Started NVIDIA vGPU Manager Daemon.
Sep 14 07:30:20 node-watt nvidia-vgpu-mgr[1564]: notice: vmiop_env_log: nvidia-vgpu-mgr daemon started

# Entries when a guest gets a vGPU passed
Sep 14 08:29:50 node-watt nvidia-vgpu-mgr[2866]: notice: vmiop_log: (0x0): gpu-pci-id : 0x4100
Sep 14 08:29:50 node-watt nvidia-vgpu-mgr[2866]: notice: vmiop_log: (0x0): vgpu_type : Quadro
Sep 14 08:29:50 node-watt nvidia-vgpu-mgr[2866]: notice: vmiop_log: (0x0): Framebuffer: 0x1dc000000
Sep 14 08:29:50 node-watt nvidia-vgpu-mgr[2866]: notice: vmiop_log: (0x0): Virtual Device Id: 0x1db4:0x1252
Sep 14 08:29:50 node-watt nvidia-vgpu-mgr[2866]: notice: vmiop_log: (0x0): FRL Value: 60 FPS
Sep 14 08:29:50 node-watt nvidia-vgpu-mgr[2866]: notice: vmiop_log: ######## vGPU Manager Information: ########
Sep 14 08:29:50 node-watt nvidia-vgpu-mgr[2866]: notice: vmiop_log: Driver Version: 470.68
Sep 14 08:29:50 node-watt nvidia-vgpu-mgr[2866]: notice: vmiop_log: (0x0): vGPU supported range: (0x70001, 0xb0001)
Sep 14 08:29:50 node-watt nvidia-vgpu-mgr[2866]: notice: vmiop_log: (0x0): Init frame copy engine: syncing...
Sep 14 08:29:50 node-watt nvidia-vgpu-mgr[2866]: notice: vmiop_log: (0x0): vGPU migration enabled
Sep 14 08:29:50 node-watt nvidia-vgpu-mgr[2866]: notice: vmiop_log: display_init inst: 0 successful

# Entries when a guest grabs a license
Sep 15 06:55:50 node-watt nvidia-vgpu-mgr[4260]: notice: vmiop_log: (0x0): vGPU license state: Unlicensed (Unrestricted)
Sep 15 06:55:52 node-watt nvidia-vgpu-mgr[4260]: notice: vmiop_log: (0x0): vGPU license state: Licensed

# In the guest the card is then fully recognized and enabled
$ nvidia-smi -a | grep -A 2 "Licensed Product"
    vGPU Software Licensed Product
        Product Name                      : NVIDIA RTX Virtual Workstation
        License Status                    : Licensed
```

A [mediated device](https://www.kernel.org/doc/html/latest/driver-api/vfio-mediated-device.html) is essentially partitioning of a hardware device using firmware and  host driver features. This brings a lot of flexibility and options; in  our example we can split our 16G GPU into 2x8G, 4x4G, 8x2G or 16x1G just as we need it. The following gives an example of how to split it into  two 8G cards for a compute profile and pass those to guests.
中介设备实质上是使用固件和主机驱动程序功能对硬件设备进行分区。这带来了很大的灵活性和选择;在我们的示例中，我们可以根据需要将 16G GPU 拆分为 2x8G、4x4G、8x2G 或 16x1G。下面给出了一个示例，说明如何将其拆分为两个 8G  卡用于计算配置文件，并将其传递给来宾。

Please refer to the [NVIDIA documentation](https://docs.nvidia.com/grid/latest/grid-vgpu-user-guide/index.html#ubuntu-install-configure-vgpu) for advanced tunings and different card profiles.
请参阅 NVIDIA 文档，了解高级调优和不同的显卡配置文件。

The tool for listing and configuring these mediated devices is `mdevctl`:
用于列出和配置这些中介设备的工具是 `mdevctl` ：

```bash
sudo mdevctl types
```

Which will list the available types:
这将列出可用的类型：

```plaintext
...
  nvidia-300
    Available instances: 0
    Device API: vfio-pci
    Name: GRID V100-8C
    Description: num_heads=1, frl_config=60, framebuffer=8192M, max_resolution=4096x2160, max_instance=2
```

Knowing the PCI ID (`0000:41:00.0`) and the mediated device type we want (`nvidia-300`) we can now create those mediated devices:
知道了我们想要的 PCI ID （ `0000:41:00.0` ） 和中介设备类型 （ `nvidia-300` ），我们现在可以创建这些中介设备：

```auto
$ sudo mdevctl define --parent 0000:41:00.0 --type nvidia-300
bc127e23-aaaa-4d06-a7aa-88db2dd538e0
$ sudo mdevctl define --parent 0000:41:00.0 --type nvidia-300
1360ce4b-2ed2-4f63-abb6-8cdb92100085
$ sudo mdevctl start --parent 0000:41:00.0 --uuid bc127e23-aaaa-4d06-a7aa-88db2dd538e0
$ sudo mdevctl start --parent 0000:41:00.0 --uuid 1360ce4b-2ed2-4f63-abb6-8cdb92100085
```

After that, you can check the UUID of your ready mediated devices:
之后，您可以检查准备好的中介设备的 UUID：

```auto
$ sudo mdevctl list -d
bc127e23-aaaa-4d06-a7aa-88db2dd538e0 0000:41:00.0 nvidia-108 manual (active)
1360ce4b-2ed2-4f63-abb6-8cdb92100085 0000:41:00.0 nvidia-108 manual (active)
```

Those UUIDs can then be used to pass the mediated devices to the guest -  which from here is rather similar to the pass through of a full PCI  device.
然后，可以使用这些 UUID 将介导的设备传递给客户机 - 从这里开始，这与完整 PCI 设备的传递非常相似。

## Passing through PCI or mediated devices 通过 PCI 或介导设备

After the above setup is ready one can pass through those devices, in `libvirt` for a PCI passthrough that looks like:
完成上述设置后，可以通过这些设备， `libvirt` 进行如下所示的 PCI 直通：

```auto
<hostdev mode='subsystem' type='pci' managed='yes'>
  <source>
    <address domain='0x0000' bus='0x41' slot='0x00' function='0x0'/>
  </source>
</hostdev>
```

And for mediated devices it is quite similar, but using the UUID.
对于中介设备，它非常相似，但使用 UUID。

```auto
<hostdev mode='subsystem' type='mdev' managed='no' model='vfio-pci' display='on'>
  <source>
    <address uuid='634fc146-50a3-4960-ac30-f09e5cedc674'/>
  </source>
</hostdev>
```

Those sections can be [part of the guest definition](https://libvirt.org/formatdomain.html#usb-pci-scsi-devices) itself, to be added on guest startup and freed on guest shutdown. Or  they can be in a file and used by for hot-add remove if the hardware  device and its drivers support it `virsh attach-device`.
这些部分可以是客户机定义本身的一部分，在客户机启动时添加，并在客户机关闭时释放。或者，如果硬件设备及其驱动程序支持， `virsh attach-device` 它们可以位于文件中并用于热添加删除。

> **Note**: 注意：
>  This works great on Focal, but `type='none'` as well as `display='off'` weren’t available on Bionic. If this level of control is required one would need to consider using the [Ubuntu Cloud Archive](https://wiki.ubuntu.com/OpenStack/CloudArchive) or [Server-Backports](https://launchpad.net/~canonical-server/+archive/ubuntu/server-backports) for a newer stack of the virtualisation components.
> 这在 Focal 上效果很好，但在 `type='none'` `display='off'` Bonic 上也不可用。如果需要这种级别的控制，则需要考虑使用Ubuntu Cloud Archive或Server-Backports来获得较新的虚拟化组件堆栈。

And finally, it might be worth noting that while mediated devices are  becoming more common and known for vGPU handling, they are a general  infrastructure also used (for example) for [s390x vfio-ccw](https://www.kernel.org/doc/html/latest/s390/vfio-ccw.html).
最后，值得注意的是，虽然中介设备正变得越来越普遍，并且以 vGPU 处理而闻名，但它们是一种通用基础设施，也用于（例如）用于 s390x vfio-ccw。

------