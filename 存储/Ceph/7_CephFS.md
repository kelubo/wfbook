# CephFS

[TOC]

## 概述

Ceph 文件系统（CephFS）是一个兼容 POSIX 的文件系统，构建在 Ceph 的分布式对象存储 RADOS 之上。Ceph FS 致力于为各种应用程序（including traditional use-cases like shared home directories, HPC scratch space, and distributed workflow shared storage包括共享主目录、HPC暂存空间和分布式工作流共享存储等传统用例）提供最先进、多用途、高可用性和高性能的文件存储。

CephFS achieves these goals through the use of some novel architectural choices.通过使用一些新颖的架构选择来实现这些目标。值得注意的是，文件元数据存储在与文件数据分离的 RADOS 池中，并通过可调整大小的元数据服务器集群（MDS）提供服务。MDS 可以扩展以支持更高吞吐量的 metadata 工作负载。文件系统的 Client 可以直接访问 RADOS 以读取和写入文件数据块。因此，工作负载可能会随着底层 RADOS 对象存储的大小而线性扩展。也就是说，没有网关或代理为 Client 中介数据 I/O （mediating data I/O）。

Access to data is coordinated through the cluster of MDS which serve as authorities for the state of the distributed metadata cache cooperatively maintained by clients and MDS. 对数据的访问通过MDS集群进行协调，MDS集群作为客户端和MDS协同维护的分布式元数据缓存状态的权威。Mutations to metadata are aggregated by each MDS into a series of efficient writes to a journal on RADOS; 元数据的突变由每个MDS聚合成一系列有效的写入RADOS上的日志；MDS不在本地存储元数据状态。This model allows for coherent and rapid collaboration between clients within the context of a POSIX file system.该模型允许在POSIX文件系统的上下文中，客户机之间进行一致和快速的协作。

![](../../Image/c/cephfs-architecture.svg)

# MDS

[TOC]

## 概述

使用 CephFS 文件系统需要一个或多个 MDS 守护进程。默认情况下，CephFS 仅使用一个活跃的 MDS 守护进程。

## 部署 MDS 服务

**注意：**

确保您至少有两个池，一个用于 CephFS 数据，另一个用于 CephFS 元数据。

### 使用命令行界面

使用放置规格部署 MDS 守护进程的方法有两种： 				

**方法 1**

使用 `ceph fs volume ` 创建 MDS 守护进程。这将创建 CephFS 卷和与 CephFS 关联的池，并在主机上启动 MDS 服务。如果使用较新的 `ceph fs volume` 接口创建新的文件系统，则会自动创建这些卷。

```bash
ceph fs volume create FILESYSTEM_NAME --placement="NUMBER_OF_DAEMONS HOST_NAME_1 HOST_NAME_2 HOST_NAME_3"

ceph fs volume create test --placement="2 host01 host02"
```

**注意:**默认情况下，此命令创建复制池。

**方法 2**

创建池 CephFS，然后使用放置规范部署 MDS 服务： 				

1. 为 CephFS 创建池：

   ```bash
   ceph osd pool create DATA_POOL
   ceph osd pool create METADATA_POOL
        
   ceph osd pool create cephfs_data
   ceph osd pool create cephfs_metadata
   ```

  2. 为数据池和元数据池创建文件系统：

     ```bash
     ceph fs new FILESYSTEM_NAME DATA_POOL_ METADATA_POOL
     
     ceph fs new test cephfs_data cephfs_metadata
     ```

  3. 使用 `ceph 或ch apply` 命令部署 MDS 服务：

     ```bash
     ceph orch apply mds FILESYSTEM_NAME --placement="NUMBER_OF_DAEMONS HOST_NAME_1 HOST_NAME_2 HOST_NAME_3"
     
     ceph orch apply mds test --placement="2 host01 host02"
     ```


**验证**

- 列出服务：

  ```bash
  ceph orch ls
  ```

- 检查 CephFS 状态：

  ```bash
  ceph fs ls
  ceph fs status
  ```

- 列出主机、守护进程和进程：

  ```bash
  ceph orch ps --daemon_type=DAEMON_NAME
    
  ceph orch ps --daemon_type=mds
  ```

### 使用服务规格

1. 编辑 `sds.yml` 文件，使其包含以下详情：

   ```yaml
   service_type: mds
   service_id: FILESYSTEM_NAME
   placement:
     hosts:
     - HOST_NAME_1
     - HOST_NAME_2
     - HOST_NAME_3
     
   service_type: mds
   service_id: fs_name
   placement:
     hosts:
     - host01
     - host02
     
   service_type: mds
   service_id: fs_name
   placement:
     count: 3
   ```

2. 使用服务规格部署 MDS 服务：

   ```bash
   ceph orch apply -i FILE_NAME.yml
   
   ceph orch apply -i mds.yml
   ```

3. 部署和运行 MDS 服务后，创建 CephFS：

   ```bash
   ceph fs new CEPHFS_NAME METADATA_POOL DATA_POOL
   
   ceph fs new test metadata_pool data_pool
   ```

## 移除 MDS 服务

可以使用 `ceph orch rm` 命令删除服务。或者，可以删除文件系统和关联的池。

从集群中移除 MDS 守护进程的方法有两种： 				

**方法 1**

移除 CephFS 卷、关联的池和服务：

1. 将配置参数 `mon_allow_pool_delete` 设置为 `true` ：

   ```bash
   ceph config set mon mon_allow_pool_delete true
   ```

2. 删除文件系统：

   ```none
   ceph fs volume rm FILESYSTEM_NAME --yes-i-really-mean-it
   
   ceph fs volume rm cephfs-new --yes-i-really-mean-it
   ```

   此命令将删除文件系统、数据和元数据池。它还尝试使用已启用的 `ceph-mgr` Orchestrator 模块来移除 MDS。 						

**方法 2**

使用 `ceph 或ch rm` 命令从整个集群中删除 MDS 服务： 				

1. 列出服务：					

   ```none
   ceph orch ls
   ```

2. 删除服务:	

   ```none
   ceph orch rm SERVICE_NAME
   
   ceph orch rm mds.test
   ```

Note

It is highly recommended to use [Cephadm](https://docs.ceph.com/en/latest/cephadm/) or another Ceph orchestrator for setting up the ceph cluster. Use this approach only if you are setting up the ceph cluster manually. If one still intends to use the manual way for deploying MDS daemons, [MDS Service](https://docs.ceph.com/en/latest/cephadm/services/mds/) can also be used.

# Deploying Metadata Servers[](https://docs.ceph.com/en/latest/cephfs/add-remove-mds/#deploying-metadata-servers)

Each CephFS file system requires at least one MDS. The cluster operator will generally use their automated deployment tool to launch required MDS servers as needed.  Rook and ansible (via the ceph-ansible playbooks) are recommended tools for doing this. For clarity, we also show the systemd commands here which may be run by the deployment technology if executed on bare-metal.

See [MDS Config Reference](https://docs.ceph.com/en/latest/cephfs/mds-config-ref) for details on configuring metadata servers.

## Provisioning Hardware for an MDS[](https://docs.ceph.com/en/latest/cephfs/add-remove-mds/#provisioning-hardware-for-an-mds)

The present version of the MDS is single-threaded and CPU-bound for most activities, including responding to client requests. An MDS under the most aggressive client loads uses about 2 to 3 CPU cores. This is due to the other miscellaneous upkeep threads working in tandem.

Even so, it is recommended that an MDS server be well provisioned with an advanced CPU with sufficient cores. Development is on-going to make better use of available CPU cores in the MDS; it is expected in future versions of Ceph that the MDS server will improve performance by taking advantage of more cores.

The other dimension to MDS performance is the available RAM for caching. The MDS necessarily manages a distributed and cooperative metadata cache among all clients and other active MDSs. Therefore it is essential to provide the MDS with sufficient RAM to enable faster metadata access and mutation. The default MDS cache size (see also [MDS Cache Configuration](https://docs.ceph.com/en/latest/cephfs/cache-configuration/)) is 4GB. It is recommended to provision at least 8GB of RAM for the MDS to support this cache size.

Generally, an MDS serving a large cluster of clients (1000 or more) will use at least 64GB of cache. An MDS with a larger cache is not well explored in the largest known community clusters; there may be diminishing returns where management of such a large cache negatively impacts performance in surprising ways. It would be best to do analysis with expected workloads to determine if provisioning more RAM is worthwhile.

In a bare-metal cluster, the best practice is to over-provision hardware for the MDS server. Even if a single MDS daemon is unable to fully utilize the hardware, it may be desirable later on to start more active MDS daemons on the same node to fully utilize the available cores and memory. Additionally, it may become clear with workloads on the cluster that performance improves with multiple active MDS on the same node rather than over-provisioning a single MDS.

Finally, be aware that CephFS is a highly-available file system by supporting standby MDS (see also [Terminology](https://docs.ceph.com/en/latest/cephfs/standby/#mds-standby)) for rapid failover. To get a real benefit from deploying standbys, it is usually necessary to distribute MDS daemons across at least two nodes in the cluster. Otherwise, a hardware failure on a single node may result in the file system becoming unavailable.

Co-locating the MDS with other Ceph daemons (hyperconverged) is an effective and recommended way to accomplish this so long as all daemons are configured to use available hardware within certain limits.  For the MDS, this generally means limiting its cache size.

## Adding an MDS[](https://docs.ceph.com/en/latest/cephfs/add-remove-mds/#adding-an-mds)

1. Create an mds directory `/var/lib/ceph/mds/ceph-${id}`. The daemon only uses this directory to store its keyring.

2. Create the authentication key, if you use CephX:

   ```
   $ sudo ceph auth get-or-create mds.${id} mon 'profile mds' mgr 'profile mds' mds 'allow *' osd 'allow *' > /var/lib/ceph/mds/ceph-${id}/keyring
   ```

3. Start the service:

   ```
   $ sudo systemctl start ceph-mds@${id}
   ```

4. The status of the cluster should show:

   ```
   mds: ${id}:1 {0=${id}=up:active} 2 up:standby
   ```

5. Optionally, configure the file system the MDS should join ([Configuring MDS file system affinity](https://docs.ceph.com/en/latest/cephfs/standby/#mds-join-fs)):

   ```
   $ ceph config set mds.${id} mds_join_fs ${fs}
   ```

## Removing an MDS[](https://docs.ceph.com/en/latest/cephfs/add-remove-mds/#removing-an-mds)

If you have a metadata server in your cluster that you’d like to remove, you may use the following method.

1. (Optionally:) Create a new replacement Metadata Server. If there are no replacement MDS to take over once the MDS is removed, the file system will become unavailable to clients.  If that is not desirable, consider adding a metadata server before tearing down the metadata server you would like to take offline.

2. Stop the MDS to be removed.

   ```
   $ sudo systemctl stop ceph-mds@${id}
   ```

   The MDS will automatically notify the Ceph monitors that it is going down. This enables the monitors to perform instantaneous failover to an available standby, if one exists. It is unnecessary to use administrative commands to effect this failover, e.g. through the use of `ceph mds fail mds.${id}`.

3. Remove the `/var/lib/ceph/mds/ceph-${id}` directory on the MDS.

   ```
   $ sudo rm -rf /var/lib/ceph/mds/ceph-${id}
   ```

​        

## 部署 CephFS

使用 CephFS 文件系统需要一个或多个 MDS 守护进程。

如果使用较新的 `ceph fs volume` 接口创建新的文件系统，Ceph Orchestrator 会自动创建这些卷和 MDS。

例如：

```bash
ceph fs volume create <fs name>
ceph fs volume create <fs_name> --placement="<placement spec>"
```

对于手动部署MDS守护程序，请使用以下规范：

```yaml
service_type: mds
service_id: fs_name
placement:
  count: 3
```

然后可使用以下方法应用本规范：

```bash
ceph orch apply -i mds.yaml
```

### 创建 pool

一个 CephFS 至少需要两个 RADOS 池，一个用于数据，一个用于元数据。配置这些池时，可能会考虑：

- Configuring 4 would not be extreme, especially since the metadata pool’s capacity requirements are quite modest.建议为元数据池配置至少 3 个副本，因为此池中的数据丢失会导致整个文件系统无法访问。配置 4 个副本并不极端，尤其是因为元数据池的容量需求非常有限。
- the fastest feasible low-latency storage devices, as this will directly affect the latency of client file system operations.建议元数据池使用最快、可行的低延迟存储设备（ NVMe、Optane 或至少 SAS / SATA SSD ），因为这将直接影响客户端文件系统操作的延迟。
- The data pool used to create the file system is the “default” data pool and the location for storing all inode backtrace information, which is used for hard link management and disaster recovery. For this reason, all CephFS inodes have at least one object in the default data pool. If erasure-coded pools are planned for file system data, it is best to configure the default as a replicated pool to improve small-object write and read performance when updating backtraces. Separately, another erasure-coded data pool can be added (see also [Erasure code](https://docs.ceph.com/en/latest/rados/operations/erasure-code/#ecpool)) that can be used on an entire hierarchy of directories and files (see also [File layouts](https://docs.ceph.com/en/latest/cephfs/file-layouts/#file-layouts)).用于创建文件系统的数据池是“默认”数据池，是存储所有inode回溯信息的位置，用于硬链接管理和灾难恢复。因此，所有Ceph  FS索引节点在默认数据池中至少有一个对象。如果计划为文件系统数据创建擦除编码池，则最好将默认池配置为复制池，以便在更新回溯时提高小对象的读写性能。另外，还可以添加另一个擦除编码数据池（另请参见擦除代码），该数据池可用于整个目录和文件层次结构（另请参见文件布局）。

使用默认设置创建两个池以用于文件系统：

```bash
ceph osd pool create cephfs_data
ceph osd pool create cephfs_metadata
```

元数据池通常最多可容纳数 GB 的数据。因此，通常建议使用较小的 PG 计数。64 或 128 通常用于大型集群。

> Note:
>
> 文件系统、元数据池和数据池的名称只能包含集合 [a-zA-Z0-9_-.] 中的字符。

### 创建文件系统

使用 `fs new` 命令新建文件系统：

```bash
ceph fs new <fs_name> <metadata> <data>
```

例如：

```bash
ceph fs new cephfs cephfs_metadata cephfs_data

ceph fs ls
name: cephfs, metadata pool: cephfs_metadata, data pools: [cephfs_data ]
```

Once a file system has been created, your MDS(s) will be able to enter an *active* state.  For example, in a single MDS system:

```bash
ceph mds stat
cephfs-1/1/1 up {0=a=up:active}
```

Once the file system is created and the MDS is active, you are ready to mount the file system.  If you have created more than one file system, you will choose which to use when mounting.

> - [Mount CephFS](https://docs.ceph.com/en/latest/cephfs/mount-using-kernel-driver)
> - [Mount CephFS as FUSE](https://docs.ceph.com/en/latest/cephfs/mount-using-fuse)
> - [Mount CephFS on Windows](https://docs.ceph.com/en/latest/cephfs/ceph-dokan)

If you have created more than one file system, and a client does not specify a file system when mounting, you can control which file system they will see by using the ceph fs set-default command.

### Adding a Data Pool to the File System

See [Adding a data pool to the File System](https://docs.ceph.com/en/latest/cephfs/file-layouts/#adding-data-pool-to-file-system).

### Using Erasure Coded pools with CephFS

You may use Erasure Coded pools as CephFS data pools as long as they have overwrites enabled, which is done as follows:

```
ceph osd pool set my_ec_pool allow_ec_overwrites true
```

Note that EC overwrites are only supported when using OSDS with the BlueStore backend.

You may not use Erasure Coded pools as CephFS metadata pools, because CephFS metadata is stored using RADOS *OMAP* data structures, which EC pools cannot store.

## Multiple Ceph File Systems

Beginning with the Pacific release, multiple file system support is stable and ready to use. This functionality allows configuring separate file systems with full data separation on separate pools.

Existing clusters must set a flag to enable multiple file systems:

```
ceph fs flag set enable_multiple true
```

New Ceph clusters automatically set this.

### Creating a new Ceph File System

The new `volumes` plugin interface (see: [FS volumes and subvolumes](https://docs.ceph.com/en/latest/cephfs/fs-volumes/)) automates most of the work of configuring a new file system. The “volume” concept is simply a new file system. This can be done via:

```
ceph fs volume create <fs_name>
```

Ceph will create the new pools and automate the deployment of new MDS to support the new file system. The deployment technology used, e.g. cephadm, will also configure the MDS affinity (see: [Configuring MDS file system affinity](https://docs.ceph.com/en/latest/cephfs/standby/#mds-join-fs)) of new MDS daemons to operate the new file system.

### Securing access

The `fs authorize` command allows configuring the client’s access to a particular file system. See also in [File system Information Restriction](https://docs.ceph.com/en/latest/cephfs/client-auth/#fs-authorize-multifs). The client will only have visibility of authorized file systems and the Monitors/MDS will reject access to clients without authorization.

### Other Notes

Multiple file systems do not share pools. This is particularly important for snapshots but also because no measures are in place to prevent duplicate inodes. The Ceph commands prevent this dangerous configuration.

Each file system has its own set of MDS ranks. Consequently, each new file system requires more MDS daemons to operate and increases operational costs. This can be useful for increasing metadata throughput by application or user base but also adds cost to the creation of a file system. Generally, a single file system with subtree pinning is a better choice for isolating load between applications.

# Terminology[](https://docs.ceph.com/en/latest/cephfs/standby/#terminology)

A Ceph cluster may have zero or more CephFS *file systems*.  Each CephFS has a human readable name (set at creation time with `fs new`) and an integer ID.  The ID is called the file system cluster ID, or *FSCID*.

Each CephFS file system has a number of *ranks*, numbered beginning with zero. By default there is one rank per file system.  A rank may be thought of as a metadata shard.  Management of ranks is described in [Configuring multiple active MDS daemons](https://docs.ceph.com/en/latest/cephfs/multimds/) .

Each CephFS `ceph-mds` daemon starts without a rank.  It may be assigned one by the cluster’s monitors. A daemon may only hold one rank at a time, and only give up a rank when the `ceph-mds` process stops.

If a rank is not associated with any daemon, that rank is considered `failed`. Once a rank is assigned to a daemon, the rank is considered `up`.

Each `ceph-mds` daemon has a *name* that is assigned statically by the administrator when the daemon is first configured.  Each daemon’s *name* is typically that of the hostname where the process runs.

A `ceph-mds` daemon may be assigned to a specific file system by setting its `mds_join_fs` configuration option to the file system’s `name`.

When a `ceph-mds` daemon starts, it is also assigned an integer `GID`, which is unique to this current daemon’s process.  In other words, when a `ceph-mds` daemon is restarted, it runs as a new process and is assigned a *new* `GID` that is different from that of the previous process.

# Referring to MDS daemons[](https://docs.ceph.com/en/latest/cephfs/standby/#referring-to-mds-daemons)

Most administrative commands that refer to a `ceph-mds` daemon (MDS) accept a flexible argument format that may specify a `rank`, a `GID` or a `name`.

Where a `rank` is used, it  may optionally be qualified by a leading file system `name` or `GID`.  If a daemon is a standby (i.e. it is not currently assigned a `rank`), then it may only be referred to by `GID` or `name`.

For example, say we have an MDS daemon with `name` ‘myhost’ and `GID` 5446, and which is assigned `rank` 0 for the file system ‘myfs’ with `FSCID` 3.  Any of the following are suitable forms of the `fail` command:

```
ceph mds fail 5446     # GID
ceph mds fail myhost   # Daemon name
ceph mds fail 0        # Unqualified rank
ceph mds fail 3:0      # FSCID and rank
ceph mds fail myfs:0   # File System name and rank
```

# Managing failover[](https://docs.ceph.com/en/latest/cephfs/standby/#managing-failover)

If an MDS daemon stops communicating with the cluster’s monitors, the monitors will wait `mds_beacon_grace` seconds (default 15) before marking the daemon as *laggy*.  If a standby MDS is available, the monitor will immediately replace the laggy daemon.

Each file system may specify a minimum number of standby daemons in order to be considered healthy. This number includes daemons in the `standby-replay` state waiting for a `rank` to fail. Note that a `standby-replay` daemon will not be assigned to take over a failure for another `rank` or a failure in a different CephFS file system). The pool of standby daemons not in `replay` counts towards any file system count. Each file system may set the desired number of standby daemons by:

```
ceph fs set <fs name> standby_count_wanted <count>
```

Setting `count` to 0 will disable the health check.



# Configuring standby-replay[](https://docs.ceph.com/en/latest/cephfs/standby/#configuring-standby-replay)

Each CephFS file system may be configured to add `standby-replay` daemons. These standby daemons follow the active MDS’s metadata journal in order to reduce failover time in the event that the active MDS becomes unavailable. Each active MDS may have only one `standby-replay` daemon following it.

Configuration of `standby-replay` on a file system is done using the below:

```
ceph fs set <fs name> allow_standby_replay <bool>
```

Once set, the monitors will assign available standby daemons to follow the active MDSs in that file system.

Once an MDS has entered the `standby-replay` state, it will only be used as a standby for the `rank` that it is following. If another `rank` fails, this `standby-replay` daemon will not be used as a replacement, even if no other standbys are available. For this reason, it is advised that if `standby-replay` is used then *every* active MDS should have a `standby-replay` daemon.



# Configuring MDS file system affinity[](https://docs.ceph.com/en/latest/cephfs/standby/#configuring-mds-file-system-affinity)

You might elect to dedicate an MDS to a particular file system. Or, perhaps you have MDSs that run on better hardware that should be preferred over a last-resort standby on modest or over-provisioned systems. To configure this preference, CephFS provides a configuration option for MDS called `mds_join_fs` which enforces this affinity.

When failing over MDS daemons, a cluster’s monitors will prefer standby daemons with `mds_join_fs` equal to the file system `name` with the failed `rank`.  If no standby exists with `mds_join_fs` equal to the file system `name`, it will choose an unqualified standby (no setting for `mds_join_fs`) for the replacement, or any other available standby, as a last resort. Note, this does not change the behavior that `standby-replay` daemons are always selected before other standbys.

Even further, the monitors will regularly examine the CephFS file systems even when stable to check if a standby with stronger affinity is available to replace an MDS with lower affinity. This process is also done for `standby-replay` daemons: if a regular standby has stronger affinity than the `standby-replay` MDS, it will replace the standby-replay MDS.

For example, given this stable and healthy file system:

```
$ ceph fs dump
dumped fsmap epoch 399
...
Filesystem 'cephfs' (27)
...
e399
max_mds 1
in      0
up      {0=20384}
failed
damaged
stopped
...
[mds.a{0:20384} state up:active seq 239 addr [v2:127.0.0.1:6854/966242805,v1:127.0.0.1:6855/966242805]]

Standby daemons:

[mds.b{-1:10420} state up:standby seq 2 addr [v2:127.0.0.1:6856/2745199145,v1:127.0.0.1:6857/2745199145]]
```

You may set `mds_join_fs` on the standby to enforce your preference:

```
$ ceph config set mds.b mds_join_fs cephfs
```

after automatic failover:

```
$ ceph fs dump
dumped fsmap epoch 405
e405
...
Filesystem 'cephfs' (27)
...
max_mds 1
in      0
up      {0=10420}
failed
damaged
stopped
...
[mds.b{0:10420} state up:active seq 274 join_fscid=27 addr [v2:127.0.0.1:6856/2745199145,v1:127.0.0.1:6857/2745199145]]

Standby daemons:

[mds.a{-1:10720} state up:standby seq 2 addr [v2:127.0.0.1:6854/1340357658,v1:127.0.0.1:6855/1340357658]]
```

Note in the above example that `mds.b` now has `join_fscid=27`. In this output, the file system name from `mds_join_fs` is changed to the file system identifier (27). If the file system is recreated with the same name, the standby will follow the new file system as expected.

Finally, if the file system is degraded or undersized, no failover will occur to enforce `mds_join_fs`.

# MDS Cache Configuration[](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#mds-cache-configuration)

The Metadata Server coordinates a distributed cache among all MDS and CephFS clients. The cache serves to improve metadata access latency and allow clients to safely (coherently) mutate metadata state (e.g. via chmod). The MDS issues **capabilities** and **directory entry leases** to indicate what state clients may cache and what manipulations clients may perform (e.g. writing to a file).

The MDS and clients both try to enforce a cache size. The mechanism for specifying the MDS cache size is described below. Note that the MDS cache size is not a hard limit. The MDS always allows clients to lookup new metadata which is loaded into the cache. This is an essential policy as it avoids deadlock in client requests (some requests may rely on held capabilities before capabilities are released).

When the MDS cache is too large, the MDS will **recall** client state so cache items become unpinned and eligible to be dropped. The MDS can only drop cache state when no clients refer to the metadata to be dropped. Also described below is how to configure the MDS recall settings for your workload’s needs. This is necessary if the internal throttles on the MDS recall can not keep up with the client workload.

## MDS Cache Size[](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#mds-cache-size)

You can limit the size of the Metadata Server (MDS) cache by a byte count. This is done through the mds_cache_memory_limit configuration:

- mds_cache_memory_limit[](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#confval-mds_cache_memory_limit)

  This sets a target maximum memory usage of the MDS cache and is the primary tunable to limit the MDS memory usage. The MDS will try to stay under a reservation of this limit (by default 95%; 1 - mds_cache_reservation) by trimming unused metadata in its cache and recalling cached items in the client caches. It is possible for the MDS to exceed this limit due to slow recall from clients. The mds_health_cache_threshold (150%) sets a cache full threshold for when the MDS signals a cluster health warning. type `size` default `4Gi`

In addition, you can specify a cache reservation by using the mds_cache_reservation parameter for MDS operations:

- mds_cache_reservation[](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#confval-mds_cache_reservation)

  The cache reservation (memory or inodes) for the MDS cache to maintain. Once the MDS begins dipping into its reservation, it will recall client state until its cache size shrinks to restore the reservation. type `float` default `0.05`

The cache reservation is limited as a percentage of the memory and is set to 5% by default. The intent of this parameter is to have the MDS maintain an extra reserve of memory for its cache for new metadata operations to use. As a consequence, the MDS should in general operate below its memory limit because it will recall old state from clients in order to drop unused metadata in its cache.

If the MDS cannot keep its cache under the target size, the MDS will send a health alert to the Monitors indicating the cache is too large. This is controlled by the mds_health_cache_threshold configuration which is by default 150% of the maximum cache size:

- mds_health_cache_threshold[](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#confval-mds_health_cache_threshold)

  threshold for cache size to generate health warning type `float` default `1.5`

Because the cache limit is not a hard limit, potential bugs in the CephFS client, MDS, or misbehaving applications might cause the MDS to exceed its cache size. The health warnings are intended to help the operator detect this situation and make necessary adjustments or investigate buggy clients.

## MDS Cache Trimming[](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#mds-cache-trimming)

There are two configurations for throttling the rate of cache trimming in the MDS:

- mds_cache_trim_threshold[](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#confval-mds_cache_trim_threshold)

  threshold for number of dentries that can be trimmed type `size` default `256Ki`

- mds_cache_trim_decay_rate[](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#confval-mds_cache_trim_decay_rate)

  decay rate for trimming MDS cache throttle type `float` default `1.0`

The intent of the throttle is to prevent the MDS from spending too much time trimming its cache. This may limit its ability to handle client requests or perform other upkeep.

The trim configurations control an internal **decay counter**. Anytime metadata is trimmed from the cache, the counter is incremented.  The threshold sets the maximum size of the counter while the decay rate indicates the exponential half life for the counter. If the MDS is continually removing items from its cache, it will reach a steady state of `-ln(0.5)/rate*threshold` items removed per second.

Note

Increasing the value of the configuration setting `mds_cache_trim_decay_rate` leads to the MDS spending less time trimming the cache. To increase the cache trimming rate, set a lower value.

The defaults are conservative and may need to be changed for production MDS with large cache sizes.

## MDS Recall[](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#mds-recall)

MDS limits its recall of client state (capabilities/leases) to prevent creating too much work for itself handling release messages from clients. This is controlled via the following configurations:

The maximum number of capabilities to recall from a single client in a given recall event:

- mds_recall_max_caps[](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#confval-mds_recall_max_caps)

  maximum number of caps to recall from client session in single recall type `size` default `30000B`

The threshold and decay rate for the decay counter on a session:

- mds_recall_max_decay_threshold[](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#confval-mds_recall_max_decay_threshold)

  decay threshold for throttle on recalled caps on a session type `size` default `128Ki`

- mds_recall_max_decay_rate[](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#confval-mds_recall_max_decay_rate)

  decay rate for throttle on recalled caps on a session type `float` default `1.5`

The session decay counter controls the rate of recall for an individual session. The behavior of the counter works the same as for cache trimming above. Each capability that is recalled increments the counter.

There is also a global decay counter that throttles for all session recall:

- mds_recall_global_max_decay_threshold[](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#confval-mds_recall_global_max_decay_threshold)

  decay threshold for throttle on recalled caps globally type `size` default `128Ki`

its decay rate is the same as `mds_recall_max_decay_rate`. Any recalled capability for any session also increments this counter.

If clients are slow to release state, the warning “failing to respond to cache pressure” or `MDS_HEALTH_CLIENT_RECALL` will be reported. Each session’s rate of release is monitored by another decay counter configured by:

- mds_recall_warning_threshold[](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#confval-mds_recall_warning_threshold)

  decay threshold for warning on slow session cap recall type `size` default `256Ki`

- mds_recall_warning_decay_rate[](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#confval-mds_recall_warning_decay_rate)

  decay rate for warning on slow session cap recall type `float` default `60.0`

Each time a capability is released, the counter is incremented.  If clients do not release capabilities quickly enough and there is cache pressure, the counter will indicate if the client is slow to release state.

Some workloads and client behaviors may require faster recall of client state to keep up with capability acquisition. It is recommended to increase the above counters as needed to resolve any slow recall warnings in the cluster health state.

## MDS Cap Acquisition Throttle[](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#mds-cap-acquisition-throttle)

A trivial “find” command on a large directory hierarchy will cause the client to receive caps significantly faster than it will release. The MDS will try to have the client reduce its caps below the `mds_max_caps_per_client` limit but the recall throttles prevent it from catching up to the pace of acquisition. So the readdir is throttled to control cap acquisition via the following configurations:

The threshold and decay rate for the readdir cap acquisition decay counter:

- mds_session_cap_acquisition_throttle[](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#confval-mds_session_cap_acquisition_throttle)

  throttle point for cap acquisition decay counter type `uint` default `500000`

- mds_session_cap_acquisition_decay_rate[](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#confval-mds_session_cap_acquisition_decay_rate)

  The half-life for the session cap acquisition counter of caps acquired by readdir. This is used for throttling readdir requests from clients slow to release caps. type `float` default `10.0`

The cap acquisition decay counter controls the rate of cap acquisition via readdir. The behavior of the decay counter is the same as for cache trimming or caps recall. Each readdir call increments the counter by the number of files in the result.

The ratio of `mds_max_caps_per_client` that client must exceed before readdir maybe throttled by cap acquisition throttle:

- mds_session_max_caps_throttle_ratio[](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#confval-mds_session_max_caps_throttle_ratio)

  ratio of mds_max_caps_per_client that client must exceed before readdir may be throttled by cap acquisition throttle type `float` default `1.1`

The timeout in seconds after which a client request is retried due to cap acquisition throttling:

- mds_cap_acquisition_throttle_retry_request_timeout[](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#confval-mds_cap_acquisition_throttle_retry_request_timeout)

  timeout in seconds after which a client request is retried due to cap acquisition throttling type `float` default `0.5`

If the number of caps acquired by the client per session is greater than the `mds_session_max_caps_throttle_ratio` and cap acquisition decay counter is greater than `mds_session_cap_acquisition_throttle`, the readdir is throttled. The readdir request is retried after `mds_cap_acquisition_throttle_retry_request_timeout` seconds.

## Session Liveness[](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#session-liveness)

The MDS also keeps track of whether sessions are quiescent. If a client session is not utilizing its capabilities or is otherwise quiet, the MDS will begin recalling state from the session even if it’s not under cache pressure. This helps the MDS avoid future work when the cluster workload is hot and cache pressure is forcing the MDS to recall state. The expectation is that a client not utilizing its capabilities is unlikely to use those capabilities anytime in the near future.

Determining whether a given session is quiescent is controlled by the following configuration variables:

- mds_session_cache_liveness_magnitude[](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#confval-mds_session_cache_liveness_magnitude)

  This is the order of magnitude difference (in base 2) of the internal liveness decay counter and the number of capabilities the session holds. When this difference occurs, the MDS treats the session as quiescent and begins recalling capabilities. type `size` default `10B` see also [`mds_session_cache_liveness_decay_rate`](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#confval-mds_session_cache_liveness_decay_rate)

- mds_session_cache_liveness_decay_rate[](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#confval-mds_session_cache_liveness_decay_rate)

  This determines how long a session needs to be quiescent before the MDS begins preemptively recalling capabilities. The default of 5 minutes will cause 10 halvings of the decay counter after 1 hour, or 1/1024. The default magnitude of 10 (1^10 or 1024) is chosen so that the MDS considers a previously chatty session (approximately) to be quiescent after 1 hour. type `float` default `5 minutes` see also [`mds_session_cache_liveness_magnitude`](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#confval-mds_session_cache_liveness_magnitude)

The configuration `mds_session_cache_liveness_decay_rate` indicates the half-life for the decay counter tracking the use of capabilities by the client. Each time a client manipulates or acquires a capability, the MDS will increment the counter. This is a rough but effective way to monitor the utilization of the client cache.

The `mds_session_cache_liveness_magnitude` is a base-2 magnitude difference of the liveness decay counter and the number of capabilities outstanding for the session. So if the client has `1*2^20` (1M) capabilities outstanding and only uses **less** than `1*2^(20-mds_session_cache_liveness_magnitude)` (1K using defaults), the MDS will consider the client to be quiescent and begin recall.

## Capability Limit[](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#capability-limit)

The MDS also tries to prevent a single client from acquiring too many capabilities. This helps prevent recovery from taking a long time in some situations.  It is not generally necessary for a client to have such a large cache. The limit is configured via:

- mds_max_caps_per_client[](https://docs.ceph.com/en/latest/cephfs/cache-configuration/#confval-mds_max_caps_per_client)

  maximum number of capabilities a client may hold type `uint` default `1Mi`

It is not recommended to set this value above 5M but it may be helpful with some workloads.

# MDS Config Reference[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#mds-config-reference)

- mds_cache_mid[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_cache_mid)

  The insertion point for new items in the cache LRU (from the top). type `float` default `0.7`

- mds_dir_max_commit_size[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_dir_max_commit_size)

  The maximum size of a directory update before Ceph breaks it into smaller transactions (MB). type `int` default `10`

- mds_dir_max_entries[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_dir_max_entries)

  The maximum number of entries before any new entries are rejected with ENOSPC. type `uint` default `0`

- mds_decay_halflife[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_decay_halflife)

  rate of decay for temperature counters on each directory for balancing type `float` default `5.0`

- mds_beacon_interval[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_beacon_interval)

  interval in seconds between MDS beacon messages sent to monitors type `float` default `4.0`

- mds_beacon_grace[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_beacon_grace)

  The interval without beacons before Ceph declares an MDS laggy (and possibly replace it). type `float` default `15.0`

- mon_mds_blocklist_interval[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mon_mds_blocklist_interval)

  The blocklist duration for failed MDSs in the OSD map. Note, this controls how long failed MDS daemons will stay in the OSDMap blocklist. It has no effect on how long something is blocklisted when the administrator blocklists it manually. For example, `ceph osd blocklist add` will still use the default blocklist time. type `float` default `1 day` min `1_hr`

- mds_reconnect_timeout[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_reconnect_timeout)

  timeout in seconds to wait for clients to reconnect during MDS reconnect recovery state type `float` default `45.0`

- mds_tick_interval[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_tick_interval)

  How frequently the MDS performs internal periodic tasks. type `float` default `5.0`

- mds_dirstat_min_interval[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_dirstat_min_interval)

  The minimum interval (in seconds) to try to avoid propagating recursive stats up the tree. type `float` default `1.0`

- mds_scatter_nudge_interval[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_scatter_nudge_interval)

  How quickly dirstat changes propagate up. type `float` default `5.0`

- mds_client_prealloc_inos[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_client_prealloc_inos)

  The number of inode numbers to preallocate per client session. type `int` default `1000`

- mds_early_reply[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_early_reply)

  Determines whether the MDS should allow clients to see request results before they commit to the journal. type `bool` default `true`

- mds_default_dir_hash[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_default_dir_hash)

  The function to use for hashing files across directory fragments. type `int` default `2`

- mds_log_skip_corrupt_events[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_log_skip_corrupt_events)

  Determines whether the MDS should try to skip corrupt journal events during journal replay. type `bool` default `false`

- mds_log_max_events[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_log_max_events)

  The maximum events in the journal before we initiate trimming. Set to `-1` to disable limits. type `int` default `-1`

- mds_log_max_segments[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_log_max_segments)

  The maximum number of segments (objects) in the journal before we initiate trimming. Set to `-1` to disable limits. type `uint` default `128`

- mds_bal_sample_interval[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_sample_interval)

  Determines how frequently to sample directory temperature (for fragmentation decisions). type `float` default `3.0`

- mds_bal_replicate_threshold[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_replicate_threshold)

  The maximum temperature before Ceph attempts to replicate metadata to other nodes. type `float` default `8000.0`

- mds_bal_unreplicate_threshold[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_unreplicate_threshold)

  The minimum temperature before Ceph stops replicating metadata to other nodes. type `float` default `0.0`

- mds_bal_split_size[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_split_size)

  The maximum directory size before the MDS will split a directory fragment into smaller bits. type `int` default `10000`

- mds_bal_split_rd[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_split_rd)

  The maximum directory read temperature before Ceph splits a directory fragment. type `float` default `25000.0`

- mds_bal_split_wr[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_split_wr)

  The maximum directory write temperature before Ceph splits a directory fragment. type `float` default `10000.0`

- mds_bal_split_bits[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_split_bits)

  The number of bits by which to split a directory fragment. type `int` default `3` allowed range `[1, 24]`

- mds_bal_merge_size[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_merge_size)

  The minimum directory size before Ceph tries to merge adjacent directory fragments. type `int` default `50`

- mds_bal_interval[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_interval)

  The frequency (in seconds) of workload exchanges between MDSs. type `int` default `10`

- mds_bal_fragment_interval[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_fragment_interval)

  The delay (in seconds) between a fragment being eligible for split or merge and executing the fragmentation change. type `int` default `5`

- mds_bal_fragment_fast_factor[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_fragment_fast_factor)

  The ratio by which frags may exceed the split size before a split is executed immediately (skipping the fragment interval) type `float` default `1.5`

- mds_bal_fragment_size_max[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_fragment_size_max)

  The maximum size of a fragment before any new entries are rejected with ENOSPC. type `int` default `100000`

- mds_bal_idle_threshold[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_idle_threshold)

  The minimum temperature before Ceph migrates a subtree back to its parent. type `float` default `0.0`

- mds_bal_max[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_max)

  The number of iterations to run balancer before Ceph stops. (used for testing purposes only) type `int` default `-1`

- mds_bal_max_until[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_max_until)

  The number of seconds to run balancer before Ceph stops. (used for testing purposes only) type `int` default `-1`

- mds_bal_mode[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_mode)

  The method for calculating MDS load.  `0` = Hybrid. `1` = Request rate and latency. `2` = CPU load.  type `int` default `0`

- mds_bal_min_rebalance[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_min_rebalance)

  The minimum subtree temperature before Ceph migrates. type `float` default `0.1`

- mds_bal_min_start[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_min_start)

  The minimum subtree temperature before Ceph searches a subtree. type `float` default `0.2`

- mds_bal_need_min[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_need_min)

  The minimum fraction of target subtree size to accept. type `float` default `0.8`

- mds_bal_need_max[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_need_max)

  The maximum fraction of target subtree size to accept. type `float` default `1.2`

- mds_bal_midchunk[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_midchunk)

  Ceph will migrate any subtree that is larger than this fraction of the target subtree size. type `float` default `0.3`

- mds_bal_minchunk[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_bal_minchunk)

  Ceph will ignore any subtree that is smaller than this fraction of the target subtree size. type `float` default `0.001`

- mds_replay_interval[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_replay_interval)

  The journal poll interval when in standby-replay mode. (“hot standby”) type `float` default `1.0`

- mds_shutdown_check[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_shutdown_check)

  The interval for polling the cache during MDS shutdown. type `int` default `0`

- mds_thrash_exports[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_thrash_exports)

  Ceph will randomly export subtrees between nodes (testing only). type `int` default `0`

- mds_thrash_fragments[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_thrash_fragments)

  Ceph will randomly fragment or merge directories. type `int` default `0`

- mds_dump_cache_on_map[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_dump_cache_on_map)

  Ceph will dump the MDS cache contents to a file on each MDSMap. type `bool` default `false`

- mds_dump_cache_after_rejoin[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_dump_cache_after_rejoin)

  Ceph will dump MDS cache contents to a file after rejoining the cache (during recovery). type `bool` default `false`

- mds_verify_scatter[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_verify_scatter)

  Ceph will assert that various scatter/gather invariants are `true` (developers only). type `bool` default `false`

- mds_debug_scatterstat[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_debug_scatterstat)

  Ceph will assert that various recursive stat invariants are `true` (for developers only). type `bool` default `false`

- mds_debug_frag[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_debug_frag)

  Ceph will verify directory fragmentation invariants when convenient (developers only). type `bool` default `false`

- mds_debug_auth_pins[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_debug_auth_pins)

  The debug auth pin invariants (for developers only). type `bool` default `false`

- mds_debug_subtrees[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_debug_subtrees)

  The debug subtree invariants (for developers only). type `bool` default `false`

- mds_kill_mdstable_at[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_kill_mdstable_at)

  Ceph will inject MDS failure in MDSTable code (for developers only). type `int` default `0`

- mds_kill_export_at[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_kill_export_at)

  Ceph will inject MDS failure in the subtree export code (for developers only). type `int` default `0`

- mds_kill_import_at[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_kill_import_at)

  Ceph will inject MDS failure in the subtree import code (for developers only). type `int` default `0`

- mds_kill_link_at[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_kill_link_at)

  Ceph will inject MDS failure in hard link code (for developers only). type `int` default `0`

- mds_kill_rename_at[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_kill_rename_at)

  Ceph will inject MDS failure in the rename code (for developers only). type `int` default `0`

- mds_wipe_sessions[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_wipe_sessions)

  Ceph will delete all client sessions on startup (for testing only). type `bool` default `false`

- mds_wipe_ino_prealloc[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_wipe_ino_prealloc)

  Ceph will delete ino preallocation metadata on startup (for testing only). type `bool` default `false`

- mds_skip_ino[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_skip_ino)

  The number of inode numbers to skip on startup (for testing only). type `int` default `0`

- mds_min_caps_per_client[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_min_caps_per_client)

  minimum number of capabilities a client may hold type `uint` default `100`

- mds_symlink_recovery[](https://docs.ceph.com/en/latest/cephfs/mds-config-ref/#confval-mds_symlink_recovery)

  Stores symlink target on the first data object of symlink file. Allows recover of symlink using recovery tools. type `bool` default `true`

# ceph-mds -- ceph metadata server daemon[](https://docs.ceph.com/en/latest/man/8/ceph-mds/#ceph-mds-ceph-metadata-server-daemon)

## Synopsis[](https://docs.ceph.com/en/latest/man/8/ceph-mds/#synopsis)

**ceph-mds** -i <*ID*> [flags]

## Description[](https://docs.ceph.com/en/latest/man/8/ceph-mds/#description)

**ceph-mds** is the metadata server daemon for the Ceph distributed file system. One or more instances of ceph-mds collectively manage the file system namespace, coordinating access to the shared OSD cluster.

Each ceph-mds daemon instance should have a unique name. The name is used to identify daemon instances in the ceph.conf.

Once the daemon has started, the monitor cluster will normally assign it a logical rank, or put it in a standby pool to take over for another daemon that crashes. Some of the specified options can cause other behaviors.

## Options[](https://docs.ceph.com/en/latest/man/8/ceph-mds/#options)

- -f, --foreground[](https://docs.ceph.com/en/latest/man/8/ceph-mds/#cmdoption-ceph-mds-f)

  Foreground: do not daemonize after startup (run in foreground). Do not generate a pid file. Useful when run via [ceph-run](https://docs.ceph.com/en/latest/man/8/ceph-run/)(8).

- -d[](https://docs.ceph.com/en/latest/man/8/ceph-mds/#cmdoption-ceph-mds-d)

  Debug mode: like `-f`, but also send all log output to stderr.

- --setuser userorgid[](https://docs.ceph.com/en/latest/man/8/ceph-mds/#cmdoption-ceph-mds-setuser)

  Set uid after starting.  If a username is specified, the user record is looked up to get a uid and a gid, and the gid is also set as well, unless --setgroup is also specified.

- --setgroup grouporgid[](https://docs.ceph.com/en/latest/man/8/ceph-mds/#cmdoption-ceph-mds-setgroup)

  Set gid after starting.  If a group name is specified the group record is looked up to get a gid.

- -c ceph.conf, --conf=ceph.conf[](https://docs.ceph.com/en/latest/man/8/ceph-mds/#cmdoption-ceph-mds-c)

  Use *ceph.conf* configuration file instead of the default `/etc/ceph/ceph.conf` to determine monitor addresses during startup.

- -m monaddress[:port][](https://docs.ceph.com/en/latest/man/8/ceph-mds/#cmdoption-ceph-mds-m)

  Connect to specified monitor (instead of looking through `ceph.conf`).

- --id/-i ID[](https://docs.ceph.com/en/latest/man/8/ceph-mds/#cmdoption-ceph-mds-id-i)

  Set ID portion of the MDS name. The ID should not start with a numeric digit.

- --name/-n TYPE.ID[](https://docs.ceph.com/en/latest/man/8/ceph-mds/#cmdoption-ceph-mds-name-n)

  Set the MDS name of the format TYPE.ID. The TYPE is obviously ‘mds’. The ID should not start with a numeric digit.

## Availability[](https://docs.ceph.com/en/latest/man/8/ceph-mds/#availability)

**ceph-mds** is part of Ceph, a massively scalable, open-source, distributed storage system. Please refer to the Ceph documentation at https://docs.ceph.com for more information.

## See also[](https://docs.ceph.com/en/latest/man/8/ceph-mds/#see-also)

[ceph](https://docs.ceph.com/en/latest/man/8/ceph/)(8), [ceph-mon](https://docs.ceph.com/en/latest/man/8/ceph-mon/)(8), [ceph-osd](https://docs.ceph.com/en/latest/man/8/ceph-osd/)(8)

​        

## 创建密钥文件

Ceph 存储集群默认启用认证，应该有个包含密钥的配置文件（但不是密钥环本身）。用下述方法获取某一用户的密钥：

1. 在密钥环文件中找到与某用户对应的密钥，例如：

   ```bash
   cat ceph.client.admin.keyring
   ```

2. 找到用于挂载 Ceph 文件系统的用户，复制其密钥。大概看起来如下所示：

   ```bash
   [client.admin]
      key = AQCj2YpRiAe6CxAA7/ETt7Hcl9IyxyYciVs47w==
   ```

3. 打开文本编辑器，把密钥粘帖进去：

   ```bash
   AQCj2YpRiAe6CxAA7/ETt7Hcl9IyxyYciVs47w==
   ```

5. 保存文件，并把其用户名 `name` 作为一个属性（如 `admin.secret` ）。

6. 确保此文件对用户有合适的权限，但对其他用户不可见。

## 内核驱动

把 Ceph FS 挂载为内核驱动。

```bash
sudo mkdir /mnt/mycephfs
sudo mount -t ceph {ip-address-of-monitor}:6789:/ /mnt/mycephfs
```

Ceph 存储集群默认需要认证，所以挂载时需要指定用户名 `name` 和密钥文件 `secretfile` ，例如：

```bash
sudo mount -t ceph 192.168.0.1:6789:/ /mnt/mycephfs -o name=admin,secretfile=admin.secret
```

## 用户空间文件系统（ FUSE ）

把 Ceph FS 挂载为用户空间文件系统（ FUSE ）。

```bash
sudo mkdir ~/mycephfs
sudo ceph-fuse -m {ip-address-of-monitor}:6789 ~/mycephfs
```

Ceph 存储集群默认要求认证，需指定相应的密钥环文件，除非它在默认位置（即 `/etc/ceph` ）：

```bash
sudo ceph-fuse -k ./ceph.client.admin.keyring -m 192.168.0.1:6789 ~/mycephfs
```

# Application best practices for distributed file systems[](https://docs.ceph.com/en/latest/cephfs/app-best-practices/#application-best-practices-for-distributed-file-systems)

CephFS is POSIX compatible, and therefore should work with any existing applications that expect a POSIX file system.  However, because it is a network file system (unlike e.g. XFS) and it is highly consistent (unlike e.g. NFS), there are some consequences that application authors may benefit from knowing about.

The following sections describe some areas where distributed file systems may have noticeably different performance behaviours compared with local file systems.

## ls -l[](https://docs.ceph.com/en/latest/cephfs/app-best-practices/#ls-l)

When you run “ls -l”, the `ls` program is first doing a directory listing, and then calling `stat` on every file in the directory.

This is usually far in excess of what an application really needs, and it can be slow for large directories.  If you don’t really need all this metadata for each file, then use a plain `ls`.

## ls/stat on files being extended[](https://docs.ceph.com/en/latest/cephfs/app-best-practices/#ls-stat-on-files-being-extended)

If another client is currently extending files in the listed directory, then an `ls -l` may take an exceptionally long time to complete, as the lister must wait for the writer to flush data in order to do a valid read of the every file’s size.  So unless you *really* need to know the exact size of every file in the directory, just don’t do it!

This would also apply to any application code that was directly issuing `stat` system calls on files being appended from another node.

## Very large directories[](https://docs.ceph.com/en/latest/cephfs/app-best-practices/#very-large-directories)

Do you really need that 10,000,000 file directory?  While directory fragmentation enables CephFS to handle it, it is always going to be less efficient than splitting your files into more modest-sized directories.

Even standard userspace tools can become quite slow when operating on very large directories. For example, the default behaviour of `ls` is to give an alphabetically ordered result, but `readdir` system calls do not give an ordered result (this is true in general, not just with CephFS).  So when you `ls` on a million file directory, it is loading a list of a million names into memory, sorting the list, then writing it out to the display.

## Hard links[](https://docs.ceph.com/en/latest/cephfs/app-best-practices/#hard-links)

Hard links have an intrinsic cost in terms of the internal housekeeping that a file system has to do to keep two references to the same data.  In CephFS there is a particular performance cost, because with normal files the inode is embedded in the directory (i.e. there is no extra fetch of the inode after looking up the path).

## Working set size[](https://docs.ceph.com/en/latest/cephfs/app-best-practices/#working-set-size)

The MDS acts as a cache for the metadata stored in RADOS.  Metadata performance is very different for workloads whose metadata fits within that cache.

If your workload has more files than fit in your cache (configured using `mds_cache_memory_limit` settings), then make sure you test it appropriately: don’t test your system with a small number of files and then expect equivalent performance when you move to a much larger number of files.

## Do you need a file system?[](https://docs.ceph.com/en/latest/cephfs/app-best-practices/#do-you-need-a-file-system)

Remember that Ceph also includes an object storage interface.  If your application needs to store huge flat collections of files where you just read and write whole files at once, then you might well be better off using the [Object Gateway](https://docs.ceph.com/en/latest/radosgw/#object-gateway)

# FS volumes and subvolumes[](https://docs.ceph.com/en/latest/cephfs/fs-volumes/#fs-volumes-and-subvolumes)

A  single source of truth for CephFS exports is implemented in the volumes module of the [Ceph Manager](https://docs.ceph.com/en/latest/glossary/#term-Ceph-Manager) daemon (ceph-mgr). The OpenStack shared file system service ([manila](https://github.com/openstack/manila)), Ceph Container Storage Interface ([CSI](https://github.com/ceph/ceph-csi)), storage administrators among others can use the common CLI provided by the ceph-mgr volumes module to manage the CephFS exports.

The ceph-mgr volumes module implements the following file system export abstractions:

- FS volumes, an abstraction for CephFS file systems
- FS subvolumes, an abstraction for independent CephFS directory trees
- FS subvolume groups, an abstraction for a directory level higher than FS subvolumes to effect policies (e.g., [File layouts](https://docs.ceph.com/en/latest/cephfs/file-layouts/)) across a set of subvolumes

Some possible use-cases for the export abstractions:

- FS subvolumes used as manila shares or CSI volumes
- FS subvolume groups used as manila share groups

## Requirements[](https://docs.ceph.com/en/latest/cephfs/fs-volumes/#requirements)

- Nautilus (14.2.x) or a later version of Ceph

- Cephx client user (see [User Management](https://docs.ceph.com/en/latest/rados/operations/user-management/)) with the following minimum capabilities:

  ```
  mon 'allow r'
  mgr 'allow rw'
  ```

## FS Volumes[](https://docs.ceph.com/en/latest/cephfs/fs-volumes/#fs-volumes)

Create a volume using:

```
$ ceph fs volume create <vol_name> [<placement>]
```

This creates a CephFS file system and its data and metadata pools. It can also try to create MDSes for the filesystem using the enabled ceph-mgr orchestrator module (see [Orchestrator CLI](https://docs.ceph.com/en/latest/mgr/orchestrator/)), e.g. rook.

<vol_name> is the volume name (an arbitrary string), and

<placement> is an optional string signifying which hosts should have NFS Ganesha daemon containers running on them and, optionally, the total number of NFS Ganesha daemons the cluster (should you want to have more than one NFS Ganesha daemon running per node). For example, the following placement string means “deploy NFS Ganesha daemons on nodes host1 and host2 (one daemon per host):

> “host1,host2”

and this placement specification says to deploy two NFS Ganesha daemons each on nodes host1 and host2 (for a total of four NFS Ganesha daemons in the cluster):

> “4 host1,host2”

For more details on placement specification refer to the [Service Specification](https://docs.ceph.com/en/latest/cephadm/services/#orchestrator-cli-service-spec), but keep in mind that specifying the placement via a YAML file is not supported.

Remove a volume using:

```
$ ceph fs volume rm <vol_name> [--yes-i-really-mean-it]
```

This removes a file system and its data and metadata pools. It also tries to remove MDSes using the enabled ceph-mgr orchestrator module.

List volumes using:

```
$ ceph fs volume ls
```

Rename a volume using:

```
$ ceph fs volume rename <vol_name> <new_vol_name> [--yes-i-really-mean-it]
```

Renaming a volume can be an expensive operation. It does the following:

- renames the orchestrator managed MDS service to match the <new_vol_name>. This involves launching a MDS service with <new_vol_name> and bringing down the MDS service with <vol_name>.
- renames the file system matching <vol_name> to <new_vol_name>
- changes the application tags on the data and metadata pools of the file system to <new_vol_name>
- renames the  metadata and data pools of the file system.

The CephX IDs authorized to <vol_name> need to be reauthorized to <new_vol_name>. Any on-going operations of the clients using these IDs may be disrupted. Mirroring is expected to be disabled on the volume.

## FS Subvolume groups[](https://docs.ceph.com/en/latest/cephfs/fs-volumes/#fs-subvolume-groups)

Create a subvolume group using:

```
$ ceph fs subvolumegroup create <vol_name> <group_name> [--size <size_in_bytes>] [--pool_layout <data_pool_name>] [--uid <uid>] [--gid <gid>] [--mode <octal_mode>]
```

The command succeeds even if the subvolume group already exists.

When creating a subvolume group you can specify its data pool layout (see [File layouts](https://docs.ceph.com/en/latest/cephfs/file-layouts/)), uid, gid, file mode in octal numerals and size in bytes. The size of the subvolume group is specified by setting a quota on it (see [Quotas](https://docs.ceph.com/en/latest/cephfs/quota/)). By default, the subvolume group is created with an octal file mode ‘755’, uid ‘0’, gid ‘0’ and data pool layout of its parent directory.

Remove a subvolume group using:

```
$ ceph fs subvolumegroup rm <vol_name> <group_name> [--force]
```

The removal of a subvolume group fails if it is not empty or non-existent. ‘--force’ flag allows the non-existent subvolume group remove command to succeed.

Fetch the absolute path of a subvolume group using:

```
$ ceph fs subvolumegroup getpath <vol_name> <group_name>
```

List subvolume groups using:

```
$ ceph fs subvolumegroup ls <vol_name>
```

Note

Subvolume group snapshot feature is no longer supported in mainline CephFS (existing group snapshots can still be listed and deleted)

Fetch the metadata of a subvolume group using:

```
$ ceph fs subvolumegroup info <vol_name> <group_name>
```

The output format is json and contains fields as follows.

- atime: access time of subvolume group path in the format “YYYY-MM-DD HH:MM:SS”
- mtime: modification time of subvolume group path in the format “YYYY-MM-DD HH:MM:SS”
- ctime: change time of subvolume group path in the format “YYYY-MM-DD HH:MM:SS”
- uid: uid of subvolume group path
- gid: gid of subvolume group path
- mode: mode of subvolume group path
- mon_addrs: list of monitor addresses
- bytes_pcent: quota used in percentage if quota is set, else displays “undefined”
- bytes_quota: quota size in bytes if quota is set, else displays “infinite”
- bytes_used: current used size of the subvolume group in bytes
- created_at: time of creation of subvolume group in the format “YYYY-MM-DD HH:MM:SS”
- data_pool: data pool the subvolume group belongs to

Resize a subvolume group using:

```
$ ceph fs subvolumegroup resize <vol_name> <group_name> <new_size> [--no_shrink]
```

The command resizes the subvolume group quota using the size specified by ‘new_size’. The ‘--no_shrink’ flag prevents the subvolume group to shrink below the current used size of the subvolume group.

The subvolume group can be resized to an infinite size by passing ‘inf’ or ‘infinite’ as the new_size.

Remove a snapshot of a subvolume group using:

```
$ ceph fs subvolumegroup snapshot rm <vol_name> <group_name> <snap_name> [--force]
```

Using the ‘--force’ flag allows the command to succeed that would otherwise fail if the snapshot did not exist.

List snapshots of a subvolume group using:

```
$ ceph fs subvolumegroup snapshot ls <vol_name> <group_name>
```

## FS Subvolumes[](https://docs.ceph.com/en/latest/cephfs/fs-volumes/#fs-subvolumes)

Create a subvolume using:

```
$ ceph fs subvolume create <vol_name> <subvol_name> [--size <size_in_bytes>] [--group_name <subvol_group_name>] [--pool_layout <data_pool_name>] [--uid <uid>] [--gid <gid>] [--mode <octal_mode>] [--namespace-isolated]
```

The command succeeds even if the subvolume already exists.

When creating a subvolume you can specify its subvolume group, data pool layout, uid, gid, file mode in octal numerals, and size in bytes. The size of the subvolume is specified by setting a quota on it (see [Quotas](https://docs.ceph.com/en/latest/cephfs/quota/)). The subvolume can be created in a separate RADOS namespace by specifying --namespace-isolated option. By default a subvolume is created within the default subvolume group, and with an octal file mode ‘755’, uid of its subvolume group, gid of its subvolume group, data pool layout of its parent directory and no size limit.

Remove a subvolume using:

```
$ ceph fs subvolume rm <vol_name> <subvol_name> [--group_name <subvol_group_name>] [--force] [--retain-snapshots]
```

The command removes the subvolume and its contents. It does this in two steps. First, it moves the subvolume to a trash folder, and then asynchronously purges its contents.

The removal of a subvolume fails if it has snapshots, or is non-existent. ‘--force’ flag allows the non-existent subvolume remove command to succeed.

A subvolume can be removed retaining existing snapshots of the subvolume using the ‘--retain-snapshots’ option. If snapshots are retained, the subvolume is considered empty for all operations not involving the retained snapshots.

Note

Snapshot retained subvolumes can be recreated using ‘ceph fs subvolume create’

Note

Retained snapshots can be used as a clone source to recreate the subvolume, or clone to a newer subvolume.

Resize a subvolume using:

```
$ ceph fs subvolume resize <vol_name> <subvol_name> <new_size> [--group_name <subvol_group_name>] [--no_shrink]
```

The command resizes the subvolume quota using the size specified by ‘new_size’. ‘--no_shrink’ flag prevents the subvolume to shrink below the current used size of the subvolume.

The subvolume can be resized to an infinite size by passing ‘inf’ or ‘infinite’ as the new_size.

Authorize cephx auth IDs, the read/read-write access to fs subvolumes:

```
$ ceph fs subvolume authorize <vol_name> <sub_name> <auth_id> [--group_name=<group_name>] [--access_level=<access_level>]
```

The ‘access_level’ takes ‘r’ or ‘rw’ as value.

Deauthorize cephx auth IDs, the read/read-write access to fs subvolumes:

```
$ ceph fs subvolume deauthorize <vol_name> <sub_name> <auth_id> [--group_name=<group_name>]
```

List cephx auth IDs authorized to access fs subvolume:

```
$ ceph fs subvolume authorized_list <vol_name> <sub_name> [--group_name=<group_name>]
```

Evict fs clients based on auth ID and subvolume mounted:

```
$ ceph fs subvolume evict <vol_name> <sub_name> <auth_id> [--group_name=<group_name>]
```

Fetch the absolute path of a subvolume using:

```
$ ceph fs subvolume getpath <vol_name> <subvol_name> [--group_name <subvol_group_name>]
```

Fetch the information of a subvolume using:

```
$ ceph fs subvolume info <vol_name> <subvol_name> [--group_name <subvol_group_name>]
```

The output format is json and contains fields as follows.

- atime: access time of subvolume path in the format “YYYY-MM-DD HH:MM:SS”
- mtime: modification time of subvolume path in the format “YYYY-MM-DD HH:MM:SS”
- ctime: change time of subvolume path in the format “YYYY-MM-DD HH:MM:SS”
- uid: uid of subvolume path
- gid: gid of subvolume path
- mode: mode of subvolume path
- mon_addrs: list of monitor addresses
- bytes_pcent: quota used in percentage if quota is set, else displays “undefined”
- bytes_quota: quota size in bytes if quota is set, else displays “infinite”
- bytes_used: current used size of the subvolume in bytes
- created_at: time of creation of subvolume in the format “YYYY-MM-DD HH:MM:SS”
- data_pool: data pool the subvolume belongs to
- path: absolute path of a subvolume
- type: subvolume type indicating whether it’s clone or subvolume
- pool_namespace: RADOS namespace of the subvolume
- features: features supported by the subvolume
- state: current state of the subvolume

If a subvolume has been removed retaining its snapshots, the output only contains fields as follows.

- type: subvolume type indicating whether it’s clone or subvolume
- features: features supported by the subvolume
- state: current state of the subvolume

The subvolume “features” are based on the internal version of the subvolume and is a list containing a subset of the following features,

- “snapshot-clone”: supports cloning using a subvolumes snapshot as the source
- “snapshot-autoprotect”: supports automatically protecting snapshots, that are active clone sources, from deletion
- “snapshot-retention”: supports removing subvolume contents, retaining any existing snapshots

The subvolume “state” is based on the current state of the subvolume and contains one of the following values.

- “complete”: subvolume is ready for all operations
- “snapshot-retained”: subvolume is removed but its snapshots are retained

List subvolumes using:

```
$ ceph fs subvolume ls <vol_name> [--group_name <subvol_group_name>]
```

Note

subvolumes that are removed but have snapshots retained, are also listed.

Set custom metadata on the subvolume as a key-value pair using:

```
$ ceph fs subvolume metadata set <vol_name> <subvol_name> <key_name> <value> [--group_name <subvol_group_name>]
```

Note

If the key_name already exists then the old value will get replaced by the new value.

Note

key_name and value should be a string of ASCII characters (as  specified in python’s string.printable). key_name is case-insensitive  and always stored in lower case.

Note

Custom metadata on a subvolume is not preserved when snapshotting the subvolume, and hence, is also not preserved when cloning the subvolume  snapshot.

Get custom metadata set on the subvolume using the metadata key:

```
$ ceph fs subvolume metadata get <vol_name> <subvol_name> <key_name> [--group_name <subvol_group_name>]
```

List custom metadata (key-value pairs) set on the subvolume using:

```
$ ceph fs subvolume metadata ls <vol_name> <subvol_name> [--group_name <subvol_group_name>]
```

Remove custom metadata set on the subvolume using the metadata key:

```
$ ceph fs subvolume metadata rm <vol_name> <subvol_name> <key_name> [--group_name <subvol_group_name>] [--force]
```

Using the ‘--force’ flag allows the command to succeed that would otherwise fail if the metadata key did not exist.

Create a snapshot of a subvolume using:

```
$ ceph fs subvolume snapshot create <vol_name> <subvol_name> <snap_name> [--group_name <subvol_group_name>]
```

Remove a snapshot of a subvolume using:

```
$ ceph fs subvolume snapshot rm <vol_name> <subvol_name> <snap_name> [--group_name <subvol_group_name>] [--force]
```

Using the ‘--force’ flag allows the command to succeed that would otherwise fail if the snapshot did not exist.

Note

if the last snapshot within a snapshot retained subvolume is removed, the subvolume is also removed

List snapshots of a subvolume using:

```
$ ceph fs subvolume snapshot ls <vol_name> <subvol_name> [--group_name <subvol_group_name>]
```

Fetch the information of a snapshot using:

```
$ ceph fs subvolume snapshot info <vol_name> <subvol_name> <snap_name> [--group_name <subvol_group_name>]
```

The output format is json and contains fields as follows.

- created_at: time of creation of snapshot in the format “YYYY-MM-DD HH:MM:SS:ffffff”
- data_pool: data pool the snapshot belongs to
- has_pending_clones: “yes” if snapshot clone is in progress otherwise “no”
- size: snapshot size in bytes

Set custom metadata on the snapshot as a key-value pair using:

```
$ ceph fs subvolume snapshot metadata set <vol_name> <subvol_name> <snap_name> <key_name> <value> [--group_name <subvol_group_name>]
```

Note

If the key_name already exists then the old value will get replaced by the new value.

Note

The key_name and value should be a string of ASCII characters (as  specified in python’s string.printable). The key_name is  case-insensitive and always stored in lower case.

Note

Custom metadata on a snapshots is not preserved when snapshotting the subvolume, and hence, is also not preserved when cloning the subvolume  snapshot.

Get custom metadata set on the snapshot using the metadata key:

```
$ ceph fs subvolume snapshot metadata get <vol_name> <subvol_name> <snap_name> <key_name> [--group_name <subvol_group_name>]
```

List custom metadata (key-value pairs) set on the snapshot using:

```
$ ceph fs subvolume snapshot metadata ls <vol_name> <subvol_name> <snap_name> [--group_name <subvol_group_name>]
```

Remove custom metadata set on the snapshot using the metadata key:

```
$ ceph fs subvolume snapshot metadata rm <vol_name> <subvol_name> <snap_name> <key_name> [--group_name <subvol_group_name>] [--force]
```

Using the ‘--force’ flag allows the command to succeed that would otherwise fail if the metadata key did not exist.

## Cloning Snapshots[](https://docs.ceph.com/en/latest/cephfs/fs-volumes/#cloning-snapshots)

Subvolumes can be created by cloning subvolume snapshots. Cloning is an asynchronous operation involving copying data from a snapshot to a subvolume. Due to this bulk copy nature, cloning is currently inefficient for very huge data sets.

Note

Removing a snapshot (source subvolume) would fail if there are pending or in progress clone operations.

Protecting snapshots prior to cloning was a pre-requisite in the Nautilus release, and the commands to protect/unprotect snapshots were introduced for this purpose. This pre-requisite, and hence the commands to protect/unprotect, is being deprecated in mainline CephFS, and may be removed from a future release.

- The commands being deprecated are:

  $ ceph fs subvolume  snapshot protect <vol_name> <subvol_name> <snap_name>  [--group_name <subvol_group_name>] $ ceph fs subvolume snapshot unprotect <vol_name>  <subvol_name> <snap_name> [--group_name  <subvol_group_name>]

Note

Using the above commands would not result in an error, but they serve no useful function.

Note

Use subvolume info command to fetch subvolume metadata regarding  supported “features” to help decide if protect/unprotect of snapshots is required, based on the “snapshot-autoprotect” feature availability.

To initiate a clone operation use:

```
$ ceph fs subvolume snapshot clone <vol_name> <subvol_name> <snap_name> <target_subvol_name>
```

If a snapshot (source subvolume) is a part of non-default group, the group name needs to be specified as per:

```
$ ceph fs subvolume snapshot clone <vol_name> <subvol_name> <snap_name> <target_subvol_name> --group_name <subvol_group_name>
```

Cloned subvolumes can be a part of a different group than the source  snapshot (by default, cloned subvolumes are created in default group).  To clone to a particular group use:

```
$ ceph fs subvolume snapshot clone <vol_name> <subvol_name> <snap_name> <target_subvol_name> --target_group_name <subvol_group_name>
```

Similar to specifying a pool layout when creating a subvolume, pool  layout can be specified when creating a cloned subvolume. To create a  cloned subvolume with a specific pool layout use:

```
$ ceph fs subvolume snapshot clone <vol_name> <subvol_name> <snap_name> <target_subvol_name> --pool_layout <pool_layout>
```

Configure maximum number of concurrent clones. The default is set to 4:

```
$ ceph config set mgr mgr/volumes/max_concurrent_clones <value>
```

To check the status of a clone operation use:

```
$ ceph fs clone status <vol_name> <clone_name> [--group_name <group_name>]
```

A clone can be in one of the following states:

1. pending     : Clone operation has not started
2. in-progress : Clone operation is in progress
3. complete    : Clone operation has successfully finished
4. failed      : Clone operation has failed
5. canceled    : Clone operation is cancelled by user

The reason for a clone failure is shown as below:

1. errno     : error number
2. error_msg : failure error string

Sample output of an in-progress clone operation:

```
$ ceph fs subvolume snapshot clone cephfs subvol1 snap1 clone1
$ ceph fs clone status cephfs clone1
{
  "status": {
    "state": "in-progress",
    "source": {
      "volume": "cephfs",
      "subvolume": "subvol1",
      "snapshot": "snap1"
    }
  }
}
```

Note

The failure section will be shown only if the clone is in failed or cancelled state

Sample output of a failed clone operation:

```
$ ceph fs subvolume snapshot clone cephfs subvol1 snap1 clone1
$ ceph fs clone status cephfs clone1
{
  "status": {
    "state": "failed",
    "source": {
      "volume": "cephfs",
      "subvolume": "subvol1",
      "snapshot": "snap1"
      "size": "104857600"
    },
    "failure": {
      "errno": "122",
      "errstr": "Disk quota exceeded"
    }
  }
}
```

(NOTE: since subvol1 is in default group, source section in clone status does not include group name)

Note

Cloned subvolumes are accessible only after the clone operation has successfully completed.

For a successful clone operation, clone status would look like so:

```
$ ceph fs clone status cephfs clone1
{
  "status": {
    "state": "complete"
  }
}
```

or failed state when clone is unsuccessful.

On failure of a clone operation, the partial clone needs to be deleted and the clone operation needs to be retriggered. To delete a partial clone use:

```
$ ceph fs subvolume rm <vol_name> <clone_name> [--group_name <group_name>] --force
```

Note

Cloning only synchronizes directories, regular files and symbolic links. Also, inode timestamps (access and modification times) are synchronized up to seconds granularity.

An in-progress or a pending clone operation can be canceled. To cancel a clone operation use the clone cancel command:

```
$ ceph fs clone cancel <vol_name> <clone_name> [--group_name <group_name>]
```

On successful cancellation, the cloned subvolume is moved to canceled state:

```
$ ceph fs subvolume snapshot clone cephfs subvol1 snap1 clone1
$ ceph fs clone cancel cephfs clone1
$ ceph fs clone status cephfs clone1
{
  "status": {
    "state": "canceled",
    "source": {
      "volume": "cephfs",
      "subvolume": "subvol1",
      "snapshot": "snap1"
    }
  }
}
```

Note

The canceled cloned can be deleted by using --force option in fs subvolume rm command.



## Pinning Subvolumes and Subvolume Groups[](https://docs.ceph.com/en/latest/cephfs/fs-volumes/#pinning-subvolumes-and-subvolume-groups)

Subvolumes and subvolume groups can be automatically pinned to ranks according to policies. This can help distribute load across MDS ranks in predictable and stable ways.  Review [Manually pinning directory trees to a particular rank](https://docs.ceph.com/en/latest/cephfs/multimds/#cephfs-pinning) and [Setting subtree partitioning policies](https://docs.ceph.com/en/latest/cephfs/multimds/#cephfs-ephemeral-pinning) for details on how pinning works.

Pinning is configured by:

```
$ ceph fs subvolumegroup pin <vol_name> <group_name> <pin_type> <pin_setting>
```

or for subvolumes:

```
$ ceph fs subvolume pin <vol_name> <group_name> <pin_type> <pin_setting>
```

Typically you will want to set subvolume group pins. The `pin_type` may be one of `export`, `distributed`, or `random`. The `pin_setting` corresponds to the extended attributed “value” as in the pinning documentation referenced above.

So, for example, setting a distributed pinning strategy on a subvolume group:

```
$ ceph fs subvolumegroup pin cephfilesystem-a csi distributed 1
```

Will enable distributed subtree partitioning policy for the “csi” subvolume group.  This will cause every subvolume within the group to be automatically pinned to one of the available ranks on the file system.

# Quotas[](https://docs.ceph.com/en/latest/cephfs/quota/#quotas)

CephFS allows quotas to be set on any directory in the system.  The quota can restrict the number of *bytes* or the number of *files* stored beneath that point in the directory hierarchy.

## Limitations[](https://docs.ceph.com/en/latest/cephfs/quota/#limitations)

1. *Quotas are cooperative and non-adversarial.* CephFS quotas rely on the cooperation of the client who is mounting the file system to stop writers when a limit is reached.  A modified or adversarial client cannot be prevented from writing as much data as it needs. Quotas should not be relied on to prevent filling the system in environments where the clients are fully untrusted.

2. *Quotas are imprecise.* Processes that are writing to the file system will be stopped a short time after the quota limit is reached.  They will inevitably be allowed to write some amount of data over the configured limit.  How far over the quota they are able to go depends primarily on the amount of time, not the amount of data.  Generally speaking writers will be stopped within 10s of seconds of crossing the configured limit.

3. *Quotas are implemented in the kernel client 4.17 and higher.* Quotas are supported by the userspace client (libcephfs, ceph-fuse). Linux kernel clients >= 4.17 support CephFS quotas but only on mimic+ clusters.  Kernel clients (even recent versions) will fail to handle quotas on older clusters, even if they may be able to set the quotas extended attributes.

4. *Quotas must be configured carefully when used with path-based mount restrictions.* The client needs to have access to the directory inode on which quotas are configured in order to enforce them.  If the client has restricted access to a specific path (e.g., `/home/user`) based on the MDS capability, and a quota is configured on an ancestor directory they do not have access to (e.g., `/home`), the client will not enforce it.  When using path-based access restrictions be sure to configure the quota on the directory the client is restricted too (e.g., `/home/user`) or something nested beneath it.

   In case of a kernel client, it needs to have access to the parent of the directory inode on which quotas are configured in order to enforce them. If quota is configured on a directory path (e.g., `/home/volumes/group`), the kclient needs to have access to the parent (e.g., `/home/volumes`).

   An example command to create such an user is as below:

   ```
   $ ceph auth get-or-create client.guest mds 'allow r path=/home/volumes, allow rw path=/home/volumes/group' mgr 'allow rw' osd 'allow rw tag cephfs metadata=*' mon 'allow r'
   ```

   See also: https://tracker.ceph.com/issues/55090

5. *Snapshot file data which has since been deleted or changed does not count towards the quota.* See also: http://tracker.ceph.com/issues/24284

## Configuration[](https://docs.ceph.com/en/latest/cephfs/quota/#configuration)

Like most other things in CephFS, quotas are configured using virtual extended attributes:

> - `ceph.quota.max_files` -- file limit
> - `ceph.quota.max_bytes` -- byte limit

If the attributes appear on a directory inode that means a quota is configured there.  If they are not present then no quota is set on that directory (although one may still be configured on a parent directory).

To set a quota:

```
setfattr -n ceph.quota.max_bytes -v 100000000 /some/dir     # 100 MB
setfattr -n ceph.quota.max_files -v 10000 /some/dir         # 10,000 files
```

To view quota settings:

```
getfattr -n ceph.quota.max_bytes /some/dir
getfattr -n ceph.quota.max_files /some/dir
```

Note that if the value of the extended attribute is `0` that means the quota is not set.

To remove a quota:

```
setfattr -n ceph.quota.max_bytes -v 0 /some/dir
setfattr -n ceph.quota.max_files -v 0 /some/dir
```

# CephFS health messages[](https://docs.ceph.com/en/latest/cephfs/health-messages/#cephfs-health-messages)

## Cluster health checks[](https://docs.ceph.com/en/latest/cephfs/health-messages/#cluster-health-checks)

The Ceph monitor daemons will generate health messages in response to certain states of the file system map structure (and the enclosed MDS maps).

Message: mds rank(s) *ranks* have failed Description: One or more MDS ranks are not currently assigned to an MDS daemon; the cluster will not recover until a suitable replacement daemon starts.

Message: mds rank(s) *ranks* are damaged Description: One or more MDS ranks has encountered severe damage to its stored metadata, and cannot start again until it is repaired.

Message: mds cluster is degraded Description: One or more MDS ranks are not currently up and running, clients may pause metadata IO until this situation is resolved.  This includes ranks being failed or damaged, and additionally includes ranks which are running on an MDS but have not yet made it to the *active* state (e.g. ranks currently in *replay* state).

Message: mds *names* are laggy Description: The named MDS daemons have failed to send beacon messages to the monitor for at least `mds_beacon_grace` (default 15s), while they are supposed to send beacon messages every `mds_beacon_interval` (default 4s).  The daemons may have crashed.  The Ceph monitor will automatically replace laggy daemons with standbys if any are available.

Message: insufficient standby daemons available Description: One or more file systems are configured to have a certain number of standby daemons available (including daemons in standby-replay) but the cluster does not have enough standby daemons. The standby daemons not in replay count towards any file system (i.e. they may overlap). This warning can configured by setting `ceph fs set <fs> standby_count_wanted <count>`.  Use zero for `count` to disable.

## Daemon-reported health checks[](https://docs.ceph.com/en/latest/cephfs/health-messages/#daemon-reported-health-checks)

MDS daemons can identify a variety of unwanted conditions, and indicate these to the operator in the output of `ceph status`. These conditions have human readable messages, and additionally a unique code starting with `MDS_`.

`ceph health detail` shows the details of the conditions. Following is a typical health report from a cluster experiencing MDS related performance issues:

```
ceph health detail
HEALTH_WARN 1 MDSs report slow metadata IOs; 1 MDSs report slow requests
MDS_SLOW_METADATA_IO 1 MDSs report slow metadata IOs
   mds.fs-01(mds.0): 3 slow metadata IOs are blocked > 30 secs, oldest blocked for 51123 secs
MDS_SLOW_REQUEST 1 MDSs report slow requests
   mds.fs-01(mds.0): 5 slow requests are blocked > 30 secs
```

Where, for instance, `MDS_SLOW_REQUEST` is the unique code representing the condition where requests are taking long time to complete. And the following description shows its severity and the MDS daemons which are serving these slow requests.

This page lists the health checks raised by MDS daemons. For the checks from other daemons, please see [Health checks](https://docs.ceph.com/en/latest/rados/operations/health-checks/#health-checks).

### `MDS_TRIM`[](https://docs.ceph.com/en/latest/cephfs/health-messages/#mds-trim)

> - Message
>
>   “Behind on trimming…”
>
> - Description
>
>   CephFS maintains a metadata journal that is divided into *log segments*.  The length of journal (in number of segments) is controlled by the setting `mds_log_max_segments`, and when the number of segments exceeds that setting the MDS starts writing back metadata so that it can remove (trim) the oldest segments.  If this writeback is happening too slowly, or a software bug is preventing trimming, then this health message may appear.  The threshold for this message to appear is controlled by the config option `mds_log_warn_factor`, the default is 2.0.

### `MDS_HEALTH_CLIENT_LATE_RELEASE`, `MDS_HEALTH_CLIENT_LATE_RELEASE_MANY`[](https://docs.ceph.com/en/latest/cephfs/health-messages/#mds-health-client-late-release-mds-health-client-late-release-many)

> - Message
>
>   “Client *name* failing to respond to capability release”
>
> - Description
>
>   CephFS clients are issued *capabilities* by the MDS, which are like locks.  Sometimes, for example when another client needs access, the MDS will request clients release their capabilities.  If the client is unresponsive or buggy, it might fail to do so promptly or fail to do so at all.  This message appears if a client has taken longer than `session_timeout` (default 60s) to comply.

### `MDS_CLIENT_RECALL`, `MDS_HEALTH_CLIENT_RECALL_MANY`[](https://docs.ceph.com/en/latest/cephfs/health-messages/#mds-client-recall-mds-health-client-recall-many)

> - Message
>
>   “Client *name* failing to respond to cache pressure”
>
> - Description
>
>   Clients maintain a metadata cache.  Items (such as inodes) in the client cache are also pinned in the MDS cache, so when the MDS needs to shrink its cache (to stay within `mds_cache_memory_limit`), it sends messages to clients to shrink their caches too.  If the client is unresponsive or buggy, this can prevent the MDS from properly staying within its cache limits and it may eventually run out of memory and crash.  This message appears if a client has failed to release more than `mds_recall_warning_threshold` capabilities (decaying with a half-life of `mds_recall_max_decay_rate`) within the last `mds_recall_warning_decay_rate` second.

### `MDS_CLIENT_OLDEST_TID`, `MDS_CLIENT_OLDEST_TID_MANY`[](https://docs.ceph.com/en/latest/cephfs/health-messages/#mds-client-oldest-tid-mds-client-oldest-tid-many)

> - Message
>
>   “Client *name* failing to advance its oldest client/flush tid”
>
> - Description
>
>   The CephFS client-MDS protocol uses a field called the *oldest tid* to inform the MDS of which client requests are fully complete and may therefore be forgotten about by the MDS.  If a buggy client is failing to advance this field, then the MDS may be prevented from properly cleaning up resources used by client requests.  This message appears if a client appears to have more than `max_completed_requests` (default 100000) requests that are complete on the MDS side but haven’t yet been accounted for in the client’s *oldest tid* value.

### `MDS_DAMAGE`[](https://docs.ceph.com/en/latest/cephfs/health-messages/#mds-damage)

> - Message
>
>   “Metadata damage detected”
>
> - Description
>
>   Corrupt or missing metadata was encountered when reading from the metadata pool.  This message indicates that the damage was sufficiently isolated for the MDS to continue operating, although client accesses to the damaged subtree will return IO errors.  Use the `damage ls` admin socket command to get more detail on the damage. This message appears as soon as any damage is encountered.

### `MDS_HEALTH_READ_ONLY`[](https://docs.ceph.com/en/latest/cephfs/health-messages/#mds-health-read-only)

> - Message
>
>   “MDS in read-only mode”
>
> - Description
>
>   The MDS has gone into readonly mode and will return EROFS error codes to client operations that attempt to modify any metadata.  The MDS will go into readonly mode if it encounters a write error while writing to the metadata pool, or if forced to by an administrator using the *force_readonly* admin socket command.

### `MDS_SLOW_REQUEST`[](https://docs.ceph.com/en/latest/cephfs/health-messages/#mds-slow-request)

> - Message
>
>   “*N* slow requests are blocked”
>
> - Description
>
>   One or more client requests have not been completed promptly, indicating that the MDS is either running very slowly, or that the RADOS cluster is not acknowledging journal writes promptly, or that there is a bug. Use the `ops` admin socket command to list outstanding metadata operations. This message appears if any client requests have taken longer than `mds_op_complaint_time` (default 30s).

### `MDS_CACHE_OVERSIZED`[](https://docs.ceph.com/en/latest/cephfs/health-messages/#mds-cache-oversized)

> - Message
>
>   “Too many inodes in cache”
>
> - Description
>
>   The MDS is not succeeding in trimming its cache to comply with the limit set by the administrator.  If the MDS cache becomes too large, the daemon may exhaust available memory and crash.  By default, this message appears if the actual cache size (in memory) is at least 50% greater than `mds_cache_memory_limit` (default 4GB). Modify `mds_health_cache_threshold` to set the warning ratio.

### `FS_WITH_FAILED_MDS`[](https://docs.ceph.com/en/latest/cephfs/health-messages/#fs-with-failed-mds)

> - Message
>
>   “Some MDS ranks do not have standby replacements”
>
> - Description
>
>   Normally, a failed MDS rank will be replaced by a standby MDS. This situation is transient and is not considered critical. However, if there are no standby MDSs available to replace an active MDS rank, this health warning is generated.

### `MDS_INSUFFICIENT_STANDBY`[](https://docs.ceph.com/en/latest/cephfs/health-messages/#mds-insufficient-standby)

> - Message
>
>   “Insufficient number of available standby(-replay) MDS daemons than configured”
>
> - Description
>
>   The minimum number of standby(-replay) MDS daemons can be configured by setting `standby_count_wanted` configuration variable. This health warning is generated when the configured value mismatches the number of standby(-replay) MDS daemons available.

### `FS_DEGRADED`[](https://docs.ceph.com/en/latest/cephfs/health-messages/#fs-degraded)

> - Message
>
>   “Some MDS ranks have been marked failed or damaged”
>
> - Description
>
>   When one or more MDS rank ends up in failed or damaged state due to an unrecoverable error. The file system may be partially or fully unavailable when one (or more) ranks are offline.

### `MDS_UP_LESS_THAN_MAX`[](https://docs.ceph.com/en/latest/cephfs/health-messages/#mds-up-less-than-max)

> - Message
>
>   “Number of active ranks are less than configured number of maximum MDSs”
>
> - Description
>
>   The maximum number of MDS ranks can be configured by setting `max_mds` configuration variable. This health warning is generated when the number of MDS ranks falls below this configured value.

### `MDS_ALL_DOWN`[](https://docs.ceph.com/en/latest/cephfs/health-messages/#mds-all-down)

> - Message
>
>   “None of the MDS ranks are available (file system offline)”
>
> - Description
>
>   All MDS ranks are unavailable resulting in the file system to be completely offline.

​        

# Upgrading the MDS Cluster[](https://docs.ceph.com/en/latest/cephfs/upgrading/#upgrading-the-mds-cluster)

Currently the MDS cluster does not have built-in versioning or file system flags to support seamless upgrades of the MDSs without potentially causing assertions or other faults due to incompatible messages or other functional differences. For this reason, it’s necessary during any cluster upgrade to reduce the number of active MDS for a file system to one first so that two active MDS do not communicate with different versions.

The proper sequence for upgrading the MDS cluster is:

1. For each file system, disable and stop standby-replay daemons.

```
ceph fs set <fs_name> allow_standby_replay false
```

In Pacific, the standby-replay daemons are stopped for you after running this command. Older versions of Ceph require you to stop these daemons manually.

```
ceph fs dump # find standby-replay daemons
ceph mds fail mds.<X>
```

1. For each file system, reduce the number of ranks to 1:

```
ceph fs set <fs_name> max_mds 1
```

1. Wait for cluster to stop non-zero ranks where only rank 0 is active and the rest are standbys.

```
ceph status # wait for MDS to finish stopping
```

1. For each MDS, upgrade packages and restart. Note: to reduce failovers, it is recommended -- but not strictly necessary -- to first upgrade standby daemons.

```
# use package manager to update cluster
systemctl restart ceph-mds.target
```

1. For each file system, restore the previous max_mds and allow_standby_replay settings for your cluster:

```
ceph fs set <fs_name> max_mds <old_max_mds>
ceph fs set <fs_name> allow_standby_replay <old_allow_standby_replay>
```

# Upgrading pre-Firefly file systems past Jewel[](https://docs.ceph.com/en/latest/cephfs/upgrading/#upgrading-pre-firefly-file-systems-past-jewel)

Tip

This advice only applies to users with file systems created using versions of Ceph older than *Firefly* (0.80). Users creating new file systems may disregard this advice.

Pre-firefly versions of Ceph used a now-deprecated format for storing CephFS directory objects, called TMAPs.  Support for reading these in RADOS will be removed after the Jewel release of Ceph, so for upgrading CephFS users it is important to ensure that any old directory objects have been converted.

After installing Jewel on all your MDS and OSD servers, and restarting the services, run the following command:

```
cephfs-data-scan tmap_upgrade <metadata pool name>
```

This only needs to be run once, and it is not necessary to stop any other services while it runs.  The command may take some time to execute, as it iterates overall objects in your metadata pool.  It is safe to continue using your file system as normal while it executes.  If the command aborts for any reason, it is safe to simply run it again.

If you are upgrading a pre-Firefly CephFS file system to a newer Ceph version than Jewel, you must first upgrade to Jewel and run the `tmap_upgrade` command before completing your upgrade to the latest version.

# CephFS Top Utility[](https://docs.ceph.com/en/latest/cephfs/cephfs-top/#cephfs-top-utility)

CephFS provides top(1) like utility to display various Ceph Filesystem metrics in realtime. cephfs-top is a curses based python script which makes use of stats plugin in Ceph Manager to fetch (and display) metrics.

## Manager Plugin[](https://docs.ceph.com/en/latest/cephfs/cephfs-top/#manager-plugin)

Ceph Filesystem clients periodically forward various metrics to Ceph Metadata Servers (MDS) which in turn get forwarded to Ceph Manager by MDS rank zero. Each active MDS forward its respective set of metrics to MDS rank zero. Metrics are aggregated and forwarded to Ceph Manager.

Metrics are divided into two categories - global and per-mds. Global metrics represent set of metrics for the filesystem as a whole (e.g., client read latency) whereas per-mds metrics are for a particular MDS rank (e.g., number of subtrees handled by an MDS).

Note

Currently, only global metrics are tracked.

stats plugin is disabled by default and should be enabled via:

```
$ ceph mgr module enable stats
```

Once enabled, Ceph Filesystem metrics can be fetched via:

```
$ ceph fs perf stats
{"version": 1, "global_counters": ["cap_hit", "read_latency", "write_latency", "metadata_latency", "dentry_lease", "opened_files", "pinned_icaps", "opened_inodes", "avg_read_latency", "stdev_read_latency", "avg_write_latency", "stdev_write_latency", "avg_metadata_latency", "stdev_metadata_latency"], "counters": [], "client_metadata": {"client.324130": {"IP": "192.168.1.100", "hostname": "ceph-host1", "root": "/", "mount_point": "/mnt/cephfs", "valid_metrics": ["cap_hit", "read_latency", "write_latency", "metadata_latency", "dentry_lease, "opened_files", "pinned_icaps", "opened_inodes", "avg_read_latency", "stdev_read_latency", "avg_write_latency", "stdev_write_latency", "avg_metadata_latency", "stdev_metadata_latency"]}}, "global_metrics": {"client.324130": [[309785, 1280], [0, 0], [197, 519015022], [88, 279074768], [12, 70147], [0, 3], [3, 3], [0, 3], [0, 0], [0, 0], [0, 11699223], [0, 88245], [0, 6596951], [0, 9539]]}, "metrics": {"delayed_ranks": [], "mds.0": {"client.324130": []}}}
```

Details of the JSON command output are as follows:

- version: Version of stats output
- global_counters: List of global performance metrics
- counters: List of per-mds performance metrics
- client_metadata: Ceph Filesystem client metadata
- global_metrics: Global performance counters
- metrics: Per-MDS performance counters (currently, empty) and delayed ranks

Note

delayed_ranks is the set of active MDS ranks that are reporting stale metrics. This can happen in cases such as (temporary) network issue between MDS rank zero and other active MDSs.

Metrics can be fetched for a particular client and/or for a set of active MDSs. To fetch metrics for a particular client (e.g., for client-id: 1234):

```
$ ceph fs perf stats --client_id=1234
```

To fetch metrics only for a subset of active MDSs (e.g., MDS rank 1 and 2):

```
$ ceph fs perf stats --mds_rank=1,2
```

## cephfs-top[](https://docs.ceph.com/en/latest/cephfs/cephfs-top/#id1)

cephfs-top utility relies on stats plugin to fetch performance metrics and display in top(1) like format. cephfs-top is available as part of cephfs-top package.

By default, cephfs-top uses client.fstop user to connect to a Ceph cluster:

```
$ ceph auth get-or-create client.fstop mon 'allow r' mds 'allow r' osd 'allow r' mgr 'allow r'
$ cephfs-top
```

To use a non-default user (other than client.fstop) use:

```
$ cephfs-top --id <name>
```

By default, cephfs-top connects to cluster name ceph. To use a non-default cluster name:

```
$ cephfs-top --cluster <cluster>
```

cephfs-top refreshes stats every second by default. To choose a different refresh interval use:

```
$ cephfs-top -d <seconds>
```

Interval should be greater than or equal to 0.5 seconds. Fractional seconds are honoured.

Sample screenshot running cephfs-top with 2 clients:

![../../_images/cephfs-top.png](https://docs.ceph.com/en/latest/_images/cephfs-top.png)

Note

As of now, cephfs-top does not reliably work with multiple Ceph Filesystems.

# Snapshot Scheduling Module[](https://docs.ceph.com/en/latest/cephfs/snap-schedule/#snapshot-scheduling-module)

This module implements scheduled snapshots for CephFS. It provides a user interface to add, query and remove snapshots schedules and retention policies, as well as a scheduler that takes the snapshots and prunes existing snapshots accordingly.

## How to enable[](https://docs.ceph.com/en/latest/cephfs/snap-schedule/#how-to-enable)

The *snap_schedule* module is enabled with:

```
ceph mgr module enable snap_schedule
```

## Usage[](https://docs.ceph.com/en/latest/cephfs/snap-schedule/#usage)

This module uses [CephFS Snapshots](https://docs.ceph.com/en/latest/dev/cephfs-snapshots/), please consider this documentation as well.

This module’s subcommands live under the ceph fs snap-schedule namespace. Arguments can either be supplied as positional arguments or as keyword arguments. Once a keyword argument was encountered, all following arguments are assumed to be keyword arguments too.

Snapshot schedules are identified by path, their repeat interval and their start time. The repeat interval defines the time between two subsequent snapshots. It is specified by a number and a period multiplier, one of h(our), d(ay) and w(eek). E.g. a repeat interval of 12h specifies one snapshot every 12 hours. The start time is specified as a time string (more details about passing times below). By default the start time is last midnight. So when a snapshot schedule with repeat interval 1h is added at 13:50 with the default start time, the first snapshot will be taken at 14:00.

Retention specifications are identified by path and the retention spec itself. A retention spec consists of either a number and a time period separated by a space or concatenated pairs of <number><time period>. The semantics are that a spec will ensure <number> snapshots are kept that are at least <time period> apart. For Example 7d means the user wants to keep 7 snapshots that are at least one day (but potentially longer) apart from each other. The following time periods are recognized: h(our), d(ay), w(eek), m(onth), y(ear) and n. The latter is a special modifier where e.g. 10n means keep the last 10 snapshots regardless of timing,

All subcommands take optional fs argument to specify paths in multi-fs setups and [FS volumes and subvolumes](https://docs.ceph.com/en/latest/cephfs/fs-volumes/) managed setups. If not passed fs defaults to the first file system listed in the fs_map. When using [FS volumes and subvolumes](https://docs.ceph.com/en/latest/cephfs/fs-volumes/) the argument fs is equivalent to a volume.

When a timestamp is passed (the start argument in the add, remove, activate and deactivate subcommands) the ISO format %Y-%m-%dT%H:%M:%S will always be accepted. When either python3.7 or newer is used or https://github.com/movermeyer/backports.datetime_fromisoformat is installed, any valid ISO timestamp that is parsed by python’s datetime.fromisoformat is valid.

When no subcommand is supplied a synopsis is printed:

```
#> ceph fs snap-schedule
no valid command found; 8 closest matches:
fs snap-schedule status [<path>] [<fs>] [<format>]
fs snap-schedule list <path> [--recursive] [<fs>] [<format>]
fs snap-schedule add <path> <snap_schedule> [<start>] [<fs>]
fs snap-schedule remove <path> [<repeat>] [<start>] [<fs>]
fs snap-schedule retention add <path> <retention_spec_or_period> [<retention_count>] [<fs>]
fs snap-schedule retention remove <path> <retention_spec_or_period> [<retention_count>] [<fs>]
fs snap-schedule activate <path> [<repeat>] [<start>] [<fs>]
fs snap-schedule deactivate <path> [<repeat>] [<start>] [<fs>]
Error EINVAL: invalid command
```

### Note:[](https://docs.ceph.com/en/latest/cephfs/snap-schedule/#note)

A subvolume argument is no longer accepted by the commands.

#### Inspect snapshot schedules[](https://docs.ceph.com/en/latest/cephfs/snap-schedule/#inspect-snapshot-schedules)

The module offers two subcommands to inspect existing schedules: list and status. Bother offer plain and json output via the optional format argument. The default is plain. The list sub-command will list all schedules on a path in a short single line format. It offers a recursive argument to list all schedules in the specified directory and all contained directories. The status subcommand prints all available schedules and retention specs for a path.

Examples:

```
ceph fs snap-schedule status /
ceph fs snap-schedule status /foo/bar --format=json
ceph fs snap-schedule list /
ceph fs snap-schedule list / --recursive=true # list all schedules in the tree
```

#### Add and remove schedules[](https://docs.ceph.com/en/latest/cephfs/snap-schedule/#add-and-remove-schedules)

The add and remove subcommands add and remove snapshots schedules respectively. Both require at least a path argument, add additionally requires a schedule argument as described in the USAGE section.

Multiple different schedules can be added to a path. Two schedules are considered different from each other if they differ in their repeat interval and their start time.

If multiple schedules have been set on a path, remove can remove individual schedules on a path by specifying the exact repeat interval and start time, or the subcommand can remove all schedules on a path when just a path is specified.

Examples:

```
ceph fs snap-schedule add / 1h
ceph fs snap-schedule add / 1h 11:55
ceph fs snap-schedule add / 2h 11:55
ceph fs snap-schedule remove / 1h 11:55 # removes one single schedule
ceph fs snap-schedule remove / 1h # removes all schedules with --repeat=1h
ceph fs snap-schedule remove / # removes all schedules on path /
```

#### Add and remove retention policies[](https://docs.ceph.com/en/latest/cephfs/snap-schedule/#add-and-remove-retention-policies)

The retention add and retention remove subcommands allow to manage retention policies. One path has exactly one retention policy. A policy can however contain multiple count-time period pairs in order to specify complex retention policies. Retention policies can be added and removed individually or in bulk via the forms ceph fs snap-schedule retention add <path> <time period> <count> and ceph fs snap-schedule retention add <path> <countTime period>[countTime period]

Examples:

```
ceph fs snap-schedule retention add / h 24 # keep 24 snapshots at least an hour apart
ceph fs snap-schedule retention add / d 7 # and 7 snapshots at least a day apart
ceph fs snap-schedule retention remove / h 24 # remove retention for 24 hourlies
ceph fs snap-schedule retention add / 24h4w # add 24 hourly and 4 weekly to retention
ceph fs snap-schedule retention remove / 7d4w # remove 7 daily and 4 weekly, leaves 24 hourly
```

#### Active and inactive schedules[](https://docs.ceph.com/en/latest/cephfs/snap-schedule/#active-and-inactive-schedules)

Snapshot schedules can be added for a path that doesn’t exist yet in the directory tree. Similarly a path can be removed without affecting any snapshot schedules on that path. If a directory is not present when a snapshot is scheduled to be taken, the schedule will be set to inactive and will be excluded from scheduling until it is activated again. A schedule can manually be set to inactive to pause the creating of scheduled snapshots. The module provides the activate and deactivate subcommands for this purpose.

Examples:

```
ceph fs snap-schedule activate / # activate all schedules on the root directory
ceph fs snap-schedule deactivate / 1d # deactivates daily snapshots on the root directory
```

#### Limitations[](https://docs.ceph.com/en/latest/cephfs/snap-schedule/#limitations)

Snapshots are scheduled using python Timers. Under normal circumstances specifying 1h as the schedule will result in snapshots 1 hour apart fairly precisely. If the mgr daemon is under heavy load however, the Timer threads might not get scheduled right away, resulting in a slightly delayed snapshot. If this happens, the next snapshot will be schedule as if the previous one was not delayed, i.e. one or more delayed snapshots will not cause drift in the overall schedule.

In order to somewhat limit the overall number of snapshots in a file system, the module will only keep a maximum of 50 snapshots per directory. If the retention policy results in more then 50 retained snapshots, the retention list will be shortened to the newest 50 snapshots.

#### Data storage[](https://docs.ceph.com/en/latest/cephfs/snap-schedule/#data-storage)

The snapshot schedule data is stored in a rados object in the cephfs metadata pool. At runtime all data lives in a sqlite database that is serialized and stored as a rados object.

​        

# CephFS Snapshot Mirroring[](https://docs.ceph.com/en/latest/cephfs/cephfs-mirroring/#cephfs-snapshot-mirroring)

CephFS supports asynchronous replication of snapshots to a remote CephFS file system via the cephfs-mirror tool. Snapshots are synchronized by mirroring snapshot data followed by creating a remote snapshot with the same name (for a given directory on the remote file system) as the source snapshot.

## Requirements[](https://docs.ceph.com/en/latest/cephfs/cephfs-mirroring/#requirements)

The primary (local) and secondary (remote) Ceph clusters version should be Pacific or later.

## Creating Users[](https://docs.ceph.com/en/latest/cephfs/cephfs-mirroring/#creating-users)

Start by creating a Ceph user (on the primary/local cluster) for the cephfs-mirror daemon. This user requires write capability on the metadata pool to create RADOS objects (index objects) for watch/notify operation and read capability on the data pool(s):

```
$ ceph auth get-or-create client.mirror mon 'profile cephfs-mirror' mds 'allow r' osd 'allow rw tag cephfs metadata=*, allow r tag cephfs data=*' mgr 'allow r'
```

Create a Ceph user for each file system peer (on the secondary/remote cluster). This user needs to have full capabilities on the MDS (to take snapshots) and the OSDs:

```
$ ceph fs authorize <fs_name> client.mirror_remote / rwps
```

This user will be supplied as part of the peer specification when adding a peer.

## Starting Mirror Daemon[](https://docs.ceph.com/en/latest/cephfs/cephfs-mirroring/#starting-mirror-daemon)

The mirror daemon should be spawned using systemctl(1) unit files:

```
$ systemctl enable cephfs-mirror@mirror
$ systemctl start cephfs-mirror@mirror
```

cephfs-mirror daemon can be run in foreground using:

```
$ cephfs-mirror --id mirror --cluster site-a -f
```

Note

The user specified here is mirror created in the Creating Users section.

## Interface[](https://docs.ceph.com/en/latest/cephfs/cephfs-mirroring/#interface)

The Mirroring module (manager plugin) provides interfaces for managing directory snapshot mirroring. These are (mostly) wrappers around monitor commands for managing file system mirroring and is the recommended control interface.

## Mirroring Module[](https://docs.ceph.com/en/latest/cephfs/cephfs-mirroring/#mirroring-module)

The mirroring module is responsible for assigning directories to mirror daemons for synchronization. Multiple mirror daemons can be spawned to achieve concurrency in directory snapshot synchronization. When mirror daemons are spawned (or terminated), the mirroring module discovers the modified set of mirror daemons and rebalances directory assignments across the new set, thus providing high-availability.

Note

Deploying a single mirror daemon is recommended; running multiple daemons is untested.

The mirroring module is disabled by default. To enable the mirroring module:

```
$ ceph mgr module enable mirroring
```

The mirroring module provides a family of commands to control mirroring of directory snapshots. To add or remove directories, mirroring needs to be enabled for a given file system. To enable mirroring for a given file system:

```
$ ceph fs snapshot mirror enable <fs_name>
```

Note

Mirroring module commands are prefixed with fs snapshot mirror as compared to monitor commands which are prefixed with fs mirror. Be sure to use module commands.

To disable mirroring for a given file system:

```
$ ceph fs snapshot mirror disable <fs_name>
```

Once mirroring is enabled, add a peer to which directory snapshots are to be mirrored. Peers are specified by <client>@<cluster> and are assigned a unique-id (UUID) when added. See Creating Users section on how to create Ceph users for mirroring.

To add a peer use:

```
$ ceph fs snapshot mirror peer_add <fs_name> <remote_cluster_spec> [<remote_fs_name>] [<remote_mon_host>] [<cephx_key>]
```

<remote_fs_name> is optional, and defaults to <fs_name> (on the remote cluster).

This requires the remote cluster ceph configuration and user keyring to be available in the primary cluster. See Bootstrap Peers section to avoid this. peer_add additionally supports passing the remote cluster monitor address and the user key. However, bootstrapping a peer is the recommended way to add a peer.

Note

Only a single peer is currently supported.

To remove a peer use:

```
$ ceph fs snapshot mirror peer_remove <fs_name> <peer_uuid>
```

To list file system mirror peers use:

```
$ ceph fs snapshot mirror peer_list <fs_name>
```

To configure a directory for mirroring, use:

```
$ ceph fs snapshot mirror add <fs_name> <path>
```

To stop a mirroring directory snapshots use:

```
$ ceph fs snapshot mirror remove <fs_name> <path>
```

Only absolute directory paths are allowed. Also, paths are normalized by the mirroring module, therefore, /a/b/../b is equivalent to /a/b.

> $ mkdir -p /d0/d1/d2 $ ceph fs snapshot mirror add cephfs /d0/d1/d2 {} $ ceph fs snapshot mirror add cephfs /d0/d1/../d1/d2 Error EEXIST: directory /d0/d1/d2 is already tracked

Once a directory is added for mirroring, additional mirroring of subdirectories or ancestor directories is disallowed:

```
$ ceph fs snapshot mirror add cephfs /d0/d1
Error EINVAL: /d0/d1 is a ancestor of tracked path /d0/d1/d2
$ ceph fs snapshot mirror add cephfs /d0/d1/d2/d3
Error EINVAL: /d0/d1/d2/d3 is a subtree of tracked path /d0/d1/d2
```

Commands to check directory mapping (to mirror daemons) and directory distribution are detailed in Mirroring Status section.

## Bootstrap Peers[](https://docs.ceph.com/en/latest/cephfs/cephfs-mirroring/#bootstrap-peers)

Adding a peer (via peer_add) requires the peer cluster configuration and user keyring to be available in the primary cluster (manager host and hosts running the mirror daemon). This can be avoided by bootstrapping and importing a peer token. Peer bootstrap involves creating a bootstrap token on the peer cluster via:

```
$ ceph fs snapshot mirror peer_bootstrap create <fs_name> <client_entity> <site-name>
```

e.g.:

```
$ ceph fs snapshot mirror peer_bootstrap create backup_fs client.mirror_remote site-remote
{"token": "eyJmc2lkIjogIjBkZjE3MjE3LWRmY2QtNDAzMC05MDc5LTM2Nzk4NTVkNDJlZiIsICJmaWxlc3lzdGVtIjogImJhY2t1cF9mcyIsICJ1c2VyIjogImNsaWVudC5taXJyb3JfcGVlcl9ib290c3RyYXAiLCAic2l0ZV9uYW1lIjogInNpdGUtcmVtb3RlIiwgImtleSI6ICJBUUFhcDBCZ0xtRmpOeEFBVnNyZXozai9YYUV0T2UrbUJEZlJDZz09IiwgIm1vbl9ob3N0IjogIlt2MjoxOTIuMTY4LjAuNTo0MDkxOCx2MToxOTIuMTY4LjAuNTo0MDkxOV0ifQ=="}
```

site-name refers to a user-defined string to identify the remote filesystem. In context of peer_add interface, site-name is the passed in cluster name from remote_cluster_spec.

Import the bootstrap token in the primary cluster via:

```
$ ceph fs snapshot mirror peer_bootstrap import <fs_name> <token>
```

e.g.:

```
$ ceph fs snapshot mirror peer_bootstrap import cephfs eyJmc2lkIjogIjBkZjE3MjE3LWRmY2QtNDAzMC05MDc5LTM2Nzk4NTVkNDJlZiIsICJmaWxlc3lzdGVtIjogImJhY2t1cF9mcyIsICJ1c2VyIjogImNsaWVudC5taXJyb3JfcGVlcl9ib290c3RyYXAiLCAic2l0ZV9uYW1lIjogInNpdGUtcmVtb3RlIiwgImtleSI6ICJBUUFhcDBCZ0xtRmpOeEFBVnNyZXozai9YYUV0T2UrbUJEZlJDZz09IiwgIm1vbl9ob3N0IjogIlt2MjoxOTIuMTY4LjAuNTo0MDkxOCx2MToxOTIuMTY4LjAuNTo0MDkxOV0ifQ==
```

## Mirroring Status[](https://docs.ceph.com/en/latest/cephfs/cephfs-mirroring/#mirroring-status)

CephFS mirroring module provides mirror daemon status interface to check mirror daemon status:

```
$ ceph fs snapshot mirror daemon status
[
  {
    "daemon_id": 284167,
    "filesystems": [
      {
        "filesystem_id": 1,
        "name": "a",
        "directory_count": 1,
        "peers": [
          {
            "uuid": "02117353-8cd1-44db-976b-eb20609aa160",
            "remote": {
              "client_name": "client.mirror_remote",
              "cluster_name": "ceph",
              "fs_name": "backup_fs"
            },
            "stats": {
              "failure_count": 1,
              "recovery_count": 0
            }
          }
        ]
      }
    ]
  }
]
```

An entry per mirror daemon instance is displayed along with information such as configured peers and basic stats. For more detailed stats, use the admin socket interface as detailed below.

CephFS mirror daemons provide admin socket commands for querying mirror status. To check available commands for mirror status use:

```
$ ceph --admin-daemon /path/to/mirror/daemon/admin/socket help
{
    ....
    ....
    "fs mirror status cephfs@360": "get filesystem mirror status",
    ....
    ....
}
```

Commands prefixed with`fs mirror status` provide mirror status for mirror enabled file systems. Note that cephfs@360 is of format filesystem-name@filesystem-id. This format is required since mirror daemons get asynchronously notified regarding file system mirror status (A file system can be deleted and recreated with the same name).

This command currently provides minimal information regarding mirror status:

```
$ ceph --admin-daemon /var/run/ceph/cephfs-mirror.asok fs mirror status cephfs@360
{
  "rados_inst": "192.168.0.5:0/1476644347",
  "peers": {
      "a2dc7784-e7a1-4723-b103-03ee8d8768f8": {
          "remote": {
              "client_name": "client.mirror_remote",
              "cluster_name": "site-a",
              "fs_name": "backup_fs"
          }
      }
  },
  "snap_dirs": {
      "dir_count": 1
  }
}
```

The Peers section in the command output above shows the peer information including the unique peer-id (UUID) and specification. The peer-id is required when removing an existing peer as mentioned in the Mirror Module and Interface section.

Commands prefixed with fs mirror peer status provide peer synchronization status. This command is of format filesystem-name@filesystem-id peer-uuid:

```
$ ceph --admin-daemon /var/run/ceph/cephfs-mirror.asok fs mirror peer status cephfs@360 a2dc7784-e7a1-4723-b103-03ee8d8768f8
{
  "/d0": {
      "state": "idle",
      "last_synced_snap": {
          "id": 120,
          "name": "snap1",
          "sync_duration": 0.079997898999999997,
          "sync_time_stamp": "274900.558797s"
      },
      "snaps_synced": 2,
      "snaps_deleted": 0,
      "snaps_renamed": 0
  }
}
```

Synchronization stats including snaps_synced, snaps_deleted and snaps_renamed are reset on daemon restart and/or when a directory is reassigned to another mirror daemon (when multiple mirror daemons are deployed).

A directory can be in one of the following states:

```
- `idle`: The directory is currently not being synchronized
- `syncing`: The directory is currently being synchronized
- `failed`: The directory has hit upper limit of consecutive failures
```

When a directory experiences a configured number of consecutive synchronization failures, the mirror daemon marks it as failed. Synchronization for these directories is retried. By default, the number of consecutive failures before a directory is marked as failed is controlled by cephfs_mirror_max_consecutive_failures_per_directory configuration option (default: 10) and the retry interval for failed directories is controlled via cephfs_mirror_retry_failed_directories_interval configuration option (default: 60s).

E.g., adding a regular file for synchronization would result in failed status:

```
$ ceph fs snapshot mirror add cephfs /f0
$ ceph --admin-daemon /var/run/ceph/cephfs-mirror.asok fs mirror peer status cephfs@360 a2dc7784-e7a1-4723-b103-03ee8d8768f8
{
  "/d0": {
      "state": "idle",
      "last_synced_snap": {
          "id": 120,
          "name": "snap1",
          "sync_duration": 0.079997898999999997,
          "sync_time_stamp": "274900.558797s"
      },
      "snaps_synced": 2,
      "snaps_deleted": 0,
      "snaps_renamed": 0
  },
  "/f0": {
      "state": "failed",
      "snaps_synced": 0,
      "snaps_deleted": 0,
      "snaps_renamed": 0
  }
}
```

This allows a user to add a non-existent directory for synchronization. The mirror daemon will mark such a directory as failed and retry (less frequently). When the directory is created, the mirror daemon will clear the failed state upon successful synchronization.

When mirroring is disabled, the respective fs mirror status command for the file system will not show up in command help.

## Configuration Options[](https://docs.ceph.com/en/latest/cephfs/cephfs-mirroring/#configuration-options)

- cephfs_mirror_max_concurrent_directory_syncs[](https://docs.ceph.com/en/latest/cephfs/cephfs-mirroring/#confval-cephfs_mirror_max_concurrent_directory_syncs)

  maximum number of directory snapshots that can be synchronized concurrently by cephfs-mirror daemon. Controls the number of synchronization threads. type `uint` default `3` min `1`

- cephfs_mirror_action_update_interval[](https://docs.ceph.com/en/latest/cephfs/cephfs-mirroring/#confval-cephfs_mirror_action_update_interval)

  Interval in seconds to process pending mirror update actions. type `secs` default `2` min `1`

- cephfs_mirror_restart_mirror_on_blocklist_interval[](https://docs.ceph.com/en/latest/cephfs/cephfs-mirroring/#confval-cephfs_mirror_restart_mirror_on_blocklist_interval)

  Interval in seconds to restart blocklisted mirror instances. Setting to zero (0) disables restarting blocklisted instances. type `secs` default `30` min `0`

- cephfs_mirror_max_snapshot_sync_per_cycle[](https://docs.ceph.com/en/latest/cephfs/cephfs-mirroring/#confval-cephfs_mirror_max_snapshot_sync_per_cycle)

  maximum number of snapshots to mirror when a directory is picked up for mirroring by worker threads. type `uint` default `3` min `1`

- cephfs_mirror_directory_scan_interval[](https://docs.ceph.com/en/latest/cephfs/cephfs-mirroring/#confval-cephfs_mirror_directory_scan_interval)

  interval in seconds to scan configured directories for snapshot mirroring. type `uint` default `10` min `1`

- cephfs_mirror_max_consecutive_failures_per_directory[](https://docs.ceph.com/en/latest/cephfs/cephfs-mirroring/#confval-cephfs_mirror_max_consecutive_failures_per_directory)

  number of consecutive snapshot synchronization failures to mark a directory as “failed”. failed directories are retried for synchronization less frequently. type `uint` default `10` min `0`

- cephfs_mirror_retry_failed_directories_interval[](https://docs.ceph.com/en/latest/cephfs/cephfs-mirroring/#confval-cephfs_mirror_retry_failed_directories_interval)

  interval in seconds to retry synchronization for failed directories. type `uint` default `60` min `1`

- cephfs_mirror_restart_mirror_on_failure_interval[](https://docs.ceph.com/en/latest/cephfs/cephfs-mirroring/#confval-cephfs_mirror_restart_mirror_on_failure_interval)

  Interval in seconds to restart failed mirror instances. Setting to zero (0) disables restarting failed mirror instances. type `secs` default `20` min `0`

- cephfs_mirror_mount_timeout[](https://docs.ceph.com/en/latest/cephfs/cephfs-mirroring/#confval-cephfs_mirror_mount_timeout)

  Timeout in seconds for mounting primary or secondary (remote) ceph file system by the cephfs-mirror daemon. Setting this to a higher value could result in the mirror daemon getting stalled when mounting a file system if the cluster is not reachable. This option is used to override the usual client_mount_timeout. type `secs` default `10` min `0`

## Re-adding Peers[](https://docs.ceph.com/en/latest/cephfs/cephfs-mirroring/#re-adding-peers)

When re-adding (reassigning) a peer to a file system in another cluster, ensure that all mirror daemons have stopped synchronization to the peer. This can be checked via fs mirror status admin socket command (the Peer UUID should not show up in the command output). Also, it is recommended to purge synchronized directories from the peer  before re-adding it to another file system (especially those directories which might exist in the new primary file system). This is not required if re-adding a peer to the same primary file system it was earlier synchronized from.

# Client Configuration[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#client-configuration)

## Updating Client Configuration[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#updating-client-configuration)

Certain client configurations can be applied at runtime. To check if a configuration option can be applied (taken into affect by a client) at  runtime, use the config help command:

```
ceph config help debug_client
 debug_client - Debug level for client
 (str, advanced)                                                                                                                      Default: 0/5
 Can update at runtime: true

 The value takes the form 'N' or 'N/M' where N and M are values between 0 and 99.  N is the debug level to log (all values below this are included), and M is the level to gather and buffer in memory.  In the event of a crash, the most recent items <= M are dumped to the log file.
```

config help tells if a given configuration can be applied at runtime along with the defaults and a description of the configuration option.

To update a configuration option at runtime, use the config set command:

```
ceph config set client debug_client 20/20
```

Note that this changes a given configuration for all clients.

To check configured options use the config get command:

```
ceph config get client
 WHO    MASK LEVEL    OPTION                    VALUE     RO
 client      advanced debug_client              20/20
 global      advanced osd_pool_default_min_size 1
 global      advanced osd_pool_default_size     3
```

## Client Config Reference[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#client-config-reference)

- client_acl_type[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_acl_type)

  Set the ACL type. Currently, only possible value is `"posix_acl"` to enable POSIX ACL, or an empty string. This option only takes effect when the `fuse_default_permissions` is set to `false`. type `str`

- client_cache_mid[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_cache_mid)

  Set client cache midpoint. The midpoint splits the least recently used lists into a hot and warm list. type `float` default `0.75`

- client_cache_size[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_cache_size)

  Set the number of inodes that the client keeps in the metadata cache. type `size` default `16Ki`

- client_caps_release_delay[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_caps_release_delay)

  Set the delay between capability releases in seconds. The delay sets how many   seconds a client waits to release capabilities that it no longer needs in case the capabilities are needed for another user space operation. type `secs` default `5`

- client_debug_force_sync_read[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_debug_force_sync_read)

  If set to `true`, clients read data directly from OSDs instead of using a local page cache. type `bool` default `false`

- client_dirsize_rbytes[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_dirsize_rbytes)

  This option enables a CephFS feature that stores the recursive directory size (the bytes used by files in the directory and its descendents) in the st_size field of the stat structure. type `bool` default `true`

- client_max_inline_size[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_max_inline_size)

  Set the maximum size of inlined data stored in a file inode rather than in a separate data object in RADOS. This setting only applies if the `inline_data` flag is set on the MDS map. type `size` default `4Ki`

- client_metadata[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_metadata)

  Comma-delimited strings for client metadata sent to each MDS, in addition to the automatically generated version, host name, and other metadata. type `str`

- client_mount_gid[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_mount_gid)

  Set the group ID of CephFS mount. type `int` default `-1`

- client_mount_timeout[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_mount_timeout)

  Set the timeout for CephFS mount in seconds. type `secs` default `5 minutes`

- client_mount_uid[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_mount_uid)

  Set the user ID of CephFS mount. type `int` default `-1`

- client_mountpoint[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_mountpoint)

  Directory to mount on the CephFS file system. An alternative to the `-r` option of the `ceph-fuse` command. type `str` default `/`

- client_oc[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_oc)

  enable object caching type `bool` default `true`

- client_oc_max_dirty[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_oc_max_dirty)

  Set the maximum number of dirty bytes in the object cache. type `size` default `100Mi`

- client_oc_max_dirty_age[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_oc_max_dirty_age)

  Set the maximum age in seconds of dirty data in the object cache before writeback. type `float` default `5.0`

- client_oc_max_objects[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_oc_max_objects)

  Set the maximum number of objects in the object cache. type `int` default `1000`

- client_oc_size[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_oc_size)

  Set how many bytes of data will the client cache. type `size` default `200Mi`

- client_oc_target_dirty[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_oc_target_dirty)

  Set the target size of dirty data. We recommend to keep this number low. type `size` default `8Mi`

- client_permissions[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_permissions)

  Check client permissions on all I/O operations. type `bool` default `true`

- client_quota_df[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_quota_df)

  Report root directory quota for the `statfs` operation. type `bool` default `true`

- client_readahead_max_bytes[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_readahead_max_bytes)

  Set the maximum number of bytes that the client reads ahead for future read operations. Overridden by the `client_readahead_max_periods` setting. type `size` default `0B`

- client_readahead_max_periods[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_readahead_max_periods)

  Set the number of file layout periods (object size * number of stripes) that the client reads ahead. Overrides the `client_readahead_max_bytes` setting. type `int` default `4`

- client_readahead_min[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_readahead_min)

  Set the minimum number bytes that the client reads ahead. type `size` default `128Ki`

- client_reconnect_stale[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_reconnect_stale)

  reconnect when the session becomes stale type `bool` default `false`

- client_snapdir[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_snapdir)

  Set the snapshot directory name. type `str` default `.snap`

- client_tick_interval[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_tick_interval)

  Set the interval in seconds between capability renewal and other upkeep. type `secs` default `1`

- client_use_random_mds[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_use_random_mds)

  Choose random MDS for each request. type `bool` default `false`

- fuse_default_permissions[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-fuse_default_permissions)

  When set to `false`, `ceph-fuse` utility checks does its own permissions checking, instead of relying on the permissions enforcement in FUSE. Set to `false` together with the `client acl type=posix_acl` option to enable POSIX ACL. type `bool` default `false`

- fuse_max_write[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-fuse_max_write)

  Set the maximum number of bytes in a single write operation. A value of 0 indicates no change; the FUSE default of 128 kbytes remains in force. type `size` default `0B`

- fuse_disable_pagecache[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-fuse_disable_pagecache)

  If set to `true`, kernel page cache is disabled for `ceph-fuse` mounts. When multiple clients read/write to a file at the same time, readers may get stale data from page cache. Due to limitations of FUSE, `ceph-fuse` can’t disable page cache dynamically. type `bool` default `false`

### Developer Options[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#developer-options)

Important

These options are internal. They are listed here only to complete the list of options.

- client_debug_getattr_caps[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_debug_getattr_caps)

  type `bool` default `false`

- client_debug_inject_tick_delay[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_debug_inject_tick_delay)

  type `secs` default `0`

- client_inject_fixed_oldest_tid[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_inject_fixed_oldest_tid)

  type `bool` default `false`

- client_inject_release_failure[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_inject_release_failure)

  type `bool` default `false`

- client_trace[](https://docs.ceph.com/en/latest/cephfs/client-config-ref/#confval-client_trace)

  file containing trace of client operations type `str`

​        

# CephFS Client Capabilities[](https://docs.ceph.com/en/latest/cephfs/client-auth/#cephfs-client-capabilities)

Use Ceph authentication capabilities to restrict your file system clients to the lowest possible level of authority needed.

Note

Path restriction and layout modification restriction are new features in the Jewel release of Ceph.

Note

Using Erasure Coded(EC) pools with CephFS is supported only with the BlueStore Backend. They cannot be used as metadata pools and overwrites must be enabled on the data pools.

## Path restriction[](https://docs.ceph.com/en/latest/cephfs/client-auth/#path-restriction)

By default, clients are not restricted in what paths they are allowed to mount. Further, when clients mount a subdirectory, e.g., `/home/user`, the MDS does not by default verify that subsequent operations are ‘locked’ within that directory.

To restrict clients to only mount and work within a certain directory, use path-based MDS authentication capabilities.

### Syntax[](https://docs.ceph.com/en/latest/cephfs/client-auth/#syntax)

To grant rw access to the specified directory only, we mention the specified directory while creating key for a client using the following syntax:

```
ceph fs authorize <fs_name> client.<client_id> <path-in-cephfs> rw
```

For example, to restrict client `foo` to writing only in the `bar` directory of file system `cephfs_a`, use

```
ceph fs authorize cephfs_a client.foo / r /bar rw

results in:

client.foo
  key: *key*
  caps: [mds] allow r, allow rw path=/bar
  caps: [mon] allow r
  caps: [osd] allow rw tag cephfs data=cephfs_a
```

To completely restrict the client to the `bar` directory, omit the root directory

```
ceph fs authorize cephfs_a client.foo /bar rw
```

Note that if a client’s read access is restricted to a path, they will only be able to mount the file system when specifying a readable path in the mount command (see below).

Supplying `all` or `*` as the file system name will grant access to every file system. Note that it is usually necessary to quote `*` to protect it from the shell.

See [User Management - Add a User to a Keyring](https://docs.ceph.com/en/latest/rados/operations/user-management/#add-a-user-to-a-keyring). for additional details on user management

To restrict a client to the specified sub-directory only, we mention the specified directory while mounting using the following syntax:

```
ceph-fuse -n client.<client_id> <mount-path> -r *directory_to_be_mounted*
```

For example, to restrict client `foo` to `mnt/bar` directory, we will use:

```
ceph-fuse -n client.foo mnt -r /bar
```

### Free space reporting[](https://docs.ceph.com/en/latest/cephfs/client-auth/#free-space-reporting)

By default, when a client is mounting a sub-directory, the used space (`df`) will be calculated from the quota on that sub-directory, rather than reporting the overall amount of space used on the cluster.

If you would like the client to report the overall usage of the file system, and not just the quota usage on the sub-directory mounted, then set the following config option on the client:

```
client quota df = false
```

If quotas are not enabled, or no quota is set on the sub-directory mounted, then the overall usage of the file system will be reported irrespective of the value of this setting.

## Layout and Quota restriction (the ‘p’ flag)[](https://docs.ceph.com/en/latest/cephfs/client-auth/#layout-and-quota-restriction-the-p-flag)

To set layouts or quotas, clients require the ‘p’ flag in addition to ‘rw’. This restricts all the attributes that are set by special extended attributes with a “ceph.” prefix, as well as restricting other means of setting these fields (such as openc operations with layouts).

For example, in the following snippet client.0 can modify layouts and quotas on the file system cephfs_a, but client.1 cannot:

```
client.0
    key: AQAz7EVWygILFRAAdIcuJ12opU/JKyfFmxhuaw==
    caps: [mds] allow rwp
    caps: [mon] allow r
    caps: [osd] allow rw tag cephfs data=cephfs_a

client.1
    key: AQAz7EVWygILFRAAdIcuJ12opU/JKyfFmxhuaw==
    caps: [mds] allow rw
    caps: [mon] allow r
    caps: [osd] allow rw tag cephfs data=cephfs_a
```

## Snapshot restriction (the ‘s’ flag)[](https://docs.ceph.com/en/latest/cephfs/client-auth/#snapshot-restriction-the-s-flag)

To create or delete snapshots, clients require the ‘s’ flag in addition to ‘rw’. Note that when capability string also contains the ‘p’ flag, the ‘s’ flag must appear after it (all flags except ‘rw’ must be specified in alphabetical order).

For example, in the following snippet client.0 can create or delete snapshots in the `bar` directory of file system `cephfs_a`:

```
client.0
    key: AQAz7EVWygILFRAAdIcuJ12opU/JKyfFmxhuaw==
    caps: [mds] allow rw, allow rws path=/bar
    caps: [mon] allow r
    caps: [osd] allow rw tag cephfs data=cephfs_a
```

## Network restriction[](https://docs.ceph.com/en/latest/cephfs/client-auth/#network-restriction)

```
client.foo
  key: *key*
  caps: [mds] allow r network 10.0.0.0/8, allow rw path=/bar network 10.0.0.0/8
  caps: [mon] allow r network 10.0.0.0/8
  caps: [osd] allow rw tag cephfs data=cephfs_a network 10.0.0.0/8
```

The optional `{network/prefix}` is a standard network name and prefix length in CIDR notation (e.g., `10.3.0.0/16`).  If present, the use of this capability is restricted to clients connecting from this network.



## File system Information Restriction[](https://docs.ceph.com/en/latest/cephfs/client-auth/#file-system-information-restriction)

If desired, the monitor cluster can present a limited view of the file systems available. In this case, the monitor cluster will only inform clients about file systems specified by the administrator. Other file systems will not be reported and commands affecting them will fail as if the file systems do not exist.

Consider following example. The Ceph cluster has 2 FSs:

```
$ ceph fs ls
name: cephfs, metadata pool: cephfs_metadata, data pools: [cephfs_data ]
name: cephfs2, metadata pool: cephfs2_metadata, data pools: [cephfs2_data ]
```

But we authorize client `someuser` for only one FS:

```
$ ceph fs authorize cephfs client.someuser / rw
[client.someuser]
    key = AQAmthpf89M+JhAAiHDYQkMiCq3x+J0n9e8REQ==
$ cat ceph.client.someuser.keyring
[client.someuser]
    key = AQAmthpf89M+JhAAiHDYQkMiCq3x+J0n9e8REQ==
    caps mds = "allow rw fsname=cephfs"
    caps mon = "allow r fsname=cephfs"
    caps osd = "allow rw tag cephfs data=cephfs"
```

And the client can only see the FS that it has authorization for:

```
$ ceph fs ls -n client.someuser -k ceph.client.someuser.keyring
name: cephfs, metadata pool: cephfs_metadata, data pools: [cephfs_data ]
```

Standby MDS daemons will always be displayed. Note that the information about restricted MDS daemons and file systems may become available by other means, such as `ceph health detail`.

## MDS communication restriction[](https://docs.ceph.com/en/latest/cephfs/client-auth/#mds-communication-restriction)

By default, user applications may communicate with any MDS, whether or not they are allowed to modify data on an associated file system (see Path restriction above). Client’s communication can be restricted to MDS daemons associated with particular file system(s) by adding MDS caps for that particular file system. Consider the following example where the Ceph cluster has 2 FSs:

```
$ ceph fs ls
name: cephfs, metadata pool: cephfs_metadata, data pools: [cephfs_data ]
name: cephfs2, metadata pool: cephfs2_metadata, data pools: [cephfs2_data ]
```

Client `someuser` is authorized only for one FS:

```
$ ceph fs authorize cephfs client.someuser / rw
[client.someuser]
    key = AQBPSARfg8hCJRAAEegIxjlm7VkHuiuntm6wsA==
$ ceph auth get client.someuser > ceph.client.someuser.keyring
exported keyring for client.someuser
$ cat ceph.client.someuser.keyring
[client.someuser]
    key = AQBPSARfg8hCJRAAEegIxjlm7VkHuiuntm6wsA==
    caps mds = "allow rw fsname=cephfs"
    caps mon = "allow r"
    caps osd = "allow rw tag cephfs data=cephfs"
```

Mounting `cephfs1` with `someuser` works:

```
$ sudo ceph-fuse /mnt/cephfs1 -n client.someuser -k ceph.client.someuser.keyring --client-fs=cephfs
ceph-fuse[96634]: starting ceph client
ceph-fuse[96634]: starting fuse
$ mount | grep ceph-fuse
ceph-fuse on /mnt/cephfs1 type fuse.ceph-fuse (rw,nosuid,nodev,relatime,user_id=0,group_id=0,allow_other)
```

But mounting `cephfs2` does not:

```
$ sudo ceph-fuse /mnt/cephfs2 -n client.someuser -k ceph.client.someuser.keyring --client-fs=cephfs2
ceph-fuse[96599]: starting ceph client
ceph-fuse[96599]: ceph mount failed with (1) Operation not permitted
```

## Root squash[](https://docs.ceph.com/en/latest/cephfs/client-auth/#root-squash)

The `root squash` feature is implemented as a safety measure to prevent scenarios such as accidental `sudo rm -rf /path`. You can enable `root_squash` mode in MDS caps to disallow clients with uid=0 or gid=0 to perform write access operations -- e.g., rm, rmdir, rmsnap, mkdir, mksnap. However, the mode allows the read operations of a root client unlike in other file systems.

Following is an example of enabling root_squash in a filesystem except within ‘/volumes’ directory tree in the filesystem:

```
$ ceph fs authorize a client.test_a / rw root_squash /volumes rw
$ ceph auth get client.test_a
[client.test_a]
    key = AQBZcDpfEbEUKxAADk14VflBXt71rL9D966mYA==
    caps mds = "allow rw fsname=a root_squash, allow rw fsname=a path=/volumes"
    caps mon = "allow r fsname=a"
    caps osd = "allow rw tag cephfs data=a"
```

​        

# Mount CephFS: Prerequisites[](https://docs.ceph.com/en/latest/cephfs/mount-prerequisites/#mount-cephfs-prerequisites)

You can use CephFS by mounting it to your local filesystem or by using [cephfs-shell](https://docs.ceph.com/en/latest/cephfs/cephfs-shell). Mounting CephFS requires superuser privileges to trim dentries by issuing a remount of itself. CephFS can be mounted [using kernel](https://docs.ceph.com/en/latest/cephfs/mount-using-kernel-driver) as well as [using FUSE](https://docs.ceph.com/en/latest/cephfs/mount-using-fuse). Both have their own advantages. Read the following section to understand more about both of these ways to mount CephFS.

For Windows CephFS mounts, please check the [ceph-dokan](https://docs.ceph.com/en/latest/cephfs/ceph-dokan) page.

## Which CephFS Client?[](https://docs.ceph.com/en/latest/cephfs/mount-prerequisites/#which-cephfs-client)

The FUSE client is the most accessible and the easiest to upgrade to the version of Ceph used by the storage cluster, while the kernel client will always gives better performance.

When encountering bugs or performance issues, it is often instructive to try using the other client, in order to find out whether the bug was client-specific or not (and then to let the developers know).

## General Pre-requisite for Mounting CephFS[](https://docs.ceph.com/en/latest/cephfs/mount-prerequisites/#general-pre-requisite-for-mounting-cephfs)

Before mounting CephFS, ensure that the client host (where CephFS has to be mounted and used) has a copy of the Ceph configuration file (i.e. `ceph.conf`) and a keyring of the CephX user that has permission to access the MDS. Both of these files must already be present on the host where the Ceph MON resides.

1. Generate a minimal conf file for the client host and place it at a standard location:

   ```
   # on client host
   mkdir -p -m 755 /etc/ceph
   ssh {user}@{mon-host} "sudo ceph config generate-minimal-conf" | sudo tee /etc/ceph/ceph.conf
   ```

   Alternatively, you may copy the conf file. But the above method generates a conf with minimal details which is usually sufficient. For more information, see [Client Authentication](https://docs.ceph.com/en/latest/cephfs/client-auth) and [Bootstrap options](https://docs.ceph.com/en/latest/rados/configuration/ceph-conf/#bootstrap-options).

2. Ensure that the conf has appropriate permissions:

   ```
   chmod 644 /etc/ceph/ceph.conf
   ```

3. Create a CephX user and get its secret key:

   ```
   ssh {user}@{mon-host} "sudo ceph fs authorize cephfs client.foo / rw" | sudo tee /etc/ceph/ceph.client.foo.keyring
   ```

   In above command, replace `cephfs` with the name of your CephFS, `foo` by the name you want for your CephX user and `/` by the path within your CephFS for which you want to allow access to the client host and `rw` stands for both read and write permissions. Alternatively, you may copy the Ceph keyring from the MON host to client host at `/etc/ceph` but creating a keyring specific to the client host is better. While creating a CephX keyring/client, using same client name across multiple machines is perfectly fine.

   Note

   If you get 2 prompts for password while running above any of 2 above command, run `sudo ls` (or any other trivial command with sudo) immediately before these commands.

4. Ensure that the keyring has appropriate permissions:

   ```
   chmod 600 /etc/ceph/ceph.client.foo.keyring
   ```

Note

There might be few more prerequisites for kernel and FUSE mounts individually, please check respective mount documents.

# Mount CephFS using Kernel Driver[](https://docs.ceph.com/en/latest/cephfs/mount-using-kernel-driver/#mount-cephfs-using-kernel-driver)

The CephFS kernel driver is part of the Linux kernel. It allows mounting CephFS as a regular file system with native kernel performance. It is the client of choice for most use-cases.

Note

CephFS mount device string now uses a new (v2) syntax. The mount helper (and the kernel) is backward compatible with the old syntax. This means that the old syntax can still be used for mounting with newer mount helpers and kernel. However, it is recommended to use the new syntax whenever possible.

## Prerequisites[](https://docs.ceph.com/en/latest/cephfs/mount-using-kernel-driver/#prerequisites)

### Complete General Prerequisites[](https://docs.ceph.com/en/latest/cephfs/mount-using-kernel-driver/#complete-general-prerequisites)

Go through the prerequisites required by both, kernel as well as FUSE mounts, in [Mount CephFS: Prerequisites](https://docs.ceph.com/en/latest/cephfs/mount-prerequisites) page.

### Is mount helper is present?[](https://docs.ceph.com/en/latest/cephfs/mount-using-kernel-driver/#is-mount-helper-is-present)

`mount.ceph` helper is installed by Ceph packages. The helper passes the monitor address(es) and CephX user keyrings automatically saving the Ceph admin the effort to pass these details explicitly while mounting CephFS. In case the helper is not present on the client machine, CephFS can still be mounted using kernel but by passing these details explicitly to the `mount` command. To check whether it is present on your system, do:

```
stat /sbin/mount.ceph
```

### Which Kernel Version?[](https://docs.ceph.com/en/latest/cephfs/mount-using-kernel-driver/#which-kernel-version)

Because the kernel client is distributed as part of the linux kernel (not as part of packaged ceph releases), you will need to consider which kernel version to use on your client nodes. Older kernels are known to include buggy ceph clients, and may not support features that more recent Ceph clusters support.

Remember that the “latest” kernel in a stable linux distribution is likely to be years behind the latest upstream linux kernel where Ceph development takes place (including bug fixes).

As a rough guide, as of Ceph 10.x (Jewel), you should be using a least a 4.x kernel. If you absolutely have to use an older kernel, you should use the fuse client instead of the kernel client.

This advice does not apply if you are using a linux distribution that includes CephFS support, as in this case the distributor will be responsible for backporting fixes to their stable kernel: check with your vendor.

## Synopsis[](https://docs.ceph.com/en/latest/cephfs/mount-using-kernel-driver/#synopsis)

In general, the command to mount CephFS via kernel driver looks like this:

```
mount -t ceph {device-string}={path-to-mounted} {mount-point} -o {key-value-args} {other-args}
```

## Mounting CephFS[](https://docs.ceph.com/en/latest/cephfs/mount-using-kernel-driver/#mounting-cephfs)

On Ceph clusters, CephX is enabled by default. Use `mount` command to mount CephFS with the kernel driver:

```
mkdir /mnt/mycephfs
mount -t ceph <name>@<fsid>.<fs_name>=/ /mnt/mycephfs
```

`name` is the username of the CephX user we are using to mount CephFS. `fsid` is the FSID of the ceph cluster which can be found using `ceph fsid` command. `fs_name` is the file system to mount. The kernel driver requires MON’s socket and the secret key for the CephX user, e.g.:

```
mount -t ceph cephuser@b3acfc0d-575f-41d3-9c91-0e7ed3dbb3fa.cephfs=/ -o mon_addr=192.168.0.1:6789,secret=AQATSKdNGBnwLhAAnNDKnH65FmVKpXZJVasUeQ==
```

When using the mount helper, monitor hosts and FSID are optional. `mount.ceph` helper figures out these details automatically by finding and reading ceph conf file, .e.g:

```
mount -t ceph cephuser@.cephfs=/ -o secret=AQATSKdNGBnwLhAAnNDKnH65FmVKpXZJVasUeQ==
```

Note

Note that the dot (`.`) still needs to be a part of the device string.

A potential problem with the above command is that the secret key is left in your shell’s command history. To prevent that you can copy the secret key inside a file and pass the file by using the option `secretfile` instead of `secret`:

```
mount -t ceph cephuser@.cephfs=/ /mnt/mycephfs -o secretfile=/etc/ceph/cephuser.secret
```

Ensure the permissions on the secret key file are appropriate (preferably, `600`).

Multiple monitor hosts can be passed by separating each address with a `/`:

```
mount -t ceph cephuser@.cephfs=/ /mnt/mycephfs -o mon_addr=192.168.0.1:6789/192.168.0.2:6789,secretfile=/etc/ceph/cephuser.secret
```

In case CephX is disabled, you can omit any credential related options:

```
mount -t ceph cephuser@.cephfs=/ /mnt/mycephfs
```

Note

The ceph user name still needs to be passed as part of the device string.

To mount a subtree of the CephFS root, append the path to the device string:

```
mount -t ceph cephuser@.cephfs=/subvolume/dir1/dir2 /mnt/mycephfs -o secretfile=/etc/ceph/cephuser.secret
```

## Unmounting CephFS[](https://docs.ceph.com/en/latest/cephfs/mount-using-kernel-driver/#unmounting-cephfs)

To unmount the Ceph file system, use the `umount` command as usual:

```
umount /mnt/mycephfs
```

Tip

Ensure that you are not within the file system directories before executing this command.

## Persistent Mounts[](https://docs.ceph.com/en/latest/cephfs/mount-using-kernel-driver/#persistent-mounts)

To mount CephFS in your file systems table as a kernel driver, add the following to `/etc/fstab`:

```
{name}@.{fs_name}=/ {mount}/{mountpoint} ceph [mon_addr={ipaddress},secret=secretkey|secretfile=/path/to/secretfile],[{mount.options}]  {fs_freq}  {fs_passno}
```

For example:

```
cephuser@.cephfs=/     /mnt/ceph    ceph    mon_addr=192.168.0.1:6789,noatime,_netdev    0       0
```

If the `secret` or `secretfile` options are not specified then the mount helper will attempt to find a secret for the given `name` in one of the configured keyrings.

See [User Management](https://docs.ceph.com/en/latest/rados/operations/user-management/) for details on CephX user management and [mount.ceph](https://docs.ceph.com/en/latest/man/8/mount.ceph/) manual for more options it can take. For troubleshooting, see [Kernel mount debugging](https://docs.ceph.com/en/latest/cephfs/troubleshooting/#kernel-mount-debugging).

# Mount CephFS using FUSE[](https://docs.ceph.com/en/latest/cephfs/mount-using-fuse/#mount-cephfs-using-fuse)

[ceph-fuse](https://docs.ceph.com/en/latest/man/8/ceph-fuse/#options) is an alternate way of mounting CephFS, although it mounts it in userspace. Therefore, performance of FUSE can be relatively lower but FUSE clients can be more manageable, especially while upgrading CephFS.

## Prerequisites[](https://docs.ceph.com/en/latest/cephfs/mount-using-fuse/#prerequisites)

Go through the prerequisites required by both, kernel as well as FUSE mounts, in [Mount CephFS: Prerequisites](https://docs.ceph.com/en/latest/cephfs/mount-prerequisites) page.

Note

Mounting CephFS using FUSE requires superuser privileges to trim dentries by issuing a remount of itself.

## Synopsis[](https://docs.ceph.com/en/latest/cephfs/mount-using-fuse/#synopsis)

In general, the command to mount CephFS via FUSE looks like this:

```
ceph-fuse {mountpoint} {options}
```

## Mounting CephFS[](https://docs.ceph.com/en/latest/cephfs/mount-using-fuse/#mounting-cephfs)

To FUSE-mount the Ceph file system, use the `ceph-fuse` command:

```
mkdir /mnt/mycephfs
ceph-fuse --id foo /mnt/mycephfs
```

Option `-id` passes the name of the CephX user whose keyring we intend to use for mounting CephFS. In the above command, it’s `foo`. You can also use `-n` instead, although `--id` is evidently easier:

```
ceph-fuse -n client.foo /mnt/mycephfs
```

In case the keyring is not present in standard locations, you may pass it too:

```
ceph-fuse --id foo -k /path/to/keyring /mnt/mycephfs
```

You may pass the MON’s socket too, although this is not mandatory:

```
ceph-fuse --id foo -m 192.168.0.1:6789 /mnt/mycephfs
```

You can also mount a specific directory within CephFS instead of mounting root of CephFS on your local FS:

```
ceph-fuse --id foo -r /path/to/dir /mnt/mycephfs
```

If you have more than one FS on your Ceph cluster, use the option `--client_fs` to mount the non-default FS:

```
ceph-fuse --id foo --client_fs mycephfs2 /mnt/mycephfs2
```

You may also add a `client_fs` setting to your `ceph.conf`

## Unmounting CephFS[](https://docs.ceph.com/en/latest/cephfs/mount-using-fuse/#unmounting-cephfs)

Use `umount` to unmount CephFS like any other FS:

```
umount /mnt/mycephfs
```

Tip

Ensure that you are not within the file system directories before executing this command.

## Persistent Mounts[](https://docs.ceph.com/en/latest/cephfs/mount-using-fuse/#persistent-mounts)

To mount CephFS as a file system in user space, add the following to `/etc/fstab`:

```
#DEVICE PATH       TYPE      OPTIONS
none    /mnt/mycephfs  fuse.ceph ceph.id={user-ID}[,ceph.conf={path/to/conf.conf}],_netdev,defaults  0 0
```

For example:

```
none    /mnt/mycephfs  fuse.ceph ceph.id=myuser,_netdev,defaults  0 0
none    /mnt/mycephfs  fuse.ceph ceph.id=myuser,ceph.conf=/etc/ceph/foo.conf,_netdev,defaults  0 0
```

Ensure you use the ID (e.g., `myuser`, not `client.myuser`). You can pass any valid `ceph-fuse` option to the command line this way.

To mount a subdirectory of the CephFS, add the following to `/etc/fstab`:

```
none    /mnt/mycephfs  fuse.ceph ceph.id=myuser,ceph.client_mountpoint=/path/to/dir,_netdev,defaults  0 0
```

`ceph-fuse@.service` and `ceph-fuse.target` systemd units are available. As usual, these unit files declare the default dependencies and recommended execution context for `ceph-fuse`. After making the fstab entry shown above, run following commands:

```
systemctl start ceph-fuse@/mnt/mycephfs.service
systemctl enable ceph-fuse.target
systemctl enable ceph-fuse@-mnt-mycephfs.service
```

See [User Management](https://docs.ceph.com/en/latest/rados/operations/user-management/#user-management) for details on CephX user management and [ceph-fuse](https://docs.ceph.com/en/latest/man/8/ceph-fuse/#options) manual for more options it can take. For troubleshooting, see [ceph-fuse debugging](https://docs.ceph.com/en/latest/cephfs/troubleshooting/#ceph-fuse-debugging).

# Mount CephFS on Windows[](https://docs.ceph.com/en/latest/cephfs/ceph-dokan/#mount-cephfs-on-windows)

`ceph-dokan` can be used for mounting CephFS filesystems on Windows. It leverages Dokany, a Windows driver that allows implementing filesystems in userspace, pretty much like FUSE.

Please check the [installation guide](https://docs.ceph.com/en/latest/install/windows-install) to get started.

## Usage[](https://docs.ceph.com/en/latest/cephfs/ceph-dokan/#usage)

### Mounting filesystems[](https://docs.ceph.com/en/latest/cephfs/ceph-dokan/#mounting-filesystems)

In order to mount a ceph filesystem, the following command can be used:

```
ceph-dokan.exe -c c:\ceph.conf -l x
```

This will mount the default ceph filesystem using the drive letter `x`. If `ceph.conf` is placed at the default location, which is `%ProgramData%\ceph\ceph.conf`, then this argument becomes optional.

The `-l` argument also allows using an empty folder as a mountpoint instead of a drive letter.

The uid and gid used for mounting the filesystem default to 0 and may be changed using the following `ceph.conf` options:

```
[client]
# client_permissions = true
client_mount_uid = 1000
client_mount_gid = 1000
```

If you have more than one FS on your Ceph cluster, use the option `--client_fs` to mount the non-default FS:

```
mkdir -Force C:\mnt\mycephfs2
ceph-dokan.exe --mountpoint C:\mnt\mycephfs2 --client_fs mycephfs2
```

CephFS subdirectories can be mounted using the `--root-path` parameter:

```
ceph-dokan -l y --root-path /a
```

If the `-o --removable` flags are set, the mounts will show up in the `Get-Volume` results:

```
PS C:\> Get-Volume -FriendlyName "Ceph*" | `
        Select-Object -Property @("DriveLetter", "Filesystem", "FilesystemLabel")

DriveLetter Filesystem FilesystemLabel
----------- ---------- ---------------
          Z Ceph       Ceph
          W Ceph       Ceph - new_fs
```

Please use `ceph-dokan --help` for a full list of arguments.

### Credentials[](https://docs.ceph.com/en/latest/cephfs/ceph-dokan/#credentials)

The `--id` option passes the name of the CephX user whose keyring we intend to use for mounting CephFS. The following commands are equivalent:

```
ceph-dokan --id foo -l x
ceph-dokan --name client.foo -l x
```

### Unmounting filesystems[](https://docs.ceph.com/en/latest/cephfs/ceph-dokan/#unmounting-filesystems)

The mount can be removed by either issuing ctrl-c or using the unmap command, like so:

```
ceph-dokan.exe unmap -l x
```

Note that when unmapping Ceph filesystems, the exact same mountpoint argument must be used as when the mapping was created.

### Limitations[](https://docs.ceph.com/en/latest/cephfs/ceph-dokan/#limitations)

Be aware that Windows ACLs are ignored. Posix ACLs are supported but cannot be modified using the current CLI. In the future, we may add some command actions to change file ownership or permissions.

Another thing to note is that cephfs doesn’t support mandatory file locks, which Windows is heavily rely upon. At the moment, we’re letting Dokan handle file locks, which are only enforced locally.

Unlike `rbd-wnbd`, `ceph-dokan` doesn’t currently provide a `service` command. In order for the cephfs mount to survive host reboots, consider using `NSSM`.

## Troubleshooting[](https://docs.ceph.com/en/latest/cephfs/ceph-dokan/#troubleshooting)

Please consult the [Windows troubleshooting](https://docs.ceph.com/en/latest/install/windows-troubleshooting) page.

# cephfs-shell -- Shell-like tool talking with CephFS[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#cephfs-shell-shell-like-tool-talking-with-cephfs)

## Synopsis[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#synopsis)

**cephfs-shell** [options] [command]

**cephfs-shell** [options] -- [command, command,…]

## Description[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#description)

CephFS Shell provides shell-like commands that directly interact with the Ceph File System.

This tool can be used in interactive mode as well as in non-interactive mode. In former mode, cephfs-shell opens a shell session and after the given command is finished, it prints the prompt string and waits indefinitely. When the shell session is finished, cephfs-shell quits with the return value of last executed command. In non-interactive mode, cephfs-shell issues a command and exits right after the command’s execution is complete with the command’s return value.

Behaviour of CephFS Shell can be tweaked using `cephfs-shell.conf`. Refer to [CephFS Shell Configuration File](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#cephfs-shell-configuration-file) for details.

## Options[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#options)

- -b, --batch FILE[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#cmdoption-cephfs-shell-b)

  Path to batch file.

- -c, --config FILE[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#cmdoption-cephfs-shell-c)

  Path to cephfs-shell.conf

- -f, --fs FS[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#cmdoption-cephfs-shell-f)

  Name of filesystem to mount.

- -t, --test FILE[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#cmdoption-cephfs-shell-t)

  Path to transcript(s) in FILE for testing

Note

Latest version of the cmd2 module is required for running cephfs-shell. If CephFS is installed through source, execute cephfs-shell in the build directory. It can also be executed as following using virtualenv:

```
[build]$ python3 -m venv venv && source venv/bin/activate && pip3 install cmd2
[build]$ source vstart_environment.sh && source venv/bin/activate && python3 ../src/tools/cephfs/cephfs-shell
```

## Commands[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#commands)

Note

Apart from Ceph File System, CephFS Shell commands can also interact directly with the local file system. To achieve this, `!` (an exclamation point) must precede the CephFS Shell command.

Usage :

> !<cephfs_shell_command>

For example,

```
CephFS:~/>>> !ls # Lists the local file system directory contents.
CephFS:~/>>> ls  # Lists the Ceph File System directory contents.
```

### mkdir[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#mkdir)

Create the directory(ies), if they do not already exist.

Usage :

> mkdir [-option] <directory>…

- directory - name of the directory to be created.

- Options :

  -m MODE Sets the access mode for the new directory. -p, --parent Create parent directories as necessary. When this option is specified, no error is reported if a directory already exists.

### put[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#put)

Copy a file/directory to Ceph File System from Local File System.

Usage :

> put [options] <source_path> <target_path>

- - source_path - local file/directory path to be copied to cephfs.

    if . copies all the file/directories in the local working directory. if -  Reads the input from stdin.

- - target_path - remote directory path where the files/directories are to be copied to.

    if . files/directories are copied to the remote working directory.

- Options :

  -f, --force Overwrites the destination if it already exists.

### get[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#get)

Copy a file from Ceph File System to Local File System.

Usage :

> get [options] <source_path> <target_path>

- - source_path - remote file/directory path which is to be copied to local file system.

    if . copies all the file/directories in the remote working directory.

- - target_path - local directory path where the files/directories are to be copied to.

    if . files/directories are copied to the local working directory. if - Writes output to stdout.

- Options:

  -f, --force Overwrites the destination if it already exists.

### ls[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#ls)

List all the files and directories in the current working directory.

Usage :

> ls [option] [directory]…

- - directory - name of directory whose files/directories are to be listed.

    By default current working directory’s files/directories are listed.

- Options:

  -l, --long list with long format - show permissions -r, --reverse reverse sort -H human readable -a, -all ignore entries starting with . -S Sort by file_size

### cat[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#cat)

Concatenate files and print on the standard output

Usage :

> cat  <file>….

- file - name of the file

### cd[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#cd)

Change current working directory.

Usage :

> cd [directory]

- - directory - path/directory name. If no directory is mentioned it is changed to the root directory.

    If ‘.’ moves to the parent directory of the current directory.

### cwd[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#cwd)

Get current working directory.

Usage :

> cwd

### quit/Ctrl + D[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#quit-ctrl-d)

Close the shell.

### chmod[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#chmod)

Change the permissions of file/directory.

Usage :

> chmod <mode> <file/directory>

### mv[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#mv)

Moves files/Directory from source to destination.

Usage :

> mv <source_path> <destination_path>

### rmdir[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#rmdir)

Delete a directory(ies).

Usage :

> rmdir <directory_name>…..

### rm[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#rm)

Remove a file(es).

Usage :

> rm <file_name/pattern>…

### write[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#write)

Create and Write a file.

Usage :

> write <file_name> <Enter Data> Ctrl+D Exit.

### lls[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#lls)

Lists all files and directories in the specified directory.Current  local directory files and directories are listed if no     path is  mentioned

Usage:

> lls <path>…..

### lcd[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#lcd)

Moves into the given local directory.

Usage :

> lcd <path>

### lpwd[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#lpwd)

Prints the absolute path of the current local directory.

Usage :

> lpwd

### umask[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#umask)

Set and get the file mode creation mask

Usage :

> umask [mode]

### alias[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#alias)

Define or display aliases

Usage:

> alias [name] | [<name> <value>]

- name - name of the alias being looked up, added, or replaced
- value - what the alias will be resolved to (if adding or replacing) this can contain spaces and does not need to be quoted

### run_pyscript[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#run-pyscript)

Runs a python script file inside the console

Usage:

> run_pyscript <script_path> [script_arguments]

- Console commands can be executed inside this script with cmd (“your command”) However, you cannot run nested “py” or “pyscript” commands from within this script. Paths or arguments that contain spaces must be enclosed in quotes

Note

This command is available as `pyscript` for cmd2 versions 0.9.13 or less.

### py[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#py)

Invoke python command, shell, or script

Usage :

> py <command>: Executes a Python command. py: Enters interactive Python mode.

### shortcuts[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#shortcuts)

Lists shortcuts (aliases) available

Usage :

> shortcuts

### history[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#history)

View, run, edit, and save previously entered commands.

Usage :

> history [-h] [-r | -e | -s | -o FILE | -t TRANSCRIPT] [arg]

- Options:

  -h show this help message and exit -r run selected history items -e edit and then run selected history items -s script format; no separation lines -o FILE output commands to a script file -t TRANSCRIPT output commands and results to a transcript file

### unalias[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#unalias)

Unsets aliases

Usage :

> unalias [-a] name [name …]

- name - name of the alias being unset

- Options:

  -a remove all alias definitions

### set[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#set)

Sets a settable parameter or shows current settings of parameters.

Usage :

> set [-h] [-a] [-l] [settable [settable …]]

- Call without arguments for a list of settable parameters with their values.

- Options :

  -h show this help message and exit -a display read-only settings as well -l describe function of parameter

### edit[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#edit)

Edit a file in a text editor.

Usage:

> edit [file_path]

- file_path - path to a file to open in editor

### run_script[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#run-script)

Runs commands in script file that is encoded as either ASCII or UTF-8 text. Each command in the script should be separated by a newline.

Usage:

> run_script <file_path>

- file_path - a file path pointing to a script

Note

This command is available as `load` for cmd2 versions 0.9.13 or less.

### shell[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#shell)

Execute a command as if at the OS prompt.

Usage:

> shell <command> [arguments]

### locate[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#locate)

Find an item in File System

Usage:

> locate [options] <name>

- Options :

  -c Count number of items found -i Ignore case

### stat[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#stat)

Display file status.

Usage :

> stat [-h] <file_name> [file_name …]

- Options :

  -h Shows the help message

### snap[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#snap)

Create or Delete Snapshot

Usage:

> snap {create|delete} <snap_name> <dir_name>

- snap_name - Snapshot name to be created or deleted
- dir_name - directory under which snapshot should be created or deleted

### setxattr[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#setxattr)

Set extended attribute for a file

Usage :

> setxattr [-h] <path> <name> <value>

- path - Path to the file
- name - Extended attribute name to get or set
- value - Extended attribute value to be set

- Options:

  -h, --help Shows the help message

### getxattr[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#getxattr)

Get extended attribute value for the name associated with the path

Usage :

> getxattr [-h] <path> <name>

- path - Path to the file
- name - Extended attribute name to get or set

- Options:

  -h, --help Shows the help message

### listxattr[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#listxattr)

List extended attribute names associated with the path

Usage :

> listxattr [-h] <path>

- path - Path to the file

- Options:

  -h, --help Shows the help message

### df[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#df)

Display amount of available disk space

Usage :

> df [-h] [file [file …]]

- file - name of the file

- Options:

  -h, --help Shows the help message

### du[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#du)

Show disk usage of a directory

Usage :

> du [-h] [-r] [paths [paths …]]

- paths - name of the directory

- Options:

  -h, --help Shows the help message -r Recursive Disk usage of all directories

### quota[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#quota)

Quota management for a Directory

Usage :

> quota [-h] [--max_bytes [MAX_BYTES]] [--max_files [MAX_FILES]] {get,set} path

- {get,set} - quota operation type.
- path - name of the directory.

- Options :

  -h, --help Shows the help message --max_bytes MAX_BYTES Set max cumulative size of the data under this directory --max_files MAX_FILES Set total number of files under this directory tree

## CephFS Shell Configuration File[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#cephfs-shell-configuration-file)

By default, CephFS Shell looks for `cephfs-shell.conf` in the path provided by the environment variable `CEPHFS_SHELL_CONF` and then in user’s home directory (`~/.cephfs-shell.conf`).

Right now, CephFS Shell inherits all its options from its dependency `cmd2`. Therefore, these options might vary with the version of `cmd2` installed on your system. Refer to `cmd2` docs for a description of these options.

Following is a sample `cephfs-shell.conf`

```
[cephfs-shell]
prompt = CephFS:~/>>>
continuation_prompt = >

quiet = False
timing = False
colors = True
debug = False

abbrev = False
autorun_on_edit = False
echo = False
editor = vim
feedback_to_output = False
locals_in_py = True
```

## Exit Code[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#exit-code)

Following exit codes are returned by cephfs shell

| Error Type                                    | Exit Code |
| --------------------------------------------- | --------- |
| Miscellaneous                                 | 1         |
| Keyboard Interrupt                            | 2         |
| Operation not permitted                       | 3         |
| Permission denied                             | 4         |
| No such file or directory                     | 5         |
| I/O error                                     | 6         |
| No space left on device                       | 7         |
| File exists                                   | 8         |
| No data available                             | 9         |
| Invalid argument                              | 10        |
| Operation not supported on transport endpoint | 11        |
| Range error                                   | 12        |
| Operation would block                         | 13        |
| Directory not empty                           | 14        |
| Not a directory                               | 15        |
| Disk quota exceeded                           | 16        |
| Broken pipe                                   | 17        |
| Cannot send after transport endpoint shutdown | 18        |
| Connection aborted                            | 19        |
| Connection refused                            | 20        |
| Connection reset                              | 21        |
| Interrupted function call                     | 22        |

## Files[](https://docs.ceph.com/en/latest/man/8/cephfs-shell/#files)

```
~/.cephfs-shell.conf
```

​        