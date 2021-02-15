# Cephadm

[TOC]

Cephadm is a new feature in the Octopus release and has seen limited use in production and at scale.  We would like users to try cephadm, especially for new clusters, but please be aware that some functionality is still rough around the edges.  We expect fairly frequent updates and improvements over the first several bug fix releases of Octopus.

Cephadm是Octopus版本中的新功能，在生产和大规模使用中受到限制。我们希望用户尝试使用cephadm，尤其是对于新集群，但是请注意，某些功能仍然很粗糙。我们希望对Octopus的前几个错误修复版本进行相当频繁的更新和改进。 

Cephadm management of the following components are currently well-supported:

- Monitors
- Managers
- OSDs
- CephFS file systems
- rbd-mirror

The following components are working with cephadm, but the documentation is not as complete as we would like, and there may be some changes in the near future:

- RGW
- dmcrypt OSDs

Cephadm support for the following features is still under development:

- NFS
- iSCSI

If you run into problems, you can always pause cephadm with 如果遇到问题，您可以随时通过以下方式暂停cephadm:

```bash
ceph orch pause
```

或使用以下方法完全关闭cephadm： 

Or turn cephadm off completely with:

```bash
ceph orch set backend ''
ceph mgr module disable cephadm
```

**特性：**

- **将所有组件部署在容器中。**
- **与Orchestrator API紧密集成。** `Ceph`的`Orchestrator`界面在`cephadm`的开发过程中得到了广泛的发展，以匹配实现并清晰地抽象出`Rook`中存在的（略有不同）功能。最终结果是不管是看起来还是感觉都像`Ceph`的一部分。
- **不依赖管理工具。**
- **最小的操作系统依赖性。** `Cephadm`需要`Python 3`，`LVM`和`container runtime`（`Podman`或`Docker`）。
- **将群集彼此隔离。** 支持多个`Ceph`集群同时存在于同一主机上一直是一个比较小众的场景，但是确实存在，并且以一种健壮，通用的方式将集群彼此隔离，这使得测试和重新部署集群对于开发人员和用户而言都是安全自然的过程。
- **自动升级。** 一旦`Ceph`“拥有”自己的部署方式，它就可以以安全和自动化的方式升级`Ceph`。
- **从“传统”部署工具轻松迁移。** 

Cephadm deploys and manages a Ceph cluster by connection to hosts from the manager daemon via SSH to add, remove, or update Ceph daemon containers. Cephadm 通过管理器守护程序通过SSH连接到主机来部署和管理Ceph集群，以添加，删除或更新Ceph守护程序容器。 

Cephadm manages the full lifecycle of a Ceph cluster.  It starts by bootstrapping a tiny Ceph cluster on a single node (one monitor and one manager) and then uses the orchestration interface (“day 2” commands) to expand the cluster to include all hosts and to provision all Ceph daemons and services.  This can be performed via the Ceph command-line interface (CLI) or dashboard (GUI).Cephadm管理Ceph集群的整个生命周期。首先从在单个节点（一个监视器和一个管理器）上引导一个微小的Ceph群集开始，然后使用业务流程界面（“ day 2”命令）将群集扩展为包括所有主机，并提供所有Ceph守护程序和服务。这可以通过Ceph命令行界面（CLI）或仪表板（GUI）执行。 

Cephadm is new in the Octopus v15.2.0 release and does not support older versions of Ceph.Cephadm是Octopus v15.2.0版本中的新增功能，并且不支持旧版本的Ceph。

## 安装 cephadm
几种安装方法：

- 使用`curl`来获取独立脚本的最新版本:

  ```bash
  curl --silent --remote-name --location https://github.com/ceph/ceph/raw/octopus/src/cephadm/cephadm
  chmod +x cephadm
  ```

  This script can be run directly from the current directory with可以使用以下命令直接从当前目录运行此脚本:

  ```bash
  ./cephadm <arguments...>
  ```

- Although the standalone script is sufficient to get a cluster started, it is convenient to have the `cephadm` command installed on the host.  To install these packages for the current Octopus release 尽管独立脚本足以启动集群，但是在主机上安装cephadm命令很方便。要为当前的Octopus版本安装这些软件包:

  ```bash
  ./cephadm add-repo --release octopus
  ./cephadm install
  ```

  Confirm that `cephadm` is now in your PATH with:

  ```bash
  which cephadm
  ```

- 某些商业Linux发行版（例如RHEL，SLE）可能已经包含最新的Ceph软件包。在这种情况下，您可以直接安装cephadm。

  ```bash
  dnf install -y cephadm
  zypper install -y cephadm
  ```

## Bootstrap

`cephadm`模型有一个简单的“ `Bootstrap` ”步骤，从命令行启动，该命令行在本地主机上启动一个最小的`Ceph`群集（一个`monitor` 与 `manager` 守护程序）。然后，使用`orchestrator`命令部署集群的其余部分，以添加其他主机，使用存储设备并为集群服务部署守护程序。

## 管理Ceph monitor, manager和其他守护程序

`Cephadm`中的每个服务或守护进程集合都有一个相关的 *`placement` 规范*，或者描述应该在哪里部署守护程序以及部署多少守护程序。默认情况下，带有`cephadm`的新`Ceph`集群知道集群应该在每个主机上部署5个`monitor`、2个`manager`和一些其他服务（如`crash dump collector`）。新的`monitor`和`manager`会在向群集添加其他主机后自动部署。您可以使用`ceph orch ls`和`ceph orch ps`命令查看新的集群服务和已部署的守护程序：

> ```php
> # ceph orch lsNAME           RUNNING  REFRESHED  AGE  PLACEMENT  IMAGE NAME                           IMAGE ID      alertmanager       1/1  71s ago    22m  count:1    docker.io/prom/alertmanager:latest   0881eb8f169f  crash              1/1  71s ago    23m  *          docker.io/ceph/ceph:v15              204a01f9b0b6  grafana            1/1  71s ago    22m  count:1    docker.io/ceph/ceph-grafana:latest   87a51ecf0b1c  mgr                1/2  71s ago    23m  count:2    docker.io/ceph/ceph:v15              204a01f9b0b6  mon                1/5  71s ago    23m  count:5    docker.io/ceph/ceph:v15              204a01f9b0b6  node-exporter      1/1  71s ago    22m  *          docker.io/prom/node-exporter:latest  e5a616e4b9cf  prometheus         1/1  71s ago    22m  count:1    docker.io/prom/prometheus:latest     e935122ab143  # ceph orch psNAME                HOST  STATUS         REFRESHED  AGE  VERSION  IMAGE NAME                           IMAGE ID      CONTAINER ID  alertmanager.gnit   gnit  running (21m)  96s ago    22m  0.20.0   docker.io/prom/alertmanager:latest   0881eb8f169f  15ceff5ae935  crash.gnit          gnit  running (22m)  96s ago    23m  15.2.0   docker.io/ceph/ceph:v15              204a01f9b0b6  0687711365e4  grafana.gnit        gnit  running (21m)  96s ago    22m  6.6.2    docker.io/ceph/ceph-grafana:latest   87a51ecf0b1c  fa1db4647c4c  mgr.gnit.xmfvjy     gnit  running (24m)  96s ago    24m  15.2.0   docker.io/ceph/ceph:v15              204a01f9b0b6  6a29bc868357  mon.gnit            gnit  running (24m)  96s ago    24m  15.2.0   docker.io/ceph/ceph:v15              204a01f9b0b6  072f5926faa8  node-exporter.gnit  gnit  running (22m)  96s ago    22m  0.18.1   docker.io/prom/node-exporter:latest  e5a616e4b9cf  eb5f715005fc  prometheus.gnit     gnit  running (22m)  96s ago    22m  2.16.0   docker.io/prom/prometheus:latest     e935122ab143  6ee6de1b3cc1  
> ```

在上面的示例输出中，您会注意到部署了许多非`Ceph`守护程序：`Prometheus`，`Grafana`，`alertmanager`和`node-exporter`。它们提供了一个基本但配置完整且功能齐全的监视堆栈，该堆栈允许`Ceph Dashboard`的所有指标和图形都可以立即使用。如果您已经希望`Ceph`使用的现有的`Prometheus`，则可以通过传递`--skip-monitoring-stack`给`bootstrap`命令来告诉`cephadm`跳过这些。

对于大多数用户来说，这种默认行为就是您所需要的。对于想要精确控制在哪些主机上部署`monitor`或选择具体`IP`的高级用户，需要一些附加步骤来定制这些守护程序的位置。甚至可以完全禁用特定服务（如`monitor`）的自动分布，尽管这样做的理由相对较少。

一旦集群开始运行，一个最小但足够的`ceph.conf`访问群集的主机的文件可以通过以下方式获取：

> ```php
> # ceph config generate-minimal-conf
> ```



## 部署存储服务

其他`Ceph`守护程序是无状态的，这意味着它们不会在本地存储任何数据，并且可以在任何主机上轻松地重新部署。这些对于`cephadm`来说很容易……对于`CephFS`，它们的部署是完全自动化的。例如，创建一个名为的`CephFS`文件系统`foo`

> ```php
> ceph fs volume create foo
> ```

将创建必要的数据和元数据池，并一步一步部署`MDS`守护程序。守护程序的数量和位置可以在以后通过`ceph orch ls`和`ceph orch apply mds ...`命令进行检查和调整，或者可以将可选的`placement`参数传递给`volume create`命令。

对于使用`RGW`的对象存储，事情还没有完全简化，但是`orchestrator`和`cephadm`可以用来管理底层守护进程。对于独立对象存储群集：

> ```php
> radosgw-admin realm create --rgw-realm=myorg --defaultradosgw-admin zonegroup create --rgw-zonegroup=default --master --defaultradosgw-admin zone create --rgw-zonegroup=default --rgw-zone=us-east-1 --master --defaultceph orch apply rgw myorg us-east-1
> ```

对于现有（`multi-site`或`standalone`）部署，部署守护程序可以像`ceph orch apply rgw<realmname><zonename>`一样简单，前提是`rgw`配置选项已存储在群集的配置数据库（`ceph config set client.rgw.$realmname.$zonename ...`）中而不是`ceph.conf`文件。

## 升级

一旦部署了新集群（或升级并转换了现有集群），`cephadm`的最佳功能之一就是它能够自动执行升级。在大多数情况下，这很简单：

> ```php
> ceph orch upgrade start --ceph-version 15.2.1
> ```

可以从`ceph status`命令监视升级进度，该命令的输出将包含一个进度条，例如：

> ```php
> Upgrade to docker.io/ceph/ceph:v15.2.1 (3m)   [===.........................] (remaining: 21m)
> ```

## 注意点

能够更深入地了解`cephadm`在后台运行以在远程主机上运行服务是非常有帮助的。首先，您可以使用`podman ps`或`docker ps`查看容器。您会注意到所有容器的名称中都有集群`fsid UUID`，这样多个集群就可以出现在同一个主机上，而不会相互冲突。（除守护进程使用固定端口（如`Ceph monitor`）或`prometheus node-exporter`之类的命令外。）

这些文件也都是单独的。在`/var/lib/ceph`和`/var/log/ceph`中，您将发现由集群`fsid`分隔开的内容。并且在每个守护程序目录中，您都会看到一个名为`unit.run`的文件，该文件具有启动守护程序的`docker`或`podman`命令——这就是`systemd`执行的操作。

尽管您可能还记得`Bootstrap`步骤将文件写入`/etc/ceph`，但它这样做只是为了方便，这样在主机上单个集群的常见情况下，只需安装`ceph common`包就可以让`ceph CLI`正常工作。传递`--output-dir`（或类似方式）引导程序会将这些文件写入其他位置。

事实上，主机操作系统唯一的其他变化是：

- `/etc/systemd/system`为每个集群（`ceph-$fsid.target`对于`ceph-$fsid@.service`所有守护程序共享的每个集群）写入的`systemd`文件
- `ceph.target`启动/停止*所有* `Ceph`服务
- `logrotate`文件位于`/etc/logrotate.d/ceph-$fsid`，以防启用了对文件的日志记录。（默认情况下，`cephadm`守护进程将日志记录到`stderr`，并由容器运行时捕获日志。）

同时，在`ceph-mgr`守护程序中运行的`cephadm`模块可以更改。通过`Orchestrator`界面配置服务，可以通过内部`Python`界面（例如，`Dashboard`）或`CLI`进行访问。要查看所有可用命令，请尝试`ceph orch -h`。 `ceph orch ls`特别是将描述当前配置的服务。

在后台，`cephadm`具有“`reconciliation loop`”，就像`Kubernetes`一样，该`loop`将当前状态与所需状态进行比较，这由配置的服务指定。要监视其活动，`ceph -W cephadm`将实时显示正在输出的最后的日志，或`ceph log last cephadm`显示最近的消息。这个后台工作可以在任何时候用`ceph orch pause`暂停，使用`ceph orch resume`继续。