# Ceph
## Ceph架构
**Rados**  
核心组件，提供高可靠、高可扩展、高性能的分布式对象存储架构，利用本地文件系统存储对象。 
 
**Client**  
RBD  
Radosgw  
Librados  
Cephfs  

![](../Image/ceph.png)

## Ceph组件
**OSD**  
存储文件数据和元数据  
![](../Image/ceph-topo.jpg)

**Monitor**  
监视整个集群状态，维护集群Map。  
**MDS**  
缓存和同步元数据，管理名字空间。
## Ceph网络

![](../Image/ceph_network.png)

## 数据流向
Data-->obj-->PG-->Pool-->OSD

![](../Image/Distributed-Object-Store.png)

## 数据复制

![](../Image/ceph_write.png)

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