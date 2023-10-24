# Install Virtualization for Block Device

[TOC]

## 概述

如果打算使用 Ceph 块设备和 Ceph 存储集群作为虚拟机（VM）或云平台的后端，QEMU/KVM 和 `libvirt` 包对于启用 VM 和云平台非常重要。VM 的示例包括：QEMU/KVM 、XEN 、VMWare 、LXC 、VirtualBox 等。云平台的示例包括 OpenStack 、CloudStack 、OpenNebula 等。

![](../../../Image/d/ditaa-85d66af9d7a5acde5cc8e5621fd253044b078e0d.png)

## 安装 QEMU

QEMU KVM 可以通过 `librbd` 与 Ceph Block设备交互，这是将 Ceph 与云平台一起使用的重要功能。

### Debian 包

QEMU 软件包被整合到 Ubuntu 12.04 Precise Pangolin 和更高版本中。要安装 QEMU ，请执行以下操作：

```bash
apt-get install qemu
```

### RPM 包

1. 更新存储库。

   ```bash
   yum update
   ```

2. 安装 QEMU 。

   ```bash
   yum install qemu-kvm qemu-kvm-tools qemu-img
   ```

3. 安装额外的 QEMU 包（可选）：

   ```bash
   yum install qemu-guest-agent qemu-guest-agent-win32
   ```

### 构建 QEMU

要从源代码构建 QEMU，请使用以下过程：

```bash
cd {your-development-directory}
git clone git://git.qemu.org/qemu.git
cd qemu
./configure --enable-rbd
make; make install
```

## 安装 libvirt

要在 Ceph 中使用 `libvirt` ，必须有一个正在运行的 Ceph 存储集群，并且必须安装并配置了 QEMU 。

### Debian 包

`libvirt` 软件包被合并到 Ubuntu 12.04 Precise Pangolin 和 Ubuntu 的更高版本中。要在这些发行版上安装 libvirt ，请执行以下操作：

```bash
apt-get update && apt-get install libvirt-bin
```

### RPM 包

要将 `libvirt` 与 Ceph 存储集群一起使用，必须具有正在运行的 Ceph 存储集群，并且还必须安装支持 rbd 格式的 QEMU 版本。

`libvirt` 包被合并到最近的 CentOS/RHEL 发行版中。要安装  `libvirt` ，请执行以下操作：

```bash
yum install libvirt
```

### 构建 `libvirt`

要从源代码构建 `libvirt` ，请克隆 `libvirt` 存储库并使用 AutoGen 生成构建。然后，执行 `make` 和 `make install` 来完成安装。举例来说：

```bash
git clone git://libvirt.org/libvirt.git
cd libvirt
./autogen.sh
make
sudo make install
```
