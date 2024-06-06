# Telemetry

## 产生背景

随着网络的普及和新技术的涌现，网络规模日益增大，部署的复杂度逐步提升，用户对业务的质量要求也不断提高。为了满足用户需求，网络运维务必更加精细化、智能化。当今网络的运维面临着如下挑战：

·   超大规模：管理的设备数目众多，监控的信息数量非常庞大。

·   快速定位：在复杂的网络中，能够快速地定位故障，达到秒级、甚至亚秒级的故障定位速度。

·   精细监控：监控的数据类型更多，且监控粒度更细，以便完整、准确地反应网络状况，据此预估可能发生的故障，并为网络优化提供有力的数据依据。网络运维系统不仅需要监控接口上的流量统计信息、每条流上的丢包情况、CPU和内存占用情况，还需要监控每条流的时延抖动、每个报文在传输路径上的时延、每台设备上的缓冲区占用情况等。

传统的网络监控手段（SNMP、CLI、日志）已无法满足网络需求：

·   SNMP和CLI主要采用“拉模式”获取数据，即发送请求来获取设备上的数据，限制了可以监控的网络设备数量，且无法快速获取数据。

·   SNMP Trap和日志虽然采用“推模式”获取数据，即设备主动将数据上报给监控设备，但仅上报事件和告警，监控的数据内容极其有限，无法准确地反映网络状况。

Telemetry是一项监控设备性能和故障的远程数据采集技术。它采用“推模式”及时获取丰富的监控数据，可以实现网络故障的快速定位，从而解决上述网络运维问题。

## 1.2 技术优势

Telemetry具有如下优势：

·   支持gRPC、INT、Telemetry Stream、ERSPAN等多种实现方式，满足用户的不同需求。

·   采集数据的精度高，且类型十分丰富，可以充分反映网络状况。

·   一次订阅，持续上报。相比传统网络监控技术的查询一次上报一次，Telemetry仅需配置一次，设备就可以持续上报数据，减轻了设备处理查询请求的压力。

·   故障定位更快速、精准。

## 1.3 Telemetry网络模型

如[图1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref17449539)所示，Telemetry网络模型中包括如下组成部分：

·   网络设备：接受监控的设备。网络设备对指定的监控数据进行采样，并将采样数据通过gRPC（Google Remote Procedure Call，Google远程过程调用）、INT（In-band Telemetry，带内遥测）、Telemetry Stream、ERSPAN（Encapsulated Remote Switch Port Analyzer，封装远程端口镜像）等方式定时上送给采集器。

·   采集器：用于接收和保存网络设备上报的监控数据。

·   分析器：用于分析采集器接收到的监控数据，对数据进行处理，并以图形化界面的形式将分析结果展现给用户。

·   控制器：通过NETCONF等方式向设备下发配置，实现对网络设备的管理。控制器可以根据分析器提供的分析数据，为网络设备下发配置，对网络设备的转发行为进行调整；也可以控制网络设备对哪些数据进行采样和上报。

图1 Telemetry网络模型

![img](https://resource.h3c.com/cn/202205/11/20220511_7183514_x_Img_x_png_0_1606183_30005_0.png)

 

## 1.4 Telemetry实现方式和差异

根据数据上报方式的不同，Telemetry的实现方式包括：

·   基于gRPC的Telemetry

基于gRPC的Telemetry技术可以采集设备的接口流量统计、CPU、告警等数据，对采集到的数据进行Protocol Buffer编码后，实时上报给采集器进行接收和存储。

·   基于INT的Telemetry

INT由Barefoot、Arista、Dell、Intel和Vmware提出，是一种从设备上采集数据的网络监控技术。设备主动向采集器上送采集数据，提供实时、高速的数据采集功能，达到对网络设备的性能及网络运行情况进行监控的目的。

INT主要用来采集报文经过的路径和报文传输时延等数据平面信息。INT监控粒度为单个数据包，可以实现完整的网络状态实时监控。

·   Telemetry Stream

Telemetry Stream是一种基于报文采样的网络流量监控技术，主要用于对流量传输路径和传输时延进行精确定位。

Telemetry Stream可以采集流量经过的每个设备的入接口及出接口信息，并打上相应的时间戳，可支持计算流量经过其中任意设备的传输时延。

·   基于ERSPAN的Telemetry

ERSPAN是一种端口报文镜像技术，它能够将端口上的报文镜像后，封装为协议号为0x88BE的GRE报文，并将其发送到远端监控设备。

用户可以根据实际需求定义待镜像的报文，例如镜像TCP三次握手报文以便监控TCP连接建立情况、镜像RDMA信令报文以便监控RDMA会话状态。

其中，gRPC上报的数据来自设备自身的业务模块，而INT、Telemetry Stream、ERSPAN上报的数据则来自设备收到的其他网络节点的报文。不同Telemetry方式的差异如[表1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref99637708)所示。

表1 不同Telemetry方式的差异

| 特征\Telemetry方式   | gRPC                                                         | INT                                                          | Telemetry Stream                                             | ERSPAN                                                       |
| -------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 测量对象             | XPath（采样路径）                                            | TCP/UDP报文                                                  | 各种报文                                                     | 各种报文                                                     |
| 测量对象的选择规则   | 通过配置订阅，指定某些XPath进行采样                          | 通过QoS策略或ACL进行报文过滤                                 | 通过ACL进行报文过滤                                          | ·   源端口、源VLAN和源CPU镜像  ·   流镜像                    |
| 报文采样方式         | ·   按周期采样数据并上报  ·   实时上报事件类数据             | 按采样率采样一部分报文（报文复制），再插入INT头得到INT报文   | 按采样率采样一部分报文（报文复制）                           | 报文镜像  支持按比例采样                                     |
| 测量数据             | 设备的各种配置数据、运行状态数据（接口的状态信息和统计数据等） | 转发路径上每台设备的设备信息、接口信息、队列信息、时间戳信息和转发路径信息 | 设备ID、流量入接口及其时间戳、流量出接口及其时间戳           | 时间戳                                                       |
| 时间戳精度           | 毫秒                                                         | 纳秒                                                         | 纳秒                                                         | 纳秒                                                         |
| 数据上送采集器的方式 | 各节点分别上报  根据gRPC协议栈将采样数据编码为订阅报文，发送给订阅关联的采集器 | 尾节点上报  INT报文封装在UDP报文中，查IP转发表发送给采集器   | 各节点分别上报  向镜像报文添加Telemetry Stream填充头，并封装含有采集器地址信息的UDP头及二三层头，再添加时间戳，查IP转发表转发给采集器 | 各节点分别上报  为镜像报文添加ERSPANv2头或ERSPANv3头后，重新计算CRC，为报文添加GRE头和IPv4报文头，通过IP网络路由转发到数据监测设备 |

 

## 1.5 Telemetry典型组网应用

网络中可以同时部署多种Telemetry技术，实现全方位、多角度的网络监控；也可以根据实际需要仅部署所需的Telemetry技术，针对某一方面进行实时监控。

如[图2](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref17397008)所示，gRPC、INT、ERSPAN将采集到的数据发送到数据采集器后，分析器可以分析数据并以图形化界面展现出来，以便管理员更加清晰地了解网络状态，快速定位网络故障。管理员还可以及时发现网络中潜在的问题，及时优化网络，以避免网络故障的发生。

图2 Telemetry典型应用

![img](https://resource.h3c.com/cn/202205/11/20220511_7183515_x_Img_x_png_1_1606183_30005_0.png)

![说明](https://resource.h3c.com/cn/202205/11/20220511_7183526_x_Img_x_png_2_1606183_30005_0.png)

采集器和分析器可以是两个独立的设备，也可以是一个设备。

 

# 2 基于gRPC的Telemetry

采用基于gRPC的Telemetry技术时，设备自动读取各种统计信息（CPU、内存、接口等），根据采集器的订阅要求将采集的信息通过gRPC协议上报给采集器，实现了比传统监控方式更加实时、高效的数据采集功能。

## 2.1 gRPC概述

### 2.1.1 gRPC协议栈

gRPC协议栈分层如[表2](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref515548477)所示。

表2 gRPC协议栈分层模型

| 分层                                           | 说明                                                         |
| ---------------------------------------------- | ------------------------------------------------------------ |
| 内容层                                         | 用于承载编码后的业务数据。业务数据的编码格式包括：  ·   GPB（Google Protocol Buffer）：高效的二进制编码格式，通过proto文件描述编码使用的数据结构。在设备和采集器之间传输数据时，该编码格式的数据比其他格式（如JSON）的数据具有更高的信息负载能力。业务数据使用GPB格式编码时，需要配合对应的业务模块proto文件才能解码。  ·   JSON（JavaScript Object Notation）：轻量级的数据交换格式，采用独立于编程语言的文本格式来存储和表示数据，易于阅读和编写。业务数据使用JSON格式编码时，通过公共proto文件即可解码，无需对应的业务模块proto文件。  设备和采集器通信时，双方的proto文件必须保持兼容。 |
| gRPC层                                         | 定义了RPC（Remote Procedure Call，远程过程调用）的协议交互格式  公共RPC方法定义在公共proto文件中，例如grpc_dialout.proto |
| HTTP 2.0层                                     | gRPC承载在HTTP 2.0协议上  HTTP 2.0协议具有首部数据压缩、单TCP连接支持多路请求、流量控制等性能增强特性 |
| TLS（Transport  Layer Security，传输层安全）层 | 该层是可选的，设备和采集器可以基于TLS协议进行通道加密和双向证书认证，实现安全通信 |
| 传输层                                         | TCP传输协议提供面向连接的、可靠的数据链路                    |

 

### 2.1.2 gRPC网络架构

如[图3](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref497912980)所示，gRPC网络采用客户端/服务器模型。

图3 gRPC网络架构

![img](https://resource.h3c.com/cn/202205/11/20220511_7183533_x_Img_x_png_3_1606183_30005_0.png)

 

设备作为服务器时，gRPC网络的工作机制如下：

(1)   服务器通过监听指定服务端口来等待客户端的连接请求。

(2)   用户通过执行客户端程序登录到服务器。

(3)   客户端调用.proto文件提供的gRPC方法发送请求消息。

(4)   服务器回复应答消息。

![说明](https://resource.h3c.com/cn/202205/11/20220511_7183534_x_Img_x_png_4_1606183_30005_0.png)

设备既可以作为gRPC服务器，也可以作为gRPC客户端，具体与两者的连接模式有关，请参见“[2.1.3 ](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref57879310)[Dial-in模式和Dial-out模式](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref57879314)”。

 

### 2.1.3 Dial-in模式和Dial-out模式

[图2](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref17397008)中，网络设备和采集器通过建立gRPC连接来输送设备的数据信息。设备支持以下两种gRPC连接模式：

·   Dial-in模式：设备作为gRPC服务器，采集器作为gRPC客户端。由采集器主动向设备发起gRPC连接并订阅需要采集的数据信息。

Dial-in模式支持以下操作：

¡   Get操作：获取设备运行状态和运行配置，以及向设备订阅事件。

¡   gNMI类操作，具体包括：

\-   gNMI Capabilities操作：获取设备的能力集。

\-   gNMI Get操作：获取设备运行状态和运行配置。

\-   gNMI Set操作：向设备下发配置。

\-   gNMI Subscribe操作：向设备订阅数据推送服务，包括事件触发类数据和周期采样类数据。

¡   CLI操作：向设备下发命令行。

·   Dial-out模式：设备作为gRPC客户端，采集器作为gRPC服务器。设备主动和采集器建立gRPC连接，将设备上配置的订阅数据推送给采集器。

![说明](https://resource.h3c.com/cn/202205/11/20220511_7183535_x_Img_x_png_5_1606183_30005_0.png)

gNMI（gRPC Network Management Interface，gRPC网络管理接口）是基于gRPC框架开发的一种操作协议，定义了一系列用于设备状态获取和配置操作的RPC方法。gNMI支持通用数据模型，不需要为内容层额外提供业务模块.proto文件。

 

## 2.2 gRPC可采集的数据信息

gRPC可采集的数据信息主要包括：

·   设备状态信息：例如CPU和内存状态。

·   物理接口状态信息：例如光模块状态和接口的带宽利用率。

·   接口的报文/队列统计数据：例如接口丢包和错包统计、队列丢包统计、队列Buffer资源占用状态。

·   表项/资源数据：例如转发表项资源、ACL流表资源和虚拟接口资源的使用情况。

## 2.3 基于gRPC的Telemetry应用场景

如[图4](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref57295327)所示，设备（SW A和SW B）作为gRPC客户端，采用Dial-out模式主动向采集和分析器上报事件数据。采集和分析器（作为gRPC服务器）通过上报的事件可以感知设备的业务状态，以便进行网络的状态和健康度分析，实现状态可视化。

图4 基于gRPC的Telemetry应用场景图

![img](https://resource.h3c.com/cn/202205/11/20220511_7183536_x_Img_x_png_6_1606183_30005_0.png)

 

# 3 基于INT的Telemetry

## 3.1 INT概述

### 3.1.1 产生背景

在传统网络中，我们对报文做转发路径探测时，经常会使用雷达探测技术。但是雷达探测技术，需要控制器软件的干预。由于没有硬件的支持，一系列的设计实现都比较复杂，而且还不能完全模拟真实的报文转发。

Ping和Tracert功能虽然可以定位网络延时和路径，但都不是很精确的方法。在对时延要求比较高的网络中，这两种方法都不能精准定位出在哪台设备的哪个端口上转发最耗时，因而不能有针对性地优化网络架构。INT（In-band Telemetry，带内遥测）技术正是为了满足这一需求而生。

INT作为可视化技术的一个重要组成部分，让网络管理和运维走向真正自动化的第一步，也是最关键的一步。通过INT技术，我们可以获知报文实际转发路径上的每台网络设备信息、报文在每台设备上的入出端口和队列信息、以及相应的时间戳信息等。

### 3.1.2 技术优点

通过INT技术，我们可以监测到报文转发路径上每台设备的入出端口和队列信息、入出设备的时间戳信息、队列的拥塞信息等；并且在路径探测的最后一跳上，将收集到的数据封装成UDP数据发送给采集器。最终通过部署在采集器上的网管软件，对监测数据进行分析，提取有用信息。

INT技术的主要优点有：

·   设备使用专用的INT处理器完成INT业务的处理。

·   管理员仅需对设备下发一次INT配置即可，INT采集数据会持续上报给采集器。

·   支持配置采样集数据的采样率。

·   通过QoS策略或ACL，可以灵活地调整需要进行路径探测的报文范围。

·   在路径探测的最后一跳，直接封装报文并发送给采集器。

·   收集探测路径上每台设备的设备信息、接口信息、队列信息、时间戳信息和转发路径信息等。

### 3.1.3 技术标准化

目前，INT技术已经在IETF的Inband Flow Analyzer draft-kumar-ippm-ifa-02草案中定义。在该草案中，对INT报文的固有头部和meta-data（即监测信息）的数据格式做了详细说明。对于支持该草案的网络设备来说，理论上可以实现INT报文分析处理的互通。

## 3.2 INT组网模型

根据配置方式和运行机制的不同，INT又分为普通型INT和灵活型INT。

·   普通型INT：每个节点的设备需要在入接口配置设备在INT网络中的角色。首节点通过QoS策略定义数据流，中间节点和尾节点自动识别INT报文并对报文进行相应的INT处理。因此，流量转发路径的每个入接口上都只支持对首节点定义的数据流进行INT处理。

·   灵活型INT：不需要配置设备在INT网络中的角色，每个节点的设备都可以通过ACL定义数据流（对于同一条流，首节点匹配原始报文，中间节点和尾节点匹配INT报文），并针对该数据流配置相应的INT处理动作（例如首节点上的镜像动作和添加采集信息动作）。设备支持在同一接口上通过ACL匹配多条数据流并针对不同的数据流分别配置INT处理动作。

图5 INT组网模型

![img](https://resource.h3c.com/cn/202205/11/20220511_7183537_x_Img_x_png_7_1606183_30005_0.png)

 

## 3.3 INT报文格式

### 3.3.1 INT报文头组成及封装位置

INT报文头包括INT Probe HDR（INT固有头部）和MD #1～N（监测信息meta-data）两部分。INT报文头的封装位置如[图6](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref20231288)所示。根据传输层协议的不同，INT报文可以分为INT over TCP和INT over UDP两种类型：

·   INT over TCP报文：对原始TCP报文进行镜像复制，并在TCP头后插入INT报文头。

·   INT over UDP报文：对原始UDP报文进行镜像复制，并在UDP头后插入INT报文头。

图6 INT报文格式

![img](https://resource.h3c.com/cn/202205/11/20220511_7183538_x_Img_x_png_8_1606183_30005_0.png)

 

### 3.3.2 INT固有头部格式

图7 INT固有头部格式

![img](https://resource.h3c.com/cn/202205/11/20220511_7183539_x_Img_x_png_9_1606183_30005_0.png)

 

INT报文固有头部格式如[图7](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref518580954)所示，各字段含义如下：

·   Probe Maker：设备通过此字段识别INT报文，目前固定填充为0xaaaaaaaabbbbbbbb。

·   Version：目前固定填充为0x01。

·   Message Type：消息类型，目前固定填充为0x01。

·   Flags：保留字段，目前固定填充为0x0000。

·   Telemetry Request Vector：目前固定填充为0xffffffff。

·   Hop Limit：最大跳数。

·   Hop Count：报文已经过网络节点数量。

·   Must Be Zero：目前固定填充为全0。

·   Maximum Length：INT报文采集数据的最大长度，单位为字节。

·   Current Length：INT报文采集数据的当前长度，单位为字节。

·   Sender`s Handle：由首节点自动填充，采集器根据此字段识别INT流，唯一标识流。

·   Sequence Number：INT流中报文的序号，同一个流中报文的唯一标识。

### 3.3.3 INT监测信息meta-data格式

![说明](https://resource.h3c.com/cn/202205/11/20220511_7183516_x_Img_x_png_10_1606183_30005_0.png)

对于INT报文格式，不同产品实现情况不同，请以实际情况为准。

 

图8 INT监测信息meta-data格式

![img](https://resource.h3c.com/cn/202205/11/20220511_7183517_x_Img_x_png_11_1606183_30005_0.png)

 

INT监测信息meta-data格式如[图8](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref518581833)所示，各字段含义如下：

·   Device-ID：设备ID。

·   Template-Id：保留字段，目前固定填充为000。

·   Congestion：拥塞标志位，即ECN。高3位固定填充0，低2位为ECN域。

·   Egress Port Drop Pkt Byte Cnt Upper：出接口丢包数，单位为字节，目前固定填充为0x00

·   IP_TTL：报文的TTL值。

·   Queue-Id：出接口队列ID，目前固定填充为0x00。

·   Rx Timestamp Seconds Upper/Rx Timestamp Seconds：入接口时间戳，单位为秒。

·   Rx Timestamp Nano-Seconds Upper：入接口时间戳，单位为纳秒。

·   Tx Timestamp Nano-Seconds Upper：出接口时间戳，单位为纳秒。

·   Egress Port Utilization [%]：出接口利用率，目前固定填充为0x0000。

·   Ingress Port [module, port]：入接口标识。

·   Egress Port [module, port]：出接口标识。

·   Egress Port Drop Pkt Byte Cnt：出接口丢包数，单位为字节，目前固定填充为0x00000000。

## 3.4 运行机制

### 3.4.1 普通型INT

普通型INT中各节点实现功能如下：

·   首节点

流量入接口上通过QoS策略将命中规则的报文镜像、采样至设备内部的INT处理器。处理器对其添加INT报文头，然后将INT报文环回至入接口。入接口根据INT标记自动识别INT报文，添加采集信息，查表转发。出接口添加采集信息，并发送给中间节点。

·   中间节点

流量入接口根据INT标记自动识别INT报文，添加采集信息，查表转发。出接口添加采集信息，发送给尾节点。

·   尾节点

流量入接口根据INT标记自动识别INT报文，添加采集信息，上送至INT处理器，INT处理器将INT报文封装在新的UDP报文中，然后查表转发至出接口，发送给采集器。

### 3.4.2 灵活型INT

以同一条流的INT处理为例，灵活型INT中各节点实现功能如下：

·   首节点

入接口通过ACL对原始报文进行筛选，命中规则的报文被镜像、采样至设备内部的INT处理器。处理器为其添加INT报文头，然后将INT报文环回至入接口。入接口通过ACL筛选出本机环回INT报文，对其添加采集信息，查表转发。出接口添加采集信息，并发送给中间节点。

·   中间节点

入接口通过ACL筛选出INT报文，为命中规则的报文添加采集信息后，查表转发。出接口添加采集信息，发送给尾节点。

·   尾节点

入接口通过ACL筛选出INT报文，命中规则的报文被镜像至INT处理器，INT处理器将INT报文封装在UDP报文中，然后查表转发至出接口，发送给采集器。

### 3.4.3 不同网络中INT的运行机制

INT在普通网络和EVPN/VXLAN网络中运行机制如[图9](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref57537589)和[图10](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref57537603)所示。

图9 INT在普通网络中的运行机制示意图

![img](https://resource.h3c.com/cn/202205/11/20220511_7183518_x_Img_x_png_12_1606183_30005_0.png)

 

图10 INT在EVPN/VXLAN网络中的运行机制示意图

![img](https://resource.h3c.com/cn/202205/11/20220511_7183519_x_Img_x_png_13_1606183_30005_0.png)

 

## 3.5 INT可采集的数据信息

INT可监测的数据信息主要有：

·   设备ID

报文转发路径上，每台设备的设备ID，即配置INT功能时指定的设备ID。

·   流量入接口ID

报文在INT网络各个节点的逻辑入接口。

·   入接口时间戳

报文从各个节点的流量入接口进入设备时的设备本地时间。对于首节点来说，是INT报文进入环回口的时间。

·   流量出接口ID

报文在INT网络各个节点的逻辑出接口。

·   出接口时间戳

报文从各个节点的流量出接口离开设备时的设备本地时间。

·   缓存信息

¡   缓存原始报文的队列ID。

¡   ECN信息

# 4 Telemetry Stream

## 4.1 Telemetry Stream概述

### 4.1.1 产生背景

在对实时性要求较高的网络中，需要能精准定位出哪台设备的哪个端口上转发报文最耗时。通过Telemetry Stream测量技术，可以获知流量经过的设备以及流量经过其入接口和出接口的时间，以此计算出流量经过某台设备或多台设备时的传输时延，从而有针对性地优化网络架构，降低网络延迟。

Telemetry Stream可监测的数据信息为：设备ID、流量入接口及其时间戳、流量出接口及其时间戳。其中，设备ID是配置Telemetry Stream功能时指定的Device ID，用于唯一标识报文传输路径上的设备。

### 4.1.2 技术优点

Telemetry Stream技术的主要优点有：

·   配置简单。

·   管理员仅需对设备下发一次Telemetry Stream配置，设备就会持续采集数据并上报给采集器。

·   可通过ACL调整路径探测的报文范围。

·   可通过修改采样器，灵活调整采样精度。

## 4.2 Telemetry Stream报文格式

![说明](https://resource.h3c.com/cn/202205/11/20220511_7183520_x_Img_x_png_14_1606183_30005_0.png)

对于Telemetry Stream报文格式，不同产品实现情况不同，请以实际情况为准。本节以S12500G-AF产品为例。

 

如[图11](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref90285745)所示，Telemetry Stream为采样的报文添加时间戳、Telemetry Stream填充头、UDP头、IP头、Ethernet头。其中时间戳、Telemetry Stream填充头的各字段含义如[表3](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref90133969)、[表4](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref90133972)所示。

图11 Telemetry Stream报文封装格式

![img](https://resource.h3c.com/cn/202205/11/20220511_7183521_x_Img_x_png_15_1606183_30005_0.png)

 

表3 时间戳各字段的含义

| 字段      | 长度（单位为bit） | 说明                                                         |
| --------- | ----------------- | ------------------------------------------------------------ |
| Time      | 48                | 从PTP模块获取的时间，包含16bits秒位和32bits纳秒位            |
| Reserved  | 8                 | 预留字段                                                     |
| Origin ID | 23                | 时间戳所在报文的源设备信息  Telemetry Stream的设备ID被拆分为2个16bits，分别存储在入接口时间戳和出接口时间戳的本字段的前16bits中 |
| Rx_Tx     | 1                 | 方向标记，取值包括：  ·   0：代表Receiver，即入接口时间戳  ·   1：代表Transmitter，即出接口时间戳 |
| FCS       | 32                | 帧校验序列（Frame Check Sequence）                           |

 

表4 Telemetry Stream填充头各字段的含义

| 字段            | 长度（单位为bit） | 说明                                                         |
| --------------- | ----------------- | ------------------------------------------------------------ |
| Version         | 32                | Telemetry Stream版本，目前固定为1                            |
| Src MID         | 8                 | 原始流量的源接口模块ID（Source Module ID）  Src MID和Src Port组成原始流量入接口的唯一标识 |
| Src Port        | 8                 | 原始流量的源端口号（Source Port）                            |
| Dst MID         | 8                 | 原始流量的目的接口模块ID（Destination Module ID）  Dst MID和Dst Port组成原始流量出接口的唯一标识 |
| Dst Port        | 8                 | 原始流量的目的端口号（Destination Port）                     |
| Flags           | 9                 | 标志位（1表示是，0表示否），比特位从左到右依次代表：  ·   Source_sample（1bit）：是否为基于Ingress port的Telemetry Stream采样  ·   Dest_sample（1bit）：固定为0  ·   Flex_sample（1bit）：是否为基于流的Telemetry Stream采样  ·   Mcast_sample（1bit）：是否为组播报文采样  ·   Discarded（1bit）：采样报文送往本地CPU处理时是否被丢弃  ·   Truncated（1bit）：固定为0（不剪裁）。目前所有采样都复制原报文进行UDP封装  ·   Dest_port_encoding（3bits）：  ¡   000：CPU之间通信的控制帧  ¡   001：目的地址已解析的二层或三层单播报文  ¡   010：组播报文、未知单播报文或未知组播报文，发往VLAN内所有端口  ¡   011：二层组播报文，发往组播组的所有端口  ¡   100：IP组播报文，发往组播组的所有端口  ¡   101、110、111：预留值 |
| Reserved        | 7                 | 预留字段                                                     |
| User metadata   | 16                | 可定制的用户信息                                             |
| Sequence number | 32                | 序列号                                                       |

 

## 4.3 Telemetry Stream运行机制

以[图12](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref90285884)中的Device B为例，Telemetry Stream工作机制如下：

(1)   所有参与测量的设备使用PTP达到纳秒级时间同步。

(2)   设备在入接口通过ACL筛选原始报文，对命中规则的报文，按设定的采样率抽取部分报文进行复制。

(3)   设备为复制的报文封装如下报文头：

¡   Telemetry Stream填充头（记录原始报文的入端口和出端口）

¡   UDP头和二三层头（记录采集器的端口号和MAC/IP地址）

¡   入接口时间戳（Rx Timestamp）

¡   出接口时间戳（Tx Timestamp）

(4)   设备将采样报文发送给采集器。采样报文的入接口时间戳和出接口时间戳中包含了报文所属的设备信息（设备ID）。

图12 Telemetry Stream工作机制示意图

![img](https://resource.h3c.com/cn/202205/11/20220511_7183522_x_Img_x_png_16_1606183_30005_0.png)

 

多个节点均各自向采集器上送采集信息，采集器就可以根据收集到的采集信息进行路径和时延计算：

·   流量经过指定设备的传输时延 = 该设备的出接口时间戳 – 该设备的入接口时间戳

·   流量经过多台设备的传输时延 = 出接口所在设备的出接口时间戳 – 入接口所在设备的入接口时间戳

# 5 基于ERSPAN的Telemetry

## 5.1 简介

ERSPAN（Encapsulated Remote Switch Port Analyzer，封装远程端口镜像）是一种三层远程镜像技术，通过复制指定端口、VLAN或CPU的报文，并通过GRE隧道将复制的报文发送到远程数据监测设备，使用户可以利用数据监测设备分析这些报文（称为镜像报文），以进行网络监控和故障排除。

ERSPAN支持端口镜像和流镜像两种实现方式。

## 5.2 报文封装格式

#### 1. ERSPANv2报文封装格式

ERSPANv2将镜像报文封装为协议号为0x88BE的GRE报文，如[图13](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref17893498)所示。

图13 ERSPANv2报文封装格式

![img](https://resource.h3c.com/cn/202205/11/20220511_7183523_x_Img_x_png_17_1606183_30005_0.png)

 

ERSPANv2为镜像报文添加ERSPANv2头后，重新计算CRC，并为报文添加GRE头和IPv4报文头。GRE头和ERSPANv2头中的关键字段含义为：

·   GRE头：

¡   标记位：S比特取值为1，表示可以通过序列号检查报文是否乱序；其余标记位取值为0。

¡   版本号：取值为0。

¡   协议类型：取值为0x88BE，表示GRE的承载协议为ERSPAN type II。

¡   序列号：报文的序列号，每增加一个报文，序列号加1。

·   ERSPANv2头：

¡   Ver：ERSPAN封装的版本，ERSPAN type II取值为1。

¡   VLAN：镜像报文的原始VLAN。

¡   CoS：镜像报文的原始CoS（Class of Service，服务等级）。

¡   En：ERSPAN流量源端口的数据帧封装类型。取值00表示不携带VLAN标签；01表示ISL封装；10表示802.1Q封装；11表示数据帧中携带VLAN标签。

¡   T：取值为1表示由于镜像报文超过接口的MTU，ERSPAN报文中封装的数据帧被进行了分片。

¡   Session ID：ERSPAN会话的标识，也称为ERSPAN ID。在同一个源和目的设备之间必须唯一。

¡   Reserverd：保留字段。

¡   Index：ERSPAN流量源端口和镜像方向的索引。

#### 2. ERSPANv3报文封装格式

ERSPANv3相比于ERSPANv2，引入了一个更大、更灵活的复合报文头，满足日益复杂和多样化的网络监控场景（比如网络管理、入侵检测、性能和延迟分析等），这些场景中需要知道原始镜像帧的所有参数，包括那些不存在于原始镜像帧本身的内容。

ERSPANv3将镜像报文封装为协议号为0x22EB的GRE报文，如[图14](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref90038339)所示。

图14 ERSPANv3报文封装格式

![img](https://resource.h3c.com/cn/202205/11/20220511_7183524_x_Img_x_png_18_1606183_30005_0.png)

 

ERSPANv3为镜像报文添加ERSPANv3头后，重新计算CRC，并为报文添加GRE头和IPv4报文头。GRE头和ERSPANv3头中的关键字段含义为：

·   GRE头：

¡   标记位：S比特取值为1，表示可以通过序列号检查报文是否乱序；其余标记位取值为0。

¡   版本号：取值为0。

¡   协议类型：取值为0x22EB，表示GRE的承载协议为ERSPAN type III。

¡   序列号：报文的序列号，每增加一个报文，序列号加1。

·   ERSPANv3头：

¡   Ver：ERSPAN封装的版本，ERSPAN type III取值为2。

¡   VLAN：镜像报文的原始VLAN。

¡   CoS：镜像报文的原始CoS（Class of Service，服务等级）。

¡   BSO：通过ERSPAN承载的数据帧的负载完整性。取值00表示完整的数据帧；11表示不完整的数据帧；01表示短帧；10表示超大帧。

¡   Session ID：ERSPAN会话的标识，也称为ERSPAN ID。在同一个源和目的设备之间必须唯一。

¡   Timestamp：时间戳，从与系统时间同步的硬件时钟中导出，这32bit的字段至少支持一个时间戳粒度为100微秒。有关时间戳粒度的详细说明，请参考Gra字段。

¡   SGT：镜像报文的安全组标记。通过SGT可以用来标注镜像报文来源的身份信息。

¡   P：协议标记，表示ERSPAN承载的是否为以太网协议帧。取值1表示是以太网协议帧，取值0表示不是以太网协议帧。

¡   FT：镜像报文是以太网帧还是IP包。取值0表示以太网帧，取值2表示IP包。

¡   HW ID：系统内ERSPAN引擎的唯一标识符。

¡   D：镜像报文的方向。取值0表示入方向镜像报文，取值1表示出方向镜像报文。

¡   Gra：定义时间戳的粒度。取值00b表示100微秒粒度；01b表示100纳秒粒度；10b表示IEEE 1588粒度；11b表示用户自定义的时间戳粒度。

¡   O：表示是否携带平台特定子头部，取值1表示携带；取值0表示未携带。

¡   Platf ID：平台特定子头部ID，不同的ID取值对应不同的平台特定子头部封装格式。目前只支持取值为0x5。

¡   Platform Specific SubHeader：平台特定子头部，具体格式如[图15](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref90051548)所示。

\-   Switch ID：标识镜像报文的来源设备。

\-   Port ID/Index：标识源设备上的目的端口。

\-   Timestamp：时间戳。在此封装格式下，ERSPANv3头中的Timestamp代表IEEE 1588纳秒、Gra的取值为10b，该Timestamp代表IEEE 1588秒。

图15 Platform Specific SubHeader格式

![img](https://resource.h3c.com/cn/202205/11/20220511_7183525_x_Img_x_png_19_1606183_30005_0.png)

 

## 5.3 端口镜像方式的ERSPAN

### 5.3.1 网络构成

端口镜像方式的ERSPAN网络由以下几部分构成：

·   镜像源：被监控的对象，可以是端口、VLAN或CPU，分别称为源端口、源VLAN和源CPU。经镜像源收发的报文会被复制一份，并发送到数据监测设备，以便对镜像报文进行监控和分析。

·   源设备：镜像源所在的设备。

·   镜像目的：镜像报文所要到达的目的地，即与数据监测设备相连的端口，该端口称为目的端口。目的端口会将镜像报文转发给与之相连的数据监测设备。

·   目的设备：目的端口所在的设备称为目的设备。

·   数据监测设备：接收镜像报文、对镜像报文进行分析处理的设备。

### 5.3.2 工作机制

端口镜像方式的ERSPAN分为Tunnel和配置封装参数两种方式。

#### 1. Tunnel方式

Tunnel方式三层远程端口镜像使用本地镜像组的方式实现，即在源设备和目的设备上分别创建各自的本地镜像组，每个本地镜像组也拥有各自的镜像源和目的端口。不同的是：

·   在源设备上：

¡   源端口为待监控的端口。

¡   源VLAN为待监控的端口所在的VLAN。

¡   源CPU为待监控的端口所在的CPU。

¡   目的端口为用于传输镜像报文的Tunnel接口。

·   在目的设备上：

¡   源端口为Tunnel接口对应的物理端口。

¡   源VLAN为Tunnel接口对应物理端口所在的VLAN。

¡   目的端口为连接数据监测设备的端口。

Tunnel方式三层远程端口镜像报文的转发过程如[图16](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref272328352)所示。

(1)   源设备将镜像源的入方向（收到的报文）、出方向（发出的报文）或双向（收到和发出的报文）报文复制一份给Tunnel接口（即目的端口）。

(2)   报文经由GRE隧道转发至目的设备端的Tunnel接口。

(3)   目的设备从该Tunnel接口对应的物理接口（即源端口）收到镜像报文后，将其复制一份给目的端口。

(4)   由目的设备上的目的端口将镜像报文转发到数据监测设备。

图16 Tunnel方式三层远程端口镜像示意图

![img](https://resource.h3c.com/cn/202205/11/20220511_7183527_x_Img_x_png_20_1606183_30005_0.png)

‌

#### 2. 配置封装参数方式

配置封装参数方式三层远程端口镜像仅需在源设备上指定镜像源和目的端口。同时所有设备上需配置单播路由协议，并确保设备之间的三层网络畅通。

在源设备上先创建一个本地镜像组，然后为该镜像组配置源端口和目的端口。指定目的端口时，指定镜像报文封装的目的IP地址为监测设备的地址，源IP地址为目的端口的IP地址。

如[图17](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref38642913)所示，配置封装参数方式三层远程端口镜像报文的转发过程为：

(1)   源设备将镜像源的入方向（收到的报文）、出方向（发出的报文）或双向（收到和发出的报文）报文复制一份。

(2)   源设备为复制的报文添加ERSPAN封装，封装的源IP地址为目的端口的IP地址，目的IP地址为监测设备的IP地址。

(3)   封装后的报文通过IP网络路由转发到监测设备。

(4)   监测设备对报文进行解封装，并分析镜像报文的内容。

由于镜像到监测设备的报文为封装后的报文，因此监测设备必须支持报文解封装。

图17 配置封装参数方式三层远程端口镜像示意图

![img](https://resource.h3c.com/cn/202205/11/20220511_7183528_x_Img_x_png_21_1606183_30005_0.png)

 

## 5.4 流镜像方式的ERSPAN

### 5.4.1 简介

流镜像是指将指定报文复制到指定目的地，以便于对报文进行分析和监控。

流镜像通过QoS实现，设备先通过流分类匹配待镜像的报文，再通过流行为将符合条件的报文镜像至指定目的地。该方式可以灵活配置报文的匹配条件，从而对报文进行精细区分，并将区分后的报文镜像到目的地。

当流镜像的目的地为接口时，可以通过流镜像实现ERSPAN。

### 5.4.2 工作机制

流镜像ERSPAN有如下几种实现方式：

·   Loopback方式

·   配置封装参数方式

·   监控组方式

#### 1. Loopback方式

如[图18](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref38642947)所示，Loopback方式流镜像ERSPAN的实现方式为：

(1)   在源设备上配置QoS策略并将策略下发到源接口上，流分类匹配指定特征的报文，流行为配置流镜像到接口Port B并指定loopback参数。

(2)   在源设备上配置QoS策略并将策略下发到Port B，流分类匹配镜像报文，流行为将报文重定向到Tunnel接口。

(3)   目的设备将从Tunnel接口收到的镜像报文解封装，然后根据报文的目的IP地址（即原始报文的目的IP地址）转发报文。因此，目的设备上需要存在到达该目的地址的路由/ARP。

图18 Loopback方式流镜像ERSPAN示意图

![img](https://resource.h3c.com/cn/202205/11/20220511_7183529_x_Img_x_png_22_1606183_30005_0.png)

 

#### 2. 配置封装参数方式

在源设备上配置QoS策略，流分类匹配指定特征的报文，流行为配置流镜像到接口。配置流镜像到接口时，有两种方式。

·   指定出接口方式：同时指定出接口和封装参数，设备给镜像报文加封装后从指定接口发出。

·   路由出接口方式：不指定出接口，只指定封装参数。设备给镜像报文加封装后，根据封装报文的源IP地址和目的IP地址查表转发，路由出接口即为镜像报文的目的端口。

采用这种方式时，可以通过路由协议的负载分担实现将镜像报文转发到多个目的端口。

如[图19](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref38642977)所示，配置封装参数方式流镜像ERSPAN的实现方式为：

(1)   源设备将匹配流分类的报文复制一份。

(2)   设备为报文添加ERSPAN封装后从指定接口发出或者根据封装报文的源IP地址和目的IP查表转发。

(3)   封装后的报文通过IP网络路由转发到监测设备。

(4)   监测设备对报文进行解封装，并分析镜像报文的内容。

通过本方式镜像到监测设备的报文为封装后的报文，因此监测设备必须支持解封装。

图19 配置封装参数方式流镜像ERSPAN示意图

![img](https://resource.h3c.com/cn/202205/11/20220511_7183530_x_Img_x_png_23_1606183_30005_0.png)

 

#### 3. 监控组方式

如[图20](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref41383838)所示，监控组方式流镜像到三层远程设备的实现方式为：

(1)   在源设备上配置监控组，为监控组添加成员端口时配置封装参数。

(2)   在源设备上配置QoS策略，流分类匹配指定特征的报文，流行为配置镜像到监控组。

(3)   设备将符合条件的报文复制一份到监控组后，监控组成员端口为报文添加ERSPAN封装后从指定接口发出或者根据封装报文的源IP地址和目的IP查表转发。

(4)   封装后的报文通过IP网络路由转发到监测设备。

(5)   监测设备对报文进行解封装，并分析镜像报文的内容。

通过本方式镜像到监测设备的报文为封装后的报文，因此监测设备必须支持解封装。

图20 流镜像到三层远程设备（监控组方式）

![img](https://resource.h3c.com/cn/202205/11/20220511_7183531_x_Img_x_png_24_1606183_30005_0.png)

 

## 5.5 基于ERSPAN的Telemetry应用场景

ERSPAN可以将用户感兴趣的报文（如某个端口接收到的报文）通过隧道镜像到远端分析器。分析器通过分析镜像报文，了解网络的状况，例如：

·   如果镜像报文中包括TCP三次握手报文，则可以监控TCP连接建立情况。

·   如果镜像报文中包括RDMA（Remote Direct Memory Access，远程直接内存访问）信令报文，则可以监控RDMA会话状态。

图21 基于ERSPAN的Telemetry应用场景图

![img](https://resource.h3c.com/cn/202205/11/20220511_7183532_x_Img_x_png_25_1606183_30005_0.png)

 

在[图21](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Telemetry_White_Paper-3559/?CHID=688870#_Ref57293849)中，管理员通过基于ERSPAN的Telemetry监控源和目的间的TCP连接状态，监控过程为：

(1)   源端发起TCP连接建立请求，向目的端发送TCP SYN报文。

(2)   沿途交换机捕获TCP SYN报文，将其封装为ERSPAN镜像报文，通过GRE隧道将镜像报文发送到远端的分析器。

(3)   分析器解封装ERSPAN镜像报文，并对其进行分析。

(4)   沿途交换机捕获后续TCP控制报文（SYN/FIN/RST报文）并发送给分析器。

(5)   分析器根据接收到的ERSPAN镜像报文获取报文转发路径。配合Telemetry实时上报的接口队列信息，还可以实现应用体验分析。