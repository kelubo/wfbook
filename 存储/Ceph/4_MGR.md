# MGR

[TOC]

## 概述

cephadm MGR 服务托管多个模块，如 Ceph Dashboard 和 cephadm manager 模块。

在引导过程中，`cephadm` 会在 bootstrap 节点上自动安装 MGR 。可使用编排器部署额外的 MGR 。

Ceph 编配器默认部署两个管理器守护进程。要部署不同数量的管理器守护进程，请指定不同的数字。如果您不指定应当部署管理器守护进程的主机，Ceph 编配器会随机选择主机，并将管理器守护进程部署到主机上。

管理节点同时包含集群配置文件和 admin 密钥环。这两个文件都存储在 `/etc/ceph` 目录中，并使用存储集群的名称作为前缀。

例如，默认的 ceph 集群名称是 `ceph`。在使用默认名称的集群中，管理员密钥环名为 `/etc/ceph/ceph.client.admin.keyring`。对应的集群配置文件命名为 `/etc/ceph/ceph.conf`。  	

## 指定网络

MGR 仅支持绑定到网络内的特定 IP 。

示例规范文件 (leveraging a default placement):

```yaml
service_type: mgr
networks:
- 192.169.142.0/24
```

## 允许 MGR 守护进程的共存

在只有一台主机的部署场景中，cephadm 仍然需要部署至少两个 MGR ，以允许集群的自动升级。

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

## crash 模块

通过使用 Ceph 管理器 crash 模块，您可以收集有关守护进程 crashdump 的信息，并将它存储在红帽 Ceph 存储集群中，以进行进一步分析。 		

默认情况下，守护进程 crashdump 在 `/var/lib/ceph/crash` 中被转储。您可以使用 选项配置 `crash dir`。崩溃目录按时间、日期和随机生成的 UUID 命名，包含元数据文件 `meta` 和最新的日志文件，其 `crash_id` 是相同的。 		

您可以使用 `ceph-crash.service` 自动提交这些崩溃并在 Ceph 监控中保留。`ceph-crash.service` 会监视 crashdump 目录，并使用 `ceph crash post` 上传它们。 		

*RECENT_CRASH* Heath 消息是 Ceph 集群中最常见的健康消息之一。此健康消息表示一个或多个 Ceph 守护进程最近崩溃，并且该崩溃尚未被管理员存档或确认。这可能表示软件错误、硬件问题（如磁盘失败）或其他一些问题。选项 `mgr/crash/warn_recent_interval` 控制最近表示的时间周期，默认为两周。您可以运行以下命令禁用警告：

```bash
ceph config set mgr/crash/warn_recent_interval 0
```

选项 `mgr/crash/retain_interval` 控制在自动清除崩溃报告前要保留崩溃报告的时间段。这个选项的默认值为一年。 				

**流程**

1. 确保启用了 crash 模块：

   ```bash
   ceph mgr module ls | more
   
   {
       "always_on_modules": [
           "balancer",
           "crash",
           "devicehealth",
           "orchestrator_cli",
           "progress",
           "rbd_support",
           "status",
           "volumes"
       ],
       "enabled_modules": [
           "dashboard",
           "pg_autoscaler",
           "prometheus"
       ]
   ```

2. 保存崩溃转储：元数据文件是存储在 crash dir 中的 JSON blob，存为 `meta`。您可以调用 ceph 命令 `-i -` 选项，它从 stdin 中读取。

   ```bash
   ceph crash post -i meta
   ```

3. 列出所有新的和归档的崩溃信息的时间戳或 UUID 崩溃 ID：

   ```bash
   ceph crash ls
   ```

4. 列出所有新崩溃信息的时间戳或 UUID 崩溃 ID：

   ```bash
   ceph crash ls-new
   ```

5. 列出所有新崩溃信息的时间戳或 UUID 崩溃 ID：

   ```bash
   ceph crash ls-new
   ```

6. 列出按年龄分组的已保存崩溃信息的摘要：

   ```bash
   ceph crash stat
   
   8 crashes recorded
   8 older than 1 days old:
   2021-05-20T08:30:14.533316Z_4ea88673-8db6-4959-a8c6-0eea22d305c2
   2021-05-20T08:30:14.590789Z_30a8bb92-2147-4e0f-a58b-a12c2c73d4f5
   2021-05-20T08:34:42.278648Z_6a91a778-bce6-4ef3-a3fb-84c4276c8297
   2021-05-20T08:34:42.801268Z_e5f25c74-c381-46b1-bee3-63d891f9fc2d
   2021-05-20T08:34:42.803141Z_96adfc59-be3a-4a38-9981-e71ad3d55e47
   2021-05-20T08:34:42.830416Z_e45ed474-550c-44b3-b9bb-283e3f4cc1fe
   2021-05-24T19:58:42.549073Z_b2382865-ea89-4be2-b46f-9a59af7b7a2d
   2021-05-24T19:58:44.315282Z_1847afbc-f8a9-45da-94e8-5aef0738954e
   ```

7. 查看保存的崩溃详情：

   ```none
   ceph crash info CRASH_ID
   ```

   ```bash
   ceph crash info 2021-05-24T19:58:42.549073Z_b2382865-ea89-4be2-b46f-9a59af7b7a2d
   
   {
       "assert_condition": "session_map.sessions.empty()",
       "assert_file": "/builddir/build/BUILD/ceph-16.1.0-486-g324d7073/src/mon/Monitor.cc",
       "assert_func": "virtual Monitor::~Monitor()",
       "assert_line": 287,
       "assert_msg": "/builddir/build/BUILD/ceph-16.1.0-486-g324d7073/src/mon/Monitor.cc: In function 'virtual Monitor::~Monitor()' thread 7f67a1aeb700 time 2021-05-24T19:58:42.545485+0000\n/builddir/build/BUILD/ceph-16.1.0-486-g324d7073/src/mon/Monitor.cc: 287: FAILED ceph_assert(session_map.sessions.empty())\n",
       "assert_thread_name": "ceph-mon",
       "backtrace": [
           "/lib64/libpthread.so.0(+0x12b30) [0x7f679678bb30]",
           "gsignal()",
           "abort()",
           "(ceph::__ceph_assert_fail(char const*, char const*, int, char const*)+0x1a9) [0x7f6798c8d37b]",
           "/usr/lib64/ceph/libceph-common.so.2(+0x276544) [0x7f6798c8d544]",
           "(Monitor::~Monitor()+0xe30) [0x561152ed3c80]",
           "(Monitor::~Monitor()+0xd) [0x561152ed3cdd]",
           "main()",
           "__libc_start_main()",
           "_start()"
       ],
       "ceph_version": "16.1.0-486.el8cp",
       "crash_id": "2021-05-24T19:58:42.549073Z_b2382865-ea89-4be2-b46f-9a59af7b7a2d",
       "entity_name": "mon.ceph-adm4",
       "os_id": "rhel",
       "os_name": "Red Hat Enterprise Linux",
       "os_version": "8.3 (Ootpa)",
       "os_version_id": "8.3",
       "process_name": "ceph-mon",
       "stack_sig": "957c21d558d0cba4cee9e8aaf9227b3b1b09738b8a4d2c9f4dc26d9233b0d511",
       "timestamp": "2021-05-24T19:58:42.549073Z",
       "utsname_hostname": "host02",
       "utsname_machine": "x86_64",
       "utsname_release": "4.18.0-240.15.1.el8_3.x86_64",
       "utsname_sysname": "Linux",
       "utsname_version": "#1 SMP Wed Feb 3 03:12:15 EST 2021"
   }
   ```

8. 删除超过 *KEEP* 天的已保存崩溃：这里，*KEEP* 必须是整数。

   ```bash
   ceph crash prune KEEP
   
   ceph crash prune 60
   ```

9. 归档崩溃报告，以便不再考虑 `RECENT_CRASH` 健康检查，不会出现在 `崩溃 ls-new` 输出中。它会出现在 `崩溃 ls 中`。 

   ```bash
   ceph crash archive CRASH_ID
   
   ceph crash archive 2021-05-24T19:58:42.549073Z_b2382865-ea89-4be2-b46f-9a59af7b7a2d
   ```

10. 归档所有崩溃报告	

    ```bash
    ceph crash archive-all
    ```

11. 删除崩溃转储：

    ```bash
    ceph crash rm CRASH_ID
    
    ceph crash rm 2021-05-24T19:58:42.549073Z_b2382865-ea89-4be2-b46f-9a59af7b7a2d
    ```