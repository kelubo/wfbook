# InfluxDB

[InfluxDB](https://www.influxdata.com/products/) is an open-source time series database (TSDB) developed by [InfluxData](https://www.influxdata.com/). It is optimized for fast, high-availability storage and retrieval of  time series data in fields such as operations monitoring, application  metrics, IoT sensor data, and real-time analytics.
[InfluxDB](https://www.influxdata.com/products/) 是 [InfluxData](https://www.influxdata.com/) 开发的开源时序数据库 （TSDB）。它针对操作监控、应用程序指标、IoT 传感器数据和实时分析等领域的时间序列数据的快速、高可用性存储和检索进行了优化。

#### Get InfluxDB 获取 InfluxDB

You can [download InfluxDB](https://portal.influxdata.com/downloads/) and install it locally or you can sign up for [InfluxDB Cloud](https://www.influxdata.com/products/influxdb-cloud/). Windows installers are not available for some versions of InfluxDB.
您可以[下载 InfluxDB](https://portal.influxdata.com/downloads/) 并在本地安装，也可以注册 [InfluxDB Cloud](https://www.influxdata.com/products/influxdb-cloud/)。Windows 安装程序不适用于某些版本的 InfluxDB。

#### Install other InfluxDB software 安装其他 InfluxDB 软件

[Install Telegraf](https://docs.influxdata.com/telegraf/v1.18/introduction/installation/). This tool is an agent that helps you get metrics into InfluxDB. For more information, refer to [Telegraf documentation](https://docs.influxdata.com/telegraf/v1.18/).
[安装 Telegraf](https://docs.influxdata.com/telegraf/v1.18/introduction/installation/)。此工具是一个代理，可帮助您将指标导入 InfluxDB。有关更多信息，请参阅 [Telegraf 文档](https://docs.influxdata.com/telegraf/v1.18/)。

If you chose to use InfluxDB Cloud, then you should [download and install the InfluxDB Cloud CLI](https://portal.influxdata.com/downloads/). This tool allows you to send command line instructions to your cloud account. For more information, refer to [Influx CLI documentation](https://docs.influxdata.com/influxdb/cloud/write-data/developer-tools/influx-cli/).
如果您选择使用 InfluxDB Cloud，则应[下载并安装 InfluxDB Cloud CLI](https://portal.influxdata.com/downloads/)。此工具允许您将命令行指令发送到您的云帐户。有关更多信息，请参阅 [Influx CLI 文档](https://docs.influxdata.com/influxdb/cloud/write-data/developer-tools/influx-cli/)。

#### Get data into InfluxDB 将数据导入 InfluxDB

If you downloaded and installed InfluxDB on your local machine, then use the [Quick Start](https://docs.influxdata.com/influxdb/v2.0/write-data/#quick-start-for-influxdb-oss) feature to visualize InfluxDB metrics.
如果您在本地计算机上下载并安装了 InfluxDB，则使用[快速入门](https://docs.influxdata.com/influxdb/v2.0/write-data/#quick-start-for-influxdb-oss)功能可视化 InfluxDB 指标。

If you are using the cloud account, then the wizards will guide you through the initial process. For more information, refer to [Configure Telegraf](https://docs.influxdata.com/influxdb/cloud/write-data/no-code/use-telegraf/#configure-telegraf).
如果您使用的是云帐户，则向导将指导您完成初始过程。有关更多信息，请参阅[配置 Telegraf](https://docs.influxdata.com/influxdb/cloud/write-data/no-code/use-telegraf/#configure-telegraf)。

##### Note for Windows users: Windows 用户注意事项：

Windows users might need to make additional adjustments. Look for special instructions in the InfluxData documentation and [Using Telegraf on Windows](https://www.influxdata.com/blog/using-telegraf-on-windows/) blog post. The regular system monitoring template in InfluxDB Cloud is  not compatible with Windows. Windows users who use InfluxDB Cloud to  monitor their system will need to use the [Windows System Monitoring Template](https://github.com/influxdata/community-templates/tree/master/windows_system).
Windows 用户可能需要进行其他调整。在 InfluxData 文档和[在 Windows 上使用 Telegraf](https://www.influxdata.com/blog/using-telegraf-on-windows/) 博客文章中查找特殊说明。InfluxDB Cloud 中的常规系统监控模板与 Windows 不兼容。使用 InfluxDB Cloud 监控系统的 Windows 用户需要使用 [Windows 系统监控模板](https://github.com/influxdata/community-templates/tree/master/windows_system)。

#### Add your InfluxDB data source to Grafana 将 InfluxDB 数据源添加到 Grafana

You can have more than one InfluxDB data source defined in Grafana.
您可以在 Grafana 中定义多个 InfluxDB 数据源。

1. Follow the general instructions to [add a data source](https://grafana.com/docs/grafana/latest/datasources/#add-a-data-source).
   按照一般说明[添加数据源](https://grafana.com/docs/grafana/latest/datasources/#add-a-data-source)。

2. Decide if you will use InfluxQL or Flux as your query language.

   
   决定是使用 InfluxQL 还是 Flux 作为查询语言。

   - [Configure the data source](https://grafana.com/docs/grafana/latest/datasources/influxdb/#configure-the-data-source) for your chosen query language. Each query language has its own unique data source settings.
     为您选择的查询语言[配置数据源](https://grafana.com/docs/grafana/latest/datasources/influxdb/#configure-the-data-source)。每种查询语言都有其自己唯一的数据源设置。
   - For querying features specific to each language, see the data source’s [query editor documentation](https://grafana.com/docs/grafana/latest/datasources/influxdb/query-editor/).
     有关特定于每种语言的查询功能，请参阅数据源的[查询编辑器文档](https://grafana.com/docs/grafana/latest/datasources/influxdb/query-editor/)。

##### InfluxDB guides InfluxDB 使用指南

InfluxDB publishes guidance for connecting different versions of their product to Grafana.
InfluxDB 发布了将其产品的不同版本连接到 Grafana 的指南。

- **InfluxDB OSS or Enterprise 1.8+.** To turn on Flux, refer to [Configure InfluxDB](https://docs.influxdata.com/influxdb/v1.8/administration/config/#flux-enabled-false.). Select your InfluxDB version in the upper right corner.
  **InfluxDB OSS 或 Enterprise 1.8+。**要开启 Flux，请参阅[配置 InfluxDB](https://docs.influxdata.com/influxdb/v1.8/administration/config/#flux-enabled-false.)。在右上角选择您的 InfluxDB 版本。
- **InfluxDB OSS or Enterprise 2.x.** Refer to [Use Grafana with InfluxDB](https://docs.influxdata.com/influxdb/v2.0/tools/grafana/). Select your InfluxDB version in the upper right corner.
  **InfluxDB OSS 或 Enterprise 2.x。**参考 [将 Grafana 与 InfluxDB 结合使用](https://docs.influxdata.com/influxdb/v2.0/tools/grafana/)。在右上角选择您的 InfluxDB 版本。
- **InfluxDB Cloud.** Refer to [Use Grafana with InfluxDB Cloud](https://docs.influxdata.com/influxdb/cloud/tools/grafana/).
  **InfluxDB 云。**请参阅[将 Grafana 与 InfluxDB Cloud 结合使用](https://docs.influxdata.com/influxdb/cloud/tools/grafana/)。

##### Important tips 重要提示

- Make sure your Grafana token has read access. If it doesn’t, then you’ll get an authentication error and be unable to connect Grafana to InfluxDB.
  确保您的 Grafana 令牌具有读取访问权限。如果没有，那么您将收到身份验证错误，并且无法将 Grafana 连接到 InfluxDB。
- Avoid apostrophes and other non-standard characters in bucket and token names.
  避免在存储桶和令牌名称中使用撇号和其他非标准字符。
- If the text name of the organization or bucket doesn’t work, then try the ID number.
  如果组织或存储桶的文本名称不起作用，请尝试使用 ID 号。
- If you change your bucket name in InfluxDB, then you must also change it in Grafana and your Telegraf .conf file as well.
  如果您在 InfluxDB 中更改存储桶名称，则还必须在 Grafana 和 Telegraf .conf 文件中更改它。

#### Add a query 添加查询

This step varies depending on the query language that you selected when you set up your data source in Grafana.
此步骤因您在 Grafana 中设置数据源时选择的查询语言而异。

##### InfluxQL query language InfluxQL 查询语言

In the query editor, click **select measurement**.
在查询编辑器中，单击 **select measurement**.

![InfluxQL query](https://grafana.com/static/img/docs/influxdb/influxql-query-7-5.png)

Grafana displays a list of possible series. Click one to select it, and Grafana graphs any available data. If there is no data to display, then try  another selection or check your data source.
Grafana 将显示可能的序列列表。单击一个以选择它，Grafana 将绘制任何可用数据的图表。如果没有要显示的数据，请尝试其他选择或检查您的数据源。

##### Flux query language Flux 查询语言

Create a simple Flux query.
创建一个简单的 Flux 查询。

1. [Add a panel](https://grafana.com/docs/grafana/latest/dashboards/build-dashboards/create-dashboard/). [添加面板](https://grafana.com/docs/grafana/latest/dashboards/build-dashboards/create-dashboard/)。
2. In the query editor, select your InfluxDB-Flux data source. For more information, refer to [Queries](https://grafana.com/docs/grafana/latest/panels-visualizations/query-transform-data/).
   在查询编辑器中，选择您的 InfluxDB-Flux 数据源。有关更多信息，请参阅 [查询](https://grafana.com/docs/grafana/latest/panels-visualizations/query-transform-data/).
3. Select the **Table** visualization.
   选择 **Table** visualization.
4. In the query editor text field, enter `buckets()` and then click outside of the query editor.
   在查询编辑器文本字段中，输入 `buckets（），`然后单击查询编辑器外部。

This generic query returns a list of buckets.
此通用查询返回存储桶列表。

![Flux query](https://grafana.com/static/img/docs/influxdb/flux-query-7-5.png)

You can also create Flux queries in the InfluxDB Explore view.
您还可以在 InfluxDB Explore 视图中创建 Flux 查询。

1. In your browser, log in to the InfluxDB native UI (OSS is typically  something like http://localhost:8086 or for InfluxDB Cloud use: https://cloud2.influxdata.com).
   在浏览器中，登录到 InfluxDB 本机 UI（OSS 通常类似于 http://localhost:8086 或 InfluxDB Cloud 使用：https://cloud2.influxdata.com）。

2. Click **Explore** to open the Data Explorer.
   单击 **Explore** 以打开 Data Explorer。

3. The InfluxDB Data Explorer provides two mechanisms for creating Flux  queries: a graphical query editor and a script editor. Using the  graphical query editor, [create a query](https://docs.influxdata.com/influxdb/cloud/query-data/execute-queries/data-explorer/). It will look something like this:
   InfluxDB Data Explorer 提供了两种创建 Flux 查询的机制：图形查询编辑器和脚本编辑器。使用图形查询编辑器[创建查询](https://docs.influxdata.com/influxdb/cloud/query-data/execute-queries/data-explorer/)。它看起来像这样：

   ![InfluxDB Explore query](https://grafana.com/static/img/docs/influxdb/influx-explore-query-7-5.png)

4. Click **Script Editor** to view the text of the query, and then copy all the lines of your Flux code, which will look something like this:
   单击 **Script Editor （脚本编辑器**） 查看查询文本，然后复制 Flux 代码的所有行，如下所示：

   ![InfluxDB Explore Script Editor](https://grafana.com/static/img/docs/influxdb/explore-query-text-7-5.png)

5. In Grafana, [add a panel](https://grafana.com/docs/grafana/latest/dashboards/build-dashboards/create-dashboard/) and then paste your Flux code into the query editor.
   在 Grafana 中，[添加一个面板](https://grafana.com/docs/grafana/latest/dashboards/build-dashboards/create-dashboard/)，然后将 Flux 代码粘贴到查询编辑器中。

6. Click **Apply**. Your new panel should be visible with data from your Flux query.
   单击 **Apply**。您的新面板应该可以看到来自 Flux 查询的数据。

#### Check InfluxDB metrics in Grafana Explore 在 Grafana Explore 中检查 InfluxDB 指标

In your Grafana instance, go to the [Explore](https://grafana.com/docs/grafana/latest/explore/) view and build queries to experiment with the metrics you want to  monitor. Here you can also debug issues related to collecting metrics.
在您的 Grafana 实例中，转到 Explore （[浏览](https://grafana.com/docs/grafana/latest/explore/)） 视图并构建查询以试验要监控的指标。在这里，您还可以调试与收集指标相关的问题。

#### Start building dashboards 开始构建仪表板

There you go! Use Explore and Data Explorer to experiment with your data, and add the queries that you like to your dashboard as panels. Have fun!
给你！使用 Explore 和 Data Explorer 对数据进行试验，并将所需的查询作为面板添加到控制面板中。玩得愉快！

Here are some resources to learn more:
以下是一些资源，可了解更多信息：

- Grafana documentation: [InfluxDB data source](https://grafana.com/docs/grafana/latest/datasources/influxdb/)
  Grafana 文档：[InfluxDB 数据源](https://grafana.com/docs/grafana/latest/datasources/influxdb/)
- InfluxDB documentation: [Comparison of Flux vs InfluxQL](https://docs.influxdata.com/influxdb/v1.8/flux/flux-vs-influxql/)
  InfluxDB 文档：[Flux 与 InfluxQL 的比较](https://docs.influxdata.com/influxdb/v1.8/flux/flux-vs-influxql/)