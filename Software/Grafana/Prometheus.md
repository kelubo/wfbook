# 什么是 Prometheus？

Observability focuses on understanding the internal state of your systems based on  the data they produce, which helps determine if your infrastructure is  healthy. Prometheus is a core technology for monitoring and  observability of systems, but the term “Prometheus” can be confusing  because it is used in different contexts. Understanding Prometheus  basics, why it’s valuable for system observability, and how users use it in practice will both help you better understand it and help you use  Grafana.
可观测性侧重于根据系统生成的数据了解系统的内部状态，这有助于确定您的基础设施是否正常运行。Prometheus 是用于监控和可观测系统的核心技术，但术语 “Prometheus” 可能会令人困惑，因为它用于不同的上下文。了解 Prometheus  基础知识、为什么它对系统可观测性有价值，以及用户在实践中如何使用它，都将帮助您更好地理解它，并帮助您使用 Grafana。

Prometheus began in 2012 at SoundCloud because existing technologies were  insufficient for their observability needs. Prometheus offers both a  robust data model and a query language. Prometheus is also simple and  scalable. In 2018, Prometheus graduated from Cloud Native Computing  Foundation (CNCF) incubation, and today has a thriving community.
Prometheus 于 2012 年在 SoundCloud 成立，因为现有技术不足以满足其可观测性需求。Prometheus  提供强大的数据模型和查询语言。Prometheus 也很简单且可扩展。2018 年，Prometheus 从云原生计算基金会 （CNCF）  孵化中毕业，如今拥有一个蓬勃发展的社区。

## Prometheus as data Prometheus 作为数据

The following panel in a Grafana dashboard shows how much disk bandwidth on a Mac laptop is being used. The green line represents disk `reads`, and the yellow line represents `writes`.
Grafana 仪表板中的以下面板显示了 Mac 笔记本电脑上正在使用的磁盘带宽量。绿线表示磁盘`读取`，黄线表示`写入`。

![Disk I/O dashboard](https://grafana.com/media/docs/grafana/intro-prometheus/disk-io.png)

Disk I/O dashboard 磁盘 I/O 控制面板

Data like these form *time series*. The X-axis is a moment in time and the Y-axis is a number or  measurement; for example, 5 megabytes per second. This type of time  series data appears everywhere in systems monitoring, as well as in  places such as seasonal temperature charts and stock prices. This data  is simply some measurement (such as a company stock price or Disk I/O)  through a series of time instants.
像这样的数据会形成*时间序列*。X 轴是时刻，Y 轴是数字或测量值;例如，每秒 5 MB。这种类型的时间序列数据在系统监控中随处可见，也出现在季节性温度图表和股票价格等地方。此数据只是通过一系列时间时刻进行的一些度量（例如公司股票价格或磁盘 I/O）。

Prometheus is a technology that collects and stores time series data. Time series are fundamental to Prometheus; its [data model](https://prometheus.io/docs/concepts/data_model/) is arranged into:
Prometheus 是一种收集和存储时间序列数据的技术。时间序列是 Prometheus 的基础;其[数据模型](https://prometheus.io/docs/concepts/data_model/)分为：

- *metrics* that consist of a *timestamp* and a *sample*, which is the numeric value, such as how many disk bytes have been read or a stock price
  由*时间戳*和样本组成的*指标*，*样本*是数值，例如已读取的磁盘字节数或股票价格
- a set of labels called *dimensions*, for example, `job` and `device`
  一组称为*维度*的标签，例如 `Job` 和 `Device`

You can store time series data in any relational database, however, these  systems are not developed to store and query large volumes of time  series data. Prometheus and similar software provide tools to compact  and optimize time series data.
您可以将时间序列数据存储在任何关系数据库中，但是，这些系统并不是为存储和查询大量时间序列数据而开发的。Prometheus 和类似软件提供了压缩和优化时间序列数据的工具。

### Simple dashboard using PromQL 使用 PromQL 的简单仪表板

The following Grafana dashboard image shows a Disk I/O graph of raw data from Prometheus derived from a laptop.
以下 Grafana 控制面板图像显示了从笔记本电脑获取的 Prometheus 原始数据的磁盘 I/O 图。

The **Metrics browser** field contains the following query:
**Metrics browser** 字段包含以下查询：

```
node_disk_written_bytes_total{job="integrations/macos-node", device!=""}
```

In this example, the Y-axis shows the total number of bytes written, and  the X-axis shows dates and times. As the laptop runs, the number of  bytes written increases over time. Below **Metrics browser** is a counter that counts the number of bytes written over time.
在此示例中，Y 轴显示写入的总字节数，X 轴显示日期和时间。随着便携式计算机的运行，写入的字节数会随着时间的推移而增加。**Metrics browser （指标浏览器**） 下面是一个计数器，用于计算随时间推移写入的字节数。

![Metrics browser and counter](https://grafana.com/media/docs/grafana/intro-prometheus/dashboard-example.png)

Metrics browser and counter
指标浏览器和计数器

The query is a simple example of [PromQL](https://grafana.com/blog/2020/02/04/introduction-to-promql-the-prometheus-query-language/), the Prometheus Query Language. The query identifies the metric of interest (`node_disk_written_bytes_total`) and provides two labels (`job` and `device`). The label selector `job="integrations/macos-node"` filters metrics. It both reduces the scope of the metrics to those  coming from the MacOS integration job and specifies that the “device”  label cannot be empty. The result of this query is the raw stream of  numbers that the graph displays.
该查询是 [PromQL（](https://grafana.com/blog/2020/02/04/introduction-to-promql-the-prometheus-query-language/)Prometheus 查询语言）的一个简单示例。该查询标识感兴趣的指标 （`node_disk_written_bytes_total`） 并提供两个标签 （`job` 和 `device`）。标签选择器 `job=“integrations/macos-node”` 筛选量度。它既将指标的范围缩小到来自 MacOS 集成作业的指标，又指定“device”标签不能为空。此查询的结果是图表显示的原始数字流。

Although this view provides some insight into the performance of the system, it  doesn’t provide the full story. A clearer picture of system performance  requires understanding the rate of change that displays *how fast the data being written is changing*. To properly monitor disk performance, you need to also see spikes in  activity that illustrate if and when the system is under load, and  whether disk performance is at risk. PromQL includes a [rate()](https://prometheus.io/docs/prometheus/latest/querying/functions/#rate) function that shows the per-second average rate of increase over `5m` (5-minute) intervals. This view provides a much clearer picture of what’s happening with the system.
尽管此视图提供了对系统性能的一些见解，但它并不能提供完整的情况。要更清楚地了解系统性能，需要了解显示*写入数据变化速度*的变化率。要正确监控磁盘性能，您还需要查看活动峰值，以说明系统是否以及何时处于负载状态，以及磁盘性能是否存在风险。PromQL 包括一个 [rate（）](https://prometheus.io/docs/prometheus/latest/querying/functions/#rate) 函数，该函数显示在 `5 米`（5 分钟）间隔内的每秒平均增加率。此视图提供了系统所发生情况的更清晰画面。

![Prometheus rate function](https://grafana.com/media/docs/grafana/intro-prometheus/rate-function.png)

Prometheus rate function Prometheus rate 函数

A counter metric is just one type of metric; it is a number (such as total bytes written) that only increases. Prometheus [supports several others](https://prometheus.io/docs/concepts/metric_types/), such as the metric type `gauge`, which can increase or decrease.
计数器指标只是一种类型的指标;它是一个只会增加的数字 （例如写入的总字节数） 。Prometheus [支持其他几种功能](https://prometheus.io/docs/concepts/metric_types/)，例如度量类型`仪表`，它可以增加或减少。

The following gauge visualization displays the total RAM usage on a computer.
以下仪表可视化显示计算机上的总 RAM 使用情况。

![Gauge visualization](https://grafana.com/media/docs/grafana/intro-prometheus/gauge-example.png)

Gauge visualization 仪表可视化

The third metric type is called a `histogram`, which counts observations and organizes them into configurable groups.  The following example displays floating-point numbers grouped into  ranges that display how frequently each occurred.
第三种指标类型称为`直方图`，它对观测值进行计数并将其组织到可配置的组中。以下示例显示分组到多个范围中的浮点数，这些数字显示每个数字的出现频率。

![Histogram visualization](https://grafana.com/media/docs/grafana/intro-prometheus/histogram-example.png)

Histogram visualization 直方图可视化

These core concepts of time series, metrics, labels, and aggregation functions are foundational to Grafana and observability.
时间序列、指标、标签和聚合函数的这些核心概念是 Grafana 和可观测性的基础。

## Why this is valuable 为什么这很有价值

Software and systems are a difficult business. Sometimes things go wrong.  Observability helps you understand a system’s state so that issues can  be quickly identified and proactively addressed. And when problems do  occur, you can be alerted to them to diagnose and solve them within your Service Level Objectives (SLOs).
软件和系统是一项艰巨的任务。有时事情会出错。可观测性可帮助您了解系统的状态，以便快速识别并主动解决问题。当问题确实发生时，您可以收到警报，提醒他们在您的服务级别目标 （SLO） 内进行诊断和解决。

The [three pillars of observability](https://www.oreilly.com/library/view/distributed-systems-observability/9781492033431/ch04.html) are metrics, logs, and traces. Prometheus supports the metrics pillar.  When software on a computer runs slowly, observability can help you  identify whether CPU is saturated, the system is out of memory, or if  the disk is writing at maximum speed so you can proactively respond.
[可观测性的三大支柱](https://www.oreilly.com/library/view/distributed-systems-observability/9781492033431/ch04.html)是指标、日志和跟踪。Prometheus 支持 metrics 支柱。当计算机上的软件运行缓慢时，可观测性可以帮助您确定 CPU 是否饱和、系统内存不足或磁盘是否以最大速度写入，以便您可以主动响应。

## Prometheus as software Prometheus 作为软件

Prometheus isn’t just a data format; it is also considered an [open source systems monitoring and alerting toolkit](https://prometheus.io/docs/introduction/overview/). That’s because Prometheus is software, not just data.
Prometheus 不仅仅是一种数据格式;它也被认为是一个[开源系统监控和警报工具包](https://prometheus.io/docs/introduction/overview/)。这是因为 Prometheus 是软件，而不仅仅是数据。

Prometheus can scrape metric data from software and infrastructure and store it.  Scraping means that Prometheus software periodically revisits the same  endpoint to check for new data. Prometheus scrapes data from a piece of  software instrumented with a client library.
Prometheus 可以从软件和基础设施中抓取指标数据并将其存储起来。抓取意味着 Prometheus 软件会定期重新访问同一终端节点以检查新数据。Prometheus 从使用客户端库检测的软件中抓取数据。

For example, a NodeJS application can configure the [prom-client](https://github.com/siimon/prom-client) to expose metrics easily at an endpoint, and Prometheus can regularly  scrape that endpoint. Prometheus includes a number of other tools within the toolkit to instrument your applications.
例如，NodeJS 应用程序可以将 [prom-client](https://github.com/siimon/prom-client) 配置为在终端节点上轻松公开指标，而 Prometheus 可以定期抓取该终端节点。Prometheus 在工具包中包含许多其他工具来检测您的应用程序。

## Prometheus as deployment Prometheus 作为部署

The first section of this document introduced the Prometheus as Data  concept and how the Prometheus data model and metrics are organized. The second section introduced the concept of Prometheus as Software that is used to collect, process, and store metrics. This section describes how Prometheus as Data and Prometheus as Software come together.
本文档的第一部分介绍了 Prometheus as Data 概念以及 Prometheus 数据模型和指标的组织方式。第二部分介绍了 Prometheus  作为用于收集、处理和存储指标的软件的概念。本节介绍了作为数据的 Prometheus 和作为软件的 Prometheus 是如何组合在一起的。

Consider the following example. Suppose a ‘MyApp’ application uses a Prometheus  client to expose metrics. One approach to collecting metrics data is to  use a URL in the application that points to an endpoint `http://localhost:3000/metrics` that produces Prometheus metrics data.
请考虑以下示例。假设 'MyApp' 应用程序使用 Prometheus 客户端来公开指标。收集指标数据的一种方法是在应用程序中使用指向生成 Prometheus 指标数据的终端节点 `http://localhost:3000/metrics` 的 URL。

The following image shows the two metrics associated with the endpoint. The HELP text explains what the metric means, and the TYPE text indicates  what kind of metric it is (in this case, a gauge). `MyAppnodejs_active_request_total` indicates the number of requests (in this case, `1`). `MyAppnodejs_heap_size_total_bytes` indicates the heap size reported in bytes. There are only two numbers  because this data shows the value at the moment the data was fetched.
下图显示了与终端节点关联的两个指标。HELP 文本说明指标的含义，TYPE 文本表示它是哪种指标（在本例中为仪表）。 `MyAppnodejs_active_request_total` 表示请求数（在本例中为 `1`）。 `MyAppnodejs_heap_size_total_bytes` 指示以字节为单位报告的堆大小。只有两个数字，因为此数据显示获取数据时的值。

![Endpoint example](https://grafana.com/media/docs/grafana/intro-prometheus/endpoint-data.png)

Endpoint example 终端节点示例

The ‘MyApp’ metrics are available in an HTTP endpoint, but how do they get  to Grafana, and subsequently, into a dashboard? The process of recording and transmitting the readings of an application or piece of  infrastructure is known as *telemetry*. Telemetry is critical to observability because it helps you understand  exactly what’s going on in your infrastructure. The metrics introduced  previously, for example, `MyAppnodejs_active_requests_total`, are telemetry data.
“MyApp”指标在 HTTP 终端节点中可用，但它们如何到达 Grafana，然后进入仪表板呢？记录和传输应用程序或基础设施读数的过程称为*遥测*。遥测对于可观测性至关重要，因为它可以帮助您准确了解基础架构中发生的情况。前面介绍的指标（例如 `MyAppnodejs_active_requests_total` ）是遥测数据。

To get metrics into Grafana, you can use either the Prometheus software or [Grafana Alloy](https://grafana.com/docs/alloy/latest/) to scrape metrics. Grafana Alloy collects and forwards the telemetry  data to open-source deployments of the Grafana Stack, Grafana Cloud, or  Grafana Enterprise, where your data can be analyzed. For example, you  can configure Grafana Alloy to pull the data from ‘MyApp’ every five  seconds and send the results to Grafana Cloud.
要将指标导入 Grafana，您可以使用 Prometheus 软件或 [Grafana Alloy](https://grafana.com/docs/alloy/latest/) 来抓取指标。Grafana Alloy 收集遥测数据并将其转发到 Grafana Stack、Grafana Cloud 或 Grafana  Enterprise 的开源部署，以便分析您的数据。例如，您可以将 Grafana Alloy 配置为每 5  秒从“MyApp”中提取一次数据，并将结果发送到 Grafana Cloud。

Metrics data is only one type of telemetry data; the other kinds are logs and  traces. Using Grafana Alloy can be a great option to send telemetry data because as you scale your observability practices to include logs and  traces, which Grafana Alloy also supports, you’ve got a solution already in place.
指标数据只是遥测数据的一种类型;其他类型是日志和跟踪。使用 Grafana Alloy 是发送遥测数据的绝佳选择，因为当您扩展可观测性实践以包括日志和跟踪（Grafana Alloy 也支持）时，您已经有一个解决方案。

The following image illustrates how Grafana Alloy works as an intermediary between ‘MyApp’ and Grafana Cloud.
下图说明了 Grafana Alloy 如何作为“MyApp”和 Grafana Cloud 之间的中介。

![Grafana Alloy](https://grafana.com/media/docs/alloy/flow-diagram-small-alloy.png)

Grafana Alloy Grafana 合金

## Bringing it together 整合

The combination of Prometheus and Grafana Alloy gives you control over the  metrics you want to report, where they come from, and where they’re  going. Once the data is in Grafana, it can be stored in a Grafana Mimir  database. Grafana dashboards consist of visualizations populated by data queried from the Prometheus data source. The PromQL query filters and  aggregates the data to provide you the insight you need. With those  steps, we’ve gone from raw numbers, generated by software, into  Prometheus, delivered to Grafana, queried by PromQL, and visualized by  Grafana.
Prometheus 和 Grafana Alloy 的组合让您可以控制要报告的指标、指标的来源和去向。一旦数据进入 Grafana，就可以存储在 Grafana  Mimir 数据库中。Grafana 控制面板由从 Prometheus 数据源查询的数据填充的可视化组成。PromQL  查询筛选和聚合数据，为您提供所需的见解。通过这些步骤，我们已经从软件生成的原始数字转变为 Prometheus，然后交付给 Grafana，由  PromQL 查询，并由 Grafana 可视化。

## What’s next? 下一步是什么？

Now that you understand how Prometheus metrics work, what will you build?
现在您已经了解了 Prometheus 指标的工作原理，您将构建什么？

- One great next step is to [build a dashboard](https://grafana.com/docs/grafana/latest/dashboards/build-dashboards/) in Grafana and start turning that raw Prometheus telemetry data into  insights about what’s going with your services and infrastructure.
  下一步是一个很好的步骤是在 Grafana [中构建一个仪表板](https://grafana.com/docs/grafana/latest/dashboards/build-dashboards/)，并开始将原始 Prometheus 遥测数据转化为有关您的服务和基础设施进展情况的见解。
- Another great step is to learn about [Grafana Mimir](https://grafana.com/oss/mimir/), which is essentially a database for Prometheus data. If you’re  wondering how to make this work for a large volumes of metrics with a  lot of data and fast querying, check out Grafana Mimir.
  另一个重要的步骤是了解 [Grafana Mimir](https://grafana.com/oss/mimir/)，它本质上是一个 Prometheus 数据的数据库。如果您想知道如何使此功能适用于具有大量数据和快速查询的大量指标，请查看 Grafana Mimir。
- If you’re interested in working with Prometheus data in Grafana directly, check out the [Prometheus data source](https://grafana.com/docs/grafana/latest/datasources/prometheus/) documentation, or check out [PromQL basics](https://prometheus.io/docs/prometheus/latest/querying/basics/).
  如果您有兴趣直接在 Grafana 中使用 Prometheus 数据，请查看 [Prometheus 数据源](https://grafana.com/docs/grafana/latest/datasources/prometheus/)文档，或查看 [PromQL 基础知识](https://prometheus.io/docs/prometheus/latest/querying/basics/)。