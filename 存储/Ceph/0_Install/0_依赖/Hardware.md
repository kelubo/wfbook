# Hardware

[TOC]

## 概述

Ceph 被设计为在商业硬件上运行，这使得构建和维护 PB 级数据集群变得灵活和经济可行。

在规划集群硬件时，需要均衡考虑几方面的因素，包括故障域、成本和性能。

硬件规划应包括在多台主机上分发 Ceph 守护进程和其他使用 Ceph 的进程。通常，建议在为特定类型的守护程序配置的主机上运行特定类型的 Ceph 守护程序。建议为使用数据集群的进程使用其他主机（例如，OpenStack 、CloudStack 、Kubernetes 等）。

## CPU

MDS 是 CPU 密集型的，在高时钟频率（GHz）的CPU上性能最佳。不需要大量的 CPU 核心，除非它们还托管其他服务，例如 CephFS 元数据池的 SSD OSD 。

OSD 需要足够的处理能力去运行 RADOS 服务，用于使用 CRUSH 计算数据放置，复制数据，并维护自己的 cluster map 副本。

在早期版本的 Ceph 中，会根据每个 OSD 的核心数来提出硬件建议，但这个 cores-per-OSD 指标不再像每个 IOP 的周期数和每个 OSD  IOP 数那样有用。例如，对于 NVMe 驱动器，Ceph 可以轻松地在实际集群上使用五个或六个内核，在单个 OSD 上单独使用多达十四个内核。Ceph can easily utilize five or six cores on real clusters and up to about fourteen cores on single OSDs in isolation. 因此，每个 OSD 的核心不再像以前那样紧迫。选择硬件时，选择每个核心的 IOP 。

> 当我们谈到CPU core 时，我们指的是启用超线程时的 thread 。超线程通常对 Ceph 服务器有益。

MON 节点和 MGR 节点对 CPU 的要求不高，只需要适度的处理器。如果主机除了 Ceph 守护程序之外，还将运行 CPU 密集型程序，请确保具有足够的处理能力来同时运行 CPU 密集型程序和 Ceph 守护程序。建议在单独的主机上运行非 Ceph CPU 密集型程序（在不是 MON 和 MGR 节点的主机上），以避免资源争夺。

如果群集部署了 Ceph 对象网关，则 RGW 守护程序可能与 MON 和 MGR 服务共存（如果节点有足够的资源）。

### MDS

MDS 的当前版本对于大多数活动（包括响应客户端请求）来说都是单线程和 CPU绑定（ CPU-bound ）的。An MDS under the most aggressive client loads uses about 2 to 3 CPU cores. 在最激进的客户端负载下，MDS 使用大约 2 到 3 个 CPU 核心。This is due to the other miscellaneous upkeep threads working in tandem.这是由于其他杂项维护线程协同工作。

即便如此，建议 MDS 服务器配备具有足够核心的高级 CPU 。开发正在进行中，以更好地在 MDS 中利用可用的 CPU 核心。预计在 Ceph 的未来版本中，MDS 将通过利用更多核心来提高性能。

## 内存

一般来说，RAM 越多越好。对于中等规模的集群，MON / MGR 可以使用 64GB；对于具有数百个 OSD 的较大集群，128GB 是合理的。

> when we speak of RAM and storage requirements, we often describe the needs of a single daemon of a given type.  A given server as a whole will thus need at least the sum of the needs of the daemons that it hosts as well as resources for logs and other operating system components.  Keep in mind that a server’s need for RAM and storage will be greater at startup and when components fail or are added and the cluster rebalances.  In other words, allow headroom past what you might see used during a calm period on a small initial cluster footprint.
>
> 当我们谈到 RAM 和存储需求时，通常描述给定类型的单个守护程序的需求。因此，一个给定的服务器作为一个整体至少需要它所承载的守护进程的需求以及日志和其他操作系统组件的资源的总和。请记住，服务器在启动时以及组件出现故障或添加组件以及群集重新平衡时对RAM和存储的需求会更大。换句话说，在一个小的初始集群占用空间上，允许超过您在平静时期可能看到的使用量。

BlueStore OSD 的 `osd_memory_target` 被设置默认为 4GB 。Factor in a prudent margin for the operating system and administrative tasks (like monitoring and metrics) as well as increased consumption during recovery: 虑到操作系统和管理任务（如监视和度量）以及恢复期间增加的消耗，建议为每个 BlueStore OSD 配置约 8GB 。

### MON / MGR

MON 和 MGR 内存使用通常随集群的大小而扩展。在引导时、拓扑更改和恢复期间，这些守护进程将需要比稳态运行期间更多的 RAM。需计划峰值使用率。对于非常小的集群，32GB 就足够了。对于高达 300 个 OSD 的集群，可以使用 64GB。对于使用更多（或者将增长到更多）OSD 构建的集群，应该提供 128GB 。可能需要考虑调整以下设置：

* `mon_osd_cache_size`
* `rocksdb_cache_size`

### MDS

The MDS necessarily manages a distributed and cooperative metadata cache among all clients and other active MDSs. MDS 必须管理所有客户端和其他活动 MDS 之间的分布式和协作的元数据缓存。因此，必须为MDS提供足够的RAM，以实现更快的元数据访问和变化。默认 MDS 缓存大小为 4GB 。建议为 MDS 配置至少 8 GB 的 RAM 以支持此缓存大小。

通常，为大型客户端集群（1000 或更多）服务的 MDS 将使用至少 64 GB 的缓存。An MDS with a larger cache is not well explored in the largest known community clusters。在最大的已知社区集群中，没有很好地探索具有较大缓存的 MDS 。there may be diminishing returns where management of such a large cache negatively impacts performance in surprising ways.在管理如此大的缓存以令人惊讶的方式对性能产生负面影响的情况下，可能存在收益递减。最好对预期的工作负载进行分析，以确定是否值得配置更多的 RAM 。

在裸机集群中，最佳做法是为 MDS 过度配置硬件。即使单个 MDS 守护进程无法充分利用硬件，稍后也可能需要在同一节点上启动更多活动 MDS 守护进程，以充分利用可用的内核和内存。此外，对于群集上的工作负载，可以清楚地看出，在同一节点上使用多个活动 MDS 而不是过度配置单个 MDS 可以提高性能。

最后，请注意 CephFS 是一个高可用性文件系统，它支持备用 MDS 以实现快速故障转移。为了从部署备用进程中获得真实的好处，通常需要在集群中的至少两个节点上分发 MDS 守护进程。否则，单个节点上的硬件故障可能导致文件系统变得不可用。

将 MDS 与其他 Ceph 守护进程（超融合）放在一起是一种有效的推荐方法，只要所有守护进程都配置为在特定限制内使用可用硬件即可。对于 MDS ，这通常意味着限制其缓存大小。

MDS 内存利用率取决于其缓存配置为消耗多少内存。对于大多数系统，建议至少 1 GB。

* `mds_cache_memory_limit`

### OSD

Bluestore 使用自己的内存来缓存数据，而不是依赖于操作系统的页面缓存。在 Bluestore 中，可使用 `osd_memory_target` 配置选项调整 OSD 尝试使用的内存量。

- 不建议将 `osd_memory_target` 设置为 2GB 以下（可能无法将内存消耗保持在 2GB 以下，并且可能会导致极低的性能。）。
- 将内存目标设置在 2 - 4 GB 之间通常是可行的，但可能会导致性能下降，因为在 IO 期间可能会从磁盘读取元数据，除非活动数据集相对较小。
- 4GB 是当前默认 `osd_memory_target` 大小。为典型用例选择了此默认值，旨在平衡内存消耗和 OSD 性能。
- 当有许多（小）对象或处理大（256 GB/OSD 或更大）数据集时，将 `osd_memory_target` 设置为高于 4GB 可以提高性能。对于快速的 NVMe OSD 来说尤其如此。

> **重要：**
>
> OSD 内存管理是“尽力而为”。尽管 OSD 可以取消内存映射以允许内核回收它，但不能保证内核将在特定的时间范围内实际回收释放的内存。这在旧版本的 Ceph 中尤其适用，where transparent huge pages can prevent the kernel from reclaiming memory that was freed from fragmented huge pages. 其中透明的大页面可以阻止内核回收从碎片化的大页面中释放的内存。现代版本的 Ceph 在应用程序级别禁用透明的巨大页面以避免这种情况，但这并不能保证内核会立即回收未映射的内存。The OSD may still at times exceed its memory target. OSD 有时仍可能超过其存储器目标。建议在系统上至少预留 20% 的额外内存，以防止 OSD 在临时高峰期间或由于内核回收释放页面的延迟而出现 OOM（内存不足）。这个 20% 的值可能比所需的多或少，具体取决于系统的确切配置。
>
> 对于现代系统，不建议使用 swap 配置操作系统来为守护进程提供额外的虚拟内存。这样做可能会导致性能降低，并且 Ceph 集群可能会更喜欢崩溃的守护进程，而不是慢到爬行的守护进程。

在使用旧版 FileStore 后端时，操作系统页面缓存用于缓存数据，因此通常不需要调优。OSD 内存消耗与系统中每个守护程序的 PG 数量有关。

## 数据存储

在规划数据存储时，需要考虑大量的成本和性能权衡。同时操作系统操作和多个守护进程同时请求对单个驱动器进行读写操作可能会影响性能。

OSD 需要大量的存储驱动器空间来存储 RADOS 数据。建议最小驱动器大小为 1 TB。远远小于 1 TB 的 OSD 驱动器将其容量的很大一部分用于元数据，而小于 100 GB 的驱动器将完全无效。

强烈建议至少为 MON 和 MGR 主机以及 CephFS  MDS 元数据池和 Ceph 对象网关（RGW）索引池配置（企业级）SSD，即使要为批量 OSD 数据配置 HDD 也是如此。

要获得 Ceph 的最佳性能，在单独的驱动器上运行以下内容：

* 操作系统
* OSD 数据
* BlueStore WAL+DB

### 硬盘驱动器

考虑较大磁盘的每 GB 成本优势。

建议将磁盘驱动器的价格除以 GB 数，以得出每 GB 的成本，因为较大的驱动器可能会对每 GB 的成本产生重大影响。在前面的示例中，使用 1 TB 磁盘通常会使每 GB 的成本增加 40% ——使集群的成本效率大大降低。

不建议在一个 SAS / SATA 驱动器上运行多个 OSD ，这可能会导致资源争夺并减少整体吞吐量。但 NVMe 驱动器可以通过拆分成两个以上的 OSD 来提高性能。

不建议在单个驱动器上同时运行 OSD、MON、MGR 或 MDS。

使用旋转磁盘时，SATA 和 SAS 接口在更大的容量下日益成为瓶颈。

存储驱动器受寻道时间、访问时间、读取和写入时间以及总吞吐量的限制。这些物理限制会影响整体系统性能，尤其是在恢复期间。

建议为操作系统和软件使用专用（理想情况下是镜像的）驱动器，并为主机上运行的每个 OSD 使用一个驱动器。许多 “slow OSD” 问题（当它们不是由硬件故障引起时）是由于在同一驱动器上运行操作系统和多个 OSD 引起的。还要注意的是，今天的 22 TB 硬盘使用的 SATA 接口与十年前的 3 TB 硬盘相同：more than seven times the data to squeeze through the same same interface通过同一接口压缩的数据是原来的 7 倍多。因此，在将 HDD 用于 OSD 时，大于 8 TB 的驱动器可能最适合存储对性能完全不敏感的大型文件/对象。

### 固态硬盘

当使用固态硬盘（SSD）时，Ceph 的性能得到了很大的提高。这减少了随机访问时间，减少了延迟的同时，增加了吞吐量。

SSD 的每 GB 成本高于 HDD，但 SSD 通常提供的访问时间至少比 HDD 快100倍。SSD 避免了繁忙集群中的热点问题和瓶颈问题，并且在全面评估 TCO 时，可以提供更好的经济性。

值得注意的是，对于给定数量的 IOPS ，SSD 的摊销驱动器成本远低于 HDD 。SSD 不会遭受旋转或寻道延迟，除了提高客户端性能外，还大大提高了群集更改的速度和客户端影响，包括当 OSD 、MON 在添加、删除或发生故障时进行的重新平衡。

SSD 没有可移动的机械部件，因此它们不一定受到与 HDD 相同类型的限制。不过，SSD 确实有很大的局限性。在评估 SSD 时，重要的是要考虑顺序和随机读写的性能。

> **Important**
>
> 建议尝试使用 SSD 来提高性能。但是，在对 SSD 进行重大投资之前，强烈建议检查 SSD 的性能指标，并在测试配置中测试 SSD ，以评估性能。

相对便宜的 SSD ，请谨慎使用。在选择用于 Ceph 的 SSD 时，可接受的 IOPS 并不是唯一需要考虑的因素。

便宜的 SSD 往往是一种虚假的经济：它们可能会经历“陡降”，这意味着在初始突发之后，一旦有限的高速缓存被填满，持续的性能就会显著下降。还要考虑耐久性：a drive rated for 0.3 Drive Writes Per Day (DWPD or equivalent) may be fine for OSDs dedicated to certain types of sequentially-written read-mostly data额定为 0.3 驱动器写入/天（DWPD 或等效）的驱动器对于专用于某些类型的顺序写入、主要为读取的数据的OSD来说可能是合适的，但是对于 Ceph MON 任务来说不是好的选择。企业级 SSD 是最适合 Ceph 的 ：  they almost always feature power less protection (PLP) and do not suffer the dramatic cliffing that client (desktop) models may experience.它们几乎总是以低功耗保护（PLP）为特征，并且不会遭受客户端（桌面）模型可能经历的急剧下降。

当将单个（或镜像对）SSD 同时用于操作系统引导和 Ceph MON / MGR 时，最小容量为 256 GB，建议至少为 480 GB。建议使用额定值为 1+ DWPD 或等效值为 TBW（TeraBytes Written）的驱动器型号。但是，对于给定的写入工作负载，比技术要求更大的驱动器将提供更大的耐久性，因为它实际上具有更大的过预存。我们强调，企业级硬盘最适合生产使用，因为与客户端（台式机）SKU 相比，它们具有断电保护功能和更高的耐用性，而客户端（台式机）SKU 旨在实现更轻的间歇性工作周期。

SSD 在对象存储方面一直成本高昂，但 QLC SSD 正在缩小差距，以更低的功耗和更少的冷却功耗提供更高的密度。此外，HDD OSD 可以通过将 WAL+DB 卸载到 SSD 上来看到显著的写入延迟改善。许多 Ceph OSD 部署不需要具有大于 1 DWPD 的耐久性的 SSD（也称为“读取优化”）。3 DWPD 类中的“混合用途” SSD 通常为此目的而大材小用，而且成本要高得多。

### 分区对齐

将 SSD 与 Ceph 一起使用时，请确保分区正确对齐。未正确对齐的分区的数据传输速度比正确对齐的较慢。

### CephFS Metadata 隔离

加速 CephFS 文件系统性能的一种方法是将 CephFS 元数据的存储与 CephFS 文件内容的存储分离。Ceph 为 CephFS 元数据提供默认 `metadata` 池。不必为 CephFS 元数据创建池，但可以为 CephFS 元数据池创建仅指向 SSD 存储介质的 CRUSH map 层次结构。

### 控制器

磁盘控制器（HBA）可能会对写入吞吐量产生重大影响。 仔细考虑 HBA 的选择，以确保它们不会造成性能瓶颈。值得注意的是，RAID 模式（IR）HBA 可能比简单的 “JBOD”（IT）模式 HBA 表现出更高的延迟。并且 RAID SoC、写缓存和电池备份可能会大幅增加硬件和维护成本。一些 RAID HBA 可以使用 IT 模式 “personality” 配置或 “ JBOD 模式”，以简化操作。

不需要 RoC（支持 RAID）HBA 。ZFS 或 Linux MD 软件镜像对于 boot 卷的持久性非常有用。使用 SAS 或 SATA 数据驱动器时，放弃 HBA RAID 功能可以缩小 HDD 和 SSD 介质成本之间的差距。此外，当使用 NVMe SSD 时，不需要任何 HBA 。当系统作为一个整体考虑时，这还减少了 HDD 与 SSD 的成本差距。一个花哨的 RAID HBA 加上板载缓存加上电池备份（BBU 或超级电容器）的初始成本即使在折扣后也很容易超过 1000 美元，a sum that goes a log way toward SSD cost parity.这一总和与SSD成本相当。如果购买年度维护合同或延长保修期，无 HBA 系统每年也可节省数百美元。

### 基准测试

BlueStore 在 O_DIRECT 中打开块设备，并频繁使用 fsync 来确保数据安全地持久化到介质。可以使用 fio 评估驱动器的低级别写入性能。例如，4kB 随机写入性能的测量如下：

BlueStore 使用 `O_DIRECT` 打开存储设备，并频繁发出 `fsync()` 以确保数据安全地持久化到介质。可以使用 `fio` 评估驱动器的低级写入性能。例如，4kB 随机写入性能测量如下：

```bash
fio --name=/dev/sdX --ioengine=libaio --direct=1 --fsync=1 --readwrite=randwrite --blocksize=4k --runtime=300
```

### 写缓存

企业级 SSD 和 HDD 通常包括断电丢失保护功能，可确保在运行过程中断电时的数据持久性，并使用多级缓存来加速直接或同步写入。这些设备可以在两种缓存模式之间切换——使用 fsync 将易失性缓存刷新到持久性介质，或者同步写入非易失性缓存。

通过“启用”或“禁用”写（易失性）缓存来选择这两种模式。启用易失性缓存时，Linux 使用处于 “ write back” 模式的设备，禁用时，它使用 “ write through ” 模式。

默认配置（通常为启用缓存）可能不是最佳配置，通过禁用写缓存，OSD 性能可能会显著提高 IOPS 并减少提交延迟。

鼓励用户如前所述使用 fio 对其设备进行基准测试，并为其设备保持最佳缓存配置。

可以使用  `hdparm`, `sdparm`, `smartctl` 或通过读取 `/sys/class/scsi_disk/*/cache_type` 中的值来查询缓存配置。例如：

```bash
hdparm -W /dev/sda
/dev/sda:
 write-caching =  1 (on)
====================================================================================
sdparm --get WCE /dev/sda
    /dev/sda: ATA       TOSHIBA MG07ACA1  0101
WCE           1  [cha: y]
==================================================================================== 
smartctl -g wcache /dev/sda
smartctl 7.1 2020-04-05 r5049 [x86_64-linux-4.18.0-305.19.1.el8_4.x86_64] (local build)
Copyright (C) 2002-19, Bruce Allen, Christian Franke, www.smartmontools.org

Write cache is:   Enabled
====================================================================================
cat /sys/class/scsi_disk/0\:0\:0\:0/cache_type
write back
```

使用相同的工具可以关闭写缓存：

```bash
hdparm -W0 /dev/sda
/dev/sda:
 setting drive write-caching to 0 (off)
 write-caching =  0 (off)
=====================================================================================
sdparm --clear WCE /dev/sda
    /dev/sda: ATA       TOSHIBA MG07ACA1  0101
=====================================================================================
smartctl -s wcache,off /dev/sda
smartctl 7.1 2020-04-05 r5049 [x86_64-linux-4.18.0-305.19.1.el8_4.x86_64] (local build)
Copyright (C) 2002-19, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF ENABLE/DISABLE COMMANDS SECTION ===
Write cache disabled
```

通常，使用 `hdparm`, `sdparm` 或 `smartctl` 禁用缓存会导致缓存类型自动更改为 “write through” 。如果情况并非如此，可以尝试按以下方式直接设置它。（用户应注意，保设置 cache_type 也能正确保持设备的缓存模式，直到下次重新启动，因为某些驱动器要求在每次启动时重复此操作）:

```bash
echo "write through" > /sys/class/scsi_disk/0\:0\:0\:0/cache_type

hdparm -W /dev/sda

/dev/sda:
 write-caching =  0 (off)
```

> **Tip**
>
> 此 udev 规则将所有 SATA / SAS 设备 cache_types 设置为“write through”：
>
> ```bash
> # CentOS 8
> cat /etc/udev/rules.d/99-ceph-write-through.rules
> ACTION=="add", SUBSYSTEM=="scsi_disk", ATTR{cache_type}:="write through"
> 
> # CentOS 7
> cat /etc/udev/rules.d/99-ceph-write-through-el7.rules
> ACTION=="add", SUBSYSTEM=="scsi_disk", RUN+="/bin/sh -c 'echo write through > /sys/class/scsi_disk/$kernel/cache_type'"
> ```

> **Tip**
>
> `sdparm` 实用程序可用于一次查看/更改多个设备上的易失性写缓存：
>
> ```bash
> sdparm --get WCE /dev/sd*
>     /dev/sda: ATA       TOSHIBA MG07ACA1  0101
> WCE           0  [cha: y]
>     /dev/sdb: ATA       TOSHIBA MG07ACA1  0101
> WCE           0  [cha: y]
> 
> sdparm --clear WCE /dev/sd*
>     /dev/sda: ATA       TOSHIBA MG07ACA1  0101
>     /dev/sdb: ATA       TOSHIBA MG07ACA1  0101
> ```

### 其他注意事项

通常为每台主机配置多个 OSD，但应该确保 OSD 驱动器的总吞吐量不会超过满足客户端读写数据所需的网络带宽。还应该了解每个主机在群集总容量中所占的百分比。如果特定主机上的百分比很大，并且主机发生故障，则可能会导致问题，例如超过完整比率 `full ratio`，从而导致 Ceph 停止操作，作为防止数据丢失的安全预防措施。

当在每个主机上运行多个 OSD 时，还需要确保内核是最新的。

## 网络

在数据中心内，在 Ceph 主机之间以及客户端与 Ceph 群集之间至少配置 10 Gb/s 网络。强烈建议跨独立网络交换机进行网络链路 active / active 绑定，以提高吞吐量并容忍网络故障和维护。注意绑定哈希策略在链路之间分配流量。

### 速度

通过 1Gb/s 网络复制 1TB 数据需要 3 小时，10TB 则需要 30 小时。相比之下，使用 10Gb/s 网络，复制时间将分别为 20 分钟和 1 小时。

### 成本

群集越大，OSD 故障就越常见。归置组（PG）可以从 `degraded` 状态恢复到 `active + clean` 状态的速度越快越好。fast recovery minimizes the likelihood of multiple, overlapping failures that can cause data to become temporarily unavailable or even lost. 值得注意的是，快速恢复可最大程度地减少多个，重叠失败的可能性，这些失败可能导致数据暂时无法使用，甚至丢失。当然，在配置网络时，必须平衡价格与性能。

一些部署工具采用 VLAN 来使硬件和网络电缆更易于管理。使用 802.1q 协议的 VLAN 需要支持 VLAN 的 NIC 和交换机。增加的硬件费用可能会被网络设置和维护的运营成本节约所抵消。当使用 VLAN 来处理集群和计算堆栈（例如 OpenStack，CloudStack 等）之间的 VM 流量时，使用 10GB/s 以太网或更好的以太网会有额外的价值；截至 2022 年，40Gb/s 或 25 / 50 / 100 Gb/s 的网络对于生产集群来说很常见。

Top-of-rack (TOR) 交换机也需要快速和冗余的上行链路连接到核心/骨干交换机或路由器，通常至少 40 Gb/s 。

### BMC

服务器机箱应该有一个 Baseboard Management Controller（BMC），例如 iDRAC (Dell)、CIMC (Cisco UCS) 和 iLO (HPE) 。管理和部署工具也可能广泛使用 BMC，尤其是通过 IPMI 或 Redfish 。因此，请考虑用于安全和管理的带外网络的成本/收益权衡。

Hypervisor SSH 访问、VM image 上传、操作系统映像安装、管理套接字等都会给网络带来显著的负载。运行多个网络可能看起来有点大材小用，但每个流量路径都代表着潜在的容量、吞吐量和/或性能瓶颈，应该在部署大规模数据集群之前仔细考虑这些问题。

此外，截至 2023 年的 BMC 很少运行速度超过 1 Gb/s 的网络连接，因此用于 BMC 管理流量的专用且廉价的 1 Gb/s 交换机可以通过在更快的主机交换机上浪费更少的昂贵端口来降低成本。

 ![](../../../../Image/ceph_network.png)

## 故障域

故障域可以被认为是阻止访问一个或多个 OSD 或其他 Ceph 守护进程的任何组件丢失。这些可能是主机上已停止的守护程序、存储驱动器故障、OS 崩溃、NIC 故障、电源故障、网络中断、电源中断等等。在规划硬件部署时，必须平衡将过多的责任放在过少的故障域中以降低成本的风险与隔离每个潜在故障域所增加的成本。

## 最低硬件推荐

Ceph 可以在廉价的商用硬件上运行。小型的生产集群和开发集群可以在不太大的硬件上成功运行。如上所述：当我们谈到 CPU core 时，我们指的是 超线程（HT）启用时的 thread 。每个现代物理 x64 CPU 核心通常提供两个逻辑 CPU 线程，其它 CPU 体系结构可以变化。

注意有许多因素会影响资源的选择。满足一个目的的最低限度资源不一定满足另一个目的。will get by with fewer resources than a production deployment with a thousand OSDs serving five thousand of RBD clients.  一个具有单个 OSD 的沙盒集群（sandbox cluster）（使用 VirtualBox 部署在一台笔记本电脑上或三个 Raspberry Pi 上 ）与一个生产部署（具有一千个 OSD ，服务于五千个 RBD 客户端）相比，将得到更少的资源。经典的 Fisher Price PXL 2000 可以捕捉视频，IMAX 或 RED 相机也可以。人们不会指望前者做后者的工作。尤其要强调的是，对于生产工作负载，使用企业级质量的存储介质至关重要。

### ceph-osd
* 处理器
  * 至少 1 core ，建议 2 个。
  * 1 core per 200 - 500 MB/s 吞吐量。
  * 1 core per 1000 - 3000 IOPS 。
  * Results are before replication.结果在复制之前。
  * 结果可能因 CPU 和驱动器型号以及 Ceph 配置而异：（纠删编码、压缩等）
  * ARM 处理器可能需要更多额外的内核来提供性能。
  * SSD OSD，特别是 NVMe，将受益于每个 OSD 的额外核心。
  * 实际性能取决于许多因素，包括驱动器、网络以及客户端吞吐量和延迟。强烈建议进行基准测试。
* 内存
  * 4GB+ per daemon （越多越好）。
  * 2 - 4GB 可能起作用，但可能缓慢。
  * 小于 2GB 不推荐
* 存储驱动器
  * 1x storage drive per daemon
* DB/WAL（可选）
  * 1x SSD partion per HDD OSD 4-5x HDD OSDs per DB/WAL SATA
  * SSD <= 10 HDD OSDss per DB/WAL NVMe SSD
* 网络
  * 1x 1Gb/s ( 建议 bonded 10+ Gb/s)

### ceph-mon
* 处理器
  * 至少 2 core
* 内存
  * 5GB+ per daemon (large / production clusters 需要更多)
* 存储
  * 100 GB per daemon，建议 SSD
* 网络
  * 1x 1Gb/s (建议 10+ Gb/s )

### ceph-mds

* 处理器
  * 至少 2 core
* 内存
  * 2GB+ per daemon (more for production)
* 磁盘空间
  * 1 GB per daemon
* 网络
  * 1x 1Gb/s (建议 10+ Gb/s )


> **Tip：**
>
> 如果运行的 OSD 节点具有单个存储驱动器，请为 OSD 创建一个分区，该分区与包含操作系统的分区分开。建议为操作系统和 OSD 存储使用单独的驱动器。
