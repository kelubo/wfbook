# NFS

[TOC]

Network File System

RHEL 8 默认版本为4.2。支持NFSv4和NFSv3的主要版本，NFSv2已不再受支持。

NFSv4仅使用TCP协议与服务器进行通信；较早的版本可使用TCP或UDP。

将NFS服务器中的一个或多个目录共享出来，使得远端的NFS客户端系统可以挂载此共享的文件系统。



## 状态

跟踪每个客户机打开的文件，这种信息一般称为“状态”。  
## 文件上锁机制
NFSv4不再想要lockd和statd两个守护进程。
## 端口
NFSv4采用TCP协议，端口号2049。
## 安全性
不建议用NFSv2和NFSv3通过广域网提供文件服务。应禁止对TCP和UDP 2049端口的访问，禁止对portmap用的TCP和UDP 111端口的访问。

NFS既然是网络文件系统，客户端和服务端就需要网络来传输数据，NFS服务器端基本会使用2049端口，但因文件系统非常复杂，NFS还会有其他的程序去启动额外的端口用于数据传输，这些额外的传输数据的端口是随机选择小于1024的端口；客户端需要通过远程过程调用（Remote Procedure Call,RPC）协议来找到对应的端口。

**基于RPC通讯调用的NFS实现原理：**

NFS运行过程中需要支持的相当多的功能，不同的功能会使用不同的程序来启动，相对应的就需要启用一些端口来传输数据，所以NFS的功能对应的端口并不固定，客户端需要清楚NFS服务器端的相关端口才能建立连接进行数据传输，RPC就是用来统一管理NFS端口的服务，并且统一对外的端口是111（有点类似nginx，当然这里没有负载均衡，仅仅有点类似代理），RPC会记录NFS每个功能服务的端口的信息，客户端通过RPC实现双方沟通端口信息。

NFS启动就会向RPC去注册自己的所有功能的端口信息，RPC记录下这些端口信息，而RPC会开启111端口对外服务，等待客户端RPC的请求，有客户端请求，服务器端的RPC就会将记录的NFS端口信息发送给客户端，以实际端口进行数据的传输。因此在启动NFS服务之前，需要先启动RPC服务（即centos5.x以下的系统中是portmap服务，centos6.x以上是**rpc-bind**服务，red hat enterprise linux同理），RPC服务重新启动，原来已注册好的NFS端口数据就会全部丢失。此时RPC服务管理的NFS程序需要重新启动以重新向RPC注册。

**注意：**修改NFS配置文件后，不要重启NFS服务，直接命令执行**exportfs –rv**即可使修改的/etc/exports配置文件重新载入而生效。

**NFS工作流程**

1. 服务端启动RPC服务，开启111端口（rpc-bind服务）；
2. 服务端启动NFS服务，向RPC注册端口信息（一般是1024以下的端口）；
3. 客户端启动RPC（rpc-bind服务），向服务端的RPC(rpc-bind服务)服务请求服务端的NFS端口；
4. 服务端的RPC(rpc-bind服务)服务返回NFS端口信息给客户端；
5. 客户端通过获得的NFS端口与服务端的RPC连接并进行数据传输。



安装系统环境：CentOS7

所需软件：

1. **RPC主程序：rpcbind**
2. **NFS主程序：nfs-utils**

**NFS服务主要文件说明：**

**主要配置文件：/etc/exports**

NFS 的主要配置文件，NFS的配置只需在此文件中配置即可。此文件需要手动生成。

**NFS 文件系统维护命令：/usr/sbin/exportfs**

维护 NFS 分享资源的命令，可使用此命令重新载入 /etc/exports内容、实现将NFS服务端共享的目录卸除或重新共享。

**查询服务器共享资源详情的命令：/usr/sbin/showmount**

exportfs 用在 NFS 服务端，showmount 主要用在客户端。showmount 主要用来察看 NFS 客户端共享的目录资源详情。

## NFS服务端

第一步：安装所需软件

**yum install -y nfs-utils rpcbind**

第二部：启动RPC、NFS服务

**systemctl start rpcbind** #先启动rpc服务

**systemctl enable rpcbind**  #设置开机启动

**systemctl start nfs-server** #启动nfs服务

**firewall-cmd --permanent --add-service=nfs** #配置防火墙放行nfs服务

**firewall-cmd --reload** #防火墙重载生效

第三部：新建共享目录

**mkdir -p /nfsdata01** #创建共享目录

**mkdir -p /nfsdata02** #创建共享目录

第四步：编辑配置文件：

**vim /etc/exports**  #vim编辑共享配置文件

内容：

**/nfsdata01 10.211.55.0/24(rw,async,all_squash,insecure)**

**/nfsdata02 \*(rw,async,all_squash,insecure)**

![CentOS7服务搭建----搭建NFS（网络文件系统）服务器](http://p3.pstatp.com/large/pgc-image/c049fc2fb9d94235ac16705c21f3087f)

exports文件内容

**配置内容说明：**

格式： **共享目录的路径** **允许访问的NFS客户端**(共享权限参数)

如上，共享目录为/**nfsdata01** , 允许访问的客户端为**10.211.55.0/24**网络用户，权限为可读写，优先将数据保存到内存然后在写入到硬盘，无论客户端是说明账户都映射为nfsnobody账户。

**请注意，NFS客户端地址与权限之间没有空格。**

参数：作用

1. ro：只读
2. rw：读写
3. root_squash：当NFS客户端以root管理员访问时，映射为NFS服务器的匿名用户
4. no_root_squash：当NFS客户端以root管理员访问时，映射为NFS服务器的root管理员
5. all_squash：无论NFS客户端使用什么账户访问，均映射为NFS服务器的匿名用户
6. sync：同时将数据写入到内存与硬盘中，保证不丢失数据
7. async：优先将数据保存到内存，然后再写入硬盘；这样效率更高，但可能会丢失数据
8. insecure：允许客户端从大于1024的tcp/ip端口连接服务器

第五步：重新载入共享配置使之生效

**exportfs -rv**

第六步：查看共享状态

**showmount -e localhost**

![CentOS7服务搭建----搭建NFS（网络文件系统）服务器](http://p3.pstatp.com/large/pgc-image/102892f7a7ea45adadf790f396725c60)

共享生效

## NFS客户端

### 挂载NFS共享的方式

* 使用`mount`命令手动挂载。
* 使用`/etc/fstab`条目在启动时自动挂载。
* 按需挂载，使用`autofs`服务或`systemd.automount`功能。



第一步：从客户端远程查看服务端共享状态

**showmount -e 10.211.55.20**

### 挂载NFS

```bash
# 方法1
mount -t nfs -o rw,sync serverb:/share mountpoint
# -o sync	使mount立即与NFS服务器同步写操作（默认值为异步）

# 方法2
vim /etc/fstab
serverb:/share  /mountpoint  nfs  rw,sync  0 0

mount /mountpoint
```

第三步：查看挂载

df -h

![CentOS7服务搭建----搭建NFS（网络文件系统）服务器](http://p1.pstatp.com/large/pgc-image/c269ab13fea64a8c8530013e0e4e9c38)

### 卸载NFS

```bash
umount mountpoint
```

## nfsconf工具

RHEL8 引入nfsconf工具，用于管理NFSv4与NFSv3下的NFS客户端和服务器配置文件。

配置文件：`/etc/nfs.conf`  (早期版本的操作系统中的/etc/sysconfig/nfs文件现已被弃用).1

```bash
/etc/nfs.conf

[nfsd]
# debug=0
# threads=8
# host=
# port=0
# grace-time=90
# lease-time=90
# tcp=y
# vers2=n
# vers3=y
# vers4=y
# vers4.0=y
# vers4.1=y
# vers4.2=y
# rdma=n
```

使用 `nfsconf --set  section  key  value` 来设置指定部分的键值。

```bash
nfsconf --set nfsd vers4.2 y
```

使用 `nfsconf --get section key` 来检索指定部分的键值。

```bash
nfsconf --get nfsd vers4.2
y
```

使用 `nfsconf --unset section key` 来取消设置指定部分的键值。

```bash
nfsconf --unset nfsd vers4.2
```

### 配置一个仅限使用NFSv4的客户端

```bash
# 禁用UDP以及其他与NFSv2和NFSv3有关的键
nfsconf --set nfsd udp n
nfsconf --set nfsd vers2 n
nfsconf --set nfsd vers3 n

# 启用TCP和NFSv4相关键
nfsconf --set nfsd tcp y
nfsconf --set nfsd vers4 y
nfsconf --set nfsd vers4.0 y
nfsconf --set nfsd vers4.1 y
nfsconf --set nfsd vers4.2 y
```

## autofs

自动挂载器是一种服务，可以“根据需要”自动挂载NFS共享，并将在不再使用NFS共享时自动卸载这些共享。

**优势：**

* 用户无需具有root特权就可以运行mount和umount命令。
* 自动挂载器中配置的NFS共享可供计算机上的所有用户使用，受访问权限约束。
* NFS共享不像/etc/fstab中的条目一样永久连接，从而可释放网络和系统资源。
* 自动挂载器在客户端配置，无需进行任何服务器端配置。
* 自动挂载器与mount命令使用相同的选项，包括安全性选项。
* 支持直接和间接挂载点映射，在挂载点位置方面提供了灵活性。
* 可创建和删除间接挂载点，从而避免了手动管理。
* NFS是默认的自动挂载器网络文件系统，但也可以自动挂载其他网络文件系统。
* autofs是一种服务，其管理方式类似于其他系统服务。

### 创建自动挂载

安装 `autofs` 软件包

```bash
yum install autofs
```

向 `/etc/auto.master.d` 添加一个主映射文件。该文件确定用于挂载点的基础目录，并确定用于创建自动挂载的映射文件。

```bash
vim /etc/auto.master.d/demo.autofs
# 文件名可以是任意的。
/shares		/etc/auto.demo
# 为间接映射的挂载添加主映射条目。
# 此条目将使用/shares目录作为间接自动挂载的基础目录。/etc/auto.demo文件中包含挂载详细信息。# 使用绝对文件名。在启动autofs服务之前创建auto.demo文件。
```

创建映射文件。

```bash
vim /etc/auto.demo
# 映射文件的命名规则是/etc/auto.name，其中name反映了映射内容。
work	-rw,sync	serverb:/shares/work
# 条目的格式为 挂载点、挂载选项和源位置。
# 挂载点在man page中被称为"密钥"，由autofs服务自动创建和删除。此例中，完全限定挂载点
# 是/shares/work。autofs服务将根据需要创建和删除/shares目录和/shares/work目录。
# 其他选项：
#		-fstype=	指定文件系统类型
#		-strict		将错误视为严重
```

启动并启用自动挂载器服务。

```bash
systemctl enable --now autofs
```

### 直接映射

用于将NFS共享映射到现有的绝对路径挂载点。

```bash
vim /etc/auto.master.d/demo.autofs
# 文件名可以是任意的。
/-		/etc/auto.direct

vim /etc/auto.direct
/mnt/docs	-rw,sync	serverb:/shares/docs
```

### 间接通配符映射

当NFS服务器导出一个目录中的多个子目录时，可将自动挂载程序配置为使用单个映射条目访问这些子目录其中的任何一个。

```bash
vim /etc/auto.demo
*	-rw,sync	serverb:/shares/&
# 当用户尝试访问/shares/work时，密钥*（此例中为work）将代替源位置中的&符号，并挂载serverb:/shares/work。
```

