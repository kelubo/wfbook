# 操作系统

[TOC]

建议在较新的 Linux 发行版上部署 Ceph ；建议选择长期支持的版本。

## Linux 内核

- **Ceph 内核态客户端**

  当前我们推荐：

  - 4.1.4 or later
  - 3.16.3 or later (rbd deadlock regression in 3.16.[0-2])
  - *NOT* v3.15.* (rbd deadlock regression)
  - 3.14.*

  如果您坚持用很旧的，可以考虑这些：

  - 3.10.*

  firefly (CRUSH_TUNABLES3) 这个版本的可调选项到 3.15 版才开始支持。

- **B-tree 文件系统（Btrfs）**

  如果您想在 `btrfs` 上运行 Ceph ，我们推荐使用一个最新的 Linux 内核（ 3.14 或更新）。

## 系统平台

下面的表格展示了 Ceph 需求和各种 Linux 发行版的对应关系。一般来说， Ceph 对内核和系统初始化阶段的依赖很少（如 sysvinit 、 upstart 、 systemd ）。

### Infernalis (9.1.0)

| Distro | Release | Code Name   | Kernel       | Notes | Testing |
| ------ | ------- | ----------- | ------------ | ----- | ------- |
| CentOS | 7       | N/A         | linux-3.10.0 |       | B, I, C |
| Debian | 8.0     | Jessie      | linux-3.16.0 | 1, 2  | B, I    |
| Fedora | 22      | N/A         | linux-3.14.0 |       | B, I    |
| RHEL   | 7       | Maipo       | linux-3.10.0 |       | B, I    |
| Ubuntu | 14.04   | Trusty Tahr | linux-3.13.0 |       | B, I, C |

### Hammer (0.94)

| Distro | Release | Code Name        | Kernel       | Notes | Testing |
| ------ | ------- | ---------------- | ------------ | ----- | ------- |
| CentOS | 6       | N/A              | linux-2.6.32 | 1, 2  |         |
| CentOS | 7       | N/A              | linux-3.10.0 |       | B, I, C |
| Debian | 7.0     | Wheezy           | linux-3.2.0  | 1, 2  |         |
| Ubuntu | 12.04   | Precise Pangolin | linux-3.2.0  | 1, 2  |         |
| Ubuntu | 14.04   | Trusty Tahr      | linux-3.13.0 |       | B, I, C |

### Firefly (0.80)

| Distro | Release | Code Name         | Kernel       | Notes   | Testing |
| ------ | ------- | ----------------- | ------------ | ------- | ------- |
| CentOS | 6       | N/A               | linux-2.6.32 | 1, 2    | B, I    |
| CentOS | 7       | N/A               | linux-3.10.0 |         | B       |
| Debian | 6.0     | Squeeze           | linux-2.6.32 | 1, 2, 3 | B       |
| Debian | 7.0     | Wheezy            | linux-3.2.0  | 1, 2    | B       |
| Fedora | 19      | Schrödinger’s Cat | linux-3.10.0 |         | B       |
| Fedora | 20      | Heisenbug         | linux-3.14.0 |         | B       |
| RHEL   | 6       | Santiago          | linux-2.6.32 | 1, 2    | B, I, C |
| RHEL   | 7       | Maipo             | linux-3.10.0 |         | B, I, C |
| Ubuntu | 12.04   | Precise Pangolin  | linux-3.2.0  | 1, 2    | B, I, C |
| Ubuntu | 14.04   | Trusty Tahr       | linux-3.13.0 |         | B, I, C |

### 附注

- **1**: 默认内核 `btrfs` 版本较老，不推荐用于 `ceph-osd` 存储节点；要升级到推荐的内核，或者改用 `xfs` 、 `ext4` 。
- **2**: 默认内核带的 Ceph 客户端较老，不推荐做内核空间客户端（内核 RBD 或 Ceph 文件系统），请升级到推荐内核。
- **3**: 默认内核或已安装的 `glibc` 版本若不支持 `syncfs(2)` 系统调用，同一台机器上使用 `xfs` 或 `ext4` 的 `ceph-osd` 守护进程性能不会如愿。

### 测试版

- **B**: 我们会为此平台构建发布包。对其中的某些平台，可能也会持续地编译所有分支、做基本单元测试。
- **I**: 我们在这个平台上做基本的安装和功能测试。
- **C**: 我们在这个平台上持续地做全面的功能、退化、压力测试，包括开发分支、预发布版本、正式发布版本。

# OS Recommendations

## Ceph Dependencies

As a general rule, we recommend deploying Ceph on newer releases of Linux. We also recommend deploying on releases with long-term support.

### Linux Kernel

- **Ceph Kernel Client**

  If you are using the kernel client to map RBD block devices or mount CephFS, the general advice is to use a “stable” or “longterm maintenance” kernel series provided by either http://kernel.org or your Linux distribution on any client hosts.

  For RBD, if you choose to *track* long-term kernels, we currently recommend 4.x-based “longterm maintenance” kernel series:

  - 4.19.z
  - 4.14.z

  For CephFS, see the section about [Mounting CephFS using Kernel Driver](https://docs.ceph.com/docs/master/cephfs/mount-using-kernel-driver#which-kernel-version) for kernel version guidance.

  Older kernel client versions may not support your [CRUSH tunables](https://docs.ceph.com/docs/master/rados/operations/crush-map#tunables) profile or other newer features of the Ceph cluster, requiring the storage cluster to be configured with those features disabled.

## Platforms

The charts below show how Ceph’s requirements map onto various Linux platforms.  Generally speaking, there is very little dependence on specific distributions aside from the kernel and system initialization package (i.e., sysvinit, upstart, systemd).

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

- **1**: The default kernel has an older version of `btrfs` that we do not recommend for `ceph-osd` storage nodes.  We recommend using `bluestore` starting from Mimic, and `XFS` for previous releases with `filestore`.
- **2**: The default kernel has an old Ceph client that we do not recommend for kernel client (kernel RBD or the Ceph file system).  Upgrade to a recommended kernel.
- **3**: The default kernel regularly fails in QA when the `btrfs` file system is used.  We recommend using `bluestore` starting from Mimic, and `XFS` for previous releases with `filestore`.
- **4**: `btrfs` is no longer tested on this release. We recommend using `bluestore`.
- **5**: Some additional features related to dashboard are not available.
- **6**: Building packages are built regularly, but not distributed by Ceph.

### Testing

- **B**: We build release packages for this platform. For some of these platforms, we may also continuously build all ceph branches and exercise basic unit tests.
- **I**: We do basic installation and functionality tests of releases on this platform.
- **C**: We run a comprehensive functional, regression, and stress test suite on this platform on a continuous basis. This includes development branches, pre-release, and released code.