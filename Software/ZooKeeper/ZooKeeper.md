# Apache ZooKeeper

[TOC]

## 概述

ZooKeeper: Because Coordinating Distributed Systems is a Zoo

ZooKeeper：因为协调分布式系统是一个动物园

ZooKeeper is a high-performance coordination service for distributed  applications.  It exposes common services - such as naming,  configuration management, synchronization, and group services - in a  simple interface so you don't have to write them from scratch.  You can  use it off-the-shelf to implement consensus, group management, leader  election, and presence protocols. And you can build on it for your own,  specific needs.

ZooKeeper是一个针对分布式应用程序的高性能协调服务。它在一个简单的接口中公开了常见的服务，例如命名、配置管理、同步和组服务，因此您不必从头开始编写它们。您可以使用它来实现共识、组管理、领导者选举和存在协议。你可以根据自己的具体需要来构建它。

Apache ZooKeeper 致力于开发和维护一个开源服务器，以实现高度可靠的分布式协调。Apache ZooKeeper 是 Apache 软件基金会的一个开源志愿者项目。

ZooKeeper is a centralized service for maintaining configuration  information, naming, providing distributed synchronization, and  providing group services. All of these kinds of services are used in  some form or another by distributed applications. Each time they are  implemented there is a lot of work that goes into fixing the bugs and  race conditions that are inevitable. Because of the difficulty of  implementing these kinds of services, applications initially usually  skimp on them, which make them brittle in the presence of change and  difficult to manage. Even when done correctly, different implementations of these services lead to management complexity when the applications  are deployed.

ZooKeeper 是一个集中式服务，用于维护配置信息，命名，提供分布式同步和提供组服务。分布式应用程序以某种形式使用所有这些类型的服务。每次实现它们时，都有大量的工作要做，以修复不可避免的bug和竞争条件。由于实现这类服务的困难，应用程序最初通常会忽略它们，这使得它们在出现更改时变得脆弱，并且难以管理。即使正确地执行了这些服务，这些服务的不同实现也会导致部署应用程序时的管理复杂性。



- ZooKeeper Overview

   Technical Overview Documents for Client Developers, Administrators, and Contributors

  - [Overview](https://zookeeper.apache.org/doc/r3.9.1/zookeeperOver.html) - a bird's eye view of ZooKeeper, including design concepts and architecture
  - [Getting Started](https://zookeeper.apache.org/doc/r3.9.1/zookeeperStarted.html) - a tutorial-style guide for developers to install, run, and program to ZooKeeper
  - [Release Notes](https://zookeeper.apache.org/doc/r3.9.1/releasenotes.html) - new developer and user facing features, improvements, and incompatibilities

- Developers

   Documents for Developers using the ZooKeeper Client API

  - [API Docs](https://zookeeper.apache.org/doc/r3.9.1/apidocs/zookeeper-server/index.html) - the technical reference to ZooKeeper Client APIs
  - [Programmer's Guide](https://zookeeper.apache.org/doc/r3.9.1/zookeeperProgrammers.html) - a client application developer's guide to ZooKeeper
  - [ZooKeeper Use Cases](https://zookeeper.apache.org/doc/r3.9.1/zookeeperUseCases.html) - a series of use cases using the ZooKeeper.
  - [ZooKeeper Java Example](https://zookeeper.apache.org/doc/r3.9.1/javaExample.html) - a simple Zookeeper client application, written in Java
  - [Barrier and Queue Tutorial](https://zookeeper.apache.org/doc/r3.9.1/zookeeperTutorial.html) - sample implementations of barriers and queues
  - [ZooKeeper Recipes](https://zookeeper.apache.org/doc/r3.9.1/recipes.html) - higher level solutions to common problems in distributed applications

- Administrators & Operators

   Documents for Administrators and Operations Engineers of ZooKeeper Deployments

  - [Administrator's Guide](https://zookeeper.apache.org/doc/r3.9.1/zookeeperAdmin.html) - a guide for system administrators and anyone else who might deploy ZooKeeper
  - [Quota Guide](https://zookeeper.apache.org/doc/r3.9.1/zookeeperQuotas.html) - a guide for system administrators on Quotas in ZooKeeper.
  - [Snapshot and Restore Guide](https://zookeeper.apache.org/doc/r3.9.1/zookeeperSnapshotAndRestore.html) - a guide for system administrators on take snapshot and restore ZooKeeper.
  - [JMX](https://zookeeper.apache.org/doc/r3.9.1/zookeeperJMX.html) - how to enable JMX in ZooKeeper
  - [Hierarchical Quorums](https://zookeeper.apache.org/doc/r3.9.1/zookeeperHierarchicalQuorums.html) - a guide on how to use hierarchical quorums
  - [Oracle Quorum](https://zookeeper.apache.org/doc/r3.9.1/zookeeperOracleQuorums.html) - the introduction to Oracle Quorum increases the availability of a cluster of 2 ZooKeeper instances with a failure detector.
  - [Observers](https://zookeeper.apache.org/doc/r3.9.1/zookeeperObservers.html) - non-voting ensemble members that easily improve ZooKeeper's scalability
  - [Dynamic Reconfiguration](https://zookeeper.apache.org/doc/r3.9.1/zookeeperReconfig.html) - a guide on how to use dynamic reconfiguration in ZooKeeper
  - [ZooKeeper CLI](https://zookeeper.apache.org/doc/r3.9.1/zookeeperCLI.html) - a guide on how to use the ZooKeeper command line interface
  - [ZooKeeper Tools](https://zookeeper.apache.org/doc/r3.9.1/zookeeperTools.html) - a guide on how to use a series of tools for ZooKeeper
  - [ZooKeeper Monitor](https://zookeeper.apache.org/doc/r3.9.1/zookeeperMonitor.html) - a guide on how to monitor the ZooKeeper
  - [Audit Logging](https://zookeeper.apache.org/doc/r3.9.1/zookeeperAuditLogs.html) - a guide on how to configure audit logs in ZooKeeper Server and what contents are logged.

- Contributors

   Documents for Developers Contributing to the ZooKeeper Open Source Project

  - [ZooKeeper Internals](https://zookeeper.apache.org/doc/r3.9.1/zookeeperInternals.html) - assorted topics on the inner workings of ZooKeeper

- Miscellaneous ZooKeeper Documentation

  - [Wiki](https://cwiki.apache.org/confluence/display/ZOOKEEPER)
  - [FAQ](https://cwiki.apache.org/confluence/display/ZOOKEEPER/FAQ)





    ZooKeeper概述技术概述面向客户端开发人员、管理员和贡献者的文档
        概述-ZooKeeper的鸟瞰图，包括设计概念和架构
        入门-一个教程式的指南，供开发人员安装，运行和编程到ZooKeeper
        发行说明-面向开发人员和用户的新功能、改进和不兼容性
    开发人员使用ZooKeeper客户端API的开发人员文档
        API接口-ZooKeeper客户端API的技术参考
        程序员指南-ZooKeeper客户端应用程序开发人员指南
        ZooKeeper用例-一系列使用ZooKeeper的用例。
        ZooKeeper Java示例-一个简单的Zookeeper客户端应用程序，用Java编写
        屏障和队列的示例实现
        ZooKeeper Recipes -分布式应用程序中常见问题的高级解决方案
    ZooKeeper部署管理员和操作工程师的管理员和操作员文档
        管理员指南-系统管理员和任何可能部署ZooKeeper的人的指南
        Question Guide -ZooKeeper中Question的系统管理员指南。
        快照和恢复指南-系统管理员的快照和恢复ZooKeeper指南。
        如何在ZooKeeper中启用JMX
        分层法定人数-关于如何使用分层法定人数的指南
        Oracle Quorum -Oracle Quorum的引入增加了具有故障检测器的2个ZooKeeper实例的集群的可用性。
        观察者-无投票权的集合成员，可以轻松提高ZooKeeper的可扩展性
        动态重新配置-关于如何在ZooKeeper中使用动态重新配置的指南
        ZooKeeper CLI -关于如何使用ZooKeeper命令行界面的指南
        ZooKeeper Tools -关于如何使用ZooKeeper的一系列工具的指南
        ZooKeeper Monitor -关于如何监控ZooKeeper的指南
        审计日志-关于如何在ZooKeeper Server中配置审计日志以及记录哪些内容的指南。
    为ZooKeeper开源项目贡献内容的开发人员文档
        ZooKeeper Internals -关于ZooKeeper内部工作原理的各种主题
    其他ZooKeeper文档
        Wiki
        FAQ

## ZooKeeper: A Distributed Coordination Service for Distributed Applications

ZooKeeper is a distributed, open-source coordination service for  distributed applications. It exposes a simple set of primitives that  distributed applications can build upon to implement higher level  services for synchronization, configuration maintenance, and groups and  naming. It is designed to be easy to program to, and uses a data model  styled after the familiar directory tree structure of file systems. It  runs in Java and has bindings for both Java and C.

Coordination services are notoriously hard to get right. They are  especially prone to errors such as race conditions and deadlock. The  motivation behind ZooKeeper is to relieve distributed applications the  responsibility of implementing coordination services from scratch.



### Design Goals

**ZooKeeper is simple.** ZooKeeper allows distributed  processes to coordinate with each other through a shared hierarchical  namespace which is organized similarly to a standard file system. The  namespace consists of data registers - called znodes, in ZooKeeper  parlance - and these are similar to files and directories. Unlike a  typical file system, which is designed for storage, ZooKeeper data is  kept in-memory, which means ZooKeeper can achieve high throughput and  low latency numbers.

The ZooKeeper implementation puts a premium on high performance,  highly available, strictly ordered access. The performance aspects of  ZooKeeper means it can be used in large, distributed systems. The  reliability aspects keep it from being a single point of failure. The  strict ordering means that sophisticated synchronization primitives can  be implemented at the client.

**ZooKeeper is replicated.** Like the distributed  processes it coordinates, ZooKeeper itself is intended to be replicated  over a set of hosts called an ensemble.

![ZooKeeper Service](https://zookeeper.apache.org/doc/r3.9.1/images/zkservice.jpg)

The servers that make up the ZooKeeper service must all know about  each other. They maintain an in-memory image of state, along with a  transaction logs and snapshots in a persistent store. As long as a  majority of the servers are available, the ZooKeeper service will be  available.

Clients connect to a single ZooKeeper server. The client maintains a  TCP connection through which it sends requests, gets responses, gets  watch events, and sends heart beats. If the TCP connection to the server breaks, the client will connect to a different server.

**ZooKeeper is ordered.** ZooKeeper stamps each update  with a number that reflects the order of all ZooKeeper transactions.  Subsequent operations can use the order to implement higher-level  abstractions, such as synchronization primitives.

**ZooKeeper is fast.** It is especially fast in  "read-dominant" workloads. ZooKeeper applications run on thousands of  machines, and it performs best where reads are more common than writes,  at ratios of around 10:1.



### Data model and the hierarchical namespace

The namespace provided by ZooKeeper is much like that of a standard  file system. A name is a sequence of path elements separated by a slash  (/). Every node in ZooKeeper's namespace is identified by a path.

#### ZooKeeper's Hierarchical Namespace

![ZooKeeper's Hierarchical Namespace](https://zookeeper.apache.org/doc/r3.9.1/images/zknamespace.jpg)



### Nodes and ephemeral nodes

Unlike standard file systems, each node in a ZooKeeper namespace can  have data associated with it as well as children. It is like having a  file-system that allows a file to also be a directory. (ZooKeeper was  designed to store coordination data: status information, configuration,  location information, etc., so the data stored at each node is usually  small, in the byte to kilobyte range.) We use the term *znode* to make it clear that we are talking about ZooKeeper data nodes.

Znodes maintain a stat structure that includes version numbers for  data changes, ACL changes, and timestamps, to allow cache validations  and coordinated updates. Each time a znode's data changes, the version  number increases. For instance, whenever a client retrieves data it also receives the version of the data.

The data stored at each znode in a namespace is read and written  atomically. Reads get all the data bytes associated with a znode and a  write replaces all the data. Each node has an Access Control List (ACL)  that restricts who can do what.

ZooKeeper also has the notion of ephemeral nodes. These znodes exists as long as the session that created the znode is active. When the  session ends the znode is deleted.



### Conditional updates and watches

ZooKeeper supports the concept of *watches*. Clients can set a watch on a znode. A watch will be triggered and removed when the znode  changes. When a watch is triggered, the client receives a packet saying  that the znode has changed. If the connection between the client and one of the ZooKeeper servers is broken, the client will receive a local  notification.

**New in 3.6.0:** Clients can also set permanent,  recursive watches on a znode that are not removed when triggered and  that trigger for changes on the registered znode as well as any children znodes recursively.



### Guarantees

ZooKeeper is very fast and very simple. Since its goal, though, is to be a basis for the construction of more complicated services, such as  synchronization, it provides a set of guarantees. These are:

- Sequential Consistency - Updates from a client will be applied in the order that they were sent.
- Atomicity - Updates either succeed or fail. No partial results.
- Single System Image - A client will see the same view of the service regardless of the server that it connects to. i.e., a client will never see an older view of the system even if the client fails over to a  different server with the same session.
- Reliability - Once an update has been applied, it will persist from that time forward until a client overwrites the update.
- Timeliness - The clients view of the system is guaranteed to be up-to-date within a certain time bound.



### Simple API

One of the design goals of ZooKeeper is providing a very simple  programming interface. As a result, it supports only these operations:

- *create* : creates a node at a location in the tree
- *delete* : deletes a node
- *exists* : tests if a node exists at a location
- *get data* : reads the data from a node
- *set data* : writes data to a node
- *get children* : retrieves a list of children of a node
- *sync* : waits for data to be propagated



### Implementation

[ZooKeeper Components](https://zookeeper.apache.org/doc/r3.9.1/zookeeperOver.html#zkComponents) shows the high-level components of the ZooKeeper service. With the  exception of the request processor, each of the servers that make up the ZooKeeper service replicates its own copy of each of the components.



![ZooKeeper Components](https://zookeeper.apache.org/doc/r3.9.1/images/zkcomponents.jpg)

The replicated database is an in-memory database containing the  entire data tree. Updates are logged to disk for recoverability, and  writes are serialized to disk before they are applied to the in-memory  database.

Every ZooKeeper server services clients. Clients connect to exactly  one server to submit requests. Read requests are serviced from the local replica of each server database. Requests that change the state of the  service, write requests, are processed by an agreement protocol.

As part of the agreement protocol all write requests from clients are forwarded to a single server, called the *leader*. The rest of the ZooKeeper servers, called *followers*, receive message proposals from the leader and agree upon message  delivery. The messaging layer takes care of replacing leaders on  failures and syncing followers with leaders.

ZooKeeper uses a custom atomic messaging protocol. Since the  messaging layer is atomic, ZooKeeper can guarantee that the local  replicas never diverge. When the leader receives a write request, it  calculates what the state of the system is when the write is to be  applied and transforms this into a transaction that captures this new  state.



### Uses

The programming interface to ZooKeeper is deliberately simple. With  it, however, you can implement higher order operations, such as  synchronizations primitives, group membership, ownership, etc.



### Performance

ZooKeeper is designed to be highly performance. But is it? The  results of the ZooKeeper's development team at Yahoo! Research indicate  that it is. (See [ZooKeeper Throughput as the Read-Write Ratio Varies](https://zookeeper.apache.org/doc/r3.9.1/zookeeperOver.html#zkPerfRW).) It is especially high performance in applications where reads outnumber writes, since writes involve synchronizing the state of all servers.  (Reads outnumbering writes is typically the case for a coordination  service.)



![ZooKeeper Throughput as the Read-Write Ratio Varies](https://zookeeper.apache.org/doc/r3.9.1/images/zkperfRW-3.2.jpg)

The [ZooKeeper Throughput as the Read-Write Ratio Varies](https://zookeeper.apache.org/doc/r3.9.1/zookeeperOver.html#zkPerfRW) is a throughput graph of ZooKeeper release 3.2 running on servers with  dual 2Ghz Xeon and two SATA 15K RPM drives.  One drive was used as a  dedicated ZooKeeper log device. The snapshots were written to the OS  drive. Write requests were 1K writes and the reads were 1K reads.   "Servers" indicate the size of the ZooKeeper ensemble, the number of  servers that make up the service. Approximately 30 other servers were  used to simulate the clients. The ZooKeeper ensemble was configured such that leaders do not allow connections from clients.

###### Note

> In version 3.2 r/w performance improved by ~2x compared to the [previous 3.1 release](http://zookeeper.apache.org/docs/r3.1.1/zookeeperOver.html#Performance).

Benchmarks also indicate that it is reliable, too. [Reliability in the Presence of Errors](https://zookeeper.apache.org/doc/r3.9.1/zookeeperOver.html#zkPerfReliability) shows how a deployment responds to various failures. The events marked in the figure are the following:

1. Failure and recovery of a follower
2. Failure and recovery of a different follower
3. Failure of the leader
4. Failure and recovery of two followers
5. Failure of another leader



### Reliability

To show the behavior of the system over time as failures are injected we ran a ZooKeeper service made up of 7 machines. We ran the same  saturation benchmark as before, but this time we kept the write  percentage at a constant 30%, which is a conservative ratio of our  expected workloads.



![Reliability in the Presence of Errors](https://zookeeper.apache.org/doc/r3.9.1/images/zkperfreliability.jpg)

There are a few important observations from this graph. First, if  followers fail and recover quickly, then ZooKeeper is able to sustain a  high throughput despite the failure. But maybe more importantly, the  leader election algorithm allows for the system to recover fast enough  to prevent throughput from dropping substantially. In our observations,  ZooKeeper takes less than 200ms to elect a new leader. Third, as  followers recover, ZooKeeper is able to raise throughput again once they start processing requests.



### The ZooKeeper Project

ZooKeeper has been [successfully used](https://cwiki.apache.org/confluence/display/ZOOKEEPER/PoweredBy) in many industrial applications.  It is used at Yahoo! as the  coordination and failure recovery service for Yahoo! Message Broker,  which is a highly scalable publish-subscribe system managing thousands  of topics for replication and data delivery.  It is used by the Fetching Service for Yahoo! crawler, where it also manages failure recovery. A  number of Yahoo! advertising systems also use ZooKeeper to implement  reliable services.

All users and developers are encouraged to join the community and contribute their expertise. See the [Zookeeper Project on Apache](http://zookeeper.apache.org/) for more information.

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