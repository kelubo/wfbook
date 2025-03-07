# 操作系统

[TOC]

## 概述

作为一般规则，建议在较新版本的 Linux 上部署 Ceph 。建议在具有长期支持的版本上部署。

## Linux Kernel

**Ceph Kernel Client**

如果使用内核客户端来映射 RBD 块设备或挂载 CephFS，一般的建议是在任何主机上使用由 http://kernel.org 或 Linux 发行版提供的“稳定”或“长期维护”的内核。

对于 RBD，如果选择跟踪长期内核 *track* long-term kernels，建议至少使用基于 4.19 的“长期维护”内核系列或更高版本。

较旧的内核客户端版本可能不支持 [CRUSH tunables](https://docs.ceph.com/en/latest/rados/operations/crush-map#tunables) 配置文件或 Ceph 群集的其他较新功能，需要将存储群集配置为禁用这些功能。对于 RBD，5.3 版本的内核或 CentOS 8.2 是合理支持 RBD image 功能所需的最低要求。

## Platform

下面的图表显示了 Ceph 为哪些 Linux 平台提供了软件包，以及 Ceph 在哪些平台上进行了测试。

Ceph 不需要特定的 Linux 发行版。Ceph 可以在任何包含受支持内核和受支持的系统启动框架的发行版上运行，例如 sysvinit 或 systemd 。Ceph 有时会被移植到非 Linux 系统，但核心 Ceph 工作不支持这些系统。

|               | Squid(19.2.z) | Reef (18.2.z) | Quincy (17.2.z) | Pacific (16.2.z) | Octopus (15.2.z) |
| ------------- | ------------- | ------------- | --------------- | ---------------- | ---------------- |
| Centos 7      |               |               |                 |                  | B                |
| Centos 8      |               |               |                 |                  |                  |
| Centos 9      | A             | A             | A 1             |                  |                  |
| Debian 10     |               | C             |                 | C                | C                |
| Debian 11     |               | C             | C               | C                |                  |
| Debian 12     | C             | C             |                 |                  |                  |
| OpenSUSE 15.2 |               | C             |                 | C                | C                |
| OpenSUSE 15.3 |               | C             | C               |                  |                  |
| Ubuntu 18.04  |               |               |                 | C                | C                |
| Ubuntu 20.04  |               | A             | A               | A                | A                |
| Ubuntu 22.04  | A             | A             |                 |                  |                  |

- **A**: Ceph 提供软件包，并对其中的软件进行了全面测试。
- **B**: Ceph 提供了软件包，并对其中的软件进行了基本测试。
- **C**: Ceph 仅提供软件包。尚未对这些版本进行任何测试。
- **1**: 已从 17.2.8 版开始在 Centos 9 上对 Quincy 进行了测试。

### Container Hosts

下表显示了支持 Ceph 官方容器镜像的操作系统。

|               | Squid (19.2.z) | Reef (18.2.z) | Quincy (17.2.z) |
| ------------- | -------------- | ------------- | --------------- |
| Centos 7      |                |               |                 |
| Centos 8      |                |               |                 |
| Centos 9      | H              | H             | H               |
| Debian 10     |                |               |                 |
| Debian 11     |                |               |                 |
| OpenSUSE 15.2 |                |               |                 |
| OpenSUSE 15.3 |                |               |                 |
| Ubuntu 18.04  |                |               |                 |
| Ubuntu 20.04  |                |               |                 |
| Ubuntu 22.04  | H              | H             |                 |

- **H**: Ceph tests this distribution as a container host.
  **H**：Ceph 作为容器主机测试此发行版。

> Note 注意
>
> See the list of QAed container hosts in the Ceph repository here: [List of Container Hosts](https://github.com/ceph/ceph/tree/main/qa/distros/supported-container-hosts).
> 在此处查看 Ceph 存储库中 QAed 容器主机的列表： [容器主机列表](https://github.com/ceph/ceph/tree/main/qa/distros/supported-container-hosts)。

> **Note：**
>
> 从 Octopus 版本起，`Btrfs` 不再在 Centos 7 上进行测试。建议使用 `bluestore` 替代。