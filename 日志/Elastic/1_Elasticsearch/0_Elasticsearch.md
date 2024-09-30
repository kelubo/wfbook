# Elasticsearch

[TOC]

## 概述

Elasticsearch 是一个基于 Apache Lucene 构建的分布式搜索和分析引擎、可扩展数据存储和矢量数据库。它针对生产规模工作负载的速度和相关性进行了优化。使用 Elasticsearch 近乎实时地搜索、索引、存储和分析各种形状和大小的数据。

Elasticsearch 为所有类型的数据提供近乎实时的搜索和分析。无论您拥有结构化或非结构化文本、数字数据或地理空间数据，Elasticsearch 都可以以支持快速搜索的方式高效地存储和索引数据。You can go far beyond simple data retrieval and aggregate information to discover trends and patterns in your data. 您可以超越简单的数据检索和聚合信息来发现数据中的趋势和模式。随着数据和查询量的增长，Elasticsearch 的分布式特性使您的部署能够与之无缝增长。

It’s optimized for speed and relevance on production-scale workloads. Use Elasticsearch to search, index, store, and analyze data of all shapes and sizes in near real time.它针对生产规模工作负载的速度和相关性进行了优化。使用 Elasticsearch 近乎实时地搜索、索引、存储和分析所有形状和大小的数据。

虽然并非所有问题都是搜索问题，但 Elasticsearch 提供了在各种使用情况下处理数据的速度和灵活性：

- 向应用程序或网站添加搜索框。
- 存储和分析日志、指标和安全事件数据。
- Use machine learning to automatically model the behavior of your data in real time使用机器学习实时自动模拟数据的行为。
- 使用 Elasticsearch 作为存储引擎自动化业务工作流。
- Manage, integrate, and analyze spatial information using Elasticsearch as a geographic information system (GIS)使用 Elasticsearch 作为地理信息系统（GIS）管理、集成和分析空间信息。
- Store and process genetic data using Elasticsearch as a bioinformatics research tool使用 Elasticsearch 作为生物信息学研究工具存储和处理遗传数据。

Elasticsearch 用于广泛且不断增长的用例。以下是一些示例：

- **监视日志和事件数据**：存储日志、指标和事件数据以实现可观察性以及安全信息和事件管理 (SIEM)。
- **Build search applications**: Add search capabilities to apps or websites, or build search engines over internal data. 
  **构建搜索应用程序**：向应用程序或网站添加搜索功能，或基于内部数据构建搜索引擎。
- **Vector database**: Store and search vectorized data, and create vector embeddings with  built-in and third-party natural language processing (NLP) models. 
  **矢量数据库**：存储和搜索矢量化数据，并使用内置和第三方自然语言处理（NLP）模型创建矢量嵌入。
- **Retrieval augmented generation (RAG)**: Use Elasticsearch as a retrieval engine to augment generative AI models. 
  **检索增强生成 (RAG)** ：使用 Elasticsearch 作为检索引擎来增强生成式 AI 模型。
- **Application and security monitoring**: Monitor and analyze application performance and security data. 
  **应用程序和安全监控**：监控和分析应用程序性能和安全数据。
- **Machine learning**: Use machine learning to automatically model the behavior of your data in real-time. 
  **机器学习**：使用机器学习实时自动建模数据的行为。

## 索引、文档和字段

The index is the fundamental unit of storage in Elasticsearch, a logical  namespace for storing data that share similar characteristics. 索引是 Elasticsearch 中的基本存储单元，是一个用于存储具有相似特征的数据的逻辑命名空间。部署 Elasticsearch 后，将开始创建索引来存储数据。

一个密切相关的概念是**数据流**。This index abstraction is optimized for append-only time-series data, and is made up of hidden, auto-generated backing indices. 该索引抽象针对仅附加时间序列数据进行了优化，并由隐藏的自动生成的支持索引组成。如果正在处理时间序列数据，我们建议使用 [Elastic Observability](https://www.elastic.co/guide/en/observability/8.15) 解决方案。

有关索引的一些关键事实：

- 索引是文档的集合。
- 索引有唯一的名称。
- 索引也可以通过别名引用。
- An index has a mapping that defines the schema of its documents 
  索引具有定义其文档架构的映射

### 文档和字段

Elasticsearch serializes and stores data in the form of JSON documents. A document is a set of fields, which are key-value pairs that contain your data. Each document has a unique ID, which you can create or have Elasticsearch auto-generate.
Elasticsearch 以 JSON 文档的形式序列化和存储数据。文档是一组字段，它们是包含数据的键值对。每个文档都有一个唯一的 ID，您可以创建该 ID 或让 Elasticsearch 自动生成该 ID。

一个简单的 Elasticsearch 文档可能如下所示：

```js
{
  "_index": "my-first-elasticsearch-index",
  "_id": "DyFpo5EBxE8fzbb95DOa",
  "_version": 1,
  "_seq_no": 0,
  "_primary_term": 1,
  "found": true,
  "_source": {
    "email": "john@smith.com",
    "first_name": "John",
    "last_name": "Smith",
    "info": {
      "bio": "Eco-warrior and defender of the weak",
      "age": 25,
      "interests": [
        "dolphins",
        "whales"
      ]
    },
    "join_date": "2024/05/01"
  }
}
```

### 数据和元数据

索引文档包含数据和元数据。在 Elasticsearch 中，元数据字段以下划线为前缀。

The most important metadata fields are:
最重要的元数据字段是：

- `_source`: Contains the original JSON document. 
  `_source` ：包含原始 JSON 文档。
- `_index`: The name of the index where the document is stored. 
  `_index` ：存储文档的索引的名称。
- `_id`: The document’s ID. IDs must be unique per index. 
  `_id` ：文档的 ID。每个索引的 ID 必须是唯一的。

### 映射和数据类型

Each index has a [mapping](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping.html) or schema for how the fields in your documents are indexed. A mapping defines the [data type](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html) for each field, how the field should be indexed, and how it should be stored. When adding documents to Elasticsearch, you have two options for mappings:
每个索引都有一个[映射](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping.html)或架构，用于说明如何对文档中的字段建立索引。映射定义每个字段的[数据类型](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html)、字段应如何索引以及应如何存储。将文档添加到 Elasticsearch 时，您有两种映射选项：

- [Dynamic mapping](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping.html#mapping-dynamic): Let Elasticsearch automatically detect the data types and create the  mappings for you. This is great for getting started quickly, but can  lead to unexpected results for complex data. 
  [动态映射](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping.html#mapping-dynamic)：让 Elasticsearch 自动检测数据类型并为您创建映射。这非常适合快速入门，但可能会导致复杂数据出现意外结果。
- [Explicit mapping](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping.html#mapping-explicit): Define the mappings up front by specifying data types for each field.  Recommended for production use cases, because you have much more control over how your data is indexed. 
  [显式映射](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping.html#mapping-explicit)：通过指定每个字段的数据类型来预先定义映射。推荐用于生产用例，因为您可以更好地控制数据的索引方式。

You can use a combination of dynamic and explicit mapping on the same index. This is useful when you have a mix of known and unknown fields in your data.
您可以在同一索引上结合使用动态映射和显式映射。当数据中混合有已知和未知字段时，这非常有用。

## 搜索和分析

While you can use Elasticsearch as a document store and retrieve documents and their metadata, the real power comes from being able to easily access the full suite of search capabilities built on the Apache Lucene search engine library.
虽然您可以使用 Elasticsearch 作为文档存储并检索文档及其元数据，但真正的强大之处在于能够轻松访问基于 Apache Lucene 搜索引擎库构建的全套搜索功能。

Elasticsearch provides a simple, coherent REST API for managing your cluster and indexing and searching your data. For testing purposes, you can easily submit requests directly from the command line or through the Developer Console in Kibana. From your applications, you can use the [Elasticsearch client](https://www.elastic.co/guide/en/elasticsearch/client/index.html) for your language of choice: Java, JavaScript, Go, .NET, PHP, Perl, Python or Ruby.
Elasticsearch 提供了一个简单、一致的 REST API，用于管理集群以及索引和搜索数据。出于测试目的，您可以直接从命令行或通过 Kibana 中的开发者控制台轻松提交请求。在您的应用程序中，您可以使用适合您选择的语言的[Elasticsearch 客户端](https://www.elastic.co/guide/en/elasticsearch/client/index.html)：Java、JavaScript、Go、.NET、PHP、Perl、Python 或 Ruby。

### Searching your data 搜索您的数据

The Elasticsearch REST APIs support structured queries, full text queries, and complex queries that combine the two. Structured queries are similar to the types of queries you can construct in SQL. For example, you could search the `gender` and `age` fields in your `employee` index and sort the matches by the `hire_date` field. Full-text queries find all documents that match the query string and return them sorted by *relevance*—how good a match they are for your search terms.
Elasticsearch REST API 支持结构化查询、全文查询以及两者结合的复杂查询。结构化查询类似于您可以在 SQL 中构造的查询类型。例如，您可以搜索`employee`索引中的`gender`和`age`字段，并按`hire_date`字段对匹配项进行排序。全文查询查找与查询字符串匹配的所有文档，并返回按*相关性排序的*文档 - 它们与您的搜索词的匹配程度。

In addition to searching for individual terms, you can perform phrase searches, similarity searches, and prefix searches, and get autocomplete suggestions.
除了搜索单个术语之外，您还可以执行短语搜索、相似性搜索和前缀搜索，并获得自动完成建议。

Have geospatial or other numerical data that you want to search? Elasticsearch indexes non-textual data in optimized data structures that support high-performance geo and numerical queries.
您有要搜索的地理空间或其他数字数据吗？ Elasticsearch 在支持高性能地理和数字查询的优化数据结构中索引非文本数据。

You can access all of these search capabilities using Elasticsearch’s comprehensive JSON-style query language ([Query DSL](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html)). You can also construct [SQL-style queries](https://www.elastic.co/guide/en/elasticsearch/reference/current/sql-overview.html) to search and aggregate data natively inside Elasticsearch, and JDBC and ODBC drivers enable a broad range of third-party applications to interact with Elasticsearch via SQL.
您可以使用 Elasticsearch 的综合 JSON 式查询语言 ( [Query DSL](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html) ) 访问所有这些搜索功能。您还可以构建[SQL 样式的查询](https://www.elastic.co/guide/en/elasticsearch/reference/current/sql-overview.html)来在 Elasticsearch 内部本地搜索和聚合数据，并且 JDBC 和 ODBC 驱动程序使各种第三方应用程序能够通过 SQL 与 Elasticsearch 进行交互。

### Analyzing your data 分析您的数据

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/intro.asciidoc)

Elasticsearch aggregations enable you to build complex summaries of your data and gain insight into key metrics, patterns, and trends. Instead of just finding the proverbial “needle in a haystack”, aggregations enable you to answer questions like:
Elasticsearch 聚合使您能够构建复杂的数据摘要并深入了解关键指标、模式和趋势。聚合不仅仅是寻找众所周知的“大海捞针”，还可以让您回答以下问题：

- How many needles are in the haystack? 
  大海捞针有多少根？
- What is the average length of the needles? 
  针的平均长度是多少？
- What is the median length of the needles, broken down by manufacturer? 
  按制造商细分的针的平均长度是多少？
- How many needles were added to the haystack in each of the last six months? 
  过去六个月每年大海捞针有多少？

You can also use aggregations to answer more subtle questions, such as:
您还可以使用聚合来回答更微妙的问题，例如：

- What are your most popular needle manufacturers? 
  您最受欢迎的针制造商是哪些？
- Are there any unusual or anomalous clumps of needles? 
  是否有任何不寻常或异常的针丛？

Because aggregations leverage the same data-structures used for search, they are also very fast. This enables you to analyze and visualize your data in real time. Your reports and dashboards update as your data changes so you can take action based on the latest information.
由于聚合利用与搜索相同的数据结构，因此它们也非常快。这使您能够实时分析和可视化数据。您的报告和仪表板会随着数据的变化而更新，以便您可以根据最新信息采取行动。

What’s more, aggregations operate alongside search requests. You can search documents, filter results, and perform analytics at the same time, on the same data, in a single request. And because aggregations are calculated in the context of a particular search, you’re not just displaying a count of all size 70 needles, you’re displaying a count of the size 70 needles that match your users' search criteria—for example, all size 70 *non-stick embroidery* needles.
此外，聚合与搜索请求一起运行。您可以在单个请求中同时对相同数据搜索文档、筛选结果和执行分析。由于聚合是在特定搜索的上下文中计算的，因此您不仅显示所有尺寸 70 针的计数，还显示与用户搜索条件匹配的尺寸 70 针的计数，例如，所有尺寸 70*不粘绣花*针。

## Scalability and resilience 可扩展性和弹性

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/intro.asciidoc)

Elasticsearch is built to be always available and to scale with your needs. It does this by being distributed by nature. You can add servers (nodes) to a cluster to increase capacity and Elasticsearch automatically distributes your data and query load across all of the available nodes. No need to overhaul your application, Elasticsearch knows how to balance multi-node clusters to provide scale and high availability. The more nodes, the merrier.
Elasticsearch 旨在始终可用并根据您的需求进行扩展。它通过自然分布来做到这一点。您可以向集群添加服务器（节点）以增加容量，Elasticsearch  会自动在所有可用节点上分配数据和查询负载。无需彻底修改您的应用程序，Elasticsearch  知道如何平衡多节点集群以提供规模和高可用性。节点越多越好。

How does this work? Under the covers, an Elasticsearch index is really just a logical grouping of one or more physical shards, where each shard is actually a self-contained index. By distributing the documents in an index across multiple shards, and distributing those shards across multiple nodes, Elasticsearch can ensure redundancy, which both protects against hardware failures and increases query capacity as nodes are added to a cluster. As the cluster grows (or shrinks), Elasticsearch automatically migrates shards to rebalance the cluster.
这是如何运作的？在幕后，Elasticsearch  索引实际上只是一个或多个物理分片的逻辑分组，其中每个分片实际上是一个独立的索引。通过将索引中的文档分布在多个分片上，并将这些分片分布在多个节点上，Elasticsearch 可以确保冗余，这既可以防止硬件故障，又可以在将节点添加到集群时提高查询容量。随着集群的增长（或缩小），Elasticsearch  会自动迁移分片以重新平衡集群。

There are two types of shards: primaries and replicas. Each document in an index belongs to one primary shard. A replica shard is a copy of a primary shard. Replicas provide redundant copies of your data to protect against hardware failure and increase capacity to serve read requests like searching or retrieving a document.
有两种类型的分片：主分片和副本分片。索引中的每个文档都属于一个主分片。副本分片是主分片的副本。副本提供数据的冗余副本，以防止硬件故障并提高服务读取请求（例如搜索或检索文档）的能力。

The number of primary shards in an index is fixed at the time that an index is created, but the number of replica shards can be changed at any time, without interrupting indexing or query operations.
索引中主分片的数量在创建索引时是固定的，但副本分片的数量可以随时更改，而无需中断索引或查询操作。

### Shard size and number of shards 分片大小和分片数量

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/intro.asciidoc)

There are a number of performance considerations and trade offs with respect to shard size and the number of primary shards configured for an index. The more shards, the more overhead there is simply in maintaining those indices. The larger the shard size, the longer it takes to move shards around when Elasticsearch needs to rebalance a cluster.
对于分片大小和为索引配置的主分片数量，存在许多性能考虑因素和权衡。分片越多，维护这些索引的开销就越大。分片大小越大，当 Elasticsearch 需要重新平衡集群时，移动分片所需的时间就越长。

Querying lots of small shards makes the processing per shard faster, but more queries means more overhead, so querying a smaller number of larger shards might be faster. In short…it depends.
查询大量小分片可以使每个分片的处理速度更快，但更多查询意味着更多开销，因此查询少量较大分片可能会更快。简而言之……​这取决于。

As a starting point: 作为起点：

- Aim to keep the average shard size between a few GB and a few tens of GB. For use cases with time-based data, it is common to see shards in the 20GB to 40GB range. 
  目标是将平均分片大小保持在几 GB 到几十 GB 之间。对于基于时间的数据的用例，通常会看到 20GB 到 40GB 范围内的分片。
- Avoid the gazillion shards problem. The number of shards a node can hold is proportional to the available heap space. As a general rule, the number of shards per GB of heap space should be less than 20. 
  避免无数碎片问题。节点可以容纳的分片数量与可用堆空间成正比。作为一般规则，每 GB 堆空间的分片数量应小于 20。

The best way to determine the optimal configuration for your use case is through [ testing with your own data and queries](https://www.elastic.co/elasticon/conf/2016/sf/quantitative-cluster-sizing).
确定适合您的用例的最佳配置的最佳方法是[使用您自己的数据和查询进行测试](https://www.elastic.co/elasticon/conf/2016/sf/quantitative-cluster-sizing)。

### Disaster recovery 灾难恢复

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/intro.asciidoc)

A cluster’s nodes need good, reliable connections to each other. To provide better connections, you typically co-locate the nodes in the same data center or nearby data centers. However, to maintain high availability, you also need to avoid any single point of failure. In the event of a major outage in one location, servers in another location need to be able to take over. The answer? Cross-cluster replication (CCR).
集群的节点之间需要良好、可靠的连接。为了提供更好的连接，您通常将节点放在同一数据中心或附近的数据中心中。但是，为了保持高可用性，您还需要避免任何单点故障。如果一个位置发生重大中断，另一位置的服务器需要能够接管。答案是什么呢？跨集群复制 (CCR)。

CCR provides a way to automatically synchronize indices from your primary cluster to a secondary remote cluster that can serve as a hot backup. If the primary cluster fails, the secondary cluster can take over. You can also use CCR to create secondary clusters to serve read requests in geo-proximity to your users.
CCR 提供了一种自动将索引从主集群同步到可用作热备份的辅助远程集群的方法。如果主集群发生故障，辅助集群可以接管。您还可以使用 CCR 创建辅助集群来处理与用户地理位置接近的读取请求。

Cross-cluster replication is active-passive. The index on the primary cluster is the active leader index and handles all write requests. Indices replicated to secondary clusters are read-only followers.
跨集群复制是主动-被动的。主集群上的索引是活动领导索引并处理所有写入请求。复制到辅助集群的索引是只读追随者。

### Security, management, and monitoring 安全、管理和监控

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/intro.asciidoc)

As with any enterprise system, you need tools to secure, manage, and monitor your Elasticsearch clusters. Security, monitoring, and administrative features that are integrated into Elasticsearch enable you to use [Kibana](https://www.elastic.co/guide/en/kibana/8.15/introduction.html) as a control center for managing a cluster. Features like [downsampling](https://www.elastic.co/guide/en/elasticsearch/reference/current/downsampling.html) and [index lifecycle management](https://www.elastic.co/guide/en/elasticsearch/reference/current/index-lifecycle-management.html) help you intelligently manage your data over time.
与任何企业系统一样，您需要工具来保护、管理和监控您的 Elasticsearch 集群。集成到 Elasticsearch 中的安全、监控和管理功能使您能够使用[Kibana](https://www.elastic.co/guide/en/kibana/8.15/introduction.html)作为管理集群的控制中心。[下采样](https://www.elastic.co/guide/en/elasticsearch/reference/current/downsampling.html)和[索引生命周期管理](https://www.elastic.co/guide/en/elasticsearch/reference/current/index-lifecycle-management.html)等功能可帮助您随着时间的推移智能地管理数据。

Refer to [Monitor a cluster](https://www.elastic.co/guide/en/elasticsearch/reference/current/monitor-elasticsearch-cluster.html) for more information.
有关详细信息，请参阅[监控集群](https://www.elastic.co/guide/en/elasticsearch/reference/current/monitor-elasticsearch-cluster.html)。

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

## 安全加固

### 禁用批量删除索引

批量索引删除操作，类似 “rm -rf ” 删库跑路操作，禁止批量删除，可避免恶意或意外的批量删除索引。

修改 ES 服务的配置文件 `elasticsearch.yml` 增加如下配置，然后重启服务：

```yaml
action.destructive_requires_name: true
```

### 禁止监听在公网 访问控制

ES服务监听在0.0.0.0，可能导致服务对外或内网横向移动渗透风险，极易被黑客利用入侵。

修改ES服务配置文件elasticsearch.yml的network.host配置： network.host: 127.0.0.1或者内网IP，然后重启服务。

### ES未授权访问入侵防范

未加固情况下启动服务存在未授权访问风险，可被非法查询或操作数据，需立即修复加固。

**限制http端口的IP访问，不对公网开放**
 修改主目录下 `config/elasticsearch.yml` 配置文件，将network.host配置为内网地址或者127.0.0.1

```
network.host: 127.0.0.1
```

**使用x-pack插件为Elasticsearch访问增加登录验证**

1. 在主目录下运行 `bin/elasticsearch-plugin install x-pack` 安装x-pack插件(6.3及以上版本已默认安装)
2. config/elasticsearch.yml 配置文件增加以下配置

```
xpack.security.enabled: True
xpack.ml.enabled: true
```

1. 运行命令`bin/x-pack/setup-passwords interactive`为ES服务设置密码(6.3及以上版本命令目录为bin/elasticsearch-setup-passwords)
2. 重启ES服务



















## 向 Elasticsearch 发送请求

使用 REST API 向 Elasticsearch 发送数据和其他请求。这使您可以使用任何发送 HTTP 请求的客户端（例如 [curl](https://curl.se) ）与 Elasticsearch 进行交互。还可以使用 Kibana 的控制台向 Elasticsearch 发送请求。

### Elasticsearch Service

**Use Kibana 使用 Kibana**

1. Open Kibana’s main menu ("**☰**" near Elastic logo) and go to **Dev Tools > Console**.
   打开 Kibana 的主菜单（Elastic 徽标附近的“ **☰** ”）并转到**Dev Tools > Con​​sole** 。

   ![Kibana Console](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/kibana-console.png)

2. Run the following test API request in Console:
   在控制台中运行以下测试 API 请求：

   

   ```console
   GET /
   ```

1. Copy as curl 复制为卷曲[Try in Elastic 尝试使用弹性](http://localhost:5601/zzz/app/kibana#/dev_tools/console?load_from=https://www.elastic.co/guide/en/elasticsearch/reference/current/snippets/1.console) 

**Use curl 使用卷曲**

To communicate with Elasticsearch using curl or another client, you need your cluster’s endpoint.
要使用curl或其他客户端与Elasticsearch通信，您需要集群的端点。

1. Open Kibana’s main menu and click **Manage this deployment**. 
   打开 Kibana 的主菜单并单击**管理此部署**。

2. From your deployment menu, go to the **Elasticsearch** page. Click **Copy endpoint**. 
   从部署菜单中，转到**Elasticsearch**页面。单击**复制端点**。

3. To submit an example API request, run the following curl command in a new terminal session. Replace `<password>` with the password for the `elastic` user. Replace `<elasticsearch_endpoint>` with your endpoint.
   要提交示例 API 请求，请在新的终端会话中运行以下curl 命令。将`<password>`替换为`elastic`用户的密码。将`<elasticsearch_endpoint>`替换为您的端点。

   ```sh
   curl -u elastic:<password> <elasticsearch_endpoint>/
   ```

### Docker

**Use Kibana 使用 Kibana**

1. Open Kibana’s main menu ("**☰**" near Elastic logo) and go to **Dev Tools > Console**.
   打开 Kibana 的主菜单（Elastic 徽标附近的“ **☰** ”）并转到**Dev Tools > Con​​sole** 。

   ![Kibana Console](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/kibana-console.png)

2. Run the following test API request in Console:
   在控制台中运行以下测试 API 请求：

   

   ```console
   GET /
   ```

1. Copy as curl 复制为卷曲[Try in Elastic 尝试使用弹性](http://localhost:5601/zzz/app/kibana#/dev_tools/console?load_from=https://www.elastic.co/guide/en/elasticsearch/reference/current/snippets/2.console) 

**Use curl 使用卷曲**

To submit an example API request, run the following curl command in a new terminal session.
要提交示例 API 请求，请在新的终端会话中运行以下curl 命令。

```sh
curl -u elastic:$ELASTIC_PASSWORD https://localhost:9200
```

## Add data 添加数据

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/quickstart/getting-started.asciidoc)

You add data to Elasticsearch as JSON objects called documents. Elasticsearch stores these documents in searchable indices.
您可以将数据作为称为文档的 JSON 对象添加到 Elasticsearch。 Elasticsearch 将这些文档存储在可搜索索引中。

### Add a single document 添加单个文档

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/quickstart/getting-started.asciidoc)

Submit the following indexing request to add a single document to the `books` index. The request automatically creates the index.
提交以下索引请求以将单个文档添加到`books`索引中。请求自动创建索引。



```console
POST books/_doc
{"name": "Snow Crash", "author": "Neal Stephenson", "release_date": "1992-06-01", "page_count": 470}
```

Copy as curl 复制为卷曲[Try in Elastic 尝试使用弹性](http://localhost:5601/zzz/app/kibana#/dev_tools/console?load_from=https://www.elastic.co/guide/en/elasticsearch/reference/current/snippets/3.console) 

The response includes metadata that Elasticsearch generates for the document including a unique `_id` for the document within the index.
响应包括 Elasticsearch 为文档生成的元数据，其中包括索引中文档的唯一`_id` 。

<details data-immersive-translate-walked="7e0d4e4d-4673-4d84-8196-7f84b47224f1"><summary class="title" data-immersive-translate-walked="7e0d4e4d-4673-4d84-8196-7f84b47224f1" data-immersive-translate-paragraph="1">Expand to see example response<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><br><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-block-wrapper-theme-none immersive-translate-target-translation-block-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">展开查看示例响应</font></font></font></summary><div class="content" data-immersive-translate-walked="7e0d4e4d-4673-4d84-8196-7f84b47224f1">
<a id="330b57d1ece90395f9b8b718d8ae2860" href="https://www.elastic.co/guide/en/elasticsearch/reference/current/getting-started.html#330b57d1ece90395f9b8b718d8ae2860" data-immersive-translate-walked="7e0d4e4d-4673-4d84-8196-7f84b47224f1"></a><div class="pre_wrapper lang-console-result" data-immersive-translate-walked="7e0d4e4d-4673-4d84-8196-7f84b47224f1">
<div class="console_code_copy" title="Copy to clipboard" data-immersive-translate-walked="7e0d4e4d-4673-4d84-8196-7f84b47224f1"></div>
<pre class="programlisting prettyprint lang-console-result prettyprinted" style=""><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pln"></span><span class="pun"></span></pre>
</div>
</div></details>

### Add multiple documents 添加多个文档

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/quickstart/getting-started.asciidoc)

Use the `_bulk` endpoint to add multiple documents in one request. Bulk data must be newline-delimited JSON (NDJSON). Each line must end in a newline character (`\n`), including the last line.
使用`_bulk`端点在一个请求中添加多个文档。批量数据必须是换行符分隔的 JSON (NDJSON)。每行必须以换行符 ( `\n` ) 结尾，包括最后一行。



```console
POST /_bulk
{ "index" : { "_index" : "books" } }
{"name": "Revelation Space", "author": "Alastair Reynolds", "release_date": "2000-03-15", "page_count": 585}
{ "index" : { "_index" : "books" } }
{"name": "1984", "author": "George Orwell", "release_date": "1985-06-01", "page_count": 328}
{ "index" : { "_index" : "books" } }
{"name": "Fahrenheit 451", "author": "Ray Bradbury", "release_date": "1953-10-15", "page_count": 227}
{ "index" : { "_index" : "books" } }
{"name": "Brave New World", "author": "Aldous Huxley", "release_date": "1932-06-01", "page_count": 268}
{ "index" : { "_index" : "books" } }
{"name": "The Handmaids Tale", "author": "Margaret Atwood", "release_date": "1985-06-01", "page_count": 311}
```

Copy as curl 复制为卷曲[Try in Elastic 尝试使用弹性](http://localhost:5601/zzz/app/kibana#/dev_tools/console?load_from=https://www.elastic.co/guide/en/elasticsearch/reference/current/snippets/4.console) 

You should receive a response indicating there were no errors.
您应该收到一条响应，表明没有错误。

<details data-immersive-translate-walked="7e0d4e4d-4673-4d84-8196-7f84b47224f1"><summary class="title" data-immersive-translate-walked="7e0d4e4d-4673-4d84-8196-7f84b47224f1" data-immersive-translate-paragraph="1">Expand to see example response<font class="notranslate immersive-translate-target-wrapper" data-immersive-translate-translation-element-mark="1" lang="zh-CN"><br><font class="notranslate immersive-translate-target-translation-theme-none immersive-translate-target-translation-block-wrapper-theme-none immersive-translate-target-translation-block-wrapper" data-immersive-translate-translation-element-mark="1"><font class="notranslate immersive-translate-target-inner immersive-translate-target-translation-theme-none-inner" data-immersive-translate-translation-element-mark="1">展开查看示例响应</font></font></font></summary><div class="content" data-immersive-translate-walked="7e0d4e4d-4673-4d84-8196-7f84b47224f1">
<a id="8eeabd21fcb2bc53e455f8e4008cb859" href="https://www.elastic.co/guide/en/elasticsearch/reference/current/getting-started.html#8eeabd21fcb2bc53e455f8e4008cb859" data-immersive-translate-walked="7e0d4e4d-4673-4d84-8196-7f84b47224f1"></a><div class="pre_wrapper lang-console-result" data-immersive-translate-walked="7e0d4e4d-4673-4d84-8196-7f84b47224f1">
<div class="console_code_copy" title="Copy to clipboard" data-immersive-translate-walked="7e0d4e4d-4673-4d84-8196-7f84b47224f1"></div>
<pre class="programlisting prettyprint lang-console-result prettyprinted" style=""><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="kwd"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pun"></span><span class="pln"></span><span class="str"></span><span class="pun"></span><span class="pln"></span><span class="lit"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="pun"></span><span class="pln"></span><span class="pun"></span></pre>
</div>
</div></details>

## Search data 搜索数据

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/quickstart/getting-started.asciidoc)

Indexed documents are available for search in near real-time.
索引文档可近乎实时地搜索。

### Search all documents 搜索所有文档

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/quickstart/getting-started.asciidoc)

Run the following command to search the `books` index for all documents:
运行以下命令在`books`索引中搜索所有文档：



```console
GET books/_search
```

Copy as curl 复制为卷曲[Try in Elastic 尝试使用弹性](http://localhost:5601/zzz/app/kibana#/dev_tools/console?load_from=https://www.elastic.co/guide/en/elasticsearch/reference/current/snippets/5.console) 

The `_source` of each hit contains the original JSON object submitted during indexing.
每个命中的`_source`包含索引期间提交的原始 JSON 对象。

### `match` query `match`查询

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/quickstart/getting-started.asciidoc)

You can use the `match` query to search for documents that contain a specific value in a specific field. This is the standard query for performing full-text search, including fuzzy matching and phrase searches.
您可以使用`match`查询来搜索特定字段中包含特定值的文档。这是执行全文搜索的标准查询，包括模糊匹配和短语搜索。

Run the following command to search the `books` index for documents containing `brave` in the `name` field:
运行以下命令在`books`索引中搜索`name`字段中包含`brave`文档：



```console
GET books/_search
{
  "query": {
    "match": {
      "name": "brave"
    }
  }
}
```

Copy as curl 复制为卷曲[Try in Elastic 尝试使用弹性](http://localhost:5601/zzz/app/kibana#/dev_tools/console?load_from=https://www.elastic.co/guide/en/elasticsearch/reference/current/snippets/6.console) 

## Next steps 后续步骤

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/quickstart/getting-started.asciidoc)

Now that Elasticsearch is up and running and you’ve learned the basics,  you’ll probably want to test out larger datasets, or index your own  data.
现在 Elasticsearch 已启动并运行，并且您已经学习了基础知识，您可能想要测试更大的数据集，或为您自己的数据建立索引。

### Learn more about search queries 了解有关搜索查询的更多信息

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/quickstart/getting-started.asciidoc)

- [Search your data](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-with-elasticsearch.html). Jump here to learn about exact value search, full-text search, vector search, and more, using the [search API](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-search.html). 
  [搜索您的数据](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-with-elasticsearch.html)。跳至此处，了解使用[搜索 API 的](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-search.html)精确值搜索、全文搜索、矢量搜索等。

### Add more data 添加更多数据

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/quickstart/getting-started.asciidoc)

- Learn how to [install sample data](https://www.elastic.co/guide/en/kibana/8.15/sample-data.html) using Kibana. This is a quick way to test out Elasticsearch on larger workloads. 
  了解如何使用 Kibana[安装示例数据](https://www.elastic.co/guide/en/kibana/8.15/sample-data.html)。这是在较大工作负载上测试 Elasticsearch 的快速方法。
- Learn how to use the [upload data UI](https://www.elastic.co/guide/en/kibana/8.15/connect-to-elasticsearch.html#upload-data-kibana) in Kibana to add your own CSV, TSV, or JSON files. 
  了解如何使用 Kibana 中的[上传数据 UI](https://www.elastic.co/guide/en/kibana/8.15/connect-to-elasticsearch.html#upload-data-kibana)添加您自己的 CSV、TSV 或 JSON 文件。
- Use the [bulk API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-bulk.html) to ingest your own datasets to Elasticsearch. 
  使用[批量 API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-bulk.html)将您自己的数据集提取到 Elasticsearch。

### Elasticsearch programming language clients Elasticsearch 编程语言客户端

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/quickstart/getting-started.asciidoc)

- Check out our [client library](https://www.elastic.co/guide/en/elasticsearch/client/index.html) to work with your Elasticsearch instance in your preferred programming language. 
  查看我们的[客户端库，](https://www.elastic.co/guide/en/elasticsearch/client/index.html)以您首选的编程语言使用您的 Elasticsearch 实例。
- If you’re using Python, check out [Elastic Search Labs](https://www.elastic.co/search-labs) for a range of examples that use the Elasticsearch Python client. This  is the best place to explore AI-powered search use cases, such as  working with embeddings, vector search, and retrieval augmented  generation (RAG).
  如果您使用的是 Python，请查看[Elastic Search Labs](https://www.elastic.co/search-labs)以获取一系列使用 Elasticsearch Python 客户端的示例。这是探索人工智能驱动的搜索用例的最佳场所，例如使用嵌入、矢量搜索和检索增强生成 (RAG)。
  - This extensive, hands-on [tutorial](https://www.elastic.co/search-labs/tutorials/search-tutorial/welcome) walks you through building a complete search solution with Elasticsearch, from the ground up. 
    这个内容丰富的实践[教程](https://www.elastic.co/search-labs/tutorials/search-tutorial/welcome)将引导您从头开始使用 Elasticsearch 构建完整的搜索解决方案。
  - [`elasticsearch-labs`](https://github.com/elastic/elasticsearch-labs) contains a range of executable Python [notebooks](https://github.com/elastic/elasticsearch-labs/tree/main/notebooks) and [example apps](https://github.com/elastic/elasticsearch-labs/tree/main/example-apps). 
    [`elasticsearch-labs`](https://github.com/elastic/elasticsearch-labs)包含一系列可执行的 Python[笔记本](https://github.com/elastic/elasticsearch-labs/tree/main/notebooks)和[示例应用程序](https://github.com/elastic/elasticsearch-labs/tree/main/example-apps)。

