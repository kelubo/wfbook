# etcd gateway etcd 网关

etcd gateway, when to use it, and how to set it up
etcd 网关，何时使用以及如何设置



## What is etcd gateway 什么是etcd网关

etcd gateway is a simple TCP proxy that forwards network data to the etcd  cluster. The gateway is stateless and transparent; it neither inspects  client requests nor interferes with cluster responses. It does not  terminate TLS connections, do TLS handshakes on behalf of its clients,  or verify if the connection is secured.
etcd 网关是一个简单的 TCP 代理，用于将网络数据转发到 etcd 集群。网关是无状态且透明的;它既不检查客户端请求，也不干扰群集响应。它不会终止 TLS 连接，不会代表其客户端执行 TLS 握手，也不会验证连接是否安全。

The gateway supports multiple etcd server endpoints and works on a simple  round-robin policy. It only routes to available endpoints and hides  failures from its clients. Other retry policies, such as weighted  round-robin, may be supported in the future.
网关支持多个 etcd 服务器端点，并采用简单的循环策略。它仅路由到可用的终结点，并对其客户端隐藏故障。将来可能会支持其他重试策略，例如加权轮询。

## When to use etcd gateway 何时使用 etcd 网关

Every application that accesses etcd must first have the address of an etcd  cluster client endpoint. If multiple applications on the same server  access the same etcd cluster, every application still needs to know the  advertised client endpoints of the etcd cluster. If the etcd cluster is  reconfigured to have different endpoints, every application may also  need to update its endpoint list. This wide-scale reconfiguration is  both tedious and error prone.
每个访问 etcd 的应用程序都必须首先具有 etcd 集群客户端端点的地址。如果同一服务器上的多个应用程序访问同一个 etcd  集群，则每个应用程序仍然需要知道 etcd 集群的通告客户端端点。如果 etcd  集群被重新配置为具有不同的端点，则每个应用程序可能还需要更新其端点列表。这种大规模的重新配置既繁琐又容易出错。

etcd gateway solves this problem by serving as a stable local endpoint. A  typical etcd gateway configuration has each machine running a gateway  listening on a local address and every etcd application connecting to  its local gateway. The upshot is only the gateway needs to update its  endpoints instead of updating each and every application.
etcd 网关通过充当稳定的本地端点来解决这个问题。典型的 etcd 网关配置是每台运行网关的机器都侦听本地地址，并且每个 etcd 应用程序都连接到其本地网关。结果是网关只需要更新其端点，而不是更新每个应用程序。

In summary, to automatically propagate cluster endpoint changes, the etcd  gateway runs on every machine serving multiple applications accessing  the same etcd cluster.
总之，为了自动传播集群端点更改，etcd 网关在为访问同一 etcd 集群的多个应用程序提供服务的每台机器上运行。

## When not to use etcd gateway 何时不使用 etcd 网关

- Improving performance 提高性能

The gateway is not designed for improving etcd cluster performance. It does not provide caching, watch coalescing or batching. The etcd team is  developing a caching proxy designed for improving cluster scalability.
该网关不是为提高 etcd 集群性能而设计的。它不提供缓存、监视合并或批处理。etcd 团队正在开发一个缓存代理，旨在提高集群的可扩展性。

- Running on a cluster management system
  在集群管理系统上运行

Advanced cluster management systems like Kubernetes natively support service  discovery. Applications can access an etcd cluster with a DNS name or a  virtual IP address managed by the system. For example, kube-proxy is  equivalent to etcd gateway.
Kubernetes 等高级集群管理系统原生支持服务发现。应用程序可以使用系统管理的 DNS 名称或虚拟 IP 地址访问 etcd 集群。例如，kube-proxy 等同于 etcd 网关。

## Start etcd gateway 启动 etcd 网关

Consider an etcd cluster with the following static endpoints:
考虑一个具有以下静态端点的 etcd 集群：

| Name 名字        | Address 地址 | Hostname 主机名    | Port 港口 |
| ---------------- | ------------ | ------------------ | --------- |
| infra0 基础设施0 | 10.0.1.10    | infra0.example.com | 2379      |
| infra1 基础设施1 | 10.0.1.11    | infra1.example.com | 2379      |
| infra2 基础设施2 | 10.0.1.12    | infra2.example.com | 2379      |

Start the etcd gateway to use these static endpoints with the command:
通过以下命令启动 etcd 网关以使用这些静态端点：

```bash
$ etcd gateway start --endpoints=infra0.example.com:2379,infra1.example.com:2379,infra2.example.com:2379
2016-08-16 11:21:18.867350 I | tcpproxy: ready to proxy client requests to [...]
```

Alternatively, if using DNS for service discovery, consider the DNS SRV entries:
或者，如果使用 DNS 进行服务发现，请考虑 DNS SRV 条目：

```bash
$ dig +noall +answer SRV _etcd-client._tcp.example.com
_etcd-client._tcp.example.com. 300 IN SRV 0 0 2379 infra0.example.com.
_etcd-client._tcp.example.com. 300 IN SRV 0 0 2379 infra1.example.com.
_etcd-client._tcp.example.com. 300 IN SRV 0 0 2379 infra2.example.com.
$ dig +noall +answer infra0.example.com infra1.example.com infra2.example.com
infra0.example.com.  300  IN  A  10.0.1.10
infra1.example.com.  300  IN  A  10.0.1.11
infra2.example.com.  300  IN  A  10.0.1.12
```

Start the etcd gateway to fetch the endpoints from the DNS SRV entries with the command:
启动 etcd 网关，使用以下命令从 DNS SRV 条目中获取端点：

```bash
$ etcd gateway start --discovery-srv=example.com
2016-08-16 11:21:18.867350 I | tcpproxy: ready to proxy client requests to [...]
```

## Configuration flags 配置标志

### etcd cluster etcd 集群

#### –endpoints –端点

- Comma-separated list of etcd server targets for forwarding client connections.
  以逗号分隔的 etcd 服务器目标列表，用于转发客户端连接。
- Default: `127.0.0.1:2379` 违约： `127.0.0.1:2379` 
- Port must be included. 必须包括端口。
- Invalid example: `https://127.0.0.1:2379` (gateway does not terminate TLS). Note that the gateway does not verify the HTTP schema or inspect the requests, it only forwards requests to  the given endpoints.
  无效示例： `https://127.0.0.1:2379` （网关不终止 TLS）。请注意，网关不会验证 HTTP 架构或检查请求，它只会将请求转发到给定的端点。

#### –discovery-srv –发现-srv

- DNS domain used to bootstrap cluster endpoints through SRV records.
  用于通过 SRV 记录引导群集终结点的 DNS 域。
- Default: (not set) 默认值：（未设置）

### Network 网络

#### –listen-addr –听地址

- Interface and port to bind for accepting client requests.
  用于接受客户端请求的绑定接口和端口。
- Default: `127.0.0.1:23790` 违约： `127.0.0.1:23790` 

#### –retry-delay –重试延迟

- Duration of delay before retrying to connect to failed endpoints.
  重试连接到失败终结点之前的延迟持续时间。
- Default: 1m0s 默认值：1m0s
- Invalid example: “123” (expects time unit in format)
  无效示例：“123”（格式中需要时间单位）

### Security 安全

#### –insecure-discovery –不安全发现

- Accept SRV records that are insecure or susceptible to man-in-the-middle attacks.
  接受不安全或容易受到中间人攻击的 SRV 记录。
- Default: `false` 违约： `false` 

#### –trusted-ca-file –trusted-ca-文件

- Path to the client TLS CA file for the etcd cluster to verify the endpoints  returned from SRV discovery. Note that it is ONLY used for  authenticating the discovered endpoints rather than creating connections for data transferring. The gateway never terminates TLS connections or  create TLS connections on behalf of its clients.
  etcd 集群的客户端 TLS CA 文件的路径，用于验证从 SRV 发现返回的端点。请注意，它仅用于对发现的端点进行身份验证，而不是创建用于数据传输的连接。网关从不终止 TLS 连接或代表其客户端创建 TLS 连接。
- Default: (not set) 默认值：（未设置）