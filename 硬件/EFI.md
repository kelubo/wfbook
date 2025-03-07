# EFI

可扩展固件接口（EFI）， 或更新一些的统一可扩展固件接口（Unified EFI，UEFI，本质上是 EFI 2.x），已经开始替代古老的 基本输入/输出系统（BIOS）固件技术。

EFI 是一种固件，是内置于计算机中处理低级任务的软件。

2006 年第一次推出。大多数 x86 和 x86-64 架构的计算机上的 EFI 都包含一个叫做兼容支持模块（CSM）的组件，这使得 EFI 能够使用旧的 BIOS 风格的引导机制来引导操作系统。

UEFI 的一个附加功能,安全启动。此特性旨在最大限度的降低计算机受到 boot kit 病毒感染的风险，这是一种感染计算机引导加载程序的恶意软件。Boot kits 很难检测和删除，阻止它们的运行刻不容缓。支持 EFI 的计算机不一定支持 安全启动，而且支持 EFI 的 x86-64 的计算机也可以禁用 安全启动。

## 安装 Linux
1、 升级固件

2、 了解如何使用固件

3、调整以下固件设置

快速启动 — 此功能可以通过在硬件初始化时使用快捷方式来加快引导过程。有时候会使 USB 设备不能初始化，导致计算机无法从 USB 闪存驱动器或类似的设备启动。

安全启动 — 在启动引导加载程序或内核时遇到问题，可能需要禁用此功能。

CSM/legacy 选项 — 请关闭这些选项。

4、 禁用 Windows 的快速启动功能

不禁用的话会导致文件系统损坏。请注意此功能与固件的快速启动不同。
5、 检查分区表

### 安装

进入 Linux shell 环境执行 ls /sys/firmware/efi 验证当前是否处于 EFI 引导模式。如果你看到一系列文件和目录，表明你已经以 EFI 模式启动，而且可以忽略以下多余的提示；如果没有，表明你是以 BIOS 模式启动的，应当重新检查你的设置。

准备 ESP 分区 — 除了 Mac，EFI 使用 ESP 分区来保存引导加载程序。创建一个大小为 550 MB 的 ESP 分区。给它一个“启动标记”。使用 GPT fdisk（gdisk，cgdisk 或 sgdisk）准备 ESP 分区，给它一个名为 EF00 的类型码。

使用 ESP 分区 — 不同发行版的安装程序以不同的方式辨识 ESP 分区。比如，Debian 和 Ubuntu 的某些版本把 ESP 分区称为“EFI boot partition”，而且不会明确显示它的挂载点（尽管它会在后台挂载）；但是有些发行版，像 Arch 或 Gentoo，需要你去手动挂载。在 Linux 中最标准的 ESP 分区挂载点是 /boot/efi。某些发行版的 /boot 不能用 FAT 分区。因此，当你设置 ESP 分区挂载点时，请将其设置为 /boot/efi。除非 ESP 分区没有，否则不要为其新建文件系统。

设置引导程序的位置 — 某些发行版会询问将引导程序（GRUB）装到何处。如果 ESP 分区按上述内容正确标记，不必理会此问题，但有些发行版仍会询问。请尝试使用 ESP 分区。

其它分区 — 除了 ESP 分区，不再需要其它的特殊分区；你可以设置 根（/）分区，swap 分区，/home 分区，或者其它分区，就像你在 BIOS 模式下安装时一样。

无显示问题 — 2013 年，许多人在 EFI 模式下经常遇到（之后出现的频率逐渐降低）无显示的问题。有时可以在命令行下通过给内核添加 nomodeset 参数解决这一问题。
