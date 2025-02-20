# MicroCeph

[TOC]

## 概述

MicroCeph 是启动和运行 Ceph 的最简单方法。

MicroCeph 是部署和管理 Ceph 集群的一种轻量级方式。Ceph 是一个高度可扩展的开源分布式存储系统，旨在为对象、块和文件级存储提供卓越的性能、可靠性和灵活性。

通过简化密钥分发、服务放置和磁盘管理，简化了 Ceph 集群管理，从而实现快速、轻松的部署和操作。这适用于跨私有云、边缘云以及家庭实验室和单个工作站的集群。

MicroCeph 专注于为 Ceph 管理员和存储软件开发人员提供现代部署和管理体验。

## 安装

### 要求

需要以下内容：

- 最新的 Ubuntu LTS 版本。
- 2 个 CPU 内核。
- 4 GiB 内存。
- 12GiB 磁盘空间。
- 互联网连接。

### 单节点安装

The above will be achieved through the use of loop files placed on the root disk, which is a convenient way for setting up small test and development clusters.
以上将通过使用放置在根磁盘上的循环文件来实现，这是设置小型测试和开发集群的便捷方式。

> **警告：**
>
> Basing a Ceph cluster on a single disk also necessarily leads to a common failure domain for all OSDs.
> 使用专用块设备将为连接客户端带来最佳的 IOPS 性能。将 Ceph 集群基于单个磁盘也必然会导致所有 OSD 都出现共同的故障域。由于这些原因，不应在生产环境中使用loop循环文件。

#### 安装软件

安装 MicroCeph 的最新稳定版本：

```bash
snap install microceph
```

接下来，防止软件自动更新：

```bash
snap refresh --hold microceph
```

> Caution 谨慎
>
> Allowing the snap to be auto-updated can lead to unintended consequences. 
> 允许快照自动更新可能会导致意想不到的后果。特别是在企业环境中，最好在实施这些更改之前研究软件更改的后果。
>
> 未设置此选项可能会导致意外升级，这对已部署的集群可能是致命的。所有后续的 MicroCeph 升级都必须手动完成。

#### 初始化集群

首先使用 **cluster bootstrap** 命令初始化集群：

```bash
microceph cluster bootstrap
```

使用 **status** 命令查看集群的状态：

```bash
microceph status
```

它应类似于以下内容：

```bash
MicroCeph deployment summary:
- node-mees (10.246.114.49)
    Services: mds, mgr, mon
      Disks: 0
```

在这里，给出了机器的主机名 “node-mees” 及其 IP 地址 “10.246.114.49 ” 。MDS、MGR 和 MON 服务正在运行，但尚无任何可用的存储。

#### 添加存储

需要三个 OSD 才能形成一个最小的 Ceph 集群。在生产系统中，通常会将物理块设备分配给 OSD。但是，在本教程中，为了简单起见，将使用文件支持的 OSD。将使用循环文件，这是文件支持的对象存储守护进程 （OSD），便于设置小型测试和开发集群。

使用 **disk add** 命令将三个文件支持的 OSD 添加到集群中。在此示例中，正在创建三个 4GiB 文件：

```bash
microceph disk add loop,4G,3
```

> Note 注意
>
> Be wary that an OSD, whether based on a physical device or a file, is resource intensive.
> 尽管您可以根据需要调整文件大小和文件编号，但建议每个 OSD 至少为 2GiB，但通过循环文件运行三个以上的 OSD 并没有明显的好处。请注意，无论是基于物理设备还是文件，OSD 都会占用大量资源。
>
> 请注意，OSD（无论是基于物理设备还是文件）都是资源密集型的。

复查状态：

```bash
microceph status
```

The output should now show three disks and the additional presence of the OSD service:
输出现在应显示三个磁盘以及 OSD 服务的其他存在：

```bash
MicroCeph deployment summary:
- node-mees (10.246.114.49)
    Services: mds, mgr, mon, osd
      Disks: 3
```

#### 管理集群

The cluster can also be managed using native Ceph tooling if snap-level commands are not yet available for a desired task:
如果快照级命令尚不可用于所需任务，也可以使用原生 Ceph 工具管理集群：

```bash
ceph status
```

集群提供以下输出：

```bash
cluster:
  id:     4c2190cd-9a31-4949-a3e6-8d8f60408278
  health: HEALTH_OK

services:
  mon: 1 daemons, quorum node-mees (age 7d)
  mgr: node-mees(active, since 7d)
  osd: 3 osds: 3 up (since 7d), 3 in (since 7d)

data:
  pools:   1 pools, 1 pgs
  objects: 2 objects, 577 KiB
  usage:   96 MiB used, 2.7 TiB / 2.7 TiB avail
  pgs:     1 active+clean
```

#### 启用 RGW

如前所述，将使用 Ceph 对象网关作为与刚刚部署的对象存储集群进行交互的一种方式。

在节点上启用 RGW 守护程序：

```bash
microceph enable rgw
```

> Note 注意
>
> 默认情况下，`rgw` 服务使用端口 80，该端口并非始终可用。如果没有空闲端口 80，可以通过添加 `--port <port-number>` 参数来设置备用端口号，例如 8080。

重新检查状态，另一个状态检查将在状态输出中显示 `rgw` 服务。

```bash
microceph status
MicroCeph deployment summary:
- ubuntu (10.246.114.49)
  Services: mds, mgr, mon, rgw, osd
  Disks: 3
```

MicroCeph is packaged with the standard `radosgw-admin` tool that manages the `rgw` service and users. We will now use this tool to create a RGW user and set secrets on it.
MicroCeph 与管理 `rgw` 服务和用户的标准 `radosgw-admin` 工具打包在一起。现在，将使用此工具创建 RGW 用户并为其设置 secret。

创建 RGW 用户：

```bash
radosgw-admin user create --uid=user --display-name=user
```

输出应如下所示：

```json
{
    "user_id": "user",
    "display_name": "user",
    "email": "",
    "suspended": 0,
    "max_buckets": 1000,
    "subusers": [],
    "keys": [
        {
            "user": "user",
            "access_key": "LAFIXGH2ELX8JBTEPC16",
            "secret_key": "sW5Mt2zDoO6C7aBu6qd5CXqfLshV1XSEO438DcNW",
            "active": true,
            "create_date": "2025-02-18T10:10:42.423357Z"
        }
    ],
    "swift_keys": [],
    "caps": [],
    "op_mask": "read, write, delete",
    "default_placement": "",
    "default_storage_class": "",
    "placement_tags": [],
    "bucket_quota": {
        "enabled": false,
        "check_on_raw": false,
        "max_size": -1,
        "max_size_kb": 0,
        "max_objects": -1
    },
    "user_quota": {
        "enabled": false,
        "check_on_raw": false,
        "max_size": -1,
        "max_size_kb": 0,
        "max_objects": -1
    },
    "temp_url_keys": [],
    "type": "rgw",
    "mfa_ids": [],
    "account_id": "",
    "path": "/",
    "create_date": "2025-02-18T10:10:42.422987Z",
    "tags": [],
    "group_ids": []
}
```

设置用户密钥：

```
radosgw-admin key create --uid=user --key-type=s3 --access-key=foo --secret-key=bar

{
    "user_id": "user",
    "display_name": "user",
    "email": "",
    "suspended": 0,
    "max_buckets": 1000,
    "subusers": [],
    "keys": [
        {
            "user": "user",
            "access_key": "LAFIXGH2ELX8JBTEPC16",
            "secret_key": "sW5Mt2zDoO6C7aBu6qd5CXqfLshV1XSEO438DcNW",
            "active": true,
            "create_date": "2025-02-18T10:10:42.423357Z"
        },
        {
            "user": "user",
            "access_key": "foo",
            "secret_key": "bar",
            "active": true,
            "create_date": "2025-02-19T00:36:19.846373Z"
        }
    ],
    "swift_keys": [],
    "caps": [],
    "op_mask": "read, write, delete",
    "default_placement": "",
    "default_storage_class": "",
    "placement_tags": [],
    "bucket_quota": {
        "enabled": false,
        "check_on_raw": false,
        "max_size": -1,
        "max_size_kb": 0,
        "max_objects": -1
    },
    "user_quota": {
        "enabled": false,
        "check_on_raw": false,
        "max_size": -1,
        "max_size_kb": 0,
        "max_objects": -1
    },
    "temp_url_keys": [],
    "type": "rgw",
    "mfa_ids": [],
    "account_id": "",
    "path": "/",
    "create_date": "2025-02-18T10:10:42.422987Z",
    "tags": [],
    "group_ids": []
}
```

#### 访问 RGW

在尝试使用集群中的对象存储之前，请通过在节点上运行 **curl** 来验证是否可以访问 RGW。

找到运行 ''rgw'' 服务的节点的 IP 地址：

```bash
microceph status

MicroCeph deployment summary:
- ubuntu (10.246.114.49)
  Services: mds, mgr, mon, rgw, osd
  Disks: 3
```

从此节点运行 **curl**：

```bash
curl http://10.246.114.49

<?xml version="1.0" encoding="UTF-8"?><ListAllMyBucketsResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/"><Owner><ID>anonymous</ID></Owner><Buckets></Buckets></ListAllMyBucketsResult>
```

创建 S3 存储桶：

已验证集群可通过 RGW 访问。现在，让我们使用 `s3cmd` 工具创建一个存储桶 bucket：

```bash
s3cmd mb -P s3://mybucket
```

> Note 注意
>
> The `-P` flag ensures that the bucket is publicly visible, enabling you to access stored objects easily via a public URL.
> `-P` 标志可确保存储桶公开可见，使您能够通过公有 URL 轻松访问存储的对象。

```bash
Bucket 's3://mybucket/' created
```

存储桶创建成功。让我们将图像上传到其中：

```bash
s3cmd put -P image.jpg s3://mybucket

upload: 'image.jpg' -> 's3://mybucket/image.jpg' [1 of 1]
66565 of 66565  100% in  0s   4.52 MB/s done
Public URL of the object is: http://ubuntu/mybucket/image.jpg
```

You  may now click on the public object URL given in the output to view it in your browser.
已将图像存储在公开可见的 S3 存储桶中。您现在可以单击输出中给出的公共对象 URL 以在浏览器中查看它。

### 多节点安装

This tutorial will show how to install MicroCeph on three machines, thereby creating a multi-node cluster. For this tutorial, we will utilise physical block devices for storage.
本教程将展示如何在三台机器上安装 MicroCeph，从而创建一个多节点集群。在本教程中，我们将利用物理块设备进行存储。

#### 确保存储需求

Three OSDs will be required to form a minimal Ceph cluster. This means that, on each of the three machines, one entire disk must be allocated for storage.
需要三个 OSD 才能形成一个最小的 Ceph 集群。这意味着，在这三台机器中的每一台上，都必须分配一个完整的磁盘用于存储。

The disk subsystem can be inspected with the **lsblk** command. In this tutorial, the command’s output on each machine looks very similar to what’s shown below. Any output related to possible loopback devices has been suppressed for the purpose of clarity:
可以使用 **lsblk** 命令检查磁盘子系统。在本教程中，命令在每台计算机上的输出看起来与下面显示的内容非常相似。为清楚起见，已禁止显示与可能的环回设备相关的任何输出：

```
lsblk | grep -v loop

NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
vda    252:0    0    40G  0 disk
├─vda1 252:1    0     1M  0 part
└─vda2 252:2    0    40G  0 part /
vdb    252:16   0    20G  0 disk
```

For the example cluster, each machine will use `/dev/vdb` for storage.
对于示例集群，每台计算机都将使用 `/dev/vdb` 进行存储。

#### 准备三台机器

在这三台机器中的每一台上，都需要：

- 安装软件
- 禁用软件的自动更新

下面将在 **node-1** 上明确展示这些步骤，将其称为主节点。

安装 MicroCeph 的最新稳定版本：

```bash
snap install microceph
```

防止软件自动更新：

```bash
snap refresh --hold microceph
```

> Caution 谨慎
>
> Allowing the snap to be auto-updated can lead to unintended consequences. In enterprise environments especially, it is better to research the ramifications of software changes before those changes are implemented.
> 允许快照自动更新可能会导致意想不到的后果。特别是在企业环境中，最好在实施这些更改之前研究软件更改的后果。

对 node-2 和 node-3 重复上述两个步骤。

#### 准备集群

在 **node-1** 上，现在将：

- 初始化集群
- 创建注册令牌

使用 **cluster bootstrap** 命令初始化集群：

```bash
microceph cluster bootstrap
```

需要令牌才能将其他两个节点加入集群。使用 **cluster add** 命令生成这些命令。

node-2 的令牌：

```
microceph cluster add node-2

eyJuYW1lIjoibm9kZS0yIiwic2VjcmV0IjoiYmRjMzZlOWJmNmIzNzhiYzMwY2ZjOWVmMzRjNDM5YzNlZTMzMTlmZDIyZjkxNmJhMTI1MzVkZmZiMjA2MTdhNCIsImZpbmdlcnByaW50IjoiMmU0MmEzYjEwYTg1MDcwYTQ1MDcyODQxZjAyNWY5NGE0OTc4NWU5MGViMzZmZGY0ZDRmODhhOGQyYjQ0MmUyMyIsImpvaW5fYWRkcmVzc2VzIjpbIjEwLjI0Ni4xMTQuMTE6NzQ0MyJdfQ==
```

Token for node-3: node-3 的令牌：

```
sudo microceph cluster add node-3

eyJuYW1lIjoibm9kZS0zIiwic2VjcmV0IjoiYTZjYWJjOTZiNDJkYjg0YTRkZTFiY2MzY2VkYTI1M2Y4MTU1ZTNhYjAwYWUyOWY1MDA4ZWQzY2RmOTYzMjBmMiIsImZpbmdlcnByaW50IjoiMmU0MmEzYjEwYTg1MDcwYTQ1MDcyODQxZjAyNWY5NGE0OTc4NWU5MGViMzZmZGY0ZDRmODhhOGQyYjQ0MmUyMyIsImpvaW5fYWRkcmVzc2VzIjpbIjEwLjI0Ni4xMTQuMTE6NzQ0MyJdfQ==
```

将这些令牌保存在安全的地方。下一步将需要它们。

> Note 注意
>
> Tokens are randomly generated; each one is unique.
> 代币是随机生成的;每一个都是独一无二的。

#### 将非主节点加入集群

**cluster join** 命令用于将节点连接到集群。

在 **node-2** 上，使用分配给 node-2 的令牌将计算机添加到集群中：

```bash
microceph cluster join eyJuYW1lIjoibm9kZS0yIiwic2VjcmV0IjoiYmRjMzZlOWJmNmIzNzhiYzMwY2ZjOWVmMzRjNDM5YzNlZTMzMTlmZDIyZjkxNmJhMTI1MzVkZmZiMjA2MTdhNCIsImZpbmdlcnByaW50IjoiMmU0MmEzYjEwYTg1MDcwYTQ1MDcyODQxZjAyNWY5NGE0OTc4NWU5MGViMzZmZGY0ZDRmODhhOGQyYjQ0MmUyMyIsImpvaW5fYWRkcmVzc2VzIjpbIjEwLjI0Ni4xMTQuMTE6NzQ0MyJdfQ==
```

在 **node-3** 上，使用分配给 node-3 的令牌将计算机添加到集群中：

```bash
microceph cluster join eyJuYW1lIjoibm9kZS0zIiwic2VjcmV0IjoiYTZjYWJjOTZiNDJkYjg0YTRkZTFiY2MzY2VkYTI1M2Y4MTU1ZTNhYjAwYWUyOWY1MDA4ZWQzY2RmOTYzMjBmMiIsImZpbmdlcnByaW50IjoiMmU0MmEzYjEwYTg1MDcwYTQ1MDcyODQxZjAyNWY5NGE0OTc4NWU5MGViMzZmZGY0ZDRmODhhOGQyYjQ0MmUyMyIsImpvaW5fYWRkcmVzc2VzIjpbIjEwLjI0Ni4xMTQuMTE6NzQ0MyJdfQ==
```

#### 添加存储

> Warning 警告
>
> This step will remove the data found on the target storage disks. Make sure you don’t lose data unintentionally.
> 此步骤将删除在目标存储磁盘上找到的数据。确保您不会无意中丢失数据。

在这三台计算机中的每一台计算机上，使用 **disk add** 命令添加存储：

```bash
microceph disk add /dev/vdb --wipe
```

根据可以使用的存储磁盘调整每台计算机的上述命令。也可以提供多个磁盘作为空格分隔的参数。

```bash
microceph disk add /dev/vdb /dev/vdc /dev/vdd --wipe
```

或使用 **–all-available** 标志登记计算机上所有可用的物理设备。

```bash
microceph disk add --all-available --wipe
```

#### 检查 MicroCeph 状态

在三个节点中的任何一个节点上，都可以调用 **status** 命令来检查 MicroCeph 的状态：

```bash
microceph status

MicroCeph deployment summary:
- node-01 (10.246.114.11)
  Services: mds, mgr, mon, osd
  Disks: 1
- node-02 (10.246.114.47)
  Services: mds, mgr, mon, osd
  Disks: 1
- node-03 (10.246.115.11)
  Services: mds, mgr, mon, osd
  Disks: 1
```

计算机主机名与其 IP 地址一起提供。MDS、MGR、MON 和 OSD 服务正在运行，并且每个节点都按预期提供单个磁盘。

#### 管理集群

如果快照级命令尚不可用于所需任务，也可以使用原生 Ceph 工具管理集群：

```bash
ceph status
```

输出了：

```bash
cluster:
  id:     cf16e5a8-26b2-4f9d-92be-dd3ac9602ebf
  health: HEALTH_OK

services:
  mon: 3 daemons, quorum node-01,node-02,node-03 (age 14m)
  mgr: node-01(active, since 43m), standbys: node-02, node-03
  osd: 3 osds: 3 up (since 4s), 3 in (since 6s)

data:
  pools:   1 pools, 1 pgs
  objects: 0 objects, 0 B
  usage:   336 MiB used, 60 GiB / 60 GiB avail
  pgs:     100.000% pgs unknown
           1 unknown
```

##  清理资源

如果出于任何原因，想摆脱 MicroCeph，可以通过以下方式从机器中清除 snap：

```bash
snap remove microceph --purge
```

此命令将停止所有服务运行，并删除 MicroCeph 快照以及集群及其包含的所有资源。

> Note 注意
>
> The `--purge` option removes all the files associated with the MicroCeph package, and will also skip generating a snapshot of the package’s running state. Skipping the **purge** option is useful if you intend to re-install MicroCeph, or move your configuration to a different system.
> `--purge` 选项会删除与 MicroCeph 软件包关联的所有文件，并且还会跳过生成软件包运行状态的快照。如果打算重新安装 MicroCeph 或将配置移动到其他系统，则跳过 **purge** 选项非常有用。

```bash
2024-11-28T19:44:29+03:00 INFO Waiting for "snap.microceph.rgw.service" to stop.
2024-11-28T19:45:00+03:00 INFO Waiting for "snap.microceph.mds.service" to stop.
microceph removed
```

## 在 MicroCeph RGW 中配置 Openstack Keystone 身份验证

Ceph Object Gateway (RGW) can be configured to use [Openstack Keystone](https://docs.openstack.org/keystone/latest/getting-started/architecture.html#identity) for providing user authentication service. A Keystone authorised user to the gateway will also be automatically created on the Ceph Object Gateway. A token that Keystone validates will be considered as valid by the gateway.
Ceph 对象网关（RGW）可以配置为使用 [Openstack Keystone](https://docs.openstack.org/keystone/latest/getting-started/architecture.html#identity) 来提供用户身份验证服务。网关的 Keystone 授权用户也将在 Ceph 对象网关上自动创建。Keystone 验证的令牌将被网关视为有效。

MicroCeph 支持设置以下 Keystone 配置键：

| 键                                          | 描述                                                         |
| ------------------------------------------- | ------------------------------------------------------------ |
| rgw_s3_auth_use_keystone                    | Whether to use keystone auth for the S3 endpoints. 是否对 S3 终端节点使用 keystone auth。 |
| rgw_keystone_url                            | {url:port} 格式的 Keystone 服务器地址                        |
| rgw_keystone_admin_token                    | Keystone 管理员令牌（不建议在生产环境中使用）                |
| rgw_keystone_admin_token_path               | Keystone 管理员令牌的路径（建议用于生产环境）                |
| rgw_keystone_admin_user                     | Keystone 服务租户用户名                                      |
| rgw_keystone_admin_password                 | Keystone 服务租户用户密码                                    |
| rgw_keystone_admin_password_path            | Keystone 服务租户用户密码文件的路径                          |
| rgw_keystone_admin_project                  | Keystone admin project name Keystone 管理项目名称            |
| rgw_keystone_admin_domain                   | Keystone admin domain name Keystone 管理域名                 |
| rgw_keystone_service_token_enabled          | Whether to allow expired tokens with service token in requests 是否允许在请求中使用服务令牌的过期令牌 |
| rgw_keystone_service_token_accepted_roles   | Specify user roles accepted as service roles 指定接受为服务角色的用户角色 |
| rgw_keystone_expired_token_cache_expiration | Cache expiration period for an expired token allowed with a service token 服务令牌允许的过期令牌的缓存过期期限 |
| rgw_keystone_api_version                    | Keystone API 版本                                            |
| rgw_keystone_accepted_roles                 | Accepted user roles for Keystone users Keystone 用户接受的用户角色 |
| rgw_keystone_accepted_admin_roles           | List of roles allowing user to gain admin privileges 允许用户获得管理员权限的角色列表 |
| rgw_keystone_token_cache_size               | The maximum number of entries in each Keystone token cache 每个 Keystone 令牌缓存中的最大条目数 |
| rgw_keystone_verify_ssl                     | Whether to verify SSL certificates while making token requests to Keystone 是否在向 Keystone 发出令牌请求时验证 SSL 证书 |
| rgw_keystone_implicit_tenants               | Whether to create new users in their own tenants of the same name 是否在自己的同名租户中创建新用户 |
| rgw_swift_account_in_url                    | Whether the Swift account is encoded in the URL path Swift 帐户是否在 URL 路径中编码 |
| rgw_swift_versioning_enabled                | Enables object versioning 启用对象版本控制                   |
| rgw_swift_enforce_content_length            | Whether content length header is needed when listing containers 列出容器时是否需要内容长度标头 |
| rgw_swift_custom_header                     | 启用 swift 自定义标头                                        |

用户可以设置/获取/列出/重置上述配置键，如下所示：

可以使用 “set” 命令配置支持的配置键：

```bash
microceph cluster config set rgw_swift_account_in_url true
```

可以使用 'get' 命令查询特定键的配置值：

```bash
microceph cluster config get rgw_swift_account_in_url
+---+--------------------------+-------+
| # |           KEY            | VALUE |
+---+--------------------------+-------+
| 0 | rgw_swift_account_in_url | true  |
+---+--------------------------+-------+
```

可以使用 “list” 命令获取所有已配置键的列表：

```bash
microceph cluster config list
+---+--------------------------+-------+
| # |           KEY            | VALUE |
+---+--------------------------+-------+
| 0 | rgw_swift_account_in_url | true  |
+---+--------------------------+-------+
```

重置配置键（即将键设置为默认值）可以使用 'reset' 命令执行：

```bash
microceph cluster config reset rgw_swift_account_in_url

microceph cluster config list
+---+-----+-------+
| # | KEY | VALUE |
+---+-----+-------+
```

## 更改日志级别

默认情况下，MicroCeph 守护进程在运行时将日志级别设置为 DEBUG。虽然这是许多用例的理想行为，但在某些情况下，此级别太高了——例如，存储受限的嵌入式设备。出于这些原因，MicroCeph 守护进程公开了一种获取和设置日志级别的方法。

### 配置日志级别

MicroCeph 包含命令 `log` ，以及子命令 `set-level` 和 `get-level` 。设置时，支持日志级别的字符串和整数格式。例如：

```bash
microceph log set-level warning
microceph log set-level 3
```

这两个命令是等效的。可以通过查询 `set-level` 子命令的帮助来查询从 integer 到 string 的 Map。请注意，对日志级别所做的任何更改都会立即生效，无需重新启动。

另一方面，`get-level` 子命令不带任何参数，仅返回整数级别。`get-level` 返回的任何值都可用于 `set-level`。

例如，在设置了示例中所示的级别后，可以通过以下方式进行验证：

```bash
microceph log get-level
3
```

## 配置集群网络

如果配置集群网络，OSD 将通过集群网络路由检测信号、对象复制和恢复流量。与使用单一网络相比，这可能会提高性能。

MicroCeph 集群配置 CLI 支持设置、获取、重置和列出下面提到的支持的配置键。


支持的配置键

| 键              | 描述                                                         |
| --------------- | ------------------------------------------------------------ |
| cluster_network | Set this key to desired CIDR to configure cluster network 将此键设置为所需的 CIDR 以配置集群网络 |

可以使用 “set” 命令配置支持的配置键：

```bash
microceph cluster config set cluster_network 10.5.0.0/16
```

可以使用 “get” 命令查询特定键的配置值：

```bash
microceph cluster config get cluster_network
+---+-----------------+-------------+
| # |       KEY       |     VALUE   |
+---+-----------------+-------------+
| 0 | cluster_network | 10.5.0.0/16 |
+---+-----------------+-------------+
```

可以使用 “list” 命令获取所有已配置键的列表：

```bash
microceph cluster config list
+---+-----------------+-------------+
| # |       KEY       |     VALUE   |
+---+-----------------+-------------+
| 0 | cluster_network | 10.5.0.0/16 |
+---+-----------------+-------------+
```

可以使用 “reset” 命令重置配置键（即将键设置为默认值）：

```bash
microceph cluster config reset cluster_network\

microceph cluster config list
+---+-----+-------+
| # | KEY | VALUE |
+---+-----+-------+
```

## 使用 Prometheus 启用指标收集

指标在理解 MicroCeph 部署的运行方面发挥着重要作用。这些指标或度量构成了分析和理解集群行为的基础，对于提供可靠的服务至关重要。

Prometheus 是一种流行且成熟的开源工具，用于抓取和记录一段时间内的指标。Ceph 还设计为易于与 Prometheus 集成。

 ![](../../../../Image/p/prometheus_microceph_scraping.jpg)

上图描述了 ceph-mgr 如何提供指标端点，以及 Prometheus 如何在服务级别上抓取指标端点。需要注意的另一件事是，在任何给定时间，只有一个  mgr 模块处于活动状态，并负责接收 MgrReports 并提供它们，即只有一个 ceph-mgr 实例服务于指标端点。由于活动 Mgr  实例可能会随着时间的推移而变化，因此标准做法是在监控 Ceph 集群时抓取所有 mgr 实例。

###  启用 Ceph-Mgr Prometheus 模块

Ceph-Mgr Prometheus 模块负责为指标端点提供服务，然后 Prometheus 本身可以抓取这些端点。我可以通过在 MicroCeph 节点上执行以下命令来启用该模块：

```bash
ceph mgr module enable prometheus
```

### 配置 metrics endpoint

默认情况下，它将在主机上的所有 IPv4 和 IPv6 地址的端口 9283 上接受 HTTP 请求。但是，可以使用以下 ceph-mgr 配置键进行配置，以根据需求进行微调。

```bash
ceph config set mgr mgr/prometheus/server_addr <addr>
ceph config set mgr mgr/prometheus/port <port>
```

### 配置 Prometheus 抓取 MicroCeph

Prometheus 使用基于 YAML 文件的抓取目标配置。

下面提供了一个简单的配置文件：

```yaml
# microceph.yaml
global:
    external_labels:
        monitor: 'microceph'

# Scrape Job
scrape_configs:
  - job_name: 'microceph'

    # Ceph's default for scrape_interval is 15s.
    scrape_interval: 15s

    # List of all the ceph-mgr instances along with default (or configured) port.
    static_configs:
    - targets: ['10.245.165.103:9283', '10.245.165.205:9283', '10.245.165.94:9283']
```

使用提供的配置文件启动 Prometheus。

```bash
prometheus --config.file=microceph.yaml
```

使用的默认端口是 9090，因此可以在 `<prometheus_addr>：9090` 处观察到收集的指标，如下所示：

![](../../../../Image/p/prometheus_console.jpg)

## 启用 Prometheus Alertmanager 警报

为了配置警报，MicroCeph 部署必须启用 Prometheus 的指标收集。此外，Alertmanager 作为单独的二进制文件分发，应安装并运行该二进制文件。

Prometheus Alertmanager handles alerts sent by the Prometheus server. It takes  care of deduplicating, grouping, and routing them to the correct  receiver integration such as email. It also takes care of silencing and  inhibition of alerts.
Prometheus Alertmanager 处理 Prometheus 服务器发送的警报。它负责删除重复数据、分组并将其路由到正确的接收器集成，例如电子邮件。它还负责警报的静默和抑制。

Alerts are configured using [Alerting Rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/). These rules allows the user to define alert conditions using Prometheus expressions. Ceph is designed to be configurable with Alertmanager, you can use the default set of alerting rules provided below to get basic  alerts from your MicroCeph deployments.
警报是使用[警报规则](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/)配置的。这些规则允许用户使用 Prometheus 表达式定义警报条件。Ceph 设计为可通过 Alertmanager 进行配置，可以使用下面提供的默认警报规则集来获取 MicroCeph 部署的基本警报。

The default alert rules can be downloaded from 
默认告警规则可从以下位置下载。[`here`](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/_downloads/2aa51c8517b2d55846da53500c263f43/prometheus_alerts.yaml)

```yaml
groups:
  - name: "cluster health"
    rules:
      - alert: "CephHealthError"
        annotations:
          description: "The cluster state has been HEALTH_ERROR for more than 5 minutes. Please check 'ceph health detail' for more information."
          summary: "Ceph is in the ERROR state"
        expr: "ceph_health_status == 2"
        for: "5m"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.2.1"
          severity: "critical"
          type: "ceph_default"
      - alert: "CephHealthWarning"
        annotations:
          description: "The cluster state has been HEALTH_WARN for more than 15 minutes. Please check 'ceph health detail' for more information."
          summary: "Ceph is in the WARNING state"
        expr: "ceph_health_status == 1"
        for: "15m"
        labels:
          severity: "warning"
          type: "ceph_default"
  - name: "mon"
    rules:
      - alert: "CephMonDownQuorumAtRisk"
        annotations:
          description: "{{ $min := query \"floor(count(ceph_mon_metadata) / 2) + 1\" | first | value }}Quorum requires a majority of monitors (x {{ $min }}) to be active. Without quorum the cluster will become inoperable, affecting all services and connected clients. The following monitors are down: {{- range query \"(ceph_mon_quorum_status == 0) + on(ceph_daemon) group_left(hostname) (ceph_mon_metadata * 0)\" }} - {{ .Labels.ceph_daemon }} on {{ .Labels.hostname }} {{- end }}"
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks#mon-down"
          summary: "Monitor quorum is at risk"
        expr: |
          (
            (ceph_health_detail{name="MON_DOWN"} == 1) * on() (
              count(ceph_mon_quorum_status == 1) == bool (floor(count(ceph_mon_metadata) / 2) + 1)
            )
          ) == 1
        for: "30s"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.3.1"
          severity: "critical"
          type: "ceph_default"
      - alert: "CephMonDown"
        annotations:
          description: |
            {{ $down := query "count(ceph_mon_quorum_status == 0)" | first | value }}{{ $s := "" }}{{ if gt $down 1.0 }}{{ $s = "s" }}{{ end }}You have {{ $down }} monitor{{ $s }} down. Quorum is still intact, but the loss of an additional monitor will make your cluster inoperable.  The following monitors are down: {{- range query "(ceph_mon_quorum_status == 0) + on(ceph_daemon) group_left(hostname) (ceph_mon_metadata * 0)" }}   - {{ .Labels.ceph_daemon }} on {{ .Labels.hostname }} {{- end }}
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks#mon-down"
          summary: "One or more monitors down"
        expr: |
          count(ceph_mon_quorum_status == 0) <= (count(ceph_mon_metadata) - floor(count(ceph_mon_metadata) / 2) + 1)
        for: "30s"
        labels:
          severity: "warning"
          type: "ceph_default"
      - alert: "CephMonDiskspaceCritical"
        annotations:
          description: "The free space available to a monitor's store is critically low. You should increase the space available to the monitor(s). The default directory is /var/lib/ceph/mon-*/data/store.db on traditional deployments, and /var/lib/rook/mon-*/data/store.db on the mon pod's worker node for Rook. Look for old, rotated versions of *.log and MANIFEST*. Do NOT touch any *.sst files. Also check any other directories under /var/lib/rook and other directories on the same filesystem, often /var/log and /var/tmp are culprits. Your monitor hosts are; {{- range query \"ceph_mon_metadata\"}} - {{ .Labels.hostname }} {{- end }}"
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks#mon-disk-crit"
          summary: "Filesystem space on at least one monitor is critically low"
        expr: "ceph_health_detail{name=\"MON_DISK_CRIT\"} == 1"
        for: "1m"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.3.2"
          severity: "critical"
          type: "ceph_default"
      - alert: "CephMonDiskspaceLow"
        annotations:
          description: "The space available to a monitor's store is approaching full (>70% is the default). You should increase the space available to the monitor(s). The default directory is /var/lib/ceph/mon-*/data/store.db on traditional deployments, and /var/lib/rook/mon-*/data/store.db on the mon pod's worker node for Rook. Look for old, rotated versions of *.log and MANIFEST*.  Do NOT touch any *.sst files. Also check any other directories under /var/lib/rook and other directories on the same filesystem, often /var/log and /var/tmp are culprits. Your monitor hosts are; {{- range query \"ceph_mon_metadata\"}} - {{ .Labels.hostname }} {{- end }}"
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks#mon-disk-low"
          summary: "Drive space on at least one monitor is approaching full"
        expr: "ceph_health_detail{name=\"MON_DISK_LOW\"} == 1"
        for: "5m"
        labels:
          severity: "warning"
          type: "ceph_default"
      - alert: "CephMonClockSkew"
        annotations:
          description: "Ceph monitors rely on closely synchronized time to maintain quorum and cluster consistency. This event indicates that the time on at least one mon has drifted too far from the lead mon. Review cluster status with ceph -s. This will show which monitors are affected. Check the time sync status on each monitor host with 'ceph time-sync-status' and the state and peers of your ntpd or chrony daemon."
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks#mon-clock-skew"
          summary: "Clock skew detected among monitors"
        expr: "ceph_health_detail{name=\"MON_CLOCK_SKEW\"} == 1"
        for: "1m"
        labels:
          severity: "warning"
          type: "ceph_default"
  - name: "osd"
    rules:
      - alert: "CephOSDDownHigh"
        annotations:
          description: "{{ $value | humanize }}% or {{ with query \"count(ceph_osd_up == 0)\" }}{{ . | first | value }}{{ end }} of {{ with query \"count(ceph_osd_up)\" }}{{ . | first | value }}{{ end }} OSDs are down (>= 10%). The following OSDs are down: {{- range query \"(ceph_osd_up * on(ceph_daemon) group_left(hostname) ceph_osd_metadata) == 0\" }} - {{ .Labels.ceph_daemon }} on {{ .Labels.hostname }} {{- end }}"
          summary: "More than 10% of OSDs are down"
        expr: "count(ceph_osd_up == 0) / count(ceph_osd_up) * 100 >= 10"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.4.1"
          severity: "critical"
          type: "ceph_default"
      - alert: "CephOSDHostDown"
        annotations:
          description: "The following OSDs are down: {{- range query \"(ceph_osd_up * on(ceph_daemon) group_left(hostname) ceph_osd_metadata) == 0\" }} - {{ .Labels.hostname }} : {{ .Labels.ceph_daemon }} {{- end }}"
          summary: "An OSD host is offline"
        expr: "ceph_health_detail{name=\"OSD_HOST_DOWN\"} == 1"
        for: "5m"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.4.8"
          severity: "warning"
          type: "ceph_default"
      - alert: "CephOSDDown"
        annotations:
          description: |
            {{ $num := query "count(ceph_osd_up == 0)" | first | value }}{{ $s := "" }}{{ if gt $num 1.0 }}{{ $s = "s" }}{{ end }}{{ $num }} OSD{{ $s }} down for over 5mins. The following OSD{{ $s }} {{ if eq $s "" }}is{{ else }}are{{ end }} down: {{- range query "(ceph_osd_up * on(ceph_daemon) group_left(hostname) ceph_osd_metadata) == 0"}} - {{ .Labels.ceph_daemon }} on {{ .Labels.hostname }} {{- end }}
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks#osd-down"
          summary: "An OSD has been marked down"
        expr: "ceph_health_detail{name=\"OSD_DOWN\"} == 1"
        for: "5m"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.4.2"
          severity: "warning"
          type: "ceph_default"
      - alert: "CephOSDNearFull"
        annotations:
          description: "One or more OSDs have reached the NEARFULL threshold. Use 'ceph health detail' and 'ceph osd df' to identify the problem. To resolve, add capacity to the affected OSD's failure domain, restore down/out OSDs, or delete unwanted data."
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks#osd-nearfull"
          summary: "OSD(s) running low on free space (NEARFULL)"
        expr: "ceph_health_detail{name=\"OSD_NEARFULL\"} == 1"
        for: "5m"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.4.3"
          severity: "warning"
          type: "ceph_default"
      - alert: "CephOSDFull"
        annotations:
          description: "An OSD has reached the FULL threshold. Writes to pools that share the affected OSD will be blocked. Use 'ceph health detail' and 'ceph osd df' to identify the problem. To resolve, add capacity to the affected OSD's failure domain, restore down/out OSDs, or delete unwanted data."
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks#osd-full"
          summary: "OSD full, writes blocked"
        expr: "ceph_health_detail{name=\"OSD_FULL\"} > 0"
        for: "1m"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.4.6"
          severity: "critical"
          type: "ceph_default"
      - alert: "CephOSDBackfillFull"
        annotations:
          description: "An OSD has reached the BACKFILL FULL threshold. This will prevent rebalance operations from completing. Use 'ceph health detail' and 'ceph osd df' to identify the problem. To resolve, add capacity to the affected OSD's failure domain, restore down/out OSDs, or delete unwanted data."
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks#osd-backfillfull"
          summary: "OSD(s) too full for backfill operations"
        expr: "ceph_health_detail{name=\"OSD_BACKFILLFULL\"} > 0"
        for: "1m"
        labels:
          severity: "warning"
          type: "ceph_default"
      - alert: "CephOSDTooManyRepairs"
        annotations:
          description: "Reads from an OSD have used a secondary PG to return data to the client, indicating a potential failing drive."
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks#osd-too-many-repairs"
          summary: "OSD reports a high number of read errors"
        expr: "ceph_health_detail{name=\"OSD_TOO_MANY_REPAIRS\"} == 1"
        for: "30s"
        labels:
          severity: "warning"
          type: "ceph_default"
      - alert: "CephOSDTimeoutsPublicNetwork"
        annotations:
          description: "OSD heartbeats on the cluster's 'public' network (frontend) are running slow. Investigate the network for latency or loss issues. Use 'ceph health detail' to show the affected OSDs."
          summary: "Network issues delaying OSD heartbeats (public network)"
        expr: "ceph_health_detail{name=\"OSD_SLOW_PING_TIME_FRONT\"} == 1"
        for: "1m"
        labels:
          severity: "warning"
          type: "ceph_default"
      - alert: "CephOSDTimeoutsClusterNetwork"
        annotations:
          description: "OSD heartbeats on the cluster's 'cluster' network (backend) are slow. Investigate the network for latency issues on this subnet. Use 'ceph health detail' to show the affected OSDs."
          summary: "Network issues delaying OSD heartbeats (cluster network)"
        expr: "ceph_health_detail{name=\"OSD_SLOW_PING_TIME_BACK\"} == 1"
        for: "1m"
        labels:
          severity: "warning"
          type: "ceph_default"
      - alert: "CephOSDInternalDiskSizeMismatch"
        annotations:
          description: "One or more OSDs have an internal inconsistency between metadata and the size of the device. This could lead to the OSD(s) crashing in future. You should redeploy the affected OSDs."
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks#bluestore-disk-size-mismatch"
          summary: "OSD size inconsistency error"
        expr: "ceph_health_detail{name=\"BLUESTORE_DISK_SIZE_MISMATCH\"} == 1"
        for: "1m"
        labels:
          severity: "warning"
          type: "ceph_default"
      - alert: "CephDeviceFailurePredicted"
        annotations:
          description: "The device health module has determined that one or more devices will fail soon. To review device status use 'ceph device ls'. To show a specific device use 'ceph device info <dev id>'. Mark the OSD out so that data may migrate to other OSDs. Once the OSD has drained, destroy the OSD, replace the device, and redeploy the OSD."
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks#id2"
          summary: "Device(s) predicted to fail soon"
        expr: "ceph_health_detail{name=\"DEVICE_HEALTH\"} == 1"
        for: "1m"
        labels:
          severity: "warning"
          type: "ceph_default"
      - alert: "CephDeviceFailurePredictionTooHigh"
        annotations:
          description: "The device health module has determined that devices predicted to fail can not be remediated automatically, since too many OSDs would be removed from the cluster to ensure performance and availabililty. Prevent data integrity issues by adding new OSDs so that data may be relocated."
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks#device-health-toomany"
          summary: "Too many devices are predicted to fail, unable to resolve"
        expr: "ceph_health_detail{name=\"DEVICE_HEALTH_TOOMANY\"} == 1"
        for: "1m"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.4.7"
          severity: "critical"
          type: "ceph_default"
      - alert: "CephDeviceFailureRelocationIncomplete"
        annotations:
          description: "The device health module has determined that one or more devices will fail soon, but the normal process of relocating the data on the device to other OSDs in the cluster is blocked. \nEnsure that the cluster has available free space. It may be necessary to add capacity to the cluster to allow data from the failing device to successfully migrate, or to enable the balancer."
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks#device-health-in-use"
          summary: "Device failure is predicted, but unable to relocate data"
        expr: "ceph_health_detail{name=\"DEVICE_HEALTH_IN_USE\"} == 1"
        for: "1m"
        labels:
          severity: "warning"
          type: "ceph_default"
      - alert: "CephOSDFlapping"
        annotations:
          description: "OSD {{ $labels.ceph_daemon }} on {{ $labels.hostname }} was marked down and back up {{ $value | humanize }} times once a minute for 5 minutes. This may indicate a network issue (latency, packet loss, MTU mismatch) on the cluster network, or the public network if no cluster network is deployed. Check the network stats on the listed host(s)."
          documentation: "https://docs.ceph.com/en/latest/rados/troubleshooting/troubleshooting-osd#flapping-osds"
          summary: "Network issues are causing OSDs to flap (mark each other down)"
        expr: "(rate(ceph_osd_up[5m]) * on(ceph_daemon) group_left(hostname) ceph_osd_metadata) * 60 > 1"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.4.4"
          severity: "warning"
          type: "ceph_default"
      - alert: "CephOSDReadErrors"
        annotations:
          description: "An OSD has encountered read errors, but the OSD has recovered by retrying the reads. This may indicate an issue with hardware or the kernel."
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks#bluestore-spurious-read-errors"
          summary: "Device read errors detected"
        expr: "ceph_health_detail{name=\"BLUESTORE_SPURIOUS_READ_ERRORS\"} == 1"
        for: "30s"
        labels:
          severity: "warning"
          type: "ceph_default"
      - alert: "CephPGImbalance"
        annotations:
          description: "OSD {{ $labels.ceph_daemon }} on {{ $labels.hostname }} deviates by more than 30% from average PG count."
          summary: "PGs are not balanced across OSDs"
        expr: |
          abs(
            ((ceph_osd_numpg > 0) - on (job) group_left avg(ceph_osd_numpg > 0) by (job)) /
            on (job) group_left avg(ceph_osd_numpg > 0) by (job)
          ) * on (ceph_daemon) group_left(hostname) ceph_osd_metadata > 0.30
        for: "5m"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.4.5"
          severity: "warning"
          type: "ceph_default"
  - name: "mds"
    rules:
      - alert: "CephFilesystemDamaged"
        annotations:
          description: "Filesystem metadata has been corrupted. Data may be inaccessible. Analyze metrics from the MDS daemon admin socket, or escalate to support."
          documentation: "https://docs.ceph.com/en/latest/cephfs/health-messages#cephfs-health-messages"
          summary: "CephFS filesystem is damaged."
        expr: "ceph_health_detail{name=\"MDS_DAMAGE\"} > 0"
        for: "1m"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.5.1"
          severity: "critical"
          type: "ceph_default"
      - alert: "CephFilesystemOffline"
        annotations:
          description: "All MDS ranks are unavailable. The MDS daemons managing metadata are down, rendering the filesystem offline."
          documentation: "https://docs.ceph.com/en/latest/cephfs/health-messages/#mds-all-down"
          summary: "CephFS filesystem is offline"
        expr: "ceph_health_detail{name=\"MDS_ALL_DOWN\"} > 0"
        for: "1m"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.5.3"
          severity: "critical"
          type: "ceph_default"
      - alert: "CephFilesystemDegraded"
        annotations:
          description: "One or more metadata daemons (MDS ranks) are failed or in a damaged state. At best the filesystem is partially available, at worst the filesystem is completely unusable."
          documentation: "https://docs.ceph.com/en/latest/cephfs/health-messages/#fs-degraded"
          summary: "CephFS filesystem is degraded"
        expr: "ceph_health_detail{name=\"FS_DEGRADED\"} > 0"
        for: "1m"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.5.4"
          severity: "critical"
          type: "ceph_default"
      - alert: "CephFilesystemMDSRanksLow"
        annotations:
          description: "The filesystem's 'max_mds' setting defines the number of MDS ranks in the filesystem. The current number of active MDS daemons is less than this value."
          documentation: "https://docs.ceph.com/en/latest/cephfs/health-messages/#mds-up-less-than-max"
          summary: "Ceph MDS daemon count is lower than configured"
        expr: "ceph_health_detail{name=\"MDS_UP_LESS_THAN_MAX\"} > 0"
        for: "1m"
        labels:
          severity: "warning"
          type: "ceph_default"
      - alert: "CephFilesystemInsufficientStandby"
        annotations:
          description: "The minimum number of standby daemons required by standby_count_wanted is less than the current number of standby daemons. Adjust the standby count or increase the number of MDS daemons."
          documentation: "https://docs.ceph.com/en/latest/cephfs/health-messages/#mds-insufficient-standby"
          summary: "Ceph filesystem standby daemons too few"
        expr: "ceph_health_detail{name=\"MDS_INSUFFICIENT_STANDBY\"} > 0"
        for: "1m"
        labels:
          severity: "warning"
          type: "ceph_default"
      - alert: "CephFilesystemFailureNoStandby"
        annotations:
          description: "An MDS daemon has failed, leaving only one active rank and no available standby. Investigate the cause of the failure or add a standby MDS."
          documentation: "https://docs.ceph.com/en/latest/cephfs/health-messages/#fs-with-failed-mds"
          summary: "MDS daemon failed, no further standby available"
        expr: "ceph_health_detail{name=\"FS_WITH_FAILED_MDS\"} > 0"
        for: "1m"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.5.5"
          severity: "critical"
          type: "ceph_default"
      - alert: "CephFilesystemReadOnly"
        annotations:
          description: "The filesystem has switched to READ ONLY due to an unexpected error when writing to the metadata pool. Either analyze the output from the MDS daemon admin socket, or escalate to support."
          documentation: "https://docs.ceph.com/en/latest/cephfs/health-messages#cephfs-health-messages"
          summary: "CephFS filesystem in read only mode due to write error(s)"
        expr: "ceph_health_detail{name=\"MDS_HEALTH_READ_ONLY\"} > 0"
        for: "1m"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.5.2"
          severity: "critical"
          type: "ceph_default"
  - name: "mgr"
    rules:
      - alert: "CephMgrModuleCrash"
        annotations:
          description: "One or more mgr modules have crashed and have yet to be acknowledged by an administrator. A crashed module may impact functionality within the cluster. Use the 'ceph crash' command to determine which module has failed, and archive it to acknowledge the failure."
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks#recent-mgr-module-crash"
          summary: "A manager module has recently crashed"
        expr: "ceph_health_detail{name=\"RECENT_MGR_MODULE_CRASH\"} == 1"
        for: "5m"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.6.1"
          severity: "critical"
          type: "ceph_default"
      - alert: "CephMgrPrometheusModuleInactive"
        annotations:
          description: "The mgr/prometheus module at {{ $labels.instance }} is unreachable. This could mean that the module has been disabled or the mgr daemon itself is down. Without the mgr/prometheus module metrics and alerts will no longer function. Open a shell to an admin node or toolbox pod and use 'ceph -s' to to determine whether the mgr is active. If the mgr is not active, restart it, otherwise you can determine module status with 'ceph mgr module ls'. If it is not listed as enabled, enable it with 'ceph mgr module enable prometheus'."
          summary: "The mgr/prometheus module is not available"
        expr: "up{job=\"ceph\"} == 0"
        for: "1m"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.6.2"
          severity: "critical"
          type: "ceph_default"
  - name: "pgs"
    rules:
      - alert: "CephPGsInactive"
        annotations:
          description: "{{ $value }} PGs have been inactive for more than 5 minutes in pool {{ $labels.name }}. Inactive placement groups are not able to serve read/write requests."
          summary: "One or more placement groups are inactive"
        expr: "ceph_pool_metadata * on(pool_id,instance) group_left() (ceph_pg_total - ceph_pg_active) > 0"
        for: "5m"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.7.1"
          severity: "critical"
          type: "ceph_default"
      - alert: "CephPGsUnclean"
        annotations:
          description: "{{ $value }} PGs have been unclean for more than 15 minutes in pool {{ $labels.name }}. Unclean PGs have not recovered from a previous failure."
          summary: "One or more placement groups are marked unclean"
        expr: "ceph_pool_metadata * on(pool_id,instance) group_left() (ceph_pg_total - ceph_pg_clean) > 0"
        for: "15m"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.7.2"
          severity: "warning"
          type: "ceph_default"
      - alert: "CephPGsDamaged"
        annotations:
          description: "During data consistency checks (scrub), at least one PG has been flagged as being damaged or inconsistent. Check to see which PG is affected, and attempt a manual repair if necessary. To list problematic placement groups, use 'rados list-inconsistent-pg <pool>'. To repair PGs use the 'ceph pg repair <pg_num>' command."
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks#pg-damaged"
          summary: "Placement group damaged, manual intervention needed"
        expr: "ceph_health_detail{name=~\"PG_DAMAGED|OSD_SCRUB_ERRORS\"} == 1"
        for: "5m"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.7.4"
          severity: "critical"
          type: "ceph_default"
      - alert: "CephPGRecoveryAtRisk"
        annotations:
          description: "Data redundancy is at risk since one or more OSDs are at or above the 'full' threshold. Add more capacity to the cluster, restore down/out OSDs, or delete unwanted data."
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks#pg-recovery-full"
          summary: "OSDs are too full for recovery"
        expr: "ceph_health_detail{name=\"PG_RECOVERY_FULL\"} == 1"
        for: "1m"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.7.5"
          severity: "critical"
          type: "ceph_default"
      - alert: "CephPGUnavilableBlockingIO"
        annotations:
          description: "Data availability is reduced, impacting the cluster's ability to service I/O. One or more placement groups (PGs) are in a state that blocks I/O."
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks#pg-availability"
          summary: "PG is unavailable, blocking I/O"
        expr: "((ceph_health_detail{name=\"PG_AVAILABILITY\"} == 1) - scalar(ceph_health_detail{name=\"OSD_DOWN\"})) == 1"
        for: "1m"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.7.3"
          severity: "critical"
          type: "ceph_default"
      - alert: "CephPGBackfillAtRisk"
        annotations:
          description: "Data redundancy may be at risk due to lack of free space within the cluster. One or more OSDs have reached the 'backfillfull' threshold. Add more capacity, or delete unwanted data."
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks#pg-backfill-full"
          summary: "Backfill operations are blocked due to lack of free space"
        expr: "ceph_health_detail{name=\"PG_BACKFILL_FULL\"} == 1"
        for: "1m"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.7.6"
          severity: "critical"
          type: "ceph_default"
      - alert: "CephPGNotScrubbed"
        annotations:
          description: "One or more PGs have not been scrubbed recently. Scrubs check metadata integrity, protecting against bit-rot. They check that metadata is consistent across data replicas. When PGs miss their scrub interval, it may indicate that the scrub window is too small, or PGs were not in a 'clean' state during the scrub window. You can manually initiate a scrub with: ceph pg scrub <pgid>"
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks#pg-not-scrubbed"
          summary: "Placement group(s) have not been scrubbed"
        expr: "ceph_health_detail{name=\"PG_NOT_SCRUBBED\"} == 1"
        for: "5m"
        labels:
          severity: "warning"
          type: "ceph_default"
      - alert: "CephPGsHighPerOSD"
        annotations:
          description: "The number of placement groups per OSD is too high (exceeds the mon_max_pg_per_osd setting).\n Check that the pg_autoscaler has not been disabled for any pools with 'ceph osd pool autoscale-status', and that the profile selected is appropriate. You may also adjust the target_size_ratio of a pool to guide the autoscaler based on the expected relative size of the pool ('ceph osd pool set cephfs.cephfs.meta target_size_ratio .1') or set the pg_autoscaler mode to 'warn' and adjust pg_num appropriately for one or more pools."
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks/#too-many-pgs"
          summary: "Placement groups per OSD is too high"
        expr: "ceph_health_detail{name=\"TOO_MANY_PGS\"} == 1"
        for: "1m"
        labels:
          severity: "warning"
          type: "ceph_default"
      - alert: "CephPGNotDeepScrubbed"
        annotations:
          description: "One or more PGs have not been deep scrubbed recently. Deep scrubs protect against bit-rot. They compare data replicas to ensure consistency. When PGs miss their deep scrub interval, it may indicate that the window is too small or PGs were not in a 'clean' state during the deep-scrub window."
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks#pg-not-deep-scrubbed"
          summary: "Placement group(s) have not been deep scrubbed"
        expr: "ceph_health_detail{name=\"PG_NOT_DEEP_SCRUBBED\"} == 1"
        for: "5m"
        labels:
          severity: "warning"
          type: "ceph_default"
  - name: "nodes"
    rules:
      - alert: "CephNodeRootFilesystemFull"
        annotations:
          description: "Root volume is dangerously full: {{ $value | humanize }}% free."
          summary: "Root filesystem is dangerously full"
        expr: "node_filesystem_avail_bytes{mountpoint=\"/\"} / node_filesystem_size_bytes{mountpoint=\"/\"} * 100 < 5"
        for: "5m"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.8.1"
          severity: "critical"
          type: "ceph_default"
      - alert: "CephNodeNetworkPacketDrops"
        annotations:
          description: "Node {{ $labels.instance }} experiences packet drop > 0.5% or > 10 packets/s on interface {{ $labels.device }}."
          summary: "One or more NICs reports packet drops"
        expr: |
          (
            rate(node_network_receive_drop_total{device!="lo"}[1m]) +
            rate(node_network_transmit_drop_total{device!="lo"}[1m])
          ) / (
            rate(node_network_receive_packets_total{device!="lo"}[1m]) +
            rate(node_network_transmit_packets_total{device!="lo"}[1m])
          ) >= 0.0050000000000000001 and (
            rate(node_network_receive_drop_total{device!="lo"}[1m]) +
            rate(node_network_transmit_drop_total{device!="lo"}[1m])
          ) >= 10
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.8.2"
          severity: "warning"
          type: "ceph_default"
      - alert: "CephNodeNetworkPacketErrors"
        annotations:
          description: "Node {{ $labels.instance }} experiences packet errors > 0.01% or > 10 packets/s on interface {{ $labels.device }}."
          summary: "One or more NICs reports packet errors"
        expr: |
          (
            rate(node_network_receive_errs_total{device!="lo"}[1m]) +
            rate(node_network_transmit_errs_total{device!="lo"}[1m])
          ) / (
            rate(node_network_receive_packets_total{device!="lo"}[1m]) +
            rate(node_network_transmit_packets_total{device!="lo"}[1m])
          ) >= 0.0001 or (
            rate(node_network_receive_errs_total{device!="lo"}[1m]) +
            rate(node_network_transmit_errs_total{device!="lo"}[1m])
          ) >= 10
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.8.3"
          severity: "warning"
          type: "ceph_default"
      - alert: "CephNodeNetworkBondDegraded"
        annotations:
          summary: "Degraded Bond on Node {{ $labels.instance }}"
          description: "Bond {{ $labels.master }} is degraded on Node {{ $labels.instance }}."
        expr: |
          node_bonding_slaves - node_bonding_active != 0
        labels:
          severity: "warning"
          type: "ceph_default"
      - alert: "CephNodeDiskspaceWarning"
        annotations:
          description: "Mountpoint {{ $labels.mountpoint }} on {{ $labels.nodename }} will be full in less than 5 days based on the 48 hour trailing fill rate."
          summary: "Host filesystem free space is getting low"
        expr: "predict_linear(node_filesystem_free_bytes{device=~\"/.*\"}[2d], 3600 * 24 * 5) *on(instance) group_left(nodename) node_uname_info < 0"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.8.4"
          severity: "warning"
          type: "ceph_default"
      - alert: "CephNodeInconsistentMTU"
        annotations:
          description: "Node {{ $labels.instance }} has a different MTU size ({{ $value }}) than the median of devices named {{ $labels.device }}."
          summary: "MTU settings across Ceph hosts are inconsistent"
        expr: "node_network_mtu_bytes * (node_network_up{device!=\"lo\"} > 0) ==  scalar(    max by (device) (node_network_mtu_bytes * (node_network_up{device!=\"lo\"} > 0)) !=      quantile by (device) (.5, node_network_mtu_bytes * (node_network_up{device!=\"lo\"} > 0))  )or node_network_mtu_bytes * (node_network_up{device!=\"lo\"} > 0) ==  scalar(    min by (device) (node_network_mtu_bytes * (node_network_up{device!=\"lo\"} > 0)) !=      quantile by (device) (.5, node_network_mtu_bytes * (node_network_up{device!=\"lo\"} > 0))  )"
        labels:
          severity: "warning"
          type: "ceph_default"
  - name: "pools"
    rules:
      - alert: "CephPoolGrowthWarning"
        annotations:
          description: "Pool '{{ $labels.name }}' will be full in less than 5 days assuming the average fill-up rate of the past 48 hours."
          summary: "Pool growth rate may soon exceed capacity"
        expr: "(predict_linear(ceph_pool_percent_used[2d], 3600 * 24 * 5) * on(pool_id, instance) group_right() ceph_pool_metadata) >= 95"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.9.2"
          severity: "warning"
          type: "ceph_default"
      - alert: "CephPoolBackfillFull"
        annotations:
          description: "A pool is approaching the near full threshold, which will prevent recovery/backfill operations from completing. Consider adding more capacity."
          summary: "Free space in a pool is too low for recovery/backfill"
        expr: "ceph_health_detail{name=\"POOL_BACKFILLFULL\"} > 0"
        labels:
          severity: "warning"
          type: "ceph_default"
      - alert: "CephPoolFull"
        annotations:
          description: "A pool has reached its MAX quota, or OSDs supporting the pool have reached the FULL threshold. Until this is resolved, writes to the pool will be blocked. Pool Breakdown (top 5) {{- range query \"topk(5, sort_desc(ceph_pool_percent_used * on(pool_id) group_right ceph_pool_metadata))\" }} - {{ .Labels.name }} at {{ .Value }}% {{- end }} Increase the pool's quota, or add capacity to the cluster first then increase the pool's quota (e.g. ceph osd pool set quota <pool_name> max_bytes <bytes>)"
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks#pool-full"
          summary: "Pool is full - writes are blocked"
        expr: "ceph_health_detail{name=\"POOL_FULL\"} > 0"
        for: "1m"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.9.1"
          severity: "critical"
          type: "ceph_default"
      - alert: "CephPoolNearFull"
        annotations:
          description: "A pool has exceeded the warning (percent full) threshold, or OSDs supporting the pool have reached the NEARFULL threshold. Writes may continue, but you are at risk of the pool going read-only if more capacity isn't made available. Determine the affected pool with 'ceph df detail', looking at QUOTA BYTES and STORED. Increase the pool's quota, or add capacity to the cluster first then increase the pool's quota (e.g. ceph osd pool set quota <pool_name> max_bytes <bytes>). Also ensure that the balancer is active."
          summary: "One or more Ceph pools are nearly full"
        expr: "ceph_health_detail{name=\"POOL_NEAR_FULL\"} > 0"
        for: "5m"
        labels:
          severity: "warning"
          type: "ceph_default"
  - name: "healthchecks"
    rules:
      - alert: "CephSlowOps"
        annotations:
          description: "{{ $value }} OSD requests are taking too long to process (osd_op_complaint_time exceeded)"
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks#slow-ops"
          summary: "OSD operations are slow to complete"
        expr: "ceph_healthcheck_slow_ops > 0"
        for: "30s"
        labels:
          severity: "warning"
          type: "ceph_default"
      - alert: "CephDaemonSlowOps"
        for: "30s"
        expr: "ceph_daemon_health_metrics{type=\"SLOW_OPS\"} > 0"
        labels: 
          severity: 'warning'
          type: 'ceph_default'
        annotations:
          summary: "{{ $labels.ceph_daemon }} operations are slow to complete"
          description: "{{ $labels.ceph_daemon }} operations are taking too long to process (complaint time exceeded)"
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks#slow-ops"
  - name: "PrometheusServer"
    rules:
      - alert: "PrometheusJobMissing"
        annotations:
          description: "The prometheus job that scrapes from Ceph is no longer defined, this will effectively mean you'll have no metrics or alerts for the cluster.  Please review the job definitions in the prometheus.yml file of the prometheus instance."
          summary: "The scrape job for Ceph is missing from Prometheus"
        expr: "absent(up{job=\"microceph\"})"
        for: "30s"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.12.1"
          severity: "critical"
          type: "ceph_default"
  - name: "rados"
    rules:
      - alert: "CephObjectMissing"
        annotations:
          description: "The latest version of a RADOS object can not be found, even though all OSDs are up. I/O requests for this object from clients will block (hang). Resolving this issue may require the object to be rolled back to a prior version manually, and manually verified."
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks#object-unfound"
          summary: "Object(s) marked UNFOUND"
        expr: "(ceph_health_detail{name=\"OBJECT_UNFOUND\"} == 1) * on() (count(ceph_osd_up == 1) == bool count(ceph_osd_metadata)) == 1"
        for: "30s"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.10.1"
          severity: "critical"
          type: "ceph_default"
  - name: "generic"
    rules:
      - alert: "CephDaemonCrash"
        annotations:
          description: "One or more daemons have crashed recently, and need to be acknowledged. This notification ensures that software crashes do not go unseen. To acknowledge a crash, use the 'ceph crash archive <id>' command."
          documentation: "https://docs.ceph.com/en/latest/rados/operations/health-checks/#recent-crash"
          summary: "One or more Ceph daemons have crashed, and are pending acknowledgement"
        expr: "ceph_health_detail{name=\"RECENT_CRASH\"} == 1"
        for: "1m"
        labels:
          oid: "1.3.6.1.4.1.50495.1.2.1.1.2"
          severity: "critical"
          type: "ceph_default"
```

### 配置告警规则

Alerting rules and Alertmanager targets are configured in Prometheus using the  same config file we used to configure scraping targets.
警报规则和 Alertmanager 目标是在 Prometheus 中使用我们用于配置抓取目标的同一配置文件配置的。

下面提供了一个简单的配置文件，其中包含抓取目标、Alertmanager 和警报规则：

```yaml
# microceph.yaml
global:
    external_labels:
        monitor: 'microceph'

# Scrape Job
scrape_configs:
  - job_name: 'microceph'

    # Ceph's default for scrape_interval is 15s.
    scrape_interval: 15s

    # List of all the ceph-mgr instances along with default (or configured) port.
    static_configs:
    - targets: ['10.245.165.103:9283', '10.245.165.205:9283', '10.245.165.94:9283']

rule_files: # path to alerting rules file.
  - /home/ubuntu/prometheus_alerts.yaml

alerting:
  alertmanagers:
    - static_configs:
      - targets: # Alertmanager <HOST>:<PORT>
        - "10.245.167.132:9093"
```

使用提供的配置文件启动 Prometheus。

```bash
prometheus --config.file=microceph.yaml
```

单击 Prometheus 仪表板上的“警报”选项卡以查看配置的警报：

![](../../../../Image/a/alerts.jpg)

已经有一个活跃的 “CephHealthWarning” 警报！（以红色显示），而其他配置的警报处于非活动状态（以绿色显示）。因此，Alertmanager 已配置并正在运行。

## 启用其他服务实例

为了确保基本级别的弹性，MicroCeph 将始终尝试为集群中的某些服务启用足够数量的实例。默认情况下，此数字设置为 3 。

受此影响的服务包括：

- MON ([Monitor service](https://docs.ceph.com/en/latest/man/8/ceph-mon/))
- MDS ([Metadata service](https://docs.ceph.com/en/latest/man/8/ceph-mds/))
- MGR ([Manager service](https://docs.ceph.com/en/latest/mgr/))

但是，需要额外服务实例的集群设计可以通过手动方式来满足。除了上述服务外，还可以手动将以下服务添加到节点：

- RGW ([RADOS Gateway service](https://docs.ceph.com/en/latest/radosgw/))

这就是 **enable** 命令的目的。它在节点上手动启用服务的新实例。

语法为：

```bash
microceph enable <service> --target <destination> ...
```

其中服务值为 'mon'、'mds'、'mgr' 和 'rgw' 之一。目标是一个节点名称，如 **status** 命令的输出所示：

```bash
microceph status
```

对于给定的服务，**enable** 命令可能支持额外的参数。可以通过查询相应服务的帮助来发现这些内容：

```bash
microceph enable <service> --help
```

### 示例：启用 RGW 服务

首先检查集群的状态，获取节点名称和现有服务的概述：

```bash
microceph status

MicroCeph deployment summary:
- node1-2c3eb41e-14e8-465d-9877-df36f5d80922 (10.111.153.78)
  Services: mds, mgr, mon, osd
  Disks: 3
- workbook (192.168.29.152)
  Services: mds, mgr, mon
  Disks: 0
```

查看 RGW 服务的任何可能的额外参数：

```
microceph enable rgw --help
```

要在 node1 上启用 RGW 服务并为额外 port 参数指定值，请执行以下操作：

```bash
microceph enable rgw --target node1 --port 8080
```

最后，再次查看集群状态并验证预期的更改：

```bash
microceph status

MicroCeph deployment summary:
- node1 (10.111.153.78)
  Services: mds, mgr, mon, rgw, osd
  Disks: 3
- workbook (192.168.29.152)
  Services: mds, mgr, mon
  Disks: 0
```

## 迁移自动配置的服务

MicroCeph 会在需要时部署自动预置的 Ceph 服务。这些服务包括：

- MON - [Monitor service](https://docs.ceph.com/en/latest/man/8/ceph-mon/)
- MDS - [Metadata service](https://docs.ceph.com/en/latest/man/8/ceph-mds/)
- MGR - [Manager service](https://docs.ceph.com/en/latest/mgr/)

但是，能够将这些服务从一个节点移动（或迁移）到另一个节点可能很有用。在维护时段内，这可能是可取的，例如，当这些服务必须保持可用时。

这就是 **cluster migrate** 命令的用途。它在目标节点上启用自动预配的服务，并在源节点上禁用它们。

语法为：

```bash
microceph cluster migrate <source> <destination>
```

其中，源和目标是可通过 **status** 命令访问的节点名称：

```bash
microceph status
```

迁移后，**status** 命令还可用于验证节点之间的服务分布。

**笔记：**

- 在任何给定节点上拥有自动预配服务的多个实例是不可能的，也没有用处。
- RADOS 网关服务不被视为自动配置类型；它们在节点上显式启用和禁用。

## 在 MicroCeph 中配置 RBD 客户端缓存

MicroCeph 支持设置、重置和列出客户端配置，这些配置被导出到 ceph.conf 中，并被 qemu 等工具直接用于配置 rbd 缓存。以下是受支持的客户端配置。


支持的配置键

| 键                                 | 描述                                                         |
| ---------------------------------- | ------------------------------------------------------------ |
| rbd_cache                          | 为 RADOS 块设备 （RBD） 启用缓存。                           |
| rbd_cache_size                     | RBD 缓存大小（以字节为单位）。                               |
| rbd_cache_writethrough_until_flush | 在写回开始之前，脏数据在缓存中的秒数。                       |
| rbd_cache_max_dirty                | The dirty limit in bytes at which the cache triggers write-back. If 0, uses write-through caching. 缓存触发回写的脏限制（以字节为单位）。如果为 0，则使用直写缓存。 |
| rbd_cache_target_dirty             | The dirty target before the cache begins writing data to the data storage. Does not block writes to the cache. 在缓存开始将数据写入数据存储之前的脏目标。不阻止对缓存的写入。 |

可以使用 “set” 命令配置支持的配置键：

```bash
microceph client config set rbd_cache true
microceph client config set rbd_cache false --target alpha
microceph client config set rbd_cache_size 2048MiB --target beta
```

> Note 注意
>
> Host level configuration changes can be made by passing the relevant hostname as the –target parameter.
> 可以通过将相关主机名作为 –target 参数传递来更改主机级别的配置。

可以使用 “list” 命令查询所有客户端配置。

```bash
microceph cluster config list
+---+----------------+---------+----------+
| # |      KEY       |  VALUE  |   HOST   |
+---+----------------+---------+----------+
| 0 | rbd_cache      | true    | beta     |
+---+----------------+---------+----------+
| 1 | rbd_cache      | false   | alpha    |
+---+----------------+---------+----------+
| 2 | rbd_cache_size | 2048MiB | beta     |
+---+----------------+---------+----------+
```

同样，可以使用 –target 参数查询特定主机的所有客户端配置。

```bash
microceph cluster config list --target beta
+---+----------------+---------+----------+
| # |      KEY       |  VALUE  |   HOST   |
+---+----------------+---------+----------+
| 0 | rbd_cache      | true    | beta     |
+---+----------------+---------+----------+
| 1 | rbd_cache_size | 2048MiB | beta     |
+---+----------------+---------+----------+
```

可以使用 “get” 命令查询特定的配置键：

```bash
microceph cluster config list
+---+----------------+---------+----------+
| # |      KEY       |  VALUE  |   HOST   |
+---+----------------+---------+----------+
| 0 | rbd_cache      | true    | beta     |
+---+----------------+---------+----------+
| 1 | rbd_cache      | false   | alpha    |
+---+----------------+---------+----------+
```

同样，–target 参数可以与 get 命令一起使用，以查询特定的配置键/主机名对。

```bash
microceph cluster config rbd_cache --target alpha
+---+----------------+---------+----------+
| # |      KEY       |  VALUE  |   HOST   |
+---+----------------+---------+----------+
| 0 | rbd_cache      | false   | alpha    |
+---+----------------+---------+----------+
```

可以使用 “reset” 命令重置配置键（即删除配置的键/值）：

```bash
microceph cluster config reset rbd_cache_size

microceph cluster config list
+---+----------------+---------+----------+
| # |      KEY       |  VALUE  |   HOST   |
+---+----------------+---------+----------+
| 0 | rbd_cache      | true    | beta     |
+---+----------------+---------+----------+
| 1 | rbd_cache      | false   | alpha    |
+---+----------------+---------+----------+
```

也可以对特定主机执行此操作，如下所示：

```bash
microceph cluster config reset rbd_cache --target alpha

microceph cluster config list
 +---+----------------+---------+----------+
 | # |      KEY       |  VALUE  |   HOST   |
 +---+----------------+---------+----------+
 | 0 | rbd_cache      | true    | beta     |
 +---+----------------+---------+----------+
```

## Major Upgrades

### 先决条件

首先，在开始升级之前，请确保集群运行状况良好。使用以下命令检查集群运行状况：

```bash
ceph -s
```

**Note**: 如果集群运行状况不佳，请不要启动升级。

其次，查看[发行说明](https://canonical-microceph.readthedocs-hosted.com/en/squid-stable/reference/release-notes/)以检查任何特定于版本的信息。

### 可选但推荐：准备步骤

在开始升级之前，请执行以下预防措施：

1. **备份数据**：作为一般预防措施，建议备份数据（例如存储的 S3 对象、RBD 卷或 cephfs 文件系统）。

2. **防止 OSD 从集群中退出**：运行以下命令以避免 OSD 在升级过程中无意中从集群中退出：

   ```bash
   ceph osd set noout
   ```

###  升级每个集群节点

如果集群运行正常，请使用以下命令刷新每个节点上的快照来继续升级：

```bash
snap refresh microceph --channel reef/stable
```

请务必在群集中的每个节点上执行刷新。

###  验证升级

升级过程完成后，请验证所有组件是否均已正确升级。使用以下命令进行检查：

```bash
ceph versions
```

###  取消设置 Noout

如果之前设置了 noout，请使用以下命令取消设置它：

```bash
ceph osd unset noout
```

现在已成功完成升级。

## 移除磁盘

想要从 Ceph 集群中删除磁盘是有充分理由的。一个常见的用例是需要更换已被确定为接近其保质期的产品。另一个示例是通过删除集群节点（计算机）来缩减集群的愿望。

> Note 注意
>
> 此功能目前仅在 **microceph** snap 的 `latest/edge` 通道中受支持。

首先，了解集群及其 OSD 的概述：

```bash
ceph status
```

输出示例：

```bash
cluster:
  id:     cf16e5a8-26b2-4f9d-92be-dd3ac9602ebf
  health: HEALTH_OK

services:
  mon: 3 daemons, quorum node-01,node-02,node-03 (age 41h)
  mgr: node-01(active, since 41h), standbys: node-02, node-03
  osd: 5 osds: 5 up (since 22h), 5 in (since 22h); 1 remapped pgs

data:
  pools:   1 pools, 1 pgs
  objects: 2 objects, 577 KiB
  usage:   105 MiB used, 1.9 TiB / 1.9 TiB avail
  pgs:     2/6 objects misplaced (33.333%)
           1 active+clean+remapped
```

然后，使用（原生 Ceph）**ceph osd tree** 命令确定与磁盘关联的 OSD 的 ID：

```bash
ceph osd tree
```

示例输出：

```bash
ID  CLASS  WEIGHT   TYPE NAME              STATUS  REWEIGHT  PRI-AFF
-1         1.87785  root default
-5         1.81940      host node-mees
 3         0.90970          osd.3              up   1.00000  1.00000
 4         0.90970          osd.4              up   1.00000  1.00000
-2         0.01949      host node-01
 0         0.01949          osd.0              up   1.00000  1.00000
-3         0.01949      host node-02
 1         0.01949          osd.1              up   1.00000  1.00000
-4         0.01949      host node-03
 2         0.01949          osd.2              up   1.00000  1.00000
```

假设目标磁盘位于主机 “node-mees” 上，并且有一个关联的 OSD ，其 ID 为 “osd.4” 。

要移除磁盘：

```bash
microceph disk remove osd.4
```

确认 OSD 已被移除：

```bash
ceph osd tree
```

输出：

```bash
ID  CLASS  WEIGHT   TYPE NAME              STATUS  REWEIGHT  PRI-AFF
-1         0.96815  root default
-5         0.90970      host node-mees
 3    hdd  0.90970          osd.3              up   1.00000  1.00000
-2         0.01949      host node-01
 0    hdd  0.01949          osd.0              up   1.00000  1.00000
-3         0.01949      host node-02
 1    hdd  0.01949          osd.1              up   1.00000  1.00000
-4         0.01949      host node-03
 2    hdd  0.01949          osd.2              up   1.00000  1.00000
```

最后，确认集群状态和运行状况：

```bash
ceph status
```

输出：

```bash
cluster:
  id:     cf16e5a8-26b2-4f9d-92be-dd3ac9602ebf
  health: HEALTH_OK

services:
  mon: 3 daemons, quorum node-01,node-02,node-03 (age 4m)
  mgr: node-01(active, since 4m), standbys: node-02, node-03
  osd: 4 osds: 4 up (since 4m), 4 in (since 4m)

data:
  pools:   1 pools, 1 pgs
  objects: 2 objects, 577 KiB
  usage:   68 MiB used, 991 GiB / 992 GiB avail
  pgs:     1 active+clean
```

## 导入远程 MicroCeph 集群

MicroCeph 支持将其他 MicroCeph 集群添加为远程集群。这会在 snap 的 config 目录中创建 `$remote.conf/$remote.keyring` 文件，允许用户（和 microceph）在远程集群上执行 ceph 操作。

这还可以通过向 MicroCeph 和 Ceph 公开所需的远程集群详细信息，实现复制到远程集群等功能。

### 使用远程 MicroCeph 集群

假设主集群（名为 magical）和辅助集群（名为 simple）。操作员可以在辅助集群上生成集群令牌，如下所示：

```bash
microceph cluster export magical
eyJmc2lkIjoiN2FiZmMwYmItNjIwNC00M2FmLTg4NDQtMjg3NDg2OGNiYTc0Iiwia2V5cmluZy5jbGllbnQubWFnaWNhbCI6IkFRQ0hJdmRtNG91SUNoQUFraGsvRldCUFI0WXZCRkpzUC92dDZ3PT0iLCJtb24uaG9zdC5zaW1wbGUtcmVpbmRlZXIiOiIxMC40Mi44OC42OSIsInB1YmxpY19uZXR3b3JrIjoiMTAuNDIuODguNjkvMjQifQ==
```

在主集群中，可以导入此令牌以创建远程记录。

```bash
microceph remote import simple eyJmc2lkIjoiN2FiZmMwYmItNjIwNC00M2FmLTg4NDQtMjg3NDg2OGNiYTc0Iiwia2V5cmluZy5jbGllbnQubWFnaWNhbCI6IkFRQ0hJdmRtNG91SUNoQUFraGsvRldCUFI0WXZCRkpzUC92dDZ3PT0iLCJtb24uaG9zdC5zaW1wbGUtcmVpbmRlZXIiOiIxMC40Mi44OC42OSIsInB1YmxpY19uZXR3b3JrIjoiMTAuNDIuODguNjkvMjQifQ== --local-name magical
```

这将创建所需的 $simple.conf 和 $simple.keyring 文件。注意：导入远程集群是单向作。对于对称关系，两个集群都应该彼此添加为 remotes。

检查远程 ceph 集群状态

```bash
ceph -s --cluster simple --id magical
 
cluster:
  id:     7abfc0bb-6204-43af-8844-2874868cba74
  health: HEALTH_OK

services:
  mon: 1 daemons, quorum simple-reindeer (age 18m)
  mgr: simple-reindeer(active, since 18m)
  osd: 3 osds: 3 up (since 17m), 3 in (since 17m)

data:
  pools:   4 pools, 97 pgs
  objects: 4 objects, 449 KiB
  usage:   81 MiB used, 15 GiB / 15 GiB avail
  pgs:     97 active+clean
```

注意：通过提供必要的 $cluster 和 $client.id 名称，可以在远程集群上调用 Ceph 命令。

同样，可以按如下方式查询已配置的远程集群

```bash
sudo microceph remote list
ID  REMOTE NAME  LOCAL NAME
 1  simple       magical
```

并且可以通过如下方式删除

```bash
sudo microceph remote remove simple
```

## RBD 复制

MicroCeph 支持将 RBD 镜像异步复制（镜像）到远程集群。

操作员可以在任何 rbd 映像或整个池上启用此功能。在存储池上启用它，将对存储池中的所有映像启用它。

### 先决条件

1. 一个主 MicroCeph 集群和一个辅助 MicroCeph 集群，例如名为 “primary_cluster” 和 “secondary_cluster”
2. primary_cluster 已从 secondary_cluster 导入配置，反之亦然。
3. 两个集群都有 2 个 rbd 池：pool_one 和 pool_two。
4. 集群 “primary_cluster” 上的两个池都有 2 个映像（image_one 和 image_two），而集群 “secondary_cluster” 上的池为空。

### 启用 RBD 复制

操作员可以为给定的 rbd 池启用复制，该池在两个集群中都显示为

```bash
microceph replication enable rbd pool_one --remote secondary_cluster
```

此处，pool_one 是 rbd 池的名称，它应存在于两个集群中。

### 检查 RBD 复制状态

上述命令将为 pool_one 中的所有图像启用复制，可以按以下方式检查：

```
microceph replication status rbd pool_one

+------------------------+----------------------+
|         SUMMARY        |        HEALTH        |
+-------------+----------+-------------+--------+
| Name        | pool_one | Replication | OK     |
| Mode        | pool     | Daemon      | OK     |
| Image Count | 2        | Image       | OK     |
+-------------+----------+-------------+--------+

+-------------------+-----------+--------------------------------------+
|    REMOTE NAME    | DIRECTION | UUID                                 |
+-------------------+-----------+--------------------------------------+
| secondary_cluster | rx-tx     | f25af3c3-f405-4159-a5c4-220c01d27507 |
+-------------------+-----------+--------------------------------------+
```

状态显示池中有 2 个映像已启用镜像。

### 列出所有 RBD 复制镜像

操作员可以列出启用了复制（镜像）的所有镜像，如下所示：

```
microceph replication list rbd
+-----------+------------+------------+---------------------+
| POOL NAME | IMAGE NAME | IS PRIMARY |  LAST LOCAL UPDATE  |
+-----------+------------+------------+---------------------+
| pool_one  | image_one  |    true    | 2024-10-08 13:54:49 |
| pool_one  | image_two  |    true    | 2024-10-08 13:55:19 |
| pool_two  | image_one  |    true    | 2024-10-08 13:55:12 |
| pool_two  | image_two  |    true    | 2024-10-08 13:55:07 |
+-----------+------------+------------+---------------------+
```

### 禁用 RBD 复制

在某些情况下，可能需要禁用复制。可以在单个命令中禁用单个映像 （$pool/$image） 或整个池 （$pool），如下所示：

禁用池复制：

```bash
microceph replication disable rbd pool_one

microceph replication list rbd

+———–-------+--------————+—--------———+—--------------——————+
| POOL NAME | IMAGE NAME | IS PRIMARY |  LAST LOCAL UPDATE  |
+——-------—–+——--------——+——--------——+————--------------———+ 
| pool_two  | image_one  |    true    | 2024-10-08 13:55:12 | 
| pool_two  | image_two  |    true    | 2024-10-08 13:55:07 | 
+——-------—–+—--------———+——--------——+——---------------————+
```

禁用映像复制：

```bash
microceph replication disable rbd pool_two/image_two

microceph replication list rbd
+—-------——–+—--------———+——--------——+——--------------—————+
| POOL NAME | IMAGE NAME | IS PRIMARY |  LAST LOCAL UPDATE  |
+——-------—–+—--------———+———--------—+——--------------—————+ 
| pool_two  | image_one  |    true    | 2024-10-08 13:55:12 |
+——-------—–+—--------———+——--------——+——--------------—————+
```

## 对复制的 RBD 资源执行故障转移

In case of a disaster, all replicated RBD pools can be failed over to a non-primary remote.
如果发生灾难，所有复制的 RBD 池都可以故障转移到非主远程。

An operator can perform promotion on a non-primary cluster, this will in turn promote all replicated rbd images in all rbd pools and make them primary. 
操作员可以在非主集群上执行提升，这反过来又会提升所有 rbd 池中的所有复制 rbd 镜像，并使其成为主集群。这使它们能够被 VM 和其他工作负载使用。

### 先决条件

1. 一个主 MicroCeph 集群和一个辅助 MicroCeph 集群，例如名为 “primary_cluster” 和 “secondary_cluster”
2. primary_cluster 已从 secondary_cluster 导入配置，反之亦然。
3. RBD 复制配置为至少 1 个 rbd 映像。

### Failover to a non-primary remote cluster故障转移到非主远程集群

List all the resources on ‘secondary_cluster’ to check primary status.
列出 'secondary_cluster' 上的所有资源以检查主状态。

```bash
microceph replication list rbd
+-----------+------------+------------+---------------------+
| POOL NAME | IMAGE NAME | IS PRIMARY | LAST LOCAL UPDATE   |
+-----------+------------+------------+---------------------+
| pool_one  | image_one  | false      | 2024-10-14 09:03:17 |
| pool_one  | image_two  | false      | 2024-10-14 09:03:17 |
+-----------+------------+------------+---------------------+
```

操作员可以执行集群范围的提升，如下所示：

```bash
microceph replication promote --remote primary_cluster --yes-i-really-mean-it
```

Here, <remote> parameter helps microceph filter the resources to promote. Since promotion of secondary_cluster may cause a split-brain condition in future, it is necessary to pass –yes-i-really-mean-it flag.
这里 `<remote>` 参数帮助 microceph 筛选要提升的资源。由于推广 secondary_cluster 可能会导致将来出现脑裂情况，因此有必要传递 –yes-i-really-mean-it 标志。

### Verify RBD replication primary status验证 RBD 复制主状态

List all the resources on ‘secondary_cluster’ again to check primary status.
再次列出 'secondary_cluster' 上的所有资源以检查主要状态。

```
sudo microceph replication status rbd pool_one
+-----------+------------+------------+---------------------+
| POOL NAME | IMAGE NAME | IS PRIMARY | LAST LOCAL UPDATE   |
+-----------+------------+------------+---------------------+
| pool_one  | image_one  | true       | 2024-10-14 09:06:12 |
| pool_one  | image_two  | true       | 2024-10-14 09:06:12 |
+-----------+------------+------------+---------------------+
```

The status shows that there are 2 replicated images and both of them are now primary.
状态显示有 2 个复制的映像，它们现在都是主映像。

### Failback to old primary故障恢复到旧的主节点

Once the disaster struck cluster (primary_cluster) is back online the RBD resources can be failed back to it, but, by this time the RBD images at the current primary (secondary_cluster) would have diverged from primary_cluster. Thus, to have a clean sync, the operator must decide which cluster would be demoted to the non-primary status. This cluster will then receive the RBD mirror updates from the standing primary.
一旦灾难发生的集群 （primary_cluster） 重新联机，RBD 资源就可以故障恢复到该集群，但是，此时当前主集群 （secondary_cluster） 的 RBD 映像将与 primary_cluster 的 RBD  映像不同。因此，要进行干净同步，作员必须决定哪个集群将降级为非主状态。然后，此集群将从常设主集群接收 RBD 镜像更新。

Note: Demotion can cause data loss and hence can only be performed with the ‘yes-i-really-mean-it’ flag.
注意：降级可能会导致数据丢失，因此只能使用 'yes-i-really-mean-it' 标志执行。

At primary_cluster (was primary before disaster), perform demotion. .. code-block:: none
在 primary_cluster 时（在灾难之前是主要的），执行降级。

```
sudo microceph replication demote –remote secondary_cluster failed to process demote_replication request for rbd: demotion may cause data loss on this cluster. If you understand the *RISK* and you’re *ABSOLUTELY CERTAIN* that is what you want, pass –yes-i-really-mean-it.
```

Now, again at the ‘primary_cluster’, perform demotion with –yes-i-really-mean-it flag. .. code-block:: none
现在，再次在 'primary_cluster' 处，使用 –yes-i-really-mean-it 标志执行降级。

```bash
sudo microceph replication demote –remote secondary_cluster –yes-i-really-mean-it
```

Note: MicroCeph with demote the primary pools and will issue a resync for all the mirroring images, hence it may cause data loss at the old primary cluster.
注意：MicroCeph 会降级主池，并将为所有镜像镜像发出重新同步，因此可能会导致旧主集群的数据丢失。

## 挂载 MicroCeph 块设备

Ceph RBD（RADOS 块设备）是由 Ceph 存储集群支持的虚拟块设备。

通过在 MicroCeph 部署的 Ceph 集群上创建 rbd 镜像，将其映射到客户端计算机上，然后挂载来实现。

> Warning 警告
>
> MicroCeph as an isolated snap cannot perform certain elevated operations like mapping the rbd image to the host. Therefore, it is recommended to use the client tools as described in this documentation, even if the client machine is the MicroCeph node itself.
> MicroCeph 作为隔离快照无法执行某些提升的操作，例如将 rbd 镜像映射到主机。因此，建议使用本文档中所述的客户端工具，即使客户端计算机本身是 MicroCeph 节点。

### MicroCeph

检查 Ceph 集群的状态：

```bash
ceph -s

cluster:
    id:     90457806-a798-47f2-aca1-a8a93739941a
    health: HEALTH_OK

services:
    mon: 1 daemons, quorum workbook (age 36m)
    mgr: workbook(active, since 50m)
    osd: 3 osds: 3 up (since 17m), 3 in (since 47m)

data:
    pools:   2 pools, 33 pgs
    objects: 21 objects, 13 MiB
    usage:   94 MiB used, 12 GiB / 12 GiB avail
    pgs:     33 active+clean
```

为 RBD 映像创建存储池：

```bash
ceph osd pool create block_pool
pool 'block_pool' created

ceph osd lspools
1 .mgr
2 block_pool

rbd pool init block_pool
```

创建 RBD 映像：

```bash
rbd create bd_foo --size 8192 --image-feature layering -p block_pool

rbd list -p block_pool
bd_foo
```

### Client

下载 'ceph-common' 程序包：

```bash
apt install ceph-common
```

即使客户端计算机本身是 MicroCeph 节点，也需要执行此步骤。

获取 `ceph.conf` 和 `ceph.keyring` 文件 ：

理想情况下，任何有权访问 RBD 设备的 CephX 用户的密钥环文件都可以使用。为简单起见，在此示例中使用 admin 密钥。

```
$ cat /var/snap/microceph/current/conf/ceph.conf
# # Generated by MicroCeph, DO NOT EDIT.
[global]
run dir = /var/snap/microceph/1039/run
fsid = 90457806-a798-47f2-aca1-a8a93739941a
mon host = 192.168.X.Y
public_network = 192.168.X.Y/24
auth allow insecure global id reclaim = false
ms bind ipv4 = true
ms bind ipv6 = false

$ cat /var/snap/microceph/current/conf/ceph.keyring
# Generated by MicroCeph, DO NOT EDIT.
[client.admin]
    key = AQCNTXlmohDfDRAAe3epjquyZGrKATDhL8p3og==
```

这些文件位于任何 MicroCeph 节点上上面显示的路径中。接下来，将假设这些文件位于上述路径。

在客户端上映射 RBD 镜像：

```bash
rbd map --image bd_foo --name client.admin -m 192.168.29.152 \
    -k /var/snap/microceph/current/conf/ceph.keyring \
    -c /var/snap/microceph/current/conf/ceph.conf \
    -p block_pool /dev/rbd0

mkfs.ext4 -m0 /dev/rbd0
mke2fs 1.46.5 (30-Dec-2021)
Discarding device blocks: done
Creating filesystem with 2097152 4k blocks and 524288 inodes
Filesystem UUID: 1deeef7b-ceaf-4882-a07a-07a28b5b2590
Superblock backups stored on blocks:
    32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done
```

将设备挂载在合适的路径上：

```bash
mkdir /mnt/new-mount
mount /dev/rbd0 /mnt/new-mount
cd /mnt/new-mount
```

这样，现在在客户端计算机上的 `/mnt/new-mount` 中挂载了一个块设备，可以对其执行 IO 。

#### 执行 IO 并观察 ceph 集群

在挂载的设备上写入文件：

```bash
dd if=/dev/zero of=random.img count=1 bs=10M
...
10485760 bytes (10 MB, 10 MiB) copied, 0.0176554 s, 594 MB/s

ll
...
-rw-r--r-- 1 root root 10485760 Jun 24 17:02 random.img
```

IO 后的 Ceph 集群状态：

```bash
ceph -s
cluster:
    id:     90457806-a798-47f2-aca1-a8a93739941a
    health: HEALTH_OK

services:
    mon: 1 daemons, quorum workbook (age 37m)
    mgr: workbook(active, since 51m)
    osd: 3 osds: 3 up (since 17m), 3 in (since 48m)

data:
    pools:   2 pools, 33 pgs
    objects: 24 objects, 23 MiB
    usage:   124 MiB used, 12 GiB / 12 GiB avail
    pgs:     33 active+clean
```

比较写入文件前后的 ceph status 输出，可以发现 MicroCeph 集群增长了 30MiB，这是写入文件大小 （10MiB） 的三倍。这是因为 MicroCeph 默认配置 3 路复制。

## MicroCeph 支持的 CephFs 挂载

CephFS（Ceph 文件系统）是由 Ceph 存储集群支持的文件系统共享。

### MicroCeph

检查 Ceph 集群的状态：

```bash
ceph -s
cluster:
    id:     90457806-a798-47f2-aca1-a8a93739941a
    health: HEALTH_OK

services:
    mon: 1 daemons, quorum workbook (age 6h)
    mgr: workbook(active, since 6h)
    osd: 3 osds: 3 up (since 6h), 3 in (since 23h)

data:
    pools:   4 pools, 97 pgs
    objects: 46 objects, 23 MiB
    usage:   137 MiB used, 12 GiB / 12 GiB avail
    pgs:     97 active+clean
```

为 CephFS 创建数据/元数据池：

```bash
ceph osd pool create cephfs_meta
ceph osd pool create cephfs_data
```

创建 CephF 共享：

```bash
ceph fs new newFs cephfs_meta cephfs_data
new fs with metadata pool 4 and data pool 3

ceph fs ls
name: newFs, metadata pool: cephfs_meta, data pools: [cephfs_data ]
```

### Client

下载 'ceph-common' 程序包：

```bash
apt install ceph-common
```

`mount.ceph` 需要此步骤，即使 mount 识别 ceph 设备类型。

获取 `ceph.conf` 和 `ceph.keyring` 文件 ：

理想情况下，任何有权访问 CephF 的 CephX 用户的密钥环文件都可以使用。为简单起见，在此示例中使用 admin 密钥。

```bash
pwd
/var/snap/microceph/current/conf

ls
ceph.client.admin.keyring  ceph.conf  ceph.keyring  metadata.yaml
```

这些文件位于任何 MicroCeph 节点上上面显示的路径中。默认情况下，内核驱动程序会查找 `/etc/ceph`，因此我们将创建指向该文件夹的符号链接。

```bash
ln -s /var/snap/microceph/current/conf/ceph.keyring /etc/ceph/ceph.keyring
ln -s /var/snap/microceph/current/conf/ceph.conf /etc/ceph/ceph.conf

ll /etc/ceph/
...
lrwxrwxrwx   1 root root    42 Jun 25 16:28 ceph.conf -> /var/snap/microceph/current/conf/ceph.conf
lrwxrwxrwx   1 root root    45 Jun 25 16:28 ceph.keyring -> /var/snap/microceph/current/conf/ceph.keyring
```

挂载文件系统：

```
mkdir /mnt/mycephfs
mount -t ceph :/ /mnt/mycephfs/ -o name=admin,fs=newFs
```

在这里，我们提供了 CephX 用户（在本例中为 admin）和之前创建的 fs（newFs）。

这样，现在已在客户端计算机上的 `/mnt/mycephfs` 挂载了一个 CephFS ，可以对其执行 IO。

#### 执行 IO 并观察 ceph 集群

编写文件：

```bash
cd /mnt/mycephfs

dd if=/dev/zero of=random.img count=1 bs=50M
52428800 bytes (52 MB, 50 MiB) copied, 0.0491968 s, 1.1 GB/s

ll
...
-rw-r--r-- 1 root root 52428800 Jun 25 16:04 random.img
```

IO 后的 Ceph 集群状态：

```bash
ceph -s
cluster:
    id:     90457806-a798-47f2-aca1-a8a93739941a
    health: HEALTH_OK

services:
    mon: 1 daemons, quorum workbook (age 8h)
    mgr: workbook(active, since 8h)
    mds: 1/1 daemons up
    osd: 3 osds: 3 up (since 8h), 3 in (since 25h)

data:
    volumes: 1/1 healthy
    pools:   4 pools, 97 pgs
    objects: 59 objects, 73 MiB
    usage:   287 MiB used, 12 GiB / 12 GiB avail
    pgs:     97 active+clean
```

我观察到集群使用量增长了 150 MiB，这是写入挂载共享的文件大小的三倍。这是因为 MicroCeph 默认配置 3 路复制。

## 命令

使用这些命令来初始化、部署和管理 MicroCeph 集群。

- [`client`](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/reference/commands/client/)
- [`cluster`](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/reference/commands/cluster/)
- [`disable`](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/reference/commands/disable/)
- [`disk`](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/reference/commands/disk/)
- [`enable`](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/reference/commands/enable/)
- [`help`](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/reference/commands/help/)
- [`init`](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/reference/commands/init/)
- [`pool`](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/reference/commands/pool/)
- remote
- replication
- [`status`](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/reference/commands/status/)

### `client`

管理 MicroCeph 客户端

```bash
microceph client [flags]
microceph client [command]
```

可用命令：

```bash
config      Manage Ceph Client configs
```

全局选项：

```bash
-d, --debug       Show all debug messages
-h, --help        Print help
    --state-dir   Path to store state information
-v, --verbose     Show all information messages
    --version     Print version number
```

### `config`

管理 Ceph 集群配置。

```bash
microceph cluster config [flags]
microceph cluster config [command]
```

可用命令：

```bash
get         Fetches specified Ceph Client config
list        Lists all configured Ceph Client configs
reset       Removes specified Ceph Client configs
set         Sets specified Ceph Client config
```

#### `config set`

设置指定的 Ceph 客户端配置

```bash
microceph client config set <Key> <Value> [flags]
```

标志：

```bash
--target string   Specify a microceph node the provided config should be applied to. (default "*")
--wait            Wait for configs to propagate across the cluster. (default true)
```

#### `config get`

获取指定的 Ceph 客户端配置

```bash
microceph client config get <key> [flags]
```

标志：

```bash
--target string   Specify a microceph node the provided config should be applied to. (default "*")
```

#### `config list`

列出所有已配置的 Ceph Client 配置

```bash
microceph client config list [flags]
```

标志：

```bash
--target string   Specify a microceph node the provided config should be applied to. (default "*")
```

#### `config reset`

删除指定的 Ceph Client 配置

```bash
microceph client config reset <key> [flags]
```

标志：

```bash
--target string          Specify a microceph node the provided config should be applied to. (default "*")
--wait                   Wait for required ceph services to restart post config reset. (default true)
--yes-i-really-mean-it   Force microceph to reset all client config records for given key.
```

### `cluster`

管理 MicroCeph 集群。

```bash
microceph cluster [flags]
microceph cluster [command]
```

可用命令：

```bash
add         Generates a token for a new server
bootstrap   Sets up a new cluster
config      Manage Ceph Cluster configs
export      Generates cluster token for given Remote cluster
join        Joins an existing cluster
list        List servers in the cluster
migrate     Migrate automatic services from one node to another
remove      Removes a server from the cluster
sql         Runs a SQL query against the cluster database
```

全局选项：

```bash
-d, --debug       Show all debug messages
-h, --help        Print help
    --state-dir   Path to store state information
-v, --verbose     Show all information messages
    --version     Print version number
```

#### `add`

为新服务器生成令牌

```bash
microceph cluster add <NAME> [flags]
```

#### `bootstrap`

设置新集群

```bash
microceph cluster bootstrap [flags]
```

标志：

```bash
--microceph-ip    string Network address microceph daemon binds to.
--mon-ip          string Public address for bootstrapping ceph mon service.
--public-network  string Public network Ceph daemons bind to.
--cluster-network string Cluster network Ceph daemons bind to.
```

#### `config`

管理 Ceph 集群配置。

```bash
microceph cluster config [flags]
microceph cluster config [command]
```

可用命令：

```bash
get         Get specified Ceph Cluster config
list        List all set Ceph level configs
reset       Clear specified Ceph Cluster config
set         Set specified Ceph Cluster config
```

##### `config get`

获取指定的 Ceph 集群配置。

```bash
microceph cluster config get <key> [flags]
```

##### `config list`

列出所有已设置的 Ceph 级别配置。

```bash
microceph cluster config list [flags]
```

##### `config reset`

清除指定的 Ceph Cluster 配置。

```bash
microceph cluster config reset <key> [flags]
```

标志：

```bash
--wait   		 Wait for required ceph services to restart post config reset.
--skip-restart   Don't perform the daemon restart for current config.
```

##### `config set`

设置指定的 Ceph 集群配置。

```bash
microceph cluster config set <Key> <Value> [flags]
```

Flags: 标志：

```bash
--wait   		 Wait for required ceph services to restart post config set.
--skip-restart   Don't perform the daemon restart for current config.
```

#### `export`

为具有给定名称的 Remote cluster 生成 cluster token。

```bash
microceph cluster export <remote-name> [flags]
```

标志：

```bash
--json   output as json string
```

#### `join`

加入现有集群。

```bash
microceph cluster join <TOKEN> [flags]
```

标志：

```bash
--microceph-ip    string Network address microceph daemon binds to.
```

#### `list`

列出群集中的服务器。

```bash
microceph cluster list [flags]
```

#### `migrate`

将自动服务从一个节点迁移到另一个节点。

```bash
microceph cluster migrate <SRC> <DST [flags]
```

#### `remove`

从群集中删除服务器。

```bash
microceph cluster remove <NAME> [flags]
```

标志：

```bash
-f, --force   Forcibly remove the cluster member
```

#### `sql`

对群集数据库运行 SQL 查询。

```bash
microceph cluster sql <query> [flags]
```

### `disable`

在集群上禁用功能

```bash
microceph disable [flags]
microceph disable [command]
```

可用命令：

```bash
rgw         Disable the RGW service on this node
```

全局标志：

```bash
-d, --debug       Show all debug messages
-h, --help        Print help
    --state-dir   Path to store state information
-v, --verbose     Show all information messages
    --version     Print version number
```

### `disk`

在 MicroCeph 中管理磁盘。

```bash
microceph disk [flags]
microceph disk [command]
```

可用命令：

```bash
add         Add a Ceph disk (OSD)
list        List servers in the cluster
remove      Remove a Ceph disk (OSD)
```

全局标志：

```bash
-d, --debug       Show all debug messages
-h, --help        Print help
    --state-dir   Path to store state information
-v, --verbose     Show all information messages
    --version     Print version number
```

#### `add`

Adds one or more new Ceph disks (OSDs) to the cluster, alongside optional devices for write-ahead logging and database management. The command takes arguments which is either one or more paths to block devices such as /dev/sdb, or a specification for loop files.
将一个或多个新的 Ceph 磁盘 （OSD） 添加到集群中，以及用于预写日志记录和数据库管理的可选设备。该命令采用参数，这些参数是用于块设备（如 /dev/sdb）的一个或多个路径，或者是循环文件的规范。

对于块设备，添加一个以空格分隔的路径列表，例如 “/dev/sda /dev/sdb ...” 。也可以添加 WAL 和 DB 设备，但这样做与一次添加多个 OSD 块设备是互斥的。

loop文件的规范格式为 `loop,<size>,<nr>`

nr is the number of file-backed loop OSDs to create. For instance, a spec of loop,8G,3 will create 3 file-backed OSDs, 8GB each.
size 是带有 M、G 或 T 后缀的整数，表示兆字节、千兆字节或兆字节。nr 是要创建的文件支持的循环 OSD 的数量。例如，一个 `loop,8G,3` 的规范将创建 3 个文件支持的 OSD，每个 8GB。

请注意，循环文件不能与加密或 WAL/DB 设备一起使用。

```bash
microceph disk add <spec> [flags]
```

标志：

```bash
--all-available       add all available devices as OSDs
--db-device string    The device used for the DB
--db-encrypt          Encrypt the DB device prior to use
--db-wipe             Wipe the DB device prior to use
--encrypt             Encrypt the disk prior to use (only block devices)
--wal-device string   The device used for WAL
--wal-encrypt         Encrypt the WAL device prior to use
--wal-wipe            Wipe the WAL device prior to use
--wipe                Wipe the disk prior to use
```

> Note 注意
>
> 只有数据设备是必需的。WAL 和 DB 设备可以通过将某些子系统的管理委托给其他块设备来提高性能。WAL  块设备存储内部日志，而数据库设备存储元数据。只要它们比数据设备更快，使用其中任何一个都应该是有利的。如果两者都没有足够的存储空间，WAL  应优先于 DB。
>
> WAL and DB devices can only be used with data devices that reside on a block device, not with loop files. Loop files do not support encryption.
> WAL 和 DB 设备只能与位于块设备上的数据设备一起使用，而不能与循环文件一起使用。循环文件不支持加密。

#### `list`

列出群集中的磁盘

```bash
microceph disk list [flags]
```

#### `remove`

从群集中删除单个磁盘。

```bash
microceph disk remove <osd-id> [flags]
```

标志：

```
--bypass-safety-checks               Bypass safety checks
--confirm-failure-domain-downgrade   Confirm failure domain downgrade if required
--timeout int                        Timeout to wait for safe removal (seconds) (default: 300)
```

### `enable`

在集群上启用功能或服务。

```bash
microceph enable [flags]
microceph enable [command]
```

可用命令：

```bash
mds         Enable the MDS service on the --target server (default: this server)
mgr         Enable the MGR service on the --target server (default: this server)
mon         Enable the MON service on the --target server (default: this server)
rgw         Enable the RGW service on the --target server (default: this server)
```

全局标志：

```bash
-d, --debug       Show all debug messages
-h, --help        Print help
    --state-dir   Path to store state information
-v, --verbose     Show all information messages
    --version     Print version number
```

#### `mds`

在 --target 服务器（默认：此服务器）上启用 MDS 服务。

```bash
microceph enable mds [--target <server>] [--wait <bool>] [flags]
```

标志：

```bash
--target string   Server hostname (default: this server)
--wait            Wait for mds service to be up. (default true)
```

#### `mgr`

在 --target 服务器（默认：此服务器）上启用 MGR 服务。

```bash
microceph enable mgr [--target <server>] [--wait <bool>] [flags]
```

标志：

```bash
--target string   Server hostname (default: this server)
--wait            Wait for mgr service to be up. (default true)
```

#### `mon`

在 --target 服务器（默认：此服务器）上启用 MON 服务。

```bash
microceph enable mon [--target <server>] [--wait <bool>] [flags]
```

标志：

```bash
--target string   Server hostname (default: this server)
--wait            Wait for mon service to be up. (default true)
```

#### `rgw`

在 --target 服务器（默认：此服务器）上启用 RGW 服务。

```bash
microceph enable rgw [--port <port>] [--ssl-port <port>] [--ssl-certificate <certificate material>] [--ssl-private-key <private key material>] [--target <server>] [--wait <bool>] [flags]
```

Flags: 标志：

```bash
--port int                Service non-SSL port (default: 80) (default 80)
--ssl-port int            Service SSL port (default: 443) (default 443)
--ssl-certificate string  base64 encoded SSL certificate
--ssl-private-key string  base64 encoded SSL private key
--target string           Server hostname (default: this server)
--wait                    Wait for rgw service to be up. (default true)
```

### `help`

为应用程序中的任何命令提供帮助。只需键入 microceph help [命令路径] 即可获得完整详细信息。

```bash
microceph help [command] [flags]
```

全局标志：

```bash
-d, --debug       Show all debug messages
-h, --help        Print help
    --state-dir   Path to store state information
-v, --verbose     Show all information messages
    --version     Print version number
```

### `init`

初始化 MicroCeph（在交互模式下）。

```bash
microceph init [flags]
```

全局标志：

```bash
-d, --debug       Show all debug messages
-h, --help        Print help
    --state-dir   Path to store state information
-v, --verbose     Show all information messages
    --version     Print version number
```

### `pool`

管理 MicroCeph 中的池。

```bash
microceph pool [command]
```

可用命令：

```bash
set-rf      Set the replication factor for pools
```

全局标志：

```bash
-d, --debug       Show all debug messages
-h, --help        Print help
    --state-dir   Path to store state information
-v, --verbose     Show all information messages
    --version     Print version number
```

#### `set-rf`

为群集中的一个或多个池设置复制因子。该命令有两个参数：池规范（字符串）和复制因子（整数）。

池规范可以采用以下三种形式之一：要么是池的列表，用空格分隔，在这种情况下，复制因子仅应用于这些池（如果它们存在）。它也可以是星号 （'*'），在这种情况下，该过程将应用于所有现有池；或空字符串 （''），用于设置默认池大小，但不会更改任何现有池。

```bash
microceph pool set-rf <pool-spec> <replication-factor>
```

### `remote`

Manage MicroCeph remotes.
管理 MicroCeph 远程。

```bash
microceph remote [flags]
microceph remote [command]
```

可用命令：

```bash
import      Import external MicroCeph cluster as a remote
list        List all configured remotes for the site
remove      Remove configured remote
```

全局选项：

```bash
-d, --debug       Show all debug messages
-h, --help        Print help
    --state-dir   Path to store state information
-v, --verbose     Show all information messages
    --version     Print version number
```

#### `import`

Import external MicroCeph cluster as a remote
将外部 MicroCeph 集群导入为远程

```bash
microceph remote import <name> <token> [flags]
```

标志：

```bash
--local-name string   friendly local name for cluster
```

#### `list`

List all configured remotes for the site
列出站点的所有已配置远程

```bash
microceph remote list [flags]
```

标志：

```bash
--json   output as json string
```

#### `remove`

Remove configured remote 删除已配置的远程

```bash
microceph remote remove <name> [flags]
```

### `replication`

```bash
microceph replication [command]
```

可用命令：

```bash
configure   Configure replication parameters for RBD resource (Pool or Image)
disable     Disable replication for RBD resource (Pool or Image)
enable      Enable replication for RBD resource (Pool or Image)
list        List all configured replications.
status      Show RBD resource (Pool or Image) replication status
```

全局选项：

```bash
-d, --debug       Show all debug messages
-h, --help        Print help
    --state-dir   Path to store state information
-v, --verbose     Show all information messages
    --version     Print version number
```

#### `enable`

为 RBD 资源（池或映像）启用复制

```bash
microceph replication enable rbd <resource> [flags]
```

标志：

```bash
--remote string      remote MicroCeph cluster name
--schedule string    snapshot schedule in days, hours, or minutes using d, h, m suffix respectively
--skip-auto-enable   do not auto enable rbd mirroring for all images in the pool.
--type string        'journal' or 'snapshot', defaults to journal (default "journal")
```

#### `status`

显示 RBD 资源（池或映像）复制状态

```bash
microceph replication status rbd <resource> [flags]
```

标志：

```bash
--json   output as json string
```

#### `list`

列出所有已配置的 remotes 复制对。

```bash
microceph replication list rbd [flags]
--json          output as json string
--pool string   RBD pool name
```

#### `disable`

禁用 RBD 资源（池或映像）的复制

```bash
microceph replication disable rbd <resource> [flags]
--force   forcefully disable replication for rbd resource
```

#### `promote`

Promote local cluster to primary
将本地集群提升为主集群

```bash
microceph replication promote [flags]
--remote         remote MicroCeph cluster name
--force          forcefully promote site to primary
```

#### `demote`

将本地集群降级为辅助集群

```bash
microceph replication demote [flags]
--remote         remote MicroCeph cluster name
```

### `status`

报告集群的状态。

```bash
microceph status [flags]
```

全局标志：

```bash
-d, --debug       Show all debug messages
-h, --help        Print help
    --state-dir   Path to store state information
-v, --verbose     Show all information messages
    --version     Print version number
```

## `microceph` charm

The `microceph` charm is used to incorporate MicroCeph into Juju-managed deployments. It offers an alternative method for deploying and managing MicroCeph. In effect, the charm installs the `microceph` snap. As expected, it provides MicroCeph management via standard Juju commands (e.g. `juju config` and `juju run`).
`microceph` charm 用于将 MicroCeph 合并到 Juju 托管的部署中。它提供了一种部署和管理 MicroCeph 的替代方法。实际上，魅力安装了`小头快照`。正如预期的那样，它通过标准 Juju 命令（例如 `juju config` 和 `juju run`）提供 MicroCeph 管理。

For more information, see the [microceph](https://charmhub.io/microceph) entry on the Charmhub.
有关更多信息，请参阅 Charmhub 上的 [microceph](https://charmhub.io/microceph) 条目。

## 集群网络配置

网络配置对于构建高性能 Ceph 存储集群至关重要。

Ceph 客户端直接向 Ceph OSD 守护进程发出请求，即 Ceph 不执行请求路由。OSD  守护进程代表客户端执行数据复制，这意味着复制和其他因素会给 Ceph  存储集群网络带来额外的负载。因此，为了增强安全性和稳定性，将公共网络流量和集群网络流量分开可能是有利的，这样客户端流量就会在公共网络上流动，而集群流量（用于复制和回填）则使用单独的网络。这有助于防止恶意或故障客户端中断集群后端操作。

### 实现

MicroCeph cluster config subcommands rely on `ceph config` as the single source of truth for config values and for getting/setting the configs. After updating (setting/resetting) a config value, a  restart request is sent to other hosts on the MicroCeph cluster for  restarting particular daemons. 
MicroCeph 集群配置子命令依赖 `ceph config` 作为配置值和获取/设置配置的单一事实来源。更新（设置/重置）配置值后，将向 MicroCeph 集群上的其他主机发送重启请求，以重启特定守护进程。执行此操作可使更改生效。

在多节点 MicroCeph 集群中，需要谨慎地以同步方式重启守护进程，以防止集群中断。下面的流程图说明了执行顺序。

 ![](../../../../Image/f/flow.jpg)

## Cluster scaling

MicroCeph 的可扩展性得益于其基于 Ceph 的基础，Ceph 具有出色的扩展能力。若要横向扩展，请向现有群集节点添加计算机，或在节点上引入其他磁盘 （OSD）。

请注意，强烈建议使用大小一致的机器，尤其是较小的集群，以确保 Ceph 充分利用所有可用的磁盘空间。

### 故障域

在 Ceph 领域，[故障域](https://en.wikipedia.org/wiki/Failure_domain)的概念开始发挥作用，以提供数据安全性。故障域是对象副本分布在其中的实体或类别。这可能是 OSD、主机、机架，甚至是更大的聚合，如房间或数据中心。故障域的主要目的是降低在较大的聚合（例如计算机或机架）崩溃或以其他方式不可用时可能发生的大量数据丢失的风险。

数据或对象在各种故障域中的分布是通过 Ceph 的可扩展哈希下的受控复制 （[CRUSH）](https://docs.ceph.com/en/latest/rados/operations/crush-map/) 规则进行管理的。CRUSH 算法使 Ceph 能够在没有任何中央目录的情况下有效地将数据副本分布在各种故障域上，从而在扩展时提供一致的性能。

In simple terms, if one component within a failure domain fails, Ceph’s  built-in redundancy means your data is still accessible from an  alternate location. For instance, with a host-level failure domain, Ceph will ensure that no two replicas are placed on the same host. This  prevents loss of more than one replica should a host crash or get  disconnected. This extends to higher-level aggregates like racks and  rooms as well.
简单来说，如果故障域中的一个组件发生故障，Ceph 的内置冗余意味着您的数据仍然可以从备用位置访问。例如，对于主机级别的故障域，Ceph  将确保没有两个副本放置在同一主机上。这样可以防止在主机崩溃或断开连接时丢失多个副本。这也延伸到更高级别的聚合，如机架和房间。

Furthermore, the CRUSH rules ensure that data is automatically re-distributed if  parts of the system fail, assuring the resiliency and high availability  of your data.
此外，CRUSH 规则可确保在系统的某些部分发生故障时，数据会自动重新分发，从而确保数据的弹性和高可用性。

The flipside is that for a given replication factor and failure domain you  will need the appropriate number of aggregates. So for the default  replication factor of 3 and failure domain at host level you’ll need at  least 3 hosts (of comparable size); for failure domain rack you’ll need  at least 3 racks, etc.
另一方面，对于给定的复制因子和故障域，您将需要适当数量的聚合。因此，对于默认复制因子 3 和主机级别的故障域，您至少需要 3 个主机（大小相当）;对于故障域机架，您至少需要 3 个机架，等等。

###  故障域管理

MicroCeph implements automatic failure domain management at the OSD and host  levels. At the start, CRUSH rules are set for OSD-level failure domain.  This makes single-node clusters viable, provided they have at least 3  OSDs.
MicroCeph 在 OSD 和主机级别实现了自动故障域管理。开始时，为 OSD 级别的故障域设置 CRUSH 规则。这使得单节点集群可行，前提是它们至少有 3 个 OSD。

####  扩容

As you scale up, the failure domain automatically will be upgraded by  MicroCeph. Once the cluster size is increased to 3 nodes having at least one OSD each, the automatic failure domain shifts to the host level to  safeguard data even if an entire host fails. This upgrade typically will need some data redistribution which is automatically performed by Ceph.
随着规模的扩大，MicroCeph 将自动升级故障域。一旦集群大小增加到 3 个节点，每个节点至少有一个 OSD，自动故障域就会转移到主机级别，以保护数据，即使整个主机发生故障也是如此。此升级通常需要一些数据重新分发，该重新分发由 Ceph 自动执行。

####  缩减

Similarly, when scaling down the cluster by removing OSDs or nodes, the automatic  failure domain rules will be downgraded, from the host level to the osd  level. This is done once a cluster has less than 3 nodes with at least  one OSD each. MicroCeph will ask for confirmation if such a downgrade is necessary.
同样，当通过删除 OSD 或节点来缩减集群时，自动故障域规则将从主机级别降级到 osd 级别。如果集群的节点少于 3 个，每个节点至少有一个 OSD，则会执行此操作。MicroCeph 将要求确认是否有必要进行此类降级。

#####  磁盘移除

[disk](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/reference/commands/disk/) 命令（**disk remove**）用于删除 OSD。

###### Automatic failure domain downgrades

######  自动故障域降级

The removal operation will abort if it would lead to a downgrade in failure domain. In such a case, the command’s `--confirm-failure-domain-downgrade` option overrides this behaviour and allows the downgrade to proceed.
如果删除操作会导致故障域降级，则该操作将中止。在这种情况下，命令的 `--confirm-failure-domain-downgrade` 选项会覆盖此行为并允许降级继续进行。

###### Cluster health and safety checks

######  集群健康和安全检查

The removal operation will wait for data to be cleanly redistributed before evicting the OSD. There may be cases however, such as when a cluster is not healthy to begin with, where the redistribution of data is not feasible. In such situations, the command’s `--bypass-safety-checks` option disable these safety checks.
删除操作将等待数据完全重新分发，然后再逐出 OSD。但是，在某些情况下，例如，当集群一开始就不健康时，数据的重新分发是不可行的。在这种情况下，命令的 `--bypass-safety-checks` 选项会禁用这些安全检查。

Warning 警告

The `--bypass-safety-checks` option is intended as a last resort measure only. Its usage may result in data loss.
`--bypass-safety-checks` 选项仅作为最后的手段。它的使用可能会导致数据丢失。

#### Custom Crush Rules

####  自定义粉碎规则

MicroCeph automatically manages two rules, named microceph_auto_osd and microceph_auto_host respectively; these two rules must not be changed. Users can however  freely set custom CRUSH rules anytime. MicroCeph will respect custom  rules and not perform any automatic updates for these. Custom CRUSH  rules can be useful to implement larger failure domains such as rack- or room-level. At the other end of the spectrum, custom CRUSH rules could  be used to enforce OSD-level failure domains for clusters larger than 3  nodes.
MicroCeph 自动管理两条规则，分别命名为 microceph_auto_osd 和 microceph_auto_host;这两条规则不能改变。但是，用户可以随时自由设置自定义 CRUSH 规则。MicroCeph 将遵循自定义规则，并且不会对这些规则执行任何自动更新。自定义 CRUSH  规则可用于实现更大的故障域，例如机架级或房间级。另一方面，自定义 CRUSH 规则可用于为大于 3 个节点的集群强制执行 OSD 级别的故障域。

###  机器选型

Maintaining uniformly sized machines is an important aspect of scaling up  MicroCeph. This means machines should ideally have a similar number of  OSDs and similar disk sizes. This uniformity in machine sizing offers  several advantages:
保持统一大小的机器是扩大 MicroCeph 规模的一个重要方面。这意味着理想情况下，计算机应具有相似数量的 OSD 和相似的磁盘大小。这种机器尺寸的均匀性提供了几个优点：

1. Balanced Cluster: Having nodes with a similar configuration drives a balanced  distribution of data and load in the cluster. It ensures all nodes are  optimally performing and no single node is overstrained, enhancing the  cluster’s overall efficiency.
   平衡集群：具有相似配置的节点可驱动集群中数据和负载的均衡分布。它确保所有节点都处于最佳性能，并且没有单个节点过度疲劳，从而提高了集群的整体效率。
2. Space Utilisation: With similar sized machines, Ceph can optimally use all  available disk space rather than having some remain underutilised and  hence wasted.
   空间利用率：使用类似大小的机器，Ceph 可以最佳地利用所有可用的磁盘空间，而不是让一些磁盘空间未得到充分利用，从而浪费掉。
3. Easy Management: Uniform machines are simpler to manage as each has similar capabilities and resource needs.
   易于管理：统一的机器更易于管理，因为每台机器都有相似的功能和资源需求。

As an example, consider a cluster with 3 nodes with host-level failure  domain and replication factor 3, where one of the nodes has significant  lower disk space available. That node would effectively bottleneck  available disk space, as Ceph needs to ensure one replica of each object is placed on each machine (due to the host-level failure domain).
例如，考虑一个具有 3 个节点的集群，这些节点具有主机级故障域和复制因子 3，其中一个节点的可用磁盘空间明显较低。该节点将有效地限制可用磁盘空间的瓶颈，因为 Ceph 需要确保在每台机器上放置每个对象的一个副本（由于主机级别的故障域）。

## 对工作负载进行备份

The MicroCeph deployed Ceph cluster supports snapshot based backups for Block and File based workloads.
MicroCeph 部署的 Ceph 集群支持基于快照的备份，适用于基于数据块和文件的工作负载。

This document is an index of upstream documentation available for snapshots along with some bridging commentary to help understand it better.
本文档是可用于快照的上游文档索引，以及一些桥接注释，以帮助更好地理解它。

### RBD 快照

Ceph supports creating point in time read-only logical copies. This allows an operator to create a checkpoint for their workload backup. The snapshots can be exported for external backup or kept in Ceph for rollback to older version.
Ceph 支持创建时间点只读逻辑副本。这允许作员为其工作负载备份创建检查点。快照可以导出用于外部备份，也可以保存在 Ceph 中以回滚到旧版本。

#### 先决条件

Refer to [How to mount MicroCeph Block Devices](https://canonical-microceph.readthedocs-hosted.com/en/squid-stable/how-to/mount-block-device/) for getting started with RBD.
请参阅[如何挂载 MicroCeph 块设备](https://canonical-microceph.readthedocs-hosted.com/en/squid-stable/how-to/mount-block-device/) 以开始使用 RBD。

Once you have a the block device mounted and in use, you can jump to [Ceph RBD Snapshots](https://docs.ceph.com/en/latest/rbd/rbd-snapshot/)
挂载并使用块设备后，您可以跳转到 [Ceph RBD 快照](https://docs.ceph.com/en/latest/rbd/rbd-snapshot/)

### CephFS 快照

Similar to RBD snapshots, CephFs snapshots are read-only logical copies of **any chosen sub-directory** of the corresponding filesystem.
与 RBD 快照类似，CephFs 快照是**任何所选子目录**的只读逻辑副本 的相应文件系统。

#### 先决条件

Refer to [How to mount MicroCeph CephFs shares](https://canonical-microceph.readthedocs-hosted.com/en/squid-stable/how-to/mount-cephfs-share/) for getting started with CephFs.
请参阅[如何挂载 MicroCeph CephFs 共享](https://canonical-microceph.readthedocs-hosted.com/en/squid-stable/how-to/mount-cephfs-share/) 以开始使用 CephF。

一旦挂载并使用了文件系统，就可以跳转到 [CephFs 快照](https://docs.ceph.com/en/latest/dev/cephfs-snapshots/)

## 全盘加密

MicroCeph 支持 OSD 上的自动全盘加密 （FDE）。

全磁盘加密是一种安全措施，它通过加密磁盘上的所有信息来保护存储设备上的数据。FDE 通过使数据在没有正确的解密密钥或密码的情况下无法访问，从而在磁盘丢失或被盗的情况下帮助维护数据机密性。

如果磁盘丢失或被盗，未经授权的个人将无法访问加密数据，因为如果没有适当的凭据，加密会使信息无法读取。这有助于防止数据泄露，并防止敏感信息被滥用。

FDE 还消除了在更换磁盘时擦除或物理销毁磁盘的需要，因为即使磁盘不再使用，加密数据也仍然是安全的。如果没有解密密钥，磁盘上的数据实际上将变得无用。

### 实现

添加磁盘时，必须请求对 OSD 进行全磁盘加密。然后，MicroCeph 将生成一个随机密钥，将其存储在 Ceph 集群配置中，并使用它来通过 [LUKS/cryptsetup](https://gitlab.com/cryptsetup/cryptsetup/-/wikis/home) 加密给定的磁盘。

### 先决条件

要使用 FDE，必须满足以下先决条件：

- 已安装的 snapd 守护程序版本必须为 >= 2.59.1
  
- `dm-crypt` 内核模块必须可用。请注意，默认情况下，一些云优化的内核不会提供 dm-crypt。通过运行 `sudo modinfo dm-crypt` 进行检查。
  
- The snap dm-crypt plug has to be connected, and `microceph.daemon` subsequently restarted:
  必须连接 snap dm-crypt 插头，然后`重新启动 microceph.daemon`：

  ```bash
  snap connect microceph:dm-crypt
  snap restart microceph.daemon
  ```

### 限制

**Warning: 警告：**

- It is important to note that MicroCeph FDE *only* encompasses OSDs. Other data, such as state information for monitors, logs, configuration etc., will *not* be encrypted by this mechanism.
  需要注意的是，MicroCeph FDE *仅*包含 OSD。其他数据，例如监视器的状态信息、日志、配置等，不会通过此机制进行加密。
- 另请注意，加密密钥将作为 Ceph 键/值存储的一部分存储在 Ceph MON 上。

### 用法

通过在添加磁盘时传递可选的 `--encrypt` 标志来激活 OSD 的 FDE：

```
microceph disk add /dev/sdx --wipe --encrypt
```

Note there is no facility to encrypt an OSD that is already part of the  cluster. To enable encryption you will have to take the OSD disk out of  the cluster, ensure data is replicated and the cluster converged and is  healthy, and then re-introduce the OSD with encryption.
请注意，没有用于加密已属于集群一部分的 OSD 的工具。要启用加密，您必须将 OSD 磁盘从集群中取出，确保数据已复制且集群收敛且运行正常，然后重新引入带有加密功能的 OSD。

## Snap content interface for MicroCeph

Snap content interfaces enable access to a particular directory from a producer snap. The MicroCeph `ceph-conf` content interface is designed to facilitate access to MicroCeph’s  configuration and credentials. This interface includes information about MON addresses, enabling a consumer snap to connect to the MicroCeph  cluster using this data.
快照内容接口允许从创建者快照访问特定目录。MicroCeph `ceph-conf` 内容接口旨在方便访问 MicroCeph 的配置和凭证。此接口包含有关 MON 地址的信息，使使用者快照能够使用此数据连接到 MicroCeph 集群。

Additionally, the `ceph-conf` content interface also provides version information of the running Ceph software.
此外，`ceph-conf` 内容接口还提供正在运行的 Ceph 软件的版本信息。

### 用法

The usage of the `ceph-conf` interface revolves around providing the consuming snap access to necessary configuration details.
`ceph-conf` 接口的使用围绕着提供对必要配置详细信息的消耗性 snap 访问。

Here is how it can be utilised:
以下是如何使用它：

- Connect to the `ceph-conf` content interface to gain access to MicroCeph’s configuration and credentials.
  连接到 `ceph-conf` 内容接口，获取对 MicroCeph 配置和凭证的访问权限。
- The interface exposes a standard `ceph.conf` configuration file as well Ceph keyrings with administrative privileges.
  该接口公开了一个标准的 `ceph.conf` 配置文件以及具有管理权限的 Ceph 密钥环。
- Use the MON addresses included in the configuration to connect to the MicroCeph cluster.
  使用配置中包含的 MON 地址连接到 MicroCeph 集群。
- The interface provides version information that can be used to set up version-specific clients.
  该接口提供可用于设置特定于版本的客户端的版本信息。

To connect the `ceph-conf` content interface to a consumer snap, use the following command:
要将 `ceph-conf` 内容接口连接到使用者快照，请使用以下命令：

```bash
snap connect <consumer-snap-name>:ceph-conf microceph:ceph-conf
```

Replace `<consumer-snap-name>` with the name of your consumer snap. Once executed, this command  establishes a connection between the consumer snap and the MicroCeph `ceph-conf` interface.
将 `<consumer-snap-name>` 替换为您的使用者快照的名称。执行后，此命令将在使用者 snap 和 MicroCeph `ceph-conf` 接口之间建立连接。