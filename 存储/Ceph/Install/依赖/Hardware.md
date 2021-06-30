# Hardware

[TOC]

规划集群硬件时，需要均衡几方面的因素，包括故障域和潜在的性能问题。

## CPU

MDS 是 CPU 密集型的，应该具有显著的处理能力（例如，四核或更好的 CPU ），更高的时钟速率（以 GHz 为单位的频率）。

OSD 运行 RADOS 服务，使用 CRUSH 计算数据放置，复制数据，并维护自己的集群映射副本。应该具有合理的处理能力，需求因用例而异：a starting point might be one core per OSD for light / archival usage, and two cores per OSD for heavy workloads such as RBD volumes attached to VMs. 一个起点可能是每个 OSD 一个核心用于轻/归档使用，而每个 OSD 两个核心用于重负载（如连接到 VMs 的 RBD 卷）。

MON / MGR 没有很高的CPU需求。

## 内存

对于中等规模的集群，MON / MGR 可以使用64GB；对于具有数百个 OSD 的较大集群，128GB是合理的。

There is a memory target for BlueStore OSDs that defaults to 4GB.Blue Store OSD有一个默认为4GB的内存目标。虑到操作系统和管理任务（如监视和度量）以及恢复期间消耗的增加，建议为每个 Blue  Store OSD 配置约 8GB。

### MON / Mgr

MON 和 MGR 内存使用通常随集群的大小而扩展。at boot-time and during topology changes and recovery these daemons will need more RAM than they do during steady-state operation。在引导时以及拓扑更改和恢复期间，这些守护进程将需要比稳态操作期间更多的RAM。需计划峰值使用率。对于非常小的集群，32GB就足够了。对于高达300个 OSD 的集群，可以使用64GB。对于使用更多osd构建的集群（或者将增长到更多osd），应该提供128GB。可能需要考虑调整 `mon_osd_cache_size`  和  `rocksdb_cache_size` 等设置。

### MDS

The metadata daemon memory utilization depends on how much memory its cache is configured to consume.  MDS 内存利用率取决于其缓存配置为消耗多少内存。对于大多数系统，建议至少1 GB。

### OSD

Bluestore 使用自己的内存来缓存数据，而不是依赖于操作系统页缓存。在 bluestore 中，可使用 `osd_memory_target` 配置选项调整 OSD 尝试使用的内存量。

- 通常不建议将 `osd_memory_target` 设置为2GB以下（it may fail to keep the memory that low 它可能无法将内存保持在低水平，并且可能会导致极其缓慢的性能）。

- Setting the memory target between 2GB and 4GB typically works but may result in degraded performance as metadata may be read from disk during IO unless the active data set is relatively small.

  将内存目标设置在2GB和4GB之间通常是可行的，但可能会导致性能下降，因为在 IO 期间可能会从磁盘读取元数据，除非活动数据集相对较小。

- was set that way to try and balance memory requirements and OSD performance for typical use cases.

  4GB是当前默认 `osd_memory_target` 大小，这样设置是为了在典型用例中尝试平衡内存需求和 OSD 性能。

- 当处理多个（小）对象或大（256GB/OSD或更多）数据集时，将 `osd_memory_target` 设置为高于4GB可能会提高性能。

> **Important**
>
> While the OSD may unmap memory to allow the kernel to reclaim it, there is no guarantee that the kernel will actually reclaim freed memory within any specific time frame.  This is especially true in older versions of Ceph where transparent huge pages can prevent the kernel from reclaiming memory freed from fragmented huge pages. Modern versions of Ceph disable transparent huge pages at the application level to avoid this, though that still does not guarantee that the kernel will immediately reclaim unmapped memory.  The OSD may still at times exceed it’s memory target.  We recommend budgeting around 20% extra memory on your system to prevent OSDs from going OOM during temporary spikes or due to any delay in reclaiming freed pages by the kernel.  
>
> OSD 内存自动调整是“尽力而为”。虽然OSD可能会取消映射内存以允许内核回收它，但不能保证内核会在任何特定的时间范围内回收释放的内存。在Ceph的旧版本中尤其如此，透明的大页面可以阻止内核回收从碎片化的大页面中释放出来的内存。现代版本的Ceph在应用程序级别禁用透明的大页面以避免这种情况，尽管这仍然不能保证内核会立即回收未映射的内存。OSD有时仍可能超出其内存目标。我们建议在系统上预算大约20%的额外内存，以防止OSD在临时峰值期间或由于内核回收释放页的任何延迟而出现OOM。根据系统的具体配置，该值可能大于或小于所需值。

使用传统 FileStore 后端时，页面缓存用于缓存数据，通常不需要进行调优，OSD 内存消耗通常与系统中每个守护进程的 PG 数量有关。

## 数据存储

在规划数据存储时，需要考虑大量的成本和性能权衡。Simultaneous OS operations, and simultaneous request for read and write operations from multiple daemons against a single drive 同时进行操作系统操作，以及同时请求多个守护进程对单个驱动器执行读写操作，都会大大降低性能。

> **Important**
>
> Since Ceph has to write all data to the journal (or WAL+DB) before it can ACK writes
>
> 由于Ceph 在 ACK write 前，必须在 journal（或WAL+DB）上写入所有数据，因此平衡元数据和OSD性能是非常重要的！

### 硬盘驱动器

建议最小为1TB。不建议在一个SAS/SATA驱动器上运行多个OSD。NVMe 驱动器可以通过拆分成两个以上的 OSD 来提高性能。

不建议在单个驱动器上运行OSD、MON 或 MDS。

Storage drives are subject to limitations on seek time, access time, read and write times, as well as total throughput. 

存储驱动器受寻道时间、访问时间、读写时间以及总吞吐量的限制。这些物理限制会影响整个系统性能，尤其是在恢复期间。 We recommend using a dedicated (ideally mirrored) drive for the operating system and software, and one drive for each Ceph OSD Daemon you run on the host (modulo NVMe above). 建议为操作系统和软件使用专用（理想情况下是镜像的）驱动器，为主机上运行的每个Ceph  OSD守护进程使用一个驱动器（上面的NVMe模块）。Many “slow OSD” issues not attributable to hardware failure arise from running an operating system, multiple OSDs, and/or multiple journals on the same drive. 在同一个驱动器上运行操作系统、多个OSD和/或多个日志时，会出现许多不可归因于硬件故障的“慢OSD”问题。Since the cost of troubleshooting performance issues on a small cluster likely exceeds the cost of the extra disk drives, you can optimize your cluster design planning by avoiding the temptation to overtax the OSD storage drives.由于解决小型集群上的性能问题的成本可能超过额外磁盘驱动器的成本，因此可以通过避免OSD存储驱动器负担过重的诱惑来优化集群设计规划。

but this will likely lead to resource contention and diminish the overall throughput. .可以在每个SAS/SATA驱动器上运行多个Ceph OSD守护程序，但这可能会导致资源争用并降低总体吞吐量。You may store a journal and object data on the same drive, but this may increase the time it takes to journal a write and ACK to the client. Ceph must write to the journal before it can ACK the write您可以将日志和对象数据存储在同一驱动器上，但这可能会增加将写入和确认日志记录到客户端所需的时间。Ceph必须先写入日志，然后才能确认写入。

Ceph best practices dictate that you should run operating systems, OSD data and OSD journals on separate drives.Ceph最佳实践要求您应该在不同的驱动器上运行操作系统、OSD数据和OSD日志。

### 固态硬盘

One opportunity for performance improvement is to use solid-state drives (SSDs) to reduce random access time and read latency while accelerating throughput. SSDs often cost more than 10x as much per gigabyte when compared to a hard disk drive, but SSDs often exhibit access times that are at least 100x faster than a hard disk drive.

性能改进的一个机会是使用固态驱动器（SSD）来减少随机访问时间和读取延迟，同时加快吞吐量。与硬盘相比，SSD的每GB成本通常超过10x，但SSD的访问时间通常比硬盘快至少100倍。

SSDs do have significant limitations though. When evaluating SSDs, it is important to consider the performance of sequential reads and writes. An SSD that has 400MB/s sequential write throughput may have much better performance than an SSD with 120MB/s of sequential write throughput when storing multiple journals for multiple OSDs.

SSD 没有可移动的机械部件，因此它们不必受到与硬盘驱动器相同类型的限制。不过固态硬盘确实有很大的局限性。在评估SSD时，重要的是要考虑顺序读写的性能。当为多个osd存储多个日志时，具有400MB/s顺序写入吞吐量的SSD可能比具有120MB/s顺序写入吞吐量的SSD具有更好的性能。

> **Important**
>
> We recommend exploring the use of SSDs to improve performance. However, before making a significant investment in SSDs, we **strongly recommend** both reviewing the performance metrics of an SSD and testing the SSD in a test configuration to gauge performance.
>
> 我们建议探索使用SSD来提高性能。但是，在对SSD进行重大投资之前，我们强烈建议您检查SSD的性能指标，并在测试配置中测试SSD，以评估性能。

 it makes sense to use them in the areas of Ceph that do not use a lot of storage space (e.g., journals). Relatively inexpensive SSDs may appeal to your sense of economy. Use caution. Acceptable IOPS are not enough when selecting an SSD for use with Ceph. There are a few important performance considerations for journals and SSDs:

由于固态硬盘没有可移动的机械部件，因此在不占用大量存储空间（如 journal）的Ceph区域使用它们是有意义的。相对便宜的固态硬盘可能会吸引你的经济意识。小心。当选择与Ceph一起使用的SSD时，可接受的IOPS是不够的。对于日志和SSD，有几个重要的性能注意事项：

- **Write-intensive semantics:** Journaling involves write-intensive semantics, so you should ensure that the SSD you choose to deploy will perform equal to or better than a hard disk drive when writing data. Inexpensive SSDs may introduce write latency even as they accelerate access time, because sometimes high performance hard drives can write as fast or faster than some of the more economical SSDs available on the market!

  写密集型语义：日志涉及写密集型语义，因此您应该确保选择部署的SSD在写入数据时的性能等同于或优于硬盘驱动器。便宜的SSD可能会引入写入延迟，即使它们加快了访问时间，因为有时高性能硬盘的写入速度可能与市场上一些更经济的SSD的写入速度一样快或更快！

- **Sequential Writes:** When you store multiple journals on an SSD you must consider the sequential write limitations of the SSD too, since they may be handling requests to write to multiple OSD journals simultaneously.

  顺序写入：在SSD上存储多个日志时，也必须考虑SSD的顺序写入限制，因为它们可能同时处理写入多个OSD日志的请求。

- **Partition Alignment:** A common problem with SSD performance is that people like to partition drives as a best practice, but they often overlook proper partition alignment with SSDs, which can cause SSDs to transfer data much more slowly. Ensure that SSD partitions are properly aligned.

  分区对齐：SSD性能的一个常见问题是，人们喜欢将驱动器分区作为最佳实践，但他们经常忽略与SSD的正确分区对齐，这会导致SSD传输数据的速度慢得多。确保SSD分区正确对齐。

SSDs have historically been cost prohibitive for object storage, though emerging QLC drives are closing the gap.  HDD OSDs may see a significant performance improvement by offloading WAL+DB onto an SSD.

尽管新兴的QLC驱动器正在缩小差距，但ssd在对象存储方面的成本一直很高。通过将WAL+DB卸载到SSD上，HDD osd可能会看到显著的性能改进。

One way Ceph accelerates CephFS file system performance is to segregate the storage of CephFS metadata from the storage of the CephFS file contents. Ceph provides a default `metadata` pool for CephFS metadata. You will never have to create a pool for CephFS metadata, but you can create a CRUSH map hierarchy for your CephFS metadata pool that points only to a host’s SSD storage media. 

Ceph加速Ceph-FS文件系统性能的一种方法是将Ceph-FS元数据的存储与Ceph-FS文件内容的存储分离开来。Ceph为cephfs元数据提供了一个默认的元数据池。您永远不必为Ceph FS元数据创建池，但可以为Ceph FS元数据池创建一个仅指向主机SSD存储介质的CRUSH map层次结构。

### 控制器

Disk controllers (HBAs) can have a significant impact on write throughput.磁盘控制器（HBA）会对写入吞吐量产生重大影响。 Carefully consider your selection to ensure that they do not create a performance bottleneck.仔细考虑您的选择，以确保它们不会造成性能瓶颈。 Notably RAID-mode (IR) HBAs may exhibit higher latency than simpler “JBOD” (IT) mode HBAs, and the RAID SoC, write cache, and battery backup can substantially increase hardware and maintenance costs.  Some RAID HBAs can be configured with an IT-mode “personality”.值得注意的是，RAID模式（IR）HBA可能比简单的“JBOD”（IT）模式HBA表现出更高的延迟，并且RAID So C、写缓存和电池备份可能会大幅增加硬件和维护成本。某些RAID HBA可以配置IT模式“个性”。

### 其他注意事项

You typically will run multiple OSDs per host, but you should ensure that the aggregate throughput of your OSD drives doesn’t exceed the network bandwidth required to service a client’s need to read or write data. You should also consider what percentage of the overall data the cluster stores on each host. If the percentage on a particular host is large and the host fails, it can lead to problems such as exceeding the `full ratio`,  which causes Ceph to halt operations as a safety precaution that prevents data loss.

您通常会在每台主机上运行多个OSD，但是您应该确保OSD驱动器的总吞吐量不会超过满足客户机读写数据需要所需的网络带宽。您还应该考虑集群在每个主机上存储的数据占总数据的百分比。如果某个特定主机上的百分比很大，而该主机发生故障，则可能会导致诸如超过完整比率之类的问题，这会导致Ceph停止操作，作为防止数据丢失的安全预防措施。

当在主机上运行多个osd时，需要确保内核是最新的。

## 网络

By contrast, with a 10Gbps network, the replication times would be 20 minutes and 1 hour respectively. In a petabyte-scale cluster, failure of an OSD drive is an expectation, not an exception. System administrators will appreciate PGs recovering from a `degraded` state to an `active + clean` state as rapidly as possible, with price / performance tradeoffs taken into consideration. Additionally, some deployment tools employ VLANs to make  hardware and network cabling more manageable. VLANs using 802.1q protocol require VLAN-capable NICs and Switches. The added hardware expense may be offset by the operational cost savings for network setup and maintenance. When using VLANs to handle VM traffic between the cluster and compute stacks (e.g., OpenStack, CloudStack, etc.), there is additional value in using 10G Ethernet or better; 40Gb or 25/50/100 Gb networking as of 2020 is common for production clusters.

在机架中至少提供10Gbps+网络。在1Gbps网络上复制1TB的数据需要3个小时，10TB需要30个小时！相比之下，使用10Gbps网络，复制时间分别为20分钟和1小时。在PB级集群中，OSD驱动器出现故障是一种预期，而不是例外。系统管理员希望PGs尽快从降级状态恢复到活动+干净状态，并考虑到价格/性能的权衡。此外，一些部署工具使用VLAN使硬件和网络布线更易于管理。使用802.1q协议的VLAN需要支持VLAN的NIC和交换机。增加的硬件费用可能会被网络设置和维护所节省的运营成本所抵消。当使用VLAN来处理集群和计算堆栈（例如，开放堆栈、云堆栈等）之间的VM流量时，使用10G以太网或更好的以太网会有额外的价值；到2020年，40Gb或25/50/100GB网络对于生产集群来说是很常见的。

Top-of-rack routers for each network also need to be able to communicate with spine routers that have even faster throughput, often 40Gbp/s or more.每个网络的机架顶部路由器还需要能够与吞吐量更快（通常为40Gbp/s或更高）的spine路由器通信。

Administration and deployment tools may also use BMCs extensively, especially via IPMI or Redfish, so consider the cost/benefit tradeoff of an out-of-band network for administration. Hypervisor SSH access, VM image uploads, OS image installs, management sockets, etc. can impose significant loads on a network.  Running three networks may seem like overkill, but each traffic path represents a potential capacity, throughput and/or performance bottleneck that you should carefully consider before deploying a large scale data cluster.

服务器硬件应该有一个 Baseboard Management Controller（BMC）。管理和部署工具也可能广泛地使用bmc，特别是通过IPMI或Redfish，因此考虑管理带外网络的成本/收益权衡。Hypervisor  SSH访问、VM映像上载、OS映像安装、管理套接字等都会对网络施加很大的负载。运行三个网络似乎有些过分，但每个通信路径都代表了一个潜在的容量、吞吐量和/或性能瓶颈，在部署大规模数据集群之前，您应该仔细考虑这些瓶颈。

![](../../../../Image/ceph_network.png)

## 故障域

A failure domain is any failure that prevents access to one or more OSDs. That could be a stopped daemon on a host; a hard disk failure, an OS crash, a malfunctioning NIC, a failed power supply, a network outage, a power outage, and so forth. When planning out your hardware needs, you must balance the temptation to reduce costs by placing too many responsibilities into too few failure domains, and the added costs of isolating every potential failure domain.

故障域是阻止访问一个或多个OSD的任何故障。这可能是主机上已停止的守护进程；硬盘故障、操作系统崩溃、NIC故障、电源故障、网络中断、电源中断等等。在规划硬件需求时，您必须平衡将太多的责任放在太少的故障域中以降低成本的诱惑，以及隔离每个潜在故障域所增加的成本。

## 最低硬件推荐

Ceph 可以在廉价的商用硬件上运行。Small production clusters and development clusters can run successfully with modest hardware.小型的生产集群和开发集群可以使用适当的硬件成功运行。

<table border="1">
<tr>
<th>Process</th><th>Criteria</th><th>Minimum Recommended</th>
</tr>
<tr>
<td rowspan=5>ceph-osd</td><td>Processor</td><td>1 core minimum 1 core per 200-500 MB/s 1 core per 1000-3000 IOPS  Results are before replication. Results may vary with different CPU models and Ceph features. (erasure coding, compression, etc) ARM processors specifically may require additional cores. Actual performance depends on many factors including drives, net, and client throughput and latency. Benchmarking is highly recommended.</td>
</tr>
<tr>
<td>RAM</td><td>4GB+ per daemon (more is better) 2-4GB often functions (may be slow) Less than 2GB not recommended</td>
</tr>
<tr>
<td>Volume Storage</td><td>1x storage drive per daemon</td>
</tr>
<tr>
<td>DB/WAL</td><td>1x SSD partition per daemon (optional)</td>
</tr>
<tr>
<td>Network</td><td>1x 1GbE+ NICs (10GbE+ recommended)</td>
</tr>
<tr>
<td rowspan=4>ceph-mon</td><td>Processor</td><td>2 cores minimum</td>
</tr>
<tr>
<td>RAM</td><td>24GB+ per daemon</td>
</tr>
<tr>
<td>Disk Space</td><td>60 GB per daemon</td>
</tr>
<tr>
<td>Network</td><td>1x 1GbE+ NICs</td>
</tr>
<tr>
<td rowspan=4>ceph-mds</td><td>Processor</td><td>2 cores minimum</td>
</tr>
<tr>
<td>RAM</td><td>2GB+ per daemon</td>
</tr>
<tr>
<td>Disk Space</td><td>1 MB per daemon</td>
</tr>
<tr>
<td>Network</td><td>1x 1GbE+ NICs</td>
</tr>
</table>
> Tip
>
> If you are running an OSD with a single disk, create a partition for your volume storage that is separate from the partition containing the OS. Generally, we recommend separate disks for the OS and the volume storage.
>
> 如果使用单个磁盘运行OSD，请为卷存储创建一个独立于包含OS的分区的分区。通常，我们建议操作系统和卷存储使用单独的磁盘。



