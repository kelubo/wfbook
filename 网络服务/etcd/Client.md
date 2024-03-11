# 客户端设计

Client architectural decisions & their implementation details
客户端架构决策及其实施细节



# etcd Client Design etcd 客户端设计

*Gyuho Lee (github.com/gyuho, Amazon Web Services, Inc.), Joe Betz (github.com/jpbetz, Google Inc.)
Gyuho Lee（github.com/gyuho，Amazon Web Services， Inc.），Joe Betz（github.com/jpbetz，Google Inc.）*

# Introduction 介绍

etcd server has proven its robustness with years of failure injection  testing. Most complex application logic is already handled by etcd  server and its data stores (e.g. cluster membership is transparent to  clients, with Raft-layer forwarding proposals to leader). Although  server components are correct, its composition with client requires a  different set of intricate protocols to guarantee its correctness and  high availability under faulty conditions. Ideally, etcd server provides one logical cluster view of many physical machines, and client  implements automatic failover between replicas. This documents client  architectural decisions and its implementation details.
etcd 服务器已通过多年的故障注入测试证明了其稳健性。大多数复杂的应用程序逻辑已经由 etcd  服务器及其数据存储处理（例如，集群成员资格对客户端是透明的，Raft  层将建议转发给领导者）。尽管服务器组件是正确的，但它与客户端的组合需要一组不同的复杂协议来保证其正确性和在错误条件下的高可用性。理想情况下，etcd 服务器提供许多物理机器的逻辑集群视图，客户端实现副本之间的自动故障转移。这记录了客户端体系结构决策及其实现详细信息。

# Glossary 词汇表

*clientv3*: etcd Official Go client for etcd v3 API.
clientv3： etcd v3 API 的官方 Go 客户端。

*clientv3-grpc1.0*: Official client implementation, with [`grpc-go v1.0.x`](https://github.com/grpc/grpc-go/releases/tag/v1.0.0), which is used in latest etcd v3.1.
clientv3-grpc1.0： 官方客户端实现，在 `grpc-go v1.0.x` 最新的 etcd v3.1 中使用。

*clientv3-grpc1.7*: Official client implementation, with [`grpc-go v1.7.x`](https://github.com/grpc/grpc-go/releases/tag/v1.7.0), which is used in latest etcd v3.2 and v3.3.
clientv3-grpc1.7：官方客户端实现，在 `grpc-go v1.7.x` 最新的 etcd v3.2 和 v3.3 中使用。

*clientv3-grpc1.23*: Official client implementation, with [`grpc-go v1.23.x`](https://github.com/grpc/grpc-go/releases/tag/v1.23.0), which is used in latest etcd v3.4.
clientv3-grpc1.23： 官方客户端实现，在 `grpc-go v1.23.x` 最新的 etcd v3.4 中使用。

*Balancer*: etcd client load balancer that implements retry and failover mechanism. etcd client should automatically balance loads between multiple  endpoints.
Balancer：etcd 客户端负载均衡器，实现重试和故障转移机制。etcd 客户端应该自动平衡多个端点之间的负载。

*Endpoints*: A list of etcd server endpoints that clients can connect to. Typically, 3 or 5 client URLs of an etcd cluster.
端点：客户端可以连接到的 etcd 服务器端点列表。通常，一个 etcd 集群的 3 或 5 个客户端 URL。

*Pinned endpoint*: When configured with multiple endpoints, <= v3.3 client balancer  chooses only one endpoint to establish a TCP connection, in order to  conserve total open connections to etcd cluster. In v3.4, balancer  round-robins pinned endpoints for every request, thus distributing loads more evenly.
固定端点：配置多个端点时，<= v3.3 客户端均衡器仅选择一个端点来建立 TCP 连接，以节省与 etcd 集群的开放连接总数。在 v3.4 中，平衡器轮询为每个请求固定端点，从而更均匀地分配负载。

*Client Connection*: TCP connection that has been established to an etcd server, via gRPC Dial.
客户端连接：已通过 gRPC 拨号与 etcd 服务器建立的 TCP 连接。

*Sub Connection*: gRPC SubConn interface. Each sub-connection contains a list of  addresses. Balancer creates a SubConn from a list of resolved addresses. gRPC ClientConn can map to multiple SubConn (e.g. example.com resolves  to `10.10.10.1` and `10.10.10.2` of two sub-connections). etcd v3.4 balancer employs internal resolver to establish one sub-connection for each endpoint.
子连接：gRPC SubConn接口。每个子连接都包含一个地址列表。Balancer 根据已解析的地址列表创建 SubConn。gRPC ClientConn 可以映射到多个 SubConn（例如，example.com 解析为 `10.10.10.1` 两个子连接的 和 `10.10.10.2` ）。etcd v3.4 balancer 使用内部解析器为每个端点建立一个子连接。

*Transient disconnect*: When gRPC server returns a status error of [`code Unavailable`](https://godoc.org/google.golang.org/grpc/codes#Code).
暂时性断开连接：当 gRPC 服务器返回状态错误时 `code Unavailable` 。

# Client Requirements 客户要求

*Correctness*. Requests may fail in the presence of server faults. However, it never  violates consistency guarantees: global ordering properties, never write corrupted data, at-most once semantics for mutable operations, watch  never observes partial events, and so on.
正确性。如果存在服务器故障，请求可能会失败。但是，它从不违反一致性保证：全局排序属性、从不写入损坏的数据、可变操作的最多一次语义、监视从不观察部分事件等。

*Liveness*. Servers may fail or disconnect briefly. Clients should make progress in either way. Clients should [never deadlock](https://github.com/etcd-io/etcd/issues/8980) waiting for a server to come back from offline, unless configured to do so. Ideally, clients detect unavailable servers with HTTP/2 ping and  failover to other nodes with clear error messages.
活性。服务器可能会出现故障或短暂断开连接。无论哪种方式，客户都应该取得进展。客户端不应在等待服务器从脱机状态返回时发生死锁，除非配置为这样做。理想情况下，客户端会检测到具有 HTTP/2 ping 的不可用服务器，并故障转移到其他节点，并显示明显的错误消息。

*Effectiveness*. Clients should operate effectively with minimum resources: previous TCP connections should be [gracefully closed](https://github.com/etcd-io/etcd/issues/9212) after endpoint switch. Failover mechanism should effectively predict  the next replica to connect, without wastefully retrying on failed  nodes.
有效性。客户端应以最少的资源有效运行：在端点切换后，应正常关闭以前的 TCP 连接。故障转移机制应有效地预测要连接的下一个副本，而不会浪费地在故障节点上重试。

*Portability*. Official client should be clearly documented and its implementation be  applicable to other language bindings. Error handling between different  language bindings should be consistent. Since etcd is fully committed to gRPC, implementation should be closely aligned with gRPC long-term  design goals (e.g. pluggable retry policy should be compatible with [gRPC retry](https://github.com/grpc/proposal/blob/master/A6-client-retries.md)). Upgrades between two client versions should be non-disruptive.
可移植性。官方客户端应有明确记录，其实现应适用于其他语言绑定。不同语言绑定之间的错误处理应保持一致。由于 etcd 完全致力于 gRPC，因此实现应与 gRPC 长期设计目标密切相关（例如，可插入重试策略应与 gRPC  重试兼容）。两个客户端版本之间的升级应该是无中断的。

# Client Overview 客户概览

etcd client implements the following components:
etcd 客户端实现了以下组件：

- balancer that establishes gRPC connections to an etcd cluster,
  与 etcd 集群建立 gRPC 连接的平衡器，
- API client that sends RPCs to an etcd server, and
  将 RPC 发送到 etcd 服务器的 API 客户端，以及
- error handler that decides whether to retry a failed request or switch endpoints.
  错误处理程序，用于决定是重试失败的请求还是切换终结点。

Languages may differ in how to establish an initial connection (e.g. configure  TLS), how to encode and send Protocol Buffer messages to server, how to  handle stream RPCs, and so on. However, errors returned from etcd server will be the same. So should be error handling and retry policy.
语言可能在如何建立初始连接（例如配置 TLS）、如何编码和将协议缓冲区消息发送到服务器、如何处理流 RPC 等方面有所不同。但是，从 etcd 服务器返回的错误将是相同的。错误处理和重试策略也应该如此。

For example, etcd server may return `"rpc error: code = Unavailable desc = etcdserver: request timed out"`, which is transient error that expects retries. Or return `rpc error: code = InvalidArgument desc = etcdserver: key is not provided`, which means request was invalid and should not be retried. Go client can parse errors with `google.golang.org/grpc/status.FromError`, and Java client with `io.grpc.Status.fromThrowable`.
例如，etcd server 可能会返回 `"rpc error: code = Unavailable desc = etcdserver: request timed out"` ，这是需要重试的暂时性错误。或 return `rpc error: code = InvalidArgument desc = etcdserver: key is not provided` ，这意味着请求无效，不应重试。Go 客户端可以用 来解析错误，Java 客户端可以 `io.grpc.Status.fromThrowable` 用 `google.golang.org/grpc/status.FromError` 来解析错误。

## clientv3-grpc1.0: Balancer Overview clientv3-grpc1.0：均衡器概述

`clientv3-grpc1.0` maintains multiple TCP connections when configured with multiple etcd  endpoints. Then pick one address and use it to send all client requests. The pinned address is maintained until the client object is closed (see *Figure 1*). When the client receives an error, it randomly picks another and retries.
 `clientv3-grpc1.0` 配置多个 etcd 端点时维护多个 TCP 连接。然后选择一个地址并使用它来发送所有客户端请求。固定地址将一直保留到客户端对象关闭为止（参见图 1）。当客户端收到错误时，它会随机选择另一个错误并重试。

![client-balancer-figure-01.png](https://etcd.io/docs/v3.5/learning/img/client-balancer-figure-01.png)

## clientv3-grpc1.0: Balancer Limitation clientv3-grpc1.0：均衡器限制

`clientv3-grpc1.0` opening multiple TCP connections may provide faster balancer failover  but requires more resources. The balancer does not understand node’s  health status or cluster membership. So, it is possible that balancer  gets stuck with one failed or partitioned node.
 `clientv3-grpc1.0` 打开多个 TCP 连接可能会提供更快的平衡器故障转移，但需要更多资源。均衡器不了解节点的运行状况或集群成员身份。因此，平衡器可能会卡在一个故障或分区节点上。

## clientv3-grpc1.7: Balancer Overview clientv3-grpc1.7：均衡器概述

`clientv3-grpc1.7` maintains only one TCP connection to a chosen etcd server. When given  multiple cluster endpoints, a client first tries to connect to them all. As soon as one connection is up, balancer pins the address, closing  others (see *Figure 2*). The pinned address is to be maintained until the client object is  closed. An error, from server or client network fault, is sent to client error handler (see *Figure 3*).
 `clientv3-grpc1.7` 仅维护与所选 etcd 服务器的一个 TCP  连接。当给定多个集群终端节点时，客户端首先尝试连接到所有终端节点。一旦一个连接启动，平衡器就会固定地址，关闭其他地址（参见图  2）。固定地址将一直保留，直到关闭客户端对象。来自服务器或客户端网络故障的错误将发送到客户端错误处理程序（参见图 3）。

![client-balancer-figure-02.png](https://etcd.io/docs/v3.5/learning/img/client-balancer-figure-02.png)

![client-balancer-figure-03.png](https://etcd.io/docs/v3.5/learning/img/client-balancer-figure-03.png)

The client error handler takes an error from gRPC server, and decides  whether to retry on the same endpoint, or to switch to other addresses,  based on the error code and message (see *Figure 4* and *Figure 5*).
客户端错误处理程序从 gRPC 服务器获取错误，并根据错误代码和消息决定是在同一终结点上重试，还是切换到其他地址（请参阅图 4 和图 5）。

![client-balancer-figure-04.png](https://etcd.io/docs/v3.5/learning/img/client-balancer-figure-04.png)

![client-balancer-figure-05.png](https://etcd.io/docs/v3.5/learning/img/client-balancer-figure-05.png)

Stream RPCs, such as Watch and KeepAlive, are often requested with no  timeouts. Instead, client can send periodic HTTP/2 pings to check the  status of a pinned endpoint; if the server does not respond to the ping, balancer switches to other endpoints (see *Figure 6*).
流 RPC（如 Watch 和 KeepAlive）通常不会超时。相反，客户端可以定期发送 HTTP/2 ping 来检查固定终结点的状态;如果服务器不响应 ping，则 balancer 将切换到其他端点（参见图 6）。

![client-balancer-figure-06.png](https://etcd.io/docs/v3.5/learning/img/client-balancer-figure-06.png)

## clientv3-grpc1.7: Balancer Limitation clientv3-grpc1.7：均衡器限制

`clientv3-grpc1.7` balancer sends HTTP/2 keepalives to detect disconnects from streaming  requests. It is a simple gRPC server ping mechanism and does not reason  about cluster membership, thus unable to detect network partitions.  Since partitioned gRPC server can still respond to client pings,  balancer may get stuck with a partitioned node. Ideally, keepalive ping  detects partition and triggers endpoint switch, before request time-out  (see [etcd#8673](https://github.com/etcd-io/etcd/issues/8673) and *Figure 7*).
 `clientv3-grpc1.7` balancer 发送 HTTP/2 keepalive 以检测与流请求的断开连接。它是一种简单的 gRPC 服务器 ping  机制，不考虑群集成员身份，因此无法检测网络分区。由于分区的 gRPC 服务器仍可响应客户端  ping，因此均衡器可能会卡在分区节点上。理想情况下，keepalive ping 会在请求超时之前检测分区并触发端点切换（参见  etcd#8673 和图 7）。

![client-balancer-figure-07.png](https://etcd.io/docs/v3.5/learning/img/client-balancer-figure-07.png)

`clientv3-grpc1.7` balancer maintains a list of unhealthy endpoints. Disconnected  addresses are added to “unhealthy” list, and considered unavailable  until after wait duration, which is hard coded as dial timeout with  default value 5-second. Balancer can have false positives on which  endpoints are unhealthy. For instance, endpoint A may come back right  after being blacklisted, but still unusable for next 5 seconds (see *Figure 8*).
 `clientv3-grpc1.7` Balancer  维护不正常的终结点列表。断开连接的地址将添加到“不正常”列表中，并在等待持续时间过后被视为不可用，这被硬编码为拨号超时，默认值为 5  秒。平衡器可能存在终结点运行状况不佳的误报。例如，端点 A 可能在被列入黑名单后立即返回，但在接下来的 5 秒内仍然无法使用（参见图 8）。

`clientv3-grpc1.0` suffered the same problems above.
 `clientv3-grpc1.0` 遭受了上述相同的问题。

![client-balancer-figure-08.png](https://etcd.io/docs/v3.5/learning/img/client-balancer-figure-08.png)

Upstream gRPC Go had already migrated to new balancer interface. For example, `clientv3-grpc1.7` underlying balancer implementation uses new gRPC balancer and tries to  be consistent with old balancer behaviors. While its compatibility has  been maintained reasonably well, etcd client still [suffered from subtle breaking changes](https://github.com/grpc/grpc-go/issues/1649). Furthermore, gRPC maintainer recommends to [not rely on the old balancer interface](https://github.com/grpc/grpc-go/issues/1942#issuecomment-375368665). In general, to get better support from upstream, it is best to be in  sync with latest gRPC releases. And new features, such as retry policy,  may not be backported to gRPC 1.7 branch. Thus, both etcd server and  client must migrate to latest gRPC versions.
上游 gRPC Go 已迁移到新的均衡器接口。例如， `clientv3-grpc1.7` 基础均衡器实现使用新的 gRPC 均衡器，并尝试与旧的均衡器行为保持一致。虽然它的兼容性保持得相当好，但 etcd  客户端仍然遭受了微妙的中断性更改。此外，gRPC 维护者建议不要依赖旧的平衡器接口。通常，若要从上游获得更好的支持，最好与最新的 gRPC  版本同步。新功能（如重试策略）可能不会向后移植到 gRPC 1.7 分支。因此，etcd 服务器和客户端都必须迁移到最新的 gRPC 版本。

## clientv3-grpc1.23: Balancer Overview clientv3-grpc1.23：均衡器概述

`clientv3-grpc1.7` is so tightly coupled with old gRPC interface, that every single gRPC  dependency upgrade broke client behavior. Majority of development and  debugging efforts were devoted to fixing those client behavior changes.  As a result, its implementation has become overly complicated with bad  assumptions on server connectivities.
 `clientv3-grpc1.7` 与旧的 gRPC 接口紧密耦合，以至于每个 gRPC 依赖项升级都会破坏客户端行为。大多数开发和调试工作都用于修复这些客户端行为更改。因此，由于对服务器连接的错误假设，它的实现变得过于复杂。

The primary goal of `clientv3-grpc1.23` is to simplify balancer failover logic; rather than maintaining a list  of unhealthy endpoints, which may be stale, simply roundrobin to the  next endpoint whenever client gets disconnected from the current  endpoint. It does not assume endpoint status. Thus, no more complicated  status tracking is needed (see *Figure 8* and above). Upgrading to `clientv3-grpc1.23` should be no issue; all changes were internal while keeping all the backward compatibilities.
的主要目标是 `clientv3-grpc1.23` 简化平衡器故障转移逻辑;无需维护可能已过时的不正常终结点列表，只需在客户端与当前终结点断开连接时循环到下一个终结点即可。它不承担终结点状态。因此，不需要更复杂的状态跟踪（参见图 8 和上面）。升级到 `clientv3-grpc1.23` 应该没有问题;所有更改都是内部的，同时保持所有向后兼容性。

Internally, when given multiple endpoints, `clientv3-grpc1.23` creates multiple sub-connections (one sub-connection per each endpoint), while `clientv3-grpc1.7` creates only one connection to a pinned endpoint (see *Figure 9*). For instance, in 5-node cluster, `clientv3-grpc1.23` balancer would require 5 TCP connections, while `clientv3-grpc1.7` only requires one. By preserving the pool of TCP connections, `clientv3-grpc1.23` may consume more resources but provide more flexible load balancer with better failover performance. The default balancing policy is round  robin but can be easily extended to support other types of balancers  (e.g. power of two, pick leader, etc.). `clientv3-grpc1.23` uses gRPC resolver group and implements balancer picker policy, in  order to delegate complex balancing work to upstream gRPC. On the other  hand, `clientv3-grpc1.7` manually handles each gRPC connection and balancer failover, which complicates the implementation. `clientv3-grpc1.23` implements retry in the gRPC interceptor chain that automatically  handles gRPC internal errors and enables more advanced retry policies  like backoff, while `clientv3-grpc1.7` manually interprets gRPC errors for retries.
在内部，当给定多个端点时， `clientv3-grpc1.23` 会创建多个子连接（每个端点一个子连接），而 `clientv3-grpc1.7` 仅创建一个与固定端点的连接（参见图 9）。例如，在 5 节点集群中， `clientv3-grpc1.23` 平衡器需要 5 个 TCP 连接，而 `clientv3-grpc1.7` 只需要一个。通过保留 TCP 连接池，可能会消耗更多资源， `clientv3-grpc1.23` 但提供更灵活的负载均衡器，具有更好的故障转移性能。默认的平衡策略是循环的，但可以很容易地扩展以支持其他类型的平衡器（例如，2 的幂、选择引线等）。 `clientv3-grpc1.23` 使用 gRPC 解析器组并实现均衡器选取器策略，以便将复杂的均衡工作委托给上游 gRPC。另一方面， `clientv3-grpc1.7` 手动处理每个 gRPC 连接和均衡器故障转移，这会使实现复杂化。 `clientv3-grpc1.23` 在 gRPC 侦听器链中实现重试，该链会自动处理 gRPC 内部错误并启用更高级的重试策略（如回退），同时 `clientv3-grpc1.7` 手动解释重试的 gRPC 错误。

![client-balancer-figure-09.png](https://etcd.io/docs/v3.5/learning/img/client-balancer-figure-09.png)

## clientv3-grpc1.23: Balancer Limitation clientv3-grpc1.23：均衡器限制

Improvements can be made by caching the status of each endpoint. For instance,  balancer can ping each server in advance to maintain a list of healthy  candidates, and use this information when doing round-robin. Or when  disconnected, balancer can prioritize healthy endpoints. This may  complicate the balancer implementation, thus can be addressed in later  versions.
可以通过缓存每个终结点的状态进行改进。例如，平衡器可以提前ping每个服务器，以维护一个健康的候选列表，并在进行循环时使用此信息。或者，当断开连接时，平衡器可以优先考虑正常运行的端点。这可能会使平衡器实现复杂化，因此可以在以后的版本中解决。

Client-side keepalive ping still does not reason about network partitions.  Streaming request may get stuck with a partitioned node. Advanced health checking service need to be implemented to understand the cluster  membership (see [etcd#8673](https://github.com/etcd-io/etcd/issues/8673) for more detail).
客户端 keepalive ping 仍然不考虑网络分区。流式处理请求可能会卡在分区节点上。需要实现高级健康检查服务来了解集群成员身份（有关详细信息，请参阅 etcd#8673）。

![client-balancer-figure-07.png](https://etcd.io/docs/v3.5/learning/img/client-balancer-figure-07.png)

Currently, retry logic is handled manually as an interceptor. This may be simplified via [official gRPC retries](https://github.com/grpc/proposal/blob/master/A6-client-retries.md).
目前，重试逻辑作为侦听器手动处理。这可以通过官方 gRPC 重试来简化。