# Kafka

[TOC]

## 概述

Apache Kafka 是一个开源分布式事件流平台，被数千家公司用于高性能数据管道、流分析、数据集成和任务关键型应用程序。

### 事件流式处理

Event streaming is the digital equivalent of the human body's central nervous system. It is the    technological foundation for the 'always-on' world where businesses are increasingly software-defined     and automated, and where the user of software is more software.  
事件流是人体中枢神经系统的数字等价物。它是“永远在线”世界的技术基础，在这个世界中，企业越来越多地采用软件定义和自动化，而软件的用户则更多地使用软件。

event streaming is the practice of capturing data in real-time from event sources    like databases, sensors, mobile devices, cloud services, and software applications in the form of streams    of events; storing these event streams durably for later retrieval; manipulating, processing, and reacting    to the event streams in real-time as well as retrospectively; and routing the event streams to different    destination technologies as needed. Event streaming thus ensures a continuous flow and interpretation of    data so that the right information is at the right place, at the right time.  
从技术上讲，事件流是指以事件流的形式从事件源（如数据库、传感器、移动设备、云服务和软件应用程序）实时捕获数据的做法;持久存储这些事件流以供以后检索;实时和回顾性地作、处理和响应事件流;以及根据需要将事件流路由到不同的目标技术。因此，事件流可确保数据的连续流动和解释，以便在正确的时间将正确的信息放在正确的位置。

#### 事件流式处理可以用于什么？

事件流式处理适用于[各种使用案例](https://kafka.apache.org/powered-by) 跨越众多行业和组织。它的许多示例包括：

- 实时处理付款和金融交易，例如在证券交易所、银行和保险中。
- 实时跟踪和监控汽车、卡车、车队和货物，例如物流和汽车行业。
- 持续捕获和分析来自 IoT 设备或其他设备（例如工厂和风电场）的传感器数据。
- 收集客户互动和订单并立即做出反应，例如在零售、酒店和旅游行业以及移动应用程序中。
- 监测住院护理的患者并预测病情变化，以确保在紧急情况下得到及时治疗。
- 连接、存储和提供公司不同部门生成的数据。
- 作为数据平台、事件驱动型架构和微服务的基础。

### Apache Kafka® 是一个事件流式处理平台。那是什么意思？

Kafka combines three key capabilities so you can implement    [your use cases](https://kafka.apache.org/powered-by)    for event streaming end-to-end with a single battle-tested solution:  
Kafka 结合了三个关键功能，因此可以实施 [您的使用案例](https://kafka.apache.org/powered-by) 对于使用单个久经考验的解决方案进行端到端事件流式处理：

1. **发布** （写入）和**订阅** （读取）事件流，包括连续导入/导出来自其他系统的数据。
2. To **store** streams of events durably and reliably for as long as you want.    
   根据需要持久可靠地**存储**事件流。
3. To **process** streams of events as they occur or retrospectively.    
   在事件发生时或回顾性**地处理**事件流。

所有这些功能都是以分布式、高度可扩展、弹性、容错和安全的方式提供的。Kafka 可以部署在裸机硬件、虚拟机和容器上，也可以部署在本地和云中。可以选择自行管理 Kafka 环境和使用各种供应商提供的完全托管式服务。

### Kafka 是如何工作的？

Kafka 是一个分布式系统，由**服务器**和**客户端**组成，它们通过高性能 [TCP 网络协议](https://kafka.apache.org/protocol.html)进行通信。 它可以部署在本地和云环境中的裸机硬件、虚拟机和容器上。

Other servers run    [Kafka Connect](https://kafka.apache.org/documentation/#connect) to continuously import and export    data as event streams to integrate Kafka with your existing systems such as relational databases as well as    other Kafka clusters.
**服务器** ：Kafka 作为一个或多个服务器的集群运行，这些服务器可以跨越多个数据中心或云区域。其中一些服务器构成了存储层，称为代理（broker）。其他服务器运行 [Kafka Connect](https://kafka.apache.org/documentation/#connect) 持续导入和导出数据作为事件流，以将 Kafka 与现有系统（如关系数据库）集成，以及其他 Kafka 集群。为了让您实施任务关键型使用案例，Kafka 集群具有高度可扩展性 和容错：如果它的任何服务器出现故障，其他服务器将接管它们的工作以确保连续运行，不会丢失任何数据。

They allow you to write distributed applications and microservices that read, write,    and process streams of events in parallel, at scale, and in a fault-tolerant manner even in the case of network    problems or machine failures. Kafka ships with some such clients included, which are augmented by    [dozens of clients](https://cwiki.apache.org/confluence/display/KAFKA/Clients) provided by the Kafka    community: clients are available for Java and Scala including the higher-level    [Kafka Streams](https://kafka.apache.org/documentation/streams/) library, for Go, Python, C/C++, and    many other programming languages as well as REST APIs.  
**客户端** ：它们允许您编写分布式应用程序和微服务，这些应用程序和微服务可以读取、写入、 并行、大规模和以容错方式处理事件流，即使在网络的情况下也是如此 问题或机器故障。Kafka 附带了一些这样的客户端，这些客户端由 Kafka 提供的[数十个客户端](https://cwiki.apache.org/confluence/display/KAFKA/Clients) community：客户端可用于 Java 和 Scala，包括更高级别的 [Kafka Streams](https://kafka.apache.org/documentation/streams/) 库，适用于 Go、Python、C/C++ 和 许多其他编程语言以及 REST API。

### 主要概念和术语  

When you read or write data to Kafka, you do this in the form of events.  Conceptually, an event has a key, value, timestamp, and optional  metadata headers. 
**事件**记录了世界上或您的企业中 “发生了什么” 的事实。在文档中也称为 record 或 message。当您向 Kafka 读取或写入数据时，您以事件的形式执行此作。从概念上讲，事件具有键、值、时间戳和可选的元数据标头。下面是一个示例事件：

- Event key: "Alice"
- Event value: "Made a payment of $200 to Bob"
- Event timestamp: "Jun. 25, 2020 at 2:06 p.m."

**Producers** 是将事件发布（写入）到 Kafka 的客户端应用程序，而 **consumers** 是订阅（读取和处理）这些事件的客户端应用程序。在 Kafka 中，生产者和使用者完全解耦且彼此不可知，这是实现 Kafka 众所周知的高可扩展性的关键设计元素。例如，生产者永远不需要等待消费者。Kafka 提供各种[保证 ](https://kafka.apache.org/documentation/#semantics)，例如能够精确处理一次事件。

Events are organized and durably stored in **topics**. Very simplified, a topic is similar to a folder in a filesystem, and  the events are the files in that folder. An example topic name could be  "payments". Topics in Kafka are always multi-producer and  multi-subscriber: a topic can have zero, one, or many producers that  write events to it, as well as zero, one, or many consumers that  subscribe to these events. Events in a topic can be read as often as  needed—unlike traditional messaging systems, events are not deleted  after consumption. Instead, you define for how long Kafka should retain  your events through a per-topic configuration setting, after which old  events will be discarded. Kafka's performance is effectively constant  with respect to data size, so storing data for a long time is perfectly  fine.  
事件被组织并持久存储在**主题**中。非常简单，主题类似于文件系统中的文件夹，事件是该文件夹中的文件。示例主题名称可以是 “payments”。Kafka  中的主题始终是多创建者和多订阅者：一个主题可以有零个、一个或多个向其写入事件的创建者，以及订阅这些事件的零个、一个或多个使用者。可以根据需要随时读取主题中的事件 - 与传统消息传递系统不同，事件在使用后不会删除。相反，您可以通过每个主题的配置设置定义 Kafka  应将事件保留多长时间，之后将丢弃旧事件。Kafka 的性能在数据大小方面实际上是恒定的，因此长时间存储数据是完全可以的。

Topics are **partitioned**, meaning a topic is spread over a number of "buckets" located on  different Kafka brokers. This distributed placement of your data is very important for scalability because it allows client applications to both read and write the data from/to many brokers at the same time. When a  new event is published to a topic, it is actually appended to one of the topic's partitions. Events with the same event key (e.g., a customer or vehicle ID) are written to the same partition, and Kafka [guarantees](https://kafka.apache.org/documentation/#semantics) that any consumer of a given topic-partition will always read that  partition's events in exactly the same order as they were written.  
主题是**分区**的，这意味着主题分布在位于不同 Kafka  代理上的多个“存储桶”中。这种分布式数据放置对于可伸缩性非常重要，因为它允许客户端应用程序同时从多个代理读取和写入数据。当新事件发布到主题时，它实际上会附加到主题的某个分区中。具有相同事件键的事件（例如，客户或车辆 ID）将写入同一分区，Kafka [ 保证](https://kafka.apache.org/documentation/#semantics)给定主题分区的任何使用者将始终以与写入事件完全相同的顺序读取该分区的事件。

​    ![](../../Image/s/streams-and-tables-p1_p4.png)          Figure: This example topic has four partitions P1–P4. Two different producer clients are publishing,      independently from each other, new events to the topic by writing events over the network to the topic's      partitions. Events with the same key (denoted by their color in the figure) are written to the same      partition. Note that both producers can write to the same partition if appropriate.    
此示例主题有四个分区 P1–P4。两个不同的创建者客户端通过网络将事件写入主题的分区，彼此独立地将新事件发布到主题。具有相同键的事件（由图中的颜色表示)将写入同一分区。请注意，如果合适，两个 producer 都可以写入同一个分区。  

To make your data fault-tolerant and highly-available, every topic can be **replicated**, even across geo-regions or datacenters, so that there are always  multiple brokers that have a copy of the data just in case things go  wrong, you want to do maintenance on the brokers, and so on. A common  production setting is a replication factor of 3, i.e., there will always be three copies of your data. This replication is performed at the  level of topic-partitions.  
为了使您的数据具有容错性和高可用性，每个主题都可以复制，甚至可以跨地理区域或数据中心**复制** ，以便始终有多个代理拥有数据副本，以防万一出现问题，您想对代理进行维护，等等。常见的生产设置是复制因子 3，即数据始终有三个副本。此复制在 topic-partitions 级别执行。

## Kafka API

In addition to command line tooling for management and administration tasks, 除了用于管理和管理任务的命令行工具外，Kafka 还有五个适用于 Java 和 Scala 的核心 API：

- The [Admin API](https://kafka.apache.org/documentation.html#adminapi) to manage and inspect topics, brokers, and other Kafka objects.    
  用于管理和检查主题、代理和其他 Kafka 对象的 [Admin API](https://kafka.apache.org/documentation.html#adminapi)。
- The [Producer API](https://kafka.apache.org/documentation.html#producerapi) to publish (write) a stream of events to one or more Kafka topics.    
  [生产者 API](https://kafka.apache.org/documentation.html#producerapi)，用于将事件流发布（写入）到一个或多个 Kafka 主题。
- The [Consumer API](https://kafka.apache.org/documentation.html#consumerapi) to subscribe to (read) one or more topics and to process the stream of events produced to them.    
  [Consumer API](https://kafka.apache.org/documentation.html#consumerapi)，用于订阅（读取）一个或多个主题并处理向它们生成的事件流。
- The [Kafka Streams API](https://kafka.apache.org/documentation/streams) to implement stream processing applications and microservices. It  provides higher-level functions to process event streams, including  transformations, stateful operations like aggregations and joins,  windowing, processing based on event-time, and more. Input is read from  one or more topics in order to generate output to one or more topics,  effectively transforming the input streams to output streams.    
  [Kafka Streams API](https://kafka.apache.org/documentation/streams)，用于实施流处理应用程序和微服务。它提供更高级别的函数来处理事件流，包括转换、有状态作（如聚合和联接）、窗口化、基于事件时间的处理等。从一个或多个主题中读取输入，以便生成对一个或多个主题的输出，从而有效地将输入流转换为输出流。
- The [Kafka Connect API](https://kafka.apache.org/documentation.html#connect) to build and run reusable data import/export connectors that consume  (read) or produce (write) streams of events from and to external systems and applications so they can integrate with Kafka. For example, a  connector to a relational database like PostgreSQL might capture every  change to a set of tables. However, in practice, you typically don't  need to implement your own connectors because the Kafka community  already provides hundreds of ready-to-use connectors.    
  [Kafka Connect API](https://kafka.apache.org/documentation.html#connect)，用于构建和运行可重用的数据导入/导出连接器，这些连接器使用（读取）或生成（写入）来自外部系统和应用程序的事件流，以便它们可以与 Kafka 集成。例如，指向关系数据库（如  PostgreSQL）的连接器可能会捕获对一组表的每次更改。但是，在实践中，您通常不需要实施自己的连接器，因为 Kafka  社区已经提供了数百个现成的连接器。

   

#### [Step 3: Create a topic to store your events 第 3 步：创建主题以存储您的事件](https://kafka.apache.org/quickstart#quickstart_createtopic)        

​            Kafka is a distributed *event streaming platform* that lets you read, write, store, and process            [*events*](https://kafka.apache.org/documentation/#messages) (also called *records* or            *messages* in the documentation)            across many machines.        
Kafka 是一个分布式*事件流式处理平台* ，可用于读取、写入、存储和处理 [*事件* ](https://kafka.apache.org/documentation/#messages)（也称为*记录*或 *消息* ） 跨多台机器。

​            Example events are payment transactions, geolocation updates from mobile phones, shipping orders, sensor measurements            from IoT devices or medical equipment, and much more. These  events are organized and stored in            [*topics*](https://kafka.apache.org/documentation/#intro_concepts_and_terms).            Very simplified, a topic is similar to a folder in a filesystem, and the events are the files in that folder.        
示例事件包括付款交易、手机的地理位置更新、发货订单、传感器测量 来自 IoT 设备或医疗设备等等。这些事件被组织和存储在 [*主题* ](https://kafka.apache.org/documentation/#intro_concepts_and_terms)。 非常简单，主题类似于文件系统中的文件夹，事件是该文件夹中的文件。

​            So before you can write your first events, you must create a topic.  Open another terminal session and run:        
因此，在编写第一个事件之前，必须创建一个主题。 打开另一个终端会话并运行：

```bash
$ bin/kafka-topics.sh --create --topic quickstart-events --bootstrap-server localhost:9092
```

​            All of Kafka's command line tools have additional options: run the `kafka-topics.sh` command without any            arguments to display usage information. For example, it can also show you            [details such as the partition count](https://kafka.apache.org/documentation/#intro_concepts_and_terms)            of the new topic:        
Kafka 的所有命令行工具都有额外的选项：运行 `kafka-topics.sh` 命令，没有任何 参数来显示使用信息。例如，它还可以向您展示 [分区计数等详细信息](https://kafka.apache.org/documentation/#intro_concepts_and_terms) 新主题：

```bash
$ bin/kafka-topics.sh --describe --topic quickstart-events --bootstrap-server localhost:9092
Topic: quickstart-events        TopicId: NPmZHyhbR9y00wMglMH2sg PartitionCount: 1       ReplicationFactor: 1	Configs:
Topic: quickstart-events Partition: 0    Leader: 0   Replicas: 0 Isr: 0
```

####                         [Step 4: Write some events into the topic 步骤 4：将一些事件写入主题](https://kafka.apache.org/quickstart#quickstart_send)        

​            A Kafka client communicates with the Kafka brokers via the network for writing (or reading) events.            Once received, the brokers will store the events in a durable and fault-tolerant manner for as long as you            need—even forever.        
Kafka 客户端通过网络与 Kafka 代理通信以写入（或读取）事件。收到事件后，代理将以持久且容错的方式存储事件，只要您需要，甚至可以永远存储。

​            Run the console producer client to write a few events into your topic.            By default, each line you enter will result in a separate event being written to the topic.        
运行控制台创建者客户端，将一些事件写入您的主题中。默认情况下，您输入的每一行都会导致将单独的事件写入主题。

```bash
$ bin/kafka-console-producer.sh --topic quickstart-events --bootstrap-server localhost:9092
>This is my first event
>This is my second event
```

You can stop the producer client with `Ctrl-C` at any time.
您可以随时使用 `Ctrl-C` 停止创建者客户端。

####                         [Step 5: Read the events 步骤 5：读取事件](https://kafka.apache.org/quickstart#quickstart_consume)        

Open another terminal session and run the console consumer client to read the events you just created:
打开另一个终端会话并运行控制台使用者客户端以读取您刚刚创建的事件：

```bash
$ bin/kafka-console-consumer.sh --topic quickstart-events --from-beginning --bootstrap-server localhost:9092
This is my first event
This is my second event
```

You can stop the consumer client with `Ctrl-C` at any time.
您可以随时使用 `Ctrl-C` 停止使用者客户端。

Feel free to experiment: for example, switch back to your producer terminal (previous step) to write            additional events, and see how the events immediately show up in your consumer terminal.
随意尝试：例如，切换回您的生产者终端（上一步）以编写其他事件，并查看事件如何立即显示在您的消费者终端中。

Because events are durably stored in Kafka, they can be read as many times and by as many consumers as you want.            You can easily verify this by opening yet another terminal session and re-running the previous command again.
由于事件持久存储在 Kafka 中，因此您可以根据需要多次读取这些事件，并由任意数量的使用者读取。您可以通过打开另一个终端会话并再次重新运行上一个命令来轻松验证这一点。

####                         [Step 6: Import/export your data as streams of events with Kafka Connect 第 6 步：使用 Kafka Connect 将数据导入/导出为事件流](https://kafka.apache.org/quickstart#quickstart_kafkaconnect)        

​            You probably have lots of data in existing systems like relational databases or traditional messaging systems,            along with many applications that already use these systems.            [Kafka Connect](https://kafka.apache.org/documentation/#connect) allows you to continuously ingest            data from external systems into Kafka, and vice versa. It is an extensible tool that runs            *connectors*, which implement the custom logic for interacting with an external system.            It is thus very easy to integrate existing systems with Kafka. To make this process even easier,            there are hundreds of such connectors readily available.        
您可能在现有系统（如关系数据库或传统消息传递系统）中拥有大量数据。 以及许多已经使用这些系统的应用程序。 [Kafka Connect](https://kafka.apache.org/documentation/#connect) 允许您持续摄取 数据从外部系统到 Kafka，反之亦然。它是一个可扩展的工具，可以运行 *连接器* ，用于实现用于与外部系统交互的自定义逻辑。 因此，将现有系统与 Kafka 集成非常容易。为了使此过程更加简单， 有数百个这样的连接器随时可用。

​            In this quickstart we'll see how to run Kafka Connect with simple connectors that import data            from a file to a Kafka topic and export data from a Kafka topic to a file.        
在本快速入门中，我们将了解如何使用简单的连接器运行 Kafka Connect，这些连接器将数据从文件导入到 Kafka 主题，并将数据从 Kafka 主题导出到文件。

​            First, make sure to add `connect-file-4.0.0.jar` to the `plugin.path` property in the Connect worker's configuration.            For the purpose of this quickstart we'll use a relative path and consider the connectors' package as an uber jar, which works when  the quickstart commands are run from the installation directory.            However, it's worth noting that for production deployments  using absolute paths is always preferable. See [plugin.path](https://kafka.apache.org/documentation/#connectconfigs_plugin.path) for a detailed description of how to set this config.        
首先，确保将 `connect-file-4.0.0.jar` 添加到 Connect 工作程序配置中的 `plugin.path` 属性中。在本快速入门中，我们将使用相对路径，并将连接器的包视为一个 uber jar，当从安装目录运行快速入门命令时，该 jar 将起作用。但是，值得注意的是，对于生产部署，使用绝对路径始终是可取的。有关如何设置此配置的详细说明，请参阅 [plugin.path](https://kafka.apache.org/documentation/#connectconfigs_plugin.path)。

​            Edit the `config/connect-standalone.properties` file, add or change the `plugin.path` configuration property match the following, and save the file:        
编辑 `config/connect-standalone.properties` 文件，添加或更改 `plugin.path` 配置属性，与以下内容匹配，然后保存文件：

```bash
$ echo "plugin.path=libs/connect-file-4.0.0.jar" >> config/connect-standalone.properties
```

​            Then, start by creating some seed data to test with:        
然后，首先创建一些种子数据以进行测试：

```bash
$ echo -e "foo\nbar" > test.txt
```

​        Or on Windows:         或者在 Windows 上：

```bash
$ echo foo > test.txt
$ echo bar >> test.txt
```

​            Next, we'll start two connectors running in *standalone* mode, which means they run in a single, local, dedicated            process. We provide three configuration files as parameters. The first is always the configuration for the Kafka Connect            process, containing common configuration such as the Kafka  brokers to connect to and the serialization format for data.            The remaining configuration files each specify a connector  to create. These files include a unique connector name, the connector            class to instantiate, and any other configuration required  by the connector.        
接下来，我们将启动两个以*独立*模式运行的连接器，这意味着它们在单个本地专用 过程。我们提供了三个配置文件作为参数。第一个始终是 Kafka Connect 的配置 进程，其中包含常见配置，例如要连接的 Kafka 代理和数据序列化格式。 其余配置文件分别指定要创建的连接器。这些文件包括一个唯一的连接器名称，即 类来实例化，以及连接器所需的任何其他配置。

```bash
$ bin/connect-standalone.sh config/connect-standalone.properties config/connect-file-source.properties config/connect-file-sink.properties
```

​            These sample configuration files, included with Kafka, use  the default local cluster configuration you started earlier            and create two connectors: the first is a source connector  that reads lines from an input file and produces each to a Kafka topic            and the second is a sink connector that reads messages from a Kafka topic and produces each as a line in an output file.        
这些示例配置文件（包含在 Kafka 中）使用您之前启动的默认本地集群配置并创建两个连接器：第一个是源连接器，用于从输入文件中读取行并将每个行生成到 Kafka  主题，第二个是接收器连接器，用于从 Kafka 主题读取消息，并将每个消息生成为输出文件中的一行。

​            During startup you'll see a number of log messages,  including some indicating that the connectors are being instantiated.            Once the Kafka Connect process has started, the source  connector should start reading lines from `test.txt` and            producing them to the topic `connect-test`, and the sink connector should start reading messages from the topic `connect-test`            and write them to the file `test.sink.txt`. We can verify the data has been delivered through the entire pipeline            by examining the contents of the output file:        
在启动过程中，您将看到许多日志消息，其中一些消息指示连接器正在实例化。Kafka Connect 进程启动后，源连接器应开始从 `test.txt` 读取行并将其生成到主题 `connect-test`，而接收器连接器应开始从主题 `connect-test` 读取消息并将其写入文件 `test.sink.txt`。我们可以验证数据是否已通过整个管道交付 通过检查输出文件的内容：

```bash
$ more test.sink.txt
foo
bar
```

​            Note that the data is being stored in the Kafka topic `connect-test`, so we can also run a console consumer to see the            data in the topic (or use custom consumer code to process it):        
请注意，数据存储在 Kafka 主题 `connect-test` 中，因此我们还可以运行控制台使用者来查看 data 中（或使用自定义使用者代码对其进行处理）：

```bash
$ bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic connect-test --from-beginning
{"schema":{"type":"string","optional":false},"payload":"foo"}
{"schema":{"type":"string","optional":false},"payload":"bar"}
…
```

The connectors continue to process data, so we can add data to the file and see it move through the pipeline:
连接器继续处理数据，因此我们可以将数据添加到文件中，并查看它在管道中移动：

```bash
$ echo "Another line" >> test.txt
```

You should see the line appear in the console consumer output and in the sink file.
您应该会看到该行出现在控制台使用者输出和 sink 文件中。

####                         [Step 7: Process your events with Kafka Streams 第 7 步：使用 Kafka Streams 处理事件](https://kafka.apache.org/quickstart#quickstart_kafkastreams)        

​            Once your data is stored in Kafka as events, you can process the data with the            [Kafka Streams](https://kafka.apache.org/documentation/streams) client library for Java/Scala.            It allows you to implement mission-critical real-time applications and microservices, where the input            and/or output data is stored in Kafka topics.  Kafka Streams combines the simplicity of writing and deploying            standard Java and Scala applications on the client side with the benefits of Kafka's server-side cluster            technology to make these applications highly scalable, elastic, fault-tolerant, and distributed. The library            supports exactly-once processing, stateful operations and aggregations, windowing, joins, processing based            on event-time, and much more.        
将数据作为事件存储在 Kafka 中后，您可以使用 适用于 Java/Scala 的 [Kafka Streams](https://kafka.apache.org/documentation/streams) 客户端库。 它允许您实施任务关键型实时应用程序和微服务，其中输入 和/或输出数据存储在 Kafka 主题中。 Kafka Streams 结合了编写和部署的简单性 客户端的标准 Java 和 Scala 应用程序，具有 Kafka 服务器端集群的优势 技术使这些应用程序具有高度可扩展性、弹性、容错性和分布式。库 支持恰好一次处理、有状态作和聚合、窗口化、联接、基于处理 在事件时间等等。

To give you a first taste, here's how one would implement the popular `WordCount` algorithm:
为了让您初步体验一下，以下是实现流行的 `WordCount` 算法的方法：

```java
KStream<String, String> textLines = builder.stream("quickstart-events");

KTable<String, Long> wordCounts = textLines
            .flatMapValues(line -> Arrays.asList(line.toLowerCase().split(" ")))
            .groupBy((keyIgnored, word) -> word)
            .count();

wordCounts.toStream().to("output-topic", Produced.with(Serdes.String(), Serdes.Long()));
```

​            The [Kafka Streams demo](https://kafka.apache.org/documentation/streams/quickstart)            and the [app development tutorial](https://kafka.apache.org/40/documentation/streams/tutorial)            demonstrate how to code and run such a streaming application from start to finish.        
[Kafka Streams 演示](https://kafka.apache.org/documentation/streams/quickstart)和[应用程序开发教程](https://kafka.apache.org/40/documentation/streams/tutorial) 演示如何从头到尾编写和运行此类流式处理应用程序。

####                         [Step 8: Terminate the Kafka environment 步骤 8：终止 Kafka 环境](https://kafka.apache.org/quickstart#quickstart_kafkaterminate)        

​            Now that you reached the end of the quickstart, feel free to tear down the Kafka environment—or            continue playing around.        
现在，您已经完成了本快速入门的结尾，您可以随意拆除 Kafka 环境，或者继续尝试。

1. ​                Stop the producer and consumer clients with `Ctrl-C`, if you haven't done so already.            
   使用 `Ctrl-C` 停止创建者和使用者客户端（如果尚未执行此作）。
2. ​                Stop the Kafka broker with `Ctrl-C`.            
   使用 `Ctrl-C` 停止 Kafka 代理。

​            If you also want to delete any data of your local Kafka environment including any events you have created            along the way, run the command:        
如果您还想删除本地 Kafka 环境的任何数据，包括您在此过程中创建的任何事件，请运行以下命令：

```bash
$ rm -rf /tmp/kafka-logs /tmp/kraft-combined-logs
```