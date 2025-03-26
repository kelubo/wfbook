# Cephadm 操作

[TOC]

## 查看 CEPHADM 日志消息

Cephadm 将日志写入 Cephadm 集群日志通道。可以通过读取日志来实时监控 Ceph 的活动。运行以下命令以实时查看日志：

```bash
ceph -W cephadm
```

默认情况下，此命令显示信息级别及以上的事件。要查看调试级消息以及信息级事件，请运行以下命令：

```bash
ceph config set mgr mgr/cephadm/log_to_cluster_level debug
ceph -W cephadm --watch-debug
```

> **Warning:**
>
> 调试消息非常冗长！

通过运行以下命令可以查看最近的事件：

```bash
ceph log last cephadm
```

These events are also logged to the `ceph.cephadm.log` file on monitor hosts as well as to the monitor daemons’ stderr.

这些事件也会记录到 MON 主机上 `ceph.cephadm.log` 文件中。以及监视器守护程序的stderr。

## Ceph daemon 日志

### 记录到 journald

Ceph 守护进程通常将日志写入 `/var/log/Ceph` 。默认情况下，Ceph 守护进程将日志记录到 journald ，Ceph 日志由容器 runtime 环境捕获。它们可以通过 `journalctl` 访问。

> **Note：**
>
> Prior to Quincy, ceph daemons logged to stderr.
>
> 在Quincy之前，ceph守护进程已登录到stderr。

例如，要查看 ID 为 `5c5a50ae-272a-455d-99e9-32c6a013e694` 的集群中 `mon.foo` 守护程序的日志，命令如下：

```bash
journalctl -u ceph-5c5a50ae-272a-455d-99e9-32c6a013e694@mon.foo
```

当日志级别较低时，这对于正常操作非常有效。

### 记录到文件

You can also configure Ceph daemons to log to files instead of to journald if you prefer logs to appear in files (as they did in earlier, pre-cephadm, pre-Octopus versions of Ceph).  When Ceph logs to files, the logs appear in `/var/log/ceph/<cluster-fsid>`. If you choose to configure Ceph to log to files instead of to journald, remember to configure Ceph so that it will not log to journald (the commands for this are covered below).

如果您希望日志显示在文件中，您也可以将Ceph守护进程配置为记录到文件而不是日志（正如Ceph的早期、cephadm之前、Octopus之前版本中所做的那样）。当Ceph记录到文件时，日志显示在/var/log/Ceph/中。如果您选择将Ceph配置为记录到文件而不是日志，请记住配置Ceph，使其不会记录到日志（下面将介绍此命令）。

#### 启用文件日志记录

要启用文件日志记录，请运行以下命令：

```bash
ceph config set global log_to_file true
ceph config set global mon_cluster_log_to_file true
```

#### Disabling logging to journald

If you choose to log to files, we recommend disabling logging to journald or else everything will be logged twice. Run the following commands to disable logging to stderr:

```
ceph config set global log_to_stderr false
ceph config set global mon_cluster_log_to_stderr false
ceph config set global log_to_journald false
ceph config set global mon_cluster_log_to_journald false
```

Note

You can change the default by passing –log-to-file during bootstrapping a new cluster.

禁用日志记录

如果您选择登录到文件，我们建议禁用日志记录，否则所有内容都将被记录两次。运行以下命令以禁用stderr日志记录：

ceph配置将全局日志设置为日志错误

ceph-config将全局mon集群日志设置为日志错误

笔记

您可以通过在引导新集群期间将--log传递到file来更改默认值。

修改日志保留计划

默认情况下，cephadm在每个主机上设置日志旋转，以旋转这些文件。您可以通过修改/etc/logrotate.d/ceph.来配置日志记录保留计划。

#### Modifying the log retention schedule

By default, cephadm sets up log rotation on each host to rotate these files.  You can configure the logging retention schedule by modifying `/etc/logrotate.d/ceph.<cluster-fsid>`.

## Ceph daemon 控制

### 启动和停止守护进程

可以使用以下命令停止、启动或重新启动守护程序：

```bash
ceph orch daemon stop <name>
ceph orch daemon start <name>
ceph orch daemon restart <name>
```

还可以对服务的所有守护程序执行相同的操作，方法如下：

```bash
ceph orch stop <name>
ceph orch start <name>
ceph orch restart <name>
```

### 重新部署或重新配置守护程序

可以使用 `redeploy` 命令停止、重新创建和重新启动守护程序的容器：

```bash
ceph orch daemon redeploy <name> [--image <image>]
```

可以选择提供容器映像名称以强制使用特定映像（而不是 `container_image` 配置值指定的映像）。

如果只需要重新生成 ceph 配置，还可以发出一个 `reconfig` 命令，它将重写 `ceph.conf` 文件，但不会触发守护进程的重新启动。

```bash
ceph orch daemon reconfig <name>
```

### Rotating a daemon’s authenticate key旋转守护程序的身份验证密钥

集群中的所有 Ceph 和网关守护进程都有一个密钥，用于连接到集群并进行身份验证。This key can be rotated可以使用以下命令旋转该键（即，替换为新键）：

```bash
ceph orch daemon rotate-key <name>
```

对于 MDS、OSD 和 MGR 守护程序，这不需要重新启动守护程序。然而，对于其他守护程序（例如 RGW ），可以重新启动守护程序以切换到新密钥。

## Data location

Cephadm 将守护程序数据和日志存储在不同的位置，pre-cephadm (pre Octopus) versions of ceph:与 ceph 的早期Cephadm（前Octopus）版本不同：

- `/var/log/ceph/<cluster-fsid>` 包含所有集群日志。默认情况下，cephadm logs via stderr and the container runtime. These logs will not exist unless you have enabled logging to files as described in [cephadm-logs](https://docs.ceph.com/en/latest/cephadm/operations/#cephadm-logs).cephadm通过stderr和容器运行时进行日志记录。除非您启用了cephadm日志中所述的文件日志记录，否则这些日志将不存在。
- `/var/lib/ceph/<cluster-fsid>` contains all cluster daemon data (besides logs).包含所有集群守护程序数据（除了日志）。
- `/var/lib/ceph/<cluster-fsid>/<daemon-name>` contains all data for an individual daemon.包含单个守护程序的所有数据。
- `/var/lib/ceph/<cluster-fsid>/crash` contains crash reports for the cluster.包含集群的崩溃报告。
- `/var/lib/ceph/<cluster-fsid>/removed` contains old daemon data directories for stateful daemons (e.g., monitor, prometheus) that have been removed by cephadm.包含已被cephadm删除的有状态守护程序（例如，monitor、prometheus）的旧守护程序数据目录。

### 磁盘空间使用

Because a few Ceph daemons (notably, the monitors and prometheus) store a large amount of data in `/var/lib/ceph` , we recommend moving this directory to its own disk, partition, or logical volume so that it does not fill up the root file system.

由于一些Ceph守护程序（特别是监视器和prometheus）在/var/lib/Ceph中存储了大量数据，我们建议将此目录移动到其自己的磁盘、分区或逻辑卷中，这样它就不会填满根文件系统。

## Health checks

The cephadm module provides additional health checks to supplement the default health checks provided by the Cluster. These additional health checks fall into two categories:

- **cephadm operations**: Health checks in this category are always executed when the cephadm module is active.
- **cluster configuration**: These health checks are *optional*, and focus on the configuration of the hosts in the cluster.

### CEPHADM Operations

#### CEPHADM_PAUSED

This indicates that cephadm background work has been paused with `ceph orch pause`.  Cephadm continues to perform passive monitoring activities (like checking host and daemon status), but it will not make any changes (like deploying or removing daemons).

Resume cephadm work by running the following command:

```
ceph orch resume
```



#### CEPHADM_STRAY_HOST

This indicates that one or more hosts have Ceph daemons that are running, but are not registered as hosts managed by *cephadm*.  This means that those services cannot currently be managed by cephadm (e.g., restarted, upgraded, included in ceph orch ps).

- You can manage the host(s) by running the following command:

  ```
  ceph orch host add *<hostname>*
  ```

  Note

  You might need to configure SSH access to the remote host before this will work.

- See [Fully qualified domain names vs bare host names](https://docs.ceph.com/en/latest/cephadm/host-management/#cephadm-fqdn) for more information about host names and domain names.

- Alternatively, you can manually connect to the host and ensure that services on that host are removed or migrated to a host that is managed by *cephadm*.

- This warning can be disabled entirely by running the following command:

  ```
  ceph config set mgr mgr/cephadm/warn_on_stray_hosts false
  ```

#### CEPHADM_STRAY_DAEMON

One or more Ceph daemons are running but not are not managed by *cephadm*.  This may be because they were deployed using a different tool, or because they were started manually.  Those services cannot currently be managed by cephadm (e.g., restarted, upgraded, or included in ceph orch ps).

- If the daemon is a stateful one (monitor or OSD), it should be adopted by cephadm; see [Converting an existing cluster to cephadm](https://docs.ceph.com/en/latest/cephadm/adoption/#cephadm-adoption).  For stateless daemons, it is usually easiest to provision a new daemon with the `ceph orch apply` command and then stop the unmanaged daemon.

- If the stray daemon(s) are running on hosts not managed by cephadm, you can manage the host(s) by running the following command:

  ```
  ceph orch host add *<hostname>*
  ```

  Note

  You might need to configure SSH access to the remote host before this will work.

- See [Fully qualified domain names vs bare host names](https://docs.ceph.com/en/latest/cephadm/host-management/#cephadm-fqdn) for more information about host names and domain names.

- This warning can be disabled entirely by running the following command:

  ```
  ceph config set mgr mgr/cephadm/warn_on_stray_daemons false
  ```

#### CEPHADM_HOST_CHECK_FAILED

One or more hosts have failed the basic cephadm host check, which verifies that (1) the host is reachable and cephadm can be executed there, and (2) that the host satisfies basic prerequisites, like a working container runtime (podman or docker) and working time synchronization. If this test fails, cephadm will no be able to manage services on that host.

You can manually run this check by running the following command:

```
ceph cephadm check-host *<hostname>*
```

You can remove a broken host from management by running the following command:

```
ceph orch host rm *<hostname>*
```

You can disable this health warning by running the following command:

```
ceph config set mgr mgr/cephadm/warn_on_failed_host_check false
```

### Cluster Configuration Checks

Cephadm periodically scans each of the hosts in the cluster in order to understand the state of the OS, disks, NICs etc. These facts can then be analysed for consistency across the hosts in the cluster to identify any configuration anomalies.

#### Enabling Cluster Configuration Checks

The configuration checks are an **optional** feature, and are enabled by running the following command:

```
ceph config set mgr mgr/cephadm/config_checks_enabled true
```

#### States Returned by Cluster Configuration Checks

The configuration checks are triggered after each host scan (1m). The cephadm log entries will show the current state and outcome of the configuration checks as follows:

Disabled state (config_checks_enabled false):

```
ALL cephadm checks are disabled, use 'ceph config set mgr mgr/cephadm/config_checks_enabled true' to enable
```

Enabled state (config_checks_enabled true):

```
CEPHADM 8/8 checks enabled and executed (0 bypassed, 0 disabled). No issues detected
```

#### Managing Configuration Checks (subcommands)

The configuration checks themselves are managed through several cephadm subcommands.

To determine whether the configuration checks are enabled, run the following command:

```
ceph cephadm config-check status
```

This command returns the status of the configuration checker as either “Enabled” or “Disabled”.

To list all the configuration checks and their current states, run the following command:

```
ceph cephadm config-check ls

  NAME             HEALTHCHECK                      STATUS   DESCRIPTION
kernel_security  CEPHADM_CHECK_KERNEL_LSM         enabled  checks SELINUX/Apparmor profiles are consistent across cluster hosts
os_subscription  CEPHADM_CHECK_SUBSCRIPTION       enabled  checks subscription states are consistent for all cluster hosts
public_network   CEPHADM_CHECK_PUBLIC_MEMBERSHIP  enabled  check that all hosts have a NIC on the Ceph public_network
osd_mtu_size     CEPHADM_CHECK_MTU                enabled  check that OSD hosts share a common MTU setting
osd_linkspeed    CEPHADM_CHECK_LINKSPEED          enabled  check that OSD hosts share a common linkspeed
network_missing  CEPHADM_CHECK_NETWORK_MISSING    enabled  checks that the cluster/public networks defined exist on the Ceph hosts
ceph_release     CEPHADM_CHECK_CEPH_RELEASE       enabled  check for Ceph version consistency - ceph daemons should be on the same release (unless upgrade is active)
kernel_version   CEPHADM_CHECK_KERNEL_VERSION     enabled  checks that the MAJ.MIN of the kernel on Ceph hosts is consistent
```

The name of each configuration check can be used to enable or disable a specific check by running a command of the following form: :

```
ceph cephadm config-check disable <name>
```

For example:

```
ceph cephadm config-check disable kernel_security
```

#### CEPHADM_CHECK_KERNEL_LSM

Each host within the cluster is expected to operate within the same Linux Security Module (LSM) state. For example, if the majority of the hosts are running with SELINUX in enforcing mode, any host not running in this mode is flagged as an anomaly and a healtcheck (WARNING) state raised.

#### CEPHADM_CHECK_SUBSCRIPTION

This check relates to the status of vendor subscription. This check is performed only for hosts using RHEL, but helps to confirm that all hosts are covered by an active subscription, which ensures that patches and updates are available.

#### CEPHADM_CHECK_PUBLIC_MEMBERSHIP

All members of the cluster should have NICs configured on at least one of the public network subnets. Hosts that are not on the public network will rely on routing, which may affect performance.

#### CEPHADM_CHECK_MTU

The MTU of the NICs on OSDs can be a key factor in consistent performance. This check examines hosts that are running OSD services to ensure that the MTU is configured consistently within the cluster. This is determined by establishing the MTU setting that the majority of hosts is using. Any anomalies result in a Ceph health check.

#### CEPHADM_CHECK_LINKSPEED

This check is similar to the MTU check. Linkspeed consistency is a factor in consistent cluster performance, just as the MTU of the NICs on the OSDs is. This check determines the linkspeed shared by the majority of OSD hosts, and a health check is run for any hosts that are set at a lower linkspeed rate.

#### CEPHADM_CHECK_NETWORK_MISSING

The public_network and cluster_network settings support subnet definitions for IPv4 and IPv6. If these settings are not found on any host in the cluster, a health check is raised.

#### CEPHADM_CHECK_CEPH_RELEASE

Under normal operations, the Ceph cluster runs daemons under the same ceph release (that is, the Ceph cluster runs all daemons under (for example) Octopus).  This check determines the active release for each daemon, and reports any anomalies as a healthcheck. *This check is bypassed if an upgrade process is active within the cluster.*

#### CEPHADM_CHECK_KERNEL_VERSION

The OS kernel version (maj.min) is checked for consistency across the hosts. The kernel version of the majority of the hosts is used as the basis for identifying anomalies.



## Client keyrings and configs

Cephadm can distribute copies of the `ceph.conf` file and client keyring files to hosts. It is usually a good idea to store a copy of the config and `client.admin` keyring on any host used to administer the cluster via the CLI.  By default, cephadm does this for any nodes that have the `_admin` label (which normally includes the bootstrap host).

When a client keyring is placed under management, cephadm will:

> - build a list of target hosts based on the specified placement spec (see [Daemon Placement](https://docs.ceph.com/en/latest/cephadm/services/#orchestrator-cli-placement-spec))
> - store a copy of the `/etc/ceph/ceph.conf` file on the specified host(s)
> - store a copy of the keyring file on the specified host(s)
> - update the `ceph.conf` file as needed (e.g., due to a change in the cluster monitors)
> - update the keyring file if the entity’s key is changed (e.g., via `ceph auth ...` commands)
> - ensure that the keyring file has the specified ownership and specified mode
> - remove the keyring file when client keyring management is disabled
> - remove the keyring file from old hosts if the keyring placement spec is updated (as needed)

### Listing Client Keyrings

To see the list of client keyrings are currently under management, run the following command:

```
ceph orch client-keyring ls
```

### Putting a Keyring Under Management

To put a keyring under management, run a command of the following form:

```
ceph orch client-keyring set <entity> <placement> [--mode=<mode>] [--owner=<uid>.<gid>] [--path=<path>]
```

- By default, the *path* is `/etc/ceph/client.{entity}.keyring`, which is where Ceph looks by default.  Be careful when specifying alternate locations, as existing files may be overwritten.
- A placement of `*` (all hosts) is common.
- The mode defaults to `0600` and ownership to `0:0` (user root, group root).

For example, to create a `client.rbd` key and deploy it to hosts with the `rbd-client` label and make it group readable by uid/gid 107 (qemu), run the following commands:

```
ceph auth get-or-create-key client.rbd mon 'profile rbd' mgr 'profile rbd' osd 'profile rbd pool=my_rbd_pool'
ceph orch client-keyring set client.rbd label:rbd-client --owner 107:107 --mode 640
```

The resulting keyring file is:

```
-rw-r-----. 1 qemu qemu 156 Apr 21 08:47 /etc/ceph/client.client.rbd.keyring
```

### Disabling Management of a Keyring File

To disable management of a keyring file, run a command of the following form:

```
ceph orch client-keyring rm <entity>
```

Note

This deletes any keyring files for this entity that were previously written to cluster nodes.



## /etc/ceph/ceph.conf

### Distributing ceph.conf to hosts that have no keyrings

It might be useful to distribute `ceph.conf` files to hosts without an associated client keyring file.  By default, cephadm deploys only a `ceph.conf` file to hosts where a client keyring is also distributed (see above).  To write config files to hosts without client keyrings, run the following command:

```
ceph config set mgr mgr/cephadm/manage_etc_ceph_ceph_conf true
```

### Using Placement Specs to specify which hosts get keyrings

By default, the configs are written to all hosts (i.e., those listed by `ceph orch host ls`).  To specify which hosts get a `ceph.conf`, run a command of the following form:

```
ceph config set mgr mgr/cephadm/manage_etc_ceph_ceph_conf_hosts <placement spec>
```

For example, to distribute configs to hosts with the `bare_config` label, run the following command:

### Distributing ceph.conf to hosts tagged with bare_config

For example, to distribute configs to hosts with the `bare_config` label, run the following command:

```
ceph config set mgr mgr/cephadm/manage_etc_ceph_ceph_conf_hosts label:bare_config
```

(See [Daemon Placement](https://docs.ceph.com/en/latest/cephadm/services/#orchestrator-cli-placement-spec) for more information about placement specs.)

## 清除群集

> **Danger：**
>
> 此操作将销毁存储在此群集中的所有数据！！！

为了销毁集群并删除存储在此集群中的所有数据，禁用 cephadm 以停止所有编排操作（因此避免部署新的守护进程）。

```bash
ceph mgr module disable cephadm
```

然后验证群集的 FSID ：

```bash
ceph fsid
```

清除群集中所有主机的 ceph 守护程序：

```bash
# For each host:
cephadm rm-cluster --force --zap-osds --fsid <fsid>
```