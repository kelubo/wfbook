# MGR

[TOC]

## 概述

在引导过程中，`cephadm` 会在 bootstrap 节点上自动安装管理器守护进程。可使用 Ceph 编配器部署额外的管理器守护进程。

Ceph 编配器默认部署两个管理器守护进程。要部署不同数量的管理器守护进程，请指定不同的数字。如果您不指定应当部署管理器守护进程的主机，Ceph 编配器会随机选择主机，并将管理器守护进程部署到主机上。

管理节点同时包含集群配置文件和 admin 密钥环。这两个文件都存储在 `/etc/ceph` 目录中，并使用存储集群的名称作为前缀。

例如，默认的 ceph 集群名称是 `ceph`。在使用默认名称的集群中，管理员密钥环名为 `/etc/ceph/ceph.client.admin.keyring`。对应的集群配置文件命名为 `/etc/ceph/ceph.conf`。  	

## 通过标签增加节点

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

3. 验证 admin 主机具有 _admin 标签。

   ```bash
   ceph orch host ls
   HOST   ADDR   LABELS  STATUS
   host01         mon
   host02         mon,mgr,_admin
   host03
   host04
   host05
   ```

4. 登录 admin 节点，以管理存储集群。

## 通过命令添加节点

**注意：**如果要将管理器守护进程应用到多个特定的主机，请务必在同一 `ceph orch apply` 命令中指定所有主机名。如果您指定了 `ceph orch apply mgr --placement host1`，然后指定了 `ceph orch apply mgr --placement host2`，第二个命令将删除 host1 上的 Manager 守护进程，并将管理器守护进程应用到 host2。

**流程**

1. 指定要将一定数量的 Manager 守护进程应用到随机选择的主机：

   ```bash
ceph orch apply mgr NUMBER-OF-DAEMONS
   ```

2. 将 Manager 守护进程添加到存储集群中的特定主机上：

   ```bash
   ceph orch apply mgr --placement "HOSTNAME1 HOSTNAME2 HOSTNAME3 "
   ```
