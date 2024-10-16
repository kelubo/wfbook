# FAQ

[TOC]

## 常规

### 什么是 Prometheus？

Prometheus 是一个开源系统监控和警报工具包，拥有活跃的生态系统。它是 [Kubernetes](https://kubernetes.io/) 直接支持的唯一系统，也是整个[云原生生态系统](https://landscape.cncf.io/)的事实标准。

### What dependencies does Prometheus have? Prometheus 有哪些依赖项？

The main Prometheus server runs standalone as a single monolithic binary and has no external dependencies.
主 Prometheus 服务器作为单个整体式二进制文件独立运行，没有外部依赖项。

#### 是云原生的吗？

是的。

Cloud native is a flexible operating model, breaking up old service  boundaries to allow for more flexible and scalable deployments.
云原生是一种灵活的运营模式，打破了旧的服务边界，以实现更灵活和可扩展的部署。

Prometheus's [service discovery](https://prometheus.io/docs/prometheus/latest/configuration/configuration/) integrates with most tools and clouds. Its dimensional data model and  scale into the tens of millions of active series allows it to monitor  large cloud-native deployments. There are always trade-offs to make when running services, and  Prometheus values reliably getting alerts out to humans above all else.
Prometheus 的[服务发现](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)与大多数工具和云集成。它的维度数据模型和数千万个活动序列的规模使其能够监控大型云原生部署。在运行服务时，总是需要做出权衡，Prometheus 将可靠地向人类发出警报放在首位。

### Prometheus 能否实现高可用性？

Yes, run identical Prometheus servers on two or more separate machines. Identical alerts will be deduplicated by the [Alertmanager](https://github.com/prometheus/alertmanager).
是的，在两台或多台单独的计算机上运行相同的 Prometheus 服务器。相同的告警将被 [Alertmanager](https://github.com/prometheus/alertmanager) 删除重复数据。

Alertmanager 通过互连多个 Alertmanager 实例来构建 Alertmanager 集群，从而支持[高可用性](https://github.com/prometheus/alertmanager#high-availability)。Instances of a cluster communicate using a gossip  protocol managed via [HashiCorp's Memberlist](https://github.com/hashicorp/memberlist) library. 集群的实例使用通过 [HashiCorp 的 Memberlist](https://github.com/hashicorp/memberlist) 库管理的 gossip 协议进行通信。

### 有人告诉我 Prometheus “无法扩展”。

这通常更像是一种营销声明，而不是其他任何事情。

A single instance of Prometheus can be more performant than some systems  positioning themselves as long term storage solution for Prometheus. You can run Prometheus reliably with tens of millions of active series.
Prometheus 的单个实例可能比某些将自己定位为 Prometheus 长期存储解决方案的系统性能更高。您可以可靠地运行 Prometheus，拥有数千万个活动序列。

[Scaling and Federating Prometheus](https://www.robustperception.io/scaling-and-federating-prometheus/) on the Robust Perception blog is a good starting point, as are the long storage systems listed on our [integrations page](https://prometheus.io/docs/operating/integrations/#remote-endpoints-and-storage).
如果您需要更多，则有多种选择。Robust Perception 博客上的[扩展和联合 Prometheus](https://www.robustperception.io/scaling-and-federating-prometheus/) 是一个很好的起点，我们的[集成页面上](https://prometheus.io/docs/operating/integrations/#remote-endpoints-and-storage)列出的长存储系统也是一个很好的起点。

### Prometheus 是用什么语言编写的？

大多数 Prometheus 组件都是用 Go 编写的。有些也是用 Java、Python 和 Ruby 编写的。

### Prometheus 功能、存储格式和 API 的稳定性如何？

All repositories in the Prometheus GitHub organization that have reached version 1.0.0 broadly follow [semantic versioning](http://semver.org/). Breaking changes are indicated by increments of the major version. Exceptions are possible for experimental components, which are clearly marked as such in announcements.
Prometheus GitHub 组织中所有已达到版本 1.0.0 的存储库都大致遵循[语义版本控制](http://semver.org/)。重大更改由主要版本的增量表示。实验性组件可能存在例外情况，这些组件在 announcement 中明确标记了此类情况。

Even repositories that have not yet reached version 1.0.0 are, in general, quite stable. We aim for a proper release process and an eventual 1.0.0 release for each repository. In any case, breaking changes will be pointed out in release notes (marked by `[CHANGE]`) or communicated clearly for components that do not have formal releases yet.
即使是尚未达到 1.0.0 版的存储库，通常也相当稳定。我们的目标是为每个存储库提供适当的发布流程和最终的 1.0.0 版本。在任何情况下，破坏性更改都会在发行说明中指出（用 `[CHANGE]` 标记），或者对于尚未正式发布的组件明确说明。

### Why do you pull rather than push? 为什么你拉而不是推？

Pulling over HTTP offers a number of advantages:
拉取 HTTP 具有许多优势：

- You can start extra monitoring instances as needed, e.g. on your laptop when developing changes.
  您可以根据需要启动额外的监控实例，例如，在开发更改时在笔记本电脑上启动。
- You can more easily and reliably tell if a target is down.
  您可以更轻松、更可靠地判断目标是否停机。
- You can manually go to a target and inspect its health with a web browser.
  您可以手动转到目标并使用 Web 浏览器检查其运行状况。

Overall, we believe that pulling is slightly better than pushing, but it should not be considered a major point when considering a monitoring system.
总的来说，我们认为拉动略好于推挤，但在考虑监控系统时，不应将其视为一个要点。

For cases where you must push, we offer the [Pushgateway](https://prometheus.io/docs/instrumenting/pushing/).
对于必须推送的情况，我们提供 [Pushgateway](https://prometheus.io/docs/instrumenting/pushing/)。

### How to feed logs into Prometheus? 如何将日志馈送到 Prometheus 中？

Short answer: Don't! Use something like [Grafana Loki](https://grafana.com/oss/loki/) or [OpenSearch](https://opensearch.org/) instead.
简短的回答：不要！请改用 [Grafana Loki](https://grafana.com/oss/loki/) 或 [OpenSearch](https://opensearch.org/) 之类的工具。

Longer answer: Prometheus is a system to collect and process metrics, not an event logging system. The Grafana blog post [Logs and Metrics and Graphs, Oh My!](https://grafana.com/blog/2016/01/05/logs-and-metrics-and-graphs-oh-my/) provides more details about the differences between logs and metrics.
更长的答案：Prometheus 是一个收集和处理指标的系统，而不是一个事件日志记录系统。Grafana 博客文章[日志和指标和图表，天哪！](https://grafana.com/blog/2016/01/05/logs-and-metrics-and-graphs-oh-my/)提供了有关日志和指标之间差异的更多详细信息。

If you want to extract Prometheus metrics from application logs, Grafana Loki is designed for just that. See Loki's [metric queries](https://grafana.com/docs/loki/latest/logql/metric_queries/) documentation.
如果您想从应用程序日志中提取 Prometheus 指标，Grafana Loki 就是为此而设计的。请参阅 Loki 的[指标查询](https://grafana.com/docs/loki/latest/logql/metric_queries/)文档。

### 谁写了 Prometheus？

Prometheus 最初由 [Matt T. Proud](http://www.matttproud.com) 和 [Julius Volz](http://juliusv.com) 私人创立。它的大部分初始开发是由 [SoundCloud](https://soundcloud.com) 赞助的。

它现在由众多公司和个人维护和扩展。

### Prometheus 是根据什么许可证发布的？

Prometheus 在 [Apache 2.0](https://github.com/prometheus/prometheus/blob/main/LICENSE) 许可下发布。

### What is the plural of Prometheus? 普罗米修斯的复数是什么？

After [extensive research](https://youtu.be/B_CDeYrqxjQ), it has been determined that the correct plural of 'Prometheus' is 'Prometheis'.
经过[广泛的研究](https://youtu.be/B_CDeYrqxjQ)，已经确定 'Prometheus' 的正确复数是 'Prometheis'。

If you can not remember this, "Prometheus instances" is a good workaround.
如果您记不清这一点，“Prometheus 实例”是一个很好的解决方法。

### 可以重新加载 Prometheus 的配置吗？

Yes, sending `SIGHUP` to the Prometheus process or an HTTP POST request to the `/-/reload` endpoint will reload and apply the configuration file. The various components attempt to handle failing changes gracefully.
是的，向 Prometheus 进程发送 `SIGHUP` 或向 `/-/reload` 端点发送 HTTP POST 请求将重新加载并应用配置文件。各种组件尝试正常处理失败的更改。

### 我可以发送警报吗？

是的，使用 [Alertmanager](https://github.com/prometheus/alertmanager)。

We support sending alerts through [email, various native integrations](https://prometheus.io/docs/alerting/latest/configuration/), and a [webhook system anyone can add integrations to](https://prometheus.io/docs/operating/integrations/#alertmanager-webhook-receiver).
我们支持通过电子邮件发送警报[、各种本机集成](https://prometheus.io/docs/alerting/latest/configuration/)以及[任何人都可以添加集成的 webhook 系统](https://prometheus.io/docs/operating/integrations/#alertmanager-webhook-receiver)。

### 我可以创建控制面板吗？

是的，我们建议将 [Grafana](https://prometheus.io/docs/visualization/grafana/) 用于生产用途。还有 [Console 模板](https://prometheus.io/docs/visualization/consoles/)。

### 我可以更改时区吗？为什么一切都是 UTC 格式？

To avoid any kind of timezone confusion, especially when the so-called daylight saving time is involved, we decided to exclusively use Unix time internally and UTC for display purposes in all components of Prometheus. A carefully done timezone selection could be introduced into the UI. Contributions are welcome. See [issue #500](https://github.com/prometheus/prometheus/issues/500) for the current state of this effort.
为了避免任何形式的时区混淆，尤其是当涉及所谓的夏令时，我们决定在 Prometheus 的所有组件中专门使用 Unix 时间和 UTC 进行显示。可以将仔细完成的时区选择引入 UI 中。欢迎贡献。请参阅[问题 #500](https://github.com/prometheus/prometheus/issues/500) 了解这项工作的当前状态。

## Instrumentation 仪表

### Which languages have instrumentation libraries? 哪些语言具有插桩库？

There are a number of client libraries for instrumenting your services with Prometheus metrics. See the [client libraries](https://prometheus.io/docs/instrumenting/clientlibs/) documentation for details.
有许多客户端库可用于使用 Prometheus 指标检测您的服务。有关详细信息，请参阅 [Client Libraries](https://prometheus.io/docs/instrumenting/clientlibs/) 文档。

If you are interested in contributing a client library for a new language, see the [exposition formats](https://prometheus.io/docs/instrumenting/exposition_formats/).
如果您有兴趣为新语言贡献客户端库，请参阅 [exposition 格式](https://prometheus.io/docs/instrumenting/exposition_formats/)。

### 我可以监控机器吗？

Yes, the [Node Exporter](https://github.com/prometheus/node_exporter) exposes an extensive set of machine-level metrics on Linux and other Unix systems such as CPU usage, memory, disk utilization, filesystem fullness, and network bandwidth.
是的，[Node Exporter](https://github.com/prometheus/node_exporter) 在 Linux 和其他 Unix 系统上公开了大量的计算机级指标，例如 CPU 使用率、内存、磁盘利用率、文件系统填充度和网络带宽。

### 我可以监控网络设备吗？

Yes, the [SNMP Exporter](https://github.com/prometheus/snmp_exporter) allows monitoring of devices that support SNMP. For industrial networks, there's also a [Modbus exporter](https://github.com/RichiH/modbus_exporter).
是的，[SNMP Exporter](https://github.com/prometheus/snmp_exporter) 允许监控支持 SNMP 的设备。对于工业网络，还有一个 [Modbus 导出器](https://github.com/RichiH/modbus_exporter)。

### 我可以监控批处理作业吗？

Yes, using the [Pushgateway](https://prometheus.io/docs/instrumenting/pushing/). See also the [best practices](https://prometheus.io/docs/practices/instrumentation/#batch-jobs) for monitoring batch jobs.
是的，使用 [Pushgateway](https://prometheus.io/docs/instrumenting/pushing/)。另请参阅监控批处理作业的[最佳实践](https://prometheus.io/docs/practices/instrumentation/#batch-jobs)。

### What applications can Prometheus monitor out of the box? Prometheus 可以开箱即用地监控哪些应用程序？

See [the list of exporters and integrations](https://prometheus.io/docs/instrumenting/exporters/).
请参阅[导出程序和集成列表](https://prometheus.io/docs/instrumenting/exporters/)。

### Can I monitor JVM applications via JMX? 我可以通过 JMX 监控 JVM 应用程序吗？

Yes, for applications that you cannot instrument directly with the Java client, you can use the [JMX Exporter](https://github.com/prometheus/jmx_exporter) either standalone or as a Java Agent.
是的，对于无法直接使用 Java 客户端进行插桩的应用程序，您可以单独使用 [JMX 导出器](https://github.com/prometheus/jmx_exporter)，也可以将其用作 Java 代理。

### What is the performance impact of instrumentation? 检测对性能有何影响？

Performance across client libraries and languages may vary. For Java, [benchmarks](https://github.com/prometheus/client_java/blob/master/benchmarks/README.md) indicate that incrementing a counter/gauge with the Java client will take 12-17ns, depending on contention. This is negligible for all but the most latency-critical code.
不同客户端库和语言的性能可能会有所不同。对于 Java，[基准测试](https://github.com/prometheus/client_java/blob/master/benchmarks/README.md)表明，使用 Java 客户端递增计数器/计量器将需要 12-17ns，具体取决于争用情况。除了延迟最关键的代码之外，所有代码都可以忽略不计。

## Implementation 实现

### Why are all sample values 64-bit floats? 为什么所有样本值都是 64 位浮点数？

We restrained ourselves to 64-bit floats to simplify the design. The [IEEE 754 double-precision binary floating-point format](https://en.wikipedia.org/wiki/Double-precision_floating-point_format) supports integer precision for values up to 253. Supporting native 64 bit integers would (only) help if you need integer precision above 253 but below 263. In principle, support for different sample value types (including some kind of big integer, supporting even more than 64 bit) could be implemented, but it is not a priority right now. A counter, even if incremented one million times per second, will only run into precision issues after over 285 years.
我们将自己限制为 64 位浮点数以简化设计。[IEEE 754 双精度二进制浮点格式](https://en.wikipedia.org/wiki/Double-precision_floating-point_format)支持最大 253 的整数精度值。支持本机 64 位整数（仅）在您需要高于 253 但低于 263 的整数精度时提供帮助。原则上，可以实现对不同样本值类型（包括某种大整数，甚至支持超过 64 位）的支持，但现在这不是优先事项。一个计数器，即使每秒递增 100 万次，也只会在超过 285 年后遇到精度问题。