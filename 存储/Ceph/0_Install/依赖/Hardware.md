# Hardware

[TOC]

We recommend using other hosts for processes that utilize your data cluster (e.g., OpenStack, CloudStack, etc).

Ceph 设计用于在商品硬件上运行，这使得构建和维护 PB 级数据集群在经济上可行。

规划集群硬件时，需要均衡几方面的因素，包括故障域和潜在的性能问题。

硬件规划应包括在多个主机上分发 Ceph 守护进程和其他使用 Ceph 的进程。Generally, we recommend running Ceph daemons of a specific type on a host configured for that type of daemon. 通常，建议在为该类型守护程序配置的主机上运行特定类型的Ceph守护程序。我们建议为利用数据集群的进程（例如，开放堆栈、云堆栈等）使用其他主机。

## CPU

MDS 是 CPU 密集型的，应该具有显著的处理能力（例如，四核或更好的 CPU ），更高的时钟速率（以 GHz 为单位的频率）。

OSD 运行 RADOS 服务，使用 CRUSH 计算数据放置，复制数据，并维护自己的集群映射副本。应该具有合理的处理能力，需求因用例而异：a starting point might be one core per OSD for light / archival usage, and two cores per OSD for heavy workloads such as RBD volumes attached to VMs. 一个起点可能是每个 OSD 一个核心用于轻/归档使用，而每个 OSD 两个核心用于重负载（如连接到 VM 的 RBD 卷）。

MON / MGR 没有很高的CPU需求。

## 内存

对于中等规模的集群，MON / MGR 可以使用64GB；对于具有数百个 OSD 的较大集群，128GB 是合理的。

There is a memory target for BlueStore OSDs that defaults to 4GB. Blue Store OSD 有一个默认为 4GB 的内存目标。虑到操作系统和管理任务（如监视和度量）以及恢复期间消耗的增加，建议为每个 Blue  Store OSD 配置约 8GB。

### MON / Mgr

MON 和 MGR 内存使用通常随集群的大小而扩展。at boot-time and during topology changes and recovery these daemons will need more RAM than they do during steady-state operation。在引导时、拓扑更改和恢复期间，这些守护进程将需要比稳态操作期间更多的 RAM。需计划峰值使用率。对于非常小的集群，32GB 就足够了。对于高达300个 OSD 的集群，可以使用 64GB。对于使用更多 OSD 构建的集群（或者将增长到更多 OSD ），应该提供 128GB。可能需要考虑调整以下设置：

* mon_osd_cache_size
* rocksdb_cache_size

### MDS

The metadata daemon memory utilization depends on how much memory its cache is configured to consume.  MDS 内存利用率取决于其缓存配置为消耗多少内存。对于大多数系统，建议至少1 GB。

* mds_cache_momory_limit

### OSD

Bluestore 使用自己的内存来缓存数据，而不是依赖于操作系统页缓存。在 Bluestore 中，可使用 `osd_memory_target` 配置选项调整 OSD 尝试使用的内存量。

- 通常不建议将 `osd_memory_target` 设置为2GB以下（可能无法保持内存消耗低于 2GB，并且可能会导致极其缓慢的性能）。

- 将内存目标设置在 2 - 4 GB 之间通常是可行的，但可能会导致性能下降，因为在 IO 期间可能会从磁盘读取元数据，除非活动数据集相对较小。metadata may be read from disk during IO unless the active data set is relatively small.

- 4GB 是当前默认 `osd_memory_target` 大小。was set that way to try and balance memory requirements and OSD performance for typical use cases.这样设置是为了在典型用例中尝试平衡内存需求和 OSD 性能。

- 当处理多个（小）对象或大（256 GB / OSD或更多）数据集时，将 `osd_memory_target` 设置为高于 4GB 可能会提高性能。

> **Important**
>
> This applies especially in older versions of Ceph, where transparent huge pages can prevent the kernel from reclaiming memory that was freed from fragmented huge pages. Modern versions of Ceph disable transparent huge pages at the application level to avoid this, but that does not guarantee that the kernel will immediately reclaim unmapped memory. The OSD may still at times exceed its memory target. We recommend budgeting approximately 20% extra memory on your system to prevent OSDs from going OOM (**O**ut **O**f **M**emory) during temporary spikes or due to delay in the kernel reclaiming freed pages. 
>
> OSD 内存自动调整是“尽力而为”。虽然 OSD 可能会取消映射内存以允许内核回收它，但不能保证内核会在任何特定的时间范围内回收释放的内存。这尤其适用于旧版本的 Ceph，其中透明的巨大页面可以阻止内核回收从碎片化的巨大页面中释放出来的内存。Ceph 的现代版本在应用程序级别禁用透明的巨大页面以避免这种情况，但这并不保证内核会立即回收未映射的内存。OSD 有时仍可能超出其内存目标。我们建议在系统上预算大约 20% 的额外内存，以防止 OSD 在临时峰值期间或由于内核回收释放页面的延迟而出现 OOM（内存不足）。20% 的值可能大于或小于所需值，具体取决于系统的确切配置。

使用传统 FileStore 后端时，页面缓存用于缓存数据，通常不需要进行调优，OSD 内存消耗通常与系统中每个守护进程的 PG 数量有关。

## 数据存储

在规划数据存储时，需要考虑大量的成本和性能权衡。Simultaneous OS operations, and simultaneous request for read and write operations from multiple daemons against a single drive 同时进行操作系统操作，以及同时请求多个守护进程对单个驱动器执行读写操作，都会大大降低性能。

> **Important**
>
> Since Ceph has to write all data to the journal (or WAL+DB) before it can ACK writes
>
> 由于Ceph 在 ACK write 前，必须在 journal（或 WAL+DB）上写入所有数据，因此平衡元数据和 OSD 性能是非常重要的！

### 硬盘驱动器

建议最小为 1TB。NVMe 驱动器可以通过拆分成两个以上的 OSD 来提高性能。

不建议在单个驱动器上运行 OSD、MON 或 MDS。

Storage drives are subject to limitations on seek time, access time, read and write times, as well as total throughput. 

存储驱动器受寻道时间、访问时间、读写时间以及总吞吐量的限制。这些物理限制会影响整个系统性能，尤其是在恢复期间。建议为操作系统和软件使用专用（理想情况下是镜像的）驱动器，为主机上运行的每个 OSD 使用一个驱动器（modulo NVMe above，上面的NVMe模块）。在同一个驱动器上运行操作系统、多个 OSD 时，会导致许多“ slow OSD ”问题（不可归因于硬件故障）。

从技术上讲，可以在每个 SAS / SATA 驱动器上运行多个 OSD 守护程序，但这将导致资源争用并降低总体吞吐量。

要获得最佳性能，请在单独的驱动器上运行：

* 操作系统
* OSD
* Blue Store db

### 固态硬盘

使用固态驱动器（SSD）可以提高 Ceph 性能。这减少了随机访问时间，减少了延迟，同时加快了吞吐量。

SSD 的每 GB 成本高于硬盘驱动器，但 SSD 通常提供的访问时间至少比硬盘驱动器快100倍。SSD 避免了繁忙集群中的热点问题和瓶颈问题，并且在全面评估 TCO 时，它们可以提供更好的经济性。

SSDs do not have moving mechanical parts, so they are not necessarily subject to the same types of limitations as hard disk drives. SSDs do have significant limitations though. When evaluating SSDs, it is important to consider the performance of sequential reads and writes.

SSD 没有可移动的机械部件，因此它们不一定受到与硬盘驱动器相同类型的限制。不过，固态硬盘确实有很大的局限性。在评估 SSD 时，重要的是要考虑顺序读写的性能。

> **Important**
>
> We recommend exploring the use of SSDs to improve performance. However, before making a significant investment in SSDs, we **strongly recommend** both reviewing the performance metrics of an SSD and testing the SSD in a test configuration to gauge performance.
>
> 我们建议探索使用 SSD 来提高性能。但是，在对 SSD 进行重大投资之前，我们强烈建议您检查 SSD 的性能指标，并在测试配置中测试 SSD ，以评估性能。

相对便宜的 SSD ，请谨慎使用。在选择用于 Ceph 的 SSD 时，可接受的 IOPS 并不是唯一需要考虑的因素。

SSD 在对象存储方面历来成本高昂，但新兴的 QLC 驱动器正在缩小差距，提供更高的密度、更低的功耗和更少的冷却功耗。通过将 WAL + DB 卸载到 SSD 上，HDD OSD 可能会显著提高性能。

### Partition Alignment

将 SSD 与 Ceph 一起使用时，请确保分区正确对齐。未正确对齐的分区的数据传输速度比正确对齐的分区慢。

### CephFS Metadata Segregation

One way Ceph accelerates CephFS file system performance is to segregate the storage of CephFS metadata from the storage of the CephFS file contents. Ceph provides a default `metadata` pool for CephFS metadata. You will never have to create a pool for CephFS metadata, but you can create a CRUSH map hierarchy for your CephFS metadata pool that points only to a host’s SSD storage media. 

Ceph 加速 CephFS 文件系统性能的一种方法是将 CephFS 元数据的存储与 CephFS 文件内容的存储隔离开来。Ceph 为 CephFS 元数据提供默认元数据池。不必为 CephFS 元数据创建池，但可以为 CephFS 元数据池创建仅指向 SSD 存储介质的CRUSH map层次结构。

### 控制器

磁盘控制器（HBA）会对写入吞吐量产生重大影响。 仔细考虑您的选择，以确保它们不会造成性能瓶颈。值得注意的是，RAID 模式（IR）HBA 可能比简单的 “JBOD”（IT）模式 HBA 表现出更高的延迟。并且RAID SoC、写缓存和电池备份可能会大幅增加硬件和维护成本。

### Benchmarking

Blue Store 在 O_DIRECT 中打开块设备，并经常使用 fsync 来确保数据安全地持久化到媒体。可以使用 fio 评估驱动器的低级别写入性能。例如，4kB 随机写入性能的测量如下：

```bash
fio --name=/dev/sdX --ioengine=libaio --direct=1 --fsync=1 --readwrite=randwrite --blocksize=4k --runtime=300
```

### 写缓存

include power loss protection features which use multi-level caches to speed up direct or synchronous writes. 企业 SSD 和 HDD 通常包括功耗保护功能，这些功能使用多级缓存来加速直接或同步写入。a volatile cache flushed to persistent media with fsync, or a non-volatile cache written synchronously.这些设备可以在两种缓存模式之间切换，一种是使用 fsync 刷新到持久介质的易失性缓存，另一种是同步写入的非易失性缓存。

通过“启用”或“禁用”写（易失性）缓存来选择这两种模式。启用易失性缓存时，Linux使用处于“ write back”模式的设备，禁用时，它使用“ write through ”。

默认配置（通常启用缓存）可能不是最佳配置，通过禁用写缓存，OSD 性能可能会显著提高 IOPS 并减少提交延迟。

因此，鼓励用户如前所述使用 fio 对其设备进行基准测试，并为其设备保持最佳缓存配置。

可以使用  `hdparm`, `sdparm`, `smartctl` 或通过读取 `/sys/class/scsi_disk/*/cache_type` 中的值来查询缓存配置。例如：

```bash
hdparm -W /dev/sda
/dev/sda:
 write-caching =  1 (on)
========================================================================================== 
sdparm --get WCE /dev/sda
    /dev/sda: ATA       TOSHIBA MG07ACA1  0101
WCE           1  [cha: y]
========================================================================================== 
smartctl -g wcache /dev/sda
smartctl 7.1 2020-04-05 r5049 [x86_64-linux-4.18.0-305.19.1.el8_4.x86_64] (local build)
Copyright (C) 2002-19, Bruce Allen, Christian Franke, www.smartmontools.org

Write cache is:   Enabled
cat /sys/class/scsi_disk/0\:0\:0\:0/cache_type
write back
```

使用相同的工具可以关闭写缓存：

```bash
hdparm -W0 /dev/sda
/dev/sda:
 setting drive write-caching to 0 (off)
 write-caching =  0 (off)
==========================================================================================
sdparm --clear WCE /dev/sda
    /dev/sda: ATA       TOSHIBA MG07ACA1  0101
==========================================================================================
smartctl -s wcache,off /dev/sda
smartctl 7.1 2020-04-05 r5049 [x86_64-linux-4.18.0-305.19.1.el8_4.x86_64] (local build)
Copyright (C) 2002-19, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF ENABLE/DISABLE COMMANDS SECTION ===
Write cache disabled
```

通常，使用 `hdparm`, `sdparm` 或 `smartctl` 禁用缓存会导致缓存类型自动更改为 “write through” 。如果情况并非如此，您可以尝试按以下方式直接设置它。（用户应注意，设置缓存类型也会正确地保持设备的缓存模式，直到下次重新启动）:

```bash
echo "write through" > /sys/class/scsi_disk/0\:0\:0\:0/cache_type
hdparm -W /dev/sda

/dev/sda:
 write-caching =  0 (off)
```

**Tip**

This udev rule will set all SATA/SAS device cache_types to “write through”:

```bash
# CentOS 8
cat /etc/udev/rules.d/99-ceph-write-through.rules
ACTION=="add", SUBSYSTEM=="scsi_disk", ATTR{cache_type}:="write through"

# CentOS 7
cat /etc/udev/rules.d/99-ceph-write-through-el7.rules
ACTION=="add", SUBSYSTEM=="scsi_disk", RUN+="/bin/sh -c 'echo write through > /sys/class/scsi_disk/$kernel/cache_type'"
```

**Tip**

`sdparm` 实用程序可用于一次查看/更改多个设备上的易失性写缓存：

```bash
sdparm --get WCE /dev/sd*
    /dev/sda: ATA       TOSHIBA MG07ACA1  0101
WCE           0  [cha: y]
    /dev/sdb: ATA       TOSHIBA MG07ACA1  0101
WCE           0  [cha: y]

sdparm --clear WCE /dev/sd*
    /dev/sda: ATA       TOSHIBA MG07ACA1  0101
    /dev/sdb: ATA       TOSHIBA MG07ACA1  0101
```

### 其他注意事项

You typically will run multiple OSDs per host, but you should ensure that the aggregate throughput of your OSD drives doesn’t exceed the network bandwidth required to service a client’s need to read or write data. 通常，会在每台主机上运行多个 OSD，但应该确保 OSD 驱动器的总吞吐量不会超过满足客户端读写数据需要所需的网络带宽。You should also consider what percentage of the overall data the cluster stores on each host. 还应该考虑集群在每个主机上存储的总数据的百分比。If the percentage on a particular host is large and the host fails, it can lead to problems such as exceeding the `full ratio`,  which causes Ceph to halt operations as a safety precaution that prevents data loss.如果特定主机上的百分比很大，并且主机发生故障，则可能会导致问题，例如超过完整比率，从而导致Ceph停止操作，作为防止数据丢失的安全预防措施。

当在每个主机上运行多个 OSD 时，还需要确保内核是最新的。

## 网络

在机架中提供至少 10Gbps 以上的网络。跨 1Gbps 网络复制 1TB 数据需要 3 小时，10TB 需要 30 小时！相比之下，使用 10Gbps 网络，复制时间将分别为 20 分钟和 1 小时。在 PB 级集群中，OSD 驱动器出现故障是意料之中的事，而不是例外。系统管理员希望 PG 尽快从降级状态恢复到 `active + clean` 状态，并考虑价格/性能权衡。此外，一些部署工具使用 VLAN 使硬件和网络布线更易于管理。使用 802.1q 协议的 VLAN 需要支持 VLAN 的 NIC 和交换机。增加的硬件费用可能会被网络设置和维护的运营成本节约所抵消。当使用 VLAN 处理集群和计算堆栈（例如开放堆栈、云堆栈等）之间的 VM 流量时，使用 10G 以太网或更好的以太网会有额外的价值；截至 2020 年，40Gb 或 25 / 50 / 100 Gb 的网络对于生产集群来说很常见。

每个网络的 Top-of-rack 路由器还需要能够与吞吐量更快（通常为 40Gbp/s 或更高）的 spine 路由器通信。

服务器硬件应该有一个 Baseboard Management Controller（BMC）。管理和部署工具也可能广泛使用 BMC，尤其是通过 IPMI 或 Redfish ，因此请考虑管理带外网络的成本/效益权衡。Hypervisor  SSH 访问、VM 映像上载、操作系统映像安装、管理套接字等都会给网络带来巨大的负载。运行三个网络似乎有些过分，但每个通信路径都代表着一个潜在的容量、吞吐量和/或性能瓶颈，在部署大规模数据集群之前，您应该仔细考虑这些瓶颈。

 ![](../../../../Image/ceph_network.png)

## 故障域

A failure domain is any failure that prevents access to one or more OSDs. That could be a stopped daemon on a host; a hard disk failure, an OS crash, a malfunctioning NIC, a failed power supply, a network outage, a power outage, and so forth. When planning out your hardware needs, you must balance the temptation to reduce costs by placing too many responsibilities into too few failure domains, and the added costs of isolating every potential failure domain.

故障域是阻止访问一个或多个 OSD 的任何故障。这可能是主机上已停止的守护进程；硬盘故障、操作系统崩溃、NIC 故障、电源故障、网络中断、电源中断等等。在规划硬件需求时，您必须平衡将太多的责任放在太少的故障域中以降低成本的诱惑，以及隔离每个潜在故障域所增加的成本。

## 最低硬件推荐

Ceph 可以在廉价的商用硬件上运行。Small production clusters and development clusters can run successfully with modest hardware.小型的生产集群和开发集群可以使用适当的硬件成功运行。

### ceph-osd
* Processor
  * 1 core minimum
  * 1 core per 200-500 MB/s
  * 1 core per 1000-3000 IOPS
  * Results are before replication.
  * Results may vary with different CPU models and Ceph features. (erasure coding, compression, etc)
  * ARM processors specifically may require additional cores.
  * Actual performance depends on many factors including drives, net, and client throughput and latency. Benchmarking is highly recommended.
* RAM
  * 4GB+ per daemon (more is better)
  * 2-4GB often functions (may be slow)
  * Less than 2GB not recommended
* Volume Storage
  * 1x storage drive per daemon
* DB/WAL
  * 1x SSD partition per daemon (optional)
* Network
  * 1x 1GbE+ NICs (10GbE+ recommended)

### ceph-mon
* Processor
  * 2 cores minimum
* RAM
  * 2-4GB+ per daemon
* Disk Space
  * 60 GB per daemon
* Network
  * 1x 1GbE+ NICs

### ceph-mds

* Processor
  * 2 cores minimum
* RAM
  * 2GB+ per daemon
* Disk Space
  * 1 MB per daemon
* Network
  * 1x 1GbE+ NICs


> Tip
>
> If you are running an OSD with a single disk, create a partition for your volume storage that is separate from the partition containing the OS. Generally, we recommend separate disks for the OS and the volume storage.
>
> 如果使用单个磁盘运行OSD，请为卷存储创建一个独立于包含 OS 分区的分区。通常，我们建议操作系统和卷存储使用单独的磁盘。



