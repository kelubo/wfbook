# gRPC proxy gRPC 代理

A stateless etcd reverse proxy operating at the gRPC layer
在 gRPC 层运行的无状态 etcd 反向代理



The gRPC proxy is a stateless etcd reverse proxy operating at the gRPC  layer (L7). The proxy is designed to reduce the total processing load on the core etcd cluster. For horizontal scalability, it coalesces watch  and lease API requests. To protect the cluster against abusive clients,  it caches key range requests.
gRPC 代理是在 gRPC 层 （L7） 运行的无状态 etcd 反向代理。该代理旨在减少核心 etcd 集群上的总处理负载。为了实现水平可伸缩性，它合并了监视和租赁 API 请求。为了保护群集免受滥用客户端的攻击，它会缓存关键范围请求。

The gRPC proxy supports multiple etcd server endpoints. When the proxy  starts, it randomly picks one etcd server endpoint to use. This endpoint serves all requests until the proxy detects an endpoint failure. If the gRPC proxy detects an endpoint failure, it switches to a different  endpoint, if available, to hide failures from its clients. Other retry  policies, such as weighted round-robin, may be supported in the future.
gRPC 代理支持多个 etcd 服务器端点。当代理启动时，它会随机选择一个 etcd  服务器端点来使用。此终结点为所有请求提供服务，直到代理检测到终结点故障。如果 gRPC  代理检测到终结点故障，它会切换到其他终结点（如果可用），以隐藏其客户端的故障。将来可能会支持其他重试策略，例如加权轮询。

## Scalable watch API 可扩展的手表 API

The gRPC proxy coalesces multiple client watchers (`c-watchers`) on the same key or range into a single watcher (`s-watcher`) connected to an etcd server. The proxy broadcasts all events from the `s-watcher` to its `c-watchers`.
gRPC 代理将同一键或范围上的多个客户端观察程序 （ `c-watchers` ） 合并为连接到 etcd 服务器的单个观察程序 （ `s-watcher` ）。代理将所有事件从 `s-watcher` 广播到其 `c-watchers` .

Assuming N clients watch the same key, one gRPC proxy can reduce the watch load  on the etcd server from N to 1. Users can deploy multiple gRPC proxies  to further distribute server load.
假设 N 个客户端监视相同的密钥，一个 gRPC 代理可以将 etcd 服务器上的监视负载从 N 个减少到 1。用户可以部署多个 gRPC 代理以进一步分配服务器负载。

In the following example, three clients watch on key A. The gRPC proxy  coalesces the three watchers, creating a single watcher attached to the  etcd server.
在以下示例中，三个客户端监视密钥 A。gRPC 代理合并了三个观察者，创建了一个附加到 etcd 服务器的观察者。

```
            +-------------+
            | etcd server |
            +------+------+
                   ^ watch key A (s-watcher)
                   |
           +-------+-----+
           | gRPC proxy  | <-------+
           |             |         |
           ++-----+------+         |watch key A (c-watcher)
watch key A ^     ^ watch key A    |
(c-watcher) |     | (c-watcher)    |
    +-------+-+  ++--------+  +----+----+
    |  client |  |  client |  |  client |
    |         |  |         |  |         |
    +---------+  +---------+  +---------+
```

### Limitations 局限性

To effectively coalesce multiple client watchers into a single watcher, the gRPC proxy coalesces new `c-watchers` into an existing `s-watcher` when possible. This coalesced `s-watcher` may be out of sync with the etcd server due to network delays or  buffered undelivered events. When the watch revision is unspecified, the gRPC proxy will not guarantee the `c-watcher` will start watching from the most recent store revision. For example,  if a client watches from an etcd server with revision 1000, that watcher will begin at revision 1000. If a client watches from the gRPC proxy,  may begin watching from revision 990.
为了有效地将多个客户端观察程序合并为一个观察程序，gRPC 代理会尽可能将新 `c-watchers` 客户端观察程序合并到现有 `s-watcher` 观察程序中。由于网络延迟或缓冲的未交付事件，此合并 `s-watcher` 可能与 etcd 服务器不同步。如果未指定监视修订版，则 gRPC 代理将不保证 `c-watcher` 将从最新的存储修订版开始监视。例如，如果客户端从修订版为 1000 的 etcd 服务器进行监视，则该观察程序将从修订版 1000 开始。如果客户端从 gRPC 代理监视，则可以从修订版 990 开始监视。

Similar limitations apply to cancellation. When the watcher is cancelled, the  etcd server’s revision may be greater than the cancellation response  revision.
类似的限制也适用于取消。当观察程序被取消时，etcd 服务器的修订版可能大于取消响应的修订版。

These two limitations should not cause problems for most use cases. In the  future, there may be additional options to force the watcher to bypass  the gRPC proxy for more accurate revision responses.
对于大多数用例，这两个限制应该不会造成问题。将来，可能会有其他选项强制观察程序绕过 gRPC 代理，以获得更准确的修订响应。

## Scalable lease API 可扩展的租赁 API

To keep its leases alive, a client must establish at least one gRPC stream to an etcd server for sending periodic heartbeats. If an etcd workload  involves heavy lease activity spread over many clients, these streams  may contribute to excessive CPU utilization. To reduce the total number  of streams on the core cluster, the proxy supports lease stream  coalescing.
为了保持其租约处于活动状态，客户端必须至少建立一个 gRPC 流到 etcd 服务器，以发送定期检测信号。如果 etcd 工作负载涉及分布在多个客户端的大量租赁活动，则这些流可能会导致 CPU 利用率过高。为了减少核心集群上的流总数，代理支持租约流合并。

Assuming N clients are updating leases, a single gRPC proxy reduces the stream  load on the etcd server from N to 1. Deployments may have additional  gRPC proxies to further distribute streams across multiple proxies.
假设 N 个客户端正在更新租约，则单个 gRPC 代理将 etcd 服务器上的流负载从 N 个减少到 1 个。部署可能具有额外的 gRPC 代理，以进一步在多个代理之间分发流。

In the following example, three clients update three independent leases (`L1`, `L2`, and `L3`). The gRPC proxy coalesces the three client lease streams (`c-streams`) into a single lease keep alive stream (`s-stream`) attached to an etcd server. The proxy forwards client-side lease  heartbeats from the c-streams to the s-stream, then returns the  responses to the corresponding c-streams.
在以下示例中，三个客户端更新三个独立租约（ `L1` 、 `L2` 和 `L3` ）。gRPC 代理将三个客户端租约流 （ `c-streams` ） 合并为一个附加到 etcd 服务器的租约保持活动流 （ `s-stream` ）。代理将客户端租用检测信号从 c-stream 转发到 s-stream，然后将响应返回给相应的 c-stream。

```
          +-------------+
          | etcd server |
          +------+------+
                 ^
                 | heartbeat L1, L2, L3
                 | (s-stream)
                 v
         +-------+-----+
         | gRPC proxy  +<-----------+
         +---+------+--+            | heartbeat L3
             ^      ^               | (c-stream)
heartbeat L1 |      | heartbeat L2  |
(c-stream)   v      v (c-stream)    v
      +------+-+  +-+------+  +-----+--+
      | client |  | client |  | client |
      +--------+  +--------+  +--------+
```

## Abusive clients protection 滥用客户保护

The gRPC proxy caches responses for requests when it does not break  consistency requirements. This can protect the etcd server from abusive  clients in tight for loops.
gRPC 代理在不违反一致性要求的情况下缓存请求的响应。这可以保护 etcd 服务器免受紧密循环中的滥用客户端的侵害。

## Start etcd gRPC proxy 启动 etcd gRPC 代理

Consider an etcd cluster with the following static endpoints:
考虑一个具有以下静态端点的 etcd 集群：

| Name 名字        | Address 地址 | Hostname 主机名    |
| ---------------- | ------------ | ------------------ |
| infra0 基础设施0 | 10.0.1.10    | infra0.example.com |
| infra1 基础设施1 | 10.0.1.11    | infra1.example.com |
| infra2 基础设施2 | 10.0.1.12    | infra2.example.com |

Start the etcd gRPC proxy to use these static endpoints with the command:
通过以下命令启动 etcd gRPC 代理以使用这些静态端点：

```bash
$ etcd grpc-proxy start --endpoints=infra0.example.com,infra1.example.com,infra2.example.com --listen-addr=127.0.0.1:2379
```

The etcd gRPC proxy starts and listens on port 2379. It forwards client requests to one of the three endpoints provided above.
etcd gRPC 代理在端口 2379 上启动并侦听。它将客户端请求转发到上面提供的三个终结点之一。

Sending requests through the proxy:
通过代理发送请求：

```bash
$ ETCDCTL_API=3 etcdctl --endpoints=127.0.0.1:2379 put foo bar
OK
$ ETCDCTL_API=3 etcdctl --endpoints=127.0.0.1:2379 get foo
foo
bar
```

## Client endpoint synchronization and name resolution 客户端终结点同步和名称解析

The proxy supports registering its endpoints for discovery by writing to a  user-defined endpoint. This serves two purposes. First, it allows  clients to synchronize their endpoints against a set of proxy endpoints  for high availability. Second, it is an endpoint provider for etcd [gRPC naming](https://etcd.io/docs/v3.5/dev-guide/grpc_naming/).
代理支持通过写入用户定义的终结点来注册其终结点以进行发现。这有两个目的。首先，它允许客户端将其终结点与一组代理终结点同步，以实现高可用性。其次，它是 etcd gRPC 命名的端点提供者。

Register proxy(s) by providing a user-defined prefix:
通过提供用户定义的前缀来注册代理：

```bash
$ etcd grpc-proxy start --endpoints=localhost:2379 \
  --listen-addr=127.0.0.1:23790 \
  --advertise-client-url=127.0.0.1:23790 \
  --resolver-prefix="___grpc_proxy_endpoint" \
  --resolver-ttl=60

$ etcd grpc-proxy start --endpoints=localhost:2379 \
  --listen-addr=127.0.0.1:23791 \
  --advertise-client-url=127.0.0.1:23791 \
  --resolver-prefix="___grpc_proxy_endpoint" \
  --resolver-ttl=60
```

The proxy will list all its members for member list:
代理将列出其所有成员以供成员列表：

```bash
ETCDCTL_API=3 etcdctl --endpoints=http://localhost:23790 member list --write-out table

+----+---------+--------------------------------+------------+-----------------+
| ID | STATUS  |              NAME              | PEER ADDRS |  CLIENT ADDRS   |
+----+---------+--------------------------------+------------+-----------------+
|  0 | started | Gyu-Hos-MBP.sfo.coreos.systems |            | 127.0.0.1:23791 |
|  0 | started | Gyu-Hos-MBP.sfo.coreos.systems |            | 127.0.0.1:23790 |
+----+---------+--------------------------------+------------+-----------------+
```

This lets clients automatically discover proxy endpoints through Sync:
这允许客户端通过同步自动发现代理终结点：

```go
cli, err := clientv3.New(clientv3.Config{
    Endpoints: []string{"http://localhost:23790"},
})
if err != nil {
    log.Fatal(err)
}
defer cli.Close()

// fetch registered grpc-proxy endpoints
if err := cli.Sync(context.Background()); err != nil {
    log.Fatal(err)
}
```

Note that if a proxy is configured without a resolver prefix,
请注意，如果代理配置时没有解析程序前缀，

```bash
$ etcd grpc-proxy start --endpoints=localhost:2379 \
  --listen-addr=127.0.0.1:23792 \
  --advertise-client-url=127.0.0.1:23792
```

The member list API to the grpc-proxy returns its own `advertise-client-url`:
grpc-proxy 的成员列表 API 返回自己的 `advertise-client-url` ：

```bash
ETCDCTL_API=3 etcdctl --endpoints=http://localhost:23792 member list --write-out table

+----+---------+--------------------------------+------------+-----------------+
| ID | STATUS  |              NAME              | PEER ADDRS |  CLIENT ADDRS   |
+----+---------+--------------------------------+------------+-----------------+
|  0 | started | Gyu-Hos-MBP.sfo.coreos.systems |            | 127.0.0.1:23792 |
+----+---------+--------------------------------+------------+-----------------+
```

## Namespacing 命名空间

Suppose an application expects full control over the entire key space, but the  etcd cluster is shared with other applications. To let all applications  run without interfering with each other, the proxy can partition the  etcd keyspace so clients appear to have access to the complete keyspace. When the proxy is given the flag `--namespace`, all client requests going into the proxy are translated to have a  user-defined prefix on the keys. Accesses to the etcd cluster will be  under the prefix and responses from the proxy will strip away the  prefix; to the client, it appears as if there is no prefix at all.
假设一个应用程序期望完全控制整个密钥空间，但 etcd 集群与其他应用程序共享。为了让所有应用程序在不相互干扰的情况下运行，代理可以对 etcd 密钥空间进行分区，以便客户端看起来可以访问整个密钥空间。当代理被赋予标志时 `--namespace` ，进入代理的所有客户端请求都会被转换为在键上具有用户定义的前缀。对 etcd 集群的访问将在前缀下，来自代理的响应将剥离前缀;对于客户端来说，它似乎根本没有前缀。

To namespace a proxy, start it with `--namespace`:

```bash
$ etcd grpc-proxy start --endpoints=localhost:2379 \
  --listen-addr=127.0.0.1:23790 \
  --namespace=my-prefix/
```

Accesses to the proxy are now transparently prefixed on the etcd cluster:
对代理的访问现在在 etcd 集群上透明地带有前缀：

```bash
$ ETCDCTL_API=3 etcdctl --endpoints=localhost:23790 put my-key abc
# OK
$ ETCDCTL_API=3 etcdctl --endpoints=localhost:23790 get my-key
# my-key
# abc
$ ETCDCTL_API=3 etcdctl --endpoints=localhost:2379 get my-prefix/my-key
# my-prefix/my-key
# abc
```

## TLS termination TLS 终止

Terminate TLS from a secure etcd cluster with the gRPC proxy by serving an unencrypted local endpoint.
通过提供未加密的本地终端节点，使用 gRPC 代理从安全 etcd 集群终止 TLS。

To try it out, start a single member etcd cluster with client https:
要尝试一下，请使用客户端 https 启动单个成员 etcd 集群：

```sh
$ etcd --listen-client-urls https://localhost:2379 --advertise-client-urls https://localhost:2379 --cert-file=peer.crt --key-file=peer.key --trusted-ca-file=ca.crt --client-cert-auth
```

Confirm the client port is serving https:
确认客户端端口正在提供 https：

```sh
# fails
$ ETCDCTL_API=3 etcdctl --endpoints=http://localhost:2379 endpoint status
# works
$ ETCDCTL_API=3 etcdctl --endpoints=https://localhost:2379 --cert=client.crt --key=client.key --cacert=ca.crt endpoint status
```

Next, start a gRPC proxy on `localhost:12379` by connecting to the etcd endpoint `https://localhost:2379` using the client certificates:
接下来， `localhost:12379`  `https://localhost:2379` 通过使用客户端证书连接到 etcd 端点来启动 gRPC 代理：

```sh
$ etcd grpc-proxy start --endpoints=https://localhost:2379 --listen-addr localhost:12379 --cert client.crt --key client.key --cacert=ca.crt --insecure-skip-tls-verify &
```

Finally, test the TLS termination by putting a key into the proxy over http:
最后，通过通过 http 将密钥放入代理中来测试 TLS 终止：

```sh
$ ETCDCTL_API=3 etcdctl --endpoints=http://localhost:12379 put abc def
# OK
```

## Metrics and Health 指标和运行状况

The gRPC proxy exposes `/health` and Prometheus `/metrics` endpoints for the etcd members defined by `--endpoints`. An alternative define an additional URL that will respond to both the `/metrics` and `/health` endpoints with the `--metrics-addr` flag.
gRPC 代理公开 `/health` 了 `--endpoints` 和 Prometheus `/metrics` 端点，用于定义 的 etcd 成员。另一种方法是定义一个附加 URL，该 URL 将使用 `--metrics-addr` 标志响应 `/metrics` and `/health` 终结点。

```bash
$ etcd grpc-proxy start \
  --endpoints https://localhost:2379 \
  --metrics-addr https://0.0.0.0:4443 \
  --listen-addr 127.0.0.1:23790 \
  --key client.key \
  --key-file proxy-server.key \
  --cert client.crt \
  --cert-file proxy-server.crt \
  --cacert ca.pem \
  --trusted-ca-file proxy-ca.pem
```

### Known issue 已知问题

The main interface of the proxy serves both HTTP2 and HTTP/1.1. If proxy is setup with TLS as show in the above example, when using a client such  as cURL against the listening interface will require explicitly setting  the protocol to HTTP/1.1 on the request to return `/metrics` or `/health`. By using the `--metrics-addr` flag the secondary interface will not have this requirement.
代理的主接口同时提供 HTTP2 和 HTTP/1.1。如果使用 TLS 设置代理，如上例所示，则在对侦听接口使用客户端（如 cURL）时，需要在请求返回 `/metrics` 或 `/health` .通过使用该 `--metrics-addr` 标志，辅助接口将没有此要求。

```bash
 $ curl --cacert proxy-ca.pem --key proxy-client.key --cert proxy-client.crt https://127.0.0.1:23790/metrics --http1.1
```