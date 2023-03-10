# Elasticsearch

[TOC]

## 概述

Elasticsearch 是一个开源的分布式 RESTful 搜索和分析引擎，能够解决越来越多不同的应用场景。

Elasticsearch 是 Elastic Stack 核心的分布式搜索和分析引擎。Logstash 和 Beats 便于收集、聚合和丰富数据，并将其存储在 Elasticsearch 中。Kibana enables you to interactively explore, visualize, and share insights into your data and manage and monitor the stack. Kibana 使您能够交互式地探索、可视化和共享对数据的见解，并管理和监视堆栈。Elasticsearch is where the indexing, search, and analysis magic happens. Elasticsearch 是索引、搜索和分析的神奇之处。

Elasticsearch 为所有类型的数据提供近乎实时的搜索和分析。Whether you have structured or unstructured text, numerical data, or geospatial data, Elasticsearch can efficiently store and index it in a way that supports fast searches. 无论您拥有结构化或非结构化文本、数字数据或地理空间数据，Elasticsearch都可以以支持快速搜索的方式高效地存储和索引数据。You can go far beyond simple data retrieval and aggregate information to discover trends and patterns in your data. 您可以超越简单的数据检索和聚合信息来发现数据中的趋势和模式。And as your data and query volume grows, the distributed nature of Elasticsearch enables your deployment to grow seamlessly right along with it.随着数据和查询量的增长，Elasticsearch的分布式特性使您的部署能够与之无缝增长。

While not *every* problem is a search problem, Elasticsearch offers speed and flexibility to handle data in a wide variety of use cases:虽然并非所有问题都是搜索问题，但Elasticsearch提供了在各种使用情况下处理数据的速度和灵活性：

- 向应用程序或网站添加搜索框
- Store and analyze logs, metrics, and security event data存储和分析日志、指标和安全事件数据
- Use machine learning to automatically model the behavior of your data in real time使用机器学习实时自动模拟数据的行为
- Automate business workflows using Elasticsearch as a storage engine使用Elasticsearch作为存储引擎自动化业务工作流
- Manage, integrate, and analyze spatial information using Elasticsearch as a geographic information system (GIS)使用Elasticsearch作为地理信息系统（GIS）管理、集成和分析空间信息
- Store and process genetic data using Elasticsearch as a bioinformatics research tool使用Elasticsearch作为生物信息学研究工具存储和处理遗传数据

## Data in: documents and indices数据来源：文件和索引

Elasticsearch is a distributed document store. Instead of storing information as rows of columnar data, Elasticsearch stores complex data structures that have been serialized as JSON documents. When you have multiple Elasticsearch nodes in a cluster, stored documents are distributed across the cluster and can be accessed immediately from any node.

Elasticsearch是一个分布式文档存储。Elasticsearch不是将信息存储为列数据行，而是存储已序列化为JSON文档的复杂数据结构。当集群中有多个Elasticsearch节点时，存储的文档分布在整个集群中，可以从任何节点立即访问。

When a document is stored, it is indexed and fully searchable in [near real-time](https://www.elastic.co/guide/en/elasticsearch/reference/current/near-real-time.html)--within 1 second. Elasticsearch uses a data structure called an inverted index that supports very fast full-text searches. An inverted index lists every unique word that appears in any document and identifies all of the documents each word occurs in.

当一个文档被存储时，它会被索引，并且可以在1秒内几乎实时地完全搜索。Elasticsearch使用一种称为反向索引的数据结构，支持非常快速的全文搜索。反向索引列出了任何文档中出现的每个唯一单词，并标识了每个单词所在的所有文档。

索引可以被认为是文档的优化集合，每个文档都是字段的集合，这些字段是包含数据的键值对。默认情况下，Elasticsearch索引每个字段中的所有数据，每个索引字段都有一个专用的优化数据结构。例如，文本字段存储在反向索引中，数字和地理字段存储在BKD树中。使用每个字段数据结构来组合和返回搜索结果的能力使Elasticsearch如此快速。

An index can be thought of as an optimized collection of documents and each document is a collection of fields, which are the key-value pairs that contain your data. By default, Elasticsearch indexes all data in every field and each indexed field has a dedicated, optimized data structure. For example, text fields are stored in inverted indices, and numeric and geo fields are stored in BKD trees. The ability to use the per-field data structures to assemble and return search results is what makes Elasticsearch so fast.

Elasticsearch also has the ability to be schema-less, which means that documents can be indexed without explicitly specifying how to handle each of the different fields that might occur in a document. When dynamic mapping is enabled, Elasticsearch automatically detects and adds new fields to the index. This default behavior makes it easy to index and explore your data—just start indexing documents and Elasticsearch will detect and map booleans, floating point and integer values, dates, and strings to the appropriate Elasticsearch data types.

Elasticsearch还具有无模式的能力，这意味着可以对文档进行索引，而无需明确指定如何处理文档中可能出现的每个不同字段。启用动态映射后，Elasticsearch会自动检测并向索引中添加新字段。这种默认行为可以方便地索引和浏览数据-只要开始索引文档，Elasticsearch就会检测布尔值、浮点值和整数值、日期和字符串，并将其映射到相应的Elasticsearch数据类型。

然而，最终，您比Elasticsearch更了解您的数据以及如何使用它。您可以定义规则来控制动态映射，并显式定义映射来完全控制字段的存储和索引方式。

Ultimately, however, you know more about your data and how you want to use it than Elasticsearch can. You can define rules to control dynamic mapping and explicitly define mappings to take full control of how fields are stored and indexed.

Defining your own mappings enables you to:定义自己的映射使您能够：

- Distinguish between full-text string fields and exact value string fields区分全文字符串字段和精确值字符串字段
- Perform language-specific text analysis执行特定语言的文本分析
- Optimize fields for partial matching优化字段以进行部分匹配
- Use custom date formats使用自定义日期格式
- Use data types such as `geo_point` and `geo_shape` that cannot be automatically detected使用无法自动检测的数据类型，如地理点和地理形状

It’s often useful to index the same field in different ways for different purposes. For example, you might want to index a string field as both a text field for full-text search and as a keyword field for sorting or aggregating your data. Or, you might choose to use more than one language analyzer to process the contents of a string field that contains user input.

为不同的目的以不同的方式索引同一字段通常很有用。例如，您可能希望将字符串字段索引为全文搜索的文本字段和排序或聚合数据的关键字字段。或者，您可以选择使用多个语言分析器来处理包含用户输入的字符串字段的内容。

在索引期间应用于全文字段的分析链也在搜索时使用。查询全文字段时，在索引中查找术语之前，查询文本将进行相同的分析。

The analysis chain that is applied to a full-text field during indexing is also used at search time. When you query a full-text field, the query text undergoes the same analysis before the terms are looked up in the index.

## Information out: search and analyze信息输出：搜索和分析

While you can use Elasticsearch as a document store and retrieve documents and their metadata, the real power comes from being able to easily access the full suite of search capabilities built on the Apache Lucene search engine library.

Elasticsearch provides a simple, coherent REST API for managing your cluster and indexing and searching your data. For testing purposes, you can easily submit requests directly from the command line or through the Developer Console in Kibana. From your applications, you can use the [Elasticsearch client](https://www.elastic.co/guide/en/elasticsearch/client/index.html) for your language of choice: Java, JavaScript, Go, .NET, PHP, Perl, Python or Ruby.

#### Searching your data[edit](https://github.com/elastic/elasticsearch/edit/8.6/docs/reference/intro.asciidoc)

The Elasticsearch REST APIs support structured queries, full text queries, and complex queries that combine the two. Structured queries are similar to the types of queries you can construct in SQL. For example, you could search the `gender` and `age` fields in your `employee` index and sort the matches by the `hire_date` field. Full-text queries find all documents that match the query string and return them sorted by *relevance*—how good a match they are for your search terms.

In addition to searching for individual terms, you can perform phrase searches, similarity searches, and prefix searches, and get autocomplete suggestions.

Have geospatial or other numerical data that you want to search? Elasticsearch indexes non-textual data in optimized data structures that support high-performance geo and numerical queries.

You can access all of these search capabilities using Elasticsearch’s comprehensive JSON-style query language ([Query DSL](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html)). You can also construct [SQL-style queries](https://www.elastic.co/guide/en/elasticsearch/reference/current/sql-overview.html) to search and aggregate data natively inside Elasticsearch, and JDBC and ODBC drivers enable a broad range of third-party applications to interact with Elasticsearch via SQL.

#### Analyzing your data[edit](https://github.com/elastic/elasticsearch/edit/8.6/docs/reference/intro.asciidoc)

Elasticsearch aggregations enable you to build complex summaries of your data and gain insight into key metrics, patterns, and trends. Instead of just finding the proverbial “needle in a haystack”, aggregations enable you to answer questions like:

- How many needles are in the haystack?
- What is the average length of the needles?
- What is the median length of the needles, broken down by manufacturer?
- How many needles were added to the haystack in each of the last six months?

You can also use aggregations to answer more subtle questions, such as:

- What are your most popular needle manufacturers?
- Are there any unusual or anomalous clumps of needles?

Because aggregations leverage the same data-structures used for search, they are also very fast. This enables you to analyze and visualize your data in real time. Your reports and dashboards update as your data changes so you can take action based on the latest information.

What’s more, aggregations operate alongside search requests. You can search documents, filter results, and perform analytics at the same time, on the same data, in a single request. And because aggregations are calculated in the context of a particular search, you’re not just displaying a count of all size 70 needles, you’re displaying a count of the size 70 needles that match your users' search criteria—for example, all size 70 *non-stick embroidery* needles.

##### But wait, there’s more[edit](https://github.com/elastic/elasticsearch/edit/8.6/docs/reference/intro.asciidoc)

Want to automate the analysis of your time series data? You can use [machine learning](https://www.elastic.co/guide/en/machine-learning/8.6/ml-ad-overview.html) features to create accurate baselines of normal behavior in your data and identify anomalous patterns. With machine learning, you can detect:

- Anomalies related to temporal deviations in values, counts, or frequencies
- Statistical rarity
- Unusual behaviors for a member of a population

And the best part? You can do this without having to specify algorithms, models, or other data science-related configurations.



虽然您可以将Elasticsearch用作文档存储和检索文档及其元数据，但真正的强大之处在于能够轻松访问构建在ApacheLucene搜索引擎库上的全套搜索功能。

Elasticsearch为管理集群、索引和搜索数据提供了一个简单、一致的REST  API。出于测试目的，您可以直接从命令行或通过Kibana中的开发人员控制台轻松提交请求。在您的应用程序中，您可以使用Elasticsearch客户端来选择您的语言：Java、Java Script、Go、.NET、PHP、Perl、Python或Ruby。

搜索您的数据

编辑

Elasticsearch REST  API支持结构化查询、全文查询和将两者结合起来的复杂查询。结构化查询与您可以在SQL中构造的查询类型相似。例如，您可以搜索员工索引中的性别和年龄字段，并根据雇用日期字段对匹配项进行排序。全文查询查找与查询字符串匹配的所有文档，并按相关性排序返回它们与搜索词的匹配程度。

除了搜索单个术语外，还可以执行短语搜索、相似度搜索和前缀搜索，并获得自动完成的建议。

是否有要搜索的地理空间或其他数字数据？Elasticsearch在支持高性能地理和数字查询的优化数据结构中索引非文本数据。

您可以使用Elasticsearch的全面JSON风格查询语言（QueryDSL）访问所有这些搜索功能。您还可以构造SQL风格的查询，以在Elasticsearch内部本地搜索和聚合数据，JDBC和ODBC驱动程序使广泛的第三方应用程序能够通过SQL与Elasticsearch交互。

分析您的数据

编辑

Elasticsearch聚合使您能够构建数据的复杂摘要，并深入了解关键指标、模式和趋势。聚合使您能够回答以下问题，而不仅仅是找到众所周知的“大海捞针”：

干草堆里有多少针？

针的平均长度是多少？

按制造商细分的针的中间长度是多少？

在过去的六个月里，每一个月有多少针被添加到干草堆中？

您还可以使用聚合来回答更微妙的问题，例如：

你最受欢迎的针头制造商是什么？

是否有异常或异常的针丛？

由于聚合利用了用于搜索的相同数据结构，因此聚合速度也非常快。这使您能够实时分析和可视化数据。您的报告和仪表板会随着数据的变化而更新，因此您可以根据最新信息采取行动。

此外，聚合与搜索请求一起运行。您可以在单个请求中搜索文档、过滤结果并同时对同一数据执行分析。由于聚合是在特定搜索的上下文中计算的，因此您不仅显示了所有大小为70针的计数，还显示了符合用户搜索条件的大小为70的针的计数-例如所有尺寸的70个不粘绣花针。

等等，还有更多

编辑

想自动分析时间序列数据吗？您可以使用机器学习功能在数据中创建正常行为的准确基线，并识别异常模式。通过机器学习，您可以检测到：

与值、计数或频率的时间偏差相关的异常

统计罕见度

群体成员的异常行为

最好的部分是什么？您可以这样做，而不必指定算法、模型或其他与数据科学相关的配置。

## Scalability and resilience: clusters, nodes, and shards[edit](https://github.com/elastic/elasticsearch/edit/8.6/docs/reference/intro.asciidoc)

Elasticsearch is built to be always available and to scale with your needs. It does this by being distributed by nature. You can add servers (nodes) to a cluster to increase capacity and Elasticsearch automatically distributes your data and query load across all of the available nodes. No need to overhaul your application, Elasticsearch knows how to balance multi-node clusters to provide scale and high availability. The more nodes, the merrier.

How does this work? Under the covers, an Elasticsearch index is really just a logical grouping of one or more physical shards, where each shard is actually a self-contained index. By distributing the documents in an index across multiple shards, and distributing those shards across multiple nodes, Elasticsearch can ensure redundancy, which both protects against hardware failures and increases query capacity as nodes are added to a cluster. As the cluster grows (or shrinks), Elasticsearch automatically migrates shards to rebalance the cluster.

There are two types of shards: primaries and replicas. Each document in an index belongs to one primary shard. A replica shard is a copy of a primary shard. Replicas provide redundant copies of your data to protect against hardware failure and increase capacity to serve read requests like searching or retrieving a document.

The number of primary shards in an index is fixed at the time that an index is created, but the number of replica shards can be changed at any time, without interrupting indexing or query operations.

#### It depends…[edit](https://github.com/elastic/elasticsearch/edit/8.6/docs/reference/intro.asciidoc)

There are a number of performance considerations and trade offs with respect to shard size and the number of primary shards configured for an index. The more shards, the more overhead there is simply in maintaining those indices. The larger the shard size, the longer it takes to move shards around when Elasticsearch needs to rebalance a cluster.

Querying lots of small shards makes the processing per shard faster, but more queries means more overhead, so querying a smaller number of larger shards might be faster. In short…it depends.

As a starting point:

- Aim to keep the average shard size between a few GB and a few tens of GB. For use cases with time-based data, it is common to see shards in the 20GB to 40GB range.
- Avoid the gazillion shards problem. The number of shards a node can hold is proportional to the available heap space. As a general rule, the number of shards per GB of heap space should be less than 20.

The best way to determine the optimal configuration for your use case is through [ testing with your own data and queries](https://www.elastic.co/elasticon/conf/2016/sf/quantitative-cluster-sizing).

#### In case of disaster[edit](https://github.com/elastic/elasticsearch/edit/8.6/docs/reference/intro.asciidoc)

A cluster’s nodes need good, reliable connections to each other. To provide better connections, you typically co-locate the nodes in the same data center or nearby data centers. However, to maintain high availability, you also need to avoid any single point of failure. In the event of a major outage in one location, servers in another location need to be able to take over. The answer? Cross-cluster replication (CCR).

CCR provides a way to automatically synchronize indices from your primary cluster to a secondary remote cluster that can serve as a hot backup. If the primary cluster fails, the secondary cluster can take over. You can also use CCR to create secondary clusters to serve read requests in geo-proximity to your users.

Cross-cluster replication is active-passive. The index on the primary cluster is the active leader index and handles all write requests. Indices replicated to secondary clusters are read-only followers.

#### Care and feeding[edit](https://github.com/elastic/elasticsearch/edit/8.6/docs/reference/intro.asciidoc)

As with any enterprise system, you need tools to secure, manage, and monitor your Elasticsearch clusters. Security, monitoring, and administrative features that are integrated into Elasticsearch enable you to use [Kibana](https://www.elastic.co/guide/en/kibana/8.6/introduction.html) as a control center for managing a cluster. Features like [data rollups](https://www.elastic.co/guide/en/elasticsearch/reference/current/xpack-rollup.html) and [index lifecycle management](https://www.elastic.co/guide/en/elasticsearch/reference/current/index-lifecycle-management.html) help you intelligently manage your data over time.

可扩展性和弹性：集群、节点和碎片

编辑

Elasticsearch旨在随时可用，并根据您的需求进行扩展。它是通过自然分布来实现的。您可以将服务器（节点）添加到集群以增加容量，Elasticsearch会自动将数据和查询负载分配到所有可用节点。Elasticsearch知道如何平衡多节点集群以提供规模和高可用性，无需对应用程序进行全面检查。节点越多，越快乐。

这是如何工作的？在封面下，Elasticsearch索引实际上只是一个或多个物理碎片的逻辑分组，其中每个碎片实际上是一个独立的索引。通过将文档分布在索引中的多个碎片上，并将这些碎片分布在多个节点上，Elasticsearch可以确保冗余，这既可以防止硬件故障，又可以在节点添加到集群时增加查询容量。随着集群的增长（或收缩），Elasticsearch会自动迁移碎片以重新平衡集群。

有两种类型的碎片：主碎片和副本碎片。索引中的每个文档都属于一个主碎片。副本碎片是主碎片的副本。副本提供了数据的冗余副本，以防止硬件故障，并增加了处理读取请求（如搜索或检索文档）的能力。

创建索引时，索引中主碎片的数量是固定的，但副本碎片的数量可以随时更改，而不会中断索引或查询操作。

这取决于…

编辑

在碎片大小和为索引配置的主碎片数量方面，存在许多性能考虑和权衡。碎片越多，维护这些索引的开销就越大。碎片大小越大，当Elasticsearch需要重新平衡集群时，移动碎片所需的时间就越长。

查询大量的小碎片可以使每个碎片的处理速度更快，但更多的查询意味着更多的开销，因此查询更少数量的大碎片可能会更快。简而言之…这取决于。

作为起点：

目标是将平均碎片大小保持在几GB到几十GB之间。对于使用基于时间的数据的用例，通常会看到20GB到40GB范围内的碎片。

避免大量碎片问题。节点可以容纳的碎片数量与可用堆空间成比例。一般来说，每GB堆空间的碎片数应该少于20个。

确定用例最佳配置的最佳方法是使用自己的数据和查询进行测试。

发生灾难时

编辑

集群的节点之间需要良好、可靠的连接。为了提供更好的连接，通常将节点放在同一数据中心或附近的数据中心。然而，为了保持高可用性，您还需要避免任何单点故障。在一个位置发生重大故障时，另一个位置的服务器需要能够接管。答案是什么？跨群集复制（CCR）。

CCR提供了一种将索引从主群集自动同步到可作为热备份的辅助远程群集的方法。如果主群集发生故障，则辅助群集可以接管。您还可以使用CCR创建辅助集群，以在地理位置接近您的用户时提供读取请求。

跨群集复制是主动-被动的。主集群上的索引是活动的前导索引，并处理所有写入请求。复制到辅助群集的索引是只读跟随者。

护理和喂养

编辑

与任何企业系统一样，您需要工具来保护、管理和监视Elasticsearch集群。集成到Elasticsearch中的安全、监控和管理功能使您能够将Kibana用作管理集群的控制中心。数据汇总和索引生命周期管理等功能可帮助您随时间智能地管理数据。

# Set up Elasticsearch[edit](https://github.com/elastic/elasticsearch/edit/8.6/docs/reference/setup.asciidoc)

This section includes information on how to setup Elasticsearch and get it running, including:

- Downloading
- Installing
- Starting
- Configuring

## Supported platforms[edit](https://github.com/elastic/elasticsearch/edit/8.6/docs/reference/setup.asciidoc)

The matrix of officially supported operating systems and JVMs is available here: [Support Matrix](https://www.elastic.co/support/matrix). Elasticsearch is tested on the listed platforms, but it is possible that it will work on other platforms too.

## Java (JVM) Version[edit](https://github.com/elastic/elasticsearch/edit/8.6/docs/reference/setup.asciidoc)

Elasticsearch is built using Java, and includes a bundled version of [OpenJDK](https://openjdk.java.net) from the JDK maintainers (GPLv2+CE) within each distribution. The bundled JVM is the recommended JVM and is located within the `jdk` directory of the Elasticsearch home directory.

To use your own version of Java, set the `ES_JAVA_HOME` environment variable. If you must use a version of Java that is different from the bundled JVM, we recommend using a [supported](https://www.elastic.co/support/matrix) [LTS version of Java](https://www.oracle.com/technetwork/java/eol-135779.html). Elasticsearch will refuse to start if a known-bad version of Java is used. The bundled JVM directory may be removed when using your own JVM.

## Use dedicated hosts[edit](https://github.com/elastic/elasticsearch/edit/8.6/docs/reference/setup.asciidoc)

In production, we recommend you run Elasticsearch on a dedicated host or as a primary service. Several Elasticsearch features, such as automatic JVM heap sizing, assume it’s the only resource-intensive application on the host or container. For example, you might run Metricbeat alongside Elasticsearch for cluster statistics, but a resource-heavy Logstash deployment should be on its own host.

设置Elasticsearch

编辑

本节包含有关如何设置Elasticsearch并使其运行的信息，包括：

正在下载

正在安装

启动

正在配置

支持的平台

编辑

官方支持的操作系统和JVM的矩阵可在此处获得：Support matrix。Elasticsearch在列出的平台上进行了测试，但它也可能在其他平台上运行。

Java（JVM）版本

编辑

Elasticsearch使用Java构建，并在每个发行版中包含JDK维护者（GPLv2+CE）提供的OpenJDK捆绑版本。捆绑的JVM是推荐的JVM，位于Elasticsearch主目录的jdk目录中。

要使用自己版本的Java，请设置ES Java  HOME环境变量。如果必须使用与捆绑JVM不同的Java版本，我们建议使用受支持的LTS版本的Java。如果使用了已知的Java坏版本，Elasticsearch将拒绝启动。使用您自己的JVM时，可能会删除捆绑的JVM目录。

使用专用主机

编辑

在生产中，我们建议您在专用主机上或作为主要服务运行Elasticsearch。几个Elasticsearch特性，例如自动调整JVM堆大小，假设它是主机或容器上唯一的资源密集型应用程序。例如，您可以与Elasticsearch一起运行Metricbeat以获取集群统计信息，但资源密集的Logstash部署应该在自己的主机上。

[Elastic Docs](https://www.elastic.co/guide/)› [Elasticsearch Guide [8.6\]](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)› [Set up Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/setup.html)

## Installing Elasticsearch[edit](https://github.com/elastic/elasticsearch/edit/8.6/docs/reference/setup/install.asciidoc)

### Hosted Elasticsearch Service[edit](https://github.com/elastic/elasticsearch/edit/8.6/docs/reference/setup/install.asciidoc)

Elastic Cloud offers all of the features of Elasticsearch, Kibana,  and  Elastic’s Observability, Enterprise Search, and Elastic Security  solutions as a hosted service available on AWS, GCP, and Azure.

To set up Elasticsearch in Elastic Cloud, sign up for a [free Elastic Cloud trial](https://www.elastic.co/cloud/elasticsearch-service/signup?baymax=docs-body&elektra=docs).

### Self-managed Elasticsearch options[edit](https://github.com/elastic/elasticsearch/edit/8.6/docs/reference/setup/install.asciidoc)

If you want to install and manage Elasticsearch yourself, you can:

- Run Elasticsearch on any Linux, MacOS, or Windows machine.
- Run Elasticsearch in a [Docker container](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html).
- Set up and manage Elasticsearch, Kibana, Elastic Agent, and the rest of the Elastic Stack on Kubernetes with [Elastic Cloud on Kubernetes](https://www.elastic.co/guide/en/cloud-on-k8s/current).

To try out Elasticsearch on your own machine, we recommend using  Docker and running both Elasticsearch and Kibana. For more information,  see [Run Elasticsearch locally](https://www.elastic.co/guide/en/elasticsearch/reference/current/run-elasticsearch-locally.html).

### Elasticsearch install packages[edit](https://github.com/elastic/elasticsearch/edit/8.6/docs/reference/setup/install.asciidoc)

Elasticsearch is provided in the following package formats:

| Linux and MacOS `tar.gz` archives | The `tar.gz` archives are available for installation on any Linux distribution and MacOS. [Install Elasticsearch from archive on Linux or MacOS](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html) |
| --------------------------------- | ------------------------------------------------------------ |
| Windows `.zip` archive            | The `zip` archive is suitable for installation on Windows. [Install Elasticsearch with `.zip` on Windows](https://www.elastic.co/guide/en/elasticsearch/reference/current/zip-windows.html) |
| `deb`                             | The `deb` package is suitable for Debian, Ubuntu, and other Debian-based systems. Debian packages may be downloaded from the Elasticsearch website or from our Debian repository. [Install Elasticsearch with Debian Package](https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html) |
| `rpm`                             | The `rpm` package is suitable for installation on Red Hat, Centos, SLES, OpenSuSE and other RPM-based systems. RPMs may be downloaded from the Elasticsearch website or from our RPM repository. [Install Elasticsearch with RPM](https://www.elastic.co/guide/en/elasticsearch/reference/current/rpm.html) |
| `docker`                          | Images are available for running Elasticsearch as Docker containers. They may be downloaded from the Elastic Docker Registry. [Install Elasticsearch with Docker](https://www.elastic.co/guide/en/elasticsearch/reference/8.6/docker.html) |

Elastic Docs›Elasticsearch指南[8.6]›设置Elasticsearch

安装Elasticsearch

编辑

托管Elasticsearch服务

编辑

ElasticCloud提供Elasticsearch、Kibana和Elastic's Observability、Enterprise Search和Elastic Security解决方案的所有功能，作为AWS、GCP和Azure上的托管服务。

要在ElasticCloud中设置Elasticsearch，请注册免费的Elasticcloud试用版。

自我管理的Elasticsearch选项

编辑

如果您想自己安装和管理Elasticsearch，您可以：

在任何Linux、Mac OS或Windows计算机上运行Elasticsearch。

在Docker容器中运行Elasticsearch。

在Kubernetes上使用ElasticCloud设置和管理Elasticsearch、Kibana、ElasticAgent以及ElasticStack的其余部分。

要在自己的机器上试用Elasticsearch，我们建议使用Docker并同时运行Elasticearch和Kibana。有关详细信息，请参阅本地运行Elasticsearch。

Elasticsearch安装包

编辑

Elasticsearch以以下包格式提供：

Linux和Mac OS tar.gz存档

tar.gz存档可在任何Linux发行版和Mac OS上安装。

在Linux或Mac OS上从存档安装Elasticsearch

Windows.zip存档

zip存档适合安装在Windows上。

在Windows上使用.zip安装Elasticsearch

债务，债务

deb包适用于Debian、Ubuntu和其他基于Debian的系统。Debian软件包可以从Elasticsearch网站或Debian存储库下载。

使用Debian软件包安装Elasticsearch

每分钟转数

rpm软件包适用于安装在Red Hat、Centos、SLES、Open Su SE和其他基于rpm的系统上。RPM可以从Elasticsearch网站或RPM存储库下载。

使用RPM安装Elasticsearch

码头装卸工

图像可用于作为Docker容器运行Elasticsearch。它们可以从Elastic Docker注册表下载。

使用Docker安装Elasticsearch