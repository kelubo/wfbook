# Apache ZooKeeper

[TOC]

## 概述

Apache ZooKeeper 致力于开发和维护一个开源服务器，以实现高度可靠的分布式协调。

ZooKeeper  是一种面向分布式应用的高性能协调服务。它在一个简单的界面中公开了常见服务（如命名、配置管理、同步和组服务），因此您不必从头开始编写它们。您可以现成使用它来实施共识、组管理、领导者选举和在线状态协议。您可以根据自己的特定需求在此基础上进行构建。

ZooKeeper 是一个集中式服务，用于维护配置信息，命名，提供分布式同步和提供群组服务。分布式应用程序以某种形式使用所有这些类型的服务。每次实现它们时，都会进行大量工作来修复不可避免的错误和竞争条件。由于实现这类服务的困难，应用程序最初通常会忽略它们，这使得它们在出现更改时变得脆弱，并且难以管理。即使正确地执行了这些服务，这些服务的不同实现也会导致部署应用程序时的管理复杂性。

ZooKeeper is a high-performance coordination service for distributed  applications.  It exposes common services - such as naming,  configuration management, synchronization, and group services - in a  simple interface so you don't have to write them from scratch.  You can  use it off-the-shelf to implement consensus, group management, leader  election, and presence protocols. And you can build on it for your own,  specific needs.

ZooKeeper是一个针对分布式应用程序的高性能协调服务。它在一个简单的接口中公开了常见的服务，例如命名、配置管理、同步和组服务，因此您不必从头开始编写它们。您可以使用它来实现共识、组管理、领导者选举和存在协议。你可以根据自己的具体需要来构建它。

Apache ZooKeeper 致力于开发和维护一个开源服务器，以实现高度可靠的分布式协调。Apache ZooKeeper 是 Apache 软件基金会的一个开源志愿者项目。

ZooKeeper is a centralized service for maintaining configuration  information, naming, providing distributed synchronization, and  providing group services. All of these kinds of services are used in  some form or another by distributed applications. Each time they are  implemented there is a lot of work that goes into fixing the bugs and  race conditions that are inevitable. Because of the difficulty of  implementing these kinds of services, applications initially usually  skimp on them, which make them brittle in the presence of change and  difficult to manage. Even when done correctly, different implementations of these services lead to management complexity when the applications  are deployed.

ZooKeeper 是一个集中式服务，用于维护配置信息，命名，提供分布式同步和提供组服务。分布式应用程序以某种形式使用所有这些类型的服务。每次实现它们时，都有大量的工作要做，以修复不可避免的bug和竞争条件。由于实现这类服务的困难，应用程序最初通常会忽略它们，这使得它们在出现更改时变得脆弱，并且难以管理。即使正确地执行了这些服务，这些服务的不同实现也会导致部署应用程序时的管理复杂性。

It exposes a simple set of primitives that distributed  applications can build upon to implement higher level services for  synchronization, configuration maintenance, and groups and naming. It is designed to be easy to program to, and uses a data model styled after  the familiar directory tree structure of file systems. It runs in Java  and has bindings for both Java and C.
ZooKeeper  是一种用于分布式应用程序的分布式开源协调服务。它公开了一组简单的原语，分布式应用程序可以基于这些原语进行构建，以实现更高级别的同步、配置维护以及组和命名服务。它设计为易于编程，并使用以熟悉的文件系统目录树结构为样式的数据模型。它在 Java 中运行，并且具有 Java 和 C 的绑定。

Coordination services are notoriously hard to get right. They are especially prone  to errors such as race conditions and deadlock. The motivation behind  ZooKeeper is to relieve distributed applications the responsibility of  implementing coordination services from scratch.
众所周知，协调服务很难做好。它们特别容易出现争用条件和死锁等错误。ZooKeeper 背后的动机是减轻分布式应用程序从头开始实施协调服务的责任。

## 设计目标

ZooKeeper allows distributed processes to coordinate with each other  through a shared hierarchical namespace which is organized similarly to a standard file system. The namespace consists of data registers - called znodes, in ZooKeeper parlance - and these are similar to files and  directories. Unlike a typical file system, which is designed for  storage, ZooKeeper data is kept in-memory, which means ZooKeeper can  achieve high throughput and low latency numbers.
**ZooKeeper 很简单。**ZooKeeper 允许分布式进程通过共享的分层命名空间相互协调，该命名空间的组织方式类似于标准文件系统。命名空间由数据寄存器（在 ZooKeeper 中称为  znodes）组成，这些寄存器类似于文件和目录。与专为存储而设计的典型文件系统不同，ZooKeeper 数据保存在内存中，这意味着  ZooKeeper 可以实现高吞吐量和低延迟数字。

The ZooKeeper implementation puts a premium on high performance, highly  available, strictly ordered access. The performance aspects of ZooKeeper means it can be used in large, distributed systems. The reliability  aspects keep it from being a single point of failure. The strict  ordering means that sophisticated synchronization primitives can be  implemented at the client.
ZooKeeper 实现非常重视高性能、高可用性、严格排序的访问。ZooKeeper 的性能方面意味着它可以在大型分布式系统中使用。可靠性方面使其不会成为单点故障。严格的 ordering 意味着可以在 Client 端实现复杂的同步原语。

**ZooKeeper is replicated.** Like the distributed processes it coordinates, ZooKeeper itself is  intended to be replicated over a set of hosts called an ensemble.
**复制 ZooKeeper。** 与它协调的分布式进程一样，ZooKeeper 本身旨在通过一组称为 ensemble 的主机进行复制。

 ![](../../Image/z/zkservice.jpg)

They maintain an in-memory image of state, along with a  transaction logs and snapshots in a persistent store.
组成 ZooKeeper 服务的服务器必须都彼此了解。它们在持久存储中维护状态的内存映像，以及事务日志和快照。只要大多数服务器都可用，ZooKeeper 服务就会可用。

客户端连接到单个 ZooKeeper 服务器。客户端维护一个 TCP 连接，通过该连接发送请求、获取响应、获取监视事件并发送检测信号。如果与服务器的 TCP 连接中断，则客户端将连接到其他服务器。

**ZooKeeper is ordered.** ZooKeeper stamps each update with a number that reflects the order of  all ZooKeeper transactions. Subsequent operations can use the order to  implement higher-level abstractions, such as synchronization primitives.
**ZooKeeper 已订购。**ZooKeeper 使用反映所有 ZooKeeper 事务顺序的数字标记每个更新。后续作可以使用 order 来实现更高级别的抽象，例如同步原语。

**ZooKeeper is fast.** It is especially fast in "read-dominant" workloads. ZooKeeper  applications run on thousands of machines, and it performs best where  reads are more common than writes, at ratios of around 10:1.
**ZooKeeper 速度很快。** 它在 “read-dominant” 工作负载中特别快。ZooKeeper 应用程序在数千台计算机上运行，在读取比写入更常见的情况下，它的性能最佳，比率约为 10：1。



### Data model and the hierarchical namespace 数据模型和分层命名空间

The namespace provided by ZooKeeper is much like that of a standard file  system. A name is a sequence of path elements separated by a slash (/).  Every node in ZooKeeper's namespace is identified by a path.
ZooKeeper 提供的命名空间与标准文件系统的命名空间非常相似。名称是由斜杠 （/） 分隔的 path 元素序列。ZooKeeper 命名空间中的每个节点都由路径标识。

#### ZooKeeper's Hierarchical Namespace ZooKeeper 的分层命名空间

![ZooKeeper's Hierarchical Namespace](https://zookeeper.apache.org/doc/r3.9.3/images/zknamespace.jpg)



### Nodes and ephemeral nodes 节点和临时节点

Unlike standard file systems, each node in a ZooKeeper namespace can have data associated with it as well as children. It is like having a file-system that allows a file to also be a directory. (ZooKeeper was designed to  store coordination data: status information, configuration, location  information, etc., so the data stored at each node is usually small, in  the byte to kilobyte range.) We use the term *znode* to make it clear that we are talking about ZooKeeper data nodes.
与标准文件系统不同，ZooKeeper 命名空间中的每个节点都可以具有与其关联的数据以及子节点。这就像拥有一个允许文件也是目录的文件系统。（ZooKeeper  旨在存储协调数据：状态信息、配置、位置信息等，因此存储在每个节点的数据通常很小，在 byte 到 kb 范围内。我们使用术语 *znode* 来清楚地表明我们谈论的是 ZooKeeper 数据节点。

Znodes maintain a stat structure that includes version numbers for data  changes, ACL changes, and timestamps, to allow cache validations and  coordinated updates. Each time a znode's data changes, the version  number increases. For instance, whenever a client retrieves data it also receives the version of the data.
Znodes 维护一个 stat 结构，其中包括数据更改、ACL 更改和时间戳的版本号，以允许缓存验证和协调更新。每次 znode 的数据发生变化时，版本号都会增加。例如，每当客户端检索数据时，它也会接收数据版本。

The data stored at each znode in a namespace is read and written  atomically. Reads get all the data bytes associated with a znode and a  write replaces all the data. Each node has an Access Control List (ACL)  that restricts who can do what.
存储在命名空间中每个 znode 的数据都是原子读取和写入的。读取获取与 znode 关联的所有数据字节，写入替换所有数据。每个节点都有一个访问控制列表 （ACL），用于限制谁可以执行哪些作。

ZooKeeper also has the notion of ephemeral nodes. These znodes exists as long as  the session that created the znode is active. When the session ends the  znode is deleted.
ZooKeeper 还具有临时节点的概念。只要创建 znode 的会话处于活动状态，这些 znode 就存在。会话结束时，znode 将被删除。



### Conditional updates and watches 条件更新和监视

ZooKeeper supports the concept of *watches*. Clients can set a watch on a znode. A watch will be triggered and  removed when the znode changes. When a watch is triggered, the client  receives a packet saying that the znode has changed. If the connection  between the client and one of the ZooKeeper servers is broken, the  client will receive a local notification.
ZooKeeper 支持*监视*的概念。客户端可以在 znode 上设置监视。当 znode 发生变化时，将触发并删除一个 watch。当触发监视时，客户端会收到一个数据包，指出 znode 已更改。如果客户端与其中一个 ZooKeeper 服务器之间的连接断开，则客户端将收到本地通知。

**New in 3.6.0:** Clients can also set permanent, recursive watches on a znode that are  not removed when triggered and that trigger for changes on the  registered znode as well as any children znodes recursively.
**3.6.0 中的新功能：** 客户端还可以在 znode 上设置永久的递归监视，这些监视在触发时不会被删除，并且会以递归方式触发已注册的 znode 以及任何子 znode 上的更改。



### Guarantees 保证

ZooKeeper is very fast and very simple. Since its goal, though, is to be a basis  for the construction of more complicated services, such as  synchronization, it provides a set of guarantees. These are:
ZooKeeper 非常快速且非常简单。但是，由于它的目标是成为构建更复杂服务（例如同步）的基础，因此它提供了一组保证。这些是：

- Sequential Consistency - Updates from a client will be applied in the order that they were sent.
  顺序一致性 - 来自客户端的更新将按发送顺序应用。
- Atomicity - Updates either succeed or fail. No partial results.
  原子性 - 更新成功或失败。无部分结果。
- Single System Image - A client will see the same view of the service  regardless of the server that it connects to. i.e., a client will never  see an older view of the system even if the client fails over to a  different server with the same session.
  单个系统映像 - 客户端将看到相同的服务视图，而不管它连接到哪个服务器。即，即使 Client 端故障转移到具有相同会话的不同服务器，Client 端也永远不会看到系统的旧视图。
- Reliability - Once an update has been applied, it will persist from that time forward until a client overwrites the update.
  可靠性 - 应用更新后，它将从该时间开始持续存在，直到客户端覆盖更新。
- Timeliness - The clients view of the system is guaranteed to be up-to-date within a certain time bound.
  及时性 - 保证系统的 clients 视图在特定时间内是最新的。



### Simple API 简单的 API

One of the design goals of ZooKeeper is providing a very simple programming interface. As a result, it supports only these operations:
ZooKeeper 的设计目标之一是提供一个非常简单的编程接口。因此，它仅支持以下作：

- *create* : creates a node at a location in the tree
  *创建*  ：在树中的某个位置创建节点
- *delete* : deletes a node
  *delete* ： 删除节点
- *exists* : tests if a node exists at a location
  *exists* ：测试某个位置是否存在节点
- *get data* : reads the data from a node
  *Get data* ：从节点读取数据
- *set data* : writes data to a node
  *设置数据*  ：将数据写入节点
- *get children* : retrieves a list of children of a node
  *get children* ：检索节点的子项列表
- *sync* : waits for data to be propagated
  *sync* ： 等待数据传播



### Implementation 实现

[ZooKeeper Components](https://zookeeper.apache.org/doc/r3.9.3/zookeeperOver.html#zkComponents) shows the high-level components of the ZooKeeper service. With the  exception of the request processor, each of the servers that make up the ZooKeeper service replicates its own copy of each of the components.
[ZooKeeper 组件 ](https://zookeeper.apache.org/doc/r3.9.3/zookeeperOver.html#zkComponents) 显示了 ZooKeeper 服务的高级组件。除了请求处理器之外，组成 ZooKeeper 服务的每个服务器都会复制自己的每个组件副本。



![ZooKeeper Components](https://zookeeper.apache.org/doc/r3.9.3/images/zkcomponents.jpg)

The replicated database is an in-memory database containing the entire data tree. Updates are logged to disk for recoverability, and writes are  serialized to disk before they are applied to the in-memory database.
复制的数据库是包含整个数据树的内存数据库。更新将记录到磁盘以实现可恢复性，并将写入序列化到磁盘，然后再将其应用于内存中数据库。

Every ZooKeeper server services clients. Clients connect to exactly one  server to submit requests. Read requests are serviced from the local  replica of each server database. Requests that change the state of the  service, write requests, are processed by an agreement protocol.
每个 ZooKeeper 服务器都为客户端提供服务。客户端只连接到一个服务器以提交请求。读取请求从每个服务器数据库的本地副本提供服务。更改服务状态的请求（写入请求）由协议协议处理。

As part of the agreement protocol all write requests from clients are forwarded to a single server, called the *leader*. The rest of the ZooKeeper servers, called *followers*, receive message proposals from the leader and agree upon message  delivery. The messaging layer takes care of replacing leaders on  failures and syncing followers with leaders.
作为协议协议的一部分，来自客户端的所有写入请求都会转发到单个服务器，称为 *leader*。其余的 ZooKeeper 服务器（称为 *follower*）接收来自领导者的消息建议并就消息传递达成一致。消息传递层负责在失败时替换领导者，并将追随者与领导者同步。

ZooKeeper uses a custom atomic messaging protocol. Since the messaging layer is  atomic, ZooKeeper can guarantee that the local replicas never diverge.  When the leader receives a write request, it calculates what the state  of the system is when the write is to be applied and transforms this  into a transaction that captures this new state.
ZooKeeper 使用自定义原子消息传递协议。由于消息收发层是原子的，因此 ZooKeeper 可以保证本地副本永远不会发散。当 leader 收到一个写请求时，它会计算在应用写时系统的状态，并将其转换为捕获此新状态的事务。



### Uses 使用

The programming interface to ZooKeeper is deliberately simple. With it,  however, you can implement higher order operations, such as  synchronizations primitives, group membership, ownership, etc.
ZooKeeper 的编程接口故意简单。但是，有了它，您可以实现更高级别的作，例如同步原语、组成员资格、所有权等。



### Performance 性能

ZooKeeper is designed to be highly performance. But is it? The results of the  ZooKeeper's development team at Yahoo! Research indicate that it is.  (See [ZooKeeper Throughput as the Read-Write Ratio Varies](https://zookeeper.apache.org/doc/r3.9.3/zookeeperOver.html#zkPerfRW).) It is especially high performance in applications where reads outnumber writes, since writes involve synchronizing the state of all servers.  (Reads outnumbering writes is typically the case for a coordination  service.)
ZooKeeper 旨在实现高性能。但事实真的如此吗？Yahoo！ Research 的 ZooKeeper 开发团队的结果表明，是的。（请参阅 [ZooKeeper 吞吐量，因为读写比率会有所不同 ](https://zookeeper.apache.org/doc/r3.9.3/zookeeperOver.html#zkPerfRW)。在读取次数超过写入次数的应用程序中，它的性能特别高，因为写入涉及同步所有服务器的状态。（读取次数超过写入次数通常是协调服务的情况。



![ZooKeeper Throughput as the Read-Write Ratio Varies](https://zookeeper.apache.org/doc/r3.9.3/images/zkperfRW-3.2.jpg)

The [ZooKeeper Throughput as the Read-Write Ratio Varies](https://zookeeper.apache.org/doc/r3.9.3/zookeeperOver.html#zkPerfRW) is a throughput graph of ZooKeeper release 3.2 running on servers with  dual 2Ghz Xeon and two SATA 15K RPM drives.  One drive was used as a  dedicated ZooKeeper log device. The snapshots were written to the OS  drive. Write requests were 1K writes and the reads were 1K reads.   "Servers" indicate the size of the ZooKeeper ensemble, the number of  servers that make up the service. Approximately 30 other servers were  used to simulate the clients. The ZooKeeper ensemble was configured such that leaders do not allow connections from clients.
[ZooKeeper 吞吐量随读写比率变化](https://zookeeper.apache.org/doc/r3.9.3/zookeeperOver.html#zkPerfRW)是 ZooKeeper 版本 3.2 的吞吐量图，该吞吐量在具有双 2Ghz Xeon 和两个 SATA 15K RPM  驱动器的服务器上运行。一个驱动器用作专用的 ZooKeeper 日志设备。快照已写入 OS 驱动器。写入请求为 1K 写入，读取为 1K  读取。“Servers” 表示 ZooKeeper ensemble 的大小，即组成服务的服务器数量。大约使用了 30  台其他服务器来模拟客户端。ZooKeeper ensemble 的配置使得 leader 不允许来自客户端的连接。

###### Note 注意

> In version 3.2 r/w performance improved by ~2x compared to the [previous 3.1 release](http://zookeeper.apache.org/docs/r3.1.1/zookeeperOver.html#Performance).
> 在版本 3.2 中，与[之前的 3.1 版本](http://zookeeper.apache.org/docs/r3.1.1/zookeeperOver.html#Performance)相比，r/w 性能提高了 ~2 倍。

Benchmarks also indicate that it is reliable, too. [Reliability in the Presence of Errors](https://zookeeper.apache.org/doc/r3.9.3/zookeeperOver.html#zkPerfReliability) shows how a deployment responds to various failures. The events marked in the figure are the following:
基准测试还表明它也是可靠的。[Reliability in the Presence of Errors](https://zookeeper.apache.org/doc/r3.9.3/zookeeperOver.html#zkPerfReliability) 显示部署如何响应各种故障。图中标记的事件如下：

1. Failure and recovery of a follower
   追随者的失败和恢复
2. Failure and recovery of a different follower
   不同 follower 的失败和恢复
3. Failure of the leader 领导者的失败
4. Failure and recovery of two followers
   两个 follower 的失败和恢复
5. Failure of another leader
   另一位领导者的失败



### Reliability 可靠性

To show the behavior of the system over time as failures are injected we  ran a ZooKeeper service made up of 7 machines. We ran the same  saturation benchmark as before, but this time we kept the write  percentage at a constant 30%, which is a conservative ratio of our  expected workloads.
为了显示系统在注入故障时随时间推移的行为，我们运行了一个由 7 台计算机组成的 ZooKeeper 服务。我们运行了与以前相同的饱和基准，但这次我们将写入百分比保持在恒定的 30%，这是我们预期工作负载的保守比率。



![Reliability in the Presence of Errors](https://zookeeper.apache.org/doc/r3.9.3/images/zkperfreliability.jpg)

There are a few important observations from this graph. First, if followers  fail and recover quickly, then ZooKeeper is able to sustain a high  throughput despite the failure. But maybe more importantly, the leader  election algorithm allows for the system to recover fast enough to  prevent throughput from dropping substantially. In our observations,  ZooKeeper takes less than 200ms to elect a new leader. Third, as  followers recover, ZooKeeper is able to raise throughput again once they start processing requests.
从这张图中可以看出一些重要的观察结果。首先，如果 follower 发生故障并快速恢复，则 ZooKeeper  能够在发生故障的情况下保持高吞吐量。但也许更重要的是，领导者选举算法允许系统足够快地恢复，以防止吞吐量大幅下降。根据我们的观察，ZooKeeper 选举新领导者所需的时间不到 200 毫秒。第三，随着追随者的恢复，一旦他们开始处理请求，ZooKeeper 就能够再次提高吞吐量。



### The ZooKeeper Project ZooKeeper 项目

ZooKeeper has been [successfully used](https://cwiki.apache.org/confluence/display/ZOOKEEPER/PoweredBy) in many industrial applications.  It is used at Yahoo! as the  coordination and failure recovery service for Yahoo! Message Broker,  which is a highly scalable publish-subscribe system managing thousands  of topics for replication and data delivery.  It is used by the Fetching Service for Yahoo! crawler, where it also manages failure recovery. A  number of Yahoo! advertising systems also use ZooKeeper to implement  reliable services.
ZooKeeper 已成功[用于](https://cwiki.apache.org/confluence/display/ZOOKEEPER/PoweredBy)许多工业应用。它在 Yahoo！ 用作 Yahoo！ Message Broker 的协调和故障恢复服务，Yahoo！ Message Broker  是一个高度可扩展的发布-订阅系统，管理着数千个用于复制和数据交付的主题。它由 Fetching Service for Yahoo！  爬网程序使用，它还管理故障恢复。许多 Yahoo！ 广告系统也使用 ZooKeeper 来实现可靠的服务。

All users and developers are encouraged to join the community and contribute their expertise. See the [Zookeeper Project on Apache](http://zookeeper.apache.org/) for more information.
我们鼓励所有用户和开发人员加入社区并贡献他们的专业知识。有关更多信息，请参阅 [Apache 上的 Zookeeper 项目 ](http://zookeeper.apache.org/)。

## 连接到 ZooKeeper

```bash
bin/zkCli.sh -server 127.0.0.1:2181
```

连接后，应该会看到如下内容：

```bash
Connecting to localhost:2181
...
Welcome to ZooKeeper!
JLine support is enabled
[zkshell: 0]
```

在 shell 中，键入 `help` 以获取可以从客户端执行的命令列表，如下所示：

```
[zkshell: 0] help
ZooKeeper -server host:port cmd args
addauth scheme auth
close
config [-c] [-w] [-s]
connect host:port
create [-s] [-e] [-c] [-t ttl] path [data] [acl]
delete [-v version] path
deleteall path
delquota [-n|-b] path
get [-s] [-w] path
getAcl [-s] path
getAllChildrenNumber path
getEphemerals path
history
listquota path
ls [-s] [-w] [-R] path
printwatches on|off
quit
reconfig [-s] [-v version] [[-file path] | [-members serverID=host:port1:port2;port3[,...]*]] | [-add serverId=host:port1:port2;port3[,...]]* [-remove serverId[,...]*]
redo cmdno
removewatches path [-c|-d|-a] [-l]
set [-s] [-v version] path data
setAcl [-s] [-v version] [-R] path acl
setquota -n|-b val path
stat [-w] path
sync path
```

从这里，可以尝试一些简单的命令来感受这个简单的命令行界面。首先，发出 list 命令，如 `ls` 中所示，产生：

```bash
[zkshell: 8] ls /
[zookeeper]
```

接下来，通过运行 `create /zk_test my_data` 创建一个新的 znode 。这将创建一个新的 znode 并将字符串 “my_data” 与该节点关联。应该看到：

```bash
[zkshell: 9] create /zk_test my_data
Created /zk_test
```

发出另一个 `ls /` 命令来查看目录：

```bash
[zkshell: 11] ls /
[zookeeper, zk_test]
```

注意，zk_test 目录现在已经创建。

接下来，通过运行 `get` 命令验证数据是否与 znode 关联，如下所示：

```bash
[zkshell: 12] get /zk_test
my_data
cZxid = 5
ctime = Fri Jun 05 13:57:06 PDT 2009
mZxid = 5
mtime = Fri Jun 05 13:57:06 PDT 2009
pZxid = 5
cversion = 0
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0
dataLength = 7
numChildren = 0
```

我们可以通过发出 `set` 命令来更改与 zk_test 相关的数据，如下所示：

```bash
[zkshell: 14] set /zk_test junk
cZxid = 5
ctime = Fri Jun 05 13:57:06 PDT 2009
mZxid = 6
mtime = Fri Jun 05 14:01:52 PDT 2009
pZxid = 5
cversion = 0
dataVersion = 1
aclVersion = 0
ephemeralOwner = 0
dataLength = 4
numChildren = 0
[zkshell: 15] get /zk_test
junk
cZxid = 5
ctime = Fri Jun 05 13:57:06 PDT 2009
mZxid = 6
mtime = Fri Jun 05 14:01:52 PDT 2009
pZxid = 5
cversion = 0
dataVersion = 1
aclVersion = 0
ephemeralOwner = 0
dataLength = 4
numChildren = 0
```

最后，删除节点：

```bash
[zkshell: 16] delete /zk_test
[zkshell: 17] ls /
[zookeeper]
[zkshell: 18]
```

### Programming to ZooKeeper

ZooKeeper has a Java bindings and C bindings. They are functionally  equivalent. The C bindings exist in two variants: single threaded and  multi-threaded. These differ only in how the messaging loop is done. For more information, see the [Programming Examples in the ZooKeeper Programmer's Guide](https://zookeeper.apache.org/doc/r3.9.1/zookeeperProgrammers.html#ch_programStructureWithExample) for sample code using the different APIs.

使用ZooKeeper

ZooKeeper有Java绑定和C绑定。它们在功能上是等同的。C绑定有两种变体：单线程和多线程。它们之间的区别仅在于消息传递循环是如何完成的。有关更多信息，请参阅ZooKeeper程序员指南中的编程示例，以获取使用不同API的示例代码。

### Running Replicated ZooKeeper

Running ZooKeeper in standalone mode is convenient for evaluation,  some development, and testing. But in production, you should run  ZooKeeper in replicated mode. A replicated group of servers in the same  application is called a *quorum*, and in replicated mode, all servers in the quorum have copies of the same configuration file.

###### Note

> For replicated mode, a minimum of three servers are required, and it  is strongly recommended that you have an odd number of servers. If you  only have two servers, then you are in a situation where if one of them  fails, there are not enough machines to form a majority quorum. Two  servers are inherently **less** stable than a single server, because there are two single points of failure.

The required **conf/zoo.cfg** file for replicated mode is similar to the one used in standalone mode, but with a few differences. Here is an example:

```
tickTime=2000
dataDir=/var/lib/zookeeper
clientPort=2181
initLimit=5
syncLimit=2
server.1=zoo1:2888:3888
server.2=zoo2:2888:3888
server.3=zoo3:2888:3888
```

The new entry, **initLimit** is timeouts ZooKeeper uses to limit the length of time the ZooKeeper servers in quorum have to connect to a leader. The entry **syncLimit** limits how far out of date a server can be from a leader.

With both of these timeouts, you specify the unit of time using **tickTime**. In this example, the timeout for initLimit is 5 ticks at 2000 milliseconds a tick, or 10 seconds.

The entries of the form *server.X* list the servers that make  up the ZooKeeper service. When the server starts up, it knows which  server it is by looking for the file *myid* in the data directory. That file has the contains the server number, in ASCII.

Finally, note the two port numbers after each server name: " 2888"  and "3888". Peers use the former port to connect to other peers. Such a  connection is necessary so that peers can communicate, for example, to  agree upon the order of updates. More specifically, a ZooKeeper server  uses this port to connect followers to the leader. When a new leader  arises, a follower opens a TCP connection to the leader using this port. Because the default leader election also uses TCP, we currently require another port for leader election. This is the second port in the server entry.

###### Note

> If you want to test multiple servers on a single machine, specify the servername as *localhost* with unique quorum & leader election ports (i.e. 2888:3888,  2889:3889, 2890:3890 in the example above) for each server.X in that  server's config file. Of course separate _dataDir_s and distinct  _clientPort_s are also necessary (in the above replicated example,  running on a single *localhost*, you would still have three config files).
>
> Please be aware that setting up multiple servers on a single machine  will not create any redundancy. If something were to happen which caused the machine to die, all of the zookeeper servers would be offline. Full redundancy requires that each server have its own machine. It must be a completely separate physical server. Multiple virtual machines on the  same physical host are still vulnerable to the complete failure of that  host.
>
> If you have multiple network interfaces in your ZooKeeper machines,  you can also instruct ZooKeeper to bind on all of your interfaces and  automatically switch to a healthy interface in case of a network  failure. For details, see the [Configuration Parameters](https://zookeeper.apache.org/doc/r3.9.1/zookeeperAdmin.html#id_multi_address).



### Other Optimizations

There are a couple of other configuration parameters that can greatly increase performance:

- To get low latencies on updates it is important to have a dedicated  transaction log directory. By default transaction logs are put in the  same directory as the data snapshots and *myid* file. The dataLogDir parameters indicates a different directory to use for the transaction logs.