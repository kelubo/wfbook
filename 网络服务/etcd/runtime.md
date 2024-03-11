# Design of runtime reconfiguration 运行时重新配置的设计

The design of etcd’s runtime reconfiguration commands
etcd 运行时重配置命令的设计



Runtime reconfiguration is one of the hardest and most error prone features in a distributed system, especially in a consensus based system like etcd.
运行时重配置是分布式系统中最难和最容易出错的功能之一，尤其是在像 etcd 这样基于共识的系统中。

Read on to learn about the design of etcd’s runtime reconfiguration commands and how we tackled these problems.
请继续阅读，了解 etcd 运行时重新配置命令的设计以及我们如何解决这些问题。

## Two phase config changes keep the cluster safe 两阶段配置更改可确保集群安全

In etcd, every runtime reconfiguration has to go through [two phases](https://etcd.io/docs/v3.5/op-guide/runtime-configuration/#add-a-new-member) for safety reasons. For example, to add a member, first inform the  cluster of the new configuration and then start the new member.
在 etcd 中，出于安全原因，每次运行时重新配置都必须经历两个阶段。例如，要添加成员，请先通知集群新配置，然后启动新成员。

Phase 1 - Inform cluster of new configuration
第 1 阶段 - 通知群集新配置

To add a member into an etcd cluster, make an API call to request a new  member to be added to the cluster. This is the only way to add a new  member into an existing cluster. The API call returns when the cluster  agrees on the configuration change.
要将成员添加到 etcd 集群中，请进行 API 调用以请求将新成员添加到集群中。这是将新成员添加到现有集群的唯一方法。当集群同意配置更改时，API 调用将返回。

Phase 2 - Start new member
第 2 阶段 - 开始新成员

To join the new etcd member into the existing cluster, specify the correct `initial-cluster` and set `initial-cluster-state` to `existing`. When the member starts, it will contact the existing cluster first and  verify the current cluster configuration matches the expected one  specified in `initial-cluster`. When the new member successfully starts, the cluster has reached the expected configuration.
要将新的 etcd 成员加入到现有集群中，请指定 correct `initial-cluster` 并设置为 `initial-cluster-state` `existing` 。当成员启动时，它将首先联系现有集群，并验证当前集群配置是否与 中 `initial-cluster` 指定的预期配置匹配。当新成员成功启动时，集群已达到预期的配置。

By splitting the process into two discrete phases users are forced to be  explicit regarding cluster membership changes. This actually gives users more flexibility and makes things easier to reason about. For example,  if there is an attempt to add a new member with the same ID as an  existing member in an etcd cluster, the action will fail immediately  during phase one without impacting the running cluster. Similar  protection is provided to prevent adding new members by mistake. If a  new etcd member attempts to join the cluster before the cluster has  accepted the configuration change, it will not be accepted by the  cluster.
通过将该过程拆分为两个离散的阶段，用户被迫明确说明群集成员身份的更改。这实际上为用户提供了更大的灵活性，并使事情更容易推理。例如，如果有人尝试添加与 etcd 集群中现有成员具有相同 ID  的新成员，则该操作将在第一阶段立即失败，而不会影响正在运行的集群。提供类似的保护，以防止错误地添加新成员。如果新的 etcd  成员在集群接受配置更改之前尝试加入集群，则集群将不会接受该成员。

Without the explicit workflow around cluster membership etcd would be  vulnerable to unexpected cluster membership changes. For example, if  etcd is running under an init system such as systemd, etcd would be  restarted after being removed via the membership API, and attempt to  rejoin the cluster on startup. This cycle would continue every time a  member is removed via the API and systemd is set to restart etcd after  failing, which is unexpected.
如果没有围绕集群成员身份的显式工作流，etcd 将容易受到意外的集群成员身份更改的影响。例如，如果 etcd 在 systemd 等 init 系统下运行，则 etcd 将在通过成员身份  API 删除后重新启动，并尝试在启动时重新加入集群。每次通过 API 删除成员并将 systemd 设置为在失败后重新启动 etcd  时，此循环将继续，这是出乎意料的。

We expect runtime reconfiguration to be an infrequent operation. We  decided to keep it explicit and user-driven to ensure configuration  safety and keep the cluster always running smoothly under explicit  control.
我们预计运行时重新配置将是一个不常见的操作。我们决定保持显式和用户驱动，以确保配置安全，并使集群始终在显式控制下平稳运行。

## Permanent loss of quorum requires new cluster 永久失去仲裁需要新的群集

If a cluster permanently loses a majority of its members, a new cluster  will need to be started from an old data directory to recover the  previous state.
如果集群永久丢失了其大部分成员，则需要从旧数据目录启动新集群以恢复以前的状态。

It is entirely possible to force removing the failed members from the  existing cluster to recover. However, we decided not to support this  method since it bypasses the normal consensus committing phase, which is unsafe. If the member to remove is not actually dead or force removed  through different members in the same cluster, etcd will end up with a  diverged cluster with same clusterID. This is very dangerous and hard to debug/fix afterwards.
完全可以强制从现有集群中删除失败的成员进行恢复。但是，我们决定不支持这种方法，因为它绕过了正常的共识提交阶段，这是不安全的。如果要删除的成员实际上不是死的，或者通过同一集群中的不同成员强制删除，etcd 最终会得到一个具有相同 clusterID 的发散集群。这是非常危险的，并且很难在事后进行调试/修复。

With a correct deployment, the possibility of permanent majority loss is  very low. But it is a severe enough problem that is worth special care.  We strongly suggest reading the [disaster recovery documentation](https://etcd.io/docs/v3.5/op-guide/recovery/) and preparing for permanent majority loss before putting etcd into production.
如果部署得当，永久多数损失的可能性非常低。但这是一个足够严重的问题，值得特别注意。我们强烈建议在将 etcd 投入生产之前阅读灾难恢复文档并做好永久多数损失的准备。

## Do not use public discovery service for runtime reconfiguration 不要使用公共发现服务进行运行时重新配置

The public discovery service should only be used for bootstrapping a  cluster. To join member into an existing cluster, use the runtime  reconfiguration API.
公共发现服务应仅用于引导群集。要将成员加入现有集群，请使用运行时重新配置 API。

The discovery service is designed for bootstrapping an etcd cluster in a  cloud environment, when the IP addresses of all the members are not  known beforehand. After successfully bootstrapping a cluster, the IP  addresses of all the members are known. Technically, the discovery  service should no longer be needed.
发现服务设计用于在云环境中引导 etcd 集群，当所有成员的 IP 地址事先未知时。成功引导集群后，所有成员的 IP 地址都是已知的。从技术上讲，应该不再需要发现服务。

It seems that using public discovery service is a convenient way to do  runtime reconfiguration, after all discovery service already has all the cluster configuration information. However relying on public discovery  service brings troubles:
使用公共发现服务似乎是进行运行时重新配置的便捷方法，毕竟发现服务已经拥有所有集群配置信息。但是，依赖公共发现服务会带来麻烦：

1. it introduces external dependencies for the entire life-cycle of the  cluster, not just bootstrap time. If there is a network issue between  the cluster and public discovery service, the cluster will suffer from  it.
   它为集群的整个生命周期引入了外部依赖关系，而不仅仅是引导时间。如果群集和公共发现服务之间存在网络问题，则群集将受到该问题的影响。
2. public discovery service must reflect correct runtime configuration of the  cluster during its life-cycle. It has to provide security mechanisms to  avoid bad actions, and it is hard.
   公共发现服务必须在群集的生命周期内反映群集的正确运行时配置。它必须提供安全机制来避免不良行为，这很难。
3. public discovery service has to keep tens of thousands of cluster  configurations. Our public discovery service backend is not ready for  that workload.
   公共发现服务必须保留数以万计的群集配置。我们的公共发现服务后端尚未为该工作负载做好准备。

To have a discovery service that supports runtime reconfiguration, the best choice is to build a private one.
要获得支持运行时重新配置的发现服务，最好的选择是构建一个私有服务。

# Runtime reconfiguration 运行时重新配置

etcd incremental runtime reconfiguration support
etcd 增量运行时重配置支持



etcd comes with support for incremental runtime reconfiguration, which  allows users to update the membership of the cluster at run time.
etcd 支持增量运行时重新配置，允许用户在运行时更新集群的成员身份。

Reconfiguration requests can only be processed when a majority of cluster members are functioning. It is **highly recommended** to always have a cluster size greater than two in production. It is  unsafe to remove a member from a two member cluster. The majority of a  two member cluster is also two. If there is a failure during the removal process, the cluster might not be able to make progress and need to [restart from majority failure](https://etcd.io/docs/v3.5/op-guide/runtime-configuration/#restart-cluster-from-majority-failure).
只有当大多数集群成员正常工作时，才能处理重新配置请求。强烈建议在生产环境中始终具有大于 2 的群集大小。从两个成员群集中删除成员是不安全的。两个成员集群中的大多数也是两个。如果在删除过程中出现故障，群集可能无法取得进展，需要从大多数故障重新启动。

To better understand the design behind runtime reconfiguration, please read [the runtime reconfiguration document](https://etcd.io/docs/v3.5/op-guide/runtime-reconf-design/).
为了更好地理解运行时重新配置背后的设计，请阅读运行时重新配置文档。

## Reconfiguration use cases 重新配置用例

This section will walk through some common reasons for reconfiguring a  cluster. Most of these reasons just involve combinations of adding or  removing a member, which are explained below under [Cluster Reconfiguration Operations](https://etcd.io/docs/v3.5/op-guide/runtime-configuration/#cluster-reconfiguration-operations).
本部分将介绍重新配置群集的一些常见原因。其中大多数原因仅涉及添加或删除成员的组合，这些组合在下面的群集重新配置操作下进行了说明。

### Cycle or upgrade multiple machines 循环或升级多台机器

If multiple cluster members need to move due to planned maintenance  (hardware upgrades, network downtime, etc.), it is recommended to modify members one at a time.
如果由于计划内维护（硬件升级、网络宕机等）需要移动多个集群成员，建议一次修改一个成员。

It is safe to remove the leader, however there is a brief period of  downtime while the election process takes place. If the cluster holds  more than 50MB of v2 data, it is recommended to [migrate the member’s data directory](https://etcd.io/docs/v2.3/admin_guide/#member-migration).
罢免领导人是安全的，但是在选举过程中会有短暂的停机时间。如果集群的 v2 数据超过 50MB，建议迁移成员的数据目录。

### Change the cluster size 更改群集大小

Increasing the cluster size can enhance [failure tolerance](https://etcd.io/docs/v2.3/admin_guide/#fault-tolerance-table) and provide better read performance. Since clients can read from any  member, increasing the number of members increases the overall  serialized read throughput.
增加簇大小可以增强容错能力并提供更好的读取性能。由于客户端可以从任何成员读取数据，因此增加成员数会增加整体序列化读取吞吐量。

Decreasing the cluster size can improve the write performance of a cluster, with a trade-off of decreased resilience. Writes into the cluster are  replicated to a majority of members of the cluster before considered  committed. Decreasing the cluster size lowers the majority, and each  write is committed more quickly.
减小集群大小可以提高集群的写入性能，但需要权衡降低弹性。在被视为已提交之前，对群集的写入将复制到群集的大多数成员。减小簇大小会降低大多数写入速度，并且每次写入的提交速度更快。

### Replace a failed machine 更换故障计算机

If a machine fails due to hardware failure, data directory corruption, or  some other fatal situation, it should be replaced as soon as possible.  Machines that have failed but haven’t been removed adversely affect the  quorum and reduce the tolerance for an additional failure.
如果计算机由于硬件故障、数据目录损坏或其他致命情况而出现故障，应尽快更换。发生故障但尚未删除的计算机会对仲裁产生负面影响，并降低对其他故障的容忍度。

To replace the machine, follow the instructions for [removing the member](https://etcd.io/docs/v3.5/op-guide/runtime-configuration/#remove-a-member) from the cluster, and then [add a new member](https://etcd.io/docs/v3.5/op-guide/runtime-configuration/#add-a-new-member) in its place. If the cluster holds more than 50MB, it is recommended to [migrate the failed member’s data directory](https://etcd.io/docs/v2.3/admin_guide/#member-migration) if it is still accessible.
若要更换计算机，请按照说明从群集中删除成员，然后在其位置添加新成员。如果集群容量超过 50MB，建议迁移故障成员的数据目录（如果仍可访问）。

### Restart cluster from majority failure 从多数故障中重新启动群集

If the majority of the cluster is lost or all of the nodes have changed IP addresses, then manual action is necessary to recover safely. The basic steps in the recovery process include [creating a new cluster using the old data](https://etcd.io/docs/v3.5/op-guide/recovery), forcing a single member to act as the leader, and finally using runtime configuration to [add new members](https://etcd.io/docs/v3.5/op-guide/runtime-configuration/#add-a-new-member) to this new cluster one at a time.
如果群集的大部分丢失或所有节点都更改了 IP 地址，则需要手动操作才能安全恢复。恢复过程中的基本步骤包括使用旧数据创建新集群，强制单个成员充当领导者，最后使用运行时配置一次向此新集群添加一个新成员。

### Recover cluster from minority failure 从少数故障中恢复群集

If a specific member is lost, then it is equivalent to replacing a failed machine. The steps are mentioned in [Replace a failed machine](https://etcd.io/docs/v3.5/op-guide/runtime-configuration/#replace-a-failed-machine).
如果某个特定成员丢失，则相当于更换故障计算机。更换故障计算机中提到了这些步骤。

## Cluster reconfiguration operations 群集重新配置操作

With these use cases in mind, the involved operations can be described for each.
考虑到这些用例，可以针对每个用例描述所涉及的操作。

Before making any change, a simple majority (quorum) of etcd members must be  available. This is essentially the same requirement for any kind of  write to etcd.
在进行任何更改之前，etcd 成员的简单多数（法定人数）必须可用。这与任何类型的写入 etcd 的要求基本相同。

All changes to the cluster must be done sequentially:
对群集的所有更改都必须按顺序完成：

- To update a single member peerURLs, issue an update operation
  若要更新单个成员 peerURL，请发出更新操作
- To replace a healthy single member, remove the old member then add a new member
  要替换正常运行的单个成员，请删除旧成员，然后添加新成员
- To increase from 3 to 5 members, issue two add operations
  若要将成员从 3 个增加到 5 个，请发出两个添加操作
- To decrease from 5 to 3, issue two remove operations
  若要从 5 个减少到 3，请执行两个删除操作

All of these examples use the `etcdctl` command line tool that ships with etcd. To change membership without `etcdctl`, use the [v2 HTTP members API](https://etcd.io/docs/v2.3/members_api/) or the [v3 gRPC members API](https://etcd.io/docs/v3.5/dev-guide/api_reference_v3/).
所有这些示例都使用 etcd 附带 `etcdctl` 的命令行工具。若要在不使用 `etcdctl` 的情况下更改成员身份，请使用 v2 HTTP 成员 API 或 v3 gRPC 成员 API。

### Update a member 更新成员

#### Update advertise client URLs 更新播发客户端 URL

To update the advertise client URLs of a member, simply restart that member with updated client urls flag (`--advertise-client-urls`) or environment variable (`ETCD_ADVERTISE_CLIENT_URLS`). The restarted member will self publish the updated URLs. A wrongly  updated client URL will not affect the health of the etcd cluster.
要更新成员的播发客户端 URL，只需使用更新的客户端 url 标志 （ `--advertise-client-urls` ） 或环境变量 （ ） 重新启动该成员 `ETCD_ADVERTISE_CLIENT_URLS` 。重新启动的成员将自行发布更新的 URL。错误更新的客户端 URL 不会影响 etcd 集群的运行状况。

#### Update advertise peer URLs 更新播发对等 URL

To update the advertise peer URLs of a member, first update it explicitly  via member command and then restart the member. The additional action is required since updating peer URLs changes the cluster wide  configuration and can affect the health of the etcd cluster.
要更新成员的通告对等 URL，请先通过 member 命令显式更新它，然后重新启动该成员。由于更新对等 URL 会更改集群范围的配置，并且可能会影响 etcd 集群的运行状况，因此需要执行其他操作。

To update the advertise peer URLs, first find the target member’s ID. To list all members with `etcdctl`:
若要更新播发对等 URL，请首先找到目标成员的 ID。要列出具有以下命令 `etcdctl` 的所有成员：

```sh
$ etcdctl member list
6e3bd23ae5f1eae0: name=node2 peerURLs=http://localhost:23802 clientURLs=http://127.0.0.1:23792
924e2e83e93f2560: name=node3 peerURLs=http://localhost:23803 clientURLs=http://127.0.0.1:23793
a8266ecf031671f3: name=node1 peerURLs=http://localhost:23801 clientURLs=http://127.0.0.1:23791
```

This example will `update` a8266ecf031671f3 member ID and change its peerURLs value to `http://10.0.1.10:2380`:
此示例将 `update` a8266ecf031671f3 成员 ID 并将其 peerURLs 值更改为 `http://10.0.1.10:2380` ：

```sh
$ etcdctl member update a8266ecf031671f3 --peer-urls=http://10.0.1.10:2380
Updated member with ID a8266ecf031671f3 in cluster
```

### Remove a member 删除成员

Suppose the member ID to remove is a8266ecf031671f3. Use the `remove` command to perform the removal:
假设要删除的成员 ID 是 a8266ecf031671f3。使用以下 `remove` 命令执行删除：

```sh
$ etcdctl member remove a8266ecf031671f3
Removed member a8266ecf031671f3 from cluster
```

The target member will stop itself at this point and print out the removal in the log:
此时，目标成员将自行停止，并在日志中打印出删除内容：

```
etcd: this member has been permanently removed from the cluster. Exiting.
```

It is safe to remove the leader, however the cluster will be inactive  while a new leader is elected. This duration is normally the period of  election timeout plus the voting process.
删除领导者是安全的，但是在选举新领导者时，集群将处于非活动状态。此持续时间通常是选举超时时间加上投票过程。

### Add a new member 添加新成员

Adding a member is a two step process:
添加成员的过程分为两个步骤：

- Add the new member to the cluster via the [HTTP members API](https://etcd.io/docs/v2.3/members_api/), the [gRPC members API](https://etcd.io/docs/v3.5/dev-guide/api_reference_v3/), or the `etcdctl member add` command.
  通过 HTTP 成员 API、gRPC 成员 API 或 `etcdctl member add` 命令将新成员添加到集群。
- Start the new member with the new cluster configuration, including a list of  the updated members (existing members + the new member).
  使用新的集群配置启动新成员，包括更新的成员（现有成员 + 新成员）的列表。

`etcdctl` adds a new member to the cluster by specifying the member’s [name](https://etcd.io/docs/v3.5/op-guide/configuration#member) and [advertised peer URLs](https://etcd.io/docs/v3.5/op-guide/configuration#clustering):
 `etcdctl` 通过指定成员的名称和播发的对等 URL 向集群添加新成员：

```sh
$ etcdctl member add infra3 --peer-urls=http://10.0.1.13:2380
added member 9bf1b35fc7761a23 to cluster

ETCD_NAME="infra3"
ETCD_INITIAL_CLUSTER="infra0=http://10.0.1.10:2380,infra1=http://10.0.1.11:2380,infra2=http://10.0.1.12:2380,infra3=http://10.0.1.13:2380"
ETCD_INITIAL_CLUSTER_STATE=existing
```

`etcdctl` has informed the cluster about the new member and printed out the  environment variables needed to successfully start it. Now start the new etcd process with the relevant flags for the new member:
 `etcdctl` 已将新成员通知集群，并打印出成功启动该成员所需的环境变量。现在使用新成员的相关标志开始新的 etcd 进程：

```sh
$ export ETCD_NAME="infra3"
$ export ETCD_INITIAL_CLUSTER="infra0=http://10.0.1.10:2380,infra1=http://10.0.1.11:2380,infra2=http://10.0.1.12:2380,infra3=http://10.0.1.13:2380"
$ export ETCD_INITIAL_CLUSTER_STATE=existing
$ etcd --listen-client-urls http://10.0.1.13:2379 --advertise-client-urls http://10.0.1.13:2379 --listen-peer-urls http://10.0.1.13:2380 --initial-advertise-peer-urls http://10.0.1.13:2380 --data-dir %data_dir%
```

The new member will run as a part of the cluster and immediately begin catching up with the rest of the cluster.
新成员将作为集群的一部分运行，并立即开始追赶集群的其余部分。

If adding multiple members the best practice is to configure a single  member at a time and verify it starts correctly before adding more new  members. If adding a new member to a 1-node cluster, the cluster cannot  make progress before the new member starts because it needs two members  as majority to agree on the consensus. This behavior only happens  between the time `etcdctl member add` informs the cluster about the new member and the new member successfully establishing a connection to the existing one.
如果添加多个成员，最佳做法是一次配置一个成员，并在添加更多新成员之前验证它是否正确启动。如果将新成员添加到 1  节点集群，则集群在新成员启动之前无法取得进展，因为它需要两个成员作为多数成员才能达成共识。此行为仅在通知集群有关新成员和新成员成功建立与现有成员的连接之间 `etcdctl member add` 发生。

#### Add a new member as learner 将新成员添加为学习者

Starting from v3.4, etcd supports adding a new member as learner / non-voting member. The motivation and design can be found in [design doc](https://etcd.io/docs/v3.5/learning/design-learner). In order to make the process of adding a new member safer, and to reduce cluster downtime when the new member is added, it is recommended that the new member is added to cluster as a learner until it catches up. This can be described as a three step process:
从 v3.4 开始，etcd 支持添加新成员作为学习者/无投票权成员。动机和设计可以在设计文档中找到。为了使添加新成员的过程更安全，并减少添加新成员时的集群停机时间，建议将新成员作为学习者添加到集群中，直到它赶上为止。这可以描述为一个三步过程：

- Add the new member as learner via [gRPC members API](https://etcd.io/docs/v3.5/dev-guide/api_reference_v3/) or the `etcdctl member add --learner` command.
  通过 gRPC members API 或 `etcdctl member add --learner` 命令将新成员添加为学习者。
- Start the new member with the new cluster configuration, including a list of  the updated members (existing members + the new member). This step is exactly the same as before.
  使用新的集群配置启动新成员，包括更新的成员（现有成员 + 新成员）的列表。此步骤与之前完全相同。
- Promote the newly added learner to voting member via [gRPC members API](https://etcd.io/docs/v3.5/dev-guide/api_reference_v3/) or the `etcdctl member promote` command. etcd server validates promote request to ensure its operational safety. Only after its raft log has caught up to leader’s can learner be promoted to a voting member. If a learner member has not caught up to leader’s raft log, member promote request will fail (see [error cases when promoting a member](https://etcd.io/docs/v3.5/op-guide/runtime-configuration/#error-cases-when-promoting-a-learner-member) section for more details). In this case, user should wait and retry later.
  通过 gRPC members API 或 `etcdctl member promote` 命令将新添加的学习者提升为投票成员。etcd 服务器对 Promote  请求进行验证，以确保其操作安全。只有当它的木筏日志赶上领导者的日志后，学习者才能晋升为投票成员。如果学习者成员没有赶上领导者的 raft  日志，则成员升级请求将失败（有关详细信息，请参阅升级成员时的错误情况部分）。在这种情况下，用户应等待，稍后重试。

In v3.4, etcd server limits the number of learners that cluster can have to one. The main consideration is to limit the extra workload on leader due to propagating data from leader to learner.
在 v3.4 中，etcd server 将集群可以拥有的学习器数量限制为 1 个。主要考虑因素是限制领导者的额外工作量，因为数据从领导者传播到学习者。

Use `etcdctl member add` with flag `--learner` to add new member to cluster as learner.
使用 `etcdctl member add` with 标志 `--learner` 将新成员作为学习者添加到集群。

```sh
$ etcdctl member add infra3 --peer-urls=http://10.0.1.13:2380 --learner
Member 9bf1b35fc7761a23 added to cluster a7ef944b95711739

ETCD_NAME="infra3"
ETCD_INITIAL_CLUSTER="infra0=http://10.0.1.10:2380,infra1=http://10.0.1.11:2380,infra2=http://10.0.1.12:2380,infra3=http://10.0.1.13:2380"
ETCD_INITIAL_CLUSTER_STATE=existing
```

After new etcd process is started for the newly added learner member, use `etcdctl member promote` to promote learner to voting member.
为新添加的学习者成员启动新的 etcd 流程后，用于 `etcdctl member promote` 将学习者提升为投票成员。

```
$ etcdctl member promote 9bf1b35fc7761a23
Member 9e29bbaa45d74461 promoted in cluster a7ef944b95711739
```

#### Error cases when adding members 添加成员时出现错误的情况

In the following case a new host is not included in the list of enumerated nodes. If this is a new cluster, the node must be added to the list of  initial cluster members.
在以下情况下，枚举节点列表中不包括新主机。如果这是一个新集群，则必须将节点添加到初始集群成员列表中。

```sh
$ etcd --name infra3 \
  --initial-cluster infra0=http://10.0.1.10:2380,infra1=http://10.0.1.11:2380,infra2=http://10.0.1.12:2380 \
  --initial-cluster-state existing
etcdserver: assign ids error: the member count is unequal
exit 1
```

In this case, give a different address (10.0.1.14:2380) from the one used to join the cluster (10.0.1.13:2380):
在这种情况下，请提供与用于加入群集的地址 （10.0.1.13：2380） 不同的地址 （10.0.1.14：2380）：

```sh
$ etcd --name infra4 \
  --initial-cluster infra0=http://10.0.1.10:2380,infra1=http://10.0.1.11:2380,infra2=http://10.0.1.12:2380,infra4=http://10.0.1.14:2380 \
  --initial-cluster-state existing
etcdserver: assign ids error: unmatched member while checking PeerURLs
exit 1
```

If etcd starts using the data directory of a removed member, etcd  automatically exits if it connects to any active member in the cluster:
如果 etcd 开始使用已删除成员的数据目录，则 etcd 在连接到集群中的任何活动成员时会自动退出：

```sh
$ etcd
etcd: this member has been permanently removed from the cluster. Exiting.
exit 1
```

#### Error cases when adding a learner member 添加学习者成员时出现错误情况

Cannot add learner to cluster if the cluster already has 1 learner (v3.4).
如果集群已有 1 个学习器，则无法将学习器添加到集群 （v3.4）。

```
$ etcdctl member add infra4 --peer-urls=http://10.0.1.14:2380 --learner
Error: etcdserver: too many learner members in cluster
```

#### Error cases when promoting a learner member 升级学习者成员时出现错误情况

Learner can only be promoted to voting member if it is in sync with leader.
学习者只有在与领导者同步的情况下才能晋升为投票成员。

```
$ etcdctl member promote 9bf1b35fc7761a23
Error: etcdserver: can only promote a learner member which is in sync with leader
```

Promoting a member that is not a learner will fail.
提升非学习者的成员将失败。

```
$ etcdctl member promote 9bf1b35fc7761a23
Error: etcdserver: can only promote a learner member
```

Promoting a member that does not exist in cluster will fail.
提升群集中不存在的成员将失败。

```
$ etcdctl member promote 12345abcde
Error: etcdserver: member not found
```

### Strict reconfiguration check mode (`-strict-reconfig-check`) 严格重配置检查模式 （ `-strict-reconfig-check` ）

As described in the above, the best practice of adding new members is to  configure a single member at a time and verify it starts correctly  before adding more new members. This step by step approach is very  important because if newly added members is not configured correctly  (for example the peer URLs are incorrect), the cluster can lose quorum.  The quorum loss happens since the newly added member are counted in the  quorum even if that member is not reachable from other existing members. Also quorum loss might happen if there is a connectivity issue or there are operational issues.
如上所述，添加新成员的最佳做法是一次配置一个成员，并在添加更多新成员之前验证它是否正确启动。这种循序渐进的方法非常重要，因为如果未正确配置新添加的成员（例如，对等 URL  不正确），群集可能会失去仲裁。仲裁丢失是因为新添加的成员被计入仲裁中，即使其他现有成员无法访问该成员。此外，如果存在连接问题或操作问题，则可能会发生仲裁丢失。

For avoiding this problem, etcd provides an option `-strict-reconfig-check`. If this option is passed to etcd, etcd rejects reconfiguration requests if the number of started members will be less than a quorum of the  reconfigured cluster.
为了避免这个问题，etcd 提供了一个选项 `-strict-reconfig-check` 。如果将此选项传递给 etcd，则如果启动的成员数将小于重新配置集群的仲裁，则 etcd 将拒绝重新配置请求。

It is enabled by default.
默认情况下，它处于启用状态。