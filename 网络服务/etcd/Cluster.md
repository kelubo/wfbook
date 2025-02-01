Bootstrapping an etcd cluster: Static, etcd Discovery, and DNS Discovery
引导 etcd 集群：静态、etcd 发现和 DNS 发现



## Overview 概述

Starting an etcd cluster statically requires that each member knows another in  the cluster. In a number of cases, the IPs of the cluster members may be unknown ahead of time. In these cases, the etcd cluster can be  bootstrapped with the help of a discovery service.
静态启动 etcd 集群需要每个成员都认识集群中的另一个成员。在许多情况下，集群成员的 IP 可能提前未知。在这些情况下，可以在发现服务的帮助下引导 etcd 集群。

Once an etcd cluster is up and running, adding or removing members is done via [runtime reconfiguration](https://etcd.io/docs/v3.5/op-guide/runtime-configuration/). To better understand the design behind runtime reconfiguration, we suggest reading [the runtime configuration design document](https://etcd.io/docs/v3.5/op-guide/runtime-reconf-design/).
一旦 etcd 集群启动并运行，通过运行时重新配置来添加或删除成员。为了更好地理解运行时重新配置背后的设计，我们建议阅读运行时配置设计文档。

This guide will cover the following mechanisms for bootstrapping an etcd cluster:
本指南将介绍以下引导 etcd 集群的机制：

- [Static 静态的](https://etcd.io/docs/v3.5/op-guide/clustering/#static)
- [etcd Discovery etcd 发现](https://etcd.io/docs/v3.5/op-guide/clustering/#etcd-discovery)
- [DNS Discovery DNS 发现](https://etcd.io/docs/v3.5/op-guide/clustering/#dns-discovery)

Each of the bootstrapping mechanisms will be used to create a three machine etcd cluster with the following details:
每个引导机制都将用于创建一个具有以下详细信息的三机器 etcd 集群：

| Name 名字        | Address 地址 | Hostname 主机名    |
| ---------------- | ------------ | ------------------ |
| infra0 基础设施0 | 10.0.1.10    | infra0.example.com |
| infra1 基础设施1 | 10.0.1.11    | infra1.example.com |
| infra2 基础设施2 | 10.0.1.12    | infra2.example.com |

## Static 静态的

As we know the cluster members, their addresses and the size of the  cluster before starting, we can use an offline bootstrap configuration  by setting the `initial-cluster` flag. Each machine will get either the following environment variables or command line:
由于我们在开始之前就知道集群成员、他们的地址和集群的大小，我们可以通过设置 `initial-cluster` 标志来使用离线引导配置。每台计算机都将获得以下环境变量或命令行：

```
ETCD_INITIAL_CLUSTER="infra0=http://10.0.1.10:2380,infra1=http://10.0.1.11:2380,infra2=http://10.0.1.12:2380"
ETCD_INITIAL_CLUSTER_STATE=new
--initial-cluster infra0=http://10.0.1.10:2380,infra1=http://10.0.1.11:2380,infra2=http://10.0.1.12:2380 \
--initial-cluster-state new
```

Note that the URLs specified in `initial-cluster` are the *advertised peer URLs*, i.e. they should match the value of `initial-advertise-peer-urls` on the respective nodes.
请注意，中 `initial-cluster` 指定的 URL 是通告的对等 URL，即它们应与相应节点 `initial-advertise-peer-urls` 上的值匹配。

If spinning up multiple clusters (or creating and destroying a single  cluster) with same configuration for testing purpose, it is highly  recommended that each cluster is given a unique `initial-cluster-token`. By doing this, etcd can generate unique cluster IDs and member IDs for  the clusters even if they otherwise have the exact same configuration.  This can protect etcd from cross-cluster-interaction, which might  corrupt the clusters.
如果出于测试目的使用相同的配置启动多个集群（或创建和销毁单个集群），强烈建议为每个集群提供唯一的 `initial-cluster-token` .通过这样做，etcd 可以为集群生成唯一的集群 ID 和成员 ID，即使它们具有完全相同的配置。这可以保护 etcd 免受跨集互的影响，这可能会损坏集群。

etcd listens on [`listen-client-urls`](https://etcd.io/docs/v3.5/op-guide/configuration/#member) to accept client traffic. etcd member advertises the URLs specified in [`advertise-client-urls`](https://etcd.io/docs/v3.5/op-guide/configuration/#clustering) to other members, proxies, clients. Please make sure the `advertise-client-urls` are reachable from intended clients. A common mistake is setting `advertise-client-urls` to localhost or leave it as default if the remote clients should reach etcd.
etcd 侦听 `listen-client-urls` 以接受客户端流量。etcd 成员将指定的 URL 通告 `advertise-client-urls` 给其他成员、代理、客户端。请确保可以从预期客户那里联系到。 `advertise-client-urls` 一个常见的错误是设置为 `advertise-client-urls` localhost 或将其保留为默认值，如果远程客户端应该到达 etcd。

On each machine, start etcd with these flags:
在每台机器上，使用以下标志启动 etcd：

```
$ etcd --name infra0 --initial-advertise-peer-urls http://10.0.1.10:2380 \
  --listen-peer-urls http://10.0.1.10:2380 \
  --listen-client-urls http://10.0.1.10:2379,http://127.0.0.1:2379 \
  --advertise-client-urls http://10.0.1.10:2379 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster infra0=http://10.0.1.10:2380,infra1=http://10.0.1.11:2380,infra2=http://10.0.1.12:2380 \
  --initial-cluster-state new
$ etcd --name infra1 --initial-advertise-peer-urls http://10.0.1.11:2380 \
  --listen-peer-urls http://10.0.1.11:2380 \
  --listen-client-urls http://10.0.1.11:2379,http://127.0.0.1:2379 \
  --advertise-client-urls http://10.0.1.11:2379 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster infra0=http://10.0.1.10:2380,infra1=http://10.0.1.11:2380,infra2=http://10.0.1.12:2380 \
  --initial-cluster-state new
$ etcd --name infra2 --initial-advertise-peer-urls http://10.0.1.12:2380 \
  --listen-peer-urls http://10.0.1.12:2380 \
  --listen-client-urls http://10.0.1.12:2379,http://127.0.0.1:2379 \
  --advertise-client-urls http://10.0.1.12:2379 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster infra0=http://10.0.1.10:2380,infra1=http://10.0.1.11:2380,infra2=http://10.0.1.12:2380 \
  --initial-cluster-state new
```

The command line parameters starting with `--initial-cluster` will be ignored on subsequent runs of etcd. Feel free to remove the  environment variables or command line flags after the initial bootstrap  process. If the configuration needs changes later (for example, adding  or removing members to/from the cluster), see the [runtime configuration](https://etcd.io/docs/v3.5/op-guide/runtime-configuration/) guide.
以 开头 `--initial-cluster` 的命令行参数将在 etcd 的后续运行中被忽略。在初始引导过程之后，可以随意删除环境变量或命令行标志。如果以后需要更改配置（例如，在集群中添加或删除成员），请参阅运行时配置指南。

### TLS

etcd supports encrypted communication through the TLS protocol. TLS channels can be used for encrypted internal cluster communication between peers  as well as encrypted client traffic. This section provides examples for  setting up a cluster with peer and client TLS. Additional information  detailing etcd’s TLS support can be found in the [security guide](https://etcd.io/docs/v3.5/op-guide/security/).
etcd 支持通过 TLS 协议进行加密通信。TLS 通道可用于对等方之间的加密内部集群通信以及加密的客户端流量。本部分提供了使用对等和客户端 TLS 设置集群的示例。有关 etcd 的 TLS 支持的其他详细信息，请参阅安全指南。

#### Self-signed certificates 自签名证书

A cluster using self-signed certificates both encrypts traffic and  authenticates its connections. To start a cluster with self-signed  certificates, each cluster member should have a unique key pair (`member.crt`, `member.key`) signed by a shared cluster CA certificate (`ca.crt`) for both peer connections and client connections. Certificates may be generated by following the etcd [TLS setup](https://github.com/etcd-io/etcd/tree/master/hack/tls-setup) example.
使用自签名证书的集群既对流量进行加密，又对其连接进行身份验证。要使用自签名证书启动集群，每个集群成员都应具有由共享集群 CA 证书 （ `ca.crt` ） 签名的唯一密钥对 `member.crt` （ ， `member.key` ），用于对等连接和客户端连接。可以按照 etcd TLS 设置示例生成证书。

On each machine, etcd would be started with these flags:
在每台机器上，etcd 将使用以下标志启动：

```
$ etcd --name infra0 --initial-advertise-peer-urls https://10.0.1.10:2380 \
  --listen-peer-urls https://10.0.1.10:2380 \
  --listen-client-urls https://10.0.1.10:2379,https://127.0.0.1:2379 \
  --advertise-client-urls https://10.0.1.10:2379 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster infra0=https://10.0.1.10:2380,infra1=https://10.0.1.11:2380,infra2=https://10.0.1.12:2380 \
  --initial-cluster-state new \
  --client-cert-auth --trusted-ca-file=/path/to/ca-client.crt \
  --cert-file=/path/to/infra0-client.crt --key-file=/path/to/infra0-client.key \
  --peer-client-cert-auth --peer-trusted-ca-file=ca-peer.crt \
  --peer-cert-file=/path/to/infra0-peer.crt --peer-key-file=/path/to/infra0-peer.key
$ etcd --name infra1 --initial-advertise-peer-urls https://10.0.1.11:2380 \
  --listen-peer-urls https://10.0.1.11:2380 \
  --listen-client-urls https://10.0.1.11:2379,https://127.0.0.1:2379 \
  --advertise-client-urls https://10.0.1.11:2379 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster infra0=https://10.0.1.10:2380,infra1=https://10.0.1.11:2380,infra2=https://10.0.1.12:2380 \
  --initial-cluster-state new \
  --client-cert-auth --trusted-ca-file=/path/to/ca-client.crt \
  --cert-file=/path/to/infra1-client.crt --key-file=/path/to/infra1-client.key \
  --peer-client-cert-auth --peer-trusted-ca-file=ca-peer.crt \
  --peer-cert-file=/path/to/infra1-peer.crt --peer-key-file=/path/to/infra1-peer.key
$ etcd --name infra2 --initial-advertise-peer-urls https://10.0.1.12:2380 \
  --listen-peer-urls https://10.0.1.12:2380 \
  --listen-client-urls https://10.0.1.12:2379,https://127.0.0.1:2379 \
  --advertise-client-urls https://10.0.1.12:2379 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster infra0=https://10.0.1.10:2380,infra1=https://10.0.1.11:2380,infra2=https://10.0.1.12:2380 \
  --initial-cluster-state new \
  --client-cert-auth --trusted-ca-file=/path/to/ca-client.crt \
  --cert-file=/path/to/infra2-client.crt --key-file=/path/to/infra2-client.key \
  --peer-client-cert-auth --peer-trusted-ca-file=ca-peer.crt \
  --peer-cert-file=/path/to/infra2-peer.crt --peer-key-file=/path/to/infra2-peer.key
```

#### Automatic certificates 自动证书

If the cluster needs encrypted communication but does not require  authenticated connections, etcd can be configured to automatically  generate its keys. On initialization, each member creates its own set of keys based on its advertised IP addresses and hosts.
如果集群需要加密通信，但不需要经过身份验证的连接，则可以将 etcd 配置为自动生成其密钥。初始化时，每个成员都会根据其播发的 IP 地址和主机创建自己的一组密钥。

On each machine, etcd would be started with these flags:
在每台机器上，etcd 将使用以下标志启动：

```
$ etcd --name infra0 --initial-advertise-peer-urls https://10.0.1.10:2380 \
  --listen-peer-urls https://10.0.1.10:2380 \
  --listen-client-urls https://10.0.1.10:2379,https://127.0.0.1:2379 \
  --advertise-client-urls https://10.0.1.10:2379 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster infra0=https://10.0.1.10:2380,infra1=https://10.0.1.11:2380,infra2=https://10.0.1.12:2380 \
  --initial-cluster-state new \
  --auto-tls \
  --peer-auto-tls
$ etcd --name infra1 --initial-advertise-peer-urls https://10.0.1.11:2380 \
  --listen-peer-urls https://10.0.1.11:2380 \
  --listen-client-urls https://10.0.1.11:2379,https://127.0.0.1:2379 \
  --advertise-client-urls https://10.0.1.11:2379 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster infra0=https://10.0.1.10:2380,infra1=https://10.0.1.11:2380,infra2=https://10.0.1.12:2380 \
  --initial-cluster-state new \
  --auto-tls \
  --peer-auto-tls
$ etcd --name infra2 --initial-advertise-peer-urls https://10.0.1.12:2380 \
  --listen-peer-urls https://10.0.1.12:2380 \
  --listen-client-urls https://10.0.1.12:2379,https://127.0.0.1:2379 \
  --advertise-client-urls https://10.0.1.12:2379 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster infra0=https://10.0.1.10:2380,infra1=https://10.0.1.11:2380,infra2=https://10.0.1.12:2380 \
  --initial-cluster-state new \
  --auto-tls \
  --peer-auto-tls
```

### Error cases 错误情况

In the following example, we have not included our new host in the list of enumerated nodes. If this is a new cluster, the node *must* be added to the list of initial cluster members.
在以下示例中，我们尚未将新主机包含在枚举节点列表中。如果这是一个新集群，则必须将节点添加到初始集群成员列表中。

```
$ etcd --name infra1 --initial-advertise-peer-urls http://10.0.1.11:2380 \
  --listen-peer-urls https://10.0.1.11:2380 \
  --listen-client-urls http://10.0.1.11:2379,http://127.0.0.1:2379 \
  --advertise-client-urls http://10.0.1.11:2379 \
  --initial-cluster infra0=http://10.0.1.10:2380 \
  --initial-cluster-state new
etcd: infra1 not listed in the initial cluster config
exit 1
```

In this example, we are attempting to map a node (infra0) on a different  address (127.0.0.1:2380) than its enumerated address in the cluster list (10.0.1.10:2380). If this node is to listen on multiple addresses, all  addresses *must* be reflected in the “initial-cluster” configuration directive.
在此示例中，我们尝试将节点 （infra0） 映射到与其在群集列表中枚举的地址 （10.0.1.10：2380） 不同的地址 （127.0.0.1：2380）  上。如果此节点要侦听多个地址，则所有地址都必须反映在“initial-cluster”配置指令中。

```
$ etcd --name infra0 --initial-advertise-peer-urls http://127.0.0.1:2380 \
  --listen-peer-urls http://10.0.1.10:2380 \
  --listen-client-urls http://10.0.1.10:2379,http://127.0.0.1:2379 \
  --advertise-client-urls http://10.0.1.10:2379 \
  --initial-cluster infra0=http://10.0.1.10:2380,infra1=http://10.0.1.11:2380,infra2=http://10.0.1.12:2380 \
  --initial-cluster-state=new
etcd: error setting up initial cluster: infra0 has different advertised URLs in the cluster and advertised peer URLs list
exit 1
```

If a peer is configured with a different set of configuration arguments  and attempts to join this cluster, etcd will report a cluster ID  mismatch will exit.
如果对等节点配置了一组不同的配置参数并尝试加入此集群，则 etcd 将报告集群 ID 不匹配将退出。

```
$ etcd --name infra3 --initial-advertise-peer-urls http://10.0.1.13:2380 \
  --listen-peer-urls http://10.0.1.13:2380 \
  --listen-client-urls http://10.0.1.13:2379,http://127.0.0.1:2379 \
  --advertise-client-urls http://10.0.1.13:2379 \
  --initial-cluster infra0=http://10.0.1.10:2380,infra1=http://10.0.1.11:2380,infra3=http://10.0.1.13:2380 \
  --initial-cluster-state=new
etcd: conflicting cluster ID to the target cluster (c6ab534d07e8fcc4 != bc25ea2a74fb18b0). Exiting.
exit 1
```

## Discovery 发现

In a number of cases, the IPs of the cluster peers may not be known ahead  of time. This is common when utilizing cloud providers or when the  network uses DHCP. In these cases, rather than specifying a static  configuration, use an existing etcd cluster to bootstrap a new one. This process is called “discovery”.
在许多情况下，群集对等体的 IP 可能事先不知道。这在使用云提供商或网络使用 DHCP 时很常见。在这些情况下，与其指定静态配置，不如使用现有的 etcd 集群来引导新的集群。此过程称为“发现”。

There two methods that can be used for discovery:
有两种方法可用于发现：

- etcd discovery service etcd 发现服务
- DNS SRV records DNS SRV 记录

### etcd discovery etcd 发现

To better understand the design of the discovery service protocol, we suggest reading the discovery service protocol [documentation](https://etcd.io/docs/v3.5/dev-internal/discovery_protocol/).
为了更好地理解发现服务协议的设计，我们建议阅读发现服务协议文档。

#### Lifetime of a discovery URL 发现 URL 的生存期

A discovery URL identifies a unique etcd cluster. Instead of reusing an  existing discovery URL, each etcd instance shares a new discovery URL to bootstrap the new cluster.
发现 URL 标识唯一的 etcd 集群。每个 etcd 实例不会重用现有的发现 URL，而是共享一个新的发现 URL 来引导新集群。

Moreover, discovery URLs should ONLY be used for the initial bootstrapping of a  cluster. To change cluster membership after the cluster is already  running, see the [runtime reconfiguration](https://etcd.io/docs/v3.5/op-guide/runtime-configuration/) guide.
此外，发现 URL 应仅用于群集的初始引导。若要在群集已运行后更改群集成员身份，请参阅运行时重新配置指南。

#### Custom etcd discovery service 自定义 etcd 发现服务

Discovery uses an existing cluster to bootstrap itself. If using a private etcd cluster, create a URL like so:
Discovery 使用现有集群进行自身引导。如果使用私有 etcd 集群，请创建如下所示的 URL：

```
$ curl -X PUT https://myetcd.local/v2/keys/discovery/6c007a14875d53d9bf0ef5a6fc0257c817f0fb83/_config/size -d value=3
```

By setting the size key to the URL, a discovery URL is created with an expected cluster size of 3.
通过将 size 键设置为 URL，将创建一个预期群集大小为 3 的发现 URL。

The URL to use in this case will be `https://myetcd.local/v2/keys/discovery/6c007a14875d53d9bf0ef5a6fc0257c817f0fb83` and the etcd members will use the `https://myetcd.local/v2/keys/discovery/6c007a14875d53d9bf0ef5a6fc0257c817f0fb83` directory for registration as they start.
在这种情况下使用的 URL 将是 `https://myetcd.local/v2/keys/discovery/6c007a14875d53d9bf0ef5a6fc0257c817f0fb83` etcd 成员在开始时使用该 `https://myetcd.local/v2/keys/discovery/6c007a14875d53d9bf0ef5a6fc0257c817f0fb83` 目录进行注册。

**Each member must have a different name flag specified. `Hostname` or `machine-id` can be a good choice. Or discovery will fail due to duplicated name.
每个成员必须指定不同的名称标志。 `Hostname` 或者 `machine-id` 可能是一个不错的选择。否则，由于名称重复，发现将失败。**

Now we start etcd with those relevant flags for each member:
现在我们从每个成员的相关标志开始 etcd：

```
$ etcd --name infra0 --initial-advertise-peer-urls http://10.0.1.10:2380 \
  --listen-peer-urls http://10.0.1.10:2380 \
  --listen-client-urls http://10.0.1.10:2379,http://127.0.0.1:2379 \
  --advertise-client-urls http://10.0.1.10:2379 \
  --discovery https://myetcd.local/v2/keys/discovery/6c007a14875d53d9bf0ef5a6fc0257c817f0fb83
$ etcd --name infra1 --initial-advertise-peer-urls http://10.0.1.11:2380 \
  --listen-peer-urls http://10.0.1.11:2380 \
  --listen-client-urls http://10.0.1.11:2379,http://127.0.0.1:2379 \
  --advertise-client-urls http://10.0.1.11:2379 \
  --discovery https://myetcd.local/v2/keys/discovery/6c007a14875d53d9bf0ef5a6fc0257c817f0fb83
$ etcd --name infra2 --initial-advertise-peer-urls http://10.0.1.12:2380 \
  --listen-peer-urls http://10.0.1.12:2380 \
  --listen-client-urls http://10.0.1.12:2379,http://127.0.0.1:2379 \
  --advertise-client-urls http://10.0.1.12:2379 \
  --discovery https://myetcd.local/v2/keys/discovery/6c007a14875d53d9bf0ef5a6fc0257c817f0fb83
```

This will cause each member to register itself with the custom etcd  discovery service and begin the cluster once all machines have been  registered.
这将导致每个成员向自定义 etcd 发现服务注册自己，并在注册完所有机器后开始集群。

#### Public etcd discovery service 公共 etcd 发现服务

If no exiting cluster is available, use the public discovery service hosted at `discovery.etcd.io`. To create a private discovery URL using the “new” endpoint, use the command:
如果没有可用的现有集群，请使用托管在 `discovery.etcd.io` 中的公共发现服务。若要使用“新”终结点创建专用发现 URL，请使用以下命令：

```
$ curl https://discovery.etcd.io/new?size=3
https://discovery.etcd.io/3e86b59982e49066c5d813af1c2e2579cbf573de
```

This will create the cluster with an initial size of 3 members. If no size is specified, a default of 3 is used.
这将创建初始大小为 3 个成员的集群。如果未指定大小，则使用默认值 3。

```
ETCD_DISCOVERY=https://discovery.etcd.io/3e86b59982e49066c5d813af1c2e2579cbf573de
--discovery https://discovery.etcd.io/3e86b59982e49066c5d813af1c2e2579cbf573de
```

**Each member must have a different name flag specified or else discovery will fail due to duplicated names. `Hostname` or `machine-id` can be a good choice.
每个成员必须指定不同的名称标志，否则发现将因名称重复而失败。 `Hostname` 或者 `machine-id` 可能是一个不错的选择。**

Now we start etcd with those relevant flags for each member:
现在我们从每个成员的相关标志开始 etcd：

```
$ etcd --name infra0 --initial-advertise-peer-urls http://10.0.1.10:2380 \
  --listen-peer-urls http://10.0.1.10:2380 \
  --listen-client-urls http://10.0.1.10:2379,http://127.0.0.1:2379 \
  --advertise-client-urls http://10.0.1.10:2379 \
  --discovery https://discovery.etcd.io/3e86b59982e49066c5d813af1c2e2579cbf573de
$ etcd --name infra1 --initial-advertise-peer-urls http://10.0.1.11:2380 \
  --listen-peer-urls http://10.0.1.11:2380 \
  --listen-client-urls http://10.0.1.11:2379,http://127.0.0.1:2379 \
  --advertise-client-urls http://10.0.1.11:2379 \
  --discovery https://discovery.etcd.io/3e86b59982e49066c5d813af1c2e2579cbf573de
$ etcd --name infra2 --initial-advertise-peer-urls http://10.0.1.12:2380 \
  --listen-peer-urls http://10.0.1.12:2380 \
  --listen-client-urls http://10.0.1.12:2379,http://127.0.0.1:2379 \
  --advertise-client-urls http://10.0.1.12:2379 \
  --discovery https://discovery.etcd.io/3e86b59982e49066c5d813af1c2e2579cbf573de
```

This will cause each member to register itself with the discovery service  and begin the cluster once all members have been registered.
这将导致每个成员向发现服务注册自身，并在注册所有成员后启动集群。

Use the environment variable `ETCD_DISCOVERY_PROXY` to cause etcd to use an HTTP proxy to connect to the discovery service.
使用环境变量 `ETCD_DISCOVERY_PROXY` 使 etcd 使用 HTTP 代理连接到发现服务。

#### Error and warning cases 错误和警告案例

##### Discovery server errors 发现服务器错误

```
$ etcd --name infra0 --initial-advertise-peer-urls http://10.0.1.10:2380 \
  --listen-peer-urls http://10.0.1.10:2380 \
  --listen-client-urls http://10.0.1.10:2379,http://127.0.0.1:2379 \
  --advertise-client-urls http://10.0.1.10:2379 \
  --discovery https://discovery.etcd.io/3e86b59982e49066c5d813af1c2e2579cbf573de
etcd: error: the cluster doesn’t have a size configuration value in https://discovery.etcd.io/3e86b59982e49066c5d813af1c2e2579cbf573de/_config
exit 1
```

##### Warnings 警告

This is a harmless warning indicating the discovery URL will be ignored on this machine.
这是一个无害的警告，指示此计算机上将忽略发现 URL。

```
$ etcd --name infra0 --initial-advertise-peer-urls http://10.0.1.10:2380 \
  --listen-peer-urls http://10.0.1.10:2380 \
  --listen-client-urls http://10.0.1.10:2379,http://127.0.0.1:2379 \
  --advertise-client-urls http://10.0.1.10:2379 \
  --discovery https://discovery.etcd.io/3e86b59982e49066c5d813af1c2e2579cbf573de
etcdserver: discovery token ignored since a cluster has already been initialized. Valid log found at /var/lib/etcd
```

### DNS discovery DNS 发现

DNS [SRV records](http://www.ietf.org/rfc/rfc2052.txt) can be used as a discovery mechanism. The `--discovery-srv` flag can be used to set the DNS domain name where the discovery SRV records can be found. Setting `--discovery-srv example.com` causes DNS SRV records to be looked up in the listed order:
DNS SRV 记录可用作发现机制。该 `--discovery-srv` 标志可用于设置可在其中找到发现 SRV 记录的 DNS 域名。设置 `--discovery-srv example.com` 会导致按列出的顺序查找 DNS SRV 记录：

- _etcd-server-ssl._tcp.example.com
- _etcd-server._tcp.example.com

If `_etcd-server-ssl._tcp.example.com` is found then etcd will attempt the bootstrapping process over TLS.
如果 `_etcd-server-ssl._tcp.example.com` 找到，则 etcd 将尝试通过 TLS 进行引导过程。

To help clients discover the etcd cluster, the following DNS SRV records are looked up in the listed order:
为了帮助客户端发现 etcd 集群，将按列出的顺序查找以下 DNS SRV 记录：

- _etcd-client._tcp.example.com
- _etcd-client-ssl._tcp.example.com

If `_etcd-client-ssl._tcp.example.com` is found, clients will attempt to communicate with the etcd cluster over SSL/TLS.
如果 `_etcd-client-ssl._tcp.example.com` 找到，客户端将尝试通过 SSL/TLS 与 etcd 集群通信。

If etcd is using TLS, the discovery SRV record (e.g. `example.com`) must be included in the SSL certificate DNS SAN along with the  hostname, or clustering will fail with log messages like the following:
如果 etcd 使用 TLS，则发现 SRV 记录（例如 `example.com` ）必须与主机名一起包含在 SSL 证书 DNS SAN 中，否则群集将失败，并显示如下日志消息：

```
[...] rejected connection from "10.0.1.11:53162" (error "remote error: tls: bad certificate", ServerName "example.com")
```

If etcd is using TLS without a custom certificate authority, the discovery domain (e.g., example.com) must match the SRV record domain (e.g.,  infra1.example.com). This is to mitigate attacks that forge SRV records  to point to a different domain; the domain would have a valid  certificate under PKI but be controlled by an unknown third party.
如果 etcd 在没有自定义证书颁发机构的情况下使用 TLS，则发现域（例如 example.com）必须与 SRV 记录域（例如  infra1.example.com）匹配。这是为了缓解伪造 SRV 记录以指向不同域的攻击;该域在 PKI  下将具有有效的证书，但由未知的第三方控制。

The `-discovery-srv-name` flag additionally configures a suffix to the SRV name that is queried during discovery. Use this flag to differentiate between multiple etcd clusters under the same domain. For example, if `discovery-srv=example.com` and `-discovery-srv-name=foo` are set, the following DNS SRV queries are made:
该 `-discovery-srv-name` 标志还配置了在发现期间查询的 SRV 名称的后缀。使用此标志可以区分同一域下的多个 etcd 集群。例如，如果 `discovery-srv=example.com` 设置了 和 `-discovery-srv-name=foo` ，则进行以下 DNS SRV 查询：

- _etcd-server-ssl-foo._tcp.example.com
- _etcd-server-foo._tcp.example.com

#### Create DNS SRV records 创建 DNS SRV 记录

```
$ dig +noall +answer SRV _etcd-server._tcp.example.com
_etcd-server._tcp.example.com. 300 IN  SRV  0 0 2380 infra0.example.com.
_etcd-server._tcp.example.com. 300 IN  SRV  0 0 2380 infra1.example.com.
_etcd-server._tcp.example.com. 300 IN  SRV  0 0 2380 infra2.example.com.
$ dig +noall +answer SRV _etcd-client._tcp.example.com
_etcd-client._tcp.example.com. 300 IN SRV 0 0 2379 infra0.example.com.
_etcd-client._tcp.example.com. 300 IN SRV 0 0 2379 infra1.example.com.
_etcd-client._tcp.example.com. 300 IN SRV 0 0 2379 infra2.example.com.
$ dig +noall +answer infra0.example.com infra1.example.com infra2.example.com
infra0.example.com.  300  IN  A  10.0.1.10
infra1.example.com.  300  IN  A  10.0.1.11
infra2.example.com.  300  IN  A  10.0.1.12
```

#### Bootstrap the etcd cluster using DNS 使用 DNS 引导 etcd 集群

etcd cluster members can advertise domain names or IP address, the bootstrap process will resolve DNS A records. Since 3.2 (3.1 prints warnings) `--listen-peer-urls` and `--listen-client-urls` will reject domain name for the network interface binding.
etcd 集群成员可以通告域名或 IP 地址，引导过程将解析 DNS A 记录。从 3.2 开始（3.1 打印警告） `--listen-peer-urls` 并将 `--listen-client-urls` 拒绝域名的网络接口绑定。

The resolved address in `--initial-advertise-peer-urls` *must match* one of the resolved addresses in the SRV targets. The etcd member reads the resolved address to find out if it belongs to the cluster defined  in the SRV records.
中的解析地址 `--initial-advertise-peer-urls` 必须与 SRV 目标中的一个解析地址匹配。etcd 成员读取解析的地址，以确定它是否属于 SRV 记录中定义的集群。

```
$ etcd --name infra0 \
--discovery-srv example.com \
--initial-advertise-peer-urls http://infra0.example.com:2380 \
--initial-cluster-token etcd-cluster-1 \
--initial-cluster-state new \
--advertise-client-urls http://infra0.example.com:2379 \
--listen-client-urls http://0.0.0.0:2379 \
--listen-peer-urls http://0.0.0.0:2380
$ etcd --name infra1 \
--discovery-srv example.com \
--initial-advertise-peer-urls http://infra1.example.com:2380 \
--initial-cluster-token etcd-cluster-1 \
--initial-cluster-state new \
--advertise-client-urls http://infra1.example.com:2379 \
--listen-client-urls http://0.0.0.0:2379 \
--listen-peer-urls http://0.0.0.0:2380
$ etcd --name infra2 \
--discovery-srv example.com \
--initial-advertise-peer-urls http://infra2.example.com:2380 \
--initial-cluster-token etcd-cluster-1 \
--initial-cluster-state new \
--advertise-client-urls http://infra2.example.com:2379 \
--listen-client-urls http://0.0.0.0:2379 \
--listen-peer-urls http://0.0.0.0:2380
```

The cluster can also bootstrap using IP addresses instead of domain names:
集群还可以使用 IP 地址而不是域名进行引导：

```
$ etcd --name infra0 \
--discovery-srv example.com \
--initial-advertise-peer-urls http://10.0.1.10:2380 \
--initial-cluster-token etcd-cluster-1 \
--initial-cluster-state new \
--advertise-client-urls http://10.0.1.10:2379 \
--listen-client-urls http://10.0.1.10:2379 \
--listen-peer-urls http://10.0.1.10:2380
$ etcd --name infra1 \
--discovery-srv example.com \
--initial-advertise-peer-urls http://10.0.1.11:2380 \
--initial-cluster-token etcd-cluster-1 \
--initial-cluster-state new \
--advertise-client-urls http://10.0.1.11:2379 \
--listen-client-urls http://10.0.1.11:2379 \
--listen-peer-urls http://10.0.1.11:2380
$ etcd --name infra2 \
--discovery-srv example.com \
--initial-advertise-peer-urls http://10.0.1.12:2380 \
--initial-cluster-token etcd-cluster-1 \
--initial-cluster-state new \
--advertise-client-urls http://10.0.1.12:2379 \
--listen-client-urls http://10.0.1.12:2379 \
--listen-peer-urls http://10.0.1.12:2380
```

Since v3.1.0 (except v3.2.9), when `etcd --discovery-srv=example.com` is configured with TLS, server will only authenticate peers/clients when the provided certs have root domain `example.com` as an entry in Subject Alternative Name (SAN) field. See [Notes for DNS SRV](https://etcd.io/docs/v3.5/op-guide/security/#notes-for-dns-srv).
从 v3.1.0（v3.2.9 除外）开始，当配置了 TLS 时 `etcd --discovery-srv=example.com` ，服务器将仅在提供的证书将根域 `example.com` 作为使用者备用名称 （SAN） 字段中的条目时才对对等方/客户端进行身份验证。请参阅 DNS SRV 注意事项。

### Gateway 网关

etcd gateway is a simple TCP proxy that forwards network data to the etcd cluster. Please read [gateway guide](https://etcd.io/docs/v3.5/op-guide/gateway/) for more information.
etcd 网关是一个简单的 TCP 代理，用于将网络数据转发到 etcd 集群。有关详细信息，请阅读网关指南。

### Proxy 代理

When the `--proxy` flag is set, etcd runs in [proxy mode](https://github.com/etcd-io/etcd/blob/release-2.3/Documentation/proxy.md). This proxy mode only supports the etcd v2 API; there are no plans to  support the v3 API. Instead, for v3 API support, there will be a new  proxy with enhanced features following the etcd 3.0 release.
设置标志 `--proxy` 后，etcd 以代理模式运行。此代理模式仅支持 etcd v2 API;没有计划支持 v3 API。相反，对于 v3 API 支持，在 etcd 3.0 版本之后将有一个新的具有增强功能的代理。

To setup an etcd cluster with proxies of v2 API, please read the the [clustering doc in etcd 2.3 release](https://github.com/etcd-io/etcd/blob/release-2.3/Documentation/clustering.md).
要使用 v2 API 的代理设置 etcd 集群，请阅读 etcd 2.3 版本中的集群文档。