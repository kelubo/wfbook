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

## 均衡器模块

平衡器是 Ceph 管理器(`ceph-mgr`)的模块，可优化 PG 在 OSD 之间的放置，从而实现自动或稳定的方式分发。 		

目前无法禁用 balancer 模块。它只能关闭来自定义配置。			

**流程**

1. 确保启用了 balancer 模块：

   ```bash
   ceph mgr module enable balancer
   ```

2. 打开 balancer 模块：

   ```bash
   ceph balancer on
   ```

3. 默认模式为 `crush-compat`。该模式可使用以下方法更改：

   ```bash
   ceph balancer mode upmap
   ceph balancer mode crush-compat
   ```

**状态**

可以随时使用以下方法检查该均衡程序的当前状态

```bash
ceph balancer status
```

**自动平衡**

默认情况下，当打开 balancer 模块时，会使用自动平衡：

```bash
ceph balancer on
```

可使用以下方法再次关闭该平衡：

```bash
ceph balancer off
```

这将使用 `crush-compat` 模式，它向后兼容较旧的客户端，并将随着时间推移对数据分发进行少量更改，以确保 OSD 得到平等利用。 		

**节流**

如果集群降级，例如 OSD 出现故障并且系统尚未修复自身，则不会对 PG 分发进行调整。 			

当集群处于健康状态时，负载平衡器会限制其变化，使得被不当或需要移动的 PG 百分比默认低于 5% 的阈值。可以使用 `target_max_misplaced 设置` 调整这个百分比。例如，将阈值增加到 7%：

```bash
ceph config-key set mgr/balancer/target_max_misplaced .07
```

**强制优化**

平衡器操作分为几个不同的阶段： 			

1. 构建 `计划`. 				

2. 评估当前 PG 分布的数据分发质量，或评估 `执行计划` 后生成的 PG 分发。 				

3. `执行计划`. 				

   - 评估并评分当前发行版：

     ```bash
     ceph balancer eval
     ```

   - 评估单个池的分布：

     ```bash
     ceph balancer eval POOL_NAME
     
     ceph balancer eval rbd
     ```

   - 查看更多评估详情：

     ```bash
     ceph balancer eval-verbose ...
     ```

   - 使用当前配置的模式生成计划：

     ```bash
     ceph balancer optimize PLAN_NAME
     # 将 PLAN_NAME 替换为自定义计划名称。
     
     ceph balancer optimize rbd_123
     ```

   - 查看计划的内容：

     ```bash
     ceph balancer show PLAN_NAME
     
     ceph balancer show rbd_123
     ```

   - 丢弃旧计划：

     ```bash
     ceph balancer rm PLAN_NAME
     
     ceph balancer rm rbd_123
     ```

   - 要查看当前记录的计划，请使用 status 命令： 						

     ```bash
     ceph balancer status
     ```

   - 要计算执行计划后产生的分布质量：

     ```bash
     ceph balancer eval PLAN_NAME
     
     ceph balancer eval rbd_123
     ```

   - 执行计划：		

     ```bash
     ceph balancer execute PLAN_NAME
     
     ceph balancer execute rbd_123
     ```

     **注意:**仅当 预期改进分布时，才会执行计划。执行后，计划将被丢弃。