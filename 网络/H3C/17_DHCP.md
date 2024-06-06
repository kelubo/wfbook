# 概述

## 1.1 产生背景

连接到Internet的计算机需要在发送或接收数据报前知道其IP地址和其他信息，如网关地址、使用的子网掩码和域名服务器的地址。计算机可以通过BOOTP协议获取这些信息。

BOOTP协议（Bootstrap Protocol）是一种较早出现的远程启动的协议，通过与远程服务器通信以获取通信所需的必要信息，主要用于无磁盘的客户端从服务器得到自己的IP地址、服务器的IP地址、启动映像文件名、网关IP地址等等。

BOOTP设计用于相对静态的环境，每台主机都有一个永久的网络连接。管理人员创建一个BOOTP配置文件，该文件定义了每台主机的一组BOOTP参数。由于配置通常保持不变，该文件不会经常改变。一般情况下，配置将保持数星期不变。

随着网络规模的不断扩大、网络复杂度的不断提高，网络配置也变得越来越复杂，在计算机经常移动（如便携机或无线网络）和计算机的数量超过可分配的IP地址等情况下，原有针对静态主机配置的BOOTP协议已经越来越不能满足实际需求。为方便用户快速地接入和退出网络、提高IP地址资源的利用率，需要在BOOTP基础上制定一种自动机制来进行IP地址的分配。为此，IETF设计了一个新的协议，即DHCP（Dynamic Host Configuration Protocol，动态主机配置协议）。

## 1.2 技术优势

DHCP是BOOTP的增强版本。它采用客户端/服务器的通信模式。所有的IP网络配置参数都由DHCP服务器集中管理，并负责处理客户端的DHCP请求；而客户端则会使用服务器分配的IP网络参数进行通信。

随着网络规模的扩大化和网络环境的复杂化，DHCP服务被应用到越来越多的网络环境中，H3C公司的DHCP特性解决方案具有完整的产品系列，可以为客户提供完善、灵活、便捷的组网配置方案，其主要优势有以下几点：

·   功能完备，可以为客户提供DHCP客户端、中继到服务器的全面功能实现；

·   具有出色的业务支持能力及灵活的组网方案；

·   良好的易用性和可配置性；

·   可以与业界其它主流厂商设备及Windows、Linux服务器实现良好的互通；

·   方便管理、部署经济、设备开销低。

# 2 DHCP技术实现

## 2.1 概念介绍

·   DHCP服务器：DHCP服务的提供者，通过DHCP报文与DHCP客户端交互，为各种类型的客户端分配合适的IP地址，并可以根据需要为客户端分配其它网络参数。

·   DHCP客户端：是整个DHCP过程的触发者和驱动者，通过DHCP报文和DHCP服务器交互，得到IP地址和其他网络参数。

·   DHCP中继：DHCP报文的中继转发者。它在处于不同网段间的DHCP客户端和服务器之间承担中继服务，解决了DHCP客户端和DHCP服务器必须位于同一网段的问题。

·   DHCP Snooping：DHCP服务的二层监听功能。利用该功能可以从接收到的DHCP-ACK和DHCP-REQUEST报文中提取并记录IP地址和MAC地址信息。

## 2.2 DHCP报文格式

DHCP报文格式如[图1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/DHCP_Tech-6W100/?CHID=949107#_Ref168383893)所示。

图1 DHCP报文格式

![img](https://resource.h3c.com/cn/201911/20/20191120_4598462_x_Img_x_png_0_1244589_30005_0.png)

 

DHCP报文的各个字段的具体说明如下：

·   op：报文的操作类型，1为请求报文，2为响应报文。具体的报文类型在option字段中标识。

·   htype：硬件地址类型。

·   hlen：硬件地址长度。系统目前只支持以太网，硬件地址长度固定为6。

·   hops：DHCP报文经过的DHCP中继的数目。DHCP请求报文每经过一个DHCP中继，该字段就会增加1。

·   xid：由客户端软件产生的随机数，用于匹配请求和应答报文。

·   secs：客户端进入IP地址申请进程的时间或者更新IP地址进程的时间；由客户端软件根据情况设定。目前没有使用，固定为0。

·   flags：标志字段。第一个比特为广播响应标识位，用来标识DHCP服务器响应报文是采用单播还是广播方式发送，0表示采用单播方式，1表示采用广播方式。其余比特保留不用。

·   ciaddr：DHCP客户端的IP地址。

·   yiaddr：DHCP服务器分配给客户端的IP地址。

·   siaddr：DHCP客户端获取IP地址等信息的服务器IP地址。

·   giaddr：DHCP客户端发出请求报文后经过的第一个DHCP中继的IP地址。

·   chaddr：DHCP客户端的硬件地址。

·   sname：DHCP客户端获取IP地址等信息的服务器名称。

·   file：DHCP服务器为DHCP客户端指定的启动配置文件名称及路径信息。

·   options：可选变长选项字段，包含报文的类型、有效租期、DNS服务器的IP地址、WINS服务器的IP地址等配置信息。

## 2.3 DHCP服务器运行机制

由于在IP地址动态获取过程中采用广播方式发送报文，因此要求DHCP客户端和服务器位于同一个网段内。如果DHCP客户端和DHCP服务器位于不同的网段，则需要通过DHCP中继来转发DHCP报文。

通过DHCP中继完成动态配置的过程中，客户端与服务器的处理方式与不通过DHCP中继时的处理方式基本相同。下面仅以DHCP客户端与DHCP服务器在同一网段的情况为例，说明DHCP协议的工作过程。

### 2.3.1 地址分配策略

针对客户端的不同需求，DHCP提供三种IP地址分配策略：

·   手工分配地址：由管理员为少数特定客户端（如WWW服务器等）静态绑定固定的IP地址，通过DHCP将配置的固定IP地址发给客户端；

·   自动分配地址：DHCP为客户端分配租期为无限长的IP地址；

·   动态分配地址：DHCP为客户端分配有有效期限的IP地址，到达使用期限后，客户端需要重新申请地址。

管理员可以选择DHCP采用哪种策略响应每个网络或每台主机。

### 2.3.2 动态获取IP地址

为了动态获取并使用一个合法的IP地址，需要经历以下几个阶段：

(1)   发现阶段：即DHCP客户端寻找DHCP服务器的阶段。

(2)   提供阶段：即DHCP服务器提供IP地址的阶段。

(3)   选择阶段：即DHCP客户端选择某台DHCP服务器提供的IP地址的阶段。

(4)   确认阶段：即DHCP服务器确认所提供的IP地址的阶段。

图2 IP地址动态获取过程

![img](https://resource.h3c.com/cn/201911/20/20191120_4598463_x_Img_x_png_1_1244589_30005_0.png)

 

IP地址的动态获取过程如[图2](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/DHCP_Tech-6W100/?CHID=949107#_Ref168387755)所示，下面将详细介绍每个阶段的工作过程。

#### 1. 发现阶段

在发现阶段，DHCP客户端通过发送DHCP-DISCOVER报文来寻找DHCP服务器。

由于DHCP服务器的IP地址对于客户端来说是未知的，所以DHCP客户端以广播方式发送DHCP-DISCOVER报文。所有收到DHCP-DISCOVER报文的DHCP服务器都会发送回应报文，DHCP客户端据此可以知道网络中存在的DHCP服务器的位置。

#### 2. 提供阶段

网络中接收到DHCP-DISCOVER报文的DHCP服务器，会选择一个合适的IP地址，连同IP地址租约期限和其他配置信息（如网关地址，域名服务器地址等）一同通过DHCP-OFFER报文发送给DHCP客户端。

DHCP服务器通过地址池保存可供分配的IP地址和其他配置信息。当DHCP服务器接收到DHCP请求报文后，将从IP地址池中选取空闲的IP地址及其他的参数，发送给DHCP客户端。

DHCP服务器为客户端分配IP地址的优先次序如下：

(1)   与客户端MAC地址或客户端ID静态绑定的IP地址；

(2)   DHCP服务器记录的曾经分配给客户端的IP地址；

(3)   客户端发送的DHCP-DISCOVER报文中Option 50字段指定的IP地址；

(4)   在DHCP地址池中，顺序查找可供分配的IP地址，最先找到的IP地址；

(5)   如果未找到可用的IP地址，则依次查询租约过期、曾经发生过冲突的IP地址，如果找到则进行分配，否则将不予处理。

DHCP服务器为客户端分配IP地址时，服务器首先需要确认所分配的IP没有被网络上的其他设备所使用。DHCP服务器通过发送ICMP Echo Request（ping）报文对分配的IP进行探测。如果在规定的时间内没有收到应答，那么服务器就会再次发送ping报文。到达指定的次数后，如果仍没有收到应答，则所分配的IP地址可用。否则将探测的IP地址记录为冲突地址，并重新选择IP地址进行分配。

#### 3. 选择阶段

如果有多台DHCP服务器向DHCP客户端回应DHCP-OFFER报文，则DHCP客户端只接受第一个收到的DHCP-OFFER报文。然后以广播方式发送DHCP-REQUEST请求报文，该报文中包含Option 54（服务器标识选项），即它选择的DHCP服务器的IP地址信息。

以广播方式发送DHCP-REQUEST请求报文，是为了通知所有的DHCP服务器，它将选择Option 54中标识的DHCP服务器提供的IP地址，其他DHCP服务器可以重新使用曾提供的IP地址。

#### 4. 确认阶段

收到DHCP客户端发送的DHCP-REQUEST请求报文后，DHCP服务器根据DHCP-REQUEST报文中携带的MAC地址来查找有没有相应的租约记录。如果有，则发送DHCP-ACK报文作为应答，通知DHCP客户端可以使用分配的IP地址。

DHCP客户端收到DHCP服务器返回的DHCP-ACK确认报文后，会以广播的方式发送免费ARP（Address Resolution Protocol，地址解析协议）报文，探测是否有主机使用服务器分配的IP地址，如果在规定的时间内没有收到回应，客户端才使用此地址。否则，客户端会发送DHCP-DECLINE报文给DHCP服务器，通知DHCP服务器该地址不可用，并重新申请IP地址。

如果DHCP服务器收到DHCP-REQUEST报文后，没有找到相应的租约记录，或者由于某些原因无法正常分配IP地址，则发送DHCP-NAK报文作为应答，通知DHCP客户端无法分配合适IP地址。DHCP客户端需要重新发送DHCP-DISCOVER报文来请求新的IP地址。

### 2.3.3 重用曾经分配的IP地址

DHCP客户端每次重新登录网络时，不需要再发送DHCP-DISCOVER报文，而是直接广播发送包含前一次分配的IP地址的DHCP-REQUEST请求报文，即报文中的Option 50（请求的IP地址选项）字段填入曾经使用过的IP地址。DHCP服务器收到这一报文后，判断DHCP客户端是否可以使用请求的地址：

·   如果可以使用请求的地址，DHCP服务器将回复DHCP-ACK确认报文。收到DHCP-ACK报文后，DHCP客户端可以继续使用该地址进行通信。如[图3](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/DHCP_Tech-6W100/?CHID=949107#_Ref15395915)所示。

图3 DHCP客户端可以重新使用曾分配的IP地址

![img](https://resource.h3c.com/cn/201911/20/20191120_4598468_x_Img_x_png_2_1244589_30005_0.png)

 

·   如果请求的IP地址已无法再分配给DHCP客户端（例如，此IP地址已分配给其它DHCP客户端使用），则DHCP服务器将回复DHCP-NAK否认报文。DHCP客户端收到此报文后，必须重新发送DHCP-DISCOVER报文来请求新的IP地址。如[图4](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/DHCP_Tech-6W100/?CHID=949107#_Ref168388872)所示。

图4 DHCP客户端不能重新使用曾分配的IP地址

![img](https://resource.h3c.com/cn/201911/20/20191120_4598469_x_Img_x_png_3_1244589_30005_0.png)

 

### 2.3.4 更新租约

DHCP服务器分配给DHCP客户端的IP地址一般都有一个租借期限，期满后DHCP服务器便会收回分配的IP地址。如果DHCP客户端要延长其IP租约，则必须更新其IP租约。

(1)   IP租约期限达到一半（T1）时，DHCP客户端会自动以单播的方式，向DHCP服务器发送DHCP-REQUEST报文，请求更新IP地址租约。如果收到DHCP-ACK报文，则租约更新成功；如果收到DHCP-NAK报文，则重新发起申请过程。

(2)   到达租约期限的87.5%（T2）时，如果仍未收到DHCP服务器的应答，DHCP客户端会自动向DHCP服务器发送更新其IP租约的广播报文。如果收到DHCP-ACK报文，则租约更新成功；如果收到DHCP-NAK报文，则重新发起申请过程。

如[图5](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/DHCP_Tech-6W100/?CHID=949107#_Ref15396682)所示，租约达到87.5%，广播发送DHCP-REQUEST报文后，收到DHCP服务器回应的DHCP-ACK报文，租约更新成功。

图5 更新IP地址租约

![img](https://resource.h3c.com/cn/201911/20/20191120_4598470_x_Img_x_png_4_1244589_30005_0.png)

 

### 2.3.5 DHCP客户端主动释放IP地址

DHCP客户端不再使用分配的IP地址时，会主动向DHCP服务器发送DHCP-RELEASE报文，通知DHCP服务器释放IP地址的租约。DHCP服务器会保留这个DHCP客户端的配置信息，以便该客户端重新申请地址时，重用这些参数。

### 2.3.6 获取除IP地址外的配置信息

DHCP客户端获取IP地址后，如果需要从DHCP服务器获取更为详细的配置信息，则发送DHCP-INFORM报文向DHCP服务器进行请求。DHCP客户端通过Option 55（请求参数列表选项），指明需要从服务器获取哪些网络配置参数。

DHCP服务器收到该报文后，将通过DHCP-ACK报文为客户端分配它所需要的网络参数。

### 2.3.7 转控分离组网地址池支持动态分配子网段

本功能适用于转发控制分离组网，此类组网主要包括CP（Control Plane，控制平面）和UP（User Plane，用户平面）两类设备：

·   CP设备：负责所有终端用户的认证、授权等工作。

·   UP设备：负责将连接的终端用户按照不同业务划分到不同的VXLAN组网、转发终端用户报文等工作。

CP设备和UP设备之间通过建立OpenFlow和VXLAN两条传输通道：

·   OpenFlow作为CP设备和UP设备之间的表项下发通道。

·   VXLAN隧道作为CP设备和UP设备之间的协议报文通道。

图6 IP地址池支持动态分配子网段功能原理图

![img](https://resource.h3c.com/cn/201911/20/20191120_4598471_x_Img_x_png_5_1244589_30005_0.png)

 

如[图6](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/DHCP_Tech-6W100/?CHID=949107#_Ref16673668)所示，CP设备通过VXLAN隧道连接多台UP设备，CP设备上开启了DHCP服务器功能，CP设备根据配置的子网段掩码长度将IP地址池中的地址空间分成多个子网段。

动态地址池组网的工作过程为：

(1)   CP设备收到DHCP客户端发送的DHCP-DISCOVER报文时，根据动态地址池下配置的分配模式（up-id、interface或up-backup-group），查看是否有子网段可以为这个DHCP客户端分配租约。如果存在，直接使用该子网段为DHCP客户端分配租约；如果不存在，则进入下一步骤。

(2)   CP设备按照用户上线时携带的up-id、interface或up-backup-group信息及动态地址池下配置的分配模式来给UP设备动态分配一个子网段，并从该子网段中选择地址分配给上线用户。同时，CP设备会将该子网段对应的网段路由下发给UP设备，当路由收敛结束后，外部网络可以访问到此UP设备下联的用户。

(3)   当某个子网段的用户全部下线后，CP设备会回收该子网段。

本功能实现了DHCP服务器对IP地址空间的灵活分配和回收，使地址空间分配更合理，并大幅节约了人力维护成本。

### 2.3.8 ODAP组网按需分配地址池

ODAP（On-Demand Address Pool，按需地址池）根据实际需求动态分配和回收子网段，可以充分利用地址资源。ODAP适用于大量用户上线的组网环境。ODAP组网主要包括服务器子网管理设备（ODAP服务器）和本地子网管理设备（ODAP客户端）。

图7 ODAP按需地址池分配子网段功能原理图

![img](https://resource.h3c.com/cn/201911/20/20191120_4598472_x_Img_x_png_6_1244589_30005_0.png)

 

如[图7](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/DHCP_Tech-6W100/?CHID=949107#_Ref16682986)所示，一台ODAP服务器可以连接多台ODAP客户端，ODAP服务器和ODAP客户端均作为DHCP服务器。ODAP服务器上的IP地址池中创建了含有大量地址的网段地址空间，ODAP服务器根据配置的子网掩码长度将这些地址空间分成多个子网段。ODAP客户端上的IP地址池不创建网段地址空间，ODAP客户端需要先从ODAP服务器申请子网段，再从该子网段中选择地址分配给DHCP客户端。

ODAP组网的工作过程为：

(1)   ODAP客户端收到DHCP客户端发送的DHCP-DISCOVER报文时，根据ODAP客户端地址池下配置的分配模式（up-id、interface或up-backup-group），查看是否有子网段可以给这个DHCP客户端分配。如果存在，则直接使用该子网段给DHCP客户端分配租约；如果不存在，则进入下一步骤。

(2)   ODAP客户端向ODAP服务器申请子网段。子网段申请过程与IP地址申请过程基本相同，不同之处在于子网段申请过程中，ODAP客户端和ODAP服务器发送的报文中均携带Option 220和Option 221选项。其中，ODAP客户端发送的请求报文中的Option 220携带请求子网段信息，Option 221携带ODAP客户端地址池所在VPN信息；ODAP服务器发送的应答报文中的Option 220携带分配的子网段信息，Option 221携带ODAP服务器地址池所在VPN信息。

(3)   ODAP客户端使用申请到的子网段为DHCP客户端分配租约。

相比于动态分配子网段功能，ODAP功能降低了ODAP服务器工作负担，使ODAP组网适用于更大规模的动态网段分配组网环境。

当ODAP客户端发生故障或者与ODAP服务器之间连接中断时，ODAP服务器感知不到此类事件，导致ODAP服务器无法回收该ODAP客户端的子网段。此时，可以强制ODAP服务器更新子网，该过程为：

(1)   触发一次ODAP服务器的子网强制更新操作后，ODAP服务器会主动向所有ODAP客户端发送DHCP-FORCERENEW报文请求申请到的子网段信息。

(2)   ODAP客户端收到该报文后，通过DHCP-REQUEST报文将自己申请到的子网段信息发送给ODAP服务器。

(3)   ODAP服务器统计DHCP-REQUEST报文中记录的所有子网段信息，未统计到的子网段都会被ODAP服务器直接回收。

本功能保证了子网段资源不会被浪费。

### 2.3.9 IP地址池组

在AAA组网中，终端用户经过AAA认证后，DHCP设备根据AAA服务器的授权信息从本地配置的IP地址池中选择IP地址。如果只配置AAA关联某个独立的IP地址池，则无法满足如下需求：

·   为不同位置的接入用户选择不同的DHCP服务器。

·   AAA设备既需要作为DHCP服务器也需要作为DHCP中继，作为DHCP服务器可以直接为客户端分配地址；作为DHCP中继可以将用户的请求报文转发给DHCP服务器，并将DHCP服务器的应答报文转发给终端用户。

·   普通组网和转控分离组网混合环境，AAA需要同时添加普通地址池和可动态分配子网段的地址池。

AAA关联IP地址池组功能可以满足上述需求。使用IP地址池组功能，管理员可以将多个IP地址池添加到同一个IP地址池组中。IP地址池包括普通地址池、本地BAS IP地址池和远端BAS IP地址池。配置AAA关联IP地址池组后，AAA按照匹配顺序选择IP地址池组中的地址池为终端用户分配IP地址。

DHCP客户端通过IP地址池组获取地址的工作过程为：

(1)   设备收到DHCP客户端发送的DHCP-DISCOVER报文时，如果设备发现该用户已经成功上线，则还会使用同样的地址分配给用户；如果用户未上线，但在某个地址池下存在对应的静态绑定关系，则使用静态绑定关系对应的地址分配给用户，如果不存在以上情况，则继续执行如下步骤。

(2)   根据该用户上线时的UP设备地址或远端接口信息，查看是否存在UP地址或远端接口绑定的可用的普通地址池和本地BAS IP地址池。如果存在，则选择该地址池为用户分配地址；如果不存在，则继续执行如下步骤。

(3)   设备查看是否存在未绑定UP地址和远端接口的可用普通地址池和本地BAS IP地址池。如果存在，则按照Buildrun显示的顺序选取地址池为用户分配租约；如果不存在，则继续执行如下步骤。

(4)   根据该用户上线时的UP地址或远端接口信息，查看是否存在UP地址或远端接口绑定的可用远端BAS IP地址池。如果存在，则将报文转发给该地址池对应的DHCP服务器；如果不存在，则继续执行如下步骤。

(5)   设备查看是否存在未绑定UP地址和远端接口的可用远端BAS IP地址池。如果存在，则按照Buildrun显示的顺序选择远端BAS IP地址池，并将报文转发给地址池对应的DHCP服务器；如果不存在，则用户无法获取到IP地址。

当用户匹配到IP地址池组中的最后一个地址池，仍无法为用户分配地址，则地址分配过程失败。

### 2.3.10 应用限制

DHCP具有如下缺点：

·   当网络上存在多个DHCP服务器时，一个DHCP服务器不能查出已被其它服务器分配出去的IP地址；

·   DHCP服务器不能跨网段与客户端通信，除非通过DHCP中继转发报文。

## 2.4 DHCP中继运行机制

原始的DHCP协议要求客户端和服务器只能在同一个子网内，不可以跨网段工作。因此，为进行动态主机配置需要在所有网段上都设置一个DHCP服务器，这显然是不经济的。

DHCP中继的引入解决了这一问题，它在处于不同网段间的DHCP客户端和服务器之间承担中继服务，将DHCP协议报文跨网段中继到目的DHCP服务器，于是不同网络上的DHCP客户端可以共同使用一个DHCP服务器。

图8 DHCP中继工作过程示意图

![img](https://resource.h3c.com/cn/201911/20/20191120_4598473_x_Img_x_png_7_1244589_30005_0.png)

 

DHCP中继的工作过程如[图8](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/DHCP_Tech-6W100/?CHID=949107#_Ref168392577)所示。DHCP客户端发送请求报文给DHCP服务器，DHCP中继收到该报文并适当处理后，发送给指定的位于其它网段上的DHCP服务器。服务器根据请求报文中提供的必要信息，通过DHCP中继将配置信息返回给客户端，完成对客户端的动态配置。

(1)   DHCP中继接收到DHCP-DISCOVER或DHCP-REQUEST报文后，将进行如下处理：

¡   为防止DHCP报文形成环路，抛弃报文头中hops字段的值大于限定跳数的DHCP请求报文。如果收到的请求报文的报文头中hops字段的值小于或等于限定跳数，则继续进行下面的操作。

¡   检查giaddr字段。如果是0，需要将giaddr字段设置为接收请求报文的接口IP地址。如果接口有多个IP地址，则选择接口的主IP地址。以后从该接口接收的所有请求报文都使用该IP地址。如果giaddr字段不是0，则不修改该字段。

¡   将hops字段增加1，表明又经过一次DHCP中继。

¡   将请求报文的TTL设置为DHCP中继设备的TTL缺省值，而不是原来请求报文的TTL减1。中继报文的环路问题和跳数限制问题都可以通过hops字段来解决。

¡   DHCP请求报文的目的地址修改为DHCP服务器或下一个DHCP中继的IP地址。从而，将DHCP请求报文中继转发给DHCP服务器或下一个DHCP中继。

(2)   DHCP服务器根据giaddr字段为客户端分配IP地址等参数，并将DHCP应答报文发送给giaddr字段标识的DHCP中继。DHCP中继接收到DHCP应答报文后，会进行如下处理：

¡   DHCP中继假设所有的应答报文都是发给直连的DHCP客户端。giaddr字段用来识别与客户端直连的接口。如果giaddr不是本地接口的地址，DHCP中继将丢弃应答报文。

¡   DHCP中继检查报文的广播标志位。如果广播标志位为1，则将DHCP应答报文广播发送给DHCP客户端；否则将DHCP应答报文单播发送给DHCP客户端，其目的地址为yiaddr，链路层地址为chaddr。

## 2.5 DHCP Snooping运行机制

### 2.5.1 DHCP Snooping基本监听功能

DHCP Snooping即DHCP服务的二层监听功能。出于安全性的考虑，安全部门需要记录用户上网时所用的IP地址，确认用户申请的IP地址和用户使用的主机的MAC地址的对应关系。此时，可以通过DHCP Snooping功能监听接收到的DHCP-REQUEST报文和DHCP-ACK报文，从中提取并记录用户获取的IP地址信息。

### 2.5.2 DHCP Snooping信任功能

DHCP Snooping的信任功能，可以为用户提供进一步的安全性保证

DHCP Snooping信任功能可以控制DHCP服务器应答报文的来源，以防止网络中可能存在的伪造或非法DHCP服务器为其他主机分配IP地址及其他配置信息。

DHCP Snooping信任功能将端口分为信任端口和不信任端口：

·   信任端口是与合法的DHCP服务器直接或间接连接的端口。信任端口对接收到的DHCP报文正常转发，从而保证了DHCP客户端获取正确的IP地址。

·   不信任端口是不与合法的DHCP服务器连接的端口。从不信任端口接收到DHCP服务器响应的DHCP-ACK、DHCP-NAK和DHCP-OFFER报文会被丢弃，从而防止了DHCP客户端获得错误的IP地址。

# 3 DHCP扩展功能

## 3.1 DHCP安全功能

DHCP安全功能可以防止非法用户发起的地址申请攻击。在DHCP服务器或DHCP中继设备上配置DHCP安全功能后，就可以有效地进行地址规划和分配，实现对用户的控制。

DHCP安全实现的基本功能如下：

(1)   合法用户IP地址表项管理

确保所有合法用户都记录在DHCP中继的用户地址表项中。

当客户端通过DHCP中继从DHCP服务器获取到IP地址时，DHCP中继可以自动记录客户端IP地址与MAC地址的绑定关系，生成DHCP中继的动态用户地址表项。DHCP中继还支持用户表项的手工删除和查询功能。

(2)   用户地址表项老化功能

DHCP客户端释放动态获取的IP地址时，会向DHCP服务器单播发送DHCP-RELEASE报文，DHCP中继不会处理该报文的内容。如果此时DHCP中继上记录了该IP地址与MAC地址的绑定关系，则会造成DHCP中继的用户地址表项无法实时刷新。为了解决这个问题，DHCP中继支持动态用户地址表项的定时刷新功能。

DHCP中继动态用户地址表项定时刷新功能开启时，DHCP中继每隔指定时间间隔采用客户端获取到的IP地址和DHCP中继接口的MAC地址向DHCP服务器发送DHCP-REQUEST报文：

¡   如果DHCP中继接收到DHCP服务器响应的DHCP-ACK报文或在指定时间内未接收到DHCP服务器的响应报文，则表明这个IP地址已经可以进行分配，DHCP中继会删除对应的动态用户地址表项。为了避免地址浪费，DHCP中继收到DHCP-ACK报文后，会发送DHCP-RELEASE报文释放申请到的IP地址。

¡   如果DHCP中继接收到DHCP服务器响应的DHCP-NAK报文，则表示该IP地址的租约仍然存在，DHCP中继不会删除该IP地址对应的表项。

(3)   DHCP Flood攻击防范功能

DHCP Flood攻击防范功能用于防止源MAC地址固定的DHCP泛洪类攻击，本功能支持在DHCP服务器和DHCP中继上配置。

配置DHCP Flood攻击防范功能后，DHCP设备会根据DHCP报文中的源MAC地址统计收到的DHCP报文数，并创建一个check状态的DHCP防Flood攻击表项。当收到某个MAC地址对应DHCP客户端发送的报文数在指定的时间内达到配置的最大报文数时，DHCP设备认为受到了该DHCP客户端的攻击，DHCP防Flood攻击表项状态从check状态变成restrain状态，且DHCP设备丢弃该DHCP客户端发送的DHCP报文。DHCP设备在DHCP Flood攻击表项老化时间到达后会检查表项对应报文的抑制速率。如果速率小于DHCP Flood攻击报文速率阈值，设备会删除此表项，设备再次收到源MAC地址为此MAC地址的DHCP请求报文时，会重新统计接收到的报文数目；如果速率大于等于DHCP Flood攻击报文速率阈值，设备不会删除此表项，老化时间重新刷新。

(4)   DHCP接口攻击抑制功能

DHCP接口攻击抑制功能用于防止对某个指定接口的DHCP泛洪类攻击，本功能支持在DHCP服务器和DHCP中继上配置。

在某接口开启DHCP接口攻击抑制功能后，该接口收到DHCP报文后，会统计收到的DHCP报文数，同时创建一个check状态的DHCP接口攻击抑制表项。当接口收到的DHCP报文数在指定的时间内达到配置的最大报文数时，则认为该接口受到了DHCP报文攻击，DHCP接口攻击抑制表项状态从check状态变成restrain状态。在DHCP接口攻击抑制表项的老化时间到期之前，设备会限制被攻击的接口每秒钟接收DHCP报文的速率，防止DHCP攻击报文持续冲击CPU。当某个接口对应的DHCP接口攻击抑制表项老化时间到达后，接口会检查当前接口收到报文的速率。如果速率达不到攻击标准，设备会删除此表项，接口再次收到DHCP报文时，会重新统计接收到的报文数目；如果速率超过攻击标准，则DHCP接口攻击抑制表项老化时间重新刷新。

(5)   DHCP防饿死功能

DHCP饿死攻击是指攻击者伪造chaddr字段各不相同的DHCP请求报文，向DHCP服务器申请大量的IP地址，导致DHCP服务器地址池中的地址耗尽，无法为合法的DHCP客户端分配IP地址，或导致DHCP服务器消耗过多的系统资源，无法处理正常业务。

如果封装DHCP请求报文的数据帧的源MAC地址各不相同，则通过mac-address max-mac-count命令限制端口可以学习到的MAC地址数，并配置学习到的MAC地址数达到最大值时，丢弃源MAC地址不在MAC地址表里的报文，能够避免攻击者申请过多的IP地址，在一定程度上阻止了DHCP饿死攻击。此时，不存在DHCP饿死攻击的端口下的DHCP客户端可以正常获取IP地址，但存在DHCP饿死攻击的端口下的DHCP客户端仍可能无法获取IP地址。如果封装DHCP请求报文的数据帧的MAC地址都相同，则通过mac-address max-mac-count命令无法防止DHCP饿死攻击。

DHCP 服务器的MAC地址检查功能可以很好地解决饿死攻击问题。开启该功能后，DHCP服务器检查接收到的DHCP请求报文中的chaddr字段和数据帧的源MAC地址字段是否一致。如果一致，则认为该报文合法，进行后续处理；如果不一致，则丢弃该报文。

(6)   DHCP中继代理功能

设备可以通过配置DHCP中继支持代理功能，来防止非法用户攻击DHCP服务器。

开启该功能后，DHCP中继收到DHCP服务器的应答报文，会把报文中的DHCP服务器地址修改为中继的接口地址，并转发给DHCP客户端。当DHCP客户端通过DHCP中继从DHCP服务器获取到IP地址等网络参数后，DHCP客户端会把DHCP中继当作自己的服务器，来进行后续的DHCP功能的报文交互。从而达到了把真正的DHCP服务器和DHCP客户端隔离开，保护DHCP服务器的目的。

## 3.2 DHCP Option 82功能

在传统的DHCP动态分配IP地址方式中，同一VLAN的用户得到的IP地址所拥有的权限是完全相同的。网络管理者不能对同一VLAN中特定的用户进行有效的控制。普通的DHCP中继代理不支持Option 82（DHCP Relay Agent Information Option，DHCP中继代理信息选项），也不能够区分不同的客户端，从而无法结合DHCP动态分配IP地址的应用来控制客户端对网络资源的访问，给网络的安全控制提出了严峻的挑战。

RFC 3046定义了DHCP Relay Agent Information Option（Option 82），在DHCP请求报文中附加一些选项信息，使DHCP服务器能够更精确地确定用户的位置，从而对不同的用户采取不同的地址分配策略。Option 82包含两个子选项Circuit ID（Sub-option 1）和Remote ID（Sub-option 2）。

图9 Option82原理示意图

![img](https://resource.h3c.com/cn/201911/20/20191120_4598474_x_Img_x_png_8_1244589_30005_0.png)

 

如[图9](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/DHCP_Tech-6W100/?CHID=949107#_Ref15404860)所示，Option 82的工作过程为：

(1)   用户未获得动态IP地址前，只有DHCP报文可以通过DHCP Snooping/DHCP中继设备。

(2)   客户端发出的DHCP-DISCOVER报文到达DHCP Snooping/DHCP中继设备后，DHCP Snooping/DHCP中继设备将客户端的位置信息携带到Option 82中，将DHCP-DISCOVER报文转发给服务器。

(3)   支持DHCP Option 82地址分配策略的DHCP服务器根据Option 82为用户分配相应的IP地址，回应DHCP-OFFER报文，在该报文中携带原来的Option 82信息。

(4)   DHCP Snooping/DHCP中继设备将回应报文中的Option 82剥离后，将回应报文发给客户端。

(5)   客户端发出的DHCP-REQUEST报文到达DHCP Snooping/DHCP中继设备后，DHCP Snooping/DHCP中继设备将客户端的位置信息携带到Option 82中，将DHCP-REQUEST报文转发给服务器。

(6)   支持DHCP Option 82地址分配策略的DHCP服务器回应DHCP-ACK，在该报文中携带原来的Option 82信息。

(7)   DHCP Snooping/DHCP中继设备将DHCP-ACK报文中的Option 82剥离后，将DHCP-ACK报文发给客户端。

通过将Option 82与支持Option 82地址分配策略的DHCP服务器结合，可以实现使用Option 82的Circuit ID和Remote ID子选项按不同的用户权限为用户分配不同的IP地址。一方面能更精确地进行IP地址管理，另一方面可以让设备进行“源IP地址”的策略路由，从而达到不同IP地址的用户有不同的路由规则的目的。

## 3.3 自动配置功能

自动配置功能是设备在空配置启动时自动获取并执行配置文件的功能。

当设备在空配置启动时，系统会自动将设备的指定接口（如VLAN接口1或第一个以太网接口）设置为DHCP客户端，并向DHCP服务器获取IP地址及后续获取配置文件所需要的信息（例如：TFTP（Trivial File Transfer Protocol，简单文件传输协议）服务器的IP地址、TFTP服务器名、启动文件名等）。如果获取到相关信息，则DHCP客户端就可发起TFTP请求，从指定的TFTP服务器获取配置文件，之后设备使用获取到的配置文件进行设备初始化工作。如果没有获取到相关信息，设备使用空配置文件进行设备初始化工作。

# 4 典型组网应用

## 4.1 在本网段内申请地址组网

如[图10](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/DHCP_Tech-6W100/?CHID=949107#_Ref19547609)所示，DHCP客户端与DHCP服务器处于同一个网段内，以DHCP的方式动态获取IP地址和其他网络参数。

组网时需要保证DHCP服务器上的地址池网段与DHCP服务器的接口IP地址网段相匹配。

图10 DHCP客户端和DHCP服务器在同一个网段内

![img](https://resource.h3c.com/cn/201911/20/20191120_4598475_x_Img_x_png_9_1244589_30005_0.png)

 

## 1.2 跨网段申请地址组网

如[图11](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/DHCP_Tech-6W100/?CHID=949107#_Ref19547674)所示，用户跨网段申请地址，DHCP服务器与DHCP客户端不在同一个局域网中，客户端通过DHCP中继，以DHCP的方式动态获取IP地址和其他网络参数。

组网时需要把DHCP中继的接口网段与DHCP服务器的地址池网段配置为一致，否则可能会导致DHCP客户端申请的地址不在网关的网段内，致使DHCP客户端无法进行通信。同时，DHCP服务器上需要配置好路由，以保证DHCP中继与DHCP服务器能够单播通信。

图11 DHCP客户端和DHCP服务器不在同一个网段内

![img](https://resource.h3c.com/cn/201911/20/20191120_4598464_x_Img_x_png_10_1244589_30005_0.png)

 

## 1.3 DHCP Snooping应用组网

如[图12](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/DHCP_Tech-6W100/?CHID=949107#_Ref19547724)所示，DHCP客户端与DHCP服务器在同一网段内，二者通过DHCP Snooping通信，以保证DHCP客户端从合法的DHCP服务器获取IP地址。还可以通过DHCP Snooping在DHCP请求报文中添加Option 82，以便DHCP服务器根据DHCP客户端的位置信息为其分配IP地址。

组网时需要注意的是，DHCP Snooping设备所有端口默认为非信任端口，需要配置连接服务器的端口为信任端口，否则会导致DHCP服务器的应答报文无法传递给DHCP客户端。

图12 Option 82典型组网应用

![img](https://resource.h3c.com/cn/201911/20/20191120_4598465_x_Img_x_png_11_1244589_30005_0.png)

 

## 1.4 自动配置应用组网

如[图13](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/DHCP_Tech-6W100/?CHID=949107#_Ref19547780)所示，DHCP客户端在空配置启动时，通过DHCP服务器获取IP地址、TFTP服务器地址等信息后，从TFTP服务器获取配置文件并执行。

图13 自动配置典型组网应用

![img](https://resource.h3c.com/cn/201911/20/20191120_4598466_x_Img_x_png_12_1244589_30005_0.png)

 

## 1.5 DHCP应用综合组网

如所示，用户跨网段以DHCP的方式动态获取IP地址，并在二层通过DHCP Snooping提高安全性。

图14 DHCP应用综合组网

![img](https://resource.h3c.com/cn/201911/20/20191120_4598467_x_Img_x_png_13_1244589_30005_0.png)

 

# 5 参考文献

·   RFC 951：BOOTSTRAP PROTOCOL(BOOTP)

·   RFC 1497：BOOTP Vendor Information Extensions

·   RFC 2131：Dynamic Host Configuration Protocol(DHCP)

·   RFC 2132：DHCP Options and BOOTP Vendor Extensions

·   RFC 3046：DHCP Relay Agent Information Option

# 配置DHCP服务器动态分配IPv4地址

## 1.1 简介

本案例介绍配置接口工作在DHCP服务器模式，实现动态分配IPv4地址的方法。

## 1.2 组网需求

如[1.2 图1](https://www.h3c.com/cn/d_202303/1816251_30005_0.htm#_Ref83211118)所示，公司将交换机做为核心交换机，现在需要在核心交换机上划分3个VLAN网段，HostA、Host B和Host C分别属于VLAN 5、VLAN 6和VLAN 7，要求在交换机上配置DHCP服务器功能，分别给主机分配不同网段的IP地址。

·   作为DHCP服务器的Switch为网段192.168.5.0/24、192.168.6.0/24和192.168.7.0/24中的客户端动态分配IP地址；

·   Switch的三个VLAN接口，VLAN接口5、VLAN接口6和VLAN接口7的地址分别为192.168.5.254/24、192.168.6.254/24和192.168.7.254/24；

·   192.168.5.0/24网段内的DNS服务器地址为192.168.5.100/24，网关的地址为192.168.5.254/24；

·   192.168.6.0/24网段内的DNS服务器地址为192.168.6.100/24，网关的地址为192.168.6.254/24；

·   192.168.7.0/24网段内的DNS服务器地址为192.168.7.100/24，网关的地址为192.168.7.254/24。

图1 DHCP服务器配置组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774723_x_Img_x_png_0_1816251_30005_0.png)

‌

## 1.3 配置步骤

\# 配置端口所属VLAN和对应VLAN接口的IP地址，IP地址即是对应VLAN的网关地址。

<Switch> system-view

[Switch] vlan 5

[Switch-vlan5] port gigabitEthernet 1/0/5

[Switch-vlan5] quit

[Switch]vlan 6

[Switch-vlan6] port gigabitEthernet 1/0/6

[Switch-vlan6] quit

[Switch]vlan 7

[Switch-vlan7] port gigabitEthernet 1/0/7

[Switch-vlan7] quit

[Switch] interface vlan-interface 5

[Switch-Vlan-interface5] ip address 192.168.5.254 255.255.255.0

[Switch-Vlan-interface5] quit

[Switch]interface vlan-interface 6

[Switch-Vlan-interface6] ip address 192.168.6.254 255.255.255.0

[Switch-Vlan-interface6] quit

[Switch]interface vlan-interface 7

[Switch-Vlan-interface7] ip address 192.168.7.254 255.255.255.0

[Switch-Vlan-interface7] quit

\# 配置不参与自动分配的IP地址（DNS服务器等，此步为选配）

[Switch] dhcp server forbidden-ip 192.168.5.100

[Switch] dhcp server forbidden-ip 192.168.6.100

[Switch] dhcp server forbidden-ip 192.168.7.100

\# 配置DHCP地址池5，用来为192.168.5.0/24网段内的客户端分配IP地址。

[Switch] dhcp server ip-pool 5

[Switch-dhcp-pool-5] network 192.168.5.0 mask 255.255.255.0

[Switch-dhcp-pool-5] dns-list 192.168.5.100

[Switch-dhcp-pool-5] gateway-list 192.168.5.254

[Switch-dhcp-pool-5] quit

\# 配置DHCP地址池6，用来为192.168.6.0/24网段内的客户端分配IP地址。

[Switch] dhcp server ip-pool 6

[Switch-dhcp-pool-6] network 192.168.6.0 mask 255.255.255.0

[Switch-dhcp-pool-6] dns-list 192.168.6.100

[Switch-dhcp-pool-6] gateway-list 192.168.6.254

[Switch-dhcp-pool-6] quit

\# 配置DHCP地址池7，用来为192.168.7.0/24网段内的客户端分配IP地址。

[Switch] dhcp server ip-pool 7

[Switch-dhcp-pool-7] network 192.168.7.0 mask 255.255.255.0

[Switch-dhcp-pool-7] dns-list 192.168.7.100

[Switch-dhcp-pool-7] gateway-list 192.168.7.254

[Switch-dhcp-pool-7] quit

\# 开启DHCP服务

[Switch] dhcp enable

\# 配置VLAN接口5、6和7工作在DHCP服务器模式。

[Switch] interface vlan-interface 5

[Switch-Vlan-interface5] dhcp select server

[Switch-Vlan-interface5] quit

[Switch] interface vlan-interface 6

[Switch-Vlan-interface6] dhcp select server

[Switch-Vlan-interface6] quit

[Switch] interface vlan-interface 7

[Switch-Vlan-interface7] dhcp select server

[Switch-Vlan-interface7] quit

## 1.4 验证配置

配置完成后，5、6、7三个网段客户端可以从DHCP服务器申请到相应网段的IP地址和网络配置参数。

#### 1. 显示DHCP服务器的配置

\# 显示DHCP地址池的信息。

[Switch] display dhcp server pool

Pool name: 5

 Network: 192.168.5.0 mask 255.255.255.0

 dns-list 192.168.5.100

 expired day 1 hour 0 minute 0 second 0

 gateway-list 192.168.5.254

 IP-in-use threshold 100

Pool name: 6

 Network: 192.168.6.0 mask 255.255.255.0

 dns-list 192.168.6.100

 expired day 1 hour 0 minute 0 second 0

 gateway-list 192.168.6.254

 IP-in-use threshold 100

Pool name: 7

 Network: 192.168.7.0 mask 255.255.255.0

 dns-list 192.168.7.100

 expired day 1 hour 0 minute 0 second 0

 gateway-list 192.168.7.254

 IP-in-use threshold 100

#### 2. 显示DHCP服务器的IP地址分配信息

\# 显示DHCP地址绑定信息。在显示信息里可以查看DHCP服务器为客户端分配的IP地址。

[Switch] display dhcp server ip-in-use

IP address    Client-identifier/  Lease expiration   Type

​         Hardware address

192.168.5.1   0262-1d36-1802-00   Feb 18 10:41:21 2023 Auto(C)

​         3264-2e30-3130-322d-

​         566c-616e-3130

192.168.6.1   0262-1d3b-7403-00   Feb 18 10:41:17 2023 Auto(C)

192.168.7.2   0262-1d41-8304-00   Feb 18 10:41:41 2023 Auto(C)

\# 显示DHCP地址池的空闲地址信息。

[Switch] display dhcp server free-ip

Pool name: 5

 Network: 192.168.5.0 mask 255.255.255.0

  IP ranges from 192.168.5.2 to 192.168.5.99

  IP ranges from 192.168.5.101 to 192.168.5.254

 

Pool name: 6

 Network: 192.168.6.0 mask 255.255.255.0

  IP ranges from 192.168.6.2 to 192.168.6.99

  IP ranges from 192.168.6.101 to 192.168.6.254

 

Pool name: 7

 Network: 192.168.7.0 mask 255.255.255.0

  IP ranges from 192.168.7.2 to 192.168.7.99

IP ranges from 192.168.7.101 to 192.168.7.254

\# 显示租约过期的地址绑定信息。当分配的IP地址的租约超过有效期限后，执行本命令可以查看到租约过期的地址绑定信息（通过expired命令可以配置租约有效期，缺省有效期限为1天）。

[Switch] display dhcp server expired

IP address    Client-identifier/Hardware address  Lease expiration

192.168.7.1   0262-1d36-2703-00          Feb 17 10:53:52 2023

#### 3. 清除DHCP服务器的IP地址分配信息

\# 清除DHCP的正式绑定和临时绑定信息。请在用户视图下执行本命令。

[Switch] quit

<Switch> reset dhcp server ip-in-use

\# 显示DHCP地址绑定信息。此时设备上不存在相关信息。

<Switch> display dhcp server ip-in-use

IP address    Client-identifier/  Lease expiration   Type

​         Hardware address

\# 清除租约过期的地址绑定信息。请在用户视图下执行本命令。

<Switch> reset dhcp server expired

\# 显示租约过期的地址绑定信息。此时设备上不存在相关信息。

<Switch> display dhcp server ip-in-use

IP address    Client-identifier/  Lease expiration   Type

​         Hardware address

#### 4. 显示和清除DHCP服务器的统计信息

\# 显示DHCP服务器的统计信息。

<Switch> dis dhcp server statistics

  Pool number:            3

  Pool utilization:         0.00%

  Bindings:

   Automatic:            0

   Manual:             0

   Expired:             3

  Conflict:             0

  Messages received:         170

   DHCPDISCOVER:          57

   DHCPREQUEST:           57

   DHCPDECLINE:           0

   DHCPRELEASE:           56

   DHCPINFORM:           0

   BOOTPREQUEST:          0

  Messages sent:           114

   DHCPOFFER:            57

   DHCPACK:             57

   DHCPNAK:             0

   BOOTPREPLY:           0

  Bad Messages:           0

\# 清除DHCP服务器的统计信息。请在用户视图下执行本命令。

<Switch> reset dhcp server statistics

\# 清除DHCP服务器的统计信息后，设备上不存在相关统计信息。

<Switch> dis dhcp server statistics

  Pool number:            3

  Pool utilization:         0.39%

  Bindings:

   Automatic:            3

   Manual:             0

   Expired:             0

  Conflict:             0

  Messages received:         0

   DHCPDISCOVER:          0

   DHCPREQUEST:           0

   DHCPDECLINE:           0

   DHCPRELEASE:           0

​    DHCPINFORM:           0

   BOOTPREQUEST:          0

  Messages sent:           0

   DHCPOFFER:            0

   DHCPACK:             0

   DHCPNAK:             0

   BOOTPREPLY:           0

  Bad Messages:           0

## 1.5 配置文件

·   Switch： 

\#

 dhcp enable

 dhcp server forbidden-ip 192.168.5.100

 dhcp server forbidden-ip 192.168.6.100

 dhcp server forbidden-ip 192.168.7.100

\#

vlan 5 to 7

\#

dhcp server ip-pool 5

 gateway-list 192.168.5.254

 network 192.168.5.0 mask 255.255.255.0

 dns-list 192.168.5.100

\#

dhcp server ip-pool 6

 gateway-list 192.168.6.254

 network 192.168.6.0 mask 255.255.255.0

 dns-list 192.168.6.100

\#

dhcp server ip-pool 7

 gateway-list 192.168.7.254

 network 192.168.7.0 mask 255.255.255.0

 dns-list 192.168.7.100

\#

interface Vlan-interface5

 ip address 192.168.5.254 255.255.255.0

 dhcp select server

\#

interface Vlan-interface6

 ip address 192.168.6.254 255.255.255.0

 dhcp select server

\#

interface Vlan-interface7

 ip address 192.168.7.254 255.255.255.0

 dhcp select server

\#

interface GigabitEthernet1/0/5

 port link-mode bridge

 port access vlan 5

\#

interface GigabitEthernet1/0/6

 port link-mode bridge

 port access vlan 6

\#

interface GigabitEthernet1/0/7

 port link-mode bridge

 port access vlan 7

\#

## 1.6 相关资料

·   产品配套“三层技术-IP业务配置指导”中的“DHCP”。

·   产品配套“三层技术-IP业务命令参考”中的“DHCP”。



 

# 2 配置DHCP中继

## 2.1 简介

本案例介绍配置接口工作在DHCP中继模式，当DHCP客户端和DHCP服务器处于不同物理网段时，用于实现客户端可以通过DHCP中继与DHCP服务器通信，获取IP地址及其他配置信息。

## 2.2 组网需求

·   DHCP客户端所在网段为10.10.1.0/24，DHCP服务器的IP地址为10.1.1.1/24；

·   由于DHCP客户端和DHCP服务器不在同一网段，因此，需要在客户端所在网段设置DHCP中继设备，以便客户端可以从DHCP服务器申请到10.10.1.0/24网段的IP地址及相关配置信息；

·   Switch A作为DHCP中继通过端口（属于VLAN10）连接到DHCP客户端所在的网络，交换机VLAN接口10的IP地址为10.10.1.1/24，VLAN接口20的IP地址为10.1.1.2/24。

图2 DHCP中继配置组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774724_x_Img_x_png_1_1816251_30005_0.png)

‌

## 2.3 配置步骤

·   配置DHCP服务器Switch B

\# 创建VLAN接口和IP地址。

<SwitchB> system-view

[SwitchB] vlan 20

[SwitchB-vlan20] port gigabitEthernet 1/0/1

[SwitchB-vlan20] quit

[SwitchB] interface vlan-interface 20

[SwitchB-Vlan-interface20] ip address 10.1.1.1 255.255.255.0

[SwitchB-Vlan-interface20] quit

\# 配置DHCP地址池5，用来为10.10.1.0/24网段内的客户端分配IP地址。

[SwitchB] dhcp server ip-pool 5

[SwitchB-dhcp-pool-5] network 10.10.1.0 mask 255.255.255.0

[SwitchB-dhcp-pool-5] dns-list 10.10.1.100

[SwitchB-dhcp-pool-5] gateway-list 10.10.1.1

[SwitchB-dhcp-pool-5] quit

\# 配置和DHCP客户端互通的静态路由。

[SwitchB] ip route-static 10.10.1.0 24 10.1.1.2

\# 开启DHCP服务

[SwitchB] dhcp enable

\# 配置VLAN接口20工作在DHCP服务器模式。

[SwitchB] interface vlan-interface 20

[SwitchB-Vlan-interface20] dhcp select server

[SwitchB-Vlan-interface20] quit

·   配置DHCP中继设备Switch A

\# 创建VLAN接口和IP地址。

<SwitchA> system-view

[SwitchA] vlan 10

[SwitchA-vlan10] port gigabitEthernet 1/0/1

[SwitchA-vlan10] quit

[SwitchA] vlan 20

[SwitchA-vlan20] port gigabitEthernet 1/0/2

[SwitchA-vlan20] quit

[SwitchA] interface vlan-interface 10

[SwitchA-Vlan-interface10] ip address 10.10.1.1 255.255.255.0

[SwitchA-Vlan-interface10] quit

[SwitchA] interface vlan-interface 20

[SwitchA-Vlan-interface20] ip address 10.1.1.2 255.255.255.0

[SwitchA-Vlan-interface20] quit

\# 开启DHCP服务。

[SwitchA] dhcp enable

\# 配置VLAN接口10工作在DHCP中继模式。

[SwitchA] interface vlan-interface 10

[SwitchA-Vlan-interface10] dhcp select relay

\# 配置DHCP服务器的地址。

[SwitchA-Vlan-interface10] dhcp relay server-address 10.1.1.1

## 2.4 验证配置

配置完成后，DHCP客户端可以通过DHCP中继从DHCP服务器获取IP地址及相关配置信息。

\# 显示接口上指定的DHCP服务器地址信息。

[SwitchA] displsy dhcp relay server-address

Interface name   Server IP address  Public/VRF name   Class name

Vlan10       10.1.1.1      Y/--        --

\# 显示DHCP地址绑定信息。在显示信息里可以查看DHCP服务器为客户端分配的IP地址。

[SwitchB] display dhcp server ip-in-use

IP address    Client-identifier/  Lease expiration   Type

​         Hardware address

10.10.1.2    0036-3232-352e-3261- Feb 18 16:14:25 2023 Auto(C)

​         3264-2e30-3130-322d-

​         566c-616e-3130

\# 显示DHCP中继的相关报文统计信息。

[SwitchB] display dhcp relay statistics

DHCP packets dropped:         0

  Incorrect Message type:       0

  Option Parsing failed:       0

  Mac-check failed:          0

  Other count:            0

DHCP packets received from clients:  2

  DHCPDISCOVER:            1

  DHCPREQUEST:            1

  DHCPINFORM:             0

  DHCPRELEASE:            0

  DHCPDECLINE:            0

  BOOTPREQUEST:            0

DHCP packets received from servers:  2

  DHCPOFFER:             1

  DHCPACK:              1

  DHCPNAK:              0

  BOOTPREPLY:             0

DHCP packets relayed to servers:    2

  DHCPDISCOVER:            1

  DHCPREQUEST:            1

  DHCPINFORM:             0

  DHCPRELEASE:            0

  DHCPDECLINE:             0

  BOOTPREQUEST:            0

DHCP packets relayed to clients:    2

  DHCPOFFER:             1

  DHCPACK:              1

  DHCPNAK:              0

  BOOTPREPLY:             0

DHCP packets sent to servers:     0

  DHCPDISCOVER:            0

  DHCPREQUEST:            0

  DHCPINFORM:             0

  DHCPRELEASE:            0

  DHCPDECLINE:            0

  BOOTPREQUEST:            0

DHCP packets sent to clients:     0

  DHCPOFFER:             0

  DHCPACK:              0

  DHCPNAK:              0

  BOOTPREPLY:             0

\# 在用户视图下执行reset dhcp relay statistics命令，可以清除该统计信息。

[SwitchB] quit

<SwitchB> reset dhcp relay statistics

\# 再次查看显示DHCP中继的相关报文统计信息。

[SwitchB] display dhcp relay statistics

DHCP packets dropped:         0

  Incorrect Message type:       0

  Option Parsing failed:       0

  Mac-check failed:          0

  Other count:            0

DHCP packets received from clients:  0

  DHCPDISCOVER:            0

  DHCPREQUEST:            0

  DHCPINFORM:             0

  DHCPRELEASE:            0

  DHCPDECLINE:            0

  BOOTPREQUEST:            0

DHCP packets received from servers:  0

  DHCPOFFER:             0

  DHCPACK:              0

  DHCPNAK:              0

  BOOTPREPLY:             0

DHCP packets relayed to servers:    0

  DHCPDISCOVER:            0

  DHCPREQUEST:            0

  DHCPINFORM:             0

  DHCPRELEASE:            0

  DHCPDECLINE:            0

  BOOTPREQUEST:            0

DHCP packets relayed to clients:    0

  DHCPOFFER:             0

  DHCPACK:              0

  DHCPNAK:               0

  BOOTPREPLY:             0

DHCP packets sent to servers:     0

  DHCPDISCOVER:            0

  DHCPREQUEST:            0

  DHCPINFORM:             0

  DHCPRELEASE:             0

  DHCPDECLINE:            0

  BOOTPREQUEST:            0

DHCP packets sent to clients:     0

  DHCPOFFER:             0

  DHCPACK:              0

  DHCPNAK:              0

  BOOTPREPLY:             0

## 2.5 配置文件

·   配置Switch B

\#

 dhcp enable

\#

vlan 20

\#

dhcp server ip-pool 5

 gateway-list 10.10.1.1

 network 10.10.1.0 mask 255.255.255.0

 dns-list 10.10.1.100

\#

interface Vlan-interface20

 ip address 10.1.1.1 255.255.255.0

 dhcp select server

\#

interface GigabitEthernet1/0/1

 port link-mode bridge

 port access vlan 20

\#

 ip route-static 10.10.1.0 24 10.1.1.2

\#

·   配置Switch A

\#

 dhcp enable

\#

vlan 10

\#

vlan 20

\#

interface Vlan-interface10

 ip address 10.10.1.1 255.255.255.0

 dhcp select relay

 dhcp relay server-address 10.1.1.1

\#

interface Vlan-interface20

 ip address 10.1.1.2 255.255.255.0

\#

interface GigabitEthernet1/0/1

 port link-mode bridge

 port access vlan 10

\#

interface GigabitEthernet1/0/2

 port link-mode bridge

 port access vlan 20

\#

## 2.6 相关资料

·   产品配套“三层技术-IP业务配置指导”中的“DHCP”。

·   产品配套“三层技术-IP业务命令参考”中的“DHCP”。



 

# 3 配置DHCP Snooping

## 3.1 简介

本案例介绍配置DHCP Snooping功能的配置方法。

## 3.2 组网需求

如[3.2 图3](https://www.h3c.com/cn/d_202303/1816251_30005_0.htm#_Ref83718762)所示，Switch通过以太网端口GigabitEthernet1/0/1连接到合法DHCP服务器，通过以太网端口GigabitEthernet1/0/3连接到非法DHCP服务器，通过GigabitEthernet1/0/2连接到DHCP客户端。要求：

·   与合法DHCP服务器相连的端口可以转发DHCP服务器的响应报文，而其他端口不转发DHCP服务器的响应报文。

·   记录DHCP-REQUEST报文和信任端口收到的DHCP-ACK报文中DHCP客户端IP地址及MAC地址的绑定信息。

图3 DHCP Snooping配置组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774725_x_Img_x_png_2_1816251_30005_0.png)

‌

## 3.3 配置步骤

\# 全局开启DHCP Snooping功能。

<Switch> system-view

[Switch] dhcp snooping enable

\# 设置GigabitEthernet1/0/1端口为信任端口。

[Switch] interface gigabitethernet 1/0/1

[Switch-GigabitEthernet1/0/1] dhcp snooping trust

[Switch-GigabitEthernet1/0/1] quit

\# 在GigabitEthernet1/0/2上开启DHCP Snooping表项功能。

[Switch] interface gigabitethernet 1/0/2

[Switch-GigabitEthernet1/0/2] dhcp snooping binding record

[Switch-GigabitEthernet1/0/2] quit

## 3.4 验证配置

配置完成后，DHCP客户端只能从合法DHCP服务器获取IP地址和其它配置信息，非法DHCP服务器无法为DHCP客户端分配IP地址和其他配置信息。且使用display dhcp snooping binding可查询到获取到的DHCP Snooping表项。在用户视图下执行reset dhcp snooping binding命令，可以清除DHCP Snooping表项。

## 3.5 配置文件

\#

 dhcp snooping enable

\#

interface GigabitEthernet1/0/1

 port link-mode bridge

 dhcp snooping trust

\#

interface GigabitEthernet1/0/2

 port link-mode bridge

 dhcp snooping binding record

\#

## 3.6 相关资料

·   产品配套“三层技术-IP业务配置指导”中的“DHCP”。

·   产品配套“三层技术-IP业务命令参考”中的“DHCP”。



 

# 4 配置DHCPv6服务器动态分配IPv6地址

## 4.1 简介

本案例介绍配置接口工作在DHCPv6服务器模式，实现动态分配IPv6地址的方法。

## 4.2 组网需求

如[图4](https://www.h3c.com/cn/d_202303/1816251_30005_0.htm#_Ref81318014)所示，交换机作为企业网络内部的网关设备。配置交换机接口工作在DHCPv6服务器模式，并配置地址/前缀分配方式，从而为主机Host A和Host B自动分配IPv6地址。不同网段的主机通过IPv6静态路由互相访问。

·   Host A、Host B、Switch A和Switch B之间通过以太网端口相连，将以太网端口分别加入相应的VLAN里，在VLAN接口上配置IPv6地址，验证它们之间的互通性。

·   配置VLAN接口工作在DHCPv6服务器模式，并引用地址池，从而为主机自动分配IPv6地址。

·   在Switch A和Switch B上配置IPv6静态路由，实现各网段的互通。

图4 动态分配IPv6地址组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774726_x_Img_x_png_3_1816251_30005_0.png)

‌

## 4.3 配置步骤

#### 1. 配置Switch A

\# 创建VLAN，在VLAN中加入对应的端口。

<SwitchA> system-view

[SwitchA] vlan 3

[SwitchA-vlan3] port gigabitethernet 1/0/2

[SwitchA-vlan3] quit

[SwitchA] vlan 2

[SwitchA-vlan2] port gigabitethernet 1/0/1

[SwitchA-vlan2] quit

\# 手工指定VLAN接口2的全球单播地址。

[SwitchA] interface vlan-interface 2

[SwitchA-Vlan-interface2] ipv6 address 3001::1/64

[SwitchA-Vlan-interface2] quit

\# 手工指定VLAN接口3的全球单播地址，并允许其发布RA消息。

[SwitchA] interface vlan-interface 3

[SwitchA-Vlan-interface3] ipv6 address 2001::1/64

[SwitchA-Vlan-interface3] undo ipv6 nd ra halt

\# 配置VLAN接口3引用DHCP地址池。

[SwitchA-Vlan-interface3] ipv6 dhcp server apply pool 1 allow-hint rapid-commit

\# 配置被管理地址的配置标志位为1，即主机通过DHCPv6服务器获取IPv6地址。配置其他信息配置标志位为1，即主机通过DHCPv6服务器获取除IPv6地址以外的其他信息。

[SwitchA-Vlan-interface3] ipv6 nd autoconfig managed-address-flag

[SwitchA-Vlan-interface3] ipv6 nd autoconfig other-flag

\# 配置接口VLAN接口3工作在DHCPv6服务器模式。

[SwitchA-Vlan-interface3] ipv6 dhcp select server

[SwitchA-Vlan-interface3] quit

\# 配置DHCPv6地址池1。

[SwitchA] ipv6 dhcp pool 1

[SwitchA-dhcp6-pool-1] network 2001::/64

[SwitchA-dhcp6-pool-1] dns-server 1::1

[SwitchA-dhcp6-pool-1] quit

\# 配置IPv6静态路由，该路由的目的地址为4001::/64，下一跳地址为3001::2。

[SwitchA] ipv6 route-static 4001:: 64 3001::2

\# 保存配置。

[SwitchA] save force

#### 2. 配置Switch B

\# 创建VLAN，在VLAN中加入对应的端口。

<SwitchB> system-view

[SwitchB] vlan 2

[SwitchB-vlan2] port gigabitethernet 1/0/1

[SwitchB-vlan2] quit

[SwitchB] vlan 3

[SwitchB-vlan3] port gigabitethernet 1/0/2

[SwitchB-vlan3] quit

\# 手工指定VLAN接口2的全球单播地址。

[SwitchB] interface vlan-interface 2

[SwitchB-Vlan-interface2] ipv6 address 3001::2/64

[SwitchB-Vlan-interface2] quit

\# 手工指定VLAN接口3的全球单播地址，并允许其发布RA消息。

[SwitchB] interface vlan-interface 3

[SwitchB-Vlan-interface3] ipv6 address 4001::1/64

[SwitchB-Vlan-interface3] undo ipv6 nd ra halt

\# 配置VLAN接口3引用DHCP地址池。

[SwitchB-Vlan-interface3] ipv6 dhcp server apply pool 1 allow-hint rapid-commit

\# 配置被管理地址的配置标志位为1，即主机通过DHCPv6服务器获取IPv6地址。配置其他信息配置标志位为1，即主机通过DHCPv6服务器获取除IPv6地址以外的其他信息。

[SwitchB-Vlan-interface3] ipv6 nd autoconfig managed-address-flag

[SwitchB-Vlan-interface3] ipv6 nd autoconfig other-flag

\# 配置接口VLAN接口3工作在DHCPv6服务器模式。

[SwitchB-Vlan-interface3] ipv6 dhcp select server

[SwitchB-Vlan-interface3] quit

\# 配置DHCPv6地址池1。

[SwitchB] ipv6 dhcp pool 1

[SwitchB-dhcp6-pool-1] network 4001::/64

[SwitchB-dhcp6-pool-1] dns-server 1::1

[SwitchB-dhcp6-pool-1] quit

\# 配置IPv6静态路由，该路由的目的地址为2001::/64，下一跳地址为3001::1。

[SwitchB] ipv6 route-static 2001:: 64 3001::1

\# 保存配置。

[SwitchB] save force

#### 3. 配置Host A

在Host A上安装IPv6，并配置自动获取IPv6地址。

#### 4. 配置Host B

在Host B上安装IPv6，并配置自动获取IPv6地址。

## 4.4 验证配置

#### 1. 显示DHCPv6服务器的配置

\# 显示DHCPv6地址池的信息。

[SwitchA] display ipv6 dhcp server ip-in-use

DHCPv6 pool: 1

 Network: 2001::/64

  Preferred lifetime 604800 seconds, valid lifetime 2592000 seconds

 DNS server addresses:

  1::1

 IP-in-use threshold: 100

 PD-in-use threshold: 100

\# 显示接口上的DHCPv6服务器信息。

[SwitchA] displsy ipv6 dhcp server

Interface            Pool

Vlan-interface1         1

#### 2. 显示和清除DHCPv6服务器的地址绑定信息

\# 在Switch A上查看DHCPv6服务器为客户端分配的IPv6地址。

[SwitchA] display ipv6 dhcp server ip-in-use

Pool: 1

 IPv6 address                Type   Lease expiration

 2001::2                   Auto(C)  Sep 30 11:45:07 2021

\# 从Switch A上查看端口GigabitEthernet1/0/2的邻居信息。

[SwitchA] display ipv6 neighbors interface gigabitethernet 1/0/2

Type: S-Static   D-Dynamic  O-Openflow   R-Rule  IS-Invalid static

IPv6 address       MAC address  VLAN/VSI  Interface   State T Aging

2001::2          b025-0b54-0106 --     GE1/0/2    REACH D 29

FE80::B225:BFF:FE54:106  b025-0b54-0106 --     GE1/0/2    REACH D 18

通过上面的信息可以知道Host A上获得的IPv6全球单播地址为2001::2。

\# 显示租约过期的DHCPv6地址绑定信息。

[SwitchA] display ipv6 dhcp server expired

IPv6 address      DUID              Lease expiration

2001::3        0262-9ead-ab03-00        Feb 17 17:09:02 2023

\# 清除DHCPv6的正式地址绑定和临时地址绑定信息。并再次查看DHCPv6服务器为客户端分配的IPv6地址

[SwitchA] quit

<SwitchA> reset ipv6 dhcp server ip-in-use

<SwitchA> display ipv6 dhcp server ip-in-use

\# 清除DHCPv6的正式地址绑定和临时地址绑定信息。并再次查看租约过期的DHCPv6地址绑定信息

<SwitchA> reset ipv6 dhcp server expired

<SwitchA> IPv6 address      DUID              Lease expiration

#### 3. 显示和清除DHCPv6服务器的报文统计信息

\# 显示DHCPv6服务器的报文统计信息。

<SwitchA> displsy ipv6 dhcp server statistics

Bindings:

  Ip-in-use         : 0

  Pd-in-use         : 0

  Expired          : 1

Conflict           : 1

Packets received       : 24

  Solicit          : 8

  Request          : 8

  Confirm          : 0

  Renew           : 0

  Rebind          : 0

  Release          : 8

  Decline          : 0

  Information-request    : 0

  Relay-forward       : 0

Packets dropped        : 0

Packets sent          : 24

  Advertise         : 8

  Reconfigure        : 0

  Reply           : 16

  Relay-reply        : 0

\# 在用户视图下执行reset ipv6 dhcp server statistics命令，可以清除该统计信息。

<SwitchA> reset ipv6 dhcp server statistics

<SwitchA> display ipv6 dhcp server statistics

Bindings:

  Ip-in-use         : 0

  Pd-in-use         : 0

  Expired          : 1

Conflict           : 1

Packets received       : 0

  Solicit          : 0

  Request          : 0

  Confirm          : 0

  Renew           : 0

  Rebind          : 0

  Release          : 0

  Decline          : 0

  Information-request    : 0

  Relay-forward       : 0

Packets dropped        : 0

Packets sent         : 0

  Advertise         : 0

  Reconfigure        : 0

  Reply           : 0

  Relay-reply        : 0

\# 在Switch B上查看DHCPv6服务器为客户端分配的IPv6地址

[SwitchB] display ipv6 dhcp server ip-in-use

Pool: 1

 IPv6 address                Type   Lease expiration

 4001::2                   Auto(C)  Sep 30 14:05:49 2021

\# 从Switch B上查看端口GigabitEthernet1/0/2的邻居信息。

[SwitchB] display ipv6 neighbors interface gigabitethernet 1/0/2

Type: S-Static  D-Dynamic  O-Openflow   R-Rule  IS-Invalid static

IPv6 address       MAC address  VLAN/VSI  Interface   State T Aging

4001::2          b043-5415-0406 --     GE1/0/2    REACH D 3

FE80::B243:54FF:FE15:406 b043-5415-0406 --     GE1/0/2    REACH D 44

通过上面的信息可以知道Host B上获得的IPv6全球单播地址为4001::2。

从Host A上也可以ping通Host B，证明它们是互通的。

## 4.5 配置文件

·   Switch A： 

\#

vlan 2 to 3

\#

ipv6 dhcp pool 1

 network 2001::/64

 dns-server 1::1

\#

interface Vlan-interface3

 ipv6 dhcp select server

 ipv6 dhcp server apply pool 1 allow-hint rapid-commit

 ipv6 address 2001::1/64

 ipv6 nd autoconfig managed-address-flag

 ipv6 nd autoconfig other-flag

 undo ipv6 nd ra halt

\#

interface Vlan-interface2

 ipv6 address 3001::1/64

\#

interface GigabitEthernet1/0/1

 port link-mode bridge

 port access vlan 2

\#

interface GigabitEthernet1/0/2

 port link-mode bridge

 port access vlan 3

\#

 ipv6 route-static 4001:: 64 3001::2

\#

·   Switch B ：

\#

vlan 2 to 3

\#

ipv6 dhcp pool 1

 network 4001::/64

 dns-server 1::1

\#

interface Vlan-interface2

 ipv6 address 3001::2/64

\#

interface Vlan-interface3

 ipv6 dhcp select server

 ipv6 dhcp server apply pool 1 allow-hint rapid-commit

 ipv6 address 4001::1/64

 ipv6 nd autoconfig managed-address-flag

 ipv6 nd autoconfig other-flag

 undo ipv6 nd ra halt

\#

interface GigabitEthernet1/0/1

 port link-mode bridge

 port access vlan 2

\#

interface GigabitEthernet1/0/2

 port link-mode bridge

 port access vlan 3

\#

 ipv6 route-static 2001:: 64 3001::1

\#





#  概述

随着网络规模的扩大化和网络环境的复杂化，DHCP服务被应用到越来越多的网络环境中。DHCP虽然提供了一种简捷、高效的主机配置机制，但由于在设计上未充分考虑到安全因素，从而留下许多安全漏洞，使得DHCP服务器很容易受到攻击。

本文将针对几种常见的DHCP攻击，对我司支持的DHCP防攻击功能的技术特点以及应用场景进行归纳总结，以帮助用户更好地应用这些功能。本文涉及的DHCP协议的相关原理以及作用机制，请参考《DHCP技术白皮书》。

# 2 DHCP攻击类型

在实际网络中，主要存在以下四种DHCP攻击类型：

·   DHCP饿死攻击

·   DHCP Flood攻击

·   仿冒DHCP Server攻击

·   伪造DHCP请求方向报文攻击

### 2.1.1 DHCP饿死攻击

攻击者伪造chaddr（client hardware address，DHCP客户端的硬件地址）字段各不相同的DHCP请求报文，向DHCP服务器申请大量的IP地址。一方面导致DHCP服务器地址池中的地址耗尽，无法为合法的DHCP客户端分配IP地址；另一方面可能导致DHCP服务器消耗过多的系统资源，无法处理正常业务。

图2-1 DHCP饿死攻击

![img](https://resource.h3c.com/cn/202202/15/20220215_6730412_x_Img_x_png_0_1545361_30005_0.png)

 

### 2.1.2 DHCP Flood攻击

攻击者短时间内恶意向DHCP服务器发送大量的DHCP请求报文申请IP地址，侵占DHCP服务器的系统资源，导致其它合法的DHCP交互无法正常进行。

图2-2 DHCP Flood攻击

![img](https://resource.h3c.com/cn/202202/15/20220215_6730413_x_Img_x_png_1_1545361_30005_0.png)

 

### 2.1.3 仿冒DHCP Server攻击

攻击者私自安装并运行DHCP Server程序后，将自己伪装成DHCP Server。DHCP客户端接收到来自DHCP Server的DHCP应答报文后，无法判断DHCP Server是否合法。如果客户端第一个接收到的应答报文来自仿冒的DHCP Server，那么仿冒的DHCP Server会给DHCP客户端分配错误的IP地址，导致DHCP客户端无法访问网络。

图2-3 仿冒DHCP Server攻击

![img](https://resource.h3c.com/cn/202202/15/20220215_6730414_x_Img_x_png_2_1545361_30005_0.png)

 

### 2.1.4 伪造DHCP请求方向报文攻击

非法客户端伪造DHCP续约报文、DHCP-DECLINE和DHCP-RELEASE三种DHCP请求方向的报文对DHCP服务器进行攻击：

·   伪造DHCP续约报文攻击是指攻击者冒充合法的DHCP客户端，向DHCP服务器发送伪造的DHCP续约报文，导致DHCP服务器和DHCP客户端无法按照自己的意愿及时释放IP地址租约。如果攻击者冒充不同的DHCP客户端发送大量伪造的DHCP续约报文，则会导致大量IP地址被长时间占用，DHCP服务器没有足够的地址分配给新的DHCP客户端。

·   伪造DHCP-DECLINE/DHCP-RELEASE报文攻击是指攻击者冒充合法的DHCP客户端，向DHCP服务器发送伪造的DHCP-DECLINE/DHCP-RELEASE报文，导致DHCP服务器错误终止IP地址租约。

图2-4 伪造DHCP请求方向报文攻击

![img](https://resource.h3c.com/cn/202202/15/20220215_6730415_x_Img_x_png_3_1545361_30005_0.png)

 

# 3 DHCP防攻击技术实现

## 3.1 DHCP防攻击技术简介

针对四种常见的DHCP攻击,设备可以采取的防范措施及部署位置如[表3-1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/DHCP-1946/?CHID=651914#_Ref92911189)所示。

表3-1 DHCP防攻击技术

| 攻击类型                                                     | 防范措施                            | 防范措施部署位置                    |
| ------------------------------------------------------------ | ----------------------------------- | ----------------------------------- |
| DHCP饿死攻击                                                 | DHCP防饿死攻击功能                  | DHCP服务器、DHCP中继、DHCP Snooping |
| 存在大量DHCP饿死攻击报文时，可同时开启DHCP防饿死攻击功能和DHCP Flood攻击防范相关功能 | DHCP服务器、DHCP中继、DHCP Snooping |                                     |
| DHCP Flood攻击                                               | DHCP Flood攻击防范功能              | DHCP服务器、DHCP中继                |
| DHCP接口攻击抑制功能                                         | DHCP服务器、DHCP中继                |                                     |
| 限制接口动态学习DHCP Snooping表项的最大数目                  | DHCP  Snooping                      |                                     |
| DHCP Snooping报文限速功能                                    | DHCP  Snooping                      |                                     |
| 仿冒DHCP Server攻击                                          | DHCP Snooping信任功能               | DHCP  Snooping                      |
| 伪造DHCP请求方向报文攻击                                     | 防止伪造DHCP请求方向报文攻击功能    | DHCP  Snooping                      |

 

## 3.2 DHCP防饿死攻击功能

DHCP防饿死攻击功能用于防止DHCP饿死攻击。本功能支持在DHCP服务器、DHCP中继和DHCP Snooping设备上配置，部署位置如[图3-1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/DHCP-1946/?CHID=651914#_Ref93069866)所示。

图3-1 DHCP防饿死攻击功能部署

![img](https://resource.h3c.com/cn/202202/15/20220215_6730416_x_Img_x_png_4_1545361_30005_0.png)

 

针对攻击者发送报文的源MAC地址，可以采取不同的防饿死攻击措施：

·   如果封装DHCP请求报文的数据帧的源MAC地址各不相同，则攻击者接入的接口会学习到大量的MAC地址。此时，可以通过设置允许接口学习的最大MAC地址数，并配置当达到接口的MAC地址数学习上限时，禁止转发源MAC地址不在MAC地址表里的报文来防止饿死攻击。当接口学习到的MAC地址数达到最大值时，接口将丢弃源MAC地址不在MAC地址表中的请求报文，从而避免攻击者申请到过多的IP地址，在一定程度上阻止了DHCP饿死攻击。其它不存在DHCP饿死攻击的接口连接的DHCP客户端仍可以正常获取IP地址。

·   如果封装DHCP请求报文的数据帧的源MAC地址相同，则可以通过在DHCP设备上开启MAC地址检查功能来防止饿死攻击。开启该功能后，DHCP设备会检查接收到的DHCP请求报文中的chaddr字段和数据帧的源MAC地址字段是否一致。如果一致，则认为该报文合法，进行后续处理；如果不一致，则丢弃该报文。

## 3.3 DHCP Flood攻击防范功能

### 3.3.1 DHCP Flood攻击防范功能

DHCP Flood攻击防范功能用于防止源MAC地址固定的DHCP泛洪类攻击。本功能支持在DHCP服务器和DHCP中继上配置，部署位置如[图3-2](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/DHCP-1946/?CHID=651914#_Ref93068771)所示。

图3-2 DHCP Flood攻击防范功能部署

![img](https://resource.h3c.com/cn/202202/15/20220215_6730417_x_Img_x_png_5_1545361_30005_0.png)

 

接口开启DHCP Flood攻击防范功能后：

(1)   DHCP设备会根据DHCP请求报文中的源MAC地址统计收到的DHCP请求报文数，同时创建一个check状态的DHCP防Flood攻击表项。

(2)   当某个源MAC地址对应DHCP客户端发送的DHCP请求报文数在指定时间内达到配置的阈值时，则认为DHCP设备受到了DHCP报文攻击，该DHCP客户端对应的DHCP防Flood攻击表项状态被置为restrain，DHCP设备将丢弃后续收到的该DHCP客户端发送的DHCP请求报文。

(3)   当该源MAC地址的DHCP防Flood攻击表项老化时，将重新统计本接口指定时间内收到的来自该DHCP客户端的DHCP请求报文数。

¡   如果未超过阈值，则删除此表项。当再次收到同一源MAC的DHCP请求报文时，将重新统计接收到的报文数并建立check状态的DHCP防Flood攻击表项；

¡   如果仍超过阈值，则刷新DHCP防Flood攻击表项老化时间，继续丢弃其发送的DHCP请求报文。

### 3.3.2 DHCP接口攻击抑制功能

DHCP接口攻击抑制功能用于防止对某个指定接口的DHCP泛洪类攻击。本功能支持在DHCP服务器和DHCP中继上配置，部署位置与DHCP Flood攻击防范功能一致。

接口开启DHCP接口攻击抑制功能后：

(1)   DHCP设备会统计该接口收到的DHCP请求报文数，同时创建一个check状态的DHCP接口攻击抑制表项。

(2)   当接口收到的DHCP请求报文数在指定时间内达到配置的阈值时，则认为DHCP设备受到了DHCP报文攻击，DHCP接口攻击抑制表项状态从check变成restrain，设备将限制该接口接收DHCP请求报文的速率，避免DHCP攻击报文持续冲击CPU。

(3)   当接口对应的DHCP接口攻击抑制表项老化时，DHCP设备会重新统计该接口指定时间内收到的DHCP请求报文数。

¡   如果未超过阈值，则删除此表项。当再次收到DHCP请求报文时，重新统计接收到的报文数并建立check状态的DHCP防Flood攻击表项；

¡   如果仍超过阈值，则刷新DHCP接口攻击抑制表项老化时间，继续限制被该接口接收DHCP请求报文的速率。

### 3.3.3 DHCP Snooping报文限速功能

为了避免非法用户发送大量DHCP报文，对网络造成攻击，DHCP Snooping支持报文限速功能，限制接口接收DHCP报文的速率。当接口接收的DHCP报文速率超过限制的最高速率时，DHCP Snooping设备将丢弃超过速率限制的报文。DHCP Snooping报文限速功能的部署位置如[图3-3](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/DHCP-1946/?CHID=651914#_Ref93075940)所示。

图3-3 DHCP Snooping报文限速功能部署

![img](https://resource.h3c.com/cn/202202/15/20220215_6730418_x_Img_x_png_6_1545361_30005_0.png)

 

### 3.3.4 限制接口动态学习DHCP Snooping表项的最大数目

限制接口动态学习DHCP Snooping表项的最大数目，可以防止接口学习到大量DHCP Snooping表项，占用过多的系统资源。接口动态学习的DHCP Snooping表项数达到最大数目后，不影响DHCP Snooping功能正常运行，只是接口不会再继续学习新的DHCP Snooping表项。本功能的部署位置与DHCP Snooping报文限速功能一致。

## 3.4 仿冒DHCP Server攻击防范功能

### 3.4.1 DHCP Snooping信任功能

DHCP Snooping信任功能通过控制DHCP服务器应答报文的来源，可以有效地阻止仿冒或非法的DHCP服务器为DHCP客户端分配IP地址及其他配置信息。

DHCP Snooping信任功能将端口分为信任端口和不信任端口：

·   将与合法DHCP服务器直接或间接连接的端口设置为信任端口，信任端口对接收到的DHCP报文正常转发，从而保证了DHCP客户端获取正确的IP地址。

·   将未与合法DHCP服务器连接的端口都设置为不信任端口，从不信任端口接收到DHCP服务器响应的DHCP-ACK、DHCP-NAK和DHCP-OFFER报文会被丢弃，从而防止了DHCP客户端获得错误的IP地址及网络参数。

DHCP Snooping信任功能中信任端口的部署情况如[图3-4](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/DHCP-1946/?CHID=651914#_Ref93070249)所示。

图3-4 DHCP Snooping信任功能

![img](https://resource.h3c.com/cn/202202/15/20220215_6730419_x_Img_x_png_7_1545361_30005_0.png)

 

## 3.5 防止伪造DHCP请求方向报文攻击功能

在DHCP Snooping设备上开启DHCP请求方向报文检查功能后，当DHCP Snooping设备接收到DHCP请求方向报文时，会检查本地的DHCP Snooping表项：

·   若存在与请求方向报文匹配的DHCP Snooping表项：

¡   请求方向的报文信息与DHCP Snooping表项信息一致时，认为该DHCP请求方向报文合法，将其转发给DHCP服务器；

¡   请求方向的报文信息与DHCP Snooping表项信息不一致时，则认为该报文为伪造的DHCP请求方向报文，将其丢弃。

·   若不存在与请求方向报文匹配的DHCP Snooping表项，则认为该报文合法，将其转发给DHCP服务器。

本功能的部署位置如[图3-5](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/DHCP-1946/?CHID=651914#_Ref93076537)所示。

图3-5 防止伪造DHCP请求方向报文攻击功能部署

![img](https://resource.h3c.com/cn/202202/15/20220215_6730420_x_Img_x_png_8_1545361_30005_0.png)

 

# 4 DHCP防攻击技术应用综合组网

如[图4-1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Routers/00-Public/Learn_Technologies/White_Paper/DHCP-1946/?CHID=651914#_Ref91345530)所示，用户跨网段以DHCP的方式动态获取IP地址。采取如下措施以防止DHCP攻击：

·   将DHCP Snooping设备上与DHCP中继设备相连的端口设置为信任端口，其余接口设置为不信任端口，防止收到来自仿冒DHCP Server的报文。

·   在DHCP Snooping设备上与攻击者相连的接口上配置限制接口动态学习DHCP Snooping表项的最大数目、DHCP Snooping报文限速功能和防止伪造DHCP请求方向报文攻击功能。

·   在DHCP中继与攻击者相连的接口上配置DHCP防饿死攻击功能、DHCP Flood攻击防范功能和DHCP接口攻击抑制功能。

图4-1 DHCP防攻击技术应用综合组网

![img](https://resource.h3c.com/cn/202202/15/20220215_6730421_x_Img_x_png_9_1545361_30005_0.png)

 