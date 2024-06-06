# 概述

IS-IS最初是为OSI网络设计的一种基于链路状态算法的动态路由协议。之后为了提供对IPv4的路由支持，IS-IS被扩展应用到IPv4网络，称为集成化IS-IS。

随着IPv6网络的建设，同样需要动态路由协议为IPv6报文的转发提供准确有效的路由信息。IS-IS路由协议结合自身具有良好的扩展性的特点，实现了对IPv6网络层协议的支持，可以发现和生成IPv6路由。支持IPv6的IS-IS路由协议又称为IS-ISv6动态路由协议。

# 2 IS-IS for IPv6技术实现

为了支持在IPv6环境中运行，指导IPv6报文的转发，IS-ISv6采用NLPID（Network Layer Protocol Identifier，网络层协议标识符）值142（0x8E）来标识IPv6协议，并通过对IS-IS TLV进行简单的扩展，使其能够处理IPv6的路由信息。

## 2.1 IS-ISv6新增TLV

TLV（Type-Length-Value）是LSP（Link State PDU，链路状态协议数据单元）中的一个可变长字段值。为了支持IPv6路由的处理和计算，IS-IS新增了两个TLV，分别是：

·   IPv6 Reachability：类型值为236（0xEC），通过定义路由信息前缀、度量值等信息来说明网络的可达性。

·   IPv6 Interface Address：类型值为232（0xE8），它对应于IPv4中的IP Interface Address TLV，只不过把原来的32比特的IPv4地址改为128比特的IPv6地址。

### 2.1.1 IPv6可达性TLV（IPv6 Reachability TLV）

IS-ISv6中的IPv6可达性TLV对应于IS-IS中的普通可达性TLV和扩展可达性TLV，格式如[图1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/IS-IS_for_IPv6_White_Paper-6W100/?CHID=949128#_Ref164047511)所示。

图1 IPv6可达性TLV

![img](https://resource.h3c.com/cn/201910/25/20191025_4562780_x_Img_x_png_0_1238944_30005_0.png)

 

主要字段的解释如下：

·   Type：取值为236，表示该TLV是IPv6可达性TLV。

·   Length：TLV长度。

·   Metric：度量值，使用扩展的Metric值，取值范围为0～4261412864。度量值大于4261412864的IPv6可达性信息都被忽略掉。

·   U：up/down状态标志位，用来防止路由环路。当某条路由从Level-2路由器传播到Level-1路由器时，这个位被置为1，从而保证了该路由不会被回环。

·   X：外部路由引入标识，取值1表示该路由是从其它协议引入的。

·   S：当TLV中不携带Sub-TLV时，S位置“0”；当S位置“1”时，表示IPv6前缀后面跟随Sub-TLV信息。

·   Reserve：保留位。

·   Prefix Length：IPv6路由的前缀长度。

·   Prefix：该路由器可以到达的IPv6路由前缀。

·   Sub-TLV Length/Sub-TLVs：Sub-TLV字段长度以及Sub-TLVs字段，该选项用于以后扩展用。

### 2.1.2 IPv6接口地址TLV

IPv6接口地址TLV对应于IS-IS中的IPv4接口地址TLV，格式如[图2](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/IS-IS_for_IPv6_White_Paper-6W100/?CHID=949128#_Ref194986311)所示。

图2 IPv6接口地址TLV

![img](https://resource.h3c.com/cn/201910/25/20191025_4562781_x_Img_x_png_1_1238944_30005_0.png)

 

主要字段的解释如下：

·   Type：取值为232，表示该TLV类型是IPv6接口地址TLV。

·   Length：TLV长度。

·   Interface Address：使能IS-ISv6功能接口的IPv6地址，Hello报文中接口IPv6地址TLV填入的是接口的IPv6链路本地地址，LSP报文中填入的是接口的非IPv6链路本地地址，即接口的IPv6全球单播地址。

## 2.2 IS-ISv6邻接关系

IS-IS使用Hello报文来发现同一条链路上的邻居路由器并建立邻接关系，当邻接关系建立完毕后，将继续周期性地发送Hello报文来维持邻接关系。为了支持IPv6路由，建立IPv6邻接关系，IS-ISv6对Hello报文进行了扩充：

·   NLPID是标识IS-IS支持何种网络层协议的一个8比特字段，IS-ISv6对应的NLPID值为142（0x8E）。如果设备支持IS-ISv6功能，那么它必须在Hello报文中携带该值向邻居通告其支持IPv6。

·   在Hello报文中添加IPv6接口地址TLV，Interface Address字段填入使能了IS-ISv6功能接口的IPv6链路本地地址。

# 3 典型组网应用

## 3.1 IS-ISv6在纯IPv6网络组网应用

在一个纯IPv6网络中，要求通过IS-ISv6协议实现网络互通。如[图3](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/IS-IS_for_IPv6_White_Paper-6W100/?CHID=949128#_Ref195002474)所示，Routing Domain 1为一纯IPv6路由域，骨干区和Level-1区域均为纯IPv6区域，所有的路由器都运行IS-ISv6。

图3 纯IPv6网络IS-IS典型组网图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562782_x_Img_x_png_2_1238944_30005_0.png)

 

## 3.2 IS-ISv6应用在IPv4和IPv6共存网络

### 3.2.1 通过构建IPv4和IPv6共存骨干区域实现IPv4/IPv6网络共存组网方案

在一个IPv4/IPv6共存的网络中，要求利用IS-IS和IS-ISv6实现网络互通。

![说明: 说明](https://resource.h3c.com/cn/201910/25/20191025_4562783_x_Img_x_png_3_1238944_30005_0.png)

一个路由域内不能同时存在两个互相独立的纯IPv4骨干区和纯IPv6骨干区，如果需要骨干区同时具有IPv4路由能力和IPv6路由能力，则必须将该骨干区配置为Dual IP。

 

如[图4](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/IS-IS_for_IPv6_White_Paper-6W100/?CHID=949128#_Ref163980831)所示，Routing Domain1为IPv4和IPv6双协议路由域：

·   规划一个双协议栈骨干区域Area 49，骨干区域中的所有IS同时使能IS-IS、IS-ISv6功能；

·   用户根据需要，配置Level-1 Area的区域类型为纯IPv4、纯IPv6或双协议栈。非骨干区Area 49.01为IPv6-Only区域；非骨干区Area 49.02为IPv4-Only区域；非骨干区Area 49.03、Area 49.04为双协议栈区域。

·   经过这种规划而组成的IPv4/IPv6共存网络，Area 49.02、Area 49.03、Area 49.04以及Area 49之间可以实现IPv4互通；Area 49.01、Area 49.03、Area 49.04以及Area 49之间可以实现IPv6互通。

此种IPv4/IPv6共存组网方案配置较为简单，组网框架逻辑清晰，可扩展性很强，用户可以根据需要随时增减Level-1区域，很容易实现IPv4网络向IPv6网络的逐渐过渡。

图4 IPv4/IPv6典型组网

![img](https://resource.h3c.com/cn/201910/25/20191025_4562784_x_Img_x_png_4_1238944_30005_0.png)

 

### 3.2.2 通过GRE隧道技术实现IPv4/IPv6网络共存组网方案

利用GRE隧道技术实现IPv6孤岛跨越IPv4核心网络进行互通，具体解决方法是在两个使能IS-ISv6功能的路由器上配置IPv6 GRE隧道，使得两个路由器在逻辑上直接相连，无需考虑隧道经过的IPv4网络。

如[图5](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/IS-IS_for_IPv6_White_Paper-6W100/?CHID=949128#_Ref18000057)所示，分别在Device A和Device B上创建并配置Tunnel 0，在Tunnel 0上使能IS-ISv6功能。Device A和Device B通过Tunnel 0发送IS-ISv6协议报文并建立邻居关系，这样两个IPv6孤岛就可以进行通信了。

通过GRE隧道技术实现IPv4/IPv6网络共存组网的优点是：

·   不要求所有路由器都运行IS-ISv6，只要IPv6网络内的路由器运行IS-ISv6即可。

·   在IPv4网络内，用户可以根据需要自由选择路由协议。

缺点是配置比较复杂，且需要对整个网络做好规划。

图5 IS-IS for IPv6 over IPv4技术实现IPv4/IPv6共存组网的方案示意图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562785_x_Img_x_png_5_1238944_30005_0.png)

 

### 3.2.3 通过IPv6单播拓扑实现IPv4/IPv6网络共存组网方案

#### 1. 功能简介

在一个IPv4/IPv6共存的网络中，当一些设备和链路不支持IPv6协议时，支持双协议栈的路由器因为无法感知到这些路由器和链路不支持IPv6，仍然会把IPv6报文转发给它们，这就导致IPv6报文由于无法转发而被丢弃。

IS-IS支持IPv6单播拓扑，即IPv4和IPv6分拓扑计算可以解决上面的问题。如[图6](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/IS-IS_for_IPv6_White_Paper-6W100/?CHID=949128#_Ref269477516)所示，图中的数值表示对应链路上的开销值；Device A、Device B和Device D支持IPv4和IPv6双协议栈；Device C只支持IPv4协议，不能转发IPv6报文。

在Device A、Device B和Device D上都配置IS-IS支持IPv6单播拓扑，所有的路由器对于IPv4、IPv6都分为两个拓扑进行计算，则Device A能够感知到Device B和Device C之间、Device C和Device D之间的链路不支持IPv6，即不会将到达Device D的IPv6报文转发给Device B，从而避免报文丢失。

图6 IS-IS支持IPv6单播拓扑功能示意图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562786_x_Img_x_png_6_1238944_30005_0.png)

 

#### 2. 应用限制

在一个区域内配置多拓扑功能需要保证所有设备均配置多拓扑功能，否则可能会导致部分设备无法计算出路由。

# 4 参考文献

·   ISO 10589：ISO IS-IS Routing Protocol

·   RFC 1195：Use of OSI IS-IS for Routing in TCP/IP and Dual Environments

·   RFC 5308：Routing IPv6 with IS-IS 