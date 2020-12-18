# Hardware

[TOC]

## CPU

MDS 服务器对CPU敏感，会动态地重分布它们的负载，CPU性能尽可能高。 
OSD 需要一定的处理能力，CPU性能要求较高。
MON 对 CPU 不敏感。

## 内存

MDS 服务器和 MON对内存要求较高，至少每进程1GB。

OSD对内存要求较低，至少每进程500MB。但在恢复期间占用内存比较大（如每进程每 TB 数据需要约 1GB  内存）。通常内存越多越好。  

## 数据存储

要谨慎地规划数据存储配置，因为其涉及明显的成本和性能折衷。来自操作系统的并行操作和到单个硬盘的多个守护进程并发读、写请求操作会极大地降低性能。文件系统局限性也要考虑： btrfs 尚未稳定到可以用于生产环境的程度，但它可以同时记日志并写入数据，而 xfs 和 ext4 却不能。

建议用容量大于1TB的硬盘。单个驱动器容量越大，其对应的 OSD 所需内存就越大，特别是在重均衡、回填、恢复期间。根据经验， 1TB  的存储空间大约需要 1GB 内存。

每个OSD守护进程占用一个驱动器。

存储驱动器受限于寻道时间、访问时间、读写时间、还有总吞吐量，这些物理局限性影响着整体系统性能，尤其在系统恢复期间。分别在单独的硬盘运行操作系统、OSD数据和OSD日志。因为 Ceph 发送 ACK 前必须把所有数据写入日志（至少对 xfs 和 ext4 来说是），因此均衡日志和 OSD 性能相当重要。

不顾分区而在单个硬盘上运行多个OSD，这样**不明智**！
不顾分区而在运行了OSD的硬盘上同时运行监视器或元数据服务器也**不明智**！

### SSD

一种提升性能的方法是使用固态硬盘（ SSD ）来降低随机访问时间和读延时，同时增加吞吐量。 SSD 和硬盘相比每 GB 成本通常要高 10 倍以上，但访问时间至少比硬盘快 100 倍。

SSD 没有可移动机械部件，所以不存在和硬盘一样的局限性。但 SSD 也有局限性，评估SSD 时，顺序读写性能很重要，在为多个 OSD 存储日志时，有着 400MB/s 顺序读写吞吐量的 SSD 其性能远高于 120MB/s 的 HDD。

适合 Ceph 里不需要太多存储空间的地方。相对廉价的 SSD 很诱人，慎用！可接受的 IOPS 指标对选择用于 Ceph 的 SSD 还不够，用于日志和 SSD 时还有几个重要考量：

- **写密集语义：** 记日志涉及写密集语义，所以你要确保选用的 SSD 写入性能和硬盘相当或好于硬盘。廉价 SSD 可能在加速访问的同时引入写延时，有时候高性能硬盘的写入速度可以和便宜 SSD 相媲美。
- **顺序写入：** 在一个 SSD 上为多个 OSD 存储多个日志时也必须考虑 SSD 的顺序写入极限，因为它们要同时处理多个 OSD 日志的写入请求。
- **分区对齐：** 采用了 SSD 的一个常见问题是人们喜欢分区，却常常忽略了分区对齐，这会导致 SSD 的数据传输速率慢很多，所以请确保分区对齐了。

SSD 用于对象存储太昂贵了，但是把 OSD 的日志存到 SSD 、把对象数据存储到独立的硬盘可以明显提升性能。 `osd journal` 选项的默认值是 `/var/lib/ceph/osd/$cluster-$id/journal` ，你可以把它挂载到一个 SSD 或 SSD 分区，这样它就不再是和对象数据一样存储在同一个硬盘上的文件了。

SSD顺序读写性能很重要。SSD可用于存储OSD的日志。 

提升 CephFS 文件系统性能的一种方法是从 CephFS 文件内容里分离出元数据。 Ceph 提供了默认的 `metadata` 存储池来存储 CephFS 元数据，所以你不需要给 CephFS 元数据创建存储池，但是可以给它创建一个仅指向某主机 SSD 的 CRUSH map。

### 控制器

硬盘控制器对写吞吐量也有显著影响，要谨慎地选择，以免产生性能瓶颈。

### 其他注意事项

可以在同一主机上运行多个 OSD ，但要确保 OSD 硬盘总吞吐量不超过为客户端提供读写服务所需的网络带宽；还要考虑集群在每台主机上所存储的数据占总体的百分比，如果一台主机所占百分比太大而它挂了，就可能导致诸如超过 `full ratio` 的问题，此问题会使 Ceph 中止运作以防数据丢失。

如果每台主机运行多个 OSD ，也得保证内核是最新的。

OSD 数量较多（如 20 个以上）的主机会派生出大量线程，尤其是在恢复和重均衡期间。很多 Linux 内核默认的最大线程数较小（如 32k 个），如果遇到了这类问题，可以把 `kernel.pid_max` 值调高些。理论最大值是 4194303 。例如把下列这行加入 `/etc/sysctl.conf` 文件：

```
kernel.pid_max = 4194303
```

## 网络

建议每台服务器至少两个千兆网卡，分别用于公网(前端)和集群网络(后端)。集群网络用于处理有数据复制产生的额外负载，而且可用防止拒绝服务攻击。考虑部署万兆网络。

![](D:/wfbook/Image/ceph_network.png)

在一个 PB 级集群中， OSD  磁盘失败是常态，而非异常；在性价比合理的的前提下，系统管理员想让 PG 尽快从 `degraded` （降级）状态恢复到 `active + clean` 状态。另外，一些部署工具（如 Dell 的 Crowbar ）部署了 5 个不同的网络，但使用了 VLAN 以提高网络和硬件可管理性。  VLAN 使用 802.1q 协议，还需要采用支持 VLAN 功能的网卡和交换机，增加的硬件成本可用节省的运营（网络安装、维护）成本抵消。使用  VLAN 来处理集群和计算栈（如 OpenStack 、 CloudStack 等等）之间的 VM 流量时，采用 10G  网卡仍然值得。每个网络的机架路由器到核心路由器应该有更大的带宽，如 40Gbps 到 100Gbps 。

服务器应配置底板管理控制器（ Baseboard Management Controller, BMC ），管理和部署工具也应该大规模使用 BMC ，所以考虑带外网络管理的成本/效益平衡，此程序管理着 SSH 访问、 VM  映像上传、操作系统安装、端口管理、等等，会徒增网络负载。运营 3  个网络有点过分，但是每条流量路径都指示了部署一个大型数据集群前要仔细考虑的潜能力、吞吐量、性能瓶颈。

## 故障域

故障域指任何导致不能访问一个或多个 OSD 的故障，可以是主机上停止的进程、硬盘故障、操作系统崩溃、有问题的网卡、损坏的电源、断网、断电等等。规划硬件需求时，要在多个需求间寻求平衡点，像付出很多努力减少故障域带来的成本削减、隔离每个潜在故障域增加的成本。

## 最低硬件推荐

Ceph 可以运行在廉价的普通硬件上，小型生产集群和开发集群可以在一般的硬件上。

<table>
    <tr><th>进程</th><th>条件</th><th>最低建议</th></tr>
    <tr><td rowspan=5>ceph-osd</td><td>Processor</td><td>1x 64-bit AMD-64 <br> 1x 32-bit ARM dual-core or better <br> 1x i386 dual-core</td></tr>
    <tr><td>RAM</td><td>~1GB for 1TB of storage per daemon</td></tr>
    <tr><td>Volume Storage</td><td>1x storage drive per daemon</td></tr>
    <tr><td>Journal</td><td>1x SSD partition per daemon (optional)</td></tr>
    <tr><td>Network</td><td>2x 1GB Ethernet NICs</td></tr>
    <tr><td rowspan=4>ceph-mon</td><td>Processor</td><td>1x 64-bit AMD-64/i386 <br> 1x 32-bit ARM dual-core or better <br> 1x i386 dual-core</td></tr>
    <tr><td>RAM</td><td>1 GB per daemon</td></tr>
    <tr><td>Disk Space</td><td>10 GB per daemon</td></tr>
    <tr><td>Network</td><td>2x 1GB Ethernet NICs</td></tr>
    <tr><td rowspan=4>ceph-mds</td><td>Processor</td><td>1x 64-bit AMD-64 quad-core <br> 1x 32-bit ARM quad-core <br> 1x i386 quad-core</td></tr>
    <tr><td>RAM</td><td>1 GB minimum per daemon</td></tr>
    <tr><td>Disk Space</td><td>1 MB per daemon</td></tr>
    <tr><td>Network</td><td>2x 1GB Ethernet NICs</td></tr>
</table>

如果在只有一块硬盘的机器上运行 OSD ，要把数据和操作系统分别放到不同分区；一般来说，我们推荐操作系统和数据分别使用不同的硬盘。







# Hardware Recommendations

Ceph was designed to run on commodity hardware, which makes building and maintaining petabyte-scale data clusters economically feasible. When planning out your cluster hardware, you will need to balance a number of considerations, including failure domains and potential performance issues. Hardware planning should include distributing Ceph daemons and other processes that use Ceph across many hosts. Generally, we recommend running Ceph daemons of a specific type on a host configured for that type of daemon. We recommend using other hosts for processes that utilize your data cluster (e.g., OpenStack, CloudStack, etc).

Tip

Check out the [Ceph blog](https://ceph.com/community/blog/) too.

## CPU

Ceph metadata servers dynamically redistribute their load, which is CPU intensive. So your metadata servers should have significant processing power (e.g., quad core or better CPUs). Ceph OSDs run the [RADOS](https://docs.ceph.com/docs/master/glossary/#term-RADOS) service, calculate data placement with [CRUSH](https://docs.ceph.com/docs/master/glossary/#term-CRUSH), replicate data, and maintain their own copy of the cluster map. Therefore, OSDs should have a reasonable amount of processing power (e.g., dual core processors). Monitors simply maintain a master copy of the cluster map, so they are not CPU intensive. You must also consider whether the host machine will run CPU-intensive processes in addition to Ceph daemons. For example, if your hosts will run computing VMs (e.g., OpenStack Nova), you will need to ensure that these other processes leave sufficient processing power for Ceph daemons. We recommend running additional CPU-intensive processes on separate hosts.

## RAM

Generally, more RAM is better.

### Monitors and managers (ceph-mon and ceph-mgr)

Monitor and manager daemon memory usage generally scales with the size of the cluster.  For small clusters, 1-2 GB is generally sufficient.  For large clusters, you should provide more (5-10 GB).  You may also want to consider tuning settings like `mon_osd_cache_size` or `rocksdb_cache_size`.

### Metadata servers (ceph-mds)

The metadata daemon memory utilization depends on how much memory its cache is configured to consume.  We recommend 1 GB as a minimum for most systems.  See `mds_cache_memory`.

### OSDs (ceph-osd)

## Memory

Bluestore uses its own memory to cache data rather than relying on the operating system page cache.  In bluestore you can adjust the amount of memory the OSD attempts to consume with the `osd_memory_target` configuration option.

- Setting the osd_memory_target below 2GB is typically not recommended (it may fail to keep the memory that low and may also cause extremely slow performance.
- Setting the memory target between 2GB and 4GB typically works but may result in degraded performance as metadata may be read from disk during IO unless the active data set is relatively small.
- 4GB is the current default osd_memory_target size and was set that way to try and balance memory requirements and OSD performance for typical use cases.
- Setting the osd_memory_target higher than 4GB may improve performance when there are many (small) objects or large (256GB/OSD or more) data sets being processed.

Important

The OSD memory autotuning is “best effort”.  While the OSD may unmap memory to allow the kernel to reclaim it, there is no guarantee that the kernel will actually reclaim freed memory within any specific time frame.  This is especially true in older versions of Ceph where transparent huge pages can prevent the kernel from reclaiming memory freed from fragmented huge pages. Modern versions of Ceph disable transparent huge pages at the application level to avoid this, though that still does not guarantee that the kernel will immediately reclaim unmapped memory.  The OSD may still at times exceed it’s memory target.  We recommend budgeting around 20% extra memory on your system to prevent OSDs from going OOM during temporary spikes or due to any delay in reclaiming freed pages by the kernel.  That value may be more or less than needed depending on the exact configuration of the system.

When using the legacy FileStore backend, the page cache is used for caching data, so no tuning is normally needed, and the OSD memory consumption is generally related to the number of PGs per daemon in the system.

## Data Storage

Plan your data storage configuration carefully. There are significant cost and performance tradeoffs to consider when planning for data storage. Simultaneous OS operations, and simultaneous request for read and write operations from multiple daemons against a single drive can slow performance considerably.

Important

Since Ceph has to write all data to the journal before it can send an ACK (for XFS at least), having the journal and OSD performance in balance is really important!

### Hard Disk Drives

OSDs should have plenty of hard disk drive space for object data. We recommend a minimum hard disk drive size of 1 terabyte. Consider the cost-per-gigabyte advantage of larger disks. We recommend dividing the price of the hard disk drive by the number of gigabytes to arrive at a cost per gigabyte, because larger drives may have a significant impact on the cost-per-gigabyte. For example, a 1 terabyte hard disk priced at $75.00 has a cost of $0.07 per gigabyte (i.e., $75 / 1024 = 0.0732). By contrast, a 3 terabyte hard disk priced at $150.00 has a cost of $0.05 per gigabyte (i.e., $150 / 3072 = 0.0488). In the foregoing example, using the 1 terabyte disks would generally increase the cost per gigabyte by 40%–rendering your cluster substantially less cost efficient.

Tip

Running multiple OSDs on a single disk–irrespective of partitions–is **NOT** a good idea.

Tip

Running an OSD and a monitor or a metadata server on a single disk–irrespective of partitions–is **NOT** a good idea either.

Storage drives are subject to limitations on seek time, access time, read and write times, as well as total throughput. These physical limitations affect overall system performance–especially during recovery. We recommend using a dedicated drive for the operating system and software, and one drive for each Ceph OSD Daemon you run on the host. Most “slow OSD” issues arise due to running an operating system, multiple OSDs, and/or multiple journals on the same drive. Since the cost of troubleshooting performance issues on a small cluster likely exceeds the cost of the extra disk drives, you can optimize your cluster design planning by avoiding the temptation to overtax the OSD storage drives.

You may run multiple Ceph OSD Daemons per hard disk drive, but this will likely lead to resource contention and diminish the overall throughput. You may store a journal and object data on the same drive, but this may increase the time it takes to journal a write and ACK to the client. Ceph must write to the journal before it can ACK the write.

Ceph best practices dictate that you should run operating systems, OSD data and OSD journals on separate drives.

### Solid State Drives

One opportunity for performance improvement is to use solid-state drives (SSDs) to reduce random access time and read latency while accelerating throughput. SSDs often cost more than 10x as much per gigabyte when compared to a hard disk drive, but SSDs often exhibit access times that are at least 100x faster than a hard disk drive.

SSDs do not have moving mechanical parts so they are not necessarily subject to the same types of limitations as hard disk drives. SSDs do have significant limitations though. When evaluating SSDs, it is important to consider the performance of sequential reads and writes. An SSD that has 400MB/s sequential write throughput may have much better performance than an SSD with 120MB/s of sequential write throughput when storing multiple journals for multiple OSDs.

Important

We recommend exploring the use of SSDs to improve performance. However, before making a significant investment in SSDs, we **strongly recommend** both reviewing the performance metrics of an SSD and testing the SSD in a test configuration to gauge performance.

Since SSDs have no moving mechanical parts, it makes sense to use them in the areas of Ceph that do not use a lot of storage space (e.g., journals). Relatively inexpensive SSDs may appeal to your sense of economy. Use caution. Acceptable IOPS are not enough when selecting an SSD for use with Ceph. There are a few important performance considerations for journals and SSDs:

- **Write-intensive semantics:** Journaling involves write-intensive semantics, so you should ensure that the SSD you choose to deploy will perform equal to or better than a hard disk drive when writing data. Inexpensive SSDs may introduce write latency even as they accelerate access time, because sometimes high performance hard drives can write as fast or faster than some of the more economical SSDs available on the market!
- **Sequential Writes:** When you store multiple journals on an SSD you must consider the sequential write limitations of the SSD too, since they may be handling requests to write to multiple OSD journals simultaneously.
- **Partition Alignment:** A common problem with SSD performance is that people like to partition drives as a best practice, but they often overlook proper partition alignment with SSDs, which can cause SSDs to transfer data much more slowly. Ensure that SSD partitions are properly aligned.

While SSDs are cost prohibitive for object storage, OSDs may see a significant performance improvement by storing an OSD’s journal on an SSD and the OSD’s object data on a separate hard disk drive. The `osd journal` configuration setting defaults to `/var/lib/ceph/osd/$cluster-$id/journal`. You can mount this path to an SSD or to an SSD partition so that it is not merely a file on the same disk as the object data.

One way Ceph accelerates CephFS file system performance is to segregate the storage of CephFS metadata from the storage of the CephFS file contents. Ceph provides a default `metadata` pool for CephFS metadata. You will never have to create a pool for CephFS metadata, but you can create a CRUSH map hierarchy for your CephFS metadata pool that points only to a host’s SSD storage media. See [CRUSH Device Class](https://docs.ceph.com/docs/master/rados/operations/crush-map-edits/#crush-map-device-class) for details.

### Controllers

Disk controllers also have a significant impact on write throughput. Carefully, consider your selection of disk controllers to ensure that they do not create a performance bottleneck.

Tip

The [Ceph blog](https://ceph.com/community/blog/) is often an excellent source of information on Ceph performance issues. See [Ceph Write Throughput 1](http://ceph.com/community/ceph-performance-part-1-disk-controller-write-throughput/) and [Ceph Write Throughput 2](http://ceph.com/community/ceph-performance-part-2-write-throughput-without-ssd-journals/) for additional details.

### Additional Considerations

You may run multiple OSDs per host, but you should ensure that the sum of the total throughput of your OSD hard disks doesn’t exceed the network bandwidth required to service a client’s need to read or write data. You should also consider what percentage of the overall data the cluster stores on each host. If the percentage on a particular host is large and the host fails, it can lead to problems such as exceeding the `full ratio`,  which causes Ceph to halt operations as a safety precaution that prevents data loss.

When you run multiple OSDs per host, you also need to ensure that the kernel is up to date. See [OS Recommendations](https://docs.ceph.com/docs/master/start/os-recommendations) for notes on `glibc` and `syncfs(2)` to ensure that your hardware performs as expected when running multiple OSDs per host.

## Networks

Consider starting with a 10Gbps+ network in your racks. Replicating 1TB of data across a 1Gbps network takes 3 hours, and 10TBs takes 30 hours! By contrast, with a 10Gbps network, the  replication times would be 20 minutes and 1 hour respectively. In a petabyte-scale cluster, failure of an OSD disk should be an expectation, not an exception. System administrators will appreciate PGs recovering from a `degraded` state to an `active + clean` state as rapidly as possible, with price / performance tradeoffs taken into consideration. Additionally, some deployment tools employ VLANs to make  hardware and network cabling more manageable. VLANs using 802.1q protocol require VLAN-capable NICs and Switches. The added hardware expense may be offset by the operational cost savings for network setup and maintenance. When using VLANs to handle VM traffic between the cluster and compute stacks (e.g., OpenStack, CloudStack, etc.), it is also worth considering using 10G Ethernet. Top-of-rack routers for each network also need to be able to communicate with spine routers that have even faster throughput–e.g.,  40Gbps to 100Gbps.

Your server hardware should have a Baseboard Management Controller (BMC). Administration and deployment tools may also use BMCs extensively, so consider the cost/benefit tradeoff of an out-of-band network for administration. Hypervisor SSH access, VM image uploads, OS image installs, management sockets, etc. can impose significant loads on a network.  Running three networks may seem like overkill, but each traffic path represents a potential capacity, throughput and/or performance bottleneck that you should carefully consider before deploying a large scale data cluster.

## Failure Domains

A failure domain is any failure that prevents access to one or more OSDs. That could be a stopped daemon on a host; a hard disk failure,  an OS crash, a malfunctioning NIC, a failed power supply, a network outage, a power outage, and so forth. When planning out your hardware needs, you must balance the temptation to reduce costs by placing too many responsibilities into too few failure domains, and the added costs of isolating every potential failure domain.

## Minimum Hardware Recommendations

Ceph can run on inexpensive commodity hardware. Small production clusters and development clusters can run successfully with modest hardware.

| Process        | Criteria                                                     | Minimum Recommended                                          |
| -------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| `ceph-osd`     | Processor                                                    | 1 core minimum 1 core per 200-500 MB/s 1 core per 1000-3000 IOPS  Results are before replication. Results may vary with different CPU models and Ceph features. (erasure coding, compression, etc) ARM processors specifically may require additional cores. Actual performance depends on many factors including disk, network, and client throughput and latency. Benchmarking is highly recommended. |
| RAM            | 4GB+ per daemon (more is better) 2-4GB often functions (may be slow) Less than 2GB not recommended |                                                              |
| Volume Storage | 1x storage drive per daemon                                  |                                                              |
| DB/WAL         | 1x SSD partition per daemon (optional)                       |                                                              |
| Network        | 1x 1GbE+ NICs (10GbE+ recommended)                           |                                                              |
| `ceph-mon`     | Processor                                                    | 1 core minimum                                               |
| RAM            | 2GB+ per daemon                                              |                                                              |
| Disk Space     | 10 GB per daemon                                             |                                                              |
| Network        | 1x 1GbE+ NICs                                                |                                                              |
| `ceph-mds`     | Processor                                                    | 1 core minimum                                               |
| RAM            | 2GB+ per daemon                                              |                                                              |
| Disk Space     | 1 MB per daemon                                              |                                                              |
| Network        | 1x 1GbE+ NICs                                                |                                                              |

Tip

If you are running an OSD with a single disk, create a partition for your volume storage that is separate from the partition containing the OS. Generally, we recommend separate disks for the OS and the volume storage.