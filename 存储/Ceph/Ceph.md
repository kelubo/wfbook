# Ceph

[TOC]

## Ceph架构
**Rados**

核心组件，提供高可靠、高可扩展、高性能的分布式对象存储架构，利用本地文件系统存储对象。 

**Client** 

**RBD**

**Radosgw**

**Librados**

**Cephfs**  

![](../../Image/ceph.png)

## Ceph组件
<<<<<<< HEAD
最简的 Ceph 存储集群至少要一个监视器和两个 OSD 守护进程，只有运行 Ceph 文件系统时,元数据服务器才是必需的。  

**OSD(对象存储守护进程，Object Storage Daemon):**  

存储数据，处理数据复制、恢复、回填、重均衡，并向监视器提供邻居的心跳信息。 
![](../../Image/ceph-topo.jpg)

**Monitor:**

维护着各种集群状态图，包括监视器图、OSD图、归置组(PG)图和CRUSH图。  

**MDS(元数据服务器，Metadata Daemon)：**

存储元数据。缓存和同步元数据，管理名字空间。

## 硬件配置

### CPU
元数据服务器对CPU敏感，CPU性能尽可能高。 
OSD需要一定的处理能力，CPU性能要求较高。
监视器对 CPU 不敏感。

### 内存
元数据服务器和监视器对内存要求较高，至少每进程1GB。  
OSD对内存要求较低，至少每进程500MB。但在恢复期间占用内存比较大（如每进程每 TB 数据需要约 1GB  内存）。通常内存越多越好。  

### 数据存储
建议用容量大于1TB的硬盘。  
每个OSD守护进程占用一个驱动器。  
分别在单独的硬盘运行操作系统、OSD数据和OSD日志。  
SSD顺序读写性能很重要。  
SSD可用于存储OSD的日志。 `osd journal` 选项的默认值是 `/var/lib/ceph/osd/$cluster-$id/journal` ，可以把它挂载到一个 SSD 或 SSD 分区。

不顾分区而在单个硬盘上运行多个OSD，这样**不明智**！
不顾分区而在运行了OSD的硬盘上同时运行监视器或元数据服务器也**不明智**！

### 其他注意事项

可以在同一主机上运行多个 OSD ，但要确保 OSD 硬盘总吞吐量不超过为客户端提供读写服务所需的网络带宽；还要考虑集群在每台主机上所存储的数据占总体的百分比，如果一台主机所占百分比太大而它挂了，就可能导致诸如超过 `full ratio` 的问题，此问题会使 Ceph 中止运作以防数据丢失。

如果每台主机运行多个 OSD ，也得保证内核是最新的。

OSD 数量较多（如 20 个以上）的主机会派生出大量线程，尤其是在恢复和重均衡期间。很多 Linux 内核默认的最大线程数较小（如 32k 个），如果遇到了这类问题，可以把 `kernel.pid_max` 值调高些。理论最大值是 4194303 。例如把下列这行加入 `/etc/sysctl.conf` 文件：

```
kernel.pid_max = 4194303
```

### Ceph网络
建议每台服务器至少两个千兆网卡，分别用于公网(前端)和集群网络(后端)。集群网络用于处理有数据复制产生的额外负载，而且可用防止拒绝服务攻击。考虑部署万兆网络。

![](../../Image/ceph_network.png)

### 最低硬件推荐(小型生产集群及开发集群)

#### Ceph-osd
**CPU:**  
>* 1x 64-bit AMD-64
>* 1x 32-bit ARM dual-core or better
>* 1x i386 dual-core  

**RAM:**  
~1GB for 1TB of storage per daemon  
**Volume Storage:**  
1x storage drive per daemon  
**Journal:**  
1x SSD partition per daemon (optional)  
**Network:**  
2x 1GB Ethernet NICs

#### Ceph-mon
**CPU:**  
>* 1x 64-bit AMD-64/i386
>* 1x 32-bit ARM dual-core or better
>* 1x i386 dual-core  

**RAM:**  
1GB per daemon  
**Disk Space:**  
10GB per daemon  
**Network:**  
2x 1GB Ethernet NICs

#### Ceph-mds
**CPU:**  
>* 1x 64-bit AMD-64 quad-core
>* 1x 32-bit ARM quad-core
>* 1x i386 quad-core  

**RAM:**  
1GB minimum per daemon  
**Disk Space:**  
1MB per daemon  
**Network:**  
2x 1GB Ethernet NICs
### 生产集群
#### Dell PowerEdge R510
**CPU：**  
2x 64-bit quad-core Xeon CPUs  
**RAM:**  
16GB  
**Volume Storage:**  
8x 2TB drives.1 OS,7 Storage  
**Client Network:**  
2x 1GB Ethernet NICs  
**OSD Network:**  
2x 1GB Ethernet NICs  
**Mgmt. Network:**  
2x 1GB Ethernet NICs
#### Dell PowerEdge R515
**CPU：**  
1x hex-core Opteron CPU  
**RAM:**  
16GB  
**Volume Storage:**  
12x 3TB drives.Storage  
**OS Storage:**  
1x 500GB drive. Operating System.  
**Client Network:**  
2x 1GB Ethernet NICs  
**OSD Network:**  
2x 1GB Ethernet NICs  
**Mgmt. Network:**  
2x 1GB Ethernet NICs
## 推荐操作系统
### Ceph 依赖
#### Linux内核
**Ceph内核态客户端：**  
>* v3.16.3 or later (rbd deadlock regression in v3.16.[0-2])  
>* NOT v3.15.* (rbd deadlock regression)  
>* V3.14.*  
>* v3.6.6 or later in the v3.6 stable series  
>* v3.4.20 or later in the v3.4 stable series  

**btrfs:**  
v3.14或更新
### 系统平台(FIREFLY 0.80)
| Distro | Release | Code Name | Kernel | Notes | Testing |
|--------|---------|-----------|--------|-------|---------|
| Ubuntu | 12.04 | Precise Pangolin | linux-3.2.0 | 1,2 | B,I,C |
| Ubuntu | 14.04 | Trusty Tahr | linux-3.13.0 |  | B,I,C |
| Debian | 6.0 | Squeeze | linux-2.6.32 | 1,2,3 | B |
| Debian | 7.0 | Wheezy | linux-3.2.0 | 1,2 | B |
| CentOS | 6 | N/A | linux-2.6.32 | 1,2 | B,I |
| RHEL | 6 |  | linux-2.6.32 | 1,2 | B,I,C |
| RHEL | 7 |  | linux-3.10.0 |  | B,I,C |
| Fedora | 19.0 | Schrodinger's Cat | linux-3.10.0 |  | B |
| Fedora | 20.0 | Heisenbug | linux-3.14.0 |  | B |

Note:  

>* 1:默认内核btrfs版本较老，不推荐用于ceph-osd存储节点；要升级到推荐的内核，或者改用xfs,ext4
>* 2:默认内核带的 Ceph 客户端较老，不推荐做内核空间客户端（内核 RBD 或 Ceph 文件系统），请升级到推荐内核。
>* 3:默认内核或已安装的 glibc 版本若不支持 syncfs(2) 系统调用，同一台机器上使用 xfs 或 ext4 的 ceph-osd 守护进程性能不会如愿。  

测试版：

>* B: 我们持续地在这个平台上编译所有分支、做基本单元测试；也为这个平台构建可发布软件包。
>* I: 我们在这个平台上做基本的安装和功能测试。
>* C: 我们在这个平台上持续地做全面的功能、退化、压力测试，包括开发分支、预发布版本、正式发布版本。
=======
最简的 Ceph 存储集群至少要一个 MON 和两个 OSD 守护进程，只有运行 Ceph 文件系统时, MDS 服务器才是必需的。  

**OSD(对象存储守护进程)**  

存储数据，处理数据复制、恢复、回填、重均衡，并通过检查其他OSD 守护进程的心跳来向 Ceph Monitors 提供一些监控信息。通常一个OSD守护进程会被捆绑到集群中的一块物理磁盘上。

当 Ceph 存储集群设定为有2个副本时，至少需要2个 OSD 守护进程，集群才能达到 `active+clean` 状态。

![](../../Image/ceph-topo.jpg)

**MON(Monitor)**  

维护着各种集群状态图，包括MON map、OSD map、PG map 和CRUSH map。所有集群节点都向MON节点汇报状态信息，并分享它们状态中的任何变化。Ceph 保存着发生在Monitors 、 OSD 和 PG上的每一次状态变更的历史信息（称为 epoch ）。

**MDS(元数据服务器)**  

为CephFS文件系统跟踪文件的层次结构和存储元数据。缓存和同步元数据，管理名字空间。不直接提供数据给客户端。使得 POSIX 文件系统的用户们，可以在不对 Ceph 存储集群造成负担的前提下，执行诸如 `ls`、`find` 等基本命令。
>>>>>>> 5658cd99704bab4f76b71fa564725144fec43e33

## 数据流向
Data-->obj-->PG-->Pool-->OSD

![](../../Image/Distributed-Object-Store.png)

## 数据复制

![](../../Image/ceph_write.png)

## 数据重分布
### 影响因素
OSD  
OSD weight  
OSD crush weight
## Ceph应用
**RDB**  
为Glance Cinder提供镜像存储  
提供Qemu/KVM驱动支持  
支持openstack的虚拟机迁移  

**RGW**  
替换swift  
网盘  

**Cephfs**  
提供共享的文件系统存储  
支持openstack的虚拟机迁移
## 部署工具
Ceph-deploy

<<<<<<< HEAD






Ceph uniquely delivers **object, block, and file storage in one unified system**.

| Ceph Object Store RESTful Interface S3- and Swift-compliant APIs S3-style subdomains Unified S3/Swift namespace User management Usage tracking Striped objects Cloud solution integration Multi-site deployment Multi-site replication | Ceph Block Device Thin-provisioned Images up to 16 exabytes Configurable striping In-memory caching Snapshots Copy-on-write cloning Kernel driver support KVM/libvirt support Back-end for cloud solutions Incremental backup Disaster recovery (multisite asynchronous replication) | Ceph File System POSIX-compliant semantics Separates metadata from data Dynamic rebalancing Subdirectory snapshots Configurable striping Kernel driver support FUSE support NFS/CIFS deployable Use with Hadoop (replace HDFS) |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| See [Ceph Object Store](https://ceph.readthedocs.io/en/latest/radosgw) for additional details. | See [Ceph Block Device](https://ceph.readthedocs.io/en/latest/rbd) for additional details. | See [Ceph File System](https://ceph.readthedocs.io/en/latest/cephfs) for additional details. |

Ceph is highly reliable, easy to manage, and free. The power of Ceph can transform your company’s IT infrastructure and your ability to manage vast amounts of data. To try Ceph, see our [Getting Started](https://ceph.readthedocs.io/en/latest/install) guides. To learn more about Ceph, see our [Architecture](https://ceph.readthedocs.io/en/latest/architecture) section.

# Intro to Ceph

Whether you want to provide [Ceph Object Storage](https://ceph.readthedocs.io/en/latest/glossary/#term-ceph-object-storage) and/or [Ceph Block Device](https://ceph.readthedocs.io/en/latest/glossary/#term-ceph-block-device) services to [Cloud Platforms](https://ceph.readthedocs.io/en/latest/glossary/#term-cloud-platforms), deploy a [Ceph File System](https://ceph.readthedocs.io/en/latest/glossary/#term-ceph-file-system) or use Ceph for another purpose, all [Ceph Storage Cluster](https://ceph.readthedocs.io/en/latest/glossary/#term-ceph-storage-cluster) deployments begin with setting up each [Ceph Node](https://ceph.readthedocs.io/en/latest/glossary/#term-ceph-node), your network, and the Ceph Storage Cluster. A Ceph Storage Cluster requires at least one Ceph Monitor, Ceph Manager, and Ceph OSD (Object Storage Daemon). The Ceph Metadata Server is also required when running Ceph File System clients.

![../../_images/37f38700cd784da451becd6718695f086edd0fd2ab5f8e8daf686249096ce7ab.png](https://ceph.readthedocs.io/en/latest/_images/37f38700cd784da451becd6718695f086edd0fd2ab5f8e8daf686249096ce7ab.png)

- **Monitors**: A [Ceph Monitor](https://ceph.readthedocs.io/en/latest/glossary/#term-ceph-monitor) (`ceph-mon`) maintains maps of the cluster state, including the monitor map, manager map, the OSD map, the MDS map, and the CRUSH map.  These maps are critical cluster state required for Ceph daemons to coordinate with each other. Monitors are also responsible for managing authentication between daemons and clients.  At least three monitors are normally required for redundancy and high availability.
- **Managers**: A [Ceph Manager](https://ceph.readthedocs.io/en/latest/glossary/#term-ceph-manager) daemon (`ceph-mgr`) is responsible for keeping track of runtime metrics and the current state of the Ceph cluster, including storage utilization, current performance metrics, and system load.  The Ceph Manager daemons also host python-based modules to manage and expose Ceph cluster information, including a web-based [Ceph Dashboard](https://ceph.readthedocs.io/en/latest/mgr/dashboard/#mgr-dashboard) and [REST API](https://ceph.readthedocs.io/en/latest/mgr/restful).  At least two managers are normally required for high availability.
- **Ceph OSDs**: A [Ceph OSD](https://ceph.readthedocs.io/en/latest/glossary/#term-ceph-osd) (object storage daemon, `ceph-osd`) stores data, handles data replication, recovery, rebalancing, and provides some monitoring information to Ceph Monitors and Managers by checking other Ceph OSD Daemons for a heartbeat. At least 3 Ceph OSDs are normally required for redundancy and high availability.
- **MDSs**: A [Ceph Metadata Server](https://ceph.readthedocs.io/en/latest/glossary/#term-ceph-metadata-server) (MDS, `ceph-mds`) stores metadata on behalf of the [Ceph File System](https://ceph.readthedocs.io/en/latest/glossary/#term-ceph-file-system) (i.e., Ceph Block Devices and Ceph Object Storage do not use MDS). Ceph Metadata Servers allow POSIX file system users to execute basic commands (like `ls`, `find`, etc.) without placing an enormous burden on the Ceph Storage Cluster.

Ceph stores data as objects within logical storage pools. Using the [CRUSH](https://ceph.readthedocs.io/en/latest/glossary/#term-crush) algorithm, Ceph calculates which placement group should contain the object, and further calculates which Ceph OSD Daemon should store the placement group.  The CRUSH algorithm enables the Ceph Storage Cluster to scale, rebalance, and recover dynamically.

| RecommendationsTo begin using Ceph in production, you should review our hardware recommendations and operating system recommendations.  [Hardware Recommendations](https://ceph.readthedocs.io/en/latest/start/hardware-recommendations/) [CPU](https://ceph.readthedocs.io/en/latest/start/hardware-recommendations/#cpu) [RAM](https://ceph.readthedocs.io/en/latest/start/hardware-recommendations/#ram) [Memory](https://ceph.readthedocs.io/en/latest/start/hardware-recommendations/#memory) [Data Storage](https://ceph.readthedocs.io/en/latest/start/hardware-recommendations/#data-storage) [Networks](https://ceph.readthedocs.io/en/latest/start/hardware-recommendations/#networks) [Failure Domains](https://ceph.readthedocs.io/en/latest/start/hardware-recommendations/#failure-domains) [Minimum Hardware Recommendations](https://ceph.readthedocs.io/en/latest/start/hardware-recommendations/#minimum-hardware-recommendations)  [OS Recommendations](https://ceph.readthedocs.io/en/latest/start/os-recommendations/) [Ceph Dependencies](https://ceph.readthedocs.io/en/latest/start/os-recommendations/#ceph-dependencies) [Platforms](https://ceph.readthedocs.io/en/latest/start/os-recommendations/#platforms) | Get Involved You can avail yourself of help or contribute documentation, source code or bugs by getting involved in the Ceph community. [Get Involved in the Ceph Community!](https://ceph.readthedocs.io/en/latest/start/get-involved/) [Documenting Ceph](https://ceph.readthedocs.io/en/latest/start/documenting-ceph/) [Making Contributions](https://ceph.readthedocs.io/en/latest/start/documenting-ceph/#making-contributions) [Documentation Style Guide](https://ceph.readthedocs.io/en/latest/start/documenting-ceph/#documentation-style-guide) |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

# 欢迎来到 Ceph 世界

Ceph 独一无二地在一个统一的系统中同时提供了**对象、块、和文件存储功能**。

| CEPH 对象存储 REST 风格的接口 与 S3 和 Swift 兼容的 API S3 风格的子域 统一的 S3/Swift 命名空间 用户管理 利用率跟踪 条带化对象 云解决方案集成 多站点部署 灾难恢复 | Ceph 块设备 瘦接口支持 映像尺寸最大 16EB 条带化可定制 内存缓存 快照 写时复制克隆 支持内核级驱动 支持 KVM 和 libvirt 可作为云解决方案的后端 增量备份 | Ceph 文件系统 与 POSIX 兼容的语义 元数据独立于数据 动态重均衡 子目录快照 可配置的条带化 有内核驱动支持 有用户空间驱动支持 可作为 NFS/CIFS 部署 可用于 Hadoop （取代 HDFS ） |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 详情见 [Ceph 对象存储](http://docs.ceph.org.cn/radosgw)。    | 详情见 [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd)。      | 详情见 [Ceph 文件系统](http://docs.ceph.org.cn/cephfs)。     |

它可靠性高、管理简单，并且是开源软件。 Ceph 的强大可以改变您公司的 IT 基础架构和海量数据管理能力。想试试 Ceph 的话看[入门](http://docs.ceph.org.cn/start)手册；想深入理解可以看[体系结构](http://docs.ceph.org.cn/architecture)一节。

# Ceph 简介

不管你是想为[*云平台*](http://docs.ceph.org.cn/glossary/#term-48)提供[*Ceph 对象存储*](http://docs.ceph.org.cn/glossary/#term-30)和/或 [*Ceph 块设备*](http://docs.ceph.org.cn/glossary/#term-38)，还是想部署一个 [*Ceph 文件系统*](http://docs.ceph.org.cn/glossary/#term-45)或者把 Ceph 作为他用，所有 [*Ceph 存储集群*](http://docs.ceph.org.cn/glossary/#term-21)的部署都始于部署一个个 [*Ceph 节点*](http://docs.ceph.org.cn/glossary/#term-13)、网络和 Ceph 存储集群。 Ceph 存储集群至少需要一个 Ceph Monitor 和两个 OSD 守护进程。而运行 Ceph 文件系统客户端时，则必须要有元数据服务器（ Metadata Server ）。

![img](http://docs.ceph.org.cn/_images/ditaa-fbe8ee62a8a21a317df92d84a62447c4ecd11e34.png)

- **Ceph OSDs**: [*Ceph OSD 守护进程*](http://docs.ceph.org.cn/glossary/#term-56)（ Ceph OSD ）的功能是存储数据，处理数据的复制、恢复、回填、再均衡，并通过检查其他OSD 守护进程的心跳来向 Ceph Monitors 提供一些监控信息。当 Ceph 存储集群设定为有2个副本时，至少需要2个 OSD 守护进程，集群才能达到 `active+clean` 状态（ Ceph 默认有3个副本，但你可以调整副本数）。
- **Monitors**: [*Ceph Monitor*](http://docs.ceph.org.cn/glossary/#term-ceph-monitor)维护着展示集群状态的各种图表，包括监视器图、 OSD 图、归置组（ PG ）图、和 CRUSH 图。 Ceph 保存着发生在Monitors 、 OSD 和 PG上的每一次状态变更的历史信息（称为 epoch ）。
- **MDSs**: [*Ceph 元数据服务器*](http://docs.ceph.org.cn/glossary/#term-63)（ MDS ）为 [*Ceph 文件系统*](http://docs.ceph.org.cn/glossary/#term-45)存储元数据（也就是说，Ceph 块设备和 Ceph 对象存储不使用MDS ）。元数据服务器使得 POSIX 文件系统的用户们，可以在不对 Ceph 存储集群造成负担的前提下，执行诸如 `ls`、`find` 等基本命令。

Ceph 把客户端数据保存为存储池内的对象。通过使用 CRUSH 算法， Ceph  可以计算出哪个归置组（PG）应该持有指定的对象(Object)，然后进一步计算出哪个 OSD 守护进程持有该归置组。 CRUSH 算法使得  Ceph 存储集群能够动态地伸缩、再均衡和修复。

| 建议开始把 Ceph 用于生产环境前，您应该回顾一下我们的硬件和操作系统推荐。  [硬件推荐](http://docs.ceph.org.cn/start/hardware-recommendations/) [CPU](http://docs.ceph.org.cn/start/hardware-recommendations/#cpu) [RAM内存](http://docs.ceph.org.cn/start/hardware-recommendations/#ram) [数据存储](http://docs.ceph.org.cn/start/hardware-recommendations/#id2) [网络](http://docs.ceph.org.cn/start/hardware-recommendations/#id7) [故障域](http://docs.ceph.org.cn/start/hardware-recommendations/#id8) [最低硬件推荐](http://docs.ceph.org.cn/start/hardware-recommendations/#id9) [生产集群实例](http://docs.ceph.org.cn/start/hardware-recommendations/#id10)  [操作系统推荐](http://docs.ceph.org.cn/start/os-recommendations/) [Ceph 依赖](http://docs.ceph.org.cn/start/os-recommendations/#ceph) [系统平台](http://docs.ceph.org.cn/start/os-recommendations/#id2) | 参与 欢迎您加入社区，贡献文档、代码，或发现软件缺陷。 [加入 Ceph 社区！](http://docs.ceph.org.cn/start/get-involved/) [贡献 Ceph 文档](http://docs.ceph.org.cn/start/documenting-ceph/) [如何贡献](http://docs.ceph.org.cn/start/documenting-ceph/#id1) [文档风格指南](http://docs.ceph.org.cn/start/documenting-ceph/#id10) |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

# 硬件推荐

Ceph 为普通硬件设计，这可使构建、维护 PB  级数据集群的费用相对低廉。规划集群硬件时，需要均衡几方面的因素，包括区域失效和潜在的性能问题。硬件规划要包含把使用 Ceph 集群的 Ceph  守护进程和其他进程恰当分布。通常，我们推荐在一台机器上只运行一种类型的守护进程。我们推荐把使用数据集群的进程（如 OpenStack 、  CloudStack 等）安装在别的机器上。

Tip

关于 Ceph 的高品质博客文章也值得参考，比如 [Ceph Write Throughput 1](http://ceph.com/community/ceph-performance-part-1-disk-controller-write-throughput/) 、 [Ceph Write Throughput 2](http://ceph.com/community/ceph-performance-part-2-write-throughput-without-ssd-journals/) 、 [Argonaut v. Bobtail Performance Preview](http://ceph.com/uncategorized/argonaut-vs-bobtail-performance-preview/) 、 [Bobtail Performance - I/O Scheduler Comparison](http://ceph.com/community/ceph-bobtail-performance-io-scheduler-comparison/) 。

## CPU

Ceph 元数据服务器对 CPU 敏感，它会动态地重分布它们的负载，所以你的元数据服务器应该有足够的处理能力（如 4 核或更强悍的 CPU ）。 Ceph 的 OSD 运行着 [*RADOS*](http://docs.ceph.org.cn/glossary/#term-rados) 服务、用 [*CRUSH*](http://docs.ceph.org.cn/glossary/#term-crush) 计算数据存放位置、复制数据、维护它自己的集群运行图副本，因此 OSD 需要一定的处理能力（如双核 CPU  ）。监视器只简单地维护着集群运行图的副本，因此对 CPU 不敏感；但必须考虑机器以后是否还会运行 Ceph 监视器以外的 CPU  密集型任务。例如，如果服务器以后要运行用于计算的虚拟机（如 OpenStack Nova ），你就要确保给 Ceph  进程保留了足够的处理能力，所以我们推荐在其他机器上运行 CPU 密集型任务。

## RAM内存

元数据服务器和监视器必须可以尽快地提供它们的数据，所以他们应该有足够的内存，至少每进程 1GB 。 OSD  的日常运行不需要那么多内存（如每进程 500MB ）差不多了；然而在恢复期间它们占用内存比较大（如每进程每 TB 数据需要约 1GB  内存）。通常内存越多越好。

## 数据存储

要谨慎地规划数据存储配置，因为其间涉及明显的成本和性能折衷。来自操作系统的并行操作和到单个硬盘的多个守护进程并发读、写请求操作会极大地降低性能。文件系统局限性也要考虑： btrfs 尚未稳定到可以用于生产环境的程度，但它可以同时记日志并写入数据，而 xfs 和 ext4 却不能。

Important

因为 Ceph 发送 ACK 前必须把所有数据写入日志（至少对 xfs 和 ext4 来说是），因此均衡日志和 OSD 性能相当重要。

### 硬盘驱动器

OSD 应该有足够的空间用于存储对象数据。考虑到大硬盘的每 GB 成本，我们建议用容量大于 1TB 的硬盘。建议用 GB  数除以硬盘价格来计算每 GB 成本，因为较大的硬盘通常会对每 GB 成本有较大影响，例如，单价为 $75 的 1TB 硬盘其每 GB 价格为  $0.07 （ $75/1024=0.0732 ），又如单价为 $150 的 3TB 硬盘其每 GB 价格为 $0.05 （  $150/3072=0.0488 ），这样使用 1TB 硬盘会增加 40% 的每 GB  价格，它将表现为较低的经济性。另外，单个驱动器容量越大，其对应的 OSD 所需内存就越大，特别是在重均衡、回填、恢复期间。根据经验， 1TB  的存储空间大约需要 1GB 内存。

Tip

不顾分区而在单个硬盘上运行多个OSD，这样**不明智**！

Tip

不顾分区而在运行了OSD的硬盘上同时运行监视器或元数据服务器也**不明智**！

存储驱动器受限于寻道时间、访问时间、读写时间、还有总吞吐量，这些物理局限性影响着整体系统性能，尤其在系统恢复期间。因此我们推荐独立的驱动器用于安装操作系统和软件，另外每个 OSD 守护进程占用一个驱动器。大多数 “slow OSD”问题的起因都是在相同的硬盘上运行了操作系统、多个 OSD  、和/或多个日志文件。鉴于解决性能问题的成本差不多会超过另外增加磁盘驱动器，你应该在设计时就避免增加 OSD 存储驱动器的负担来提升性能。

Ceph 允许你在每块硬盘驱动器上运行多个 OSD ，但这会导致资源竞争并降低总体吞吐量； Ceph  也允许把日志和对象数据存储在相同驱动器上，但这会增加记录写日志并回应客户端的延时，因为 Ceph 必须先写入日志才会回应确认了写动作。  btrfs 文件系统能同时写入日志数据和对象数据， xfs 和 ext4 却不能。

Ceph 最佳实践指示，你应该分别在单独的硬盘运行操作系统、 OSD 数据和 OSD 日志。

### 固态硬盘

一种提升性能的方法是使用固态硬盘（ SSD ）来降低随机访问时间和读延时，同时增加吞吐量。 SSD 和硬盘相比每 GB 成本通常要高 10 倍以上，但访问时间至少比硬盘快 100 倍。

SSD 没有可移动机械部件，所以不存在和硬盘一样的局限性。但 SSD 也有局限性，评估SSD 时，顺序读写性能很重要，在为多个 OSD 存储日志时，有着 400MB/s 顺序读写吞吐量的 SSD 其性能远高于 120MB/s 的。

Important

我们建议发掘 SSD 的用法来提升性能。然而在大量投入 SSD 前，我们**强烈建议**核实 SSD 的性能指标，并在测试环境下衡量性能。

正因为 SSD 没有移动机械部件，所以它很适合 Ceph 里不需要太多存储空间的地方。相对廉价的 SSD 很诱人，慎用！可接受的 IOPS 指标对选择用于 Ceph 的 SSD 还不够，用于日志和 SSD 时还有几个重要考量：

- **写密集语义：** 记日志涉及写密集语义，所以你要确保选用的 SSD 写入性能和硬盘相当或好于硬盘。廉价 SSD 可能在加速访问的同时引入写延时，有时候高性能硬盘的写入速度可以和便宜 SSD 相媲美。
- **顺序写入：** 在一个 SSD 上为多个 OSD 存储多个日志时也必须考虑 SSD 的顺序写入极限，因为它们要同时处理多个 OSD 日志的写入请求。
- **分区对齐：** 采用了 SSD 的一个常见问题是人们喜欢分区，却常常忽略了分区对齐，这会导致 SSD 的数据传输速率慢很多，所以请确保分区对齐了。

SSD 用于对象存储太昂贵了，但是把 OSD 的日志存到 SSD 、把对象数据存储到独立的硬盘可以明显提升性能。 `osd journal` 选项的默认值是 `/var/lib/ceph/osd/$cluster-$id/journal` ，你可以把它挂载到一个 SSD 或 SSD 分区，这样它就不再是和对象数据一样存储在同一个硬盘上的文件了。

提升 CephFS 文件系统性能的一种方法是从 CephFS 文件内容里分离出元数据。 Ceph 提供了默认的 `metadata` 存储池来存储 CephFS 元数据，所以你不需要给 CephFS 元数据创建存储池，但是可以给它创建一个仅指向某主机 SSD 的 CRUSH 运行图。详情见[给存储池指定 OSD](http://ceph.com/docs/master/rados/operations/crush-map/#placing-different-pools-on-different-osds) 。

### 控制器

硬盘控制器对写吞吐量也有显著影响，要谨慎地选择，以免产生性能瓶颈。

Tip

Ceph blog通常是优秀的Ceph性能问题来源，见 [Ceph Write Throughput 1](http://ceph.com/community/ceph-performance-part-1-disk-controller-write-throughput/) 和 [Ceph Write Throughput 2](http://ceph.com/community/ceph-performance-part-2-write-throughput-without-ssd-journals/) 。

### 其他注意事项

你可以在同一主机上运行多个 OSD ，但要确保 OSD 硬盘总吞吐量不超过为客户端提供读写服务所需的网络带宽；还要考虑集群在每台主机上所存储的数据占总体的百分比，如果一台主机所占百分比太大而它挂了，就可能导致诸如超过 `full ratio` 的问题，此问题会使 Ceph 中止运作以防数据丢失。

如果每台主机运行多个 OSD ，也得保证内核是最新的。参阅[操作系统推荐](http://docs.ceph.org.cn/start/os-recommendations)里关于 `glibc` 和 `syncfs(2)` 的部分，确保硬件性能可达期望值。

OSD 数量较多（如 20 个以上）的主机会派生出大量线程，尤其是在恢复和重均衡期间。很多 Linux 内核默认的最大线程数较小（如 32k 个），如果您遇到了这类问题，可以把 `kernel.pid_max` 值调高些。理论最大值是 4194303 。例如把下列这行加入 `/etc/sysctl.conf` 文件：

```
kernel.pid_max = 4194303
```

## 网络

建议每台机器最少两个千兆网卡，现在大多数机械硬盘都能达到大概 100MB/s 的吞吐量，网卡应该能处理所有 OSD  硬盘总吞吐量，所以推荐最少两个千兆网卡，分别用于公网（前端）和集群网络（后端）。集群网络（最好别连接到国际互联网）用于处理由数据复制产生的额外负载，而且可防止拒绝服务攻击，拒绝服务攻击会干扰数据归置组，使之在 OSD 数据复制时不能回到 `active + clean` 状态。请考虑部署万兆网卡。通过 1Gbps 网络复制 1TB 数据耗时 3 小时，而 3TB （典型配置）需要 9 小时，相比之下，如果使用  10Gbps 复制时间可分别缩减到 20 分钟和 1 小时。在一个 PB 级集群中， OSD  磁盘失败是常态，而非异常；在性价比合理的的前提下，系统管理员想让 PG 尽快从 `degraded` （降级）状态恢复到 `active + clean` 状态。另外，一些部署工具（如 Dell 的 Crowbar ）部署了 5 个不同的网络，但使用了 VLAN 以提高网络和硬件可管理性。  VLAN 使用 802.1q 协议，还需要采用支持 VLAN 功能的网卡和交换机，增加的硬件成本可用节省的运营（网络安装、维护）成本抵消。使用  VLAN 来处理集群和计算栈（如 OpenStack 、 CloudStack 等等）之间的 VM 流量时，采用 10G  网卡仍然值得。每个网络的机架路由器到核心路由器应该有更大的带宽，如 40Gbps 到 100Gbps 。

服务器应配置底板管理控制器（ Baseboard Management Controller, BMC ），管理和部署工具也应该大规模使用 BMC ，所以请考虑带外网络管理的成本/效益平衡，此程序管理着 SSH 访问、 VM  映像上传、操作系统安装、端口管理、等等，会徒增网络负载。运营 3  个网络有点过分，但是每条流量路径都指示了部署一个大型数据集群前要仔细考虑的潜能力、吞吐量、性能瓶颈。

## 故障域

故障域指任何导致不能访问一个或多个 OSD 的故障，可以是主机上停止的进程、硬盘故障、操作系统崩溃、有问题的网卡、损坏的电源、断网、断电等等。规划硬件需求时，要在多个需求间寻求平衡点，像付出很多努力减少故障域带来的成本削减、隔离每个潜在故障域增加的成本。

## 最低硬件推荐

Ceph 可以运行在廉价的普通硬件上，小型生产集群和开发集群可以在一般的硬件上。

| 进程           | 条件                                   | 最低建议                                                     |
| -------------- | -------------------------------------- | ------------------------------------------------------------ |
| `ceph-osd`     | Processor                              | 1x 64-bit AMD-64 1x 32-bit ARM dual-core or better 1x i386 dual-core |
| RAM            | ~1GB for 1TB of storage per daemon     |                                                              |
| Volume Storage | 1x storage drive per daemon            |                                                              |
| Journal        | 1x SSD partition per daemon (optional) |                                                              |
| Network        | 2x 1GB Ethernet NICs                   |                                                              |
| `ceph-mon`     | Processor                              | 1x 64-bit AMD-64/i386 1x 32-bit ARM dual-core or better 1x i386 dual-core |
| RAM            | 1 GB per daemon                        |                                                              |
| Disk Space     | 10 GB per daemon                       |                                                              |
| Network        | 2x 1GB Ethernet NICs                   |                                                              |
| `ceph-mds`     | Processor                              | 1x 64-bit AMD-64 quad-core 1x 32-bit ARM quad-core 1x i386 quad-core |
| RAM            | 1 GB minimum per daemon                |                                                              |
| Disk Space     | 1 MB per daemon                        |                                                              |
| Network        | 2x 1GB Ethernet NICs                   |                                                              |

Tip

如果在只有一块硬盘的机器上运行 OSD ，要把数据和操作系统分别放到不同分区；一般来说，我们推荐操作系统和数据分别使用不同的硬盘。

## 生产集群实例

PB 级生产集群也可以使用普通硬件，但应该配备更多内存、 CPU 和数据存储空间来解决流量压力。

### Dell 实例

一个最新（ 2012 ）的 Ceph 集群项目使用了 2 个相当强悍的 OSD 硬件配置，和稍逊的监视器配置。

| Configuration  | Criteria                          | Minimum Recommended           |
| -------------- | --------------------------------- | ----------------------------- |
| Dell PE R510   | Processor                         | 2x 64-bit quad-core Xeon CPUs |
| RAM            | 16 GB                             |                               |
| Volume Storage | 8x 2TB drives. 1 OS, 7 Storage    |                               |
| Client Network | 2x 1GB Ethernet NICs              |                               |
| OSD Network    | 2x 1GB Ethernet NICs              |                               |
| Mgmt. Network  | 2x 1GB Ethernet NICs              |                               |
| Dell PE R515   | Processor                         | 1x hex-core Opteron CPU       |
| RAM            | 16 GB                             |                               |
| Volume Storage | 12x 3TB drives. Storage           |                               |
| OS Storage     | 1x 500GB drive. Operating System. |                               |
| Client Network | 2x 1GB Ethernet NICs              |                               |
| OSD Network    | 2x 1GB Ethernet NICs              |                               |
| Mgmt. Network  | 2x 1GB Ethernet NICs              |                               |

# 推荐操作系统

## Ceph 依赖

按常规来说，我们建议在较新的 Linux 发行版上部署 Ceph ；同样，要选择长期支持的版本。

### Linux 内核

- **Ceph 内核态客户端**

  当前我们推荐：

  - 4.1.4 or later
  - 3.16.3 or later (rbd deadlock regression in 3.16.[0-2])
  - *NOT* v3.15.* (rbd deadlock regression)
  - 3.14.*

  如果您坚持用很旧的，可以考虑这些：

  - 3.10.*

  firefly (CRUSH_TUNABLES3) 这个版本的可调选项到 3.15 版才开始支持。详情见 [CRUSH 可调值](http://docs.ceph.org.cn/rados/operations/crush-map#tunables) 。

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
=======
`cephadm`用于“裸机”部署.

`Rook`用于在`Kubernetes`环境中运行`Ceph`，并为这两个平台提供类似的管理体验。
>>>>>>> 5658cd99704bab4f76b71fa564725144fec43e33
