# FAQ

### How do you pronounce etcd? etcd如何发音？

etcd is pronounced **/ˈɛtsiːdiː/**, and means “distributed `etc` directory.”
etcd 发音为 /ˈɛtsiːdiː/，意思是“分布式 `etc` 目录”。

### Do clients have to send requests to the etcd leader? 客户端是否必须向 etcd leader 发送请求？

[Raft](https://raft.github.io/raft.pdf) is leader-based; the leader handles all client requests which need  cluster consensus. However, the client does not need to know which node  is the leader. Any request that requires consensus sent to a follower is automatically forwarded to the leader. Requests that do not require  consensus (e.g., serialized reads) can be processed by any cluster  member.
Raft 是基于领导者的;领导者处理所有需要集群共识的客户端请求。但是，客户端不需要知道哪个节点是领导者。任何需要达成共识的请求都会自动转发给领导者。不需要共识的请求（例如，序列化读取）可以由任何集群成员处理。

## Configuration 配置

### What is the difference between listen-<client,peer>-urls, advertise-client-urls or initial-advertise-peer-urls? listen-<client，peer>-urls、advertise-client-urls 或 initial-advertise-peer-urls 有什么区别？

`listen-client-urls` and `listen-peer-urls` specify the local addresses etcd server binds to for accepting incoming connections. To listen on a port for all interfaces, specify `0.0.0.0` as the listen IP address.
 `listen-client-urls` 并 `listen-peer-urls` 指定 etcd 服务器绑定到的本地地址以接受传入连接。要侦听所有接口的端口，请指定 `0.0.0.0` 为侦听 IP 地址。

`advertise-client-urls` and `initial-advertise-peer-urls` specify the addresses etcd clients or other etcd members should use to  contact the etcd server. The advertise addresses must be reachable from  the remote machines. Do not advertise addresses like `localhost` or `0.0.0.0` for a production setup since these addresses are unreachable from remote machines.
 `advertise-client-urls` 并 `initial-advertise-peer-urls` 指定 etcd 客户端或其他 etcd 成员用于联系 etcd 服务器的地址。播发地址必须可从远程计算机访问。不要为生产设置通告地址， `0.0.0.0` 因为 `localhost` 这些地址无法从远程计算机访问。

### Why doesn’t changing `--listen-peer-urls` or `--initial-advertise-peer-urls` update the advertised peer URLs in `etcdctl member list`? 为什么不更改 `--listen-peer-urls` 或 `--initial-advertise-peer-urls` 更新 中播发的对等 URL `etcdctl member list` ？

A member’s advertised peer URLs come from `--initial-advertise-peer-urls` on initial cluster boot. Changing the listen peer URLs or the initial  advertise peers after booting the member won’t affect the exported  advertise peer URLs since changes must go through quorum to avoid  membership configuration split brain. Use `etcdctl member update` to update a member’s peer URLs.
成员播发的对等 URL 来自 `--initial-advertise-peer-urls` 初始集群引导时。在启动成员后更改侦听对等 URL 或初始播发对等体不会影响导出的通告对等体 URL，因为更改必须通过仲裁以避免成员资格配置拆分。用于 `etcdctl member update` 更新成员的对等 URL。

## Deployment 部署

### System requirements 系统要求

Since etcd writes data to disk, its performance strongly depends on disk  performance. For this reason, SSD is highly recommended. To assess  whether a disk is fast enough for etcd, one possibility is using a disk  benchmarking tool such as [fio](https://github.com/axboe/fio). For an example on how to do that, read [here](https://www.ibm.com/cloud/blog/using-fio-to-tell-whether-your-storage-is-fast-enough-for-etcd). To prevent performance degradation or unintentionally overloading the  key-value store, etcd enforces a configurable storage size quota set to  2GB by default. To avoid swapping or running out of memory, the machine  should have at least as much RAM to cover the quota. 8GB is a suggested  maximum size for normal environments and etcd warns at startup if the  configured value exceeds it. At CoreOS, an etcd cluster is usually  deployed on dedicated CoreOS Container Linux machines with dual-core  processors, 2GB of RAM, and 80GB of SSD *at the very least*. **Note that performance is intrinsically workload dependent; please test before production deployment**. See [hardware](https://etcd.io/docs/v3.5/op-guide/hardware/) for more recommendations.
由于 etcd 将数据写入磁盘，因此其性能很大程度上取决于磁盘性能。因此，强烈建议使用 SSD。为了评估磁盘是否足够快，可以进行  etcd，一种可能性是使用磁盘基准测试工具，例如 fio。有关如何执行此操作的示例，请阅读此处。为了防止性能下降或无意中使键值存储过载，etcd 强制执行可配置的存储大小配额，默认设置为 2GB。为避免交换或内存不足，计算机应至少具有相同多的 RAM 来满足配额。8GB  是正常环境的建议最大大小，如果配置的值超过它，etcd 会在启动时发出警告。在 CoreOS，etcd 集群通常部署在专用的 CoreOS 容器 Linux 机器上，至少具有双核处理器、2GB RAM 和 80GB  SSD。请注意，性能本质上取决于工作负载;请在生产部署之前进行测试。有关更多建议，请参阅硬件。

Most stable production environment is Linux operating system with amd64 architecture; see [supported platform](https://etcd.io/docs/v3.5/op-guide/supported-platform/) for more.
最稳定的生产环境是 amd64 架构的 Linux 操作系统;有关详细信息，请参阅支持的平台。

### Why an odd number of cluster members? 为什么集群成员数量为奇数？

An etcd cluster needs a majority of nodes, a quorum, to agree on updates  to the cluster state. For a cluster with n members, quorum is (n/2)+1.  For any odd-sized cluster, adding one node will always increase the  number of nodes necessary for quorum. Although adding a node to an  odd-sized cluster appears better since there are more machines, the  fault tolerance is worse since exactly the same number of nodes may fail without losing quorum but there are more nodes that can fail. If the  cluster is in a state where it can’t tolerate any more failures, adding a node before removing nodes is dangerous because if the new node fails  to register with the cluster (e.g., the address is misconfigured),  quorum will be permanently lost.
etcd 集群需要大多数节点（仲裁）才能就集群状态的更新达成一致。对于具有 n 个成员的集群，仲裁为  （n/2）+1。对于任何奇数大小的群集，添加一个节点将始终增加仲裁所需的节点数。尽管将节点添加到奇数大小的群集看起来更好，因为有更多的计算机，但容错能力更差，因为完全相同数量的节点可能会失败而不会丢失仲裁，但可能会有更多的节点发生故障。如果群集处于无法容忍更多故障的状态，则在删除节点之前添加节点是危险的，因为如果新节点无法向群集注册（例如，地址配置错误），仲裁将永久丢失。

### What is maximum cluster size? 最大集群大小是多少？

Theoretically, there is no hard limit. However, an etcd cluster probably should have no more than seven nodes. [Google Chubby lock service](http://static.googleusercontent.com/media/research.google.com/en//archive/chubby-osdi06.pdf), similar to etcd and widely deployed within Google for many years,  suggests running five nodes. A 5-member etcd cluster can tolerate two  member failures, which is enough in most cases. Although larger clusters provide better fault tolerance, the write performance suffers because  data must be replicated across more machines.
从理论上讲，没有硬性限制。但是，一个 etcd 集群可能不应该超过 7 个节点。Google Chubby 锁服务，类似于 etcd，在 Google  中广泛部署多年，建议运行五个节点。一个 5 成员的 etcd  集群可以容忍两个成员故障，这在大多数情况下就足够了。尽管较大的群集提供了更好的容错能力，但写入性能会受到影响，因为必须在更多计算机上复制数据。

### What is failure tolerance? 什么是容错？

An etcd cluster operates so long as a member quorum can be established. If quorum is lost through transient network failures (e.g., partitions),  etcd automatically and safely resumes once the network recovers and  restores quorum; Raft enforces cluster consistency. For power loss, etcd persists the Raft log to disk; etcd replays the log to the point of  failure and resumes cluster participation. For permanent hardware  failure, the node may be removed from the cluster through [runtime reconfiguration](https://etcd.io/docs/v3.5/op-guide/runtime-configuration/).
只要可以建立成员仲裁，etcd 集群就会运行。如果仲裁因暂时性网络故障（例如分区）而丢失，则一旦网络恢复并恢复仲裁，etcd 就会自动安全地恢复;Raft  强制执行集群一致性。对于断电，etcd 将 Raft 日志持久化到磁盘;etcd  将日志重放到故障点，并恢复集群参与。对于永久性硬件故障，可以通过运行时重新配置从集群中删除节点。

It is recommended to have an odd number of members in a cluster. An  odd-size cluster tolerates the same number of failures as an even-size  cluster but with fewer nodes. The difference can be seen by comparing  even and odd sized clusters:
建议集群中的成员数为奇数。奇数大小的群集容忍的故障数与偶数大小的群集相同，但节点较少。通过比较偶数和奇数大小的聚类可以看出差异：

| Cluster Size 集群大小 | Majority 大多数 | Failure Tolerance 容错 |
| :-------------------: | :-------------: | :--------------------: |
|           1           |        1        |           0            |
|           2           |        2        |           0            |
|           3           |        2        |           1            |
|           4           |        3        |           1            |
|           5           |        3        |           2            |
|           6           |        4        |           2            |
|           7           |        4        |           3            |
|           8           |        5        |           3            |
|           9           |        5        |           4            |

Adding a member to bring the size of cluster up to an even number doesn’t buy  additional fault tolerance. Likewise, during a network partition, an odd number of members guarantees that there will always be a majority  partition that can continue to operate and be the source of truth when  the partition ends.
添加成员以使群集的大小达到偶数不会购买额外的容错能力。同样，在网络分区期间，奇数个成员保证了始终存在一个多数分区，该分区可以继续运行，并在分区结束时成为事实来源。

### Does etcd work in cross-region or cross data center deployments? etcd 是否适用于跨区域或跨数据中心部署？

Deploying etcd across regions improves etcd’s fault tolerance since members are  in separate failure domains. The cost is higher consensus request  latency from crossing data center boundaries. Since etcd relies on a  member quorum for consensus, the latency from crossing data centers will be somewhat pronounced because at least a majority of cluster members  must respond to consensus requests. Additionally, cluster data must be  replicated across all peers, so there will be bandwidth cost as well.
跨区域部署 etcd 可以提高 etcd 的容错能力，因为成员位于不同的故障域中。代价是跨越数据中心边界导致的共识请求延迟更高。由于 etcd  依赖于成员仲裁来达成共识，因此跨数据中心的延迟会有些明显，因为至少大多数集群成员必须响应共识请求。此外，集群数据必须在所有对等方之间复制，因此也会产生带宽成本。

With longer latencies, the default etcd configuration may cause frequent elections or heartbeat timeouts. See [tuning](https://etcd.io/docs/v3.5/tuning/) for adjusting timeouts for high latency deployments.
延迟越长，默认的 etcd 配置可能会导致频繁的选举或检测信号超时。请参阅调整高延迟部署的超时。

## Operation 操作

### Should I add a member before removing an unhealthy member? 在删除不正常的成员之前，我应该添加成员吗？

When replacing an etcd node, it’s important to remove the member first and then add its replacement.
替换 etcd 节点时，请务必先删除该成员，然后再添加其替换。

etcd employs distributed consensus based on a quorum model; (n/2)+1 members, a majority, must agree on a proposal before it can be committed to the  cluster. These proposals include key-value updates and membership  changes. This model totally avoids any possibility of split brain  inconsistency. The downside is permanent quorum loss is catastrophic.
etcd 采用基于 quorum 模型的分布式共识;（n/2）+1 成员（占多数）必须就提案达成一致，然后才能将其提交到集群中。这些建议包括键值更新和成员身份更改。该模型完全避免了任何裂脑不一致的可能性。不利的一面是永久性的法定人数损失是灾难性的。

How this applies to membership: If a 3-member cluster has 1 downed member,  it can still make forward progress because the quorum is 2 and 2 members are still live. However, adding a new member to a 3-member cluster will increase the quorum to 3 because 3 votes are required for a majority of 4 members. Since the quorum increased, this extra member buys nothing  in terms of fault tolerance; the cluster is still one node failure away  from being unrecoverable.
这如何应用于成员身份：如果 3 成员群集有 1 个已关闭的成员，它仍然可以向前推进，因为仲裁为 2 个，并且 2 个成员仍处于活动状态。但是，向 3  名成员群集添加新成员会将法定人数增加到 3 人，因为 4 名成员的多数需要 3  票。由于仲裁人数增加，这个额外的成员在容错方面一无所获;群集距离不可恢复仍差一个节点故障。

Additionally, that new member is risky because it may turn out to be misconfigured or incapable of joining the cluster. In that case, there’s no way to  recover quorum because the cluster has two members down and two members  up, but needs three votes to change membership to undo the botched  membership addition. etcd will by default reject member add attempts  that could take down the cluster in this manner.
此外，该新成员存在风险，因为它可能配置错误或无法加入集群。在这种情况下，无法恢复仲裁，因为群集有两个成员关闭，两个成员启动，但需要三票才能更改成员身份以撤消拙劣的成员身份添加。默认情况下，etcd 将拒绝可能以这种方式关闭集群的成员添加尝试。

On the other hand, if the downed member is removed from cluster membership first, the number of members becomes 2 and the quorum remains at 2.  Following that removal by adding a new member will also keep the quorum  steady at 2. So, even if the new node can’t be brought up, it’s still  possible to remove the new member through quorum on the remaining live  members.
另一方面，如果首先从集群成员身份中删除已关闭的成员，则成员数将变为 2，仲裁人数仍为 2。删除后，通过添加新成员也将法定人数稳定在 2 人。因此，即使无法启动新节点，仍可以通过剩余活动成员的仲裁删除新成员。

### Why won’t etcd accept my membership changes? 为什么etcd不接受我的会员资格变更？

etcd sets `strict-reconfig-check` in order to reject reconfiguration requests that would cause quorum  loss. Abandoning quorum is really risky (especially when the cluster is  already unhealthy). Although it may be tempting to disable quorum  checking if there’s quorum loss to add a new member, this could lead to  full fledged cluster inconsistency. For many applications, this will  make the problem even worse (“disk geometry corruption” being a  candidate for most terrifying).
etcd 集 `strict-reconfig-check`  以拒绝会导致仲裁丢失的重新配置请求。放弃仲裁确实存在风险（尤其是当群集已经不正常时）。尽管如果存在配额丢失以添加新成员，则禁用仲裁检查可能很诱人，但这可能会导致完全成熟的群集不一致。对于许多应用程序来说，这将使问题变得更糟（“磁盘几何损坏”是最可怕的候选者）。

### Why does etcd lose its leader from disk latency spikes? 为什么 etcd 会因磁盘延迟峰值而失去其领导者？

This is intentional; disk latency is part of leader liveness. Suppose the  cluster leader takes a minute to fsync a raft log update to disk, but  the etcd cluster has a one second election timeout. Even though the  leader can process network messages within the election interval (e.g.,  send heartbeats), it’s effectively unavailable because it can’t commit  any new proposals; it’s waiting on the slow disk. If the cluster  frequently loses its leader due to disk latencies, try [tuning](https://etcd.io/docs/v3.5/tuning/) the disk settings or etcd time parameters.
这是故意的;磁盘延迟是领导者活跃度的一部分。假设集群领导者需要一分钟时间将 raft 日志更新同步到磁盘，但 etcd  集群有一秒钟的选举超时。即使领导者可以在选举间隔内处理网络消息（例如，发送检测信号），它实际上也不可用，因为它无法提交任何新提案;它正在慢速磁盘上等待。如果集群由于磁盘延迟而频繁丢失其领导，请尝试调整磁盘设置或 etcd 时间参数。

### What does the etcd warning “request ignored (cluster ID mismatch)” mean? etcd 警告“请求被忽略（集群 ID 不匹配）”是什么意思？

Every new etcd cluster generates a new cluster ID based on the initial cluster configuration and a user-provided unique `initial-cluster-token` value. By having unique cluster ID’s, etcd is protected from cross-cluster interaction which could corrupt the cluster.
每个新的 etcd 集群都会根据初始集群配置和用户提供的唯一 `initial-cluster-token` 值生成一个新的集群 ID。通过具有唯一的集群 ID，etcd 可以防止跨集互，这可能会破坏集群。

Usually this warning happens after tearing down an old cluster, then reusing  some of the peer addresses for the new cluster. If any etcd process from the old cluster is still running it will try to contact the new  cluster. The new cluster will recognize a cluster ID mismatch, then  ignore the request and emit this warning. This warning is often cleared  by ensuring peer addresses among distinct clusters are disjoint.
通常，此警告发生在拆除旧集群，然后为新集群重用某些对等地址之后。如果旧集群中的任何 etcd 进程仍在运行，它将尝试联系新集群。新集群将识别出集群 ID 不匹配，然后忽略该请求并发出此警告。通常通过确保不同集群之间的对等地址不相交来清除此警告。

### What does “mvcc: database space exceeded” mean and how do I fix it? “mvcc： database space exceeded”是什么意思，我该如何解决？

The [multi-version concurrency control](https://etcd.io/docs/v3.5/learning/api/#revisions) data model in etcd keeps an exact history of the keyspace. Without periodically compacting this history (e.g., by setting `--auto-compaction`), etcd will eventually exhaust its storage space. If etcd runs low on  storage space, it raises a space quota alarm to protect the cluster from further writes. So long as the alarm is raised, etcd responds to write  requests with the error `mvcc: database space exceeded`.
etcd 中的多版本并发控制数据模型保留了密钥空间的精确历史记录。如果不定期压缩此历史记录（例如，通过设置 `--auto-compaction` ），etcd 最终会耗尽其存储空间。如果 etcd 的存储空间不足，它会发出空间配额警报，以保护集群免受进一步写入的影响。只要发出警报，etcd 就会响应带有错误 `mvcc: database space exceeded` 的写入请求。

To recover from the low space quota alarm:
要从空间配额不足警报中恢复，请执行以下操作：

1. [Compact](https://etcd.io/docs/v3.5/op-guide/maintenance/#history-compaction-v3-api-key-value-database) etcd’s history. Compact etcd 的历史。
2. [Defragment](https://etcd.io/docs/v3.5/op-guide/maintenance/#defragmentation) every etcd endpoint.
   对每个 etcd 端点进行碎片整理。
3. [Disarm](https://github.com/etcd-io/etcd/blob/master/etcdctl/README.md#alarm-disarm) the alarm. 解除警报。

### What does the etcd warning “etcdserver/api/v3rpc: transport:  http2Server.HandleStreams failed to read frame: read tcp  127.0.0.1:2379->127.0.0.1:43020: read: connection reset by peer”  mean? etcd 警告 “etcdserver/api/v3rpc： transport： http2Server.HandleStreams failed  to read frame： read tcp 127.0.0.1：2379->127.0.0.1：43020： read：  connection reset by peer” 是什么意思？

This is gRPC-side warning when a server receives a TCP RST flag with  client-side streams being prematurely closed. For example, a client  closes its connection, while gRPC server has not yet processed all  HTTP/2 frames in the TCP queue. Some data may have been lost in server  side, but it is ok so long as client connection has already been closed.
当服务器收到客户端流过早关闭的 TCP RST 标志时，这是 gRPC 端警告。例如，客户端关闭其连接，而 gRPC 服务器尚未处理 TCP 队列中的所有 HTTP/2 帧。某些数据可能在服务器端丢失，但只要客户端连接已经关闭，就可以了。

Only [old versions of gRPC](https://github.com/grpc/grpc-go/issues/1362) log this. etcd [>=v3.2.13 by default log this with DEBUG level](https://github.com/etcd-io/etcd/pull/9080), thus only visible with `--log-level=debug` flag enabled.
只有旧版本的 gRPC 会记录此内容。etcd >=v3.2.13 默认情况下，使用 DEBUG 级别记录此记录，因此只有在启用标志时 `--log-level=debug` 才可见。

## Performance 性能

### How should I benchmark etcd? 我应该如何对 etcd 进行基准测试？

Try the [benchmark](https://github.com/etcd-io/etcd/tree/master/tools/benchmark) tool. Current [benchmark results](https://etcd.io/docs/v3.5/op-guide/performance/) are available for comparison.
试试基准测试工具。当前的基准测试结果可供比较。

### What does the etcd warning “apply entries took too long” mean? etcd 警告“apply entries taken too long”是什么意思？

After a majority of etcd members agree to commit a request, each etcd server  applies the request to its data store and persists the result to disk.  Even with a slow mechanical disk or a virtualized network disk, such as  Amazon’s EBS or Google’s PD, applying a request should normally take  fewer than 50 milliseconds. If the average apply duration exceeds 100  milliseconds, etcd will warn that entries are taking too long to apply.
在大多数 etcd 成员同意提交请求后，每个 etcd 服务器将请求应用于其数据存储，并将结果保存到磁盘。即使使用缓慢的机械磁盘或虚拟化网络磁盘（例如  Amazon 的 EBS 或 Google 的 PD），应用请求通常也应花费不到 50 毫秒的时间。如果平均申请持续时间超过 100  毫秒，etcd 将警告条目申请时间过长。

Usually this issue is caused by a slow disk. The disk could be experiencing  contention among etcd and other applications, or the disk is too simply  slow (e.g., a shared virtualized disk). To rule out a slow disk from  causing this warning, monitor [backend_commit_duration_seconds](https://etcd.io/docs/v3.5/metrics/#disk) (p99 duration should be less than 25ms) to confirm the disk is  reasonably fast. If the disk is too slow, assigning a dedicated disk to  etcd or using faster disk will typically solve the problem.
通常，此问题是由磁盘速度较慢引起的。磁盘可能在 etcd  和其他应用程序之间遇到争用，或者磁盘速度太慢（例如，共享虚拟化磁盘）。要排除导致此警告的慢速磁盘，请监视backend_commit_duration_seconds（p99 持续时间应小于 25 毫秒）以确认磁盘速度相当快。如果磁盘太慢，将专用磁盘分配给 etcd 或使用更快的磁盘通常可以解决问题。

The second most common cause is CPU starvation. If monitoring of the  machine’s CPU usage shows heavy utilization, there may not be enough  compute capacity for etcd. Moving etcd to dedicated machine, increasing  process resource isolation cgroups, or renicing the etcd server process  into a higher priority can usually solve the problem.
第二个最常见的原因是 CPU 匮乏。如果对计算机 CPU 使用率的监控显示使用率很高，则 etcd 可能没有足够的计算容量。将 etcd 移动到专用机器，增加进程资源隔离 cgroups，或者将 etcd 服务器进程调整为更高的优先级通常可以解决问题。

Expensive user requests which access too many keys (e.g., fetching the entire  keyspace) can also cause long apply latencies. Accessing fewer than a  several hundred keys per request, however, should always be performant.
访问过多密钥（例如，获取整个密钥空间）的昂贵用户请求也可能导致长时间的应用延迟。但是，每个请求访问少于几百个密钥应该始终是高性能的。

If none of the above suggestions clear the warnings, please [open an issue](https://github.com/etcd-io/etcd/issues/new) with detailed logging, monitoring, metrics and optionally workload information.
如果上述建议均未清除警告，请打开一个问题，其中包含详细的日志记录、监控、指标和可选的工作负载信息。

### What does the etcd warning “failed to send out heartbeat on time” mean? etcd 警告“未能按时发送心跳”是什么意思？

etcd uses a leader-based consensus protocol for consistent data replication  and log execution. Cluster members elect a single leader, all other  members become followers. The elected leader must periodically send  heartbeats to its followers to maintain its leadership. Followers infer  leader failure if no heartbeats are received within an election interval and trigger an election. If a leader doesn’t send its heartbeats in  time but is still running, the election is spurious and likely caused by insufficient resources. To catch these soft failures, if the leader  skips two heartbeat intervals, etcd will warn it failed to send a  heartbeat on time.
etcd  使用基于领导者的共识协议来实现一致的数据复制和日志执行。集群成员选举一个领导者，所有其他成员都成为追随者。当选的领导人必须定期向其追随者发送心跳，以保持其领导地位。如果在选举间隔内未收到检测信号，则追随者推断领导者失败并触发选举。如果一个领导人没有及时发出心跳，但仍在竞选，那么选举是虚假的，很可能是由于资源不足造成的。为了捕获这些软故障，如果领导者跳过了两个心跳间隔，etcd 将警告它未能按时发送心跳。

Usually this issue is caused by a slow disk. Before the leader sends heartbeats attached with metadata, it may need to persist the metadata to disk.  The disk could be experiencing contention among etcd and other  applications, or the disk is too simply slow (e.g., a shared virtualized disk). To rule out a slow disk from causing this warning, monitor [wal_fsync_duration_seconds](https://etcd.io/docs/v3.5/metrics/#disk) (p99 duration should be less than 10ms) to confirm the disk is  reasonably fast. If the disk is too slow, assigning a dedicated disk to  etcd or using faster disk will typically solve the problem. To tell  whether a disk is fast enough for etcd, a benchmarking tool such as [fio](https://github.com/axboe/fio) can be used. Read [here](https://www.ibm.com/cloud/blog/using-fio-to-tell-whether-your-storage-is-fast-enough-for-etcd) for an example.
通常，此问题是由磁盘速度较慢引起的。在 leader 发送附加元数据的检测信号之前，它可能需要将元数据保存到磁盘。磁盘可能在 etcd  和其他应用程序之间遇到争用，或者磁盘速度太慢（例如，共享虚拟化磁盘）。要排除导致此警告的慢速磁盘，请监视wal_fsync_duration_seconds（p99 持续时间应小于 10 毫秒）以确认磁盘速度相当快。如果磁盘太慢，将专用磁盘分配给 etcd  或使用更快的磁盘通常可以解决问题。要判断磁盘是否足够快，可以使用 fio 等基准测试工具。阅读此处的示例。

The second most common cause is CPU starvation. If monitoring of the  machine’s CPU usage shows heavy utilization, there may not be enough  compute capacity for etcd. Moving etcd to dedicated machine, increasing  process resource isolation with cgroups, or renicing the etcd server  process into a higher priority can usually solve the problem.
第二个最常见的原因是 CPU 匮乏。如果对计算机 CPU 使用率的监控显示使用率很高，则 etcd 可能没有足够的计算容量。将 etcd 移动到专用机器，使用  cgroups 增加进程资源隔离，或者将 etcd 服务器进程调整为更高的优先级通常可以解决问题。

A slow network can also cause this issue. If network metrics among the  etcd machines shows long latencies or high drop rate, there may not be  enough network capacity for etcd. Moving etcd members to a less  congested network will typically solve the problem. However, if the etcd cluster is deployed across data centers, long latency between members  is expected. For such deployments, tune the `heartbeat-interval` configuration to roughly match the round trip time between the machines, and the `election-timeout` configuration to be at least 5 * `heartbeat-interval`. See [tuning documentation](https://etcd.io/docs/v3.5/tuning/) for detailed information.
网络速度慢也可能导致此问题。如果 etcd 机器之间的网络指标显示较长的延迟或高丢弃率，则 etcd 可能没有足够的网络容量。将 etcd  成员移动到一个不那么拥挤的网络通常可以解决这个问题。但是，如果 etcd  集群跨数据中心部署，则成员之间预计会出现较长的延迟。对于此类部署，请调整 `heartbeat-interval` 配置以大致匹配计算机之间的往返时间，并且 `election-timeout` 配置至少为 5 * `heartbeat-interval` 。有关详细信息，请参阅优化文档。

If none of the above suggestions clear the warnings, please [open an issue](https://github.com/etcd-io/etcd/issues/new) with detailed logging, monitoring, metrics and optionally workload information.
如果上述建议均未清除警告，请打开一个问题，其中包含详细的日志记录、监控、指标和可选的工作负载信息。

### What does the etcd warning “snapshotting is taking more than x seconds to finish …” mean? etcd 警告“快照需要超过 x 秒才能完成......”意味 着？

etcd sends a snapshot of its complete key-value store to refresh slow followers and for [backups](https://etcd.io/docs/v3.5/op-guide/recovery/#snapshotting-the-keyspace). Slow snapshot transfer times increase MTTR; if the cluster is ingesting data with high throughput, slow followers may livelock by needing a new snapshot before finishing receiving a snapshot. To catch slow snapshot  performance, etcd warns when sending a snapshot takes more than thirty  seconds and exceeds the expected transfer time for a 1Gbps connection.
etcd 发送其完整键值存储的快照，以刷新慢速追随者和备份。较慢的快照传输时间会增加  MTTR;如果集群正在以高吞吐量摄取数据，则速度较慢的追随者可能会在完成接收快照之前需要新的快照来激活。为了捕获缓慢的快照性能，etcd  会在发送快照时间超过 30 秒且超过 1Gbps 连接的预期传输时间时发出警告。