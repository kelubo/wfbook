# etcd learner design etcd 学习器设计

Mitigating common challenges with membership reconfiguration
通过成员资格重新配置缓解常见挑战



# etcd Learner etcd 学习器

*Gyuho Lee (github.com/gyuho, Amazon Web Services, Inc.), Joe Betz (github.com/jpbetz, Google Inc.)
Gyuho Lee（github.com/gyuho，Amazon Web Services， Inc.），Joe Betz（github.com/jpbetz，Google Inc.）*

# Background 背景

Membership reconfiguration has been one of the biggest operational challenges. Let’s review common challenges.
成员资格重新配置一直是最大的运营挑战之一。让我们回顾一下常见的挑战。

### 1. New Cluster member overloads Leader 1. 新的集群成员重载 Leader

A newly joined etcd member starts with no data, thus demanding more  updates from leader until it catches up with leader’s logs. Then  leader’s network is more likely to be overloaded, blocking or dropping  leader heartbeats to followers. In such case, a follower may  election-timeout to start a new leader election. That is, a cluster with a new member is more vulnerable to leader election. Both leader  election and the subsequent update propagation to the new member are  prone to causing periods of cluster unavailability (see *Figure 1*).
新加入的 etcd 成员开始时没有数据，因此需要 leader 进行更多更新，直到它赶上 leader  的日志。然后，领导者的网络更有可能过载，阻塞或丢弃领导者的心跳给追随者。在这种情况下，追随者可能会选举超时以开始新的领导人选举。也就是说，具有新成员的集群更容易受到领导者选举的影响。leader 选举和随后向新成员的更新传播都容易导致集群不可用（参见图 1）。

![server-learner-figure-01](https://etcd.io/docs/v3.5/learning/img/server-learner-figure-01.png)

### 2. Network Partitions scenarios 2. 网络分区方案

What if network partition happens? It depends on leader partition. If the  leader still maintains the active quorum, the cluster would continue to  operate (see *Figure 2*).
如果发生网络分区怎么办？它取决于领导分区。如果领导者仍保持活动仲裁，则集群将继续运行（参见图 2）。

![server-learner-figure-02](https://etcd.io/docs/v3.5/learning/img/server-learner-figure-02.png)

#### 2.1 Leader isolation 2.1 引线隔离

What if the leader becomes isolated from the rest of the cluster? Leader  monitors progress of each follower. When leader loses connectivity from  the quorum, it reverts back to follower which will affect the cluster  availability (see *Figure 3*).
如果领导者与集群的其余部分隔离，该怎么办？领导者监控每个追随者的进度。当 leader 失去与仲裁的连接时，它会恢复为 follower，这将影响集群可用性（参见图 3）。

![server-learner-figure-03](https://etcd.io/docs/v3.5/learning/img/server-learner-figure-03.png)

When a new node is added to 3 node cluster, the cluster size becomes 4 and  the quorum size becomes 3. What if a new node had joined the cluster,  and then network partition happens? It depends on which partition the  new member gets located after partition.
将新节点添加到 3 节点群集时，群集大小将变为 4，仲裁大小将变为 3。如果新节点已加入集群，然后发生网络分区，该怎么办？这取决于新成员在分区后找到哪个分区。

#### 2.2 Cluster Split 3+1 2.2 集群拆分 3+1

If the new node happens to be located in the same partition as leader’s,  the leader still maintains the active quorum of 3. No leadership  election happens, and no cluster availability gets affected (see *Figure 4*).
如果新节点恰好与领导者的节点位于同一分区中，则领导者仍将保持 3 的活跃仲裁。不会发生领导选举，也不会影响集群可用性（参见图 4）。

![server-learner-figure-04](https://etcd.io/docs/v3.5/learning/img/server-learner-figure-04.png)

#### 2.3 Cluster Split 2+2 2.3 集群拆分 2+2

If the cluster is 2-and-2 partitioned, then neither of partition maintains the quorum of 3. In this case, leadership election happens (see *Figure 5*).
如果群集是 2 和 2 分区的，则两个分区都不会保持 3 的仲裁。在这种情况下，将进行领导选举（见图 5）。

![server-learner-figure-05](https://etcd.io/docs/v3.5/learning/img/server-learner-figure-05.png)

#### 2.4 Quorum Lost 2.4 法定人数丢失

What if network partition happens first, and then a new member gets added? A partitioned 3-node cluster already has one disconnected follower. When a new member is added, the quorum changes from 2 to 3. Now, this cluster  has only 2 active nodes out 4, thus losing quorum and starting a new  leadership election (see *Figure 6*).
如果先发生网络分区，然后添加新成员怎么办？分区的 3 节点集群已具有一个断开连接的从属节点。添加新成员时，仲裁将从 2 人更改为 3 人。现在，此集群在 4 个节点中只有 2 个活动节点，因此会失去仲裁并开始新的领导选举（参见图 6）。

![server-learner-figure-06](https://etcd.io/docs/v3.5/learning/img/server-learner-figure-06.png)

Since member add operation can change the size of quorum, it is always  recommended to “member remove” first to replace an unhealthy node.
由于成员添加操作可以更改仲裁的大小，因此始终建议先“成员删除”以替换运行状况不佳的节点。

Adding a new member to a 1-node cluster changes the quorum size to 2,  immediately causing a leader election when the previous leader finds out quorum is not active. This is because “member add” operation is a  2-step process where user needs to apply “member add” command first, and then starts the new node process (see *Figure 7*).
将新成员添加到 1 节点集群会将仲裁大小更改为 2，当前一个领导者发现仲裁未处于活动状态时，会立即导致领导者选举。这是因为“成员添加”操作是一个两步过程，用户需要先应用“成员添加”命令，然后启动新节点进程（参见图 7）。

![server-learner-figure-07](https://etcd.io/docs/v3.5/learning/img/server-learner-figure-07.png)

### 3. Cluster Misconfigurations 3. 集群配置错误

An even worse case is when an added member is misconfigured. Membership  reconfiguration is a two-step process: “etcdctl member add” and starting an etcd server process with the given peer URL. That is, “member add”  command is applied regardless of URL, even when the URL value is  invalid. If the first step is applied with invalid URLs, the second step cannot even start the new etcd. Once the cluster loses quorum, there is no way to revert the membership change (see *Figure 8*).
更糟糕的情况是添加的成员配置错误。成员资格重新配置分为两步：“etcdctl member add”和使用给定的对等 URL 启动 etcd 服务器进程。也就是说，无论 URL 如何，都会应用“member  add”命令，即使 URL 值无效也是如此。如果第一步使用无效的 URL 应用，则第二步甚至无法启动新的  etcd。一旦集群失去仲裁，就无法恢复成员身份更改（参见图 8）。

![server-learner-figure-08](https://etcd.io/docs/v3.5/learning/img/server-learner-figure-08.png)

Same applies to a multi-node cluster. For example, the cluster has two  members down (one is failed, the other is misconfigured) and two members up, but now it requires at least 3 votes to change the cluster  membership (see *Figure 9*).
这同样适用于多节点集群。例如，集群有两个成员关闭（一个失败，另一个配置错误）和两个成员启动，但现在至少需要 3 票才能更改集群成员身份（参见图 9）。

![server-learner-figure-09](https://etcd.io/docs/v3.5/learning/img/server-learner-figure-09.png)

As seen above, a simple misconfiguration can fail the whole cluster into  an inoperative state. In such case, an operator need manually recreate  the cluster with `etcd --force-new-cluster` flag. As etcd has become a mission-critical service for Kubernetes,  even the slightest outage may have significant impact on users. What can we better to make etcd such operations easier? Among other things,  leader election is most critical to cluster availability: Can we make  membership reconfiguration less disruptive by not changing the size of  quorum? Can a new node be idle, only requesting the minimum updates from leader, until it catches up? Can membership misconfiguration be always  reversible and handled in a more secure way (wrong member add command  run should never fail the cluster)? Should an user worry about network  topology when adding a new member? Can member add API work regardless of the location of nodes and ongoing network partitions?
如上所述，一个简单的错误配置可能会使整个集群陷入不工作状态。在这种情况下，操作员需要手动重新创建带有 `etcd --force-new-cluster` 标志的集群。由于 etcd 已成为 Kubernetes 的关键任务服务，即使是最轻微的中断也可能对用户产生重大影响。我们怎样才能更好地使  etcd  这样的操作更容易？除其他事项外，领导者选举对集群可用性最为关键：我们能否通过不更改仲裁大小来减少成员资格重新配置的破坏性？一个新节点是否可以处于空闲状态，只向领导者请求最少的更新，直到它赶上来？成员身份错误配置是否始终是可逆的，并以更安全的方式处理（错误的成员添加命令运行不应使群集失败）？用户在添加新成员时是否应该担心网络拓扑？无论节点和正在进行的网络分区的位置如何，成员添加 API 都可以工作吗？

# Raft Learner 木筏学习者

In order to mitigate such availability gaps in the previous section, [Raft §4.2.1](https://github.com/ongardie/dissertation/blob/master/stanford.pdf) introduces a new node state “Learner”, which joins the cluster as a **non-voting member** until it catches up to leader’s logs.
为了缓解上一节中的此类可用性差距，Raft §4.2.1 引入了一个新的节点状态“Learner”，它以无投票权成员的身份加入集群，直到它赶上领导者的日志。

## Features in v3.4 v3.4 中的功能

An operator should do the minimum amount of work possible to add a new learner node. `member add --learner` command to add a new learner, which joins cluster as a non-voting member but still receives all data from leader (see *Figure 10*).
操作员应尽可能少地完成添加新学习器节点的工作量。 `member add --learner` 命令添加新的学习器，该学习器以无投票权成员的身份加入集群，但仍从领导者接收所有数据（参见图 10）。

![server-learner-figure-10](https://etcd.io/docs/v3.5/learning/img/server-learner-figure-10.png)

When a learner has caught up with leader’s progress, the learner can be promoted to a voting member using `member promote` API, which then counts towards the quorum (see *Figure 11*).
当学习者赶上领导者的进度时，可以使用 `member promote` API 将学习者提升为投票成员，然后计入法定人数（参见图 11）。

![server-learner-figure-11](https://etcd.io/docs/v3.5/learning/img/server-learner-figure-11.png)

etcd server validates promote request to ensure its operational safety. Only after its log has caught up to leader’s can learner be promoted to a  voting member (see *Figure 12*).
etcd 服务器对 Promote 请求进行验证，以确保其操作安全。只有当其日志赶上领导者的日志后，学习者才能被提升为投票成员（参见图 12）。

![server-learner-figure-12](https://etcd.io/docs/v3.5/learning/img/server-learner-figure-12.png)

Learner only serves as a standby node until promoted: Leadership cannot be  transferred to learner. Learner rejects client reads and writes (client  balancer should not route requests to learner). Which means learner does not need issue Read Index requests to leader. Such limitation  simplifies the initial learner implementation in v3.4 release (see *Figure 13*).
学习者在升级之前仅充当备用节点：领导权不能转移给学习者。学习器拒绝客户端读取和写入（客户端平衡器不应将请求路由到学习器）。这意味着学习者不需要向领导者发出读取索引请求。这种限制简化了 v3.4 版本中的初始学习器实现（参见图 13）。

![server-learner-figure-13](https://etcd.io/docs/v3.5/learning/img/server-learner-figure-13.png)

In addition, etcd limits the total number of learners that a cluster can  have, and avoids overloading the leader with log replication. Learner  never promotes itself. While etcd provides learner status information  and safety checks, cluster operator must make the final decision whether to promote learner or not.
此外，etcd 限制了集群可以拥有的学习器总数，并避免了日志复制使领导者过载。学习者从不推销自己。虽然 etcd 提供学习者状态信息和安全检查，但集群运营商必须最终决定是否提升学习者。

## Proposed features for future releases 未来版本的建议功能

*Make learner state only and default*: Defaulting a new member state to learner will greatly improve  membership reconfiguration safety, because learner does not change the  size of quorum. Misconfiguration will always be reversible without  losing the quorum.
仅将学习者状态设为默认状态：将新成员状态默认为学习者将大大提高成员资格重新配置的安全性，因为学习器不会更改仲裁的大小。错误配置将始终是可逆的，而不会丢失仲裁。

*Make voting-member promotion fully automatic*: Once a learner catches up to leader’s logs, a cluster can automatically promote the learner. etcd requires certain thresholds to be defined by  the user, and once the requirements are satisfied, learner promotes  itself to a voting member. From a user’s perspective, “member add”  command would work the same way as today but with greater safety  provided by learner feature.
使投票成员晋升完全自动化：一旦学习者赶上了领导者的日志，集群就可以自动升级学习者。etcd 要求用户定义一定的阈值，一旦满足要求，学习者就会将自己提升为投票成员。从用户的角度来看，“成员添加”命令的工作方式与现在相同，但学习者功能提供了更高的安全性。

*Make learner standby failover node*: A learner joins as a standby node, and gets automatically promoted when the cluster availability is affected.
使学习者成为备用故障转移节点：学习者作为备用节点加入，并在集群可用性受到影响时自动升级。

*Make learner read-only*: A learner can serve as a read-only node that never gets promoted. In a  weak consistency mode, learner only receives data from leader and never  process writes. Serving reads locally without consensus overhead would  greatly decrease the workloads to leader but may serve stale data. In a  strong consistency mode, learner requests read index from leader to  serve latest data, but still rejects writes.
将学习器设置为只读：学习器可以充当永远不会升级的只读节点。在弱一致性模式下，学习器仅接收来自领导者的数据，从不处理写入。在没有共识开销的情况下在本地提供读取将大大减少领导者的工作量，但可能会提供过时的数据。在强一致性模式下，学习器请求从领导者读取索引以提供最新数据，但仍拒绝写入。

# Learner vs. Mirror Maker 学习者与镜子制作者

etcd implements “mirror maker” using watch API to continuously relay key  creates and updates to a separate cluster. Mirroring usually has low  latency overhead once it completes initial synchronization. Learner and  mirroring overlap in that both can be used to replicate existing data  for read-only. However, mirroring does not guarantee linearizability.  During network disconnects, previous key-values might have been  discarded, and clients are expected to verify watch responses for  correct ordering. Thus, there is no ordering guarantee in mirror. Use  mirror for minimum latency (e.g. cross data center) at the costs of  consistency. Use learner to retain all historical data and its ordering.
etcd 使用 watch API  实现“镜像制作器”，以持续将密钥创建和更新中继到单独的集群。镜像在完成初始同步后通常具有较低的延迟开销。学习器和镜像的重叠之处在于，两者都可用于以只读方式复制现有数据。但是，镜像并不能保证线性化。在网络断开连接期间，以前的键值可能已被丢弃，客户端应验证监视响应是否正确排序。因此，镜像中没有订购保证。使用镜像实现最小延迟（例如跨数据中心），但代价是一致性。使用 learner 保留所有历史数据及其排序。

# Appendix: Learner Implementation in v3.4 附录：v3.4 中的学习器实现

*Expose “Learner” node type to “MemberAdd” API.
向“MemberAdd”API 公开“Learner”节点类型。*

etcd client adds a flag to “MemberAdd” API for learner node. And etcd server handler applies membership change entry with `pb.ConfChangeAddLearnerNode` type. Once the command has been applied, a server joins the cluster with `etcd --initial-cluster-state=existing` flag. This learner node can neither vote nor count as quorum.
etcd 客户端为学习器节点的 “MemberAdd” API 添加了一个标志。etcd 服务器处理程序应用带有 `pb.ConfChangeAddLearnerNode` type 的成员资格更改条目。应用该命令后，服务器将使用 `etcd --initial-cluster-state=existing` flag 加入群集。此学习器节点既不能投票，也不能计为仲裁。

etcd server must not transfer leadership to learner, since it may still lag  behind and does not count as quorum. etcd server limits the number of  learners that cluster can have to one: the more learners we have, the  more data the leader has to propagate. Clients may talk to learner node, but learner rejects all requests other than serializable read and  member status API. This is for simplicity of initial implementation. In  the future, learner can be extended as a read-only server that  continuously mirrors cluster data. Client balancer must provide helper  function to exclude learner node endpoint. Otherwise, request sent to  learner may fail. Client sync member call should factor into learner  node type. So should client endpoints update call.
etcd 服务器不得将领导权转移给学习者，因为它可能仍然滞后并且不计入仲裁。etcd  服务器将集群可以拥有的学习器数量限制为一个：我们拥有的学习器越多，领导者必须传播的数据就越多。客户端可以与学习器节点通信，但学习器拒绝除可序列化读取和成员状态 API  之外的所有请求。这是为了简化初始实现。将来，学习器可以扩展为持续镜像集群数据的只读服务器。客户端均衡器必须提供帮助程序函数以排除学习器节点终结点。否则，发送给学习者的请求可能会失败。客户端同步成员调用应考虑学习器节点类型。客户端终结点更新调用也应如此。

`MemberList` and `MemberStatus` responses should indicate which node is learner.
 `MemberList` 响应 `MemberStatus` 应指示哪个节点是学习器。

*Add “MemberPromote” API. 添加“MemberPromote”API。*

Internally in Raft, second `MemberAdd` call to learner node promotes it to a voting member. Leader maintains  the progress of each follower and learner. If learner has not completed  its snapshot message, reject promote request. Only accept promote  request if and only if: The learner node is in a healthy state. The  learner is in sync with leader or the delta is within the threshold  (e.g. the number of entries to replicate to learner is less than 1/10 of snapshot count, which means it is less likely that even after promotion leader would not need send snapshot to the learner). All these logic  are hard-coded in `etcdserver` package and not configurable.
在 Raft 内部，对学习者节点的第二次 `MemberAdd` 调用将其提升为投票成员。领导者维护每个追随者和学习者的进步。如果学习者尚未完成其快照消息，请拒绝升级请求。仅当且仅当以下情况才接受升级请求：  学习器节点处于正常状态。学习者与领导者同步或增量在阈值内（例如，要复制给学习者的条目数小于快照计数的  1/10，这意味着即使在晋升领导者之后也不太可能不需要向学习者发送快照）。所有这些逻辑都是在封装中 `etcdserver` 硬编码的，不可配置。

# Reference 参考

- Original github issue: [etcd#9161](https://github.com/etcd-io/etcd/issues/9161)
  原始 github 问题：etcd#9161
- Use case: [etcd#3715](https://github.com/etcd-io/etcd/issues/3715) 使用案例：etcd#3715
- Use case: [etcd#8888](https://github.com/etcd-io/etcd/issues/8888) 用例：etcd#8888
- Use case: [etcd#10114](https://github.com/etcd-io/etcd/issues/10114) 用例：etcd#10114