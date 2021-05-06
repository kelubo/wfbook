Ceph

[TOC]

Ceph是一个分布式、弹性可扩展的、高可靠的、性能优异的存储系统，诞生于2004年。可以同时支持块设备、文件系统和对象网关三种类型的存储接口。

## 功能

**Ceph Object Store                                 Ceph Block Device                                                                    Ceph File System**

RESTful Interface                                      Thin-provisioned                                                                         POSIX-compliant semantics
S3- and Swift-compliant APIs                 Images up to 16 exabytes                                                          Separates metadata from data
S3-style subdomains                               Configurable striping                                                                   Dynamic rebalancing
Unified S3/Swift namespace                  In-memory caching                                                                      Subdirectory snapshots
User management                                   Snapshots                                                                                     Configurable striping
Usage tracking                                          Copy-on-write cloning                                                                 Kernel driver support
Striped objects                                          Kernel driver support                                                                  FUSE support
Cloud solution integration                      KVM/libvirt support                                                                      NFS/CIFS deployable
Multi-site deployment                             Back-end for cloud solutions                                                      Use with Hadoop (replace HDFS)
Multi-site replication                                Incremental backup
                                                                     Disaster recovery (multisite asynchronous replication)

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

Ceph底层提供了分布式的RADOS存储，用与支撑上层的librados和RGW、RBD、CephFS等服务。Ceph实现了非常底层的object storage，是纯粹的SDS，并且支持通用的ZFS、BtrFS和Ext4文件系统，能轻易得Scale，没有单点故障。

**RADOS**

Reliable Autonomic Distributed Object  Store

Ceph存储集群的基础。核心组件，提供高可靠、高可扩展、高性能的分布式对象存储架构，利用本地文件系统存储对象。 本身就是一个完整的对象存储系统。

物理上，RADOS由大量的存储设备节点组成，每个节点拥有自己的硬件资源（CPU、内存、硬盘、网络），并运行着操作系统和文件系统。

RADOS采用C++开发，所提供的原生Librados API包括C和C++两种。Ceph的上层应用调用本机上的librados  API，再由后者通过socket与RADOS集群中的其他节点通信并完成各种操作。

RADOS层确保数据一致性和可靠性。对于数据一致性，它执行数据复制、故障检测和恢复，还包括数据在集群节点间的recovery。

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

最简的 Ceph 存储集群至少要一个 MON，一个 Manager 和两个 OSD ，只有运行 Ceph 文件系统时, MDS 才是必需的。

### OSD

OSD (对象存储守护进程，Object Storage Daemon，ceph-osd)

A [Ceph OSD](https://docs.ceph.com/en/latest/glossary/#term-Ceph-OSD) (object storage daemon, `ceph-osd`) stores data, handles data replication, recovery, rebalancing, and provides some monitoring information to Ceph Monitors and Managers by checking other Ceph OSD Daemons for a heartbeat. At least 3 Ceph OSDs are normally required for redundancy and high availability.Ceph OSD（object storage  daemon，Ceph OSD）存储数据、处理数据复制、恢复、重新平衡，并通过检查其他Ceph  OSD守护进程的心跳向Ceph监控器和管理器提供一些监视信息。为了实现冗余和高可用性，通常至少需要3个Ceph osd。

存储数据，处理数据复制、恢复、回填、重均衡，并通过检查其他 OSD 守护进程的心跳来向 MON提供一些监控信息。通常一个OSD守护进程会被捆绑到集群中的一块物理磁盘上。

至少需要3个 OSD ，集群才能达到 `active+clean` 状态。

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

### MON

MON (Monitor)

A [Ceph Monitor](https://docs.ceph.com/en/latest/glossary/#term-Ceph-Monitor) (`ceph-mon`) maintains maps of the cluster state, including the monitor map, manager map, the OSD map, the MDS map, and the CRUSH map.  These maps are critical cluster state required for Ceph daemons to coordinate with each other. Monitors are also responsible for managing authentication between daemons and clients.  At least three monitors are normally required for redundancy and high availability.Ceph监视器（Ceph  mon）维护集群状态的映射，包括监视器映射、管理器映射、OSD映射、MDS映射和CRUSH映射。这些映射是Ceph守护进程相互协调所需的关键集群状态。监视器还负责管理守护程序和客户端之间的身份验证。为了实现冗余和高可用性，通常至少需要三个监视器。

维护着各种 `cluster map` 的主副本，包括`MON map`、`OSD map`、`PG map` 、`MDS map`、`Mgr map` 和 `CRUSH map`。监听tcp 6789端口，所有集群节点都向其汇报状态信息，并分享状态中的任何变化。Ceph 保存着发生在Monitors、OSD 和 PG上的每一次状态变更的历史信息（称为 epoch ）。These maps are critical cluster state required for Ceph daemons to coordinate with each other. Monitors are also responsible for managing authentication between daemons and clients.  

MON服务利用Paxos的实例，把每个映射图存储为一个文件。Mon节点之间使用Paxos算法来保持各节点cluster  map的一致性；各mon节点的功能总体上是一样的，相互间的关系可以被简单理解为主备关系。如果主mon节点损坏，其他mon存活节点超过半数时，集群还可以正常运行。当故障mon节点恢复时，会主动向其他mon节点拉取最新的cluster map。

Monitor是个轻量级的守护进程，通常情况下并不需要大量的系统资源，低成本、入门级的CPU，以及千兆网卡即可满足大多数的场景；与此同时，Monitor节点需要有足够的磁盘空间来存储集群日志，健康集群产生几MB到GB的日志；然而，如果存储的需求增加时，打开低等级的日志信息的话，可能需要几个GB的磁盘空间来存储日志。

一个典型的Ceph集群可包含多个Monitor节点，至少要有一个，官方推荐至少部署三台。一个多Monitor的Ceph的架构通过法定人数来选择leader，并在提供一致分布式决策时使用Paxos算法集群。在Ceph集群中有多个Monitor时，集群的Monitor应该是奇数；最起码的要求是一台监视器节点，这里推荐Monitor个数是3。由于Monitor工作在法定人数，一半以上的总监视器节点应该总是可用的，以应对死机等极端情况，这是Monitor节点为N（N>0）个且N为奇数的原因。所有集群Monitor节点，其中一个节点为Leader。如果Leader Monitor节点处于不可用状态，其他显示器节点有资格成为Leader。生产群集必须至少有N/2个监控节点提供高可用性。

客户端在使用时，需要挂载mon节点的6789端口，下载最新的cluster  map，通过crush算法获得集群中各osd的IP地址，然后再与osd节点直接建立连接来传输数据。所以不需要有集中式的主节点用于计算与寻址，客户端分摊了这部分工作。且客户端也可以直接和osd通信，省去了中间代理服务器的额外开销。

Mon节点不会主动轮询各个osd的当前状态，相反，osd只有在一些特殊情况才会上报自己的信息，平常只会简单的发送心跳。特殊情况包括：

1. 新的OSD被加入集群

2. 某个OSD发现自身或其他OSD发生异常。

Mon节点在收到这些上报信息时，则会更新cluster map信息并加以扩散。

cluster map信息是以异步且lazy的形式扩散的。monitor并不会在每一次cluster  map版本更新后都将新版本广播至全体OSD，而是在有OSD向自己上报信息时，将更新回复给对方。类似的，各个OSD也是在和其他OSD通信时，如果发现对方的osd中持有的cluster map版本较低，则把自己更新的版本发送给对方。

### MDS

MDS (元数据服务器，Metadata Server)

A [Ceph Metadata Server](https://docs.ceph.com/en/latest/glossary/#term-Ceph-Metadata-Server) (MDS, `ceph-mds`) stores metadata on behalf of the [Ceph File System](https://docs.ceph.com/en/latest/glossary/#term-Ceph-File-System) (i.e., Ceph Block Devices and Ceph Object Storage do not use MDS). Ceph Metadata Servers allow POSIX file system users to execute basic commands (like `ls`, `find`, etc.) without placing an enormous burden on the Ceph Storage Cluster.Ceph元数据服务器（MDS，Ceph MDS）代表Ceph文件系统存储元数据（即，Ceph块设备和Ceph对象存储不使用MDS）。Ceph元数据服务器允许POSIX文件系统用户执行基本命令（如ls、find等），而不会给Ceph存储集群带来巨大负担。

为CephFS文件系统跟踪文件的层次结构和存储元数据。缓存和同步元数据，管理名字空间。不直接提供数据给客户端。使得 POSIX 文件系统的用户们，可以在不对 Ceph 存储集群造成负担的前提下，执行诸如 `ls`、`find` 等基本命令。

不是必须的，只有在使用cephfs的时候才需要。

不负责存储元数据，元数据也是被切成对象存在各个osd节点中的。

在创建CEPHFS时，要至少创建两个POOL，一个用于存放数据，另一个用于存放元数据。Mds只是负责接受用户的元数据查询请求，然后从osd中把数据取出来映射进自己的内存中供客户访问。mds其实类似一个代理缓存服务器，替osd分担了用户的访问压力。

![img](../../Image/m/mds.jpg)

### MGR

A [Ceph Manager](https://docs.ceph.com/en/latest/glossary/#term-Ceph-Manager) daemon (`ceph-mgr`) is responsible for keeping track of runtime metrics and the current state of the Ceph cluster, including storage utilization, current performance metrics, and system load.  The Ceph Manager daemons also host python-based modules to manage and expose Ceph cluster information, including a web-based [Ceph Dashboard](https://docs.ceph.com/en/latest/mgr/dashboard/#mgr-dashboard) and [REST API](https://docs.ceph.com/en/latest/mgr/restful).  At least two managers are normally required for high availability.Ceph管理器守护程序（Ceph  mgr）负责跟踪运行时度量和Ceph集群的当前状态，包括存储利用率、当前性能度量和系统负载。Ceph管理器守护进程还托管基于python的模块来管理和公开Ceph集群信息，包括基于web的Ceph仪表板和restapi。高可用性通常至少需要两个管理器。

主要功能是一个监控系统，包含采集、存储、分析（包含报警）和可视化几部分，用于把集群的一些指标暴露给外界使用。

A [Ceph Manager](https://ceph.readthedocs.io/en/latest/glossary/#term-ceph-manager) daemon (`ceph-mgr`) is responsible for keeping track of runtime metrics and the current state of the Ceph cluster, including storage utilization, current performance metrics, and system load.  The Ceph Manager daemons also host python-based modules to manage and expose Ceph cluster information, including a web-based [Ceph Dashboard](https://ceph.readthedocs.io/en/latest/mgr/dashboard/#mgr-dashboard) and [REST API](https://ceph.readthedocs.io/en/latest/mgr/restful).  At least two managers are normally required for high availability.

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

Ceph存储集群从Ceph客户端接收数据（不管是来自Ceph块设备、 Ceph对象存储、  Ceph文件系统，还是基于librados的自定义实现）并存储为对象。每个对象是文件系统中的一个文件，它们存储在对象存储设备上。由Ceph  OSD守护进程处理存储设备上的读/写操作。

![img](../../Image/c/ceph1.png)

Data --> obj --> PG --> Pool --> OSD

![](../../Image/Distributed-Object-Store.png)

无论使用哪种存储方式，存储的数据都会被切分成对象（Objects）。Objects  size大小可以由管理员调整，通常为2M或4M。每个对象都会有一个唯一的OID，由ino与ono生成。ino即是文件的File  ID，用于在全局唯一标示每一个文件，而ono则是分片的编号。比如：一个文件FileID为A，它被切成了两个对象，一个对象编号0，另一个编号1，那么这两个文件的oid则为A0与A1。OID的好处是可以唯一标示每个不同的对象，并且存储了对象与文件的从属关系。由于ceph的所有数据都虚拟成了整齐划一的对象，所以在读写时效率都会比较高。

对象并不会直接存储进OSD中，因为对象的size很小，在一个大规模的集群中可能有几百到几千万个对象。这么多对象光是遍历寻址，速度都是很缓慢的；并且如果将对象直接通过某种固定映射的哈希算法映射到osd上，当这个osd损坏时，对象无法自动迁移至其他osd上面（因为映射函数不允许）。为了解决这些问题，ceph引入了归置组的概念，即PG。

PG是一个逻辑概念，linux系统中可以直接看到对象，但是无法直接看到PG。在数据寻址时类似于数据库中的索引：每个对象都会固定映射进一个PG中，所以当我们要寻找一个对象时，只需要先找到对象所属的PG，然后遍历这个PG就可以了，无需遍历所有对象。在数据迁移时，以PG作为基本单位进行迁移，不会直接操作对象。

**对象映射进PG:** 首先使用静态hash函数对OID做hash取出特征码，用特征码与PG的数量去模，得到的序号则是PGID。由于这种设计方式，PG的数量多寡直接决定了数据分布的均匀性，所以合理设置的PG数量可以很好的提升CEPH集群的性能并使数据均匀分布。

PG会根据管理员设置的副本数量进行复制，然后通过crush算法存储到不同的OSD节点上（其实是把PG中的所有对象存储到节点上），第一个osd节点即为主节点，其余均为从节点。

Pool是管理员自定义的命名空间，像其他的命名空间一样，用来隔离对象与PG。在调用API存储即使用对象存储时，需要指定对象要存储进哪一个Pool 中。除了隔离数据，也可以分别对不同的 Pool 设置不同的优化策略，比如副本数、数据清洗次数、数据块及对象大小等。



Ceph stores data as objects within logical storage pools. Using the [CRUSH](https://docs.ceph.com/en/latest/glossary/#term-CRUSH) algorithm, Ceph calculates which placement group should contain the object, and further calculates which Ceph OSD Daemon should store the placement group.  The CRUSH algorithm enables the Ceph Storage Cluster to scale, rebalance, and recover dynamically.

Ceph将数据作为对象存储在逻辑存储池中。使用CRUSH算法，Ceph计算哪个放置组应该包含该对象，并进一步计算哪个Ceph OSD守护进程应该存储该放置组。CRUSH算法使Ceph存储集群能够动态地扩展、重新平衡和恢复。



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

Ceph-Dash是用Python语言开发的一个Ceph的监控面板，用来监控Ceph的运行状态。同时提供REST API来访问状态数据。













Ceph OSD在扁平的命名空间内把所有数据存储为对象（也就是没有目录层次）。对象包含一个标识符、二进制数据、和由名字/值对组成的元数据，元数据语义完全取决于Ceph客户端。

 

在很多集群架构中，集群成员的主要目的就是让集中式接口知道它能访问哪些节点，然后此中央接口通过一个两级调度为客户端提供服务，在PB到EB级系统中这个调度系统必将成为最大的瓶颈。

Ceph消除了此瓶颈：其OSD守护进程和客户端都能感知集群，例如Ceph客户端、各OSD守护进程都知道集群内其他的OSD守护进程，这样OSD就能直接和其它OSD守护进程和监视器通讯。另外，Ceph客户端也能直接和OSD守护进程交互。

Ceph客户端、监视器和OSD守护进程可以相互直接交互，这意味着OSD可以利用本地节点的CPU和内存执行那些有可能拖垮中央服务器的任务。这种设计均衡了计算资源，带来几个好处：

1. **OSD****直接服务于客户端**：由于任何网络设备都有最大并发连接上限，规模巨大时中央化的系统其物理局限性就暴露了。Ceph允许客户端直接和OSD节点联系，这在消除单故障点的同时，提升了性能和系统总容量。Ceph客户端可按需维护和某OSD的会话，而不是一中央服务器。
2. **OSD****成员和状态**：Ceph  OSD加入集群后会持续报告自己的状态。在底层，OSD状态为up或down，反映它是否在运行、能否提供服务。如果一OSD状态为down且in，表明OSD守护进程可能故障了；如果一OSD守护进程没在运行（例如崩溃了），它就不能亲自向监视器报告自己是down的。Ceph监视器能周期性地ping  OSD守护进程，以确保它们在运行，然而它也授权OSD进程去确认邻居OSD是否down了，并更新集群运行图、报告给监视器。这种机制意味着监视器还是轻量级进程。详情见[监控OSD](http://docs.ceph.org.cn/rados/operations/monitoring-osd-pg/#monitoring-osds)和[心跳](http://docs.ceph.org.cn/rados/configuration/mon-osd-interaction)。
3. **数据清洗**：作为维护数据一致性和清洁度的一部分，OSD能清洗归置组内的对象。也就是说，Ceph  OSD能比较对象元数据与存储在其他OSD上的副本元数据，以捕捉OSD缺陷或文件系统错误（每天）。OSD也能做深度清洗（每周），即按位比较对象中的数据，以找出轻度清洗时未发现的硬盘坏扇区。关于清洗详细配置见[数据清洗](http://docs.ceph.org.cn/architecture/#id42)。
4. **复制**：和Ceph客户端一样，OSD也用CRUSH算法，但用于计算副本存到哪里（也用于重均衡）。一个典型的写情形是，一客户端用CRUSH算法算出对象应存到哪里，并把对象映射到存储池和归置组，然后查找CRUSH图来确定此归置组的主OSD。

客户端把对象写入目标归置组的主OSD，然后这个主OSD再用它的CRUSH图副本找出用于放对象副本的第二、第三个OSD，并把数据复制到适当的归置组所对应的第二、第三OSD（要多少副本就有多少OSD），最终，确认数据成功存储后反馈给客户端。



有了做副本的能力，OSD守护进程就可以减轻客户端的复制压力，同时保证了数据的高可靠性和安全性。

# 动态集群管理

​                        更新时间：2021/01/18 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/twp-kunpengsdss/kunpengsdss-twp.pdf) 			

​	[分享](javascript:void(0);) 

Ceph的关键设计是自治、自修复、智能的OSD守护进程。下面介绍一下Ceph如何动态实现数据映射、重均衡、数据一致性。

Ceph存储系统支持“池”概念，它是存储对象的逻辑分区。

Ceph客户端从监视器获取一张集群运行图，并把对象写入存储池。存储池的size或副本数、CRUSH规则集和归置组数量决定着Ceph如何放置数据。

# 对象映射到OSD

​                        更新时间：2021/02/26 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/twp-kunpengsdss/kunpengsdss-twp.pdf) 			

​	[分享](javascript:void(0);) 

每个存储池都有很多归置组，CRUSH动态的把它们映射到OSD 。Ceph客户端要存对象时，CRUSH将把各对象映射到某个归置组。

把对象映射到归置组在OSD和客户端间创建了一个间接层。由于Ceph集群必须能增大或缩小、并动态地重均衡。如果让客户端“知道”哪个OSD有哪个对象，就会导致客户端和OSD紧耦合；相反，CRUSH算法把对象映射到归置组、然后再把各归置组映射到一或多个OSD，这一间接层可以让Ceph在OSD守护进程和底层设备上线时动态地重均衡。下图描述了CRUSH如何将对象映射到归置组、再把归置组映射到OSD。

![点击放大](https://support.huaweicloud.com/twp-kunpengsdss/zh-cn_image_0000001089418523.png)

有了集群运行图副本和CRUSH算法，客户端就能精确地计算出到哪个OSD读、写某特定对象。

Ceph客户端绑定到某监视器时，会索取最新的集群运行图副本，有了此图，客户端就能知道集群内的所有监视器、OSD和元数据服务器。然而它对对象的位置一无所知。

对象位置是计算出来的。

客户端只需输入对象名称和存储池，此事简单：Ceph把数据存在某存储池（如 liverpool ）中。当客户端想要存命名对象（如john、paul、george、ringo等等）时，它用对象名、一个哈希值、  存储池中的归置组数、存储池名计算归置组。Ceph按下列步骤计算PG ID。

1. 客户端输入存储池名称和对象名称（如pool="liverpool"和object-id="john"）。
2. CRUSH拿到对象名称并哈希它。
3. CRUSH用PG数（如58）对哈希值取模，这就是归置组ID。
4. CRUSH根据存储池名称取得存储池ID（如liverpool = 4 ）。
5. CRUSH把存储池ID加到PG ID（如 4.58 ）之前。

计算对象位置远快于查询定位， CRUSH算法允许客户端计算对象应该存到哪里，并允许客户端连接主OSD来存储或检索对象。

# 数据重均衡

​                        更新时间：2021/01/18 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/twp-kunpengsdss/kunpengsdss-twp.pdf) 			

​	[分享](javascript:void(0);) 

当Ceph存储集群新增一个OSD守护进程时，集群运行图就要用新增的OSD更新。回想计算PG  ID，这个动作会更改集群运行图，因此也改变了对象位置，因为计算时的输入条件变了。下图描述了重均衡过程（此图仅作简单示例，因为在大型集群里变动幅度小的多），是其中的一些而不是所有PG都从已有OSD（OSD 1和2）迁移到新OSD（OSD  3）。即使在重均衡中，CRUSH都是稳定的，很多归置组仍维持最初的配置，且各OSD都腾出了些空间，所以重均衡完成后新OSD上不会出现负载突增。

![点击放大](https://support.huaweicloud.com/twp-kunpengsdss/zh-cn_image_0000001089144251.png)

​				 			



# 数据一致性

作为维护数据一致和清洁的一部分，OSD也能清洗归置组内的对象，也就是说，OSD会比较归置组内位于不同OSD的各对象副本的元数据。清洗（通常每天执行）是为捕获OSD缺陷和文件系统错误。OSD也能执行深度清洗：按位比较对象内的数据，深度清洗（通常每周执行）是为捕捉那些在轻度清洗过程中未能发现的磁盘上的坏扇区。

Ceph集群中为了保证数据一致性，可以选择2种方案：多副本和Erasure Code。				

# 方案组网

​                        更新时间：2021/03/23 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/twp-kunpengsdss/kunpengsdss-twp.pdf) 			

​	[分享](javascript:void(0);) 

**图1** 鲲鹏BoostKit分布式存储组网示意图
![点击放大](https://support.huaweicloud.com/twp-kunpengsdss/zh-cn_image_0000001089001429.png)

上图中所示bond网口是在单个网口带宽不能满足客户业务时使用，将两个25GE网口组成一个50GE网口。

​					 					 				 			

# 块存储服务

​                        更新时间：2021/01/18 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/twp-kunpengsdss/kunpengsdss-twp.pdf) 			

​	[分享](javascript:void(0);) 

Ceph块存储又称为RADOS块设备，Ceph为块设备引入了一个新的RBD协议，即（Ceph Block  Device）。RBD为客户端提供了可靠、分布式、高性能的块存储。RBD块呈带状分布在多个Ceph对象之上，而这些对象本身又分布在整个Ceph存储集群中，因此能够保证数据的可靠性以及性能。RBD已经被Linux内核支持，换句话说，RBD驱动程序在过去的几年里已经很好地跟Linux内核集成。几乎所有的Linux操作系统发行版都支持RBD。除了可靠性和性能之外，RBD也支持其他的企业级特性，例如完整和增量式快照，精简的配置，写时复制（copy-on-write）式克隆，以及其他特性。RBD还支持全内存式缓存，这可以大大提高它的性能。

Ceph RBD镜像可以作为磁盘映射到物理裸机、虚拟机或者其他主机使用。业界领先的开源hypervisor，例如KVM和Xen完全支持RBD，并利用它为自个的客户虚拟机提供RBD特性。

Ceph块设备完全支持云平台，例如OpenStack等。在OpenStack中，可以通过cinder（块）和glance（image）组件来使用Ceph块设备。这样做可以利用Ceph块存储的copy-on-write特性在很短的时间内创建上千个VM。

# 文件存储服务

​                        更新时间：2021/01/18 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/twp-kunpengsdss/kunpengsdss-twp.pdf) 			

​	[分享](javascript:void(0);) 

分布式文件系统（Distributed File  System）是指文件系统管理的物理存储资源不一定直接连接在本地节点上，而是通过计算机网络与节点相连。CephFS使用Ceph集群提供与POSIX兼容的文件系统，允许Linux直接将Ceph存储mount到本地。它可以像NFS或者SAMBA那样，提供共享文件夹，客户端通过挂载目录的方式使用Ceph提供的存储。

使用CephFS时，需要配置MDS节点。MDS节点类似于元数据的代理缓存服务器，它为Ceph文件系统提供元数据计算、缓存与同步。

# 对象存储服务

​                        更新时间：2021/01/18 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/twp-kunpengsdss/kunpengsdss-twp.pdf) 			

​	[分享](javascript:void(0);) 

对象存储不是传统的文件和块形式存储数据的方法，而是一种以对象也就是通常意义的键值形式进行存储。在多台服务器中内置大容量硬盘，并安装上对象存储管理软件Ceph，对外通过接口提供读写访问功能。每个对象需要存储数据、元数据和一个唯一的标识符。对象存储不仅具备块存储的读写高速，还具备文件存储的共享等特性，适合于更新变动较少的场景，如图片存储、视频存储。但是对象存储不能像文件系统的磁盘那样被操作系统直接访问，只能通过API在应用层面被访问。建立在Ceph RADOS层之上的Ceph对象网关（也称为RGW接口）提供了与OpenStack Swift和Amazon  S3兼容的接口对象存储接口，包括GET、PUT、DEL和其他扩展。

RADOS是Ceph存储集群的基础。在Ceph中，所有数据都以对象的形式存储，并且无论什么数据类型，RADOS对象存储都将负责保存这些对象。RADOS层可以确保数据始终保持一致。RADOS要有它自己的用户管理。RADOS网关提供RESTful接口让用户的应用程序将数据存储到Ceph集群中。RADOS网关接口兼容Swift和S3。

RADOSGW（RGW）使用librgw和librados来实现允许应用程序与Ceph对象存储建立连接，它将API请求转化为librados请求，并且提供S3和Swift兼容的RESTful API接口。

RGW的内部逻辑处理过程中，HTTP前端接收请求数据并保存在相应的数据结构中。REST  API通用处理层从HTTP语义中解析出S3或Swift数据并进行一系列检查。检查通过后，根据不同API操作请求执行不同的处理流程。如需从RADOS集群中获取数据或者往RADOS集群中写入数据，则通过RGW与RADOS接口适配层调用librados接口将请求发送到RADOS集群中获取或写入相应数据。

要访问Ceph的对象存储系统，其实也可以绕开RADOS网关层，这样更灵活并且速度更快。librados软件库允许用户的应用程序通过C、C++、Java、Python和PHP直接访问Ceph对象存储。Ceph对象存储具备多站点（multisite）的能力，也就是说它能为灾难恢复提供解决方案。通过RADOS或者联合网关可以配置多站点的对象存储。

从存储角度来看，Ceph对象存储设备执行从对象到块的映射（在客户端的文件系统层中常常执行的任务）。这个动作允许本地实体以最佳方式决定怎样存储一个对象。Ceph的早期版本在一个名为EBOFS的本地存储器上实现一个自定义低级文件系统。这个系统实现一个到底层存储的非标准接口，这个底层存储已针对对象语义和其他特性（例如对磁盘提交的异步通知）调优。目前，B-tree文件系统（BTRFS）可以被用于存储节点，它已经实现了部分必要功能（例如嵌入式完整性）。

# 公共特性

​                        更新时间：2021/01/18 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/twp-kunpengsdss/kunpengsdss-twp.pdf) 			

​	[分享](javascript:void(0);) 

- **[Bcache](https://support.huaweicloud.com/twp-kunpengsdss/kunpengsdss_19_0018.html)**
- **[Journal](https://support.huaweicloud.com/twp-kunpengsdss/kunpengsdss_19_0019.html)**
- **[多副本](https://support.huaweicloud.com/twp-kunpengsdss/kunpengsdss_19_0020.html)**
- **[Erasure code](https://support.huaweicloud.com/twp-kunpengsdss/kunpengsdss_19_0021.html)**

# Bcache

​                        更新时间：2021/01/18 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/twp-kunpengsdss/kunpengsdss-twp.pdf) 			

​	[分享](javascript:void(0);) 

#### Bcache简介

Bcache是Linux内核块设备层cache，支持将一个或多个速度较快的磁盘设备（如SSD）作为读写速度相对较慢的磁盘设备的cache。Bcache从Linux-3.10开始正式并入内核主线。

Bcache具有以下特征：

1. 一个缓存设备可以作为多个设备的缓存，并且可以在设备运行时动态添加和删除缓存。
2. 可以从非正常状态关机中恢复，只有当缓存写入到后端设备才会确认写完成。
3. 正确处理写阻塞和刷缓存。
4. 支持writethrough、writeback和writearound等写缓存模式。
5. 检测并避开顺序IO（可配置阈值，或关闭该选项）。
6. 当检测到SSD延迟超过配置边界值，减少到SSD流量（当一个SSD作为多个磁盘缓存时使用）。
7. 缓存不命中时预读（默认关闭）。
8. 高性能的writeback实现：脏数据通过排序后再刷到磁盘中。如果设置了writeback_percent值，后台的writeback进程利用PD控制器根据脏数据比例平滑地处理脏数据。
9. 使用高效率的B+树，硬件设备足够快速的情况下，bcache随机读可以达到1M IOPS。
10. 可在生产中稳定的使用。

#### Bcache的缓存策略

Bcache支持三种缓存策略：writeback（回写策略）、writethrough（写通策略）、writearound（旁路策略）。默认使用writethrough，缓存策略可动态修改。

- writeback：此策略模式下，则所有的数据将先写入缓存盘，然后等待系统将数据回写到后端数据盘中，此策略默认关闭。
- writethrough：此策略模式下，数据同时写入缓存盘和后端数据盘，适用于读多写少的场景，此策略默认打开。
- writearound：选择此策略，数据将直接写入后端磁盘。

#### 常用优化方法

1. 设置writeback提高写性能。

   **echo writeback > /sys/block/bcache0/bcache/cache_mode**

2. 允许缓存顺序I/O或者顺序I/O阈值。

3. 支持缓存顺序IO。

   **echo 0 > /sys/block/bcache0/bcache/sequential_cutoff**

4. 调整顺序IO阈值。

   **echo 4M > /sys/block/bcache0/bcache/sequential_cutoff**

   上述设置，当顺序IO缓存量超过该阈值后，相应的IO将直接写到后端数据盘上。

1. 关闭拥塞控制项。

   **echo 0 > /sys/fs/bcache/<cache set uuid>/congested_read_threshold_us**

   **echo 0 > /sys/fs/bcache/<cache set uuid>/congested_write_threshold_us**

   **congested_read_threshold_us 默认为2000us；**

   **congested_write_threshold_us默认为20000us；**

更多信息详见bcache主页及手册：

https://bcache.evilpiepirate.org/

https://evilpiepirate.org/git/linux-bcache.git/tree/Documentation/bcache.txt

# Journal

​                        更新时间：2021/01/18 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/twp-kunpengsdss/kunpengsdss-twp.pdf) 			

​	[分享](javascript:void(0);) 

Ceph的OSD使用日志有两个原因：速度和一致性。

- 速度：日志使得OSD可以快速地提交小块数据的写入，Ceph把小片、随机IO依次写入日志，这样，后端文件系统就有可能归并写入动作，并最终提升并发承载力。因此，使用OSD日志能展现出优秀的突发写性能，实际上数据还没有写入OSD，因为文件系统把它们捕捉到了日志。
- 一致性：Ceph的OSD守护进程需要一个能保证原子操作的文件系统接口。OSD把一个操作的描述写入日志，然后把操作应用到文件系统，这需要原子更新一个对象（例如归置组元数据）。每隔一段时间，OSD停止写入、把日志同步到文件系统，这样允许OSD修整日志里的操作并重用空间。若失败，OSD从上个同步点开始重放日志。

# 多副本

​                        更新时间：2021/01/18 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/twp-kunpengsdss/kunpengsdss-twp.pdf) 			

​	[分享](javascript:void(0);) 

Ceph分布式存储采用数据多副本备份机制来保证数据的可靠性，默认保存为3个副本（可修改）。Ceph采用CRUSH算法，在大规模集群下，实现数据的快速、准确存放，同时能够在硬件故障或扩展硬件设备时，做到尽可能小的数据迁移，其原理如下：

1. 当用户要将数据存储到Ceph集群时，数据先被分割成多个object（每个object一个object id，大小可设置，默认是4MB），object是Ceph存储的最小存储单元。
2. 由于object的数量很多，为了有效减少了object到OSD的索引表、降低元数据的复杂度，使得写入和读取更加灵活，引入了pg（Placement Group）：PG用来管理object，每个object通过Hash，映射到某个pg中，一个pg可以包含多个object。
3. Pg再通过CRUSH计算，映射到osd中。如果是三副本的，则每个pg都会映射到三个osd，保证了数据的冗余。

**图1** CRUSH算法资源划分示意图
![点击放大](https://support.huaweicloud.com/twp-kunpengsdss/zh-cn_image_0000001089001465.png)

CRUSH算法并不是绝对不变的，会受其他因素影响，影响因素主要有：

1. 当前系统状态（Cluster Map）

   当系统中的OSD状态、数量发生变化，会引起Cluster Map发生变化，这边变化就会影响PG与OSD的映射关系。

2. 存储策略配置（存储策略主要与数据安全相关）

   通过策略可以指定同一个PG的3个OSD分别位于数据中心的不同服务器甚至不同机柜上，从而更加完善存储的可靠性。

如[图2](https://support.huaweicloud.com/twp-kunpengsdss/kunpengsdss_19_0020.html#kunpengsdss_19_0020__fig16670523)所示，对于节点Server1的磁盘Disk1上的数据块P1，它的数据备份为节点Server2的磁盘Disk2上P1'，P1和P1'构成了同一个数据块的两个副本。例如，当P1所在的硬盘故障时，P1'可以继续提供存储服务。

**图2** Ceph分布式存储多副本示意图
![点击放大](https://support.huaweicloud.com/twp-kunpengsdss/zh-cn_image_0000001089261231.png)

**父主题：** [公共特性](https://support.huaweicloud.com/twp-kunpengsdss/kunpengsdss_19_0017.html)

# Erasure code

​                        更新时间：2021/01/18 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/twp-kunpengsdss/kunpengsdss-twp.pdf) 			

​	[分享](javascript:void(0);) 

纠删码（Erasure  Coding，EC）是一种编码容错技术，最早是在通信行业解决部分数据在传输中的损耗问题。其基本原理就是把传输的信号分段，加入一定的校验再让各段间发生相互关联，即使在传输过程中丢失部分信号，接收端仍然能通过算法将完整的信息计算出来。在数据存储中，纠删码将数据分割成片段，把冗余数据块扩展和编码，并将其存储在不同的位置，例如磁盘、存储节点或者其他地理位置。

从纠删码基本的形态看，它是k个数据块+m个校验块的结构，其中k和m值可以按照一定的规则设定，可以用公式：n=k+m来表示。变量k代表原始数据或符号的值。变量m代表故障后添加的提供保护的额外或冗余符号的值。变量n代表纠删码过程后创建的符号的总值。当小于或等于m个存储块（数据块或校验块）损坏的情况下，整体数据块可以通过计算剩余存储块上的数据得到，整体数据不会丢失。

下面以k=3，m=2为例，介绍一下如何以纠删码的形式将一个名称为NYAN的对象存放在Ceph中，假定该对象的内容为ABCDEFGHI。客户端在将NYAN上传到Ceph以后，会在主OSD中调用相应的纠删码算法对数据进行编码计算：将原来的ABCDEFGHI拆分成三个分片，之后再计算出另外两个校验条带分片（内容为YXY QGC）。按照crushmap所指定的规则，将这5个分片随机分布在5个不同的OSD上面，完成对这个对象的存储操作，如[图1](https://support.huaweicloud.com/twp-kunpengsdss/kunpengsdss_19_0021.html#kunpengsdss_19_0021__fig15249547184012)所示。

**图1** 以纠删码的形式将一个名称为NYAN的对象存放在Ceph示例
![点击放大](https://support.huaweicloud.com/twp-kunpengsdss/zh-cn_image_0000001089261257.png)

下面再看一下如何使用纠删码读取数据，同样还是以NYAN为例。客户端在发起读取NYAN请求以后，这个对象所在PG的主OSD会向其他关联的OSD发起读取请求，比如主OSD是图中的OSD1，当请求发送到了其他4个OSD，此时刚好OSD4出现故障无法回应请求，导致最终只能获取到OSD1(GHI)、OSD3(YXY)和OSD5（ABC）的条带分片，OSD2虽然也收到请求并发送数据，但OSD2是最慢被接收的，此时OSD1作为主OSD会对OSD1、OSD3和OSD5的数据分片做纠删码解码操作，OSD2上面的分片内容会被忽略，之后重新组合出新的NYAN内容(ABCDEFGHI)，最终将该结果返回给客户端。



#### 简要介绍

Bcache是Linux内核块层cache，使用SSD来作为HDD硬盘的cache，从而起到加速作用。Bcache内核模块仅在Linux 3.10及以上版本支持，因此使用Bcache，需要将内核升级到3.10及以上版本。

更多详情见Bcache主页和使用手册：

https://bcache.evilpiepirate.org/

https://evilpiepirate.org/git/linux-bcache.git/tree/Documentation/bcache.txt

# 环境要求

​                        更新时间：2021/03/10 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengsdss-prtg.pdf) 			

​	[分享](javascript:void(0);) 

#### 操作系统要求

操作系统要求如[表1](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengbcache_02_0002.html#kunpengbcache_02_0002__table5438964)所示。



| 项目   | 版本   |
| ------ | ------ |
| CentOS | 7.6    |
| Kernel | 4.14.0 |

# 配置编译环境

​                        更新时间：2021/03/10 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengsdss-prtg.pdf) 			

​	[分享](javascript:void(0);) 

1. 重新编译内核将PAGESIZE改为4K，并打开Bcache开关。

2. 下载Bcache工具包bcache-tools 1.0.8。

   

   https://github.com/g2p/bcache-tools/releases

   

3. 安装编译依赖。

   

   **yum -y install elfutils-libelf-devel bc openssl-devel ncurses-devel libssl-dev**

   ![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

   如果发现依赖包缺失，可以mount镜像包，配置本地镜像源。具体参见[配置本地yum仓库](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengbcache_02_0010.html#kunpengbcache_02_0010__section7533185720423)。

# 获取源码

​                        更新时间：2021/03/10 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengsdss-prtg.pdf) 			

​	[分享](javascript:void(0);) 

1. 创建路径。

   

   **mkdir /root/kernel**

   **cd /root/kernel**

   

2. 下载CentOS 7.6内核源码。

   

   - 方法一：在线下载

     下载地址：[kernel-alt-4.14.0-115.el7a.0.1.src.rpm](http://vault.centos.org/centos/7.6.1810/os/Source/SPackages/kernel-alt-4.14.0-115.el7a.0.1.src.rpm)

   - 方法二：本地下载

     **wget** **http://vault.centos.org/centos/7.6.1810/os/Source/SPackages/kernel-alt-4.14.0-115.el7a.0.1.src.rpm**

   

3. 解压源码包。

   

   **rpm2cpio kernel-alt-4.14.0-115.el7a.0.1.src.rpm | cpio -div**

   **tar -vxf linux-4.14.0-115.el7a.tar.xz**

# 编译和安装

​                        更新时间：2021/03/10 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengsdss-prtg.pdf) 			

​	[分享](javascript:void(0);) 

1. 复制本地config文件到源码路径下。

   

   **cd /root/kernel/linux-4.14.0-115.el7a/**

   **cp  /boot/config-4.14.0-115.el7a.0.1.aarch64  .config**

   

2. 编译配置.config文件，更改页大小为4K。

   

   1. **make menuconfig**

   2. “Kernel Features > Page size (64KB) > Page size (4KB)”

       保存 #Page size调整为4K。

      ![点击放大](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0208912561.png)

   3. 按“Enter”键进入下一页。

      ![点击放大](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0208912493.png)

   4. 按“Enter”键进入Page size选择页，按上下键选择4KB，16KB，64KB，此处选中4KB，按“Enter”键退出。

      ![点击放大](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0208912797.png)

   5. 按左右键移动光标到“Exit”选项，按“Enter”键退出。

      ![点击放大](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0208912564.png)

   

3. 打开Bcache模块。

   

   1. 回退到最外层菜单，选择

      “Device Drivers > Multiple device driver support (RAID and LVM )”

      ，按“Enter”键进入下一级菜单。

      ![点击放大](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0208912567.png)

      ![点击放大](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0208912532.png)

   1. 选中“Block device as cache”，输入“Y”选中。

      ![点击放大](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0208912517.png)

      ![点击放大](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0208912539.png)

   

4. 

   

   自定义kernel版本。

   

   1. 在最外层菜单，选择

      “General setup > Local version – append to kernel release”

      。

      ![点击放大](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0208912543.png)

   2. 输入自定义kernel版本，如“bcache_kernel”。

      ![点击放大](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0208912769.png)

   

5. 按照原名保存。

   

   ![点击放大](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0208912779.png)

   ![点击放大](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0208912778.png)

   

6. 退出。

   

   ![点击放大](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0208933746.png)

   

7. 删除CONFIG_SYSTEM_TRUSTED_TRUSTED_KEYS配置。

   

   1. **vi .config**

   2. 找到“CONFIG_SYSTEM_TRUSTED_KEYS”，将

      CONFIG_SYSTEM_TRUSTED_KEYS="certs/centos.pem"

       

        修改为

      CONFIG_SYSTEM_TRUSTED_KEYS=""

      ，以下是修改后的呈现。

      ```
      CONFIG_MODULE_SIG_KEY="certs/signing_key.pem"
      CONFIG_SYSTEM_TRUSTED_KEYRING=y
      CONFIG_SYSTEM_TRUSTED_KEYS=""
      #  CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
      #  CONFIG_SECONDARY_TRUSTED_KEYRING is not set
      #  CONFIG_SYSTEM_BLACKLIST_KEYRING is not set
      ```

1. 1. 
   2. 保存并退出。

   

2. 打开.config文件，确认“CONFIG_ARM64_4K_PAGES”是否为“y”，“CONFIG_BCACHE”是否为“y”。

   

   ![img](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0208940100.png)

   ![img](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0208940108.png)

   

3. 生成RPM包。

   

   **make rpm**

   ![点击放大](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0208941263.png)

   ![点击放大](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0208994402.png)

   上图中红色方框部分为保存的RPM包路径。

   

1. 安装新内核RPM包。

   

   **cd /root/rpmbuild/RPMS/aarch64/**

   **yum install -y kernel-4.14.0bcache_kernel-1.aarch64.rpm**

   **yum install -y  kernel-devel-4.14.0bcache_kernel-1.aarch64.rpm**

   **yum install -y kernel-headers-4.14.0bcache_kernel-1.aarch64.rpm**

   

**父主题：** [Bcache 移植指南（CentOS 7.6）](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengsdss_02_0001.html)

# 运行和验证

​                        更新时间：2021/03/10 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengsdss-prtg.pdf) 			

​	[分享](javascript:void(0);) 

- **[设置系统默认启动的内核版本](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengbcache_02_0007.html)**
- **[安装bcache配置工具](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengbcache_02_0008.html)**
- **[Bcache基础操作](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengbcache_02_0009.html)**

# 设置系统默认启动的内核版本

​                        更新时间：2021/03/10 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengsdss-prtg.pdf) 			

​	[分享](javascript:void(0);) 

1. 查看Bcache内核版本。

   

   **cat /etc/grub2-efi.cfg | grep "bcache_kernel"**

   ![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

   "bcache_kernel”为自定义内核版本信息，见“编译和安装”章节[步骤4](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengbcache_02_0005.html#kunpengbcache_02_0005__li169941900533)。

   

2. 找到单引号中的内核版本，此处是CentOS Linux (4.14.0bcache_kernel) 7 (AltArch)。

   

   ```
   [root@ceph1 aarch64]# cat /etc/grub2-efi.cfg  | grep bcache_kernel
   menuentry 'CentOS Linux (4.14.0bcache_kernel) 7 (AltArch)' --class centos --class gnu-linux --class gnu --class os --unrestricted $menuentry_id_option 'gnulinux-4.14.0-115.el7a.0.1.aarch64-advanced-9ba3eaee-5c33-4412-8a03-e3ed8a6c2826' {
           linux /vmlinuz-4.14.0bcache_kernel root=/dev/mapper/centos-root ro crashkernel=auto rd.lvm.lv=centos/root rd.lvm.lv=centos/swap rhgb quiet LANG=en_US.UTF-8
           initrd /initramfs-4.14.0bcache_kernel.img
   ```

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

若未设置自定义的内核版本名称，可通过 **grep "menuentry"**筛选，系统自带的内核版本有4.14.0-115相应信息。



设置带Bcache的内核为系统默认启动内核，此处设置为用户自定义的版本。



**grub2-set-default “user-defined version”**

以bcache_kernel为例，此处应执行:

**grub2-set-default 'CentOS Linux (4.14.0bcache_kernel) 7 (AltArch)'**



确认修改生效。



**grub2-editenv list**

```
[root@ceph1 aarch64]# grub2-editenv list
saved_entry=CentOS Linux (4.14.0bcache_kernel) 7 (AltArch)
```

1. 

2. 重启系统。

   

   **reboot**

   重启后，按上述的内核配置编译，bcache模块已经bulit-in kernel，直接使用即可。可以通过查看“/sys/fs/bcache”目录或者是查看“/lib/modules/<kernel version>/kernel/drivers/md/bcache.ko”确认bcache是否存在。

   

**父主题：** [运行和验证](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengbcache_02_0006.html)

# 安装bcache配置工具

​                        更新时间：2021/03/10 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengsdss-prtg.pdf) 			

​	[分享](javascript:void(0);) 

#### 操作准备

Bcache通过**make-bcache**命令完成bcache的创建，需要安装相关的工具包bcache-tools。

下载链接：https://github.com/g2p/bcache-tools/releases。

版本：v1.0.8

#### 操作步骤

1. 通过传输工具将下载的bcache-tools-1.0.8.tar.gz包上传到“/home”目录下。

2. 解压缩。

   

   **cd /home/**

   **tar -zxvf bcache-tools-1.0.8.tar.gz**

   **cd /home/bcache-tools-1.0.8**

   

3. 安装依赖。

   

   **yum install libblkid-devel -y**

   

4. 安装。

   

   **make**

   **make install**

   

5. 执行**make-bcache**命令，如下图所示。

   

   ![img](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0209045494.png)

   

**父主题：** [运行和验证](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengbcache_02_0006.html)

​					 					 [上一篇：设置系统默认启动的内核版本 					](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengbcache_02_0007.html) 				 				 			

​					 					 [下一篇：Bcache基础操作](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengbcache_02_0009.html) 				 				 			

# Bcache基础操作

​                        更新时间：2021/03/10 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengsdss-prtg.pdf) 			

​	[分享](javascript:void(0);) 

- 创建Bcache后端和缓存磁盘。

  **make-bcache  -B /dev/sdx1 -C /dev/sdx2**

  ![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

  -B：指定后端磁盘设备（即数据盘）

  -C：指定缓存设备（用于加速数据盘）

  此处以sdb为后端磁盘，sdc为缓存设备为例。

  **make-bcache  -B /dev/sdb -C /dev/sdc**

  ![img](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0209003205.png)

- 删除缓存盘。

  1. 查看缓存盘的cset-uuid。

     **bcache-super-show /dev/sd\***

     以sdc为例：

     **bcache-super-show /dev/sdc**

     ![点击放大](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0209003279.png)

  2. 删除缓存操作。

     **echo cset-uuid  > /sys/block/bcahce<n>/bcache/detach**

     举例：

     **echo 5f50eddf-69d8-45e3-9b67-7386ffdaceb7 > /sys/block/bcache0/bcache/detach**

     此时sdc与bcache0解除绑定。

     ![img](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0209003263.png)

     ![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

     若需要恢复缓存，可通过以下方式重新绑定缓存：

     **echo cset-uuid  > /sys/block/bcahce<n>/bcache/attach**

- 注销缓存盘。

  **echo 1  > /sys/fs/bcache/<cset-uuid>/unregister**

  举例：

  **echo 1  > /sys/fs/bcache/5f50eddf-69d8-45e3-9b67-7386ffdaceb7/unregister**

- 停用缓存盘。

  **echo 1  > /sys/fs/bcache/<cset-uuid>/stop**

  举例：

  **echo 1  > /sys/fs/bcache/5f50eddf-69d8-45e3-9b67-7386ffdaceb7/stop**

- 停用后端设备。

  **echo 1 > /sys/block/bcahce<n>/bcache/stop**

  举例：

  **echo 1 > /sys/block/bcache0/bcache/stop**

  此时 sdb，sdc均与bcache0解除绑定关系

  ![img](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0209003336.png)

- 卸载bcache模块。

  **rmmod bcache**

  ![img](https://res-img2.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-notice.svg)须知： 

  卸载后bcache无法使用。

**父主题：** [运行和验证](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengbcache_02_0006.html)

​					 					 [上一篇：安装bcache配置工具 					](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengbcache_02_0008.html) 				 				 			

​					 					 [下一篇：更多资源](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengbcache_02_0010.html) 				 				 			

Ceph 是一个专注于分布式的、弹性可扩展的、高可靠的、性能优异的存储系统平台，可以同时支持块设备、文件系统和对象网关三种类型的存储接口。Ceph架构如[图1](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengceph_02_0001.html#kunpengceph_02_0001__zh-cn_topic_0185813847_fig3121152)所示。

**图1** Ceph架构
![img](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0000001132290865.png)

图中模块说明如[表1](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengceph_02_0001.html#kunpengceph_02_0001__zh-cn_topic_0185813847_table51486751)所示。



| 模块名称 | 功能描述                                                     |
| -------- | ------------------------------------------------------------ |
| RADOS    | RADOS（Reliable Autonomic Distributed Object  Store，RADOS）是Ceph存储集群的基础。Ceph中的一切都以对象的形式存储，而RADOS就负责存储这些对象，而不考虑它们的数据类型。RADOS层确保数据一致性和可靠性。对于数据一致性，它执行数据复制、故障检测和恢复，还包括数据在集群节点间的recovery。 |
| OSD      | 实际存储数据的进程。通常一个OSD daemon绑定一个物理磁盘。Client write/read数据最终都会走到OSD去执行write/read操作。 |
| MON      | Monitor在Ceph集群中扮演者管理者的角色，维护了整个集群的状态，是Ceph集群中最重要的组件。MON保证集群的相关组件在同一时刻能够达成一致，相当于集群的领导层，负责收集、更新和发布集群信息。为了规避单点故障，在实际的Ceph部署环境中会部署多个MON，同样会引来多个MON之前如何协同工作的问题。 |
| MGR      | MGR目前的主要功能是一个监控系统，包含采集、存储、分析（包含报警）和可视化几部分，用于把集群的一些指标暴露给外界使用。 |
| Librados | 简化访问RADOS的一种方法，目前支持PHP、Ruby、Java、Python、C和C++语言。它提供了Ceph存储集群的一个本地接口RADOS，并且是其他服务（如RBD、RGW）的基础，此外，还为CephFS提供POSIX接口。Librados API支持直接访问RADOS，使开发者能够创建自己的接口来访问Ceph集群存储。 |
| RBD      | Ceph块设备，对外提供块存储。可以像磁盘一样被映射、格式化和挂载到服务器上。 |
| RGW      | Ceph对象网关，提供了一个兼容S3和Swift的RESTful API接口。RGW还支持多租户和OpenStack的Keystone身份验证服务。 |
| MDS      | Ceph元数据服务器，跟踪文件层次结构并存储只供CephFS使用的元数据。Ceph块设备和RADOS网关不需要元数据。MDS不直接给Client提供数据服务。 |
| CephFS   | 提供了一个任意大小且兼容POSlX的分布式文件系统。CephFS依赖Ceph MDS来跟踪文件层次结构，即元数据。 |

#### 建议的版本

建议使用的版本为“14.2.1”。

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

本文档适用于Ceph 14.2.1，其他版本的移植步骤可参考本文档。

# 环境要求

​                        更新时间：2021/01/21 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengsdss-prtg.pdf) 			

​	[分享](javascript:void(0);) 

#### 硬件要求

硬件要求如[表1](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengceph_02_0002.html#kunpengceph_02_0002__table38928044)所示。



| 项目   | 说明                                                         |
| ------ | ------------------------------------------------------------ |
| 服务器 | TaiShan 200服务器（型号2280）或TaiShan 200服务器（型号5280） |
| CPU    | 鲲鹏920处理器                                                |

#### 操作系统要求

操作系统要求如[表2](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengceph_02_0002.html#kunpengceph_02_0002__table5438964)所示。



| 项目   | 版本                                     |
| ------ | ---------------------------------------- |
| CentOS | CentOS Linux release 7.6.1810 (AltArch） |
| Kernel | 4.14.0-115.el7a.0.1.aarch64              |

 

1. 安装SCL软件集。

   

   `yum -y install centos-release-scl `





修改SCL repo源。



```
vi /etc/yum.repos.d/CentOS-SCLo-scl.repo 
```



添加以下字段：

```
baseurl=http://mirror.centos.org/altarch/7/sclo/$basearch/rh/ 
```



![点击放大](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0215981096.png)



模拟gcc7编译环境。



```
yum -y install devtoolset-7 scl enable devtoolset-7 bash gcc --version 
```

1. 

   ![点击放大](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0215981536.png)

   

**父主题：** [Ceph 14.2.1 移植指南（CentOS 7.6）](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengsdss_02_0002.html)

# 安装依赖包

​                        更新时间：2021/01/21 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengsdss-prtg.pdf) 			

​	[分享](javascript:void(0);) 

#### 获取源码

源码下载链接：https://download.ceph.com/tarballs/

![点击放大](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0226694127.png)

下载完成后将源码包放入服务器“/home”目录下。

#### 安装依赖包

1. 进入“/home”目录，解压源码包并进入解压后的目录。

   

   `cd /home && tar -zxvf ceph-14.2.1.tar.gz && cd ceph-14.2.1/ `





修改scl-rh repo源中http为https。



```
vi /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo 
```



![img](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0226694170.png)



设置yum证书验证。



```
vi /etc/yum.conf 
```



```
sslverify=false 
```



![点击放大](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0226694171.png)



修改install-deps.sh中“x86_64”为“aarch64”。



```
vi /home/ceph-14.2.1/install-deps.sh 
```



![点击放大](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0226694172.png)



运行install-deps.sh，安装依赖包。



```
./install-deps.sh 
```

1. 

   

**父主题：** [Ceph 14.2.1 移植指南（CentOS 7.6）](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengsdss_02_0002.html)

# 编译安装与运行验证

​                        更新时间：2021/01/21 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/prtg-kunpengsdss/kunpengsdss-prtg.pdf) 			

​	[分享](javascript:void(0);) 

#### 编译和安装

1. 修改“do_cmake.sh”中的“-DCMAKE_BUILD_TYPE”为“RelWithDebInfo”。

   

   `vi do_cmake.sh `



修改为以下内容：

![点击放大](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0226694174.png)

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

默认的“do_cmake.sh”会编译一个DEBUG环境，为了不影响性能，使用参数“-DCMAKE_BUILD_TYPE=RelWithDebInfo”，取消DEBUG编译。



安装RPM打包工具，并设置rpmbuild默认目录为“/home”。



1. 安装

   rpmdevtools。

   `yum install rpmdevtools -y `



安装rpmbuild。

```
rpmdev-setuptree 
```

1. 

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

若使用root用户进行编译，则会在“/root”目录下生成一个“rpmbuild”目录，由于编译过程会占用20~30GB左右的空间，若“/root”目录下空间较小，可以更改“rpmbuild”目录到其他路径下，如“/home”目录：

1. 执行rpmbuild安装命令之后修改“.rpmmacros”文件。

   `vi /root/.rpmmacros `



修改“%_topdir”为“/home/rpmbuild”

![点击放大](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0226694175.png)

再次执行rpmbuild安装命令。

```
rpmdev-setuptree 
```

1. 



将源码包中的ceph.spec文件拷贝到SPECS中。



```
cp /home/ceph-14.2.1/ceph.spec /home/rpmbuild/SPECS/ 
```





在ceph.spec文件开头添加字段。



```
vi /home/rpmbuild/SPECS/ceph.spec 
```



添加字段如下：

```
%define _binaries_in_noarch_packages_terminate_build 0 
```



![img](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0226694177.png)



回到“/home”目录，将源码包打包为tar.bz2格式。



```
cd /home/ && tar -cjvf ceph-14.2.1.tar.bz2 ceph-14.2.1 
```





将打包好的文件放到SOURCES目录下。



```
cp ceph-14.2.1.tar.bz2 /home/rpmbuild/SOURCES/ 
```





使用rpmbuild开始编译。



```
rpmbuild -bb /home/rpmbuild/SPECS/ceph.spec 
```



![img](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0226694178.png)

编译过程需要花费较长时间，编译完成后会在“/home/rpmbuild/RPMS/”目录下生成两个目录“aarch64”和“noarch”，其中包含有Ceph相关的RPM包。

![点击放大](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0226694179.png)



使用yum命令安装RPM包。



```
yum -y install /home/rpmbuild/RPMS/aarch64/*.rpm 
```



![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

- aarch64目录下的RPM包都是ceph的核心组件和依赖，涵盖了块（RBD）、文件（CephFS）和对象（RGW）三种存储模式。其中ceph-debuginfo-14.2.1-0.el7.aarch64.rpm和ceph-test-14.2.1-0.el7.aarch64.rpm不是必要组件，如果不需要在开发过程中调试ceph建议不安装这两个RPM包。

- noarch目录下的RPM包主要包含了一些Ceph的额外功能，如果没有明确需求可以不安装。

- 安装Ceph RPM包的过程中可能还会需要一些基础依赖包，建议让服务器能够接入互联网，yum命令会自动下载并安装依赖包。其中一些依赖包可能需要提前配置好epel源，执行如下命令即可配置epel源。

  `yum -y install epel-release `

1. - 

   

#### 运行和验证

验证Ceph版本，能正确显示版本为14.2.1说明安装成功。

```
ceph --version 
```



![点击放大](https://support.huaweicloud.com/prtg-kunpengsdss/zh-cn_image_0226694180.png)



#### 硬件要求

硬件要求如[表1](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephblock_04_0002.html#kunpengcephblock_04_0002__table121991951103717)所示。



| 服务器名称 | TaiShan 200服务器（型号2280）                                |
| ---------- | ------------------------------------------------------------ |
| 处理器     | 鲲鹏920 5230处理器                                           |
| 核数       | 2*32核                                                       |
| 主频       | 2600MHz                                                      |
| 内存大小   | 8*16GB                                                       |
| 内存频率   | 2933MHz                                                      |
| 网卡       | 以太网标卡-25GE（Hi1822）-四端口-SFP+                        |
| 硬盘       | 系统盘：RAID1（2*960GB SATA SSD） 数据盘：RAID模式下使能JBOD（12*4TB SATA HDD） |
| NVMe SSD   | 1*ES3000 V5 3.2TB NVMe SSD                                   |
| RAID卡     | LSI SAS3508                                                  |

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

由于安装过程中需要在线安装Ceph软件包及依赖包，请确保服务器可以接入互联网。

#### 软件要求

软件要求如[表2](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephblock_04_0002.html#kunpengcephblock_04_0002__table1768995793917)所示。



| 软件名称    | CentOS                        |
| ----------- | ----------------------------- |
| OS          | CentOS Linux release 7.6.1810 |
| Ceph        | 14.2.10 Nautilus              |
| ceph-deploy | 2.0.1                         |

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

- 本文档以Ceph 14.2.10版本进行说明，其他版本安装也可参考本文档。
- 如果是全新安装操作系统，安装方式建议不要使用最小化安装，否则很多软件包需要手动安装，可选择“Server with GUI”安装方式。

#### 集群环境规划

物理组网方式如[图1](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephblock_04_0002.html#kunpengcephblock_04_0002__fig621185394111)所示。

**图1** 物理组网图
![img](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0000001089002225.png)

集群部署如[表3](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephblock_04_0002.html#kunpengcephblock_04_0002__table60309786)所示。



| 集群  | 管理IP        | Public Network | Cluster Network |
| ----- | ------------- | -------------- | --------------- |
| ceph1 | 192.168.2.166 | 192.168.3.166  | 192.168.4.166   |
| ceph2 | 192.168.2.167 | 192.168.3.167  | 192.168.4.167   |
| ceph3 | 192.168.2.168 | 192.168.3.168  | 192.168.4.168   |

客户端部署如[表4](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephblock_04_0002.html#kunpengcephblock_04_0002__table53254482)所示。



| 客户端  | 管理IP        | 业务口IP      |
| ------- | ------------- | ------------- |
| client1 | 192.168.2.160 | 192.168.3.160 |
| client2 | 192.168.2.161 | 192.168.3.161 |
| client3 | 192.168.2.162 | 192.168.3.162 |

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

- 管理IP：用于远程SSH机器管理配置使用的IP。
- 内部集群IP（cluster network）：用于集群之间同步数据的IP，选取任意一个25GE网口配置即可。
- 外部访问IP（public network）：存储节点供其他节点访问的IP，选取任意一个25GE网口配置即可。
- 客户端当做压力机，需保证客户端业务口IP与集群的外部访问IP在同一个网段，建议选用25GE网口进行配置。

#### 硬盘划分

Ceph 14.2.10采用了BlueStore作为后端存储引擎，没有了Jewel版本的Journal盘分区的划分，而是变成DB分区（元数据分区）和WAL分区。这两个分区分别存储BlueStore后端产生的元数据和日志文件。

在集群部署时，每个Ceph节点配置12块4TB数据盘和1块3.2TB的NVMe盘。每个4TB数据盘作为一个OSD的数据分区，单个NVMe盘作为12个OSD的DB、WAL分区。一般WAL分区大于10GB就足够使用，Ceph官方文档建议每个DB分区不小于每个数据盘容量的4%，具体可根据NVMe盘容量灵活设置。在本方案中，以WAL分区设置为60GB、DB分区设置为180GB为例进行说明。

综上，对于一个OSD，分区如[表5](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephblock_04_0002.html#kunpengcephblock_04_0002__table46688182)所示。



| 数据盘 | DB分区 | WAL分区 |
| ------ | ------ | ------- |
| 4TB    | 180GB  | 60GB    |



# 配置部署环境

​                        更新时间：2021/02/23 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss-dpmg.pdf) 			

​	[分享](javascript:void(0);) 

#### 配置epel源

在所有集群和客户端节点执行下列命令以配置epel源。

```
yum install epel-release -y 
```



![img](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266851346.png)

#### 关闭防火墙

关闭本节点防火墙，需在所有Ceph节点和Client节点依次执行如下命令。

```
systemctl stop firewalld systemctl disable firewalld systemctl status firewalld 
```



![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266851354.png)

#### 配置主机名

1. 配置永久静态主机名，主机配置为ceph1~ceph3，客户机配置为client1~client3。

   

   1. 配置主机节点。

      ceph1节点：

      `hostnamectl --static set-hostname ceph1 `



![img](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266851330.png)

其余节点以此类推。

同理配置客户机节点。

client1节点：

```
hostnamectl --static set-hostname client1 
```

1. 

   其余节点以此类推。



修改域名解析文件。



```
vi /etc/hosts 
```



在各个集群和客户端节点的“/etc/hosts”中添加如下内容：

```
192.168.3.166   ceph1 192.168.3.167   ceph2 192.168.3.168   ceph3 192.168.3.160   client1 192.168.3.161   client2 192.168.3.162   client3 
```



#### 配置免密登录

需配置ceph1节点对所有主/客户机节点的免密（包括ceph1本身），此外需要配置client1节点对所有主/客户机节点的免密（包括client1本身）。

1. 在ceph1节点生成公钥，并发放到各个主机/客户机节点。

   

   `ssh-keygen -t rsa for i in {1..3}; do ssh-copy-id ceph$i; done for i in {1..3}; do ssh-copy-id client$i; done `



![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

输入第一条命令“**ssh-keygen -t rsa**”之后，按回车使用默认配置。

![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266851351.png)

![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266851342.png)



在client1节点生成公钥，并发放到各个主机/客户机节点。



```
ssh-keygen -t rsa for i in {1..3}; do ssh-copy-id ceph$i; done for i in {1..3}; do ssh-copy-id client$i; done 
```

1. 

   ![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

   输入第一条命令“**ssh-keygen -t rsa**”之后，按回车使用默认配置。

   

#### 关闭SELinux

关闭本节点SELinux，需在所有主客户机节点执行。

- 临时关闭，重启后失效，与下一条互补。

  `setenforce 0 `



![img](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266851350.png)

永久关闭，重启后生效。

```
vi /etc/selinux/config 
```

- 

  修改**SELINUX=disabled**

  ![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266851329.png)

#### 配置Ceph镜像源

1. 在所有集群和客户端节点建立ceph.repo。

   

   `vi /etc/yum.repos.d/ceph.repo `



并加入如下内容：

```
[Ceph]
name=Ceph packages for $basearch
baseurl=http://download.ceph.com/rpm-nautilus/el7/$basearch
enabled=1
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc
priority=1
 
[Ceph-noarch]
name=Ceph noarch packages
baseurl=http://download.ceph.com/rpm-nautilus/el7/noarch
enabled=1
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc
priority=1
 
[ceph-source]
name=Ceph source packages
baseurl=http://download.ceph.com/rpm-nautilus/el7/SRPMS
enabled=1
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc
priority=1
```



更新yum源。



```
yum clean all && yum makecache 
```

1. 

   ![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266851344.png)

   

**父主题：** [Ceph块存储 部署指南（CentOS 7.6）](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss_04_0004.html)

​					 					 [上一篇：环境要求 					](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephblock_04_0002.html) 				 				 			

​					 					 [下一](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephblock_04_0004.html)

# 安装Ceph

​                        

# 安装Ceph软件

​                    

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

使用**yum install**安装Ceph的时候会默认安装当前已有的最新版本，本文安装时的最新版本是Ceph 14.2.11，如果不想安装最新版本，可以在“/etc/yum.conf”文件中加以限制。例如现在yum默认安装的最新版本是Ceph  14.2.11，若想要安装Ceph 14.2.10，则需要做如下操作：

1. 编辑“

   /etc/yum.conf”文件

   。

   `vi /etc/yum.conf `



在[main]模块下添加如下内容：

```
exclude=*14.2.11*
```

1. 这样会把14.2.11版本过滤掉，可安装的最新版本就变成了14.2.10，再执行**yum install**命令时安装的就是Ceph 14.2.10。
2. 通过**yum list ceph**查看目前可安装版本。

1. 在所有集群和客户端节点安装Ceph。

   

   `yum -y install ceph `



![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0272259281.png)



在ceph1节点额外安装ceph-deploy。



```
yum -y install ceph-deploy 
```



![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266851364.png)



在各节点查看版本。



**ceph -v**

查询结果如下所示：

```
ceph version 14.2.10 (b340acf629a010a74d90da5782a2c5fe0b54ac20) nautilus (stable)
```

# 部署MON节点

​                        更新时间：2021/02/23 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss-dpmg.pdf) 			

​	[分享](javascript:void(0);) 

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

只需要在主节点ceph1执行。

1. 创建集群。

   

   `cd /etc/ceph ceph-deploy new ceph1 ceph2 ceph3 `



![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266851327.png)



在“/etc/ceph”目录下自动生成的ceph.conf文件中配置网络mon_host、public network、cluster network。



```
vi /etc/ceph/ceph.conf 
```



将ceph.conf中的内容修改为如下所示：

```
[global] fsid = f6b3c38c-7241-44b3-b433-52e276dd53c6 mon_initial_members = ceph1, ceph2, ceph3 mon_host = 192.168.3.166,192.168.3.167,192.168.3.168 auth_cluster_required = cephx auth_service_required = cephx auth_client_required = cephx public_network = 192.168.3.0/24 cluster_network = 192.168.4.0/24 [mon] mon_allow_pool_delete = true 
```



![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

- 配置节点命令以及使用ceph-deploy配置OSD时，需在“/etc/ceph”目录下执行，否则会报错。
- 修改的目的是为了将内部集群间的网络与外部访问的网络隔离，192.168.4.0用于内部存储集群之间的数据同步（仅在存储节点间使用），而192.168.3.0用于存储节点与计算节点的数据交互。



初始化监视器并收集密钥。



```
ceph-deploy mon create-initial 
```



![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266851349.png)



将“ceph.client.admin.keyring”拷贝到各个节点上。



```
ceph-deploy --overwrite-conf admin ceph1 ceph2 ceph3 client1 client2 client3 
```



![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266851366.png)



查看是否配置成功。



```
ceph -s 
```



如下所示：

```
cluster:
id:     f6b3c38c-7241-44b3-b433-52e276dd53c6
health: HEALTH_OK

services:
mon: 3 daemons, quorum ceph1,ceph2,ceph3 (age 25h)
```

1. 

**父主题：** [安装Ceph](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephblock_04_0004.html)

​					 					 [上一篇：安装Ceph软件 					](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephblock_04_0005.html) 				 				 			

​					 					 

# 部署MGR节点

​                        更新时间：2021/02/23 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss-dpmg.pdf) 			

​	[分享](javascript:void(0);) 

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

仅需在主节点ceph1节点上执行。

1. 部署MGR节点。

   

   `ceph-deploy mgr create ceph1 ceph2 ceph3 `



![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266851333.png)



查看MGR是否部署成功。



```
ceph -s 
```



结果如下所示：

```
cluster:
id:     f6b3c38c-7241-44b3-b433-52e276dd53c6
health: HEALTH_OK

services:
mon: 3 daemons, quorum ceph1,ceph2,ceph3 (age 25h)
mgr: ceph1(active, since 2d), standbys: ceph2, ceph3
```

1. 

**父主题：** [安装Ceph](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephblock_04_0004.html)

# 部署OSD节点

​                        更新时间：2021/02/23 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss-dpmg.pdf) 			

​	[分享](javascript:void(0);) 

#### 划分OSD分区

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

以下操作在3个ceph节点均执行一遍，此处以/dev/nvme0n1为例说明，如果有多块NVMe SSD或SATA/SAS接口SSD，只需将脚本中的/dev/nvme0n1盘符替换为对应盘符即可。

NVMe盘划分为12个60GB分区、12个180GB分区，分别对应WAL分区、DB分区：

1. 创建一个partition.sh脚本。

   

   `vi partition.sh `





添加如下内容：



```
#!/bin/bash parted /dev/nvme0n1 mklabel gpt for j in `seq 1 12` do ((b = $(( $j * 8 )))) ((a = $(( $b - 8 )))) ((c = $(( $b - 6 )))) str="%" echo $a echo $b echo $c parted /dev/nvme0n1 mkpart primary ${a}${str} ${c}${str} parted /dev/nvme0n1 mkpart primary ${c}${str} ${b}${str} done 
```



![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

此脚本内容只适用于当前硬件配置，其他硬件配置可参考此脚本。



创建完脚本后执行脚本。



```
bash partition.sh 
```

1. 

   

#### 部署OSD节点

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

以下脚本的“/dev/sda-/dev/sdl”12块硬盘均为数据盘，OS安装在“/dev/sdm”上。实际情况中可能会遇到OS硬盘位于数据盘中间的情况，比方说系统盘安装到了“/dev/sde”，则不能直接使用以下脚本直接运行，否则部署到“/dev/sde”时会报错。此时需要重新调整脚本，避免脚本中包含数据盘以外的如OS盘、做DB/WAL分区的SSD盘等。

1. 确认各个节点各硬盘的sd*。

   

   `lsblk `



![img](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266851360.png)

如图代表/dev/sda是系统盘。

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

有一些硬盘可能是以前Ceph集群里的数据盘或者曾经安装过操作系统，那么这些硬盘上很可能有未清理的分区，lsblk命令可以看到各个硬盘下是否有分区。假如/dev/sdb硬盘下发现有分区信息，可用如下命令清除：

```
ceph-volume lvm zap /dev/sdb --destroy 
```



![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-caution.svg)注意： 

必须先确定哪些盘做为数据盘使用，当数据盘有未清理的分区时再执行清除命令。



在ceph1上创建脚本create_osd.sh，将每台服务器上的12块硬盘部署OSD。



```
cd /etc/ceph/ vi /etc/ceph/create_osd.sh 
```



添加以下内容：

```
#!/bin/bash for node in ceph1 ceph2 ceph3 do j=1 k=2 for i in {a..l} do ceph-deploy osd create ${node} --data /dev/sd${i} --block-wal /dev/nvme0n1p${j} --block-db /dev/nvme0n1p${k} ((j=${j}+2)) ((k=${k}+2)) sleep 3 done done 
```



![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

- 此脚本内容只适用于当前硬件配置，其他硬件配置可参考此脚本。

- ceph-deploy osd create

  命令中:

  - ${node}是节点的hostname。
  - --data选项后面是作为数据盘的设备。
  - --block-db选项后面是DB分区。
  - --block-wal选项后面是WAL分区。

  DB和WAL通常部署在NVMe SSD上以提高写入性能，如果没有配置NVMe SSD或者直接使用NVMe SSD作为数据盘，则不需要--block-db和--block-wal，只需要--data指定数据盘即可。



在ceph1上运行脚本。



```
bash create_osd.sh 
```





创建成功后，查看是否正常，即36个OSD是否都为up。



```
ceph -s 
```

1. 

   

**父主题：** [安装Ceph](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephblock_04_0004.html)

# 验证Ceph

​                        更新时间：2021/02/23 GMT+08:00

​					

# 创建存储池

​                        更新时间：2021/02/23 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss-dpmg.pdf) 			

​	[分享](javascript:void(0);) 

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

- Ceph 14.2.1及以后的版本没有默认的存储池，需自行创建存储池，然后再在存储池中创建块设备。
- 仅需在主节点ceph1节点上执行。

1. 创建存储池，存储池的名字可自行命名，本文档命名为vdbench。

   

   `cd /etc/ceph ceph osd pool create vdbench 1024 1024 `



![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266851326.png)

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

- 命令中的vdbench是存储池名字，1024分别是pg、pgp的数量。
- 创建存储池命令最后的两个数字，比如**ceph osd pool create vdbench 1024 1024**中的两个1024分别代表存储池的pg_num和pgp_num，即存储池对应的pg数量。Ceph官方文档建议整个集群所有存储池的pg数量之和大约为：（OSD数量 * 100)/数据冗余因数，数据冗余因数对副本模式而言是副本数，对EC模式而言是数据块+校验块之和。例如，三副本模式是3，EC4+2模式是6。
- 此处整个集群3台服务器，每台服务器12个OSD，总共36个OSD，按照上述公式计算应为1200，一般建议pg数取2的整数次幂。

综上，vdbench的pg数量取1024。



Ceph 14.2.10版本创建存储池后，需指定池类型（CephFS、RBD、RGW）三种，本文以创建块存储为例。



```
ceph osd pool application enable vdbench rbd 
```



![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266851361.png)

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

- 命令中vdbench是存储池名字，rbd是指存储池类型。
- 命令后加上**--yes-i-really-mean-it**可对存储池类型进行修改。



（可选）存储池使能zlib压缩。



```
ceph osd pool set vdbench compression_algorithm zlib ceph osd pool set vdbench compression_mode force ceph osd pool set vdbench compression_required_ratio .99 
```



![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266851331.png)

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

本步骤用于使能OSD压缩，如果不需要压缩则可以跳过。

# 创建块设备

​                        更新时间：2021/02/23 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss-dpmg.pdf) 			

​	[分享](javascript:void(0);) 

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

仅需在ceph1上执行。

1. 创建脚本，在RBD存储池中创建30个块设备，每个块设备大小为200GB。

   

   `vi create_image.sh `





添加以下内容：



```
#!/bin/bash pool="vdbench" size="204800" createimages() { for image in {1..30} do rbd create image${image} --size ${size} --pool ${pool} --image-format 2 --image-feature layering sleep 1 done } createimages 
```



![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

此脚本内容只适用于当前硬件配置，其他硬件配置可参考此脚本。



执行脚本。



```
bash create_image.sh 
```





检查是否创建成功。



```
rbd ls --pool vdbench 
```



输出结果中包含image1、image2、image3......image29、image30则说明创建成功。

![img](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266851352.png)

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

上述命令中--pool指定存储池名称，用于查看该存储池下的image。

# 映射块设备镜像

​                        更新时间：2021/03/03 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss-dpmg.pdf) 			

​	[分享](javascript:void(0);) 

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

- 仅需在ceph1上执行，执行以下脚本会分别登录到client1、client2、client3上映射image为本地块设备，将上面步骤中创建的30个image映射到3台客户端，每台10个RBD。
- 块存储镜像在创建完image后就已经完成，以下步骤映射image为本地块设备为可选操作，可根据实际情况选择是否进行以下操作。

1. 创建脚本，在RBD存储池中创建30个块设备，每个块设备大小为200GB。

   

   `vi map_image.sh `





添加以下内容：



```
#!/bin/bash pool="vdbench" mapimages() { for i in {1..10} do ssh client1 "rbd map ${pool}/image${i}" done for i in {11..20} do ssh client2 "rbd map ${pool}/image${i}" done for i in {21..30} do ssh client3 "rbd map ${pool}/image${i}" done } mapimages 
```



![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

此脚本内容只适用于当前硬件配置，其他硬件配置可参考此脚本。



执行脚本。



```
bash map_image.sh 
```





分别登录client1、client2、client3，输入以下命令检查是否创建成功。



```
ls /dev |  grep rbd 
```

1. 

   输出结果中包含rbd0、rbd2、rbd3......rbd8、rbd9则说明创建成功。

   ![img](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266851353.png)

   

**父主题：** [验证Ceph](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephblock_04_0009.html)

​					 					 [上一篇：创建块设备 					](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephblock_04_0011.html) 				 				 			

​					 					 [下一篇：Ceph块存储 部署指南（openEuler 20.03）](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss_04_0005.html) 				 				 			

# 部署RGW节点

​                        更新时间：2021/02/23 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss-dpmg.pdf) 			

​	[分享](javascript:void(0);) 

本例在每个节点上创建12个RGW实例，3个节点共36个RGW实例，网关端口分别为10001-10036，网关名称分别为bucket1-bucket36。

#### 准备ceph.conf文件

1. 在ceph.conf文件中添加RGW实例的端口配置，在ceph1上编辑ceph.conf。

   

   ```
   vim /etc/ceph/ceph.conf
   ```

修改为以下内容：

```
[global] fsid = 4f238985-ad0a-4fc3-944b-da59ea3e65d7 mon_initial_members = ceph1, ceph2, ceph3 mon_host = 192.168.3.163,192.168.3.164,192.168.3.165 auth_cluster_required = cephx auth_service_required = cephx auth_client_required = cephx public_network = 192.168.3.0/24 cluster_network = 192.168.4.0/24  [mon] mon_allow_pool_delete = true  [client.rgw.bucket1] rgw_frontends = civetweb port=10001 log file = /var/log/ceph/client.rgw.bucket1.log [client.rgw.bucket2] rgw_frontends = civetweb port=10002 log file = /var/log/ceph/client.rgw.bucket2.log [client.rgw.bucket3] rgw_frontends = civetweb port=10003 log file = /var/log/ceph/client.rgw.bucket3.log [client.rgw.bucket4] rgw_frontends = civetweb port=10004 log file = /var/log/ceph/client.rgw.bucket4.log [client.rgw.bucket5] rgw_frontends = civetweb port=10005 log file = /var/log/ceph/client.rgw.bucket5.log [client.rgw.bucket6] rgw_frontends = civetweb port=10006 log file = /var/log/ceph/client.rgw.bucket6.log [client.rgw.bucket7] rgw_frontends = civetweb port=10007 log file = /var/log/ceph/client.rgw.bucket7.log [client.rgw.bucket8] rgw_frontends = civetweb port=10008 log file = /var/log/ceph/client.rgw.bucket8.log [client.rgw.bucket9] rgw_frontends = civetweb port=10009 log file = /var/log/ceph/client.rgw.bucket9.log [client.rgw.bucket10] rgw_frontends = civetweb port=10010 log file = /var/log/ceph/client.rgw.bucket10.log [client.rgw.bucket11] rgw_frontends = civetweb port=10011 log file = /var/log/ceph/client.rgw.bucket11.log [client.rgw.bucket12] rgw_frontends = civetweb port=10012 log file = /var/log/ceph/client.rgw.bucket12.log [client.rgw.bucket13] rgw_frontends = civetweb port=10013 log file = /var/log/ceph/client.rgw.bucket13.log [client.rgw.bucket14] rgw_frontends = civetweb port=10014 log file = /var/log/ceph/client.rgw.bucket14.log [client.rgw.bucket15] rgw_frontends = civetweb port=10015 log file = /var/log/ceph/client.rgw.bucket15.log [client.rgw.bucket16] rgw_frontends = civetweb port=10016 log file = /var/log/ceph/client.rgw.bucket16.log [client.rgw.bucket17] rgw_frontends = civetweb port=10017 log file = /var/log/ceph/client.rgw.bucket17.log [client.rgw.bucket18] rgw_frontends = civetweb port=10018 log file = /var/log/ceph/client.rgw.bucket18.log [client.rgw.bucket19] rgw_frontends = civetweb port=10019 log file = /var/log/ceph/client.rgw.bucket19.log [client.rgw.bucket20] rgw_frontends = civetweb port=10020 log file = /var/log/ceph/client.rgw.bucket20.log [client.rgw.bucket21] rgw_frontends = civetweb port=10021 log file = /var/log/ceph/client.rgw.bucket21.log [client.rgw.bucket22] rgw_frontends = civetweb port=10022 log file = /var/log/ceph/client.rgw.bucket22.log [client.rgw.bucket23] rgw_frontends = civetweb port=10023 log file = /var/log/ceph/client.rgw.bucket23.log [client.rgw.bucket24] rgw_frontends = civetweb port=10024 log file = /var/log/ceph/client.rgw.bucket24.log [client.rgw.bucket25] rgw_frontends = civetweb port=10025 log file = /var/log/ceph/client.rgw.bucket25.log [client.rgw.bucket26] rgw_frontends = civetweb port=10026 log file = /var/log/ceph/client.rgw.bucket26.log [client.rgw.bucket27] rgw_frontends = civetweb port=10027 log file = /var/log/ceph/client.rgw.bucket27.log [client.rgw.bucket28] rgw_frontends = civetweb port=10028 log file = /var/log/ceph/client.rgw.bucket28.log [client.rgw.bucket29] rgw_frontends = civetweb port=10029 log file = /var/log/ceph/client.rgw.bucket29.log [client.rgw.bucket30] rgw_frontends = civetweb port=10030 log file = /var/log/ceph/client.rgw.bucket30.log [client.rgw.bucket31] rgw_frontends = civetweb port=10031 log file = /var/log/ceph/client.rgw.bucket31.log [client.rgw.bucket32] rgw_frontends = civetweb port=10032 log file = /var/log/ceph/client.rgw.bucket32.log [client.rgw.bucket33] rgw_frontends = civetweb port=10033 log file = /var/log/ceph/client.rgw.bucket33.log [client.rgw.bucket34] rgw_frontends = civetweb port=10034 log file = /var/log/ceph/client.rgw.bucket34.log [client.rgw.bucket35] rgw_frontends = civetweb port=10035 log file = /var/log/ceph/client.rgw.bucket35.log [client.rgw.bucket36] rgw_frontends = civetweb port=10036 log file = /var/log/ceph/client.rgw.bucket36.log 
```





在所有集群节点上同步配置文件，在ceph1上执行。



```
ceph-deploy --overwrite-conf admin ceph1 ceph2 ceph3 
```

1. 

   ![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266854095.png)

   

#### 创建RGW实例

1. 在所有服务端节点安装RGW组件。

   

   `yum -y install ceph-radosgw `





创建RGW实例，在主节点ceph1上执行。



```
for i in {1..12};do ceph-deploy rgw create ceph1:bucket$i;done for i in {13..24};do ceph-deploy rgw create ceph2:bucket$i;done for i in {25..36};do ceph-deploy rgw create ceph3:bucket$i;done 
```





上述命令执行成功后，查看36个RGW进程是否在线。



**ceph -s**

如下图所示：

```
cluster:
id:     f6b3c38c-7241-44b3-b433-52e276dd53c6
health: HEALTH_OK

services:
mon: 3 daemons, quorum ceph1,ceph2,ceph3 (age 25h)
mgr: ceph3(active, since 2d), standbys: ceph2, ceph1
osd: 108 osds: 108 up (since 25h), 108 in (since 9d)
rgw: 36 daemons active (bucket1, bucket10, bucket11, bucket12, bucket13, bucket14, bucket15, bucket16, bucket17, bucket18, bucket19, bucket2, bucket20, bucket21, bucket22, bucket23, bucket24, bucket25, bucket26, bucket27, bucket28, bucket29, bucket3, bucket30, bucket31, bucket32, bucket33, bucket34, bucket35, bucket36, bucket4, bucket5, bucket6, bucket7, bucket8, bucket9)
```

1. 

**父主题：** [验证Ceph](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephobject_04_0009.html)

# 创建存储池

​                        更新时间：2021/02/23 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss-dpmg.pdf) 			

​	[分享](javascript:void(0);) 

对象存储需要用到多个存储池，把元数据等数据量较小的存储池建立在SSD上可提高性能。本例介绍在SSD上创建对象存储元数据存储池，在HDD上创建对象存储数据存储池。

Ceph的存储池默认使用三副本模式，其中对象存储数据存储池有时会设置为EC纠删码模式以节省存储空间，以下分两个部分分别介绍副本模式和EC模式存储池的创建方法。如果选用副本模式，请参考[创建副本存储池](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephobject_04_0011.html#kunpengcephobject_04_0011__section1624775854120)；如果选用EC模式，请参考[创建EC存储池](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephobject_04_0011.html#kunpengcephobject_04_0011__section1253211391422)。



#### 创建副本存储池

1. 查看crush类，在ceph1上执行。

   

   `ceph osd crush class ls `



![img](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266854085.png)

如果服务器上既有基于SSD的创建的OSD，又有基于HDD创建的OSD，则crush class会显示两种类型，如下所示：

```
[
"hdd",
"ssd"
]
```



为SSD class和HDD class分别创建crush rule，在ceph1上执行。



```
ceph osd crush rule create-replicated rule-ssd default host ssd ceph osd crush rule create-replicated rule-hdd default host hdd 
```



![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266854069.png)



查看crush rule是否创建成功，在ceph1上执行。



```
ceph osd crush rule ls 
```



![img](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266850384.png)

当前集群的crush rule如下所示：

```
replicated_rule
rule-ssd
rule-hdd
```

其中replicated_rule是集群默认使用的crush rule，若不指定crush  rule则默认使用这个。该rule是三副本模式，存储池的所有数据会按照一定比例存储到所有存储设备上（SSD和HDD上都会有数据存储），rule-ssd和rule-hdd则会分别只把数据存储到SSD上和HDD上。



创建Data Pool和Index Pool，在ceph1上执行。



```
ceph osd pool create default.rgw.buckets.data 1024 1024 ceph osd pool create default.rgw.buckets.index 256 256 ceph osd pool application enable default.rgw.buckets.data rgw ceph osd pool application enable default.rgw.buckets.index rgw 
```



![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

- 创建存储池命令最后的两个数字，比如**ceph osd pool create default.rgw.buckets.data 1024 1024**中的两个1024分别代表存储池的pg_num和pgp_num，即存储池对应的pg数量。Ceph官方文档建议整个集群所有存储池的pg数量之和大约为：（OSD数量 * 100)/数据冗余因数，数据冗余因数对副本模式而言是副本数，对EC模式而言是数据块+校验块之和。例如，三副本模式是3，EC4+2模式是6。
- 此处整个集群3台服务器，每台服务器15个OSD，总共45个OSD，按照上述公式计算应为1500，一般建议pg数取2的整数次幂。由于**default.rgw.buckets.data**存放的数据量远大于其他几个存储池的数据量，因此该存储池也成比例的分配更多的pg。

综上，**default.rgw.buckets.data**的pg数量取1024，**default.rgw.buckets.index**的pg数量取128或者256。



修改所有存储池的crush规则，在ceph1上执行。



```
for i in `ceph osd lspools | grep -v data | awk '{print $2}'`; do ceph osd pool set $i crush_rule rule-ssd; done ceph osd pool set default.rgw.buckets.data crush_rule rule-hdd 
```





取消Proxy配置，在ceph1、ceph2、ceph3上执行。



```
unset http_proxy unset https_proxy 
```

1. 

   

2. 使用curl或者web节点登录验证，要注意IP与端口的对应关系，下图以IP为192.168.3.164、端口为10013为例说明，出现如下字样表示RGW创建成功。

   

   ![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266854071.png)

   至此网关服务创建成功。

   



#### 创建EC存储池

1. 查看crush类，在ceph1上执行。

   

   `ceph osd crush class ls `



![img](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266854100.png)

如果服务器上既有基于SSD的创建的OSD，又有基于HDD创建的OSD，则crush class会显示两种类型，如下所示：

```
[
"hdd",
"ssd"
]
```



为SSD class创建crush rule，在ceph1上执行。



```
ceph osd crush rule create-replicated rule-hdd default host hdd 
```



![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266854093.png)



查看crush rule是否创建成功，在ceph1上执行。



```
ceph osd crush rule ls 
```



![img](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266854102.png)

当前集群的crush  rule如下所示，其中replicated_rule是集群默认使用的crush rule，若不指定crush  rule则默认使用这个。该rule是三副本模式，存储池的所有数据会按照一定比例存储到所有存储设备上（SSD和HDD上都会有数据存储），rule-ssd则会只把数据存储到SSD上。

```
replicated_rule
rule-hdd
```



创建EC profile。



```
ceph osd erasure-code-profile set myprofile k=4 m=2 crush-failure-domain=osd crush-device-class=hdd 
```



![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266854077.png)

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

以EC 4+2为例，以上命令创建了一个名为myprofile的EC  profile，k为数据块数量，m为校验块数量，crush-failure-domain=host表示最小故障域为host，crush-device-class=hdd表示crush rule建立在hdd上。

一般情况下，最小故障域设置为host，若host数量小于k+m，则需要将故障域改为osd，否则会因无法找到足够多的host而报错。



创建Data Pool和Index Pool，在ceph1上执行。



```
ceph osd pool create default.rgw.buckets.data 2048 2048 erasure myprofile ceph osd pool create default.rgw.buckets.index 256 256 ceph osd pool application enable default.rgw.buckets.data rgw ceph osd pool application enable default.rgw.buckets.index rgw 
```



![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

- **ceph-deploy osd pool create default.rgw.buckets.data 2048 2048 erasure myprofile**命令创建的是EC模式的pool，对于对象存储而言，只需修改default.rgw.buckets.data为EC pool即可，其他pool仍使用默认3副本模式。
- 创建存储池命令最后的两个数字，比如**ceph osd pool create default.rgw.buckets.data 2048 2048 erasure myprofile**中的两个2048分别代表存储池的pg_num和pgp_num，即存储池对应的pg数量。Ceph官方文档建议整个集群所有存储池的pg数量之和大约为：（OSD数量 * 100) /  数据冗余因数，数据冗余因数对副本模式而言是副本数，对EC模式而言是数据块+校验块之和。例如，三副本模式是3，EC4+2模式是6。
- 此处整个集群3台服务器，每台服务器36个OSD，总共108个OSD，按照上述公式计算应为1800，一般建议pg数取2的整数次幂。由于**default.rgw.buckets.data**存放的数据量远大于其他几个存储池的数据量，因此该存储池也成比例的分配更多的pg。

综上，**default.rgw.buckets.data**的pg数量取2048，**default.rgw.buckets.index**的pg数量取128或者256。



修改Data Pool以外所有存储池的crush规则，在ceph1上执行。



```
for i in `ceph osd lspools | grep -v data | awk '{print $2}'`; do ceph osd pool set $i crush_rule rule-ssd; done 
```





取消Proxy配置，在ceph1、ceph2、ceph3上执行。



```
unset http_proxy unset https_proxy 
```

1. 

   

2. 使用curl或者web节点登录验证，如下图所示。

   

   ![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266854098.png)

   至此网关服务创建成功。

   

**父主题：** [验证Ceph](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephobject_04_0009.html)

​					 					 [上一篇：部署RGW节点 					](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephobject_04_0010.html) 				 				 			

​					 					 [下一篇：创建RGW账户](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephobject_04_0012.html) 				 				 			

# 创建RGW账户

​                        更新时间：2021/02/23 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss-dpmg.pdf) 			

​	[分享](javascript:void(0);) 

为了在客户端访问Ceph对象存储，需要创建RGW账户。

1. 在ceph1上创建RGW账户。

   

   `radosgw-admin user create --uid="admin" --display-name="admin user" `





创建账户完成后查询账户信息。



```
radosgw-admin user info --uid=admin 
```

1. 

   ![img](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266854083.png)

   至此Ceph RGW OSD混合部署完毕。

   

**父主题：** [验证Ceph](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephobject_04_0009.html)

# 使能RGW压缩

​                        更新时间：2021/02/23 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss-dpmg.pdf) 			

​	[分享](javascript:void(0);) 

创建完RGW账户后便可以使用该账户访问RGW。如果想要使能RGW数据压缩功能，还需要创建压缩数据用的存储池，然后新增放置策略并指明压缩算法。

若需要使能RGW数据压缩功能，请参考如下内容。

#### 创建压缩存储池

执行以下命令创建压缩存储池。

```
ceph osd pool create default.rgw.buckets.data-compress 4096 4096 ceph osd pool create default.rgw.buckets.index-compress 256 256 ceph osd pool create default.rgw.buckets.non-ec-compress 64 64 ceph osd pool application enable default.rgw.buckets.data-compress rgw ceph osd pool application enable default.rgw.buckets.index-compress rgw ceph osd pool application enable default.rgw.buckets.non-ec-compress rgw 
```



![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

区别于普通的非压缩存储池，此处创建用于RGW使能压缩的存储池，分别作为接下来新建放置策略中的data_pool、index_pool与data_extra_pool。

与非压缩存储池类似，default.rgw.buckets.data-compress 也可创建EC模式的压缩数据存储池，创建方法参考[创建EC存储池](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephobject_04_0011.html#kunpengcephobject_04_0011__section1253211391422)。

#### 新增放置策略

Ceph对象存储集群有一个默认的放置策略default-placement，此处需要创建一个新的放置策略compress-placement，应用于RGW压缩。

1. 创建新的放置策略compress-placement，在ceph1上执行：

   

   `radosgw-admin zonegroup placement add --rgw-zonegroup=default --placement-id=compress-placement `



![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266854089.png)



填入compress-placement相关信息，包括该放置策略的存储池及压缩算法，在ceph1上执行：



```
radosgw-admin zone placement add --rgw-zone=default --placement-id=compress-placement --index_pool=default.rgw.buckets.index-compress --data_pool=default.rgw.buckets.data-compress --data_extra_pool=default.rgw.buckets.non-ec-compress --compression=zlib 
```

1. 

   ![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266854067.png)

   ![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

   --compression=zlib 代表使用的压缩算法是zlib。可选的压缩算法还有snappy, LZ4等算法。

   

#### 使能放置策略

1. 新建admin-compress用户。在ceph1执行：

   

   `radosgw-admin user create --uid="admin-compress" --display-name="admin compress user" `



![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266854099.png)



导出用户元数据，此处以存入user.json文件为例。在ceph1执行：



```
radosgw-admin metadata get user:admin-compress > user.json 
```





修改元数据user.json，将“default_placement”的值改为上一章节中新增的放置策略“compress-placement”。



```
vi user.json 
```



改为以下内容：

![img](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266854092.png)



将修改后的用户元数据导入。在ceph1执行：



```
radosgw-admin metadata put user:admin-compress < user.json 
```





重启radosgw进程。在所有存储端节点上执行：



```
systemctl restart ceph-radosgw.target 
```





检查用户的放置策略是否生效。在ceph1执行以下命令，所显示"default_placement"的值应为"compress-placement"。



```
radosgw-admin user info --uid="admin-compress" 
```

1. 

   ![img](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266854086.png)

   至此使用admin-compress用户创建的bucket将使用compress-placement放置策略，完成压缩使能。

   

**父主题：** [验证Ceph](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephobject_04_0009.html)

​					 					 [上一篇：创建RGW账户 					](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephobject_04_0012.html) 				 				 			

​					 					 [下一篇：Ceph对象存储 部署指南（openEuler 20.03）](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss_04_0007.html) 				 				 			

# 配置MDS节点

​                        更新时间：2021/02/23 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss-dpmg.pdf) 			

​	[分享](javascript:void(0);) 

MDS（Metadata Server）即元数据Server主要负责Ceph FS集群中文件和目录的管理。配置MDS节点如下：

1. 创建MDS。在ceph1节点执行：

   

   `cd /etc/ceph ceph-deploy mds create ceph1 ceph2 ceph3 `



![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266854633.png)



在Ceph各个节点上查看是否成功创建MDS进程。



```
ps -ef | grep ceph-mds | grep -v grep 
```



若有类似如下的字段输出则说明MDS进程启动成功。

![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266854636.png)

```
ceph       64149       1  0 Nov15 ?        00:01:18 /usr/bin/ceph-mds -f --cluster ceph --id ceph4 --setuser ceph --setgroup ceph
```

1. 

**父主题：** [验证Ceph](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephfile_04_0009.html)

# 创建存储池和文件系统

​                        更新时间：2021/02/23 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss-dpmg.pdf) 			

​	[分享](javascript:void(0);) 

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

- CephFS需要使用两个Pool来分别存储数据和元数据，下面我们分别创建fs_data和fs_metadata两个Pool。
- 创建存储池命令最后的两个数字，比如**ceph osd pool create fs_data 1024 1024**中的两个1024分别代表存储池的pg_num和pgp_num，即存储池对应的pg数量。Ceph官方文档建议整个集群所有存储池的pg数量之和大约为：（OSD数量 *  100)/数据冗余因数，数据冗余因数对副本模式而言是副本数，对EC模式而言是数据块+校验块之和，比方说，三副本模式是3，EC4+2模式是6。
- 此处整个集群3台服务器，每台服务器12个OSD，总共36个OSD，按照上述公式计算应为1200，一般建议pg数取2的整数次幂。由于**fs_data**存放的数据量远大于其他几个存储池的数据量，因此该存储池也成比例的分配更多的pg。

综上，**fs_data**的pg数量取1024，**fs_metadata**的pg数量取128或者256。

1. 在ceph1上执行以下命令创建存储池。

   

   `ceph osd pool create fs_data 1024 1024 ceph osd pool create fs_metadata 128 128 `



![img](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266854615.png)

![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266854637.png)

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

命令中的fs_data是存储池名字，1024分别是pg、pgp的数量，fs_metadata同理。



基于上述存储池创建新的文件系统。



```
ceph fs new cephfs fs_metadata fs_data 
```



![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

cephfs为文件系统名称，fs_metadata和fs_data为存储池名称，注意先后顺序。



存储池使能zlib压缩。



```
ceph osd pool set fs_data compression_algorithm zlib ceph osd pool set fs_data compression_mode force ceph osd pool set fs_data compression_required_ratio .99 
```



![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266854653.png)

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

本步骤是使能OSD压缩的，如果不需要压缩可以跳过。



查看创建的CephFS。



```
ceph fs ls 
```

1. 

   ![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266854642.png)

   

**父主题：** [验证Ceph](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephfile_04_0009.html)

# 客户机挂载文件系统

​                        更新时间：2021/02/23 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss-dpmg.pdf) 			

​	[分享](javascript:void(0);) 

1. 在任一Client节点查看客户端访问Ceph集群密钥。

   

   `cat /etc/ceph/ceph.client.admin.keyring `



![img](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266854659.png)

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

该操作执行一次即可，主机/客户机均已同步为一致。



创建文件系统挂载点，在所有Client节点执行。



```
mkdir /mnt/cephfs 
```





在所有Client节点执行。



```
mount -t ceph 192.168.3.166:6789,192.168.3.167:6789,192.168.3.168:6789:/ /mnt/cephfs -o name=admin,secret=步骤1查看到的key,sync 
```



![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266854649.png)

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

MON默认端口号为6789，-o参数指定集群登录用户名和密钥。



在所有Client节点检查是否挂载成功，文件系统类型是否为ceph。



```
stat -f /mnt/cephfs 
```



#### 简要介绍

ceph-ansible是用于部署Ceph分布式系统的Ansible脚本。

Ansible是一种自动化运维工具，基于Python开发，集合了众多运维工具（Puppet、CFEngine、Chef、Func、Fabric）的优点，实现了批量系统配置、批量程序部署、批量运行命令等功能。

Ansible基于模块工作，本身没有批量部署的能力。真正具有批量部署的是Ansible所运行的模块，Ansible只是提供一种框架。

#### 建议的版本

建议使用版本为“stable-4.0”。

#### 部署流程介绍

部署流程如[图1](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephansible_04_0001.html#kunpengcephansible_04_0001__fig1734674704012)所示。

**图1** 部署流程示意图
![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0000001089001637.png)

**父主题：** [Ceph-ansible 部署指南（CentOS 7.6）](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss_04_0001.html)

# 环境要求

​                        更新时间：2021/02/23 GMT+08:00

​					[查看PDF](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengsdss-dpmg.pdf) 			

​	[分享](javascript:void(0);) 

#### 硬件要求

硬件要求如[表1](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephansible_04_0002.html#kunpengcephansible_04_0002__table121991951103717)所示。



| 服务器名称 | TaiShan 200服务器（型号2280）                                |
| ---------- | ------------------------------------------------------------ |
| 处理器     | 鲲鹏920 5230处理器                                           |
| 核数       | 2*32核                                                       |
| 主频       | 2600MHz                                                      |
| 内存大小   | 12*16GB                                                      |
| 内存频率   | 2666MHz                                                      |
| 网卡       | 以太网标卡-25GE (Hi1822)-四端口-SFP+                         |
| 硬盘       | 系统盘：RAID1（2*960GB SATA SSD） 数据盘：Raid模式下使能JBOD（12*4TB SATA HDD） |
| NVMe SSD   | 1*ES3000 V5 3.2TB NVMe SSD                                   |
| Raid卡     | LSI SAS3508                                                  |

#### 软件要求

软件要求如[表2](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephansible_04_0002.html#kunpengcephansible_04_0002__table59343073)所示。



| 软件名称     | 版本                                                         |
| ------------ | ------------------------------------------------------------ |
| OS           | CentOS Linux release 7.6.1810 安装方式：“Infrastructure Server”+“development tools” |
| Ceph         | 14.2.1 Nautilus                                              |
| Ansible      | 2.8.5                                                        |
| Ceph-ansible | stable-4.0                                                   |

#### 集群环境规划

物理组网方式如[图1](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephansible_04_0002.html#kunpengcephansible_04_0002__kunpengcephblock_04_0002_fig621185394111)所示。

**图1** 物理组网图
![img](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0000001089002225.png)

集群部署如[表3](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephansible_04_0002.html#kunpengcephansible_04_0002__kunpengcephblock_04_0002_table60309786)所示。



| 集群  | 管理IP        | Public Network | Cluster Network |
| ----- | ------------- | -------------- | --------------- |
| ceph1 | 192.168.2.166 | 192.168.3.166  | 192.168.4.166   |
| ceph2 | 192.168.2.167 | 192.168.3.167  | 192.168.4.167   |
| ceph3 | 192.168.2.168 | 192.168.3.168  | 192.168.4.168   |

客户端部署如[表4](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephansible_04_0002.html#kunpengcephansible_04_0002__kunpengcephblock_04_0002_table53254482)所示。



| 客户端  | 管理IP        | 业务口IP      |
| ------- | ------------- | ------------- |
| client1 | 192.168.2.160 | 192.168.3.160 |
| client2 | 192.168.2.161 | 192.168.3.161 |
| client3 | 192.168.2.162 | 192.168.3.162 |

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

- 管理IP：用于远程SSH机器管理配置使用的IP。
- 内部集群IP（cluster network）：用于集群之间同步数据的IP，选取任意一个25GE网口配置即可。
- 外部访问IP（public network）：存储节点供其他节点访问的IP，选取任意一个25GE网口配置即可。
- 客户端当做压力机，需保证客户端业务口IP与集群的外部访问IP在同一个网段，建议选用25GE网口进行配置。



 

#### 配置主机名

1. 配置永久静态主机名，主机配置为ceph1~ceph3，客户机配置为client1~client3。

   

   1. 配置主机节点。

      ceph1节点：

      `hostnamectl --static set-hostname ceph1 `



![img](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266851330.png)

其余节点以此类推。

同理配置客户机节点。

client1节点：

```
hostnamectl --static set-hostname client1 
```

1. 

   其余节点以此类推。



修改域名解析文件。



```
vi /etc/hosts 
```



在各个集群和客户端节点的“/etc/hosts”中添加如下内容：

```
192.168.3.166   ceph1 192.168.3.167   ceph2 192.168.3.168   ceph3 192.168.3.160   client1 192.168.3.161   client2 192.168.3.162   client3 
```

1. 

   

#### 配置免密登录

需配置ceph1节点对所有主/客户机节点的免密（包括ceph1本身），此外需要配置client1节点对所有主/客户机节点的免密（包括client1本身）。

1. 在ceph1节点生成公钥，并发放到各个主机/客户机节点。

   

   `ssh-keygen -t rsa for i in {1..3}; do ssh-copy-id ceph$i; done for i in {1..3}; do ssh-copy-id client$i; done `



![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

输入第一条命令“**ssh-keygen -t rsa**”之后，按回车使用默认配置。

![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266851351.png)

![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266851342.png)



在client1节点生成公钥，并发放到各个主机/客户机节点。



```
ssh-keygen -t rsa for i in {1..3}; do ssh-copy-id ceph$i; done for i in {1..3}; do ssh-copy-id client$i; done 
```

1. 

   ![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

   输入第一条命令“**ssh-keygen -t rsa**”之后，按回车使用默认配置。

   

#### 关闭防火墙

关闭本节点防火墙，需在所有Ceph节点和Client节点依次执行如下命令。

```
systemctl stop firewalld systemctl disable firewalld systemctl status firewalld 
```



![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266851354.png)

#### 关闭SELinux

关闭本节点SELinux，需在所有主客户机节点执行。

- 临时关闭，重启后失效，与下一条互补。

  `setenforce 0 `



![img](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266851350.png)

永久关闭，重启后生效。

```
vi /etc/selinux/config 
```

- 

  修改**SELINUX=disabled**

  ![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0266851329.png)

#### 配置repo源

本文档提供在线和离线两种repo源的安装方式，推荐使用在线安装方式。

**方法一：****在线方式安装**

1. 在所有集群和客户端节点建立ceph.repo。

   

   `vi /etc/yum.repos.d/ceph.repo `



并加入如下内容：

```
[Ceph] name=Ceph packages for $basearch  baseurl=http://download.ceph.com/rpm-nautilus/el7/$basearch enabled=1 gpgcheck=1 type=rpm-md gpgkey=https://download.ceph.com/keys/release.asc priority=1  [Ceph-noarch] name=Ceph noarch packages baseurl=http://download.ceph.com/rpm-nautilus/el7/noarch enabled=1 gpgcheck=1 type=rpm-md gpgkey=https://download.ceph.com/keys/release.asc priority=1  [ceph-source] name=Ceph source packages baseurl=http://download.ceph.com/rpm-nautilus/el7/SRPMS enabled=1 gpgcheck=1 type=rpm-md gpgkey=https://download.ceph.com/keys/release.asc priority=1 
```





更新yum源。



```
yum clean all && yum makecache 
```



![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0224711004.png)



安装epel源。



```
yum -y install epel-release 
```



![img](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0224711005.png)



修改所有节点代理配置。



```
vim /etc/environment 
```



添加如下内容使其支持相关依赖包的安装：

```
export http_proxy=http://{Proxy-User-Name}:{Proxy-Password}@<Proxy-Server-IP-Address>:<Proxy-Port> export https_proxy= http://{Proxy-User-Name}:{Proxy-Password}@<Proxy-Server-IP-Address>:<Proxy-Port> export ftp_proxy= http://{Proxy-User-Name}:{Proxy-Password}@<Proxy-Server-IP-Address>:<Proxy-Port> export no_proxy=127.0.0.1,localhost 
```

1. 

   

**方法二：离线方式安装**

集群中所有节点均需配置repo源，分别在各个节点进行如下操作。

![img](https://res-img3.huaweicloud.com/content/dam/cloudbu-site/archive/china/zh-cn/support/resource/framework/v3/images/support-doc-new-note.svg)说明： 

目前source.zip包需要自己手动制作，制作方法请参见[repo源压缩包制作](https://support.huaweicloud.com/dpmg-kunpengsdss/kunpengcephansible_04_0017.html#kunpengcephansible_04_0017__section3528641112516)。

1. 将source.zip传到“/home”目录后进入该目录。

   

   `cd /home `





解压。



```
unzip source.zip 
```



![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0224711006.png)



安装createrepo。



```
yum install -y createrepo/*.rpm 
```



![点击放大](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0224711007.png)



创建本地源。



```
cd /home/local_source createrepo . 
```



![img](https://support.huaweicloud.com/dpmg-kunpengsdss/zh-cn_image_0224711008.png)



进入“yum.repo.d”目录。



```
cd /home/yum.repo.d 
```





将系统自带repo文件备份移除。



```
mkdir bak mv *.repo bak 
```





创建repo文件。



```
vi local.repo 
```



添加如下内容：

```
[local] name=local baseurl=file:///home/local_source enabled=1 gpgcheck=0 
```
