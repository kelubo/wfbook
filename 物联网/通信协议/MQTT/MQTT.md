# MQTT

[TOC]

## 概述

MQTT : The Standard for IoT Messaging 物联网消息传递的标准

MQTT 是物联网（IoT）的 OASIS 标准消息传递协议。它被设计为一种非常轻量级的发布/订阅消息传输，非常适合以较小的代码占用和最小的网络带宽连接远程设备。MQTT 如今用于各种行业，如汽车、制造业、电信、石油和天然气等。

## 为什么选择 MQTT？

* 轻巧高效

  MQTT 客户端非常小，需要最少的资源，因此可以在小型微控制器上使用。MQTT 消息头很小，以优化网络带宽。

* 双向通信

  MQTT 允许设备到云和云到设备之间的消息传递。这使得很容易将消息广播到一组事物。

* 扩展到数百万件事物

  MQTT 可以扩展到连接数百万个物联网设备。

* 可靠的消息传递

  消息传递的可靠性对于许多物联网用例都很重要。这就是为什么 MQTT 有 3 个定义的服务质量级别：0 - 最多一次，1 - 至少一次，2 - 正好一次

* 支持不可靠的网络

  许多物联网设备通过不可靠的蜂窝网络连接。MQTT 对持久会话的支持减少了重新连接客户端和代理的时间。

* Security Enabled  启用安全的

  MQTT 可以轻松地使用 TLS 加密消息，并使用现代身份验证协议（如 OAuth）对客户端进行身份验证。

## MQTT 发布/订阅架构

 ![](../../Image/m/mqtt-publish-subscribe.png)

## MQTT 在行动

MQTT 用于各种行业：

* Automotive 汽车
* Logistics 物流
* Manufacturing 制造
* Smart Home 智能家居
* Consumer Products 消费产品
* Transportation 运输

## 什么是 MQTT 服务器（MQTT Broker）？

[MQTT](https://www.emqx.com/zh/blog/the-easiest-guide-to-getting-started-with-mqtt) 是一种适用于物联网的轻量级协议，MQTT Broker 是其核心组件

MQTT Broker 是一种中介实体，帮助 MQTT 客户端进行通信。作为中央枢纽，MQTT Broker 能够高效管理设备与应用之间的信息流。具体来说，MQTT Broker 接收客户端发布的消息，根据主题对消息进行过滤，并分发给订阅者。

通过使用 MQTT Broker 实现发布/订阅通信模型，可以显著提高 MQTT 协议的效率和可扩展性。这种由 Broker  促成的通信方式，为设备在网络环境中共享信息提供了轻量级、可扩展且可靠的机制，在构建高效、响应迅速的物联网生态系统和其他分布式应用中发挥着重要作用。

## MQTT Broker 的重要性

MQTT Broker 是 MQTT 架构的核心，因为它负责协调 MQTT 客户端（发布者和订阅者）之间的通信。

以下是 MQTT Broker 的一些重要作用：

- **消息路由：**MQTT Broker 接收发布者发送的消息，并根据主题将其转发给相应的订阅者。这保证了消息能够有效和准确地传送，而无需客户端之间建立直接连接。
- **扩展性：**MQTT Broker 能够处理大量并发连接，这对于物联网和 M2M 通信场景非常重要，在这些场景中，可能有成千上万甚至数百万个设备连接。Broker 处理这些连接和消息的能力使 MQTT 协议能够高效地扩展。
- **安全性：**MQTT Broker 可以提供身份验证和加密等安全机制，以保证物联网设备和应用之间数据传输的安全性。要了解更多信息请阅读：[MQTT 安全指南：2024 年你需要了解的 7 个要点](https://www.emqx.com/zh/blog/essential-things-to-know-about-mqtt-security)。
- **集成性：**MQTT Broker  可以与其他通信协议和云平台集成，以构建完整的物联网解决方案。例如，MQTT Broker 可以与 AWS IoT、Google Cloud  IoT 或 Microsoft Azure IoT Hub 集成，以实现一个无缝的物联网生态系统。
- **会话管理：**MQTT Broker 负责管理客户端会话，包括维护客户端订阅信息，以及处理保留消息以便在客户端上线时发送给客户端。会话管理功能可以确保在客户端断开连接并在稍后重新连接到 Broker 时不会丢失消息。要了解更多信息请阅读：[MQTT Persistent Session 与 Clean Session 详解](https://www.emqx.com/zh/blog/mqtt-session)。

## MQTT Broker 架构

MQTT Broker 架构基于[发布-订阅消息传输模式](https://www.emqx.com/zh/blog/mqtt-5-introduction-to-publish-subscribe-model)，将消息生产者（发布者）与消息消费者（订阅者）解耦。该架构包括三个主要组件：客户端、主题和 Broker 。

- **MQTT Broker 服务器**

  MQTT Broker 是个服务器，它接收发布者发送的消息，并根据订阅者订阅的主题将消息转发给订阅者。它管理客户端连接、处理订阅和退订，并保证按照指定的[服务质量（QoS）级别](https://www.emqx.com/zh/blog/introduction-to-mqtt-qos)发送消息。

- **MQTT 客户端**

  MQTT 客户端可以是发布者，也可以是订阅者，或者两者都是。发布者向 MQTT Broker 发送消息，而订阅者从 Broker  接收消息。客户端可以是任何能够使用 MQTT 协议与 MQTT Broker 建立连接的设备或应用，如物联网设备、移动应用或其他服务器。

- **主题**

  主题是具有层次结构的字符串，描述了消息的类别。当发布者向 Broker 发送消息时，会指定一个主题。订阅者通过订阅一个或多个 [MQTT 主题](https://www.emqx.com/zh/blog/advanced-features-of-mqtt-topics)来表明他们想要接收消息的类别。Broker 根据用户订阅的主题，将消息转发给相应的用户。

MQTT Broker 架构可以是集中式的，也可以是分布式的。在集中式架构中，单个 Broker  负责客户端之间的所有通信。在分布式架构中，多个 Broker 协同工作，以构建一个可扩展和容错的消息传输基础设施。分布式架构中的每个  Broker 都可以与其他 Broker 通信，管理消息转发，保证消息送达预期的接收者。

总之，MQTT Broker 架构提供了一个灵活高效的消息传输基础架构，使设备和应用能够安全、高效和大规模地进行通信。

## 热门开源 MQTT Broker

### EMQX

[EMQX](https://github.com/emqx/emqx) 是目前物联网应用中最具扩展性的 MQTT  Broker。它能够以亚毫秒级的延迟在一秒钟内处理百万级的 MQTT 消息，并支持在一个集群内连接高达 1 亿个客户端进行消息传输。EMQX  兼容 MQTT 5.0 和 3.x 版本。它是分布式物联网网络的理想选择，可以在 Microsoft Azure、Amazon Web  Services 和 Google Cloud 等云上运行。EMQX 支持 MQTT over TLS/SSL，并支持多种认证机制，如  PSK、JWT 和 X.5093。与 Mosquitto 不同，EMQX 支持通过 CLI、HTTP API 和 Dashboard  进行集群管理。

### Mosquitto

[Eclipse Mosquitto](https://github.com/eclipse/mosquitto)  也是一款开源的 MQTT Broker，兼容 MQTT 协议的 5.0、3.1.1 和 3.1 版本。Mosquitto  体积小巧，既可以运行在低功耗的单板计算机上，也可以部署在企业级服务器上。它采用 C 语言编写，可以用 C 库实现 MQTT 客户端。它支持  Windows、Mac、Linux 和 Raspberry Pi  等多种平台，为每个平台提供了方便安装的二进制文件。最新版本还增加了一个认证和授权插件 “mosquitto-go-auth”，以及一个用于管理  Mosquitto 实例的 Web 用户界面。此外，它还提供了一个 PHP 包装器 “Mosquitto-PHP”，可以方便地在 PHP 中开发 MQTT 客户端。

### NanoMQ

[NanoMQ](https://nanomq.io/zh) 是一款为物联网边缘设计的轻量级 MQTT Broker。NanoMQ 以纯 C 语言实现，基于 NNG 的异步 I/O 和多线程 [Aactor 模型](https://en.wikipedia.org/wiki/Actor_model)，支持 MQTT 3.1.1 和 MQTT 5.0。NanoMQ 在独立 Broker  的环境中具有较高的性能。它的优势在于它的可移植性，它可以部署在任何 POSIX 兼容的平台上，并可在 x86_64、ARM、MIPS 和  RISC-V 等多种 CPU 架构上运行。

### VerneMQ

[VerneMQ](https://github.com/vernemq/vernemq) 项目于 [2014](https://github.com/vernemq/vernemq/tree/3c7703f0d62e758ba22a34ceb756f2ac2a4da44a) 启动，最初由 [Erlio GmbH](https://vernemq.com/company.html) 开发。它是第二个用 Erlang/OTP 开发的 MQTT Broker，该项目遵循 Apache 2.0 开源协议，并借鉴了 EMQX 项目的[部分代码](https://github.com/vernemq/vernemq/blob/ff75cc33d8e1a4ccb75de7f268d3ea934c9b23fb/apps/vmq_commons/src/vmq_topic.erl)。在架构设计方面，VerneMQ 支持将 MQTT 消息持久化到 LevelDB 中，并使用基于 [Plumtree](https://github.com/lasp-lang/plumtree) 库的集群架构，该库实现了 [Epidemic Broadcast Trees](https://asc.di.fct.unl.pt/~jleitao/pdf/srds07-leitao.pdf) 算法。

## MQTT Broker 选择指南以及一些有用的评估资源

接下来，本文将指导您如何根据需求，评估和选择最合适的 MQTT Broker。

### 评估标准

- [**选择 MQTT Broker 时要考虑的 7 个因素**](https://www.emqx.com/zh/blog/7-factors-to-consider-when-choosing-mqtt-broker-2023)

  正在寻找 2024 年最适合您的 MQTT Broker？在做出决策之前，请考虑这七个基本要素。请阅读我们的指南以获取更多信息。

### MQTT Broker 对比

- [**开源 MQTT Broker 综合比较**](https://www.emqx.com/en/blog/a-comprehensive-comparison-of-open-source-mqtt-brokers-in-2023)

  这篇文章对 2024 年最受欢迎的开源 MQTT Broker 进行了详细比较，以便您根据自己的需求做出明智的选择。

- [**最适用于工业物联网领域的三款开源 MQTT Broker**](https://www.emqx.com/zh/blog/top-3-open-source-mqtt-brokers-for-industrial-iot-in-2023)

  这篇文章对 2024 年[工业物联网](https://www.emqx.com/zh/blog/iiot-explained-examples-technologies-benefits-and-challenges)领域最优秀的 3 款 MQTT Broker 进行了对比分析，介绍了它们各自的优缺点和适用场景。

- [**EMQX vs Mosquitto | MQTT Broker 对比**](https://www.emqx.com/zh/blog/emqx-vs-mosquitto-2023-mqtt-broker-comparison)

  要了解 EMQX 和 Mosquitto 这两款 2024 年备受关注的开源 MQTT Broker 的异同，请阅读我们的详细对比。

- [**EMQX vs NanoMQ | MQTT Broker 对比**](https://www.emqx.com/zh/blog/emqx-vs-nanomq-2023-mqtt-broker-comparison)

  根据您的物联网项目需求，从 EMQX 和 NanoMQ 这两款 MQTT Broker 中选择最合适的一款。请阅读我们的指南，了解它们在扩展性、安全性和可靠性方面的差异。

- [**EMQX vs VerneMQ | MQTT Broker 对比**](https://www.emqx.com/zh/blog/emqx-vs-vernemq-2023-mqtt-broker-comparison)

  请阅读我们对 EMQX 和 VerneMQ 这两款 MQTT Broker 的详细分析，以便您根据自己的物联网项目需求做出正确的选择。

- [**Mosquitto vs NanoMQ | MQTT Broker 对比**](https://www.emqx.com/zh/blog/mosquitto-vs-nanomq-2023-mqtt-broker-comparison)

  这篇文章对 Mosquitto 和 NanoMQ 这两款 MQTT Broker 进行了对比分析，并为读者提供了 2024 年它们各自适用的应用场景。

- [**热门在线公共 MQTT Broker 评估**](https://www.emqx.com/zh/blog/popular-online-public-mqtt-brokers)

  这篇文章为您整理了一些免费的在线 MQTT Broker，并对它们的特点和优劣进行了分析，希望能帮助您做出正确的选择。

### MQTT Broker 基准测试

- [**MQTT 开放基准测试规范：全面评估你的 MQTT Broker 性能**](https://www.emqx.com/zh/blog/open-mqtt-benchmark-suite-the-ultimate-guide-to-mqtt-performance-testing)

  这篇文章介绍了 Open MQTT Benchmark Suite 的原理和功能，以及如何利用它对 MQTT Broker 的扩展性和性能进行客观公正的评估。

- [**MQTT 开放基准测试对比: 2024 年的 MQTT Broker**](https://www.emqx.com/en/blog/open-mqtt-benchmarking-comparison-mqtt-brokers-in-2023)

  这篇文章为您提供了 2024 年物联网领域最流行的 MQTT Broker 的对比分析，帮助您找到最适合您的 MQTT Broker。立即获取详尽的基准报告，了解各个 MQTT Broker 的优势和劣势。

- [**MQTT 开放基准测试对比: Mosquitto vs NanoMQ**](https://www.emqx.com/en/blog/open-mqtt-benchmarking-comparison-mosquitto-vs-nanomq)

  这篇文章利用 MQTT 开放基准测试工具，对 Mosquitto 和 NanoMQ 这两款 MQTT Broker 的性能进行了全方位的分析和对比。通过这篇文章，您可以了解两款 MQTT Broker 的特点和差异，从而选择最符合您需求的 Broker。

- [**MQTT 开放基准测试对比: EMQX vs NanoMQ**](https://www.emqx.com/en/blog/open-mqtt-benchmarking-comparison-emqx-vs-nanomq)

  这篇文章使用 Open MQTT Benchmark Suite 工具，对 EMQX 和 NanoMQ 这两款 MQTT Broker 的性能进行了全面的基准测试和评估，为您选择合适的 MQTT Broker 提供参考和指导。

- [**MQTT 开放基准测试对比: EMQX vs Mosquitto**](https://www.emqx.com/en/blog/open-mqtt-benchmarking-comparison-emqx-vs-mosquitto)

  这篇文章采用 MQTT 开放基准测试工具，对 EMQX 和 Mosquitto 这两款 MQTT Broker 的性能进行了综合分析和比较，从而帮助您选择最适合您需求的 MQTT Broker。

- [**MQTT 开放基准测试对比: EMQX vs VerneMQ**](https://www.emqx.com/en/blog/open-mqtt-benchmarking-comparison-emqx-vs-vernemq)

  这篇文章采用 MQTT 开放基准测试工具，对 EMQX 和 VerneMQ 这两款 MQTT Broker 的性能进行了综合分析和比较，从而帮助您选择最适合您需求的 MQTT Broker。

- [**高度可扩展，EMQX 5.0 达成 1 亿 MQTT 连接**](https://www.emqx.com/zh/blog/reaching-100m-mqtt-connections-with-emqx-5-0)

  为了评估 EMQX 的扩展性，我们在一个由 23 个 EMQX 节点组成的集群上，建立了 1 亿个 MQTT 连接，并观察了 EMQX 的性能表现。

## 快速入门 MQTT Broker

您可以轻松地通过免费公共 MQTT Broker 或全托管 MQTT 服务快速入门。

EMQ 提供了一个[免费的公共 MQTT 服务器](https://www.emqx.com/zh/mqtt/public-mqtt5-broker)，由全球多区域的 EMQX 集群构建，专为学习和测试 MQTT 协议的用户设计。请注意，不建议在生产环境中使用此公共 Broker，因为可能存在安全风险和停机问题。

全托管云服务是启动 MQTT 服务的最简单方式。通过 [EMQX Serverless](https://www.emqx.com/zh/cloud/serverless-mqtt) 版本，您可以在几分钟内开始运行 MQTT 服务，并在 AWS、Google Cloud 和 Microsoft Azure 的 20  多个区域中部署，实现全球覆盖和快速连接。EMQX Serverless 为开发者提供每月免费 1M 会话分钟数，使其能在数秒内轻松启动 MQTT 部署。

​        免费试用 EMQX Serverless        

无须绑定信用卡

### 快速上手

- [**如何在 Ubuntu 上安装 MQTT Broker**](https://www.emqx.com/zh/blog/how-to-install-emqx-mqtt-broker-on-ubuntu)

  这篇文章以 EMQX 为例，教您如何在 Ubuntu 系统上搭建一个单节点 MQTT Broker。

- [**为 EMQX MQTT Broker 启用 SSL/TLS**](https://www.emqx.com/zh/blog/emqx-server-ssl-tls-secure-connection-configuration-guide)

  EMQX 提供了多种安全认证方式，这篇文章将教您如何在 EMQX 中为 MQTT 配置 SSL/TLS。

### MQTT Broker 集成

- [**EMQX+Prometheus+Grafana：MQTT 数据可视化监控实践**](https://www.emqx.com/zh/blog/emqx-prometheus-grafana)

  这篇文章教您如何将 EMQX 5.0 的监控数据集成到 Prometheus 平台，并使用 Grafana 工具来展示 EMQX 的监控数据，从而搭建一个简单而实用的 MQTT Broker 监控系统。

- [**EMQX + ClickHouse 实现物联网数据接入与分析**](https://www.emqx.com/zh/blog/emqx-and-clickhouse-for-iot-data-access-and-analysis)

  物联网数据采集涉及大量的设备和数据，需要高效的访问、存储、分析和处理能力。EMQX + ClickHouse 的组合完美地满足了这一需求。

- [**如何使用 ThingsBoard 接入 MQTT 数据**](https://www.emqx.com/zh/blog/how-to-use-thingsboard-to-access-mqtt-data)

  这篇文章以 ThingsBoard Cloud 和 EMQX Cloud 为例，介绍如何将第三方 MQTT Broker 集成到 ThingsBoard 平台，从而实现对 MQTT 数据的访问和管理。

- [**使用 Node-RED 处理 MQTT 数据**](https://www.emqx.com/zh/blog/using-node-red-to-process-mqtt-data)

  这篇文章教您如何使用 Node-RED 工具访问 MQTT Broker，并对 MQTT 数据进行预处理后再发送到 Broker。

- [**MQTT+MongoDB 实现高效物联网数据管理**](https://www.emqx.com/zh/blog/mqtt-and-mongodb-crafting-seamless-synergy-for-iot-data-mangement)

  本博客将演示如何使用 EMQX 从车辆收集传感器数据，并与 MongoDB 集成，实现实时数据存储和分析。

- [**MQTT + InfluxDB：构建面向储能领域的物联网时序数据应用**](https://www.emqx.com/zh/blog/building-an-iot-time-series-data-application-with-mqtt-and-influxdb)

  本文介绍了如何将能源存储设备与 EMQX 连接，并与 InfluxDB 集成，以确保可靠的数据存储并实现实时分析。

## MQTT Broker 在行业中的应用

- [**实时监控与控制**](https://www.emqx.com/zh/solutions/internet-of-things)：MQTT Broker 是物联网架构的核心，使设备能够发布和订阅主题。这实现了制造业、智能家居和医疗保健等行业中设备的实时监控与控制。
- [**工业传感器网络**](https://www.emqx.com/zh/blog/data-infrastructure-for-smart-factory)：在工业环境中，MQTT Broker 在收集和传播传感器数据方面发挥着关键作用，支持预测性维护和流程优化等应用。
- [**交通中的遥测**](https://www.emqx.com/zh/blog/revolutionizing-tsp-platforms)：MQTT Broker 实现了连接车辆之间的通信，支持车辆跟踪、性能监测和交通管理等应用中的遥测数据交换。
- [**能源管理**](https://www.emqx.com/zh/solutions/industries/energy-utilities)：MQTT Broker 协调智能电表、配电设备和能源管理系统之间的通信，提高能源系统的效率、可靠性和响应能力。
- [**物流与仓储**](https://www.emqx.com/zh/blog/how-emqx-revolutionizes-logistics-fleet-management)：MQTT Broker 支持供应链中的实时跟踪和可见性，使设备能够发布和订阅位置信息和状态更新，从而提高整体供应链效率。

## EMQX：全球最具扩展性的 MQTT Broker

[EMQX](https://github.com/emqx/emqx) 是全球最受欢迎的 MQTT Broker 之一，在 [GitHub](https://github.com/emqx/emqx) 上拥有 14k Stars。EMQX 项目于 2012 年启动，采用 Apache 2.0 协议开源。EMQX 是用 Erlang/OTP 编写的，这是一种专为构建大规模可扩展软实时系统而设计的编程语言。

EMQX 是全球最具扩展性的 MQTT Broker，支持 [MQTT 5.0](https://www.emqx.com/zh/blog/introduction-to-mqtt-5)、[MQTT-SN](https://www.emqx.com/zh/blog/connecting-mqtt-sn-devices-using-emqx) 和 [MQTT over QUIC](https://www.emqx.com/zh/blog/mqtt-over-quic) 等先进的功能。它支持无主集群架构，保证了高可用性和水平扩展性。自 5.0 版本起，EMQX 能够在由 23 个节点组成的单一集群上，支持高达 1 亿的 MQTT 并发连接。

EMQX 不仅提供了丰富的企业功能、数据集成、云主机服务，还有来自 EMQ 的商业支持。EMQX 以其卓越的性能、可靠性和可扩展性，赢得了企业、初创公司和个人开发者的广泛认可。EMQX 被应用于各个行业的关键业务场景，如物联网、[工业物联网](https://www.emqx.com/zh/use-cases/industrial-iot)、[网联汽车](https://www.emqx.com/zh/blog/connected-cars-and-automotive-connectivity-all-you-need-to-know)、[制造业](https://www.emqx.com/zh/solutions/industries/manufacturing)和电信。

## 轻量级物联网消息推送协议

　　`MQTT`是机器对机器(`M2M`)/物联网(`IoT`)连接协议。它被设计为一个极其轻量级的`发布/订阅`消息传输协议。对于需要较小代码占用空间和/或网络带宽非常宝贵的远程连接非常有用，是专为受限设备和低带宽、高延迟或不可靠的网络而设计。这些原则也使该协议成为新兴的“机器到机器”(`M2M`)或物联网(`IoT`)世界的连接设备，以及带宽和电池功率非常高的移动应用的理想选择。例如，它已被用于通过卫星链路与代理通信的传感器、与医疗服务提供者的拨号连接，以及一系列家庭自动化和小型设备场景。它也是移动应用的理想选择，因为它体积小，功耗低，数据包最小，并且可以有效地将信息分配给一个或多个接收器。 　

### 特点

- 开放消息协议，简单易实现
- 发布订阅模式，一对多消息发布
- 基于TCP/IP网络连接,提供有序，无损，双向连接。
- 1字节固定报头，2字节心跳报文，最小化传输开销和协议交换，有效减少网络流量。
- 消息QoS支持，可靠传输保证

### 应用

MQTT协议广泛应用于物联网、移动互联网、智能硬件、车联网、电力能源等领域。

- 物联网M2M通信，物联网大数据采集
- Android消息推送，WEB消息推送
- 移动即时消息，例如Facebook Messenger
- 智能硬件、智能家具、智能电器
- 车联网通信，电动车站桩采集
- 智慧城市、远程医疗、远程教育
- 电力、石油与能源等行业市场

### 最新消息

#### MQTT v5.0现在成为了OASIS官方标准

OASIS现在已经发布了官方的[MQTT v5.0标准](https://docs.oasis-open.org/mqtt/mqtt/v5.0/mqtt-v5.0.html) - 这对于已经为物联网（IoT）所用的消息传输协议来说，这是一个改进和功能的巨大飞跃。基于早期的v3.1.1标准，它具有重要的更新，同时最大限度地减少与现有版本的不兼容性。

新版本的亮点包括：

- 更好的错误报告 - 特别是，在发布的响应中添加了原因代码（PUBACK / PUBREC）。MQTT起源于输油管道沿线的传感器等使用案例 -  如果它们的消息发布未能传输，则传感器将不采取任何措施。然而，MQTT的用例现在要广泛得多，如果数据没有成功传输，手机上的应用程序可能会想要警告用户。返回代码现在出现在所有确认中（以及包含人类可读错误诊断的可选原因字符串）。
- 共享订阅 - 如果订阅上的消息速率很高，则可以使用共享订阅在多个接收客户端之间对消息进行负载平衡。
- 消息属性 - 消息标题中的元数据。这些用于实现此列表中的其他功能，但也允许用户定义的属性，例如通过告知接收方使用哪个密钥来解密消息内容来协助消息加密
- 消息过期 - 如果消息无法在用户定义的时间段内传递，则可以选择丢弃消息。
- 会话到期 - 如果客户端未在用户定义的时间段内连接，则可以丢弃状态（例如，订阅和缓冲的消息）而无需进行清理。
- 主题别名 - 允许将消息中的主题字符串替换为单个数字，从而减少发布者重复使用相同主题时需要传输的字节数。
- Will Delay - 如果客户端断开连接的时间超过用户定义的时间段, 则允许发布消息。允许有关重要客户端应用程序中断的通知, 而不会被误报淹没。
- 允许的功能发现 - 在连接开始时，可以传输最大数据包大小和（QoS> 0）消息的数量限制，以通知客户端允许执行的操作。 新功能的完整列表见[标准的附录C](https://docs.oasis-open.org/mqtt/mqtt/v5.0/os/mqtt-v5.0-os.html#_Toc3901293)。

在当今互联互通的世界中，各种设备通过网络无缝通信，实现自动化和数据交换。了解物联网和 MQTT 的相关知识变得愈加重要。本文是 MQTT 协议的入门指南，您可以通过本文了解 MQTT 的基本原理、核心概念及实际应用，快速开启 MQTT 服务和应用的开发。

## 什么是 MQTT？

MQTT（Message Queuing Telemetry  Transport）是一种轻量级、基于发布-订阅模式的消息传输协议，适用于资源受限的设备和低带宽、高延迟或不稳定的网络环境。它在物联网应用中广受欢迎，能够实现传感器、执行器和其它设备之间的高效通信。

## 为什么 MQTT 是适用于物联网的最佳协议？

MQTT 所具有的适用于物联网特定需求的特点和功能，使其成为物联网领域最佳的协议之一。它的主要特点包括：

- **轻量级：**物联网设备通常在处理能力、内存和能耗方面受到限制。MQTT 开销低、报文小的特点使其非常适合这些设备，因为它消耗更少的资源，即使在有限的能力下也能实现高效的通信。
- **可靠：**物联网网络常常面临高延迟或连接不稳定的情况。MQTT 支持多种 QoS 等级、会话感知和持久连接，即使在困难的条件下也能保证消息的可靠传递，使其非常适合物联网应用。
- **安全通信：**安全对于物联网网络至关重要，因为其经常涉及敏感数据的传输。为确保数据在传输过程中的机密性，MQTT 提供传输层安全（TLS）和安全套接层（SSL）加密功能。此外，MQTT 还通过用户名/密码凭证或客户端证书提供身份验证和授权机制，以保护网络及其资源的访问。
- **双向通信：**MQTT 的发布-订阅模式为设备之间提供了无缝的双向通信方式。客户端既可以向主题发布消息，也可以订阅接收特定主题上的消息，从而实现了物联网生态系统中的高效数据交换，而无需直接将设备耦合在一起。这种模式也简化了新设备的集成，同时保证了系统易于扩展。
- **连续、有状态的会话：**MQTT 提供了客户端与 Broker  之间保持有状态会话的能力，这使得系统即使在断开连接后也能记住订阅和未传递的消息。此外，客户端还可以在建立连接时指定一个保活间隔，这会促使  Broker 定期检查连接状态。如果连接中断，Broker 会储存未传递的消息（根据 QoS  级别确定），并在客户端重新连接时尝试传递它们。这个特性保证了通信的可靠性，降低了因间断性连接而导致数据丢失的风险。
- **大规模物联网设备支持：**物联网系统往往涉及大量设备，需要一种能够处理大规模部署的协议。MQTT  的轻量级特性、低带宽消耗和对资源的高效利用使其成为大规模物联网应用的理想选择。通过采用发布-订阅模式，MQTT  实现了发送者和接收者的解耦，从而有效地减少了网络流量和资源使用。此外，协议对不同 QoS  等级的支持使得消息传递可以根据需求进行定制，确保在各种场景下获得最佳的性能表现。
- **语言支持：**物联网系统包含使用各种编程语言开发的设备和应用。MQTT 具有广泛的语言支持，使其能够轻松与多个平台和技术进行集成，从而实现了物联网生态系统中的无缝通信和互操作性。您可以阅读我们的 [MQTT 客户端编程](https://www.emqx.com/zh/blog/category/mqtt-programming)系列文章，学习如何在 PHP、Node.js、Python、Golang、Node.js 等编程语言中使用 MQTT。

## MQTT 的工作原理

要了解 MQTT 的工作原理，首先需要掌握以下几个概念：MQTT 客户端、MQTT Broker、发布-订阅模式、主题、QoS。

**MQTT 客户端**

任何运行 [MQTT 客户端库](https://www.emqx.com/zh/mqtt-client-sdk)的应用或设备都是 MQTT 客户端。例如，使用 MQTT 的即时通讯应用是客户端，使用 MQTT 上报数据的各种传感器是客户端，各种 [MQTT 测试工具](https://www.emqx.com/zh/blog/mqtt-client-tools)也是客户端。

**MQTT Broker**

MQTT Broker 是负责处理客户端请求的关键组件，包括建立连接、断开连接、订阅和取消订阅等操作，同时还负责消息的转发。一个高效强大的 MQTT Broker 能够轻松应对海量连接和百万级消息吞吐量，从而帮助物联网服务提供商专注于业务发展，快速构建可靠的 MQTT 应用。

关于 MQTT Broker 的更多详情，请参阅文章 [2024 年最全面的 MQTT Broker 比较指南](https://www.emqx.com/zh/blog/the-ultimate-guide-to-mqtt-broker-comparison)。

**发布-订阅模式**

发布-订阅模式与客户端-服务器模式的不同之处在于，它将发送消息的客户端（发布者）和接收消息的客户端（订阅者）进行了解耦。发布者和订阅者之间无需建立直接连接，而是通过 MQTT Broker 来负责消息的路由和分发。

下图展示了 MQTT 发布/订阅过程。温度传感器作为客户端连接到 MQTT Broker，并通过发布操作将温度数据发布到一个特定主题（例如 `Temperature`）。MQTT Broker 接收到该消息后会负责将其转发给订阅了相应主题（`Temperature`）的订阅者客户端。

​                

**主题**

MQTT 协议根据主题来转发消息。主题通过 `/` 来区分层级，类似于 URL 路径，例如：

```awk
chat/room/1

sensor/10/temperature

sensor/+/temperature
```

MQTT 主题支持以下两种通配符：`+` 和 `#`。

- `+`：表示单层通配符，例如 `a/+` 匹配 `a/x` 或 `a/y`。
- `#`：表示多层通配符，例如 `a/#` 匹配 `a/x`、`a/b/c/d`。

> **注意**：通配符主题只能用于订阅，不能用于发布。

关于 MQTT 主题的更多详情，请参阅文章[通过案例理解 MQTT 主题与通配符](https://www.emqx.com/zh/blog/advanced-features-of-mqtt-topics)。

**QoS**

MQTT 提供了三种服务质量（QoS），在不同网络环境下保证消息的可靠性。

- QoS 0：消息最多传送一次。如果当前客户端不可用，它将丢失这条消息。
- QoS 1：消息至少传送一次。
- QoS 2：消息只传送一次。

关于 MQTT QoS 的更多详情，请参阅文章 [MQTT QoS 0, 1, 2 介绍](https://www.emqx.com/zh/blog/introduction-to-mqtt-qos)。

## MQTT 的工作流程

在了解了 MQTT 的基本组件之后，让我们来看看它的一般工作流程：

1. **客户端使用 TCP/IP 协议与 Broker 建立连接**，可以选择使用 TLS/SSL 加密来实现安全通信。客户端提供认证信息，并指定会话类型（Clean Session 或 Persistent Session）。
2. **客户端既可以向特定主题发布消息，也可以订阅主题以接收消息**。当客户端发布消息时，它会将消息发送给 MQTT Broker；而当客户端订阅消息时，它会接收与订阅主题相关的消息。
3. **MQTT Broker 接收发布的消息**，并将这些消息转发给订阅了对应主题的客户端。它根据 QoS 等级确保消息可靠传递，并根据会话类型为断开连接的客户端存储消息。

## 开始使用 MQTT：快速教程

下面我们将通过一些简单的示例来展示如何使用 MQTT。在开始之前，需要准备 MQTT Broker 和 MQTT 客户端。

### 准备 MQTT Broker

您可以选择私有部署或完全托管的云服务来建立自己的 MQTT Broker。或者您也可以使用免费的公共 Broker。

EMQX 是一个可以「无限连接、任意集成、随处运行」的大规模分布式企业级 MQTT 物联网接入平台。它根据用户的不同需求提供了多个版本选择：

- **全托管的云服务**

  通过全托管的云服务启动 MQTT 服务是最便捷的方式。如下图所示，EMQX Serverless 版本是基于多租户架构的 MQTT  云服务，具有按量付费和灵活扩容的特性，可以在几分钟内启动，并在 AWS、Google Cloud 和 Microsoft Azure 的 17  个区域提供运行支持。

  ​        免费试用 EMQX Serverless        

  无须绑定信用卡

- **免费的公共 MQTT Broker**

  在本文中，我们将使用 EMQ 提供的[免费公共 MQTT 服务器](https://www.emqx.com/zh/mqtt/public-mqtt5-broker)，它基于完全托管的 [MQTT 云服务 - EMQX Cloud](https://www.emqx.com/zh/cloud) 创建。服务器信息如下：

  > Server: `broker.emqx.io`
  >
  > TCP Port: `1883`
  >
  > WebSocket Port: `8083`
  >
  > SSL/TLS Port: `8883`
  >
  > Secure WebSocket Port: `8084`

### 准备 MQTT 客户端

在本文中，我们将使用 [MQTTX](https://mqttx.app/zh) 提供的支持浏览器访问的 MQTT 客户端工具，访问地址为 https://mqttx.app/web-client/ 。 MQTTX 还提供了[桌面客户端](https://mqttx.app/zh)和[命令行工具](https://mqttx.app/zh/cli)。

[MQTTX](https://mqttx.app/zh) 是一款跨平台的 MQTT 5.0 桌面客户端，可在 macOS、Linux、Windows 操作系统上运行。其用户友好的聊天式界面使用户能够轻松创建多个 MQTT/MQTTS 连接，并进行 MQTT 消息的订阅和发布。

​                ![MQTTX](https://assets.emqx.com/images/ada10fb84b685af3cadcae6c95197c4f.gif?x-image-process=image/resize,w_1520/format,webp)

MQTTX 界面

目前，各种编程语言都拥有成熟的开源 MQTT 客户端库。我们在[流行的 MQTT 客户端库和 SDK](https://www.emqx.com/zh/mqtt-client-sdk) 中精选了多个编程语言的 MQTT 客户端库，并提供了详细的代码示例，旨在帮助您快速了解 MQTT 客户端的使用。

### 创建 MQTT 连接

在使用 MQTT 协议进行通信之前，客户端需要创建一个 MQTT 连接来连接到 Broker。

在浏览器中打开 https://mqttx.app/web-client/ , 点击页面中间的 `New Connection` 按钮，将看到如下页面。

​                ![创建 MQTT 连接](https://assets.emqx.com/images/5e110d181ce8489c275d5674910fa16d.png?x-image-process=image/resize,w_1520/format,webp)

我们在 `Name` 中输入 `Simple Demo`，然后点击右上角的 `Connect` 按钮，建立一个 MQTT 连接。如下图所示，表示连接成功。

​                ![MQTT 连接成功](https://assets.emqx.com/images/9583db03a552b24980cf49005e3dc668.png?x-image-process=image/resize,w_1520/format,webp)

要了解更多关于 MQTT 连接参数的内容，请查看我们的文章：[建立 MQTT 连接时如何设置参数](https://www.emqx.com/zh/blog/how-to-set-parameters-when-establishing-an-mqtt-connection)。

### 通过通配符订阅主题

接下来，我们在上面创建的 `Simple Demo` 连接中通过通配符订阅主题 `sensor/+/temperature`，这样就可以接收所有传感器发送的温度数据了。

如下图所示，点击 `New Subscription` 按钮，在弹出框中的 `Topic` 字段中输入主题 `sensor/+/temperature`，QoS 保持默认值 0。

​                ![订阅 MQTT 通配符主题](https://assets.emqx.com/images/79321fd9e22058e27a256152b60908d6.png?x-image-process=image/resize,w_1520/format,webp)

订阅成功后，会在订阅列表的中间看到新增了一条记录。

​                ![MQTT 主题订阅成功](https://assets.emqx.com/images/3687ba334049a0ca19e3300a2cbc4a98.png?x-image-process=image/resize,w_1520/format,webp)

### 发布 MQTT 消息

接下来，我们点击左侧菜单上的 `+` 按钮创建两个连接，分别命名为 `Sensor 1` 和 `Sensor 2`，用来模拟两个温度传感器。

​                ![创建 MQTT 连接](https://assets.emqx.com/images/0c96ec70a51ecc605bad4972edd77fb1.png?x-image-process=image/resize,w_1520/format,webp)

连接创建成功后，会看到三个连接，每个连接左侧的在线状态指示灯都是绿色的。

​                ![三个连接创建成功](https://assets.emqx.com/images/70010ba4da8d452ab0f738d36013dd9a.png?x-image-process=image/resize,w_1520/format,webp)

选择 `Sensor 1` 连接，在页面下方的发布主题中输入 `sensor/1/temperature`，在消息框中输入以下 JSON 格式的消息，然后点击右下方的发布按钮发送消息。

```json
{
  "msg": "17.2"
}
```

​                ![发布 MQTT 消息](https://assets.emqx.com/images/859966556e5649f1d6ec9bf378162def.png?x-image-process=image/resize,w_1520/format,webp)

如下图所示，消息发送成功。

​                ![MQTT 消息发布成功](https://assets.emqx.com/images/b1a46d8a415603d87e0c4244ee34bc02.png?x-image-process=image/resize,w_1520/format,webp)

使用相同的步骤，在 `Sensor 2` 连接中发布以下 JSON 消息到 `sensor/2/temperature` 主题。

```json
{
  "msg": "18.2"
}
```

您会看到 `Simple Demo` 连接收到两条新消息。

​                ![2条消息提示](https://assets.emqx.com/images/f815767a47f234424ae55ea0fe39eb04.png?x-image-process=image/resize,w_1520/format,webp)

点击 `Simple Demo` 连接，会看到两个传感器发送的两条消息。

​                ![查看消息详情](https://assets.emqx.com/images/f88de809773829f6a86dcedc2f612dd5.png?x-image-process=image/resize,w_1520/format,webp)

### MQTT 功能演示

#### 保留消息

当 MQTT 客户端向服务器发布消息时，可以设置保留消息标志。保留消息存储在消息服务器上，后续订阅该主题的客户端仍然可以收到该消息。

如下图所示，我们在 `Sensor 1` 连接中勾选 `Retain` 选项，然后向 `retained_message` 主题发送两条消息。

​                ![MQTT Retain](https://assets.emqx.com/images/5c7dcb078d223e0b6d33cb66241caa5d.png?x-image-process=image/resize,w_1520/format,webp)

接着，我们在 `Simple Demo` 连接中订阅 `retained_message` 主题。订阅成功后，会收到 `Sensor 1` 发送的第二条保留消息，这说明服务器只会为主题保留最近的一条保留消息。

​                ![MQTT 保留消息](https://assets.emqx.com/images/afe8cca62d576404d5f622f362ef3592.png?x-image-process=image/resize,w_1520/format,webp)

关于保留消息的更多细节，请阅读文章 [MQTT 保留消息初学者指南](https://www.emqx.com/zh/blog/mqtt5-features-retain-message)。

#### Clean Session

MQTT 客户端通常只能在在线状态下接收其它客户端发布的消息。如果客户端离线后重新上线，它将无法收到离线期间的消息。

但是，如果客户端连接时设置 Clean Session 为 false，并且使用相同的客户端 ID 再次上线，那么消息服务器将为客户端缓存一定数量的离线消息，并在它重新上线时发送给它。

> 本次演示使用的公共 MQTT 服务器设置为缓存 5 分钟的离线消息，最大消息数为 1000 条，且不保存 QoS 0 消息。

下面，我们创建一个 MQTT 3.1.1 连接，并用 QoS 1 来演示 Clean Session 的使用。

> MQTT 5.0 中将 Clean Session 拆分成了 Clean Start 与 Session Expiry Interval。详情请参考文章 [Clean Start 与 Session Expiry Interval](https://www.emqx.com/zh/blog/mqtt5-new-feature-clean-start-and-session-expiry-interval)。

创建一个名为 `MQTT V3` 的连接，设置 Clean Session 为 false，选择 MQTT 版本为 3.1.1。

​                ![设置 Clean Session 为 false](https://assets.emqx.com/images/1472ce0ea8e728647d973cae56e6b1d5.png?x-image-process=image/resize,w_1520/format,webp)

连接成功后，订阅 `clean_session_false` 主题，并将 QoS 设置为 1。

​                ![订阅 clean_session_false 主题](https://assets.emqx.com/images/7a5792040185d956803cb7406b2df3af.png?x-image-process=image/resize,w_1520/format,webp)

订阅成功后，点击右上角的断开按钮，断开连接。

​                ![断开 MQTT 连接](https://assets.emqx.com/images/fd5726bd0e2a5b9d9d73a7095f322ecf.png?x-image-process=image/resize,w_1520/format,webp)

然后，创建一个名为 `MQTT_V3_Publish` 的连接，MQTT 版本也设置为 3.1.1。连接成功后，向 `clean_session_false` 主题发布三条消息。

​                ![创建一个名为 MQTT_V3_Publish 的连接](https://assets.emqx.com/images/0659785e98cb03f9d6e78497e0adb26f.png?x-image-process=image/resize,w_1520/format,webp)

接着，选择 `MQTT_V3` 连接，点击连接按钮重新连接到服务器，会收到三条离线消息。

​                ![接收到三条离线消息](https://assets.emqx.com/images/106cc289cbb3a07be2ed294dd97fe420.png?x-image-process=image/resize,w_1520/format,webp)

关于 Clean Session 的更多细节，请阅读文章 [MQTT Persistent Session 与 Clean Session 详解](https://www.emqx.com/zh/blog/mqtt-session)。

#### 遗嘱消息

MQTT 客户端在向服务器发起 CONNECT 请求时，可以选择是否发送遗嘱消息标志，并指定遗嘱消息的主题和有效载荷。

如果 MQTT 客户端异常离线（在断开连接前没有向服务器发送 DISCONNECT 消息），MQTT 服务器会发布遗嘱消息。

我们创建一个名为 `Last Will` 的连接来演示这个功能。

- 为了快速看到效果，我们把 Keep Alive 设置为 5 秒。
- Last-Will Topic 设置为 `last_will`。
- Last-Will QoS 设置为 `1`。
- Last-Will Retain 设置为 `true`。
- Last-Will Payload 设置为 `offline`。

​                ![创建名为 Last Will 的连接](https://assets.emqx.com/images/3fc9e2c463bd38c21dc7f523520c7076.png?x-image-process=image/resize,w_1520/format,webp)

连接成功后，我们断开电脑网络超过 5 秒（模拟客户端异常断开连接），然后再恢复网络。

接着启动 Simple Demo 连接，并订阅 `last_will` 主题。您会收到 `Last Will` 连接设置的遗嘱消息。

​                ![收到 Last Will 连接设置的遗嘱消息](https://assets.emqx.com/images/a216808a1ba964bbddc75708bc55c072.png?x-image-process=image/resize,w_1520/format,webp)

关于 MQTT 遗嘱消息的更多内容，请阅读文章 [MQTT 遗嘱消息的使用](https://www.emqx.com/zh/blog/use-of-mqtt-will-message)。

## 2024 年值得关注的 7 大 MQTT 协议技术趋势

### **MQTT over QUIC**

QUIC 是 Google 推出的一种基于 UDP 的新型传输协议，能够降低延迟、提高数据传输速率。将 QUIC 引入 MQTT  将为网络不稳定或低延迟要求的场景（如车联网和工业物联网）带来优势。EMQX 和未来的 MQTT 版本正逐步采用 MQTT over  QUIC，将引领物联网连接标准的重要变革。

更多详情，请查看博客：[MQTT over QUIC：物联网消息传输还有更多可能](https://www.emqx.com/zh/blog/mqtt-over-quic)

### **MQTT Serverless**

Serverless MQTT 作为前沿的架构创新，使 MQTT  服务的快速部署变得轻而易举。此外，其资源自动扩展和按需付费模式提供了极大的灵活性，有望推动 MQTT  更广泛的应用，降低运营成本，激发不同行业的创新协作。我们甚至可能看到每个物联网和工业物联网开发者都能拥有一个免费的 Serverless  MQTT 消息服务器。

​        免费试用 EMQX Serverless        

无须绑定信用卡

### **MQTT 多租户架构**

多租户架构是实现 Serverless MQTT 服务的一个重要基础。不同用户或租户的物联网设备可以连接至同一大规模 MQTT 集群，同时保持各自的数据和业务逻辑独立。支持多租户的 MQTT 服务器将降低管理负担，提升复杂场景或大规模物联网应用的灵活性。

更多详情，请查看博客：[MQTT 服务新趋势：了解 MQTT 多租户架构](https://www.emqx.com/zh/blog/multi-tenancy-architecture-in-mqtt)

### **MQTT Sparkplug 3.0**

MQTT Sparkplug 定义了如何通过 MQTT 连接传感器、执行器、PLC 和网关等工业设备，旨在简化工业设备的连接与通信，实现高效的数据采集、处理和分析。最新的 3.0 版本引入了更多高级功能，有望在工业物联网中得到更广泛的应用。

更多详情，请查看博客：[MQTT Sparkplug：在工业 4.0 时代架起 IT 和 OT 的桥梁](https://www.emqx.com/zh/blog/mqtt-sparkplug-bridging-it-and-ot-in-industry-4-0)

### **MQTT 统一命名空间**

统一命名空间（Unified Namespace）是一个建立在面向工业物联网和工业 4.0 的 MQTT Broker  上的解决方案架构。它采用星型拓扑，通过中央 MQTT Broker 连接工业设备、传感器和应用（如 SCADA、MES 和  ERP）。采用统一命名空间可以更高效地实现 OT 和 IT 系统的数据交换，最终实现统一。

更多详情，请查看博客：[统一命名空间（UNS）：面向工业物联网的下一代数据架构](https://www.emqx.com/zh/blog/unified-namespace-next-generation-data-fabric-for-iiot)

### **MQTT 跨域集群**

MQTT 跨域集群是一种创新架构，允许部署在不同区域或云端的 MQTT Broker 协同工作，形成一个统一的集群。它支持在多云环境中构建全球 MQTT 访问网络，使得本地接入的设备和应用无论物理位置如何都能相互通信。

更多详情，请查看博客：[EMQX 跨域集群：增强可扩展性，打破地域限制](https://www.emqx.com/zh/blog/exploring-geo-distribution-in-emqx-for-enhanced-scalability)

### **MQTT Streams**

MQTT Streams 是 MQTT 协议备受期待的一项扩展能力，能够在 MQTT Broker  内实时处理海量、高频的数据流。这一创新功能支持历史消息重播，确保数据一致性、审计和合规。内置的流处理功能将简化物联网数据处理架构，成为基于  MQTT 的物联网应用中实时数据管理的宝贵工具。

## 深入学习 MQTT

本文详细介绍了 MQTT 的基本概念和使用流程，您可以按照本文所学的内容尝试使用 MQTT 协议。

如果您想了解更多 MQTT 的知识，建议您阅读 EMQ 提供的 [MQTT 教程：从入门到精通](https://www.emqx.com/zh/mqtt-guide)系列文章，了解 MQTT 主题、通配符、保留消息、遗嘱消息等功能。通过这些文章，您将能够探索 MQTT 的更高级应用场景，并开始进行 MQTT 应用和服务的开发。