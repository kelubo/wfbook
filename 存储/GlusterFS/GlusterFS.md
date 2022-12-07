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

## 设置 GlusterFS 卷

卷是 brick 的逻辑集合，其中每个 brick 都是受信任存储池中服务器上的导出目录。要在存储环境中创建新卷，请指定组成卷的 brick 。创建新卷后，必须先启动它，然后再尝试装载它。

### 卷类型

#### Distributed

Distributed volumes    distribute files across the bricks in the volume. You can use distributed    volumes where the requirement is to scale storage and the redundancy is    either not important or is provided by other hardware/software layers.![](../Image/g/glusterfs-DistributedVol.png)

分布式—分布式卷将文件分布在卷中的各个砖上。如果需要扩展存储，并且冗余不重要或由其他硬件/软件层提供，则可以使用分布式卷。

In a distributed volume files are spread randomly across the bricks in the volume. Use distributed volumes where you need to scale storage and redundancy is either not important or is provided by other hardware/software layers.

在分布式卷中，文件在卷中的砖上随机分布。在需要扩展存储的地方使用分布式卷，冗余不重要或由其他硬件/软件层提供。

注意：分布式卷中的磁盘/服务器故障可能会导致严重的数据丢失，因为目录内容在卷中的砖块中随机分布。

> **Note**: Disk/server failure in distributed volumes can result in a serious loss of data because directory contents are spread randomly across the bricks in the volume.

#### Replicated

Replicated volumes replicate    files across bricks in the volume. You can use replicated volumes in    environments where high-availability and high-reliability are critical.

 ![](../Image/g/glusterfs-ReplicatedVol.png)

Replicated–复制的卷跨卷中的砖复制文件。您可以在高可用性和高可靠性至关重要的环境中使用复制卷。

Replicated volumes create copies of files across multiple bricks in the volume. You can use replicated volumes in environments where high-availability and high-reliability are critical.

复制的卷在卷中的多个砖上创建文件副本。您可以在高可用性和高可靠性至关重要的环境中使用复制卷。

注意：砖的数量应等于复制卷的副本计数。为了防止服务器和磁盘故障，建议卷的砖块来自不同的服务器。

> **Note**: The number of bricks should be equal to of the replica count for a replicated volume. To protect against server and disk failures, it is recommended that the bricks of the volume are from different servers.

#### Distributed Replicated

Distributed replicated volumes distribute files across replicated bricks in the    volume. You can use distributed replicated volumes in environments where the    requirement is to scale storage and high-reliability is critical. Distributed    replicated volumes also offer improved read performance in most environments.

 ![](../Image/g/glusterfs-Distributed-ReplicatedVol.png)

分布式复制—分布式复制卷跨卷中的复制砖分发文件。您可以在需要扩展存储且高可靠性至关重要的环境中使用分布式复制卷。分布式复制卷在大多数环境中还提供了改进的读取性能。

Distributes files across replicated bricks in the volume. You can use distributed replicated volumes in environments where the requirement is to scale storage and high-reliability is critical. Distributed replicated volumes also offer improved read performance in most environments.

在卷中的复制砖上分发文件。您可以在需要扩展存储且高可靠性至关重要的环境中使用分布式复制卷。分布式复制卷在大多数环境中还提供了改进的读取性能。

注意：砖的数量应该是分布式复制卷的副本计数的倍数。此外，砖块的指定顺序对数据保护有很大影响。每个副本计数列表中的连续砖块将形成一个副本集，所有副本集合并为一个卷范围的分发集。要确保副本集成员不放在同一节点上，请按相同的顺序列出每个服务器上的第一个砖，然后列出每个服务器的第二个砖，依此类推。

> **Note**: The number of bricks should be a multiple of the replica count for a distributed replicated volume. Also, the order in which bricks are specified has a great effect on data protection. Each replica_count consecutive bricks in the list you give will form a replica set, with all replica sets combined into a volume-wide distribute set. To make sure that replica-set members are not placed on the same node, list the first brick on every server, then the second brick on every server in the same order, and so on.

#### Dispersed

Dispersed volumes are based on    erasure codes, providing space-efficient protection against disk or server    failures. It stores an encoded fragment of the original file to each brick in a    way that only a subset of the fragments is needed to recover the original file.    The number of bricks that can be missing without losing access to data is    configured by the administrator on volume creation time.

 ![](../Image/g/glusterfs-DispersedVol.png)

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

 ![](../Image/n/New-Distributed-DisperseVol.png)

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

# Accessing Data - Setting Up GlusterFS Client

You can access gluster volumes in multiple ways. You can use Gluster Native Client method for high concurrency, performance and transparent failover in GNU/Linux clients. You can also use NFS v3 to access gluster volumes. Extensive testing has been done on GNU/Linux clients and NFS implementation in other operating system, such as FreeBSD, and Mac OS X, as well as Windows 7 (Professional and Up) and Windows Server 2003. Other NFS client implementations may work with gluster NFS server.

You can use CIFS to access volumes when using Microsoft Windows as well as SAMBA clients. For this access method, Samba packages need to be present on the client side.

## Gluster Native Client

The Gluster Native Client is a FUSE-based client running in user space. Gluster Native Client is the recommended method for accessing volumes when high concurrency and high write performance is required.

This section introduces the Gluster Native Client and explains how to install the software on client machines. This section also describes how to mount volumes on clients (both manually and automatically) and how to verify that the volume has mounted successfully.

### Installing the Gluster Native Client

Before you begin installing the Gluster Native Client, you need to verify that the FUSE module is loaded on the client and has access to the required modules as follows:

1. Add the FUSE loadable kernel module (LKM) to the Linux kernel:

   ```
   
   ```

```
modprobe fuse
```

Verify that the FUSE module is loaded:

```

```

1. ```
   # dmesg | grep -i fuse
   fuse init (API version 7.13)
   ```

### Installing on Red Hat Package Manager (RPM) Distributions

To install Gluster Native Client on RPM distribution-based systems

1. Install required prerequisites on the client using the following    command:

   ```
   
   ```

```
sudo yum -y install openssh-server wget fuse fuse-libs openib libibverbs
```

Ensure that TCP and UDP ports 24007 and 24008 are open on all    Gluster servers. Apart from these ports, you need to open one port    for each brick starting from port 49152 (instead of 24009 onwards as    with previous releases). The brick ports assignment scheme is now    compliant with IANA guidelines. For example: if you have    five bricks, you need to have ports 49152 to 49156 open.

From Gluster-10 onwards, the brick ports will be randomized. A port is randomly selected within the range of base_port to max_port as defined in glusterd.vol file and then assigned to the brick. For example: if you have five bricks, you need to have at least 5 ports open within the given range of base_port and max_port. To reduce the number of open ports (for best security practices), one can lower the max_port value in the glusterd.vol file and restart glusterd to get it into effect.

You can use the following chains with iptables:

```

sudo iptables -A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 24007:24008 -j ACCEPT

sudo iptables -A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 49152:49156 -j ACCEPT
```

> **Note**
>  If you already have iptable chains, make sure that the above ACCEPT rules precede the DROP rules. This can be achieved by providing a lower rule number than the DROP rule.

Download the latest glusterfs, glusterfs-fuse, and glusterfs-rdma    RPM files to each client. The glusterfs package contains the Gluster    Native Client. The glusterfs-fuse package contains the FUSE    translator required for mounting on client systems and the    glusterfs-rdma packages contain OpenFabrics verbs RDMA module for    Infiniband.

You can download the software at [GlusterFS download page](http://www.gluster.org/download/).

Install Gluster Native Client on the client.

**Note** The package versions listed in the example below may not be the latest  release. Please refer to the download page to ensure that you have the  recently released packages.

```

```

1. ```
   sudo rpm -i glusterfs-3.8.5-1.x86_64
   sudo rpm -i glusterfs-fuse-3.8.5-1.x86_64
   sudo rpm -i glusterfs-rdma-3.8.5-1.x86_64
   ```

> **Note:** The RDMA module is only required when using Infiniband.

### Installing on Debian-based Distributions

To install Gluster Native Client on Debian-based distributions

1. Install OpenSSH Server on each client using the following command:

   ```
   
   ```

```
sudo apt-get install openssh-server vim wget
```

Download the latest GlusterFS .deb file and checksum to each client.

You can download the software at [GlusterFS download page](http://www.gluster.org/download/).

For each .deb file, get the checksum (using the following command)    and compare it against the checksum for that file in the md5sum    file.

```

md5sum GlusterFS_DEB_file.deb
```

The md5sum of the packages is available at: [GlusterFS download page](https://download.gluster.org/pub/gluster/glusterfs/LATEST/)

Uninstall GlusterFS v3.1 (or an earlier version) from the client    using the following command:

```

sudo dpkg -r glusterfs
```

(Optional) Run `$ sudo dpkg -purge glusterfs`to purge the configuration files.

Install Gluster Native Client on the client using the following    command:

```

sudo dpkg -i GlusterFS_DEB_file
```

For example:

```

sudo dpkg -i glusterfs-3.8.x.deb
```

Ensure that TCP and UDP ports 24007 and 24008 are open on all    Gluster servers. Apart from these ports, you need to open one port    for each brick starting from port 49152 (instead of 24009 onwards as    with previous releases). The brick ports assignment scheme is now    compliant with IANA guidelines. For example: if you have    five bricks, you need to have ports 49152 to 49156 open.

From Gluster-10 onwards, the brick ports will be randomized. A port is randomly selected within the range of base_port to max_port as defined in glusterd.vol file and then assigned to the brick. For example: if you have five bricks, you need to have at least 5 ports open within the given range of base_port and max_port. To reduce the number of open ports (for best security practices), one can lower the max_port value in the glusterd.vol file and restart glusterd to get it into effect.

You can use the following chains with iptables:

```

```

1. ```
   sudo iptables -A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 24007:24008 -j ACCEPT
   
   sudo iptables -A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 49152:49156 -j ACCEPT
   ```

> **Note**
>  If you already have iptable chains, make sure that the above ACCEPT rules precede the DROP rules. This can be achieved by providing a lower rule number than the DROP rule.

### Performing a Source Installation

To build and install Gluster Native Client from the source code

1. Create a new directory using the following commands:

   ```
   
   ```

```
mkdir glusterfs
cd glusterfs
```

Download the source code.

You can download the source at [link](http://www.gluster.org/download/).

Extract the source code using the following command:

```

tar -xvzf SOURCE-FILE
```

Run the configuration utility using the following command:

```

$ ./configure

GlusterFS configure summary
===========================
FUSE client : yes
Infiniband verbs : yes
epoll IO multiplex : yes
argp-standalone : no
fusermount : no
readline : yes
```

The configuration summary shows the components that will be built with Gluster Native Client.

Build the Gluster Native Client software using the following    commands:

```

make
make install`
```

Verify that the correct version of Gluster Native Client is    installed, using the following command:

```

```

1. ```
   glusterfs --version
   ```

## Mounting Volumes

After installing the Gluster Native Client, you need to mount Gluster volumes to access data. There are two methods you can choose:

- [Manually Mounting Volumes](https://docs.gluster.org/en/latest/Administrator-Guide/Setting-Up-Clients/#manual-mount)
- [Automatically Mounting Volumes](https://docs.gluster.org/en/latest/Administrator-Guide/Setting-Up-Clients/#auto-mount)

> **Note**
>  Server names selected during creation of Volumes should be resolvable in the client machine. You can use appropriate /etc/hosts entries or DNS server to resolve server names to IP addresses.



### Manually Mounting Volumes

- To mount a volume, use the following command:

  ```
  
  ```

- ```
  mount -t glusterfs HOSTNAME-OR-IPADDRESS:/VOLNAME MOUNTDIR
  ```

For example:

```

    mount -t glusterfs server1:/test-volume /mnt/glusterfs
```

> **Note**
>  The server specified in the mount command is only used to fetch the gluster configuration volfile describing the volume name. Subsequently, the client will communicate directly with the servers mentioned in the volfile (which might not even include the one used for mount).
>
> If you see a usage message like "Usage: mount.glusterfs", mount usually requires you to create a directory to be used as the mount point. Run "mkdir /mnt/glusterfs" before you attempt to run the mount command listed above.

**Mounting Options**

You can specify the following options when using the `mount -t glusterfs` command. Note that you need to separate all options with commas.

```

backupvolfile-server=server-name

volfile-max-fetch-attempts=number of attempts

log-level=loglevel

log-file=logfile

transport=transport-type

direct-io-mode=[enable|disable]

use-readdirp=[yes|no]
```

For example:

```
mount -t glusterfs -o  backupvolfile-server=volfile_server2,use-readdirp=no,volfile-max-fetch-attempts=2,log-level=WARNING,log-file=/var/log/gluster.log server1:/test-volume /mnt/glusterfs
```

If `backupvolfile-server` option is added while mounting fuse client, when the first volfile server fails, then the server specified in `backupvolfile-server` option is used as volfile server to mount the client.

In `volfile-max-fetch-attempts=X` option, specify the number of attempts to fetch volume files while mounting a volume. This option is useful when you mount a server with multiple IP addresses or when round-robin DNS is configured for the server-name..

If `use-readdirp` is set to ON, it forces the use of readdirp mode in fuse kernel module



### Automatically Mounting Volumes

You can configure your system to automatically mount the Gluster volume each time your system starts.

The server specified in the mount command is only used to fetch the gluster configuration volfile describing the volume name. Subsequently, the client will communicate directly with the servers mentioned in the volfile (which might not even include the one used for mount).

- To mount a volume, edit the /etc/fstab file and add the following  line:

```
HOSTNAME-OR-IPADDRESS:/VOLNAME MOUNTDIR glusterfs defaults,_netdev 0 0
```

For example:

```
server1:/test-volume /mnt/glusterfs glusterfs defaults,_netdev 0 0
```

**Mounting Options**

You can specify the following options when updating the /etc/fstab file. Note that you need to separate all options with commas.

```

log-level=loglevel

log-file=logfile

transport=transport-type

direct-io-mode=[enable|disable]

use-readdirp=no
```

For example:

```
HOSTNAME-OR-IPADDRESS:/VOLNAME MOUNTDIR glusterfs defaults,_netdev,log-level=WARNING,log-file=/var/log/gluster.log 0 0
```

### Testing Mounted Volumes

To test mounted volumes

- Use the following command:

```
# mount
```

If the gluster volume was successfully mounted, the output of the  mount command on the client will be similar to this example:

```
server1:/test-volume on /mnt/glusterfs type fuse.glusterfs (rw,allow_other,default_permissions,max_read=131072
```

- Use the following command:

```
# df
```

The output of df command on the client will display the aggregated  storage space from all the bricks in a volume similar to this  example:

```

  # df -h /mnt/glusterfs
  Filesystem               Size Used Avail Use% Mounted on
  server1:/test-volume     28T 22T 5.4T 82% /mnt/glusterfs
```

- Change to the directory and list the contents by entering the  following:

```

    `# cd MOUNTDIR `
    `# ls`
```

- For example,

```

    `# cd /mnt/glusterfs `
    `# ls`
```

# NFS

You can use NFS v3 to access to gluster volumes. Extensive testing has be done on GNU/Linux clients and NFS implementation in other operating system, such as FreeBSD, and Mac OS X, as well as Windows 7 (Professional and Up), Windows Server 2003, and others, may work with gluster NFS server implementation.

GlusterFS now includes network lock manager (NLM) v4. NLM enables applications on NFSv3 clients to do record locking on files on NFS server. It is started automatically whenever the NFS server is run.

You must install nfs-common package on both servers and clients (only for Debian-based) distribution.

This section describes how to use NFS to mount Gluster volumes (both manually and automatically) and how to verify that the volume has been mounted successfully.

## Using NFS to Mount Volumes

You can use either of the following methods to mount Gluster volumes:

- [Manually Mounting Volumes Using NFS](https://docs.gluster.org/en/latest/Administrator-Guide/Setting-Up-Clients/#manual-nfs)
- [Automatically Mounting Volumes Using NFS](https://docs.gluster.org/en/latest/Administrator-Guide/Setting-Up-Clients/#auto-nfs)

**Prerequisite**: Install nfs-common package on both servers and clients (only for Debian-based distribution), using the following command:

```

    sudo aptitude install nfs-common
```



### Manually Mounting Volumes Using NFS

**To manually mount a Gluster volume using NFS**

- To mount a volume, use the following command:

  ```
  
  ```

- ```
  mount -t nfs -o vers=3 HOSTNAME-OR-IPADDRESS:/VOLNAME MOUNTDIR
  ```

For example:

```

   mount -t nfs -o vers=3 server1:/test-volume /mnt/glusterfs
```

> **Note**
>  Gluster NFS server does not support UDP. If the NFS client you are using defaults to connecting using UDP, the following message appears:
>
> `requested NFS version or transport protocol is not supported`.

**To connect using TCP**

- Add the following option to the mount command:

```
-o mountproto=tcp
```

For example:

```

    mount -o mountproto=tcp -t nfs server1:/test-volume /mnt/glusterfs
```

**To mount Gluster NFS server from a Solaris client**

- Use the following command:

  ```
  
  ```

- ```
  mount -o proto=tcp,vers=3 nfs://HOSTNAME-OR-IPADDRESS:38467/VOLNAME MOUNTDIR
  ```

For example:

```

    mount -o proto=tcp,vers=3 nfs://server1:38467/test-volume /mnt/glusterfs
```



### Automatically Mounting Volumes Using NFS

You can configure your system to automatically mount Gluster volumes using NFS each time the system starts.

**To automatically mount a Gluster volume using NFS**

- To mount a volume, edit the /etc/fstab file and add the following  line:

  ```
  
  ```

- ```
  HOSTNAME-OR-IPADDRESS:/VOLNAME MOUNTDIR nfs defaults,_netdev,vers=3 0 0
  ```

For example,

```
server1:/test-volume /mnt/glusterfs nfs defaults,_netdev,vers=3 0 0
```

> **Note**
>  Gluster NFS server does not support UDP. If the NFS client you are using defaults to connecting using UDP, the following message appears:
>
> ```
> requested NFS version or transport protocol is not supported.
> ```

To connect using TCP

- Add the following entry in /etc/fstab file :

  ```
  
  ```

- ```
  HOSTNAME-OR-IPADDRESS:/VOLNAME MOUNTDIR nfs defaults,_netdev,mountproto=tcp 0 0
  ```

For example,

```
server1:/test-volume /mnt/glusterfs nfs defaults,_netdev,mountproto=tcp 0 0
```

**To automount NFS mounts**

Gluster supports *nix standard method of automounting NFS mounts. Update the /etc/auto.master and /etc/auto.misc and restart the autofs service. After that, whenever a user or process attempts to access the directory it will be mounted in the background.

### Testing Volumes Mounted Using NFS

You can confirm that Gluster directories are mounting successfully.

**To test mounted volumes**

- Use the mount command by entering the following:

```
# mount
```

For example, the output of the mount command on the client will  display an entry like the following:

```
server1:/test-volume on /mnt/glusterfs type nfs (rw,vers=3,addr=server1)
```

- Use the df command by entering the following:

```
# df
```

For example, the output of df command on the client will display the  aggregated storage space from all the bricks in a volume.

```

  # df -h /mnt/glusterfs
  Filesystem              Size Used Avail Use% Mounted on
  server1:/test-volume    28T  22T  5.4T  82%  /mnt/glusterfs
```

- Change to the directory and list the contents by entering the  following:

```
# cd MOUNTDIR`  `# ls
```

# CIFS

You can use CIFS to access to volumes when using Microsoft Windows as well as SAMBA clients. For this access method, Samba packages need to be present on the client side. You can export glusterfs mount point as the samba export, and then mount it using CIFS protocol.

This section describes how to mount CIFS shares on Microsoft Windows-based clients (both manually and automatically) and how to verify that the volume has mounted successfully.

> **Note**
>
> CIFS access using the Mac OS X Finder is not supported, however, you can use the Mac OS X command line to access Gluster volumes using CIFS.

## Using CIFS to Mount Volumes

You can use either of the following methods to mount Gluster volumes:

- [Exporting Gluster Volumes Through Samba](https://docs.gluster.org/en/latest/Administrator-Guide/Setting-Up-Clients/#export-samba)
- [Manually Mounting Volumes Using CIFS](https://docs.gluster.org/en/latest/Administrator-Guide/Setting-Up-Clients/#cifs-manual)
- [Automatically Mounting Volumes Using CIFS](https://docs.gluster.org/en/latest/Administrator-Guide/Setting-Up-Clients/#cifs-auto)

You can also use Samba for exporting Gluster Volumes through CIFS protocol.



### Exporting Gluster Volumes Through Samba

We recommend you to use Samba for exporting Gluster volumes through the CIFS protocol.

**To export volumes through CIFS protocol**

1. Mount a Gluster volume.

2. Setup Samba configuration to export the mount point of the Gluster    volume.

   For example, if a Gluster volume is mounted on /mnt/gluster, you must edit smb.conf file to enable exporting this through CIFS. Open smb.conf file in an editor and add the following lines for a simple configuration:

```

    [glustertest]

    comment = For testing a Gluster volume exported through CIFS

    path = /mnt/glusterfs

    read only = no

    guest ok = yes
```

Save the changes and start the smb service using your systems init scripts (/etc/init.d/smb [re]start). Abhove steps is needed for doing multiple mount. If you want only samba mount then in your smb.conf you need to add

```

    kernel share modes = no
    kernel oplocks = no
    map archive = no
    map hidden = no
    map read only = no
    map system = no
    store dos attributes = yes
```

> **Note**
>
> To be able mount from any server in the trusted storage pool, you must repeat these steps on each Gluster node. For more advanced configurations, see Samba documentation.



### Manually Mounting Volumes Using CIFS

You can manually mount Gluster volumes using CIFS on Microsoft Windows-based client machines.

**To manually mount a Gluster volume using CIFS**

1. Using Windows Explorer, choose **Tools > Map Network Drive…** from    the menu. The **Map Network Drive**window appears.
2. Choose the drive letter using the **Drive** drop-down list.
3. Click **Browse**, select the volume to map to the network drive, and    click **OK**.
4. Click **Finish.**

The network drive (mapped to the volume) appears in the Computer window.

Alternatively, to manually mount a Gluster volume using CIFS by going to **Start > Run** and entering Network path manually.



### Automatically Mounting Volumes Using CIFS

You can configure your system to automatically mount Gluster volumes using CIFS on Microsoft Windows-based clients each time the system starts.

**To automatically mount a Gluster volume using CIFS**

The network drive (mapped to the volume) appears in the Computer window and is reconnected each time the system starts.

1. Using Windows Explorer, choose **Tools > Map Network Drive…** from    the menu. The **Map Network Drive**window appears.
2. Choose the drive letter using the **Drive** drop-down list.
3. Click **Browse**, select the volume to map to the network drive, and    click **OK**.
4. Click the **Reconnect** at logon checkbox.
5. Click **Finish.**

### Testing Volumes Mounted Using CIFS

You can confirm that Gluster directories are mounting successfully by navigating to the directory using Windows Explorer.







配置Server
 编辑Server1和Server2的配置文件glusterfsd.vol的内容

vi /usr/local/etc/glusterfs/glusterfsd.vol

以下的配置内容是配置成复制中继（关于中继的介绍在后面）

\# 指定一个卷，路径为/data/gluster，作为服务器文件
 volume brick
 type storage/posix
 option directory  /data/gluster
 end-volume
 \# 设置卷brick为锁中继（关于中继在附录中介绍）
 volume locker
 type features/posix-locks
 subvolumes brick
 end-volume
 设置卷brick为服务器模式，并指定IP和检测端口，同时设置卷的使用权限为（全部授权），也可以设置成部分授权,如：192.168.1.*
 volume server
 type protocol/server
 option transport-type tcp/server
 option bind-address 192.168.1.101 #Server2时IP配置为: 192.168.1.102
 option listen-port 6996
 subvolumes locker
 option auth.addr.brick.allow *
 option auth.addr.locker.allow *
 end-volume

三：配置Client
 编辑Client的配置文件glusterfs.vol的内容

vi /usr/local/etc/glusterfs/glusterfs.vol

配置内容如下

\# 指向Server1:192.168.1.101服务器的客户端访问配置
 volume client1
 type   protocol/client
 option  transport-type  tcp/client
 option  remote-host  192.168.1.101
 option  transport.socket.remote-port 6996
 option  remote-subvolume locker
 end-volume
 \# 指向Server2:192.168.1.102服务器的客户端访问配置
 volume client2
 type    protocol/client
 option   transport-type  tcp/client
 option   remote-host  192.168.1.102
 option   transport.socket.remote-port 6996
 option   remote-subvolume locker
 end-volume
 \# 将client1和client2设置成复制模式
 volume bricks
 type cluster/replicate
 subvolumes client1 client2
 end-volume

四：启动
 启动Server1和Server2，可以到/tmp/glusterfsd.log里查看启动信息

glusterfsd -f /usr/local/etc/glusterfs/glusterfsd.vol -l /tmp/glusterfsd.log

启动Client，可以到/tmp/glusterfs.log里查看启动信息

mkdir /data/gluster
 glusterfs -f /usr/local/etc/glusterfs/glusterfs.vol -l /tmp/glusterfs.log /data/gluster

启动完成后登入Client：192.168.1.100

cd /data/gluster
 echo 'test' > test.txt

再进入Server1、Server2的/data/gluster发现文件都已经存入，大功告成。

GlusterFS常用的中继介绍

1. storage/posix   #指定一个本地目录给GlusterFS内的一个卷使用；

2. protocol/server   #服务器中继，表示此节点在GlusterFS中为服务器模式，可以说明其IP、守护端口、访问权限；

3. protocol/client   #客户端中继，用于客户端连接服务器时使用，需要指明服务器IP和定义好的卷；

4. cluster/replicate   #复制中继，备份文件时使用，若某子卷掉了，系统仍能正常工作，子卷起来后自动更新（通过客户端）；

5. cluster/distribute   #分布式中继，可以把两个卷或子卷组成一个大卷，实现多存储空间的聚合；

6. features/locks    #锁中继，只能用于服务器端的posix中继之上，表示给这个卷提供加锁(fcntl locking)的功能；

7. performance/read-ahead      #预读中继，属于性能调整中继的一种，用预读的方式提高读取的性能，有利于应用频繁持续性的访问文件，当应用完成当前数据块读取的时候，下一个数据块就已经准备好了，主要是在IB-verbs或10G的以太网上使用；

8. performance/write-behind   #回写中继，属于性能调整中继的一种，作用是在写数据时，先写入缓存内，再写入硬盘，以提高写入的性能，适合用于服务器端；

9. performance/io-threads   #IO线程中继，属于性能调整中继的一种，由于glusterfs 服务是单线程的，使用IO 线程转换器可以较大的提高性能，这个转换器最好是被用于服务器端；

10. performance/io-cache   #IO缓存中继，属于性能调整中继的一种，作用是缓存住已经被读过的数据，以提高IO 性能，当IO 缓存中继检测到有写操作的时候，它就会把相应的文件从缓存中删除，需要设置文件匹配列表及其设置的优先级等内容；

11. cluster/stripe   #条带中继，将单个大文件分成多个小文件存于各个服务器中

    

     设计目的：

1. 集群设计虚拟机容量70-100台,占用1个机柜，全部由1U服务器组成，其中存储服务器6台，300G*8，节点服务器10台；
2. 虚拟机可以在KVM集群宿主机之间迁移；
    glusterfs集群架构：
3. 存储服务器和节点服务器组成，存储服务器通过哈希算法，可以弹性增加或者减少，并实现冗余；
4. 存储服务器每台机器至少需要4块网卡，如果机器只有板载的2块网卡，需要在加1块双口网卡，做4块网卡的绑定，这样可以提高网络带宽；
5. KVM集群每台宿主机作为glusterfs客户端，挂载glusterfs集群的文件系统，将虚拟机放置在上面；





4 添加服务器到存储池

在第一台服务器上执行探测操作

gluster peer probe server1
 gluster peer probe server2
 gluster peer probe server3
 gluster peer probe server4
 gluster peer probe server5

校验集群状态

[root@hp246 ~]# gluster peer status
 Number of Peers: 4
 Hostname: server1
 Uuid: 59cd74a9-a555-4560-b98e-a7eaf2058926
 State: Peer in Cluster (Connected)
 Hostname: server2
 Uuid: 278d94f8-cf55-42cc-a4ad-9f84295c140b
 State: Peer in Cluster (Connected)
 Hostname: server3
 Uuid: 7fd840a2-53f5-4540-b455-3e5e7eded813
 State: Peer in Cluster (Connected)
 Hostname: server4
 Uuid: 4bfd8649-7f74-4a9f-9f04-4267cc80a1c3
 State: Peer in Cluster (Connected)

…

如果需要移出集群 执行如下命令

gluster peer detach server

5 创建集群卷

1)创建一个分布卷（只是卷连接起来，跨区卷）

gluster volume create test-volume server1:/exp1 server2:/exp2 server3:/exp3 server4:/exp4

2)创建一个复制卷(类似raid1)

gluster volume create test-volume replica 2 transport tcp server1:/exp1 server2:/exp2

3)创建一个条带卷(类似raid0)

gluster volume create test-volume stripe 2 transport tcp server1:/exp1 server2:/exp2

4）创建一个分布条带卷(类似raid0+0)

gluster volume create test-volume stripe 4 transport tcp server1:/exp1 server2:/exp2 server3:/exp3 server4:/exp4 server5:/exp5 server6:/exp6 server7:/exp7 server8:/exp8

5）创建一个复制条带卷(类似raid1然后跨区)

gluster volume create test-volume replica 2 transport tcp server1:/exp1 server2:/exp2 server3:/exp3 server4:/exp4

6)创建一个分部复制条带卷(类似raid10)

gluster volume create test-volume stripe 2 replica 2 transport tcp server1:/exp1 server2:/exp2 server3:/exp3 server4:/exp4 server5:/exp5 server6:/exp6 server7:/exp7server8:/exp8

7)创建条带复制卷(类似raid01)

gluster volume create test-volume stripe 2 replica 2 transport tcp server1:/exp1 server2:/exp2 server3:/exp3 server4:/exp4

查看卷信息

gluster volume info

启动卷

gluster volume start test-volume

6 客户端挂载

modprobe fuse
 Verify that the FUSE module is loaded:
 \# dmesg | grep -i fuse
 fuse init (API version 7.13)
 yum -y install wget fuse fuse-libs
 wget http://download.gluster.org/pub/gluster/glusterfs/LATEST/CentOS/glusterfs-3.3.0-1.el6.x86_64.rpm
 wget http://download.gluster.org/pub/gluster/glusterfs/LATEST/CentOS/glusterfs-debuginfo-3.3.0-1.el6.x86_64.rpm
 wget http://download.gluster.org/pub/gluster/glusterfs/LATEST/CentOS/glusterfs-devel-3.3.0-1.el6.x86_64.rpm
 wget http://download.gluster.org/pub/gluster/glusterfs/LATEST/CentOS/glusterfs-fuse-3.3.0-1.el6.x86_64.rpm
 wget http://download.gluster.org/pub/gluster/glusterfs/LATEST/CentOS/glusterfs-geo-replication-3.3.0-1.el6.x86_64.rpm
 wget http://download.gluster.org/pub/gluster/glusterfs/LATEST/CentOS/glusterfs-rdma-3.3.0-1.el6.x86_64.rpm
 wget http://download.gluster.org/pub/gluster/glusterfs/LATEST/CentOS/glusterfs-server-3.3.0-1.el6.x86_64.rpm
 yum install glusterfs-* -y

挂载卷

mount -t glusterfs server1:/test-volume /mnt/glusterfs
 mount -t glusterfs hp246:/test-volume /gfs

自动挂载

vim fstab
 server1:/test-volume /mnt/glusterfs glusterfs defaults,_netdev 0 0

今天测试glusterfs的时候创建存储组老是提示”/data” or a prefix of it is already part of a volume
 心想之前用/data分区测试过，我删除数据试试看，接着创建gluster volume create replicate-stripe replica。。。
 还是尼玛already part of a volume，奇了怪了。果断google还真是个坑爹的bug：https://bugzilla.redhat.com/show_bug.cgi?id=812214

后来在一国外大神的blog找到的解决方法：http://joejulian.name/blog/glusterfs-path-or-a-prefix-of-it-is-already-part-of-a-volume/

话说之前测试glusterfs hang住也是在他blog看到的解决方法。
 问题搞定了。

在这里我自己搞了个简便的方法：

cd $datapath
 for i in <code>attr -lq .</code>; do setfattr -x trusted.$i .; done







GlusterFS 将数据保存在一些被称为“块”的设备中。一个“块”是一个系统路径，由你指定给 gluster 使用。GlusterFS  会将所有“块”组合成一个存储卷，给客户端使用。GlusterFS  会将文件的数据分割成多份，保存在不同的“块”中。所以虽然一个“块”看起来就是一个普通的路径，你最好不要在树莓派中直接操作它，而应该通过客户端访问 GlusterFS 服务，让 GlusterFS 操作。本文中我在两个树莓派中都新建一个 /srv/gv0 目录作为 GlusterFS  的“块”：

```
$ sudo mkdir /srv/gv0
```

在我的环境中，我将 SD 卡上的根文件系统共享出来，而你可能需要共享更大的存储空间。如果是这样的话，在两块树莓派上都接上 USB  硬盘，格式化后挂载到 /srv/gv0 上。编辑下 /etc/fstab 文件，确保系统每次启动时都会把你的 USB  硬盘挂载上去。两个树莓派上的“块”不一定需要有相同的名字或者相同的路径名称，但是把它们设置为相同的值也没什么坏处。

目前为止，我的 pi1 (192.168.0.121) 信任 pi2 (192.168.0.122)，我可以建立一个存储卷，名字都想好了：gv0。在主设备端运行命令“gluster volume create”：

```
pi@pi1 ~ $ sudo gluster volume create gv0 replica 2 192.168.0.121:/srv/gv0 192.168.0.122:/srv/gv0
Creation of volume gv0 has been successful. Please start 
the volume to access data.
```

这里稍微解释一下命令的意思。“gluster volume  create”就是新建一个卷；“gv0”是卷名，这个名称将会在客户端被用到；“replica  2”表示这个卷的数据会在两个“块”之间作冗余，而不是将数据分割成两份分别存于两个“块”。这个命令保证了卷内的数据会被复制成两份分别保存在两个“块”中。最后我定义两个独立的“块”，作为卷的存储空间：192.168.0.121 上的 /srv/gv0 和 192.168.0.122 上的 /srv/gv0。

现在，卷被成功创建，我只需启动它：

```
pi@pi1 ~ $ sudo gluster volume start gv0
Starting volume gv0 has been successful
```

然后我可以在任何一个树莓派上使用“volume info”命令来查看状态：

```
$ sudo gluster volume info

Volume Name: gv0
Type: Replicate
Status: Started
Number of Bricks: 2
Transport-type: tcp
Bricks:
Brick1: 192.168.0.121:/srv/gv0
Brick2: 192.168.0.122:/srv/gv0
```

## 配置 GlusterFS 客户端

卷已启动，现在我可以在一个支持 GlusterFS 的客户端上，将它作为一个 GlusterFS 类型的文件系统挂载起来。首先我想在这两个树莓派上挂载这个卷，于是我在两个树莓派上都创建了挂载点，并下面的命令把这个卷挂载上去：

```
$ sudo mkdir -p /mnt/gluster1
$ sudo mount -t glusterfs 192.168.0.121:/gv0 /mnt/gluster1
$ df
Filesystem         1K-blocks    Used Available Use% Mounted on
rootfs               1804128 1496464    216016  88% /
/dev/root            1804128 1496464    216016  88% /
devtmpfs               86184       0     86184   0% /dev
tmpfs                  18888     216     18672   2% /run
tmpfs                   5120       0      5120   0% /run/lock
tmpfs                  37760       0     37760   0% /run/shm
/dev/mmcblk0p1         57288   18960     38328  34% /boot
192.168.0.121:/gv0   1804032 1496448    215936  88% /mnt/gluster1
```

如果你是一个喜欢钻研的读者，你可能会问了：“如果我指定了一个 IP 地址，如果192.168.0.121当机了，怎么办？”。别担心，这个 IP 地址仅仅是为了指定使用哪个卷，当我们访问这个卷的时候，卷内的两个“块”都会被访问到。

当你挂载好这个文件系统后，试试在里面新建文件，然后查看一下“块”对应的路径：/srv/gv0。你应该可以看到你在 /mngt/gluster1 里创建的文件，在两个树莓派的 /srv/gv0 上都出现了（重申一遍，不要往 /srv/gv0 里写数据）：

```
pi@pi1 ~ $ sudo touch /mnt/gluster1/test1
pi@pi1 ~ $ ls /mnt/gluster1/test1
/mnt/gluster1/test1
pi@pi1 ~ $ ls /srv/gv0
test1
pi@pi2 ~ $ ls /srv/gv0
test1
```

你可以在 /etc/fstab 上添加下面一段，就可以在系统启动的时候自动把 GlusterFS 的卷挂载上来：

```
192.168.0.121:/gv0  /mnt/gluster1  glusterfs  defaults,_netdev  0  0
```

注意：如果你想通过其他客户端访问到这个 GlusterFS 卷，只需要安装一个 GlusterFS 客户端（在基于 Debian 的发行版里，这个客户端叫 glusterfs-client），然后接我上面介绍的，创建挂载点，将卷挂载上去。

## 冗余测试

现在我们就来测试一下这个冗余文件系统。我们的目标是，当其中一个节点当掉，我们还能访问 GlusterFS 卷里面的文件。首先我配置一个独立的客户端用于挂载 GlusterFS 卷，然后新建一个简单的脚本文件放在卷中，文件名为“glustertest”：

```
#!/bin/bash

while [ 1 ]
do
  date > /mnt/gluster1/test1
  cat /mnt/gluster1/test1
  sleep 1
done
```

这个脚本运行无限循环并每隔1秒打印出系统时间。当我运行这个脚本时，我可以看到下面的信息：

```
# chmod a+x /mnt/gluster1/glustertest
root@moses:~# /mnt/gluster1/glustertest
Sat Mar  9 13:19:02 PST 2013
Sat Mar  9 13:19:04 PST 2013
Sat Mar  9 13:19:05 PST 2013
Sat Mar  9 13:19:06 PST 2013
Sat Mar  9 13:19:07 PST 2013
Sat Mar  9 13:19:08 PST 2013
```

我发现这个脚本偶尔会跳过1秒，可能是 date 这个命令并不是很精确地每隔1秒钟打印一次，所以偶尔会出现输出时间不连惯的现象。

当我执行这个脚本后，我登入一个树莓派并输入“sudo  reboot”重启这个设备。这个脚本一直在运行，如果出现输出时间不连惯现象，我不知道还是不是上面说的偶然现象。当第一个树莓派启动后，我重启第二个树莓派，确认下这个系统有一个节点丢失后，我的程序仍然能正常工作。这个冗余系统配置起来只需要几个命令，如果你需要一个冗余系统，这是个不错的选择。

现在你已经实现了 2 Pi R 组成的冗余文件系统，在我的下篇文章中，我将会加入新的冗余服务，将这个共享存储系统好好利用起来。

Step 1 – 至少2个节点

    Fedora 22 (or later) on two nodes named "server1" and "server2"
    A working network connection
    At least two virtual disks, one for the OS installation, and one to be used to serve GlusterFS storage (sdb). This will emulate a real world deployment, where you would want to separate GlusterFS storage from the OS install.
    Note: GlusterFS stores its dynamically generated configuration files at /var/lib/glusterd. If at any point in time GlusterFS is unable to write to these files (for example, when the backing filesystem is full), it will at minimum cause erratic behavior for your system; or worse, take your system offline completely. It is advisable to create separate partitions for directories such as /var/log to ensure this does not happen.

Step 2 - Format and mount the bricks

(on both nodes): Note: These examples are going to assume the brick is going to reside on /dev/sdb1.

    mkfs.xfs -i size=512 /dev/sdb1
    mkdir -p /data/brick1
    echo '/dev/sdb1 /data/brick1 xfs defaults 1 2' >> /etc/fstab
    mount -a && mount

You should now see sdb1 mounted at /data/brick1
Step 3 - Installing GlusterFS

(on both servers) Install the software

    yum install glusterfs-server

Start the GlusterFS management daemon:

    service glusterd start
    service glusterd status
    glusterd.service - LSB: glusterfs server
           Loaded: loaded (/etc/rc.d/init.d/glusterd)
       Active: active (running) since Mon, 13 Aug 2012 13:02:11 -0700; 2s ago
      Process: 19254 ExecStart=/etc/rc.d/init.d/glusterd start (code=exited, status=0/SUCCESS)
       CGroup: name=systemd:/system/glusterd.service
           ├ 19260 /usr/sbin/glusterd -p /run/glusterd.pid
           ├ 19304 /usr/sbin/glusterfsd --xlator-option georep-server.listen-port=24009 -s localhost...
           └ 19309 /usr/sbin/glusterfs -f /var/lib/glusterd/nfs/nfs-server.vol -p /var/lib/glusterd/...

Step 4 - Configure the trusted pool

From "server1"

    gluster peer probe server2

Note: When using hostnames, the first server needs to be probed from one other server to set its hostname.

From "server2"

    gluster peer probe server1

Note: Once this pool has been established, only trusted members may probe new servers into the pool. A new server cannot probe the pool, it must be probed from the pool.
Step 5 - Set up a GlusterFS volume

On both server1 and server2:

    mkdir -p /data/brick1/gv0

From any single server:

    gluster volume create gv0 replica 2 server1:/data/brick1/gv0 server2:/data/brick1/gv0
    gluster volume start gv0

Confirm that the volume shows "Started":

    gluster volume info

Note: If the volume is not started, clues as to what went wrong will be in log files under /var/log/glusterfs on one or both of the servers - usually in etc-glusterfs-glusterd.vol.log
Step 6 - Testing the GlusterFS volume

For this step, we will use one of the servers to mount the volume. Typically, you would do this from an external machine, known as a "client". Since using this method would require additional packages to be installed on the client machine, we will use one of the servers as a simple place to test first, as if it were that "client".

    mount -t glusterfs server1:/gv0 /mnt
      for i in `seq -w 1 100`; do cp -rp /var/log/messages /mnt/copy-test-$i; done

First, check the mount point:

    ls -lA /mnt | wc -l

You should see 100 files returned. Next, check the GlusterFS mount points on each server:

    ls -lA /data/brick1/gv0

You should see 100 files on each server using the method we listed here. Without replication, in a distribute only volume (not detailed here), you should see about 50 files on each one.





