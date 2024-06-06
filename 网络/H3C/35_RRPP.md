概述

1.1  

产生背景

在实际的网络规划和组网应用中，大多采用环网来提供高可靠性。环网技术简单来说，就是将一

些网络设备通过环的形状连接到一起，实现相互通信的一种技术。

为了避免环网中产生广播风暴，最初

采用了已被普遍应用的

STP

协议环路保护机制。但实际应用

中

STP

协议的收敛时间受网络拓扑的影响，在网络直径较大时收敛时间较长，因而往往不能满足

传输质量较高的数据的要求。

为了缩短环网的收敛时间并

消除网络大小的影响，

H3C

开发了专门应用于环网保护的

RRPP

（

Rapid Ring Protection Protocol

，快速环网保护协议）协议。

1.2  

技术优点

RRPP

是一个专门应用于以太网环的链路层协议。它在以太网环完整时能够防止数据环路引起的

广播风暴，而当以太网环上的

链路断开时能迅速启用备份链路恢复环网上各个节点之间的通信链

路。与

STP

协议相比，

RRPP

协议有如下优点：

•

拓扑收敛速度快（低于

50ms

）

•

收敛时间与环网上节点数无关，可应用于网络直径较大的网络

H3C

所实现的

RRPP

协议还有如下特点：

•

在相交环拓扑中，一个环拓扑的变化不会引起其他环的拓扑振荡，数据传输更为稳定。

•

支持

RRPP

环网的负载分担，充分利用了物理链路的带宽。

2  

RRPP

技术实现

2.1  

RRPP

组成要素

2.1.1  

RRPP

域

RRPP

域用于标识

RRPP

协议所计算和控制的拓扑范围。

域

ID

是

RRPP

域的唯一标识，一个

RRPP

域由具有相同域

ID

和控制

VLAN

、且相互连通的设备构成。一台设备上可以创建多个

RRPP

域。

一个

RRPP

域具有如下的组成要素：

•

RRPP

环

•

RRPP

控制

VLAN

•

RRPP

保护

VLAN

•

主节点

•

传输节点

•

边缘节点

•

辅助边缘节点

2 

如图

1

所示

Domain 1

就是一个

RRPP

域，

S1

～

S6

的设备都属于

Domain 1

。

Domain 1

的主控制

VLAN

和子控制

VLAN

分别为

VLAN  3

和

VLAN  4

，域中包含两个

RRPP

环，分别为

Ring 

1

和

Ring  2

。主环的主节点为

S1

，子环的主节点为

S6

。

S2

、

S3

和

S4

都是主环的传输节点，

S5

是子

环的传输节点。

S3

和

S2

分别为边缘节点和辅助边缘节点。

图

1

RRPP

组网示意图

2.1.2  

RRPP

环

每一个

RRPP

环物理上对应一个环形连接的以太网拓扑，

RRPP

环由整数表示的

ID

来标识。每个

RRPP

环都是其所在的

RRPP

域的一个局部单元。实际上

RRPP

协议是按

RRPP

环进行拓扑计算。

环形物理拓扑常见的三种组网形式为：单环、相交环和

相切环。组网形式不同，划分

RRPP

域的

方案也不同：

•

单环上的所有设备要配置在相同的

RRPP

域中；

•

相交环上的所有设备也要配置在相同的

RRPP

域中；

•

相切的两个环，每个环上的设备要配置在相同的

RRPP

域中，即相切环相当于两个单环，需

要配置两个

RRPP

域，每个

RRPP

域中只有一个环。

在相交环组网的

RRPP

域中为了各环的拓扑计算不相互干扰，并且所有环都不出现环路，需要区

分出一个为主环，其他环为子环。

主环可以作为一个整体抽象成子环的一个逻辑节点，子环的

协

议报文通过主环透传，可以对两个相交环形成的大环的拓扑进行计算；主环的协议报文只在主环

内部传播，不进入子环。主环和子环通过配置时指定的级别来标识，主环的级别配置为

0

，子环的

级别配置为

1

。

如图

1

所示

RRPP

域

Domain 1

中包含了两个相交的以太网环

Ring 1

和

Ring 2

。把

Ring 1

配置为

该域的主环，

Ring 2

配置为该域的子环。这样

Ring 1

和

Ring 2

就会分别计算出一个无环路的拓扑，

从而消除了组网中的环路并保证了各节点的全连通性。

S

1

3

S2

S

3

S4

S5

S6

4

4

3

3

4

3

4

4

4

4

3

4

3

4

4

4

4

4

4

3

3

S

P

P

S

Master

Edge

Assistant

Master

Ring 

1

Ring 

2

Domain 

1

B

B

B

P

\-

Primary Port

\- 

Secondary Port

\- Blocked Port

RRPP Domain Outline

Major Ctrl VLAN

: 

3

Sub Ctrl VLAN

: 4

S

3 

2.1.3  

控制

VLAN

控制

VLA

N

用来传递

RRPP

协议报文。每个

RRPP

域都有两个控制

VLAN

：主控制

VLAN

和子控

制

VLAN

。主环的控制

VLAN

简称主控制

VLAN

，子环的控制

VLAN

简称子控制

VLAN

。配置时只

需指定主控制

VLAN

，系统会自动将主控制

VLAN

的

VLAN  ID

＋

1

作为子控制

VLAN

。同一

RRPP

域中所有子环的控制

VLAN

都相同，且主控制

VLAN

和子控制

VLAN

的接口上都不允许配

置

IP

地址。主环协议报文和子环

Edge

-Hello

报文在主控制

VLAN

中传播，其它的

子环协议报文在

子控制

VLAN

中传播。

每个设备上接入

RRPP

环的端口都属于控制

VLAN

，而且也只有接入

RRPP

环上的端口可以加入

控制

VLAN

。如图

1

上每个端口旁边的数字

3

和

4

所示，主环的

RRPP

端口既要属于主控制

VLAN

，同时也要属于子控制

VLAN

；子环的

RRPP

端口只属于子控制

VLAN

。

2.1.4  

保护

VLAN

保护

VLAN

是用来传递数据报文的

VLAN

。保护

VLAN

中可以包含

RRPP

端口，也可以包含非

RRPP

端口。保护

VLAN

的转发状态由其所对应的

RRPP

域控制。同一环网上不同的

RRPP

域配

置不同的保护

VLAN

，各

RRPP

域分别独立计算自己环上端口的转发状态。

2.1.5  

主节点

以太网环上每一台设备都称为一个

RRPP

节点，每个

RRPP

环上必须有一个主节点，而且只能有

一个，如图

1

中的

S1

是主环的主节点，

S6

是子环的主节点。主节点是环网状态主动检测机制的

发起者，也是检测到

RRPP

环故障后执行操作的决策者。

主节点有如下两种状态：

•

Complete State

（健康状态）

当环网上所有的链路都处于

UP

状态，主节点可以从副端口收到自己发送的

Hello

报文时，

主节点处于

Complete

状态，此时主节点会阻塞副端口以防止数据报文在环形拓扑上形成广

播环路。

•

Failed State

（断裂状态）

当环网上有链路处于断裂状态时，主节点处于

Failed

状态，此时主节点的副端口放开对数据

报文的阻塞，以保证环网上的通信不中断。

主节点的状态代表了整个

RRPP

环的状态。即，主节点处于

Complete

（

Failed

）状态时，

RRPP

环也处于

Complete

（

Failed

）   状态。

2.1.6  

传输节点

RRPP

环上除主节点外的所有其它节点是传输节点，如图

1

中的

S2

、

S3

和

S4

是主环的传输节点，

S5

是子环的传输节点。传输节点负责透传主节点的

Hello

报文，并监测自己的直连

RRPP

链路的

状态，把链路

DOWN

事件通知主节点。

传输节点有如下

3

种状态：

4 

•

Link

-Up State

（

UP

状态）

传输节点的主端口和副端口都处于

UP

状态时，传输节点处于

Link

-Up

状态。

•

Link

-Down State

（

Down

状态）

传输节点的主端口或副端口处于

Down

状态时，传输节点处于

Link

-Down

状态。

•

Pre-

forwarding State

（临时阻塞状态）

传输节点的主端口或副端口处于阻塞状态时，传输节点处于

Pre-

forwarding

状态。

2.1.7  

边缘节点和辅助边缘节点

子环和主环相交时有两个交点，这两个交点处的设备其中一个叫做边缘节点，另外一个叫做辅助

边缘节点。边缘节点与辅助边缘节点必须成对配置。如图

1

所示，

S3

为边缘节点，

S2

为辅助边缘

节点。

边缘节点或辅助边缘节点是设备在子环上的角色，其在主环上的角色为主节点或传输节点。

边缘节点和辅助边缘节点都是特殊的传输节点，因此具有与传输节点相同的

3

种状态，但定义

稍

有不同，具体如下：

•

Link

-Up State

（

UP

状态）

边缘端口处于

UP

状态时，边缘节点（辅助边缘节点）处于

Link

-Up

状态。

•

Link

-Down State

（

Down

状态）

边缘端口处于

Down

状态时，边缘节点（辅助边缘节点）处于

Link

-Down

状态。

•

Pre-

forwarding State

（临时阻塞状态）

边缘端口处于阻塞状态时，边缘节点（辅助边缘节点）处于

Pre-

forwarding

状态。

2.1.8  

主端口和副端口

主节点和传输节点接入以太网环的两个端口中，一个为主端口，另一个为副端口，端口的角色由

用户的配置决定。

主节点的主端口和副端口在功能上是有区别的。主节点从其主端口发送

Hello

报文，如果能够从副

端口收到该报文，说明本节点所在

RRPP

环网处于健康状态，因此需要阻塞副端口以防止数据环

路；相反如果在规定时间内收不到该

报文，说明环网故障，此时需要放开副端口以保证环上所有

节点的正常通信。

传输节点的主端口和副端口在功能上没有区别。端口的角色同样由用户的配置决定。

RRPP

协议理论上把主环看作是子环的一个逻辑节点，子环的协议报文通过主环透传，主环

将子

环的协议报文（除了

Edge

-Hello

报文）视为数据报文。因此，当主环上的端口被阻塞时，数据报

文和子环协议报文（除了

Edge-

Hello

报文）都不能通过。

2.1.9  

公共端口和边缘端口

边缘节点（辅助边缘节点）接入子环的端口为边缘端口，接入主环的两个端口为公共端口，边缘

节点上公共端口与辅助边缘节点上公共端口之间的链路被称为公共链路。

公共端口和边缘端口的

角色由用户的配置决定。

RRPP

协议理论上将整个主环看作是子环上的一个逻辑节点，从而公共链路被看成是主环这个大

节点的内部链路，链路的状态变化只通知主环主节点进行处理。

5 

如图

1

所示，在边缘节点

S3

上，与

S6

相连的端口为边缘端口、与

S4

和

S2

分别相连的两个端口

为公共端口。边缘节点

S3

与辅助边缘节点

S2

相连的链路为公共链路。

2.2  

RRPP

协议报文

2.2.1  

RRPP

协议报文类型

表

1

RRPP

协议报文类型列表

报文类型

说明

Hello

也称

He

alth

报文，由主节点发起，对网络进行环路完整性检测

Fast

-Hello

应用于快速检测机制中，由主节点发起，对网络进行环路完整性快速检测

Link

-Down

由传输节点、边缘节点或者辅助边缘节点发起，在这些节点的自身端口

down

时向主

节点通知环路断裂

Common-Flush-FDB

由主节点发起，在

RRPP

环迁移到断裂状态时通知传输节点、边缘节点和辅助边缘

节点更新各自

MAC

地址表项和

ARP/ND

表项。

FDB

是

Forwarding Database

（转发数

据库）的缩写

Com

plete-Flush-FDB

由主节点发起，在

RRPP

环迁移到健康状态时通知传输节点、边缘节点和辅助边缘

节点更新各自

MAC

地址表项和

ARP/ND

表项，同时通知传输节点解除临时阻塞端口

的阻塞状态

Edge-

Hello

由边缘节点发起并由辅助边缘节点接收，对边缘节点与辅助边缘节点之间的主环链

路进行检测

Fast

-Edge-Hello

应用于快速检测机制中，

由边缘节点发起，对边缘节点与辅助边缘节点之间的主环

链路进行快速检测

Major

-Fault

由辅助边缘节点发起，在

辅助边缘节点与边缘节点之间的主环链路不连通时，向边

缘节点报告主环链路故障

6 

2.2.2  

RRPP

协议报文格式

图

2

RRPP

协议报文格式

协议报文各字段的含义如下：

•

Destination MAC Address

：

48bits

，

RRPP

协议报文目的

MAC

地址，范围为

0x000FE2078217

～

0x

000FE2078416

。

•

Source Mac Address

：

48bits

，

RRPP

协议报文的源

MAC

地址，固定为

0x000fe203fd75

。

•

EtherType

：

8bits

，报文封装类型域，固定为

0x8100

，表示

Tagged

封装。

•

PRI

：

4bits

，

COS

（

Class of Service

）优先级，固定为

0xe0

。

•

VLAN ID

：

12bits

，报文所在

VLAN

的

ID

。

•

Frame Length

：

16bits

，以太网帧的长度，固定为

0x48

。

•

DSAP/SSAP

：

16bits

，目的服务访问点

/

源服务访问点，固定为

0xaaaa

。

•

CONTROL

：

8bits

，固定为

0x03

。

•

OUI

：

24bits

，固定为

0x00e02b

。

•

RRPP

 Length

：

16bits

，

RRPP

协议数据单元长度，固定为

0x40

。

•

RRPP

_VER

：

16bits

，

RRPP

版本信息，当前版本为

0x0001

。

•

RRPP

 Type

：

8bits

，

RRPP

协议报文的类型。

5

表示

Hello

报文；

6

表示

Com

plete-

Flush

\-

FDB

报文；

7

表示

Common-

Flush

-FDB

报文；

8

表示

Link

-Down

报文；

10

表示

Edge-

Hello

报文；

11

表示

Major

-Fault

报文。

•

Domain 

ID

：

16bits

，报文所属

RRPP

域的

ID

。

•

Ring 

ID

：

16bits

，报文所属

RRPP

环的

ID

。

•

SYSTEM_MAC_ADDR

：

48bits

，发送报文节点的桥

MAC

。

0

7

Destination MAC Address 

(6 bytes

)

15

23

31

39

47

Source MAC Address 

(6 bytes

)

EtherType

PRI

VLAN ID 

Frame Length

DSAP

/SSAP

0x00

bb

CONTROL

OUI 

= 0x00

e02

b

0x99

0x0b

RRPP Length

RRPP

_VER

RRPP

 T

ype

Ring ID

Domain ID

0x0000

SYSTEM

_MAC

_ADDR 

(6 bytes

)

HELLO

_TIMER

FAIL

_TIMER

0x0000

0x0000

0x00

LEVEL

RESERVED

(0x000000000000

)

RESERVED

(0x000000000000

)

RESERVED

(0x000000000000

)

RESERVED

(0x000000000000

)

RESERVED

(0x000000000000

)

RESERVED

(0x000000000000

)

7 

•

HELLO_TIMER

：

16bits

，发送报文节点使用的

Hello

定时器的超时时间，单位为秒。

•

FAIL_TIMER

：

16bits

，发送报文节点使用的

Fail

定时器的超时时间，单位为秒。

•

LEVEL

：

8bits

，报文所属

RRPP

环的级别。

2.3  

单环工作原理

2.3.1  

单环检测及故障恢复机制

1. 

环网健康检测及处理机制

主节点通过轮询机制来主动检测环网状态并进行相应处理：主节点周期性地从主端口发送

Hello

报

文，依次经过各传输节点在环上传播。如果环网上所有链路都处于

UP

状态，则主节点能够从副端

口收到自己发送的

Hello

报文，说明环网处于健康状态。为了防止环上的数据报文形成广播环路，

主节点阻塞其副端口。环网完整时的情况如图

3

所示。

图

3

完整状态下的

RRPP

环

2. 

环网故障检测及处理机制

环网故障可以通过轮询机制和

Link Down

通知机制两种方式检测出来：

•

轮询机制

主节点通过轮询机制主动检测环网状态：主节点周期性的从其主端口发送

Hello

报文，依次

经过各传输节点在环上传播。如果主节点在规定时间内收不到自己发送的

Hello

报文，认为

环网发生链路故障。主节点将状态切换到

Failed

状态，放开副端口，并从主、副端口发送

Common-

Flush

-FDB

报文通知环上所有传输节点刷新

MAC

表项和

ARP/ND

表项。

•

Link Down

通知机制



当主节点主端口

Down

后，主节点直接感知链路故障，立即放开副端口，并从副端口发送

Common

-Flush

-FDB

报文通知环上所有传输节点刷新

MAC

表项和

ARP/ND

表项。

Data Packet

Control Packet

S

P

Master

Hello

B

P

\- Primary Port

\- Secondary Port

\-

 Blocked Port

S

B

Single Ring Complete state

Complete state

S port blocked

8 



当传输节点上的

RRPP

端口发生链路

DOWN

时，该节点将从与故障端口配对的状态为

UP

的

RRPP

端口发送

Link

-Down

报文通知主节点（

Link

-Down

上报过程如图

4

所示）。

主节点收到

Link

-Down

报文后，放开副端口，立即将状态切换到

Failed

状态。由于网络

拓扑发生改变，为避免报文定向错误，主节点还需要刷新

MAC

表项和

ARP/ND

表项，并

从主、副端口发送

Common-

Flush

-FDB

报文通知所有传输节点刷新

MAC

表项和

ARP/ND

表项（主节点状态向

Failed

状态迁移过程如图

5

所示）。

图

4

传输节点链路中断上报示意图

Data Packet

Control Packet

S

P

Master

Link

\-

Down

B

P

\- Primary Port

\- 

Secondary Port

\- Blocked Port

S

B

Transit Send LINK

-DOWN to Master

Link failure

9 

图

5

主节点向

Failed

状态迁移过程示意图

Link  Down

通知机制提供了比轮询机制更快的环网故障处理机制，但是，如果

Link

-Down

报文在

传输过程中不幸丢失时，这时主节点的轮询机制就派上了用场。如果主节点在规定时间内（这一

时间由

Fail

定时器定义）仍没有在副端口收到自己的

Hello

报文，则认为环网发生故障，对故障的

处理过程与传输节点主动上报完全相同。

3. 

环网故障恢复检测及处理机制

传输节点端口恢复的瞬间，主节点无法立刻感知到此信息，因此其副端口还处于放开状态。这时

如果传输节点立即迁移回

Link

-Up

状态，势必造成数据报文在环网上形成瞬时环路，因此处于

Link

-Down

状态的传输节点的主、副端口都恢复时，传输节点立即阻塞刚刚恢复的端口，迁移到

Pre-

forwarding

状态。传输节点端口恢复时的处理过程如图

6

所示。此时整个环网并没有恢复，环

网恢复的过程是由主节点主动发起的。

Data Packet

Control Packet

S

P

Master

B

P

\- Primary Port

\- Secondary Port

\- Blocked Port

S

Master Transfer to Failed State

Transfer to Failed State

Unblock S port 

Common-Flush-FDB

10

图

6

传输节点链路恢复处理过程示意图

环上所有链路恢复正常后，当处于

Failed

状态的主节点重新收到自己发出的

Hello

报文，将

阻塞

副端口，将状态迁移回

Complete

状态。由于

RRPP

环拓扑已经改变，主节点要刷新

MAC

表项和

ARP/ND

表项，并从主端口

发送

Com

plete-

Flush

-FDB

报文通知所有传输节点刷新

MAC

表项和

ARP/ND

表项。处于

Pre-

forwarding

状态的传输节点收到主节点发送的

Com

plete

-Flush

-FDB

报文

时，迁移到

Link

-Up

状态，这样整个环网就恢复完成了。环网恢复的处理过程如图

7

所示。

图

7

环网恢复示意图

Data Packet

Control Packet

S

P

Master

B

P

\- Primary Port

\- Secondary Port

\- Blocked Port

S

Transit block restored port temporarily

at Failed State

B

B

Transfer to preforwarding 

state & block restored port

Data Packet

Control Packet

S

P

Master

Complete

-Flush

\-

FDB

B

P

\- Primary Port

\- 

Secondary Port

\- 

Blocked Port

S

B

Master transfer to Complete state

Transfer to Link

-Up State

 & 

Unblock port

Transfer to Complete state 

& 

block S port

11

如果

Com

plete-

Flush

-FDB

报文在传播过程中丢失，还有一种备份机制来实现传输节点临时阻塞端

口的恢复。传输节点处于

Pre-

forwarding

状态时，如果在规定时间内（这一时间由

Fail

定时器定

义）收不到主节点发来的

Com

plete

-Flush

-FDB

报文，自行放开临时阻塞端口，并刷新本节点

MAC

表项和

ARP/ND

表项，恢复数据通信。

2.3.2  

单环负载分担

在同一个环网中，如果同时存在多个

VLAN

的数据流量，可以在同一个环网上配置多个

RRPP

域，

不同

RRPP

域转发不同

VLAN

（称之为保护

VLAN

）的流量，实现不同

VLAN

的数据流量在该环

网中有不同的转发路径，从而达到负载分担的目的。

图

8

单环负载分担组网

如图

8

所示，

Domain  1

和

Domain  2

都配置

Ring  1

为主环，两个

RRPP

域保护的

VLAN

不同。

Domain 1

的

Ring 1

配置

Device 

A

为主节点；

Domain 2

的

Ring 1

配置

Device 

B

为主节点。通过

配置，可以实现不同

VLAN

分别阻塞不同的链路，从而实现单环的负载分担。

2.4  

相交环工作原理

2.4.1  

相交环检测机制

相交环实现方式中，主环的实现原理与单环相同，子环主节点的检测机制亦与单环相同。不同之

处在于多环引入了

SRPT

（

Sub 

Ring  P

acket

 Tunnel  in  major  ring

，子环协议报文在主环中的通道）

检查机制，在子环的

2

条

SRPT

全部中断，子环主节点副端口放开之前，先阻塞边缘节点的边缘

端口，以此来防止子环间形成数据广播环路。

关于

SRPT

检查机制的详细介绍请

参见

“

2.4.3  

SRPT

状态检测原理”。

另外，主环节点收到子环的

Common

-Flush

-FDB

或者

Com

plete-

Flush

-FDB

报文时，都需要刷新

MAC

表项和

ARP/ND

表项；子环的

Com

plete

-Flush

-FDB

不会导致主环传输节点放开临时阻塞端

口。

Device A

Device B

Device C

Device D

Domain 

1

Ring 

1

Domain 

2

12

图

9

相交环组网

2.4.2  

相交环负载分担

在同一相交环组网中，如果同时存在多个

VLAN

的数据流量，可以在同一相交环组网上配置多个

RRPP

域（每个

RRPP

域的工作原理同相交环工作原理）

，不同

RRPP

域转发不同保护

VLAN

的

流量，实现不同

VLAN

的流量在该环网中有不同的转发路径，从而达到负载分担的目的。

图

10

相交环负载分担组网

如图

10

所示，

D

omain  1

和

Domain  2

分别配置

Ring  1

和

Ring  2

为主环和子环，两个域保护的

VLAN

不同。

D

omain 1

的

Ring 1

配置

Device A

为主节点；

Domain 2

的

Ring 1

配置

Device 

D

为

主节点，

Domain  1

和

Domain  2

的

Ring  2

都配置

Device  E

为子环主节点，但主副端口配成不同

的。通过配置，可以使不同

VLAN

的流量通过不同的链路传输，从而实现相交环的负载分担。

Device A

Device B

Device C

Device D

Device E

Edge node

Master node

Transit node

Assistant edge node

Domain 

1

Ring 

1

Ring 

2

Master node

Device A

Device B

Device C

Device D

Device E

Ring 

1

Ring 

2

Domain 

1

Domain 

2

13

2.4.3  

SRPT

状态检测原理

1. 

SRPT

状态检测机制产生背景

SRPT

是子环协议报文在主环中的通道。

RRPP

协议理论上把主环看作是子环的一个逻辑节点，子

环的协议报文通过主环透传，主环

将子环的协议报文（除了

Edge-

Hello

报文）当作数据报文

进行

转发。

每个子环有

2

条

SRPT

，在图

1

中分别为

S3

-S2

和

S3

-S4

-S1

-S2

。在主环完整时，其主节点副端

口处于阻塞状态，只有

S3

-S2

是通的。主环故障时，如果故障发生在

S3

-S4

-S1

-S2

上，则

S3

-S2

是通的；如果故障发生在

S3

-S2

上，则

S3

-S4

-S1

-S2

是通的；因此，在任意时刻，子环的

2

条

SRPT

中，最多只有

1

条是通的，这样就避免了子环协议报文在主环中形成数据环路。如果子环的

2

条

SRPT

全部中断时，子环主节点收不到自己发出的

Hello

报文，于是

Fail

定时器超时，子环主

节点放开副端口，这样子环可以获得最大的通信通路，且不会形成环路。

但对于图

11

所示的在实际应用中采用较多的双归属组网中，双归属的两个子环

Ring  2

和

Ring  3

借助边缘节点和辅助边缘节点相互连接，本身就形成了一个环路。当主环

Ring  1

上子环的

2

条

SRPT

全部中断后，所有子环的主节点副端口放开，子环之间势必形成数据环路（数据报文走向如

箭头所示）。

图

11

多环组网

SRPT

故障时子环间数据环路示意图

为了消除这一缺陷，引入了

SRPT

状态检查机制。由边缘节点和辅助边缘节点配合完成

SRPT

的

状态检查，

当边缘节点检测到

SRPT

中断后，

在两个子环主节点副端口全部放开之前，阻塞两子

环边缘节点的边缘端口，避免子环间形成数据环路。主环

SRPT

故障后保护

机制产生作用效果如

图

12

所示。

S1

S2

S3

S4

S5

S6

S

P

S

Master

Master

Ring 

1

Ring 

3

P

\- 

Primary Port

\- Secondary Port

Master

Ring 

2

P

S

14

图

12

多环

SRPT

状态检查机制结果示意图

2. 

SRPT

状态检测机制工作过程

边缘节点是检查活动的发起者和决策者，辅助边缘节点是通道状态的监听者，并负责在通道状态

改变时及时通知边缘节点。整个机制的过程描述如下。

(1)

检查

SRPT

状态

子环的边缘节点通过连入

SRPT

的两个端口周期性向主环内发送

Edge-

Hello

报文，依次经

过环上各节点发往辅助边缘节点，如图

13

所示。

如果辅助边缘节点在规定时间内能够收到

Edge-

Hello

报文，表明至少有

1

条

SRPT

正常，

子环报文可以正常通过。反之，辅助边缘节点如果收不到

Edge-

Hello

报文，说明

2

条

SRPT

全部中断，子环报文无法通过。

S1

S2

S3

S4

S5

S6

S

P

S

Master

Master

Ring 

1

Ring 

3

P

\- Primary Port

\- Secondary Port

Master

Ring 

2

P

S

B

B

15

图

13

边缘节点发送

Edge-

Hello

报文

(2)

SRPT

中断，阻塞边缘节点的边缘端口

辅助边缘节点检测到

2

条

SRPT

全部中断后，立即从边缘端口通过子环链路向边缘节点发送

Major

-Fault

报文。如果此时子环上无故障，边缘节点能够收到

Major

-Fault

，立即阻塞自己

的边缘端口，如图

14

所示；如果子环上存在故障，边缘节点的边缘端口不会被阻塞。

Major

-Fault

报文是周期性发送的，如果边缘节点收到，其边缘端口继续阻塞；如果在规定时

间内收不到报文，边缘端口自行放开。

图

14

边缘节点响应

Major-

Fault

报文阻塞边缘端口示意图

(3)

子环故障，状态迁移到

Failed

Data Packet

Control Packet

S

P

P

S

Master

Edge

Assistant

Master

Major ring

Sub ring

Edge

-Hello

B

B

B

P

\- 

Primary Port

\- 

Secondary Port

\-

 Blocked Port

S

Data Packet

Control Packet

S

P

P

S

Master

Edge

Assistant

Master

Major ring

Sub ring

Major

-Fault

B

B

P

\- Primary Port

\- Secondary Port

\- Blocked Port

S

B

16

由于子环的两条

SRPT

全部中断，因此子环协议报文无法在主环中透传，主节点收不到自己

发出的

Hello

报文，于是，放开副端口，迁移到

Failed

状态。如图

15

所示。

图

15

单环负载分担主环通道中断导致子环

Failed

示意图

(4)

SRPT

恢复

主环故障恢复的同时，子环的

SRPT

得到恢复，辅助边缘节点不再报告

Major

-Fault

报文。

如果子环本身没有故障，其主节点重新收到自己发出的

Hello

报文，于是阻塞副端口，切换

到

Complete

状态，如图

16

所示。

图

16

子环协议通道恢复示意图

Data Packet

Control Packet

S

P

P

S

Master

Edge

Assistant

Master

Major ring

Sub ring

B

P

\- Primary Port

\- Secondary Port

\- Blocked Port

S

B

Data Packet

Control Packet

S

P

P

S

Master

Edge

Assistant

Master

Major ring

Sub ring

Hello

B

B

P

\- Primary Port

\- Secondary Port

\- Blocked Port

S

B

17

子环恢复后，主节点会从主端口发送

Com

plete

-Flush

-FDB

报文。边缘节点收到报文后，如

果其边缘端口处于阻塞状态，立即放开边缘端口，全网通信恢复。如图

17

所示。

图

17

子环边缘节点放开边缘端口示意图

SRPT

恢复时，如果此时子环存在故障，则子环无法恢复。此种情况下子环主节点不会发送

Com

plete-

Flush-

FDB

报文，如果边缘节点的边缘端口处于阻塞状态，该端口只能在

Fail

定

时器超时后自行放开。

3. 

环组机制

在

SRPT

状态检查过程中，子环边缘节点和辅助边缘节点分别要持续频繁地发送和接收

Edge-

Hello

报文。如图

11

所示的多个子环双归属的组网中，如果分别配置

S2

和

S3

为

Ring  2

和

Ring3

的边缘节点和辅助边缘节点。

S2

上

Ring  2

和

Ring 

3

都需要频繁发送

Edge

-Hello

报文，而

S3

上

Ring  2

和

Ring3

都需要频繁接收

Edge

-Hello

报文。如果配置更多的子环，将会收发大量的

Edge

\-

Hello

报文，势必增加设备

CPU

的负荷。

为了减少

Edge

-Hello

报文的收发数量，引入了环组机制。在边缘节点或辅助边缘节点上配置的一

组子环的集合作为一个环组。在边缘节点上配置的环组称为边缘节点环组，在辅助边缘节点上配

置的环组称为辅助边缘节点环组。在边缘节点配置的环组内，只有域

ID

和环

ID

最小的激活子环

才发送

Edge

-Hello

报文。在辅助边缘节点环组内，任意激活子环收到

Edge

-Hello

报文会通知给其

它激活子环。这样在边缘节点和

辅助边缘节点上分别配置

对应的环组后，只有一个子环发送

/

接收

Edge

-Hello

报文，从而减少了对设备

CPU

的冲击。

需要注意的是，环组中所有子环的边缘节点必须都配置在同一台设备上、

辅助边缘节点也都必须

配置在同一台设备上，而且这些子环的

SRPT

必须相同。

Data Packet

Control Packet

S

P

P

S

Master

Edge

Assistant

Master

Major ring

Sub ring

Complete

\-

Flush

-FDB

B

B

P

\- 

Primary Port

\-

 Secondary Port

\-

Blocked Port

S

18

2.5  

快速检测机制

要实现快速检测功能，要求

RRPP

环的主节点、边缘节点和辅助边缘节点都支持快速检测机制。

RRPP

的快速收敛依赖于传输节点能够快速检测到链路故障，并立即发出通知。而在

RRPP

的实

际运用中，环网中的某些设备并不支持

RRPP

协议，由于无法感知到这些设备之间的链路故障，

RRPP

只能通过超时机制进行链路切换，但这将导致流量中断时间过长，不能达到用户毫秒级切

换的需要。

RRPP

快速检测机制可以解决上述问题。在配置了快速检测功能之后，当

RRPP

在检测以太网环

的链路状况时：

•

主节点会以

Fast

-Hello

定时器周期性地从主端口发送

Fast

-Hello

报文：在

Fast

-Fail

定时器超

时前，若其副端口收到了该报文，就认为环路处于健康状态；否则，认为环路处于断裂状态。

•

边缘节点会以最高精度定时器周期性地从公共端口发送

Fast

-Edge

-Hello

报文：在三倍于最

高精度定时器值的时间间隔内，若辅助边缘节点没有收到该报文，就认为子环在主环上的传

输通道处于断裂状态。

2.6  

防抖动机制

RRPP

端口状态不稳定或者丢包导致超时的情况下，环网状态会在

Complete

和

Failed

之间来回

切换，导致

RRPP

环流量转发路径频繁变化，导致丢包过多，可以通过配置

Linkup-

Delay

来避免

该情况的发生。

配置

Linkup-

Delay

定时器但未开启扩散功能，当

RRPP

链路的故障端口变为

UP

状态，且主节点

从副端口收到

Hello

报文时，主节点会启动

Linkup-

Delay

定时器，此时：

•

若在

Linkup-

Delay

定时器超时后主节点依然能够从副端口收到

Hello

报文，则主节点才会切

换

RRPP

环的断裂状态到健康状态，将从副端口转发的流量切换至主端口进行转发。

•

若在

Linkup-

Delay

定时器超时前，及在

Fail

定时器超时后主节点未能从副端口收到

Hello

报

文，则主节点停止

Linkup-

Delay

定时器且保持

RRPP

环处于断裂状态。

配置

Linkup-

Delay

定时器和开启扩散功能，

RRPP

域中所有节点会通过收到的

Hello

报文学习到

Linkup

-Delay

定时器的值。当

RRPP

链路的故障端口变为

UP

状态时，该端口所在

RRPP

节点设

备会临时阻塞该端口（数据报文和协议报文均不能收发），并启动

Linkup-

Delay

定时器，此时：

•

若在

Linkup

-Delay

定时器超时后该端口没有发生故障，则该节点设备恢复该端口为

UP

状态。

从而使得主节点发送

Hello

报文能通过该端口转发至主节点的副端口，然后主节点立即切换

RRPP

环的断裂状态到健康状态，将从副端口转发的流量切换至主端口进行转发。

•

若在

Linkup-

Delay

定时器超时前，该端口又发生故障，则阻塞该端口，所在节点设备停止

Linkup-

Delay

定时器。

19

3  

典型组网应用

3.1  

单环

图

18

单环典型组网

物理网络拓扑中只有一个环，此时可以定义一个

RRPP

域和一个

RRPP

环。

这种组网的特征是拓扑改变时反应速度快，收敛时间短。

3.2  

单环负载分担

图

19

单环负载分担典型组网

物理网络拓扑中只有一个环，

但同时存在多个

VLAN

的数据流量，

为了实现负载分担，可以在物

理拓扑环上定义多个

RRPP

域，每个

RRPP

域的保护

VLAN

不同，并且不同

RRPP

域的

RRPP

环的主节点不同或主节点相同而主副端口不同，从而实现不同

RRPP

域的保护

VLAN

有不同的逻

辑拓扑。

Device A

Device B

Device C

Device D

Master node

Transit node

Domain 

1

Ring 

1

Transit node

Transit node

Device A

Device B

Device C

Device D

Domain 

1

Ring 

1

Domain 

2

20

3.3  

相切环

图

20

相切环典型组网

物理网络拓扑中有两个及两个以上的环，

但是各个环之间只有一个公共节点。此时每个环要配置

成属于不同的

RRPP

域。

当网络规模较大，同级网络需要分区域管理时，可以采用这种组网。

3.4  

相交环

图

21

相交环典型组网

物理网络拓扑中有两个及两个以上的环，

但是各个环之间有两个公共节点。此时可以只定义一个

RRPP

域，选择其中一个环为主环，其他环为子环。

Ring 

1

Device A

Device B

Device C

Device E

Master node

Domain 

1

Transit node

Device D

Transit node

Transit node

Ring 

2

Device F

Master node

Transit node

Domain 

2

Device A

Device B

Device C

Device D

Device E

Edge node

Master node

Transit node

Assistant edge node

Domain 

1

Ring 

1

Ring 

2

Master node

21

这种组网最典型的应用就是子环主节点可以通过边缘节点和辅助边缘节点双归属上行，提供上行

链路备份。

3.5  

相交环负载分担

图

22

相交环负载分担典型组网

物理网络拓扑中有两个及两个以上的环，

但是各个环之间有两个公共节点。如果网络中存在多个

VLAN

的数据流量，为了实现负载分担，可以定义多个

RRPP

域，每个

RRPP

域的保护

VLAN

不

同，并且不同

RRPP

域的

RRPP

环的主节点不同或主节点相同而主副端口不同，从而实现不同

RRPP

域的保护

VLAN

有不同的逻辑拓扑。

3.6  

RRPP

与

STP

混合组网

RRPP

协议与

STP

协议在端口上使能是互斥的，这是为了避免

RRPP

与

STP

在计算端口阻塞

/

放

开状态时产生冲突。当

RRPP

环与

STP

环邻接时，只支持

RRPP

环与

STP

环相切的组网，不支

持二者相交的组网，也就是两种协议不能有公共的端口。

Device A

Device B

Device C

Device D

Device E

Ring 

1

Ring 

2

Domain 

1

Domain 

2

22