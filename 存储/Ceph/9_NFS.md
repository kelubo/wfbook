# NFS

[TOC]

## 概述

管理 NFS 的最简单方法是使用 `ceph nfs cluster ...` 命令。

> **Note:** 
>
> 只支持 NFSv4 。

## 要求

- Ceph 文件系统
- NFS 服务器主机上的 `libcephfs2` 、`nfs-ganesha` 和 `nfs-ganesha-ceph` 包。
- NFS-Ganesha 服务器主机连接到 Ceph  public 网络。

> Note
>
> 建议将 3.5 或更高版本的 NFS-Ganesha 软件包与 pacific（16.2.x）或更高版本的 Ceph 一起使用。

## 部署 NFS Ganesha

Cephadm 部署 NFS Ganesha 守护程序（或一组守护程序）。NFS 的配置存储在 `.nfs` 池中，导出通过 `ceph nfs export ...` 命令和仪表板管理。

Cephadm 使用预定义的RADOS 池和可选的名称空间部署NFS Ganesha 。

要部署 NFS Ganesha 网关，请执行以下操作： 

```bash
ceph orch apply nfs <svc_id> [--port <pool>] [--placement ...]
```

要在默认端口 2049 上部署服务 id 为 foo 的 NFS，默认位置为单个守护程序：

```bash
ceph orch apply nfs foo
```

## 服务规约

或者，可以使用 YAML 规范应用 NFS 服务。

```yaml
service_type: nfs
service_id: mynfs
placement:
  hosts:
    - host1
    - host2
spec:
  port: 12345
```

在本例中，在 host1 和 host2 上的非默认端口 12345（而不是默认端口 2049 ）上运行服务器。

然后可以通过运行以下命令应用该规范：

```bash
ceph orch apply -i nfs.yaml
```

## 配置 NFS-Ganesha 以导出 CephFS 文件

NFS-Ganesha 提供了一个文件系统抽象层（FSAL）来插入不同的存储后端。FSAL_CEPH 是 CephFS 的 FSAL 插件。对于每个 NFS-Ganesha 导出，FSAL_CEPH 使用 libcephfs 客户端来挂载 NFS-Ganesha 导出的 CephFS 路径。

使用 CephFS 设置 NFS-Ganesha ，包括设置 NFS-Ganesha 和 Ceph 的配置文件， CephX access credentials for the Ceph clients created by NFS-Ganesha to access CephFS. 以及由 NFS-Ganesha 创建的 Ceph 客户端访问 CephFS 的 CephX 访问凭据。

### NFS-Ganesha 配置

下面是一个使用 FSAL_CEPH 配置的 ganesha.conf 示例。

```bash
#
# It is possible to use FSAL_CEPH to provide an NFS gateway to CephFS. The
# following sample config should be useful as a starting point for
# configuration. This basic configuration is suitable for a standalone NFS
# server, or an active/passive configuration managed by some sort of clustering
# software (e.g. pacemaker, docker, etc.).
#
# Note too that it is also possible to put a config file in RADOS, and give
# ganesha a rados URL from which to fetch it. For instance, if the config
# file is stored in a RADOS pool called "nfs-ganesha", in a namespace called
# "ganesha-namespace" with an object name of "ganesha-config":
#
# %url	rados://nfs-ganesha/ganesha-namespace/ganesha-config
#
# If we only export cephfs (or RGW), store the configs and recovery data in
# RADOS, and mandate NFSv4.1+ for access, we can avoid any sort of local
# storage, and ganesha can run as an unprivileged user (even inside a
# locked-down container).
#

NFS_CORE_PARAM
{
	# Ganesha can lift the NFS grace period early if NLM is disabled.
	Enable_NLM = false;

	# rquotad doesn't add any value here. CephFS doesn't support per-uid
	# quotas anyway.
	Enable_RQUOTA = false;

	# In this configuration, we're just exporting NFSv4. In practice, it's
	# best to use NFSv4.1+ to get the benefit of sessions.
	Protocols = 4;
}

NFSv4
{
	# Modern versions of libcephfs have delegation support, though they
	# are not currently recommended in clustered configurations. They are
	# disabled by default but can be re-enabled for singleton or
	# active/passive configurations.
	# Delegations = false;

	# One can use any recovery backend with this configuration, but being
	# able to store it in RADOS is a nice feature that makes it easy to
	# migrate the daemon to another host.
	#
	# For a single-node or active/passive configuration, rados_ng driver
	# is preferred. For active/active clustered configurations, the
	# rados_cluster backend can be used instead. See the
	# ganesha-rados-grace manpage for more information.
	RecoveryBackend = rados_ng;

	# NFSv4.0 clients do not send a RECLAIM_COMPLETE, so we end up having
	# to wait out the entire grace period if there are any. Avoid them.
	Minor_Versions =  1,2;
}

# The libcephfs client will aggressively cache information while it
# can, so there is little benefit to ganesha actively caching the same
# objects. Doing so can also hurt cache coherency. Here, we disable
# as much attribute and directory caching as we can.
MDCACHE {
	# Size the dirent cache down as small as possible.
	Dir_Chunk = 0;
}

EXPORT
{
	# Unique export ID number for this export
	Export_ID=100;

	# We're only interested in NFSv4 in this configuration
	Protocols = 4;

	# NFSv4 does not allow UDP transport
	Transports = TCP;

	#
	# Path into the cephfs tree.
	#
	# Note that FSAL_CEPH does not support subtree checking, so there is
	# no way to validate that a filehandle presented by a client is
	# reachable via an exported subtree.
	#
	# For that reason, we just export "/" here.
	Path = /;

	#
	# The pseudoroot path. This is where the export will appear in the
	# NFS pseudoroot namespace.
	#
	Pseudo = /cephfs_a/;

	# We want to be able to read and write
	Access_Type = RW;

	# Time out attribute cache entries immediately
	Attr_Expiration_Time = 0;

	# Enable read delegations? libcephfs v13.0.1 and later allow the
	# ceph client to set a delegation. While it's possible to allow RW
	# delegations it's not recommended to enable them until ganesha
	# acquires CB_GETATTR support.
	#
	# Note too that delegations may not be safe in clustered
	# configurations, so it's probably best to just disable them until
	# this problem is resolved:
	#
	# http://tracker.ceph.com/issues/24802
	#
	# Delegations = R;

	# NFS servers usually decide to "squash" incoming requests from the
	# root user to a "nobody" user. It's possible to disable that, but for
	# now, we leave it enabled.
	# Squash = root;

	FSAL {
		# FSAL_CEPH export
		Name = CEPH;

		#
		# Ceph filesystems have a name string associated with them, and
		# modern versions of libcephfs can mount them based on the
		# name. The default is to mount the default filesystem in the
		# cluster (usually the first one created).
		#
		# Filesystem = "cephfs_a";

		#
		# Ceph clusters have their own authentication scheme (cephx).
		# Ganesha acts as a cephfs client. This is the client username
		# to use. This user will need to be created before running
		# ganesha.
		#
		# Typically ceph clients have a name like "client.foo". This
		# setting should not contain the "client." prefix.
		#
		# See:
		#
		# http://docs.ceph.com/docs/jewel/rados/operations/user-management/
		#
		# The default is to set this to NULL, which means that the
		# userid is set to the default in libcephfs (which is
		# typically "admin").
		#
		# User_Id = "ganesha";

		#
		# Key to use for the session (if any). If not set, it uses the
		# normal search path for cephx keyring files to find a key:
		#
		# Secret_Access_Key = "YOUR SECRET KEY HERE";
	}
}

# Config block for FSAL_CEPH
CEPH
{
	# Path to a ceph.conf file for this ceph cluster.
	# Ceph_Conf = /etc/ceph/ceph.conf;

	# User file-creation mask. These bits will be masked off from the unix
	# permissions on newly-created inodes.
	# umask = 0;
}

#
# This is the config block for the RADOS RecoveryBackend. This is only
# used if you're storing the client recovery records in a RADOS object.
#
RADOS_KV
{
	# Path to a ceph.conf file for this cluster.
	# Ceph_Conf = /etc/ceph/ceph.conf;

	# The recoverybackend has its own ceph client. The default is to
	# let libcephfs autogenerate the userid. Note that RADOS_KV block does
	# not have a setting for Secret_Access_Key. A cephx keyring file must
	# be used for authenticated access.
	# UserId = "ganesharecov";

	# Pool ID of the ceph storage pool that contains the recovery objects.
	# The default is "nfs-ganesha".
	# pool = "nfs-ganesha";

	# Consider setting a unique nodeid for each running daemon here,
	# particularly if this daemon could end up migrating to a host with
	# a different hostname (i.e. if you're running an active/passive cluster
	# with rados_ng/rados_kv and/or a scale-out rados_cluster). The default
	# is to use the hostname of the node where ganesha is running.
	# nodeid = hostname.example.com
}

# Config block for rados:// URL access. It too uses its own client to access
# the object, separate from the FSAL_CEPH and RADOS_KV client.
RADOS_URLS
{
	# Path to a ceph.conf file for this cluster.
	# Ceph_Conf = /etc/ceph/ceph.conf;

	# RADOS_URLS use their own ceph client too. Authenticated access
	# requires a cephx keyring file.
	# UserId = "ganeshaurls";

	# We can also have ganesha watch a RADOS object for notifications, and
	# have it force a configuration reload when one comes in. Set this to
	# a valid rados:// URL to enable this feature.
	# watch_url = "rados://pool/namespace/object";
}
```

它适用于独立的 NFS-Ganesha 服务器，或由某种集群软件（例如，Pacemaker）管理的主动/被动配置的 NFS-Ganesha 服务器。选项可执行以下操作：

- 尽可能减少 Ganesha 缓存，since the libcephfs clients (of [FSAL_CEPH](https://github.com/nfs-ganesha/nfs-ganesha/tree/next/src/FSAL/FSAL_CEPH)) also cache aggressively因为 libcephfs 客户端（FSAL_CEPH）也会积极缓存。
- read from Ganesha config files stored in RADOS objects从存储在 RADOS 对象中的 Ganesha 配置文件读取。
- store client recovery data in RADOS OMAP key-value interface在RADOS OMAP键-值接口中存储客户端恢复数据
- 授权 NFSv4.1+ 访问。
- 启用读取委托（至少需要 v13.0.1 版本 `libcephfs2` 包和 v2.6.0 stable `nfs-ganesha` 和 `nfs-ganesha-ceph` 包）。

### libcephfs clients 配置

libcephfs 客户端的`ceph.conf` 文件中包含一个 `[client]` 部分，其中设置了 `mon_host` 选项，以让客户端连接到 Ceph 集群的 MON ，通常通过 `ceph config generate-minimal-conf` 生成。例如：

```ini
[client]
        mon host = [v2:192.168.1.7:3300,v1:192.168.1.7:6789], [v2:192.168.1.8:3300,v1:192.168.1.8:6789], [v2:192.168.1.9:3300,v1:192.168.1.9:6789]
```

## 使用 NFSv4 客户端装载

It is preferred to mount the NFS-Ganesha exports using NFSv4.1+ protocols to get the benefit of sessions.最好使用 NFSv4.1+ 协议挂载 NFS-Ganesha 的导出以获得会话的好处。

挂载 NFS 资源的约定是特定于平台的。以下约定适用于 Linux 和某些 Unix 平台：

```bash
mount -t nfs -o nfsvers=4.1,proto=tcp <ganesha-host-name>:<ganesha-pseudo-path> <mount-point>
```



## 高可用性 NFS 

为现有 *nfs* 服务部署 *Ingress* 服务将提供：

- 可用于访问 NFS 服务器的稳定虚拟 IP
- 主机故障时主机之间的故障转移
- load distribution across multiple NFS gateways (although this is rarely necessary)
  跨多个 NFS 网关的负载分配（尽管这很少需要）

可以按照以下规范为现有 NFS 服务（本例中为 `nfs.mynfs`）部署 NFS 的入口：

```yaml
service_type: ingress
service_id: nfs.mynfs
placement:
  count: 2
spec:
  backend_service: nfs.mynfs
  frontend_port: 2049
  monitor_port: 9000
  virtual_ip: 10.0.0.123/24
```

一些说明：

- The *virtual_ip* must include a CIDR prefix length, as in the example above.  The virtual IP will normally be configured on the first identified network interface that has an existing IP in the same subnet.  You can also specify a *virtual_interface_networks* property to match against IPs in other networks; see [Selecting ethernet interfaces for the virtual IP](https://docs.ceph.com/en/latest/cephadm/services/rgw/#ingress-virtual-ip) for more information.
  *virtual_ip* 必须包含 CIDR 前缀长度，如上例所示。虚拟 IP 通常会配置在同一子网中具有现有 IP 的第一个已识别网络接口上。您还可以指定 *virtual_interface_networks* 属性以与其他网络中的 IP 进行匹配;看 [为虚拟 IP 选择以太网接口](https://docs.ceph.com/en/latest/cephadm/services/rgw/#ingress-virtual-ip) 了解更多信息。

- *monitor_port* 用于访问 haproxy 负载状态页面。默认情况下，用户是 `admin`，但可以通过规范中的 *admin* 属性进行修改。如果未通过 spec 中的 *password* 属性指定密码，则可以通过以下方式找到自动生成的密码：

  ```bash
  ceph config-key get mgr/cephadm/ingress.*{svc_id}*/monitor_password
  ```

  例如：

  ```bash
  ceph config-key get mgr/cephadm/ingress.nfs.myfoo/monitor_password
  ```

- The backend service (`nfs.mynfs` in this example) should include a *port* property that is not 2049 to avoid conflicting with the ingress service, which could be placed on the same host(s).
  后端服务（本例中为 `nfs.mynfs`）应包含非 2049 的 *port* 属性，以避免与入口服务冲突，后者可以放置在同一主机上。

### 具有虚拟 IP 但没有 haproxy 的 NFS

Cephadm also supports deploying nfs with keepalived but not haproxy. 
Cephadm 还支持使用 keepalived 而不是 haproxy 部署 nfs。这提供了一个 keepalived 支持的虚拟 IP，nfs 守护程序可以直接绑定到该 IP，而不是让流量通过 haproxy。

在此设置中，需要使用 nfs 模块设置服务（请参阅[创建 NFS Ganesha 集群](https://docs.ceph.com/en/latest/mgr/nfs/#nfs-module-cluster-create)）或首先放置 Ingress 服务，以便存在虚拟 IP 供 nfs 守护程序绑定到。Ingress 服务应包含 `keepalive_only` 设置为 true 的属性。例如

```yaml
service_type: ingress
service_id: nfs.foo
placement:
  count: 1
  hosts:
  - host1
  - host2
  - host3
spec:
  backend_service: nfs.foo
  monitor_port: 9049
  virtual_ip: 192.168.122.100/24
  keepalive_only: true
```

然后，可以创建一个 nfs 服务，该服务指定一个 `virtual_ip` 属性，该属性将指示它绑定到该特定 IP。

```yaml
service_type: nfs
service_id: foo
placement:
  count: 1
  hosts:
  - host1
  - host2
  - host3
spec:
  port: 2049
  virtual_ip: 192.168.122.100
```

请注意，在这些设置中，应确保在 nfs 放置中包含 `count： 1` ，因为只有一个 nfs 守护程序可以绑定到虚拟 IP。

### 支持 HAProxy 协议的 NFS

This works just like High-availability NFS but also supports client IP level configuration on NFS Exports.  This feature requires [NFS-Ganesha v5.0](https://github.com/nfs-ganesha/nfs-ganesha/wiki/ReleaseNotes_5) or later.
Cephadm 支持在高可用性模式下部署 NFS，并带有额外的 HAProxy 协议支持。这与高可用性 NFS 一样，但 支持 NFS 导出上的客户端 IP 级别配置。 此功能需要 [NFS-Ganesha v5.0](https://github.com/nfs-ganesha/nfs-ganesha/wiki/ReleaseNotes_5) 或更高版本。

To use this mode, you’ll either want to set up the service using the nfs module (see [Create NFS Ganesha Cluster](https://docs.ceph.com/en/latest/mgr/nfs/#nfs-module-cluster-create)) or manually create services with the extra parameter `enable_haproxy_protocol` set to true. Both NFS Service and Ingress service must have `enable_haproxy_protocol` set to the same value. For example:
要使用此模式，需要使用 nfs 模块设置服务（请参阅[创建 NFS Ganesha 集群](https://docs.ceph.com/en/latest/mgr/nfs/#nfs-module-cluster-create)）或手动创建服务，并将额外参数 `enable_haproxy_protocol` 设置为 true。NFS 服务和 Ingress 服务必须将 `enable_haproxy_protocol` 设置为相同的值。例如：

```yaml
service_type: ingress
service_id: nfs.foo
placement:
  count: 1
  hosts:
  - host1
  - host2
  - host3
spec:
  backend_service: nfs.foo
  monitor_port: 9049
  virtual_ip: 192.168.122.100/24
  enable_haproxy_protocol: true
service_type: nfs
service_id: foo
placement:
  count: 1
  hosts:
  - host1
  - host2
  - host3
spec:
  port: 2049
  enable_haproxy_protocol: true
```



​			

​				对于每个守护进程，池中会创建一个新用户和一个通用配置。虽然所有集群在集群名称上都有不同的命名空间，但它们使用相同的恢复池。 		 				

**流程**

1. ​						登录到 Cephadm shell： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]# cephadm shell
   ```

2. ​						启用 `mgr/nfs` 模块： 				

   **示例**

   ​							

   ```none
   [ceph: root@host01 /]# ceph mgr module enable nfs
   ```

3. ​						创建集群： 				

   **语法**

   ​							

   ```none
   ceph nfs cluster create CLUSTER_NAME ["HOST_NAME_1_,HOST_NAME_2,HOST_NAME_3"]
   ```

   ​						The *CLUSTER_NAME* 是一个任意字符串，*HOST_NAME_1* 是一个可选字符串，表示主机要部署 NFS-Ganesha 守护进程。 				

   **示例**

   ​							

   ```none
   [ceph: root@host01 /]# ceph nfs cluster create nfsganesha "host01, host02"
   ```

   ​						这会创建一个 NFS_Ganesha 群集 `nfsganesha`，并在 `host01 和 host` `02` 上有一个守护进程。 				

**验证**

- ​						列出集群详情： 				

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph nfs cluster ls
  ```

- ​						显示 NFS-Ganesha 集群信息： 				

  **语法**

  ​							

  ```none
  ceph nfs cluster info CLUSTER_NAME
  ```

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph nfs cluster info nfsganesha
  ```

# 使用命令行界面部署 NFS-Ganesha 网关

​				您可以在后端将 Ceph 编排器与 Cephadm 搭配使用，以按照放置规范部署 NFS-Ganesha 网关。在这种情形中，您必须创建 RADOS 池，并在部署网关之前创建命名空间。 		

注意

​					红帽支持仅通过 NFS v4.0+ 协议进行 CephFS 导出。 							

**流程**

1. ​						登录到 Cephadm shell： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]# cephadm shell
   ```

2. ​						创建 RADOS 池命名空间，并启用应用： 				

   **语法**

   ​							

   ```none
   ceph osd pool create POOL_NAME _
   ceph osd pool application enable POOL_NAME freeform/rgw/rbd/cephfs/nfs
   rbd pool init -p POOL_NAME
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 /]# ceph osd pool create nfs-ganesha
   [ceph: root@host01 /]# ceph osd pool application enable nfs-ganesha nfs
   [ceph: root@host01 /]# rbd pool init -p nfs-ganesha
   ```

3. ​						使用命令行界面中的放置规格部署 NFS-Ganesha 网关： 				

   **语法**

   ​							

   ```none
   ceph orch apply nfs SERVICE_ID --pool POOL_NAME --namespace NAMESPACE --placement="NUMBER_OF_DAEMONS HOST_NAME_1 HOST_NAME_2 HOST_NAME_3"
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 /]# ceph orch apply nfs foo --pool nfs-ganesha --namespace nfs-ns --placement="2 host01 host02"
   ```

   ​						这将通过 `host01 和 host` `02` 上的一个守护进程部署 NFS-Ganesha 群集 `nfsganesha`。 				

**验证**

- ​						列出服务： 				

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph orch ls
  ```

- ​						列出主机、守护进程和进程： 				

  **语法**

  ​							

  ```none
  ceph orch ps --daemon_type=DAEMON_NAME
  ```

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph orch ps --daemon_type=nfs
  ```

# 使用服务规格部署 NFS-Ganesha 网关

​				您可以在后端将 Ceph 编排器与 Cephadm 搭配使用，以按照服务规格部署 NFS-Ganesha 网关。在这种情形中，您必须创建 RADOS 池，并在部署网关之前创建命名空间。 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						主机添加到集群中。 				

**流程**

1. ​						登录到 Cephadm shell： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]# cephadm shell
   ```

2. ​						创建 RADOS 池、命名空间并启用 RBD： 				

   **语法**

   ​							

   ```none
   ceph osd pool create POOL_NAME _
   ceph osd pool application enable POOL_NAME rbd
   rbd pool init -p POOL_NAME
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 /]# ceph osd pool create nfs-ganesha
   [ceph: root@host01 /]#ceph osd pool application enable nfs-ganesha rbd
   [ceph: root@host01 /]#rbd pool init -p nfs-ganesha
   ```

3. ​						进入以下目录： 				

   **语法**

   ​							

   ```none
   cd /var/lib/ceph/DAEMON_PATH/
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 nfs/]# cd /var/lib/ceph/nfs/
   ```

   ​						如果 `nfs` 目录不存在，请在路径中创建目录。 				

4. ​						创建 `nfs.yml` 文件： 				

   **示例**

   ​							

   ```none
   [ceph: root@host01 nfs]# touch nfs.yml
   ```

5. ​						编辑 `nfs.yml` 文件，使其包含以下详情： 				

   **语法**

   ​							

   ```none
   service_type: nfs
   service_id: SERVICE_ID
   placement:
     hosts:
       - HOST_NAME_1
       - HOST_NAME_2
   spec:
     pool: POOL_NAME
     namespace: NAMESPACE
   ```

   **示例**

   ​							

   ```none
   service_type: nfs
   service_id: foo
   placement:
     hosts:
       - host01
       - host02
   spec:
     pool: nfs-ganesha
     namespace: nfs-ns
   ```

6. ​						使用服务规格部署 NFS-Ganesha 网关： 				

   **语法**

   ​							

   ```none
   ceph orch apply -i FILE_NAME.yml
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 nfs]# ceph orch apply -i nfs.yml
   ```

**验证**

- ​						列出服务： 				

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph orch ls
  ```

- ​						列出主机、守护进程和进程： 				

  **语法**

  ​							

  ```none
  ceph orch ps --daemon_type=DAEMON_NAME
  ```

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph orch ps --daemon_type=nfs
  ```



# 使用 Ceph 编排器更新 NFS-Ganesha 集群

​				您可以使用后端中的 Ceph 编排器更改主机上的守护进程放置来更新 NFS-Ganesha 集群。 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						主机添加到集群中。 				
- ​						部署所有管理器、监控器和 OSD 守护进程。 				
- ​						使用 `mgr/nfs` 模块创建的 NFS-Ganesha 群集. 				

**流程**

1. ​						登录到 Cephadm shell： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]# cephadm shell
   ```

2. ​						更新集群： 				

   **语法**

   ​							

   ```none
   ceph orch apply nfs CLUSTER_NAME ["HOST_NAME_1,HOST_NAME_2,HOST_NAME_3"]
   ```

   ​						The *CLUSTER_NAME* 是一个任意字符串，*HOST_NAME_1* 是一个可选字符串，表示主机更新所部署的 NFS-Ganesha 守护进程。 				

   **示例**

   ​							

   ```none
   [ceph: root@host01 /]# ceph orch apply nfs nfsganesha "host02"
   ```

   ​						这将更新 `host02` 上的 `nfsganesha` 集群。 				

**验证**

- ​						列出集群详情： 				

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph nfs cluster ls
  ```

- ​						显示 NFS-Ganesha 集群信息： 				

  **语法**

  ​							

  ```none
  ceph nfs cluster info CLUSTER_NAME
  ```

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph nfs cluster info nfsganesha
  ```

- ​						列出主机、守护进程和进程：+ 				

**语法**

​					

```none
ceph orch ps --daemon_type=DAEMON_NAME
```

​				+ .Example 		

```none
[ceph: root@host01 /]# ceph orch ps --daemon_type=nfs
```



# 使用 Ceph 编排器查看 NFS-Ganesha 集群信息

​				您可以使用 Ceph 编排器查看 NFS-Ganesha 集群的信息。您可以使用其端口、IP 地址以及创建集群的主机名称来获取有关所有 NFS Ganesha 集群或特定集群的信息。 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						主机添加到集群中。 				
- ​						部署所有管理器、监控器和 OSD 守护进程。 				
- ​						使用 `mgr/nfs` 模块创建的 NFS-Ganesha 群集. 				

**流程**

1. ​						登录到 Cephadm shell： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]# cephadm shell
   ```

2. ​						查看 NFS-Ganesha 集群信息： 				

   **语法**

   ​							

   ```none
   ceph nfs cluster info CLUSTER_NAME
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 /]# ceph nfs cluster info nfsganesha
   
   {
       "nfsganesha": [
           {
               "hostname": "host02",
               "ip": [
                   "10.74.251.164"
               ],
               "port": 2049
           }
       ]
   }
   ```



# 使用 Ceph 编排器获取 NFS-Ganesha clutser 日志

​				利用 Ceph 编排器，您可以获取 NFS-Ganesha 集群日志。您需要处于部署该服务的节点。 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						Cephadm 安装在部署了 NFS 的节点上。 				
- ​						所有节点的根级别访问权限。 				
- ​						主机添加到集群中。 				
- ​						使用 `mgr/nfs` 模块创建的 NFS-Ganesha 群集. 				

**流程**

1. ​						以 root 用户身份，获取存储集群的 *FSID* ： 				

   **示例**

   ​							

   ```none
   [root@host03 ~]# cephadm ls
   ```

   ​						复制 *FSID* 和服务的名称。 				

2. ​						获取日志： 				

   **语法**

   ​							

   ```none
   cephadm logs --fsid FSID --name SERVICE_NAME
   ```

   **示例**

   ​							

   ```none
   [root@host03 ~]# cephadm logs --fsid 499829b4-832f-11eb-8d6d-001a4a000635 --name nfs.foo.host03
   ```



# 使用 Ceph 编排器设置自定义 NFS-Ganesha 配置

​				NFS-Ganesha 集群在默认配置块中定义。利用 Ceph 编排器，您可以自定义配置，它们优先于默认配置块。 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						主机添加到集群中。 				
- ​						部署所有管理器、监控器和 OSD 守护进程。 				
- ​						使用 `mgr/nfs` 模块创建的 NFS-Ganesha 群集. 				

**流程**

1. ​						登录到 Cephadm shell： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]# cephadm shell
   ```

2. ​						以下是 NFS-Ganesha 集群默认配置的示例： 				

   **示例**

   ​							

   ```none
   # {{ cephadm_managed }}
   NFS_CORE_PARAM {
           Enable_NLM = false;
           Enable_RQUOTA = false;
           Protocols = 4;
   }
   
   MDCACHE {
           Dir_Chunk = 0;
   }
   
   EXPORT_DEFAULTS {
           Attr_Expiration_Time = 0;
   }
   
   NFSv4 {
           Delegations = false;
           RecoveryBackend = 'rados_cluster';
           Minor_Versions = 1, 2;
   }
   
   RADOS_KV {
           UserId = "{{ user }}";
           nodeid = "{{ nodeid}}";
           pool = "{{ pool }}";
           namespace = "{{ namespace }}";
   }
   
   RADOS_URLS {
           UserId = "{{ user }}";
           watch_url = "{{ url }}";
   }
   
   RGW {
           cluster = "ceph";
           name = "client.{{ rgw_user }}";
   }
   
   %url    {{ url }}
   ```

3. ​						自定义 NFS-Ganesha 集群配置。以下是自定义配置的两个示例： 				

   - ​								更改日志级别： 						

     **示例**

     ​									

     ```none
     LOG {
      COMPONENTS {
          ALL = FULL_DEBUG;
      }
     }
     ```

   - ​								添加自定义导出块： 						

     1. ​										创建 用户。 								

        注意

        ​											在 FSAL 块中指定的用户应当具有正确的 NFS-Ganesha 守护进程，以访问 Ceph 集群。 									

        **语法**

        ​											

        ```none
        ceph auth get-or-create client.USER_NAME mon 'allow r' osd 'allow rw pool=POOL_NAME namespace=NFS_CLUSTER_NAME, allow rw tag cephfs data=FILE_SYSTEM_NAME' mds 'allow rw path=EXPORT_PATH'
        ```

        **示例**

        ​											

        ```none
        [ceph: root@host01 /]# ceph auth get-or-create client.nfstest1 mon 'allow r' osd 'allow rw pool=nfsganesha namespace=nfs_cluster_name, allow rw tag cephfs data=filesystem_name' mds 'allow rw path=export_path
        ```

     2. ​										进入以下目录： 								

        **语法**

        ​											

        ```none
        cd /var/lib/ceph/DAEMON_PATH/
        ```

        **示例**

        ​											

        ```none
        [ceph: root@host01 /]# cd /var/lib/ceph/nfs/
        ```

        ​										如果 `nfs` 目录不存在，请在路径中创建目录。 								

     3. ​										创建新配置文件： 								

        **语法**

        ​											

        ```none
        touch PATH_TO_CONFIG_FILE
        ```

        **示例**

        ​											

        ```none
        [ceph: root@host01 nfs]#  touch nfs-ganesha.conf
        ```

     4. ​										通过添加自定义导出块来编辑 配置文件。它创建一个导出，它由 Ceph NFS 导出接口管理。 								

        **语法**

        ​											

        ```none
        EXPORT {
          Export_Id = NUMERICAL_ID;
          Transports = TCP;
          Path = PATH_WITHIN_CEPHFS;
          Pseudo = BINDING;
          Protocols = 4;
          Access_Type = PERMISSIONS;
          Attr_Expiration_Time = 0;
          Squash = None;
          FSAL {
            Name = CEPH;
            Filesystem = "FILE_SYSTEM_NAME";
            User_Id = "USER_NAME";
            Secret_Access_Key = "USER_SECRET_KEY";
          }
        }
        ```

        **示例**

        ​											

        ```none
        EXPORT {
          Export_Id = 100;
          Transports = TCP;
          Path = /;
          Pseudo = /ceph/;
          Protocols = 4;
          Access_Type = RW;
          Attr_Expiration_Time = 0;
          Squash = None;
          FSAL {
            Name = CEPH;
            Filesystem = "filesystem name";
            User_Id = "user id";
            Secret_Access_Key = "secret key";
          }
        }
        ```

4. ​						应用集群的新配置： 				

   **语法**

   ​							

   ```none
   ceph nfs cluster config set _CLUSTER_NAME_ -i _PATH_TO_CONFIG_FILE_
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 nfs]# ceph nfs cluster config set nfs-ganesha -i /root/nfs-ganesha.conf
   ```

   ​						这也会重启自定义配置的服务。 				

**验证**

- ​						列出服务： 				

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph orch ls
  ```

- ​						列出主机、守护进程和进程： 				

  **语法**

  ​							

  ```none
  ceph orch ps --daemon_type=DAEMON_NAME
  ```

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph orch ps --daemon_type=nfs
  ```

- ​						验证自定义配置： 				

  **语法**

  ​							

  ```none
  ./bin/rados -p POOL_NAME -N CLUSTER_NAME get userconf-nfs.CLUSTER_NAME -
  ```

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ./bin/rados -p nfs-ganesha -N nfsganesha get userconf-nfs.nfsganesha -
  ```

**其它资源**

- ​						如需更多信息，*请参阅红帽 Ceph 存储操作指南* [*中的使用 Ceph 编排器重置自定义 NFS-Ganesha 配置*](https://access.redhat.com/documentation/en-us/red_hat_ceph_storage/5/html-single/operations_guide/#resetting-custom-nfs-ganesha-configuration-using-the-ceph-orchestrator_ops) 一节。 				

​                    [           Previous         ](https://access.redhat.com/documentation/zh-cn/red_hat_ceph_storage/5/html/operations_guide/fetching-the-nfs-ganesha-cluster-logs-using-the-ceph-orchestrator_ops)                                [           Next         ](https://access.redhat.com/documentation/zh-cn/red_hat_ceph_storage/5/html/operations_guide/resetting-custom-nfs-ganesha-configuration-using-the-ceph-orchestrator_ops)            



# 使用 Ceph 编排器重置自定义 NFS-Ganesha 配置

​				利用 Ceph 编排器，您可以将用户定义的配置重置为默认配置。 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						主机添加到集群中。 				
- ​						部署所有管理器、监控器和 OSD 守护进程。 				
- ​						使用 `mgr/nfs` 模块部署的 NFS-Ganesha。 				
- ​						自定义 NFS 集群配置已设置 				

**流程**

1. ​						登录到 Cephadm shell： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]# cephadm shell
   ```

2. ​						重置 NFS_Ganesha 配置： 				

   **语法**

   ​							

   ```none
   ceph nfs cluster config reset CLUSTER_NAME
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 /]# ceph nfs cluster config reset nfsganesha
   ```

**验证**

- ​						列出服务： 				

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph orch ls
  ```

- ​						列出主机、守护进程和进程： 				

  **语法**

  ​							

  ```none
  ceph orch ps --daemon_type=DAEMON_NAME
  ```

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph orch ps --daemon_type=nfs
  ```

- ​						验证自定义配置是否已删除： 				

  **语法**

  ​							

  ```none
  ./bin/rados -p POOL_NAME -N CLUSTER_NAME get userconf-nfs.CLUSTER_NAME -
  ```

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ./bin/rados -p nfs-ganesha -N nfsganesha get userconf-nfs.nfsganesha -
  ```

**其它资源**

- ​						如需更多信息 [*，\*请参阅红帽 Ceph 存储操作指南\* 中的使用 Ceph 编排器创建 NFS-Ganesha 集群*](https://access.redhat.com/documentation/en-us/red_hat_ceph_storage/5/html-single/operations_guide/#creating-the-nfs-ganesha-cluster-using-the-ceph-orchestrator_ops) 章节。 				
- ​						如需更多信息，*请参阅红帽 Ceph 存储操作指南* [*中的使用 Ceph 编排器设置自定义 NFS-Ganesha 配置*](https://access.redhat.com/documentation/en-us/red_hat_ceph_storage/5/html-single/operations_guide/#setting-custom-nfs-ganesha-configuration-using-the-ceph-orchestrator_ops) 一节。 				



# 使用 Ceph 编排器删除 NFS-Ganesha 集群

​				您可以在后端将 Ceph 编排器与 Cephadm 搭配使用，以删除 NFS-Ganesha 集群。 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						主机添加到集群中。 				
- ​						部署所有管理器、监控器和 OSD 守护进程。 				
- ​						使用 `mgr/nfs` 模块创建的 NFS-Ganesha 群集. 				

**流程**

1. ​						登录到 Cephadm shell： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]# cephadm shell
   ```

2. ​						删除集群： 				

   **语法**

   ​							

   ```none
   ceph nfs cluster delete CLUSTER_NAME
   ```

   ​						The *CLUSTER_NAME* 是一个任意字符串。 				

   **示例**

   ​							

   ```none
   [ceph: root@host01 /]# ceph nfs cluster delete nfsganesha
   NFS Cluster Deleted Successfully
   ```

**验证**

- ​						列出集群详情： 				

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph nfs cluster ls
  ```



# 使用 Ceph 编排器删除 NFS-Ganesha 网关

​				您可以使用 `ceph 或ch rm` 命令删除 NFS-Ganesha 网关。 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						所有节点的根级别访问权限。 				
- ​						主机添加到集群中。 				
- ​						主机上至少部署了一个 NFS-Ganesha 网关。 				

**流程**

1. ​						登录到 Cephadm shell： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]# cephadm shell
   ```

2. ​						列出服务： 				

   **示例**

   ​							

   ```none
   [ceph: root@host01 /]# ceph orch ls
   ```

3. ​						删除服务 				

   **语法**

   ​							

   ```none
   ceph orch rm SERVICE_NAME
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 /]# ceph orch rm nfs.foo
   ```

**验证**

- ​						列出主机、守护进程和进程： 				

  **语法**

  ​							

  ```none
  ceph orch ps
  ```

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph orch ps
  ```





Cephadm deploys NFS Ganesha using a pre-defined RADOS *pool* and optional *namespace*

To deploy a NFS Ganesha gateway, run the following command:

```
ceph orch apply nfs *<svc_id>* *<pool>* *<namespace>* --placement="*<num-daemons>* [*<host1>* ...]"
```

For example, to deploy NFS with a service id of *foo*, that will use the RADOS pool *nfs-ganesha* and namespace *nfs-ns*:

```
ceph orch apply nfs foo nfs-ganesha nfs-ns
```

Note

Create the *nfs-ganesha* pool first if it doesn’t exist.

See [Placement Specification](https://docs.ceph.com/en/latest/cephadm/service-management/#orchestrator-cli-placement-spec) for details of the placement specification.
