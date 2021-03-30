# Hardware

[TOC]

When planning out your cluster hardware, you will need to balance a number of considerations, including failure domains and potential performance issues. 
规划集群硬件时，需要均衡几方面的因素，包括故障域和潜在的性能问题

## CPU

MDS 是 CPU 密集型的，应该具有显著的处理能力（例如，四核或更好的 CPU ），更高的时钟速率（以 GHz 为单位的频率）。

OSD 运行 RADOS 服务，使用 CRUSH 计算数据放置，复制数据，并维护自己的集群映射副本。应该具有合理的处理能力，需求因用例而异：a starting point might be one core per OSD for light / archival usage, and two cores per OSD for heavy workloads such as RBD volumes attached to VMs. 一个起点可能是每个OSD一个核心用于轻/归档使用，而每个OSD两个核心用于重负载（如连接到VMs的RBD卷）。

MON / Mgr 没有很高的CPU需求。

## 内存

对于中等规模的集群，MON / Mgr 可以使用64GB；对于具有数百个 OSD 的较大集群，128GB是合理的。

There is a memory target for BlueStore OSDs that defaults to 4GB.Blue Store OSD有一个默认为4GB的内存目标。建议为每个Blue  Store OSD 配置约8GB。

### MON / Mgr

MON 和 Mgr 内存使用通常随集群的大小而扩展。at boot-time and during topology changes and recovery these daemons will need more RAM than they do during steady-state operation。在引导时以及拓扑更改和恢复期间，这些守护进程将需要比稳态操作期间更多的RAM。需计划峰值使用率。对于非常小的集群，32GB就足够了。对于高达300个 OSD 的集群，可以使用64GB。对于使用更多osd构建的集群（或者将增长到更多osd），应该提供129GB。可能需要考虑调整 `mon_osd_cache_size`  和  `rocksdb_cache_size` 等设置。

### MDS

The metadata daemon memory utilization depends on how much memory its cache is configured to consume.  MDS 内存利用率取决于其缓存配置为消耗多少内存。对于大多数系统，建议至少1 GB。

### OSD

Bluestore使用自己的内存来缓存数据，而不是依赖于操作系统页缓存。在bluestore中，可以使用 `osd_memory_target` 配置选项调整OSD尝试使用的内存量。

- 通常不建议将 `osd_memory_target` 设置为2GB以下（it may fail to keep the memory that low 它可能无法将内存保持在低水平，并且可能会导致极其缓慢的性能）。
- Setting the memory target between 2GB and 4GB typically works but may result in degraded performance as metadata may be read from disk during IO unless the active data set is relatively small.将内存目标设置在2GB和4GB之间通常是可行的，但可能会导致性能下降，因为在IO期间可能会从磁盘读取元数据，除非活动数据集相对较小。
- was set that way to try and balance memory requirements and OSD performance for typical use cases.4GB是当前默认 `osd_memory_target` 大小，并设置为尝试平衡典型用例的内存需求和osd性能。
- 当处理多个（小）对象或大（256GB/OSD或更多）数据集时，将 `osd_memory_target` 设置为高于4GB可能会提高性能。

> **Important**
>
> The OSD memory autotuning is “best effort”.  While the OSD may unmap memory to allow the kernel to reclaim it, there is no guarantee that the kernel will actually reclaim freed memory within any specific time frame.  This is especially true in older versions of Ceph where transparent huge pages can prevent the kernel from reclaiming memory freed from fragmented huge pages. Modern versions of Ceph disable transparent huge pages at the application level to avoid this, though that still does not guarantee that the kernel will immediately reclaim unmapped memory.  The OSD may still at times exceed it’s memory target.  We recommend budgeting around 20% extra memory on your system to prevent OSDs from going OOM during temporary spikes or due to any delay in reclaiming freed pages by the kernel.  That value may be more or less than needed depending on the exact configuration of the system.
>
> OSD内存自动调整是“尽力而为”。虽然OSD可能会取消映射内存以允许内核回收它，但不能保证内核会在任何特定的时间范围内回收释放的内存。在Ceph的旧版本中尤其如此，透明的大页面可以阻止内核回收从碎片化的大页面中释放出来的内存。现代版本的Ceph在应用程序级别禁用透明的大页面以避免这种情况，尽管这仍然不能保证内核会立即回收未映射的内存。OSD有时仍可能超出其内存目标。我们建议在系统上预算大约20%的额外内存，以防止OSD在临时峰值期间或由于内核回收释放页的任何延迟而出现OOM。根据系统的具体配置，该值可能大于或小于所需值。

使用传统 FileStore 后端时，页面缓存用于缓存数据，通常不需要进行调优，OSD 内存消耗通常与系统中每个守护进程的 PG 数量有关。

## 数据存储

There are significant cost and performance tradeoffs to consider when planning for data storage.在规划数据存储时，需要考虑大量的成本和性能权衡。 Simultaneous OS operations, and simultaneous request for read and write operations from multiple daemons against a single drive can slow performance considerably.同时进行操作系统操作，以及同时请求多个守护进程对单个驱动器执行读写操作，都会大大降低性能。

> **Important**
>
> Since Ceph has to write all data to the journal (or WAL+DB) before it can ACK writes, having this metadata and OSD performance in balance is really important!由于Ceph 在 ACK write 前，必须在 journal（或WAL+DB）上写入所有数据，因此平衡元数据和OSD性能是非常重要的！

### 硬盘驱动器

建议最小硬盘大小为1TB。不建议在一个SAS/SATA驱动器上运行多个OSD。然而，NVMe 驱动器可以通过拆分成两个以上的 OSD 来提高性能。

不建议在单个驱动器上运行OSD、MON 或 MDS。

Storage drives are subject to limitations on seek time, access time, read and write times, as well as total throughput. These physical limitations affect overall system performance–especially during recovery. We recommend using a dedicated (ideally mirrored) drive for the operating system and software, and one drive for each Ceph OSD Daemon you run on the host (modulo NVMe above). Many “slow OSD” issues not attributable to hardware failure arise from running an operating system, multiple OSDs, and/or multiple journals on the same drive. Since the cost of troubleshooting performance issues on a small cluster likely exceeds the cost of the extra disk drives, you can optimize your cluster design planning by avoiding the temptation to overtax the OSD storage drives.

You may run multiple Ceph OSD Daemons per SAS / SATA drive, but this will likely lead to resource contention and diminish the overall throughput. You may store a journal and object data on the same drive, but this may increase the time it takes to journal a write and ACK to the client. Ceph must write to the journal before it can ACK the write.

Ceph best practices dictate that you should run operating systems, OSD data and OSD journals on separate drives.

存储驱动器受寻道时间、访问时间、读写时间以及总吞吐量的限制。这些物理限制会影响整个系统性能，尤其是在恢复期间。我们建议为操作系统和软件使用专用（理想情况下是镜像的）驱动器，为主机上运行的每个Ceph  OSD守护进程使用一个驱动器（上面的NVMe模块）。在同一个驱动器上运行操作系统、多个OSD和/或多个日志时，会出现许多不可归因于硬件故障的“慢OSD”问题。由于解决小型集群上的性能问题的成本可能超过额外磁盘驱动器的成本，因此可以通过避免OSD存储驱动器负担过重的诱惑来优化集群设计规划。

您可以在每个SAS/SATA驱动器上运行多个Ceph OSD守护程序，但这可能会导致资源争用并降低总体吞吐量。您可以将日志和对象数据存储在同一驱动器上，但这可能会增加将写入和确认日志记录到客户端所需的时间。Ceph必须先写入日志，然后才能确认写入。

Ceph最佳实践要求您应该在不同的驱动器上运行操作系统、OSD数据和OSD日志。

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



### 





### 其他注意事项

可以在同一主机上运行多个 OSD ，但要确保 OSD 硬盘总吞吐量不超过为客户端提供读写服务所需的网络带宽；还要考虑集群在每台主机上所存储的数据占总体的百分比，如果一台主机所占百分比太大而它挂了，就可能导致诸如超过 `full ratio` 的问题，此问题会使 Ceph 中止运作以防数据丢失。

如果每台主机运行多个 OSD ，也得保证内核是最新的。

OSD 数量较多（如 20 个以上）的主机会派生出大量线程，尤其是在恢复和重均衡期间。很多 Linux 内核默认的最大线程数较小（如 32k 个），如果遇到了这类问题，可以把 `kernel.pid_max` 值调高些。理论最大值是 4194303 。例如把下列这行加入 `/etc/sysctl.conf` 文件：

```
kernel.pid_max = 4194303
```

### Ceph网络

建议每台服务器至少两个千兆网卡，分别用于公网(前端)和集群网络(后端)。集群网络用于处理有数据复制产生的额外负载，而且可用防止拒绝服务攻击。考虑部署万兆网络。

![](D:/wfbook/Image/ceph_network.png)


