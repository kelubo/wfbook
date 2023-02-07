# 操作系统

[TOC]

建议在较新版本的 Linux 上部署 Ceph 。建议在具有长期支持的版本上部署。

## Linux Kernel

**Ceph Kernel Client**

如果您使用内核客户端来映射 RBD 块设备或挂载 CephFS，一般的建议是在任何主机上使用由 http://kernel.org 或 Linux 发行版提供的“稳定”或“长期维护”的内核。

对于 RBD，如果选择跟踪长期内核 *track* long-term kernels，我们目前建议使用基于 4.x 的“长期维护”内核系列或更高版本：

- 4.19.z
- 4.14.z
- 5.x

较旧的内核客户端版本可能不支持您的 [CRUSH tunables](https://docs.ceph.com/en/latest/rados/operations/crush-map#tunables) 配置文件或 Ceph 群集的其他较新功能，要求将存储群集配置为禁用这些功能。

## Platform

下面的图表显示了 Ceph 的需求如何映射到各种 Linux 平台上。一般来说，除了内核和系统初始化包（即 sysvinit、systemd）之外，对特定发行版的依赖性很小。

| Release Name | Tag    | CentOS                      | Ubuntu                               | OpenSUSE<sup>C</sup> | Debian<sup>C</sup> |
| ------------ | ------ | --------------------------- | ------------------------------------ | -------------------- | ------------------ |
| Quincy       | 17.2.z | 8<sup>A</sup>               | 20.04<sup>A</sup>                    | 15.3                 | 11                 |
| Pacific      | 16.2.z | 8<sup>A</sup>               | 18.04<sup>C</sup>, 20.04<sup>A</sup> | 15.2                 | 10, 11             |
| Octopus      | 15.2.z | 7<sup>B</sup> 8<sup>A</sup> | 18.04<sup>C</sup>, 20.04<sup>A</sup> | 15.2                 | 10                 |

- **A**: Ceph提供软件包，并对其中的软件进行了全面测试。
- **B**: Ceph提供了软件包，并对其中的软件进行了基本测试。
- **C**: Ceph仅提供软件包。尚未对这些版本进行任何测试。

> **Note：**
>
> 从 Octopus 版本起，`Btrfs` 不再在 Centos 7 上进行测试。建议使用 `bluestore` 替代。