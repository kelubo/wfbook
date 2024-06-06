# 概述

## 1.1 产生背景

随着数据中心业务日益增加，用户需求不断提高，数据中心的规模和功能日趋复杂，管理难度也越来越高。出于灾备、企业分支机构的多地部署、提升资源利用率等方面的考虑，企业可能在不同的物理站点部署自己的数据中心网络。于是，如何将这些数据中心站点互联起来，并降低数据中心的管理成本、灵活扩充数据中心业务等就成为企业数据中心的重要任务。

EVPN（Ethernet Virtual Private Network，以太网虚拟专用网络）是一种基于Overlay技术的二层网络互联技术，具有部署简单、扩展性强等优点。EVPN采用MP-BGP协议通告MAC/IP的可达性和组播等信息，通过生成的MAC表项和路由表项进行二/三层报文转发，以实现二层网络互联，很好地满足了用户对于大型数据中心网络的需求。

目前，EVPN不仅广泛应用于数据中心网络，在园区接入网络、广域网、运营商网络中也具有一定的应用。

## 1.2 协议框架

EVPN定义了一套通用的控制平面，数据平面可以使用不同的封装技术，他们的关系如[图1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref507666461)所示。目前，Comware支持VXLAN、MPLS和IPv6 Segment Routing（SRv6）作为数据平面。

图1 EVPN协议框架

![img](https://resource.h3c.com/cn/202305/10/20230510_9004119_x_Img_x_png_0_1844394_30005_0.png)

 

不同数据平面对应的EVPN技术分别为：

·   EVPN VXLAN：数据平面采用VXLAN封装。

EVPN VXLAN网络的边缘设备称为VTEP（VXLAN Tunnel End Point，VXLAN隧道端点），EVPN的相关处理均在VTEP上完成。EVPN VXLAN通过在VTEP间建立VXLAN隧道，透明传输二层数据报文，实现不同站点间的二层互联。

通过在EVPN VXLAN网络中部署EVPN网关，可以实现为同一租户的不同子网提供三层互联，并为其提供与外部网络的三层互联。

EVPN VXLAN的详细介绍请参见“[2 ](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57132369)[EVPN VXLAN](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57132354)”。

图2 EVPN VXLAN网络模型示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004120_x_Img_x_png_1_1844394_30005_0.png)

 

·   EVPN VPLS：数据平面采用MPLS封装，用来实现用户的点到多点二层互通。

EVPN VPLS组网中，用户网络侧设备CE通过AC接入服务提供商网络侧设备PE，PE间通过BGP EVPN路由建立PW，PE通过查找MAC地址表转发报文，可以实现用户点对多点的二层互通。

EVPN VPLS的详细介绍请参见“[3 ](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57132325)[EVPN VPLS](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57132336)”。

图3 EVPN VPLS网络模型示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004131_x_Img_x_png_2_1844394_30005_0.png)

 

·   EVPN VPWS：数据平面采用MPLS封装，用来实现用户的点到点二层互通。

EVPN VPWS组网中，用户网络侧设备CE通过AC接入服务提供商网络侧设备PE，PE间通过BGP EVPN路由建立EVPN PW，在PE上使用交叉连接将AC与EVPN PW关联，即可实现用户点对点的二层互通。

EVPN VPWS的详细介绍请参见“[4 ](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref59022394)[EVPN VPWS](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref59022400)”。

图4 EVPN VPWS网络模型示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004142_x_Img_x_png_3_1844394_30005_0.png)

 

·   EVPN VPLS over SRv6：数据平面采用SRv6封装，用来实现用户的点到多点二层互通。

·   EVPN VPWS over SRv6：数据平面采用SRv6封装，用来实现用户的点到点二层互通。

本文仅介绍EVPN VXLAN、EVPN VPLS和EVPN VPWS三种EVPN技术，EVPN VPLS over SRv6和EVPN VPWS over SRv6的详细介绍，请参见《SRv6技术白皮书》。

## 1.3 技术优势

EVPN不仅继承了MP-BGP和VXLAN/MPLS的优势，还提供了新的功能。EVPN具有如下特点：

·   简化配置：通过MP-BGP实现VTEP/PE自动发现、VXLAN隧道/PW自动建立、VXLAN隧道与VXLAN自动关联，无需用户手工配置，降低网络部署难度。

·   分离控制平面与数据平面：控制平面负责发布路由信息，数据平面负责转发报文，分工明确，易于管理。

·   提供点到点和点到多点的服务：将用户的二层数据封装成可以在IP或MPLS网络中传送的分组，从而实现用户二层数据跨越IP或MPLS网络在不同站点间透明地传送。

相对于传统VPLS技术，EVPN存在如下优势：

·   EVPN支持完善的多归属接入应用场景，支持负载分担和主备备份两种工作模式。

·   二层网络间的MAC/IP地址学习和发布从数据平面转移到控制平面，采用MP-BGP协议通告MAC/IP的可达性，使设备可以像管理路由一样灵活地管理MAC/IP地址：

¡   具有较好的扩展性。

¡   能够维护主机或虚拟机彼此间的隔离性。

¡   解决了设备多归属或网络多归属接入时的负载分担问题，并缩短了网络出现故障时的收敛时间。

·   使用BGP作为控制协议，统一了二层和三层的控制信令协议。

·   通过部署路由反射器，避免设备全连接，降低网络部署的难度。

## 1.4 BGP EVPN路由

为了支持EVPN，MP-BGP在L2VPN地址族下定义了新的子地址族——EVPN地址族，并为该地址族定义了EVPN NLRI（Network Layer Reachability Information，网络层可达性信息），即EVPN路由。EVPN子地址族使用的地址族编号为：AFI=25，SAFI=70。

在EVPN网络中，VTEP/PE之间既可以建立IBGP邻居，也可以建立EBGP邻居。

·   建立IBGP邻居时，为简化全连接配置，需要部署RR反射器。所有VTEP/PE都只和RR建立BGP邻居关系。RR发现并接收VTEP/PE发起的BGP连接后形成客户机列表，将从某个VTEP/PE收到的路由反射给其他所有的VTEP/PE。

·   建立EBGP邻居时，不需要部署RR。BGP自动将从EBGP邻居收到的EVPN消息发送给其他EBGP和IBGP邻居。

### 1.4.1 Ethernet Auto-discovery Route（RT-1）

以太网自动发现路由，用来在站点多归属组网中通告ES信息，也可以用来在EVPN VPWS组网中通告Service ID信息。

以太网自动发现路由分为：

·   Ethernet Auto-discovery Per ES路由：主要用于多归属组网的快速收敛、冗余模式和水平分割。

·   Ethernet Auto-discovery Per EVI路由：主要用于多归属组网的别名（Aliasing）、备份路径功能。

图5 以太自动发现路由报文格式

![img](https://resource.h3c.com/cn/202305/10/20230510_9004153_x_Img_x_png_4_1844394_30005_0.png)

 

如[图5](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref56501013)所示，以太自动发现路由包括如下字段：

·   RD（Route Distinguisher，路由标识符）：EVPN实例的RD值。

·   Ethernet segment identifier：VTEP/PE与CE之间的以太网链路的段标识符。同一站点CE通过不同链路多归属到不同PE时，这些链路构成一个ES，并以一个相同的ESI标识。

·   Ethernet tag ID：

¡   对于Ethernet Auto-discovery Per ES路由，该字段为全F。

¡   对于Ethernet Auto-discovery Per EVI路由，不同类型组网中，该字段对应不同的取值：

\-   在EVPN VPLS和EVPN VXLAN组网中，该字段为VSI实例的Tag ID、接入AC对应的VLAN或全0。

\-   在EVPN VPWS组网中中，本字段为本端的Service ID。

·   MPLS label：

¡   对于Ethernet Auto-discovery Per ES路由，该字段为0。

¡   对于Ethernet Auto-discovery Per EVI路由，不同数据封装类型下，该字段对应不同的取值：

\-   VXLAN封装时，为VXLAN ID。

\-   MPLS封装时，为MPLS Label。

\-   SRv6封装时，该字段与SRv6 TLV组合在一起表示SID。

### 1.4.2 MAC/IP Advertisement Route（RT-2）

MAC/IP发布路由，用来通告MAC地址和主机路由信息（即ARP信息和ND信息）。

图6 MAC/IP发布路由报文格式

![img](https://resource.h3c.com/cn/202305/10/20230510_9004164_x_Img_x_png_5_1844394_30005_0.png)

 

如[图6](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref56501719)所示，MAC/IP发布路由包括如下字段：

·   RD：EVPN实例的RD值。

·   Ethernet segment identifier：VTEP/PE与CE之间的以太网链路的段标识符。

·   Ethernet tag ID：该字段为VSI实例的Tag ID、接入AC对应的VLAN或全0。

·   MAC address length：通告的MAC地址长度。

·   MAC address：通告的MAC地址。

·   IP address length：主机IP地址的掩码长度。

·   IP address ：通告的主机IP地址。

·   MPLS label1：不同的数据封装类型下，该字段对应不同的取值：

¡   VXLAN封装时，为VXLAN ID。

¡   MPLS封装时，为MPLS Label。

¡   SRv6封装时，该字段与SRv6 TLV组合在一起表示SID。

·   MPLS label2：三层业务流量转发时使用的标识。不同的数据封装类型下，该字段对应不同的取值：

¡   VXLAN封装时，为L3VNI。

¡   MPLS封装暂不支持该字段。

¡   SRv6封装时，该字段与SRv6 TLV组合在一起表示SRv6分布式网关用于转发三层流量的SRv6 SID。

### 1.4.3 Inclusive Multicast Ethernet Tag Route（RT-3）

包含性组播以太网标签路由，又称为IMET路由。在EVPN VXLAN组网中用来通告VTEP及其所属VXLAN信息，以实现自动发现VTEP、自动建立VXLAN隧道和自动关联VXLAN与VXLAN隧道；在EVPN VPLS组网中用来通告PE信息，实现PE的自动发现、自动建立PW。

图7 包含性组播以太网标签路由的报文格式

![img](https://resource.h3c.com/cn/202305/10/20230510_9004175_x_Img_x_png_6_1844394_30005_0.png)

 

如[图7](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref56502220)所示，发布包含性组播以太网标签路由时，需要在该路由中携带PSMI（Provider Multicast Service Interface，运营商组播业务接口）tunnel attributes，该属性中各字段的含义为：

·   Flags：标记位。

·   Tunnel type：隧道类型，取值如下：

¡   0：表示No tunnel information present。

¡   1：表示RSVP-TE P2MP LSP。

¡   2：表示mLDP P2MP LSP。

¡   3：表示PIM-SSM Tree。

¡   4：表示PIM-SM Tree。

¡   5：表示BIDIR-PIM Tree。

¡   6：表示Ingress Replication。

¡   7：表示mLDP MP2MP LSP。

·   MPLS label：转发BUM（Broadcast/Unknown unicast/Unknown Multicast，广播/未知单播/未知组播）流量时，封装的MPLS标签、VXLAN ID或SID。

·   Tunnel Identifier：当隧道类型为Ingress Replication时，表示隧道对端的IP地址。

包含性组播以太网标签路由包含如下字段：

·   RD：EVPN实例的RD值。

·   Ethernet tag ID：该字段为接入AC对应的VLAN或全0。

·   IP address length：始发该路由的IP地址的掩码长度。

·   Originating router's IP address：始发该路由的VTEP或PE的IP地址，取值为BGP协议的Router ID。

### 1.4.4 Ethernet Segment Route（RT-4）

以太网段路由，用来通告ES及其连接的VTEP信息，以便发现连接同一ES的多归属冗余备份组中的其他成员，以及在冗余组之间选举DF等。

图8 以太网段路由报文格式

![img](https://resource.h3c.com/cn/202305/10/20230510_9004186_x_Img_x_png_7_1844394_30005_0.png)

 

如[图8](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref56502437)所示，以太网段路由包含如下字段：

·   RD：根据VTEP/PE的IP地址自动生成的RD，例如X.X.X.X:0。

·   Ethernet segment identifier：VTEP/PE与CE之间的以太网链路的段标识符。

·   IP address length：始发该路由的IP地址的掩码长度。

·   Originating router's IP address：始发该路由的VTEP或PE的IP地址，取值为BGP协议的Router ID。

### 1.4.5 IP Prefix Advertisement Route（RT-5）

IP前缀路由，用来以IP前缀的形式通告BGP IPv4单播路由或BGP IPv6单播路由。

图9 IP前缀路由报文格式

![img](https://resource.h3c.com/cn/202305/10/20230510_9004197_x_Img_x_png_8_1844394_30005_0.png)

 

如[图9](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref56502542)所示，IP前缀路由包含如下字段：

·   RD：VPN实例/公网实例下EVPN地址族的RD值。

·   Ethernet segment identifier：VTEP/PE与CE之间的以太网链路的段标识符。

·   Ethernet tag ID：固定为全0。

·   IP prefix length：IP前缀掩码长度。

·   IP prefix：IP前缀地址。

·   GW IP address：默认网关地址。

·   L3VNI：不同数据封装类型下，该字段对应不同的取值：

¡   VXLAN封装时，为转发三层业务流量时使用的L3VNI。

¡   MPLS封装时，为MPLS Label。

¡   SRv6封装时，为转发三层业务流量时使用的SID。

### 1.4.6 Selective Multicast Ethernet Tag Route（RT-6）

选择性组播以太网标签路由，用来通告租户的IGMP组播组信息。

图10 选择性组播以太网标签路由报文格式

![img](https://resource.h3c.com/cn/202305/10/20230510_9004204_x_Img_x_png_9_1844394_30005_0.png)

 

如[图10](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref56786329)所示，选择性组播以太网标签路由包含如下字段：

·   RD：EVPN实例的RD值。

·   Ethernet tag ID：该字段为全0。

·   Multicast source length：租户加入的组播源的IP地址长度，32位代表IPv4，128位代表IPv6。

·   Multicast source address：租户加入的组播源的地址。

·   Multicast group length：租户加入的组播组的IP地址长度，32代表IPv4，128位代表IPv6。

·   Multicast group address：租户加入的组播组地址。

·   Originator router length：始发该路由的IP地址的长度，32代表IPv4，128位代表IPv6。

·   Originator router address：始发该路由的VTEP或PE的IP地址，取值为BGP协议的Router ID。

·   Flags：标记位。该字段表示的内容与Multicast group address字段有关：

¡   如果Multicast group address为IPv4地址：

\-   bit 7表示是否支持IGMP version 1。

\-   bit 6表示是否支持IGMP version 2。

\-   bit 5表示是否支持IGMP version 3。

\-   bit 4表示携带的（S，G）的模式，取值为1，表示Exclude模式；取值为0，表示Include模式。该bit位仅在bit 5取值为1时有效，bit 5取值为0时忽略该bit位。

¡   如果Multicast group address为IPv6地址：

\-   bit 7表示是否支持MLD version 1。

\-   bit 6表示是否支持MLD version 2。

\-   bit 5目前固定值为0。

\-   bit 4表示携带的（S，G）的模式，取值为1，表示Exclude模式；取值为0，表示Include模式。该bit位仅在bit 6取值为1时有效，bit 6取值为0时忽略该bit位。

### 1.4.7 IGMP Join Synch Route（RT-7）

IGMP加入同步路由，用来在多归属成员间同步租户的IGMP加入组播组信息。

图11 IGMP加入同步路由报文格式

![img](https://resource.h3c.com/cn/202305/10/20230510_9004121_x_Img_x_png_10_1844394_30005_0.png)

 

如[图11](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref56786901)所示，IGMP加入同步路由包含如下字段：

·   RD：EVPN实例的RD值。

·   Ethernet segment identifier：VTEP/PE与CE之间的以太网链路的段标识符。

·   Ethernet tag ID：接入AC对应的VLAN。

·   Multicast source length：租户加入的组播源的IP地址长度，32位代表IPv4，128位代表IPv6。

·   Multicast source address：租户加入的组播源的地址。

·   Multicast group length：租户加入的组播组的IP地址长度，32代表IPv4，128位代表IPv6。

·   Multicast group address：租户加入的组播组地址。

·   Originator router length：始发该路由的IP地址的长度，32代表IPv4，128位代表IPv6。

·   Originator router address：始发该路由的VTEP或PE的IP地址，取值为BGP协议的Router ID。

·   Flags：标记位。该字段表示的内容与Multicast group address字段有关：

¡   如果Multicast group address为IPv4地址：

\-   bit 7表示是否支持IGMP version 1。

\-   bit 6表示是否支持IGMP version 2。

\-   bit 5表示是否支持IGMP version 3。

\-   bit 4表示携带的（S，G）的模式，取值为1，表示Exclude模式；取值为0，表示Include模式。该bit位仅在bit 5取值为1时有效，bit 5取值为0时忽略该bit位。

¡   如果Multicast group address为IPv6地址：

\-   bit 7表示是否支持MLD version 1。

\-   bit 6表示是否支持MLD version 2。

\-   bit 5目前固定值为0。

\-   bit 4表示携带的（S，G）的模式，取值为1，表示Exclude模式；取值为0，表示Include模式。该bit位仅在bit 6取值为1时有效，bit 6取值为0时忽略该bit位。

### 1.4.8 IGMP Leave Synch Route（RT-8）

IGMP离开同步路由，用来在多归属成员间通告租户的IGMP离开组播组信息，以撤销相应的IGMP加入同步路由。

图12 IGMP离开同步路由报文格式

![img](https://resource.h3c.com/cn/202305/10/20230510_9004122_x_Img_x_png_11_1844394_30005_0.png)

 

如[图12](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref56787186)所示，IGMP离开同步路由包含如下字段：

·   RD：EVPN实例的RD值。

·   Ethernet segment identifier：VTEP/PE与CE之间的以太网链路的段标识符。

·   Ethernet tag ID：接入AC对应的VLAN。

·   Multicast source length：租户加入的组播源的IP地址长度，32位代表IPv4，128位代表IPv6。

·   Multicast source address：租户加入的组播源的地址。

·   Multicast group length：租户加入的组播组的IP地址长度，32代表IPv4，128位代表IPv6。

·   Multicast group address：租户加入的组播组地址。

·   Originator router length：始发该路由的IP地址的长度，32代表IPv4，128位代表IPv6。

·   Originator router address：始发该路由的VTEP或PE的IP地址，取值为BGP协议的Router ID。

·   Leave group synchronization：租户离开组播组的序列号。

·   Maximum response time：通告的最大响应时间。

·   Flags：标记位。该字段表示的内容与Multicast group address字段有关：

¡   如果Multicast group address为IPv4地址：

\-   bit 7表示是否支持IGMP version 1。

\-   bit 6表示是否支持IGMP version 2。

\-   bit 5表示是否支持IGMP version 3。

\-   bit 4表示携带的（S，G）的模式，取值为1，表示Exclude模式；取值为0，表示Include模式。该bit位仅在bit 5取值为1时有效，bit 5取值为0时忽略该bit位。

¡   如果Multicast group address为IPv6地址：

\-   bit 7表示是否支持MLD version 1。

\-   bit 6表示是否支持MLD version 2。

\-   bit 5目前固定值为0。

\-   bit 4表示携带的（S，G）的模式，取值为1，表示Exclude模式；取值为0，表示Include模式。该bit位仅在bit 6取值为1时有效，bit 6取值为0忽略该bit位。

## 1.5 BGP EVPN路由的扩展团体属性

为了配合不同类型BGP EVPN路由实现不同的功能，BGP EVPN定义了多种扩展团体属性。

### 1.5.1 ESI Label Extended Community

Ethernet Auto-discovery Route路由中携带该扩展团体属性，用来实现水平分割和识别冗余备份模式。

图13 ESI Label Extended Community报文格式

![img](https://resource.h3c.com/cn/202305/10/20230510_9004123_x_Img_x_png_12_1844394_30005_0.png)

 

如[图13](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57032875)所示，ESI Label Extended Community包含如下字段：

·   Flags：该字段的最后一个bit位用于标识多归属的冗余备份模式。取值为0，表示多活冗余模式；取值为1，表示单活冗余模式。

·   ESI Label：用于在EVPN多归属组网中实现水平分割。不同的数据封装类型下，该字段对应不同的取值：

¡   MPLS封装时，为MPLS Label。

¡   VXLAN封装时，该字段无意义。

¡   SRv6封装时，为SID的argument。

### 1.5.2 ES-Import Route Target Extended Community

Ethernet Segment Route中携带该扩展团体属性，用于通告ES的Route target属性。

图14 ES-Import Route Target Extended Community报文格式

![img](https://resource.h3c.com/cn/202305/10/20230510_9004124_x_Img_x_png_13_1844394_30005_0.png)

 

如[图14](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57032889)所示，ES-Import Route Target Extended Community中ES-Import和ES-Import Cont'd字段一起表示根据ESI自动生成的Route target属性值。

### 1.5.3 MAC Mobility Extended Community

当主机发生迁移时，携带在MAC/IP Advertisement Route路由中，用于标识主机发生迁移的次数。

图15 MAC Mobility Extended Community报文格式

![img](https://resource.h3c.com/cn/202305/10/20230510_9004125_x_Img_x_png_14_1844394_30005_0.png)

 

如[图15](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57032896)所示，MAC Mobility Extended Community包含如下字段：

·   Flags：该字段的最后一个bit位用于标识是否为静态MAC。取值为1，表示该MAC地址为静态MAC，不可迁移。

·   Reserved：保留字段。

·   Sequence Numbe：标记MAC迁移的次数。

### 1.5.4 Default Gateway Extended Community

EVPN VXLAN分布式网关组网中，携带在MAC/IP Advertisement Route路由中，表示本地址是网关地址。

图16 Default Gateway Extended Community报文格式

![img](https://resource.h3c.com/cn/202305/10/20230510_9004126_x_Img_x_png_15_1844394_30005_0.png)

 

如[图16](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57032903)所示，Default Gateway Extended Community中Value和Value (cont.)字段取值均为0。

### 1.5.5 Encapsulation Type Extended Community

所有BGP EVPN路由均可以携带该扩展团体属性，用于标识报文的封装类型。默认报文封装类型为MPLS封装。因此，采用MPLS封装时，BGP EVPN路由中可以不携带该属性。

图17 Encapsulation Type Extended Community报文格式

![img](https://resource.h3c.com/cn/202305/10/20230510_9004127_x_Img_x_png_16_1844394_30005_0.png)

 

如[图17](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57032910)所示，Encapsulation Type Extended Community包含如下字段：

·   Reserved：保留字段。

·   Tunnel Type：封装类型。该字段不同取值代表不同的封装类型：

¡   8：VXLAN封装。

¡   9：NVGRE封装。

¡   10：MPLS封装。

¡   11：MPLS in GRE封装。

¡   12：VXLAN GPE封装。

### 1.5.6 VPN Target Extended Community（也称为Route Target）

所有BGP EVPN路由均需要携带VPN Target扩展团体属性，通过VPN Target属性来控制EVPN路由信息的发布与接收：

·   本地VTEP在通过BGP的Update消息将EVPN路由发送给远端VTEP时，在Update消息中携带VPN Target属性（该属性称为Export target属性）。

·   远端VTEP收到其它VTEP发布的Update消息时，将消息中携带的VPN target属性与本地配置的VPN target属性（该属性称为Import target属性）进行匹配，只有二者中存在相同的属性值时，才会接收该消息中的EVPN路由。

图18 VPN Target Extended Community报文格式

![img](https://resource.h3c.com/cn/202305/10/20230510_9004128_x_Img_x_png_17_1844394_30005_0.png)

 

如[图18](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57305186)所示，VPN Target Extended Community中Value和Value (cont.)字段一起表示Route Target。

Route Target取值有如下三种格式：

·   16位自治系统号:32位用户自定义数，例如：101:3。

·   32位IP地址:16位用户自定义数，例如：192.168.122.15:1。

·   32位自治系统号:16位用户自定义数字，其中的自治系统号最小值为65536。例如：65536:1。



# 2 EVPN VXLAN

## 2.1 EVPN VXLAN网络模型

图19 EVPN VXLAN网络模型示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004129_x_Img_x_png_18_1844394_30005_0.png)

 

如[图19](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref374540414)所示，EVPN VXLAN的典型网络模型中包括如下几部分：

·   用户终端（Terminal）：可以是PC机、无线终端设备、服务器上创建的VM（Virtual Machine，虚拟机）等。不同的用户终端可以属于不同的VXLAN。属于相同VXLAN的用户终端处于同一个逻辑二层网络，彼此之间二层互通；属于不同VXLAN的用户终端之间二层隔离。

![说明](https://resource.h3c.com/cn/202305/10/20230510_9004130_x_Img_x_png_19_1844394_30005_0.png)

本文档中如无特殊说明，均以VM为例介绍EVPN VXLAN工作机制。采用其他类型用户终端时，EVPN VXLAN工作机制与VM相同，不再赘述。

 

·   VTEP（VXLAN Tunnel End Point，VXLAN隧道端点）：EVPN VXLAN的边缘设备。EVPN VXLAN的相关处理都在VTEP上进行。根据VTEP功能，VTEP可以划分为L2 VTEP和GW两种角色：

¡   L2 VTEP：只支持二层VXLAN转发功能的设备，即只能在相同VXLAN内进行二层转发。

¡   GW：可以进行跨VXLAN或者访问外部IP网络等三层转发的设备。EVPN VXLAN网络根据GW的部署方式，可以分为集中式网关和分布式网关两种。

·   VXLAN隧道：两个VTEP之间的点到点逻辑隧道。VTEP为数据帧封装VXLAN头、UDP头和IP头后，通过VXLAN隧道将封装后的报文转发给远端VTEP，远端VTEP对其进行解封装。

·   核心设备：IP核心网络中的设备（如[图19](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref374540414)中的P设备）。核心设备不参与EVPN处理，仅需要根据封装后报文的外层目的IP地址对报文进行三层转发。

·   VXLAN网络/EVPN实例：用户网络可能包括分布在不同地理位置的多个站点内的用户终端。在骨干网上可以利用VXLAN隧道将这些站点连接起来，为用户提供一个逻辑的二层VPN。这个二层VPN称为一个VXLAN网络，也称为EVPN实例。VXLAN网络通过VXLAN ID来标识，VXLAN ID又称VNI（VXLAN Network Identifier，VXLAN网络标识符），其长度为24比特。不同VXLAN网络中的用户终端不能二层互通。

·   VSI（Virtual Switch Instance，虚拟交换实例）：VTEP上为一个VXLAN提供二层交换服务的虚拟交换实例。VSI可以看作是VTEP上的一台基于VXLAN进行二层转发的虚拟交换机。VSI与VXLAN一一对应。

·   ES（Ethernet Segment，以太网段）：用户站点连接到VTEP的链路，通过ESI（Ethernet Segment Identifier，以太网段标识符）唯一标识。当一个站点通过多条链路接入到EVPN VXLAN网络时，这些链路构成一个ES，以实现主备备份或负载分担。

如[图20](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref508025664)所示，EVPN VXLAN通常采用Spine（核心）—Leaf（分支）的分层结构。Leaf层的设备作为VTEP对报文进行EVPN相关处理，Spine层为核心设备，根据报文的目的IP地址转发报文。EVPN VXLAN网络中的设备属于同一个AS（Autonomous System，自治系统）时，为了避免在所有VTEP之间建立IBGP对等体，可以将核心设备配置为RR（Route Reflector，路由反射器），以减轻网络的部署难度。通常情况下，在集中式网关组网中，VTEP为L2 VTEP，其中一台RR同时作为GW；在分布式网关组网中，VTEP作为GW，RR仅作为反射器发布、接收EVPN路由，不需要封装、解封装VXLAN报文。

图20 EVPN VXLAN分层组网模型

![img](https://resource.h3c.com/cn/202305/10/20230510_9004132_x_Img_x_png_20_1844394_30005_0.png)

 

## 2.2 EVPN VXLAN控制平面工作机制

### 2.2.1 VXLAN隧道及BUM广播表建立

VXLAN采用“MAC in UDP”封装，是一种在IP网络基础之上构建Overlay网络的技术。在IP网络上传输报文时，VXLAN使用Ingress Replication，即头端复制，来转发BUM（Broadcast/Unknown unicast/Unknown Multicast，广播/未知单播/未知组播）流量。所谓头端复制，是指在VXLAN转发实体（VSI）中保存BUM流量需要通过哪些VXLAN隧道复制到远端PE设备，此VXLAN隧道列表叫做BUM广播表。

EVPN VXLAN可以通过以下两种方式建立VXLAN隧道和BUM广播表：

·   在二层转发时，EVPN VXLAN依靠RT-3（Inclusive Multicast Ethernet Tag Route）自动发现VTEP站点、建立VXLAN隧道、建立BUM广播表。

RT-3路由的关键信息及路由格式如[图21](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref508093692)所示。每个VTEP都通过RT-3通告自己所属的VXLAN ID及自身的IP地址。这样，每个VTEP设备都有全网的VXLAN信息以及VXLAN和下一跳的关系。VTEP设备会和那些跟自己具有相同VXLAN的下一跳自动建立VXLAN隧道，并将此VXLAN隧道与VXLAN关联。于是，对于每个VXLAN而言，所有这些建立并关联的VXLAN隧道就形成BUM广播表。

图21 RT-3路由消息格式

 ![img](https://resource.h3c.com/cn/202305/10/20230510_9004133_x_Img_x_png_21_1844394_30005_0.png)

 

·   在分布式网关进行三层转发时，EVPN VXLAN依靠RT-2或RT-5自动发现VTEP站点、建立VXLAN隧道。

当分布式网关接收到远端网关通告的RT-2或RT-5路由，且该路由携带的Export target属性与本地某个VPN实例的Import target属性匹配时，本地VTEP会与远端VTEP建立VXLAN隧道，并将该VXLAN隧道与VPN实例对应的L3VNI（Layer 3 VNI，三层VXLAN ID）关联。此隧道用于三层转发时对报文进行封装。分布式网关的详细介绍，请参见“[2.3.3 ](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref508096612)[分布式网关对称IRB转发](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref508096619)”。

如果通过上述两种方式发现同一个远端VTEP，则只建立一条隧道，该隧道与不同的VXLAN关联，同时用于二层转发和三层转发，即两个VTEP之间最多只会建立一条VXLAN隧道。

### 2.2.2 MAC/IP路由通告与学习

EVPN VXLAN在控制平面学习MAC地址和ARP/ND信息。站点的MAC地址和ARP/ND信息通过EVPN的MAC/IP发布路由（即RT-2，二类路由）通告。因此，在EVPN VXLAN网络中，不需要将ARP/ND请求泛洪到网络中。

RT-2路由格式如[图22](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref508098084)所示。

图22 RT-2路由格式

![img](https://resource.h3c.com/cn/202305/10/20230510_9004134_x_Img_x_png_22_1844394_30005_0.png)

 

如[图23](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref508108317)所示，MAC地址和ARP/ND信息的通告和学习过程为：

(1)   VTEP在数据平面完成本地MAC地址和ARP/ND信息的学习。本地MAC地址通过以太网报文的源MAC地址学习获得；ARP/ND信息通过ARP、免费ARP、ND等报文学习获得。

(2)   VTEP学习到本地MAC地址和ARP/ND信息后，在控制平面通过BGP EVPN的RT-2路由将该信息发布给RR。

(3)   RR将接收到的RT-2路由同步给所有BGP EVPN邻居（远端VTEP）。

(4)   远端VTEP接收到RT-2路由后，将MAC地址添加到MAC地址转发表，将ARP/ND信息添加到ARP/ND表和路由表。

图23 MAC/IP路由通告与学习过程

![img](https://resource.h3c.com/cn/202305/10/20230510_9004135_x_Img_x_png_23_1844394_30005_0.png)

 

在发布RT-2路由时，VTEP可以选择是否携带IP。为了抑制ARP请求泛洪到网络中，通常需要携带IP，以便让远端VTEP学习到本端VTEP下挂的主机ARP，使得远端VTEP可以直接代答回应远端主机发起的ARP请求。如果只是纯二层网络、不进行三层转发，则在RT-2中只携带MAC地址。由于在三层转发环境下远端VTEP能够从ARP信息中获取MAC地址，Comware上可以禁止通告只包含MAC地址的RT-2路由，以减少通告的EVPN路由数量。

在集中式网关组网中，L2 VTEP需要将学习到的ARP通告给GW，GW添加该ARP表项，并生成32位主机路由，路由的下一跳为路由的目的地址本身。

在分布式网关组网中，每一个分布式网关都会将学习到的ARP通告给其他网关。在远端GW上，RT-2中的IP地址会下发到VPN实例的路由表形成32位主机路由，此路由的下一跳为通告此路由的GW设备。

### 2.2.3 外部路由通告与学习

EVPN VXLAN网络构建的是一个私有网络，它也可以通过接入外网，实现与外网的通信。通常在EVPN VXLAN的Spine-Leaf架构中，会部署一台或多台专门接入外网的设备，称之为Board leaf。Board leaf通过普通接口与外网之间运行普通路由协议，学习路由；之后，在Board leaf上EVPN VXLAN可以引入这些外部路由，形成EVPN RT-5（5类）路由，进而通告到EVPN VXLAN网络中，使其他VTEP也能学到这些外部路由。这些路由的下一跳均指向通告此路由的Board leaf。当网络中存在多台Board leaf时，这些Board leaf都可以通告此路由，从而形成等价路由，以达到负载分担的目的。

5类路由的格式如[图24](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref508111218)所示。

图24 RT-5路由格式

![img](https://resource.h3c.com/cn/202305/10/20230510_9004136_x_Img_x_png_24_1844394_30005_0.png)

 

如[图25](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref508111752)所示，外部路由通告与学习过程为：

(1)   Board leaf与WAN网络之间配置静态路由，或运行BGP、OSPF等动态路由协议。Board leaf学习到外网的路由。

(2)   在Board leaf上，将外部路由引入到EVPN，形成EVPN的5类路由，并发布给RR。

(3)   RR将Board leaf通告的5类路由反射给其他VTEP。

(4)   远端VTEP收到5类路由后，如果该路由携带的Export target属性与本地某个VPN实例的Import target属性匹配，将此路由添加到该VPN实例的路由表中。

图25 外部路由通告与学习过程

![img](https://resource.h3c.com/cn/202305/10/20230510_9004137_x_Img_x_png_25_1844394_30005_0.png)

 

### 2.2.4 MAC地址迁移

MAC地址迁移是指主机/虚拟机从其接入的VTEP迁到数据中心网络的另一台VTEP下。EVPN VXLAN通过在BGP update消息中携带MAC Mobility扩展团体属性，来确保主机/虚拟机迁移后，VTEP能够及时更新MAC/IP路由。

(1)   VTEP第一次发布某个MAC/IP路由时，BGP update消息中不携带MAC Mobility扩展团体属性。

(2)   主机/虚拟机迁移后，新迁移到的VTEP感知到主机/虚拟机上线，重新通告该MAC/IP路由，并在路由中携带MAC Mobility扩展团体属性。此扩展团体包含一个序列号。每次迁移，迁移序列号将递增。

(3)   远端VTEP接收到比自己本地保存的序列号更大的MAC/IP路由时，更新自己的MAC/IP路由消息，下一跳指向迁移后通告此路由的VTEP。

(4)   原VTEP在收到此路由更新后，撤销之前通告的路由。

### 2.2.5 ARP泛洪抑制

为了避免广播发送的ARP请求报文占用核心网络带宽，VTEP根据接收到的ARP请求和ARP应答报文、BGP EVPN的RT-2路由在本地建立ARP缓存表项。后续当VTEP收到本站点内虚拟机请求其它虚拟机MAC地址的ARP请求时，优先根据本地存储的ARP表项进行代理回应。如果没有对应的表项，则将ARP请求泛洪到核心网。ARP泛洪抑制功能可以大大减少ARP泛洪的次数。

图26 ARP泛洪抑制示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004138_x_Img_x_png_26_1844394_30005_0.png)

 

如[图26](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref333507040)所示，ARP泛洪抑制的处理过程如下：

(1)   虚拟机VM 1发送ARP请求，获取VM 7的MAC地址。

(2)   VTEP 1根据接收到的ARP请求，建立VM 1的ARP泛洪抑制表项，在VXLAN内泛洪该ARP请求（[图26](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref333507040)以单播路由泛洪方式为例）。VTEP 1还会通过BGP EVPN将该表项同步给VTEP 2和VTEP 3。

(3)   远端VTEP（VTEP 2和VTEP 3）解封装VXLAN报文，获取原始的ARP请求报文后，在本地站点的指定VXLAN内泛洪该ARP请求。

(4)   VM 7接收到ARP请求后，回复ARP应答报文。

(5)   VTEP 2接收到ARP应答后，建立VM 7的ARP泛洪抑制表项，通过VXLAN隧道将ARP应答发送给VTEP 1。VTEP 2通过BGP EVPN将该表项同步给VTEP 1和VTEP 3。

(6)   VTEP 1解封装VXLAN报文，获取原始的ARP应答，将ARP应答报文发送给VM 1。

(7)   在VTEP 1上建立ARP泛洪抑制表项后，虚拟机VM 4发送ARP请求，获取VM 1的MAC地址。

(8)   VTEP 1接收到ARP请求后，建立VM 4的ARP泛洪抑制表项，并查找本地ARP泛洪抑制表项，根据已有的表项回复ARP应答报文，不会对ARP请求进行泛洪。

(9)   虚拟机VM 10发送ARP请求，获取VM 1的MAC地址。

(10)   VTEP 3接收到ARP请求后，建立VM 10的ARP泛洪抑制表项，并查找ARP泛洪抑制表项，根据已有的表项（VTEP 1通过BGP EVPN同步）回复ARP应答报文，不会对ARP请求进行泛洪。

## 2.3 EVPN VXLAN数据平面工作机制

### 2.3.1 二层流量转发

#### 1. 转发已知单播流量

EVPN VXLAN通过控制平面完成MAC地址表项的学习。VTEP接收到二层数据帧后，判断其所属的VSI，根据目的MAC地址查找该VSI的MAC地址表，通过表项的出接口转发该数据帧。如果出接口为本地接口，则VTEP直接通过该接口转发数据帧；如果出接口为Tunnel接口，则VTEP根据Tunnel接口为数据帧添加VXLAN封装后，通过VXLAN隧道将其转发给远端VTEP。

#### 2. 转发BUM流量

除了单播流量转发，EVPN VXLAN网络中还需要转发广播，未知组播与未知单播流量，即BUM流量。EVPN VXLAN采用头端复制方式转发BUM流量。

VTEP接收到本地虚拟机发送的组播、广播和未知单播数据帧后，判断数据帧所属的VXLAN，通过该VXLAN内除接收接口外的所有本地接口和VXLAN隧道转发该数据帧。通过VXLAN隧道转发数据帧时，需要为其封装VXLAN头、UDP头和IP头，将泛洪流量封装在多个单播报文中，发送到VXLAN内的所有远端VTEP。VXLAN的头端复制列表（即BUM广播表）由EVPN自动发现并创建，不需要手工干预。

图27 BUM流量头端复制转发示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004139_x_Img_x_png_27_1844394_30005_0.png)

 

### 2.3.2 集中式网关转发

在EVPN集中式网关组网中，L2 VTEP将本地学到的ARP通过EVPN路由通告给GW。GW上创建ARP表项，ARP表项的MAC地址为虚拟机的MAC地址。GW还会根据ARP生成32位主机路由，路由的下一跳为路由的目的地址本身（即虚拟机的IP地址）。

集中式网关转发流量的方式为：

·   对于外网访问EVPN VXLAN网络内VM的流量，GW接收到报文后，进行三层查表转发，根据32位主机路由获取到下一跳为虚拟机的IP地址。GW查找虚拟机IP地址对应的ARP表项，将报文内层目的MAC地址封装为虚拟机的MAC地址，并添加VXLAN封装后发送给L2 VTEP。L2 VTEP解封装后，根据目的MAC地址进行二层转发，将报文发送给VM。

·   对于EVPN VXLAN网络内VM访问外网的流量，VM发送给VTEP的报文的目的MAC为GW的网关MAC。VTEP查找MAC地址表项，添加VXLAN封装后，将报文发送给GW。GW解封装后，根据内层报文的目的IP地址进行三层转发。此时，GW充当的是IP网关角色。

·   对于EVPN VXLAN网络内不同VM之间的流量，如果VM属于同一个VXLAN，则在VTEP上查找MAC地址表进行二层转发即可；如果VM属于不同的VXLAN，则VM发送给VTEP的报文的目的MAC为GW的网关MAC，需要经过GW进行三层转发，才能将报文转发到目的VXLAN。此时，GW充当的是VXLAN网关角色。

### 2.3.3 分布式网关对称IRB转发

在分布式网关对称IRB转发方式中，入口网关和出口网关上的处理方式相同。对于二层流量，入口网关和出口网关都只进行二层转发；对于三层流量，入口网关和出口网关都只进行三层转发。

#### 1. 基本概念

对称IRB转发引入了以下概念：

·   L3VNI（Layer 3 VNI）：是指在分布式网关之间通过VXLAN隧道转发流量时，属于同一租户（VPN实例）的流量通过L3VNI来标识。L3VNI唯一关联一个VPN实例，通过VPN实例确保不同租户之间的业务隔离。

·   Route MAC：网关的Router MAC地址，是指每个分布式网关拥有的唯一一个用来标识本机的本地MAC地址，此MAC用于在网关之间通过VXLAN隧道转发三层流量。报文在网关之间转发时，报文的内层MAC地址为出口网关的Router MAC地址。

#### 2. 分布式EVPN网关部署要求

如[图28](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref433893862)所示，在分布式EVPN网关组网中，所有的分布式EVPN网关（GW）上都存在以下类型的VSI虚接口：

·   作为分布式网关接口的VSI虚接口。该接口需要与VSI、VPN实例关联。不同GW上相同VSI虚接口的IP地址必须相同，该IP地址作为VXLAN内虚拟机的网关地址。

·   承载L3VNI的VSI虚接口。该接口需要与VPN实例关联，并需要指定L3VNI。关联相同VPN实例的VSI虚接口共用该L3VNI。

边界网关（Border leaf）上也需要存在承载L3VNI的VSI虚接口。

图28 分布式EVPN网关部署示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004140_x_Img_x_png_28_1844394_30005_0.png)

 

#### 3. 流量转发过程

分布式网关对流量的转发方式分为两种：

·   区分二三层转发方式：对于二层流量，查找MAC地址表进行转发；对于三层流量，查找FIB表进行转发。在该方式下，建议在分布式网关上开启ARP泛洪抑制功能，以减少泛洪流量。

·   全三层转发方式：对于二层和三层流量，均查找FIB表进行转发。在该方式下，需要在分布式网关上开启本地代理ARP功能。

查找MAC地址表转发二层流量的过程，请参见“[2.3.1 1. ](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref508119640)[转发已知单播流量](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref508119640)”；相同站点间三层流量的转发过程如[图29](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref508119938)所示；不同站点间三层流量转发过程如[图30](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref435278862)所示。

图29 相同站点间三层流量转发过程

![img](https://resource.h3c.com/cn/202305/10/20230510_9004141_x_Img_x_png_29_1844394_30005_0.png)

 

图30 不同站点间三层流量转发过程

![img](https://resource.h3c.com/cn/202305/10/20230510_9004143_x_Img_x_png_30_1844394_30005_0.png)

 

以IPv4网络为例，查找FIB表转发流量的过程为：

(1)   虚拟机访问相同子网、不同子网内的其他虚拟机时，发送ARP请求获取ARP信息。

(2)   GW接收到ARP请求后，判断ARP请求所属VSI，采用与该VSI关联的VSI虚接口MAC地址对其进行应答。

(3)   虚拟机将报文发送给GW。

(4)   GW判断报文所属VSI，并查找与该VSI关联的VSI虚接口，在与VSI虚接口关联的VPN实例内查找FIB表项，并根据匹配的FIB表项转发报文：

¡   如果FIB表项的出接口为本地接口，则GW将目的MAC替换为目的虚拟机的MAC地址、源MAC替换为VSI虚接口的MAC，并通过本地接口转发给目的虚拟机。

¡   如果FIB表项的出接口为VSI虚接口，则GW将目的MAC替换为目的GW的Router MAC地址、源MAC替换为自己的Router MAC，报文添加VXLAN封装后将其转发给目的GW。其中，为报文封装的VXLAN ID为与VPN实例关联的L3VNI。

(5)   目的GW接收到报文后，根据L3VNI判断报文所属的VPN实例，解除VXLAN封装后，在该VPN实例内查找ARP表项转发该报文。

在分布式网关组网中，每一台分布式网关只需要配置下挂的主机/虚拟机所在的VXLAN ID即可，且分布式网关不需要维护本租户内所有主机/虚拟机的ARP信息，只需要维护少量的远端分布式网关的ARP信息即可。

### 2.3.4 分布式网关非对称IRB转发

在分布式网关非对称IRB转发方式中，入口网关和出口网关上的处理方式不同。入口网关需要同时进行二层和三层转发，而出口网关只进行二层转发。

#### 1. 分布式EVPN网关部署要求

非对称IRB与对称IRB方式中，分布式EVPN网关的部署方式基本相同。

如[图28](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref433893862)所示，所有的分布式EVPN网关（GW）上都存在以下类型的VSI虚接口：

·   作为分布式网关接口的VSI虚接口。该接口需要与VSI、VPN实例关联。不同GW上相同VSI虚接口的IP地址不能相同。

·   承载L3VNI的VSI虚接口。在非对称IRB转发方式中，L3VNI用来实现VXLAN网络与外界网络的互通。当VXLAN内的虚拟机需要通过边界网关（Border）与外界通信时，GW上必须部署该类VSI虚接口。该接口需要与VPN实例关联，并需要指定L3VNI。关联相同VPN实例的VSI虚接口共用该L3VNI。

边界网关上也需要存在承载L3VNI的VSI虚接口。

#### 2. 三层流量转发过程

目前，非对称IRB转发方式仅支持通过分布式EVPN网关转发相同VXLAN的三层流量。

在非对称IRB转发方式中，GW学习到本地虚拟机的ARP信息后，通过MAC/IP发布路由将其通告给其他GW。其他GW学习ARP信息，并生成对应的FIB表项。

如[图31](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref36044018)所示，VM 1和VM 2属于VXLAN 10，通过分布式EVPN网关实现三层互通。分布式EVPN网关采用非对称IRB方式转发三层流量的过程为：

(1)   GW 1接收到VM 1发送的报文后，由于目的MAC地址为自己，GW 1剥离二层帧头，根据目的IP地址查找FIB表。

(2)   GW 1在FIB表中匹配到VM 2的ARP信息生成的FIB表项。

(3)   GW 1为报文封装源和目的MAC地址（分别为网关MAC地址和VM 2的MAC地址）、VXLAN头后，通过VXLAN隧道将其转发到GW 2。

(4)   GW 2接收到报文后，解除VXLAN封装，并在VXLAN 10内进行二层转发，即根据目的MAC地址查找MAC地址表。

(5)   GW 2根据MAC地址表查找结果，将报文转发给VM 2。

图31 非对称IRB三层流量转发过程

![img](https://resource.h3c.com/cn/202305/10/20230510_9004144_x_Img_x_png_31_1844394_30005_0.png)

 

## 2.4 EVPN VXLAN多归属

### 2.4.1 功能简介

当一个站点通过不同的以太网链路连接到多台VTEP时，这些链路就构成了一个ES（Ethernet Segment，以太网段），并以一个相同的ESI（ES Identifier）标识其属于同一个ES。连接的多台VTEP组成冗余备份组，可以避免VTEP单点故障对网络造成影响，从而提高EVPN网络的可靠性。

图32 多归属站点示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004145_x_Img_x_png_32_1844394_30005_0.png)

 

### 2.4.2 DF选举

当一个站点连接到多台VTEP时，为了避免冗余备份组中的VTEP均发送泛洪流量给该站点，需要在冗余备份组中选举一个VTEP作为DF（Designated Forwarder，指定转发者），负责将泛洪流量转发给本地站点。其他VTEP作为BDF（Backup DF，备份DF），不会向本地站点转发泛洪流量。多归属成员通过发送以太网段路由，向其它VTEP通告ES及其连接的VTEP信息，仅配置了ESI的VTEP会接收以太网段路由并根据其携带的ES、VTEP信息选举出DF。

设备支持多种DF选举算法，用户可以根据业务需要灵活地选择DF选举算法，使组网中DF能够均匀分布，提高网络设备的使用率。

图33 DF示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004146_x_Img_x_png_33_1844394_30005_0.png)

 

#### 2. 基于VLAN Tag的DF选举算法

基于VLAN Tag的DF选举算法根据VLAN Tag和VTEP的IP地址为每个AC选举DF。

图34 基于VLAN Tag的DF选举

![img](https://resource.h3c.com/cn/202305/10/20230510_9004147_x_Img_x_png_34_1844394_30005_0.png)

 

如[图34](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57033150)所示，以允许VLAN Tag 4通过的AC 1的DF选举为例，基于VLAN Tag的DF选举算法为：

(2)   选取AC内允许通过的最小VLAN Tag代表该AC。在本例中，代表AC 1的VLAN Tag为4。

(3)   VTEP根据接收到的以太网段路由，对携带相同ESI的路由中的源IP地址按升序排列，编号从0开始。在本例中，源IP 1.1.1.1、2.2.2.2对应的编号依次为0、1。

(4)   根据VLAN Tag除以N的余数M来选举DF，N代表冗余备份组中成员的数量，M对应的编号为该AC的DF。在本例中，4除以2的余数为0，即AC 1的DF为编号为0的VTEP 1。

#### 3. 基于优先级的DF选举算法

基于优先级的DF选举算法根据DF选举优先级、DP（Don't Preempt Me，不可回切）位和VTEP的IP地址为每个ES选举DF。其中，DP位的取值包括：

·   1：表示开启了基于优先级DF选举算法不回切功能。即当前设备被选举为DF后，即使后续选举出了新的设备作为DF，依然使用当前设备作为DF。

·   0：表示关闭了基于优先级DF选举算法不回切功能。即当前设备被选举为DF后，如果后续选举出了新的设备作为DF，则直接使用新的设备作为DF。

图35 基于优先级的DF选举

![img](https://resource.h3c.com/cn/202305/10/20230510_9004148_x_Img_x_png_35_1844394_30005_0.png)

 

如[图35](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57033160)所示，以ES 1、ES 2的DF选举为例，基于优先级的DF选举算法为：

(1)   同一ES内DF选举优先级（数值越大则优先级越高）最高的VTEP作为该ES的DF。在本例中，选举VTEP 2作为ES 1的DF。

(2)   若优先级相同，则DP位为1的VTEP作为DF。

(3)   若DP位相同，则IP地址小的VTEP作为DF。在本例中，选举VTEP 1作为ES 2的DF。

### 2.4.3 协议报文交互过程

### 2.4.4 水平分割

在多归属站点组网中，VTEP接收到站点发送的组播、广播和未知单播数据帧后，判断数据帧所属的VXLAN，通过该VXLAN内除接收接口外的所有本地接口和VXLAN隧道转发该数据帧。同一冗余备份组中的VTEP接收到该数据帧后会在本地所属的VXLAN内泛洪，这样数据帧会通过AC泛洪到本地站点，造成环路和站点的重复接收。EVPN通过水平分割解决该问题。水平分割的机制为：VTEP接收到同一冗余备份组中成员转发的广播、组播、未知单播数据帧后，不向具有相同ESI标识的ES转发该数据帧。

图36 水平分割

![img](https://resource.h3c.com/cn/202305/10/20230510_9004149_x_Img_x_png_36_1844394_30005_0.png)

 

### 2.4.5 别名

图37 别名示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004150_x_Img_x_png_37_1844394_30005_0.png)

 

如[图37](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57036212)所示，在多活冗余模式下，冗余备份组中可能仅有一台VTEP能学习到某些业务相关的MAC地址，这会导致远端PE仅能从这台VTEP收到这些MAC地址的MAC/IP发布路由，因此远端VTEP无法将访问这些MAC地址的流量负载分担到冗余备份组中的其它VTEP上。

为了解决这个问题，EVPN多归属引入了别名机制，即当冗余备份组中仅有一台VTEP通过MAC/IP发布路由向远端VTEP通告了Server侧MAC地址的可达性时，远端VTEP能够根据冗余备份组内VTEP发送的以太网自动发现路由（携带VTEP、ESI等信息）感知到冗余备份组中其它VTEP与MAC地址的可达性，并生成对应的MAC表项，从而形成负载分担。

### 2.4.6 MAC地址快速收敛

图38 MAC地址快速收敛示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004151_x_Img_x_png_38_1844394_30005_0.png)

 

如[图38](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57295597)所示，在EVPN网络中，MAC地址可达性是通过VTEP之间发布MAC/IP发布路由通告的。因此，在CE 1与VTEP 1间链路故障时，VTEP 1需要逐条撤销MAC/IP发布路由，在大规模的网络中会导致MAC地址收敛速度较慢。

EVPN多归属组网提供了快速收敛机制，使得VTEP可以通过撤销一条以太网自动发现路由，通告对指定ES内所有MAC地址的不可达性，通知远端VTEP批量删除MAC地址表项，减少收敛时间。

## 2.5 EVPN VXLAN支持组播

### 2.5.1 功能简介

为了避免组播发送的IGMP报文占用核心网络带宽，VTEP会根据接收到的报告报文和离开报文在本地建立或删除组播转发表项。通过SMET（Selective Multicast Ethernet Tag Route，选择性组播以太网标签路由）路由将组播组信息通告给其他VTEP，远端VTEP收到SMET路由后在本地建立组播转发表项。当VTEP再次收到属于同一IGMP版本加入同一组播组的报告报文时，将不再发送SMET路由。EVPN VXLAN支持组播功能可以大大减少IGMP报文泛洪的次数。

为了支持组播，MP-BGP在EVPN地址族新增了SMET、IGMP-JS和IGMP-LS三类EVPN路由，详细介绍请参见“[1.4 ](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57204119)[BGP EVPN路由](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57204125)”。

### 2.5.2 单归属站点组播

如[图39](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref505707708)所示，在单归属站点组网中，Server 1发出IGMP成员关系报告报文至VTEP 1。VTEP 1上生成相应的组播表项，并发送SMET路由将组播信息通告给VTEP 2和VTEP 3。VTEP 2和VTEP 3收到SMET路由后形成下一跳为VTEP 1的组播表项。

图39 单归属站点组播示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004152_x_Img_x_png_39_1844394_30005_0.png)

 

### 2.5.3 多归属站点组播

站点多归属组网中，站点侧发送的加入组播组报文和离开组播组报文，会被不同的VTEP接收。为了在多归属站点间管理站点的组播表项，收到加入和离开组播组报文的VTEP会发送IGMP-JS路由和IGMP-LS路由来告诉其他成员，保证同ESI成员VTEP间组播信息的同步。

图40 多归属站点组播示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004154_x_Img_x_png_40_1844394_30005_0.png)

 

如[图40](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref505071518)所示，多归属站点组播处理过程如下：

·   当接收报告报文的设备为DF（VTEP 1）时，DF通告SMET路由给VTEP 2和VTEP 3，并通告IGMP-JS路由给VTEP 2。当组播接收者离开组播组时：

¡   若接收离开报文的设备为DF，则DF通告IGMP-LS路由并撤销IGMP-JS路由和SMET路由。

¡   若接收离开报文的设备为BDF（VTEP 2），则BDF通告IGMP-LS路由给同一冗余备份中的其他成员。DF收到BDF同步的IGMP-LS路由后，撤销IGMP-JS路由和SMET路由。

·   当接收报告报文的设备为BDF时，BDF通告IGMP-JS路由给同一冗余备份中的其他成员，DF收到IGMP-JS路由后生成SMET路同步给VTEP 2和VTEP 3。当组播接收者离开组播组时：

¡   若接收离开报文的设备为DF，则DF通告IGMP-LS路由给同一冗余备份中的其他成员。BDF收到IGMP-LS路由后撤销IGMP-JS路由。DF收到撤销IGMP-JS路由后，撤销由IGMP-JS路由生成的SMET路由。

¡   若接收离开报文的设备为BDF，则BDF通告IGMP-LS路由并撤销IGMP-JS路由。DF收到撤销IGMP-JS路由后，会撤销由该IGMP-JS路由生成的SMET路由。

## 2.6 典型组网应用

### 2.6.1 EVPN分布式网关组网

EVPN分布式网关组网中，对网关设备转发能力的要求没有集中式网关那么高，且在核心设备只需要支持普通的IP转发即可，因此，EVPN分布式网关应用非常广泛。

EVPN分布式网关的典型组网如[图41](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref508121563)所示。VTEP为EVPN分布式网关设备；Border leaf为与广域网连接的边界网关设备，部署两台Border leaf，形成备份；RR负责在交换机之间反射BGP路由。

图41 EVPN分布式网关组网示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004155_x_Img_x_png_41_1844394_30005_0.png)

 

### 2.6.2 EVPN数据中心互联组网

EVPN数据中心互联技术通过在数据中心之间建立VXLAN-DCI（VXLAN Data Center Interconnect，VXLAN数据中心互联）隧道，实现不同数据中心之间虚拟机的互通。

如[图42](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref508122482)所示，数据中心的边缘设备为ED（Edge Device，边缘设备）。ED之间建立VXLAN-DCI隧道，该隧道采用VXLAN封装格式。ED与数据中心内部的VTEP建立VXLAN隧道。ED从VXLAN隧道或VXLAN-DCI隧道上接收到报文后，解除VXLAN封装，根据目的IP地址重新对报文进行VXLAN封装，并将其转发到VXLAN-DCI隧道或VXLAN隧道，从而实现跨数据中心之间的互通。

图42 VXLAN数据中心互联典型组网图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004156_x_Img_x_png_42_1844394_30005_0.png)

 

### 2.6.3 EVPN与SDN控制器配合组网

SDN（Software Defined Network，软件定义网络）是一种新型的网络架构，它将控制平面与转发平面分离，由SDN控制器集中控制和管理整网的设备。如[图43](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref508199768)所示，EVPN可以与SDN控制器配合使用，EVPN网络中的所有设备均由SDN控制器通过标准协议集中管理，减少了传统设备管理的复杂性。同时，当用户业务扩展时，通过集中管理，用户可以方便快速地部署网络设备，便于网络的扩展和管理。

图43 EVPN与SDN控制器配合组网

![img](https://resource.h3c.com/cn/202305/10/20230510_9004157_x_Img_x_png_43_1844394_30005_0.png)

 



# 3 EVPN VPLS

## 3.1 EVPN VPLS 网络模型

图44 EVPN VPLS网络模型示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004158_x_Img_x_png_44_1844394_30005_0.png)

 

如[图44](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref536021565)所示，EVPN VPLS网络中主要包括如下几部分：

·   CE（Customer Edge，用户网络边缘）：直接与服务提供商网络相连的用户网络侧设备。

·   PE（Provider Edge，服务提供商网络边缘）：与CE相连的服务提供商网络侧设备。PE主要负责EVPN VPLS业务的接入，完成报文从用户网络到公网隧道、从公网隧道到用户网络的映射与转发。

·   AC（Attachment Circuit，接入电路）：连接CE和PE的物理电路或虚拟电路。

·   PW（Pseudowire，伪线）：两个PE之间的虚拟双向连接。PW由一对方向相反的单向虚拟连接构成。

·   公网隧道（Tunnel）：穿越IP或MPLS骨干网、用来承载PW的隧道。一条公网隧道可以承载多条PW，公网隧道可以是LSP、GRE隧道或MPLS TE隧道。

·   VSI（Virtual Switch Instance，虚拟交换实例）：VSI是PE设备上为一个VPLS实例提供二层交换服务的虚拟实例。VSI可以看作PE设备上的一台虚拟交换机，它具有传统以太网交换机的所有功能，包括源MAC地址学习、MAC地址老化、泛洪等。VPLS通过VSI实现在VPLS实例内转发二层数据报文。

## 3.2 EVPN VPLS控制平面工作机制

### 3.2.1 建立PW

EVPN VPLS组网中，PW的建立过程为：

(1)   PE为每个VSI实例分配两个PW标签，分别用于转发已知单播报文和BUM（Broadcast/Unknown unicast/Unknown Multicast，广播/未知单播/未知组播）报文。

(2)   本端PE通过MAC/IP发布路由将转发已知单播报文的PW标签通告给远端PE；通过IMET路由将转发BUM报文的PW标签通告给远端PE。路由中携带VPN Target属性。

(3)   远端PE接收到MAC/IP发布路由或IMET路由后，将路由中的VPN Target属性与EVPN实例的Import Target进行匹配，如果一致则根据路由中携带的PE地址（对于MAC/IP发布路由，为路由的下一跳地址；对于IMET路由，为PSMI tunnel attributes中Tunnel Identifier字段携带的地址）、PW标签等信息建立一条单向的虚拟连接。

(4)   当两端的PE间建立了两条方向相反的单向虚拟连接，则PW建立完成。

### 3.2.2 MAC地址学习、老化和回收

#### 1. MAC地址学习

PE根据学习到的MAC地址表项转发二层单播流量。PE上MAC地址学习分为两部分：

·   本地MAC地址学习：PE接收到本地CE发送的数据帧后，判断该数据帧所属的VSI，并将数据帧中的源MAC地址（本地CE的MAC地址）添加到该VSI的MAC地址表中，该MAC地址对应的接口为接收到数据帧的接口。

·   远端MAC地址学习：PE通过MAC/IP发布路由将本地学习的MAC地址通告给远端PE。远端PE接收到该信息后，将其添加到对应的VSI的MAC地址表中，该MAC地址的出接口为两个PE之间PW的索引。

#### 2. MAC地址老化

·   本地MAC地址老化：PE学习本地MAC地址后，如果MAC地址老化定时器超时，则删除该MAC地址表项，减少占用的MAC地址表资源。

·   远端MAC地址老化：PE从MAC/IP发布路由中学习远端MAC地址，在接收到撤销该MAC地址的路由前，MAC地址会一直存在MAC地址表中。

#### 3. MAC地址回收

AC状态变为down时，EVPN会向所有远端PE发送MAC/IP发布路由撤销消息来撤销该AC对应的MAC地址，远端PE根据撤销消息删除指定VSI内的指定MAC地址，以加快MAC地址表的收敛速度。

### 3.2.3 MAC地址迁移

MAC地址迁移是指主机/虚拟机从其接入的PE迁到另一台PE下。EVPN VPLS通过在BGP update消息中携带MAC Mobility扩展团体属性，来确保主机/虚拟机迁移后，VTEP能够及时更新MAC/IP路由。

(1)   PE第一次发布某个MAC/IP路由时，BGP update消息中不携带MAC Mobility扩展团体属性。

(2)   主机/虚拟机迁移后，新迁移到的PE感知到主机/虚拟机上线，重新通告该MAC/IP路由，并在路由中携带MAC Mobility扩展团体属性。此扩展团体包含一个序列号。每次迁移，迁移序列号将递增。

(3)   远端PE接收到比自己本地保存的序列号更大的MAC/IP路由时，更新自己的MAC/IP路由消息，下一跳指向迁移后通告此路由的PE。

(4)   原VTEP在收到此路由更新后，撤销之前通告的路由。

### 3.2.4 ARP泛洪抑制

为了避免广播发送的ARP请求报文占用核心网络带宽，PE会根据接收到的ARP请求和ARP应答报文、BGP EVPN路由在本地建立ARP泛洪抑制表项。当PE再收到本地站点内虚拟机请求其它虚拟机MAC地址的ARP请求时，优先根据ARP泛洪抑制表项进行代答。如果没有对应的表项，则通过PW将ARP请求泛洪到其他站点。ARP泛洪抑制功能可以大大减少ARP泛洪的次数。

图45 ARP泛洪抑制示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004159_x_Img_x_png_45_1844394_30005_0.png)

 

如[图45](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref536114233)所示，ARP泛洪抑制的处理过程如下：

(1)   虚拟机CE 1发送ARP请求，获取CE 2的MAC地址。

(2)   PE 1根据接收到的ARP请求，建立CE 1的ARP泛洪抑制表项，向VSI内的本地CE和远端PE（PE 2和PE 3）泛洪该ARP请求（[图45](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref536114233)以单播路由泛洪方式为例）。PE 1还会通过BGP EVPN将该表项同步给PE 2和PE 3。

(3)   远端PE解封装报文，获取原始的ARP请求报文后，向VSI内的本地CE泛洪该ARP请求。

(4)   CE 2接收到ARP请求后，回复ARP应答报文。

(5)   PE 2接收到ARP应答后，建立CE 2的ARP泛洪抑制表项，通过PW将ARP应答发送给PE 1。PE 2通过BGP EVPN将该表项同步给PE 1和PE 3。

(6)   PE 1解封装报文并获取原始的ARP应答，将ARP应答报文发送给CE 1。

(7)   在PE 1上建立ARP泛洪抑制表项后，CE 4发送ARP请求，获取CE 1的MAC地址。

(8)   PE 1接收到ARP请求后，建立CE 4的ARP泛洪抑制表项，并查找本地ARP泛洪抑制表项，根据已有的表项回复ARP应答报文，不会对ARP请求进行泛洪。

(9)   CE 3发送ARP请求，获取CE 1的MAC地址。

(10)   PE 3接收到ARP请求后，建立CE 3的ARP泛洪抑制表项，并查找ARP泛洪抑制表项，根据已有的表项（PE 1通过BGP EVPN同步）回复ARP应答报文，不会对ARP请求进行泛洪。

## 3.3 EVPN VPLS数据平面工作机制

### 3.3.1 本地站点接入模式

本地站点可以通过以下几种方式接入EVPN VPLS网络：

·   端口模式

本地站点通过三层以太网接口接入EVPN VPLS网络。从该接口收到的所有报文都属于三层以太网接口关联的VSI。

在这种接入模式下，三层以太网接口作为AC。

·   VLAN模式

本地站点通过三层以太网子接口接入EVPN VPLS网络。从三层以太网接口接收到的、所有被该子接口终结的VLAN的报文都属于三层以太网子接口关联的VSI。

在这种接入模式下，三层以太网子接口作为AC。

·   灵活匹配模式

本地站点通过二层以太网接口上的以太网服务实例接入EVPN VPLS网络。通过以太网服务实例的报文匹配规则（如匹配接口接收到的所有报文、所有携带VLAN Tag的报文和所有不携带VLAN Tag的报文等），灵活匹配来自用户网络的报文。从接口接收到的、符合报文匹配规则的报文，属于以太网服务实例关联的VSI。

在这种接入模式下，以太网服务实例作为AC。

VTEP从本地站点接收到报文后，根据接入模式判断报文所属的VSI，以便在VSI内转发该报文。

### 3.3.2 流量转发

#### 1. 转发已知单播流量

·   PE从AC接收到已知单播报文后，会在对应的VSI内查找MAC地址表，从而确定如何转发报文：

¡   表项的出接口为PW索引时，为报文封装PW标签（用于转发已知单播报文的PW标签），再添加公网隧道封装后，通过PW将该报文转发给远端PE。如果公网隧道为LSP或MPLS TE隧道，则通过PW转发报文时将为报文封装两层标签。内层标签为PW标签，用来将报文转发给相应的VSI；外层标签为公网LSP或MPLS TE隧道标签，用来保证报文在PE之间正确传送。

¡   表项的出接口为连接本地CE的接口时，直接通过出接口将报文转发给本地CE。

·   PE从PW接收到已知单播报文后，在其所属的VSI内查找MAC地址表，出接口应为连接本地站点的接口，PE通过该出接口将报文转发给本地站点。

#### 2. 转发泛洪流量

PE从AC上接收到泛洪流量后，向该AC关联的VSI内的所有其他AC泛洪该报文，并查找该VSI内所有用于转发BUM流量的PW标签，为报文分别封装这些PW标签后，将该报文泛洪给所有远端PE。

PE从PW上接收到泛洪流量后，向该PW所属VSI内的所有AC泛洪该报文。

### 3.3.3 全连接和水平分割

为避免环路，一般的二层网络都要求使用环路预防协议，比如STP（Spanning Tree Protocol，生成树协议）。但在骨干网的PE上部署环路预防协议，会增加管理和维护的难度。因此，EVPN VPLS采用如下方法避免环路：

·   PE之间建立全连接，即一个EVPN实例内的每两个PE之间必须都建立PW。

·   采用水平分割转发规则，即从PW上收到的泛洪报文禁止向其他PW转发，只能转发到AC。

## 3.4 EVPN VPLS多归属

### 3.4.1 功能简介

EVPN多归属是指一个站点通过不同的以太网链路接入EVPN网络中的多台PE，接入的多台PE组成冗余备份组，该站点的流量在多台PE间进行负载分担。利用多归属技术可以避免PE单点故障造成EVPN网络通信中断，从而提高EVPN网络的可靠性。

EVPN多归属的网络模型如[图46](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57204751)所示，其中：

·   站点CE 1接入的多台PE组成冗余备份组。

·   接入冗余备份组中不同PE的一组链路，组成一个ES（Ethernet Segment，以太网段），它们具有相同的ESI （Ethernet Segment Identifier，以太网段标识）。

·   通过ES接入冗余备份组的站点，称为多归属站点。

图46 多归属站点示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004160_x_Img_x_png_46_1844394_30005_0.png)

 

### 3.4.2 DF选举

当一个CE连接到多台PE时，为了避免冗余备份组中的PE均发送泛洪流量给该CE，需要在冗余备份组中选举一个PE作为DF（Designated Forwarder，指定转发者），负责将泛洪流量转发给本地站点。其他PE作为BDF（Backup DF，备份DF），不会向本地CE转发泛洪流量。

DF的选举过程为：

(1)   冗余备份组中的PE设备之间互相发送以太网段路由，通告ES的ESI值及其连接的PE信息（如IP地址、优先级等）。

(2)   PE接收到以太网段路由后，如果路由中携带的ESI值与本地相同，则PE记录发送该路由的PE信息，以便生成连接到同一ES的所有PE的列表。

(3)   冗余备份组中的PE设备根据以太网段路由中的PE信息选举出DF。

设备支持多种DF选举算法，用户可以根据业务需要灵活地选择DF选举算法，使组网中DF能够均匀分布，提高网络设备的使用率。

图47 DF示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004161_x_Img_x_png_47_1844394_30005_0.png)

 

#### 2. 基于VLAN Tag的DF选举算法

基于VLAN Tag的DF选举算法根据VLAN Tag和VTEP的IP地址为每个AC选举DF。

图48 基于VLAN Tag的DF选举

![img](https://resource.h3c.com/cn/202305/10/20230510_9004162_x_Img_x_png_48_1844394_30005_0.png)

 

如[图48](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57036326)所示，以允许VLAN Tag 4通过的AC 1的DF选举为例，基于VLAN Tag的DF选举算法为：

(2)   选取AC内允许通过的最小VLAN Tag代表该AC。在本例中，代表AC 1的VLAN Tag为4。

(3)   VTEP根据接收到的以太网段路由，对携带相同ESI的路由中的源IP地址按升序排列，编号从0开始。在本例中，源IP 1.1.1.1、2.2.2.2对应的编号依次为0、1。

(4)   根据VLAN Tag除以N的余数M来选举DF，N代表冗余备份组中成员的数量，M对应的编号为该AC的DF。在本例中，4除以2的余数为0，即AC 1的DF为编号为0的VTEP 1。

#### 3. 基于优先级的DF选举算法

基于优先级的DF选举算法根据DF选举优先级、DP（Don't Preempt Me，不可回切）位和VTEP的IP地址为每个ES选举DF。其中，DP位的取值包括：

·   1：表示开启了基于优先级DF选举算法不回切功能。即当前设备被选举为DF后，即使后续选举出了新的设备作为DF，依然使用当前设备作为DF。

·   0：表示关闭了基于优先级DF选举算法不回切功能。即当前设备被选举为DF后，如果后续选举出了新的设备作为DF，则直接使用新的设备作为DF。

图49 基于优先级的DF选举

![img](https://resource.h3c.com/cn/202305/10/20230510_9004163_x_Img_x_png_49_1844394_30005_0.png)

 

如[图49](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57036325)所示，以ES 1、ES 2的DF选举为例，基于优先级的DF选举算法为：

(2)   同一ES内DF选举优先级（数值越大则优先级越高）最高的VTEP作为该ES的DF。在本例中，选举VTEP 2作为ES 1的DF。

(3)   若优先级相同，则DP位为1的VTEP作为DF。

(4)   若DP位相同，则IP地址小的VTEP作为DF。在本例中，选举VTEP 1作为ES 2的DF。

### 3.4.3 冗余备份模式

当前设备支持多活冗余模式，在该模式下：

·   出多归属站点方向流量：多归属站点可以通过冗余备份组中多台PE访问其它站点。

·   入多归属站点方向流量：其它站点的已知单播流量可以通过冗余备份组中多台PE访问多归属站点；其它站点的未知单播流量、广播流量和组播流量仅可以通过冗余备份组中作为DF的PE访问多归属站点。

·   负载分担：站点间可以通过冗余备份组中多台PE互相访问，CE之间存在多条可达链路，可以形成负载分担。

### 3.4.4 协议报文交互过程

### 3.4.5 别名

图50 别名示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004165_x_Img_x_png_50_1844394_30005_0.png)

 

如[图50](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57036327)所示，在多活冗余模式下，冗余备份组中可能仅有一台PE能学习到某些业务相关的MAC地址，这会导致远端PE仅能从这台PE收到这些MAC地址的MAC/IP发布路由，因此远端PE无法将访问这些MAC地址的流量负载分担到冗余备份组中的其它PE上。

为了解决这个问题，EVPN多归属引入了别名机制，即当冗余备份组中仅有一台PE通过MAC/IP发布路由向远端PE通告了CE侧MAC地址的可达性时，远端PE能够根据冗余备份组内PE发送的以太网自动发现路由（携带PE、ESI等信息）感知到冗余备份组中其它PE与MAC地址的可达性，并生成对应的MAC表项，从而形成负载分担。

### 3.4.6 MAC地址快速收敛

图51 MAC地址快速收敛示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004166_x_Img_x_png_51_1844394_30005_0.png)

 

如[图51](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57295703)所示，在EVPN网络中，MAC地址可达性是通过PE之间发布MAC/IP发布路由通告的。因此，在CE 1与PE 1间链路故障时，PE 1需要逐条撤销MAC/IP发布路由，在大规模的网络中会导致MAC地址收敛速度较慢。

EVPN多归属组网提供了快速收敛机制，使得PE可以通过撤销一条以太网自动发现路由，通告对指定ES内所有MAC地址的不可达性，通知远端PE批量删除MAC地址表项，减少收敛时间。

## 3.5 LDP PW或静态PW接入EVPN PW

在实际组网中，可能会存在传统的VPLS网络与EVPN VPLS网络共存的情况。LDP PW或静态PW接入EVPN PW功能，通过将VPLS网络中的LDP PW或静态PW看作EVPN VPLS网络的AC（该PW称为UPW），实现报文在EVPN PW与UPW之间相互转发，从而实现VPLS网络与EVPN VPLS网络的互通。

本功能不仅支持一条LDP PW或静态PW接入一条EVPN PW，还支持将两条LDP PW或静态PW多归属接入两条EVPN PW。如[图52](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref54889595)所示，在VPLS网络中，PE 1与PE 2、PE 3分别建立主备LDP PW或静态PW，该PW称为UPW；在EVPN VPLS网络中，PE 4与PE 2、PE 3分别建立EVPN PW。UPW作为EVPN VPLS网络中的AC，PE 2或PE 3从UPW接收到报文后，会解除MPLS封装，查找MAC地址表获取到对应的EVPN PW，为报文添加该EVPN PW对应的MPLS封装，并将其转发给PE 4；PE 2或PE 3从EVPN PW接收报文的处理方法与此类似。

图52 LDP PW或静态PW接入EVPN PW组网示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004167_x_Img_x_png_52_1844394_30005_0.png)

 

## 3.6 典型组网应用

### 3.6.1 多归属组网

为了避免PE单点故障造成报文转发中断，EVPN VPLS通常采用多归属组网方式。多归属站点的流量在多台PE之间进行负载分担，即所有PE均转发流量，以提高网络的可靠性。

图53 多归属组网方式

![img](https://resource.h3c.com/cn/202305/10/20230510_9004168_x_Img_x_png_53_1844394_30005_0.png)

 

### 3.6.2 E-Tree组网

在EVPN VPLS组网中，属于同一个VSI的所有AC均可以互相访问。在EVPN VPLS网络中，为了提高AC侧用户业务的安全性，减少用户业务之间的相互影响，网络管理员可能需要控制AC侧用户之间的相互访问。E-Tree功能通过将AC分为Root和Leaf两种角色，实现了同一VSI内AC之间流量的隔离：

·   Leaf AC连接的用户只能和Root AC连接的用户相互访问。

·   不同Leaf AC连接的用户之间相互隔离。

·   Root AC连接的用户可以与VSI内所有AC连接的用户相互访问。

图54 EVPN E-Tree示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004169_x_Img_x_png_54_1844394_30005_0.png)

 

 



# 4 EVPN VPWS

## 4.1 网络模型

图55 EVPN VPWS网络模型示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004170_x_Img_x_png_55_1844394_30005_0.png)

 

如[图55](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref528138671)所示，EVPN VPWS的典型网络模型中包括如下几部分：

·   CE（Customer Edge，用户网络边缘）：直接与服务提供商网络相连的用户网络侧设备。

·   PE（Provider Edge，服务提供商网络边缘）：与CE相连的服务提供商网络侧设备。PE主要负责EVPN业务的接入，完成报文从用户网络到公网隧道、从公网隧道到用户网络的映射与转发。

·   AC（Attachment Circuit，接入电路）：连接CE和PE的物理电路或虚拟电路，例如Frame Relay的DLCI、ATM的VPI/VCI、Ethernet接口、VLAN、物理接口上的PPP连接。

·   PW（Pseudowire，伪线）：两个PE之间的虚拟双向连接。PW由一对方向相反的单向虚拟连接构成。

·   公网隧道（Tunnel）：穿越IP或MPLS骨干网、用来承载PW的隧道。一条公网隧道可以承载多条PW，公网隧道可以是LSP、GRE隧道或MPLS TE隧道。

·   交叉连接（Cross connect）：由两条物理电路或虚拟电路串连而成的一条连接，从一条物理、虚拟电路收到的报文直接交换到另一条物理、虚拟电路转发。交叉连接包括二种方式：AC到AC交叉连接和AC到PW交叉连接。

## 4.2 EVPN VPWS控制平面工作机制

### 4.2.1 工作机制综述

EVPN VPWS通过穿越IP或MPLS骨干网络的PW连接两端的用户网络，为用户提供点对点的二层服务。

EVPN VPWS控制平面的工作机制为：

(1)   建立公网隧道，公网隧道用来承载PE之间的一条或多条PW。

(2)   建立用来传送特定用户网络报文的PW，PW标签标识了报文所属的用户网络。

(3)   建立用来连接CE和PE的AC，AC的报文匹配规则（显式配置或隐含的规则）决定了从CE接收到的哪些报文属于一个特定的用户网络。

(4)   将AC和PW关联，以便PE确定从AC接收到的报文向指定PW转发，从PW接收到的报文向指定AC转发。

完成上述工作后，PE从AC接收到用户网络的报文后，根据AC关联的PW为报文封装PW标签，并通过公网隧道将报文转发给远端PE；远端PE从公网隧道接收到报文后，根据PW标签判断报文所属的PW，并将还原后的原始报文转发给与该PW关联的AC。

### 4.2.2 建立公网隧道

公网隧道用来承载PW，可以是LSP隧道、MPLS TE隧道和GRE隧道等。不同隧道的建立方式不同，详细介绍请参见相关手册。

当两个PE之间存在多条公网隧道时，可以通过配置隧道策略，确定如何选择隧道。

![说明](https://resource.h3c.com/cn/202305/10/20230510_9004171_x_Img_x_png_56_1844394_30005_0.png)

如果PW建立在LSP或MPLS TE隧道之上，则PW上传送的报文将包括两层标签：内层标签为PW标签，用来决定报文所属的PW，从而将报文转发给正确的CE；外层标签为公网LSP或MPLS TE隧道标签，用来保证报文在MPLS网络正确传送。

 

### 4.2.3 建立PW

如[图56](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57205682)所示，PW的建立过程为：

(1)   在PE 1、PE 2上均配置Local service ID来标识与其连接的CE，配置Remote service ID来标识远端PE连接的CE，并为每个Local service ID分配MPLS标签（即PW标签），该标签作为PW的入标签。

(2)   本地PE（如PE 1）通过Ethernet Auto-discovery Per EVI路由将Local service ID和为其分配的PW标签通告给远端PE（如PE 2）。

(3)   如果路由中的Export target属性与PE 2本地配置的Import target属性相同，则PE 2将接收到的Local service ID与本地配置的Remote service ID匹配。若二者相同，则建立一条从PE 2到PE 1的单向LSP，PE 1通告的PW标签作为该LSP的出标签。

(4)   同时，PE 2也会向PE 1发送Ethernet Auto-discovery Per EVI路由。PE 1将接收到的Local service ID与本地配置的Remote service ID匹配。若二者相同，则建立一条从PE 1到PE 2的单向LSP。

(5)   当两端PE间建立了两条方向相反的单向LSP时，EVPN PW建立完成。

图56 建立PW示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004172_x_Img_x_png_57_1844394_30005_0.png)

 

### 4.2.4 建立AC

在EVPN VPWS中，AC是与交叉连接关联的三层以太网接口、三层以太网子接口或以太网服务实例。以太网服务实例在二层以太网接口上创建，它定义了一系列匹配规则，用来匹配从该二层以太网接口上接收到的数据帧。

### 4.2.5 关联AC和PW

通过命令行将AC连接对应的三层以太网接口、三层以太网子接口或以太网服务实例与PW关联，即可实现从该AC接收到的报文通过关联的PW转发，从关联的PW上接收到的报文通过该AC转发。

## 4.3 EVPN VPWS数据平面工作机制

如[图57](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57206112)所示，PE从AC/PW接收到报文后，会在对应的交叉连接内查找出方向PW或AC信息，从而确定如何转发报文：

·   出接口为PW索引时，为报文封装PW标签，再添加公网隧道封装后，通过PW将该报文转发给远端PE。如果公网隧道为LSP或MPLS TE隧道，则通过PW转发报文时将为报文封装两层标签。内层标签为PW标签，用来将报文转发给相应的PW；外层标签为公网LSP或MPLS TE隧道标签，用来保证报文在PE之间正确传送。

·   出接口为连接本地CE的接口时，直接通过出接口将报文转发给本地CE。

图57 EVPN VPWS报文转发过程

![img](https://resource.h3c.com/cn/202305/10/20230510_9004173_x_Img_x_png_58_1844394_30005_0.png)

 

## 4.4 EVPN VPWS多归属

### 4.4.1 功能简介

当一个站点通过不同的以太网链路连接到多台PE时，这些链路就构成了一个ES（Ethernet Segment，以太网段），并以一个相同的ESI（ES Identifier）标识其属于同一个ES。连接的多台PE组成冗余备份组，可以避免PE单点故障对网络造成影响，从而提高网络的可靠性。目前仅支持双归属。

图58 多归属站点示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004174_x_Img_x_png_59_1844394_30005_0.png)

 

### 4.4.2 冗余备份模式

EVPN VPWS组网场景支持的冗余备份模式包括：单活冗余模式和多活冗余模式。

·   单活冗余模式

如[图59](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref10706258)所示，单活冗余模式下，PE 1和PE 2中仅其中一台转发流量，PE 1和PE 2上的两条PW为主备关系，实现当主PW出现故障后，将流量立即切换到备份PW，使流量转发得以继续。通过DF选举可以确定主备PW，DF选举的详细介绍，请参见“[4.4.3 ](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref530410749)[DF选举](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref530410749)”。当PE 1的PW不可用（可能是PE 1节点故障，也可能是PW故障）时，PE 3将启用备份PW，通过备份PW将CE 2的报文转发给PE 2，再由PE 2转发给CE 1；同时建议在PE 1设备AC侧的物理接口与PW侧的物理接口（用于建立EVPN PW的接口）配置EAA和Track联动的CLI监控策略，使这两个接口联动，可以确保PW侧的Underlay网络断开时，将AC侧的接口置于Down状态，使CE 1到CE 2的流量通过PE 2转发。

图59 单活冗余模式示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004176_x_Img_x_png_60_1844394_30005_0.png)

 

·   多活冗余模式

多活冗余模式下，两条PW等价负载分担转发数据报文。该模式下也需要在PE设备AC侧的物理接口与PW侧的物理接口（用于建立EVPN PW的接口）配置EAA和Track联动的CLI监控策略，使这两个接口联动，提高网络可靠性。

### 4.4.3 DF选举

在单活冗余模式下，数据报文仅通过一条PW转发，此时需要在冗余备份组中选举一个PE作为DF（Designated Forwarder，指定转发者），该PE上创建的PW为主PW。其他PE作为BDF（Backup DF，备份DF），其上创建的PW为备份PW。多归属成员通过发送以太网段路由，向其它PE通告ES及PE信息，仅配置了ESI的PE会接收以太网段路由并根据其携带的ES和PE信息选举出DF。

设备支持多种DF选举算法，用户可以根据业务需要灵活地选择DF选举算法，使组网中DF能够均匀分布，提高网络设备的使用率。

图60 DF示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004177_x_Img_x_png_61_1844394_30005_0.png)

 

#### 2. 基于VLAN Tag的DF选举算法

基于VLAN Tag的DF选举算法根据VLAN Tag和VTEP的IP地址为每个AC选举DF。

图61 基于VLAN Tag的DF选举

![img](https://resource.h3c.com/cn/202305/10/20230510_9004178_x_Img_x_png_62_1844394_30005_0.png)

 

如[图61](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57037386)所示，以允许VLAN Tag 4通过的AC 1的DF选举为例，基于VLAN Tag的DF选举算法为：

(1)   选取AC内允许通过的最小VLAN Tag代表该AC。在本例中，代表AC 1的VLAN Tag为4。

(2)   VTEP根据接收到的以太网段路由，对携带相同ESI的路由中的源IP地址按升序排列，编号从0开始。在本例中，源IP 1.1.1.1、2.2.2.2对应的编号依次为0、1。

(3)   根据VLAN Tag除以N的余数M来选举DF，N代表冗余备份组中成员的数量，M对应的编号为该AC的DF。在本例中，4除以2的余数为0，即AC 1的DF为编号为0的VTEP 1。

#### 3. 基于优先级的DF选举算法

基于优先级的DF选举算法根据DF选举优先级、DP（Don't Preempt Me，不可回切）位和VTEP的IP地址为每个ES选举DF。其中，DP位的取值包括：

·   1：表示开启了基于优先级DF选举算法不回切功能。即当前设备被选举为DF后，即使后续选举出了新的设备作为DF，依然使用当前设备作为DF。

·   0：表示关闭了基于优先级DF选举算法不回切功能。即当前设备被选举为DF后，如果后续选举出了新的设备作为DF，则直接使用新的设备作为DF。

图62 基于优先级的DF选举

![img](https://resource.h3c.com/cn/202305/10/20230510_9004179_x_Img_x_png_63_1844394_30005_0.png)

 

如[图62](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57037387)所示，以ES 1、ES 2的DF选举为例，基于优先级的DF选举算法为：

(1)   同一ES内DF选举优先级（数值越大则优先级越高）最高的VTEP作为该ES的DF。在本例中，选举VTEP 2作为ES 1的DF。

(2)   若优先级相同，则DP位为1的VTEP作为DF。

(3)   若DP位相同，则IP地址小的VTEP作为DF。在本例中，选举VTEP 1作为ES 2的DF。

### 4.4.4 协议报文交互过程

### 4.4.5 别名与备份路径

#### 1. 单活冗余模式下的备份路径机制

图63 备份路径示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004180_x_Img_x_png_64_1844394_30005_0.png)

 

如[图63](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57036365)所示，在单活冗余模式下，仅DF可以学习到多归属站点内的MAC地址，这会导致PE 3仅能从DF收到这些MAC地址的MAC/IP发布路由，若DF故障，PE 3需要较长时间重新学习这些MAC地址的表项指导报文转发。

EVPN多归属引入备份路径机制解决上述问题。备份路径机制是指冗余备份组中作为DF的PE通过MAC/IP发布路由向远端PE通告了CE侧MAC地址的可达性时，远端PE能够根据冗余备份组内PE发送的以太网自动发现路由（携带PE、ESI等信息）感知到冗余备份组中BDF与MAC地址的可达性，从而形成远端PE经过BDF到达与CE 1的备份路径。当DF故障时，冗余备份组直接将转发路径切换到通过BDF的备份路径上，而不需重新学习MAC表项。

#### 2. 多活冗余模式下的别名机制

图64 别名示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004181_x_Img_x_png_65_1844394_30005_0.png)

如[图64](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref57036405)所示，在多活冗余模式下，冗余备份组中可能仅有一台PE能学习到某些业务相关的MAC地址，这会导致远端PE仅能从这台PE收到这些MAC地址的MAC/IP发布路由，因此远端PE无法将访问这些MAC地址的流量负载分担到冗余备份组中的其它PE上。

为了解决这个问题，EVPN多归属引入了别名机制，即当冗余备份组中仅有一台PE通过MAC/IP发布路由向远端PE通告了CE侧MAC地址的可达性时，远端PE能够根据冗余备份组内PE发送的以太网自动发现路由（携带PE、ESI等信息）感知到冗余备份组中其它PE与MAC地址的可达性，并生成对应的MAC表项，从而形成负载分担。

## 4.5 多段PW

多段PW是指将两条或多条PW串连（concatenated）起来，形成一条端到端的PW。通过在同一个交叉连接下创建两条PW，可以实现将该交叉连接下的两条PW串连。PE从一条PW接收到报文后，剥离报文的隧道标识和PW标签，封装上与该PW串连的另一条PW的PW标签，并通过承载该PW的公网隧道转发该报文，从而实现报文在两条PW之间的转发。

如[图65](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref304554888)所示，通过在PE 2上将PW 1和PW 2串连、在PE 3上将PW 2和PW 3串连，可以建立从PE 1到PE 4的端到端PW，实现报文沿着PW 1、PW 2和PW 3形成的多段PW在PE 1和PE 4之间转发。

图65 多段PW示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004182_x_Img_x_png_66_1844394_30005_0.png)

 

多段PW分为：

·   域内多段PW：即在一个自治系统内部署多段PW。

在一个自治系统内部署多段PW，可以实现两个PE之间不存在端到端公网隧道的情况下，在这两个PE之间建立端到端PW。

如[图66](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref2587855)所示，PE 1和PE 4之间没有建立公网隧道，PE 1和PE 2、PE 2和PE 4之间已经建立了公网隧道。通过在PE 1与PE 2、PE 2与PE 4之间分别建立一条PW（PW 1和PW 2），在PE 2上将这两条PW串连，可以实现在PE 1和PE 4之间建立一条由两段PW组成的端到端域内多段PW。

通过建立域内多段PW可以充分利用已有的公网隧道，减少端到端公网隧道数量。

图66 域内多段PW

![img](https://resource.h3c.com/cn/202305/10/20230510_9004183_x_Img_x_png_67_1844394_30005_0.png)

 

·   域间多段PW：即跨越自治系统部署多段PW。关于域间多段PW的详细介绍，请参见“[4.6.2 ](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref531248259)[跨域-Option B](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref531248259)”。

## 4.6 EVPN VPWS跨域

实际组网应用中，不同Site间可能会通过使用不同AS号的多个服务提供商通信，或者跨越一个服务提供商的多个AS通信。这种跨越多个自治系统的应用方式被称为EVPN VPWS跨域。

EVPN VPWS跨域解决方案分为以下几种：

·   PE与ASBR间通过MP-IBGP（IBGP redistribution of EVPN routes between PE and ASBR）发布EVPN路由建立EVPN PW，ASBR互为CE，在ASBR上将AC与EVPN PW关联，也称为Inter-Provider Option A。

·   PE与ASBR间通过MP-IBGP发布EVPN路由建立EVPN PW，ASBR间通过MP-EBGP（EBGP redistribution of EVPN routes between ASBRs）发布EVPN路由建立EVPN PW，也称为Inter-Provider Option B；

·   PE间通过MP-EBGP（Multi-hop EBGP redistribution of EVPN routes between PE routers）发布EVPN路由建立EVPN PW，也称为Inter-Provider Option C。

### 4.6.1 跨域-Option A

如[图67](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref363645038)所示，这种方式下，两个AS的PE路由器直接相连，并且作为各自所在自治系统的边界路由器ASBR。两个ASBR均把对方当作自己的CE设备，并将与对端ASBR相连的接口与EVPN PW关联实现报文的跨域转发。

这种方式的优点是实现简单，两个作为ASBR的PE之间不需要为跨域进行特殊配置。缺点是可扩展性差：需要在两端的ASBR上为每个跨域站点配置AC并与EVPN PW绑定，配置复杂且管理难度大。

图67 ASBR互为CE连接组网图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004184_x_Img_x_png_68_1844394_30005_0.png)

 

### 4.6.2 跨域-Option B

如[图68](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref363736708)所示，这种方式下，在PE 1与ASBR 1、ASBR 2与PE 2之间分别通过MP-IBGP发布EVPN路由建立EVPN PW，ASBR 1与ASBR 2间通过MP-EBGP发布EVPN路由建立EVPN PW。通过多条EVPN PW的串联，即可实现报文的跨域传送。

这种方式的扩展性优于Inter-Provider Option A。缺点是ASBR仍然需要为每个跨域站点配置多段PW。

图68 多段PW跨域组网图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004185_x_Img_x_png_69_1844394_30005_0.png)

 

### 4.6.3 跨域-Option C

这种方式下，不同AS的PE之间建立多跳MP-EBGP会话，通过该会话直接在PE之间发布EVPN路由创建EVPN PW。此时，一端PE上需要具有到达远端PE的路由以及该路由对应的标签，以便在两个PE之间建立跨越AS的公网隧道。Inter-Provider Option C通过如下方式建立公网隧道：

·   利用LDP等标签分发协议在AS内建立公网隧道；

·   ASBR通过BGP发布带标签的IPv4单播路由，实现跨越AS域建立公网隧道。带标签的IPv4单播路由是指为IPv4单播路由分配MPLS标签，并同时发布IPv4单播路由和标签，以便将路由和标签关联。

图69 PE间通过Multi-hop MP-EBGP发布EVPN路由组网图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004187_x_Img_x_png_70_1844394_30005_0.png)

 

如[图69](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref364178223)所示，Inter-Provider Option C的难点是建立跨越AS域的公网隧道。以PE 2到PE 1为例，公网隧道建立过程为：

(1)   在AS 100内，通过LDP等标签分发协议建立从ASBR 1到PE 1的公网隧道。假设ASBR 1上该公网隧道的出标签为L1。

(2)   ASBR 1通过EBGP会话向ASBR 2发布带标签的IPv4单播路由，将PE 1地址对应的路由及ASBR 1为其分配的标签（假设为L2）发布给ASBR 2，路由的下一跳地址为ASBR 1。这样，就建立了从ASBR 2到ASBR 1的公网隧道，ASBR 1上公网隧道的入标签为L2。

(3)   ASBR 2通过IBGP会话向PE 2发布带标签的IPv4单播路由，将PE 1地址对应的路由及ASBR 2为其分配的标签（假设为L3）发布给PE 2，路由的下一跳地址为ASBR 2。这样，就建立了从PE 2直接到ASBR 2的公网隧道，ASBR 2上公网隧道的入标签为L3，出标签为L2。

(4)   MPLS报文不能直接从PE 2转发给ASBR 2，在AS 200内，还需要通过LDP等标签分发协议逐跳建立另一条从PE 2到ASBR 2的公网隧道。假设PE 2上该公网隧道的出标签为Lv。

公网隧道建立后，PE 1和PE 2间通过多跳MP-EBGP会话发布EVPN路由建立EVPN PW，在PE 1和PE 2上将EVPN PW与AC关联，即可实现报文的跨域转发。

为减少IBGP连接数，可以在每个AS中指定一个RR（Route Reflector，路由反射器），与同一AS的PE交换EVPN路由信息，由RR保存所有EVPN路由。两个AS的RR之间建立多跳MP-EBGP会话，通告EVPN路由。

Inter-Provider Option A和Inter-Provider Option B都需要ASBR参与EVPN路由的维护和发布。当每个AS都有大量的EVPN路由需要交换时，ASBR很可能成为阻碍网络进一步扩展的瓶颈。Inter-Provider Option C中PE之间直接交换EVPN路由，具有很好的可扩展性。

## 4.7 LDP PW或静态PW接入EVPN PW

在实际组网中，可能会存在传统的MPLS L2VPN网络（也称为VPWS网络）与EVPN VPWS网络共存的情况。LDP PW或静态PW接入EVPN PW功能，通过将MPLS L2VPN网络中的LDP PW或静态PW看作EVPN VPWS网络的AC（该PW称为UPW），实现报文在EVPN PW与UPW之间相互转发，从而实现MPLS L2VPN网络与EVPN VPWS网络的互通。

本功能不仅支持一条LDP PW或静态PW接入一条EVPN PW，还支持将两条LDP PW或静态PW多归属接入两条EVPN PW。如[3.5 图52](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref54889595)所示，在MPLS L2VPN网络中，PE 1与PE 2、PE 3分别建立主备LDP PW或静态PW，该PW称为UPW；在EVPN VPWS网络中，PE 4与PE 2、PE 3分别建立EVPN PW。UPW作为EVPN VPWS网络中的AC，PE 2或PE 3从UPW接收到报文后，会解除MPLS封装，查找与UPW关联的EVPN PW，为报文添加该EVPN PW对应的MPLS封装，并将其转发给PE 4；PE 2或PE 3从EVPN PW接收报文的处理方法与此类似。

图70 LDP PW或静态PW接入EVPN PW组网示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004188_x_Img_x_png_71_1844394_30005_0.png)

 

## 4.8 典型组网应用

### 4.8.1 多归属组网

为了避免PE单点故障造成报文转发中断，EVPN VPWS通常采用多归属组网方式。多归属站点的流量可以在多台PE之间形成主备备份，即同一时间仅有其中一台PE转发流量；也可以在多台PE之间进行负载分担，即所有PE均转发流量。

图71 多归属组网方式

![img](https://resource.h3c.com/cn/202305/10/20230510_9004189_x_Img_x_png_72_1844394_30005_0.png)

 

### 4.8.2 FRR组网

为了减少AC链路或PW链路故障对网络造成的影响，提升网络的可靠性和稳定性，可以在EVPN VPWS组网中部署FRR（Fast Reroute ，快速重路由）功能。FRR功能包含如下两种类型：

·   Bypass PW：即旁路PW。该功能可以减少AC链路故障导致的丢包。如PE 2侧AC链路故障时，PE 2通过Bypass PW临时将流量到转发到PE 3，再由PE 3转发到CE 2。

·   主备PW：即PE间建立的两条互为备份的EVPN PW，其中一条为主PW，一条为备份PW。如PE 1与PE 2间的主PW故障时，PE 1将流量切换到备PW上转发给PE 3，再由PE 3转发到CE 2。

图72 FRR组网示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004190_x_Img_x_png_73_1844394_30005_0.png)

 

 



# 5 EVPN L3VPN

## 5.1 EVPN L3VPN网络模型

EVPN的IP前缀路由可以用来发布VPN私网路由信息，以实现MPLS L3VPN组网，该网络称为EVPN L3VPN。与BGP/MPLS L3VPN网络相比，EVPN L3VPN组网中，在EVPN的基础上可以快速部署大二层网络，使得网络同时承载二层VPN和三层VPN业务。

图73 EVPN L3VPN典型组网图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004191_x_Img_x_png_74_1844394_30005_0.png)

 

如[图73](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref532289550)所示，EVPN L3VPN网络中主要包括如下几部分：

·   CE（Customer Edge，用户网络边缘）：直接与服务提供商网络相连的用户网络侧设备。

·   PE（Provider Edge，服务提供商网络边缘）：与CE相连的服务提供商网络侧设备。PE主要负责EVPN L3VPN业务的接入，完成报文从用户网络到公网隧道、从公网隧道到用户网络的映射与转发。

## 5.2 EVPN L3VPN控制平面工作机制

在EVPN L3VPN组网中，VPN路由信息的发布涉及CE和PE。P路由器只维护骨干网的路由，不需要了解任何VPN路由信息。PE路由器只维护与它直接相连的VPN的路由信息，不维护所有VPN路由。

VPN路由信息的发布过程包括三部分：本地CE到入口PE、入口PE到出口PE、出口PE到远端CE。完成这三部分后，本地CE与远端CE之间将建立可达路由。

### 5.2.1 本地CE到入口PE的路由信息交换

CE使用静态路由、RIP、OSPF、IS-IS、EBGP或IBGP，将本站点的VPN路由发布给PE。CE发布给PE的是标准的IPv4或IPv6路由。

### 5.2.2 入口PE到出口PE的路由信息交换

PE从CE学到VPN路由信息后，将其存放到相应的VPN实例的路由表中。PE为这些标准IPv4或IPv6路由增加RD和Export Target属性，并为这些路由分配MPLS私网标签，形成EVPN的IP前缀路由（包括RD、Export Target属性和MPLS私网标签）发布给出口PE。出口PE将IP前缀路由的Export Target属性与自己维护的VPN实例的Import Target属性进行匹配。如果出口PE上某个VPN实例的Import Target属性与路由的Export Target属性中存在相同的属性值，则接收该IP前缀路由并将其添加到VPN路由表中。

### 5.2.3 出口PE到远端CE的路由信息交换

与本地CE到入口PE的路由信息交换相同，远端CE可以通过多种方式从出口PE学习VPN路由，包括静态路由、RIP、OSPF、IS-IS、EBGP和IBGP。

## 5.3 EVPN L3VAN数据平面工作机制

在EVPN L3VPN组网中，PE转发VPN报文时为报文封装如下内容：

·   外层标记：又称为公网标记。VPN报文在骨干网上沿着公网隧道从一端PE传送到另一端PE。公网隧道可以是LSP隧道、MPLS TE隧道和GRE隧道。当公网隧道为LSP隧道或MPLS TE隧道时，公网标记为MPLS标签，称为公网标签；当公网隧道为GRE隧道时，公网标记为GRE封装。

·   内层标签：又称为私网标签，用来指示报文应被送到哪个Site。对端PE根据私网标签可以确定报文所属的VPN实例，通过查找该VPN实例的路由表，将报文正确地转发到相应的Site。PE之间在发布EVPN路由时，将为私网路由分配的私网标签通告给对端PE。

图74 EVPN L3VPN报文转发示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004192_x_Img_x_png_75_1844394_30005_0.png)

 

如[图74](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref130634555)所示，VPN报文的转发过程为：

(1)   Site 1发出一个目的地址为1.1.1.2的IP报文，由CE 1将报文发送至PE 1。

(2)   PE 1根据报文到达的接口及目的地址查找对应VPN实例的路由表，根据匹配的路由表项为报文添加私网标签，并查找到报文的下一跳为PE 2。

(3)   PE 1在公网路由表内查找到达PE 2的路由，根据查找结果为报文封装公网标签或进行GRE封装，并沿着公网隧道转发该报文。

(4)   MPLS网络内，P根据报文的公网标记转发报文，将报文转发到PE 2。如果公网标记为MPLS标签，则报文在到达PE 2的前一跳时剥离公网标签，仅保留私网标签；如果为GRE封装，则由PE 2剥离报文的GRE封装。

(5)   PE 2根据私网标签确定报文所属的VPN实例，通过查找该VPN实例的路由表，确定报文的出接口，剥离私网标签后将报文转发至CE 2。

(6)   CE 2根据正常的IP转发过程将报文转发给目的主机。

属于同一个VPN的两个Site连接到同一个PE时，PE不需要为VPN报文封装外层标记和内层标签，只需查找对应VPN实例的路由表，找到报文的出接口，将报文转发至相应的Site。

## 5.4 BGP/MPLS L3VPN与EVPN L3VPN对接

将现网L3VPN网络改造成EVPN L3VPN网络的过程中，会存在两种类型网络对接的情况。通过在PE 3上部署BGP VPNv4或BGP VPNv6路由通过BGP EVPN的IP前缀路由发布给邻居功能和EVPN路由通过BGP VPNv4或BGP VPNv6地址族发布给邻居功能，可实现在CE 1、CE 2间跨越MPLS L3VPN和EVPN L3VPN网络建立可达路由，并进行通信。

图75 MPLS L3VPN与EVPN L3VPN对接示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004193_x_Img_x_png_76_1844394_30005_0.png)

 

BGP/MPLS L3VPN与EVPN L3VPN对接分为两部分：

·   在PE 3上部署BGP VPNv4或BGP VPNv6路由通过BGP EVPN的IP前缀路由发布给邻居功能，从而实现将站点1的路由通过MPLS L3VPN网络发布到EVPN L3VPN网络，进而发布给站点2。具体过程为：

a.   PE 1从CE 1学到VPN路由信息后，将其保存到VPN实例的路由表中。同时，为这些IPv4或IPv6路由增加RD，形成VPNv4或VPNv6路由。

b.   PE 1通过MP-BGP把VPNv4或VPNv6路由发布给PE 3。路由中携带VPN Target属性及MPLS私网标签。

c.   PE 3收到VPNv4或VPNv6路由后，将路由中的Export target与本地VPN实例的Import target进行匹配。如果二者中存在相同的值，则将该路由添加到该VPN实例的路由表中。

d.   PE 3上将VPN实例路由表中的IPv4或IPv6路由转换为EVPN的IP Prefix路由，路由的下一跳地址为PE 3，且路由中携带VPN Target属性及该VPN的MPLS私网标签等信息。

e.   PE 3将该IP Prefix路由发送给PE 2。

f.   PE 2收到IP Prefix路由后，如果路由通过VPN Target属性匹配，则将路由添加到VPN实例的路由表中。

g.   PE 2将IPv4或IPv6路由发布给CE 2。

·   在PE 3上部署EVPN路由通过BGP VPNv4或BGP VPNv6地址族发布给邻居功能，从而实现将站点2的路由通过EVPN L3VPN网络发布到MPLS L3VPN网络，进而发布给站点1。具体过程为：

a.   PE 2从CE 2学到VPN路由信息后，将其保存到VPN实例的路由表中。

b.   PE 2将VPN实例路由表中的IPv4或IPv6路由转换为EVPN的IP Prefix路由，该路由的下一跳地址为PE 2，且路由中携带VPN Target属性及该VPN的MPLS私网标签等信息。

c.   PE 2将该路由发布给PE 3。

d.   PE 3收到IP Prefix路由后，如果路由通过VPN Target属性匹配，则将路由添加到VPN实例的路由表中。

e.   PE 3将VPN实例路由表中的IPv4或IPv6路由转换为VPNv4或VPNv6路由，并发布给PE 1。路由中携带VPN Target属性及MPLS私网标签。

f.   PE 1收到VPNv4或VPNv6路由后，如果路由通过VPN Target属性匹配，则将该路由加入到VPN实例的路由表。

g.   PE 1将IPv4或IPv6路由发布给CE 1。

## 5.5 BGP EVPN快速重路由

当EVPN网络中的链路或某台路由器发生故障时，需要通过故障链路或故障路由器传输才能到达目的地的报文将会丢失或产生路由环路，数据流量将会被中断。直到根据新的网络拓扑路由收敛后，被中断的流量才能恢复正常的传输。

通过BGP EVPN快速重路由功能，可以尽可能地缩短网络故障导致的流量中断时间。在BGP EVPN地址族下开启快速重路由功能后，BGP会为EVPN地址族的所有路由自动计算备份路由，即只要从不同BGP对等体学习到了到达同一目的网络的路由，且这些路由不等价，就会生成主备两条路由。当主路由不可达时，BGP会使用备份路由来指导报文的转发，从而大大缩短了流量中断时间。在使用备份路由转发报文的同时，BGP会重新进行路由优选，优选完毕后，使用新的最优路由来指导报文转发。

图76 EVPN L3VPN快速重路由示意图

![http://press.h3c.com/data/infoblade/Comware%20V7%E5%B9%B3%E5%8F%B0B75%E5%88%86%E6%94%AF%E4%B8%AD%E6%96%87/10-MPLS/08-MPLS%20L3VPN/MPLS%20L3VPN%E9%85%8D%E7%BD%AE.files/20230510_9004134_x_Img_x_png_22_1844394_30005_0.png](https://resource.h3c.com/cn/202305/10/20230510_9004194_x_Img_x_png_77_1844394_30005_0.png)

 

如[图76](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref56505429)所示，在入节点PE 1上配置FRR后，PE 1将计算出PE 3为PE 2的备份下一跳。当PE 1接收到PE 2和PE 3发布的到达CE 2的BGP EVPN IP前缀路由后，PE 1会记录这两条BGP EVPN IP前缀路由，并将PE 2发布的路由当作主路径，PE 3发布的路由当作备份路径。

在PE 1上配置BFD检测LSP或MPLS TE隧道功能，通过BFD检测PE 1到PE 2之间公网隧道的状态。当公网隧道正常工作时，CE 1和CE 2通过主路径CE 1—PE 1—PE 2—CE 2通信。当PE 1检测到该公网隧道出现故障时，PE 1将通过备份路径CE 1—PE 1—PE 3—CE 2转发CE 1访问CE 2的流量。在此过程中，PE 1负责主路径检测和流量切换。



# 6 EVPN VXLAN与EVPN VPLS over SRv6网络互通

## 6.1 网络模型

图77 EVPN VXLAN网络与EVPN VPLS over SRv6网络互通典型应用场景

![img](https://resource.h3c.com/cn/202305/10/20230510_9004195_x_Img_x_png_78_1844394_30005_0.png)

 

EVPN VXLAN网络与EVPN VPLS over SRv6网络互通功能的典型应用场景如[图77](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref126240838)所示。两个EVPN VXLAN网络通过EVPN VPLS over SRv6网络互联。GW 1、GW 2、GW 3和GW 4为EVPN VXLAN网络和EVPN VPLS over SRv6网络的边界设备，通过在GW上重生成EVPN路由，实现EVPN VXLAN网络和EVPN VPLS over SRv6网络之间互通。

## 6.2 网络互通原理

EVPN VXLAN网络和EVPN VPLS over SRv6网络之间实现互通，依赖于网络的边界设备上进行MAC/IP发布路由的重生成，具体过程为如下两种：

·   GW从EVPN VXLAN网络接收到MAC/IP发布路由后，GW重生成该路由，即为该路由分配并添加SRv6 SID、将路由的封装类型修改为SRv6封装、修改路由的RD和RT，之后将该路由发送到EVPN VPLS over SRv6网络。

·   GW从EVPN VPLS over SRv6网络接收到MAC/IP发布路由后，GW重生成该路由，即查找该路由对应的VXLAN ID并为路由添加VXLAN ID、将路由的封装类型修改为VXLAN封装、修改路由的RD和RT，之后将该路由发送到EVPN VXLAN网络。

完成路由重生成后，边界网关上会形成SRv6 SID、VXLAN ID与VSI实例的映射关系。在报文转发过程中，当GW收到VXLAN封装的报文时，对报文解封装，然后重新查表，再使用VXLAN ID对应的SRv6 SID对报文进行重新封装。同样的，当GW收到IPv6或SRv6封装的报文时，对报文解封装，然后重新查表，再使用SRv6 SID对应的VXLAN ID对报文进行重新封装。

## 6.3 控制平面工作机制

### 6.3.1 SRv6 PW及BUM广播表建立

如[图78](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref129591199)所示，EVPN VPLS over SRv6组网中PE 1和PE 2依靠RT-3（Inclusive Multicast Ethernet Tag Route）路由自动发现PE站点、建立SRv6 PW和BUM广播表。

图78 RT-3路由消息格式

![img](https://resource.h3c.com/cn/202305/10/20230510_9004196_x_Img_x_png_79_1844394_30005_0.png)

 

如[图79](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref129591394)所示，SRv6 PW及BUM广播表建立的具体过程为：

(1)   PE 1通过RT-3向PE 2通告自身的IP地址，以及PE 1为VSI实例A分配的用于转发BUM流量的End.DT2M SID。

(2)   PE 2收到PE 1发送的RT-3路由后，若路由中VPN Target属性与PE 2本地配置的Import Target属性匹配，则PE 2建立一条到达PE 1的IP地址的单向SRv6隧道，其出SID为PE 1携带的End.DT2M SID；若路由中VPN Target属性与PE 2本地配置的Import Target属性不匹配，则不建立SRv6 PW。

(3)   PE 2通过RT-3向PE 1通告自身的IP地址，以及PE 2为VSI实例A分配的用于转发BUM流量的End.DT2M SID。

(4)   PE 1收到PE 2发送的RT-3路由后，若路由中VPN Target属性与PE 1本地配置的Import Target属性匹配，则PE 1建立一条到达PE 1的IP地址的单向SRv6隧道，其出SID为PE 2携带的End.DT2M SID；若路由中VPN Target属性与PE 1本地配置的Import Target属性不匹配，则不建立SRv6 PW。

(5)   两条方向相反的SRv6隧道，构成一条SRv6 PW。

(6)   对于每个VSI而言，所有这些建立并关联的SRv6 PW就形成了BUM广播表。

图79 SRv6 PW及BUM广播表建立过程示意图

![img](https://resource.h3c.com/cn/202305/10/20230510_9004198_x_Img_x_png_80_1844394_30005_0.png)

 

### 6.3.2 VXLAN隧道及BUM广播表建立

如[图80](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref129765172)所示，EVPN VXLAN组网中PE 2和PE 3依靠RT-3（Inclusive Multicast Ethernet Tag Route）路由自动发现PE站点、建立VXLAN隧道和BUM广播表。

图80 RT-3路由消息格式

![img](https://resource.h3c.com/cn/202305/10/20230510_9004199_x_Img_x_png_81_1844394_30005_0.png)

 

如[图79](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref129591394)所示，VXLAN隧道及BUM广播表建立的具体过程为：

(1)   PE 2通过RT-3向PE 3通告自己所属的VXLAN ID及自身的IP地址。

(2)   PE 3收到PE 2发送的RT-3路由后，若路由中VPN Target属性与PE 3本地配置的Import Target属性匹配，则获取PE 2的VXLAN信息以及VXLAN和下一跳的关系；若路由中VPN Target属性与PE 3本地配置的Import Target属性不匹配，则丢弃该报文。

(3)   PE 3查看自己的VXLAN信息，若存在与PE 2相同的VXLAN，则与RT-3路由中携带的下一跳自动建立VXLAN隧道，并将此VXLAN隧道与VXLAN关联。

(4)   PE 3通过RT-3向PE 2通告自己所属的VXLAN ID及自身的IP地址。

(5)   PE 2收到PE 3发送的RT-3路由后，若路由中VPN Target属性与PE 2本地配置的Import Target属性匹配，则获取PE 3的VXLAN信息以及VXLAN和下一跳的关系；若路由中VPN Target属性与PE 2本地配置的Import Target属性不匹配，则丢弃该报文。

(6)   PE 2查看自己的VXLAN信息，若存在与PE 3相同的VXLAN，则与RT-3路由中携带的下一跳自动建立VXLAN隧道，并将此VXLAN隧道与VXLAN关联。

(7)   对于每个VXLAN而言，所有这些建立并关联的VXLAN隧道就形成BUM广播表。

### 6.3.3 MAC地址学习

如[图81](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref131167105)所示，EVPN VXLAN与EVPN VPLS over SRv6互通组网中，PE之间通过MAC/IP发布路由（即RT-2，二类路由）通告和学习站点的MAC地址。

图81 RT-2路由格式

![img](https://resource.h3c.com/cn/202305/10/20230510_9004200_x_Img_x_png_82_1844394_30005_0.png)

 

如[图82](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref129765206)所示，MAC地址通告和学习过程为：

(1)   PE 1接收到CE 1发送的报文后，通过以太网报文的源MAC地址学习获得CE 1的MAC地址。即将CE 1的MAC地址添加到接收报文的AC口关联的VSI实例A的MAC地址表中，其出接口为连接CE 1的AC口。

(2)   PE 1通过RT-2路由将CE 1的MAC地址以及PE 1为VSI实例A分配的End.DT2U SID发布给PE 2。

(3)   PE 2接收到RT-2路由后，如果路由中的VPN Target属性与PE 2本地配置的Import target属性匹配，则PE 2接收该路由，并将CE 1的MAC地址加入到本地VSI实例A的MAC地址表中，其出SID为PE 1通告的End.DT2U SID；如果路由中的VPN Target属性与PE 2本地配置的Import target属性不匹配，则PE 2丢弃该路由。

(4)   PE 2将从PE 1接收到RT-2路由的下一跳地址修改为自身的地址、将报文封装类型修改为VXLAN方式，并添加VSI实例A关联的VXLAN ID，然后通过RT-2路由发送给PE 3。此外，PE 2上还会建立End.DT2U SID、VXLAN ID与VSI实例的映射关系。

(5)   PE 3接收到RT-2路由后，如果路由中的VPN Target属性与PE 1 本地配置的Import target 属性匹配，则将MAC地址加入到本地VSI实例A的MAC地址表中，其出接口为接收该路由的VXLAN隧道。

完成RT-2路由发布后，PE 1、PE 2和PE 3上均有CE 1的MAC，PE 2上还具有End.DT2U SID、VXLAN ID与VSI实例的映射关系。用户二层数据报文可以通过查找MAC地址表在EVPN VXLAN网络和EVPN VPLS over SRv6网络之间转发。

图82 MAC地址通告和学习过程

![img](https://resource.h3c.com/cn/202305/10/20230510_9004201_x_Img_x_png_83_1844394_30005_0.png)

 

## 6.4 数据平面工作机制

### 6.4.1 转发已知单播流量

图83 转发已知单播流量

![img](https://resource.h3c.com/cn/202305/10/20230510_9004202_x_Img_x_png_84_1844394_30005_0.png)

 

如[图83](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref129681174)所示，PE完成MAC地址表项的学习后，以CE 1访问CE 2为例，已知单播报文从EVPN VPLS over SRv6网络转发到EVPN VXLAN网络的转发过程为：

(1)   PE 1从AC接收到CE 1发送的报文后，在AC关联的VSI实例内查找MAC地址表，找到对应的出接口SRv6 PW，并获取该VSI实例的End.DT2U SID。

(2)   PE 1根据SRv6 BE或SRv6 TE方式为报文封装IPv6报文头，然后查找IPv6路由表将报文发送到PE 2。

(3)   PE 2接收到报文后，对报文解封装，去掉IPv6报文头，根据End.DT2U SID找到关联的VSI实例，在VSI实例内查找MAC地址表，找到对应的VXLAN隧道，然后为报文进行VXLAN封装，通过VXLAN隧道将报文发送给PE 3。

(4)   PE 3接收到报文后，对报文解封装，根据VXLAN报头中的VXLAN ID找到关联的VSI，并在该VSI实例内查找MAC地址表，根据查表结果将报文转发给CE 2。

以CE 2访问CE 1为例，已知单播报文从EVPN VXLAN网络转发到EVPN VPLS over SRv6网络的转发过程为：

(1)   PE 3从AC接收到CE 2发送的报文后，在AC关联的VSI实例内查找MAC地址表，找到对应的出接口VXLAN隧道，并获取VSI实例关联的VXLAN ID。

(2)   PE 3为报文进行VXLAN封装，并通过VXLAN隧道将报文发送给PE 2。

(3)   PE 2接收到报文后，对报文进行解封装，根据VXLAN报头中的VXLAN ID找到关联的VSI，并在该VSI实例内查找MAC地址表，获取对应的End.DT2U SID。

(4)   PE 2根据SRv6 BE或SRv6 TE方式为报文封装IPv6报文头，然后查找IPv6路由表将报文发送到 PE 1。

(5)   PE 1接收到报文后，对报文解封装，去掉IPv6报文头，根据End.DT2U SID找到关联的VSI实例，在该VSI实例内查找MAC地址表，根据查表结果将报文转发给CE 1。

### 6.4.2 转发BUM流量

除了单播流量转发，EVPN VPLS over SRv6与EVPN VXLAN网络互通组网中还会转发广播、未知组播与未知单播流量，即BUM流量。

图84 转发BUM流量

![img](https://resource.h3c.com/cn/202305/10/20230510_9004203_x_Img_x_png_85_1844394_30005_0.png)

 

如[图84](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/EVPN_White_Paper-10897/?CHID=853362#_Ref129681222)所示，以CE 1侧发送未知单播报文为例，报文转发过程为：

(1)   PE 1从AC接收到CE 1发送的BUM报文后，在AC关联的VSI的MAC地址表中未找到匹配的MAC地址表项，则在VSI中查找所有远端PE分配的所有End.DT2M SID，此例中只有PE 2。

(2)   PE 1根据SRv6 BE或SRv6 TE方式为报文封装IPv6报文头，然后查找IPv6路由表将报文发送到PE 2。如果存在多个远端PE，则会将报文复制多份并为报文封装不同的IPv6报文头，然后查表发给多个远端PE。

(3)   PE 2接收到报文后，对报文解封装，去掉IPv6报文头，根据End.DT2M SID找到关联的VSI实例，在VSI实例内查找绑定的VXLAN隧道，然后为报文进行VXLAN封装，通过VXLAN隧道发送给PE 3。如果存在多个远端PE，则会对报文进行复制并进行VXLAN封装，然后通过多个VXLAN隧道将报文转发到远端PE。

(4)   PE 3接收到报文后，对报文解封装，根据VXLAN报头中的VXLAN ID找到关联的VSI，在该VSI实例内进行广播，即通过VSI实例关联的所有AC将报文转发到CE。

以CE 2侧发送未知单播报文为例，报文转发过程为：

(1)   PE 3从AC收到CE 2发送的BUM报文后，在AC关联的VSI的MAC地址表中未找到匹配的MAC地址表项，则在该VXLAN内除接收接口外的所有本地AC口和VXLAN隧道转发该报文。

(2)   PE 3为报文进行VXLAN封装，并通过VXLAN隧道将报文发送给远端PE 2。如果存在多个远端PE，则会对报文进行复制并进行VXLAN封装，然后通过多个VXLAN隧道将报文转发到远端PE。

(3)   PE 2接收到报文后，对报文进行解封装，根据VXLAN报头中的VXLAN ID找到关联的VSI，并在该VSI实例内查找所有远端PE分配的所有End.DT2M SID，此例中只有PE 1。

(4)   PE 2根据SRv6 BE或SRv6 TE方式为报文封装IPv6报文头，然后查找IPv6路由表将报文发送到PE 1。如果存在多个远端PE，则会将报文复制多份并为报文封装不同的IPv6报文头，然后查表发给多个远端PE。

(5)   PE 1接收到报文后，对报文解封装，去掉IPv6报文头，根据End.DT2M SID找到关联的VSI实例，在该VSI实例内进行广播，即通过VSI实例关联的所有AC将报文转发到CE。



# 7 参考文献

·   RFC 7432: BGP MPLS-Based Ethernet VPN

·   draft-ietf-bess-evpn-overlay: A Network Virtualization Overlay Solution using EVPN

·   draft-ietf-bess-evpn-prefix-advertisement: BGP MPLS-Based Ethernet VPN

·   draft-ietf-bess-evpn-igmp-mld-proxy: IGMP and MLD Proxy for EVPN

·   draft-boutros-l2vpn-vxlan-evpn: VXLAN DCI Using EVPN

·   draft-ietf-bess-srv6-services: SRv6 BGP based Overlay services