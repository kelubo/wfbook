# Roadmap

The following is only a selection of some of the major features we plan to implement in the near future. To get a more complete overview of planned features and current work, see the issue trackers for the various repositories, for example, the [Prometheus server](https://github.com/prometheus/prometheus/issues).

以下只是我们计划在不久的将来实现的一些主要功能的选择。要获得计划功能和当前工作的更完整概述，请参阅各种存储库的问题跟踪器，例如Prometheus服务器。

### Server-side metric metadata support

服务器端度量元数据支持

At this time, metric types and other metadata are only used in the client libraries and in the exposition format, but not persisted or utilized in the Prometheus server. We plan on making use of this metadata in the future. The first step is to aggregate this data in-memory in Prometheus and provide it via an experimental API endpoint.

此时，度量类型和其他元数据仅在客户端库和公开格式中使用，而不会在Prometheus服务器中持久化或使用。我们计划在未来使用这些元数据。第一步是在Prometheus的内存中聚合这些数据，并通过一个实验性的API端点提供这些数据。

### Adopt OpenMetrics

The OpenMetrics working group is developing a new standard for metric exposition. We plan to support this format in our client libraries and Prometheus itself.

采用开放度量

开放度量工作组正在为度量展示开发一个新的标准。我们计划在我们的客户端库和普罗米修斯本身中支持这种格式。

### Retroactive rule evaluations

追溯规则评估

Add support for retroactive rule evaluations making use of backfill.

添加对使用回填进行追溯规则评估的支持。

### TLS and authentication in HTTP serving endpoints

HTTP服务端点中的TLS和身份验证

TLS and authentication are currently being rolled out to the Prometheus, Alertmanager, and the official exporters. Adding this support will make it easier for people to deploy Prometheus components securely without requiring a reverse proxy to add those features externally.

TLS和身份验证目前正在向Prometheus、Alertmanager和官方出口商推出。添加这种支持将使人们更容易安全地部署普罗米修斯组件，而不需要反向代理从外部添加这些功能。

### 支持生态系统

Prometheus 拥有一系列客户库和导出程序。总是有更多的语言可以得到支持，或者有更多的系统可以用于导出度量。我们将支持生态系统创建和扩展这些功能。