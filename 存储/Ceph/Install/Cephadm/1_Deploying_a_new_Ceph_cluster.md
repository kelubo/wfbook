# 部署新的Ceph集群 

Cephadm creates a new Ceph cluster by “bootstrapping” on a single host, expanding the cluster to encompass any additional hosts, and then deploying the needed services.Cephadm通过在单个主机上“引导”，将群集扩展为包含任何其他主机，然后部署所需的服务，来创建新的Ceph群集。

The `cephadm` command can (1) bootstrap a new cluster, (2) launch a containerized shell with a working Ceph CLI, and (3) aid in debugging containerized Ceph daemons.`cephadm` 命令可以（1）引导新集群，（2）使用有效的Ceph CLI启动容器化的Shell，以及（3）调试容器化的Ceph守护程序。  

## 依赖

- Systemd
- python3                                                         （cephadm运行需要）
- Podman或Docker                                         （用于运行容器） 
- 时间同步                                                         （如chrony或NTP） 
- LVM2 for provisioning storage devices

```bash
# CentOS 7
yum install python3 docker
systemctl enable docker
systemctl start docker

# CentOS 8
yum install python3 podman
```

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

## 引导群集

You need to know which *IP address* to use for the cluster’s first monitor daemon.  This is normally just the IP for the first host.  If there are multiple networks and interfaces, be sure to choose one that will be accessible by any host accessing the Ceph cluster.

您需要知道用于群集的第一个监视器守护程序的IP地址。通常，这只是第一台主机的IP。如果有多个网络和接口，请确保选择一个可供访问Ceph群集的主机访问的网络和接口。 

```bash
mkdir -p /etc/ceph
cephadm bootstrap --mon-ip <ip>
```

This command will:

- 在本地主机上为新集群创建 monitor  和 manager 守护程序。
- Generate a new SSH key for the Ceph cluster and adds it to the root user’s `/root/.ssh/authorized_keys` file.为Ceph集群生成一个新的SSH密钥，并将其添加到root用户的/root/.ssh/authorized密钥文件中。
- Write a minimal configuration file needed to communicate with the new cluster to `/etc/ceph/ceph.conf`.将与新群集通信所需的最小配置文件写入/etc/ceph/ceph.conf。
- Write a copy of the `client.admin` administrative (privileged!) secret key to `/etc/ceph/ceph.client.admin.keyring`.将client.admin管理（特权！）秘密密钥的副本写入/etc/ceph/ceph.client.admin.keyring。 
- Write a copy of the public key to `/etc/ceph/ceph.pub`.将公用密钥的副本写入/etc/ceph/ceph.pub。 

30到60秒后，最小的`Ceph`集群将启动并运行，并且`cephadm`将打印出命令以访问`Ceph CLI`（通过容器化`shell`）和`URL`来访问`dashboard`：

```bash
INFO:cephadm:Ceph Dashboard is now available at:
		     URL: https://gnit:8443/
            User: admin
        Password: 07j394z550

INFO:cephadm:You can access the Ceph CLI with:
		sudo ./cephadm shell --fsid 2d2fd136-6df1-11ea-ae74-002590e526e8 -c /etc/ceph/ceph.conf -k /etc/ceph/ceph.client.admin.keyring

INFO:cephadm:Bootstrap complete.
```



The default bootstrap behavior will work for the vast majority of users.  See below for a few options that may be useful for some users, or run `cephadm bootstrap -h` to see all available options:默认的引导行为将对绝大多数用户起作用。请参阅以下有关对某些用户可能有用的一些选项，或运行cephadm bootstrap -h以查看所有可用选项：

* Bootstrap writes the files needed to access the new cluster to `/etc/ceph` for convenience, so that any Ceph packages installed on the host itself (e.g., to access the command line interface) can easily find them.    为了方便起见，Bootstrap将访问新集群所需的文件写到/ etc / ceph中，以便主机本身安装的任何Ceph软件包（例如，访问命令行界面）都可以轻松找到它们。 

- Daemon containers deployed with cephadm, however, do not need `/etc/ceph` at all.  Use the `--output-dir *<directory>*` option to put them in a different directory (like `.`), avoiding any potential conflicts with existing Ceph configuration (cephadm or otherwise) on the same host.    但是，使用cephadm部署的守护程序容器根本不需要/ etc / ceph。使用--output-dir *  <directory> *选项将它们放在不同的目录（如。）中，避免与同一主机上的现有Ceph配置（cephadm或其他）潜在冲突。 
- You can pass any initial Ceph configuration options to the new cluster by putting them in a standard ini-style configuration file and using the `--config *<config-file>*` option.   您可以将任何初始Ceph配置选项传递到新集群，方法是将它们放置在标准ini样式的配置文件中，并使用--config * <config-file> *选项。 
- You can choose the ssh user cephadm will use to connect to hosts by using the `--ssh-user *<user>*` option. The ssh key will be added to `/home/*<user>*/.ssh/authorized_keys`. This user will require passwordless sudo access. 您可以使用--ssh-user * <user> *选项选择ssh用户cephadm将用于连接主机。 ssh密钥将添加到/ home / * <用户> * /。ssh /授权密钥。该用户将需要无密码的sudo访问。 
- If you are using a container on an authenticated registry that requires login you may add the three arguments `--registry-url <url of registry>`, `--registry-username <username of account on registry>`, `--registry-password <password of account on registry>` OR `--registry-json <json file with login info>`. Cephadm will attempt to login to this registry so it may pull your container and then store the login info in its config database so other hosts added to the cluster may also make use of the authenticated registry.    如果您在需要登录的经过身份验证的注册表上使用容器，则可以添加三个参数--registry-url  <注册表的URL>，-registry-username  <注册表上的帐户的用户名>，-registry-password  <密码注册表上的帐户编号>或--registry-json <带有登录信息的json文件>。  Cephadm将尝试登录此注册表，以便它可以拉出您的容器，然后将登录信息存储在其配置数据库中，以便添加到群集的其他主机也可以使用经过身份验证的注册表。

## 启用Ceph CLI 

由于`Ceph`已完全容器化，因此主机上尚未安装任何软件，通常的`ceph`命令将不起作用。有几种与新群集进行交互的方法。

**方法1：**是使用`cephadm shell`命令。用于引导的`cephadm`也可以启动装有所有`Ceph`软件（包括`CLI`）的容器话`Shell`。因为`bootstrap`在默认情况下会将`ceph config`和`admin keyring`的副本放在`/etc/ceph`中，而`shell`命令在默认情况下会在那里显示，所以您可以通过以下的命令启动一个shell并进入CLI管理端：

```bash
./cephadm shell ceph status
```

**方法2：**`cephadm`命令还使在主机上安装`Ceph`软件包变得更加容易。将`Ceph CLI`命令和`cephadm`命令安装在标准位置：

```bash
./cephadm add-repo --release octopus
./cephadm install cephadm ceph-common
```

做这件事有很多种方法： 

- The `cephadm shell` command launches a bash shell in a container with all of the Ceph packages installed. By default, if configuration and keyring files are found in `/etc/ceph` on the host, they are passed into the container environment so that the shell is fully functional. Note that when executed on a MON host, `cephadm shell` will infer the `config` from the MON container instead of using the default configuration. If `--mount <path>` is given, then the host `<path>` (file or directory) will appear under `/mnt` inside the container:cephadm shell命令在装有所有Ceph软件包的容器中启动bash shell。默认情况下，如果在主机上的/ etc / ceph中找到配置文件和密钥环文件，它们将被传递到容器环境中，从而使Shell可以正常运行。请注意，当在MON主机上执行时，cephadm  Shell将从MON容器中推断配置，而不是使用默认配置。如果给出了--mount  <path>，则主机<path>（文件或目录）将出现在容器内的/ mnt下：

  ```bash
  cephadm shell
  ```

- To execute `ceph` commands, you can also run commands like so:要执行ceph命令，您还可以运行如下命令： 

  ```bash
  cephadm shell -- ceph -s
  ```

- You can install the `ceph-common` package, which contains all of the ceph commands, including `ceph`, `rbd`, `mount.ceph` (for mounting CephFS file systems), etc.:    您可以安装ceph-common软件包，其中包含所有ceph命令，包括ceph，rbd，mount.ceph（用于安装Ceph FS文件系统）等： 

  ```bash
  cephadm add-repo --release octopus
  cephadm install ceph-common
  ```

Confirm that the `ceph` command is accessible with:确认可以使用以下命令访问ceph命令：

```bash
ceph -v
```

Confirm that the `ceph` command can connect to the cluster and also its status with:使用以下命令确认ceph命令可以连接到集群及其状态：

```bash
ceph status
```

## Ceph集群扩展

`Cephadm`通过使用`SSH`从`ceph mgr`守护程序连接到集群中的主机来管理集群，从而内省环境、监视`ceph`守护进程以及部署或删除守护程序。每个`Ceph`集群生成一个惟一的`SSH`标识和密钥，用于连接到主机。引导过程会将此密钥添加到本地主机的根用户的`authorized_keys`中。

首先，我们需要集群密钥的公钥部分。默认情况下，引导程序会将副本放在`/etc/ceph/ceph.pub`，或者可以使用`ceph cephadm get ssh pub key`从集群获取公钥副本。

对于每个主机，我们首先需要在远程系统上添加密钥。使用任何最新版本的`ssh`附带的`ssh copy id`命令最容易实现这一点：

```php
ssh-copy-id -f -i /etc/ceph/ceph.pub root@new-host
```

如果您当前的用户尚未设置免密码的`SSH`访问，则此命令可能会提示您输入`root`密码。

接下来，我们需要告诉`Ceph`有关新主机的信息。在此我们假设所有主机都有一个唯一的主机名，该主机名与主机本身上配置的主机名匹配。如果您的本地环境还没有配置`DNS`以使我们可以连接到这些主机名，或者您希望避免依赖`DNS`，则还可以为每个主机提供`IP`地址：

```php
ceph orch host add <new-host> [<new-host-ip>]
```

使用以下命令查看群集中的所有主机

```php
ceph orch host ls
```
### Deploy additional monitors (optional) 部署其他监视器（可选） 

A typical Ceph cluster has three or five monitor daemons spread across different hosts.  We recommend deploying five monitors if there are five or more nodes in your cluster.一个典型的Ceph集群具有三个或五个分布在不同主机上的监视守护程序。如果集群中有五个或更多节点，我们建议部署五个监视器。

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

### Deploy OSDs部署OSD 

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

There are a few ways to create new OSDs:有几种创建新OSD的方法： 

- Tell Ceph to consume any available and unused storage device:告诉Ceph使用任何可用和未使用的存储设备： 

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

## 添加存储

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

### Deploy MDSs部署MDS 

One or more MDS daemons is required to use the CephFS file system. These are created automatically if the newer `ceph fs volume` interface is used to create a new file system.  For more information, see [FS volumes and subvolumes](https://docs.ceph.com/docs/master/cephfs/fs-volumes/#fs-volumes-and-subvolumes).要使用Ceph FS文件系统，需要一个或多个MDS守护程序。如果使用较新的ceph fs卷接口创建新文件系统，则会自动创建这些文件。有关更多信息，请参见FS卷和子卷。 

To deploy metadata servers:部署元数据服务器：

```bash
ceph orch apply mds <fs-name> --placement="<num-daemons> [<host1> ...]"
```

See [Placement Specification](https://docs.ceph.com/docs/master/mgr/orchestrator/#orchestrator-cli-placement-spec) for details of the placement specification.有关放置规范的详细信息，请参见放置规范。

### Deploy RGWs 部署RGW 

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

### Deploying NFS ganesha 部署NFS

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

### Deploying custom containers部署自定义容器 

It is also possible to choose different containers than the default containers to deploy Ceph. See [Ceph Container Images](https://docs.ceph.com/docs/master/install/containers/#containers) for information about your options in this regard.也可以选择与默认容器不同的容器来部署Ceph。有关这方面选项的信息，请参阅Ceph容器映像。

