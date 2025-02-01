# Managing etcd 管理 etcd

​        version 版本              



Kolla Ansible can manage the lifecycle of an etcd cluster and supports the following operations:
Kolla Ansible 可以管理 etcd 集群的生命周期，并支持以下操作：

- Bootstrapping a clean multi-node etcd cluster.
  引导一个干净的多节点 etcd 集群。
- Adding a new member to the etcd cluster.
  向 etcd 集群添加新成员。
- Optionally, automatically removing a deleted node from the etcd cluster.
  （可选）自动从 etcd 集群中删除已删除的节点。

It is highly recommended to read the operator documentation for the version of etcd deployed in the cluster.
强烈建议阅读集群中部署的 etcd 版本的 operator 文档。



 

Note 注意



Once an etcd cluster is bootstrapped, the etcd service takes most of its configuration from the etcd database itself.
一旦 etcd 集群被引导，etcd 服务就会从 etcd 数据库本身获取其大部分配置。

This pattern is very different from many other Kolla Ansible services, and is a source of confusion for operators unfamiliar with etcd.
这种模式与许多其他 Kolla Ansible 服务非常不同，对于不熟悉 etcd 的操作员来说，这是一个令人困惑的根源。

## Cluster vs. Node Bootstrapping 集群与节点引导 ¶

Kolla Ansible distinguishes between two forms of bootstrapping in an etcd cluster:
Kolla Ansible 区分了 etcd 集群中的两种引导形式：

- Bootstrapping multiple nodes at the same time to bring up a new cluster.
  同时引导多个节点以启动新集群。
- Bootstrapping a single node to add it to an existing cluster.
  引导单个节点以将其添加到现有集群中。

These corresponds to the `new` and `existing` parameters for `ETCD_INITIAL_CLUSTER_STATE` in the upstream documentation. Once an etcd node has completed bootstrap, the bootstrap configuration is ignored, even if it is changed.
这些对应于上游文档 `ETCD_INITIAL_CLUSTER_STATE` 中的 `new` 和 `existing` 参数。一旦 etcd 节点完成了引导，引导配置就会被忽略，即使它被更改了。

Kolla Ansible will decide to perform a new cluster bootstrap if it detects that there is no existing data on the etcd nodes. Otherwise it assumes that there is a healthy etcd cluster and it will add a new node to it.
如果 Kolla Ansible 检测到 etcd 节点上没有现有数据，它将决定执行新的集群引导程序。否则，它假定有一个健康的 etcd 集群，并且它将向其添加一个新节点。

## Forcing Bootstrapping 强制引导 ¶

Kolla Ansible looks for the `kolla_etcd` volume on the node. If this volume is available, it assumes that the bootstrap process has run on the node and the volume contains the required config.
Kolla Ansible 在节点上查找 `kolla_etcd` 卷。如果此卷可用，则假定引导进程已在节点上运行，并且该卷包含所需的配置。

However, if the process was interrupted (externally, or by an error), this volume might be misconfigured. In order to prevent data loss, manual intervention is required.
但是，如果进程中断（外部中断或错误中断），则此卷可能配置错误。为了防止数据丢失，需要手动干预。

Before retriggering bootstrap make sure that there is no valuable data on the volume. This could be because the node was not in service, or that the data is persisted elsewhere.
在重新触发引导程序之前，请确保卷上没有有价值的数据。这可能是因为节点未投入使用，或者数据保留在其他地方。

To retrigger a bootstrap (for either the cluster, or for a single node), remove the volume from all affected nodes by running:
要重新触发引导程序（对于集群或单个节点），请通过运行以下命令从所有受影响的节点中删除卷：

```
docker volume rm kolla_etcd
```

Rerunning Kolla Ansible will then trigger the appropriate workflow and either a blank cluster will be bootstrapped, or an empty member will be added to the existing cluster.
然后，重新运行 Kolla Ansible 将触发相应的工作流，并且将引导一个空白集群，或者将空成员添加到现有集群中。

## Manual Commands 手动命令 ¶

In order to manage etcd manually, the `etcdctl` command can be used inside the `etcd` container. This command has been set up with the appropriate environment variables for integrating with automation.
为了手动管理 etcd，可以在 `etcd` 容器内使用该 `etcdctl` 命令。此命令已使用适当的环境变量进行设置，以便与自动化集成。

`etcdctl` is configured with json output by default, you can override that if you are running it yourself:
 `etcdctl` 默认情况下配置了 json 输出，如果您自己运行它，则可以覆盖它：

```
list cluster members in a human-readable table
docker exec -it etcd etcdctl -w table member list
```

## Removing Dead Nodes 删除死节点 ¶

If `globals.yml` has the value `etcd_remove_deleted_members: "yes"` then etcd nodes that are not in the inventory will be removed from the etcd cluster.
如果 `globals.yml` 具有该值 `etcd_remove_deleted_members: "yes"` ，则不在清单中的 etcd 节点将从 etcd 集群中删除。

Any errors in the inventory can therefore cause unintended removal.
因此，库存中的任何错误都可能导致意外移除。

To manually remove a dead node from the etcd cluster, use the following commands:
要从 etcd 集群中手动删除死节点，请使用以下命令：

```
list cluster members and identify dead member
docker exec -it etcd etcdctl -w table member list
remove dead member
docker exec -it etcd etcdctl member remove MEMBER_ID_IN_HEX
```