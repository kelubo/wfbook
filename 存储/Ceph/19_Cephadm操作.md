# Cephadm 操作

[TOC]

## 查看 CEPHADM 日志消息

The cephadm orchestrator module writes logs to the `cephadm` cluster log channel. You can monitor Ceph’s activity in real time by reading the logs as they fill up. 

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

这些事件也会记录到 MON 主机上 `ceph.cephadm.log` 文件中。以及 MON 守护程序的 stderr 。

## Ceph daemon 日志

### 记录到 journald

Ceph 守护进程通常将日志写入 `/var/log/Ceph` 。默认情况下，Ceph 守护进程将日志记录到 journald ，Ceph 日志由容器 runtime 环境捕获。它们可以通过 `journalctl` 访问。

> **Note：**
>
> 在 Quincy 之前，ceph 守护进程会记录到 stderr 。
>

例如，要查看 ID 为 `5c5a50ae-272a-455d-99e9-32c6a013e694` 的集群中 `mon.foo` 守护程序的日志，命令如下：

```bash
journalctl -u ceph-5c5a50ae-272a-455d-99e9-32c6a013e694@mon.foo
```

当日志级别较低时，这对于正常操作非常有效。

### 记录到文件

You can also configure Ceph daemons to log to files instead of to journald if you prefer logs to appear in files (as they did in earlier, pre-cephadm, pre-Octopus versions of Ceph).  When Ceph logs to files, the logs appear in `/var/log/ceph/<cluster-fsid>`. If you choose to configure Ceph to log to files instead of to journald, remember to configure Ceph so that it will not log to journald (the commands for this are covered below).

如果您希望日志显示在文件中，您也可以将Ceph守护进程配置为记录到文件而不是日志（正如 Ceph 的早期、cephadm 之前、Octopus 之前版本中所做的那样）。当 Ceph 记录到文件时，日志显示在 `/var/log/ceph/<cluster-fsid>` 中。如果您选择将 Ceph 配置为记录到文件而不是日志，请记住配置 Ceph，使其不会记录到日志（下面将介绍此命令）。

#### 启用文件日志记录

要启用文件日志记录，请运行以下命令：

```bash
ceph config set global log_to_file true
ceph config set global mon_cluster_log_to_file true
```

#### 禁用 journald 的日志记录

If you choose to log to files, we recommend disabling logging to journald or else everything will be logged twice. Run the following commands to disable logging to stderr:

如果选择记录到文件，建议禁用记录到 journald，否则所有内容将被记录两次。运行以下命令以禁用到 stderr 的日志记录：

```bash
ceph config set global log_to_stderr false
ceph config set global mon_cluster_log_to_stderr false
ceph config set global log_to_journald false
ceph config set global mon_cluster_log_to_journald false
```

> Note
>
> 可以通过在引导新集群期间传递 `--log-to-file` 来更改默认值。

#### 修改日志保留计划

By default, cephadm sets up log rotation on each host to rotate these files.  You can configure the logging retention schedule by modifying `/etc/logrotate.d/ceph.<cluster-fsid>`.

默认情况下，cephadm 在每个主机上设置日志旋转，以旋转这些文件。您可以通过修改 `/etc/logrotate.d/ceph.<cluster-fsid>` 来配置日志记录保留计划。

## 每个节点的 cephadm 日志

cephadm 可执行文件（由用户直接运行或由 cephadm 编排模块运行）也可以生成日志。它独立于容器中运行的其他 Ceph 组件来实现。默认情况下，此可执行文件会记录到文件 `/var/log/ceph/cephadm.log` 中。

This logging destination is configurable and you may choose to log to the file, to the syslog/journal, or to both.
此日志记录目标是可配置的，您可以选择记录到文件和/或 syslog/journal。

### 在引导期间设置 cephadm 日志目标

The `cephadm` command may be executed with the option `--log-dest=file` or with `--log-dest=syslog` or both. These options control where cephadm will store persistent logs for each invocation. When these options are specified for the `cephadm bootstrap` command the system will automatically record these settings for future invocations of `cephadm` by the cephadm orchestration module.
`cephadm` 命令可以使用选项 `--log-dest=file` 执行 或`两者兼`而有之。这些选项控制 cephadm 将为每个调用存储持久日志的位置。为 `cephadm bootstrap` 命令指定这些选项时，系统将自动记录这些设置，以供 cephadm 编排模块将来调用 `cephadm`。

例如：

```bash
cephadm --log-dest=syslog bootstrap # ... other bootstrap arguments ...
```

If you want to manually specify exactly what log destination to use during bootstrap, independent from the `--log-dest` options, you may add a configuration key `mgr/cephadm/cephadm_log_destination` to the initial configuration file, under the `[mgr]` section. Valid values for the key are: `file`, `syslog`, and `file,syslog`.
如果想手动指定在 bootstrap 期间要使用的日志目的地，独立于 `--log-dest` 选项，您可以在 `[mgr]` 部分下向初始配置文件添加配置键 `mgr/cephadm/cephadm_log_destination` 。键的有效值为：`file`、`syslog` 和 `file，syslog`。

For example: 例如：

```bash
cat >/tmp/bootstrap.conf <<EOF
[mgr]
mgr/cephadm/cephadm_log_destination = syslog
EOF
cephadm bootstrap --config /tmp/bootstrap.conf # ... other bootstrap arguments ...
```

### 在现有集群上设置 cephadm 日志目标

An existing Ceph cluster can be configured to use a specific cephadm log destination by setting the `mgr/cephadm/cephadm_log_destination` configuration value to one of `file`, `syslog`, or `file,syslog`. This will cause the cephadm orchestration module to run `cephadm` so that logs go to `/var/log/ceph/cephadm.log`, the syslog/journal, or both, respectively.
通过将 `mgr/cephadm/cephadm_log_destination`  configuration 值设置为 `file`、`syslog` 或 `file，syslog` 之一。这将导致 cephadm 编排模块运行 `cephadm`，以便日志分别转到 `/var/log/ceph/cephadm.log` 和/或 syslog/journal。

For example: 例如：

```bash
# set the cephadm executable to log to syslog
ceph config set mgr mgr/cephadm/cephadm_log_destination syslog
# set the cephadm executable to log to both the log file and syslog
ceph config set mgr mgr/cephadm/cephadm_log_destination file,syslog
# set the cephadm executable to log to the log file
ceph config set mgr mgr/cephadm/cephadm_log_destination file
```

> 注意
>
> If you execute cephadm commands directly, such as cephadm shell, this option will not apply. To have cephadm log to locations other than the default log file When running cephadm commands directly use the `--log-dest` options described in the bootstrap section above.
> 如果您直接执行 cephadm 命令，例如 cephadm shell， 此选项将不适用。要让 cephadm 记录到 默认日志文件：直接运行 cephadm 命令时，请使用 `--log-dest` 选项。

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

可以选择提供容器映像名称以强制使用特定镜像（而不是 `container_image` 配置值指定的镜像）。

如果只需要重新生成 ceph 配置，还可以发出一个 `reconfig` 命令，它将重写 `ceph.conf` 文件，但不会触发守护进程的重新启动。

```bash
ceph orch daemon reconfig <name>
```

### Rotating a daemon’s authenticate key旋转守护程序的身份验证密钥

集群中的所有 Ceph 和网关守护进程都有一个密钥，用于连接到集群并进行身份验证。This key can be rotated可以使用以下命令旋转该键（即，替换为新密钥）：

```bash
ceph orch daemon rotate-key <name>
```

对于 MDS、OSD 和 MGR 守护程序，这不需要重新启动守护程序。然而，对于其他守护程序（例如 RGW ），可以重新启动守护程序以切换到新密钥。

## 数据位置

Cephadm 将守护程序数据和日志存储在不同的位置，pre-cephadm (pre Octopus) versions of ceph:与 ceph 的早期Cephadm（前Octopus）版本不同：

- `/var/log/ceph/<cluster-fsid>` 包含所有集群日志。默认情况下，cephadm logs via stderr and the container runtime. These logs will not exist unless you have enabled logging to files as described in [cephadm-logs](https://docs.ceph.com/en/latest/cephadm/operations/#cephadm-logs).cephadm 通过 stderr 和容器运行时进行日志记录。除非启用了文件日志记录，否则这些日志将不存在。
- `/var/lib/ceph/<cluster-fsid>` contains all cluster daemon data (besides logs).包含所有集群守护程序数据（除了日志）。
- `/var/lib/ceph/<cluster-fsid>/<daemon-name>` contains all data for an individual daemon.包含单个守护程序的所有数据。
- `/var/lib/ceph/<cluster-fsid>/crash` contains crash reports for the cluster.包含集群的崩溃报告。
- `/var/lib/ceph/<cluster-fsid>/removed` contains old daemon data directories for stateful daemons (e.g., monitor, prometheus) that have been removed by cephadm.包含已被cephadm删除的有状态守护程序（例如，monitor、prometheus）的旧守护程序数据目录。

### 磁盘空间使用

Because a few Ceph daemons (notably, the monitors and prometheus) store a large amount of data in `/var/lib/ceph` , we recommend moving this directory to its own disk, partition, or logical volume so that it does not fill up the root file system.

由于一些 Ceph 守护程序（特别是 MON 和 prometheus）在 /var/lib/Ceph 中存储了大量数据，建议将此目录移动到其自己的磁盘、分区或逻辑卷中，这样它就不会填满根文件系统。

## 健康检查

The cephadm module provides additional health checks to supplement the default health checks provided by the Cluster. cephadm 模块提供额外的运行状况检查，以补充集群提供的默认运行状况检查。这些额外的运行状况检查分为两类：

- **cephadm operations**: Health checks in this category are always executed when the cephadm module is active.此类别中的运行状况检查始终在 cephadm 模块处于活动状态时执行。
- **cluster configuration**: These health checks are *optional*, and focus on the configuration of the hosts in the cluster.这些运行状况*检查是可选的，*侧重于集群中主机的配置。

### CEPHADM Operations

#### CEPHADM_PAUSED

This indicates that cephadm background work has been paused with `ceph orch pause`.  Cephadm continues to perform passive monitoring activities (like checking host and daemon status), but it will not make any changes (like deploying or removing daemons).这表示 cephadm 后台工作已暂停，并且 `Ceph Orch pause` 了一下。Cephadm 会继续执行被动监控活动（如检查主机和守护进程状态），但不会进行任何更改（如部署或删除守护进程）。

通过运行以下命令恢复 cephadm 工作：

```bash
ceph orch resume
```

#### CEPHADM_STRAY_HOST

这表示一个或多个主机具有正在运行的 Ceph 守护进程，但未注册为由 *cephadm* 管理的主机。这意味着这些服务目前无法由 cephadm 管理（例如，重新启动、升级、包含在 `ceph orch ps` 中）。

- 可以通过运行以下命令来管理主机：

  ```bash
  ceph orch host add <hostname>
  ```

  > Note
>
  > 可能需要配置对远程主机的 SSH 访问，然后才能正常工作。

- See [Fully qualified domain names vs bare host names](https://docs.ceph.com/en/latest/cephadm/host-management/#cephadm-fqdn) for more information about host names and domain names.有关主机名和域名的更多信息，请参阅[完全限定域名与裸主机名](https://docs.ceph.com/en/latest/cephadm/host-management/#cephadm-fqdn)。

- Alternatively, you can manually connect to the host and ensure that services on that host are removed or migrated to a host that is managed by *cephadm*.或者，可以手动连接到主机，并确保该主机上的服务已删除或迁移到由 *cephadm* 管理的主机。

- 可以通过运行以下命令完全禁用此警告：

  ```bash
  ceph config set mgr mgr/cephadm/warn_on_stray_hosts false
  ```

#### CEPHADM_STRAY_DAEMON

一个或多个 Ceph 守护进程正在运行，但未由 cephadm 管理。这可能是因为它们是使用其他工具部署的，或者因为它们是手动启动的。这些服务目前无法由 cephadm 管理（例如，重新启动、升级或包含在 `ceph orch ps` 中）。

- If the daemon is a stateful one (monitor or OSD), it should be adopted by cephadm; see [Converting an existing cluster to cephadm](https://docs.ceph.com/en/latest/cephadm/adoption/#cephadm-adoption). 如果守护进程是有状态的守护进程（monitor 或 OSD），则应由 cephadm 采用;请参阅[将现有集群转换为 cephadm](https://docs.ceph.com/en/latest/cephadm/adoption/#cephadm-adoption)。对于无状态守护进程，通常最简单的方法是使用 `ceph orch apply` 命令配置新的守护进程，然后停止非托管的守护程序。

- If the stray daemon(s) are running on hosts not managed by cephadm:如果 stray 守护进程在不受 cephadm 管理的主机上运行，您可以通过运行以下命令来管理主机：

  ```bash
  ceph orch host add <hostname>
  ```

  > Note
>
  > 可能需要配置对远程主机的 SSH 访问，然后才能正常工作。

- See [Fully qualified domain names vs bare host names](https://docs.ceph.com/en/latest/cephadm/host-management/#cephadm-fqdn) for more information about host names and domain names.有关主机名和域名的更多信息，请参阅[完全限定域名与裸主机名](https://docs.ceph.com/en/latest/cephadm/host-management/#cephadm-fqdn)。

- 可以通过运行以下命令完全禁用此警告：

  ```bash
  ceph config set mgr mgr/cephadm/warn_on_stray_daemons false
  ```

#### CEPHADM_HOST_CHECK_FAILED

One or more hosts have failed the basic cephadm host check, which verifies that (1) the host is reachable and cephadm can be executed there, and (2) that the host satisfies basic prerequisites, like a working container runtime (podman or docker) and working time synchronization. 

一个或多个主机未通过基本的 cephadm 主机检查，该检查验证 （1） 主机可访问并且可以在那里执行 cephadm，以及 （2）  主机是否满足基本先决条件，例如工作容器运行时（podman 或 docker）和工作时间同步。如果此测试失败，cephadm  将无法管理该主机上的服务。

可以通过运行以下命令来手动运行此检查：

```bash
ceph cephadm check-host <hostname>
```

可以通过运行以下命令从管理中删除损坏的主机：

```bash
ceph orch host rm <hostname>
```

可以通过运行以下命令来禁用此运行状况警告：

```bash
ceph config set mgr mgr/cephadm/warn_on_failed_host_check false
```

### Cluster Configuration Checks

Cephadm 会定期扫描集群中的每个主机，以了解操作系统、磁盘、网络接口等的状态。然后，可以分析此信息在集群中主机之间的一致性，以识别任何配置异常。

#### 启用 Cluster Configuration Checks

这些配置检查是一项**可选**功能，可通过运行以下命令来启用：

```bash
ceph config set mgr mgr/cephadm/config_checks_enabled true
```

#### 集群配置检查返回的状态

每次主机扫描后都会触发配置检查。cephadm 日志条目将显示配置检查的当前状态和结果，如下所示：

禁用状态 (config_checks_enabled false):

```bash
ALL cephadm checks are disabled, use 'ceph config set mgr mgr/cephadm/config_checks_enabled true' to enable
```

启用状态 (config_checks_enabled true):

```bash
CEPHADM 8/8 checks enabled and executed (0 bypassed, 0 disabled). No issues detected
```

#### 管理配置检查（子命令）

配置检查本身通过多个 cephadm 子命令进行管理。

要确定是否启用了配置检查，请运行以下命令：

```bash
ceph cephadm config-check status
```

此命令将配置检查器的状态返回为 “Enabled” 或 “Disabled” 。

要列出所有配置检查及其当前状态，请运行以下命令：

```bash
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

The name of each configuration check can be used to enable or disable a specific check by running a command of the following form: 

每个配置检查的名称可用于通过运行以下形式的命令来启用或禁用特定检查：

```bash
ceph cephadm config-check disable <name>
```

例如：

```bash
ceph cephadm config-check disable kernel_security
```

#### CEPHADM_CHECK_KERNEL_LSM

Each host within the cluster is expected to operate within the same Linux Security Module (LSM) state. For example, if the majority of the hosts are running with SELINUX in enforcing mode, any host not running in this mode is flagged as an anomaly and a healtcheck (WARNING) state raised.

集群中的每个主机都应在相同的 Linux 安全模块 （LSM） 状态下运行。例如，如果大多数主机在强制模式下运行 SELINUX，则任何未在此模式下运行的主机都会被标记为异常并引发运行状况检查（警告）状态。

#### CEPHADM_CHECK_SUBSCRIPTION

This check relates to the status of OS vendor subscription. This check is performed only for hosts using RHEL and helps to confirm that all hosts are covered by an active subscription, which ensures that patches and updates are available.
此检查与 OS 供应商订阅的状态相关。此检查仅对使用 RHEL 的主机执行，有助于确认所有主机都包含在活动订阅中，从而确保补丁和更新可用。

#### CEPHADM_CHECK_PUBLIC_MEMBERSHIP

All members of the cluster should have a network interface configured on at least one of the public network subnets. Hosts that are not on the public network will rely on routing, which may affect performance.
群集的所有成员都应在至少一个公共网络子网上配置网络接口。不在公网的主机将依赖路由，这可能会影响性能。

#### CEPHADM_CHECK_MTU

The MTU of the network interfaces on OSD hosts can be a key factor in consistent performance. This check examines hosts that are running OSD services to ensure that the MTU is configured consistently within the cluster. This is determined by determining the MTU setting that the majority of hosts is using. Any anomalies result in a health check.
OSD 主机上网络接口的 MTU 可能是实现一致性能的关键因素。此检查检查运行 OSD 服务的主机，以确保在集群内一致地配置 MTU。这是通过确定大多数主机使用的 MTU 设置来确定的。任何异常都会导致运行状况检查。

#### CEPHADM_CHECK_LINKSPEED

This check is similar to the MTU check. Link speed consistency is a factor in consistent cluster performance, as is the MTU of the OSD node network interfaces. This check determines the link speed shared by the majority of OSD hosts, and a health check is run for any hosts that are set at a lower link speed rate.
此检查类似于 MTU 检查。链路速度一致性是集群性能一致性的一个因素，OSD 节点网络接口的 MTU 也是如此。此检查确定大多数 OSD 主机共享的链接速度，并对设置为较低链接速率的任何主机运行运行状况检查。

#### CEPHADM_CHECK_NETWORK_MISSING

The public_network and cluster_network settings support subnet definitions for IPv4 and IPv6. If these settings are not found on any host in the cluster, a health check is raised.
public_network 和 cluster_network 设置支持 IPv4 和 IPv6 的子网定义。如果在集群中的任何主机上都找不到这些设置，则会引发运行状况检查。

#### CEPHADM_CHECK_CEPH_RELEASE

Under normal operations, the Ceph cluster runs daemons that are of the same Ceph release (for example, Reef).  This check determines the active release for each daemon, and reports any anomalies as a healthcheck. *This check is bypassed if an upgrade is in process.*
在正常作下，Ceph 集群运行具有相同 Ceph 版本（例如 Reef）的守护进程。此检查确定每个守护程序的活动版本，并将任何异常报告为运行状况检查。*如果正在进行升级，则会绕过此检查。*

#### CEPHADM_CHECK_KERNEL_VERSION

The OS kernel version (maj.min) is checked for consistency across hosts. The kernel version of the majority of the hosts is used as the basis for identifying anomalies.
检查作系统内核版本 （maj.min） 以确保主机之间的一致性。大多数主机的内核版本用作识别异常的基础。

## 客户端密钥环和配置

cephadm 可以将 `ceph.conf` 文件和客户端密钥环文件的副本分发到主机。从版本 16.2.10 (Pacific) 和 17.2.1 (Quincy) 开始，除了默认位置 `/etc/ceph/` 外，cephadm 还将配置和密钥环文件存储在 `/var/lib/ceph/<fsid>/config` 目录中。通常，最好在用于通过 CLI 管理集群的任何主机上存储 config 和 `client.admin` 密钥环的副本。默认情况下，cephadm 对具有 `_admin` 标签（通常包括 bootstrap 主机）的任何节点执行此操作。

> 注意
>
> Ceph 守护进程仍将使用 `/etc/ceph/` 上的文件。新的配置位置 `/var/lib/ceph/<fsid>/config` 仅供 cephadm 使用。将此配置目录放在 fsid 下有助于 cephadm 加载与集群关联的配置。

When a client keyring is placed under management, cephadm will:当客户端密钥环置于管理之下时，cephadm 将：

* 根据指定的 placement spec 构建目标主机列表（请参阅 [守护进程放置](https://docs.ceph.com/en/latest/cephadm/services/#orchestrator-cli-placement-spec)）

* 在指定的主机上存储 `/etc/ceph/ceph.conf` 文件的副本

* store a copy of the `ceph.conf` file at `/var/lib/ceph/<fsid>/config/ceph.conf` on the specified host(s)将 `ceph.conf` 文件 `/var/lib/ceph/<fsid>/config/ceph.conf` 的副本存储在指定的主机上

* store a copy of the `ceph.client.admin.keyring` file at `/var/lib/ceph/<fsid>/config/ceph.client.admin.keyring` on the specified host(s)

  将 `ceph.client.admin.keyring` 文件 `/var/lib/ceph/<fsid>/config/ceph.client.admin.keyring` 的副本存储在指定主机上

* 在指定的主机上存储密钥环文件的副本

* 根据需要更新 `ceph.conf` 文件（例如，由于集群 MON 的更改）

* 如果实体的密钥发生更改，请更新密钥环文件（例如，通过 `ceph auth ...` 命令）

* 确保密钥环文件具有指定的所有权和指定的模式

* 禁用客户端密钥环管理时删除密钥环文件

* 如果 Keyring 放置规范已更新（根据需要），请从旧主机中删除 Keyring 文件

### 列出客户端密钥环

要查看当前受管理的客户端密钥环列表，请运行以下命令：

```bash
ceph orch client-keyring ls
```

### 将密钥环置于 Management 下

要将密钥环置于管理之下，请运行以下形式的命令：

```bash
ceph orch client-keyring set <entity> <placement> [--mode=<mode>] [--owner=<uid>.<gid>] [--path=<path>]
```

- 默认情况下，*path* 为 `/etc/ceph/client.{entity}.keyring` ，这是 Ceph 默认查找的位置。指定备用位置时要小心，因为现有文件可能会被覆盖。
- A placement of `*` (all hosts) is common.放置 `*` （all hosts） 很常见。
- 模式默认为 `0600`，所有权为 `0:0`（用户 root、组 root）。

例如，要创建一个 `client.rbd` 密钥并将其部署到具有 `rbd-client` 标签，并使其可通过 uid/gid 107 (QEMU) 组读取，请执行以下命令：

```bash
ceph auth get-or-create-key client.rbd mon 'profile rbd' mgr 'profile rbd' osd 'profile rbd pool=my_rbd_pool'
ceph orch client-keyring set client.rbd label:rbd-client --owner 107:107 --mode 640
```

生成的密钥环文件为：

```bash
-rw-r-----. 1 qemu qemu 156 Apr 21 08:47 /etc/ceph/client.client.rbd.keyring
```

默认情况下，cephadm 还将在写入密钥环的主机上管理 `/etc/ceph/ceph.conf` 。在设置密钥环时，可以通过传递 `--no-ceph-conf` 来抑制此功能。

```bash
ceph orch client-keyring set client.foo label:foo 0:0 --no-ceph-conf
```

### 禁用密钥环文件的管理

要禁用密钥环文件的管理，请运行以下形式的命令：

```bash
ceph orch client-keyring rm <entity>
```

> Note
>
> 这将删除此实体之前写入集群节点的任何密钥环文件。

## /etc/ceph/ceph.conf

### 将 ceph.conf 分发到没有密钥环的主机

It might be useful to distribute `ceph.conf` files to hosts without an associated client keyring file.  By default, cephadm deploys only a `ceph.conf` file to hosts where a client keyring is also distributed (see above).  

将 `ceph.conf` 文件分发到没有 关联的客户端密钥环文件。 默认情况下，cephadm 仅部署 `ceph.conf` 文件复制到还分发了客户端密钥环的主机（见上文）。

```bash
ceph config set mgr mgr/cephadm/manage_etc_ceph_ceph_conf true
```

### 使用 Placement Specs 指定哪些主机获得密钥环

默认情况下，配置将写入所有主机（即 `ceph orch host ls` 列出的主机）。要指定哪些主机获取 `ceph.conf`，请运行以下形式的命令：

```bash
ceph config set mgr mgr/cephadm/manage_etc_ceph_ceph_conf_hosts <placement spec>
```

### 将 ceph.conf 分发到标记为 bare_config 的主机

例如，要将配置分发到带有 `bare_config` 标签的主机，请运行以下命令：

```bash
ceph config set mgr mgr/cephadm/manage_etc_ceph_ceph_conf_hosts label:bare_config
```

(See [Daemon Placement](https://docs.ceph.com/en/latest/cephadm/services/#orchestrator-cli-placement-spec) for more information about placement specs.)

## 限制无密码 sudo 访问

By default, the cephadm install guide recommends enabling password-less `sudo` for the cephadm user.
默认情况下，cephadm 安装指南建议启用无密码 `sudo 的 cepadm` 用户。此选项是最灵活且面向未来的，但可能并非在所有环境中都是首选。管理员可以将 `sudo` 限制为仅运行确切的命令列表，而无需访问密码。请注意，此列表可能会因 Ceph 版本而异，选择此选项的管理员应阅读发行说明并查看 Ceph 文档的目标版本中的此列表。如果列表不同，则必须在升级之前扩展无密码 `sudo` 命令的列表。

需要无密码 sudo 支持的命令：

* `chmod`
* `chown`
* `ls`
* `mkdir`
* `mv`
* `rm`
* `sysctl`
* `touch` 
* `true`
*  `which` (see note)
* `/usr/bin/cephadm` 或 Python 可执行文件（请参阅注释）

> 注意
>
> Typically cephadm will execute `which` to determine what python3 command is available and then use the command returned by `which` in subsequent commands. Before configuring `sudo` run `which python3` to determine what python command to add to the `sudo` configuration. In some rare configurations `/usr/bin/cephadm` will be used instead.
> 通常，cephadm 将执行 `which` 以确定可用的 python3 命令，然后在后续命令中使用 `which` 返回的命令。在配置 `sudo` 之前，请运行 `which python3` 来确定要添加到 `sudo` 配置中的 python 命令。在一些罕见的配置中，将使用 `/usr/bin/cephadm`。

可以使用 `visudo` 之类的工具配置 `sudoers` 文件，以及添加或替换用户配置行，如下所示：

```
# assuming the cephadm user is named "ceph"
ceph ALL=(ALL) NOPASSWD:/usr/bin/chmod,/usr/bin/chown,/usr/bin/ls,/usr/bin/mkdir,/usr/bin/mv,/usr/bin/rm,/usr/sbin/sysctl,/usr/bin/touch,/usr/bin/true,/usr/bin/which,/usr/bin/cephadm,/usr/bin/python3
```

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