# 操作系统

[TOC]

建议在较新版本的Linux上部署Ceph。建议在具有长期支持的版本上部署。

## Linux Kernel

**Ceph Kernel Client**

If you are using the kernel client to map RBD block devices or mount CephFS, the general advice is to use a “stable” or “longterm maintenance” kernel series provided by either http://kernel.org or your Linux distribution on any client hosts.

如果您使用内核客户机来映射RBD块设备或挂载cephfs，一般的建议是使用其中一个提供的“稳定”或“长期维护”内核系列http://kernel.org或您的Linux发行版在任何客户端主机上。

For RBD, if you choose to *track* long-term kernels, we currently recommend 4.x-based “longterm maintenance” kernel series or later:对于RBD，如果您选择跟踪长期内核，我们目前建议使用基于4.x的“长期维护”内核系列或更高版本：

- 4.19.z
- 4.14.z
- 5.x

## Platforms

show how Ceph’s requirements map onto various Linux platforms.  Generally speaking, there is very little dependence on specific distributions aside from the kernel and system initialization package (i.e., sysvinit, systemd).下面的图表显示了Ceph的需求如何映射到各种Linux平台上。一般来说，除了内核和系统初始化包（即sysvinit、systemd）之外，对特定发行版的依赖性很小。

| Release Name | Tag    | CentOS  | Ubuntu           | OpenSUSE C | Debian C |
| ------------ | ------ | ------- | ---------------- | ---------- | -------- |
| Quincy       | 17.2.z | 8 A     | 20.04 A          | 15.3       | 11       |
| Pacific      | 16.2.z | 8 A     | 18.04 C, 20.04 A | 15.2       | 10, 11   |
| Octopus      | 15.2.z | 7 B 8 A | 18.04 C, 20.04 A | 15.2       | 10       |

- **A**: Ceph提供软件包，并对其中的软件进行了全面测试。
- **B**: Ceph提供了软件包，并对其中的软件进行了基本测试。
- **C**: Ceph仅提供软件包。尚未对这些版本进行任何测试。

> Note
>
> **For Centos 7 Users**
>
> `Btrfs` is no longer tested on Centos 7 in the Octopus release. 建议使用`bluestore` 替代。