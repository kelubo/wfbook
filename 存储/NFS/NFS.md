# NFS

Network File System

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



# 二，NFS服务端安装共享步骤：

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



## 三，NFS客户端安装挂载步骤：

第一步：从客户端远程查看服务端共享状态

**showmount -e 10.211.55.20**

![CentOS7服务搭建----搭建NFS（网络文件系统）服务器](http://p9.pstatp.com/large/pgc-image/0bf7bca0b8ab459cac5e10daaa89361b)

客户端操作查看nfs服务器共享状态

第二步：挂载nfs

mount 10.211.55.20:/nfsdata01

第三步：查看挂载

df -h

![CentOS7服务搭建----搭建NFS（网络文件系统）服务器](http://p1.pstatp.com/large/pgc-image/c269ab13fea64a8c8530013e0e4e9c38)

挂载并查看