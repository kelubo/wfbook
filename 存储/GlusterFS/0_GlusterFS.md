GlusterFS

[TOC]

## 概述

Gluster 是一个可扩展的分布式文件系统，它将来自多个服务器的磁盘存储资源聚合到一个全局名称空间中。适合于数据密集型任务，如云存储和媒体流。

企业可以按需扩展容量、性能和可用性，而无需在内部部署、公共云和混合环境中锁定供应商。

最大特点就是以 Brick  (Dirctory)  为节点。具有强大的线性横向扩展能力，通过扩展能够支持数PB存储容量和处理数千客户端。GlusterFS借助TCP/IP或InfiniBand  RDMA 网络将物理分布的存储资源聚集在一起，使用单一全局命名空间来管理数据。

它将自动故障切换作为主要功能。所有这些都是在没有集中式元数据服务器的情况下完成的。

### 优势

- 可扩展到数 PB
- Handles thousands of clients处理数千个客户
- POSIX 兼容
- Uses commodity hardware使用商品硬件
- Can use any ondisk filesystem that supports extended attributes可以使用任何支持扩展属性的ondisk文件系统
- Accessible using industry standard protocols like NFS and SMB可使用NFS和SMB等行业标准协议访问
- Provides replication, quotas, geo-replication, snapshots and bitrot detection提供复制、配额、地理复制、快照和比特率检测
- Allows optimization for different workloads允许针对不同的工作负载进行优化
- 开放源代码

### 商业产品和支持

一些公司提供支持或咨询。

Red Hat Gluster Storage是一款基于 Gluster 的商业存储软件产品。

## 安装

首先，必须了解 GlusterFS 本身并不是一个真正的文件系统。它将现有的文件系统连接成一个（或多个）大块，以便将数据写入Gluster或从Gluster中读出的数据同时分布在多个主机上。这意味着您可以使用任何可用主机的空间。通常，建议使用XFS，但它也可以与其他文件系统一起使用。当XFS不可用时，最常用的是EXT4，但您可以（很多人都这样做）使用另一个适合您的文件系统。It concatenates existing filesystems into one (or more) big chunks so that data being written into or read out of Gluster gets distributed across multiple hosts simultaneously. This means that you can use space from any host that you have available. Typically, XFS is recommended but it can be used with other filesystems as well. Most commonly EXT4 is used when XFS isn’t, but you can (and many, many people do) use another filesystem that suits you. 

**常用术语：**

- A **trusted pool** refers collectively to the hosts in a given    Gluster Cluster.受信任的池统称为给定Gluster集群中的主机。
- A **node** or “server” refers to any server that is part of a    trusted pool. In general, this assumes all nodes are in the same    trusted pool.节点或“服务器”是指属于受信任池的任何服务器。通常，这假设所有节点都在同一个受信任池中。
- A **brick** is used to refer to any device (really this means    filesystem) that is being used for Gluster storage.砖用于指代用于Gluster存储的任何设备（实际上这意味着文件系统）。
- An **export** refers to the mount path of the brick(s) on a given    server, for example, /export/brick1导出是指给定服务器上砖的装载路径，例如/export/brick1
- The term **Global Namespace** is a fancy way of saying a Gluster    volume术语“全局命名空间”是Gluster卷的一种奇特说法
- A **Gluster volume** is a collection of one or more bricks (of    course, typically this is two or more). This is analogous to    /etc/exports entries for NFS.Gluster体积是一块或多块砖的集合（当然，通常是两块或更多）。这类似于NFS的/etc/exports条目。
- **GNFS** and **kNFS**. GNFS is how we refer to our inline NFS    server. kNFS stands for kernel NFS, or, as most people would say,    just plain NFS. Most often, you will want kNFS services disabled on    the Gluster nodes. Gluster NFS doesn't take any additional    configuration and works just like you would expect with NFSv3. It is    possible to configure Gluster and NFS to live in harmony if you want    to.GNFS和k  NFS。GNFS是我们引用内联NFS服务器的方式。kNFS代表内核NFS，或者，正如大多数人所说的，只是普通NFS。通常，您会希望Gluster节点上禁用k个NFS服务。Gluster NFS不需要任何额外的配置，工作方式与NFSv3一样。如果您愿意，可以将Gluster和NFS配置为和谐共存。

其他注释：

- For this test, if you do not have DNS set up, you can get away with    using /etc/hosts entries for the two nodes. However, when you move    from this basic setup to using Gluster in production, correct DNS    entries (forward and reverse) and NTP are essential.
- When you install the Operating System, do not format the Gluster    storage disks! We will use specific settings with the mkfs command    later on when we set up Gluster. If you are testing with a single    disk (not recommended), make sure to carve out a free partition or    two to be used by Gluster later, so that you can format or reformat    at will during your testing.
- Firewalls are great, except when they aren’t. For storage servers,    being able to operate in a trusted environment without firewalls can    mean huge gains in performance, and is recommended. In case you absolutely    need to set up a firewall, have a look at    [Setting up clients](https://docs.gluster.org/en/latest/Administrator-Guide/Setting-Up-Clients/) for    information on the ports used.
- 对于此测试，如果您没有设置DNS，则可以在两个节点上使用/etc/hosts条目。然而，当您从这个基本设置转到在生产中使用Gluster时，正确的DNS条目（正向和反向）和NTP是必不可少的。
- 安装操作系统时，不要格式化Gluster存储磁盘！稍后我们将在设置Gluster时使用mkfs命令的特定设置。如果您使用单个磁盘进行测试（不推荐），请确保留出一两个空闲分区供Gluster稍后使用，以便您可以在测试期间随意格式化或重新格式化。
- 防火墙很棒，除非它们不是。对于存储服务器，能够在没有防火墙的可信环境中运行意味着性能的巨大提高，建议这样做。如果您确实需要设置防火墙，请查看“设置客户端”以获取有关所用端口的信息。

### 准备节点

- Fedora 30（或更高版本），位于名为 “server1” 、“server2” 和 “server3” 的 3 个节点上。
- 工作网络连接
- 每个主机上至少有两个磁盘，一个用于 OS 安装，另一个用于 GlusterFS 存储。
- 在每台服务器上设置 NTP，以使文件系统上的许多应用程序正常运行。这是一项重要要求。

> **Note**:
>
> GlusterFS 将其动态生成的配置文件存储在 `/var/lib/glusterd` 。如果在任何时间点，GlusterFS 无法写入这些文件（例如，当备份文件系统已满时），这至少会导致系统的不稳定；或者更糟的是，让系统完全离线。建议为 /var/log 等目录创建单独的分区，以减少发生这种情况的可能性。

### 格式化及挂载硬盘

在所有节点上执行：

```bash
mkfs.xfs -i size=512 /dev/sdb1
mkdir -p /data/brick1
echo '/dev/sdb1 /data/brick1 xfs defaults 1 2' >> /etc/fstab
mount -a
```

### 安装 GlusterFS

For RPM based distributions, if you will be using InfiniBand, add the glusterfs RDMA package to the installations. For RPM based systems, yum/dnf is used as the install method in order to satisfy external depencies such as compat-readline5

对于基于RPM的发行版，如果您将使用Infini Band，请将glusterfs RDMA包添加到安装中。对于基于RPM的系统，使用yum/dnf作为安装方法，以满足compat-readline5等外部依赖性

#### Debian

Add the GPG key to apt:

```bash
wget -O - https://download.gluster.org/pub/gluster/glusterfs/LATEST/rsa.pub | apt-key add -
```

If the rsa.pub is not available at the above location, please look  here https://download.gluster.org/pub/gluster/glusterfs/7/rsa.pub and  add the GPG key to apt:

```bash
wget -O - https://download.gluster.org/pub/gluster/glusterfs/7/rsa.pub | apt-key add -
```

Add the source:

```bash
DEBID=$(grep 'VERSION_ID=' /etc/os-release | cut -d '=' -f 2 | tr -d '"')
DEBVER=$(grep 'VERSION=' /etc/os-release | grep -Eo '[a-z]+')
DEBARCH=$(dpkg --print-architecture)
echo deb https://download.gluster.org/pub/gluster/glusterfs/LATEST/Debian/${DEBID}/${DEBARCH}/apt ${DEBVER} main > /etc/apt/sources.list.d/gluster.list
```

更新软件包列表并安装：

```bash
apt update
apt install glusterfs-server
```

#### Ubuntu

Install software-properties-common:

```bash
apt install software-properties-common
```

Then add the community GlusterFS PPA:

```bash
add-apt-repository ppa:gluster/glusterfs-7
apt update
```

Finally, install the packages:

```bash
apt install glusterfs-server
```

#### Red Hat / CentOS

RPMs for CentOS and other RHEL clones are available from the CentOS Storage SIG mirrors.

```bash
# CentOS Stream release 8
yum install centos-release-gluster10
# 可能会提示缺少软件包，通过下面命令安装
yum install http://mirror.centos.org/centos/8-stream/PowerTools/x86_64/os/Packages/python3-pyxattr-0.5.3-18.el8.x86_64.rpm
yum install glusterfs-server
```

#### Fedora

```bash
dnf install glusterfs-server
```

#### Arch Linux

```bash
pacman -S glusterfs
```

### 启动 GlusterFS

```bash
systemctl start glusterd
systemctl enable glusterd
```

### 配置防火墙

```bash
iptables -I INPUT -p all -s <ip-address> -j ACCEPT
# ip-address 是其他节点的地址。
```

### 配置受信任的池

从 "server1" 上执行：

```bash
gluster peer probe server2
gluster peer probe server3
```

> **注意：**
>
> When using hostnames, the first server i.e, `server1` needs to be probed from ***one\*** other server to set its hostname. Reason being when the other server i.e, `server2` is probed from `server1` it may happen that the hosts are configured in a way that the IP Address of the server is transmitted on probing. So in order to use the hostnames in the cluster, it is advised to probe back the `server1` from `server2`, `server3` or upto nth server based on the cluster size.
>
> 使用主机名时，需要从另一台服务器探测第一台服务器，即server1，以设置其主机名。原因是当从服务器1探测另一个服务器（即，服务器2）时，可能会发生主机配置为在探测时传输服务器的IP地址的情况。因此，为了在集群中使用主机名，建议根据集群大小从服务器2、服务器3或第n个服务器探测服务器1。

从 "server2" 上执行：

```bash
gluster peer probe server1
```

> **注意：**
>
> Once this pool has been established, only trusted members may probe new servers into the pool. A new server cannot probe the pool, it must be probed from the pool.
>
> 一旦建立了此池，只有受信任的成员才能将新服务器探测到池中。新服务器无法探测池，必须从池中探测它。

检查 server1 上的对等状态：

```bash
gluster peer status

Number of Peers: 2

Hostname: server2
Uuid: f0e7b138-4874-4bc0-ab91-54f20c7068b4
State: Peer in Cluster (Connected)

Hostname: server3
Uuid: f0e7b138-4532-4bc0-ab91-54f20c701241
State: Peer in Cluster (Connected)
```



Remember that the trusted pool is the term used to define a cluster of nodes in Gluster. Choose a server to be your “primary” server. This is just to keep things simple, you will generally want to run all commands from this tutorial. Keep in mind, running many Gluster specific commands (like `gluster volume create`) on one server in the cluster will execute the same command on all other servers.

Replace `nodename` with hostname of the other server in the cluster, or IP address if you don’t have DNS or `/etc/hosts` entries. Let say we want to connect to `node02`:

```
# gluster peer probe node02
```

Notice that running `gluster peer status` from the second node shows that the first node has already been added.

请记住，可信池是用于在Gluster中定义节点集群的术语。选择一台服务器作为“主”服务器。这只是为了保持简单，您通常希望运行本教程中的所有命令。请记住，在集群中的一台服务器上运行许多特定于Gluster的命令（如Gluster volume create）将在所有其他服务器上执行相同的命令。

如果没有DNS或/etc/hosts条目，则将nodename替换为集群中其他服务器的主机名或IP地址。假设我们要连接到node02：

请注意，从第二个节点运行gluster对等状态表明第一个节点已经添加。

### 设置 GlusterFS 卷

在所有服务器上：

```bash
mkdir -p /data/brick1/gv0
```

从任何一台服务器上：

```bash
gluster volume create gv0 replica 3 server1:/data/brick1/gv0 server2:/data/brick1/gv0 server3:/data/brick1/gv0
volume create: gv0: success: please start the volume to access data

gluster volume start gv0
volume start: gv0: success
```

确认卷显示 "Started" ：

```bash
gluster volume info

Volume Name: gv0
Type: Replicate
Volume ID: f25cc3d8-631f-41bd-96e1-3e22a4c6f71f
Status: Started
Snapshot Count: 0
Number of Bricks: 1 x 3 = 3
Transport-type: tcp
Bricks:
Brick1: server1:/data/brick1/gv0
Brick2: server2:/data/brick1/gv0
Brick3: server3:/data/brick1/gv0
Options Reconfigured:
transport.address-family: inet
```

> **Note：**
>
> If the volume does not show "Started", the files under `/var/log/glusterfs/glusterd.log` should be checked in order to debug and diagnose the situation. These logs can be looked at on one or, all the servers configured.
>
> 如果卷未显示“已启动”，则会显示/var/log/glusterfs/glusterd下的文件。为了调试和诊断情况，应该检查日志。可以在一台或所有配置的服务器上查看这些日志。

### 测试 GlusterFS 卷

For this step, we will use one of the servers to mount the volume. Typically, you would do this from an external machine, known as a "client". Since using this method would require additional packages to be installed on the client machine, we will use one of the servers as a simple place to test first , as if it were that "client".对于此步骤，我们将使用其中一台服务器来装载卷。通常，您可以从称为“客户端”的外部计算机执行此操作。由于使用此方法将需要在客户机上安装其他软件包，因此我们将使用其中一个服务器作为一个简单的地方进行测试，就像它是“客户机”一样。

```bash
mount -t glusterfs server1:/gv0 /mnt

for i in `seq -w 1 100`; do cp -rp /var/log/messages /mnt/copy-test-$i; done
```

首先，检查客户端挂载点：

```bash
ls -lA /mnt/copy* | wc -l
```

应该看到返回了 100 个文件。接下来，检查每个服务器上的 GlusterFS brick 挂载点：

```bash
ls -lA /data/brick1/gv0/copy*
```

使用这里列出的方法，您应该可以在每台服务器上看到 100 个文件。在没有复制的情况下，在a distribute only volume仅分发卷（此处未详细说明）中，应该在每个卷上看到大约 33 个文件。

## 架构

 ![architecture](../Image/g/GlusterFS_Translator_Stack.png)

A gluster volume is a collection of servers belonging to a Trusted Storage Pool. 是属于受信任存储池的服务器的集合。管理守护程序（glusterd）在每台服务器上运行，并管理一个 brick 进程（glusterfsd），which in turn exports the underlying on disk storage (XFS 文件系统). 客户端进程挂载卷，并将所有 brick 中的存储作为单个统一存储命名空间公开给访问它的应用程序。The client and brick processes' stacks have various translators loaded in them.客户端和 brick 进程的堆栈中加载了各种转换器。来自应用程序的I/O通过这些转换器路由到不同的 brick 。

### 卷的类型

Gluster 文件系统根据需要支持不同类型的卷。有些卷有利于扩展存储大小，有些卷有助于提高性能，有些卷则两者兼而有之。

#### 分布式 Glusterfs 卷

Distributed Glusterfs Volume

在未指定卷类型的情况下，默认创建该卷。在这里，文件分布在卷中的各个 brick 上。因此，file1 只能存储在 brick1 或 brick2 中，而不能同时存储在两者上。因此，没有数据冗余。这种存储卷的目的是方便且廉价地缩放卷大小。然而，这也意味着 brick 故障将导致数据完全丢失，必须依靠底层硬件进行数据丢失保护。

Create a Distributed Volume

```bash
gluster volume create NEW-VOLNAME [transport [tcp | rdma | tcp,rdma]] NEW-BRICK...
```

**For example** to create a distributed volume with four storage servers using TCP.

```bash
gluster volume create test-volume server1:/exp1 server2:/exp2 server3:/exp3 server4:/exp4
```

To display the volume info

```bash
gluster volume info

Volume Name: test-volume
Type: Distribute
Status: Created
Number of Bricks: 4
Transport-type: tcp
Bricks:
Brick1: server1:/exp1
Brick2: server2:/exp2
Brick3: server3:/exp3
Brick4: server4:/exp4
```

#### 复制 Glusterfs 卷

Replicated Glusterfs Volume

在本卷中，克服了分布式卷中存在的数据丢失风险。在这里，数据的精确副本保存在所有 brick 上。创建卷时，卷中副本的数量可以由客户端决定。因此，我们需要至少两块 brick 来创建一个具有 2 个副本的卷，或者至少三块 brick 才能创建一个包含 3 个副本的卷。这种卷的一个主要优点是，即使一块 brick 出现故障，也可以从其复制的 brick 中访问数据。这样的卷用于更好的可靠性和数据冗余。

 

Create a Replicated Volume

```bash
gluster volume create NEW-VOLNAME [replica COUNT] [transport [tcp |rdma | tcp,rdma]] NEW-BRICK...
```

**For example**, to create a replicated volume with three storage servers:

```bash
gluster volume create test-volume replica 3 transport tcp \
      server1:/exp1 server2:/exp2 server3:/exp3
```

#### 分布式复制 Glusterfs 卷

Distributed Replicated Glusterfs Volume

在此卷中，文件分布在复制的 brick 组中。brick 的数量必须是副本计数的倍数。此外，指定 brick 的顺序也很重要，因为相邻 brick 会成为彼此的复制品。This type of volume is used when high availability of data due to redundancy and scaling storage is required. 当由于冗余和扩展存储而需要数据的高可用性时，使用这种类型的卷。因此，如果有八块 brick ，副本计数为 2，则前两块 brick 将成为彼此的副本，然后是下两块 brick ，依此类推。此卷表示为 4 x 2。同样，如果有 8 块 brick ，且副本计数为 4，则四块 brick 将变成彼此的副本。我们将此卷称为 2 x 4 卷。



Create the distributed replicated volume:

```bash
gluster volume create NEW-VOLNAME [replica COUNT] [transport [tcp | rdma | tcp,rdma]] NEW-BRICK...
```

**For example**, six node distributed replicated volume with a three-way mirror:

```bash
gluster volume create test-volume replica 3 transport tcp server1:/exp1 server2:/exp2 server3:/exp3 server4:/exp4 server5:/exp5 server6:/exp6
volume create: test-volume: success: please start the volume to access data
```

#### Dispersed Glusterfs Volume

Dispersed volumes are based on erasure codes. It stripes the encoded data of files, with some redundancy added, across multiple bricks in the volume. You can use dispersed volumes to have a configurable level of reliability with minimum space waste. The number of redundant bricks in the volume can be decided by clients while creating the volume. Redundant bricks determines how many bricks can be lost without interrupting the operation of the volume.

分散的卷基于擦除代码。它将文件的编码数据分条，并在卷中的多块砖上添加一些冗余。您可以使用分散的卷，以最小的空间浪费实现可配置的可靠性级别。创建卷时，客户端可以决定卷中冗余砖的数量。冗余砖块确定在不中断卷操作的情况下可以丢失多少砖块。

 Create a dispersed volume:

```bash
gluster volume create test-volume [disperse [<COUNT>]] [disperse-data <COUNT>] [redundancy <COUNT>] [transport tcp | rdma | tcp,rdma] <NEW-BRICK>
```

**For example**, three node dispersed volume with level of redundancy 1, (2 + 1):

```bash
gluster volume create test-volume disperse 3 redundancy 1 server1:/exp1 server2:/exp2 server3:/exp3
```

#### Distributed Dispersed Glusterfs Volume

Distributed dispersed volumes are the equivalent to distributed replicated volumes, but using dispersed subvolumes instead of replicated ones. The number of bricks must be a multiple of the 1st subvol. The purpose for such a volume is to easily scale the volume size and distribute the load across various bricks.

分布式分散卷等同于分布式复制卷，但使用分散的子卷而不是复制的子卷。砖的数量必须是第一个子体积的倍数。这种体积的目的是方便地缩放体积大小，并将负载分布在各个砖上。

Create a distributed dispersed volume:

```bash
gluster volume create [disperse [<COUNT>]] [disperse-data <COUNT>] [redundancy <COUNT>] [transport tcp | rdma | tcp,rdma] <NEW-BRICK>
```

**For example**, six node distributed dispersed volume with level of redundancy 1, 2 x (2 + 1) = 6:

```bash
gluster volume create test-volume disperse 3 redundancy 1 server1:/exp1 server2:/exp2 server3:/exp3 server4:/exp4 server5:/exp5 server6:/exp6
```

> **Note**:
>
> - A dispersed volume can be created by specifying the number of bricks in a   disperse set, by specifying the number of redundancy bricks, or both.
>
> - If *disperse* is not specified, or the `<COUNT>` is missing, the   entire volume will be treated as a single disperse set composed by all   bricks enumerated in the command line.
>
> - If *redundancy* is not specified, it is computed automatically to be the   optimal value. If this value does not exist, it's assumed to be '1' and a   warning message is shown:
>
>   \# gluster volume create test-volume disperse 4 server{1..4}:/bricks/test-volume     There isn't an optimal redundancy value for this configuration. Do you want to create the volume with redundancy 1 ? (y/n)
>
> - In all cases where *redundancy* is automatically computed and it's not   equal to '1', a warning message is displayed:
>
>   \# gluster volume create test-volume disperse 6 server{1..6}:/bricks/test-volume     The optimal redundancy for this configuration is 2. Do you want to create the volume with this value ? (y/n)
>
> - *redundancy* must be greater than 0, and the total number of bricks must   be greater than 2 * *redundancy*. This means that a dispersed volume must   have a minimum of 3 bricks.
>
> - 可以通过指定分散集中的砖块数量、指定冗余砖块数量或两者来创建分散体。
>
>   如果未指定分散，或者缺少＜COUNT＞，则整个卷将被视为由命令行中枚举的所有砖块组成的单个分散集。
>
>   如果未指定冗余，则会自动将其计算为最佳值。如果该值不存在，则假定为“1”，并显示警告消息：
>
>   \#gluster卷创建测试卷分散4服务器｛1..4｝：/bricks/测试卷
>
>   此配置没有最佳冗余值。是否要创建具有冗余1的卷？（是/否）
>
>   在所有自动计算冗余且不等于“1”的情况下，将显示警告消息：
>
>   \#胶卷创建测试卷分散6服务器｛1..6｝：/brickers/测试卷
>
>   此配置的最佳冗余为2。是否要使用此值创建卷？（是/否）
>
>   冗余度必须大于0，砖的总数必须大于2*冗余度。这意味着分散体积必须至少有3块砖。

### **FUSE**

GlusterFS is a userspace filesystem. The GluserFS developers opted  for this approach in order to avoid the need to have modules in the  Linux kernel.

As it is a userspace filesystem, to interact with kernel VFS, GlusterFS makes use of FUSE (File System in Userspace). For a long time, implementation of a userspace filesystem was considered impossible. FUSE was developed as a solution for this. FUSE is a kernel module that support interaction between kernel VFS and non-privileged user applications and it has an API that can be accessed from userspace. Using this API, any type of filesystem can be written using almost any language you prefer as there are many bindings between FUSE and other languages.

Gluster FS是一个用户空间文件系统。Gluser FS开发人员选择了这种方法，以避免在Linux内核中使用模块。

由于它是一个用户空间文件系统，为了与内核VFS交互，Gluster  FS使用FUSE（用户空间中的文件系统）。长期以来，用户空间文件系统的实现被认为是不可能的。FUSE就是为此开发的解决方案。FUSE是一个内核模块，支持内核VFS和非特权用户应用程序之间的交互，它有一个可以从用户空间访问的API。使用此API，几乎可以使用您喜欢的任何语言编写任何类型的文件系统，因为FUSE和其他语言之间有许多绑定。

 ![](../Image/f/fuse.png)

*Structural diagram of FUSE.*

This shows a filesystem "hello world" that is compiled to create a binary "hello". It is executed with a filesystem mount point /tmp/fuse. Then the user issues a command ls -l on the mount point /tmp/fuse. This command reaches VFS via glibc and since the mount /tmp/fuse corresponds to a FUSE based filesystem, VFS passes it over to FUSE module. The FUSE kernel module contacts the actual filesystem binary "hello" after passing through glibc and FUSE library in userspace(libfuse). The result is returned by the "hello" through the same path and reaches the ls -l command.

The communication between FUSE kernel module and the FUSE library(libfuse) is via a special file descriptor which is obtained by opening /dev/fuse. This file can be opened multiple times, and the obtained file descriptor is passed to the mount syscall, to match up the descriptor with the mounted filesystem.

FUSE结构图。

这显示了一个文件系统“helloworld”，该文件系统被编译为创建二进制文件“hello”。它使用文件系统装载点/tmp/fuse执行。然后，用户在装载点/tmp/fuse上发出命令ls-l。该命令通过glibc到达VFS，由于mount/tmp/fuse对应于基于fuse的文件系统，VFS将其传递给fuse模块。FUSE内核模块在通过用户空间（libfuse）中的glibc和FUSE库后，与实际的文件系统二进制文件“hello”接触。结果由“hello”通过相同路径返回，并到达ls-l命令。

FUSE内核模块和FUSE库（libfuse）之间的通信是通过打开/dev/FUSE获得的一个特殊文件描述符实现的。可以多次打开该文件，并将获得的文件描述符传递给mount syscall，以使描述符与已安装的文件系统匹配。

- [More about userspace     filesystems](http://www.linux-mag.com/id/7814/)
- [FUSE reference](http://fuse.sourceforge.net/)

### Translators

翻译人员

翻译“翻译人员”：

翻译器将用户的请求转换为存储请求。

*一对一、一对多、一对零（例如缓存）

**Translating “translators”**:

- A translator converts requests from users into requests for storage.

  *One to one, one to many, one to zero (e.g. caching)

![translator](https://cloud.githubusercontent.com/assets/10970993/7412595/fd46c492-ef61-11e4-8f49-61dbd15b9695.png)

- A translator can modify requests on the way through :

  *convert one request type to another ( during the request transfer amongst the translators)* modify paths, flags, even data (e.g. encryption)

- Translators can intercept or block the requests. (e.g. access    control)

- Or spawn new requests (e.g. pre-fetch)

翻译人员可以通过以下方式修改请求：

将一种请求类型转换为另一种请求（在转换器之间的请求传输期间），修改路径、标志甚至数据（例如加密）

翻译人员可以拦截或阻止请求。（例如访问控制）

或产生新请求（例如预取）

**How Do Translators Work?**

- Shared Objects

- Dynamically loaded according to 'volfile'

  *dlopen/dlsync* setup pointers to parents / children *call init (constructor)* call IO functions through fops.

- Conventions for validating/ passing options, etc.

- The configuration of translators (since GlusterFS 3.1) is managed    through the gluster command line interface (cli), so you don't need    to know in what order to graph the translators together.

译者是如何工作的？

共享对象

根据“volfile”动态加载

dlopen/dlsync设置指针指向父母/子女，通过fops调用init（构造函数）调用IO函数。

验证/传递选项等的惯例。

翻译器的配置（从Gluster FS 3.1开始）是通过Gluster命令行接口（cli）管理的，因此您不需要知道将翻译器按什么顺序绘制在一起。

#### Types of Translators

List of known translators with their current status.

| Translator Type | Functional Purpose                                           |
| --------------- | ------------------------------------------------------------ |
| Storage         | Lowest level translator, stores and accesses data from local file system. |
| Debug           | Provide interface and statistics for errors and debugging.   |
| Cluster         | Handle distribution and replication of data as it relates to writing to and reading from bricks & nodes. |
| Encryption      | Extension translators for on-the-fly encryption/decryption of stored data. |
| Protocol        | Extension translators for client/server communication protocols. |
| Performance     | Tuning translators to adjust for workload and I/O profiles.  |
| Bindings        | Add extensibility, e.g. The Python interface written by Jeff Darcy to extend API interaction with GlusterFS. |
| System          | System access translators, e.g. Interfacing with file system access control. |
| Scheduler       | I/O schedulers that determine how to distribute new write operations across clustered systems. |
| Features        | Add additional features such as Quotas, Filters, Locks, etc. |

The default / general hierarchy of translators in vol files :

![](../Image/t/07d93ce4-3771-11e5-8bda-9018871aa6fb.png)

All the translators hooked together to perform a function is called a graph. The left-set of translators comprises of **Client-stack**.The right-set of translators comprises of **Server-stack**.

**The glusterfs translators can be sub-divided into many categories, but two important categories are - Cluster and Performance translators :**

One of the most important and the first translator the data/request has to go through is **fuse translator** which falls under the category of **Mount Translators**.

1. **Cluster Translators**:
   - DHT(Distributed Hash Table)
   - AFR(Automatic File Replication)
2. **Performance Translators**:
   - io-cache
   - io-threads
   - md-cache
   - O-B (open behind)
   - QR (quick read)
   - r-a (read-ahead)
   - w-b (write-behind)

Other **Feature Translators** include:

- changelog
- locks - GlusterFS has locks  translator which provides the following internal locking operations  called `inodelk`, `entrylk`,  which are used by afr to achieve synchronization of operations on files or directories that conflict with each other.
- marker
- quota

**Debug Translators**

- trace - To trace the error logs generated during the communication amongst the translators.
- io-stats

#### DHT(Distributed Hash Table) Translator

**What is DHT?**

DHT is the real core of how GlusterFS aggregates capacity and performance across multiple servers. Its responsibility is to place each file on exactly one of its subvolumes – unlike either replication (which places copies on all of its subvolumes) or striping (which places pieces onto all of its subvolumes). It’s a routing function, not splitting or copying.

**How DHT works**?

The basic method used in DHT is consistent hashing. Each subvolume (brick) is assigned a range within a 32-bit hash space, covering the entire range with no holes or overlaps. Then each file is also assigned a value in that same space, by hashing its name. Exactly one brick will have an assigned range including the file’s hash value, and so the file “should” be on that brick. However, there are many cases where that won’t be the case, such as when the set of bricks (and therefore the range assignment of ranges) has changed since the file was created, or when a brick is nearly full. Much of the complexity in DHT involves these special cases, which we’ll discuss in a moment.

When you open() a file, the distribute translator is giving one piece of information to find your file, the file-name. To determine where that file is, the translator runs the file-name through a hashing algorithm in order to turn that file-name into a number.

**A few Observations of DHT hash-values assignment**:

1. The assignment of hash ranges to bricks is determined by extended    attributes stored on directories, hence distribution is    directory-specific.
2. Consistent hashing is usually thought of as hashing around a circle,    but in GlusterFS it’s more linear. There’s no need to “wrap around”    at zero, because there’s always a break (between one brick’s range    and another’s) at zero.
3. If a brick is missing, there will be a hole in the hash space. Even    worse, if hash ranges are reassigned while a brick is offline, some    of the new ranges might overlap with the (now out of date) range    stored on that brick, creating a bit of confusion about where files    should be.

#### AFR(Automatic File Replication) Translator

The Automatic File Replication (AFR) translator in GlusterFS makes use of the extended attributes to keep track of the file operations.It is responsible for replicating the data across the bricks.

##### Responsibilities of AFR

Its responsibilities include the following:

1. Maintain replication consistency (i.e. Data on both the bricks    should be same, even in the cases where there are operations    happening on same file/directory in parallel from multiple    applications/mount points as long as all the bricks in replica set    are up).
2. Provide a way of recovering data in case of failures as long as    there is at least one brick which has the correct data.
3. Serve fresh data for read/stat/readdir etc.

#### Geo-Replication

Geo-replication provides asynchronous replication of data across geographically distinct locations and was introduced in Glusterfs 3.2. It mainly works across WAN and is used to replicate the entire volume unlike AFR which is intra-cluster replication. This is mainly useful for backup of entire data for disaster recovery.

Geo-replication uses a primary-secondary model, whereby replication occurs between a **Primary** and a **Secondary**, both of which should  be GlusterFS volumes. Geo-replication provides an incremental replication service over Local Area Networks (LANs), Wide Area Network (WANs), and across the Internet.

**Geo-replication over LAN**

You can configure Geo-replication to mirror data over a Local Area Network.

![geo-rep_lan](https://cloud.githubusercontent.com/assets/10970993/7412281/a542e724-ef5e-11e4-8207-9e018c1e9304.png)

**Geo-replication over WAN**

You can configure Geo-replication to replicate data over a Wide Area Network.

![geo-rep_wan](https://cloud.githubusercontent.com/assets/10970993/7412292/c3816f76-ef5e-11e4-8daa-271f6efa1f58.png)

**Geo-replication over Internet**

You can configure Geo-replication to mirror data over the Internet.

![geo-rep03_internet](https://cloud.githubusercontent.com/assets/10970993/7412305/d8660050-ef5e-11e4-9d1b-54369fb1e43f.png)

**Multi-site cascading Geo-replication**

You can configure Geo-replication to mirror data in a cascading fashion across multiple sites.

![geo-rep04_cascading](https://cloud.githubusercontent.com/assets/10970993/7412320/05e131bc-ef5f-11e4-8580-a4dc592148ff.png)

There are mainly two aspects while asynchronously replicating data:

1.**Change detection** - These include file-operation necessary details. There are two methods to sync the detected changes:

i. Changelogs - Changelog is a translator which records necessary details for the fops that occur. The changes can be written in binary format or ASCII. There are three category with each category represented by a specific changelog format. All three types of categories are recorded in a single changelog file.

**Entry** - create(), mkdir(), mknod(), symlink(), link(), rename(), unlink(), rmdir()

**Data** - write(), writev(), truncate(), ftruncate()

**Meta** - setattr(), fsetattr(), setxattr(), fsetxattr(), removexattr(), fremovexattr()

In order to record the type of operation and entity underwent, a type identifier is used. Normally, the entity on which the operation is performed would be identified by the pathname, but we choose to use GlusterFS internal file identifier (GFID) instead (as GlusterFS supports GFID based backend and the pathname field may not always be valid and other reasons which are out of scope of this document). Therefore, the format of the record for the three types of operation can be summarized as follows:

Entry - GFID + FOP + MODE + UID + GID + PARGFID/BNAME [PARGFID/BNAME]

Meta - GFID of the file

Data - GFID of the file

GFID's are analogous to inodes. Data and Meta fops record the GFID of the entity on which the operation was performed, thereby recording that there was a data/metadata change on the inode. Entry fops record at the minimum a set of six or seven records (depending on the type of operation), that is sufficient to identify what type of operation the entity underwent. Normally this record includes the GFID of the entity, the type of file operation (which is an integer [an enumerated value which is used in Glusterfs]) and the parent GFID and the basename (analogous to parent inode and basename).

Changelog file is rolled over after a specific time interval. We then perform processing operations on the file like converting it to understandable/human readable format, keeping private copy of the changelog etc. The library then consumes these logs and serves application requests.

ii. Xsync - Marker translator maintains an extended attribute “xtime” for each file and directory. Whenever any update happens it would update the xtime attribute of that file and all its ancestors. So the change is propagated from the node (where the change has occurred) all the way to the root.

![geo-replication-sync](https://cloud.githubusercontent.com/assets/10970993/7412646/824add4a-ef62-11e4-9a0b-5cc270be6a10.png)

Consider the above directory tree structure. At time T1 the primary and secondary were in sync each other.

![geo-replication-async](https://cloud.githubusercontent.com/assets/10970993/7412653/93b04e30-ef62-11e4-9ab1-e5cc57eb0db5.jpg)

At time T2 a new file File2 was created. This will trigger the xtime marking (where xtime is the current timestamp) from File2 upto to the root, i.e, the xtime of File2, Dir3, Dir1 and finally Dir0 all will be updated.

Geo-replication daemon crawls the file system based on the condition that xtime(primary) > xtime(secondary). Hence in our example it would crawl only the left part of the directory structure since the right part of the directory structure still has equal timestamp. Although the crawling algorithm is fast we still need to crawl a good part of the directory structure.

2.**Replication** - We use rsync for data replication. Rsync is an external utility which will calculate the diff of the two files and sends this difference from source to sync.

### Overall working of GlusterFS

As soon as GlusterFS is installed in a server node, a gluster management daemon(glusterd) binary will be created. This daemon should be running in all participating nodes in the cluster. After starting glusterd, a trusted server pool(TSP) can be created consisting of all storage server nodes (TSP can contain even a single node). Now bricks which are the basic units of storage can be created as export directories in these servers. Any number of bricks from this TSP can be clubbed together to form a volume.

Once a volume is created, a glusterfsd process starts running in each of the participating brick. Along with this, configuration files known as vol files will be generated inside /var/lib/glusterd/vols/. There will be configuration files corresponding to each brick in the volume. This will contain all the details about that particular brick. Configuration file required by a client process will also be created. Now our filesystem is ready to use. We can mount this volume on a client machine very easily as follows and use it like we use a local storage:

mount.glusterfs `<IP or hostname>`:`<volume_name>` `<mount_point>`

IP or hostname can be that of any node in the trusted server pool in which the required volume is created.

When we mount the volume in the client, the client glusterfs process communicates with the servers’ glusterd process. Server glusterd process sends a configuration file (vol file) containing the list of client translators and another containing the information of each brick in the volume with the help of which the client glusterfs process can now directly communicate with each brick’s glusterfsd process. The setup is now complete and the volume is now ready for client's service.

![overallprocess](https://cloud.githubusercontent.com/assets/10970993/7412664/a9aaaece-ef62-11e4-8c87-75d8e7157739.png)

When a system call (File operation or Fop) is issued by client in the mounted filesystem, the VFS (identifying the type of filesystem to be glusterfs) will send the request to the FUSE kernel module. The FUSE kernel module will in turn send it to the GlusterFS in the userspace of the client node via /dev/fuse (this has been described in FUSE section). The GlusterFS process on the client consists of a stack of translators called the client translators which are defined in the configuration file(vol file) sent by the storage server glusterd process. The first among these translators being the FUSE translator which consists of the FUSE library(libfuse). Each translator has got functions corresponding to each file operation or fop supported by glusterfs. The request will hit the corresponding function in each of the translators. Main client translators include:

- FUSE translator
- DHT translator- DHT translator maps the request to the correct brick    that contains the file or directory required.
- AFR translator- It receives the request from the previous translator    and if the volume type is replicate, it duplicates the request and    passes it on to the Protocol client translators of the replicas.
- Protocol Client translator- Protocol Client translator is the last    in the client translator stack. This translator is divided into    multiple threads, one for each brick in the volume. This will    directly communicate with the glusterfsd of each brick.

In the storage server node that contains the brick in need, the request again goes through a series of translators known as server translators, main ones being:

- Protocol server translator
- POSIX translator

The request will finally reach VFS and then will communicate with the underlying native filesystem. The response will retrace the same path.

### Purpose

The Install Guide (IG) is aimed at providing the sequence of steps needed for setting up Gluster. It contains a reasonable degree of detail which helps an administrator to understand the terminology, the choices and how to configure the deployment to the storage needs of their application workload. The [Quick Start Guide](https://docs.gluster.org/en/latest/Quick-Start-Guide/Quickstart/) (QSG) is designed to get a deployment with default choices and is aimed at those who want to spend less time to get to a deployment.

After you deploy Gluster by following these steps, we recommend that you read the [Gluster Admin Guide](https://docs.gluster.org/en/latest/Administrator-Guide/) to learn how to administer Gluster and how to select a volume type that fits your needs. Also, be sure to enlist the help of the Gluster community via the IRC or, Slack channels (see https://www.gluster.org/community/) or Q&A section.

## Configure

### Partition the disk

Assuming you have an empty disk at `/dev/sdb`: *(You can check the partitions on your system using* `fdisk -l`*)*

对磁盘进行分区

假设您在/dev/sdb上有一个空磁盘：（您可以使用fdisk-l检查系统上的分区）

```

# fdisk /dev/sdb 
```

### Format the partition

```

# mkfs.xfs -i size=512 /dev/sdb1
```

### 向 /etc/fstab 添加条目

```

# echo "/dev/sdb1 /export/sdb1 xfs defaults 0 0"  >> /etc/fstab
```

### Mount the partition as a Gluster "brick"

```

# mkdir -p /export/sdb1 && mount -a && mkdir -p /export/sdb1/brick
```

#### Set up a Gluster volume

The most basic Gluster volume type is a “Distribute only” volume (also referred to as a “pure DHT” volume if you want to impress the folks at the water cooler). This type of volume simply distributes the data evenly across the available bricks in a volume. So, if I write 100 files, on average, fifty will end up on one server, and fifty will end up on another. This is faster than a “replicated” volume, but isn’t as popular since it doesn’t give you two of the most sought after features of Gluster — multiple copies of the data, and automatic failover if something goes wrong.

设置Gluster卷

最基本的Gluster体积类型是“仅分布”体积（如果你想让水冷却器的人印象深刻，也可以称为“纯DHT”体积）。这种类型的卷只是将数据均匀分布在卷中的可用砖上。所以，如果我写100个文件，平均来说，50个文件将在一个服务器上结束，50个将在另一个服务器中结束。这比“复制”卷更快，但并不流行，因为它没有提供Gluster最受欢迎的两个功能—数据的多个副本，以及在出现问题时自动故障切换。

To set up a replicated volume:要设置复制卷，请执行以下操作：

```bash
gluster volume create gv0 replica 3 node01.mydomain.net:/export/sdb1/brick \
    node02.mydomain.net:/export/sdb1/brick                                 \
    node03.mydomain.net:/export/sdb1/brick
```

Breaking this down into pieces:

- the first part says to create a gluster volume named gv0 (the name is arbitrary, `gv0` was chosen simply because it’s less typing than `gluster_volume_0`).
- make the volume a replica volume
- keep a copy of the data on at least 3 bricks at any given time. Since we only have three bricks total, this means each server will house a copy of the data.
- we specify which nodes to use, and which bricks on those nodes. The order here is important when you have more bricks.

将其分解为多个部分：

第一部分是创建一个名为gv0的gluster卷（这个名称是任意的，之所以选择gv0，是因为它比gluster卷0键入更少）。

使卷成为副本卷

在任何给定时间至少在3块砖上保存数据副本。由于我们总共只有三块砖，这意味着每台服务器都将存储一份数据。

我们指定要使用的节点以及这些节点上的砖块。当你有更多的砖块时，这里的顺序很重要。

It is possible (as of the most current release as of this writing, Gluster 3.3) to specify the bricks in such a way that you would make both copies of the data reside on a single node. This would make for an embarrassing explanation to your boss when your bulletproof, completely redundant, always on super cluster comes to a grinding halt when a single point of failure occurs.

可以（截至本文撰写时的最新版本Gluster 3.3）以这样的方式指定砖块，即您可以使数据的两个副本都驻留在一个节点上。当您的防弹、完全冗余、始终在线的超级集群在发生单点故障时陷入严重停顿时，这将给您的老板一个尴尬的解释。

Now, we can check to make sure things are working as expected:

现在，我们可以检查以确保一切按预期进行：

```bash
gluster volume info
```

您应该会看到类似于以下内容的结果：

```bash
Volume Name: gv0
Type: Replicate
Volume ID: 8bc3e96b-a1b6-457d-8f7a-a91d1d4dc019
Status: Created
Number of Bricks: 1 x 3 = 3
Transport-type: tcp
Bricks:
Brick1: node01.yourdomain.net:/export/sdb1/brick
Brick2: node02.yourdomain.net:/export/sdb1/brick
Brick3: node03.yourdomain.net:/export/sdb1/brick
```

This shows us essentially what we just specified during the volume creation. The one this to mention is the `Status`. A status of `Created` means that the volume has been created, but hasn’t yet been started, which would cause any attempt to mount the volume fail.

Now, we should start the volume.

这基本上向我们展示了在卷创建期间刚刚指定的内容。值得注意的一个关键输出是Status。状态为“已创建”表示卷已创建，但尚未启动，这将导致装载卷的任何尝试失败。

现在，我们应该在尝试装载之前启动卷。

```

# gluster volume start gv0
```

## 管理 glusterd 服务

The glusterd service serves as the Gluster elastic volume manager, overseeing glusterfs processes, and co-ordinating dynamic volume operations, such as adding and removing volumes across multiple storage servers non-disruptively.

安装 GlusterFS 后，必须启动 glusterd 服务。glusterd服务充当Gluster弹性卷管理器，监督glusterfs过程，并协调动态卷操作，例如无中断地跨多个存储服务器添加和删除卷。

### Distributions with systemd

#### 手动启动/停止 glusterd

```bash
systemctl start glusterd
systemctl stop glusterd
```

#### 开启 / 关闭开机自动启动

```bash
systemctl enable --now glusterd
systemctl disable --now glusterd
```

### Distributions without systemd

#### 手动启动/停止 glusterd

```bash
/etc/init.d/glusterd start
/etc/init.d/glusterd stop
```

#### 开启 / 关闭开机自动启动

```bash
# Red Hat / Fedora
chkconfig glusterd on

# Debian / Ubuntu
update-rc.d glusterd defaults

# Other
echo "glusterd" >> /etc/rc.local
```

## 管理 Trusted Storage Pool

Before you can configure a GlusterFS volume, you must create a trusted storage pool of the storage servers that will provide bricks to the volume by peer probing the servers. The servers in a TSP are peers of each other.

After installing Gluster on your servers and before creating a trusted storage pool, each server belongs to a storage pool consisting of only that server.

可信存储池（TSP）是存储服务器的可信网络。在配置Gluster FS卷之前，必须创建一个受信任的存储服务器存储池，该池将通过对等探测服务器为卷提供砖块。TSP中的服务器是彼此对等的。

在服务器上安装 Gluster 之后，在创建受信任的存储池之前，每个服务器都属于仅由该服务器组成的存储池。

- 用于创建存储池的服务器必须可按主机名解析。
- glusterd 守护程序必须在要添加到存储池的所有存储服务器上运行。
- 服务器上的防火墙必须配置为允许访问端口 24007 。

The following commands were run on a TSP consisting of 3 servers - server1, server2, and server3.

以下命令在由3个服务器组成的 TSP 上运行：server1、server2和server3。

### 添加服务器

要将服务器添加到 TSP，请从池中已经存在的服务器对其进行对等探测。

```bash
gluster peer probe <server>
```

例如，要将新 server4 添加到上述集群，请从其他服务器之一进行探测：

```bash
# server1
gluster peer probe server4
```

验证第一台服务器（server1）的对等状态：

```bash
# server1
gluster peer status

Number of Peers: 3

Hostname: server2
Uuid: 5e987bda-16dd-43c2-835b-08b7d55e94e5
State: Peer in Cluster (Connected)

Hostname: server3
Uuid: 1e0ca3aa-9ef7-4f66-8f15-cbc348f29ff7
State: Peer in Cluster (Connected)

Hostname: server4
Uuid: 3e0cabaa-9df7-4f66-8e5d-cbc348f29ff7
State: Peer in Cluster (Connected)
```

### 列出服务器

```bash
# server1
gluster pool list

UUID                                    Hostname        State
d18d36c5-533a-4541-ac92-c471241d5418    localhost       Connected
5e987bda-16dd-43c2-835b-08b7d55e94e5    server2         Connected
1e0ca3aa-9ef7-4f66-8f15-cbc348f29ff7    server3         Connected
3e0cabaa-9df7-4f66-8e5d-cbc348f29ff7    server4         Connected
```

### 查看 Peer 状态

```bash
# server1
gluster peer status

Number of Peers: 3

Hostname: server2
Uuid: 5e987bda-16dd-43c2-835b-08b7d55e94e5
State: Peer in Cluster (Connected)

Hostname: server3
Uuid: 1e0ca3aa-9ef7-4f66-8f15-cbc348f29ff7
State: Peer in Cluster (Connected)

Hostname: server4
Uuid: 3e0cabaa-9df7-4f66-8e5d-cbc348f29ff7
State: Peer in Cluster (Connected)
```

### 删除服务器

```bash
gluster peer detach <server>
```

示例：

```bash
gluster peer detach server4
```

查看 Peer 状态：

```bash
gluster peer status

Number of Peers: 2

Hostname: server2
Uuid: 5e987bda-16dd-43c2-835b-08b7d55e94e5
State: Peer in Cluster (Connected)

Hostname: server3
Uuid: 1e0ca3aa-9ef7-4f66-8f15-cbc348f29ff7
State: Peer in Cluster (Connected)
```

## 设置存储

A volume is a logical collection of bricks where each brick is an export directory on a server in the trusted storage pool. Before creating a volume, you need to set up the bricks that will form the volume.

卷是砖的逻辑集合，其中每个砖都是受信任存储池中服务器上的导出目录。在创建卷之前，需要设置将形成卷的砖块。

### Brick 命名惯例

FHS-2.3 isn't entirely clear on where data shared by the server should reside. It does state that "*/srv contains site-specific data which is served by this system*", but is GlusterFS data site-specific?

FHS-2.3并不完全清楚服务器共享的数据应该驻留在哪里。它确实指出“/srv包含由该系统提供的特定站点数据”，但Gluster FS数据是否特定站点？

The consensus seems to lean toward using `/data`. A good hierarchical method for placing bricks is:

共识似乎倾向于使用 `/data`。放置砖块的良好分层方法是：

```bash
/data/glusterfs/<volume>/<brick>/brick
```

In this example, `<brick>` is the filesystem that is mounted.

#### Example: 每台服务器一块 Brick

A physical disk */dev/sdb* is going to be used as brick storage for a volume you're about to create named *myvol1*. You've partitioned and formatted */dev/sdb1* with XFS on each of 4 servers.一个物理磁盘/dev/sdb将被用作您将要创建的名为myvol1的卷的砖式存储。您已经在4台服务器中的每台服务器上使用XFS对/dev/sdb1进行了分区和格式化。

On all 4 servers:

```bash
mkdir -p /data/glusterfs/myvol1/brick1
mount /dev/sdb1 /data/glusterfs/myvol1/brick1
```

We're going to define the actual brick in the `brick` directory on that filesystem. This helps by causing the brick to fail to start if the XFS filesystem isn't mounted.我们将在该文件系统的brick目录中定义实际的brick。这有助于在XFS文件系统未安装时导致砖无法启动。

On just one server:

```
gluster volume create myvol1 replica 2 server{1..4}:/data/glusterfs/myvol1/brick1/brick
```

This will create the volume *myvol1* which uses the directory `/data/glusterfs/myvol1/brick1/brick` on all 4 servers.

#### Example: 每台服务器两块 Brick

Two physical disks */dev/sdb* and */dev/sdc* are going to be used as brick storage for a volume you're about to create named *myvol2*. You've partitioned and formatted */dev/sdb1* and */dev/sdc1* with XFS on each of 4 servers.

两个物理磁盘/dev/sdb和/dev/sdc将用作您将要创建的名为myvol2的卷的砖式存储。您已在4台服务器上分别使用XFS对/dev/sdb1和/dev/sdc1进行分区和格式化。

On all 4 servers:

```

mkdir -p /data/glusterfs/myvol2/brick{1,2}
mount /dev/sdb1 /data/glusterfs/myvol2/brick1
mount /dev/sdc1 /data/glusterfs/myvol2/brick2
```

Again we're going to define the actual brick in the `brick` directory on these filesystems

再次，我们将在这些文件系统的brick目录中定义实际的brick。

On just one server:

```

gluster volume create myvol2 replica 2 \
  server{1..4}:/data/glusterfs/myvol2/brick1/brick \
  server{1..4}:/data/glusterfs/myvol2/brick2/brick
```

**Note:** It might be tempting to try `gluster volume create myvol2 replica 2 server{1..4}:/data/glusterfs/myvol2/brick{1,2}/brick` but Bash would expand the last `{}` first, so you would end up replicating between the two bricks on each servers, instead of across servers.

注意：尝试gluster volume create myvol2 replica 2  server｛1..4｝：/data/glusterfs/myvol2/brick｛1,2｝/brick可能很诱人，但Bash会首先扩展最后一个｛｝，因此您最终会在每个服务器上的两个brick之间进行复制，而不是跨服务器进行复制。

### 格式化和挂载 Brick

#### 创建精简配置的逻辑卷

1. 使用 pvcreate 命令创建物理卷（PV）。例如：

   ```bash
   pvcreate --dataalignment 128K /dev/sdb
   ```

   这里，/dev/sdb 是一个存储设备。根据您的设备使用正确的数据对齐选项。

   > **Note:** 
   >
   > 设备名称和对齐值会因您使用的设备而异。

2. 使用 vgcreate 命令从 PV 创建卷组（VG）。例如：

   ```bash
   vgcreate --physicalextentsize 128K gfs_vg /dev/sdb
   ```

   It is recommended that only one VG must be created from one storage device.

3. 使用以下命令创建精简池：

   1. 使用以下命令创建 LV 作为元数据设备：

      ```bash
      lvcreate -L metadev_sz --name metadata_device_name VOLGROUP
      ```

      例如：

      ```bash
      lvcreate -L 16776960K --name gfs_pool_meta gfs_vg
      ```

   2. 使用以下命令创建 LV 作为数据设备：

      ```bash
      lvcreate -L datadev_sz --name thin_pool VOLGROUP`
      ```

      例如：

      ```bash
      lvcreate -L 536870400K --name gfs_pool gfs_vg
      ```

   3. 使用以下命令从数据 LV 和元数据 LV 创建精简池：

      ```bash
      lvconvert --chunksize STRIPE_WIDTH --thinpool VOLGROUP/thin_pool --poolmetadata VOLGROUP/metadata_device_name
      ```

      例如：

      ```bash
      lvconvert --chunksize 1280K --thinpool gfs_vg/gfs_pool --poolmetadata gfs_vg/gfs_pool_meta
      ```

      > **Note:** the newly provisioned chunks in a thin pool are zeroed to prevent data leaking between different block devices.
      >
      > 默认情况下，精简池中新配置的块将归零，以防止不同块设备之间的数据泄漏。

      ```bash
      lvchange --zero n VOLGROUP/thin_pool
      ```

      例如：

      ```bash
      lvchange --zero n gfs_vg/gfs_pool
      ```

4. 使用 lvcreate 命令从先前创建的池创建精简配置卷：

   例如：

   ```bash
   lvcreate -V 1G -T gfs_vg/gfs_pool -n gfs_lv
   ```

   建议在精简池中只创建一个 LV 。

   Format bricks using the supported XFS configuration, 使用支持的XFS配置格式化砖块，挂载 brick ，并验证brick 是否正确安装。

   运行 `mkfs.xfs -f -i size=512 -n size=8192 -d su=128k,sw=10 DEVICE`  将 brick 格式化为支持的 XFS 文件系统格式。这里，DEVICE 是 精简配置 LV（这里是 /dev/gfs-vg/gfs-LV ）。inode 大小设置为 512 字节，以适应GlusterFS 使用的扩展属性。

   运行 `mkdir /mountpoint` 创建一个目录，将 brick 链接到该目录。

   在 /etc/fstab 中添加条目：

   ```bash
   /dev/gfs_vg/gfs_lv    /mountpoint  xfs rw,inode64,noatime,nouuid      1 2
   ```

   执行  `mount /mountpoint`  挂载 brick 。

   执行  `df -h`  命令去确认 brick 被成功挂载。

   ```bash
   df -h
   
   /dev/gfs_vg/gfs_lv   16G  1.2G   15G   7% /exp1
   ```

### POSIX 访问控制列表

POSIX 访问控制列表（ACL）允许您为不同的用户或组分配不同的权限，即使它们与原始所有者或所属组不对应。

例如：用户 john 创建了一个文件，但不允许任何人对该文件执行任何操作，除了另一个用户 antoy（即使有其他用户属于组 john ）。

这意味着，除了文件所有者、文件组和其他人之外，还可以通过使用 POSIX ACL 授予或拒绝其他用户和组访问权限。

#### 激活 POSIX ACL 支持

要对文件或目录使用 POSIX ACL ，文件或目录的分区必须安装 POSIX ACL 支持。

##### 在服务器上激活 POSIX ACL 支持

要装载 POSIX ACL 支持的后端导出目录，请使用以下命令：

```bash
mount -o acl
```

例如：

```bash
mount -o acl /dev/sda1 /export1
```

或者，如果分区列在 /etc/fstab 文件中，请为分区添加以下条目以包含 POSIX ACL 选项：

```bash
LABEL=/work /export1 ext3 rw,acl 14
```

##### 在客户端上激活 POSIX ACL 支持

要挂载 POSIX ACL 支持的 glusterfs 卷，请使用以下命令：

```bash
mount –t glusterfs -o acl
```

例如：

```bash
mount -t glusterfs -o acl 198.192.198.234:glustervolume /mnt/gluster
```

#### 设置 POSIX ACL

您可以设置两种类型的 POSIX ACL ，即访问 ACL 和默认 ACL 。您可以使用访问 ACL 授予特定文件或目录的权限。您只能在目录上使用默认 ACL ，但如果该目录中的文件没有 AC L，则它将继承该目录的默认 ACL 的权限。

You can set ACLs for per user, per group, for users not in the user group for the file, and via the effective right mask.您可以通过有效的权限掩码为每个用户、每个组、不在文件的用户组中的用户设置 ACL 。

##### Setting Access ACLs

You can apply access ACLs to grant permission for both files and directories.

**To set or modify Access ACLs**

You can set or modify access ACLs use the following command:

```

setfacl –m  file
```

The ACL entry types are the POSIX ACLs representations of owner, group, and other.

Permissions must be a combination of the characters `r` (read), `w` (write), and `x` (execute). You must specify the ACL entry in the following format and can specify multiple entry types separated by commas.

| ACL Entry           | Description                                                  |
| ------------------- | ------------------------------------------------------------ |
| u:uid:\<permission> | Sets the access ACLs for a user. You can specify user name or UID |
| g:gid:\<permission> | Sets the access ACLs for a group. You can specify group name or GID. |
| m:\<permission>     | Sets the effective rights mask. The mask is the combination of all  access permissions of the owning group and all of the user and group  entries. |
| o:\<permission>     | Sets the access ACLs for users other than the ones in the group for the file. |

If a file or directory already has a POSIX ACLs, and the setfacl command is used, the additional permissions are added to the existing POSIX ACLs or the existing rule is modified.

For example, to give read and write permissions to user antony:

```

setfacl -m u:antony:rw /mnt/gluster/data/testfile
```

##### Setting Default ACLs

You can apply default ACLs only to directories. They determine the permissions of a file system objects that inherits from its parent directory when it is created.

To set default ACLs

You can set default ACLs for files and directories using the following command:

```

setfacl –m –-set
```

Permissions must be a combination of the characters r (read), w  (write), and x (execute). Specify the ACL entry_type as described below, separating multiple entry types with commas.

u:*user_name:permissions* Sets the access ACLs for a user. Specify the user name, or the UID.

g:*group_name:permissions* Sets the access ACLs for a group. Specify the group name, or the GID.

m:*permission* Sets the effective rights mask. The mask is the combination of all  access permissions of the owning group, and all user and group entries.

o:*permissions* Sets the access ACLs for users other than the ones in the group for the file.

For example, to set the default ACLs for the /data directory to read for users not in the user group:

```

setfacl –m --set o::r /mnt/gluster/data
```

> **Note**
>
> An access ACLs set for an individual file can override the default ACLs permissions.

**Effects of a Default ACLs**

The following are the ways in which the permissions of a directory's default ACLs are passed to the files and subdirectories in it:

- A subdirectory inherits the default ACLs of the parent directory  both as its default ACLs and as an access ACLs.
- A file inherits the default ACLs as its access ACLs.

#### Retrieving POSIX ACLs

You can view the existing POSIX ACLs for a file or directory.

**To view existing POSIX ACLs**

- View the existing access ACLs of a file using the following command:

```

getfacl
```

For example, to view the existing POSIX ACLs for sample.jpg

```

getfacl /mnt/gluster/data/test/sample.jpg
owner: antony
group: antony
user::rw-
group::rw-
other::r--
```

- View the default ACLs of a directory using the following command:

```

getfacl
```

For example, to view the existing ACLs for /data/doc

```

getfacl /mnt/gluster/data/doc
owner: antony
group: antony
user::rw-
user:john:r--
group::r--
mask::r--
other::r--
default:user::rwx
default:user:antony:rwx
default:group::r-x
default:mask::rwx
default:other::r-x
```

#### Removing POSIX ACLs

To remove all the permissions for a user, groups, or others, use the following command:

```

setfacl -x
```

##### setfaclentry_type Options

The ACL entry_type translates to the POSIX ACL representations of owner, group, and other.

Permissions must be a combination of the characters r (read), w  (write), and x (execute). Specify the ACL entry_type as described below, separating multiple entry types with commas.

u:*user_name* Sets the access ACLs for a user. Specify the user name, or the UID.

g:*group_name* Sets the access ACLs for a group. Specify the group name, or the GID.

m:*permission* Sets the effective rights mask. The mask is the combination of all  access permissions of the owning group, and all user and group entries.

o:*permissions* Sets the access ACLs for users other than the ones in the group for the file.

For example, to remove all permissions from the user antony:

```

setfacl -x u:antony /mnt/gluster/data/test-file
```

#### Samba and ACLs

If you are using Samba to access GlusterFS FUSE mount, then POSIX ACLs are enabled by default. Samba has been compiled with the `--with-acl-support` option, so no special flags are required when accessing or mounting a Samba share.

#### NFS and ACLs

Currently GlusterFS supports POSIX ACL configuration through NFS mount, i.e. setfacl and getfacl commands work through NFS mount.

## Handling of users that belong to many groups

Users can belong to many different (UNIX) groups. These groups are generally used to allow or deny permissions for executing commands or access to files and directories.

The number of groups a user can belong to depends on the operating system, but there are also components that support fewer groups. In Gluster, there are different restrictions on different levels in the stack. The explanations in this document should clarify which restrictions exist, and how these can be handled.

### tl;dr

- if users belong to more than 90 groups, the brick processes need to resolve  the secondary/auxiliary groups with the `server.manage-gids` volume option
- the linux kernels `/proc` filesystem provides up to 32 groups of a running  process, if this is not sufficient the mount option `resolve-gids` can be  used
- Gluster/NFS needs `nfs.server-aux-gids` when users accessing a Gluster volume  over NFS belong to more than 16 groups

For all of the above options counts that the system doing the group resolving must be configured (`nsswitch`, `sssd`, ..) to be able to get all groups when only a UID is known.

### Limit in the GlusterFS protocol

When a Gluster client does some action on a Gluster volume, the operation is sent in an RPC packet. This RPC packet contains an header with the credentials of the user. The server-side receives the RPC packet and uses the credentials from the RPC header to perform ownership operations and allow/deny checks.

The RPC header used by the GlusterFS protocols can contain at most ~93 groups. In order to pass this limit, the server process (brick) receiving the RPC procedure can do the resolving of the groups locally, and ignore the (too few) groups from the RPC header.

This requires that the service process can resolve all of the users groups by the UID of the client process. Most environments that have many groups, already use a configuration where users and groups are maintained in a central location. for enterprises it is common to manage users and their groups in LDAP, Active Directory, NIS or similar.

To have the groups of a user resolved on the server-side (brick), the volume option `server.manage-gids` needs to be set. Once this option is enabled, the brick processes will not use the groups that the Gluster clients send, but will use the POSIX `getgrouplist()` function to fetch them.

Because this is a protocol limitation, all clients, including FUSE mounts, Gluster/NFS server and libgfapi applications are affected by this.

### Group limit with FUSE

The FUSE client gets the groups of the process that does the I/O by reading the information from `/proc/$pid/status`. This file only contains up to 32 groups. If client-side xlators rely on all groups of a process/user (like posix-acl), these 32 groups could limit functionality.

For that reason a mount option has been added. With the `resolve-gids` mount option, the FUSE client calls the POSIX `getgrouplist()` function instead of reading `/proc/$pid/status`.

### Group limit for NFS

The NFS protocol (actually the AUTH_SYS/AUTH_UNIX RPC header) allows up to 16 groups. These are the groups that the NFS-server receives from NFS-clients. Similar to the way the brick processes can resolve the groups on the server-side, the NFS-server can take the UID passed by the NFS-client and use that to resolve the groups. the volume option for that is `nfs.server-aux-gids`.

Other NFS-servers offer options like this too. The Linux kernel nfsd server uses `rpc.mountd --manage-gids`. NFS-Ganesha has the configuration option `Manage_Gids`.

### Implications of these solutions

All of the mentioned options are disabled by default. one of the reasons is that resolving groups is an expensive operation. in many cases there is no need for supporting many groups and there could be a performance hit.

When groups are resolved, the list is cached. the validity of the cache is configurable. the Gluster processes are not the only ones that cache these groups. `nscd` or `sssd` also keep a cache when they handle the `getgroupslist()` requests. When there are many requests, and querying the groups from a centralized management system takes long, caches might benefit from a longer validity.

An other, less obvious difference might be noticed too. Many processes that are written with security in mind reduce the groups that the process can effectively use. This is normally done with the `setegids()` function. When storage processes do not honour the fewer groups that are effective, and the processes use the UID to resolve all groups of a process, the groups that got dropped with `setegids()` are added back again. this could lead to permissions that the process should not have.

## 设置卷

卷是 brick 的逻辑集合，其中每个 brick 都是受信任存储池中服务器上的导出目录。要在存储环境中创建新卷，请指定组成卷的 brick 。创建新卷后，必须先启动它，然后再尝试装载它。

### 卷类型

#### Distributed

Distributed volumes    distribute files across the bricks in the volume. You can use distributed    volumes where the requirement is to scale storage and the redundancy is    either not important or is provided by other hardware/software layers.

 ![](../../Image/g/glusterfs-DistributedVol.png)

分布式—分布式卷将文件分布在卷中的各个砖上。如果需要扩展存储，并且冗余不重要或由其他硬件/软件层提供，则可以使用分布式卷。

In a distributed volume files are spread randomly across the bricks in the volume. Use distributed volumes where you need to scale storage and redundancy is either not important or is provided by other hardware/software layers.

在分布式卷中，文件在卷中的砖上随机分布。在需要扩展存储的地方使用分布式卷，冗余不重要或由其他硬件/软件层提供。

注意：分布式卷中的磁盘/服务器故障可能会导致严重的数据丢失，因为目录内容在卷中的砖块中随机分布。

> **Note**: Disk/server failure in distributed volumes can result in a serious loss of data because directory contents are spread randomly across the bricks in the volume.

#### Replicated

Replicated volumes replicate    files across bricks in the volume. You can use replicated volumes in    environments where high-availability and high-reliability are critical.

 ![](../../Image/g/glusterfs-ReplicatedVol.png)

Replicated–复制的卷跨卷中的砖复制文件。您可以在高可用性和高可靠性至关重要的环境中使用复制卷。

Replicated volumes create copies of files across multiple bricks in the volume. You can use replicated volumes in environments where high-availability and high-reliability are critical.

复制的卷在卷中的多个砖上创建文件副本。您可以在高可用性和高可靠性至关重要的环境中使用复制卷。

注意：砖的数量应等于复制卷的副本计数。为了防止服务器和磁盘故障，建议卷的砖块来自不同的服务器。

> **Note**: The number of bricks should be equal to of the replica count for a replicated volume. To protect against server and disk failures, it is recommended that the bricks of the volume are from different servers.

#### Distributed Replicated

Distributed replicated volumes distribute files across replicated bricks in the    volume. You can use distributed replicated volumes in environments where the    requirement is to scale storage and high-reliability is critical. Distributed    replicated volumes also offer improved read performance in most environments.

 ![](../../Image/g/glusterfs-Distributed-ReplicatedVol.png)

分布式复制—分布式复制卷跨卷中的复制砖分发文件。您可以在需要扩展存储且高可靠性至关重要的环境中使用分布式复制卷。分布式复制卷在大多数环境中还提供了改进的读取性能。

Distributes files across replicated bricks in the volume. You can use distributed replicated volumes in environments where the requirement is to scale storage and high-reliability is critical. Distributed replicated volumes also offer improved read performance in most environments.

在卷中的复制砖上分发文件。您可以在需要扩展存储且高可靠性至关重要的环境中使用分布式复制卷。分布式复制卷在大多数环境中还提供了改进的读取性能。

注意：砖的数量应该是分布式复制卷的副本计数的倍数。此外，砖块的指定顺序对数据保护有很大影响。每个副本计数列表中的连续砖块将形成一个副本集，所有副本集合并为一个卷范围的分发集。要确保副本集成员不放在同一节点上，请按相同的顺序列出每个服务器上的第一个砖，然后列出每个服务器的第二个砖，依此类推。

> **Note**: The number of bricks should be a multiple of the replica count for a distributed replicated volume. Also, the order in which bricks are specified has a great effect on data protection. Each replica_count consecutive bricks in the list you give will form a replica set, with all replica sets combined into a volume-wide distribute set. To make sure that replica-set members are not placed on the same node, list the first brick on every server, then the second brick on every server in the same order, and so on.

#### Dispersed

Dispersed volumes are based on    erasure codes, providing space-efficient protection against disk or server    failures. It stores an encoded fragment of the original file to each brick in a    way that only a subset of the fragments is needed to recover the original file.    The number of bricks that can be missing without losing access to data is    configured by the administrator on volume creation time.

 ![](../../Image/g/glusterfs-DispersedVol.png)

分散—分散的卷基于擦除代码，提供了针对磁盘或服务器故障的空间高效保护。它将原始文件的编码片段存储到每个砖中，这样只需要片段的一个子集即可恢复原始文件。在卷创建时，管理员会配置丢失而不会丢失数据访问权限的砖的数量。

Dispersed volumes are based on erasure codes. It stripes the encoded data of files, with some redundancy added, across multiple bricks in the volume. You can use dispersed volumes to have a configurable level of reliability with  minimum space waste.分散的卷基于擦除代码。它将文件的编码数据分条，并在卷中的多块砖上添加一些冗余。您可以使用分散的卷，以最小的空间浪费实现可配置的可靠性级别。

**冗余**

Each dispersed volume has a redundancy value defined when the volume is created. This value determines how many bricks can be lost without interrupting the operation of the volume. It also determines the amount of usable space of the volume using this formula:

每个分散卷都有一个在创建卷时定义的冗余值。该值确定在不中断体积操作的情况下可以丢失多少砖块。它还使用以下公式确定卷的可用空间量：

```bash
<Usable size> = <Brick size> * (#Bricks - Redundancy)
```

All bricks of a disperse set should have the same capacity, otherwise, when the smallest brick becomes full, no additional data will be allowed in the disperse set.

It's important to note that a configuration with 3 bricks and redundancy 1 will have less usable space (66.7% of the total physical space) than a configuration with 10 bricks and redundancy 1 (90%). However the first one will be safer than the second one (roughly the probability of failure of the second configuration if more than 4.5 times bigger than the first one).

For example, a dispersed volume composed of 6 bricks of 4TB and a redundancy of 2 will be completely operational even with two bricks inaccessible. However a third inaccessible brick will bring the volume down because it won't be possible to read or write to it. The usable space of the volume will be equal to 16TB.

The implementation of erasure codes in GlusterFS limits the redundancy to a value smaller than #Bricks / 2 (or equivalently, redundancy * 2 < #Bricks). Having a redundancy equal to half of the number of bricks would be almost equivalent to a replica-2 volume, and probably a replicated volume will perform better in this case.

分散集中的所有砖块都应具有相同的容量，否则，当最小砖块变满时，分散集中不允许有其他数据。

需要注意的是，具有3块和冗余1的配置的可用空间（占总物理空间的66.7%）将少于具有10块和冗余2的配置（90%）。然而，第一个配置将比第二个配置更安全（如果第二配置的故障概率大于第一个配置的4.5倍）。

例如，由6块4TB砖块和2块冗余砖块组成的分散体积将完全可操作，即使两块砖块无法访问。然而，第三块不可访问的砖将使卷下降，因为无法对其进行读写。卷的可用空间将等于16TB。

Gluster FS中擦除代码的实现将冗余限制为小于#Bricks/2的值（或等效地，冗余*2<#Bricks）。具有等于砖数量一半的冗余几乎等同于复制-2卷，在这种情况下，复制卷的性能可能会更好。

**最佳容量**

One of the worst things erasure codes have in terms of performance is the RMW (Read-Modify-Write) cycle. Erasure codes operate in blocks of a certain size and it cannot work with smaller ones. This means that if a user issues a write of a portion of a file that doesn't fill a full block, it needs to read the remaining portion from the current contents of the file, merge them, compute the updated encoded block and, finally, writing the resulting data.

This adds latency, reducing performance when this happens. Some GlusterFS performance xlators can help to reduce or even eliminate this problem for some workloads, but it should be taken into account when using dispersed volumes for a specific use case.

Current implementation of dispersed volumes use blocks of a size that depends on the number of bricks and redundancy: 512 * (#Bricks - redundancy) bytes. This value is also known as the stripe size.

Using combinations of #Bricks/redundancy that give a power of two for the stripe size will make the disperse volume perform better in most workloads because it's more typical to write information in blocks that are multiple of two (for example databases, virtual machines and many applications).

These combinations are considered *optimal*.

For example, a configuration with 6 bricks and redundancy 2 will have a stripe size of 512 * (6 - 2) = 2048 bytes, so it's considered optimal. A configuration with 7 bricks and redundancy 2 would have a stripe size of 2560 bytes, needing a RMW cycle for many writes (of course this always depends on the use case).

擦除代码在性能方面最糟糕的事情之一是RMW（读-修改-写）周期。擦除码在一定大小的块中工作，不能与较小的块一起工作。这意味着，如果用户对文件的一部分进行写入，而该部分未填满整个块，则需要从文件的当前内容中读取剩余部分，合并它们，计算更新的编码块，最后写入结果数据。

这会增加延迟，从而降低性能。对于某些工作负载，一些Gluster FS性能解析器可以帮助减少甚至消除此问题，但在使用特定用例的分散卷时，应该考虑到这一点。

分散卷的当前实现使用的块的大小取决于砖的数量和冗余：512*（#bricks-冗余）字节。该值也称为条带大小。

使用#Bricks/冗余的组合（为条带大小提供2次方）将使分散卷在大多数工作负载中的性能更好，因为更典型的情况是将信息写入两倍的块中（例如数据库、虚拟机和许多应用程序）。

这些组合被认为是最佳的。

例如，具有6块和冗余2的配置的条带大小为512*（6-2）=2048字节，因此被认为是最佳的。具有7块和冗余2的配置将具有2560字节的条带大小，需要RMW周期进行多次写入（当然，这始终取决于使用情况）。

#### Distributed Dispersed

Distributed dispersed volumes distribute files across dispersed subvolumes. This    has the same advantages of distribute replicate volumes, but using disperse to    store the data into the bricks. 

 ![](../../Image/n/New-Distributed-DisperseVol.png)

分布式分散—分布式分散卷跨分散的子卷分发文件。这与分发复制卷具有相同的优点，但使用分散将数据存储到砖块中。

Distributed dispersed volumes are the equivalent to distributed replicated volumes, but using dispersed subvolumes instead of replicated ones.分布式分散卷等同于分布式复制卷，但使用分散的子卷而不是复制的子卷。

### 创建新的卷

```bash
gluster volume create <NEW-VOLNAME> [[replica  <COUNT> [arbiter <COUNT>]]|[replica 2 thin-arbiter 1]]  [disperse [<COUNT>]] [disperse-data <COUNT>] [redundancy  <COUNT>] [transport <tcp|rdma|tcp,rdma>] <NEW-BRICK>  <TA-BRICK>... [force]
```

例如，要创建一个名为 test-volume 的卷，该卷由 server3:/exp3 和 server4:/exp4 组成：

```bash
gluster volume create test-volume server3:/exp3 server4:/exp4

Creation of test-volume has been successful
Please start the volume to access data.
```

### 创建 Distributed Volume

```bash
gluster volume create  [transport tcp | rdma | tcp,rdma]
```

For example, to create a distributed volume with four storage servers using tcp:例如，要使用tcp创建具有四个存储服务器的分布式卷：

```bash
gluster volume create test-volume server1:/exp1 server2:/exp2 server3:/exp3 server4:/exp4

Creation of test-volume has been successful
Please start the volume to access data.
```

显示卷信息：

```bash
gluster volume info

Volume Name: test-volume
Type: Distribute
Status: Created
Number of Bricks: 4
Transport-type: tcp
Bricks:
Brick1: server1:/exp1
Brick2: server2:/exp2
Brick3: server3:/exp3
Brick4: server4:/exp4
```

例如，要在 InfiniBand上创建具有四个存储服务器的分布式卷：

```bash
gluster volume create test-volume transport rdma server1:/exp1 server2:/exp2 server3:/exp3 server4:/exp4

Creation of test-volume has been successful
Please start the volume to access data.
```

If the transport type is not specified, *tcp* is used as the default. You can also set additional options if required, such as auth.allow or auth.reject.

如果未指定传输类型，则默认使用 tcp。如果需要，还可以设置其他选项，例如 auth。allow或auth.reject。

> **Note**: Make sure you start your volumes before you try to mount them or else client operations after the mount will hang.
>
> 确保在尝试装载卷之前启动卷，否则装载后的客户端操作将挂起。

### 创建 Replicated Volume

```bash
gluster volume create  [replica ] [transport tcp | rdma | tcp,rdma]
```

For example, to create a replicated volume with two storage servers:例如，要创建具有两个存储服务器的复制卷：

```bash
gluster volume create test-volume replica 2 transport tcp server1:/exp1 server2:/exp2

Creation of test-volume has been successful
Please start the volume to access data.
```

If the transport type is not specified, *tcp* is used as the default. You can also set additional options if required, such as auth.allow or auth.reject.

如果未指定传输类型，则默认使用tcp。如果需要，还可以设置其他选项，例如auth。allow或auth.reject。

> **Note**:
>
> - Make sure you start your volumes before you try to mount them or else client operations after the mount will hang.
>
> - GlusterFS will fail to create a replicate volume if more than one  brick of a replica set is present on the same peer. For eg. a four node  replicated volume where more than one brick of a replica set is present  on the same peer.
>
> - 确保在尝试装载卷之前启动卷，否则装载后的客户端操作将挂起。
>
> - 如果副本集的多个砖位于同一对等体上，Gluster FS将无法创建复制卷。例如，一个四节点复制卷，其中一个副本集的多个砖位于同一对等体上。
>
>   ```bash
>   gluster volume create <volname> replica 4 server1:/brick1 server1:/brick2 server2:/brick3 server4:/brick4
>   
>   volume create: <volname>: failed: Multiple bricks of a replicate volume are present on the same server. This setup is not optimal. Use 'force' at the end of the command if you want to override this behavior.
>   ```
>   
> - Use the `force` option at the end of command if you still want to create the volume with this configuration.
>
> - 如果仍要使用此配置创建卷，请在命令末尾使用force选项。

#### Arbiter configuration for replica volumes 副本卷的仲裁器配置

Arbiter volumes are replica 3 volumes where the 3rd brick acts as the arbiter brick. This configuration has mechanisms that prevent  occurrence of split-brains.

仲裁器卷是副本3卷，其中第三块充当仲裁器块。这种结构具有防止大脑分裂的机制。

可以使用以下命令创建：

```bash
gluster volume create <VOLNAME> replica 2 arbiter 1 host1:brick1 host2:brick2 host3:brick3
```

Note that the arbiter configuration for replica 3 can be used to create distributed-replicate volumes as well.请注意，副本3的仲裁器配置也可用于创建分布式复制卷。

### 创建 Distributed Replicated Volume

```bash
gluster volume create  [replica ] [transport tcp | rdma | tcp,rdma]
```

For example, a four node distributed (replicated) volume with a two-way mirror:例如，具有双向镜像的四节点分布式（复制）卷：

```bash
gluster volume create test-volume replica 2 transport tcp server1:/exp1 server2:/exp2 server3:/exp3 server4:/exp4

Creation of test-volume has been successful
Please start the volume to access data.
```

For example, to create a six node distributed (replicated) volume with a two-way mirror:例如，要创建具有双向镜像的六节点分布式（复制）卷：

```bash
gluster volume create test-volume replica 2 transport tcp server1:/exp1 server2:/exp2 server3:/exp3 server4:/exp4 server5:/exp5 server6:/exp6

Creation of test-volume has been successful
Please start the volume to access data.
```

If the transport type is not specified, *tcp* is used as the default. You can also set additional options if required, such as auth.allow or auth.reject.如果未指定传输类型，则默认使用tcp。如果需要，还可以设置其他选项，例如auth。allow或auth.reject。

> **Note**: - Make sure you start your volumes before you try to mount them or else client operations after the mount will hang.
>
> - GlusterFS will fail to create a distribute replicate volume if more  than one brick of a replica set is present on the same peer. For eg. for a four node distribute (replicated) volume where more than one brick of a replica set is present on the same peer.
>
> - 确保在尝试装载卷之前启动卷，否则装载后的客户端操作将挂起。
>
> - 如果副本集的多个砖位于同一对等体上，Gluster FS将无法创建分布式复制卷。例如，对于一个四节点分发（复制）卷，其中一个副本集的多个砖位于同一对等体上。
>
>   ```bash
>   gluster volume create <volname> replica 2 server1:/brick1 server1:/brick2 server2:/brick3 server4:/brick4
>   volume create: <volname>: failed: Multiple bricks of a replicate volume are present on the same server. This setup is not optimal. Use 'force' at the end of the command if you want to override this behavior.
>   ```
>   
> - Use the `force` option at the end of command if you want to create the volume in this case.如果要在这种情况下创建卷，请在命令末尾使用force选项。

### 创建 Dispersed Volume

```bash
gluster volume create [disperse [<count>]] [redundancy <count>] [transport tcp | rdma | tcp,rdma]
```

A dispersed volume can be created by specifying the number of bricks in a disperse set, by specifying the number of redundancy bricks, or both.

If *disperse* is not specified, or the *<count>* is missing, the entire volume will be treated as a single disperse set composed by all bricks enumerated in the command line.

If *redundancy* is not specified, it is computed automatically to be the optimal value. If this value does not exist, it's assumed to be '1' and a warning message is shown:

可以通过指定分散集中的砖块数量、指定冗余砖块数量或两者来创建分散体。

如果未指定分散，或缺少＜count＞，则整个卷将被视为由命令行中枚举的所有砖块组成的单个分散集。

如果未指定冗余，则会自动将其计算为最佳值。如果该值不存在，则假定为“1”，并显示警告消息：

```bash
gluster volume create test-volume disperse 4 server{1..4}:/bricks/test-volume

There isn't an optimal redundancy value for this configuration. Do you want to create the volume with redundancy 1 ? (y/n)
```

In all cases where *redundancy* is automatically computed and it's not equal to '1', a warning message is displayed:在所有自动计算冗余且不等于“1”的情况下，将显示警告消息：

```bash
gluster volume create test-volume disperse 6 server{1..6}:/bricks/test-volume

The optimal redundancy for this configuration is 2. Do you want to create the volume with this value ? (y/n)
```

*redundancy* must be greater than 0, and the total number of bricks must be greater than 2 * *redundancy*. This means that a dispersed volume must have a minimum of 3 bricks.

If the transport type is not specified, *tcp* is used as the default. You can also set additional options if required, like in the other volume types.

冗余度必须大于0，砖的总数必须大于2*冗余度。这意味着分散体积必须至少有3块砖。

如果未指定传输类型，则默认使用tcp。如果需要，还可以设置其他选项，如其他卷类型。

> **Note**:
>
> - Make sure you start your volumes before you try to mount them or else client operations after the mount will hang.
>
> - GlusterFS will fail with a warning to create a dispersed volume if  more than one brick of a disperse set is present on the same peer.
>
> - 确保在尝试装载卷之前启动卷，否则装载后的客户端操作将挂起。
>
>   如果同一对等体上存在分散集的多个砖，Gluster FS将失败，并显示创建分散卷的警告。
>
>   ```bash
>   gluster volume create <volname> disperse 3 server1:/brick{1..3}
>                 
>   volume create: <volname>: failed: Multiple bricks of a disperse volume are present on the same server. This setup is not optimal. Bricks should be on different nodes to have best fault tolerant configuration. Use 'force' at the end of the command if you want to override this behavior.
>   ```

### 创建 Distributed Dispersed Volume

```bash
gluster volume create disperse <count> [redundancy <count>] [transport tcp | rdma | tcp,rdma]
```

To create a distributed dispersed volume, the *disperse* keyword and <count> is mandatory, and the number of bricks specified in the command line must must be a multiple of the disperse count.

*redundancy* is exactly the same as in the dispersed volume.

If the transport type is not specified, *tcp* is used as the default. You can also set additional options if required, like in the other volume types.

要创建分布式分散卷，分散关键字和＜count＞是必需的，并且命令行中指定的砖块数量必须是分散计数的倍数。

冗余与分散卷中的冗余完全相同。

如果未指定传输类型，则默认使用tcp。如果需要，还可以设置其他选项，如其他卷类型。

> **Note**:
>
> - Make sure you start your volumes before you try to mount them or else client operations after the mount will hang.
>
> - For distributed disperse volumes bricks can be hosted on same node if they belong to different subvol.
>
> - 确保在尝试装载卷之前启动卷，否则装载后的客户端操作将挂起。
>
>   对于分布式分散体，如果砖属于不同的子卷，则砖可以托管在同一节点上。
>
>   ```bash
>   gluster volume create <volname> disperse 3 server1:/br1 server2:/br1 server3:/br1 server1:/br2 server2:/br2 server3:/br2
>   ```
>   
>   volume create: : success: please start the volume to access data

### 启动卷

在尝试装载卷之前，必须先启动卷。

```bash
gluster volume start <VOLNAME> [force]
```

示例：

```bash
gluster volume start test-volume
Starting test-volume has been successful
```

## 管理卷

### Configuring Transport Types for a Volume

A volume can support one or more transport types for communication between clients and brick processes. There are three types of supported transport, which are tcp, rdma, and tcp,rdma.

To change the supported transport types of a volume, follow the procedure:

1. Unmount the volume on all the clients using the following command:

   ```
   
   ```

```
umount mount-point
```

Stop the volumes using the following command:

```

gluster volume stop <VOLNAME>
```

Change the transport type. For example, to enable both tcp and rdma execute the followimg command:

```

gluster volume set test-volume config.transport tcp,rdma OR tcp OR rdma
```

Mount the volume on all the clients. For example, to mount using rdma transport, use the following command:

```

```

1. ```
   mount -t glusterfs -o transport=rdma server1:/test-volume /mnt/glusterfs
   ```

### Expanding Volumes

You can expand volumes, as needed, while the cluster is online and available. For example, you might want to add a brick to a distributed volume, thereby increasing the distribution and adding to the capacity of the GlusterFS volume.

Similarly, you might want to add a group of bricks to a distributed replicated volume, increasing the capacity of the GlusterFS volume.

> **Note**
>  When expanding distributed replicated and distributed dispersed volumes, you need to add a number of bricks that is a multiple of the replica or disperse count. For example, to expand a distributed replicated volume with a replica count of 2, you need to add bricks in multiples of 2 (such as 4, 6, 8, etc.).

**To expand a volume**

1. If they are not already part of the TSP, probe the servers which contain the bricks you    want to add to the volume using the following command:

   ```
   
   ```

```
gluster peer probe <SERVERNAME>
```

For example:

```

# gluster peer probe server4
Probe successful
```

Add the brick using the following command:

```

gluster volume add-brick <VOLNAME> <NEW-BRICK>
```

For example:

```

# gluster volume add-brick test-volume server4:/exp4
Add Brick successful
```

Check the volume information using the following command:

```

gluster volume info <VOLNAME>
```

The command displays information similar to the following:

```

```

1. ```
   Volume Name: test-volume
   Type: Distribute
   Status: Started
   Number of Bricks: 4
   Bricks:
   Brick1: server1:/exp1
   Brick2: server2:/exp2
   Brick3: server3:/exp3
   Brick4: server4:/exp4
   ```

2. Rebalance the volume to ensure that files are distributed to the    new brick.

   You can use the rebalance command as described in [Rebalancing Volumes](https://docs.gluster.org/en/latest/Administrator-Guide/Managing-Volumes/#rebalancing-volumes)

### Shrinking Volumes

You can shrink volumes, as needed, while the cluster is online and available. For example, you might need to remove a brick that has become inaccessible in a distributed volume due to hardware or network failure.

> **Note**
>  Data residing on the brick that you are removing will no longer be accessible at the Gluster mount point. Note however that only the configuration information is removed - you can continue to access the data directly from the brick, as necessary.

When shrinking distributed replicated and distributed dispersed volumes, you need to remove a number of bricks that is a multiple of the replica or stripe count. For example, to shrink a distributed replicate volume with a replica count of 2, you need to remove bricks in multiples of 2 (such as 4, 6, 8, etc.). In addition, the bricks you are trying to remove must be from the same sub-volume (the same replica or disperse set).

Running remove-brick with the *start* option will automatically trigger a rebalance operation to migrate data from the removed-bricks to the rest of the volume.

**To shrink a volume**

1. Remove the brick using the following command:

   ```
   
   ```

```
gluster volume remove-brick <VOLNAME> <BRICKNAME> start
```

For example, to remove server2:/exp2:

```

# gluster volume remove-brick test-volume server2:/exp2 start
volume remove-brick start: success
```

View the status of the remove brick operation using the    following command:

```

gluster volume remove-brick <VOLNAME> <BRICKNAME> status
```

For example, to view the status of remove brick operation on server2:/exp2 brick:

```

# gluster volume remove-brick test-volume server2:/exp2 status
                                Node  Rebalanced-files  size  scanned       status
                           ---------  ----------------  ----  -------  -----------
617c923e-6450-4065-8e33-865e28d9428f               34   340      162   in progress
```

Once the status displays "completed", commit the remove-brick operation

```

gluster volume remove-brick <VOLNAME> <BRICKNAME> commit
```

In this example:

```

# gluster volume remove-brick test-volume server2:/exp2 commit
Removing brick(s) can result in data loss. Do you want to Continue? (y/n) y
volume remove-brick commit: success
Check the removed bricks to ensure all files are migrated.
If files with data are found on the brick path, copy them via a gluster mount point before re-purposing the removed brick.
```

Check the volume information using the following command:

```

gluster volume info
```

The command displays information similar to the following:

```

```

1. ```
   # gluster volume info
   Volume Name: test-volume
   Type: Distribute
   Status: Started
   Number of Bricks: 3
   Bricks:
   Brick1: server1:/exp1
   Brick3: server3:/exp3
   Brick4: server4:/exp4
   ```

### Replace faulty brick

**Replacing a brick in a \*pure\* distribute volume**

To replace a brick on a distribute only volume, add the new brick and then remove the brick you want to replace. This will trigger a  rebalance operation which will move data from the removed brick.

> NOTE: Replacing a brick using the 'replace-brick' command in gluster is supported only for distributed-replicate or *pure* replicate volumes.

Steps to remove brick Server1:/home/gfs/r2_1 and add Server1:/home/gfs/r2_2:

1. Here is the initial volume configuration:

   ```
   
   ```

```
Volume Name: r2
Type: Distribute
Volume ID: 25b4e313-7b36-445d-b524-c3daebb91188
Status: Started
Number of Bricks: 2
Transport-type: tcp
Bricks:
Brick1: Server1:/home/gfs/r2_0
Brick2: Server1:/home/gfs/r2_1
```

Here are the files that are present on the mount:

```

# ls
1  10  2  3  4  5  6  7  8  9
```

Add the new brick - Server1:/home/gfs/r2_2 now:

```

# gluster volume add-brick r2 Server1:/home/gfs/r2_2
volume add-brick: success
```

Start remove-brick using the following command:

```

# gluster volume remove-brick r2 Server1:/home/gfs/r2_1 start
volume remove-brick start: success
ID: fba0a488-21a4-42b7-8a41-b27ebaa8e5f4
```

Wait until remove-brick status indicates that it is complete.

```

# gluster volume remove-brick r2 Server1:/home/gfs/r2_1 status
                                Node Rebalanced-files          size       scanned      failures       skipped               status   run time in secs
                           ---------      -----------   -----------   -----------   -----------   -----------         ------------     --------------
                           localhost                5       20Bytes            15             0             0            completed               0.00
```

Now we can safely remove the old brick, so commit the changes:

```

# gluster volume remove-brick r2 Server1:/home/gfs/r2_1 commit
Removing brick(s) can result in data loss. Do you want to Continue? (y/n) y
volume remove-brick commit: success
```

Here is the new volume configuration.

```

Volume Name: r2
Type: Distribute
Volume ID: 25b4e313-7b36-445d-b524-c3daebb91188
Status: Started
Number of Bricks: 2
Transport-type: tcp
Bricks:
Brick1: Server1:/home/gfs/r2_0
Brick2: Server1:/home/gfs/r2_2
```

Check the contents of the mount:

```

```

1. ```
   # ls
   1  10  2  3  4  5  6  7  8  9
   ```

**Replacing bricks in Replicate/Distributed Replicate volumes**

This section of the document describes how brick: `Server1:/home/gfs/r2_0` is replaced with brick: `Server1:/home/gfs/r2_5` in volume `r2` with replica count `2`.

```

    Volume Name: r2
    Type: Distributed-Replicate
    Volume ID: 24a0437a-daa0-4044-8acf-7aa82efd76fd
    Status: Started
    Number of Bricks: 2 x 2 = 4
    Transport-type: tcp
    Bricks:
    Brick1: Server1:/home/gfs/r2_0
    Brick2: Server2:/home/gfs/r2_1
    Brick3: Server1:/home/gfs/r2_2
    Brick4: Server2:/home/gfs/r2_3
```

Steps:

1. Make sure there is no data in the new brick Server1:/home/gfs/r2_5

2. Check that all the bricks are running. It is okay if the brick that is going to be replaced is down.

3. Bring the brick that is going to be replaced down if not already.

   - Get the pid of the brick by executing 'gluster volume  status'

     \# gluster volume status   Status of volume: r2   Gluster process                        Port    Online    Pid

     ------

     Brick Server1:/home/gfs/r2_0            49152    Y    5342   Brick Server2:/home/gfs/r2_1            49153    Y    5354   Brick Server1:/home/gfs/r2_2            49154    Y    5365   Brick Server2:/home/gfs/r2_3            49155    Y    5376

   - Login to the machine where the brick is running and kill the brick.

     \# kill -15 5342

   - Confirm that the brick is not running anymore and the other bricks are running fine.

     \# gluster volume status   Status of volume: r2   Gluster process                        Port    Online    Pid

     ------

     Brick Server1:/home/gfs/r2_0            N/A      N    5342 <<---- brick is not running, others are running fine.   Brick Server2:/home/gfs/r2_1            49153    Y    5354   Brick Server1:/home/gfs/r2_2            49154    Y    5365   Brick Server2:/home/gfs/r2_3            49155    Y    5376

4. Using the gluster volume fuse mount (In this example: `/mnt/r2`) set up metadata so that data will be synced to new brick (In this case it is from `Server1:/home/gfs/r2_1` to `Server1:/home/gfs/r2_5`)

   - Create a directory on the mount point that doesn't already exist.  Then delete that directory, do the same for metadata changelog by doing  setfattr. This operation marks the pending changelog which will tell  self-heal damon/mounts to perform self-heal from `/home/gfs/r2_1` to `/home/gfs/r2_5`.

     mkdir /mnt/r2/   rmdir /mnt/r2/   setfattr -n trusted.non-existent-key -v abc /mnt/r2   setfattr -x trusted.non-existent-key  /mnt/r2

   - Check that there are pending xattrs on the replica of the brick that is being replaced:

     getfattr -d -m. -e hex /home/gfs/r2_1   # file: home/gfs/r2_1   security.selinux=0x756e636f6e66696e65645f753a6f626a6563745f723a66696c655f743a733000   trusted.afr.r2-client-0=0x000000000000000300000002 <<---- xattrs are marked from source brick Server2:/home/gfs/r2_1   trusted.afr.r2-client-1=0x000000000000000000000000   trusted.gfid=0x00000000000000000000000000000001   trusted.glusterfs.dht=0x0000000100000000000000007ffffffe   trusted.glusterfs.volume-id=0xde822e25ebd049ea83bfaa3c4be2b440

5. Volume heal info will show that '/' needs healing.(There could be more entries based on the work load. But '/' must exist)

   ```
   
   ```

```
    # gluster volume heal r2 info
    Brick Server1:/home/gfs/r2_0
    Status: Transport endpoint is not connected

    Brick Server2:/home/gfs/r2_1
    /
    Number of entries: 1

    Brick Server1:/home/gfs/r2_2
    Number of entries: 0

    Brick Server2:/home/gfs/r2_3
    Number of entries: 0
```

Replace the brick with 'commit force' option. Please note that other variants of replace-brick command are not supported.

- Execute replace-brick command

  \# gluster volume replace-brick r2 Server1:/home/gfs/r2_0 Server1:/home/gfs/r2_5 commit force   volume replace-brick: success: replace-brick commit successful

- Check that the new brick is now online

  \# gluster volume status   Status of volume: r2   Gluster process                        Port    Online    Pid

  ------

  Brick Server1:/home/gfs/r2_5            49156    Y    5731 <<<---- new brick is online   Brick Server2:/home/gfs/r2_1            49153    Y    5354   Brick Server1:/home/gfs/r2_2            49154    Y    5365   Brick Server2:/home/gfs/r2_3            49155    Y    5376

- Users can track the progress of self-heal using: `gluster volume heal [volname] info`.  Once self-heal completes the changelogs will be removed.

  ```
  
  ```

1. - ```
     # getfattr -d -m. -e hex /home/gfs/r2_1
     getfattr: Removing leading '/' from absolute path names
     # file: home/gfs/r2_1
     security.selinux=0x756e636f6e66696e65645f753a6f626a6563745f723a66696c655f743a733000
     trusted.afr.r2-client-0=0x000000000000000000000000 <<---- Pending changelogs are cleared.
     trusted.afr.r2-client-1=0x000000000000000000000000
     trusted.gfid=0x00000000000000000000000000000001
     trusted.glusterfs.dht=0x0000000100000000000000007ffffffe
     trusted.glusterfs.volume-id=0xde822e25ebd049ea83bfaa3c4be2b440
     ```

   - `# gluster volume heal <VOLNAME> info` will show that no heal is required.

     \# gluster volume heal r2 info   Brick Server1:/home/gfs/r2_5   Number of entries: 0

     Brick Server2:/home/gfs/r2_1   Number of entries: 0

     Brick Server1:/home/gfs/r2_2   Number of entries: 0

     Brick Server2:/home/gfs/r2_3   Number of entries: 0

### Rebalancing Volumes

After expanding a volume using the add-brick command, you may need to rebalance the data among the servers. New directories created after expanding or shrinking of the volume will be evenly distributed automatically. For all the existing directories, the distribution can be fixed by rebalancing the layout and/or data.

This section describes how to rebalance GlusterFS volumes in your storage environment, using the following common scenarios:

- **Fix Layout** - Fixes the layout to use the new volume topology so that files can  be distributed to newly added nodes.
- **Fix Layout and Migrate Data** - Rebalances volume by fixing the layout  to use the new volume topology and migrating the existing data.

#### Rebalancing Volume to Fix Layout Changes

Fixing the layout is necessary because the layout structure is static for a given directory. Even after new bricks are added to the volume, newly created files in existing directories will still be distributed only among the original bricks. The command `gluster volume rebalance <volname> fix-layout start` will fix the layout information so that the files can be created on the newly added bricks. When this command is issued, all the file stat information which is already cached will get revalidated.

As of GlusterFS 3.6, the assignment of files to bricks will take into account the sizes of the bricks. For example, a 20TB brick will be assigned twice as many files as a 10TB brick. In versions before 3.6, the two bricks were treated as equal regardless of size, and would have been assigned an equal share of files.

A fix-layout rebalance will only fix the layout changes and does not migrate data. If you want to migrate the existing data, use `gluster volume rebalance <volume> start` command to rebalance data among the servers.

**To rebalance a volume to fix layout**

- Start the rebalance operation on any Gluster server using the  following command:

```
# gluster volume rebalance <VOLNAME> fix-layout start
```

For example:

```

  # gluster volume rebalance test-volume fix-layout start
  Starting rebalance on volume test-volume has been successful
```

#### Rebalancing Volume to Fix Layout and Migrate Data

After expanding a volume using the add-brick respectively, you need to rebalance the data among the servers. A remove-brick command will automatically trigger a rebalance.

**To rebalance a volume to fix layout and migrate the existing data**

- Start the rebalance operation on any one of the server using the  following command:

```
# gluster volume rebalance <VOLNAME> start
```

For example:

```

  # gluster volume rebalance test-volume start
  Starting rebalancing on volume test-volume has been successful
```

- Start the migration operation forcefully on any one of the servers  using the following command:

```
# gluster volume rebalance <VOLNAME> start force
```

For example:

```

  # gluster volume rebalance test-volume start force
  Starting rebalancing on volume test-volume has been successful
```

A rebalance operation will attempt to balance the diskusage across nodes, therefore it will skip files where the move will result in a less balanced volume. This leads to link files that are still left behind in the system and hence may cause performance issues. The behaviour can be overridden with the `force` argument.

#### Displaying the Status of Rebalance Operation

You can display the status information about rebalance volume operation, as needed.

- Check the status of the rebalance operation, using the following  command:

```
# gluster volume rebalance <VOLNAME> status
```

For example:

```

  # gluster volume rebalance test-volume status
                                  Node  Rebalanced-files  size  scanned       status
                             ---------  ----------------  ----  -------  -----------
  617c923e-6450-4065-8e33-865e28d9428f               416  1463      312  in progress
```

The time to complete the rebalance operation depends on the number  of files on the volume along with the corresponding file sizes.  Continue checking the rebalance status, verifying that the number of  files rebalanced or total files scanned keeps increasing.

For example, running the status command again might display a result  similar to the following:

```

  # gluster volume rebalance test-volume status
                                  Node  Rebalanced-files  size  scanned       status
                             ---------  ----------------  ----  -------  -----------
  617c923e-6450-4065-8e33-865e28d9428f               498  1783      378  in progress
```

The rebalance status displays the following when the rebalance is  complete:

```

  # gluster volume rebalance test-volume status
                                  Node  Rebalanced-files  size  scanned       status
                             ---------  ----------------  ----  -------  -----------
  617c923e-6450-4065-8e33-865e28d9428f               502  1873      334   completed
```

#### Stopping an Ongoing Rebalance Operation

You can stop the rebalance operation, if needed.

- Stop the rebalance operation using the following command:

```
# gluster volume rebalance <VOLNAME> stop
```

For example:

```

  # gluster volume rebalance test-volume stop
                                  Node  Rebalanced-files  size  scanned       status
                             ---------  ----------------  ----  -------  -----------
  617c923e-6450-4065-8e33-865e28d9428f               59   590      244       stopped
  Stopped rebalance process on volume test-volume
```

### Stopping Volumes

1. Stop the volume using the following command:

   `# gluster volume stop <VOLNAME>`

   For example, to stop test-volume:

   ```
   
   ```

```
# gluster volume stop test-volume
Stopping volume will make its data inaccessible. Do you want to continue? (y/n)
```

Enter `y` to confirm the operation. The output of the command    displays the following:

```

```

1. ```
   Stopping volume test-volume has been successful
   ```

### Deleting Volumes

1. Delete the volume using the following command:

   `# gluster volume delete <VOLNAME>`

   For example, to delete test-volume:

   ```
   
   ```

```
# gluster volume delete test-volume
Deleting volume will erase all information about the volume. Do you want to continue? (y/n)
```

Enter `y` to confirm the operation. The command displays the    following:

```

```

1. ```
   Deleting volume test-volume has been successful
   ```

### Triggering Self-Heal on Replicate

In replicate module, previously you had to manually trigger a self-heal when a brick goes offline and comes back online, to bring all the replicas in sync. Now the pro-active self-heal daemon runs in the background, diagnoses issues and automatically initiates self-healing every 10 minutes on the files which requires*healing*.

You can view the list of files that need *healing*, the list of files which are currently/previously *healed*, list of files which are in split-brain state, and you can manually trigger self-heal on the entire volume or only on the files which need *healing*.

- Trigger self-heal only on the files which requires *healing*:

```
# gluster volume heal <VOLNAME>
```

For example, to trigger self-heal on files which requires *healing*  of test-volume:

```

  # gluster volume heal test-volume
  Heal operation on volume test-volume has been successful
```

- Trigger self-heal on all the files of a volume:

```
# gluster volume heal <VOLNAME> full
```

For example, to trigger self-heal on all the files of of  test-volume:

```

  # gluster volume heal test-volume full
  Heal operation on volume test-volume has been successful
```

- View the list of files that needs *healing*:

```
# gluster volume heal <VOLNAME> info
```

For example, to view the list of files on test-volume that needs  *healing*:

```

  # gluster volume heal test-volume info
  Brick server1:/gfs/test-volume_0
  Number of entries: 0

  Brick server2:/gfs/test-volume_1
  Number of entries: 101
  /95.txt
  /32.txt
  /66.txt
  /35.txt
  /18.txt
  /26.txt
  /47.txt
  /55.txt
  /85.txt
  ...
```

- View the list of files that are self-healed:

```
# gluster volume heal <VOLNAME> info healed
```

For example, to view the list of files on test-volume that are  self-healed:

```

  # gluster volume heal test-volume info healed
  Brick Server1:/gfs/test-volume_0
  Number of entries: 0

  Brick Server2:/gfs/test-volume_1
  Number of entries: 69
  /99.txt
  /93.txt
  /76.txt
  /11.txt
  /27.txt
  /64.txt
  /80.txt
  /19.txt
  /41.txt
  /29.txt
  /37.txt
  /46.txt
  ...
```

- View the list of files of a particular volume on which the self-heal  failed:

```
# gluster volume heal <VOLNAME> info failed
```

For example, to view the list of files of test-volume that are not  self-healed:

```

  # gluster volume heal test-volume info failed
  Brick Server1:/gfs/test-volume_0
  Number of entries: 0

  Brick Server2:/gfs/test-volume_3
  Number of entries: 72
  /90.txt
  /95.txt
  /77.txt
  /71.txt
  /87.txt
  /24.txt
  ...
```

- View the list of files of a particular volume which are in  split-brain state:

```
# gluster volume heal <VOLNAME> info split-brain
```

For example, to view the list of files of test-volume which are in  split-brain state:

```

  # gluster volume heal test-volume info split-brain
  Brick Server1:/gfs/test-volume_2
  Number of entries: 12
  /83.txt
  /28.txt
  /69.txt
  ...

  Brick Server2:/gfs/test-volume_3
  Number of entries: 12
  /83.txt
  /28.txt
  /69.txt
  ...
```

### Non Uniform File Allocation

NUFA translator or Non Uniform File Access translator is designed for giving higher preference to a local drive when used in a HPC type of environment. It can be applied to Distribute and Replica translators; in the latter case it ensures that *one* copy is local if space permits.

When a client on a server creates files, the files are allocated to a brick in the volume based on the file name. This allocation may not be ideal, as there is higher latency and unnecessary network traffic for read/write operations to a non-local brick or export directory. NUFA ensures that the files are created in the local export directory of the server, and as a result, reduces latency and conserves bandwidth for that server accessing that file. This can also be useful for applications running on mount points on the storage server.

If the local brick runs out of space or reaches the minimum disk free limit, instead of allocating files to the local brick, NUFA distributes files to other bricks in the same volume if there is space available on those bricks.

NUFA should be enabled before creating any data in the volume.

Use the following command to enable NUFA:

```
# gluster volume set <VOLNAME> cluster.nufa enable
```

**Important**

NUFA is supported under the following conditions:

- Volumes with only one brick per server.
- For use with a FUSE client. **NUFA is not supported with NFS or SMB**.
- A client that is mounting a NUFA-enabled volume must be present within the trusted storage pool.

The NUFA scheduler also exists, for use with the Unify translator; see below.

```

volume bricks
  type cluster/nufa
  option local-volume-name brick1
  subvolumes brick1 brick2 brick3 brick4 brick5 brick6 brick7
end-volume
```

#### NUFA additional options

- lookup-unhashed

This is an advanced option where files are looked up in all  subvolumes if they are missing on the subvolume matching the hash value  of the filename. The default is on.

- local-volume-name

The volume name to consider local and prefer file creations on. The  default is to search for a volume matching the hostname of the system.

- subvolumes

This option lists the subvolumes that are part of this 'cluster/nufa' volume. This translator requires more than one subvolume.

### BitRot Detection

With BitRot detection in Gluster, it's possible to identify "insidious" type of disk errors where data is silently corrupted with no indication from the disk to the storage software layer than an error has occured. This also helps in catching "backend" tinkering of bricks (where data is directly manipulated on the bricks without going through FUSE, NFS or any other access protocol(s).

BitRot detection is disbled by default and needs to be enabled to make use of other sub-commands.

1. To enable bitrot detection for a given volume :

```
# gluster volume bitrot <VOLNAME> enable
```

and similarly to disable bitrot use:

```
# gluster volume bitrot <VOLNAME> disable
```

> NOTE: Enabling bitrot spawns the Signer & Scrubber daemon per node. Signer is responsible

```

  for signing (calculating checksum for each file) an object and scrubber verifies the
  calculated checksum against the objects data.
```

1. Scrubber daemon has three (3) throttling modes that adjusts the rate at which objects    are verified.

   ```
   
   ```

```
 # volume bitrot <VOLNAME> scrub-throttle lazy
 # volume bitrot <VOLNAME> scrub-throttle normal
 # volume bitrot <VOLNAME> scrub-throttle aggressive
```

By default scrubber scrubs the filesystem biweekly. It's possible to tune it to scrub    based on predefined frequency such as monthly, etc. This can be done as shown below:

```

```

1. ```
    # volume bitrot <VOLNAME> scrub-frequency daily
    # volume bitrot <VOLNAME> scrub-frequency weekly
    # volume bitrot <VOLNAME> scrub-frequency biweekly
    # volume bitrot <VOLNAME> scrub-frequency monthly
   ```

> NOTE: Daily scrubbing would not be available with GA release.

1. Scrubber daemon can be paused and later resumed when required. This can be done as   shown below:

```
# volume bitrot <VOLNAME> scrub pause
```

and to resume scrubbing:

```
# volume bitrot <VOLNAME> scrub resume
```

> NOTE: Signing cannot be paused (and resumed) and would always be active as long as

```

  bitrot is enabled for that particular volume.
```



# Building QEMU With gfapi For Debian Based Systems

This how-to has been tested on Ubuntu 13.10 in a clean, up to date environment. Older Ubuntu distros required some hacks if I remembered rightly. Other Debian based distros should be able to follow this adjusting for dependencies. Please update this if you get it working on another distro.

### Satisfying dependencies

Make the first stab at getting qemu dependencies

```

apt-get  build-dep qemu
```

This next command grabs all the dependencies specified in the debian control file as asked for from upstream Debian sid You can look into the options specified there and adjust to taste.

```

# get almost all the rest and the tools to work up the Debian magic
apt-get install devscripts quilt libiscsi-dev libusbredirparser-dev libssh2-1-dev libvdeplug-dev libjpeg-dev glusterfs*
```

we need a newer version of libseccomp for Ubuntu 13.10

```

mkdir libseccomp
cd libseccomp

# grab it from upstream sid
wget http://ftp.de.debian.org/debian/pool/main/libs/libseccomp/libseccomp_2.1.0+dfsg.orig.tar.gz
wget http://ftp.de.debian.org/debian/pool/main/libs/libseccomp/libseccomp_2.1.0+dfsg-1.debian.tar.gz

# get it ready
tar xf libseccomp_2.1.0+dfsg.orig.tar.gz
cd libseccomp-2.1.0+dfsg/

# install the debian magic
tar xf ../libseccomp_2.1.0+dfsg-1.debian.tar.gz

# apply series files if any
while quilt push; do quilt refresh; done

# build debs, they will appear one directory up
debuild -i -us -uc -b
cd ..

# install it
dpkg -i *.deb
```

### Building QEMU

This next part is straightforward if your dependencies are met. For the advanced reader look around debian/control once it is extracted before you install as you may want to change what options QEMU is built with and what targets are requested.

```

cd ..
mkdir qemu
cd qemu

# download our sources. you'll want to check back frequently on these for changes
wget http://ftp.de.debian.org/debian/pool/main/q/qemu/qemu_1.7.0+dfsg.orig.tar.xz
wget http://ftp.de.debian.org/debian/pool/main/q/qemu/qemu_1.7.0+dfsg-2.debian.tar.gz
wget http://download.gluster.org/pub/gluster/glusterfs/3.4/LATEST/glusterfs-3.4.2.tar.gz
tar xf glusterfs-3.4.2.tar.gz
tar xf qemu_1.7.0+dfsg.orig.tar.xz
cd qemu-1.7.0+dfsg/

# unpack the debian magic
tar xf ../qemu_1.7.0+dfsg-2.debian.tar.gz

# bring glusterfs in to the buiild
cp -r ../glusterfs-3.4.2 glusterfs

# the glusterfs check in configure looks around weird. I've never asked why but moving the src stuff up one works and tests fine
cd glusterfs/api/
mv src/* .
cd ../..

#you'll need to edit debian/control to enable glusterfs replacing

  - ##--enable-glusterfs todo
  + # --enable-glusterfs
  + glusterfs-common (>= 3.4.0),

#And finally build. It'll take ages.  http://xkcd.com/303/
# apply series if any
while quilt push; do quilt refresh; done

# build packages
debuild -i -us -uc -b
cd ..
```

Your debs now available to install. It is up to the reader to determine what targets they want installed.

# Modifying .vol files with a filter

If you need to make manual changes to a .vol file it is recommended to make these through the client interface ('gluster foo'). Making changes directly to .vol files is discouraged, because it cannot be predicted when a .vol file will be reset on disk, for example with a 'gluster set foo' command. The command line interface was never designed to read the .vol files, but rather to keep state and rebuild them (from `/var/lib/glusterd/vols/$vol/info`). There is, however, another way to do this.

You can create a shell script in the directory `/usr/lib*/glusterfs/$VERSION/filter`. All scripts located there will be executed every time the .vol files are written back to disk. The first and only argument passed to all script located there is the name of the .vol file.

So you could create a script there that looks like this:

```

#!/bin/sh
sed -i 'some-sed-magic' "$1"
```

Which will run the script, which in turn will run the sed command on the .vol file (passed as \$1).

Importantly, the script needs to be set as executable (eg via chmod), else it won't be run.

# GlusterFS service Logs and locations

Below lists the component, services, and functionality based logs in  the GlusterFS Server. As per the File System Hierarchy Standards (FHS)  all the log files are placed in the `/var/log` directory. ⁠

## Glusterd:

glusterd logs are located at `/var/log/glusterfs/glusterd.log`. One glusterd log file per server. This log file also contains the snapshot and user logs.

## Gluster cli command:

gluster cli logs are located at `/var/log/glusterfs/cli.log`. Gluster commands executed on a node in a GlusterFS Trusted Storage Pool is logged in `/var/log/glusterfs/cmd_history.log`.

## Bricks:

Bricks logs are located at `/var/log/glusterfs/bricks/<path extraction of brick path>.log`. One log file per brick on the server

## Rebalance:

rebalance logs are located at `/var/log/glusterfs/VOLNAME-rebalance.log` . One log file per volume on the server.

## Self heal deamon:

self heal deamon are logged at `/var/log/glusterfs/glustershd.log`. One log file per server

## Quota:

`/var/log/glusterfs/quotad.log` are log of the quota daemons running on each node. `/var/log/glusterfs/quota-crawl.log` Whenever quota is enabled, a file system crawl is performed and the corresponding log is stored in this file. `/var/log/glusterfs/quota-mount- VOLNAME.log` An auxiliary FUSE client is mounted in /VOLNAME of the glusterFS and the corresponding client logs found in this file.  One log file per server and per volume from quota-mount.

## Gluster NFS:

`/var/log/glusterfs/nfs.log` One log file per server

## SAMBA Gluster:

`/var/log/samba/glusterfs-VOLNAME-<ClientIP>.log` .  If the client mounts this on a glusterFS server node, the actual log  file or the mount point may not be found. In such a case, the mount  outputs of all the glusterFS type mount operations need to be  considered.

## Ganesha NFS :

```
/var/log/nfs-ganesha.log
```

## FUSE Mount:

```
/var/log/glusterfs/<mountpoint path extraction>.log
```

## Geo-replication:

```
/var/log/glusterfs/geo-replication/<primary>` `/var/log/glusterfs/geo-replication-secondary
```

## Gluster volume heal VOLNAME info command:

`/var/log/glusterfs/glfsheal-VOLNAME.log` . One log file per server on which the command is executed.

## Gluster-swift:

```
/var/log/messages
```

## SwiftKrbAuth:

```
/var/log/httpd/error_log
```

# Replication

This doc contains information about the synchronous replication module in gluster and has two sections

- Replication logic
- Self-heal logic.

# 1. Replication logic

AFR is the module (translator) in glusterfs that provides all the  features that you would expect of any synchronous replication system:

1. Simultaneous updating of all copies of data on the replica bricks when a client modifies it.
2. Providing continued data availability to clients when say one brick of the replica set goes down.
3. Automatic self-healing of any data that was modified when the brick  that was down, once it comes back up, ensuring consistency of data on  all the bricks of the replica.

1 and 2 are in the I/O path while 3 is done either in the I/O path (in the background) or via the self-heal daemon.

Each gluster translator implements what are known as *File Operations (FOPs)* which are mapped to the I/O syscalls which the application makes. For example, AFR has *afr_writev* that gets invoked when application does a *write(2)*. As is obvious, all FOPs fall into one of 2 types:

i) Read based FOPs which only get informtion from and don’t modify the file in any way.

viz: afr_readdir, afr_access, afr_stat, afr_fstat, afr_readlink, afr_getxattr, afr_fgetxattr, afr_readv,afr_seek

ii) Write based FOPs which change the file or its attributes.

viz: afr_create, afr_mknod,afr_mkdir,afr_link, afr_symlink,  afr_rename, afr_unlink, afr_rmdir, afr_do_writev, afr_truncate,  afr_ftruncate, afr_setattr, afr_fsetattr, afr_setxattr, afr_fsetxattr,  afr_removexattr, afr_fremovexattr, afr_fallocate, afr_discard,  afr_zerofill, afr_xattrop, afr_fxattrop, afr_fsync.

AFR follows a transaction model for both types of FOPs.

### Read transactions:

For every file in the replica, AFR has an in-memory notion/array  called ‘readables’ which indicate whether each brick of the replica is a good copy or a bad one (i.e. in need of a heal). In a healthy state,  all bricks are readable and a read FOP will be served from any one of  the readable bricks. The read-hash-mode volume option decides which  brick is the chosen one.

```

gluster volume set help | grep read-hash-mode -A7

Option: cluster.read-hash-mode
Default Value: 1
Description: inode-read fops happen only on one of the bricks in replicate. AFR will prefer the one computed using the method specified using this option.
0 = first readable child of AFR, starting from 1st child.
1 = hash by GFID of file (all clients use same subvolume).
2 = hash by GFID of file and client PID.
3 = brick having the least outstanding read requests.
```

If the brick is bad for a given file (i.e. it is pending heal), then  it won’t be marked readable to begin with. The readables array is  populated based on the on-disk AFR xattrs for the file during lookup.  These xattrs indicate which bricks are good and which ones are bad. We  will see more about these xattrs in the write transactions section  below. If the FOP fails on the chosen readable brick, AFR attempts it on the next readable one, until all are exhausted. If the FOP doesn’t  succeed on any of the readables, then the application receives an error.

### Write transactions:

Every write based FOP employs a write transaction model which consists of 5 phases:

**1) The lock phase** Take locks on the file being modified on all bricks so that AFRs of  other clients are blocked if they try to modify the same file  simultaneously.

**2) The pre-op phase** Increment the ‘dirty’ xattr (trusted.afr.dirty) by 1 on all  participating bricks as an indication of an impending FOP (in the next  phase)

**3) The FOP phase** Perform the actual FOP (say a setfattr) on all bricks.

**4) The post-op phase** Decrement the dirty xattr by 1 on bricks where the FOP was successful. In addition, also increment the ‘pending’ xattr  (trusted.afr.$VOLNAME-client-x) xattr on the success bricks to ‘blame’  the bricks where the FOP failed.

**5) The unlock phase** Release the locks that were taken in phase 1. Any competing client can now go ahead with its own write transaction.

**Note**: There are certain optimizations done at the  code level which reduce the no. of lock/unlock phases done for a  transaction by piggybacking on the previous transaction’s locks. These  optimizations (eager-locking, piggybacking and delayed post-op) beyond  the scope of this post.

AFR returns sucess for these FOPs only if they meet quorum. For  replica 2, this means it needs to suceed on any one brick. For replica  3, it is two out of theree and so on.

### More on the AFR xattrs:

We saw that AFR modifies the dirty and pending xattrs in the pre-op  and post-op phases. To be more precise, only parts of the xattr are  modified in a given transaction. Which bytes are modified depends on the type of write transaction which the FOP belongs to.

| Transaction Type         | FOPs that belong to it                                       |
| ------------------------ | ------------------------------------------------------------ |
| AFR_DATA_TRANSACTION     | afr_writev, afr_truncate, afr_ftruncate, afr_fsync, afr_fallocate, afr_discard, afr_zerofill |
| AFR_METADATA_TRANSACTION | afr_setattr, afr_fsetattr, afr_setxattr, afr_fsetxattr, afr_removexattr, afr_fremovexattr, afr_xattrop, afr_fxattrop |
| AFR_ENTRY_TRANSACTION    | afr_create, afr_mknod, afr_mkdir, afr_link, afr_symlink, afr_rename, afr_unlink, afr_rmdir |

Stop here and convince yourself that given a write based FOP, you can say which one of the 3 transaction types it belongs to.

**Note:** In the code, there is also a  AFR_ENTRY_RENAME_TRANSACTION (used by afr_rename) but it is safe to  assume that it is identical to AFR_ENTRY_TRANSACTION as far as  interpreting the xattrs are concerned.

Consider the xttr: `trusted.afr.dirty=0x000000000000000000000000` The first 4 bytes of the xattr are used for data transactions, the next 4 bytes for metadata transactions and the last 4 for entry transactions.  Let us see some examples of how the xattr would look like for various  types of FOPs during a transaction:

| FOP         | Value after pre-op phase                       | Value after post-op phase                      |
| ----------- | ---------------------------------------------- | ---------------------------------------------- |
| afr_writev  | trusted.afr.dirty=0x00000001 00000000 00000000 | trusted.afr.dirty=0x00000000 00000000 00000000 |
| afr_setattr | trusted.afr.dirty=0x00000000 00000001 00000000 | trusted.afr.dirty=0x00000000 00000000 00000000 |
| afr_create  | trusted.afr.dirty=0x00000000 00000000 00000001 | trusted.afr.dirty=0x00000000 00000000 00000000 |

Thus depending on the type of FOP (i.e. data/ metadata/ entry  transaction), different set of bytes of the dirty xattr get incremented/ decremented. Modification of the pending xattr also follows the same  pattern, execept it is incremented only in the post-op phase if the FOP  fails on some bricks.

**Example:** Let us say a write was performed on a file, say FILE1, on replica 3  volume called ‘testvol’. Suppose the lock and pre-op phase succeeded on  all bricks. After that the 3rd brick went down, and the transaction  completed successfully on the first 2 bricks. What will be the state of the afr xattrs on all bricks?

```

# getfattr -d -m . -e hex /bricks/brick1/FILE1 | grep afr
getfattr: Removing leading '/' from absolute path names
trusted.afr.dirty=0x000000000000000000000000
trusted.afr.testvol-client-2=0x000000010000000000000000

# getfattr -d -m . -e hex /bricks/brick2/FILE1 | grep afr
getfattr: Removing leading '/' from absolute path names
trusted.afr.dirty=0x000000000000000000000000
trusted.afr.testvol-client-2=0x000000010000000000000000

# getfattr -d -m . -e hex /bricks/brick3/FILE1 | grep afr
getfattr: Removing leading '/' from absolute path names
trusted.afr.dirty=0x000000010000000000000000
```

So Brick3 will still have the dirty xattr set because it went down  before the post-op had a chance to decrement it. Bricks 1 and 2 will  have a zero dirty xattr and in addition, a non-zero pending xattr set.  The client-2 in trusted.afr.testvol-client-2 indicates that the 3rd  brick is bad and has some pending data operations.

# 2. Self-heal logic.

We already know that AFR increments and/or decrements the dirty (i.e. `trusted.afr.dirty`) and pending (i.e. `trusted.afr.$VOLNAME-client-x`) xattrs during the different phases of the transaction. For a given file (or directory), an all zero value of these xattrs or the total absence  of these xattrs on all bricks of the replica mean the file is healthy  and does not need heal. If any of these xattrs are non-zero even on one  of the bricks, then the file is a candidate for heal- it as simple as  that.

When we say these xattrs are non-zero, it is in the context of no  on-going I/O going from client(s) on the file. Otherwise the non-zero  values that one observes might be transient as the write transaction is  progressing through its five phases. Of course, as an admin, you  wouldn’t need to figure out all of this. Just running the `heal info` set of commands should give you the list of files that need heal.

So if self-heal observes a file with non-zero xattrs, it does the following steps:

1. Fetch the afr xattrs, examine which set of 8 bytes are non-zero and  determine the corresponding heals that are needed on the file – i.e. **data heal/ metadata heal/ entry heal**.
2. Determine which bricks are good (a.k.a. ‘sources’) and which ones  are bad (a.k.a. ‘sinks’) for each of those heals by interpretting the  xattr values.
3. Pick one source brick and heal the file on to all the sink bricks.
4. If the heal is successful, reset the afr xattrs to zero.

This is a rather simplified description and I have omitted details  about various locks that each of these steps need to take because  self-heal and client I/O can happen in parallel on the file. Or even  multiple self-heal daemons (described later) can attempt to heal the  same file.

**Data heal**: Happens only for files. The contents of the file are copied from the source to the sink bricks.

**Entry heal**: Happens only for directories. Entries  (i.e. files and subdirs) under a given directory are deleted from the  sinks if they are not present in the source. Likewise, entries are  created on the sinks if they are not present in the source.

**Metadata heal:** Happens for both files and  directories. File ownership, file permissions and extended attributes  are copied from the source to the sink bricks.

It can be possible that for a given file, one set of bricks can be  the source for data heal while another set could be the source for  metadata heals. It all depends on which FOPs failed on what bricks and  therefore what set of bytes are non-zero for the afr xattrs.

## When do self-heals happen?

There are two places from which the steps described above for healing can be carried out:

### i) From the client side.

Client-side heals are triggered when the file is accessed from the  client (mount). AFR uses a monotonically increasing generation number to keep track of disconnect/connect of its children (i.e. the client  translators) to the bricks. When this ‘event generation’ number changes, the file’s inode is marked as a candidate for refresh. When the next  FOP comes on such an inode, a refresh is triggered to update the  readables during which a heal is launched (if the AFR xattrs indicate  that a heal is needed, that is). This heal happens in the background,  meaning it does not block the actual FOP which will continue as usual  post the refresh. Specific client-side heals can be turned off by  disabling the 3 corresponding volume options:

```text
cluster.metadata-self-heal
cluster.data-self-heal
cluster.entry-self-heal
```

The number of client-side heals that happen in the background can be tuned via the following volume options:

```text
background-self-heal-count
heal-wait-queue-length
```

See the `gluster volume set help` for more information on all the above options.

***Name heal\***: Name heal is just healing of the file/directory name when it is accessed. For example, say a file is  created and written to when a brick is down and all the 3 client side  heals are disabled. When the brick comes up and the next I/O comes on  it, the file name is created on it as a part of lookup. Its  contents/metadata are not healed though. Name heal cannot be disabled.  It is there to ensure that the namespace is consistent on all bricks as  soon as the file is accessed.

### ii) By the self-heal daemon.

There is a self-heal daemon process (glutershd) that runs on every  node of the trusted storage pool. It is a light weight client process  consisting mainly of AFR ant the protocol/client translators. It can  talk to all bricks of all the replicate volume(s) of the pool. It  periodically crawls (every 10 minutes by default; tunable via the `heal-timeout` volume option) the list of files that need heal and does their healing. As you can see, client side heal is done upon file access but  glustershd processes the heal backlog pro-actively.

### Index heal:

But how does glustershd know which files it needs to heal? Where does it get the list from? So in part-1, while we saw the five phases of the AFR write transaction, we left out one detail:

- In the pre-op phase, in addition to marking the dirty xattr, each brick also stores the gfid string of the file inside its `.glusterfs/indices/dirty` directory.
- Likewise, in the post-op phase, it removes the gfid string from its `.glusterfs/indices/dirty` If addition, if the write failed on some brick, the good bricks will stores the gfid string inside the `.glusterfs/indices/xattrop` directory.

Thus when no I/O is happening on a file and you still find its gfid inside `.glusterfs/indices/dirty` of a particular brick, it means the brick went down before the post-op phase. If you find the gfid inside `.glusterfs/indices/xattrop`, it means the write failed on some other brick and this brick has captured it.

The glustershd simply reads the list of entries inside `.glusterfs/indices/*` and triggers heal on them. This is referred to as **index heal**. While this happens automcatically every heal-timeout seconds, we can also manaully trigger it via the CLI using `gluster volume heal $VOLNAME` .

### Full heal:

A full heal, triggered from the CLI with `gluster volume heal $VOLNAME full`, does just what the name implies. It does not process a particular list  of entries like index heal, but crawls the whole gluster filesystem  beginning with root, examines if files have non zero afr xattrs and  triggers heal on them.

### Of missing xattrs and split-brains:

You might now realise how AFR pretty much relies on its xattr values  of a given file- from using it to find the good copies to serve a read  to finding out the source and sink bricks to heal the file. But what if  there is inconsistency in data/metadata of a file and

(a) there are zero/ no AFR xattrs (or)

(b) if the xattrs all blame each other (i.e. no good copy=>split-brain)?

For (a), AFR uses heuristics like picking a local (to that specfic  glustershd process) brick, picking the bigger file, picking the file  with latest ctime etc. and then does the heal.

For (b) you need to resort to using the gluster split-brain  resolution CLI or setting the favorite-child-policy volume option to  choose a good copy and trigger the heal.

# Geo-Replication

## Introduction

Geo-replication provides a continuous, asynchronous, and incremental replication service from one site to another over Local Area Networks (LANs), Wide Area Network (WANs), and across the Internet.

## Prerequisites

- Primary and Secondary Volumes should be Gluster Volumes.
- Primary and Secondary clusters should have the same GlusterFS version.

## Replicated Volumes vs Geo-replication

The following table lists the difference between replicated volumes and Geo-replication:

| Replicated Volumes                                           | Geo-replication                                              |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Mirrors data across clusters                                 | Mirrors data across geographically distributed clusters      |
| Provides high-availability                                   | Ensures backing up of data for disaster recovery             |
| Synchronous replication (each and every file operation is sent across all the bricks) | Asynchronous replication (checks for the changes in files periodically and syncs them on detecting differences) |

## Exploring Geo-replication Deployment Scenarios

Geo-replication provides an incremental replication service over Local Area Networks (LANs), Wide Area Network (WANs), and across the Internet.

This section illustrates the most common deployment scenarios for Geo-replication, including the following:

### Geo-replication over Local Area Network(LAN)

![geo-rep_lan](https://cloud.githubusercontent.com/assets/10970993/7412281/a542e724-ef5e-11e4-8207-9e018c1e9304.png)

### Geo-replication over Wide Area Network(WAN)

![geo-rep_wan](https://cloud.githubusercontent.com/assets/10970993/7412292/c3816f76-ef5e-11e4-8daa-271f6efa1f58.png)

### Geo-replication over Internet

![geo-rep03_internet](https://cloud.githubusercontent.com/assets/10970993/7412305/d8660050-ef5e-11e4-9d1b-54369fb1e43f.png)

### Mirror data in a cascading fashion across multiple sites(Multi-site cascading Geo-replication)

![geo-rep04_cascading](https://cloud.githubusercontent.com/assets/10970993/7412320/05e131bc-ef5f-11e4-8580-a4dc592148ff.png)

## Secondary User setup

Setup an unprivileged user in Secondary nodes to secure the SSH connectivity to those nodes. The unprivileged Secondary user uses the mountbroker service of glusterd to set up an auxiliary gluster mount for the user in a special environment, which ensures that the user is only allowed to access with special parameters that provide administrative level access to the particular Volume.

In all the Secondary nodes, create a new group as "geogroup".

```

sudo groupadd geogroup
```

In all the Secondary nodes, create an unprivileged account. For example, "geoaccount". Add geoaccount as a member of "geogroup" group.

```

useradd -G geogroup geoaccount
```

In any one Secondary node, run the following command to setup the mountbroker root directory and group.

```

gluster-mountbroker setup <MOUNT ROOT> <GROUP>
```

For example,

```

gluster-mountbroker setup /var/mountbroker-root geogroup
```

In any one of Secondary node, Run the following commands to add Volume and user to mountbroker service.

```

gluster-mountbroker add <VOLUME> <USER>
```

For example,

```

gluster-mountbroker add gvol-secondary geoaccount
```

(**Note**: To remove a user, use `gluster-mountbroker remove` command)

Check the status of setup using,

```

gluster-mountbroker status
```

Restart `glusterd` service on all Secondary nodes.

## Setting Up the Environment for Geo-replication

### Time Synchronization

On bricks of a geo-replication Primary volume, all the servers' time must be uniform. You are recommended to set up NTP (Network Time Protocol) or similar service to keep the bricks sync in time and avoid the out-of-time sync effect.

For example: In a Replicated volume where brick1 of the Primary is at 12.20 hrs, and brick 2 of the Primary is at 12.10 hrs with 10 minutes time lag, all the changes in brick2 between this period may go unnoticed during synchronization of files with Secondary.

### Password-less SSH

Password-less login has to be set up between the host machine (where geo-replication Create command will be issued) and one of the Secondary node for the unprivileged account created above.

**Note**: This is required to run Create command. This can be disabled once the session is established.(Required again while running create force)

On one of the Primary node where geo-replication Create command will be issued, run the following command to generate the SSH key(Press Enter twice to avoid passphrase).

```

ssh-keygen
```

Run the following command on the same node to one Secondary node which is identified as the main Secondary node.

```

ssh-copy-id geoaccount@snode1.example.com
```

### Creating secret pem pub file

Execute the below command from the node where you setup the password-less ssh to Secondary. This will generate Geo-rep session specific ssh-keys in all Primary peer nodes and collect public keys from all peer nodes to the command initiated node.

```

gluster-georep-sshkey generate
```

This command adds extra prefix inside common_secret.pem.pub file to each pub keys to prevent running extra commands using this key, to disable that prefix,

```

gluster-georep-sshkey generate --no-prefix
```

## Creating the session

Create a geo-rep session between Primary and Secondary volume using the following command. The node in which this command is executed and the `<Secondary_host>` specified in the command should have password less ssh setup between them. The push-pem option actually uses the secret pem pub file created earlier and establishes geo-rep specific password less ssh between each node in Primary to each node of Secondary.

```

gluster volume geo-replication <primary_volume> \
    <secondary_user>@<secondary_host>::<secondary_volume> \
    create [ssh-port <port>] push-pem|no-verify [force]
```

For example,

```

gluster volume geo-replication gvol-primary \
  geoaccount@snode1.example.com::gvol-secondary \
  create push-pem
```

If custom SSH port (example: 50022) is configured in Secondary nodes then

```

gluster volume geo-replication gvol-primary  \
  geoaccount@snode1.example.com::gvol-secondary \
  config ssh_port 50022

gluster volume geo-replication gvol-primary  \
  geoaccount@snode1.example.com::gvol-secondary \
  create ssh-port 50022 push-pem
```

If the total available size in Secondary volume is less than the total size of Primary, the command will throw error message. In such cases 'force' option can be used.

In use cases where the rsa-keys of nodes in Primary volume is distributed to Secondary nodes through an external agent and following Secondary side verifications are taken care of by the external agent, then

- if ssh port 22 or custom port is open in Secondary
- has proper passwordless ssh login setup
- Secondary volume is created and is empty
- if Secondary has enough memory

Then use following command to create Geo-rep session with `no-verify` option.

```

gluster volume geo-replication <primary_volume> \
    <secondary_user>@<secondary_host>::<secondary_volume> create no-verify [force]
```

For example,

```

gluster volume geo-replication gvol-primary  \
  geoaccount@snode1.example.com::gvol-secondary \
  create no-verify
```

In this case the Primary node rsa-key distribution to Secondary node does not happen and above mentioned Secondary verification is not performed and these two things has to be taken care externaly.

## Post Creation steps

Run the following command as root in any one of Secondary node.

```

/usr/libexec/glusterfs/set_geo_rep_pem_keys.sh <secondary_user> \
    <primary_volume> <secondary_volume>
```

For example,

```

/usr/libexec/glusterfs/set_geo_rep_pem_keys.sh geoaccount \
  gvol-primary gvol-secondary
```

## Configuration

Configuration can be changed anytime after creating the session. After successful configuration change, Geo-rep session will be automatically restarted.

To view all configured options of a session,

```

gluster volume geo-replication <primary_volume> \
    <secondary_user>@<secondary_host>::<secondary_volume> config [option]
```

For Example,

```

gluster volume geo-replication gvol-primary  \
  geoaccount@snode1.example.com::gvol-secondary \
  config

gluster volume geo-replication gvol-primary  \
  geoaccount@snode1.example.com::gvol-secondary \
  config sync-jobs
```

To configure Gluster Geo-replication, use the following command at the Gluster command line

```

gluster volume geo-replication <primary_volume> \
   <secondary_user>@<secondary_host>::<secondary_volume> config [option]
```

For example:

```

gluster volume geo-replication gvol-primary  \
  geoaccount@snode1.example.com::gvol-secondary \
  config sync-jobs 3
```

> **Note**: If Geo-rep is in between sync, restart due to configuration change may cause resyncing a few entries which are already synced.

## Configurable Options

**Meta Volume**

In case of Replica bricks, one brick worker will be Active and participate in syncing and others will be waiting as Passive. By default Geo-rep uses `node-uuid`, if `node-uuid` of worker present in first up subvolume node ids list then that worker will become Active. With this method, multiple workers of same replica becomes Active if multiple bricks used from same machine.

To prevent this, Meta Volume(Extra Gluster Volume) can be used in Geo-rep. With this method, Each worker will try to acquire lock on a file inside meta volume. Lock file name pattern will be different for each sub volume. If a worker acquire lock, then it will become Active else remain as Passive.

```

gluster volume geo-replication <primary_volume> \
    <secondary_user>@<secondary_host>::<secondary_volume> config
    use-meta-volume true
```

> **Note**: Meta Volume is shared replica 3 Gluster Volume. The name of the meta-volume should be `gluster_shared_storage` and should be mounted at `/var/run/gluster/shared_storage/`.

The following table provides an overview of the configurable options for a geo-replication setting:

| Option                           | Description                                                  |
| -------------------------------- | ------------------------------------------------------------ |
| log-level LOGFILELEVEL           | The log level for geo-replication.                           |
| gluster-log-level LOGFILELEVEL   | The log level for glusterfs processes.                       |
| changelog-log-level LOGFILELEVEL | The log level for Changelog processes.                       |
| ssh-command COMMAND              | The SSH command to connect to the remote machine (the default is  ssh). If ssh is installed in custom location, that path can be  configured. For ex `/usr/local/sbin/ssh` |
| rsync-command COMMAND            | The rsync command to use for synchronizing the files (the default is rsync). |
| use-tarssh true                  | The use-tarssh command allows tar over Secure Shell protocol. Use  this option to handle workloads of files that have not undergone edits. |
| timeout SECONDS                  | The timeout period in seconds.                               |
| sync-jobs N                      | The number of simultaneous files/directories that can be synchronized. |
| ignore-deletes                   | If this option is set to 1, a file deleted on the primary will not  trigger a delete operation on the secondary. As a result, the secondary  will remain as a superset of the primary and can be used to recover the  primary in the event of a crash and/or accidental delete. |

## Starting Geo-replication

Use the following command to start geo-replication session,

```

gluster volume geo-replication <primary_volume>  \
    <secondary_user>@<secondary_host>::<secondary_volume> \
    start [force]
```

For example,

```

gluster volume geo-replication gvol-primary  \
  geoaccount@snode1.example.com::gvol-secondary \
  start
```

> **Note**
>
> You may need to configure the session before starting Gluster Geo-replication.

## Stopping Geo-replication

Use the following command to stop geo-replication sesion,

```

gluster volume geo-replication <primary_volume>  \
    <secondary_user>@<secondary_host>::<secondary_volume> \
    stop [force]
```

For example,

```

gluster volume geo-replication gvol-primary  \
  geoaccount@snode1.example.com::gvol-secondary \
  stop
```

## Status

To check the status of all Geo-replication sessions in the Cluster

```

gluster volume geo-replication status
```

To check the status of one session,

```

gluster volume geo-replication <primary_volume> \
    <secondary_user>@<secondary_host>::<secondary_volume> status [detail]
```

Example,

```

gluster volume geo-replication gvol-primary \
  geoaccount@snode1::gvol-secondary status

gluster volume geo-replication gvol-primary \
  geoaccount@snode1::gvol-secondary status detail
```

Example Status Output

```

PRIMARY NODE    PRIMARY VOL          PRIMARY BRICK    SECONDARY USER    SECONDARY         SECONDARY NODE    STATUS    CRAWL STATUS       LAST_SYNCED
---------------------------------------------------------------------------------------------------------------------------------------------------------
mnode1         gvol-primary           /bricks/b1      root          snode1::gvol-secondary  snode1        Active    Changelog Crawl    2016-10-12 23:07:13
mnode2         gvol-primary           /bricks/b2      root          snode1::gvol-secondary  snode2        Active    Changelog Crawl    2016-10-12 23:07:13
```

Example Status detail Output

```

PRIMARY NODE    PRIMARY VOL    PRIMARY BRICK    SECONDARY USER    SECONDARY        SECONDARY NODE    STATUS    CRAWL STATUS       LAST_SYNCED            ENTRY    DATA    META    FAILURES    CHECKPOINT TIME    CHECKPOINT COMPLETED    CHECKPOINT COMPLETION TIME
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
mnode1         gvol-primary           /bricks/b1      root          snode1::gvol-secondary  snode1        Active    Changelog Crawl    2016-10-12 23:07:13    0        0       0       0           N/A                N/A                     N/A
mnode2         gvol-primary           /bricks/b2      root          snode1::gvol-secondary  snode2        Active    Changelog Crawl    2016-10-12 23:07:13    0        0       0       0           N/A                N/A                     N/A
```

The `STATUS` of the session could be one of the following,

- **Initializing**: This is the initial phase of the Geo-replication  session; it remains in this state for a minute in order to make  sure no abnormalities are present.

- **Created**: The geo-replication session is created, but not  started.

- **Active**: The gsync daemon in this node is active and syncing the  data. (One worker among the replica pairs will be in Active state)

- **Passive**: A replica pair of the active node. The data  synchronization is handled by active node. Hence, this node does  not sync any data. If Active node goes down, Passive worker will  become Active

- **Faulty**: The geo-replication session has experienced a problem,  and the issue needs to be investigated further. Check log files  for more details about the Faulty status. Log file path can be  found using

  ```
  
  ```

- ```
  gluster volume geo-replication <primary_volume> \
      <secondary_user>@<secondary_host>::<secondary_volume> config log-file
  ```

- **Stopped**: The geo-replication session has stopped, but has not  been deleted.

The `CRAWL STATUS` can be one of the following:

- **Hybrid Crawl**: The gsyncd daemon is crawling the glusterFS file  system and generating pseudo changelog to sync data. This crawl is  used during initial sync and if Changelogs are not available.
- **History Crawl**: gsyncd daemon syncs data by consuming Historical  Changelogs. On every worker restart, Geo-rep uses this Crawl to  process backlog Changelogs.
- **Changelog Crawl**: The changelog translator has produced the  changelog and that is being consumed by gsyncd daemon to sync  data.

The `ENTRY` denotes: **The number of pending entry operations** (create, mkdir, mknod, symlink, link, rename, unlink, rmdir) per session.

The `DATA` denotes: **The number of pending Data operations** (write, writev, truncate, ftruncate) per session.

The `META` denotes: **The number of pending Meta operations** (setattr, fsetattr, setxattr, fsetxattr, removexattr, fremovexattr) per session.

The `FAILURE` denotes: **The number of failures per session**. On encountering failures, one can proceed to look at the log files.

## Deleting the session

Established Geo-replication session can be deleted using the following command,

```

gluster volume geo-replication <primary_volume> \
    <secondary_user>@<secondary_host>::<secondary_volume> delete [force]
```

For example,

```

gluster volume geo-replication gvol-primary \
  geoaccount@snode1.example.com::gvol-secondary delete
```

> Note: If the same session is created again then syncing will resume from where it was stopped before deleting the session. If the session to be deleted permanently then use reset-sync-time option with delete command. For example, `gluster volume geo-replication gvol-primary geoaccount@snode1::gvol-secondary delete reset-sync-time`

## Checkpoint

Using Checkpoint feature we can find the status of sync with respect to the Checkpoint time. Checkpoint completion status shows "Yes" once Geo-rep syncs all the data from that brick which are created or modified before the Checkpoint Time.

Set the Checkpoint using,

```

gluster volume geo-replication <primary_volume> \
    <secondary_user>@<secondary_host>::<secondary_volume> config checkpoint now
```

Example,

```

gluster volume geo-replication gvol-primary \
  geoaccount@snode1.example.com::gvol-secondary \
  config checkpoint now
```

Touch the Primary mount point to make sure Checkpoint completes even though no I/O happening in the Volume

```

mount -t glusterfs <primaryhost>:<primaryvol> /mnt
touch /mnt
```

Checkpoint status can be checked using Geo-rep status command. Following columns in status output gives more information about Checkpoint

- **CHECKPOINT TIME**: Checkpoint Set Time
- **CHECKPOINT COMPLETED**: Yes/No/NA, Status of Checkpoint
- **CHECKPOINT COMPLETION TIME**: Checkpoint Completion Time if  completed, else N/A

## Log Files

Primary Log files are located in `/var/log/glusterfs/geo-replication` directory in each Primary nodes. Secondary log files are located in `/var/log/glusterfs/geo-replication-secondary` directory in Secondary nodes.

## Gluster Snapshots and Geo-replicated Volumes

Gluster snapshot of Primary and Secondary should not go out of order on restore. So while taking snapshot take snapshot of both Primary and Secondary Volumes.

- Pause the Geo-replication session using,

  ```
  
  ```

```
gluster volume geo-replication <primary_volume> \
    <secondary_user>@<secondary_host>::<secondary_volume> pause
```

Take Gluster Snapshot of Secondary Volume and Primary Volume(Use same  name for snapshots)

```

```

- ```
  gluster snapshot create <snapname> <volname>
  ```

Example,

```

    gluster snapshot create snap1 gvol-secondary
    gluster snapshot create snap1 gvol-primary
```

- Resume Geo-replication session using,

  ```
  
  ```

- ```
  gluster volume geo-replication <primary_volume> \
      <secondary_user>@<secondary_host>::<secondary_volume> resume
  ```

If we want to continue Geo-rep session after snapshot restore, we need to restore both Primary and Secondary Volume and resume the Geo-replication session using force option

```

gluster snapshot restore <snapname>
gluster volume geo-replication <primary_volume> \
    <secondary_user>@<secondary_host>::<secondary_volume> resume force
```

Example,

```

gluster snapshot restore snap1 # Secondary Snap
gluster snapshot restore snap1 # Primary Snap
gluster volume geo-replication gvol-primary geoaccount@snode1::gvol-secondary \
  resume force
```

# Managing Directory Quota

Directory quotas in GlusterFS allow you to set limits on the usage of the disk space by directories or volumes. The storage administrators can control the disk space utilization at the directory and/or volume levels in GlusterFS by setting limits to allocatable disk space at any level in the volume and directory hierarchy. This is particularly useful in cloud deployments to facilitate the utility billing model.

> **Note:** For now, only Hard limits are supported. Here, the limit cannot be exceeded, and attempts to use more disk space or inodes beyond the set limit are denied.

System administrators can also monitor the resource utilization to limit the storage for the users depending on their role in the organization.

You can set the quota at the following levels:

- **Directory level** – limits the usage at the directory level
- **Volume level** – limits the usage at the volume level

> **Note:** You can set the quota limit on an empty  directory. The quota limit will be automatically enforced when files are added to the directory.

## Enabling Quota

You must enable Quota to set disk limits.

**To enable quota:**

Use the following command to enable quota:

```

gluster volume quota <VOLNAME> enable
```

For example, to enable quota on the test-volume:

```

# gluster volume quota test-volume enable
Quota is enabled on /test-volume
```

## Disabling Quota

You can disable Quota if needed.

**To disable quota:**

Use the following command to disable quota:

```

gluster volume quota <VOLNAME> disable
```

For example, to disable quota translator on the test-volume:

```

# gluster volume quota test-volume disable
Quota translator is disabled on /test-volume
```

## Setting or Replacing Disk Limit

You can create new directories in your storage environment and set the disk limit or set disk limit for the existing directories. The directory name should be relative to the volume with the export directory/mount being treated as "/".

**To set or replace disk limit:**

Set the disk limit using the following command:

```

gluster volume quota <VOLNAME> limit-usage <DIR> <HARD_LIMIT>
```

For example, to set a limit on data directory on the test-volume where data is a directory under the export directory:

```

# gluster volume quota test-volume limit-usage /data 10GB
Usage limit has been set on /data
```

> **Note** In a multi-level directory hierarchy, the strictest disk limit will be considered for enforcement. Also, whenever the quota limit is set for the first time, an auxiliary mount point will be created under /var/run/gluster/. This is just like any other mount point with some special permissions and remains until the quota is disabled. This mount point is being used by quota to set and display limits and lists respectively.

## Displaying Disk Limit Information

You can display disk limit information on all the directories on which the limit is set.

**To display disk limit information:**

- Display disk limit information of all the directories on which limit  is set, using the following command:

  gluster volume quota  list

For example, to see the set disks limit on the test-volume:

```

  # gluster volume quota test-volume list
  /Test/data    10 GB       6 GB
  /Test/data1   10 GB       4 GB
```

- Display disk limit information on a particular directory on which  limit is set, using the following command:

  gluster volume quota  list 

  

For example, to view the set limit on /data directory of test-volume:

```

  # gluster volume quota test-volume list /data
  /Test/data    10 GB       6 GB
```

### Displaying Quota Limit Information Using the df Utility

You can create a report of the disk usage using the df utility by  considering quota limits. To generate a report, run the following  command:

```

gluster volume set <VOLNAME> quota-deem-statfs on
```

In this case, the total disk space of the directory is taken as the quota hard limit set on the directory of the volume.

> **Note** The default value for quota-deem-statfs is on when the quota is enabled and it is recommended to keep quota-deem-statfs on.

The following example displays the disk usage when quota-deem-statfs is off:

```

# gluster volume set test-volume features.quota-deem-statfs off
volume set: success

# gluster volume quota test-volume list
Path            Hard-limit    Soft-limit    Used      Available
---------------------------------------------------------------
/               300.0GB        90%          11.5GB    288.5GB
/John/Downloads  77.0GB        75%          11.5GB     65.5GB
```

Disk usage for volume test-volume as seen on client1:

```

# df -hT /home
Filesystem           Type            Size  Used Avail Use% Mounted on
server1:/test-volume fuse.glusterfs  400G   12G  389G   3% /home
```

The following example displays the disk usage when quota-deem-statfs is on:

```

# gluster volume set test-volume features.quota-deem-statfs on
volume set: success

# gluster vol quota test-volume list
Path        Hard-limit    Soft-limit     Used     Available
-----------------------------------------------------------
/              300.0GB        90%        11.5GB     288.5GB
/John/Downloads 77.0GB        75%        11.5GB     65.5GB
```

Disk usage for volume test-volume as seen on client1:

```

# df -hT /home
Filesystem            Type            Size  Used Avail Use% Mounted on
server1:/test-volume  fuse.glusterfs  300G   12G  289G   4% /home
```

The quota-deem-statfs option when set to on, allows the administrator to make the user view the total disk space available on the directory  as the hard limit set on it.

## Updating Memory Cache Size

### Setting Timeout

For performance reasons, quota caches the directory sizes on the client. You can set a timeout indicating the maximum valid duration of directory sizes in the cache, from the time they are populated.

For example: If multiple clients are writing to a single directory, there are chances that some other client might write till the quota limit is exceeded. However, this new file-size may not get reflected in the client till the size entry in the cache has become stale because of timeout. If writes happen on this client during this duration, they are allowed even though they would lead to exceeding of quota-limits, since the size in the cache is not in sync with the actual size. When a timeout happens, the size in the cache is updated from servers and will be in sync and no further writes will be allowed. A timeout of zero will force fetching of directory sizes from the server for every operation that modifies file data and will effectively disable directory size caching on the client-side.

**To update the memory cache size:**

Use the following command to update the memory cache size:

1. Soft Timeout: The frequency at which the quota server-side  translator checks the volume usage when the usage is below the soft  limit. The soft timeout is in effect when the disk usage is less than  the soft limit.

```

gluster volume set <VOLNAME> features.soft-timeout <time>
```

1. Hard Timeout: The frequency at which the quota server-side  translator checks the volume usage when the usage is above the soft  limit. The hard timeout is in effect when the disk usage is between the  soft limit and the hard limit.

```

gluster volume set <VOLNAME> features.hard-timeout <time>
```

For example, to update the memory cache size for every 5 seconds on test-volume in case of hard-timeout:

```

# gluster volume set test-volume features.hard-timeout 5
Set volume successful
```

## Setting Alert Time

Alert time is the frequency at which you want your usage information to be logged after you reach the soft limit.

**To set the alert time:**

Use the following command to set the alert time:

```

gluster volume quota <VOLNAME> alert-time <time>
```

> **Note:** The default alert-time is one week.

For example, to set the alert time to one day:

```

# gluster volume quota test-volume alert-time 1d
volume quota : success
```

## Removing Disk Limit

You can remove the set disk limit if you do not want a quota anymore.

**To remove disk limit:**

Use the following command to remove the disk limit set on a particular directory:

```

gluster volume quota <VOLNAME> remove <DIR>
```

For example, to remove the disk limit on /data directory of test-volume:

```

# gluster volume quota test-volume remove /data
Usage limit set on /data is removed
```

# Managing GlusterFS Volume Snapshots

This section describes how to perform common GlusterFS volume snapshot management operations

## Pre-requisites

GlusterFS volume snapshot feature is based on thinly provisioned LVM snapshot. To make use of snapshot feature GlusterFS volume should fulfill following pre-requisites:

- Each brick should be on an independent thinly provisioned LVM.
- Brick LVM should not contain any other data other than brick.
- None of the brick should be on a thick LVM.
- gluster version should be 3.6 and above.

Details of how to create thin volume can be found at the following  link. https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Logical_Volume_Manager_Administration/LV.html#thinly_provisioned_volume_creation

## Few features of snapshot are:

**Crash Consistency**

when a snapshot is taken at a particular point-in-time, it is made sure that the taken snapshot is crash consistent. when the taken snapshot is restored, then the data is identical as it was at the time of taking a snapshot.

**Online Snapshot**

When the snapshot is being taken the file system and its associated data continue to be available for the clients.

**Barrier**

During snapshot creation some of the fops are blocked to guarantee crash consistency. There is a default time-out of 2 minutes, if snapshot creation is not complete within that span then fops are unbarried. If unbarrier happens before the snapshot creation is complete then the snapshot creation operation fails. This to ensure that the snapshot is in a consistent state.

## Snapshot Management

### Snapshot creation

```

gluster snapshot create <snapname> <volname> [no-timestamp] [description <description>]
```

Creates a snapshot of a GlusterFS volume. User can provide a snap-name and a description to identify the snap. The description cannot be more than 1024 characters.

Snapshot will be created by appending timestamp with user provided snap name. User can override this behaviour by giving no-timestamp flag.

**NOTE**: To be able to take a snapshot, volume should be present and it should be in started state. All the bricks used in creating the snapshot have to be online in order to successfully create a snapshot as the force option is now deprecated.

### Snapshot clone

```

gluster snapshot clone <clonename> <snapname>
```

Creates a clone of a snapshot. Upon successful completion, a new GlusterFS volume will be created from snapshot. The clone will be a space efficient clone, i.e, the snapshot and the clone will share the backend disk.

**NOTE**: To be able to take a clone from snapshot, snapshot should be present and it should be in activated state.

### Restoring snaps

```

gluster snapshot restore <snapname>
```

Restores an already taken snapshot of a GlusterFS volume. Snapshot restore is an offline activity therefore if the volume is online (in started state) then the restore operation will fail.

Once the snapshot is restored it will not be available in the list of snapshots.

### Deleting snaps

```

gluster snapshot delete (all | <snapname> | volume <volname>)
```

If snapname is specified then mentioned snapshot is deleted. If volname is specified then all snapshots belonging to that particular volume is deleted. If keyword *all* is used then all snapshots belonging to the system is deleted.

### Listing of available snaps

```

gluster snapshot list [volname]
```

Lists all snapshots taken. If volname is provided, then only the snapshots belonging to that particular volume is listed.

### Information of available snaps

```

gluster snapshot info [(snapname | volume <volname>)]
```

This command gives information such as snapshot name, snapshot UUID, time at which snapshot was created, and it lists down the snap-volume-name, number of snapshots already taken and number of snapshots still available for that particular volume, and the state of the snapshot.

### Status of snapshots

```

gluster snapshot status [(snapname | volume <volname>)]
```

This command gives status of the snapshot. The details included are snapshot brick path, volume group(LVM details), status of the snapshot bricks, PID of the bricks, data percentage filled for that particular volume group to which the snapshots belong to, and total size of the logical volume.

If snapname is specified then status of the mentioned snapshot is displayed. If volname is specified then status of all snapshots belonging to that volume is displayed. If both snapname and volname is not specified then status of all the snapshots present in the system are displayed.

### Configuring the snapshot behavior

```

snapshot config [volname] ([snap-max-hard-limit <count>] [snap-max-soft-limit <percent>])
                            | ([auto-delete <enable|disable>])
                            | ([activate-on-create <enable|disable>])
```

Displays and sets the snapshot config values.

snapshot config without any keywords displays the snapshot config values of all volumes in the system. If volname is provided, then the snapshot config values of that volume is displayed.

Snapshot config command along with keywords can be used to change the existing config values. If volname is provided then config value of that volume is changed, else it will set/change the system limit.

snap-max-soft-limit and auto-delete are global options, that will be inherited by all volumes in the system and cannot be set to individual volumes.

The system limit takes precedence over the volume specific limit.

When auto-delete feature is enabled, then upon reaching the soft-limit, with every successful snapshot creation, the oldest snapshot will be deleted.

When auto-delete feature is disabled, then upon reaching the soft-limit, the user gets a warning with every successful snapshot creation.

Upon reaching the hard-limit, further snapshot creations will not be allowed.

activate-on-create is disabled by default. If you enable activate-on-create, then further snapshot will be activated during the time of snapshot creation.

### Activating a snapshot

```

gluster snapshot activate <snapname>
```

Activates the mentioned snapshot.

**Note**: By default the snapshot will not be activated during snapshot creation.

### Deactivate a snapshot

```

gluster snapshot deactivate <snapname>
```

Deactivates the mentioned snapshot.

### Accessing the snapshot

Snapshots can be accessed in 2 ways.

1. Mounting the snapshot:

   The snapshot can be accessed via FUSE mount (only fuse). To do that it has to be mounted first. A snapshot can be mounted via fuse by below command

   ```
   
   ```

```
mount -t glusterfs <hostname>:/snaps/<snap-name>/<volume-name> <mount-path>
```

i.e. say "host1" is one of the peers. Let "vol" be the volume name and "my-snap" be the snapshot name. In this case a snapshot can be mounted via this command

```

mount -t glusterfs host1:/snaps/my-snap/vol /mnt/snapshot
```

User serviceability:

Apart from the above method of mounting the snapshot, a list of available snapshots and the contents of each snapshot can be viewed from any of the mount points accessing the glusterfs volume (either FUSE or NFS or SMB). For having user serviceable snapshots, it has to be enabled for a volume first. User serviceability can be enabled for a volume using the below command.

```

gluster volume set <volname> features.uss enable
```

Once enabled, from any of the directory (including root of the filesystem) an access point will be created to the snapshot world. The access point is a hidden directory cding into which will make the user enter the snapshot world. By default the hidden directory is ".snaps". Once user serviceability is enabled, one will be able to cd into .snaps from any directory. Doing "ls" on that directory shows a list of directories which are nothing but the snapshots present for that volume. Say if there are 3 snapshots ("snap1", "snap2", "snap3"), then doing ls in .snaps directory will show those 3 names as the directory entries. They represent the state of the directory from which .snaps was entered, at different points in time.

**NOTE**: The access to the snapshots are read-only. The snapshot needs to be activated for it to be accessible inside .snaps directory.

Also, the name of the hidden directory (or the access point to the snapshot world) can be changed using the below command.

```

```

1. ```
   gluster volume set <volname> snapshot-directory <new-name>
   ```

2. Accessing from windows:

   The glusterfs volumes can be made accessible by windows via samba. (the glusterfs plugin for samba helps achieve this, without having to re-export a fuse mounted glusterfs volume). The snapshots of a glusterfs volume can also be viewed in the windows explorer.

   There are 2 ways:

   - Give the path of the entry point directory  (`<hostname><samba-share><directory><entry-point path>`) in the run command  window
   - Go to the samba share via windows explorer. Make hidden files and folders  visible so that in the root of the samba share a folder icon for the entry point  can be seen.

**NOTE**: From the explorer, snapshot world can be entered via entry point only from the root of the samba share. If snapshots have to be seen from subfolders, then the path should be provided in the run command window.

For snapshots to be accessible from windows, below 2 options can be used.

1. The glusterfs plugin for samba should give the option "snapdir-entry-path"    while starting. The option is an indication to glusterfs, that samba is loading    it and the value of the option should be the path that is being used as the    share for windows.

   Ex: Say, there is a glusterfs volume and a directory called "export" from the root of the volume is being used as the samba share, then samba has to load glusterfs with this option as well.

   ```
   
   ```

1. ```
    ret = glfs_set_xlator_option(
            fs,
            "*-snapview-client",
            "snapdir-entry-path", "/export"
    );
   ```

   The xlator option "snapdir-entry-path" is not exposed via volume set options, cannot be changed from CLI. Its an option that has to be provided at the time of mounting glusterfs or when samba loads glusterfs.

2. The accessibility of snapshots via root of the samba share from windows    is configurable. By default it is turned off. It is a volume set option which can    be changed via CLI.

   `gluster volume set <volname> features.show-snapshot-directory <on/off>`. By default it is off.

Only when both the above options have been provided (i.e snapdir-entry-path contains a valid unix path that is exported and show-snapshot-directory option is set to true), snapshots can accessed via windows explorer.

If only 1st option (i.e. snapdir-entry-path) is set via samba and 2nd option (i.e. show-snapshot-directory) is off, then snapshots can be accessed from windows via the run command window, but not via the explorer.

# io_uring support in gluster

io_uring is an asynchronous I/O interface similar to linux-aio, but aims to be more performant. Refer https://kernel.dk/io_uring.pdf and https://kernel-recipes.org/en/2019/talks/faster-io-through-io_uring for more details.

Incorporating io_uring in various layers of gluster is an ongoing  activity but beginning with glusterfs-9.0, support has been added to the posix translator via the `storage.linux-io_uring` volume  option. When this option is enabled, the posix translator in the  glusterfs brick process (at the server side) will use io_uring calls for reads, writes and fsyncs as opposed to the normal pread/pwrite based  syscalls.

#### Example:

```console
# gluster volume set testvol storage.linux-io_uring on
volume set: success

# gluster volume set testvol storage.linux-io_uring off
volume set: success
```

This option can be enabled/disabled only when the volume is not running. i.e. you can toggle the option when the volume is `Created` or is `Stopped` as indicated in `gluster volume status $VOLNAME`

# Monitoring your GlusterFS Workload

You can monitor the GlusterFS volumes on different parameters. Monitoring volumes helps in capacity planning and performance tuning tasks of the GlusterFS volume. Using these information, you can identify and troubleshoot issues.

You can use Volume Top and Profile commands to view the performance and identify bottlenecks/hotspots of each brick of a volume. This helps system administrators to get vital performance information whenever performance needs to be probed.

You can also perform statedump of the brick processes and nfs server process of a volume, and also view volume status and volume information.

## Running GlusterFS Volume Profile Command

GlusterFS Volume Profile command provides an interface to get the per-brick I/O information for each File Operation (FOP) of a volume. The per brick information helps in identifying bottlenecks in the storage system.

This section describes how to run GlusterFS Volume Profile command by performing the following operations:

- [Start Profiling](https://docs.gluster.org/en/latest/Administrator-Guide/Monitoring-Workload/#start-profiling)
- [Displaying the I/0 Information](https://docs.gluster.org/en/latest/Administrator-Guide/Monitoring-Workload/#displaying-io)
- [Stop Profiling](https://docs.gluster.org/en/latest/Administrator-Guide/Monitoring-Workload/#stop-profiling)



### Start Profiling

You must start the Profiling to view the File Operation information for each brick.

To start profiling, use following command:

```
# gluster volume profile start
```

For example, to start profiling on test-volume:

```

# gluster volume profile test-volume start
Profiling started on test-volume
```

When profiling on the volume is started, the following additional options are displayed in the Volume Info:

```

diagnostics.count-fop-hits: on
diagnostics.latency-measurement: on
```



### Displaying the I/0 Information

You can view the I/O information of each brick by using the following command:

```
# gluster volume profile info
```

For example, to see the I/O information on test-volume:

```

# gluster volume profile test-volume info
Brick: Test:/export/2
Cumulative Stats:

Block                     1b+           32b+           64b+
Size:
       Read:                0              0              0
       Write:             908             28              8

Block                   128b+           256b+         512b+
Size:
       Read:                0               6             4
       Write:               5              23            16

Block                  1024b+          2048b+        4096b+
Size:
       Read:                 0              52           17
       Write:               15             120          846

Block                   8192b+         16384b+      32768b+
Size:
       Read:                52               8           34
       Write:              234             134          286

Block                                  65536b+     131072b+
Size:
       Read:                               118          622
       Write:                             1341          594


%-latency  Avg-      Min-       Max-       calls     Fop
          latency   Latency    Latency
___________________________________________________________
4.82      1132.28   21.00      800970.00   4575    WRITE
5.70       156.47    9.00      665085.00   39163   READDIRP
11.35      315.02    9.00     1433947.00   38698   LOOKUP
11.88     1729.34   21.00     2569638.00    7382   FXATTROP
47.35   104235.02 2485.00     7789367.00     488   FSYNC

------------------

------------------

Duration     : 335

BytesRead    : 94505058

BytesWritten : 195571980
```



### Stop Profiling

You can stop profiling the volume, if you do not need profiling information anymore.

Stop profiling using the following command:

```

# gluster volume profile  stop
```

For example, to stop profiling on test-volume:

```

# gluster volume profile  stop

Profiling stopped on test-volume
```

## Running GlusterFS Volume TOP Command

GlusterFS Volume Top command allows you to view the glusterfs bricks’ performance metrics like read, write, file open calls, file read calls, file write calls, directory open calls, and directory real calls. The top command displays up to 100 results.

This section describes how to run and view the results for the following GlusterFS Top commands:

- [Viewing Open fd Count and Maximum fd Count](https://docs.gluster.org/en/latest/Administrator-Guide/Monitoring-Workload/#open-fd-count)
- [Viewing Highest File Read Calls](https://docs.gluster.org/en/latest/Administrator-Guide/Monitoring-Workload/#file-read)
- [Viewing Highest File Write Calls](https://docs.gluster.org/en/latest/Administrator-Guide/Monitoring-Workload/#file-write)
- [Viewing Highest Open Calls on Directories](https://docs.gluster.org/en/latest/Administrator-Guide/Monitoring-Workload/#open-dir)
- [Viewing Highest Read Calls on Directory](https://docs.gluster.org/en/latest/Administrator-Guide/Monitoring-Workload/#read-dir)
- [Viewing List of Read Performance on each Brick](https://docs.gluster.org/en/latest/Administrator-Guide/Monitoring-Workload/#read-perf)
- [Viewing List of Write Performance on each Brick](https://docs.gluster.org/en/latest/Administrator-Guide/Monitoring-Workload/#write-perf)



### Viewing Open fd Count and Maximum fd Count

You can view both current open fd count (list of files that are currently the most opened and the count) on the brick and the maximum open fd count (count of files that are the currently open and the count of maximum number of files opened at any given point of time, since the servers are up and running). If the brick name is not specified, then open fd metrics of all the bricks belonging to the volume will be displayed.

- View open fd count and maximum fd count using the following command:

```
# gluster volume top open [brick ] [list-cnt ]
```

For example, to view open fd count and maximum fd count on brick  server:/export of test-volume and list top 10 open calls:

```
# gluster volume top open brick list-cnt
Brick: server:/export/dir1
Current open fd's: 34 Max open fd's: 209

               ==========Open file stats========

  open            file name
  call count

  2               /clients/client0/~dmtmp/PARADOX/
                  COURSES.DB

  11              /clients/client0/~dmtmp/PARADOX/
                  ENROLL.DB

  11              /clients/client0/~dmtmp/PARADOX/
                  STUDENTS.DB

  10              /clients/client0/~dmtmp/PWRPNT/
                  TIPS.PPT

  10              /clients/client0/~dmtmp/PWRPNT/
                  PCBENCHM.PPT

  9               /clients/client7/~dmtmp/PARADOX/
                  STUDENTS.DB

  9               /clients/client1/~dmtmp/PARADOX/
                  STUDENTS.DB

  9               /clients/client2/~dmtmp/PARADOX/
                  STUDENTS.DB

  9               /clients/client0/~dmtmp/PARADOX/
                  STUDENTS.DB

  9               /clients/client8/~dmtmp/PARADOX/
                  STUDENTS.DB
```



### Viewing Highest File Read Calls

You can view highest read calls on each brick. If brick name is not specified, then by default, list of 100 files will be displayed.

- View highest file Read calls using the following command:

```
# gluster volume top read [brick ] [list-cnt ]
```

For example, to view highest Read calls on brick server:/export of  test-volume:

```
# gluster volume top read brick list-cnt
```

`Brick:` server:/export/dir1

```

            ==========Read file stats========

  read              filename
  call count

  116              /clients/client0/~dmtmp/SEED/LARGE.FIL

  64               /clients/client0/~dmtmp/SEED/MEDIUM.FIL

  54               /clients/client2/~dmtmp/SEED/LARGE.FIL

  54               /clients/client6/~dmtmp/SEED/LARGE.FIL

  54               /clients/client5/~dmtmp/SEED/LARGE.FIL

  54               /clients/client0/~dmtmp/SEED/LARGE.FIL

  54               /clients/client3/~dmtmp/SEED/LARGE.FIL

  54               /clients/client4/~dmtmp/SEED/LARGE.FIL

  54               /clients/client9/~dmtmp/SEED/LARGE.FIL

  54               /clients/client8/~dmtmp/SEED/LARGE.FIL
```



### Viewing Highest File Write Calls

You can view list of files which has highest file write calls on each brick. If brick name is not specified, then by default, list of 100 files will be displayed.

- View highest file Write calls using the following command:

```
# gluster volume top write [brick ] [list-cnt ]
```

For example, to view highest Write calls on brick server:/export of  test-volume:

```
# gluster volume top write brick list-cnt
Brick: server:/export/dir1

                 ==========Write file stats========
  write call count   filename

  83                /clients/client0/~dmtmp/SEED/LARGE.FIL

  59                /clients/client7/~dmtmp/SEED/LARGE.FIL

  59                /clients/client1/~dmtmp/SEED/LARGE.FIL

  59                /clients/client2/~dmtmp/SEED/LARGE.FIL

  59                /clients/client0/~dmtmp/SEED/LARGE.FIL

  59                /clients/client8/~dmtmp/SEED/LARGE.FIL

  59                /clients/client5/~dmtmp/SEED/LARGE.FIL

  59                /clients/client4/~dmtmp/SEED/LARGE.FIL

  59                /clients/client6/~dmtmp/SEED/LARGE.FIL

  59                /clients/client3/~dmtmp/SEED/LARGE.FIL
```



### Viewing Highest Open Calls on Directories

You can view list of files which has highest open calls on directories of each brick. If brick name is not specified, then the metrics of all the bricks belonging to that volume will be displayed.

- View list of open calls on each directory using the following  command:

```
# gluster volume top opendir [brick ] [list-cnt ]
```

For example, to view open calls on brick server:/export/ of  test-volume:

```
# gluster volume top opendir brick list-cnt
Brick: server:/export/dir1

           ==========Directory open stats========

  Opendir count     directory name

  1001              /clients/client0/~dmtmp

  454               /clients/client8/~dmtmp

  454               /clients/client2/~dmtmp

  454               /clients/client6/~dmtmp

  454               /clients/client5/~dmtmp

  454               /clients/client9/~dmtmp

  443               /clients/client0/~dmtmp/PARADOX

  408               /clients/client1/~dmtmp

  408               /clients/client7/~dmtmp

  402               /clients/client4/~dmtmp
```



### Viewing Highest Read Calls on Directory

You can view list of files which has highest directory read calls on each brick. If brick name is not specified, then the metrics of all the bricks belonging to that volume will be displayed.

- View list of highest directory read calls on each brick using the  following command:

```
# gluster volume top test-volume readdir [brick BRICK] [list-cnt {0..100}]
```

For example, to view highest directory read calls on brick  server:/export of test-volume:

```
# gluster volume top test-volume readdir brick server:/export list-cnt 10
Brick:

  ==========Directory readdirp stats========

  readdirp count           directory name

  1996                    /clients/client0/~dmtmp

  1083                    /clients/client0/~dmtmp/PARADOX

  904                     /clients/client8/~dmtmp

  904                     /clients/client2/~dmtmp

  904                     /clients/client6/~dmtmp

  904                     /clients/client5/~dmtmp

  904                     /clients/client9/~dmtmp

  812                     /clients/client1/~dmtmp

  812                     /clients/client7/~dmtmp

  800                     /clients/client4/~dmtmp
```



### Viewing List of Read Performance on each Brick

You can view the read throughput of files on each brick. If brick name is not specified, then the metrics of all the bricks belonging to that volume will be displayed. The output will be the read throughput.

```

       ==========Read throughput file stats========

read         filename                         Time
through
put(MBp
s)

2570.00    /clients/client0/~dmtmp/PWRPNT/      -2011-01-31
           TRIDOTS.POT                      15:38:36.894610
2570.00    /clients/client0/~dmtmp/PWRPNT/      -2011-01-31
           PCBENCHM.PPT                     15:38:39.815310
2383.00    /clients/client2/~dmtmp/SEED/        -2011-01-31
           MEDIUM.FIL                       15:52:53.631499

2340.00    /clients/client0/~dmtmp/SEED/        -2011-01-31
           MEDIUM.FIL                       15:38:36.926198

2299.00   /clients/client0/~dmtmp/SEED/         -2011-01-31
          LARGE.FIL                         15:38:36.930445

2259.00   /clients/client0/~dmtmp/PARADOX/      -2011-01-31
          COURSES.X04                       15:38:40.549919

2221.00   /clients/client0/~dmtmp/PARADOX/      -2011-01-31
          STUDENTS.VAL                      15:52:53.298766

2221.00   /clients/client3/~dmtmp/SEED/         -2011-01-31
          COURSES.DB                        15:39:11.776780

2184.00   /clients/client3/~dmtmp/SEED/         -2011-01-31
          MEDIUM.FIL                        15:39:10.251764

2184.00   /clients/client5/~dmtmp/WORD/         -2011-01-31
          BASEMACH.DOC                      15:39:09.336572
```

This command will initiate a dd for the specified count and block size and measures the corresponding throughput.

- View list of read performance on each brick using the following  command:

```
# gluster volume top read-perf [bs count ] [brick ] [list-cnt ]
```

For example, to view read performance on brick server:/export/ of  test-volume, 256 block size of count 1, and list count 10:

```
# gluster volume top read-perf bs 256 count 1 brick list-cnt
Brick: server:/export/dir1 256 bytes (256 B) copied, Throughput: 4.1 MB/s

         ==========Read throughput file stats========

  read         filename                         Time
  through
  put(MBp
  s)

  2912.00   /clients/client0/~dmtmp/PWRPNT/    -2011-01-31
             TRIDOTS.POT                   15:38:36.896486

  2570.00   /clients/client0/~dmtmp/PWRPNT/    -2011-01-31
             PCBENCHM.PPT                  15:38:39.815310

  2383.00   /clients/client2/~dmtmp/SEED/      -2011-01-31
             MEDIUM.FIL                    15:52:53.631499

  2340.00   /clients/client0/~dmtmp/SEED/      -2011-01-31
             MEDIUM.FIL                    15:38:36.926198

  2299.00   /clients/client0/~dmtmp/SEED/      -2011-01-31
             LARGE.FIL                     15:38:36.930445

  2259.00  /clients/client0/~dmtmp/PARADOX/    -2011-01-31
            COURSES.X04                    15:38:40.549919

  2221.00  /clients/client9/~dmtmp/PARADOX/    -2011-01-31
            STUDENTS.VAL                   15:52:53.298766

  2221.00  /clients/client8/~dmtmp/PARADOX/    -2011-01-31
           COURSES.DB                      15:39:11.776780

  2184.00  /clients/client3/~dmtmp/SEED/       -2011-01-31
            MEDIUM.FIL                     15:39:10.251764

  2184.00  /clients/client5/~dmtmp/WORD/       -2011-01-31
           BASEMACH.DOC                    15:39:09.336572
```



### Viewing List of Write Performance on each Brick

You can view list of write throughput of files on each brick. If brick name is not specified, then the metrics of all the bricks belonging to that volume will be displayed. The output will be the write throughput.

This command will initiate a dd for the specified count and block size and measures the corresponding throughput. To view list of write performance on each brick:

- View list of write performance on each brick using the following  command:

```
# gluster volume top write-perf [bs count ] [brick ] [list-cnt ]
```

For example, to view write performance on brick server:/export/ of  test-volume, 256 block size of count 1, and list count 10:

```
# gluster volume top write-perf bs 256 count 1 brick list-cnt
```

`Brick`: server:/export/dir1

```
256 bytes (256 B) copied, Throughput: 2.8 MB/s

         ==========Write throughput file stats========

  write                filename                 Time
  throughput
  (MBps)

  1170.00    /clients/client0/~dmtmp/SEED/     -2011-01-31
             SMALL.FIL                     15:39:09.171494

  1008.00    /clients/client6/~dmtmp/SEED/     -2011-01-31
             LARGE.FIL                      15:39:09.73189

  949.00    /clients/client0/~dmtmp/SEED/      -2011-01-31
            MEDIUM.FIL                     15:38:36.927426

  936.00   /clients/client0/~dmtmp/SEED/       -2011-01-31
           LARGE.FIL                        15:38:36.933177
  897.00   /clients/client5/~dmtmp/SEED/       -2011-01-31
           MEDIUM.FIL                       15:39:09.33628

  897.00   /clients/client6/~dmtmp/SEED/       -2011-01-31
           MEDIUM.FIL                       15:39:09.27713

  885.00   /clients/client0/~dmtmp/SEED/       -2011-01-31
            SMALL.FIL                      15:38:36.924271

  528.00   /clients/client5/~dmtmp/SEED/       -2011-01-31
           LARGE.FIL                        15:39:09.81893

  516.00   /clients/client6/~dmtmp/ACCESS/    -2011-01-31
           FASTENER.MDB                    15:39:01.797317
```

## Displaying Volume Information

You can display information about a specific volume, or all volumes, as needed.

- Display information about a specific volume using the following  command:

```
# gluster volume info VOLNAME
```

For example, to display information about test-volume:

```

  # gluster volume info test-volume
  Volume Name: test-volume
  Type: Distribute
  Status: Created
  Number of Bricks: 4
  Bricks:
  Brick1: server1:/exp1
  Brick2: server2:/exp2
  Brick3: server3:/exp3
  Brick4: server4:/exp4
```

- Display information about all volumes using the following command:

```
# gluster volume info all

  # gluster volume info all

  Volume Name: test-volume
  Type: Distribute
  Status: Created
  Number of Bricks: 4
  Bricks:
  Brick1: server1:/exp1
  Brick2: server2:/exp2
  Brick3: server3:/exp3
  Brick4: server4:/exp4

  Volume Name: mirror
  Type: Distributed-Replicate
  Status: Started
  Number of Bricks: 2 X 2 = 4
  Bricks:
  Brick1: server1:/brick1
  Brick2: server2:/brick2
  Brick3: server3:/brick3
  Brick4: server4:/brick4

  Volume Name: Vol
  Type: Distribute
  Status: Started
  Number of Bricks: 1
  Bricks:
  Brick: server:/brick6
```

## Performing Statedump on a Volume

Statedump is a mechanism through which you can get details of all internal variables and state of the glusterfs process at the time of issuing the command.You can perform statedumps of the brick processes and nfs server process of a volume using the statedump command. The following options can be used to determine what information is to be dumped:

- **mem** - Dumps the memory usage and memory pool details of the  bricks.
- **iobuf** - Dumps iobuf details of the bricks.
- **priv** - Dumps private information of loaded translators.
- **callpool** - Dumps the pending calls of the volume.
- **fd** - Dumps the open fd tables of the volume.
- **inode** - Dumps the inode tables of the volume.

**To display volume statedump**

- Display statedump of a volume or NFS server using the following  command:

```
# gluster volume statedump [nfs] [all|mem|iobuf|callpool|priv|fd|inode]
```

For example, to display statedump of test-volume:

```

  # gluster volume statedump test-volume
  Volume statedump successful
```

The statedump files are created on the brick servers in the`/tmp`  directory or in the directory set using `server.statedump-path`  volume option. The naming convention of the dump file is  `<brick-path>.<brick-pid>.dump`.

- By defult, the output of the statedump is stored at  `/tmp/<brickname.PID.dump>` file on that particular server. Change  the directory of the statedump file using the following command:

```
# gluster volume set server.statedump-path
```

For example, to change the location of the statedump file of  test-volume:

```

  # gluster volume set test-volume server.statedump-path /usr/local/var/log/glusterfs/dumps/
  Set volume successful
```

You can view the changed path of the statedump file using the  following command:

```
# gluster volume info
```

## Displaying Volume Status

You can display the status information about a specific volume, brick or all volumes, as needed. Status information can be used to understand the current status of the brick, nfs processes, and overall file system. Status information can also be used to monitor and debug the volume information. You can view status of the volume along with the following details:

- **detail** - Displays additional information about the bricks.
- **clients** - Displays the list of clients connected to the volume.
- **mem** - Displays the memory usage and memory pool details of the  bricks.
- **inode** - Displays the inode tables of the volume.
- **fd** - Displays the open fd (file descriptors) tables of the  volume.
- **callpool** - Displays the pending calls of the volume.

**To display volume status**

- Display information about a specific volume using the following  command:

```
# gluster volume status [all| []] [detail|clients|mem|inode|fd|callpool]
```

For example, to display information about test-volume:

```

  # gluster volume status test-volume
  STATUS OF VOLUME: test-volume
  BRICK                           PORT   ONLINE   PID
  --------------------------------------------------------
  arch:/export/1                  24009   Y       22445
  --------------------------------------------------------
  arch:/export/2                  24010   Y       22450
```

- Display information about all volumes using the following command:

```
# gluster volume status all

  # gluster volume status all
  STATUS OF VOLUME: volume-test
  BRICK                           PORT   ONLINE   PID
  --------------------------------------------------------
  arch:/export/4                  24010   Y       22455

  STATUS OF VOLUME: test-volume
  BRICK                           PORT   ONLINE   PID
  --------------------------------------------------------
  arch:/export/1                  24009   Y       22445
  --------------------------------------------------------
  arch:/export/2                  24010   Y       22450
```

- Display additional information about the bricks using the following  command:

```
# gluster volume status detail
```

For example, to display additional information about the bricks of  test-volume:

```

  # gluster volume status test-volume details
  STATUS OF VOLUME: test-volume
  -------------------------------------------
  Brick                : arch:/export/1
  Port                 : 24009
  Online               : Y
  Pid                  : 16977
  File System          : rootfs
  Device               : rootfs
  Mount Options        : rw
  Disk Space Free      : 13.8GB
  Total Disk Space     : 46.5GB
  Inode Size           : N/A
  Inode Count          : N/A
  Free Inodes          : N/A

  Number of Bricks: 1
  Bricks:
  Brick: server:/brick6
```

- Display the list of clients accessing the volumes using the  following command:

```
# gluster volume status test-volume clients
```

For example, to display the list of clients connected to  test-volume:

```

  # gluster volume status test-volume clients
  Brick : arch:/export/1
  Clients connected : 2
  Hostname          Bytes Read   BytesWritten
  --------          ---------    ------------
  127.0.0.1:1013    776          676
  127.0.0.1:1012    50440        51200
```

- Display the memory usage and memory pool details of the bricks using  the following command:

```
# gluster volume status test-volume mem
```

For example, to display the memory usage and memory pool details of  the bricks of test-volume:

```

  Memory status for volume : test-volume
  ----------------------------------------------
  Brick : arch:/export/1
  Mallinfo
  --------
  Arena    : 434176
  Ordblks  : 2
  Smblks   : 0
  Hblks    : 12
  Hblkhd   : 40861696
  Usmblks  : 0
  Fsmblks  : 0
  Uordblks : 332416
  Fordblks : 101760
  Keepcost : 100400

  Mempool Stats
  -------------
  Name                               HotCount ColdCount PaddedSizeof AllocCount MaxAlloc
  ----                               -------- --------- ------------ ---------- --------
  test-volume-server:fd_t                0     16384           92         57        5
  test-volume-server:dentry_t           59       965           84         59       59
  test-volume-server:inode_t            60       964          148         60       60
  test-volume-server:rpcsvc_request_t    0       525         6372        351        2
  glusterfs:struct saved_frame           0      4096          124          2        2
  glusterfs:struct rpc_req               0      4096         2236          2        2
  glusterfs:rpcsvc_request_t             1       524         6372          2        1
  glusterfs:call_stub_t                  0      1024         1220        288        1
  glusterfs:call_stack_t                 0      8192         2084        290        2
  glusterfs:call_frame_t                 0     16384          172       1728        6
```

- Display the inode tables of the volume using the following command:

```
# gluster volume status inode
```

For example, to display the inode tables of the test-volume:

```

  # gluster volume status test-volume inode
  inode tables for volume test-volume
  ----------------------------------------------
  Brick : arch:/export/1
  Active inodes:
  GFID                                            Lookups            Ref   IA type
  ----                                            -------            ---   -------
  6f3fe173-e07a-4209-abb6-484091d75499                  1              9         2
  370d35d7-657e-44dc-bac4-d6dd800ec3d3                  1              1         2

  LRU inodes:
  GFID                                            Lookups            Ref   IA type
  ----                                            -------            ---   -------
  80f98abe-cdcf-4c1d-b917-ae564cf55763                  1              0         1
  3a58973d-d549-4ea6-9977-9aa218f233de                  1              0         1
  2ce0197d-87a9-451b-9094-9baa38121155                  1              0         2
```

- Display the open fd tables of the volume using the following  command:

```
# gluster volume status fd
```

For example, to display the open fd tables of the test-volume:

```

  # gluster volume status test-volume fd

  FD tables for volume test-volume
  ----------------------------------------------
  Brick : arch:/export/1
  Connection 1:
  RefCount = 0  MaxFDs = 128  FirstFree = 4
  FD Entry            PID                 RefCount            Flags
  --------            ---                 --------            -----
  0                   26311               1                   2
  1                   26310               3                   2
  2                   26310               1                   2
  3                   26311               3                   2

  Connection 2:
  RefCount = 0  MaxFDs = 128  FirstFree = 0
  No open fds

  Connection 3:
  RefCount = 0  MaxFDs = 128  FirstFree = 0
  No open fds
```

- Display the pending calls of the volume using the following command:

```
# gluster volume status callpool
```

Each call has a call stack containing call frames.

For example, to display the pending calls of test-volume:

```

  # gluster volume status test-volume

  Pending calls for volume test-volume
  ----------------------------------------------
  Brick : arch:/export/1
  Pending calls: 2
  Call Stack1
   UID    : 0
   GID    : 0
   PID    : 26338
   Unique : 192138
   Frames : 7
   Frame 1
    Ref Count   = 1
    Translator  = test-volume-server
    Completed   = No
   Frame 2
    Ref Count   = 0
    Translator  = test-volume-posix
    Completed   = No
    Parent      = test-volume-access-control
    Wind From   = default_fsync
    Wind To     = FIRST_CHILD(this)->fops->fsync
   Frame 3
    Ref Count   = 1
    Translator  = test-volume-access-control
    Completed   = No
    Parent      = repl-locks
    Wind From   = default_fsync
    Wind To     = FIRST_CHILD(this)->fops->fsync
   Frame 4
    Ref Count   = 1
    Translator  = test-volume-locks
    Completed   = No
    Parent      = test-volume-io-threads
    Wind From   = iot_fsync_wrapper
    Wind To     = FIRST_CHILD (this)->fops->fsync
   Frame 5
    Ref Count   = 1
    Translator  = test-volume-io-threads
    Completed   = No
    Parent      = test-volume-marker
    Wind From   = default_fsync
    Wind To     = FIRST_CHILD(this)->fops->fsync
   Frame 6
    Ref Count   = 1
    Translator  = test-volume-marker
    Completed   = No
    Parent      = /export/1
    Wind From   = io_stats_fsync
    Wind To     = FIRST_CHILD(this)->fops->fsync
   Frame 7
    Ref Count   = 1
    Translator  = /export/1
    Completed   = No
    Parent      = test-volume-server
    Wind From   = server_fsync_resume
    Wind To     = bound_xl->fops->fsync
```

# SwiftOnFile

SwiftOnFile project enables GlusterFS volume to be used as backend for Openstack Swift - a distributed object store. This allows objects PUT over Swift's RESTful API to be accessed as files over filesystem interface and vice versa i.e files created over filesystem interface (NFS/FUSE/native) can be accessed as objects over Swift's RESTful API.

SwiftOnFile project was formerly known as `gluster-swift` and also as `UFO (Unified File and Object)` before that. More information about SwiftOnFile can be found [here](https://github.com/swiftonfile/swiftonfile/blob/master/doc/markdown/quick_start_guide.md). There are differences in working of gluster-swift (now obsolete) and swiftonfile projects. The older gluster-swift code and relevant documentation can be found in [icehouse branch](https://github.com/swiftonfile/swiftonfile/tree/icehouse) of swiftonfile repo.

## SwiftOnFile vs gluster-swift

| Gluster-Swift                                                | SwiftOnFile                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| One GlusterFS volume maps to and stores only one Swift account. Mountpoint Hierarchy: `container/object` | One GlusterFS volume or XFS partition can have multiple accounts. Mountpoint Hierarchy: `acc/container/object` |
| Over-rides account server, container server and  object server. We need to keep in sync with upstream Swift and often may need code changes or workarounds to support new Swift features | Implements only object-server. Very less need to  catch-up to Swift as new features at proxy,container and account level  would very likely be compatible with SwiftOnFile as it's just a storage  policy. |
| Does not use DBs for accounts and container.A  container listing involves a filesystem crawl.A HEAD on  account/container gives inaccurate or stale results without FS crawl. | Uses Swift's DBs to store account and container  information. An account or container listing does not involve FS crawl.  Accurate info on HEAD to account/container – ability to support account  quotas. |
| GET on a container and account lists actual files in filesystem. | GET on a container and account only lists objects PUT over Swift. Files created over filesystem interface do not appear in  container and object listings. |
| Standalone deployment required and does not integrate with existing Swift cluster. | Integrates with any existing Swift deployment as a Storage Policy. |

# Accessing GlusterFS using Cinder Hosts

*Note: GlusterFS driver was removed from Openstack since Ocata. This guide applies only to older Openstack releases.*

## 1. Introduction

GlusterFS and Cinder integration provides a system for data storage  that enables users to access the same data, both as an object and as a  file, thus simplifying management and controlling storage costs.

*GlusterFS* - GlusterFS is an open source, distributed file  system capable of scaling to several petabytes and handling thousands of clients. GlusterFS clusters together storage building blocks over  Infiniband RDMA or TCP/IP interconnect, aggregating disk and memory  resources and managing data in a single global namespace. GlusterFS is  based on a stackable user space design and can deliver exceptional  performance for diverse workloads.

*Cinder* - Cinder is the OpenStack service which is  responsible for handling persistent storage for virtual machines. This  is persistent block storage for the instances running in Nova. Snapshots can be taken for backing up and data, either for restoring data, or to  be used to create new block storage volumes.

With Enterprise Linux 6, configuring OpenStack Grizzly to use GlusterFS for its Cinder (block) storage is fairly simple.

These instructions have been tested with both GlusterFS 3.3 and  GlusterFS 3.4. Other releases may also work, but have not been tested.

## 2. Prerequisites

### GlusterFS

For information on prerequisites and instructions for installing GlusterFS, see http://www.gluster.org/community/documentation/index.php.

### Cinder

For information on prerequisites and instructions for installing Cinder, see http://docs.openstack.org/.

Before beginning, you must ensure there are **no existing volumes** in Cinder. Use "cinder delete" to remove any, and "cinder list" to  verify that they are deleted. If you do not delete the existing cinder  volumes, it will cause errors later in the process, breaking your Cinder installation.

**NOTE** - Unlike other software, the "openstack-config" and "cinder" commands generally require you to run them as a root user. Without prior configuration, running them through sudo generally does  not work. (This can be changed, but is beyond the scope of this HOW-TO.)

## 3 Installing GlusterFS Client on Cinder hosts

On each Cinder host, install the GlusterFS client packages:

```

sudo yum -y install glusterfs-fuse
```

## 4. Configuring Cinder to Add GlusterFS

On each Cinder host, run the following commands to add GlusterFS to the Cinder configuration:

```

openstack-config --set /etc/cinder/cinder.conf DEFAULT volume_driver cinder.volume.drivers.glusterfs.GlusterfsDriver
openstack-config --set /etc/cinder/cinder.conf DEFAULT glusterfs_shares_config /etc/cinder/shares.conf
openstack-config --set /etc/cinder/cinder.conf DEFAULT glusterfs_mount_point_base /var/lib/cinder/volumes
```

## 5. Creating GlusterFS Volume List

On each of the Cinder nodes, create a simple text file **/etc/cinder/shares.conf**.

This file is a simple list of the GlusterFS volumes to be used, one per line, using the following format:

```

GLUSTERHOST:VOLUME
GLUSTERHOST:NEXTVOLUME
GLUSTERHOST2:SOMEOTHERVOLUME
```

For example:

```

myglusterbox.example.org:myglustervol
```

## 6. Updating Firewall for GlusterFS

You must update the firewall rules on each Cinder node to communicate with the GlusterFS nodes.

The ports to open are explained in Step 3:

https://docs.gluster.org/en/latest/Install-Guide/Install/

If you are using iptables as your firewall, these lines can be added under **:OUTPUT ACCEPT** in the "*filter" section. You should probably adjust them to suit your  environment (eg. only accept connections from your GlusterFS servers).

```

-A INPUT -m state --state NEW -m tcp -p tcp --dport 111 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 24007 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 24008 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 24009 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 24010 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 24011 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 38465:38469 -j ACCEPT
```

Restart the firewall service:

```

sudo service iptables restart
```

## 7. Restarting Cinder Services

Configuration is complete and now you must restart the Cinder services to make it active.

```

for i in api scheduler volume; do sudo service openstack-cinder-${i} start; done
```

Check the Cinder volume log to make sure that there are no errors:

```

sudo tail -50 /var/log/cinder/volume.log
```

## 8. Verify GlusterFS Integration with Cinder

To verify if the installation and configuration is successful, create a Cinder volume then check using GlusterFS.

Create a Cinder volume:

```

cinder create --display_name myvol 10
```

Volume creation takes a few seconds. Once created, run the following command:

```

cinder list
```

The volume should be in "available" status. Now, look for a new file in the GlusterFS volume directory:

```

sudo ls -lah /var/lib/cinder/volumes/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/
```

(the `XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX` will be a number specific to your installation)

A newly created file should be inside that directory which is the new volume you just created. A new file will appear each time you create a  volume.

For example:

```console
$ sudo ls -lah /var/lib/cinder/volumes/29e55f0f3d56494ef1b1073ab927d425/
 
 total 4.0K
 drwxr-xr-x. 3 root   root     73 Apr  4 15:46 .
 drwxr-xr-x. 3 cinder cinder 4.0K Apr  3 09:31 ..
 -rw-rw-rw-. 1 root   root    10G Apr  4 15:46 volume-a4b97d2e-0f8e-45b2-9b94-b8fa36bd51b9
```

# GlusterFS Keystone Quickstart

This is a document in progress, and may contain some errors or missing information.

I am currently in the process of building an AWS Image with this  installed, however if you can't wait, and want to install this with a  script, here are the commands from both articles, with defaults  appropriate for an Amazon CentOS/RHEL 6 AMI, such as ami-a6e15bcf

This document assumes you already have GlusterFS with UFO installed, 3.3.1-11 or later, and are using the instructions here:

[`http://www.gluster.org/2012/09/howto-using-ufo-swift-a-quick-and-dirty-setup-guide/`](http://www.gluster.org/2012/09/howto-using-ufo-swift-a-quick-and-dirty-setup-guide/)

These docs are largely derived from:

[`http://fedoraproject.org/wiki/Getting_started_with_OpenStack_on_Fedora_17#Initial_Keystone_setup`](http://fedoraproject.org/wiki/Getting_started_with_OpenStack_on_Fedora_17#Initial_Keystone_setup)

Add the RDO Openstack Grizzly and Epel repos:

```

sudo yum install -y "http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm"

sudo yum install -y "http://rdo.fedorapeople.org/openstack/openstack-grizzly/rdo-release-grizzly-1.noarch.rpm"
```

Install Openstack-Keystone

```

sudo yum install openstack-keystone openstack-utils python-keystoneclient
```

Configure keystone

```

$ cat > keystonerc << _EOF
export ADMIN_TOKEN=$(openssl rand -hex 10)
export OS_USERNAME=admin
export OS_PASSWORD=$(openssl rand -hex 10)
export OS_TENANT_NAME=admin
export OS_AUTH_URL=`[`https://127.0.0.1:5000/v2.0/`](https://127.0.0.1:5000/v2.0/)
export SERVICE_ENDPOINT=`[`https://127.0.0.1:35357/v2.0/`](https://127.0.0.1:35357/v2.0/)
export SERVICE_TOKEN=\$ADMIN_TOKEN
_EOF

$ . ./keystonerc
$ sudo openstack-db --service keystone --init
```

Append the keystone configs to /etc/swift/proxy-server.conf

```

$ sudo -i

# cat >> /etc/swift/proxy-server.conf << _EOM
[filter:keystone]`
use = egg:swift#keystoneauth`
operator_roles = admin, swiftoperator`

[filter:authtoken]
paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory
auth_port = 35357
auth_host = 127.0.0.1
auth_protocol = https
_EOM

# exit
```

Finish configuring both swift and keystone using the command-line tool:

```

sudo openstack-config --set /etc/swift/proxy-server.conf filter:authtoken admin_token $ADMIN_TOKEN
sudo openstack-config --set /etc/swift/proxy-server.conf filter:authtoken auth_token $ADMIN_TOKEN
sudo openstack-config --set /etc/swift/proxy-server.conf DEFAULT log_name proxy_server
sudo openstack-config --set /etc/swift/proxy-server.conf filter:authtoken signing_dir /etc/swift
sudo openstack-config --set /etc/swift/proxy-server.conf pipeline:main pipeline "healthcheck cache authtoken keystone proxy-server"

sudo openstack-config --set /etc/keystone/keystone.conf DEFAULT admin_token $ADMIN_TOKEN
sudo openstack-config --set /etc/keystone/keystone.conf ssl enable True
sudo openstack-config --set /etc/keystone/keystone.conf ssl keyfile /etc/swift/cert.key
sudo openstack-config --set /etc/keystone/keystone.conf ssl certfile /etc/swift/cert.crt
sudo openstack-config --set /etc/keystone/keystone.conf signing token_format UUID
sudo openstack-config --set /etc/keystone/keystone.conf sql connection mysql://keystone:keystone@127.0.0.1/keystone
```

Configure keystone to start at boot and start it up.

```

sudo chkconfig openstack-keystone on
sudo service openstack-keystone start # If you script this, you'll want to wait a few seconds to start using it
```

We are using untrusted certs, so tell keystone not to complain. If  you replace with trusted certs, or are not using SSL, set this to "".

```

INSECURE="--insecure"
```

Create the keystone and swift services in keystone:

```

KS_SERVICEID=$(keystone $INSECURE service-create --name=keystone --type=identity --description="Keystone Identity Service" | grep " id " | cut -d "|" -f 3)

SW_SERVICEID=$(keystone $INSECURE service-create --name=swift --type=object-store --description="Swift Service" | grep " id " | cut -d "|" -f 3)

endpoint="`[`https://127.0.0.1:443`](https://127.0.0.1:443)`"

keystone $INSECURE endpoint-create --service_id $KS_SERVICEID \
  --publicurl $endpoint'/v2.0' --adminurl `[`https://127.0.0.1:35357/v2.0`](https://127.0.0.1:35357/v2.0)` \
  --internalurl `[`https://127.0.0.1:5000/v2.0`](https://127.0.0.1:5000/v2.0)

keystone $INSECURE endpoint-create --service_id $SW_SERVICEID \
  --publicurl $endpoint'/v1/AUTH_$(tenant_id)s' \
  --adminurl $endpoint'/v1/AUTH_$(tenant_id)s' \
  --internalurl $endpoint'/v1/AUTH_$(tenant_id)s'
```

Create the admin tenant:

```

admin_id=$(keystone $INSECURE tenant-create --name admin --description "Internal Admin Tenant" | grep id | awk '{print $4}')
```

Create the admin roles:

```

admin_role=$(keystone $INSECURE role-create --name admin | grep id | awk '{print $4}')
ksadmin_role=$(keystone $INSECURE role-create --name KeystoneServiceAdmin | grep id | awk '{print $4}')
kadmin_role=$(keystone $INSECURE role-create --name KeystoneAdmin | grep id | awk '{print $4}')
member_role=$(keystone $INSECURE role-create --name member | grep id | awk '{print $4}')
```

Create the admin user:

```

user_id=$(keystone $INSECURE user-create --name admin --tenant-id $admin_id --pass $OS_PASSWORD | grep id | awk '{print $4}')

keystone $INSECURE user-role-add --user-id $user_id --tenant-id $admin_id \
  --role-id $admin_role

keystone $INSECURE user-role-add --user-id $user_id --tenant-id $admin_id \
  --role-id $kadmin_role

keystone $INSECURE user-role-add --user-id $user_id --tenant-id $admin_id \
  --role-id $ksadmin_role
```

If you do not have multi-volume support (broken in 3.3.1-11), then  the volume names will not correlate to the tenants, and all tenants will map to the same volume, so just use a normal name. (This will be fixed  in 3.4, and should be fixed in 3.4 Beta. The bug report for this is  here: https://bugzilla.redhat.com/show_bug.cgi?id=924792)

```

volname="admin"

# or if you have the multi-volume patch
volname=$admin_id
```

Create and start the admin volume:

```

sudo gluster volume create $volname $myhostname:$pathtobrick
sudo gluster volume start $volname
sudo service openstack-keystone start
```

Create the ring for the admin tenant. If you have working  multi-volume support, then you can specify multiple volume names in the  call:

```

cd /etc/swift
sudo /usr/bin/gluster-swift-gen-builders $volname
sudo swift-init main restart
```

Create a testadmin user associated with the admin tenant with password testadmin and admin role:

```

user_id=$(keystone $INSECURE user-create --name testadmin --tenant-id $admin_id --pass testadmin | grep id | awk '{print $4}')

keystone $INSECURE user-role-add --user-id $user_id --tenant-id $admin_id \
  --role-id $admin_role
```

Test the user:

```

curl $INSECURE -d '{"auth":{"tenantName": "admin", "passwordCredentials":{"username": "testadmin", "password": "testadmin"}}}' -H "Content-type: application/json" "https://127.0.0.1:5000/v2.0/tokens"
```

See here for more examples:

http://docs.openstack.org/developer/keystone/api_curl_examples.html

# Gluster On ZFS

## Gluster On ZFS

This is a step-by-step set of instructions to install Gluster on top  of ZFS as the backing file store. There are some commands which were  specific to my installation, specifically, the ZFS tuning section. *Moniti estis.*

## Preparation

- Install CentOS 6.3
- Assumption is that your hostname is `gfs01`
- Run all commands as the root user
- yum update
- Disable IP Tables

```

chkconfig iptables off
service iptables stop
```

- Disable SELinux

```

1. edit `/etc/selinux/config`
2. set `SELINUX=disabled`
3. reboot
```

## Install ZFS on Linux

For RHEL6 or 7 and derivatives, you can install the ZFSoL repo (and EPEL) and use that to install ZFS

- RHEL 6:

```

yum localinstall --nogpgcheck https://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum localinstall --nogpgcheck http://archive.zfsonlinux.org/epel/zfs-release.el6.noarch.rpm
yum install kernel-devel zfs
```

- RHEL 7:

```

yum localinstall --nogpgcheck https://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm
yum localinstall --nogpgcheck http://archive.zfsonlinux.org/epel/zfs-release.el7.noarch.rpm
yum install kernel-devel zfs
```

and skip to [Finish ZFS Configuration](https://docs.gluster.org/en/latest/Administrator-Guide/Gluster-On-ZFS/#Finish ZFS Configuration) below.

Or you can roll your own if you want specific patches:

```

yum groupinstall "Development Tools"
```

- Download & unpack latest SPL and ZFS tarballs from [zfsonlinux.org](http://www.zfsonlinux.org)

### Install DKMS

We want automatically rebuild the kernel modules when we upgrade the kernel, so you definitely want DKMS with ZFS on Linux.

- Download latest RPM from http://linux.dell.com/dkms
- Install DKMS

```

rpm -Uvh dkms*.rpm
```

### Build & Install SPL

- Enter SPL source directory
- The following commands create two source & three binary RPMs.  Remove the static module RPM (we are using DKMS) and install the rest:

```

./configure
make rpm
rm spl-modules-0.6.0*.x86_64.rpm
rpm -Uvh spl*.x86_64.rpm spl*.noarch.rpm
```

### Build & Install ZFS

**Notice:** If you plan to use the `xattr=sa` filesystem option, make sure you have the ZFS fix for https://github.com/zfsonlinux/zfs/issues/1648 so your symlinks don't get corrupted. (applies to ZFSoL before 0.6.3, `xattr=sa` is safe to use on 0.6.3 and later)

- Enter ZFS source directory
- The following commands create two source & five binary RPMs.  Remove the static module RPM and install the rest. Note we have a few  preliminary packages to install before we can compile.

```

yum install zlib-devel libuuid-devel libblkid-devel libselinux-devel parted lsscsi
./configure
make rpm
rm zfs-modules-0.6.0*.x86_64.rpm
rpm -Uvh zfs*.x86_64.rpm zfs*.noarch.rpm
```

### Finish ZFS Configuration

- Reboot to allow all changes to take effect, if desired
- Create ZFS storage pool, in below examples it will be named `sp1`. This is a simple example of 4 HDDs in RAID10. NOTE: Check the latest [ZFS on Linux FAQ](http://zfsonlinux.org/faq.html) about configuring the `/etc/zfs/zdev.conf` file. You want to create mirrored devices across controllers to maximize performance. Make sure to run `udevadm trigger` after creating zdev.conf.

```

zpool create -f sp1 mirror A0 B0 mirror A1 B1
zpool status sp1
df -h
```

- You should see the `/sp1` mount point
- Enable ZFS compression to save disk space:

```
zfs set compression=on sp1
```

- you can also use `lz4` compression on later versions of  ZFS as it can be faster, especially for incompressible workloads. It is  safe to change this on the fly, as ZFS will compress new data with the  current setting:

```
zfs set compression=lz4 sp1
```

- Set ZFS tunables. This is specific to my environment.
- Set ARC cache min to 33% and max to 75% of installed RAM. Since this is a dedicated storage node, I can get away with this. In my case my  servers have 24G of RAM. More RAM is better with ZFS.
- We use SATA drives which do not accept command tagged queuing, therefore set the min and max pending requests to 1
- Disable read prefetch because it is almost completely useless and  does nothing in our environment but work the drives unnecessarily. I see < 10% prefetch cache hits, so it's really not required and actually  hurts performance.
- Set transaction group timeout to 5 seconds to prevent the volume  from appearing to freeze due to a large batch of writes. 5 seconds is  the default, but safe to force this.
- Ignore client flush/sync commands; let ZFS handle this with the  transaction group timeout flush. NOTE: Requires a UPS backup solution  unless you don't mind losing that 5 seconds worth of data.

```

echo "options zfs zfs_arc_min=8G zfs_arc_max=18G zfs_vdev_min_pending=1 zfs_vdev_max_pending=1 zfs_prefetch_disable=1 zfs_txg_timeout=5" > /etc/modprobe.d/zfs.conf
reboot
```

- Setting the `acltype` property to `posixacl` indicates Posix ACLs should be used.

```
zfs set acltype=posixacl sp1
```

## Install GlusterFS

```

wget -P /etc/yum.repos.d http://download.gluster.org/pub/gluster/glusterfs/LATEST/EPEL.repo/glusterfs-epel.repo
yum install glusterfs{-fuse,-server}
service glusterd start
service glusterd status
chkconfig glusterd on
```

- Continue with your GFS peer probe, volume creation, etc.
- To mount GFS volumes automatically after reboot, add these lines to `/etc/rc.local` (assuming your gluster volume is called `export` and your desired mount point is `/export`:

```

# Mount GFS Volumes
mount -t glusterfs gfs01:/export /export
```

## Miscellaneous Notes & TODO

### Daily e-mail status reports

Python script source; put your desired e-mail address in the `toAddr` variable. Add a crontab entry to run this daily.

```

#!/usr/bin/python
'''
Send e-mail to given user with zfs status
'''
import datetime
import socket
import smtplib
import subprocess


def doShellCmd(cmd):
    '''execute system shell command, return output as string'''
    subproc = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
    cmdOutput = subproc.communicate()[0]
    return cmdOutput

hostname = socket.gethostname()
statusLine = "Status of " + hostname + " at " + str(datetime.datetime.now())
zpoolList = doShellCmd('zpool list')
zpoolStatus = doShellCmd('zpool status')
zfsList = doShellCmd('zfs list')
report = (statusLine + "\n" +
    "-----------------------------------------------------------\n" +
    zfsList +
    "-----------------------------------------------------------\n" +
    zpoolList +
    "-----------------------------------------------------------\n" +
    zpoolStatus)

fromAddr = "From: root@" + hostname + "\r\n"
toAddr = "To: user@your.com\r\n"
subject = "Subject: ZFS Status from " + hostname + "\r\n"
msg = (subject + report)
server = smtplib.SMTP('localhost')
server.set_debuglevel(1)
server.sendmail(fromAddr, toAddr, msg)
server.quit()
```

### Restoring files from ZFS Snapshots

Show which node a file is on (for restoring files from ZFS snapshots):

```

 getfattr -n trusted.glusterfs.pathinfo <file>
```

### Recurring ZFS Snapshots

Since the community site will not let me actually post the script due to some random bug with Akismet spam blocking, I'll just post links  instead.

- [Recurring ZFS Snapshots](http://community.spiceworks.com/how_to/show/15303-recurring-zfs-snapshots)
- Or use https://github.com/zfsonlinux/zfs-auto-snapshot

# Configuring Bareos to store backups on Gluster

This description assumes that you already have a Gluster environment ready and configured. The examples use `storage.example.org` as a Round Robin DNS name that can be used to contact any of the available GlusterD processes. The Gluster Volume that is used, is called `backups`. Client systems would be able to access the volume by mounting it with FUSE like this:

```

mount -t glusterfs storage.example.org:/backups /mnt
```

[Bareos](http://bareos.org) contains a plugin for the Storage Daemon that uses `libgfapi`. This makes it possible for Bareos to access the Gluster Volumes without the need to have a FUSE mount available.

Here we will use one server that is dedicated for doing backups. This system is called `backup.example.org`. The Bareos Director is running on this host, together with the Bareos Storage Daemon. In the example, there is a File Daemon running on the same server. This makes it possible to backup the Bareos Director, which is useful as a backup of the Bareos database and configuration is kept that way.

# Bareos Installation

An absolute minimal Bareos installation needs a Bareos Director and a Storage Daemon. In order to backup a filesystem, a File Daemon needs to be available too. For the description in this document, CentOS-7 was used, with the following packages and versions:

- [glusterfs-3.7.4](http://download.gluster.org)
- [bareos-14.2](http://download.bareos.org) with bareos-storage-glusterfs

The Gluster Storage Servers do not need to have any Bareos packages installed. It is often better to keep applications (Bareos) and storage servers on different systems. So, when the Bareos repository has been configured, install the packages on the `backup.example.org` server:

```

yum install bareos-director bareos-database-sqlite3 \
                bareos-storage-glusterfs bareos-filedaemon \
                bareos-bconsole
```

To keep things as simple as possible, SQlite it used. For production deployments either MySQL or PostgrSQL is advised. It is needed to create the initial database:

```

sqlite3 /var/lib/bareos/bareos.db < /usr/lib/bareos/scripts/ddl/creates/sqlite3.sql
chown bareos:bareos /var/lib/bareos/bareos.db
```

The `bareos-bconsole` package is optional. `bconsole` is a terminal application that can be used to initiate backups, check the status of different Bareos components and the like. Testing the configuration with `bconsole` is relatively simple.

Once the packages are installed, you will need to start and enable the daemons:

```

systemctl start bareos­sd
systemctl start bareos­fd
systemctl start bareos­dir
systemctl enable bareos­sd
systemctl enable bareos­fd
systemctl enable bareos­dir
```

# Gluster Volume preparation

There are a few steps needed to allow Bareos to access the Gluster Volume. By default Gluster does not allow clients to connect from an unprivileged port. Because the Bareos Storage Daemon does not run as root, permissions to connect need to be opened up.

There are two processes involved when a client accesses a Gluster Volume. For the initial phase, GlusterD is contacted, when the client received the layout of the volume, the client will connect to the bricks directly. The changes to allow unprivileged processes to connect, are therefore twofold:

1. In `/etc/glusterfs/glusterd.vol` the option `rpc-auth-allow-insecure on`   needs to be added on all storage servers. After the modification of the   configuration file, the GlusterD process needs to be restarted with   `systemctl restart glusterd`.
2. The brick processes for the volume are configured through a volume option.   By executing `gluster volume set backups server.allow-insecure on` the   needed option gets set. Some versions of Gluster require a volume stop/start   before the option is taken into account, for these versions you will need to   execute `gluster volume stop backups` and `gluster volume start backups`.

Except for the network permissions, the Bareos Storage Daemon needs to be allowed to write to the filesystem provided by the Gluster Volume. This is achieved by setting normal UNIX permissions/ownership so that the right user/group can write to the volume:

```

mount -t glusterfs storage.example.org:/backups /mnt
mkdir /mnt/bareos
chown bareos:bareos /mnt/bareos
chmod ug=rwx /mnt/bareos
umount /mnt
```

Depending on how users/groups are maintained in the environment, the `bareos` user and group may not be available on the storage servers. If that is the case, the `chown` command above can be adapted to use the `uid` and `gid` of the `bareos` user and group from `backup.example.org`. On the Bareos server, the output would look similar to:

```console
# id bareos
uid=998(bareos) gid=997(bareos) groups=997(bareos),6(disk),30(tape)
```

And that makes the `chown` command look like this:

```

chown 998:997 /mnt/bareos
```

# Bareos Configuration

When `bareos-storage-glusterfs` got installed, an example configuration file has been added too. The `/etc/bareos/bareos-sd.d/device-gluster.conf` contains the `Archive Device` directive, which is a URL for the Gluster Volume and path where the backups should get stored. In our example, the entry should get set to:

```

Device {
    Name = GlusterStorage
    Archive Device = gluster://storage.example.org/backups/bareos
    Device Type = gfapi
    Media Type = GlusterFile
    ...
}
```

The default configuration of the Bareos provided jobs is to write backups to `/var/lib/bareos/storage`. In order to write all the backups to the Gluster Volume instead, the configuration for the Bareos Director needs to be modified. In the `/etc/bareos/bareos-dir.conf` configuration, the defaults for all jobs can be changed to use the `GlusterFile` storage:

```

JobDefs {
    Name = "DefaultJob"
    ...
  #   Storage = File
    Storage = GlusterFile
    ...
}
```

After changing the configuration files, the Bareos daemons need to apply them. The easiest to inform the processes of the changed configuration files is by instructing them to `reload` their configuration:

```console
# bconsole
Connecting to Director backup:9101
1000 OK: backup-dir Version: 14.2.2 (12 December 2014)
Enter a period to cancel a command.
*reload
```

With `bconsole` it is also possible to check if the configuration has been applied. The `status` command can be used to show the URL of the storage that is configured. When all is setup correctly, the result looks like this:

```console
*status storage=GlusterFile
Connecting to Storage daemon GlusterFile at backup:9103
...
open.
...
```

# Create your first backup

There are several default jobs configured in the Bareos Director. One of them is the `DefaultJob` which was modified in an earlier step. This job uses the `SelfTest` FileSet, which backups `/usr/sbin`. Running this job will verify if the configuration is working correctly. Additional jobs, other FileSets and more File Daemons (clients that get backed up) can be added later.

```text
*run
A job name must be specified.
The defined Job resources are:
        1: BackupClient1
        2: BackupCatalog
        3: RestoreFiles
Select Job resource (1-3): 1
Run Backup job
JobName:  BackupClient1
Level:    Incremental
Client:   backup-fd
...
OK to run? (yes/mod/no): yes
Job queued. JobId=1
```

The job will need a few seconds to complete, the `status` command can be used to show the progress. Once done, the `messages` command will display the result:

```text
*messages
...
    JobId:                  1
    Job:                    BackupClient1.2015-09-30_21.17.56_12
    ...
    Termination:            Backup OK
```

The archive that contains the backup will be located on the Gluster Volume. To check if the file is available, mount the volume on a storage server:

```

mount -t glusterfs storage.example.org:/backups /mnt
ls /mnt/bareos
```

# Further Reading

This document intends to provide a quick start of configuring Bareos to use Gluster as a storage backend. Bareos can be configured to create backups of different clients (which run a File Daemon), run jobs at scheduled time and intervals and much more. The excellent [Bareos documentation](http://doc.bareos.org) can be consulted to find out how to create backups in a much more useful way than can get expressed on this page.

# Setting up GlusterFS with SSL/TLS

GlusterFS allows its communication to be secured using the [Transport Layer Security](http://tools.ietf.org/html/rfc5246) standard (which supersedes Secure Sockets Layer), using the [OpenSSL](https://www.openssl.org/) library. Setting this up requires a basic working knowledge of some SSL/TLS concepts, which can only be briefly summarized here.

- "Authentication" is the process of one entity (e.g. a machine, process, or  person) proving its identity to a second entity.
- "Authorization" is the process of checking whether an entity has permission  to perform an action.
- TLS provides authentication and encryption. It does not provide  authorization, though GlusterFS can use TLS-authenticated identities to  authorize client connections to bricks/volumes.
- An entity X which must authenticate to a second entity Y does so by sharing  with Y a *certificate*, which contains information sufficient to prove X's  identity. X's proof of identity also requires possession of a *private key*  which matches its certificate, but this key is never seen by Y or anyone  else. Because the certificate is already public, anyone who has the key can  claim that identity.
- Each certificate contains the identity of its principal (owner) along with  the identity of a *certifying authority* or CA who can verify the integrity  of the certificate's contents. The principal and CA can be the same (a  "self-signed certificate"). If they are different, the CA must *sign* the  certificate by appending information derived from both the certificate  contents and the CA's own private key.
- Certificate-signing relationships can extend through multiple levels. For  example, a company X could sign another company Y's certificate, which could  then be used to sign a third certificate Z for a specific user or purpose.  Anyone who trusts X (and is willing to extend that trust through a  *certificate depth* of two or more) would therefore be able to authenticate  Y and Z as well.
- Any entity willing to accept other entities' authentication attempts must  have some sort of database seeded with the certificates that already accept.

In GlusterFS's case, a client or server X uses the following files to contain TLS-related information:

- /etc/ssl/glusterfs.pem X's own certificate
- /etc/ssl/glusterfs.key X's private key
- /etc/ssl/glusterfs.ca concatenation of *others'* certificates

GlusterFS always performs *mutual authentication*, though clients do not currently do anything with the authenticated server identity. Thus, if client X wants to communicate with server Y, then X's certificate (or that of a signer) must be in Y's CA file, and vice versa.

For all uses of TLS in GlusterFS, if one side of a connection is configured to use TLS then the other side must use it as well. There is no automatic fallback to non-TLS communication, or allowance for concurrent TLS and non-TLS access to the same resource, because either would be insecure. Instead, any such "mixed mode" connections will be rejected by the TLS-using side, sacrificing availability to maintain security.

**NOTE**The TLS certificate verification will fail if the machines' date and time are not in sync with each other. Certificate verification depends on the time of the client as well as the server and if that is not found to be in sync then it is deemed to be an invalid certificate. To get the date and times in sync, tools such as ntpdate can be used.

## Using Certmonger and FreeIPA to generate and manage certs

Certmonger can be used to generate keys, request certs from a CA and then automatically keep the Gluster certificate and the CA bundle updated as required, simplifying deployment. Either a commercial CA or a local CA can be used. E.g., FreeIPA (with dogtag CA) is an open-source CA with user-friendly tooling.

If using FreeIPA, first add the host. This is required for FreeIPA to issue certificates. This can be done via the web UI, or the CLI with:

```

ipa host-add <hostname>
```

If the host has been added the following should show the host:

```

ipa host-show <hostname>
```

And it should show a kerberos principal for the host in the form of:

```

host/<hostname>
```

Now use certmonger on the gluster server or client to generate the key (if required), and submit a CSR to the CA. Certmonger will monitor the request, and create and update the files as required. For FreeIPA we need to specify the Kerberos principal from above to -K. E.g.:

```

 getcert request -r  \
    -K host/$(hostname)  \
    -f /etc/ssl/gluster.pem \
    -k /etc/ssl/gluster.key \
    -D $(hostname)  \
    -F /etc/ssl/gluster.ca
```

Certmonger should print out an ID for the request, e.g.:

```

New signing request "20210801190305" added.
```

You can check the status of the request with this ID:

```

getcert list -i 20210801190147
```

If the CA approves the CSR and issues the cert, then the previous command should print a status field with:

```

status: MONITORING
```

As this point, the key, the cert and the CA bundle should all be in /etc/ssl ready for Gluster to use. Certmonger will renew the certificates as required for you.

You do not need to manually concatenate certs to a trusted cert bundle and distribute them to all servers.

You may need to set the certificate depth to allow the CA signed certs to be used, if there are intermediate CAs in the signing path. E.g., on every server and client:

```

echo "option transport.socket.ssl-cert-depth 3" >  /var/lib/glusterd/secure-access
```

This should not be necessary where a local CA (e.g., FreeIPA) has directly signed the cart.

## Enabling TLS on the I/O Path

To enable authentication and encryption between clients and brick servers, two options must be set:

```

gluster volume set MYVOLUME client.ssl on
gluster volume set MYVOLUME server.ssl on
```

> **Note** that the above options affect only the GlusterFS native protocol. For foreign protocols such as NFS, SMB, or Swift the encryption will not be affected between:
>
> 1. NFS client and Glusterfs NFS Ganesha Server
> 2. SMB client and Glusterfs SMB server
>
> While it affects the encryption between the following:
>
> 1. NFS Ganesha server and Glusterfs bricks
> 2. Glusterfs SMB server and Glusterfs bricks

## Using TLS Identities for Authorization

Once TLS has been enabled on the I/O path, TLS identities can be used instead of IP addresses or plain usernames to control access to specific volumes. For example:

```

gluster volume set MYVOLUME auth.ssl-allow Zaphod
```

Here, we're allowing the TLS-authenticated identity "Zaphod" to access MYVOLUME. This is intentionally identical to the existing "auth.allow" option, except that the name is taken from a TLS certificate instead of a command-line string. Note that infelicities in the gluster CLI preclude using names that include spaces, which would otherwise be allowed.

## Enabling TLS on the Management Path

Management-daemon traffic is not controlled by an option. Instead, it is controlled by the presence of a file on each machine:

```

/var/lib/glusterd/secure-access
```

Creating this file will cause glusterd connections made from that machine to use TLS. Note that even clients must do this to communicate with a remote glusterd while mounting, but not thereafter.

## Additional Options

The GlusterFS TLS implementation supports two additional options related to TLS internals.

The first option allows the user to set the certificate depth, as mentioned above.

```

gluster volume set MYVOLUME ssl.certificate-depth 2
```

Here, we're setting our certificate depth to two, as in the introductory example. By default this value is zero, meaning that only certificates which are directly specified in the local CA file will be accepted (i.e. no signed certificates at all).

The second option allows the user to specify the set of allowed TLS ciphers.

```

gluster volume set MYVOLUME ssl.cipher-list 'HIGH:!SSLv2'
```

Cipher lists are negotiated between the two parties to a TLS connection so that both sides' security needs are satisfied. In this example, we're setting the initial cipher list to HIGH, representing ciphers that the cryptography community still believes to be unbroken. We are also explicitly disallowing ciphers specific to SSL version 2. The default is based on this example but also excludes CBC-based cipher modes to provide extra mitigation against the [POODLE](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2014-3566) attack.

# Puppet-Gluster

## A GlusterFS Puppet module by [James](https://ttboj.wordpress.com/)

#### Available from:

#### https://github.com/purpleidea/puppet-gluster/

#### Table of Contents

1. [Overview](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#overview)
2. [Module description - What the module does](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#module-description)
3. Setup - Getting started with Puppet-Gluster
   - [What can Puppet-Gluster manage?](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#what-can-puppet-gluster-manage)
   - [Simple setup](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#simple-setup)
   - [Elastic setup](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#elastic-setup)
   - [Advanced setup](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#advanced-setup)
4. [Usage/FAQ - Notes on management and frequently asked questions](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#usage-and-frequently-asked-questions)
5. Reference - Class and type reference
   - [gluster::simple](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#glustersimple)
   - [gluster::elastic](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#glusterelastic)
   - [gluster::server](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#glusterserver)
   - [gluster::host](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#glusterhost)
   - [gluster::brick](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#glusterbrick)
   - [gluster::volume](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#glustervolume)
   - [gluster::volume::property](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#glustervolumeproperty)
6. [Examples - Example configurations](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#examples)
7. [Limitations - Puppet versions, OS compatibility, etc...](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#limitations)
8. [Development - Background on module development](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#development)
9. [Author - Author and contact information](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#author)

## Overview

The Puppet-Gluster module installs, configures, and manages a GlusterFS cluster.

## Module Description

This Puppet-Gluster module handles installation, configuration, and management of GlusterFS across all of the hosts in the cluster.

## Setup

### What can Puppet-Gluster manage?

Puppet-Gluster is designed to be able to manage as much or as little of your GlusterFS cluster as you wish. All features are optional. If there is a feature that doesn't appear to be optional, and you believe it should be, please let me know. Having said that, it makes good sense to me to have Puppet-Gluster manage as much of your GlusterFS infrastructure as it can. At the moment, it cannot rack new servers, but I am accepting funding to explore this feature ;) At the moment it can manage:

- GlusterFS packages (rpm)
- GlusterFS configuration files (/var/lib/glusterd/)
- GlusterFS host peering (gluster peer probe)
- GlusterFS storage partitioning (fdisk)
- GlusterFS storage formatting (mkfs)
- GlusterFS brick creation (mkdir)
- GlusterFS services (glusterd)
- GlusterFS firewalling (whitelisting)
- GlusterFS volume creation (gluster volume create)
- GlusterFS volume state (started/stopped)
- GlusterFS volume properties (gluster volume set)
- And much more...

### Simple setup

include '::gluster::simple' is enough to get you up and running. When using the gluster::simple class, or with any other Puppet-Gluster configuration, identical definitions must be used on all hosts in the cluster. The simplest way to accomplish this is with a single shared puppet host definition like:

```

node /^annex\d+$/ {        # annex{1,2,..N}
        class { '::gluster::simple':
        }
}
```

If you wish to pass in different parameters, you can specify them in the class before you provision your hosts:

```

class { '::gluster::simple':
    replica => 2,
    volume => ['volume1', 'volume2', 'volumeN'],
}
```

### Elastic setup

The gluster::elastic class is not yet available. Stay tuned!

### Advanced setup

Some system administrators may wish to manually itemize each of the required components for the Puppet-Gluster deployment. This happens automatically with the higher level modules, but may still be a desirable feature, particularly for non-elastic storage pools where the configuration isn't expected to change very often (if ever).

To put together your cluster piece by piece, you must manually include and define each class and type that you wish to use. If there are certain aspects that you wish to manage yourself, you can omit them from your configuration. See the [reference](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#reference) section below for the specifics. Here is one possible example:

```

class { '::gluster::server':
    shorewall => true,
}

gluster::host { 'annex1.example.com':
    # use uuidgen to make these
    uuid => '1f660ca2-2c78-4aa0-8f4d-21608218c69c',
}

# note that this is using a folder on your existing file system...
# this can be useful for prototyping gluster using virtual machines
# if this isn't a separate partition, remember that your root fs will
# run out of space when your gluster volume does!
gluster::brick { 'annex1.example.com:/data/gluster-storage1':
    areyousure => true,
}

gluster::host { 'annex2.example.com':
    # NOTE: specifying a host uuid is now optional!
    # if you don't choose one, one will be assigned
    #uuid => '2fbe6e2f-f6bc-4c2d-a301-62fa90c459f8',
}

gluster::brick { 'annex2.example.com:/data/gluster-storage2':
    areyousure => true,
}

$brick_list = [
    'annex1.example.com:/data/gluster-storage1',
    'annex2.example.com:/data/gluster-storage2',
]

gluster::volume { 'examplevol':
    replica => 2,
    bricks => $brick_list,
    start => undef, # i'll start this myself
}

# namevar must be: <VOLNAME>#<KEY>
gluster::volume::property { 'examplevol#auth.reject':
    value => ['192.0.2.13', '198.51.100.42', '203.0.113.69'],
}
```

## Usage and frequently asked questions

All management should be done by manipulating the arguments on the appropriate Puppet-Gluster classes and types. Since certain manipulations are either not yet possible with Puppet-Gluster, or are not supported by GlusterFS, attempting to manipulate the Puppet configuration in an unsupported way will result in undefined behaviour, and possible even data loss, however this is unlikely.

### How do I change the replica count?

You must set this before volume creation. This is a limitation of GlusterFS. There are certain situations where you can change the replica count by adding a multiple of the existing brick count to get this desired effect. These cases are not yet supported by Puppet-Gluster. If you want to use Puppet-Gluster before and / or after this transition, you can do so, but you'll have to do the changes manually.

### Do I need to use a virtual IP?

Using a virtual IP (VIP) is strongly recommended as a distributed lock manager (DLM) and also to provide a highly-available (HA) IP address for your clients to connect to. For a more detailed explanation of the reasoning please see:

https://ttboj.wordpress.com/2012/08/23/how-to-avoid-cluster-race-conditions-or-how-to-implement-a-distributed-lock-manager-in-puppet/

Remember that even if you're using a hosted solution (such as AWS) that doesn't provide an additional IP address, or you want to avoid using an additional IP, and you're okay not having full HA client mounting, you can use an unused private RFC1918 IP address as the DLM VIP. Remember that a layer 3 IP can co-exist on the same layer 2 network with the layer 3 network that is used by your cluster.

### Is it possible to have Puppet-Gluster complete in a single run?

No. This is a limitation of Puppet, and is related to how GlusterFS operates. For example, it is not reliably possible to predict which ports a particular GlusterFS volume will run on until after the volume is started. As a result, this module will initially whitelist connections from GlusterFS host IP addresses, and then further restrict this to only allow individual ports once this information is known. This is possible in conjunction with the [puppet-shorewall](https://github.com/purpleidea/puppet-shorewall) module. You should notice that each run should complete without error. If you do see an error, it means that either something is wrong with your system and / or configuration, or because there is a bug in Puppet-Gluster.

### Can you integrate this with vagrant?

Not until vagrant properly supports libvirt/KVM. I have no desire to use VirtualBox for fun.

### Awesome work, but it's missing support for a feature and/or platform!

Since this is an Open Source / Free Software project that I also give away for free (as in beer, free as in gratis, free as in libre), I'm unable to provide unlimited support. Please consider donating funds, hardware, virtual machines, and other resources. For specific needs, you could perhaps sponsor a feature!

### You didn't answer my question, or I have a question!

Contact me through my [technical blog](https://ttboj.wordpress.com/contact/) and I'll do my best to help. If you have a good question, please remind me to add my answer to this documentation!

## Reference

Please note that there are a number of undocumented options. For more information on these options, please view the source at: https://github.com/purpleidea/puppet-gluster/. If you feel that a well used option needs documenting here, please contact me.

### Overview of classes and types

- [gluster::simple](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#glustersimple): Simple Puppet-Gluster deployment.
- [gluster::elastic](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#glusterelastic): Under construction.
- [gluster::server](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#glusterserver): Base class for server hosts.
- [gluster::host](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#glusterhost): Host type for each participating host.
- [gluster::brick](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#glusterbrick): Brick type for each defined brick, per host.
- [gluster::volume](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#glustervolume): Volume type for each defined volume.
- [gluster::volume::property](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#glustervolumeproperty): Manages properties for each volume.

### gluster::simple

This is gluster::simple. It should probably take care of 80% of all use cases. It is particularly useful for deploying quick test clusters. It uses a finite-state machine (FSM) to decide when the cluster has settled and volume creation can begin. For more information on the FSM in Puppet-Gluster see: https://ttboj.wordpress.com/2013/09/28/finite-state-machines-in-puppet/

#### replica

The replica count. Can't be changed automatically after initial deployment.

#### volume

The volume name or list of volume names to create.

#### path

The valid brick path for each host. Defaults to local file system. If you need a different path per host, then Gluster::Simple will not meet your needs.

#### vip

The virtual IP address to be used for the cluster distributed lock manager.

#### shorewall

Boolean to specify whether puppet-shorewall integration should be used or not.

### gluster::elastic

Under construction.

### gluster::server

Main server class for the cluster. Must be included when building the GlusterFS cluster manually. Wrapper classes such as [gluster::simple](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#glustersimple) include this automatically.

#### vip

The virtual IP address to be used for the cluster distributed lock manager.

#### shorewall

Boolean to specify whether puppet-shorewall integration should be used or not.

### gluster::host

Main host type for the cluster. Each host participating in the GlusterFS cluster must define this type on itself, and on every other host. As a result, this is not a singleton like the [gluster::server](https://docs.gluster.org/en/latest/Administrator-Guide/Puppet/#glusterserver) class.

#### ip

Specify which IP address this host is using. This defaults to the *$::ipaddress* variable. Be sure to set this manually if you're declaring this yourself on each host without using exported resources. If each host thinks the other hosts should have the same IP address as itself, then Puppet-Gluster and GlusterFS won't work correctly.

#### uuid

Universally unique identifier (UUID) for the host. If empty, Puppet-Gluster will generate this automatically for the host. You can generate your own manually with *uuidgen*, and set them yourself. I found this particularly useful for testing, because I would pick easy to recognize UUID's like: *aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa*, *bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb*, and so on. If you set a UUID manually, and Puppet-Gluster has a chance to run, then it will remember your choice, and store it locally to be used again if you no longer specify the UUID. This is particularly useful for upgrading an existing un-managed GlusterFS installation to a Puppet-Gluster managed one, without changing any UUID's.

### gluster::brick

Main brick type for the cluster. Each brick is an individual storage segment to be used on a host. Each host must have at least one brick to participate in the cluster, but usually a host will have multiple bricks. A brick can be as simple as a file system folder, or it can be a separate file system. Please read the official GlusterFS documentation, if you aren't entirely comfortable with the concept of a brick.

For most test clusters, and for experimentation, it is easiest to use a directory on the root file system. You can even use a */tmp* sub folder if you don't care about the persistence of your data. For more serious clusters, you might want to create separate file systems for your data. On self-hosted iron, it is not uncommon to create multiple RAID-6 drive pools, and to then create a separate file system per virtual drive. Each file system can then be used as a single brick.

So that each volume in GlusterFS has the maximum ability to grow, without having to partition storage separately, the bricks in Puppet-Gluster are actually folders (on whatever backing store you wish) which then contain sub folders-- one for each volume. As a result, all the volumes on a given GlusterFS cluster can share the total available storage space. If you wish to limit the storage used by each volume, you can setup quotas. Alternatively, you can buy more hardware, and elastically grow your GlusterFS volumes, since the price per GB will be significantly less than any proprietary storage system. The one downside to this brick sharing, is that if you have chosen the brick per host count specifically to match your performance requirements, and each GlusterFS volume on the same cluster has drastically different brick per host performance requirements, then this won't suit your needs. I doubt that anyone actually has such requirements, but if you do insist on needing this compartmentalization, then you can probably use the Puppet-Gluster grouping feature to accomplish this goal. Please let me know about your use-case, and be warned that the grouping feature hasn't been extensively tested.

To prove to you that I care about automation, this type offers the ability to automatically partition and format your file systems. This means you can plug in new iron, boot, provision and configure the entire system automatically. Regrettably, I don't have a lot of test hardware to routinely use this feature. If you'd like to donate some, I'd be happy to test this thoroughly. Having said that, I have used this feature, I consider it to be extremely safe, and it has never caused me to lose data. If you're uncertain, feel free to look at the code, or avoid using this feature entirely. If you think there's a way to make it even safer, then feel free to let me know.

#### dev

Block device, such as */dev/sdc* or */dev/disk/by-id/scsi-0123456789abcdef*. By default, Puppet-Gluster will assume you're using a folder to store the brick data, if you don't specify this parameter.

#### fsuuid

File system UUID. This ensures we can distinctly identify a file system. You can set this to be used with automatic file system creation, or you can specify the file system UUID that you'd like to use.

#### labeltype

Only *gpt* is supported. Other options include *msdos*, but this has never been used because of it's size limitations.

#### fstype

This should be *xfs* or *ext4*. Using *xfs* is recommended, but *ext4* is also quite common. This only affects a file system that is getting created by this module. If you provision a new machine, with a root file system of *ext4*, and the brick you create is a root file system path, then this option does nothing.

#### xfs_inode64

Set *inode64* mount option when using the *xfs* fstype. Choose *true* to set.

#### xfs_nobarrier

Set *nobarrier* mount option when using the *xfs* fstype. Choose *true* to set.

#### ro

Whether the file system should be mounted read only. For emergencies only.

#### force

If *true*, this will overwrite any xfs file system it sees. This is useful for rebuilding GlusterFS repeatedly and wiping data. There are other safeties in place to stop this. In general, you probably don't ever want to touch this.

#### areyousure

Do you want to allow Puppet-Gluster to do dangerous things? You have to set this to *true* to allow Puppet-Gluster to *fdisk* and *mkfs* your file system.

### gluster::volume

Main volume type for the cluster. This is where a lot of the magic happens. Remember that changing some of these parameters after the volume has been created won't work, and you'll experience undefined behaviour. There could be FSM based error checking to verify that no changes occur, but it has been left out so that this code base can eventually support such changes, and so that the user can manually change a parameter if they know that it is safe to do so.

#### bricks

List of bricks to use for this volume. If this is left at the default value of *true*, then this list is built automatically. The algorithm that determines this order does not support all possible situations, and most likely can't handle certain corner cases. It is possible to examine the FSM to view the selected brick order before it has a chance to create the volume. The volume creation script won't run until there is a stable brick list as seen by the FSM running on the host that has the DLM. If you specify this list of bricks manually, you must choose the order to match your desired volume layout. If you aren't sure about how to order the bricks, you should review the GlusterFS documentation first.

#### transport

Only *tcp* is supported. Possible values can include *rdma*, but this won't get any testing if I don't have access to infiniband hardware. Donations welcome.

#### replica

Replica count. Usually you'll want to set this to *2*. Some users choose *3*. Other values are seldom seen. A value of *1* can be used for simply testing a distributed setup, when you don't care about your data or high availability. A value greater than *4* is probably wasteful and unnecessary. It might even cause performance issues if a synchronous write is waiting on a slow fourth server.

#### stripe

Stripe count. Thoroughly unsupported and untested option. Not recommended for use by GlusterFS.

#### ping

Do we want to include ping checks with *fping*?

#### settle

Do we want to run settle checks?

#### start

Requested state for the volume. Valid values include: *true* (start), *false* (stop), or *undef* (un-managed start/stop state).

### gluster::volume::property

Main volume property type for the cluster. This allows you to manage GlusterFS volume specific properties. There are a wide range of properties that volumes support. For the full list of properties, you should consult the GlusterFS documentation, or run the *gluster volume set help* command. To set a property you must use the special name pattern of: *volume*#*key*. The value argument is used to set the associated value. It is smart enough to accept values in the most logical format for that specific property. Some properties aren't yet supported, so please report any problems you have with this functionality. Because this feature is an awesome way to *document as code* the volume specific optimizations that you've made, make sure you use this feature even if you don't use all the others.

#### value

The value to be used for this volume property.

## Examples

For example configurations, please consult the [examples/](https://github.com/purpleidea/puppet-gluster/tree/master/examples) directory in the git source repository. It is available from:

https://github.com/purpleidea/puppet-gluster/tree/master/examples

## Limitations

This module has been tested against open source Puppet 3.2.4 and higher.

The module has been tested on:

- CentOS 6.4

It will probably work without incident or without major modification on:

- CentOS 5.x/6.x
- RHEL 5.x/6.x

It will most likely work with other Puppet versions and on other platforms, but testing under other conditions has been light due to lack of resources. It will most likely not work on Debian/Ubuntu systems without modification. I would really love to add support for these operating systems, but I do not have any test resources to do so. Please sponsor this if you'd like to see it happen.

## Development

This is my personal project that I work on in my free time. Donations of funding, hardware, virtual machines, and other resources are appreciated. Please contact me if you'd like to sponsor a feature, invite me to talk/teach or for consulting.

You can follow along [on my technical blog](https://ttboj.wordpress.com/).

## Author

Copyright (C) 2010-2013+ James Shubin

- [github](https://github.com/purpleidea/)
- [@purpleidea](https://twitter.com/#!/purpleidea)
- https://ttboj.wordpress.com/

# NOTE: FEATURE DEPRECATED

THE RDMA is no longer supported in Gluster builds. This has been removed from release 8 onwards.

Currently we dont have

1. The expertise to support RDMA
2. Infrastructure to test/verify the performances each release   The options are getting discussed here - https://github.com/gluster/glusterfs/issues/2000

Ready to enable as a compile time option, if there is proper support and testing infrastructure.

# Introduction

GlusterFS supports using RDMA protocol for communication between  glusterfs clients and glusterfs bricks. GlusterFS clients include FUSE client, libgfapi clients(Samba and  NFS-Ganesha included), gNFS server and other glusterfs processes that  communicate with bricks like self-heal daemon, quotad, rebalance process etc.

NOTE: As of now only FUSE client and gNFS server would support RDMA transport.

NOTE:
 NFS client to gNFS Server/NFS Ganesha Server communication would still happen over tcp.
 CIFS Clients/Windows Clients to Samba Server communication would still happen over tcp.

# Setup

Please refer to these external documentation to setup RDMA on your machines
 http://people.redhat.com/dledford/infiniband_get_started.html

## Creating Trusted Storage Pool

All the servers in the Trusted Storage Pool must have RDMA devices if either RDMA or TCP,RDMA volumes are created in the storage pool.
 The peer probe must be performed using IP/hostname assigned to the RDMA device.

## Ports and Firewall

Process glusterd will listen on both tcp and rdma if rdma device is  found. Port used for rdma is 24008. Similarly, brick processes will also listen on two ports for a volume created with transport "tcp,rdma".

Make sure you update the firewall to accept packets on these ports.

# Gluster Volume Create

A volume can support one or more transport types for communication  between clients and brick processes. There are three types of supported  transport, which are, tcp, rdma, and tcp,rdma.

Example: To create a distributed volume with four storage servers over InfiniBand:

`# gluster volume create test-volume transport rdma server1:/exp1 server2:/exp2 server3:/exp3 server4:/exp4`
 Creation of test-volume has been successful
 Please start the volume to access data.

# Changing Transport of Volume

To change the supported transport types of a existing volume, follow the procedure:
 NOTE: This is possible only if the volume was created with IP/hostname assigned to RDMA device.

1. Unmount the volume on all the clients using the following command:

   ```
   
   ```

```
umount mount-point
```

Stop the volumes using the following command:

```

gluster volume stop volname
```

Change the transport type.
    For example, to enable both tcp and rdma execute the followimg command:

```

gluster volume set volname config.transport tcp,rdma
```

Mount the volume on all the clients.
    For example, to mount using rdma transport, use the following command:

```

```

1. ```
   mount -t glusterfs -o transport=rdma server1:/test-volume /mnt/glusterfs`
   ```

NOTE:
 config.transport option does not have a entry in help of gluster cli.

```

gluster vol set help | grep config.transport`
```

However, the key is a valid one.

# Mounting a Volume using RDMA

You can use the mount option "transport" to specify the transport  type that FUSE client must use to communicate with bricks. If the volume was created with only one transport type, then that becomes the default when no value is specified. In case of tcp,rdma volume, tcp is the  default.

For example, to mount using rdma transport, use the following command:

```

mount -t glusterfs -o transport=rdma server1:/test-volume /mnt/glusterfs
```

# Transport used by auxillary processes

All the auxillary processes like self-heal daemon, rebalance process  etc use the default transport.In case you have a tcp,rdma volume it will use tcp.
 In case of rdma volume, rdma will be used.
 Configuration options to select transport used by these processes when  volume is tcp,rdma are not yet available and will be coming in later  releases.

# GlusterFS iSCSI

## Introduction

iSCSI on Gluster can be set up using the Linux Target driver. This is a user space daemon that accepts iSCSI (as well as iSER and FCoE.) It  interprets iSCSI CDBs and converts them into some other I/O operation,  according to user configuration. In our case, we can convert the CDBs  into file operations that run against a gluster file. The file  represents the LUN and the offset in the file the LBA.

A plug-in for the Linux target driver has been written to use the  libgfapi. It is part of the Linux target driver (bs_glfs.c). Using it,  the datapath skips FUSE. This document will be updated to describe how  to use it. You can see README.glfs in the Linux target driver's  documentation subdirectory.

LIO is a replacement for the Linux Target Driver that is included in  RHEL7. A user-space plug-in mechanism for it is under development. Once  that piece of code exists a similar mechanism can be built for gluster  as was done for the Linux target driver.

Below is a cookbook to set it up using the Linux Target Driver on the server. This has been tested on XEN and KVM instances within RHEL6,  RHEL7, and Fedora 19 instances. In this setup a single path leads to  gluster, which represents a performance bottleneck and single point of  failure. For HA and load balancing, it is possible to setup two or more  paths to different gluster servers using mpio; if the target name is  equivalent over each path, mpio will coalless both paths into a single  device.

For more information on iSCSI and the Linux target driver, see [1] and [2].

## Setup

Mount gluster locally on your gluster server. Note you can also run  it on the gluster client. There are pros and cons to these  configurations, described [below](https://docs.gluster.org/en/latest/Administrator-Guide/GlusterFS-iSCSI/#Running_the_target_on_the_gluster_client).

```

mount -t glusterfs 127.0.0.1:gserver /mnt
```

Create a large file representing your block device within the gluster fs. In this case, the lun is 2G. (*You could also create a gluster "block device" for this purpose, which would skip the file system*).

```

dd if=/dev/zero of=disk3 bs=2G count=25
```

Create a target using the file as the backend storage.

If necessary, download the Linux SCSI target. Then start the service.

```

yum install scsi-target-utils
service tgtd start
```

You must give an iSCSI Qualified name (IQN), in the format : iqn.yyyy-mm.reversed.domain.name:OptionalIdentifierText

where:

yyyy-mm represents the 4-digit year and 2-digit month the device was started (for example: 2011-07)

```

tgtadm --lld iscsi --op new --mode target --tid 1 -T iqn.20013-10.com.redhat
```

You can look at the target:

```

# tgtadm --lld iscsi --op show --mode conn --tid 1

Session: 11  Connection: 0     Initiator iqn.1994-05.com.redhat:cf75c8d4274d
```

Next, add a logical unit to the target

```

tgtadm --lld iscsi --op new --mode logicalunit --tid 1 --lun 1 -b /mnt/disk3
```

Allow any initiator to access the target.

```

tgtadm --lld iscsi --op bind --mode target --tid 1 -I ALL
```

Now it’s time to set up your client.

Discover your targets. Note in this example's case, the target IP address is 192.168.1.2

```

iscsiadm --mode discovery --type sendtargets --portal 192.168.1.2
```

Login to your target session.

```

iscsiadm --mode node --targetname iqn.2001-04.com.example:storage.disk1.amiens.sys1.xyz --portal 192.168.1.2:3260 --login
```

You should have a new SCSI disk. You will see it created in /var/log/messages. You will see it in lsblk.

You can send I/O to it:

```

dd if=/dev/zero of=/dev/sda bs=4K count=100
```

To tear down your iSCSI connection:

```

iscsiadm  -m node -T iqn.2001-04.com.redhat  -p 172.17.40.21 -u
```

## Running the iSCSI target on the gluster client

You can run the Linux target daemon on the gluster client. The  advantages to this setup is the client could run gluster and enjoy all  of gluster's benefits. For example, gluster could "fan out" I/O to  different gluster servers. The downside would be that the client would  need to load and configure gluster. It is better to run gluster on the  client if it is possible.

## References

[1] http://www.linuxjournal.com/content/creating-software-backed-iscsi-targets-red-hat-enterprise-linux-6

[2] http://www.cyberciti.biz/tips/howto-setup-linux-iscsi-target-sanwith-tgt.html

# Configuring NFS-Ganesha over GlusterFS

NFS-Ganesha is a user-space file server for the NFS protocol with  support for NFSv3, v4, v4.1, pNFS. It provides a FUSE-compatible File  System Abstraction Layer(FSAL) to allow the file-system developers to  plug in their storage mechanism and access it from any NFS client.  NFS-Ganesha can access the FUSE filesystems directly through its FSAL  without copying any data to or from the kernel, thus potentially  improving response times.

## Installing nfs-ganesha

#### Gluster RPMs (>= 3.10)

> glusterfs-server
>  glusterfs-api
>  glusterfs-ganesha

#### Ganesha RPMs (>= 2.5)

> nfs-ganesha
>  nfs-ganesha-gluster

## Start NFS-Ganesha manually

- To start NFS-Ganesha manually, use the command:  `service nfs-ganesha start`

```

where:
/var/log/ganesha.log is the default log file for the ganesha process.
/etc/ganesha/ganesha.conf is the default configuration file
NIV_EVENT is the default log level.
```

- If the user wants to run ganesha in a preferred mode, execute the following command :
   `ganesha.nfsd -f <location_of_nfs-ganesha.conf_file> -L <location_of_log_file> -N <log_level>`

```

For example:
#ganesha.nfsd -f nfs-ganesha.conf -L nfs-ganesha.log -N NIV_DEBUG
where:
nfs-ganesha.log is the log file for the ganesha.nfsd process.
nfs-ganesha.conf is the configuration file
NIV_DEBUG is the log level.
```

- By default, the export list for the server will be Null

```

Note : include following parameters in ganesha configuration file for exporting gluster volumes
NFS_Core_Param {
        #Use supplied name other tha IP In NSM operations
        NSM_Use_Caller_Name = true;
        #Copy lock states into "/var/lib/nfs/ganesha" dir
        Clustered = false;
        #Use a non-privileged port for RQuota
        Rquota_Port = 875;
    #please note add below option for Mac clients
    #Enable_RQUOTA = false;
}
```

## Step by step procedures to exporting GlusterFS volume via NFS-Ganesha

#### step 1 :

To export any GlusterFS volume or directory inside a volume, create  the EXPORT block for each of those entries in an export configuration  file. The following parameters are required to export any entry.

- `cat export.conf`

```

EXPORT{
    Export_Id = 1 ;   # Export ID unique to each export
    Path = "volume_path";  # Path of the volume to be exported. Eg: "/test_volume"

    FSAL {
        name = GLUSTER;
        hostname = "10.xx.xx.xx";  # IP of one of the nodes in the trusted pool
        volume = "volume_name";  # Volume name. Eg: "test_volume"
    }

    Access_type = RW;    # Access permissions
    Squash = No_root_squash; # To enable/disable root squashing
    Disable_ACL = TRUE;  # To enable/disable ACL
    Pseudo = "pseudo_path";  # NFSv4 pseudo path for this export. Eg: "/test_volume_pseudo"
    Protocols = "3","4" ;    # NFS protocols supported
    Transports = "UDP","TCP" ; # Transport protocols supported
    SecType = "sys";     # Security flavors supported
}
```

#### step 2 :

Now include the export configuration file in the ganesha  configuration file (by default). This can be done by adding the line  below at the end of file

- `%include “<path of export configuration>”`

```

Note :
The above two steps can be done with following script
#/usr/libexec/ganesha/create-export-ganesha.sh <ganesha directory> on <volume name>
By default ganesha directory is "/etc/ganesha"
This will create export configuration file in <ganesha directory>/exports/export.<volume name>.conf
Also, it will add the above entry to ganesha.conf
```

#### step 3 :

Turn on features.cache-invalidation for that volume

- `gluster volume set \<volume name\> features.cache-invalidation on`

#### step 4 :

dbus commands are used to export/unexport volume 

- export
- `dbus-send --system --print-reply --dest=org.ganesha.nfsd  /org/ganesha/nfsd/ExportMgr org.ganesha.nfsd.exportmgr.AddExport  string:<ganesha directory>/exports/export.<volume name>.conf string:"EXPORT(Path=/<volume name>)"`
- unexport
- `dbus-send --system --dest=org.ganesha.nfsd  /org/ganesha/nfsd/ExportMgr org.ganesha.nfsd.exportmgr.RemoveExport  uint16:<export id>`

```

Note :
Step 4 can be performed via following script
#/usr/libexec/ganesha/dbus-send.sh <ganesha directory> [on|off] <volume name>
```

Above scripts (mentioned in step 3 and step 4) are available in glusterfs 3.10 rpms.

You can download it from [here](https://github.com/gluster/glusterfs/blob/release-3.10/extras/ganesha/scripts/)

#### step 5 :

- To check if the volume is exported, run
- `showmount -e localhost`
- Or else use the following dbus command
- `dbus-send --type=method_call --print-reply --system  --dest=org.ganesha.nfsd /org/ganesha/nfsd/ExportMgr  org.ganesha.nfsd.exportmgr.ShowExports`
- To see clients
- `dbus-send --type=method_call --print-reply --system  --dest=org.ganesha.nfsd /org/ganesha/nfsd/ClientMgr  org.ganesha.nfsd.clientmgr.ShowClients`

## Using Highly Available Active-Active NFS-Ganesha And GlusterFS cli

> Please Note currently HA solution for nfs-ganesha is available in  3.10. From 3.12 onwards HA will be handled by a different project known  as [storhaug](https://github.com/linux-ha-storage/storhaug) which is under development.

In a highly available active-active environment, if an NFS-Ganesha  server that is connected to an NFS client running a particular  application crashes, the application/NFS client is seamlessly connected  to another NFS-Ganesha server without any administrative intervention. The cluster is maintained using Pacemaker and Corosync. Pacemaker acts  as a resource manager and Corosync provides the communication layer of  the cluster. Data coherency across the multi-head NFS-Ganesha servers in the cluster  is achieved using the UPCALL infrastructure. UPCALL infrastructure is a  generic and extensible framework that sends notifications to the  respective glusterfs clients (in this case NFS-Ganesha server) in case  of any changes detected in the backend filesystem.

The Highly Available cluster is configured in the following three stages:

### Creating the ganesha-ha.conf file

The ganesha-ha.conf.example is created in the following location  /etc/ganesha when Gluster Storage is installed. Rename the file to  ganesha-ha.conf and make the changes as suggested in the following  example: sample ganesha-ha.conf file:

> \# Name of the HA cluster created. must be unique within the subnet
>  HA_NAME="ganesha-ha-360"
>  \# The subset of nodes of the Gluster Trusted Pool that form the ganesha HA cluster.
>  \# Hostname is specified.
>  HA_CLUSTER_NODES="server1,server2,..."
>  \#HA_CLUSTER_NODES="server1.lab.redhat.com,server2.lab.redhat.com,..."
>  \# Virtual IPs for each of the nodes specified above.
>  VIP_server1="10.0.2.1"
>  VIP_server2="10.0.2.2"

### Configuring NFS-Ganesha using gluster CLI

The HA cluster can be set up or torn down using gluster CLI. Also, it can export and unexport specific volumes. For more information, see  section Configuring NFS-Ganesha using gluster CLI.

### Modifying the HA cluster using the `ganesha-ha.sh` script

Post the cluster creation any further modification can be done using the `ganesha-ha.sh` script. For more information, see the section Modifying the HA cluster using the `ganesha-ha.sh` script.

## Step-by-step guide

### Configuring NFS-Ganesha using Gluster CLI⁠

#### Pre-requisites to run NFS-Ganesha

Ensure that the following pre-requisites are taken into consideration before you run NFS-Ganesha in your environment:

- A Gluster Storage volume must be available for export and NFS-Ganesha rpms are installed on all the nodes.

- IPv6 must be enabled on the host interface which is used by the  NFS-Ganesha daemon. To enable IPv6 support, perform the following steps:

- Comment or remove the line options ipv6 disable=1 in the /etc/modprobe.d/ipv6.conf file.

- Reboot the system.

- Ensure that all the nodes in the cluster are DNS resolvable. For  example, you can populate the /etc/hosts with the details of all the  nodes in the cluster.

- Disable and stop NetworkManager service.

- Enable and start network service on all machines.

- Create and mount a gluster shared volume.

- `gluster volume set all cluster.enable-shared-storage enable`

- Install Pacemaker and Corosync on all machines.

- Set the cluster auth password on all the machines.

- Passwordless ssh needs to be enabled on all the HA nodes. Follow these steps,

- On one (primary) node in the cluster, run:

  - `ssh-keygen -f /var/lib/glusterd/nfs/secret.pem`

- Deploy the pubkey ~root/.ssh/authorized keys on 

  all

   nodes, run:

  - `ssh-copy-id -i /var/lib/glusterd/nfs/secret.pem.pub root@$node`

- Copy the keys to *all* nodes in the cluster, run:

  - `scp /var/lib/glusterd/nfs/secret.\* $node:/var/lib/glusterd/nfs/`

- Create a directory named "nfs-ganesha" in shared storage path and  create ganesha.conf & ganesha-ha.conf in it (from glusterfs 3.9  onwards)

#### Configuring the HA Cluster

To set up the HA cluster, enable NFS-Ganesha by executing the following command:

```

gluster nfs-ganesha enable
```

To tear down the HA cluster, execute the following command:

```

gluster nfs-ganesha disable

Note :
Enable command performs the following
* create a symlink ganesha.conf in /etc/ganesha using ganesha.conf in shared storage
* start nfs-ganesha process on nodes part of ganesha cluster
* set up ha cluster
and disable does the reversal of enable
Also if gluster nfs-ganesha [enable/disable] fails of please check following logs
* /var/log/glusterfs/glusterd.log
* /var/log/messages (and grep for pcs commands)
* /var/log/pcsd/pcsd.log
```

#### Exporting Volumes through NFS-Ganesha using cli

To export a Red Hat Gluster Storage volume, execute the following command:

```

gluster volume set <volname> ganesha.enable on
```

To unexport a Red Hat Gluster Storage volume, execute the following command:

```

gluster volume set <volname> ganesha.enable off
```

This command unexports the Red Hat Gluster Storage volume without affecting other exports.

To verify the status of the volume set options, follow the guidelines mentioned below:

- Check if NFS-Ganesha is started by executing the following command:
- `ps aux | grep ganesha.nfsd`
- Check if the volume is exported.
- `showmount -e localhost`

The logs of ganesha.nfsd daemon is written to /var/log/ganesha.log. Check the log file on noticing any unexpected behavior.

### Modifying the HA cluster using the ganesha-ha.sh script

To modify the existing HA cluster and to change the default values of the exports use the ganesha-ha.sh script located at  /usr/libexec/ganesha/.

#### Adding a node to the cluster

Before adding a node to the cluster, ensure all the prerequisites mentioned in section `Pre-requisites to run NFS-Ganesha` are met. To add a node to the cluster. execute the following command on any of the nodes in the existing NFS-Ganesha cluster:

```

#./ganesha-ha.sh --add <HA_CONF_DIR> <HOSTNAME> <NODE-VIP>
where,
HA_CONF_DIR: The directory path containing the ganesha-ha.conf file.
HOSTNAME: Hostname of the new node to be added
NODE-VIP: Virtual IP of the new node to be added.
```

#### Deleting a node in the cluster

To delete a node from the cluster, execute the following command on any of the nodes in the existing NFS-Ganesha cluster:

```

#./ganesha-ha.sh --delete <HA_CONF_DIR> <HOSTNAME>

where,
HA_CONF_DIR: The directory path containing the ganesha-ha.conf file.
HOSTNAME: Hostname of the new node to be added
```

#### Modifying the default export configuration

To modify the default export configurations perform the following steps on any of the nodes in the existing ganesha cluster:

- Edit/add the required fields in the corresponding export file located at `/etc/ganesha/exports`.

- Execute the following command:

  ```
  
  ```

- ```
    #./ganesha-ha.sh --refresh-config <HA_CONFDIR> <volname>
    
    where,
    HA_CONF_DIR: The directory path containing the ganesha-ha.conf file.
    volname: The name of the volume whose export configuration has to be changed.
  ```

  Note:      The export ID must not be changed.

⁠

### Configure ganesha ha cluster outside of gluster nodes

Currently, ganesha HA cluster creating tightly integrated with  glusterd. So here user needs to create another TSP using ganesha nodes.  Then create ganesha HA cluster using above mentioned steps till  executing "gluster nfs-ganesha enable" Exporting/Unexporting should be performed without using glusterd cli  (follow the manual steps, before performing step 4 replace localhost  with required hostname/ip "hostname=localhost;" in the export  configuration file)

## Configuring Gluster volume for pNFS

The Parallel Network File System (pNFS) is part of the NFS v4.1  protocol that allows computing clients to access storage devices  directly and in parallel. The pNFS cluster consists of MDS  (Meta-Data-Server) and DS (Data-Server). The client sends all the  read/write requests directly to DS and all other operations are handle  by the MDS.

### Step by step guide

- Turn on `feature.cache-invalidation` for the volume.
- `gluster v set <volname> features.cache-invalidation on`
- Select one of the nodes in the cluster as MDS and configure it adding the following block to ganesha configuration file

```

GLUSTER
{
 PNFS_MDS = true;
}
```

- Manually start NFS-Ganesha in every node in the cluster.
- Check whether the volume is exported via nfs-ganesha in all the nodes.
- `showmount -e localhost`
- Mount the volume using NFS version 4.1 protocol with the ip of MDS
- `mount -t nfs4 -o minorversion=1 <ip of MDS>:<volume name> <mount path>`

### Points to be Noted

- The current architecture supports only a single MDS and multiple DS.  The server with which client mounts will act as MDS and all servers  including MDS can act as DS.
- Currently, HA is not supported for pNFS (more specifically MDS).  Although it is configurable, consistency is guaranteed across the  cluster.
- If any of the DS goes down, then MDS will handle those I/O's.
- Hereafter, all the subsequent NFS clients need to use the same server for mounting that volume via pNFS. i.e more than one MDS for a volume  is not preferred
- pNFS support is only tested with distributed, replicated, or distribute-replicate volumes
- It is tested and verified with RHEL 6.5 , fedora 20, fedora 21 nfs clients. It is always better to use latest nfs-clients

# Linux Kernel Tuning

## Linux kernel tuning for GlusterFS

Every now and then, questions come up here internally and with many enthusiasts on what Gluster has to say about kernel tuning, if anything.

The rarity of kernel tuning is on account of the Linux kernel doing a pretty good job on most workloads. But there is a flip side to this design. The Linux kernel historically has eagerly eaten up a lot of RAM, provided there is some, or driven towards caching as the primary way to improve performance.

For most cases, this is fine, but as the amount of workload increases over time and clustered load is thrown upon the servers, this turns out to be troublesome, leading to catastrophic failures of jobs etc.

Having had a fair bit of experience looking at large memory systems with heavily loaded regressions, be it CAD, EDA or similar tools, we've sometimes encountered stability problems with Gluster. We had to carefully analyse the memory footprint and amount of disk wait times over days. This gave us a rather remarkable story of disk trashing, huge iowaits, kernel oops, disk hangs etc.

This article is the result of my many experiences with tuning options which were performed on many sites. The tuning not only helped with overall responsiveness, but it dramatically stabilized the cluster overall.

When it comes to memory tuning the journey starts with the 'VM' subsystem which has a bizarre number of options, which can cause a lot of confusion.

### vm.swappiness

vm.swappiness is a tunable kernel parameter that controls how much the kernel favors swap over RAM. At the source code level, it’s also defined as the tendency to steal mapped memory. A high swappiness value means that the kernel will be more apt to unmap mapped pages. A low swappiness value means the opposite, the kernel will be less apt to unmap mapped pages. In other words, the higher the vm.swappiness value, the more the system will swap.

High system swapping has very undesirable effects when there are huge chunks of data being swapped in and out of RAM. Many have argued for the value to be set high, but in my experience, setting the value to '0' causes a performance increase.

Conforming with the details here - http://lwn.net/Articles/100978/

But again these changes should be driven by testing and due diligence from the user for their own applications. Heavily loaded, streaming apps should set this value to '0'. By changing this value to '0', the system's responsiveness improves.

### vm.vfs_cache_pressure

This option controls the tendency of the kernel to reclaim the memory which is used for caching of directory and inode objects.

At the default value of vfs_cache_pressure=100 the kernel will attempt to reclaim dentries and inodes at a "fair" rate with respect to pagecache and swapcache reclaim. Decreasing vfs_cache_pressure causes the kernel to prefer to retain dentry and inode caches. When vfs_cache_pressure=0, the kernel will never reclaim dentries and inodes due to memory pressure and this can easily lead to out-of-memory conditions. Increasing vfs_cache_pressure beyond 100 causes the kernel to prefer to reclaim dentries and inodes.

With GlusterFS, many users with a lot of storage and many small files easily end up using a lot of RAM on the server side due to 'inode/dentry' caching, leading to decreased performance when the kernel keeps crawling through data-structures on a 40GB RAM system. Changing this value higher than 100 has helped many users to achieve fair caching and more responsiveness from the kernel.

### vm.dirty_background_ratio

### vm.dirty_ratio

The first of the two (vm.dirty_background_ratio) defines the percentage of memory that can become dirty before a background flushing of the pages to disk starts. Until this percentage is reached no pages are flushed to disk. However when the flushing starts, then it's done in the background without disrupting any of the running processes in the foreground.

Now the second of the two parameters (vm.dirty_ratio) defines the percentage of memory which can be occupied by dirty pages before a forced flush starts. If the percentage of dirty pages reaches this threshold, then all processes become synchronous, and they are not allowed to continue until the io operation they have requested is actually performed and the data is on disk. In cases of high performance I/O machines, this causes a problem as the data caching is cut away and all of the processes doing I/O become blocked to wait for I/O. This will cause a large number of hanging processes, which leads to high load, which leads to an unstable system and crappy performance.

Lowering them from standard values causes everything to be flushed to disk rather than storing much in RAM. It helps large memory systems, which would normally flush a 45G-90G pagecache to disk, causing huge wait times for front-end applications, decreasing overall responsiveness and interactivity.

### "1" > /proc/sys/vm/pagecache

Page Cache is a disk cache which holds data from files and executable programs, i.e. pages with actual contents of files or block devices. Page Cache (disk cache) is used to reduce the number of disk reads. A value of '1' indicates 1% of the RAM is used for this, so that most of them are fetched from disk rather than RAM. This value is somewhat fishy after the above values have been changed. Changing this option is not necessary, but if you are still paranoid about controlling the pagecache, this value should help.

### "deadline" > /sys/block/sdc/queue/scheduler

The I/O scheduler is a component of the Linux kernel which decides how the read and write buffers are to be queued for the underlying device. Theoretically 'noop' is better with a smart RAID controller because Linux knows nothing about (physical) disk geometry, therefore it can be efficient to let the controller, well aware of disk geometry, handle the requests as soon as possible. But 'deadline' seems to enhance performance. You can read more about them in the Linux kernel source documentation: linux/Documentation/block/*iosched.txt . I have also seen 'read' throughput increase during mixed-operations (many writes).

### "256" > /sys/block/sdc/queue/nr_requests

This is the size of I/O requests which are buffered before they are communicated to the disk by the Scheduler. The internal queue size of some controllers (queue_depth) is larger than the I/O scheduler's nr_requests so that the I/O scheduler doesn't get much of a chance to properly order and merge the requests. Deadline or CFQ scheduler likes to have nr_requests to be set 2 times the value of queue_depth, which is the default for a given controller. Merging the order and requests helps the scheduler to be more responsive during huge load.

### echo "16" > /proc/sys/vm/page-cluster

page-cluster controls the number of pages which are written to swap in a single attempt. It defines the swap I/O size, in the above example adding '16' as per the RAID stripe size of 64k. This wouldn't make sense after you have used swappiness=0, but if you defined swappiness=10 or 20, then using this value helps when your have a RAID stripe size of 64k.

### blockdev --setra 4096 /dev/ (eg:- sdb, hdc or dev_mapper)

Default block device settings often result in terrible performance for many RAID controllers. Adding the above option, which sets read-ahead to 4096 * 512-byte sectors, at least for the streamed copy, increases the speed, saturating the HD's integrated cache by reading ahead during the period used by the kernel to prepare I/O. It may put in cached data which will be requested by the next read. Too much read-ahead may kill random I/O on huge files if it uses potentially useful drive time or loads data beyond caches.

A few other miscellaneous changes which are recommended at filesystem level but haven't been tested yet are the following. Make sure that your filesystem knows about the stripe size and number of disks in the array. E.g. for a raid5 array with a stripe size of 64K and 6 disks (effectively 5, because in every stripe-set there is one disk doing parity). These are built on theoretical assumptions and gathered from various other blogs/articles provided by RAID experts.

-> ext4 fs, 5 disks, 64K stripe, units in 4K blocks

mkfs -text4 -E stride=\$((64/4))

-> xfs, 5 disks, 64K stripe, units in 512-byte sectors

mkfs -txfs -d sunit=\$((64*2)) -d swidth=\$((5*64*2))

You may want to consider increasing the above stripe sizes for streaming large files.

WARNING: Above changes are highly subjective with certain types of applications. This article doesn't guarantee any benefits whatsoever without prior due diligence from the user for their respective applications. It should only be applied at the behest of an expected increase in overall system responsiveness or if it resolves ongoing issues.

More informative and interesting articles/emails/blogs to read

- http://dom.as/2008/02/05/linux-io-schedulers/
- http://www.nextre.it/oracledocs/oraclemyths.html
- https://lkml.org/lkml/2006/11/15/40
- http://misterd77.blogspot.com/2007/11/3ware-hardware-raid-vs-linux-software.html

`Last updated by:`[`User:y4m4`](User:y4m4)

### comment:jdarcy

Some additional tuning ideas:

```
* The choice of scheduler is *really* hardware- and  workload-dependent, and some schedulers have unique features other than  performance. For example, last time I looked cgroups support was limited to the cfq scheduler. Different tests regularly do best on any of cfq,  deadline, or noop. The best advice here is not to use a particular  scheduler but to try them all for a specific need.
* It's worth checking to make sure that /sys/.../max_sectors_kb matches max_hw_sectors_kb. I haven't seen this problem for a while, but back when I used to work on Lustre I often saw that these didn't match  and performance suffered.
* For read-heavy workloads, experimenting with /sys/.../readahead_kb is definitely worthwhile.
* Filesystems should be built with -I 512 or similar so that  more xattrs can be stored in the inode instead of requiring an extra  seek.
* Mounting with noatime or relatime is usually good for performance.
```

#### reply:y4m4

```
Agreed i was about write those parameters you mentioned. I should write another elaborate article on FS changes.
```

y4m4

### comment:eco

`1 year ago`\ `This article is the model on which all articles should be written. Detailed information, solid examples and a great selection of  references to let readers go more in depth on topics they choose. Great  benchmark for others to strive to attain.`\ `Eco`\

### comment:y4m4

```
sysctl -w net.core.{r,w}mem_max = 4096000 - this helped us to  Reach 800MB/sec with replicated GlusterFS on 10gige - Thanks to Ben  England for these test results.`\ `y4m4
```

### comment:bengland

```
After testing Gluster 3.2.4 performance with RHEL6.1, I'd suggest some changes to this article's recommendations:
vm.swappiness=10 not 0 -- I think 0 is a bit extreme and might  lead to out-of-memory conditions, but 10 will avoid just about all  paging/swapping. If you still see swapping, you need to probably focus  on restricting dirty pages with vm.dirty_ratio.
vfs_cache_pressure > 100 -- why? I thought this was a percentage.
vm.pagecache=1 -- some distros (e.g. RHEL6) don't have vm.pagecache parameter.
vm.dirty_background_ratio=1 not 10 (kernel default?) -- the  kernel default is a bit dependent on choice of Linux distro, but for  most workloads it's better to set this parameter very low to cause Linux to push dirty pages out to storage sooner. It means that if dirty pages exceed 1% of RAM then it will start to asynchronously write dirty pages to storage. The only workload where this is really bad: apps that write temp files and then quickly delete them (compiles) -- and you should  probably be using local storage for such files anyway.
Choice of vm.dirty_ratio is more dependent upon the workload,  but in other contexts I have observed that response time fairness and  stability is much better if you lower dirty ratio so that it doesn't  take more than 2-5 seconds to flush all dirty pages to storage.
block device parameters:
I'm not aware of any case where cfq scheduler actually helps  Gluster server. Unless server I/O threads correspond directly to  end-users, I don't see how cfq can help you. Deadline scheduler is a  good choice. I/O request queue has to be deep enough to allow scheduler  to reorder requests to optimize away disk seeks. The parameters  max_sectors_kb and nr_requests are relevant for this. For read-ahead,  consider increasing it to the point where you prefetch for longer period of time than a disk seek (on order of 10 msec), so that you can avoid  unnecessary disk seeks for multi-stream workloads. This comes at the  expense of I/O latency so don't overdo it.
network:
jumbo frames can increase throughput significantly for 10-GbE networks.
```

`Raise net.core.{r,w}mem_max to 540000 from default of 131071  (not 4 MB above, my previous recommendation). Gluster 3.2 does  setsockopt() call to use 1/2 MB mem for TCP socket buffer space.`\ `bengland`\

### comment:hjmangalam

```
Thanks very much for noting this info - the descriptions are  VERY good.. I'm in the midst of debugging a misbehaving gluster that  can't seem to handle small writes over IPoIB and this contains some  useful pointers.
Some suggestions that might make this more immediately useful:
- I'm assuming that this discussion refers to the gluster  server nodes, not to the gluster native client nodes, yes? If that's the case, are there are also kernel parameters or recommended settings for  the client nodes?`\ `- While there are some cases where you mention that a value should be changed to a particular # or %, in a number of cases you advise just increasing/decreasing the values, which for something like a kernel  parameter is probably not a useful suggestion. Do I raise it by 10? 10%  2x? 10x?
I also ran across a complimentary page, which might be of  interest - it explains more of the vm variables, especially as it  relates to writing.`\ `"Theory of Operation and Tuning for Write-Heavy Loads"`\ ``` and refs therein.` `hjmangalam
```

### comment:bengland

```
Here are some additional suggestions based on recent testing:`\ `- scaling out number of clients -- you need to increase the size  of the ARP tables on Gluster server if you want to support more than 1K  clients mounting a gluster volume. The defaults for RHEL6.3 were too low to support this, we used this:
net.ipv4.neigh.default.gc_thresh2 = 2048`\ `net.ipv4.neigh.default.gc_thresh3 = 4096
In addition, tunings common to webservers become relevant at  this number of clients as well, such as netdev_max_backlog,  tcp_fin_timeout, and somaxconn.
Bonding mode 6 has been observed to increase replication write  performance, I have no experience with bonding mode 4 but it should work if switch is properly configured, other bonding modes are a waste of  time.
bengland`\ `3 months ago
```

# Network Configurations Techniques

#### Bonding best practices

Bonded network interfaces incorporate multiple physical interfaces  into a single logical bonded interface, with a single IP addr. An N-way  bonded interface can survive loss of N-1 physical interfaces, and  performance can be improved in some cases.

###### When to bond?

- Need high availability for network link
- Workload: sequential access to large files (most time spent reading/writing)
- Network throughput limit of client/server \<\< storage throughput limit
- 1 GbE (almost always)
- 10-Gbps links or faster -- for writes, replication doubles the load  on the network and replicas are usually on different peers to which the  client can transmit in parallel.
- LIMITATION: Bonding mode 6 doesn't improve throughput if network peers are not on the same VLAN.

###### How to configure

- [Bonding-howto](http://www.linuxquestions.org/linux/answers/Networking/Linux_bonding_howto_0)
- Best bonding mode for Gluster client is mode 6 (balance-alb), this  allows client to transmit writes in parallel on separate NICs much of  the time. A peak throughput of 750 MB/s on writes from a single client  was observed with bonding mode 6 on 2 10-GbE NICs with jumbo frames.  That's 1.5 GB/s of network traffic.
- Another way to balance both transmit and receive traffic is bonding  mode 4 (802.3ad) but this requires switch configuration (trunking  commands)
- Still another way to load balance is bonding mode 2 (balance-xor)  with option "xmit_hash_policy=layer3+4". The bonding modes 6 and 2 will  not improve single-connection throughput, but improve aggregate  throughput across all connections.

##### Jumbo frames

Jumbo frames are Ethernet (or Infiniband) frames with size greater  than the default of 1500 bytes (Infiniband default is around 2000  bytes). Increasing frame size reduces load on operating system and  hardware, which must process interrupts and protocol messages per frame.

###### When to configure?

- Any network faster than 1-GbE
- Workload is sequential large-file reads/writes
- LIMITATION: Requires all network switches in VLAN must be configured to handle jumbo frames, do not configure otherwise.

###### How to configure?

- Edit network interface file at /etc/sysconfig/network-scripts/ifcfg-your-interface
- Ethernet (on ixgbe driver): add "MTU=9000" (MTU means "maximum transfer unit") record to network interface file
- Infiniband (on mlx4 driver): add "CONNECTED_MODE=yes" and "MTU=65520" records to network interface file
- ifdown your-interface; ifup your-interface
- Test with "ping -s 16384 other-host-on-VLAN"
- Switch requires max frame size larger than MTU because of protocol headers, usually 9216 bytes

##### Configuring a backend network for storage

This method lets you add network capacity for multi-protocol sites by segregating traffic for different protocols on different network  interfaces. This method can lower latency and improve throughput. For  example, this method can keep self-heal and rebalancing traffic from  competing with non-Gluster client traffic for a network interface, and  will better support multi-stream I/O.

###### When to configure?

- For non-Gluster services such as NFS, Swift (REST), CIFS being  provided on Gluster servers. It will not help Gluster clients (external  nodes with Gluster mountpoints on them).
- Network port is over-utilized.

###### How to configure?

- Most network cards have multiple ports on them -- make port 1 the non-Gluster port and port 2 the Gluster port.
- Separate Gluster ports onto a separate VLAN from non-Gluster ports, to simplify configuration.

# Gluster performance testing

Once you have created a Gluster volume, you need to verify that it has adequate performance for your application, and if it does not, you need a way to isolate the root cause of the problem.

There are two kinds of workloads:

- synthetic - run a test program such as ones below
- application - run existing application

# Profiling tools

Ideally it's best to use the actual application that you want to run  on Gluster, but applications often don't tell the sysadmin much about  where the performance problems are, particularly latency (response-time) problems. So there are non-invasive profiling tools built into Gluster  that can measure performance as seen by the application, without  changing the application. Gluster profiling methods at present are based on the io-stats translator, and include:

- client-side profiling - instrument a Gluster mountpoint or libgfapi  process to sample profiling data. In this case, the io-stats translator  is at the "top" of the translator stack, so the profile data truly  represents what the application (or FUSE mountpoint) is asking Gluster  to do. For example, a single application write is counted once as a  WRITE FOP (file operation) call, and the latency for that WRITE FOP  includes latency of the data replication done by the AFR translator  lower in the stack.
- server-side profiling - this is done using the "gluster volume  profile" command (and "gluster volume top" can be used to identify  particular hot files in use as well). Server-side profiling can measure  the throughput of an entire Gluster volume over time, and can measure  server-side latencies. However, it does not incorporate network or  client-side latencies. It is also hard to infer application behavior  because of client-side translators that alter the I/O workload  (examples: erasure coding, cache tiering).

In short, use client-side profiling for understanding "why is my  application unresponsive"? and use server-side profiling for  understanding how busy your Gluster volume is, what kind of workload is  being applied to it (i.e. is it mostly-read? is it small-file?), and how well the I/O load is spread across the volume.

## client-side profiling

To run client-side profiling,

- gluster volume profile your-volume start
- setfattr -n trusted.io-stats-dump -v io-stats-pre.txt /your/mountpoint

This will generate the specified file (`/var/run/gluster/io-stats-pre.txt`) on the client. A script like [gvp-client.sh](https://github.com/bengland2/gluster-profile-analysis) can automate collection of this data.

TBS: what the different FOPs are and what they mean.

## server-side profiling

To run it:

- gluster volume profile your-volume start
- repeat this command periodically: gluster volume profile your-volume info
- gluster volume profile your-volume stop

A script like [gvp.sh](https://github.com/bengland2/gluster-profile-analysis) can help you automate this procedure.

Scripts to post-process this data are in development now, let us know what you need and what would be a useful format for presenting the  data.

# Testing tools

In this section, we suggest some basic workload tests that can be used to measure Gluster performance in an application-independent way for a wide variety of POSIX-like operating systems and runtime environments. We then provide some terminology and conceptual framework for interpreting these results.

The tools that we suggest here are designed to run in a distributed filesystem. This is still a relatively rare attribute for filesystem benchmarks, even now! There is a much larger set of benchmarks available that can be run from a single system. While single-system results are important, they are far from a definitive measure of the performance capabilities of a distributed filesystem.

- [fio](http://freecode.com/projects/fio) - for large file I/O tests.
- [smallfile](https://github.com/bengland2/smallfile) - for  pure-workload small-file tests
- [iozone](http://www.iozone.org) - for pure-workload large-file tests
- [parallel-libgfapi](https://github.com/bengland2/parallel-libgfapi) - for pure-workload libgfapi tests

The "netmist" mixed-workload generator of SPECsfs2014 may be suitable in some cases, but is not technically an open-source tool. This tool  was written by Don Capps, who was an author of iozone.

### fio

fio is extremely powerful and is easily installed from traditional  distros, unlike iozone, and has increasingly powerful distributed test  capabilities described in its --client parameter upstream as of May  2015. To use this mode, start by launching an fio "server" instance on  each workload generator host using:

```

    fio --server --daemonize=/var/run/fio-svr.pid
```

And make sure your firewall allows port 8765 through for it. You can now run tests on sets of hosts using syntax like:

```

    fio --client=workload-generator.list --output-format=json my-workload.fiojob
```

You can also use it for distributed testing, however, by launching  fio instances on separate hosts, taking care to start all fio instances  as close to the same time as possible, limiting per-thread throughput,  and specifying the run duration rather than the amount of data, so that  all fio instances end at around the same time. You can then aggregate  the fio results from different hosts to get a meaningful aggregate  result.

fio also has different I/O engines, in particular Huamin Chen authored the ***libgfapi\*** engine for fio so that you can use fio to test Gluster performance without using FUSE.

Limitations of fio in distributed mode:

- stonewalling - fio calculates throughput based on when the last  thread finishes a test run. In contrast, iozone calculates throughput by default based on when the FIRST thread finishes the workload. This can  lead to (deceptively?) higher throughput results for iozone, since there are inevitably some "straggler" threads limping to the finish line  later than others. It is possible in some cases to overcome this  limitation by specifying a time limit for the test. This works well for  random I/O tests, where typically you do not want to read/write the  entire file/device anyway.
- inaccuracy when response times > 1 sec - at least in some cases  fio has reported excessively high IOPS when fio threads encounter  response times much greater than 1 second, this can happen for  distributed storage when there is unfairness in the implementation.
- io engines are not integrated.

### smallfile Distributed I/O Benchmark

[Smallfile](https://github.com/distributed-system-analysis/smallfile) is a python-based small-file distributed POSIX workload generator which can be used to quickly measure performance for a variety of  metadata-intensive workloads across an entire cluster. It has no  dependencies on any specific filesystem or implementation AFAIK. It runs on Linux, Windows and should work on most Unixes too. It is intended to complement use of iozone benchmark for measuring performance of  large-file workloads, and borrows certain concepts from iozone and Ric  Wheeler's fs_mark. It was developed by Ben England starting in March  2009, and is now open-source (Apache License v2).

Here is a typical simple sequence of tests where files laid down in  an initial create test are then used in subsequent tests. There are many more smallfile operation types than these 5 (see doc), but these are  the most commonly used ones.

```

    SMF="./smallfile_cli.py --top /mnt/glusterfs/smf --host-set h1,h2,h3,h4 --threads 8 --file-size 4 --files 10000 --response-times Y "
    $SMF --operation create
    for s in $SERVERS ; do ssh $h 'echo 3 > /proc/sys/vm/drop_caches' ; done
    $SMF --operation read
    $SMF --operation append
    $SMF --operation rename
    $SMF --operation delete
```

### iozone

This tool has limitations but does distributed testing well using -+m option (below).

The "-a" option for automated testing of all use cases is discouraged, because:

- this does not allow you to drop the read cache in server before a  test.
- most of the data points being measured will be irrelevant to the  problem you are solving.

Single-thread testing is an important use case, but to fully utilize the available hardware you typically need to do multi-thread and even multi-host testing.

Consider using "-c -e" options to measure the time it takes for data to reach persistent storage. "-C" option lets you see how much each thread participated in the test. "-+n" allows you to save time by skipping re-read and re-write tests. "-w" option tells iozone not to delete any files that it accessed, so that subsequent tests can use them. Specify these options with each test:

- -i -- test type, 0=write, 1=read, 2=random read/write
- -r -- data transfer size -- allows you to simulate I/O size used by  application
- -s -- per-thread file size -- choose this to be large enough for the  system to reach steady state (typically multiple GB needed)
- -t -- number of threads -- how many subprocesses will be  concurrently issuing I/O requests
- -F -- list of files -- what files to write/read. If you do not  specify then the filenames iozone.DUMMY.* will be used in the  default directory.

Example of an 8-thread sequential write test with 64-KB transfer size and file size of 1 GB to shared Gluster mountpoint directory /mnt/glusterfs , including time to fsync() and close() the files in the throughput calculation:

```

    iozone -w -c -e -i 0 -+n -C -r 64k -s 1g -t 8 -F /mnt/glusterfs/f{0,1,2,3,4,5,6,7,8}.ioz
```

WARNING: random I/O testing in iozone is heavily restricted by the iozone constraint that it must randomly read then randomly write the entire file! This is not what we want - instead it should randomly read/write for some fraction of file size or time duration, allowing us to spread out more on the disk while not waiting too long for test to finish. This is why fio (below) is the preferred test tool for random I/O workloads.

Distributed testing is a strength of the iozone utility, but this requires use of "-+m" option in place of "-F" option. The configuration file passed with "-+m" option contains a series of records that look like this:

```

    hostname   directory   iozone-pathname
```

Where hostname is a host name or IP address of a test driver machine that iozone can use, directory is the pathname of a directory to use within that host, and iozone-pathname is the full pathname of the iozone executable to use on that host. Be sure that every target host can resolve the hostname of host where the iozone command was run. All target hosts must permit password-less ssh access from the host running the command.

For example: (Here, my-ip-address refers to the machine from where the iozone is being run)

```

    export RSH=ssh
    iozone -+m ioz.cfg -+h my-ip-address -w -c -e -i 0 -+n -C -r 64k -s 1g -t 4
```

And the file ioz.cfg contains these records (where /mnt/glusterfs is  the Gluster mountpoint on each test machine and test-client-ip is the IP  address of a client). Also note that, Each record in the file is a  thread in IOZone terminology. Since we have defined the number of  threads to be 4 in the above example, we have four records(threads) for a single client.

```

    test-client-ip  /mnt/glusterfs  /usr/local/bin/iozone
    test-client-ip  /mnt/glusterfs  /usr/local/bin/iozone
    test-client-ip  /mnt/glusterfs  /usr/local/bin/iozone
    test-client-ip  /mnt/glusterfs  /usr/local/bin/iozone
```

Restriction: Since iozone uses non-privileged ports it may be necessary to temporarily shut down or alter iptables on some/all of the hosts. Secondary machines must support password-less access from Primary machine via ssh.

Note that the -+h option is undocumented but it tells the secondary host what IP address to use so that the secondary does not have to be able to resolve the hostname of the test driver. my-ip-address is the IP address that the secondary should connect to in order to report results back to the host. This need not be the same as the host's hostname.

Typically you run the sequential write test first to lay down the file, drop cache on the servers (and clients if necessary), do the sequential read test, drop cache, do random I/O test if desired. Using above example:

```

    export RSH=ssh
    IOZ="iozone -+m ioz.cfg -+h my-ip-address -w -C -c -e -r 64k -+n "
     hosts="`awk '{ print $1 }' ioz.cfg`"
    $IOZ -i 0 -s 1g -t 4`\
    for n in $hosts $servers ; do \
       ssh $n 'sync; echo 1 > /proc/sys/vm/drop_caches' ; done
    $IOZ -i 1 -s 1g -t 4
    for n in $hosts $servers ; do \
       ssh $n 'sync; echo 1 > /proc/sys/vm/drop_caches' ; done
    $IOZ -i 2 -s 1g -t 4
```

If you use client with buffered I/O (the default), drop cache on the client machines first, then the server machines also as shown above.

### parallel-libgfapi

This test exercises Gluster performance using the libgfapi API, bypassing FUSE - no mountpoints are used. Available [here](https://github.com/bengland2/parallel-libgfapi).

To use it, you edit the script parameters in parallel_gfapi_test.sh script - all of them are above the comment "NO EDITABLE PARAMETERS BELOW THIS LINE". These include such things as the Gluster volume name, a host serving that volume, number of files, etc. You then make sure that the gfapi_perf_test executable is distributed to the client machines at the specified directory, and then run the script. The script starts all libgfapi workload generator processes in parallel in such a way that they all start the test at the same time. It waits until they all complete, and then it collects and aggregates the results for you.

Note that libgfapi processes consume one socket per brick, so in Gluster volumes with high brick counts, there can be constraints on the number of libgfapi processes that can run concurrently. Specifically, each host can only support up to about 30000 concurrent TCP ports. You may need to adjust "ulimit -n" parameter (see /etc/security/limits.conf "nofile" parameter for persistent tuning).

### Object Store tools

[COSBench](http://www.snia.org/sites/default/files/files2/files2/SDC2013/presentations/Cloud/YaguangWang__COSBench_Final.pdf) was developed by Intel employees and is very useful for both Swift and S3 workload generation.

[ssbench](https://pypi.python.org/pypi/ssbench) is part of OpenStack Swift toolset and is command-line tool with a workload definition file format.

## Workload

An application can be as simple as writing some files, or it can be as complex as running a cloud on top of Gluster. But all applications have performance requirements, whether the users are aware of them or not, and if these requirements aren't met, the system as a whole is not functional from the user's perspective. The activities that the application spends most of its time doing with Gluster are called the "workload" below. For the Gluster filesystem, the "workload" consists of the filesystem requests being delivered to Gluster by the application. There are two ways to look at workload:

- top-down - what is the application trying to get the filesystem to  do?
- bottom-up - what requests is the application actually generating to  the filesystem?

### data vs metadata

In this page we frequently refer to "large-file" or "small-file" workloads. But what do we mean by the terms "large-file" or "small-file"? "large-file" is a deliberately vague but descriptive term that refers to workloads where most of the application time is spent reading/writing the file. This is in contrast to a "small-file" workload, where most of the application's time is spent opening/closing the file or accessing metadata about the file. Metadata means "data about data", so it is information that describes the state of the file, rather than the contents of the file. For example, a filename is a type of metadata, as are directories and extended attributes.

### Top-down workload analysis

Often this is what users will be able to help you with -- for example, a workload might consist of ingesting a billion .mp3 files. Typical questions that need to be answered (approximately) are:

- what is file size distribution? Averages are often not enough - file  size distributions can be bi-modal (i.e. consist mostly of the very  large and very small file sizes). TBS: provide pointers to scripts  that can collect this.
- what fraction of file accesses are reads vs writes?
- how cache-friendly is the workload? Do the same files get read  repeatedly by different Gluster clients, or by different  processes/threads on these clients?
- for large-file workloads, what fraction of accesses are  sequential/random? Sequential file access means that the application  thread reads/writes the file from start to finish in byte offset  order, and random file access is the exact opposite -- the thread  may read/write from any offset at any time. Virtual machine disk  images are typically accessed randomly, since the VM's filesystem is  embedded in a Gluster file.

Why do these questions matter? For example, if you have a large-file sequential read workload, network configuration + Gluster and Linux readahead is important. If you have a small-file workload, storage configuration is important, and so on. You will not know what tuning is appropriate for Gluster unless you have a basic understanding the workload.

### Bottom-up analysis

Even a complex application may have a very simple workload from the point of view of the filesystem servicing its requests. If you don't know what your application spends its time doing, you can start by running the "gluster volume profile" and "gluster volume top" commands. These extremely useful tools will help you understand both the workload and the bottlenecks which are limiting performance of that workload.

TBS: links to documentation for these tools and scripts that reduce the data to usable form.

## Configuration

There are 4 basic hardware dimensions to a Gluster server, listed here in order of importance:

- network - possibly the most important hardware component of a  Gluster site
- access protocol - what kind of client is used to get to the    files/objects?
- storage - this is absolutely critical to get right up front
- cpu - on client, look for hot threads (see below)
- memory - can impact performance of read-intensive, cacheable  workloads

### network testing

Network configuration has a huge impact on performance of distributed storage, but is often not given the attention it deserves during the planning and installation phases of the cluster lifecycle. Fortunately, [network configuration](https://docs.gluster.org/en/latest/Administrator-Guide/Network-Configurations-Techniques/) can be enhanced significantly, often without additional hardware.

To measure network performance, consider use of a [netperf-based](http://www.cs.kent.edu/~farrell/dist/ref/Netperf.html) script.

The purpose of these two tools is to characterize the capacity of  your entire network infrastructure to support the desired level of  traffic induced by distributed storage, using multiple network  connections in parallel. The latter script is probably the most  realistic network workload for distributed storage.

The two most common hardware problems impacting distributed storage are, not surprisingly, disk drive failures and network failures. Some of these failures do not cause hard errors, but instead cause performance degradation. For example, with a bonded network interface containing two physical network interfaces, if one of the physical interfaces fails (either port on NIC/switch, or cable), then the bonded interface will stay up, but will have less performance (how much less depends on the bonding mode). Another error would be failure of an 10-GbE Ethernet interface to autonegotiate speed to 10-Gbps -- sometimes network interfaces auto-negotiate to 1-Gbps instead. If the TCP connection is experiencing a high rate of packet loss or is not tuned correctly, it may not reach the full network speed supported by the hardware.

So why run parallel netperf sessions instead of just one? There are a variety of network performance problems relating to network topology (the way in which hosts are interconnected), particularly network switch and router topology, that only manifest when several pairs of hosts are attempting to transmit traffic across the same shared resource, which could be a trunk connecting top-of-rack switches or a blade-based switch with insufficient bandwidth to switch backplane, for example. Individual netperf/iperf sessions will not find these problems, but this script will.

This test can be used to simulate flow of data through a distributed filesystem, for example. If you want to simulate 4 Gluster clients, call them c1 through c4, writing large files to a set of 2 servers, call them s1 and s2, you can specify these (sender, receiver) pairs:

```

    (c1,s1), (c2, s2), (c3, s1), (c4, s2)
```

If on the other hand you want to simulate reads, you can use these (sender, receiver) pairs:

```

    (s1, c1), (s2, c2), (s1, c3), (s2, c4)
```

To simulate a mixed read-write workload, use both sets of pairs:

```

    (c1,s1), (c2, s2), (c3, s1), (c4, s2), (s1, c1), (s2, c2), (s1, c3), (s2, c4)
```

More complicated flows can model behavior of non-native protocols,  where a cluster node acts as a proxy server- it is a server (for  non-native protocol) and a client (for native protocol). For example,  such protocols often induce full-duplex traffic which can stress the  network differently than unidirectional in/out traffic. For example, try adding this set of flows to preceding flow:

```

    (s1, s2),.(s2, s3),.(s3, s4),.(s4, s1)
```

The comments at the top of the script describe the input syntax, but here are some suggestions on how to best utilize it. You typically run this script from a head node or test driver that has password-less ssh access to the set of machines being tested. The hosts running the test do not need ssh access to each other -- they only have to allow password-less ssh access from the head node. The script does not rely on root privileges, so you can run it from a non-root account. Just create a public key on the head node in the right account (usually in \$HOME/.ssh/id_rsa.pub ) and then append this public key to \$HOME/.ssh/authorized_keys on each host participating in the test.

We input senders and receivers using separate text files, 1 host per line. For pair (sender[j], receiver[j]), you get sender[j] from line j in the sender file, and receiver[j] from line j in the receiver file. You have to use the IP address/name that corresponds to the interface you want to test, and you have to be able to ssh to each host from the head node using this interface.

## Results

There are 3 basic forms of performance results, not in order of importance:

- throughput -- how much work is done in a unit of time? Best metrics  typically are workload-dependent:
- for large-file random: IOPS
- for large-file sequential: MB/s
- for small-file: files/sec
- response time -- IMPORTANT, how long does it take for filesystem  request to complete?
- utilization -- how busy is the hardware while the workload is  running?
- scalability -- can we linearly scale throughput without sacrificing  response time as we add servers to a Gluster volume?

Typically throughput results get the most attention, but in a distributed-storage environment, the hardest goal to achieve may well be CONSISTENTLY LOW RESPONSE TIME, not throughput.

While there are non-interactive workloads where response time does not matter as much, you should pay attention to response time in any situation where a user has to directly interact with the filesystem. Tuning the filesystem to achieve the absolute highest throughput can result in a filesystem that is unusable because of high response time. Unless you are in a benchmarking situation, you want to achieve a balance of good throughput and response time. Typically an interactive user wants to see a response time under 5 seconds always, with most response times much lower than this. To keep response times under control (including system management!), you do not want any hardware component to run at maximum utilization, typically 60-80% utilization is a good peak utilization target. On the other hand, to avoid wasting hardware, you want all of the hardware to be utilized to some extent.

# Performance tuning

## Enable Metadata cache

Metadata caching improves performance in almost all the workloads, except for use cases with most of the workload accessing a file sumultaneously from multiple clients.

1. Execute the following command to enable metadata caching and cache invalidation:

   `console gluster volume set <volname> group metadata-cache`

   This group command enables caching of stat and xattr information of a file or directory. The caching is refreshed every 10 min, and cache-invalidation is enabled to ensure cache consistency.

2. To increase the number of files that can be cached, execute the following command:

   `console gluster volume set <volname> network.inode-lru-limit <n>`

   n, is set to 50000. It can be increased if the number of active files in the volume is very high. Increasing this number increases the memory footprint of the brick processes.

3. Execute the following command to enable samba specific metadata caching:

   `console gluster volume set <volname> cache-samba-metadata on`

4. By default, some xattrs are cached by gluster like: capability xattrs, ima xattrs    ACLs, etc. If there are any other xattrs that are used by the application using    the Gluster storage, execute the following command to add these xattrs to the metadata    cache list:    `console    gluster volume set <volname> xattr-cache-list "comma separated xattr list"`    Eg:    `console    gluster volume set <volname> xattr-cache-list "user.org.netatalk.*,user.swift.metadata"`

## Directory operations

Along with enabling the metadata caching, the following options can be set to increase performance of directory operations:

### Directory listing Performance:

- Enable `parallel-readdir`

```
console  gluster volume set <VOLNAME> performance.readdir-ahead on  gluster volume set <VOLNAME> performance.parallel-readdir on
```

### File/Directory Create Performance

- Enable `nl-cache`

```
console  gluster volume set <volname> group nl-cache  gluster volume set <volname> nl-cache-positive-entry on
```

The above command also enables cache invalidation and increases the timeout to 10 minutes

## Small file Read operations

For use cases with dominant small file reads, enable the following options

```

gluster volume set <volname> performance.cache-invalidation on
gluster volume set <volname> features.cache-invalidation on
gluster volume set <volname> performance.qr-cache-timeout 600 # 10 min recommended setting
gluster volume set <volname> cache-invalidation-timeout 600 # 10 min recommended setting
```

This command enables caching of the content of small file, in the client cache. Enabling cache invalidation ensures cache consistency.

The total cache size can be set using

```

gluster volume set <volname> cache-size <size>
```

By default, the files with size `<=64KB` are cached. To change this value:

```

gluster volume set <volname> performance.cache-max-file-size <size>
```

Note that the `size` arguments use SI unit suffixes, e.g. `64KB` or `2MB`.

# Export and Netgroup Authentication

## Exports and Netgroups Authentication for NFS

This feature adds Linux-style exports & netgroups authentication  to Gluster's NFS server. More specifically, this feature allows users to restrict access specific IPs (exports authentication) or a netgroup  (netgroups authentication), or a combination of both for both Gluster  volumes and subdirectories within Gluster volumes. Netgroups are used in Unix environments to control access for NFS exports, remote logins and  remote shells. Each netgroup has a unique name and defines a set of  hosts, users, groups and other netgroups. This information is stored in  files and gluster NFS server manage permission for clients based on  those file

## Implications and Usage

Currently, gluster can restrict access to volumes through simple IP  list. But this feature makes that capability more scalable by allowing  large lists of IPs to be managed through a netgroup. Moreover it  provides more granular permission handling on volumes like wildcard  support, read-only permission to certain client etc.

The file `/var/lib/glusterd/nfs/export` contains the  details of machines which can be used as clients for that server.An  typical export entry use the following format :

```

/<export path> <host/netgroup> (options),..
```

Here export name can be gluster volume or subdirectory path inside  that volume. Next it contains list of host/netgroup , followed by the  options applicable to that entry.A string beginning with an '@' is  treated as a netgroup and a string beginning without an @ is a host. The options include mount related parameters , right now options such as  "sec", "ro/rw", "anonuid" valid one. If * is mention as host/netgroup  field , then any client can mount that export path.

The file `/var/lib/glusterd/nfs/netgroup` should mention the expansion of each netgroup which mentioned in the export file. An typical netgroup entry will look like :

```

<netgroup name> ng1000\nng1000 ng999\nng999 ng1\nng1 ng2\nng2 (ip1,ip2,..)
```

The gluster NFS server will check the contents of these file after specific time intervals

## Volume Options

1. Enabling export/netgroup feature

```

gluster volume set <volname> nfs.exports-auth-enable on
```

1. Changing the refresh interval for gluster NFS server

```

gluster volume set <volname> nfs.auth-refresh-interval-sec <time in seconds>
```

1. Changing the cache interval for an export entry

```

gluster volume set <volname> nfs.auth-cache-ttl-sec <time in seconds>
```

## Testing the export/netgroup file

An user should have the ability to check the validity of the files  before applying the configuration. The "glusterfsd" command now has the  following additional arguments that can be used to check the  configuration:

- --print-netgroups: Validate the netgroups file and print it out. For example,
- `glusterfsd --print-netgroups <name of the file>`
- --print-exports: Validate the exports file and print it out. For example,
- `glusterfsd --print-export <name of the file>`

## Points to be noted.

1. This feature does not currently support all the options in the man page of exports, but we can easily add them.
2. The files `/var/lib/glusterd/nfs/export` and `/var/lib/glusterd/nfs/netgroup` should be created before setting the `nfs.exports-auth-enable` option in every node in Trusted Storage Pool.
3. These files are handled manually by the users. So that, their  contents can be different among the gluster nfs servers across Trusted  Storage Pool . i.e it is possible to have different authenticate  mechanism for the gluster NFS servers in the same cluster.
4. Do not mixup this feature and authentication using `nfs.rpc-auth-allow`, `nfs.export-dir` which may result in inconsistency.

## Troubleshooting

After changing the contents of the file, if it is not reflected  properly in the authentication mechanism , just restart the server using volume stop and start, So that gluster NFS server will forcefully read  the contents of those files again.

# Consul and GlusterFS integration

[Consul](https://www.consul.io/) is used for service discovery and configuration.

It consists of consul server and agents connecting to it. Apps can get configuration data from consul via HTTP API or DNS queries.

Long story short, instead of using standard hostnames and relying on official DNS servers which we may not control, we can use consul to resolve hosts with services under `.consul` domain, which turns this classic setup:

```

mount -t glusterfs -o backupvolfile-server=gluster-poc-02 gluster-poc-01:/g0 /mnt/gluster/g0
```

into more convenient entry:

```

mount -t glusterfs gluster.service.consul:/g0 /mnt/gluster/g0
```

which is especially useful when using image-based servers without  further provisioning, and spreading load across all healthy servers  registered in consul.

# Warning

In this document you will get a proof-of-concept basic setup - gluster servers and gluster clients configured, which should be a point to expand. You should read [Further steps](https://docs.gluster.org/en/latest/Administrator-Guide/Consul/#further-steps-for-improvements) section to harden it.

Tested on:

- isolated virtual network
- selinux permissive (yay!)
- consul server/agents version `v0.7.5`
- gluster servers with glusterfs 3.8.x on CentOS 7.3 + samba 4 with simple auth and vfs gluster module
- gluster volume set as distributed-replicated + 'features.shard: true' and 'features.shard-block-size: 512MB'
- gluster agents with glusterfs 3.8.x on Ubuntu 14.04
- gluster agents with glusterfs 3.8.x on CentOS 7.3
- gluster agents with glusterfs 3.7.x on CentOS 5.9
- Windows 2012R2 connected to gluster servers via samba

# Scenario

We want to create shared storage accessible via different operating systems - Linux and Windows.

- we do not control DNS server so we cannot add/remove entries on gluster server add/remove
- gluster servers are in the gluster pool and have gluster volume created named `g0`
- gluster servers have consul agent installed, and they will register to consul as `gluster` service
- gluster servers have also SMB installed with very simple setup using gluster vfs plugin
- gluster client have consul agent installed, and they will use `gluster.service.consul` as entry point.
- DNS resolution under Linux will be handled via dnsmasq
- DNS resolution under Windows will be handled via consul itself

# Known limitations

- consul health checks introduce delay, also remember that consul can cache DNS entries to increase performance
- the way Windows share works is that it will connect to one of the samba servers, if this server die then transfers are  aborted, and we must retry operation, but watch out for delay.
- anything other than gluster volume distributed-replicated was not tested - it may not work for Windows.

# Requirements

- you should have consul server (or cluster) up and running, and the best, also accessible via default HTTP port.
- you should have gluster servers already joined in the gluster pool, bricks and volume configured.
- check you firewall rules for outbound and inbound for DNS, gluster, samba, consul
- make yourself familiar with [consul documentation](https://www.consul.io/docs/index.html) (or specific branch on github)

# Linux setup

## Consul agent on Linux on gluster clients

First, install consul agent. The best way is to use for example [puppet module](https://github.com/solarkennedy/puppet-consul) In general your Linux boxes should register in the consul server and be visible under `Nodes` section.

To verify if consul agent is working properly, you can query its DNS interface, asking it to list consul servers:

```

[centos@gluster-poc-01]# dig consul.service.consul 127.0.0.1:8600

; <<>> DiG 9.9.4-RedHat-9.9.4-38.el7_3.3 <<>> consul.service.consul 127.0.01:8600
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 39354
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;consul.service.consul.     IN  A

;; ANSWER SECTION:
consul.service.consul.  0   IN  A   172.30.64.198
consul.service.consul.  0   IN  A   172.30.82.255
consul.service.consul.  0   IN  A   172.30.81.155

;; Query time: 1 msec
;; SERVER: 127.0.0.1#53(127.0.0.1)
;; WHEN: Sat May 20 08:50:21 UTC 2017
;; MSG SIZE  rcvd: 87

;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 22224
;; flags: qr rd ra ad; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;127.0.0.1:8600.            IN  A

;; Query time: 0 msec
;; SERVER: 127.0.0.1#53(127.0.0.1)
;; WHEN: Sat May 20 08:50:21 UTC 2017
;; MSG SIZE  rcvd: 32
```

Now, to be able to use it on system level, we want it to work without specifying port. We can achieve it with running consul on port 53 (not advised), or  redirecting network traffic from port 53 to 8600 or proxy it via local  DNS resolver - for example use locally installed dnsmasq.

First, install dnsmasq, and add file `/etc/dnsmasq.d/10-consul`:

```

server=/consul/127.0.0.1#8600
```

This will ensure that any `*.consul` requests will be forwarded to local consul listening on its default DNS port 8600.

Make sure that `/etc/resolv.conf` contains `nameserver 127.0.0.1`. Under Debian distros it should be there, under RedHat - not really. You can fix this in two ways, choose on your onw which one to apply:

- add `nameserver 127.0.0.1` to `/etc/resolvconf/resolv.conf.d/header`

or

- update `/etc/dhcp/dhclient.conf` and add to it line `prepend domain-name-servers 127.0.0.1;`.

In both cases it ensures that dnsmasq will be a first nameserver, and requires reloading resolver or networking.

Eventually you should have `nameserver 127.0.0.1` set as first entry in `/etc/resolv.conf` and have DNS resolving consul entries:

```

[centos@gluster-poc-01]# dig consul.service.consul

; <<>> DiG 9.9.4-RedHat-9.9.4-38.el7_3.3 <<>> consul.service.consul
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 42571
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;consul.service.consul.     IN  A

;; ANSWER SECTION:
consul.service.consul.  0   IN  A   172.30.64.198
consul.service.consul.  0   IN  A   172.30.82.255
consul.service.consul.  0   IN  A   172.30.81.155

;; Query time: 1 msec
;; SERVER: 127.0.0.1#53(127.0.0.1)
;; WHEN: Sat May 20 09:01:12 UTC 2017
;; MSG SIZE  rcvd: 87
```

From now on we should be able to use `<servicename>.service.consul` in places, where we had FQDN entries of the single servers.

Next, we must define gluster service consul on the servers.

## Consul agent on Linux on gluster servers

Install consul agent as described in previous section.

You can define consul services as `gluster` to run health checks, to do that we must add consul to sudoers or allow it executing certain sudo commands without password:

`/etc/sudoers.d/99-consul.conf`:

```

consul ALL=(ALL) NOPASSWD: /sbin/gluster pool list
```

First, lets define service in consul, it will be very basic, without volume names. Service name `gluster`, with default port 24007, and we will tag it as `gluster` and `server`.

Our service will have [service health checks](https://www.consul.io/docs/agent/checks.html) every 10s:

- check if the gluster service is responding to TCP on 24007 port
- check if the gluster server is connected to other peers in the pool  (to avoid registering as healthy service which is actaully not serving  anything)

Below is an example of `/etc/consul/service_gluster.json`:

```

{
  "service": {
    "address": "",
    "checks": [
      {
        "interval": "10s",
        "tcp": "localhost:24007",
        "timeout": "5s"
      },
      {
        "interval": "10s",
        "script": "/bin/bash -c \"sudo -n /sbin/gluster pool list |grep -v UUID|grep -v localhost|grep Connected\"",
        "timeout": "5s"
      }
    ],
    "enableTagOverride": false,
    "id": "gluster",
    "name": "gluster",
    "port": 24007,
    "tags": ["gluster", "server"]
  }
}
```

Restart consul service and you should see gluster servers in consul web ui. After a while service should be in healthy stage and be available under nslookup:

```

[centos@gluster-poc-02]# nslookup gluster.service.consul
Server:     127.0.0.1
Address:    127.0.0.1#53

Name:   gluster.service.consul
Address: 172.30.64.144
Name:   gluster.service.consul
Address: 172.30.65.61
```

Notice that gluster server can be also gluster client, for example if we want to mount gluster volume on the servers.

## Mounting gluster volume under Linux

As a moutpoint we would usually select one of the gluster servers, and another as backup server, like this:

```

mount -t glusterfs -o backupvolfile-server=gluster-poc-02 gluster-poc-01:/g0 /mnt/gluster/g0
```

This is a bit inconvenient, for example we have an image with hardcoded hostnames, and old servers are gone due to maintenance. We would have to recreate image, or reconfigure existing nodes if they unmount gluster storage.

To mitigate that issue we can now use consul for fetching the server pool:

```

mount -t glusterfs gluster.service.consul:/g0 /mnt/gluster/g0
```

So we can populate that to `/etc/fstab` or one of the `autofs` files.

# Windows setup

## Configuring gluster servers as samba shares

This is the simplest and not so secure setup, you have been warned.

Proper setup suggests using LDAP or [CTDB](https://ctdb.samba.org/). You can configure it with puppet using module [kakwa-samba](https://github.com/kakwa/puppet-samba).

First, we want to reconfigure gluster servers so that they serve as  samba shares using user/pass credentials, which is separate to Linux  credentials.

We assume that accessing windows share will be done as user `steve` with password `steve-loves-bacon`, make sure you create that user on each gluster server host.

```

sudo adduser steve
sudo smbpasswd -a steve
```

Notice that if you do not set `user.smb = disable` in gluster volume then it may auto-add itself to samba configuration. So better disable this by executing:

```

gluster volume get g0 user.smb disable
```

Now install `samba` and `samba-vfs-glusterfs` packages and configure `/etc/samba/smb.conf`:

```

[global]
workgroup = test
security = user
min protocol = SMB2
netbios name = gluster
realm = test
vfs objects = acl_xattr
map acl inherit = Yes
store dos attributes = Yes
log level = 1
dedicated keytab file = /etc/krb5.keytab
map untrusted to domain = Yes

[vfs-g0]
guest only = no
writable = yes
guest ok = no
force user = steve
create mask = 0666
directory mask = 0777
comment = Gluster via VFS (native gluster)
path = /
vfs objects = glusterfs
glusterfs:volume = g0
kernel share modes = no
glusterfs:loglevel = 7
glusterfs:logfile = /var/log/samba/glusterfs-g0.%M.log
browsable = yes
force group = steve
```

Some notes:

- when using vfs plugin then `path` is a relative path via gluster volume.
- `kernel share modes = no` may be required to make it work.

We can also use classic fuse mount and use it under samba as share path, then configuration is even simpler.

For detailed description between those two solutions see [gluster vfs blog posts](https://lalatendu.org/2014/04/20/glusterfs-vfs-plugin-for-samba/).

- Remember to add user steve to samba with a password
- unblock firewall ports for samba
- test samba config and reload samba

## Defining new samba service under consul

Now we define gluster-samba service on gluster server hosts in a similiar way as we defined it for gluster itself.

Below is an example of `/etc/consul/service_samba.json`:

```

{
  "service": {
    "address": "",
    "checks": [
      {
        "interval": "10s",
        "tcp": "localhost:139",
        "timeout": "5s"
      },
      {
        "interval": "10s",
        "tcp": "localhost:445",
        "timeout": "5s"
      }
    ],
    "enableTagOverride": false,
    "id": "gluster-samba",
    "name": "gluster-samba",
    "port": 139,
    "tags": ["gluster", "samba"]
  }
}
```

We have two health checks here, just checking if we can connect to  samba service. It could be also expanded to see if the network share is  actually accessible.

Reload consul service and you should after a while see new service registered in the consul. Check if it exists in dns:

```

nslookup gluster-samba.service.consul

Server:     127.0.0.1
Address:    127.0.0.1#53

Name:   gluster-samba.service.consul
Address: 172.30.65.61
Name:   gluster-samba.service.consul
Address: 172.30.64.144
```

Install `samba-client` and check connectivity to samba from gluster server itself.

```

[centos@gluster-poc-01]# smbclient -L //gluster-samba.service.consul/g0 -U steve
Enter steve's password:
Domain=[test] OS=[Windows 6.1] Server=[Samba 4.4.4]

    Sharename       Type      Comment
    ---------       ----      -------
    vfs-g0          Disk      Gluster via VFS (native gluster)
    IPC$            IPC       IPC Service (Samba 4.4.4)
Domain=[test] OS=[Windows 6.1] Server=[Samba 4.4.4]

    Server               Comment
    ---------            -------

    Workgroup            Master
    ---------            -------
```

Now check if we can list share directory as `steve`:

```

smbclient //gluster-samba.service.consul/vfs-g0/ -U steve -c ls

Enter steve's password:
Domain=[test] OS=[Windows 6.1] Server=[Samba 4.4.4]
  .                                   D        0  Wed May 17 20:48:06 2017
  ..                                  D        0  Wed May 17 20:48:06 2017
  .trashcan                          DH        0  Mon May 15 15:41:37 2017
  CentOS-7-x86_64-Everything-1611.iso      N 8280604672  Mon Dec  5 13:57:33 2016
  hello.world                         D        0  Fri May 19 08:54:02 2017
  ipconfig.all.txt                    A     2931  Wed May 17 20:18:52 2017
  nslookup.txt                        A      126  Wed May 17 20:19:13 2017
  net.view.txt                        A      315  Wed May 17 20:47:44 2017

        463639360 blocks of size 1024. 447352464 blocks available
```

Notice that this might take a few seconds, because when we try to  connect to the share, samba vfs connects to the gluster servers as  agent.

Looks good, time to configure Windows.

## Installing Consul agent on Windows

Log in as administrator and install consul agent on the Windows machine, the easiest way is to use chocolatey.

- install [chocolatey](https://chocolatey.org/install) and use preferred installation method, for example via `cmd.exe`
- optionally install some tools via chocolatey to edit files:

```

chocolatey install notepadplusplus
```

- install consul as agent with specific version and configs to load:

```

chocolatey install consul --version 0.7.5 -params '-config-dir "%PROGRAMDATA%\consul\"'
```

- stop consul service in command prompt:

```

net stop consul
```

- edit consul config `%PROGRAMDATA%\consul\config.json`:

```

start notepad++.exe "%PROGRAMDATA%\consul\config\config.json"
```

fill it with data (description below):

```

{
  "datacenter": "virt-gluster",
  "retry_join": ["192.178.1.11", "192.178.1.12", "192.178.1.13"],
  "recursors": ["8.8.8.8", "8.8.4.4"],
  "ports": {
    "dns": 53
  }
}
```

Remember to replace `datacenter`, `recursors` with preferred local DNS servers and `retry_join` with list of consul server hosts or for example some generic Route53  entry from private zone (if it exists) which points to real consul  servers.

In AWS you can also use `retry_join_ec2` - his way Windows instance will always search other consul server EC2 instances and join them.

Notice that recursors section is required if not using retry_join and just relying on AWS EC2 tags - otherwise consul will fail to resolve  anything else, thus not joining to the consul.

We use port `53` so that consul will serve as local DNS.

- start consul service

```

net start consul
```

- update DNS settings for network interface in Windows, make it the primary entry

```

netsh interface ipv4 add dnsserver \"Ethernet\" address=127.0.0.1 index=1
```

- verify that DNS Servers is pointing to localhost:

```

ipconfig /all

Windows IP Configuration

    Host Name . . . . . . . . . . . . : WIN-S8N782O8GG3
    ...
    ...
    DNS Servers . . . . . . . . . . . : 127.0.0.1
    ...
    ...
```

- verify that consul resolves some services:

```

nslookup gluster.service.consul

nslookup gluster-samba.service.consul

Server:  UnKnown
Address:  127.0.0.1

Name:    gluster-samba.service.consul
Addresses:  172.30.65.61
            172.30.64.144
```

## Mounting gluster volume under Windows

We have running gluster servers with volume and samba share, registered in consul. We have Windows with running consul agent. All hosts are registered in consul and can connect to each other.

- verify that samba can see network share:

```

net view \\gluster-samba.service.consul

Shared resources at \\gluster-samba.service.consul

Samba 4.4.4

Share name  Type  Used as  Comment

-------------------------------------------------------------------------------
vfs-g0      Disk           Gluster via VFS (native gluster)
The command completed successfully.
```

- mount network share, providing credentials for gluster samba share:

```

net use s: \\gluster-samba.service.consul\vfs-g0 /user:steve password: steve-loves-bacon /persistent:yes
```

If mounting fails due to error message: `System error 1219 has occurred. Multiple connections to a server  or shared resource by the same user, using more than one user name, are  not allowed....` then you must delete existing connections, for example:

```

net use /delete \\gluster-samba.service.consul\IPC$
```

And then retry the `net use` commands again.

From now on this windows share should reconnect to the random gluster samba server, if it is healthy.

Enjoy.

# Further steps for improvements

Below is a list of things to improve:

- enable selinux
- harden samba setup on gluster servers to use domain logons
- use consul ACL lists to control access to consul data
- export gluster volumes as key/value in consul, use consul-template to create mountpoints on consul updates - in autofs/ samba mounts/unmounts
- expand consul health checks with more detailed checks, like:
- better checking if gluster volume exists etc
- if samba share is accessible by the client (to avoid situation samba tries to share non-mounted volume)

# Split brain and the ways to deal with it

### Split brain:

Split brain is a situation where two or more replicated copies of a  file become divergent. When a file is in split brain, there is an  inconsistency in either data or metadata of the file amongst the bricks  of a replica and do not have enough information to authoritatively pick a copy as being pristine and heal the bad copies, despite all bricks  being up and online. For a directory, there is also an entry split brain where a file inside it can have different gfid/file-type across the  bricks of a replica. Split brain can happen mainly because of 2 reasons:

- Due to network disconnect Where a client temporarily loses connection to the bricks.

> 1. There is a replica pair of 2 bricks, brick1 on server1 and brick2 on server2.
> 2. Client1 loses connection to brick2 and client2 loses connection to brick1 due to network split.
> 3. Writes from client1 goes to brick1 and from client2 goes to brick2, which is nothing but split-brain.

- Gluster brick processes going down or returning error:

> 1. Server1 is down and server2 is up: Writes happen on server 2.
> 2. Server1 comes up, server2 goes down (Heal not happened / data on  server 2 is not replicated on server1): Writes happen on server1.
> 3. Server2 comes up: Both server1 and server2 has data independent of each other.

If we use the `replica 2` volume, it is not possible to prevent split-brain without losing availability.

### Ways to deal with split brain:

In glusterfs there are ways to resolve split brain. You can see the detailed description of how to resolve a split-brain [here](https://docs.gluster.org/en/latest/Troubleshooting/resolving-splitbrain/). Moreover, there are ways to reduce the chances of ending up in split-brain situations. They are:

1. Replica 3 volume
2. Arbiter volume

Both of these use the client-quorum option of glusterfs to avoid the split-brain situations.

### Client quorum:

This is a feature implemented in Automatic File Replication (AFR here on) module, to prevent split-brains in the I/O path for  replicate/distributed-replicate volumes. By default, if the  client-quorum is not met for a particular replica subvol, it becomes  read-only. The other subvols (in a dist-rep volume) will still have R/W  access. [Here](https://docs.gluster.org/en/latest/Administrator-Guide/arbiter-volumes-and-quorum/#client-quorum) you can see more details about client-quorum.

#### Client quorum in replica 2 volumes:

In a replica 2 volume it is not possible to achieve high availability and consistency at the same time, without sacrificing tolerance to  partition. If we set the client-quorum option to auto, then the first  brick must always be up, irrespective of the status of the second brick. If only the second brick is up, the subvolume becomes read-only. If the quorum-type is set to fixed, and the quorum-count is set to 1,  then we may end up in split brain. - Brick1 is up and brick2 is down.  Quorum is met and write happens on brick1. - Brick1 goes down and brick2 comes up (No heal happened). Quorum is met, write happens on brick2. -  Brick1 comes up. Quorum is met, but both the bricks have independent  writes - split-brain. To avoid this we have to set the quorum-count to 2, which will cost the  availability. Even if we have one replica brick up and running, the  quorum is not met and we end up seeing EROFS.

### 1. Replica 3 volume:

When we create a replicated or distributed replicated volume with  replica count 3, the cluster.quorum-type option is set to auto by  default. That means at least 2 bricks should be up and running to  satisfy the quorum and allow the writes. This is the recommended setting for a replica 3 volume and this should not be changed. Here is how it  prevents files from ending up in split brain:

B1, B2, and B3 are the 3 bricks of a replica 3 volume.

1. B1 & B2 are up and B3 is down. Quorum is met and write happens on B1 & B2.
2. B3 comes up and B2 is down. Quorum is met and write happens on B1 & B3.
3. B2 comes up and B1 goes down. Quorum is met. But when a write  request comes, AFR sees that B2 & B3 are blaming each other (B2 says that some writes are pending on B3 and B3 says that some writes are  pending on B2), therefore the write is not allowed and is failed with  EIO.

Command to create a replica 3 volume:

```

gluster volume create <volname> replica 3 host1:brick1 host2:brick2 host3:brick3
```

### 2. Arbiter volume:

Arbiter offers the sweet spot between replica 2 and replica 3, where  user wants the split-brain protection offered by replica 3 but does not  want to invest in 3x storage space. Arbiter is also an replica 3 volume  where the third brick of the replica is automatically configured as an  arbiter node. This means that the third brick stores only the file name  and metadata, but not any data. This will help in avoiding split brain  while providing the same level of consistency as a normal replica 3  volume.

Command to create a arbiter volume:

```

gluster volume create <volname> replica 3 arbiter 1 host1:brick1 host2:brick2 host3:brick3
```

The only difference in the command is, we need to add one more keyword `arbiter 1` after the replica count. Since it is also a replica 3 volume, the  cluster.quorum-type option is set to auto by default and at least 2  bricks should be up to satisfy the quorum and allow writes. Since the arbiter brick has only name and metadata of the files, there  are some more checks to guarantee consistency. Arbiter works as follows:

1. Clients take full file locks while writing (replica 3 takes range locks).
2. If 2 bricks are up and if one of them is the arbiter, and it blames  the other up brick, then all FOPs will fail with ENOTCONN (Transport  endpoint is not connected). If the arbiter doesn't blame the other  brick, FOPs will be allowed to proceed.
3. If 2 bricks are up and the arbiter is down, then FOPs will be allowed.
4. If only one brick is up, then client-quorum is not met and the volume becomes EROFS.
5. In all cases, if there is only one source before the FOP is  initiated and if the FOP fails on that source, the application will  receive ENOTCONN.

You can find more details on arbiter [here](https://docs.gluster.org/en/latest/Administrator-Guide/arbiter-volumes-and-quorum/).

### Differences between replica 3 and arbiter volumes:

1. In case of a replica 3 volume, we store the entire file in all the  bricks and it is recommended to have bricks of same size. But in case of arbiter, since we do not store data, the size of the arbiter brick is  comparatively lesser than the other bricks.
2. Arbiter is a state between replica 2 and replica 3 volume. If we  have only arbiter and one of the other brick is up and the arbiter brick blames the other brick, then we can not proceed with the FOPs.
3. Replica 3 gives high availability compared to arbiter, because  unlike in arbiter, replica 3 has a full copy of the data in all 3  bricks.

# Arbiter volumes and quorum options in gluster

The arbiter volume is a special subset of replica volumes that is aimed at preventing split-brains and providing the same consistency guarantees as a normal replica 3 volume without consuming 3x space.

- [Arbiter volumes and quorum options in gluster](https://docs.gluster.org/en/latest/Administrator-Guide/arbiter-volumes-and-quorum/#arbiter-volumes-and-quorum-options-in-gluster)
- [Arbiter configuration](https://docs.gluster.org/en/latest/Administrator-Guide/arbiter-volumes-and-quorum/#arbiter-configuration)
- [Arbiter brick(s) sizing](https://docs.gluster.org/en/latest/Administrator-Guide/arbiter-volumes-and-quorum/#arbiter-bricks-sizing)
- [Why Arbiter?](https://docs.gluster.org/en/latest/Administrator-Guide/arbiter-volumes-and-quorum/#why-arbiter)
- [Split-brains in replica volumes](https://docs.gluster.org/en/latest/Administrator-Guide/arbiter-volumes-and-quorum/#split-brains-in-replica-volumes)
- [Server-quorum and some pitfalls](https://docs.gluster.org/en/latest/Administrator-Guide/arbiter-volumes-and-quorum/#server-quorum-and-some-pitfalls)
- [Client Quorum](https://docs.gluster.org/en/latest/Administrator-Guide/arbiter-volumes-and-quorum/#client-quorum)
- [Replica 2 and Replica 3 volumes](https://docs.gluster.org/en/latest/Administrator-Guide/arbiter-volumes-and-quorum/#replica-2-and-replica-3-volumes)
- [How Arbiter works](https://docs.gluster.org/en/latest/Administrator-Guide/arbiter-volumes-and-quorum/#how-arbiter-works)

# Arbiter configuration

The syntax for creating the volume is:

```console
gluster volume create <VOLNAME>  replica 2 arbiter 1 <NEW-BRICK> ...
```

**Note**: The earlier syntax used to be `replica 3 arbiter 1` but that was leading to confusions among users about the total no. of data bricks. For the sake of backward compatibility, the old syntax also works. In any case, the implied meaning is that there are 2 data bricks and 1 arbiter brick in a nx(2+1) arbiter volume.

For example:

```

gluster volume create testvol replica 2 arbiter 1  server{1..6}:/bricks/brick
volume create: testvol: success: please start the volume to access data
```

This means that for every 3 bricks listed, 1 of them is an arbiter. We have created 6 bricks. With a replica count of three, each 3rd brick in the series will be a replica subvolume. Since we have two sets of 3, this created a distribute subvolume made of up two replica subvolumes.

Each replica subvolume is defined to have 1 arbiter out of the 3 bricks. The arbiter bricks are taken from the end of each replica subvolume.

```

gluster volume info
Volume Name: testvol
Type: Distributed-Replicate
Volume ID: ae6c4162-38c2-4368-ae5d-6bad141a4119
Status: Created
Number of Bricks: 2 x (2 + 1) = 6
Transport-type: tcp
Bricks:
Brick1: server1:/bricks/brick
Brick2: server2:/bricks/brick
Brick3: server3:/bricks/brick (arbiter)
Brick4: server4:/bricks/brick
Brick5: server5:/bricks/brick
Brick6: server6:/bricks/brick (arbiter)
Options Reconfigured  :
transport.address-family: inet
performance.readdir-ahead: on
```

The arbiter brick will store only the file/directory names (i.e. the tree structure) and extended attributes (metadata) but not any data. i.e. the file size (as shown by `ls -l`) will be zero bytes. It will also store other gluster metadata like the `.glusterfs` folder and its contents.

***Note:** Enabling the arbiter feature **automatically** configures* *client-quorum to 'auto'. This setting is **not** to be changed.*

## Arbiter brick(s) sizing

Since the arbiter brick does not store file data, its disk usage will be considerably smaller than for the other bricks of the replica. The sizing of the brick will depend on how many files you plan to store in the volume. A good estimate will be 4KB times the number of files in the replica. Note that the estimate also depends on the inode space alloted by the underlying filesystem for a given disk size.

The `maxpct` value in XFS for volumes of size 1TB to 50TB is only 5%. If you want to store say 300 million files, 4KB x 300M gives us 1.2TB. 5% of this is around 60GB. Assuming the recommended inode size of 512 bytes, that gives us the ability to store only 60GB/512 ~= 120 million files. So it is better to choose a higher `maxpct` value (say 25%) while formatting an XFS disk of size greater than 1TB. Refer the man page of `mkfs.xfs` for details.

# Why Arbiter?

## Split-brains in replica volumes

When a file is in split-brain, there is an inconsistency in either data or metadata (permissions, uid/gid, extended attributes etc.) of the file amongst the bricks of a replica *and* we do not have enough information to authoritatively pick a copy as being pristine and heal to the bad copies, despite all bricks being up and online. For directories, there is also an entry-split brain where a file inside it has different gfids/ file-type (say one is a file and another is a directory of the same name) across the bricks of a replica.

This [document](https://github.com/gluster/glusterfs-specs/blob/master/done/Features/heal-info-and-split-brain-resolution.md) describes how to resolve files that are in split-brain using gluster cli or the mount point. Almost always, split-brains occur due to network disconnects (where a client temporarily loses connection to the bricks) and very rarely due to the gluster brick processes going down or returning an error.

## Server-quorum and some pitfalls

This [document](https://docs.gluster.org/en/latest/Administrator-Guide/arbiter-volumes-and-quorum/#server-quorum-and-some-pitfalls) provides a detailed description of this feature. The volume options for server-quorum are:

> Option: **cluster.server-quorum-ratio**
>  Value Description: 0 to 100
>
> Option: **cluster.server-quorum-type**
>  Value Description: none | server
>  If set to server, this option enables the specified volume to participate in the server-side quorum. If set to none, that volume alone is not considered for volume checks.

The cluster.server-quorum-ratio is a percentage figure and is cluster wide- i.e. you cannot have different ratio for different volumes in the same trusted pool.

For a two-node trusted storage pool, it is important to set this value greater than 50%, so that two nodes separated from each other do not believe they have quorum simultaneously. For a two-node plain replica volume, this would mean both nodes need to be up and running. So there is no notion of HA/failover.

There are users who create a `replica 2` volume from 2 nodes and peer-probe a 'dummy' node without bricks and enable server quorum with a ratio of 51%. This does not prevent files from getting into split-brain. For example, if B1 and B2 are the bricks/nodes of the replica and B3 is the dummy node, we can still end up in split-brain like so:

1. B1 goes down, B2 and B3 are up. Server-quorum is still. File is modified   by the client.
2. B2 goes down, B1 comes back up. Server-quorum is met. Same file is modified   by the client.
3. We now have different contents for the file in B1 and B2 ==>split-brain.

In author’s opinion, server-quorum is useful if you want to avoid split-brains to the volume(s) configuration across the nodes and not in the I/O path. Unlike in client-quorum where the volume becomes read-only when quorum is lost, loss of server-quorum in a particular node makes glusterd kill the brick processes on that node (for the participating volumes) making even reads impossible.

## Client Quorum

Client-quorum is a feature implemented in AFR to prevent split-brains in the I/O path for replicate/distributed-replicate volumes. By default, if the client-quorum is not met for a particular replica subvol, it becomes unavailable. The other subvols (in a dist-rep volume) will still have R/W access.

The following volume set options are used to configure it:

> Option: **cluster.quorum-type**
>  Default Value: none
>  Value Description: none|auto|fixed
>  If set to "fixed", this option allows writes to a file only if the number of active bricks in that replica set (to which the file belongs) is greater than or equal to the count specified in the 'quorum-count' option. If set to "auto", this option allows write to the file only if number of bricks that are up >= ceil (of the total number of bricks that constitute that replica/2). If the number of replicas is even, then there is a further check: If the number of up bricks is exactly equal to n/2, then the first brick must be one of the bricks that are up. If it is more than n/2 then it is not necessary that the first brick is one of the up bricks.
>
> Option: **cluster.quorum-count**
>  Value Description:
>  The number of bricks that must be active in a replica-set to allow writes. This option is used in conjunction with cluster.quorum-type *=fixed* option to specify the number of bricks to be active to participate in quorum. If the quorum-type is auto then this option has no significance.

Earlier, when quorm was not met, the replica subvolume turned read-only. But since [glusterfs-3.13](https://docs.gluster.org/en/latest/release-notes/3.13.0/#addition-of-checks-for-allowing-lookups-in-afr-and-removal-of-clusterquorum-reads-volume-option) and upwards, the subvolume becomes unavailable, i.e. all the file operations fail with ENOTCONN error instead of becoming EROFS. This means the `cluster.quorum-reads` volume option is also not supported.

## Replica 2 and Replica 3 volumes

From the above descriptions, it is clear that client-quorum cannot really be applied to a `replica 2` volume (without costing HA). If the quorum-type is set to auto, then by the description given earlier, the first brick must always be up, irrespective of the status of the second brick. IOW, if only the second brick is up, the subvol returns ENOTCONN, i.e. no HA. If quorum-type is set to fixed, then the quorum-count *has* to be two to prevent split-brains (otherwise a write can succeed in brick1, another in brick2 =>split-brain). So for all practical purposes, if you want high availability in a `replica 2` volume, it is recommended not to enable client-quorum.

In a `replica 3` volume, client-quorum is enabled by default and set to 'auto'. This means 2 bricks need to be up for the write to succeed. Here is how this configuration prevents files from ending up in split-brain:

Say B1, B2 and B3 are the bricks:

1. B3 is down, quorum is met, write happens on file B1 and B2.
2. B3 comes up, B2 is down, quorum is again met, write happens on B1 and B3.
3. B2 comes up, B1 goes down, quorum is met. Now when a write is issued, AFR sees   that B2 and B3's pending xattrs blame each other and therefore the write is not   allowed and is failed with ENOTCONN.

# How Arbiter works

There are 2 components to the arbiter volume. One is the arbiter xlator that is loaded in the brick process of every 3rd (i.e. the arbiter) brick. The other is the arbitration logic itself that is present in AFR (the replicate xlator) loaded on the clients.

The former acts as a sort of 'filter' translator for the FOPS- i.e. it allows entry operations to hit POSIX, blocks certain inode operations like read (unwinds the call with ENOTCONN) and unwinds other inode operations like write, truncate etc. with success without winding it down to POSIX.

The latter i.e. the arbitration logic present in AFR takes full file locks when writing to a file, just like in normal replica volumes. The behavior of arbiter volumes in allowing/failing write FOPS in conjunction with client-quorum can be summarized in the below steps:

- If all 3 bricks are up (happy case), then there is no issue and the FOPs are allowed.
- If 2 bricks are up and if one of them is the arbiter (i.e. the 3rd brick) *and*  it blames the other up brick for a given file, then all write FOPS will fail  with ENOTCONN. This is because, in this scenario, the only true copy is on the  brick that is down. Hence we cannot allow writes until that brick is also up.  If the arbiter doesn't blame the other brick, FOPS will be allowed to proceed.  'Blaming' here is w.r.t the values of AFR changelog extended attributes.
- If 2 bricks are up and the arbiter is down, then FOPS will be allowed.  When the arbiter comes up, the entry/metadata heals to it happen. Of course data  heals are not needed.
- If only one brick is up, then client-quorum is not met and the volume returns ENOTCONN.
- In all cases, if there is only one source before the FOP is initiated  (even if all bricks are up) and if the FOP fails on that source, the  application will receive ENOTCONN. For example, assume that a write failed on B2  and B3, i.e. B1 is the only source. Now if for some reason, the second write  failed on B1 (before there was a chance for selfheal to complete despite all brick  being up), the application would receive failure (ENOTCONN) for that write.

The bricks being up or down described above does not necessarily mean the brick process is offline. It can also mean the mount lost the connection to the brick due to network disconnects etc.

# Thin Arbiter volumes in gluster

Thin Arbiter is a new type of quorum node where granularity of what is good and what is bad data is less compared to the traditional arbiter brick. In this type of volume, quorum is taken into account at a brick level rather than per file basis. If there is even one file that is marked bad (i.e. needs healing) on a data brick, that brick is considered bad for all files as a whole. So, even different file, if the write fails on the other data brick but succeeds on this 'bad' brick we will return failure for the write.

- [Thin Arbiter volumes in gluster](https://docs.gluster.org/en/latest/Administrator-Guide/Thin-Arbiter-Volumes/#thin-arbiter-volumes-in-gluster)
- [Why Thin Arbiter?](https://docs.gluster.org/en/latest/Administrator-Guide/Thin-Arbiter-Volumes/#why-thin-arbiter)
- [Setting UP Thin Arbiter Volume](https://docs.gluster.org/en/latest/Administrator-Guide/Thin-Arbiter-Volumes/#setting-up-thin-arbiter-volume)
- [How Thin Arbiter works](https://docs.gluster.org/en/latest/Administrator-Guide/Thin-Arbiter-Volumes/#how-thin-arbiter-works)

# Why Thin Arbiter?

This is a solution for handling stretch cluster kind of workload, but it can be used for regular workloads as well in case users are satisfied with this kind of quorum in comparison to arbiter/3-way-replication. Thin arbiter node can be placed outside of trusted storage pool i.e, thin arbiter is the "stretched" node in the cluster. This node can be placed on cloud or anywhere even if that connection has high latency. As this node will take part only in case of failure (or a brick is down) and to decide the quorum, it will not impact the performance in normal cases. Cost to perform any file operation would be lesser than arbiter if everything is fine. I/O will only go to the data bricks and goes to thin-arbiter only in the case of first failure until heal completes.

# Setting UP Thin Arbiter Volume

The command to run thin-arbiter process on node:

```

/usr/local/sbin/glusterfsd -N --volfile-id ta-vol -f /var/lib/glusterd/vols/thin-arbiter.vol --brick-port 24007 --xlator-option ta-vol-server.transport.socket.listen-port=24007
```

Creating a thin arbiter replica 2 volume:

```

glustercli volume create <volname> --replica 2 <host1>:<brick1> <host2>:<brick2> --thin-arbiter <quorum-host>:<path-to-store-replica-id-file>
```

For example:

```

glustercli volume create testvol --replica 2 server{1..2}:/bricks/brick-{1..2} --thin-arbiter server-3:/bricks/brick_ta --force
volume create: testvol: success: please start the volume to access data
```

# How Thin Arbiter works

There will be only one process running on thin arbiter node which will be used to update replica id file for all replica pairs across all volumes. Replica id file contains the information of good and bad data bricks in the form of xattrs. Replica pairs will use its respective replica-id file that is going to be created during mount.

1. Read Transactions:   Reads are allowed when quorum is met. i.e.
2. When all data bricks and thin arbiter are up: Perform lookup on data bricks to figure out good/bad bricks and  serve content from the good brick.
3. When one brick is up: Fail FOP with EIO.
4. Two bricks are up:  If two data bricks are up, lookup is done on data bricks to figure out good/bad bricks and content will be served  from the good brick. One lookup is enough to figure out good/bad copy of that file and keep this in inode context.  If one data brick and thin arbiter brick are up, xattrop is done on thin arbiter to get information of source (good)  brick. If the data brick, which is UP, has also been marked as source brick on thin arbiter, lookup on this file is  done on the data brick to check if the file is really healthy or not. If the file is good, data will be served from  this brick else an EIO error would be returned to user.
5. Write transactions:   Thin arbiter doesn’t participate in I/O, transaction will choose to wind operations on thin-arbiter brick to   make sure the necessary metadata is kept up-to-date in case of failures. Operation failure will lead to   updating the replica-id file on thin-arbiter with source/sink information in the xattrs just how it happens in AFR.

# Trash Translator

Trash translator will allow users to access deleted or truncated  files. Every brick will maintain a hidden .trashcan directory, which  will be used to store the files deleted or truncated from the respective brick. The aggregate of all those .trashcan directories can be accessed from the mount point. To avoid name collisions, a timestamp is appended to the original file name while it is being moved to the trash  directory.

## Implications and Usage

Apart from the primary use-case of accessing files deleted or  truncated by the user, the trash translator can be helpful for internal  operations such as self-heal and rebalance. During self-heal and  rebalance it is possible to lose crucial data. In those circumstances,  the trash translator can assist in the recovery of the lost data. The  trash translator is designed to intercept unlink, truncate and ftruncate fops, store a copy of the current file in the trash directory, and then perform the fop on the original file. For the internal operations, the  files are stored under the 'internal_op' folder inside the trash  directory.

## Volume Options

- ***`gluster volume set <VOLNAME> features.trash <on/off>`\***

This command can be used to enable a trash translator in a volume. If set to on, a trash directory will be created in every brick inside the  volume during the volume start command. By default, a translator is  loaded during volume start but remains non-functional. Disabling trash  with the help of this option will not remove the trash directory or even its contents from the volume.

- ***`gluster volume set <VOLNAME> features.trash-dir <name>`\***

This command is used to reconfigure the trash directory to a  user-specified name. The argument is a valid directory name. The  directory will be created inside every brick under this name. If not  specified by the user, the trash translator will create the trash  directory with the default name “.trashcan”. This can be used only when  the trash-translator is on.

- ***`gluster volume set <VOLNAME> features.trash-max-filesize <size>`\***

This command can be used to filter files entering the trash directory based on their size. Files above trash_max_filesize are  deleted/truncated directly. Value for size may be followed by  multiplicative suffixes as KB(=1024 bytes), MB(=1024*1024 bytes) ,and  GB(=1024*1024*1024 bytes). The default size is set to 5MB.

- ***`gluster volume set <VOLNAME> features.trash-eliminate-path <path1> [ , <path2> , . . . ]`\***

This command can be used to set the eliminate pattern for the trash  translator. Files residing under this pattern will not be moved to the  trash directory during deletion/truncation. The path must be a valid one present in the volume.

- ***`gluster volume set <VOLNAME> features.trash-internal-op <on/off>`\***

This command can be used to enable trash for internal operations like self-heal and re-balance. By default set to off.

## Sample usage

The following steps give illustrates a simple scenario of deletion of a file from a directory

1. Create a simple distributed volume and start it.

   ```
   
   ```

```
gluster volume create test rhs:/home/brick
gluster volume start test
```

Enable trash translator

```

gluster volume set test features.trash on
```

Mount glusterfs volume via native client as follows.

```

mount -t glusterfs  rhs:test /mnt
```

Create a directory and file in the mount.

```

mkdir mnt/dir
echo abc > mnt/dir/file
```

Delete the file from the mount.

```

rm mnt/dir/file -rf
```

Checkout inside the trash directory.

```

```

1. ```
   ls mnt/.trashcan
   ```

We can find the deleted file inside the trash directory with a timestamp appending on its filename.

For example,

```

mount -t glusterfs rh-host:/test /mnt/test
mkdir /mnt/test/abc
touch /mnt/test/abc/file
rm -f /mnt/test/abc/file

ls /mnt/test/abc

ls /mnt/test/.trashcan/abc/
```

You will see `file2014-08-21_123400` as the output of the last `ls` command.

#### Points to be remembered

- As soon as the volume is started, the trash directory will be  created inside the volume and will be visible through the mount.  Disabling the trash will not have any impact on its visibility from the  mount.
- Even though deletion of trash-directory is not permitted, currently  residing trash contents will be removed on issuing delete on it and only an empty trash-directory exists.

#### Known issue

Since trash translator resides on the server side higher translators  like AFR, DHT are unaware of rename and truncate operations being done  by this translator which eventually moves the files to trash directory.  Unless and until a complete-path-based lookup comes on trashed files,  those may not be visible from the mount.

# Tuning Volume Options



You can tune volume options, as needed, while the cluster is online and available.

> **Note**
>
> It is recommended to set server.allow-insecure option to ON if there are too many bricks in each volume or if there are too many services which have already utilized all the privileged ports in the system. Turning this option ON allows ports to accept/reject messages from insecure ports. So, use this option only if your deployment requires it.

Tune volume options using the following command:

```
# gluster volume set <VOLNAME> <OPT-NAME> <OPT-VALUE>
```

For example, to specify the performance cache size for test-volume:

```

# gluster volume set test-volume performance.cache-size 256MB
Set volume successful
```

You can view the changed volume options using command:

```
# gluster volume info
```

The following table lists the Volume options along with its description and default value:

> **Note**
>
> The default options given here are subject to modification at any given time and may not be the same for all versions.

| Type                                          | Option                                                       | Description                                                  | Default Value                                                | Available Options                       |
| --------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | --------------------------------------- |
| auth.allow                                    | IP addresses of the clients which should be allowed to access the volume. | * (allow all)                                                | Valid IP address which includes wild card patterns including *, such as 192.168.1.* |                                         |
| auth.reject                                   | IP addresses of the clients which should be denied to access the volume. | NONE (reject none)                                           | Valid IP address which includes wild card patterns including *, such as 192.168.2.* |                                         |
| Cluster                                       | cluster.self-heal-window-size                                | Specifies the maximum number of blocks per file on which self-heal would happen simultaneously. | 1                                                            | 0 - 1024 blocks                         |
| cluster.data-self-heal-algorithm              | Specifies the type of self-heal. If you set the option as "full",  the entire file is copied from source to destinations. If the option is  set to "diff" the file blocks that are not in sync are copied to  destinations. Reset uses a heuristic model. If the file does not exist  on one of the subvolumes, or a zero-byte file exists (created by entry  self-heal) the entire content has to be copied anyway, so there is no  benefit from using the "diff" algorithm. If the file size is about the  same as page size, the entire file can be read and written with a few  operations, which will be faster than "diff" which has to read checksums and then read and write. | reset                                                        | full/diff/reset                                              |                                         |
| cluster.min-free-disk                         | Specifies the percentage of disk space that must be kept free. Might be useful for non-uniform bricks | 10%                                                          | Percentage of required minimum free disk space               |                                         |
| cluster.min-free-inodes                       | Specifies when system has only N% of inodes remaining, warnings starts to appear in log files | 10%                                                          | Percentage of required minimum free inodes                   |                                         |
| cluster.stripe-block-size                     | Specifies the size of the stripe unit that will be read from or written to. | 128 KB (for all files)                                       | size in bytes                                                |                                         |
| cluster.self-heal-daemon                      | Allows you to turn-off proactive self-heal on replicated     | On                                                           | On/Off                                                       |                                         |
| cluster.ensure-durability                     | This option makes sure the data/metadata is durable across abrupt shutdown of the brick. | On                                                           | On/Off                                                       |                                         |
| cluster.lookup-unhashed                       | This option does a lookup through all the sub-volumes, in case a  lookup didn’t return any result from the hashed subvolume. If set to  OFF, it does not do a lookup on the remaining subvolumes. | on                                                           | auto, yes/no, enable/disable, 1/0, on/off                    |                                         |
| cluster.lookup-optimize                       | This option enables the optimization of -ve lookups, by not doing a  lookup on non-hashed subvolumes for files, in case the hashed subvolume  does not return any result. This option disregards the lookup-unhashed  setting, when enabled. | on                                                           | on/off                                                       |                                         |
| cluster.randomize-hash-range-by-gfid          | Allows to use gfid of directory to determine the subvolume from  which hash ranges are allocated starting with 0. Note that we still use a directory/file’s name to determine the subvolume to which it hashes | off                                                          | on/off                                                       |                                         |
| cluster.rebal-throttle                        | Sets the maximum number of parallel file migrations allowed on a  node during the rebalance operation. The default value is normal and  allows 2 files to be migrated at a time. Lazy will allow only one file  to be migrated at a time and aggressive will allow maxof[(((processing  units) - 4) / 2), 4] | normal                                                       | lazy/normal/aggressive                                       |                                         |
| cluster.background-self-heal-count            | Specifies the number of per client self-heal jobs that can perform parallel heals in the background. | 8                                                            | 0-256                                                        |                                         |
| cluster.heal-timeout                          | Time interval for checking the need to self-heal in self-heal-daemon | 600                                                          | 5-(signed-int)                                               |                                         |
| cluster.eager-lock                            | If eager-lock is off, locks release immediately after file  operations complete, improving performance for some operations, but  reducing access efficiency | on                                                           | on/off                                                       |                                         |
| cluster.quorum-type                           | If value is “fixed” only allow writes if quorum-count bricks are  present. If value is “auto” only allow writes if more than half of  bricks, or exactly half including the first brick, are present | none                                                         | none/auto/fixed                                              |                                         |
| cluster.quorum-count                          | If quorum-type is “fixed” only allow writes if this many bricks are present. Other quorum types will OVERWRITE this value | null                                                         | 1-(signed-int)                                               |                                         |
| cluster.heal-wait-queue-length                | Specifies the number of heals that can be queued for the parallel background self heal jobs. | 128                                                          | 0-10000                                                      |                                         |
| cluster.favorite-child-policy                 | Specifies which policy can be used to automatically resolve  split-brains without user intervention. “size” picks the file with the  biggest size as the source. “ctime” and “mtime” pick the file with the  latest ctime and mtime respectively as the source. “majority” picks a  file with identical mtime and size in more than half the number of  bricks in the replica. | none                                                         | none/size/ctime/mtime/majority                               |                                         |
| cluster.use-anonymous-inode                   | Setting this option heals directory renames efficiently      | no                                                           | no/yes                                                       |                                         |
| Disperse                                      | disperse.eager-lock                                          | If eager-lock is on, the lock remains in place either until lock  contention is detected, or for 1 second in order to check if there is  another request for that file from the same client. If eager-lock is  off, locks release immediately after file operations complete, improving performance for some operations, but reducing access efficiency. | on                                                           | on/off                                  |
| disperse.other-eager-lock                     | This option is equivalent to the disperse.eager-lock option but  applicable only for non regular files. When multiple clients access a  particular directory, disabling disperse.other-eager-lockoption for the  volume can improve performance for directory access without compromising performance of I/O's for regular files. | off                                                          | on/off                                                       |                                         |
| disperse.shd-max-threads                      | Specifies the number of entries that can be self healed in parallel on each disperse subvolume by self-heal daemon. | 1                                                            | 1 - 64                                                       |                                         |
| disperse.shd-wait-qlength                     | Specifies the number of entries that must be kept in the dispersed  subvolume's queue for self-heal daemon threads to take up as soon as any of the threads are free to heal. This value should be changed based on  how much memory self-heal daemon process can use for keeping the next  set of entries that need to be healed. | 1024                                                         | 1 - 655536                                                   |                                         |
| disprse.eager-lock-timeout                    | Maximum time (in seconds) that a lock on an inode is kept held if no new operations on the inode are received. | 1                                                            | 1-60                                                         |                                         |
| disperse.other-eager-lock-timeout             | It’s equivalent to eager-lock-timeout option but for non regular files. | 1                                                            | 1-60                                                         |                                         |
| disperse.background-heals                     | This option can be used to control number of parallel heals running in background. | 8                                                            | 0-256                                                        |                                         |
| disperse.heal-wait-qlength                    | This option can be used to control number of heals that can wait | 128                                                          | 0-65536                                                      |                                         |
| disperse.read-policy                          | inode-read fops happen only on ‘k’ number of bricks in n=k+m  disperse subvolume. ‘round-robin’ selects the read subvolume using  round-robin algo. ‘gfid-hash’ selects read subvolume based on hash of  the gfid of that file/directory. | gfid-hash                                                    | round-robin/gfid-hash                                        |                                         |
| disperse.self-heal-window-size                | Maximum number blocks(128KB) per file for which self-heal process would be applied simultaneously. | 1                                                            | 1-1024                                                       |                                         |
| disperse.optimistic-change-log                | This option Set/Unset dirty flag for every update fop at the start  of the fop. If OFF, this option impacts performance of entry or metadata operations as it will set dirty flag at the start and unset it at the  end of ALL update fop. If ON and all the bricks are good, dirty flag  will be set at the start only for file fops, For metadata and entry fops dirty flag will not be set at the start This does not impact  performance for metadata operations and entry operation but has a very  small window to miss marking entry as dirty in case it is required to be healed. | on                                                           | on/off                                                       |                                         |
| disperse.parallel-writes                      | This controls if writes can be wound in parallel as long as it doesn’t modify same stripes | on                                                           | on/off                                                       |                                         |
| disperse.stripe-cache                         | This option will keep the last stripe of write fop in memory. If  next write falls in this stripe, we need not to read it again from  backend and we can save READ fop going over the network. This will  improve performance, specially for sequential writes. However, this will also lead to extra memory consumption, maximum (cache size * stripe  size) Bytes per open file | 4                                                            | 0-10                                                         |                                         |
| disperse.quorum-count                         | This option can be used to define how many successes on the bricks  constitute a success to the application. This count should be in the  range [disperse-data-count, disperse-count] (inclusive) | 0                                                            | 0-(signedint)                                                |                                         |
| disperse.use-anonymous-inode                  | Setting this option heals renames efficiently                | off                                                          | on/off                                                       |                                         |
| Logging                                       | diagnostics.brick-log-level                                  | Changes the log-level of the bricks                          | INFO                                                         | DEBUG/WARNING/ERROR/CRITICAL/NONE/TRACE |
| diagnostics.client-log-level                  | Changes the log-level of the clients.                        | INFO                                                         | DEBUG/WARNING/ERROR/CRITICAL/NONE/TRACE                      |                                         |
| diagnostics.brick-sys-log-level               | Depending on the value defined for this option, log messages at and  above the defined level are generated in the syslog and the brick log  files. | CRITICAL                                                     | INFO/WARNING/ERROR/CRITICAL                                  |                                         |
| diagnostics.client-sys-log-level              | Depending on the value defined for this option, log messages at and  above the defined level are generated in the syslog and the client log  files. | CRITICAL                                                     | INFO/WARNING/ERROR/CRITICAL                                  |                                         |
| diagnostics.brick-log-format                  | Allows you to configure the log format to log either with a message id or without one on the brick. | with-msg-id                                                  | no-msg-id/with-msg-id                                        |                                         |
| diagnostics.client-log-format                 | Allows you to configure the log format to log either with a message ID or without one on the client. | with-msg-id                                                  | no-msg-id/with-msg-id                                        |                                         |
| diagnostics.brick-log-buf-size                | The maximum number of unique log messages that can be suppressed  until the timeout or buffer overflow, whichever occurs first on the  bricks. | 5                                                            | 0 and 20 (0 and 20 included)                                 |                                         |
| diagnostics.client-log-buf-size               | The maximum number of unique log messages that can be suppressed  until the timeout or buffer overflow, whichever occurs first on the  clients. | 5                                                            | 0 and 20 (0 and 20 included)                                 |                                         |
| diagnostics.brick-log-flush-timeout           | The length of time for which the log messages are buffered, before  being flushed to the logging infrastructure (gluster or syslog files) on the bricks. | 120                                                          | 30 - 300 seconds (30 and 300 included)                       |                                         |
| diagnostics.client-log-flush-timeout          | The length of time for which the log messages are buffered, before  being flushed to the logging infrastructure (gluster or syslog files) on the clients. | 120                                                          | 30 - 300 seconds (30 and 300 included)                       |                                         |
| Performance                                   | *features.trash                                              | Enable/disable trash translator                              | off                                                          | on/off                                  |
| *performance.readdir-ahead                    | Enable/disable readdir-ahead translator in the volume        | off                                                          | on/off                                                       |                                         |
| *performance.read-ahead                       | Enable/disable read-ahead translator in the volume           | off                                                          | on/off                                                       |                                         |
| *performance.io-cache                         | Enable/disable io-cache translator in the volume             | off                                                          | on/off                                                       |                                         |
| performance.quick-read                        | To enable/disable quick-read translator in the volume.       | on                                                           | off/on                                                       |                                         |
| performance.md-cache                          | Enables and disables md-cache translator.                    | off                                                          | off/on                                                       |                                         |
| performance.open-behind                       | Enables and disables open-behind translator.                 | on                                                           | off/on                                                       |                                         |
| performance.nl-cache                          | Enables and disables nl-cache translator.                    | off                                                          | off/on                                                       |                                         |
| performance.stat-prefetch                     | Enables and disables stat-prefetch translator.               | on                                                           | off/on                                                       |                                         |
| performance.client-io-threads                 | Enables and disables client-io-thread translator.            | on                                                           | off/on                                                       |                                         |
| performance.write-behind                      | Enables and disables write-behind translator.                | on                                                           | off/on                                                       |                                         |
| performance.write-behind-window-size          | Size of the per-file write-behind buffer.                    | 1MB                                                          | Write-behind cache size                                      |                                         |
| performance.io-thread-count                   | The number of threads in IO threads translator.              | 16                                                           | 1-64                                                         |                                         |
| performance.flush-behind                      | If this option is set ON, instructs write-behind translator to  perform flush in background, by returning success (or any errors, if any of previous writes were failed) to application even before flush is  sent to backend filesystem. | On                                                           | On/Off                                                       |                                         |
| performance.cache-max-file-size               | Sets the maximum file size cached by the io-cache translator. Can  use the normal size descriptors of KB, MB, GB,TB or PB (for example,  6GB). Maximum size uint64. | 2 ^ 64 -1 bytes                                              | size in bytes                                                |                                         |
| performance.cache-min-file-size               | Sets the minimum file size cached by the io-cache translator. Values same as "max" above | 0B                                                           | size in bytes                                                |                                         |
| performance.cache-refresh-timeout             | The cached data for a file will be retained till 'cache-refresh-timeout' seconds, after which data re-validation is performed. | 1s                                                           | 0-61                                                         |                                         |
| performance.cache-size                        | Size of the read cache.                                      | 32 MB                                                        | size in bytes                                                |                                         |
| performance.lazy-open                         | This option requires open-behind to be on. Perform an open in the  backend only when a necessary FOP arrives (for example, write on the  file descriptor, unlink of the file). When this option is disabled,  perform backend open immediately after an unwinding open. | Yes                                                          | Yes/No                                                       |                                         |
| performance.md-cache-timeout                  | The time period in seconds which controls when metadata cache has to be refreshed. If the age of cache is greater than this time-period, it  is refreshed. Every time cache is refreshed, its age is reset to 0. | 1                                                            | 0-600 seconds                                                |                                         |
| performance.nfs-strict-write-ordering         | Specifies whether to prevent later writes from overtaking earlier  writes for NFS, even if the writes do not relate to the same files or  locations. | off                                                          | on/off                                                       |                                         |
| performance.nfs.flush-behind                  | Specifies whether the write-behind translator performs flush  operations in the background for NFS by returning (false) success to the application before flush file operations are sent to the backend file  system. | on                                                           | on/off                                                       |                                         |
| performance.nfs.strict-o-direct               | Specifies whether to attempt to minimize the cache effects of I/O  for a file on NFS. When this option is enabled and a file descriptor is  opened using the O_DIRECT flag, write-back caching is disabled for  writes that affect that file descriptor. When this option is disabled,  O_DIRECT has no effect on caching. This option is ignored if  performance.write-behind is disabled. | off                                                          | on/off                                                       |                                         |
| performance.nfs.write-behind-trickling-writes | Enables and disables trickling-write strategy for the write-behind translator for NFS clients. | on                                                           | off/on                                                       |                                         |
| performance.nfs.write-behind-window-size      | Specifies the size of the write-behind buffer for a single file or inode for NFS. | 1 MB                                                         | 512 KB - 1 GB                                                |                                         |
| performance.rda-cache-limit                   | The value specified for this option is the maximum size of cache  consumed by the readdir-ahead translator. This value is global and the  total memory consumption by readdir-ahead is capped by this value,  irrespective of the number/size of directories cached. | 10MB                                                         | 0-1GB                                                        |                                         |
| performance.rda-request-size                  | The value specified for this option will be the size of buffer holding directory entries in readdirp response. | 128KB                                                        | 4KB-128KB                                                    |                                         |
| performance.resync-failed-syncs-after-fsync   | If syncing cached writes that were issued before an fsync operation  fails, this option configures whether to reattempt the failed sync  operations. | off                                                          | on/off                                                       |                                         |
| performance.strict-o-direct                   | Specifies whether to attempt to minimize the cache effects of I/O  for a file. When this option is enabled and a file descriptor is opened  using the O_DIRECT flag, write-back caching is disabled for writes that  affect that file descriptor. When this option is disabled, O_DIRECT has  no effect on caching. This option is ignored if performance.write-behind is disabled. | on                                                           | on/off                                                       |                                         |
| performance.strict-write-ordering             | Specifies whether to prevent later writes from overtaking earlier  writes, even if the writes do not relate to the same files or locations. | on                                                           | on/off                                                       |                                         |
| performance.use-anonymous-fd                  | This option requires open-behind to be on. For read operations, use  anonymous file descriptor when the original file descriptor is  open-behind and not yet opened in the backend. | Yes                                                          | No/Yes                                                       |                                         |
| performance.write-behind-trickling-writes     | Enables and disables trickling-write strategy for the write-behind translator for FUSE clients. | on                                                           | off/on                                                       |                                         |
| performance.write-behind-window-size          | Specifies the size of the write-behind buffer for a single file or inode. | 1MB                                                          | 512 KB - 1 GB                                                |                                         |
| features.read-only                            | Enables you to mount the entire volume as read-only for all the clients (including NFS clients) accessing it. | Off                                                          | On/Off                                                       |                                         |
| features.quota-deem-statfs                    | When this option is set to on, it takes the quota limits into  consideration while estimating the filesystem size. The limit will be  treated as the total size instead of the actual size of filesystem. | on                                                           | on/off                                                       |                                         |
| features.shard                                | Enables or disables sharding on the volume. Affects files created after volume configuration. | disable                                                      | enable/disable                                               |                                         |
| features.shard-block-size                     | Specifies the maximum size of file pieces when sharding is enabled. Affects files created after volume configuration. | 64MB                                                         | 4MB-4TB                                                      |                                         |
| features.uss                                  | This option enable/disable User Serviceable Snapshots on the volume. | off                                                          | on/off                                                       |                                         |
| geo-replication.indexing                      | Use this option to automatically sync the changes in the filesystem from Primary to Secondary. | Off                                                          | On/Off                                                       |                                         |
| network.frame-timeout                         | The time frame after which the operation has to be declared as dead, if the server does not respond for a particular operation. | 1800 (30 mins)                                               | 1800 secs                                                    |                                         |
| network.ping-timeout                          | The time duration for which the client waits to check if the server  is responsive. When a ping timeout happens, there is a network  disconnect between the client and server. All resources held by server  on behalf of the client get cleaned up. When a reconnection happens, all resources will need to be re-acquired before the client can resume its  operations on the server. Additionally, the locks will be acquired and  the lock tables updated. This reconnect is a very expensive operation  and should be avoided. | 42 Secs                                                      | 42 Secs                                                      |                                         |
| nfs                                           | nfs.enable-ino32                                             | For 32-bit nfs clients or applications that do not support 64-bit  inode numbers or large files, use this option from the CLI to make  Gluster NFS return 32-bit inode numbers instead of 64-bit inode numbers. | Off                                                          | On/Off                                  |
| nfs.volume-access                             | Set the access type for the specified sub-volume.            | read-write                                                   | read-write/read-only                                         |                                         |
| nfs.trusted-write                             | If there is an UNSTABLE write from the client, STABLE flag will be  returned to force the client to not send a COMMIT request. In some  environments, combined with a replicated GlusterFS setup, this option  can improve write performance. This flag allows users to trust Gluster  replication logic to sync data to the disks and recover when required.  COMMIT requests if received will be handled in a default manner by  fsyncing. STABLE writes are still handled in a sync manner. | Off                                                          | On/Off                                                       |                                         |
| nfs.trusted-sync                              | All writes and COMMIT requests are treated as async. This implies  that no write requests are guaranteed to be on server disks when the  write reply is received at the NFS client. Trusted sync includes  trusted-write behavior. | Off                                                          | On/Off                                                       |                                         |
| nfs.export-dir                                | This option can be used to export specified comma separated  subdirectories in the volume. The path must be an absolute path. Along  with path allowed list of IPs/hostname can be associated with each  subdirectory. If provided connection will allowed only from these IPs.  Format: \<dir>[(hostspec[hostspec...])][,...]. Where hostspec can  be an IP address, hostname or an IP range in CIDR notation. **Note**: Care must be taken while configuring this option as invalid entries  and/or unreachable DNS servers can introduce unwanted delay in all the  mount calls. | No sub directory exported.                                   | Absolute path with allowed list of IP/hostname               |                                         |
| nfs.export-volumes                            | Enable/Disable exporting entire volumes, instead if used in  conjunction with nfs3.export-dir, can allow setting up only  subdirectories as exports. | On                                                           | On/Off                                                       |                                         |
| nfs.rpc-auth-unix                             | Enable/Disable the AUTH_UNIX authentication type. This option is  enabled by default for better interoperability. However, you can disable it if required. | On                                                           | On/Off                                                       |                                         |
| nfs.rpc-auth-null                             | Enable/Disable the AUTH_NULL authentication type. It is not recommended to change the default value for this option. | On                                                           | On/Off                                                       |                                         |
| nfs.rpc-auth-allow\<IP- Addresses>            | Allow a comma separated list of addresses and/or hostnames to  connect to the server. By default, all clients are disallowed. This  allows you to define a general rule for all exported volumes. | Reject All                                                   | IP address or Host name                                      |                                         |
| nfs.rpc-auth-reject\<IP- Addresses>           | Reject a comma separated list of addresses and/or hostnames from  connecting to the server. By default, all connections are disallowed.  This allows you to define a general rule for all exported volumes. | Reject All                                                   | IP address or Host name                                      |                                         |
| nfs.ports-insecure                            | Allow client connections from unprivileged ports. By default only  privileged ports are allowed. This is a global setting in case insecure  ports are to be enabled for all exports using a single option. | Off                                                          | On/Off                                                       |                                         |
| nfs.addr-namelookup                           | Turn-off name lookup for incoming client connections using this  option. In some setups, the name server can take too long to reply to  DNS queries resulting in timeouts of mount requests. Use this option to  turn off name lookups during address authentication. Note, turning this  off will prevent you from using hostnames in rpc-auth.addr.* filters. | On                                                           | On/Off                                                       |                                         |
| nfs.register-with-portmap                     | For systems that need to run multiple NFS servers, you need to  prevent more than one from registering with portmap service. Use this  option to turn off portmap registration for Gluster NFS. | On                                                           | On/Off                                                       |                                         |
| nfs.port \<PORT- NUMBER>                      | Use this option on systems that need Gluster NFS to be associated with a non-default port number. | NA                                                           | 38465-38467                                                  |                                         |
| nfs.disable                                   | Turn-off volume being exported by NFS                        | Off                                                          | On/Off                                                       |                                         |
| Server                                        | server.allow-insecure                                        | Allow client connections from unprivileged ports. By default only  privileged ports are allowed. This is a global setting in case insecure  ports are to be enabled for all exports using a single option. | On                                                           | On/Off                                  |
| server.statedump-path                         | Location of the state dump file.                             | tmp directory of the brick                                   | New directory path                                           |                                         |
| server.allow-insecure                         | Allows FUSE-based client connections from unprivileged ports.By  default, this is enabled, meaning that ports can accept and reject  messages from insecure ports. When disabled, only privileged ports are  allowed. | on                                                           | on/off                                                       |                                         |
| server.anongid                                | Value of the GID used for the anonymous user when root-squash is  enabled. When root-squash is enabled, all the requests received from the root GID (that is 0) are changed to have the GID of the anonymous user. | 65534 (this UID is also known as nfsnobody)                  | 0 - 4294967295                                               |                                         |
| server.anonuid                                | Value of the UID used for the anonymous user when root-squash is  enabled. When root-squash is enabled, all the requests received from the root UID (that is 0) are changed to have the UID of the anonymous user. | 65534 (this UID is also known as nfsnobody)                  | 0 - 4294967295                                               |                                         |
| server.event-threads                          | Specifies the number of event threads to execute in parallel. Larger values would help process responses faster, depending on available  processing power. | 2                                                            | 1-1024                                                       |                                         |
| server.gid-timeout                            | The time period in seconds which controls when cached groups has to  expire. This is the cache that contains the groups (GIDs) where a  specified user (UID) belongs to. This option is used only when  server.manage-gids is enabled. | 2                                                            | 0-4294967295 seconds                                         |                                         |
| server.manage-gids                            | Resolve groups on the server-side. By enabling this option, the  groups (GIDs) a user (UID) belongs to gets resolved on the server,  instead of using the groups that were send in the RPC Call by the  client. This option makes it possible to apply permission checks for  users that belong to bigger group lists than the protocol supports  (approximately 93). | off                                                          | on/off                                                       |                                         |
| server.root-squash                            | Prevents root users from having root privileges, and instead assigns them the privileges of nfsnobody. This squashes the power of the root  users, preventing unauthorized modification of files on the Red Hat  Gluster Storage servers. This option is used only for glusterFS NFS  protocol. | off                                                          | on/off                                                       |                                         |
| server.statedump-path                         | Specifies the directory in which the statedumpfiles must be stored. | path to directory                                            | /var/run/gluster (for a default installation)                |                                         |
| Storage                                       | storage.health-check-interval                                | Number of seconds between health-checks done on the filesystem that  is used for the brick(s). Defaults to 30 seconds, set to 0 to disable. | tmp directory of the brick                                   | New directory path                      |
| storage.linux-io_uring                        | Enable/Disable io_uring based I/O at the posix xlator on the bricks. | Off                                                          | On/Off                                                       |                                         |
| storage.fips-mode-rchecksum                   | If enabled, posix_rchecksum uses the FIPS compliant SHA256 checksum, else it uses MD5. | on                                                           | on/ off                                                      |                                         |
| storage.create-mask                           | Maximum set (upper limit) of permission for the files that will be created. | 0777                                                         | 0000 - 0777                                                  |                                         |
| storage.create-directory-mask                 | Maximum set (upper limit) of permission for the directories that will be created. | 0777                                                         | 0000 - 0777                                                  |                                         |
| storage.force-create-mode                     | Minimum set (lower limit) of permission for the files that will be created. | 0000                                                         | 0000 - 0777                                                  |                                         |
| storage.force-create-directory                | Minimum set (lower limit) of permission for the directories that will be created. | 0000                                                         | 0000 - 0777                                                  |                                         |
| storage.health-check-interval                 | Sets the time interval in seconds for a filesystem health check. You can set it to 0 to disable. | 30 seconds                                                   | 0-4294967295 seconds                                         |                                         |
| storage.reserve                               | To reserve storage space at the brick. This option accepts size in  form of MB and also in form of percentage. If user has configured the  storage.reserve option using size in MB earlier, and then wants to give  the size in percentage, it can be done using the same option. Also, the  newest set value is considered, if it was in MB before and then if it  sent in percentage, the percentage value becomes new value and the older one is over-written | 1 (1% of the brick size)                                     | 0-100                                                        |                                         |

> **Note**
>
> We've found few performance xlators, options marked with * in above  table have been causing more performance regression than improving.  These xlators should be turned off for volumes.

# Mandatory Locks

Support for mandatory locks inside GlusterFS does not converge all by itself to what Linux kernel provides to user space file systems. Here  we enforce core mandatory lock semantics with and without the help of  file mode bits. Please read through the [design specification](https://github.com/gluster/glusterfs-specs/blob/master/done/GlusterFS 3.8/Mandatory Locks.md) which explains the whole concept behind the mandatory locks implementation done for GlusterFS.

## Implications and Usage

By default, mandatory locking will be disabled for a volume and a  volume set options is available to configure volume to operate under 3  different mandatory locking modes.

## Volume Option

```

gluster volume set <VOLNAME> locks.mandatory-locking <off / file / forced / optimal>
```

**off** - Disable mandatory locking for specified volume.
 **file** - Enable Linux kernel style mandatory locking semantics with the help of mode bits (not well tested)
 **forced** - Check for conflicting byte range locks for every data modifying operation in a volume
 **optimal** - Combinational mode where POSIX clients can  live with their advisory lock semantics which will still honour the  mandatory locks acquired by other clients like SMB.

**Note**:- Please refer the design doc for more information on these key values.

#### Points to be remembered

- Valid key values available with mandatory-locking volume set option  are taken into effect only after a subsequent start/restart of the  volume.
- Due to some outstanding issues, it is recommended to turn off the  performance translators in order to have the complete functionality of  mandatory-locks when volume is configured in any one of the above  described mandatory-locking modes. Please see the 'Known issue' section  below for more details.

#### Known issues

- Since the whole logic of mandatory-locks are implemented within the  locks translator loaded at the server side, early success returned to  fops like open, read, write to upper/application layer by performance  translators residing at the client side will impact the intended  functionality of mandatory-locks. One such issue is being tracked in the following bugzilla report:

https://bugzilla.redhat.com/show_bug.cgi?id=1194546

- There is a possible race window uncovered with respect to mandatory  locks and an ongoing read/write operation. For more details refer the  bug report given below:

https://bugzilla.redhat.com/show_bug.cgi?id=1287099

# Coreutils for GlusterFS volumes

The GlusterFS Coreutils is a suite of utilities that aims to mimic  the standard Linux coreutils, with the exception that it utilizes the  gluster C API in order to do work. It offers an interface similar to  that of the ftp program. Operations include things like getting files from the server to the  local machine, putting files from the local machine to the server,  retrieving directory information from the server and so on.

## Installation

#### Install GlusterFS

For information on prerequisites, instructions and configuration of GlusterFS, see Installation Guides from http://docs.gluster.org/en/latest/.

#### Install glusterfs-coreutils

For now glusterfs-coreutils will be packaged only as rpm. Other package formats will be supported very soon.

##### For fedora

Use dnf/yum to install glusterfs-coreutils:

```

dnf install glusterfs-coreutils
```

OR

```

yum install glusterfs-coreutils
```

## Usage

glusterfs-coreutils provides a set of basic utilities such as cat,  cp, flock, ls, mkdir, rm, stat and tail that are implemented  specifically using the GlusterFS API commonly known as libgfapi. These  utilities can be used either inside a gluster remote shell or as standalone commands with 'gf' prepended to their respective  base names. For example, glusterfs cat utility is named as gfcat and so  on with an exception to flock core utility for which a standalone  gfflock command is not provided as such(see the notes section on why  flock is designed in that way).

#### Using coreutils within a remote gluster-shell

##### Invoke a new shell

In order to enter into a gluster client-shell, type *gfcli* and press enter. You will now be presented with a similar prompt as shown below:

```

# gfcli
gfcli>
```

See the man page for *gfcli* for more options.

##### Connect to a gluster volume

Now we need to connect as a client to some glusterfs volume which has already started. Use connect command to do so as follows:

```

gfcli> connect glfs://<SERVER-IP or HOSTNAME>/<VOLNAME>
```

For example if you have a volume named vol on a server with hostname localhost the above command will take the following form:

```

gfcli> connect glfs://localhost/vol
```

Make sure that you are successfully attached to a remote gluster volume by verifying the new prompt which should look like:

```

gfcli (<SERVER IP or HOSTNAME/<VOLNAME>)
```

##### Try out your favorite utilities

Please go through the man pages for different utilities and available options for each command. For example, *man gfcp* will display details on the usage of cp command outside or within a gluster-shell. Run different commands as follows:

```

gfcli (localhost/vol) ls .
gfcli (localhost/vol) stat .trashcan
```

##### Terminate the client connection from the volume

Use disconnect command to close the connection:

```

gfcli (localhost/vol) disconnect
gfcli>
```

##### Exit from shell

Run quit from shell:

```

gfcli> quit
```

#### Using standalone glusterfs coreutil commands

As mentioned above glusterfs coreutils also provides standalone  commands to perform the basic GNU coreutil functionalities. All those  commands are prepended by 'gf'. Instead of invoking a gluster  client-shell you can directly make use of these to establish and perform the operation in one shot. For example see the following sample usage  of gfstat command:

```

gfstat glfs://localhost/vol/foo
```

There is an exemption regarding flock coreutility which is not  available as a standalone command for a reason described under 'Notes'  section.

For more information on each command and corresponding options see associated man pages.

## Notes

- Within a particular session of gluster client-shell, history of  commands are preserved i.e, you can use up/down arrow keys to search  through previously executed commands or the reverse history search  technique using Ctrl+R.
- flock is not available as standalone 'gfflock'. Because locks are  always associated with file descriptors. Unlike all other commands flock cannot straight away clean up the file descriptor after acquiring the  lock. For flock we need to maintain an active connection as a glusterfs  client.

# Events APIs

*New in version 3.9*

NOTE : glusterfs-selinux package would have to be installed for events feature to function properly when the selinux is in enforced mode. In addition to that, the default port to be used for eventsd has now been changed to 55555 and it has to lie between the ephemeral port ranges.

## Set PYTHONPATH(Only in case of Source installation)

If Gluster is installed using source install, `cliutils` will get installed under `/usr/local/lib/python.2.7/site-packages` Set PYTHONPATH by adding in `~/.bashrc`

```

export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH
```

## Enable and Start Events APIs

Enable and Start glustereventsd in all peer nodes

In Systems using Systemd,

```

systemctl enable glustereventsd
systemctl start glustereventsd
```

FreeBSD or others, add the following in `/etc/rc.conf`

```

glustereventsd_enable="YES"
```

And start the glustereventsd using,

```

service glustereventsd start
```

SysVInit(CentOS 6),

```

chkconfig glustereventsd on
service glustereventsd start
```

## Status

Status Can be checked using,

```

gluster-eventsapi status
```

Example output:

```

Webhooks:
None

+-----------+-------------+-----------------------+
| NODE      | NODE STATUS | GLUSTEREVENTSD STATUS |
+-----------+-------------+-----------------------+
| localhost |          UP |                    UP |
| node2     |          UP |                    UP |
+-----------+-------------+-----------------------+
```

## Webhooks

**Webhooks** are similar to callbacks(over HTTP), on event Gluster will call the Webhook URL(via POST) which is configured. Webhook is a web server which listens on a URL, this can be deployed outside of the Cluster. Gluster nodes should be able to access this Webhook server on the configured port.

Example Webhook written in python,

```

from flask import Flask, request

app = Flask(__name__)

@app.route("/listen", methods=["POST"])
def events_listener():
    gluster_event = request.json
    if gluster_event is None:
        # No event to process, may be test call
        return "OK"

    # Process gluster_event
    # {
    #  "nodeid": NODEID,
    #  "ts": EVENT_TIMESTAMP,
    #  "event": EVENT_TYPE,
    #  "message": EVENT_DATA
    # }
    print (gluster_event)
    return "OK"

app.run(host="0.0.0.0", port=9000)
```

Test and Register webhook using following commands,

```console
usage: gluster-eventsapi webhook-test [-h] [--bearer_token BEARER_TOKEN] url

positional arguments:
  url                   URL of Webhook

optional arguments:
  -h, --help            show this help message and exit
  --bearer_token BEARER_TOKEN, -t BEARER_TOKEN
                        Bearer Token
```

Example(Webhook server is running in `192.168.122.188:9000`),

```console
# gluster-eventsapi webhook-test http://192.168.122.188:9000/listen

+-----------+-------------+----------------+
| NODE      | NODE STATUS | WEBHOOK STATUS |
+-----------+-------------+----------------+
| localhost |          UP |             OK |
| node2     |          UP |             OK |
+-----------+-------------+----------------+
```

If Webhook status is OK from all peer nodes then register the Webhook using,

```console
usage: gluster-eventsapi webhook-add [-h] [--bearer_token BEARER_TOKEN] url

positional arguments:
  url                   URL of Webhook

optional arguments:
  -h, --help            show this help message and exit
  --bearer_token BEARER_TOKEN, -t BEARER_TOKEN
                        Bearer Token
```

Example,

```console
# gluster-eventsapi webhook-add http://192.168.122.188:9000/listen

+-----------+-------------+-------------+
| NODE      | NODE STATUS | SYNC STATUS |
+-----------+-------------+-------------+
| localhost |          UP |          OK |
| node2     |          UP |          OK |
+-----------+-------------+-------------+
```

**Note**: If Sync status is Not OK for any node, then make sure to run following command from a peer node when that node comes up.

```

gluster-eventsapi sync
```

To unsubscribe from events, delete the webhook using following command

```console
usage: gluster-eventsapi webhook-del [-h] url

positional arguments:
  url         URL of Webhook

optional arguments:
  -h, --help  show this help message and exit
```

Example,

```

gluster-eventsapi webhook-del http://192.168.122.188:9000/listen
```

## Configuration

View all configurations using,

```console
usage: gluster-eventsapi config-get [-h] [--name NAME]

optional arguments:
  -h, --help   show this help message and exit
  --name NAME  Config Name
```

Example output:

```console
+--------------------+-------+
| NAME               | VALUE |
+--------------------+-------+
| log-level          | INFO  |
| port               | 55555 |
| disable-events-log | False |
+--------------------+-------+
```

To change any configuration,

```console
usage: gluster-eventsapi config-set [-h] name value

positional arguments:
  name        Config Name
  value       Config Value

optional arguments:
  -h, --help  show this help message and exit
```

Example output,

```console
+-----------+-------------+-------------+
| NODE      | NODE STATUS | SYNC STATUS |
+-----------+-------------+-------------+
| localhost |          UP |          OK |
| node2     |          UP |          OK |
+-----------+-------------+-------------+
```

To Reset any configuration,

```console
usage: gluster-eventsapi config-reset [-h] name

positional arguments:
  name        Config Name or all

optional arguments:
  -h, --help  show this help message and exit
```

Example output,

```console
+-----------+-------------+-------------+
| NODE      | NODE STATUS | SYNC STATUS |
+-----------+-------------+-------------+
| localhost |          UP |          OK |
| node2     |          UP |          OK |
+-----------+-------------+-------------+
```

**Note**: If any node status is not UP or sync status is not OK, make sure to run `gluster-eventsapi sync` from a peer node.

## Add node to the Cluster

When a new node added to the cluster,

- Enable and Start Eventsd in the new node using the steps mentioned above
- Run `gluster-eventsapi sync` command from a peer node other than the new node.

## APIs documentation

Glustereventsd pushes the Events in JSON format to configured Webhooks. All Events will have following attributes.

| Attribute | Description         |
| --------- | ------------------- |
| nodeid    | Node UUID           |
| ts        | Event Timestamp     |
| event     | Event Type          |
| message   | Event Specific Data |

Example:

```

{
  "nodeid": "95cd599c-5d87-43c1-8fba-b12821fd41b6",
  "ts": 1468303352,
  "event": "VOLUME_CREATE",
  "message": {
    "name": "gv1"
  }
}
```

"message" can have following attributes based on the type of event.

### Peer Events

| Event Type  | Attribute | Description                     |
| ----------- | --------- | ------------------------------- |
| PEER_ATTACH | host      | Hostname or IP of added node    |
| PEER_DETACH | host      | Hostname or IP of detached node |

### Volume Events

| Event Type    | Attribute                                      | Description                           |
| ------------- | ---------------------------------------------- | ------------------------------------- |
| VOLUME_CREATE | name                                           | Volume Name                           |
| VOLUME_START  | force                                          | Force option used or not during Start |
| name          | Volume Name                                    |                                       |
| VOLUME_STOP   | force                                          | Force option used or not during Stop  |
| name          | Volume Name                                    |                                       |
| VOLUME_DELETE | name                                           | Volume Name                           |
| VOLUME_SET    | name                                           | Volume Name                           |
| options       | List of Options[(key1, val1), (key2, val2),..] |                                       |
| VOLUME_RESET  | name                                           | Volume Name                           |
| option        | Option Name                                    |                                       |

### Brick Events

| Event Type         | Attribute            | Description |
| ------------------ | -------------------- | ----------- |
| BRICK_RESET_START  | volume               | Volume Name |
| source-brick       | Source Brick details |             |
| BRICK_RESET_COMMIT | volume               | Volume Name |
| destination-brick  | Destination Brick    |             |
| source-brick       | Source Brick details |             |
| BRICK_REPLACE      | volume               | Volume Name |
| destination-brick  | Destination Brick    |             |
| source-brick       | Source Brick details |             |

### Georep Events

| Event Type          | Attribute                                         | Description                             |
| ------------------- | ------------------------------------------------- | --------------------------------------- |
| GEOREP_CREATE       | force                                             | Force option used during session Create |
| secondary           | Secondary Details(Secondaryhost::SecondaryVolume) |                                         |
| no_verify           | No verify option is used or not                   |                                         |
| push_pem            | Push pem option is used or Not                    |                                         |
| ssh_port            | If SSH port is configured during Session Create   |                                         |
| primary             | Primary Volume Name                               |                                         |
| GEOREP_START        | force                                             | Force option used during session Start  |
| Primary             | Primary Volume Name                               |                                         |
| secondary           | Secondary Details(Secondaryhost::SecondaryVolume) |                                         |
| GEOREP_STOP         | force                                             | Force option used during session Stop   |
| primary             | Primary Volume Name                               |                                         |
| secondary           | Secondary Details(Secondaryhost::SecondaryVolume) |                                         |
| GEOREP_PAUSE        | force                                             | Force option used during session Pause  |
| primary             | Primary Volume Name                               |                                         |
| secondary           | Secondary Details(Secondaryhost::SecondaryVolume) |                                         |
| GEOREP_RESUME       | force                                             | Force option used during session Resume |
| primary             | Primary Volume Name                               |                                         |
| secondary           | Secondary Details(Secondaryhost::SecondaryVolume) |                                         |
| GEOREP_DELETE       | force                                             | Force option used during session Delete |
| primary             | Primary Volume Name                               |                                         |
| secondary           | Secondary Details(Secondaryhost::SecondaryVolume) |                                         |
| GEOREP_CONFIG_SET   | primary                                           | Primary Volume Name                     |
| secondary           | Secondary Details(Secondaryhost::SecondaryVolume) |                                         |
| option              | Name of Geo-rep config                            |                                         |
| value               | Changed Value                                     |                                         |
| GEOREP_CONFIG_RESET | primary                                           | Primary Volume Name                     |
| secondary           | Secondary Details(Secondaryhost::SecondaryVolume) |                                         |
| option              | Name of Geo-rep config                            |                                         |

### Bitrot Events

| Event Type            | Attribute     | Description |
| --------------------- | ------------- | ----------- |
| BITROT_ENABLE         | name          | Volume Name |
| BITROT_DISABLE        | name          | Volume Name |
| BITROT_SCRUB_THROTTLE | name          | Volume Name |
| value                 | Changed Value |             |
| BITROT_SCRUB_FREQ     | name          | Volume Name |
| value                 | Changed Value |             |
| BITROT_SCRUB_OPTION   | name          | Volume Name |
| value                 | Changed Value |             |

### Quota Events

| Event Type                 | Attribute                                     | Description |
| -------------------------- | --------------------------------------------- | ----------- |
| QUOTA_ENABLE               | volume                                        | Volume Name |
| QUOTA_DISABLE              | volume                                        | Volume Name |
| QUOTA_SET_USAGE_LIMIT      | volume                                        | Volume Name |
| path                       | Path in Volume on which Quota option is set   |             |
| limit                      | Changed Value                                 |             |
| QUOTA_SET_OBJECTS_LIMIT    | volume                                        | Volume Name |
| path                       | Path in Volume on which Quota option is set   |             |
| limit                      | Changed Value                                 |             |
| QUOTA_REMOVE_USAGE_LIMIT   | volume                                        | Volume Name |
| path                       | Path in Volume on which Quota option is Reset |             |
| QUOTA_REMOVE_OBJECTS_LIMIT | volume                                        | Volume Name |
| path                       | Path in Volume on which Quota option is Reset |             |
| QUOTA_ALERT_TIME           | volume                                        | Volume Name |
| time                       | Changed Alert Time                            |             |
| QUOTA_SOFT_TIMEOUT         | volume                                        | Volume Name |
| soft-timeout               | Changed Value                                 |             |
| QUOTA_HARD_TIMEOUT         | volume                                        | Volume Name |
| hard-timeout               | Changed Value                                 |             |
| QUOTA_DEFAULT_SOFT_LIMIT   | volume                                        | Volume Name |
| default-soft-limit         | Changed Value                                 |             |

### Snapshot Events

| Event Type                                | Attribute                        | Description                    |
| ----------------------------------------- | -------------------------------- | ------------------------------ |
| SNAPSHOT_CREATED                          | snapshot_name                    | Snapshot Name                  |
| volume_name                               | Volume Name                      |                                |
| snapshot_uuid                             | Snapshot UUID                    |                                |
| SNAPSHOT_CREATE_FAILED                    | snapshot_name                    | Snapshot Name                  |
| volume_name                               | Volume Name                      |                                |
| error                                     | Failure details                  |                                |
| SNAPSHOT_ACTIVATED                        | snapshot_name                    | Snapshot Name                  |
| snapshot_uuid                             | Snapshot UUID                    |                                |
| SNAPSHOT_ACTIVATE_FAILED                  | snapshot_name                    | Snapshot Name                  |
| error                                     | Failure details                  |                                |
| SNAPSHOT_DEACTIVATED                      | snapshot_name                    | Snapshot Name                  |
| snapshot_uuid                             | Snapshot UUID                    |                                |
| SNAPSHOT_DEACTIVATE_FAILED                | snapshot_name                    | Snapshot Name                  |
| error                                     | Failure details                  |                                |
| SNAPSHOT_SOFT_LIMIT_REACHED               | volume_name                      | Volume Name                    |
| volume_id                                 | Volume ID                        |                                |
| SNAPSHOT_HARD_LIMIT_REACHED               | volume_name                      | Volume Name                    |
| volume_id                                 | Volume ID                        |                                |
| SNAPSHOT_RESTORED                         | snapshot_name                    | Snapshot Name                  |
| volume_name                               | Volume Name                      |                                |
| snapshot_uuid                             | Snapshot UUID                    |                                |
| SNAPSHOT_RESTORE_FAILED                   | snapshot_name                    | Snapshot Name                  |
| error                                     | Failure details                  |                                |
| SNAPSHOT_DELETED                          | snapshot_name                    | Snapshot Name                  |
| snapshot_uuid                             | Snapshot UUID                    |                                |
| SNAPSHOT_DELETE_FAILED                    | snapshot_name                    | Snapshot Name                  |
| error                                     | Failure details                  |                                |
| SNAPSHOT_CLONED                           | clone_uuid                       | Snapshot Clone UUID            |
| snapshot_name                             | Snapshot Name                    |                                |
| clone_name                                | Snapshot Clone Name              |                                |
| SNAPSHOT_CLONE_FAILED                     | snapshot_name                    | Snapshot Name                  |
| clone_name                                | Snapshot Clone Name              |                                |
| error                                     | Failure details                  |                                |
| SNAPSHOT_CONFIG_UPDATED                   | auto-delete                      | Auto delete Value if available |
| config_type                               | Volume Config or System Config   |                                |
| hard_limit                                | Hard Limit Value if available    |                                |
| soft_limit                                | Soft Limit Value if available    |                                |
| snap-activate                             | Snap activate Value if available |                                |
| SNAPSHOT_CONFIG_UPDATE_FAILED             | error                            | Error details                  |
| SNAPSHOT_SCHEDULER_INITIALISED            | status                           | Succss Status                  |
| SNAPSHOT_SCHEDULER_INIT_FAILED            | error                            | Error details                  |
| SNAPSHOT_SCHEDULER_ENABLED                | status                           | Succss Status                  |
| SNAPSHOT_SCHEDULER_ENABLE_FAILED          | error                            | Error details                  |
| SNAPSHOT_SCHEDULER_DISABLED               | status                           | Succss Status                  |
| SNAPSHOT_SCHEDULER_DISABLE_FAILED         | error                            | Error details                  |
| SNAPSHOT_SCHEDULER_SCHEDULE_ADDED         | status                           | Succss Status                  |
| SNAPSHOT_SCHEDULER_SCHEDULE_ADD_FAILED    | error                            | Error details                  |
| SNAPSHOT_SCHEDULER_SCHEDULE_EDITED        | status                           | Succss Status                  |
| SNAPSHOT_SCHEDULER_SCHEDULE_EDIT_FAILED   | error                            | Error details                  |
| SNAPSHOT_SCHEDULER_SCHEDULE_DELETED       | status                           | Succss Status                  |
| SNAPSHOT_SCHEDULER_SCHEDULE_DELETE_FAILED | error                            | Error details                  |

### Svc Events

| Event Type         | Attribute    | Description              |
| ------------------ | ------------ | ------------------------ |
| SVC_MANAGER_FAILED | volume       | Volume Name if available |
| svc_name           | Service Name |                          |
| SVC_CONNECTED      | volume       | Volume Name if available |
| svc_name           | Service Name |                          |
| SVC_DISCONNECTED   | svc_name     | Service Name             |

### Peer Events

| Event Type             | Attribute        | Description    |
| ---------------------- | ---------------- | -------------- |
| PEER_STORE_FAILURE     | peer             | Hostname or IP |
| PEER_RPC_CREATE_FAILED | peer             | Hostname or IP |
| PEER_REJECT            | peer             | Hostname or IP |
| PEER_CONNECT           | host             | Hostname or IP |
| uuid                   | Host UUID        |                |
| PEER_DISCONNECT        | host             | Hostname or IP |
| uuid                   | Host UUID        |                |
| state                  | Disconnect State |                |
| PEER_NOT_FOUND         | peer             | Hostname or IP |
| uuid                   | Host UUID        |                |

### Unknown Events

| Event Type   | Attribute | Description    |
| ------------ | --------- | -------------- |
| UNKNOWN_PEER | peer      | Hostname or IP |

### Brick Events

| Event Type         | Attribute   | Description    |
| ------------------ | ----------- | -------------- |
| BRICK_START_FAILED | peer        | Hostname or IP |
| volume             | Volume Name |                |
| brick              | Brick       |                |
| BRICK_STOP_FAILED  | peer        | Hostname or IP |
| volume             | Volume Name |                |
| brick              | Brick       |                |
| BRICK_DISCONNECTED | peer        | Hostname or IP |
| volume             | Volume Name |                |
| brick              | Brick       |                |
| BRICK_CONNECTED    | peer        | Hostname or IP |
| volume             | Volume Name |                |
| brick              | Brick       |                |

### Bricks Events

| Event Type          | Attribute | Description |
| ------------------- | --------- | ----------- |
| BRICKS_START_FAILED | volume    | Volume Name |

### Brickpath Events

| Event Type               | Attribute   | Description    |
| ------------------------ | ----------- | -------------- |
| BRICKPATH_RESOLVE_FAILED | peer        | Hostname or IP |
| volume                   | Volume Name |                |
| brick                    | Brick       |                |

### Notify Events

| Event Type        | Attribute | Description    |
| ----------------- | --------- | -------------- |
| NOTIFY_UNKNOWN_OP | op        | Operation Name |

### Quorum Events

| Event Type      | Attribute | Description |
| --------------- | --------- | ----------- |
| QUORUM_LOST     | volume    | Volume Name |
| QUORUM_REGAINED | volume    | Volume Name |

### Rebalance Events

| Event Type                     | Attribute | Description |
| ------------------------------ | --------- | ----------- |
| REBALANCE_START_FAILED         | volume    | Volume Name |
| REBALANCE_STATUS_UPDATE_FAILED | volume    | Volume Name |

### Import Events

| Event Type               | Attribute     | Description    |
| ------------------------ | ------------- | -------------- |
| IMPORT_QUOTA_CONF_FAILED | volume        | Volume Name    |
| IMPORT_VOLUME_FAILED     | volume        | Volume Name    |
| IMPORT_BRICK_FAILED      | peer          | Hostname or IP |
| brick                    | Brick details |                |

### Compare Events

| Event Type                   | Attribute | Description |
| ---------------------------- | --------- | ----------- |
| COMPARE_FRIEND_VOLUME_FAILED | volume    | Volume Name |

### Ec Events

| Event Type           | Attribute | Description |
| -------------------- | --------- | ----------- |
| EC_MIN_BRICKS_NOT_UP | subvol    | Subvolume   |
| EC_MIN_BRICKS_UP     | subvol    | Subvolume   |

### Georep Events

| Event Type             | Attribute                                                    | Description                      |
| ---------------------- | ------------------------------------------------------------ | -------------------------------- |
| GEOREP_FAULTY          | primary_node                                                 | Hostname or IP of Primary Volume |
| brick_path             | Brick Path                                                   |                                  |
| secondary_host         | Secondary Hostname or IP                                     |                                  |
| primary_volume         | Primary Volume Name                                          |                                  |
| current_secondary_host | Current Secondary Host to which Geo-rep worker was trying to connect to |                                  |
| secondary_volume       | Secondary Volume Name                                        |                                  |

### Quota Events

| Event Type               | Attribute   | Description |
| ------------------------ | ----------- | ----------- |
| QUOTA_CROSSED_SOFT_LIMIT | usage       | Usage       |
| volume                   | Volume Name |             |
| path                     | Path        |             |

### Bitrot Events

| Event Type      | Attribute         | Description  |
| --------------- | ----------------- | ------------ |
| BITROT_BAD_FILE | gfid              | GFID of File |
| path            | Path if Available |              |
| brick           | Brick details     |              |

### Client Events

| Event Type         | Attribute         | Description       |
| ------------------ | ----------------- | ----------------- |
| CLIENT_CONNECT     | client_identifier | Client Identifier |
| client_uid         | Client UID        |                   |
| server_identifier  | Server Identifier |                   |
| brick_path         | Path of Brick     |                   |
| CLIENT_AUTH_REJECT | client_identifier | Client Identifier |
| client_uid         | Client UID        |                   |
| server_identifier  | Server Identifier |                   |
| brick_path         | Path of Brick     |                   |
| CLIENT_DISCONNECT  | client_identifier | Client Identifier |
| client_uid         | Client UID        |                   |
| server_identifier  | Server Identifier |                   |
| brick_path         | Path of Brick     |                   |

### Posix Events

| Event Type                      | Attribute        | Description   |
| ------------------------------- | ---------------- | ------------- |
| POSIX_SAME_GFID                 | gfid             | GFID of File  |
| path                            | Path of File     |               |
| newpath                         | New Path of File |               |
| brick                           | Brick details    |               |
| POSIX_ALREADY_PART_OF_VOLUME    | volume-id        | Volume ID     |
| brick                           | Brick details    |               |
| POSIX_BRICK_NOT_IN_VOLUME       | brick            | Brick details |
| POSIX_BRICK_VERIFICATION_FAILED | brick            | Brick details |
| POSIX_ACL_NOT_SUPPORTED         | brick            | Brick details |
| POSIX_HEALTH_CHECK_FAILED       | path             | Path          |
| brick                           | Brick details    |               |
| op                              | Error Number     |               |
| error                           | Error            |               |

### Afr Events

| Event Type       | Attribute | Description     |
| ---------------- | --------- | --------------- |
| AFR_QUORUM_MET   | subvol    | Sub Volume Name |
| AFR_QUORUM_FAIL  | subvol    | Sub Volume Name |
| AFR_SUBVOL_UP    | subvol    | Sub Volume Name |
| AFR_SUBVOLS_DOWN | subvol    | Sub Volume Name |
| AFR_SPLIT_BRAIN  | subvol    | Sub Volume Name |

### Tier Events

| Event Type                    | Attribute | Description |
| ----------------------------- | --------- | ----------- |
| TIER_ATTACH                   | vol       | Volume Name |
| TIER_ATTACH_FORCE             | vol       | Volume Name |
| TIER_DETACH_START             | vol       | Volume Name |
| TIER_DETACH_STOP              | vol       | Volume Name |
| TIER_DETACH_COMMIT            | vol       | Volume Name |
| TIER_DETACH_FORCE             | vol       | Volume Name |
| TIER_PAUSE                    | vol       | Volume Name |
| TIER_RESUME                   | vol       | Volume Name |
| TIER_WATERMARK_HI             | vol       | Volume Name |
| TIER_WATERMARK_DROPPED_TO_MID | vol       | Volume Name |
| TIER_WATERMARK_RAISED_TO_MID  | vol       | Volume Name |
| TIER_WATERMARK_DROPPED_TO_LOW | vol       | Volume Name |

### Volume Events

| Event Type                 | Attribute                         | Description |
| -------------------------- | --------------------------------- | ----------- |
| VOLUME_ADD_BRICK           | volume                            | Volume Name |
| bricks                     | Bricks details separated by Space |             |
| VOLUME_REMOVE_BRICK_START  | volume                            | Volume Name |
| bricks                     | Bricks details separated by Space |             |
| VOLUME_REMOVE_BRICK_COMMIT | volume                            | Volume Name |
| bricks                     | Bricks details separated by Space |             |
| VOLUME_REMOVE_BRICK_STOP   | volume                            | Volume Name |
| bricks                     | Bricks details separated by Space |             |
| VOLUME_REMOVE_BRICK_FORCE  | volume                            | Volume Name |
| bricks                     | Bricks details separated by Space |             |
| VOLUME_REBALANCE_START     | volume                            | Volume Name |
| VOLUME_REBALANCE_STOP      | volume                            | Volume Name |
| VOLUME_REBALANCE_FAILED    | volume                            | Volume Name |
| VOLUME_REBALANCE_COMPLETE  | volume                            | Volume Name |

# Managing GlusterFS Volume Life-Cycle Extensions with Hook Scripts

Glusterfs allows automation of operations by user-written scripts. For every operation, you can execute a *pre* and a *post* script.

### Pre Scripts

These scripts are run before the occurrence of the event. You can  write a script to automate activities like managing system-wide  services. For example, you can write a script to stop exporting the SMB  share corresponding to the volume before you stop the volume.

### Post Scripts

These scripts are run after execution of the event. For example, you  can write a script to export the SMB share corresponding to the volume  after you start the volume.

You can run scripts for the following events:

- Creating a volume
- Starting a volume
- Adding a brick
- Removing a brick
- Tuning volume options
- Stopping a volume
- Deleting a volume

### Naming Convention

While creating the file names of your scripts, you must follow the  naming convention followed in your underlying file system like XFS.

> Note: To enable the script, the name of the script must start with an S . Scripts run in lexicographic order of their names.

### Location of Scripts

This section provides information on the folders where the scripts  must be placed. When you create a trusted storage pool, the following  directories are created:

- `/var/lib/glusterd/hooks/1/create/`
- `/var/lib/glusterd/hooks/1/delete/`
- `/var/lib/glusterd/hooks/1/start/`
- `/var/lib/glusterd/hooks/1/stop/`
- `/var/lib/glusterd/hooks/1/set/`
- `/var/lib/glusterd/hooks/1/add-brick/`
- `/var/lib/glusterd/hooks/1/remove-brick/`

After creating a script, you must ensure to save the script in its  respective folder on all the nodes of the trusted storage pool. The  location of the script dictates whether the script must be executed  before or after an event. Scripts are provided with the command line  argument `--volname=VOLNAME` to specify the volume. Command-specific additional arguments are provided for the following volume operations:

```text
Start volume
    --first=yes, if the volume is the first to be started
    --first=no, for otherwise
Stop volume
    --last=yes, if the volume is to be stopped last.
    --last=no, for otherwise
Set volume
    -o key=value
    For every key, value is specified in volume set command.
```

### Prepackaged Scripts

Gluster provides scripts to export Samba (SMB) share when you start a volume and to remove the share when you stop the volume. These scripts  are available at: `/var/lib/glusterd/hooks/1/start/post` and `/var/lib/glusterd/hooks/1/stop/pre`. By default, the scripts are enabled.

When you start a volume using `gluster volume start VOLNAME`, the S30samba-start.sh script performs the following:

- Adds Samba share configuration details of the volume to the smb.conf file
- Mounts the volume through FUSE and adds an entry in /etc/fstab for the same.
- Restarts Samba to run with updated configuration

When you stop the volume using `gluster volume stop VOLNAME`, the S30samba-stop.sh script performs the following:

- Removes the Samba share details of the volume from the smb.conf file
- Unmounts the FUSE mount point and removes the corresponding entry in  /etc/fstab
- Restarts Samba to run with updated configuration

## Introduction[¶](https://docs.rockylinux.org/guides/file_sharing/glusterfs/#introduction)

GlusterFS is a distributed file system.

It allows for storage of large amount of data distributed across clusters of servers with a very high availability.

It is composed of a server part to be installed on all the nodes of the server clusters.

Clients can access the data via the `glusterfs` client or the `mount` command.

GlusterFS can operate in two modes:

- replicated mode: each node of the cluster has all the data.
- distributed mode: no data redundancy. If a storage fails, the data on the failed node is lost.

Both modes can be used together to provide both a replicated and  distributed file system as long as you have the right number of servers.

Data is stored inside bricks.

> A Brick is the basic unit of storage in GlusterFS, represented by an export directory on a server in the trusted storage pool.

## Test platform[¶](https://docs.rockylinux.org/guides/file_sharing/glusterfs/#test-platform)

Our fictitious platform is composed of two servers and a client, all Rocky Linux servers.

- First node: node1.cluster.local - 192.168.1.10
- Second node: node2.cluster.local - 192.168.1.11
- Client1: client1.clients.local - 192.168.1.12

Note

Make sure you have the necessary bandwidth between the servers of the cluster.

Each server in the cluster has a second disk for data storage.

## Preparation of the disks[¶](https://docs.rockylinux.org/guides/file_sharing/glusterfs/#preparation-of-the-disks)

We will create a new LVM logical volume that will be mounted on `/data/glusterfs/vol0` on both of the cluster's servers:

```
$ sudo pvcreate /dev/sdb
$ sudo vgcreate vg_data /dev/sdb
$ sudo lvcreate -l 100%FREE -n lv_data vg_data
$ sudo mkfs.xfs /dev/vg_data/lv_data
$ sudo mkdir -p /data/glusterfs/volume1
```

Note

If LVM is not available on your servers, just install it with the following command:

```
$ sudo dnf install lvm2
```

We can now add that logical volume to the `/etc/fstab` file:

```
/dev/mapper/vg_data-lv_data /data/glusterfs/volume1        xfs     defaults        1 2
```

And mount it:

```
$ sudo mount -a
```

As the data is stored in a sub-volume called brick, we can create a directory in this new data space dedicated to it:

```
$ sudo mkdir /data/glusterfs/volume1/brick0
```

## Installation[¶](https://docs.rockylinux.org/guides/file_sharing/glusterfs/#installation)

At the time of writing this documentation, the original CentOS  Storage SIG repository is no longer available and the RockyLinux  repository is not yet available.

However, we will use (for the time being) the archived version.

First of all, it is necessary to add the dedicated repository to gluster (in version 9) on both servers:

```
sudo dnf install centos-release-gluster9
```

Note

Later, when it is ready on the Rocky side, we can change the name of this package.

As the repo list and url is not available anymore, let's change the content of the `/etc/yum.repos.d/CentOS-Gluster-9.repo`:

```
[centos-gluster9]
name=CentOS-$releasever - Gluster 9
#mirrorlist=http://mirrorlist.centos.org?arch=$basearch&release=$releasever&repo=storage-gluster-9
baseurl=https://dl.rockylinux.org/vault/centos/8.5.2111/storage/x86_64/gluster-9/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Storage
```

We are now ready to install the glusterfs server:

```
$ sudo dnf install glusterfs glusterfs-libs glusterfs-server
```

## Firewall rules[¶](https://docs.rockylinux.org/guides/file_sharing/glusterfs/#firewall-rules)

A few rules are necessary for the service to work:

```
$ sudo firewall-cmd --zone=public --add-service=glusterfs --permanent
$ sudo firewall-cmd --reload
```

or:

```
$ sudo firewall-cmd --zone=public --add-port=24007-24008/tcp --permanent
$ sudo firewall-cmd --zone=public --add-port=49152/tcp --permanent
$ sudo firewall-cmd --reload
```

## Name resolution[¶](https://docs.rockylinux.org/guides/file_sharing/glusterfs/#name-resolution)

You can let DNS handle the name resolution of the servers in your  cluster, or you can choose to relieve the servers of this task by  inserting records for each of them in your `/etc/hosts` files. This will also keep things running even in the event of a DNS failure.

```
192.168.10.10 node1.cluster.local
192.168.10.11 node2.cluster.local
```

## Starting the service[¶](https://docs.rockylinux.org/guides/file_sharing/glusterfs/#starting-the-service)

Without further delay, let's start the service:

```
$ sudo systemctl enable glusterfsd.service glusterd.service
$ sudo systemctl start glusterfsd.service glusterd.service
```

We are ready to join the two nodes to the same pool.

This command is to be performed only once on a single node (here on node1):

```
sudo gluster peer probe node2.cluster.local
peer probe: success
```

Verify:

```
node1 $ sudo gluster peer status
Number of Peers: 1

Hostname: node2.cluster.local
Uuid: c4ff108d-0682-43b2-bc0c-311a0417fae2
State: Peer in Cluster (Connected)
Other names:
192.168.10.11
node2 $ sudo gluster peer status
Number of Peers: 1

Hostname: node1.cluster.local
Uuid: 6375e3c2-4f25-42de-bbb6-ab6a859bf55f
State: Peer in Cluster (Connected)
Other names:
192.168.10.10
```

We can now create a volume with 2 replicas:

```
$ sudo gluster volume create volume1 replica 2 node1.cluster.local:/data/glusterfs/volume1/brick0/ node2.cluster.local:/data/glusterfs/volume1/brick0/
Replica 2 volumes are prone to split-brain. Use Arbiter or Replica 3 to avoid this. See: https://docs.gluster.org/en/latest/Administrator-Guide/Split-brain-and-ways-to-deal-with-it/.
Do you still want to continue?
 (y/n) y
volume create: volume1: success: please start the volume to access data
```

Note

As the return command says, a 2-node cluster is not the best idea in  the world against split brain. But this will suffice for the purposes of our test platform.

We can now start the volume to access data:

```
$ sudo gluster volume start volume1

volume start: volume1: success
```

Check the volume state:

```
$ sudo gluster volume status
Status of volume: volume1
Gluster process                             TCP Port  RDMA Port  Online  Pid
------------------------------------------------------------------------------
Brick node1.cluster.local:/data/glusterfs/v
olume1/brick0                               49152     0          Y       1210
Brick node2.cluster.local:/data/glusterfs/v
olume1/brick0                               49152     0          Y       1135
Self-heal Daemon on localhost               N/A       N/A        Y       1227
Self-heal Daemon on node2.cluster.local     N/A       N/A        Y       1152

Task Status of Volume volume1
------------------------------------------------------------------------------
There are no active volume tasks
$ sudo gluster volume info

Volume Name: volume1
Type: Replicate
Volume ID: f51ca783-e815-4474-b256-3444af2c40c4
Status: Started
Snapshot Count: 0
Number of Bricks: 1 x 2 = 2
Transport-type: tcp
Bricks:
Brick1: node1.cluster.local:/data/glusterfs/volume1/brick0
Brick2: node2.cluster.local:/data/glusterfs/volume1/brick0
Options Reconfigured:
cluster.granular-entry-heal: on
storage.fips-mode-rchecksum: on
transport.address-family: inet
nfs.disable: on
performance.client-io-threads: off
```

The status must be "Started".

We can already restrict access on the volume a little bit:

```
$ sudo gluster volume set volume1 auth.allow 192.168.10.*
```

It's as simple as that

## Clients access[¶](https://docs.rockylinux.org/guides/file_sharing/glusterfs/#clients-access)

There are several ways to access our data from a client.

The preferred method:

```
$ sudo dnf install glusterfs-client
$ sudo mkdir /data
$ sudo mount.glusterfs node1.cluster.local:/volume1 /data
```

There are no additional repositories to configure. The client is already present in the base repos.

Create a file and check that it is present on all the nodes of the cluster:

On client:

```
sudo touch /data/test
```

On both servers:

```
$ ll /data/glusterfs/volume1/brick0/
total 0
-rw-r--r--. 2 root root 0 Feb  3 19:21 test
```

Sound good! But what happens if the node 1 fails? It is the one that was specified when mounting the remote access.

Let's stop the node one:

```
$ sudo shutdown -h now
```

Check status on node2:

```
$ sudo gluster peer status
Number of Peers: 1

Hostname: node1.cluster.local
Uuid: 6375e3c2-4f25-42de-bbb6-ab6a859bf55f
State: Peer in Cluster (Disconnected)
Other names:
192.168.10.10
[antoine@node2 ~]$ sudo gluster volume status
Status of volume: volume1
Gluster process                             TCP Port  RDMA Port  Online  Pid
------------------------------------------------------------------------------
Brick node2.cluster.local:/data/glusterfs/v
olume1/brick0                               49152     0          Y       1135
Self-heal Daemon on localhost               N/A       N/A        Y       1152

Task Status of Volume volume1
------------------------------------------------------------------------------
There are no active volume tasks
```

The node1 is away.

And on client:

```
$ ll /data/test
-rw-r--r--. 1 root root 0 Feb  4 16:41 /data/test
```

File is already there.

Upon connection, the glusterfs client receives a list of nodes it can address, which explains the transparent switchover we just witnessed.

## Conclusions[¶](https://docs.rockylinux.org/guides/file_sharing/glusterfs/#conclusions)

While there are no current repositories, using the archived  repositories that CentOS had for GlusterFS will still work. As outlined, GlusterFS is pretty easy to install and maintain. Using the command  line tools is a pretty straight forward process. GlusterFS will help  with creating and maintaining high-availability clusters for data  storage and redundancy. You can find more information on GlusterFS and  tool usage from the [official documentation pages.](https://docs.gluster.org/en/latest/)
