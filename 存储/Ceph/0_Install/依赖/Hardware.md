# Hardware

[TOC]

Ceph 被设计为在商品硬件上运行，这使得构建和维护 PB 级数据集群在经济上可行。

在规划集群硬件时，需要均衡考虑几方面的因素，包括故障域和潜在的性能问题。

硬件规划应包括在多台主机上分发 Ceph 守护进程和其他使用 Ceph 的进程。Generally, we recommend running Ceph daemons of a specific type on a host configured for that type of daemon. 通常，建议在为特定类型的守护程序配置的主机上运行特定类型的Ceph守护程序。建议对使用数据集群的进程使用其他主机（例如，OpenStack、CloudStack 等）。

## CPU

MDS 是 CPU 密集型的，应该具有四核（或更好的）CPU 和高时钟速率（ GHz ）。

OSD 应该具有足够的处理能力去运行 RADOS 服务，使用 CRUSH 计算数据放置，复制数据，并维护自己的 cluster map 副本。

在早期版本的 Ceph 中，会根据每个 OSD 的核数来提出硬件建议，但这个每个 cores-per-OSD 指标不再像每个 IOP 的周期数和每个 OSD  IOP 数那样有用。we would make hardware recommendations based on the number of cores per OSD, but this  metric is no longer as useful a metric as the number of cycles per IOP and the number of IOPs per OSD. 例如，对于NVMe 驱动器，Ceph 可以轻松地在实际集群上使用五个或六个内核，在单个 OSD 上单独使用多达十四个内核。因此，每个 OSD 的核心不再像以前那样紧迫。选择硬件时，选择每个核心的 IOP 。Ceph can easily utilize five or six cores on real clusters and up to about fourteen cores on single OSDs in isolation. So cores per OSD are no longer as pressing a concern as they were. When selecting hardware, select for IOPs per core.

MON 节点和 MGR 节点没有大量的 CPU 需求，只需要适度的处理器。如果主机除了 Ceph 守护程序之外，还将运行 CPU 密集型程序，请确保具有足够的处理能力来同时运行 CPU 密集型程序和 Ceph 守护程序。建议在单独的主机上运行非 Ceph CPU 密集型程序（在不是 MON 和 MGR 节点的主机上），以避免资源争夺。

## 内存

对于中等规模的集群，MON / MGR 可以使用 64GB；对于具有数百个 OSD 的较大集群，128GB 是合理的。

There is a memory target for BlueStore OSDs that defaults to 4GB. BlueStore OSD 有一个默认为 4GB 的内存目标。Factor in a prudent margin for the operating system and administrative tasks (like monitoring and metrics) as well as increased consumption during recovery:  provisioning ~8GB per BlueStore OSD is advised.虑到操作系统和管理任务（如监视和度量）以及恢复期间消耗的增加，建议为每个 BlueStore OSD 配置约 8GB 。

### MON / MGR

MON 和 MGR 内存使用通常随集群的大小而扩展。在引导时、拓扑更改和恢复期间，这些守护进程将需要比稳态操作期间更多的 RAM。需计划峰值使用率。对于非常小的集群，32GB 就足够了。对于高达 300 个 OSD 的集群，可以使用 64GB。对于使用更多 OSD 构建的集群（或者将增长到更多 OSD ），应该提供 128GB。可能需要考虑调整以下设置：

* `mon_osd_cache_size`
* `rocksdb_cache_size`

### MDS

MDS 内存利用率取决于其缓存配置为消耗多少内存。对于大多数系统，建议至少1 GB。

* `mds_cache_memory_limit`

### OSD

Bluestore 使用自己的内存来缓存数据，而不是依赖于操作系统的页面缓存。在 Bluestore 中，可使用 `osd_memory_target` 配置选项调整 OSD 尝试使用的内存量。

- 通常不建议将 `osd_memory_target` 设置为 2GB 以下（可能无法保持内存消耗低于 2GB，并且可能会导致极其缓慢的性能）。

- 将内存目标设置在 2 - 4 GB 之间通常是可行的，但可能会导致性能下降，因为在 IO 期间可能会从磁盘读取元数据，除非活动数据集相对较小。

- 4GB 是当前默认 `osd_memory_target` 大小。为典型用例选择了此默认值，旨在平衡内存需求和 OSD 性能。

- 当处理多个（小）对象或大（256 GB / OSD 或更多）数据集时，将 `osd_memory_target` 设置为高于 4GB 可能会提高性能。

> **重要：**
>
> OSD memory autotuning is “best effort”.  OSD 内存自动调整是“最大的努力”。尽管 OSD 可以取消映射内存以允许内核回收内存，但不能保证内核会在特定的时间范围内实际回收释放的内存。这尤其适用于旧版本的 Ceph ，where transparent huge pages can prevent the kernel from reclaiming memory that was freed from fragmented huge pages. Modern versions of Ceph disable transparent huge pages at the application level to avoid this, but that does not guarantee that the kernel will immediately reclaim unmapped memory. The OSD may still at times exceed its memory target. We recommend budgeting approximately 20% extra memory on your system to prevent OSDs from going OOM (**O**ut **O**f **M**emory) during temporary spikes or due to delay in the kernel reclaiming freed pages. That 20% value might be more or less than needed, depending on the exact configuration of the system. 在旧版本中，透明的巨大页面可以阻止内核回收从碎片化的巨大页面中释放的内存。现代版本的 Ceph 在应用程序级别禁用了透明的巨大页面来避免这种情况，但这并不能保证内核会立即回收未映射的内存。OSD有时仍可能超过其存储器目标。我们建议在系统上预算大约20%的额外内存，以防止操作系统在临时峰值期间或由于内核回收释放页面的延迟而出现OOM（内存不足）。根据系统的确切配置，20%的值可能比需要的要多或少。

当使用传统 FileStore 后端时，页面缓存被用于缓存数据，通常不需要进行调优。OSD 内存消耗通常与系统中每个守护进程的 PG 数量有关。

## 数据存储

在规划数据存储时，需要考虑大量的成本和性能权衡。同时进行操作系统操作，以及同时请求多个守护进程对单个驱动器执行读写操作，都会降低性能。

### 硬盘驱动器

操作系统应该有足够的存储驱动器空间来存储对象数据。建议磁盘驱动器最小为 1 TB 。考虑一下较大磁盘的每 GB 成本优势。

不建议在一个 SAS / SATA 驱动器上运行多个 OSD 。但 NVMe 驱动器可以通过拆分成两个以上的 OSD 来提高性能。

不建议在单个驱动器上同时运行 OSD、MON 或 MDS。

随着磁盘的旋转，SATA 和 SAS 接口越来越成为更大容量的瓶颈。

存储驱动器受寻道时间、访问时间、读写时间以及总吞吐量的限制。这些物理限制会影响整个系统性能，尤其是在恢复期间。建议为操作系统和软件使用专用（理想情况下是镜像的）驱动器，为主机上运行的每个 OSD 使用一个驱动器（modulo NVMe above，上面的NVMe 模块）。在同一驱动器上运行一个操作系统和多个 OSD 会导致许多 “ slow OSD” 问题（当这些问题不是由硬件故障引起的）。

从技术上讲，可以在每个 SAS / SATA 驱动器运行多个 OSD 守护程序，但这可能会导致资源争夺并减少整体吞吐量。

要获得 Ceph 的最佳性能，请在单独的驱动器上运行以下内容：

* 操作系统
* OSD 数据
* BlueStore db

### 固态硬盘

使用固态驱动器（SSD）可以提高 Ceph 性能。这减少了随机访问时间，减少了延迟的同时加快了吞吐量。

SSD 的每 GB 成本高于硬盘驱动器，但 SSD 通常提供的访问时间至少比硬盘驱动器快100倍。SSD 避免了繁忙集群中的热点问题和瓶颈问题，当对TCO 进行整体评估时，它们可能会提供更好的经济性。

SSD 没有可移动的机械部件，因此它们不一定受到与硬盘驱动器相同类型的限制。不过，固态硬盘确实有很大的局限性。在评估 SSD 时，重要的是要考虑顺序读写的性能。

> **Important**
>
> 建议尝试使用 SSD 来提高性能。但是，在对 SSD 进行重大投资之前，强烈建议检查 SSD 的性能指标，并在测试配置中测试 SSD ，以评估性能。
>

相对便宜的 SSD ，请谨慎使用。在选择用于 Ceph 的 SSD 时，可接受的 IOPS 并不是唯一需要考虑的因素。

SSD 在对象存储方面历来成本高昂，但新兴的 QLC 驱动器正在缩小差距，提供更高的密度、更低的功耗和更少的冷却功耗。通过将 WAL + DB 卸载到 SSD 上，HDD OSD 可能会显著提高性能。

### 分区对齐

将 SSD 与 Ceph 一起使用时，请确保分区正确对齐。未正确对齐的分区的数据传输速度比正确对齐的分区慢。

### CephFS Metadata 隔离

加速 CephFS 文件系统性能的一种方法是将 CephFS 元数据的存储与 CephFS 文件内容的存储分开。Ceph 为 CephFS 元数据提供默认 `metadata` 池。不必为 CephFS 元数据创建池，但可以为 CephFS 元数据池创建仅指向 SSD 存储介质的 CRUSH map 层次结构。

### 控制器

磁盘控制器（HBA）会对写入吞吐量产生重大影响。 仔细考虑您的选择，以确保它们不会造成性能瓶颈。值得注意的是，RAID 模式（IR）HBA 可能比简单的 “JBOD”（IT）模式 HBA 表现出更高的延迟。并且 RAID SoC、写缓存和电池备份可能会大幅增加硬件和维护成本。一些 RAID HBA 可以使用 IT 模式“个性”配置。

### 基准测试

BlueStore 在 O_DIRECT 中打开块设备，并频繁使用 fsync 来确保数据安全地持久化到介质。可以使用 fio 评估驱动器的低级别写入性能。例如，4kB 随机写入性能的测量如下：

```bash
fio --name=/dev/sdX --ioengine=libaio --direct=1 --fsync=1 --readwrite=randwrite --blocksize=4k --runtime=300
```

### 写缓存

企业级 SSD 和 HDD 通常包括断电保护功能，这些功能使用多级缓存来加速直接或同步写入。这些设备可以在两种缓存模式之间切换，一种是使用 fsync 刷新到持久介质的易失性缓存，另一种是同步写入的非易失性缓存。

通过“启用”或“禁用”写（易失性）缓存来选择这两种模式。启用易失性缓存时，Linux 使用处于 “ write back” 模式的设备，禁用时，它使用 “ write through ” 。

默认配置（通常启用缓存）可能不是最佳配置，通过禁用写缓存，OSD 性能可能会显著提高 IOPS 并减少提交延迟。

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

通常，使用 `hdparm`, `sdparm` 或 `smartctl` 禁用缓存会导致缓存类型自动更改为 “write through” 。如果情况并非如此，您可以尝试按以下方式直接设置它。（用户应注意，设置 cache_type 也会正确地保持设备的缓存模式，直到下次重新启动）:

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

通常，会在每台主机上运行多个 OSD，但应该确保 OSD 驱动器的总吞吐量不会超过满足客户端读写数据所需的网络带宽。还应该考虑集群在每个主机上存储的总数据的百分比。如果特定主机上的百分比很大，并且主机发生故障，则可能会导致问题，例如超过完整比率 `full ratio`，从而导致 Ceph 停止操作，作为防止数据丢失的安全预防措施。

当在每个主机上运行多个 OSD 时，还需要确保内核是最新的。

## 网络

在机架中提供至少 10Gb/s 以上的网络。

### 速度

通过 1Gb/s 网络复制 1TB 数据需要 3 小时，10TB 则需要 30 小时。相比之下，使用 10Gb/s 网络，复制时间将分别为 20 分钟和 1 小时。

### 成本

群集越大，OSD 失败就会越常见。归置组（PG）可以从 `degraded` 状态恢复到 `active + clean` 状态的速度越快越好。Notably, fast recovery minimizes the likelihood of multiple, overlapping failures that can cause data to become temporarily unavailable or even lost. 值得注意的是，快速恢复可最大程度地减少多个，重叠失败的可能性，这些失败可能导致数据暂时无法使用甚至丢失。当然，在配置网络时，必须平衡价格与性能。

一些部署工具采用 VLAN 来使硬件和网络电缆更易于管理。使用 802.1q 协议的 VLAN 需要支持 VLAN 的 NIC 和交换机。增加的硬件费用可能会被网络设置和维护的运营成本节约所抵消。当使用 VLAN 来处理集群和计算堆栈（例如 OpenStack，CloudStack 等）之间的 VM 流量时，使用 10GB/s 以太网或更好的以太网会有额外的价值；截至 2022 年，40Gb/s 或 25 / 50 / 100 Gb/s 的网络对于生产集群来说很常见。

Top-of-rack (TOR) 交换机也需要快速和冗余的上行链路连接到骨干交换机 / 路由器，通常至少 40 Gb/s 。

### BMC

服务器机箱应该有一个 Baseboard Management Controller（BMC），例如 iDRAC (Dell)、CIMC (Cisco UCS) 和 iLO (HPE) 。管理和部署工具也可能广泛使用 BMC，尤其是通过 IPMI 或 Redfish 。因此，请考虑用于安全和管理的带外网络的成本/收益权衡。

Hypervisor  SSH 访问、VM image 上传、操作系统映像安装、管理套接字等都会给网络带来巨大的负载。运行三个网络似乎有些过分，但每个流量路径都代表着一个潜在的容量、吞吐量和/或性能瓶颈，在部署大规模数据集群之前，应该仔细考虑这些瓶颈。

 ![](../../../../Image/ceph_network.png)

## 故障域

故障域是阻止访问一个或多个 OSD 的任何故障。这可能是主机上已停止的守护进程；硬盘故障、操作系统崩溃、NIC 故障、电源故障、网络中断、电源中断等等。balance the temptation to reduce costs by placing too many responsibilities into too few failure domains, and the added costs of isolating every potential failure domain.在规划硬件需求时，必须平衡将太多的责任放在太少的故障域中以降低成本的诱惑，以及隔离每个潜在故障域所增加的额外成本。

## 最低硬件推荐

Ceph 可以在廉价的商用硬件上运行。小型的生产集群和开发集群可以使用适当的硬件成功运行。

### ceph-osd
* Processor
  * 1 core minimum
  * 1 core per 200-500 MB/s
  * 1 core per 1000-3000 IOPS
  * Results are before replication.结果在复制之前。
  * 结果可能因不同的 CPU 型号和 Ceph 功能而异。（擦除编码、压缩等）
  * ARM processors specifically may require additional cores.ARM处理器可能需要额外的内核。
  * 实际性能取决于许多因素，包括驱动器、网络、客户端吞吐量和延迟。强烈建议进行基准测试。
* RAM
  * 4GB+ per daemon (more is better)
  * 2-4GB often functions (may be slow)
  * 小于 2GB 不推荐
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


> **Tip：**
>
> 如果使用单个磁盘运行 OSD ，请为卷存储创建一个独立于包含 OS 分区的分区。通常，我们建议操作系统和卷存储使用单独的磁盘。

