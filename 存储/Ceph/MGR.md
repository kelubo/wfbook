# MGR

[TOC]

## 概述		

管理节点同时包含集群配置文件和 admin 密钥环。这两个文件都存储在 `/etc/ceph` 目录中，并使用存储集群的名称作为前缀。

例如，默认的 ceph 集群名称是 `ceph`。在使用默认名称的集群中，管理员密钥环名为 `/etc/ceph/ceph.client.admin.keyring`。对应的集群配置文件命名为 `/etc/ceph/ceph.conf`。 		

## 增加节点

要将存储集群中的主机设置为管理节点，请将 _admin 标签应用到要指定为管理节点的主机。

**注意：**

在应用 _admin 标签后，确保将 `ceph.conf` 文件和 admin 密钥环复制到 admin 节点。

1. 使用 `ceph orch host ls` 查看您的存储集群中的主机：

   ```bash
   ceph orch host ls
   HOST   ADDR   LABELS  STATUS
   host01         mon
   host02         mon,mgr
   host03
   host04
   host05
   ```

   

2. 使用 `_admin` 标签指定存储集群中的 admin 主机。为获得最佳结果，此主机应同时运行 monitor 和 Manager 守护进程。

   ```bash
   ceph orch host label add HOSTNAME _admin
   ```

   

3. ​						验证 admin 主机具有 _admin 标签。 				

   **示例**

   ​							

   ```none
   [cephadm@cephadm /]# ceph orch host ls
   HOST   ADDR   LABELS  STATUS
   host01         mon
   host02         mon,mgr,_admin
   host03
   host04
   host05
   ```

   

4. ​						登录 admin 节点，以管理存储集群。 				





# 通过 IP 地址或网络名称添加 Ceph 监控节点

​					典型的 Red Hat Ceph Storage 集群在不同主机上部署了三个或五个 monitor 守护进程。如果您的存储集群有五个或更多主机，红帽建议您部署五个 monitor 节点。 			

​					如果您的 monitor 节点或整个集群都位于单个子网中，则 `cephadm` 会在向集群添加新节点时自动添加最多五个 monitor 守护进程。您不需要在新节点上配置 monitor 守护进程。新节点与存储集群中的第一个节点位于同一个子网中。存储集群中的第一个节点是 bootstrap 节点。`cephadm` 还可以部署和缩放 monitor，以响应存储集群大小的变化。 			

**先决条件**

- ​							对存储集群中所有节点的根级别访问权限。 					
- ​							正在运行的存储群集。 					

**流程**

1. ​							部署每个额外的 Ceph 监控节点： 					

   **语法**

   ​								

   ```none
   ceph orch apply mon NODE:IP-ADDRESS-OR-NETWORK-NAME [NODE:IP-ADDRESS-OR-NETWORK-NAME...]
   ```

   

   **示例**

   ​								

   ```none
   [ceph: root@node00 ~]# ceph orch apply mon node01:10.1.2.0 node02:mynetwork
   ```

# 添加管理器服务

​				在引导过程中，`cephadm` 会在 bootstrap 节点上自动安装管理器守护进程。使用 Ceph 编配器部署额外的管理器守护进程。 		

​				Ceph 编配器默认部署两个管理器守护进程。要部署不同数量的管理器守护进程，请指定不同的数字。如果您不指定应当部署管理器守护进程的主机，Ceph 编配器会随机选择主机，并将管理器守护进程部署到主机上。 		

注意

​					如果要将管理器守护进程应用到多个特定的主机，请务必在同一 `ceph orch apply` 命令中指定所有主机名。如果您指定了 `ceph orch apply mgr --placement host1`，然后指定了 `ceph orch apply mgr --placement host2`，第二个命令将删除 host1 上的 Manager 守护进程，并将管理器守护进程应用到 host2。 			

​				红帽建议您使用 `--placement` 选项来部署到特定主机。 		

**先决条件**

- ​						正在运行的存储群集。 				

**流程**

1. ​						指定您要将一定数量的 Manager 守护进程应用到随机选择的主机： 				

   **语法**

   ​							

   ```none
   ceph orch apply mgr NUMBER-OF-DAEMONS
   ```

   

   **示例**

   ​							

   ```none
   [ceph: root@node01 ~]# ceph orch apply mgr 3
   ```

   

   - ​								将 Manager 守护进程添加到存储集群中的特定主机上： 						

     **语法**

     ​									

     ```none
     ceph orch apply mgr --placement "HOSTNAME1 HOSTNAME2 HOSTNAME3 "
     ```

     

     **示例**

     ​									

     ```none
     [ceph: root@node01 /]# ceph orch apply mgr --placement "node01 node02 node03"
     ```