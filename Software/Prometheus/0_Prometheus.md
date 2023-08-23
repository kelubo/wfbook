# Prometheus

[TOC]

## 概述

Prometheus 是一个开源的系统监控和警报工具包，最初构建于 SoundCloud 。从 2012 年开始由前 Google 工程师在 SoundCloud 以开源软件的形式进行研发，并且于 2015 年早期对外发布早期版本。现在是一个独立的开源项目，独立于任何公司进行维护。2016 年 5 月继 Kubernetes 之后成为第二个正式加入 [Cloud Native Computing Foundation](https://cncf.io/) 的项目，同年 6 月正式发布 1.0 版本。2017 年底发布了基于全新存储层的 2.0 版本，能更好地与容器平台、云平台配合。

Prometheus 收集并存储其度量作为时间序列数据，即度量信息与记录的时间戳一起存储，以及称为标签的可选键值对。通过在被监控的目标上抓取度量 HTTP 端点来收集这些目标的度量。

 ![](../../Image/p/prometheus-release-roadmaps.png)

## 功能

Prometheus 的主要特征是：

- 一个多维数据模型，包含由度量名称和键/值对标识的时间序列数据。
- PromQL，leverage this dimensionality一种灵活的查询语言，可以利用这种维度
- 不依赖分布式存储；单个服务器节点是自主的。
- 时间序列收集通过 HTTP 上的 pull 模型进行。
- 支持通过中间网关推送时间序列。
- 通过服务发现或静态配置发现目标。
- 支持多种图形和仪表板模式。

# Basic Architecture of Prometheus

The basic components of a Prometheus setup are:

- Prometheus Server (the server which scrapes and stores the metrics data).
- Targets to be scraped, for example an instrumented application that  exposes its metrics, or an exporter that exposes metrics of another  application.
- Alertmanager to raise alerts based on preset rules.

(Note: Apart from this Prometheus has push_gateway which is not covered here).

[![Architecture](https://prometheus.io/assets/tutorial/architecture.png)](https://prometheus.io/assets/tutorial/architecture.png)

Let's consider a web server as an example application and we want to  extract a certain metric like the number of API calls processed by the  web server. So we add certain instrumentation code using the Prometheus  client library and expose the metrics information. Now that our web  server exposes its metrics we can configure Prometheus to scrape it. Now Prometheus is configured to fetch the metrics from the web server which is listening on xyz IP address port 7500 at a specific time interval,  say, every minute.

At 11:00:00 when I make the server public for consumption, the  application calculates the request count and exposes it, Prometheus  simultaneously scrapes the count metric and stores the value as 0.

By 11:01:00 one request is processed. The instrumentation logic in  the server increments the count to 1. When Prometheus scrapes the metric the value of count is 1 now.

By 11:02:00 two more requests are processed and the request count is 1+2 = 3 now. Similarly metrics are scraped and stored.

The user can control the frequency at which metrics are scraped by Prometheus.

| Time Stamp | Request Count (metric) |
| ---------- | ---------------------- |
| 11:00:00   | 0                      |
| 11:01:00   | 1                      |
| 11:02:00   | 3                      |

(Note: This table is just a representation for understanding purposes. Prometheus doesn’t store the values in this exact format)

Prometheus also has an API which allows to query metrics which have  been stored by scraping. This API is used to query the metrics, create  dashboards/charts on it etc. PromQL is used to query these metrics.

A simple Line chart created on the Request Count metric will look like this

[![Graph](https://prometheus.io/assets/tutorial/sample_graph.png)](https://prometheus.io/assets/tutorial/sample_graph.png)

One can scrape multiple useful metrics to understand what is  happening in the application and create multiple charts on them. Group  the charts into a dashboard and use it to get an overview of the  application.

# Show me how it is done

Let’s get our hands dirty and setup Prometheus. Prometheus is written using [Go](https://golang.org/) and all you need is the binary compiled for your operating system.  Download the binary corresponding to your operating system from [here](https://prometheus.io/download/) and add the binary to your path.

Prometheus exposes its own metrics which can be consumed by itself or another Prometheus server.

Now that we have Prometheus installed, the next step is to run it.  All that we need is just the binary and a configuration file. Prometheus uses yaml files for configuration.

```
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets: ["localhost:9090"]
```

In the above configuration file we have mentioned the `scrape_interval`, i.e how frequently we want Prometheus to scrape the metrics. We have added `scrape_configs` which has a name and target to scrape the metrics from. Prometheus by default listens on port 9090. So add it to targets.

> prometheus --config.file=prometheus.yml



Now we have Prometheus up and running and scraping its own metrics  every 15s. Prometheus has standard exporters available to export  metrics. Next we will run a node exporter which is an exporter for  machine metrics and scrape the same using Prometheus. ([Download node metrics exporter.](https://prometheus.io/download/#node_exporter))

Run the node exporter in a terminal.

```
./node_exporter
```

[![Node exporter](https://prometheus.io/assets/tutorial/node_exporter.png)](https://prometheus.io/assets/tutorial/node_exporter.png)

Next, add node exporter to the list of scrape_configs:

```
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets: ["localhost:9090"]
  - job_name: node_exporter
    static_configs:
      - targets: ["localhost:9100"]
```



In this tutorial we discussed what are metrics and why they are important, basic architecture of Prometheus and how to run Prometheus.

## 指标

用外行的话来说，度量是数字测量。时间序列是指对一段时间内变化的记录。用户想要测量的内容因应用程序而异。对于 web 服务器，可能是请求次数（请求时间）request times。对于数据库，可能是活动连接数或活动查询数等。

度量在理解应用程序以某种方式工作的原因方面发挥着重要作用。假设正在运行一个 web 应用程序，并发现运行速度很慢。需要一些信息来了解应用程序发生了什么。例如，当请求数量高时，应用程序可能会变慢。如果有请求计数度量，可以找出原因并增加处理负载的服务器数量。

## 组件

Prometheus 生态系统由多个部分组成，其中许多是可选的：

- 主要的 Prometheus 服务器，用于抓取和存储时间序列数据。
- 用于检测应用程序代码的客户端库。
- 支持 short-lived jobs 短命工作的推送网关。
- special-purpose [exporters](https://prometheus.io/docs/instrumenting/exporters/) for services.HAProxy、StatsD、Graphite 等服务的特殊用途出口商。
- 处理警报的警报管理器。
- 各种支持工具。

大多数 Prometheus 组件都是用 Go 编写的，这使得它们很容易作为静态二进制文件进行构建和部署。

### Prometheus Server

Prometheus Server 是 Prometheus 组件中的核心部分，负责实现对监控数据的获取，存储以及查询。 Prometheus Server 可以通过静态配置管理监控目标，也可以配合使用 Service  Discovery 的方式动态管理监控目标，并从这些监控目标中获取数据。其次 Prometheus  Server 需要对采集到的监控数据进行存储，Prometheus  Server 本身就是一个时序数据库，将采集到的监控数据按照时间序列的方式存储在本地磁盘当中。最后 Prometheus  Server 对外提供了自定义的PromQL 语言，实现对数据的查询以及分析。

Prometheus Server 内置的 Express Browser UI，通过这个 UI 可以直接通过 PromQL 实现数据的查询以及可视化。

Prometheus Server 的联邦集群能力可以使其从其他的 Prometheus Server 实例中获取数据，因此在大规模监控的情况下，可以通过联邦集群以及功能分区的方式对 Prometheus Server 进行扩展。

### Exporters

Exporter 将监控数据采集的端点通过 HTTP 服务的形式暴露给 Prometheus Server，Prometheus Server 通过访问该 Exporter 提供的 Endpoint 端点，即可获取到需要采集的监控数据。

一般来说可以将 Exporter 分为2类：

- 直接采集

  这一类 Exporter 直接内置了对 Prometheus 监控的支持，比如 cAdvisor，Kubernetes，Etcd，Gokit 等，都直接内置了用于向 Prometheus 暴露监控数据的端点。

- 间接采集

  间接采集，原有监控目标并不直接支持 Prometheus，因此需要通过 Prometheus 提供的 Client  Library 编写该监控目标的监控采集程序。例如： Mysql Exporter，JMX Exporter，Consul Exporter 等。

### AlertManager

在 Prometheus  Server 中支持基于 PromQL 创建告警规则，如果满足 PromQL 定义的规则，则会产生一条告警，而告警的后续处理流程则由 AlertManager 进行管理。在 AlertManager 中我们可以与邮件，Slack 等等内置的通知方式进行集成，也可以通过 Webhook 自定义告警处理方式。AlertManager 即 Prometheus 体系中的告警处理中心。

### PushGateway

由于 Prometheus 数据采集基于 Pull 模型进行设计，因此在网络环境的配置上必须要让 Prometheus  Server 能够直接与 Exporter 进行通信。  当这种网络需求无法直接满足时，就可以利用 PushGateway 来进行中转。可以通过 PushGateway 将内部网络的监控数据主动 Push 到 Gateway 当中。而 Prometheus Server 则可以采用同样 Pull 的方式从 PushGateway 中获取到监控数据。 

## 架构

Prometheus 的基本架构：

 ![Prometheus架构](../../Image/p/prometheus_architecture.png)

Prometheus scrapes metrics from instrumented jobs, either directly or via an intermediary push gateway for short-lived jobs. Prometheus 直接或通过中介推送网关从装有工具的作业中获取指标，用于短期作业。它在本地存储所有抓取的样本，并对这些数据运行规则，以从现有数据中聚合和记录新的时间序列，或生成警报。Grafana 或其他 API 消费者可以用于可视化收集的数据。

## When does it fit?

Prometheus 可以很好地记录任何纯数字时间序列。它既适合以机器为中心的监控，也适合高度动态的面向服务的体系结构的监控。在微服务的世界里，它对多维数据收集和查询的支持是一个特别的优势。

Prometheus 是为可靠性而设计的，它是您在停机期间使用的系统，可以让您快速诊断问题。每个 Prometheus 服务器都是独立的，不依赖于网络存储或其他远程服务。当基础设施的其他部分出现故障时，您可以依赖它，并且不需要设置大量的基础设施来使用它。

## When does it not fit?

Prometheus 重视可靠性。即使在出现故障的情况下，您也可以随时查看系统的可用统计信息。如果您需要 100% 的准确性，例如按请求计费，Prometheus 不是一个好选择，因为收集的数据可能不够详细和完整。在这种情况下，您最好使用其他系统来收集和分析用于计费的数据，并使用 Prometheus 来进行其余的监控。

## 使用表达式浏览器

试着看看 Prometheus 收集到的关于自己的一些数据。要使用 Prometheus 内置的表达式浏览器，请导航到 http://localhost:9090/graph 并在“图形”选项卡中选择“表格”视图。

正如你可以从http://localhost:9090/metrics，Prometheus 导出的关于自身的一个度量称为 `promhttp_metric_handler_requests_total` （ Prometheus 服务器已服务的 `/metrics` 请求总数）。继续并将其输入表达式控制台：

```bash
promhttp_metric_handler_requests_total
```

这应该返回许多不同的时间序列（以及为每个时间序列记录的最新值），所有时间序列都具有指标名 `promhttp_metric_handler_requests_total`，但具有不同的标签。这些标签指定不同的请求状态。

If we were only interested in requests that resulted in HTTP code, we could use this query to retrieve that information:

如果我们只对导致 HTTP 代码 `200` 的请求感兴趣，可以使用此查询来检索这些信息：

```bash
promhttp_metric_handler_requests_total{code="200"}
```

要计算返回的时间序列的数量，可以写：

```bash
count(promhttp_metric_handler_requests_total)
```

## 使用绘图界面

要绘制表达式的图形，请导航到 http://localhost:9090/graph 并使用“图形”选项卡。

例如，输入以下表达式 graph the per-second  HTTP request rate returning status code 200 happening in the  self-scraped 以绘制自刮Prometheus中每秒HTTP请求率返回状态代码200的图形：

```bash
rate(promhttp_metric_handler_requests_total{code="200"}[1m])
```

可以对图形范围参数和其他设置进行实验。

## 监控的目标

在《SRE:  Google运维解密》一书中指出，监控系统需要能够有效的支持白盒监控和黑盒监控。通过白盒能够了解其内部的实际运行状态，通过对监控指标的观察能够预判可能出现的问题，从而对潜在的不确定因素进行优化。而黑盒监控，常见的如 HTTP 探针，TCP 探针等，可以在系统或者服务在发生故障时能够快速通知相关的人员进行处理。通过建立完善的监控体系，从而达到以下目的：

- 长期趋势分析：通过对监控样本数据的持续收集和统计，对监控指标进行长期趋势分析。例如，通过对磁盘空间增长率的判断，我们可以提前预测在未来什么时间节点上需要对资源进行扩容。
- 对照分析：两个版本的系统运行资源使用情况的差异如何？在不同容量情况下系统的并发和负载变化如何？通过监控能够方便的对系统进行跟踪和比较。
- 告警：当系统出现或者即将出现故障时，监控系统需要迅速反应并通知管理员，从而能够对问题进行快速的处理或者提前预防问题的发生，避免出现对业务的影响。
- 故障分析与定位：当问题发生后，需要对问题进行调查和处理。通过对不同监控监控以及历史数据的分析，能够找到并解决根源问题。
- 数据可视化：通过可视化仪表盘能够直接获取系统的运行状态、资源使用情况、以及服务运行状态等直观的信息。

## 优势

Prometheus 是一个开源的完整监控解决方案，其对传统监控系统的测试和告警模型进行了彻底的颠覆，形成了基于中央化的规则计算、统一分析和告警的新模型。 相比于传统监控系统 Prometheus 具有以下优点：

### 易于管理

Prometheus 核心部分只有一个单独的二进制文件，不存在任何的第三方依赖(数据库，缓存等等)。唯一需要的就是本地磁盘，因此不会有潜在级联故障的风险。

Prometheus 基于 Pull 模型的架构方式，可以在任何地方（本地电脑，开发环境，测试环境）搭建我们的监控系统。对于一些复杂的情况，还可以使用Prometheus 服务发现 (Service Discovery) 的能力动态管理监控目标。

### 监控服务的内部运行状态

Pometheus 鼓励用户监控服务的内部状态，基于 Prometheus 丰富的 Client 库，用户可以轻松的在应用程序中添加对 Prometheus 的支持，从而让用户可以获取服务和应用内部真正的运行状态。

![](../../Image/m/monitor-internal.png)

### 强大的数据模型

所有采集的监控数据均以指标 (metric) 的形式保存在内置的时间序列数据库当中 (TSDB) 。所有的样本除了基本的指标名称以外，还包含一组用于描述该样本特征的标签。

如下所示：

```bash
http_request_status{code='200',content_path='/api/path', environment='produment'} => [value1@timestamp1,value2@timestamp2...]
http_request_status{code='200',content_path='/api/path2', environment='produment'} => [value1@timestamp1,value2@timestamp2...]
```

每一条时间序列由指标名称 (Metrics Name) 以及一组标签 (Labels) 唯一标识。每条时间序列按照时间的先后顺序存储一系列的样本值。

表示维度的标签可能来源于你的监控对象的状态，比如 code=404 或者 content_path=/api/path 。也可能来源于的你的环境定义，比如environment=produment 。基于这些 Labels 可以方便地对监控数据进行聚合，过滤，裁剪。

### 强大的查询语言 PromQL

Prometheus 内置了一个强大的数据查询语言 PromQL 。 通过 PromQL 可以实现对监控数据的查询、聚合。同时 PromQL 也被应用于数据可视化(如 Grafana )以及告警当中。

通过 PromQL 可以轻松回答类似于以下问题：

- 在过去一段时间中95%应用延迟时间的分布范围？
- 预测在4小时后，磁盘空间占用大致会是什么情况？
- CPU占用率前5位的服务有哪些？(过滤)

### 高效

对于监控系统而言，大量的监控任务必然导致有大量的数据产生。而 Prometheus 可以高效地处理这些数据，对于单一 Prometheus Server 实例而言它可以处理：

- 数以百万的监控指标
- 每秒处理数十万的数据点。

### 可扩展

Prometheus 是如此简单，因此可以在每个数据中心、每个团队运行独立的 Prometheus  Sevrer 。Prometheus 对于联邦集群的支持，可以让多个 Prometheus 实例产生一个逻辑集群，当单实例 Prometheus  Server 处理的任务量过大时，通过使用功能分区 ( sharding ) +联邦集群 ( federation ) 可以对其进行扩展。

### 易于集成

使用 Prometheus 可以快速搭建监控服务，并且可以非常方便地在应用程序中进行集成。目前支持： Java， JMX， Python，  Go，Ruby， .Net，  Node.js 等等语言的客户端 SDK，基于这些 SDK 可以快速让应用程序纳入到 Prometheus 的监控当中，或者开发自己的监控数据收集程序。同时这些客户端收集的监控数据，不仅仅支持 Prometheus，还能支持 Graphite 这些其他的监控工具。

同时 Prometheus 还支持与其他的监控系统进行集成：Graphite， Statsd， Collected， Scollector， muini， Nagios 等。

Prometheu s社区还提供了大量第三方实现的监控数据采集支持：JMX， CloudWatch， EC2， MySQL，  PostgresSQL， Haskell， Bash， SNMP， Consul， Haproxy， Mesos， Bind， CouchDB， Django， Memcached， RabbitMQ， Redis， RethinkDB， Rsyslog 等等。

### 可视化

Prometheus Server 中自带了一个 Prometheus  UI，通过这个 UI 可以方便地直接对数据进行查询，并且支持直接以图形化的形式展示数据。同时 Prometheus还提供了一个独立的基于 Ruby On  Rails 的 Dashboard 解决方案 Promdash。最新的 Grafana 可视化工具也已经提供了完整的 Prometheus 支持，基于 Grafana 可以创建更加精美的监控图标。基于 Prometheus 提供的 API 还可以实现自己的监控可视化 UI。

### 开放性

通常来说当我们需要监控一个应用程序时，一般需要该应用程序提供对相应监控系统协议的支持。因此应用程序会与所选择的监控系统进行绑定。为了减少这种绑定所带来的限制。对于决策者而言要么你就直接在应用中集成该监控系统的支持，要么就在外部创建单独的服务来适配不同的监控系统。

而对于 Prometheus 来说，使用 Prometheus 的 client library 的输出格式不止支持 Prometheus 的格式化数据，也可以输出支持其它监控系统的格式化数据，比如 Graphite 。

因此你甚至可以在不使用 Prometheus 的情况下，采用 Prometheus 的 client library 来让你的应用程序支持监控数据采集。

## 概念

# Types of metrics.

- [Counter ](https://prometheus.io/docs/tutorials/understanding_metric_types/#counter)
- [Gauge ](https://prometheus.io/docs/tutorials/understanding_metric_types/#gauge)
- [Histogram ](https://prometheus.io/docs/tutorials/understanding_metric_types/#histogram)
- [Summary ](https://prometheus.io/docs/tutorials/understanding_metric_types/#summary)

Prometheus supports four types of metrics, they are    - Counter    - Gauge    - Histogram    - Summary 

## Counter

Counter is a metric value which can only increase or reset i.e the  value cannot reduce than the previous value. It can be used for metrics  like number of requests, no of errors etc.

Type the below query in the query bar and click execute.

```
go_gc_duration_seconds_count
```

[![Counter](https://prometheus.io/assets/tutorial/counter_example.png)](https://prometheus.io/assets/tutorial/counter_example.png)

The rate() function in PromQL takes the history of metrics over a  time frame and calculates how fast value is increasing per second. Rate  is applicable on counter values only.

` rate(go_gc_duration_seconds_count[5m])` [![Rate Counter](https://prometheus.io/assets/tutorial/rate_example.png)](https://prometheus.io/assets/tutorial/rate_example.png)

## Gauge

Gauge is a number which can either go up or down. It can be used for  metrics like number of pods in a cluster, number of events in an queue  etc.

` go_memstats_heap_alloc_bytes` [![Gauge](https://prometheus.io/assets/tutorial/gauge_example.png)](https://prometheus.io/assets/tutorial/gauge_example.png)

PromQL functions like `max_over_time`, `min_over_time` and `avg_over_time` can be used on gauge metrics

## Histogram

Histogram is a more complex metric type when compared to the previous two. Histogram can be used for any calculated value which is counted  based on bucket values. Bucket boundaries can be configured by the  developer. A common example would the time it takes to reply to a  request, called latency.

Example: Lets assume we want to observe the time taken to process API requests. Instead of storing the request time for each request,  histograms allow us to store them in buckets. We define buckets for time taken, for example `lower or equal 0.3` , `le 0.5`, `le 0.7`, `le 1`, and `le 1.2`. So these are our buckets and once the time taken for a request is  calculated it is added to the count of all the buckets whose bucket  boundaries are higher than the measured value.

Lets say Request 1 for endpoint “/ping” takes 0.25 s. The count values for the buckets will be.

> /ping

| Bucket   | Count |
| -------- | ----- |
| 0 - 0.3  | 1     |
| 0 - 0.5  | 1     |
| 0 - 0.7  | 1     |
| 0 - 1    | 1     |
| 0 - 1.2  | 1     |
| 0 - +Inf | 1     |

Note: +Inf bucket is added by default.

(Since histogram is a cumulative frequency 1 is added to all the buckets which are greater than the value)

Request 2 for endpoint “/ping” takes 0.4s The count values for the buckets will be this.

> /ping

| Bucket   | Count |
| -------- | ----- |
| 0 - 0.3  | 1     |
| 0 - 0.5  | 2     |
| 0 - 0.7  | 2     |
| 0 - 1    | 2     |
| 0 - 1.2  | 2     |
| 0 - +Inf | 2     |

Since 0.4 is below 0.5, all buckets up to that boundary increase their counts.

Let's explore a histogram metric from the Prometheus UI and apply few functions.

```
prometheus_http_request_duration_seconds_bucket{handler="/graph"}
```

[![Histogram](https://prometheus.io/assets/tutorial/histogram_example.png)](https://prometheus.io/assets/tutorial/histogram_example.png)

`histogram_quantile()` function can be used to calculate quantiles from histogram

```
histogram_quantile(0.9,prometheus_http_request_duration_seconds_bucket{handler="/graph"})
```

[![Histogram Quantile](https://prometheus.io/assets/tutorial/histogram_quantile_example.png)](https://prometheus.io/assets/tutorial/histogram_quantile_example.png)

The graph shows that the 90th percentile is 0.09, To find the  histogram_quantile over last 5m you can use the rate() and time frame

```
histogram_quantile(0.9, rate(prometheus_http_request_duration_seconds_bucket{handler="/graph"}[5m]))
```

[![Histogram Quantile Rate](https://prometheus.io/assets/tutorial/histogram_rate_example.png)](https://prometheus.io/assets/tutorial/histogram_rate_example.png)

## Summary

Summaries also measure events and are an alternative to histograms.  They are cheaper, but lose more data. They are calculated on the  application level hence aggregation of metrics from multiple instances  of the same process is not possible. They are used when the buckets of a metric is not known beforehand, but it is highly recommended to use  histograms over summaries whenever possible.

In this tutorial we covered the types of metrics in detail and few PromQL operations like rate, histogram_quantile etc.

n this tutorial we will create a simple Go HTTP server and instrumentation it by adding a counter metric to keep count of the total number of requests processed by the server.

Here we have a simple HTTP server with `/ping` endpoint which returns `pong` as response.

```
package main

import (
   "fmt"
   "net/http"
)

func ping(w http.ResponseWriter, req *http.Request){
   fmt.Fprintf(w,"pong")
}

func main() {
   http.HandleFunc("/ping",ping)

   http.ListenAndServe(":8090", nil)
}
```

Compile and run the server

```
go build server.go
./server.go
```

Now open `http://localhost:8090/ping` in your browser and you must see `pong`.

[![Server](https://prometheus.io/assets/tutorial/server.png)](https://prometheus.io/assets/tutorial/server.png)

Now lets add a metric to the server which will instrument the number  of requests made to the ping endpoint,the counter metric type is  suitable for this as we know the request count doesn’t go down and only  increases.

Create a Prometheus counter

```
var pingCounter = prometheus.NewCounter(
   prometheus.CounterOpts{
       Name: "ping_request_count",
       Help: "No of request handled by Ping handler",
   },
)
```

Next lets update the ping Handler to increase the count of the counter using `pingCounter.Inc()`.

```
func ping(w http.ResponseWriter, req *http.Request) {
   pingCounter.Inc()
   fmt.Fprintf(w, "pong")
}
```

Then register the counter to the Default Register and expose the metrics.

```
func main() {
   prometheus.MustRegister(pingCounter)
   http.HandleFunc("/ping", ping)
   http.Handle("/metrics", promhttp.Handler())
   http.ListenAndServe(":8090", nil)
}
```

The `prometheus.MustRegister` function registers the pingCounter to the default Register. To expose the metrics the Go Prometheus client library provides the promhttp package. `promhttp.Handler()` provides a `http.Handler` which exposes the metrics registered in the Default Register.

The sample code depends on the  

```
package main

import (
   "fmt"
   "net/http"

   "github.com/prometheus/client_golang/prometheus"
   "github.com/prometheus/client_golang/prometheus/promhttp"
)

var pingCounter = prometheus.NewCounter(
   prometheus.CounterOpts{
       Name: "ping_request_count",
       Help: "No of request handled by Ping handler",
   },
)

func ping(w http.ResponseWriter, req *http.Request) {
   pingCounter.Inc()
   fmt.Fprintf(w, "pong")
}

func main() {
   prometheus.MustRegister(pingCounter)

   http.HandleFunc("/ping", ping)
   http.Handle("/metrics", promhttp.Handler())
   http.ListenAndServe(":8090", nil)
}
```

Run the example  `bash go mod init prom_example go mod tidy go run main.go `

Now hit the localhost:8090/ping endpoint a couple of times and sending a request to localhost:8090 will provide the metrics.

[![Ping Metric](https://prometheus.io/assets/tutorial/ping_metric.png)](https://prometheus.io/assets/tutorial/ping_metric.png)

Here the ping*request*count shows that `/ping` endpoint was called 3 times.

The DefaultRegister comes with a collector for go runtime metrics and that is why we see other metrics like go*threads, go*goroutines etc.

We have built our first metric exporter. Let’s update our Prometheus config to scrape the metrics from our server.

```
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets: ["localhost:9090"]
  - job_name: simple_server
    static_configs:
      - targets: ["localhost:8090"]
prometheus --config.file=prometheus.yml
```

<iframe src="https://www.youtube.com/embed/yQIWgZoiW0o" allowfullscreen="" width="560" height="315" frameborder="0"></iframe>

​           This documentation is [open-source](https://github.com/prometheus/docs#contributing-changes). Please help improve it b

# Visualizing metrics.

- [Installing and Setting up Grafana. ](https://prometheus.io/docs/tutorials/visualizing_metrics_using_grafana/#installing-and-setting-up-grafana)
- [Adding Prometheus as a Data Source in Grafana. ](https://prometheus.io/docs/tutorials/visualizing_metrics_using_grafana/#adding-prometheus-as-a-data-source-in-grafana)
- [Creating our first dashboard. ](https://prometheus.io/docs/tutorials/visualizing_metrics_using_grafana/#creating-our-first-dashboard)

In this tutorial we will create a simple dashboard using [Grafana](https://github.com/grafana/grafana) to visualize the `ping_request_count` metric that we instrumented in the [previous tutorial](https://prometheus.io/docs/tutorials/instrumenting_http_server_in_go).

If you are wondering why one should use a tool like Grafana when one  can query and see the graphs using Prometheus, the answer is that the  graph that we see when we run queries on Prometheus is to run ad-hoc  queries.  Grafana and [Console Templates](https://prometheus.io/docs/visualization/consoles/) are two recommended ways of creating graphs.

## Installing and Setting up Grafana.

Install and Run Grafana by following the steps from [here](https://grafana.com/docs/grafana/latest/installation/requirements/#supported-operating-systems) for your operating system.

Once Grafana is installed and run, navigate to http://localhost:3000 in your browser. Use the default credentials, username as `admin` and password as `admin` to log in and setup new credentials.

## Adding Prometheus as a Data Source in Grafana.

Let's add a datasource to Grafana by clicking on the gear icon in the side bar and select `Data Sources`

> ⚙ > Data Sources

In the Data Sources screen you can see that Grafana supports multiple data sources like Graphite, PostgreSQL etc. Select Prometheus to set it up.

Enter the URL as http://localhost:9090 under the HTTP section and click on `Save and Test`.

<iframe src="https://www.youtube.com/embed/QT66dU_h9lo" allowfullscreen="" width="560" height="315" frameborder="0"></iframe>

## Creating our first dashboard.

Now we have succesfully added Prometheus as a data source, Next we will create our first dashboard for the `ping_request_count` metric that we instrumented in the previous tutorial.

1. Click on the `+` icon in the side bar and select `Dashboard`.
2. In the next screen, Click on the `Add new panel` button.
3. In the `Query` tab type the PromQL query, in this case just type `ping_request_count`.
4. Access the `ping` endpoint few times and refresh the Graph to verify if it is working as expected.
5. In the right hand section under `Panel Options` set the `Title` as `Ping Request Count`.
6. Click on the Save Icon in the right corner to Save the dashboard.

<iframe src="https://www.youtube.com/embed/giVZHO6akRA" allowfullscreen="" width="560" height="315" frameborder="0"></iframe>

# Alerting based on metrics

In this tutorial we will create alerts on the `ping_request_count` metric that we instrumented earlier in the  [Instrumenting HTTP server written in Go](https://prometheus.io/docs/tutorials/alerting_based_on_metrics/instrumenting_http_server_in_go.md) tutorial.

For the sake of this tutorial we will alert when the `ping_request_count` metric is greater than 5, Checkout real world [best practices](https://prometheus.io/docs/practices/alerting) to learn more about alerting principles.

Download the latest release of Alertmanager for your operating system from [here](https://github.com/prometheus/alertmanager/releases)

Alertmanager supports various receivers like `email`, `webhook`, `pagerduty`, `slack` etc through which it can notify when an alert is firing. You can find the list of receivers and how to configure them [here](https://prometheus.io/docs/alerting/latest/configuration). We will use `webhook` as a receiver for this tutorial, head over to [webhook.site](https://webhook.site) and copy the webhook URL which we will use later to configure the Alertmanager.

First let's setup Alertmanager with webhook receiver.

> alertmanager.yml

```
global:
  resolve_timeout: 5m
route:
  receiver: webhook_receiver
receivers:
    - name: webhook_receiver
      webhook_configs:
        - url: '<INSERT-YOUR-WEBHOOK>'
          send_resolved: false
```

Replace `<INSERT-YOUR-WEBHOOK>` with the webhook that we copied earlier in the alertmanager.yml file and run the Alertmanager using the following command.

```
alertmanager --config.file=alertmanager.yml
```

Once the Alertmanager is up and running navigate to http://localhost:9093 and you should be able to access it.

<iframe src="https://www.youtube.com/embed/RKXwHhQZ5RE" allowfullscreen="" width="560" height="315" frameborder="0"></iframe>

Now that we have configured the Alertmanager with webhook receiver let's add the rules to the Prometheus config.

> prometheus.yml

```
global:
 scrape_interval: 15s
 evaluation_interval: 10s
rule_files:
  - rules.yml
alerting:
  alertmanagers:
  - static_configs:
    - targets:
       - localhost:9093
scrape_configs:
 - job_name: prometheus
   static_configs:
       - targets: ["localhost:9090"]
 - job_name: simple_server
   static_configs:
       - targets: ["localhost:8090"]
```

If you notice the `evaluation_interval`,`rule_files` and `alerting` sections are added to the Prometheus config, the `evaluation_interval` defines the intervals at which the rules are evaluated, `rule_files` accepts an array of yaml files that defines the rules and the `alerting` section defines the Alertmanager configuration. As mentioned in the  beginning of this tutorial we will create a basic rule where we want to raise an alert when the `ping_request_count` value is greater than 5.

> rules.yml

```
groups:
 - name: Count greater than 5
   rules:
   - alert: CountGreaterThan5
     expr: ping_request_count > 5
     for: 10s
```

Now let's run Prometheus using the following command.

```
prometheus --config.file=./prometheus.yml
```

Open http://localhost:9090/rules in your browser to see the rules. Next run the instrumented ping server and visit the http://localhost:8090/ping endpoint and refresh the page atleast 6 times. You can check the ping count by navigating to http://localhost:8090/metrics endpoint. To see the status of the alert visit http://localhost:9090/alerts. Once the condition `ping_request_count > 5` is true for more than 10s the `state` will become `FIRING`. Now if you navigate back to your `webhook.site` URL you will see the alert message.

<iframe src="https://www.youtube.com/embed/xaMXVrle98M" allowfullscreen="" width="560" height="315" frameborder="0"></iframe>

Similarly Alertmanager can be configured with other receivers to notify when an alert is firing.

​           This documentation is [open-source](https://github.com/prometheus/docs#contributing-changes). Please help improve it by filing issues or pull requests.      

------



# Metric types公制类型

- Counter
- Gauge
- Histogram

The Prometheus client libraries offer four core metric types. These are currently only differentiated in the client libraries (to enable APIs tailored to the usage of the specific types) and in the wire protocol. The Prometheus server does not yet make use of the type information and flattens all data into untyped time series. This may change in the future.

## Counter

A *counter* is a cumulative metric that represents a single [monotonically  increasing counter](https://en.wikipedia.org/wiki/Monotonic_function) whose value can only increase or be reset to zero on restart. For example, you can use a counter to represent the number of requests served, tasks completed, or errors.

Do not use a counter to expose a value that can decrease. For example, do not use a counter for the number of currently running processes; instead use a gauge.

Client library usage documentation for counters:

- [Go](http://godoc.org/github.com/prometheus/client_golang/prometheus#Counter)
- [Java](https://github.com/prometheus/client_java#counter)
- [Python](https://github.com/prometheus/client_python#counter)
- [Ruby](https://github.com/prometheus/client_ruby#counter)
- [.Net](https://github.com/prometheus-net/prometheus-net#counters)

## Gauge

A *gauge* is a metric that represents a single numerical value that can arbitrarily go up and down.

Gauges are typically used for measured values like temperatures or current memory usage, but also "counts" that can go up and down, like the number of concurrent requests.

Client library usage documentation for gauges:

- [Go](http://godoc.org/github.com/prometheus/client_golang/prometheus#Gauge)
- [Java](https://github.com/prometheus/client_java#gauge)
- [Python](https://github.com/prometheus/client_python#gauge)
- [Ruby](https://github.com/prometheus/client_ruby#gauge)
- [.Net](https://github.com/prometheus-net/prometheus-net#gauges)

## Histogram

A *histogram* samples observations (usually things like request durations or response sizes) and counts them in configurable buckets. It also provides a sum of all observed values.

A histogram with a base metric name of `<basename>` exposes multiple time series during a scrape:

- cumulative counters for the observation buckets, exposed as `<basename>_bucket{le="<upper inclusive bound>"}`
- the **total sum** of all observed values, exposed as `<basename>_sum`
- the **count** of events that have been observed, exposed as `<basename>_count` (identical to `<basename>_bucket{le="+Inf"}` above)

Use the [`histogram_quantile()` function](https://prometheus.io/docs/prometheus/latest/querying/functions/#histogram_quantile) to calculate quantiles from histograms or even aggregations of histograms. A histogram is also suitable to calculate an [Apdex score](https://en.wikipedia.org/wiki/Apdex). When operating on buckets, remember that the histogram is [cumulative](https://en.wikipedia.org/wiki/Histogram#Cumulative_histogram). See [histograms and summaries](https://prometheus.io/docs/practices/histograms) for details of histogram usage and differences to [summaries](https://prometheus.io/docs/concepts/metric_types/#summary).

**NOTE:** Beginning with Prometheus v2.40, there is experimental support for native histograms. A native histogram requires only one time series, which includes a dynamic number of buckets in addition to the sum and count of observations. Native histograms allow much higher resolution at a fraction of the cost. Detailed documentation will follow once native histograms are closer to becoming a stable feature.

Client library usage documentation for histograms:

- [Go](http://godoc.org/github.com/prometheus/client_golang/prometheus#Histogram)
- [Java](https://github.com/prometheus/client_java#histogram)
- [Python](https://github.com/prometheus/client_python#histogram)
- [Ruby](https://github.com/prometheus/client_ruby#histogram)
- [.Net](https://github.com/prometheus-net/prometheus-net#histogram)

## Summary

Similar to a *histogram*, a *summary* samples observations (usually things like request durations and response sizes). While it also provides a total count of observations and a sum of all observed values, it calculates configurable quantiles over a sliding time window.

A summary with a base metric name of `<basename>` exposes multiple time series during a scrape:

- streaming **φ-quantiles** (0 ≤ φ ≤ 1) of observed events, exposed as `<basename>{quantile="<φ>"}`
- the **total sum** of all observed values, exposed as `<basename>_sum`
- the **count** of events that have been observed, exposed as `<basename>_count`

See [histograms and summaries](https://prometheus.io/docs/practices/histograms) for detailed explanations of φ-quantiles, summary usage, and differences to [histograms](https://prometheus.io/docs/concepts/metric_types/#histogram).

Client library usage documentation for summaries:

- [Go](http://godoc.org/github.com/prometheus/client_golang/prometheus#Summary)
- [Java](https://github.com/prometheus/client_java#summary)
- [Python](https://github.com/prometheus/client_python#summary)
- [Ruby](https://github.com/prometheus/client_ruby#summary)
- [.Net](https://github.com/prometheus-net/prometheus-net#summary)





Prometheus客户端库提供了四种核心度量类型。目前，这些仅在客户端库（以启用根据特定类型的使用定制的API）和有线协议中有所区别。普罗米修斯服务器还没有利用类型信息，而是将所有数据扁平化为非类型的时间序列。这种情况将来可能会改变。

柜台

计数器是一种累积度量，表示单个单调递增的计数器，其值只能在重新启动时增加或重置为零。例如，您可以使用计数器来表示已服务的请求数、已完成的任务数或错误数。

不要使用计数器来公开可能会减少的值。例如，不要使用计数器来表示当前正在运行的进程的数量；而是使用仪表。

计数器的客户端库使用说明文件：

去

Java语言

蟒蛇

红宝石

网

测量

仪表是一种度量标准，表示可以任意上下移动的单个数值。

仪表通常用于测量温度或当前内存使用情况等值，但也可用于上下浮动的“计数”，如并发请求的数量。

仪表的客户端库使用文档：

去

Java语言

蟒蛇

红宝石

网

直方图

直方图对观察结果（通常是请求持续时间或响应大小）进行采样，并在可配置的桶中对其进行计数。它还提供了所有观测值的总和。

基本度量名称为的直方图会在刮取过程中暴露多个时间序列：

观察bucket的累积计数器，公开为bucket｛le=“”｝

所有观测值的总和，显示为sum

已观察到的事件数，公开为count（与上述bucket｛le=“+Inf”｝相同）

使用直方图分位数（）函数可以根据直方图甚至直方图的聚合计算分位数。直方图也适用于计算Apdex得分。在对bucket进行操作时，请记住直方图是累积的。有关直方图使用的详细信息以及与摘要的差异，请参阅直方图和摘要。

注意：从Prometheus v2.40开始，有对原生直方图的实验支持。原生直方图只需要一个时间序列，除了观测值的总和和计数外，还包括动态数量的桶。原生直方图允许以很小的成本获得更高的分辨率。一旦本机直方图接近成为一个稳定的特性，详细的文档就会随之而来。

直方图的客户端库使用文档：



总结

与直方图类似，摘要对观察结果进行采样（通常是请求持续时间和响应大小）。虽然它还提供了观测的总数和所有观测值的总和，但它计算了滑动时间窗口上的可配置分位数。

基本度量名称为＜basename＞的摘要会在刮取过程中暴露多个时间序列：

流式φ-观察到的事件的分位数（0≤φ≤1），暴露为｛分位数=“<φ>”｝

所有观测值的总和，显示为sum

已观察到的事件数，公开为＜basename＞计数

有关φ-分位数、摘要用法以及直方图差异的详细解释，请参见直方图和摘要。

摘要的客户端库使用文档：

# Jobs and instances

In Prometheus terms, an endpoint you can scrape is called an *instance*, usually corresponding to a single process. A collection of instances  with the same purpose, a process replicated for scalability or  reliability for example, is called a *job*.

For example, an API server job with four replicated instances:

- job: 

  ```
  api-server
  ```

  - instance 1: `1.2.3.4:5670`
  - instance 2: `1.2.3.4:5671`
  - instance 3: `5.6.7.8:5670`
  - instance 4: `5.6.7.8:5671`

## Automatically generated labels and time series

When Prometheus scrapes a target, it attaches some labels automatically to the scraped time series which serve to identify the scraped target:

- `job`: The configured job name that the target belongs to.
- `instance`: The `<host>:<port>` part of the target's URL that was scraped.

If either of these labels are already present in the scraped data, the behavior depends on the `honor_labels` configuration option. See the [scrape configuration documentation](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config) for more information.

For each instance scrape, Prometheus stores a [sample](https://prometheus.io/docs/introduction/glossary#sample) in the following time series:

- `up{job="<job-name>", instance="<instance-id>"}`: `1` if the instance is healthy, i.e. reachable, or `0` if the scrape failed.
- `scrape_duration_seconds{job="<job-name>", instance="<instance-id>"}`: duration of the scrape.
- `scrape_samples_post_metric_relabeling{job="<job-name>", instance="<instance-id>"}`: the number of samples remaining after metric relabeling was applied.
- `scrape_samples_scraped{job="<job-name>", instance="<instance-id>"}`: the number of samples the target exposed.
- `scrape_series_added{job="<job-name>", instance="<instance-id>"}`: the approximate number of new series in this scrape. *New in v2.10*

The `up` time series is useful for instance availability monitoring.

作业和实例

用普罗米修斯的话来说，你可以抓取的端点被称为实例，通常对应于一个进程。具有相同目的的实例集合，例如为了可扩展性或可靠性而复制的过程，称为作业。

例如，具有四个复制实例的API服务器作业：

作业：api服务器

实例1:1.2.3.4:5670

实例2:1.2.3.4:5671

实例3:5.6.7.8:5670

实例4:5.6.7.8:5671

自动生成的标签和时间序列

当普罗米修斯刮伤目标时，它会自动在刮伤的时间序列上贴上一些标签，用于识别刮伤的目标：

job：目标所属的已配置作业名称。

instance:被抓取的目标URL的＜host＞：＜port＞部分。

如果这些标签中的任何一个已经存在于刮取的数据中，则行为取决于荣誉标签配置选项。有关更多信息，请参阅刮取配置文档。

对于每一次刮擦，普罗米修斯都会按照以下时间序列存储一个样本：

up｛job=“＜job name＞”，instance=“＜instance id＞”｝：如果实例正常，即可访问，则为1；如果刮取失败，则为0。

刮取持续时间秒｛job=“＜job name＞”，instance=“＜instance id＞”｝：刮取的持续时间。

在度量重新标记后刮取样本｛job=“”，instance=“”｝：应用度量重新标记之后剩余的样本数。

scrape samples scraped｛job=“＜job name＞”，instance=“＜instance id＞”｝：目标暴露的样本数。

scrape series added｛job=“＜job name＞”，instance=“＜instance id＞”｝：此scrape中新系列的大致数量。v2.10中的新增功能

上行时间序列对于实例可用性监控非常有用。

# Getting started

## Configuring Prometheus to monitor itself

Prometheus collects metrics from *targets* by scraping metrics HTTP endpoints. Since Prometheus exposes data in the same manner about itself, it can also scrape and monitor its own health.

While a Prometheus server that collects only data about itself is not very useful, it is a good starting example. Save the following basic Prometheus configuration as a file named `prometheus.yml`:

```
global:
  scrape_interval:     15s # By default, scrape targets every 15 seconds.

  # Attach these labels to any time series or alerts when communicating with
  # external systems (federation, remote storage, Alertmanager).
  external_labels:
    monitor: 'codelab-monitor'

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 5s

    static_configs:
      - targets: ['localhost:9090']
```

For a complete specification of configuration options, see the [configuration documentation](https://prometheus.io/docs/prometheus/latest/configuration/configuration/).

## Starting Prometheus

To start Prometheus with your newly created configuration file, change to the directory containing the Prometheus binary and run:

```
# Start Prometheus.
# By default, Prometheus stores its database in ./data (flag --storage.tsdb.path).
./prometheus --config.file=prometheus.yml
```

Prometheus should start up. You should also be able to browse to a status page about itself at [localhost:9090](http://localhost:9090). Give it a couple of seconds to collect data about itself from its own HTTP metrics endpoint.

You can also verify that Prometheus is serving metrics about itself by navigating to its metrics endpoint: [localhost:9090/metrics](http://localhost:9090/metrics)

## Using the expression browser

Let us explore data that Prometheus has collected about itself. To use Prometheus's built-in expression browser, navigate to http://localhost:9090/graph and choose the "Table" view within the "Graph" tab.

As you can gather from [localhost:9090/metrics](http://localhost:9090/metrics), one metric that Prometheus exports about itself is named `prometheus_target_interval_length_seconds` (the actual amount of time between target scrapes). Enter the below into the expression console and then click "Execute":

```
prometheus_target_interval_length_seconds
```

This should return a number of different time series (along with the latest value recorded for each), each with the metric name `prometheus_target_interval_length_seconds`, but with different labels. These labels designate different latency percentiles and target group intervals.

If we are interested only in 99th percentile latencies, we could use this query:

```
prometheus_target_interval_length_seconds{quantile="0.99"}
```

To count the number of returned time series, you could write:

```
count(prometheus_target_interval_length_seconds)
```

For more about the expression language, see the [expression language documentation](https://prometheus.io/docs/prometheus/latest/querying/basics/).

## Using the graphing interface

To graph expressions, navigate to http://localhost:9090/graph and use the "Graph" tab.

For example, enter the following expression to graph the per-second rate of chunks being created in the self-scraped Prometheus:

```
rate(prometheus_tsdb_head_chunks_created_total[1m])
```

Experiment with the graph range parameters and other settings.

## Starting up some sample targets

Let's add additional targets for Prometheus to scrape.

The Node Exporter is used as an example target, for more information on using it [see these instructions.](https://prometheus.io/docs/guides/node-exporter/)

```
tar -xzvf node_exporter-*.*.tar.gz
cd node_exporter-*.*

# Start 3 example targets in separate terminals:
./node_exporter --web.listen-address 127.0.0.1:8080
./node_exporter --web.listen-address 127.0.0.1:8081
./node_exporter --web.listen-address 127.0.0.1:8082
```

You should now have example targets listening on http://localhost:8080/metrics, http://localhost:8081/metrics, and http://localhost:8082/metrics.

## Configure Prometheus to monitor the sample targets

Now we will configure Prometheus to scrape these new targets. Let's group all three endpoints into one job called `node`. We will imagine that the first two endpoints are production targets, while the third one represents a canary instance. To model this in Prometheus, we can add several groups of endpoints to a single job, adding extra labels to each group of targets. In this example, we will add the `group="production"` label to the first group of targets, while adding `group="canary"` to the second.

To achieve this, add the following job definition to the `scrape_configs` section in your `prometheus.yml` and restart your Prometheus instance:

```
scrape_configs:
  - job_name:       'node'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 5s

    static_configs:
      - targets: ['localhost:8080', 'localhost:8081']
        labels:
          group: 'production'

      - targets: ['localhost:8082']
        labels:
          group: 'canary'
```

Go to the expression browser and verify that Prometheus now has information about time series that these example endpoints expose, such as `node_cpu_seconds_total`.

## Configure rules for aggregating scraped data into new time series

Though not a problem in our example, queries that aggregate over thousands of time series can get slow when computed ad-hoc. To make this more efficient, Prometheus can prerecord expressions into new persisted time series via configured *recording rules*. Let's say we are interested in recording the per-second rate of cpu time (`node_cpu_seconds_total`) averaged over all cpus per instance (but preserving the `job`, `instance` and `mode` dimensions) as measured over a window of 5 minutes. We could write this as:

```
avg by (job, instance, mode) (rate(node_cpu_seconds_total[5m]))
```

Try graphing this expression.

To record the time series resulting from this expression into a new metric called `job_instance_mode:node_cpu_seconds:avg_rate5m`, create a file with the following recording rule and save it as `prometheus.rules.yml`:

```
groups:
- name: cpu-node
  rules:
  - record: job_instance_mode:node_cpu_seconds:avg_rate5m
    expr: avg by (job, instance, mode) (rate(node_cpu_seconds_total[5m]))
```

To make Prometheus pick up this new rule, add a `rule_files` statement in your `prometheus.yml`. The config should now look like this:

```
global:
  scrape_interval:     15s # By default, scrape targets every 15 seconds.
  evaluation_interval: 15s # Evaluate rules every 15 seconds.

  # Attach these extra labels to all timeseries collected by this Prometheus instance.
  external_labels:
    monitor: 'codelab-monitor'

rule_files:
  - 'prometheus.rules.yml'

scrape_configs:
  - job_name: 'prometheus'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 5s

    static_configs:
      - targets: ['localhost:9090']

  - job_name:       'node'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 5s

    static_configs:
      - targets: ['localhost:8080', 'localhost:8081']
        labels:
          group: 'production'

      - targets: ['localhost:8082']
        labels:
          group: 'canary'
```

Restart Prometheus with the new configuration and verify that a new time series with the metric name `job_instance_mode:node_cpu_seconds:avg_rate5m` is now available by querying it through the expression browser or graphing it.

开始

下载并运行普罗米修斯

将普罗米修斯配置为监视自身

启动普罗米修斯

使用表达式浏览器

使用绘图界面

启动一些示例目标

配置普罗米修斯来监视样本目标

配置用于将已刮取的数据聚合到新时间序列中的规则

本指南是一个“Hello World”风格的教程，展示了如何安装、配置和使用一个简单的Prometheus实例。您将在本地下载并运行Prometheus，将其配置为抓取自身和示例应用程序，然后使用查询、规则和图形来使用收集的时间序列数据。

下载并运行普罗米修斯

为您的平台下载最新版本的Prometheus，然后提取并运行它：

tar xvfz普罗米修斯-*.tar.gz

cd普罗米修斯-*

在启动普罗米修斯之前，让我们对其进行配置。

将普罗米修斯配置为监视自身

普罗米修斯通过抓取度量HTTP端点来收集目标的度量。由于普罗米修斯以同样的方式暴露自己的数据，它也可以抓取和监测自己的健康状况。

虽然普罗米修斯服务器只收集自己的数据并不是很有用，但它是一个很好的起点。将以下基本Prometheus配置保存为名为Prometheus.yml的文件：

全球的：

刮取间隔：15s#默认情况下，每15秒刮取一次目标。

\#与通信时，将这些标签附加到任何时间序列或警报

\#外部系统（联合、远程存储、警报管理器）。

外部标签：

monitor:“代码实验室监视器”

\#仅包含一个要刮取的端点的刮取配置：

\#这是普罗米修斯。

刮取配置：

\#作业名称将作为标签“job=<作业名称>”添加到从此配置中抓取的任何时间序列中。

-作业名称：“普罗米修斯”

\#覆盖全局默认值，并每5秒从该作业中抓取一次目标。

刮擦间隔：5s

静态配置：

-目标：['本地主机：9090']

有关配置选项的完整规范，请参阅配置文档。

启动普罗米修斯

要使用新创建的配置文件启动Prometheus，请更改到包含Prometheus二进制文件的目录，然后运行：

\#启动普罗米修斯。

\#默认情况下，普罗米修斯将其数据库存储在中/数据（标志--存储.tsdb.path）。

./prometheus--配置.file=prometheus.yml

普罗米修斯应该启动了。您还应该能够在localhost:9090上浏览到关于其自身的状态页面。给它几秒钟时间，从它自己的HTTP度量端点收集关于它自己的数据。

您还可以通过导航到其度量端点localhost:9090/metrics来验证Prometheus是否提供了有关其自身的度量

使用表达式浏览器

让我们探索普罗米修斯收集到的关于自己的数据。要使用Prometheus内置的表达式浏览器，请导航到http://localhost:9090/graph并在“图形”选项卡中选择“表格”视图。

正如您可以从localhost:9090/metrics收集到的那样，Prometheus导出的一个关于自身的度量被命名为Prometheus目标间隔长度秒（目标刮擦之间的实际时间）。在表达式控制台中输入以下内容，然后单击“执行”：

普罗米修斯目标间隔长度秒

这应该返回许多不同的时间序列（以及为每个时间序列记录的最新值），每个时间序列都具有度量名称prometheus目标间隔长度秒，但具有不同的标签。这些标签指定不同的延迟百分位数和目标组间隔。

如果我们只对第99百分位的延迟感兴趣，我们可以使用以下查询：

普罗米修斯目标间隔长度秒｛分位数=“0.99”｝

要计算返回的时间序列的数量，您可以写：

计数（普罗米修斯目标间隔长度秒）

有关表达式语言的更多信息，请参阅表达式语言文档。

使用绘图界面

要绘制表达式的图形，请导航到http://localhost:9090/graph并使用“图形”选项卡。

例如，输入以下表达式以绘制每秒在自刮的普罗米修斯中创建块的速率：

速率（prometheus tsdb头块创建总数[1m]）

对图形范围参数和其他设置进行实验。

启动一些示例目标

让我们为普罗米修斯添加额外的目标。

节点导出器用作示例目标，有关使用它的更多信息，请参阅以下说明。

tar-xzvf节点导出器-*.*.tar.gz

cd节点导出器-**

\#在单独的终端中启动3个示例目标：

./节点导出器--web.listen地址127.0.0.1:8080

./节点导出器--web.listen地址127.0.0.1:8081

./节点导出器--web.listen地址127.0.0.1:8082

您现在应该有示例目标在侦听http://localhost:8080/metrics, http://localhost:8081/metrics和http://localhost:8082/metrics.

配置普罗米修斯来监视样本目标

现在

- 

# Configuration

Prometheus is configured via command-line flags and a configuration file. While the command-line flags configure immutable system parameters (such as storage locations, amount of data to keep on disk and in memory, etc.), the configuration file defines everything related to scraping [jobs and their instances](https://prometheus.io/docs/concepts/jobs_instances/), as well as which [rule files to load](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/#configuring-rules).

To view all available command-line flags, run `./prometheus -h`.

Prometheus can reload its configuration at runtime. If the new configuration is not well-formed, the changes will not be applied. A configuration reload is triggered by sending a `SIGHUP` to the Prometheus process or sending a HTTP POST request to the `/-/reload` endpoint (when the `--web.enable-lifecycle` flag is enabled). This will also reload any configured rule files.

## Configuration file

To specify which configuration file to load, use the `--config.file` flag.

The file is written in [YAML format](https://en.wikipedia.org/wiki/YAML), defined by the scheme described below. Brackets indicate that a parameter is optional. For non-list parameters the value is set to the specified default.

Generic placeholders are defined as follows:

- `<boolean>`: a boolean that can take the values `true` or `false`
- `<duration>`: a duration matching the regular expression `((([0-9]+)y)?(([0-9]+)w)?(([0-9]+)d)?(([0-9]+)h)?(([0-9]+)m)?(([0-9]+)s)?(([0-9]+)ms)?|0)`, e.g. `1d`, `1h30m`, `5m`, `10s`
- `<filename>`: a valid path in the current working directory
- `<float>`: a floating-point number
- `<host>`: a valid string consisting of a hostname or IP followed by an optional port number
- `<int>`: an integer value
- `<labelname>`: a string matching the regular expression `[a-zA-Z_][a-zA-Z0-9_]*`
- `<labelvalue>`: a string of unicode characters
- `<path>`: a valid URL path
- `<scheme>`: a string that can take the values `http` or `https`
- `<secret>`: a regular string that is a secret, such as a password
- `<string>`: a regular string
- `<size>`: a size in bytes, e.g. `512MB`. A unit is required. Supported units: B, KB, MB, GB, TB, PB, EB.
- `<tmpl_string>`: a string which is template-expanded before usage

The other placeholders are specified separately.

A valid example file can be found [here](https://github.com/prometheus/prometheus/blob/release-2.43/config/testdata/conf.good.yml).

The global configuration specifies parameters that are valid in all other configuration contexts. They also serve as defaults for other configuration sections.

```
global:
  # How frequently to scrape targets by default.
  [ scrape_interval: <duration> | default = 1m ]

  # How long until a scrape request times out.
  [ scrape_timeout: <duration> | default = 10s ]

  # How frequently to evaluate rules.
  [ evaluation_interval: <duration> | default = 1m ]

  # The labels to add to any time series or alerts when communicating with
  # external systems (federation, remote storage, Alertmanager).
  external_labels:
    [ <labelname>: <labelvalue> ... ]

  # File to which PromQL queries are logged.
  # Reloading the configuration will reopen the file.
  [ query_log_file: <string> ]

# Rule files specifies a list of globs. Rules and alerts are read from
# all matching files.
rule_files:
  [ - <filepath_glob> ... ]

# Scrape config files specifies a list of globs. Scrape configs are read from
# all matching files and appended to the list of scrape configs.
scrape_config_files:
  [ - <filepath_glob> ... ]

# A list of scrape configurations.
scrape_configs:
  [ - <scrape_config> ... ]

# Alerting specifies settings related to the Alertmanager.
alerting:
  alert_relabel_configs:
    [ - <relabel_config> ... ]
  alertmanagers:
    [ - <alertmanager_config> ... ]

# Settings related to the remote write feature.
remote_write:
  [ - <remote_write> ... ]

# Settings related to the remote read feature.
remote_read:
  [ - <remote_read> ... ]

# Storage related settings that are runtime reloadable.
storage:
  [ tsdb: <tsdb> ]
  [ exemplars: <exemplars> ]

# Configures exporting traces.
tracing:
  [ <tracing_config> ]
```

### `<scrape_config>`

A `scrape_config` section specifies a set of targets and parameters describing how to scrape them. In the general case, one scrape configuration specifies a single job. In advanced configurations, this may change.

Targets may be statically configured via the `static_configs` parameter or dynamically discovered using one of the supported service-discovery mechanisms.

Additionally, `relabel_configs` allow advanced modifications to any target and its labels before scraping.

```
# The job name assigned to scraped metrics by default.
job_name: <job_name>

# How frequently to scrape targets from this job.
[ scrape_interval: <duration> | default = <global_config.scrape_interval> ]

# Per-scrape timeout when scraping this job.
[ scrape_timeout: <duration> | default = <global_config.scrape_timeout> ]

# The HTTP resource path on which to fetch metrics from targets.
[ metrics_path: <path> | default = /metrics ]

# honor_labels controls how Prometheus handles conflicts between labels that are
# already present in scraped data and labels that Prometheus would attach
# server-side ("job" and "instance" labels, manually configured target
# labels, and labels generated by service discovery implementations).
#
# If honor_labels is set to "true", label conflicts are resolved by keeping label
# values from the scraped data and ignoring the conflicting server-side labels.
#
# If honor_labels is set to "false", label conflicts are resolved by renaming
# conflicting labels in the scraped data to "exported_<original-label>" (for
# example "exported_instance", "exported_job") and then attaching server-side
# labels.
#
# Setting honor_labels to "true" is useful for use cases such as federation and
# scraping the Pushgateway, where all labels specified in the target should be
# preserved.
#
# Note that any globally configured "external_labels" are unaffected by this
# setting. In communication with external systems, they are always applied only
# when a time series does not have a given label yet and are ignored otherwise.
[ honor_labels: <boolean> | default = false ]

# honor_timestamps controls whether Prometheus respects the timestamps present
# in scraped data.
#
# If honor_timestamps is set to "true", the timestamps of the metrics exposed
# by the target will be used.
#
# If honor_timestamps is set to "false", the timestamps of the metrics exposed
# by the target will be ignored.
[ honor_timestamps: <boolean> | default = true ]

# Configures the protocol scheme used for requests.
[ scheme: <scheme> | default = http ]

# Optional HTTP URL parameters.
params:
  [ <string>: [<string>, ...] ]

# Sets the `Authorization` header on every scrape request with the
# configured username and password.
# password and password_file are mutually exclusive.
basic_auth:
  [ username: <string> ]
  [ password: <secret> ]
  [ password_file: <string> ]

# Sets the `Authorization` header on every scrape request with
# the configured credentials.
authorization:
  # Sets the authentication type of the request.
  [ type: <string> | default: Bearer ]
  # Sets the credentials of the request. It is mutually exclusive with
  # `credentials_file`.
  [ credentials: <secret> ]
  # Sets the credentials of the request with the credentials read from the
  # configured file. It is mutually exclusive with `credentials`.
  [ credentials_file: <filename> ]

# Optional OAuth 2.0 configuration.
# Cannot be used at the same time as basic_auth or authorization.
oauth2:
  [ <oauth2> ]

# Configure whether scrape requests follow HTTP 3xx redirects.
[ follow_redirects: <boolean> | default = true ]

# Whether to enable HTTP2.
[ enable_http2: <bool> | default: true ]

# Configures the scrape request's TLS settings.
tls_config:
  [ <tls_config> ]

# Optional proxy URL.
[ proxy_url: <string> ]
# Comma-separated string that can contain IPs, CIDR notation, domain names
# that should be excluded from proxying. IP and domain names can
# contain port numbers.
[ no_proxy: <string> ]
# Use proxy URL indicated by environment variables (HTTP_PROXY, https_proxy, HTTPs_PROXY, https_proxy, and no_proxy)
[ proxy_from_environment: <bool> | default: false ]
# Specifies headers to send to proxies during CONNECT requests.
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]


# List of Azure service discovery configurations.
azure_sd_configs:
  [ - <azure_sd_config> ... ]

# List of Consul service discovery configurations.
consul_sd_configs:
  [ - <consul_sd_config> ... ]

# List of DigitalOcean service discovery configurations.
digitalocean_sd_configs:
  [ - <digitalocean_sd_config> ... ]

# List of Docker service discovery configurations.
docker_sd_configs:
  [ - <docker_sd_config> ... ]

# List of Docker Swarm service discovery configurations.
dockerswarm_sd_configs:
  [ - <dockerswarm_sd_config> ... ]

# List of DNS service discovery configurations.
dns_sd_configs:
  [ - <dns_sd_config> ... ]

# List of EC2 service discovery configurations.
ec2_sd_configs:
  [ - <ec2_sd_config> ... ]

# List of Eureka service discovery configurations.
eureka_sd_configs:
  [ - <eureka_sd_config> ... ]

# List of file service discovery configurations.
file_sd_configs:
  [ - <file_sd_config> ... ]

# List of GCE service discovery configurations.
gce_sd_configs:
  [ - <gce_sd_config> ... ]

# List of Hetzner service discovery configurations.
hetzner_sd_configs:
  [ - <hetzner_sd_config> ... ]

# List of HTTP service discovery configurations.
http_sd_configs:
  [ - <http_sd_config> ... ]


# List of IONOS service discovery configurations.
ionos_sd_configs:
  [ - <ionos_sd_config> ... ]

# List of Kubernetes service discovery configurations.
kubernetes_sd_configs:
  [ - <kubernetes_sd_config> ... ]

# List of Kuma service discovery configurations.
kuma_sd_configs:
  [ - <kuma_sd_config> ... ]

# List of Lightsail service discovery configurations.
lightsail_sd_configs:
  [ - <lightsail_sd_config> ... ]

# List of Linode service discovery configurations.
linode_sd_configs:
  [ - <linode_sd_config> ... ]

# List of Marathon service discovery configurations.
marathon_sd_configs:
  [ - <marathon_sd_config> ... ]

# List of AirBnB's Nerve service discovery configurations.
nerve_sd_configs:
  [ - <nerve_sd_config> ... ]

# List of Nomad service discovery configurations.
nomad_sd_configs:
  [ - <nomad_sd_config> ... ]

# List of OpenStack service discovery configurations.
openstack_sd_configs:
  [ - <openstack_sd_config> ... ]

# List of OVHcloud service discovery configurations.
ovhcloud_sd_configs:
  [ - <ovhcloud_sd_config> ... ]

# List of PuppetDB service discovery configurations.
puppetdb_sd_configs:
  [ - <puppetdb_sd_config> ... ]

# List of Scaleway service discovery configurations.
scaleway_sd_configs:
  [ - <scaleway_sd_config> ... ]

# List of Zookeeper Serverset service discovery configurations.
serverset_sd_configs:
  [ - <serverset_sd_config> ... ]

# List of Triton service discovery configurations.
triton_sd_configs:
  [ - <triton_sd_config> ... ]

# List of Uyuni service discovery configurations.
uyuni_sd_configs:
  [ - <uyuni_sd_config> ... ]

# List of labeled statically configured targets for this job.
static_configs:
  [ - <static_config> ... ]

# List of target relabel configurations.
relabel_configs:
  [ - <relabel_config> ... ]

# List of metric relabel configurations.
metric_relabel_configs:
  [ - <relabel_config> ... ]

# An uncompressed response body larger than this many bytes will cause the
# scrape to fail. 0 means no limit. Example: 100MB.
# This is an experimental feature, this behaviour could
# change or be removed in the future.
[ body_size_limit: <size> | default = 0 ]
# Per-scrape limit on number of scraped samples that will be accepted.
# If more than this number of samples are present after metric relabeling
# the entire scrape will be treated as failed. 0 means no limit.
[ sample_limit: <int> | default = 0 ]

# Per-scrape limit on number of labels that will be accepted for a sample. If
# more than this number of labels are present post metric-relabeling, the
# entire scrape will be treated as failed. 0 means no limit.
[ label_limit: <int> | default = 0 ]

# Per-scrape limit on length of labels name that will be accepted for a sample.
# If a label name is longer than this number post metric-relabeling, the entire
# scrape will be treated as failed. 0 means no limit.
[ label_name_length_limit: <int> | default = 0 ]

# Per-scrape limit on length of labels value that will be accepted for a sample.
# If a label value is longer than this number post metric-relabeling, the
# entire scrape will be treated as failed. 0 means no limit.
[ label_value_length_limit: <int> | default = 0 ]

# Per-scrape config limit on number of unique targets that will be
# accepted. If more than this number of targets are present after target
# relabeling, Prometheus will mark the targets as failed without scraping them.
# 0 means no limit. This is an experimental feature, this behaviour could
# change in the future.
[ target_limit: <int> | default = 0 ]
```

Where `<job_name>` must be unique across all scrape configurations.

### `<tls_config>`

A `tls_config` allows configuring TLS connections.

```
# CA certificate to validate API server certificate with.
[ ca_file: <filename> ]

# Certificate and key files for client cert authentication to the server.
[ cert_file: <filename> ]
[ key_file: <filename> ]

# ServerName extension to indicate the name of the server.
# https://tools.ietf.org/html/rfc4366#section-3.1
[ server_name: <string> ]

# Disable validation of the server certificate.
[ insecure_skip_verify: <boolean> ]

# Minimum acceptable TLS version. Accepted values: TLS10 (TLS 1.0), TLS11 (TLS
# 1.1), TLS12 (TLS 1.2), TLS13 (TLS 1.3).
# If unset, Prometheus will use Go default minimum version, which is TLS 1.2.
# See MinVersion in https://pkg.go.dev/crypto/tls#Config.
[ min_version: <string> ]
# Maximum acceptable TLS version. Accepted values: TLS10 (TLS 1.0), TLS11 (TLS
# 1.1), TLS12 (TLS 1.2), TLS13 (TLS 1.3).
# If unset, Prometheus will use Go default maximum version, which is TLS 1.3.
# See MaxVersion in https://pkg.go.dev/crypto/tls#Config.
[ max_version: <string> ]
```

### `<oauth2>`

OAuth 2.0 authentication using the client credentials grant type. Prometheus fetches an access token from the specified endpoint with the given client access and secret keys.

```
client_id: <string>
[ client_secret: <secret> ]

# Read the client secret from a file.
# It is mutually exclusive with `client_secret`.
[ client_secret_file: <filename> ]

# Scopes for the token request.
scopes:
  [ - <string> ... ]

# The URL to fetch the token from.
token_url: <string>

# Optional parameters to append to the token URL.
endpoint_params:
  [ <string>: <string> ... ]

# Configures the token request's TLS settings.
tls_config:
  [ <tls_config> ]

# Optional proxy URL.
[ proxy_url: <string> ]
# Comma-separated string that can contain IPs, CIDR notation, domain names
# that should be excluded from proxying. IP and domain names can
# contain port numbers.
[ no_proxy: <string> ]
# Use proxy URL indicated by environment variables (HTTP_PROXY, https_proxy, HTTPs_PROXY, https_proxy, and no_proxy)
[ proxy_from_environment: <bool> | default: false ]
# Specifies headers to send to proxies during CONNECT requests.
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]
```

### `<azure_sd_config>`

Azure SD configurations allow retrieving scrape targets from Azure VMs.

The following meta labels are available on targets during [relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config):

- `__meta_azure_machine_id`: the machine ID
- `__meta_azure_machine_location`: the location the machine runs in
- `__meta_azure_machine_name`: the machine name
- `__meta_azure_machine_computer_name`: the machine computer name
- `__meta_azure_machine_os_type`: the machine operating system
- `__meta_azure_machine_private_ip`: the machine's private IP
- `__meta_azure_machine_public_ip`: the machine's public IP if it exists
- `__meta_azure_machine_resource_group`: the machine's resource group
- `__meta_azure_machine_tag_<tagname>`: each tag value of the machine
- `__meta_azure_machine_scale_set`: the name of the scale set which the vm is part of (this value is only set if you are using a [scale set](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/))
- `__meta_azure_machine_size`: the machine size
- `__meta_azure_subscription_id`: the subscription ID
- `__meta_azure_tenant_id`: the tenant ID

See below for the configuration options for Azure discovery:

```
# The information to access the Azure API.
# The Azure environment.
[ environment: <string> | default = AzurePublicCloud ]

# The authentication method, either OAuth or ManagedIdentity.
# See https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview
[ authentication_method: <string> | default = OAuth]
# The subscription ID. Always required.
subscription_id: <string>
# Optional tenant ID. Only required with authentication_method OAuth.
[ tenant_id: <string> ]
# Optional client ID. Only required with authentication_method OAuth.
[ client_id: <string> ]
# Optional client secret. Only required with authentication_method OAuth.
[ client_secret: <secret> ]

# Optional resource group name. Limits discovery to this resource group.
[ resource_group: <string> ]

# Refresh interval to re-read the instance list.
[ refresh_interval: <duration> | default = 300s ]

# The port to scrape metrics from. If using the public IP address, this must
# instead be specified in the relabeling rule.
[ port: <int> | default = 80 ]

# Authentication information used to authenticate to the Azure API.
# Note that `basic_auth`, `authorization` and `oauth2` options are
# mutually exclusive.
# `password` and `password_file` are mutually exclusive.

# Optional HTTP basic authentication information, currently not support by Azure.
basic_auth:
  [ username: <string> ]
  [ password: <secret> ]
  [ password_file: <string> ]

# Optional `Authorization` header configuration, currently not supported by Azure.
authorization:
  # Sets the authentication type.
  [ type: <string> | default: Bearer ]
  # Sets the credentials. It is mutually exclusive with
  # `credentials_file`.
  [ credentials: <secret> ]
  # Sets the credentials to the credentials read from the configured file.
  # It is mutually exclusive with `credentials`.
  [ credentials_file: <filename> ]

# Optional OAuth 2.0 configuration, currently not supported by Azure.
oauth2:
  [ <oauth2> ]

# Optional proxy URL.
[ proxy_url: <string> ]
# Comma-separated string that can contain IPs, CIDR notation, domain names
# that should be excluded from proxying. IP and domain names can
# contain port numbers.
[ no_proxy: <string> ]
# Use proxy URL indicated by environment variables (HTTP_PROXY, https_proxy, HTTPs_PROXY, https_proxy, and no_proxy)
[ proxy_from_environment: <bool> | default: false ]
# Specifies headers to send to proxies during CONNECT requests.
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]

# Configure whether HTTP requests follow HTTP 3xx redirects.
[ follow_redirects: <boolean> | default = true ]

# Whether to enable HTTP2.
[ enable_http2: <bool> | default: true ]

# TLS configuration.
tls_config:
  [ <tls_config> ]
```

### `<consul_sd_config>`

Consul SD configurations allow retrieving scrape targets from [Consul's](https://www.consul.io) Catalog API.

The following meta labels are available on targets during [relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config):

- `__meta_consul_address`: the address of the target
- `__meta_consul_dc`: the datacenter name for the target
- `__meta_consul_health`: the health status of the service
- `__meta_consul_partition`: the admin partition name where the service is registered 
- `__meta_consul_metadata_<key>`: each node metadata key value of the target
- `__meta_consul_node`: the node name defined for the target
- `__meta_consul_service_address`: the service address of the target
- `__meta_consul_service_id`: the service ID of the target
- `__meta_consul_service_metadata_<key>`: each service metadata key value of the target
- `__meta_consul_service_port`: the service port of the target
- `__meta_consul_service`: the name of the service the target belongs to
- `__meta_consul_tagged_address_<key>`: each node tagged address key value of the target
- `__meta_consul_tags`: the list of tags of the target joined by the tag separator

```
# The information to access the Consul API. It is to be defined
# as the Consul documentation requires.
[ server: <host> | default = "localhost:8500" ]
[ token: <secret> ]
[ datacenter: <string> ]
# Namespaces are only supported in Consul Enterprise.
[ namespace: <string> ]
# Admin Partitions are only supported in Consul Enterprise.
[ partition: <string> ]
[ scheme: <string> | default = "http" ]
# The username and password fields are deprecated in favor of the basic_auth configuration.
[ username: <string> ]
[ password: <secret> ]

# A list of services for which targets are retrieved. If omitted, all services
# are scraped.
services:
  [ - <string> ]

# See https://www.consul.io/api/catalog.html#list-nodes-for-service to know more
# about the possible filters that can be used.

# An optional list of tags used to filter nodes for a given service. Services must contain all tags in the list.
tags:
  [ - <string> ]

# Node metadata key/value pairs to filter nodes for a given service.
[ node_meta:
  [ <string>: <string> ... ] ]

# The string by which Consul tags are joined into the tag label.
[ tag_separator: <string> | default = , ]

# Allow stale Consul results (see https://www.consul.io/api/features/consistency.html). Will reduce load on Consul.
[ allow_stale: <boolean> | default = true ]

# The time after which the provided names are refreshed.
# On large setup it might be a good idea to increase this value because the catalog will change all the time.
[ refresh_interval: <duration> | default = 30s ]

# Authentication information used to authenticate to the consul server.
# Note that `basic_auth`, `authorization` and `oauth2` options are
# mutually exclusive.
# `password` and `password_file` are mutually exclusive.

# Optional HTTP basic authentication information.
basic_auth:
  [ username: <string> ]
  [ password: <secret> ]
  [ password_file: <string> ]

# Optional `Authorization` header configuration.
authorization:
  # Sets the authentication type.
  [ type: <string> | default: Bearer ]
  # Sets the credentials. It is mutually exclusive with
  # `credentials_file`.
  [ credentials: <secret> ]
  # Sets the credentials to the credentials read from the configured file.
  # It is mutually exclusive with `credentials`.
  [ credentials_file: <filename> ]

# Optional OAuth 2.0 configuration.
oauth2:
  [ <oauth2> ]

# Optional proxy URL.
[ proxy_url: <string> ]
# Comma-separated string that can contain IPs, CIDR notation, domain names
# that should be excluded from proxying. IP and domain names can
# contain port numbers.
[ no_proxy: <string> ]
# Use proxy URL indicated by environment variables (HTTP_PROXY, https_proxy, HTTPs_PROXY, https_proxy, and no_proxy)
[ proxy_from_environment: <bool> | default: false ]
# Specifies headers to send to proxies during CONNECT requests.
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]

# Configure whether HTTP requests follow HTTP 3xx redirects.
[ follow_redirects: <boolean> | default = true ]

# Whether to enable HTTP2.
[ enable_http2: <bool> | default: true ]

# TLS configuration.
tls_config:
  [ <tls_config> ]
```

Note that the IP number and port used to scrape the targets is assembled as `<__meta_consul_address>:<__meta_consul_service_port>`. However, in some Consul setups, the relevant address is in `__meta_consul_service_address`. In those cases, you can use the [relabel](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config) feature to replace the special `__address__` label.

The [relabeling phase](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config) is the preferred and more powerful way to filter services or nodes for a service based on arbitrary labels. For users with thousands of services it can be more efficient to use the Consul API directly which has basic support for filtering nodes (currently by node metadata and a single tag).

### `<digitalocean_sd_config>`

DigitalOcean SD configurations allow retrieving scrape targets from [DigitalOcean's](https://www.digitalocean.com/) Droplets API. This service discovery uses the public IPv4 address by default, by that can be changed with relabeling, as demonstrated in [the Prometheus digitalocean-sd configuration file](https://github.com/prometheus/prometheus/blob/release-2.43/documentation/examples/prometheus-digitalocean.yml).

The following meta labels are available on targets during [relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config):

- `__meta_digitalocean_droplet_id`: the id of the droplet
- `__meta_digitalocean_droplet_name`: the name of the droplet
- `__meta_digitalocean_image`: the slug of the droplet's image
- `__meta_digitalocean_image_name`: the display name of the droplet's image
- `__meta_digitalocean_private_ipv4`: the private IPv4 of the droplet
- `__meta_digitalocean_public_ipv4`: the public IPv4 of the droplet
- `__meta_digitalocean_public_ipv6`: the public IPv6 of the droplet
- `__meta_digitalocean_region`: the region of the droplet
- `__meta_digitalocean_size`: the size of the droplet
- `__meta_digitalocean_status`: the status of the droplet
- `__meta_digitalocean_features`: the comma-separated list of features of the droplet
- `__meta_digitalocean_tags`: the comma-separated list of tags of the droplet
- `__meta_digitalocean_vpc`: the id of the droplet's VPC

```
# Authentication information used to authenticate to the API server.
# Note that `basic_auth` and `authorization` options are
# mutually exclusive.
# password and password_file are mutually exclusive.

# Optional HTTP basic authentication information, not currently supported by DigitalOcean.
basic_auth:
  [ username: <string> ]
  [ password: <secret> ]
  [ password_file: <string> ]

# Optional `Authorization` header configuration.
authorization:
  # Sets the authentication type.
  [ type: <string> | default: Bearer ]
  # Sets the credentials. It is mutually exclusive with
  # `credentials_file`.
  [ credentials: <secret> ]
  # Sets the credentials to the credentials read from the configured file.
  # It is mutually exclusive with `credentials`.
  [ credentials_file: <filename> ]

# Optional OAuth 2.0 configuration.
# Cannot be used at the same time as basic_auth or authorization.
oauth2:
  [ <oauth2> ]

# Optional proxy URL.
[ proxy_url: <string> ]
# Comma-separated string that can contain IPs, CIDR notation, domain names
# that should be excluded from proxying. IP and domain names can
# contain port numbers.
[ no_proxy: <string> ]
# Use proxy URL indicated by environment variables (HTTP_PROXY, https_proxy, HTTPs_PROXY, https_proxy, and no_proxy)
[ proxy_from_environment: <bool> | default: false ]
# Specifies headers to send to proxies during CONNECT requests.
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]

# Configure whether HTTP requests follow HTTP 3xx redirects.
[ follow_redirects: <boolean> | default = true ]

# Whether to enable HTTP2.
[ enable_http2: <bool> | default: true ]

# TLS configuration.
tls_config:
  [ <tls_config> ]

# The port to scrape metrics from.
[ port: <int> | default = 80 ]

# The time after which the droplets are refreshed.
[ refresh_interval: <duration> | default = 60s ]
```

### `<docker_sd_config>`

Docker SD configurations allow retrieving scrape targets from [Docker Engine](https://docs.docker.com/engine/) hosts.

This SD discovers "containers" and will create a target for each network IP and port the container is configured to expose.

Available meta labels:

- `__meta_docker_container_id`: the id of the container
- `__meta_docker_container_name`: the name of the container
- `__meta_docker_container_network_mode`: the network mode of the container
- `__meta_docker_container_label_<labelname>`: each label of the container
- `__meta_docker_network_id`: the ID of the network
- `__meta_docker_network_name`: the name of the network
- `__meta_docker_network_ingress`: whether the network is ingress
- `__meta_docker_network_internal`: whether the network is internal
- `__meta_docker_network_label_<labelname>`: each label of the network
- `__meta_docker_network_scope`: the scope of the network
- `__meta_docker_network_ip`: the IP of the container in this network
- `__meta_docker_port_private`: the port on the container
- `__meta_docker_port_public`: the external port if a port-mapping exists
- `__meta_docker_port_public_ip`: the public IP if a port-mapping exists

See below for the configuration options for Docker discovery:

```
# Address of the Docker daemon.
host: <string>

# Optional proxy URL.
[ proxy_url: <string> ]
# Comma-separated string that can contain IPs, CIDR notation, domain names
# that should be excluded from proxying. IP and domain names can
# contain port numbers.
[ no_proxy: <string> ]
# Use proxy URL indicated by environment variables (HTTP_PROXY, https_proxy, HTTPs_PROXY, https_proxy, and no_proxy)
[ proxy_from_environment: <bool> | default: false ]
# Specifies headers to send to proxies during CONNECT requests.
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]

# TLS configuration.
tls_config:
  [ <tls_config> ]

# The port to scrape metrics from, when `role` is nodes, and for discovered
# tasks and services that don't have published ports.
[ port: <int> | default = 80 ]

# The host to use if the container is in host networking mode.
[ host_networking_host: <string> | default = "localhost" ]

# Optional filters to limit the discovery process to a subset of available
# resources.
# The available filters are listed in the upstream documentation:
# https://docs.docker.com/engine/api/v1.40/#operation/ContainerList
[ filters:
  [ - name: <string>
      values: <string>, [...] ]

# The time after which the containers are refreshed.
[ refresh_interval: <duration> | default = 60s ]

# Authentication information used to authenticate to the Docker daemon.
# Note that `basic_auth` and `authorization` options are
# mutually exclusive.
# password and password_file are mutually exclusive.

# Optional HTTP basic authentication information.
basic_auth:
  [ username: <string> ]
  [ password: <secret> ]
  [ password_file: <string> ]

# Optional `Authorization` header configuration.
authorization:
  # Sets the authentication type.
  [ type: <string> | default: Bearer ]
  # Sets the credentials. It is mutually exclusive with
  # `credentials_file`.
  [ credentials: <secret> ]
  # Sets the credentials to the credentials read from the configured file.
  # It is mutually exclusive with `credentials`.
  [ credentials_file: <filename> ]

# Optional OAuth 2.0 configuration.
# Cannot be used at the same time as basic_auth or authorization.
oauth2:
  [ <oauth2> ]

# Configure whether HTTP requests follow HTTP 3xx redirects.
[ follow_redirects: <boolean> | default = true ]

# Whether to enable HTTP2.
[ enable_http2: <bool> | default: true ]
```

The [relabeling phase](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config) is the preferred and more powerful way to filter containers. For users with thousands of containers it can be more efficient to use the Docker API directly which has basic support for filtering containers (using `filters`).

See [this example Prometheus configuration file](https://github.com/prometheus/prometheus/blob/release-2.43/documentation/examples/prometheus-docker.yml) for a detailed example of configuring Prometheus for Docker Engine.

### `<dockerswarm_sd_config>`

Docker Swarm SD configurations allow retrieving scrape targets from [Docker Swarm](https://docs.docker.com/engine/swarm/) engine.

One of the following roles can be configured to discover targets:

#### `services`

The `services` role discovers all [Swarm services](https://docs.docker.com/engine/swarm/key-concepts/#services-and-tasks) and exposes their ports as targets. For each published port of a service, a single target is generated. If a service has no published ports, a target per service is created using the `port` parameter defined in the SD configuration.

Available meta labels:

- `__meta_dockerswarm_service_id`: the id of the service
- `__meta_dockerswarm_service_name`: the name of the service
- `__meta_dockerswarm_service_mode`: the mode of the service
- `__meta_dockerswarm_service_endpoint_port_name`: the name of the endpoint port, if available
- `__meta_dockerswarm_service_endpoint_port_publish_mode`: the publish mode of the endpoint port
- `__meta_dockerswarm_service_label_<labelname>`: each label of the service
- `__meta_dockerswarm_service_task_container_hostname`: the container hostname of the target, if available
- `__meta_dockerswarm_service_task_container_image`: the container image of the target
- `__meta_dockerswarm_service_updating_status`: the status of the service, if available
- `__meta_dockerswarm_network_id`: the ID of the network
- `__meta_dockerswarm_network_name`: the name of the network
- `__meta_dockerswarm_network_ingress`: whether the network is ingress
- `__meta_dockerswarm_network_internal`: whether the network is internal
- `__meta_dockerswarm_network_label_<labelname>`: each label of the network
- `__meta_dockerswarm_network_scope`: the scope of the network

#### `tasks`

The `tasks` role discovers all [Swarm tasks](https://docs.docker.com/engine/swarm/key-concepts/#services-and-tasks) and exposes their ports as targets. For each published port of a task, a single target is generated. If a task has no published ports, a target per task is created using the `port` parameter defined in the SD configuration.

Available meta labels:

- `__meta_dockerswarm_container_label_<labelname>`: each label of the container
- `__meta_dockerswarm_task_id`: the id of the task
- `__meta_dockerswarm_task_container_id`: the container id of the task
- `__meta_dockerswarm_task_desired_state`: the desired state of the task
- `__meta_dockerswarm_task_slot`: the slot of the task
- `__meta_dockerswarm_task_state`: the state of the task
- `__meta_dockerswarm_task_port_publish_mode`: the publish mode of the task port
- `__meta_dockerswarm_service_id`: the id of the service
- `__meta_dockerswarm_service_name`: the name of the service
- `__meta_dockerswarm_service_mode`: the mode of the service
- `__meta_dockerswarm_service_label_<labelname>`: each label of the service
- `__meta_dockerswarm_network_id`: the ID of the network
- `__meta_dockerswarm_network_name`: the name of the network
- `__meta_dockerswarm_network_ingress`: whether the network is ingress
- `__meta_dockerswarm_network_internal`: whether the network is internal
- `__meta_dockerswarm_network_label_<labelname>`: each label of the network
- `__meta_dockerswarm_network_label`: each label of the network
- `__meta_dockerswarm_network_scope`: the scope of the network
- `__meta_dockerswarm_node_id`: the ID of the node
- `__meta_dockerswarm_node_hostname`: the hostname of the node
- `__meta_dockerswarm_node_address`: the address of the node
- `__meta_dockerswarm_node_availability`: the availability of the node
- `__meta_dockerswarm_node_label_<labelname>`: each label of the node
- `__meta_dockerswarm_node_platform_architecture`: the architecture of the node
- `__meta_dockerswarm_node_platform_os`: the operating system of the node
- `__meta_dockerswarm_node_role`: the role of the node
- `__meta_dockerswarm_node_status`: the status of the node

The `__meta_dockerswarm_network_*` meta labels are not populated for ports which are published with `mode=host`.

#### `nodes`

The `nodes` role is used to discover [Swarm nodes](https://docs.docker.com/engine/swarm/key-concepts/#nodes).

Available meta labels:

- `__meta_dockerswarm_node_address`: the address of the node
- `__meta_dockerswarm_node_availability`: the availability of the node
- `__meta_dockerswarm_node_engine_version`: the version of the node engine
- `__meta_dockerswarm_node_hostname`: the hostname of the node
- `__meta_dockerswarm_node_id`: the ID of the node
- `__meta_dockerswarm_node_label_<labelname>`: each label of the node
- `__meta_dockerswarm_node_manager_address`: the address of the manager component of the node
- `__meta_dockerswarm_node_manager_leader`: the leadership status of the manager component of the node (true or false)
- `__meta_dockerswarm_node_manager_reachability`: the reachability of the manager component of the node
- `__meta_dockerswarm_node_platform_architecture`: the architecture of the node
- `__meta_dockerswarm_node_platform_os`: the operating system of the node
- `__meta_dockerswarm_node_role`: the role of the node
- `__meta_dockerswarm_node_status`: the status of the node

See below for the configuration options for Docker Swarm discovery:

```
# Address of the Docker daemon.
host: <string>

# Optional proxy URL.
[ proxy_url: <string> ]
# Comma-separated string that can contain IPs, CIDR notation, domain names
# that should be excluded from proxying. IP and domain names can
# contain port numbers.
[ no_proxy: <string> ]
# Use proxy URL indicated by environment variables (HTTP_PROXY, https_proxy, HTTPs_PROXY, https_proxy, and no_proxy)
[ proxy_from_environment: <bool> | default: false ]
# Specifies headers to send to proxies during CONNECT requests.
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]

# TLS configuration.
tls_config:
  [ <tls_config> ]

# Role of the targets to retrieve. Must be `services`, `tasks`, or `nodes`.
role: <string>

# The port to scrape metrics from, when `role` is nodes, and for discovered
# tasks and services that don't have published ports.
[ port: <int> | default = 80 ]

# Optional filters to limit the discovery process to a subset of available
# resources.
# The available filters are listed in the upstream documentation:
# Services: https://docs.docker.com/engine/api/v1.40/#operation/ServiceList
# Tasks: https://docs.docker.com/engine/api/v1.40/#operation/TaskList
# Nodes: https://docs.docker.com/engine/api/v1.40/#operation/NodeList
[ filters:
  [ - name: <string>
      values: <string>, [...] ]

# The time after which the service discovery data is refreshed.
[ refresh_interval: <duration> | default = 60s ]

# Authentication information used to authenticate to the Docker daemon.
# Note that `basic_auth` and `authorization` options are
# mutually exclusive.
# password and password_file are mutually exclusive.

# Optional HTTP basic authentication information.
basic_auth:
  [ username: <string> ]
  [ password: <secret> ]
  [ password_file: <string> ]

# Optional `Authorization` header configuration.
authorization:
  # Sets the authentication type.
  [ type: <string> | default: Bearer ]
  # Sets the credentials. It is mutually exclusive with
  # `credentials_file`.
  [ credentials: <secret> ]
  # Sets the credentials to the credentials read from the configured file.
  # It is mutually exclusive with `credentials`.
  [ credentials_file: <filename> ]

# Optional OAuth 2.0 configuration.
# Cannot be used at the same time as basic_auth or authorization.
oauth2:
  [ <oauth2> ]

# Configure whether HTTP requests follow HTTP 3xx redirects.
[ follow_redirects: <boolean> | default = true ]

# Whether to enable HTTP2.
[ enable_http2: <bool> | default: true ]
```

The [relabeling phase](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config) is the preferred and more powerful way to filter tasks, services or nodes. For users with thousands of tasks it can be more efficient to use the Swarm API directly which has basic support for filtering nodes (using `filters`).

See [this example Prometheus configuration file](https://github.com/prometheus/prometheus/blob/release-2.43/documentation/examples/prometheus-dockerswarm.yml) for a detailed example of configuring Prometheus for Docker Swarm.

### `<dns_sd_config>`

A DNS-based service discovery configuration allows specifying a set of DNS domain names which are periodically queried to discover a list of targets. The DNS servers to be contacted are read from `/etc/resolv.conf`.

This service discovery method only supports basic DNS A, AAAA, MX and SRV record queries, but not the advanced DNS-SD approach specified in [RFC6763](https://tools.ietf.org/html/rfc6763).

The following meta labels are available on targets during [relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config):

- `__meta_dns_name`: the record name that produced the discovered target.
- `__meta_dns_srv_record_target`: the target field of the SRV record
- `__meta_dns_srv_record_port`: the port field of the SRV record
- `__meta_dns_mx_record_target`: the target field of the MX record

```
# A list of DNS domain names to be queried.
names:
  [ - <string> ]

# The type of DNS query to perform. One of SRV, A, AAAA or MX.
[ type: <string> | default = 'SRV' ]

# The port number used if the query type is not SRV.
[ port: <int>]

# The time after which the provided names are refreshed.
[ refresh_interval: <duration> | default = 30s ]
```

### `<ec2_sd_config>`

EC2 SD configurations allow retrieving scrape targets from AWS EC2 instances. The private IP address is used by default, but may be changed to the public IP address with relabeling.

The IAM credentials used must have the `ec2:DescribeInstances` permission to discover scrape targets, and may optionally have the `ec2:DescribeAvailabilityZones` permission if you want the availability zone ID available as a label (see below).

The following meta labels are available on targets during [relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config):

- `__meta_ec2_ami`: the EC2 Amazon Machine Image
- `__meta_ec2_architecture`: the architecture of the instance
- `__meta_ec2_availability_zone`: the availability zone in which the instance is running
- `__meta_ec2_availability_zone_id`: the [availability zone ID](https://docs.aws.amazon.com/ram/latest/userguide/working-with-az-ids.html) in which the instance is running (requires `ec2:DescribeAvailabilityZones`)
- `__meta_ec2_instance_id`: the EC2 instance ID
- `__meta_ec2_instance_lifecycle`: the lifecycle of the EC2 instance, set only for 'spot' or 'scheduled' instances, absent otherwise
- `__meta_ec2_instance_state`: the state of the EC2 instance
- `__meta_ec2_instance_type`: the type of the EC2 instance
- `__meta_ec2_ipv6_addresses`: comma separated list of IPv6 addresses assigned to the instance's network interfaces, if present
- `__meta_ec2_owner_id`: the ID of the AWS account that owns the EC2 instance
- `__meta_ec2_platform`: the Operating System platform, set to 'windows' on Windows servers, absent otherwise
- `__meta_ec2_primary_subnet_id`: the subnet ID of the primary network interface, if available
- `__meta_ec2_private_dns_name`: the private DNS name of the instance, if available
- `__meta_ec2_private_ip`: the private IP address of the instance, if present
- `__meta_ec2_public_dns_name`: the public DNS name of the instance, if available
- `__meta_ec2_public_ip`: the public IP address of the instance, if available
- `__meta_ec2_region`: the region of the instance
- `__meta_ec2_subnet_id`: comma separated list of subnets IDs in which the instance is running, if available
- `__meta_ec2_tag_<tagkey>`: each tag value of the instance
- `__meta_ec2_vpc_id`: the ID of the VPC in which the instance is running, if available

See below for the configuration options for EC2 discovery:

```
# The information to access the EC2 API.

# The AWS region. If blank, the region from the instance metadata is used.
[ region: <string> ]

# Custom endpoint to be used.
[ endpoint: <string> ]

# The AWS API keys. If blank, the environment variables `AWS_ACCESS_KEY_ID`
# and `AWS_SECRET_ACCESS_KEY` are used.
[ access_key: <string> ]
[ secret_key: <secret> ]
# Named AWS profile used to connect to the API.
[ profile: <string> ]

# AWS Role ARN, an alternative to using AWS API keys.
[ role_arn: <string> ]

# Refresh interval to re-read the instance list.
[ refresh_interval: <duration> | default = 60s ]

# The port to scrape metrics from. If using the public IP address, this must
# instead be specified in the relabeling rule.
[ port: <int> | default = 80 ]

# Filters can be used optionally to filter the instance list by other criteria.
# Available filter criteria can be found here:
# https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeInstances.html
# Filter API documentation: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_Filter.html
filters:
  [ - name: <string>
      values: <string>, [...] ]

# Authentication information used to authenticate to the EC2 API.
# Note that `basic_auth`, `authorization` and `oauth2` options are
# mutually exclusive.
# `password` and `password_file` are mutually exclusive.

# Optional HTTP basic authentication information, currently not supported by AWS.
basic_auth:
  [ username: <string> ]
  [ password: <secret> ]
  [ password_file: <string> ]

# Optional `Authorization` header configuration, currently not supported by AWS.
authorization:
  # Sets the authentication type.
  [ type: <string> | default: Bearer ]
  # Sets the credentials. It is mutually exclusive with
  # `credentials_file`.
  [ credentials: <secret> ]
  # Sets the credentials to the credentials read from the configured file.
  # It is mutuall exclusive with `credentials`.
  [ credentials_file: <filename> ]

# Optional OAuth 2.0 configuration, currently not supported by AWS.
oauth2:
  [ <oauth2> ]

# Optional proxy URL.
[ proxy_url: <string> ]
# Comma-separated string that can contain IPs, CIDR notation, domain names
# that should be excluded from proxying. IP and domain names can
# contain port numbers.
[ no_proxy: <string> ]
# Use proxy URL indicated by environment variables (HTTP_PROXY, https_proxy, HTTPs_PROXY, https_proxy, and no_proxy)
[ proxy_from_environment: <bool> | default: false ]
# Specifies headers to send to proxies during CONNECT requests.
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]

# Configure whether HTTP requests follow HTTP 3xx redirects.
[ follow_redirects: <boolean> | default = true ]

# Whether to enable HTTP2.
[ enable_http2: <bool> | default: true ]

# TLS configuration.
tls_config:
  [ <tls_config> ]
```

The [relabeling phase](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config) is the preferred and more powerful way to filter targets based on arbitrary labels. For users with thousands of instances it can be more efficient to use the EC2 API directly which has support for filtering instances.

### `<openstack_sd_config>`

OpenStack SD configurations allow retrieving scrape targets from OpenStack Nova instances.

One of the following `<openstack_role>` types can be configured to discover targets:

#### `hypervisor`

The `hypervisor` role discovers one target per Nova hypervisor node. The target address defaults to the `host_ip` attribute of the hypervisor.

The following meta labels are available on targets during [relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config):

- `__meta_openstack_hypervisor_host_ip`: the hypervisor node's IP address.
- `__meta_openstack_hypervisor_hostname`: the hypervisor node's name.
- `__meta_openstack_hypervisor_id`: the hypervisor node's ID.
- `__meta_openstack_hypervisor_state`: the hypervisor node's state.
- `__meta_openstack_hypervisor_status`: the hypervisor node's status.
- `__meta_openstack_hypervisor_type`: the hypervisor node's type.

#### `instance`

The `instance` role discovers one target per network interface of Nova instance. The target address defaults to the private IP address of the network interface.

The following meta labels are available on targets during [relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config):

- `__meta_openstack_address_pool`: the pool of the private IP.
- `__meta_openstack_instance_flavor`: the flavor of the OpenStack instance.
- `__meta_openstack_instance_id`: the OpenStack instance ID.
- `__meta_openstack_instance_name`: the OpenStack instance name.
- `__meta_openstack_instance_status`: the status of the OpenStack instance.
- `__meta_openstack_private_ip`: the private IP of the OpenStack instance.
- `__meta_openstack_project_id`: the project (tenant) owning this instance.
- `__meta_openstack_public_ip`: the public IP of the OpenStack instance.
- `__meta_openstack_tag_<tagkey>`: each tag value of the instance.
- `__meta_openstack_user_id`: the user account owning the tenant.

See below for the configuration options for OpenStack discovery:

```
# The information to access the OpenStack API.

# The OpenStack role of entities that should be discovered.
role: <openstack_role>

# The OpenStack Region.
region: <string>

# identity_endpoint specifies the HTTP endpoint that is required to work with
# the Identity API of the appropriate version. While it's ultimately needed by
# all of the identity services, it will often be populated by a provider-level
# function.
[ identity_endpoint: <string> ]

# username is required if using Identity V2 API. Consult with your provider's
# control panel to discover your account's username. In Identity V3, either
# userid or a combination of username and domain_id or domain_name are needed.
[ username: <string> ]
[ userid: <string> ]

# password for the Identity V2 and V3 APIs. Consult with your provider's
# control panel to discover your account's preferred method of authentication.
[ password: <secret> ]

# At most one of domain_id and domain_name must be provided if using username
# with Identity V3. Otherwise, either are optional.
[ domain_name: <string> ]
[ domain_id: <string> ]

# The project_id and project_name fields are optional for the Identity V2 API.
# Some providers allow you to specify a project_name instead of the project_id.
# Some require both. Your provider's authentication policies will determine
# how these fields influence authentication.
[ project_name: <string> ]
[ project_id: <string> ]

# The application_credential_id or application_credential_name fields are
# required if using an application credential to authenticate. Some providers
# allow you to create an application credential to authenticate rather than a
# password.
[ application_credential_name: <string> ]
[ application_credential_id: <string> ]

# The application_credential_secret field is required if using an application
# credential to authenticate.
[ application_credential_secret: <secret> ]

# Whether the service discovery should list all instances for all projects.
# It is only relevant for the 'instance' role and usually requires admin permissions.
[ all_tenants: <boolean> | default: false ]

# Refresh interval to re-read the instance list.
[ refresh_interval: <duration> | default = 60s ]

# The port to scrape metrics from. If using the public IP address, this must
# instead be specified in the relabeling rule.
[ port: <int> | default = 80 ]

# The availability of the endpoint to connect to. Must be one of public, admin or internal.
[ availability: <string> | default = "public" ]

# TLS configuration.
tls_config:
  [ <tls_config> ]
```

### `<ovhcloud_sd_config>`

OVHcloud SD configurations allow retrieving scrape targets from OVHcloud's [dedicated servers](https://www.ovhcloud.com/en/bare-metal/) and [VPS](https://www.ovhcloud.com/en/vps/) using their [API](https://api.ovh.com/). Prometheus will periodically check the REST endpoint and create a target for every discovered server. The role will try to use the public IPv4 address as default address, if  there's none it will try to use the IPv6 one. This may be changed with  relabeling. For OVHcloud's [public cloud instances](https://www.ovhcloud.com/en/public-cloud/) you can use the [openstack*sd*config](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#openstack_sd_config).

#### VPS

- `__meta_ovhcloud_vps_cluster`: the cluster of the server
- `__meta_ovhcloud_vps_datacenter`: the datacenter of the server
- `__meta_ovhcloud_vps_disk`: the disk of the server
- `__meta_ovhcloud_vps_display_name`: the display name of the server
- `__meta_ovhcloud_vps_ipv4`: the IPv4 of the server
- `__meta_ovhcloud_vps_ipv6`: the IPv6 of the server
- `__meta_ovhcloud_vps_keymap`: the KVM keyboard layout of the server
- `__meta_ovhcloud_vps_maximum_additional_ip`: the maximum additional IPs of the server
- `__meta_ovhcloud_vps_memory_limit`: the memory limit of the server
- `__meta_ovhcloud_vps_memory`: the memory of the server
- `__meta_ovhcloud_vps_monitoring_ip_blocks`: the monitoring IP blocks of the server
- `__meta_ovhcloud_vps_name`: the name of the server
- `__meta_ovhcloud_vps_netboot_mode`: the netboot mode of the server
- `__meta_ovhcloud_vps_offer_type`: the offer type of the server
- `__meta_ovhcloud_vps_offer`: the offer of the server
- `__meta_ovhcloud_vps_state`: the state of the server
- `__meta_ovhcloud_vps_vcore`: the number of virtual cores of the server
- `__meta_ovhcloud_vps_version`: the version of the server
- `__meta_ovhcloud_vps_zone`: the zone of the server

#### Dedicated servers

- `__meta_ovhcloud_dedicated_server_commercial_range`: the commercial range of the server
- `__meta_ovhcloud_dedicated_server_datacenter`: the datacenter of the server
- `__meta_ovhcloud_dedicated_server_ipv4`: the IPv4 of the server
- `__meta_ovhcloud_dedicated_server_ipv6`: the IPv6 of the server
- `__meta_ovhcloud_dedicated_server_link_speed`: the link speed of the server
- `__meta_ovhcloud_dedicated_server_name`: the name of the server
- `__meta_ovhcloud_dedicated_server_os`: the operating system of the server
- `__meta_ovhcloud_dedicated_server_rack`: the rack of the server
- `__meta_ovhcloud_dedicated_server_reverse`: the reverse DNS name of the server
- `__meta_ovhcloud_dedicated_server_server_id`: the ID of the server
- `__meta_ovhcloud_dedicated_server_state`: the state of the server
- `__meta_ovhcloud_dedicated_server_support_level`: the support level of the server

See below for the configuration options for OVHcloud discovery:

```
# Access key to use. https://api.ovh.com
application_key: <string>
application_secret: <secret>
consumer_key: <secret>
# Service of the targets to retrieve. Must be `vps` or `dedicated_server`.
service: <string>
# API endpoint. https://github.com/ovh/go-ovh#supported-apis
[ endpoint: <string> | default = "ovh-eu" ]
# Refresh interval to re-read the resources list.
[ refresh_interval: <duration> | default = 60s ]
```

### `<puppetdb_sd_config>`

PuppetDB SD configurations allow retrieving scrape targets from [PuppetDB](https://puppet.com/docs/puppetdb/latest/index.html) resources.

This SD discovers resources and will create a target for each resource returned by the API.

The resource address is the `certname` of the resource and can be changed during [relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config).

The following meta labels are available on targets during [relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config):

- `__meta_puppetdb_query`: the Puppet Query Language (PQL) query
- `__meta_puppetdb_certname`: the name of the node associated with the resource
- `__meta_puppetdb_resource`: a SHA-1 hash of the resource’s type, title, and parameters, for identification
- `__meta_puppetdb_type`: the resource type
- `__meta_puppetdb_title`: the resource title
- `__meta_puppetdb_exported`: whether the resource is exported (`"true"` or `"false"`)
- `__meta_puppetdb_tags`: comma separated list of resource tags
- `__meta_puppetdb_file`: the manifest file in which the resource was declared
- `__meta_puppetdb_environment`: the environment of the node associated with the resource
- `__meta_puppetdb_parameter_<parametername>`: the parameters of the resource

See below for the configuration options for PuppetDB discovery:

```
# The URL of the PuppetDB root query endpoint.
url: <string>

# Puppet Query Language (PQL) query. Only resources are supported.
# https://puppet.com/docs/puppetdb/latest/api/query/v4/pql.html
query: <string>

# Whether to include the parameters as meta labels.
# Due to the differences between parameter types and Prometheus labels,
# some parameters might not be rendered. The format of the parameters might
# also change in future releases.
#
# Note: Enabling this exposes parameters in the Prometheus UI and API. Make sure
# that you don't have secrets exposed as parameters if you enable this.
[ include_parameters: <boolean> | default = false ]

# Refresh interval to re-read the resources list.
[ refresh_interval: <duration> | default = 60s ]

# The port to scrape metrics from.
[ port: <int> | default = 80 ]

# TLS configuration to connect to the PuppetDB.
tls_config:
  [ <tls_config> ]

# basic_auth, authorization, and oauth2, are mutually exclusive.

# Optional HTTP basic authentication information.
basic_auth:
  [ username: <string> ]
  [ password: <secret> ]
  [ password_file: <string> ]

# `Authorization` HTTP header configuration.
authorization:
  # Sets the authentication type.
  [ type: <string> | default: Bearer ]
  # Sets the credentials. It is mutually exclusive with
  # `credentials_file`.
  [ credentials: <secret> ]
  # Sets the credentials with the credentials read from the configured file.
  # It is mutually exclusive with `credentials`.
  [ credentials_file: <filename> ]

# Optional OAuth 2.0 configuration.
# Cannot be used at the same time as basic_auth or authorization.
oauth2:
  [ <oauth2> ]

# Optional proxy URL.
[ proxy_url: <string> ]
# Comma-separated string that can contain IPs, CIDR notation, domain names
# that should be excluded from proxying. IP and domain names can
# contain port numbers.
[ no_proxy: <string> ]
# Use proxy URL indicated by environment variables (HTTP_PROXY, https_proxy, HTTPs_PROXY, https_proxy, and no_proxy)
[ proxy_from_environment: <bool> | default: false ]
# Specifies headers to send to proxies during CONNECT requests.
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]

# Configure whether HTTP requests follow HTTP 3xx redirects.
[ follow_redirects: <boolean> | default = true ]

# Whether to enable HTTP2.
[ enable_http2: <bool> | default: true ]
```

See [this example Prometheus configuration file](https://github.com/prometheus/prometheus/blob/release-2.43/documentation/examples/prometheus-puppetdb.yml) for a detailed example of configuring Prometheus with PuppetDB.

### `<file_sd_config>`

File-based service discovery provides a more generic way to configure static targets and serves as an interface to plug in custom service discovery mechanisms.

It reads a set of files containing a list of zero or more `<static_config>`s. Changes to all defined files are detected via disk watches and applied immediately. Files may be provided in YAML or JSON format. Only changes resulting in well-formed target groups are applied.

Files must contain a list of static configs, using these formats:

**JSON**

```
[
  {
    "targets": [ "<host>", ... ],
    "labels": {
      "<labelname>": "<labelvalue>", ...
    }
  },
  ...
]
```

**YAML**

```
- targets:
  [ - '<host>' ]
  labels:
    [ <labelname>: <labelvalue> ... ]
```

As a fallback, the file contents are also re-read periodically at the specified refresh interval.

Each target has a meta label `__meta_filepath` during the [relabeling phase](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config). Its value is set to the filepath from which the target was extracted.

There is a list of [integrations](https://prometheus.io/docs/operating/integrations/#file-service-discovery) with this discovery mechanism.

```
# Patterns for files from which target groups are extracted.
files:
  [ - <filename_pattern> ... ]

# Refresh interval to re-read the files.
[ refresh_interval: <duration> | default = 5m ]
```

Where `<filename_pattern>` may be a path ending in `.json`, `.yml` or `.yaml`. The last path segment may contain a single `*` that matches any character sequence, e.g. `my/path/tg_*.json`.

### `<gce_sd_config>`

[GCE](https://cloud.google.com/compute/) SD configurations allow retrieving scrape targets from GCP GCE instances. The private IP address is used by default, but may be changed to the public IP address with relabeling.

The following meta labels are available on targets during [relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config):

- `__meta_gce_instance_id`: the numeric id of the instance
- `__meta_gce_instance_name`: the name of the instance
- `__meta_gce_label_<labelname>`: each GCE label of the instance
- `__meta_gce_machine_type`: full or partial URL of the machine type of the instance
- `__meta_gce_metadata_<name>`: each metadata item of the instance
- `__meta_gce_network`: the network URL of the instance
- `__meta_gce_private_ip`: the private IP address of the instance
- `__meta_gce_interface_ipv4_<name>`: IPv4 address of each named interface
- `__meta_gce_project`: the GCP project in which the instance is running
- `__meta_gce_public_ip`: the public IP address of the instance, if present
- `__meta_gce_subnetwork`: the subnetwork URL of the instance
- `__meta_gce_tags`: comma separated list of instance tags
- `__meta_gce_zone`: the GCE zone URL in which the instance is running

See below for the configuration options for GCE discovery:

```
# The information to access the GCE API.

# The GCP Project
project: <string>

# The zone of the scrape targets. If you need multiple zones use multiple
# gce_sd_configs.
zone: <string>

# Filter can be used optionally to filter the instance list by other criteria
# Syntax of this filter string is described here in the filter query parameter section:
# https://cloud.google.com/compute/docs/reference/latest/instances/list
[ filter: <string> ]

# Refresh interval to re-read the instance list
[ refresh_interval: <duration> | default = 60s ]

# The port to scrape metrics from. If using the public IP address, this must
# instead be specified in the relabeling rule.
[ port: <int> | default = 80 ]

# The tag separator is used to separate the tags on concatenation
[ tag_separator: <string> | default = , ]
```

Credentials are discovered by the Google Cloud SDK default client by looking in the following places, preferring the first location found:

1. a JSON file specified by the `GOOGLE_APPLICATION_CREDENTIALS` environment variable
2. a JSON file in the well-known path `$HOME/.config/gcloud/application_default_credentials.json`
3. fetched from the GCE metadata server

If Prometheus is running within GCE, the service account associated with the instance it is running on should have at least read-only permissions to the compute resources. If running outside of GCE make sure to create an appropriate service account and place the credential file in one of the expected locations.

### `<hetzner_sd_config>`

Hetzner SD configurations allow retrieving scrape targets from [Hetzner](https://www.hetzner.com/) [Cloud](https://www.hetzner.cloud/) API and [Robot](https://docs.hetzner.com/robot/) API. This service discovery uses the public IPv4 address by default, but that can be changed with relabeling, as demonstrated in [the Prometheus hetzner-sd configuration file](https://github.com/prometheus/prometheus/blob/release-2.43/documentation/examples/prometheus-hetzner.yml).

The following meta labels are available on all targets during [relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config):

- `__meta_hetzner_server_id`: the ID of the server
- `__meta_hetzner_server_name`: the name of the server
- `__meta_hetzner_server_status`: the status of the server
- `__meta_hetzner_public_ipv4`: the public ipv4 address of the server
- `__meta_hetzner_public_ipv6_network`: the public ipv6 network (/64) of the server
- `__meta_hetzner_datacenter`: the datacenter of the server

The labels below are only available for targets with `role` set to `hcloud`:

- `__meta_hetzner_hcloud_image_name`: the image name of the server
- `__meta_hetzner_hcloud_image_description`: the description of the server image
- `__meta_hetzner_hcloud_image_os_flavor`: the OS flavor of the server image
- `__meta_hetzner_hcloud_image_os_version`: the OS version of the server image
- `__meta_hetzner_hcloud_datacenter_location`: the location of the server
- `__meta_hetzner_hcloud_datacenter_location_network_zone`: the network zone of the server
- `__meta_hetzner_hcloud_server_type`: the type of the server
- `__meta_hetzner_hcloud_cpu_cores`: the CPU cores count of the server
- `__meta_hetzner_hcloud_cpu_type`: the CPU type of the server (shared or dedicated)
- `__meta_hetzner_hcloud_memory_size_gb`: the amount of memory of the server (in GB)
- `__meta_hetzner_hcloud_disk_size_gb`: the disk size of the server (in GB)
- `__meta_hetzner_hcloud_private_ipv4_<networkname>`: the private ipv4 address of the server within a given network
- `__meta_hetzner_hcloud_label_<labelname>`: each label of the server
- `__meta_hetzner_hcloud_labelpresent_<labelname>`: `true` for each label of the server

The labels below are only available for targets with `role` set to `robot`:

- `__meta_hetzner_robot_product`: the product of the server
- `__meta_hetzner_robot_cancelled`: the server cancellation status

```
# The Hetzner role of entities that should be discovered.
# One of robot or hcloud.
role: <string>

# Authentication information used to authenticate to the API server.
# Note that `basic_auth` and `authorization` options are
# mutually exclusive.
# password and password_file are mutually exclusive.

# Optional HTTP basic authentication information, required when role is robot
# Role hcloud does not support basic auth.
basic_auth:
  [ username: <string> ]
  [ password: <secret> ]
  [ password_file: <string> ]

# Optional `Authorization` header configuration, required when role is
# hcloud. Role robot does not support bearer token authentication.
authorization:
  # Sets the authentication type.
  [ type: <string> | default: Bearer ]
  # Sets the credentials. It is mutually exclusive with
  # `credentials_file`.
  [ credentials: <secret> ]
  # Sets the credentials to the credentials read from the configured file.
  # It is mutually exclusive with `credentials`.
  [ credentials_file: <filename> ]

# Optional OAuth 2.0 configuration.
# Cannot be used at the same time as basic_auth or authorization.
oauth2:
  [ <oauth2> ]

# Optional proxy URL.
[ proxy_url: <string> ]
# Comma-separated string that can contain IPs, CIDR notation, domain names
# that should be excluded from proxying. IP and domain names can
# contain port numbers.
[ no_proxy: <string> ]
# Use proxy URL indicated by environment variables (HTTP_PROXY, https_proxy, HTTPs_PROXY, https_proxy, and no_proxy)
[ proxy_from_environment: <bool> | default: false ]
# Specifies headers to send to proxies during CONNECT requests.
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]

# Configure whether HTTP requests follow HTTP 3xx redirects.
[ follow_redirects: <boolean> | default = true ]

# Whether to enable HTTP2.
[ enable_http2: <bool> | default: true ]

# TLS configuration.
tls_config:
  [ <tls_config> ]

# The port to scrape metrics from.
[ port: <int> | default = 80 ]

# The time after which the servers are refreshed.
[ refresh_interval: <duration> | default = 60s ]
```

### `<http_sd_config>`

HTTP-based service discovery provides a more generic way to configure static targets and serves as an interface to plug in custom service discovery mechanisms.

It fetches targets from an HTTP endpoint containing a list of zero or more `<static_config>`s. The target must reply with an HTTP 200 response. The HTTP header `Content-Type` must be `application/json`, and the body must be valid JSON.

Example response body:

```
[
  {
    "targets": [ "<host>", ... ],
    "labels": {
      "<labelname>": "<labelvalue>", ...
    }
  },
  ...
]
```

The endpoint is queried periodically at the specified refresh interval. The `prometheus_sd_http_failures_total` counter metric tracks the number of refresh failures.

Each target has a meta label `__meta_url` during the [relabeling phase](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config). Its value is set to the URL from which the target was extracted.

```
# URL from which the targets are fetched.
url: <string>

# Refresh interval to re-query the endpoint.
[ refresh_interval: <duration> | default = 60s ]

# Authentication information used to authenticate to the API server.
# Note that `basic_auth`, `authorization` and `oauth2` options are
# mutually exclusive.
# `password` and `password_file` are mutually exclusive.

# Optional HTTP basic authentication information.
basic_auth:
  [ username: <string> ]
  [ password: <secret> ]
  [ password_file: <string> ]

# Optional `Authorization` header configuration.
authorization:
  # Sets the authentication type.
  [ type: <string> | default: Bearer ]
  # Sets the credentials. It is mutually exclusive with
  # `credentials_file`.
  [ credentials: <secret> ]
  # Sets the credentials to the credentials read from the configured file.
  # It is mutually exclusive with `credentials`.
  [ credentials_file: <filename> ]

# Optional OAuth 2.0 configuration.
oauth2:
  [ <oauth2> ]

# Optional proxy URL.
[ proxy_url: <string> ]
# Comma-separated string that can contain IPs, CIDR notation, domain names
# that should be excluded from proxying. IP and domain names can
# contain port numbers.
[ no_proxy: <string> ]
# Use proxy URL indicated by environment variables (HTTP_PROXY, https_proxy, HTTPs_PROXY, https_proxy, and no_proxy)
[ proxy_from_environment: <bool> | default: false ]
# Specifies headers to send to proxies during CONNECT requests.
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]

# Configure whether HTTP requests follow HTTP 3xx redirects.
[ follow_redirects: <boolean> | default = true ]

# Whether to enable HTTP2.
[ enable_http2: <bool> | default: true ]

# TLS configuration.
tls_config:
  [ <tls_config> ]
```

### `<ionos_sd_config>`

IONOS SD configurations allows retrieving scrape targets from [IONOS Cloud](https://cloud.ionos.com/) API. This service discovery uses the first NICs IP address by default, but that can be changed with relabeling. The following meta labels are available on all targets during [relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config):

- `__meta_ionos_server_availability_zone`: the availability zone of the server
- `__meta_ionos_server_boot_cdrom_id`: the ID of the CD-ROM the server is booted from
- `__meta_ionos_server_boot_image_id`: the ID of the boot image or snapshot the server is booted from
- `__meta_ionos_server_boot_volume_id`: the ID of the boot volume
- `__meta_ionos_server_cpu_family`: the CPU family of the server to
- `__meta_ionos_server_id`: the ID of the server
- `__meta_ionos_server_ip`: comma separated list of all IPs assigned to the server
- `__meta_ionos_server_lifecycle`: the lifecycle state of the server resource
- `__meta_ionos_server_name`: the name of the server
- `__meta_ionos_server_nic_ip_<nic_name>`: comma separated list of IPs, grouped by the name of each NIC attached to the server
- `__meta_ionos_server_servers_id`: the ID of the servers the server belongs to
- `__meta_ionos_server_state`: the execution state of the server
- `__meta_ionos_server_type`: the type of the server

```
# The unique ID of the data center.
datacenter_id: <string>

# Authentication information used to authenticate to the API server.
# Note that `basic_auth` and `authorization` options are
# mutually exclusive.
# password and password_file are mutually exclusive.

# Optional HTTP basic authentication information, required when using IONOS
# Cloud username and password as authentication method.
basic_auth:
  [ username: <string> ]
  [ password: <secret> ]
  [ password_file: <string> ]

# Optional `Authorization` header configuration, required when using IONOS
# Cloud token as authentication method.
authorization:
  # Sets the authentication type.
  [ type: <string> | default: Bearer ]
  # Sets the credentials. It is mutually exclusive with
  # `credentials_file`.
  [ credentials: <secret> ]
  # Sets the credentials to the credentials read from the configured file.
  # It is mutually exclusive with `credentials`.
  [ credentials_file: <filename> ]

# Optional OAuth 2.0 configuration.
# Cannot be used at the same time as basic_auth or authorization.
oauth2:
  [ <oauth2> ]

# Optional proxy URL.
[ proxy_url: <string> ]
# Comma-separated string that can contain IPs, CIDR notation, domain names
# that should be excluded from proxying. IP and domain names can
# contain port numbers.
[ no_proxy: <string> ]
# Use proxy URL indicated by environment variables (HTTP_PROXY, https_proxy, HTTPs_PROXY, https_proxy, and no_proxy)
[ proxy_from_environment: <bool> | default: false ]
# Specifies headers to send to proxies during CONNECT requests.
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]

# Configure whether HTTP requests follow HTTP 3xx redirects.
[ follow_redirects: <boolean> | default = true ]

# Whether to enable HTTP2.
[ enable_http2: <bool> | default: true ]

# TLS configuration.
tls_config:
  [ <tls_config> ]

# The port to scrape metrics from.
[ port: <int> | default = 80 ]

# The time after which the servers are refreshed.
[ refresh_interval: <duration> | default = 60s ]
```

### `<kubernetes_sd_config>`

Kubernetes SD configurations allow retrieving scrape targets from [Kubernetes'](https://kubernetes.io/) REST API and always staying synchronized with the cluster state.

One of the following `role` types can be configured to discover targets:

#### `node`

The `node` role discovers one target per cluster node with the address defaulting to the Kubelet's HTTP port. The target address defaults to the first existing address of the Kubernetes node object in the address type order of `NodeInternalIP`, `NodeExternalIP`, `NodeLegacyHostIP`, and `NodeHostName`.

Available meta labels:

- `__meta_kubernetes_node_name`: The name of the node object.
- `__meta_kubernetes_node_provider_id`: The cloud provider's name for the node object.
- `__meta_kubernetes_node_label_<labelname>`: Each label from the node object.
- `__meta_kubernetes_node_labelpresent_<labelname>`: `true` for each label from the node object.
- `__meta_kubernetes_node_annotation_<annotationname>`: Each annotation from the node object.
- `__meta_kubernetes_node_annotationpresent_<annotationname>`: `true` for each annotation from the node object.
- `__meta_kubernetes_node_address_<address_type>`: The first address for each node address type, if it exists.

In addition, the `instance` label for the node will be set to the node name as retrieved from the API server.

#### `service`

The `service` role discovers a target for each service port for each service. This is generally useful for blackbox monitoring of a service. The address will be set to the Kubernetes DNS name of the service and respective service port.

Available meta labels:

- `__meta_kubernetes_namespace`: The namespace of the service object.
- `__meta_kubernetes_service_annotation_<annotationname>`: Each annotation from the service object.
- `__meta_kubernetes_service_annotationpresent_<annotationname>`: "true" for each annotation of the service object.
- `__meta_kubernetes_service_cluster_ip`: The cluster IP address of the service. (Does not apply to services of type ExternalName)
- `__meta_kubernetes_service_loadbalancer_ip`: The IP address of the loadbalancer. (Applies to services of type LoadBalancer)
- `__meta_kubernetes_service_external_name`: The DNS name of the service. (Applies to services of type ExternalName)
- `__meta_kubernetes_service_label_<labelname>`: Each label from the service object.
- `__meta_kubernetes_service_labelpresent_<labelname>`: `true` for each label of the service object.
- `__meta_kubernetes_service_name`: The name of the service object.
- `__meta_kubernetes_service_port_name`: Name of the service port for the target.
- `__meta_kubernetes_service_port_number`: Number of the service port for the target.
- `__meta_kubernetes_service_port_protocol`: Protocol of the service port for the target.
- `__meta_kubernetes_service_type`: The type of the service.

#### `pod`

The `pod` role discovers all pods and exposes their containers as targets. For each declared port of a container, a single target is generated. If a container has no specified ports, a port-free target per container is created for manually adding a port via relabeling.

Available meta labels:

- `__meta_kubernetes_namespace`: The namespace of the pod object.
- `__meta_kubernetes_pod_name`: The name of the pod object.
- `__meta_kubernetes_pod_ip`: The pod IP of the pod object.
- `__meta_kubernetes_pod_label_<labelname>`: Each label from the pod object.
- `__meta_kubernetes_pod_labelpresent_<labelname>`: `true` for each label from the pod object.
- `__meta_kubernetes_pod_annotation_<annotationname>`: Each annotation from the pod object.
- `__meta_kubernetes_pod_annotationpresent_<annotationname>`: `true` for each annotation from the pod object.
- `__meta_kubernetes_pod_container_init`: `true` if the container is an [InitContainer](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)
- `__meta_kubernetes_pod_container_name`: Name of the container the target address points to.
- `__meta_kubernetes_pod_container_id`: ID of the container the target address points to. The ID is in the form `<type>://<container_id>`.
- `__meta_kubernetes_pod_container_image`: The image the container is using.
- `__meta_kubernetes_pod_container_port_name`: Name of the container port.
- `__meta_kubernetes_pod_container_port_number`: Number of the container port.
- `__meta_kubernetes_pod_container_port_protocol`: Protocol of the container port.
- `__meta_kubernetes_pod_ready`: Set to `true` or `false` for the pod's ready state.
- `__meta_kubernetes_pod_phase`: Set to `Pending`, `Running`, `Succeeded`, `Failed` or `Unknown` in the [lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#pod-phase).
- `__meta_kubernetes_pod_node_name`: The name of the node the pod is scheduled onto.
- `__meta_kubernetes_pod_host_ip`: The current host IP of the pod object.
- `__meta_kubernetes_pod_uid`: The UID of the pod object.
- `__meta_kubernetes_pod_controller_kind`: Object kind of the pod controller.
- `__meta_kubernetes_pod_controller_name`: Name of the pod controller.

#### `endpoints`

The `endpoints` role discovers targets from listed endpoints of a service. For each endpoint address one target is discovered per port. If the endpoint is backed by a pod, all additional container ports of the pod, not bound to an endpoint port, are discovered as targets as well.

Available meta labels:

- `__meta_kubernetes_namespace`: The namespace of the endpoints object.
- `__meta_kubernetes_endpoints_name`: The names of the endpoints object.
- `__meta_kubernetes_endpoints_label_<labelname>`: Each label from the endpoints object.
- `__meta_kubernetes_endpoints_labelpresent_<labelname>`: `true` for each label from the endpoints object.
- For all targets discovered directly from the endpoints list (those not additionally inferred from underlying pods), the following labels are attached:
  - `__meta_kubernetes_endpoint_hostname`: Hostname of the endpoint.
  - `__meta_kubernetes_endpoint_node_name`: Name of the node hosting the endpoint.
  - `__meta_kubernetes_endpoint_ready`: Set to `true` or `false` for the endpoint's ready state.
  - `__meta_kubernetes_endpoint_port_name`: Name of the endpoint port.
  - `__meta_kubernetes_endpoint_port_protocol`: Protocol of the endpoint port.
  - `__meta_kubernetes_endpoint_address_target_kind`: Kind of the endpoint address target.
  - `__meta_kubernetes_endpoint_address_target_name`: Name of the endpoint address target.
- If the endpoints belong to a service, all labels of the `role: service` discovery are attached.
- For all targets backed by a pod, all labels of the `role: pod` discovery are attached.

#### `endpointslice`

The `endpointslice` role discovers targets from existing endpointslices. For each endpoint address referenced in the endpointslice object one target is discovered. If the endpoint is backed by a pod, all additional container ports of the pod, not bound to an endpoint port, are discovered as targets as well.

Available meta labels:

- `__meta_kubernetes_namespace`: The namespace of the endpoints object.
- `__meta_kubernetes_endpointslice_name`: The name of endpointslice object.
- For all targets discovered directly from the endpointslice list (those not additionally inferred from underlying pods), the following labels are attached:
  - `__meta_kubernetes_endpointslice_address_target_kind`: Kind of the referenced object.
  - `__meta_kubernetes_endpointslice_address_target_name`: Name of referenced object.
  - `__meta_kubernetes_endpointslice_address_type`: The ip protocol family of the address of the target.
  - `__meta_kubernetes_endpointslice_endpoint_conditions_ready`:  Set to `true` or `false` for the referenced endpoint's ready state.
  - `__meta_kubernetes_endpointslice_endpoint_conditions_serving`:  Set to `true` or `false` for the referenced endpoint's serving state.
  - `__meta_kubernetes_endpointslice_endpoint_conditions_terminating`:  Set to `true` or `false` for the referenced endpoint's terminating state.
  - `__meta_kubernetes_endpointslice_endpoint_topology_kubernetes_io_hostname`:  Name of the node hosting the referenced endpoint.
  - `__meta_kubernetes_endpointslice_endpoint_topology_present_kubernetes_io_hostname`: Flag that shows if the referenced object has a kubernetes.io/hostname annotation.
  - `__meta_kubernetes_endpointslice_port`: Port of the referenced endpoint.
  - `__meta_kubernetes_endpointslice_port_name`: Named port of the referenced endpoint.
  - `__meta_kubernetes_endpointslice_port_protocol`: Protocol of the referenced endpoint.
- If the endpoints belong to a service, all labels of the `role: service` discovery are attached.
- For all targets backed by a pod, all labels of the `role: pod` discovery are attached.

#### `ingress`

The `ingress` role discovers a target for each path of each ingress. This is generally useful for blackbox monitoring of an ingress. The address will be set to the host specified in the ingress spec.

Available meta labels:

- `__meta_kubernetes_namespace`: The namespace of the ingress object.
- `__meta_kubernetes_ingress_name`: The name of the ingress object.
- `__meta_kubernetes_ingress_label_<labelname>`: Each label from the ingress object.
- `__meta_kubernetes_ingress_labelpresent_<labelname>`: `true` for each label from the ingress object.
- `__meta_kubernetes_ingress_annotation_<annotationname>`: Each annotation from the ingress object.
- `__meta_kubernetes_ingress_annotationpresent_<annotationname>`: `true` for each annotation from the ingress object.
- `__meta_kubernetes_ingress_class_name`: Class name from ingress spec, if present.
- `__meta_kubernetes_ingress_scheme`: Protocol scheme of ingress, `https` if TLS config is set. Defaults to `http`.
- `__meta_kubernetes_ingress_path`: Path from ingress spec. Defaults to `/`.

See below for the configuration options for Kubernetes discovery:

```
# The information to access the Kubernetes API.

# The API server addresses. If left empty, Prometheus is assumed to run inside
# of the cluster and will discover API servers automatically and use the pod's
# CA certificate and bearer token file at /var/run/secrets/kubernetes.io/serviceaccount/.
[ api_server: <host> ]

# The Kubernetes role of entities that should be discovered.
# One of endpoints, endpointslice, service, pod, node, or ingress.
role: <string>

# Optional path to a kubeconfig file.
# Note that api_server and kube_config are mutually exclusive.
[ kubeconfig_file: <filename> ]

# Optional authentication information used to authenticate to the API server.
# Note that `basic_auth` and `authorization` options are mutually exclusive.
# password and password_file are mutually exclusive.

# Optional HTTP basic authentication information.
basic_auth:
  [ username: <string> ]
  [ password: <secret> ]
  [ password_file: <string> ]

# Optional `Authorization` header configuration.
authorization:
  # Sets the authentication type.
  [ type: <string> | default: Bearer ]
  # Sets the credentials. It is mutually exclusive with
  # `credentials_file`.
  [ credentials: <secret> ]
  # Sets the credentials to the credentials read from the configured file.
  # It is mutually exclusive with `credentials`.
  [ credentials_file: <filename> ]

# Optional OAuth 2.0 configuration.
# Cannot be used at the same time as basic_auth or authorization.
oauth2:
  [ <oauth2> ]

# Optional proxy URL.
[ proxy_url: <string> ]
# Comma-separated string that can contain IPs, CIDR notation, domain names
# that should be excluded from proxying. IP and domain names can
# contain port numbers.
[ no_proxy: <string> ]
# Use proxy URL indicated by environment variables (HTTP_PROXY, https_proxy, HTTPs_PROXY, https_proxy, and no_proxy)
[ proxy_from_environment: <bool> | default: false ]
# Specifies headers to send to proxies during CONNECT requests.
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]

# Configure whether HTTP requests follow HTTP 3xx redirects.
[ follow_redirects: <boolean> | default = true ]

# Whether to enable HTTP2.
[ enable_http2: <bool> | default: true ]

# TLS configuration.
tls_config:
  [ <tls_config> ]

# Optional namespace discovery. If omitted, all namespaces are used.
namespaces:
  own_namespace: <boolean>
  names:
    [ - <string> ]

# Optional label and field selectors to limit the discovery process to a subset of available resources.
# See https://kubernetes.io/docs/concepts/overview/working-with-objects/field-selectors/
# and https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ to learn more about the possible
# filters that can be used. The endpoints role supports pod, service and endpoints selectors.
# The pod role supports node selectors when configured with `attach_metadata: {node: true}`.
# Other roles only support selectors matching the role itself (e.g. node role can only contain node selectors).

# Note: When making decision about using field/label selector make sure that this
# is the best approach - it will prevent Prometheus from reusing single list/watch
# for all scrape configs. This might result in a bigger load on the Kubernetes API,
# because per each selector combination there will be additional LIST/WATCH. On the other hand,
# if you just want to monitor small subset of pods in large cluster it's recommended to use selectors.
# Decision, if selectors should be used or not depends on the particular situation.
[ selectors:
  [ - role: <string>
    [ label: <string> ]
    [ field: <string> ] ]]

# Optional metadata to attach to discovered targets. If omitted, no additional metadata is attached.
attach_metadata:
# Attaches node metadata to discovered targets. Valid for roles: pod, endpoints, endpointslice.
# When set to true, Prometheus must have permissions to get Nodes.
  [ node: <boolean> | default = false ]
```

See [this example Prometheus configuration file](https://github.com/prometheus/prometheus/blob/release-2.43/documentation/examples/prometheus-kubernetes.yml) for a detailed example of configuring Prometheus for Kubernetes.

You may wish to check out the 3rd party [Prometheus Operator](https://github.com/coreos/prometheus-operator), which automates the Prometheus setup on top of Kubernetes.

### `<kuma_sd_config>`

Kuma SD configurations allow retrieving scrape target from the [Kuma](https://kuma.io) control plane.

This SD discovers "monitoring assignments" based on Kuma [Dataplane Proxies](https://kuma.io/docs/latest/documentation/dps-and-data-model), via the MADS v1 (Monitoring Assignment Discovery Service) xDS API, and will create a target for each proxy inside a Prometheus-enabled mesh.

The following meta labels are available for each target:

- `__meta_kuma_mesh`: the name of the proxy's Mesh
- `__meta_kuma_dataplane`: the name of the proxy
- `__meta_kuma_service`: the name of the proxy's associated Service
- `__meta_kuma_label_<tagname>`: each tag of the proxy

See below for the configuration options for Kuma MonitoringAssignment discovery:

```
# Address of the Kuma Control Plane's MADS xDS server.
server: <string>

# The time to wait between polling update requests.
[ refresh_interval: <duration> | default = 30s ]

# The time after which the monitoring assignments are refreshed.
[ fetch_timeout: <duration> | default = 2m ]

# Optional proxy URL.
[ proxy_url: <string> ]
# Comma-separated string that can contain IPs, CIDR notation, domain names
# that should be excluded from proxying. IP and domain names can
# contain port numbers.
[ no_proxy: <string> ]
# Use proxy URL indicated by environment variables (HTTP_PROXY, https_proxy, HTTPs_PROXY, https_proxy, and no_proxy)
[ proxy_from_environment: <bool> | default: false ]
# Specifies headers to send to proxies during CONNECT requests.
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]

# TLS configuration.
tls_config:
  [ <tls_config> ]

# Authentication information used to authenticate to the Docker daemon.
# Note that `basic_auth` and `authorization` options are
# mutually exclusive.
# password and password_file are mutually exclusive.

# Optional HTTP basic authentication information.
basic_auth:
  [ username: <string> ]
  [ password: <secret> ]
  [ password_file: <string> ]

# Optional the `Authorization` header configuration.
authorization:
  # Sets the authentication type.
  [ type: <string> | default: Bearer ]
  # Sets the credentials. It is mutually exclusive with
  # `credentials_file`.
  [ credentials: <secret> ]
  # Sets the credentials with the credentials read from the configured file.
  # It is mutually exclusive with `credentials`.
  [ credentials_file: <filename> ]

# Optional OAuth 2.0 configuration.
# Cannot be used at the same time as basic_auth or authorization.
oauth2:
  [ <oauth2> ]

# Configure whether HTTP requests follow HTTP 3xx redirects.
[ follow_redirects: <boolean> | default = true ]

# Whether to enable HTTP2.
[ enable_http2: <bool> | default: true ]
```

The [relabeling phase](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config) is the preferred and more powerful way to filter proxies and user-defined tags.

### `<lightsail_sd_config>`

Lightsail SD configurations allow retrieving scrape targets from [AWS Lightsail](https://aws.amazon.com/lightsail/) instances. The private IP address is used by default, but may be changed to the public IP address with relabeling.

The following meta labels are available on targets during [relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config):

- `__meta_lightsail_availability_zone`: the availability zone in which the instance is running
- `__meta_lightsail_blueprint_id`: the Lightsail blueprint ID
- `__meta_lightsail_bundle_id`: the Lightsail bundle ID
- `__meta_lightsail_instance_name`: the name of the Lightsail instance
- `__meta_lightsail_instance_state`: the state of the Lightsail instance
- `__meta_lightsail_instance_support_code`: the support code of the Lightsail instance
- `__meta_lightsail_ipv6_addresses`: comma separated list of IPv6 addresses assigned to the instance's network interfaces, if present
- `__meta_lightsail_private_ip`: the private IP address of the instance
- `__meta_lightsail_public_ip`: the public IP address of the instance, if available
- `__meta_lightsail_region`: the region of the instance
- `__meta_lightsail_tag_<tagkey>`: each tag value of the instance

See below for the configuration options for Lightsail discovery:

```
# The information to access the Lightsail API.

# The AWS region. If blank, the region from the instance metadata is used.
[ region: <string> ]

# Custom endpoint to be used.
[ endpoint: <string> ]

# The AWS API keys. If blank, the environment variables `AWS_ACCESS_KEY_ID`
# and `AWS_SECRET_ACCESS_KEY` are used.
[ access_key: <string> ]
[ secret_key: <secret> ]
# Named AWS profile used to connect to the API.
[ profile: <string> ]

# AWS Role ARN, an alternative to using AWS API keys.
[ role_arn: <string> ]

# Refresh interval to re-read the instance list.
[ refresh_interval: <duration> | default = 60s ]

# The port to scrape metrics from. If using the public IP address, this must
# instead be specified in the relabeling rule.
[ port: <int> | default = 80 ]

# Authentication information used to authenticate to the Lightsail API.
# Note that `basic_auth`, `authorization` and `oauth2` options are
# mutually exclusive.
# `password` and `password_file` are mutually exclusive.

# Optional HTTP basic authentication information, currently not supported by AWS.
basic_auth:
  [ username: <string> ]
  [ password: <secret> ]
  [ password_file: <string> ]

# Optional `Authorization` header configuration, currently not supported by AWS.
authorization:
  # Sets the authentication type.
  [ type: <string> | default: Bearer ]
  # Sets the credentials. It is mutually exclusive with
  # `credentials_file`.
  [ credentials: <secret> ]
  # Sets the credentials to the credentials read from the configured file.
  # It is mutuall exclusive with `credentials`.
  [ credentials_file: <filename> ]

# Optional OAuth 2.0 configuration, currently not supported by AWS.
oauth2:
  [ <oauth2> ]

# Optional proxy URL.
[ proxy_url: <string> ]
# Comma-separated string that can contain IPs, CIDR notation, domain names
# that should be excluded from proxying. IP and domain names can
# contain port numbers.
[ no_proxy: <string> ]
# Use proxy URL indicated by environment variables (HTTP_PROXY, https_proxy, HTTPs_PROXY, https_proxy, and no_proxy)
[ proxy_from_environment: <bool> | default: false ]
# Specifies headers to send to proxies during CONNECT requests.
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]

# Configure whether HTTP requests follow HTTP 3xx redirects.
[ follow_redirects: <boolean> | default = true ]

# Whether to enable HTTP2.
[ enable_http2: <bool> | default: true ]

# TLS configuration.
tls_config:
  [ <tls_config> ]
```

### `<linode_sd_config>`

Linode SD configurations allow retrieving scrape targets from [Linode's](https://www.linode.com/) Linode APIv4. This service discovery uses the public IPv4 address by default, by that can be changed with relabeling, as demonstrated in [the Prometheus linode-sd configuration file](https://github.com/prometheus/prometheus/blob/release-2.43/documentation/examples/prometheus-linode.yml).

The following meta labels are available on targets during [relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config):

- `__meta_linode_instance_id`: the id of the linode instance
- `__meta_linode_instance_label`: the label of the linode instance
- `__meta_linode_image`: the slug of the linode instance's image
- `__meta_linode_private_ipv4`: the private IPv4 of the linode instance
- `__meta_linode_public_ipv4`: the public IPv4 of the linode instance
- `__meta_linode_public_ipv6`: the public IPv6 of the linode instance
- `__meta_linode_region`: the region of the linode instance
- `__meta_linode_type`: the type of the linode instance
- `__meta_linode_status`: the status of the linode instance
- `__meta_linode_tags`: a list of tags of the linode instance joined by the tag separator
- `__meta_linode_group`: the display group a linode instance is a member of
- `__meta_linode_hypervisor`: the virtualization software powering the linode instance
- `__meta_linode_backups`: the backup service status of the linode instance
- `__meta_linode_specs_disk_bytes`: the amount of storage space the linode instance has access to
- `__meta_linode_specs_memory_bytes`: the amount of RAM the linode instance has access to
- `__meta_linode_specs_vcpus`: the number of VCPUS this linode has access to
- `__meta_linode_specs_transfer_bytes`: the amount of network transfer the linode instance is allotted each month
- `__meta_linode_extra_ips`: a list of all extra IPv4 addresses assigned to the linode instance joined by the tag separator

```
# Authentication information used to authenticate to the API server.
# Note that `basic_auth` and `authorization` options are
# mutually exclusive.
# password and password_file are mutually exclusive.
# Note: Linode APIv4 Token must be created with scopes: 'linodes:read_only', 'ips:read_only', and 'events:read_only'

# Optional HTTP basic authentication information, not currently supported by Linode APIv4.
basic_auth:
  [ username: <string> ]
  [ password: <secret> ]
  [ password_file: <string> ]

# Optional the `Authorization` header configuration.
authorization:
  # Sets the authentication type.
  [ type: <string> | default: Bearer ]
  # Sets the credentials. It is mutually exclusive with
  # `credentials_file`.
  [ credentials: <secret> ]
  # Sets the credentials with the credentials read from the configured file.
  # It is mutually exclusive with `credentials`.
  [ credentials_file: <filename> ]

# Optional OAuth 2.0 configuration.
# Cannot be used at the same time as basic_auth or authorization.
oauth2:
  [ <oauth2> ]

# Optional proxy URL.
[ proxy_url: <string> ]
# Comma-separated string that can contain IPs, CIDR notation, domain names
# that should be excluded from proxying. IP and domain names can
# contain port numbers.
[ no_proxy: <string> ]
# Use proxy URL indicated by environment variables (HTTP_PROXY, https_proxy, HTTPs_PROXY, https_proxy, and no_proxy)
[ proxy_from_environment: <bool> | default: false ]
# Specifies headers to send to proxies during CONNECT requests.
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]

# Configure whether HTTP requests follow HTTP 3xx redirects.
[ follow_redirects: <boolean> | default = true ]

# Whether to enable HTTP2.
[ enable_http2: <bool> | default: true ]

# TLS configuration.
tls_config:
  [ <tls_config> ]

# The port to scrape metrics from.
[ port: <int> | default = 80 ]

# The string by which Linode Instance tags are joined into the tag label.
[ tag_separator: <string> | default = , ]

# The time after which the linode instances are refreshed.
[ refresh_interval: <duration> | default = 60s ]
```

### `<marathon_sd_config>`

Marathon SD configurations allow retrieving scrape targets using the [Marathon](https://mesosphere.github.io/marathon/) REST API. Prometheus will periodically check the REST endpoint for currently running tasks and create a target group for every app that has at least one healthy task.

The following meta labels are available on targets during [relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config):

- `__meta_marathon_app`: the name of the app (with slashes replaced by dashes)
- `__meta_marathon_image`: the name of the Docker image used (if available)
- `__meta_marathon_task`: the ID of the Mesos task
- `__meta_marathon_app_label_<labelname>`: any Marathon labels attached to the app
- `__meta_marathon_port_definition_label_<labelname>`: the port definition labels
- `__meta_marathon_port_mapping_label_<labelname>`: the port mapping labels
- `__meta_marathon_port_index`: the port index number (e.g. `1` for `PORT1`)

See below for the configuration options for Marathon discovery:

```
# List of URLs to be used to contact Marathon servers.
# You need to provide at least one server URL.
servers:
  - <string>

# Polling interval
[ refresh_interval: <duration> | default = 30s ]

# Optional authentication information for token-based authentication
# https://docs.mesosphere.com/1.11/security/ent/iam-api/#passing-an-authentication-token
# It is mutually exclusive with `auth_token_file` and other authentication mechanisms.
[ auth_token: <secret> ]

# Optional authentication information for token-based authentication
# https://docs.mesosphere.com/1.11/security/ent/iam-api/#passing-an-authentication-token
# It is mutually exclusive with `auth_token` and other authentication mechanisms.
[ auth_token_file: <filename> ]

# Sets the `Authorization` header on every request with the
# configured username and password.
# This is mutually exclusive with other authentication mechanisms.
# password and password_file are mutually exclusive.
basic_auth:
  [ username: <string> ]
  [ password: <secret> ]
  [ password_file: <string> ]

# Optional `Authorization` header configuration.
# NOTE: The current version of DC/OS marathon (v1.11.0) does not support
# standard `Authentication` header, use `auth_token` or `auth_token_file`
# instead.
authorization:
  # Sets the authentication type.
  [ type: <string> | default: Bearer ]
  # Sets the credentials. It is mutually exclusive with
  # `credentials_file`.
  [ credentials: <secret> ]
  # Sets the credentials to the credentials read from the configured file.
  # It is mutually exclusive with `credentials`.
  [ credentials_file: <filename> ]

# Optional OAuth 2.0 configuration.
# Cannot be used at the same time as basic_auth or authorization.
oauth2:
  [ <oauth2> ]

# Configure whether HTTP requests follow HTTP 3xx redirects.
[ follow_redirects: <boolean> | default = true ]

# Whether to enable HTTP2.
[ enable_http2: <bool> | default: true ]

# TLS configuration for connecting to marathon servers
tls_config:
  [ <tls_config> ]

# Optional proxy URL.
[ proxy_url: <string> ]
# Comma-separated string that can contain IPs, CIDR notation, domain names
# that should be excluded from proxying. IP and domain names can
# contain port numbers.
[ no_proxy: <string> ]
# Use proxy URL indicated by environment variables (HTTP_PROXY, https_proxy, HTTPs_PROXY, https_proxy, and no_proxy)
[ proxy_from_environment: <bool> | default: false ]
# Specifies headers to send to proxies during CONNECT requests.
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]
```

By default every app listed in Marathon will be scraped by Prometheus. If not all of your services provide Prometheus metrics, you can use a Marathon label and Prometheus relabeling to control which instances will actually be scraped. See [the Prometheus marathon-sd configuration file](https://github.com/prometheus/prometheus/blob/release-2.43/documentation/examples/prometheus-marathon.yml) for a practical example on how to set up your Marathon app and your Prometheus configuration.

By default, all apps will show up as a single job in Prometheus (the one specified in the configuration file), which can also be changed using relabeling.

### `<nerve_sd_config>`

Nerve SD configurations allow retrieving scrape targets from [AirBnB's Nerve](https://github.com/airbnb/nerve) which are stored in [Zookeeper](https://zookeeper.apache.org/).

The following meta labels are available on targets during [relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config):

- `__meta_nerve_path`: the full path to the endpoint node in Zookeeper
- `__meta_nerve_endpoint_host`: the host of the endpoint
- `__meta_nerve_endpoint_port`: the port of the endpoint
- `__meta_nerve_endpoint_name`: the name of the endpoint

```
# The Zookeeper servers.
servers:
  - <host>
# Paths can point to a single service, or the root of a tree of services.
paths:
  - <string>
[ timeout: <duration> | default = 10s ]
```

### `<nomad_sd_config>`

Nomad SD configurations allow retrieving scrape targets from [Nomad's](https://www.nomadproject.io/) Service API.

The following meta labels are available on targets during [relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config):

- `__meta_nomad_address`: the service address of the target
- `__meta_nomad_dc`: the datacenter name for the target
- `__meta_nomad_namespace`: the namespace of the target
- `__meta_nomad_node_id`: the node name defined for the target
- `__meta_nomad_service`: the name of the service the target belongs to
- `__meta_nomad_service_address`: the service address of the target
- `__meta_nomad_service_id`: the service ID of the target
- `__meta_nomad_service_port`: the service port of the target
- `__meta_nomad_tags`: the list of tags of the target joined by the tag separator

```
# The information to access the Nomad API. It is to be defined
# as the Nomad documentation requires.
[ allow_stale: <boolean> | default = true ]
[ namespace: <string> | default = default ]
[ refresh_interval: <duration> | default = 60s ]
[ region: <string> | default = global ]
[ server: <host> ]
[ tag_separator: <string> | default = ,]

# Authentication information used to authenticate to the nomad server.
# Note that `basic_auth`, `authorization` and `oauth2` options are
# mutually exclusive.
# `password` and `password_file` are mutually exclusive.

# Optional HTTP basic authentication information.
basic_auth:
  [ username: <string> ]
  [ password: <secret> ]
  [ password_file: <string> ]

# Optional `Authorization` header configuration.
authorization:
  # Sets the authentication type.
  [ type: <string> | default: Bearer ]
  # Sets the credentials. It is mutually exclusive with
  # `credentials_file`.
  [ credentials: <secret> ]
  # Sets the credentials to the credentials read from the configured file.
  # It is mutually exclusive with `credentials`.
  [ credentials_file: <filename> ]

# Optional OAuth 2.0 configuration.
oauth2:
  [ <oauth2> ]

# Optional proxy URL.
[ proxy_url: <string> ]
# Comma-separated string that can contain IPs, CIDR notation, domain names
# that should be excluded from proxying. IP and domain names can
# contain port numbers.
[ no_proxy: <string> ]
# Use proxy URL indicated by environment variables (HTTP_PROXY, https_proxy, HTTPs_PROXY, https_proxy, and no_proxy)
[ proxy_from_environment: <bool> | default: false ]
# Specifies headers to send to proxies during CONNECT requests.
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]

# Configure whether HTTP requests follow HTTP 3xx redirects.
[ follow_redirects: <boolean> | default = true ]

# Whether to enable HTTP2.
[ enable_http2: <bool> | default: true ]

# TLS configuration.
tls_config:
  [ <tls_config> ]
```

### `<serverset_sd_config>`

Serverset SD configurations allow retrieving scrape targets from [Serversets](https://github.com/twitter/finagle/tree/develop/finagle-serversets) which are stored in [Zookeeper](https://zookeeper.apache.org/). Serversets are commonly used by [Finagle](https://twitter.github.io/finagle/) and [Aurora](https://aurora.apache.org/).

The following meta labels are available on targets during [relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config):

- `__meta_serverset_path`: the full path to the serverset member node in Zookeeper
- `__meta_serverset_endpoint_host`: the host of the default endpoint
- `__meta_serverset_endpoint_port`: the port of the default endpoint
- `__meta_serverset_endpoint_host_<endpoint>`: the host of the given endpoint
- `__meta_serverset_endpoint_port_<endpoint>`: the port of the given endpoint
- `__meta_serverset_shard`: the shard number of the member
- `__meta_serverset_status`: the status of the member

```
# The Zookeeper servers.
servers:
  - <host>
# Paths can point to a single serverset, or the root of a tree of serversets.
paths:
  - <string>
[ timeout: <duration> | default = 10s ]
```

Serverset data must be in the JSON format, the Thrift format is not currently supported.

### `<triton_sd_config>`

[Triton](https://github.com/joyent/triton) SD configurations allow retrieving scrape targets from [Container Monitor](https://github.com/joyent/rfd/blob/master/rfd/0027/README.md) discovery endpoints.

One of the following `<triton_role>` types can be configured to discover targets:

#### `container`

The `container` role discovers one target per "virtual machine" owned by the `account`. These are SmartOS zones or lx/KVM/bhyve branded zones.

The following meta labels are available on targets during [relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config):

- `__meta_triton_groups`: the list of groups belonging to the target joined by a comma separator
- `__meta_triton_machine_alias`: the alias of the target container
- `__meta_triton_machine_brand`: the brand of the target container
- `__meta_triton_machine_id`: the UUID of the target container
- `__meta_triton_machine_image`: the target container's image type
- `__meta_triton_server_id`: the server UUID the target container is running on

#### `cn`

The `cn` role discovers one target for per compute node (also known as "server" or "global zone") making up the Triton infrastructure. The `account` must be a Triton operator and is currently required to own at least one `container`.

The following meta labels are available on targets during [relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config):

- `__meta_triton_machine_alias`: the hostname of the target (requires triton-cmon 1.7.0 or newer)
- `__meta_triton_machine_id`: the UUID of the target

See below for the configuration options for Triton discovery:

```
# The information to access the Triton discovery API.

# The account to use for discovering new targets.
account: <string>

# The type of targets to discover, can be set to:
# * "container" to discover virtual machines (SmartOS zones, lx/KVM/bhyve branded zones) running on Triton
# * "cn" to discover compute nodes (servers/global zones) making up the Triton infrastructure
[ role : <string> | default = "container" ]

# The DNS suffix which should be applied to target.
dns_suffix: <string>

# The Triton discovery endpoint (e.g. 'cmon.us-east-3b.triton.zone'). This is
# often the same value as dns_suffix.
endpoint: <string>

# A list of groups for which targets are retrieved, only supported when `role` == `container`.
# If omitted all containers owned by the requesting account are scraped.
groups:
  [ - <string> ... ]

# The port to use for discovery and metric scraping.
[ port: <int> | default = 9163 ]

# The interval which should be used for refreshing targets.
[ refresh_interval: <duration> | default = 60s ]

# The Triton discovery API version.
[ version: <int> | default = 1 ]

# TLS configuration.
tls_config:
  [ <tls_config> ]
```

### `<eureka_sd_config>`

Eureka SD configurations allow retrieving scrape targets using the [Eureka](https://github.com/Netflix/eureka) REST API. Prometheus will periodically check the REST endpoint and create a target for every app instance.

The following meta labels are available on targets during [relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config):

- `__meta_eureka_app_name`: the name of the app
- `__meta_eureka_app_instance_id`: the ID of the app instance
- `__meta_eureka_app_instance_hostname`: the hostname of the instance
- `__meta_eureka_app_instance_homepage_url`: the homepage url of the app instance
- `__meta_eureka_app_instance_statuspage_url`: the status page url of the app instance
- `__meta_eureka_app_instance_healthcheck_url`: the health check url of the app instance
- `__meta_eureka_app_instance_ip_addr`: the IP address of the app instance
- `__meta_eureka_app_instance_vip_address`: the VIP address of the app instance
- `__meta_eureka_app_instance_secure_vip_address`: the secure VIP address of the app instance
- `__meta_eureka_app_instance_status`: the status of the app instance
- `__meta_eureka_app_instance_port`: the port of the app instance
- `__meta_eureka_app_instance_port_enabled`: the port enabled of the app instance
- `__meta_eureka_app_instance_secure_port`: the secure port address of the app instance
- `__meta_eureka_app_instance_secure_port_enabled`: the secure port of the app instance
- `__meta_eureka_app_instance_country_id`: the country ID of the app instance
- `__meta_eureka_app_instance_metadata_<metadataname>`: app instance metadata
- `__meta_eureka_app_instance_datacenterinfo_name`: the datacenter name of the app instance
- `__meta_eureka_app_instance_datacenterinfo_<metadataname>`: the datacenter metadata

See below for the configuration options for Eureka discovery:

```
# The URL to connect to the Eureka server.
server: <string>

# Sets the `Authorization` header on every request with the
# configured username and password.
# password and password_file are mutually exclusive.
basic_auth:
  [ username: <string> ]
  [ password: <secret> ]
  [ password_file: <string> ]

# Optional `Authorization` header configuration.
authorization:
  # Sets the authentication type.
  [ type: <string> | default: Bearer ]
  # Sets the credentials. It is mutually exclusive with
  # `credentials_file`.
  [ credentials: <secret> ]
  # Sets the credentials to the credentials read from the configured file.
  # It is mutually exclusive with `credentials`.
  [ credentials_file: <filename> ]

# Optional OAuth 2.0 configuration.
# Cannot be used at the same time as basic_auth or authorization.
oauth2:
  [ <oauth2> ]

# Configures the scrape request's TLS settings.
tls_config:
  [ <tls_config> ]

# Optional proxy URL.
[ proxy_url: <string> ]
# Comma-separated string that can contain IPs, CIDR notation, domain names
# that should be excluded from proxying. IP and domain names can
# contain port numbers.
[ no_proxy: <string> ]
# Use proxy URL indicated by environment variables (HTTP_PROXY, https_proxy, HTTPs_PROXY, https_proxy, and no_proxy)
[ proxy_from_environment: <bool> | default: false ]
# Specifies headers to send to proxies during CONNECT requests.
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]

# Configure whether HTTP requests follow HTTP 3xx redirects.
[ follow_redirects: <boolean> | default = true ]

# Whether to enable HTTP2.
[ enable_http2: <bool> | default: true ]

# Refresh interval to re-read the app instance list.
[ refresh_interval: <duration> | default = 30s ]
```

See [the Prometheus eureka-sd configuration file](https://github.com/prometheus/prometheus/blob/release-2.43/documentation/examples/prometheus-eureka.yml) for a practical example on how to set up your Eureka app and your Prometheus configuration.

### `<scaleway_sd_config>`

Scaleway SD configurations allow retrieving scrape targets from [Scaleway instances](https://www.scaleway.com/en/virtual-instances/) and [baremetal services](https://www.scaleway.com/en/bare-metal-servers/).

The following meta labels are available on targets during [relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config):

#### Instance role

- `__meta_scaleway_instance_boot_type`: the boot type of the server
- `__meta_scaleway_instance_hostname`: the hostname of the server
- `__meta_scaleway_instance_id`: the ID of the server
- `__meta_scaleway_instance_image_arch`: the arch of the server image
- `__meta_scaleway_instance_image_id`: the ID of the server image
- `__meta_scaleway_instance_image_name`: the name of the server image
- `__meta_scaleway_instance_location_cluster_id`: the cluster ID of the server location
- `__meta_scaleway_instance_location_hypervisor_id`: the hypervisor ID of the server location
- `__meta_scaleway_instance_location_node_id`: the node ID of the server location
- `__meta_scaleway_instance_name`: name of the server
- `__meta_scaleway_instance_organization_id`: the organization of the server
- `__meta_scaleway_instance_private_ipv4`: the private IPv4 address of the server
- `__meta_scaleway_instance_project_id`: project id of the server
- `__meta_scaleway_instance_public_ipv4`: the public IPv4 address of the server
- `__meta_scaleway_instance_public_ipv6`: the public IPv6 address of the server
- `__meta_scaleway_instance_region`: the region of the server
- `__meta_scaleway_instance_security_group_id`: the ID of the security group of the server
- `__meta_scaleway_instance_security_group_name`: the name of the security group of the server
- `__meta_scaleway_instance_status`: status of the server
- `__meta_scaleway_instance_tags`: the list of tags of the server joined by the tag separator
- `__meta_scaleway_instance_type`: commercial type of the server
- `__meta_scaleway_instance_zone`: the zone of the server (ex: `fr-par-1`, complete list [here](https://developers.scaleway.com/en/products/instance/api/#introduction))

This role uses the private IPv4 address by default. This can be changed with relabeling, as demonstrated in [the Prometheus scaleway-sd configuration file](https://github.com/prometheus/prometheus/blob/release-2.43/documentation/examples/prometheus-scaleway.yml).

#### Baremetal role

- `__meta_scaleway_baremetal_id`: the ID of the server
- `__meta_scaleway_baremetal_public_ipv4`: the public IPv4 address of the server
- `__meta_scaleway_baremetal_public_ipv6`: the public IPv6 address of the server
- `__meta_scaleway_baremetal_name`: the name of the server
- `__meta_scaleway_baremetal_os_name`: the name of the operating system of the server
- `__meta_scaleway_baremetal_os_version`: the version of the operating system of the server
- `__meta_scaleway_baremetal_project_id`: the project ID of the server
- `__meta_scaleway_baremetal_status`: the status of the server
- `__meta_scaleway_baremetal_tags`: the list of tags of the server joined by the tag separator
- `__meta_scaleway_baremetal_type`: the commercial type of the server
- `__meta_scaleway_baremetal_zone`: the zone of the server (ex: `fr-par-1`, complete list [here](https://developers.scaleway.com/en/products/instance/api/#introduction))

This role uses the public IPv4 address by default. This can be changed with relabeling, as demonstrated in [the Prometheus scaleway-sd configuration file](https://github.com/prometheus/prometheus/blob/release-2.43/documentation/examples/prometheus-scaleway.yml).

See below for the configuration options for Scaleway discovery:

```
# Access key to use. https://console.scaleway.com/project/credentials
access_key: <string>

# Secret key to use when listing targets. https://console.scaleway.com/project/credentials
# It is mutually exclusive with `secret_key_file`.
[ secret_key: <secret> ]

# Sets the secret key with the credentials read from the configured file.
# It is mutually exclusive with `secret_key`.
[ secret_key_file: <filename> ]

# Project ID of the targets.
project_id: <string>

# Role of the targets to retrieve. Must be `instance` or `baremetal`.
role: <string>

# The port to scrape metrics from.
[ port: <int> | default = 80 ]

# API URL to use when doing the server listing requests.
[ api_url: <string> | default = "https://api.scaleway.com" ]

# Zone is the availability zone of your targets (e.g. fr-par-1).
[ zone: <string> | default = fr-par-1 ]

# NameFilter specify a name filter (works as a LIKE) to apply on the server listing request.
[ name_filter: <string> ]

# TagsFilter specify a tag filter (a server needs to have all defined tags to be listed) to apply on the server listing request.
tags_filter:
[ - <string> ]

# Refresh interval to re-read the targets list.
[ refresh_interval: <duration> | default = 60s ]

# Configure whether HTTP requests follow HTTP 3xx redirects.
[ follow_redirects: <boolean> | default = true ]

# Whether to enable HTTP2.
[ enable_http2: <bool> | default: true ]

# Optional proxy URL.
[ proxy_url: <string> ]
# Comma-separated string that can contain IPs, CIDR notation, domain names
# that should be excluded from proxying. IP and domain names can
# contain port numbers.
[ no_proxy: <string> ]
# Use proxy URL indicated by environment variables (HTTP_PROXY, https_proxy, HTTPs_PROXY, https_proxy, and no_proxy)
[ proxy_from_environment: <bool> | default: false ]
# Specifies headers to send to proxies during CONNECT requests.
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]

# TLS configuration.
tls_config:
  [ <tls_config> ]
```

### `<uyuni_sd_config>`

Uyuni SD configurations allow retrieving scrape targets from managed systems via [Uyuni](https://www.uyuni-project.org/) API.

The following meta labels are available on targets during [relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config):

- `__meta_uyuni_endpoint_name`: the name of the application endpoint
- `__meta_uyuni_exporter`: the exporter exposing metrics for the target
- `__meta_uyuni_groups`: the system groups of the target
- `__meta_uyuni_metrics_path`: metrics path for the target
- `__meta_uyuni_minion_hostname`: hostname of the Uyuni client
- `__meta_uyuni_primary_fqdn`: primary FQDN of the Uyuni client
- `__meta_uyuni_proxy_module`: the module name if *Exporter Exporter* proxy is configured for the target
- `__meta_uyuni_scheme`:  the protocol scheme used for requests
- `__meta_uyuni_system_id`: the system ID of the client

See below for the configuration options for Uyuni discovery:

```
# The URL to connect to the Uyuni server.
server: <string>

# Credentials are used to authenticate the requests to Uyuni API.
username: <string>
password: <secret>

# The entitlement string to filter eligible systems.
[ entitlement: <string> | default = monitoring_entitled ]

# The string by which Uyuni group names are joined into the groups label.
[ separator: <string> | default = , ]

# Refresh interval to re-read the managed targets list.
[ refresh_interval: <duration> | default = 60s ]

# Optional HTTP basic authentication information, currently not supported by Uyuni.
basic_auth:
  [ username: <string> ]
    [ password: <secret> ]
    [ password_file: <string> ]

# Optional `Authorization` header configuration, currently not supported by Uyuni.
authorization:
  # Sets the authentication type.
    [ type: <string> | default: Bearer ]
    # Sets the credentials. It is mutually exclusive with
    # `credentials_file`.
    [ credentials: <secret> ]
    # Sets the credentials to the credentials read from the configured file.
    # It is mutually exclusive with `credentials`.
    [ credentials_file: <filename> ]

# Optional OAuth 2.0 configuration, currently not supported by Uyuni.
# Cannot be used at the same time as basic_auth or authorization.
oauth2:
  [ <oauth2> ]

# Optional proxy URL.
[ proxy_url: <string> ]
# Comma-separated string that can contain IPs, CIDR notation, domain names
# that should be excluded from proxying. IP and domain names can
# contain port numbers.
[ no_proxy: <string> ]
# Use proxy URL indicated by environment variables (HTTP_PROXY, https_proxy, HTTPs_PROXY, https_proxy, and no_proxy)
[ proxy_from_environment: <bool> | default: false ]
# Specifies headers to send to proxies during CONNECT requests.
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]

# Configure whether HTTP requests follow HTTP 3xx redirects.
[ follow_redirects: <boolean> | default = true ]

# Whether to enable HTTP2.
[ enable_http2: <bool> | default: true ]

# TLS configuration.
tls_config:
  [ <tls_config> ]
```

See [the Prometheus uyuni-sd configuration file](https://github.com/prometheus/prometheus/blob/release-2.43/documentation/examples/prometheus-uyuni.yml) for a practical example on how to set up Uyuni Prometheus configuration.

### `<vultr_sd_config>`

Vultr SD configurations allow retrieving scrape targets from [Vultr](https://www.vultr.com/).

This service discovery uses the main IPv4 address by default, which that be changed with relabeling, as demonstrated in [the Prometheus vultr-sd configuration file](https://github.com/prometheus/prometheus/blob/release-2.43/documentation/examples/prometheus-vultr.yml).

The following meta labels are available on targets during [relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config):

- `__meta_vultr_instance_id` : A unique ID for the vultr Instance.
- `__meta_vultr_instance_label` : The user-supplied label for this instance.
- `__meta_vultr_instance_os` : The Operating System name.
- `__meta_vultr_instance_os_id` : The Operating System id used by this instance.
- `__meta_vultr_instance_region` : The Region id where the Instance is located.
- `__meta_vultr_instance_plan` : A unique ID for the Plan.
- `__meta_vultr_instance_main_ip` : The main IPv4 address.
- `__meta_vultr_instance_internal_ip` : The private IP address.
- `__meta_vultr_instance_main_ipv6` : The main IPv6 address.
- `__meta_vultr_instance_features` : List of features that are available to the instance.
- `__meta_vultr_instance_tags` : List of tags associated with the instance.
- `__meta_vultr_instance_hostname` : The hostname for this instance.
- `__meta_vultr_instance_server_status` : The server health status.
- `__meta_vultr_instance_vcpu_count` : Number of vCPUs.
- `__meta_vultr_instance_ram_mb` : The amount of RAM in MB.
- `__meta_vultr_instance_disk_gb` : The size of the disk in GB.
- `__meta_vultr_instance_allowed_bandwidth_gb` : Monthly bandwidth quota in GB.

```
# Authentication information used to authenticate to the API server.
# Note that `basic_auth` and `authorization` options are
# mutually exclusive.
# password and password_file are mutually exclusive.

# Optional HTTP basic authentication information, not currently supported by Vultr.
basic_auth:
  [ username: <string> ]
  [ password: <secret> ]
  [ password_file: <string> ]

# Optional `Authorization` header configuration.
authorization:
  # Sets the authentication type.
  [ type: <string> | default: Bearer ]
  # Sets the credentials. It is mutually exclusive with
  # `credentials_file`.
  [ credentials: <secret> ]
  # Sets the credentials to the credentials read from the configured file.
  # It is mutually exclusive with `credentials`.
  [ credentials_file: <filename> ]

# Optional OAuth 2.0 configuration.
# Cannot be used at the same time as basic_auth or authorization.
oauth2:
  [ <oauth2> ]

# Optional proxy URL.
[ proxy_url: <string> ]
# Comma-separated string that can contain IPs, CIDR notation, domain names
# that should be excluded from proxying. IP and domain names can
# contain port numbers.
[ no_proxy: <string> ]
# Use proxy URL indicated by environment variables (HTTP_PROXY, https_proxy, HTTPs_PROXY, https_proxy, and no_proxy)
[ proxy_from_environment: <bool> | default: false ]
# Specifies headers to send to proxies during CONNECT requests.
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]

# Configure whether HTTP requests follow HTTP 3xx redirects.
[ follow_redirects: <boolean> | default = true ]

# Whether to enable HTTP2.
[ enable_http2: <bool> | default: true ]

# TLS configuration.
tls_config:
  [ <tls_config> ]

# The port to scrape metrics from.
[ port: <int> | default = 80 ]

# The time after which the instances are refreshed.
[ refresh_interval: <duration> | default = 60s ]
```

### `<static_config>`

A `static_config` allows specifying a list of targets and a common label set for them.  It is the canonical way to specify static targets in a scrape configuration.

```
# The targets specified by the static config.
targets:
  [ - '<host>' ]

# Labels assigned to all metrics scraped from the targets.
labels:
  [ <labelname>: <labelvalue> ... ]
```

### `<relabel_config>`

Relabeling is a powerful tool to dynamically rewrite the label set of a target before it gets scraped. Multiple relabeling steps can be configured per scrape configuration. They are applied to the label set of each target in order of their appearance in the configuration file.

Initially, aside from the configured per-target labels, a target's `job` label is set to the `job_name` value of the respective scrape configuration. The `__address__` label is set to the `<host>:<port>` address of the target. After relabeling, the `instance` label is set to the value of `__address__` by default if it was not set during relabeling. The `__scheme__` and `__metrics_path__` labels are set to the scheme and metrics path of the target respectively. The `__param_<name>` label is set to the value of the first passed URL parameter called `<name>`.

The `__scrape_interval__` and `__scrape_timeout__` labels are set to the target's interval and timeout. This is **experimental** and could change in the future.

Additional labels prefixed with `__meta_` may be available during the relabeling phase. They are set by the service discovery mechanism that provided the target and vary between mechanisms.

Labels starting with `__` will be removed from the label set after target relabeling is completed.

If a relabeling step needs to store a label value only temporarily (as the input to a subsequent relabeling step), use the `__tmp` label name prefix. This prefix is guaranteed to never be used by Prometheus itself.

```
# The source labels select values from existing labels. Their content is concatenated
# using the configured separator and matched against the configured regular expression
# for the replace, keep, and drop actions.
[ source_labels: '[' <labelname> [, ...] ']' ]

# Separator placed between concatenated source label values.
[ separator: <string> | default = ; ]

# Label to which the resulting value is written in a replace action.
# It is mandatory for replace actions. Regex capture groups are available.
[ target_label: <labelname> ]

# Regular expression against which the extracted value is matched.
[ regex: <regex> | default = (.*) ]

# Modulus to take of the hash of the source label values.
[ modulus: <int> ]

# Replacement value against which a regex replace is performed if the
# regular expression matches. Regex capture groups are available.
[ replacement: <string> | default = $1 ]

# Action to perform based on regex matching.
[ action: <relabel_action> | default = replace ]
```

`<regex>` is any valid [RE2 regular expression](https://github.com/google/re2/wiki/Syntax). It is required for the `replace`, `keep`, `drop`, `labelmap`,`labeldrop` and `labelkeep` actions. The regex is anchored on both ends. To un-anchor the regex, use `.*<regex>.*`.

`<relabel_action>` determines the relabeling action to take:

- `replace`: Match `regex` against the concatenated `source_labels`. Then, set `target_label` to `replacement`, with match group references (`${1}`, `${2}`, ...) in `replacement` substituted by their value. If `regex` does not match, no replacement takes place.
- `lowercase`: Maps the concatenated `source_labels` to their lower case.
- `uppercase`: Maps the concatenated `source_labels` to their upper case.
- `keep`: Drop targets for which `regex` does not match the concatenated `source_labels`.
- `drop`: Drop targets for which `regex` matches the concatenated `source_labels`.
- `keepequal`: Drop targets for which the concatenated `source_labels` do not match `target_label`.
- `dropequal`: Drop targets for which the concatenated `source_labels` do match `target_label`.
- `hashmod`: Set `target_label` to the `modulus` of a hash of the concatenated `source_labels`.
- `labelmap`: Match `regex` against all source label names, not just those specified in `source_labels`. Then copy the values of the matching labels  to label names given by `replacement` with match group references (`${1}`, `${2}`, ...) in `replacement` substituted by their value.
- `labeldrop`: Match `regex` against all label names. Any label that matches will be removed from the set of labels.
- `labelkeep`: Match `regex` against all label names. Any label that does not match will be removed from the set of labels.

Care must be taken with `labeldrop` and `labelkeep` to ensure that metrics are still uniquely labeled once the labels are removed.

### `<metric_relabel_configs>`

Metric relabeling is applied to samples as the last step before ingestion. It has the same configuration format and actions as target relabeling. Metric relabeling does not apply to automatically generated timeseries such as `up`.

One use for this is to exclude time series that are too expensive to ingest.

### `<alert_relabel_configs>`

Alert relabeling is applied to alerts before they are sent to the Alertmanager. It has the same configuration format and actions as target relabeling. Alert relabeling is applied after external labels.

One use for this is ensuring a HA pair of Prometheus servers with different external labels send identical alerts.

### `<alertmanager_config>`

An `alertmanager_config` section specifies Alertmanager instances the Prometheus server sends alerts to. It also provides parameters to configure how to communicate with these Alertmanagers.

Alertmanagers may be statically configured via the `static_configs` parameter or dynamically discovered using one of the supported service-discovery mechanisms.

Additionally, `relabel_configs` allow selecting Alertmanagers from discovered entities and provide advanced modifications to the used API path, which is exposed through the `__alerts_path__` label.

```
# Per-target Alertmanager timeout when pushing alerts.
[ timeout: <duration> | default = 10s ]

# The api version of Alertmanager.
[ api_version: <string> | default = v2 ]

# Prefix for the HTTP path alerts are pushed to.
[ path_prefix: <path> | default = / ]

# Configures the protocol scheme used for requests.
[ scheme: <scheme> | default = http ]

# Sets the `Authorization` header on every request with the
# configured username and password.
# password and password_file are mutually exclusive.
basic_auth:
  [ username: <string> ]
  [ password: <secret> ]
  [ password_file: <string> ]

# Optional `Authorization` header configuration.
authorization:
  # Sets the authentication type.
  [ type: <string> | default: Bearer ]
  # Sets the credentials. It is mutually exclusive with
  # `credentials_file`.
  [ credentials: <secret> ]
  # Sets the credentials to the credentials read from the configured file.
  # It is mutually exclusive with `credentials`.
  [ credentials_file: <filename> ]

# Optional OAuth 2.0 configuration.
# Cannot be used at the same time as basic_auth or authorization.
oauth2:
  [ <oauth2> ]

# Configures the scrape request's TLS settings.
tls_config:
  [ <tls_config> ]

# Optional proxy URL.
[ proxy_url: <string> ]
# Comma-separated string that can contain IPs, CIDR notation, domain names
# that should be excluded from proxying. IP and domain names can
# contain port numbers.
[ no_proxy: <string> ]
# Use proxy URL indicated by environment variables (HTTP_PROXY, https_proxy, HTTPs_PROXY, https_proxy, and no_proxy)
[ proxy_from_environment: <bool> | default: false ]
# Specifies headers to send to proxies during CONNECT requests.
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]

# Configure whether HTTP requests follow HTTP 3xx redirects.
[ follow_redirects: <boolean> | default = true ]

# Whether to enable HTTP2.
[ enable_http2: <bool> | default: true ]

# List of Azure service discovery configurations.
azure_sd_configs:
  [ - <azure_sd_config> ... ]

# List of Consul service discovery configurations.
consul_sd_configs:
  [ - <consul_sd_config> ... ]

# List of DNS service discovery configurations.
dns_sd_configs:
  [ - <dns_sd_config> ... ]

# List of EC2 service discovery configurations.
ec2_sd_configs:
  [ - <ec2_sd_config> ... ]

# List of Eureka service discovery configurations.
eureka_sd_configs:
  [ - <eureka_sd_config> ... ]

# List of file service discovery configurations.
file_sd_configs:
  [ - <file_sd_config> ... ]

# List of DigitalOcean service discovery configurations.
digitalocean_sd_configs:
  [ - <digitalocean_sd_config> ... ]

# List of Docker service discovery configurations.
docker_sd_configs:
  [ - <docker_sd_config> ... ]

# List of Docker Swarm service discovery configurations.
dockerswarm_sd_configs:
  [ - <dockerswarm_sd_config> ... ]

# List of GCE service discovery configurations.
gce_sd_configs:
  [ - <gce_sd_config> ... ]

# List of Hetzner service discovery configurations.
hetzner_sd_configs:
  [ - <hetzner_sd_config> ... ]

# List of HTTP service discovery configurations.
http_sd_configs:
  [ - <http_sd_config> ... ]

 # List of IONOS service discovery configurations.
ionos_sd_configs:
  [ - <ionos_sd_config> ... ]

# List of Kubernetes service discovery configurations.
kubernetes_sd_configs:
  [ - <kubernetes_sd_config> ... ]

# List of Lightsail service discovery configurations.
lightsail_sd_configs:
  [ - <lightsail_sd_config> ... ]

# List of Linode service discovery configurations.
linode_sd_configs:
  [ - <linode_sd_config> ... ]

# List of Marathon service discovery configurations.
marathon_sd_configs:
  [ - <marathon_sd_config> ... ]

# List of AirBnB's Nerve service discovery configurations.
nerve_sd_configs:
  [ - <nerve_sd_config> ... ]

# List of Nomad service discovery configurations.
nomad_sd_configs:
  [ - <nomad_sd_config> ... ]

# List of OpenStack service discovery configurations.
openstack_sd_configs:
  [ - <openstack_sd_config> ... ]

# List of OVHcloud service discovery configurations.
ovhcloud_sd_configs:
  [ - <ovhcloud_sd_config> ... ]

# List of PuppetDB service discovery configurations.
puppetdb_sd_configs:
  [ - <puppetdb_sd_config> ... ]

# List of Scaleway service discovery configurations.
scaleway_sd_configs:
  [ - <scaleway_sd_config> ... ]

# List of Zookeeper Serverset service discovery configurations.
serverset_sd_configs:
  [ - <serverset_sd_config> ... ]

# List of Triton service discovery configurations.
triton_sd_configs:
  [ - <triton_sd_config> ... ]

# List of Uyuni service discovery configurations.
uyuni_sd_configs:
  [ - <uyuni_sd_config> ... ]

# List of Vultr service discovery configurations.
vultr_sd_configs:
  [ - <vultr_sd_config> ... ]

# List of labeled statically configured Alertmanagers.
static_configs:
  [ - <static_config> ... ]

# List of Alertmanager relabel configurations.
relabel_configs:
  [ - <relabel_config> ... ]
```

### `<remote_write>`

`write_relabel_configs` is relabeling applied to samples before sending them to the remote endpoint. Write relabeling is applied after external labels. This could be used to limit which samples are sent.

There is a [small demo](https://github.com/prometheus/prometheus/blob/release-2.43/documentation/examples/remote_storage) of how to use this functionality.

```
# The URL of the endpoint to send samples to.
url: <string>

# Timeout for requests to the remote write endpoint.
[ remote_timeout: <duration> | default = 30s ]

# Custom HTTP headers to be sent along with each remote write request.
# Be aware that headers that are set by Prometheus itself can't be overwritten.
headers:
  [ <string>: <string> ... ]

# List of remote write relabel configurations.
write_relabel_configs:
  [ - <relabel_config> ... ]

# Name of the remote write config, which if specified must be unique among remote write configs.
# The name will be used in metrics and logging in place of a generated value to help users distinguish between
# remote write configs.
[ name: <string> ]

# Enables sending of exemplars over remote write. Note that exemplar storage itself must be enabled for exemplars to be scraped in the first place.
[ send_exemplars: <boolean> | default = false ]

# Enables sending of native histograms, also known as sparse histograms, over remote write.
[ send_native_histograms: <boolean> | default = false ]

# Sets the `Authorization` header on every remote write request with the
# configured username and password.
# password and password_file are mutually exclusive.
basic_auth:
  [ username: <string> ]
  [ password: <secret> ]
  [ password_file: <string> ]

# Optional `Authorization` header configuration.
authorization:
  # Sets the authentication type.
  [ type: <string> | default: Bearer ]
  # Sets the credentials. It is mutually exclusive with
  # `credentials_file`.
  [ credentials: <secret> ]
  # Sets the credentials to the credentials read from the configured file.
  # It is mutually exclusive with `credentials`.
  [ credentials_file: <filename> ]

# Optionally configures AWS's Signature Verification 4 signing process to
# sign requests. Cannot be set at the same time as basic_auth, authorization, or oauth2.
# To use the default credentials from the AWS SDK, use `sigv4: {}`.
sigv4:
  # The AWS region. If blank, the region from the default credentials chain
  # is used.
  [ region: <string> ]

  # The AWS API keys. If blank, the environment variables `AWS_ACCESS_KEY_ID`
  # and `AWS_SECRET_ACCESS_KEY` are used.
  [ access_key: <string> ]
  [ secret_key: <secret> ]

  # Named AWS profile used to authenticate.
  [ profile: <string> ]

  # AWS Role ARN, an alternative to using AWS API keys.
  [ role_arn: <string> ]

# Optional OAuth 2.0 configuration.
# Cannot be used at the same time as basic_auth, authorization, or sigv4.
oauth2:
  [ <oauth2> ]

# Configures the remote write request's TLS settings.
tls_config:
  [ <tls_config> ]

# Optional proxy URL.
[ proxy_url: <string> ]
# Comma-separated string that can contain IPs, CIDR notation, domain names
# that should be excluded from proxying. IP and domain names can
# contain port numbers.
[ no_proxy: <string> ]
# Use proxy URL indicated by environment variables (HTTP_PROXY, https_proxy, HTTPs_PROXY, https_proxy, and no_proxy)
[ proxy_from_environment: <bool> | default: false ]
# Specifies headers to send to proxies during CONNECT requests.
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]

# Configure whether HTTP requests follow HTTP 3xx redirects.
[ follow_redirects: <boolean> | default = true ]

# Whether to enable HTTP2.
[ enable_http2: <bool> | default: true ]

# Configures the queue used to write to remote storage.
queue_config:
  # Number of samples to buffer per shard before we block reading of more
  # samples from the WAL. It is recommended to have enough capacity in each
  # shard to buffer several requests to keep throughput up while processing
  # occasional slow remote requests.
  [ capacity: <int> | default = 2500 ]
  # Maximum number of shards, i.e. amount of concurrency.
  [ max_shards: <int> | default = 200 ]
  # Minimum number of shards, i.e. amount of concurrency.
  [ min_shards: <int> | default = 1 ]
  # Maximum number of samples per send.
  [ max_samples_per_send: <int> | default = 500]
  # Maximum time a sample will wait in buffer.
  [ batch_send_deadline: <duration> | default = 5s ]
  # Initial retry delay. Gets doubled for every retry.
  [ min_backoff: <duration> | default = 30ms ]
  # Maximum retry delay.
  [ max_backoff: <duration> | default = 5s ]
  # Retry upon receiving a 429 status code from the remote-write storage.
  # This is experimental and might change in the future.
  [ retry_on_http_429: <boolean> | default = false ]

# Configures the sending of series metadata to remote storage.
# Metadata configuration is subject to change at any point
# or be removed in future releases.
metadata_config:
  # Whether metric metadata is sent to remote storage or not.
  [ send: <boolean> | default = true ]
  # How frequently metric metadata is sent to remote storage.
  [ send_interval: <duration> | default = 1m ]
  # Maximum number of samples per send.
  [ max_samples_per_send: <int> | default = 500]
```

There is a list of [integrations](https://prometheus.io/docs/operating/integrations/#remote-endpoints-and-storage) with this feature.

### `<remote_read>`

```
# The URL of the endpoint to query from.
url: <string>

# Name of the remote read config, which if specified must be unique among remote read configs.
# The name will be used in metrics and logging in place of a generated value to help users distinguish between
# remote read configs.
[ name: <string> ]

# An optional list of equality matchers which have to be
# present in a selector to query the remote read endpoint.
required_matchers:
  [ <labelname>: <labelvalue> ... ]

# Timeout for requests to the remote read endpoint.
[ remote_timeout: <duration> | default = 1m ]

# Custom HTTP headers to be sent along with each remote read request.
# Be aware that headers that are set by Prometheus itself can't be overwritten.
headers:
  [ <string>: <string> ... ]

# Whether reads should be made for queries for time ranges that
# the local storage should have complete data for.
[ read_recent: <boolean> | default = false ]

# Sets the `Authorization` header on every remote read request with the
# configured username and password.
# password and password_file are mutually exclusive.
basic_auth:
  [ username: <string> ]
  [ password: <secret> ]
  [ password_file: <string> ]

# Optional `Authorization` header configuration.
authorization:
  # Sets the authentication type.
  [ type: <string> | default: Bearer ]
  # Sets the credentials. It is mutually exclusive with
  # `credentials_file`.
  [ credentials: <secret> ]
  # Sets the credentials to the credentials read from the configured file.
  # It is mutually exclusive with `credentials`.
  [ credentials_file: <filename> ]

# Optional OAuth 2.0 configuration.
# Cannot be used at the same time as basic_auth or authorization.
oauth2:
  [ <oauth2> ]

# Configures the remote read request's TLS settings.
tls_config:
  [ <tls_config> ]

# Optional proxy URL.
[ proxy_url: <string> ]
# Comma-separated string that can contain IPs, CIDR notation, domain names
# that should be excluded from proxying. IP and domain names can
# contain port numbers.
[ no_proxy: <string> ]
# Use proxy URL indicated by environment variables (HTTP_PROXY, https_proxy, HTTPs_PROXY, https_proxy, and no_proxy)
[ proxy_from_environment: <bool> | default: false ]
# Specifies headers to send to proxies during CONNECT requests.
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]

# Configure whether HTTP requests follow HTTP 3xx redirects.
[ follow_redirects: <boolean> | default = true ]

# Whether to enable HTTP2.
[ enable_http2: <bool> | default: true ]

# Whether to use the external labels as selectors for the remote read endpoint.
[ filter_external_labels: <boolean> | default = true ]
```

There is a list of [integrations](https://prometheus.io/docs/operating/integrations/#remote-endpoints-and-storage) with this feature.

### `<tsdb>`

`tsdb` lets you configure the runtime-reloadable configuration settings of the TSDB.

**NOTE:** Out-of-order ingestion is an experimental feature, but you do not need any additional flag to enable it. Setting `out_of_order_time_window` to a positive duration enables it.

```
# Configures how old an out-of-order/out-of-bounds sample can be w.r.t. the TSDB max time.
# An out-of-order/out-of-bounds sample is ingested into the TSDB as long as the timestamp
# of the sample is >= TSDB.MaxTime-out_of_order_time_window.
#
# When out_of_order_time_window is >0, the errors out-of-order and out-of-bounds are
# combined into a single error called 'too-old'; a sample is either (a) ingestible
# into the TSDB, i.e. it is an in-order sample or an out-of-order/out-of-bounds sample
# that is within the out-of-order window, or (b) too-old, i.e. not in-order
# and before the out-of-order window.
[ out_of_order_time_window: <duration> | default = 0s ]
```

### `<exemplars>`

Note that exemplar storage is still considered experimental and must be enabled via `--enable-feature=exemplar-storage`.

```
# Configures the maximum size of the circular buffer used to store exemplars for all series. Resizable during runtime.
[ max_exemplars: <int> | default = 100000 ]
```

### `<tracing_config>`

`tracing_config` configures exporting traces from Prometheus to a tracing backend via the OTLP protocol. Tracing is currently an **experimental** feature and could change in the future.

```
# Client used to export the traces. Options are 'http' or 'grpc'.
[ client_type: <string> | default = grpc ]

# Endpoint to send the traces to. Should be provided in format <host>:<port>.
[ endpoint: <string> ]

# Sets the probability a given trace will be sampled. Must be a float from 0 through 1.
[ sampling_fraction: <float> | default = 0 ]

# If disabled, the client will use a secure connection.
[ insecure: <boolean> | default = false ]

# Key-value pairs to be used as headers associated with gRPC or HTTP requests.
headers:
  [ <string>: <string> ... ]

# Compression key for supported compression types. Supported compression: gzip.
[ compression: <string> ]

# Maximum time the exporter will wait for each batch export.
[ timeout: <duration> | default = 10s ]

# TLS configuration.
tls_config:
  [ <tls_config> ]
```

# Defining recording rules

- [Configuring rules ](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/#configuring-rules)

- [Syntax-checking rules ](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/#syntax-checking-rules)

- [Recording rules ](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/#recording-rules)

- - [ `` ](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/#rule_group)
  - [ `` ](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/#rule)

## Configuring rules

Prometheus supports two types of rules which may be configured and then evaluated at regular intervals: recording rules and [alerting rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/). To include rules in Prometheus, create a file containing the necessary rule statements and have Prometheus load the file via the `rule_files` field in the [Prometheus configuration](https://prometheus.io/docs/prometheus/latest/configuration/configuration/). Rule files use YAML.

The rule files can be reloaded at runtime by sending `SIGHUP` to the Prometheus process. The changes are only applied if all rule files are well-formatted.

*Note about native histograms (experimental feature): Native histogram are always recorded as gauge histograms (for now). Most cases will create gauge histograms naturally, e.g. after `rate()`.*

## Syntax-checking rules

To quickly check whether a rule file is syntactically correct without starting a Prometheus server, you can use Prometheus's `promtool` command-line utility tool:

```
promtool check rules /path/to/example.rules.yml
```

The `promtool` binary is part of the `prometheus` archive offered on the project's [download page](https://prometheus.io/download/).

When the file is syntactically valid, the checker prints a textual representation of the parsed rules to standard output and then exits with a `0` return status.

If there are any syntax errors or invalid input arguments, it prints an error  message to standard error and exits with a `1` return status.

## Recording rules

Recording rules allow you to precompute frequently needed or computationally expensive expressions and save their result as a new set of time series. Querying the precomputed result will then often be much faster than executing the original expression every time it is needed. This is especially useful for dashboards, which need to query the same expression repeatedly every time they refresh.

Recording and alerting rules exist in a rule group. Rules within a group are run sequentially at a regular interval, with the same evaluation time. The names of recording rules must be [valid metric names](https://prometheus.io/docs/concepts/data_model/#metric-names-and-labels). The names of alerting rules must be [valid label values](https://prometheus.io/docs/concepts/data_model/#metric-names-and-labels).

The syntax of a rule file is:

```
groups:
  [ - <rule_group> ]
```

A simple example rules file would be:

```
groups:
  - name: example
    rules:
    - record: code:prometheus_http_requests_total:sum
      expr: sum by (code) (prometheus_http_requests_total)
```

### `<rule_group>`

```
# The name of the group. Must be unique within a file.
name: <string>

# How often rules in the group are evaluated.
[ interval: <duration> | default = global.evaluation_interval ]

# Limit the number of alerts an alerting rule and series a recording
# rule can produce. 0 is no limit.
[ limit: <int> | default = 0 ]

rules:
  [ - <rule> ... ]
```

### `<rule>`

The syntax for recording rules is:

```
# The name of the time series to output to. Must be a valid metric name.
record: <string>

# The PromQL expression to evaluate. Every evaluation cycle this is
# evaluated at the current time, and the result recorded as a new set of
# time series with the metric name as given by 'record'.
expr: <string>

# Labels to add or overwrite before storing the result.
labels:
  [ <labelname>: <labelvalue> ]
```

The syntax for alerting rules is:

```
# The name of the alert. Must be a valid label value.
alert: <string>

# The PromQL expression to evaluate. Every evaluation cycle this is
# evaluated at the current time, and all resultant time series become
# pending/firing alerts.
expr: <string>

# Alerts are considered firing once they have been returned for this long.
# Alerts which have not yet fired for long enough are considered pending.
[ for: <duration> | default = 0s ]

# How long an alert will continue firing after the condition that triggered it
# has cleared.
[ keep_firing_for: <duration> | default = 0s ]

# Labels to add or overwrite for each alert.
labels:
  [ <labelname>: <tmpl_string> ]

# Annotations to add to each alert.
annotations:
  [ <labelname>: <tmpl_string> ]
```

See also the [best practices for naming metrics created by recording rules](https://prometheus.io/docs/practices/rules/#recording-rules).

# Limiting alerts and series

A limit for alerts produced by alerting rules and series produced recording rules can be configured per-group. When the limit is exceeded, *all* series produced by the rule are discarded, and if it's an alerting rule, *all* alerts for the rule, active, pending, or inactive, are cleared as well. The event will be recorded as an error in the evaluation, and as such no stale markers are written.

# Alerting rules

- [Defining alerting rules ](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/#defining-alerting-rules)
- [Inspecting alerts during runtime ](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/#inspecting-alerts-during-runtime)
- [Sending alert notifications ](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/#sending-alert-notifications)

Alerting rules allow you to define alert conditions based on Prometheus expression language expressions and to send notifications about firing alerts to an external service. Whenever the alert expression results in one or more vector elements at a given point in time, the alert counts as active for these elements' label sets.

### Defining alerting rules

Alerting rules are configured in Prometheus in the same way as [recording rules](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/).

An example rules file with an alert would be:

```
groups:
- name: example
  rules:
  - alert: HighRequestLatency
    expr: job:request_latency_seconds:mean5m{job="myjob"} > 0.5
    for: 10m
    labels:
      severity: page
    annotations:
      summary: High request latency
```

The optional `for` clause causes Prometheus to wait for a  certain duration between first encountering a new expression output vector element and  counting an alert as firing for this element. In this case, Prometheus  will check that the alert continues to be active during each evaluation  for 10 minutes before firing the alert. Elements that are active, but  not firing yet, are in the pending state.

The `labels` clause allows specifying a set of additional labels to be attached to the alert. Any existing conflicting labels will be overwritten. The label values can be templated.

The `annotations` clause specifies a set of informational  labels that can be used to store longer additional information such as  alert descriptions or runbook links. The annotation values can be  templated.

#### Templating

Label and annotation values can be templated using [console templates](https://prometheus.io/docs/visualization/consoles).  The `$labels` variable holds the label key/value pairs of an alert instance. The configured external labels can be accessed via the `$externalLabels` variable. The `$value` variable holds the evaluated value of an alert instance.

```
# To insert a firing element's label values:
{{ $labels.<labelname> }}
# To insert the numeric expression value of the firing element:
{{ $value }}
```

Examples:

```
groups:
- name: example
  rules:

  # Alert for any instance that is unreachable for >5 minutes.
  - alert: InstanceDown
    expr: up == 0
    for: 5m
    labels:
      severity: page
    annotations:
      summary: "Instance {{ $labels.instance }} down"
      description: "{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes."

  # Alert for any instance that has a median request latency >1s.
  - alert: APIHighRequestLatency
    expr: api_http_request_latencies_second{quantile="0.5"} > 1
    for: 10m
    annotations:
      summary: "High request latency on {{ $labels.instance }}"
      description: "{{ $labels.instance }} has a median request latency above 1s (current value: {{ $value }}s)"
```

### Inspecting alerts during runtime

To manually inspect which alerts are active (pending or firing), navigate to the "Alerts" tab of your Prometheus instance. This will show you the exact label sets for which each defined alert is currently active.

For pending and firing alerts, Prometheus also stores synthetic time series of the form `ALERTS{alertname="<alert name>", alertstate="<pending or firing>", <additional alert labels>}`. The sample value is set to `1` as long as the alert is in the indicated active (pending or firing) state, and the series is marked stale when this is no longer the case.

### Sending alert notifications

Prometheus's alerting rules are good at figuring what is broken *right now*, but they are not a fully-fledged notification solution. Another layer is needed to add summarization, notification rate limiting, silencing and alert dependencies on top of the simple alert definitions. In Prometheus's ecosystem, the [Alertmanager](https://prometheus.io/docs/alerting/alertmanager/) takes on this role. Thus, Prometheus may be configured to periodically send information about alert states to an Alertmanager instance, which then takes care of dispatching the right notifications.
 Prometheus can be [configured](https://prometheus.io/docs/prometheus/latest/configuration/configuration/) to automatically discover available Alertmanager instances through its service discovery integrations.

# Template examples

- [Simple alert field templates ](https://prometheus.io/docs/prometheus/latest/configuration/template_examples/#simple-alert-field-templates)
- [Simple iteration ](https://prometheus.io/docs/prometheus/latest/configuration/template_examples/#simple-iteration)
- [Display one value ](https://prometheus.io/docs/prometheus/latest/configuration/template_examples/#display-one-value)
- [Using console URL parameters ](https://prometheus.io/docs/prometheus/latest/configuration/template_examples/#using-console-url-parameters)
- [Advanced iteration ](https://prometheus.io/docs/prometheus/latest/configuration/template_examples/#advanced-iteration)
- [Defining reusable templates ](https://prometheus.io/docs/prometheus/latest/configuration/template_examples/#defining-reusable-templates)

Prometheus supports templating in the annotations and labels of alerts, as well as in served console pages. Templates have the ability to run queries against the local database, iterate over data, use conditionals, format data, etc. The Prometheus templating language is based on the [Go templating](https://golang.org/pkg/text/template/) system.

## Simple alert field templates

```
alert: InstanceDown
expr: up == 0
for: 5m
labels:
  severity: page
annotations:
  summary: "Instance {{$labels.instance}} down"
  description: "{{$labels.instance}} of job {{$labels.job}} has been down for more than 5 minutes."
```

Alert field templates will be executed during every rule iteration for each alert that fires, so keep any queries and templates lightweight. If you have a need for more complicated templates for alerts, it is recommended to link to a console instead.

## Simple iteration

This displays a list of instances, and whether they are up:

```
{{ range query "up" }}
  {{ .Labels.instance }} {{ .Value }}
{{ end }}
```

The special `.` variable contains the value of the current sample for each loop iteration.

## Display one value

```
{{ with query "some_metric{instance='someinstance'}" }}
  {{ . | first | value | humanize }}
{{ end }}
```

Go and Go's templating language are both strongly typed, so one must check that samples were returned to avoid an execution error. For example this could happen if a scrape or rule evaluation has not run yet, or a host was down.

The included `prom_query_drilldown` template handles this, allows for formatting of results, and linking to the [expression browser](https://prometheus.io/docs/visualization/browser/).

## Using console URL parameters

```
{{ with printf "node_memory_MemTotal{job='node',instance='%s'}" .Params.instance | query }}
  {{ . | first | value | humanize1024 }}B
{{ end }}
```

If accessed as `console.html?instance=hostname`, `.Params.instance` will evaluate to `hostname`.

## Advanced iteration

```
<table>
{{ range printf "node_network_receive_bytes{job='node',instance='%s',device!='lo'}" .Params.instance | query | sortByLabel "device"}}
  <tr><th colspan=2>{{ .Labels.device }}</th></tr>
  <tr>
    <td>Received</td>
    <td>{{ with printf "rate(node_network_receive_bytes{job='node',instance='%s',device='%s'}[5m])" .Labels.instance .Labels.device | query }}{{ . | first | value | humanize }}B/s{{end}}</td>
  </tr>
  <tr>
    <td>Transmitted</td>
    <td>{{ with printf "rate(node_network_transmit_bytes{job='node',instance='%s',device='%s'}[5m])" .Labels.instance .Labels.device | query }}{{ . | first | value | humanize }}B/s{{end}}</td>
  </tr>{{ end }}
</table>
```

Here we iterate over all network devices and display the network traffic for each.

As the `range` action does not specify a variable, `.Params.instance` is not available inside the loop as `.` is now the loop variable.

## Defining reusable templates

Prometheus supports defining templates that can be reused. This is particularly powerful when combined with [console library](https://prometheus.io/docs/prometheus/latest/configuration/template_reference/#console-templates) support, allowing sharing of templates across consoles.

```
{{/* Define the template */}}
{{define "myTemplate"}}
  do something
{{end}}

{{/* Use the template */}}
{{template "myTemplate"}}
```

Templates are limited to one argument. The `args` function can be used to wrap multiple arguments.

```
{{define "myMultiArgTemplate"}}
  First argument: {{.arg0}}
  Second argument: {{.arg1}}
{{end}}
{{template "myMultiArgTemplate" (args 1 2)}}
```

# Template reference

- [Data Structures ](https://prometheus.io/docs/prometheus/latest/configuration/template_reference/#data-structures)

- [Functions ](https://prometheus.io/docs/prometheus/latest/configuration/template_reference/#functions)

- - [Queries ](https://prometheus.io/docs/prometheus/latest/configuration/template_reference/#queries)
  - [Numbers ](https://prometheus.io/docs/prometheus/latest/configuration/template_reference/#numbers)
  - [Strings ](https://prometheus.io/docs/prometheus/latest/configuration/template_reference/#strings)
  - [Others ](https://prometheus.io/docs/prometheus/latest/configuration/template_reference/#others)

- [Template type differences ](https://prometheus.io/docs/prometheus/latest/configuration/template_reference/#template-type-differences)

- - [Alert field templates ](https://prometheus.io/docs/prometheus/latest/configuration/template_reference/#alert-field-templates)
  - [Console templates ](https://prometheus.io/docs/prometheus/latest/configuration/template_reference/#console-templates)

Prometheus supports templating in the annotations and labels of alerts, as well as in served console pages. Templates have the ability to run queries against the local database, iterate over data, use conditionals, format data, etc. The Prometheus templating language is based on the [Go templating](https://golang.org/pkg/text/template/) system.

## Data Structures

The primary data structure for dealing with time series data is the sample, defined as:

```
type sample struct {
        Labels map[string]string
        Value  float64
}
```

The metric name of the sample is encoded in a special `__name__` label in the `Labels` map.

`[]sample` means a list of samples.

`interface{}` in Go is similar to a void pointer in C.

## Functions

In addition to the [default functions](https://golang.org/pkg/text/template/#hdr-Functions) provided by Go templating, Prometheus provides functions for easier processing of query results in templates.

If functions are used in a pipeline, the pipeline value is passed as the last argument.

### Queries

| Name        | Arguments        | Returns  | Notes                                                        |
| ----------- | ---------------- | -------- | ------------------------------------------------------------ |
| query       | query string     | []sample | Queries the database, does not support returning range vectors. |
| first       | []sample         | sample   | Equivalent to `index a 0`                                    |
| label       | label, sample    | string   | Equivalent to `index sample.Labels label`                    |
| value       | sample           | float64  | Equivalent to `sample.Value`                                 |
| sortByLabel | label, []samples | []sample | Sorts the samples by the given label. Is stable.             |

`first`, `label` and `value` are intended to make query results easily usable in pipelines.

### Numbers

| Name               | Arguments        | Returns    | Notes                                                        |
| ------------------ | ---------------- | ---------- | ------------------------------------------------------------ |
| humanize           | number or string | string     | Converts a number to a more readable format, using [metric prefixes](https://en.wikipedia.org/wiki/Metric_prefix). |
| humanize1024       | number or string | string     | Like `humanize`, but uses 1024 as the base rather than 1000. |
| humanizeDuration   | number or string | string     | Converts a duration in seconds to a more readable format.    |
| humanizePercentage | number or string | string     | Converts a ratio value to a fraction of 100.                 |
| humanizeTimestamp  | number or string | string     | Converts a Unix timestamp in seconds to a more readable format. |
| toTime             | number or string | *time.Time | Converts a Unix timestamp in seconds to a time.Time.         |

Humanizing functions are intended to produce reasonable output for consumption by humans, and are not guaranteed to return the same results between Prometheus versions.

### Strings

| Name          | Arguments                  | Returns | Notes                                                        |
| ------------- | -------------------------- | ------- | ------------------------------------------------------------ |
| title         | string                     | string  | [strings.Title](https://golang.org/pkg/strings/#Title), capitalises first character of each word. |
| toUpper       | string                     | string  | [strings.ToUpper](https://golang.org/pkg/strings/#ToUpper), converts all characters to upper case. |
| toLower       | string                     | string  | [strings.ToLower](https://golang.org/pkg/strings/#ToLower), converts all characters to lower case. |
| stripPort     | string                     | string  | [net.SplitHostPort](https://pkg.go.dev/net#SplitHostPort), splits string into host and port, then returns only host. |
| match         | pattern, text              | boolean | [regexp.MatchString](https://golang.org/pkg/regexp/#MatchString) Tests for a unanchored regexp match. |
| reReplaceAll  | pattern, replacement, text | string  | [Regexp.ReplaceAllString](https://golang.org/pkg/regexp/#Regexp.ReplaceAllString) Regexp substitution, unanchored. |
| graphLink     | expr                       | string  | Returns path to graph view in the [expression browser](https://prometheus.io/docs/visualization/browser/) for the expression. |
| tableLink     | expr                       | string  | Returns path to tabular ("Table") view in the [expression browser](https://prometheus.io/docs/visualization/browser/) for the expression. |
| parseDuration | string                     | float   | Parses a duration string such as "1h" into the number of seconds it represents. |
| stripDomain   | string                     | string  | Removes the domain part of a FQDN. Leaves port untouched.    |

### Others

| Name       | Arguments             | Returns                | Notes                                                        |
| ---------- | --------------------- | ---------------------- | ------------------------------------------------------------ |
| args       | []interface{}         | map[string]interface{} | This converts a list of objects to a map with keys arg0, arg1 etc.  This is intended to allow multiple arguments to be passed to templates. |
| tmpl       | string, []interface{} | nothing                | Like the built-in `template`, but allows non-literals as  the template name. Note that the result is assumed to be safe, and will  not be auto-escaped. Only available in consoles. |
| safeHtml   | string                | string                 | Marks string as HTML not requiring auto-escaping.            |
| pathPrefix | *none*                | string                 | The external URL [path](https://pkg.go.dev/net/url#URL) for use in console templates. |

## Template type differences

Each of the types of templates provide different information that can be used to parameterize templates, and have a few other differences.

### Alert field templates

`.Value`, `.Labels`, `.ExternalLabels`, and `.ExternalURL` contain the alert value, the alert labels, the globally configured external labels, and the external URL (configured with `--web.external-url`) respectively. They are also exposed as the `$value`, `$labels`, `$externalLabels`, and `$externalURL` variables for convenience.

### Console templates

Consoles are exposed on `/consoles/`, and sourced from the directory pointed to by the `-web.console.templates` flag.

Console templates are rendered with [html/template](https://golang.org/pkg/html/template/), which provides auto-escaping. To bypass the auto-escaping use the `safe*` functions.,

URL parameters are available as a map in `.Params`. To access multiple URL parameters by the same name, `.RawParams` is a map of the list values for each parameter. The URL path is available in `.Path`, excluding the `/consoles/` prefix. The globally configured external labels are available as `.ExternalLabels`. There are also convenience variables for all four: `$rawParams`, `$params`, `$path`, and `$externalLabels`.

Consoles also have access to all the templates defined with `{{define "templateName"}}...{{end}}` found in `*.lib` files in the directory pointed to by the `-web.console.libraries` flag. As this is a shared namespace, take care to avoid clashes with other users. Template names beginning with `prom`, `_prom`, and `__` are reserved for use by Prometheus, as are the functions listed above.

# Unit Testing for Rules

- [Test file format ](https://prometheus.io/docs/prometheus/latest/configuration/unit_testing_rules/#test-file-format)

- - [ `` ](https://prometheus.io/docs/prometheus/latest/configuration/unit_testing_rules/#test_group)
  - [ `` ](https://prometheus.io/docs/prometheus/latest/configuration/unit_testing_rules/#series)
  - [ `` ](https://prometheus.io/docs/prometheus/latest/configuration/unit_testing_rules/#alert_test_case)
  - [ `` ](https://prometheus.io/docs/prometheus/latest/configuration/unit_testing_rules/#alert)
  - [ `` ](https://prometheus.io/docs/prometheus/latest/configuration/unit_testing_rules/#promql_test_case)
  - [ `` ](https://prometheus.io/docs/prometheus/latest/configuration/unit_testing_rules/#sample)

- [Example ](https://prometheus.io/docs/prometheus/latest/configuration/unit_testing_rules/#example)

- - [ `test.yml` ](https://prometheus.io/docs/prometheus/latest/configuration/unit_testing_rules/#test-yml)
  - [ `alerts.yml` ](https://prometheus.io/docs/prometheus/latest/configuration/unit_testing_rules/#alerts-yml)

You can use `promtool` to test your rules.

```
# For a single test file.
./promtool test rules test.yml

# If you have multiple test files, say test1.yml,test2.yml,test2.yml
./promtool test rules test1.yml test2.yml test3.yml
```

## Test file format

```
# This is a list of rule files to consider for testing. Globs are supported.
rule_files:
  [ - <file_name> ]

[ evaluation_interval: <duration> | default = 1m ]

# The order in which group names are listed below will be the order of evaluation of
# rule groups (at a given evaluation time). The order is guaranteed only for the groups mentioned below.
# All the groups need not be mentioned below.
group_eval_order:
  [ - <group_name> ]

# All the tests are listed here.
tests:
  [ - <test_group> ]
```

### `<test_group>`

```
# Series data
interval: <duration>
input_series:
  [ - <series> ]

# Name of the test group
[ name: <string> ]

# Unit tests for the above data.

# Unit tests for alerting rules. We consider the alerting rules from the input file.
alert_rule_test:
  [ - <alert_test_case> ]

# Unit tests for PromQL expressions.
promql_expr_test:
  [ - <promql_test_case> ]

# External labels accessible to the alert template.
external_labels:
  [ <labelname>: <string> ... ]

# External URL accessible to the alert template.
# Usually set using --web.external-url.
  [ external_url: <string> ]
```

### `<series>`

```
# This follows the usual series notation '<metric name>{<label name>=<label value>, ...}'
# Examples:
#      series_name{label1="value1", label2="value2"}
#      go_goroutines{job="prometheus", instance="localhost:9090"}
series: <string>

# This uses expanding notation.
# Expanding notation:
#     'a+bxc' becomes 'a a+b a+(2*b) a+(3*b) … a+(c*b)'
#     Read this as series starts at a, then c further samples incrementing by b.
#     'a-bxc' becomes 'a a-b a-(2*b) a-(3*b) … a-(c*b)'
#     Read this as series starts at a, then c further samples decrementing by b (or incrementing by negative b).
# There are special values to indicate missing and stale samples:
#    '_' represents a missing sample from scrape
#    'stale' indicates a stale sample
# Examples:
#     1. '-2+4x3' becomes '-2 2 6 10' - series starts at -2, then 3 further samples incrementing by 4.
#     2. ' 1-2x4' becomes '1 -1 -3 -5 -7' - series starts at 1, then 4 further samples decrementing by 2.
#     3. ' 1x4' becomes '1 1 1 1 1' - shorthand for '1+0x4', series starts at 1, then 4 further samples incrementing by 0.
#     4. ' 1 _x3 stale' becomes '1 _ _ _ stale' - the missing sample cannot increment, so 3 missing samples are produced by the '_x3' expression.
values: <string>
```

### `<alert_test_case>`

Prometheus allows you to have same alertname for different alerting  rules. Hence in this unit testing, you have to list the union of all the firing alerts for the alertname under a single `<alert_test_case>`.

```
# The time elapsed from time=0s when the alerts have to be checked.
eval_time: <duration>

# Name of the alert to be tested.
alertname: <string>

# List of expected alerts which are firing under the given alertname at
# given evaluation time. If you want to test if an alerting rule should
# not be firing, then you can mention the above fields and leave 'exp_alerts' empty.
exp_alerts:
  [ - <alert> ]
```

### `<alert>`

```
# These are the expanded labels and annotations of the expected alert.
# Note: labels also include the labels of the sample associated with the
# alert (same as what you see in `/alerts`, without series `__name__` and `alertname`)
exp_labels:
  [ <labelname>: <string> ]
exp_annotations:
  [ <labelname>: <string> ]
```

### `<promql_test_case>`

```
# Expression to evaluate
expr: <string>

# The time elapsed from time=0s when the expression has to be evaluated.
eval_time: <duration>

# Expected samples at the given evaluation time.
exp_samples:
  [ - <sample> ]
```

### `<sample>`

```
# Labels of the sample in usual series notation '<metric name>{<label name>=<label value>, ...}'
# Examples:
#      series_name{label1="value1", label2="value2"}
#      go_goroutines{job="prometheus", instance="localhost:9090"}
labels: <string>

# The expected value of the PromQL expression.
value: <number>
```

## Example

This is an example input file for unit testing which passes the test. `test.yml` is the test file which follows the syntax above and `alerts.yml` contains the alerting rules.

With `alerts.yml` in the same directory, run `./promtool test rules test.yml`.

### `test.yml`

```
# This is the main input for unit testing.
# Only this file is passed as command line argument.

rule_files:
    - alerts.yml

evaluation_interval: 1m

tests:
    # Test 1.
    - interval: 1m
      # Series data.
      input_series:
          - series: 'up{job="prometheus", instance="localhost:9090"}'
            values: '0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'
          - series: 'up{job="node_exporter", instance="localhost:9100"}'
            values: '1+0x6 0 0 0 0 0 0 0 0' # 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0
          - series: 'go_goroutines{job="prometheus", instance="localhost:9090"}'
            values: '10+10x2 30+20x5' # 10 20 30 30 50 70 90 110 130
          - series: 'go_goroutines{job="node_exporter", instance="localhost:9100"}'
            values: '10+10x7 10+30x4' # 10 20 30 40 50 60 70 80 10 40 70 100 130

      # Unit test for alerting rules.
      alert_rule_test:
          # Unit test 1.
          - eval_time: 10m
            alertname: InstanceDown
            exp_alerts:
                # Alert 1.
                - exp_labels:
                      severity: page
                      instance: localhost:9090
                      job: prometheus
                  exp_annotations:
                      summary: "Instance localhost:9090 down"
                      description: "localhost:9090 of job prometheus has been down for more than 5 minutes."
      # Unit tests for promql expressions.
      promql_expr_test:
          # Unit test 1.
          - expr: go_goroutines > 5
            eval_time: 4m
            exp_samples:
                # Sample 1.
                - labels: 'go_goroutines{job="prometheus",instance="localhost:9090"}'
                  value: 50
                # Sample 2.
                - labels: 'go_goroutines{job="node_exporter",instance="localhost:9100"}'
                  value: 50
```

### `alerts.yml`

```
# This is the rules file.

groups:
- name: example
  rules:

  - alert: InstanceDown
    expr: up == 0
    for: 5m
    labels:
        severity: page
    annotations:
        summary: "Instance {{ $labels.instance }} down"
        description: "{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes."

  - alert: AnotherInstanceDown
    expr: up == 0
    for: 10m
    labels:
        severity: page
    annotations:
        summary: "Instance {{ $labels.instance }} down"
        description: "{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes."
```

# HTTPS and authentication

Prometheus supports basic authentication and TLS. This is **experimental** and might change in the future.

To specify which web configuration file to load, use the `--web.config.file` flag.

The file is written in [YAML format](https://en.wikipedia.org/wiki/YAML), defined by the scheme described below. Brackets indicate that a parameter is optional. For non-list parameters the value is set to the specified default.

The file is read upon every http request, such as any change in the configuration and the certificates is picked up immediately.

Generic placeholders are defined as follows:

- `<boolean>`: a boolean that can take the values `true` or `false`
- `<filename>`: a valid path in the current working directory
- `<secret>`: a regular string that is a secret, such as a password
- `<string>`: a regular string

A valid example file can be found [here](https://github.com/prometheus/prometheus/blob/release-2.43/documentation/examples/web-config.yml).

```
tls_server_config:
  # Certificate and key files for server to use to authenticate to client.
  cert_file: <filename>
  key_file: <filename>

  # Server policy for client authentication. Maps to ClientAuth Policies.
  # For more detail on clientAuth options:
  # https://golang.org/pkg/crypto/tls/#ClientAuthType
  #
  # NOTE: If you want to enable client authentication, you need to use
  # RequireAndVerifyClientCert. Other values are insecure.
  [ client_auth_type: <string> | default = "NoClientCert" ]

  # CA certificate for client certificate authentication to the server.
  [ client_ca_file: <filename> ]

  # Minimum TLS version that is acceptable.
  [ min_version: <string> | default = "TLS12" ]

  # Maximum TLS version that is acceptable.
  [ max_version: <string> | default = "TLS13" ]

  # List of supported cipher suites for TLS versions up to TLS 1.2. If empty,
  # Go default cipher suites are used. Available cipher suites are documented
  # in the go documentation:
  # https://golang.org/pkg/crypto/tls/#pkg-constants
  #
  # Note that only the cipher returned by the following function are supported:
  # https://pkg.go.dev/crypto/tls#CipherSuites
  [ cipher_suites:
    [ - <string> ] ]

  # prefer_server_cipher_suites controls whether the server selects the
  # client's most preferred ciphersuite, or the server's most preferred
  # ciphersuite. If true then the server's preference, as expressed in
  # the order of elements in cipher_suites, is used.
  [ prefer_server_cipher_suites: <bool> | default = true ]

  # Elliptic curves that will be used in an ECDHE handshake, in preference
  # order. Available curves are documented in the go documentation:
  # https://golang.org/pkg/crypto/tls/#CurveID
  [ curve_preferences:
    [ - <string> ] ]

http_server_config:
  # Enable HTTP/2 support. Note that HTTP/2 is only supported with TLS.
  # This can not be changed on the fly.
  [ http2: <boolean> | default = true ]
  # List of headers that can be added to HTTP responses.
  [ headers:
    # Set the Content-Security-Policy header to HTTP responses.
    # Unset if blank.
    [ Content-Security-Policy: <string> ]
    # Set the X-Frame-Options header to HTTP responses.
    # Unset if blank. Accepted values are deny and sameorigin.
    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options
    [ X-Frame-Options: <string> ]
    # Set the X-Content-Type-Options header to HTTP responses.
    # Unset if blank. Accepted value is nosniff.
    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Content-Type-Options
    [ X-Content-Type-Options: <string> ]
    # Set the X-XSS-Protection header to all responses.
    # Unset if blank.
    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-XSS-Protection
    [ X-XSS-Protection: <string> ]
    # Set the Strict-Transport-Security header to HTTP responses.
    # Unset if blank.
    # Please make sure that you use this with care as this header might force
    # browsers to load Prometheus and the other applications hosted on the same
    # domain and subdomains over HTTPS.
    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security
    [ Strict-Transport-Security: <string> ] ]

# Usernames and hashed passwords that have full access to the web
# server via basic authentication. If empty, no basic authentication is
# required. Passwords are hashed with bcrypt.
basic_auth_users:
  [ <string>: <secret> ... ]
```

# Querying Prometheus

- [Examples ](https://prometheus.io/docs/prometheus/latest/querying/basics/#examples)

- [Expression language data types ](https://prometheus.io/docs/prometheus/latest/querying/basics/#expression-language-data-types)

- [Literals ](https://prometheus.io/docs/prometheus/latest/querying/basics/#literals)

- - [String literals ](https://prometheus.io/docs/prometheus/latest/querying/basics/#string-literals)
  - [Float literals ](https://prometheus.io/docs/prometheus/latest/querying/basics/#float-literals)

- [Time series Selectors ](https://prometheus.io/docs/prometheus/latest/querying/basics/#time-series-selectors)

- - [Instant vector selectors ](https://prometheus.io/docs/prometheus/latest/querying/basics/#instant-vector-selectors)
  - [Range Vector Selectors ](https://prometheus.io/docs/prometheus/latest/querying/basics/#range-vector-selectors)
  - [Time Durations ](https://prometheus.io/docs/prometheus/latest/querying/basics/#time-durations)
  - [Offset modifier ](https://prometheus.io/docs/prometheus/latest/querying/basics/#offset-modifier)
  - [@ modifier ](https://prometheus.io/docs/prometheus/latest/querying/basics/#modifier)

- [Subquery ](https://prometheus.io/docs/prometheus/latest/querying/basics/#subquery)

- [Operators ](https://prometheus.io/docs/prometheus/latest/querying/basics/#operators)

- [Functions ](https://prometheus.io/docs/prometheus/latest/querying/basics/#functions)

- [Comments ](https://prometheus.io/docs/prometheus/latest/querying/basics/#comments)

- [Gotchas ](https://prometheus.io/docs/prometheus/latest/querying/basics/#gotchas)

- - [Staleness ](https://prometheus.io/docs/prometheus/latest/querying/basics/#staleness)
  - [Avoiding slow queries and overloads ](https://prometheus.io/docs/prometheus/latest/querying/basics/#avoiding-slow-queries-and-overloads)

Prometheus provides a functional query language called PromQL (Prometheus Query Language) that lets the user select and aggregate time series data in real time. The result of an expression can either be shown as a graph, viewed as tabular data in Prometheus's expression browser, or consumed by external systems via the [HTTP API](https://prometheus.io/docs/prometheus/latest/querying/api/).

## Examples

This document is meant as a reference. For learning, it might be easier to start with a couple of [examples](https://prometheus.io/docs/prometheus/latest/querying/examples/).

## Expression language data types

In Prometheus's expression language, an expression or sub-expression can evaluate to one of four types:

- **Instant vector** - a set of time series containing a single sample for each time series, all sharing the same timestamp
- **Range vector** - a set of time series containing a range of data points over time for each time series
- **Scalar** - a simple numeric floating point value
- **String** - a simple string value; currently unused

Depending on the use-case (e.g. when graphing vs. displaying the output of an expression), only some of these types are legal as the result from a user-specified expression. For example, an expression that returns an instant vector is the only type that can be directly graphed.

*Notes about the experimental native histograms:*

- Ingesting native histograms has to be enabled via a [feature flag](https://prometheus.io/docs/prometheus/latest/querying/feature_flags/#native-histograms).
- Once native histograms have been ingested into the TSDB (and even after disabling the feature flag again), both instant vectors and range vectors may now contain samples that aren't simple floating point numbers (float samples) but complete histograms (histogram samples). A vector may contain a mix of float samples and histogram samples.

## Literals

### String literals

Strings may be specified as literals in single quotes, double quotes or backticks.

PromQL follows the same [escaping rules as Go](https://golang.org/ref/spec#String_literals). In single or double quotes a backslash begins an escape sequence, which may be followed by `a`, `b`, `f`, `n`, `r`, `t`, `v` or `\`. Specific characters can be provided using octal (`\nnn`) or hexadecimal (`\xnn`, `\unnnn` and `\Unnnnnnnn`).

No escaping is processed inside backticks. Unlike Go, Prometheus does not discard newlines inside backticks.

Example:

```
"this is a string"
'these are unescaped: \n \\ \t'
`these are not unescaped: \n ' " \t`
```

### Float literals

Scalar float values can be written as literal integer or  floating-point numbers in the format (whitespace only included for  better readability):

```
[-+]?(
      [0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?
    | 0[xX][0-9a-fA-F]+
    | [nN][aA][nN]
    | [iI][nN][fF]
)
```

Examples:

```
23
-2.43
3.4e-9
0x8f
-Inf
NaN
```

## Time series Selectors

### Instant vector selectors

Instant vector selectors allow the selection of a set of time series and a single sample value for each at a given timestamp (instant): in the simplest form, only a metric name is specified. This results in an instant vector containing elements for all time series that have this metric name.

This example selects all time series that have the `http_requests_total` metric name:

```
http_requests_total
```

It is possible to filter these time series further by appending a comma separated list of label matchers in curly braces (`{}`).

This example selects only those time series with the `http_requests_total` metric name that also have the `job` label set to `prometheus` and their `group` label set to `canary`:

```
http_requests_total{job="prometheus",group="canary"}
```

It is also possible to negatively match a label value, or to match label values against regular expressions. The following label matching operators exist:

- `=`: Select labels that are exactly equal to the provided string.
- `!=`: Select labels that are not equal to the provided string.
- `=~`: Select labels that regex-match the provided string.
- `!~`: Select labels that do not regex-match the provided string.

Regex matches are fully anchored. A match of `env=~"foo"` is treated as `env=~"^foo$"`.

For example, this selects all `http_requests_total` time series for `staging`, `testing`, and `development` environments and HTTP methods other than `GET`.

```
http_requests_total{environment=~"staging|testing|development",method!="GET"}
```

Label matchers that match empty label values also select all time series that do not have the specific label set at all. It is possible to have multiple matchers for the same label name.

Vector selectors must either specify a name or at least one label matcher that does not match the empty string. The following expression is illegal:

```
{job=~".*"} # Bad!
```

In contrast, these expressions are valid as they both have a selector that does not match empty label values.

```
{job=~".+"}              # Good!
{job=~".*",method="get"} # Good!
```

Label matchers can also be applied to metric names by matching against the internal `__name__` label. For example, the expression `http_requests_total` is equivalent to `{__name__="http_requests_total"}`. Matchers other than `=` (`!=`, `=~`, `!~`) may also be used. The following expression selects all metrics that have a name starting with `job:`:

```
{__name__=~"job:.*"}
```

The metric name must not be one of the keywords `bool`, `on`, `ignoring`, `group_left` and `group_right`. The following expression is illegal:

```
on{} # Bad!
```

A workaround for this restriction is to use the `__name__` label:

```
{__name__="on"} # Good!
```

All regular expressions in Prometheus use [RE2 syntax](https://github.com/google/re2/wiki/Syntax).

### Range Vector Selectors

Range vector literals work like instant vector literals, except that they select a range of samples back from the current instant. Syntactically, a [time duration](https://prometheus.io/docs/prometheus/latest/querying/basics/#time-durations) is appended in square brackets (`[]`) at the end of a vector selector to specify how far back in time values should be fetched for each resulting range vector element.

In this example, we select all the values we have recorded within the last 5 minutes for all time series that have the metric name `http_requests_total` and a `job` label set to `prometheus`:

```
http_requests_total{job="prometheus"}[5m]
```

### Time Durations

Time durations are specified as a number, followed immediately by one of the following units:

- `ms` - milliseconds
- `s` - seconds
- `m` - minutes
- `h` - hours
- `d` - days - assuming a day has always 24h
- `w` - weeks - assuming a week has always 7d
- `y` - years - assuming a year has always 365d

Time durations can be combined, by concatenation. Units must be ordered from the longest to the shortest. A given unit must only appear once in a time duration.

Here are some examples of valid time durations:

```
5h
1h30m
5m
10s
```

### Offset modifier

The `offset` modifier allows changing the time offset for individual instant and range vectors in a query.

For example, the following expression returns the value of `http_requests_total` 5 minutes in the past relative to the current query evaluation time:

```
http_requests_total offset 5m
```

Note that the `offset` modifier always needs to follow the selector immediately, i.e. the following would be correct:

```
sum(http_requests_total{method="GET"} offset 5m) // GOOD.
```

While the following would be *incorrect*:

```
sum(http_requests_total{method="GET"}) offset 5m // INVALID.
```

The same works for range vectors. This returns the 5-minute rate that `http_requests_total` had a week ago:

```
rate(http_requests_total[5m] offset 1w)
```

For comparisons with temporal shifts forward in time, a negative offset can be specified:

```
rate(http_requests_total[5m] offset -1w)
```

Note that this allows a query to look ahead of its evaluation time.

### @ modifier

The `@` modifier allows changing the evaluation time for individual instant and range vectors in a query. The time supplied to the `@` modifier is a unix timestamp and described with a float literal. 

For example, the following expression returns the value of `http_requests_total` at `2021-01-04T07:40:00+00:00`:

```
http_requests_total @ 1609746000
```

Note that the `@` modifier always needs to follow the selector immediately, i.e. the following would be correct:

```
sum(http_requests_total{method="GET"} @ 1609746000) // GOOD.
```

While the following would be *incorrect*:

```
sum(http_requests_total{method="GET"}) @ 1609746000 // INVALID.
```

The same works for range vectors. This returns the 5-minute rate that `http_requests_total` had at `2021-01-04T07:40:00+00:00`:

```
rate(http_requests_total[5m] @ 1609746000)
```

The `@` modifier supports all representation of float literals described above within the limits of `int64`. It can also be used along with the `offset` modifier where the offset is applied relative to the `@` modifier time irrespective of which modifier is written first. These 2 queries will produce the same result.

```
# offset after @
http_requests_total @ 1609746000 offset 5m
# offset before @
http_requests_total offset 5m @ 1609746000
```

Additionally, `start()` and `end()` can also be used as values for the `@` modifier as special values.

For a range query, they resolve to the start and end of the range query respectively and remain the same for all steps.

For an instant query, `start()` and `end()` both resolve to the evaluation time.

```
http_requests_total @ start()
rate(http_requests_total[5m] @ end())
```

Note that the `@` modifier allows a query to look ahead of its evaluation time.

## Subquery

Subquery allows you to run an instant query for a given range and resolution. The result of a subquery is a range vector.

Syntax: `<instant_query> '[' <range> ':' [<resolution>] ']' [ @ <float_literal> ] [ offset <duration> ]`

- `<resolution>` is optional. Default is the global evaluation interval.

## Operators

Prometheus supports many binary and aggregation operators. These are described in detail in the [expression language operators](https://prometheus.io/docs/prometheus/latest/querying/operators/) page.

## Functions

Prometheus supports several functions to operate on data. These are described in detail in the [expression language functions](https://prometheus.io/docs/prometheus/latest/querying/functions/) page.

## Comments

PromQL supports line comments that start with `#`. Example:

```
    # This is a comment
```

## Gotchas

### Staleness

When queries are run, timestamps at which to sample data are selected independently of the actual present time series data. This is mainly to support cases like aggregation (`sum`, `avg`, and so on), where multiple aggregated time series do not exactly align in time. Because of their independence, Prometheus needs to assign a value at those timestamps for each relevant time series. It does so by simply taking the newest sample before this timestamp.

If a target scrape or rule evaluation no longer returns a sample for a time series that was previously present, that time series will be marked as stale. If a target is removed, its previously returned time series will be marked as stale soon afterwards.

If a query is evaluated at a sampling timestamp after a time series is marked stale, then no value is returned for that time series. If new samples are subsequently ingested for that time series, they will be returned as normal.

If no sample is found (by default) 5 minutes before a sampling timestamp, no value is returned for that time series at this point in time. This effectively means that time series "disappear" from graphs at times where their latest collected sample is older than 5 minutes or after they are marked stale.

Staleness will not be marked for time series that have timestamps included in their scrapes. Only the 5 minute threshold will be applied in that case.

### Avoiding slow queries and overloads

If a query needs to operate on a very large amount of data, graphing it might time out or overload the server or browser. Thus, when constructing queries over unknown data, always start building the query in the tabular view of Prometheus's expression browser until the result set seems reasonable (hundreds, not thousands, of time series at most).  Only when you have filtered or aggregated your data sufficiently, switch to graph mode. If the expression still takes too long to graph ad-hoc, pre-record it via a [recording rule](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/#recording-rules).

This is especially relevant for Prometheus's query language, where a bare metric name selector like `api_http_requests_total` could expand to thousands of time series with different labels. Also keep in mind that expressions which aggregate over many time series will generate load on the server even if the output is only a small number of time series. This is similar to how it would be slow to sum all values of a column in a relational database, even if the output value is only a single number.

# Operators

- [Binary operators ](https://prometheus.io/docs/prometheus/latest/querying/operators/#binary-operators)

- - [Arithmetic binary operators ](https://prometheus.io/docs/prometheus/latest/querying/operators/#arithmetic-binary-operators)
  - [Trigonometric binary operators ](https://prometheus.io/docs/prometheus/latest/querying/operators/#trigonometric-binary-operators)
  - [Comparison binary operators ](https://prometheus.io/docs/prometheus/latest/querying/operators/#comparison-binary-operators)
  - [Logical/set binary operators ](https://prometheus.io/docs/prometheus/latest/querying/operators/#logical-set-binary-operators)

- [Vector matching ](https://prometheus.io/docs/prometheus/latest/querying/operators/#vector-matching)

- - [Vector matching keywords ](https://prometheus.io/docs/prometheus/latest/querying/operators/#vector-matching-keywords)
  - [Group modifiers ](https://prometheus.io/docs/prometheus/latest/querying/operators/#group-modifiers)
  - [One-to-one vector matches ](https://prometheus.io/docs/prometheus/latest/querying/operators/#one-to-one-vector-matches)
  - [Many-to-one and one-to-many vector matches ](https://prometheus.io/docs/prometheus/latest/querying/operators/#many-to-one-and-one-to-many-vector-matches)

- [Aggregation operators ](https://prometheus.io/docs/prometheus/latest/querying/operators/#aggregation-operators)

- [Binary operator precedence ](https://prometheus.io/docs/prometheus/latest/querying/operators/#binary-operator-precedence)

- [Operators for native histograms ](https://prometheus.io/docs/prometheus/latest/querying/operators/#operators-for-native-histograms)

## Binary operators

Prometheus's query language supports basic logical and arithmetic operators. For operations between two instant vectors, the [matching behavior](https://prometheus.io/docs/prometheus/latest/querying/operators/#vector-matching) can be modified.

### Arithmetic binary operators

The following binary arithmetic operators exist in Prometheus:

- `+` (addition)
- `-` (subtraction)
- `*` (multiplication)
- `/` (division)
- `%` (modulo)
- `^` (power/exponentiation)

Binary arithmetic operators are defined between scalar/scalar, vector/scalar, and vector/vector value pairs.

**Between two scalars**, the behavior is obvious: they evaluate to another scalar that is the result of the operator applied to both scalar operands.

**Between an instant vector and a scalar**, the operator is applied to the value of every data sample in the vector. E.g. if a time series instant vector is multiplied by 2, the result is another vector in which every sample value of the original vector is multiplied by 2. The metric name is dropped.

**Between two instant vectors**, a binary arithmetic operator is applied to each entry in the left-hand side vector and its [matching element](https://prometheus.io/docs/prometheus/latest/querying/operators/#vector-matching) in the right-hand vector. The result is propagated into the result vector with the grouping labels becoming the output label set. The metric name is dropped. Entries for which no matching entry in the right-hand vector can be found are not part of the result.

### Trigonometric binary operators

The following trigonometric binary operators, which work in radians, exist in Prometheus:

- `atan2` (based on https://pkg.go.dev/math#Atan2)

Trigonometric operators allow trigonometric functions to be executed on two vectors using vector matching, which isn't available with normal functions. They act in the same manner as arithmetic operators.

### Comparison binary operators

The following binary comparison operators exist in Prometheus:

- `==` (equal)
- `!=` (not-equal)
- `>` (greater-than)
- `<` (less-than)
- `>=` (greater-or-equal)
- `<=` (less-or-equal)

Comparison operators are defined between scalar/scalar, vector/scalar, and vector/vector value pairs. By default they filter. Their behavior can be modified by providing `bool` after the operator, which will return `0` or `1` for the value rather than filtering.

**Between two scalars**, the `bool` modifier must be provided and these operators result in another scalar that is either `0` (`false`) or `1` (`true`), depending on the comparison result.

**Between an instant vector and a scalar**, these operators are applied to the value of every data sample in the vector, and vector elements between which the comparison result is `false` get dropped from the result vector. If the `bool` modifier is provided, vector elements that would be dropped instead have the value `0` and vector elements that would be kept have the value `1`. The metric name is dropped if the `bool` modifier is provided.

**Between two instant vectors**, these operators behave as a filter by default, applied to matching entries. Vector elements for which the expression is not true or which do not find a match on the other side of the expression get dropped from the result, while the others are propagated into a result vector with the grouping labels becoming the output label set. If the `bool` modifier is provided, vector elements that would have been dropped instead have the value `0` and vector elements that would be kept have the value `1`, with the grouping labels again becoming the output label set. The metric name is dropped if the `bool` modifier is provided.

### Logical/set binary operators

These logical/set binary operators are only defined between instant vectors:

- `and` (intersection)
- `or` (union)
- `unless` (complement)

`vector1 and vector2` results in a vector consisting of the elements of `vector1` for which there are elements in `vector2` with exactly matching label sets. Other elements are dropped. The metric name and values are carried over from the left-hand side vector.

`vector1 or vector2` results in a vector that contains all original elements (label sets + values) of `vector1` and additionally all elements of `vector2` which do not have matching label sets in `vector1`.

`vector1 unless vector2` results in a vector consisting of the elements of `vector1` for which there are no elements in `vector2` with exactly matching label sets. All matching elements in both vectors are dropped.

## Vector matching

Operations between vectors attempt to find a matching element in the right-hand side vector for each entry in the left-hand side. There are two basic types of matching behavior: One-to-one and many-to-one/one-to-many.

### Vector matching keywords

These vector matching keywords allow for matching between series with different label sets providing:

- `on`
- `ignoring`

Label lists provided to matching keywords will determine how vectors are combined. Examples can be found in [One-to-one vector matches](https://prometheus.io/docs/prometheus/latest/querying/operators/#one-to-one-vector-matches) and in [Many-to-one and one-to-many vector matches](https://prometheus.io/docs/prometheus/latest/querying/operators/#many-to-one-and-one-to-many-vector-matches)

### Group modifiers

These group modifiers enable many-to-one/one-to-many vector matching:

- `group_left`
- `group_right`

Label lists can be provided to the group modifier which contain labels from the "one"-side to be included in the result metrics.

*Many-to-one and one-to-many matching are advanced use cases that should be carefully considered. Often a proper use of `ignoring(<labels>)` provides the desired outcome.*

*Grouping modifiers can only be used for [comparison](https://prometheus.io/docs/prometheus/latest/querying/operators/#comparison-binary-operators) and [arithmetic](https://prometheus.io/docs/prometheus/latest/querying/operators/#arithmetic-binary-operators). Operations as `and`, `unless` and `or` operations match with all possible entries in the right vector by default.*

### One-to-one vector matches

**One-to-one** finds a unique pair of entries from each side of the operation. In the default case, that is an operation following the format `vector1 <operator> vector2`. Two entries match if they have the exact same set of labels and corresponding values. The `ignoring` keyword allows ignoring certain labels when matching, while the `on` keyword allows reducing the set of considered labels to a provided list:

```
<vector expr> <bin-op> ignoring(<label list>) <vector expr>
<vector expr> <bin-op> on(<label list>) <vector expr>
```

Example input:

```
method_code:http_errors:rate5m{method="get", code="500"}  24
method_code:http_errors:rate5m{method="get", code="404"}  30
method_code:http_errors:rate5m{method="put", code="501"}  3
method_code:http_errors:rate5m{method="post", code="500"} 6
method_code:http_errors:rate5m{method="post", code="404"} 21

method:http_requests:rate5m{method="get"}  600
method:http_requests:rate5m{method="del"}  34
method:http_requests:rate5m{method="post"} 120
```

Example query:

```
method_code:http_errors:rate5m{code="500"} / ignoring(code) method:http_requests:rate5m
```

This returns a result vector containing the fraction of HTTP requests with status code of 500 for each method, as measured over the last 5 minutes. Without `ignoring(code)` there would have been no match as the metrics do not share the same set of labels. The entries with methods `put` and `del` have no match and will not show up in the result:

```
{method="get"}  0.04            //  24 / 600
{method="post"} 0.05            //   6 / 120
```

### Many-to-one and one-to-many vector matches

**Many-to-one** and **one-to-many** matchings refer to the case where each vector element on the "one"-side can match with multiple elements on the "many"-side. This has to be explicitly requested using the `group_left` or `group_right` [modifiers](https://prometheus.io/docs/prometheus/latest/querying/operators/#group-modifiers), where left/right determines which vector has the higher cardinality.

```
<vector expr> <bin-op> ignoring(<label list>) group_left(<label list>) <vector expr>
<vector expr> <bin-op> ignoring(<label list>) group_right(<label list>) <vector expr>
<vector expr> <bin-op> on(<label list>) group_left(<label list>) <vector expr>
<vector expr> <bin-op> on(<label list>) group_right(<label list>) <vector expr>
```

The label list provided with the [group modifier](https://prometheus.io/docs/prometheus/latest/querying/operators/#group-modifiers) contains additional labels from the "one"-side to be included in the result metrics. For `on` a label can only appear in one of the lists. Every time series of the result vector must be uniquely identifiable.

Example query:

```
method_code:http_errors:rate5m / ignoring(code) group_left method:http_requests:rate5m
```

In this case the left vector contains more than one entry per `method` label value. Thus, we indicate this using `group_left`. The elements from the right side are now matched with multiple elements with the same `method` label on the left:

```
{method="get", code="500"}  0.04            //  24 / 600
{method="get", code="404"}  0.05            //  30 / 600
{method="post", code="500"} 0.05            //   6 / 120
{method="post", code="404"} 0.175           //  21 / 120
```

## Aggregation operators

Prometheus supports the following built-in aggregation operators that can be used to aggregate the elements of a single instant vector, resulting in a new vector of fewer elements with aggregated values:

- `sum` (calculate sum over dimensions)
- `min` (select minimum over dimensions)
- `max` (select maximum over dimensions)
- `avg` (calculate the average over dimensions)
- `group` (all values in the resulting vector are 1)
- `stddev` (calculate population standard deviation over dimensions)
- `stdvar` (calculate population standard variance over dimensions)
- `count` (count number of elements in the vector)
- `count_values` (count number of elements with the same value)
- `bottomk` (smallest k elements by sample value)
- `topk` (largest k elements by sample value)
- `quantile` (calculate φ-quantile (0 ≤ φ ≤ 1) over dimensions)

These operators can either be used to aggregate over **all** label dimensions or preserve distinct dimensions by including a `without` or `by` clause. These clauses may be used before or after the expression.

```
<aggr-op> [without|by (<label list>)] ([parameter,] <vector expression>)
```

or

```
<aggr-op>([parameter,] <vector expression>) [without|by (<label list>)]
```

`label list` is a list of unquoted labels that may include a trailing comma, i.e. both `(label1, label2)` and `(label1, label2,)` are valid syntax.

`without` removes the listed labels from the result vector, while all other labels are preserved in the output. `by` does the opposite and drops labels that are not listed in the `by` clause, even if their label values are identical between all elements of the vector.

`parameter` is only required for `count_values`, `quantile`, `topk` and `bottomk`.

`count_values` outputs one time series per unique sample value. Each series has an additional label. The name of that label is given by the aggregation parameter, and the label value is the unique sample value. The value of each time series is the number of times that sample value was present.

`topk` and `bottomk` are different from other aggregators in that a subset of the input samples, including the original labels, are returned in the result vector. `by` and `without` are only used to bucket the input vector.

`quantile` calculates the φ-quantile, the value that ranks at number φ*N among the N metric values of the dimensions aggregated over. φ is provided as the aggregation parameter. For example, `quantile(0.5, ...)` calculates the median, `quantile(0.95, ...)` the 95th percentile. For φ = `NaN`, `NaN` is returned. For φ < 0, `-Inf` is returned. For φ > 1, `+Inf` is returned.

Example:

If the metric `http_requests_total` had time series that fan out by `application`, `instance`, and `group` labels, we could calculate the total number of seen HTTP requests per application and group over all instances via:

```
sum without (instance) (http_requests_total)
```

Which is equivalent to:

```
 sum by (application, group) (http_requests_total)
```

If we are just interested in the total of HTTP requests we have seen in **all** applications, we could simply write:

```
sum(http_requests_total)
```

To count the number of binaries running each build version we could write:

```
count_values("version", build_version)
```

To get the 5 largest HTTP requests counts across all instances we could write:

```
topk(5, http_requests_total)
```

## Binary operator precedence

The following list shows the precedence of binary operators in Prometheus, from highest to lowest.

1. `^`
2. `*`, `/`, `%`, `atan2`
3. `+`, `-`
4. `==`, `!=`, `<=`, `<`, `>=`, `>`
5. `and`, `unless`
6. `or`

Operators on the same precedence level are left-associative. For example, `2 * 3 % 2` is equivalent to `(2 * 3) % 2`. However `^` is right associative, so `2 ^ 3 ^ 2` is equivalent to `2 ^ (3 ^ 2)`.

## Operators for native histograms

Native histograms are an experimental feature. Ingesting native histograms has to be enabled via a [feature flag](https://prometheus.io/docs/prometheus/latest/querying/feature_flags/#native-histograms). Once native histograms have been ingested, they can be queried (even after the feature flag has been disabled again). However, the operator support for native histograms is still very limited.

Logical/set binary operators work as expected even if histogram samples are involved. They only check for the existence of a vector element and don't change their behavior depending on the sample type of an element (float or histogram).

The binary `+` operator between two native histograms and the `sum` aggregation operator to aggregate native histograms are fully supported. Even if the histograms involved have different bucket layouts, the buckets are automatically converted appropriately so that the operation can be performed. (With the currently supported bucket schemas, that's always possible.) If either operator has to sum up a mix of histogram samples and float samples, the corresponding vector element is removed from the output vector entirely.

All other operators do not behave in a meaningful way. They either treat the histogram sample as if it were a float sample of value 0, or (in case of arithmetic operations between a scalar and a vector) they leave the histogram sample unchanged. This behavior will change to a meaningful one before native histograms are a stable feature.

# Functions

- [ `abs()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#abs)
- [ `absent()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#absent)
- [ `absent_over_time()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#absent_over_time)
- [ `ceil()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#ceil)
- [ `changes()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#changes)
- [ `clamp()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#clamp)
- [ `clamp_max()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#clamp_max)
- [ `clamp_min()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#clamp_min)
- [ `day_of_month()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#day_of_month)
- [ `day_of_week()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#day_of_week)
- [ `day_of_year()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#day_of_year)
- [ `days_in_month()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#days_in_month)
- [ `delta()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#delta)
- [ `deriv()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#deriv)
- [ `exp()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#exp)
- [ `floor()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#floor)
- [ `histogram_count()` and `histogram_sum()`  ](https://prometheus.io/docs/prometheus/latest/querying/functions/#histogram_count-and-histogram_sum)
- [ `histogram_fraction()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#histogram_fraction)
- [ `histogram_quantile()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#histogram_quantile)
- [ `holt_winters()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#holt_winters)
- [ `hour()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#hour)
- [ `idelta()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#idelta)
- [ `increase()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#increase)
- [ `irate()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#irate)
- [ `label_join()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#label_join)
- [ `label_replace()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#label_replace)
- [ `ln()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#ln)
- [ `log2()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#log2)
- [ `log10()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#log10)
- [ `minute()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#minute)
- [ `month()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#month)
- [ `predict_linear()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#predict_linear)
- [ `rate()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#rate)
- [ `resets()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#resets)
- [ `round()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#round)
- [ `scalar()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#scalar)
- [ `sgn()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#sgn)
- [ `sort()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#sort)
- [ `sort_desc()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#sort_desc)
- [ `sqrt()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#sqrt)
- [ `time()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#time)
- [ `timestamp()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#timestamp)
- [ `vector()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#vector)
- [ `year()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#year)
- [ `_over_time()` ](https://prometheus.io/docs/prometheus/latest/querying/functions/#aggregation_over_time)
- [Trigonometric Functions ](https://prometheus.io/docs/prometheus/latest/querying/functions/#trigonometric-functions)

Some functions have default arguments, e.g. `year(v=vector(time()) instant-vector)`. This means that there is one argument `v` which is an instant vector, which if not provided it will default to the value of the expression `vector(time())`.

*Notes about the experimental native histograms:*

- Ingesting native histograms has to be enabled via a [feature flag](https://prometheus.io/docs/prometheus/latest/querying/feature_flags/#native-histograms). As long as no native histograms have been ingested into the TSDB, all functions will behave as usual.
- Functions that do not explicitly mention native histograms in their documentation (see below) effectively treat a native histogram as a float sample of value 0. (This is confusing and will change before native histograms become a stable feature.)
- Functions that do already act on native histograms might still change their behavior in the future.
- If a function requires the same bucket layout between multiple native histograms it acts on, it will automatically convert them appropriately. (With the currently supported bucket schemas, that's always possible.)

## `abs()`

`abs(v instant-vector)` returns the input vector with all sample values converted to their absolute value.

## `absent()`

`absent(v instant-vector)` returns an empty vector if the vector passed to it has any elements (floats or native histograms) and a 1-element vector with the value 1 if the vector passed to it has no elements.

This is useful for alerting on when no time series exist for a given metric name and label combination.

```
absent(nonexistent{job="myjob"})
# => {job="myjob"}

absent(nonexistent{job="myjob",instance=~".*"})
# => {job="myjob"}

absent(sum(nonexistent{job="myjob"}))
# => {}
```

In the first two examples, `absent()` tries to be smart about deriving labels of the 1-element output vector from the input vector.

## `absent_over_time()`

`absent_over_time(v range-vector)` returns an empty vector if the range vector passed to it has any elements (floats or native histograms) and a 1-element vector with the value 1 if the range vector passed to it has no elements.

This is useful for alerting on when no time series exist for a given metric name and label combination for a certain amount of time.

```
absent_over_time(nonexistent{job="myjob"}[1h])
# => {job="myjob"}

absent_over_time(nonexistent{job="myjob",instance=~".*"}[1h])
# => {job="myjob"}

absent_over_time(sum(nonexistent{job="myjob"})[1h:])
# => {}
```

In the first two examples, `absent_over_time()` tries to be smart about deriving labels of the 1-element output vector from the input vector.

## `ceil()`

`ceil(v instant-vector)` rounds the sample values of all elements in `v` up to the nearest integer.

## `changes()`

For each input time series, `changes(v range-vector)` returns the number of times its value has changed within the provided time range as an instant vector.

## `clamp()`

`clamp(v instant-vector, min scalar, max scalar)` clamps the sample values of all elements in `v` to have a lower limit of `min` and an upper limit of `max`.

Special cases: - Return an empty vector if `min > max` - Return `NaN` if `min` or `max` is `NaN`

## `clamp_max()`

`clamp_max(v instant-vector, max scalar)` clamps the sample values of all elements in `v` to have an upper limit of `max`.

## `clamp_min()`

`clamp_min(v instant-vector, min scalar)` clamps the sample values of all elements in `v` to have a lower limit of `min`.

## `day_of_month()`

`day_of_month(v=vector(time()) instant-vector)` returns the day of the month for each of the given times in UTC. Returned values are from 1 to 31.

## `day_of_week()`

`day_of_week(v=vector(time()) instant-vector)` returns the day of the week for each of the given times in UTC. Returned values are from 0 to 6, where 0 means Sunday etc.

## `day_of_year()`

`day_of_year(v=vector(time()) instant-vector)` returns the day of the year for each of the given times in UTC. Returned values are from 1 to 365 for non-leap years, and 1 to 366 in leap years.

## `days_in_month()`

`days_in_month(v=vector(time()) instant-vector)` returns number of days in the month for each of the given times in UTC. Returned values are from 28 to 31.

## `delta()`

`delta(v range-vector)` calculates the difference between the first and last value of each time series element in a range vector `v`, returning an instant vector with the given deltas and equivalent labels. The delta is extrapolated to cover the full time range as specified in the range vector selector, so that it is possible to get a non-integer result even if the sample values are all integers.

The following example expression returns the difference in CPU temperature between now and 2 hours ago:

```
delta(cpu_temp_celsius{host="zeus"}[2h])
```

`delta` acts on native histograms by calculating a new histogram where each compononent (sum and count of observations, buckets) is the difference between the respective component in the first and last native histogram in `v`. However, each element in `v` that contains a mix of float and native histogram samples within the range, will be missing from the result vector.

`delta` should only be used with gauges and native histograms where the components behave like gauges (so-called gauge histograms).

## `deriv()`

`deriv(v range-vector)` calculates the per-second derivative of the time series in a range vector `v`, using [simple linear regression](https://en.wikipedia.org/wiki/Simple_linear_regression). The range vector must have at least two samples in order to perform the calculation. When `+Inf` or  `-Inf` are found in the range vector, the slope and offset value calculated will be `NaN`.

`deriv` should only be used with gauges.

## `exp()`

`exp(v instant-vector)` calculates the exponential function for all elements in `v`. Special cases are:

- `Exp(+Inf) = +Inf`
- `Exp(NaN) = NaN`

## `floor()`

`floor(v instant-vector)` rounds the sample values of all elements in `v` down to the nearest integer.

## `histogram_count()` and `histogram_sum()`

*Both functions only act on native histograms, which are an experimental feature. The behavior of these functions may change in future versions of Prometheus, including their removal from PromQL.*

`histogram_count(v instant-vector)` returns the count of observations stored in a native histogram. Samples that are not native histograms are ignored and do not show up in the returned vector.

Similarly, `histogram_sum(v instant-vector)` returns the sum of observations stored in a native histogram.

Use `histogram_count` in the following way to calculate a rate of observations (in this case corresponding to “requests per second”) from a native histogram:

```
histogram_count(rate(http_request_duration_seconds[10m]))
```

The additional use of `histogram_sum` enables the calculation of the average of observed values (in this case corresponding to “average request duration”):

```
  histogram_sum(rate(http_request_duration_seconds[10m]))
/
  histogram_count(rate(http_request_duration_seconds[10m]))
```

## `histogram_fraction()`

*This function only acts on native histograms, which are an experimental feature. The behavior of this function may change in future versions of Prometheus, including its removal from PromQL.*

For a native histogram, `histogram_fraction(lower scalar, upper scalar, v instant-vector)` returns the estimated fraction of observations between the provided lower and upper values. Samples that are not native histograms are ignored and do not show up in the returned vector.

For example, the following expression calculates the fraction of HTTP requests over the last hour that took 200ms or less:

```
histogram_fraction(0, 0.2, rate(http_request_duration_seconds[1h]))
```

The error of the estimation depends on the resolution of the underlying native histogram and how closely the provided boundaries are aligned with the bucket boundaries in the histogram.

`+Inf` and `-Inf` are valid boundary values. For example, if the histogram in the expression above included negative observations (which shouldn't be the case for request durations), the appropriate lower boundary to include all observations less than or equal 0.2 would be `-Inf` rather than `0`.

Whether the provided boundaries are inclusive or exclusive is only relevant if the provided boundaries are precisely aligned with bucket boundaries in the underlying native histogram. In this case, the behavior depends on the schema definition of the histogram. The currently supported schemas all feature inclusive upper boundaries and exclusive lower boundaries for positive values (and vice versa for negative values). Without a precise alignment of boundaries, the function uses linear interpolation to estimate the fraction. With the resulting uncertainty, it becomes irrelevant if the boundaries are inclusive or exclusive.

## `histogram_quantile()`

`histogram_quantile(φ scalar, b instant-vector)` calculates the φ-quantile (0 ≤ φ ≤ 1) from a [conventional histogram](https://prometheus.io/docs/concepts/metric_types/#histogram) or from a native histogram. (See [histograms and summaries](https://prometheus.io/docs/practices/histograms) for a detailed explanation of φ-quantiles and the usage of the (conventional) histogram metric type in general.)

*Note that native histograms are an experimental feature. The behavior of this function when dealing with native histograms may change in future versions of Prometheus.*

The conventional float samples in `b` are considered the counts of observations in each bucket of one or more conventional histograms. Each float sample must have a label `le` where the label value denotes the inclusive upper bound of the bucket. (Float samples without such a label are silently ignored.) The other labels and the metric name are used to identify the buckets belonging to each conventional histogram. The [histogram metric type](https://prometheus.io/docs/concepts/metric_types/#histogram) automatically provides time series with the `_bucket` suffix and the appropriate labels.

The native histogram samples in `b` are treated each individually as a separate histogram to calculate the quantile from.

As long as no naming collisions arise, `b` may contain a mix of conventional and native histograms.

Use the `rate()` function to specify the time window for the quantile calculation.

Example: A histogram metric is called `http_request_duration_seconds` (and therefore the metric name for the buckets of a conventional histogram is `http_request_duration_seconds_bucket`). To calculate the 90th percentile of request durations over the last 10m, use the following expression in case `http_request_duration_seconds` is a conventional histogram:

```
histogram_quantile(0.9, rate(http_request_duration_seconds_bucket[10m]))
```

For a native histogram, use the following expression instead:

```
histogram_quantile(0.9, rate(http_request_duration_seconds[10m]))
```

The quantile is calculated for each label combination in `http_request_duration_seconds`. To aggregate, use the `sum()` aggregator around the `rate()` function. Since the `le` label is required by `histogram_quantile()` to deal with conventional histograms, it has to be included in the `by` clause. The following expression aggregates the 90th percentile by `job` for conventional histograms:

```
histogram_quantile(0.9, sum by (job, le) (rate(http_request_duration_seconds_bucket[10m])))
```

When aggregating native histograms, the expression simplifies to:

```
histogram_quantile(0.9, sum by (job) (rate(http_request_duration_seconds[10m])))
```

To aggregate all conventional histograms, specify only the `le` label:

```
histogram_quantile(0.9, sum by (le) (rate(http_request_duration_seconds_bucket[10m])))
```

With native histograms, aggregating everything works as usual without any `by` clause:

```
histogram_quantile(0.9, sum(rate(http_request_duration_seconds[10m])))
```

The `histogram_quantile()` function interpolates quantile values by assuming a linear distribution within a bucket. 

If `b` has 0 observations, `NaN` is returned. For φ < 0, `-Inf` is returned. For φ > 1, `+Inf` is returned. For φ = `NaN`, `NaN` is returned.

The following is only relevant for conventional histograms: If `b` contains fewer than two buckets, `NaN` is returned. The highest bucket must have an upper bound of `+Inf`. (Otherwise, `NaN` is returned.) If a quantile is located in the highest bucket, the upper bound of the second highest bucket is returned. A lower limit of the lowest bucket is assumed to be 0 if the upper bound of that bucket is greater than 0. In that case, the usual linear interpolation is applied within that bucket. Otherwise, the upper bound of the lowest bucket is returned for quantiles located in the lowest bucket. 

## `holt_winters()`

`holt_winters(v range-vector, sf scalar, tf scalar)` produces a smoothed value for time series based on the range in `v`. The lower the smoothing factor `sf`, the more importance is given to old data. The higher the trend factor `tf`, the more trends in the data is considered. Both `sf` and `tf` must be between 0 and 1.

`holt_winters` should only be used with gauges.

## `hour()`

`hour(v=vector(time()) instant-vector)` returns the hour of the day for each of the given times in UTC. Returned values are from 0 to 23.

## `idelta()`

`idelta(v range-vector)` calculates the difference between the last two samples in the range vector `v`, returning an instant vector with the given deltas and equivalent labels.

`idelta` should only be used with gauges.

## `increase()`

`increase(v range-vector)` calculates the increase in the time series in the range vector. Breaks in monotonicity (such as counter resets due to target restarts) are automatically adjusted for. The increase is extrapolated to cover the full time range as specified in the range vector selector, so that it is possible to get a non-integer result even if a counter increases only by integer increments.

The following example expression returns the number of HTTP requests as measured over the last 5 minutes, per time series in the range vector:

```
increase(http_requests_total{job="api-server"}[5m])
```

`increase` acts on native histograms by calculating a new histogram where each compononent (sum and count of observations, buckets) is the increase between the respective component in the first and last native histogram in `v`. However, each element in `v` that contains a mix of float and native histogram samples within the range, will be missing from the result vector.

`increase` should only be used with counters and native histograms where the components behave like counters. It is syntactic sugar for `rate(v)` multiplied by the number of seconds under the specified time range window, and should be used primarily for human readability.  Use `rate` in recording rules so that increases are tracked consistently on a per-second basis.

## `irate()`

`irate(v range-vector)` calculates the per-second instant rate of increase of the time series in the range vector. This is based on the last two data points. Breaks in monotonicity (such as counter resets due to target restarts) are automatically adjusted for.

The following example expression returns the per-second rate of HTTP requests looking up to 5 minutes back for the two most recent data points, per time series in the range vector:

```
irate(http_requests_total{job="api-server"}[5m])
```

`irate` should only be used when graphing volatile, fast-moving counters. Use `rate` for alerts and slow-moving counters, as brief changes in the rate can reset the `FOR` clause and graphs consisting entirely of rare spikes are hard to read.

Note that when combining `irate()` with an [aggregation operator](https://prometheus.io/docs/prometheus/latest/querying/operators/#aggregation-operators) (e.g. `sum()`) or a function aggregating over time (any function ending in `_over_time`), always take a `irate()` first, then aggregate. Otherwise `irate()` cannot detect counter resets when your target restarts.

## `label_join()`

For each timeseries in `v`, `label_join(v instant-vector, dst_label string, separator string, src_label_1 string, src_label_2 string, ...)` joins all the values of all the `src_labels` using `separator` and returns the timeseries with the label `dst_label` containing the joined value. There can be any number of `src_labels` in this function.

This example will return a vector with each time series having a `foo` label with the value `a,b,c` added to it:

```
label_join(up{job="api-server",src1="a",src2="b",src3="c"}, "foo", ",", "src1", "src2", "src3")
```

## `label_replace()`

For each timeseries in `v`, `label_replace(v instant-vector, dst_label string, replacement string, src_label string, regex string)` matches the regular expression `regex` against the value of the label `src_label`. If it matches, the value of the label `dst_label` in the returned timeseries will be the expansion of `replacement`, together with the original labels in the input. Capturing groups in the regular expression can be referenced with `$1`, `$2`, etc. If the regular expression doesn't match then the timeseries is returned unchanged.

This example will return timeseries with the values `a:c` at label `service` and `a` at label `foo`:

```
label_replace(up{job="api-server",service="a:c"}, "foo", "$1", "service", "(.*):.*")
```

## `ln()`

`ln(v instant-vector)` calculates the natural logarithm for all elements in `v`. Special cases are:

- `ln(+Inf) = +Inf`
- `ln(0) = -Inf`
- `ln(x < 0) = NaN`
- `ln(NaN) = NaN`

## `log2()`

`log2(v instant-vector)` calculates the binary logarithm for all elements in `v`. The special cases are equivalent to those in `ln`.

## `log10()`

`log10(v instant-vector)` calculates the decimal logarithm for all elements in `v`. The special cases are equivalent to those in `ln`.

## `minute()`

`minute(v=vector(time()) instant-vector)` returns the minute of the hour for each of the given times in UTC. Returned values are from 0 to 59.

## `month()`

`month(v=vector(time()) instant-vector)` returns the month of the year for each of the given times in UTC. Returned values are from 1 to 12, where 1 means January etc.

## `predict_linear()`

`predict_linear(v range-vector, t scalar)` predicts the value of time series `t` seconds from now, based on the range vector `v`, using [simple linear regression](https://en.wikipedia.org/wiki/Simple_linear_regression). The range vector must have at least two samples in order to perform the  calculation. When `+Inf` or `-Inf` are found in the range vector,  the slope and offset value calculated will be `NaN`.

`predict_linear` should only be used with gauges.

## `rate()`

`rate(v range-vector)` calculates the per-second average rate of increase of the time series in the range vector. Breaks in monotonicity (such as counter resets due to target restarts) are automatically adjusted for. Also, the calculation extrapolates to the ends of the time range, allowing for missed scrapes or imperfect alignment of scrape cycles with the range's time period.

The following example expression returns the per-second rate of HTTP requests as measured over the last 5 minutes, per time series in the range vector:

```
rate(http_requests_total{job="api-server"}[5m])
```

`rate` acts on native histograms by calculating a new histogram where each compononent (sum and count of observations, buckets) is the rate of increase between the respective component in the first and last native histogram in `v`. However, each element in `v` that contains a mix of float and native histogram samples within the range, will be missing from the result vector.

`rate` should only be used with counters and native histograms where the components behave like counters. It is best suited for alerting, and for graphing of slow-moving counters.

Note that when combining `rate()` with an aggregation operator (e.g. `sum()`) or a function aggregating over time (any function ending in `_over_time`), always take a `rate()` first, then aggregate. Otherwise `rate()` cannot detect counter resets when your target restarts.

## `resets()`

For each input time series, `resets(v range-vector)` returns the number of counter resets within the provided time range as an instant vector. Any decrease in the value between two consecutive samples is interpreted as a counter reset.

`resets` should only be used with counters.

## `round()`

`round(v instant-vector, to_nearest=1 scalar)` rounds the sample values of all elements in `v` to the nearest integer. Ties are resolved by rounding up. The optional `to_nearest` argument allows specifying the nearest multiple to which the sample values should be rounded. This multiple may also be a fraction.

## `scalar()`

Given a single-element input vector, `scalar(v instant-vector)` returns the sample value of that single element as a scalar. If the input vector does not have exactly one element, `scalar` will return `NaN`.

## `sgn()`

`sgn(v instant-vector)` returns a vector with all sample  values converted to their sign, defined as this: 1 if v is positive, -1  if v is negative and 0 if v is equal to zero.

## `sort()`

`sort(v instant-vector)` returns vector elements sorted by their sample values, in ascending order.

## `sort_desc()`

Same as `sort`, but sorts in descending order.

## `sqrt()`

`sqrt(v instant-vector)` calculates the square root of all elements in `v`.

## `time()`

`time()` returns the number of seconds since January 1, 1970 UTC. Note that this does not actually return the current time, but the time at which the expression is to be evaluated.

## `timestamp()`

`timestamp(v instant-vector)` returns the timestamp of each of the samples of the given vector as the number of seconds since January 1, 1970 UTC.

## `vector()`

`vector(s scalar)` returns the scalar `s` as a vector with no labels.

## `year()`

`year(v=vector(time()) instant-vector)` returns the year for each of the given times in UTC.

## `<aggregation>_over_time()`

The following functions allow aggregating each series of a given range vector over time and return an instant vector with per-series aggregation results:

- `avg_over_time(range-vector)`: the average value of all points in the specified interval.
- `min_over_time(range-vector)`: the minimum value of all points in the specified interval.
- `max_over_time(range-vector)`: the maximum value of all points in the specified interval.
- `sum_over_time(range-vector)`: the sum of all values in the specified interval.
- `count_over_time(range-vector)`: the count of all values in the specified interval.
- `quantile_over_time(scalar, range-vector)`: the φ-quantile (0 ≤ φ ≤ 1) of the values in the specified interval.
- `stddev_over_time(range-vector)`: the population standard deviation of the values in the specified interval.
- `stdvar_over_time(range-vector)`: the population standard variance of the values in the specified interval.
- `last_over_time(range-vector)`: the most recent point value in specified interval.
- `present_over_time(range-vector)`: the value 1 for any series in the specified interval.

Note that all values in the specified interval have the same weight in the aggregation even if the values are not equally spaced throughout the interval.

## Trigonometric Functions

The trigonometric functions work in radians:

- `acos(v instant-vector)`: calculates the arccosine of all elements in `v` ([special cases](https://pkg.go.dev/math#Acos)).
- `acosh(v instant-vector)`: calculates the inverse hyperbolic cosine of all elements in `v` ([special cases](https://pkg.go.dev/math#Acosh)).
- `asin(v instant-vector)`: calculates the arcsine of all elements in `v` ([special cases](https://pkg.go.dev/math#Asin)).
- `asinh(v instant-vector)`: calculates the inverse hyperbolic sine of all elements in `v` ([special cases](https://pkg.go.dev/math#Asinh)).
- `atan(v instant-vector)`: calculates the arctangent of all elements in `v` ([special cases](https://pkg.go.dev/math#Atan)).
- `atanh(v instant-vector)`: calculates the inverse hyperbolic tangent of all elements in `v` ([special cases](https://pkg.go.dev/math#Atanh)).
- `cos(v instant-vector)`: calculates the cosine of all elements in `v` ([special cases](https://pkg.go.dev/math#Cos)).
- `cosh(v instant-vector)`: calculates the hyperbolic cosine of all elements in `v` ([special cases](https://pkg.go.dev/math#Cosh)).
- `sin(v instant-vector)`: calculates the sine of all elements in `v` ([special cases](https://pkg.go.dev/math#Sin)).
- `sinh(v instant-vector)`: calculates the hyperbolic sine of all elements in `v` ([special cases](https://pkg.go.dev/math#Sinh)).
- `tan(v instant-vector)`: calculates the tangent of all elements in `v` ([special cases](https://pkg.go.dev/math#Tan)).
- `tanh(v instant-vector)`: calculates the hyperbolic tangent of all elements in `v` ([special cases](https://pkg.go.dev/math#Tanh)).

The following are useful for converting between degrees and radians:

- `deg(v instant-vector)`: converts radians to degrees for all elements in `v`.
- `pi()`: returns pi.
- `rad(v instant-vector)`: converts degrees to radians for all elements in `v`.

# Query examples

- [Simple time series selection ](https://prometheus.io/docs/prometheus/latest/querying/examples/#simple-time-series-selection)
- [Subquery ](https://prometheus.io/docs/prometheus/latest/querying/examples/#subquery)
- [Using functions, operators, etc. ](https://prometheus.io/docs/prometheus/latest/querying/examples/#using-functions-operators-etc)

## Simple time series selection

Return all time series with the metric `http_requests_total`:

```
http_requests_total
```

Return all time series with the metric `http_requests_total` and the given `job` and `handler` labels:

```
http_requests_total{job="apiserver", handler="/api/comments"}
```

Return a whole range of time (in this case 5 minutes up to the query time) for the same vector, making it a [range vector](https://prometheus.io/docs/prometheus/latest/querying/basics/#range-vector-selectors):

```
http_requests_total{job="apiserver", handler="/api/comments"}[5m]
```

Note that an expression resulting in a range vector cannot be graphed directly, but viewed in the tabular ("Console") view of the expression browser.

Using regular expressions, you could select time series only for jobs whose name match a certain pattern, in this case, all jobs that end with `server`:

```
http_requests_total{job=~".*server"}
```

All regular expressions in Prometheus use [RE2 syntax](https://github.com/google/re2/wiki/Syntax).

To select all HTTP status codes except 4xx ones, you could run:

```
http_requests_total{status!~"4.."}
```

## Subquery

Return the 5-minute rate of the `http_requests_total` metric for the past 30 minutes, with a resolution of 1 minute.

```
rate(http_requests_total[5m])[30m:1m]
```

This is an example of a nested subquery. The subquery for the `deriv` function uses the default resolution. Note that using subqueries unnecessarily is unwise.

```
max_over_time(deriv(rate(distance_covered_total[5s])[30s:5s])[10m:])
```

## Using functions, operators, etc.

Return the per-second rate for all time series with the `http_requests_total` metric name, as measured over the last 5 minutes:

```
rate(http_requests_total[5m])
```

Assuming that the `http_requests_total` time series all have the labels `job` (fanout by job name) and `instance` (fanout by instance of the job), we might want to sum over the rate of all instances, so we get fewer output time series, but still preserve the `job` dimension:

```
sum by (job) (
  rate(http_requests_total[5m])
)
```

If we have two different metrics with the same dimensional labels, we can apply binary operators to them and elements on both sides with the same label set will get matched and propagated to the output. For example, this expression returns the unused memory in MiB for every instance (on a fictional cluster scheduler exposing these metrics about the instances it runs):

```
(instance_memory_limit_bytes - instance_memory_usage_bytes) / 1024 / 1024
```

The same expression, but summed by application, could be written like this:

```
sum by (app, proc) (
  instance_memory_limit_bytes - instance_memory_usage_bytes
) / 1024 / 1024
```

If the same fictional cluster scheduler exposed CPU usage metrics like the following for every instance:

```
instance_cpu_time_ns{app="lion", proc="web", rev="34d0f99", env="prod", job="cluster-manager"}
instance_cpu_time_ns{app="elephant", proc="worker", rev="34d0f99", env="prod", job="cluster-manager"}
instance_cpu_time_ns{app="turtle", proc="api", rev="4d3a513", env="prod", job="cluster-manager"}
instance_cpu_time_ns{app="fox", proc="widget", rev="4d3a513", env="prod", job="cluster-manager"}
...
```

...we could get the top 3 CPU users grouped by application (`app`) and process type (`proc`) like this:

```
topk(3, sum by (app, proc) (rate(instance_cpu_time_ns[5m])))
```

Assuming this metric contains one time series per running instance, you could count the number of running instances per application like this:

```
count by (app) (instance_cpu_time_ns)
```

# HTTP API

- [Format overview ](https://prometheus.io/docs/prometheus/latest/querying/api/#format-overview)

- [Expression queries ](https://prometheus.io/docs/prometheus/latest/querying/api/#expression-queries)

- - [Instant queries ](https://prometheus.io/docs/prometheus/latest/querying/api/#instant-queries)
  - [Range queries ](https://prometheus.io/docs/prometheus/latest/querying/api/#range-queries)

- [Formatting query expressions ](https://prometheus.io/docs/prometheus/latest/querying/api/#formatting-query-expressions)

- [Querying metadata ](https://prometheus.io/docs/prometheus/latest/querying/api/#querying-metadata)

- - [Finding series by label matchers ](https://prometheus.io/docs/prometheus/latest/querying/api/#finding-series-by-label-matchers)
  - [Getting label names ](https://prometheus.io/docs/prometheus/latest/querying/api/#getting-label-names)
  - [Querying label values ](https://prometheus.io/docs/prometheus/latest/querying/api/#querying-label-values)

- [Querying exemplars ](https://prometheus.io/docs/prometheus/latest/querying/api/#querying-exemplars)

- [Expression query result formats ](https://prometheus.io/docs/prometheus/latest/querying/api/#expression-query-result-formats)

- - [Range vectors ](https://prometheus.io/docs/prometheus/latest/querying/api/#range-vectors)
  - [Instant vectors ](https://prometheus.io/docs/prometheus/latest/querying/api/#instant-vectors)
  - [Scalars ](https://prometheus.io/docs/prometheus/latest/querying/api/#scalars)
  - [Strings ](https://prometheus.io/docs/prometheus/latest/querying/api/#strings)
  - [Native histograms ](https://prometheus.io/docs/prometheus/latest/querying/api/#native-histograms)

- [Targets ](https://prometheus.io/docs/prometheus/latest/querying/api/#targets)

- [Rules ](https://prometheus.io/docs/prometheus/latest/querying/api/#rules)

- [Alerts ](https://prometheus.io/docs/prometheus/latest/querying/api/#alerts)

- [Querying target metadata ](https://prometheus.io/docs/prometheus/latest/querying/api/#querying-target-metadata)

- [Querying metric metadata ](https://prometheus.io/docs/prometheus/latest/querying/api/#querying-metric-metadata)

- [Alertmanagers ](https://prometheus.io/docs/prometheus/latest/querying/api/#alertmanagers)

- [Status ](https://prometheus.io/docs/prometheus/latest/querying/api/#status)

- - [Config ](https://prometheus.io/docs/prometheus/latest/querying/api/#config)
  - [Flags ](https://prometheus.io/docs/prometheus/latest/querying/api/#flags)
  - [Runtime Information ](https://prometheus.io/docs/prometheus/latest/querying/api/#runtime-information)
  - [Build Information ](https://prometheus.io/docs/prometheus/latest/querying/api/#build-information)
  - [TSDB Stats ](https://prometheus.io/docs/prometheus/latest/querying/api/#tsdb-stats)
  - [WAL Replay Stats ](https://prometheus.io/docs/prometheus/latest/querying/api/#wal-replay-stats)

- [TSDB Admin APIs ](https://prometheus.io/docs/prometheus/latest/querying/api/#tsdb-admin-apis)

- - [Snapshot ](https://prometheus.io/docs/prometheus/latest/querying/api/#snapshot)
  - [Delete Series ](https://prometheus.io/docs/prometheus/latest/querying/api/#delete-series)
  - [Clean Tombstones ](https://prometheus.io/docs/prometheus/latest/querying/api/#clean-tombstones)

- [Remote Write Receiver ](https://prometheus.io/docs/prometheus/latest/querying/api/#remote-write-receiver)

The current stable HTTP API is reachable under `/api/v1` on a Prometheus server. Any non-breaking additions will be added under that endpoint.

## Format overview

The API response format is JSON. Every successful API request returns a `2xx` status code.

Invalid requests that reach the API handlers return a JSON error object and one of the following HTTP response codes:

- `400 Bad Request` when parameters are missing or incorrect.
- `422 Unprocessable Entity` when an expression can't be executed ([RFC4918](https://tools.ietf.org/html/rfc4918#page-78)).
- `503 Service Unavailable` when queries time out or abort.

Other non-`2xx` codes may be returned for errors occurring before the API endpoint is reached.

An array of warnings may be returned if there are errors that do not inhibit the request execution. All of the data that was successfully collected will be returned in the data field.

The JSON response envelope format is as follows:

```
{
  "status": "success" | "error",
  "data": <data>,

  // Only set if status is "error". The data field may still hold
  // additional data.
  "errorType": "<string>",
  "error": "<string>",

  // Only if there were warnings while executing the request.
  // There will still be data in the data field.
  "warnings": ["<string>"]
}
```

Generic placeholders are defined as follows:

- `<rfc3339 | unix_timestamp>`: Input timestamps may be provided either in [RFC3339](https://www.ietf.org/rfc/rfc3339.txt) format or as a Unix timestamp in seconds, with optional decimal places for sub-second precision. Output timestamps are always represented as Unix timestamps in seconds.
- `<series_selector>`: Prometheus [time series selectors](https://prometheus.io/docs/prometheus/latest/querying/basics/#time-series-selectors) like `http_requests_total` or `http_requests_total{method=~"(GET|POST)"}` and need to be URL-encoded.
- `<duration>`: [Prometheus duration strings](https://prometheus.io/docs/prometheus/latest/querying/basics/#time-durations). For example, `5m` refers to a duration of 5 minutes.
- `<bool>`: boolean values (strings `true` and `false`).

Note: Names of query parameters that may be repeated end with `[]`.

## Expression queries

Query language expressions may be evaluated at a single instant or over a range of time. The sections below describe the API endpoints for each type of expression query.

### Instant queries

The following endpoint evaluates an instant query at a single point in time:

```
GET /api/v1/query
POST /api/v1/query
```

URL query parameters:

- `query=<string>`: Prometheus expression query string.
- `time=<rfc3339 | unix_timestamp>`: Evaluation timestamp. Optional.
- `timeout=<duration>`: Evaluation timeout. Optional. Defaults to and is capped by the value of the `-query.timeout` flag.

The current server time is used if the `time` parameter is omitted.

You can URL-encode these parameters directly in the request body by using the `POST` method and `Content-Type: application/x-www-form-urlencoded` header. This is useful when specifying a large query that may breach server-side URL character limits.

The `data` section of the query result has the following format:

```
{
  "resultType": "matrix" | "vector" | "scalar" | "string",
  "result": <value>
}
```

`<value>` refers to the query result data, which has varying formats depending on the `resultType`. See the [expression query result formats](https://prometheus.io/docs/prometheus/latest/querying/api/#expression-query-result-formats).

The following example evaluates the expression `up` at the time `2015-07-01T20:10:51.781Z`:

```
$ curl 'http://localhost:9090/api/v1/query?query=up&time=2015-07-01T20:10:51.781Z'
{
   "status" : "success",
   "data" : {
      "resultType" : "vector",
      "result" : [
         {
            "metric" : {
               "__name__" : "up",
               "job" : "prometheus",
               "instance" : "localhost:9090"
            },
            "value": [ 1435781451.781, "1" ]
         },
         {
            "metric" : {
               "__name__" : "up",
               "job" : "node",
               "instance" : "localhost:9100"
            },
            "value" : [ 1435781451.781, "0" ]
         }
      ]
   }
}
```

### Range queries

The following endpoint evaluates an expression query over a range of time:

```
GET /api/v1/query_range
POST /api/v1/query_range
```

URL query parameters:

- `query=<string>`: Prometheus expression query string.
- `start=<rfc3339 | unix_timestamp>`: Start timestamp, inclusive.
- `end=<rfc3339 | unix_timestamp>`: End timestamp, inclusive.
- `step=<duration | float>`: Query resolution step width in `duration` format or float number of seconds.
- `timeout=<duration>`: Evaluation timeout. Optional. Defaults to and is capped by the value of the `-query.timeout` flag.

You can URL-encode these parameters directly in the request body by using the `POST` method and `Content-Type: application/x-www-form-urlencoded` header. This is useful when specifying a large query that may breach server-side URL character limits.

The `data` section of the query result has the following format:

```
{
  "resultType": "matrix",
  "result": <value>
}
```

For the format of the `<value>` placeholder, see the [range-vector result format](https://prometheus.io/docs/prometheus/latest/querying/api/#range-vectors).

The following example evaluates the expression `up` over a 30-second range with a query resolution of 15 seconds.

```
$ curl 'http://localhost:9090/api/v1/query_range?query=up&start=2015-07-01T20:10:30.781Z&end=2015-07-01T20:11:00.781Z&step=15s'
{
   "status" : "success",
   "data" : {
      "resultType" : "matrix",
      "result" : [
         {
            "metric" : {
               "__name__" : "up",
               "job" : "prometheus",
               "instance" : "localhost:9090"
            },
            "values" : [
               [ 1435781430.781, "1" ],
               [ 1435781445.781, "1" ],
               [ 1435781460.781, "1" ]
            ]
         },
         {
            "metric" : {
               "__name__" : "up",
               "job" : "node",
               "instance" : "localhost:9091"
            },
            "values" : [
               [ 1435781430.781, "0" ],
               [ 1435781445.781, "0" ],
               [ 1435781460.781, "1" ]
            ]
         }
      ]
   }
}
```

## Formatting query expressions

The following endpoint formats a PromQL expression in a prettified way:

```
GET /api/v1/format_query
POST /api/v1/format_query
```

URL query parameters:

- `query=<string>`: Prometheus expression query string.

You can URL-encode these parameters directly in the request body by using the `POST` method and `Content-Type: application/x-www-form-urlencoded` header. This is useful when specifying a large query that may breach server-side URL character limits.

The `data` section of the query result is a string  containing the formatted query expression. Note that any comments are  removed in the formatted string.

The following example formats the expression `foo/bar`:

```
$ curl 'http://localhost:9090/api/v1/format_query?query=foo/bar'
{
   "status" : "success",
   "data" : "foo / bar"
}
```

## Querying metadata

Prometheus offers a set of API endpoints to query metadata about series and their labels.

**NOTE:** These API endpoints may return metadata for  series for which there is no sample within the selected time range,  and/or for series whose samples have been marked as deleted via the  deletion API endpoint. The exact extent of additionally returned series  metadata is an implementation detail that may change in the future.

### Finding series by label matchers

The following endpoint returns the list of time series that match a certain label set.

```
GET /api/v1/series
POST /api/v1/series
```

URL query parameters:

- `match[]=<series_selector>`: Repeated series selector argument that selects the series to return. At least one `match[]` argument must be provided.
- `start=<rfc3339 | unix_timestamp>`: Start timestamp.
- `end=<rfc3339 | unix_timestamp>`: End timestamp.

You can URL-encode these parameters directly in the request body by using the `POST` method and `Content-Type: application/x-www-form-urlencoded` header. This is useful when specifying a large or dynamic number of series selectors that may breach server-side URL character limits.

The `data` section of the query result consists of a list of objects that contain the label name/value pairs which identify each series.

The following example returns all series that match either of the selectors `up` or `process_start_time_seconds{job="prometheus"}`:

```
$ curl -g 'http://localhost:9090/api/v1/series?' --data-urlencode 'match[]=up' --data-urlencode 'match[]=process_start_time_seconds{job="prometheus"}'
{
   "status" : "success",
   "data" : [
      {
         "__name__" : "up",
         "job" : "prometheus",
         "instance" : "localhost:9090"
      },
      {
         "__name__" : "up",
         "job" : "node",
         "instance" : "localhost:9091"
      },
      {
         "__name__" : "process_start_time_seconds",
         "job" : "prometheus",
         "instance" : "localhost:9090"
      }
   ]
}
```

### Getting label names

The following endpoint returns a list of label names:

```
GET /api/v1/labels
POST /api/v1/labels
```

URL query parameters:

- `start=<rfc3339 | unix_timestamp>`: Start timestamp. Optional.
- `end=<rfc3339 | unix_timestamp>`: End timestamp. Optional.
- `match[]=<series_selector>`: Repeated series selector argument that selects the series from which to read the label names. Optional.

The `data` section of the JSON response is a list of string label names.

Here is an example.

```
$ curl 'localhost:9090/api/v1/labels'
{
    "status": "success",
    "data": [
        "__name__",
        "call",
        "code",
        "config",
        "dialer_name",
        "endpoint",
        "event",
        "goversion",
        "handler",
        "instance",
        "interval",
        "job",
        "le",
        "listener_name",
        "name",
        "quantile",
        "reason",
        "role",
        "scrape_job",
        "slice",
        "version"
    ]
}
```

### Querying label values

The following endpoint returns a list of label values for a provided label name:

```
GET /api/v1/label/<label_name>/values
```

URL query parameters:

- `start=<rfc3339 | unix_timestamp>`: Start timestamp. Optional.
- `end=<rfc3339 | unix_timestamp>`: End timestamp. Optional.
- `match[]=<series_selector>`: Repeated series selector argument that selects the series from which to read the label values. Optional.

The `data` section of the JSON response is a list of string label values.

This example queries for all label values for the `job` label:

```
$ curl http://localhost:9090/api/v1/label/job/values
{
   "status" : "success",
   "data" : [
      "node",
      "prometheus"
   ]
}
```

## Querying exemplars

This is **experimental** and might change in the future. The following endpoint returns a list of exemplars for a valid PromQL query for a specific time range:

```
GET /api/v1/query_exemplars
POST /api/v1/query_exemplars
```

URL query parameters:

- `query=<string>`: Prometheus expression query string.
- `start=<rfc3339 | unix_timestamp>`: Start timestamp.
- `end=<rfc3339 | unix_timestamp>`: End timestamp.

```
$ curl -g 'http://localhost:9090/api/v1/query_exemplars?query=test_exemplar_metric_total&start=2020-09-14T15:22:25.479Z&end=2020-09-14T15:23:25.479Z'
{
    "status": "success",
    "data": [
        {
            "seriesLabels": {
                "__name__": "test_exemplar_metric_total",
                "instance": "localhost:8090",
                "job": "prometheus",
                "service": "bar"
            },
            "exemplars": [
                {
                    "labels": {
                        "traceID": "EpTxMJ40fUus7aGY"
                    },
                    "value": "6",
                    "timestamp": 1600096945.479,
                }
            ]
        },
        {
            "seriesLabels": {
                "__name__": "test_exemplar_metric_total",
                "instance": "localhost:8090",
                "job": "prometheus",
                "service": "foo"
            },
            "exemplars": [
                {
                    "labels": {
                        "traceID": "Olp9XHlq763ccsfa"
                    },
                    "value": "19",
                    "timestamp": 1600096955.479,
                },
                {
                    "labels": {
                        "traceID": "hCtjygkIHwAN9vs4"
                    },
                    "value": "20",
                    "timestamp": 1600096965.489,
                },
            ]
        }
    ]
}
```

## Expression query result formats

Expression queries may return the following response values in the `result` property of the `data` section. `<sample_value>` placeholders are numeric sample values. JSON does not support special float values such as `NaN`, `Inf`, and `-Inf`, so sample values are transferred as quoted JSON strings rather than raw numbers.

The keys `"histogram"` and `"histograms"` only show up if the experimental native histograms are present in the response. Their placeholder `<histogram>` is explained in detail in its own section below. 

### Range vectors

Range vectors are returned as result type `matrix`. The corresponding `result` property has the following format:

```
[
  {
    "metric": { "<label_name>": "<label_value>", ... },
    "values": [ [ <unix_time>, "<sample_value>" ], ... ],
    "histograms": [ [ <unix_time>, <histogram> ], ... ]
  },
  ...
]
```

Each series could have the `"values"` key, or the `"histograms"` key, or both.  For a given timestamp, there will only be one sample of either float or histogram type.

### Instant vectors

Instant vectors are returned as result type `vector`. The corresponding `result` property has the following format:

```
[
  {
    "metric": { "<label_name>": "<label_value>", ... },
    "value": [ <unix_time>, "<sample_value>" ],
    "histogram": [ <unix_time>, <histogram> ]
  },
  ...
]
```

Each series could have the `"value"` key, or the `"histogram"` key, but not both.

### Scalars

Scalar results are returned as result type `scalar`. The corresponding `result` property has the following format:

```
[ <unix_time>, "<scalar_value>" ]
```

### Strings

String results are returned as result type `string`. The corresponding `result` property has the following format:

```
[ <unix_time>, "<string_value>" ]
```

### Native histograms

The `<histogram>` placeholder used above is formatted as follows.

*Note that native histograms are an experimental feature, and the format below might still change.*

```
{
  "count": "<count_of_observations>",
  "sum": "<sum_of_observations>",
  "buckets": [ [ <boundary_rule>, "<left_boundary>", "<right_boundary>", "<count_in_bucket>" ], ... ]
}
```

The `<boundary_rule>` placeholder is an integer between 0 and 3 with the following meaning:

- 0: “open left” (left boundary is exclusive, right boundary in inclusive)
- 1: “open right” (left boundary is inclusive, right boundary in exclusive)
- 2: “open both” (both boundaries are exclusive)
- 3: “closed both” (both boundaries are inclusive)

Note that with the currently implemented bucket schemas, positive buckets are “open left”, negative buckets are “open right”, and the zero bucket (with a negative left boundary and a positive right boundary) is “closed both”.

## Targets

The following endpoint returns an overview of the current state of the Prometheus target discovery:

```
GET /api/v1/targets
```

Both the active and dropped targets are part of the response by default. `labels` represents the label set after relabeling has occurred. `discoveredLabels` represent the unmodified labels retrieved during service discovery before relabeling has occurred.

```
$ curl http://localhost:9090/api/v1/targets
{
  "status": "success",
  "data": {
    "activeTargets": [
      {
        "discoveredLabels": {
          "__address__": "127.0.0.1:9090",
          "__metrics_path__": "/metrics",
          "__scheme__": "http",
          "job": "prometheus"
        },
        "labels": {
          "instance": "127.0.0.1:9090",
          "job": "prometheus"
        },
        "scrapePool": "prometheus",
        "scrapeUrl": "http://127.0.0.1:9090/metrics",
        "globalUrl": "http://example-prometheus:9090/metrics",
        "lastError": "",
        "lastScrape": "2017-01-17T15:07:44.723715405+01:00",
        "lastScrapeDuration": 0.050688943,
        "health": "up",
        "scrapeInterval": "1m",
        "scrapeTimeout": "10s"
      }
    ],
    "droppedTargets": [
      {
        "discoveredLabels": {
          "__address__": "127.0.0.1:9100",
          "__metrics_path__": "/metrics",
          "__scheme__": "http",
          "__scrape_interval__": "1m",
          "__scrape_timeout__": "10s",
          "job": "node"
        },
      }
    ]
  }
}
```

The `state` query parameter allows the caller to filter by active or dropped targets, (e.g., `state=active`, `state=dropped`, `state=any`). Note that an empty array is still returned for targets that are filtered out. Other values are ignored.

```
$ curl 'http://localhost:9090/api/v1/targets?state=active'
{
  "status": "success",
  "data": {
    "activeTargets": [
      {
        "discoveredLabels": {
          "__address__": "127.0.0.1:9090",
          "__metrics_path__": "/metrics",
          "__scheme__": "http",
          "job": "prometheus"
        },
        "labels": {
          "instance": "127.0.0.1:9090",
          "job": "prometheus"
        },
        "scrapePool": "prometheus",
        "scrapeUrl": "http://127.0.0.1:9090/metrics",
        "globalUrl": "http://example-prometheus:9090/metrics",
        "lastError": "",
        "lastScrape": "2017-01-17T15:07:44.723715405+01:00",
        "lastScrapeDuration": 50688943,
        "health": "up"
      }
    ],
    "droppedTargets": []
  }
}
```

The `scrapePool` query parameter allows the caller to filter by scrape pool name.

```
$ curl 'http://localhost:9090/api/v1/targets?scrapePool=node_exporter'
{
  "status": "success",
  "data": {
    "activeTargets": [
      {
        "discoveredLabels": {
          "__address__": "127.0.0.1:9091",
          "__metrics_path__": "/metrics",
          "__scheme__": "http",
          "job": "node_exporter"
        },
        "labels": {
          "instance": "127.0.0.1:9091",
          "job": "node_exporter"
        },
        "scrapePool": "node_exporter",
        "scrapeUrl": "http://127.0.0.1:9091/metrics",
        "globalUrl": "http://example-prometheus:9091/metrics",
        "lastError": "",
        "lastScrape": "2017-01-17T15:07:44.723715405+01:00",
        "lastScrapeDuration": 50688943,
        "health": "up"
      }
    ],
    "droppedTargets": []
  }
}
```

## Rules

The `/rules` API endpoint returns a list of alerting and recording rules that are currently loaded. In addition it returns the currently active alerts fired by the Prometheus instance of each alerting rule.

As the `/rules` endpoint is fairly new, it does not have the same stability guarantees as the overarching API v1.

```
GET /api/v1/rules
```

URL query parameters: - `type=alert|record`: return only the alerting rules (e.g. `type=alert`) or the recording rules (e.g. `type=record`). When the parameter is absent or empty, no filtering is done.

```
$ curl http://localhost:9090/api/v1/rules

{
    "data": {
        "groups": [
            {
                "rules": [
                    {
                        "alerts": [
                            {
                                "activeAt": "2018-07-04T20:27:12.60602144+02:00",
                                "annotations": {
                                    "summary": "High request latency"
                                },
                                "labels": {
                                    "alertname": "HighRequestLatency",
                                    "severity": "page"
                                },
                                "state": "firing",
                                "value": "1e+00"
                            }
                        ],
                        "annotations": {
                            "summary": "High request latency"
                        },
                        "duration": 600,
                        "health": "ok",
                        "labels": {
                            "severity": "page"
                        },
                        "name": "HighRequestLatency",
                        "query": "job:request_latency_seconds:mean5m{job=\"myjob\"} > 0.5",
                        "type": "alerting"
                    },
                    {
                        "health": "ok",
                        "name": "job:http_inprogress_requests:sum",
                        "query": "sum by (job) (http_inprogress_requests)",
                        "type": "recording"
                    }
                ],
                "file": "/rules.yaml",
                "interval": 60,
                "limit": 0,
                "name": "example"
            }
        ]
    },
    "status": "success"
}
```

## Alerts

The `/alerts` endpoint returns a list of all active alerts.

As the `/alerts` endpoint is fairly new, it does not have the same stability guarantees as the overarching API v1.

```
GET /api/v1/alerts
$ curl http://localhost:9090/api/v1/alerts

{
    "data": {
        "alerts": [
            {
                "activeAt": "2018-07-04T20:27:12.60602144+02:00",
                "annotations": {},
                "labels": {
                    "alertname": "my-alert"
                },
                "state": "firing",
                "value": "1e+00"
            }
        ]
    },
    "status": "success"
}
```

## Querying target metadata

The following endpoint returns metadata about metrics currently scraped from targets. This is **experimental** and might change in the future.

```
GET /api/v1/targets/metadata
```

URL query parameters:

- `match_target=<label_selectors>`: Label selectors that match targets by their label sets. All targets are selected if left empty.
- `metric=<string>`: A metric name to retrieve metadata for. All metric metadata is retrieved if left empty.
- `limit=<number>`: Maximum number of targets to match.

The `data` section of the query result consists of a list of objects that contain metric metadata and the target label set.

The following example returns all metadata entries for the `go_goroutines` metric from the first two targets with label `job="prometheus"`.

```
curl -G http://localhost:9091/api/v1/targets/metadata \
    --data-urlencode 'metric=go_goroutines' \
    --data-urlencode 'match_target={job="prometheus"}' \
    --data-urlencode 'limit=2'
{
  "status": "success",
  "data": [
    {
      "target": {
        "instance": "127.0.0.1:9090",
        "job": "prometheus"
      },
      "type": "gauge",
      "help": "Number of goroutines that currently exist.",
      "unit": ""
    },
    {
      "target": {
        "instance": "127.0.0.1:9091",
        "job": "prometheus"
      },
      "type": "gauge",
      "help": "Number of goroutines that currently exist.",
      "unit": ""
    }
  ]
}
```

The following example returns metadata for all metrics for all targets with label `instance="127.0.0.1:9090`.

```
curl -G http://localhost:9091/api/v1/targets/metadata \
    --data-urlencode 'match_target={instance="127.0.0.1:9090"}'
{
  "status": "success",
  "data": [
    // ...
    {
      "target": {
        "instance": "127.0.0.1:9090",
        "job": "prometheus"
      },
      "metric": "prometheus_treecache_zookeeper_failures_total",
      "type": "counter",
      "help": "The total number of ZooKeeper failures.",
      "unit": ""
    },
    {
      "target": {
        "instance": "127.0.0.1:9090",
        "job": "prometheus"
      },
      "metric": "prometheus_tsdb_reloads_total",
      "type": "counter",
      "help": "Number of times the database reloaded block data from disk.",
      "unit": ""
    },
    // ...
  ]
}
```

## Querying metric metadata

It returns metadata about metrics currently scraped from targets. However, it does not provide any target information. This is considered **experimental** and might change in the future.

```
GET /api/v1/metadata
```

URL query parameters:

- `limit=<number>`: Maximum number of metrics to return.
- `metric=<string>`: A metric name to filter metadata for. All metric metadata is retrieved if left empty.

The `data` section of the query result consists of an  object where each key is a metric name and each value is a list of  unique metadata objects, as exposed for that metric name across all  targets.

The following example returns two metrics. Note that the metric `http_requests_total` has more than one object in the list. At least one target has a value for `HELP` that do not match with the rest.

```
curl -G http://localhost:9090/api/v1/metadata?limit=2

{
  "status": "success",
  "data": {
    "cortex_ring_tokens": [
      {
        "type": "gauge",
        "help": "Number of tokens in the ring",
        "unit": ""
      }
    ],
    "http_requests_total": [
      {
        "type": "counter",
        "help": "Number of HTTP requests",
        "unit": ""
      },
      {
        "type": "counter",
        "help": "Amount of HTTP requests",
        "unit": ""
      }
    ]
  }
}
```

The following example returns metadata only for the metric `http_requests_total`.

```
curl -G http://localhost:9090/api/v1/metadata?metric=http_requests_total

{
  "status": "success",
  "data": {
    "http_requests_total": [
      {
        "type": "counter",
        "help": "Number of HTTP requests",
        "unit": ""
      },
      {
        "type": "counter",
        "help": "Amount of HTTP requests",
        "unit": ""
      }
    ]
  }
}
```

## Alertmanagers

The following endpoint returns an overview of the current state of the Prometheus alertmanager discovery:

```
GET /api/v1/alertmanagers
```

Both the active and dropped Alertmanagers are part of the response.

```
$ curl http://localhost:9090/api/v1/alertmanagers
{
  "status": "success",
  "data": {
    "activeAlertmanagers": [
      {
        "url": "http://127.0.0.1:9090/api/v1/alerts"
      }
    ],
    "droppedAlertmanagers": [
      {
        "url": "http://127.0.0.1:9093/api/v1/alerts"
      }
    ]
  }
}
```

## Status

Following status endpoints expose current Prometheus configuration.

### Config

The following endpoint returns currently loaded configuration file:

```
GET /api/v1/status/config
```

The config is returned as dumped YAML file. Due to limitation of the YAML library, YAML comments are not included.

```
$ curl http://localhost:9090/api/v1/status/config
{
  "status": "success",
  "data": {
    "yaml": "<content of the loaded config file in YAML>",
  }
}
```

### Flags

The following endpoint returns flag values that Prometheus was configured with:

```
GET /api/v1/status/flags
```

All values are of the result type `string`.

```
$ curl http://localhost:9090/api/v1/status/flags
{
  "status": "success",
  "data": {
    "alertmanager.notification-queue-capacity": "10000",
    "alertmanager.timeout": "10s",
    "log.level": "info",
    "query.lookback-delta": "5m",
    "query.max-concurrency": "20",
    ...
  }
}
```

*New in v2.2*

### Runtime Information

The following endpoint returns various runtime information properties about the Prometheus server:

```
GET /api/v1/status/runtimeinfo
```

The returned values are of different types, depending on the nature of the runtime property.

```
$ curl http://localhost:9090/api/v1/status/runtimeinfo
{
  "status": "success",
  "data": {
    "startTime": "2019-11-02T17:23:59.301361365+01:00",
    "CWD": "/",
    "reloadConfigSuccess": true,
    "lastConfigTime": "2019-11-02T17:23:59+01:00",
    "timeSeriesCount": 873,
    "corruptionCount": 0,
    "goroutineCount": 48,
    "GOMAXPROCS": 4,
    "GOGC": "",
    "GODEBUG": "",
    "storageRetention": "15d"
  }
}
```

**NOTE:** The exact returned runtime properties may change without notice between Prometheus versions.

*New in v2.14*

### Build Information

The following endpoint returns various build information properties about the Prometheus server:

```
GET /api/v1/status/buildinfo
```

All values are of the result type `string`.

```
$ curl http://localhost:9090/api/v1/status/buildinfo
{
  "status": "success",
  "data": {
    "version": "2.13.1",
    "revision": "cb7cbad5f9a2823a622aaa668833ca04f50a0ea7",
    "branch": "master",
    "buildUser": "julius@desktop",
    "buildDate": "20191102-16:19:59",
    "goVersion": "go1.13.1"
  }
}
```

**NOTE:** The exact returned build properties may change without notice between Prometheus versions.

*New in v2.14*

### TSDB Stats

The following endpoint returns various cardinality statistics about the Prometheus TSDB:

```
GET /api/v1/status/tsdb
```

- headStats

  : This provides the following data about the head block of the TSDB:

  - **numSeries**: The number of series.
  - **chunkCount**: The number of chunks.
  - **minTime**: The current minimum timestamp in milliseconds.
  - **maxTime**: The current maximum timestamp in milliseconds.

- **seriesCountByMetricName:**  This will provide a list of metrics names and their series count.

- **labelValueCountByLabelName:** This will provide a list of the label names and their value count.

- **memoryInBytesByLabelName** This will provide a list of  the label names and memory used in bytes. Memory usage is calculated by  adding the length of all values for a given label name.

- **seriesCountByLabelPair** This will provide a list of label value pairs and their series count.

```
$ curl http://localhost:9090/api/v1/status/tsdb
{
  "status": "success",
  "data": {
    "headStats": {
      "numSeries": 508,
      "chunkCount": 937,
      "minTime": 1591516800000,
      "maxTime": 1598896800143,
    },
    "seriesCountByMetricName": [
      {
        "name": "net_conntrack_dialer_conn_failed_total",
        "value": 20
      },
      {
        "name": "prometheus_http_request_duration_seconds_bucket",
        "value": 20
      }
    ],
    "labelValueCountByLabelName": [
      {
        "name": "__name__",
        "value": 211
      },
      {
        "name": "event",
        "value": 3
      }
    ],
    "memoryInBytesByLabelName": [
      {
        "name": "__name__",
        "value": 8266
      },
      {
        "name": "instance",
        "value": 28
      }
    ],
    "seriesCountByLabelValuePair": [
      {
        "name": "job=prometheus",
        "value": 425
      },
      {
        "name": "instance=localhost:9090",
        "value": 425
      }
    ]
  }
}
```

*New in v2.15*

### WAL Replay Stats

The following endpoint returns information about the WAL replay:

```
GET /api/v1/status/walreplay
```

**read**: The number of segments replayed so far. **total**: The total number segments needed to be replayed. **progress**: The progress of the replay (0 - 100%). **state**: The state of the replay. Possible states: - **waiting**: Waiting for the replay to start. - **in progress**: The replay is in progress. - **done**: The replay has finished.

```
$ curl http://localhost:9090/api/v1/status/walreplay
{
  "status": "success",
  "data": {
    "min": 2,
    "max": 5,
    "current": 40,
    "state": "in progress"
  }
}
```

**NOTE:** This endpoint is available before the server has  been marked ready and is updated in real time to facilitate monitoring  the progress of the WAL replay.

*New in v2.28*

## TSDB Admin APIs

These are APIs that expose database functionalities for the advanced user. These APIs are not enabled unless the `--web.enable-admin-api` is set.

### Snapshot

Snapshot creates a snapshot of all current data into `snapshots/<datetime>-<rand>` under the TSDB's data directory and returns the directory as response. It will optionally skip snapshotting data that is only present in the head block, and which has not yet been compacted to disk.

```
POST /api/v1/admin/tsdb/snapshot
PUT /api/v1/admin/tsdb/snapshot
```

URL query parameters:

- `skip_head=<bool>`: Skip data present in the head block. Optional.

```
$ curl -XPOST http://localhost:9090/api/v1/admin/tsdb/snapshot
{
  "status": "success",
  "data": {
    "name": "20171210T211224Z-2be650b6d019eb54"
  }
}
```

The snapshot now exists at `<data-dir>/snapshots/20171210T211224Z-2be650b6d019eb54`

*New in v2.1 and supports PUT from v2.9*

### Delete Series

DeleteSeries deletes data for a selection of series in a time range.  The actual data still exists on disk and is cleaned up in future  compactions or can be explicitly cleaned up by hitting the [Clean Tombstones](https://prometheus.io/docs/prometheus/latest/querying/api/#clean-tombstones) endpoint.

If successful, a `204` is returned.

```
POST /api/v1/admin/tsdb/delete_series
PUT /api/v1/admin/tsdb/delete_series
```

URL query parameters:

- `match[]=<series_selector>`: Repeated label matcher argument that selects the series to delete. At least one `match[]` argument must be provided.
- `start=<rfc3339 | unix_timestamp>`: Start timestamp. Optional and defaults to minimum possible time.
- `end=<rfc3339 | unix_timestamp>`: End timestamp. Optional and defaults to maximum possible time.

Not mentioning both start and end times would clear all the data for the matched series in the database.

Example:

```
$ curl -X POST \
  -g 'http://localhost:9090/api/v1/admin/tsdb/delete_series?match[]=up&match[]=process_start_time_seconds{job="prometheus"}'
```

**NOTE:** This endpoint marks samples from series as  deleted, but will not necessarily prevent associated series metadata  from still being returned in metadata queries for the affected time  range (even after cleaning tombstones). The exact extent of metadata  deletion is an implementation detail that may change in the future.

*New in v2.1 and supports PUT from v2.9*

### Clean Tombstones

CleanTombstones removes the deleted data from disk and cleans up the  existing tombstones. This can be used after deleting series to free up  space.

If successful, a `204` is returned.

```
POST /api/v1/admin/tsdb/clean_tombstones
PUT /api/v1/admin/tsdb/clean_tombstones
```

This takes no parameters or body.

```
$ curl -XPOST http://localhost:9090/api/v1/admin/tsdb/clean_tombstones
```

*New in v2.1 and supports PUT from v2.9*

## Remote Write Receiver

Prometheus can be configured as a receiver for the Prometheus remote write protocol. This is not considered an efficient way of ingesting samples. Use it with caution for specific low-volume use cases. It is not suitable for replacing the ingestion via scraping and turning Prometheus into a push-based metrics collection system.

Enable the remote write receiver by setting `--web.enable-remote-write-receiver`. When enabled, the remote write receiver endpoint is `/api/v1/write`. Find more details [here](https://prometheus.io/docs/prometheus/latest/storage/#overview).

*New in v2.33*

# Remote Read API

- [Format overview ](https://prometheus.io/docs/prometheus/latest/querying/remote_read_api/#format-overview)

- [Remote Read API ](https://prometheus.io/docs/prometheus/latest/querying/remote_read_api/#remote-read-api)

- - [Samples ](https://prometheus.io/docs/prometheus/latest/querying/remote_read_api/#samples)
  - [Streamed Chunks ](https://prometheus.io/docs/prometheus/latest/querying/remote_read_api/#streamed-chunks)

This is not currently considered part of the stable API and is subject to change even between non-major version releases of Prometheus.

## Format overview

The API response format is JSON. Every successful API request returns a `2xx` status code.

Invalid requests that reach the API handlers return a JSON error object and one of the following HTTP response codes:

- `400 Bad Request` when parameters are missing or incorrect.
- `422 Unprocessable Entity` when an expression can't be executed ([RFC4918](https://tools.ietf.org/html/rfc4918#page-78)).
- `503 Service Unavailable` when queries time out or abort.

Other non-`2xx` codes may be returned for errors occurring before the API endpoint is reached.

An array of warnings may be returned if there are errors that do not inhibit the request execution. All of the data that was successfully collected will be returned in the data field.

The JSON response envelope format is as follows:

```
{
  "status": "success" | "error",
  "data": <data>,

  // Only set if status is "error". The data field may still hold
  // additional data.
  "errorType": "<string>",
  "error": "<string>",

  // Only if there were warnings while executing the request.
  // There will still be data in the data field.
  "warnings": ["<string>"]
}
```

Generic placeholders are defined as follows:

- `<rfc3339 | unix_timestamp>`: Input timestamps may be provided either in [RFC3339](https://www.ietf.org/rfc/rfc3339.txt) format or as a Unix timestamp in seconds, with optional decimal places for sub-second precision. Output timestamps are always represented as Unix timestamps in seconds.
- `<series_selector>`: Prometheus [time series selectors](https://prometheus.io/docs/prometheus/latest/querying/basics/#time-series-selectors) like `http_requests_total` or `http_requests_total{method=~"(GET|POST)"}` and need to be URL-encoded.
- `<duration>`: [Prometheus duration strings](https://prometheus.io/docs/prometheus/latest/querying/basics/#time_durations). For example, `5m` refers to a duration of 5 minutes.
- `<bool>`: boolean values (strings `true` and `false`).

Note: Names of query parameters that may be repeated end with `[]`.

## Remote Read API

This API provides data read functionality from Prometheus. This interface expects [snappy](https://github.com/google/snappy) compression. The API definition is located [here](https://github.com/prometheus/prometheus/blob/master/prompb/remote.proto).

Request are made to the following endpoint. ` /api/v1/read `

### Samples

This returns a message that includes a list of raw samples.

### Streamed Chunks

These streamed chunks utilize an XOR algorithm inspired by the [Gorilla](http://www.vldb.org/pvldb/vol8/p1816-teller.pdf) compression to encode the chunks. However, it provides resolution to the millisecond instead of to the second.

# Storage

- [Local storage ](https://prometheus.io/docs/prometheus/latest/storage/#local-storage)

- - [On-disk layout ](https://prometheus.io/docs/prometheus/latest/storage/#on-disk-layout)

- [Compaction ](https://prometheus.io/docs/prometheus/latest/storage/#compaction)

- [Operational aspects ](https://prometheus.io/docs/prometheus/latest/storage/#operational-aspects)

- [Remote storage integrations ](https://prometheus.io/docs/prometheus/latest/storage/#remote-storage-integrations)

- - [Overview ](https://prometheus.io/docs/prometheus/latest/storage/#overview)
  - [Existing integrations ](https://prometheus.io/docs/prometheus/latest/storage/#existing-integrations)

- [Backfilling from OpenMetrics format ](https://prometheus.io/docs/prometheus/latest/storage/#backfilling-from-openmetrics-format)

- - [Overview ](https://prometheus.io/docs/prometheus/latest/storage/#overview)
  - [Usage ](https://prometheus.io/docs/prometheus/latest/storage/#usage)

- [Backfilling for Recording Rules ](https://prometheus.io/docs/prometheus/latest/storage/#backfilling-for-recording-rules)

- - [Overview ](https://prometheus.io/docs/prometheus/latest/storage/#overview)
  - [Usage ](https://prometheus.io/docs/prometheus/latest/storage/#usage)
  - [Limitations ](https://prometheus.io/docs/prometheus/latest/storage/#limitations)

Prometheus includes a local on-disk time series database, but also optionally integrates with remote storage systems.

## Local storage

Prometheus's local time series database stores data in a custom, highly efficient format on local storage.

### On-disk layout

Ingested samples are grouped into blocks of two hours. Each two-hour block consists of a directory containing a chunks subdirectory containing all the time series samples for that window of time, a metadata file, and an index file (which indexes metric names and labels to time series in the chunks directory). The samples in the chunks directory are grouped together into one or more segment files of up to 512MB each by default. When series are deleted via the API, deletion records are stored in separate tombstone files (instead of deleting the data immediately from the chunk segments).

The current block for incoming samples is kept in memory and is not fully persisted. It is secured against crashes by a write-ahead log (WAL) that can be replayed when the Prometheus server restarts. Write-ahead log files are stored in the `wal` directory in 128MB segments. These files contain raw data that has not yet been compacted; thus they are significantly larger than regular block files. Prometheus will retain a minimum of three write-ahead log files. High-traffic servers may retain more than three WAL files in order to keep at least two hours of raw data.

A Prometheus server's data directory looks something like this:

```
./data
├── 01BKGV7JBM69T2G1BGBGM6KB12
│   └── meta.json
├── 01BKGTZQ1SYQJTR4PB43C8PD98
│   ├── chunks
│   │   └── 000001
│   ├── tombstones
│   ├── index
│   └── meta.json
├── 01BKGTZQ1HHWHV8FBJXW1Y3W0K
│   └── meta.json
├── 01BKGV7JC0RY8A6MACW02A2PJD
│   ├── chunks
│   │   └── 000001
│   ├── tombstones
│   ├── index
│   └── meta.json
├── chunks_head
│   └── 000001
└── wal
    ├── 000000002
    └── checkpoint.00000001
        └── 00000000
```

Note that a limitation of local storage is that it is not clustered or replicated. Thus, it is not arbitrarily scalable or durable in the face of drive or node outages and should be managed like any other single node database. The use of RAID is suggested for storage availability, and [snapshots](https://prometheus.io/docs/prometheus/latest/querying/api/#snapshot) are recommended for backups. With proper architecture, it is possible to retain years of data in local storage.

Alternatively, external storage may be used via the [remote read/write APIs](https://prometheus.io/docs/operating/integrations/#remote-endpoints-and-storage). Careful evaluation is required for these systems as they vary greatly in durability, performance, and efficiency.

For further details on file format, see [TSDB format](https://github.com/prometheus/prometheus/blob/release-2.43/tsdb/docs/format/README.md).

## Compaction

The initial two-hour blocks are eventually compacted into longer blocks in the background.

Compaction will create larger blocks containing data spanning up to 10% of the retention time, or 31 days, whichever is smaller.

## Operational aspects

Prometheus has several flags that configure local storage. The most important are:

- `--storage.tsdb.path`: Where Prometheus writes its database. Defaults to `data/`.
- `--storage.tsdb.retention.time`: When to remove old data. Defaults to `15d`. Overrides `storage.tsdb.retention` if this flag is set to anything other than default.
- `--storage.tsdb.retention.size`: The maximum number of bytes of storage blocks to retain. The oldest data will be removed first. Defaults to `0` or disabled. Units supported: B, KB, MB, GB, TB, PB, EB. Ex: "512MB".  Based on powers-of-2, so 1KB is 1024B. Only the persistent blocks are  deleted to honor this retention although WAL and m-mapped chunks are  counted in the total size. So the minimum requirement for the disk is  the peak space taken by the `wal` (the WAL and Checkpoint) and `chunks_head` (m-mapped Head chunks) directory combined (peaks every 2 hours).
- `--storage.tsdb.retention`: Deprecated in favor of `storage.tsdb.retention.time`.
- `--storage.tsdb.wal-compression`: Enables compression of the  write-ahead log (WAL). Depending on your data, you can expect the WAL  size to be halved with little extra cpu load. This flag was introduced  in 2.11.0 and enabled by default in 2.20.0. Note that once enabled,  downgrading Prometheus to a version below 2.11.0 will require deleting  the WAL.

Prometheus stores an average of only 1-2 bytes per sample. Thus, to  plan the capacity of a Prometheus server, you can use the rough formula:

```
needed_disk_space = retention_time_seconds * ingested_samples_per_second * bytes_per_sample
```

To lower the rate of ingested samples, you can either reduce the  number of time series you scrape (fewer targets or fewer series per  target), or you can increase the scrape interval. However, reducing the  number of series is likely more effective, due to compression of samples within a series.

If your local storage becomes corrupted for whatever reason, the best strategy to address the problem is to shut down Prometheus then remove the entire storage directory. You can also try removing individual block directories, or the WAL directory to resolve the problem.  Note that this means losing approximately two hours data per block directory. Again, Prometheus's local storage is not intended to be durable long-term storage; external solutions offer extended retention and data durability.

**CAUTION:** Non-POSIX compliant filesystems are not  supported for Prometheus' local storage as unrecoverable corruptions may happen. NFS filesystems (including AWS's EFS) are not supported. NFS  could be POSIX-compliant, but most implementations are not. It is  strongly recommended to use a local filesystem for reliability.

If both time and size retention policies are specified, whichever triggers first will be used.

Expired block cleanup happens in the background. It may take up to  two hours to remove expired blocks. Blocks must be fully expired before  they are removed.

## Remote storage integrations

Prometheus's local storage is limited to a single node's scalability and durability. Instead of trying to solve clustered storage in Prometheus itself, Prometheus offers a set of interfaces that allow integrating with remote storage systems.

### Overview

Prometheus integrates with remote storage systems in three ways:

- Prometheus can write samples that it ingests to a remote URL in a standardized format.
- Prometheus can receive samples from other Prometheus servers in a standardized format.
- Prometheus can read (back) sample data from a remote URL in a standardized format.

![Remote read and write architecture](https://prometheus.io/docs/prometheus/latest/images/remote_integrations.png)

The read and write protocols both use a snappy-compressed protocol  buffer encoding over HTTP. The protocols are not considered as stable  APIs yet and may change to use gRPC over HTTP/2 in the future, when all  hops between Prometheus and the remote storage can safely be assumed to  support HTTP/2.

For details on configuring remote storage integrations in Prometheus, see the [remote write](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#remote_write) and [remote read](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#remote_read) sections of the Prometheus configuration documentation.

The built-in remote write receiver can be enabled by setting the `--web.enable-remote-write-receiver` command line flag. When enabled, the remote write receiver endpoint is `/api/v1/write`.

For details on the request and response messages, see the [remote storage protocol buffer definitions](https://github.com/prometheus/prometheus/blob/main/prompb/remote.proto).

Note that on the read path, Prometheus only fetches raw series data  for a set of label selectors and time ranges from the remote end. All  PromQL evaluation on the raw data still happens in Prometheus itself.  This means that remote read queries have some scalability limit, since  all necessary data needs to be loaded into the querying Prometheus  server first and then processed there. However, supporting fully  distributed evaluation of PromQL was deemed infeasible for the time  being.

### Existing integrations

To learn more about existing integrations with remote storage systems, see the [Integrations documentation](https://prometheus.io/docs/operating/integrations/#remote-endpoints-and-storage).

## Backfilling from OpenMetrics format

### Overview

If a user wants to create blocks into the TSDB from data that is in [OpenMetrics](https://openmetrics.io/) format, they can do so using backfilling. However, they should be  careful and note that it is not safe to backfill data from the last 3  hours (the current head block) as this time range may overlap with the  current head block Prometheus is still mutating. Backfilling will create new TSDB blocks, each containing two hours of metrics data. This limits the memory requirements of block creation. Compacting the two hour  blocks into larger blocks is later done by the Prometheus server itself.

A typical use case is to migrate metrics data from a different  monitoring system or time-series database to Prometheus. To do so, the  user must first convert the source data into [OpenMetrics](https://openmetrics.io/)  format, which is the input format for the backfilling as described below.

### Usage

Backfilling can be used via the Promtool command line. Promtool will  write the blocks to a directory. By default this output directory is  ./data/, you can change it by using the name of the desired output  directory as an optional argument in the sub-command.

```
promtool tsdb create-blocks-from openmetrics <input file> [<output directory>]
```

After the creation of the blocks, move it to the data directory of  Prometheus. If there is an overlap with the existing blocks in  Prometheus, the flag `--storage.tsdb.allow-overlapping-blocks` needs to be set for Prometheus versions v2.38 and below. Note that any  backfilled data is subject to the retention configured for your  Prometheus server (by time or size).

#### Longer Block Durations

By default, the promtool will use the default block duration (2h) for the blocks; this behavior is the most generally applicable and correct. However, when backfilling data over a long range of times, it may be  advantageous to use a larger value for the block duration to backfill  faster and prevent additional compactions by TSDB later.

The `--max-block-duration` flag allows the user to  configure a maximum duration of blocks. The backfilling tool will pick a suitable block duration no larger than this.

While larger blocks may improve the performance of backfilling large  datasets, drawbacks exist as well. Time-based retention policies must  keep the entire block around if even one sample of the (potentially  large) block is still within the retention policy. Conversely,  size-based retention policies will remove the entire block even if the  TSDB only goes over the size limit in a minor way.

Therefore, backfilling with few blocks, thereby choosing a larger  block duration, must be done with care and is not recommended for any  production instances.

## Backfilling for Recording Rules

### Overview

When a new recording rule is created, there is no historical data for it. Recording rule data only exists from the creation time on. `promtool` makes it possible to create historical recording rule data.

### Usage

To see all options, use: `$ promtool tsdb create-blocks-from rules --help`.

Example usage:

```
$ promtool tsdb create-blocks-from rules \
    --start 1617079873 \
    --end 1617097873 \
    --url http://mypromserver.com:9090 \
    rules.yaml rules2.yaml
```

The recording rule files provided should be a normal [Prometheus rules file](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/).

The output of `promtool tsdb create-blocks-from rules`  command is a directory that contains blocks with the historical rule  data for all rules in the recording rule files. By default, the output  directory is `data/`. In order to make use of this new block data, the blocks must be moved to a running Prometheus instance data dir `storage.tsdb.path` (for Prometheus versions v2.38 and below, the flag `--storage.tsdb.allow-overlapping-blocks` must be enabled). Once moved, the new blocks will merge with existing blocks when the next compaction runs.

### Limitations

- If you run the rule backfiller multiple times with the overlapping  start/end times, blocks containing the same data will be created each  time the rule backfiller is run.
- All rules in the recording rule files will be evaluated.
- If the `interval` is set in the recording rule file that will take priority over the `eval-interval` flag in the rule backfill command.
- Alerts are currently ignored if they are in the recording rule file.
- Rules in the same group cannot see the results of previous rules.  Meaning that rules that refer to other rules being backfilled is not  supported. A workaround is to backfill multiple times and create the  dependent data first (and move dependent data to the Prometheus server  data dir so that it is accessible from the Prometheus API).

# Federation

- [Use cases ](https://prometheus.io/docs/prometheus/latest/federation/#use-cases)

- - [Hierarchical federation ](https://prometheus.io/docs/prometheus/latest/federation/#hierarchical-federation)
  - [Cross-service federation ](https://prometheus.io/docs/prometheus/latest/federation/#cross-service-federation)

- [Configuring federation ](https://prometheus.io/docs/prometheus/latest/federation/#configuring-federation)

Federation allows a Prometheus server to scrape selected time series from another Prometheus server.

*Note about native histograms (experimental feature): To scrape native histograms via federation, the scraping Prometheus server needs to run with native histograms enabled (via the command line flag `--enable-feature=native-histograms`), implying that the protobuf format is used for scraping. Should the federated metrics contain a mix of different sample types (float64, counter histogram, gauge histogram) for the same metric name, the federation payload will contain multiple metric families with the same name (but different types). Technically, this violates the rules of the protobuf exposition format, but Prometheus is nevertheless able to ingest all metrics correctly.*

## Use cases

There are different use cases for federation. Commonly, it is used to either achieve scalable Prometheus monitoring setups or to pull related metrics from one service's Prometheus into another.

### Hierarchical federation

Hierarchical federation allows Prometheus to scale to environments with tens of data centers and millions of nodes. In this use case, the federation topology resembles a tree, with higher-level Prometheus servers collecting aggregated time series data from a larger number of subordinated servers.

For example, a setup might consist of many per-datacenter Prometheus servers that collect data in high detail (instance-level drill-down), and a set of global Prometheus servers which collect and store only aggregated data (job-level drill-down) from those local servers. This provides an aggregate global view and detailed local views.

### Cross-service federation

In cross-service federation, a Prometheus server of one service is configured to scrape selected data from another service's Prometheus server to enable alerting and queries against both datasets within a single server.

For example, a cluster scheduler running multiple services might expose resource usage information (like memory and CPU usage) about service instances running on the cluster. On the other hand, a service running on that cluster will only expose application-specific service metrics. Often, these two sets of metrics are scraped by separate Prometheus servers. Using federation, the Prometheus server containing service-level metrics may pull in the cluster resource usage metrics about its specific service from the cluster Prometheus, so that both sets of metrics can be used within that server.

## Configuring federation

On any given Prometheus server, the `/federate` endpoint allows retrieving the current value for a selected set of time series in that server. At least one `match[]` URL parameter must be specified to select the series to expose. Each `match[]` argument needs to specify an [instant vector selector](https://prometheus.io/docs/prometheus/latest/querying/basics/#instant-vector-selectors) like `up` or `{job="api-server"}`. If multiple `match[]` parameters are provided, the union of all matched series is selected.

To federate metrics from one server to another, configure your destination Prometheus server to scrape from the `/federate` endpoint of a source server, while also enabling the `honor_labels` scrape option (to not overwrite any labels exposed by the source server) and passing in the desired `match[]` parameters. For example, the following `scrape_configs` federates any series with the label `job="prometheus"` or a metric name starting with `job:` from the Prometheus servers at `source-prometheus-{1,2,3}:9090` into the scraping Prometheus:

```
scrape_configs:
  - job_name: 'federate'
    scrape_interval: 15s

    honor_labels: true
    metrics_path: '/federate'

    params:
      'match[]':
        - '{job="prometheus"}'
        - '{__name__=~"job:.*"}'

    static_configs:
      - targets:
        - 'source-prometheus-1:9090'
        - 'source-prometheus-2:9090'
        - 'source-prometheus-3:9090'
```

# Writing HTTP Service Discovery

- [Comparison between File-Based SD and HTTP SD ](https://prometheus.io/docs/prometheus/latest/http_sd/#comparison-between-file-based-sd-and-http-sd)
- [Requirements of HTTP SD endpoints ](https://prometheus.io/docs/prometheus/latest/http_sd/#requirements-of-http-sd-endpoints)
- [HTTP_SD format ](https://prometheus.io/docs/prometheus/latest/http_sd/#http_sd-format)

Prometheus provides a generic [HTTP Service Discovery](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#http_sd_config), that enables it to discover targets over an HTTP endpoint.

The HTTP Service Discovery is complimentary to the supported service discovery mechanisms, and is an alternative to [File-based Service Discovery](https://prometheus.io/docs/guides/file-sd/#use-file-based-service-discovery-to-discover-scrape-targets).

## Comparison between File-Based SD and HTTP SD

Here is a table comparing our two generic Service Discovery implementations.

| Item             | File SD                    | HTTP SD                                       |
| ---------------- | -------------------------- | --------------------------------------------- |
| Event Based      | Yes, via inotify           | No                                            |
| Update frequency | Instant, thanks to inotify | Following refresh_interval                    |
| Format           | Yaml or JSON               | JSON                                          |
| Transport        | Local file                 | HTTP/HTTPS                                    |
| Security         | File-Based security        | TLS, Basic auth, Authorization header, OAuth2 |

## Requirements of HTTP SD endpoints

If you implement an HTTP SD endpoint, here are a few requirements you should be aware of.

The response is consumed as is, unmodified. On each refresh interval (default: 1 minute), Prometheus will perform a GET request to the HTTP SD endpoint. The GET request contains a `X-Prometheus-Refresh-Interval-Seconds` HTTP header with the refresh interval.

The SD endpoint must answer with an HTTP 200 response, with the HTTP Header `Content-Type: application/json`. The answer must be UTF-8 formatted. If no targets should be transmitted, HTTP 200 must also be emitted, with an empty list `[]`. Target lists are unordered.

Prometheus caches target lists. If an error occurs while fetching an updated targets list, Prometheus keeps using the current targets list. The targets list is not saved across restart. The `prometheus_sd_http_failures_total` counter  metric tracks the number of refresh failures.

The whole list of targets must be returned on every scrape. There is no support for incremental updates. A Prometheus instance does not send its hostname and it is not possible for a SD endpoint to know if the SD requests is the first one after a restart or not.

The URL to the HTTP SD is not considered secret. The authentication and any API keys should be passed with the appropriate authentication mechanisms. Prometheus supports TLS authentication, basic authentication, OAuth2, and authorization headers.

## HTTP_SD format

```
[
  {
    "targets": [ "<host>", ... ],
    "labels": {
      "<labelname>": "<labelvalue>", ...
    }
  },
  ...
]
```

Examples:

```
[
    {
        "targets": ["10.0.10.2:9100", "10.0.10.3:9100", "10.0.10.4:9100", "10.0.10.5:9100"],
        "labels": {
            "__meta_datacenter": "london",
            "__meta_prometheus_job": "node"
        }
    },
    {
        "targets": ["10.0.40.2:9100", "10.0.40.3:9100"],
        "labels": {
            "__meta_datacenter": "london",
            "__meta_prometheus_job": "alertmanager"
        }
    },
    {
        "targets": ["10.0.40.2:9093", "10.0.40.3:9093"],
        "labels": {
            "__meta_datacenter": "newyork",
            "__meta_prometheus_job": "alertmanager"
        }
    }
]
```

# Management API

- [Health check ](https://prometheus.io/docs/prometheus/latest/management_api/#health-check)
- [Readiness check ](https://prometheus.io/docs/prometheus/latest/management_api/#readiness-check)
- [Reload ](https://prometheus.io/docs/prometheus/latest/management_api/#reload)
- [Quit ](https://prometheus.io/docs/prometheus/latest/management_api/#quit)

Prometheus provides a set of management APIs to facilitate automation and integration.

### Health check

```
GET /-/healthy
HEAD /-/healthy
```

This endpoint always returns 200 and should be used to check Prometheus health.

### Readiness check

```
GET /-/ready
HEAD /-/ready
```

This endpoint returns 200 when Prometheus is ready to serve traffic (i.e. respond to queries).

### Reload

```
PUT  /-/reload
POST /-/reload
```

This endpoint triggers a reload of the Prometheus configuration and  rule files. It's disabled by default and can be enabled via the `--web.enable-lifecycle` flag.

Alternatively, a configuration reload can be triggered by sending a `SIGHUP` to the Prometheus process.

### Quit

```
PUT  /-/quit
POST /-/quit
```

This endpoint triggers a graceful shutdown of Prometheus. It's disabled by default and can be enabled via the `--web.enable-lifecycle` flag.

Alternatively, a graceful shutdown can be triggered by sending a `SIGTERM` to the Prometheus process.

# Prometheus 2.0 migration guide

- [Flags ](https://prometheus.io/docs/prometheus/latest/migration/#flags)

- [Alertmanager service discovery ](https://prometheus.io/docs/prometheus/latest/migration/#alertmanager-service-discovery)

- [Recording rules and alerts ](https://prometheus.io/docs/prometheus/latest/migration/#recording-rules-and-alerts)

- [Storage ](https://prometheus.io/docs/prometheus/latest/migration/#storage)

- [PromQL ](https://prometheus.io/docs/prometheus/latest/migration/#promql)

- [Miscellaneous ](https://prometheus.io/docs/prometheus/latest/migration/#miscellaneous)

- - [Prometheus non-root user ](https://prometheus.io/docs/prometheus/latest/migration/#prometheus-non-root-user)
  - [Prometheus lifecycle ](https://prometheus.io/docs/prometheus/latest/migration/#prometheus-lifecycle)

In line with our [stability promise](https://prometheus.io/blog/2016/07/18/prometheus-1-0-released/#fine-print), the Prometheus 2.0 release contains a number of backwards incompatible changes. This document offers guidance on migrating from Prometheus 1.8 to Prometheus 2.0 and newer versions.

## Flags

The format of Prometheus command line flags has changed. Instead of a single dash, all flags now use a double dash. Common flags (`--config.file`, `--web.listen-address` and `--web.external-url`) remain but almost all storage-related flags have been removed.

Some notable flags which have been removed:

- `-alertmanager.url` In Prometheus 2.0, the command line flags for configuring a static Alertmanager URL have been removed. Alertmanager must now be discovered via service discovery, see [Alertmanager service discovery](https://prometheus.io/docs/prometheus/latest/migration/#alertmanager-service-discovery).
- `-log.format` In Prometheus 2.0 logs can only be streamed to standard error.
- `-query.staleness-delta` has been renamed to `--query.lookback-delta`; Prometheus 2.0 introduces a new mechanism for handling staleness, see [staleness](https://prometheus.io/docs/prometheus/latest/querying/basics/#staleness).
- `-storage.local.*` Prometheus 2.0 introduces a new storage engine; as such all flags relating to the old engine have been removed.  For information on the new engine, see [Storage](https://prometheus.io/docs/prometheus/latest/migration/#storage).
- `-storage.remote.*` Prometheus 2.0 has removed the deprecated remote storage flags, and will fail to start if they are supplied. To write to InfluxDB, Graphite, or OpenTSDB use the relevant storage adapter.

## Alertmanager service discovery

Alertmanager service discovery was introduced in Prometheus 1.4, allowing Prometheus to dynamically discover Alertmanager replicas using the same mechanism as scrape targets. In Prometheus 2.0, the command line flags for static Alertmanager config have been removed, so the following command line flag:

```
./prometheus -alertmanager.url=http://alertmanager:9093/
```

Would be replaced with the following in the `prometheus.yml` config file:

```
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      - alertmanager:9093
```

You can also use all the usual Prometheus service discovery integrations and relabeling in your Alertmanager configuration. This snippet instructs Prometheus to search for Kubernetes pods, in the `default` namespace, with the label `name: alertmanager` and with a non-empty port.

```
alerting:
  alertmanagers:
  - kubernetes_sd_configs:
      - role: pod
    tls_config:
      ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
    relabel_configs:
    - source_labels: [__meta_kubernetes_pod_label_name]
      regex: alertmanager
      action: keep
    - source_labels: [__meta_kubernetes_namespace]
      regex: default
      action: keep
    - source_labels: [__meta_kubernetes_pod_container_port_number]
      regex:
      action: drop
```

## Recording rules and alerts

The format for configuring alerting and recording rules has been changed to YAML. An example of a recording rule and alert in the old format:

```
job:request_duration_seconds:histogram_quantile99 =
  histogram_quantile(0.99, sum by (le, job) (rate(request_duration_seconds_bucket[1m])))

ALERT FrontendRequestLatency
  IF job:request_duration_seconds:histogram_quantile99{job="frontend"} > 0.1
  FOR 5m
  ANNOTATIONS {
    summary = "High frontend request latency",
  }
```

Would look like this:

```
groups:
- name: example.rules
  rules:
  - record: job:request_duration_seconds:histogram_quantile99
    expr: histogram_quantile(0.99, sum by (le, job) (rate(request_duration_seconds_bucket[1m])))
  - alert: FrontendRequestLatency
    expr: job:request_duration_seconds:histogram_quantile99{job="frontend"} > 0.1
    for: 5m
    annotations:
      summary: High frontend request latency
```

To help with the change, the `promtool` tool has a mode to automate the rules conversion.  Given a `.rules` file, it will output a `.rules.yml` file in the new format. For example:

```
$ promtool update rules example.rules
```

You will need to use `promtool` from [Prometheus 2.5](https://github.com/prometheus/prometheus/releases/tag/v2.5.0) as later versions no longer contain the above subcommand.

## Storage

The data format in Prometheus 2.0 has completely changed and is not backwards compatible with 1.8 and older versions. To retain access to your historic monitoring data we recommend you run a non-scraping Prometheus instance running at least version 1.8.1 in parallel with your Prometheus 2.0 instance, and have the new server read existing data from the old one via the remote read protocol.

Your Prometheus 1.8 instance should be started with the following flags and an config file containing only the `external_labels` setting (if any):

```
$ ./prometheus-1.8.1.linux-amd64/prometheus -web.listen-address ":9094" -config.file old.yml
```

Prometheus 2.0 can then be started (on the same machine) with the following flags:

```
$ ./prometheus-2.0.0.linux-amd64/prometheus --config.file prometheus.yml
```

Where `prometheus.yml` contains in addition to your full existing configuration, the stanza:

```
remote_read:
  - url: "http://localhost:9094/api/v1/read"
```

## PromQL

The following features have been removed from PromQL:

- `drop_common_labels` function - the `without` aggregation modifier should be used instead.
- `keep_common` aggregation modifier - the `by` modifier should be used instead.
- `count_scalar` function - use cases are better handled by `absent()` or correct propagation of labels in operations.

See [issue #3060](https://github.com/prometheus/prometheus/issues/3060) for more details.

## Miscellaneous

### Prometheus non-root user

The Prometheus Docker image is now built to [run Prometheus as a non-root user](https://github.com/prometheus/prometheus/pull/2859). If you want the Prometheus UI/API to listen on a low port number (say, port 80), you'll need to override it. For Kubernetes, you would use the following YAML:

```
apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo-2
spec:
  securityContext:
    runAsUser: 0
...
```

See [Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) for more details.

If you're using Docker, then the following snippet would be used:

```
docker run -p 9090:9090 prom/prometheus:latest
```

### Prometheus lifecycle

If you use the Prometheus `/-/reload` HTTP endpoint to [automatically reload your Prometheus config when it changes](https://prometheus.io/docs/prometheus/latest/configuration/configuration/), these endpoints are disabled by default for security reasons in Prometheus 2.0. To enable them, set the `--web.enable-lifecycle` flag.

# API Stability Guarantees

Prometheus promises API stability within a major version, and strives to avoid breaking changes for key features. Some features, which are cosmetic, still under development, or depend on 3rd party services, are not covered by this.

Things considered stable for 2.x:

- The query language and data model
- Alerting and recording rules
- The ingestion exposition format
- v1 HTTP API (used by dashboards and UIs)
- Configuration file format (minus the service discovery remote read/write, see below)
- Rule/alert file format
- Console template syntax and semantics

Things considered unstable for 2.x:

- Any feature listed as experimental or subject to change, including:
  - The [`holt_winters` PromQL function](https://github.com/prometheus/prometheus/issues/2458)
  - Remote read, remote write and the remote read endpoint
- Server-side HTTPS and basic authentication
- Service discovery integrations, with the exception of `static_configs` and `file_sd_configs`
- Go APIs of packages that are part of the server
- HTML generated by the web UI
- The metrics in the /metrics endpoint of Prometheus itself
- Exact on-disk format. Potential changes however, will be forward compatible and transparently handled by Prometheus
- The format of the logs

As long as you are not using any features marked as experimental/unstable, an upgrade within a major version can usually be performed without any operational adjustments and very little risk that anything will break. Any breaking changes will be marked as `CHANGE` in release notes.

# Feature flags

- [Expand environment variables in external labels ](https://prometheus.io/docs/prometheus/latest/feature_flags/#expand-environment-variables-in-external-labels)
- [Remote Write Receiver ](https://prometheus.io/docs/prometheus/latest/feature_flags/#remote-write-receiver)
- [Exemplars storage ](https://prometheus.io/docs/prometheus/latest/feature_flags/#exemplars-storage)
- [Memory snapshot on shutdown ](https://prometheus.io/docs/prometheus/latest/feature_flags/#memory-snapshot-on-shutdown)
- [Extra scrape metrics ](https://prometheus.io/docs/prometheus/latest/feature_flags/#extra-scrape-metrics)
- [New service discovery manager ](https://prometheus.io/docs/prometheus/latest/feature_flags/#new-service-discovery-manager)
- [Prometheus agent ](https://prometheus.io/docs/prometheus/latest/feature_flags/#prometheus-agent)
- [Per-step stats ](https://prometheus.io/docs/prometheus/latest/feature_flags/#per-step-stats)
- [Auto GOMAXPROCS ](https://prometheus.io/docs/prometheus/latest/feature_flags/#auto-gomaxprocs)
- [No default scrape port ](https://prometheus.io/docs/prometheus/latest/feature_flags/#no-default-scrape-port)
- [Native Histograms ](https://prometheus.io/docs/prometheus/latest/feature_flags/#native-histograms)

Here is a list of features that are disabled by default since they are breaking changes or are considered experimental. Their behaviour can change in future releases which will be communicated via the [release changelog](https://github.com/prometheus/prometheus/blob/main/CHANGELOG.md).

You can enable them using the `--enable-feature` flag with a comma separated list of features. They may be enabled by default in future versions.

## Expand environment variables in external labels

```
--enable-feature=expand-external-labels
```

Replace `${var}` or `$var` in the [`external_labels`](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#configuration-file) values according to the values of the current environment variables. References to undefined variables are replaced by the empty string. The `$` character can be escaped by using `$$`.

## Remote Write Receiver

```
--enable-feature=remote-write-receiver
```

The remote write receiver allows Prometheus to accept remote write  requests from other Prometheus servers. More details can be found [here](https://prometheus.io/docs/prometheus/latest/storage/#overview).

Activating the remote write receiver via a feature flag is deprecated. Use `--web.enable-remote-write-receiver` instead. This feature flag will be ignored in future versions of Prometheus.

## Exemplars storage

```
--enable-feature=exemplar-storage
```

[OpenMetrics](https://github.com/OpenObservability/OpenMetrics/blob/main/specification/OpenMetrics.md#exemplars) introduces the ability for scrape targets to add exemplars to certain  metrics. Exemplars are references to data outside of the MetricSet. A  common use case are IDs of program traces.

Exemplar storage is implemented as a fixed size circular buffer that  stores exemplars in memory for all series. Enabling this feature will  enable the storage of exemplars scraped by Prometheus. The config file  block [storage](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#configuration-file)/[exemplars](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#exemplars) can be used to control the size of circular buffer by # of exemplars. An exemplar with just a `traceID=<jaeger-trace-id>` uses roughly 100 bytes of memory via the in-memory exemplar storage. If the exemplar storage is enabled, we will also append the exemplars to  WAL for local persistence (for WAL duration).

## Memory snapshot on shutdown

```
--enable-feature=memory-snapshot-on-shutdown
```

This takes the snapshot of the chunks that are in memory along with the series information when shutting down and stores it on disk. This will reduce the startup time since the memory state can be restored with this snapshot and m-mapped chunks without the need of WAL replay.

## Extra scrape metrics

```
--enable-feature=extra-scrape-metrics
```

When enabled, for each instance scrape, Prometheus stores a sample in the following additional time series:

- `scrape_timeout_seconds`. The configured `scrape_timeout` for a target. This allows you to measure each target to find out how close they are to timing out with `scrape_duration_seconds / scrape_timeout_seconds`.
- `scrape_sample_limit`. The configured `sample_limit` for a target. This allows you to measure each target to find out how close they are to reaching the limit with `scrape_samples_post_metric_relabeling / scrape_sample_limit`. Note that `scrape_sample_limit` can be zero if there is no limit configured, which means that the query above can return `+Inf` for targets with no limit (as we divide by zero). If you want to query  only for targets that do have a sample limit use this query: `scrape_samples_post_metric_relabeling / (scrape_sample_limit > 0)`.
- `scrape_body_size_bytes`. The uncompressed size of the most recent scrape response, if successful. Scrapes failing because `body_size_limit` is exceeded report `-1`, other scrape failures report `0`.

## New service discovery manager

```
--enable-feature=new-service-discovery-manager
```

When enabled, Prometheus uses a new service discovery manager that does not restart unchanged discoveries upon reloading. This makes reloads faster and reduces pressure on service discoveries' sources.

Users are encouraged to test the new service discovery manager and report any issues upstream.

In future releases, this new service discovery manager will become the default and this feature flag will be ignored.

## Prometheus agent

```
--enable-feature=agent
```

When enabled, Prometheus runs in agent mode. The agent mode is limited to discovery, scrape and remote write.

This is useful when you do not need to query the Prometheus data locally, but only from a central [remote endpoint](https://prometheus.io/docs/operating/integrations/#remote-endpoints-and-storage).

## Per-step stats

```
--enable-feature=promql-per-step-stats
```

When enabled, passing `stats=all` in a query request returns per-step statistics. Currently this is limited to totalQueryableSamples.

When disabled in either the engine or the query, per-step statistics are not computed at all.

## Auto GOMAXPROCS

```
--enable-feature=auto-gomaxprocs
```

When enabled, GOMAXPROCS variable is automatically set to match Linux container CPU quota.

## No default scrape port

```
--enable-feature=no-default-scrape-port
```

When enabled, the default ports for HTTP (`:80`) or HTTPS (`:443`) will *not* be added to the address used to scrape a target (the value of the `__address_` label), contrary to the default behavior. In addition, if a default HTTP or HTTPS port has already been added either in a static configuration or by a service discovery mechanism and the respective scheme is specified (`http` or `https`), that port will be removed.

## Native Histograms

```
--enable-feature=native-histograms
```

When enabled, Prometheus will ingest native histograms (formerly also known as sparse histograms or high-res histograms). Native histograms are still highly experimental. Expect breaking changes to happen (including those rendering the TSDB unreadable).

Native histograms are currently only supported in the traditional Prometheus protobuf exposition format. This feature flag therefore also enables a new (and also experimental) protobuf parser, through which *all* metrics are ingested (i.e. not only native histograms). Prometheus will try to negotiate the protobuf format first. The instrumented target needs to support the protobuf format, too, *and* it needs to expose native histograms. The protobuf format allows to expose conventional and native histograms side by side. With this feature flag disabled, Prometheus will continue to parse the conventional histogram (albeit via the text format). With this flag enabled, Prometheus will still ingest those conventional histograms that do not come with a corresponding native histogram. However, if a native histogram is present, Prometheus will ignore the corresponding conventional histogram, with the notable exception of exemplars, which are always ingested.

# [Visualization](https://prometheus.io/docs/visualization/browser/#)

# Expression browser

The expression browser is available at `/graph` on the Prometheus server, allowing you to enter any expression and see its result either in a table or graphed over time.

This is primarily useful for ad-hoc queries and debugging. For graphs, use [Grafana](https://prometheus.io/docs/visualization/grafana/) or [Console templates](https://prometheus.io/docs/visualization/consoles/).

# Grafana support for Prometheus

- [Installing ](https://prometheus.io/docs/visualization/grafana/#installing)

- [Using ](https://prometheus.io/docs/visualization/grafana/#using)

- - [Creating a Prometheus data source ](https://prometheus.io/docs/visualization/grafana/#creating-a-prometheus-data-source)
  - [Creating a Prometheus graph ](https://prometheus.io/docs/visualization/grafana/#creating-a-prometheus-graph)
  - [Importing pre-built dashboards from Grafana.com ](https://prometheus.io/docs/visualization/grafana/#importing-pre-built-dashboards-from-grafana-com)

[Grafana](http://grafana.com/) supports querying Prometheus. The Grafana data source for Prometheus is included since Grafana 2.5.0 (2015-10-28).

The following shows an example Grafana dashboard which queries Prometheus for data:

[![Grafana screenshot](https://prometheus.io/assets/grafana_prometheus.png)](https://prometheus.io/assets/grafana_prometheus.png)

## Installing

To install Grafana see the [official Grafana documentation](https://grafana.com/grafana/download/).

## Using

By default, Grafana will be listening on http://localhost:3000. The default login is "admin" / "admin".

### Creating a Prometheus data source

To create a Prometheus data source in Grafana:

1. Click on the "cogwheel" in the sidebar to open the Configuration menu.
2. Click on "Data Sources".
3. Click on "Add data source".
4. Select "Prometheus" as the type.
5. Set the appropriate Prometheus server URL (for example, `http://localhost:9090/`)
6. Adjust other data source settings as desired (for example, choosing the right Access method).
7. Click "Save & Test" to save the new data source.

The following shows an example data source configuration:

[![Data source configuration](https://prometheus.io/assets/grafana_configuring_datasource.png)](https://prometheus.io/assets/grafana_configuring_datasource.png)

### Creating a Prometheus graph

Follow the standard way of adding a new Grafana graph. Then:

1. Click the graph title, then click "Edit".
2. Under the "Metrics" tab, select your Prometheus data source (bottom right).
3. Enter any Prometheus expression into the "Query" field, while using the "Metric" field to lookup metrics via autocompletion.
4. To format the legend names of time series, use the "Legend format" input. For example, to show only the `method` and `status` labels of a returned query result, separated by a dash, you could use the legend format string `{{method}} - {{status}}`.
5. Tune other graph settings until you have a working graph.

The following shows an example Prometheus graph configuration: [![Prometheus graph creation](https://prometheus.io/assets/grafana_qps_graph.png)](https://prometheus.io/assets/grafana_qps_graph.png)

In Grafana 7.2 and later, the `$__rate_interval` variable is [recommended](https://grafana.com/docs/grafana/latest/datasources/prometheus/#using-__rate_interval) for use in the `rate`and `increase` functions.

### Importing pre-built dashboards from Grafana.com

Grafana.com maintains [a collection of shared dashboards](https://grafana.com/dashboards) which can be downloaded and used with standalone instances of Grafana.  Use the Grafana.com "Filter" option to browse dashboards for the "Prometheus" data source only.

You must currently manually edit the downloaded JSON files and correct the `datasource:` entries to reflect the Grafana data source name which you chose for your Prometheus server.  Use the "Dashboards" → "Home" → "Import" option to import the edited dashboard file into your Grafana install.

# Console templates

- [Getting started ](https://prometheus.io/docs/visualization/consoles/#getting-started)
- [Example Console ](https://prometheus.io/docs/visualization/consoles/#example-console)
- [Graph Library ](https://prometheus.io/docs/visualization/consoles/#graph-library)

Console templates allow for creation of arbitrary consoles using the [Go templating language](https://golang.org/pkg/text/template/). These are served from the Prometheus server.

Console templates are the most powerful way to create templates that can be easily managed in source control. There is a learning curve though, so users new to this style of monitoring should try out [Grafana](https://prometheus.io/docs/visualization/grafana/) first.

## Getting started

Prometheus comes with an example set of consoles to get you going. These can be found at `/consoles/index.html.example` on a running Prometheus and will display Node Exporter consoles if Prometheus is scraping Node Exporters with a `job="node"` label.

The example consoles have 5 parts:

1. A navigation bar on top
2. A menu on the left
3. Time controls on the bottom
4. The main content in the center, usually graphs
5. A table on the right

The navigation bar is for links to other systems, such as other Prometheis [1](https://prometheus.io/docs/introduction/faq/#what-is-the-plural-of-prometheus), documentation, and whatever else makes sense to you. The menu is for navigation inside the same Prometheus server, which is very useful to be able to quickly open a console in another tab to correlate information. Both are configured in `console_libraries/menu.lib`.

The time controls allow changing of the duration and range of the graphs. Console URLs can be shared and will show the same graphs for others.

The main content is usually graphs. There is a configurable JavaScript graphing library provided that will handle requesting data from Prometheus, and rendering it via [Rickshaw](https://shutterstock.github.io/rickshaw/).

Finally, the table on the right can be used to display statistics in a more compact form than graphs.

## Example Console

This is a basic console. It shows the number of tasks, how many of them are up, the average CPU usage, and the average memory usage in the right-hand-side table. The main content has a queries-per-second graph.

```
{{template "head" .}}

{{template "prom_right_table_head"}}
<tr>
  <th>MyJob</th>
  <th>{{ template "prom_query_drilldown" (args "sum(up{job='myjob'})") }}
      / {{ template "prom_query_drilldown" (args "count(up{job='myjob'})") }}
  </th>
</tr>
<tr>
  <td>CPU</td>
  <td>{{ template "prom_query_drilldown" (args
      "avg by(job)(rate(process_cpu_seconds_total{job='myjob'}[5m]))"
      "s/s" "humanizeNoSmallPrefix") }}
  </td>
</tr>
<tr>
  <td>Memory</td>
  <td>{{ template "prom_query_drilldown" (args
       "avg by(job)(process_resident_memory_bytes{job='myjob'})"
       "B" "humanize1024") }}
  </td>
</tr>
{{template "prom_right_table_tail"}}


{{template "prom_content_head" .}}
<h1>MyJob</h1>

<h3>Queries</h3>
<div id="queryGraph"></div>
<script>
new PromConsole.Graph({
  node: document.querySelector("#queryGraph"),
  expr: "sum(rate(http_query_count{job='myjob'}[5m]))",
  name: "Queries",
  yAxisFormatter: PromConsole.NumberFormatter.humanizeNoSmallPrefix,
  yHoverFormatter: PromConsole.NumberFormatter.humanizeNoSmallPrefix,
  yUnits: "/s",
  yTitle: "Queries"
})
</script>

{{template "prom_content_tail" .}}

{{template "tail"}}
```

The `prom_right_table_head` and `prom_right_table_tail` templates contain the right-hand-side table. This is optional.

`prom_query_drilldown` is a template that will evaluate the expression passed to it, format it, and link to the expression in the [expression browser](https://prometheus.io/docs/visualization/browser/). The first argument is the expression. The second argument is the unit to use. The third argument is how to format the output. Only the first argument is required.

Valid output formats for the third argument to `prom_query_drilldown`:

- Not specified: Default Go display output.
- `humanize`: Display the result using [metric prefixes](https://en.wikipedia.org/wiki/Metric_prefix).
- `humanizeNoSmallPrefix`: For absolute values greater than 1, display the result using [metric prefixes](https://en.wikipedia.org/wiki/Metric_prefix). For absolute values less than 1, display 3 significant digits. This is useful to avoid units such as milliqueries per second that can be produced by `humanize`.
- `humanize1024`: Display the humanized result using a base of 1024 rather than 1000. This is usually used with `B` as the second argument to produce units such as `KiB` and `MiB`.
- `printf.3g`: Display 3 significant digits.

Custom formats can be defined. See [prom.lib](https://github.com/prometheus/prometheus/blob/main/console_libraries/prom.lib) for examples.

## Graph Library

The graph library is invoked as:

```
<div id="queryGraph"></div>
<script>
new PromConsole.Graph({
  node: document.querySelector("#queryGraph"),
  expr: "sum(rate(http_query_count{job='myjob'}[5m]))"
})
</script>
```

The `head` template loads the required Javascript and CSS.

Parameters to the graph library:

| Name            | Description                                                  |
| --------------- | ------------------------------------------------------------ |
| expr            | Required. Expression to graph. Can be a list.                |
| node            | Required. DOM node to render into.                           |
| duration        | Optional. Duration of the graph. Defaults to 1 hour.         |
| endTime         | Optional. Unixtime the graph ends at. Defaults to now.       |
| width           | Optional. Width of the graph, excluding titles. Defaults to auto-detection. |
| height          | Optional. Height of the graph, excluding titles and legends. Defaults to 200 pixels. |
| min             | Optional. Minimum x-axis value. Defaults to lowest data value. |
| max             | Optional. Maximum y-axis value. Defaults to highest data value. |
| renderer        | Optional. Type of graph. Options are `line` and `area` (stacked graph). Defaults to `line`. |
| name            | Optional. Title of plots in legend and hover detail. If passed a string, `[[ label ]]` will be substituted with the label value. If passed a function, it will be passed a map of labels and should return the name as a string. Can  be a list. |
| xTitle          | Optional. Title of the x-axis. Defaults to `Time`.           |
| yUnits          | Optional. Units of the y-axis. Defaults to empty.            |
| yTitle          | Optional. Title of the y-axis. Defaults to empty.            |
| yAxisFormatter  | Optional. Number formatter for the y-axis. Defaults to `PromConsole.NumberFormatter.humanize`. |
| yHoverFormatter | Optional. Number formatter for the hover detail. Defaults to `PromConsole.NumberFormatter.humanizeExact`. |
| colorScheme     | Optional. Color scheme to be used by the plots. Can be either a list of hex color codes or one of the [color scheme names](https://github.com/shutterstock/rickshaw/blob/master/src/js/Rickshaw.Fixtures.Color.js) supported by Rickshaw. Defaults to `'colorwheel'`. |

If both `expr` and `name` are lists, they must be of the same length. The name will be applied to the plots for the corresponding expression.

Valid options for the `yAxisFormatter` and `yHoverFormatter`:

- `PromConsole.NumberFormatter.humanize`: Format using [metric prefixes](https://en.wikipedia.org/wiki/Metric_prefix).
- `PromConsole.NumberFormatter.humanizeNoSmallPrefix`: For absolute values greater than 1, format using using [metric prefixes](https://en.wikipedia.org/wiki/Metric_prefix). For absolute values less than 1, format with 3 significant digits. This is useful to avoid units such as milliqueries per second that can be produced by `PromConsole.NumberFormatter.humanize`.
- `PromConsole.NumberFormatter.humanize1024`: Format the humanized result using a base of 1024 rather than 1000.













## Node Exporter

Prometheus  Server 并不直接服务监控特定的目标，其主要任务负责数据的收集，存储并且对外提供数据查询支持。因此为了能够监控到某些东西，如主机的 CPU 使用率，需要使用到 Exporter 。Prometheus 周期性的从 Exporter 暴露的 HTTP 服务地址（通常是 /metrics ）拉取监控样本数据。

Exporter 可以是一个相对开放的概念，其可以是一个独立运行的程序，独立于监控目标以外，也可以是直接内置在监控目标中。只要能够向 Prometheus 提供标准格式的监控样本数据即可。

为了能够采集到主机的运行指标如 CPU , 内存，磁盘等信息，可以使用 [Node Exporter](https://github.com/prometheus/node_exporter)。

### 初始监控指标

访问 http://localhost:9100/metrics，可以看到当前 node exporter 获取到的当前主机的所有监控数据，如下所示：

 ![](../../Image/n/node_exporter_metrics_page.png)

每一个监控指标之前都会有一段类似于如下形式的信息：

```bash
# HELP node_cpu Seconds the cpus spent in each mode.
# TYPE node_cpu counter
node_cpu{cpu="cpu0",mode="idle"} 362812.7890625
# HELP node_load1 1m load average.
# TYPE node_load1 gauge
node_load1 3.0703125
```

其中 HELP 用于解释当前指标的含义，TYPE 则说明当前指标的数据类型。在上面的例子中 node_cpu 的注释表明当前指标是 cpu0 上 idle 进程占用 CPU 的总时间，CPU 占用时间是一个只增不减的度量指标，从类型中也可以看出 node_cpu 的数据类型是计数器 ( counter ) ，与该指标的实际含义一致。又例如 node_load1 该指标反映了当前主机在最近一分钟以内的负载情况，系统的负载情况会随系统资源的使用而变化，因此 node_load1 反映的是当前状态，数据可能增加也可能减少，从注释中可以看出当前指标类型为仪表盘 ( gauge ) ，与指标反映的实际含义一致。

除了这些以外，在当前页面中根据物理主机系统的不同，还可能看到如下监控指标：

- node_boot_time_seconds      系统启动时间
- node_cpu_*                              系统 CPU 使用量
- node_disk_*                              磁盘
- node_filesystem_*                   文件系统用量
- node_load[1/5/15]                   系统负载
- node_memeory_*                    内存使用量
- node_network_*                      网络带宽
- node_time_*                             系统时间
- go_*                                           node exporter 中 go 相关指标
- process_*                                  node exporter 自身进程相关运行指标

### 从 Node Exporter 收集监控数据

为了能够让 Prometheus Server 能够从当前 node exporter 获取到监控数据，这里需要修改 Prometheus 配置文件。编辑 prometheus.yml 并在 scrape_configs 节点下添加以下内容:

```yaml
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
  # 采集node exporter监控数据
  - job_name: 'node'
    static_configs:
      - targets: ['localhost:9100']
```

重新启动 Prometheus Server

访问http://localhost:9090，进入到 Prometheus Server。如果输入 “up” 并且点击执行按钮以后，可以看到如下结果：

 ![](../../Image/p/prometheus_ui_up_query.png)

如果Prometheus能够正常从node exporter获取数据，则会看到以下结果：

```bash
up{instance="localhost:9090",job="prometheus"}               1
up{instance="localhost:9100",job="node"}                     1
```

其中 “1” 表示正常，反之 “0” 则为异常。

## 使用 Grafana 创建可视化 Dashboard

Prometheus  UI 提供了快速验证 PromQL 以及临时可视化支持的能力，而在大多数场景下引入监控系统通常还需要构建可以长期使用的监控数据可视化面板（Dashboard）。这时用户可以考虑使用第三方的可视化工具如 Grafana。

添加 Prometheus 作为默认的数据源，如下图所示，指定数据源类型为 Prometheus 并且设置 Prometheus 的访问地址即可，在配置正确的情况下点击 “Add” 按钮，会提示连接成功的信息：

 ![添加Prometheus作为数据源](../../Image/a/add_default_prometheus_datasource.png)

在完成数据源的添加之后就可以在 Grafana 中创建可视化 Dashboard 了。Grafana 提供了对 PromQL 的完整支持，如下所示，通过 Grafana 添加 Dashboard 并且为该 Dashboard 添加一个类型为 “Graph” 的面板。 并在该面板的 “Metrics” 选项下通过 PromQL 查询需要可视化的数据：

![第一个可视化面板](../../Image/f/first_grafana_dashboard.png)

点击界面中的保存选项，就创建了第一个可视化 Dashboard了。 当然作为开源软件，Grafana 社区鼓励用户分享 Dashboard 通过https://grafana.com/dashboards网站，可以找到大量可直接使用的 Dashboard：

![用户共享的Dashboard](../../Image/g/grafana_dashboards.png)

Grafana 中所有的 Dashboard 通过 JSON 进行共享，下载并且导入这些 JSON 文件，就可以直接使用这些已经定义好的 Dashboard：

![Host Stats Dashboard](../../Image/n/node_exporter_dashboard.png) 

## 任务和实例

在上一小节中，通过在prometheus.yml配置文件中，添加如下配置。我们让Prometheus可以从node exporter暴露的服务中获取监控指标数据。

```yaml
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'node'
    static_configs:
      - targets: ['localhost:9100']
```

当我们需要采集不同的监控指标(例如：主机、MySQL、Nginx)时，我们只需要运行相应的监控采集程序，并且让Prometheus  Server知道这些Exporter实例的访问地址。在Prometheus中，每一个暴露监控样本数据的HTTP服务称为一个实例。例如在当前主机上运行的node exporter可以被称为一个实例(Instance)。

而一组用于相同采集目的的实例，或者同一个采集进程的多个副本则通过一个一个任务(Job)进行管理。

```
* job: node
    * instance 2: 1.2.3.4:9100
    * instance 4: 5.6.7.8:9100
```

当前在每一个Job中主要使用了静态配置(static_configs)的方式定义监控目标。除了静态配置每一个Job的采集Instance地址以外，Prometheus还支持与DNS、Consul、E2C、Kubernetes等进行集成实现自动发现Instance实例，并从这些Instance上获取监控数据。

除了通过使用“up”表达式查询当前所有Instance的状态以外，还可以通过Prometheus UI中的Targets页面查看当前所有的监控采集任务，以及各个任务下所有实例的状态:

![target列表以及状态](https://www.prometheus.wang/quickstart/static/prometheus_ui_targets.png)target列表以及状态

我们也可以访问http://192.168.33.10:9090/targets直接从Prometheus的UI中查看当前所有的任务以及每个任务对应的实例信息。

![Targets状态](https://www.prometheus.wang/quickstart/static/prometheus_ui_targets_status.png)

## PromQL

Prometheus 的自定义查询语言。通过 PromQL 用户可以非常方便地对监控样本数据进行统计分析，PromQL 支持常见的运算操作符，同时 PromQL 中还提供了大量的内置函数可以实现对数据的高级处理。通过这些丰富的表达书语句，监控指标不再是一个单独存在的个体，而是一个个能够表达出正式业务含义的语言。PromQL 作为 Prometheus 的核心能力除了实现数据的对外查询和展现，同时告警监控也是依赖 PromQL 实现的。

### 查询监控数据

Prometheus UI 是 Prometheus 内置的一个可视化管理界面，通过 Prometheus UI 用户能够轻松的了解 Prometheus 当前的配置，监控任务运行状态等。 通过`Graph` 面板，用户还能直接使用 `PromQL` 实时查询监控数据：

 ![](../../Image/p/prometheus_ui_graph_query.png)

切换到 `Graph` 面板，用户可以使用 PromQL 表达式查询特定监控指标的监控数据。如下所示，查询主机负载变化情况，可以使用关键字 `node_load1` 可以查询出 Prometheus 采集到的主机负载的样本数据，这些样本数据按照时间先后顺序展示，形成了主机负载随时间变化的趋势图表：

 ![](../../Image/n/node_node1_graph.png)

PromQL 是 Prometheus 自定义的一套强大的数据查询语言，除了使用监控指标作为查询关键字以为，还内置了大量的函数，帮助用户进一步对时序数据进行处理。例如使用 `rate()` 函数，可以计算在单位时间内样本数据的变化情况即增长率，因此通过该函数我们可以近似的通过 CPU 使用时间计算 CPU 的利用率：

```bash
rate(node_cpu[2m])
```

 ![系统进程的CPU使用率](../../Image/n/node_cpu_usage_by_cpu_and_mode.png)

这时如果要忽略是哪一个 CPU 的，只需要使用 without 表达式，将标签 CPU 去除后聚合数据即可：

```
avg without(cpu) (rate(node_cpu[2m]))
```

 ![系统各mode的CPU使用率](../../Image/n/node_cpu_usage_by_mode.png)

那如果需要计算系统CPU的总体使用率，通过排除系统闲置的CPU使用率即可获得:

```
1 - avg without(cpu) (rate(node_cpu{mode="idle"}[2m]))
```

 ![系统CPU使用率](../../Image/n/node_cpu_usage_total.png)

### 理解时间序列

通过 Node Exporter 暴露的 HTTP 服务，Prometheus 可以采集到当前主机所有监控指标的样本数据。例如：

```bash
# HELP node_cpu Seconds the cpus spent in each mode.
# TYPE node_cpu counter
node_cpu{cpu="cpu0",mode="idle"} 362812.7890625
# HELP node_load1 1m load average.
# TYPE node_load1 gauge
node_load1 3.0703125
```

其中非 # 开头的每一行表示当前 Node Exporter 采集到的一个监控样本：node_cpu 和 node_load1 表明了当前指标的名称、大括号中的标签则反映了当前样本的一些特征和维度、浮点数则是该监控样本的具体值。

#### 样本

Prometheus 会将所有采集到的样本数据以时间序列（time-series）的方式保存在内存数据库中，并且定时保存到硬盘上。time-series 是按照时间戳和值的序列顺序存放的，我们称之为向量 (vector). 每条 time-series 通过指标名称 (metrics  name) 和一组标签集 (labelset) 命名。如下所示，可以将 time-series 理解为一个以时间为 Y 轴的数字矩阵：

```bash
  ^
  │   . . . . . . . . . . . . . . . . .   . .   node_cpu{cpu="cpu0",mode="idle"}
  │     . . . . . . . . . . . . . . . . . . .   node_cpu{cpu="cpu0",mode="system"}
  │     . . . . . . . . . .   . . . . . . . .   node_load1{}
  │     . . . . . . . . . . . . . . . .   . .  
  v
    <------------------ 时间 ---------------->
```

在time-series中的每一个点称为一个样本（sample），样本由以下三部分组成：

- 指标 (metric)：metric name 和描述当前样本特征的 labelsets ;
- 时间戳 (timestamp)：一个精确到毫秒的时间戳;
- 样本值 (value)： 一个 float64 的浮点型数据表示当前样本的值。

```bash
<--------------- metric ---------------------><-timestamp -><-value->
http_request_total{status="200", method="GET"}@1434417560938 => 94355
http_request_total{status="200", method="GET"}@1434417561287 => 94334

http_request_total{status="404", method="GET"}@1434417560938 => 38473
http_request_total{status="404", method="GET"}@1434417561287 => 38544

http_request_total{status="200", method="POST"}@1434417560938 => 4748
http_request_total{status="200", method="POST"}@1434417561287 => 4785
```

#### 指标(Metric)

在形式上，所有的指标 (Metric) 都通过如下格式标示：

```bash
<metric name>{<label name>=<label value>, ...}
```

指标的名称 (metric name) 可以反映被监控样本的含义（比如，`http_request_total` - 表示当前系统接收到的 HTTP 请求总量）。指标名称只能由 ASCII 字符、数字、下划线以及冒号组成并必须符合正则表达式`[a-zA-Z_:][a-zA-Z0-9_:]*`。

标签 (label) 反映了当前样本的特征维度，通过这些维度 Prometheus 可以对样本数据进行过滤，聚合等。标签的名称只能由 ASCII 字符、数字以及下划线组成并满足正则表达式`[a-zA-Z_][a-zA-Z0-9_]*`。

其中以 `__` 作为前缀的标签，是系统保留的关键字，只能在系统内部使用。标签的值则可以包含任何 Unicode 编码的字符。在 Prometheus 的底层实现中指标名称实际上是以 `__name__=<metric name>` 的形式保存在数据库中的，因此以下两种方式均表示的同一条 time-series：

```bash
api_http_requests_total{method="POST", handler="/messages"}
```

等同于：

```bash
{__name__="api_http_requests_total"，method="POST", handler="/messages"}
```

在 Prometheus 源码中也可以指标 (Metric) 对应的数据结构，如下所示：

```go
type Metric LabelSet

type LabelSet map[LabelName]LabelValue

type LabelName string

type LabelValue string
```

### Metric类型

在 Prometheus 的存储实现上所有的监控样本都是以 time-series 的形式保存在 Prometheus 内存的 TSDB（时序数据库）中，而 time-series 所对应的监控指标(metric) 也是通过 labelset 进行唯一命名的。

从存储上来讲所有的监控指标 metric 都是相同的，但是在不同的场景下这些 metric 又有一些细微的差异。 例如，在 Node  Exporter 返回的样本中指标node_load1 反应的是当前系统的负载状态，随着时间的变化这个指标返回的样本数据是在不断变化的。而指标 node_cpu 所获取到的样本数据却不同，它是一个持续增大的值，因为其反应的是 CPU 的累积使用时间，从理论上讲只要系统不关机，这个值是会无限变大的。

为了能够帮助用户理解和区分这些不同监控指标之间的差异，Prometheus 定义了4中不同的指标类型 (metric type)：

* Counter（计数器）
* Gauge（仪表盘）
* Histogram（直方图）
* Summary（摘要）

在 Exporter 返回的样本数据中，其注释中也包含了该样本的类型。例如：

```bash
# HELP node_cpu Seconds the cpus spent in each mode.
# TYPE node_cpu counter
node_cpu{cpu="cpu0",mode="idle"} 362812.7890625
```

#### Counter：只增不减的计数器

Counter类型的指标其工作方式和计数器一样，只增不减（除非系统发生重置）。常见的监控指标，如http_requests_total，node_cpu都是Counter类型的监控指标。 一般在定义Counter类型指标的名称时推荐使用_total作为后缀。

Counter是一个简单但有强大的工具，例如我们可以在应用程序中记录某些事件发生的次数，通过以时序的形式存储这些数据，我们可以轻松的了解该事件产生速率的变化。 PromQL内置的聚合操作和函数可以让用户对这些数据进行进一步的分析：

例如，通过rate()函数获取HTTP请求量的增长率：

```
rate(http_requests_total[5m])
```

查询当前系统中，访问量前10的HTTP地址：

```
topk(10, http_requests_total)
```

#### Gauge：可增可减的仪表盘

与Counter不同，Gauge类型的指标侧重于反应系统的当前状态。因此这类指标的样本数据可增可减。常见指标如：node_memory_MemFree（主机当前空闲的内容大小）、node_memory_MemAvailable（可用内存大小）都是Gauge类型的监控指标。

通过Gauge指标，用户可以直接查看系统的当前状态：

```
node_memory_MemFree
```

对于Gauge类型的监控指标，通过PromQL内置函数delta()可以获取样本在一段时间返回内的变化情况。例如，计算CPU温度在两个小时内的差异：

```
delta(cpu_temp_celsius{host="zeus"}[2h])
```

还可以使用deriv()计算样本的线性回归模型，甚至是直接使用predict_linear()对数据的变化趋势进行预测。例如，预测系统磁盘空间在4个小时之后的剩余情况：

```
predict_linear(node_filesystem_free{job="node"}[1h], 4 * 3600)
```

#### 使用Histogram和Summary分析数据分布情况

除了Counter和Gauge类型的监控指标以外，Prometheus还定义了Histogram和Summary的指标类型。Histogram和Summary主用用于统计和分析样本的分布情况。

在大多数情况下人们都倾向于使用某些量化指标的平均值，例如CPU的平均使用率、页面的平均响应时间。这种方式的问题很明显，以系统API调用的平均响应时间为例：如果大多数API请求都维持在100ms的响应时间范围内，而个别请求的响应时间需要5s，那么就会导致某些WEB页面的响应时间落到中位数的情况，而这种现象被称为长尾问题。

为了区分是平均的慢还是长尾的慢，最简单的方式就是按照请求延迟的范围进行分组。例如，统计延迟在0~10ms之间的请求数有多少而10~20ms之间的请求数又有多少。通过这种方式可以快速分析系统慢的原因。Histogram和Summary都是为了能够解决这样问题的存在，通过Histogram和Summary类型的监控指标，我们可以快速了解监控样本的分布情况。 

例如，指标prometheus_tsdb_wal_fsync_duration_seconds的指标类型为Summary。  它记录了Prometheus Server中wal_fsync处理的处理时间，通过访问Prometheus  Server的/metrics地址，可以获取到以下监控样本数据：

```
# HELP prometheus_tsdb_wal_fsync_duration_seconds Duration of WAL fsync.
# TYPE prometheus_tsdb_wal_fsync_duration_seconds summary
prometheus_tsdb_wal_fsync_duration_seconds{quantile="0.5"} 0.012352463
prometheus_tsdb_wal_fsync_duration_seconds{quantile="0.9"} 0.014458005
prometheus_tsdb_wal_fsync_duration_seconds{quantile="0.99"} 0.017316173
prometheus_tsdb_wal_fsync_duration_seconds_sum 2.888716127000002
prometheus_tsdb_wal_fsync_duration_seconds_count 216
```

从上面的样本中可以得知当前Prometheus  Server进行wal_fsync操作的总次数为216次，耗时2.888716127000002s。其中中位数（quantile=0.5）的耗时为0.012352463，9分位数（quantile=0.9）的耗时为0.014458005s。

在Prometheus Server自身返回的样本数据中，我们还能找到类型为Histogram的监控指标prometheus_tsdb_compaction_chunk_range_bucket。

```
# HELP prometheus_tsdb_compaction_chunk_range Final time range of chunks on their first compaction
# TYPE prometheus_tsdb_compaction_chunk_range histogram
prometheus_tsdb_compaction_chunk_range_bucket{le="100"} 0
prometheus_tsdb_compaction_chunk_range_bucket{le="400"} 0
prometheus_tsdb_compaction_chunk_range_bucket{le="1600"} 0
prometheus_tsdb_compaction_chunk_range_bucket{le="6400"} 0
prometheus_tsdb_compaction_chunk_range_bucket{le="25600"} 0
prometheus_tsdb_compaction_chunk_range_bucket{le="102400"} 0
prometheus_tsdb_compaction_chunk_range_bucket{le="409600"} 0
prometheus_tsdb_compaction_chunk_range_bucket{le="1.6384e+06"} 260
prometheus_tsdb_compaction_chunk_range_bucket{le="6.5536e+06"} 780
prometheus_tsdb_compaction_chunk_range_bucket{le="2.62144e+07"} 780
prometheus_tsdb_compaction_chunk_range_bucket{le="+Inf"} 780
prometheus_tsdb_compaction_chunk_range_sum 1.1540798e+09
prometheus_tsdb_compaction_chunk_range_count 780
```

与Summary类型的指标相似之处在于Histogram类型的样本同样会反应当前指标的记录的总数(以_count作为后缀)以及其值的总量（以_sum作为后缀）。不同在于Histogram指标直接反应了在不同区间内样本的个数，区间通过标签len进行定义。

同时对于Histogram的指标，我们还可以通过histogram_quantile()函数计算出其值的分位数。不同在于Histogram通过histogram_quantile函数是在服务器端计算的分位数。  而Sumamry的分位数则是直接在客户端计算完成。因此对于分位数的计算而言，Summary在通过PromQL进行查询时有更好的性能表现，而Histogram则会消耗更多的资源。反之对于客户端而言Histogram消耗的资源更少。在选择这两种方式时用户应该按照自己的实际场景进行选择。 

# 初识PromQL

Prometheus通过指标名称（metrics  name）以及对应的一组标签（labelset）唯一定义一条时间序列。指标名称反映了监控样本的基本标识，而label则在这个基本特征上为采集到的数据提供了多种特征维度。用户可以基于这些特征维度过滤，聚合，统计从而产生新的计算后的一条时间序列。

PromQL是Prometheus内置的数据查询语言，其提供对时间序列数据丰富的查询，聚合以及逻辑运算能力的支持。并且被广泛应用在Prometheus的日常应用当中，包括对数据查询、可视化、告警处理当中。可以这么说，PromQL是Prometheus所有应用场景的基础，理解和掌握PromQL是Prometheus入门的第一课。

## 查询时间序列

当Prometheus通过Exporter采集到相应的监控指标样本数据后，我们就可以通过PromQL对监控样本数据进行查询。

当我们直接使用监控指标名称查询时，可以查询该指标下的所有时间序列。如：

```
http_requests_total
```

等同于：

```
http_requests_total{}
```

该表达式会返回指标名称为http_requests_total的所有时间序列：

```
http_requests_total{code="200",handler="alerts",instance="localhost:9090",job="prometheus",method="get"}=(20889@1518096812.326)
http_requests_total{code="200",handler="graph",instance="localhost:9090",job="prometheus",method="get"}=(21287@1518096812.326)
```

PromQL还支持用户根据时间序列的标签匹配模式来对时间序列进行过滤，目前主要支持两种匹配模式：完全匹配和正则匹配。

PromQL支持使用`=`和`!=`两种完全匹配模式：

- 通过使用`label=value`可以选择那些标签满足表达式定义的时间序列；
- 反之使用`label!=value`则可以根据标签匹配排除时间序列；

例如，如果我们只需要查询所有http_requests_total时间序列中满足标签instance为localhost:9090的时间序列，则可以使用如下表达式：

```
http_requests_total{instance="localhost:9090"}
```

反之使用`instance!="localhost:9090"`则可以排除这些时间序列：

```
http_requests_total{instance!="localhost:9090"}
```

除了使用完全匹配的方式对时间序列进行过滤以外，PromQL还可以支持使用正则表达式作为匹配条件，多个表达式之间使用`|`进行分离：

- 使用`label=~regx`表示选择那些标签符合正则表达式定义的时间序列；
- 反之使用`label!~regx`进行排除；

例如，如果想查询多个环节下的时间序列序列可以使用如下表达式：

```
http_requests_total{environment=~"staging|testing|development",method!="GET"}
```

## 范围查询

直接通过类似于PromQL表达式http*requests\*total查询时间序列时，返回值中只会包含该时间序列中的最新的一个样本值，这样的返回结果我们称之为**瞬时向量**。而相应的这样的表达式称之为__瞬时向量表达式**。

而如果我们想过去一段时间范围内的样本数据时，我们则需要使用**区间向量表达式**。区间向量表达式和瞬时向量表达式之间的差异在于在区间向量表达式中我们需要定义时间选择的范围，时间范围通过时间范围选择器`[]`进行定义。例如，通过以下表达式可以选择最近5分钟内的所有样本数据：

```
http_request_total{}[5m]
```

该表达式将会返回查询到的时间序列中最近5分钟的所有样本数据：

```
http_requests_total{code="200",handler="alerts",instance="localhost:9090",job="prometheus",method="get"}=[
    1@1518096812.326
    1@1518096817.326
    1@1518096822.326
    1@1518096827.326
    1@1518096832.326
    1@1518096837.325
]
http_requests_total{code="200",handler="graph",instance="localhost:9090",job="prometheus",method="get"}=[
    4 @1518096812.326
    4@1518096817.326
    4@1518096822.326
    4@1518096827.326
    4@1518096832.326
    4@1518096837.325
]
```

通过区间向量表达式查询到的结果我们称为**区间向量**。

除了使用m表示分钟以外，PromQL的时间范围选择器支持其它时间单位：

- s - 秒
- m - 分钟
- h - 小时
- d - 天
- w - 周
- y - 年

## 时间位移操作

在瞬时向量表达式或者区间向量表达式中，都是以当前时间为基准：

```
http_request_total{} # 瞬时向量表达式，选择当前最新的数据
http_request_total{}[5m] # 区间向量表达式，选择以当前时间为基准，5分钟内的数据
```

而如果我们想查询，5分钟前的瞬时样本数据，或昨天一天的区间内的样本数据呢? 这个时候我们就可以使用位移操作，位移操作的关键字为**offset**。

可以使用offset时间位移操作：

```
http_request_total{} offset 5m
http_request_total{}[1d] offset 1d
```

## 使用聚合操作

一般来说，如果描述样本特征的标签(label)在并非唯一的情况下，通过PromQL查询数据，会返回多条满足这些特征维度的时间序列。而PromQL提供的聚合操作可以用来对这些时间序列进行处理，形成一条新的时间序列：

```
# 查询系统所有http请求的总量
sum(http_request_total)

# 按照mode计算主机CPU的平均使用时间
avg(node_cpu) by (mode)

# 按照主机查询各个主机的CPU使用率
sum(sum(irate(node_cpu{mode!='idle'}[5m]))  / sum(irate(node_cpu[5m]))) by (instance)
```

## 标量和字符串

除了使用瞬时向量表达式和区间向量表达式以外，PromQL还直接支持用户使用标量(Scalar)和字符串(String)。

### 标量（Scalar）：一个浮点型的数字值

标量只有一个数字，没有时序。

例如：

```
10
```

> 需要注意的是，当使用表达式count(http_requests_total)，返回的数据类型，依然是瞬时向量。用户可以通过内置函数scalar()将单个瞬时向量转换为标量。

### 字符串（String）：一个简单的字符串值

直接使用字符串，作为PromQL表达式，则会直接返回字符串。

```
"this is a string"
'these are unescaped: \n \\ \t'
`these are not unescaped: \n ' " \t`
```

## 合法的PromQL表达式

所有的PromQL表达式都必须至少包含一个指标名称(例如http_request_total)，或者一个不会匹配到空字符串的标签过滤器(例如{code="200"})。

因此以下两种方式，均为合法的表达式：

```
http_request_total # 合法
http_request_total{} # 合法
{method="get"} # 合法
```

而如下表达式，则不合法：

```
{job=~".*"} # 不合法
```

同时，除了使用`<metric name>{label=value}`的形式以外，我们还可以使用内置的`__name__`标签来指定监控指标名称：

```
{__name__=~"http_request_total"} # 合法
{__name__=~"node_disk_bytes_read|node_disk_bytes_written"} # 合法
```

# PromQL操作符

使用PromQL除了能够方便的按照查询和过滤时间序列以外，PromQL还支持丰富的操作符，用户可以使用这些操作符对进一步的对事件序列进行二次加工。这些操作符包括：数学运算符，逻辑运算符，布尔运算符等等。

## 数学运算

例如，我们可以通过指标node_memory_free_bytes_total获取当前主机可用的内存空间大小，其样本单位为Bytes。这是如果客户端要求使用MB作为单位响应数据，那只需要将查询到的时间序列的样本值进行单位换算即可：

```
node_memory_free_bytes_total / (1024 * 1024)
```

node_memory_free_bytes_total表达式会查询出所有满足表达式条件的时间序列，在上一小节中我们称该表达式为瞬时向量表达式，而返回的结果成为瞬时向量。

当瞬时向量与标量之间进行数学运算时，数学运算符会依次作用域瞬时向量中的每一个样本值，从而得到一组新的时间序列。

而如果是瞬时向量与瞬时向量之间进行数学运算时，过程会相对复杂一点。 例如，如果我们想根据node_disk_bytes_written和node_disk_bytes_read获取主机磁盘IO的总量，可以使用如下表达式：

```
node_disk_bytes_written + node_disk_bytes_read
```

那这个表达式是如何工作的呢？依次找到与左边向量元素匹配（标签完全一致）的右边向量元素进行运算，如果没找到匹配元素，则直接丢弃。同时新的时间序列将不会包含指标名称。 该表达式返回结果的示例如下所示：

```
{device="sda",instance="localhost:9100",job="node_exporter"}=>1634967552@1518146427.807 + 864551424@1518146427.807
{device="sdb",instance="localhost:9100",job="node_exporter"}=>0@1518146427.807 + 1744384@1518146427.807
```

PromQL支持的所有数学运算符如下所示：

- `+` (加法)
- `-` (减法)
- `*` (乘法)
- `/` (除法)
- `%` (求余)
- `^` (幂运算)

## 使用布尔运算过滤时间序列

在PromQL通过标签匹配模式，用户可以根据时间序列的特征维度对其进行查询。而布尔运算则支持用户根据时间序列中样本的值，对时间序列进行过滤。

例如，通过数学运算符我们可以很方便的计算出，当前所有主机节点的内存使用率：

```
(node_memory_bytes_total - node_memory_free_bytes_total) / node_memory_bytes_total
```

而系统管理员在排查问题的时候可能只想知道当前内存使用率超过95%的主机呢？通过使用布尔运算符可以方便的获取到该结果：

```
(node_memory_bytes_total - node_memory_free_bytes_total) / node_memory_bytes_total > 0.95
```

瞬时向量与标量进行布尔运算时，PromQL依次比较向量中的所有时间序列样本的值，如果比较结果为true则保留，反之丢弃。

瞬时向量与瞬时向量直接进行布尔运算时，同样遵循默认的匹配模式：依次找到与左边向量元素匹配（标签完全一致）的右边向量元素进行相应的操作，如果没找到匹配元素，则直接丢弃。

目前，Prometheus支持以下布尔运算符如下：

- `==` (相等)
- `!=` (不相等)
- `>` (大于)
- `<` (小于)
- `>=` (大于等于)
- `<=` (小于等于)

## 使用bool修饰符改变布尔运算符的行为

布尔运算符的默认行为是对时序数据进行过滤。而在其它的情况下我们可能需要的是真正的布尔结果。例如，只需要知道当前模块的HTTP请求量是否>=1000，如果大于等于1000则返回1（true）否则返回0（false）。这时可以使用bool修饰符改变布尔运算的默认行为。 例如：

```
http_requests_total > bool 1000
```

使用bool修改符后，布尔运算不会对时间序列进行过滤，而是直接依次瞬时向量中的各个样本数据与标量的比较结果0或者1。从而形成一条新的时间序列。

```
http_requests_total{code="200",handler="query",instance="localhost:9090",job="prometheus",method="get"}  1
http_requests_total{code="200",handler="query_range",instance="localhost:9090",job="prometheus",method="get"}  0
```

同时需要注意的是，如果是在两个标量之间使用布尔运算，则必须使用bool修饰符

```
2 == bool 2 # 结果为1
```

## 使用集合运算符

使用瞬时向量表达式能够获取到一个包含多个时间序列的集合，我们称为瞬时向量。 通过集合运算，可以在两个瞬时向量与瞬时向量之间进行相应的集合操作。目前，Prometheus支持以下集合运算符：

- `and` (并且)
- `or` (或者)
- `unless` (排除)

***vector1 and vector2\*** 会产生一个由vector1的元素组成的新的向量。该向量包含vector1中完全匹配vector2中的元素组成。

***vector1 or vector2\*** 会产生一个新的向量，该向量包含vector1中所有的样本数据，以及vector2中没有与vector1匹配到的样本数据。

***vector1 unless vector2\*** 会产生一个新的向量，新向量中的元素由vector1中没有与vector2匹配的元素组成。

## 操作符优先级

对于复杂类型的表达式，需要了解运算操作的运行优先级

例如，查询主机的CPU使用率，可以使用表达式：

```
100 * (1 - avg (irate(node_cpu{mode='idle'}[5m])) by(job) )
```

其中irate是PromQL中的内置函数，用于计算区间向量中时间序列每秒的即时增长率。关于内置函数的部分，会在下一节详细介绍。

在PromQL操作符中优先级由高到低依次为：

1. `^`
2. `*, /, %`
3. `+, -`
4. `==, !=, <=, <, >=, >`
5. `and, unless`
6. `or`

## 匹配模式详解

向量与向量之间进行运算操作时会基于默认的匹配规则：依次找到与左边向量元素匹配（标签完全一致）的右边向量元素进行运算，如果没找到匹配元素，则直接丢弃。

接下来将介绍在PromQL中有两种典型的匹配模式：一对一（one-to-one）,多对一（many-to-one）或一对多（one-to-many）。

### 一对一匹配

一对一匹配模式会从操作符两边表达式获取的瞬时向量依次比较并找到唯一匹配(标签完全一致)的样本值。默认情况下，使用表达式：

```
vector1 <operator> vector2
```

在操作符两边表达式标签不一致的情况下，可以使用on(label list)或者ignoring(label list）来修改便签的匹配行为。使用ignoreing可以在匹配时忽略某些便签。而on则用于将匹配行为限定在某些便签之内。

```
<vector expr> <bin-op> ignoring(<label list>) <vector expr>
<vector expr> <bin-op> on(<label list>) <vector expr>
```

例如当存在样本：

```
method_code:http_errors:rate5m{method="get", code="500"}  24
method_code:http_errors:rate5m{method="get", code="404"}  30
method_code:http_errors:rate5m{method="put", code="501"}  3
method_code:http_errors:rate5m{method="post", code="500"} 6
method_code:http_errors:rate5m{method="post", code="404"} 21

method:http_requests:rate5m{method="get"}  600
method:http_requests:rate5m{method="del"}  34
method:http_requests:rate5m{method="post"} 120
```

使用PromQL表达式：

```
method_code:http_errors:rate5m{code="500"} / ignoring(code) method:http_requests:rate5m
```

该表达式会返回在过去5分钟内，HTTP请求状态码为500的在所有请求中的比例。如果没有使用ignoring(code)，操作符两边表达式返回的瞬时向量中将找不到任何一个标签完全相同的匹配项。

因此结果如下：

```
{method="get"}  0.04            //  24 / 600
{method="post"} 0.05            //   6 / 120
```

同时由于method为put和del的样本找不到匹配项，因此不会出现在结果当中。

### 多对一和一对多

多对一和一对多两种匹配模式指的是“一”侧的每一个向量元素可以与"多"侧的多个元素匹配的情况。在这种情况下，必须使用group修饰符：group_left或者group_right来确定哪一个向量具有更高的基数（充当“多”的角色）。

```
<vector expr> <bin-op> ignoring(<label list>) group_left(<label list>) <vector expr>
<vector expr> <bin-op> ignoring(<label list>) group_right(<label list>) <vector expr>
<vector expr> <bin-op> on(<label list>) group_left(<label list>) <vector expr>
<vector expr> <bin-op> on(<label list>) group_right(<label list>) <vector expr>
```

多对一和一对多两种模式一定是出现在操作符两侧表达式返回的向量标签不一致的情况。因此需要使用ignoring和on修饰符来排除或者限定匹配的标签列表。

例如,使用表达式：

```
method_code:http_errors:rate5m / ignoring(code) group_left method:http_requests:rate5m
```

该表达式中，左向量`method_code:http_errors:rate5m`包含两个标签method和code。而右向量`method:http_requests:rate5m`中只包含一个标签method，因此匹配时需要使用ignoring限定匹配的标签为code。 在限定匹配标签后，右向量中的元素可能匹配到多个左向量中的元素 因此该表达式的匹配模式为多对一，需要使用group修饰符group_left指定左向量具有更好的基数。

最终的运算结果如下：

```
{method="get", code="500"}  0.04            //  24 / 600
{method="get", code="404"}  0.05            //  30 / 600
{method="post", code="500"} 0.05            //   6 / 120
{method="post", code="404"} 0.175           //  21 / 120
```

> 提醒：group修饰符只能在比较和数学运算符中使用。在逻辑运算and,unless和or才注意操作中默认与右向量中的所有元素进行匹配。

# PromQL聚合操作

Prometheus还提供了下列内置的聚合操作符，这些操作符作用域瞬时向量。可以将瞬时表达式返回的样本数据进行聚合，形成一个新的时间序列。

- `sum` (求和)
- `min` (最小值)
- `max` (最大值)
- `avg` (平均值)
- `stddev` (标准差)
- `stdvar` (标准差异)
- `count` (计数)
- `count_values` (对value进行计数)
- `bottomk` (后n条时序)
- `topk` (前n条时序)
- `quantile` (分布统计)

使用聚合操作的语法如下：

```
<aggr-op>([parameter,] <vector expression>) [without|by (<label list>)]
```

其中只有`count_values`, `quantile`, `topk`, `bottomk`支持参数(parameter)。

without用于从计算结果中移除列举的标签，而保留其它标签。by则正好相反，结果向量中只保留列出的标签，其余标签则移除。通过without和by可以按照样本的问题对数据进行聚合。

例如：

```
sum(http_requests_total) without (instance)
```

等价于

```
sum(http_requests_total) by (code,handler,job,method)
```

如果只需要计算整个应用的HTTP请求总量，可以直接使用表达式：

```
sum(http_requests_total)
```

count_values用于时间序列中每一个样本值出现的次数。count_values会为每一个唯一的样本值输出一个时间序列，并且每一个时间序列包含一个额外的标签。

例如：

```
count_values("count", http_requests_total)
```

topk和bottomk则用于对样本值进行排序，返回当前样本值前n位，或者后n位的时间序列。

获取HTTP请求数前5位的时序样本数据，可以使用表达式：

```
topk(5, http_requests_total)
```

quantile用于计算当前样本数据值的分布情况quantile(φ, express)其中0 ≤ φ ≤ 1。

例如，当φ为0.5时，即表示找到当前样本数据中的中位数：

```
quantile(0.5, http_requests_total)
```

# PromQL内置函数

在上一小节中，我们已经看到了类似于irate()这样的函数，可以帮助我们计算监控指标的增长率。除了irate以外，Prometheus还提供了其它大量的内置函数，可以对时序数据进行丰富的处理。本小节将带来读者了解一些常用的内置函数以及相关的使用场景和用法。

## 计算Counter指标增长率

我们知道Counter类型的监控指标其特点是只增不减，在没有发生重置（如服务器重启，应用重启）的情况下其样本值应该是不断增大的。为了能够更直观的表示样本数据的变化剧烈情况，需要计算样本的增长速率。

如下图所示，样本增长率反映出了样本变化的剧烈程度：

![通过增长率表示样本的变化情况](https://www.prometheus.wang/promql/static/counter-to-rate.png)通过增长率表示样本的变化情况

increase(v range-vector)函数是PromQL中提供的众多内置函数之一。其中参数v是一个区间向量，increase函数获取区间向量中的第一个后最后一个样本并返回其增长量。因此，可以通过以下表达式Counter类型指标的增长率：

```
increase(node_cpu[2m]) / 120
```

这里通过node_cpu[2m]获取时间序列最近两分钟的所有样本，increase计算出最近两分钟的增长量，最后除以时间120秒得到node_cpu样本在最近两分钟的平均增长率。并且这个值也近似于主机节点最近两分钟内的平均CPU使用率。

除了使用increase函数以外，PromQL中还直接内置了rate(v range-vector)函数，rate函数可以直接计算区间向量v在时间窗口内平均增长速率。因此，通过以下表达式可以得到与increase函数相同的结果：

```
rate(node_cpu[2m])
```

需要注意的是使用rate或者increase函数去计算样本的平均增长速率，容易陷入“长尾问题”当中，其无法反应在时间窗口内样本数据的突发变化。  例如，对于主机而言在2分钟的时间窗口内，可能在某一个由于访问量或者其它问题导致CPU占用100%的情况，但是通过计算在时间窗口内的平均增长率却无法反应出该问题。

为了解决该问题，PromQL提供了另外一个灵敏度更高的函数irate(v  range-vector)。irate同样用于计算区间向量的计算率，但是其反应出的是瞬时增长率。irate函数是通过区间向量中最后两个两本数据来计算区间向量的增长速率。这种方式可以避免在时间窗口范围内的“长尾问题”，并且体现出更好的灵敏度，通过irate函数绘制的图标能够更好的反应样本数据的瞬时变化状态。

```
irate(node_cpu[2m])
```

irate函数相比于rate函数提供了更高的灵敏度，不过当需要分析长期趋势或者在告警规则中，irate的这种灵敏度反而容易造成干扰。因此在长期趋势分析或者告警中更推荐使用rate函数。

## 预测Gauge指标变化趋势

在一般情况下，系统管理员为了确保业务的持续可用运行，会针对服务器的资源设置相应的告警阈值。例如，当磁盘空间只剩512MB时向相关人员发送告警通知。 这种基于阈值的告警模式对于当资源用量是平滑增长的情况下是能够有效的工作的。 但是如果资源不是平滑变化的呢？  比如有些某些业务增长，存储空间的增长速率提升了高几倍。这时，如果基于原有阈值去触发告警，当系统管理员接收到告警以后可能还没来得及去处理问题，系统就已经不可用了。 因此阈值通常来说不是固定的，需要定期进行调整才能保证该告警阈值能够发挥去作用。 那么还有没有更好的方法吗？

PromQL中内置的predict_linear(v range-vector, t scalar)  函数可以帮助系统管理员更好的处理此类情况，predict_linear函数可以预测时间序列v在t秒后的值。它基于简单线性回归的方式，对时间窗口内的样本数据进行统计，从而可以对时间序列的变化趋势做出预测。例如，基于2小时的样本数据，来预测主机可用磁盘空间的是否在4个小时候被占满，可以使用如下表达式：

```
predict_linear(node_filesystem_free{job="node"}[2h], 4 * 3600) < 0
```

## 统计Histogram指标的分位数

在本章的第2小节中，我们介绍了Prometheus的四种监控指标类型，其中Histogram和Summary都可以同于统计和分析数据的分布情况。区别在于Summary是直接在客户端计算了数据分布的分位数情况。而Histogram的分位数计算需要通过histogram_quantile(φ float, b  instant-vector)函数进行计算。其中φ（0<φ<1）表示需要计算的分位数，如果需要计算中位数φ取值为0.5，以此类推即可。

以指标http_request_duration_seconds_bucket为例：

```
# HELP http_request_duration_seconds request duration histogram
# TYPE http_request_duration_seconds histogram
http_request_duration_seconds_bucket{le="0.5"} 0
http_request_duration_seconds_bucket{le="1"} 1
http_request_duration_seconds_bucket{le="2"} 2
http_request_duration_seconds_bucket{le="3"} 3
http_request_duration_seconds_bucket{le="5"} 3
http_request_duration_seconds_bucket{le="+Inf"} 3
http_request_duration_seconds_sum 6
http_request_duration_seconds_count 3
```

当计算9分位数时，使用如下表达式：

```
histogram_quantile(0.5, http_request_duration_seconds_bucket)
```

通过对Histogram类型的监控指标，用户可以轻松获取样本数据的分布情况。同时分位数的计算，也可以非常方便的用于评判当前监控指标的服务水平。

![获取分布直方图的中位数](https://www.prometheus.wang/promql/static/histogram_quantile.png)获取分布直方图的中位数

需要注意的是通过histogram_quantile计算的分位数，并非为精确值，而是通过http_request_duration_seconds_bucket和http_request_duration_seconds_sum近似计算的结果。

## 动态标签替换

一般来说来说，使用PromQL查询到时间序列后，可视化工具会根据时间序列的标签来渲染图表。例如通过up指标可以获取到当前所有运行的Exporter实例以及其状态：

```
up{instance="localhost:8080",job="cadvisor"}    1
up{instance="localhost:9090",job="prometheus"}    1
up{instance="localhost:9100",job="node"}    1
```

这是可视化工具渲染图标时可能根据，instance和job的值进行渲染，为了能够让客户端的图标更具有可读性，可以通过label_replace标签为时间序列添加额外的标签。label_replace的具体参数如下：

```
label_replace(v instant-vector, dst_label string, replacement string, src_label string, regex string)
```

该函数会依次对v中的每一条时间序列进行处理，通过regex匹配src_label的值，并将匹配部分relacement写入到dst_label标签中。如下所示：

```
label_replace(up, "host", "$1", "instance",  "(.*):.*")
```

函数处理后，时间序列将包含一个host标签，host标签的值为Exporter实例的IP地址：

```
up{host="localhost",instance="localhost:8080",job="cadvisor"}    1
up{host="localhost",instance="localhost:9090",job="prometheus"}    1
up{host="localhost",instance="localhost:9100",job="node"} 1
```

除了label_replace以外，Prometheus还提供了label_join函数，该函数可以将时间序列中v多个标签src_label的值，通过separator作为连接符写入到一个新的标签dst_label中:

```
label_join(v instant-vector, dst_label string, separator string, src_label_1 string, src_label_2 string, ...)
```

label_replace和label_join函数提供了对时间序列标签的自定义能力，从而能够更好的于客户端或者可视化工具配合。

## 其它内置函数

除了上文介绍的这些内置函数以外，PromQL还提供了大量的其它内置函数。这些内置函数包括一些常用的数学计算、日期等等。这里就不一一细讲，感兴趣的读者可以通过阅读Prometheus的官方文档，了解这些函数的使用方式。

# 在HTTP API中使用PromQL

Prometheus当前稳定的HTTP API可以通过/api/v1访问。

## API响应格式

Prometheus API使用了JSON格式的响应内容。 当API调用成功后将会返回2xx的HTTP状态码。

反之，当API调用失败时可能返回以下几种不同的HTTP状态码：

- 404 Bad Request：当参数错误或者缺失时。
- 422 Unprocessable Entity 当表达式无法执行时。
- 503 Service Unavailiable 当请求超时或者被中断时。

所有的API请求均使用以下的JSON格式：

```
{
  "status": "success" | "error",
  "data": <data>,

  // Only set if status is "error". The data field may still hold
  // additional data.
  "errorType": "<string>",
  "error": "<string>"
}
```

## 在HTTP API中使用PromQL

通过HTTP API我们可以分别通过/api/v1/query和/api/v1/query_range查询PromQL表达式当前或者一定时间范围内的计算结果。

### 瞬时数据查询

通过使用QUERY API我们可以查询PromQL在特定时间点下的计算结果。

```
GET /api/v1/query
```

URL请求参数：

- query=：PromQL表达式。
- time=：用于指定用于计算PromQL的时间戳。可选参数，默认情况下使用当前系统时间。
- timeout=：超时设置。可选参数，默认情况下使用-query,timeout的全局设置。

例如使用以下表达式查询表达式up在时间点2015-07-01T20:10:51.781Z的计算结果：

```
$ curl 'http://localhost:9090/api/v1/query?query=up&time=2015-07-01T20:10:51.781Z'
{
   "status" : "success",
   "data" : {
      "resultType" : "vector",
      "result" : [
         {
            "metric" : {
               "__name__" : "up",
               "job" : "prometheus",
               "instance" : "localhost:9090"
            },
            "value": [ 1435781451.781, "1" ]
         },
         {
            "metric" : {
               "__name__" : "up",
               "job" : "node",
               "instance" : "localhost:9100"
            },
            "value" : [ 1435781451.781, "0" ]
         }
      ]
   }
}
```

### 响应数据类型

当API调用成功后，Prometheus会返回JSON格式的响应内容，格式如上小节所示。并且在data节点中返回查询结果。data节点格式如下：

```
{
  "resultType": "matrix" | "vector" | "scalar" | "string",
  "result": <value>
}
```

PromQL表达式可能返回多种数据类型，在响应内容中使用resultType表示当前返回的数据类型，包括：

- 瞬时向量：vector

当返回数据类型resultType为vector时，result响应格式如下：

```
[
  {
    "metric": { "<label_name>": "<label_value>", ... },
    "value": [ <unix_time>, "<sample_value>" ]
  },
  ...
]
```

其中metrics表示当前时间序列的特征维度，value只包含一个唯一的样本。

- 区间向量：matrix

当返回数据类型resultType为matrix时，result响应格式如下：

```
[
  {
    "metric": { "<label_name>": "<label_value>", ... },
    "values": [ [ <unix_time>, "<sample_value>" ], ... ]
  },
  ...
]
```

其中metrics表示当前时间序列的特征维度，values包含当前事件序列的一组样本。

- 标量：scalar

当返回数据类型resultType为scalar时，result响应格式如下：

```
[ <unix_time>, "<scalar_value>" ]
```

由于标量不存在时间序列一说，因此result表示为当前系统时间一个标量的值。

- 字符串：string

当返回数据类型resultType为string时，result响应格式如下：

```
[ <unix_time>, "<string_value>" ]
```

字符串类型的响应内容格式和标量相同。

### 区间数据查询

使用QUERY_RANGE API我们则可以直接查询PromQL表达式在一段时间返回内的计算结果。

```
GET /api/v1/query_range
```

URL请求参数：

- query=: PromQL表达式。
- start=: 起始时间。
- end=: 结束时间。
- step=: 查询步长。
- timeout=: 超时设置。可选参数，默认情况下使用-query,timeout的全局设置。

当使用QUERY_RANGE API查询PromQL表达式时，返回结果一定是一个区间向量：

```
{
  "resultType": "matrix",
  "result": <value>
}
```

> 需要注意的是，在QUERY_RANGE API中PromQL只能使用瞬时向量选择器类型的表达式。

例如使用以下表达式查询表达式up在30秒范围内以15秒为间隔计算PromQL表达式的结果。

```
$ curl 'http://localhost:9090/api/v1/query_range?query=up&start=2015-07-01T20:10:30.781Z&end=2015-07-01T20:11:00.781Z&step=15s'
{
   "status" : "success",
   "data" : {
      "resultType" : "matrix",
      "result" : [
         {
            "metric" : {
               "__name__" : "up",
               "job" : "prometheus",
               "instance" : "localhost:9090"
            },
            "values" : [
               [ 1435781430.781, "1" ],
               [ 1435781445.781, "1" ],
               [ 1435781460.781, "1" ]
            ]
         },
         {
            "metric" : {
               "__name__" : "up",
               "job" : "node",
               "instance" : "localhost:9091"
            },
            "values" : [
               [ 1435781430.781, "0" ],
               [ 1435781445.781, "0" ],
               [ 1435781460.781, "1" ]
            ]
         }
      ]
   }
}
```

# 最佳实践：4个黄金指标和USE方法

前面部分介绍了Prometheus的数据存储模型以及4种指标类型，同时Prometheus提供的强大的PromQL可以实现对数据的个性化处理。Promthues基于指标提供了一个通用的监控解决方案。这里先思考一个基本的问题，在实现监控时，我们到底应该监控哪些对象以及哪些指标？

## 监控所有

在之前**Prometheus简介**部分介绍监控的基本目标，首先是及时发现问题其次是要能够快速对问题进行定位。对于传统监控解决方案而言，用户看到的依然是一个黑盒，用户无法真正了解系统的真正的运行状态。因此Prometheus鼓励用户监控所有的东西。下面列举一些常用的监控维度。

| 级别              | 监控什么                                                   | Exporter                        |
| ----------------- | ---------------------------------------------------------- | ------------------------------- |
| 网络              | 网络协议：http、dns、tcp、icmp；网络硬件：路由器，交换机等 | BlockBox Exporter;SNMP Exporter |
| 主机              | 资源用量                                                   | node exporter                   |
| 容器              | 资源用量                                                   | cAdvisor                        |
| 应用(包括Library) | 延迟，错误，QPS，内部状态等                                | 代码中集成Prmometheus Client    |
| 中间件状态        | 资源用量，以及服务状态                                     | 代码中集成Prmometheus Client    |
| 编排工具          | 集群资源用量，调度等                                       | Kubernetes Components           |

## 监控模式

除了上述介绍的不同监控级别以外。实际上根据不同的系统类型和目标，这里还有一些通用的套路和模式可以使用。

## 4个黄金指标

Four Golden Signals是Google针对大量分布式监控的经验总结，4个黄金指标可以在服务级别帮助衡量终端用户体验、服务中断、业务影响等层面的问题。主要关注与以下四种类型的指标：延迟，通讯量，错误以及饱和度：

- 延迟：服务请求所需时间。

记录用户所有请求所需的时间，重点是要区分成功请求的延迟时间和失败请求的延迟时间。 例如在数据库或者其他关键祸端服务异常触发HTTP  500的情况下，用户也可能会很快得到请求失败的响应内容，如果不加区分计算这些请求的延迟，可能导致计算结果与实际结果产生巨大的差异。除此以外，在微服务中通常提倡“快速失败”，开发人员需要特别注意这些延迟较大的错误，因为这些缓慢的错误会明显影响系统的性能，因此追踪这些错误的延迟也是非常重要的。

- 通讯量：监控当前系统的流量，用于衡量服务的容量需求。

流量对于不同类型的系统而言可能代表不同的含义。例如，在HTTP REST API中, 流量通常是每秒HTTP请求数；

- 错误：监控当前系统所有发生的错误请求，衡量当前系统错误发生的速率。

对于失败而言有些是显式的(比如, HTTP 500错误)，而有些是隐式(比如，HTTP响应200，但实际业务流程依然是失败的)。

对于一些显式的错误如HTTP 500可以通过在负载均衡器(如Nginx)上进行捕获，而对于一些系统内部的异常，则可能需要直接从服务中添加钩子统计并进行获取。

- 饱和度：衡量当前服务的饱和度。

主要强调最能影响服务状态的受限制的资源。  例如，如果系统主要受内存影响，那就主要关注系统的内存状态，如果系统主要受限与磁盘I/O，那就主要观测磁盘I/O的状态。因为通常情况下，当这些资源达到饱和后，服务的性能会明显下降。同时还可以利用饱和度对系统做出预测，比如，“磁盘是否可能在4个小时候就满了”。

## RED方法

RED方法是Weave Cloud在基于Google的“4个黄金指标”的原则下结合Prometheus以及Kubernetes容器实践，细化和总结的方法论，特别适合于云原生应用以及微服务架构应用的监控和度量。主要关注以下三种关键指标：

- (请求)速率：服务每秒接收的请求数。
- (请求)错误：每秒失败的请求数。
- (请求)耗时：每个请求的耗时。

在“4大黄金信号”的原则下，RED方法可以有效的帮助用户衡量云原生以及微服务应用下的用户体验问题。

## USE方法

USE方法全称"Utilization Saturation and Errors  Method"，主要用于分析系统性能问题，可以指导用户快速识别资源瓶颈以及错误的方法。正如USE方法的名字所表示的含义，USE方法主要关注与资源的：使用率(Utilization)、饱和度(Saturation)以及错误(Errors)。

- 使用率：关注系统资源的使用情况。 这里的资源主要包括但不限于：CPU，内存，网络，磁盘等等。100%的使用率通常是系统性能瓶颈的标志。
- 饱和度：例如CPU的平均运行排队长度，这里主要是针对资源的饱和度(注意，不同于4大黄金信号)。任何资源在某种程度上的饱和都可能导致系统性能的下降。
- 错误：错误计数。例如：“网卡在数据包传输过程中检测到的以太网网络冲突了14次”。

通过对资源以上指标持续观察，通过以下流程可以知道用户识别资源瓶颈：

![识别资源瓶颈](https://www.prometheus.wang/promql/static/USEMethod.png)识别资源瓶颈

# 小结

PromQL是Prometheus的标准查询语句，通过强大的数据统计能力，使得将监控指标与实际业务进行关联成为可能。同时通过内置的预测函数，能够帮助用户将传统的面向结果转变为面向预测的方式。从而更有效的为业务和系统的正常运行保驾护航。 

# 第3章 Prometheus告警处理

本章我们将带领读者探索Prometheus的告警处理机制，在前面的部分中已经介绍了告警能力在Prometheus的架构中被划分为两个部分，在Prometheus  Server中定义告警规则以及产生告警，Alertmanager组件则用于处理这些由Prometheus产生的告警。Alertmanager即Prometheus体系中告警的统一处理中心。Alertmanager提供了多种内置第三方告警通知方式，同时还提供了对Webhook通知的支持，通过Webhook用户可以完成对告警更多个性化的扩展。

本章主要内容：

- 在Prometheus中自定义告警规则
- 理解Alertmanager特性
- 基于标签的动态告警处理
- 将告警通知发送到第三方服务
- 如何使用Webhook扩展Alertmanager
- 以及一些其他的性能优化模式 

# Prometheus告警简介

告警能力在Prometheus的架构中被划分成两个独立的部分。如下所示，通过在Prometheus中定义AlertRule（告警规则），Prometheus会周期性的对告警规则进行计算，如果满足告警触发条件就会向Alertmanager发送告警信息。

![Prometheus告警处理](https://www.prometheus.wang/alert/static/prometheus-alert-artich.png)Prometheus告警处理

在Prometheus中一条告警规则主要由以下几部分组成：

- 告警名称：用户需要为告警规则命名，当然对于命名而言，需要能够直接表达出该告警的主要内容
- 告警规则：告警规则实际上主要由PromQL进行定义，其实际意义是当表达式（PromQL）查询结果持续多长时间（During）后出发告警

在Prometheus中，还可以通过Group（告警组）对一组相关的告警进行统一定义。当然这些定义都是通过YAML文件来统一管理的。

Alertmanager作为一个独立的组件，负责接收并处理来自Prometheus  Server(也可以是其它的客户端程序)的告警信息。Alertmanager可以对这些告警信息进行进一步的处理，比如当接收到大量重复告警时能够消除重复的告警信息，同时对告警信息进行分组并且路由到正确的通知方，Prometheus内置了对邮件，Slack等多种通知方式的支持，同时还支持与Webhook的集成，以支持更多定制化的场景。例如，目前Alertmanager还不支持钉钉，那用户完全可以通过Webhook与钉钉机器人进行集成，从而通过钉钉接收告警信息。同时AlertManager还提供了静默和告警抑制机制来对告警通知行为进行优化。

## Alertmanager特性

Alertmanager除了提供基本的告警通知能力以外，还主要提供了如：分组、抑制以及静默等告警特性：

![Alertmanager特性](https://www.prometheus.wang/alert/static/alertmanager-features.png)Alertmanager特性

#### 分组

分组机制可以将详细的告警信息合并成一个通知。在某些情况下，比如由于系统宕机导致大量的告警被同时触发，在这种情况下分组机制可以将这些被触发的告警合并为一个告警通知，避免一次性接受大量的告警通知，而无法对问题进行快速定位。

例如，当集群中有数百个正在运行的服务实例，并且为每一个实例设置了告警规则。假如此时发生了网络故障，可能导致大量的服务实例无法连接到数据库，结果就会有数百个告警被发送到Alertmanager。

而作为用户，可能只希望能够在一个通知中中就能查看哪些服务实例收到影响。这时可以按照服务所在集群或者告警名称对告警进行分组，而将这些告警内聚在一起成为一个通知。

告警分组，告警时间，以及告警的接受方式可以通过Alertmanager的配置文件进行配置。

#### 抑制

抑制是指当某一告警发出后，可以停止重复发送由此告警引发的其它告警的机制。

例如，当集群不可访问时触发了一次告警，通过配置Alertmanager可以忽略与该集群有关的其它所有告警。这样可以避免接收到大量与实际问题无关的告警通知。

抑制机制同样通过Alertmanager的配置文件进行设置。

#### 静默

静默提供了一个简单的机制可以快速根据标签对告警进行静默处理。如果接收到的告警符合静默的配置，Alertmanager则不会发送告警通知。

静默设置需要在Alertmanager的Werb页面上进行设置。

# 自定义Prometheus告警规则

Prometheus中的告警规则允许你基于PromQL表达式定义告警触发条件，Prometheus后端对这些触发规则进行周期性计算，当满足触发条件后则会触发告警通知。默认情况下，用户可以通过Prometheus的Web界面查看这些告警规则以及告警的触发状态。当Promthues与Alertmanager关联之后，可以将告警发送到外部服务如Alertmanager中并通过Alertmanager可以对这些告警进行进一步的处理。

## 定义告警规则

一条典型的告警规则如下所示：

```
groups:
- name: example
  rules:
  - alert: HighErrorRate
    expr: job:request_latency_seconds:mean5m{job="myjob"} > 0.5
    for: 10m
    labels:
      severity: page
    annotations:
      summary: High request latency
      description: description info
```

在告警规则文件中，我们可以将一组相关的规则设置定义在一个group下。在每一个group中我们可以定义多个告警规则(rule)。一条告警规则主要由以下几部分组成：

- alert：告警规则的名称。
- expr：基于PromQL表达式告警触发条件，用于计算是否有时间序列满足该条件。
- for：评估等待时间，可选参数。用于表示只有当触发条件持续一段时间后才发送告警。在等待期间新产生告警的状态为pending。
- labels：自定义标签，允许用户指定要附加到告警上的一组附加标签。
- annotations：用于指定一组附加信息，比如用于描述告警详细信息的文字等，annotations的内容在告警产生时会一同作为参数发送到Alertmanager。

为了能够让Prometheus能够启用定义的告警规则，我们需要在Prometheus全局配置文件中通过**rule_files**指定一组告警规则文件的访问路径，Prometheus启动后会自动扫描这些路径下规则文件中定义的内容，并且根据这些规则计算是否向外部发送通知：

```
rule_files:
  [ - <filepath_glob> ... ]
```

默认情况下Prometheus会每分钟对这些告警规则进行计算，如果用户想定义自己的告警计算周期，则可以通过`evaluation_interval`来覆盖默认的计算周期：

```
global:
  [ evaluation_interval: <duration> | default = 1m ]
```

## 模板化

一般来说，在告警规则文件的annotations中使用`summary`描述告警的概要信息，`description`用于描述告警的详细信息。同时Alertmanager的UI也会根据这两个标签值，显示告警信息。为了让告警信息具有更好的可读性，Prometheus支持模板化label和annotations的中标签的值。

通过`$labels.<labelname>`变量可以访问当前告警实例中指定标签的值。$value则可以获取当前PromQL表达式计算的样本值。

```
# To insert a firing element's label values:
{{ $labels.<labelname> }}
# To insert the numeric expression value of the firing element:
{{ $value }}
```

例如，可以通过模板化优化summary以及description的内容的可读性：

```
groups:
- name: example
  rules:

  # Alert for any instance that is unreachable for >5 minutes.
  - alert: InstanceDown
    expr: up == 0
    for: 5m
    labels:
      severity: page
    annotations:
      summary: "Instance {{ $labels.instance }} down"
      description: "{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes."

  # Alert for any instance that has a median request latency >1s.
  - alert: APIHighRequestLatency
    expr: api_http_request_latencies_second{quantile="0.5"} > 1
    for: 10m
    annotations:
      summary: "High request latency on {{ $labels.instance }}"
      description: "{{ $labels.instance }} has a median request latency above 1s (current value: {{ $value }}s)"
```

## 查看告警状态

如下所示，用户可以通过Prometheus WEB界面中的Alerts菜单查看当前Prometheus下的所有告警规则，以及其当前所处的活动状态。

![告警活动状态](https://www.prometheus.wang/alert/static/prometheus-ui-alert.png)告警活动状态

同时对于已经pending或者firing的告警，Prometheus也会将它们存储到时间序列ALERTS{}中。

可以通过表达式，查询告警实例：

```
ALERTS{alertname="<alert name>", alertstate="pending|firing", <additional alert labels>}
```

样本值为1表示当前告警处于活动状态（pending或者firing），当告警从活动状态转换为非活动状态时，样本值则为0。

## 实例：定义主机监控告警

修改Prometheus配置文件prometheus.yml,添加以下配置：

```
rule_files:
  - /etc/prometheus/rules/*.rules
```

在目录/etc/prometheus/rules/下创建告警文件hoststats-alert.rules内容如下：

```
groups:
- name: hostStatsAlert
  rules:
  - alert: hostCpuUsageAlert
    expr: sum(avg without (cpu)(irate(node_cpu{mode!='idle'}[5m]))) by (instance) > 0.85
    for: 1m
    labels:
      severity: page
    annotations:
      summary: "Instance {{ $labels.instance }} CPU usgae high"
      description: "{{ $labels.instance }} CPU usage above 85% (current value: {{ $value }})"
  - alert: hostMemUsageAlert
    expr: (node_memory_MemTotal - node_memory_MemAvailable)/node_memory_MemTotal > 0.85
    for: 1m
    labels:
      severity: page
    annotations:
      summary: "Instance {{ $labels.instance }} MEM usgae high"
      description: "{{ $labels.instance }} MEM usage above 85% (current value: {{ $value }})"
```

重启Prometheus后访问Prometheus UIhttp://127.0.0.1:9090/rules可以查看当前以加载的规则文件。

![告警规则](https://www.prometheus.wang/alert/static/prometheus-ui-rules.png)告警规则

切换到Alerts标签http://127.0.0.1:9090/alerts可以查看当前告警的活动状态。

![告警活动状态](https://www.prometheus.wang/alert/static/prometheus-ui-alert.png)告警活动状态

此时，我们可以手动拉高系统的CPU使用率，验证Prometheus的告警流程，在主机上运行以下命令：

```
cat /dev/zero>/dev/null
```

运行命令后查看CPU使用率情况，如下图所示：

![img](https://www.prometheus.wang/alert/static/node_cpu_usgae_high.png)

Prometheus首次检测到满足触发条件后，hostCpuUsageAlert显示由一条告警处于活动状态。由于告警规则中设置了1m的等待时间，当前告警状态为PENDING，如下图所示：

![img](https://www.prometheus.wang/alert/static/node_cpu_alert_pending.png)

如果1分钟后告警条件持续满足，则会实际触发告警并且告警状态为FIRING，如下图所示：

![img](https://www.prometheus.wang/alert/static/node_cpu_alert_firing.png)

# 部署Alertmanager

Alertmanager和Prometheus Server一样均采用Golang实现，并且没有第三方依赖。一般来说我们可以通过以下几种方式来部署Alertmanager：二进制包、容器以及源码方式安装。

## 使用二进制包部署AlertManager

##### 获取并安装软件包

Alertmanager最新版本的下载地址可以从Prometheus官方网站https://prometheus.io/download/获取。

```shell
export VERSION=0.15.2
curl -LO https://github.com/prometheus/alertmanager/releases/download/v$VERSION/alertmanager-$VERSION.darwin-amd64.tar.gz
tar xvf alertmanager-$VERSION.darwin-amd64.tar.gz
```

##### 创建alertmanager配置文件

Alertmanager解压后会包含一个默认的alertmanager.yml配置文件，内容如下所示：

```
global:
  resolve_timeout: 5m

route:
  group_by: ['alertname']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 1h
  receiver: 'web.hook'
receivers:
- name: 'web.hook'
  webhook_configs:
  - url: 'http://127.0.0.1:5001/'
inhibit_rules:
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['alertname', 'dev', 'instance']
```

Alertmanager的配置主要包含两个部分：路由(route)以及接收器(receivers)。所有的告警信息都会从配置中的顶级路由(route)进入路由树，根据路由规则将告警信息发送给相应的接收器。

在Alertmanager中可以定义一组接收器，比如可以按照角色(比如系统运维，数据库管理员)来划分多个接收器。接收器可以关联邮件，Slack以及其它方式接收告警信息。

当前配置文件中定义了一个默认的接收者default-receiver由于这里没有设置接收方式，目前只相当于一个占位符。关于接收器的详细介绍会在后续章节介绍。

在配置文件中使用route定义了顶级的路由，路由是一个基于标签匹配规则的树状结构。所有的告警信息从顶级路由开始，根据标签匹配规则进入到不同的子路由，并且根据子路由设置的接收器发送告警。目前配置文件中只设置了一个顶级路由route并且定义的接收器为default-receiver。因此，所有的告警都会发送给default-receiver。关于路由的详细内容会在后续进行详细介绍。

##### 启动Alertmanager

Alermanager会将数据保存到本地中，默认的存储路径为`data/`。因此，在启动Alertmanager之前需要创建相应的目录：

```
./alertmanager
```

用户也在启动Alertmanager时使用参数修改相关配置。`--config.file`用于指定alertmanager配置文件路径，`--storage.path`用于指定数据存储路径。

#### 查看运行状态

Alertmanager启动后可以通过9093端口访问，http://192.168.33.10:9093

![Alertmanager页面](https://www.prometheus.wang/alert/static/alertmanager.png)Alertmanager页面

Alert菜单下可以查看Alertmanager接收到的告警内容。Silences菜单下则可以通过UI创建静默规则，这部分我们会在后续部分介绍。进入Status菜单，可以看到当前系统的运行状态以及配置信息。

## 关联Prometheus与Alertmanager

在Prometheus的架构中被划分成两个独立的部分。Prometheus负责产生告警，而Alertmanager负责告警产生后的后续处理。因此Alertmanager部署完成后，需要在Prometheus中设置Alertmanager相关的信息。

编辑Prometheus配置文件prometheus.yml,并添加以下内容

```
alerting:
  alertmanagers:
    - static_configs:
        - targets: ['localhost:9093']
```

重启Prometheus服务，成功后，可以从http://192.168.33.10:9090/config查看alerting配置是否生效。

此时，再次尝试手动拉高系统CPU使用率：

```
cat /dev/zero>/dev/null
```

等待Prometheus告警进行触发状态：

![img](https://www.prometheus.wang/alert/static/prometheus-alert-firing-with-manager.png)

查看Alertmanager UI此时可以看到Alertmanager接收到的告警信息。

![img](https://www.prometheus.wang/alert/static/alertmanager-alert.png)

## 接下来

目前为止，我们已经成功安装部署了Alertmanager并且与Prometheus关联，能够正常接收来自Prometheus的告警信息。接下来我们将详细介绍Alertmanager是如何处理这些接收到的告警信息的。

# Alertmanager配置概述

在上面的部分中已经简单介绍过，在Alertmanager中通过路由(Route)来定义告警的处理方式。路由是一个基于标签匹配的树状匹配结构。根据接收到告警的标签匹配相应的处理方式。这里将详细介绍路由相关的内容。

Alertmanager主要负责对Prometheus产生的告警进行统一处理，因此在Alertmanager配置中一般会包含以下几个主要部分：

- 全局配置（global）：用于定义一些全局的公共参数，如全局的SMTP配置，Slack配置等内容；
- 模板（templates）：用于定义告警通知时的模板，如HTML模板，邮件模板等；
- 告警路由（route）：根据标签匹配，确定当前告警应该如何处理；
- 接收人（receivers）：接收人是一个抽象的概念，它可以是一个邮箱也可以是微信，Slack或者Webhook等，接收人一般配合告警路由使用；
- 抑制规则（inhibit_rules）：合理设置抑制规则可以减少垃圾告警的产生

其完整配置格式如下：

```
global:
  [ resolve_timeout: <duration> | default = 5m ]
  [ smtp_from: <tmpl_string> ] 
  [ smtp_smarthost: <string> ] 
  [ smtp_hello: <string> | default = "localhost" ]
  [ smtp_auth_username: <string> ]
  [ smtp_auth_password: <secret> ]
  [ smtp_auth_identity: <string> ]
  [ smtp_auth_secret: <secret> ]
  [ smtp_require_tls: <bool> | default = true ]
  [ slack_api_url: <secret> ]
  [ victorops_api_key: <secret> ]
  [ victorops_api_url: <string> | default = "https://alert.victorops.com/integrations/generic/20131114/alert/" ]
  [ pagerduty_url: <string> | default = "https://events.pagerduty.com/v2/enqueue" ]
  [ opsgenie_api_key: <secret> ]
  [ opsgenie_api_url: <string> | default = "https://api.opsgenie.com/" ]
  [ hipchat_api_url: <string> | default = "https://api.hipchat.com/" ]
  [ hipchat_auth_token: <secret> ]
  [ wechat_api_url: <string> | default = "https://qyapi.weixin.qq.com/cgi-bin/" ]
  [ wechat_api_secret: <secret> ]
  [ wechat_api_corp_id: <string> ]
  [ http_config: <http_config> ]

templates:
  [ - <filepath> ... ]

route: <route>

receivers:
  - <receiver> ...

inhibit_rules:
  [ - <inhibit_rule> ... ]
```

在全局配置中需要注意的是`resolve_timeout`，该参数定义了当Alertmanager持续多长时间未接收到告警后标记告警状态为resolved（已解决）。该参数的定义可能会影响到告警恢复通知的接收时间，读者可根据自己的实际场景进行定义，其默认值为5分钟。在接下来的部分，我们将已一些实际的例子解释Alertmanager的其它配置内容。 

# 基于标签的告警路由

在Alertmanager的配置中会定义一个基于标签匹配规则的告警路由树，以确定在接收到告警后Alertmanager需要如何对其进行处理：

```
route: <route>
```

其中route中则主要定义了告警的路由匹配规则，以及Alertmanager需要将匹配到的告警发送给哪一个receiver，一个最简单的route定义如下所示：

```
route:
  group_by: ['alertname']
  receiver: 'web.hook'
receivers:
- name: 'web.hook'
  webhook_configs:
  - url: 'http://127.0.0.1:5001/'
```

如上所示：在Alertmanager配置文件中，我们只定义了一个路由，那就意味着所有由Prometheus产生的告警在发送到Alertmanager之后都会通过名为`web.hook`的receiver接收。这里的web.hook定义为一个webhook地址。当然实际场景下，告警处理可不是这么简单的一件事情，对于不同级别的告警，我们可能会不完全不同的处理方式，因此在route中，我们还可以定义更多的子Route，这些Route通过标签匹配告警的处理方式，route的完整定义如下：

```
[ receiver: <string> ]
[ group_by: '[' <labelname>, ... ']' ]
[ continue: <boolean> | default = false ]

match:
  [ <labelname>: <labelvalue>, ... ]

match_re:
  [ <labelname>: <regex>, ... ]

[ group_wait: <duration> | default = 30s ]
[ group_interval: <duration> | default = 5m ]
[ repeat_interval: <duration> | default = 4h ]

routes:
  [ - <route> ... ]
```

## 路由匹配

每一个告警都会从配置文件中顶级的route进入路由树，需要注意的是顶级的route必须匹配所有告警(即不能有任何的匹配设置match和match_re)，每一个路由都可以定义自己的接受人以及匹配规则。默认情况下，告警进入到顶级route后会遍历所有的子节点，直到找到最深的匹配route，并将告警发送到该route定义的receiver中。但如果route中设置**continue**的值为false，那么告警在匹配到第一个子节点之后就直接停止。如果**continue**为true，报警则会继续进行后续子节点的匹配。如果当前告警匹配不到任何的子节点，那该告警将会基于当前路由节点的接收器配置方式进行处理。

其中告警的匹配有两种方式可以选择。一种方式基于字符串验证，通过设置**match**规则判断当前告警中是否存在标签labelname并且其值等于labelvalue。第二种方式则基于正则表达式，通过设置**match_re**验证当前告警标签的值是否满足正则表达式的内容。

如果警报已经成功发送通知, 如果想设置发送告警通知之前要等待时间，则可以通过**repeat_interval**参数进行设置。

## 告警分组

在之前的部分有讲过，Alertmanager可以对告警通知进行分组，将多条告警合合并为一个通知。这里我们可以使用**group_by**来定义分组规则。基于告警中包含的标签，如果满足**group_by**中定义标签名称，那么这些告警将会合并为一个通知发送给接收器。

有的时候为了能够一次性收集和发送更多的相关信息时，可以通过**group_wait**参数设置等待时间，如果在等待时间内当前group接收到了新的告警，这些告警将会合并为一个通知向receiver发送。

而**group_interval**配置，则用于定义相同的Group之间发送告警通知的时间间隔。

例如，当使用Prometheus监控多个集群以及部署在集群中的应用和数据库服务，并且定义以下的告警处理路由规则来对集群中的异常进行通知。

```
route:
  receiver: 'default-receiver'
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 4h
  group_by: [cluster, alertname]
  routes:
  - receiver: 'database-pager'
    group_wait: 10s
    match_re:
      service: mysql|cassandra
  - receiver: 'frontend-pager'
    group_by: [product, environment]
    match:
      team: frontend
```

默认情况下所有的告警都会发送给集群管理员default-receiver，因此在Alertmanager的配置文件的根路由中，对告警信息按照集群以及告警的名称对告警进行分组。

如果告警时来源于数据库服务如MySQL或者Cassandra，此时则需要将告警发送给相应的数据库管理员(database-pager)。这里定义了一个单独子路由，如果告警中包含service标签，并且service为MySQL或者Cassandra,则向database-pager发送告警通知，由于这里没有定义group_by等属性，这些属性的配置信息将从上级路由继承，database-pager将会接收到按cluster和alertname进行分组的告警通知。

而某些告警规则来源可能来源于开发团队的定义，这些告警中通过添加标签team来标示这些告警的创建者。在Alertmanager配置文件的告警路由下，定义单独子路由用于处理这一类的告警通知，如果匹配到告警中包含标签team，并且team的值为frontend，Alertmanager将会按照标签product和environment对告警进行分组。此时如果应用出现异常，开发团队就能清楚的知道哪一个环境(environment)中的哪一个应用程序出现了问题，可以快速对应用进行问题定位。

# 内置告警接收器Receiver

前上一小节已经讲过，在Alertmanager中路由负责对告警信息进行分组匹配，并将像告警接收器发送通知。告警接收器可以通过以下形式进行配置：

```
receivers:
  - <receiver> ...
```

每一个receiver具有一个全局唯一的名称，并且对应一个或者多个通知方式：

```
name: <string>
email_configs:
  [ - <email_config>, ... ]
hipchat_configs:
  [ - <hipchat_config>, ... ]
pagerduty_configs:
  [ - <pagerduty_config>, ... ]
pushover_configs:
  [ - <pushover_config>, ... ]
slack_configs:
  [ - <slack_config>, ... ]
opsgenie_configs:
  [ - <opsgenie_config>, ... ]
webhook_configs:
  [ - <webhook_config>, ... ]
victorops_configs:
  [ - <victorops_config>, ... ]
```

目前官方内置的第三方通知集成包括：邮件、  即时通讯软件（如Slack、Hipchat）、移动应用消息推送(如Pushover)和自动化运维工具（例如：Pagerduty、Opsgenie、Victorops）。Alertmanager的通知方式中还可以支持Webhook，通过这种方式开发者可以实现更多个性化的扩展支持。

# 与SMTP邮件集成

邮箱应该是目前企业最常用的告警通知方式，Alertmanager内置了对SMTP协议的支持，因此对于企业用户而言，只需要一些基本的配置即可实现通过邮件的通知。

在Alertmanager使用邮箱通知，用户只需要定义好SMTP相关的配置，并且在receiver中定义接收方的邮件地址即可。在Alertmanager中我们可以直接在配置文件的global中定义全局的SMTP配置：

```
global:
  [ smtp_from: <tmpl_string> ]
  [ smtp_smarthost: <string> ]
  [ smtp_hello: <string> | default = "localhost" ]
  [ smtp_auth_username: <string> ]
  [ smtp_auth_password: <secret> ]
  [ smtp_auth_identity: <string> ]
  [ smtp_auth_secret: <secret> ]
  [ smtp_require_tls: <bool> | default = true ]
```

完成全局SMTP之后，我们只需要为receiver配置email_configs用于定义一组接收告警的邮箱地址即可，如下所示：

```
name: <string>
email_configs:
  [ - <email_config>, ... ]
```

每个email_config中定义相应的接收人邮箱地址，邮件通知模板等信息即可，当然如果当前接收人需要单独的SMTP配置，那直接在email_config中覆盖即可：

```
[ send_resolved: <boolean> | default = false ]
to: <tmpl_string>
[ html: <tmpl_string> | default = '{{ template "email.default.html" . }}' ]
[ headers: { <string>: <tmpl_string>, ... } ]
```

如果当前收件人需要接受告警恢复的通知的话，在email_config中定义`send_resolved`为true即可。

如果所有的邮件配置使用了相同的SMTP配置，则可以直接定义全局的SMTP配置。

这里，以Gmail邮箱为例，我们定义了一个全局的SMTP配置，并且通过route将所有告警信息发送到default-receiver中:

```
global:
  smtp_smarthost: smtp.gmail.com:587
  smtp_from: <smtp mail from>
  smtp_auth_username: <usernae>
  smtp_auth_identity: <username>
  smtp_auth_password: <password>

route:
  group_by: ['alertname']
  receiver: 'default-receiver'

receivers:
  - name: default-receiver
    email_configs:
      - to: <mail to address>
        send_resolved: true
```

> 需要注意的是新的Google账号安全规则需要使用”应用专有密码“作为邮箱登录密码

这时如果手动拉高主机CPU使用率，使得监控样本数据满足告警触发条件。在SMTP配置正确的情况下，可以接收到如下的告警内容：

![告警](https://www.prometheus.wang/alert/static/mail-alert-page.png) 

# 与Slack集成

Slack是非常流行的团队沟通应用，提供群组聊天和直接消息发送功能，支持移动端，Web  和桌面平台。在国外有大量的IT团队使用Slack作为团队协作平台。同时其提供了强大的集成能力，在Slack的基础上也衍生出了大量的ChatOps相关的技术实践。这部分将介绍如何将Slack集成到Alertmanager中。

## 认识Slack

![Slack](https://www.prometheus.wang/alert/static/slack-overview.png)Slack

Slack作为一款即时通讯工具，协作沟通主要通过Channel（平台）来完成，用户可以在企业中根据用途添加多个Channel，并且通过Channel来集成各种第三方工具。

例如，我们可以为监控建立一个单独的Channel用于接收各种监控信息：

![创建Channel](https://www.prometheus.wang/alert/static/slack-create-channel.png)创建Channel

通过一个独立的Channle可以减少信息对用户工作的干扰，并且将相关信息聚合在一起：

![Monitoring](https://www.prometheus.wang/alert/static/slack-channel.png)Monitoring

Slack的强大之处在于在Channel中添加各种第三方服务的集成，用户也可以基于Slack开发自己的聊天机器人来实现一些更高级的能力，例如自动化运维，提高开发效率等。

## 添加应用：Incomming Webhooks

为了能够在Monitoring中接收来自Alertmanager的消息，我们需要在Channel的设置选项中使用"Add an App"为Monitoring channel添加一个名为`Incoming WebHooks`的应用：

![添加Incomming Webhooks](https://www.prometheus.wang/alert/static/add-incomming-webhooks.png)添加Incomming Webhooks

添加成功后Slack会显示`Incoming WebHooks`配置和使用方式：

![Incomming Webhhook配置](https://www.prometheus.wang/alert/static/incomming-webhooks-setting.png)Incomming Webhhook配置

Incomming Webhook的工作方式很简单，Slack为当前Channel创建了一个用于接收消息的API地址：

```
https://hooks.slack.com/services/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
```

用户只需要使用Post方式向Channel发送需要通知的消息即可，例如，我们可以在命令行中通过curl模拟一次消息通知：

```
curl -d "payload={'text': 'This is a line of text in a channel.\nAnd this is another line of text.'}" https://hooks.slack.com/services/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
```

在网络正常的情况下，在Channel中会显示新的通知信息，如下所示：

![测试消息](https://www.prometheus.wang/alert/static/slack-receiver-message.png)测试消息

除了发送纯文本以外，slack还支持在文本内容中添加链接，例如：

```
payload={"text": "A very important thing has occurred! <https://alert-system.com/alerts/1234|Click here> for details!"}
```

此时接收到的消息中建辉包含一个可点击的超链接地址。除了payload以外，Incomming Webhhook还支持一些其他的参数：

| 参数       | 作用                                                         | 示例                                   |
| ---------- | ------------------------------------------------------------ | -------------------------------------- |
| username   | 设置当前聊天机器人的名称                                     | webhookbot                             |
| icon_url   | 当前聊天机器人的头像地址                                     | https://slack.com/img/icons/app-57.png |
| icon_emoji | 使用emoji作为聊天机器人的头像                                | :ghost:                                |
| channel    | 消息发送的目标channel, 需要直接发给特定用户时使用@username即可 | #monitoring 或者 @username             |

例如，使用以上参数发送一条更有趣的消息：

```
curl -X POST --data-urlencode "payload={'channel': '#monitoring', 'username': 'webhookbot', 'text': 'This is posted to #monitoring and comes from a bot named webhookbot.', 'icon_emoji': ':ghost:'}" https://hooks.slack.com/services/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
```

![自定义消息](https://www.prometheus.wang/alert/static/custom-slack-message.png)自定义消息

## 在Alertmanager中使用Slack

在了解了Slack以及Incomming Webhhook的基本使用方式后，在Alertmanager中添加Slack支持就非常简单了。

在Alertmanager的全局配置中，将Incomming Webhhook地址作为slack_api_url添加到全局配置中即可：

```
global:
  slack_api_url: https://hooks.slack.com/services/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
```

当然，也可以在每个receiver中单独定义自己的slack_configs即可：

```
receivers：
- name: slack
  slack_configs:
    - channel: '#monitoring'
      send_resolved: true
```

这里如果我们手动拉高当前主机的CPU利用率，在#Monitoring平台中，我们会接收到一条告警信息如下所示：

![告警信息](https://www.prometheus.wang/alert/static/slack_alert_message.png)告警信息

而当告警项恢复正常后，则可以接收到如下通知：

![告警恢复信息](https://www.prometheus.wang/alert/static/slack_resolved_message.png)告警恢复信息

对于Incomming Webhhook支持的其它自定义参数，也可以在slack_config中进行定义，slack_config的主要配置如下：

```
channel: <tmpl_string>
[ send_resolved: <boolean> | default = false ]
[ api_url: <secret> | default = global.slack_api_url ]
[ icon_emoji: <tmpl_string> ]
[ icon_url: <tmpl_string> ]
[ link_names: <boolean> | default = false ]
[ username: <tmpl_string> | default = '{{ template "slack.default.username" . }}' ]
[ color: <tmpl_string> | default = '{{ if eq .Status "firing" }}danger{{ else }}good{{ end }}' ]
[ footer: <tmpl_string> | default = '{{ template "slack.default.footer" . }}' ]
[ pretext: <tmpl_string> | default = '{{ template "slack.default.pretext" . }}' ]
[ text: <tmpl_string> | default = '{{ template "slack.default.text" . }}' ]
[ title: <tmpl_string> | default = '{{ template "slack.default.title" . }}' ]
[ title_link: <tmpl_string> | default = '{{ template "slack.default.titlelink" . }}' ]
[ image_url: <tmpl_string> ]
[ thumb_url: <tmpl_string> ]
```

如果要覆盖默认的告警内容，直接使用Go Template即可。例如：

```
color: '{{ if eq .Status "firing" }}danger{{ else }}good{{ end }}'
```

# 与企业微信集成

Alertmanager已经内置了对企业微信的支持，我们可以通过企业微信来管理报警，更进一步可以通过企业微信和微信的互通来直接将告警消息转发到个人微信上。

[prometheus官网](https://prometheus.io/docs/alerting/configuration/#wechat_config)中给出了企业微信的相关配置说明

```
# Whether or not to notify about resolved alerts.
[ send_resolved: <boolean> | default = false ]

# The API key to use when talking to the WeChat API.
[ api_secret: <secret> | default = global.wechat_api_secret ]

# The WeChat API URL.
[ api_url: <string> | default = global.wechat_api_url ]

# The corp id for authentication.
[ corp_id: <string> | default = global.wechat_api_corp_id ]

# API request data as defined by the WeChat API.
[ message: <tmpl_string> | default = '{{ template "wechat.default.message" . }}' ]
[ agent_id: <string> | default = '{{ template "wechat.default.agent_id" . }}' ]
[ to_user: <string> | default = '{{ template "wechat.default.to_user" . }}' ]
[ to_party: <string> | default = '{{ template "wechat.default.to_party" . }}' ]
[ to_tag: <string> | default = '{{ template "wechat.default.to_tag" . }}' ]
```

企业微信相关概念说明请参考[企业微信API说明](https://work.weixin.qq.com/api/doc#90000/90135/90665)，可以在企业微信的后台中建立多个应用，每个应用对应不同的报警分组，由企业微信来做接收成员的划分。具体配置参考如下：

```
global:
  resolve_timeout: 10m
  wechat_api_url: 'https://qyapi.weixin.qq.com/cgi-bin/'
  wechat_api_secret: '应用的secret，在应用的配置页面可以看到'
  wechat_api_corp_id: '企业id，在企业的配置页面可以看到'
templates:
- '/etc/alertmanager/config/*.tmpl'
route:
  group_by: ['alertname']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 12h
  routes:
  - receiver: 'wechat'
    continue: true
inhibit_rules:
- source_match:
receivers:
- name: 'wechat'
  wechat_configs:
  - send_resolved: false
    corp_id: '企业id，在企业的配置页面可以看到'
    to_user: '@all'
    to_party: ' PartyID1 | PartyID2 '
    message: '{{ template "wechat.default.message" . }}'
    agent_id: '应用的AgentId，在应用的配置页面可以看到'
    api_secret: '应用的secret，在应用的配置页面可以看到'
```

配置模板示例如下：

```
{{ define "wechat.default.message" }}
{{- if gt (len .Alerts.Firing) 0 -}}
{{- range $index, $alert := .Alerts -}}
{{- if eq $index 0 -}}
告警类型: {{ $alert.Labels.alertname }}
告警级别: {{ $alert.Labels.severity }}

=====================
{{- end }}
===告警详情===
告警详情: {{ $alert.Annotations.message }}
故障时间: {{ $alert.StartsAt.Format "2006-01-02 15:04:05" }}
===参考信息===
{{ if gt (len $alert.Labels.instance) 0 -}}故障实例ip: {{ $alert.Labels.instance }};{{- end -}}
{{- if gt (len $alert.Labels.namespace) 0 -}}故障实例所在namespace: {{ $alert.Labels.namespace }};{{- end -}}
{{- if gt (len $alert.Labels.node) 0 -}}故障物理机ip: {{ $alert.Labels.node }};{{- end -}}
{{- if gt (len $alert.Labels.pod_name) 0 -}}故障pod名称: {{ $alert.Labels.pod_name }}{{- end }}
=====================
{{- end }}
{{- end }}

{{- if gt (len .Alerts.Resolved) 0 -}}
{{- range $index, $alert := .Alerts -}}
{{- if eq $index 0 -}}
告警类型: {{ $alert.Labels.alertname }}
告警级别: {{ $alert.Labels.severity }}

=====================
{{- end }}
===告警详情===
告警详情: {{ $alert.Annotations.message }}
故障时间: {{ $alert.StartsAt.Format "2006-01-02 15:04:05" }}
恢复时间: {{ $alert.EndsAt.Format "2006-01-02 15:04:05" }}
===参考信息===
{{ if gt (len $alert.Labels.instance) 0 -}}故障实例ip: {{ $alert.Labels.instance }};{{- end -}}
{{- if gt (len $alert.Labels.namespace) 0 -}}故障实例所在namespace: {{ $alert.Labels.namespace }};{{- end -}}
{{- if gt (len $alert.Labels.node) 0 -}}故障物理机ip: {{ $alert.Labels.node }};{{- end -}}
{{- if gt (len $alert.Labels.pod_name) 0 -}}故障pod名称: {{ $alert.Labels.pod_name }};{{- end }}
=====================
{{- end }}
{{- end }}
{{- end }}
```

这时如果某一容器频繁重启，可以接收到如下的告警内容：

![告警](https://www.prometheus.wang/alert/static/wechat-alert-page.png)告警

# 使用Webhook扩展Alertmanager

在某些情况下除了Alertmanager已经内置的集中告警通知方式以外，对于不同的用户和组织而言还需要一些自定义的告知方式支持。通过Alertmanager提供的webhook支持可以轻松实现这一类的扩展。除了用于支持额外的通知方式，webhook还可以与其他第三方系统集成实现运维自动化，或者弹性伸缩等。

在Alertmanager中可以使用如下配置定义基于webhook的告警接收器receiver。一个receiver可以对应一组webhook配置。

```yaml
name: <string>
webhook_configs:
  [ - <webhook_config>, ... ]
```

每一项webhook_config的具体配置格式如下：

```yaml
# Whether or not to notify about resolved alerts.
[ send_resolved: <boolean> | default = true ]

# The endpoint to send HTTP POST requests to.
url: <string>

# The HTTP client's configuration.
[ http_config: <http_config> | default = global.http_config ]
```

send_resolved用于指定是否在告警消除时发送回执消息。url则是用于接收webhook请求的地址。http_configs则是在需要对请求进行SSL配置时使用。

当用户定义webhook用于接收告警信息后，当告警被触发时，Alertmanager会按照以下格式向这些url地址发送HTTP Post请求，请求内容如下：

```json
{
  "version": "4",
  "groupKey": <string>,    // key identifying the group of alerts (e.g. to deduplicate)
  "status": "<resolved|firing>",
  "receiver": <string>,
  "groupLabels": <object>,
  "commonLabels": <object>,
  "commonAnnotations": <object>,
  "externalURL": <string>,  // backlink to the Alertmanager.
  "alerts": [
    {
      "labels": <object>,
      "annotations": <object>,
      "startsAt": "<rfc3339>",
      "endsAt": "<rfc3339>"
    }
  ]
}
```

### 使用Golang创建webhook服务

首先我们尝试使用Golang创建用于接收webhook告警通知的服务。首先创建model包，用于映射ALertmanager发送的告警信息，Alertmanager的一个通知中根据配置的group_by规则可能会包含多条告警信息Alert。创建告警通知对应的结构体Notification。

```golang
package model

import "time"

type Alert struct {
    Labels      map[string]string `json:"labels"`
    Annotations map[string]string `json:annotations`
    StartsAt    time.Time         `json:"startsAt"`
    EndsAt      time.Time         `json:"endsAt"`
}

type Notification struct {
    Version           string            `json:"version"`
    GroupKey          string            `json:"groupKey"`
    Status            string            `json:"status"`
    Receiver          string            `json:receiver`
    GroupLabels       map[string]string `json:groupLabels`
    CommonLabels      map[string]string `json:commonLabels`
    CommonAnnotations map[string]string `json:commonAnnotations`
    ExternalURL       string            `json:externalURL`
    Alerts            []Alert           `json:alerts`
}
```

这里使用gin-gonic框架创建用于接收Webhook通知的Web服务。定义路由/webhook接收来自Alertmanager的POST请求。

```golang
package main

import (
    "net/http"

    "github.com/gin-gonic/gin"
    model "github.com/k8stech/alertmanaer-dingtalk-webhook/model"
)

func main() {
    router := gin.Default()
    router.POST("/webhook", func(c *gin.Context) {
        var notification model.Notification

        err := c.BindJSON(&notification)

        if err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
            return
        }

        c.JSON(http.StatusOK, gin.H{"message": " successful receive alert notification message!"})

    })
    router.Run()
}
```

### 与钉钉集成

钉钉，阿里巴巴出品，专为中国企业打造的免费智能移动办公平台，提供了即时通讯以及移动办公等丰富的功能。

[钉钉群机器人](https://open-doc.dingtalk.com/docs/doc.htm?spm=a219a.7629140.0.0.8M9OKD&treeId=257&articleId=105733&docType=1)是钉钉群的高级扩展功能。群机器人可以将第三方服务的信息聚合到群聊中，实现自动化的信息同步。例如：通过聚合GitHub，GitLab等源码管理服务，实现源码更新同步；通过聚合Trello，JIRA等项目协调服务，实现项目信息同步。不仅如此，群机器人支持Webhook协议的自定义接入，支持更多可能性。这里我们将演示如果将Alertmanager运维报警提醒通过自定义机器人聚合到钉钉群。

这里将继续扩展webhook服务，以支持将Alertmanager的告警通知转发到钉钉平台。完整的示例代码可以从github仓库https://github.com/k8stech/alertmanaer-dingtalk-webhook中获取。

##### 自定义webhook群机器人

通过钉钉客户端（如：桌面或者手机）进入到群设置后选择“群机器人”。将显示如下界面：

![群机器人](https://www.prometheus.wang/alert/static/dingding-group-robot.png)群机器人

选择“自定义机器人”，并且按照提示填写机器人名称，获取机器人webhook地址，如下所示：

![获取webhook地址](https://www.prometheus.wang/alert/static/dingtalk-robot-create-webhook.png)获取webhook地址

webhook机器人创建成功后，用户就可以使用任何方式向该地址发起HTTP POST请求，即可实现向该群主发送消息。目前自定义机器人支持文本(text)，连接(link)，markdown三种消息类型。

例如，可以向webhook地址以POST形式发送以下

```json
{
     "msgtype": "markdown",
     "markdown": {
         "title":"Prometheus告警信息",
         "text": "#### 监控指标\n" +
                 "> 监控描述信息\n\n" +
                 "> ###### 告警时间 \n"
     },
    "at": {
        "atMobiles": [
            "156xxxx8827",
            "189xxxx8325"
        ], 
        "isAtAll": false
    }
 }
```

可以使用curl验证钉钉webhook是否能够成功调用：

```
$ curl -l -H "Content-type: application/json" -X POST -d '{"msgtype": "markdown","markdown": {"title":"Prometheus告警信息","text": "#### 监控指标\n> 监控描述信息\n\n> ###### 告警时间 \n"},"at": {"isAtAll": false}}' https://oapi.dingtalk.com/robot/send?access_token=xxxx
{"errcode":0,"errmsg":"ok"}
```

调用成功后，可以在钉钉应用群消息中接收到类似于如下通知消息:

![测试消息](https://www.prometheus.wang/alert/static/dingtalk-message-test.png)测试消息

##### 定义转换器将告警通知转化为Dingtalk消息对象

这里定义结构体DingTalkMarkdown用于映射Dingtalk的消息体。

```golang
package model

type At struct {
    AtMobiles []string `json:"atMobiles"`
    IsAtAll   bool     `json:"isAtAll"`
}

type DingTalkMarkdown struct {
    MsgType  string    `json:"msgtype"`
    At       *At       `json:at`
    Markdown *Markdown `json:"markdown"`
}

type Markdown struct {
    Title string `json:"title"`
    Text  string `json:"text"`
}
```

定义转换器将Alertmanager发送的告警通知转换为Dingtalk的消息体。

```golang
package transformer

import (
    "bytes"
    "fmt"

    "github.com/k8stech/alertmanaer-dingtalk-webhook/model"
)

// TransformToMarkdown transform alertmanager notification to dingtalk markdow message
func TransformToMarkdown(notification model.Notification) (markdown *model.DingTalkMarkdown, err error) {

    groupKey := notification.GroupKey
    status := notification.Status

    annotations := notification.CommonAnnotations

    var buffer bytes.Buffer

    buffer.WriteString(fmt.Sprintf("### 通知组%s(当前状态:%s) \n", groupKey, status))

    buffer.WriteString(fmt.Sprintf("#### 告警项:\n"))

    for _, alert := range notification.Alerts {
        annotations := alert.Annotations
        buffer.WriteString(fmt.Sprintf("##### %s\n > %s\n", annotations["summary"], annotations["description"]))
        buffer.WriteString(fmt.Sprintf("\n> 开始时间：%s\n", alert.StartsAt.Format("15:04:05")))
    }

    markdown = &model.DingTalkMarkdown{
        MsgType: "markdown",
        Markdown: &model.Markdown{
            Title: fmt.Sprintf("通知组：%s(当前状态:%s)", groupKey, status),
            Text:  buffer.String(),
        },
        At: &model.At{
            IsAtAll: false,
        },
    }

    return
}
```

##### 创建Dingtalk通知发送包

notifier包中使用golang的net/http包实现与Dingtalk群机器人的交互。Send方法包含两个参数：接收到的告警通知结构体指针，以及Dingtalk群机器人的Webhook地址。

通过包transformer.TransformToMarkdown将Alertmanager告警通知与Dingtalk消息进行映射。

```golang
package notifier

import (
    "bytes"
    "encoding/json"
    "fmt"
    "net/http"

    "github.com/k8stech/alertmanaer-dingtalk-webhook/model"
    "github.com/k8stech/alertmanaer-dingtalk-webhook/transformer"
)

func Send(notification model.Notification, dingtalkRobot string) (err error) {

    markdown, err := transformer.TransformToMarkdown(notification)

    if err != nil {
        return
    }

    data, err := json.Marshal(markdown)
    if err != nil {
        return
    }

    req, err := http.NewRequest(
        "POST",
        dingtalkRobot,
        bytes.NewBuffer(data))

    if err != nil {
        return
    }

    req.Header.Set("Content-Type", "application/json")
    client := &http.Client{}
    resp, err := client.Do(req)

    if err != nil {
        return
    }

    defer resp.Body.Close()
    fmt.Println("response Status:", resp.Status)
    fmt.Println("response Headers:", resp.Header)

    return
}
```

##### 扩展启动函数

首先为程序添加命令行参数支持，用于在启动时添加全局的Dingtalk群聊机器人地址。

```golang
package main

import (
  "flag"
  ...
  "github.com/k8stech/alertmanaer-dingtalk-webhook/notifier"
)

var (
    h            bool
    defaultRobot string
)

func init() {
    flag.BoolVar(&h, "h", false, "help")
    flag.StringVar(&defaultRobot, "defaultRobot", "", "global dingtalk robot webhook")
}

func main() {

    flag.Parse()

    if h {
        flag.Usage()
        return
    }

  ...

}
```

同时通过notifier包的Send方法将告警通知发送给Dingtalk群聊机器人

```
func main() {

  ...

  err = notifier.Send(notification, defaultRobot)

  if err != nil {
    c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})

  }

  c.JSON(http.StatusOK, gin.H{"message": "send to dingtalk successful!"})
}
```

##### 使用Dingtalk扩展

运行并启动dingtalk webhook服务之后，修改Alertmanager配置文件, 为default-receiver添加webhook配置，如下所示：

```
receivers:
  - name: default-receiver
    email_configs:
      - to: yunl.zheng@wise2c.com
    webhook_configs:
      - url: http://localhost:8080/webhook
```

重启Alertmanager服务后，手动拉高虚拟机CPU使用率触发告警条件，此时Dingtalk即可接收到相应的告警通知信息:

![钉钉群机器人告警信息](https://www.prometheus.wang/alert/static/alertmanager-dingtalk-test-result.png) 

## 自定义告警模板

默认情况下Alertmanager使用了系统自带的默认通知模板，模板源码可以从https://github.com/prometheus/alertmanager/blob/master/template/default.tmpl获得。Alertmanager的通知模板基于[Go的模板系统](http://golang.org/pkg/text/template)。Alertmanager也支持用户定义和使用自己的模板，一般来说有两种方式可以选择。

第一种，基于模板字符串。用户可以直接在Alertmanager的配置文件中使用模板字符串，例如:

```
receivers:
- name: 'slack-notifications'
  slack_configs:
  - channel: '#alerts'
    text: 'https://internal.myorg.net/wiki/alerts/{{ .GroupLabels.app }}/{{ .GroupLabels.alertname }}'
```

第二种方式，自定义可复用的模板文件。例如，可以创建自定义模板文件custom-template.tmpl，如下所示：

```
{{ define "slack.myorg.text" }}https://internal.myorg.net/wiki/alerts/{{ .GroupLabels.app }}/{{ .GroupLabels.alertname }}{{ end}}
```

通过在Alertmanager的全局设置中定义templates配置来指定自定义模板的访问路径:

```
# Files from which custom notification template definitions are read.
# The last component may use a wildcard matcher, e.g. 'templates/*.tmpl'.
templates:
  [ - <filepath> ... ]
```

在设置了自定义模板的访问路径后，用户则可以直接在配置中使用该模板：

```
receivers:
- name: 'slack-notifications'
  slack_configs:
  - channel: '#alerts'
    text: '{{ template "slack.myorg.text" . }}'

templates:
- '/etc/alertmanager/templates/myorg.tmpl'
```

# 屏蔽告警通知

Alertmanager提供了方式可以帮助用户控制告警通知的行为，包括预先定义的抑制机制和临时定义的静默规则。

## 抑制机制

Alertmanager的抑制机制可以避免当某种问题告警产生之后用户接收到大量由此问题导致的一系列的其它告警通知。例如当集群不可用时，用户可能只希望接收到一条告警，告诉他这时候集群出现了问题，而不是大量的如集群中的应用异常、中间件服务异常的告警通知。

在Alertmanager配置文件中，使用inhibit_rules定义一组告警的抑制规则：

```
inhibit_rules:
  [ - <inhibit_rule> ... ]
```

每一条抑制规则的具体配置如下：

```
target_match:
  [ <labelname>: <labelvalue>, ... ]
target_match_re:
  [ <labelname>: <regex>, ... ]

source_match:
  [ <labelname>: <labelvalue>, ... ]
source_match_re:
  [ <labelname>: <regex>, ... ]

[ equal: '[' <labelname>, ... ']' ]
```

当已经发送的告警通知匹配到target_match和target_match_re规则，当有新的告警规则如果满足source_match或者定义的匹配规则，并且已发送的告警与新产生的告警中equal定义的标签完全相同，则启动抑制机制，新的告警不会发送。

例如，定义如下抑制规则：

```
- source_match:
    alertname: NodeDown
    severity: critical
  target_match:
    severity: critical
  equal:
    - node
```

例如当集群中的某一个主机节点异常宕机导致告警NodeDown被触发，同时在告警规则中定义了告警级别severity=critical。由于主机异常宕机，该主机上部署的所有服务，中间件会不可用并触发报警。根据抑制规则的定义，如果有新的告警级别为severity=critical，并且告警中标签node的值与NodeDown告警的相同，则说明新的告警是由NodeDown导致的，则启动抑制机制停止向接收器发送通知。

## 临时静默

除了基于抑制机制可以控制告警通知的行为以外，用户或者管理员还可以直接通过Alertmanager的UI临时屏蔽特定的告警通知。通过定义标签的匹配规则(字符串或者正则表达式)，如果新的告警通知满足静默规则的设置，则停止向receiver发送通知。

进入Alertmanager UI，点击"New Silence"显示如下内容：

![创建静默规则](https://www.prometheus.wang/alert/static/alertmanager-new-slicense.png)创建静默规则

用户可以通过该UI定义新的静默规则的开始时间以及持续时间，通过Matchers部分可以设置多条匹配规则(字符串匹配或者正则匹配)。填写当前静默规则的创建者以及创建原因后，点击"Create"按钮即可。

通过"Preview Alerts"可以查看预览当前匹配规则匹配到的告警信息。静默规则创建成功后，Alertmanager会开始加载该规则并且设置状态为Pending,当规则生效后则进行到Active状态。

![活动的静默规则](https://www.prometheus.wang/alert/static/alertmanager-active-silences.png)活动的静默规则

当静默规则生效以后，从Alertmanager的Alerts页面下用户将不会看到该规则匹配到的告警信息。

![告警信息](https://www.prometheus.wang/alert/static/alertmanager-slicense-alerts-result.png)告警信息

对于已经生效的规则，用户可以通过手动点击”Expire“按钮使当前规则过期。

# 使用Recoding Rules优化性能

通过PromQL可以实时对Prometheus中采集到的样本数据进行查询，聚合以及其它各种运算操作。而在某些PromQL较为复杂且计算量较大时，直接使用PromQL可能会导致Prometheus响应超时的情况。这时需要一种能够类似于后台批处理的机制能够在后台完成这些复杂运算的计算，对于使用者而言只需要查询这些运算结果即可。Prometheus通过Recoding Rule规则支持这种后台计算的方式，可以实现对复杂查询的性能优化，提高查询效率。

## 定义Recoding rules

在Prometheus配置文件中，通过rule_files定义recoding rule规则文件的访问路径。

```
rule_files:
  [ - <filepath_glob> ... ]
```

每一个规则文件通过以下格式进行定义：

```
groups:
  [ - <rule_group> ]
```

一个简单的规则文件可能是这个样子的：

```
groups:
  - name: example
    rules:
    - record: job:http_inprogress_requests:sum
      expr: sum(http_inprogress_requests) by (job)
```

rule_group的具体配置项如下所示：

```
# The name of the group. Must be unique within a file.
name: <string>

# How often rules in the group are evaluated.
[ interval: <duration> | default = global.evaluation_interval ]

rules:
  [ - <rule> ... ]
```

与告警规则一致，一个group下可以包含多条规则rule。

```
# The name of the time series to output to. Must be a valid metric name.
record: <string>

# The PromQL expression to evaluate. Every evaluation cycle this is
# evaluated at the current time, and the result recorded as a new set of
# time series with the metric name as given by 'record'.
expr: <string>

# Labels to add or overwrite before storing the result.
labels:
  [ <labelname>: <labelvalue> ]
```

根据规则中的定义，Prometheus会在后台完成expr中定义的PromQL表达式计算，并且将计算结果保存到新的时间序列record中。同时还可以通过labels为这些样本添加额外的标签。

这些规则文件的计算频率与告警规则计算频率一致，都通过global.evaluation_interval定义:

```
global:
  [ evaluation_interval: <duration> | default = 1m ]
```

# 小结

当故障发生时，即时获取到异常结果是大多数用户使用监控系统的最主要的目的之一。通过Prometheus提供的告警以及告警处理能力，通过内置的告警通知能力，能过帮助用户快速实现告警的通知。同时其还提供了简单有效的扩展方式，让用户可以基于Prometheus的告警处理模式实现更多的定制化需求。 

# 第5章 可视化一切

"You can't fix what you can't  see"。可视化是监控的核心目标之一，在本章中我们将介绍Prometheus下的可视化技术。例如，Prometheus自身提供的Console  Template能力以及Grafana这一可视化工具实现监控数据可视化。Prometheus  UI提供了基本的数据可视化能力，可以帮助用户直接使用PromQL查询数据，并将数据通过可视化图表的方式进行展示，而实际的应用场景中往往不同的人对于可视化的需求不一样，关注的指标也不一样，因此我们需要能够有能力，构建出不同的可视化报表页面。 本章学习的内容就主要解决以上问题。

本章的主要内容：

- 使用Console Template创建可视化页面
- 使用Grafana创建更精美的数据仪表盘 

# 使用Console Template

在第1章以及第2章的内容中，读者已经对Prometheus已经有了一个相对完成的认识，并且我们已经学习了如何通过PromQL对时间序列数据进行查询和分析，并且通过Prometheus中的Graph面板查询数据形成图表。但是缺点也很明显，这些查询结果都是临时的，无法持久化的，更别说我们想实时关注某些特定监控指标的变化趋势。

为了简化这些问题Prometheus内置了一个简单的解决方案`Console Template`,它允许用户通过Go模板语言创建任意的控制台界面，并且通过Prometheus Server对外提供访问路径。

## 快速开始

首先我们先从一个小例子开始，创建我们的第一个Console Template页面。与Console Template有关的两个启动参数为`--web.console.libraries`和`--web.console.templates`,其分别指定页面组件以及页面的存储路径。默认情况下其分别指向Prometheus当前安装路径的`console_libraries`和`consoles`目录。

Prometheus在`console_libraries`目录中已经内置了一些基本的界面组件，用户可以直接使用。

在`consoles`目录下创建index.html文件后，刷新Prometheus界面可以看到在顶部菜单中多了一个Consoles菜单项，如下所示。该选项默认指向`consoles/index.html`文件：

![Consoles菜单](https://www.prometheus.wang/grafana/static/consoles_index.png)Consoles菜单

当然，这个时候点击该菜单，我们会看到一个空白页。因为目前index.html文件中还未填充任何内容：

## 定义页面菜单

首先，我们先直接使用console_libraries中定义的`head`组件，并加入到index.html文件中：

```
{{template "head" .}}
```

此时，如果我们刷新浏览器可以看到以下内容：

![默认的Head组件](https://www.prometheus.wang/grafana/static/head.png)默认的Head组件

`head`组件的定义，读者可以通过关键字`define "head"`在console_libraries目录中查找。默认其应该是定义在`prom.lib`文件中：

```go
{{ define "head" }}
<html>
<head>
{{ template "prom_console_head" }}
</head>
<body>
{{ template "navbar" . }}
{{ end }}
```

如果需要定制化菜单的内容，那一样的读者只需要找到`navbar`组件的定义即可。当然用户也可以创建自己的组件。 例如，如果我们希望Console Template页面的菜单与Prometheus UI一致，只需要修改navbar组件的定义即可，找到`menu.lib`并修改navbar组件:

```
{{ define "navbar" }}
<nav class="navbar navbar-inverse navbar-static-top">
  <div class="container-fluid">
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="{{ pathPrefix }}/">Prometheus</a>
    </div>

    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
      <ul class="nav navbar-nav">
        <li><a href="{{ pathPrefix }}/alerts">Alerts</a></li>
        <li><a href="{{ pathPrefix }}/graph">Graph</a></li>
      </div>
    </ul>
  </div>
</nav>
{{ end }}
```

如果不需要侧边菜单栏，直接在head组件中移除`{{ template "menu" . }}`部分即可，修改后刷新页面，如下所示：

![自定义菜单](https://www.prometheus.wang/grafana/static/custom_index_head.png)自定义菜单

无论是`.lib`文件还是`.html`文件均使用了Go Template的语言，感兴趣的读者可以自行在Go语言官网了解更多内容`https://golang.org/pkg/text/template/`

## 定义图表

在Console Template中我们可以在页面中使用内置的`PromConsole.Graph()`函数，该函数通过`head`加载相应的js源码，在该函数中，通过指定特定的DOM节点以及相应的PromQL表达式，即可在特定区域图形化显示相应的图表内容，如下所示：

```
<h1>Prometheus HTTP Request Rate</h1>

<h3>Queries</h3>
<div id="queryGraph"></div>
<script>
new PromConsole.Graph({
  node: document.querySelector("#queryGraph"),
  expr: "sum(rate(prometheus_http_request_duration_seconds_count{job='prometheus'}[5m]))",
  name: "Queries",
  yAxisFormatter: PromConsole.NumberFormatter.humanizeNoSmallPrefix,
  yHoverFormatter: PromConsole.NumberFormatter.humanizeNoSmallPrefix,
  yUnits: "/s",
  yTitle: "Queries"
})
</script>
```

这里创建了一个id为queryGraph的div节点，通过在页面中使用PromConsole.Graph函数，我们可以绘制出表达式`sum(rate(prometheus_http_request_duration_seconds_count{job='prometheus'}[5m]))`的可视化图表如下所示：

![img](https://www.prometheus.wang/grafana/static/query_graph.png)

除了最基本的node以及expr参数以外，该函数还支持的完整参数如下：

| 参数名称        | 作用                                                         |
| --------------- | ------------------------------------------------------------ |
| expr            | Required. Expression to graph. Can be a list.                |
| node            | Required. DOM node to render into.                           |
| duration        | Optional. Duration of the graph. Defaults to 1 hour.         |
| endTime         | Optional. Unixtime the graph ends at. Defaults to now.       |
| width           | Optional. Width of the graph, excluding titles. Defaults to auto-detection. |
| height          | Optional. Height of the graph, excluding titles and legends. Defaults to 200 pixels. |
| min             | Optional. Minimum x-axis value. Defaults to lowest data value. |
| max             | Optional. Maximum y-axis value. Defaults to highest data value. |
| renderer        | Optional. Type of graph. Options are line and area (stacked graph). Defaults to line. |
| name            | Optional. Title of plots in legend and hover detail. If passed a  string, [[ label ]] will be substituted with the label value. If passed a function, it will be passed a map of labels and should return the name  as a string. Can be a list. |
| xTitle          | Optional. Title of the x-axis. Defaults to Time.             |
| yUnits          | Optional. Units of the y-axis. Defaults to empty.            |
| yTitle          | Optional. Title of the y-axis. Defaults to empty.            |
| yAxisFormatter  | Optional. Number formatter for the y-axis. Defaults to PromConsole.NumberFormatter.humanize. |
| yHoverFormatter | Optional. Number formatter for the hover detail. Defaults to PromConsole.NumberFormatter.humanizeExact. |
| colorScheme     | Optional. Color scheme to be used by the plots. Can be either a list of hex color codes or one of the color scheme names supported by  Rickshaw. Defaults to 'colorwheel'. |

需要注意的是，如果参数`expr`和`name`均是list类型，其必须是一一对应的。

除了直接使用`PromConsole.Graph`函数显示可视化图表以外，在Console Template中还可以使用模板组件`prom_query_drilldown`定义一个连接直接跳转到Graph页面，并显示相应表达式的查询结果， 如下所示：

```
<h3>Links</h3>
{{ template "prom_query_drilldown" (args "prometheus_http_response_size_bytes_bucket") }}
```

除了以上部分以外，我们也可以和原生Prometheus UI一样定义一个时间轴控制器，方便用户按需查询数据：

![img](https://www.prometheus.wang/grafana/static/prom_graph_timecontrol.png)

加入这个时间轴控制器的方式也很简单，直接引用以下模板即可：

```
{{ template "prom_graph_timecontrol" . }}
```

# Grafana简介

Console  Teamplet虽然能满足一定的可视化需求，但是也仅仅是对Prometheus的基本能力的补充。同时使用也会有许多问题，首先用户需要学习和了解Go  Template模板语言，其它其支持的可视化图表类型也非常有限，最后其管理也有一定的成本。在第1章的“初识Prometheus”中我们已经尝试通过Grafana快速搭建过一个主机监控的Dashboard，在本章中将会带来读者学习如何使用Grafana创建更加精美的可视化报表。

## Grafana基本概念

首先Grafana是一个通用的可视化工具。‘通用’意味着Grafana不仅仅适用于展示Prometheus下的监控数据，也同样适用于一些其他的数据可视化需求。在开始使用Grafana之前，我们首先需要明确一些Grafana下的基本概念，以帮助用户能够快速理解Grafana。

### 数据源（Data Source）

对于Grafana而言，Prometheus这类为其提供数据的对象均称为数据源（Data  Source）。目前，Grafana官方提供了对：Graphite, InfluxDB, OpenTSDB, Prometheus,  Elasticsearch,  CloudWatch的支持。对于Grafana管理员而言，只需要将这些对象以数据源的形式添加到Grafana中，Grafana便可以轻松的实现对这些数据的可视化工作。

### 仪表盘（Dashboard）

通过数据源定义好可视化的数据来源之后，对于用户而言最重要的事情就是实现数据的可视化。在Grafana中，我们通过Dashboard来组织和管理我们的数据可视化图表：

![Grafana Dashboard](https://www.prometheus.wang/grafana/static/dashboard-components.png)Grafana Dashboard

如上所示，在一个Dashboard中一个最基本的可视化单元为一个**Panel（面板）**，Panel通过如趋势图，热力图的形式展示可视化数据。 并且在Dashboard中每一个Panel是一个完全独立的部分，通过Panel的**Query Editor（查询编辑器）**我们可以为每一个Panel自己查询的数据源以及数据查询方式，例如，如果以Prometheus作为数据源，那在Query  Editor中，我们实际上使用的是PromQL，而Panel则会负责从特定的Prometheus中查询出相应的数据，并且将其可视化。由于每个Panel是完全独立的，因此在一个Dashboard中，往往可能会包含来自多个Data Source的数据。

Grafana通过插件的形式提供了多种Panel的实现，常用的如：Graph Panel，Heatmap Panel，SingleStat Panel以及Table Panel等。用户还可通过插件安装更多类型的Panel面板。

除了Panel以外，在Dashboard页面中，我们还可以定义一个**Row（行）**，来组织和管理一组相关的Panel。

除了Panel, Row这些对象以外，Grafana还允许用户为Dashboard定义**Templating variables（模板参数）**，从而实现可以与用户动态交互的Dashboard页面。同时Grafana通过JSON数据结构管理了整个Dasboard的定义，因此这些Dashboard也是非常方便进行共享的。Grafana还专门为Dashboard提供了一个共享服务：https://grafana.com/dashboards，通过该服务用户可以轻松实现Dashboard的共享，同时我们也能快速的从中找到我们希望的Dashboard实现，并导入到自己的Grafana中。

### 组织和用户

作为一个通用可视化工具，Grafana除了提供灵活的可视化定制能力以外，还提供了面向企业的组织级管理能力。在Grafana中Dashboard是属于一个**Organization（组织）**，通过Organization，可以在更大规模上使用Grafana，例如对于一个企业而言，我们可以创建多个Organization，其中**User（用户）**可以属于一个或多个不同的Organization。 并且在不同的Organization下，可以为User赋予不同的权限。 从而可以有效的根据企业的组织架构定义整个管理模型。 

# Grafana与数据可视化

在第1章的“初始Prometheus”部分，我们已经带领读者大致了解了Grafana的基本使用方式。对于Grafana而言，Prometheus就是一个用于存储监控样本数据的数据源（Data Source）通过使用PromQL查询特定Prometheus实例中的数据并且在Panel中实现可视化。

接下来，我们将带领读者了解如何通过Panel创建精美的可视化图表。

## 认识面板（Panel）

Panel是Grafana中最基本的可视化单元。每一种类型的面板都提供了相应的查询编辑器(Query Editor)，让用户可以从不同的数据源（如Prometheus）中查询出相应的监控数据，并且以可视化的方式展现。

Grafana中所有的面板均以插件的形式进行使用，当前内置了5种类型的面板，分别是：Graph，Singlestat，Heatmap, Dashlist，Table以及Text。

其中像Graph这样的面板允许用户可视化任意多个监控指标以及多条时间序列。而Siglestat则必须要求查询结果为单个样本。Dashlist和Text相对比较特殊，它们与特定的数据源无关。

通过Grafana UI用户可以在一个Dashboard下添加Panel，点击Dashboard右上角的“Add Panel”按钮，如下所示，将会显示当前系统中所有可使用的Panel类型：

![添加Panel](https://www.prometheus.wang/grafana/static/grafana_dashboard_add_panel.png)添加Panel

选择想要创建的面板类型即可。这里以Graph面板为例，创建Panel之后，并切换到编辑模式，就可以进入Panel的配置页面。对于一个Panel而言，一般来说会包含2个主要的配置选项：General（通用设置）、Metrics（度量指标）。其余的配置则根据Panel类型的不同而不同。

在通用设置中，除了一些Panel的基本信息以外，最主要的能力就是定义动态Panel的能力，这部分内容会在本章的“模板化Dashboard”小结中详细介绍。

对于使用Prometheus作为数据源的用户，最主要的需要了解的就是Metrics设置的使用。在Metric选项中可以定义了Grafana从哪些数据源中查询样本数据。**Data Source**中指定当前查询的数据源，Grafana会加载当前组织中添加的所有数据源。其中还会包含两个特殊的数据源：**Mixed**和**Grafana**。 Mixed用于需要从多个数据源中查询和渲染数据的场景，Grafana则用于需要查询Grafana自身状态时使用。

当选中数据源时，Panel会根据当前数据源类型加载不同的Query Editor界面。这里我们主要介绍Prometheus Query Editor，如下所示，当选中的数据源类型为Prometheus时，会显示如下界面：

![Query Editor](https://www.prometheus.wang/grafana/static/graph_prometheus_query_editor.png)Query Editor

Grafana提供了对PromQL的完整支持，在Query Editor中，可以添加任意个Query，并且使用PromQL表达式从Prometheus中查询相应的样本数据。

```
avg (irate(node_cpu{mode!='idle'}[2m])) without (cpu)
```

每个PromQL表达式都可能返回多条时间序列。**Legend format**用于控制如何格式化每条时间序列的图例信息。Grafana支持通过模板的方式，根据时间序列的标签动态生成图例名称，例如：使用表示使用当前时间序列中的instance标签的值作为图例名称：

```
{{instance}}-{{mode}}
```

当查询到的样本数据量非常大时可以导致Grafana渲染图标时出现一些性能问题，通过**Min Step**可以控制Prometheus查询数据时的最小步长（Step），从而减少从Prometheus返回的数据量。

**Resolution**选项，则可以控制Grafana自身渲染的数据量。例如，如果**Resolution**的值为**1/10**，Grafana会将Prometeus返回的10个样本数据合并成一个点。因此**Resolution**越小可视化的精确性越高，反之，可视化的精度越低。

**Format as**选项定义如何格式化Prometheus返回的样本数据。这里提供了3个选项：Table,Time Series和Heatmap，分别用于Tabel面板，Graph面板和Heatmap面板的数据可视化。

除此以外，Query Editor还提供了调试相关的功能，点击**Query Inspector**可以展开相关的调试面板：

![调试面板](https://www.prometheus.wang/grafana/static/grafana_query_editor_inspector.png)调试面板

在面板中，可以查看当前Prometheus返回的样本数据，用户也可以提供Mock数据渲染图像。 

# 变化趋势：Graph面板

Graph面板是最常用的一种可视化面板，其通过折线图或者柱状图的形式显示监控样本随时间而变化的趋势。Graph面板天生适用于Prometheus中Gauge和Counter类型监控指标的监控数据可视化。例如，当需要查看主机CPU、内存使用率的随时间变化的情况时，可以使用Graph面板。同时，Graph还可以非常方便的支持多个数据之间的对比。

![Graph面板](https://www.prometheus.wang/grafana/static/grafana_graph_panel.png)Graph面板

## Graph面板与Prometheus

Graph面板通过折线图或者柱状图的形式，能够展示监控样本数据在一段时间内的变化趋势，因此其天生适合Prometheus中的Counter和Gauge类型的监控指标的可视化，对于Histogram类型的指标也可以支持，不过可视化效果不如Heatmap Panel来的直观。

### 使用Graph面板可视化Counter/Gauge

以主机为例，CPU使用率的变化趋势天然适用于使用Grapn面板来进行展示：

![Prometheus Counter可视化](https://www.prometheus.wang/grafana/static/grafana_graph_counter_demo_v2.png)Prometheus Counter可视化

在**Metrics选项**中，我们使用以下PromQL定义如何从Prometheus中读取数据：

```
1 - (avg(irate(node_cpu{mode='idle'}[5m])) without (cpu))
```

如下所示：

![Metrics选项](https://www.prometheus.wang/grafana/static/grafana_graph_counter_demo_metrics.png)Metrics选项

根据当前Prometheus的数据采集情况，该PromQL会返回多条时间序列（在示例中会返回3条）。Graph面板会从时间序列中获取样本数据，并绘制到图表中。 为了让折线图有更好的可读性，我们可以通过定义**Legend format**为`{{ instance }}`控制每条线的图例名称：

![使用Legend format模板化图例](https://www.prometheus.wang/grafana/static/grafana_graph_counter_demo_metrics_legend.png)使用Legend format模板化图例

由于当前使用的PromQL的数据范围为0~1表示CPU的使用率，为了能够更有效的表达出度量单位的概念，我们需要对Graph图表的坐标轴显示进行优化。如下所示，在**Axes选项**中可以控制图标的X轴和Y轴相关的行为：

![Axes选项](https://www.prometheus.wang/grafana/static/grafana_graph_counter_demo_axes.png)Axes选项

默认情况下，Y轴会直接显示当前样本的值，通过**Left Y**的**Unit**可以让Graph面板自动格式化样本值。当前表达式返回的当前主机CPU使用率的小数表示，因此，这里选择单位为**percent(0.0.-1.0)**。除了百分比以外，Graph面板支持如日期、货币、重量、面积等各种类型单位的自动换算，用户根据自己当前样本的值含义选择即可。

除了在Metrics设置图例的显示名称以外，在Graph面板的**Legend选项**可以进一步控制图例的显示方式，如下所示：

![Legend选项](https://www.prometheus.wang/grafana/static/grafana_graph_counter_demo_legend.png)Legend选项

**Options中**可以设置图例的显示方式以及展示位置，**Values**中可以设置是否显示当前时间序列的最小值，平均值等。 **Decimals**用于配置这些值显示时保留的小数位，如下所示：

![Legend控制图例的显示示例](https://www.prometheus.wang/grafana/static/grafana_graph_counter_demo_legend_sample.png)Legend控制图例的显示示例

除了以上设置以外，我们可能还需要对图表进行一些更高级的定制化，以便能够更直观的从可视化图表中获取信息。在Graph面板中**Display选项**可以帮助我们实现更多的可视化定制的能力，其中包含三个部分：Draw options、Series overrides和Thresholds。

![Display选项](https://www.prometheus.wang/grafana/static/grafana_graph_counter_demo_display_draw.png)Display选项

**Draw Options**用于设置当前图标的展示形式、样式以及交互提示行为。其中，Draw  Modes用于控制图形展示形式：Bar（柱状）、Lines（线条）、Points（点），用户可以根据自己的需求同时启用多种模式。Mode  Options则设置各个展示模式下的相关样式。Hover tooltip用于控制当鼠标移动到图形时，显示提示框中的内容。

如果希望当前图表中的时间序列以不同的形式展示，则可以通过**Series overrides**控制，顾名思义，可以为指定的时间序列指定自定义的Draw Options配置，从而让其以不同的样式展示。例如：

![Series overrides](https://www.prometheus.wang/grafana/static/grafana_series_overrides.png)Series overrides

这里定义了一条自定义规则，其匹配图例名称满足**/localhost/**的时间序列，并定义其以点的形式显示在图表中，修改后的图标显示效果如下：

![Series overrides效果](https://www.prometheus.wang/grafana/static/grafana_series_overrides_demo.png)Series overrides效果

Display选项中的最后一个是**Thresholds**，Threshold主要用于一些自定义一些样本的阈值，例如，定义一个Threshold规则，如果CPU超过50%的区域显示为warning状态，可以添加如下配置：

![Threshold设置](https://www.prometheus.wang/grafana/static/grafana_thresholds_demo.png)Threshold设置

Graph面板则会在图表中显示一条阈值，并且将所有高于该阈值的区域显示为warining状态，通过可视化的方式直观的在图表中显示一些可能出现异常的区域。

需要注意的是，如果用户为该图表自定义了Alert（告警）配置，Thresholds将会被警用，并且根据Alert中定义的Threshold在图形中显示阈值内容。关于Alert的使用会在后续部分，详细介绍。

### 使用Graph面板可视化Histogram

以Prometheus自身的监控指标prometheus_tsdb_compaction_duration为例，该监控指标记录了Prometheus进行数据压缩任务的运行耗时的分布统计情况。如下所示，是Prometheus返回的样本数据：

```
# HELP prometheus_tsdb_compaction_duration Duration of compaction runs.
# TYPE prometheus_tsdb_compaction_duration histogram
prometheus_tsdb_compaction_duration_bucket{le="1"} 2
prometheus_tsdb_compaction_duration_bucket{le="2"} 36
prometheus_tsdb_compaction_duration_bucket{le="4"} 36
prometheus_tsdb_compaction_duration_bucket{le="8"} 36
prometheus_tsdb_compaction_duration_bucket{le="16"} 36
prometheus_tsdb_compaction_duration_bucket{le="32"} 36
prometheus_tsdb_compaction_duration_bucket{le="64"} 36
prometheus_tsdb_compaction_duration_bucket{le="128"} 36
prometheus_tsdb_compaction_duration_bucket{le="256"} 36
prometheus_tsdb_compaction_duration_bucket{le="512"} 36
prometheus_tsdb_compaction_duration_bucket{le="+Inf"} 36
prometheus_tsdb_compaction_duration_sum 51.31017077500001
prometheus_tsdb_compaction_duration_count 36
```

在第2章的“Metric类型”小节中，我们已经介绍过Histogram的指标，Histogram用于统计样本数据的分布情况，其中标签le定义了分布桶Bucket的边界，如上所示，表示当前Prometheus共进行了36次数据压缩，总耗时为51.31017077500001ms。其中任务耗时在0~1ms区间内的为2次、在0~2ms区间范围内为36次，以此类推。

如下所示，如果需要在Graph中显示Histogram类型的监控指标，需要在Query Editor中定义查询结果的**Format as**为Heatmap。通过该设置Grafana会自动计算Histogram中的Bucket边界范围以及该范围内的值：

![Metrics设置](https://www.prometheus.wang/grafana/static/grafana_bucket_setting.png)Metrics设置

Graph面板重新计算了Bucket边界，如下所示，在0~1ms范围内的任务次数为2，在1~2ms范围内的运行任务次数为34。通过图形的面积，可以反映出各个Bucket下的大致数据分布情况：

![Histogram数据可视化](https://www.prometheus.wang/grafana/static/grafana_bucket_demo.png)Histogram数据可视化

不过通过Graph面板展示Histogram也并不太直观，其并不能直接反映出Bucket的大小以及分布情况，因此在Grafana  V5版本以后更推荐使用Heatmap面板的方式展示Histogram样本数据。关于Heatmap面板的使用将会在接下来的部分介绍。

# 分布统计：Heatmap面板

Heatmap是是Grafana v4.3版本以后新添加的可视化面板，通过热图可以直观的查看样本的分布情况。在Grafana  v5.1版本中Heatmap完善了对Prometheus的支持。这部分，将介绍如何使用Heatmap  Panel实现对Prometheus监控指标的可视化。

## 使用Heatmap可视化Histogram样本分布情况

在上一小节中，我们尝试了使用Graph面板来可视化Histogram类型的监控指标prometheus_tsdb_compaction_duration_bucket。虽然能展示各个Bucket区间内的样本分布，但是无论是以线图还是柱状图的形式展示，都不够直观。对于Histogram类型的监控指标来说，更好的选择是采用Heatmap Panel，如下所示，Heatmap  Panel可以自动对Histogram类型的监控指标分布情况进行计划，获取到每个区间范围内的样本个数，并且以颜色的深浅来表示当前区间内样本个数的大小。而图形的高度，则反映出当前时间点，样本分布的离散程度。

![Heatmap示例](https://www.prometheus.wang/grafana/static/grafana_heatmap_sample.png)Heatmap示例

在Grafana中使用Heatmap Panel也非常简单，在Dashboard页面右上角菜单中点击“add panel”按钮，并选择Heatmap Panel即可。

如下所示，Heapmap Panel的编辑页面中，主要包含5类配置选项，分别是：General、Metrics、Axes、Display、Time range。

![Heapmap Panel编辑页面](https://www.prometheus.wang/grafana/static/grafana_heatmap_editor.png)Heapmap Panel编辑页面

其中大部分的配置选项与Graph面板基本保持一致，这里就不重复介绍了。

当使用Heatmap可视化Histogram类型的监控指标时，需要设置**Format as**选项为**Heatmap**。当使用Heatmap格式化数据后，Grafana会自动根据样本的中的le标签，计算各个Bucket桶内的分布，并且按照Bucket对数据进行重新排序。**Legend format**模板则将会控制Y轴中的显示内容。如下所示：

![Mteircs设置](https://www.prometheus.wang/grafana/static/grafana_heatmap_metrics_setting.png)Mteircs设置

默认情况下，Heatmap Panel会自行对PromQL查询出的数据进行分布情况统计，而在Prometheus中Histogram类型的监控指标其实是已经自带了分布的Bucket信息的，因此为了直接使用这些Bucket信息，我们需要在**Axes选项**中定义数据的Date format需要定义为**Time series buckets**。该选项表示Heatmap Panel不需要自身对数据的分布情况进行计算，直接使用时间序列中返回的Bucket即可。如下所示：

![Axes设置](https://www.prometheus.wang/grafana/static/grafana_heatmap_axes_setting.png)Axes设置

通过以上设置，即可实现对Histogram类型监控指标的可视化。

## 使用Heatmap可视化其它类型样本分布情况

对于非Histogram类型，由于其监控样本中并不包含Bucket相关信息，因此在**Metrics选项中**需要定义**Format as**为**Time series**，如下所示：

![Metrics设置](https://www.prometheus.wang/grafana/static/grafana_heatmap_normal_metrics.png)Metrics设置

并且通过**Axes选项**中选择**Data format**方式为**Time series**。设置该选项后Heatmap Panel会要求用户提供Bucket分布范围的设置，如下所示：

![Axes设置](https://www.prometheus.wang/grafana/static/grafana_heatmap_normal_axes.png)Axes设置

在Y轴（Y  Axis）中需要通过Scale定义Bucket桶的分布范围，默认的Bucket范围支持包括：liner（线性分布）、log(base  10)（10的对数）、log(base 32)（32的对数）、log(base 1024)（1024的对数）等。

例如，上图中设置的Scale为log(base 2)，那么在Bucket范围将2的对数的形式进行分布，即[1,2,4,8,....]，如下所示：

![Bucket分布情况](https://www.prometheus.wang/grafana/static/grafana_heatmap_normal_sample.png)Bucket分布情况

通过以上设置，Heatmap会自动根据用户定义的Bucket范围对Prometheus中查询到的样本数据进行分布统计。 

# 当前状态：SingleStat面板

Singlem Panel侧重于展示系统的当前状态而非变化趋势。如下所示，在以下场景中特别适用于使用SingleStat：

- 当前系统中所有服务的运行状态；
- 当前基础设施资源的使用量；
- 当前系统中某些事件发生的次数或者资源数量等。

如下所示，是使用SingleStat进行数据可视化的显示效果：

![SingleStat Panel示例](https://www.prometheus.wang/grafana/static/grafana_singlestat_sample.png)SingleStat Panel示例

## 使用SingleStat Panel

从Dashboardc创建Singlestat Panel，并进入编辑页面， 如下所示：

![SingleStat 编辑页面](https://www.prometheus.wang/grafana/static/grafana_single_stat_sample.png)SingleStat 编辑页面

对于SingleStat Panel而言，其只能处理一条时间序列，否则页面中会提示“Multiple Series Error”错误信息。这里使用如下PromQL查询当前主机负载：

```
node_load1{instance="localhost:9100"}
```

默认情况下，当前面板中会显示当前时间序列中所有样本的平均值，而实际情况下，我们需要显示的是当前主机当前的负载情况，因此需要通过SingleStat Panel的**Options**选项控制当前面板的显示模式：

![SingleStat Option选项](https://www.prometheus.wang/grafana/static/grafana_single_stat_edit_options.png)SingleStat Option选项

如上所示，通过Value配置项组可以控制当前面板中显示的值，以及字体大小等。对于主机负载而言，我们希望能够显示当前的最新值，因此修改Stat为**Current**即可。

如果希望面板能够根据不同的值显示不同的颜色的话，则可以定义**Thresholds**与**Colors**的映射关系，例如，定义Thresholds的分割区间值为“0,1”，则当Value的值落到不同的范围内时，将显示不同的颜色。

如果希望能够显示当前时间序列的样本值变化情况，则可以启用Spark lines配置。启用之后，Singlestat面板中除了会显示当前的最新样本值以外，也会同时将时间序列中的数据已趋势图的形式进行展示。

除了通过数字大小反应当前状态以外，在某些场景下我们可能更关心的是这些数字表示的意义。例如，在Promthues监控服务的健康状态时，在样本数据中会通过0表示不健康，1表示健康。 但是如果直接将0或1显示在面板中，那么可视化效果将缺乏一定的可读性。

为了提升数字的可读性，可以在Singlestat Panel中可以通过**Value Mappings**定义值的映射关系。Siglesta支持值映射（value to text）和区间映射（range to text）两种方式。 如下所示：

![Singlestat value mappings配置](https://www.prometheus.wang/grafana/static/grafana_single_stat_edit_value_mapping.png)Singlestat value mappings配置

当面板中Value的值在0~0.99范围内则显示为Health，否则显示为Unhealth。这种模式特别适合于展示服务的健康状态。 当然你也可以将Value映射为任意的字符，甚至是直接使用Emoji(http://www.iemoji.com/)表情：

![在Singlestat中使用Emoji表情字符](https://www.prometheus.wang/grafana/static/grafana_single_stat_edit_value_mapping_emoji.png) 

# 模板化Dashboard

在前面的小节中介绍了Grafana中4中常用的可视化面板的使用，通过在面板中使用PromQL表达式，Grafana能够方便的将Prometheus返回的数据进行可视化展示。例如，在展示主机CPU使用率时，我们使用了如下表达式：

```
1 - (avg(irate(node_cpu{mode='idle'}[5m])) without (cpu))
```

该表达式会返回当前Promthues中存储的所有时间序列，每一台主机都会有一条单独的曲线用于体现其CPU使用率的变化情况：

![主机CPU使用率](https://www.prometheus.wang/grafana/static/grafana_templating_variables_example.png)主机CPU使用率

而当用户只想关注其中某些主机时，基于当前我们已经学习到的知识只有两种方式，要么每次手动修改Panel中的PromQL表达式，要么直接为这些主机创建单独的Panel。但是无论如何，这些硬编码方式都会直接导致Dashboard配置的频繁修改。在这一小节中我们将学习使用Dashboard变量的方式解决以上问题。

## 变量

在Grafana中用户可以为Dashboard定义一组变量（Variables），变量一般包含一个到多个可选值。如下所示，Grafana通过将变量渲染为一个下拉框选项，从而使用户可以动态的改变变量的值：

![Dashboard变量](https://www.prometheus.wang/grafana/static/grafana_templating_variables_example1.png)Dashboard变量

例如，这里定义了一个名为node的变量，用户可以通过在PromQL表达式或者Panel的标题中通过以下形式使用该变量：

```
1 - (avg(irate(node_cpu{mode='idle', instance=~"$node"}[5m])) without (cpu))
```

变量的值可以支持单选或者多选，当对接Prometheus时，Grafana会自动将$node的值格式化为如“**host1|host2|host3**”的形式。配合使用PromQL的标签正则匹配“**=~**”，通过动态改变PromQL从而实现基于标签快速对时间序列进行过滤。

## 变量定义

通过Dashboard页面的Settings选项，可以进入Dashboard的配置页面并且选择Variables子菜单:

![为Dashboard添加变量](https://www.prometheus.wang/grafana/static/grafana_templating_add_variables.png)为Dashboard添加变量

用户需要指定变量的名称，后续用户就可以通过$variable_name的形式引用该变量。Grafana目前支持6种不同的变量类型，而能和Prometheus一起工作的主要包含以下5种类型：

| 类型       | 工作方式                                                     |
| ---------- | ------------------------------------------------------------ |
| Query      | 允许用户通过Datasource查询表达式的返回值动态生成变量的可选值 |
| Interval   | 该变量代表时间跨度，通过Interval类型的变量，可以动态改变PromQL区间向量表达式中的时间范围。如rate(node_cpu[2m]) |
| Datasource | 允许用户动态切换当前Dashboard的数据源，特别适用于同一个Dashboard展示多个数据源数据的情况 |
| Custom     | 用户直接通过手动的方式，定义变量的可选值                     |
| Constant   | 常量，在导入Dashboard时，会要求用户设置该常量的值            |

Label属性用于指定界面中变量的显示名称，Hide属性则用于指定在渲染界面时是否隐藏该变量的下拉框。

## 使用变量过滤时间序列

当Prometheus同时采集了多个主机节点的监控样本数据时，用户希望能够手动选择并查看其中特定主机的监控数据。这时我们需要使用Query类型的变量。

![新建Query类型的变量](https://www.prometheus.wang/grafana/static/grafana_templating_query_variables3.png)新建Query类型的变量

如上所示，这里我们为Dashboard创建了一个名为node的变量，并且指定其类型为Query。Query类型的变量，允许用户指定数据源以及查询表达式，并通过正则匹配（Regex）的方式对查询结果进行处理，从而动态生成变量的可选值。在这里指定了数据源为Prometheus，通过使用node_load1我们得到了两条时间序列：

```
node_load1{instance="foo:9100",job="node"}
node_load1{instance="localhost:9100",job="node"}
```

通过指定正则匹配表达式为`/.*instance="([^"]*).*/`从而匹配出标签instance的值作为node变量的所有可选项，即：

```
foo:9100
localhost:9100
```

**Selection Options**选项中可以指定该变量的下拉框是否支持多选，以及是否包含全选（All）选项。

保存变量后，用户可以在Panel的General或者Metrics中通过$node的方式使用该变量，如下所示：

![在Metrics中使用变量](https://www.prometheus.wang/grafana/static/grafana_templating_variables_filter.png)在Metrics中使用变量

这里需要注意的是，如果允许用户多选在PromQL表达式中应该使用标签的正则匹配模式，因为Grafana会自动将多个选项格式化为如“foo:9100|localhost:9100”的形式。

使用Query类型的变量能够根据允许用户能够根据时间序列的特征维度对数据进行过滤。在定义Query类型变量时，除了使用PromQL查询时间序列以过滤标签的方式以外，Grafana还提供了几个有用的函数：

| 函数                        | 作用                                                         |
| --------------------------- | ------------------------------------------------------------ |
| label_values(label)         | 返回Promthues所有监控指标中，标签名为label的所有可选值       |
| label_values(metric, label) | 返回Promthues所有监控指标metric中，标签名为label的所有可选值 |
| metrics(metric)             | 返回所有指标名称满足metric定义正则表达式的指标名称           |
| query_result(query)         | 返回prometheus查询语句的查询结果                             |

例如，当需要监控Prometheus所有采集任务的状态时，可以使用如下方式，获取当前所有采集任务的名称：

```
label_values(up, job)
```

例如，有时候我们想要动态修改变量查询结果。比如某一个节点绑定了多个ip，一个用于内网访问，一个用于外网访问，此时prometheus采集到的指标是内网的ip，但我们需要的是外网ip。这里我们想要能在Grafana中动态改变标签值，进行ip段的替换，而避免从prometheus或exporter中修改采集指标。

这时需要使用grafana的query_result函数

```
# 将10.10.15.xxx段的ip地址替换为10.20.15.xxx段 注：替换端口同理
query_result(label_replace(kube_pod_info{pod=~"$pod"}, "node", "10.20.15.$1", "node", "10.10.15.(.*)"))
# 通过正则从返回结果中匹配出所需要的ip地址
regex：/.*node="(.*?)".*/
```

在grafana中配置如图： ![Grafana中动态修改变量](https://www.prometheus.wang/grafana/static/grafana_templating_query_result.png)

## 使用变量动态创建Panel和Row

当在一个Panel中展示多条时间序列数据时，通过使用变量可以轻松实现对时间序列的过滤，提高用户交互性。除此以外，我们还可以使用变量自动生成Panel或者Row。  如下所示，当需要可视化当前系统中所有采集任务的监控任务运行状态时，由于Prometheus的采集任务配置可能随时发生变更，通过硬编码的形式实现，会导致Dashboard配置的频繁变更：

![Prometheus采集任务状态](https://www.prometheus.wang/grafana/static/grafana_templating_repeat_example1.png)Prometheus采集任务状态

如下所示，这里为Dashboard定义了一遍名为job的变量：

![使用变量获取当前所有可选任务](https://www.prometheus.wang/grafana/static/grafana_templating_repeat_var.png)使用变量获取当前所有可选任务

通过使用label_values函数，获取到当前Promthues监控指标up中所有可选的job标签的值：

```
label_values(up, job)
```

如果变量启用了Multi-value或者Include All Option选项的变量，那么在Panel的General选项的Repeat中可以选择自动迭代的变量，这里使用了Singlestat展示所有监控采集任务的状态：

![General中的Repeat选项](https://www.prometheus.wang/grafana/static/grafana_templating_repeat_e2.png)General中的Repeat选项

Repeat选项设置完成后，Grafana会根据当前用户的选择，自动创建一个到多个Panel实例。 为了能够使Singlestat  Panel能够展示正确的数据，如下所示，在Prometheus中，我们依然使用了$job变量，不过此时的$job反应的是当前迭代的值：

![在Metric中使用变量](https://www.prometheus.wang/grafana/static/grafana_templating_repeat_e3.png)在Metric中使用变量

而如果还希望能够自动生成Row，只需要在Row的设置中，选择需要Repeat的变量即可：

![Repeat Row](https://www.prometheus.wang/grafana/static/grafana_templating_repeat_row.png)Repeat Row

# 小结

"You can't fix what you can't  see"。可视化是监控的核心目标之一，在本章中我们学习了如何通过Prometheus内置的Console  Template实现基本的可视化能力，以及通过更专业的开源工具Grafana实现Prometheus的数据可视化。 

# 第6章 集群与高可用

Prometheus内置了一个基于本地存储的时间序列数据库。在Prometheus设计上，使用本地存储可以降低Prometheus部署和管理的复杂度同时减少高可用（HA）带来的复杂性。  在默认情况下，用户只需要部署多套Prometheus，采集相同的Targets即可实现基本的HA。同时由于Promethus高效的数据处理能力，单个Prometheus Server基本上能够应对大部分用户监控规模的需求。

当然本地存储也带来了一些不好的地方，首先就是数据持久化的问题，特别是在像Kubernetes这样的动态集群环境下，如果Promthues的实例被重新调度，那所有历史监控数据都会丢失。  其次本地存储也意味着Prometheus不适合保存大量历史数据(一般Prometheus推荐只保留几周或者几个月的数据)。最后本地存储也导致Prometheus无法进行弹性扩展。为了适应这方面的需求，Prometheus提供了remote_write和remote_read的特性，支持将数据存储到远端和从远端读取数据。通过将监控与数据分离，Prometheus能够更好地进行弹性扩展。

除了本地存储方面的问题，由于Prometheus基于Pull模型，当有大量的Target需要采样本时，单一Prometheus实例在数据抓取时可能会出现一些性能问题，联邦集群的特性可以让Prometheus将样本采集任务划分到不同的Prometheus实例中，并且通过一个统一的中心节点进行聚合，从而可以使Prometheuse可以根据规模进行扩展。

除了讨论Prometheus自身的高可用，Alertmanager作为Promthues体系中的告警处理中心，本章的最后部分会讨论如何实现Alertmanager的高可用部署。

本章的主要内容：

- Prometheus本地存储机制
- Prometheus的远程存储机制
- Prometheus联邦集群
- Prometheus高可用部署架构
- Alertmanager高可用部署架构

- # Prometheus数据存储

  ## 本地存储

  Prometheus 2.x  采用自定义的存储格式将样本数据保存在本地磁盘当中。如下所示，按照两个小时为一个时间窗口，将两小时内产生的数据存储在一个块(Block)中，每一个块中包含该时间窗口内的所有样本数据(chunks)，元数据文件(meta.json)以及索引文件(index)。

  ```
  t0            t1             t2             now
   ┌───────────┐  ┌───────────┐  ┌───────────┐
   │           │  │           │  │           │                 ┌────────────┐
   │           │  │           │  │  mutable  │ <─── write ──── ┤ Prometheus │
   │           │  │           │  │           │                 └────────────┘
   └───────────┘  └───────────┘  └───────────┘                        ^
         └──────────────┴───────┬──────┘                              │
                                │                                   query
                                │                                     │
                              merge ──────────────────────────────────┘
  ```

  当前时间窗口内正在收集的样本数据，Prometheus则会直接将数据保存在内存当中。为了确保此期间如果Prometheus发生崩溃或者重启时能够恢复数据，Prometheus启动时会从写入日志(WAL)进行重播，从而恢复数据。此期间如果通过API删除时间序列，删除记录也会保存在单独的逻辑文件当中(tombstone)。

  在文件系统中这些块保存在单独的目录当中，Prometheus保存块数据的目录结构如下所示：

  ```
  ./data 
     |- 01BKGV7JBM69T2G1BGBGM6KB12 # 块
        |- meta.json  # 元数据
        |- wal        # 写入日志
          |- 000002
          |- 000001
     |- 01BKGTZQ1SYQJTR4PB43C8PD98  # 块
        |- meta.json  #元数据
        |- index   # 索引文件
        |- chunks  # 样本数据
          |- 000001
        |- tombstones # 逻辑数据
     |- 01BKGTZQ1HHWHV8FBJXW1Y3W0K
        |- meta.json
        |- wal
          |-000001
  ```

  通过时间窗口的形式保存所有的样本数据，可以明显提高Prometheus的查询效率，当查询一段时间范围内的所有样本数据时，只需要简单的从落在该范围内的块中查询数据即可。

  同时该存储方式可以简化历史数据的删除逻辑。只要一个块的时间范围落在了配置的保留范围之外，直接丢弃该块即可。

  ```
                        |
   ┌────────────┐  ┌────┼─────┐  ┌───────────┐  ┌───────────┐  
   │ 1          │  │ 2  |     │  │ 3         │  │ 4         │ . . .
   └────────────┘  └────┼─────┘  └───────────┘  └───────────┘  
                        |
                        |
               retention boundary
  ```

  ## 本地存储配置

  用户可以通过命令行启动参数的方式修改本地存储的配置。

  | 启动参数                          | 默认值 | 含义                                                         |
  | --------------------------------- | ------ | ------------------------------------------------------------ |
  | --storage.tsdb.path               | data/  | Base path for metrics storage                                |
  | --storage.tsdb.retention          | 15d    | How long to retain samples in the storage                    |
  | --storage.tsdb.min-block-duration | 2h     | The timestamp range of head blocks after which they get persisted |
  | --storage.tsdb.max-block-duration | 36h    | The maximum timestamp range of compacted blocks,It's the minimum duration of any persisted block. |
  | --storage.tsdb.no-lockfile        | false  | Do not create lockfile in data directory                     |

  在一般情况下，Prometheus中存储的每一个样本大概占用1-2字节大小。如果需要对Prometheus Server的本地磁盘空间做容量规划时，可以通过以下公式计算：

  ```
  needed_disk_space = retention_time_seconds * ingested_samples_per_second * bytes_per_sample
  ```

  从上面公式中可以看出在保留时间(retention_time_seconds)和样本大小(bytes_per_sample)不变的情况下，如果想减少本地磁盘的容量需求，只能通过减少每秒获取样本数(ingested_samples_per_second)的方式。因此有两种手段，一是减少时间序列的数量，二是增加采集样本的时间间隔。考虑到Prometheus会对时间序列进行压缩效率，减少时间序列的数量效果更明显。

  ### 从失败中恢复

  如果本地存储由于某些原因出现了错误，最直接的方式就是停止Prometheus并且删除data目录中的所有记录。当然也可以尝试删除那些发生错误的块目录，不过相应的用户会丢失该块中保存的大概两个小时的监控记录。 

# 远程存储

Prometheus的本地存储设计可以减少其自身运维和管理的复杂度，同时能够满足大部分用户监控规模的需求。但是本地存储也意味着Prometheus无法持久化数据，无法存储大量历史数据，同时也无法灵活扩展和迁移。

为了保持Prometheus的简单性，Prometheus并没有尝试在自身中解决以上问题，而是通过定义两个标准接口(remote_write/remote_read)，让用户可以基于这两个接口对接将数据保存到任意第三方的存储服务中，这种方式在Promthues中称为Remote Storage。

## Remote Write

用户可以在Prometheus配置文件中指定Remote  Write(远程写)的URL地址，一旦设置了该配置项，Prometheus将采集到的样本数据通过HTTP的形式发送给适配器(Adaptor)。而用户则可以在适配器中对接外部任意的服务。外部服务可以是真正的存储系统，公有云的存储服务，也可以是消息队列等任意形式。

![Remote Write](https://www.prometheus.wang/ha/static/remote-write-path-2.png)Remote Write

## Remote Read

如下图所示，Promthues的Remote  Read(远程读)也通过了一个适配器实现。在远程读的流程当中，当用户发起查询请求后，Promthues将向remote_read中配置的URL发起查询请求(matchers,ranges)，Adaptor根据请求条件从第三方存储服务中获取响应的数据。同时将数据转换为Promthues的原始样本数据返回给Prometheus Server。

当获取到样本数据后，Promthues在本地使用PromQL对样本数据进行二次处理。

> 注意：启用远程读设置后，只在数据查询时有效，对于规则文件的处理，以及Metadata API的处理都只基于Prometheus本地存储完成。

![Remote Read](https://www.prometheus.wang/ha/static/remote_read_path-2.png)Remote Read

### 配置文件

Prometheus配置文件中添加remote_write和remote_read配置，其中url用于指定远程读/写的HTTP服务地址。如果该URL启动了认证则可以通过basic_auth进行安全认证配置。对于https的支持需要设定tls_concig。proxy_url主要用于Prometheus无法直接访问适配器服务的情况下。

remote_write和remote_write具体配置如下所示：

```
remote_write:
    url: <string>
    [ remote_timeout: <duration> | default = 30s ]
    write_relabel_configs:
    [ - <relabel_config> ... ]
    basic_auth:
    [ username: <string> ]
    [ password: <string> ]
    [ bearer_token: <string> ]
    [ bearer_token_file: /path/to/bearer/token/file ]
    tls_config:
    [ <tls_config> ]
    [ proxy_url: <string> ]

remote_read:
    url: <string>
    required_matchers:
    [ <labelname>: <labelvalue> ... ]
    [ remote_timeout: <duration> | default = 30s ]
    [ read_recent: <boolean> | default = false ]
    basic_auth:
    [ username: <string> ]
    [ password: <string> ]
    [ bearer_token: <string> ]
    [ bearer_token_file: /path/to/bearer/token/file ]
    [ <tls_config> ]
    [ proxy_url: <string> ]
```

## 自定义Remote Storage Adaptor

实现自定义Remote Storage需要用户分别创建用于支持remote_read和remote_write的HTTP服务。

![Remote Storage](https://www.prometheus.wang/ha/static/remote-storage-paths.png)Remote Storage

当前Prometheus中Remote Storage相关的协议主要通过以下proto文件进行定义：

```
syntax = "proto3";
package prometheus;

option go_package = "prompb";

import "types.proto";

message WriteRequest {
  repeated prometheus.TimeSeries timeseries = 1;
}

message ReadRequest {
  repeated Query queries = 1;
}

message ReadResponse {
  // In same order as the request's queries.
  repeated QueryResult results = 1;
}

message Query {
  int64 start_timestamp_ms = 1;
  int64 end_timestamp_ms = 2;
  repeated prometheus.LabelMatcher matchers = 3;
}

message QueryResult {
  // Samples within a time series must be ordered by time.
  repeated prometheus.TimeSeries timeseries = 1;
}
```

以下代码展示了一个简单的remote_write服务，创建用于接收remote_write的HTTP服务，将请求内容转换成WriteRequest后，用户就可以按照自己的需求进行后续的逻辑处理。

```
package main

import (
    "fmt"
    "io/ioutil"
    "net/http"

    "github.com/gogo/protobuf/proto"
    "github.com/golang/snappy"
    "github.com/prometheus/common/model"

    "github.com/prometheus/prometheus/prompb"
)

func main() {
    http.HandleFunc("/receive", func(w http.ResponseWriter, r *http.Request) {
        compressed, err := ioutil.ReadAll(r.Body)
        if err != nil {
            http.Error(w, err.Error(), http.StatusInternalServerError)
            return
        }

        reqBuf, err := snappy.Decode(nil, compressed)
        if err != nil {
            http.Error(w, err.Error(), http.StatusBadRequest)
            return
        }

        var req prompb.WriteRequest
        if err := proto.Unmarshal(reqBuf, &req); err != nil {
            http.Error(w, err.Error(), http.StatusBadRequest)
            return
        }

        for _, ts := range req.Timeseries {
            m := make(model.Metric, len(ts.Labels))
            for _, l := range ts.Labels {
                m[model.LabelName(l.Name)] = model.LabelValue(l.Value)
            }
            fmt.Println(m)

            for _, s := range ts.Samples {
                fmt.Printf("  %f %d\n", s.Value, s.Timestamp)
            }
        }
    })

    http.ListenAndServe(":1234", nil)
}
```

## 使用Influxdb作为Remote Storage

目前Prometheus社区也提供了部分对于第三方数据库的Remote Storage支持：

| 存储服务                | 支持模式   |
| ----------------------- | ---------- |
| AppOptics               | write      |
| Chronix                 | write      |
| Cortex:                 | read/write |
| CrateDB                 | read/write |
| Gnocchi                 | write      |
| Graphite                | write      |
| InfluxDB                | read/write |
| OpenTSDB                | write      |
| PostgreSQL/TimescaleDB: | read/write |
| SignalFx                | write      |

这里将介绍如何使用Influxdb作为Prometheus的Remote Storage，从而确保当Prometheus发生宕机或者重启之后能够从Influxdb中恢复和获取历史数据。

这里使用docker-compose定义并启动Influxdb数据库服务，docker-compose.yml定义如下：

```
version: '2'
services:
  influxdb:
    image: influxdb:1.3.5
    command: -config /etc/influxdb/influxdb.conf
    ports:
      - "8086:8086"
    environment:
      - INFLUXDB_DB=prometheus
      - INFLUXDB_ADMIN_ENABLED=true
      - INFLUXDB_ADMIN_USER=admin
      - INFLUXDB_ADMIN_PASSWORD=admin
      - INFLUXDB_USER=prom
      - INFLUXDB_USER_PASSWORD=prom
```

启动influxdb服务

```
$ docker-compose up -d
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
795d0ead87a1        influxdb:1.3.5      "/entrypoint.sh -c..."   3 hours ago         Up 3 hours          0.0.0.0:8086->8086/tcp   localhost_influxdb_1
```

获取并启动Prometheus提供的Remote Storage Adapter：

```
go get github.com/prometheus/prometheus/documentation/examples/remote_storage/remote_storage_adapter
```

获取remote_storage_adapter源码后，go会自动把相关的源码编译成可执行文件，并且保存在$GOPATH/bin/目录下。

启动remote_storage_adapter并且设置Influxdb相关的认证信息：

```
INFLUXDB_PW=prom $GOPATH/bin/remote_storage_adapter -influxdb-url=http://localhost:8086 -influxdb.username=prom -influxdb.database=prometheus -influxdb.retention-policy=autogen
```

修改prometheus.yml添加Remote Storage相关的配置内容：

```
remote_write:
  - url: "http://localhost:9201/write"

remote_read:
  - url: "http://localhost:9201/read"
```

重新启动Prometheus能够获取数据后，登录到influxdb容器，并验证数据写入。如下所示，当数据能够正常写入Influxdb后可以看到Prometheus相关的指标。

```
docker exec -it 795d0ead87a1 influx
Connected to http://localhost:8086 version 1.3.5
InfluxDB shell version: 1.3.5
> auth
username: prom
password:

> use prometheus
> SHOW MEASUREMENTS
name: measurements
name
----
go_gc_duration_seconds
go_gc_duration_seconds_count
go_gc_duration_seconds_sum
go_goroutines
go_info
go_memstats_alloc_bytes
go_memstats_alloc_bytes_total
go_memstats_buck_hash_sys_bytes
go_memstats_frees_total
go_memstats_gc_cpu_fraction
go_memstats_gc_sys_bytes
go_memstats_heap_alloc_bytes
go_memstats_heap_idle_bytes
```

当数据写入成功后，停止Prometheus服务。同时删除Prometheus的data目录，模拟Promthues数据丢失的情况后重启Prometheus。打开Prometheus UI如果配置正常，Prometheus可以正常查询到本地存储以删除的历史数据记录。

![从Remote Storage获取历史数据](https://www.prometheus.wang/ha/static/promethues-remote-storage.png) 

# 联邦集群

通过Remote Storage可以分离监控样本采集和数据存储，解决Prometheus的持久化问题。这一部分会重点讨论如何利用联邦集群特性对Promthues进行扩展，以适应不同监控规模的变化。

## 使用联邦集群

对于大部分监控规模而言，我们只需要在每一个数据中心(例如：EC2可用区，Kubernetes集群)安装一个Prometheus  Server实例，就可以在各个数据中心处理上千规模的集群。同时将Prometheus Server部署到不同的数据中心可以避免网络配置的复杂性。

![联邦集群](https://www.prometheus.wang/ha/static/prometheus_feradtion.png)联邦集群

如上图所示，在每个数据中心部署单独的Prometheus Server，用于采集当前数据中心监控数据。并由一个中心的Prometheus Server负责聚合多个数据中心的监控数据。这一特性在Promthues中称为联邦集群。

联邦集群的核心在于每一个Prometheus  Server都包含额一个用于获取当前实例中监控样本的接口/federate。对于中心Prometheus  Server而言，无论是从其他的Prometheus实例还是Exporter实例中获取数据实际上并没有任何差异。

```
scrape_configs:
  - job_name: 'federate'
    scrape_interval: 15s
    honor_labels: true
    metrics_path: '/federate'
    params:
      'match[]':
        - '{job="prometheus"}'
        - '{__name__=~"job:.*"}'
        - '{__name__=~"node.*"}'
    static_configs:
      - targets:
        - '192.168.77.11:9090'
        - '192.168.77.12:9090'
```

为了有效的减少不必要的时间序列，通过params参数可以用于指定只获取某些时间序列的样本数据，例如

```
"http://192.168.77.11:9090/federate?match[]={job%3D"prometheus"}&match[]={__name__%3D~"job%3A.*"}&match[]={__name__%3D~"node.*"}"
```

通过URL中的match[]参数指定我们可以指定需要获取的时间序列。match[]参数必须是一个瞬时向量选择器，例如up或者{job="api-server"}。配置多个match[]参数，用于获取多组时间序列的监控数据。

**horbor_labels**配置true可以确保当采集到的监控指标冲突时，能够自动忽略冲突的监控数据。如果为false时，prometheus会自动将冲突的标签替换为”exported_“的形式。

## 功能分区

联邦集群的特性可以帮助用户根据不同的监控规模对Promthues部署架构进行调整。例如如下所示，可以在各个数据中心中部署多个Prometheus Server实例。每一个Prometheus  Server实例只负责采集当前数据中心中的一部分任务(Job)，例如可以将不同的监控任务分离到不同的Prometheus实例当中，再有中心Prometheus实例进行聚合。

![功能分区](https://www.prometheus.wang/ha/static/prometheus_feradtion_2.png)功能分区

功能分区，即通过联邦集群的特性在任务级别对Prometheus采集任务进行划分，以支持规模的扩展。

# Prometheus高可用部署

Prometheus的本地存储给Prometheus带来了简单高效的使用体验，可以让Promthues在单节点的情况下满足大部分用户的监控需求。但是本地存储也同时限制了Prometheus的可扩展性，带来了数据持久化等一系列的问题。通过Prometheus的Remote Storage特性可以解决这一系列问题，包括Promthues的动态扩展，以及历史数据的存储。

而除了数据持久化问题以外，影响Promthues性能表现的另外一个重要因素就是数据采集任务量，以及单台Promthues能够处理的时间序列数。因此当监控规模大到Promthues单台无法有效处理的情况下，可以选择利用Promthues的联邦集群的特性，将Promthues的监控任务划分到不同的实例当中。

这一部分将重点讨论Prometheus的高可用架构，并且根据不同的使用场景介绍了一种常见的高可用方案。

## 基本HA：服务可用性

由于Promthues的Pull机制的设计，为了确保Promthues服务的可用性，用户只需要部署多套Prometheus Server实例，并且采集相同的Exporter目标即可。

![基本HA](https://www.prometheus.wang/ha/static/promethues-ha-01.png)基本HA

基本的HA模式只能确保Promthues服务的可用性问题，但是不解决Prometheus  Server之间的数据一致性问题以及持久化问题(数据丢失后无法恢复)，也无法进行动态的扩展。因此这种部署方式适合监控规模不大，Promthues Server也不会频繁发生迁移的情况，并且只需要保存短周期监控数据的场景。

## 基本HA + 远程存储

在基本HA模式的基础上通过添加Remote Storage存储支持，将监控数据保存在第三方存储服务上。

![HA + Remote Storage](https://www.prometheus.wang/ha/static/prometheus-ha-remote-storage.png)HA + Remote Storage

在解决了Promthues服务可用性的基础上，同时确保了数据的持久化，当Promthues  Server发生宕机或者数据丢失的情况下，可以快速的恢复。 同时Promthues  Server可能很好的进行迁移。因此，该方案适用于用户监控规模不大，但是希望能够将监控数据持久化，同时能够确保Promthues  Server的可迁移性的场景。

## 基本HA + 远程存储 + 联邦集群

当单台Promthues Server无法处理大量的采集任务时，用户可以考虑基于Prometheus联邦集群的方式将监控采集任务划分到不同的Promthues实例当中即在任务级别功能分区。

![基本HA + 远程存储 + 联邦集群](https://www.prometheus.wang/ha/static/prometheus-ha-rs-fedreation.png)基本HA + 远程存储 + 联邦集群

这种部署方式一般适用于两种场景：

场景一：单数据中心 + 大量的采集任务

这种场景下Promthues的性能瓶颈主要在于大量的采集任务，因此用户需要利用Prometheus联邦集群的特性，将不同类型的采集任务划分到不同的Promthues子服务中，从而实现功能分区。例如一个Promthues Server负责采集基础设施相关的监控指标，另外一个Prometheus Server负责采集应用监控指标。再有上层Prometheus  Server实现对数据的汇聚。

场景二：多数据中心

这种模式也适合与多数据中心的情况，当Promthues  Server无法直接与数据中心中的Exporter进行通讯时，在每一个数据中部署一个单独的Promthues  Server负责当前数据中心的采集任务是一个不错的方式。这样可以避免用户进行大量的网络配置，只需要确保主Promthues  Server实例能够与当前数据中心的Prometheus Server通讯即可。 中心Promthues  Server负责实现对多数据中心数据的聚合。

## 按照实例进行功能分区

这时在考虑另外一种极端情况，即单个采集任务的Target数也变得非常巨大。这时简单通过联邦集群进行功能分区，Prometheus Server也无法有效处理时。这种情况只能考虑继续在实例级别进行功能划分。

![实例级别功能分区](https://www.prometheus.wang/ha/static/promethues-sharding-targets.png)实例级别功能分区

如上图所示，将统一任务的不同实例的监控数据采集任务划分到不同的Prometheus实例。通过relabel设置，我们可以确保当前Prometheus Server只收集当前采集任务的一部分实例的监控指标。

```
global:
  external_labels:
    slave: 1  # This is the 2nd slave. This prevents clashes between slaves.
scrape_configs:
  - job_name: some_job
    relabel_configs:
    - source_labels: [__address__]
      modulus:       4
      target_label:  __tmp_hash
      action:        hashmod
    - source_labels: [__tmp_hash]
      regex:         ^1$
      action:        keep
```

并且通过当前数据中心的一个中心Prometheus Server将监控数据进行聚合到任务级别。

```
- scrape_config:
  - job_name: slaves
    honor_labels: true
    metrics_path: /federate
    params:
      match[]:
        - '{__name__=~"^slave:.*"}'   # Request all slave-level time series
    static_configs:
      - targets:
        - slave0:9090
        - slave1:9090
        - slave3:9090
        - slave4:9090
```

## 高可用方案选择

上面的部分，根据不同的场景演示了3种不同的高可用部署方案。当然对于Promthues部署方案需要用户根据监控规模以及自身的需求进行动态调整，下表展示了Promthues和高可用有关3个选项各自解决的问题，用户可以根据自己的需求灵活选择。

| 选项\需求 | 服务可用性 | 数据持久化 | 水平扩展 |
| --------- | ---------- | ---------- | -------- |
| 主备HA    | v          | x          | x        |
| 远程存储  | x          | v          | x        |
| 联邦集群  | x          | x          | v        |

# Alertmanager高可用

在上一小节中我们主要讨论了Prometheus Server自身的高可用问题。而接下来，重点将放在告警处理也就是Alertmanager部分。如下所示。

![Alertmanager成为单点](https://www.prometheus.wang/ha/static/prom-ha-with-single-am.png)Alertmanager成为单点

为了提升Promthues的服务可用性，通常用户会部署两个或者两个以上的Promthus Server，它们具有完全相同的配置包括Job配置，以及告警配置等。当某一个Prometheus Server发生故障后可以确保Promthues持续可用。

同时基于Alertmanager的告警分组机制即使不同的Prometheus Sever分别发送相同的告警给Alertmanager，Alertmanager也可以自动将这些告警合并为一个通知向receiver发送。

![Alertmanager特性](https://www.prometheus.wang/ha/static/alertmanager-features.png)Alertmanager特性

但不幸的是，虽然Alertmanager能够同时处理多个相同的Prometheus  Server所产生的告警。但是由于单个Alertmanager的存在，当前的部署结构存在明显的单点故障风险，当Alertmanager单点失效后，告警的后续所有业务全部失效。

如下所示，最直接的方式，就是尝试部署多套Alertmanager。但是由于Alertmanager之间不存在并不了解彼此的存在，因此则会出现告警通知被不同的Alertmanager重复发送多次的问题。

![img](https://www.prometheus.wang/ha/static/prom-ha-with-double-am.png)

为了解决这一问题，如下所示。Alertmanager引入了Gossip机制。Gossip机制为多个Alertmanager之间提供了信息传递的机制。确保及时在多个Alertmanager分别接收到相同告警信息的情况下，也只有一个告警通知被发送给Receiver。

![Alertmanager Gossip](https://www.prometheus.wang/ha/static/prom-ha-with-am-gossip.png)Alertmanager Gossip

## Gossip协议

Gossip是分布式系统中被广泛使用的协议，用于实现分布式节点之间的信息交换和状态同步。Gossip协议同步状态类似于流言或者病毒的传播，如下所示：

![Gossip分布式协议](https://www.prometheus.wang/ha/static/gossip-protoctl.png)Gossip分布式协议

一般来说Gossip有两种实现方式分别为Push-based和Pull-based。在Push-based当集群中某一节点A完成一个工作后，随机的从其它节点B并向其发送相应的消息，节点B接收到消息后在重复完成相同的工作，直到传播到集群中的所有节点。而Pull-based的实现中节点A会随机的向节点B发起询问是否有新的状态需要同步，如果有则返回。

在简单了解了Gossip协议之后，我们来看Alertmanager是如何基于Gossip协议实现集群高可用的。如下所示，当Alertmanager接收到来自Prometheus的告警消息后，会按照以下流程对告警进行处理：

![通知流水线](https://www.prometheus.wang/ha/static/am-notifi-pipeline.png)通知流水线

1. 在第一个阶段Silence中，Alertmanager会判断当前通知是否匹配到任何的静默规则，如果没有则进入下一个阶段，否则则中断流水线不发送通知。
2. 在第二个阶段Wait中，Alertmanager会根据当前Alertmanager在集群中所在的顺序(index)等待index * 5s的时间。
3. 当前Alertmanager等待阶段结束后，Dedup阶段则会判断当前Alertmanager数据库中该通知是否已经发送，如果已经发送则中断流水线，不发送告警，否则则进入下一阶段Send对外发送告警通知。
4. 告警发送完成后该Alertmanager进入最后一个阶段Gossip，Gossip会通知其他Alertmanager实例当前告警已经发送。其他实例接收到Gossip消息后，则会在自己的数据库中保存该通知已发送的记录。

因此如下所示，Gossip机制的关键在于两点：

![Gossip机制](https://www.prometheus.wang/ha/static/am-gossip.png)Gossip机制

- Silence设置同步：Alertmanager启动阶段基于Pull-based从集群其它节点同步Silence状态，当有新的Silence产生时使用Push-based方式在集群中传播Gossip信息。
- 通知发送状态同步：告警通知发送完成后，基于Push-based同步告警发送状态。Wait阶段可以确保集群状态一致。

Alertmanager基于Gossip实现的集群机制虽然不能保证所有实例上的数据时刻保持一致，但是实现了CAP理论中的AP系统，即可用性和分区容错性。同时对于Prometheus Server而言保持了配置了简单性，Promthues Server之间不需要任何的状态同步。

## 搭建本地集群环境

为了能够让Alertmanager节点之间进行通讯，需要在Alertmanager启动时设置相应的参数。其中主要的参数包括：

- --cluster.listen-address string: 当前实例集群服务监听地址
- --cluster.peer value: 初始化时关联的其它实例的集群服务地址

例如：

定义Alertmanager实例a1，其中Alertmanager的服务运行在9093端口，集群服务地址运行在8001端口。

```
alertmanager  --web.listen-address=":9093" --cluster.listen-address="127.0.0.1:8001" --config.file=/etc/prometheus/alertmanager.yml  --storage.path=/data/alertmanager/
```

定义Alertmanager实例a2，其中主服务运行在9094端口，集群服务运行在8002端口。为了将a1，a2组成集群。 a2启动时需要定义--cluster.peer参数并且指向a1实例的集群服务地址:8001。

```
alertmanager  --web.listen-address=":9094" --cluster.listen-address="127.0.0.1:8002" --cluster.peer=127.0.0.1:8001 --config.file=/etc/prometheus/alertmanager.yml  --storage.path=/data/alertmanager2/
```

为了能够在本地模拟集群环境，这里使用了一个轻量级的多线程管理工具goreman。使用以下命令可以在本地安装goreman命令行工具。

```
go get github.com/mattn/goreman
```

### 创建Alertmanager集群

创建Alertmanager配置文件/etc/prometheus/alertmanager-ha.yml, 为了验证Alertmanager的集群行为，这里在本地启动一个webhook服务用于打印Alertmanager发送的告警通知信息。

```
route:
  receiver: 'default-receiver'
receivers:
  - name: default-receiver
    webhook_configs:
    - url: 'http://127.0.0.1:5001/'
```

本地webhook服务可以直接从Github获取。

```
# 获取alertmanager提供的webhook示例，如果该目录下定义了main函数，go get会自动将其编译成可执行文件
go get github.com/prometheus/alertmanager/examples/webhook
# 设置环境变量指向GOPATH的bin目录
export PATH=$GOPATH/bin:$PATH
# 启动服务
webhook
```

示例结构如下所示：

![Alertmanager HA部署结构](https://www.prometheus.wang/ha/static/alertmanager-gossip-ha.png)Alertmanager HA部署结构

创建alertmanager.procfile文件，并且定义了三个Alertmanager节点（a1，a2，a3）以及用于接收告警通知的webhook服务:

```
a1: alertmanager  --web.listen-address=":9093" --cluster.listen-address="127.0.0.1:8001" --config.file=/etc/prometheus/alertmanager-ha.yml  --storage.path=/data/alertmanager/ --log.level=debug
a2: alertmanager  --web.listen-address=":9094" --cluster.listen-address="127.0.0.1:8002" --cluster.peer=127.0.0.1:8001 --config.file=/etc/prometheus/alertmanager-ha.yml  --storage.path=/data/alertmanager2/ --log.level=debug
a3: alertmanager  --web.listen-address=":9095" --cluster.listen-address="127.0.0.1:8003" --cluster.peer=127.0.0.1:8001 --config.file=/etc/prometheus/alertmanager-ha.yml  --storage.path=/data/alertmanager2/ --log.level=debug

webhook: webhook
```

在Procfile文件所在目录，执行goreman start命令，启动所有进程:

```
$ goreman -f alertmanager.procfile start
10:27:57      a1 | level=debug ts=2018-03-12T02:27:57.399166371Z caller=cluster.go:125 component=cluster msg="joined cluster" peers=0
10:27:57      a3 | level=info ts=2018-03-12T02:27:57.40004678Z caller=main.go:346 msg=Listening address=:9095
10:27:57      a1 | level=info ts=2018-03-12T02:27:57.400212246Z caller=main.go:271 msg="Loading configuration file" file=/etc/prometheus/alertmanager.yml
10:27:57      a1 | level=info ts=2018-03-12T02:27:57.405638714Z caller=main.go:346 msg=Listening address=:9093
```

启动完成后访问任意Alertmanager节点http://localhost:9093/#/status,可以查看当前Alertmanager集群的状态。

![Alertmanager集群状态](https://www.prometheus.wang/ha/static/am-ha-status.png)Alertmanager集群状态

当集群中的Alertmanager节点不在一台主机时，通常需要使用--cluster.advertise-address参数指定当前节点所在网络地址。

> 注意：由于goreman不保证进程之间的启动顺序，如果集群状态未达到预期，可以使用`goreman -f alertmanager.procfile run restart a2`重启a2，a3服务。

当Alertmanager集群启动完成后，可以使用send-alerts.sh脚本对集群进行简单测试，这里利用curl分别向3个Alertmanager实例发送告警信息。

```
alerts1='[
  {
    "labels": {
       "alertname": "DiskRunningFull",
       "dev": "sda1",
       "instance": "example1"
     },
     "annotations": {
        "info": "The disk sda1 is running full",
        "summary": "please check the instance example1"
      }
  },
  {
    "labels": {
       "alertname": "DiskRunningFull",
       "dev": "sdb2",
       "instance": "example2"
     },
     "annotations": {
        "info": "The disk sdb2 is running full",
        "summary": "please check the instance example2"
      }
  },
  {
    "labels": {
       "alertname": "DiskRunningFull",
       "dev": "sda1",
       "instance": "example3",
       "severity": "critical"
     }
  },
  {
    "labels": {
       "alertname": "DiskRunningFull",
       "dev": "sda1",
       "instance": "example3",
       "severity": "warning"
     }
  }
]'

curl -XPOST -d"$alerts1" http://localhost:9093/api/v1/alerts
curl -XPOST -d"$alerts1" http://localhost:9094/api/v1/alerts
curl -XPOST -d"$alerts1" http://localhost:9095/api/v1/alerts
```

运行send-alerts.sh后，查看alertmanager日志，可以看到以下输出，3个Alertmanager实例分别接收到模拟的告警信息：

```
10:43:36      a1 | level=debug ts=2018-03-12T02:43:36.853370185Z caller=dispatch.go:188 component=dispatcher msg="Received alert" alert=DiskRunningFull[6543bc1][active]
10:43:36      a2 | level=debug ts=2018-03-12T02:43:36.871180749Z caller=dispatch.go:188 component=dispatcher msg="Received alert" alert=DiskRunningFull[8320f0a][active]
10:43:36      a3 | level=debug ts=2018-03-12T02:43:36.894923811Z caller=dispatch.go:188 component=dispatcher msg="Received alert" alert=DiskRunningFull[8320f0a][active]
```

查看webhook日志只接收到一个告警通知：

```
10:44:06 webhook | 2018/03/12 10:44:06 {
10:44:06 webhook |  >  "receiver": "default-receiver",
10:44:06 webhook |  >  "status": "firing",
10:44:06 webhook |  >  "alerts": [
10:44:06 webhook |  >    {
10:44:06 webhook |  >      "status": "firing",
10:44:06 webhook |  >      "labels": {
10:44:06 webhook |  >        "alertname": "DiskRunningFull",
```

### 多实例Prometheus与Alertmanager集群

由于Gossip机制的实现，在Promthues和Alertmanager实例之间不要使用任何的负载均衡，需要确保Promthues将告警发送到所有的Alertmanager实例中：

```
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      - 127.0.0.1:9093
      - 127.0.0.1:9094
      - 127.0.0.1:9095
```

创建Promthues集群配置文件/etc/prometheus/prometheus-ha.yml，完整内容如下：

```
global:
  scrape_interval: 15s
  scrape_timeout: 10s
  evaluation_interval: 15s
rule_files:
  - /etc/prometheus/rules/*.rules
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      - 127.0.0.1:9093
      - 127.0.0.1:9094
      - 127.0.0.1:9095
scrape_configs:
- job_name: prometheus
  static_configs:
  - targets:
    - localhost:9090
- job_name: 'node'
  static_configs:
  - targets: ['localhost:9100']
```

同时定义告警规则文件/etc/prometheus/rules/hoststats-alert.rules，如下所示：

```
groups:
- name: hostStatsAlert
  rules:
  - alert: hostCpuUsageAlert
    expr: sum(avg without (cpu)(irate(node_cpu{mode!='idle'}[5m]))) by (instance) * 100 > 50
    for: 1m
    labels:
      severity: page
    annotations:
      summary: "Instance {{ $labels.instance }} CPU usgae high"
      description: "{{ $labels.instance }} CPU usage above 50% (current value: {{ $value }})"
  - alert: hostMemUsageAlert
    expr: (node_memory_MemTotal - node_memory_MemAvailable)/node_memory_MemTotal * 100 > 85
    for: 1m
    labels:
      severity: page
    annotations:
      summary: "Instance {{ $labels.instance }} MEM usgae high"
      description: "{{ $labels.instance }} MEM usage above 85% (current value: {{ $value }})"
```

本示例部署结构如下所示：

![Promthues与Alertmanager HA部署结构](https://www.prometheus.wang/ha/static/promethues-alertmanager-ha.png)Promthues与Alertmanager HA部署结构

创建prometheus.procfile文件，创建两个Promthues节点，分别监听9090和9091端口:

```
p1: prometheus --config.file=/etc/prometheus/prometheus-ha.yml --storage.tsdb.path=/data/prometheus/ --web.listen-address="127.0.0.1:9090"
p2: prometheus --config.file=/etc/prometheus/prometheus-ha.yml --storage.tsdb.path=/data/prometheus2/ --web.listen-address="127.0.0.1:9091"

node_exporter: node_exporter -web.listen-address="0.0.0.0:9100"
```

使用goreman启动多节点Promthues：

```
goreman -f prometheus.procfile -p 8556 start
```

Promthues启动完成后，手动拉高系统CPU使用率：

```
cat /dev/zero>/dev/null
```

> 注意，对于多核主机，如果CPU达不到预期，运行多个命令。

当CPU利用率达到告警规则触发条件，两个Prometheus实例告警分别被触发。查看Alertmanager输出日志：

```
11:14:41      a3 | level=debug ts=2018-03-12T03:14:41.945493505Z caller=dispatch.go:188 component=dispatcher msg="Received alert" alert=hostCpuUsageAlert[7d698ac][active]
11:14:41      a1 | level=debug ts=2018-03-12T03:14:41.945534548Z caller=dispatch.go:188 component=dispatcher msg="Received alert" alert=hostCpuUsageAlert[7d698ac][active]
11:14:41      a2 | level=debug ts=2018-03-12T03:14:41.945687812Z caller=dispatch.go:188 component=dispatcher msg="Received alert" alert=hostCpuUsageAlert[7d698ac][active]
```

3个Alertmanager实例分别接收到来自不同Prometheus实例的告警信息。而Webhook服务只接收到来自Alertmanager集群的一条告警通知：

```
11:15:11 webhook | 2018/03/12 11:15:11 {
11:15:11 webhook |  >  "receiver": "default-receiver",
11:15:11 webhook |  >  "status": "firing",
11:15:11 webhook |  >  "alerts": [
11:15:11 webhook |  >    {
11:15:11 webhook |  >      "status": "firing",
11:15:11 webhook |  >      "labels": {
11:15:11 webhook |  >        "alertname": "hostCpuUsageAlert",
```

# 小结

Prometheus的简单性贯穿于整个Prometheus的使用过程中，无论是单机部署还是集群化部署，简单性一致是Prometheus设计的基本原则。这本章中，我们系统学习了如果实现Prometheus下各个中间的高可用部署方式，同时给出了集中常用的高可用方案，读者可以根据自己的实际需求来选择如何部署自己的Promethues集群。 

# 第7章 Prometheus服务发现

在前6个章节中，我们主要介绍了Prometheus自身的一些特性，包括高效的数据能力、灵活的查询语言PromQL、Prometheus的告警模式、Exporter的使用、以及自身的高可用等。而作为下一代监控系统的首选解决方案，Prometheus对云以及容器环境下的监控场景提供了完善的支持。本章中将介绍Prometheus是如何通过服务发现机制完美解决云原生场景下的监控挑战的。

本章的主要内容：

- 云原生、容器场景下监控的挑战；
- Prometheus服务发现的实现机制；
- Prometheus中服务发现的几种实现方式；
- Prometheus中强大的Relabel机制。 

# Prometheus与服务发现

在基于云(IaaS或者CaaS)的基础设施环境中用户可以像使用水、电一样按需使用各种资源（计算、网络、存储）。按需使用就意味着资源的动态性，这些资源可以随着需求规模的变化而变化。例如在AWS中就提供了专门的AutoScall服务，可以根据用户定义的规则动态地创建或者销毁EC2实例，从而使用户部署在AWS上的应用可以自动的适应访问规模的变化。

这种按需的资源使用方式对于监控系统而言就意味着没有了一个固定的监控目标，所有的监控对象(基础设施、应用、服务)都在动态的变化。对于Nagias这类基于Push模式传统监控软件就意味着必须在每一个节点上安装相应的Agent程序，并且通过配置指向中心的Nagias服务，受监控的资源与中心监控服务器之间是一个强耦合的关系，要么直接将Agent构建到基础设施镜像当中，要么使用一些自动化配置管理工具(如Ansible、Chef)动态的配置这些节点。当然实际场景下除了基础设施的监控需求以外，我们还需要监控在云上部署的应用，中间件等等各种各样的服务。要搭建起这样一套中心化的监控系统实施成本和难度是显而易见的。

而对于Prometheus这一类基于Pull模式的监控系统，显然也无法继续使用的static_configs的方式静态的定义监控目标。而对于Prometheus而言其解决方案就是引入一个中间的代理人（服务注册中心），这个代理人掌握着当前所有监控目标的访问信息，Prometheus只需要向这个代理人询问有哪些监控目标控即可， 这种模式被称为服务发现。

![基于服务发现与注册中心动态发现监控目标](https://www.prometheus.wang/sd/static/prometheus-sd.png)基于服务发现与注册中心动态发现监控目标

在不同的场景下，会有不同的东西扮演者代理人（服务发现与注册中心）这一角色。比如在AWS公有云平台或者OpenStack的私有云平台中，由于这些平台自身掌握着所有资源的信息，此时这些云平台自身就扮演了代理人的角色。Prometheus通过使用平台提供的API就可以找到所有需要监控的云主机。在Kubernetes这类容器管理平台中，Kubernetes掌握并管理着所有的容器以及服务信息，那此时Prometheus只需要与Kubernetes打交道就可以找到所有需要监控的容器以及服务对象。Prometheus还可以直接与一些开源的服务发现工具进行集成，例如在微服务架构的应用程序中，经常会使用到例如Consul这样的服务发现注册软件，Promethues也可以与其集成从而动态的发现需要监控的应用服务实例。除了与这些平台级的公有云、私有云、容器云以及专门的服务发现注册中心集成以外，Prometheus还支持基于DNS以及文件的方式动态发现监控目标，从而大大的减少了在云原生，微服务以及云模式下监控实施难度。

![Push系统 vs Pull系统](https://www.prometheus.wang/sd/static/pulls_vs_push.png)Push系统 vs Pull系统

如上所示，展示了Push系统和Pull系统的核心差异。相较于Push模式，Pull模式的优点可以简单总结为以下几点：

- 只要Exporter在运行，你可以在任何地方（比如在本地），搭建你的监控系统；
- 你可以更容易的查看监控目标实例的健康状态，并且可以快速定位故障；
- 更利于构建DevOps文化的团队；
- 松耦合的架构模式更适合于云原生的部署环境。 

# 基于文件的服务发现

在Prometheus支持的众多服务发现的实现方式中，基于文件的服务发现是最通用的方式。这种方式不需要依赖于任何的平台或者第三方服务。对于Prometheus而言也不可能支持所有的平台或者环境。通过基于文件的服务发现方式下，Prometheus会定时从文件中读取最新的Target信息，因此，你可以通过任意的方式将监控Target的信息写入即可。

用户可以通过JSON或者YAML格式的文件，定义所有的监控目标。例如，在下面的JSON文件中分别定义了3个采集任务，以及每个任务对应的Target列表：

```
[
  {
    "targets": [ "localhost:8080"],
    "labels": {
      "env": "localhost",
      "job": "cadvisor"
    }
  },
  {
    "targets": [ "localhost:9104" ],
    "labels": {
      "env": "prod",
      "job": "mysqld"
    }
  },
  {
    "targets": [ "localhost:9100"],
    "labels": {
      "env": "prod",
      "job": "node"
    }
  }
]
```

同时还可以通过为这些实例添加一些额外的标签信息，例如使用env标签标示当前节点所在的环境，这样从这些实例中采集到的样本信息将包含这些标签信息，从而可以通过该标签按照环境对数据进行统计。

创建Prometheus配置文件/etc/prometheus/prometheus-file-sd.yml，并添加以下内容：

```
global:
  scrape_interval: 15s
  scrape_timeout: 10s
  evaluation_interval: 15s
scrape_configs:
- job_name: 'file_ds'
  file_sd_configs:
  - files:
    - targets.json
```

这里定义了一个基于file_sd_configs的监控采集任务，其中模式的任务名称为file_ds。在JSON文件中可以使用job标签覆盖默认的job名称，此时启动Prometheus服务：

```
prometheus --config.file=/etc/prometheus/prometheus-file-sd.yml --storage.tsdb.path=/data/prometheus
```

在Prometheus UI的Targets下就可以看到当前从targets.json文件中动态获取到的Target实例信息以及监控任务的采集状态，同时在Labels列下会包含用户添加的自定义标签:

![基于文件动态发现Target对象](https://www.prometheus.wang/sd/static/service_ds_with_file.png)基于文件动态发现Target对象

Prometheus默认每5m重新读取一次文件内容，当需要修改时，可以通过refresh_interval进行设置，例如：

```
- job_name: 'file_ds'
  file_sd_configs:
  - refresh_interval: 1m
    files:
    - targets.json
```

通过这种方式，Prometheus会自动的周期性读取文件中的内容。当文件中定义的内容发生变化时，不需要对Prometheus进行任何的重启操作。

这种通用的方式可以衍生了很多不同的玩法，比如与自动化配置管理工具(Ansible)结合、与Cron Job结合等等。  对于一些Prometheus还不支持的云环境，比如国内的阿里云、腾讯云等也可以使用这种方式通过一些自定义程序与平台进行交互自动生成监控Target文件，从而实现对这些云环境中基础设施的自动化监控支持。 

# 基于Consul的服务发现

Consul是由HashiCorp开发的一个支持多数据中心的分布式服务发现和键值对存储服务的开源软件，被大量应用于基于微服务的软件架构当中。

## Consul初体验

用户可以通过Consul官网https://www.consul.io/downloads.html下载对应操作系统版本的软件包。Consul与Prometheus同样使用Go语言进行开发，因此安装和部署的方式也极为简单，解压并将命令行工具放到系统PATH路径下即可。

在本地可以使用开发者模式在本地快速启动一个单节点的Consul环境：

```
$ consul agent -dev
==> Starting Consul agent...
==> Consul agent running!
           Version: 'v1.0.7'
           Node ID: 'd7b590ba-e2f8-3a82-e8a8-2a911bdf67d5'
         Node name: 'localhost'
        Datacenter: 'dc1' (Segment: '<all>')
            Server: true (Bootstrap: false)
       Client Addr: [127.0.0.1] (HTTP: 8500, HTTPS: -1, DNS: 8600)
      Cluster Addr: 127.0.0.1 (LAN: 8301, WAN: 8302)
           Encrypt: Gossip: false, TLS-Outgoing: false, TLS-Incoming: false
```

在启动成功后，在一个新的terminal窗口中运行consul members可以查看当前集群中的所有节点：

```
$ consul members
Node       Address         Status  Type    Build  Protocol  DC   Segment
localhost  127.0.0.1:8301  alive   server  1.0.7  2         dc1  <all>
```

用户还可以通过HTTP API的方式查看当前集群中的节点信息：

```
$ curl localhost:8500/v1/catalog/nodes
[
    {
        "ID": "d7b590ba-e2f8-3a82-e8a8-2a911bdf67d5",
        "Node": "localhost",
        "Address": "127.0.0.1",
        "Datacenter": "dc1",
        "TaggedAddresses": {
            "lan": "127.0.0.1",
            "wan": "127.0.0.1"
        },
        "Meta": {
            "consul-network-segment": ""
        },
        "CreateIndex": 5,
        "ModifyIndex": 6
    }
]
```

Consul还提供了内置的DNS服务，可以通过Consul的DNS服务的方式访问其中的节点：

```
$ dig @127.0.0.1 -p 8600 localhost.node.consul

; <<>> DiG 9.9.7-P3 <<>> @127.0.0.1 -p 8600 localhost.node.consul
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 50684
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;localhost.node.consul.        IN    A

;; ANSWER SECTION:
localhost.node.consul.    0    IN    A    127.0.0.1

;; Query time: 5 msec
;; SERVER: 127.0.0.1#8600(127.0.0.1)
;; WHEN: Sun Apr 15 22:10:56 CST 2018
;; MSG SIZE  rcvd: 66
```

在Consul当中服务可以通过服务定义文件或者是HTTP API的方式进行注册。这里使用服务定义文件的方式将本地运行的node_exporter通过服务的方式注册到Consul当中。

创建配置目录：

```
sudo mkdir /etc/consul.d
echo '{"service": {"name": "node_exporter", "tags": ["exporter"], "port": 9100}}' \
    | sudo tee /etc/consul.d/node_exporter.json
```

重新启动Consul服务，并且声明服务定义文件所在目录：

```
$ consul agent -dev -config-dir=/etc/consul.d
==> Starting Consul agent...
    2018/04/15 22:23:47 [DEBUG] agent: Service "node_exporter" in sync
```

一旦服务注册成功之后，用户就可以通过DNS或HTTP API的方式查询服务信息。默认情况下，所有的服务都可以使用NAME.service.consul域名的方式进行访问。

例如，可以使用node_exporter.service.consul域名查询node_exporter服务的信息：

```
$ dig @127.0.0.1 -p 8600 node_exporter.service.consul

;; QUESTION SECTION:
;node_exporter.service.consul.    IN    A

;; ANSWER SECTION:
node_exporter.service.consul. 0    IN    A    127.0.0.1
```

如上所示DNS记录会返回当前可用的node_exporter服务实例的IP地址信息。

除了使用DNS的方式以外，Consul还支持用户使用HTTP API的形式获取服务列表：

```
$ curl http://localhost:8500/v1/catalog/service/node_exporter
[
    {
        "ID": "e561b376-2c1b-653d-61a0-1d844bce06a7",
        "Node": "localhost",
        "Address": "127.0.0.1",
        "Datacenter": "dc1",
        "TaggedAddresses": {
            "lan": "127.0.0.1",
            "wan": "127.0.0.1"
        },
        "NodeMeta": {
            "consul-network-segment": ""
        },
        "ServiceID": "node_exporter",
        "ServiceName": "node_exporter",
        "ServiceTags": [
            "exporter"
        ],
        "ServiceAddress": "",
        "ServiceMeta": {},
        "ServicePort": 9100,
        "ServiceEnableTagOverride": false,
        "CreateIndex": 6,
        "ModifyIndex": 6
    }
]
```

Consul也提供了一个Web UI可以查看Consul中所有服务以及节点的状态：

![Consul UI](https://www.prometheus.wang/sd/static/consul_ui_page.png)Consul UI

当然Consul还提供了更多的API用于支持对服务的生命周期管理（添加、删除、修改等）这里就不做过多的介绍，感兴趣的同学可以通过Consul官方文档了解更多的详细信息。

## 与Prometheus集成

Consul作为一个通用的服务发现和注册中心，记录并且管理了环境中所有服务的信息。Prometheus通过与Consul的交互可以获取到相应Exporter实例的访问信息。在Prometheus的配置文件当可以通过以下方式与Consul进行集成：

```
- job_name: node_exporter
    metrics_path: /metrics
    scheme: http
    consul_sd_configs:
      - server: localhost:8500
        services:
          - node_exporter
```

在consul_sd_configs定义当中通过server定义了Consul服务的访问地址，services则定义了当前需要发现哪些类型服务实例的信息，这里限定了只获取node_exporter的服务实例信息。 

# 服务发现与Relabeling

在本章的前几个小节中笔者已经分别介绍了Prometheus的几种服务发现机制。通过服务发现的方式，管理员可以在不重启Prometheus服务的情况下动态的发现需要监控的Target实例信息。

![基于Consul的服务发现](https://www.prometheus.wang/sd/static/bolg_sd_mutil_cluster.png)基于Consul的服务发现

如上图所示，对于线上环境我们可能会划分为:dev, stage,  prod不同的集群。每一个集群运行多个主机节点，每个服务器节点上运行一个Node Exporter实例。Node  Exporter实例会自动注册到Consul中，而Prometheus则根据Consul返回的Node  Exporter实例信息动态的维护Target列表，从而向这些Target轮询监控数据。

然而，如果我们可能还需要：

- 按照不同的环境dev, stage, prod聚合监控数据？
- 对于研发团队而言，我可能只关心dev环境的监控数据，如何处理？
- 如果为每一个团队单独搭建一个Prometheus Server。那么如何让不同团队的Prometheus Server采集不同的环境监控数据？

面对以上这些场景下的需求时，我们实际上是希望Prometheus Server能够按照某些规则（比如标签）从服务发现注册中心返回的Target实例中有选择性的采集某些Exporter实例的监控数据。

接下来，我们将学习如何通过Prometheus强大的Relabel机制来实现以上这些具体的目标。

## Prometheus的Relabeling机制

在Prometheus所有的Target实例中，都包含一些默认的Metadata标签信息。可以通过Prometheus UI的Targets页面中查看这些实例的Metadata标签的内容：

![实例的Metadata信息](https://www.prometheus.wang/sd/static/prometheus_file_target_metadata.png)实例的Metadata信息

默认情况下，当Prometheus加载Target实例完成后，这些Target时候都会包含一些默认的标签：

- `__address__`：当前Target实例的访问地址`<host>:<port>`
- `__scheme__`：采集目标服务访问地址的HTTP Scheme，HTTP或者HTTPS
- `__metrics_path__`：采集目标服务访问地址的访问路径
- `__param_<name>`：采集任务目标服务的中包含的请求参数

上面这些标签将会告诉Prometheus如何从该Target实例中获取监控数据。除了这些默认的标签以外，我们还可以为Target添加自定义的标签，例如，在“基于文件的服务发现”小节中的示例中，我们通过JSON配置文件，为Target实例添加了自定义标签env，如下所示该标签最终也会保存到从该实例采集的样本数据中：

```
node_cpu{cpu="cpu0",env="prod",instance="localhost:9100",job="node",mode="idle"}
```

一般来说，Target以`__`作为前置的标签是在系统内部使用的，因此这些标签不会被写入到样本数据中。不过这里有一些例外，例如，我们会发现所有通过Prometheus采集的样本数据中都会包含一个名为instance的标签，该标签的内容对应到Target实例的`__address__`。 这里实际上是发生了一次标签的重写处理。

这种发生在采集样本数据之前，对Target实例的标签进行重写的机制在Prometheus被称为Relabeling。

![Relabeling作用时机](https://www.prometheus.wang/sd/static/when-relabel-work.png)Relabeling作用时机

Prometheus允许用户在采集任务设置中通过relabel_configs来添加自定义的Relabeling过程。

## 使用replace/labelmap重写标签

Relabeling最基本的应用场景就是基于Target实例中包含的metadata标签，动态的添加或者覆盖标签。例如，通过Consul动态发现的服务实例还会包含以下Metadata标签信息：

- __meta_consul_address：consul地址
- __meta_consul_dc：consul中服务所在的数据中心
- __meta_consulmetadata：服务的metadata
- __meta_consul_node：服务所在consul节点的信息
- __meta_consul_service_address：服务访问地址
- __meta_consul_service_id：服务ID
- __meta_consul_service_port：服务端口
- __meta_consul_service：服务名称
- __meta_consul_tags：服务包含的标签信息

在默认情况下，从Node Exporter实例采集上来的样本数据如下所示：

```
node_cpu{cpu="cpu0",instance="localhost:9100",job="node",mode="idle"} 93970.8203125
```

我们希望能有一个额外的标签dc可以表示该样本所属的数据中心：

```
node_cpu{cpu="cpu0",instance="localhost:9100",job="node",mode="idle", dc="dc1"} 93970.8203125
```

在每一个采集任务的配置中可以添加多个relabel_config配置，一个最简单的relabel配置如下：

```
scrape_configs:
  - job_name: node_exporter
    consul_sd_configs:
      - server: localhost:8500
        services:
          - node_exporter
    relabel_configs:
    - source_labels:  ["__meta_consul_dc"]
      target_label: "dc"
```

该采集任务通过Consul动态发现Node  Exporter实例信息作为监控采集目标。在上一小节中，我们知道通过Consul动态发现的监控Target都会包含一些额外的Metadata标签，比如标签__meta_consul_dc表明了当前实例所在的Consul数据中心，因此我们希望从这些实例中采集到的监控样本中也可以包含这样一个标签，例如：

```
node_cpu{cpu="cpu0",dc="dc1",instance="172.21.0.6:9100",job="consul_sd",mode="guest"}
```

这样可以方便的根据dc标签的值，根据不同的数据中心聚合分析各自的数据。

在这个例子中，通过从Target实例中获取__meta_consul_dc的值，并且重写所有从该实例获取的样本中。

完整的relabel_config配置如下所示：

```
# The source labels select values from existing labels. Their content is concatenated
# using the configured separator and matched against the configured regular expression
# for the replace, keep, and drop actions.
[ source_labels: '[' <labelname> [, ...] ']' ]

# Separator placed between concatenated source label values.
[ separator: <string> | default = ; ]

# Label to which the resulting value is written in a replace action.
# It is mandatory for replace actions. Regex capture groups are available.
[ target_label: <labelname> ]

# Regular expression against which the extracted value is matched.
[ regex: <regex> | default = (.*) ]

# Modulus to take of the hash of the source label values.
[ modulus: <uint64> ]

# Replacement value against which a regex replace is performed if the
# regular expression matches. Regex capture groups are available.
[ replacement: <string> | default = $1 ]

# Action to perform based on regex matching.
[ action: <relabel_action> | default = replace ]
```

其中action定义了当前relabel_config对Metadata标签的处理方式，默认的action行为为replace。  replace行为会根据regex的配置匹配source_labels标签的值（多个source_label的值会按照separator进行拼接），并且将匹配到的值写入到target_label当中，如果有多个匹配组，则可以使用${1}, ${2}确定写入的内容。如果没匹配到任何内容则不对target_label进行重新。

repalce操作允许用户根据Target的Metadata标签重写或者写入新的标签键值对，在多环境的场景下，可以帮助用户添加与环境相关的特征维度，从而可以更好的对数据进行聚合。

除了使用replace以外，还可以定义action的配置为labelmap。与replace不同的是，labelmap会根据regex的定义去匹配Target实例所有标签的名称，并且以匹配到的内容为新的标签名称，其值作为新标签的值。

例如，在监控Kubernetes下所有的主机节点时，为将这些节点上定义的标签写入到样本中时，可以使用如下relabel_config配置：

```
- job_name: 'kubernetes-nodes'
  kubernetes_sd_configs:
  - role: node
  relabel_configs:
  - action: labelmap
    regex: __meta_kubernetes_node_label_(.+)
```

而使用labelkeep或者labeldrop则可以对Target标签进行过滤，仅保留符合过滤条件的标签，例如：

```
relabel_configs:
  - regex: label_should_drop_(.+)
    action: labeldrop
```

该配置会使用regex匹配当前Target实例的所有标签，并将符合regex规则的标签从Target实例中移除。labelkeep正好相反，会移除那些不匹配regex定义的所有标签。

## 使用keep/drop过滤Target实例

在上一部分中我们介绍了Prometheus的Relabeling机制，并且使用了replace/labelmap/labelkeep/labeldrop对标签进行管理。而本节开头还提到过第二个问题，使用中心化的服务发现注册中心时，所有环境的Exporter实例都会注册到该服务发现注册中心中。而不同职能（开发、测试、运维）的人员可能只关心其中一部分的监控数据，他们可能各自部署的自己的Prometheus Server用于监控自己关心的指标数据，如果让这些Prometheus  Server采集所有环境中的所有Exporter数据显然会存在大量的资源浪费。如何让这些不同的Prometheus  Server采集各自关心的内容？答案还是Relabeling，relabel_config的action除了默认的replace以外，还支持keep/drop行为。例如，如果我们只希望采集数据中心dc1中的Node Exporter实例的样本数据，那么可以使用如下配置：

```
scrape_configs:
  - job_name: node_exporter
    consul_sd_configs:
      - server: localhost:8500
        services:
          - node_exporter
    relabel_configs:
    - source_labels:  ["__meta_consul_dc"]
      regex: "dc1"
      action: keep
```

当action设置为keep时，Prometheus会丢弃source_labels的值中没有匹配到regex正则表达式内容的Target实例，而当action设置为drop时，则会丢弃那些source_labels的值匹配到regex正则表达式内容的Target实例。可以简单理解为keep用于选择，而drop用于排除。

## 使用hashmod计算source_labels的Hash值

当relabel_config设置为hashmod时，Prometheus会根据modulus的值作为系数，计算source_labels值的hash值。例如：

```
scrape_configs
- job_name: 'file_ds'
  relabel_configs:
    - source_labels: [__address__]
      modulus:       4
      target_label:  tmp_hash
      action:        hashmod
  file_sd_configs:
  - files:
    - targets.json
```

根据当前Target实例`__address__`的值以4作为系数，这样每个Target实例都会包含一个新的标签tmp_hash，并且该值的范围在1~4之间，查看Target实例的标签信息，可以看到如下的结果，每一个Target实例都包含了一个新的tmp_hash值：

![计算Hash值](https://www.prometheus.wang/sd/static/relabel_hash_mode.png)计算Hash值

在第6章的“Prometheus高可用”小节中，正是利用了Hashmod的能力在Target实例级别实现对采集任务的功能分区的:

```
scrape_configs:
  - job_name: some_job
    relabel_configs:
    - source_labels: [__address__]
      modulus:       4
      target_label:  __tmp_hash
      action:        hashmod
    - source_labels: [__tmp_hash]
      regex:         ^1$
      action:        keep
```

这里需要注意的是，如果relabel的操作只是为了产生一个临时变量，以作为下一个relabel操作的输入，那么我们可以使用`__tmp`作为标签名的前缀，通过该前缀定义的标签就不会写入到Target或者采集到的样本的标签中。

# 小结

相比于直接使用静态配置，在云环境以及容器环境下我们更多的监控对象都是动态的。通过服务发现，使得Prometheus相比于其他传统监控解决方案更适用于云以及容器环境下的监控需求。 

# 第8章 Kubernetes监控实战

Kubenetes是一款由Google开发的开源的容器编排工具，在Google已经使用超过15年。作为容器领域事实的标准，Kubernetes可以极大的简化应用的管理和部署复杂度。本章中，我们将介绍Kubernetes的一些基本概念，并且从0开始利用Prometheus构建一个完整的Kubernetes集群监控系统。同时我们还将学习如何通过Prometheus Operator简化在Kubernetes下部署和管理Promethues的过程。

本章的主要内容：

- 理解Kubernetes的工作机制
- Prometheus在Kubernetes下的服务发现机制
- 监控Kubernetes集群状态
- 监控集群基础设施基础设施
- 监控集群应用容器资源使用情况
- 监控用户部署的应用程序
- 对Service和Ingress进行网络探测
- 通过Operator高效管理和部署在Kubernetes集群中的Prometheus 

# 初识Kubernetes

Kubenetes是一款由Google开发的开源的容器编排工具（[GitHub源码](https://github.com/kubernetes/kubernetes)），在Google已经使用超过15年（Kubernetest前身是Google的内部工具Borg）。Kubernetes将一系列的主机看做是一个受管理的海量资源，这些海量资源组成了一个能够方便进行扩展的操作系统。而在Kubernetes中运行着的容器则可以视为是这个操作系统中运行的“进程”，通过Kubernetes这一中央协调器，解决了基于容器应用程序的调度、伸缩、访问负载均衡以及整个系统的管理和监控的问题。

## Kubernetes应用管理模型

下图展示了Kubernetes的应用管理模型：

![Kubernetes应用管理模型](https://www.prometheus.wang/kubernetes/static/kubernetes-app-model.png)Kubernetes应用管理模型

Pod是Kubernetes中的最小调度资源。Pod中会包含一组容器，它们一起工作，并且对外提供一个（或者一组）功能。对于这组容器而言它们共享相同的网络和存储资源，因此它们之间可以直接通过本地网络（127.0.0.1）进行访问。当Pod被创建时，调度器（kube-schedule）会从集群中找到满足条件的节点运行它。

如果部署应用程序时，需要启动多个实例（副本），则需要使用到控制器（Controller）。用户可以在Controller定义Pod的调度规则、运行的副本数量以及升级策略等等信息，当某些Pod发生故障之后，Controller会尝试自动修复，直到Pod的运行状态满足Controller中定义的预期状态为止。Kubernetes中提供了多种Controller的实现，包括：Deployment（无状态应用）、StatefulSet（有状态应用）、Daemonset（守护模式）等，以支持不同类型应用的部署和调度模式。

通过Controller和Pod我们定义了应用程序是如何运行的，接下来需要解决如何使用这些部署在Kubernetes集群中的应用。Kubernetes将这一问题划分为两个问题域，第一，集群内的应用如何通信。第二，外部的用户如何访问部署在集群内的应用？

对于第一个问题，在Kubernetes中通过定义Service（服务）来解决。Service在Kubernetes集群内扮演了服务发现和负载均衡的作用。在Kubernetes下部署的Pod实例都会包含一组描述自身信息的Lable，而创建Service，可以声明一个Selector（标签选择器）。Service通过Selector，找到匹配标签规则的Pod实例，并将对Service的请求转发到代理的Pod中。Service创建完成后，集群内的应用就可以通过使用Service的名称作为DNS域名进行相互访问。

而对于第二个问题，Kubernetes中定义了单独的资源Ingress（入口）。Ingress是一个工作在7层的负载均衡器，其负责代理外部进入集群内的请求，并将流量转发到对应的服务中。

最后，对于同一个Kubernetes集群其可能被多个组织使用，为了隔离这些不同组织创建的应用程序，Kubernetes定义了Namespace（命名空间）对资源进行隔离。

## Kubernetes架构模型

为了能够更好的理解Kubernetes下的监控体系，我们需要了解Kubernetes的基本架构，如下所示，是Kubernetes的架构示意图：

![Kubernetes架构](https://www.prometheus.wang/kubernetes/static/pre-ccm-arch.png)Kubernetes架构

Kubernetes的核心组件主要由两部分组成：Master组件和Node组件，其中Matser组件提供了集群层面的管理功能，它们负责响应用户请求并且对集群资源进行统一的调度和管理。Node组件会运行在集群的所有节点上，它们负责管理和维护节点中运行的Pod，为Kubernetes集群提供运行时环境。

Master组件主要包括：

- kube-apiserver：负责对外暴露Kubernetes API；
- etcd：用于存储Kubernetes集群的所有数据；
- kube-scheduler: 负责为新创建的Pod选择可供其运行的节点；
- kube-controller-manager： 包含Node Controller，Deployment Controller，Endpoint Controller等等，通过与apiserver交互使相应的资源达到预期状态。

Node组件主要包括：

- kubelet：负责维护和管理节点上Pod的运行状态；
- kube-proxy：负责维护主机上的网络规则以及转发。
- Container Runtime：如Docker,rkt,runc等提供容器运行时环境。

## Kubernetes监控策略

Kubernetes作为开源的容器编排工具，为用户提供了一个可以统一调度，统一管理的云操作系统。其解决如用户应用程序如何运行的问题。而一旦在生产环境中大量基于Kubernetes部署和管理应用程序后，作为系统管理员，还需要充分了解应用程序以及Kubernetes集群服务运行质量如何，通过对应用以及集群运行状态数据的收集和分析，持续优化和改进，从而提供一个安全可靠的生产运行环境。 这一小节中我们将讨论当使用Kubernetes时的监控策略该如何设计。

从物理结构上讲Kubernetes主要用于整合和管理底层的基础设施资源，对外提供应用容器的自动化部署和管理能力，这些基础设施可能是物理机、虚拟机、云主机等等。因此，基础资源的使用直接影响当前集群的容量和应用的状态。在这部分，我们需要关注集群中各个节点的主机负载，CPU使用率、内存使用率、存储空间以及网络吞吐等监控指标。

从自身架构上讲，kube-apiserver是Kubernetes提供所有服务的入口，无论是外部的客户端还是集群内部的组件都直接与kube-apiserver进行通讯。因此，kube-apiserver的并发和吞吐量直接决定了集群性能的好坏。其次，对于外部用户而言，Kubernetes是否能够快速的完成pod的调度以及启动，是影响其使用体验的关键因素。而这个过程主要由kube-scheduler负责完成调度工作，而kubelet完成pod的创建和启动工作。因此在Kubernetes集群本身我们需要评价其自身的服务质量，主要关注在Kubernetes的API响应时间，以及Pod的启动时间等指标上。

Kubernetes的最终目标还是需要为业务服务，因此我们还需要能够监控应用容器的资源使用情况。对于内置了对Prometheus支持的应用程序，也要支持从这些应用程序中采集内部的监控指标。最后，结合黑盒监控模式，对集群中部署的服务进行探测，从而当应用发生故障后，能够快速处理和恢复。

综上所述，我们需要综合使用白盒监控和黑盒监控模式，建立从基础设施，Kubernetes核心组件，应用容器等全面的监控体系。

在白盒监控层面我们需要关注：

- 基础设施层（Node）：为整个集群和应用提供运行时资源，需要通过各节点的kubelet获取节点的基本状态，同时通过在节点上部署Node Exporter获取节点的资源使用情况；
- 容器基础设施（Container）：为应用提供运行时环境，Kubelet内置了对cAdvisor的支持，用户可以直接通过Kubelet组件获取给节点上容器相关监控指标；
- 用户应用（Pod）：Pod中会包含一组容器，它们一起工作，并且对外提供一个（或者一组）功能。如果用户部署的应用程序内置了对Prometheus的支持，那么我们还应该采集这些Pod暴露的监控指标；
- Kubernetes组件：获取并监控Kubernetes核心组件的运行状态，确保平台自身的稳定运行。

而在黑盒监控层面，则主要需要关注以下：

- 内部服务负载均衡（Service）：在集群内，通过Service在集群暴露应用功能，集群内应用和应用之间访问时提供内部的负载均衡。通过Balckbox Exporter探测Service的可用性，确保当Service不可用时能够快速得到告警通知；
- 外部访问入口（Ingress）：通过Ingress提供集群外的访问入口，从而可以使外部客户端能够访问到部署在Kubernetes集群内的服务。因此也需要通过Blackbox Exporter对Ingress的可用性进行探测，确保外部用户能够正常访问集群内的功能；

## 搭建本地Kubernetes集群

为了能够更直观的了解和使用Kubernetes，我们将在本地通过工具Minikube(https://github.com/kubernetes/minikube)搭建一个本地的Kubernetes测试环境。Minikube会在本地通过虚拟机运行一个单节点的Kubernetes集群，可以方便用户或者开发人员在本地进行与Kubernetes相关的开发和测试工作。

安装MiniKube的方式很简单，对于Mac用户可以直接使用Brew进行安装:

```shell
brew cask install minikube
```

其它操作系统用户，可以查看Minikube项目的官方说明文档进行安装即可。安装完成后，在本机通过命令行启动Kubernetes集群:

```shell
$ minikube start
Starting local Kubernetes v1.7.5 cluster...
Starting VM...
SSH-ing files into VM...
Setting up certs...
Starting cluster components...
Connecting to cluster...
Setting up kubeconfig...
Kubectl is now configured to use the cluster.
```

MiniKube会自动配置本机的kubelet命令行工具，用于与对集群资源进行管理。同时Kubernetes也提供了一个Dashboard管理界面，在MiniKube下可以通过以下命令打开：

```shell
$ minikube dashboard
Opening kubernetes dashboard in default browser...
```

Kubernetes中的Dashboard本身也是通过Deployment进行部署的，因此可以通过MiniKube找到当前集群虚拟机的IP地址：

```shell
$ minikube ip
192.168.99.100
```

通过kubectl命令行工具，找到Dashboard对应的Service对外暴露的端口，如下所示，kubernetes-dashboard是一个NodePort类型的Service，并对外暴露了30000端口：

```shell
$ kubectl get service --namespace=kube-system
NAME                   TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)         AGE
kube-dns               ClusterIP   10.96.0.10       <none>        53/UDP,53/TCP   131d
kubernetes-dashboard   NodePort    10.105.168.160   <none>        80:30000/TCP    131d
```

在Dashbord中，用户可以可视化的管理当前集群中运行的所有资源，以及监视其资源运行状态。

![Kubernetes Dashboard](https://www.prometheus.wang/kubernetes/static/kubernetes-dashboard.png)Kubernetes Dashboard

Kubernetes环境准备完成后，就可以开始尝试在Kubernetes下尝试部署一个应用程序。Kubernetes中管理的所有资源都可以通过YAML文件进行描述。如下所示，创建了一个名为nginx-deploymeht.yml文件：

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.7.9
        ports:
        - containerPort: 80
```

在该YAML文件中，我们定义了需要创建的资源类型为Deployment，在metadata中声明了该Deployment的名称以及标签。spec中则定义了该Deployment的具体设置，通过replicas定义了该Deployment创建后将会自动创建3个Pod实例。运行的Pod以及进行则通过template进行定义。

在命令行中使用，如下命令：

```shell
$ kubectl create -f nginx-deploymeht.yml
deployment "nginx-deployment" created
```

在未指定命名空间的情况下，kubectl默认关联default命名空间。由于这里没有指定Namespace，该Deployment将会在默认的命令空间default中创建。 通过kubectl get命令查看当前Deployment的部署进度：

```shell
# 查看Deployment的运行状态
$ kubectl get deployments
NAME               DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3         3         3            3           1m

# 查看运行的Pod实例
$ kubectl get pods
NAME                                READY     STATUS    RESTARTS   AGE
nginx-deployment-6d8f46cfb7-5f9qm   1/1       Running   0          1m
nginx-deployment-6d8f46cfb7-9ppb8   1/1       Running   0          1m
nginx-deployment-6d8f46cfb7-nfmsw   1/1       Running   0          1m
```

为了能够让用户或者其它服务能够访问到Nginx实例，这里通过一个名为nginx-service.yml的文件定义Service资源：

```yaml
kind: Service
apiVersion: v1
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: NodePort
```

默认情况下，Service资源只能通过集群网络进行访问(type=ClusterIP)。这里为了能够直接访问该Service，需要将容器端口映射到主机上，因此定义该Service类型为NodePort。

创建并查看Service资源：

```shell
$ kubectl create -f nginx-service.yml
service "nginx-service" created

$ kubectl get svc
NAME            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
kubernetes      ClusterIP   10.96.0.1        <none>        443/TCP        131d
nginx-service   NodePort    10.104.103.112   <none>        80:32022/TCP   10s
```

通过nginx-server映射到虚拟机的32022端口，就可以直接访问到Nginx实例的80端口：

![Nginx主页](https://www.prometheus.wang/kubernetes/static/nginx-home-page.png)Nginx主页

部署完成后，如果需要对Nginx实例进行扩展，可以使用：

```shell
$ kubectl scale deployments/nginx-deployment --replicas=4
deployment "nginx-deployment" scaled
```

通过kubectl命令还可以对镜像进行滚动升级：

```shell
$ kubectl set image deployment/nginx-deployment nginx=nginx:1.9.1
deployment "nginx-deployment" image updated

$ kubectl get pods
NAME                                READY     STATUS              RESTARTS   AGE
nginx-deployment-58b94fcb9-8fjm6    0/1       ContainerCreating   0          52s
nginx-deployment-58b94fcb9-qzlwx    0/1       ContainerCreating   0          51s
nginx-deployment-6d8f46cfb7-5f9qm   1/1       Running             0          45m
nginx-deployment-6d8f46cfb7-7xs6z   0/1       Terminating         0          2m
nginx-deployment-6d8f46cfb7-9ppb8   1/1       Running             0          45m
nginx-deployment-6d8f46cfb7-nfmsw   1/1       Running             0          45m
```

如果升级后服务出现异常，那么可以通过以下命令对应用进行回滚：

```shell
$ kubectl rollout undo deployment/nginx-deployment
deployment "nginx-deployment"
```

Kubernetes依托于Google丰富的大规模应用管理经验。通过将集群环境抽象为一个统一调度和管理的云"操作系统，视容器为这个操作中独自运行的“进程”，进程间的隔离通过命名空间（Namespace）完成，实现了对应用生命周期管理从自动化到自主化的跨越。

# 在Kubernetes下部署Prometheus

在上一小节总我们介绍了与Kubernetes的应用管理模型，并且利用MiniKube在本地搭建了一个单节点的Kubernetes。这一部分我们将带领读者通过Kubernetes部署Prometheus实例。

## 使用ConfigMaps管理应用配置

当使用Deployment管理和部署应用程序时，用户可以方便了对应用进行扩容或者缩容，从而产生多个Pod实例。为了能够统一管理这些Pod的配置信息，在Kubernetes中可以使用ConfigMaps资源定义和管理这些配置，并且通过环境变量或者文件系统挂载的方式让容器使用这些配置。

这里将使用ConfigMaps管理Prometheus的配置文件，创建prometheus-config.yml文件，并写入以下内容：

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
data:
  prometheus.yml: |
    global:
      scrape_interval:     15s 
      evaluation_interval: 15s
    scrape_configs:
      - job_name: 'prometheus'
        static_configs:
        - targets: ['localhost:9090']
```

使用kubectl命令行工具，在命名空间default创建ConfigMap资源：

```
kubectl create -f prometheus-config.yml
configmap "prometheus-config" created
```

## 使用Deployment部署Prometheus

当ConfigMap资源创建成功后，我们就可以通过Volume挂载的方式，将Prometheus的配置文件挂载到容器中。  这里我们通过Deployment部署Prometheus  Server实例，创建prometheus-deployment.yml文件，并写入以下内容:

```
apiVersion: v1
kind: "Service"
metadata:
  name: prometheus
  labels:
    name: prometheus
spec:
  ports:
  - name: prometheus
    protocol: TCP
    port: 9090
    targetPort: 9090
  selector:
    app: prometheus
  type: NodePort
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  labels:
    name: prometheus
  name: prometheus
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: prometheus
    spec:
      containers:
      - name: prometheus
        image: prom/prometheus:v2.2.1
        command:
        - "/bin/prometheus"
        args:
        - "--config.file=/etc/prometheus/prometheus.yml"
        ports:
        - containerPort: 9090
          protocol: TCP
        volumeMounts:
        - mountPath: "/etc/prometheus"
          name: prometheus-config
      volumes:
      - name: prometheus-config
        configMap:
          name: prometheus-config
```

该文件中分别定义了Service和Deployment，Service类型为NodePort，这样我们可以通过虚拟机IP和端口访问到Prometheus实例。为了能够让Prometheus实例使用ConfigMap中管理的配置文件，这里通过volumes声明了一个磁盘卷。并且通过volumeMounts将该磁盘卷挂载到了Prometheus实例的/etc/prometheus目录下。

使用以下命令创建资源，并查看资源的创建情况：

```
$ kubectl create -f prometheus-deployment.yml
service "prometheus" created
deployment "prometheus" created

$ kubectl get pods
NAME                               READY     STATUS        RESTARTS   AGE
prometheus-55f655696d-wjqcl        1/1       Running       0          5s

$ kubectl get svc
NAME            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
kubernetes      ClusterIP   10.96.0.1        <none>        443/TCP          131d
prometheus      NodePort    10.101.255.236   <none>        9090:32584/TCP   42s
```

至此，我们可以通过MiniKube虚拟机的IP地址和端口32584访问到Prometheus的服务。

![Prometheus UI](https://www.prometheus.wang/kubernetes/static/kubernetes-prometheus-step1.png)Prometheus UI

# Kubernetes下的服务发现

目前为止，我们已经能够在Kubernetes下部署一个简单的Prometheus实例，不过当前来说它并不能发挥其监控系统的作用，除了Prometheus，暂时没有任何的监控采集目标。在第7章中，我们介绍了Prometheus的服务发现能力，它能够与通过与“中间代理人“的交互，从而动态的获取需要监控的目标实例。而在Kubernetes下Prometheus就是需要与Kubernetes的API进行交互，从而能够动态的发现Kubernetes中部署的所有可监控的目标资源。

## Kubernetes的访问授权

为了能够让Prometheus能够访问收到认证保护的Kubernetes  API，我们首先需要做的是，对Prometheus进行访问授权。在Kubernetes中主要使用基于角色的访问控制模型(Role-Based  Access  Control)，用于管理Kubernetes下资源访问权限。首先我们需要在Kubernetes下定义角色（ClusterRole），并且为该角色赋予响应的访问权限。同时创建Prometheus所使用的账号（ServiceAccount），最后则是将该账号与角色进行绑定（ClusterRoleBinding）。这些所有的操作在Kubernetes同样被视为是一系列的资源，可以通过YAML文件进行描述并创建，这里创建prometheus-rbac-setup.yml文件，并写入以下内容：

```
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  name: prometheus
rules:
- apiGroups: [""]
  resources:
  - nodes
  - nodes/proxy
  - services
  - endpoints
  - pods
  verbs: ["get", "list", "watch"]
- apiGroups:
  - extensions
  resources:
  - ingresses
  verbs: ["get", "list", "watch"]
- nonResourceURLs: ["/metrics"]
  verbs: ["get"]
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: prometheus
  namespace: default
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: prometheus
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: prometheus
subjects:
- kind: ServiceAccount
  name: prometheus
  namespace: default
```

其中需要注意的是ClusterRole是全局的，不需要指定命名空间。而ServiceAccount是属于特定命名空间的资源。通过kubectl命令创建RBAC对应的各个资源：

```
$ kubectl create -f prometheus-rbac-setup.yml
clusterrole "prometheus" created
serviceaccount "prometheus" created
clusterrolebinding "prometheus" created
```

在完成角色权限以及用户的绑定之后，就可以指定Prometheus使用特定的ServiceAccount创建Pod实例。修改prometheus-deployment.yml文件，并添加serviceAccountName和serviceAccount定义：

```
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: prometheus
    spec:
      serviceAccountName: prometheus
      serviceAccount: prometheus
```

通过kubectl apply对Deployment进行变更升级：

```
$ kubectl apply -f prometheus-deployment.yml
service "prometheus" configured
deployment "prometheus" configured

$ kubectl get pods
NAME                               READY     STATUS        RESTARTS   AGE
prometheus-55f655696d-wjqcl        0/1       Terminating   0          38m
prometheus-69f9ddb588-czn2c        1/1       Running       0          6s
```

指定ServiceAccount创建的Pod实例中，会自动将用于访问Kubernetes  API的CA证书以及当前账户对应的访问令牌文件挂载到Pod实例的/var/run/secrets/kubernetes.io/serviceaccount/目录下，可以通过以下命令进行查看：

```
kubectl exec -it prometheus-69f9ddb588-czn2c ls /var/run/secrets/kubernetes.io/serviceaccount/
ca.crt     namespace  token
```

## 服务发现

在Kubernetes下，Promethues通过与Kubernetes API集成目前主要支持5种服务发现模式，分别是：Node、Service、Pod、Endpoints、Ingress。

通过kubectl命令行，可以方便的获取到当前集群中的所有节点信息：

```
$ kubectl get nodes -o wide
NAME       STATUS    ROLES     AGE       VERSION   EXTERNAL-IP   OS-IMAGE            KERNEL-VERSION   CONTAINER-RUNTIME
minikube   Ready     <none>    164d      v1.8.0    <none>        Buildroot 2017.02   4.9.13           docker://Unknown
```

为了能够让Prometheus能够获取到当前集群中所有节点的信息，在Promtheus的配置文件中，我们添加如下Job配置：

```
- job_name: 'kubernetes-nodes'
  tls_config:
    ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
  bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
  kubernetes_sd_configs:
  - role: node
```

通过指定kubernetes_sd_config的模式为node，Prometheus会自动从Kubernetes中发现到所有的node节点并作为当前Job监控的Target实例。如下所示，这里需要指定用于访问Kubernetes API的ca以及token文件路径。

对于Ingress，Service，Endpoints, Pod的使用方式也是类似的，下面给出了一个完整Prometheus配置的示例：

```
apiVersion: v1
data:
  prometheus.yml: |-
    global:
      scrape_interval:     15s 
      evaluation_interval: 15s
    scrape_configs:

    - job_name: 'kubernetes-nodes'
      tls_config:
        ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
      bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
      kubernetes_sd_configs:
      - role: node

    - job_name: 'kubernetes-service'
      tls_config:
        ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
      bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
      kubernetes_sd_configs:
      - role: service

    - job_name: 'kubernetes-endpoints'
      tls_config:
        ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
      bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
      kubernetes_sd_configs:
      - role: endpoints

    - job_name: 'kubernetes-ingress'
      tls_config:
        ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
      bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
      kubernetes_sd_configs:
      - role: ingress

    - job_name: 'kubernetes-pods'
      tls_config:
        ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
      bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
      kubernetes_sd_configs:
      - role: pod

kind: ConfigMap
metadata:
  name: prometheus-config
```

更新Prometheus配置文件，并重建Prometheus实例：

```
$ kubectl apply -f prometheus-config.yml
configmap "prometheus-config" configured

$ kubectl get pods
prometheus-69f9ddb588-rbrs2        1/1       Running   0          4m

$ kubectl delete pods prometheus-69f9ddb588-rbrs2
pod "prometheus-69f9ddb588-rbrs2" deleted

$ kubectl get pods
prometheus-69f9ddb588-rbrs2        0/1       Terminating   0          4m
prometheus-69f9ddb588-wtlsn        1/1       Running       0          14s
```

Prometheus使用新的配置文件重建之后，打开Prometheus UI，通过Service Discovery页面可以查看到当前Prometheus通过Kubernetes发现的所有资源对象了：

![Service Discovery发现的实例](https://www.prometheus.wang/kubernetes/static/prometheus-k8s-sd-example1.png)Service Discovery发现的实例

同时Prometheus会自动将该资源的所有信息，并通过标签的形式体现在Target对象上。如下所示，是Promthues获取到的Node节点的标签信息：

```
__address__="192.168.99.100:10250"
__meta_kubernetes_node_address_Hostname="minikube"
__meta_kubernetes_node_address_InternalIP="192.168.99.100"
__meta_kubernetes_node_annotation_alpha_kubernetes_io_provided_node_ip="192.168.99.100"
__meta_kubernetes_node_annotation_node_alpha_kubernetes_io_ttl="0"
__meta_kubernetes_node_annotation_volumes_kubernetes_io_controller_managed_attach_detach="true"
__meta_kubernetes_node_label_beta_kubernetes_io_arch="amd64"
__meta_kubernetes_node_label_beta_kubernetes_io_os="linux"
__meta_kubernetes_node_label_kubernetes_io_hostname="minikube"
__meta_kubernetes_node_name="minikube"
__metrics_path__="/metrics"
__scheme__="https"
instance="minikube"
job="kubernetes-nodes"
```

目前为止，我们已经能够通过Prometheus自动发现Kubernetes集群中的各类资源以及其基本信息。不过，如果现在查看Promtheus的Target状态页面，结果可能会让人不太满意：

![Target页面状态](https://www.prometheus.wang/kubernetes/static/prometheus-k8s-sd-example3.png)Target页面状态

虽然Prometheus能够自动发现所有的资源对象，并且将其作为Target对象进行数据采集。  但并不是所有的资源对象都是支持Promethues的，并且不同类型资源对象的采集方式可能是不同的。因此，在实际的操作中，我们需要有明确的监控目标，并且针对不同类型的监控目标设置不同的数据采集方式。

接下来，我们将利用Promtheus的服务发现能力，实现对Kubernetes集群的全面监控。 

# 使用Prometheus监控Kubernetes集群

上一小节中，我们介绍了Promtheus在Kubernetes下的服务发现能力，并且通过kubernetes_sd_config实现了对Kubernetes下各类资源的自动发现。在本小节中，我们将带领读者利用Promethues提供的服务发现能力，实现对Kubernetes集群以及其中部署的各类资源的自动化监控。

下表中，梳理了监控Kubernetes集群监控的各个维度以及策略：

| 目标                                                         | 服务发现模式 | 监控方法 | 数据源            |
| ------------------------------------------------------------ | ------------ | -------- | ----------------- |
| 从集群各节点kubelet组件中获取节点kubelet的基本运行状态的监控指标 | node         | 白盒监控 | kubelet           |
| 从集群各节点kubelet内置的cAdvisor中获取，节点中运行的容器的监控指标 | node         | 白盒监控 | kubelet           |
| 从部署到各个节点的Node Exporter中采集主机资源相关的运行资源  | node         | 白盒监控 | node exporter     |
| 对于内置了Promthues支持的应用，需要从Pod实例中采集其自定义监控指标 | pod          | 白盒监控 | custom pod        |
| 获取API Server组件的访问地址，并从中获取Kubernetes集群相关的运行监控指标 | endpoints    | 白盒监控 | api server        |
| 获取集群中Service的访问地址，并通过Blackbox Exporter获取网络探测指标 | service      | 黑盒监控 | blackbox exporter |
| 获取集群中Ingress的访问信息，并通过Blackbox Exporter获取网络探测指标 | ingress      | 黑盒监控 | blackbox exporter |

## 从Kubelet获取节点运行状态

Kubelet组件运行在Kubernetes集群的各个节点中，其负责维护和管理节点上Pod的运行状态。kubelet组件的正常运行直接关系到该节点是否能够正常的被Kubernetes集群正常使用。

基于Node模式，Prometheus会自动发现Kubernetes中所有Node节点的信息并作为监控的目标Target。 而这些Target的访问地址实际上就是Kubelet的访问地址，并且Kubelet实际上直接内置了对Promtheus的支持。

修改prometheus.yml配置文件，并添加以下采集任务配置：

```
  - job_name: 'kubernetes-kubelet'
    scheme: https
    tls_config:
    ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
    kubernetes_sd_configs:
    - role: node
    relabel_configs:
    - action: labelmap
      regex: __meta_kubernetes_node_label_(.+)
```

这里使用Node模式自动发现集群中所有Kubelet作为监控的数据采集目标，同时通过labelmap步骤，将Node节点上的标签，作为样本的标签保存到时间序列当中。

重新加载promethues配置文件，并重建Promthues的Pod实例后，查看kubernetes-kubelet任务采集状态，我们会看到以下错误提示信息：

```
Get https://192.168.99.100:10250/metrics: x509: cannot validate certificate for 192.168.99.100 because it doesn't contain any IP SANs
```

这是由于当前使用的ca证书中，并不包含192.168.99.100的地址信息。为了解决该问题，第一种方法是直接跳过ca证书校验过程，通过在tls_config中设置 insecure_skip_verify为true即可。 这样Promthues在采集样本数据时，将会自动跳过ca证书的校验过程，从而从kubelet采集到监控数据：

```
  - job_name: 'kubernetes-kubelet'
      scheme: https
      tls_config:
        ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        insecure_skip_verify: true
      bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
      kubernetes_sd_configs:
      - role: node
      relabel_configs:
      - action: labelmap
        regex: __meta_kubernetes_node_label_(.+)
```

![直接采集kubelet监控指标](https://www.prometheus.wang/kubernetes/static/kubernetes-kubelets-step2.png)直接采集kubelet监控指标

第二种方式，不直接通过kubelet的metrics服务采集监控数据，而通过Kubernetes的api-server提供的代理API访问各个节点中kubelet的metrics服务，如下所示：

```
  - job_name: 'kubernetes-kubelet'
      scheme: https
      tls_config:
        ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
      bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
      kubernetes_sd_configs:
      - role: node
      relabel_configs:
      - action: labelmap
        regex: __meta_kubernetes_node_label_(.+)
      - target_label: __address__
        replacement: kubernetes.default.svc:443
      - source_labels: [__meta_kubernetes_node_name]
        regex: (.+)
        target_label: __metrics_path__
        replacement: /api/v1/nodes/${1}/proxy/metrics
```

通过relabeling，将从Kubernetes获取到的默认地址`__address__`替换为kubernetes.default.svc:443。同时将`__metrics_path__`替换为api-server的代理地址/api/v1/nodes/${1}/proxy/metrics。

![通过api-server代理获取kubelet监控指标](https://www.prometheus.wang/kubernetes/static/kubernetes-kubelets-step3.png)通过api-server代理获取kubelet监控指标

通过获取各个节点中kubelet的监控指标，用户可以评估集群中各节点的性能表现。例如,通过指标kubelet_pod_start_latency_microseconds可以获得当前节点中Pod启动时间相关的统计数据。

```
kubelet_pod_start_latency_microseconds{quantile="0.99"}
```

![99%的Pod启动时间](https://www.prometheus.wang/kubernetes/static/kubelet_pod_start_latency_microseconds.png)99%的Pod启动时间

Pod平均启动时间大致为42s左右（包含镜像下载时间）：

```
kubelet_pod_start_latency_microseconds_sum / kubelet_pod_start_latency_microseconds_count
```

![Pod平均启动时间](https://www.prometheus.wang/kubernetes/static/kubelet_pod_start_latency_microseconds_avg.png)Pod平均启动时间

除此以外，监控指标kubelet*docker**还可以体现出kubelet与当前节点的docker服务的调用情况，从而可以反映出docker本身是否会影响kubelet的性能表现等问题。

## 从Kubelet获取节点容器资源使用情况

各节点的kubelet组件中除了包含自身的监控指标信息以外，kubelet组件还内置了对cAdvisor的支持。cAdvisor能够获取当前节点上运行的所有容器的资源使用情况，通过访问kubelet的/metrics/cadvisor地址可以获取到cadvisor的监控指标，因此和获取kubelet监控指标类似，这里同样通过node模式自动发现所有的kubelet信息，并通过适当的relabel过程，修改监控采集任务的配置。 与采集kubelet自身监控指标相似，这里也有两种方式采集cadvisor中的监控指标：

方式一：直接访问kubelet的/metrics/cadvisor地址，需要跳过ca证书认证：

```
    - job_name: 'kubernetes-cadvisor'
      scheme: https
      tls_config:
        ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        insecure_skip_verify: true
      bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
      kubernetes_sd_configs:
      - role: node
      relabel_configs:
      - source_labels: [__meta_kubernetes_node_name]
        regex: (.+)
        target_label: __metrics_path__
        replacement: metrics/cadvisor
      - action: labelmap
        regex: __meta_kubernetes_node_label_(.+)
```

![直接访问kubelet](https://www.prometheus.wang/kubernetes/static/prometheus-cadvisor-step1.png)直接访问kubelet

方式二：通过api-server提供的代理地址访问kubelet的/metrics/cadvisor地址：

```
    - job_name: 'kubernetes-cadvisor'
      scheme: https
      tls_config:
        ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
      bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
      kubernetes_sd_configs:
      - role: node
      relabel_configs:
      - target_label: __address__
        replacement: kubernetes.default.svc:443
      - source_labels: [__meta_kubernetes_node_name]
        regex: (.+)
        target_label: __metrics_path__
        replacement: /api/v1/nodes/${1}/proxy/metrics/cadvisor
      - action: labelmap
        regex: __meta_kubernetes_node_label_(.+)
```

![使用api-server代理](https://www.prometheus.wang/kubernetes/static/prometheus-cadvisor-step2.png)使用api-server代理

## 使用NodeExporter监控集群资源使用情况

为了能够采集集群中各个节点的资源使用情况，我们需要在各节点中部署一个Node  Exporter实例。在本章的“部署Prometheus”小节，我们使用了Kubernetes内置的控制器之一Deployment。Deployment能够确保Prometheus的Pod能够按照预期的状态在集群中运行，而Pod实例可能随机运行在任意节点上。而与Prometheus的部署不同的是，对于Node  Exporter而言每个节点只需要运行一个唯一的实例，此时，就需要使用Kubernetes的另外一种控制器Daemonset。顾名思义，Daemonset的管理方式类似于操作系统中的守护进程。Daemonset会确保在集群中所有（也可以指定）节点上运行一个唯一的Pod实例。

创建node-exporter-daemonset.yml文件，并写入以下内容：

```
apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  name: node-exporter
spec:
  template:
    metadata:
      annotations:
        prometheus.io/scrape: 'true'
        prometheus.io/port: '9100'
        prometheus.io/path: 'metrics'
      labels:
        app: node-exporter
      name: node-exporter
    spec:
      containers:
      - image: prom/node-exporter
        imagePullPolicy: IfNotPresent
        name: node-exporter
        ports:
        - containerPort: 9100
          hostPort: 9100
          name: scrape
      hostNetwork: true
      hostPID: true
```

由于Node  Exporter需要能够访问宿主机，因此这里指定了hostNetwork和hostPID，让Pod实例能够以主机网络以及系统进程的形式运行。同时YAML文件中也创建了NodeExporter相应的Service。这样通过Service就可以访问到对应的NodeExporter实例。

```
$ kubectl create -f node-exporter-daemonset.yml
service "node-exporter" created
daemonset "node-exporter" created
```

查看Daemonset以及Pod的运行状态

```
$ kubectl get daemonsets
NAME            DESIRED   CURRENT   READY     UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
node-exporter   1         1         1         1            1           <none>          15s

$ kubectl get pods
NAME                               READY     STATUS    RESTARTS   AGE
...
node-exporter-9h56z                1/1       Running   0          51s
```

由于Node Exporter是以主机网络的形式运行，因此直接访问MiniKube的虚拟机IP加上Pod的端口即可访问当前节点上运行的Node Exporter实例:

```
$ minikube ip
192.168.99.100

$ curl http://192.168.99.100:9100/metrics
...
process_start_time_seconds 1.5251401593e+09
# HELP process_virtual_memory_bytes Virtual memory size in bytes.
# TYPE process_virtual_memory_bytes gauge
process_virtual_memory_bytes 1.1984896e+08
```

目前为止，通过Daemonset的形式将Node  Exporter部署到了集群中的各个节点中。接下来，我们只需要通过Prometheus的pod服务发现模式，找到当前集群中部署的Node  Exporter实例即可。  需要注意的是，由于Kubernetes中并非所有的Pod都提供了对Prometheus的支持，有些可能只是一些简单的用户应用，为了区分哪些Pod实例是可以供Prometheus进行采集的，这里我们为Node Exporter添加了注解：

```
prometheus.io/scrape: 'true'
```

由于Kubernetes中Pod可能会包含多个容器，还需要用户通过注解指定用户提供监控指标的采集端口：

```
prometheus.io/port: '9100'
```

而有些情况下，Pod中的容器可能并没有使用默认的/metrics作为监控采集路径，因此还需要支持用户指定采集路径：

```
prometheus.io/path: 'metrics'
```

为Prometheus创建监控采集任务kubernetes-pods，如下所示：

```
  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
    - role: pod
    relabel_configs:
    - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
      action: keep
      regex: true
    - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
      action: replace
      target_label: __metrics_path__
      regex: (.+)
    - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
      action: replace
      regex: ([^:]+)(?::\d+)?;(\d+)
      replacement: $1:$2
      target_label: __address__
    - action: labelmap
      regex: __meta_kubernetes_pod_label_(.+)
    - source_labels: [__meta_kubernetes_namespace]
      action: replace
      target_label: kubernetes_namespace
    - source_labels: [__meta_kubernetes_pod_name]
      action: replace
      target_label: kubernetes_pod_name
```

![通过Pod模式自动发现Node Exporter实例](https://www.prometheus.wang/kubernetes/static/prometheus-pods-sd-ex1.png)通过Pod模式自动发现Node Exporter实例

通过以上relabel过程实现对Pod实例的过滤，以及采集任务地址替换，从而实现对特定Pod实例监控指标的采集。需要说明的是kubernetes-pods并不是只针对Node  Exporter而言，对于用户任意部署的Pod实例，只要其提供了对Prometheus的支持，用户都可以通过为Pod添加注解的形式为其添加监控指标采集的支持。

## 从kube-apiserver获取集群运行监控指标

在开始正式内容之前，我们需要先了解一下Kubernetes中Service是如何实现负载均衡的，如下图所示，一般来说Service有两个主要的使用场景：

![Service负载均衡](https://www.prometheus.wang/kubernetes/static/kubernetes_service_endpoints.png)Service负载均衡

- 代理对集群内部应用Pod实例的请求：当创建Service时如果指定了标签选择器，Kubernetes会监听集群中所有的Pod变化情况，通过Endpoints自动维护满足标签选择器的Pod实例的访问信息；
- 代理对集群外部服务的请求：当创建Service时如果不指定任何的标签选择器，此时需要用户手动创建Service对应的Endpoint资源。例如，一般来说，为了确保数据的安全，我们通常讲数据库服务部署到集群外。 这是为了避免集群内的应用硬编码数据库的访问信息，这是就可以通过在集群内创建Service，并指向外部的数据库服务实例。

kube-apiserver扮演了整个Kubernetes集群管理的入口的角色，负责对外暴露Kubernetes  API。kube-apiserver组件一般是独立部署在集群外的，为了能够让部署在集群内的应用（kubernetes插件或者用户应用）能够与kube-apiserver交互，Kubernetes会默认在命名空间下创建一个名为kubernetes的服务，如下所示：

```
$ kubectl get svc kubernetes -o wide
NAME                  TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE       SELECTOR
kubernetes            ClusterIP   10.96.0.1       <none>        443/TCP          166d      <none>
```

而该kubernetes服务代理的后端实际地址通过endpoints进行维护，如下所示：

```
$ kubectl get endpoints kubernetes
NAME         ENDPOINTS        AGE
kubernetes   10.0.2.15:8443   166d
```

通过这种方式集群内的应用或者系统主机就可以通过集群内部的DNS域名kubernetes.default.svc访问到部署外部的kube-apiserver实例。

因此，如果我们想要监控kube-apiserver相关的指标，只需要通过endpoints资源找到kubernetes对应的所有后端地址即可。

如下所示，创建监控任务kubernetes-apiservers，这里指定了服务发现模式为endpoints。Promtheus会查找当前集群中所有的endpoints配置，并通过relabel进行判断是否为apiserver对应的访问地址：

```
    - job_name: 'kubernetes-apiservers'
      kubernetes_sd_configs:
      - role: endpoints
      scheme: https
      tls_config:
        ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
      bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
      relabel_configs:
      - source_labels: [__meta_kubernetes_namespace, __meta_kubernetes_service_name, __meta_kubernetes_endpoint_port_name]
        action: keep
        regex: default;kubernetes;https
      - target_label: __address__
        replacement: kubernetes.default.svc:443
```

在relabel_configs配置中第一步用于判断当前endpoints是否为kube-apiserver对用的地址。第二步，替换监控采集地址到kubernetes.default.svc:443即可。重新加载配置文件，重建Promthues实例，得到以下结果。

![apiserver任务状态](https://www.prometheus.wang/kubernetes/static/promethues-api-server-sd.eq1.png)apiserver任务状态

## 对Ingress和Service进行网络探测

为了能够对Ingress和Service进行探测，我们需要在集群部署Blackbox Exporter实例。 如下所示，创建blackbox-exporter.yaml用于描述部署相关的内容:

```
apiVersion: v1
kind: Service
metadata:
  labels:
    app: blackbox-exporter
  name: blackbox-exporter
spec:
  ports:
  - name: blackbox
    port: 9115
    protocol: TCP
  selector:
    app: blackbox-exporter
  type: ClusterIP
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  labels:
    app: blackbox-exporter
  name: blackbox-exporter
spec:
  replicas: 1
  selector:
    matchLabels:
      app: blackbox-exporter
  template:
    metadata:
      labels:
        app: blackbox-exporter
    spec:
      containers:
      - image: prom/blackbox-exporter
        imagePullPolicy: IfNotPresent
        name: blackbox-exporter
```

通过kubectl命令部署Blackbox Exporter实例，这里将部署一个Blackbox  Exporter的Pod实例，同时通过服务blackbox-exporter在集群内暴露访问地址blackbox-exporter.default.svc.cluster.local，对于集群内的任意服务都可以通过该内部DNS域名访问Blackbox Exporter实例：

```
$ kubectl get pods
NAME                                        READY     STATUS        RESTARTS   AGE
blackbox-exporter-f77fc78b6-72bl5           1/1       Running       0          4s

$ kubectl get svc
NAME                        TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
blackbox-exporter           ClusterIP   10.109.144.192   <none>        9115/TCP         3m
```

为了能够让Prometheus能够自动的对Service进行探测，我们需要通过服务发现自动找到所有的Service信息。 如下所示，在Prometheus的配置文件中添加名为kubernetes-services的监控采集任务：

```
    - job_name: 'kubernetes-services'
      metrics_path: /probe
      params:
        module: [http_2xx]
      kubernetes_sd_configs:
      - role: service
      relabel_configs:
      - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_probe]
        action: keep
        regex: true
      - source_labels: [__address__]
        target_label: __param_target
      - target_label: __address__
        replacement: blackbox-exporter.default.svc.cluster.local:9115
      - source_labels: [__param_target]
        target_label: instance
      - action: labelmap
        regex: __meta_kubernetes_service_label_(.+)
      - source_labels: [__meta_kubernetes_namespace]
        target_label: kubernetes_namespace
      - source_labels: [__meta_kubernetes_service_name]
        target_label: kubernetes_name
```

在该任务配置中，通过指定kubernetes_sd_config的role为service指定服务发现模式：

```
  kubernetes_sd_configs:
    - role: service
```

为了区分集群中需要进行探测的Service实例，我们通过标签‘prometheus.io/probe: true’进行判断，从而过滤出需要探测的所有Service实例：

```
      - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_probe]
        action: keep
        regex: true
```

并且将通过服务发现获取到的Service实例地址`__address__`转换为获取监控数据的请求参数。同时将`__address`执行Blackbox Exporter实例的访问地址，并且重写了标签instance的内容：

```
      - source_labels: [__address__]
        target_label: __param_target
      - target_label: __address__
        replacement: blackbox-exporter.default.svc.cluster.local:9115
      - source_labels: [__param_target]
        target_label: instance
```

最后，为监控样本添加了额外的标签信息：

```
      - action: labelmap
        regex: __meta_kubernetes_service_label_(.+)
      - source_labels: [__meta_kubernetes_namespace]
        target_label: kubernetes_namespace
      - source_labels: [__meta_kubernetes_service_name]
        target_label: kubernetes_name
```

对于Ingress而言，也是一个相对类似的过程，这里给出对Ingress探测的Promthues任务配置作为参考：

```
    - job_name: 'kubernetes-ingresses'
      metrics_path: /probe
      params:
        module: [http_2xx]
      kubernetes_sd_configs:
      - role: ingress
      relabel_configs:
      - source_labels: [__meta_kubernetes_ingress_annotation_prometheus_io_probe]
        action: keep
        regex: true
      - source_labels: [__meta_kubernetes_ingress_scheme,__address__,__meta_kubernetes_ingress_path]
        regex: (.+);(.+);(.+)
        replacement: ${1}://${2}${3}
        target_label: __param_target
      - target_label: __address__
        replacement: blackbox-exporter.default.svc.cluster.local:9115
      - source_labels: [__param_target]
        target_label: instance
      - action: labelmap
        regex: __meta_kubernetes_ingress_label_(.+)
      - source_labels: [__meta_kubernetes_namespace]
        target_label: kubernetes_namespace
      - source_labels: [__meta_kubernetes_ingress_name]
        target_label: kubernetes_name
```

# 基于Prometheus的弹性伸缩

弹性伸缩（AutoScaling）是指应用可以根据当前的资源使用情况自动水平扩容或者缩容的能力。 

# 小结

Kubernetes与Promethues有着十分相似的历程，均是源自Google内部多年的运维经验。并且相继从CNCF基金会正式毕业。它们分别代表了云原生模式下容器编排以及监控的事实标准。 

# 第9章 Prometheus Operator

本章，我们将介绍如何使用Prometheus Operator简化在Kubernetes下部署和管理Prmetheus的复杂度。

本章的主要内容：

- 为什么需要使用Prometheus Operator
- Prometheus Operator的主要概念
- 如何利用Prometheus Operator自动化运维Prometheus
- 如何使用Prometheus Operator自动化管理监控配置 

# 什么是Prometheus Operator

在第8章章中，为了在Kubernetes能够方便的管理和部署Prometheus，我们使用ConfigMap了管理Prometheus配置文件。每次对Prometheus配置文件进行升级时，，我们需要手动移除已经运行的Pod实例，从而让Kubernetes可以使用最新的配置文件创建Prometheus。 而如果当应用实例的数量更多时，通过手动的方式部署和升级Prometheus过程繁琐并且效率低下。

从本质上来讲Prometheus属于是典型的有状态应用，而其有包含了一些自身特有的运维管理和配置管理方式。而这些都无法通过Kubernetes原生提供的应用管理概念实现自动化。为了简化这类应用程序的管理复杂度，CoreOS率先引入了Operator的概念，并且首先推出了针对在Kubernetes下运行和管理Etcd的Etcd Operator。并随后推出了Prometheus Operator。

## Prometheus Operator的工作原理

从概念上来讲Operator就是针对管理特定应用程序的，在Kubernetes基本的Resource和Controller的概念上，以扩展Kubernetes api的形式。帮助用户创建，配置和管理复杂的有状态应用程序。从而实现特定应用程序的常见操作以及运维自动化。

在Kubernetes中我们使用Deployment、DamenSet，StatefulSet来管理应用Workload，使用Service，Ingress来管理应用的访问方式，使用ConfigMap和Secret来管理应用配置。我们在集群中对这些资源的创建，更新，删除的动作都会被转换为事件(Event)，Kubernetes的Controller  Manager负责监听这些事件并触发相应的任务来满足用户的期望。这种方式我们成为声明式，用户只需要关心应用程序的最终状态，其它的都通过Kubernetes来帮助我们完成，通过这种方式可以大大简化应用的配置管理复杂度。

而除了这些原生的Resource资源以外，Kubernetes还允许用户添加自己的自定义资源(Custom Resource)。并且通过实现自定义Controller来实现对Kubernetes的扩展。

如下所示，是Prometheus Operator的架构示意图：

![Prometheus Operator架构](https://www.prometheus.wang/operator/static/prometheus-architecture.png)Prometheus Operator架构

Prometheus的本职就是一组用户自定义的CRD资源以及Controller的实现，Prometheus Operator负责监听这些自定义资源的变化，并且根据这些资源的定义自动化的完成如Prometheus Server自身以及配置的自动化管理工作。

## Prometheus Operator能做什么

要了解Prometheus Operator能做什么，其实就是要了解Prometheus Operator为我们提供了哪些自定义的Kubernetes资源，列出了Prometheus Operator目前提供的️4类资源：

- Prometheus：声明式创建和管理Prometheus Server实例；
- ServiceMonitor：负责声明式的管理监控配置；
- PrometheusRule：负责声明式的管理告警配置；
- Alertmanager：声明式的创建和管理Alertmanager实例。

简言之，Prometheus Operator能够帮助用户自动化的创建以及管理Prometheus Server以及其相应的配置。

## 在Kubernetes集群中部署Prometheus Operator

在Kubernetes中安装Prometheus Operator非常简单，用户可以从以下地址中过去Prometheus Operator的源码：

```
git clone https://github.com/coreos/prometheus-operator.git
```

这里，我们为Promethues Operator创建一个单独的命名空间monitoring：

```
kubectl create namespace monitoring
```

由于需要对Prometheus  Operator进行RBAC授权，而默认的bundle.yaml中使用了default命名空间，因此，在安装Prometheus  Operator之前需要先替换一下bundle.yaml文件中ClusterRoleBinding以及ServiceAccount的namespace定义。 通过运行一下命令安装Prometheus Operator的Deployment实例：

```
$ kubectl -n monitoring apply -f bundle.yaml
clusterrolebinding.rbac.authorization.k8s.io/prometheus-operator created
clusterrole.rbac.authorization.k8s.io/prometheus-operator created
deployment.apps/prometheus-operator created
serviceaccount/prometheus-operator created
```

Prometheus Operator通过Deployment的形式进行部署，为了能够让Prometheus Operator能够监听和管理Kubernetes资源同时也创建了单独的ServiceAccount以及相关的授权动作。

查看Prometheus Operator部署状态，以确保已正常运行：

```
$ kubectl -n monitoring get pods
NAME                                   READY     STATUS    RESTARTS   AGE
prometheus-operator-6db8dbb7dd-2hz55   1/1       Running   0          19s
```

# 使用Operator管理Prometheus

## 创建Prometheus实例

当集群中已经安装Prometheus Operator之后，对于部署Prometheus Server实例就变成了声明一个Prometheus资源，如下所示，我们在Monitoring命名空间下创建一个Prometheus实例：

```
apiVersion: monitoring.coreos.com/v1
kind: Prometheus
metadata:
  name: inst
  namespace: monitoring
spec:
  resources:
    requests:
      memory: 400Mi
```

将以上内容保存到prometheus-inst.yaml文件，并通过kubectl进行创建：

```
$ kubectl create -f prometheus-inst.yaml
prometheus.monitoring.coreos.com/inst-1 created
```

此时，查看default命名空间下的statefulsets资源，可以看到Prometheus Operator自动通过Statefulset创建的Prometheus实例：

```
$ kubectl -n monitoring get statefulsets
NAME              DESIRED   CURRENT   AGE
prometheus-inst   1         1         1m
```

查看Pod实例：

```
$ kubectl -n monitoring get pods
NAME                                   READY     STATUS    RESTARTS   AGE
prometheus-inst-0                      3/3       Running   1          1m
prometheus-operator-6db8dbb7dd-2hz55   1/1       Running   0          45m
```

通过port-forward访问Prometheus实例:

```
$ kubectl -n monitoring port-forward statefulsets/prometheus-inst 9090:9090
```

通过http://localhost:9090可以在本地直接打开Prometheus Operator创建的Prometheus实例。查看配置信息，可以看到目前Operator创建了只包含基本配置的Prometheus实例：

![img](https://www.prometheus.wang/operator/static/operator-01.png)

## 使用ServiceMonitor管理监控配置

修改监控配置项也是Prometheus下常用的运维操作之一，为了能够自动化的管理Prometheus的配置，Prometheus Operator使用了自定义资源类型ServiceMonitor来描述监控对象的信息。

这里我们首先在集群中部署一个示例应用，将以下内容保存到example-app.yaml，并使用kubectl命令行工具创建：

```
kind: Service
apiVersion: v1
metadata:
  name: example-app
  labels:
    app: example-app
spec:
  selector:
    app: example-app
  ports:
  - name: web
    port: 8080
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: example-app
spec:
  replicas: 3
  template:
    metadata:
      labels:
        app: example-app
    spec:
      containers:
      - name: example-app
        image: fabxc/instrumented_app
        ports:
        - name: web
          containerPort: 8080
```

示例应用会通过Deployment创建3个Pod实例，并且通过Service暴露应用访问信息。

```
$ kubectl get pods
NAME                        READY     STATUS    RESTARTS   AGE
example-app-94c8bc8-l27vx   2/2       Running   0          1m
example-app-94c8bc8-lcsrm   2/2       Running   0          1m
example-app-94c8bc8-n6wp5   2/2       Running   0          1m
```

在本地同样通过port-forward访问任意Pod实例

```
$ kubectl port-forward deployments/example-app 8080:8080
```

访问本地的http://localhost:8080/metrics实例应用程序会返回以下样本数据：

```
# TYPE codelab_api_http_requests_in_progress gauge
codelab_api_http_requests_in_progress 3
# HELP codelab_api_request_duration_seconds A histogram of the API HTTP request durations in seconds.
# TYPE codelab_api_request_duration_seconds histogram
codelab_api_request_duration_seconds_bucket{method="GET",path="/api/bar",status="200",le="0.0001"} 0
```

为了能够让Prometheus能够采集部署在Kubernetes下应用的监控数据，在原生的Prometheus配置方式中，我们在Prometheus配置文件中定义单独的Job，同时使用kubernetes_sd定义整个服务发现过程。而在Prometheus Operator中，则可以直接生命一个ServiceMonitor对象，如下所示：

```
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: example-app
  namespace: monitoring
  labels:
    team: frontend
spec:
  namespaceSelector:
    matchNames:
    - default
  selector:
    matchLabels:
      app: example-app
  endpoints:
  - port: web
```

通过定义selector中的标签定义选择监控目标的Pod对象，同时在endpoints中指定port名称为web的端口。默认情况下ServiceMonitor和监控对象必须是在相同Namespace下的。在本示例中由于Prometheus是部署在Monitoring命名空间下，因此为了能够关联default命名空间下的example对象，需要使用namespaceSelector定义让其可以跨命名空间关联ServiceMonitor资源。保存以上内容到example-app-service-monitor.yaml文件中，并通过kubectl创建：

```
$ kubectl create -f example-app-service-monitor.yaml
servicemonitor.monitoring.coreos.com/example-app created
```

如果希望ServiceMonitor可以关联任意命名空间下的标签，则通过以下方式定义：

```
spec:
  namespaceSelector:
    any: true
```

如果监控的Target对象启用了BasicAuth认证，那在定义ServiceMonitor对象时，可以使用endpoints配置中定义basicAuth如下所示：

```
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: example-app
  namespace: monitoring
  labels:
    team: frontend
spec:
  namespaceSelector:
    matchNames:
    - default
  selector:
    matchLabels:
      app: example-app
  endpoints:
  - basicAuth:
      password:
        name: basic-auth
        key: password
      username:
        name: basic-auth
        key: user
    port: web
```

其中basicAuth中关联了名为basic-auth的Secret对象，用户需要手动将认证信息保存到Secret中:

```
apiVersion: v1
kind: Secret
metadata:
  name: basic-auth
data:
  password: dG9vcg== # base64编码后的密码
  user: YWRtaW4= # base64编码后的用户名
type: Opaque
```

## 关联Promethues与ServiceMonitor

Prometheus与ServiceMonitor之间的关联关系使用serviceMonitorSelector定义，在Prometheus中通过标签选择当前需要监控的ServiceMonitor对象。修改prometheus-inst.yaml中Prometheus的定义如下所示： 为了能够让Prometheus关联到ServiceMonitor，需要在Pormtheus定义中使用serviceMonitorSelector，我们可以通过标签选择当前Prometheus需要监控的ServiceMonitor对象。修改prometheus-inst.yaml中Prometheus的定义如下所示：

```
apiVersion: monitoring.coreos.com/v1
kind: Prometheus
metadata:
  name: inst
  namespace: monitoring
spec:
  serviceMonitorSelector:
    matchLabels:
      team: frontend
  resources:
    requests:
      memory: 400Mi
```

将对Prometheus的变更应用到集群中：

```
$ kubectl -n monitoring apply -f prometheus-inst.yaml
```

此时，如果查看Prometheus配置信息，我们会惊喜的发现Prometheus中配置文件自动包含了一条名为monitoring/example-app/0的Job配置：

```
global:
  scrape_interval: 30s
  scrape_timeout: 10s
  evaluation_interval: 30s
  external_labels:
    prometheus: monitoring/inst
    prometheus_replica: prometheus-inst-0
alerting:
  alert_relabel_configs:
  - separator: ;
    regex: prometheus_replica
    replacement: $1
    action: labeldrop
rule_files:
- /etc/prometheus/rules/prometheus-inst-rulefiles-0/*.yaml
scrape_configs:
- job_name: monitoring/example-app/0
  scrape_interval: 30s
  scrape_timeout: 10s
  metrics_path: /metrics
  scheme: http
  kubernetes_sd_configs:
  - role: endpoints
    namespaces:
      names:
      - default
  relabel_configs:
  - source_labels: [__meta_kubernetes_service_label_app]
    separator: ;
    regex: example-app
    replacement: $1
    action: keep
  - source_labels: [__meta_kubernetes_endpoint_port_name]
    separator: ;
    regex: web
    replacement: $1
    action: keep
  - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
    separator: ;
    regex: Node;(.*)
    target_label: node
    replacement: ${1}
    action: replace
  - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
    separator: ;
    regex: Pod;(.*)
    target_label: pod
    replacement: ${1}
    action: replace
  - source_labels: [__meta_kubernetes_namespace]
    separator: ;
    regex: (.*)
    target_label: namespace
    replacement: $1
    action: replace
  - source_labels: [__meta_kubernetes_service_name]
    separator: ;
    regex: (.*)
    target_label: service
    replacement: $1
    action: replace
  - source_labels: [__meta_kubernetes_pod_name]
    separator: ;
    regex: (.*)
    target_label: pod
    replacement: $1
    action: replace
  - source_labels: [__meta_kubernetes_service_name]
    separator: ;
    regex: (.*)
    target_label: job
    replacement: ${1}
    action: replace
  - separator: ;
    regex: (.*)
    target_label: endpoint
    replacement: web
    action: replace
```

不过，如果细心的读者可能会发现，虽然Job配置有了，但是Prometheus的Target中并没包含任何的监控对象。查看Prometheus的Pod实例日志，可以看到如下信息：

```
level=error ts=2018-12-15T12:52:48.452108433Z caller=main.go:240 component=k8s_client_runtime err="github.com/prometheus/prometheus/discovery/kubernetes/kubernetes.go:300: Failed to list *v1.Endpoints: endpoints is forbidden: User \"system:serviceaccount:monitoring:default\" cannot list endpoints in the namespace \"default\""
```

## 自定义ServiceAccount

由于默认创建的Prometheus实例使用的是monitoring命名空间下的default账号，该账号并没有权限能够获取default命名空间下的任何资源信息。

为了修复这个问题，我们需要在Monitoring命名空间下为创建一个名为Prometheus的ServiceAccount，并且为该账号赋予相应的集群访问权限。

```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: prometheus
  namespace: monitoring
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  name: prometheus
rules:
- apiGroups: [""]
  resources:
  - nodes
  - services
  - endpoints
  - pods
  verbs: ["get", "list", "watch"]
- apiGroups: [""]
  resources:
  - configmaps
  verbs: ["get"]
- nonResourceURLs: ["/metrics"]
  verbs: ["get"]
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: prometheus
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: prometheus
subjects:
- kind: ServiceAccount
  name: prometheus
  namespace: monitoring
```

将以上内容保存到prometheus-rbac.yaml文件中，并且通过kubectl创建相应资源：

```
$ kubectl -n monitoring create -f prometheus-rbac.yaml
serviceaccount/prometheus created
clusterrole.rbac.authorization.k8s.io/prometheus created
clusterrolebinding.rbac.authorization.k8s.io/prometheus created
```

在完成ServiceAccount创建后，修改prometheus-inst.yaml，并添加ServiceAccount如下所示：

```
apiVersion: monitoring.coreos.com/v1
kind: Prometheus
metadata:
  name: inst
  namespace: monitoring
spec:
  serviceAccountName: prometheus
  serviceMonitorSelector:
    matchLabels:
      team: frontend
  resources:
    requests:
      memory: 400Mi
```

保存Prometheus变更到集群中：

```
$ kubectl -n monitoring apply -f prometheus-inst.yaml
prometheus.monitoring.coreos.com/inst configured
```

等待Prometheus Operator完成相关配置变更后，此时查看Prometheus，我们就能看到当前Prometheus已经能够正常的采集实例应用的相关监控数据了。

## 使用Operator管理告警

### 使用PrometheusRule定义告警规则

对于Prometheus而言，在原生的管理方式上，我们需要手动创建Prometheus的告警文件，并且通过在Prometheus配置中声明式的加载。而在Prometheus Operator模式中，告警规则也编程一个通过Kubernetes API 声明式创建的一个资源，如下所示：

```
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  labels:
    prometheus: example
    role: alert-rules
  name: prometheus-example-rules
spec:
  groups:
  - name: ./example.rules
    rules:
    - alert: ExampleAlert
      expr: vector(1)
```

将以上内容保存为example-rule.yaml文件，并且通过kubectl命令创建相应的资源：

```
$ kubectl -n monitoring create -f example-rule.yaml
prometheusrule "prometheus-example-rules" created
```

告警规则创建成功后，通过在Prometheus中使用ruleSelector通过选择需要关联的PrometheusRule即可：

```
apiVersion: monitoring.coreos.com/v1
kind: Prometheus
metadata:
  name: inst
  namespace: monitoring
spec:
  serviceAccountName: prometheus
  serviceMonitorSelector:
    matchLabels:
      team: frontend
  ruleSelector:
    matchLabels:
      role: alert-rules
      prometheus: example
  resources:
    requests:
      memory: 400Mi
```

Prometheus重新加载配置后，从UI中我们可以查看到通过PrometheusRule自动创建的告警规则配置：

![Prometheus告警规则](https://www.prometheus.wang/operator/static/prometheus-rule.png)Prometheus告警规则

如果查看Alerts页面，我们会看到告警已经处于触发状态。

### 使用Operator管理Alertmanager实例

到目前为止，我们已经通过Prometheus  Operator的自定义资源类型管理了Promtheus的实例，监控配置以及告警规则等资源。通过Prometheus  Operator将原本手动管理的工作全部变成声明式的管理模式，大大简化了Kubernetes下的Prometheus运维管理的复杂度。  接下来，我们将继续使用Promtheus Operator定义和管理Alertmanager相关的内容。

为了通过Prometheus Operator管理Alertmanager实例，用户可以通过自定义资源Alertmanager进行定义，如下所示，通过replicas可以控制Alertmanager的实例数：

```
apiVersion: monitoring.coreos.com/v1
kind: Alertmanager
metadata:
  name: inst
  namespace: monitoring
spec:
  replicas: 3
```

当replicas大于1时，Prometheus Operator会自动通过集群的方式创建Alertmanager。将以上内容保存为文件alertmanager-inst.yaml，并通过以下命令创建：

```
$ kubectl -n monitoring create -f alertmanager-inst.yaml
alertmanager.monitoring.coreos.com/inst created
```

查看Pod的情况如下所示，我们会发现Alertmanager的Pod实例一直处于ContainerCreating的状态中:

```
$ kubectl -n monitoring get pods
NAME                                   READY     STATUS              RESTARTS   AGE
alertmanager-inst-0                    0/2       ContainerCreating   0          32s
```

通过kubectl describe命令查看该Alertmanager的Pod实例状态，可以看到类似于以下内容的告警信息：

```
MountVolume.SetUp failed for volume "config-volume" : secrets "alertmanager-inst" not found
```

这是由于Prometheus Operator通过Statefulset的方式创建的Alertmanager实例，在默认情况下，会通过`alertmanager-{ALERTMANAGER_NAME}`的命名规则去查找Secret配置并以文件挂载的方式，将Secret的内容作为配置文件挂载到Alertmanager实例当中。因此，这里还需要为Alertmanager创建相应的配置内容，如下所示，是Alertmanager的配置文件：

```
global:
  resolve_timeout: 5m
route:
  group_by: ['job']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 12h
  receiver: 'webhook'
receivers:
- name: 'webhook'
  webhook_configs:
  - url: 'http://alertmanagerwh:30500/'
```

将以上内容保存为文件alertmanager.yaml，并且通过以下命令创建名为alrtmanager-inst的Secret资源：

```
$ kubectl -n monitoring create secret generic alertmanager-inst --from-file=alertmanager.yaml
secret/alertmanager-inst created
```

在Secret创建成功后，查看当前Alertmanager Pod实例状态。如下所示：

```
$ kubectl -n monitoring get pods
NAME                                   READY     STATUS    RESTARTS   AGE
alertmanager-inst-0                    2/2       Running   0          5m
alertmanager-inst-1                    2/2       Running   0          52s
alertmanager-inst-2                    2/2       Running   0          37s
```

使用port-forward将Alertmanager映射到本地：

```
$ kubectl -n monitoring port-forward statefulsets/alertmanager-inst 9093:9093
```

访问http://localhost:9093/#/status，并查看当前集群状态：

![Alertmanager集群状态](https://www.prometheus.wang/operator/static/prometheus-alert-cluster-status.png)Alertmanager集群状态

接下来，我们只需要修改我们的Prometheus资源定义，通过alerting指定使用的Alertmanager资源即可：

```
apiVersion: monitoring.coreos.com/v1
kind: Prometheus
metadata:
  name: inst
  namespace: monitoring
spec:
  serviceAccountName: prometheus
  serviceMonitorSelector:
    matchLabels:
      team: frontend
  ruleSelector:
    matchLabels:
      role: alert-rules
      prometheus: example
  alerting:
    alertmanagers:
    - name: alertmanager-example
      namespace: monitoring
      port: web
  resources:
    requests:
      memory: 400Mi
```

等待Prometheus重新加载后，我们可以看到Prometheus Operator在配置文件中添加了以下配置：

```
  alertmanagers:
  - kubernetes_sd_configs:
    - role: endpoints
      namespaces:
        names:
        - monitoring
    scheme: http
    path_prefix: /
    timeout: 10s
    relabel_configs:
    - source_labels: [__meta_kubernetes_service_name]
      separator: ;
      regex: alertmanager-example
      replacement: $1
      action: keep
    - source_labels: [__meta_kubernetes_endpoint_port_name]
      separator: ;
      regex: web
      replacement: $1
      action: keep
```

通过服务发现规则将Prometheus与Alertmanager进行了自动关联。 

# 在Prometheus Operator中使用自定义配置

在Prometheus Operator我们通过声明式的创建如Prometheus,  ServiceMonitor这些自定义的资源类型来自动化部署和管理Prometheus的相关组件以及配置。而在一些特殊的情况下，对于用户而言，可能还是希望能够手动管理Prometheus配置文件，而非通过Prometheus Operator自动完成。 为什么？ 实际上Prometheus  Operator对于Job的配置只适用于在Kubernetes中部署和管理的应用程序。如果你希望使用Prometheus监控一些其他的资源，例如AWS或者其他平台中的基础设施或者应用，这些并不在Prometheus Operator的能力范围之内。

为了能够在通过Prometheus Operator创建的Prometheus实例中使用自定义配置文件，我们只能创建一个不包含任何与配置文件内容相关的Prometheus实例

```
apiVersion: monitoring.coreos.com/v1
kind: Prometheus
metadata:
  name: inst-cc
  namespace: monitoring
spec:
  serviceAccountName: prometheus
  resources:
    requests:
      memory: 400Mi
```

将以上内容保存到prometheus-inst-cc.yaml文件中，并且通过kubectl创建:

```
$ kubectl -n monitoring create -f prometheus-inst-cc.yaml
prometheus.monitoring.coreos.com/inst-cc created
```

如果查看新建Prometheus的Pod实例YAML定义，我们可以看到Pod中会包含一个volume配置：

```
volumes:
  - name: config
    secret:
      defaultMode: 420
      secretName: prometheus-inst-cc
```

Prometheus的配置文件实际上是保存在名为`prometheus-<name-of-prometheus-object>`的Secret中，当用户创建的Prometheus中关联ServiceMonitor这类会影响配置文件内容的定义时，Promethues Operator会自动管理。而如果Prometheus定义中不包含任何与配置相关的定义，那么Secret的管理权限就落到了用户自己手中。

通过修改prometheus-inst-cc的内容，从而可以让用户可以使用自定义的Prometheus配置文件，作为示例，我们创建一个prometheus.yaml文件并添加以下内容：

```
global:
  scrape_interval: 10s
  scrape_timeout: 10s
  evaluation_interval: 10s
```

生成文件内容的base64编码后的内容：

```
$ cat prometheus.yaml | base64
Z2xvYmFsOgogIHNjcmFwZV9pbnRlcnZhbDogMTBzCiAgc2NyYXBlX3RpbWVvdXQ6IDEwcwogIGV2YWx1YXRpb25faW50ZXJ2YWw6IDEwcw==
```

修改名为prometheus-inst-cc的Secret内容，如下所示：

```
$ kubectl -n monitoring edit secret prometheus-inst-cc
# 省略其它内容
data:
  prometheus.yaml: "Z2xvYmFsOgogIHNjcmFwZV9pbnRlcnZhbDogMTBzCiAgc2NyYXBlX3RpbWVvdXQ6IDEwcwogIGV2YWx1YXRpb25faW50ZXJ2YWw6IDEwcw=="
```

通过port-forward在本地访问新建的Prometheus实例，观察配置文件变化即可：

```
kubectl -n monitoring port-forward statefulsets/prometheus-inst-cc 9091:9090
```
