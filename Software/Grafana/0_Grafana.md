# Grafana

[TOC]

## 概述

Grafana 使您能够查询、可视化、提醒和探索您的指标、日志和跟踪，无论它们存储在何处。Grafana 数据源插件使您能够查询数据源，包括  Prometheus 和 CloudWatch 等时间序列数据库、Loki 和 Elasticsearch 等日志记录工具、Postgres 等 NoSQL/SQL 数据库、Jira 或 ServiceNow 等票证工具、GitHub 等 CI/CD 工具等等。Grafana 提供了一些工具，可将时间序列数据库 （TSDB） 数据转换为富有洞察力的图形和可视化效果，可通过富有洞察力的图表和可视化效果在实时控制面板上显示这些数据。

Grafana 可帮助您使用漂亮的控制面板收集、关联和可视化数据，这是一种开源数据可视化和监控解决方案，可推动做出明智的决策、增强系统性能并简化故障排除。

安装 Grafana 并设置第一个控制面板后，将有许多选项可供选择，具体取决于您的要求。例如，如果想查看有关智能家居的天气数据和统计数据，则可以创建[播放列表](https://grafana.com/docs/grafana/latest/dashboards/create-manage-playlists/)。如果是企业的管理员，并且正在为多个团队管理 Grafana，则可以设置[预置](https://grafana.com/docs/grafana/latest/administration/provisioning/)和[身份验证](https://grafana.com/docs/grafana/latest/setup-grafana/configure-security/configure-authentication/)。

## 探索指标、日志和跟踪traces

通过临时查询和动态深入分析来探索您的数据。拆分视图并排比较不同的时间范围、查询和数据源。

## 警报

如果使用的是 Grafana Alerting，则可以通过许多不同的警报通知程序发送警报，包括 PagerDuty、SMS、电子邮件、VictorOps、OpsGenie 或 Slack。

Alert hooks allow you to create different notifiers with a bit of code if you prefer some other channels of communication. Visually define [alert rules](https://grafana.com/docs/grafana/latest/alerting/alerting-rules/) for your most important metrics.
如果您更喜欢其他通信渠道，则警报钩子允许您使用一些代码创建不同的通知器。直观地定义最重要指标的[警报规则](https://grafana.com/docs/grafana/latest/alerting/alerting-rules/)。

## Annotations 附注

Annotate graphs with rich events from different data sources. Hover over events to see the full event metadata and tags.
使用来自不同数据源的丰富事件对图形进行注释。将鼠标悬停在事件上可查看完整的事件元数据和标签。

This feature, which shows up as a graph marker in Grafana, is useful for  correlating data in case something goes wrong. You can create the  annotations manually—just control-click on a graph and input some  text—or you can fetch data from any data source. 
此功能在 Grafana 中显示为图形标记，可用于在出现问题时关联数据。您可以手动创建注释 — 只需按住 Control 键单击图表并输入一些文本即可 — 也可以从任何数据源获取数据。

## Dashboard variables 仪表板变量

[Template variables](https://grafana.com/docs/grafana/latest/dashboards/variables/) allow you to create dashboards that can be reused for lots of different use cases. Values aren’t hard-coded with these templates, so for  instance, if you have a production server and a test server, you can use the same dashboard for both.
[模板变量](https://grafana.com/docs/grafana/latest/dashboards/variables/)允许您创建可重复用于许多不同的使用案例的控制面板。这些模板不会对值进行硬编码，因此，例如，如果您有生产服务器和测试服务器，则可以对两者使用相同的控制面板。

Templating allows you to drill down into your data, say, from all data to North  America data, down to Texas data, and beyond. You can also share these  dashboards across teams within your organization—or if you create a  great dashboard template for a popular data source, you can contribute  it to the whole community to customize and use.
模板允许您向下钻取数据，例如，从所有数据到北美数据，再到德克萨斯州数据，等等。您还可以在组织内的团队之间共享这些控制面板，或者如果您为常用数据源创建了一个出色的控制面板模板，则可以将其贡献给整个社区进行自定义和使用。

## 配置 Grafana

配置包括配置文件和环境变量。您可以设置默认端口、日志记录级别、电子邮件 IP 地址、安全性等。

## 导入仪表板和插件

Discover hundreds of [dashboards](https://grafana.com/grafana/dashboards) and [plugins](https://grafana.com/grafana/plugins) in the official library. Thanks to the passion and momentum of community members, new ones are added every week.
在官方库中发现数百个[仪表板](https://grafana.com/grafana/dashboards)和[插件](https://grafana.com/grafana/plugins)。

## 认证

Grafana 支持不同的身份验证方法，例如 LDAP 和 OAuth，并允许您将用户映射到组织。

In Grafana Enterprise, you can also map users to teams: If your company  has its own authentication system, Grafana allows you to map the teams  in your internal systems to teams in Grafana. That way, you can  automatically give people access to the dashboards designated for their  teams. 
在 Grafana Enterprise 中，您还可以将用户映射到团队：如果您的公司有自己的身份验证系统，Grafana  允许您将内部系统中的团队映射到 Grafana 中的团队。这样，您可以自动授予人们访问为其团队指定的控制面板的权限。

## Provisioning 供应

While it’s easy to click, drag, and drop to create a single dashboard, power  users in need of many dashboards will want to automate the setup with a  script. You can script anything in Grafana.
虽然单击、拖放创建单个仪表板很容易，但需要许多仪表板的高级用户会希望使用脚本自动进行设置。您可以在 Grafana 中编写任何内容。

For example, if you’re spinning up a new Kubernetes cluster, you can also  spin up a Grafana automatically with a script that would have the right  server, IP address, and data sources preset and locked in so users  cannot change them. It’s also a way of getting control over a lot of  dashboards. 
例如，如果您正在启动一个新的 Kubernetes 集群，您还可以使用脚本自动启动一个 Grafana，该脚本将预设并锁定正确的服务器、IP 地址和数据源，以便用户无法更改它们。这也是控制许多仪表板的一种方式。

## 权限

When organizations have one Grafana and multiple teams, they often want the  ability to both keep things separate and share dashboards. You can  create a team of users and then set permissions on [folders and dashboards](https://grafana.com/docs/grafana/latest/administration/user-management/manage-dashboard-permissions/), and down to the [data source level](https://grafana.com/docs/grafana/latest/administration/data-source-management/#data-source-permissions) if you’re using [Grafana Enterprise](https://grafana.com/docs/grafana/latest/introduction/grafana-enterprise/).
当组织有一个 Grafana 和多个团队时，他们通常希望能够同时将事情分开并共享仪表板。您可以创建一个用户团队，然后对[文件夹和控制面板](https://grafana.com/docs/grafana/latest/administration/user-management/manage-dashboard-permissions/)设置权限，如果您使用的是 [Grafana Enterprise](https://grafana.com/docs/grafana/latest/introduction/grafana-enterprise/)，则可以设置到[数据源级别](https://grafana.com/docs/grafana/latest/administration/data-source-management/#data-source-permissions)的权限。

## 其他 Grafana Labs OSS 项目

除了 Grafana，Grafana Labs 还提供以下开源项目：

* **Grafana Loki：**是一组开源组件，可以组合成一个功能齐全的日志记录堆栈。
* **Grafana Tempo：**是一个开源、易于使用且大容量的分布式跟踪后端。
* **Grafana Mimir** 是一个开源软件项目，可为 Prometheus 提供可扩展的长期存储。
* **Grafana Pyroscope:** Grafana Pyroscope is an open source software project for aggregating  continuous profiling data. Continuous profiling is an observability  signal that allows you to understand your workload’s resources (CPU,  memory, for example) usage down to the line number. 
  **Grafana 热镜：**Grafana Pyroscope 是一个开源软件项目，用于聚合持续分析数据。持续分析是一种可观测性信号，可让您了解工作负载的资源（例如 CPU、内存）使用情况，直至行号。
* **Grafana Faro** 是一个开源 JavaScript 代理，它嵌入到 Web 应用程序中以收集真实用户监控 （RUM） 数据：性能指标、日志、异常、事件和跟踪。
* **Grafana Beyla:** Grafana Beyla is an eBPF-based application auto-instrumentation tool  for application observability. eBPF is used to automatically inspect  application executables and the OS networking layer as well as capture  basic trace spans related to web transactions and Rate-Errors-Duration  (RED) metrics for Linux HTTP/S and gRPC services. All data capture  occurs without any modifications to application code or configuration. 
  **格拉法娜·贝拉：**Grafana Beyla 是一个基于 eBPF 的应用程序自动检测工具，用于应用程序可观察性。eBPF  用于自动检查应用程序可执行文件和操作系统网络层，以及捕获与 Web 事务相关的基本跟踪跨度以及 Linux HTTP/S 和 gRPC  服务的速率-错误-持续时间 （RED） 指标。所有数据捕获均无需对应用程序代码或配置进行任何修改。
* **Grafana Alloy:** Grafana Alloy is a flexible, high performance, vendor-neutral distribution of the [OpenTelemetry][] (OTel) Collector. It’s fully compatible with the most popular open source observability standards such as OpenTelemetry (OTel) and Prometheus. 
  **Grafana 合金：**Grafana Alloy 是 [OpenTelemetry][] （OTel） 收集器的灵活、高性能、供应商中立的发行版。它与最流行的开源可观测性标准（如  OpenTelemetry （OTel） 和 Prometheus）完全兼容。
* **Grafana k6** 是一款开源负载测试工具，可让工程团队轻松高效地进行性能测试。
* **Grafana OnCall** 是一种开源事件响应管理工具，旨在帮助团队改善协作并更快地解决事件。



访问 http://localhost:3000 就可以进入到 Grafana 的界面中，默认情况下使用账户 admin/admin 进行登录。在 Grafana 首页中显示默认的使用向导，包括：安装、添加数据源、创建 Dashboard 、邀请成员、以及安装应用和插件等主要流程:

![Grafana向导](../../Image/g/get_start_with_grafana2.png)

## Environment file

The systemd service file and init.d script both use the file located at `/etc/sysconfig/grafana-server` for environment variables used when starting the back-end. Here you can override log directory, data directory and other variables.

### Logging

By default Grafana will log to `/var/log/grafana`

### Database

The default configuration specifies a sqlite3 database located at `/var/lib/grafana/grafana.db`. Please backup this database before upgrades. You can also use MySQL or Postgres as the Grafana database, as detailed on [the configuration page](http://docs.grafana.org/installation/configuration/#database).

## Configuration

The configuration file is located at `/etc/grafana/grafana.ini`. Go the [Configuration](http://docs.grafana.org/installation/configuration/) page for details on all those options.

### Adding data sources

- [Graphite](http://docs.grafana.org/features/datasources/graphite/)
- [InfluxDB](http://docs.grafana.org/features/datasources/influxdb/)
- [OpenTSDB](http://docs.grafana.org/features/datasources/opentsdb/)
- [Prometheus](http://docs.grafana.org/features/datasources/prometheus/)

### Server side image rendering

Server side image (png) rendering is a feature that is optional but very useful when sharing visualizations, for example in alert notifications.

If the image is missing text make sure you have font packages installed.

```
yum install fontconfig
yum install freetype*
yum install urw-fonts

```

## Installing from binary tar file

Download [the latest `.tar.gz` file](https://grafana.com/get) and extract it. This will extract into a folder named after the version you downloaded. This folder contains all files required to run Grafana. There are no init scripts or install scripts in this package.

To configure Grafana add a configuration file named `custom.ini` to the `conf` folder and override any of the settings defined in `conf/defaults.ini`.

Start Grafana by executing `./bin/grafana-server web`. The `grafana-server` binary needs the working directory to be the root install directory (where the binary and the `public` folder is located).