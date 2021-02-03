# Ceph

[TOC]

Ceph的CRUSH算法引擎，聪明地解决了数据分布效率问题，奠定了它胜任各种规模存储池集群的坚实基础。

## Ceph架构

**RADOS**

核心组件，提供高可靠、高可扩展、高性能的分布式对象存储架构，利用本地文件系统存储对象。 本身就是一个完整的对象存储系统。

物理上，RADOS由大量的存储设备节点组成，每个节点拥有自己的硬件资源（CPU、内存、硬盘、网络），并运行着操作系统和文件系统。

**Client** 

**RBD（Rados Block Device）**

功能特性基于LIBRADOS之上，通过LIBRBD创建一个块设备，通过QEMU/KVM附加到VM上，作为传统的块设备来用。目前OpenStack、CloudStack等都是采用这种方式来为VM提供块设备，同时也支持快照、COW（Copy On Write）等功能。RBD通过Linux内核（Kernel）客户端和QEMU/KVM驱动，来提供一个完全分布式的块设备。

**RADOSGW**

是一个提供与Am azon S3和Swift兼容的RESTful API的网关，以供相应的对象存储应用开发使用。RADOSGW提供的API抽象层次更高，但在类S3或Swift LIBRADOS的管理比便捷，因此，开发者应针对自己的需求选择使用。

**LIBRADOS**

功能是对RADOS进行抽象和封装，并向上层提供API，以便直接基于RADOS进行应用开发。

LIBRADOS实现的 API是针对对象存储功能的。RADOS采用C++开发，所提供的原生LIBRADOS API包括C和C++两种。物理上，LIBRADOS和基于其上开发的应用位于同一台机器，因而也被称为本地API。应用调用本机上的LIBRADOS API，再由后者通过socket与RADOS集群中的节点通信并完成各种操作。

**CephFS（Ceph File System ）**

功能特性是基于RADOS来实现分布式的文件系统，引入了MDS（Metadata Server），主要为兼容POSIX文件系统提供元数据。一般都是当做文件系统来挂载。通过Linux内核（Kernel）客户端结合FUSE，来提供一个兼容POSIX的文件系统。

![](../../Image/ceph.png)

## Ceph组件

最简的 Ceph 存储集群至少要一个监视器和两个 OSD 守护进程，只有运行 Ceph 文件系统时,元数据服务器才是必需的。  

**OSD(对象存储守护进程，Object Storage Daemon):**  

存储数据，处理数据复制、恢复、回填、重均衡，并通过检查其他 OSD 守护进程的心跳来向 Ceph Monitors 提供一些监控信息。通常一个OSD守护进程会被捆绑到集群中的一块物理磁盘上。

当 Ceph 存储集群设定为有2个副本时，至少需要2个 OSD 守护进程，集群才能达到 `active+clean` 状态。

![](../../Image/ceph-topo.jpg)

Ceph OSD将数据以对象的形式存储到集群中每个节点的物理磁盘上，完成存储用户数据的工作绝大多数都是由OSD deam on进程来实现的。

Ceph集群一般情况都包含多个OSD，对于任何读写操作请求，Client端从Ceph Monitor获取Cluster Map之后，Client将直接与OSD进行I/O操作的交互，而不再需要Ceph Monitor干预。这使得数据读写过程更为迅速，因为这些操作过程不像其他存储系统，它没有其他额外的层级数据处理。

Ceph提供通过分布在多节点上的副本，使得Ceph具有高可用性以及容错性。在OSD中的每个对象都有一个主副本，若干个从副本，这些副本默认情况下是分布在不同节点上的，这就是Ceph作为分布式存储系统的集中体现。每个OSD都可能作为某些对象的主OSD，与此同时，它也可能作为某些对象的从OSD，从OSD受到主OSD的控制，然而，从OSD 在某些情况也可能成为主OSD。在磁盘故障时，Ceph OSD Deam on的智能对等机制将协同其他OSD执行恢复操作。在此期间，存储对象副本的从OSD将被提升为主OSD，与此同时，新的从副本将重新生成，这样就保证了Ceph的可靠和一致。

Ceph OSD架构实现由物理磁盘驱动器、在其之上的Linux文件系统以及Ceph OSD服务组成。对Ceph OSD Deamon而言，Linux文件系统显性地支持了其扩展属性；这些文件系统的扩展属性提供了关于对象状态、快照、元数据内部信息；而访问Ceph OSD Deam on的ACL则有助于数据管理。

**MON(Monitor)**  

维护着各种 `cluster map`，包括`MON map`、`OSD map`、`PG map` 和`CRUSH map`。所有集群节点都向MON节点汇报状态信息，并分享它们状态中的任何变化。Ceph 保存着发生在Monitors 、 OSD 和 PG上的每一次状态变更的历史信息（称为 epoch ）。

MON服务利用Paxos的实例，把每个映射图存储为一个文件。 

Monitor是个轻量级的守护进程，通常情况下并不需要大量的系统资源，低成本、入门级的CPU，以及千兆网卡即可满足大多数的场景；与此同时，Monitor节点需要有足够的磁盘空间来存储集群日志，健康集群产生几MB到GB的日志；然而，如果存储的需求增加时，打开低等级的日志信息的话，可能需要几个GB的磁盘空间来存储日志。

一个典型的Ceph集群包含多个Monitor节点。一个多Monitor的Ceph的架构通过法定人数来选择leader，并在提供一致分布式决策时使用Paxos算法集群。在Ceph集群中有多个Monitor时，集群的Monitor应该是奇数；最起码的要求是一台监视器节点，这里推荐Monitor个数是3。由于Monitor工作在法定人数，一半以上的总监视器节点应该总是可用的，以应对死机等极端情况，这是Monitor节点为N（N>0）个且N为奇数的原因。所有集群Monitor节点，其中一个节点为Leader。如果Leader Monitor节点处于不可用状态，其他显示器节点有资格成为Leader。生产群集必须至少有N/2个监控节点提供高可用性。

**MDS(元数据服务器，Metadata Server)**  

为CephFS文件系统跟踪文件的层次结构和存储元数据。缓存和同步元数据，管理名字空间。不直接提供数据给客户端。使得 POSIX 文件系统的用户们，可以在不对 Ceph 存储集群造成负担的前提下，执行诸如 `ls`、`find` 等基本命令。

## Map

### Monitor Map

包括有关monitor节点端到端的信息，其中包括Ceph集群ID，监控主机名和IP地址和端口号，它还存储了当前版本信息以及最新更改信息。

```bash
ceph mon dump
```

### OSD Map

包括一些常用的信息，如集群ID，创建OSD Map的版本信息和最后修改信息，以及pool相关信息，pool的名字、pool的ID、类型，副本数目以及PGP，还包括OSD信息，如数量、状态、权重、最新的清洁间隔和OSD主机信息。

```bash
ceph osd dump
```

### PG Map

包括当前PG版本、时间戳、最新的OSD Map的版本信息、空间使用比例，以及接近占满比例信息，同时，也包括每个PG ID、对象数目、状态、OSD的状态以及深度清理的详细信息。

```bash
ceph pg dump
```

### CRUSH Map

包括集群存储设备信息，故障域层次结构和存储数据时定义失败域规则信息；可以通过以下命令查看CRUSH Map。

```bash
ceph osd crush dump 
```

### MDS Map

包括存储当前MDS Map的版本信息、创建当前Map的信息、修改时间、数据和元数据POOL ID、集群MDS数目和MDS状态。

```bash
ceph mds dump
```

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
* Ceph-deploy

- cephadm               用于“裸机”部署

* Rook                       用于在`Kubernetes`环境中运行`Ceph`，并为这两个平台提供类似的管理体验




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



Ceph 独一无二地在一个统一的系统中同时提供了**对象、块、和文件存储功能**。

| CEPH 对象存储 REST 风格的接口 与 S3 和 Swift 兼容的 API S3 风格的子域 统一的 S3/Swift 命名空间 用户管理 利用率跟踪 条带化对象 云解决方案集成 多站点部署 灾难恢复 | Ceph 块设备 瘦接口支持 映像尺寸最大 16EB 条带化可定制 内存缓存 快照 写时复制克隆 支持内核级驱动 支持 KVM 和 libvirt 可作为云解决方案的后端 增量备份 | Ceph 文件系统 与 POSIX 兼容的语义 元数据独立于数据 动态重均衡 子目录快照 可配置的条带化 有内核驱动支持 有用户空间驱动支持 可作为 NFS/CIFS 部署 可用于 Hadoop （取代 HDFS ） |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 详情见 [Ceph 对象存储](http://docs.ceph.org.cn/radosgw)。    | 详情见 [Ceph 块设备](http://docs.ceph.org.cn/rbd/rbd)。      | 详情见 [Ceph 文件系统](http://docs.ceph.org.cn/cephfs)。     |

它可靠性高、管理简单，并且是开源软件。 Ceph 的强大可以改变您公司的 IT 基础架构和海量数据管理能力。想试试 Ceph 的话看[入门](http://docs.ceph.org.cn/start)手册；想深入理解可以看[体系结构](http://docs.ceph.org.cn/architecture)一节。



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

## CLI



## 集群监控

主流软件：

* Calam ari
* VSM
* Inkscope
* Ceph-Dash
* Zabbix

### Calam ari

对外提供了十分漂亮的Web管理和监控界面，以及一套改进的REST API接口（不同于Ceph自身的REST API），在一定程度上简化了Ceph的管理。

最初Calam ari是作为Inktank公司的Ceph企业级商业产品来销售的，Red Hat公司2015年收购Inktank后，为了更好地推动Ceph的发展，对外宣布Calam ari开源。

优点：

* 轻量级

* 官方化

* 界面友好

缺点：
*  不易安装
*  管理功能滞后

### Virtual Storage Manager

Virtual Storage Manager（VSM）是Intel公司研发并且开源的一款Ceph集群管理和监控软件，简化了一些Ceph集群部署的步骤，可以简单地通过Web页面来操作。 

优点：

* 管理功能好
* 界面友好
* 可以部署Ceph和监控Ceph

缺点：

* 非官方
* 依赖OpenStack某些包

### Inkscope

是一个Ceph的管理和监控系统，依赖于Ceph提供的API，使用MongoDB来存储实时的监控数据和历史信息。

优点：

* 易部署
* 轻量级

缺点：

* 监控选项少
* 缺乏Ceph管理功能

### Ceph-Dash

Ceph-Dash是用Py thon语言开发的一个Ceph的监控面板，用来监控Ceph的运行状态。同时提供REST API来访问状态数据。

