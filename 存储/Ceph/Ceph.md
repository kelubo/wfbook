# Ceph

[TOC]

## Ceph架构
**Rados**  
核心组件，提供高可靠、高可扩展、高性能的分布式对象存储架构，利用本地文件系统存储对象。 

**Client**  
RBD  
Radosgw  
Librados  
Cephfs  

![](../../Image/ceph.png)

## Ceph组件
最简的 Ceph 存储集群至少要一个 MON 和两个 OSD 守护进程，只有运行 Ceph 文件系统时, MDS 服务器才是必需的。  

**OSD(对象存储守护进程)**  

存储数据，处理数据复制、恢复、回填、重均衡，并通过检查其他OSD 守护进程的心跳来向 Ceph Monitors 提供一些监控信息。通常一个OSD守护进程会被捆绑到集群中的一块物理磁盘上。

当 Ceph 存储集群设定为有2个副本时，至少需要2个 OSD 守护进程，集群才能达到 `active+clean` 状态。

![](../../Image/ceph-topo.jpg)

**MON(Monitor)**  

维护着各种集群状态图，包括MON map、OSD map、PG map 和CRUSH map。所有集群节点都向MON节点汇报状态信息，并分享它们状态中的任何变化。Ceph 保存着发生在Monitors 、 OSD 和 PG上的每一次状态变更的历史信息（称为 epoch ）。

**MDS(元数据服务器)**  

为CephFS文件系统跟踪文件的层次结构和存储元数据。缓存和同步元数据，管理名字空间。不直接提供数据给客户端。使得 POSIX 文件系统的用户们，可以在不对 Ceph 存储集群造成负担的前提下，执行诸如 `ls`、`find` 等基本命令。

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

`cephadm`用于“裸机”部署.

`Rook`用于在`Kubernetes`环境中运行`Ceph`，并为这两个平台提供类似的管理体验。