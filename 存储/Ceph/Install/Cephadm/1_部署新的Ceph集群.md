# 部署新的Ceph集群 

[TOC]

## Bootstrap

`cephadm`有一个简单的“ `Bootstrap` ”步骤，从命令行启动，该命令行在本地主机（第一个）上启动一个最小的`Ceph`群集（一个 MON 与 MGR 守护程序）。然后，使用`orchestrator`命令部署集群的其余部分，以添加其他主机，使用存储设备，并为集群服务部署守护程序。

```bash
# 将Ceph集群的第一个主机的IP地址传递给 Ceph bootstrap 命令
mkdir -p /etc/ceph
cephadm bootstrap --mon-ip <mon-ip> --cluster-network <cluster_network>
```

这个命令将执行如下操作：

- 在本地主机上为新集群创建 MON  和 MGR 。
- 为 Ceph 集群生成一个新的 SSH 密钥，并将其添加到root用户的 `/root/.ssh/authorized_keys` 文件中。
- 将公钥的副本写入 `/etc/ceph/ceph.pub` 。
- 将最小配置写入文件 `/etc/ceph/ceph.conf` 中 。与新群集通信需要该文件。
- 将 `client.admin` 管理（特权）密钥的副本写入 `/etc/ceph/ceph.client.admin.keyring` 。 
- 将 `_admin` 标签添加到引导主机。默认情况下，具有此标签的任何主机都将（同时）获得 `/etc/ceph/ceph.conf` 和 `/etc/ceph/ceph.client.admin.keyring` 的副本。

30 到 60 秒后，最小的 `Ceph` 集群将启动并运行，并且 `cephadm` 将打印出命令以访问 `Ceph CLI`（通过容器化`shell`）和 `URL` 来访问 `dashboard` ：

```bash
INFO:cephadm:Ceph Dashboard is now available at:
		     URL: https://gnit:8443/
            User: admin
        Password: 07j394z550

INFO:cephadm:You can access the Ceph CLI with:
		sudo ./cephadm shell --fsid 2d2fd136-6df1-11ea-ae74-002590e526e8 -c /etc/ceph/ceph.conf -k /etc/ceph/ceph.client.admin.keyring

INFO:cephadm:Bootstrap complete.
```


### Further information

运行 `cephadm bootstrap -h` 查看所有可用选项。

- 默认情况下，Ceph 守护进程将其日志输出发送到stdout/stderr，由容器 runtime（docker 或 podman）获取，并（在大多数系统上）发送到 journald 。如果希望Ceph将传统的日志文件写入 `/var/log/Ceph/$fsid`，在引导过程中使用 `--log-to-file` 选项。

- 当（Ceph集群外部）公共网络流量与（Ceph集群内部）集群流量分离时，较大的 Ceph 集群性能更好。内部集群通信处理 OSD 守护进程之间的复制、恢复和心跳。可以通过向 bootstrap 子命令提供 `--cluster-network` 选项来定义集群网络。此参数必须以 CIDR 表示法定义子网（例如 `10.90.90.0/24` 或 `fe80::/64`）。

- `cephadm bootstrap` 将访问新集群所需的文件写入 `/etc/ceph` 。这个中心位置使得安装在主机上的Ceph 包(例如，允许访问cephadm命令行接口的包)能够找到这些文件。然而，用cephadm部署的Daemon container 根本不需要 `/etc/ceph` 。使用 `--output-dir <directory>` 选项将它们放在不同的目录中。这可能有助于避免与同一主机上现有的 Ceph 配置（ cephadm 或其他配置）发生冲突。

- 可以将任何初始化Ceph的配置选项放到一个标准的ini样式的配置文件中，使用 `--config <config-file>` 传递给新的集群。例如：

  ```bash
  cat << EOF > initial-ceph.conf
  
  [global]
  public network = 10.0.0.0/24
  cluster network = 172.16.0.0/24   #貌似不生效
  EOF
  
  ./cephadm bootstrap --config initial-ceph.conf ...
  ```
  
- 使用 `--ssh-user <user>` 选项，指定 cephadm 连接到主机时，选择使用哪个 ssh 用户。相关的 ssh 密钥将被添加到 `/home/<user>/.ssh/authorized_keys` 中。使用此选项指定的用户，必须具有无密码sudo 访问权限。

- If you are using a container on an authenticated registry that requires login, you may add the three arguments:

  ```bash
  --registry-url <url of registry>
  --registry-username <username of account on registry>
  --registry-password <password of account on registry>
  
  #或者
  --registry-json <json file with login info>
  ```

  Cephadm 将尝试登录到这个 registry ，以便可以 pull your container 并且将登录信息存储在它的配置数据库中。添加到集群中的其他主机也将能够使用经过身份验证的 registry 。


## 启用 Ceph CLI

Cephadm 不需要再本地安装任何 Ceph 软件包。有几种与新群集进行交互的方法：

- cephadm shell 命令在安装了所有 Ceph 包的容器中启动一个 bash shell。默认情况下，如果在主机上的 `/etc/ceph` 中找到配置和密钥环文件，则将它们传递到容器环境中，以便 shell 完全正常运行。注意，在 MON 主机上执行时，`cephadm shell` 将从 MON 容器推断配置，而不是使用默认配置。如果给定了 `--mount <path>` ，则主机  <path>（文件或目录）将出现在容器内的 `/mnt` 下：

  ```bash
  cephadm shell
  ```
  
- 要执行 `ceph` 命令，还可以运行如下命令：

  ```bash
  cephadm shell -- ceph -s
  ```

- 可以安装 `ceph-common` 软件包，其中包含所有ceph命令，包括 `ceph`，`rbd`，`mount.ceph`（用于安装CephFS 文件系统）等：

  ```bash
  cephadm add-repo --release pacific
  cephadm install ceph-common
  ```

## Ceph集群扩展

详见文档[主机管理.md](../../主机管理.md)

### 部署 MON

一个典型的 Ceph 集群具有3个或5个分布在不同主机上的监视守护程序。如果集群中有5个或更多节点，建议部署5个 MON 。

When Ceph knows what IP subnet the monitors should use it can automatically deploy and scale monitors as the cluster grows (or contracts).  By default, Ceph assumes that other monitors should use the same subnet as the first monitor’s IP.当Ceph知道监视器应该使用哪个IP子网时，它可以随着群集的增长（或收缩）自动部署和扩展监视器。默认情况下，Ceph假定其他监视器应使用与第一台监视器IP相同的子网。 

If your Ceph monitors (or the entire cluster) live on a single subnet, then by default cephadm automatically adds up to 5 monitors as you add new hosts to the cluster. No further steps are necessary.如果您的Ceph监视器（或整个群集）位于单个子网中，则默认情况下，当您向群集中添加新主机时，cephadm会自动添加多达5个监视器。无需其他步骤。 

- If there is a specific IP subnet that should be used by monitors, you can configure that in [CIDR](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing#CIDR_notation) format (e.g., `10.1.2.0/24`) with:如果监视器应使用特定的IP子网，则可以使用以下命令以CIDR格式（例如10.1.2.0/24）进行配置： 

  ```bash
  ceph config set mon public_network *<mon-cidr-network>*
  ```

  For example:

  ```bash
  ceph config set mon public_network 10.1.2.0/24
  ```

  Cephadm only deploys new monitor daemons on hosts that have IPs configured in the configured subnet.Cephadm仅在已在配置的子网中配置了IP的主机上部署新的监视器守护程序。

- If you want to adjust the default of 5 monitors: 如果要调整5个监视器的默认值： 

  ```bash
  ceph orch apply mon *<number-of-monitors>*
  ```

- To deploy monitors on a specific set of hosts: 要将监视器部署在一组特定的主机上： 

  ```bash
  ceph orch apply mon *<host1,host2,host3,...>*
  ```

  Be sure to include the first (bootstrap) host in this list.      确保在此列表中包括第一台（引导）主机。

- You can control which hosts the monitors run on by making use of host labels.  To set the `mon` label to the appropriate hosts:您可以通过使用主机标签来控制运行监视器的主机。要将mon标签设置为适当的主机： 

  ```bash
  ceph orch host label add *<hostname>* mon
  ```

  To view the current hosts and labels:要查看当前的主机和标签： 

  ```bash
  ceph orch host ls
  ```

  For example:

  ```bash
  ceph orch host label add host1 mon
  ceph orch host label add host2 mon
  ceph orch host label add host3 mon
  
  ceph orch host ls
  HOST   ADDR   LABELS  STATUS
  host1         mon
  host2         mon
  host3         mon
  host4
  host5
  ```

  Tell cephadm to deploy monitors based on the label:告诉cephadm根据标签部署监视器： 

  ```bash
  ceph orch apply mon label:mon
  ```

- You can explicitly specify the IP address or CIDR network for each monitor and control where it is placed.  To disable automated monitor deployment:您可以为每个监视器和控件明确地指定IP地址或CIDR网络。要禁用自动监视器部署： 

  ```bash
  ceph orch apply mon --unmanaged
  ```

  To deploy each additional monitor:  要部署每个其他监视器： 

  ```bash
  ceph orch daemon add mon *<host1:ip-or-network1> [<host1:ip-or-network-2>...]
  ```

  For example, to deploy a second monitor on `newhost1` using an IP address `10.1.2.123` and a third monitor on `newhost2` in network `10.1.2.0/24`: 例如，要使用IP地址10.1.2.123在newhost1上部署第二台监视器，并在网络10.1.2.0/24中在newhost2上部署第三台监视器：

  ```bash
  ceph orch apply mon --unmanaged
  ceph orch daemon add mon newhost1:10.1.2.123
  ceph orch daemon add mon newhost2:10.1.2.0/24
  ```

  Note

  The **apply** command can be confusing. For this reason, we recommend using YAML specifications.   apply命令可能会造成混淆。因此，我们建议使用YAML规范。 

  Each ‘ceph orch apply mon’ command supersedes the one before it. This means that you must use the proper comma-separated list-based syntax when you want to apply monitors to more than one host. If you do not use the proper syntax, you will clobber your work as you go.每个“ ceph orch apply mon”命令都会取代之前的命令。这意味着要将监视器应用于多个主机时，必须使用正确的逗号分隔的基于列表的语法。如果您使用的语法不正确，那么您将无法进行工作。 

  For example:

  ```bash
  ceph orch apply mon host1
  ceph orch apply mon host2
  ceph orch apply mon host3
  ```

  This results in only one host having a monitor applied to it: host 3.    这样只会导致一个主机上应用了监视器：主机3。 

  (The first command creates a monitor on host1. Then the second command clobbers the monitor on host1 and creates a monitor on host2. Then the third command clobbers the monitor on host2 and creates a monitor on host3. In this scenario, at this point, there is a monitor ONLY on host3.)    （第一个命令在host1上创建一个监视器。然后第二个命令在host1上创建一个监视器，然后在host2上创建一个监视器。然后第三个命令在host2上创建一个监视器，然后在host3上创建一个监视器。在这种情况下，在host3上只有一个监视器。） 

  To make certain that a monitor is applied to each of these three hosts, run a command like this:为了确保将监视器应用于这三台主机中的每台，请运行以下命令： 

  ```bash
  ceph orch apply mon "host1,host2,host3"
  ```

  Instead of using the “ceph orch apply mon” commands, run a command like this:而不是使用“ ceph orch apply mon”命令，而是运行以下命令： 

  ```bash
  ceph orch apply -i file.yaml
  ```

  Here is a sample **file.yaml** file:    这是一个示例file.yaml文件： 

  ```yaml
  service_type: mon
  placement:
    hosts:
     - host1
     - host2
     - host3
  ```

### 部署 OSD 

An inventory of storage devices on all cluster hosts can be displayed with:所有群集主机上的存储设备清单可以显示： 

```bash
ceph orch device ls
```

A storage device is considered *available* if all of the following conditions are met:如果满足以下所有条件，则认为存储设备可用： 

- The device must have no partitions.设备必须没有分区
- The device must not have any LVM state.设备不得具有任何LVM状态。 
- The device must not be mounted.不得安装设备。 
- The device must not contain a file system.  该设备不得包含文件系统。 
- The device must not contain a Ceph BlueStore OSD. 该设备不得包含Ceph Blue Store OSD。 
- The device must be larger than 5 GB.设备必须大于5 GB。 

Ceph refuses to provision an OSD on a device that is not available.Ceph拒绝在不可用的设备上配置OSD。 

有几种创建新 OSD 的方法： 

- 告诉Ceph使用任何可用和未使用的存储设备： 

  ```bash
  ceph orch apply osd --all-available-devices
  ```

- Create an OSD from a specific device on a specific host:    从特定主机上的特定设备创建OSD： 

  ```bash
  ceph orch daemon add osd <host>:<device-path>
  ```

  For example:

  ```bash
  ceph orch daemon add osd host1:/dev/sdb
  ```

- Use [OSD Service Specification](https://docs.ceph.com/docs/master/cephadm/drivegroups/#drivegroups) to describe device(s) to consume based on their properties, such device type (SSD or HDD), device model names, size, or the hosts on which the devices exist:  使用OSD服务规范基于设备的属性来描述要使用的设备，例如设备类型（SSD或HDD），设备型号名称，大小或设备所在的主机： 

  ```bash
  ceph orch apply osd -i spec.yml
  ```



将`OSD`添加到`Ceph`集群通常是部署中最棘手的部分之一。`HDD`和`SSD`可以通过多种方式组合以平衡性能和成本，并且告诉`Ceph`使用哪种设备可能很棘手。

对于大部分用户，我们希望以下命令就足够了：

> ```php
> ceph orch apply osd --all-available-devices
> ```

这将消耗`Ceph`集群中通过所有安全检查的任何主机上的任何设备（`HDD`或`SSD`），这意味着没有分区、没有`LVM`卷、没有文件系统等。每个设备将部署一个`OSD`，这是适用于大多数用户的最简单情况。

对于我们其他人，我们有几种工具可供使用。我们可以使用以下方法列出所有主机上的所有设备（以及上述安全检查的状态）：

> ```php
> ceph orch device ls
> ```

可以使用以下命令在单个设备上显式创建单个`OSD`：

> ```php
> ceph orch daemon add osd host-foo:/dev/foo
> ```

但是，对于更复杂的自动化，`orchestrator API`引入了`DriveGroups`的概念，该概念允许按照设备属性（`SSD`与`HDD`，型号名称，大小，主机名模式）以及“`hybrid`” `OSD`来描述`OSD`部署。组合多个设备（例如，用于元数据的`SSD`和用于数据的`HDD`）以半自动化的方式进行部署。

### 部署 MDS 

One or more MDS daemons is required to use the CephFS file system. These are created automatically if the newer `ceph fs volume` interface is used to create a new file system.  For more information, see [FS volumes and subvolumes](https://docs.ceph.com/docs/master/cephfs/fs-volumes/#fs-volumes-and-subvolumes).要使用Ceph FS文件系统，需要一个或多个MDS守护程序。如果使用较新的ceph fs卷接口创建新文件系统，则会自动创建这些文件。有关更多信息，请参见FS卷和子卷。 

To deploy metadata servers:部署元数据服务器：

```bash
ceph orch apply mds <fs-name> --placement="<num-daemons> [<host1> ...]"
```

See [Placement Specification](https://docs.ceph.com/docs/master/mgr/orchestrator/#orchestrator-cli-placement-spec) for details of the placement specification.有关放置规范的详细信息，请参见放置规范。

### 部署 RGW 

Cephadm deploys radosgw as a collection of daemons that manage a particular *realm* and *zone*.  (For more information about realms and zones, see [Multi-Site](https://docs.ceph.com/docs/master/radosgw/multisite/#multisite).)Cephadm将radosgw部署为管理特定领域和区域的守护程序的集合。 （有关领域和区域的更多信息，请参见多站点。）

Note that with cephadm, radosgw daemons are configured via the monitor configuration database instead of via a ceph.conf or the command line.  If that configuration isn’t already in place (usually in the `client.rgw.<realmname>.<zonename>` section), then the radosgw daemons will start up with default settings (e.g., binding to port 80).请注意，使用cephadm时，radosgw守护程序是通过监视器配置数据库而不是通过ceph.conf或命令行来配置的。如果该配置尚未就绪（通常在client.rgw。<realmname>。<zonename>部分中），那么radosgw守护程序将使用默认设置（例如，绑定到端口80）启动。

To deploy a set of radosgw daemons for a particular realm and zone:要为特定领域和区域部署一组radosgw守护程序： 

```bash
ceph orch apply rgw <realm-name> <zone-name> --placement="<num-daemons> [<host1> ...]"
```

For example, to deploy 2 rgw daemons serving the *myorg* realm and the *us-east-1* zone on *myhost1* and *myhost2*:例如，要在myhost1和myhost2上部署两个服务于myorg领域和us-east-1区域的rgw守护程序： 

```bash
ceph orch apply rgw myorg us-east-1 --placement="2 myhost1 myhost2"
```

Cephadm will wait for a healthy cluster and automatically create the  supplied realm and zone if they do not exist before deploying the rgw  daemon(s)Cephadm将等待运行状况良好的群集，并在部署rgw守护程序之前自动创建所提供的领域和区域（如果它们不存在）

Alternatively, the realm, zonegroup, and zone can be manually created using `radosgw-admin` commands:另外，可以使用radosgw-admin命令手动创建领域，区域组和区域：

```bash
radosgw-admin realm create --rgw-realm=<realm-name> --default
radosgw-admin zonegroup create --rgw-zonegroup=<zonegroup-name>  --master --default
radosgw-admin zone create --rgw-zonegroup=<zonegroup-name> --rgw-zone=<zone-name> --master --default
```

See [Placement Specification](https://docs.ceph.com/docs/master/mgr/orchestrator/#orchestrator-cli-placement-spec) for details of the placement specification.有关放置规范的详细信息，请参见放置规范。

### 部署 NFS ganesha

Cephadm deploys NFS Ganesha using a pre-defined RADOS *pool* and optional *namespace* Cephadm使用预定义的RADOS池和可选的名称空间部署NFS Ganesha 

To deploy a NFS Ganesha gateway,:要部署NFS Ganesha网关，请执行以下操作： 

```bash
ceph orch apply nfs <svc_id> <pool> <namespace> --placement="<num-daemons> [<host1> ...]"
```

For example, to deploy NFS with a service id of *foo*, that will use the RADOS pool *nfs-ganesha* and namespace *nfs-ns*,:例如，要部署服务标识为foo的NFS，将使用RADOS池nfs-ganesha和名称空间nfs-ns： 

```bash
ceph orch apply nfs foo nfs-ganesha nfs-ns
```

Note

Create the *nfs-ganesha* pool first if it doesn’t exist.如果不存在，请首先创建nfs-ganesha池。 

See [Placement Specification](https://docs.ceph.com/docs/master/mgr/orchestrator/#orchestrator-cli-placement-spec) for details of the placement specification.有关放置规范的详细信息，请参见放置规范。

### 部署 iSCSI

### 部署自定义容器 

It is also possible to choose different containers than the default containers to deploy Ceph. See [Ceph Container Images](https://docs.ceph.com/docs/master/install/containers/#containers) for information about your options in this regard.也可以选择与默认容器不同的容器来部署Ceph。有关这方面选项的信息，请参阅Ceph容器映像。



## 管理Ceph monitor, manager和其他守护程序

`Cephadm`中的每个服务或守护进程集合都有一个相关的 *`placement` 规范*，或者描述应该在哪里部署守护程序以及部署多少守护程序。默认情况下，带有`cephadm`的新`Ceph`集群知道集群应该在每个主机上部署5个`monitor`、2个`manager`和一些其他服务（如`crash dump collector`）。新的`monitor`和`manager`会在向群集添加其他主机后自动部署。您可以使用`ceph orch ls`和`ceph orch ps`命令查看新的集群服务和已部署的守护程序：

> ```php
> ceph orch ls
>     
> NAME           RUNNING  REFRESHED  AGE  PLACEMENT  IMAGE NAME                           IMAGE ID      alertmanager       1/1  71s ago    22m  count:1    docker.io/prom/alertmanager:latest   0881eb8f169f  crash              1/1  71s ago    23m  *          docker.io/ceph/ceph:v15              204a01f9b0b6  grafana            1/1  71s ago    22m  count:1    docker.io/ceph/ceph-grafana:latest   87a51ecf0b1c  mgr                1/2  71s ago    23m  count:2    docker.io/ceph/ceph:v15              204a01f9b0b6  mon                1/5  71s ago    23m  count:5    docker.io/ceph/ceph:v15              204a01f9b0b6  node-exporter      1/1  71s ago    22m  *          docker.io/prom/node-exporter:latest  e5a616e4b9cf  prometheus         1/1  71s ago    22m  count:1    docker.io/prom/prometheus:latest     e935122ab143
>     
> ceph orch ps
> 
> NAME                HOST  STATUS         REFRESHED  AGE  VERSION  IMAGE NAME                           IMAGE ID      CONTAINER ID  alertmanager.gnit   gnit  running (21m)  96s ago    22m  0.20.0   docker.io/prom/alertmanager:latest   0881eb8f169f  15ceff5ae935  crash.gnit          gnit  running (22m)  96s ago    23m  15.2.0   docker.io/ceph/ceph:v15              204a01f9b0b6  0687711365e4  grafana.gnit        gnit  running (21m)  96s ago    22m  6.6.2    docker.io/ceph/ceph-grafana:latest   87a51ecf0b1c  fa1db4647c4c  mgr.gnit.xmfvjy     gnit  running (24m)  96s ago    24m  15.2.0   docker.io/ceph/ceph:v15              204a01f9b0b6  6a29bc868357  mon.gnit            gnit  running (24m)  96s ago    24m  15.2.0   docker.io/ceph/ceph:v15              204a01f9b0b6  072f5926faa8  node-exporter.gnit  gnit  running (22m)  96s ago    22m  0.18.1   docker.io/prom/node-exporter:latest  e5a616e4b9cf  eb5f715005fc  prometheus.gnit     gnit  running (22m)  96s ago    22m  2.16.0   docker.io/prom/prometheus:latest     e935122ab143  6ee6de1b3cc1  
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





