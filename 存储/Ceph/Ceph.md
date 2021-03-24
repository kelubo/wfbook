# Ceph

[TOC]

Ceph是一个分布式存储系统，诞生于2004年，最早致力于开发下一代高性能分布式文件系统的项目。

## 优势

**CRUSH算法**

ceph的两大创新之一，ceph摒弃了传统的集中式存储元数据寻址的方案，转而使用CRUSH算法完成数据的寻址操作。CRUSH在一致性哈希基础上很好的考虑了容灾域的隔离，能够实现各类负载的副本放置规则，例如跨机房、机架感知等。Crush算法有相当强大的扩展性，理论上支持数千个存储节点。

**高可用**

Ceph中的数据副本数量可以由管理员自行定义，并可以通过CRUSH算法指定副本的物理存储位置以分隔故障域，支持数据强一致性； ceph可以忍受多种故障场景并自动尝试并行修复。

**高扩展性**

Ceph不同于swift，客户端所有的读写操作都要经过代理节点。一旦集群并发量增大时，代理节点很容易成为单点瓶颈。Ceph本身并没有主控节点，扩展起来比较容易，并且理论上，它的性能会随着磁盘数量的增加而线性增长。

**特性丰富**

支持三种调用接口：`对象存储`，`块存储`，`文件系统挂载`。三种方式可以一同使用。

Ceph的CRUSH算法引擎，聪明地解决了数据分布效率问题，奠定了它胜任各种规模存储池集群的坚实基础。

## Ceph架构

**RADOS**

核心组件，提供高可靠、高可扩展、高性能的分布式对象存储架构，利用本地文件系统存储对象。 本身就是一个完整的对象存储系统。

物理上，RADOS由大量的存储设备节点组成，每个节点拥有自己的硬件资源（CPU、内存、硬盘、网络），并运行着操作系统和文件系统。

RADOS采用C++开发，所提供的原生Librados API包括C和C++两种。Ceph的上层应用调用本机上的librados  API，再由后者通过socket与RADOS集群中的其他节点通信并完成各种操作。

**LIBRADOS**

功能是对RADOS进行抽象和封装，并向上层提供API，以便直接基于RADOS进行应用开发。

LIBRADOS实现的 API是针对对象存储功能的。RADOS采用C++开发，所提供的原生LIBRADOS API包括C和C++两种。物理上，LIBRADOS和基于其上开发的应用位于同一台机器，因而也被称为本地API。应用调用本机上的LIBRADOS API，再由后者通过socket与RADOS集群中的节点通信并完成各种操作。

**RBD（Rados Block Device）**

功能特性基于LIBRADOS之上，通过LIBRBD创建一个块设备，通过QEMU/KVM附加到VM上，作为传统的块设备来用。目前OpenStack、CloudStack等都是采用这种方式来为VM提供块设备，同时也支持快照、COW（Copy On Write）等功能。RBD通过Linux内核（Kernel）客户端和QEMU/KVM驱动，来提供一个完全分布式的块设备。

**RADOSGW**

是一个提供与Am azon S3和Swift兼容的RESTful API的网关，以供相应的对象存储应用开发使用。RADOSGW提供的API抽象层次更高，但在类S3或Swift LIBRADOS的管理比便捷，因此，开发者应针对自己的需求选择使用。

**CephFS（Ceph File System ）**

功能特性是基于RADOS来实现分布式的文件系统，引入了MDS（Metadata Server），主要为兼容POSIX文件系统提供元数据。一般都是当做文件系统来挂载。通过Linux内核（Kernel）客户端结合FUSE，来提供一个兼容POSIX的文件系统。

**Client** 

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

在ceph中，每一个osd进程都可称作是一个osd节点，每台存储服务器上可能包含了众多的osd节点，每个osd节点监听不同的端口。每个osd节点可以设置一个目录作为实际存储区域，也可以是一个分区，一整块硬盘。下图，当前这台机器上跑了两个osd进程，每个osd监听4个端口，分别用于接收客户请求、传输数据、发送心跳、同步数据等操作。osd节点默认监听tcp的6800到6803端口，如果同一台服务器上有多个osd节点，则依次往后排序。

![img](../../Image/o/osd.jpg)

在生产环境中的osd最少可能都有上百个，所以每个osd都有一个全局的编号，类似osd0，osd1，osd2........序号根据osd诞生的顺序排列，并且是全局唯一的。存储了相同PG的osd节点除了向mon节点发送心跳外，还会互相发送心跳信息以检测pg数据副本是否正常。

每个osd节点都包含一个journal文件，默认大小为5G。每创建一个osd节点，还没使用就要被journal占走5G的空间。这个值可以调整，具体大小要依osd的总大小而定。

Journal的作用类似于mysql  innodb引擎中的事物日志系统。当有突发的大量写入操作时，可先把一些零散的，随机的IO请求保存到缓存中进行合并，然后再统一向内核发起IO请求。这样做效率会比较高，但是一旦osd节点崩溃，缓存中的数据就会丢失，所以数据在还未写进硬盘中时，都会记录到journal中，当osd崩溃后重新启动时，会自动尝试从journal恢复因崩溃丢失的缓存数据。因此journal的io是非常密集的，而且由于一个数据要io两次，很大程度上也损耗了硬件的io性能，所以通常在生产环境中，使用ssd来单独存储journal文件以提高ceph读写性能。

**MON(Monitor)**  

维护着各种 `cluster map` 的主副本，包括`MON map`、`OSD map`、`PG map` 和`CRUSH map`。监听tcp 6789端口，所有集群节点都向其汇报状态信息，并分享状态中的任何变化。Ceph 保存着发生在Monitors、OSD 和 PG上的每一次状态变更的历史信息（称为 epoch ）。

MON服务利用Paxos的实例，把每个映射图存储为一个文件。Mon节点之间使用Paxos算法来保持各节点cluster  map的一致性；各mon节点的功能总体上是一样的，相互间的关系可以被简单理解为主备关系。如果主mon节点损坏，其他mon存活节点超过半数时，集群还可以正常运行。当故障mon节点恢复时，会主动向其他mon节点拉取最新的cluster map。

Monitor是个轻量级的守护进程，通常情况下并不需要大量的系统资源，低成本、入门级的CPU，以及千兆网卡即可满足大多数的场景；与此同时，Monitor节点需要有足够的磁盘空间来存储集群日志，健康集群产生几MB到GB的日志；然而，如果存储的需求增加时，打开低等级的日志信息的话，可能需要几个GB的磁盘空间来存储日志。

一个典型的Ceph集群可包含多个Monitor节点，至少要有一个，官方推荐至少部署三台。一个多Monitor的Ceph的架构通过法定人数来选择leader，并在提供一致分布式决策时使用Paxos算法集群。在Ceph集群中有多个Monitor时，集群的Monitor应该是奇数；最起码的要求是一台监视器节点，这里推荐Monitor个数是3。由于Monitor工作在法定人数，一半以上的总监视器节点应该总是可用的，以应对死机等极端情况，这是Monitor节点为N（N>0）个且N为奇数的原因。所有集群Monitor节点，其中一个节点为Leader。如果Leader Monitor节点处于不可用状态，其他显示器节点有资格成为Leader。生产群集必须至少有N/2个监控节点提供高可用性。

客户端在使用时，需要挂载mon节点的6789端口，下载最新的cluster  map，通过crush算法获得集群中各osd的IP地址，然后再与osd节点直接建立连接来传输数据。所以不需要有集中式的主节点用于计算与寻址，客户端分摊了这部分工作。且客户端也可以直接和osd通信，省去了中间代理服务器的额外开销。

Mon节点不会主动轮询各个osd的当前状态，相反，osd只有在一些特殊情况才会上报自己的信息，平常只会简单的发送心跳。特殊情况包括：

1. 新的OSD被加入集群

2. 某个OSD发现自身或其他OSD发生异常。

Mon节点在收到这些上报信息时，则会更新cluster map信息并加以扩散。

cluster map信息是以异步且lazy的形式扩散的。monitor并不会在每一次cluster  map版本更新后都将新版本广播至全体OSD，而是在有OSD向自己上报信息时，将更新回复给对方。类似的，各个OSD也是在和其他OSD通信时，如果发现对方的osd中持有的cluster map版本较低，则把自己更新的版本发送给对方。

**MDS(元数据服务器，Metadata Server)**  

为CephFS文件系统跟踪文件的层次结构和存储元数据。缓存和同步元数据，管理名字空间。不直接提供数据给客户端。使得 POSIX 文件系统的用户们，可以在不对 Ceph 存储集群造成负担的前提下，执行诸如 `ls`、`find` 等基本命令。

不是必须的，只有在使用cephfs的时候才需要。

不负责存储元数据，元数据也是被切成对象存在各个osd节点中的。

在创建CEPHFS时，要至少创建两个POOL，一个用于存放数据，另一个用于存放元数据。Mds只是负责接受用户的元数据查询请求，然后从osd中把数据取出来映射进自己的内存中供客户访问。mds其实类似一个代理缓存服务器，替osd分担了用户的访问压力。

![img](../../Image/m/mds.jpg)

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

## 数据流向
Data --> obj --> PG --> Pool --> OSD

![](../../Image/Distributed-Object-Store.png)

无论使用哪种存储方式，存储的数据都会被切分成对象（Objects）。Objects  size大小可以由管理员调整，通常为2M或4M。每个对象都会有一个唯一的OID，由ino与ono生成。ino即是文件的File  ID，用于在全局唯一标示每一个文件，而ono则是分片的编号。比如：一个文件FileID为A，它被切成了两个对象，一个对象编号0，另一个编号1，那么这两个文件的oid则为A0与A1。OID的好处是可以唯一标示每个不同的对象，并且存储了对象与文件的从属关系。由于ceph的所有数据都虚拟成了整齐划一的对象，所以在读写时效率都会比较高。

对象并不会直接存储进OSD中，因为对象的size很小，在一个大规模的集群中可能有几百到几千万个对象。这么多对象光是遍历寻址，速度都是很缓慢的；并且如果将对象直接通过某种固定映射的哈希算法映射到osd上，当这个osd损坏时，对象无法自动迁移至其他osd上面（因为映射函数不允许）。为了解决这些问题，ceph引入了归置组的概念，即PG。

PG是一个逻辑概念，linux系统中可以直接看到对象，但是无法直接看到PG。在数据寻址时类似于数据库中的索引：每个对象都会固定映射进一个PG中，所以当我们要寻找一个对象时，只需要先找到对象所属的PG，然后遍历这个PG就可以了，无需遍历所有对象。在数据迁移时，以PG作为基本单位进行迁移，不会直接操作对象。

**对象映射进PG:** 首先使用静态hash函数对OID做hash取出特征码，用特征码与PG的数量去模，得到的序号则是PGID。由于这种设计方式，PG的数量多寡直接决定了数据分布的均匀性，所以合理设置的PG数量可以很好的提升CEPH集群的性能并使数据均匀分布。

PG会根据管理员设置的副本数量进行复制，然后通过crush算法存储到不同的OSD节点上（其实是把PG中的所有对象存储到节点上），第一个osd节点即为主节点，其余均为从节点。

Pool是管理员自定义的命名空间，像其他的命名空间一样，用来隔离对象与PG。在调用API存储即使用对象存储时，需要指定对象要存储进哪一个Pool 中。除了隔离数据，也可以分别对不同的 Pool 设置不同的优化策略，比如副本数、数据清洗次数、数据块及对象大小等。

## 数据复制

![](../../Image/ceph_write.png)

Ceph的读写操作采用主从模型，客户端要读写数据时，只能向对象所对应的主osd节点发起请求。主节点在接受到写请求时，会同步的向从OSD中写入数据。当所有的OSD节点都写入完成后，主节点才会向客户端报告写入完成的信息。因此保证了主从节点数据的高度一致性。而读取的时候，客户端也只会向主osd节点发起读请求，并不会有类似于数据库中的读写分离的情况出现，这也是出于强一致性的考虑。由于所有写操作都要交给主osd节点来处理，所以在数据量很大时，性能可能会比较慢，为了克服这个问题以及让ceph能支持事物，每个osd节点都包含了一个journal文件。

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






or [Ceph Block Device](https://ceph.readthedocs.io/en/latest/glossary/#term-ceph-block-device) services to [Cloud Platforms](https://ceph.readthedocs.io/en/latest/glossary/#term-cloud-platforms), deploy a [Ceph File System](https://ceph.readthedocs.io/en/latest/glossary/#term-ceph-file-system) or use Ceph for another purpose, all [Ceph Storage Cluster](https://ceph.readthedocs.io/en/latest/glossary/#term-ceph-storage-cluster) deployments begin with setting up each [Ceph Node](https://ceph.readthedocs.io/en/latest/glossary/#term-ceph-node), your network, and the Ceph Storage Cluster. A Ceph Storage Cluster requires at least one Ceph Monitor, Ceph Manager, and Ceph OSD (Object Storage Daemon). The Ceph Metadata Server is also required when running Ceph File System clients.

![../../_images/37f38700cd784da451becd6718695f086edd0fd2ab5f8e8daf686249096ce7ab.png](https://ceph.readthedocs.io/en/latest/_images/37f38700cd784da451becd6718695f086edd0fd2ab5f8e8daf686249096ce7ab.png)

- **Monitors**: A [Ceph Monitor](https://ceph.readthedocs.io/en/latest/glossary/#term-ceph-monitor) (`ceph-mon`) maintains maps of the cluster state, including the monitor map, manager map, the OSD map, the MDS map, and the CRUSH map.  These maps are critical cluster state required for Ceph daemons to coordinate with each other. Monitors are also responsible for managing authentication between daemons and clients.  At least three monitors are normally required for redundancy and high availability.
- **Managers**: A [Ceph Manager](https://ceph.readthedocs.io/en/latest/glossary/#term-ceph-manager) daemon (`ceph-mgr`) is responsible for keeping track of runtime metrics and the current state of the Ceph cluster, including storage utilization, current performance metrics, and system load.  The Ceph Manager daemons also host python-based modules to manage and expose Ceph cluster information, including a web-based [Ceph Dashboard](https://ceph.readthedocs.io/en/latest/mgr/dashboard/#mgr-dashboard) and [REST API](https://ceph.readthedocs.io/en/latest/mgr/restful).  At least two managers are normally required for high availability.
- **Ceph OSDs**: A [Ceph OSD](https://ceph.readthedocs.io/en/latest/glossary/#term-ceph-osd) (object storage daemon, `ceph-osd`) stores data, handles data replication, recovery, rebalancing, and provides some monitoring information to Ceph Monitors and Managers by checking other Ceph OSD Daemons for a heartbeat. At least 3 Ceph OSDs are normally required for redundancy and high availability.
- **MDSs**: A [Ceph Metadata Server](https://ceph.readthedocs.io/en/latest/glossary/#term-ceph-metadata-server) (MDS, `ceph-mds`) stores metadata on behalf of the [Ceph File System](https://ceph.readthedocs.io/en/latest/glossary/#term-ceph-file-system) (i.e., Ceph Block Devices and Ceph Object Storage do not use MDS). Ceph Metadata Servers allow POSIX file system users to execute basic commands (like `ls`, `find`, etc.) without placing an enormous burden on the Ceph Storage Cluster.

Ceph stores data as objects within logical storage pools. Using the [CRUSH](https://ceph.readthedocs.io/en/latest/glossary/#term-crush) algorithm, Ceph calculates which placement group should contain the object, and further calculates which Ceph OSD Daemon should store the placement group.  The CRUSH algorithm enables the Ceph Storage Cluster to scale, rebalance, and recover dynamically.



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
