# 概述

## 1.1 产生背景

在实际组网中，有时会出现单通现象，即一条链路上的两个接口，有且只有一端可收到另一端发来的链路层报文，此链路便称为单向链路。[图1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/DLDP_Tech_White_Paper-6W100/?CHID=949139#_Ref236625591)以光纤连接为例，示意了两种单通情形：一种是光纤交叉相连，另一种是一条光纤未连接或断路。

图1 光纤连接的两种单通情形示意图

![img](https://resource.h3c.com/cn/201908/20/20190820_4449558_image001_1220686_30005_0.png)

 

物理层的检测机制（如自动协商机制）负责进行物理信号和故障的检测。而在单向链路中，由于物理层仍处于连通状态，因此物理层检测机制无法发现设备间的通信异常，从而会导致错误转发、环路等问题。而DLDP（Device Link Detection Protocol，设备链路检测协议）能够通过在链路层监控光纤或网线的链路状态，检测链路连接是否正确、链路两端可否正常交互报文。当发现单向链路时，DLDP会根据用户配置自动关闭或由用户手工关闭相关接口，以防止网络问题的发生。

## 1.2 技术优点

作为链路层协议，DLDP可以在链路层进行对端设备识别、单向链路识别以及关闭单通接口等工作：

·   如果链路两端在物理层都能独立正常工作，DLDP会在链路层检测该链路的连接是否正确、链路两端可否正常交互报文，这种检测不能通过自动协商机制实现。

·   DLDP还可与物理层的检测机制协同工作以监控链路状态。物理层的自动协商机制可以进行物理信号和故障的检测，二者协同工作，便可以检测并避免物理和逻辑的单向连接。

# 2 DLDP技术实现

## 2.1 概念介绍

### 2.1.1 DLDP邻居状态

假设接口A和B同处一条链路上，若A能收到B发来的链路层报文，便将B称为A的DLDP邻居，能够互相收发报文的两个接口互为邻居。DLDP邻居的状态如[表1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/DLDP_Tech_White_Paper-6W100/?CHID=949139#_Ref321470254)所示。

表1 DLDP邻居状态

| 状态                  | 说明                                       |
| --------------------- | ------------------------------------------ |
| Confirmed（确定）     | 链路双通时的DLDP邻居状态                   |
| Unconfirmed（未确定） | 发现新邻居但未确认链路双通时的DLDP邻居状态 |

 

### 2.1.2 DLDP接口状态

使能了DLDP功能的接口简称DLDP接口。DLDP接口可以有一或多个DLDP邻居，其状态与各DLDP邻居的状态相关，具体如[表2](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/DLDP_Tech_White_Paper-6W100/?CHID=949139#_Ref297629336)所示。

表2 DLDP接口状态

| 状态                   | 说明                                                         |
| ---------------------- | ------------------------------------------------------------ |
| Initial（初始）        | 当接口已使能DLDP，但全局尚未使能DLDP时的接口状态             |
| Inactive（非活动）     | 当接口和全局均已使能DLDP，但链路物理down时的接口状态         |
| Bidirectional（双通）  | 当接口和全局均已使能DLDP，且有至少一个处于确定状态下的邻居时的接口状态 |
| Unidirectional（单通） | 当接口和全局均已使能DLDP，且没有处于确定状态下的邻居时的接口状态，处于此状态的接口只能收发DLDP报文 |

 

### 2.1.3 DLDP定时器

DLDP在工作过程中使用到的定时器如[表3](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/DLDP_Tech_White_Paper-6W100/?CHID=949139#_Ref162758690)所示。

表3 DLDP定时器

| 定时器                  | 说明                                                         |
| ----------------------- | ------------------------------------------------------------ |
| Advertisement发送定时器 | Advertisement报文的发送间隔（缺省为5秒，可配）               |
| Probe发送定时器         | Probe报文的发送间隔（固定为1秒）                             |
| Echo等待定时器          | 对邻居进行探测时会启动此定时器（固定为10秒）                 |
| 邻居老化定时器          | 每个新邻居的加入都要建立邻居表项，当邻居处于确定状态时启动邻居老化定时器，当收到邻居的Advertisement报文时刷新邻居表项的邻居老化定时器。邻居老化定时器的值是Advertisement发送定时器的值的3倍 |
| 加强探测定时器          | 若邻居老化定时器超时，则启动该邻居的加强探测定时器（固定为1秒），同时启动Echo等待定时器 |
| DelayDown定时器         | 接口物理down时不会立即删除所有邻居，而是先启动DelayDown定时器（缺省为1秒，可配），该定时器超时后再核对接口的物理状态：若为down，则删除DLDP邻居信息；若为up，则不进行任何处理 |
| 恢复探测定时器          | RecoverProbe报文的发送间隔（固定为2秒）。处于单通状态的接口会定期发送RecoverProbe报文来检测单向链路是否恢复 |

 

### 2.1.4 DLDP认证模式

进行DLDP认证，可以防止网络攻击和恶意探测，DLDP的认证模式如[表4](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/DLDP_Tech_White_Paper-6W100/?CHID=949139#_Ref297622690)所示。

表4 DLDP认证模式

| 认证模式 | DLDP报文发送端的处理                                | DLDP报文接收端的处理                                         |
| -------- | --------------------------------------------------- | ------------------------------------------------------------ |
| 不认证   | 将DLDP报文的认证字字段置为全0                       | 将接收的DLDP报文的认证信息与本端配置进行比较，若一致则认证通过，否则丢弃该报文 |
| 明文认证 | 将DLDP报文的认证字字段置为明文认证密码              |                                                              |
| MD5认证  | 将DLDP报文的认证字字段置为用MD5算法加密后的密码摘要 |                                                              |

 

## 2.2 工作机制

### 2.2.1 单邻居检测机制

当两台设备通过光纤或网线直接相连时，可以在这两台设备之间启用DLDP来检测单向链路，此时这两台设备的接口互为DLDP邻居，因此称为单邻居检测。下面分两种情况分别介绍单邻居的单向链路检测过程。

#### 1. DLDP使能前链路已出现单通

图2 光纤交叉连接示意图

![img](https://resource.h3c.com/cn/201908/20/20190820_4449559_image002_1220686_30005_0.png)

 

如[图2](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/DLDP_Tech_White_Paper-6W100/?CHID=949139#_Ref321734248)所示，在DLDP使能之前，Device A和Device B之间的光纤就已交叉连接。当DLDP使能后，处于up状态的四个接口都进入单通状态，并向外发送RecoverProbe报文。下面以Port 1为例介绍单向链路的检测过程：

(1)   Port 1收到Port 4发来的RecoverProbe报文后，回复RecoverEcho报文。

(2)   由于Port 4无法收到Port 1发来的RecoverEcho报文，因此不会与Port 1建立邻居关系。

(3)   Port 3虽能收到Port 1发来的RecoverEcho报文，但由于该报文并不是回复给Port 3的，因此Port 3也不会与Port 1建立邻居关系。

其它三个接口上的检测过程与Port 1类似，这四个接口将始终处于单通状态。

#### 2. DLDP使能后链路才出现单通

图3 一条光纤断路示意图

![img](https://resource.h3c.com/cn/201908/20/20190820_4449560_image003_1220686_30005_0.png)

 

如[图3](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/DLDP_Tech_White_Paper-6W100/?CHID=949139#_Ref321734277)所示，Device A和Device B通过光纤相连。在DLDP使能之后，光纤连接起初是正常的，Port 1与Port 2之间的双通邻居建立过程如下：

(1)   处于物理up状态的Port 1先进入单通状态，向外发送RecoverProbe报文。

(2)   Port 2收到RecoverProbe报文后，回复RecoverEcho报文。

(3)   Port 1收到RecoverEcho报文后，发现该报文中携带的邻居信息与本机的相同，于是与Port 2建立确定的邻居关系，接口状态由单通变为双通，启动该邻居的老化定时器并定期发送Advertisement报文。

(4)   Port 2收到Advertisement报文后与Port 1建立未确定的邻居关系，为该邻居启动Echo等待定时器和Probe发送定时器，定期发送Probe报文。

(5)   Port 1收到Probe报文后，回复Echo报文。

(6)   Port 2收到Echo报文后，发现该报文中携带的邻居信息和本机保存的相同，于是将邻居状态由未确定切换为确定，接口状态则由单通切换为双通，启动该邻居的老化定时器并定期发送Advertisement报文。

至此，Port 1与Port 2之间的双通邻居关系建立完毕。

此后，假设Port 2的Rx端突发故障而无法接收信号，该接口将物理down并进入非活动状态，但此时由于其Tx端尚能发送信号给Port 1，因此Port 1还处于up状态。Port 1在邻居老化定时器超时后，将启用加强探测定时器和Echo等待定时器，并向邻居Port 2发送Probe报文；而由于Port 1的Tx端已断路，Echo等待定时器超时后将收不到Port 2回复的Echo报文，于是Port 1进入单通状态，并发送Disable报文通知对端。同时，Port 1删除邻居Port 2，并启动恢复探测定时器以检测链路是否恢复。在此过程中，Port 2将一直处于非活动状态。

### 2.2.2 多邻居检测机制

当多台设备通过Hub相连时，也可以在这些设备之间启用DLDP协议来检测单向链路，此时每个接口都会检测到一个以上的DLDP邻居，因此称为多邻居检测。在多邻居组网环境中，为了能正确检测出单向链路，要求在所有与Hub相连的接口上都启用DLDP，接口一旦发现没有确定的邻居，便进入单通状态。

图4 多邻居组网示意图

![img](https://resource.h3c.com/cn/201908/20/20190820_4449561_image004_1220686_30005_0.png)

 

如[图4](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/DLDP_Tech_White_Paper-6W100/?CHID=949139#_Ref321734170)所示，Device A～Device D都通过一台Hub相连，各设备都支持DLDP。当Port 1、Port 2和Port 3发现与Port 4的连接出错后，都将删除该邻居，但仍保持双通状态。

### 2.2.3 发现单向链路后的处理机制

当DLDP检测到单向链路时，可以采用以下三种方式关闭单通接口：

·   自动模式：在此模式下，当DLDP检测到单向链路时会自动关闭单通接口。

·   手动模式：在此模式下，当DLDP检测到单向链路时不会直接关闭单通接口，而是需要用户手工将其关闭；当单向链路恢复为双向链路后，还需要用户手工将其打开。当网络性能较差、设备业务量较大或CPU利用率较高时，都容易造成DLDP对单通的误判而自动关闭接口，手动模式就是为了避免这种误判而采取的一种折中方案。

·   混合模式：在此模式下，若DLDP检测到单向链路，则会自动关闭单通接口；当用户想知道链路是否恢复为双向链路时，需要执行**undo shutdown**命令打开端口重新检测链路，若检测到链路恢复为双向链路，则接口恢复正常。

### 2.2.4 链路恢复后的处理机制

当单向链路恢复双通后，可以通过以下两种方式使接口恢复正常工作：

·   对于被网络管理员手动关闭的接口，需要使用undo shutdown命令手工打开。

·   对于被系统自动设置为DLDP DOWN状态的接口，链路自动恢复机制可自动检测到DLDP邻居恢复并重新打开该接口。

其中，链路自动恢复机制可使处于DLDP DOWN状态的接口在链路恢复后自动从此状态中恢复，具体过程如下：

(1)   处于DLDP DOWN状态的接口每2秒向外发送一次RecoverProbe报文，该报文中只携带本接口的信息。

(2)   对端接口如果收到该报文，则回复RecoverEcho报文作为应答。

(3)   本端接口收到RecoverEcho报文后，检查该报文中携带的邻居信息是否与本接口的信息相同。如果相同，便建立邻居表项，设置邻居状态为Confirmed，本端接口的状态从Unidirectional迁移到Bidirectional，并开始定期发送Advertisement报文。

## 2.3 应用限制

在应用DLDP时需要注意：

·   为了防止网络攻击和恶意探测，用户可以对DLDP报文进行认证，认证方式分为明文认证和MD5认证。为确保检测出单向链路，要保证两端设备的认证方式和认证口令相同。

·   为确保检测出单向链路，要保证两端设备的DLDP处于使能状态、Advertisement报文发送时间间隔相等。

·   为了使DLDP在不同的网络环境下都能及时发现单向链路，需要合理调整Advertisement报文的时间间隔。如果设定的时间太长，DLDP协议不能及时关闭单向链路；如果设定的时间太短，会增加协议报文数量，并且在网络环境不好的情况下，由丢失协议报文导致的误检测几率会提高。

·   DLDP运行在聚合和STP之下，协议报文的收发不受聚合非选中以及STP阻塞的影响。

·   使能了DLDP功能的设备之间可以通过透传设备（如Hub或未启用DLDP的设备）相连。透传设备将DLDP协议报文作为数据报文处理，此时聚合非选中以及STP阻塞会影响DLDP协议报文的转发，进而可能会引起DLDP状态机震荡。

# 3 典型组网应用

典型的DLDP组网应用如[图5](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/DLDP_Tech_White_Paper-6W100/?CHID=949139#_Ref97266835)所示。Device A和Device B通过光纤相连，Port 2的Rx端所在线路断路，Port 2处于物理down状态。但是，由于Port 1检测不到这种情况，仍向Port 2发送数据报文，这样就会造成数据报文的丢失。

为了检测出此单通情况，可以在这两台设备上都配置DLDP功能。当DLDP检测出单向链路后，会自动断开单向链路，就避免了数据报文的丢失。在网络管理员修复链路之后，单向链路会自动恢复为正常状态，继续转发报文。

图5 DLDP典型应用组网图

![img](https://resource.h3c.com/cn/201908/20/20190820_4449562_image005_1220686_30005_0.png)

 