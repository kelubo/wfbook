# 概述

## 1.1 产生背景

如[图1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref101529204)所示，普通聚合的链路只能够在一台设备上，只能提供链路级的保护，当设备故障以后，普通聚合将无法工作，所以需要设备级保护的技术。M-LAG（Multichassis link aggregation，跨设备链路聚合）是基于IEEE P802.1AX协议的跨设备链路聚合技术。M-LAG将两台物理设备虚拟成一台设备来实现跨设备链路聚合，从而提供设备级冗余保护和流量负载分担。

图1 链路聚合和M-LAG对比示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257881_x_Img_x_png_0_2004108_30005_0.png)

 

## 1.2 IRF和M-LAG对比

[表1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref80513653)为IRF和M-LAG对比，组网可靠性要求高，升级过程要求业务中断时间短的场景推荐使用M-LAG。在同一组网环境中，不能同时部署IRF和M-LAG。

表1 IRF和M-LAG对比

| 项目     | IRF                                                          | M-LAG                                                        |
| -------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 控制面   | ·   所有成员设备控制面统一，集中管理  ·   所有成员设备需要同步所有表项 | ·   两台独立设备，控制平面解耦  ·   主要同步MAC表项/ARP表项/ND表项 |
| 设备面   | 紧耦合  ·   硬件要求：芯片架构相同，一般要求同系列  ·   软件要求：必须相同版本 | 松耦合  ·   硬件要求：支持不同型号  ·   软件要求：支持不同版本（由于M-LAG的特性支持情况还在快速发展阶段，现阶段部分产品要求相同版本） |
| 版本升级 | ·   需要成员设备同步升级，或者主设备、从设备分开升级但操作较复杂  ·   升级时业务中断时间2秒左右 | 可独立升级，升级时业务中断时间小于1s  对于支持GIR（Graceful Insertion and Removal，平滑插入和移除）的版本，可以做到不中断 |
| 配置管理 | 统一配置，统一管理，操作简单  耦合度高，和控制器配合存在单点故障可能 | 独立配置，M-LAG系统会进行配置一致性检查，具体业务配置需要手工保证  独立管理，耦合度低，和控制器配合使用不存在单点故障，可靠性更高 |

 

![说明](https://resource.h3c.com/cn/202312/29/20231229_10257882_x_Img_x_png_1_2004108_30005_0.png)

GIR提供了一种设备隔离方案，适用于设备进行维护或升级的场景。通过GIR模式切换功能，可以一次下发多个业务模块的隔离命令，各业务协议模块会先将流量切换至冗余路径，再将设备置于维护模式，此时处于维护模式下的设备与其他设备之间网络隔离。当完成维护或者升级操作之后，将设备切换到普通模式，恢复流量的正常转发和处理。

 

## 1.3 技术优点

M-LAG作为一种跨设备链路聚合的技术，除了具备增加带宽、提高链路可靠性、负载分担的优势外，还具备以下优势：

·   无环拓扑

M-LAG提供无环拓扑，即使在M-LAG组网中部署STP，M-LAG组网中的接口也不会被STP阻塞。

·   更高的可靠性

把链路可靠性从单板级提高到了设备级。

·   双归接入

允许设备双归接入，将两台设备的链路进行聚合，实现流量负载分担。

·   用户流量不中断

M-LAG组网中的接口、链路或者设备发生故障时，可将用户流量快速切换到正常设备/链路转发，确保用户业务不中断。

·   简化组网及配置

提供了一个没有环路的二层拓扑，同时实现冗余备份，不再需要繁琐的防环协议配置，极大地简化了组网及配置。

·   独立升级

两台设备可以分别进行升级，保证有一台设备正常工作即可，对正在运行的业务几乎没有影响。

# 2 M-LAG技术实现

## 2.1 M-LAG基本概念

如[图2](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref465339785)所示，Device D接入到Device A和Device B组成的M-LAG系统，通过Device A和Device B共同进行流量转发，保证网络的可靠性。

图2 M-LAG组网示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257893_x_Img_x_png_2_2004108_30005_0.png)

 

M-LAG涉及的相关概念如下：

·   M-LAG主设备：部署M-LAG且状态为Primary的设备。

·   M-LAG备设备：部署M-LAG且状态为Secondary的设备。

·   peer-link链路：M-LAG设备间的交互M-LAG协议报文及传输数据流量的链路。peer-link可以是聚合链路，也可以是Tunnel隧道，管理员需要根据不同组网环境选择peer-link链路。当采用聚合链路作为peer-link链路时，建议将多条链路进行聚合。一个M-LAG系统只有一条peer-link链路。

·   peer-link接口：peer-link链路对应的接口，可以是聚合接口，也可以是Tunnel接口。每台M-LAG设备只有一个peer-link接口。

·   Keepalive链路：M-LAG主备设备间的一条三层互通链路，用于M-LAG主备设备间检测邻居状态，即通过交互Keepalive报文来进行peer-link链路故障时的双主检测。

·   M-LAG组：用于部署M-LAG设备之间的配对，M-LAG设备上相同编号的M-LAG接口属于同一M-LAG组。

·   M-LAG接口：M-LAG主备设备与外部设备相连的二层聚合接口。为了提高可靠性，需要使用动态聚合。M-LAG设备上相同编号的M-LAG接口属于同一M-LAG组。M-LAG组ID为M-LAG接口编号。

![说明](https://resource.h3c.com/cn/202312/29/20231229_10257904_x_Img_x_png_3_2004108_30005_0.png)

M-LAG的角色区分为主和备，正常情况下，主设备和备设备同时进行业务流量的转发，转发行为没有区别，仅在故障场景下，主备设备的行为会有差别。

 

## 2.2 M-LAG网络模型

### 2.2.1 双归接入M-LAG网络模型

如[图3](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref103502298)所示，Device D设备和Server分别双归接入Device A与Device B组成的M-LAG系统。Device A与Device B形成负载分担，共同进行流量转发，当其中一台设备发生故障时，流量可以快速切换到另一台设备，保证业务的正常运行。

图3 双归接入M-LAG网络模型示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257915_x_Img_x_png_4_2004108_30005_0.png)

 

### 2.2.2 单归接入M-LAG网络模型

单归接入是指一台外部设备仅接入M-LAG系统的其中一台M-LAG设备。该外部设备称为单挂设备。

根据接入接口的不同，单归接入分为：

·   M-LAG单归接入：通过M-LAG接口接入M-LAG系统的其中一台M-LAG设备。

·   非M-LAG单归接入：通过非M-LAG接口接入M-LAG系统的其中一台M-LAG设备。

如[图4](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref103502392)所示，Device D设备以M-LAG单归接入方式接入M-LAG系统，Device E设备以非M-LAG单归接入方式接入M-LAG系统。Device D和Device E以单归方式接入M-LAG系统，Device D和Device E的MAC地址、ARP/ND等表项会M-LAG系统间进行备份，为南北向流量提供备份路径，提高可靠性。

图4 单归接入M-LAG网络模型示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257926_x_Img_x_png_5_2004108_30005_0.png)

 

## 2.3 M-LAG系统建立和维护

M-LAG设备间通过交互DRCP（Distributed Relay Control Protocol，分布式聚合控制协议）报文和Keepalive报文建立和维护M-LAG系统。在M-LAG系统正常工作时，M-LAG系统的主备设备负载分担共同进行流量转发。如果M-LAG系统中出现故障（无论是接口故障、链路故障还是设备故障），M-LAG系统都可以保证正常的业务不受影响。

### 2.3.1 M-LAG系统建立及工作过程

如[图5](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref511045581)所示，Device A和Device B之间M-LAG系统建立及工作过程如下：

(1)   DRCP协商

当M-LAG设备完成M-LAG系统参数配置后，两端设备通过peer-link链路定期发送DRCP报文。

(2)   M-LAG配对

当本端收到对端的DRCP协商报文后，会判断DRCP协商报文中的M-LAG系统配置是否和本端相同。如果两端的M-LAG系统配置相同，则这两台设备组成M-LAG系统。

(3)   主备协商

配对成功后，两端设备会确定出主备状态。依次比较两端M-LAG设备的初始角色、M-LAG MAD DOWN状态、设备的健康值、角色优先级、设备桥MAC，比较结果更优的一端为主设备。主备协商后，M-LAG设备间会进行配置一致性检查。有关一致性检查的详细介绍，请参见“[2.3.8 ](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref487012392)[配置一致性检查功能](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref487012392)”。

(4)   双主检测

当主备角色确定后，两端设备通过Keepalive链路周期性地发送Keepalive报文进行双主检测。

(5)   M-LAG系统开始工作后，两端设备之间会通过peer-link链路实时同步对端的信息，例如MAC地址表项、ARP表项，从而确保任意一台设备故障都不会影响流量的转发，保证业务不会中断。

图5 M-LAG建立及工作过程示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257937_x_Img_x_png_6_2004108_30005_0.png)

 

### 2.3.2 DRCP协议

M-LAG通过在peer-link链路上运行DRCP来交互分布式聚合的相关信息，以确定两台设备是否可以组成M-LAG系统。运行该协议的设备之间通过互发DRCPDU（Distributed Relay Control Protocol Data Unit，分布式聚合控制协议数据单元）来交互分布式聚合的相关信息。

#### 1. DRCPDU的交互

两端M-LAG设备通过peer-link链路定期交互DRCP报文。当本端M-LAG设备收到对端M-LAG设备的DRCP协商报文后，会判断DRCP协商报文中的M-LAG系统配置是否和本端相同。如果两端的M-LAG系统配置均相同，则这两台设备可以组成M-LAG系统。

#### 2. DRCP超时时间

DRCP超时时间是指peer-link接口等待接收DRCPDU的超时时间。在DRCP超时时间之前，如果本端peer-link未收到来自对端M-LAG设备的DRCPDU，则认为对端M-LAG设备peer-link接口已经失效。

DRCP超时时间同时也决定了对端M-LAG设备发送DRCPDU的速率。DRCP超时有短超时（3秒）和长超时（90秒）两种：

·   若本端DRCP超时时间为短超时，则对端M-LAG设备将快速发送DRCPDU（每1秒发送1个DRCPDU）。

·   若本端DRCP超时时间为长超时，则对端M-LAG设备将慢速发送DRCPDU（每30秒发送1个DRCPDU）。

### 2.3.3 Keepalive机制

M-LAG设备间通过Keepalive链路检测邻居状态，即通过交互Keepalive报文来进行peer-link链路故障时的双主检测。

#### 1. Keepalive定时器

缺省情况下，Keepalive各个定时器如[表2](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref103511638)所示。

表2 Keepalive定时器描述表

| Keepalive定时器类型    | 定时器中文涵义                            | 定时器缺省值 |
| ---------------------- | ----------------------------------------- | ------------ |
| Keepalive interval     | Keepalive报文发送的时间间隔               | 1秒          |
| Keepalive hold timeout | peer-link链路down后等待检测故障原因的时间 | 3秒          |
| Keepalive timeout      | Keepalive报文超时时间间隔                 | 5秒          |

 

#### 2. Keepalive实现机制

如果在Keepalive timeout时间内，本端M-LAG设备收到对端M-LAG设备发送的Keepalive报文：

·   如果peer-link链路状态为down，则认为peer-link故障，启动Keepalive hold timeout定时器：

¡   在该定时器超时前收到DRCP报文，则peer-link链路状态恢复up，M-LAG系统正常工作。

¡   在该定时器超时前未收到DRCP报文，则本端和对端M-LAG设备根据收到的Keepalive报文选举主备设备，保证M-LAG系统中仅一台M-LAG设备转发流量，避免两台M-LAG设备均升级为主设备。

·   如果peer-link链路状态为up，则M-LAG系统正常工作。

如果在Keepalive timeout时间内，本端M-LAG设备未收到对端M-LAG设备发送的Keepalive报文：

·   如果peer-link链路状态为down，则认为对端M-LAG设备状态为down，启动Keepalive hold timeout定时器，在该定时器超时后：

¡   本端设备为主设备时，如果本端设备上存在处于up状态的M-LAG口，则本端仍为主设备；否则，本端设备角色变为None角色。

¡   本端设备为备设备时，则升级为主设备。此后，只要本端设备上存在处于up状态的M-LAG口，则保持为主设备，否则本端设备角色变为None角色。

当设备为None角色时，设备不能收发Keepalive报文，Keepalive链路处于down状态。

·   如果peer-link链路状态为up，则认为Keepalive链路状态为down。此时主备设备正常工作，同时设备打印日志信息，提醒用户检查Keepalive链路。

### 2.3.4 MAD机制

设备上接口在M-LAG系统分裂后有以下状态：

·   M-LAG系统分裂后接口处于M-LAG MAD DOWN状态。

·   M-LAG系统分裂后接口保持原状态不变。

peer-link链路故障后，为了防止备设备继续转发流量，M-LAG提供MAD（Multi-Active Detection，多Active检测）机制，即在M-LAG系统分裂时将设备上部分接口置为M-LAG MAD DOWN状态，仅允许M-LAG口、peer-link接口等接口转发流量，避免流量错误转发，尽量减少对业务影响。如果希望M-LAG系统中有特殊用途的接口（比如Keepalive接口）保持up状态，可以将其指定为M-LAG保留接口。

M-LAG系统分裂时，设备上以下接口不被置为M-LAG MAD DOWN状态：

·   M-LAG保留接口（包括用户配置的和系统保留的）。

·   配置了强制端口up功能的接口。

M-LAG保留接口包括系统保留接口和用户配置的保留接口。系统保留接口包括：

·   peer-link接口

·   peer-link接口所对应的二层聚合接口的成员接口

·   M-LAG接口

·   管理以太网接口

当peer-link链路故障恢复后，为了防止丢包，备设备尽可能在延迟恢复时间内完成表项（MAC地址表、ARP表等）同步，其后该设备上处于M-LAG MAD DOWN状态的接口将恢复为up状态。

在EVPN VXLAN支持M-LAG组网环境中，当使用VXLAN隧道作为peer-link链路时，为了保证M-LAG系统分裂后M-LAG设备能够正常工作，需要将大量逻辑接口（例如Tunnel接口或LoopBack接口）配置为保留接口。此时，为了减少配置工作量，可以指定部分无关接口在M-LAG系统分裂后处于M-LAG MAD DOWN状态，指定其他接口在M-LAG系统分裂后保持原状态不变。

### 2.3.5 M-LAG防环机制

M-LAG本身具有防环机制，可以构造出一个无环网络。如[图6](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref103529397)所示，从接入设备或网络侧到达M-LAG设备的单播流量，会优先从本地转发出去，peer-link链路一般情况下不用来转发数据流量。当流量通过peer-link链路转发到对端M-LAG设备，在peer-link链路与M-LAG接口之间设置单方向的流量隔离，即从peer-link接口进来的流量不会再从M-LAG接口转发出去，所以不会形成环路，这就是M-LAG单向隔离机制。

图6 M-LAG防环机制示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257948_x_Img_x_png_7_2004108_30005_0.png)

 

### 2.3.6 M-LAG表项同步机制

如[图7](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref103534878)所示，M-LAG主备设备之间会实时同步MAC地址表项、ARP表项、DHCP表项、ND表项等表项。单归接入场景中，单归接入的M-LAG接口的表项将同步到对端设备的peer-link接口上，以便下行流量绕行peer-link链路转发到Device F。

图7 M-LAG表项同步机制示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257959_x_Img_x_png_8_2004108_30005_0.png)

 

### 2.3.7 M-LAG设备工作模式

M-LAG设备工作模式分为以下两种：

·   M-LAG系统工作模式：作为M-LAG系统成员设备参与报文转发。接入设备与M-LAG设备交互的LACPDU（Link Aggregation Control Protocol Data Unit，链路聚合控制协议数据单元）中，LACDU携带的LACP System ID由M-LAG系统MAC地址和M-LAG系统优先级组成。

·   独立工作模式：脱离M-LAG系统独立工作，独自转发报文。接入设备与M-LAG设备交互的LACPDU（Link Aggregation Control Protocol Data Unit，链路聚合控制协议数据单元）中，LACDU携带的LACP System ID由LACP系统MAC地址和LACP系统优先级组成。

当M-LAG系统分裂时，为了避免M-LAG系统中的两台设备都作为主设备转发流量的情况，需要M-LAG设备独立工作。在peer-link链路和Keepalive链路均处于DOWN状态时，备设备会立即或经过一段时间切换到独立运行模式。

M-LAG设备切换到独立运行模式后，聚合接口发送的LACPDU中携带的M-LAG系统参数还原为聚合接口的LACP系统MAC地址和LACP系统优先级，使同一M-LAG组中的两个聚合接口的LACP系统MAC地址和LACP系统优先级不一致。这样只有一边聚合接口的成员端口可以被选中，通过被选中的设备转发业务流量，避免流量转发异常。

### 2.3.8 配置一致性检查功能

M-LAG系统建立过程中会进行配置一致性检查，以确保两端M-LAG设备配置匹配，不影响M-LAG设备转发报文。M-LAG设备通过peer-link链路交换各自的配置信息，检查配置是否匹配。目前M-LAG支持对两种类型的配置进行一致性检查：

·   关键配置：Type 1类型配置，即影响M-LAG系统转发的配置。如果Type 1类型配置不匹配，则将备设备上M-LAG接口置为down状态，将导致链路状态正常但是长时间丢包等问题。

·   一般配置：Type 2类型配置，即仅影响业务模块的配置。如果Type 2类型配置不匹配，备设备上M-LAG接口依然为up状态，不影响M-LAG系统正常工作。与Type 1类型配置相比而言，Type 2类型配置对网络环境影响较小。Type 2类型配置仅影响其对应的业务模块功能。

### 2.3.9 M-LAG双活网关

在M-LAG双归接入三层网络的场景中，两台M-LAG设备需要同时作为三层网关，必须保证M-LAG设备上存在相同的IP地址和MAC地址的逻辑接口，以便实现：

·   当一条接入链路发生故障时，流量可以快速切换到另一条链路，保证可靠性。

·   两条接入链路可以同时处理用户流量，以提高带宽利用率，使流量在两条接入链路上负载分担。

M-LAG双活网关主要用于接入侧设备通过动态路由接入M-LAG的组网环境中。如[图8](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref98700020)所示，用户可以在Device C上部署静态路由通过三层路由方式接入到M-LAG系统，但部署静态路由将带来运维难度的上升和缺乏灵活快速部署能力，无法满足快速增长的业务需要。为解决静态路由表带来的问题，需要在M-LAG系统与用户侧设备之间建立动态路由协议邻居：

·   M-LAG设备Device A和Device B上各创建一个相同编号的VLAN接口（例如Vlan-interface100），该接口作为网关接口，具有相同的IPv4地址、IPv6地址和MAC地址，且M-LAG接口允许该VLAN通过。

·   在该VLAN接口下配置IP地址不同的M-LAG虚拟地址，用于IGP/BGP动态路由协议邻居建立，使得M-LAG设备和Device C之间建立IGP/BGP邻居，M-LAG设备之间也会建立IGP/BGP邻居。

图8 动态路由接入M-LAG示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257970_x_Img_x_png_9_2004108_30005_0.png)

 

### 2.3.10 M-LAG序列号校验

当网络入侵者从网络上截取M-LAG 1发送给M-LAG 2的DRCP报文/Keepalive报文，并将这些报文发送给M-LAG 2，使M-LAG 2误以为入侵者就是M-LAG 1，然后M-LAG 2向伪装成M-LAG 1的入侵者发送应当发送给M-LAG 1的报文。M-LAG 1接收不到M-LAG 2发送的DRCP报文/Keepalive报文，导致M-LAG系统分裂，出现双主双活问题。

为了防止重放攻击，保证流量正常转发，M-LAG支持序列号校验，以识别非法攻击报文。

如[图9](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref19867220)所示，如果M-LAG设备本次收到的DRCP报文/Keepalive报文的序列号与已经收到的DRCP报文/Keepalive报文的序列号相同，或小于上次收到的DRCP报文/Keepalive报文的序列号，则认为发生重放攻击。M-LAG设备会丢弃序列号校验失败的DRCP报文/Keepalive报文。

图9 M-LAG序列号校验示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257883_x_Img_x_png_10_2004108_30005_0.png)

 

### 2.3.11 M-LAG报文认证

为防止攻击者篡改DRCP报文/Keepalive报文内容，M-LAG提供报文认证功能，提高安全性。

如[图10](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref19868901)所示，M-LAG设备发送的DRCP报文/Keepalive报文中会携带一个消息摘要，该消息摘要是对报文内容经Hash计算得到。对端M-LAG设备收到该报文时，会与自己计算的该报文的消息摘要进行比对，如果一致，则认为其合法。

图10 M-LAG报文认证

![img](https://resource.h3c.com/cn/202312/29/20231229_10257884_x_Img_x_png_11_2004108_30005_0.png)

 

## 2.4 流量转发

M-LAG系统建立成功后即进入正常的工作，M-LAG主备设备负载分担共同进行流量的转发，转发行为没有区别。

### 2.4.1 单播流量转发

如[图11](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref103541042)所示，Device D设备接入M-LAG系统，已知单播流量转发机制如下：

·   对于南北向的单播流量，在M-LAG接入侧，M-LAG设备接收到接入设备通过聚合链路负载分担发送的流量后，按本地转发优先原则，共同进行流量转发。发往Network侧的流量到达M-LAG设备后将根据路由表转发流量。

·   对于东西向的单播流量，二层流量通过M-LAG本地优先转发，三层流量通过双活网关转发，都不经过peer-link链路，直接由M-LAG设备转发。

图11 单播流量转发示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257885_x_Img_x_png_12_2004108_30005_0.png)

 

#### 1. 南北向流量转发

如[图12](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref104542496)所示，上行流量转发机制如下：

·   对于来自M-LAG接口的单播流量，Device A与Device B形成负载分担，共同对来自M-LAG接口端口的单播流量进行转发。单播流量按本地转发优先原则，避免对peer-link链路造成压力。

·   对于来自非M-LAG接口的单播流量，Device B按本地转发优先原则直接转发，不向peer-link链路转发。

图12 上行流量转发示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257886_x_Img_x_png_13_2004108_30005_0.png)

 

如[图13](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref104543249)所示，对于来自网络侧的单播流量，根据本地转发优先原则，直接本地转发。

图13 下行流量转发示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257887_x_Img_x_png_14_2004108_30005_0.png)

 

#### 2. 东西向流量转发

如[图14](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref104542500)所示，东西向流量转发机制如下：

·   如果本地存在出接口，则按照本地转发优先原则，本地直接转发。

·   如果本地不存在出接口，则流量绕行peer-link链路，通过对端M-LAG设备转发。

图14 东西向流量转发示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257888_x_Img_x_png_15_2004108_30005_0.png)

 

 

### 2.4.2 未知单播/广播流量转发

如[图15](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref103541630)所示，Device D设备接入M-LAG系统，未知单播/广播流量转发机制如下：

·   Device B收到来自非M-LAG接口的未知单播/广播流量后，将向相连设备的同一广播域转发。当流量到达Device A时，由于peer-link接口与M-LAG接口存在单向隔离机制，到达Device A的流量不会向Device D转发。

·   Device D发送的未知单播/广播流量到达M-LAG设备（以Device A为例）后，将向相连设备的同一广播域转发。当流量到达Device B时，由于peer-link接口与M-LAG接口存在单向隔离机制，到达Device B的流量不会向Device D转发。

图15 广播流量转发示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257889_x_Img_x_png_16_2004108_30005_0.png)

 

### 2.4.3 组播流量转发

M-LAG组网环境中组播流量的转发过程，具体请参见“[8 ](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref104796823)[二层组播支持M-LAG](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref104796832)”和“[9 ](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref104796857)[三层组播支持M-LAG](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref104796842)”。

## 2.5 M-LAG故障处理机制

### 2.5.1 M-LAG接口故障处理机制

如[图16](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref511154541)所示，某M-LAG接口故障，来自外网侧的流量会通过peer-link链路发送给另外一台设备，所有流量均由另外一台M-LAG设备转发，具体过程如下：

(1)   Device B的某M-LAG接口故障，外网侧不感知，流量依然会发送给所有M-LAG设备。

(2)   Device A的相同M-LAG接口正常，则Device B收到外网侧访问Device C的流量后，通过peer-link链路将流量交给Device A后转发给Device C。

(3)   故障恢复后，Device B的该M-LAG接口up，流量正常转发。

图16 M-LAG接口故障处理机制示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257890_x_Img_x_png_17_2004108_30005_0.png)

 

![说明](https://resource.h3c.com/cn/202312/29/20231229_10257891_x_Img_x_png_18_2004108_30005_0.png)

对于已知单播，当M-LAG接口被手动shutdown、undo shutdown或M-LAG接口所在设备重启后，M-LAG设备支持下行链路切换无丢包。

 

### 2.5.2 peer-link链路故障处理机制

如[图17](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref471312234)所示，peer-link链路故障但Keepalive链路正常会导致备设备上除M-LAG保留接口以外的接口处于M-LAG MAD DOWN状态。主设备上的M-LAG接口所在聚合链路状态仍为up，备设备上的M-LAG接口所在聚合链路状态变为down，从而保证所有流量都通过主设备转发。一旦peer-link链路故障恢复，处于M-LAG MAD DOWN状态的接口经过延迟恢复时间自动恢复为up状态。

图17 peer-link链路故障处理机制示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257892_x_Img_x_png_19_2004108_30005_0.png)

 

### 2.5.3 设备故障处理机制

如[图18](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref471312252)所示，Device A为主设备，Device B为备设备。当主设备故障后，主设备上的聚合链路状态变为down，不再转发流量。备设备将升级为主设备，该设备上的聚合链路状态为up，流量转发状态不变，继续转发流量。主设备故障恢复后，M-LAG系统中由从状态升级为主状态的设备仍保持主状态，故障恢复后的设备成为M-LAG系统的备设备。

如果是备设备发生故障，M-LAG系统的主备状态不会发生变化，备设备上的聚合链路状态变为down。主设备上的聚合链路状态为up，流量转发状态不变，继续转发流量。

图18 设备故障处理机制示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257894_x_Img_x_png_20_2004108_30005_0.png)

 

### 2.5.4 上行链路故障处理机制

上行链路故障并不会影响M-LAG系统的转发。如[图19](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref508981492)所示，Device A上行链路虽然故障，但是外网侧的转发相关表项由Device B通过peer-link链路同步给Device A，Device A会将访问外网侧的流量发送给Device B进行转发。而外网侧发送给Device C的流量由于接口故障，自然也不会发送给Device A处理。

上行链路故障时，如果通过Device A将访问外网侧的流量发送给Device B进行转发，会降低转发效率。此时用户可以配置Monitor Link功能，将M-LAG组成员端口和上行端口关联起来，一旦上行链路故障了，会联动M-LAG组成员端口状态，将其状态变为down，提高转发效率。

图19 上行链路故障处理机制示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257895_x_Img_x_png_21_2004108_30005_0.png)

 

### 2.5.5 M-LAG二次故障处理机制

M-LAG二次故障是指在peer-link发生故障后，Keepalive链路也发生故障，或者在Keepalive链路发生故障后，peer-link也发生故障。针对M-LAG设备上不同的配置情况，当发生二次故障时，处理方式不同。

#### 1. 缺省配置场景

如[图20](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref24817368)所示，若peer-link链路先发生故障，此时两端M-LAG设备会根据Keepalive链路进行设备角色选举，并依据MAD检测机制，将从设备上除M-LAG保留接口外的所有接口置为M-LAG MAD DOWN状态。

此后，若Keepalive链路也发生故障，从设备也会升为主设备，并解除设备上所有接口的M-LAG MAD DOWN状态，以双主双活的方式转发流量。由于peer-link链路故障时，无法同步表项，可能导致流量转发错误。

若Keepalive链路先发生故障，peer-link链路后发生故障，则M-LAG设备上的接口不会被置为M-LAG MAD DOWN状态，而是直接以双主双活的方式转发流量，可能导致流量转发错误。

图20 缺省配置场景下二次故障处理机制示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257896_x_Img_x_png_22_2004108_30005_0.png)

 

#### 2. 开启M-LAG MAD DOWN状态保持功能场景

如[图21](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref24818769)所示，若peer-link先发生故障，此时两端M-LAG设备会根据Keepalive链路进行设备角色选举，并依据MAD检测机制，将从设备上除M-LAG保留接口外的所有接口置为M-LAG MAD DOWN状态。

此后，若Keepalive链路也发生故障，从设备也会升为主设备，但由于M-LAG设备已开启M-LAG MAD DOWN状态保持功能，将不会解除设备上所有接口的M-LAG MAD DOWN状态，继续只从原来的主设备转发流量。这样将不会出现双主双活的情况，避免流量转发异常。

若Keepalive链路先发生故障，peer-link链路后发生故障，则M-LAG设备上的接口不会被置为M-LAG MAD DOWN状态，而是直接以双主双活的方式转发流量。M-LAG MAD DOWN状态保持功能不能解决Keepalive链路先故障，peer-link后故障导致的双主双活问题。

图21 开启M-LAG MAD DOWN状态保持功能场景下二次故障处理机制示意图（一）

![img](https://resource.h3c.com/cn/202312/29/20231229_10257897_x_Img_x_png_23_2004108_30005_0.png)

 

如[图22](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref24820048)所示，如果主设备故障或者主设备上M-LAG接口故障，则无法转发流量。为了避免这种情况可以关闭M-LAG MAD DOWN状态保持功能，解除从设备上所有接口的M-LAG MAD DOWN状态，使从设备升级为主设备，以保证流量正常转发，减少流量中断时间。

图22 开启M-LAG MAD DOWN状态保持功能场景下二次故障处理机制示意图（二）

![img](https://resource.h3c.com/cn/202312/29/20231229_10257898_x_Img_x_png_24_2004108_30005_0.png)

 

#### 3. 开启设备独立工作功能场景

如[图23](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref24821115)所示，若peer-link先发生故障，此时两端M-LAG设备会根据Keepalive链路进行设备角色选举，并依据MAD检测机制，将从设备上除M-LAG保留接口外的所有接口置为M-LAG MAD DOWN状态。

此后，若Keepalive链路也发生故障，从设备也会升为主设备，解除所有接口的M-LAG MAD DOWN状态。但由于已开启立即或延迟切换到设备独立工作状态功能，两台M-LAG设备将切换到独立工作状态，切换后M-LAG接口对应的聚合接口发送的LACP报文中携带的M-LAG系统参数还原为聚合接口的LACP系统MAC地址和LACP系统优先级，使同一M-LAG组中的两个聚合接口的LACP系统MAC地址和LACP系统优先级不一致。这样M-LAG设备中只有一台设备的聚合接口的成员端口可以被选中（接入设备上仅一个成员端口可以被选中），通过被选中的设备转发业务流量，避免流量转发异常。成员端口的选中与LACP系统优先级和系统MAC地址相关，与M-LAG设备角色无关。LACP系统优先级和系统MAC地址越小，则优先被选中。若选中的成员端口也发生故障，则将选中另外一台设备上聚合接口的成员端口，通过该聚合接口继续转发流量。

若Keepalive链路先发生故障，peer-link链路后发生故障，则M-LAG设备上的接口不会被置为M-LAG MAD DOWN状态，将立即或延迟一段时间切换到设备独立工作模式。

图23 开启设备独立工作功能场景下二次故障处理机制示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257899_x_Img_x_png_25_2004108_30005_0.png)

 

# 3 M-LAG网络中运行STP

## 3.1 STP应用场景

M-LAG本身具有环路避免机制，正常情况下，M-LAG组网中不会产生环路。多级M-LAG组网中，网络搭建错误、初始化M-LAG配置或设备空配置重启时，网络中可能会产生环路，需要部署STP来避免环路。需要部署STP的典型场景包括：

·   下行接入设备产生环路。

·   多级M-LAG设备间接入设备产生环路。

·   初始化M-LAG配置产生环路。

·   设备空配置重启产生环路。

### 3.1.1 下行接入设备产生环路

如[图24](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref97969687)所示，下行设备Device M和Device N通过非M-LAG接口接入Device A和Device B，且Device M和Device N互连。

图24 下行设备接入M-LAG系统产生环路示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257900_x_Img_x_png_26_2004108_30005_0.png)

 

如[图25](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref97970917)所示，Device M和Device N间的流量会经过Device A和Device B间的peer-link链路绕行，形成环路。为了避免环路，需要在Device A和Device B、Device M和Device N上部署STP，阻塞Device M和Device N之间链路。其中，Device A和Device B作为指定桥，Device M和Device N间流量将通过Device A和Device B转发，避免了环路。

图25 下行设备接入M-LAG系统产生环路拓扑图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257901_x_Img_x_png_27_2004108_30005_0.png)

 

### 3.1.2 多级M-LAG设备间产生的环路

如[图26](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref97974601)所示，多级M-LAG组网中，Device A和Device C之间通过非M-LAG接口误接线。

图26 多级M-LAG设备间环路产生示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257902_x_Img_x_png_28_2004108_30005_0.png)

 

如[图27](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref97974615)所示，Device A和Device C间的流量会经过peer-link链路绕行，形成环路。为了避免环路，需要在Device A和Device B、Device C和Device D上部署STP，阻塞Device A和Device C之间的误连接。其中，Device C和Device D作为指定桥，Device A和Device C间流量将通过多级M-LAG中的M-LAG接口转发，避免了环路。

图27 多级M-LAG设备间环路产生拓扑图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257903_x_Img_x_png_29_2004108_30005_0.png)

 

### 3.1.3 初始化M-LAG配置产生环路

如[图28](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref98494293)所示，按照M-LAG组网要求完成设备间的线路连接，并在M-LAG设备上执行M-LAG相关配置后，在M-LAG系统建立前，网络中存在短暂的环路。此时，通过部署STP，可以阻塞端口，避免流量转发环路。

建议M-LAG系统建立完成，并验证通过后，再将M-LAG系统接入到现网中，以避免初始化M-LAG配置产生环路。

图28 初始化M-LAG配置环路产生示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257905_x_Img_x_png_30_2004108_30005_0.png)

 

### 3.1.4 设备空配置重启产生环路

如[图29](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref98494571)所示，两台M-LAG设备组成M-LAG系统后，如果其中一台M-LAG设备进行空配置重启，则该设备重启后不会加入M-LAG系统，作为独立的物理设备运行，可以转发流量。另一台M-LAG设备认为对端M-LAG设备故障，承担流量转发工作。从而，导致网络中存在环路。通过部署STP，可以用来避免环路。

图29 设备空配置重启环路产生示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257906_x_Img_x_png_31_2004108_30005_0.png)

 

## 3.2 STP在M-LAG中的工作机制

在M-LAG组网中，由于组成M-LAG系统的两台M-LAG设备虚拟为一台设备，为了确保STP在M-LAG组网中的正常运行，M-LAG设备上的STP运行机制需要进行如下调整：

·   STP协议由主设备控制。无论指定端口位于哪台M-LAG设备，都是由主设备生成STP的BPDU报文，并在指定的端口上发送BPDU报文。端口的STP状态也由主设备决定。

·   备设备不生成BPDU报文，也无法决定端口的STP状态。备设备接收到BPDU报文后，通过peer-link链路将其转发给主设备。

·   两台M-LAG设备上M-LAG接口的STP端口状态始终保持一致。

·   peer-link链路上不运行STP协议。

![说明](https://resource.h3c.com/cn/202312/29/20231229_10257907_x_Img_x_png_32_2004108_30005_0.png)

组成M-LAG系统的两台M-LAG设备具有相同的虚MAC地址（M-LAG系统的MAC地址）。M-LAG设备基于该虚MAC地址运行STP协议，因此，两台M-LAG设备可以同时作为STP的根。

 

# 4 M-LAG三层网关

## 4.1 VLAN双活网关

如[图30](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref99351300)所示，VLAN双活网关是指组成M-LAG系统的两台M-LAG设备均作为用户侧的网关，回应用户侧的ARP/ND请求并转发用户侧的报文，以提高网关的可靠性。

图30 M-LAG VLAN双活网关部署方案

![img](https://resource.h3c.com/cn/202312/29/20231229_10257908_x_Img_x_png_33_2004108_30005_0.png)

 

M-LAG VLAN双活网关的部署方案为：在同一M-LAG系统的两台M-LAG设备上各创建一个相同编号的VLAN接口（例如Vlan-interface100），并为其配置相同的IPv4地址、IPv6地址和MAC地址。该接口的IPv4地址和IPv6地址作为网关地址，以便IPv4和IPv6用户均可通过该网关访问外部网络。

M-LAG VLAN双活网关的工作机制为：

·   M-LAG设备采取本地优先转发原则，设备收到报文后直接转发，无需绕行peer-link链路到对端M-LAG设备转发。例如，M-LAG设备Device E收到VM侧发送的ARP请求，Device E直接向VM侧发送ARP应答报文，无需转发到M-LAG设备Device F处理。

·   当一条接入链路发生故障时，流量可以快速切换到另一条链路，保证可靠性。例如，Device E和Device G之间链路故障，则流量处理方式为：

¡   访问Device D的下行流量快速切换到Device F处理，不再转发到Device E。

¡   访问VM的上行流量，转发到Device F时，Device F处理完成后直接向VM侧转发；转发到Device E时，流量将通过peer-link链路绕行到Device F处理，然后向VM侧转发。

·   两条接入链路可以同时处理用户流量，以提高带宽利用率，使流量在两条接入链路上负载分担。

在M-LAG VLAN双活网关场景中，M-LAG成员设备作为网关进行三层转发。由于作为网关的VLAN接口具有相同的IP地址和MAC地址，M-LAG成员设备无法用该IP地址与用户侧设备之间建立路由邻居关系。当VLAN双活网关需要与Device B建立路由邻居关系时，可以在作为网关的VLAN接口上配置M-LAG虚拟IP地址，并部署路由协议，使用虚拟IP地址与下行设备Device B建立邻居关系。具体部署方式请参见[图31](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref86136386)和[表3](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref86136388)。

图31 M-LAG VLAN双活网关场景网关接口配置M-LAG虚拟IP地址建立路由邻居

![img](https://resource.h3c.com/cn/202312/29/20231229_10257909_x_Img_x_png_34_2004108_30005_0.png)

 

表3 M-LAG VLAN双活网关场景网关接口配置M-LAG虚拟IP地址建立路由邻居

| 应用场景                                 | 部署方案                                                     | 流量模型                                                     |
| ---------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 下行设备Device  B与M-LAG设备部署动态路由 | ·   在同一M-LAG系统的两台M-LAG设备上各创建一个相同编号的VLAN接口（例如VLAN 100）作为IPv4和IPv6双活网关，在两台M-LAG设备上为该VLAN接口配置相同的IP地址和MAC地址作为网关地址。Device B通过M-LAG接口接入到M-LAG设备，且IPv4和IPv6流量均可通过网关地址访问外部网络  ·   在同一M-LAG系统的两台M-LAG设备上，作为网关的VLAN接口下分别配置同一网段不同的M-LAG虚拟IP地址，使用该虚拟IP地址与Device B建立三层连接，通过BGP或OSPF实现三层互通  ·   在同一M-LAG系统的两台M-LAG设备上各自再创建一个相同编号的VLAN接口（例如VLAN 101），将peer-link链路聚合接口加入该VLAN。两台M-LAG设备上分别为该VLAN接口配置同一网段的不同IP地址，以实现两台M-LAG设备的三层互通。如果M-LAG 1或M-LAG 2与上行设备Device A的链路故障，报文可以通过路由绕行到对端M-LAG设备处理  ·   M-LAG设备与上行设备Device A间通过三层接口部署等价路由进行负载分担 | ·   Device B发出的二层流量，查找MAC地址表找到出接口为聚合接口，将流量负载分担到M-LAG设备上。M-LAG设备根据本地优先转发原则，根据MAC地址表进行二层转发  ·   Device B发出的三层流量，根据配置的动态路由生成的路由表找到出接口为VLAN 100，通过VLAN 100加入的聚合接口转发，将流量负载分担到M-LAG设备上，M-LAG设备根据FIB表对流量进行三层转发  ·   外部网络访问Device  B的流量根据ECMP路由，将流量负载分担转到M-LAG设备。M-LAG设备根据本地路由信息将流量转发到Device B |
| BFD快速检测（如有需要）                  | 两台M-LAG设备分别使用M-LAG虚拟IP地址与下行设备的VLAN接口100的从IP地址建立BFD会话 | -                                                            |

 

## 4.2 VRRP网关

在M-LAG设备上部署VRRP，可以实现为下行接入设备提供冗余备份的网关。M-LAG+VRRP的三层转发部署方案请参见[图32](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref86135487)和[表4](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref86135490)。

图32 M-LAG+VRRP的三层转发方案

![img](https://resource.h3c.com/cn/202312/29/20231229_10257910_x_Img_x_png_35_2004108_30005_0.png)

 

表4 M-LAG+VRRP的三层转发方案说明

| 部署方案                                                     | 流量模型                                                     |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| ·   M-LAG设备部署VRRP，VRRP虚拟IP地址作为Device B的网关地址，Device B通过M-LAG接口双归接入到VRRP网关  ·   M-LAG口所属VLAN创建VLAN接口，两台M-LAG设备的VLAN接口分别配置同网段内不同的IP地址作主IP地址，再配置另一网段内同网段不同的IP地址作从IP地址  ·   两台M-LAG设备通过peer-link链路建立的三层接口建立路由邻居作为三层链路备份，如果M-LAG1或M-LAG2与上行设备Device A的链路故障，报文可以通过路由绕行到对端M-LAG设备处理  ·   M-LAG设备与上行设备Device A间通过三层接口部署等价路由进行负载分担 | ·   Device B发往其它网段的报文，通过M-LAG接口负载分担到两台M-LAG设备，两台M-LAG设备均可以作为VRRP虚拟路由器对报文进行转发  ·   Device B发出的三层流量，根据Device B与M-LAG设备VLAN接口从IP建立的路由信息转发  ·   外部网络访问Device  B的流量根据ECMP路由，将流量负载分担转发到M-LAG设备上。M-LAG设备根据本地路由信息将流量转发到Device B |

 

VRRP网关接收到外网发送给Device B的、目的MAC地址为对端M-LAG设备实MAC地址的报文后，如果按照正常转发流程，本地M-LAG设备通过peer-link链路将该报文发送给目的M-LAG设备，则由于M-LAG的防环机制，目的M-LAG设备不会将从peer-link链路上接收的报文通过M-LAG接口转发给Device B，从而导致报文被丢弃。为了避免报文丢失，在M-LAG+VRRP组网中，M-LAG设备间需要同步各自的实MAC地址，使得M-LAG设备可以对目的MAC地址为对端M-LAG设备实MAC地址的报文进行本地三层转发。实MAC地址同步功能始终处于开启状态，无需手工配置。

# 5 M-LAG网络中运行环路检测

## 5.1 功能简介

在M-LAG网络中运行环路检测时，如果设备在M-LAG接口上检测到环路，则形成M-LAG的两台设备作为一台虚拟设备，在同一编号的M-LAG接口上对环路作出相同的响应；如果设备在单归接入设备的接口上检测到环路，则M-LAG的两台设备各自作为独立的一台设备对环路作出单独的响应。

## 5.2 工作机制

### 5.2.1 普通组网下的M-LAG设备环路检测工作机制

#### 1. 功能简介

如[图33](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref102721962)所示，Device A和Device B组成M-LAG系统，作为一台虚拟设备接入在网络中，以提高网络的可靠性。Device C和Device D双归接入M-LAG系统，Device F、Device G和Device H单归接入Device A，本章将通过以下几种情形，分别对环路检测的工作机制进行介绍：

·   双归接入情形：例如M-LAG系统、Device C、Device F以及Device D形成的环路。

·   单归接入情形一：例如Device A、Device B、Device C以及Device F形成的环路。

·   单归接入情形二：例如Device A、Device G以及Device H形成的环路。

图33 普通组网运行环路检测组网图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257911_x_Img_x_png_36_2004108_30005_0.png)

 

#### 2. 环路检测功能的生效机制

M-LAG设备只有在开启了环路检测功能后，才能检测到环路以及对发生环路的端口进行处理。所以根据不同的情形，推荐的环路检测配置如下：

·   对于双归接入情形，用户需要在M-LAG的两台设备上均开启环路检测功能，否则将只有一台设备对端口环路进行处理，无法起到消除环路的作用。

·   对于单归接入情形一，如果用户仅在Device A上开启环路检测功能，建议在BAGG4接口上开启环路检测功能，或全局开启环路检测功能，这样Device A会在Port 1上检测到环路，能够有效地消除环路。如果Device A仅在Port 1上开启环路检测功能，则Device A将在BAGG4接口上检测到环路，而仅阻塞或者关闭Device A的BAGG4接口不足以消除环路，此时建议在Device B上也开启环路检测功能，以确保能够消除环路。

·   对于单归接入情形二，用户只需要在单归接入的Device A上开启环路检测功能，Device A将作为一台独立的设备检测环路。

#### 3. 环路检测报文发送机制

对于双归接入的情形：

·   开启环路检测功能后，M-LAG的两台设备都会在M-LAG接口上发送环路检测报文，报文的源MAC地址相同，均为M-LAG系统MAC地址。

·   M-LAG设备从M-LAG接口收到环路检测报文后，会通过peer-link链路同步给另一台M-LAG设备，以避免单点故障导致另一台M-LAG设备无法收到环路检测报文。

对于单归接入一的情形：

·   开启环路检测功能后，M-LAG设备即在开启了环路检测功能的接口上发送环路检测报文，报文的源MAC地址为M-LAG系统MAC地址。

·   M-LAG设备从M-LAG接口收到环路检测报文后，会通过peer-link链路同步给另一台M-LAG设备；从非M-LAG接口收到环路检测报文后，不会通过peer-link链路同步。

对于单归接入二的情形：

·   开启环路检测功能后，M-LAG设备即在开启了环路检测功能的接口上发送环路检测报文，报文的源MAC地址为M-LAG系统MAC地址。

·   M-LAG设备从非M-LAG接口收到环路检测报文后，不会通过peer-link链路同步给另一台M-LAG设备。

#### 4. 产生环路的判断机制

开启环路检测功能后，M-LAG设备从peer-link链路以外的任意端口收到M-LAG系统发送的环路检测报文时，均会判断该端口存在环路。

M-LAG设备在开启了环路检测功能并从peer-link链路接收到同步的环路检测报文后，本端设备会判断与对端接收到环路检测报文的M-LAG接口属于同一M-LAG组的M-LAG接口也产生了环路。例如，Device A从BAGG4接口收到环路检测报文并通过peer-link链路同步给Device B后，即使Device B没有从BAGG4接口收到环路检测报文，也会认为BAGG4接口上产生了环路，并对其进行相应的处理。

#### 5. 检测到发生环路的处理机制

M-LAG设备接收到本机发送或通过peer-link链路同步的环路检测报文，并判断端口出现环路后，会根据设备的配置对出现环路的端口执行关闭、阻塞或禁止MAC地址学习等操作。

### 5.2.2 VXLAN组网下的M-LAG设备环路检测工作机制

#### 1. 功能简介

如[图34](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref100752955)所示，VXLAN利用M-LAG功能将两台物理设备连接起来虚拟成一台设备，使用该虚拟设备作为VTEP，用以避免VTEP单点故障对网络造成影响，从而提高VXLAN网络的可靠性。本章将通过以下几种情形，分别对环路检测的工作机制进行介绍：

·   双归接入情形：Server 2双归接入VTEP经过VXLAN网络与Server 1实现互通，同时还通过直连的二层网络与Server 1互通，形成了环路。

·   单归接入情形：Server 4单归接入VTEP经过VXLAN网络与Server 3实现互通，同时还通过直连的二层网络与Server 3互通，形成了环路。

图34 VXLAN支持M-LAG网络运行环路检测组网图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257912_x_Img_x_png_37_2004108_30005_0.png)

 

#### 2. 环路检测功能的生效机制

M-LAG设备只有在开启了环路检测功能后，才能检测到环路以及对发生环路的AC进行处理。所以根据不同的情形，推荐的环路检测配置如下：

·   对于双归接入情形，用户需要在M-LAG的两台设备上均开启环路检测功能，否则将只有一台设备对环路进行处理，无法起到消除环路的作用。

·   对于单归接入情形，用户只需要在终端接入的VTEP上开启环路检测功能即可。

#### 3. 环路检测报文发送机制

对于双归接入的情形：

·   开启环路检测功能后，M-LAG的两台设备都会在M-LAG接口的AC上上发送环路检测报文，报文的源MAC地址为M-LAG系统MAC地址。

·   M-LAG设备从M-LAG接口收到环路检测报文后，会通过peer-link链路同步给另一台M-LAG设备，以避免单点故障导致另一台M-LAG设备无法收到环路检测报文。

对于单归接入的情形：

·   开启环路检测功能后，M-LAG设备在终端接入的AC上发送环路检测报文，报文的源MAC地址为M-LAG系统MAC地址。

·   M-LAG设备从M-LAG接口收到环路检测报文后，会通过peer-link链路同步给另一台M-LAG设备；从非M-LAG接口收到环路检测报文后，不会通过peer-link链路同步。

#### 4. 产生环路的判断机制

开启环路检测功能后，M-LAG设备从peer-link链路以外的AC收到环路检测报文、且该环路检测报文携带的VLAN Tag与AC发送的环路检测报文相同时，会判断该AC存在环路。

M-LAG设备在开启了环路检测功能并从peer-link链路接收到同步的环路检测报文后，本端设备会判断本端同一M-LAG组中，与环路检测报文属于相同VXLAN的AC也产生了环路。例如，VTEP 1从BAGG接口上的AC收到环路检测报文并通过peer-link链路同步给VTEP 2后，即使VTEP 2没有从BAGG接口上的AC收到环路检测报文，也会认为本机上与VTEP 1上收到环路检测报文AC属于同一VXLAN的AC产生了环路。

#### 5. 检测到发生环路的处理机制

M-LAG设备从AC或者peer-link链路接收环路检测报文，并判断AC出现环路后，会根据收到的环路检测报文的优先级进行判断：

·   如果收到的环路检测报文的优先级更高，则M-LAG设备会根据配置对出现环路的AC进行阻塞等操作。

·   如果收到的环路检测报文的优先级更低，则M-LAG设备不会对出现环路的AC触发环路的处理动作。

# 6 DHCP/DHCPv6支持M-LAG

![说明](https://resource.h3c.com/cn/202312/29/20231229_10257913_x_Img_x_png_38_2004108_30005_0.png)

·   当前DHCP支持M-LAG主要应用场景为DHCP Snooping，DHCP中继支持M-LAG的工作机制与DHCP Snooping基本一致，本章主要介绍DHCP Snooping支持M-LAG的工作机制。

·   本章内容中涉及的DHCP Snooping包括了DHCPv4 Snooping和DHCPv6 Snooping。

 

## 6.1 功能简介

在网络中，为了提高DHCP Snooping设备的可靠性，可以配置M-LAG组网下的DHCP功能。将两台DHCP Snooping设备在聚合层面虚拟成一台设备来实现跨设备链路聚合，从而提供设备级冗余保护和流量负载分担。

## 6.2 工作机制

### 6.2.1 M-LAG系统建立

DHCP Snooping作为M-LAG设备，M-LAG系统的建立及工作过程参见“[2.3 ](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref103590642)[M-LAG系统建立和维护](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref103590621)”。

### 6.2.2 用户表项同步机制

·   实时备份

DHCP用户触发上线、续约或者下线时，由一端设备上生成、更新或删除用户表项，并将数据通过peer-link链路实时备份到对端设备上。

·   批量备份

peer-link接口状态由DOWN变UP时会触发批量备份事件，由M-LAG主设备将本端保存的用户表项发送给M-LAG备设备备份，备设备比主设备多余的用户表项也会发送给主设备备份，两端最终保存的表项是双方表项的并集。处于批备阶段时，实备消息会延迟发送。

## 6.3 流量转发

DHCP Snooping支持M-LAG主要涉及如下几种应用场景。

### 6.3.1 M-LAG设备双边聚合场景

图35 M-LAG设备双边聚合场景（本端设备M-LAG上行口UP）

![img](https://resource.h3c.com/cn/202312/29/20231229_10257914_x_Img_x_png_39_2004108_30005_0.png)

 

图36 M-LAG设备双边聚合场景（本端设备M-LAG上行口DOWN）

![img](https://resource.h3c.com/cn/202312/29/20231229_10257916_x_Img_x_png_40_2004108_30005_0.png)

 

如[图35](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref102722308)、[图36](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref102722314)所示，以DHCP请求报文发送给了M-LAG 1（以下称为本端设备）为例：

(1)   本端设备收到DHCP客户端的请求报文后，生成用户的MAC地址临时表项（上线接口为M-LAG接口）。

(2)   本端设备通过peer-link链路将请求报文同步给对端设备，对端设备生成用户的MAC地址临时表项（上线接口为peer-link接口）。

(3)   后续请求报文转发与设备上行口状态有关：

¡   如[图35](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref102722308)所示，如果本端设备M-LAG上行口UP，则本端设备会将请求报文上送给DHCP服务器处理。对端设备通过peer-link链路感知到本端M-LAG口状态为UP，则直接丢弃请求报文。

¡   如[图36](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref102722314)所示，如果本端设备M-LAG上行口故障，对端设备通过peer-link链路感知到本端设备上行M-LAG口DOWN，则由对端设备将请求报文上送给DHCP服务器。

(4)   DHCP服务器收到请求报文处理后后，发送回应报文：

¡   如果是本端设备收到回应报文，查找MAC地址转发表项后发现上线口为M-LAG口，则直接转发给DHCP客户端，不再同步给对端设备，同时在本端生成用户的DHCP Snooping绑定表项，并通过peer-link链路实时备份到对端设备。

¡   如果是对端设备收到回应报文，会通过peer-link链路将回应报文同步给本端设备。对端设备查找MAC地址转发表项后发现上线口为peer-link接口，收包口是M-LAG口，直接丢弃此报文，由本端设备处理回应报文并转发给DHCP客户端。同样，本端会生成用户的DHCP Snooping绑定表项，并通过peer-link链路实时备份到对端设备。

### 6.3.2 M-LAG设备下行口单边聚合场景

图37 M-LAG设备下行口单边聚合场景

![img](https://resource.h3c.com/cn/202312/29/20231229_10257917_x_Img_x_png_41_2004108_30005_0.png)

 

如[图37](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref102057013)所示，M-LAG设备下行口单边聚合与双边聚合流量转发的主要差异在于：

·   双边聚合场景下，M-LAG设备的上行口均为M-LAG口；下行口单边聚合场景下，M-LAG设备的上行口均为普通口。

·   双边聚合时两端M-LAG口均可以同时处于UP状态，而上行口非聚合情况下，由于生成树协议作用，为了避免回环，会选择阻塞一端的上行口。

·   M-LAG设备收到回应报文后，不是通过peer-link链路将回应报文转发给对端，而是通过DHCP Snooping模块转发给对端。

对于流量转发：

·   如果生成树协议选择阻塞对端设备上行口，则流量转发情况同[6.3.1 图35](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref102722308)。

·   如果生成树协议选择阻塞本端设备上行口，则流量转发路线同[6.3.1 图36](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref102722314)。不同的是，此时收包口为普通口，对端设备收到回应报文后，不会直接丢弃报文，会处理回应报文，但由于上线口为peer-link口，仍无法将报文转发给DHCP客户端，同样由本端设备处理同步过来的回应报文并转发给DHCP客户端。

### 6.3.3 M-LAG设备上行口单边聚合场景

图38 M-LAG设备上行口单边聚合场景

![img](https://resource.h3c.com/cn/202312/29/20231229_10257918_x_Img_x_png_42_2004108_30005_0.png)

 

如[图38](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref102722351)，M-LAG设备上行口单边聚合与双边聚合的主要差异在于：

·   双边聚合场景下，M-LAG设备上行口均为M-LAG口；上行口单边聚合场景下，M-LAG设备的下行口均为普通口。

·   上行口单边聚合场景下，本端设备收到DHCP客户端的请求报文后，生成的MAC地址临时表项中用户的上线接口为普通口。

·   双边聚合时下行口均为M-LAG口，DHCP客户端的请求报文随机发送。而下行口非聚合情况下，由于生成树协议作用，所有DHCP客户端的请求报文只会发送给一端设备。

·   M-LAG设备收到请求报文后，不是通过peer-link链路将请求报文转发给对端，而是由DHCP Snooping模块转发给对端。

上行口单边聚合流量转发过程同双边聚合场景。

# 7 安全机制支持M-LAG

## 7.1 功能简介

设备正常运行时，用户可通过M-LAG接口发起认证。对于同一用户，认证、计费动作只在其中一台M-LAG设备执行，授权动作在两台M-LAG设备都会执行。M-LAG接口上授权成功的用户，可以通过任意M-LAG设备上的M-LAG接口访问网络资源。当其中一台M-LAG设备发生故障，原来在该设备进行认证、计费的用户将在另一台M-LAG设备上接替运行，继续与服务器交互计费报文等信息，保持在线状态，可以继续访问网络资源。因此，M-LAG场景下可以实现端口安全、Portal业务的设备级负载分担和冗余备份。

本文提到的“端口安全用户”是802.1X用户、MAC地址认证用户、Web认证用户、静态用户的统称。

## 7.2 工作机制

### 7.2.1 端口安全支持M-LAG

#### 1. 典型组网

有线802.1X用户、MAC地址认证用户、Web认证用户、静态用户支持M-LAG的典型组网如下所示。

图39 端口安全支持M-LAG组网示意图

 ![img](https://resource.h3c.com/cn/202312/29/20231229_10257919_x_Img_x_png_43_2004108_30005_0.png)

 

#### 2. 配置一致性检查

M-LAG系统会对端口安全业务进行Type 2类型的配置一致性检查：

·   如果配置一致性检查不通过，则丢弃触发认证的用户报文。

·   如果端口安全的配置从一致改变为不一致，则已经在线用户保持在线，新用户不允许上线。

·   如果peer-link链路故障恢复，M-LAG系统发现端口安全的配置不一致，则会强制已在线用户下线。

·   允许M-LAG接口单边接入的情况下，不会对该M-LAG接口的端口安全业务进行配置一致性检查。当从M-LAG接口单边接入变为两台M-LAG设备上的M-LAG接口都正常工作时，M-LAG系统发现端口安全的配置不一致，会强制之前单边接入的M-LAG接口上的已在线用户下线。

![说明](https://resource.h3c.com/cn/202312/29/20231229_10257920_x_Img_x_png_44_2004108_30005_0.png)

M-LAG接口单边接入是指，仅当前设备上配置了M-LAG接口，对端未配置M-LAG接口。

 

#### 3. 用户报文的上送与分发

用户发送的报文，经由接入设备转发时，将根据接入设备的聚合口上配置的负载分担模式决定最终转发到哪一台M-LAG设备的M-LAG接口上进行处理。

M-LAG设备收到用户的未知源MAC报文和802.1X EAPOL协议报文后，在本地创建用户表项，并根据端口安全模块配置的M-LAG接口上用户认证的负载分担模式，决定报文是直接在本设备处理，还是通知对端M-LAG设备处理。

·   集中式处理模式下：

¡   如果主设备收到用户报文，那么就在主设备上直接处理。

¡   如果备设备收到用户报文，先进行必要的报文解析，然后通知主设备进行后续处理，并由主设备主动与AAA服务器、客户端进行认证相关报文的交互。

该模式下，配置较为简单，RADIUS服务器上仅需管理一个接入设备IP，两台M-LAG设备上仅需配置一个相同的RADIUS报文源IP地址，但用户报文的分发效率较低，适用于接入用户量较小的场景。

·   分布式处理模式下：

¡   本地模式：本端M-LAG接口上送的用户报文就在本端M-LAG设备处理。

¡   奇偶模式：当主机收到用户报文时，解析报文中的用户源MAC，根据端口安全配置决定，奇MAC在一台M-LAG设备上处理，偶MAC在另外一台M-LAG设备上处理。如果需要对端处理，就透传到对端处理。

该模式下，用户报文的分发效率较高，但是RADIUS服务器上需管理两个接入设备IP，两台M-LAG设备上需同时配置本地设备以及对端设备使用的RADIUS报文源IP地址，适用于集中上线用户量较大的场景。其中，本地模式的分发效率最高，奇偶模式次之。

![说明](https://resource.h3c.com/cn/202312/29/20231229_10257921_x_Img_x_png_45_2004108_30005_0.png)

当允许M-LAG接口单边接入时：

·   集中式处理模式下，M-LAG接口会将用户的认证报文丢弃。

·   分布式处理模式下，无论配置了本地模式还是奇偶模式，均按照本地模式来处理。

如果任何一台M-LAG设备上修改了M-LAG接口上用户认证的负载分担模式，则所有M-LAG接口上的用户都会被强制下线。

peer-link接口故障时，M-LAG备设备上的所有M-LAG接口将处于MAD DOWN状态，且接口上的用户表项会被删除，此时将仅由M-LAG主设备处理用户报文。

 

#### 4. 用户认证、授权、计费

(1)   假设用户报文分发给M-LAG 1设备处理，那么M-LAG 1上该用户表项就会置为Active状态，并由M-LAG 1与RADIUS服务器交互用户的认证、授权、计费报文。

(2)   M-LAG 1上用户认证通过后，执行本地授权，同时同步包含授权信息的用户数据到对端M-LAG设备。对端M-LAG设备同步此用户数据之后，也会进行本地授权，使得用户无论是通过M-LAG 1还是通过M-LAG 2上的M-LAG接口，都可以访问授权的网络资源。

(3)   两端M-LAG设备授权成功后，M-LAG 1需要向客户端发送认证通过报文，向服务器发送计费开始报文。由于M-LAG 2上的该用户作为备份用户，不需要与服务器交互。

#### 5. 用户表项同步

用户表项的创建及实时备份过程如下：

(1)   本端用户认证成功后，本端M-LAG设备将向对端M-LAG设备实时同步用户信息（包括源MAC地址、VLAN、授权信息等）。

(2)   对端M-LAG设备根据同步信息建立用户表项，下发授权信息。

![说明](https://resource.h3c.com/cn/202312/29/20231229_10257922_x_Img_x_png_46_2004108_30005_0.png)

对于Web认证，两台设备上都要下发相同的重定向URL规则，以保证用户的HTTP报文从任意一台设备上来时，均可以重定向到Portal Web服务器。

 

用户表项的删除过程如下：

(1)   本端用户下线时，本端M-LAG设备通知对端M-LAG设备同步对用户进行下线处理，包括删除用户表项、取消用户授权、统计最终流量，并随此下线通知消息交互最终的用户流量。

(2)   由用户处于Active状态的M-LAG设备向RADIUS服务器发送计费停止报文，报文中携带的用户流量数据为两台M-LAG设备上叠加的最终用户流量数据。

(3)   对于802.1X用户，用户状态为Active的M-LAG设备需要通知802.1X客户端下线。

![说明](https://resource.h3c.com/cn/202312/29/20231229_10257923_x_Img_x_png_47_2004108_30005_0.png)

两端M-LAG设备上均开启了相应认证类型用户的下线检测功能的情况下，当两端M-LAG设备均未检测到用户流量时，才会触发用户下线，并删除用户表项。

 

当peer-link链路UP、端口安全进程重启或者单台M-LAG主备倒换时，两台M-LAG设备将会互相批量同步自身的用户数据，收到对端数据后都以激活状态的用户数据为准保存用户表项。

#### 6. 流量统计及流量数据同步

由于两台M-LAG设备上都存在相同的用户表项，而且同一个用户的流量可能分布在两台设备上，所以同一个用户在两台设备上的流量统计信息需要互相同步：

·   两台M-LAG设备都会在用户授权成功后，开启统计流量功能，并将用户的流量统计值周期性（缺省60秒）地发往对端，并在收到对端的数据后叠加出用户的总流量。

·   如果当前M-LAG设备上的用户处于Active状态，则由该M-LAG设备使用叠加出的总流量，向RADIUS服务器发送计费更新报文，并在下线时发送计费停止报文。

#### 7. 端口迁移

端口安全支持如下情况下，两台M-LAG设备之间或者单台M-LAG设备上发生的端口间用户迁移：

·   M-LAG接口间发生的用户迁移。

·   M-LAG口与非M-LAG口之间的用户迁移。

·   非M-LAG口之间的用户迁移。

![说明](https://resource.h3c.com/cn/202312/29/20231229_10257924_x_Img_x_png_48_2004108_30005_0.png)

如果需要两台M-LAG设备上的非M-LAG接口之间进行用户迁移，需要在两台M-LAG设备均配置允许同步的远端MAC表项覆盖本端的原MAC表项功能。

 

#### 8. 用户状态切换

表5 用户状态切换

| 系统状态          | 用户认证的负载分担模式                                       | 用户状态                                                     |
| ----------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 系统正常运行      | 集中式处理模式                                               | ·   主设备上的用户全部为Active状态  ·   备设备上的用户全部为Inactive状态 |
| 分布式处理模式    | ·   本设备上线的用户为Active状态  ·   对端备份过来的用户为Inactive状态 |                                                              |
| peer-link接口故障 | 集中式处理模式                                               | ·   主设备上的用户全部为Active状态  ·   备设备上的用户全部为Inactive状态 |
| 分布式处理模式    | ·   主设备上的用户全部为Active状态  ·   备设备上的用户表项被删除 |                                                              |

 

### 7.2.2 Portal支持M-LAG功能

#### 1. 典型组网

在该组网中，若Portal用户在本端M-LAG设备上通过认证，本端M-LAG设备会将用户数据同步发送到对端M-LAG设备进行备份。当一端M-LAG设备发生故障时，对端M-LAG设备可以使用备份的用户数据接替处理业务，从而保证用户业务的正常运行。

图40 Portal支持M-LAG功能组网图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257925_x_Img_x_png_49_2004108_30005_0.png)

 

#### 2. 配置一致性检查

Portal业务启动后，会对M-LAG接口所属的相同VLAN接口上的Portal配置进行一致性检查：

·   如果配置一致性检查不通过，则丢弃触发认证的用户报文。

·   如果Portal的配置从一致转变为不一致，则已经在线用户保持在线，新用户不允许上线。

·   如果peer-link链路故障恢复后，M-LAG系统发现Portal配置不一致，则已经在线用户保持在线，新用户不允许上线。

![说明](https://resource.h3c.com/cn/202312/29/20231229_10257927_x_Img_x_png_50_2004108_30005_0.png)

在单归接入的设备上不允许Portal用户上线。

 

#### 3. 用户报文的上送与分发

用户发送的报文，经由接入设备转发时，将根据接入设备的聚合口上配置的负载分担模式决定最终转发到哪一台M-LAG设备的M-LAG接口上进行处理。

#### 4. HTTP重定向报文的处理

M-LAG设备按照如下原则对用户的HTTP/HTTPS报文进行重定向处理：

(1)   如果主机或者备机收到首个HTTP/HTTPS报文，则记录一下报文的五元组信息。

(2)   下一个HTTP/HTTPS报文来到主机或者备机的时候，则检查本机是否有首个HTTP/HTTPS报文的记录。如果有，就在本端进行重定向处理；如果没有，就丢弃该HTTP/HTTPS报文。如果收到了非分片报文，或者最后一个HTTP分片报文，则也会尝试进行重定向处理。

![说明](https://resource.h3c.com/cn/202312/29/20231229_10257928_x_Img_x_png_51_2004108_30005_0.png)

如果用户的同一条HTTP/HTTPS报文流（五元组一致）被上送到不同的M-LAG设备上，那么该用户的HTTP重定向处理可能会失败。

 

#### 5. Portal协议报文的处理

M-LAG设备完成用户HTTP报文的重定向处理后，由Portal服务器向M-LAG设备发起认证请求。

·   集中式处理模式下：

¡   如果主设备收到Portal协议报文，那么就在主设备上直接处理，并创建用户表项。

¡   如果备设备收到Portal协议报文，先进行报文的必要解析，然后将报文透传给主设备进行后续的Portal业务处理，并由主设备上回应Portal服务器。

该模式下，配置较为简单，RADIUS服务器上仅需管理一个接入设备IP，两台M-LAG设备上仅需配置一个相同的RADIUS报文源IP地址，但用户报文的分发效率较低，适用于接入用户量较小的场景。

·   分布式处理模式下：

¡   M-LAG设备会按照Portal协议报中携带的用户IP地址信息做负载分担。

¡   当M-LAG设备收到一个Portal协议报文时，解析报文中的用户源IP，根据设备上的Portal配置决定，奇IP在一台M-LAG设备上处理，偶IP在另外一台M-LAG设备上处理。如果需要对端处理，就透传到对端进行Portal业务处理，并由对端设备回应Portal服务器，否则在本端进行Portal业务处理，并创建用户表项。

该模式下，用户报文的分发效率较高，但是RADIUS服务器上需管理两个接入设备IP，两台M-LAG设备上需同时配置本地设备以及对端设备使用的RADIUS报文源IP地址，适用于集中上线用户量较大的场景。

#### 6. 用户认证、授权、计费

(1)   假设用户的Portal协议报文由M-LAG 1设备处理，那么就由M-LAG 1与RADIUS服务器交互用户的认证、授权、计费报文。

(2)   M-LAG 1上的用户认证通过后，该用户表项就会置为激活状态，M-LAG 1将向Portal服务器发送认证通过报文。

(3)   M-LAG 1使用RADIUS服务器下发的授权信息在本地对用户进行授权，并同时将包含授权信息的用户数据同步给对端M-LAG设备。对端M-LAG设备同步此用户数据之后，也会进行本地授权，使得用户无论是通过M-LAG 1还是通过M-LAG 2上的M-LAG接口，都可以访问授权的网络资源。

(4)   两端M-LAG设备授权成功后，M-LAG 1向RADIUS服务器发送计费开始报文。由于M-LAG 2上的该用户只作为备份用户，不需要与RADIUS服务器交互。

#### 7. 用户表项同步

用户表项的创建及实时备份过程如下：

(1)   本端用户认证成功后，本端M-LAG设备将向对端M-LAG设备实时同步用户信息（包括用户IP地址、源MAC地址、VLAN、授权信息等）。

(2)   对端M-LAG根据同步信息建立用户表项，下发授权信息。

用户表项的删除过程如下：

(1)   如果用户主动下线，Portal服务器会通知M-LAG设备对用户进行下线处理。M-LAG系统将按照配置的Portal业务的M-LAG处理模式，对Portal服务器的下线请求报文进行分发。最终，由用户状态为Active的M-LAG设备对用户进行下线处理，并通知对端M-LAG设备同步处理，包括删除用户表项、取消用户授权、统计最终流量。

(2)   如果在M-LAG设备上强制用户下线，则由用户状态为Active的M-LAG设备向Portal服务器发送下线通知报文，并通知对端M-LAG设备同步处理，包括删除用户表项、取消用户授权、统计最终流量。

(3)   由用户处于Active状态的M-LAG设备向RADIUS服务器发送计费停止报文，报文中携带的用户流量数据为两台M-LAG设备上叠加的最终用户流量数据。

当peer-link链路UP、端口安全进程重启、单台M-LAG主备倒换或者Portal配置从不一致转变为一致时，两台M-LAG设备将会互相批量同步自身的用户数据，收到对端数据后都以激活状态的用户数据为准保存用户表项。

#### 8. 流量统计及流量数据数据同步

由于两台M-LAG设备上都下发了相同的Portal规则，而且同一个用户的流量可能分布在两台设备上，所以同一个用户在两台设备上的流量统计信息需要互相同步（包括ITA用户的流量）：

·   当M-LAG设备收到的Portal用户流量数值与上次备份的流量数值差值达到设定的阈值，或者Portal用户流量数值达到指定的流量备份周期，将触发本端设备将用户流量备份给对端M-LAG设备。

·   如果当前M-LAG设备上的用户处于Active状态，则由该M-LAG设备使用叠加出的总流量，向RADIUS服务器发送计费更新报文，并在下线时发送计费停止报文。

#### 9. 用户状态切换

表6 用户状态切换

| 系统状态          | 用户认证的负载分担模式                                       | 用户状态                                                     |
| ----------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 系统正常运行      | 集中式处理模式                                               | ·   主设备上的用户全部为Active状态  ·   备设备上的用户全部为Inactive状态 |
| 分布式处理模式    | ·   本设备上线的用户为Active状态  ·   对端备份过来的用户为Inactive状态 |                                                              |
| peer-link接口故障 | 集中式处理模式                                               | ·   主设备上的用户全部为Active状态  ·   备设备上的用户全部为Inactive状态 |
| 分布式处理模式    | ·   主设备上的用户全部为Active状态  ·   备设备上的用户表项保持现状 |                                                              |

 

### 7.2.3 RADIUS协议报文处理

认证服务器需要根据NAS-IP识别用户身份，为保证交互不受影响，处理备份用户业务时，需要使用对端M-LAG的IP地址作为源IP地址。在两台M-LAG设备上分别部署M-LAG虚拟IP地址后，设备正常工作时，使用本端M-LAG虚拟IP地址与RADIUS服务器交互本地用户信息，一台设备故障时，另一台设备就要使用对端的M-LAG虚拟IP地址和RADIUS服务器交互对端备份用户信息。

#### 1. 认证报文、授权报文、计费报文（设备作为RADIUS客户端）

总处理原则：用户上线后，与RADIUS服务器交互时采用的RADIUS源IP地址保持不变。

·   集中处理模式下，需要在两台M-LAG设备上均配置相同的Local源IP地址，所有的认证、授权、计费报文都在主设备上进行处理。该源IP地址必须为同一个M-LAG虚拟IP地址。

¡   主设备正常的情况下，由主设备使用Local源IP地址与服务器交互RADIUS协议报文。

¡   主设备发生故障时，由备设备使用Local源IP地址与服务器交互RADIUS协议报文。

·   分布处理模式下，需要在两台M-LAG设备上均配置一个Local源IP地址和一个Peer源IP地址。即，两台设备上分别配置两个不同的M-LAG虚拟IP地址，且这两对地址彼此相反。

假设，M-LAG 1设备上的Local源IP地址为A、Peer源IP地址为B，M-LAG 2设备上的Local源IP地址为B、Peer源IP地址为A，则：

¡   两台M-LAG设备均正常的情况下，M-LAG 1设备使用A地址与服务器交互RADIUS协议报文，M-LAG 2设备使用B地址与服务器交互RADIUS协议报文。

¡   当一台M-LAG设备发生故障时，原故障设备上处理的用户在另外一台M-LAG设备上使用配置的Peer源IP地址发送RADIUS报文。

![说明](https://resource.h3c.com/cn/202312/29/20231229_10257929_x_Img_x_png_52_2004108_30005_0.png)

M-LAG组网环境中，M-LAG设备上指定的发送RADIUS报文使用的源IP地址必须为M-LAG虚拟IP地址。两台M-LAG设备的Loopback接口配置不同的虚拟IP地址，且均配置为active状态。

 

#### 2. COA报文（设备作为RADIUS服务端）

对于端口安全业务，COA报文处理机制如下：

·   如果主机收到COA协议报文，那么就在主机上直接处理。

·   如果备机收到COA协议报文，那么就在备机上直接处理。

对于Portal业务，COA报文处理机制如下：

·   如果收到COA协议报文的M-LAG设备上该用户状态为Active，那么就在本机上直接处理。

·   如果收到COA协议报文的M-LAG设备上该用户状态为Inactive，那么就透传到对端处理。

# 8 二层组播支持M-LAG

## 8.1 功能简介

二层组播利用M-LAG功能将两台物理设备连接起来形成M-LAG系统，该M-LAG系统作为一台虚拟二层组播设备使用。使用该虚拟设备连接组播源或组播接收者，可避免单点故障对组播网络造成影响，提高组播网络可靠性。

## 8.2 工作机制

![说明](https://resource.h3c.com/cn/202312/29/20231229_10257930_x_Img_x_png_53_2004108_30005_0.png)

二层组播支持M-LAG组网中，IPP口作为静态路由器端口，承载所有的组播流量。

 

### 8.2.1 组播源连接M-LAG系统

#### 1. 二层组播转发表项建立过程

如[图41](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref104796638)所示，作为M-LAG设备的Device A和Device B通过peer-link链路连接，Device C与组播源相连。由于M-LAG系统上行接入二层网络，因此需要配置STP协议，选择性地阻塞某些端口来消除二层环路，确保组播源发送到M-LAG系统的组播数据流量，只能被Device A或Device B的其中一台转发给组播接收者。此处，以阻断Device B与二层网络相连的链路为例。

图41 二层组播转发表项建立过程（组播源连接M-LAG系统）

![img](https://resource.h3c.com/cn/202312/29/20231229_10257931_x_Img_x_png_54_2004108_30005_0.png) 

 

组播源连接M-LAG时，二层组播表项的建立过程如下：

(1)   Device C发送的IGMP/MLD查询报文，通过Device C的聚合口进行负载分担，分别到达Device A和Device B的M-LAG接口。

(2)   Device A和Device B分别将各自的M-LAG接口添加到路由器端口列表中，并通过peer-link链路互相发送给对端设备。Device A和Device B从peer-link接口收到的对端发送的查询报文，不会再向各自的M-LAG接口转发。

(3)   Device A收到来自下游接收者的IGMP/MLD Report报文后，从Report报文中解析出主机要加入的组播组地址G，生成二层组播转发表项（*，G），将接收端口作为成员端口添加到出端口列表。同时，将IGMP/MLD Report报文通过peer-link链路发送给Device B。

(4)   Device B收到Report报文后，同样生成二层组播转发表项（*，G），同时将peer-link接口作为成员端口添加到出端口列表中。但是，Device B并不会将该报文从自己的路由器端口（M-LAG接口）转发出去。

通过上述机制使得Device A和Device B上生成相同的二层组播转发表项，形成设备级别的备份，当一台成员设备发生故障（设备故障、上下行链路故障等）时，组播流量可以由另一台成员设备进行转发，从而避免组播流量转发中断。

#### 2. 正常情况下组播流量转发过程

M-LAG设备正常工作时，组播流量转发过程如[图42](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref104796639)所示。

(1)   组播源发送的组播流量，通过负载分担方式到达Device A和Device B。

(2)   Device A和Device B，通过peer-link链路互相发送各自接收到的组播数据流量给对方。这样，保证Device A和Device B上都能收到完整的组播数据流量。

(3)   Device A将完整的组播数据流量发送给下游接收者。

图42 组播流量转发过程（组播源连接M-LAG系统）

![img](https://resource.h3c.com/cn/202312/29/20231229_10257932_x_Img_x_png_55_2004108_30005_0.png)

 

### 8.2.2 组播接收者连接M-LAG系统

如[图43](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref104796640)所示，作为M-LAG设备的Device A和Device B通过peer-link链路连接，Device C与组播接收者相连。由于M-LAG系统上行接入二层网络，因此需要配置STP协议，选择性地阻塞某些端口来消除二层环路，确保组播源发送到M-LAG系统的组播数据流量，只能被Device A或Device B的其中一台转发给组播接收者。此处，以阻断Device B与二层网络相连的链路为例。

图43 二层组播转发表项建立过程（组播接收者连接M-LAG系统）

![img](https://resource.h3c.com/cn/202312/29/20231229_10257933_x_Img_x_png_56_2004108_30005_0.png)

 

组播接收者连接M-LAG时，二层组播表项的建立过程如下：

(1)   Device A收到上游二层网络发送的IGMP/MLD查询报文后，将接收报文的端口添加到动态路由器端口列表中，并通过peer-link链路发送给Device B。

(2)   Device B收到查询报文后，将peer-link接口添加到路由器端口列表中。

(3)   Device A或者Device B中的任意一台设备，收到下游设备Device C发送的IGMP/MLD Report报文后，从Report报文中解析出主机要加入的组播组地址G1和G2，分别在各自设备上生成二层组播转发表项（*，G1）和（*，G2），出端口分别为各自的M-LAG接口。

![说明](https://resource.h3c.com/cn/202312/29/20231229_10257934_x_Img_x_png_57_2004108_30005_0.png)

假设Device A收到的为加入组播组G1的Report报文，Device B收到的为加入组播组G2的Report报文。

 

(4)   Device A和Device B分别将Report报文通过peer-link链路透传给对端设备。以Device A为例，Device A收到Device B发送的Report报文后，在生成二层组播转发表项（*，G2），同时将Device A上的M-LAG接口添加到出端口列表中。Device B的处理过程类似，将在本地生成（*，G1）的二层组播转发表项。

通过上述机制使得Device A和Device B上的生成相同的二层组播转发表项，形成设备级别的备份，当一台成员设备发生故障（设备故障、上下行链路故障等）时，组播流量可以由另一台成员设备进行转发，从而避免组播流量转发中断。

#### 2. 正常情况下组播流量转发过程

M-LAG设备正常工作时，组播流量转发过程如[图44](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref104796641)所示。

(1)   组播源发送的组播流量，通过二层网络到达Device A。

(2)   Device A通过peer-link链路将收到的组播数据流量发送给Device B。此时，只有Device A会向下游Device C转发组播流量，而Device B上虽然生成了二层组播转发表项，但不会向下游Device C转发组播流量。

(3)   Device C收到后，将流量转发给接收者。

图44 组播流量转发过程（组播接收者连接M-LAG系统）

![img](https://resource.h3c.com/cn/202312/29/20231229_10257935_x_Img_x_png_58_2004108_30005_0.png)

 

# 9 三层组播支持M-LAG

## 9.1 功能简介

三层组播利用M-LAG功能将两台物理设备连接起来虚拟成一台设备，使用该虚拟设备连接组播源或组播接收者，可避免单点故障对组播网络造成影响，提高组播网络可靠性。

## 9.2 工作机制

![说明](https://resource.h3c.com/cn/202312/29/20231229_10257936_x_Img_x_png_59_2004108_30005_0.png)

三层组播支持M-LAG场景中，需要在M-LAG设备之间配置一条独立的三层链路建立PIM邻居，并且作为M-LAG系统的Keepalive链路使用。

 

### 9.2.1 组播源连接M-LAG系统

#### 1. 三层组播转发表项建立过程

如[图45](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref104796642)所示，作为M-LAG设备的Device A和Device B通过peer-link链路连接，Device C与组播源相连。其中，peer-link链路与M-LAG接口属于同一个VLAN。接收者位于三层网络侧，会在三层网络上选择一条到组播源的最优路径，此处以选择上游设备Device A为例。

图45 三层组播转发表项建立过程（组播源连接M-LAG系统）

![img](https://resource.h3c.com/cn/202312/29/20231229_10257938_x_Img_x_png_60_2004108_30005_0.png)

 

组播源连接M-LAG时，三层组播表项的建立过程如下：

(1)   Device A收到PIM/IPv6 PIM加入报文后，不会将报文通过peer-link链路同步给Device B，而是在获取了组播组的接收者信息后，生成了（*，G）表项。

(2)   组播源发送给接收者的组播数据报文，会通过负载分担的方式分别到达Device A和Device B的M-LAG接口。Device A和Device B会通过peer-link链路将各自接收到的报文发送给对端，从而使两台设备上都能收到完整的组播流量。Device A上根据收到的组播数据流量建立（S，G）表项。

#### 2. 正常情况下组播流量转发过程

M-LAG设备正常工作时，组播流量转发过程如[图46](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref104796643)所示。

(1)   组播源发送的组播流量，通过负载分担方式到达Device A和Device B。

(2)   Device A和Device B，通过peer-link链路互相发送接收到的组播数据流量。这样，保证Device A和Device B上都能收到完整的组播数据流量。

(3)   Device A将收到的完整的组播数据流量发送给下游接收者。

图46 组播流量转发过程（组播源连接M-LAG系统）

![img](https://resource.h3c.com/cn/202312/29/20231229_10257939_x_Img_x_png_61_2004108_30005_0.png)

 

### 9.2.2 组播接收者连接M-LAG系统

如[图47](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref104796644)所示，作为M-LAG设备的Device A和Device B通过peer-link链路连接，Device C与组播接收者相连。Device A和Device B上与Device C相连的M-LAG接口上，均需要配置PIM/IPv6 PIM消极模式，保证Device A和Device B均能收到组播源发送的所有的组播数据流量。

图47 三层组播转发表项建立过程（组播接收者连接M-LAG系统）

![img](https://resource.h3c.com/cn/202312/29/20231229_10257940_x_Img_x_png_62_2004108_30005_0.png)

 

(1)   Device A或者Device B中的任意一台设备，收到下游设备Device C发送的IGMP/MLD Report报文。Device A或者Device B从Report报文中解析出主机要加入的组播组地址，分别生成（*，G1）和（*，G2）三层组播转发表项，将M-LAG接口添加到出端口列表中。

(2)   Device A和Device B分别将Report报文通过peer-link链路透传给对端设备。以Device A为例，Device A收到Device B发送的Report报文后，在生成三层组播转发表项（*，G2），同时将Device A上的M-LAG接口添加到出端口列表中。Device B的处理过程类似，将在本地生成（*，G1）的组播转发表项。

(3)   Device A和Device B上的组播组信息将保持同步，生成相同的（*，G1）和（*，G2）组播转发表项。

(4)   Device A和Device B根据网络中配置PIM模式工作机制，最终在设备上生成相同的PIM路由表项。此处，以网络配置的PIM模式为PIM-SM示例。

通过上述机制使得Device A和Device B上生成的PIM路由表项保持一致，形成设备级别的备份，当一台成员设备发生故障（设备故障、上下行链路故障等）时，组播流量可以由另一台成员设备进行转发，从而避免组播流量转发中断。

#### 2. 正常情况下组播流量转发过程

M-LAG设备正常工作时，组播流量转发过程如[图48](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref104796645)所示。

(1)   组播源发送的组播流量，通过三层网络分别到达Device A和Device B。

(2)   Device A和Device B向下游转发组播流量时，采用奇偶原则对组播流量进行负载分担。M-LAG系统编号为奇数的成员设备转发组播组地址为奇数的流量，M-LAG系统编号为偶数的成员设备转发组播组地址为偶数的流量。

图48 组播流量转发过程（组播接收者连接M-LAG系统）

![img](https://resource.h3c.com/cn/202312/29/20231229_10257941_x_Img_x_png_63_2004108_30005_0.png)

 

# 10 EVPN VXLAN支持M-LAG

## 10.1 功能简介

EVPN（Ethernet Virtual Private Network，以太网虚拟专用网络） VXLAN采用M-LAG技术将两台物理设备连接起来虚拟成一台设备，使用该虚拟设备作为VTEP（既可以是仅用于二层转发的VTEP，也可以是EVPN网关），可以避免VTEP单点故障对网络造成影响，从而提高EVPN网络的可靠性。

![提示](https://resource.h3c.com/cn/202312/29/20231229_10257942_x_Img_x_png_64_2004108_30005_0.png)

目前，本功能仅支持站点网络和Underlay网络同为IPv4网络，或站点网络和Underlay网络同为IPv6网络。

 

## 10.2 典型组网

EVPN VXLAN支持M-LAG的典型组网如[图49](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref101341317)所示。在该组网中：

·   两台VTEP组成M-LAG系统，它们具有相同的虚拟VTEP地址，对外表现为一台虚拟VTEP设备。

·   M-LAG设备间的peer-link连接既可以是以太网聚合链路，也可以是VXLAN隧道。以太网链路作为peer-link连接的组网，称为有peer link组网；VXLAN隧道作为peer-link连接的组网，称为无peer link组网，作为peer-link的VXLAN隧道自动与设备上的所有VXLAN关联。

·   Server 2和Server 3通过M-LAG方式接入VTEP。

·   Server 1和Server 4单挂接入VTEP。

图49 EVPN VXLAN支持M-LAG典型组网图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257943_x_Img_x_png_65_2004108_30005_0.png)

 

 

## 10.3 同步MAC地址和ARP/ND信息

作为M-LAG设备的两台VTEP通过peer-link连接，在peer-link上同步MAC地址、ARP/ND表项和ARP/ND泛洪抑制表项等，以确保两台VTEP上的MAC地址和ARP/ND信息保持一致。当一台VTEP故障时，另一台VTEP可以快速接替其工作，转发流量。

M-LAG接口的表项通过peer-link同步到对端M-LAG设备上后，对端M-LAG设备将该表项添加到本地对应的M-LAG接口；单挂接口的表项通过peer-link同步到对端M-LAG设备上后，对端M-LAG设备将该表项添加到peer-link接口。

## 10.4 VXLAN隧道建立

在EVPN VXLAN组网中，VTEP之间可以根据BGP EVPN的IMET（Inclusive Multicast Ethernet Tag Route，包含性组播以太网标签路由）路由、MAC/IP发布路由和IP前缀路由建立VXLAN隧道。

## 10.5 备份用户侧链路

在用户侧，两台VTEP均通过以太网链路接入同一台虚拟机，跨设备在两条链路间建立二层聚合接口，将该聚合接口配置为AC（在聚合接口上创建以太网服务实例、配置报文匹配规则并关联以太网服务实例与VSI），从而避免单条以太网链路故障导致虚拟机无法访问网络。

### 10.5.1 peer-link为以太网聚合链路时的用户侧链路备份机制

peer-link为以太网聚合链路时，VTEP通过在peer-link上自动创建AC或自动创建VXLAN隧道来实现用户侧链路备份。

·   在peer-link上自动创建AC

在peer-link上，M-LAG设备会根据用户侧AC或用户所属的VXLAN ID自动创建AC。

通过自动创建的AC实现用户侧链路备份的过程为：当一台VTEP上的AC故障后，从VXLAN隧道上接收到的、发送给该AC的报文将通过peer-link转发到另一台VTEP，该VTEP根据peer-link上配置的AC判断报文所属VSI，并转发该报文，从而保证转发不中断。

·   自动创建VXLAN隧道

作为M-LAG设备的两台VTEP之间自动建立VXLAN隧道，并将该VXLAN隧道自动与所有VXLAN关联。

通过自动创建的VXLAN隧道实现用户侧链路备份的过程为：如果一台VTEP上的AC故障，则该VTEP从VXLAN隧道上接收到远端VTEP（非M-LAG设备）发送给故障AC的报文后，为报文添加VXLAN封装，封装的VXLAN ID为故障AC所属VSI对应的VXLAN ID，并通过自动创建的VXLAN隧道将其转发到另一台VTEP（M-LAG设备）。该VTEP根据VXLAN ID判断报文所属的VSI，并转发该报文。

### 10.5.2 peer-link为VXLAN隧道时的用户侧链路备份机制

peer-link为VXLAN隧道时，用户侧链路备份机制为：如果一台VTEP上的AC故障，则该VTEP从VXLAN隧道上接收到发送给故障AC的报文后，为报文添加VXLAN封装，封装的VXLAN ID为故障AC所属VSI对应的VXLAN ID，并通过作为peer-link的VXLAN隧道将其转发到另一台VTEP。该VTEP根据VXLAN ID判断报文所属的VSI，并转发该报文。

## 10.6 流量转发

### 10.6.1 M-LAG接口的单播流量转发

#### 1. M-LAG接口的上行单播流量

如[图50](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref103590759)所示，接入服务器（Server 2）通过聚合接口采用M-LAG方式接入VTEP时，利用聚合接口的负载分担功能，接入服务器将发送到外网的上行单播流量负载分担到多台M-LAG设备（VTEP 1和VTEP 2）。M-LAG设备接收到单播流量后，按照本地转发优先原则，通过本地的VXLAN隧道将单播流量转发给远端VTEP。

图50 M-LAG接口的上行单播流量转发

![img](https://resource.h3c.com/cn/202312/29/20231229_10257944_x_Img_x_png_66_2004108_30005_0.png)

 

#### 2. M-LAG接口的下行单播流量

如[图51](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref101364613)所示，接入服务器（Server 2）通过聚合接口采用M-LAG方式接入VTEP。外网向Server 2发送单播流量时，该流量通过VXLAN隧道转发给M-LAG设备（VTEP 1和VTEP 2）。Underlay网络中，M-LAG设备均发布到达虚拟VTEP地址的路由，以便在VTEP 3上形成等价路由。从而，使得外网发送给Server 2的单播流量负载分担到多台M-LAG设备。

M-LAG设备接收到下行的单播流量后，按照本地转发优先原则，通过本地AC将单播流量转发给接入服务器（Server 2）。

图51 M-LAG接口的下行单播流量转发

![img](https://resource.h3c.com/cn/202312/29/20231229_10257945_x_Img_x_png_67_2004108_30005_0.png)

 

#### 3. M-LAG接口发往单挂接口的单播流量

如[图52](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref101365406)所示，接入服务器（Server 2）通过聚合接口采用M-LAG方式接入VTEP时，利用聚合接口的负载分担功能，Server 2将发往单挂接口的单播流量负载分担到多台M-LAG设备（VTEP 1和VTEP 2）。单挂接口所在的M-LAG设备（VTEP 1）通过查找本地表项，将单播流量转发到单挂接口；其他M-LAG设备（VTEP 2）接收到单播流量后，通过peer-link将流量转发给VTEP 1，再由VTEP 1转发到单挂接口。

图52 M-LAG接口发往单挂接口的单播流量转发

![img](https://resource.h3c.com/cn/202312/29/20231229_10257946_x_Img_x_png_68_2004108_30005_0.png)

 

### 10.6.2 单挂接口的单播流量转发

#### 1. 单挂接口的上行单播流量

如[图53](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref101366507)所示，单挂接入服务器（Server 1）发送的单播流量到达VTEP 1后，VTEP 1通过本地的VXLAN隧道将单播流量转发给远端VTEP。

图53 单挂接口的上行单播流量转发

![img](https://resource.h3c.com/cn/202312/29/20231229_10257947_x_Img_x_png_69_2004108_30005_0.png)

 

#### 2. 单挂接口的下行单播流量

如[图54](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref101366647)所示，外网向单挂接入的服务器（Server 1）发送单播流量时，该流量会通过VXLAN隧道转发给VTEP 1，VTEP 1接收到流量后，直接将其转发到单挂接口。该流量不会发送给VTEP 2，从而避免流量绕行peer-link的问题。

图54 单挂接口的下行单播流量转发

![img](https://resource.h3c.com/cn/202312/29/20231229_10257949_x_Img_x_png_70_2004108_30005_0.png)

 

#### 3. 单挂接口发往M-LAG接口的单播流量

如[图55](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref101369453)所示，单挂接入服务器（Server 1）发送给M-LAG接入服务器（Server 2）的单播流量到达VTEP 1后，VTEP 1按照本地转发优先原则，通过本地AC将单播流量转发给接入服务器（Server 2）。

图55 单挂接口发往M-LAG接口的单播流量转发

![img](https://resource.h3c.com/cn/202312/29/20231229_10257950_x_Img_x_png_71_2004108_30005_0.png)

 

#### 4. 单挂接口互通的单播流量

当互通的单挂接口连接到同一台M-LAG设备时，流量转发过程与EVPN VXLAN的流量转发过程相同。

如[图56](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref101369786)所示，当互通的单挂接口连接到不同的M-LAG设备时，通过peer-link实现单挂接口的互通：

·   peer-link为以太网聚合链路时，单挂接口互通机制为：在单挂接口上创建单挂AC后，M-LAG设备会在peer-link上自动创建对应的AC，并将其与VSI关联。当一台M-LAG设备从单挂AC上收到报文后，报文将通过peer-link转发到另一台M-LAG设备，另一台M-LAG设备根据peer-link上自动创建的AC判断报文所属VSI，并转发该报文。

·   peer-link为VXLAN隧道时，单挂接口互通机制为：当一台M-LAG设备从单挂AC上收到报文后，为报文添加VXLAN封装，封装的VXLAN ID为单挂AC所属VSI对应的VXLAN ID，并通过作为peer-link的VXLAN隧道将其转发到另一台M-LAG设备。另一台M-LAG设备根据VXLAN ID判断报文所属的VSI，并转发该报文。

图56 单挂接口互通的单播流量转发

![img](https://resource.h3c.com/cn/202312/29/20231229_10257951_x_Img_x_png_72_2004108_30005_0.png)

 

### 10.6.3 BUM流量转发

#### 1. M-LAG接口的上行BUM流量

如[图57](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref102828686)所示，接入服务器（Server 2）通过聚合接口采用M-LAG方式接入VTEP时，利用聚合接口的负载分担功能，接入服务器将发送到外网的上行BUM（Broadcast/Unknown unicast/Unknown Multicast，广播/未知单播/未知组播）流量负载分担到多台M-LAG设备（VTEP 1和VTEP 2）。M-LAG设备接收到BUM流量后，判断BUM流量所属的VSI，通过该VSI内除接收AC外的所有本地AC（包括单挂AC）、VXLAN隧道和peer-link转发该流量。M-LAG设备（即VTEP）从peer-link上接收到BUM流量后，仅将该流量转发给本地的单挂AC。

图57 M-LAG接口的上行BUM流量转发

![img](https://resource.h3c.com/cn/202312/29/20231229_10257952_x_Img_x_png_73_2004108_30005_0.png)

 

#### 2. 单挂接口的上行BUM流量

如[图58](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref102830846)所示，单挂接入服务器（Server 1）发送的BUM流量到达VTEP 1后，VTEP 1判断流量所属的VSI，通过该VSI内除接收AC外的所有本地AC、VXLAN隧道和peer-link转发该流量。VTEP 2从peer-link收到该流量后，只将其转发给本地单挂AC。

图58 单挂接口的上行BUM流量转发

![img](https://resource.h3c.com/cn/202312/29/20231229_10257953_x_Img_x_png_74_2004108_30005_0.png)

 

#### 3. 网络侧的下行BUM流量

如[图59](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref102829423)所示，接入服务器（Server 2）通过聚合接口采用M-LAG方式接入VTEP，Server 1和Server 3分别单挂接入VTEP 1和VTEP 2。外网向Server所在的内网发送BUM流量时，VTEP 3通过VXLAN隧道将流量转发给VTEP 1和VTEP 2。

M-LAG设备接收到BUM流量后，判断流量所属的VSI，并在该VSI内的所有AC（包括M-LAG接口对应的AC和单挂AC）、peer-link上转发该流量。M-LAG设备从peer-link上接收到BUM流量后，仅将该流量转发给本地的单挂AC。

图59 M-LAG接口的下行BUM流量转发

![img](https://resource.h3c.com/cn/202312/29/20231229_10257954_x_Img_x_png_75_2004108_30005_0.png)

 

## 10.7 故障处理机制

在EVPN VXLAN支持M-LAG组网中，peer-link故障、M-LAG设备故障时的故障处理机制与M-LAG组网中的故障处理机制相同，详细介绍请参见“[2.5 ](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref103588479)[M-LAG故障处理机制](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref103588479)”。本节仅介绍下行链路故障、上行链路故障、peer-link和Keepalive链路同时故障时的故障处理机制。

### 10.7.1 下行链路故障处理机制

#### 1. peer-link为以太网聚合链路

如[图60](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref511922011)所示，peer-link为以太网聚合链路的EVPN VXLAN组网中，某台M-LAG设备（VTEP 2）的下行链路故障时，上下行流量的处理方式分别为：

·   上行流量会通过未故障的链路发送给另一台M-LAG设备（VTEP 1），上行流量均通过VTEP 1转发。

·   下行流量转发过程为：

a.   由于网络侧感知不到下行链路故障，流量依然会发送给所有M-LAG设备。

b.   VTEP 2收到网络侧访问Server 2的流量后，会通过peer-link上自动创建的AC转发到VTEP 1，VTEP 1根据peer-link上自动创建的AC判断报文所属VSI，并将该报文转发给Server 2。

故障恢复后，VTEP 2上的AC up，流量正常转发。

图60 下行链路故障处理机制（peer-link为以太网聚合链路）

![img](https://resource.h3c.com/cn/202312/29/20231229_10257955_x_Img_x_png_76_2004108_30005_0.png)

 

#### 2. peer-link为VXLAN隧道

如[图61](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref508981470)所示，peer-link为VXLAN隧道的EVPN VXLAN组网中，某台M-LAG设备（VTEP 2）的下行链路故障时，上下行流量的处理方式分别为：

·   上行流量会通过未故障的链路发送给另一台M-LAG设备（VTEP 1），上行流量均通过VTEP 1转发。

·   下行流量转发过程为：

a.   由于网络侧感知不到下行链路故障，流量依然会发送给所有M-LAG设备。

b.   VTEP 2收到网络侧访问Server 2的流量后，为报文添加VXLAN封装（封装的VXLAN ID为故障AC所属VSI对应的VXLAN ID），然后通过作为peer-link的VXLAN隧道将其转发到VTEP 1。VTEP 1根据接收到的报文中携带的VXLAN ID字段判断报文所属VSI，并将该报文转发给Server 2。

故障恢复后，VTEP 2的AC up，流量正常转发。

图61 下行链路故障处理机制（peer-link为VXLAN隧道）

![img](https://resource.h3c.com/cn/202312/29/20231229_10257956_x_Img_x_png_77_2004108_30005_0.png)

 

### 10.7.2 上行链路故障处理机制

#### 1. peer-link为以太网聚合链路

peer-link为以太网聚合链路的EVPN VXLAN组网中，建议将peer-link部署为逃生链路。部署逃生链路是指允许peer-link转发三层流量，并在peer-link上运行路由协议，使得M-LAG设备可以通过peer-link与远端VTEP三层互通。在underlay网络上，peer-link所在的路径作为M-LAG设备与远端VTEP之间VXLAN隧道的备份路径。当M-LAG设备的上行链路故障，导致VXLAN隧道的underlay主路径故障时，VXLAN隧道保持up状态，通过peer-link所在的underlay备份路径转发流量。

如[图62](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref103083225)所示，部署逃生链路的方式为在peer-link上允许某个VLAN通过，在M-LAG设备上创建该VLAN对应的VLAN接口，并在VLAN接口上运行路由协议，使得该接口与远端VTEP三层互通。部署逃生链路后，VTEP 1和VTEP 3之间的VXLAN隧道在underlay网络上具有主备两条路径，经由peer-link的路径作为备份路径。推荐使用VLAN 4094来部署逃生链路。

图62 逃生链路部署示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257957_x_Img_x_png_78_2004108_30005_0.png)

 

如[图63](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref103097415)所示，当某台M-LAG设备（VTEP 2）的上行链路故障时，M-LAG接口上下行流量的处理方式分别为：

·   上行流量：接入服务器（Server 2）通过聚合接口采用M-LAG方式接入VTEP时，利用聚合接口的负载分担功能，接入服务器将发送到外网的上行单播流量负载分担到多台M-LAG设备（VTEP 1和VTEP 2）。

¡   VTEP 1接收到上行流量后，正常转发该流量。

¡   由于部署了逃生链路，上行链路故障的M-LAG设备（VTEP 2）与远端VTEP之间的VXLAN隧道仍然up。该VXLAN隧道对应的underlay路径为经由peer-link的路径。因此，VTEP 2接收到上行流量后，对其进行VXLAN封装，并通过peer-link绕行另一台M-LAG设备VTEP 1，将流量发送给远端VTEP。

·   下行流量：远端VTEP通过VXLAN隧道将下行流量发送给M-LAG设备。由于VTEP 2的上行链路故障，下行流量只会发送给VTEP 1，再由VTEP 1将流量转发给Server 2。

图63 上行链路故障处理机制（peer-link为以太网聚合链路）

![img](https://resource.h3c.com/cn/202312/29/20231229_10257958_x_Img_x_png_79_2004108_30005_0.png)

 

当某台M-LAG设备的上行链路故障时，该M-LAG设备上单挂接口的上下行流量将通过peer-link发送给另一台M-LAG设备，由另一台M-LAG设备进行转发。

#### 2. peer-link为VXLAN隧道

peer-link为VXLAN隧道的EVPN VXLAN组网中，某台M-LAG设备的上行链路故障时，作为peer-link的VXLAN隧道也会down，此时的故障处理机制为：

·   如果M-LAG设备之间没有Keepalive链路，则M-LAG系统会分裂，两台M-LAG设备均使用实际IP地址与远端VTEP建立VXLAN隧道，两台M-LAG设备均可以转发流量。

·   如果M-LAG设备之间存在Keepalive链路，则备设备上的接口会MAD down，仅主设备使用虚拟VTEP地址与远端VTEP建立VXLAN隧道，仅主设备可以转发流量。

### 10.7.3 peer-link和Keepalive链路同时故障

#### 1. peer-link为以太网聚合链路

peer-link为以太网聚合链路的EVPN VXLAN组网中，peer-link和Keepalive链路同时故障时，M-LAG系统会分裂，两台M-LAG设备均使用实际IP地址与远端VTEP建立VXLAN隧道，两台M-LAG设备均可以转发流量。

如[图64](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref103153414)所示，peer-link和Keepalive链路同时故障时，M-LAG接口的上下行流量转发方式为：Server 2根据LACP优先级选择将上行流量发送给一台M-LAG设备（如VTEP 1），下行流量也通过目的IP为实际IP地址的VXLAN隧道发送给VTEP 1。即，M-LAG接口的上下行流量均通过VTEP 1转发。

图64 peer-link和Keepalive链路同时故障（peer-link为以太网聚合链路）

![img](https://resource.h3c.com/cn/202312/29/20231229_10257960_x_Img_x_png_80_2004108_30005_0.png)

 

peer-link和Keepalive链路同时故障时，单挂接口的流量转发不受影响。

#### 2. peer-link为VXLAN隧道

peer-link为VXLAN隧道的EVPN VXLAN组网中，peer-link和Keepalive链路同时故障时的故障处理机制与peer-link为以太网聚合链路的EVPN VXLAN组网相同。

# 11 VXLAN支持M-LAG

VXLAN（Virtual eXtensible LAN，可扩展虚拟局域网络）采用M-LAG技术将两台物理设备连接起来虚拟成一台设备，使用该虚拟设备作为VTEP（既可以是仅用于二层转发的VTEP，也可以是VXLAN IP网关），可以避免VTEP单点故障对网络造成影响，从而提高VXLAN网络的可靠性。

![提示](https://resource.h3c.com/cn/202312/29/20231229_10257961_x_Img_x_png_81_2004108_30005_0.png)

·   目前，本功能仅支持站点网络和Underlay网络同为IPv4网络，或站点网络和Underlay网络同为IPv6网络。

·   集中式VXLAN IP网关保护组不支持M-LAG功能。

 

VXLAN支持M-LAG的工作机制与EVPN VXLAN支持M-LAG的工作机制基本相同，此章节不再赘述，仅介绍两种工作机制的差异点。

## 11.1 同步MAC地址和ARP/ND信息

VXLAN支持M-LAG组网中M-LAG接口和单挂接口的表项同步与EVPN VXLAN支持M-LAG组网的中表项同步工作机制相同。

对于VXLAN隧道上通过动态/静态方式学习到的MAC地址、ARP/ND表项和ARP/ND泛洪抑制表项，需要通过peer-link同步到对端M-LAG设备上，对端M-LAG设备根据同步的表项信息中的VXLAN ID、隧道的源端地址和目的地址，在本地相同VXLAN ID下查找是否存在相同源端地址和目的地址的VXLAN隧道。若存在相同的VXLAN隧道，则将表项添加到该VXLAN隧道接口；否则，不添加表项。

## 11.2 VXLAN隧道建立

在VXLAN组网中，VTEP之间通过手工方式创建VXLAN隧道，即手工指定隧道的源端地址和目的端地址需要分别手工指定为本地和远端VTEP的接口地址。组成M-LAG系统的两台VTEP设备上，需要配置一个相同的IP地址作为虚拟VTEP的地址，并采用虚拟VTEP地址作为本地VXLAN隧道的源端地址与远端VTEP建立隧道。

在peer-link为VXLAN隧道的VXLAN组网中，还需要在组成M-LAG系统的两台VTEP设备之间手工创建一条VXLAN隧道。

## 11.3 网络侧的下行BUM流量

如[图59](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref102829423)所示，接入服务器（Server 2）通过聚合接口采用M-LAG方式接入VTEP，Server 1和Server 3分别单挂接入VTEP 1和VTEP 2。外网向Server所在的内网发送BUM流量时，VTEP 3将通过目的IP地址为虚拟VTEP地址的VXLAN隧道将流量转发给M-LAG设备（VTEP 1和VTEP 2）。由于VTEP 1和VTEP 2共用虚拟VTEP地址，因此通过该VXLAN隧道转发的流量会负载分担到VTEP 1和VTEP 2。VTEP 1和VTEP 2判断流量所属的VSI，并在该VSI内的所有AC（包括M-LAG接口对应的AC和单挂AC）、peer-link上转发该流量。M-LAG设备从peer-link上接收到BUM流量后，仅将该流量转发给本地的单挂AC。

图65 M-LAG接口的下行BUM流量转发

![img](https://resource.h3c.com/cn/202312/29/20231229_10257962_x_Img_x_png_82_2004108_30005_0.png)

 

# 12 EVPN数据中心互联支持M-LAG

![说明](https://resource.h3c.com/cn/202312/29/20231229_10257963_x_Img_x_png_83_2004108_30005_0.png)

目前，本功能仅支持站点网络和Underlay网络同为IPv4网络，或站点网络和Underlay网络同为IPv6网络。

 

如[图66](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref38614783)所示，EVPN数据中心互联组网中，利用M-LAG将两台物理设备连接起来虚拟成一台设备，使用该虚拟设备作为ED，可以避免ED单点故障对网络造成影响，从而提高EVPN网络的可靠性。

图66 EVPN数据中心互联支持M-LAG示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257964_x_Img_x_png_84_2004108_30005_0.png)

 

EVPN数据中心互联支持M-LAG的工作机制与EVPN VXLAN支持M-LAG相同，详细介绍请参见“[10 ](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref103590903)[EVPN VXLAN支持M-LAG](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref103590911)”。

# 13 组播VXLAN支持M-LAG

![说明](https://resource.h3c.com/cn/202312/29/20231229_10257965_x_Img_x_png_85_2004108_30005_0.png)

仅EVPN VXLAN组网中的MDT模式组播VXLAN支持M-LAG。VXLAN组网中的入方向复制模式组播VXLAN不支持M-LAG。

 

## 13.1 组播VXLAN支持M-LAG工作机制概述

### 13.1.1 典型组网

组播VXLAN利用M-LAG将两台物理设备连接起来虚拟成一台设备，避免设备单点故障对网络造成影响，从而提高组播VXLAN网络的可靠性。在组播VXLAN组网中，VTEP和Border设备均支持M-LAG，且作为M-LAG设备的VTEP和Border均可以连接组播源和组播接收者。

EVPN组播支持M-LAG的典型组网如[图67](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref88485783)所示。VTEP 1和VTEP 2组成M-LAG系统，VTEP 3和VTEP 4组成M-LAG系统，Border 1和Border 2组成M-LAG系统。组成M-LAG系统的两台VTEP/Border具有相同的虚拟地址，对外表现为一台虚拟设备。其他VTEP/Border使用该地址与这台虚拟设备自动建立单播VXLAN隧道。组播VXLAN隧道的源地址也使用该虚拟VTEP地址。由于存在Underlay网络的组播RPF检查机制，设备只会加入到M-LAG系统中一台设备的组播VXLAN隧道。例如，VTEP 3和VTEP 4在加入组播VXLAN隧道时，只会加入到VTEP 1和VTEP 2中一台VTEP的组播VXLAN隧道，不会同时加入VTEP 1和VTEP 2的组播VXLAN隧道。

图67 组播VXLAN支持M-LAG组网

![img](https://resource.h3c.com/cn/202312/29/20231229_10257966_x_Img_x_png_86_2004108_30005_0.png)

 

### 13.1.2 用户侧备份机制

组播VXLAN支持M-LAG功能通过peer-link在组成M-LAG系统的成员设备间同步组播流量和组播接收者加入请求（IGMP成员关系报告报文或者PIM加入报文），使成员设备上的组播源和组播接收者信息保持一致，形成设备级备份。当一台成员设备发生故障（设备故障、上下行链路故障等）时，组播流量可以由另一台成员设备进行转发，从而避免组播流量转发中断。

在[图67](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref88485783)所示的组网中，用户侧备份机制为：

·   组播源侧备份：组播源Source 1通过M-LAG接入后，Source 1的组播流量会发送到VTEP 1和VTEP 2中的一台设备。接收到组播流量的VTEP通过peer-link，将组播流量同步到另外一台VTEP，从而实现VTEP 1和VTEP 2上都存在组播流量。

·   组播接收者侧备份：组播接收者通过M-LAG接入后，组播接收者的加入请求会发送到VTEP 3和VTEP 4中的一台设备。接收到加入请求的VTEP通过peer-link，将加入请求同步到另外一台VTEP，从而实现在VTEP 3和VTEP 4上都建立组播转发表项，表项的出接口为M-LAG接口。

### 13.1.3 组播流量分担

组播接收者侧的M-LAG设备接收到组播流量后，采用奇偶原则对组播流量进行负载分担，M-LAG系统编号为奇数的成员设备转发组播组地址为奇数的流量，M-LAG系统编号为偶数的成员设备转发组播组地址为偶数的流量。当一台设备发生故障时，另一台设备可以接替其工作，避免流量转发中断。

![说明](https://resource.h3c.com/cn/202312/29/20231229_10257967_x_Img_x_png_87_2004108_30005_0.png)

M-LAG设备上的组播流量奇偶负载分担原则仅针对三层组播转发生效，对二层组播转发不生效。

 

## 13.2 二层组播支持M-LAG

二层组播是指组播源和组播接收者位于同一个VXLAN网络，组播流量在同一个VXLAN网络内根据二层组播转发表项（IGMP snooping、PIM snooping表项等）进行转发。

如[图68](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref88487584)所示，二层组播支持M-LAG组网中，仅支持组播接收者通过M-LAG方式接入，不支持组播源通过M-LAG方式接入，且流量转发仅支持头端复制方式。

图68 二层组播支持M-LAG典型组网

![img](https://resource.h3c.com/cn/202312/29/20231229_10257968_x_Img_x_png_88_2004108_30005_0.png)

 

## 13.3 三层组播支持M-LAG

三层组播是指组播源和组播接收者位于不同的VXLAN网络、相同的VPN，组播流量在同一个VPN内跨越VXLAN网络，根据三层组播转发表项（IGMP、PIM表项等）进行转发。如[图69](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref105055934)所示，EVPN VXLAN三层组播场景中，支持通过M-LAG提高网络的可靠性。

图69 三层组播支持M-LAG典型组网

![img](https://resource.h3c.com/cn/202312/29/20231229_10257969_x_Img_x_png_89_2004108_30005_0.png)

 

## 13.4 三层组播数据中心互联支持M-LAG

在三层组播VXLAN跨数据中心互联场景中，为了提高ED的可靠性，避免单点故障，在数据中心的边缘可以部署两台ED设备与其他数据中心互联。这两台ED设备组成M-LAG系统，通过M-LAG机制为ED提供冗余保护。

如[图70](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref103161726)所示，在组播数据中心互联支持M-LAG组网中，DC内需要建立组播VXLAN隧道，ED之间建立单播VXLAN-DCI隧道。组成M-LAG系统的ED设备具有相同的虚拟ED地址，虚拟成一台ED设备，使用虚拟ED地址与VTEP、远端ED建立隧道，以实现冗余保护和负载分担。

![说明](https://resource.h3c.com/cn/202312/29/20231229_10257971_x_Img_x_png_90_2004108_30005_0.png)

组播数据中心互联支持M-LAG组网中，ED上不存在M-LAG接口。

 

图70 三层组播数据中心互联支持M-LAG典型组网

![img](https://resource.h3c.com/cn/202312/29/20231229_10257972_x_Img_x_png_91_2004108_30005_0.png)

 

# 14 典型组网应用

## 14.1 单级M-LAG场景

如[图71](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref484788293)所示，为了保证可靠性，Device C在接入网络时需要考虑链路的冗余备份，虽然可以采用部署MSTP等环路保护协议的方式，但是这种方式下链路的利用率很低，浪费大量的带宽资源。为了实现冗余备份同时提高链路的利用率，在Device A与Device B之间部署M-LAG，实现设备的双归属接入。这样Device A与Device B形成负载分担，共同进行流量转发，当其中一台设备发生故障时，流量可以快速切换到另一台设备，保证业务的正常运行。

图71 单级M-LAG场景组网图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257973_x_Img_x_png_92_2004108_30005_0.png)

 

## 14.2 多级M-LAG互联场景

如[图72](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref484788075)所示，多级M-LAG互联可以在保证可靠性、提供链路利用率的同时扩展双归属接入的网络规模，可以在大二层数据中心网络设备数量比较多时提供稳定网络环境。同时汇聚层设备作为双活网关，核心层设备和汇聚层设备之间采用M-LAG组成聚合链路，保证设备级可靠性。

图72 多级M-LAG互联组网图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257974_x_Img_x_png_93_2004108_30005_0.png)

 

## 14.3 M-LAG与STP结合应用场景

如[图73](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref103539224)所示，M-LAG与STP结合应用场景的部署方案如下：

·   接入层的Device A和Device B、汇聚层的Device C和Device D分别组成M-LAG系统，以避免单点故障造成流量转发中断，提高网络的可靠性。

·   Device F和VM通过M-LAG方式双归接入到M-LAG系统，以提高上行流量和下行流量的可靠性。其中，Device F双归接入到Device A和Device B组成的M-LAG系统；VM通过Device G双归接入到evice C和Device D组成的M-LAG系统。

·   多级M-LAG组网中，汇聚层的Device C和Device D作为三层网关，为Device F提供网关和路由接入服务。M-LAG支持VLAN双活网关和VRRP网关两种网关部署方案。

·   在Device A～Device D上部署STP，并指定Device C和Device D作为根桥，以消除M-LAG系统之间的环路。

图73 二级M-LAG+STP组网示意图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257975_x_Img_x_png_94_2004108_30005_0.png)

 

## 14.4 M-LAG与QinQ结合应用场景

如[图74](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref102831367)所示，在汇聚层设备上部署M-LAG和QinQ，为QinQ服务提供设备高可靠性和负载分担；在汇聚层与核心层间部署生成树，以避免产生环路。

图74 M-LAG与QinQ结合组网图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257976_x_Img_x_png_95_2004108_30005_0.png)

 

## 14.5 M-LAG与Super VLAN结合应用场景

如[图75](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref102838186)所示，为用户终端提供接入的设备均双归接入到与外界网络进行三层通信的M-LAG系统网关，M-LAG设备运行Super VLAN服务以节约IP地址资源，同时通过M-LAG系统提供设备的高可靠性和链路的负载分担。M-LAG系统的两台设备与外部网络间的上行链路可以借助路由协议实现负载分担。

图75 M-LAG与Super VLAN结合组网图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257977_x_Img_x_png_96_2004108_30005_0.png)

 

## 14.6 M-LAG与Private VLAN结合应用场景

如[图75](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref102838186)所示，为用户终端提供接入的设备均双归接入到与外界网络进行二三层通信的M-LAG系统网关，M-LAG设备运行Private VLAN服务以节约VLAN资源，同时通过M-LAG系统提供设备的高可靠性和链路的负载分担。M-LAG系统的两台设备与外部网络间的上行链路可以借助路由协议实现三层流量的负载分担，如果M-LAG系统的两台设备需要与外部网络进行二层通信，需要在上行链路配置生成树协议，以避免产生环路。

图76 M-LAG与Private VLAN结合组网图

![img](https://resource.h3c.com/cn/202312/29/20231229_10257978_x_Img_x_png_97_2004108_30005_0.png)

 

## 14.7 EVPN VXLAN支持M-LAG

EVPN VXLAN支持M-LAG组网中，两台VTEP虚拟为一台VTEP，在VTEP之间通过peer-link同步MAC地址和ARP信息，以确保两台VTEP上的MAC地址和ARP信息保持一致。peer-link连接既可以是以太网聚合链路，如[图77](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref508957473)所示，也可以是VXLAN隧道，如[图78](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/M-LAG_White_Paper-Long/?CHID=713486#_Ref508957474)所示。

在下行方向，跨VTEP设备形成链路聚合，实现用户侧链路的备份，从而避免单条以太网链路故障导致虚拟机无法访问网络。

图77 EVPN VXLAN支持M-LAG组网图（以太网聚合链路作为peer-link）

![img](https://resource.h3c.com/cn/202312/29/20231229_10257979_x_Img_x_png_98_2004108_30005_0.png)

 

图78 EVPN VXLAN支持M-LAG组网图（VXLAN隧道作为peer-link）

![img](https://resource.h3c.com/cn/202312/29/20231229_10257980_x_Img_x_png_99_2004108_30005_0.png)

 