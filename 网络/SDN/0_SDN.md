# SDN

[TOC]

## 概述

SDN （Software Defined Networking）

是一种新的网络设计理念，即控制与转发分离、集中控制并且开放 API 。

与 SDN 相辅相成的 NFV，即网络功能虚拟化，最初主要是电信运营商在推动。NFV 借助通用硬件以及虚拟化技术，实现专用网络设备的功能，从而降低网络建设的成本。对应的还一个 NV（网络虚拟化）的概念，这是在数据中心将各种不同软硬件网络资源整合为基于软件统一管理的过程，主要是用来虚拟化数据中心网络。

## SDN架构

[ONF (Open Networking Foundation)](https://www.opennetworking.org/index.php) 将 SDN 架构分为三层：

- 应用层包括各种不同的业务应用。
- 控制层负责数据平面资源的编排、维护网络拓扑和状态信息等。
- 数据层负责数据处理、转发和状态收集。

![](../../Image/s/sdn-architecture.png)

共 5 个部分：

* SDN 网络应用

  实现了对应的网络功能应用。通过调用控制器的北向接口，实现对网络数据平面设备的配置、管理和控制。

* 北向接口

  控制器与网络应用之间开放的 API 为北向接口。将数据平面资源和状态信息抽象成统一的开放编程接口。

* SDN 控制器

  也称为网络操作系统。通过北向接口给上层网络应用提供不同层次的可编程能力，通过南向接口对 SDN 数据平面进行统一配置、管理和控制。

* 南向接口

  控制器与底层网络之间的接口为南向接口。南北向接口目前都还没有统一的标准，但南向接口用的比较多的是 OpenFlow ，使其成为事实上的标准。

* SDN 数据平面

  基于软件实现的和基于硬件实现的数据平面设备。通过南向接口接收来自控制器的指令，并按照这些指令完成特定的网络数据处理。同时 SDN 数据平面设备也可以通过南向接口给控制器反馈网络配置和运行时的状态信息。

## SDN的基本特征

SDN具有三个基本特征

- 控制与转发分离：转发平面由受控转发的设备组成，转发方式以及业务逻辑由运行在分离出去的控制面上的控制应用所控制。
- 开放 API：通过开放的南向和北向 AP I，能够实现应用和网络的无缝集成，使得应用只需要关注自身逻辑，而不需要关注底层实现细节。
- 集中控制：逻辑上集中的控制平面能够获得网络资源的全局信息并根据业务需求进行全局调配和优化。

## SDN优势

从SDN的特征出发，SDN的优势包括

- 灵活性，动态调整网络设备的配置，再也不需要人工去配置每台设备
- 网络硬件简化（如白牌交换机等），只需要关注数据的处理和转发，与业务特性解耦，加快了新业务的引入速度
- 网络的自动化部署和运维、故障诊断

## SDN 发展历程

- 2006 年，Martin Casado 博士在 RCP 和 4D 论文基础上，提出了一个逻辑上集中控制的企业安全解决方案 SANE ，打开了集中控制解决安全问题的大门。
- 2007 年，Martin 博士在 SANE 基础上实现了面向企业网管理的 Ethane 项目（SDN 架构和 OpenFlow 的前身），Nick、Scott 和Martin一起创建 Nicira 。
- 斯坦福大学 Nick McKeown 教授的 Clean Slate 项目，其目标是重新定义网络体系结构。
- 2008 年，网络领域八位学者联合发表了 OpenFlow 论文，Nick 团队发布了第一个开源 SDN 控制器 NOX 。
- 2009 年，SDN 入选麻省理工科技评论的 “未来十大突破性技术”，Nick 团队发布 POX 以及 FlowVisor，Nicira 发布 Open vSwitch，James Liao 和杜林共同创办了 Pica8 公司。
- 2010 年，Nick 团队发布 Mininet ，Google 发布分布式 SDN 控制器 Onix，Nick 的博士 Guido 等创办了 BigSwitch，前思科员工 JR 等创办了 Cumulus 。
- 2011 年，开放网络基金会 ONF 诞生，第一届开放网络峰会 ONS 成功举办，Nick McKeown、Scott Shenker、Larry Peterson 等创建了开放网络研究中心 ONRC ，这是 ON.Lab 的前身。
- 2012 年，Google 发布 B4，VMWare 天价收购 Nicira，BigSwitch 发布 Floodlight，NTT 发布 Ryu 。
- 2013 年，OpenDaylight 项目诞生，思科发布 ACI 产品方案，VMWare 发布 NSX 产品。
- 2014 年，ONOS、P4 等诞生。Facebook 在 OCP 项目中开放发布 Wedge 交换机设计细节，白盒交换机成为这一年的主旋律。
- 2015 年，ONF 发布了一个开源 SDN 项目社区，SD-WAN 成为第二个成熟的 SDN 应用市场。SDN 与 NFV 融合成为趋势。
- 2016 年，国内的云杉网络、大河云联、盛科网络以及国外的 VeloCloud、Plexxi、Cumulus 和 BigSwitch 都获得了新一轮融资。
- 2017 年，鹏博士正式发布运行国内首个运营商级 SD-WAN 。

## SDN技能图谱

![6. SDN - 图2](https://static.sitestack.cn/projects/sdn-handbook/sdn/images/Open_SDN_skill_map_ch_v2_0.jpg)

# SDN控制器

控制器是整个SDN网络的核心大脑，负责数据平面资源的编排、维护网络拓扑和状态信息等，并向应用层提供北向API接口。其核心技术包括

- 链路发现和拓扑管理
- 高可用和分布式状态管理
- 自动化部署以及无丢包升级

## 链路发现和拓扑管理

在SDN中通常使用LLDP发现其所控制的交换机并形成控制层面的网络拓扑。

> LLDP（Link Layer Discovery  Protocol，链路层发现协议）定义在802.1ab中,它是一个二层协议，提供了一种标准的链路层发现方式。LLDP协议使得接入网络的一台设备可以将其主要的能力，管理地址、设备标识、接口标识等信息发送给接入同一个局域网络的其它设备。当一个设备从网络中接收到其它设备的这些信息时，它就将这些信息以MIB的形式存储起来。这些MIB信息可用于发现设备的物理拓扑结构以及管理配置信息。需要注意的是LLDP仅仅被设计用于进行信息通告，它被用于通告一个设备的信息并可以获得其它设备的信息，进而得到相关的MIB信息。它不是一个配置、控制协议，无法通过该协议对远端设备进行配置，它只是提供了关于网络拓扑以及管理配置的信息。

发现过程为

- 控制器通过`Packet_out`包向所有与之相连的交换机发送LLDP包，同时要求交换机发出广播包（为了发现非OpenFlow交换机）
- 这些交换机收到消息后会向其所有端口发送LLDP数据包
- OpenFlow交换机收到LLDP数据包后通过`Packet_in`消息将链路信息发送给控制器
- 控制器根据收到的`Packet_in`消息创建网络拓扑

## 下发流表

SDN控制器通过南向接口（如OpenFlow）向SDN交换机下发流表，有两种方式

- 主动下发：控制器在数据包到达OpenFlow交换机之前就已经下发流表。这种方式不存在控制器的瓶颈问题，是主流的设计
- 被动下发：OpenFlow交换机收到第一个数据包并且没有发现与之匹配的流表项时发送给控制器处理，这种方式增加了流表设置的时间，也增加了控制器的处理负担，使控制器容易成为瓶颈

## 北向接口

北向接口是直接面向业务应用服务的，其设计密切联系业务应用需求，具有多样化的特征。北向接口目前还没有统一的标准，各家的实现均不相同，但共同点是都提供了一个开放的API，方便业务应用编程。

## 高可用

为了保证逻辑集中控制器的高可用性，需要多台控制器形成分布式集群，避免单点故障。由于控制器掌握着全网的网络设备，通过分布式协作的方式确保网络状态的一致性尤为重要。

## 开源控制器

- OpenDaylight
- ONOS
- NOX/POX
- OpenContrail
- Ryu
- Floodlight

# OpenDaylight

[OpenDaylight](https://www.opendaylight.org/)是Linux基金会管理的开源SDN控制器，依托强大的社区支持和功能特性，已成为最受瞩目的开源SDN控制器。

OpenDaylight(ODL)高度模块化、可扩展、可升级、支持多协议。北向接口可扩展性强，REST型API用于松耦合应用，OSGI型用于紧耦合应用。引入SAL屏蔽不同协议的差异性。南向支持多种协议插件，如OpenFlow 1.0、 OpenFlow  1.3、OVSDB、NETCONF、LISP、BGP、PCEP和SNMP等。底层支持传统交换机、纯Openflow交换机、混合模式的交换机。ODL控制平台采用了OSGI框架，实现了模块化和可扩展化，为OSGI模块和服务提供了版本和周期管理。ODL靠社区的力量驱动发，支持工业级最广的SDN和NFV使用用例。ODL每6个月推出一个版本，经历的版本为Hydrogen、Helium、Lithium、Beryllium、Boron、Carbon等。

## 架构

如下图所示，OpenDaylight架构分为南向接口层、控制平面层、北向接口层和网络应用层。

- 南向接口层：包含多种协议插件，如OpenFlow 1.0、 OpenFlow 1.3、OVSDB、NETCONF、LISP、BGP、PCEP和SNMP等。南向接口层使用Netty来管理底层的并发IO
- 控制平面层：包含MD-SAL、网络功能、网络服务和网络抽象等模块，其中MD-SAL（Model Driven Service Abstraction  Layer）是OpenDaylight的核心，所有模块都需要向其注册才可使用。MD-SAL也是整个控制器的管理中心，负责数据存储、请求路由、消息的订阅和发布等
- 北向接口层：包含开放API接口（包括REST API和OSGI）和认证模块
- 网络应用层：包含各种基于OpenDaylight北向接口层的各种应用集合，如Management GUI/CLI、VTN Coordinator、D4A Protection和OpenStack Neutron等

![OpenDaylight - 图1](https://static.sitestack.cn/projects/sdn-handbook/sdn/images/opendaylight.png)

## 参考文档

- [OpenDaylight官网](https://www.opendaylight.org/)
- [OpenDaylight Handbook](http://docs.opendaylight.org/en/stable-carbon/)
- [OpenDaylight Wiki](https://wiki.opendaylight.org/view/Main_Page)
- [OpenDaylight控制器架构分析](http://www.sdnlab.com/community/article/4)
- 《重构网络-SDN架构与实现》

# ONOS

[ONOS](http://onosproject.org/)是一个开源SDN网络操作系统，主要面向服务提供商和企业骨干网。ONOS的设计宗旨是满足网络需求实现可靠性强，性能好，灵活度高等特性。此外，ONOS的北向接口抽象层和API使得应用开发变得更加简单，而通过南向接口抽象层和接口则可以管控OpenFlow或者传统设备。ONOS集聚了知名的服务提供商（AT&T、NTT通信），高标准的网络供应商（Ciena、Ericsson、Fujitsu、Huawei、Intel、NEC），网络运营商（Internet2、CNIT、CREATE-NET），以及其他合作伙伴（SRI、Infoblox），并且获得ONF的鼎力支持，通过一些真实用例来验证其系统架构。

## ONOS架构

### 系统层次

![ONOS - 图1](https://static.sitestack.cn/projects/sdn-handbook/sdn/images/onos.png)

### 组件和服务

- 模块化： ONOS由一系列功能模块组成，每个功能模块由一个或者多个组件组成，对外提供一种特定服务，这种基于SOA的框架同时支持对组件的全生命周期管理，支持动态加载、卸载组件
- 开放：ONOS提供开放的北向与南向API，使得用户能够很方便的基于ONOS开发应用以及南向插件。
- 抽象：ONOS 抽象出了统一的网络资源和网元模型奠定了第三方SDN应用程序互通的基础，使得运营商可以做灵活的业务协同和低成本业务创新。
- 简单：ONOS屏蔽了复杂的分布式等通用机制，对外只暴露业务接口，使得应用开发十分简单。 

![ONOS - 图2](https://static.sitestack.cn/projects/sdn-handbook/sdn/images/onos-subsystem.png)

### ONOS集群

![ONOS - 图3](https://static.sitestack.cn/projects/sdn-handbook/sdn/images/onos-communication.png)

- 分布式: 由多个实例组成一个集群
- 对称性: 每一个实例运行相同的软件和配置
- 容错与弹性扩展: 集群在面对节点故障时仍然可操作，支持新节点动态加入，轻松应对网络扩张
- 位置透明: 一个客户端可以和任何实例打交道，集群要展现单个逻辑实例的抽象
- ONOS集群间通信: 分为两种，一种基于Gossip协议，是数据弱一致性的通信方式；一种基于Raft算法，是保证数据强一致性的通信方式
- 高可靠：ONOS的Cluster机制能够保障节点失效对业务无影响，当ONOS节点宕机时，其他节点会接管该节点对网元的控制权，当节点恢复后，通过loadbalance命令恢复节点对网元的控制并使整体的控制达到负载均衡 

## 参考文档

- [ONOS Website](http://onosproject.org/)
- [ONOS Wiki](https://wiki.onosproject.org)
- [ONOS架构分析](http://developer.huawei.com/ict/cn/site-sdn-onos/article/onos-paradigm)
- [ONOS白皮书上篇之ONOS简介](http://www.sdnlab.com/6371.html)
- [ONOS白皮书中篇之ONOS架构](http://www.sdnlab.com/6800.html)

# Floodlight

Floodlight是BigSwitch在Beacon基础上开发的SDN控制器，它基于Java开发，具有良好的架构和性能，也是早期最流行的SDN控制器之一。

Floodlight的架构可以分为控制层和应用层，应用层通过北向API与控制层通信；控制层则通过南向接口控制数据平面。

Floodlight模块结果如下所示：

![Floodlight - 图1](https://static.sitestack.cn/projects/sdn-handbook/sdn/images/floodlight.png)

由于Floodlight更新迭代速度较慢，特别是OpenDaylight诞生以后，Floodlight已经丧失了

## 参考文档

- [Floodlight官网](http://www.projectfloodlight.org/floodlight/)
- [Project Floodlight](https://floodlight.atlassian.net/wiki/)

# Ryu

[Ryu](https://osrg.github.io/ryu/)是日本NTT公司推出的SDN控制器框架，它基于Python开发，模块清晰，可扩展性好，逐步取代了早期的NOX和POX。

- Ryu支持OpenFlow 1.0到1.5版本，也支持Netconf，OF-CONIFG等其他南向协议
- Ryu可以作为OpenStack的插件，见[Dragonflow](https://github.com/openstack/dragonflow)
- Ryu提供了丰富的组件，便于开发者构建SDN应用

## 示例

Ryu的安装非常简单，直接用pip就可以安装

```
pip install ryu
```

安装完成后，就可以用python来开发SDN应用了。比如下面的例子构建了一个L2Switch应用：

```
from ryu.base import app_managerfrom ryu.controller import ofp_eventfrom ryu.controller.handler import MAIN_DISPATCHERfrom ryu.controller.handler import set_ev_clsfrom ryu.ofproto import ofproto_v1_0class L2Switch(app_manager.RyuApp):    OFP_VERSIONS = [ofproto_v1_0.OFP_VERSION]    def __init__(self, *args, **kwargs):        super(L2Switch, self).__init__(*args, **kwargs)    @set_ev_cls(ofp_event.EventOFPPacketIn, MAIN_DISPATCHER)    def packet_in_handler(self, ev):        msg = ev.msg        dp = msg.datapath        ofp = dp.ofproto        ofp_parser = dp.ofproto_parser        actions = [ofp_parser.OFPActionOutput(ofp.OFPP_FLOOD)]        out = ofp_parser.OFPPacketOut(            datapath=dp, buffer_id=msg.buffer_id, in_port=msg.in_port,            actions=actions)        dp.send_msg(out)
```

最后可以使用`ryu-manager`启动应用：

```
ryu-manager L2Switch.py
```

## 参考文档

- [Ryu官网](https://osrg.github.io/ryu/)
- [Ryu源码](https://github.com/osrg/ryu)
- [Ryu Book](http://osrg.github.io/ryu-book/en/html/)
- [RYU 控制器性能测试报告](http://www.sdnctc.com/public/download/RYU.pdf)

# NOX/POX

[NOX](https://github.com/noxrepo/nox)是第一个SDN控制器，由Nicira开发，并于2008年开源发布。NOX在2010年以前得到广泛应用，不过由于其基于C++开发，开发成本较高，逐渐在控制器竞争中没落。所以后来其兄弟版本[POX](https://github.com/noxrepo/pox)面世。POX是完全基于Python的，适合SDN初学者。但POX也有其架构和性能的缺陷，逐渐也被新兴的控制器所取代。

目前，NOX/POX社区已不再活跃，其官网`http://www.noxrepo.org`也已废弃，不推荐在生产中继续使用它们。

## 参考文档

- [NOX源码](https://github.com/noxrepo)
- [POX Wiki](https://openflow.stanford.edu/display/ONL/POX+Wiki)

# 南向接口

南向接口负责控制器与数据平面的通信，可以理解成数据平面的编程接口，直接决定了SDN架构的可编程能力。

主流的南向接口协议包括

- OpenFlow：第一个开放的南向接口协议，也是目前最流行的协议。它提出了控制与转发分离的架构，规定了SDN转发设备的基本组件和功能要求，以及与控制器通信的协议。
- OF-Config：提供开放接口用于控制和配置OpenFlow交换机，但不影响流表的内容和数据转发行为。OF-CONFIG在OpenFlow架构上增加了一个被称作OpenFlow Configuration  Point的配置节点。这个节点既可以是控制器上的一个软件进程，也可以是传统的网管设备。OF-Config基于NET-CONF与设备通信。
- [P4](http://p4.org/)：协议无关的数据包处理编程语言，提供了比OpenFlow更出色的编程能力。它不仅可以指导数据流进行转发，还可以对交换机等转发设备的数据处理流程进行软件编程定义。
- OVSDB：Open vSwitch数据库协议。
- NET-CONF：用于替代CLI、SNMP等配置交换机。
- OpFlex：思科ACI使用的一种声明式南向接口协议。

## 参考文档

- https://www.opennetworking.org/sdn-resources/openflow
- http://p4.org/
- [P4:真正的SDN还遥远吗](http://www.muzixing.com/pages/2016/03/23/p4zhen-zheng-de-sdnhuan-yao-yuan-ma.html)

# OpenFlow

[OpenFlow](https://www.opennetworking.org/sdn-resources/openflow)是第一个开放的南向接口协议，也是目前最流行的南向协议。它提出了控制与转发分离的架构，规定了SDN转发设备的基本组件和功能要求，以及与控制器通信的协议。

OpenFlow起源于Nick McKeown等在2008年发表的[OpenFlow: enabling innovation in campus networks](http://dl.acm.org/citation.cfm?id=1355734.1355746)论文，并在次年发布了1.0版本协议。2011年又成立了Open Networking Foundation (ONF)进一步规范和推动OpenFlow的发展，并将OpenFlow的协议规范发布在[ONF网站](https://www.opennetworking.org/technical-communities/areas/specification)。

## OpenFlow原理

OpenFlow协议规范定义了OpenFlow交换机、流表、OpenFlow通道以及OpenFlow交换协议。

### OpenFlow交换机

一个典型的OpenFlow交换机如下图所示

![OpenFlow - 图1](https://static.sitestack.cn/projects/sdn-handbook/sdn/images/openflow.png)

它主要由OpenFlow通道和数据平面组成，而数据平面又包括流表、端口、组表和Meter表等：

- OpenFlow通道用于交换机和控制器进行通信（基于OpenFlow交换协议）
- 流表即存放流表项的表
- 端口是OpenFlow与其他网络协议栈进行数据交换的网络接口，包括物理端口、逻辑端口以及预留端口等
- 组表用于定义一组可被多个流表项共同使用的动作
- Meter表用于计量和限速

### 流表

流表用于存储流表项，多级流表以流水线的方式处理。

![OpenFlow - 图2](https://static.sitestack.cn/projects/sdn-handbook/sdn/images/flow.png)

每个流表项由匹配域（包括输入端口、包头以及其他流表设置的元数据）、优先级、指令集、计数器、计时器、Cookie和用于管理流表项的flag组成：

![OpenFlow - 图3](https://static.sitestack.cn/projects/sdn-handbook/sdn/images/item.png)

一个典型的流表匹配过程如下所示

![OpenFlow - 图4](https://static.sitestack.cn/projects/sdn-handbook/sdn/images/match.png)

而典型的指令执行过程如下所示

![OpenFlow - 图5](https://static.sitestack.cn/projects/sdn-handbook/sdn/images/instruction.png)

除了流表，还可以定义Meter表

![OpenFlow - 图6](https://static.sitestack.cn/projects/sdn-handbook/sdn/images/meter.png)

### OpenFlow通道

OpenFlow通道是控制器和交换机通信的通道。控制器可以通过该通道来配置和管理交换机、接收交换机发出的事件等。OpenFlow通道使用OpenFlow交换协议（OpenFlow switch protocol），通常基于TLS通信，但也支持直接TCP通信。

OpenFlow交换协议支持三种类型的报文

- controller-to-switch：控制器初始化并下发给交换机的报文，用于管理和查询交换机状态（如查询交换机特性，修改交换机流表、组表等）
- asynchronous：交换机异步发送给控制器的报文，用于更新网络事件和交换机状态的改变（如新报文到达、交换机端口变化等）
- symmetric：交换机或控制器发送，但无需对方许可，如Hello协商、Echo活性测试、Error错误报文等

## 参考文档

- [OpenFlow官方网站](https://www.opennetworking.org/sdn-resources/openflow)
- [OpenFlow协议规范](https://www.opennetworking.org/technical-communities/areas/specification)

# OF-Config

OF-Config是一个OpenFlow交换机配置协议，也是ONF主推的OpenFlow补充协议，很好的填补了OpenFlow协议之外的交换机运维配置等内容。它提供了开放接口用于控制和配置OpenFlow交换机，但不影响流表的内容和数据转发行为。OF-CONFIG在OpenFlow架构上增加了一个被称作OpenFlow Configuration Point的配置节点。这个节点既可以是控制器上的一个软件进程，也可以是传统的网管设备。

![OF-Config - 图1](https://static.sitestack.cn/projects/sdn-handbook/sdn/images/of-config.png)

OF-Config的协议规范也发布在[ONF官方网站](https://www.opennetworking.org/technical-communities/areas/specification)。

OF-Config基于NET-CONF与设备通信，其核心数据结构如下所示。

![OF-Config - 图2](https://static.sitestack.cn/projects/sdn-handbook/sdn/images/of-config-core.png)

# NETCONF

NETCONF是一个基于XML的交换机配置接口，用于替代CLI、SNMP等配置交换机。

## 协议

NETCONF通过RPC与交换机通信，其协议包含四层

```
            Layer                 Example       +-------------+      +-----------------+      +----------------+   (4) |   Content   |      |  Configuration  |      |  Notification  |       |             |      |      data       |      |      data      |       +-------------+      +-----------------+      +----------------+              |                       |                      |       +-------------+      +-----------------+              |   (3) | Operations  |      |  <edit-config>  |              |       |             |      |                 |              |       +-------------+      +-----------------+              |              |                       |                      |       +-------------+      +-----------------+      +----------------+   (2) |  Messages   |      |     <rpc>,      |      | <notification> |       |             |      |   <rpc-reply>   |      |                |       +-------------+      +-----------------+      +----------------+              |                       |                      |       +-------------+      +-----------------------------------------+   (1) |   Secure    |      |  SSH, TLS, BEEP/TLS, SOAP/HTTP/TLS, ... |       |  Transport  |      |                                         |       +-------------+      +-----------------------------------------+
```

- (1) 安全传输层，用于跟交换机安全通信，NETCONF并未规定具体使用哪种传输层协议，所以可以使用SSH、TLS、HTTP等各种协议
- (2) 消息层，提供一种传输无关的消息封装格式，用于RPC通信
- (3) 操作层，定义了一系列的RPC调用方法，并可以通过Capabilities来扩展
- (4) 内容层，定义RPC调用的数据内容

## 参考文档

- [RFC6241](https://tools.ietf.org/html/rfc6241)

# P4

[P4](http://p4.org/)是一个协议无关的数据包处理编程语言，提供了比OpenFlow更出色的编程能力。它不仅可以指导数据流进行转发，还可以对交换机等转发设备的数据处理流程进行编程。主要特点包括

- 灵活定义数据转发流程，支持重新配置匹配域，并支持无中断的重配置
- 协议无关，只需要关注如何处理转发包，而不需要关注底层协议细节
- 设备无关，无需关注底层设备的具体信息

![P4 - 图1](https://static.sitestack.cn/projects/sdn-handbook/sdn/images/p4.png)

## 转发模型

如下图所示，数据包经过解析后，会被传递到一个“匹配-动作”表，并支持串行和并行操作。类似于OpenFlow流水线，这些表决定了数据包将被送往哪里，如丢弃或送到某个出端口。P4的流水线分为入口流水线和出口流水线：

- 入口流水线中，数据包可能会被转发、复制、丢弃或触发流量控制
- 而出口流水线可以对数据包作进一步的修改，并送到相应的出端口

![P4 - 图2](https://static.sitestack.cn/projects/sdn-handbook/sdn/images/p4-2.png)

P4交换机将流水线处理数据的过程进行抽象和重定义，数据处理单元对数据的处理抽象成匹配和执行匹配-动作表的过程，包头的解析抽象成P4中的解析器，数据处理流程抽象成流控制。P4基础数据处理单元是不记录数据的，所以就需要引入一个元数据总线，用来存储一条流水线处理过程中需要记录的数据。P4交换机的专用物理芯片Tofino，最高支持12个数据处理单元，可以覆盖传统交换机的所有功能。

## P4语言

每个P4程序包含如下的5个关键组件：

- Headers：定义报文头部格式，支持重定义的头部名称和任意长度字段
- Parses：定义数据包解析流程的有限状态机
- Tables：“匹配-动作”表，定义匹配域以及对应的执行动作
- Actions：动作指令集，包括构造查找键（Construct lookup keys）、根据查找键查表、执行动作等
- Control Flow：控制程序，决定了数据包处理的流程，比如如何在不同表之间跳转等

具体的编写方法可以参考[P4 Language Specification](https://p4lang.github.io/p4-spec/docs/P4-16-v1.0.0-spec.html)。

## P4工作流程

P4的完整工作流程为：

- 首先用户需要自定义数据帧的解析器和流控制程序
- 然后，P4程序经过编译器编译后输出JSON格式的交换机配置文件和运行时的API
- 再次配置的文件载入到交换器中后更新解析起和匹配－动作表
- 最后交换机操作系统按照流控制程序进行包的查表操作

![P4 - 图3](https://static.sitestack.cn/projects/sdn-handbook/sdn/images/p4-3.png)

以新增VLAN包解析为例，图中解析器除VXLAN以外的包解析是交换机中已有的，载入VXLAN.p4文件所得的配置文件的过程就是交换机的重配置过程。配置文件载入交换机后，解析器中会新增对VXLAN包解析，同时更新匹配-动作表，匹配成功后执行的动作也是在用户自定的程序中指定。执行动作需要交换机系统调用执行动作对应的指令来完成，这时交换机系统调用的是经过P4编译器生成的统一的运行时API，这个API就是交换机系统调用芯片功能的驱动，流控制程序就是指定API对应的交换机指令。

## 参考文档

- [P4](http://p4.org/)
- [P4:开创数据平面可编程时代](http://www.sdnlab.com/17795.html)

# SDN数据平面

数据平面负责数据处理、转发和状态收集等。其核心设备为交换机，可以是物理交换机，也可以是虚拟交换机。不同于传统网络转发设备，应用于SDN中的转发设备将数据平面与控制平面完全解耦，所有数据包的控制策略由远端的控制器通过南向接口协议下发，网络的配置管理同样也由控制器完成，这大大提高了网络管控的效率。交换设备只保留数据平面，专注于数据包的高速转发，降低了交换设备的复杂度。

本质上来说，决定SDN可编程能力的因素在于数据平面的可编程性，所以就有了通用可编程数据平面OpenFlow Switch。通用可编程数据平面支持用户通过软件编程的方式任意定义数据平面的能力，包括数据包的解析、处理等功能。

从OpenFlow  Switch通用转发模型诞生至今，学术界和产业界在通用可编程数据平面领域做了很多努力，持续推动了SDN数据平面的发展。其中典型的通用可编程数据平面设计思路是The McKeown Group的可编程协议无关交换机架构PISA（Protocol-Independent Switch  Architecture）。到达PISA系统的数据包先由可编程解析器解析，再通过入口侧一系列的Match-Action阶段，然后经由队列系统交换，由出口Match-Action阶段再次处理，最后重新组装发送到输出端口。

![数据平面 - 图1](https://static.sitestack.cn/projects/sdn-handbook/sdn/images/openflow-switch.jpg)

## SDN数据平面发展历史

- 早期的软件交换机，如Open vSwitch、Indigo等，一般存在性能问题
- 随后的可编程硬件，如基于NetFPGA的OpenFlow交换机，成本高，开发难度大，灵活性差
- 中期的OpenFlow网络设备，如Pica8、Cumulus、Big  Switch等在现有网络交换机操作系统上增加了对OpenFlow南向接口的支持，还有博通、盛科等网络芯片厂商在网络交换机芯片上实现了对OpenFlow南向接口和OpenFlow Switch通用转发模型的支持
- 现阶段通用可编程网络芯片和数据平面编程语言的出现进一步推动SDN数据平面的发展，如The  McKeown Group的PISA (Protocol Independent Switch Architecture)  架构以及Barefoot发布的基于PISA的可编程网络芯片Tofino。现阶段数据平面的编程语言代表为P4。

## 参考文档

- [Barefoot Tofino](https://barefootnetworks.com/technology/#tofino)
- [P4 Language](http://p4.org/)
- 《重构网络-SDN架构与实现》
- [基于SDN的数据中心网络技术研究](http://www.sdnlab.com/10543.html)

# NFV

NFV (Network Functions Virtualization)是一种使用x86等通用硬件来承载传统网络设备功能的技术。它是通过用软件和自动化替代专用网络设备来定义、创建和管理网络的新方式。

同SDN一样，NFV从根本上讲是从基于硬件的解决方案转向更开放的基于软件的解决方案。例如，取代专用防火墙设备，软件可以通过虚拟防火墙提供相同的功能。再如入侵检测和入侵防御、NAT、负载均衡、WAN加速、缓存、GGSN、会话边界控制器、DNS等等虚拟网络功能。有时，不同的子功能可以组合起来形成一个更高级的多组件VNF，如虚拟路由器。

正如SDN和NFV可以在廉价的裸机或白盒服务器上的实现方式，这些VNF可以运行在通用的商用硬件组件上，而不是成本高昂的专有设备。网络运营商通过NFV快速实现并应用VNF，并通过业务流程自动化服务交付。

ETSI列出了NFV为网络运营商及其客户提供的几点优势：

- 通过降低设备成本和降低功耗，减少运营商CAPEX和OPEX
- 缩短部署新网络服务的时间
- 提高新服务的投资回报率
- 更灵活的扩大，缩小或发展服务
- 开放虚拟家电市场和纯软件进入者
- 以较低的风险试用和部署新的创新服务

## NFV架构

![7. NFV - 图1](https://static.sitestack.cn/projects/sdn-handbook/nfv/nfv.png)

- NFV VIM (Virtualised Infrastructure Manager)，包括虚拟化（hypervisor或container）以及物理资源（服务器、交换机、存储设备等）
- NFVO (Network Functions Virtualisation Orchestrator)，NFV的管理和编排，包括自动化交付、按需提供资源以及VNF配置（包括物理和虚拟资源）
- VNF (Virtual Network Function)

## OPNFV (Open Platform for NFV)

[OPNFV](https://www.opnfv.org/)是Linux基金会的开源NFV方案，致力于将其他开源项目通过集成、部署和测试进行系统级的整合，从而搭建一个基准的NFV平台。

![7. NFV - 图2](https://static.sitestack.cn/op/projects/sdn-handbook/nfv/nfv.png)

## 开源项目

- ONAP (Open Network Automation Platform)
  - 由AT&T主导下的ECOMP（增强控制、编排、管理和策略）项目和中国三大运营商主导下的Open-O项目合并而成
  - 旨在帮助电信行业克服在MANO领域遇到的一些障碍，加快NFV的部署，降低将VNF纳入到网络中的时间和成本
  - 官方网站为https://www.onap.org/.
- ETSI OSM
  - ETSI开源的NFV MANO (Management and Orchestration)。
  - 官方网站为https://osm.etsi.org/
- OpenStack Tacker
  - 官方网站为https://wiki.openstack.org/wiki/Tacker
  - [Redhat solution for network functions virtualization](https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/8/html-single/red_hat_solution_for_network_functions_virtualization/)
- OpenDaylight: https://www.opendaylight.org/
- ONOS: http://onosproject.org/
- CORD: http://opencord.org/
- Openbaton
- Cloudify
- Clearwater vIMS
- Gohan

## 参考文档

- http://www.etsi.org/
- https://www.onap.org/
- [NFV specifications by ETSI](http://www.etsi.org/technologies-clusters/technologies/nfv)。
- [历数NFV的发展历程](http://www.sdnlab.com/19295.html)

# SD-WAN

SD-WAN (Software-Defined Wide-Area Networking) 是继SDN之后的又一个热门技术，将软件可编程与商业化硬件结合，通过集中管理和软件可编程方式自动部署和管理广域网，加速服务交付，并通过路径优化提升网络性能和可靠性。

SD-WAN服务是基于企业客户的需求，以革新方式亦或是升级方式支持的广域组网SDN解决方案。SDN支持的软件定义广域网络，不仅仅是硬件设备开放的南向接口和Openflow、NETCONF、PCEP等接口协议，也不仅仅是集中的SDN控制器加上业务编排系统，其核心的特点是对应用需求的感知和按需服务，以及以应用视角贯穿的网络构建、用户服务、持续交付、运维支撑、运营保障的全生命周期管理。

目前，全球各大运营商和设备制造商均在积极布局SD-WAN。

## SD-WAN特性

现在普遍认为，SD-WAN应该具有以下4个功能：

- 支持多种连接方式，MPLS，frame relay，LTE，Public Internet等等。SD-WAN将Virtual  WAN与传统WAN结合，在这之上做overlay。对于应用程序来说，不需要清楚底层的WAN连接究竟是什么。在不需要传统WAN的场景下，SD-WAN就是Virtual WAN。
- 能够在多种连接之间动态选择链路，以达到负载均衡或者资源弹性。与Virtual  WAN类似，动态选择多条路径。SD-WAN如果同时连接了MPLS和Internet，那么可以将一些重要的应用流量，例如VoIP，分流到MPLS，以保证应用的可用性。对于一些对带宽或者稳定性不太敏感的应用流量，例如文件传输，可以分流到Internet上。这样减轻了企业对MPLS的依赖。或者，Internet可以作为MPLS的备份连接，当MPLS出故障了，至少企业的WAN网络不至于也断连。
- 简单的WAN管理接口。凡是涉及网络的事物，似乎都存在管理和故障排查较为复杂的问题，WAN也不例外。SD-WAN通常也会提供一个集中的控制器，来管理WAN连接，设置应用流量policy和优先级，监测WAN连接可用性等等。基于集中控制器，可以再提供CLI或者GUI。以达到简化WAN管理和故障排查的目的。
- 支持VPN，防火墙，网关，WAN优化器等服务。SD-WAN在WAN连接的基础上，将提供尽可能多的，开放的和基于软件的技术。

除此之外，SD-WAN通常还具备以下功能

- 弹性，实时检测网络故障并自动切换链路
- QoS，自动链路选择，为关键应用优化最佳路径
- 安全
- 易部署，易管理，易调试
- 在线流量工程

在部署时，SD-WAN与WAN edge router放置在一起，用来增强WAN edge router甚至替代WAN edge router。

## 相关技术

### Hybrid WAN

Hybrid WAN是指采用同时采用多种WAN连接，通常就是私有MPLS连接和Internet连接。企业通过Hybrid  WAN技术，可以将一些应用流量分流到Internet连接上来。毕竟，私有MPLS连接成本不低。从这点看，Hybrid  WAN与前面描述的SD-WAN非常接近。实际InfoVista将hybrid WAN看作是SD-WAN的前身。不过Hybrid  WAN只是强调同时使用多条WAN连接，SD-WAN在这之上加上了software-defined的概念，这包括了集中控制，智能分析和动态创建网络服务等。Hybrid WAN仍然占据了WAN市场较大一部分，当用户需要升级或者需要更灵活的WAN连接管理时，SD-WAN会是一个不错的替代。

### WAN Optimization

WAN Optimization是指提高数据在WAN上传输效率的技术的集合。SD-WAN关注的是使用低成本线路，以达到高性能线路传输效果。而WAN  Optimization关注的是网络数据包如何更有效的在已有线路上传输。在实际中，SD-WAN可以配合WAN  Optimization使用。在SD-WAN场景下，WAN Optimization通常是以虚拟的形式存在。

### WAN edge router

前面说过，SD-WAN实际上能增强WAN edge router甚至取而代之。传统的网络厂商一般是在自己的WAN edge  device（路由器，NGFW）里集成SD-WAN功能，而新兴的SD-WAN创业公司，更倾向于专有的SD-WAN设备，或者虚拟的SD-WAN产品，来配合WAN edge router。

### MPLS

SD-WAN的倡导者通常会宣称SD-WAN是用来替代MPLS的。不过，只要对网络流量可靠的QoS还有需要，那么MPLS或者其他的传统WAN连接技术仍然是不能替代。现实中，SD-WAN厂商通常会建议MPLS和Virtual WAN一起部署。对于高优先级流量，仍然走MPLS。从技术的角度来看，MPLS，可以通过Traffic  Engineering完全控制骨干网网络流量。而SD-WAN，其所有的控制都是在网络边缘。网络对于SD-WAN来说就是个黑盒子。所以总的来说，SD-WAN可以减轻企业对MPLS的依赖，但是不能完全消除MPLS。

### NFV

SD-WAN产品需要支持基于软件的VPN，防火墙，WAN Optimization等。这可以在SD-WAN上实现，也可以通过NFV技术向SD-WAN添加相应的VNF来实现。NFV和SD-WAN都是虚拟网络服务，两者并不互斥，可以配合工作。

### SDN

与SDN的联系更多是概念上。前面已经提过了SD-WAN与SDN的区别。这里再引用一个报告，Riverbed  2015年通过对260个样本调查发现，29%的用户正在研究SD-WAN，而已经有5%的用户在使用SD-WAN。相比之下，77%的用户在研究SDN，只有13%在使用。SD-WAN的先驱使用者是零售商和金融机构，他们都有大量的分支机构。SDN是对现有网络架构的更新，虽然说SDN架构优势明显，但是应用到实际中，因为企业现有网络架构在还能用之前，没人会提出更换成SDN架构，企业不会承担相应的成本和风险。而SD-WAN，最直接的效应就是减少企业在WAN上的投入，特别是分支机构较多的企业。设计到钱的问题的时候，总是比涉及技术更容易在企业推广。并且SD-WAN是增量变化，企业有时可以在原有WAN架构的基础上新增SD-WAN功能。因此，普遍认为SD-WAN的发展速度会更快。

## SD-WAN厂商

- Viptela
- VeloCloud
- Aryaka

更多SD-WAN厂商列表见[这里](http://packetpushers.net/virtual-toolbox/list-sd-wan-vendors/)。

国外运营商SDWAN服务及提供商：

![8. SDWAN - 图1](https://static.sitestack.cn/projects/sdn-handbook/sdwan/images/operator-managed-sdwan.png)

(图片来自[NET MANIAS](http://www.netmanias.com/en/?m=view&id=oneshot&no=12105))

*注：部分转自[SD-WAN](https://en.wikipedia.org/wiki/SD-WAN)和[SD-WAN漫谈](https://zhuanlan.zhihu.com/p/27775512)。*

# Mininet

Mininet是一个由Stanford大学Nick研究小组开发的网络虚拟化平台，可以用来方便的测试、验证和研究OpenFlow和SDN网络。

Mininet使用Linux Network  Namespaces来创建虚拟节点，默认情况下，Mininet会为每一个host创建一个新的网络命名空间，同时在root  Namespace（根进程命名空间）运行交换机和控制器的进程，因此这两个进程就共享host网络命名空间。由于每个主机都有各自独立的网络命名空间，我们就可以进行个性化的网络配置和网络程序部署。

Mininet提供了命令行工具`mn`和Python API，用来构建网络拓扑。

## 安装Mininet

在Ubuntu系统上可以使用通过下面的命令来安装mininet：

```
sudo apt-get install -y mininet openvswitch-testcontrollersudo /usr/bin/ovs-testcontroller /usr/bin/ovs-controllersudo service openvswitch-switch start
```

然后运行下面的命令验证安装是否正常

```
sudo mn --test pingall
```

其他系统上，可以参考[这里](https://github.com/mininet/mininet/wiki/Mininet-VM-Images)下载预置mininet的虚拟机镜像。

## mn命令行

直接运行mn命令可以进入mininet控制台，默认创建一个`minimal`拓扑，即一个控制器、一台OpenFlow交换机并连着两台host。

```
$ sudo mnmininet> nodesavailable nodes are:h1 h2 s1mininet> dump<Host h1: h1-eth0:10.0.0.1 pid=21291><Host h2: h2-eth0:10.0.0.2 pid=21293><OVSBridge s1: lo:127.0.0.1,s1-eth1:None,s1-eth2:None pid=21298>
```

以节点名字开始的命令在节点内运行

```
mininet> h1 ifconfig -ah1-eth0   Link encap:Ethernet  HWaddr aa:7d:6a:7f:b5:52          inet addr:10.0.0.1  Bcast:10.255.255.255  Mask:255.0.0.0          inet6 addr: fe80::a87d:6aff:fe7f:b552/64 Scope:Link          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1          RX packets:15 errors:0 dropped:0 overruns:0 frame:0          TX packets:8 errors:0 dropped:0 overruns:0 carrier:0          collisions:0 txqueuelen:1000          RX bytes:1206 (1.2 KB)  TX bytes:648 (648.0 B)lo        Link encap:Local Loopback          inet addr:127.0.0.1  Mask:255.0.0.0          inet6 addr: ::1/128 Scope:Host          UP LOOPBACK RUNNING  MTU:65536  Metric:1          RX packets:0 errors:0 dropped:0 overruns:0 frame:0          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0          collisions:0 txqueuelen:1          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)mininet> h1 ping -c1 h2PING 10.0.0.2 (10.0.0.2) 56(84) bytes of data.64 bytes from 10.0.0.2: icmp_seq=1 ttl=64 time=0.040 ms--- 10.0.0.2 ping statistics ---1 packets transmitted, 1 received, 0% packet loss, time 0msrtt min/avg/max/mdev = 0.040/0.040/0.040/0.000 ms
```

#### 命令和选项

命令列表

- py：执行python命令，如`py h1.IP()`
- dump：查看各节点的信息
- nodes：查看所有节点
- net：查看链路信息
- links：查看网络接口连接拓扑
- link：开启或关闭网络接口，如`link s1 h1 up`
- xterm：开启终端
- dpctl：操作OpenFlow流表
- pingall：自动ping测试

选项列表

- `--topo`：自定义拓扑，如`linear|minimal|reversed|single|torus|tree`
- `--link`：自定义网络参数，如`default|ovs|tc`
- `--switch`：自定义虚拟交换机，如`default|ivs|lxbr|ovs|ovsbr|ovsk|user`
- `--controller`：自定义控制器，如`default|none|nox|ovsc|ref|remote|ryu`
- `--nat`：自动设置NAT
- `--cluster`：集群模式，将网络拓扑运行在多台机器上
- `--mac`：自动设置主机mac
- `--arp`：自动设置arp表项

#### 自定义网络拓扑

默认的`minimal`拓扑比较简单，可以使用`--topo`选项设置网络拓扑。

```
$ sudo mn --topo single,3mininet> dump<Host h1: h1-eth0:10.0.0.1 pid=22193><Host h2: h2-eth0:10.0.0.2 pid=22195><Host h3: h3-eth0:10.0.0.3 pid=22197><OVSBridge s1: lo:127.0.0.1,s1-eth1:None,s1-eth2:None,s1-eth3:None pid=22202>
```

#### 自定义网络参数

可以使用`--link`选项设置网络参数。

```
$ sudo mn --link tc,bw=10,delay=10msmininet> iperf*** Iperf: testing TCP bandwidth between h1 and h2*** Results: ['9.50 Mbits/sec', '12.0 Mbits/sec']
```

#### 自定义独立命名空间

默认情况下，host在独立的netns中，而switch和controller都还是使用host netns，可以使用`--innamespace`选项将它们也放到独立的netns中。

```
$ sudo mn --innamespace --switch user
```

## Python API

对于复杂的网络，需要使用[Python API](http://mininet.org/api/annotated.html)来构建。

比如，使用python API构造一个单switch接4台虚拟节点的示例

```
#!/usr/bin/pythonfrom mininet.topo import Topofrom mininet.net import Mininetfrom mininet.util import dumpNodeConnectionsfrom mininet.log import setLogLevelfrom mininet.node import OVSControllerclass SingleSwitchTopo(Topo):    "Single switch connected to n hosts."    def build(self, n=2):        switch = self.addSwitch('s1')        # Python's range(N) generates 0..N-1        for h in range(n):            host = self.addHost('h%s' % (h + 1))            self.addLink(host, switch)def simpleTest():    "Create and test a simple network"    topo = SingleSwitchTopo(n=4)    net = Mininet(topo=topo, controller = OVSController)    net.start()    print "Dumping host connections"    dumpNodeConnections(net.hosts)    print "Testing network connectivity"    net.pingAll()    net.stop()topos = {"mytopo": SingleSwitchTopo}if __name__ == '__main__':    # Tell mininet to print useful information    setLogLevel('info')    simpleTest()
```

这个脚本可以直接运行，也可以使用mn命令启动

```
$ sudo mn --custom a.py --topo mytopo,3 --test pingall
```

Mininet v2.2.0+还提供了一个miniedit的可视化界面，更直观的编辑和查看网络拓扑。miniedit实际上是一个python脚本，存放在mininet安装目录的examples中，如`/usr/lib/python2.7/dist-packages/mininet/examples/miniedit.py`。

## 参考文档

- [Mininet官方网站](http://mininet.org/)
- [Mininet Github](https://github.com/mininet/mininet)
- [REPRODUCING NETWORK RESEARCH](https://reproducingnetworkresearch.wordpress.com/)