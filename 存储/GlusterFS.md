# GlusterFS

[TOC]

GlusterFS is a scalable network filesystem suitable for data-intensive tasks such as cloud storage and media streaming.   Gluster FS是一个可扩展的网络文件系统，适合于数据密集型任务，如云存储和媒体流。

Gluster is a scalable, distributed file system that aggregates disk  storage resources from multiple servers into a single global namespace.Gluster是一个可扩展的分布式文件系统，它将来自多个服务器的磁盘存储资源聚合到一个全局名称空间中。

GlusterFS是一个(Cluster File System)分布式集群文件系统, 它的最大特点就是以 Brick  (Dirctory)  为节点。具有强大的线性横向扩展能力，通过扩展能够支持数PB存储容量和处理数千客户端。GlusterFS借助TCP/IP或InfiniBand  RDMA 网络将物理分布的存储资源聚集在一起，使用单一全局命名空间来管理数据。

## 安装

### 准备节点

- Fedora 30 (or later) on 3 nodes named "server1", "server2" and "server3"
- A working network connection
- At least two virtual disks, one for the OS installation, and one to be    used to serve GlusterFS storage (sdb), on each of these VMs. 
- Setup NTP on each of these servers to get the proper functioning of    many applications on top of filesystem. This is an important requirement

**Note**: GlusterFS stores its dynamically generated configuration files    at `/var/lib/glusterd`. If at any point in time GlusterFS is unable to    write to these files (for example, when the backing filesystem is full),    it will at minimum cause erratic behavior for your system; or worse,    take your system offline completely. It is recommended to create separate    partitions for directories such as `/var/log` to reduce the chances of this happening.

Gluster  FS将其动态生成的配置文件存储在/var/lib/glusterd。如果Gluster  FS在任何时候都无法写入这些文件（例如，当备份文件系统已满时），它至少会导致系统行为不稳定；或者更糟的是，使系统完全脱机。建议为/var/log等目录创建单独的分区，以减少发生这种情况的可能性。

### 格式化及挂载硬盘

Perform this step on all the nodes, "server{1,2,3}"

```bash
mkfs.xfs -i size=512 /dev/sdb1
mkdir -p /data/brick1
echo '/dev/sdb1 /data/brick1 xfs defaults 1 2' >> /etc/fstab
mount -a && mount
```

### 安装 GlusterFS

Install the software

```bash
yum install centos-release-gluster8
yum install glusterfs-server
```

开启 GlusterFS management daemon:

```bash
systemctl start glusterd

systemctl status glusterd
glusterd.service - LSB: glusterfs server
       Loaded: loaded (/etc/rc.d/init.d/glusterd)
   Active: active (running) since Mon, 13 Aug 2012 13:02:11 -0700; 2s ago
   Process: 19254 ExecStart=/etc/rc.d/init.d/glusterd start (code=exited, status=0/SUCCESS)
   CGroup: name=systemd:/system/glusterd.service
       ├ 19260 /usr/sbin/glusterd -p /run/glusterd.pid
       ├ 19304 /usr/sbin/glusterfsd --xlator-option georep-server.listen-port=24009 -s localhost...
       └ 19309 /usr/sbin/glusterfs -f /var/lib/glusterd/nfs/nfs-server.vol -p /var/lib/glusterd/...
```

### Configure the trusted pool

From "server1"

```bash
gluster peer probe server2
gluster peer probe server3
```

Check the peer status on server1

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

### Set up a GlusterFS volume

On all servers:

```
mkdir -p /data/brick1/gv0
```

From any single server:

```

# gluster volume create gv0 replica 3 server1:/data/brick1/gv0 server2:/data/brick1/gv0 server3:/data/brick1/gv0
volume create: gv0: success: please start the volume to access data
# gluster volume start gv0
volume start: gv0: success
```

Confirm that the volume shows "Started":

```

# gluster volume info
```

You should see something like this (the Volume ID will differ):

```

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

Note: If the volume does not show "Started", the files under `/var/log/glusterfs/glusterd.log` should be checked in order to debug and diagnose the situation. These logs can be looked at on one or, all the servers configured.

### Testing the GlusterFS volume

For this step, we will use one of the servers to mount the volume. Typically, you would do this from an external machine, known as a "client". Since using this method would require additional packages to be installed on the client machine, we will use one of the servers as a simple place to test first , as if it were that "client".

```

# mount -t glusterfs server1:/gv0 /mnt
# for i in `seq -w 1 100`; do cp -rp /var/log/messages /mnt/copy-test-$i; done
```

First, check the client mount point:

```
# ls -lA /mnt/copy* | wc -l
```

You should see 100 files returned. Next, check the GlusterFS brick mount points on each server:

```

# ls -lA /data/brick1/gv0/copy*
```

You should see 100 files on each server using the method we listed here. Without replication, in a distribute only volume (not detailed here), you should see about 33 files on each one.



A gluster volume is a collection of servers belonging to a Trusted Storage Pool. A management daemon (glusterd) runs on each server and manages a brick process (glusterfsd) which in turn exports the underlying on disk storage (XFS filesystem). The client process mounts the volume and exposes the storage from all the bricks as a single unified storage namespace to the applications accessing it. The client and brick processes' stacks have various translators loaded in them. I/O from the application is routed to different bricks via these translators.

### Types of Volumes

Gluster file system supports different types of volumes based on the requirements. Some volumes are good for scaling storage size, some for improving performance and some for both.

\1. ***\*Distributed Glusterfs Volume\**** - This is the type of volume which is created by default if no volume type is specified. Here, files are distributed across various bricks in the volume. So file1 may be stored only in brick1 or brick2 but not on both. Hence there is **no data redundancy**. The purpose for such a storage volume is to easily & cheaply scale the volume size. However this also means that a brick failure will lead to complete loss of data and one must rely on the underlying hardware for data loss protection.

![distributed volume](https://docs.gluster.org/en/latest/images/New-DistributedVol.png)

Create a Distributed Volume

```

gluster volume create NEW-VOLNAME [transport [tcp | rdma | tcp,rdma]] NEW-BRICK...
```

**For example** to create a distributed volume with four storage servers using TCP.

```

# gluster volume create test-volume server1:/exp1 server2:/exp2 server3:/exp3 server4:/exp4
volume create: test-volume: success: please start the volume to access data
```

To display the volume info

```

# gluster volume info
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

\2. ***\*Replicated Glusterfs Volume\**** - In this volume we overcome the risk of data loss which is present in the distributed volume. Here exact copies of the data are maintained on all bricks. The number of replicas in the volume can be decided by client while creating the volume. So we need to have at least two bricks to create a volume with 2 replicas or a minimum of three bricks to create a volume of 3 replicas. One major advantage of such a volume is that even if one brick fails the data can still be accessed from its replicated bricks. Such a volume is used for better reliability and data redundancy.

![replicated volume](https://docs.gluster.org/en/latest/images/New-ReplicatedVol.png)

Create a Replicated Volume

```

gluster volume create NEW-VOLNAME [replica COUNT] [transport [tcp |rdma | tcp,rdma]] NEW-BRICK...
```

**For example**, to create a replicated volume with three storage servers:

```

# gluster volume create test-volume replica 3 transport tcp \
      server1:/exp1 server2:/exp2 server3:/exp3
volume create: test-volume: success: please start the volume to access data
```

\3. ***\*Distributed Replicated Glusterfs Volume\**** - In this volume files are distributed across replicated sets of bricks. The number of bricks must be a multiple of the replica count. Also the order in which we specify the bricks is important since adjacent bricks become replicas of each other. This type of volume is used when high availability of data due to redundancy and scaling storage is required. So if there were eight bricks and replica count 2 then the first two bricks become replicas of each other then the next two and so on. This volume is denoted as 4x2. Similarly if there were eight bricks and replica count 4 then four bricks become replica of each other and we denote this volume as 2x4 volume.

![distributed_replicated_volume](https://docs.gluster.org/en/latest/images/New-Distributed-ReplicatedVol.png)

Create the distributed replicated volume:

```

gluster volume create NEW-VOLNAME [replica COUNT] [transport [tcp | rdma | tcp,rdma]] NEW-BRICK...
```

**For example**, six node distributed replicated volume with a three-way mirror:

```

# gluster volume create test-volume replica 3 transport tcp server1:/exp1 server2:/exp2 server3:/exp3 server4:/exp4 server5:/exp5 server6:/exp6
volume create: test-volume: success: please start the volume to access data
```

\4. ***\*Dispersed Glusterfs Volume\**** - Dispersed volumes are based on erasure codes. It stripes the encoded data of files, with some redundancy added, across multiple bricks in the volume. You can use dispersed volumes to have a configurable level of reliability with minimum space waste. The number of redundant bricks in the volume can be decided by clients while creating the volume. Redundant bricks determines how many bricks can be lost without interrupting the operation of the volume.

![Dispersed volume](https://docs.gluster.org/en/latest/images/New-DispersedVol.png) Create a dispersed volume:

```

# gluster volume create test-volume [disperse [<COUNT>]] [disperse-data <COUNT>] [redundancy <COUNT>] [transport tcp | rdma | tcp,rdma] <NEW-BRICK>
```

**For example**, three node dispersed volume with level of redundancy 1, (2 + 1):

```

# gluster volume create test-volume disperse 3 redundancy 1 server1:/exp1 server2:/exp2 server3:/exp3
volume create: test-volume: success: please start the volume to access data
```

\5. ***\*Distributed Dispersed Glusterfs Volume\**** - Distributed dispersed volumes are the equivalent to distributed replicated volumes, but using dispersed subvolumes instead of replicated ones. The number of bricks must be a multiple of the 1st subvol. The purpose for such a volume is to easily scale the volume size and distribute the load across various bricks.

![distributed_dispersed_volume](https://docs.gluster.org/en/latest/images/New-Distributed-DisperseVol.png) Create a distributed dispersed volume:

```

# gluster volume create [disperse [<COUNT>]] [disperse-data <COUNT>] [redundancy <COUNT>] [transport tcp | rdma | tcp,rdma] <NEW-BRICK>
```

**For example**, six node distributed dispersed volume with level of redundancy 1, 2 x (2 + 1) = 6:

```

# gluster volume create test-volume disperse 3 redundancy 1 server1:/exp1 server2:/exp2 server3:/exp3 server4:/exp4 server5:/exp5 server6:/exp6
volume create: test-volume: success: please start the volume to access data
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

### **FUSE**

GlusterFS is a userspace filesystem. The GluserFS developers opted  for this approach in order to avoid the need to have modules in the  Linux kernel.

As it is a userspace filesystem, to interact with kernel VFS, GlusterFS makes use of FUSE (File System in Userspace). For a long time, implementation of a userspace filesystem was considered impossible. FUSE was developed as a solution for this. FUSE is a kernel module that support interaction between kernel VFS and non-privileged user applications and it has an API that can be accessed from userspace. Using this API, any type of filesystem can be written using almost any language you prefer as there are many bindings between FUSE and other languages.

![fuse_structure](https://cloud.githubusercontent.com/assets/10970993/7412530/67a544ae-ef61-11e4-8979-97dad4031a81.png)

*Structural diagram of FUSE.*

This shows a filesystem "hello world" that is compiled to create a binary "hello". It is executed with a filesystem mount point /tmp/fuse. Then the user issues a command ls -l on the mount point /tmp/fuse. This command reaches VFS via glibc and since the mount /tmp/fuse corresponds to a FUSE based filesystem, VFS passes it over to FUSE module. The FUSE kernel module contacts the actual filesystem binary "hello" after passing through glibc and FUSE library in userspace(libfuse). The result is returned by the "hello" through the same path and reaches the ls -l command.

The communication between FUSE kernel module and the FUSE library(libfuse) is via a special file descriptor which is obtained by opening /dev/fuse. This file can be opened multiple times, and the obtained file descriptor is passed to the mount syscall, to match up the descriptor with the mounted filesystem.

- [More about userspace     filesystems](http://www.linux-mag.com/id/7814/)
- [FUSE reference](http://fuse.sourceforge.net/)

### Translators

**Translating “translators”**:

- A translator converts requests from users into requests for storage.

  *One to one, one to many, one to zero (e.g. caching)

![translator](https://cloud.githubusercontent.com/assets/10970993/7412595/fd46c492-ef61-11e4-8f49-61dbd15b9695.png)

- A translator can modify requests on the way through :

  *convert one request type to another ( during the request transfer amongst the translators)* modify paths, flags, even data (e.g. encryption)

- Translators can intercept or block the requests. (e.g. access    control)

- Or spawn new requests (e.g. pre-fetch)

**How Do Translators Work?**

- Shared Objects

- Dynamically loaded according to 'volfile'

  *dlopen/dlsync* setup pointers to parents / children *call init (constructor)* call IO functions through fops.

- Conventions for validating/ passing options, etc.

- The configuration of translators (since GlusterFS 3.1) is managed    through the gluster command line interface (cli), so you don't need    to know in what order to graph the translators together.

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

![translator_h](https://cloud.githubusercontent.com/assets/628699/9002815/07d93ce4-3771-11e5-8bda-9018871aa6fb.png)

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

### Overview

Before we begin, let’s talk about what Gluster is, address a few myths and misconceptions, and define a few terms. This will help you to avoid some of the common issues that others encounter as they start their journey with Gluster.

#### What is Gluster

Gluster is a distributed scale-out filesystem that allows rapid provisioning of additional storage based on your storage consumption needs. It incorporates automatic failover as a primary feature. All of this is accomplished without a centralized metadata server.

#### What is Gluster without making me learn an extra glossary of terminology?

- Gluster is an easy way to provision your own storage backend NAS    using almost any hardware you choose.
- You can add as much as you want to start with, and if you need more    later, adding more takes just a few steps.
- You can configure failover automatically, so that if a server goes    down, you don’t lose access to the data. No manual steps are    required for failover. When you fix the server that failed and bring    it back online, you don’t have to do anything to get the data back    except wait. In the meantime, the most current copy of your data    keeps getting served from the node that was still running.
- You can build a clustered filesystem in a matter of minutes… it is    trivially easy for basic setups
- It takes advantage of what we refer to as “commodity hardware”,    which means, we run on just about any hardware you can think of,    from that stack of decomm’s and gigabit switches in the corner no    one can figure out what to do with (how many license servers do you    really need, after all?), to that dream array you were speccing out    online. Don’t worry, I won’t tell your boss.
- It takes advantage of commodity software too. No need to mess with    kernels or fine tune the OS to a tee. We run on top of most unix    filesystems, with XFS and ext4 being the most popular choices. We do    have some recommendations for more heavily utilized arrays, but    these are simple to implement and you probably have some of these    configured already anyway.
- Gluster data can be accessed from just about anywhere – You can use    traditional NFS, SMB/CIFS for Windows clients, or our own native    GlusterFS (a few additional packages are needed on the client    machines for this, but as you will see, they are quite small).
- There are even more advanced features than this, but for now we will    focus on the basics.
- It’s not just a toy. Gluster is enterprise-ready, and commercial    support is available if you need it. It is used in some of the most    taxing environments like media serving, natural resource    exploration, medical imaging, and even as a filesystem for Big Data.

#### Is Gluster going to work for me and what I need it to do?

Most likely, yes. People use Gluster for storage needs of a variety of application workloads. You are encouraged to ask around in our IRC or, Slack channels or Q&A forums to see if anyone has tried something similar. That being said, there are a few places where Gluster is going to need more consideration than others.

- Accessing Gluster from SMB/CIFS is often going to be slow by most  people’s standards. If you only moderate access by users, then it most  likely won’t be an issue for you. On the other hand, adding enough  Gluster servers into the mix, some people have seen better performance  with us than other solutions due to the scale out nature of the  technology
- Gluster does not support so called “structured data”, meaning  live, SQL databases. Of course, using Gluster to backup and  restore the database would be fine
- Gluster is traditionally better when using file sizes of at least 16KB  (with a sweet spot around 128KB or so).

#### What is the cost and complexity required to set up cluster?

Question: How many billions of dollars is it going to cost to setup a cluster? Don’t I need redundant networking, super fast SSD’s, technology from Alpha Centauri delivered by men in black, etc…?

I have never seen anyone spend even close to a billion, unless they got the rust proof coating on the servers. You don’t seem like the type that would get bamboozled like that, so have no fear. For the purpose of this tutorial, if your laptop can run two VM’s with 1GB of memory each, you can get started testing and the only thing you are going to pay for is coffee (assuming the coffee shop doesn’t make you pay them back for the electricity to power your laptop).

If you want to test on bare metal, since Gluster is built with commodity hardware in mind, and because there is no centralized meta-data server, a very simple cluster can be deployed with two basic servers (2 CPU’s, 4GB of RAM each, 1 Gigabit network). This is sufficient to have a nice file share or a place to put some nightly backups. Gluster is deployed successfully on all kinds of disks, from the lowliest 5200 RPM SATA to mightiest 1.21 gigawatt SSD’s. The more performance you need, the more consideration you will want to put into how much hardware to buy, but the great thing about Gluster is that you can start small, and add on as your needs grow.

#### OK, but if I add servers on later, don’t they have to be exactly the same?

In a perfect world, sure. Having the hardware be the same means less troubleshooting when the fires start popping up. But plenty of people deploy Gluster on mix and match hardware, and successfully.

Get started by checking some [Common Criteria](https://docs.gluster.org/en/latest/Install-Guide/Common-criteria/)

# Common Criteria

### Getting Started

This tutorial will cover different options for getting a Gluster cluster up and running. Here is a rundown of the steps we need to do.

To start, we will go over some common things you will need to know for setting up Gluster.

Next, choose the method you want to use to set up your first cluster:

- Within a virtual machine
- To bare metal servers
- To EC2 instances in Amazon

Finally, we will install Gluster, create a few volumes, and test using them.

#### General Setup Principles

No matter where you will be installing Gluster, it helps to understand a few key concepts on what the moving parts are.

First, it is important to understand that GlusterFS isn’t really a filesystem in and of itself. It concatenates existing filesystems into one (or more) big chunks so that data being written into or read out of Gluster gets distributed across multiple hosts simultaneously. This means that you can use space from any host that you have available. Typically, XFS is recommended but it can be used with other filesystems as well. Most commonly EXT4 is used when XFS isn’t, but you can (and many, many people do) use another filesystem that suits you. 

Now that we understand that, we can define a few of the common terms used in Gluster.

- A **trusted pool** refers collectively to the hosts in a given    Gluster Cluster.
- A **node** or “server” refers to any server that is part of a    trusted pool. In general, this assumes all nodes are in the same    trusted pool.
- A **brick** is used to refer to any device (really this means    filesystem) that is being used for Gluster storage.
- An **export** refers to the mount path of the brick(s) on a given    server, for example, /export/brick1
- The term **Global Namespace** is a fancy way of saying a Gluster    volume
- A **Gluster volume** is a collection of one or more bricks (of    course, typically this is two or more). This is analogous to    /etc/exports entries for NFS.
- **GNFS** and **kNFS**. GNFS is how we refer to our inline NFS    server. kNFS stands for kernel NFS, or, as most people would say,    just plain NFS. Most often, you will want kNFS services disabled on    the Gluster nodes. Gluster NFS doesn't take any additional    configuration and works just like you would expect with NFSv3. It is    possible to configure Gluster and NFS to live in harmony if you want    to.

Other notes:

- For this test, if you do not have DNS set up, you can get away with    using /etc/hosts entries for the two nodes. However, when you move    from this basic setup to using Gluster in production, correct DNS    entries (forward and reverse) and NTP are essential.
- When you install the Operating System, do not format the Gluster    storage disks! We will use specific settings with the mkfs command    later on when we set up Gluster. If you are testing with a single    disk (not recommended), make sure to carve out a free partition or    two to be used by Gluster later, so that you can format or reformat    at will during your testing.
- Firewalls are great, except when they aren’t. For storage servers,    being able to operate in a trusted environment without firewalls can    mean huge gains in performance, and is recommended. In case you absolutely    need to set up a firewall, have a look at    [Setting up clients](https://docs.gluster.org/en/latest/Administrator-Guide/Setting-Up-Clients/) for    information on the ports used.

Click here to [get started](https://docs.gluster.org/en/latest/Quick-Start-Guide/Quickstart/)

# Setup on Virtual Machine

*Note: You only need one of the three setup methods!*

### Setup, Method 1 – Setting up in virtual machines

As we just mentioned, to set up Gluster using virtual machines, you will need at least two virtual machines with at least 1GB of RAM each. You may be able to test with less but most users will find it too slow for their tastes. The particular virtualization product you use is a matter of choice. Common platforms include Xen, VMware ESX and Workstation, VirtualBox, and KVM. For purpose of this article, all steps assume KVM but the concepts are expected to be simple to translate to other platforms as well. The article assumes you know the particulars of how to create a virtual machine and have installed a 64 bit linux distribution already.

Create or clone two VM’s, with the following setup on each:

- 2 disks using the VirtIO driver, one for the base OS and one that we    will use as a Gluster “brick”. You can add more later to try testing    some more advanced configurations, but for now let’s keep it simple.

*Note: If you have ample space available, consider allocating all the disk space at once.*

- 2 NIC’s using VirtIO driver. The second NIC is not strictly    required, but can be used to demonstrate setting up a separate    network for storage and management traffic.

*Note: Attach each NIC to a separate network.*

Other notes: Make sure that if you clone the VM, that Gluster has not already been installed. Gluster generates a UUID to “fingerprint” each system, so cloning a previously deployed system will result in errors later on.

Once these are prepared, you are ready to move on to the [install](https://docs.gluster.org/en/latest/Install-Guide/Install/) section.

# Setup Bare Metal

*Note: You only need one of the three setup methods!*

### Setup, Method 2 – Setting up on physical servers

To set up Gluster on physical servers, we recommend two servers of very modest specifications (2 CPUs, 2GB of RAM, 1GBE). Since we are dealing with physical hardware here, keep in mind, what we are showing here is for testing purposes. In the end, remember that forces beyond your control (aka, your bosses’ boss...) can force you to take that the “just for a quick test” environment right into production, despite your kicking and screaming against it. To prevent this, it can be a good idea to deploy your test environment as much as possible the same way you would to a production environment (in case it becomes one, as mentioned above). That being said, here is a reminder of some of the best practices we mentioned before:

- Make sure DNS and NTP are setup, correct, and working
- If you have access to a backend storage network, use it! 10GBE or    InfiniBand are great if you have access to them, but even a 1GBE    backbone can help you get the most out of your deployment. Make sure    that the interfaces you are going to use are also in DNS since we    will be using the hostnames when we deploy Gluster
- When it comes to disks, the more the merrier. Although you could    technically fake things out with a single disk, there would be    performance issues as soon as you tried to do any real work on the    servers

With the explosion of commodity hardware, you don’t need to be a hardware expert these days to deploy a server. Although this is generally a good thing, it also means that paying attention to some important, performance-impacting BIOS settings is commonly ignored. Several points that might cause issues when if you're unaware of them:

- Most manufacturers enable power saving mode by default. This is a    great idea for servers that do not have high-performance    requirements. For the average storage server, the performance-impact    of the power savings is not a reasonable tradeoff
- Newer motherboards and processors have lots of nifty features!    Enhancements in virtualization, newer ways of doing predictive    algorithms and NUMA are just a few to mention. To be safe, many    manufactures ship hardware with settings meant to work with as    massive a variety of workloads and configurations as they have    customers. One issue you could face is when you set up that blazing-fast     10GBE card you were so thrilled about installing? In many    cases, it would end up being crippled by a default 1x speed put in    place on the PCI-E bus by the motherboard.

Thankfully, most manufacturers show all the BIOS settings, including the defaults, right in the manual. It only takes a few minutes to download, and you don’t even have to power off the server unless you need to make changes. More and more boards include the functionality to make changes in the BIOS on the fly without even powering the box off. One word of caution of course, is don’t go too crazy. Fretting over each tiny little detail and setting is usually not worth the time, and the more changes you make, the more you need to document and implement later. Try to find the happy balance between time spent managing the hardware (which ideally should be as close to zero after you setup initially) and the expected gains you get back from it.

Finally, remember that some hardware really is better than others. Without pointing fingers anywhere specifically, it is often true that onboard components are not as robust as add-ons. As a general rule, you can safely delegate the onboard hardware to things like management network for the NIC’s, and for installing the OS onto a SATA drive. At least twice a year you should check the manufacturer's website for bulletins about your hardware. Critical performance issues are often resolved with a simple driver or firmware update. As often as not, these updates affect the two most critical pieces of hardware on a machine you want to use for networked storage - the RAID controller and the NIC's.

Once you have set up the servers and installed the OS, you are ready to move on to the [install](https://docs.gluster.org/en/latest/Install-Guide/Install/) section.

# Setup AWS

*Note: You only need one of the three setup methods!*

### Setup, Method 3 – Deploying in AWS

Deploying in Amazon can be one of the fastest ways to get up and running with Gluster. Of course, most of what we cover here will work with other cloud platforms.

- Deploy at least two instances. For testing, you can use micro    instances (I even go as far as using spot instances in most cases).    Debates rage on what size instance to use in production, and there    is really no correct answer. As with most things, the real answer is    “whatever works for you”, where the trade-offs between cost and    performance are balanced in a continual dance of trying to make your    project successful while making sure there is enough money left over    in the budget for you to get that sweet new ping pong table in the    break room.
- For cloud platforms, your data is wide open right from the start. As    such, you shouldn’t allow open access to all ports in your security    groups if you plan to put a single piece of even the least valuable    information on the test instances. By least valuable, I mean “Cash    value of this coupon is 1/100th of 1 cent” kind of least valuable.    Don’t be the next one to end up as a breaking news flash on the    latest inconsiderate company to allow their data to fall into the    hands of the baddies. See Step 2 for the minimum ports you will need    open to use Gluster
- You can use the free “ephemeral” storage for the Gluster bricks    during testing, but make sure to use some form of protection against    data loss when you move to production. Typically this means EBS    backed volumes or using S3 to periodically back up your data bricks.

Other notes:

- In production, it is recommended to replicate your VM’s across    multiple zones. For purpose of this tutorial, it is overkill, but if    anyone is interested in this please let us know since we are always    looking to write articles on the most requested features and    questions.
- Using EBS volumes and Elastic IPs are also recommended in    production. For testing, you can safely ignore these as long as you    are aware that the data could be lost at any moment, so make sure    your test deployment is just that, testing only.
- Performance can fluctuate wildly in a cloud environment. If    performance issues are seen, there are several possible strategies,    but keep in mind that this is the perfect place to take advantage of    the scale-out capability of Gluster. While it is not true in all    cases that deploying more instances will necessarily result in a    “faster” cluster, in general, you will see that adding more nodes    means more performance for the cluster overall.
- If a node reboots, you will typically need to do some extra work to    get Gluster running again using the default EC2 configuration. If a    node is shut down, it can mean absolute loss of the node (depending    on how you set things up). This is well beyond the scope of this    document but is discussed in any number of AWS-related forums and    posts. Since I found out the hard way myself (oh, so you read the    manual every time?!), I thought it worth at least mentioning.

Once you have both instances up, you can proceed to the [install](https://docs.gluster.org/en/latest/Install-Guide/Install/) page.

# Install

### Installing Gluster

For RPM based distributions, if you will be using InfiniBand, add the glusterfs RDMA package to the installations. For RPM based systems, yum/dnf is used as the install method in order to satisfy external depencies such as compat-readline5

###### Community Packages

Packages are provided according to this [table](https://docs.gluster.org/en/latest/Install-Guide/Community-Packages/).

###### For Debian

Add the GPG key to apt:

```

wget -O - https://download.gluster.org/pub/gluster/glusterfs/LATEST/rsa.pub | apt-key add -
```

If the rsa.pub is not available at the above location, please look  here https://download.gluster.org/pub/gluster/glusterfs/7/rsa.pub and  add the GPG key to apt:

```

wget -O - https://download.gluster.org/pub/gluster/glusterfs/7/rsa.pub | apt-key add -
```

Add the source:

```

DEBID=$(grep 'VERSION_ID=' /etc/os-release | cut -d '=' -f 2 | tr -d '"')
DEBVER=$(grep 'VERSION=' /etc/os-release | grep -Eo '[a-z]+')
DEBARCH=$(dpkg --print-architecture)
echo deb https://download.gluster.org/pub/gluster/glusterfs/LATEST/Debian/${DEBID}/${DEBARCH}/apt ${DEBVER} main > /etc/apt/sources.list.d/gluster.list
```

Update package list:

```

apt update
```

Install:

```

apt install glusterfs-server
```

###### For Ubuntu

Install software-properties-common:

```

apt install software-properties-common
```

Then add the community GlusterFS PPA:

```

add-apt-repository ppa:gluster/glusterfs-7
apt update
```

Finally, install the packages:

```

apt install glusterfs-server
```

*Note: Packages exist for Ubuntu 12.04 LTS, 12.10, 13.10, and 14.04 LTS*

###### For Red Hat/CentOS

RPMs for CentOS and other RHEL clones are available from the CentOS Storage SIG mirrors.

For more installation details refer [Gluster Quick start guide](https://wiki.centos.org/SpecialInterestGroup/Storage/gluster-Quickstart) from CentOS Storage SIG.

###### For Fedora

Install the Gluster packages:

```

dnf install glusterfs-server
```

Once you are finished installing, you can move on to [configuration](https://docs.gluster.org/en/latest/Install-Guide/Configure/) section.

###### For Arch Linux

Install the Gluster package:

```

pacman -S glusterfs
```

# Configure

### Configure Firewall

For the Gluster to communicate within a cluster either the firewalls have to be turned off or enable communication for each server.

```

# iptables -I INPUT -p all -s `<ip-address>` -j ACCEPT
```

### Configure the trusted pool

Remember that the trusted pool is the term used to define a cluster of nodes in Gluster. Choose a server to be your “primary” server. This is just to keep things simple, you will generally want to run all commands from this tutorial. Keep in mind, running many Gluster specific commands (like `gluster volume create`) on one server in the cluster will execute the same command on all other servers.

Replace `nodename` with hostname of the other server in the cluster, or IP address if you don’t have DNS or `/etc/hosts` entries. Let say we want to connect to `node02`:

```

# gluster peer probe node02
```

Notice that running `gluster peer status` from the second node shows that the first node has already been added.

### Partition the disk

Assuming you have an empty disk at `/dev/sdb`: *(You can check the partitions on your system using* `fdisk -l`*)*

```

# fdisk /dev/sdb 
```

And then create a single XFS partition using fdisk

### Format the partition

```

# mkfs.xfs -i size=512 /dev/sdb1
```

### Add an entry to /etc/fstab

```

# echo "/dev/sdb1 /export/sdb1 xfs defaults 0 0"  >> /etc/fstab
```

### Mount the partition as a Gluster "brick"

```

# mkdir -p /export/sdb1 && mount -a && mkdir -p /export/sdb1/brick
```

#### Set up a Gluster volume

The most basic Gluster volume type is a “Distribute only” volume (also referred to as a “pure DHT” volume if you want to impress the folks at the water cooler). This type of volume simply distributes the data evenly across the available bricks in a volume. So, if I write 100 files, on average, fifty will end up on one server, and fifty will end up on another. This is faster than a “replicated” volume, but isn’t as popular since it doesn’t give you two of the most sought after features of Gluster — multiple copies of the data, and automatic failover if something goes wrong.

To set up a replicated volume:

```

# gluster volume create gv0 replica 3 node01.mydomain.net:/export/sdb1/brick \
    node02.mydomain.net:/export/sdb1/brick                                   \
    node03.mydomain.net:/export/sdb1/brick
```

Breaking this down into pieces:

- the first part says to create a gluster volume named gv0 (the name is arbitrary, `gv0` was chosen simply because it’s less typing than `gluster_volume_0`).
- make the volume a replica volume
- keep a copy of the data on at least 3 bricks at any given time. Since we only have three bricks total, this means each server will house a copy of the data.
- we specify which nodes to use, and which bricks on those nodes. The order here is important when you have more bricks.

It is possible (as of the most current release as of this writing, Gluster 3.3) to specify the bricks in such a way that you would make both copies of the data reside on a single node. This would make for an embarrassing explanation to your boss when your bulletproof, completely redundant, always on super cluster comes to a grinding halt when a single point of failure occurs.

Now, we can check to make sure things are working as expected:

```

# gluster volume info
```

And you should see results similar to the following:

```

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

```

# gluster volume start gv0
```

Find all documentation [here](https://docs.gluster.org/en/latest/)

# Managing the glusterd Service

After installing GlusterFS, you must start glusterd service. The glusterd service serves as the Gluster elastic volume manager, overseeing glusterfs processes, and co-ordinating dynamic volume operations, such as adding and removing volumes across multiple storage servers non-disruptively.

This section describes how to start the glusterd service in the following ways:

- [Starting and stopping glusterd manually on distributions using systemd](https://docs.gluster.org/en/latest/Administrator-Guide/Start-Stop-Daemon/#manual)
- [Starting glusterd automatically on distributions using systemd](https://docs.gluster.org/en/latest/Administrator-Guide/Start-Stop-Daemon/#auto)
- [Starting and stopping glusterd manually](https://docs.gluster.org/en/latest/Administrator-Guide/Start-Stop-Daemon/#manual-legacy)
- [Starting glusterd Automatically](https://docs.gluster.org/en/latest/Administrator-Guide/Start-Stop-Daemon/#auto-legacy)

> **Note**: You must start glusterd on all GlusterFS servers.

## Distributions with systemd



### Starting and stopping glusterd manually

- To start `glusterd` manually:

```

systemctl start glusterd
```

- To stop `glusterd` manually:

```

systemctl stop glusterd
```



### Starting glusterd automatically

- To enable the glusterd service and start it if stopped:

```

systemctl enable --now glusterd
```

- To disable the glusterd service and stop it if started:

```

systemctl disable --now glusterd
```

## Distributions without systemd



### Starting and stopping glusterd manually

This section describes how to start and stop glusterd manually

- To start glusterd manually, enter the following command:

```

# /etc/init.d/glusterd start
```

- To stop glusterd manually, enter the following command:

```

# /etc/init.d/glusterd stop
```



### Starting glusterd Automatically

This section describes how to configure the system to automatically start the glusterd service every time the system boots.

#### Red Hat and Fedora distributions

To configure Red Hat-based systems to automatically start the glusterd service every time the system boots, enter the following from the command line:

```

# chkconfig glusterd on
```

#### Debian and derivatives like Ubuntu

To configure Debian-based systems to automatically start the glusterd service every time the system boots, enter the following from the command line:

```

# update-rc.d glusterd defaults
```

#### Systems Other than Red Hat and Debian

To configure systems other than Red Hat or Debian to automatically start the glusterd service every time the system boots, enter the following entry to the*/etc/rc.local* file:

```

# echo "glusterd" >> /etc/rc.local
```

# Managing Trusted Storage Pools

### Overview

A trusted storage pool(TSP) is a trusted network of storage servers. Before you can configure a GlusterFS volume, you must create a trusted storage pool of the storage servers that will provide bricks to the volume by peer probing the servers. The servers in a TSP are peers of each other.

After installing Gluster on your servers and before creating a trusted storage pool, each server belongs to a storage pool consisting of only that server.

- [Adding Servers](https://docs.gluster.org/en/latest/Administrator-Guide/Storage-Pools/#adding-servers)
- [Listing Servers](https://docs.gluster.org/en/latest/Administrator-Guide/Storage-Pools/#listing-servers)
- [Viewing Peer Status](https://docs.gluster.org/en/latest/Administrator-Guide/Storage-Pools/#peer-status)
- [Removing Servers](https://docs.gluster.org/en/latest/Administrator-Guide/Storage-Pools/#removing-servers)

**Before you start**:

- The servers used to create the storage pool must be resolvable by hostname.
- The glusterd daemon must be running on all storage servers that you want to add to the storage pool. See [Managing the glusterd Service](https://docs.gluster.org/en/latest/Administrator-Guide/Start-Stop-Daemon/) for details.
- The firewall on the servers must be configured to allow access to port 24007.

The following commands were run on a TSP consisting of 3 servers - server1, server2, and server3.



### Adding Servers

To add a server to a TSP, peer probe it from a server already in the pool.

```

    # gluster peer probe <server>
```

For example, to add a new server4 to the cluster described above, probe it from one of the other servers:

```

    server1#  gluster peer probe server4
    Probe successful
```

Verify the peer status from the first server (server1):

```

    server1# gluster peer status
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



### Listing Servers

To list all nodes in the TSP:

```

    server1# gluster pool list
    UUID                                    Hostname        State
    d18d36c5-533a-4541-ac92-c471241d5418    localhost       Connected
    5e987bda-16dd-43c2-835b-08b7d55e94e5    server2         Connected
    1e0ca3aa-9ef7-4f66-8f15-cbc348f29ff7    server3         Connected
    3e0cabaa-9df7-4f66-8e5d-cbc348f29ff7    server4         Connected
```



### Viewing Peer Status

To view the status of the peers in the TSP:

```

    server1# gluster peer status
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



### Removing Servers

To remove a server from the TSP, run the following command from another server in the pool:

```

    # gluster peer detach <server>
```

For example, to remove server4 from the trusted storage pool:

```

    server1# gluster peer detach server4
    Detach successful
```

Verify the peer status:

```

    server1# gluster peer status
    Number of Peers: 2

    Hostname: server2
    Uuid: 5e987bda-16dd-43c2-835b-08b7d55e94e5
    State: Peer in Cluster (Connected)

    Hostname: server3
    Uuid: 1e0ca3aa-9ef7-4f66-8f15-cbc348f29ff7
    State: Peer in Cluster (Connected)
```

# Setting Up Storage

A volume is a logical collection of bricks where each brick is an export directory on a server in the trusted storage pool. Before creating a volume, you need to set up the bricks that will form the volume.

- [Brick Naming Conventions](https://docs.gluster.org/en/latest/Administrator-Guide/Brick-Naming-Conventions/)
- [Formatting and Mounting Bricks](https://docs.gluster.org/en/latest/Administrator-Guide/formatting-and-mounting-bricks/)
- [Posix ACLS](https://docs.gluster.org/en/latest/Administrator-Guide/Access-Control-Lists/)



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





