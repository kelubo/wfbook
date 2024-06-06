# 概述

## 1.1 产生背景

网络设计时，通常使用冗余备份链路来保护关键应用。网络发生故障时，需要设备能够快速检测出故障，并将流量切换至备份链路以加快网络收敛速度。目前有些链路（如POS）通过硬件检测机制来实现快速故障检测，但是某些链路（如以太网链路）不具备这样的检测机制。此时，应用就要依靠上层协议自身的机制来进行故障检测，然而上层协议的检测时间都在1秒以上，这样的故障检测时间对某些应用来说是不能容忍的。部分路由协议如OSPF、IS-IS虽然有Fast Hello功能来加快检测速度，但是检测时间也只能达到1秒的精度，而且Fast Hello功能只是针对本协议的，无法为其它协议提供快速故障检测。

## 1.2 技术优点

BFD协议提供了一个通用的、标准化的、介质无关的、协议无关的快速故障检测机制。具有以下优点：

·   对网络设备间任意类型的双向转发路径进行故障检测，包括直连物理链路、SRv6 BE转发路径、SRv6 TE Policy转发路径、MPLS LSP、多跳路由路径以及单向链路等。

·   可以为不同的上层应用服务，提供一致的快速故障检测时间。

·   提供毫秒级的检测速度，从而加快网络收敛速度，减少应用中断时间，提高网络的可靠性。

# 2 BFD技术实现

## 2.1 概念介绍

BFD可以用来进行单跳和多跳检测：

·   单跳检测：是指对两个直连设备进行IP连通性检测，这里所说的“单跳”是IP的一跳。

·   多跳检测：BFD可以检测两个设备间任意路径的链路情况，这些路径可能跨越很多跳。

## 2.2 原理简介

BFD在两台网络设备上建立会话，用来检测网络设备间的双向转发路径，为上层应用服务。BFD本身并没有发现机制，而是靠被服务的上层协议通知来建立会话。上层协议在建立新的邻居关系后，将邻居的参数及检测参数（包括目的地址和源地址等）通告给BFD；BFD根据收到的参数建立BFD会话。会话建立后，建立会话的双方会周期性地向彼此快速发送BFD报文。如果在检测时间内没有收到会话对端的BFD报文，则认为该双向转发路径发生了故障，并将故障信息通知给该会话所服务的上层应用，由上层应用采取相应的措施。下面以OSPF与BFD联动为例，简单介绍BFD的工作流程。

如[(3)图1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/BFD_White_Paper-110/?CHID=949034#_Ref14189092)所示，上层应用与BFD联动触发建立会话的流程为：

(1)   OSPF通过自己的Hello机制发现邻居并建立连接；

(2)   OSPF在建立了新的邻居关系后，将邻居信息（包括目的地址和源地址等）通告给BFD；

(3)   BFD根据收到的邻居信息建立会话。

图1 BFD会话建立流程图

![img](https://resource.h3c.com/cn/202111/23/20211123_6354506_x_Img_x_png_0_1493433_30005_0.png)

 

如[图2](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/BFD_White_Paper-110/?CHID=949034#_Ref14189364)所示，BFD检测到链路故障通知上层应用的流程为：

(1)   BFD检测到链路故障，BFD会话状态变为Down；

(2)   BFD通知本地OSPF进程BFD邻居不可达；

(3)   本地OSPF进程中断OSPF邻居关系。

图2 BFD故障发现处理流程图

![img](https://resource.h3c.com/cn/202111/23/20211123_6354507_x_Img_x_png_1_1493433_30005_0.png)

 

根据检测过程采用的报文类型不同，BFD会话分为两类：

·   echo报文方式的BFD会话。echo报文方式的BFD会话不需要对端设备支持BFD功能，或者不需要对端配置BFD。适用于仅一端设备需要故障检测的情况。

·   控制报文方式的BFD会话。控制报文方式需要两端设备均配置BFD。适用于两端设备均需要故障检测的情况。

下面将分别对这两种方式进行介绍。

## 2.3 echo报文方式的BFD会话

### 2.3.1 BFD echo报文

BFD echo报文采用UDP封装，目的端口号为3785，目的IP地址为发送接口的地址，源IP地址由配置产生（配置的源IP地址要避免产生ICMP重定向）。

BFD协议并没有对BFD echo报文的格式进行定义，唯一的要求是发送方能够通过报文内容识别会话。

当BFD会话工作于echo报文方式时，仅在隧道应用中支持多跳检测，其他应用中仅支持单跳检测。

### 2.3.2 BFD会话的建立

本端周期性发送echo报文建立BFD会话，对链路进行单向检测。对端不建立BFD会话。

### 2.3.3 BFD会话的检测机制

本端发送echo报文，对端只需把收到的echo报文转发回本端。如果本端在检测时间内没有收到对端转发回的echo报文，则认为会话DOWN。

## 2.4 控制报文方式的BFD会话

### 2.4.1 BFD控制报文

BFD控制报文采用UDP封装，源端口号的范围为49152到65535，对于单跳检测其UDP目的端口号为3784，对于多跳检测其UDP目的端口号为4784。

如[图3](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/BFD_White_Paper-110/?CHID=949034#_Ref18479071)所示，BFD控制报文包括强制必选部分和可选认证部分。

图3 BFD控制报文

![img](https://resource.h3c.com/cn/202111/23/20211123_6354513_x_Img_x_png_2_1493433_30005_0.png)

 

BFD控制报文各字段含义如[表1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/BFD_White_Paper-110/?CHID=949034#_Ref18479100)所示。

表1 BFD控制报文字段含义

| 字段                          | 含义                                                         |
| ----------------------------- | ------------------------------------------------------------ |
| Vers                          | BFD协议版本号，目前版本号为1                                 |
| Diag                          | 诊断码，表明发送方最近一次会话Down的原因                     |
| Sta                           | 发送方BFD会话当前状态，取值为：  ·   0：代表AdminDown  ·   1：代表Down  ·   2：代表Init  ·   3：代表Up |
| P                             | 会话参数变化时置位                                           |
| F                             | 如果收到的BFD控制报文P字段置位，则将下一个发送的BFD控制报文的F字段置位作为应答 |
| C                             | 该字段置位表明BFD的实现是独立于控制平面的                    |
| A                             | 该字段置位表明报文包含认证部分，会话需要进行认证             |
| D                             | 该字段置位表明发送方希望以查询模式运行，不置位表明不希望以查询模式运行或不支持查询模式 |
| R                             | 保留位，发送时设为0，接收时忽略该字段                        |
| Detect Mult                   | 检测时间倍数                                                 |
| Length                        | BFD控制报文长度，单位为字节                                  |
| My Discriminator              | 发送方产生的一个唯一非0值，用来标识不同的BFD会话             |
| Your Discriminator            | 如果已经收到会话邻居发送的BFD控制报文则该值为收到报文中的My Discriminator，否则为0 |
| Desired Min TX Interval       | 发送方支持的最小BFD控制报文发送时间间隔，单位为微秒          |
| Required Min RX Interval      | 发送方支持的最小BFD控制报文接收时间间隔，单位为微秒          |
| Required Min Echo RX Interval | 发送方支持的最小BFD Echo报文接收时间间隔，单位为微秒。为0表示不支持BFD Echo报文 |
| Auth Type                     | 认证类型                                                     |
| Auth Len                      | 可选认证部分长度，包括Auth Type和Auth Len字段，单位为字节    |
| Authentication Data           | 认证数据区                                                   |

 

### 2.4.2 BFD会话建立方式

建立控制报文方式的BFD会话有两种方式：

·   通过命令行静态创建BFD会话。

·   应用程序与BFD联动时动态建立BFD会话。

BFD通过控制报文中的本地标识符（My Discriminator）和远端标识符（Your Discriminator）来区分不同的会话。静态创建BFD会话和动态建立BFD会话的主要区别在于本地标识符和远端标识符的获取方式不同：

·   静态BFD会话的本地标识符和远端标识符由用户手工配置。包括以下两种配置方式：

¡   手工创建静态BFD会话的同时，指定本地标识符和远端标识符。

¡   将应用程序与BFD联动时，手工指定本地标识符和远端标识符。

·   动态BFD会话的本端标识符由本端设备分配，远端标识符在BFD会话协商建立过程中获取。

### 2.4.3 BFD会话建立过程

#### 1. BFD会话的状态机迁移机制

BFD会话通常有三种状态，分别为：

·   DOWN：本端会话已经关闭或刚刚创建。DOWN状态表示转发路径不可用，与BFD会话联动的上层应用需要采取适当的措施，例如主备路径切换等。

·   INIT：本端已经可以与对端通信，且本端希望会话进入UP状态。

·   UP：本端会话已经建立成功。UP状态表示转发路径可用。

另外，还有一个特殊状态：ADMIN DOWN，本端系统主动阻止建立BFD会话时，BFD会话状态为ADMIN DOWN。在状态机中ADMIN DOWN也是DOWN状态。状态机迁移机制如[图4](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/BFD_White_Paper-110/?CHID=949034#_Ref14420183)所示。

图4 BFD会话状态机迁移机制

![img](https://resource.h3c.com/cn/202111/23/20211123_6354514_x_Img_x_png_3_1493433_30005_0.png)

 

#### 2. BFD会话的建立

BFD会话建立前，通过改变BFD会话的运行模式可以控制发送BFD控制报文的方式：

·   主动模式：在建立会话前不管是否收到对端发来的BFD控制报文，都会主动发送BFD控制报文；

·   被动模式：在建立会话前不会主动发送BFD控制报文，直到收到对端发送来的控制报文。

通信双方至少要有一方运行在主动模式才能成功建立起BFD会话。

BFD使用三次握手的机制来建立会话，发送方在发送BFD控制报文时会在Sta字段填入本地当前的会话状态，接收方根据收到的BFD控制报文的Sta字段以及本地当前会话状态来进行状态机的迁移，建立会话。

图5 BFD会话建立过程

![img](https://resource.h3c.com/cn/202111/23/20211123_6354515_x_Img_x_png_4_1493433_30005_0.png)

 

如[图5](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/BFD_White_Paper-110/?CHID=949034#_Ref15051074)所示，以两端均为主动模式的会话建立过程为例，说明BFD如何通过报文交互和状态机的变化建立会话，一端主动模式一端被动模式的会话建立过程基本相同：

(1)   Router A和Router B的BFD收到上层应用的通知后，发送状态为DOWN的BFD控制报文。

(2)   Router B收到对端状态为DOWN的BFD控制报文后，本地会话状态由DOWN迁移到INIT，随后将待发送的BFD控制报文中的Sta字段填为2（表示会话状态为INIT）。Router A的BFD状态变化同Router B。

(3)   Router A收到对端状态为INIT的BFD控制报文后，本地会话状态由INIT迁移到UP，随后将待发送的BFD控制报文中的Sta字段填为3（表示会话状态为UP）。Router B的BFD状态变化同Router A。

(4)   BFD双方状态都为UP时，标志会话成功建立，两端开始检测链路状态。

(5)   如果本端BFD会话DOWN，将会向对端发送Sta字段填为1的BFD控制报文，通知对端会话DOWN，对端的BFD会话也迁移到DOWN状态。

### 2.4.4 定时器协商

#### 1. 定时器简介

在建立BFD会话的过程中，需要通过报文交互协商如下定时器来控制BFD检测过程：

·   BFD控制报文的发送时间间隔：BFD会话建立前，发送时间间隔至少为1秒，具体发送时间间隔与设备的型号有关。部分设备上会话数量越多发送的间隔越大，这样可以减小报文流量；在会话建立后，则以协商的时间间隔发送BFD控制报文，以实现快速检测。

·   检测时间：每当收到BFD控制报文时，就会重置检测时间定时器，保持会话UP状态。如果在检测时间内没有收到BFD控制报文，BFD会话会迁移到DOWN状态，并通知该会话所服务的上层应用监测对象发生故障，由上层应用采取相应的措施。

#### 2. 定时器协商机制

BFD会话协商时，定时器值的选取原则为：

·   BFD控制报文发送时间间隔=MAX（本端Desired Min TX Interval，对端Required Min RX Interval），也就是说比较慢的一方决定了发送频率。

·   检测时间=对端BFD控制报文中的Detect Mult×MAX（本端Required Min RX Interval，对端Desired Min TX Interval）。

不同方向的BFD会话定时器是各自独立协商的，双向定时器时间可以不同。

在BFD会话有效期间，控制报文发送时间间隔和检测时间可以随时协商修改而不影响会话状态。修改定时器参数会带来如下影响：

·   如果加大本端Desired Min TX Interval，那么本端实际发送BFD控制报文的时间间隔必须要等收到对端F字段置位的报文后才能改变，这是为了确保在本端加大BFD控制报文发送时间间隔前对端已经加大了检测时间，否则可能导致对端检测定时器错误超时。

·   如果减小本端Required Min RX Interval，那么本端检测时间必须要等收到对端F字段置位的报文后才能改变，这是为了确保在本端减小检测时间前对端已经减小了BFD控制报文发送间隔时间，否则可能导致本端检测定时器错误超时。

·   如果减小Desired Min TX Interval，本端BFD控制报文发送时间间隔将会立即减小；加大Required Min RX Interval，本端检测时间将会立即加大。

下面详细介绍参数改变后定时器的协商过程。如[图6](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/BFD_White_Paper-110/?CHID=949034#_Ref14197640)所示，Router A与Router B建立BFD会话，双方的Desired Min TX Interval和Required Min RX Interval（下面简称为TX和RX）都为100ms，Detect Mult都为3。根据定时器协商规则，Router A的发送时间间隔为Router A的TX与Router B的RX中的最大值也就是100ms，Router B的发送时间间隔也是100ms，双方的检测超时时间都为300ms。

如果此时将Router A的TX和RX加大到150 ms。

(1)   Router A比较本端的RX（150ms）和Router B的TX（100ms），然后将本端检测时间改为450ms，同时向对端发送P字段置位的BFD控制报文（TX和RX均为150ms）。

(2)   Router B收到报文后，将收到报文中的RX与本端的TX进行比较，由于RX较大，故Router B的发送间隔改为150ms。经过比较本端RX和对端的TX，从而将检测时间也增大到450ms。调整完成后给Router A回复F字段置位的BFD控制报文（TX和RX均为100ms）。

(3)   Router A收到对端发来F字段置位的控制报文，根据报文中的RX与本端的TX进行比较计算出新的时间间隔为150ms。

(4)   定时器协商完成，双方的发送间隔和检测时间均分别为150ms和450ms。

图6 BFD检测时间协商

![img](https://resource.h3c.com/cn/202111/23/20211123_6354516_x_Img_x_png_5_1493433_30005_0.png)

 

### 2.4.5 BFD会话的检测机制

BFD会话建立后，两端通过周期性发送控制报文对链路进行检测。

BFD支持两种检测模式：

·   异步模式：设备周期性发送BFD控制报文，如果在检测时间内没有收到对端发送的BFD控制报文，则认为会话DOWN。缺省情况下，BFD会话为异步模式。

·   查询模式：当系统中的BFD会话数量较多时，采用查询模式可防止周期性发送BFD控制报文的开销对系统的正常运行造成影响。

¡   本端的BFD会话工作在查询模式时，本端设备会向对端发送D比特位置1的BFD控制报文，对端（缺省为异步模式）收到该报文后将停止周期性发送BFD控制报文。

¡   如果BFD会话两端都是查询模式，则双方在BFD会话建立后停止周期性发送BFD控制报文。仅当需要验证连通性的时候，设备会连续发送P比特位置1的BFD控制报文。如果在检测时间内没有收到对端回应的F比特位置1的报文，就认为会话DOWN；如果在检测时间内收到对端回应的F比特位置1的报文，就认为链路连通，停止发送报文，等待下一次触发查询。

### 2.4.6 BFD回声功能

使用异步模式的BFD会话检测直连网段的连通性时，可以使用BFD回声功能辅助进行故障检测。

回声功能启动后，会话的一端周期性地发送BFD echo报文，同时自动降低控制报文的接收速率，减少对带宽资源的消耗。对端不对BFD echo报文进行处理，而只将此报文转发回发送端。如果发送端连续几个echo报文都没有接收到，会话状态将变为DOWN。

# 3 SBFD技术实现

## 3.1 原理简介

SBFD（Seamless BFD，无缝BFD）是一种单向的故障检测机制，简化了BFD的状态机（SBFD仅支持UP、DOWN两个状态），缩短了会话协商时间，其检测速度比BFD更快速。SBFD适用于仅一端需要进行链路状态检测的情况。

## 3.2 运行机制

SBFD会话中，设备的角色分为发起端（Initiator）和响应端（Reflector）：

·   Initiator：SBFD会话的发起者，负责维护SBFD会话的状态。Initiator周期性发送SBFD控制报文。

·   Reflector：监听到达本地节点的SBFD控制报文，并判断是否需要生成SBFD响应报文。Reflector无需维护SBFD会话状态。

以[图7](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/BFD_White_Paper-110/?CHID=949034#_Ref492545721)所示的组网为例，说明SBFD会话的运行机制。作为Initiator的Router A通过基于SR（Segment Routing，段路由）建立的MPLS TE隧道，向作为Reflector的Router E发送SBFD控制报文。Router A只要能够收到Router E发送的SBFD控制报文，即认为从Router A到Router E的SRLSP路径可达。

图7 SBFD的Initiator和Reflector

![img](https://resource.h3c.com/cn/202111/23/20211123_6354517_x_Img_x_png_6_1493433_30005_0.png)

 

## 3.3 应用限制

Initiator上指定的SBFD会话的远端标识符必须为Reflector上手工指定的SBFD会话本地标识符。否则，当Reflector收到Initiator发送的SBFD控制报文后，发现报文中携带的远端标识符不是自己的本地标识符时，不会发送响应报文给Initiator。

# 4 SRv6 BFD技术实现

## 4.1 原理简介

BFD可以对SRv6 BE的转发路径和SRv6 TE Policy的转发路径进行快速故障检测，监测其连通状态。当故障发生时触发SRv6 BE或SRv6 TE Policy进行流量切换，提高整网可靠性。

## 4.2 检测SRv6 BE

### 4.2.1 功能简介

在SRv6 BE网络中，使用静态BFD会话检测Locator的可达性，能够提升故障切换性能。

### 4.2.2 运行机制

如[图8](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/BFD_White_Paper-110/?CHID=949034#_Ref56668588)所示，Device A、Device B和Device C为SRv6节点，建立Device A到Device C的SRv6 BE转发路径。Device A的Locator前缀为100:1::/120，Device B的Locator前缀为200:1::/120，Device C的Locator前缀为300:1::/120。分别在Device A和Device C上创建静态BFD会话，Device A和Device C的静态BFD会话使用的源地址和目的地址分别如下：

·   Device A上的静态BFD会话使用的源地址是100:1::0，目的地址是300:1::0。

·   Device C上的静态BFD会话使用的源地址是300:1::0，目的地址是100:1::0。

完成静态BFD会话创建后，Device A和Device C通过IPv6路由的最短路径周期性发送BFD控制报文。如果Device A和Device C在检测时间内收到对端发送的BFD控制报文，则认为SRv6 BE转发路径正常。否则，Device A和Device C认为SRv6 BE转发路径故障。

图8 SRv6 BE组网

![img](https://resource.h3c.com/cn/202111/23/20211123_6354518_x_Img_x_png_7_1493433_30005_0.png)

 

## 4.3 检测SRv6 TE Policy

### 4.3.1 功能简介

SBFD和echo报文方式的BFD均可以用来检测SRv6 TE Policy的连通性，为其提供毫秒级的故障检测速度，并实现快速的故障切换。

### 4.3.2 运行机制

#### 1. SBFD检测SRv6 TE Policy

一个SRv6 TE Policy中，优先级最高的有效路径为主路径，优先级次高的有效路径为备份路径。SBFD对SRv6 TE Policy的主、备路径进行检测。如果主、备路径中存在多个SID列表，SRv6 TE Policy会建立多个SBFD会话分别用来检测每一个SID列表对应的转发路径。当SBFD检测到SRv6 TE Policy主路径的所有SID列表均无效时，SBFD通知SRv6 TE Policy切换到备份路径。

如[(3)图9](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/BFD_White_Paper-110/?CHID=949034#_Ref38635939)所示，在Device A上配置SRv6 TE Policy，并使用SBFD检测该SRv6 TE Policy。SBFD检测SRv6 TE Policy的过程如下：

(1)   头节点作为Initiator发送SBFD报文，SBFD报文封装SRv6 TE Policy对应的SID列表，分别对主、备路径进行检测。存在多个SID列表时，使用多个报文封装不同的SID列表。

(2)   作为Reflector的尾节点收到SBFD报文后，检查报文中携带的远端标识符是否与本地配置的标识符一致。如果一致，Reflector将通过IPv6路由向Initiator发送SBFD响应报文。如果不一致，Reflector将丢弃收到的SBFD报文。

(3)   如果头节点在检测时间超时前能够收到SBFD响应报文，则认为SRv6 TE Policy的SID列表正常。否则，头节点认为SID列表故障。如果主路径下的所有SID列表都发生故障，则SBFD触发主备路径切换。

图9 SBFD for SRv6 TE Policy检测过程

![img](https://resource.h3c.com/cn/202111/23/20211123_6354519_x_Img_x_png_8_1493433_30005_0.png)

 

#### 2. echo报文方式的BFD会话检测SRv6 TE Policy

一个SRv6 TE Policy中，优先级最高的有效路径为主路径，优先级次高的有效路径为备份路径。echo报文方式的BFD对SRv6 TE Policy的主、备路径进行检测。如果主、备路径中存在多个SID列表，SRv6 TE Policy会建立多个BFD会话分别用来检测每一个SID列表对应的转发路径。当BFD检测到SRv6 TE Policy主路径的所有SID列表均无效时，BFD通知SRv6 TE Policy切换到备份路径。

如[(3)图10](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/BFD_White_Paper-110/?CHID=949034#_Ref56671212)所示，在Router A上配置SRv6 TE Policy，并使用echo报文方式的BFD检测该SRv6 TE Policy，检测过程如下：

(1)   头节点发送BFD echo报文，报文封装SRv6 TE Policy对应的SID列表，分别对主、备路径进行检测。存在多个SID列表时，使用多个报文封装不同的SID列表。

(2)   尾节点收到BFD echo报文后，通过IPv6路由的最短路径将BFD echo报文转发回头节点。

(3)   如果头节点在检测时间超时前能够收到尾节点转发回的BFD echo报文，则认为SRv6 TE Policy的SID列表正常。否则，头节点认为SID列表故障。如果主路径下的所有SID列表都发生故障，则BFD触发主备路径切换。

图10 echo报文方式的BFD会话检测SRv6 TE Policy

![img](https://resource.h3c.com/cn/202111/23/20211123_6354520_x_Img_x_png_9_1493433_30005_0.png)

 

# 5 Comware实现的技术特色—硬件BFD技术

## 5.1 产生背景

软件BFD是指BFD检测过程中的报文收发、BFD会话状态机的维护完全依赖CPU来处理。软件BFD会极大的消耗CPU能力。同时，受CPU性能影响，能够支持的BFD会话规格较小，无法用于大规格BFD会话需求的应用场景。

硬件BFD将发送报文、接收报文以及故障检测等消耗CPU性能的功能转移到硬件芯片上处理，从而提升CPU的利用率，以便支持大规格的BFD会话。

## 5.2 运行机制

### 5.2.1 echo报文方式的硬件BFD

对于echo报文方式的BFD会话，第一次收到转发回来的echo报文后，BFD会话就会尝试将其转发到硬件芯片处理。具体处理机制如下：

·   如果检测到硬件芯片可以支持BFD，系统会通知软件处理成功，软件不再维护BFD会话。

·   如果检测到硬件芯片不支持BFD，系统会通知软件处理失败，仍然由软件维护BFD会话。

### 5.2.2 控制报文方式的硬件BFD

控制报文方式的BFD会话状态需要通过控制报文进行协商，硬件芯片的功能比较简单，不能完成BFD会话协商功能。因此在会话状态UP之前，仍然需要通过CPU维护。会话UP之后，会尝试转移到硬件芯片处理。具体处理机制如下：

·   如果系统检测到硬件芯片可以支持BFD，会通知软件处理成功，软件不再维护BFD会话。

·   如果系统检测到硬件芯片不支持BFD，会通知软件处理失败，仍然由软件维护BFD会话。如果需要调整会话的各种参数，则由软件进行协商。

为了支持大规格BFD会话的并发协商能力，在协商定时器时，硬件BFD会话有一些特殊的处理：

(1)   本端在DOWN状态收到INIT报文，或者在INIT状态收到UP报文后，BFD会话变成UP状态，并开始向对端发送P字段置位的报文。报文中携带的会话发送时间间隔、接收时间间隔和检测倍数都设置为设备支持的最大值。

(2)   对端收到P字段置位的报文时，回应F字段置位的报文。

(3)   当本端收到对端回应的F字段置位的报文，表明对端已经按照最大值调整好，此时开始尝试将发送时间间隔、接收时间间隔和检测倍数下调到配置的值，并向对端发送新的P字段置位的报文。报文中携带的发送时间间隔、接收时间间隔和检测倍数为配置的值。由于发送时间间隔变小，因此本端报文的发送时间间隔调整为MAX（配置的发送时间间隔，上一次收到的对端发送时间间隔）；测时间调整为MAX（最大接收时间间隔，对端接收时间间隔）×本端检测倍数。

(4)   对端收到新的P字段置位的报文时，回应F字段置位的报文。

(5)   当本端收到对端回应的新的F字段置位的报文，表明对端已经按照P字段置位的报文中携带的发送时间间隔、接收时间间隔和检测倍数调整好了实际发送时间间隔和检测时间。此时本端检测时间调整为MAX（配置的接收时间间隔，对端接收时间间隔）×本端检测倍数。

(6)   如果本端未收到对端回应的F字段置位的报文，会持续向对端发送P字段置位的报文，在此期间定时器的值为发起协商前的值。直到收到对端回应的F字段置位的报文，协商过程才能结束，BFD按照协商后的结果调整定时器的值。

## 5.3 应用限制

目前，硬件BFD存在如下限制：

·   硬件芯片对BFD会话的发送时间、接收时间和检测倍数有一定的限制，比如发送时间、接收时间可能要求必须是10ms的整数倍。

·   暂不支持对BFD报文进行认证。

·   硬件BFD的协商较普通BFD的协商流程复杂，因此耗时更久，如果在协商未完成之前链路发生故障，可能导致检测时间较长。

# 6 典型组网应用

## 6.1 路由协议与BFD联动典型组网应用

如[图11](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/BFD_White_Paper-110/?CHID=949034#_Ref14197953)所示，两台路由器Router A、Router B通过二层交换机互连，在设备上运行路由协议，网络层相互可达。

Router A与Router B之间通过二层交换机通信的链路出现故障时，BFD能够快速感知并通知OSPF协议，OSPF协议收到BFD通知后尽快计算新的路由，从而缩短收敛时间。

图11 路由协议与BFD联动组网图

![img](https://resource.h3c.com/cn/202111/23/20211123_6354508_x_Img_x_png_10_1493433_30005_0.png)

 

## 6.2 快速重路由与BFD联动典型组网应用

随着网络的快速发展，IP网络越来越多的承载语音、视频等多种业务，这些业务对网络的高可靠性提出了更高的要求，从而运营商网络要求更快的收敛速度。

BFD应用于路由协议以及路由协议快速收敛技术的使用虽然很大程度提高了收敛速度，但还是无法满足语音、视频等新业务对业务中断时间的要求。

而快速重路由和BFD联动技术可以很好的满足这种要求，如[图12](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/BFD_White_Paper-110/?CHID=949034#_Ref14198043)所示，通过提前计算备用路径，快速发现主用路径故障，并在主用路径故障时不依赖于控制平面的收敛而直接在转发平面切换至备用路径，极大的缩短了业务中断时间。

图12 快速重路由与BFD联动组网图

![img](https://resource.h3c.com/cn/202111/23/20211123_6354509_x_Img_x_png_11_1493433_30005_0.png)

 

## 6.3 VRRP与BFD联动典型组网应用

VRRP的协议关键点是当Master出现故障时，Backup能够快速接替Master的转发工作，保证用户数据流的中断时间尽量短。当Master出现故障时，VRRP依靠Backup设置的超时时间来判断是否应该抢占，切换速度在1秒以上。如[图13](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/BFD_White_Paper-110/?CHID=949034#_Ref14248975)所示，将BFD应用于Backup对Master的检测，可以实现对Master故障的快速检测，缩短用户流量中断时间。

VRRP还会监视Master的上行链路能否正常工作，Master即使正常工作，但是如果其上行链路出现了故障，用户报文实际上也是无法正常转发的。VRRP是依靠监视接口状态来判断上行链路是否正常工作的，当被监视的接口DOWN掉时，Master主动降低优先级，引起切换。这种监视接口的处理方式依赖于接口的协议状态，如果上行链路出现故障而接口不DOWN则无法感知到。将BFD应用于VRRP上行链路的检测可以有效解决问题。

图13 VRRP与BFD联动组网图

![img](https://resource.h3c.com/cn/202111/23/20211123_6354510_x_Img_x_png_12_1493433_30005_0.png)

 

## 6.4 MPLS L3VPN over SRv6快速重路由典型组网应用

MPLS L3VPN over SRv6快速重路由功能用来在CE双归属（即一个CE同时连接两个PE）的组网环境下，通过为流量转发的主路径指定一条备份路径，并通过静态BFD检测主路径的状态，实现当主路径出现故障时，将流量迅速切换到备份路径，大大缩短了故障恢复时间。在使用备份路径转发报文的同时，会重新进行路由优选，优选完毕后，使用新的最优路由来转发报文。

以VPNv4路由备份VPNv4路由为例，如[图14](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/BFD_White_Paper-110/?CHID=949034#_Ref58435961)所示，在入节点PE 1上指定VPN 1的FRR备份下一跳为PE 3，则PE 1接收到PE 2和PE 3发布的到达CE 2的VPNv4路由后，PE 1会记录这两条VPNv4路由，并将PE 2发布的VPNv4路由当作主路径，PE 3发布的VPNv4路由当作备份路径。

在PE 1上配置静态BFD检测，通过BFD检测PE 1到PE 2之间公网隧道的状态，由PE 1负责流量切换。当公网隧道正常工作时，CE 1和CE 2通过主路径CE 1—PE 1—PE 2—CE 2通信。当PE 1检测到该公网隧道出现故障时，PE 1将通过备份路径CE 1—PE 1—PE 3—CE 2转发CE 1访问CE 2的流量。

图14 MPLS L3VPN over SRv6快速重路由组网图

![img](https://resource.h3c.com/cn/202111/23/20211123_6354511_x_Img_x_png_13_1493433_30005_0.png)

 

## 6.5 SR-MPLS TE Policy与SBFD联动典型组网应用

SR-MPLS TE Policy不会通过设备之间互相发送的消息来维持自身状态，需要借助SBFD检测SR-MPLS TE Policy路径故障。

如[(3)图15](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/BFD_White_Paper-110/?CHID=949034#_Ref58435972)所示，源节点Router A开启SR-MPLS TE Policy与SBFD联动功能后，将End-point地址作为SBFD的远端标识符。当SR-MPLS TE Policy中优先级最高的候选路径里存在多个SID列表时，会建立多个SBFD会话分别用来检测每一个SID列表对应的转发路径，所有SBFD会话的远端标识符均相同。

通过SBFD检测SR-MPLS TE Policy路径过程如下：

(1)   源节点Router A对外发送SBFD报文，SBFD报文封装SR-MPLS TE Policy对应的SID列表。

(2)   尾节点Router E收到SBFD报文后，通过查找IP路由表按照最短路径发送回应报文。

(3)   源节点Router A如果收到SBFD回应报文，则认为该SID列表对应的转发路径正常；否则，会认为该SID列表对应转发路径故障。如果一个候选路径下所有SID列表对应的转发路径都发生故障，则SBFD触发候选路径切换。

图15 SR-MPLS TE Policy与SBFD联动组网图

![img](https://resource.h3c.com/cn/202111/23/20211123_6354512_x_Img_x_png_14_1493433_30005_0.png)

 

# 7 参考文献

·   RFC 5880：Bidirectional Forwarding Detection (BFD)

·   RFC 5881：Bidirectional Forwarding Detection (BFD) for IPv4 and IPv6 (Single Hop)

·   RFC 5882：Generic Application of Bidirectional Forwarding Detection (BFD)

·   RFC 5883：Bidirectional Forwarding Detection (BFD) for Multihop Paths

·   RFC 7880：Seamless Bidirectional Forwarding Detection (S-BFD)

·   RFC 7881：Seamless Bidirectional Forwarding Detection (S-BFD) for IPv4, IPv6, and MPLS

·   RFC 7882：Seamless Bidirectional Forwarding Detection (S-BFD) Use Cases