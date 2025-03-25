# CephFS

[TOC]

## 概述

Ceph 文件系统（CephFS）是一个基于 Ceph 分布式对象存储 RADOS 的 POSIX 兼容文件系统。CephFS 致力于为各种应用程序（包括共享 home 目录、HPC 暂存空间和分布式工作流共享存储等传统用例）提供最先进、多用途、高可用性和高性能的文件存储。

CephFS 通过使用一些新颖的架构选择来实现这些目标。值得注意的是，文件元数据存储在与文件数据分离的 RADOS 池中，并通过可调整大小的元数据服务器集群（MDS）提供服务。MDS 可以扩展以支持更高吞吐量的 metadata 工作负载。文件系统的 Client 可以直接访问 RADOS 以读取和写入文件数据块。因此，工作负载可能会随着底层 RADOS 对象存储的大小而线性扩展。也就是说，没有网关或代理为 Client 中介数据 I/O （mediating data I/O）。

通过 MDS 集群协调对数据的访问，MDS 集群充当客户端和 MDS 协同维护的分布式元数据缓存状态的权威。元数据的变化由每个 MDS 聚合为一系列有效的写入 RADOS 上的日志；MDS 不在本地存储元数据状态。该模型允许客户机在 POSIX 文件系统的上下文中进行一致且快速的协作。

![](../../Image/c/cephfs-architecture.svg)

CephFS 因其新颖的设计和对文件系统研究的贡献而成为众多学术论文的主题。它是 Ceph 中最古老的存储接口，曾经是 RADOS 的主要用例。现在，它由另两个存储接口连接起来，形成了一个现代的统一存储系统：RBD（Ceph Block Devices）和 RGW（Ceph Object storage Gateway）。

## 部署 MDS 服务

要使用 CephFS 文件系统，需要一个或多个 MDS 守护程序。默认情况下，CephFS 仅使用一个活跃的 MDS 守护进程。

集群运营商通常会根据需要使用其自动化部署工具来启动所需的 MDS 服务器。Rook 和 ansible（通过 ceph-ansible playbook）是推荐的工具。

如果使用较新的 `ceph fs volume` 接口创建新文件系统，则会自动创建这些。

```bash
ceph fs volume create <fs name>
ceph fs volume create <fs_name> --placement="<placement spec>"
```

其中 `fs_name` 是 CephFS 的名称，`placement` 是一个 [Daemon Placement](https://docs.ceph.com/en/latest/cephadm/services/#orchestrator-cli-placement-spec) 。

如果后端部署技术支持，Ceph Orchestrator 将自动为文件系统创建和配置 MDS 。否则，请根据需要手动部署 MDS 。

命令行 shell 实用程序 `cephfs-shell` 可用于进行交互访问或编写脚本。

对于手动部署 MDS 守护程序，请使用以下规范：

```yaml
service_type: mds
service_id: fs_name
placement:
  count: 3
  label: mds
```

然后可以使用以下方法应用本规范：

```bash
ceph orch apply -i mds.yaml
```

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

You can also update the placement after-the-fact via:
您还可以通过以下方式在事后更新版面：

```bash
ceph orch apply mds foo 'mds-[012]'
```

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

  3. 使用 `ceph orch apply` 命令部署 MDS 服务：

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

使用 `ceph orch rm` 命令从整个集群中删除 MDS 服务： 				

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

Each CephFS file system requires at least one MDS. The cluster operator will generally use their automated deployment tool to launch required MDS servers as needed.  Rook and ansible (via the ceph-ansible playbooks) are recommended tools for doing this. For clarity, we also show the systemd commands here which may be run by the deployment technology if executed on bare-metal.

See [MDS Config Reference](https://docs.ceph.com/en/latest/cephfs/mds-config-ref) for details on configuring metadata servers.

## 添加 MDS

1. 创建一个目录 `/var/lib/ceph/mds/ceph-${id}` 。守护进程仅使用此目录来存储其密钥环。

2. 如果使用 CephX，创建身份验证密钥：

   ```bash
   ceph auth get-or-create mds.${id} mon 'profile mds' mgr 'profile mds' mds 'allow *' osd 'allow *' > /var/lib/ceph/mds/ceph-${id}/keyring
   ```

3. 启动服务：

   ```bash
   systemctl start ceph-mds@${id}
   ```

4. 群集的状态应显示：

   ```bash
   mds: ${id}:1 {0=${id}=up:active} 2 up:standby
   ```

5. 配置 MDS 和文件系统关联（可选）：

   ```bash
   ceph config set mds.${id} mds_join_fs ${fs}
   ```

## 删除 MDS

如果想删除集群中的 MDS ，可以使用以下方法。

1. （可选）创建新的替换 MDS 。如果在删除 MDS 后没有替代 MDS 来接管，则文件系统将对客户端不可用。如果不希望这样做，请考虑在拆除要脱机的 MDS 之前添加元数据服务器。

2. 停止要删除的 MDS 。

   ```bash
   systemctl stop ceph-mds@${id}
   ```

   MDS 将自动通知 Ceph MON 其正在关闭。This enables the monitors to perform instantaneous failover to an available standby, if one exists. 这使 MON 能够执行到可用备用设备（如果存在）的瞬时故障转移。不需要使用管理命令来实现这种故障转移，例如通过使用 `ceph mds fail mds.${id}` 。

3. 删除 MDS 上的 `/var/lib/ceph/mds/ceph-${id}` 目录。

   ```bash
   rm -rf /var/lib/ceph/mds/ceph-${id}
   ```

## 部署 CephFS

### 创建 pool

CephFS 至少需要两个 RADOS 池，一个用于数据，一个用于元数据。配置这些池时，可能会考虑：

- 建议为元数据池配置至少 3 个副本，因为此池中的数据丢失会导致整个文件系统无法访问。配置 4 个副本并不极端，尤其是因为元数据池的容量需求非常有限。
- 建议元数据池使用最快的低延迟存储设备（ NVMe、Optane 或至少 SAS / SATA SSD ），因为这将直接影响客户端文件系统操作的延迟。
- 强烈建议在专用 SSD / NVMe OSD 上配置 CephFS 元数据池。这确保了高客户端工作负载不会对元数据操作产生不利影响。
- 用于创建文件系统的数据池是 “default” 数据池，是存储所有 inode 回溯信息的位置，用于硬链接管理和灾难恢复。因此，所有 CephFS inode 在 default 数据池中至少有一个对象。如果计划为文件系统数据创建擦除编码池，则最好将 default 池配置为复制池，以提高更新回溯时的小对象读写性能。另外，还可以添加另一个擦除编码数据池，该数据池可用于整个目录和文件层次结构。

使用默认设置创建两个池以用于文件系统：

```bash
ceph osd pool create cephfs_data
ceph osd pool create cephfs_metadata
```

元数据池通常最多可容纳数 GB 的数据。因此，通常建议使用较小的 PG 计数。64 或 128 在实践中通常用于大型集群。

> **Note：**
>
> 文件系统、元数据池和数据池的名称只能包含集合 [a-zA-Z0-9_-.] 中的字符。

### 创建文件系统

使用 `fs new` 命令新建文件系统：

```bash
ceph fs new <fs_name> <metadata> <data> [--force] [--allow-dangerous-metadata-overlay] [<fscid:init>] [--recover]
```

此命令使用指定的元数据和数据池创建新的文件系统。指定的数据池是 default 数据池，一旦设置就无法更改。Each file system has its own set of MDS daemons assigned to ranks 每个文件系统都有自己的一组 MDS 守护程序分配给列组，因此确保您有足够的备用守护程序来容纳新的文件系统。

`--force` 选项用于实现以下任何一项：

- 为 default 数据池设置擦除编码池。不鼓励将 EC 池用作默认数据池。
- 为元数据池设置非空池（池已包含一些对象）。
- 创建具有特定文件系统 ID（fscid）的文件系统。--force 选项是 --fscid 选项所必需的。

`--allow-dangerous-metadata-overlay` 选项允许重用元数据和数据池（如果它已经在使用）。只有在紧急情况下，并在仔细阅读文件后，才能执行此操作。

如果提供了 `--fscid` 选项，这将创建具有特定 fscid 的文件系统。当应用程序希望文件系统的 ID 在恢复后保持稳定时，可以使用此选项。例如，在 MON 数据库丢失并重建后，可以使用此选项。因此，文件系统 ID 并不总是随着更新的文件系统而增加。

`--recover` option sets the state of file system’s rank 0 to existing but failed.选项将文件系统的 rank 0 的状态设置为 existing but failed 。因此，当一个 MDS 守护程序最终选择了 rank 0 时，该守护程序将读取 RADOS 中现有的元数据，并且不会覆盖它。该标志还阻止备用 MDS 守护程序加入文件系统。

例如：

```bash
ceph fs new cephfs cephfs_metadata cephfs_data
```

创建文件系统后，MDS 将能够进入 *active* 状态。例如，在单个 MDS 系统中：

```bash
ceph mds stat
cephfs-1/1/1 up {0=a=up:active}
```

一旦创建了文件系统并且 MDS 处于活动状态，就可以挂载文件系统了。如果创建了多个文件系统，将选择在装载时使用哪个文件系统。挂载方式有多种可选：

* Mount CephFS
* Mount CephFS as FUSE
* Mount CephFS on Windows

### 列出文件系统

按名称列出所有文件系统：

```bash
ceph fs ls
name: cephfs, metadata pool: cephfs_metadata, data pools: [cephfs_data ]
```

列出文件系统上设置的所有标志：

```bash
ceph fs lsflags <file system name>
```

这将转储给定时期（默认值：current ）的 FSMap ，其中包括所有文件系统设置、MDS 守护进程及其持有的 rank ，以及备用 MDS 守护进程列表。

```bash
ceph fs dump [epoch]
```

获取有关命名文件系统的信息，包括设置和 rank 。这是来自 `ceph fs dump` 命令的相同信息的子集。

```bash
fs get <file system name>
```

### 修改文件系统设置

更改文件系统上的设置。这些设置特定于指定的文件系统，不会影响其他文件系统。

```bash
ceph fs set <file system name> <var> <val>
```

CephFS 有一个可配置的最大文件大小，默认情况下为 1TB 。如果希望在 CephFS 中存储大型文件，则可能希望将此限制设置得更高。它是一个 64 位字段。

将 `max_file_size` 设置为 0 不会禁用限制。它只会限制客户端只创建空文件。

```bash
ceph fs set <fs name> max_file_size <size in bytes>
```

### 删除文件系统

销毁 CephFS 文件系统。这将从 FSMap 中擦除有关文件系统状态的信息。元数据池和数据池是未动的，必须单独销毁。需要先关闭对应的 MDS 。

```bash
ceph fs rm <file system name> [--yes-i-really-mean-it]
```

### 文件系统添加/删除数据池

将数据池添加到文件系统。此池可用于文件布局，作为存储文件数据的备用位置。

```bash
ceph fs add_data_pool <file system name> <pool name/id>
```

此命令将从文件系统的数据池列表中删除指定的池。If any files have layouts for the removed data pool, the file data will become unavailable. 如果任何文件具有已删除数据池的布局，则文件数据将变得不可用。无法删除默认数据池（在创建文件系统时）。

```bash
ceph fs rm_data_pool <file system name> <pool name/id>
```

### 重命名文件系统

重命名 Ceph 文件系统。这还会将文件系统的数据池和元数据池上的应用程序标记更改为新的文件系统名称。授权给旧文件系统名称的 CephX ID 需要重新授权为新名称。使用这些 ID 的客户端的任何正在进行的操作可能会中断。应在文件系统上禁用镜像。

```bash
fs rename <file system name> <new file system name> [--yes-i-really-mean-it]
```

### 使用 CephFS 的擦除编码池

可以使用 Erasure Coded 池作为 CephFS 数据池，只要它们启用了覆盖，操作如下：

```bash
ceph osd pool set my_ec_pool allow_ec_overwrites true
```

注意，只有在使用带有 BlueStore 后端的 OSD 时才支持 EC 重写。

不能将 Erasure Coded 池用作 CephFS 元数据池，因为 CephFS 的元数据是使用 RADOS OMAP 数据结构存储的，而 EC 池无法存储这些数据结构。

## 最大文件大小和性能

CephFS enforces the maximum file size limit at the point of appending to files or setting their size. CephFS 在附加到文件或设置其大小时强制执行最大文件大小限制。它不会影响任何东西的存储方式。

When users create a file of an enormous size (without necessarily writing any data to it), some operations (such as deletes) cause the MDS to have to do a large number of operations to check if any of the RADOS objects within the range that could exist (according to the file size) really existed.当用户创建一个巨大的文件时（不需要向其中写入任何数据），某些操作（如删除）会导致 MDS 必须执行大量操作，以检查可能存在的范围内（根据文件大小）是否真的存在任何 RADOS 对象。

The `max_file_size` setting prevents users from creating files that appear to be eg. exabytes in size, causing load on the MDS as it tries to enumerate the objects during operations like stats or deletes.

`max_file_size` 设置防止用户创建看起来像是 EB 大小，导致 MDS 在尝试在统计或删除等操作期间枚举对象时负载。

## 关闭/开启集群

关闭 CephFS 集群是通过设置 down 标志来完成的：

```bash
ceph fs set <fs_name> down true
```

要使群集重新联机，请执行以下操作：

```bash
ceph fs set <fs_name> down false
```

这也将恢复 max_mds 的先前值。MDS 守护进程关闭的方式是将日志刷新到元数据池，并停止所有客户端 I/O 。

## 快速关闭群集以进行删除或灾难恢复

要允许快速删除文件系统（用于测试）或快速关闭文件系统和MDS守护程序，请使用 `ceph fs fail` 命令：

```bash
ceph fs fail <fs_name>
```

This command sets a file system flag to prevent standbys from activating on the file system (the `joinable` flag).此命令设置文件系统标志，以防止在文件系统上激活备用文件（可 `joinable` 标志）。

此过程也可以通过执行以下操作手动完成：

```bash
ceph fs set <fs_name> joinable false
```

然后操作员可以使所有 rank 失败，这导致 MDS 守护程序作为备用程序重新生成。文件系统将处于降级状态。

```bash
# For all ranks, 0-N:
ceph mds fail <fs_name>:<n>
```

一旦所有 rank 都处于非活动状态，文件系统也可能被删除或出于其他目的（可能是灾难恢复）而保持此状态。

要恢复集群，只需设置 joinable 标志：

```bash
ceph fs set <fs_name> joinable true
```

## Daemons

大多数操作 MDS 的命令都带有一个 `<role>` 参数，该参数可以采用以下三种形式之一：

```bash
<fs_name>:<rank>
<fs_id>:<rank>
<rank>
```

将 MDS 守护程序标记为失败。这相当于在 MDS 守护进程未能在 `mds_beacon_grace` 秒内向 MON 发送消息时群集将执行的操作。如果守护进程处于活动状态，并且有合适的备用进程可用，则使用 `ceph mds fail` 将强制故障转移到备用进程。

```bash
ceph mds fail <gid/name/role>
```

如果 MDS 守护程序实际上仍在运行，则使用 `ceph mds fail` 将导致守护程序重新启动。如果它是活动的，并且有一个备用的，那么 “failed” 的守护进程将作为备用的返回。

Send a command to the MDS daemon(s). Use `mds.*` to send a command to all daemons. Use `ceph tell mds.* help` to learn available commands.

向 MDS 守护程序发送命令。使用 `mds.*` 向所有守护进程发送命令。使用 `ceph tell mds.* help` 帮助学习可用的命令。

```bash
ceph tell mds.<daemon name> command ...
```

获取关于 给定MDS 已知的元数据给 MON 。Get metadata about the given MDS known to the Monitors.

```bash
ceph mds metadata <gid/name/role>
```

将文件系统 rank 标记为已修复。与名称不同，此命令不会更改 MDS ；it manipulates the file system rank which has been marked damaged.它会操作已标记为损坏的文件系统级别。

```bash
ceph mds repaired <role>
```

## 所需客户端功能

有时需要设置客户端必须支持某些功能才能与 CephFS 通信。没有这些功能的客户端可能会干扰其他客户端或以令人惊讶的方式行事。或者，可能需要更新的功能，以防止旧的和可能有错误的客户端连接。

用于操作文件系统所需的客户端功能的命令：

```bash
ceph fs required_client_features <fs name> add reply_encoding
ceph fs required_client_features <fs name> rm reply_encoding
```

列出所有 CephFS 功能：

```bash
ceph fs feature ls
```

缺少新添加功能的客户端将被自动逐出。

以下是当前 CephFS 的功能和它们发布的第一个版本：

| Feature          | Ceph release | Upstream Kernel | 描述                                                         |
| ---------------- | ------------ | --------------- | ------------------------------------------------------------ |
| jewel            | jewel        | 4.5             |                                                              |
| kraken           | kraken       | 4.13            |                                                              |
| luminous         | luminous     | 4.13            |                                                              |
| mimic            | mimic        | 4.19            |                                                              |
| reply_encoding   | nautilus     | 5.1             | 如果客户端支持此功能，MDS 将以可扩展格式对请求应答进行编码。 |
| reclaim_client   | nautilus     | N/A             | MDS 允许新客户端回收另一个（dead）客户端的状态。此功能由 NFS-Ganesha 使用。 |
| lazy_caps_wanted | nautilus     | 5.1             | 当一个过时的客户端恢复时，如果客户端支持这个特性，mds 只需要重新发出明确需要的上限。 |
| multi_reconnect  | nautilus     | 5.1             | 当 mds 故障转移时，客户端向 mds 发送重新连接消息，以重新建立缓存状态。如果 MDS 支持此功能，则客户端可以将大的重新连接消息拆分为多个消息。 |
| deleg_ino        | octopus      | 5.6             | 如果客户端支持此功能，则 MDS 将信息节点编号委托给客户端。Having delegated inode numbers is a prerequisite for client to do async file creation.委托了 inode 编号是客户端创建 dataset 文件的先决条件。 |
| metric_collect   | pacific      | N/A             | 如果 MDS 支持此功能，则客户端可以向 MDS 发送性能度量。       |
| alternate_name   | pacific      | PLANNED         | 客户端可以设置和理解目录条目的“alternate names备用名称”。这将用于支持加密文件名。 |

## 全局设置

```bash
ceph fs flag set <flag name> <flag val> [<confirmation string>]
```

设置一个全局 CephFS 标志（即不特定于特定的文件系统）。目前，唯一的标志设置是 “enable_multiple” ，它允许拥有多个 CephFS 文件系统。

有些标志要求你用 “--yes-i-really-mean-it” 或类似的字符串来确认你的意图。在继续之前仔细考虑这些行动;他们被置于特别危险的活动中。

## Advanced

这些命令在正常操作中是不需要的，并且在特殊情况下使用。不正确使用这些命令可能会导致严重的问题，例如无法访问文件系统。

This removes a rank from the failed set.这将从失败集合中删除一个等级。

```bash
ceph mds rmfailed
```

此命令将文件系统状态重置为默认值（名称和池除外）。Non-zero ranks are saved in the stopped set.非零 rank 保存在停止集合中。

```bash
ceph fs reset <file system name>
```

此命令创建一个具有特定 fscid（文件系统群集 ID ）的文件系统。当应用程序希望文件系统的 ID 在恢复后保持稳定时，可能需要执行此操作，例如，监控数据库丢失后重建。因此，文件系统 ID 并不总是随着更新的文件系统而不断增加。

```bash
ceph fs new <file system name> <metadata pool name> <data pool name> --fscid <fscid> --force
```

## 多个 Ceph 文件系统

默认情况下只允许创建一个文件系统。

如果创建了多个文件系统，并且客户机在装载时未指定文件系统，则可以使用 `ceph fs set-default` 命令控制客户端将看到的文件系统。

从 Pacific 发行版开始，多文件系统支持变得稳定并可随时使用。此功能允许配置单独的文件系统，并在单独的池上进行完全数据分离。

现有群集必须设置标志才能启用多个文件系统：

```bash
ceph fs flag set enable_multiple true
```

新的 Ceph 集群会自动设置此选项。

### 创建新的 Ceph 文件系统

新的 `volumes` 插件接口自动化了配置新文件系统的大部分工作。“卷”概念只是一个新的文件系统。这可以通过以下方式实现：

```bash
ceph fs volume create <fs_name>
```

Ceph 将创建新池并自动部署新 MDS 以支持新文件系统。所使用的部署技术（例如 cephadm ）还将配置新 MDS 守护进程的 MDS 关联以操作新文件系统。

### 安全访问

`ceph fs authorize` 命令允许配置客户端对特定文件系统的访问。客户端将只能看到授权的文件系统，并且MON / MDS 将拒绝对未经授权的客户端的访问。

### 其他说明

多个文件系统不共享池。This is particularly important for snapshots but also because no measures are in place to prevent duplicate inodes. 这对于快照尤其重要，但也是因为没有采取措施来防止重复的 inode 。Ceph 命令可以防止这种危险的配置。

每个文件系统都有自己的 MDS rank 。因此，每个新的文件系统都需要更多的 MDS 守护程序来运行，并增加了运营成本。这对于按应用程序或用户群增加元数据吞吐量很有用，但也增加了创建文件系统的成本。Generally, a single file system with subtree pinning is a better choice for isolating load between applications.通常，使用子树固定的单个文件系统是隔离应用程序之间负载的更好选择。

## Referring to MDS daemons

大多数用于 MDS 的管理命令都接受灵活的参数格式，可以指定 `rank` 、 `GID` 或 `name` 。

Where a `rank` is used, it  may optionally be qualified by a leading file system `name` or `GID`. 在使用 `rank` 的情况下，它可以可选地由前导文件系统名称或GID限定。如果一个守护进程是一个备用进程（即它当前没有被分配一个 `rank` ），那么它只能通过 `GID` 或 `name` 来引用。

例如，假设有一个 `name` 为 “myhost” 和 `GID`  5446 的 MDS 守护程序，and which is assigned `rank` 0 for the file system ‘myfs’ with `FSCID` 3. 并且它被分配了 FSCID 3的文件系统“myfs”的rank 0。以下任何一种都是 `fail` 命令的合适形式：

```bash
ceph mds fail 5446     # GID
ceph mds fail myhost   # Daemon name
ceph mds fail 0        # Unqualified rank
ceph mds fail 3:0      # FSCID and rank
ceph mds fail myfs:0   # File System name and rank
```

## 管理故障转移

如果 MDS 守护程序停止与群集的 MON 通信，MON 将等待 `mds_beacon_grace` 秒（默认值为 15），然后将守护程序标记为 `laggy` 。如果备用 MDS 可用，MON 将立即替换滞后的守护进程。

每个文件系统都可以指定最小数量的备用守护进程，以便被认为是健康的。This number includes daemons in the `standby-replay` state waiting for a `rank` to fail. 此数量包括处于 `standby-replay` 状态的守护进程，等待某个 `rank` 失败。(Note，a `standby-replay` daemon will not be assigned to take over a failure for another `rank` or a failure in a different CephFS file system.MON 不会分配 `standby-replay` 守护程序来接管另一个列的故障或不同CephFS文件系统中的故障）。The pool of standby daemons not in `replay` counts towards any file system count.不在重放中的备用守护进程池计入任何文件系统计数。每个文件系统可以通过以下方式设置所需的备用守护进程数量：

```bash
ceph fs set <fs name> standby_count_wanted <count>
```

将 `count` 设置为 0 将禁用运行状况检查。

## 配置 standby-replay

每个 CephFS 文件系统都可以配置为添加 `standby-replay` 守护进程。这些备用守护程序遵循活动 MDS 的元数据日志，以便在活动 MDS 不可用时缩短故障转移时间。每个活动 MDS 只能有一个 `standby-replay` 守护进程。

在文件系统上配置 `standby-replay` 是使用以下方法完成的：

```bash
ceph fs set <fs name> allow_standby_replay <bool>
```

设置后，MON 将分配可用的备用守护进程来跟踪该文件系统中的活动 MDS 。

一旦 MDS 进入 `standby-replay` 状态，它将仅被用作它所跟随的 `rank` 的备用。如果另一个 `rank` 失败，这个 `standby-replay` 守护进程将不会被用作替代，即使没有其他备用进程可用。因此，建议如果使用 `standby-replay` ，则每个活动 MDS 都应该有一个 `standby-replay` 守护程序。

## 配置 MDS 文件系统关联性

可以选择将 MDS 专用于特定的文件系统。或者，也许有在更好的硬件上运行的 MDS ，在适度或过度配置的系统上，这些硬件应该优于最后的备用硬件。要配置此首选项，CephFS 为 MDS 提供了一个名为 `mds_join_fs` 的配置选项，该选项强制执行此关联。

在对 MDS 守护进程进行故障切换时，a cluster’s monitors will prefer standby daemons with `mds_join_fs` equal to the file system `name` with the failed `rank`.  群集的 MON 将优先使用 `mds_join_fs` 等于具有故障 `rank` 的文件系统 `name` 的备用守护进程。如果不存在 `mds_join_fs` 等于文件系统 `name` 的备用守护进程，it will choose an unqualified standby (no setting for `mds_join_fs`) for the replacement它将选择一个不合格的备用文件（没有mds_join_fs设置）进行替换。作为最后的手段，将选择另一个文件系统的备用守护进程，尽管可以禁用此行为：

```bash
ceph fs set <fs name> refuse_standby_for_another_fs true
```

请注意，配置 MDS 文件系统关联性不会更改始终在其他备用守护进程之前选择 `standby-replay` 守护进程的行为。

Even further, the monitors will regularly examine the CephFS file systems even when stable to check if a standby with stronger affinity is available to replace an MDS with lower affinity. 此外，即使 CephFS 文件系统稳定，MON 也会定期检查 CephFS 文件系统，以检查是否有更强亲和力的备用守护进程可用于替换亲和力较低的 MDS 。这个过程也适用于 `standby-replay` 守护进程：如果一个常规备用守护进程比 `standby-replay`  MDS 具有更强的亲和力，它将替换  `standby-replay`  MDS。

例如，给定此稳定且健康的文件系统：

```bash
ceph fs dump

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

您可以在备用服务器上设置 `mds_join_fs` 以强制执行您的首选项：

```bash
ceph config set mds.b mds_join_fs cephfs
```

自动故障切换后：

```bash
ceph fs dump

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

请注意，在上面的示例中， `mds.b` 现在的 `join_fscid=27` 。在此输出中， `mds_join_fs` 中的文件系统名称被更改为文件系统标识符（27）。如果使用相同的名称重新创建文件系统，If the file system is recreated with the same name, the standby will follow the new file system as expected.则备用系统将按照预期遵循新的文件系统。

最后，如文件系统 degraded or undersized降级或规模过小，则不会发生故障转移来强制执行 `mds_join_fs` 。



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

##   分布式文件系统的应用程序最佳实践

CephFS 与 POSIX 兼容，and therefore should work with any existing applications that expect a POSIX file system.  因此应该与任何需要 POSIX 文件系统的现有应用程序一起工作。然而，因为它是一个网络文件系统（不像 XFS），并且它是高度一致的（不像 NFS ），所以有一些应用程序作者可以从中受益。

The following sections describe some areas where distributed file systems may have noticeably different performance behaviours compared with local file systems.以下部分描述了分布式文件系统与本地文件系统相比可能具有明显不同的性能行为的一些领域。

### ls -l

当您运行 `ls -l` 时，`ls` 程序首先列出目录，然后对目录中的每个文件调用 `stat` 。

这通常远远超过应用程序的实际需要，并且对于大型目录来说可能会很慢。如果不需要每个文件的所有这些元数据，那么使用一个简单的 `ls` 。

### 正在扩展的文件上的 ls/stat

If another client is currently extending files in the listed directory,如果另一个客户端当前正在扩展列出的目录中的文件，那么 `ls -l` 可能需要非常长的时间才能完成，因为 lister 必须等待 writer 刷新数据，以便有效地读取每个文件的大小。所以，除非你真的需要知道目录中每个文件的确切大小，否则不要这样做！

This would also apply to any application code that was directly issuing `stat` system calls on files being appended from another node.这也适用于直接对从另一个节点追加的文件发出stat系统调用的任何应用程序代码。

### 非常大的目录

你真的需要那包含 1000 万个文件的目录吗？While directory fragmentation enables CephFS to handle it, it is always going to be less efficient than splitting your files into more modest-sized directories.虽然目录碎片使CephFS能够处理它，但它总是比将文件拆分到更适度大小的目录中效率更低。

即使是标准的用户空间工具在操作非常大的目录时也会变得非常慢。例如，`ls` 的默认行为是给予一个有序的结果，但是 `readdir` 系统调用并不给予一个有序的结果（这通常是正确的，而不仅仅是 CephFS ）。因此，当你在一个百万文件目录上 `ls` 时，它会将一个包含一百万个名称的列表加载到内存中，对列表进行排序，然后将其写入显示器。

### 硬链接

Hard links have an intrinsic cost in terms of the internal housekeeping that a file system has to do to keep two references to the same data. 硬链接在内部管理方面具有内在成本，文件系统必须进行内部管理以保持对同一数据的两个引用。In CephFS there is a particular performance cost, because with normal files the inode is embedded in the directory (i.e. there is no extra fetch of the inode after looking up the path).在 CephFS 中，有一个特殊的性能成本，因为对于普通文件，inode 嵌入在目录中（即在查找路径后没有额外的inode获取）。

### Working set size工作集大小

MDS 充当存储在 RADOS 中的元数据的缓存。Metadata performance is very different for workloads whose metadata fits within that cache.对于元数据适合该缓存的工作负载，元数据性能有很大不同。

如果您的工作负载中的文件数超过缓存容量（使用 `mds_cache_memory_limit` 设置进行配置），请确保进行了适当的测试：不要使用少量文件测试系统，然后期望在移动到大量文件时获得同等性能。

### 你需要一个文件系统吗？

请记住，Ceph 还包括一个对象存储接口。If your application needs to store huge flat collections of files where you just read and write whole files at once, then you might well be better off using the [Object Gateway](https://docs.ceph.com/en/latest/radosgw/#object-gateway)如果您的应用程序需要存储巨大的文件平面集合，您只需一次读写整个文件，那么您最好使用 Object Gateway 。



# Experimental Features[](https://docs.ceph.com/en/latest/cephfs/experimental-features/#experimental-features)

CephFS includes a number of experimental features which are not fully stabilized or qualified for users to turn on in real deployments. We generally do our best to clearly demarcate these and fence them off so they cannot be used by mistake.

Some of these features are closer to being done than others, though. We describe each of them with an approximation of how risky they are and briefly describe what is required to enable them. Note that doing so will *irrevocably* flag maps in the monitor as having once enabled this flag to improve debugging and support processes.

## Inline data[](https://docs.ceph.com/en/latest/cephfs/experimental-features/#inline-data)

By default, all CephFS file data is stored in RADOS objects. The inline data feature enables small files (generally <2KB) to be stored in the inode and served out of the MDS. This may improve small-file performance but increases load on the MDS. It is not sufficiently tested to support at this time, although failures within it are unlikely to make non-inlined data inaccessible

Inline data has always been off by default and requires setting the `inline_data` flag.

Inline data has been declared deprecated for the Octopus release, and will likely be removed altogether in the Q release.

## Mantle: Programmable Metadata Load Balancer[](https://docs.ceph.com/en/latest/cephfs/experimental-features/#mantle-programmable-metadata-load-balancer)

Mantle is a programmable metadata balancer built into the MDS. The idea is to protect the mechanisms for balancing load (migration, replication, fragmentation) but stub out the balancing policies using Lua. For details, see [Mantle](https://docs.ceph.com/en/latest/cephfs/mantle/).

## LazyIO[](https://docs.ceph.com/en/latest/cephfs/experimental-features/#lazyio)

LazyIO relaxes POSIX semantics. Buffered reads/writes are allowed even when a file is opened by multiple applications on multiple clients. Applications are responsible for managing cache coherency themselves.