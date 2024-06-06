# 概述

OSPFv2是IETF组织开发的一个基于链路状态的内部网关协议，具有适应范围广、收敛迅速、无自环、便于层级化网络设计等特点，因此在IPv4网络中获得了广泛应用。

随着IPv6网络的建设，同样需要动态路由协议为IPv6报文的转发提供准确有效的路由信息。基于此，IETF在保留了OSPFv2优点的基础上，针对IPv6网络修改形成了OSPFv3。OSPFv3主要用于在IPv6网络中提供路由功能，是IPv6路由技术中的主流协议。

# 2 OSPFv3技术实现

OSPFv3在工作机制上与OSPFv2基本相同，但为了支持IPv6地址格式，OSPFv3对OSPFv2做了一些改动。下面先对OSPFv2进行简要介绍，之后再详细介绍OSPFv3与OSPFv2的异同点。

## 2.1 OSPFv2简介

### 2.1.1 OSPF基本概念

#### 1. OSPF网络类型

OSPF根据链路层协议类型将网络分为下列四种类型：

·   广播类型：当链路层协议是Ethernet、FDDI时，OSPF认为网络类型是广播。在该类型的网络中，通常以组播形式（224.0.0.5和224.0.0.6）发送协议报文。

·   NBMA类型：当链路层协议是帧中继、ATM或X.25时，OSPF认为网络类型是NBMA。在该类型的网络中，以单播形式发送协议报文。

·   P2MP类型：没有一种链路层协议会被OSPF认为是P2MP类型，只能将其他的网络类型强制更改为点到多点类型。常用做法是将NBMA改为点到多点的网络。在该类型的网络中，缺省情况下，以组播形式（224.0.0.5）发送协议报文。可以根据用户需要，以单播形式发送协议报文。

·   P2P类型：当链路层协议是PPP、HDLC时，OSPF认为网络类型是P2P。在该类型的网络中，以组播形式（224.0.0.5）发送协议报文。

#### 2. DR和BDR

在广播网或NBMA网络中，任意两台路由器之间都要交换路由信息。如果网络中有n台路由器，则需要建立n（n-1）/2个邻接关系。这使得任何一台路由器的路由变化都会导致多次传递，浪费了带宽资源。为解决这一问题，OSPF提出了DR（Designated Router，指定路由器）的概念，所有路由器只将信息发送给DR，由DR将网络链路状态发送出去。

另外，OSPF提出了BDR（Backup Designated Router，备份指定路由器）的概念。BDR是对DR的一个备份，在选举DR的同时也选举出BDR，BDR也和本网段内的所有路由器建立邻接关系并交换路由信息。当DR失效后，BDR会立即成为新的DR。

OSPF网络中，既不是DR也不是BDR的路由器为DR Other。DR Other仅与DR和BDR建立邻接关系，DR Other之间不交换任何路由信息。这样就减少了广播网和NBMA网络上各路由器之间邻接关系的数量，同时减少网络流量，节约了带宽资源。

#### 3. 区域

随着网络规模日益扩大，当一个大型网络中的路由器都运行OSPF路由协议时，会存在以下问题：

·   路由器数量会增多，每台路由器都生成LSA，整个LSDB即所有LSA的集合会非常大，占用大量存储空间。

·   计算最短路径树耗时增加，导致CPU负担很重。

·   在网络规模增大之后，拓扑结构发生变化的概率也会增大，网络会经常处于“震荡”之中，造成网络中大量的OSPF协议报文在传递，降低了网络的带宽利用率。更为严重的是，每一次变化都会导致网络中所有的路由器重新进行路由计算。

OSPF协议通过将自治系统划分成不同的区域来解决上述问题。区域是从逻辑上将路由器划分为不同的组，每个组用区域号ID来标识。

为了适应特定的网络需求，OSPF定义了两种特殊的区域：

(1)   Stub/Totally Stub区域

Stub区域是一些特定的区域，Stub区域的ABR不允许注入Type5 LSA，在这些区域中路由器的路由表规模以及路由信息传递的数量都会大大减少。

为了进一步减少Stub区域中路由器的路由表规模以及路由信息传递的数量，可以将该区域配置为Totally Stub（完全Stub）区域，该区域的ABR不会将区域间的路由信息和外部路由信息传递到本区域。

Stub/Totally Stub区域是一种可选的配置属性，但并不是每个区域都符合配置的条件。通常来说，Stub/Totally Stub区域位于自治系统的边界。

(2)   NSSA/Totally NSSA区域

NSSA（Not-So-Stubby Area）区域是Stub区域的变形，与Stub区域有许多相似的地方。NSSA区域也不允许Type5 LSA注入，但可以允许Type7 LSA注入。Type7 LSA由NSSA区域的ASBR产生，在NSSA区域内传播。当Type7 LSA到达NSSA的ABR时，由ABR将Type7 LSA转换成Type5 LSA，传播到其他区域。

为了进一步阻挡NSSA区域外的其他区域的Type3 LSA注入，可以将该区域配置为Totally NSSA（完全NSSA）区域，该区域的ABR不会将区域间的路由信息传递到本区域。为保证到本自治系统的其他区域的路由依旧可达，该区域的ABR将生成一条缺省路由Type-3 LSA，发布给本区域中的其他非ABR路由器。

#### 4. OSPF协议报文

OSPF有五种类型的协议报文：

·   Hello报文：周期性发送，用来发现和维持OSPF邻居关系。内容包括一些定时器的数值、DR、BDR以及自己已知的邻居。

·   DD报文：描述了本地LSDB中每一条LSA的摘要信息，用于两台路由器进行数据库同步。

·   LSR报文：向对方请求所需的LSA。两台路由器互相交换DD报文之后，得知对端的路由器有哪些LSA是本地的LSDB所缺少的，这时需要发送LSR报文向对方请求所需的LSA。内容包括所需要的LSA的摘要。

·   LSU报文：向对方发送其所需要的LSA。

·   LSAck报文：用来对收到的LSA进行确认。内容是需要确认的LSA的Header（一个报文可对多个LSA进行确认）。

### 2.1.2 OSPF路由计算过程

OSPF协议的路由计算过程可简单描述如下：

·   每台OSPF路由器根据自己周围的网络拓扑结构生成LSA，并通过更新报文将LSA发送给网络中的其它OSPF路由器。

·   每台OSPF路由器都会收集其它路由器通告的LSA，所有的LSA放在一起便组成了LSDB。LSA是对路由器周围网络拓扑结构的描述，LSDB则是对整个自治系统的网络拓扑结构的描述。

·   OSPF路由器将LSDB转换成一张带权的有向图，这张图便是对整个网络拓扑结构的真实反映，各个路由器得到的有向图是完全相同的。

·   每台路由器根据有向图，使用SPF算法计算出一棵以自己为根的最短路径树，这棵树给出了到自治系统中各节点的路由。

## 2.2 OSPFv3与OSPFv2的相同点

OSPFv3在协议设计思路和工作机制与OSPFv2基本一致：

·   报文类型相同：包含Hello、DD、LSR、LSU、LSAck五种类型的报文。

·   区域划分相同。

·   LSA泛洪和同步机制相同：为了保证LSDB内容的正确性，需要保证LSA的可靠泛洪和同步。

·   路由计算方法相同：采用最短路径优先算法计算路由。

·   网络类型相同：支持广播、NBMA、P2MP和P2P四种网络类型。

·   邻居发现和邻接关系形成机制相同：OSPF路由器启动后，便会通过OSPF接口向外发送Hello报文，收到Hello报文的OSPF路由器会检查报文中所定义的参数，如果双方一致就会形成邻居关系。形成邻居关系的双方不一定都能形成邻接关系，这要根据网络类型而定，只有当双方成功交换DD报文，交换LSA并达到LSDB的同步之后，才形成真正意义上的邻接关系。

·   DR选举机制相同：在NBMA和广播网络中需要选举DR和BDR。

## 2.3 OSPFv3与OSPFv2的不同点

为了支持在IPv6环境中运行，指导IPv6报文的转发，OSPFv3对OSPFv2做出了一些必要的改进，使得OSPFv3可以独立于网络层协议，而且只要稍加扩展，就可以适应各种协议，为未来可能的扩展预留了充分的可能。

OSPFv3与OSPFv2不同主要表现在：

·   基于链路的运行

·   使用链路本地地址

·   链路支持多实例复用

·   通过Router ID唯一标识邻居

·   认证的变化

·   Stub区域的支持

·   报文的不同

·   Option字段不同

·   LSA类型、处理方式和格式不同

### 2.3.1 基于链路的运行

OSPFv2是基于网络运行的，两个路由器要形成邻居关系必须在同一个网段。

OSPFv3的实现是基于链路，一条链路可以包含多个子网，节点即使不在同一个子网内，只要在同一链路上就可以直接通信。

### 2.3.2 使用链路本地地址

OSPFv3的路由器使用链路本地地址作为发送报文的源地址。一台路由器可以学习到这条链路上相连的所有其它路由器的链路本地地址，并使用这些链路本地地址作为下一跳来转发报文。但是在虚连接上，必须使用全球范围地址作为OSPFv3协议报文的源地址。

由于链路本地地址只在本链路上有意义且只能在本链路上泛洪，因此链路本地地址只能出现在Link LSA中。

### 2.3.3 链路支持多实例复用

如[图1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/OSPFv3_White_Paper-6W100/?CHID=949121#_Ref17464474)所示，OSPFv3支持在同一链路上运行多个实例，实现链路复用并节约成本。

图1 链路支持多实例复用示意图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562821_x_Img_x_png_0_1238948_30005_0.png)

 

Device A、Device B、Device C和Device D连接到同一个广播网上，它们共享同一条链路。在Device A的Interface A、Device B的Interface B、Device C的Interface C上指定实例1；在Device A的Interface A、Device B的Interface B、Device D的Interface D上指定实例2，实现了Device A、Device B和Device C可以建立邻居关系，Device A、Device B和Device D可以建立邻居关系。

这是通过在OSPFv3报文头中添加Instance ID字段来实现的。如果接口配置的Instance ID与接收的OSPFv3报文的Instance ID不匹配，则丢弃该报文，从而无法建立邻居关系。

### 2.3.4 通过Router ID唯一标识邻居

在OSPFv2中，当网络类型为点到点或者通过虚连接与邻居相连时，通过Router ID来标识邻居路由器，当网络类型为广播或NBMA时，通过邻居接口的IP地址来标识邻居路由器。

OSPFv3取消了这种复杂性，无论对于何种网络类型，都是通过Router ID来唯一标识邻居。

### 2.3.5 认证的变化

OSPFv3协议除了自身可以提供认证功能外，还可以通过使用IPv6提供的安全机制来保证自身报文的合法性。

### 2.3.6 Stub区域的支持

由于OSPFv3支持对未知类型LSA的泛洪，为防止大量未知类型LSA泛洪进入Stub区域，对于向Stub区域泛洪的未知类型LSA进行了明确规定：只有当未知类型LSA的泛洪范围是区域或链路而且U比特没有置位时，未知类型LSA才可以向Stub区域泛洪。

### 2.3.7 报文的不同

OSPFv3报文封装在IPv6报文中，每一种类型的报文均以一个16字节的报文头部开始。

与OSPFv2一样，OSPFv3的五种报文都有同样的报文头，只是报文中的字段有些不同。

OSPFv3的LSU和LSAck报文与OSPFv2相比没有什么变化，但OSPFv3的报文头、Hello与OSPFv2略有不同，报文的改变包括以下几点：

·   版本号从2升级到3。

·   报文头的不同：与OSPFv2报文头相比，OSPFv3报文头长度只有16字节，去掉了认证字段，但增加了Instance ID字段。Instance ID字段用来支持在同一条链路上运行多个实例，且只在链路本地范围内有效。

·   Hello报文的不同：与OSPFv2 Hello报文相比，OSPFv3 Hello报文去掉了网络掩码字段，增加了Interface ID字段，用来标识发送该Hello报文的接口ID。

### 2.3.8 Option字段不同

在OSPFv2中，Option字段出现在每一个Hello报文、DD报文以及每一个LSA中。

在OSPFv3中，Option字段只在Hello报文、DD报文、Router LSA、Network LSA、Inter Area Router LSA以及Link LSA中出现。

OSPFv2的Option字段如[图2](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/OSPFv3_White_Paper-6W100/?CHID=949121#_Ref16580670)所示。

图2 OSPFv2 Option字段格式

![img](https://resource.h3c.com/cn/201910/25/20191025_4562822_x_Img_x_png_1_1238948_30005_0.png)

 

OSPFv3的Option字段如[图3](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/OSPFv3_White_Paper-6W100/?CHID=949121#_Ref16580703)所示。

图3 OSPFv3 Option字段格式

![img](https://resource.h3c.com/cn/201910/25/20191025_4562830_x_Img_x_png_2_1238948_30005_0.png)

 

从上图可以看出，与OSPFv2相比，OSPFv3的Option字段增加了R比特、V比特。其中：

·   R比特：用来标识设备是否是具备转发能力的路由器。如果R比特置0，则表示该节点的路由信息将不会参加路由计算。如果当前设备不想转发目的地址不是本地地址的报文，可以将R比特置0。

·   V比特：如果V比特置0，该路由器或链路不会参加路由计算。

### 2.3.9 LSA类型不同

OSPFv3支持七种类型的LSA。OSPFv3 LSA与OSPFv2 LSA的异同如[表1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/OSPFv3_White_Paper-6W100/?CHID=949121#_Ref17307470)所示。

表1 OSPFv3与OSPFv2 LSA的异同点

| OSPFv2 LSA            | OSPFv3 LSA            | 与OSPFv2   LSA异同点说明                                     |
| --------------------- | --------------------- | ------------------------------------------------------------ |
| Router LSA            | Router LSA            | 名称相同，作用也类似，但是不再描述地址信息，仅仅用来描述路由域的拓扑结构 |
| Network LSA           | Network LSA           |                                                              |
| Network Summary LSA   | Inter Area Prefix LSA | 作用类似，名称不同                                           |
| ASBR Summary LSA      | Inter Area Router LSA |                                                              |
| AS External LSA       | AS External LSA       | 作用与名称完全相同                                           |
| 无                    | Link LSA              | 新增LSA                                                      |
| Intra Area Prefix LSA | 新增LSA               |                                                              |

 

OSPFv3新增了Link LSA和Intra Area Prefix LSA。

·   Router LSA不再包含地址信息，使能OSPFv3的路由器为它所连接的每条链路产生单独的Link LSA，将当前接口的链路本地地址以及路由器在这条链路上的一系列IPv6地址信息向该链路上的所有其它路由器通告。

·   Router LSA和Network LSA中不再包含路由信息，这两类LSA中所携带的路由信息由Intra Area Prefix LSA来描述，该类LSA用来公告一个或多个IPv6地址前缀。

### 2.3.10 扩大了LSA的泛洪范围

LSA的泛洪范围已经被明确地定义在LSA的LS Type字段。目前，有三种LSA泛洪范围：

·   链路本地范围：LSA只在本地链路上泛洪，不会超出这个范围，该范围适用于新定义的Link LSA。

·   区域范围：LSA的泛洪范围仅仅覆盖一个单独的OSPFv3区域。Router LSA、Network LSA、Inter Area Prefix LSA、Inter Area Router LSA和Intra Area Prefix LSA都是区域范围泛洪的LSA。

·   自治系统范围：LSA将被泛洪到整个路由域，AS External LSA就是自治系统范围泛洪的LSA。

### 2.3.11 支持对未知类型LSA的处理

在OSPFv2中，收到类型未知的LSA将直接丢弃。

OSPFv3在LSA的LS Type字段中增加了一个U比特位来位标识对未知类型LSA的处理方式：

·   如果U比特置1，则对于未知类型的LSA按照LSA中的LS Type字段描述的泛洪范围进行泛洪。

·   如果U比特置0，对于未知类型的LSA仅在链路范围内泛洪。

### 2.3.12 LSA报文格式不同

OSPFv3 LSA封装在LSA头的后面，下面将重点介绍OSPFv3与OSPFv2在LSA头以及LSA内容上的不同点。

#### 1. LSA头

如[图4](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/OSPFv3_White_Paper-6W100/?CHID=949121#_Ref16582349)所示，与OSPFv2相比，OSPFv3的LSA头部取消了Options字段，且Link State ID不再有具体的含义，而是由当前路由器随机生成，用来同Advertising Router、LS Sequence Number字段一同标识一个LSA。

图4 OSPFv2 LSA头和OSPFv3 LSA头格式对比

![img](https://resource.h3c.com/cn/201910/25/20191025_4562831_x_Img_x_png_3_1238948_30005_0.png)

 

OSPFv2中的LS Type长度为8比特，标识LSA的类型；OSPFv3的LS Type字段由OSPFv2的8比特扩充为16比特，具体如[图5](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/OSPFv3_White_Paper-6W100/?CHID=949121#_Ref17464901)所示。

图5 OSPFv3 LS Type字段

![img](https://resource.h3c.com/cn/201910/25/20191025_4562832_x_Img_x_png_4_1238948_30005_0.png)

 

OSPFv3的LS Type字段中U位、S2位、S1位和LSA Function Code的含义如下：

·   U位：描述了路由器收到一个类型未知的LSA时如何处理。

¡   取值为0：表示把未知类型的LSA当成具有链路本地范围的LSA处理。

¡   取值为1：表示按照S2/S1位标识的泛洪范围来处理。

·   S2/S1位：共同标识LSA的泛洪范围。

¡   取值00：表示LSA只在产生该LSA的本地链路上泛洪。

¡   取值01：表示LSA的泛洪范围为产生该LSA的路由器所在区域。

¡   取值10：表示LSA将在整个自治系统内进行泛洪。

¡   取值11：保留。

·   LSA Function Code：LSA类型编码，描述LSA的类型，类型编码取值与LSA类型的对应关系如[表2](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/OSPFv3_White_Paper-6W100/?CHID=949121#_Ref16582704)所示。

表2 类型编码取值与LSA类型对应关系

| 类型编码取值 | LSA类型               |
| ------------ | --------------------- |
| 1            | Router LSA            |
| 2            | Network LSA           |
| 3            | Inter Area Prefix LSA |
| 4            | Inter Area Router LSA |
| 5            | AS External LSA       |
| 7            | NSSA LSA              |
| 8            | Link LSA              |
| 9            | Intra Area Prefix LSA |

 

#### 2. Router LSA

OSPFv2的Router LSA格式如[图6](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/OSPFv3_White_Paper-6W100/?CHID=949121#_Ref16582769)所示。

图6 OSPFv2 Router LSA格式

![img](https://resource.h3c.com/cn/201910/25/20191025_4562833_x_Img_x_png_5_1238948_30005_0.png)

 

OSPFv3的Router LSA格式如[图7](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/OSPFv3_White_Paper-6W100/?CHID=949121#_Ref16582809)所示。与OSPFv2相比，OSPFv3的Router LSA格式变化比较大：

·   新增了Options字段，用来标识该路由器支持的功能。

·   取消了用来描述路由器连接数量的连接数字段#Links。

·   对链路的描述方式发生改变，通过Interface ID、Neighbor Interface ID和Neighbor Router ID进行综合描述。

与OSPFv2不同的字段解释如下：

·   W：Wild-card，用于MOSPF，目前我司不支持。

·   Interface ID：所描述链路的本地接口ID。

·   Neighbor Interface ID：所描述链路的邻居路由器的接口ID。

·   Neighbor Router：所描述链路的邻居路由器ID。

图7 OSPFv3 Router LSA格式

![img](https://resource.h3c.com/cn/201910/25/20191025_4562834_x_Img_x_png_6_1238948_30005_0.png)

 

#### 3. Network LSA

如[图8](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/OSPFv3_White_Paper-6W100/?CHID=949121#_Ref17464582)所示，OSPFv3的Network LSA中新增了Option字段，减少了Network Mask字段。

当网络类型为广播网和NBMA时，OSPFv3的Network LSA仅仅描述了连接到链路上的所有路由器，包括DR本身，由于不包含Network Mask字段，OSPFv3的Network LSA仅描述了拓扑信息，不再描述路由信息。

图8 OSPFv2 Network LSA和OSPFv3 Network LSA格式对比

![img](https://resource.h3c.com/cn/201910/25/20191025_4562835_x_Img_x_png_7_1238948_30005_0.png)

 

#### 4. Inter Area Prefix LSA

Inter Area Prefix LSA的LSA类型编码为3，相当于OSPFv2的Network Summary LSA。该LSA通过PrefixLength、PrefixOptions以及Address Prefix来描述到达区域外的IPv6地址前缀的路径信息。每一个IPv6地址前缀都会产生一个单独的Inter Area Prefix LSA。

对于Stub区域，Inter Area Prefix LSA还可以用来描述缺省路由，描述缺省路由时前缀长度取值为0。

OSPFv2的Network Summary LSA格式如[图9](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/OSPFv3_White_Paper-6W100/?CHID=949121#_Ref16583046)所示。

图9 OSPFv2 Network Summary LSA格式

![img](https://resource.h3c.com/cn/201910/25/20191025_4562836_x_Img_x_png_8_1238948_30005_0.png)

 

OSPFv3的Inter Area Prefix LSA格式如[图10](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/OSPFv3_White_Paper-6W100/?CHID=949121#_Ref16583051)所示。

图10 OSPFv3 Inter Area Prefix LSA格式

![img](https://resource.h3c.com/cn/201910/25/20191025_4562837_x_Img_x_png_9_1238948_30005_0.png)

 

OSPFv3的Inter Area Prefix LSA与OSPFv2 Network Summary LSA不同字段解释如下：

·   PrefixLength：IPv6地址前缀长度。

·   PrefixOptions：IPv6地址前缀选项，用来标识前缀的功能。根据前缀选项的设置，在路由计算过程中允许某些前缀被忽略，或者标识为不用重新公告。

·   Address Prefix：IPv6地址前缀。

如[图11](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/OSPFv3_White_Paper-6W100/?CHID=949121#_Ref17464724)所示，前缀选项的长度为一个字节，各字段含义为：

·   P（Propagate）：传播功能位，在NSSA前缀上设置，置1表示该前缀应该在NSSA区域边界重新公告。

·   MC（Multicast）：多播功能位，置位表示该前缀应该包含在IPv6多播路由计算中。

·   LA（Local Address）：本地地址功能位，置位表示该前缀就是发出该LSA的路由器接口的IPv6地址。

·   NU（No Unicast）：非单播功能位，置位表示该前缀不会包括在IPv6单播路由计算中。

图11 OSPFv3 PrefixOption

![img](https://resource.h3c.com/cn/201910/25/20191025_4562823_x_Img_x_png_10_1238948_30005_0.png)

 

#### 5. Inter Area Router LSA

Inter Area Prefix LSA的LSA类型编码为4，相当于OSPFv2中的ASBR Summary LSA。OSPFv2的ASBR Summary LSA格式与Network Summary LSA相同，如[图9](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/OSPFv3_White_Paper-6W100/?CHID=949121#_Ref16583046)所示。

OSPFv3的Inter Area Router LSA格式如[图12](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/OSPFv3_White_Paper-6W100/?CHID=949121#_Ref17464743)所示。主要字段描述如下：

·   Metric：到达区域外的目的路由器的路径开销。

·   Destination Router ID：区域外的目的路由器的Router ID。

图12 OSPFv3的Inter Area Router LSA格式

![img](https://resource.h3c.com/cn/201910/25/20191025_4562824_x_Img_x_png_11_1238948_30005_0.png)

 

#### 6. AS External LSA

AS External LSA的LSA类型编码为5，与OSPFv2中的AS External LSA作用相同。

OSPFv2的AS External LSA格式如[图13](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/OSPFv3_White_Paper-6W100/?CHID=949121#_Ref17464755)所示。

图13 OSPFv2的AS External LSA格式

![img](https://resource.h3c.com/cn/201910/25/20191025_4562825_x_Img_x_png_12_1238948_30005_0.png)

 

OSPFv3的AS External LSA格式如[图14](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/OSPFv3_White_Paper-6W100/?CHID=949121#_Ref17464764)所示。OSPFv3的AS External LSA与OSPFv2 AS External LSA不同字段解释如下：

·   Address Prefix、PrefixLength、PrefixOptions共同标记了一个自治系统外部的一个IPv6地址前缀。

·   Referenced LS Type：引用的LSA的类型。如果该字段非0，则会有一个LSA与该LSA相关，Referenced LS Type为与该LSA相关的LSA类型。

·   Referenced Link State ID：引用的LSA的Link State ID，目前我司不支持。

图14 OSPFv3的AS External LSA格式

![img](https://resource.h3c.com/cn/201910/25/20191025_4562826_x_Img_x_png_13_1238948_30005_0.png)

 

#### 7. Link LSA

Link LSA的LSA类型编码为8，每个路由器都为它所连接的每条链路产生单独的Link LSA。

通过使用Link LSA：

·   路由器可以把当前接口的链路本地地址向该链路上的所有其它路由器通告。

·   把自己在这条链路上的一系列IPv6地址信息向该链路上的所有其它路由器通告。

·   为Network LSA收集Option位。

Link LSA的报文格式如[图15](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/OSPFv3_White_Paper-6W100/?CHID=949121#_Ref17464771)所示。

图15 OSPFv3 Link LSA

![img](https://resource.h3c.com/cn/201910/25/20191025_4562827_x_Img_x_png_14_1238948_30005_0.png)

 

主要字段解释如下：

·   Router Priority：路由器优先级。

·   Options：代表当前路由器支持的可选性能。一个链路上的所有Link LSA的能力并集是Network LSA的能力。

·   Link Local Interface Address：链路本地接口地址。

·   #Prefixes：该LSA中所包含的IPv6地址前缀个数。

#### 8. Intra Area Prefix LSA

Intra Area Prefix LSA的LSA类型编码为9，OSPFv3的设计思想之一就是拓扑信息和路由信息分离，即计算拓扑的基本LSA（Router LSA和Network LSA）中不再含有路由信息。所以原来OSPFv2中这两类LSA中所携带的路由信息由新的LSA来描述，于是引入了Intra Area Prefix LSA。

路由器使用Intra Area Prefix LSA来公告一个或多个IPv6地址前缀，这些地址前缀信息描述如下路由信息：

·   描述路由器自身的路由信息。

·   描述路由器连接到的一个Stub网络的路由信息。

·   描述路由器连接到的一个传输网络的路由信息。

Intra Area Prefix LSA的报文格式如[图16](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/OSPFv3_White_Paper-6W100/?CHID=949121#_Ref16583507)所示。

图16 OSPFv3 Intra Area Prefix LSA

![img](https://resource.h3c.com/cn/201910/25/20191025_4562828_x_Img_x_png_15_1238948_30005_0.png)

 

Intra Area Prefix LSA描述了Router LSA和Network LSA所携带的路由信息，因此在Intra Area Prefix LSA中需要标明该LSA引用的Router LSA或Network LSA，这是通过Referenced LS Type、Referenced Link State ID和Referenced Advertising Router字段来联合标识的。

主要字段的解释如下：

·   # Prefixes：包含的IPv6地址前缀的个数。

·   Referenced LS Type：引用LSA的类型，取值为1表明该LSA与Router LSA相关，取值为2表明该LSA与Network LSA相关。

·   Referenced Link State ID：引用LSA的Link State ID。如果引用的是Router LSA，此字段值为0；如果引用的是Network LSA，此字段值为DR在该条链路上的Interface ID。

·   Referenced Advertising Router：引用LSA的发布路由器。如果引用的是Router LSA，此字段值为产生该LSA路由器的Router ID；如果引用的是Network LSA，此字段值为DR的Router ID。

# 3 典型组网应用

如[图17](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/OSPFv3_White_Paper-6W100/?CHID=949121#_Ref16584014)所示，Device A～Device D均运行OSPFv3协议。整个自治系统划分为3个区域。其中Device B和Device C作为ABR来转发区域之间的路由。将Area2配置为Stub区域，减少通告到此区域内的LSA数量，但不影响路由的可达性。

图17 OSPFv3典型应用组网图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562829_x_Img_x_png_16_1238948_30005_0.png)

 

# 4 参考文献

·   RFC 3101：The OSPF Not-So-Stubby Area (NSSA) Option

·   RFC 5340：OSPF for IPv6

#  配置OSPF引入自治系统外部路由

## 1.1 简介

本案例介绍OSPF引入自治系统外部路由的配置方法。

## 1.2 组网需求

如[图1](https://www.h3c.com/cn/d_202303/1816252_30005_0.htm#_Ref80955109)所示，Switch A、Switch B、Switch C和Switch D运行OSPF；Switch C和Switch E运行静态路由。整个自治系统划分为3个区域。具体应用需求如下：

·   Switch A和Switch B作为ABR来转发区域之间的路由。

·   Switch C作为ASBR引入外部路由（静态路由），要求路由信息可正确的在AS内传播。

图1 OSPF引入自治系统外部路由组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774728_x_Img_x_png_0_1816252_30005_0.png)

 

## 1.3 数据规划

| 设备                                                 | Router ID                          | 接口和IP地址                                         | 网段和区域                         |
| ---------------------------------------------------- | ---------------------------------- | ---------------------------------------------------- | ---------------------------------- |
| Switch A                                             | 1.1.1.1                            | 物理接口：GE1/0/1  VLAN：100  IP地址：192.168.0.1/24 | 网段：192.168.0.0/24  区域：area 0 |
| 物理接口：GE1/0/2  VLAN：200  IP地址：192.168.1.1/24 | 网段：192.168.1.0/24  区域：area 1 |                                                      |                                    |
| Switch B                                             | 2.2.2.2                            | 物理接口：GE1/0/1  VLAN：100  IP地址：192.168.0.2/24 | 网段：192.168.0.0/24  区域：area 0 |
| 物理接口：GE1/0/2  VLAN：200  IP地址：192.168.2.1/24 | 网段：192.168.2.0/24  区域：area 2 |                                                      |                                    |
| Switch C                                             | 3.3.3.3                            | 物理接口：GE1/0/1  VLAN：300  IP地址：172.16.1.1/24  | 网段：172.16.1.0/24  区域：area 1  |
| 物理接口：GE1/0/2  VLAN：200  IP地址：192.168.1.2/24 | 网段：192.168.1.0/24  区域：area 1 |                                                      |                                    |
| Switch D                                             | 4.4.4.4                            | 物理接口：GE1/0/1  VLAN：300  IP地址：172.17.1.1/24  | 网段：172.17.1.0/24  区域：area 2  |
| 物理接口：GE1/0/2  VLAN：200  IP地址：192.168.2.2/24 | 网段：192.168.2.0/24  区域：area 2 |                                                      |                                    |
| Switch E                                             | -                                  | 物理接口：GE1/0/1  VLAN：300  IP地址：172.16.1.2/24  | 网段：172.16.1.0/24                |
| 物理接口：GE1/0/2  VLAN：400  IP地址：10.10.10.1/24  | 网段：10.10.10.0/24                |                                                      |                                    |
| Host A                                               | -                                  | IP地址：10.10.10.2/24                                | 网段：10.10.10.0/24                |
| Host B                                               | -                                  | IP地址：172.17.1.2/24                                | 网段：172.17.1.0/24                |

 

## 1.4 配置步骤

#### 1. Switch A的配置

\# 创建VLAN 100和VLAN 200，将接口GE1/0/1加入VLAN 100、接口GE1/0/2加入VLAN 200，并配置VLAN 100的IP地址为192.168.0.1/24，VLAN 200的IP地址为192.168.1.1/24。

<Switch A> system-view

[Switch A] vlan 100

[Switch A-vlan100] port gigabitethernet 1/0/1

[Switch A-vlan100] quit

[Switch A] vlan 200

[Switch A-vlan200] port gigabitethernet 1/0/2

[Switch A-vlan200] quit

[Switch A] interface vlan 100

[Switch A-Vlan-interface100] ip address 192.168.0.1 255.255.255.0

[Switch A-Vlan-interface100] quit

[Switch A] interface vlan 200

[Switch A-Vlan-interface200] ip address 192.168.1.1 255.255.255.0

[Switch A-Vlan-interface200] quit

\# 配置全局Router ID为1.1.1.1。

[Switch A] router id 1.1.1.1

\# 启动OSPF进程1，创建区域0，并通告192.168.0.0/24网段；创建区域1，并通告192.168.1.0/24网段。

[Switch A] ospf 1

[Switch A-ospf-1] area 0

[Switch A-ospf-1-area-0.0.0.0] network 192.168.0.0 0.0.0.255

[Switch A-ospf-1-area-0.0.0.0] quit

[Switch A-ospf-1] area 1

[Switch A-ospf-1-area-0.0.0.1] network 192.168.1.0 0.0.0.255

[Switch A-ospf-1] quit

\# 保存配置。

[Switch A] save force

#### 2. Switch B的配置

\# 创建VLAN 100和VLAN 200，将接口GE1/0/1加入VLAN 100、接口GE1/0/2加入VLAN 200，并配置VLAN 100的IP地址为192.168.0.2/24，VLAN 200的IP地址为192.168.2.1/24。

<Switch B> system-view

[Switch B] vlan 100

[Switch B-vlan100] port gigabitethernet 1/0/1

[Switch B-vlan100] quit

[Switch B] vlan 200

[Switch B-vlan200] port gigabitethernet 1/0/2

[Switch B-vlan200] quit

[Switch B] interface vlan 100

[Switch B-Vlan-interface100] ip address 192.168.0.2 255.255.255.0

[Switch B-Vlan-interface100] quit

[Switch B] interface vlan 200

[Switch B-Vlan-interface200] ip address 192.168.2.1 255.255.255.0

[Switch B-Vlan-interface200] quit

\# 配置全局Router ID为2.2.2.2。

[Switch B] router id 2.2.2.2

\# 启动OSPF进程1，创建区域0，并通告192.168.0.0/24网段；创建区域2，并通告192.168.2.0/24网段。

[Switch B] ospf 1

[Switch B-ospf-1] area 0

[Switch B-ospf-1-area-0.0.0.0] network 192.168.0.0 0.0.0.255

[Switch B-ospf-1-area-0.0.0.0] quit

[Switch B-ospf-1] area 2

[Switch B-ospf-1-area-0.0.0.2] network 192.168.2.0 0.0.0.255

[Switch B-ospf-1-area-0.0.0.2] quit

[Switch B-ospf-1] quit

\# 保存配置。

[Switch B] save force

#### 3. Switch C的配置

\# 创建VLAN 200和VLAN 300，将接口GE1/0/1加入VLAN 300、接口GE1/0/2加入VLAN 200，并配置VLAN 300的IP地址为172.16.1.1/24，VLAN 200的IP地址为192.168.1.2/24。

<Switch C> system-view

[Switch C] vlan 300

[Switch C-vlan300] port gigabitethernet 1/0/1

[Switch C-vlan300] quit

[Switch C] vlan 200

[Switch C-vlan200] port gigabitethernet 1/0/2

[Switch C-vlan200] quit

[Switch C] interface vlan 300

[Switch C-Vlan-interface300] ip address 172.16.1.1 255.255.255.0

[Switch C-Vlan-interface300] quit

[Switch C] interface vlan 200

[Switch C-Vlan-interface200] ip address 192.168.1.2 255.255.255.0

[Switch C-Vlan-interface200] quit

\# 配置静态路由，其目的网段为10.10.10.0/24，下一跳为172.16.1.2。

[Switch C] ip route-static 10.10.10.0 24 172.16.1.2

\# 配置全局Router ID为3.3.3.3。

[Switch C] router id 3.3.3.3

\# 启动OSPF进程1，创建区域1，并通告192.168.1.0/24网段和172.16.1.0/24网段。

[Switch C] ospf 1

[Switch C-ospf-1] area 1

[Switch C-ospf-1-area-0.0.0.1] network 192.168.1.0 0.0.0.255

[Switch C-ospf-1-area-0.0.0.1] network 172.16.1.0 0.0.0.255

[Switch C-ospf-1-area-0.0.0.1] quit

\# 配置OSPF引入静态路由。

[Switch C-ospf-1] import-route static

[Switch C-ospf-1] quit

\# 保存配置。

[Switch C] save force

#### 4. Switch D的配置

\# 创建VLAN 200和VLAN 300，将接口GE1/0/1加入VLAN 300、接口GE1/0/2加入VLAN 200，并配置VLAN 300的IP地址为172.17.1.1/24，VLAN 200的IP地址为192.168.2.2/24。

<Switch D> system-view

[Switch D] vlan 300

[Switch D-vlan300] port gigabitethernet 1/0/1

[Switch D-vlan300] quit

[Switch D] vlan 200

[Switch D-vlan200] port gigabitethernet 1/0/2

[Switch D-vlan200] quit

[Switch D] interface vlan 300

[Switch D-Vlan-interface300] ip address 172.17.1.1 255.255.255.0

[Switch D-Vlan-interface300] quit

[Switch D] interface vlan 200

[Switch D-Vlan-interface200] ip address 192.168.2.2 255.255.255.0

[Switch D-Vlan-interface200] quit

\# 配置全局Router ID为4.4.4.4。

[Switch D] router id 4.4.4.4

\# 启动OSPF进程1，创建区域2，并通告192.168.2.0/24网段和172.17.1.0/24网段。

[Switch D] ospf 1

[Switch D-ospf-1] area 2

[Switch D-ospf-1-area-0.0.0.2] network 192.168.2.0 0.0.0.255

[Switch D-ospf-1-area-0.0.0.2] network 172.17.1.0 0.0.0.255

[Switch D-ospf-1-area-0.0.0.2] quit

[Switch D-ospf-1] quit

\# 保存配置。

[Switch D] save force

#### 5. Switch E的配置

\# 创建VLAN 300和VLAN 400，将接口GE1/0/1加入VLAN 300、接口GE1/0/2加入VLAN 400，并配置VLAN 300的IP地址为172.16.1.2/24，VLAN 400的IP地址为10.10.10.1/24。

<Switch E> system-view

[Switch E] vlan 300

[Switch E-vlan300] port gigabitethernet 1/0/1

[Switch E-vlan300] quit

[Switch E] vlan 400

[Switch E-vlan400] port gigabitethernet 1/0/2

[Switch E-vlan400] quit

[Switch E] interface vlan 300

[Switch E-Vlan-interface300] ip address 172.16.1.2 255.255.255.0

[Switch E-Vlan-interface300] quit

[Switch E] interface vlan 400

[Switch E-Vlan-interface400] ip address 10.10.10.1 255.255.255.0

[Switch E-Vlan-interface400] quit

\# 配置缺省路由，下一跳为172.16.1.1。

[Switch E] ip route-static 0.0.0.0 0 172.16.1.1

\# 保存配置。

[Switch E] save force

## 1.5 验证配置

\# 查看Switch A的路由表，存在到172.16.1.0、172.17.1.0、192.168.2.0的路由，以及学习到的外部引入的静态路由。

[Switch A] display ip routing-table

Destinations : 20    Routes : 20

 

Destination/Mask  Proto  Pre Cost    NextHop     Interface

 

0.0.0.0/32     Direct 0  0      127.0.0.1    InLoop0

10.10.10.0/24   O_ASE2 150 1      192.168.1.2   Vlan200

127.0.0.0/8    Direct 0  0      127.0.0.1    InLoop0

127.0.0.0/32    Direct 0  0      127.0.0.1    InLoop0

127.0.0.1/32    Direct 0  0      127.0.0.1    InLoop0

127.255.255.255/32 Direct 0  0      127.0.0.1    InLoop0

172.16.1.0/24   O_INTRA 10 2      192.168.1.2   Vlan200

172.17.1.0/24   O_INTER 10 3      192.168.0.2   Vlan100

192.168.0.0/24   Direct 0  0      192.168.0.1   Vlan100

192.168.0.0/32   Direct 0  0      192.168.0.1   Vlan100

192.168.0.1/32   Direct 0  0      127.0.0.1    InLoop0

192.168.0.255/32  Direct 0  0      192.168.0.1   Vlan100

192.168.1.0/24   Direct 0  0      192.168.1.1   Vlan200

192.168.1.0/32   Direct 0  0      192.168.1.1   Vlan200

192.168.1.1/32   Direct 0  0      127.0.0.1    InLoop0

192.168.1.255/32  Direct 0  0      192.168.1.1   Vlan200

192.168.2.0/24   O_INTER 10 2      192.168.0.2   Vlan100

224.0.0.0/4    Direct 0  0      0.0.0.0     NULL0

224.0.0.0/24    Direct 0  0      0.0.0.0     NULL0

255.255.255.255/32 Direct 0  0      127.0.0.1    InLoop0

\# Host A可以ping通Host B。

C:\Users\HostA>ping 172.17.1.2

正在 Ping 172.17.1.2 具有 32 字节的数据:

来自 172.17.1.2 的回复: 字节=32 时间=3ms TTL=255

来自 172.17.1.2 的回复: 字节=32 时间=1ms TTL=255

来自 172.17.1.2 的回复: 字节=32 时间<1ms TTL=255

来自 172.17.1.2 的回复: 字节=32 时间=2ms TTL=255

 

172.17.1.2 的 Ping 统计信息:

  数据包: 已发送 = 4，已接收 = 4，丢失 = 0 (0% 丢失)，

往返行程的估计时间(以毫秒为单位):

  最短 = 0ms，最长 = 3ms，平均 = 1ms

## 1.6 配置文件

·   Switch A：

\#

 router id 1.1.1.1

\#

ospf 1

 area 0.0.0.0

 network 192.168.0.0 0.0.0.255

 area 0.0.0.1

 network 192.168.1.0 0.0.0.255

\#

interface Vlan-interface100

 ip address 192.168.0.1 255.255.255.0

\#

interface Vlan-interface200

 ip address 192.168.1.1 255.255.255.0

\#

interface GigabitEthernet1/0/1

 port access vlan 100

\#

interface GigabitEthernet1/0/2

 port access vlan 200

\#

·   Switch B：

\#

 router id 2.2.2.2

\#

ospf 1

 area 0.0.0.0

 network 192.168.0.0 0.0.0.255

 area 0.0.0.2

 network 192.168.2.0 0.0.0.255

\#

interface Vlan-interface100

 ip address 192.168.0.2 255.255.255.0

\#

interface Vlan-interface200

 ip address 192.168.2.1 255.255.255.0

\#

interface GigabitEthernet1/0/1

 port access vlan 100

\#

interface GigabitEthernet1/0/2

 port access vlan 200

\#

·   Switch C：

\#

 router id 3.3.3.3

\#

ospf 1

 area 0.0.0.1

 network 192.168.1.0 0.0.0.255

 network 172.16.1.0 0.0.0.255

\#

interface Vlan-interface200

 ip address 192.168.1.2 255.255.255.0

\#

interface Vlan-interface300

 ip address 172.16.1.1 255.255.255.0

\#

interface GigabitEthernet1/0/1

 port access vlan 300

\#

interface GigabitEthernet1/0/2

 port access vlan 200

\#

·   Switch D：

\#

 router id 4.4.4.4

\#

ospf 1

 area 0.0.0.2

 network 192.168.2.0 0.0.0.255

 network 172.17.1.0 0.0.0.255

\#

interface Vlan-interface200

 ip address 192.168.2.2 255.255.255.0

\#

interface Vlan-interface300

 ip address 172.17.1.1 255.255.255.0

\#

interface GigabitEthernet1/0/1

 port access vlan 300

\#

interface GigabitEthernet1/0/2

 port access vlan 200

 

\#

·   Switch E：

\#

interface Vlan-interface200

 ip address 10.10.10.1 255.255.255.0

\#

interface Vlan-interface300

 ip address 172.16.1.2 255.255.255.0

\#

interface GigabitEthernet1/0/1

 port access vlan 300

\#

interface GigabitEthernet1/0/2

 port access vlan 200

\#

 ip route-static 0.0.0.0 0 172.16.1.1

\#

## 1.7 相关资料

·   产品配套“三层技术-IP路由配置指导”中的“OSPF”。

·   产品配套“三层技术-IP路由命令参考”中的“OSPF”。



 

# 2 单区域OSPF基本功能配置

## 2.1 简介

本案例介绍单区域OSPF基本功能的配置方法。

## 2.2 组网需求

如[图2](https://www.h3c.com/cn/d_202303/1816252_30005_0.htm#_Ref80972225)所示，Switch A和Switch B运行OSPF，要求Host A和Host B通过运行OSPF协议的Switch A和Switch B实现互联互通。

图2 单区域OSPF基本功能组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774729_x_Img_x_png_1_1816252_30005_0.png)

 

## 2.3 配置步骤

#### 1. Switch A的配置

\# 创建VLAN 10和VLAN 20，将接口GE1/0/1加入VLAN 10、接口GE1/0/2加入VLAN 20，并配置VLAN 10的IP地址为192.168.10.1/24，VLAN 20的IP地址为192.168.20.1/24。

<Switch A> system-view

[Switch A] vlan 10

[Switch A-vlan10] port gigabitethernet 1/0/1

[Switch A-vlan10] quit

[Switch A] vlan 20

[Switch A-vlan20] port gigabitethernet 1/0/2

[Switch A-vlan20] quit

[Switch A] interface vlan 10

[Switch A-Vlan-interface10] ip address 192.168.10.1 255.255.255.0

[Switch A-Vlan-interface10] quit

[Switch A] interface vlan 20

[Switch A-Vlan-interface20] ip address 192.168.20.1 255.255.255.0

[Switch A-Vlan-interface20] quit

\# 配置全局Router ID为1.1.1.1。

[Switch A] router id 1.1.1.1

\# 启动OSPF进程1，创建区域0，并通告192.168.10.0/24网段和192.168.20.0/24网段。

[Switch A] ospf 1

[Switch A-ospf-1] area 0

[Switch A-ospf-1-area-0.0.0.0] network 192.168.10.0 0.0.0.255

[Switch A-ospf-1-area-0.0.0.0] network 192.168.20.0 0.0.0.255

[Switch A-ospf-1-area-0.0.0.0] quit

[Switch A-ospf-1] quit

\# 保存配置。

[Switch A] save force

#### 2. Switch B的配置

\# 创建VLAN 20和VLAN 30，将接口GE1/0/1加入VLAN 30、接口GE1/0/2加入VLAN 20，并配置VLAN 30的IP地址为192.168.30.1/24，VLAN 20的IP地址为192.168.20.2/24。

<Switch B> system-view

[Switch B] vlan 30

[Switch B-vlan30] port gigabitethernet 1/0/1

[Switch B-vlan30] quit

[Switch B] vlan 20

[Switch B-vlan20] port gigabitethernet 1/0/2

[Switch B-vlan20] quit

[Switch B] interface vlan 30

[Switch B-Vlan-interface30] ip address 192.168.30.1 255.255.255.0

[Switch B-Vlan-interface30] quit

[Switch B] interface vlan 20

[Switch B-Vlan-interface20] ip address 192.168.20.2 255.255.255.0

[Switch B-Vlan-interface20] quit

\# 配置全局Router ID为2.2.2.2。

[Switch B] router id 2.2.2.2

\# 启动OSPF进程1，创建区域0，并通告192.168.20.0/24网段和192.168.30.0/24网段。

[Switch B] ospf 1

[Switch B-ospf-1] area 0

[Switch B-ospf-1-area-0.0.0.0] network 192.168.20.0 0.0.0.255

[Switch B-ospf-1-area-0.0.0.0] network 192.168.30.0 0.0.0.255

[Switch B-ospf-1-area-0.0.0.0] quit

[Switch B-ospf-1] quit

\# 保存配置。

[Switch B] save force

## 2.4 验证配置

\# 查看Switch A的OSPF邻居。

[Switch A] display ospf peer

 

​     OSPF Process 1 with Router ID 1.1.1.1

​        Neighbor Brief Information

 

 Area: 0.0.0.0

 Router ID    Address     Pri Dead-Time State       Interface

 2.2.2.2     192.168.20.2  1  30     Full/DR -     Vlan20

\# 查看Switch A的OSPF路由信息。

[Switch A] display ospf routing

 

​     OSPF Process 1 with Router ID 1.1.1.1

 

​          Routing Table

 

​        Topology base (MTID 0)

 

 Routing for network

 

 Destination    Cost   Type  NextHop     AdvRouter    Area

 192.168.10.0/24  1    Stub  0.0.0.0     192.168.20.1  0.0.0.0

 192.168.30.0/24  2    Stub  192.168.20.2  192.168.20.2  0.0.0.0

 192.168.20.0/24  1    Transit 0.0.0.0     192.168.20.1  0.0.0.0

\# 查看Switch A的路由表信息，存在到达192.168.30.0/24网段的路由。

[Switch A] display ip routing-table

 

Destinations : 17    Routes : 17

 

Destination/Mask  Proto  Pre Cost    NextHop     Interface

 

0.0.0.0/32     Direct 0  0      127.0.0.1    InLoop0

127.0.0.0/8    Direct 0  0      127.0.0.1    InLoop0

127.0.0.0/32    Direct 0  0      127.0.0.1    InLoop0

127.0.0.1/32    Direct 0  0      127.0.0.1    InLoop0

127.255.255.255/32 Direct 0  0      127.0.0.1    InLoop0

192.168.10.0/24  Direct 0  0      192.168.10.1  Vlan10

192.168.10.0/32  Direct 0  0      192.168.10.1  Vlan10

192.168.10.1/32  Direct 0  0      127.0.0.1    InLoop0

192.168.10.255/32 Direct 0  0      192.168.10.1  Vlan10

192.168.20.0/24  Direct 0  0      192.168.20.1  Vlan20

192.168.20.0/32  Direct 0  0      192.168.20.1  Vlan20

192.168.20.1/32  Direct 0  0      127.0.0.1    InLoop0

192.168.20.255/32 Direct 0  0      192.168.20.1  Vlan20

192.168.30.0/24  O_INTRA 10 2      192.168.20.2  Vlan20

224.0.0.0/4     Direct 0  0      0.0.0.0     NULL0

224.0.0.0/24    Direct 0  0      0.0.0.0     NULL0

255.255.255.255/32 Direct 0  0      127.0.0.1    InLoop0

\# Host A可以ping通Host B。

C:\Users\HostA>ping 192.168.30.2

正在 Ping 192.168.30.2 具有 32 字节的数据:

来自 192.168.30.2 的回复: 字节=32 时间=3ms TTL=255

来自 192.168.30.2 的回复: 字节=32 时间=1ms TTL=255

来自 192.168.30.2 的回复: 字节=32 时间<1ms TTL=255

来自 192.168.30.2 的回复: 字节=32 时间=2ms TTL=255

 

192.168.30.2 的 Ping 统计信息:

  数据包: 已发送 = 4，已接收 = 4，丢失 = 0 (0% 丢失)，

往返行程的估计时间(以毫秒为单位):

  最短 = 2ms，最长 = 3ms，平均 = 2ms

## 2.5 配置文件

·   Switch A：

\#

 router id 1.1.1.1

\#

ospf 1

 area 0.0.0.0

 network 192.168.10.0 0.0.0.255

 network 192.168.20.0 0.0.0.255

\#

interface Vlan-interface10

 ip address 192.168.10.1 255.255.255.0

\#

interface Vlan-interface20

 ip address 192.168.20.1 255.255.255.0

\#

interface GigabitEthernet1/0/1

 port access vlan 10

\#

interface GigabitEthernet1/0/2

 port access vlan 20

\#

·   Switch B：

\#

 router id 2.2.2.2

\#

ospf 1

 area 0.0.0.0

 network 192.168.20.0 0.0.0.255

 network 192.168.30.0 0.0.0.255

\#

interface Vlan-interface20

 ip address 192.168.20.2 255.255.255.0

\#

interface Vlan-interface30

 ip address 192.168.30.1 255.255.255.0

\#

interface GigabitEthernet1/0/1

 port access vlan 30

\#

interface GigabitEthernet1/0/2

 port access vlan 20

\#

## 2.6 相关资料

·   产品配套“三层技术-IP路由配置指导”中的“OSPF”。

·   产品配套“三层技术-IP路由命令参考”中的“OSPF”。



 

# 3 多区域OSPF基本功能配置

## 3.1 简介

本案例介绍多区域OSPF基本功能的配置方法。

## 3.2 组网需求

如[图3](https://www.h3c.com/cn/d_202303/1816252_30005_0.htm#_Ref81320117)所示，Switch A、Switch B、Switch C、Switch D都运行OSPF，并将整个自治系统划分为3个区域。其中Switch A和Switch B作为ABR来转发区域之间的路由。配置完成后，每台交换机都应学到AS内的到所有网段的路由。

图3 多区域OSPF基本功能组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774730_x_Img_x_png_2_1816252_30005_0.png)

 

## 3.3 数据规划

| 设备                                                 | Router ID                          | 接口和IP地址                                         | 网段和区域                         |
| ---------------------------------------------------- | ---------------------------------- | ---------------------------------------------------- | ---------------------------------- |
| Switch A                                             | 1.1.1.1                            | 物理接口：GE1/0/1  VLAN：100  IP地址：192.168.0.1/24 | 网段：192.168.0.0/24  区域：area 0 |
| 物理接口：GE1/0/2  VLAN：200  IP地址：192.168.1.1/24 | 网段：192.168.1.0/24  区域：area 1 |                                                      |                                    |
| Switch B                                             | 2.2.2.2                            | 物理接口：GE1/0/1  VLAN：100  IP地址：192.168.0.2/24 | 网段：192.168.0.0/24  区域：area 0 |
| 物理接口：GE1/0/2  VLAN：200  IP地址：192.168.2.1/24 | 网段：192.168.2.0/24  区域：area 2 |                                                      |                                    |
| Switch C                                             | 3.3.3.3                            | 物理接口：GE1/0/1  VLAN：300  IP地址：172.16.1.1/24  | 网段：172.16.1.0/24  区域：area 1  |
| 物理接口：GE1/0/2  VLAN：200  IP地址：192.168.1.2/24 | 网段：192.168.1.0/24  区域：area 1 |                                                      |                                    |
| Switch D                                             | 4.4.4.4                            | 物理接口：GE1/0/1  VLAN：300  IP地址：172.17.1.1/24  | 网段：172.17.1.0/24  区域：area 2  |
| 物理接口：GE1/0/2  VLAN：200  IP地址：192.168.2.2/24 | 网段：192.168.2.0/24  区域：area 2 |                                                      |                                    |
| Host A                                               | -                                  | IP地址：172.16.1.2/24                                | 网段：172.16.1.0/24                |
| Host B                                               | -                                  | IP地址：172.17.1.2/24                                | 网段：172.17.1.0/24                |

 

## 3.4 配置步骤

#### 1. Switch A的配置

\# 创建VLAN 100和VLAN 200，将接口GE1/0/1加入VLAN 100、接口GE1/0/2加入VLAN 200，并配置VLAN 100的IP地址为192.168.0.1/24，VLAN 200的IP地址为192.168.1.1/24。

<Switch A> system-view

[Switch A] vlan 100

[Switch A-vlan100] port gigabitethernet 1/0/1

[Switch A-vlan100] quit

[Switch A] vlan 200

[Switch A-vlan200] port gigabitethernet 1/0/2

[Switch A-vlan200] quit

[Switch A] interface vlan 100

[Switch A-Vlan-interface100] ip address 192.168.0.1 255.255.255.0

[Switch A-Vlan-interface100] quit

[Switch A] interface vlan 200

[Switch A-Vlan-interface200] ip address 192.168.1.1 255.255.255.0

[Switch A-Vlan-interface200] quit

\# 配置全局Router ID为1.1.1.1。

[Switch A] router id 1.1.1.1

\# 启动OSPF进程1，创建区域0，并通告192.168.0.0/24网段；创建区域1，并通告192.168.1.0/24网段。

[Switch A] ospf 1

[Switch A-ospf-1] area 0

[Switch A-ospf-1-area-0.0.0.0] network 192.168.0.0 0.0.0.255

[Switch A-ospf-1-area-0.0.0.0] quit

[Switch A-ospf-1] area 1

[Switch A-ospf-1-area-0.0.0.1] network 192.168.1.0 0.0.0.255

[Switch A-ospf-1-area-0.0.0.1] quit

[Switch A-ospf-1] quit

\# 保存配置。

[Switch A] save force

#### 2. Switch B的配置

\# 创建VLAN 100和VLAN 200，将接口GE1/0/1加入VLAN 100、接口GE1/0/2加入VLAN 200，并配置VLAN 100的IP地址为192.168.0.2/24，VLAN 200的IP地址为192.168.2.1/24。

<Switch B> system-view

[Switch B] vlan 100

[Switch B-vlan100] port gigabitethernet 1/0/1

[Switch B-vlan100] quit

[Switch B] vlan 200

[Switch B-vlan200] port gigabitethernet 1/0/2

[Switch B-vlan200] quit

[Switch B] interface vlan 100

[Switch B-Vlan-interface100] ip address 192.168.0.2 255.255.255.0

[Switch B-Vlan-interface100] quit

[Switch B] interface vlan 200

[Switch B-Vlan-interface200] ip address 192.168.2.1 255.255.255.0

[Switch B-Vlan-interface200] quit

\# 配置全局Router ID为2.2.2.2。

[Switch B] router id 2.2.2.2

\# 启动OSPF进程1，创建区域0，并通告192.168.0.0/24网段；创建区域2，并通告192.168.2.0/24网段。

[Switch B] ospf 1

[Switch B-ospf-1] area 0

[Switch B-ospf-1-area-0.0.0.0] network 192.168.0.0 0.0.0.255

[Switch B-ospf-1-area-0.0.0.0] quit

[Switch B-ospf-1] area 2

[Switch B-ospf-1-area-0.0.0.2] network 192.168.2.0 0.0.0.255

[Switch B-ospf-1-area-0.0.0.2] quit

[Switch B-ospf-1] quit

\# 保存配置。

[Switch B] save force

#### 3. Switch C的配置

\# 创建VLAN 200和VLAN 300，将接口GE1/0/1加入VLAN 300、接口GE1/0/2加入VLAN 200，并配置VLAN 300的IP地址为172.16.1.1/24，VLAN 200的IP地址为192.168.1.2/24。

<Switch C> system-view

[Switch C] vlan 300

[Switch C-vlan300] port gigabitethernet 1/0/1

[Switch C-vlan300] quit

[Switch C] vlan 200

[Switch C-vlan200] port gigabitethernet 1/0/2

[Switch C-vlan200] quit

[Switch C] interface vlan 300

[Switch C-Vlan-interface300] ip address 172.16.1.1 255.255.255.0

[Switch C-Vlan-interface300] quit

[Switch C] interface vlan 200

[Switch C-Vlan-interface200] ip address 192.168.1.2 255.255.255.0

[Switch C-Vlan-interface200] quit

\# 配置全局Router ID为3.3.3.3。

[Switch C] router id 3.3.3.3

\# 启动OSPF进程1，创建区域1，并通告192.168.1.0/24网段和172.16.1.0/24网段。

[Switch C] ospf 1

[Switch C-ospf-1] area 1

[Switch C-ospf-1-area-0.0.0.1] network 192.168.1.0 0.0.0.255

[Switch C-ospf-1-area-0.0.0.1] network 172.16.1.0 0.0.0.255

[Switch C-ospf-1-area-0.0.0.1] quit

[Switch C-ospf-1] quit

\# 保存配置。

[Switch C] save force

#### 4. Switch D的配置

\# 创建VLAN 200和VLAN 300，将接口GE1/0/1加入VLAN 300、接口GE1/0/2加入VLAN 200，并配置VLAN 300的IP地址为172.17.1.1/24，VLAN 200的IP地址为192.168.2.2/24。

<Switch D> system-view

[Switch D] vlan 300

[Switch D-vlan300] port gigabitethernet 1/0/1

[Switch D-vlan300] quit

[Switch D] vlan 200

[Switch D-vlan200] port gigabitethernet 1/0/2

[Switch D-vlan200] quit

[Switch D] interface vlan 300

[Switch D-Vlan-interface300] ip address 172.17.1.1 255.255.255.0

[Switch D-Vlan-interface300] quit

[Switch D] interface vlan 200

[Switch D-Vlan-interface200] ip address 192.168.2.2 255.255.255.0

[Switch D-Vlan-interface200] quit

\# 配置全局Router ID为4.4.4.4。

[Switch D] router id 4.4.4.4

\# 启动OSPF进程1，创建区域2，并通告192.168.2.0/24网段和172.17.1.0/24网段。

[Switch D] ospf 1

[Switch D-ospf-1] area 2

[Switch D-ospf-1-area-0.0.0.2] network 192.168.2.0 0.0.0.255

[Switch D-ospf-1-area-0.0.0.2] network 172.17.1.0 0.0.0.255

[Switch D-ospf-1-area-0.0.0.2] quit

[Switch D-ospf-1] quit

\# 保存配置。

[Switch D] save force

## 3.5 验证配置

\# 查看Switch A的OSPF邻居。

[Switch A] display ospf peer

 

​     OSPF Process 1 with Router ID 1.1.1.1

​        Neighbor Brief Information

 

 Area: 0.0.0.0

 Router ID    Address     Pri Dead-Time State       Interface

 2.2.2.2     192.168.0.2   1  33     Full/DR      Vlan100

 

 Area: 0.0.0.1

 Router ID    Address     Pri Dead-Time State       Interface

 3.3.3.3     192.168.1.2   1  34     Full/DR      Vlan200

\# 查看Switch A的路由表，存在到172.16.1.0、172.17.1.0、192.168.2.0的路由。

[Switch A] display ip routing-table

 

Destinations : 19    Routes : 19

 

Destination/Mask  Proto  Pre Cost    NextHop     Interface

0.0.0.0/32     Direct 0  0      127.0.0.1    InLoop0

127.0.0.0/8    Direct 0  0      127.0.0.1    InLoop0

127.0.0.0/32    Direct 0  0      127.0.0.1    InLoop0

127.0.0.1/32    Direct 0  0      127.0.0.1    InLoop0

127.255.255.255/32 Direct 0  0      127.0.0.1    InLoop0

172.16.1.0/24   O_INTRA 10 2      192.168.1.2   Vlan200

172.17.1.0/24   O_INTER 10 3      192.168.0.2   Vlan100

192.168.0.0/24   Direct 0  0      192.168.0.1   Vlan100

192.168.0.0/32   Direct 0  0      192.168.0.1   Vlan100

192.168.0.1/32   Direct 0  0      127.0.0.1    InLoop0

192.168.0.255/32  Direct 0  0      192.168.0.1   Vlan100

192.168.1.0/24   Direct 0  0      192.168.1.1   Vlan200

192.168.1.0/32   Direct 0  0      192.168.1.1   Vlan200

192.168.1.1/32   Direct 0  0      127.0.0.1    InLoop0

192.168.1.255/32  Direct 0  0      192.168.1.1   Vlan200

192.168.2.0/24   O_INTER 10 2      192.168.0.2   Vlan100

224.0.0.0/4    Direct 0  0      0.0.0.0     NULL0

224.0.0.0/24    Direct 0  0      0.0.0.0     NULL0

255.255.255.255/32 Direct 0  0      127.0.0.1    InLoop0

\# Host A可以ping通Host B。

C:\Users\HostA>ping 172.17.1.2

正在 Ping 192.168.30.2 具有 32 字节的数据:

来自 172.17.1.2 的回复: 字节=32 时间=3ms TTL=255

来自 172.17.1.2 的回复: 字节=32 时间=1ms TTL=255

来自 172.17.1.2 的回复: 字节=32 时间<1ms TTL=255

来自 172.17.1.2 的回复: 字节=32 时间=2ms TTL=255

 

172.17.1.2 的 Ping 统计信息:

  数据包: 已发送 = 4，已接收 = 4，丢失 = 0 (0% 丢失)，

往返行程的估计时间(以毫秒为单位):

  最短 = 2ms，最长 = 3ms，平均 = 2ms

## 3.6 配置文件

·   Switch A：

\#

 router id 1.1.1.1

\#

ospf 1

 area 0.0.0.0

 network 192.168.0.0 0.0.0.255

 area 0.0.0.1

 network 192.168.1.0 0.0.0.255

\#

interface Vlan-interface100

 ip address 192.168.0.1 255.255.255.0

\#

interface Vlan-interface200

 ip address 192.168.1.1 255.255.255.0

\#

interface GigabitEthernet1/0/1

 port access vlan 100

\#

interface GigabitEthernet1/0/2

 port access vlan 200

\#

·   Switch B：

\#

 router id 2.2.2.2

\#

ospf 1

 area 0.0.0.0

 network 192.168.0.0 0.0.0.255

 area 0.0.0.2

 network 192.168.2.0 0.0.0.255

\#

interface Vlan-interface100

 ip address 192.168.0.2 255.255.255.0

\#

interface Vlan-interface200

 ip address 192.168.2.1 255.255.255.0

\#

interface GigabitEthernet1/0/1

 port access vlan 100

\#

interface GigabitEthernet1/0/2

 port access vlan 200

\#

·   Switch C：

\#

 router id 3.3.3.3

\#

ospf 1

 area 0.0.0.1

 network 192.168.1.0 0.0.0.255

 network 172.16.1.0 0.0.0.255

\#

interface Vlan-interface200

 ip address 192.168.1.2 255.255.255.0

\#

interface Vlan-interface300

 ip address 172.16.1.1 255.255.255.0

\#

interface GigabitEthernet1/0/1

 port access vlan 300

\#

interface GigabitEthernet1/0/2

 port access vlan 200

\#

·   Switch D：

\#

 router id 4.4.4.4

\#

ospf 1

 area 0.0.0.2

 network 192.168.2.0 0.0.0.255

 network 172.17.1.0 0.0.0.255

\#

interface Vlan-interface200

 ip address 192.168.2.2 255.255.255.0

\#

interface Vlan-interface300

 ip address 172.17.1.1 255.255.255.0

\#

interface GigabitEthernet1/0/1

 port access vlan 300

\#

interface GigabitEthernet1/0/2

 port access vlan 200

\#