# MicroCeph

[TOC]

## 概述

MicroCeph 是启动和运行 Ceph 的最简单方法。

MicroCeph 是一种部署和管理 Ceph 集群的轻量级方式。Ceph 是一个高度可扩展的开源分布式存储系统，旨在为对象级、块级和文件级存储提供卓越的性能、可靠性和灵活性。

通过简化密钥分发、服务放置和磁盘管理，简化了 Ceph 集群管理，从而实现快速、轻松的部署和操作。这适用于跨私有云、边缘云以及家庭实验室和单个工作站的集群。

MicroCeph 专注于为 Ceph 管理员和存储软件开发人员提供现代部署和管理体验。

## 安装

### 单节点安装

The above will be achieved through the use of loop files placed on the root disk, which is a convenient way for setting up small test and development clusters.
以上将通过使用放置在根磁盘上的循环文件来实现，这是设置小型测试和开发集群的便捷方式。

> **警告：**
>
> Basing a Ceph cluster on a single disk also necessarily leads to a common failure domain for all OSDs. For these reasons, loop files should not be used in production environments.
> 使用专用块设备将为连接客户端带来最佳的 IOPS 性能。将 Ceph 集群基于单个磁盘也必然会导致所有 OSD 都出现共同的故障域。由于这些原因，不应在生产环境中使用循环文件。

#### 安装软件

安装 MicroCeph 的最新稳定版本：

```bash
sudo snap install microceph
```

接下来，防止软件自动更新：

```bash
sudo snap refresh --hold microceph
```

> Caution 谨慎
>
> Allowing the snap to be auto-updated can lead to unintended consequences. 
> 允许快照自动更新可能会导致意想不到的后果。特别是在企业环境中，最好在实施这些更改之前研究软件更改的后果。

#### 初始化集群

首先使用 **cluster bootstrap** 命令初始化集群：

```bash
sudo microceph cluster bootstrap
```

然后使用 **status** 命令查看集群的状态：

```bash
sudo microceph status
```

它应类似于以下内容：

```bash
MicroCeph deployment summary:
- node-mees (10.246.114.49)
    Services: mds, mgr, mon
      Disks: 0
```

在这里，给出了机器的主机名 “node-mees” 及其 IP 地址 “10.246.114.49 ” 。MDS、MGR 和 MON 服务正在运行，但尚无任何可用的存储。

#### 添加存储

需要三个 OSD 才能形成一个最小的 Ceph 集群。在生产系统中，通常会将物理块设备分配给 OSD。但是，在本教程中，为了简单起见，将使用文件支持的 OSD。

使用 **disk add** 命令将三个文件支持的 OSD 添加到集群中。在此示例中，正在创建三个 4GiB 文件：

```bash
sudo microceph disk add loop,4G,3
```

> Note 注意
>
> Although you can adjust the file size and file number to your needs, with a recommended minimum of 2GiB per OSD, there is no obvious benefit to running more than three OSDs via loop files. Be wary that an OSD, whether based on a physical device or a file, is resource intensive.
> 尽管您可以根据需要调整文件大小和文件编号，但建议每个 OSD 至少为 2GiB，但通过循环文件运行三个以上的 OSD 并没有明显的好处。请注意，无论是基于物理设备还是文件，OSD 都会占用大量资源。

复查状态：

```bash
sudo microceph status
```

The output should now show three disks and the additional presence of the OSD service:
输出现在应显示三个磁盘以及 OSD 服务的其他存在：

```bash
MicroCeph deployment summary:
- node-mees (10.246.114.49)
    Services: mds, mgr, mon, osd
      Disks: 3
```

#### 管理集群

The cluster can also be managed using native Ceph tooling if snap-level commands are not yet available for a desired task:
如果快照级命令尚不可用于所需任务，也可以使用原生 Ceph 工具管理集群：

```bash
sudo ceph status
```

集群提供以下输出：

```bash
cluster:
  id:     4c2190cd-9a31-4949-a3e6-8d8f60408278
  health: HEALTH_OK

services:
  mon: 1 daemons, quorum node-mees (age 7d)
  mgr: node-mees(active, since 7d)
  osd: 3 osds: 3 up (since 7d), 3 in (since 7d)

data:
  pools:   1 pools, 1 pgs
  objects: 2 objects, 577 KiB
  usage:   96 MiB used, 2.7 TiB / 2.7 TiB avail
  pgs:     1 active+clean
```

### 多节点安装

This tutorial will show how to install MicroCeph on three machines, thereby creating a multi-node cluster. For this tutorial, we will utilise physical block devices for storage.
本教程将展示如何在三台机器上安装 MicroCeph，从而创建一个多节点集群。在本教程中，我们将利用物理块设备进行存储。

## Ensure storage requirements

##  确保存储需求

Three OSDs will be required to form a minimal Ceph cluster. This means that, on each of the three machines, one entire disk must be allocated for storage.
需要三个 OSD 才能形成一个最小的 Ceph 集群。这意味着，在这三台机器中的每一台上，都必须分配一个完整的磁盘用于存储。

The disk subsystem can be inspected with the **lsblk** command. In this tutorial, the command’s output on each machine looks very similar to what’s shown below. Any output related to possible loopback devices has been suppressed for the purpose of clarity:
可以使用 **lsblk** 命令检查磁盘子系统。在本教程中，命令在每台计算机上的输出看起来与下面显示的内容非常相似。为清楚起见，已禁止显示与可能的环回设备相关的任何输出：

```
lsblk | grep -v loop

NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
vda    252:0    0    40G  0 disk
├─vda1 252:1    0     1M  0 part
└─vda2 252:2    0    40G  0 part /
vdb    252:16   0    20G  0 disk
```

For the example cluster, each machine will use `/dev/vdb` for storage.
对于示例集群，每台计算机都将使用 `/dev/vdb` 进行存储。

## Prepare the three machines

##  准备三台机器

On each of the three machines we will need to:
在这三台机器中的每一台上，我们都需要：

- install the software 安装软件
- disable auto-updates of the software
  禁用软件的自动更新

Below we’ll show these steps explicitly on **node-1**, which we’ll call the primary node.
下面我们将在**节点 1** 上明确展示这些步骤，我们将其称为主节点。

Install the most recent stable release of MicroCeph:
安装 MicroCeph 的最新稳定版本：

```
sudo snap install microceph
```

Prevent the software from being auto-updated:
防止软件自动更新：

```
sudo snap refresh --hold microceph
```

Caution 谨慎

Allowing the snap to be auto-updated can lead to unintended consequences. In enterprise environments especially, it is better to research the ramifications of software changes before those changes are implemented.
允许快照自动更新可能会导致意想不到的后果。特别是在企业环境中，最好在实施这些更改之前研究软件更改的后果。

Repeat the above two steps for node-2 and node-3.
对 node-2 和 node-3 重复上述两个步骤。

## Prepare the cluster

##  准备集群

On **node-1** we will now:
在**节点 1** 上，我们现在将：

- initialise the cluster 初始化集群
- create registration tokens
  创建注册令牌

Initialise the cluster with the **cluster bootstrap** command:
使用 **cluster bootstrap** 命令初始化集群：

```
sudo microceph cluster bootstrap
```

Tokens are needed to join the other two nodes to the cluster. Generate these with the **cluster add** command.
需要令牌才能将其他两个节点加入集群。使用 **cluster add** 命令生成这些命令。

Token for node-2: node-2 的令牌：

```
sudo microceph cluster add node-2

eyJuYW1lIjoibm9kZS0yIiwic2VjcmV0IjoiYmRjMzZlOWJmNmIzNzhiYzMwY2ZjOWVmMzRjNDM5YzNlZTMzMTlmZDIyZjkxNmJhMTI1MzVkZmZiMjA2MTdhNCIsImZpbmdlcnByaW50IjoiMmU0MmEzYjEwYTg1MDcwYTQ1MDcyODQxZjAyNWY5NGE0OTc4NWU5MGViMzZmZGY0ZDRmODhhOGQyYjQ0MmUyMyIsImpvaW5fYWRkcmVzc2VzIjpbIjEwLjI0Ni4xMTQuMTE6NzQ0MyJdfQ==
```

Token for node-3: node-3 的令牌：

```
sudo microceph cluster add node-3

eyJuYW1lIjoibm9kZS0zIiwic2VjcmV0IjoiYTZjYWJjOTZiNDJkYjg0YTRkZTFiY2MzY2VkYTI1M2Y4MTU1ZTNhYjAwYWUyOWY1MDA4ZWQzY2RmOTYzMjBmMiIsImZpbmdlcnByaW50IjoiMmU0MmEzYjEwYTg1MDcwYTQ1MDcyODQxZjAyNWY5NGE0OTc4NWU5MGViMzZmZGY0ZDRmODhhOGQyYjQ0MmUyMyIsImpvaW5fYWRkcmVzc2VzIjpbIjEwLjI0Ni4xMTQuMTE6NzQ0MyJdfQ==
```

Keep these tokens in a safe place. They’ll be needed in the next step.
将这些令牌保存在安全的地方。下一步将需要它们。

Note 注意

Tokens are randomly generated; each one is unique.
代币是随机生成的;每一个都是独一无二的。

## Join the non-primary nodes to the cluster

##  将非主节点加入集群

The **cluster join** command is used to join nodes to a cluster.
**cluster join**命令用于将节点连接到集群。

On **node-2**, add the machine to the cluster using the token assigned to node-2:
在 **node-2** 上，使用分配给 node-2 的令牌将计算机添加到集群中：

```
sudo microceph cluster join eyJuYW1lIjoibm9kZS0yIiwic2VjcmV0IjoiYmRjMzZlOWJmNmIzNzhiYzMwY2ZjOWVmMzRjNDM5YzNlZTMzMTlmZDIyZjkxNmJhMTI1MzVkZmZiMjA2MTdhNCIsImZpbmdlcnByaW50IjoiMmU0MmEzYjEwYTg1MDcwYTQ1MDcyODQxZjAyNWY5NGE0OTc4NWU5MGViMzZmZGY0ZDRmODhhOGQyYjQ0MmUyMyIsImpvaW5fYWRkcmVzc2VzIjpbIjEwLjI0Ni4xMTQuMTE6NzQ0MyJdfQ==
```

On **node-3**, add the machine to the cluster using the token assigned to node-3:
在 **node-3** 上，使用分配给 node-3 的令牌将计算机添加到集群中：

```
sudo microceph cluster join eyJuYW1lIjoibm9kZS0zIiwic2VjcmV0IjoiYTZjYWJjOTZiNDJkYjg0YTRkZTFiY2MzY2VkYTI1M2Y4MTU1ZTNhYjAwYWUyOWY1MDA4ZWQzY2RmOTYzMjBmMiIsImZpbmdlcnByaW50IjoiMmU0MmEzYjEwYTg1MDcwYTQ1MDcyODQxZjAyNWY5NGE0OTc4NWU5MGViMzZmZGY0ZDRmODhhOGQyYjQ0MmUyMyIsImpvaW5fYWRkcmVzc2VzIjpbIjEwLjI0Ni4xMTQuMTE6NzQ0MyJdfQ==
```

## Add storage

##  添加存储

Warning 警告

This step will remove the data found on the target storage disks. Make sure you don’t lose data unintentionally.
此步骤将删除在目标存储磁盘上找到的数据。确保您不会无意中丢失数据。

On **each** of the three machines, use the **disk add** command to add storage:
在这三台计算机中**的每一台**计算机上，使用 **disk add** 命令添加存储：

```
sudo microceph disk add /dev/vdb --wipe
```

Adjust the above command per machine according to the storage disks at your disposal. You may also provide multiple disks as space separated arguments.
根据您可以使用的存储磁盘调整每台计算机的上述命令。您也可以提供多个磁盘作为空格分隔的参数。

```
sudo microceph disk add /dev/vdb /dev/vdc /dev/vdd --wipe
```

Or use the **–all-available** flag to enlist all physical devices available on the machine.
或使用 **–all-available** 标志登记计算机上所有可用的物理设备。

```
sudo microceph disk add --all-available --wipe
```

## Check MicroCeph status

##  检查 MicroCeph 状态

On any of the three nodes, the **status** command can be invoked to check the status of MicroCeph:
在三个节点中的任何一个节点上，都可以调用 **status** 命令来检查 MicroCeph 的状态：

```
sudo microceph status

MicroCeph deployment summary:
- node-01 (10.246.114.11)
  Services: mds, mgr, mon, osd
  Disks: 1
- node-02 (10.246.114.47)
  Services: mds, mgr, mon, osd
  Disks: 1
- node-03 (10.246.115.11)
  Services: mds, mgr, mon, osd
  Disks: 1
```

Machine hostnames are given along with their IP addresses. The MDS, MGR, MON, and OSD services are running and each node is supplying a single disk, as expected.
计算机主机名与其 IP 地址一起提供。MDS、MGR、MON 和 OSD 服务正在运行，并且每个节点都按预期提供单个磁盘。

## Manage the cluster

##  管理集群

Your Ceph cluster is now deployed and can be managed by following the resources found in the [Howto](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/how-to/) section.
您的 Ceph 集群现已部署，可以按照 [Howto](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/how-to/) 部分中找到的资源进行管理。

The cluster can also be managed using native Ceph tooling if snap-level commands are not yet available for a desired task:
如果快照级命令尚不可用于所需任务，也可以使用原生 Ceph 工具管理集群：

```
ceph status
```

This gives: 这给出了：

```
cluster:
  id:     cf16e5a8-26b2-4f9d-92be-dd3ac9602ebf
  health: HEALTH_OK

services:
  mon: 3 daemons, quorum node-01,node-02,node-03 (age 14m)
  mgr: node-01(active, since 43m), standbys: node-02, node-03
  osd: 3 osds: 3 up (since 4s), 3 in (since 6s)

data:
  pools:   1 pools, 1 pgs
  objects: 0 objects, 0 B
  usage:   336 MiB used, 60 GiB / 60 GiB avail
  pgs:     100.000% pgs unknown
           1 unknown
```

# How-to guides

#  操作指南

These how-to guides will cover key operations and processes in MicroCeph.
这些操作指南将涵盖 MicroCeph 中的关键操作和流程。

- [Changing the log level 更改日志级别](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/how-to/change-log-level/)
- [Configuring Cluster network
  配置集群网络](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/how-to/configure-network-keys/)
- [Enabling Prometheus Alertmanager alerts
  启用 Prometheus Alertmanager 警报](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/how-to/enable-alerts/)
- [Enabling metrics collection with Prometheus
  使用 Prometheus 启用指标收集](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/how-to/enable-metrics/)
- [Enabling additional service instances
  启用其他服务实例](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/how-to/enable-service-instances/)
- [Migrating automatically-provisioned services
  迁移自动预配的服务](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/how-to/migrate-auto-services/)
- [Configure RBD client cache in MicroCeph
  在 MicroCeph 中配置 RBD 客户端缓存](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/how-to/rbd-client-cfg/)
- [Upgrade to Reef 升级到珊瑚礁](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/how-to/reef-upgrade/)
- [Removing a disk 删除磁盘](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/how-to/remove-disk/)

# Changing the log level

#  更改日志级别

By default, the MicroCeph daemon runs with the log level set to DEBUG. While that is the desirable behaviour for a good number of use cases, there are instances when this level is far too high - for example, embedded devices where storage is much more limited. For these reasons, the MicroCeph daemon exposes a way to both get and set the log level.
默认情况下，MicroCeph 守护程序在日志级别设置为 DEBUG 的情况下运行。虽然对于许多用例来说，这是理想的行为，但在某些情况下，这个水平太高了 -  例如，存储空间更加有限的嵌入式设备。由于这些原因，MicroCeph 守护进程提供了一种获取和设置日志级别的方法。

## Configuring the log level

##  配置日志级别

MicroCeph includes the command `log`, with the sub-commands `set-level` and `get-level`. When setting, we support both string and integer formats for the log level. For example:
MicroCeph 包含命令`日志`，以及子命令 `set-level` 和 `get-level`。设置时，我们支持日志级别的字符串和整数格式。例如：

```
sudo microceph log set-level warning
sudo microceph log set-level 3
```

Both commands are equivalent. The mapping from integer to string can be consulted by querying the help for the `set-level` sub-command. Note that any changes made to the log level take effect immediately, and need no restarts.
这两个命令都是等效的。从整数到字符串的映射可以通过查询`设置级`子命令的帮助来查询。请注意，对日志级别所做的任何更改都会立即生效，无需重新启动。

On the other hand, the `get-level` sub-command takes no arguments and returns an integer level only. Any value returned by `get-level` can be used for `set-level`.
另一方面，`get-level` 子命令不带任何参数，仅返回整数级别。`get-level` 返回的任何值都可用于 `set-level`。

For example, after setting the level as shown in the example, we can verify in this way:
例如，在设置了示例中所示的级别后，我们可以通过以下方式进行验证：

```
sudo microceph log get-level
3
```

# Configuring Cluster network

#  配置集群网络

If you configure a cluster network, OSDs will route heartbeat, object  replication and recovery traffic over the cluster network. This may  improve performance compared to using a single network.
如果配置集群网络，OSD 将通过集群网络路由检测信号、对象复制和恢复流量。与使用单一网络相比，这可能会提高性能。

The MicroCeph cluster configuration CLI supports setting, getting, resetting and listing supported config keys mentioned below.
MicroCeph 集群配置 CLI 支持设置、获取、重置和列出下面提到的支持的配置键。


支持的配置键

| Key 钥匙        | Description 描述                                             |
| --------------- | ------------------------------------------------------------ |
| cluster_network | Set this key to desired CIDR to configure cluster network 将此密钥设置为所需的 CIDR 以配置集群网络 |

1. Supported config keys can be configured using the ‘set’ command:
   可以使用“set”命令配置支持的配置键：

> ```
> $ sudo microceph cluster config set cluster_network 10.5.0.0/16
> ```

1. Config value for a particular key could be queried using the ‘get’ command:
   可以使用“get”命令查询特定键的配置值：

> ```
> $ sudo microceph cluster config get cluster_network
> +---+-----------------+-------------+
> | # |       KEY       |     VALUE   |
> +---+-----------------+-------------+
> | 0 | cluster_network | 10.5.0.0/16 |
> +---+-----------------+-------------+
> ```

1. A list of all the configured keys can be fetched using the ‘list’ command:
   可以使用“list”命令获取所有已配置键的列表：

> ```
> $ sudo microceph cluster config list
> +---+-----------------+-------------+
> | # |       KEY       |     VALUE   |
> +---+-----------------+-------------+
> | 0 | cluster_network | 10.5.0.0/16 |
> +---+-----------------+-------------+
> ```

1. Resetting a config key (i.e. setting the key to its default value) can performed using the ‘reset’ command:
   可以使用“reset”命令重置配置键（即将键设置为默认值）：

> ```
> $ sudo microceph cluster config reset cluster_network
> $ sudo microceph cluster config list
> +---+-----+-------+
> | # | KEY | VALUE |
> +---+-----+-------+
> ```

For more explanations and implementation details refer to [explanation](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/explanation/cluster-configurations/)
更多说明和实现细节请参考 [解释](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/explanation/cluster-configurations/)

# Enabling Prometheus Alertmanager alerts

#  启用 Prometheus Alertmanager 警报

## Pre-Requisite

##  先决条件

In order to configure alerts, your MicroCeph deployment must enable metrics collections with Prometheus. Follow [this How-To](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/how-to/enable-metrics/) if you haven’t configured it. Also, Alertmanager is distributed as a separate binary which should be installed and running.
为了配置警报，您的 MicroCeph 部署必须启用 Prometheus 的指标收集。如果您尚未配置，请按照[此操作](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/how-to/enable-metrics/)方法进行操作。此外，Alertmanager作为单独的二进制文件分发，应安装并运行该二进制文件。

## Introduction

##  简介

Prometheus Alertmanager handles alerts sent by the Prometheus server. It takes  care of deduplicating, grouping, and routing them to the correct  receiver integration such as email. It also takes care of silencing and  inhibition of alerts.
Prometheus Alertmanager 处理 Prometheus 服务器发送的警报。它负责对它们进行重复数据删除、分组和路由到正确的接收器集成，例如电子邮件。它还负责静音和禁止警报。

Alerts are configured using [Alerting Rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/). These rules allows the user to define alert conditions using Prometheus expressions. Ceph is designed to be configurable with Alertmanager, you can use the default set of alerting rules provided below to get basic  alerts from your MicroCeph deployments.
警报是使用[警报规则](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/)配置的。这些规则允许用户使用 Prometheus 表达式定义警报条件。Ceph 设计为可通过 Alertmanager 进行配置，您可以使用下面提供的默认警报规则集来获取 MicroCeph 部署的基本警报。

The default alert rules can be downloaded from 
默认告警规则可从以下位置下载。[`here`](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/_downloads/2aa51c8517b2d55846da53500c263f43/prometheus_alerts.yaml)

## Configuring Alert rules

##  配置告警规则

Alerting rules and Alertmanager targets are configured in Prometheus using the  same config file we used to configure scraping targets.
警报规则和 Alertmanager 目标是在 Prometheus 中使用我们用于配置抓取目标的同一配置文件配置的。

A simple configuration file with scraping targets, Alertmanager and alerting rules is provided below:
下面提供了一个简单的配置文件，其中包含抓取目标、Alertmanager 和警报规则：

```
# microceph.yaml
global:
    external_labels:
        monitor: 'microceph'

# Scrape Job
scrape_configs:
  - job_name: 'microceph'

    # Ceph's default for scrape_interval is 15s.
    scrape_interval: 15s

    # List of all the ceph-mgr instances along with default (or configured) port.
    static_configs:
    - targets: ['10.245.165.103:9283', '10.245.165.205:9283', '10.245.165.94:9283']

rule_files: # path to alerting rules file.
  - /home/ubuntu/prometheus_alerts.yaml

alerting:
  alertmanagers:
    - static_configs:
      - targets: # Alertmanager <HOST>:<PORT>
        - "10.245.167.132:9093"
```

Start Prometheus with provided configuration file.
使用提供的配置文件启动 Prometheus。

```
prometheus --config.file=microceph.yaml
```

Click on the ‘Alerts’ tab on Prometheus dashboard to view the configured alerts:
单击 Prometheus 仪表板上的“警报”选项卡以查看配置的警报：

![../../_images/alerts](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/_images/alerts)

Look we already have an active ‘CephHealthWarning’ alert! (shown in red)  while the other configured alerts are inactive (shown in green). Hence,  Alertmanager is configured and working.
看，我们已经有一个活跃的“CephHealthWarning”警报！（以红色显示），而其他配置的警报处于非活动状态（以绿色显示）。因此，Alertmanager 已配置并正在运行。

# Enabling metrics collection with Prometheus

#  使用 Prometheus 启用指标收集

## Introduction

##  简介

Metrics play an important role in understanding the operation of your MicroCeph deployment. These metrics or measurements form the basis for analysing  and understanding your cluster’s behaviour and are essential for  providing reliable services.
指标在理解 MicroCeph 部署的操作方面发挥着重要作用。这些指标或度量构成了分析和理解集群行为的基础，对于提供可靠的服务至关重要。

A popular and mature open-source tool used for scraping and recording  metrics over time is Prometheus. Ceph is also designed to be easily  integratable with Prometheus. This tutorial documents the procedure and  related information for configuring Prometheus to scrape MicroCeph’s  metrics endpoint.
Prometheus 是一种流行且成熟的开源工具，用于抓取和记录一段时间内的指标。Ceph 还设计为易于与 Prometheus 集成。本教程记录了配置 Prometheus 以抓取 MicroCeph 的指标端点的过程和相关信息。

## Setup

##  设置

![../../_images/prometheus_microceph_scraping.jpg](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/_images/prometheus_microceph_scraping.jpg)

Prometheus service scraping endpoints of a multi-node MicroCeph cluster.


Prometheus 服务抓取多节点 MicroCeph 集群的端点。

The diagram above describes how the metrics endpoint is served by ceph-mgr  and scraped by Prometheus on a service level. Another thing to notice is that at any given time only one of the mgr module is active and  responsible for receiving MgrReports and serving them i.e. only one  instance of ceph-mgr serves the metrics endpoint. As the active Mgr  instance can be changing over time, standard practice is to scrape all  the mgr instances when monitoring a Ceph cluster.
上图描述了 ceph-mgr 如何提供指标端点，以及 Prometheus 如何在服务级别上抓取指标端点。需要注意的另一件事是，在任何给定时间，只有一个  mgr 模块处于活动状态，并负责接收 MgrReports 并提供它们，即只有一个 ceph-mgr 实例服务于指标端点。由于活动 Mgr  实例可能会随着时间的推移而变化，因此标准做法是在监控 Ceph 集群时抓取所有 mgr 实例。

### Enabling Ceph-Mgr Prometheus module

###  启用 Ceph-Mgr Prometheus 模块

Ceph-Mgr Prometheus module is responsible for serving the metrics endpoint which can then be scraped by Prometheus itself. We can enable the module by  executing the following command on a MicroCeph node:
Ceph-Mgr Prometheus 模块负责为指标端点提供服务，然后 Prometheus 本身可以抓取这些端点。我们可以通过在 MicroCeph 节点上执行以下命令来启用该模块：

```
ceph mgr module enable prometheus
```

### Configuring metrics endpoint

###  配置指标端

By default, it will accept HTTP requests on port 9283 on all IPv4 and IPv6 addresses on the host. However this can configured using the following  ceph-mgr config keys to fine tune to requirements.
默认情况下，它将在主机上的所有 IPv4 和 IPv6 地址的端口 9283 上接受 HTTP 请求。但是，可以使用以下 ceph-mgr 配置键进行配置，以根据需求进行微调。

```
ceph config set mgr mgr/prometheus/server_addr <addr>
ceph config set mgr mgr/prometheus/port <port>
```

For details on how metrics endpoint can be further configured visit [Ceph Prometheus module](https://docs.ceph.com/en/quincy/mgr/prometheus/)
有关如何进一步配置指标端点的详细信息，请访问 [Ceph Prometheus 模块](https://docs.ceph.com/en/quincy/mgr/prometheus/)

## Configuring Prometheus to scrape MicroCeph

##  配置 Prometheus 抓取 MicroCeph

Prometheus uses YAML file based configuration of scrape targets. While Prometheus  supports an extensive list of configurations that is out of the scope of this document. For details visit [Prometheus configuration](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)
Prometheus 使用基于 YAML 文件的抓取目标配置。虽然 Prometheus 支持大量的配置列表，但这超出了本文档的范围。详情请参见 [Prometheus 配置](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)

A simple configuration file is provided below:
下面提供了一个简单的配置文件：

```
# microceph.yaml
global:
    external_labels:
        monitor: 'microceph'

# Scrape Job
scrape_configs:
  - job_name: 'microceph'

    # Ceph's default for scrape_interval is 15s.
    scrape_interval: 15s

    # List of all the ceph-mgr instances along with default (or configured) port.
    static_configs:
    - targets: ['10.245.165.103:9283', '10.245.165.205:9283', '10.245.165.94:9283']
```

Start Prometheus with provided configuration file.
使用提供的配置文件启动 Prometheus。

```
prometheus --config.file=microceph.yaml
```

The default port used is 9090 hence collected metrics can be observed at `<prometheus_addr>:9090` as:
使用的默认端口是 9090，因此可以在 `<prometheus_addr>：9090` 处观察到收集的指标，如下所示：

![../../_images/prometheus_console.jpg](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/_images/prometheus_console.jpg)

A Prometheus console displaying scraped metric from MicroCeph cluster.


一个 Prometheus 控制台，显示从 MicroCeph 集群中抓取的指标。

# Enabling additional service instances

#  启用其他服务实例

To ensure a base level of resiliency, MicroCeph will always try to enable a sufficient number of instances for certain services in the cluster. This number is set to three by default.
为了确保基本级别的弹性，MicroCeph 将始终尝试为集群中的某些服务启用足够数量的实例。默认情况下，此数字设置为 3。

The services affected by this include:
受此影响的服务包括：

- MON ([Monitor service](https://docs.ceph.com/en/latest/man/8/ceph-mon/))
  MON（[监控服务](https://docs.ceph.com/en/latest/man/8/ceph-mon/)）
- MDS ([Metadata service](https://docs.ceph.com/en/latest/man/8/ceph-mds/))
  MDS（[元数据服务](https://docs.ceph.com/en/latest/man/8/ceph-mds/)）
- MGR ([Manager service](https://docs.ceph.com/en/latest/mgr/))
  MGR（[经理服务](https://docs.ceph.com/en/latest/mgr/)）

Cluster designs that call for extra service instances, however, can be satisfied by manual means. In addition to the above-listed services, the following service can be added manually to a node:
但是，需要额外服务实例的集群设计可以通过手动方式来满足。除了上述服务外，还可以手动将以下服务添加到节点：

- RGW ([RADOS Gateway service](https://docs.ceph.com/en/latest/radosgw/))
  RGW（[RADOS网关服务](https://docs.ceph.com/en/latest/radosgw/)）

This is the purpose of the **enable** command. It manually enables a new instance of a service on a node.
这就是 **enable** 命令的目的。它在节点上手动启用服务的新实例。

The syntax is: 语法为：

```
sudo microceph enable <service> --target <destination> ...
```

Where the service value is one of ‘mon’, ‘mds’, ‘mgr’, and ‘rgw’. The destination is a node name as discerned by the output of the **status** command:
其中服务值为 'mon'、'mds'、'mgr' 和 'rgw' 之一。目标是一个节点名称，如 **status** 命令的输出所示：

```
sudo microceph status
```

For a given service, the **enable** command may support extra parameters. These can be discovered by querying for help for the respective service:
对于给定的服务，**enable** 命令可能支持额外的参数。可以通过查询相应服务的帮助来发现这些内容：

```
sudo microceph enable <service> --help
```

## Example: enable an RGW service

##  示例：启用 RGW 服务

First check the status of the cluster to get node names and an overview of existing services:
首先检查集群的状态，获取节点名称和现有服务的概述：

```
sudo microceph status

MicroCeph deployment summary:
- node1-2c3eb41e-14e8-465d-9877-df36f5d80922 (10.111.153.78)
  Services: mds, mgr, mon, osd
  Disks: 3
- workbook (192.168.29.152)
  Services: mds, mgr, mon
  Disks: 0
```

View any possible extra parameters for the RGW service:
查看 RGW 服务的任何可能的额外参数：

```
sudo microceph enable rgw --help
```

To enable the RGW service on node1 and specify a value for extra parameter port:
要在 node1 上启用 RGW 服务并为额外参数端口指定值，请执行以下操作：

```
sudo microceph enable rgw --target node1 --port 8080
```

Finally, view cluster status again and verify expected changes:
最后，再次查看集群状态并验证预期的更改：

```
sudo microceph status

MicroCeph deployment summary:
- node1 (10.111.153.78)
  Services: mds, mgr, mon, rgw, osd
  Disks: 3
- workbook (192.168.29.152)
  Services: mds, mgr, mon
  Disks: 0
```

# Migrating automatically-provisioned services

#  迁移自动配置的服务

MicroCeph deploys automatically-provisioned Ceph services when needed. These services include:
MicroCeph 会在需要时部署自动配置的 Ceph 服务。这些服务包括：

- MON - [Monitor service](https://docs.ceph.com/en/latest/man/8/ceph-mon/)
  MON - [监控服务](https://docs.ceph.com/en/latest/man/8/ceph-mon/)
- MDS - [Metadata service](https://docs.ceph.com/en/latest/man/8/ceph-mds/)
  MDS - [元数据服务](https://docs.ceph.com/en/latest/man/8/ceph-mds/)
- MGR - [Manager service](https://docs.ceph.com/en/latest/mgr/)
  MGR - [经理服务](https://docs.ceph.com/en/latest/mgr/)

It can however be useful to have the ability to move (or migrate) these services from one node to another. This may be desirable during a maintenance window for instance where these services must remain available.
但是，能够将这些服务从一个节点移动（或迁移）到另一个节点可能很有用。在维护时段内，这可能是可取的，例如，当这些服务必须保持可用时。

This is the purpose of the **cluster migrate** command. It enables automatically-provisioned services on a target node and disables them on the source node.
这就是 **cluster migrate** 命令的用途。它在目标节点上启用自动预配的服务，并在源节点上禁用它们。

The syntax is: 语法为：

```
sudo microceph cluster migrate <source> <destination>
```

Where the source and destination are node names that are available via the **status** command:
其中，源和目标是可通过 **status** 命令访问的节点名称：

```
sudo microceph status
```

Post-migration, the **status** command can also be used to verify the distribution of services among nodes.
迁移后，**status** 命令还可用于验证节点之间的服务分布。

**Notes: 笔记：**

- It’s not possible, nor useful, to have more than one instance of an automatically-provisioned service on any given node.
  在任何给定节点上拥有自动预配服务的多个实例是不可能的，也没有用处。
- RADOS Gateway services are not considered to be of the automatically-provisioned type; they are enabled and disabled explicitly on a node.
  RADOS 网关服务不被视为自动配置类型;它们在节点上显式启用和禁用。

# Configure RBD client cache in MicroCeph

#  在 MicroCeph 中配置 RBD 客户端缓存

MicroCeph supports setting, resetting, and listing client configurations which  are exported to ceph.conf and are used by tools like qemu directly for  configuring rbd cache. Below are the supported client configurations.
MicroCeph 支持设置、重置和列出客户端配置，这些配置被导出到 ceph.conf 中，并被 qemu 等工具直接用于配置 rbd 缓存。以下是受支持的客户端配置。


支持的配置键

| Key 钥匙                           | Description 描述                                             |
| ---------------------------------- | ------------------------------------------------------------ |
| rbd_cache                          | Enable caching for RADOS Block Device (RBD). 为 RADOS 块设备 （RBD） 启用缓存。 |
| rbd_cache_size                     | The RBD cache size in bytes. RBD 缓存大小（以字节为单位）。  |
| rbd_cache_writethrough_until_flush | The number of seconds dirty data is in the cache before writeback starts. 在写回开始之前，脏数据在缓存中的秒数。 |
| rbd_cache_max_dirty                | The dirty limit in bytes at which the cache triggers write-back. If 0, uses write-through caching. 缓存触发回写的脏限制（以字节为单位）。如果为 0，则使用直写缓存。 |
| rbd_cache_target_dirty             | The dirty target before the cache begins writing data to the data storage. Does not block writes to the cache. 在缓存开始将数据写入数据存储之前的脏目标。不阻止对缓存的写入。 |

1. Supported config keys can be configured using the ‘set’ command:
   可以使用“set”命令配置支持的配置键：

> ```
> $ sudo microceph client config set rbd_cache true
> $ sudo microceph client config set rbd_cache false --target alpha
> $ sudo microceph client config set rbd_cache_size 2048MiB --target beta
> ```

> Note 注意
>
> Host level configuration changes can be made by passing the relevant hostname as the –target parameter.
> 可以通过将相关主机名作为 –target 参数传递来更改主机级别的配置。

1. All the client configs can be queried using the ‘list’ command.
   可以使用“list”命令查询所有客户端配置。

> ```
> $ sudo microceph cluster config list
> +---+----------------+---------+----------+
> | # |      KEY       |  VALUE  |   HOST   |
> +---+----------------+---------+----------+
> | 0 | rbd_cache      | true    | beta     |
> +---+----------------+---------+----------+
> | 1 | rbd_cache      | false   | alpha    |
> +---+----------------+---------+----------+
> | 2 | rbd_cache_size | 2048MiB | beta     |
> +---+----------------+---------+----------+
> ```

Similarly, all the client configs of a particular host can be queried using the –target parameter.
同样，可以使用 –target 参数查询特定主机的所有客户端配置。

```
$ sudo microceph cluster config list --target beta
+---+----------------+---------+----------+
| # |      KEY       |  VALUE  |   HOST   |
+---+----------------+---------+----------+
| 0 | rbd_cache      | true    | beta     |
+---+----------------+---------+----------+
| 1 | rbd_cache_size | 2048MiB | beta     |
+---+----------------+---------+----------+
```

1. A particular config key can be queried for using the ‘get’ command:
   可以使用“get”命令查询特定的配置键：

> ```
> $ sudo microceph cluster config list
> +---+----------------+---------+----------+
> | # |      KEY       |  VALUE  |   HOST   |
> +---+----------------+---------+----------+
> | 0 | rbd_cache      | true    | beta     |
> +---+----------------+---------+----------+
> | 1 | rbd_cache      | false   | alpha    |
> +---+----------------+---------+----------+
> ```

Similarly, –target parameter can be used with get command to query for a particular config key/hostname pair.
同样，–target 参数可以与 get 命令一起使用，以查询特定的配置键/主机名对。

```
$ sudo microceph cluster config rbd_cache --target alpha
+---+----------------+---------+----------+
| # |      KEY       |  VALUE  |   HOST   |
+---+----------------+---------+----------+
| 0 | rbd_cache      | false   | alpha    |
+---+----------------+---------+----------+
```

1. Resetting a config key (i.e. removing the configured key/value) can performed using the ‘reset’ command:
   可以使用“reset”命令重置配置键（即删除配置的键/值）：

> ```
> $ sudo microceph cluster config reset rbd_cache_size
> $ sudo microceph cluster config list
>  +---+----------------+---------+----------+
>  | # |      KEY       |  VALUE  |   HOST   |
>  +---+----------------+---------+----------+
>  | 0 | rbd_cache      | true    | beta     |
>  +---+----------------+---------+----------+
>  | 1 | rbd_cache      | false   | alpha    |
>  +---+----------------+---------+----------+
> ```

This operation can also be performed for a specific host as follows:
也可以对特定主机执行此操作，如下所示：

```
$ sudo microceph cluster config reset rbd_cache --target alpha
$ sudo microceph cluster config list
 +---+----------------+---------+----------+
 | # |      KEY       |  VALUE  |   HOST   |
 +---+----------------+---------+----------+
 | 0 | rbd_cache      | true    | beta     |
 +---+----------------+---------+----------+
```

# Upgrade to Reef

#  升级到 

## Overview

##  概述

This guide provides step-by-step instructions on how to upgrade your  MicroCeph cluster from the Quincy release to the Reef release. Follow  these steps carefully to prevent to ensure a smooth transition.
本指南提供了有关如何将 MicroCeph 集群从 Quincy 版本升级到 Reef 版本的分步说明。请仔细执行这些步骤，以防止顺利过渡。

## Procedure

##  操作步骤

### Optional but Recommended: Preparation Steps

###  可选但推荐：准备步骤

Carry out these precautionary steps before initiating the upgrade:
在开始升级之前，请执行以下预防措施：

1. **Back up your data**: as a general precaution, it is recommended to take a backup of your  data (such as stored S3 objects, RBD volumes, or cephfs filesystems).
   **备份数据**：作为一般预防措施，建议备份您的数据（例如存储的 S3 对象、RBD 卷或 cephfs 文件系统）。
2. **Prevent OSDs from dropping out of the cluster**: Run the following command to avoid OSDs from unintentionally dropping out of the cluster during the upgrade process:
   **防止 OSD 从集群中退出**：运行以下命令以避免 OSD 在升级过程中无意中从集群中退出：

```
sudo ceph osd set noout
```

### Checking Ceph Health

###  检查 Ceph 运行状况

Before initiating the upgrade, ensure that the cluster is healthy. Use the below command to check the cluster health:
在启动升级之前，请确保集群运行正常。使用以下命令检查集群运行状况：

```
sudo ceph -s
```

**Note**: Do not start the upgrade if the cluster is unhealthy.
**注意**：如果集群运行不正常，请不要开始升级。

### Upgrading Each Cluster Node

###  升级每个集群节点

If your cluster is healthy, proceed with the upgrade by refreshing the snap on each node using the following command:
如果您的集群运行正常，请使用以下命令刷新每个节点上的快照来继续升级：

```
sudo snap refresh microceph --channel reef/stable
```

Be sure to perform the refresh on every node in the cluster.
请务必在群集中的每个节点上执行刷新。

### Verifying the Upgrade

###  验证升级

Once the upgrade process is done, verify that all components have been upgraded correctly. Use the following command to check:
升级过程完成后，请验证所有组件是否均已正确升级。使用以下命令进行检查：

```
sudo ceph versions
```

### Unsetting Noout

###  取消设置 Noout

If you had previously set noout, unset it with this command:
如果您之前设置了 noout，请使用以下命令取消设置它：

```
sudo ceph osd unset noout
```

You have now successfully upgraded to the Reef Release.
您现在已成功升级到 Reef Release。

# Removing a disk

#  移除磁盘

## Overview

##  概述

There are valid reasons for wanting to remove a disk from a Ceph cluster. A common use case is the need to replace one that has been identified as nearing its shelf life. Another example is the desire to scale down the cluster through the removal of a cluster node (machine).
想要从 Ceph 集群中删除磁盘是有充分理由的。一个常见的用例是需要更换已被确定为接近其保质期的产品。另一个示例是通过删除集群节点（计算机）来缩减集群的愿望。

The following resources provide extra context to the disk removal operation:
以下资源为磁盘删除操作提供了额外的上下文：

- the [Cluster scaling](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/explanation/cluster-scaling/) page
  [集群扩缩容](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/explanation/cluster-scaling/)页面
- the [disk](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/reference/commands/disk/) command reference
  [磁盘](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/reference/commands/disk/)命令参考

Note 注意

This feature is currently only supported in channel `latest/edge` of the **microceph** snap.
此功能目前仅在 **microceph** snap 的通道 `latest/edge` 中受支持。

## Procedure

##  操作步骤

First get an overview of the cluster and its OSDs:
首先，了解集群及其 OSD 的概述：

```
ceph status
```

Example output: 输出示例：

```
cluster:
  id:     cf16e5a8-26b2-4f9d-92be-dd3ac9602ebf
  health: HEALTH_OK

services:
  mon: 3 daemons, quorum node-01,node-02,node-03 (age 41h)
  mgr: node-01(active, since 41h), standbys: node-02, node-03
  osd: 5 osds: 5 up (since 22h), 5 in (since 22h); 1 remapped pgs

data:
  pools:   1 pools, 1 pgs
  objects: 2 objects, 577 KiB
  usage:   105 MiB used, 1.9 TiB / 1.9 TiB avail
  pgs:     2/6 objects misplaced (33.333%)
           1 active+clean+remapped
```

Then determine the ID of the OSD associated with the disk with the (native Ceph) **ceph osd tree** command:
然后，使用（原生 Ceph）**ceph osd tree** 命令确定与磁盘关联的 OSD 的 ID：

```
ceph osd tree
```

Sample output: 示例输出：

```
ID  CLASS  WEIGHT   TYPE NAME              STATUS  REWEIGHT  PRI-AFF
-1         1.87785  root default
-5         1.81940      host node-mees
 3         0.90970          osd.3              up   1.00000  1.00000
 4         0.90970          osd.4              up   1.00000  1.00000
-2         0.01949      host node-01
 0         0.01949          osd.0              up   1.00000  1.00000
-3         0.01949      host node-02
 1         0.01949          osd.1              up   1.00000  1.00000
-4         0.01949      host node-03
 2         0.01949          osd.2              up   1.00000  1.00000
```

Let’s assume that our target disk is on host ‘node-mees’ and has an associated OSD whose ID is ‘osd.4’.
假设我们的目标磁盘位于主机“node-mees”上，并且有一个关联的 OSD，其 ID 为“osd.4”。

To remove the disk: 要移除磁盘：

```
sudo microceph disk remove osd.4
```

Verify that the OSD has been removed:
确认 OSD 已被移除：

```
ceph osd tree
```

Output: 输出：

```
ID  CLASS  WEIGHT   TYPE NAME              STATUS  REWEIGHT  PRI-AFF
-1         0.96815  root default
-5         0.90970      host node-mees
 3    hdd  0.90970          osd.3              up   1.00000  1.00000
-2         0.01949      host node-01
 0    hdd  0.01949          osd.0              up   1.00000  1.00000
-3         0.01949      host node-02
 1    hdd  0.01949          osd.1              up   1.00000  1.00000
-4         0.01949      host node-03
 2    hdd  0.01949          osd.2              up   1.00000  1.00000
```

Finally, confirm cluster status and health:
最后，确认集群状态和运行状况：

```
ceph status
```

Output: 输出：

```
cluster:
  id:     cf16e5a8-26b2-4f9d-92be-dd3ac9602ebf
  health: HEALTH_OK

services:
  mon: 3 daemons, quorum node-01,node-02,node-03 (age 4m)
  mgr: node-01(active, since 4m), standbys: node-02, node-03
  osd: 4 osds: 4 up (since 4m), 4 in (since 4m)

data:
  pools:   1 pools, 1 pgs
  objects: 2 objects, 577 KiB
  usage:   68 MiB used, 991 GiB / 992 GiB avail
  pgs:     1 active+clean
```

# Commands

#  命令

List of MicroCeph commands.
MicroCeph 命令列表。

- [`client`](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/reference/commands/client/)
- [`cluster`](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/reference/commands/cluster/)
- [`disable`](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/reference/commands/disable/)
- [`disk`](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/reference/commands/disk/)
- [`enable`](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/reference/commands/enable/)
- [`help`](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/reference/commands/help/)
- [`init`](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/reference/commands/init/)
- [`pool`](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/reference/commands/pool/)
- [`status`](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/reference/commands/status/)

# `client`

Manages MicroCeph clients
管理 MicroCeph 客户端

Usage: 用法：

```
microceph client [flags]
microceph client [command]
```

Available commands: 可用命令：

```
config      Manage Ceph Client configs
```

Global options: 全局选项：

```
-d, --debug       Show all debug messages
-h, --help        Print help
    --state-dir   Path to store state information
-v, --verbose     Show all information messages
    --version     Print version number
```

## `config`

Manages Ceph Cluster configs.
管理 Ceph 集群配置。

Usage: 用法：

```
microceph cluster config [flags]
microceph cluster config [command]
```

Available Commands: 可用命令：

```
get         Fetches specified Ceph Client config
list        Lists all configured Ceph Client configs
reset       Removes specified Ceph Client configs
set         Sets specified Ceph Client config
```

## `config set`

Sets specified Ceph Client config
设置指定的 Ceph 客户端配置

Usage: 用法：

```
microceph client config set <Key> <Value> [flags]
```

Flags: 标志：

```
--target string   Specify a microceph node the provided config should be applied to. (default "*")
--wait            Wait for configs to propagate across the cluster. (default true)
```

## `config get`

Fetches specified Ceph Client config
获取指定的 Ceph 客户端配置

Usage: 用法：

```
microceph client config get <key> [flags]
```

Flags: 标志：

```
--target string   Specify a microceph node the provided config should be applied to. (default "*")
```

## `config list`

Lists all configured Ceph Client configs
列出所有已配置的 Ceph Client 配置

Usage: 用法：

```
microceph client config list [flags]
```

Flags: 标志：

```
--target string   Specify a microceph node the provided config should be applied to. (default "*")
```

## `config reset`

Removes specified Ceph Client configs
删除指定的 Ceph Client 配置

Usage: 用法：

```
microceph client config reset <key> [flags]
```

Flags: 标志：

```
--target string          Specify a microceph node the provided config should be applied to. (default "*")
--wait                   Wait for required ceph services to restart post config reset. (default true)
--yes-i-really-mean-it   Force microceph to reset all client config records for given key.
```

# `cluster`

Manages the MicroCeph cluster.
管理 MicroCeph 集群。

Usage: 用法：

```
microceph cluster [flags]
microceph cluster [command]
```

Available commands: 可用命令：

```
add         Generates a token for a new server
bootstrap   Sets up a new cluster
config      Manage Ceph Cluster configs
join        Joins an existing cluster
list        List servers in the cluster
migrate     Migrate automatic services from one node to another
remove      Removes a server from the cluster
sql         Runs a SQL query against the cluster database
```

Global options: 全局选项：

```
-d, --debug       Show all debug messages
-h, --help        Print help
    --state-dir   Path to store state information
-v, --verbose     Show all information messages
    --version     Print version number
```

## `add`

Generates a token for a new server
为新服务器生成令牌

Usage: 用法：

```
microceph cluster add <NAME> [flags]
```

## `bootstrap`

Sets up a new cluster
设置新集群

Usage: 用法：

```
microceph cluster bootstrap [flags]
```

Flags: 标志：

```
--microceph-ip    string Network address microceph daemon binds to.
--mon-ip          string Public address for bootstrapping ceph mon service.
--public-network  string Public network Ceph daemons bind to.
--cluster-network string Cluster network Ceph daemons bind to.
```

## `config`

Manages Ceph Cluster configs.
管理 Ceph 集群配置。

Usage: 用法：

```
microceph cluster config [flags]
microceph cluster config [command]
```

Available Commands: 可用命令：

```
get         Get specified Ceph Cluster config
list        List all set Ceph level configs
reset       Clear specified Ceph Cluster config
set         Set specified Ceph Cluster config
```

## `config get`

Gets specified Ceph Cluster config.
获取指定的 Ceph 集群配置。

Usage: 用法：

```
microceph cluster config get <key> [flags]
```

## `config list`

Lists all set Ceph level configs.
列出所有已设置的 Ceph 级别配置。

Usage: 用法：

```
microceph cluster config list [flags]
```

## `config reset`

Clears specified Ceph Cluster config.
清除指定的 Ceph Cluster 配置。

Usage: 用法：

```
microceph cluster config reset <key> [flags]
```

Flags: 标志：

```
--wait   Wait for required ceph services to restart post config reset.
```

## `config set`

Sets specified Ceph Cluster config.
设置指定的 Ceph 集群配置。

Usage: 用法：

```
microceph cluster config set <Key> <Value> [flags]
```

Flags: 标志：

```
--wait   Wait for required ceph services to restart post config set.
```

## `join`

Joins an existing cluster.
加入现有集群。

Usage: 用法：

```
microceph cluster join <TOKEN> [flags]
```

Flags: 标志：

```
--microceph-ip    string Network address microceph daemon binds to.
```

## `list`

Lists servers in the cluster.
列出群集中的服务器。

Usage: 用法：

```
microceph cluster list [flags]
```

## `migrate`

Migrates automatic services from one node to another.
将自动服务从一个节点迁移到另一个节点。

Usage: 用法：

```
microceph cluster migrate <SRC> <DST [flags]
```

## `remove`

Removes a server from the cluster.
从群集中删除服务器。

Syntax: 语法：

```
microceph cluster remove <NAME> [flags]
```

Flags: 标志：

```
-f, --force   Forcibly remove the cluster member
```

## `sql`

Runs a SQL query against the cluster database.
对群集数据库运行 SQL 查询。

Usage: 用法：

```
microceph cluster sql <query> [flags]
```

# `disable`

Disables a feature on the cluster
在集群上禁用功能

Usage: 用法：

```
microceph disable [flags]
microceph disable [command]
```

Available Commands: 可用命令：

```
rgw         Disable the RGW service on this node
```

Global flags: 全球标志：

```
-d, --debug       Show all debug messages
-h, --help        Print help
    --state-dir   Path to store state information
-v, --verbose     Show all information messages
    --version     Print version number
```

# `disk`

Manages disks in MicroCeph.
在 MicroCeph 中管理磁盘。

Usage: 用法：

```
microceph disk [flags]
microceph disk [command]
```

Available commands: 可用命令：

```
add         Add a Ceph disk (OSD)
list        List servers in the cluster
remove      Remove a Ceph disk (OSD)
```

Global flags: 全球标志：

```
-d, --debug       Show all debug messages
-h, --help        Print help
    --state-dir   Path to store state information
-v, --verbose     Show all information messages
    --version     Print version number
```

## `add`

Adds one or more new Ceph disks (OSDs) to the cluster, alongside optional devices for write-ahead logging and database management. The command takes arguments which is either one or more paths to block devices such as /dev/sdb, or a specification for loop files.
将一个或多个新的 Ceph 磁盘 （OSD） 添加到集群中，以及用于预写日志记录和数据库管理的可选设备。该命令接受参数，这些参数可以是阻止设备的一个或多个路径，例如 /dev/sdb，或者是循环文件的规范。

For block devices, add a space separated list of paths, e.g. “/dev/sda /dev/sdb …”. You may also add WAL and DB devices, but doing this is mutually exclusive with adding more than one OSD block device at a time.
对于块设备，添加一个以空格分隔的路径列表，例如“/dev/sda /dev/sdb ...”。您也可以添加 WAL 和 DB 设备，但这样做与一次添加多个 OSD 块设备是互斥的。

The specification for loop files is of the form loop,<size>,<nr>
循环文件的规范是 loop，，

size is an integer with M, G, or T suffixes for megabytes, gigabytes, or terabytes. nr is the number of file-backed loop OSDs to create. For instance, a spec of loop,8G,3 will create 3 file-backed OSDs, 8GB each.
size 是一个整数，带有 M、G 或 T 后缀，分别表示兆字节、千兆字节或兆兆字节。nr 是要创建的文件支持的循环 OSD 的数量。例如，loop，8G，3 的规格将创建 3 个文件支持的 OSD，每个 8GB。

Note that loop files can’t be used with encryption nor WAL/DB devices.
请注意，循环文件不能与加密或 WAL/DB 设备一起使用。

Usage: 用法：

```
microceph disk add <spec> [flags]
```

Flags: 标志：

```
--all-available       add all available devices as OSDs
--db-device string    The device used for the DB
--db-encrypt          Encrypt the DB device prior to use
--db-wipe             Wipe the DB device prior to use
--encrypt             Encrypt the disk prior to use (only block devices)
--wal-device string   The device used for WAL
--wal-encrypt         Encrypt the WAL device prior to use
--wal-wipe            Wipe the WAL device prior to use
--wipe                Wipe the disk prior to use
```

Note 注意

Only the data device is mandatory. The WAL and DB devices can improve performance by delegating the management of some subsystems to additional block devices. The WAL block device stores the internal journal whereas the DB one stores metadata. Using either of those should be advantageous as long as they are faster than the data device. WAL should take priority over DB if there isn’t enough storage for both.
只有数据设备是必需的。WAL 和 DB 设备可以通过将某些子系统的管理委托给其他块设备来提高性能。WAL  块设备存储内部日志，而数据库设备存储元数据。只要它们比数据设备更快，使用其中任何一个都应该是有利的。如果两者都没有足够的存储空间，WAL  应优先于 DB。

WAL and DB devices can only be used with data devices that reside on a block device, not with loop files. Loop files do not support encryption.
WAL 和 DB 设备只能与位于块设备上的数据设备一起使用，而不能与循环文件一起使用。循环文件不支持加密。

## `list`

List servers in the cluster
列出群集中的服务器

Usage: 用法：

```
microceph disk list [flags]
```

## `remove`

Removes a single disk from the cluster.
从群集中删除单个磁盘。

Usage: 用法：

```
microceph disk remove <osd-id> [flags]
```

Flags: 标志：

```
--bypass-safety-checks               Bypass safety checks
--confirm-failure-domain-downgrade   Confirm failure domain downgrade if required
--timeout int                        Timeout to wait for safe removal (seconds) (default: 300)
```

# `enable`

Enables a feature or service on the cluster.
在集群上启用功能或服务。

Usage: 用法：

```
microceph enable [flags]
microceph enable [command]
```

Available commands: 可用命令：

```
mds         Enable the MDS service on the --target server (default: this server)
mgr         Enable the MGR service on the --target server (default: this server)
mon         Enable the MON service on the --target server (default: this server)
rgw         Enable the RGW service on the --target server (default: this server)
```

Global flags: 全球标志：

```
-d, --debug       Show all debug messages
-h, --help        Print help
    --state-dir   Path to store state information
-v, --verbose     Show all information messages
    --version     Print version number
```

## `mds`

Enables the MDS service on the –target server (default: this server).
在 –target 服务器（默认：此服务器）上启用 MDS 服务。

Usage: 用法：

```
microceph enable mds [--target <server>] [--wait <bool>] [flags]
```

Flags: 标志：

```
--target string   Server hostname (default: this server)
--wait            Wait for mds service to be up. (default true)
```

## `mgr`

Enables the MGR service on the –target server (default: this server).
在 –target 服务器（默认：此服务器）上启用 MGR 服务。

Usage: 用法：

```
microceph enable mgr [--target <server>] [--wait <bool>] [flags]
```

Flags: 标志：

```
--target string   Server hostname (default: this server)
--wait            Wait for mgr service to be up. (default true)
```

## `mon`

Enables the MON service on the –target server (default: this server).
在 –target 服务器（默认：此服务器）上启用 MON 服务。

Usage: 用法：

```
microceph enable mon [--target <server>] [--wait <bool>] [flags]
```

Flags: 标志：

```
--target string   Server hostname (default: this server)
--wait            Wait for mon service to be up. (default true)
```

## `rgw`

Enables the RGW service on the –target server (default: this server).
在 –target 服务器（默认：此服务器）上启用 RGW 服务。

Usage: 用法：

```
microceph enable rgw [--port <port>] [--target <server>] [--wait <bool>] [flags]
```

Flags: 标志：

```
--port int        Service port (default: 80) (default 80)
--target string   Server hostname (default: this server)
--wait            Wait for rgw service to be up. (default true)
```

# `help`

Help provides help for any command in the application. Simply type microceph help [path to command] for full details.
帮助为应用程序中的任何命令提供帮助。只需键入 microceph help [命令路径] 即可获得完整详细信息。

Usage: 用法：

```
microceph help [command] [flags]
```

Global flags: 全球标志：

```
-d, --debug       Show all debug messages
-h, --help        Print help
    --state-dir   Path to store state information
-v, --verbose     Show all information messages
    --version     Print version number
```

# `init`

Initialises MicroCeph (in interactive mode).
初始化 MicroCeph（在交互模式下）。

Usage: 用法：

```
microceph init [flags]
```

Global flags: 全球标志：

```
-d, --debug       Show all debug messages
-h, --help        Print help
    --state-dir   Path to store state information
-v, --verbose     Show all information messages
    --version     Print version number
```

# `pool`

Manages pools in MicroCeph.
管理 MicroCeph 中的池。

Usage: 用法：

```
microceph pool [command]
```

Available commands: 可用命令：

```
set-rf      Set the replication factor for pools
```

Global flags: 全球标志：

```
-d, --debug       Show all debug messages
-h, --help        Print help
    --state-dir   Path to store state information
-v, --verbose     Show all information messages
    --version     Print version number
```

## `set-rf`

Sets the replication factor for one or more pools in the cluster. The command takes two arguments: The pool specification (a string) and the replication factor (an integer).
为群集中的一个或多个池设置复制因子。该命令有两个参数：池规范（字符串）和复制因子（整数）。

The pool specification can take one of three forms: Either a list of pools, separated by a space, in which case the replication factor is applied only to those pools (provided they exist). It can also be an asterisk (‘*’) in which case the process is applied to all existing pools; or an empty string (‘’), which sets the default pool size, but doesn’t change any existing pools.
池规范可以采用以下三种形式之一：要么是池的列表，用空格分隔，在这种情况下，复制因子仅应用于这些池（如果它们存在）。它也可以是星号 （'*'），在这种情况下，该过程将应用于所有现有池;或空字符串 （''），用于设置默认池大小，但不会更改任何现有池。

Usage: 用法：

```
microceph pool set-rf <pool-spec> <replication-factor>
```

# `status`

Reports the status of the cluster.
报告集群的状态。

Usage: 用法：

```
microceph status [flags]
```

Global flags: 全球标志：

```
-d, --debug       Show all debug messages
-h, --help        Print help
    --state-dir   Path to store state information
-v, --verbose     Show all information messages
    --version     Print version number
```

# `microceph` charm

#  魅力

The `microceph` charm is used to incorporate MicroCeph into Juju-managed deployments. It offers an alternative method for deploying and managing MicroCeph. In effect, the charm installs the `microceph` snap. As expected, it provides MicroCeph management via standard Juju commands (e.g. `juju config` and `juju run`).
`microceph` charm 用于将 MicroCeph 合并到 Juju 托管的部署中。它提供了一种部署和管理 MicroCeph 的替代方法。实际上，魅力安装了`小头快照`。正如预期的那样，它通过标准 Juju 命令（例如 `juju config` 和 `juju run）提供 MicroCeph` 管理。

For more information, see the [microceph](https://charmhub.io/microceph) entry on the Charmhub.
有关更多信息，请参阅 Charmhub 上的 [microceph](https://charmhub.io/microceph) 条目。

# Explanation

#  解释

Discussion and clarification of key topics
关键议题的讨论和澄清

- [Cluster network configurations
  集群网络配置](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/explanation/cluster-configurations/)
- [Cluster scaling 集群扩缩容](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/explanation/cluster-scaling/)
- [Full disk encryption 全盘加密](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/explanation/full-disk-encryption/)
- [Snap content interface for MicroCeph
  MicroCeph 的 Snap 内容接口](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/explanation/snap-content-interface/)

# Cluster network configurations

#  集群网络配置

## Overview

##  概述

Network configuration is critical for building a high performance Ceph Storage Cluster.
网络配置对于构建高性能 Ceph 存储集群至关重要。

Ceph clients make requests directly to Ceph OSD Daemons i.e. Ceph does not  perform request routing. The OSD Daemons perform data replication on  behalf of clients, which means replication and other factors impose  additional loads on Ceph Storage Cluster networks. Therefore, to enhance security and stability, it can be advantageous to split public and  cluster network traffic so that client traffic flows on a public net  while cluster traffic (for replication and backfilling) utilises a  separate net. This helps to prevent malicious or malfunctioning clients  from disrupting cluster backend operations.
Ceph 客户端直接向 Ceph OSD 守护进程发出请求，即 Ceph 不执行请求路由。OSD  守护进程代表客户端执行数据复制，这意味着复制和其他因素会给 Ceph  存储集群网络带来额外的负载。因此，为了增强安全性和稳定性，将公共网络流量和集群网络流量分开可能是有利的，这样客户端流量就会在公共网络上流动，而集群流量（用于复制和回填）则使用单独的网络。这有助于防止恶意或故障客户端中断集群后端操作。

For more details, refer to [Ceph Network Config](https://docs.ceph.com/en/latest/rados/configuration/network-config-ref/).
有关详细信息，请参阅 [Ceph 网络配置](https://docs.ceph.com/en/latest/rados/configuration/network-config-ref/)。

## Implementation

##  实现

MicroCeph cluster config subcommands rely on `ceph config` as the single source of truth for config values and for getting/setting the configs. After updating (setting/resetting) a config value, a  restart request is sent to other hosts on the MicroCeph cluster for  restarting particular daemons. This is done for the change to take  effect.
MicroCeph 集群配置子命令依赖 `ceph config` 作为配置值和获取/设置配置的单一事实来源。更新（设置/重置）配置值后，将向 MicroCeph 集群上的其他主机发送重启请求，以重启特定守护进程。执行此操作可使更改生效。

In a multi-node MicroCeph cluster, restarting the daemons is done  cautiously in a synchronous manner to prevent cluster outage. The flow  diagram below explains the order of execution.
在多节点 MicroCeph 集群中，需要谨慎地以同步方式重启守护进程，以防止集群中断。下面的流程图说明了执行顺序。

![../../_images/flow.jpg](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/_images/flow.jpg)

Execution flow of config set/reset commands in multi-node MicroCeph deployment


多节点 MicroCeph 部署中配置设置/重置命令的执行流程

# Cluster scaling

#  集群扩缩容

## Overview

##  概述

MicroCeph’s scalability is courtesy of its foundation on Ceph, which has excellent  scaling capabilities. To scale out, either add machines to the existing  cluster nodes or introduce additional disks (OSDs) on the nodes.
MicroCeph 的可扩展性得益于其基于 Ceph 的基础，Ceph 具有出色的扩展能力。若要横向扩展，请向现有群集节点添加计算机，或在节点上引入其他磁盘 （OSD）。

Note it is strongly recommended to use uniformly-sized machines,  particularly with smaller clusters, to ensure Ceph fully utilises all  available disk space.
请注意，强烈建议使用大小一致的机器，尤其是较小的集群，以确保 Ceph 充分利用所有可用的磁盘空间。

## Failure Domains

##  失败域

In the realm of Ceph, the concept of [failure domains](https://en.wikipedia.org/wiki/Failure_domain) comes into play in order to provide data safety. A failure domain is an entity or a category across which object replicas are spread. This  could be OSDs, hosts, racks, or even larger aggregates like rooms or  data centres. The key purpose of failure domains is to mitigate the risk of extensive data loss that could occur if a larger aggregate (e.g.  machine or rack) crashes or becomes otherwise unavailable.
在 Ceph 领域，[故障域](https://en.wikipedia.org/wiki/Failure_domain)的概念开始发挥作用，以提供数据安全性。故障域是对象副本分布在其中的实体或类别。这可能是 OSD、主机、机架，甚至是更大的聚合，如房间或数据中心。故障域的主要目的是降低在较大的聚合（例如计算机或机架）崩溃或以其他方式不可用时可能发生的大量数据丢失的风险。

This spreading of data or objects across various failure domains is managed  through the Ceph’s Controlled Replication Under Scalable Hashing ([CRUSH](https://docs.ceph.com/en/latest/rados/operations/crush-map/)) rules. The CRUSH algorithm enables Ceph to distribute data replicas  over various failure domains efficiently and without any central  directory, thus providing consistent performance as you scale.
这种数据或对象在各种故障域中的传播是通过 Ceph 的可扩展哈希下的受控复制 （[CRUSH）](https://docs.ceph.com/en/latest/rados/operations/crush-map/) 规则进行管理的。CRUSH 算法使 Ceph 能够在没有任何中央目录的情况下有效地将数据副本分布在各种故障域上，从而在扩展时提供一致的性能。

In simple terms, if one component within a failure domain fails, Ceph’s  built-in redundancy means your data is still accessible from an  alternate location. For instance, with a host-level failure domain, Ceph will ensure that no two replicas are placed on the same host. This  prevents loss of more than one replica should a host crash or get  disconnected. This extends to higher-level aggregates like racks and  rooms as well.
简单来说，如果故障域中的一个组件发生故障，Ceph 的内置冗余意味着您的数据仍然可以从备用位置访问。例如，对于主机级别的故障域，Ceph  将确保没有两个副本放置在同一主机上。这样可以防止在主机崩溃或断开连接时丢失多个副本。这也延伸到更高级别的聚合，如机架和房间。

Furthermore, the CRUSH rules ensure that data is automatically re-distributed if  parts of the system fail, assuring the resiliency and high availability  of your data.
此外，CRUSH 规则可确保在系统的某些部分发生故障时，数据会自动重新分发，从而确保数据的弹性和高可用性。

The flipside is that for a given replication factor and failure domain you  will need the appropriate number of aggregates. So for the default  replication factor of 3 and failure domain at host level you’ll need at  least 3 hosts (of comparable size); for failure domain rack you’ll need  at least 3 racks, etc.
另一方面，对于给定的复制因子和故障域，您将需要适当数量的聚合。因此，对于默认复制因子 3 和主机级别的故障域，您至少需要 3 个主机（大小相当）;对于故障域机架，您至少需要 3 个机架，等等。

## Failure Domain Management

##  故障域管理

MicroCeph implements automatic failure domain management at the OSD and host  levels. At the start, CRUSH rules are set for OSD-level failure domain.  This makes single-node clusters viable, provided they have at least 3  OSDs.
MicroCeph 在 OSD 和主机级别实现了自动故障域管理。开始时，为 OSD 级别的故障域设置 CRUSH 规则。这使得单节点集群可行，前提是它们至少有 3 个 OSD。

### Scaling Up

###  扩容

As you scale up, the failure domain automatically will be upgraded by  MicroCeph. Once the cluster size is increased to 3 nodes having at least one OSD each, the automatic failure domain shifts to the host level to  safeguard data even if an entire host fails. This upgrade typically will need some data redistribution which is automatically performed by Ceph.
随着规模的扩大，MicroCeph 将自动升级故障域。一旦集群大小增加到 3 个节点，每个节点至少有一个 OSD，自动故障域就会转移到主机级别，以保护数据，即使整个主机发生故障也是如此。此升级通常需要一些数据重新分发，该重新分发由 Ceph 自动执行。

### Scaling Down

###  缩减

Similarly, when scaling down the cluster by removing OSDs or nodes, the automatic  failure domain rules will be downgraded, from the host level to the osd  level. This is done once a cluster has less than 3 nodes with at least  one OSD each. MicroCeph will ask for confirmation if such a downgrade is necessary.
同样，当通过删除 OSD 或节点来缩减集群时，自动故障域规则将从主机级别降级到 osd 级别。如果集群的节点少于 3 个，每个节点至少有一个 OSD，则会执行此操作。MicroCeph 将要求确认是否有必要进行此类降级。

#### Disk removal

####  磁盘移除

The [disk](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/reference/commands/disk/) command (**disk remove**) is used to remove OSDs.
[disk](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/reference/commands/disk/) 命令（**disk remove**）用于删除 OSD。

##### Automatic failure domain downgrades

#####  自动故障域降级

The removal operation will abort if it would lead to a downgrade in failure domain. In such a case, the command’s `--confirm-failure-domain-downgrade` option overrides this behaviour and allows the downgrade to proceed.
如果删除操作会导致故障域降级，则该操作将中止。在这种情况下，命令的 `--confirm-failure-domain-downgrade` 选项会覆盖此行为并允许降级继续进行。

##### Cluster health and safety checks

#####  集群健康和安全检查

The removal operation will wait for data to be cleanly redistributed before evicting the OSD. There may be cases however, such as when a cluster is not healthy to begin with, where the redistribution of data is not feasible. In such situations, the command’s `--bypass-safety-checks` option disable these safety checks.
删除操作将等待数据完全重新分发，然后再逐出 OSD。但是，在某些情况下，例如，当集群一开始就不健康时，数据的重新分发是不可行的。在这种情况下，命令的 `--bypass-safety-checks` 选项会禁用这些安全检查。

Warning 警告

The `--bypass-safety-checks` option is intended as a last resort measure only. Its usage may result in data loss.
`--bypass-safety-checks` 选项仅作为最后的手段。它的使用可能会导致数据丢失。

### Custom Crush Rules

###  自定义粉碎规则

MicroCeph automatically manages two rules, named microceph_auto_osd and microceph_auto_host respectively; these two rules must not be changed. Users can however  freely set custom CRUSH rules anytime. MicroCeph will respect custom  rules and not perform any automatic updates for these. Custom CRUSH  rules can be useful to implement larger failure domains such as rack- or room-level. At the other end of the spectrum, custom CRUSH rules could  be used to enforce OSD-level failure domains for clusters larger than 3  nodes.
MicroCeph 自动管理两条规则，分别命名为 microceph_auto_osd 和 microceph_auto_host;这两条规则不能改变。但是，用户可以随时自由设置自定义 CRUSH 规则。MicroCeph 将遵循自定义规则，并且不会对这些规则执行任何自动更新。自定义 CRUSH  规则可用于实现更大的故障域，例如机架级或房间级。另一方面，自定义 CRUSH 规则可用于为大于 3 个节点的集群强制执行 OSD 级别的故障域。

## Machine Sizing

##  机器选型

Maintaining uniformly sized machines is an important aspect of scaling up  MicroCeph. This means machines should ideally have a similar number of  OSDs and similar disk sizes. This uniformity in machine sizing offers  several advantages:
保持统一大小的机器是扩大 MicroCeph 规模的一个重要方面。这意味着理想情况下，计算机应具有相似数量的 OSD 和相似的磁盘大小。这种机器尺寸的均匀性提供了几个优点：

1. Balanced Cluster: Having nodes with a similar configuration drives a balanced  distribution of data and load in the cluster. It ensures all nodes are  optimally performing and no single node is overstrained, enhancing the  cluster’s overall efficiency.
   平衡集群：具有相似配置的节点可驱动集群中数据和负载的均衡分布。它确保所有节点都处于最佳性能，并且没有单个节点过度疲劳，从而提高了集群的整体效率。
2. Space Utilisation: With similar sized machines, Ceph can optimally use all  available disk space rather than having some remain underutilised and  hence wasted.
   空间利用率：使用类似大小的机器，Ceph 可以最佳地利用所有可用的磁盘空间，而不是让一些磁盘空间未得到充分利用，从而浪费掉。
3. Easy Management: Uniform machines are simpler to manage as each has similar capabilities and resource needs.
   易于管理：统一的机器更易于管理，因为每台机器都有相似的功能和资源需求。

As an example, consider a cluster with 3 nodes with host-level failure  domain and replication factor 3, where one of the nodes has significant  lower disk space available. That node would effectively bottleneck  available disk space, as Ceph needs to ensure one replica of each object is placed on each machine (due to the host-level failure domain).
例如，考虑一个具有 3 个节点的集群，这些节点具有主机级故障域和复制因子 3，其中一个节点的可用磁盘空间明显较低。该节点将有效地限制可用磁盘空间的瓶颈，因为 Ceph 需要确保在每台机器上放置每个对象的一个副本（由于主机级别的故障域）。

# Full disk encryption

#  全盘加密

## Overview

##  概述

MicroCeph supports automatic full disk encryption (FDE) on OSDs.
MicroCeph 支持 OSD 上的自动全盘加密 （FDE）。

Full disk encryption is a security measure that protects the data on a  storage device by encrypting all the information on the disk. FDE helps  maintain data confidentiality in case the disk is lost or stolen by  rendering the data inaccessible without the correct decryption key or  password.
全磁盘加密是一种安全措施，它通过加密磁盘上的所有信息来保护存储设备上的数据。FDE 通过使数据在没有正确的解密密钥或密码的情况下无法访问，从而在磁盘丢失或被盗的情况下帮助维护数据机密性。

In the event of disk loss or theft, unauthorised individuals are unable to access the encrypted data, as the encryption renders the information  unreadable without the proper credentials. This helps prevent data  breaches and protects sensitive information from being misused.
如果磁盘丢失或被盗，未经授权的个人将无法访问加密数据，因为如果没有适当的凭据，加密会使信息无法读取。这有助于防止数据泄露，并防止敏感信息被滥用。

FDE also eliminates the need for wiping or physically destroying a disk  when it is replaced, as the encrypted data remains secure even if the  disk is no longer in use. The data on the disk is effectively rendered  useless without the decryption key.
FDE 还消除了在更换磁盘时擦除或物理销毁磁盘的需要，因为即使磁盘不再使用，加密数据也仍然是安全的。如果没有解密密钥，磁盘上的数据实际上将变得无用。

## Implementation

##  实现

Full disk encryption for OSDs has to be requested when adding disks.  MicroCeph will then generate a random key, store it in the Ceph cluster  configuration, and use it to encrypt the given disk via [LUKS/cryptsetup](https://gitlab.com/cryptsetup/cryptsetup/-/wikis/home).
添加磁盘时，必须请求对 OSD 进行全磁盘加密。然后，MicroCeph 将生成一个随机密钥，将其存储在 Ceph 集群配置中，并使用它来通过 [LUKS/cryptsetup](https://gitlab.com/cryptsetup/cryptsetup/-/wikis/home) 加密给定的磁盘。

## Prerequisites

##  先决条件

To use FDE, the following prerequisites must be met:
要使用 FDE，必须满足以下先决条件：

- The installed snapd daemon version must be >= 2.59.1
  已安装的 snapd 守护程序版本必须为 >= 2.59.1

- The `dm-crypt` kernel module must be available. Note that some cloud-optimised kernels do not ship dm-crypt by default. Check by running 
  `dm-crypt` 内核模块必须可用。请注意，默认情况下，一些云优化的内核不会提供 dm-crypt。通过运行进行检查`sudo modinfo dm-crypt`

- The snap dm-crypt plug has to be connected, and `microceph.daemon` subsequently restarted:
  必须连接 snap dm-crypt 插头，然后`重新启动 microceph.daemon`：

  ```
  sudo snap connect microceph:dm-crypt
  sudo snap restart microceph.daemon
  ```

## Limitations

##  限制

**Warning: 警告：**

- It is important to note that MicroCeph FDE *only* encompasses OSDs. Other data, such as state information for monitors, logs, configuration etc., will *not* be encrypted by this mechanism.
  需要注意的是，MicroCeph FDE *仅*包含 OSD。其他数据，例如监视器的状态信息、日志、配置等，不会通过此机制进行加密。
- Also note that the encryption key will be stored on the Ceph monitors as part of the Ceph key/value store
  另请注意，加密密钥将作为 Ceph 键/值存储的一部分存储在 Ceph 监视器上

## Usage

##  用法

FDE for OSDs is activated by passing the optional `--encrypt` flag when adding disks:
通过在添加磁盘时传递可选的 `--encrypt` 标志来激活 OSD 的 FDE：

```
sudo microceph disk add /dev/sdx --wipe --encrypt
```

Note there is no facility to encrypt an OSD that is already part of the  cluster. To enable encryption you will have to take the OSD disk out of  the cluster, ensure data is replicated and the cluster converged and is  healthy, and then re-introduce the OSD with encryption.
请注意，没有用于加密已属于集群一部分的 OSD 的工具。要启用加密，您必须将 OSD 磁盘从集群中取出，确保数据已复制且集群收敛且运行正常，然后重新引入带有加密功能的 OSD。

# Snap content interface for MicroCeph

#  MicroCeph 的 Snap 内容接口

## Overview

##  概述

Snap content interfaces enable access to a particular directory from a producer snap. The MicroCeph `ceph-conf` content interface is designed to facilitate access to MicroCeph’s  configuration and credentials. This interface includes information about MON addresses, enabling a consumer snap to connect to the MicroCeph  cluster using this data.
快照内容接口允许从创建者快照访问特定目录。MicroCeph `ceph-conf` 内容接口旨在方便访问 MicroCeph 的配置和凭证。此接口包含有关 MON 地址的信息，使使用者快照能够使用此数据连接到 MicroCeph 集群。

Additionally, the `ceph-conf` content interface also provides version information of the running Ceph software.
此外，`ceph-conf` 内容接口还提供正在运行的 Ceph 软件的版本信息。

## Usage

##  用法

The usage of the `ceph-conf` interface revolves around providing the consuming snap access to necessary configuration details.
`ceph-conf` 接口的使用围绕着提供对必要配置详细信息的消耗性 snap 访问。

Here is how it can be utilised:
以下是如何使用它：

- Connect to the `ceph-conf` content interface to gain access to MicroCeph’s configuration and credentials.
  连接到 `ceph-conf` 内容接口，获取对 MicroCeph 配置和凭证的访问权限。
- The interface exposes a standard `ceph.conf` configuration file as well Ceph keyrings with administrative privileges.
  该接口公开了一个标准的 `ceph.conf` 配置文件以及具有管理权限的 Ceph 密钥环。
- Use the MON addresses included in the configuration to connect to the MicroCeph cluster.
  使用配置中包含的 MON 地址连接到 MicroCeph 集群。
- The interface provides version information that can be used to set up version-specific clients.
  该接口提供可用于设置特定于版本的客户端的版本信息。

To connect the `ceph-conf` content interface to a consumer snap, use the following command:
要将 `ceph-conf` 内容接口连接到使用者快照，请使用以下命令：

```
snap connect <consumer-snap-name>:ceph-conf microceph:ceph-conf
```

Replace `<consumer-snap-name>` with the name of your consumer snap. Once executed, this command  establishes a connection between the consumer snap and the MicroCeph `ceph-conf` interface.
将 `<consumer-snap-name>` 替换为您的使用者快照的名称。执行后，此命令将在使用者 snap 和 MicroCeph `ceph-conf` 接口之间建立连接。