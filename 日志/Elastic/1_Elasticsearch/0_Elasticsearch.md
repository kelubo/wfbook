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

# Configuring Elasticsearch 配置Elasticsearch

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/setup/configuration.asciidoc)

Elasticsearch ships with good defaults and requires very little configuration. Most settings can be changed on a running cluster using the [Cluster update settings](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-update-settings.html) API.
Elasticsearch 具有良好的默认设置，并且需要很少的配置。可以使用[集群更新设置](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-update-settings.html)API 在正在运行的集群上更改大多数设置。

The configuration files should contain settings which are node-specific (such as `node.name` and paths), or settings which a node requires in order to be able to join a cluster, such as `cluster.name` and `network.host`.
配置文件应包含特定于节点的设置（例如`node.name`和 paths），或者节点为了能够加入集群而需要的设置，例如`cluster.name`和`network.host` 。

## Config files location 配置文件位置

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/setup/configuration.asciidoc)

Elasticsearch has three configuration files:
Elasticsearch 有三个配置文件：

- `elasticsearch.yml` for configuring Elasticsearch 
  用于配置Elasticsearch的`elasticsearch.yml`
- `jvm.options` for configuring Elasticsearch JVM settings 
  `jvm.options`用于配置 Elasticsearch JVM 设置
- `log4j2.properties` for configuring Elasticsearch logging 
  `log4j2.properties`用于配置 Elasticsearch 日志记录

These files are located in the config directory, whose default location depends on whether or not the installation is from an archive distribution (`tar.gz` or `zip`) or a package distribution (Debian or RPM packages).
这些文件位于 config 目录中，其默认位置取决于安装是来自存档发行版（ `tar.gz`或`zip` ）还是软件包发行版（Debian 或 RPM 软件包）。

For the archive distributions, the config directory location defaults to `$ES_HOME/config`. The location of the config directory can be changed via the `ES_PATH_CONF` environment variable as follows:
对于存档发行版，配置目录位置默认为`$ES_HOME/config` 。 config 目录的位置可以通过`ES_PATH_CONF`环境变量更改，如下所示：

```sh
ES_PATH_CONF=/path/to/my/config ./bin/elasticsearch
```

Alternatively, you can `export` the `ES_PATH_CONF` environment variable via the command line or via your shell profile.
或者，您可以通过命令行或 shell 配置文件`export` `ES_PATH_CONF`环境变量。

For the package distributions, the config directory location defaults to `/etc/elasticsearch`. The location of the config directory can also be changed via the `ES_PATH_CONF` environment variable, but note that setting this in your shell is not sufficient. Instead, this variable is sourced from `/etc/default/elasticsearch` (for the Debian package) and `/etc/sysconfig/elasticsearch` (for the RPM package). You will need to edit the `ES_PATH_CONF=/etc/elasticsearch` entry in one of these files accordingly to change the config directory location.
对于软件包发行版，配置目录位置默认为`/etc/elasticsearch` 。 config 目录的位置也可以通过`ES_PATH_CONF`环境变量进行更改，但请注意，在 shell 中设置此位置是不够的。相反，此变量源自`/etc/default/elasticsearch` （对于 Debian 软件包）和`/etc/sysconfig/elasticsearch` （对于 RPM 软件包）。您将需要编辑 `ES_PATH_CONF=/etc/elasticsearch` 相应地在这些文件之一中输入条目以更改配置目录位置。

## Config file format 配置文件格式

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/setup/configuration.asciidoc)

The configuration format is [YAML](https://yaml.org/). Here is an example of changing the path of the data and logs directories:
配置格式为[YAML](https://yaml.org/) 。以下是更改数据和日志目录路径的示例：

```yaml
path:
    data: /var/lib/elasticsearch
    logs: /var/log/elasticsearch
```

Settings can also be flattened as follows:
设置也可以按如下方式展平：

```yaml
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
```

In YAML, you can format non-scalar values as sequences:
在 YAML 中，您可以将非标量值格式化为序列：

```yaml
discovery.seed_hosts:
   - 192.168.1.10:9300
   - 192.168.1.11
   - seeds.mydomain.com
```

Though less common, you can also format non-scalar values as arrays:
虽然不太常见，但您也可以将非标量值格式化为数组：

```yaml
discovery.seed_hosts: ["192.168.1.10:9300", "192.168.1.11", "seeds.mydomain.com"]
```

## Environment variable substitution 环境变量替换

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/setup/configuration.asciidoc)

Environment variables referenced with the `${...}` notation within the configuration file will be replaced with the value of the environment variable. For example:
配置文件中使用`${...}`表示法引用的环境变量将替换为环境变量的值。例如：

```yaml
node.name:    ${HOSTNAME}
network.host: ${ES_NETWORK_HOST}
```

Values for environment variables must be simple strings. Use a comma-separated string to provide values that Elasticsearch will parse as a list. For  example, Elasticsearch will split the following string into a list of  values for the `${HOSTNAME}` environment variable:
环境变量的值必须是简单字符串。使用逗号分隔的字符串提供 Elasticsearch 将解析为列表的值。例如，Elasticsearch 会将以下字符串拆分为`${HOSTNAME}`环境变量的值列表：

```yaml
export HOSTNAME="host1,host2"
```

## Cluster and node setting types 集群和节点设置类型

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/setup/configuration.asciidoc)

Cluster and node settings can be categorized based on how they are configured:
集群和节点设置可以根据配置方式进行分类：



- Dynamic 动态的

  You can configure and update dynamic settings on a running cluster using the [cluster update settings API](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-update-settings.html). You can also configure dynamic settings locally on an unstarted or shut down node using `elasticsearch.yml`. 您可以使用[集群更新设置 API](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-update-settings.html)在正在运行的集群上配置和更新动态设置。您还可以使用`elasticsearch.yml`在未启动或关闭的节点上本地配置动态设置。 Updates made using the cluster update settings API can be *persistent*, which apply across cluster restarts, or *transient*, which reset after a cluster restart. You can also reset transient or persistent settings by assigning them a `null` value using the API. 使用集群更新设置 API 进行的更新可以是*持久的*（在集群重新启动时应用），也可以是*暂时的*（在集群重新启动后重置）。您还可以使用 API 为临时或持久设置分配`null`值来重置它们。 If you configure the same setting using multiple methods, Elasticsearch applies the settings in following order of precedence: 如果您使用多种方法配置相同的设置，Elasticsearch 将按以下优先顺序应用设置：  Transient setting 瞬态设置 Persistent setting 持续设置 `elasticsearch.yml` setting  `elasticsearch.yml`设置 Default setting value 默认设定值  For example, you can apply a transient setting to override a persistent setting or `elasticsearch.yml` setting. However, a change to an `elasticsearch.yml` setting will not override a defined transient or persistent setting. 例如，您可以应用瞬态设置来覆盖持久设置或`elasticsearch.yml`设置。但是，对`elasticsearch.yml`设置的更改不会覆盖定义的瞬态或持久设置。  If you use Elasticsearch Service, use the [user settings](https://www.elastic.co/guide/en/cloud/current/ec-add-user-settings.html) feature to configure all cluster settings. This method lets Elasticsearch Service automatically reject unsafe settings that could break your cluster. 如果您使用 Elasticsearch Service，请使用[用户设置](https://www.elastic.co/guide/en/cloud/current/ec-add-user-settings.html)功能来配置所有集群设置。此方法可让 Elasticsearch Service 自动拒绝可能破坏集群的不安全设置。 If you run Elasticsearch on your own hardware, use the [cluster update settings API](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-update-settings.html) to configure dynamic cluster settings. Only use `elasticsearch.yml` for static cluster settings and node settings. The API doesn’t require a restart and ensures a setting’s value is the same on all nodes. 如果您在自己的硬件上运行 Elasticsearch，请使用[集群更新设置 API](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-update-settings.html)来配置动态集群设置。仅将`elasticsearch.yml`用于静态集群设置和节点设置。该 API 不需要重新启动并确保所有节点上的设置值相同。   We no longer recommend using transient cluster settings. Use persistent cluster settings instead. If a cluster becomes unstable, transient settings can clear unexpectedly, resulting in a potentially undesired cluster configuration. See the [Transient settings migration guide](https://www.elastic.co/guide/en/elasticsearch/reference/current/transient-settings-migration-guide.html). 我们不再建议使用临时集群设置。请改用持久集群设置。如果集群变得不稳定，瞬态设置可能会意外清除，从而导致可能出现不需要的集群配置。请参阅[瞬态设置迁移指南](https://www.elastic.co/guide/en/elasticsearch/reference/current/transient-settings-migration-guide.html)。



- Static 静止的

  Static settings can only be configured on an unstarted or shut down node using `elasticsearch.yml`.  静态设置只能使用`elasticsearch.yml`在未启动或关闭的节点上配置。 Static settings must be set on every relevant node in the cluster. 必须在集群中的每个相关节点上设置静态设置。

# Important Elasticsearch configuration 重要的 Elasticsearch 配置

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/setup/important-settings.asciidoc)

Elasticsearch requires very little configuration to get started, but there are a number of items which **must** be considered before using your cluster in production:
Elasticsearch 需要很少的配置即可开始，但在生产中使用集群之前**必须**考虑许多事项：

- [Path settings 路径设置](https://www.elastic.co/guide/en/elasticsearch/reference/current/important-settings.html#path-settings)
- [Cluster name setting 集群名称设置](https://www.elastic.co/guide/en/elasticsearch/reference/current/important-settings.html#cluster-name)
- [Node name setting 节点名称设置](https://www.elastic.co/guide/en/elasticsearch/reference/current/important-settings.html#node-name)
- [Network host settings 网络主机设置](https://www.elastic.co/guide/en/elasticsearch/reference/current/important-settings.html#network.host)
- [Discovery settings 发现设置](https://www.elastic.co/guide/en/elasticsearch/reference/current/important-settings.html#discovery-settings)
- [Heap size settings 堆大小设置](https://www.elastic.co/guide/en/elasticsearch/reference/current/important-settings.html#heap-size-settings)
- [JVM heap dump path setting
  JVM堆转储路径设置](https://www.elastic.co/guide/en/elasticsearch/reference/current/important-settings.html#heap-dump-path)
- [GC logging settings GC 日志记录设置](https://www.elastic.co/guide/en/elasticsearch/reference/current/important-settings.html#gc-logging)
- [Temporary directory settings
  临时目录设置](https://www.elastic.co/guide/en/elasticsearch/reference/current/important-settings.html#es-tmpdir)
- [JVM fatal error log setting
  JVM致命错误日志设置](https://www.elastic.co/guide/en/elasticsearch/reference/current/important-settings.html#error-file-path)
- [Cluster backups 集群备份](https://www.elastic.co/guide/en/elasticsearch/reference/current/important-settings.html#important-settings-backups)

Our [Elastic Cloud](https://www.elastic.co/cloud/elasticsearch-service/signup?page=docs&placement=docs-body) service configures these items automatically, making your cluster production-ready by default.
我们的[Elastic Cloud](https://www.elastic.co/cloud/elasticsearch-service/signup?page=docs&placement=docs-body)服务会自动配置这些项目，默认情况下您的集群已做好生产准备。

## Path settings 路径设置

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/setup/important-settings/path-settings.asciidoc)

Elasticsearch writes the data you index to indices and data streams to a `data` directory. Elasticsearch writes its own application logs, which contain information about cluster health and operations, to a `logs` directory.
Elasticsearch 将索引的数据写入索引，并将数据流写入`data`目录。 Elasticsearch 将其自己的应用程序日志写入`logs`目录，其中包含有关集群运行状况和操作的信息。

For [macOS `.tar.gz`](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html), [Linux `.tar.gz`](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html), and [Windows `.zip`](https://www.elastic.co/guide/en/elasticsearch/reference/current/zip-windows.html) installations, `data` and `logs` are subdirectories of `$ES_HOME` by default. However, files in `$ES_HOME` risk deletion during an upgrade.
对于[macOS `.tar.gz`](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html) 、 [Linux `.tar.gz`](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html)和[Windows `.zip`](https://www.elastic.co/guide/en/elasticsearch/reference/current/zip-windows.html)安装，默认情况下`data`和`logs`是`$ES_HOME`的子目录。但是，升级期间`$ES_HOME`中的文件有被删除的风险。

In production, we strongly recommend you set the `path.data` and `path.logs` in `elasticsearch.yml` to locations outside of `$ES_HOME`. [Docker](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html), [Debian](https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html), and [RPM](https://www.elastic.co/guide/en/elasticsearch/reference/current/rpm.html) installations write data and log to locations outside of `$ES_HOME` by default.
在生产中，我们强烈建议您将`elasticsearch.yml`中的`path.data`和`path.logs`设置为`$ES_HOME`之外的位置。默认情况下， [Docker](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html) 、 [Debian](https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html)和[RPM](https://www.elastic.co/guide/en/elasticsearch/reference/current/rpm.html)安装将数据和日志写入`$ES_HOME`之外的位置。

Supported `path.data` and `path.logs` values vary by platform:
支持的`path.data`和`path.logs`值因平台而异：

​    

Linux and macOS installations support Unix-style paths:
Linux 和 macOS 安装支持 Unix 样式路径：

```yaml
path:
  data: /var/data/elasticsearch
  logs: /var/log/elasticsearch
```

Don’t modify anything within the data directory or run processes that might interfere with its contents. If something other than Elasticsearch modifies the contents of the data directory, then Elasticsearch may fail, reporting corruption or other data inconsistencies, or may appear to work correctly having silently lost some of your data. Don’t attempt to take filesystem backups of the data directory; there is no supported way to restore such a backup. Instead, use [Snapshot and restore](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshot-restore.html) to take backups safely. Don’t run virus scanners on the data directory. A virus scanner can prevent Elasticsearch from working correctly and may modify the contents of the data directory. The data directory contains no executables so a virus scan will only find false positives.
不要修改数据目录中的任何内容或运行可能干扰其内容的进程。如果 Elasticsearch 以外的其他内容修改了数据目录的内容，则 Elasticsearch  可能会失败，报告损坏或其他数据不一致，或者可能看似正常工作但悄悄丢失了一些数据。不要尝试对数据目录进行文件系统备份；不支持恢复此类备份的方法。相反，请使用[快照和恢复](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshot-restore.html)来安全地进行备份。不要在数据目录上运行病毒扫描程序。病毒扫描程序可能会阻止 Elasticsearch 正常工作，并可能修改数据目录的内容。数据目录不包含可执行文件，因此病毒扫描只会发现误报。

## Multiple data paths 多个数据路径

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/setup/important-settings/path-settings.asciidoc)

Deprecated in 7.13.0. 7.13.0 中已弃用。

If needed, you can specify multiple paths in `path.data`. Elasticsearch stores the node’s data across all provided paths but keeps each shard’s data on the same path.
如果需要，您可以在`path.data`中指定多个路径。 Elasticsearch 在所有提供的路径上存储节点的数据，但将每个分片的数据保留在同一路径上。

Elasticsearch does not balance shards across a node’s data paths. High disk usage in a single path can trigger a [high disk usage watermark](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-cluster.html#disk-based-shard-allocation) for the entire node. If triggered, Elasticsearch will not add shards to the node, even if the node’s other paths have available disk space. If you need additional disk space, we recommend you add a new node rather than additional data paths.
Elasticsearch 不会平衡节点数据路径上的分片。单个路径中的高磁盘使用率可能会触发整个节点的[高磁盘使用率水印](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-cluster.html#disk-based-shard-allocation)。如果触发，Elasticsearch 不会向该节点添加分片，即使该节点的其他路径有可用磁盘空间。如果您需要额外的磁盘空间，我们建议您添加新节点而不是额外的数据路径。

​    

Linux and macOS installations support multiple Unix-style paths in `path.data`:
Linux 和 macOS 安装支持`path.data`中的多个 Unix 风格路径：

```yaml
path:
  data:
    - /mnt/elasticsearch_1
    - /mnt/elasticsearch_2
    - /mnt/elasticsearch_3
```

## Migrate from multiple data paths 从多个数据路径迁移

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/setup/important-settings/path-settings.asciidoc)

Support for multiple data paths was deprecated in 7.13 and will be removed in a future release.
对多个数据路径的支持已在 7.13 中弃用，并将在未来版本中删除。

As an alternative to multiple data paths, you can create a filesystem which spans multiple disks with a hardware virtualisation layer such as RAID, or a software virtualisation layer such as Logical Volume Manager (LVM) on Linux or Storage Spaces on Windows. If you wish to use multiple data paths on a single machine then you must run one node for each data path.
作为多个数据路径的替代方案，您可以使用硬件虚拟化层（例如 RAID）或软件虚拟化层（例如 Linux 上的逻辑卷管理器 (LVM) 或 Windows  上的存储空间）创建跨多个磁盘的文件系统。如果您希望在一台计算机上使用多个数据路径，则必须为每个数据路径运行一个节点。

If you currently use multiple data paths in a [highly available cluster](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/high-availability-cluster-design.html) then you can migrate to a setup that uses a single path for each node without downtime using a process similar to a [rolling restart](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/restart-cluster.html#restart-cluster-rolling): shut each node down in turn and replace it with one or more nodes each configured to use a single data path. In more detail, for each node that currently has multiple data paths you should follow the following process. In principle you can perform this migration during a rolling upgrade to 8.0, but we recommend migrating to a single-data-path setup before starting to upgrade.
如果您当前在[高可用集群](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/high-availability-cluster-design.html)中使用多个数据路径，那么您可以迁移到每个节点使用单个路径的设置，而无需使用类似于[滚动重新启动的](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/restart-cluster.html#restart-cluster-rolling)过程进行停机：依次关闭每个节点并将其替换为一个或多个节点更多节点，每个节点配置为使用单个数据路径。更详细地说，对于当前具有多个数据路径的每个节点，您应该遵循以下过程。原则上，您可以在滚动升级到 8.0 期间执行此迁移，但我们建议在开始升级之前迁移到单数据路径设置。

1. Take a snapshot to protect your data in case of disaster. 
   拍摄快照以在发生灾难时保护您的数据。

2. Optionally, migrate the data away from the target node by using an [allocation filter](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/modules-cluster.html#cluster-shard-allocation-filtering):
   （可选）使用[分配过滤器](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/modules-cluster.html#cluster-shard-allocation-filtering)将数据从目标节点迁移：

   

   ```console
   PUT _cluster/settings
   {
     "persistent": {
       "cluster.routing.allocation.exclude._name": "target-node-name"
     }
   }
   ```

Copy as curl 复制为卷曲[Try in Elastic 尝试使用弹性](http://localhost:5601/zzz/app/kibana#/dev_tools/console?load_from=https://www.elastic.co/guide/en/elasticsearch/reference/current/snippets/7.console) 

You can use the [cat allocation API](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/cat-allocation.html) to track progress of this data migration. If some shards do not migrate then the [cluster allocation explain API](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/cluster-allocation-explain.html) will help you to determine why.
您可以使用[cat 分配 API](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/cat-allocation.html)来跟踪此数据迁移的进度。如果某些分片没有迁移，那么[集群分配解释 API](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/cluster-allocation-explain.html)将帮助您确定原因。

Follow the steps in the [rolling restart process](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/restart-cluster.html#restart-cluster-rolling) up to and including shutting the target node down. 
按照[滚动重新启动过程](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/restart-cluster.html#restart-cluster-rolling)中的步骤进行操作，直至关闭目标节点（包括关闭目标节点）。

Ensure your cluster health is `yellow` or `green`, so that there is a copy of every shard assigned to at least one of the other nodes in your cluster. 
确保集群运行状况为`yellow`或`green` ，以便将每个分片的副本分配给集群中至少一个其他节点。

If applicable, remove the allocation filter applied in the earlier step.
如果适用，请删除先前步骤中应用的分配过滤器。



```console
PUT _cluster/settings
{
  "persistent": {
    "cluster.routing.allocation.exclude._name": null
  }
}
```

1. Copy as curl 复制为卷曲[Try in Elastic 尝试使用弹性](http://localhost:5601/zzz/app/kibana#/dev_tools/console?load_from=https://www.elastic.co/guide/en/elasticsearch/reference/current/snippets/8.console) 
2. Discard the data held by the stopped node by deleting the contents of its data paths. 
   通过删除其数据路径的内容来丢弃已停止节点所保存的数据。
3. Reconfigure your storage. For instance, combine your disks into a single filesystem using LVM or Storage Spaces. Ensure that your reconfigured storage has sufficient space for the data that it will hold. 
   重新配置您的存储。例如，使用 LVM 或存储空间将磁盘组合成单个文件系统。确保重新配置的存储有足够的空间来容纳它将保存的数据。
4. Reconfigure your node by adjusting the `path.data` setting in its `elasticsearch.yml` file. If needed, install more nodes each with their own `path.data` setting pointing at a separate data path. 
   通过调整`elasticsearch.yml`文件中的`path.data`设置来重新配置节点。如果需要，请安装更多节点，每个节点都有自己的`path.data`设置，指向单独的数据路径。
5. Start the new nodes and follow the rest of the [rolling restart process](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/restart-cluster.html#restart-cluster-rolling) for them. 
   启动新节点并执行它们的其余[滚动重新启动过程](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/restart-cluster.html#restart-cluster-rolling)。
6. Ensure your cluster health is `green`, so that every shard has been assigned. 
   确保您的集群运行状况为`green` ，以便每个分片都已分配。

You can alternatively add some number of single-data-path nodes to your cluster, migrate all your data over to these new nodes using [allocation filters](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/modules-cluster.html#cluster-shard-allocation-filtering), and then remove the old nodes from the cluster. This approach will temporarily double the size of your cluster so it will only work if you have the capacity to expand your cluster like this.
您也可以向集群添加一定数量的单数据路径节点，使用[分配过滤器](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/modules-cluster.html#cluster-shard-allocation-filtering)将所有数据迁移到这些新节点，然后从集群中删除旧节点。这种方法会暂时将集群的大小增加一倍，因此只有当您有能力像这样扩展集群时它才有效。

If you currently use multiple data paths but your cluster is not highly available then you can migrate to a non-deprecated configuration by taking a snapshot, creating a new cluster with the desired configuration and restoring the snapshot into it.
如果您当前使用多个数据路径，但集群的可用性不高，那么您可以通过拍摄快照、使用所需配置创建新集群并将快照恢复到其中来迁移到未弃用的配置。

## Cluster name setting 集群名称设置

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/setup/important-settings/cluster-name.asciidoc)

A node can only join a cluster when it shares its `cluster.name` with all the other nodes in the cluster. The default name is `elasticsearch`, but you should change it to an appropriate name that describes the purpose of the cluster.
仅当节点与集群中的所有其他节点共享其`cluster.name`时，它​​才能加入集群。默认名称是`elasticsearch` ，但您应该将其更改为描述集群用途的适当名称。

```yaml
cluster.name: logging-prod
```

Do not reuse the same cluster names in different environments. Otherwise, nodes might join the wrong cluster.
不要在不同环境中重复使用相同的集群名称。否则，节点可能会加入错误的集群。

Changing the name of a cluster requires a [full cluster restart](https://www.elastic.co/guide/en/elasticsearch/reference/current/restart-cluster.html#restart-cluster-full).
更改集群名称需要[重新启动整个集群](https://www.elastic.co/guide/en/elasticsearch/reference/current/restart-cluster.html#restart-cluster-full)。

## Node name setting 节点名称设置

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/setup/important-settings/node-name.asciidoc)

Elasticsearch uses `node.name` as a human-readable identifier for a particular instance of Elasticsearch. This name is included in the response of many APIs. The node name defaults to the hostname of the machine when Elasticsearch starts, but can be configured explicitly in `elasticsearch.yml`:
Elasticsearch 使用`node.name`作为 Elasticsearch 特定实例的人类可读标识符。此名称包含在许多 API 的响应中。 Elasticsearch 启动时节点名称默认为机器的主机名，但可以在`elasticsearch.yml`中显式配置：

```yaml
node.name: prod-data-2
```

## Network host setting 网络主机设置

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/setup/important-settings/network-host.asciidoc)

By default, Elasticsearch only binds to loopback addresses such as `127.0.0.1` and `[::1]`. This is sufficient to run a cluster of one or more nodes on a single server for development and testing, but a [resilient production cluster](https://www.elastic.co/guide/en/elasticsearch/reference/current/high-availability-cluster-design.html) must involve nodes on other servers. There are many [network settings](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-network.html) but usually all you need to configure is `network.host`:
默认情况下，Elasticsearch 仅绑定到环回地址，例如`127.0.0.1`和`[::1]` 。这足以在一台服务器上运行一个或多个节点的集群以进行开发和测试，但[弹性生产集群](https://www.elastic.co/guide/en/elasticsearch/reference/current/high-availability-cluster-design.html)必须涉及其他服务器上的节点。有很多[网络设置](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-network.html)，但通常您需要配置的只是`network.host` ：

```yaml
network.host: 192.168.1.10
```

When you provide a value for `network.host`, Elasticsearch assumes that you are moving from development mode to production mode, and upgrades a number of system startup checks from warnings to exceptions. See the differences between [development and production modes](https://www.elastic.co/guide/en/elasticsearch/reference/current/system-config.html#dev-vs-prod).
当您为`network.host`提供值时，Elasticsearch 假定您正在从开发模式转向生产模式，并将许多系统启动检查从警告升级为异常。查看[开发和生产模式](https://www.elastic.co/guide/en/elasticsearch/reference/current/system-config.html#dev-vs-prod)之间的差异。

## Discovery and cluster formation settings 发现和集群形成设置

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/setup/important-settings/discovery-settings.asciidoc)

Configure two important discovery and cluster formation settings before going to production so that nodes in the cluster can discover each other and elect a master node.
在投入生产之前配置两个重要的发现和集群形成设置，以便集群中的节点可以相互发现并选举主节点。

### `discovery.seed_hosts`

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/setup/important-settings/discovery-settings.asciidoc)

Out of the box, without any network configuration, Elasticsearch will bind to the available loopback addresses and scan local ports `9300` to `9305` to connect with other nodes running on the same server. This behavior provides an auto-clustering experience without having to do any configuration.
开箱即用，无需任何网络配置，Elasticsearch 将绑定到可用的环回地址并扫描本地端口`9300`至`9305`以与同一服务器上运行的其他节点连接。此行为提供自动集群体验，无需进行任何配置。

When you want to form a cluster with nodes on other hosts, use the [static](https://www.elastic.co/guide/en/elasticsearch/reference/current/settings.html#static-cluster-setting) `discovery.seed_hosts` setting. This setting provides a list of other nodes in the cluster that are master-eligible and likely to be live and contactable to seed the [discovery process](https://www.elastic.co/guide/en/elasticsearch/reference/current/discovery-hosts-providers.html). This setting accepts a YAML sequence or array of the addresses of all the master-eligible nodes in the cluster. Each address can be either an IP address or a hostname that resolves to one or more IP addresses via DNS.
当您想要与其他主机上的节点形成集群时，请使用[静态](https://www.elastic.co/guide/en/elasticsearch/reference/current/settings.html#static-cluster-setting)`discovery.seed_hosts`设置。此设置提供集群中其他节点的列表，这些节点符合主节点资格，并且可能处于活动状态并可联系以启动[发现过程](https://www.elastic.co/guide/en/elasticsearch/reference/current/discovery-hosts-providers.html)。此设置接受集群中所有符合主节点资格的节点的 YAML 序列或地址数组。每个地址可以是 IP 地址，也可以是通过 DNS 解析为一个或多个 IP 地址的主机名。

```yaml
discovery.seed_hosts:
   - 192.168.1.10:9300
   - 192.168.1.11 
   - seeds.mydomain.com 
   - [0:0:0:0:0:ffff:c0a8:10c]:9301 
```

|      | The port is optional and defaults to `9300`, but can be [overridden](https://www.elastic.co/guide/en/elasticsearch/reference/current/discovery-hosts-providers.html#built-in-hosts-providers). 该端口是可选的，默认为`9300` ，但可以[覆盖](https://www.elastic.co/guide/en/elasticsearch/reference/current/discovery-hosts-providers.html#built-in-hosts-providers)。 |
| ---- | ------------------------------------------------------------ |
|      | If a hostname resolves to multiple IP addresses, the node will attempt to discover other nodes at all resolved addresses. 如果主机名解析为多个 IP 地址，则该节点将尝试在所有已解析地址处发现其他节点。 |
|      | IPv6 addresses must be enclosed in square brackets. IPv6 地址必须括在方括号内。 |

If your master-eligible nodes do not have fixed names or addresses, use an [alternative hosts provider](https://www.elastic.co/guide/en/elasticsearch/reference/current/discovery-hosts-providers.html#built-in-hosts-providers) to find their addresses dynamically.
如果符合主节点资格的节点没有固定名称或地址，请使用[替代主机提供商](https://www.elastic.co/guide/en/elasticsearch/reference/current/discovery-hosts-providers.html#built-in-hosts-providers)动态查找其地址。

### `cluster.initial_master_nodes`

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/setup/important-settings/discovery-settings.asciidoc)

When you start an Elasticsearch cluster for the first time, a [cluster bootstrapping](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-discovery-bootstrap-cluster.html) step determines the set of master-eligible nodes whose votes are counted in the first election. In [development mode](https://www.elastic.co/guide/en/elasticsearch/reference/current/bootstrap-checks.html#dev-vs-prod-mode), with no discovery settings configured, this step is performed automatically by the nodes themselves.
当您第一次启动 Elasticsearch 集群时，[集群引导](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-discovery-bootstrap-cluster.html)步骤会确定在第一次选举中计票的符合主节点资格的节点集。在[开发模式](https://www.elastic.co/guide/en/elasticsearch/reference/current/bootstrap-checks.html#dev-vs-prod-mode)下，如果没有配置发现设置，此步骤将由节点本身自动执行。

Because auto-bootstrapping is [inherently unsafe](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-discovery-quorums.html), when starting a new cluster in production mode, you must explicitly list the master-eligible nodes whose votes should be counted in the very first election. You set this list using the `cluster.initial_master_nodes` setting.
由于自动引导[本质上是不安全的](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-discovery-quorums.html)，因此在生产模式下启动新集群时，您必须明确列出符合主资格的节点，这些节点的选票应在第一次选举中计入。您可以使用`cluster.initial_master_nodes`设置来设置此列表。

After the cluster forms successfully for the first time, remove the `cluster.initial_master_nodes` setting from each node’s configuration. Do not use this setting when restarting a cluster or adding a new node to an existing cluster.
集群首次成功形成后，从每个节点的配置中删除`cluster.initial_master_nodes`设置。重新启动集群或向现有集群添加新节点时请勿使用此设置。

```yaml
discovery.seed_hosts:
   - 192.168.1.10:9300
   - 192.168.1.11
   - seeds.mydomain.com
   - [0:0:0:0:0:ffff:c0a8:10c]:9301
cluster.initial_master_nodes: 
   - master-node-a
   - master-node-b
   - master-node-c
```

|      | Identify the initial master nodes by their [`node.name`](https://www.elastic.co/guide/en/elasticsearch/reference/current/important-settings.html#node-name), which defaults to their hostname. Ensure that the value in `cluster.initial_master_nodes` matches the `node.name` exactly. If you use a fully-qualified domain name (FQDN) such as `master-node-a.example.com` for your node names, then you must use the FQDN in this list. Conversely, if `node.name` is a bare hostname without any trailing qualifiers, you must also omit the trailing qualifiers in `cluster.initial_master_nodes`. 通过其[`node.name`](https://www.elastic.co/guide/en/elasticsearch/reference/current/important-settings.html#node-name)标识初始主节点，默认为其主机名。确保`cluster.initial_master_nodes`中的值与`node.name`完全匹配。如果您使用完全限定域名 (FQDN)（例如`master-node-a.example.com` ）作为节点名称，则必须使用此列表中的 FQDN。相反，如果`node.name`是没有任何尾随限定符的裸主机名，则还必须省略`cluster.initial_master_nodes`中的尾随限定符。 |
| ---- | ------------------------------------------------------------ |
|      |                                                              |

See [bootstrapping a cluster](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-discovery-bootstrap-cluster.html) and [discovery and cluster formation settings](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-discovery-settings.html).
请参阅[引导集群](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-discovery-bootstrap-cluster.html)以及[发现和集群形成设置](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-discovery-settings.html)。

## Heap size settings 堆大小设置

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/setup/important-settings/heap-size.asciidoc)

By default, Elasticsearch automatically sets the JVM heap size based on a node’s [roles](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-node.html#node-roles) and total memory. We recommend the default sizing for most production environments.
默认情况下，Elasticsearch 根据节点的[角色](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-node.html#node-roles)和总内存自动设置 JVM 堆大小。我们建议大多数生产环境使用默认大小。

If needed, you can override the default sizing by manually [setting the JVM heap size](https://www.elastic.co/guide/en/elasticsearch/reference/current/advanced-configuration.html#set-jvm-heap-size).
如果需要，您可以通过手动[设置 JVM 堆大小](https://www.elastic.co/guide/en/elasticsearch/reference/current/advanced-configuration.html#set-jvm-heap-size)来覆盖默认大小。

## JVM heap dump path setting JVM堆转储路径设置

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/setup/important-settings/heap-dump-path.asciidoc)

By default, Elasticsearch configures the JVM to dump the heap on out of memory exceptions to the default data directory. On [RPM](https://www.elastic.co/guide/en/elasticsearch/reference/current/rpm.html) and [Debian](https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html) packages, the data directory is `/var/lib/elasticsearch`. On [Linux and MacOS](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html) and [Windows](https://www.elastic.co/guide/en/elasticsearch/reference/current/zip-windows.html) distributions, the `data` directory is located under the root of the Elasticsearch installation.
默认情况下，Elasticsearch 将 JVM 配置为将内存不足异常时的堆转储到默认数据目录。在[RPM](https://www.elastic.co/guide/en/elasticsearch/reference/current/rpm.html)和[Debian](https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html)软件包上，数据目录是`/var/lib/elasticsearch` 。在[Linux、MacOS](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html)和[Windows](https://www.elastic.co/guide/en/elasticsearch/reference/current/zip-windows.html)发行版上， `data`目录位于 Elasticsearch 安装的根目录下。

If this path is not suitable for receiving heap dumps, modify the `-XX:HeapDumpPath=...` entry in [`jvm.options`](https://www.elastic.co/guide/en/elasticsearch/reference/current/advanced-configuration.html#set-jvm-options):
如果此路径不适合接收堆转储，请修改[`jvm.options`](https://www.elastic.co/guide/en/elasticsearch/reference/current/advanced-configuration.html#set-jvm-options)中的`-XX:HeapDumpPath=...`条目：

- If you specify a directory, the JVM will generate a filename for the heap dump based on the PID of the running instance. 
  如果指定目录，JVM 将根据运行实例的 PID 为堆转储生成文件名。
- If you specify a fixed filename instead of a directory, the file must not exist when the JVM needs to perform a heap dump on an out of memory exception. Otherwise, the heap dump will fail. 
  如果指定固定文件名而不是目录，则当 JVM 需要对内存不足异常执行堆转储时，该文件不能存在。否则，堆转储将会失败。

## GC logging settings GC 日志记录设置

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/setup/important-settings/gc-logging.asciidoc)

By default, Elasticsearch enables garbage collection (GC) logs. These are configured in [`jvm.options`](https://www.elastic.co/guide/en/elasticsearch/reference/current/advanced-configuration.html#set-jvm-options) and output to the same default location as the Elasticsearch logs. The default configuration rotates the logs every 64 MB and can consume up to 2 GB of disk space.
默认情况下，Elasticsearch 启用垃圾收集 (GC) 日志。这些在[`jvm.options`](https://www.elastic.co/guide/en/elasticsearch/reference/current/advanced-configuration.html#set-jvm-options)中配置并输出到与 Elasticsearch 日志相同的默认位置。默认配置每 64 MB 轮换一次日志，最多可消耗 2 GB 磁盘空间。

You can reconfigure JVM logging using the command line options described in [JEP 158: Unified JVM Logging](https://openjdk.java.net/jeps/158). Unless you change the default `jvm.options` file directly, the Elasticsearch default configuration is applied in addition to your own settings. To disable the default configuration, first disable logging by supplying the `-Xlog:disable` option, then supply your own command line options. This disables *all* JVM logging, so be sure to review the available options and enable everything that you require.
您可以使用[JEP 158：统一 JVM 日志记录](https://openjdk.java.net/jeps/158)中描述的命令行选项重新配置 JVM 日志记录。除非您直接更改默认的`jvm.options`文件，否则除了您自己的设置之外，还会应用 Elasticsearch 默认配置。要禁用默认配置，请首先通过提供`-Xlog:disable`选项来禁用日志记录，然后提供您自己的命令行选项。这会禁用*所有*JVM 日志记录，因此请务必查看可用选项并启用您需要的所有内容。

To see further options not contained in the original JEP, see [Enable Logging with the JVM Unified Logging Framework](https://docs.oracle.com/en/java/javase/13/docs/specs/man/java.html#enable-logging-with-the-jvm-unified-logging-framework).
要查看原始 JEP 中未包含的更多选项，请参阅[使用 JVM 统一日志记录框架启用日志记录](https://docs.oracle.com/en/java/javase/13/docs/specs/man/java.html#enable-logging-with-the-jvm-unified-logging-framework)。

## Examples 示例

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/setup/important-settings/gc-logging.asciidoc)

Change the default GC log output location to `/opt/my-app/gc.log` by  creating `$ES_HOME/config/jvm.options.d/gc.options` with some sample  options:
通过创建将默认 GC 日志输出位置更改为`/opt/my-app/gc.log` `$ES_HOME/config/jvm.options.d/gc.options` 有一些示例选项：

```shell
# Turn off all previous logging configuratons
-Xlog:disable

# Default settings from JEP 158, but with `utctime` instead of `uptime` to match the next line
-Xlog:all=warning:stderr:utctime,level,tags

# Enable GC logging to a custom location with a variety of options
-Xlog:gc*,gc+age=trace,safepoint:file=/opt/my-app/gc.log:utctime,level,pid,tags:filecount=32,filesize=64m
```

Configure an Elasticsearch [Docker container](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html) to send GC debug logs to  standard error (`stderr`). This lets the container orchestrator  handle the output. If using the `ES_JAVA_OPTS` environment variable,  specify:
配置 Elasticsearch [Docker 容器](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html)以将 GC 调试日志发送到标准错误 ( `stderr` )。这让容器编排器可以处理输出。如果使用`ES_JAVA_OPTS`环境变量，请指定：

```sh
MY_OPTS="-Xlog:disable -Xlog:all=warning:stderr:utctime,level,tags -Xlog:gc=debug:stderr:utctime"
docker run -e ES_JAVA_OPTS="$MY_OPTS" # etc
```

## Temporary directory settings 临时目录设置

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/setup/important-settings/es-tmpdir.asciidoc)

By default, Elasticsearch uses a private temporary directory that the startup script creates immediately below the system temporary directory.
默认情况下，Elasticsearch 使用启动脚本在系统临时目录下立即创建的私有临时目录。

On some Linux distributions, a system utility will clean files and directories from `/tmp` if they have not been recently accessed. This behavior can lead to the private temporary directory being removed while Elasticsearch is running if features that require the temporary directory are not used for a long time. Removing the private temporary directory causes problems if a feature that requires this directory is subsequently used.
在某些 Linux 发行版上，如果最近未访问过文件和目录，系统实用程序将清除`/tmp`中的文件和目录。如果长时间不使用需要临时目录的功能，此行为可能会导致 Elasticsearch 运行时私有临时目录被删除。如果随后使用需要此目录的功能，则删除私有临时目录会导致问题。

If you install Elasticsearch using the `.deb` or `.rpm` packages and run it under `systemd`, the private temporary directory that Elasticsearch uses is excluded from periodic cleanup.
如果您使用`.deb`或`.rpm`软件包安装 Elasticsearch 并在`systemd`下运行它，则 Elasticsearch 使用的私有临时目录将被排除在定期清理之外。

If you intend to run the `.tar.gz` distribution on Linux or MacOS for an extended period, consider creating a dedicated temporary directory for Elasticsearch that is not under a path that will have old files and directories cleaned from it. This directory should have permissions set so that only the user that Elasticsearch runs as can access it. Then, set the `$ES_TMPDIR` environment variable to point to this directory before starting Elasticsearch.
如果您打算在 Linux 或 MacOS 上长时间运行`.tar.gz`发行版，请考虑为 Elasticsearch 创建一个专用的临时目录，该目录不在将清除旧文件和目录的路径下。该目录应设置权限，以便只有运行 Elasticsearch 的用户才能访问它。然后，在启动 Elasticsearch 之前将`$ES_TMPDIR`环境变量设置为指向此目录。

## JVM fatal error log setting JVM致命错误日志设置

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/setup/important-settings/error-file.asciidoc)

By default, Elasticsearch configures the JVM to write fatal error logs to the default logging directory. On [RPM](https://www.elastic.co/guide/en/elasticsearch/reference/current/rpm.html) and [Debian](https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html) packages, this directory is `/var/log/elasticsearch`. On [Linux and MacOS](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html) and [Windows](https://www.elastic.co/guide/en/elasticsearch/reference/current/zip-windows.html) distributions, the `logs` directory is located under the root of the Elasticsearch installation.
默认情况下，Elasticsearch 将 JVM 配置为将致命错误日志写入默认日志记录目录。在[RPM](https://www.elastic.co/guide/en/elasticsearch/reference/current/rpm.html)和[Debian](https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html)软件包上，此目录是`/var/log/elasticsearch` 。在[Linux、MacOS](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html)和[Windows](https://www.elastic.co/guide/en/elasticsearch/reference/current/zip-windows.html)发行版上， `logs`目录位于 Elasticsearch 安装的根目录下。

These are logs produced by the JVM when it encounters a fatal error, such as a segmentation fault. If this path is not suitable for receiving logs, modify the `-XX:ErrorFile=...` entry in [`jvm.options`](https://www.elastic.co/guide/en/elasticsearch/reference/current/advanced-configuration.html#set-jvm-options).
这些是 JVM 在遇到致命错误（例如分段错误）时生成的日志。如果该路径不适合接收日志，请修改[`jvm.options`](https://www.elastic.co/guide/en/elasticsearch/reference/current/advanced-configuration.html#set-jvm-options)中的`-XX:ErrorFile=...`条目。

## Cluster backups 集群备份

[edit 编辑](https://github.com/elastic/elasticsearch/edit/8.15/docs/reference/setup/important-settings/snapshot.asciidoc)

In a disaster, [snapshots](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshot-restore.html) can prevent permanent data loss. [Snapshot lifecycle management](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html#automate-snapshots-slm) is the easiest way to take regular backups of your cluster. For more information, see [*Create a snapshot*](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html).
在灾难中，[快照](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshot-restore.html)可以防止永久性数据丢失。[快照生命周期管理](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html#automate-snapshots-slm)是定期备份集群的最简单方法。有关更多信息，请参阅[*创建快照*](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html)。

**Taking a snapshot is the only reliable and supported way to back up a cluster.** You cannot back up an Elasticsearch cluster by making copies of the data directories of its nodes. There are no supported methods to restore any data from a filesystem-level backup. If you try to restore a cluster from such a backup, it may fail with reports of corruption or missing files or other data inconsistencies, or it may appear to have succeeded having silently lost some of your data.
**拍摄快照是唯一可靠且受支持的集群备份方式。**您无法通过复制其节点的数据目录来备份 Elasticsearch 集群。不支持从文件系统级备份恢复任何数据的方法。如果您尝试从此类备份恢复集群，则可能会失败，并报告损坏或丢失文件或其他数据不一致的情况，或者可能看似已成功，但悄无声息地丢失了一些数据。
