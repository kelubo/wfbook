# SMB

[TOC]

## 概述

> **警告**
>
> Unless the smb module has been determined to be unsuitable for your needs we recommend using that module over directly using the smb service spec.
> SMB 支持正在积极开发中，许多功能可能缺失或不成熟。名为 smb 的 Ceph MGR 模块可用于帮助组织和管理与 SMB 相关的功能。除非已确定 smb 模块不适合您的需求，否则我们建议使用该模块，而不是直接使用 smb 服务规范。

## 部署 Samba 容器

Cephadm 使用 [samba-container 项目](http://github.com/samba-in-kubernetes/samba-container)构建的容器镜像部署 [Samba](http://www.samba.org) 服务器。

要托管可访问 CephFS 文件系统的 SMB 共享，请使用以下命令部署 Samba 容器：

```bash
ceph orch apply smb <cluster_id> <config_uri> [--features ...] [--placement ...] ...
```

该命令接受许多其他参数。有关这些选项的说明，请参阅服务规范。

## 服务规范

可以使用规范应用 SMB 服务。YAML 中的示例如下：

```yaml
service_type: smb
service_id: tango
placement:
  hosts:
    - ceph0
spec:
  cluster_id: tango
  features:
    - domain
  config_uri: rados://.smb/tango/scc.toml
  custom_dns:
    - "192.168.76.204"
  join_sources:
    - "rados:mon-config-key:smb/config/tango/join1.json"
  include_ceph_users:
    - client.smb.fs.cluster.tango
```

然后，可以通过运行以下命令来应用规范：

```bash
ceph orch apply -i smb.yaml
```

### 服务规范选项

特定于 SMB 服务的 `spec` 部分的字段如下所述。

- cluster_id

  A short name identifying the SMB “cluster”. In this case a cluster is simply a management unit of one or more Samba services sharing a common configuration, and may not provide actual clustering or availability mechanisms. 标识 SMB “群集” 的短名称。在这种情况下，集群只是一个或多个共享通用配置的 Samba 服务的管理单元，可能不提供实际的集群或可用性机制。

- features 特征

  A list of pre-defined terms enabling specific deployment characteristics. An empty list is valid. Supported terms: 启用特定部署特征的预定义术语列表。空列表有效。支持的术语： `domain`: Enable domain member mode `domain`：启用域成员模式 `clustered`: Enable Samba native cluster mode `clustered`：启用 Samba 原生集群模式

- config_uri

  A string containing a (standard or de-facto) URI that identifies a configuration source that should be loaded by the samba-container as the primary configuration file. Supported URI schemes include `http:`, `https:`, `rados:`, and `rados:mon-config-key:`. 一个包含（标准或事实上的）URI 的字符串，用于标识应由 samba 容器作为主配置文件加载的配置源。支持的 URI 方案包括 `http：`、`https：`、`rados：` 和 `rados：mon-config-key：`。

- user_sources

  A list of strings with (standard or de-facto) URI values that will be used to identify where credentials for authentication are located. See `config_uri` for the supported list of URI schemes. 具有 （标准或事实上的） URI 值的字符串列表，这些值将用于标识身份验证凭据的位置。有关支持的 URI 方案列表，请参阅 `config_uri`。

- join_sources

  A list of strings with (standard or de-facto) URI values that will be used to identify where authentication data that will be used to perform domain joins are located. Each join source is tried in sequence until one succeeds. See `config_uri` for the supported list of URI schemes. 具有（标准或事实上的）URI 值的字符串列表，这些值将用于标识将用于执行域加入的身份验证数据的位置。将按顺序尝试每个联接源，直到一个联接源成功。有关支持的 URI 方案列表，请参阅 `config_uri`。

- custom_dns

  A list of IP addresses that will be used as the DNS servers for a Samba container. This features allows Samba Containers to integrate with Active Directory even if the Ceph host nodes are not tied into the Active Directory DNS domain(s). 将用作 Samba 容器的 DNS 服务器的 IP 地址列表。此功能允许 Samba 容器与 Active Directory 集成，即使 Ceph 主机节点未绑定到 Active Directory DNS 域。

- include_ceph_users

  A list of cephx user (aka entity) names that the Samba Containers may use. The cephx keys for each user in the list will automatically be added to the keyring in the container. Samba 容器可以使用的 cephx 用户（又名实体）名称的列表。列表中每个用户的 cephx 密钥将自动添加到容器的密钥环中。

- cluster_meta_uri

  A string containing a URI that identifies where the cluster structure metadata will be stored. Required if `clustered` feature is set. Must be a RADOS pseudo-URI. 一个字符串，其中包含一个 URI，用于标识群集结构元数据的存储位置。如果设置`了 clustered feature，`则为必需。必须是 RADOS 伪 URI。

- cluster_lock_uri

  A string containing a URI that identifies where Samba/CTDB will store a cluster lock. Required if `clustered` feature is set. Must be a RADOS pseudo-URI. 一个包含 URI 的字符串，用于标识 Samba/CTDB 将存储群集锁的位置。如果设置`了 clustered feature，`则为必需。必须是 RADOS 伪 URI。

- cluster_public_addrs

  List of objects; optional. Supported only when using Samba’s clustering. Assign “virtual” IP addresses that will be managed by the clustering subsystem and may automatically move between nodes running Samba containers. Fields: 对象列表;自选。仅在使用 Samba 的集群时受支持。分配“虚拟”IP 地址，该地址将由集群子系统管理，并可能在运行 Samba 容器的节点之间自动移动。领域： address 地址Required string. An IP address with a required prefix length (example: `192.168.4.51/24`). This address will be assigned to one of the host’s network devices and managed automatically. 必需字符串。具有所需前缀长度的 IP 地址（例如： `192.168.4.51/24`）。此地址将分配给主机的网络设备之一并自动管理。 destination 目的地Optional. String or list of strings. A `destination` defines where the system will assign the managed IPs. Each string value must be a network address (example `192.168.4.0/24`). One or more destinations may be supplied. The typical case is to use exactly one destination and so the value may be supplied as a string, rather than a list with a single item. Each destination network will be mapped to a device on a host. Run `cephadm list-networks` for an example of these mappings. If destination is not supplied the network is automatically determined using the address value supplied and taken as the destination. 自选。字符串或字符串列表。`目标`定义系统将托管 IP 分配到的位置。每个字符串值都必须是一个网络地址（例如 `192.168.4.0/24`）。可能会提供一个或多个目的地。典型情况是只使用一个目标，因此该值可以作为字符串提供，而不是作为包含单个项目的列表提供。每个目标网络都将映射到主机上的设备。运行 `cephadm list-networks` 以获取这些映射的示例。如果未提供 destination，则使用提供的地址值自动确定网络，并将其作为 destination。

> **注意**
>
> If one desires clustering between smbd instances (also known as High-Availability or “transparent state migration”) the feature flag `clustered` is needed. If this flag is not specified cephadm may deploy multiple smb servers but they will lack the coordination needed of an actual Highly-Avaiable cluster. When the `clustered` flag is specified cephadm will deploy additional containers that manage this coordination. Additionally, the cluster_meta_uri and cluster_lock_uri values must be specified. The former is used by cephadm to describe the smb cluster layout to the samba containers. The latter is used by Samba’s CTDB component to manage an internal cluster lock.
> 如果希望在 smbd 实例（也称为 高可用性或“透明状态迁移”）功能标志 `clustered` 是必需的。如果未指定此标志，cephadm 可能会部署多个 smb 服务器，但它们将缺乏实际高可用性集群所需的协调。指定 `clustered` 标志后，cephadm 将部署管理此协调的其他容器。此外，还必须指定 cluster_meta_uri 和 cluster_lock_uri  值。cephadm 使用前者来描述 samba 容器的 smb 集群布局。Samba 的 CTDB 组件使用后者来管理内部集群锁。

### 配置 SMB 服务

> Warning 警告
>
> A Manager module for SMB is under active development. Once that module is available it will be the preferred method for managing Samba on Ceph in an end-to-end manner. The following discussion is provided for the sake of completeness and to explain how the software layers interact.
> SMB 的 Manager 模块正在积极开发中。该模块可用后，它将成为以端到端方式管理 Ceph 上的 Samba 的首选方法。为了完整起见，并解释软件层如何交互，提供了以下讨论。

Creating an SMB Service spec is not sufficient for complete operation of a Samba Container on Ceph. It is important to create valid configurations and place them in locations that the container can read. The complete specification of these configurations is out of scope for this document. You can refer to the [documentation for Samba](https://wiki.samba.org/index.php/Main_Page) as well as the [samba server container](https://github.com/samba-in-kubernetes/samba-container/blob/master/docs/server.md) and the [configuation file](https://github.com/samba-in-kubernetes/sambacc/blob/master/docs/configuration.md) it accepts.
创建 SMB 服务规范不足以完成 Ceph 上的 Samba 容器。创建有效的配置和 将它们放置在容器可以读取的位置。完整规格 超出了本文档的范围。您可以参考 [Samba](https://wiki.samba.org/index.php/Main_Page) 和 [Samba 服务器容器](https://github.com/samba-in-kubernetes/samba-container/blob/master/docs/server.md)的文档 和[配置文件](https://github.com/samba-in-kubernetes/sambacc/blob/master/docs/configuration.md) 它接受。

When one has composed a configuration it should be stored in a location that the Samba Container can access. The recommended approach for running Samba Containers within Ceph orchestration is to store the configuration in the Ceph cluster. There are a few ways to store the configuration in ceph:
当一个人编写了一个配置后，它应该存储在 Samba 容器可以访问的位置。在 Ceph 编排中运行 Samba 容器的推荐方法是将配置存储在 Ceph 集群中。有几种方法可以将配置存储在 ceph 中：

#### RADOS

A configuration file can be stored as a RADOS object in a pool named `.smb`. Within the pool there should be a namespace named after the `cluster_id` value. The URI used to identify this resource should be constructed like `rados://.smb/<cluster_id>/<object_name>`. Example: `rados://.smb/tango/config.json`.
配置文件可以作为 RADOS 对象存储在名为 `.smb` 的存储池中。在池中，应该有一个以 `cluster_id`值。用于标识此资源的 URI 应构造如下 `rados://.smb/<cluster_id>/<object_name>` 。例： `rados://.smb/tango/config.json` .

The containers are automatically deployed with cephx keys allowing access to resources in these pools and namespaces. As long as this scheme is used no additional configuration to read the object is needed.
容器使用 cephx 密钥自动部署，允许访问这些池和命名空间中的资源。只要使用此方案，就不需要额外的配置来读取对象。

To copy a configuration file to a RADOS pool, use the `rados` command line tool. For example:
要将配置文件复制到 RADOS 池，请使用 `rados` 命令行工具。例如：

```
# assuming your config file is /tmp/config.json
rados --pool=.smb --namespace=tango put config.json /tmp/config.json
```

#### MON Key/Value Store

A configuration file can be stored as a value in the Ceph Monitor Key/Value store.  The key must be named after the cluster like so: `smb/config/<cluster_id>/<name>`.  This results in a URI that can be used to identify this configuration constructed like `rados:mon-config-key:smb/config/<cluster_id>/<name>`. Example: `rados:mon-config-key:smb/config/tango/config.json`.
配置文件可以作为值存储在 Ceph 监控器 Key/Value 中 商店。 该键必须以集群命名，如下所示： `smb/config/<cluster_id>/<name>` 。 这将生成一个 URI，该 URI 可用于 识别此构造的配置，如 `rados:mon-config-key:smb/config/<cluster_id>/<name>` 。示例： `rados:mon-config-key:smb/config/tango/config.json` .

The containers are automatically deployed with cephx keys allowing access to resources with the key-prefix `smb/config/<cluster_id>/`. As long as this scheme is used no additional configuration to read the value is needed.
容器使用 cephx 密钥自动部署，允许访问密钥前缀为 `smb/config/<cluster_id>/` 的资源。只要使用此方案，就不需要额外的配置来读取该值。

To copy a configuration file into the Key/Value store use the `ceph config-key put ...` tool. For example:
要将配置文件复制到键/值存储中，请使用 `ceph config-key put ...` 工具。例如：

```
# assuming your config file is /tmp/config.json
ceph config-key set smb/config/tango/config.json -i /tmp/config.json
```

#### HTTP/HTTPS

配置文件可以存储在 HTTP(S) 服务器上，并由 Samba 容器自动读取。

> **注意**
>
> All URI schemes are supported by parameters that accept URIs. Each scheme has different performance and security characteristics.
> 接受 URI 的参数支持所有 URI 方案。每个方案都有不同的性能和安全特征。

## 限制

SMB 服务的重要限制的非详尽列表如下：

- If one is configuring the SMB service for domain membership, either the Ceph host node must be configured so that it can resolve the Active Directory (AD) domain or the `custom_dns` option may be used. In both cases DNS hosts for the AD domain must still be reachable from whatever network segment the ceph cluster is on.
  DNS 是 Active Directory 的关键组件。如果要配置 SMB 服务，则 Ceph 主机节点必须为 配置，以便它可以解析 Active Directory （AD） 域或 可以使用`custom_dns`选项。在这两种情况下，AD 域的 DNS 主机仍必须可从 ceph 集群所在的任何网段访问。
- 服务必须绑定到 TCP 端口 445。尚不支持在同一节点上运行多个 SMB 服务，并且会触发 port-in-use 冲突。