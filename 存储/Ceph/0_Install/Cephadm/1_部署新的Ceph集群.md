# 部署新的Ceph集群 

[TOC]

## Bootstrap

创建新的 ceph 群集的第一步是在群集的第一个主机上运行 `cephadm bootstrap` 命令。该命令创建了 Ceph 群集的第一个 MON 。

```bash
# 将 Ceph 集群的第一个主机的 IP 传递给 Ceph bootstrap 命令。
cephadm bootstrap --mon-ip <mon-ip> --cluster-network <cluster_network>
```

这个命令将执行如下操作：

- 在本地主机上为新集群创建 MON  和 MGR 。
- 为 Ceph 集群生成一个新的 SSH 密钥，并将其添加到 root 用户的 `/root/.ssh/authorized_keys` 文件中。
- 将公钥的副本写入 `/etc/ceph/ceph.pub` 。
- 将最小配置写入文件 `/etc/ceph/ceph.conf` 中 。与新群集通讯需要该文件。
- 将 `client.admin` 管理（特权）密钥的副本写入 `/etc/ceph/ceph.client.admin.keyring` 。 
- 将 `_admin` 标签添加到引导主机。默认情况下，具有此标签的任何主机都将（同时）获得 `/etc/ceph/ceph.conf` 和 `/etc/ceph/ceph.client.admin.keyring` 的副本。
- 使用 prometheus 、grafana 和其他工具（如 `node-exporter` 和 `alert-manager`）部署基本的监控堆栈。

若干时间后，最小的 `Ceph` 集群将启动并运行，并且 `cephadm` 将打印出命令以访问 `Ceph CLI`（通过容器化`shell`）和 `URL` 来访问 `dashboard` ：

```bash
INFO:cephadm:Ceph Dashboard is now available at:
		     URL: https://gnit:8443/
            User: admin
        Password: 07j394z550

INFO:cephadm:You can access the Ceph CLI with:
		sudo ./cephadm shell --fsid 2d2fd136-6df1-11ea-ae74-002590e526e8 -c /etc/ceph/ceph.conf -k /etc/ceph/ceph.client.admin.keyring

INFO:cephadm:Bootstrap complete.
```


### 命令选项

运行 `cephadm bootstrap -h` 查看所有可用选项。

- 默认情况下，Ceph 守护进程将其日志输出发送到 stdout / stderr ，由容器 runtime（docker 或 podman）获取，并（在大多数系统上）发送到 journald 。如果希望 Ceph 将传统的日志文件写入 `/var/log/Ceph/$fsid`，在引导过程中使用 `--log-to-file` 选项。

- 当（ Ceph 集群外部）公共网络流量与（ Ceph 集群内部）集群流量分离时，较大的 Ceph 集群性能更好。内部集群通信处理 OSD 守护进程之间的复制、恢复和心跳。可以通过向 bootstrap 子命令提供 `--cluster-network` 选项来定义集群网络。此参数必须以 CIDR 表示法定义子网（例如 `10.90.90.0/24` 或 `fe80::/64`）。

- `cephadm bootstrap` 将访问新集群所需的文件写入 `/etc/ceph` 。这个中心位置使得安装在主机上的 Ceph 包（例如，允许访问 cephadm 命令行接口的包）能够找到这些文件。

  然而，用 cephadm 部署的 Daemon container 根本不需要 `/etc/ceph` 。使用 `--output-dir <directory>` 选项将它们放在不同的目录中。这可能有助于避免与同一主机上现有的 Ceph 配置（ cephadm 或其他配置）发生冲突。

- 可以将任何初始化 Ceph 的配置选项放到一个标准的 ini 样式的配置文件中，使用 `--config <config-file>` 传递给新的集群。例如：

  ```bash
  cat << EOF > initial-ceph.conf
  [global]
  osd crush chooseleaf type = 0
  EOF
  
  ./cephadm bootstrap --config initial-ceph.conf ...
  ```
  
- 使用 `--ssh-user <user>` 选项，指定 cephadm 连接到主机时，选择使用哪个 ssh 用户。相关的 ssh 密钥将被添加到 `/home/<user>/.ssh/authorized_keys` 中。使用此选项指定的用户，必须具有无密码 sudo 访问权限。

- If you are using a container on an authenticated registry that requires login如果在需要登录的经过身份验证的 registry 上使用容器，则可以添加参数：

  ```bash
  --registry-json <path to json file>
  ```
  
  带有登录信息的 JSON 文件的示例内容：
  
  ```json
  {"url":"REGISTRY_URL", "username":"REGISTRY_USERNAME", "password":"REGISTRY_PASSWORD"}
  ```
  
  Cephadm 将尝试登录到这个 registry ，以便可以 pull your container 并且将登录信息存储在它的配置数据库中。添加到集群中的其他主机也将能够使用经过身份验证的 registry 。

| 选项                                                      | 描述                                                         |
| --------------------------------------------------------- | ------------------------------------------------------------ |
| --config *CONFIG-FILE*, -c *CONFIG-FILE*                  | *CONFIG-FILE* 是 bootsrap 命令使用的 `ceph.conf` 文件        |
| --mon-id *MON-ID*                                         | 在名为 *MON-ID* 的主机上引导。默认值为本地主机。             |
| --mon-addrv *MON-ADDRV*                                   | mon IPs (例如 [v2:localipaddr:3300,v1:localipaddr:6789])     |
| --mon-ip *IP-ADDRESS*                                     | 用于运行 `cephadm bootstrap` 的节点的 IP 地址。              |
| --mgr-id *MGR_ID*                                         | 安装 MGR 节点的主机 ID。默认：随机生成。                     |
| --fsid *FSID*                                             | 集群 FSID                                                    |
| --output-dir *OUTPUT_DIR*                                 | 使用此目录编写配置、密钥环和公钥文件。                       |
| --output-keyring *OUTPUT_KEYRING*                         | 使用这个位置使用新的集群管理员和 mon 密钥编写密钥环文件。    |
| --output-config *OUTPUT_CONFIG*                           | 写入用于连接到新集群的配置文件的位置。                       |
| --output-pub-ssh-key *OUTPUT_PUB_SSH_KEY*                 | 用于集群的公共 SSH 公钥的写入位置。                          |
| --skip-ssh                                                | 跳过本地主机上 ssh 密钥的设置。                              |
| --initial-dashboard-user *INITIAL_DASHBOARD_USER*         | 仪表板的初始用户.                                            |
| --initial-dashboard-password *INITIAL_DASHBOARD_PASSWORD* | 仪表板初始用户的初始密码.                                    |
| --ssl-dashboard-port *SSL_DASHBOARD_PORT*                 | 用于使用 SSL 与控制面板连接的端口号。                        |
| --dashboard-key *DASHBOARD_KEY*                           | 仪表板密钥。                                                 |
| --dashboard-crt *DASHBOARD_CRT*                           | 仪表板证书。                                                 |
| --ssh-config *SSH_CONFIG*                                 | SSH 配置。                                                   |
| --ssh-private-key *SSH_PRIVATE_KEY*                       | SSH 私钥。                                                   |
| --ssh-public-key *SSH_PUBLIC_KEY*                         | SSH 公钥。                                                   |
| --ssh-user *SSH_USER*                                     | 设置用于与集群主机的 SSH 连接的用户。非 root 用户需要免密码 sudo。 |
| --skip-mon-network                                        | 根据 bootstrap mon ip 设置 mon public_network。              |
| --skip-dashboard                                          | 不要启用 Ceph 仪表板。                                       |
| --dashboard-password-noupdate                             | 禁用强制仪表板密码更改。                                     |
| --no-minimize-config                                      | 不要模拟和最小化配置文件。                                   |
| --skip-ping-check                                         | 不验证 mon IP 是否可 ping 通。                               |
| --skip-pull                                               | 在 bootstrapping 前不要拉取最新的镜像。                      |
| --skip-firewalld                                          | 不配置 firewalld。                                           |
| --allow-overwrite                                         | 允许覆盖现有的 -output-* config/keyring/ssh 文件。           |
| --allow-fqdn-hostname                                     | 允许完全限定主机名。                                         |
| --skip-prepare-host                                       | 不准备主机。                                                 |
| --orphan-initial-daemons                                  | 不创建初始 mon、mgr 和崩溃服务规格。                         |
| --skip-monitoring-stack                                   | 不自动置备监控堆栈（prometheus、grafana、alertmanager、node-exporter）。 |
| --apply-spec *APPLY_SPEC*                                 | 在 bootstrap 后应用集群 spec 文件（复制 ssh 密钥、添加主机和应用服务）。 |
| --registry-url *REGISTRY_URL*                             | 指定要登录的自定义 registry 的 URL。例如： `registry.redhat.io`。 |
| --registry-username *REGISTRY_USERNAME*                   | 到自定义 registry 的登录帐户的用户名。                       |
| --registry-password *REGISTRY_PASSWORD*                   | 到自定义 registry 的登录帐户的密码。                         |
| --registry-json *REGISTRY_JSON*                           | 包含 registry 登录信息的 JSON 文件。                         |

## 启用 Ceph CLI

Cephadm 不需要再本地安装任何 Ceph 软件包。有几种与新群集进行交互的方法：

- `cephadm shell` 命令在安装了所有 Ceph 包的容器中启动一个 bash shell。默认情况下，如果在主机上的 `/etc/ceph` 中找到配置和密钥环文件，则将它们传递到容器环境中，以便 shell 完全正常运行。注意，在 MON 主机上执行时，`cephadm shell` 将从 MON 容器推断配置，而不是使用默认配置。如果给定了 `--mount <path>` ，则主机  `<path>`（文件或目录）将出现在容器内的 `/mnt` 下：

  ```bash
  cephadm shell
  ```

- 要执行 `ceph` 命令，还可以运行如下命令：

  ```bash
  cephadm shell -- ceph -s
  ```

- 可以安装 `ceph-common` 软件包，其中包含所有 ceph 命令，包括 `ceph`，`rbd`，`mount.ceph`（用于安装 CephFS 文件系统）等：

  ```bash
  cephadm add-repo --release quincy
  cephadm install ceph-common
  ```

如果遇到问题，您可以随时通过以下方式暂停cephadm:

```bash
ceph orch pause
```

或使用以下方法完全关闭cephadm

```bash
ceph orch set backend ''
ceph mgr module disable cephadm
```

## Ceph集群扩展

### 添加主机

详见文档 [1_主机管理.md](../../1_主机管理.md)

### 部署 MON

详见文档 [3_MON.md](../../3_MON.md)

### 部署 MGR

详见文档 [MGR.md](../../MGR.md)

### 部署 OSD

详见文档 [5_OSD.md](../../5_OSD.md)

### 部署 MDS 

详见文档 [7_CephFS.md](../../7_CephFS.md)

### 部署 RGW 

详见文档 [6_RGW.md](../../6_RGW.md)

### 部署 NFS ganesha

详见文档 [8_NFS.md](../../8_NFS.md)

### 部署 iSCSI

详见文档 [10_iSCSI.md](../../10_iSCSI.md)

### 部署自定义容器 

It is also possible to choose different containers than the default containers to deploy Ceph. See [Ceph Container Images](https://docs.ceph.com/docs/master/install/containers/#containers) for information about your options in this regard.也可以选择与默认容器不同的容器来部署Ceph。有关这方面选项的信息，请参阅Ceph容器映像。

## 管理Ceph monitor, manager和其他守护程序

`Cephadm`中的每个服务或守护进程集合都有一个相关的 *`placement` 规范*，或者描述应该在哪里部署守护程序以及部署多少守护程序。默认情况下，带有`cephadm`的新`Ceph`集群知道集群应该在每个主机上部署5个`monitor`、2个`manager`和一些其他服务（如`crash dump collector`）。新的`monitor`和`manager`会在向群集添加其他主机后自动部署。您可以使用`ceph orch ls`和`ceph orch ps`命令查看新的集群服务和已部署的守护程序：

 ```bash
 ceph orch ls
     
 NAME           RUNNING  REFRESHED  AGE  PLACEMENT  IMAGE NAME                           IMAGE ID      alertmanager       1/1  71s ago    22m  count:1    docker.io/prom/alertmanager:latest   0881eb8f169f  crash              1/1  71s ago    23m  *          docker.io/ceph/ceph:v15              204a01f9b0b6  grafana            1/1  71s ago    22m  count:1    docker.io/ceph/ceph-grafana:latest   87a51ecf0b1c  mgr                1/2  71s ago    23m  count:2    docker.io/ceph/ceph:v15              204a01f9b0b6  mon                1/5  71s ago    23m  count:5    docker.io/ceph/ceph:v15              204a01f9b0b6  node-exporter      1/1  71s ago    22m  *          docker.io/prom/node-exporter:latest  e5a616e4b9cf  prometheus         1/1  71s ago    22m  count:1    docker.io/prom/prometheus:latest     e935122ab143
     
 ceph orch ps
 
 NAME                HOST  STATUS         REFRESHED  AGE  VERSION  IMAGE NAME                           IMAGE ID      CONTAINER ID  alertmanager.gnit   gnit  running (21m)  96s ago    22m  0.20.0   docker.io/prom/alertmanager:latest   0881eb8f169f  15ceff5ae935  crash.gnit          gnit  running (22m)  96s ago    23m  15.2.0   docker.io/ceph/ceph:v15              204a01f9b0b6  0687711365e4  grafana.gnit        gnit  running (21m)  96s ago    22m  6.6.2    docker.io/ceph/ceph-grafana:latest   87a51ecf0b1c  fa1db4647c4c  mgr.gnit.xmfvjy     gnit  running (24m)  96s ago    24m  15.2.0   docker.io/ceph/ceph:v15              204a01f9b0b6  6a29bc868357  mon.gnit            gnit  running (24m)  96s ago    24m  15.2.0   docker.io/ceph/ceph:v15              204a01f9b0b6  072f5926faa8  node-exporter.gnit  gnit  running (22m)  96s ago    22m  0.18.1   docker.io/prom/node-exporter:latest  e5a616e4b9cf  eb5f715005fc  prometheus.gnit     gnit  running (22m)  96s ago    22m  2.16.0   docker.io/prom/prometheus:latest     e935122ab143  6ee6de1b3cc1  
 ```

在上面的示例输出中，您会注意到部署了许多非`Ceph`守护程序：`Prometheus`，`Grafana`，`alertmanager`和`node-exporter`。它们提供了一个基本但配置完整且功能齐全的监视堆栈，该堆栈允许`Ceph Dashboard`的所有指标和图形都可以立即使用。如果您已经希望`Ceph`使用的现有的`Prometheus`，则可以通过传递`--skip-monitoring-stack`给`bootstrap`命令来告诉`cephadm`跳过这些。

对于大多数用户来说，这种默认行为就是您所需要的。对于想要精确控制在哪些主机上部署`monitor`或选择具体`IP`的高级用户，需要一些附加步骤来定制这些守护程序的位置。甚至可以完全禁用特定服务（如`monitor`）的自动分布，尽管这样做的理由相对较少。

一旦集群开始运行，一个最小但足够的`ceph.conf`访问群集的主机的文件可以通过以下方式获取：

 ```bash
ceph config generate-minimal-conf
 ```

## 部署存储服务

其他`Ceph`守护程序是无状态的，这意味着它们不会在本地存储任何数据，并且可以在任何主机上轻松地重新部署。这些对于`cephadm`来说很容易……对于`CephFS`，它们的部署是完全自动化的。例如，创建一个名为的`CephFS`文件系统`foo`

 ```bash
 ceph fs volume create foo
 ```

将创建必要的数据和元数据池，并一步一步部署`MDS`守护程序。守护程序的数量和位置可以在以后通过`ceph orch ls`和`ceph orch apply mds ...`命令进行检查和调整，或者可以将可选的`placement`参数传递给`volume create`命令。

对于使用`RGW`的对象存储，事情还没有完全简化，但是`orchestrator`和`cephadm`可以用来管理底层守护进程。对于独立对象存储群集：

```bash
radosgw-admin realm create --rgw-realm=myorg --defaultradosgw-admin zonegroup create --rgw-zonegroup=default --master --defaultradosgw-admin zone create --rgw-zonegroup=default --rgw-zone=us-east-1 --master --defaultceph orch apply rgw myorg us-east-1
```

对于现有（`multi-site`或`standalone`）部署，部署守护程序可以像`ceph orch apply rgw<realmname><zonename>`一样简单，前提是`rgw`配置选项已存储在群集的配置数据库（`ceph config set client.rgw.$realmname.$zonename ...`）中而不是`ceph.conf`文件。

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

## 不同的部署方案

### 单节点

要将 Ceph 集群配置为在单个主机上运行，请在引导时使用 `--single-host-defaults` 标志。

`--single-host-defaults` 标志设置以下配置选项：

```bash
global/osd_crush_chooseleaf_type = 0
global/osd_pool_default_size = 2
mgr/mgr_standby_modules = False
```

### One Node Cluster[](https://docs.ceph.com/en/latest/rados/troubleshooting/troubleshooting-pg/#one-node-cluster)

Ceph no longer provides documentation for operating on a single node, because you would never deploy a system designed for distributed computing on a single node. Additionally, mounting client kernel modules on a single node containing a Ceph  daemon may cause a deadlock due to issues with the Linux kernel itself (unless you use VMs for the clients). You can experiment with Ceph in a 1-node configuration, in spite of the limitations as described herein.

If you are trying to create a cluster on a single node, you must change the default of the `osd_crush_chooseleaf_type` setting from `1` (meaning `host` or `node`) to `0` (meaning `osd`) in your Ceph configuration file before you create your monitors and OSDs. This tells Ceph that an OSD can peer with another OSD on the same host. If you are trying to set up a 1-node cluster and `osd_crush_chooseleaf_type` is greater than `0`, Ceph will try to peer the PGs of one OSD with the PGs of another OSD on another node, chassis, rack, row, or even datacenter depending on the setting.

Tip

DO NOT mount kernel clients directly on the same node as your Ceph Storage Cluster, because kernel conflicts can arise. However, you can mount kernel clients within virtual machines (VMs) on a single node.

If you are creating OSDs using a single disk, you must create directories for the data manually first.

One Node Cluster

Ceph不再提供在单个节点上操作的文档，因为您永远不会在单个节点部署为分布式计算而设计的系统。此外，在包含Ceph守护程序的单个节点上安装客户端内核模块可能会由于Linux内核本身的问题而导致死锁（除非您为客户端使用VM）。您可以在单节点配置中尝试Ceph，尽管存在本文所述的限制。

如果您试图在单个节点上创建集群，则必须在创建监视器和osd之前，将Ceph配置文件中osd crush  chooseleaf类型设置的默认值从1（表示主机或节点）更改为0（表示osd）。这告诉Ceph，OSD可以与同一主机上的另一OSD对等。如果您正在尝试设置一个单节点集群，并且osd crush  chooseleaf类型大于0，Ceph将根据设置，尝试将一个osd的PG与另一个节点、机箱、机架、行甚至数据中心上的另一osd的PG进行对等。

提示

不要将内核客户端直接安装在Ceph存储群集的同一节点上，因为可能会出现内核冲突。但是，您可以在单个节点上的虚拟机（VM）中装载内核客户端。

如果使用单个磁盘创建OSD，则必须首先手动创建数据目录。

### 部署在隔离环境中

Run a local container registry:

可能需要在未直接连接到 Internet 的环境中安装 Cephadm （这种环境也称为“隔离环境”）。如果使用自定义容器 registry，则可以执行此操作。在这个场景中可以使用两种自定义容器 registry：

* 基于 Podman 或 Docker 的不安全 registry
* 安全 registry

在未直接连接到互联网的系统上安装软件的做法被称为“airgapping”，而未直接连接至互联网的 registry 被称为”airgapped”。

确保容器映像位于 registry 中。确保可以访问计划添加到群集的所有主机。

1. 运行本地容器 registry ：

   ```bash
   podman run --privileged -d --name registry -p 5000:5000 -v /var/lib/registry:/var/lib/registry --restart=always registry:2
   ```

2. If you are using an insecure registry, configure Podman or Docker with the hostname and port where the registry is running.如果使用的是不安全的 registry，请使用运行 registry 的主机名和端口配置 Podman 或 Docker。

   > **Note：**
   >
   > 必须对访问本地不安全 registry 的每个主机重复此步骤。

3. 将容器 image 推送到本地 registry 。以下是一些可接受的容器 image 。

   - Ceph container image
   - Prometheus container image
   - Node exporter container image
   - Grafana container image
   - Alertmanager container image

4. 创建临时配置文件以存储映像的名称。

   ```bash
   cat <<EOF > initial-ceph.conf
   ```

   ```ini
   [mgr]
   mgr/cephadm/container_image_prometheus *<hostname>*:5000/prometheus
   mgr/cephadm/container_image_node_exporter *<hostname>*:5000/node_exporter
   mgr/cephadm/container_image_grafana *<hostname>*:5000/grafana
   mgr/cephadm/container_image_alertmanager *<hostname>*:5000/alertmanger
   ```

5. 使用 `--image` 标志运行引导程序，并将容器 image 的名称作为 image 标志的参数传递。例如：

   ```bash
   cephadm --image <hostname>:5000/ceph/ceph bootstrap --mon-ip <mon-ip>
   ```
