# Set up your LMA stack 设置您的LMA堆栈 

> **LMA to COS LMA到COS**
>  The LMA stack is being succeeded by the Canonical Observability Stack  (COS). While the current LMA still works, most users are recommended to  consider COS instead. For more information, refer to [this COS topic](https://charmhub.io/topics/canonical-observability-stack/). In environments with more limited resources, there is also [COS lite](https://charmhub.io/topics/canonical-observability-stack/editions/lite).
>  LMA堆栈被规范可观测性堆栈（COS）所取代。虽然目前的LMA仍然有效，但建议大多数用户考虑COS。有关详细信息，请参阅此COS主题。在资源更有限的环境中，还有COS lite。

Logging, Monitoring, and Alerting (LMA) is a collection of tools that guarantee  the availability of your running infrastructure. Your LMA stack will  help point out issues in load, networking, and other resources before  they become a failure point.
日志记录、监视和警报（LMA）是一组工具，可保证运行基础架构的可用性。您的LMA堆栈将有助于在负载、网络和其他资源成为故障点之前指出这些问题。 

## Architectural overview 体系结构概述 

Canonical’s LMA stack involves several discrete software services acting in concert.
Canonical的LMA堆栈涉及几个独立的软件服务。 

[**Telegraf**](https://docs.influxdata.com/telegraf/v1/) collects metrics from the operating system, running software, and other inputs. Its plugin system permits export of data in any arbitrary  format; for this system we collect the data in a central data manager  called [**Prometheus**](https://prometheus.io/docs/introduction/overview/).
Telecommunication从操作系统、运行的软件和其他输入中收集指标。它的插件系统允许以任意格式导出数据;对于这个系统，我们在一个名为Prometheus的中央数据管理器中收集数据。

Prometheus works as a hub, polling data from different Telegraf nodes and sending  it to various outputs, including persistent storage. For this LMA stack, visualisation is handled via [**Grafana**](https://grafana.com/docs/) and email/pager alerts are generated via the [**Prometheus Alertmanager**](https://prometheus.io/docs/alerting/latest/alertmanager/) plugin.
Prometheus作为一个枢纽，轮询来自不同Telecommunications节点的数据，并将其发送到各种输出，包括持久存储。对于这个LMA堆栈，可视化通过Grafana处理，电子邮件/寻呼机警报通过Prometheus Alertmanager插件生成。

## Getting started 入门 

Let’s set up a basic demonstration with two **nodes**, the first acting as a placeholder load with Telegraf installed - the  “Workload”, and the second acting as our data visualisation system - the “Monitor”. This will help us familiarise ourselves with the various  components and how they inter-operate.
让我们用两个节点来设置一个基本的演示，第一个节点作为安装了Telecom的占位符负载-“监视器”，第二个节点作为我们的数据可视化系统-“监视器”。这将帮助我们熟悉各种组件以及它们如何相互操作。

> **Note**: 注意事项：
>  For clarity, we’ll refer to these two hosts as named: `workload` and `monitor`. If you use other hostnames, substitute your preferred names as we go through this guide.
>  为清楚起见，我们将这两台主机命名为： `workload` 和 `monitor` 。如果您使用其他主机名，请在我们阅读本指南时替换您的首选名称。

The Workload node will be running Telegraf to collect metrics from whatever load we’re monitoring. For demonstration purposes we’ll just read the  CPU/memory data from the node. In a real environment, we’d have multiple hosts (each with their own Telegraf instance) collecting hardware,  network, and software statuses particular to that node.
该节点将运行Telecommunication来从我们监视的任何负载中收集指标。出于演示目的，我们将只从节点读取CPU/内存数据。在真实的环境中，我们会有多个主机（每个主机都有自己的Telecom实例）收集特定于该节点的硬件、网络和软件状态。 

Our Monitor node will double as both a data store and a web UI, receiving  data from the Workload, storing it to disk, and displaying it for  analysis.
我们的Monitor节点将同时作为数据存储和Web UI，从数据库接收数据，将其存储到磁盘，并显示数据以供分析。 

### Ports 端口 

As reference, here are the ports we’ll be binding for each service:
作为参考，以下是我们将为每个服务绑定的端口： 

|              |                 |
| ------------ | --------------- |
| Prometheus   | `monitor:9090`  |
| Alertmanager | `monitor:9093`  |
| Grafana      | `monitor:3000`  |
| Telegraf     | `workload:9273` |

### Set up the Workload node  设置网络节点 

First, let’s set up the Workload. We’ll be using LXD as our container  technology in this guide, but any VM, container, or bare metal host  should work, so long as it’s running Ubuntu 20.10. With LXD installed on our host we can use its `lxc` command line tool to create our containers:
首先，让我们建立一个网络。在本指南中，我们将使用LXD作为我们的容器技术，但任何VM，容器或裸机主机都应该工作，只要它运行Ubuntu 20.10。在主机上安装LXD后，我们可以使用它的 `lxc` 命令行工具来创建容器：

```bash
$ lxc launch ubuntu:20.10 workload
Creating workload
Starting workload

$ lxc exec workload -- bash
workload:~#
```

On the Workload, install Telegraf:
在安装器上，安装Telephone： 

```bash
workload:~# apt update
workload:~# apt install telegraf
```

Telegraf processes input data to transform, filter, and decorate it, and then  performs selected aggregation functions on it such as tallies, averages, etc. The results are published for collection by external services; in  our case Prometheus will be collecting the CPU/memory data from the  Monitor node.
Telecommunications处理输入数据以转换、过滤和修饰它，然后对其执行选定的聚合功能，例如计数、平均值等。结果被发布以供外部服务收集;在我们的示例中，Prometheus将从Monitor节点收集CPU/内存数据。 

Open `/etc/telegraf/telegraf.conf` and scroll down to the “INPUT PLUGINS” section. What we’ll need is the  following configuration settings, which you should find already enabled  by default:
打开 `/etc/telegraf/telegraf.conf` 并向下滚动至“INPUT PLUGINS”（输入插头）部分。我们需要的是以下配置设置，您应该会发现默认情况下已启用这些设置：

```plaintext
[[inputs.cpu]]
  percpu = true
  totalcpu = true
  collect_cpu_time = false
  report_active = false
```

Looking at the config file you’ll notice it’s almost entirely commented out.  There are three different types of sections in the file: `[[inputs]]`, which we set above; `[[outputs]]`, which we’ll set up next; and the `[[agent]]` setting, with several performance tuning parameters such as the  collection interval, which we’re setting to 10 seconds. The agent  defaults are fine for our example and for basic use.
查看配置文件，您会注意到它几乎完全被注释掉了。文件中有三种不同类型的部分： `[[inputs]]` ，我们在上面设置; `[[outputs]]` ，我们将在下面设置;以及 `[[agent]]` 设置，具有几个性能调优参数，例如收集间隔，我们将其设置为10秒。代理默认值对于我们的示例和基本用途来说都很好。

Finally, we need to define where Telegraf will provide its output. Open `/etc/telegraf/telegraf.conf` and scroll down to the “OUTPUT PLUGINS” section and add the following output configuration:
最后，我们需要定义Telecommunication将在何处提供其输出。打开 `/etc/telegraf/telegraf.conf` 并向下滚动至“OUTPUT PLUGINS”部分，并添加以下输出配置：

```plaintext
[[outputs.prometheus_client]]
  listen = "workload:9273"
  metric_version = 2

#[[outputs.influxdb]]
```

We won’t be using `Influxdb`, so you can comment that section out (if it’s enabled).
我们不会使用 `Influxdb` ，因此您可以将该部分注释掉（如果已启用）。

Now restart the Telegraf service:
现在重新启动Telecommunication服务： 

```bash
workload:~# systemctl restart telegraf
workload:~# systemctl status telegraf
● telegraf.service - The plugin-driven server agent for reporting metrics into InfluxDB
	 Loaded: loaded (/lib/systemd/system/telegraf.service; enabled; vendor preset: enabled)
	 Active: active (running) since Sat 2020-10-31 02:17:57 UTC; 6s ago
	   Docs: https://github.com/influxdata/telegraf
   Main PID: 2562 (telegraf)
	  Tasks: 17 (limit: 77021)
	 Memory: 42.2M
	 CGroup: /system.slice/telegraf.service
			 └─2562 /usr/bin/telegraf -config /etc/telegraf/telegraf.conf -config-directory /etc/telegraf/telegraf.d

...I! Loaded inputs: swap system cpu disk diskio kernel mem processes
...I! Loaded outputs: http prometheus_client
...I! [agent] Config: Interval:10s, Quiet:false, Hostname:"workload", Flush Interval:10s
...I! [outputs.prometheus_client] Listening on http://127.0.0.1:9273/metrics
```

Verify that it is collecting metrics by connecting to Telegraf’s web interface:
通过连接到Telecommunication的Web界面来验证它是否正在收集指标： 

```bash
workload:~# wget -O- http://workload:9273/metrics

# HELP cpu_usage_guest Telegraf collected metric
# TYPE cpu_usage_guest gauge
cpu_usage_guest{cpu="cpu-total",host="workload"} 0
cpu_usage_guest{cpu="cpu0",host="workload"} 0
cpu_usage_guest{cpu="cpu1",host="workload"} 0
cpu_usage_guest{cpu="cpu10",host="workload"} 0
...
cpu_usage_idle{cpu="cpu-total",host="workload"} 92.74914376428686
cpu_usage_idle{cpu="cpu0",host="workload"} 86.72897196325539
cpu_usage_idle{cpu="cpu1",host="workload"} 90.11857707405758
cpu_usage_idle{cpu="cpu10",host="workload"} 95.95141700494543
```

### Set up the Monitor node 设置监视器节点 

Now let’s create the Monitor. As before, we’ll be using LXD as the  container technology but feel free to adapt these steps to your chosen  alternative:
现在让我们创建监视器。和以前一样，我们将使用LXD作为容器技术，但可以根据您选择的替代方案调整这些步骤： 

```bash
$ lxc launch ubuntu:20.10 monitor
Creating monitor
Starting monitor
$ lxc exec monitor -- bash
monitor:~#
```

Make a note of the newly created container’s IP address, which we’ll need later on;
记下新创建的容器的IP地址，稍后我们会用到它; 

```bash
monitor:~# ip addr | grep 'inet .* global'
inet 10.69.244.104/24 brd 10.69.244.255 scope global dynamic eth0
```

Verify the Workload’s Telegraf instance can be reached from the Monitor:
验证是否可以从监视器访问远程监控实例： 

```bash
monitor:~# wget -O- http://workload:9273/metrics
```

We’ll be setting up a few components to run on this node using their  respective Snap packages. LXD images should normally have snap  pre-installed, but if not, install it manually:
我们将设置几个组件，使用它们各自的Snap包在此节点上运行。LXD映像通常应预先安装Snap，但如果没有，请手动安装： 

```bash
monitor:~# apt install snapd
```

### Install Prometheus 安装Prometheus 

Prometheus will be our data manager. It collects data from external sources –  Telegraf in our case – and distributes it to various destinations such  as email/pager alerts, web UIs, API clients, remote storage services,  etc. We’ll get into those shortly.
普罗米修斯将是我们的数据管理员。它从外部源（在我们的例子中是Telecommunication）收集数据，并将其分发到各种目的地，如电子邮件/寻呼机警报、Web UI、API客户端、远程存储服务等。 

Let’s install Prometheus itself, and the Prometheus Alertmanager plugin for alerts, along with the required dependencies:
让我们安装Prometheus本身，以及Prometheus Alertmanager插件，沿着所需的依赖项： 

```bash
monitor:~# snap install prometheus
monitor:~# snap install prometheus-alertmanager
```

The snap will automatically configure and start the service. To verify this, run:
快照将自动配置并启动服务。要验证这一点，请运行： 

```bash
monitor:~# snap services
Service                Startup  Current   Notes
lxd.activate           enabled  inactive  -
lxd.daemon             enabled  inactive  socket-activated
prometheus.prometheus  enabled  active    -
prometheus-alertmanager.alertmanager  enabled  active    -
```

Verify that Prometheus is listening on the port as we expect:
验证Prometheus是否按照我们的预期监听端口： 

```bash
visualizer:~# ss -tulpn | grep prometheus
tcp    LISTEN  0      128                     *:9090               *:*      users:(("prometheus",pid=618,fd=8))
```

`journalctl` can be also used to review the state of Snap services if more detail is needed. For example, to see where Prometheus is loading its config  from:
如果需要更多详细信息，还可以使用 `journalctl` 查看快照服务的状态。例如，要查看Prometheus从何处加载其配置：

```bash
monitor:~# journalctl | grep "prometheus.*config"
...
...msg="Completed loading of configuration file" filename=/var/snap/prometheus/32/prometheus.yml
```

Although the file name points to a specific Snap revision (`32`, in this case), we can use the generic config file `/var/snap/prometheus/current/prometheus.yml` here in order to make things more general. Edit this config file to  register the targets we’ll be reading data from. This will go under the `scrape_configs` section of the file:
虽然文件名指向特定的Snap修订版（在本例中为 `32` ），但我们可以在此处使用通用配置文件 `/var/snap/prometheus/current/prometheus.yml` ，以便使其更通用。编辑此配置文件以注册我们将从中阅读数据的目标。这将在文件的 `scrape_configs` 部分下进行：

```plaintext
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

	# metrics_path defaults to '/metrics'
	# scheme defaults to 'http'.

	static_configs:
	- targets: ['localhost:9090']

  - job_name: 'telegraf'
	static_configs:
	- targets: ['workload:9273']
```

Then restart Prometheus:
重启Prometheus： 

```bash
monitor:~# snap restart prometheus
```

While we’ll be using Grafana for visualisation, Prometheus also has a web  interface for viewing and interacting with the collected data. At this  stage, we can load it to verify that our setup is working properly. In a web browser, navigate to the Monitor’s IP address, and port `9090`. You should see Prometheus’ interface, as in the following image:
虽然我们将使用Grafana进行可视化，但Prometheus也有一个Web界面，用于查看和与收集的数据进行交互。在这个阶段，我们可以加载它来验证我们的设置是否正常工作。在Web浏览器中，导航至监视器的IP地址和端口 `9090` 。您应该会看到Prometheus的界面，如下图所示：

![prometheus_0](https://assets.ubuntu.com/v1/54610cab-promotheus_0.png)

In the entry box, enter `cpu_usage_system`, select the “Graph” tab and click “Execute”. This should show a graph of our collected CPU data so far. Prometheus also has a secondary web UI  using `React.js`.
在输入框中，输入 `cpu_usage_system` ，选择“Graph”选项卡并单击“Execute”。这应该显示了我们收集到的CPU数据到目前为止的图表。Prometheus也有一个使用 `React.js` 的辅助Web UI。

![prometheus_1](https://assets.ubuntu.com/v1/d56f0ceb-promotheus_1.png) ![prometheus_2](https://assets.ubuntu.com/v1/d46d3705-promotheus_2.png)

### Configure Alertmanager 配置AlertManager 

Let’s tackle the Alert Manager next. Edit `/var/snap/prometheus/current/prometheus.yml` again, adding the following to the `alerting` and `rules_files` sections:
接下来让我们解决警报管理器。再次编辑 `/var/snap/prometheus/current/prometheus.yml` ，将以下内容添加到 `alerting` 和 `rules_files` 部分：

```plaintext
## /var/snap/prometheus/current/prometheus.yml
#...
# Alertmanager configuration
alerting:
  alertmanagers:
  - static_configs:
	- targets:
	  - 127.0.0.1:9093
rule_files:
  - 'alerts.yml'
```

Now create `/var/snap/prometheus/current/alerts.yml` with the following contents:
现在使用以下内容创建 `/var/snap/prometheus/current/alerts.yml` ：

```plaintext
## /var/snap/prometheus/current/alerts.yml
groups:
- name: demo-alerts
  rules:
  - alert: HighLoad
	expr: node_load1 > 2.0
	for: 60m
	labels:
	  severity: normal
	annotations:
	  description: '{{ $labels.instance }} of job {{ $labels.job }} is under high load.'
	  summary: Instance {{ $labels.instance }} under high load.
	  value: '{{ $value }}'

  - alert: InstanceDown
	expr: up == 0
	for: 5m
	labels:
	  severity: major
	annotations:
	  summary: "Instance {{ $labels.instance }} down"
	  description: "{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes."
```

This adds two alerts: one for high processor load, and one to report if the  node has been unreachable for over 5 minutes. We’re considering high CPU to be a load of 2 or higher for an hour; this would need to be set to  something more sensible for the style of workloads your production  system experiences.
这将添加两个警报：一个用于高处理器负载，另一个用于报告节点是否超过5分钟无法访问。我们认为高CPU是指一个小时内的负载为2或更高;这需要根据您的生产系统体验的工作负载类型设置为更合理的值。 

With the alerts themselves now defined, we next need to instruct  Alertmanager how to handle them. There is a sample configuration  installed to `/var/snap/prometheus-alertmanager/current/alertmanager.yml`, however it’s full of example data. Instead, replace it entirely with this content:
现在定义了警报本身，我们接下来需要指示Alertmanager如何处理它们。有一个示例配置安装到 `/var/snap/prometheus-alertmanager/current/alertmanager.yml` ，但它充满了示例数据。相反，将其完全替换为以下内容：

```plaintext
## /var/snap/prometheus-alertmanager/current/alertmanager.yml
global:
  resolve_timeout: 5m

route:
  group_by: ['alertname']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 1h

inhibit_rules:
  - source_match:
	  severity: 'critical'
	target_match:
	  severity: 'warning'
	equal: ['alertname', 'dev', 'instance']
```

Restart Alertmanager after making the configuration change:
更改配置后重新启动Alertmanager： 

```bash
workload:~# snap restart prometheus-alertmanager
```

### Install Grafana 安装Grafana 

Grafana provides our main dashboard, from which we can generate graphs and  other visuals to study the collected metrics. Grafana can read its data  directly from log files, but we’ll focus on using Prometheus as its  principle data source. Grafana is available as a Snap and can be  installed like this:
Grafana提供了我们的主仪表板，我们可以从中生成图表和其他视觉效果来研究收集的指标。Grafana可以直接从日志文件中读取数据，但我们将重点关注使用Prometheus作为其主要数据源。Grafana作为Snap提供，可以这样安装： 

```bash
monitor:~# snap install grafana
grafana 6.7.4 from Alvaro Uría (aluria) installed
```

It uses port `3000`:
它使用端口 `3000` ：

```bash
# ss -tulpn | grep grafana
tcp    LISTEN  0      128                     *:3000               *:*      users:(("grafana-server",pid=1449,fd=10))
```

We next need to know where it expects its configuration:
接下来，我们需要知道它期望配置的位置： 

```bash
monitor:~# journalctl | grep "grafana.*conf"
... msg="Config loaded from" logger=settings file=/snap/grafana/36/conf/defaults.ini
... msg="Config overridden from Environment variable" logger=settings var="GF_PATHS_PROVISIONING=/var/snap/grafana/common/conf/provisioning"
... error="open /var/snap/grafana/common/conf/provisioning/datasources: no such file or directory"
...
```

We can see it is getting its defaults from `/snap/grafana/36/conf/`, but `/snap/` is a read-only directory and therefore we cannot edit the file. Instead, we should put our customisations inside `/var/snap/grafana/36/conf/grafana.ini`. You can also use the generic path `/var/snap/grafana/current/conf/grafana.ini`.
我们可以看到它从 `/snap/grafana/36/conf/` 获取默认值，但 `/snap/` 是只读目录，因此我们无法编辑该文件。相反，我们应该把我们的定制放在 `/var/snap/grafana/36/conf/grafana.ini` 里面。您也可以使用通用路径 `/var/snap/grafana/current/conf/grafana.ini` 。

For a production installation, the `defaults.ini` has numerous parameters we’d want to customise for our site, however  for the demo we’ll accept all the defaults. We do need to configure our  data sources, but can do this via the web interface:
对于生产安装， `defaults.ini` 有许多参数，我们希望为我们的网站自定义，但对于演示，我们将接受所有默认值。我们确实需要配置数据源，但可以通过Web界面进行配置：

```bash
$ firefox http://10.69.244.104:3000
```

Log in with ‘admin’ and ‘admin’ as the username and password. This should  bring you to the main Grafana page, where you can find links to  tutorials and documentation. Delete any example data sources and/or  dashboards.
使用“admin”和“admin”作为用户名和密码登录。这应该会把你带到Grafana主页，在那里你可以找到教程和文档的链接。删除任何示例数据源和/或仪表板。 

![grafana_0](https://assets.ubuntu.com/v1/bb8a72f8-grafana_0.png)

Select the button to add a new data source and select “Prometheus”. On the “Data Sources / Prometheus” edit page, set:
选择添加新数据源的按钮并选择“Prometheus”。在“数据源/ Prometheus”编辑页面上，设置： 

- the name to Prometheus
  普罗米修斯的名字 
- the URL to `http://localhost:9090` URL为 `http://localhost:9090` 
- ‘Access’ to “Server (default)” to make Grafana pull data from the Prometheus service we set up.
  “访问”“服务器（默认）”，让Grafana从我们设置的Prometheus服务中提取数据。 

The remaining settings can be left as defaults. Click “Save & Test”.
其余设置可以保留为默认值。点击“保存和测试”。 

![grafana_1](https://assets.ubuntu.com/v1/5bf5a238-grafana_1.png) ![grafana_2](https://assets.ubuntu.com/v1/72f14261-grafana_2.png)

Returning to the Grafana home page, next set up a “New Dashboard”. A dashboard  can hold one or more panels, each of which can be connected to one or  more data queries. Let’s add a panel for CPU data. For the query, enter  “cpu_usage_system” in the Metrics field.
返回Grafana主页，接下来设置一个“新仪表板”。仪表板可以包含一个或多个面板，每个面板可以连接到一个或多个数据查询。让我们为CPU数据添加一个面板。对于该查询，请在“CPU_usage_system”字段中输入。 

![grafana_3](https://assets.ubuntu.com/v1/bf7c1660-grafana_3.png) ![grafana_4](https://assets.ubuntu.com/v1/50532a03-grafana_4.png) ![grafana_5](https://assets.ubuntu.com/v1/0830c195-grafana_5.png)

On the left you can see four buttons to configure four elements of the  panel: data source, visualisation, general settings, and alerts. The  general settings page allows us to set a title for the panel, for  instance. Make any other customisations you want, and then save the  dashboard using the save icon at the top of the page.
在左侧，您可以看到四个按钮，用于配置面板的四个元素：数据源、可视化、常规设置和警报。例如，常规设置页面允许我们为面板设置标题。进行所需的任何其他自定义，然后使用页面顶部的保存图标保存仪表板。 

![grafana_6](https://assets.ubuntu.com/v1/cfaca920-grafana_6.png) ![grafana_7](https://assets.ubuntu.com/v1/3dfc6d9d-grafana_7.png)

Using the same procedure, add additional panels for processor load and memory usage. Panels can be used to present other types of data as well, such  as numerical indicators, logs, newsfeeds, or markdown-formatted  documentation. For example, you can add a panel to display the system  uptime, such as in the following image:
使用相同的过程，添加处理器负载和内存使用的其他面板。面板也可以用来显示其他类型的数据，如数字指标、日志、新闻源或markdown格式的文档。例如，您可以添加一个面板来显示系统配置文件，如下图所示： 

![grafana_9](https://assets.ubuntu.com/v1/2441c52c-grafana_9.png)

Try also adding a panel with the “Text” visualisation option for entering  descriptive text about our demo. Save, and then view the final  dashboard:
也可以尝试添加一个带有“文本”可视化选项的面板，用于输入有关我们演示的描述性文本。保存，然后查看最终仪表板： 

![grafana_X](https://assets.ubuntu.com/v1/55658d4d-grafana_X.png)