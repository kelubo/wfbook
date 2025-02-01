# ES|QL ES|QL 系列

[edit 编辑](https://github.com/elastic/kibana/edit/8.15/docs/concepts/esql.asciidoc)

The Elasticsearch Query Language, ES|QL, makes it faster and easier to explore your data.
Elasticsearch 查询语言 ES|QL 可以更快、更轻松地探索数据。

ES|QL is a piped language which allows you to chain together multiple commands to query your data. Based on the query, Lens suggestions in Discover create a visualization of the query results.
ES|QL 是一种管道语言，允许您将多个命令链接在一起以查询数据。根据查询，Discover 中的 Lens 建议会创建查询结果的可视化效果。

ES|QL comes with its own dedicated ES|QL Compute Engine for greater  efficiency. With one query you can search, aggregate, calculate and  perform data transformations without leaving **Discover**. Write your query directly in **Discover** or use the **Dev Tools** with the [ES|QL API](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/esql-rest.html).
ES|QL 自带专用 ES|QL Compute Engine 可提高效率。只需一个查询，您就可以在不离开 **Discover** 的情况下进行搜索、聚合、计算和执行数据转换。直接在 **Discover** 中编写查询，或者将**开发工具**与 [ES|QL API](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/esql-rest.html) 的 API 中。

Here’s how to use ES|QL in the data view selector in **Discover**:
以下是使用 ES|**Discover** 数据视图选择器中的 QL：

![An image of the Discover UI where users can access the ES|QL feature](https://www.elastic.co/guide/en/kibana/current/images/esql-data-view-menu.png)

ES|QL also features in-app help, so you can get started faster and don’t have to leave the application to check syntax.
ES|QL 还具有应用程序内帮助功能，因此您可以更快地开始，而不必离开应用程序来检查语法。

![An image of the Discover UI where users can browse the in-app help](https://www.elastic.co/guide/en/kibana/current/images/esql-in-app-help.png)

You can also use ES|QL queries to create panels on your dashboards, create enrich policies, and create alerting rules.
您还可以使用 ES|QL 查询，用于在控制面板上创建面板、创建扩充策略和创建警报规则。

For more detailed information about ES|QL in Kibana, refer to [Using ES|QL in Kibana](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/esql-kibana.html).
有关 ES|Kibana 中的 QL，请参考 [使用 ES|Kibana 中的 QL](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/esql-kibana.html)。

ES|QL is enabled by default in Kibana. It can be disabled using the `enableESQL` setting from the [Advanced Settings](https://www.elastic.co/guide/en/kibana/8.15/advanced-options.html).
ES|QL 在 Kibana 中默认启用。可以使用 [Advanced Settings](https://www.elastic.co/guide/en/kibana/8.15/advanced-options.html) 中的 `enableESQL` 设置来禁用它。

This will hide the ES|QL user interface from various applications. However, users will be able to access existing ES|QL artifacts like saved searches and visualizations.
这将隐藏 ES|来自各种应用程序的 QL 用户界面。但是，用户将能够访问现有的 ES|QL 工件，如保存的搜索和可视化。

## Observability 可观察性

[edit 编辑](https://github.com/elastic/kibana/edit/8.15/docs/concepts/esql.asciidoc)

ES|QL makes it much easier to analyze metrics, logs and traces from a single  query. Find performance issues fast by defining fields on the fly,  enriching data with lookups, and using simultaneous query processing.  Combining ES|QL with machine learning and AiOps can improve detection  accuracy and use aggregated value thresholds.
ES|QL 可以更轻松地分析来自单个查询的指标、日志和跟踪。通过动态定义字段、使用查找丰富数据以及使用同步查询处理来快速发现性能问题。结合 ES|具有机器学习和 AiOps 的 QL 可以提高检测准确性并使用聚合值阈值。

## Security 安全

[edit 编辑](https://github.com/elastic/kibana/edit/8.15/docs/concepts/esql.asciidoc)

Use ES|QL to retrieve important information for investigation by using  lookups. Enrich data and create new fields on the go to gain valuable  insight for faster decision-making and actions. For example, perform a  lookup on an IP address to identify its geographical location, its  association with known malicious entities, or whether it belongs to a  known cloud service provider all from one search bar. ES|QL ensures more accurate alerts by incorporating aggregated values in detection rules.
使用 ES|QL 使用查找检索重要信息以进行调查。随时随地丰富数据并创建新字段，以获得有价值的见解，从而更快地做出决策和采取行动。例如，对 IP  地址执行查找以确定其地理位置、它与已知恶意实体的关联，或者它是否属于已知的云服务提供商，所有这些都从一个搜索栏中完成。ES|QL  通过在检测规则中合并聚合值来确保更准确的警报。

## What’s next? 下一步是什么？

[edit 编辑](https://github.com/elastic/kibana/edit/8.15/docs/concepts/esql.asciidoc)

The main documentation for ES|QL lives in the [Elasticsearch docs](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/esql.html).
The main documentation for ES|QL 位于 [Elasticsearch 文档中](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/esql.html)。

We also have a short tutorial in the **Discover** docs: [Using ES|QL](https://www.elastic.co/guide/en/kibana/current/try-esql.html).
我们在 **Discover** 文档中还有一个简短的教程：[使用 ES|QL](https://www.elastic.co/guide/en/kibana/current/try-esql.html)的。