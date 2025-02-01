# 概述

## 1.1 产生背景

在二层交换网络中，一旦存在环路就会造成报文在环路内不断循环和增生，产生广播风暴，从而占用所有的有效带宽，使网络变得不可用。

在这种环境下生成树协议应运而生，生成树协议是一种二层管理协议，它通过选择性地阻塞网络中的冗余链路来消除二层环路，同时还具备链路备份的功能。最初的生成树协议为STP（Spanning Tree Protocol，生成树协议），之后又发展出RSTP（Rapid Spanning Tree Protocol，快速生成树协议）、PVST（Per-VLAN Spanning Tree，每VLAN生成树）和MSTP（Multiple Spanning Tree Protocol，多生成树协议）。

STP包含了两个含义，狭义的STP是指IEEE 802.1D中定义的STP协议，广义的STP是指包括IEEE 802.1D定义的STP协议以及各种在它的基础上经过改进的生成树协议。

## 1.2 技术优点

MSTP由IEEE制定的802.1s标准定义，相比于STP、RSTP和PVST MSTP的优点如下：

·   MSTP把一个交换网络划分成多个域，每个域内形成多棵生成树，生成树之间彼此独立。生成树间独立计算，实现快速收敛。

·   MSTP通过设置VLAN与生成树的对应关系表（即VLAN映射表），将VLAN与生成树联系起来。并通过“实例”的概念，将多个VLAN捆绑到一个实例中，从而达到了节省通信开销和降低资源占用率的目的。

·   MSTP将环路网络修剪成为一个无环的树型网络，避免报文在环路网络中的增生和无限循环，同时还提供了数据转发的多个冗余路径，不同VLAN的流量沿各自的路径转发，实现VLAN数据的负载分担。

·   MSTP兼容STP和RSTP，部分兼容PVST。

# 2 STP技术实现

## 2.1 概念介绍

#### 1. 根桥

树形的网络结构必须有树根，于是STP引入了根桥的概念。根桥在全网中有且只有一个，其他设备则称为叶子节点。根桥会根据网络拓扑的变化而改变，因此根桥并不是固定的。

在网络初始化过程中，所有设备都视自己为根桥，生成各自的配置BPDU并周期性地向外发送；但当网络拓扑稳定以后，只有根桥才会向外发送配置BPDU，其他设备则对其进行转发。

#### 2. 根端口

非根桥设备上离根桥最近的端口。根端口负责与根桥进行通信。非根桥设备上有且只有一个根端口，根桥上没有根端口。

#### 3. 指定桥与指定端口

有关指定桥与指定端口的含义，请参见[表1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref125196674)的说明。

表1 指定桥与指定端口的含义

| 分类               | 指定桥                                     | 指定端口                     |
| ------------------ | ------------------------------------------ | ---------------------------- |
| 对于一台设备而言   | 与本机直接相连并且负责向本机转发BPDU的设备 | 指定桥向本机转发BPDU的端口   |
| 对于一个局域网而言 | 负责向本网段转发BPDU的设备                 | 指定桥向本网段转发BPDU的端口 |

 

#### 4. 端口状态

STP的端口有5种工作状态。如[表2](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref398036135)所示。

表2 STP的端口状态

| 状态       | 描述                                                        |
| ---------- | ----------------------------------------------------------- |
| Disabled   | 该状态下的端口没有激活，不参与STP的任何动作，不转发用户流量 |
| Listening  | 该状态下的端口可以接收和发送BPDU，但不转发用户流量          |
| Learning   | 该状态下建立无环的转发表，不转发用户流量                    |
| Forwarding | 该状态下的端口可以接收和发送BPDU，也转发用户流量            |
| Blocking   | 该状态下的端口可以接收BPDU，但不转发用户流量                |

 

#### 5. 路径开销

路径开销是STP协议用于选择链路的参考值。STP协议通过计算路径开销，选择较为“强壮”的链路，阻塞多余的链路，将网络修剪成无环路的树型网络结构。

## 2.2 STP的协议报文

STP采用的协议报文是BPDU（Bridge Protocol Data Unit，网桥协议数据单元），也称为配置消息。本文中将把生成树的协议报文简称为BPDU。

STP通过在设备之间传递BPDU来确定网络的拓扑结构。BPDU中包含了足够的信息来保证设备完成生成树的计算过程。STP协议的BPDU分为以下两类：

·   配置BPDU（Configuration BPDU）：用来进行生成树计算和维护生成树拓扑的报文。

·   TCN BPDU（Topology Change Notification BPDU，拓扑变化通知BPDU）：当拓扑结构发生变化时，用来通知相关设备网络拓扑结构发生变化的报文。

#### 1. 配置BPDU

网桥之间通过交互配置BPDU来进行根桥的选举以及端口角色的确定。配置BPDU的格式如[图1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref17377449)所示。

图1 配置BPDU格式

![img](https://resource.h3c.com/cn/201910/25/20191025_4562940_x_Img_x_png_0_1238957_30005_0.png)

 

配置BPDU中BPDU数据的信息包括：

·   协议类型（Protocol ID）：固定为0x0000，表示生成树协议。

·   协议版本号（Protocol Version ID）：目前生成树有三个版本，STP的协议版本号为0x00。

·   BPDU类型：配置BPDU类型为0x00。

·   BPDU Flags位：BPDU标志位，表示是哪种BPDU。由8位组成，最低位（0位）为TC（Topology Change，拓扑改变）标志位；最高位（7位）为TCA（Topology Change Acknowledge，拓扑改变确认）标志位；其他6位保留。

·   根桥（Root Bridge）ID：由根桥的优先级和MAC地址组成。

·   根路径开销：到根桥的路径开销。

·   指定桥ID：由指定桥的优先级和MAC地址组成。

·   指定端口ID：由指定端口的优先级和该端口的全局编号组成。

·   Message Age：BPDU在网络中传播的生存期。

·   Max Age：BPDU在设备中的最大生存期。

·   Hello Time：BPDU的发送周期。

·   Forward Delay：端口状态迁移的延迟时间。

其中通过根桥ID、路径开销、指定桥ID、指定端口ID、Message Age、Max Age、Hello Time和Forward Delay信息来保证设备完成生成树的计算过程。

#### 2. TCN BPDU

如[图2](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref17377459)所示，TCN BPDU和配置BPDU在结构上基本相同，也是由源/目的MAC地址、L/T位、逻辑链路头和BPDU数据组成。但是TCN BPDU的BPDU数据组成非常简单，只包含三部分信息：协议类型、协议版本号和BPDU类型。协议类型和协议版本号字段和配置BPDU相同，BPDU类型字段的值为0x80，表示该BPDU为TCN BPDU。

图2 TCN BPDU格式

![img](https://resource.h3c.com/cn/201910/25/20191025_4562941_x_Img_x_png_1_1238957_30005_0.png)

 

TCN BPDU有两个产生条件：

·   网桥上有端口转变为Forwarding状态，且该网桥至少包含一个指定端口。

·   网桥上有端口从Forwarding状态或Learning状态转变为Blocking状态。

当上述两个条件之一满足时，说明网络拓扑发生了变化，网桥需要使用TCN BPDU通知根桥。根桥可以通过将配置BPDU中对应标志位置位来通知所有网桥网络拓扑发生了变化，需要使用较短的MAC地址老化时间，保证拓扑的快速收敛。

## 2.3 STP的拓扑计算过程

STP的拓扑计算过程如下：设备通过比较不同端口收到的BPDU报文的优先级高低，选举出根桥、根端口、指定端口，完成生成树的计算，建立对应的树形拓扑。

#### 1. 初始状态

各设备的各端口在初始时会生成以本设备为根桥的BPDU，根路径开销为0，指定桥ID为自身设备ID，指定端口为本端口。

#### 2. 选择根桥

网络初始化时，需要在网络中所有的STP设备中选择一个根桥，根桥的选择方式有以下两种：

·   自动选举：网络初始化时，网络中所有的STP设备都认为自己是“根桥”，根桥ID为自身的设备ID。通过交换BPDU，设备之间比较根桥ID，网络中根桥ID最小的设备被选为根桥。

·   手工指定：用户手工将设备配置为指定生成树的根桥或备份根桥。

¡   在一棵生成树中，生效的根桥只有一个，当两台或两台以上的设备被指定为同一棵生成树的根桥时，系统将选择MAC地址最小的设备作为根桥。

¡   用户可以在每棵生成树中指定一个或多个备份根桥。当根桥出现故障或被关机时，如果配置了一个备份根桥，则该备份根桥可以取代根桥成为指定生成树的根桥；如果配置了多个备份根桥，则MAC地址最小的备份根桥将成为指定生成树的根桥。但此时若配置了新的根桥，则备份根桥将不会成为根桥。

#### 3. 选择根端口和指定端口

根端口和指定端口的选择过程如[表3](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref419033141)所示。

表3 根端口和指定端口的选择过程

| 步骤 | 内容                                                         |
| ---- | ------------------------------------------------------------ |
| 1    | 非根桥设备将接收最优BPDU（最优BPDU的选择过程如[表4](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref272755221)所示）的那个端口定为根端口 |
| 2    | 设备根据根端口的BPDU和根端口的路径开销，为每个端口计算一个指定端口BPDU：  ·   根桥ID替换为根端口的BPDU的根桥ID；  ·   根路径开销替换为根端口BPDU的根路径开销加上根端口对应的路径开销；  ·   指定桥ID替换为自身设备的ID；  ·   指定端口ID替换为自身端口ID。 |
| 3    | 设备将计算出的BPDU与角色待定端口自己的BPDU进行比较：  ·   如果计算出的BPDU更优，则该端口被确定为指定端口，其BPDU也被计算出的BPDU替换，并周期性地向外发送；  ·   如果该端口自己的BPDU更优，则不更新该端口的BPDU并将该端口阻塞。该端口将不再转发数据，且只接收不发送BPDU。 |

 

![说明: 说明](https://resource.h3c.com/cn/201910/25/20191025_4562952_x_Img_x_png_2_1238957_30005_0.png)

当拓扑处于稳定状态时，只有根端口和指定端口在转发用户流量。其他端口都处于阻塞状态，只接收STP协议报文而不转发用户流量。

 

表4 最优BPDU的选择过程

| 步骤 | 内容                                                         |
| ---- | ------------------------------------------------------------ |
| 1    | 每个端口将收到的BPDU与自己的BPDU进行比较：  ·   如果收到的BPDU优先级较低，则将其直接丢弃，对自己的BPDU不进行任何处理；  ·   如果收到的BPDU优先级较高，则用该BPDU的内容将自己BPDU的内容替换掉。 |
| 2    | 设备将所有端口的BPDU进行比较，选出最优的BPDU                 |

 

![说明: 说明](https://resource.h3c.com/cn/201910/25/20191025_4562959_x_Img_x_png_3_1238957_30005_0.png)

BPDU优先级的比较规则如下：

·   根桥ID较小的BPDU优先级较高；

·   若根桥ID相同，则比较根路径开销：将BPDU中的根路径开销与本端口对应的路径开销相加，二者之和较小的BPDU优先级较高；

·   若根路径开销也相同，则依次比较指定桥ID、指定端口ID、接收该BPDU的端口ID等，上述值较小的BPDU优先级较高。

 

一旦根桥、根端口和指定端口选举成功，整个树形拓扑就建立完毕了。

## 2.4 STP算法实现举例

下面结合例子说明STP算法实现的具体过程。

图3 STP算法实现过程组网图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562960_x_Img_x_png_4_1238957_30005_0.png)

 

如[图3](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref400639545)所示，Device A、Device B和Device C的优先级分别为0、1和2，Device A与Device B之间、Device A与Device C之间以及Device B与Device C之间链路的路径开销分别为5、10和4。

#### 1. 各设备的初始状态

各设备的初始状态如[表5](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref125196878)所示。

表5 各设备的初始状态

| 设备     | 端口名称           | 端口的BPDU         |
| -------- | ------------------ | ------------------ |
| Device A | Port A1            | {0，0，0，Port A1} |
| Port A2  | {0，0，0，Port A2} |                    |
| Device B | Port B1            | {1，0，1，Port B1} |
| Port B2  | {1，0，1，Port B2} |                    |
| Device C | Port C1            | {2，0，2，Port C1} |
| Port C2  | {2，0，2，Port C2} |                    |

 

![说明: 说明](https://resource.h3c.com/cn/201910/25/20191025_4562961_x_Img_x_png_5_1238957_30005_0.png)

[表5](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref125196878)中BPDU各项的具体含义为：{根桥ID，根路径开销，指定桥ID，指定端口ID}。

 

#### 2. 各设备的比较过程及结果

各设备的比较过程及结果如[表6](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref265128457)所示。

表6 各设备的比较过程及结果

| 设备                                                         | 比较过程                                                     | 比较后端口的BPDU                                             |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Device A                                                     | ·   Port A1收到Port B1的BPDU {1，0，1，Port B1}，发现自己的BPDU {0，0，0，Port A1}更优，于是将其丢弃。  ·   Port A2收到Port C1的BPDU {2，0，2，Port C1}，发现自己的BPDU {0，0，0，Port A2}更优，于是将其丢弃。  ·   Device A发现自己各端口的BPDU中的根桥和指定桥都是自己，于是认为自己就是根桥，各端口的BPDU都不作任何修改，此后便周期性地向外发送BPDU。 | ·   Port A1：  {0，0，0，Port A1}  ·   Port A2：  {0，0，0，Port A2} |
| Device B                                                     | ·   Port B1收到Port A1的BPDU {0，0，0，Port A1}，发现其比自己的BPDU {1，0，1，Port B1}更优，于是更新自己的BPDU。  ·   Port B2收到Port C2的BPDU {2，0，2，Port C2}，发现自己的BPDU {1，0，1，Port B2}更优，于是将其丢弃。 | ·   Port B1：  {0，0，0，Port A1}  ·   Port B2：  {1，0，1，Port B2} |
| ·   Device B比较自己各端口的BPDU，发现Port B1的BPDU最优，于是该端口被确定为根端口，其BPDU不变。  ·   Device B根据根端口的BPDU和路径开销，为Port B2计算出指定端口的BPDU {0，5，1，Port B2}，然后与Port B2本身的BPDU {1，0，1，Port B2}进行比较，发现计算出的BPDU更优，于是Port B2被确定为指定端口，其BPDU也被替换为计算出的BPDU，并周期性地向外发送。 | ·   根端口Port B1：  {0，0，0，Port A1}  ·   指定端口Port B2：  {0，5，1，Port B2} |                                                              |
| Device C                                                     | ·   Port C1收到Port A2的BPDU {0，0，0，Port A2}，发现其比自己的BPDU {2，0，2，Port C1}更优，于是更新自己的BPDU。  ·   Port C2收到Port B2更新前的BPDU {1，0，1，Port B2}，发现其比自己的BPDU {2，0，2，Port C2}更优，于是更新自己的BPDU。 | ·   Port C1：  {0，0，0，Port A2}  ·   Port C2：  {1，0，1，Port B2} |
| ·   Device C比较自己各端口的BPDU，发现Port C1的BPDU最优，于是该端口被确定为根端口，其BPDU不变。  ·   Device C根据根端口的BPDU和路径开销，为Port C2计算出指定端口的BPDU {0，10，2，Port C2}，然后与Port C2本身的BPDU {1，0，1，Port B2}进行比较，发现计算出的BPDU更优，于是Port C2被确定为指定端口，其BPDU也被替换为计算出的BPDU。 | ·   根端口Port C1：  {0，0，0，Port A2}  ·   指定端口Port C2：  {0，10，2，Port C2} |                                                              |
| ·   Port C2收到Port B2更新后的BPDU {0，5，1，Port B2}，发现其比自己的BPDU {0，10，2，Port C2}更优，于是更新自己的BPDU。  ·   Port C1收到Port A2周期性发来的BPDU {0，0，0，Port A2}，发现其与自己的BPDU一样，于是将其丢弃。 | ·   Port C1：  {0，0，0，Port A2}  ·   Port C2：  {0，5，1，Port B2} |                                                              |
| ·   Device C比较Port C1的根路径开销10（收到的BPDU中的根路径开销0＋本端口所在链路的路径开销10）与Port C2的根路径开销9（收到的BPDU中的根路径开销5＋本端口所在链路的路径开销4），发现后者更小，因此Port C2的BPDU更优，于是Port C2被确定为根端口，其BPDU不变。  ·   Device C根据根端口的BPDU和路径开销，为Port C1计算出指定端口的BPDU {0，9，2，Port C1}，然后与Port C1本身的BPDU {0，0，0，Port A2}进行比较，发现本身的BPDU更优，于是Port C1被阻塞，其BPDU不变。从此，Port C1不再转发数据，直至有触发生成树计算的新情况出现，譬如Device B与Device C之间的链路down掉。 | ·   阻塞端口Port C1：  {0，0，0，Port A2}  ·   根端口Port C2：  {0，5，1，Port B2} |                                                              |

 

#### 3. 计算出的生成树

经过上述比较过程之后，以Device A为根桥的生成树就确定下来了，其拓扑如[图4](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref419033162)所示。

图4 计算后得到的拓扑

![img](https://resource.h3c.com/cn/201910/25/20191025_4562962_x_Img_x_png_6_1238957_30005_0.png)

 

![说明: 说明](https://resource.h3c.com/cn/201910/25/20191025_4562963_x_Img_x_png_7_1238957_30005_0.png)

为了便于描述，本例简化了生成树的计算过程，实际的过程要更加复杂。

 

## 2.5 STP的BPDU传递机制

STP的BPDU传递机制如下：

·   当网络初始化时，所有的设备都将自己作为根桥，生成以自己为根的BPDU，并以Hello Time为周期定时向外发送。

·   接收到BPDU的端口如果是根端口，且接收的BPDU比该端口的BPDU优，则设备将BPDU中携带的Message Age按照一定的原则递增，并启动定时器为这条BPDU计时，同时将此BPDU从设备的指定端口转发出去。

·   如果指定端口收到的BPDU比本端口的BPDU优先级低时，会立刻发出自己的更好的BPDU进行回应。

·   如果某条路径发生故障，则这条路径上的根端口不会再收到新的BPDU，旧的BPDU将会因为超时而被丢弃，设备重新生成以自己为根的BPDU并向外发送，从而引发生成树的重新计算，得到一条新的通路替代发生故障的链路，恢复网络连通性。

不过，重新计算得到的新BPDU不会立刻就传遍整个网络，因此旧的根端口和指定端口由于没有发现网络拓扑变化，将仍按原来的路径继续转发数据。如果新选出的根端口和指定端口立刻就开始数据转发的话，可能会造成暂时性的环路。

## 2.6 STP的时间参数

在STP的计算过程中，用到了以下三个重要的时间参数：

·   Forward Delay：用于确定状态迁移的延迟时间。缺省情况下Forward Delay时间为15秒。链路故障会引发网络重新进行生成树的计算，生成树的结构将发生相应的变化。不过重新计算得到的新BPDU无法立刻传遍整个网络，如果新选出的根端口和指定端口立刻就开始数据转发的话，可能会造成暂时性的环路。为此，生成树协议在端口由Blocking状态向Forwarding状态迁移的过程中设置了Listening和Learning状态作为过渡（Listening和Learning状态都会持续Forward Delay时间），并规定状态迁移需要等待Forward Delay时间，以保持与远端的设备状态切换同步。新选出的根端口和指定端口要经过2倍的Forward Delay延时后才能进入转发状态，这个延时保证了新的BPDU已经传遍整个网络。

·   Hello Time：用于设备检测链路是否存在故障。缺省情况下Hello Time为2秒。生成树协议每隔Hello Time时间会发送BPDU，以确认链路是否存在故障。如果设备在超时时间（超时时间＝超时时间因子×3×Hello Time）内没有收到BPDU，则会由于消息超时而重新计算生成树。

·   Max Age：用于判断BPDU在设备内的保存时间是否“过时”，设备会将过时的BPDU丢弃。缺省情况下Max Age时间为20秒。在MSTP的CIST上，设备根据Max Age时间来确定端口收到的BPDU是否超时。如果端口收到的BPDU超时，则需要对该MSTI重新计算。Max Age时间对MSTP的MSTI无效。

STP每隔一个Hello Time发送一个BPDU，并且引入Keepalive机制。Hello包的发送可以避免最大失效定时器溢出。如果最大失效定时器溢出，通常表明有连接错误发生。此时，STP会进入Listening状态。STP要从连接错误中恢复过来，一般需要50秒的时间。其中BPDU最长的失效时间20秒；Listening状态持续15秒；Learning状态持续15秒。

为保证网络拓扑的快速收敛，需要配置合适的时间参数。上述三个时间参数之间应满足以下关系，否则会引起网络的频繁震荡：

·   2×（Forward Delay－1秒）≥Max Age

·   Max Age≥2×（Hello Time＋1秒）

# 3 RSTP技术实现

## 3.1 概念介绍

#### 1. 端口角色

RSTP中根端口和指定端口角色的定义和STP相同。与STP相比，RSTP增加了三种端口角色替换端口（Alternate Port）、备份端口（Backup Port）和边缘端口（Edge Port）。

·   替换端口为网桥提供一条到达根桥的备用路径，当根端口或主端口被阻塞后，替换端口将成为新的根端口或主端口。

·   备份端口为网桥提供了到达同一个物理网段的冗余路径，当指定端口失效后，备份端口将转换为新的指定端口。当开启了生成树协议的同一台设备上的两个端口互相连接而形成环路时，设备会将其中一个端口阻塞，该端口就是备份端口。

·   边缘端口是不与其他设备或网段连接的端口，边缘端口一般与用户终端设备直接相连。

#### 2. 端口状态

RSTP将端口状态缩减为三个，分别为Discarding、Learning和Forwarding状态。STP中的Disabled、Blocking和Listening状态在RSTP中都对应为Discarding状态，如[表7](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref398301592)所示。

表7 RSTP的端口状态

| STP端口状态 | RSTP端口状态 | 是否发送BPDU | 是否进行MAC地址学习 | 是否收发用户流量 |
| ----------- | ------------ | ------------ | ------------------- | ---------------- |
| Disabled    | Discarding   | 否           | 否                  | 否               |
| Blocking    | Discarding   | 否           | 否                  | 否               |
| Listening   | Discarding   | 是           | 否                  | 否               |
| Learning    | Learning     | 是           | 是                  | 否               |
| Forwarding  | Forwarding   | 是           | 是                  | 是               |

 

## 3.2 RSTP的协议报文

RSTP也是通过在设备之间传递BPDU来确定网络的拓扑结构。RSTP的BPDU格式和STP的配置BPDU格式非常相似，仅在以下几个信息有所不同：

·   BPDU类型变为0x02，表示为RSTP的BPDU。

·   BPDU协议版本号为0x02，表示为RSTP协议。

·   Flags位字段使用了全8位。

·   RSTP在BPDU报文的最后增加了Version1 Length字段。该字段的值为0x00，表示本BPDU中不包含Version 1内容。

在拓扑改变时，RSTP的拓扑改变处理过程不再使用TCN BPDU，而使用Flags位中TC置位的RST BPDU取代TCN BPDU，并通过泛洪方式快速的通知到整个网络。

## 3.3 RSTP的工作原理

进行RSTP计算时，端口会在Discarding状态完成角色的确定，当端口确定为根端口和指定端口后，经过Forward Delay端口会进入Learning状态；当端口确定为替换端口，端口会维持在Discarding状态。

处于Learning状态的端口其处理方式和STP相同，开始学习MAC地址并在Forward Delay后进入Forwarding状态开始收发用户流量。

在RSTP中，根端口 的端口状态快速迁移的条件是：本设备上旧的根端口已经停止转发数据，而且上游指定端口已经开始转发数据。

在RSTP中，指定端口的端口状态快速迁移的条件是：指定端口是边缘端口（即该端口直接与用户终端相连，而没有连接到其他设备或共享网段上）或者指定端口与点对点链路（即两台设备直接相连的链路）相连。如果指定端口是边缘端口，则指定端口可以直接进入转发状态；如果指定端口连接着点对点链路，则设备可以通过与下游设备握手，得到响应后即刻进入转发状态。

## 3.4 RSTP中的BPDU处理

相比于STP，RSTP对BPDU的发送方式做了改进，RSTP中网桥可以自行从指定端口发送RST BPDU，不需要等待来自根桥的RST BPDU，BPDU的发送周期为Hello Time。

由于RSTP中网桥可以自行从指定端口发送RST BPDU，所以在网桥之间可以提供一种保活机制，即在一定时间内网桥没有收到对端网桥发送的RST BPDU，即可认为和对端网桥的连接中断。

RSTP规定，若在三个连续的Hello Time时间内网桥没有收到对端指定桥发送的RST BPDU，则网桥端口保存的RST BPDU老化，认为与对端网桥连接中断。新的老化机制大大加快了拓扑变化的感知，从而可以实现快速收敛。

在RSTP中，如果阻塞状态的端口收到低优先级的RST BPDU，也可以立即对其做出回应。

如[图5](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref398305590)，网络中Device A为根桥，Device C阻塞和Device B相连的端口。当Device B和根桥之间的链路中断时，Device B会发送以自己为根桥的RST BPDU。Device C收到Device B发送的RST BPDU后，经过比较，Device B的值RST BPDU为低优先级的RST BPDU，所以Device C的端口会立即对该RST BPDU做出回应，发送优先级更高的RST BPDU。Device B收到Device C发送的RST BPDU后，将会停止发送RST BPDU，并将和Device C连接的端口确定为根端口。

图5 RSTP对低优先级RST BPDU的处理

![img](https://resource.h3c.com/cn/201910/25/20191025_4562964_x_Img_x_png_8_1238957_30005_0.png)

 

# 4 PVST技术实现

STP和RSTP在局域网内的所有网桥都共享一棵生成树，不能按VLAN阻塞冗余链路，所有VLAN的报文都沿着一棵生成树进行转发。而PVST则可以在每个VLAN内都拥有一棵生成树，能够有效地提高链路带宽的利用率。PVST可以简单理解为在每个VLAN上运行一个RSTP协议，不同VLAN之间的生成树完全独立。

运行PVST的H3C设备可以与运行Rapid PVST或PVST的第三方设备互通。当运行PVST的H3C设备之间互联，或运行PVST的H3C设备与运行Rapid PVST的第三方设备互通时，H3C设备支持像RSTP一样的快速收敛。

## 4.1 PVST的协议报文

如[图6](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref403378283)，从报文结构对上看，PVST的BPDU和RSTP的BPDU不同在于以下几点：

·   报文的目的MAC地址改变，变为私有MAC地址01-00-0c-cc-cc-cd。

·   报文携带VLAN标签，确定该协议报文归属的VLAN。

·   报文配置消息固定链路头字段添加Organization code和PID字段。

图6 PVST报文格式

![img](https://resource.h3c.com/cn/201910/25/20191025_4562965_x_Img_x_png_9_1238957_30005_0.png)

 

根据端口类型的不同，PVST所发送的BPDU格式也有所差别：

·   对于Access端口，PVST将根据该VLAN的状态发送RSTP格式的BPDU。

·   对于Trunk端口和Hybrid端口，PVST将在缺省VLAN内根据该VLAN的状态发送RSTP格式的BPDU，而对于其他本端口允许通过的VLAN，则发送PVST格式的BPDU。

## 4.2 PVST的工作原理

PVST借助MSTP的实例和VLAN映射关系模型，将MSTP每个实例映射一个VLAN。PVST中每个VLAN独立运行RSTP，独立运算，并允许以每个VLAN为基础开启或关闭生成树。每个VLAN内的生成树实例都有单独的网络拓扑结构，相互之间没有影响。这样既可以消除了VLAN内的冗余环路，还可以实现不同VLAN间负载分担。

PVST在缺省VLAN上通过RSTP报文进行拓扑运算；在其他VLAN上通过带VLAN Tag的PVST报文进行拓扑运算。

PVST的端口角色和端口状态和RSTP相同，能够实现快速收敛。

# 5 MSTP技术实现

## 5.1 概念介绍

图7 MSTP的基本概念示意图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562942_x_Img_x_png_10_1238957_30005_0.png)

 

图8 MST域3详图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562943_x_Img_x_png_11_1238957_30005_0.png)

 

#### 1. MST域

MST域（Multiple Spanning Tree Regions，多生成树域）是由交换网络中的多台设备以及它们之间的网段所构成。这些设备具有下列特点：

·   都开启了生成树协议。

·   域名相同。

·   VLAN与MSTI间映射关系相同。

·   MSTP修订级别相同。

·   这些设备之间有物理链路连通。

一个交换网络中可以存在多个MST域，用户可以将多台设备划分在一个MST域内。如在[图7](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref400704493)所示的网络中就有MST域1～MST域4这四个MST域，每个域内的所有设备都具有相同的MST域配置。

#### 2. MSTI

一个MST域内可以通过MSTP生成多棵生成树，各生成树之间彼此独立并分别与相应的VLAN对应，每棵生成树都称为一个MSTI（Multiple Spanning Tree Instance，多生成树实例）。如在[图8](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref265133803)所示的MST域3中，包含有三个MSTI：MSTI 1、MSTI 2和MSTI 0。

#### 3. VLAN映射表

VLAN映射表是MST域的一个属性，用来描述VLAN与MSTI间的映射关系。如[图8](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref265133803)中MST域3的VLAN映射表就是：VLAN 1映射到MSTI 1，VLAN 2和VLAN 3映射到MSTI 2，其余VLAN映射到MSTI 0。MSTP就是根据VLAN映射表来实现负载分担的。

#### 4. CST

CST（Common Spanning Tree，公共生成树）是一棵连接交换网络中所有MST域的单生成树。如果把每个MST域都看作一台“设备”，CST就是这些“设备”通过STP协议、RSTP协议计算生成的一棵生成树。如[图7](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref400704571)中的蓝色线条描绘的就是CST。

#### 5. IST

IST（Internal Spanning Tree，内部生成树）是MST域内的一棵生成树，它是一个特殊的MSTI，通常也称为MSTI 0，所有VLAN缺省都映射到MSTI 0上。如[图8](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref265133803)中的MSTI 0就是MST域3内的IST。

#### 6. CIST

CIST（Common and Internal Spanning Tree，公共和内部生成树）是一棵连接交换网络内所有设备的单生成树，所有MST域的IST再加上CST就共同构成了整个交换网络的一棵完整的单生成树，即CIST。如[图7](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref400704585)中各MST域内的IST（即MSTI 0）再加上MST域间的CST就构成了整个网络的CIST。

#### 7. 域根

域根（Regional Root）就是MST域内IST或MSTI的根桥。MST域内各生成树的拓扑不同，域根也可能不同。如在[图8](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref265133803)所示的MST域3中，MSTI 1的域根为Device B，MSTI 2的域根为Device C，而MSTI 0（即IST）的域根则为Device A。

#### 8. 总根

总根（Common Root Bridge）就是CIST的根桥。如[图7](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref400704598)中CIST的总根就是MST域1中的某台设备。

#### 9. 端口角色

端口在不同的MSTI中可以担任不同的角色。如[图9](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref265080922)所示，在由Device A、Device B、Device C和Device D共同构成的MST域中，Device A的端口Port A1和Port A2连向总根方向，Device B的端口Port B2和Port B3相连而构成环路，Device C的端口Port C3和Port C4连向其他MST域，Device D的端口Port D3直接连接用户主机。

图9 端口角色示意图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562944_x_Img_x_png_12_1238957_30005_0.png)

 

如[图9](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref265080922)所示，MSTP计算过程中涉及到的主要端口角色有以下几种：

·   根端口（Root Port）：在非根桥上负责向根桥方向转发数据的端口就称为根端口，根桥上没有根端口。

·   指定端口（Designated Port）：负责向下游网段或设备转发数据的端口就称为指定端口。

·   替换端口（Alternate Port）：是根端口和主端口的备份端口。当根端口或主端口被阻塞后，替换端口将成为新的根端口或主端口。

·   备份端口（Backup Port）：是指定端口的备份端口。当指定端口失效后，备份端口将转换为新的指定端口。当开启了生成树协议的同一台设备上的两个端口互相连接而形成环路时，设备会将其中一个端口阻塞，该端口就是备份端口。

·   边缘端口（Edge Port）：不与其他设备或网段连接的端口就称为边缘端口，边缘端口一般与用户终端设备直接相连。

·   主端口（Master Port）：是将MST域连接到总根的端口（主端口不一定在域根上），位于整个域到总根的最短路径上。主端口是MST域中的报文去往总根的必经之路。主端口在IST/CIST上的角色是根端口，而在其他MSTI上的角色则是主端口。

·   域边界端口（Boundary Port）：是位于MST域的边缘、并连接其他MST域或MST域与运行STP/RSTP的区域的端口。主端口同时也是域边界端口。在进行MSTP计算时，域边界端口在MSTI上的角色与CIST的角色一致，但主端口除外——主端口在CIST上的角色为根端口，在其他MSTI上的角色才是主端口。

#### 10. 端口状态

MSTP中的端口状态可分为三种，如[表8](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref252199380)所示。同一端口在不同的MSTI中的端口状态可以不同。

表8 MSTP的端口状态

| 状态       | 描述                                                         |
| ---------- | ------------------------------------------------------------ |
| Forwarding | 该状态下的端口可以接收和发送BPDU，也转发用户流量             |
| Learning   | 是一种过渡状态，该状态下的端口可以接收和发送BPDU，但不转发用户流量 |
| Discarding | 该状态下的端口可以接收和发送BPDU，但不转发用户流量           |

 

端口状态和端口角色是没有必然联系的，[表9](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref148412990)给出了各种端口角色能够具有的端口状态（“√”表示此端口角色能够具有此端口状态；“-”表示此端口角色不能具有此端口状态）。

表9 各种端口角色具有的端口状态

| 端口角色（右）   端口状态（下） | 根端口/主端口 | 指定端口 | 替换端口 | 备份端口 |
| ------------------------------- | ------------- | -------- | -------- | -------- |
| Forwarding                      | √             | √        | -        | -        |
| Learning                        | √             | √        | -        | -        |
| Discarding                      | √             | √        | √        | √        |

 

## 5.2 MSTP的协议报文

如[图10](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref400701425)，MST BPDU和RST BPDU的前36个字节格式是相同的，其中BPDU协议版本号为0x03，表示MSTP协议，BPDU类型为0x02，表示为RST/MST BPDU。

图10 MSTP的BPDU格式

![img](https://resource.h3c.com/cn/201910/25/20191025_4562945_x_Img_x_png_13_1238957_30005_0.png)

 

RST BPDU中的Root ID字段在MSTP中表示CIST（Common and Internal Spanning Tree，公共和内部生成树）总根ID，Root Path Cost字段在MSTP中表示CIST外部路径开销（External Path Cost，EPC），Bridge ID字段在MSTP中表示CIST域根ID，Port ID字段在MSTP中表示CIST指定端口ID。

从第37字节开始是MSTP的专有字段：

·   Version3 Length：表示MSTP专有字段长度，该字段用于接收到BPDU后进行校验。

·   MST配置标识（Configuration ID）：包含格式选择符（Format Selector）、域名（Configuration Name）、修订级别（Revision Level）和配置摘要（Configuration Digest）四个字段。其中格式选择符字段固定为0x00，其余三个字段用来判断网桥是否属于某MST域。

·   CIST内部路径开销（Internal Root Path Cost，IRPC）：表示发送此BPDU的网桥到达CIST域根的路径开销。

·   CIST Bridge ID：表示发送此BPDU的网桥ID。

·   CIST剩余跳数：用来限制MST域的规模。从CIST域根开始，BPDU每经过一个网桥的转发，跳数就被减1；网桥将丢弃收到的跳数为0的BPDU，使出于最大跳数外的网桥无法参与生成树的计算，从而限制了MST域的规模。CIST剩余跳数默认值为20。

·   MSTI Configuration Messages：包含0个或最多64个MSTI（Multiple Spanning Tree Instance，多生成树实例）配置信息，MSTI配置信息数量由域内MST实例数决定，每一个MSTI配置信息长度为16字节。

## 5.3 MSTP的工作原理

MSTP将整个二层网络划分为多个MST域，各域之间通过计算生成CST；域内则通过计算生成多棵生成树，每棵生成树都被称为是一个MSTI，其中的MSTI 0也称为IST。MSTP同STP一样，使用BPDU进行生成树的计算，只是BPDU中携带的是设备上MSTP的配置信息。

#### 1. CIST生成树的计算

通过比较BPDU后，在整个网络中选择一个优先级最高的设备作为CIST的根桥。在每个MST域内MSTP通过计算生成IST；同时MSTP将每个MST域作为单台设备对待，通过计算在域间生成CST。CST和IST构成了整个网络的CIST。

#### 2. MSTI的计算

在MST域内，MSTP根据VLAN与MSTI的映射关系，针对不同的VLAN生成不同的MSTI。每棵生成树独立进行计算，计算过程与STP计算生成树的过程类似，请参见“[2.3 ](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref128824493)[STP的拓扑计算过程](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref128824493)”。

MSTP中，一个VLAN报文将沿着如下路径进行转发：

·   在MST域内，沿着其对应的MSTI转发；

·   在MST域间，沿着CST转发。

## 5.4 快速收敛机制

在STP中，为避免临时环路，端口从开启到进入转发状态需要等待默认30秒的时间，如果想要缩短这个时间，只能手工方式将Forward Delay设置为较小值。但是Forward Delay是由Hello Time和网络直径共同决定的一个参数，如果将Forward Delay设置太小，可能会导致临时环路的产生，影响网络的稳定性。

目前，RSTP/PVST/MSTP都支持快速收敛机制。快速收敛机制包括边缘端口机制、根端口快速切换机制、指定端口快速切换机制。其中指定端口快速切换机制也称为P/A（Proposal/Agreement，请求/回应）机制。

### 5.4.1 边缘端口机制

当端口直接与用户终端相连，而没有连接到其他网桥或局域网网段上时，该端口即为边缘端口。

边缘端口连接的是终端，当网络拓扑变化时，边缘端口不会产生临时环路，所以边缘端口可以略过两个Forward Delay的时间，直接进入Forwarding状态，无需任何延时。

由于网桥无法自动判断端口是否直接与终端相连，所以用户需要手工将与终端连接的端口配置为边缘端口。

图11 边缘端口示意图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562946_x_Img_x_png_14_1238957_30005_0.png)

 

### 5.4.2 根端口快速切换机制

当旧的根端口进入阻塞状态，网桥会选择优先级最高的替换端口作为新的根端口，如果当前新根端口连接的对端网桥的指定端口处于Forwarding状态，则新根端口可以立刻进入Forwarding状态。

图12 根端口快速切换示意图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562947_x_Img_x_png_15_1238957_30005_0.png)

 

如[图12](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref397611854)，Device C有两个端口，一个为根端口另一个为替换端口，当根端口链路中断时，替换端口会立刻成为新的根端口并进入Forwarding状态，期间不需要延时。

### 5.4.3 P/A机制

P/A机制是指指定端口可以通过与对端网桥进行一次握手，即可快速进入转发状态，期间不需要任何定时器。P/A机制的前提条件是：握手必须在点到点链路上进行。有点到点链路作为前提，P/A机制可以实现网络拓扑的逐链路收敛，而不必像STP，需要被动等待30秒的时间以确保全网实现收敛。

#### 1. RSTP/PVST的P/A机制

当新链路连接或故障链路恢复时，链路两端的端口初始都为指定端口并处于阻塞状态。当指定端口处于Discarding状态和Learning状态，其所发送的BPDU中Proposal位将被置位，端口角色为指定端口。收到Proposal置位的BPDU后，网桥会判断接收端口是否为根端口，如果是，网桥会启动同步过程。同步过程指网桥阻塞除边缘端口之外的所有端口，在本网桥层面消除环路产生的可能。

图13 RSTP/PVST的P/A机制实现快速收敛

![img](https://resource.h3c.com/cn/201910/25/20191025_4562948_x_Img_x_png_16_1238957_30005_0.png)

 

如[图13](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref397671674)，当Device A和Device B之间的链路连接后，P/A机制处理过程如下：

·   Device A从端口Port A1发送Proposal置位的BPDU给Device B。

·   Device B收到Proposal BPDU后，判断端口Port B2为根端口，启动同步过程阻塞指定端口Port B1和替换端口 Port B3避免环路产生，然后将根端口Port B2设置为转发状态，并向Device A回复Agreement BPDU。

·   Device A收到Agreement BPDU后，指定端口Port A1立即进入转发状态。

·   Device A的端口Port A1和Device B的端口Port B2均进入转发状态，P/A收敛过程结束。

#### 2. MSTP的P/A机制

在MSTP中，上游网桥发送的Proposal BPDU中的Proposal位和Agreement位均置位，下游网桥收到Proposal位和Agreement位均置位的BPDU后，执行同步操作然后回应Agreement置位的BPDU，使得上游指定端口快速进入转发状态。

图14 MSTP的P/A机制实现快速收敛

![img](https://resource.h3c.com/cn/201910/25/20191025_4562949_x_Img_x_png_17_1238957_30005_0.png)

 

如[图14](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref397674219)，Device A和Device B之间的P/A机制处理过程如下：

·   Device A从端口Port A1发送Proposal位和Agreement位均置位的BPDU给Device B。

·   Device B收到Proposal位和Agreement位均置位的BPDU后，判断端口Port B1为根端口，执行同步操作然后将根端口Port B1设置为转发状态，并向Device A回复Agreement BPDU。

·   Device A收到Agreement BPDU后，指定端口Port A1立即进入转发状态。

·   Device A的端口Port A1和Device B的端口Port B1均进入转发状态，P/A收敛过程结束。

从RSTP/PVST和MSTP的P/A机制处理过程可以看到，P/A机制没有依赖任何定时器，可以实现快速的收敛。

需要注意的是，如果指定端口发出的Proposal BPDU后没有收到Agreement BPDU，则该端口将切换到STP方式，需要等待30秒时间才能进入转发状态。

# 6 Comware实现的技术特色

## 6.1 No Agreement Check功能

RSTP和MSTP的指定端口快速迁移机制使用两种协议报文：

·   Proposal报文：指定端口请求快速迁移的报文。

·   Agreement报文：同意对端进行快速迁移的报文。

RSTP和MSTP均要求上游设备的指定端口在接收到下游设备的Agreement报文后才能进行快速迁移。不同之处如下：

·   对于MSTP，上游设备先向下游设备发送Agreement报文，而下游设备的根端口只有在收到了上游设备的Agreement报文后才会向上游设备回应Agreement报文。

·   对于RSTP，下游设备无需等待上游设备发送Agreement报文就可向上游设备发送Agreement报文。

如[图15](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref111455764)所示，是MSTP的指定端口快速迁移机制。

图15 MSTP指定端口快速迁移机制

![img](https://resource.h3c.com/cn/201910/25/20191025_4562950_x_Img_x_png_18_1238957_30005_0.png)

 

如[图16](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref111455762)所示，是RSTP的指定端口快速迁移机制。

图16 RSTP指定端口快速迁移机制

![img](https://resource.h3c.com/cn/201910/25/20191025_4562951_x_Img_x_png_19_1238957_30005_0.png)

 

当我方设备与作为上游设备且与对生成树协议的实现存在差异的第三方厂商设备互联时，二者在快速迁移的配合上可能会存在一定的限制。例如：上游设备指定端口的状态迁移实现机制与RSTP类似；而下游设备运行MSTP并且不工作在RSTP模式时，由于下游设备的根端口接收不到上游设备的Agreement报文，它不会向上游设备发Agreement报文，所以上游设备的指定端口无法实现状态的快速迁移，只能在2倍的Forward Delay延时后变成转发状态。

通过在我方设备与对生成树协议的实现存在私有性差异的上游第三方厂商设备相连的端口上开启No Agreement Check功能，可避免这种情况的出现，使得上游的第三方厂商设备的指定端口能够进行状态的快速迁移。

## 6.2 VLAN Ignore功能

在网络拓扑比较复杂的情况下，某些VLAN的拓扑有可能会被生成树阻塞，造成该VLAN的业务流量不通。

图17 MSTP阻塞VLAN连通性示意图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562953_x_Img_x_png_20_1238957_30005_0.png)

 

如所示，Device A的端口Port A1允许VLAN 1通过，Port A2允许VLAN 2通过；Device B的端口Port B1允许VLAN 1通过，Port B2允许VLAN 2通过。Device A和Device B都正常运行生成树协议，通过计算，Device A为根桥，其端口Port A1和Port A2为指定端口，Device B的端口Port B1为根端口，Port B2为阻塞端口，则VLAN 2的业务流量无法实现正常连通。

通过在指定VLAN上开启VLAN Ignore功能，可使该VLAN中每个端口的实际转发状态不再遵从生成树的计算结果，而是一直保持转发状态。

## 6.3 摘要侦听功能

根据IEEE 802.1s规定，只有在MST域配置（包括域名、修订级别和VLAN映射关系）完全一致的情况下，相连的设备才被认为是在同一个域内。当设备开启了生成树协议以后，设备之间通过识别BPDU数据报文内的配置ID来判断相连的设备是否与自己处于相同的MST域内；配置ID包含域名、修订级别、配置摘要等内容，其中配置摘要长16字节，是由HMAC-MD5算法将VLAN与MSTI的映射关系加密计算而成。

在网络中，由于一些厂商的设备在对生成树协议的实现上存在差异，即用加密算法计算配置摘要时采用私有的密钥，从而导致即使MST域配置相同，不同厂商的设备之间也不能实现在MST域内的互通。

通过在我方设备与对生成树协议的实现存在差异的第三方厂商设备相连的端口上开启摘要侦听功能，可以实现我方设备与这些厂商设备在MST域内的完全互通。

## 6.4 TC Snooping功能

TC Snooping功能的典型应用环境如[图18](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref290038065)所示。在该组网中，由Device A和Device B组成的IRF设备未开启生成树协议，而用户网络1和用户网络2中的所有设备均开启了生成树协议。用户网络1和用户网络2均通过双上行链路与IRF设备相连以提高链路可靠性，IRF设备可以透明传输每个用户网络中的BPDU。

在该组网中，当用户网络的拓扑结构发生改变时，由于IRF设备对BPDU进行了透明传输而不参与生成树计算，因而其本身可能需经过较长时间才能重新学到正确的MAC地址表项和ARP表项，在此期间可能导致网络中断。

图18 TC Snooping功能典型应用组网图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562954_x_Img_x_png_21_1238957_30005_0.png)

 

为了避免这种情况，可以通过在IRF设备上开启TC Snooping功能，使其在收到TC-BPDU（网络拓扑发生变化的通知报文）后，主动更新接收该报文的端口所属的VLAN所对应的MAC地址表和ARP表，从而保证业务流量的正常转发。

## 6.5 执行mCheck操作

生成树的工作模式有STP模式、RSTP模式、PVST模式和MSTP模式四种。在运行RSTP、PVST或MSTP的设备上，若某端口连接着运行STP协议的设备，该端口收到STP报文后会自动迁移到STP模式；但当对端运行STP协议的设备关机或撤走，而该端口又无法感知的情况下，该端口将无法自动迁移回原有模式，此时需要通过执行mCheck操作将其手工迁移回原有模式。

当运行STP的设备A、未开启生成树协议的设备B和运行RSTP/PVST/MSTP的设备C三者顺次相连时，设备B将透传STP报文，设备C上连接设备B的端口将迁移到STP模式。在设备B上开启生成树协议后，若想使设备B与设备C之间运行RSTP/PVST/MSTP协议，除了要在设备B上配置生成树的工作模式为RSTP/PVST/MSTP外，还要在设备B与设备C相连的端口上都执行mCheck操作。

## 6.6 关闭PVST的PVID不一致保护功能

在当链路相连的两端PVID不一致时，PVST的计算可能出现错误，为了防止这样的错误，系统默认会开启PVID不一致保护功能，即做PVID不一致的检查。若端口PVID不一致保护功能触发后，端口在PVID不一致的VLAN中，会变为阻塞状态。

在某些特定的组网场景中，比如网络中的接入层设备采用同样的配置，其接口PVID一致，而网络管理员在汇聚层设备的下行口（即连接接入层设备的接口）上做了不同的PVID配置，该配置与接入层设备的上行口（即连接汇聚层设备的接口）的PVID配置不一致时，有可能引起生成树的阻塞，为避免这种情况的发生，保持流量的转发，可以关闭PVID不一致保护功能。

## 6.7 生成树保护功能

### 6.7.1 BPDU保护功能

对于接入层设备，接入端口一般直接与用户终端（如PC）或文件服务器相连，此时接入端口被设置为边缘端口以实现这些端口的快速迁移；当这些端口接收到BPDU时系统会自动将这些端口设置为非边缘端口，重新计算生成树，引起网络拓扑结构的变化。这些端口正常情况下应该不会收到STP的BPDU。如果有人伪造BPDU恶意攻击设备，就会引起网络震荡。

生成树协议提供了BPDU保护功能来防止这种攻击：设备上开启了BPDU保护功能后，如果边缘端口收到了BPDU，系统就将这些端口关闭，同时通知网管这些端口已被生成树协议关闭。被关闭的端口在经过一定时间间隔之后将被重新激活。

### 6.7.2 根保护功能

本功能应用在设备的指定端口上。

生成树的根桥和备份根桥应该处于同一个域内，特别是对于CIST的根桥和备份根桥，网络设计时一般会把CIST的根桥和备份根桥放在一个高带宽的核心域内。但是，由于维护人员的错误配置或网络中的恶意攻击，网络中的合法根桥有可能会收到优先级更高的BPDU，这样当前合法根桥会失去根桥的地位，引起网络拓扑结构的错误变动。这种不合法的变动，会导致原来应该通过高速链路的流量被牵引到低速链路上，导致网络拥塞。

为了防止这种情况发生，生成树协议提供了根保护功能：对于开启了根保护功能的端口，其在所有MSTI上的端口角色只能为指定端口。一旦该端口收到某MSTI优先级更高的BPDU，立即将该MSTI端口设置为侦听状态，不再转发报文（相当于将此端口相连的链路断开）。当在2倍的Forward Delay时间内没有收到更优的BPDU时，端口会恢复原来的正常状态。

### 6.7.3 环路保护功能

本功能应用在设备的根端口和替换端口上。

依靠不断接收上游设备发送的BPDU，设备可以维持根端口和其他阻塞端口的状态。但是由于链路拥塞或者单向链路故障，这些端口会收不到上游设备的BPDU，此时下游设备会重新选择端口角色，收不到BPDU的下游设备端口会转变为指定端口，而阻塞端口会迁移到转发状态，从而交换网络中会产生环路。环路保护功能会抑制这种环路的产生。

在开启了环路保护功能的端口上，其所有MSTI的初始状态均为Discarding状态：如果该端口收到了BPDU，这些MSTI可以进行正常的状态迁移；否则，这些MSTI将一直处于Discarding状态以避免环路的产生。

### 6.7.4 端口角色限制功能

本功能应用在与用户接入网络相连的端口上。

用户接入网络中设备桥ID的变化会引起核心网络生成树拓扑的改变。为了避免这种情况，可以在端口上开启端口角色限制功能，此后当该端口收到最优根消息时将不再当选为根端口，而是成为替换端口。

### 6.7.5 TC-BPDU传播限制功能

本功能应用在与用户接入网络相连的端口上。

用户接入网络的拓扑改变会引起核心网络的转发地址更新，当用户接入网络的拓扑因某种原因而不稳定时，就会对核心网络形成冲击。为了避免这种情况，可以在端口上开启TC-BPDU传播限制功能，此后当该端口收到TC-BPDU时，不会再向其他端口传播。

### 6.7.6 防TC-BPDU攻击保护功能

设备在收到TC-BPDU后，会执行转发地址表项的刷新操作。在有人伪造TC-BPDU恶意攻击设备时，设备短时间内会收到很多的TC-BPDU，频繁的刷新操作给设备带来很大负担，给网络的稳定带来很大隐患。而通过在设备上开启防TC-BPDU攻击保护功能，就可以避免转发地址表项的频繁刷新。

当开启了防TC-BPDU攻击保护功能后，如果设备在单位时间（固定为十秒）内收到TC-BPDU的次数大于允许收到TC-BPDU后立即刷新转发地址表项的最高次数（假设为N次），那么该设备在这段时间之内将只进行N次刷新转发地址表项的操作，而对于超出N次的那些TC-BPDU，设备会在这段时间过后再统一进行一次地址表项刷新的操作，这样就可以避免频繁地刷新转发地址表项。

### 6.7.7 MSTP的PVST报文保护功能

对于开启MSTP的设备，并不识别PVST报文，所以开启MSTP的设备会将PVST报文当做数据报文转发。在另一个并不相干的网络中，开启PVST的设备收到该报文，处理后可能导致该网络的拓扑计算出现错误。

对于这个问题，可以通过MSTP的PVST报文保护功能来解决。在MSTP模式下，设备上开启了PVST报文保护功能后，如果端口收到了PVST报文，系统就将这些端口关闭。

### 6.7.8 关闭Dispute保护功能

当端口收到指定端口发出的低优先级消息，且发送端口处于Forwarding或Learning状态时，会触发Dispute保护，阻塞端口以防止环路。

如[图19](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref479319973)所示，正常情况下，Device A是根桥，经过生成树计算后，Port B1被阻塞。如果Port A1发生单通故障，即Port A1不能发送报文，只能接收报文。Port B1在一定时间内未收到Port A1发送的BPDU，则Device B认为自己是根桥，由Port B1发送低优先级BPDU到Port A1。此时，Port A2和Port B2之间链路正常，Device B会接收到自己发送BPDU，导致产生环路。因此当链路出现单通故障后，会触发Dispute保护功能，阻塞端口，防止环路。

图19 Dispute保护触发场景

![img](https://resource.h3c.com/cn/201910/25/20191025_4562955_x_Img_x_png_22_1238957_30005_0.png)

 

在如[图20](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref479319974)所示的VLAN组网的场景中，需要关闭Dispute保护功能，防止链路被阻塞。Device A和Device C开启生成树功能，Device B关闭生成树功能，此时Devcie B会透传BPDU。由于Device B上Port B1的配置，导致Device C不能收到根桥Device A发送的VLAN 1的高优先级BPDU。Device C在一定时间内未收到根桥发送的BPDU，则Device C认为自己是根桥，由Port C1发送VLAN 100的低优先级BPDU到Device A。Device A收到低优先级BPDU后，会触发Dispute保护阻塞端口，导致用户业务流量中断。为了保证业务流量正常处理，用户可以关闭Dispute保护功能，避免链路被生成树阻塞而影响用户业务。

图20 关闭Dispute保护功能使用场景

![img](https://resource.h3c.com/cn/201910/25/20191025_4562956_x_Img_x_png_23_1238957_30005_0.png)

 

# 7 典型组网应用

## 7.1 MSTP典型组网应用

MSTP可以使得同一组网中的不同VLAN的报文按照不同的生成树进行转发，从而实现不同VLAN数据的负载分担和冗余备份。

图21 MSTP典型组网图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562957_x_Img_x_png_24_1238957_30005_0.png)

 

如[图21](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref331342741)所示，Switch A和Switch B为汇聚层设备，Switch C和Switch D为接入层设备。为了合理均衡各条链路上的流量，可以在设备上按照下列思路进行配置：

·   所有设备属于同一个MST域；

·   VLAN 10的报文沿着实例1转发，实例1的根桥为Switch A；

·   VLAN 20的报文沿着实例2转发，实例2的根桥为Switch B；

·   VLAN 30的报文沿着实例3转发，实例3的根桥为Switch A；

·   VLAN 40的报文沿着实例4转发，实例4的根桥为Switch B。

MSTP计算完成后，不同VLAN流量的转发路径如[图22](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SCSXY_White_Paper-6W100/?CHID=949100#_Ref331342764)所示，这样可以大大减少各链路的负载。同时，每个VLAN都有一条冗余备份链路，当前工作链路失效后，冗余备份链路会马上生效，大大减小由于链路故障而导致的流量丢失。

图22 流量转发路径图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562958_x_Img_x_png_25_1238957_30005_0.png)

 

对于上述组网，也可以部署PVST协议来达到同样负载分担和链路备份的目的。配置如下：

·   VLAN 10的根桥为Switch A；

·   VLAN 20的根桥为Switch B；

·   VLAN 30的根桥为Switch A；

·   VLAN 40的根桥为Switch B。

# 8 参考文献

·   IEEE 802.1D：Media Access Control (MAC) Bridges

·   IEEE 802.1w：Part 3: Media Access Control (MAC) Bridges—Amendment 2: Rapid Reconfiguration

·   IEEE 802.1s：Virtual Bridged Local Area Networks—Amendment 3: Multiple Spanning Trees

·   IEEE 802.1Q-REV/D1.3：Media Access Control (MAC) Bridges and Virtual Bridged Local Area Networks—Clause 13: Spanning tree Protocol

# MSTP快速配置指南

## 1.1 简介

本案例介绍MSTP（Multiple Spanning Tree Protocol，多生成树协议）的配置方法。

## 1.2 组网需求

如[图1](https://www.h3c.com/cn/d_202303/1816250_30005_0.htm#_Ref79767989)所示：

·   网络中所有设备都属于同一个MST域，设备的端口均允许VLAN 11～30通过。

·   Device A和Device B为核心层设备，Device C和Device D为汇聚层设备。

·   假定所有端口路径开销相同。

要求通过配置MSTP功能，实现：

·   网络中无二层环路。

·   Device C和Device D的VLAN 11～20报文、VLAN 21～30报文沿不同链路分别上行到Device A和Device B，实现流量负载分担和链路备份。

图1 MSTP配置组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774718_x_Img_x_png_0_1816250_30005_0.png)

 

## 1.3 配置思路

要使所有设备属于同一MST域，在所有设备上配置相同的如下参数：

·   生成树的工作模式（缺省为MSTP模式，无需配置）

·   域名（本例配置为test）

·   修订级别（缺省为0，无需配置）

·   VLAN映射表（本例将VLAN 11～20映射到MSTI 1，VLAN 21～30映射到MSTI 2）

·   为了使MSTI 1和MSTI 2拓扑中的上行链路不同并互相作为冗余备份，配置Device A为MSTI 1的根桥，Device B为MSTI  2的根桥。另外，本例中配置Device A、B、C、D在MSTI 0的优先级依次降低，使Device  A成为IST域根。形成的多个生成树实例拓扑如[1.3 图2](https://www.h3c.com/cn/d_202303/1816250_30005_0.htm#_Ref357329071)所示。

图2 各VLAN对应的生成树实例的拓扑

![img](https://resource.h3c.com/cn/202303/28/20230328_8774719_x_Img_x_png_1_1816250_30005_0.png)

 

## 1.4 配置步骤

#### 1. Device A的配置

<DeviceA> system-view

[DeviceA] vlan 11 to 30

[DeviceA] interface range gigabitethernet 1/0/1 to gigabitethernet 1/0/3

[DeviceA-if-range] port link-type trunk

[DeviceA-if-range] port trunk permit vlan 11 to 30

[DeviceA-if-range] quit

\# 配置MST域的域名为test，将VLAN 11～20映射到MSTI 1，VLAN 21～30映射到MSTI 2。

[DeviceA] stp region-configuration

[DeviceA-mst-region] region-name test

[DeviceA-mst-region] instance 1 vlan 11 to 20

[DeviceA-mst-region] instance 2 vlan 21 to 30

[DeviceA-mst-region] active region-configuration

[DeviceA-mst-region] quit

\# 配置本设备为MSTI 0和1的根桥。

[DeviceA] stp instance 0 to 1 root primary

\# 全局开启生成树协议。

[DeviceA] stp global enable

\# 保存配置。

[DeviceA] save force

#### 2. Device B的配置

\# 创建VLAN 11～30。将设备的各端口配置为Trunk端口并允许VLAN 11～30通过。

<DeviceB> system-view

[DeviceB] vlan 11 to 30

[DeviceB] interface range gigabitethernet 1/0/1 to gigabitethernet 1/0/3

[DeviceB-if-range] port link-type trunk

[DeviceB-if-range] port trunk permit vlan 11 to 30

[DeviceB-if-range] quit

\# 配置MST域的域名为test，将VLAN 11～20映射到MSTI 1，VLAN 21～30映射到MSTI 2。

[DeviceB] stp region-configuration

[DeviceB-mst-region] region-name test

[DeviceB-mst-region] instance 1 vlan 11 to 20

[DeviceB-mst-region] instance 2 vlan 21 to 30

[DeviceB-mst-region] active region-configuration

[DeviceB-mst-region] quit

\# 配置本设备为MSTI 2的根桥，以及MSTI 0的备份根桥。

[DeviceB] stp instance 2 root primary

[DeviceB] stp instance 0 root secondary

\# 全局开启生成树协议。

[DeviceB] stp global enable

\# 保存配置。

[DeviceB] save force

#### 3. Device C的配置

\# 创建VLAN 11～30。将设备的各端口配置为Trunk端口并允许VLAN 11～30通过。

<DeviceC> system-view

[DeviceC] vlan 11 to 30

[DeviceC] interface range gigabitethernet 1/0/1 to gigabitethernet 1/0/2

[DeviceC-if-range] port link-type trunk

[DeviceC-if-range] port trunk permit vlan 11 to 30

[DeviceC-if-range] quit

\# 配置MST域的域名为test，将VLAN 11～20映射到MSTI 1，VLAN 21～30映射到MSTI 2。

[DeviceC] stp region-configuration

[DeviceC-mst-region] region-name test

[DeviceC-mst-region] instance 1 vlan 11 to 20

[DeviceC-mst-region] instance 2 vlan 21 to 30

[DeviceC-mst-region] active region-configuration

[DeviceC-mst-region] quit

\# 全局开启生成树协议。

[DeviceC] stp global enable

\# 保存配置。

[DeviceC] save force

#### 4. Device D的配置

\# 创建VLAN 11～30。将设备的各端口配置为Trunk端口并允许VLAN 11～30通过。

<DeviceD> system-view

[DeviceD] vlan 11 to 30

[DeviceD] interface range gigabitethernet 1/0/1 to gigabitethernet 1/0/2

[DeviceD-if-range] port link-type trunk

[DeviceD-if-range] port trunk permit vlan 11 to 30

[DeviceD-if-range] quit

\# 配置MST域的域名为test，将VLAN 11～20映射到MSTI 1，VLAN 21～30映射到MSTI 2。

[DeviceD] stp region-configuration

[DeviceD-mst-region] region-name test

[DeviceD-mst-region] instance 1 vlan 11 to 20

[DeviceD-mst-region] instance 2 vlan 21 to 30

[DeviceD-mst-region] active region-configuration

[DeviceD-mst-region] quit

\# 配置本设备在MSTI 0的优先级为36864，从而使本设备在MSTI 0的优先级低于Device C（Device C使用缺省优先级32768）。

[DeviceD] stp instance 0 priority 36864

\# 全局开启生成树协议。

[DeviceD] stp global enable

\# 保存配置。

[DeviceD] save force

## 1.5 验证配置

#### 1. 查看生成树实例拓扑信息

\# 查看Device A上生成树的简要信息。

[DeviceA] display stp brief

 MST ID  Port                Role STP State  Protection

 0    GigabitEthernet1/0/1        DESI FORWARDING NONE

 0    GigabitEthernet1/0/2        DESI FORWARDING NONE

 0    GigabitEthernet1/0/3        DESI FORWARDING NONE

 1    GigabitEthernet1/0/1        DESI FORWARDING NONE

 1    GigabitEthernet1/0/2        DESI FORWARDING NONE

 1    GigabitEthernet1/0/3        DESI FORWARDING NONE

 2    GigabitEthernet1/0/1        ALTE FORWARDING NONE

 2    GigabitEthernet1/0/2        DESI FORWARDING NONE

 2    GigabitEthernet1/0/3        ROOT FORWARDING NONE

\# 查看Device B上生成树的简要信息。

[DeviceB] display stp brief

 MST ID  Port                Role STP State  Protection

 0    GigabitEthernet1/0/1        DESI FORWARDING NONE

 0    GigabitEthernet1/0/2        DESI FORWARDING NONE

 0    GigabitEthernet1/0/3        ROOT FORWARDING NONE

 1    GigabitEthernet1/0/1        DESI FORWARDING NONE

 1    GigabitEthernet1/0/2        ALTE FORWARDING NONE

 1    GigabitEthernet1/0/3        ROOT FORWARDING NONE

 2    GigabitEthernet1/0/1        DESI FORWARDING NONE

 2    GigabitEthernet1/0/2        DESI FORWARDING NONE

 2    GigabitEthernet1/0/3        DESI FORWARDING NONE

\# 查看Device C上生成树的简要信息。

[DeviceC] display stp brief

 MST ID  Port                Role STP State  Protection

 0    GigabitEthernet1/0/1        ROOT FORWARDING NONE

 0    GigabitEthernet1/0/2        ALTE DISCARDING NONE

 1    GigabitEthernet1/0/1         ROOT FORWARDING NONE

 1    GigabitEthernet1/0/2        DESI DISCARDING NONE

 2    GigabitEthernet1/0/1        DESI DISCARDING NONE

 2    GigabitEthernet1/0/2        ROOT FORWARDING NONE 

\# 查看Device D上生成树的简要信息。

[DeviceD] display stp brief

 MST ID  Port                Role STP State  Protection

 0    GigabitEthernet1/0/1        ALTE DISCARDING NONE

 0    GigabitEthernet1/0/2        ROOT FORWARDING NONE

 1    GigabitEthernet1/0/1        ALTE DISCARDING NONE

 1    GigabitEthernet1/0/2        ROOT FORWARDING NONE

 2    GigabitEthernet1/0/1        ROOT FORWARDING NONE

 2    GigabitEthernet1/0/2        ALTE DISCARDING  NONE

根据上述显示信息中的Alternate端口（阻塞端口），可以绘出各VLAN所对应MSTI的拓扑，
 如[1.5 1. 图3](https://www.h3c.com/cn/d_202303/1816250_30005_0.htm#_Ref391473105)所示。

图3 MSTI 0～2的拓扑

![img](https://resource.h3c.com/cn/202303/28/20230328_8774720_x_Img_x_png_2_1816250_30005_0.png)

 

可以看到，Device C和Device D的VLAN 11～20报文和VLAN 21～30报文沿不同的上行链路转发；网络中无二层环路。

#### 2. 验证链路备份功能

\# 关闭Device C的端口GigabitEthernet1/0/1（这是Device C在MSTI 0～1中的上行链路所在端口）。

[DeviceC] interface gigabitethernet 1/0/1

[DeviceC-GigabitEthernet1/0/1] shutdown

\# 查看Device A、B、C、D上生成树的简要信息。

[DeviceA] display stp brief

 MST ID  Port                Role STP State  Protection

 0    GigabitEthernet1/0/2        DESI FORWARDING NONE

 0    GigabitEthernet1/0/3        DESI FORWARDING NONE

 1    GigabitEthernet1/0/2        DESI FORWARDING NONE

 1    GigabitEthernet1/0/3        DESI FORWARDING NONE

 2    GigabitEthernet1/0/2        DESI FORWARDING NONE

 2    GigabitEthernet1/0/3        ROOT FORWARDING NONE

[DeviceB] display stp brief

 MST ID  Port                Role STP State  Protection

 0    GigabitEthernet1/0/1        DESI FORWARDING NONE

 0    GigabitEthernet1/0/2        DESI FORWARDING NONE

 0    GigabitEthernet1/0/3        ROOT FORWARDING NONE

 1    GigabitEthernet1/0/1        DESI FORWARDING NONE

 1    GigabitEthernet1/0/2        DESI FORWARDING NONE

 1    GigabitEthernet1/0/3        ROOT FORWARDING NONE

 2    GigabitEthernet1/0/1        DESI FORWARDING NONE

 2    GigabitEthernet1/0/2        DESI FORWARDING NONE

 2    GigabitEthernet1/0/3        DESI FORWARDING NONE

[DeviceC] display stp brief

 MST ID  Port                   Role STP State  Protection

 0    GigabitEthernet1/0/2        ROOT FORWARDING NONE

 1    GigabitEthernet1/0/2        ROOT FORWARDING NONE

 2    GigabitEthernet1/0/2        ROOT FORWARDING NONE

[DeviceD] display stp brief

 MST ID  Port                Role STP State  Protection

 0    GigabitEthernet1/0/1        ALTE DISCARDING NONE

 0    GigabitEthernet1/0/2        ROOT FORWARDING NONE

 1    GigabitEthernet1/0/1         ALTE DISCARDING NONE

 1    GigabitEthernet1/0/2        ROOT FORWARDING NONE

 2    GigabitEthernet1/0/1        ROOT FORWARDING NONE

 2    GigabitEthernet1/0/2        ALTE DISCARDING NONE

根据上述显示信息中的Alternate端口（阻塞端口），可以绘出各VLAN所对应MSTI的拓扑，
 如[2. 图4](https://www.h3c.com/cn/d_202303/1816250_30005_0.htm#_Ref391475735)所示。

图4 某链路断开后MSTI 0～2的拓扑

![img](https://resource.h3c.com/cn/202303/28/20230328_8774721_x_Img_x_png_3_1816250_30005_0.png)

 

可以看到，Device C在MSTI 0～1中的上行链路所在端口已从原先的GigabitEthernet1/0/1切换为GigabitEthernet1/0/2。

## 1.6 配置文件

·   Device A： 

\#

vlan 1

\#

vlan 11 to 30

\#

stp region-configuration

 region-name test

 instance 1 vlan 11 to 20

 instance 2 vlan 21 to 30

 active region-configuration

\#

 stp instance 0 to 1 root primary

 stp global enable

\#

interface GigabitEthernet1/0/1

 port link-mode bridge

 port link-type trunk

 port trunk permit vlan 1 11 to 30

\#

interface GigabitEthernet1/0/2

 port link-mode bridge

 port link-type trunk

 port trunk permit vlan 1 11 to 30

\#

interface GigabitEthernet1/0/3

 port link-mode bridge

 port link-type trunk

 port trunk permit vlan 1 11 to 30

·   Device B ：

\#

vlan 1

\#

vlan 11 to 30

\#

stp region-configuration

 region-name test

 instance 1 vlan 11 to 20

 instance 2 vlan 21 to 30

 active region-configuration

\#

 stp instance 0 root secondary

 stp instance 2 root primary

 stp global enable

\#

interface GigabitEthernet1/0/1

 port link-mode bridge

 port link-type trunk

 port trunk permit vlan 1 11 to 30

\#

interface GigabitEthernet1/0/2

 port link-mode bridge

 port link-type trunk

 port trunk permit vlan 1 11 to 30

\#

interface GigabitEthernet1/0/3

 port link-mode bridge

 port link-type trunk

 port trunk permit vlan 1 11 to 30

·   Device C： 

\#

vlan 1

\#

vlan 11 to 30

\#

stp region-configuration

 region-name test

 instance 1 vlan 11 to 20

 instance 2 vlan 21 to 30

 active region-configuration

\#

 stp global enable

\#

interface GigabitEthernet1/0/1

 port link-mode bridge

 port link-type trunk

 port trunk permit vlan 1 11 to 30

\#

interface GigabitEthernet1/0/2

 port link-mode bridge

 port link-type trunk

 port trunk permit vlan 1 11 to 30

·   Device D ：

\#

vlan 1

\#

vlan 11 to 30

\#

stp region-configuration

 region-name test

 instance 1 vlan 11 to 20

 instance 2 vlan 21 to 30

 active region-configuration

\#

 stp instance 0 priority 36864

 stp global enable

\#

interface GigabitEthernet1/0/1

 port link-mode bridge

 port link-type trunk

 port trunk permit vlan 1 11 to 30

\#

interface GigabitEthernet1/0/2

 port link-mode bridge

 port link-type trunk

 port trunk permit vlan 1 11 to 30