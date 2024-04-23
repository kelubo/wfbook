# QEMU

[TOC]

QEMU 是一个机器仿真器，可以在不同的机器上为一台机器运行操作系统和程序。但是，它更常用作与 KVM 内核组件协作的虚拟化器。在这种情况下，它使用硬件虚拟化技术来虚拟化 guest 。

尽管 QEMU 具有命令行界面和监视器，用于与正在运行的客户机进行交互，但它们通常仅用于开发目的。[libvirt](https://ubuntu.com/server/docs/virtualisation-with-qemu#libvirt) provides an abstraction from specific versions and hypervisors and encapsulates some workarounds and best practices.libvirt 提供了从特定版本和虚拟机管理程序中抽象出来的，并封装了一些变通方法和最佳实践。

## 运行 QEMU/KVM

虽然有更用户友好和舒适的方法，但开始使用 QEMU 的最快方法是直接从 netboot ISO 运行它。您可以通过运行以下命令来实现此目的：

> **Warning**:
>
> Multipass and UVTool are much better ways to get actual guests easily.
> 此示例仅用于说明目的 - 通常不建议在不验证校验和的情况下使用它。Multipass 和 UVTool 是轻松吸引实际客人的更好方式。

```bash
qemu-system-x86_64 -enable-kvm -cdrom http://archive.ubuntu.com/ubuntu/dists/bionic-updates/main/installer-amd64/current/images/netboot/mini.iso
```

Downloading the ISO provides for faster access at runtime.下载 ISO 可在运行时更快地访问。现在可以为 VM 分配空间：

```bash
qemu-img create -f qcow2 disk.qcow 5G
```

然后，可以通过添加 `-drive file=disk.qcow,format=qcow2` 参数来使用刚刚分配给存储的磁盘空间：

这些工具可以做更多的事情。还可以通过大量的辅助工具使它们更适合特定的用例和需求 - 例如，通过 libvirt 用于 UI 驱动的 virt-manager。但总的来说，它归结为：

```bash
qemu-system-x86_64 options image[s]
```

## 创建具有多达 1024 个 vCPU 的 QEMU 虚拟机

在很长一段时间里，QEMU 只支持启动具有 288 个或更少 vCPU 的虚拟机。虽然这在十年前是可以接受的，但现在更常见的是看到具有 300+  物理内核的处理器可用。因此，QEMU 已修改为支持最多具有 1024 个 vCPU  的虚拟机。需要注意的是，用户必须提供一些特定的（并且不是微不足道的）命令行选项才能启用这样的功能。

### 支持的 QEMU 版本

目前，以下 QEMU 版本中支持具有超过 288 个 vCPU 的 VM：

- QEMU 6.2 (Ubuntu 22.04 Jammy)*****
- QEMU 8.0.4 (Ubuntu 23.10 Mantic)*****
- QEMU 8.2.1 (Ubuntu 24.04 Noble)

*****  在这种情况下，需要使用特殊的 QEMU 机器类型。

从 Ubuntu 24.04 Noble 开始，原生支持超过 288 个 vCPU，使用常规 `ubuntu` 机器类型应该开箱即用。

### Ubuntu 22.04 Jammy

如果在 Jammy 上使用 QEMU，并且想要创建具有超过 288 个 vCPU 的 VM，则需要使用特殊 `pc-q35-jammy-maxcpus` 类型或 `pc-i440fx-jammy-maxcpus` 计算机类型。

命令行需要从以下位置开始：

```bash
qemu-system-x86_64 -M pc-q35-jammy-maxcpus,accel=kvm,kernel-irqchip=split -device intel-iommu,intremap=on -smp cpus=300,maxcpus=300 ...
```

在上面的示例中，虚拟机将使用 300 个 vCPU 和计算机 `pc-q35-jammy-maxcpus` 类型启动。可以根据用例调整选项。

`kernel-irqchip=split -device intel-iommu,intremap=on` 命令行选项是必需的，以确保使用具有中断映射的虚拟 IOMMU 创建 VM。由于此方案中存在一些特殊性，因此需要这样做。

请注意，后续版本的 Ubuntu 支持 Jammy 的两种机器类型，因此应该能够毫无问题地将虚拟机迁移到 Ubuntu 中较新版本的 QEMU。

### Ubuntu 23.10 Mantic

如果您在 Mantic 上使用 QEMU，则特殊机器类型的命名方式与 Jammy 的命名方式类似： `pc-q35-mantic-maxcpus` 或 `pc-i440fx-mantic-maxcpus` .因此，要在 Mantic 上创建支持超过 288 个 vCPU 的虚拟机的命令行应从以下位置开始：

```bash
qemu-system-x86_64 -M pc-q35-mantic-maxcpus,accel=kvm,kernel-irqchip=split -device intel-iommu,intremap=on -smp cpus=300,maxcpus=300 ...
```

在上面的示例中，虚拟机将使用 300 个 vCPU 和计算机 `pc-q35-mantic-maxcpus` 类型启动。可以根据用例调整选项。

`kernel-irqchip=split -device intel-iommu,intremap=on` 命令行选项是必需的，以确保使用具有中断映射的虚拟 IOMMU 创建 VM。由于此方案中存在一些特殊性，因此需要这样做。

请注意，Mantic 的两种机器类型在后续版本的 Ubuntu 中都受支持，因此您应该能够毫无问题地将虚拟机迁移到 Ubuntu 中较新版本的 QEMU。如上一节所述，还可以在 Mantic 上使用特殊的 Jammy 机器类型创建虚拟机。

### Ubuntu 24.04 Noble

从 Noble 开始，常规 `ubuntu` 机器类型支持多达 1024 个开箱即用的 vCPU，这简化了用于创建此类虚拟机的命令：

```bash
qemu-system-x86_64 -M ubuntu,accel=kvm,kernel-irqchip=split -device intel-iommu,intremap=on -smp cpus=300,maxcpus=300 ...
```

尽管现在可以使用常规计算机类型来启动虚拟机，但仍需要提供一些特殊的命令行选项，以确保使用具有中断映射的虚拟 IOMMU 创建 VM。

## 在 QEMU 上引导 ARM64 虚拟机

Ubuntu ARM64 映像可以在 QEMU 中运行。可以完全模拟（例如在 x86 主机上）执行此操作，或者如果有 ARM64 主机，则使用 KVM 进行加速。

> **Note**: 
>  这需要 Ubuntu 20.04 或更高版本

### 安装 QEMU

第一步是安装 `qemu-system-arm` 软件包，无论 ARM64 虚拟机将在哪里运行，都需要完成此操作：

```bash
sudo apt install qemu-system-arm
```

### 创建必要的支持文件

创建一个特定于 VM 的闪存卷来存储 NVRAM 变量，这是引导 EFI 固件时所必需的：

```bash
truncate -s 64m varstore.img
```

还需要将 ARM UEFI 固件复制到更大的文件中：

```bash
truncate -s 64m efi.img
dd if=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd of=efi.img conv=notrunc
```

### 获取 Ubuntu 云镜像

需要获取要在虚拟机中使用的 Ubuntu 云映像的 ARM64 变体。可以前往 Ubuntu 云官方镜像网站，选择 Ubuntu 版本，然后下载文件名以 `-arm64.img` 结尾的变体。例如，如果要使用最新的 Jammy 云映像，则应下载名为 `ubuntu-22.04-server-cloudimg-arm64.img` .

### Run QEMU natively on an ARM64 host 在 ARM64 主机上本机运行 QEMU

如果有权访问 ARM64 主机，则应该能够在该主机中创建并启动 ARM64 虚拟机。请注意，以下命令假定您已经设置了要供虚拟机使用的网桥。

```bash
sudo qemu-system-aarch64 \
 -enable-kvm \
 -m 1024 \
 -cpu host \
 -M virt \
 -nographic \
 -drive if=pflash,format=raw,file=efi.img,readonly=on \
 -drive if=pflash,format=raw,file=varstore.img \
 -drive if=none,file=jammy-server-cloudimg-arm64.img,id=hd0 \
 -device virtio-blk-device,drive=hd0 -netdev type=tap,id=net0 \
 -device virtio-net-device,netdev=net0
```

### 在 x86 上运行模拟的 ARM64 VM

还可以在 x86 主机上模拟 ARM64 虚拟机。为此，请执行以下操作：

```bash
sudo qemu-system-aarch64 \
 -m 2048\
 -cpu max \
 -M virt \
 -nographic \
 -drive if=pflash,format=raw,file=efi.img,readonly=on \
 -drive if=pflash,format=raw,file=varstore.img \
 -drive if=none,file=jammy-server-cloudimg-arm64.img,id=hd0 \
 -device virtio-blk-device,drive=hd0 \
 -netdev type=tap,id=net0 \
 -device virtio-net-device,netdev=net0
```

### 故障排除

#### No output and no response 无输出，无响应

aligning your host and  guest release versions may help. For example, if you generated `efi.img` on Focal but want to emulate Jammy (with the Jammy cloud image), the firmware may not be fully compatible. Generating `efi.img` on Jammy when emulating Jammy with the Jammy cloud image may help.
如果上述 QEMU 命令未输出，则对齐主机和客户机版本可能会有所帮助。例如，如果在 Focal 上生成 `efi.img` ，但想要模拟 Jammy（使用 Jammy 云映像），则固件可能不完全兼容。使用 Jammy 云映像模拟 Jammy 时，在 Jammy 上生成 `efi.img` 可能会有所帮助。