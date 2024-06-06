##  产生背景

在为网络中的所有设备都配置某些VLAN时，需要网络管理员在每台设备上分别进行手工添加。如[图1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/MVRP_White_Paper-6W100/?CHID=949093#_Ref22049048)所示，Device A上有VLAN 2，Device B和Device C上只有VLAN 1，三台设备通过Trunk链路连接在一起。为了使Device A上VLAN 2的报文可以传到Device C，网络管理员必须在Device B和Device C上分别手工添加VLAN 2。

图1 MVRP应用组网

![img](https://resource.h3c.com/cn/201910/25/20191025_4562865_x_Img_x_png_0_1238952_30005_0.png)

 

对于上面的组网环境，手工添加VLAN很简单，但是当实际组网复杂或整个网络的VLAN太多时，网络管理员无法短时间内完全了解网络的拓扑结构，并且工作量会非常大，而且非常容易配置错误。在这种情况下，用户可以通过MVRP的VLAN自动注册功能完成VLAN的配置。

## 1.2 技术优势

MRP（Multiple Registration Protocol，多属性注册协议）作为一个属性注册协议的载体，可以用来传递属性信息。MVRP（Multiple VLAN Registration Protocol，多VLAN注册协议）是MRP的一种应用，用于在设备间发布并学习VLAN配置信息。通过MVRP，局域网中的设备可以自动同步VLAN信息，极大地减少了网络管理员的VLAN配置工作。

# 2 MVRP技术实现

## 2.1 MVRP应用实体

设备上每一个参与MRP协议的端口都可以视为一个应用实体。当MRP应用（如MVRP）在端口上启动之后，该端口就可视为一个MRP应用实体（以下简称MRP实体，同样的，MVRP应用实体简称MVRP实体）。

## 2.2 VLAN的注册和注销

MVRP协议可以实现VLAN属性的自动注册和注销：

·   VLAN的注册：端口加入VLAN。

·   VLAN的注销：端口退出VLAN。

MVRP协议通过发送声明和回收声明类消息实现VLAN属性的注册和注销：

·   当端口接收到一个VLAN属性声明时，该端口将注册该声明中包含的VLAN信息（端口加入VLAN）。

·   当端口接收到一个VLAN属性的回收声明时，该端口将注销该声明中包含的VLAN信息（端口退出VLAN）。

MVRP协议的属性注册和注销仅仅是对于接收到MVRP协议报文的端口而言的。

图2 VLAN的注册和注销

![img](https://resource.h3c.com/cn/201910/25/20191025_4562866_x_Img_x_png_1_1238952_30005_0.png)

 

## 2.3 MRP消息

### 2.3.1 MRP消息封装结构

MRP消息通过MRP协议报文传递，MRP协议报文以特定组播MAC地址为目的MAC，如MVRP的目的MAC地址为01-80-C2-00-00-21，Type为88F5。当设备在收到MRP应用实体的报文后，会根据其目的MAC地址分发给不同的MRP应用进行处理。

MRP协议报文采用IEEE 802.3 Ethernet封装格式，如[图3](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/MVRP_White_Paper-6W100/?CHID=949093#_Ref16586816)所示

图3 MRP协议报文封装格式

![img](https://resource.h3c.com/cn/201910/25/20191025_4562867_x_Img_x_png_2_1238952_30005_0.png)

 

主要字段的说明如[表1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/MVRP_White_Paper-6W100/?CHID=949093#_Ref16586808)所示。

表1 MRP协议报文主要字段说明

| 字段             | 说明                                                         |
| ---------------- | ------------------------------------------------------------ |
| MRPDU            | 封装在MRP协议报文中的MRPDU（Protocol Data Unit，协议数据单元） |
| Protocol Version | 协议版本号，目前为0                                          |
| Message          | 属性消息，每个消息都由Attribute Type，Attribute Length和Attribute List三个字段构成，一个MRPDU中可以包含多个属性消息 |
| End Mark         | 属性及消息的结束标记，取值为0x00                             |
| Attribute Type   | 属性类型，目前使用的是VID Vector属性类型，取值为1            |
| Attribute Length | First Value字段的长度取值，在MVRP中规定其取值为2             |
| Attribute List   | 属性列表，由多个属性构成                                     |
| Vector Attribute | 属性，每个属性都由Vector Header，First Value和Vector这三个字段构成 |
| Vector Header    | 向量头域，每个向量头域由LeaveAll Event和Number Of Values这两个字段构成 |
| First Value      | 起始属性值，长度为2字节。MVRP应用的属性取值为VLAN ID         |
| Vector           | 属性所描述的操作，取值及含义如下：  ·   0x00：表示LeaveAll操作   ·   0x01：表示JoinEmpty操作  ·   0x02：表示JoinIn操作  ·   0x03：表示LeaveEmpty操作  ·   0x04：表示LeaveIn操作  ·   0x05：表示Empty操作 |
| LeaveAll Event   | 是否为LeaveAll操作：  ·   0表示非LeaveAll操作  ·   1表示LeaveAll操作 |
| Number of Values | Vector字段中包含的属性值数量，长度为13bits                   |

 

### 2.3.2 MRP消息类型

MRP消息主要包括Join消息、New消息、Leave消息和LeaveAll消息，它们通过互相配合来实现信息的注册或注销。其中，Join消息和New消息属于声明，Leave消息和LeaveAll消息属于回收声明。

#### 1. Join消息

当一个MRP实体配置了某些属性，需要对端实体来注册自己的属性信息时，它会向对端实体发送Join消息。

当一个MRP实体收到来自对端实体的Join消息时，它会注册该Join消息中的属性，并向本设备的其他实体传播该Join消息，其他实体收到传播的Join消息后，向其对端实体发送Join消息。

MRP实体间发送的Join消息又分为JoinEmpty和JoinIn两种（对于同一设备的实体间传播的Join消息则不做区分），二者的区别如下：

·   JoinEmpty：用于声明MRP实体的非注册属性。比如一个MRP实体加入了某静态VLAN（我们将本地手工创建的VLAN称为静态VLAN，通过MRP消息学习并创建的VLAN称为动态VLAN），此时若该实体还没有通过MRP消息注册该VLAN，这时该实体向对端实体发送的Join消息就为JoinEmpty消息。

·   JoinIn：用于声明MRP实体的注册属性。比如MRP实体加入了某静态VLAN且通过MRP消息注册了该VLAN，或该实体收到本设备其他实体传播的某VLAN的Join信息且通过MRP消息注册了该VLAN，这时该实体向对端实体发送的Join消息就为JoinIn消息。

#### 2. New消息

New消息的作用和Join消息比较类似，都是用于对属性的声明。不同的是，New消息主要用于MSTP（Multiple Spanning Tree Protocol，多生成树协议）拓扑变化的情况。

·   当MSTP拓扑变化时，MRP实体需要向对端实体发送New消息声明拓扑变化。

·   当一个MRP实体收到来自对端实体的New消息时，它会注册该New消息中的属性，并向本设备的其他实体传播该New消息，其他实体收到传播的New消息后，向其对端实体发送该New消息。

#### 3. Leave消息

当一个MRP实体注销了某些属性，需要对端实体进行同步注销时，它会向对端实体发送Leave消息。

当一个MRP实体收到来自对端实体的Leave消息时，它会注销该Leave消息中的属性，并向本设备的其他实体传播该Leave消息，其他实体收到传播的Leave消息后，根据该Leave消息中的属性在本设备上的状态，决定是否向其对端实体发送该Leave消息（比如该Leave消息中的属性为某VLAN，若该VLAN为动态VLAN，且本设备上无实体注册该VLAN，则在设备上删除该VLAN，并向对端实体发送该Leave消息；若该VLAN为静态VLAN，则不向对端实体发送该Leave消息）。

#### 4. LeaveAll消息

每个MRP实体启动时都会启动各自的LeaveAll定时器，当该定时器超时后，MRP实体就会向对端实体发送LeaveAll消息。

当一个MRP实体收发LeaveAll消息时，它会启动Leave定时器，同时根据自身的属性状态决定是否发送Join消息要求对端实体重新注册某属性。该实体在Leave定时器超时前，重新注册收到的来自对端实体的Join消息中的属性；在Leave定时器超时后，注销所有未重新注册的属性信息，从而周期性地清除网络中的垃圾属性。

## 2.4 MRP定时器

MRP定义了四种定时器，用于控制各种MRP消息的发送。

#### 1. Periodic定时器

每个MRP实体启动时都会启动各自的Periodic定时器，来控制MRP消息的周期发送。该定时器超时前，实体收集需要发送的MRP消息，在该定时器超时后，将所有待发送的MRP消息封装成尽可能少的报文发送出去，这样减少了报文发送数量。随后再重新启动Periodic定时器，开始新一轮的循环。

![说明: 说明](https://resource.h3c.com/cn/201910/25/20191025_4562868_x_Img_x_png_3_1238952_30005_0.png)

Periodic定时器允许用户通过命令行开启或关闭。如果关闭Periodic定时器，则MRP实体不再周期发送MRP消息，仅在LeaveAll定时器超时或收到来自对端实体的LeaveAll消息的情况下会发送MRP消息。

 

#### 2. Join定时器

Join定时器用来控制Join消息的发送。为了保证消息能够可靠地发送到对端实体，MRP实体在发送Join消息时，将启动Join定时器。如果在该定时器超时前收到了来自对端实体的JoinIn消息，且该JoinIn消息中的属性与发出的Join消息中的属性一致，便不再重发该Join消息，否则在该定时器超时后，当Periodic定时器也超时，它将重发一次该Join消息。

#### 3. Leave定时器

Leave定时器用来控制属性的注销。当MRP实体收到来自对端实体的Leave消息（或收发LeaveAll消息）时，将启动Leave定时器。如果在该定时器超时前，收到来自对端实体的Join消息，且该Join消息中的属性与收到的Leave消息中的属性一致（或与收发的LeaveAll消息中的某些属性一致），则这些属性不会在本实体被注销，其他属性则会在该定时器超时后被注销。

#### 4. LeaveAll定时器

每个MRP实体启动时都会启动各自的LeaveAll定时器，当该定时器超时后，该实体就会向对端实体发送LeaveAll消息，随后再重新启动LeaveAll定时器，开始新一轮的循环，对端实体在收到LeaveAll消息后也重新启动LeaveAll定时器。

![说明: 说明](https://resource.h3c.com/cn/201910/25/20191025_4562869_x_Img_x_png_4_1238952_30005_0.png)

LeaveAll定时器具有抑制机制，即当某个MRP实体的LeaveAll定时器超时后，会向对端实体发送LeaveAll消息，对端实体在收到LeaveAll消息时，重启本实体的LeaveAll定时器，从而有效抑制网络中的LeaveAll消息数。为了防止每次都是同一实体的LeaveAll定时超时，每次LeaveAll定时器重启时，LeaveAll定时器的值都将在一定范围内随机变动。

 

## 2.5 MVRP注册模式

MVRP传递的VLAN配置信息既包括本地手工配置的静态信息，也包括来自其他设备的动态信息。MVRP有三种注册模式，不同注册模式对动态VLAN的处理方式有所不同。

·   Normal模式：该模式下的MVRP实体允许进行动态VLAN的注册或注销。

·   Fixed模式：该模式下的MVRP实体禁止进行动态VLAN的注销，收到的MVRP报文会被丢弃。也就是说，在该模式下，实体已经注册的动态VLAN是不会被注销的，同时也不会注册新的动态VLAN。

·   Forbidden模式：该模式下的MVRP实体禁止进行动态VLAN的注册，收到的MVRP报文会被丢弃。同时，将端口的MVRP注册模式配置为Forbidden模式时，该端口上除VLAN1以外所有已注册的动态VLAN将被删除。

## 2.6 运行机制

下面通过一个简单的例子来介绍一下MVRP的工作过程。该例子分四个阶段描述了一个VLAN属性在网络中是如何被注册和注销的。

#### 1. VLAN属性的单向注册机制

图4 VLAN属性的单向注册示意图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562870_x_Img_x_png_5_1238952_30005_0.png)

 

在Device A上创建静态VLAN 2，通过VLAN属性的单向注册，将Device B和Device C的相应端口自动加入VLAN 2：

(1)   在Device A上手工创建静态VLAN 2后，Port 1启动Join定时器和Hold定时器。等待Hold定时器超时后，Device A向Device B发送第一个JoinEmpty消息。Join定时器超时后再次启动Hold定时器，再等待Hold定时器超时后，发送第二个JoinEmpty消息。

(2)   Device B上接收到第一个JoinEmpty消息后创建动态VLAN 2，并把接收到JoinEmpty消息的Port 2加入到动态VLAN 2中，同时告知Port 3启动Join定时器和Hold定时器。等待Hold定时器超时后向Device C发送第一个JoinEmpty消息。Join定时器超时后再次启动Hold定时器，Hold定时器超时之后，发送第二个JoinEmpty消息。Device B上收到第二个JoinEmpty消息后，由于Port 2已经加入动态VLAN 2，所以不作处理。

(3)   Device C上接收到第一个JoinEmpty消息后创建动态VLAN 2，并把接收到JoinEmpty消息的Port 4加入到动态VLAN 2中。Device C上收到第二个JoinEmpty消息后，由于Port 4已经加入动态VLAN 2，所以不作处理。

(4)   此后，每当Leaveall定时器超时或收到LeaveAll消息，设备会重新启动Leaveall定时器、Join定时器、Hold定时器和Leave定时器。Device A的Port 1在Hold定时器超时之后发送第一个JoinEmpty消息，再等待Join定时器+Hold定时器之后，发送第二个JoinEmpty消息，Device B向Device C发送JoinEmpty消息的过程也是如此。

#### 2. VLAN属性的双向注册机制

图5 VLAN属性的双向注册示意图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562871_x_Img_x_png_6_1238952_30005_0.png)

 

通过上述VLAN属性的单向注册过程，端口Port 1、Port 2、Port 4已经加入VLAN 2，但是Port 3还没有加入VLAN 2（只有收到JoinEmpty消息或JoinIn消息的端口才能加入动态VLAN）。为使VLAN 2流量可以双向互通，需要进行Device C到Device A方向的VLAN属性的注册过程：

(1)   VLAN属性的单向注册完成后，在Device C上创建静态VLAN 2（将动态VLAN转换成静态VLAN），Port 4启动Join定时器和Hold定时器，等待Hold定时器超时后，Device C向Device B发送第一个JoinIn消息（因为Port 4已经注册了VLAN 2，所以发送JoinIn消息）。Join定时器超时后再次启动Hold定时器，Hold定时器超时之后，发送第二个JoinIn消息。

(2)   Device B上接收到第一个JoinIn后，把接收到JoinIn消息的Port 3加入到动态VLAN 2中，同时告知Port 2启动Join定时器和Hold定时器。等待Hold定时器超时后，向Device A发送第一个JoinIn消息。Join定时器超时后再次启动Hold定时器，Hold定时器超时之后，发送第二个JoinIn消息。Device B上收到第二个JoinIn后，因为Port 3已经加入动态VLAN 2，所以不作处理。

(3)   Device A上接收到JoinIn之后，停止向Device B发送JoinEmpty消息。此后，当Leaveall定时器超时或收到LeaveAll消息，设备重新启动Leaveall定时器、Join定时器、Hold定时器和Leave定时器。Device A的Port 1在Hold定时器超时之后就开始发送JoinIn消息。

(4)   Device B向Device C发送JoinIn消息。

(5)   Device C收到JoinIn消息后，由于本身已经创建了静态VLAN 2，所以不会再创建动态VLAN 2。

#### 3. VLAN属性的单向注销机制

图6 VLAN属性的单向注销示意图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562872_x_Img_x_png_7_1238952_30005_0.png)

 

当设备上不再需要VLAN 2时，可以通过VLAN属性的注销过程将VLAN 2从设备上删除：

(1)   在Device A上删除静态VLAN 2，Port 1启动Hold定时器，等待Hold定时器超时后，Device A向Device B发送LeaveEmpty消息。LeaveEmpty消息只需发送一次。

(2)   Device B上接收到LeaveEmpty，Port 2启动Leave定时器。等待Leave定时器超时之后Port 2注销VLAN 2，将Port 2从动态VLAN 2中删除（由于此时VLAN 2中还存在端口Port 3，所以不会删除VLAN 2），同时告知Port 3启动Hold定时器和Leave定时器。等待Hold定时器超时后，向Device C发送LeaveIn消息。由于Device C的静态VLAN 2还没有删除，Port 3在Leave定时器超时之前仍然能够收到Port 4发送的JoinIn消息，所以Device A和Device B上仍然能够学习到动态的VLAN 2。

(3)   Device C上接收到LeaveIn后，由于Device C上存在静态VLAN 2，所以Port 4不会从VLAN 2中删除。

#### 4. VLAN属性的双向注销机制

图7 VLAN属性的双向注销示意图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562873_x_Img_x_png_8_1238952_30005_0.png)

 

当需要彻底删除所有设备上的VLAN 2时，可以进行VLAN属性的双向注销：

(1)   在Device C上删除静态VLAN 2，Port 4启动Hold定时器，等待Hold定时器超时后，Device C向Device B发送LeaveEmpty消息。

(2)   Device B接收到LeaveEmpty消息后，Port 3启动Leave定时器，等待Leave定时器超时之后Port 3注销VLAN 2，将Port 3从动态VLAN 2中删除并删除动态VLAN 2，同时告知Port 2启动Hold定时器。等待Hold定时器超时后，向Device A发送LeaveEmpty消息。

(3)   Device A接收到LeaveEmpty消息后，Port 1启动Leave定时器，等待Leave定时器超时之后Port 1注销VLAN 2，将Port 1从动态VLAN 2中删除并删除动态VLAN 2。

## 2.7 应用限制

使用MVRP功能时，需要注意：

·   MVRP功能只能与STP、RSTP或MSTP配合使用，而无法与其他二层网络拓扑协议（如业务环回、PVST、RRPP和Smart Link）在一个端口上同时使用。MVRP报文的收发不受STP/RSTP/MSTP阻塞端口影响。

·   建议不要同时启用远程端口镜像功能和MVRP功能，否则MVRP可能将远程镜像VLAN注册到错误的端口上，导致镜像目的端口会收到很多不必要的报文。

·   在二层聚合接口上启用了MVRP功能后，会同时在二层聚合接口和对应的所有选中成员端口上进行动态VLAN的注册或注销。

·   如果二层以太网接口加入了聚合组，则加入聚合组之前和加入聚合组之后在该接口上进行的MVRP相关配置不会生效，该接口退出聚合组后，MVRP的配置才会生效。

·   在配置MVRP兼容GVRP后，MVRP功能只能与STP或RSTP配合使用，而不能与MSTP配合使用，否则可能会造成网络工作的不正常。

·   在配置MVRP兼容GVRP后，建议关闭Periodic定时器，否则当系统繁忙时，容易造成VLAN状态的频繁改变。

# 3 典型组网应用

MVRP使不同设备上的VLAN信息可以由协议动态维护和更新，用户只需要对少数设备进行VLAN配置即可应用到整个交换网络，无需耗费大量时间进行拓扑分析和配置管理。

[图8](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/MVRP_White_Paper-6W100/?CHID=949093#_Ref16582519)中所有设备都开启MVRP功能，设备之间相连的端口均为Trunk端口，并允许所有VLAN通过。只需在Device A和Device G上分别手工配置静态VLAN 100～VLAN 1000，那么，设备Device B～Device F就可以通过MVRP协议学习到这些VLAN，最后各设备上都存在VLAN 100～VLAN 1000。

图8 典型组网应用

![img](https://resource.h3c.com/cn/201910/25/20191025_4562874_x_Img_x_png_9_1238952_30005_0.png)