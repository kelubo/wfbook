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
> If you already have iptable chains, make sure that the above ACCEPT rules precede the DROP rules. This can be achieved by providing a lower rule number than the DROP rule.

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
> If you already have iptable chains, make sure that the above ACCEPT rules precede the DROP rules. This can be achieved by providing a lower rule number than the DROP rule.

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
> Server names selected during creation of Volumes should be resolvable in the client machine. You can use appropriate /etc/hosts entries or DNS server to resolve server names to IP addresses.



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
> The server specified in the mount command is only used to fetch the gluster configuration volfile describing the volume name. Subsequently, the client will communicate directly with the servers mentioned in the volfile (which might not even include the one used for mount).
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
> Gluster NFS server does not support UDP. If the NFS client you are using defaults to connecting using UDP, the following message appears:
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
> Gluster NFS server does not support UDP. If the NFS client you are using defaults to connecting using UDP, the following message appears:
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

12. 集群设计虚拟机容量70-100台,占用1个机柜，全部由1U服务器组成，其中存储服务器6台，300G*8，节点服务器10台；

13. 虚拟机可以在KVM集群宿主机之间迁移；
    glusterfs集群架构：

14. 存储服务器和节点服务器组成，存储服务器通过哈希算法，可以弹性增加或者减少，并实现冗余；

15. 存储服务器每台机器至少需要4块网卡，如果机器只有板载的2块网卡，需要在加1块双口网卡，做4块网卡的绑定，这样可以提高网络带宽；

16. KVM集群每台宿主机作为glusterfs客户端，挂载glusterfs集群的文件系统，将虚拟机放置在上面；





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

