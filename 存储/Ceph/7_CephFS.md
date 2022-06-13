# CephFS

[TOC]

## 准备工作

Ceph 文件系统（CephFS）是一个兼容 POSIX 的文件系统，构建在 Ceph 的分布式对象存储 RADOS 之上。Ceph FS 致力于为各种应用程序（including traditional use-cases like shared home directories, HPC scratch space, and distributed workflow shared storage包括共享主目录、HPC暂存空间和分布式工作流共享存储等传统用例）提供最先进、多用途、高可用性和高性能的文件存储。

CephFS achieves these goals through the use of some novel architectural choices.通过使用一些新颖的架构选择来实现这些目标。值得注意的是，文件元数据存储在与文件数据分离的 RADOS 池中，并通过可调整大小的元数据服务器集群（MDS）提供服务。MDS 可以扩展以支持更高吞吐量的 metadata 工作负载。文件系统的 Client 可以直接访问 RADOS 以读取和写入文件数据块。因此，工作负载可能会随着底层 RADOS 对象存储的大小而线性扩展。也就是说，没有网关或代理为 Client 中介数据 I/O （mediating data I/O）。

Access to data is coordinated through the cluster of MDS which serve as authorities for the state of the distributed metadata cache cooperatively maintained by clients and MDS. 对数据的访问通过MDS集群进行协调，MDS集群作为客户端和MDS协同维护的分布式元数据缓存状态的权威。Mutations to metadata are aggregated by each MDS into a series of efficient writes to a journal on RADOS; 元数据的突变由每个MDS聚合成一系列有效的写入RADOS上的日志；MDS不在本地存储元数据状态。This model allows for coherent and rapid collaboration between clients within the context of a POSIX file system.该模型允许在POSIX文件系统的上下文中，客户机之间进行一致和快速的协作。

![](../../Image/c/cephfs-architecture.svg)

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

## 创建 CephFS

### 创建 pool

一个 CephFS 至少需要两个 RADOS 池，一个用于数据，一个用于元数据。配置这些池时，可能会考虑：

- Using a higher replication level for the metadata pool, as any data loss in this pool can render the whole file system inaccessible.对元数据池使用更高的复制级别，因为此池中的任何数据丢失都可能导致整个文件系统无法访问。
- Using lower-latency storage such as SSDs for the metadata pool, as this will directly affect the observed latency of file system operations on clients.使用较低延迟的存储（如ssd）作为元数据池，因为这将直接影响在客户端上观察到的文件系统操作延迟。
- The data pool used to create the file system is the “default” data pool and the location for storing all inode backtrace information, used for hard link management and disaster recovery. For this reason, all inodes created in CephFS have at least one object in the default data pool. If erasure-coded pools are planned for the file system, it is usually better to use a replicated pool for the default data pool to improve small-object write and read performance for updating backtraces. Separately, another erasure-coded data pool can be added (see also [Erasure code](https://docs.ceph.com/en/latest/rados/operations/erasure-code/#ecpool)) that can be used on an entire hierarchy of directories and files (see also [File layouts](https://docs.ceph.com/en/latest/cephfs/file-layouts/#file-layouts)).用于创建文件系统的数据池是“默认”数据池，是存储所有inode回溯信息的位置，用于硬链接管理和灾难恢复。因此，在Ceph  FS中创建的所有inode在默认数据池中至少有一个对象。如果为文件系统规划了擦除编码池，则通常最好为默认数据池使用复制池，以提高用于更新回溯的小对象读写性能。另外，还可以添加另一个擦除编码的数据池（另请参阅擦除代码），该数据池可用于整个目录和文件层次结构（另请参阅文件布局）。

Refer to [Pools](https://docs.ceph.com/en/latest/rados/operations/pools/) to learn more about managing pools.  For example, to create two pools with default settings for use with a file system, you might run the following commands:

```
$ ceph osd pool create cephfs_data
$ ceph osd pool create cephfs_metadata
```

Generally, the metadata pool will have at most a few gigabytes of data. For this reason, a smaller PG count is usually recommended. 64 or 128 is commonly used in practice for large clusters.

Note

The names of the file systems, metadata pools, and data pools can only have characters in the set [a-zA-Z0-9_-.].

### Creating a file system

Once the pools are created, you may enable the file system using the `fs new` command:

```
$ ceph fs new <fs_name> <metadata> <data>
```

For example:

```
$ ceph fs new cephfs cephfs_metadata cephfs_data
$ ceph fs ls
name: cephfs, metadata pool: cephfs_metadata, data pools: [cephfs_data ]
```

Once a file system has been created, your MDS(s) will be able to enter an *active* state.  For example, in a single MDS system:

```
$ ceph mds stat
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

1. 确认你使用了合适的内核版本。

   ```bash
   lsb_release -a
   uname -r
   ```

2. 在管理节点上，通过 `ceph-deploy` 把 Ceph 安装到 `ceph-client` 节点上。

   ```bash
   ceph-deploy install ceph-client
   ```

3. 确保 Ceph 存储集群在运行，且处于 `active + clean` 状态。同时，确保至少有一个 MON 在运行。

   ```bash
   ceph -s [-m {monitor-ip-address}] [-k {path/to/ceph.client.admin.keyring}]
   ```

## 创建存储池和文件系统

```bash
ceph osd pool create cephfs_data <pg_num>
ceph osd pool create cephfs_metadata <pg_num>
ceph fs new <fs_name> cephfs_metadata cephfs_data
```

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
