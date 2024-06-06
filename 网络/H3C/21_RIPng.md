# 概述

RIP是IETF组织开发的一个基于距离矢量算法的内部网关协议，具有配置简单、易于管理和操作等特点，在IPv4的中小型网络中获得了广泛应用。

随着IPv6网络的建设，同样需要动态路由协议为IPv6报文的转发提供准确有效的路由信息。因此，IETF在保留了RIP优点的基础上，针对IPv6网络修改形成了RIPng。RIPng主要用于在IPv6网络中提供路由功能，是IPv6网络中的一个重要路由协议。

# 2 RIPng技术实现

RIPng在工作机制上与RIP基本相同，但为了支持IPv6地址格式，RIPng对RIP做了一些改动。下面先对RIP进行简要介绍，之后再详细介绍RIPng与RIP的异同点。

## 2.1 RIP简介

### 2.1.1 RIP工作机制

RIP通过UDP报文进行路由信息的交换，使用的端口号为520。

RIP使用跳数来衡量到达目的地址的距离，跳数称为度量值。在RIP中，路由器到与它直接相连网络的跳数为0，通过一个路由器可达的网络的跳数为1，依此类推。为限制收敛时间，RIP规定度量值取0～15之间的整数，大于或等于16的跳数被定义为无穷大，即目的网络或主机不可达。

RIP的启动和运行过程如下：

(1)   路由器启动RIP后，便会向相邻的路由器发送请求报文。接着，路由器将不断侦听来自其它路由器的RIP请求报文或响应报文。

(2)   当发出请求的路由器收到响应报文后，路由器将处理响应报文中的路由更新信息并对自己的路由表进行更新，同时向相邻路由器发送触发更新报文，通告路由更新信息。

(3)   相邻路由器收到触发更新报文后，又向其各自的相邻路由器发送触发更新报文。在一连串的触发更新广播后，各路由器都能得到并保持最新的路由信息。

为保证路由的实时性和有效性，RIP在缺省情况下每隔30秒向相邻路由器发送本地路由表，同时采用老化机制对超时的路由进行老化处理。

### 2.1.2 RIP版本差异

RIP有两个版本：RIP-1和RIP-2。

RIP-1是有类别路由协议（Classful Routing Protocol），它只支持以广播方式发布协议报文。RIP-1的协议报文无法携带掩码信息，它只能识别A、B、C类这样的自然网段的路由，因此RIP-1不支持不连续子网。

RIP-2是一种无类别路由协议（Classless Routing Protocol），与RIP-1相比，它有以下优势：

·   支持路由标记，在路由策略中可根据路由标记对路由进行灵活的控制。

·   报文中携带掩码信息，支持路由聚合和CIDR。

·   支持指定下一跳，在广播网上可以选择到最优下一跳地址。

·   支持组播方式发送更新报文，减少资源消耗。

·   在路由更新报文中增加一个认证RTE（Route Entries，路由表项）以支持对协议报文进行验证，并提供明文验证和MD5验证两种方式，增强安全性。

## 2.2 RIPng与RIP的异同点

### 2.2.1 报文的不同

#### 1. 路由信息中的目的地址和下一跳地址长度不同

RIP-2报文中路由信息的目的地址和下一跳地址只有32比特，而RIPng均为128比特。

#### 2. 报文长度不同

RIP-2对报文的长度有限制，规定每个报文最多只能携带25个RTE，而RIPng对报文长度、RTE的数目都不作规定，报文的长度与发送接口设置的IPv6 MTU有关。

#### 3. 报文格式不同

RIP-2报文结构如[图1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/RIPng_White_Paper-6W100/?CHID=949114#_Ref16176473)所示，由头部（Header）和多个RTE组成。

图1 RIP-2报文

![img](https://resource.h3c.com/cn/201910/25/20191025_4562839_x_Img_x_png_0_1238949_30005_0.png)

 

RIPng报文结构如[图2](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/RIPng_White_Paper-6W100/?CHID=949114#_Ref16176532)所示。与RIP-2一样，RIPng报文也是由Header和多个RTE组成。与RIP-2不同的是，在RIPng里有两类RTE，分别是：

·   下一跳RTE：位于一组具有相同下一跳的IPv6前缀RTE的前面，它定义了下一跳的IPv6地址。

·   IPv6前缀RTE：位于某个下一跳RTE的后面。同一个下一跳RTE的后面可以有多个不同的IPv6前缀RTE。它描述了RIPng路由表中的目的IPv6地址、路由标记、前缀长度以及度量值。

图2 RIPng报文

![img](https://resource.h3c.com/cn/201910/25/20191025_4562840_x_Img_x_png_1_1238949_30005_0.png)

 

下一跳RTE的格式如[图3](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/RIPng_White_Paper-6W100/?CHID=949114#_Ref16176697)所示，其中，IPv6 next hop address表示下一跳的IPv6地址。

图3 下一跳RTE格式

![img](https://resource.h3c.com/cn/201910/25/20191025_4562841_x_Img_x_png_2_1238949_30005_0.png)

 

IPv6前缀RTE的格式如[图4](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/RIPng_White_Paper-6W100/?CHID=949114#_Ref16176764)所示，各字段的解释如下：

·   IPv6 prefix：目的IPv6地址的前缀。

·   Route tag：路由标记。

·   Prefix lenth：IPv6地址的前缀长度。

·   Metric：路由的度量值。

图4 IPv6前缀RTE格式

![img](https://resource.h3c.com/cn/201910/25/20191025_4562842_x_Img_x_png_3_1238949_30005_0.png)

#### 4. 报文的发送方式不同

RIP-2可以根据用户配置采用广播或组播方式来周期性地发送路由信息；RIPng使用组播方式周期性地发送路由信息。

### 2.2.2 安全认证不同

RIPng自身不提供认证功能，而是通过使用IPv6提供的安全机制来保证自身报文的合法性。因此，RIP-2报文中的认证RTE在RIPng报文中被取消。

### 2.2.3 与网络层协议的兼容性不同

RIP不仅能在IP网络中运行，也能在IPX网络中运行；RIPng只能在IPv6网络中运行。

# 3 Comware实现加快RIP/RIPng路由收敛的技术特色

当我司设备收到多个邻居发送的去往同一目的地但是开销不同的路由时，会将开销较大的次优路由也保存在本地。次优路由的生效机制如下：

·   当最优路由因为链路down被删除时，次优路由会立即生效。

·   如果最优路由的发布者停止更新路由，设备将启动Garbage-Collect定时器，在定时器结束时，如果次优路由没有被撤销，那么该次优路由会立即生效。

次优路由在主路由抑制状态结束后可以立即生效，而不用等待发布次优路由的路由器再次更新该路由。保存次优路由可以在很多场景下加快RIP/RIPng的路由收敛。同时，次优路由是否生效受主路由抑制状态影响，可以避免路由环路。

# 4 典型组网应用

如[图5](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/RIPng_White_Paper-6W100/?CHID=949114#_Ref17300905)所示，某学校构建了IPv6网络，学校内所有主机和路由器运行IPv6协议。该学校的网络规模比较小，选择RIPng路由协议即可满足用户需求，实现任意两个节点之间能够互通，并降低网络拓扑变化引发的人工维护工作量。

图5 RIPng典型应用组网图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562843_x_Img_x_png_4_1238949_30005_0.png)

 

# 5 参考文献

·   RFC 2080：RIPng for IPv6

·   RFC 2081：RIPng Protocol Applicability Statement

·   RFC 1058：Routing Information Protocol

·   RFC 1721：RIP Version 2 Protocol Analysis

·   RFC 2082：RIP-2 MD5 Authentication

·   RFC 2453：RIP Version 2