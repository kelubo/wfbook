# 操作系统

[TOC]

建议在较新版本的Linux上部署Ceph。建议在具有长期支持的版本上部署。

## Linux Kernel

- **Ceph Kernel Client**

  If you are using the kernel client to map RBD block devices or mount CephFS, the general advice is to use a “stable” or “longterm maintenance” kernel series provided by either http://kernel.org or your Linux distribution on any client hosts.

  如果您使用内核客户机来映射RBD块设备或挂载cephfs，一般的建议是使用其中一个提供的“稳定”或“长期维护”内核系列http://kernel.org或您的Linux发行版在任何客户端主机上。

  For RBD, if you choose to *track* long-term kernels, we currently recommend 4.x-based “longterm maintenance” kernel series or later:对于RBD，如果您选择跟踪长期内核，我们目前建议使用基于4.x的“长期维护”内核系列或更高版本：

  - 4.19.z
  - 4.14.z
  - 5.x

## Platforms

The charts below show how Ceph’s requirements map onto various Linux platforms.  Generally speaking, there is very little dependence on specific distributions aside from the kernel and system initialization package (i.e., sysvinit, systemd).下面的图表显示了Ceph的需求如何映射到各种Linux平台上。一般来说，除了内核和系统初始化包（即sysvinit、systemd）之外，对特定发行版的依赖性很小。

### Octopus (15.2.z)

| Distro   | Release | Code Name     | Kernel       | Notes | Testing |
| -------- | ------- | ------------- | ------------ | ----- | ------- |
| CentOS   | 8       | N/A           | linux-4.18   |       | B, I, C |
| CentOS   | 7       | N/A           | linux-3.10.0 | 4, 5  | B, I    |
| Debian   | 10      | Buster        | linux-4.19   |       | B       |
| RHEL     | 8       | Ootpa         | linux-4.18   |       | B, I, C |
| RHEL     | 7       | Maipo         | linux-3.10.0 |       | B, I    |
| Ubuntu   | 18.04   | Bionic Beaver | linux-4.15   | 4     | B, I, C |
| openSUSE | 15.2    | Leap          | linux-5.3    | 6     |         |
| openSUSE |         | Tumbleweed    |              |       |         |

### Nautilus (14.2.z)

| Distro   | Release | Code Name     | Kernel       | Notes | Testing |
| -------- | ------- | ------------- | ------------ | ----- | ------- |
| CentOS   | 7       | N/A           | linux-3.10.0 | 3     | B, I, C |
| Debian   | 8.0     | Jessie        | linux-3.16.0 | 1, 2  | B, I    |
| Debian   | 9.0     | Stretch       | linux-4.9    | 1, 2  | B, I    |
| RHEL     | 7       | Maipo         | linux-3.10.0 |       | B, I    |
| Ubuntu   | 14.04   | Trusty Tahr   | linux-3.13.0 |       | B, I, C |
| Ubuntu   | 16.04   | Xenial Xerus  | linux-4.4.0  | 3     | B, I, C |
| Ubuntu   | 18.04   | Bionic Beaver | linux-4.15   | 3     | B, I, C |
| openSUSE | 15.1    | Leap          | linux-4.12   | 6     |         |

### Luminous (12.2.z)

| Distro | Release | Code Name    | Kernel       | Notes | Testing |
| ------ | ------- | ------------ | ------------ | ----- | ------- |
| CentOS | 7       | N/A          | linux-3.10.0 | 3     | B, I, C |
| Debian | 8.0     | Jessie       | linux-3.16.0 | 1, 2  | B, I    |
| Debian | 9.0     | Stretch      | linux-4.9    | 1, 2  | B, I    |
| Fedora | 22      | N/A          | linux-3.14.0 |       | B, I    |
| RHEL   | 7       | Maipo        | linux-3.10.0 |       | B, I    |
| Ubuntu | 14.04   | Trusty Tahr  | linux-3.13.0 |       | B, I, C |
| Ubuntu | 16.04   | Xenial Xerus | linux-4.4.0  | 3     | B, I, C |

### Notes

- **1**: using `BlueStore` starting with Luminous, and `XFS` for previous releases with `Filestore`.默认内核有一个旧版本的Btrfs，不建议将其用于 OSD 节点。我们建议从luminal开始使用Blue Store，对于带有Filestore的早期版本，使用XFS。
- **2**: The default kernel has an old Ceph client that we do not recommend for kernel client (kernel RBD or the Ceph file system).  默认内核有一个旧的Ceph client，不建议将其用于内核客户机（kernel RDB 或 Ceph文件系统）。升级到推荐的内核。
- **3**: The default kernel regularly fails in QA when the `Btrfs` file system is used.  We recommend using `BlueStore` starting from Luminous, and `XFS` for previous releases with `Filestore`.当使用Btrfs文件系统时，默认内核在QA中经常失败。我们建议从luminic开始使用Blue Store，对于带有Filestore的早期版本，使用XFS。
- **4**: `btrfs` is no longer tested on this release. We recommend using `bluestore`.btrfs不再在此版本上进行测试。我们建议使用bluestore。
- **5**: Some additional features related to dashboard are not available.与仪表板相关的其他功能不可用。
- **6**: Packages are built regularly, but not distributed by upstream Ceph.软件包定期构建，但不由上游Ceph分发。

### Testing

- **B**: We build release packages for this platform. For some of these platforms, we may also continuously build all Ceph branches and perform basic unit tests.我们为这个平台构建发布包。对于其中一些平台，我们还可以继续构建所有Ceph分支并执行基本单元测试。
- **I**: We do basic installation and functionality tests of releases on this platform.我们在这个平台上进行基本的安装和功能测试。
- **C**: We run a comprehensive functional, regression, and stress test suite on this platform on a continuous basis. This includes development branches, pre-release, and released code.我们在这个平台上连续运行一个全面的功能测试、回归测试和压力测试套件。这包括开发分支、预发布和发布的代码。