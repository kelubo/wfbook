# Smart Link概述

## 1.1 产生背景

Smart Link用于双上行组网中实现主备链路的冗余备份，并提供亚秒级的快速链路切换。如[图1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/Smart_Link_Monitor_Link_White_Paper-6W100/?CHID=949153#_Ref206473765)所示，在Device C和Device D上采用Smart Link功能，可以实现主用上行链路故障时，将流量快速切换到备用上行链路。

图1 Smart Link应用场景示意图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562904_x_Img_x_png_0_1238955_30005_0.png)

 

虽然双上行组网可以提供链路备份，但网络中的环路会引起广播风暴，因此，需要采取措施避免环路。一般情况下，可以通过STP（Spanning Tree Protocol，生成树协议）来消除环路，但STP的收敛时间较长，会丢失较多流量，不适用于对收敛时间有很高要求的组网环境。另一种高效的环网解决方案RRPP（Rapid Ring Protection Protocol，快速环网保护协议）虽然可以提高收敛性能，但是RRPP主要适用于较复杂的环形组网，且配置复杂度较高。基于上述原因，H3C提出了Smart Link技术解决方案。

## 1.2 技术优点

Smart Link是一种为双上行组网量身定做的解决方案，具有如下优点：

·   能够实现在双上行组网的两条链路正常情况下，只有一条处于连通状态，而另一条处于阻塞状态，从而防止了环路引起的广播风暴。

·   当主用链路发生故障后，流量会在亚秒级的时间内迅速切换到备用链路上，保证了数据的正常转发。

# 2 Smart Link技术实现

## 2.1 概念介绍

### 2.1.1 Smart Link组

Smart Link组也称为灵活链路组，一个Smart Link组包含两个成员端口，其中一个被指定为主端口（Primary Port），另一个被指定为从端口（Secondary Port），不同的Smart Link组可以包含同一个端口。正常情况下，只有一个端口（主端口或从端口）处于转发（ACTIVE）状态，另一个端口被阻塞（BLOCK），处于待命（STANDBY）状态。当处于转发状态的端口发生链路故障（链路故障目前主要是指端口状态转为DOWN、以太网OAM链路故障等）时，Smart Link组会自动将该端口阻塞，并将原阻塞的处于待命状态的端口切换到转发状态。

图2 Smart Link技术应用场景图

 ![img](https://resource.h3c.com/cn/201910/25/20191025_4562905_x_Img_x_png_1_1238955_30005_0.png)

 

如[图2](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/Smart_Link_Monitor_Link_White_Paper-6W100/?CHID=949153#_Ref520215120)所示，Device C的端口Port A和Port B组成了一个Smart Link组，端口Port A处于转发状态，端口Port B处于阻塞状态。Device D的端口Port A和Port B组成了另外一个Smart Link组，端口Port B处于阻塞状态，端口Port A处于转发状态。

### 2.1.2 主端口

主端口（Primary Port）是通过命令行指定的Smart Link组的一种端口角色。Smart Link组的主端口可以是以太网端口（电口或光口），也可以是聚合接口。

如[图2](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/Smart_Link_Monitor_Link_White_Paper-6W100/?CHID=949153#_Ref520215120)所示，Device C的Smart Link组中处于转发状态的端口Port A是主端口。

### 2.1.3 从端口

从端口（Secondary Port）是通过命令行指定的Smart Link组的另外一种端口角色。Smart Link组的从端口可以是以太网端口（电口或光口），也可以是聚合接口。从端口所在的链路也被称为从链路。

如[图2](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/Smart_Link_Monitor_Link_White_Paper-6W100/?CHID=949153#_Ref520215120)所示，Device C的Smart Link组中被阻塞的端口Port B是从端口。

### 2.1.4 保护VLAN

保护VLAN是Smart Link组内承载数据流量的用户数据VLAN。端口可以加入多个Smart Link组，这些Smart Link组的保护VLAN不同。各Smart Link组分别独立计算组内端口的转发状态。

如[图3](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/Smart_Link_Monitor_Link_White_Paper-6W100/?CHID=949153#_Ref16688035)所示，Device C上可以创建Smart Link组1和Smart Link组2，两个Smart Link组分别保护不同的VLAN，Smart Link组1保护VLAN 1～10，Smart Link组2保护VLAN 11～20，这样就可以控制两组VLAN的流量分别通过不同的端口上行。

图3 Smart Link组保护VLAN示意图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562910_x_Img_x_png_2_1238955_30005_0.png)

 

### 2.1.5 Flush报文

当Smart Link组发生链路切换时，原有的转发表项已经不再适用于新的拓扑网络，需要对整网进行MAC地址转发表项和ARP表项的更新。Smart Link通过Flush报文来通知其他设备进行表项的刷新操作。

Flush报文采用IEEE802.3封装，包括Destination MAC、Source MAC、Control VLAN ID和VLAN Bitmap等信息字段。Flush报文格式如[图4](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/Smart_Link_Monitor_Link_White_Paper-6W100/?CHID=949153#_Ref520215664)所示。

图4 Flush报文格式

![img](https://resource.h3c.com/cn/201910/25/20191025_4562911_x_Img_x_png_3_1238955_30005_0.png)

 

·   Destination MAC为未知组播地址。可以通过判断该地址是否为0x010F-E200-0004来区分该报文是否为Flush报文。

·   Source MAC表示发送Flush报文的设备的接口MAC地址，如果该接口没有MAC地址，则使用二层协议的缺省MAC地址。

·   Control Type表示控制类型。目前只有删除MAC地址转发表项和ARP表项一种（0x01）。

·   Control Version表示版本号。当前版本号为0x00，用于后续版本的扩展。

·   Device ID表示发送Flush报文的设备的桥MAC地址。

·   Control VLAN ID表示发送控制VLAN的ID号。

·   Auth-mode表示认证模式，和Password一起使用，便于以后进行安全性扩展。

·   VLAN Bitmap表示VLAN位图，用于携带需要刷新地址表的VLAN列表。

·   FCS表示帧校验和，用于检查报文的合法性。

### 2.1.6 控制VLAN

#### 1. 发送控制VLAN

发送控制VLAN（Control VLAN）是Smart Link组用于广播发送Flush报文的VLAN。

设备上开启了Flush报文发送功能后，当Smart Link组发生主备链路切换时，设备会从新的转发链路上在发送控制VLAN内广播发送Flush报文。

#### 2. 接收控制VLAN

接收控制VLAN是上游设备用于接收并处理Flush报文的VLAN。

上游设备开启了Flush报文发送功能后，当发生链路切换时，上游设备会处理收到的属于接收控制VLAN的Flush报文，进而执行MAC地址转发表项和ARP表项的刷新操作。

## 2.2 Smart Link的工作机制

### 2.2.1 链路正常工作机制

双上行链路都正常的情况下，主端口处于转发状态，所在的链路是主链路，从端口处于待命状态，所在链路是从链路。数据在主链路进行传输，网络中不存在环路，避免产生广播风暴。

### 2.2.2 链路故障处理机制

当主链路发生故障时，主端口切换到待命状态，从端口切换到转发状态。此时，网络中各设备上的MAC地址转发表项和ARP表项可能已经错误，需要提供一种MAC地址转发表项和ARP表项更新的机制，完成流量的快速切换，以免造成流量丢失。目前更新机制有以下两种。

#### 1. 通过Flush报文通知设备更新表项

这种方式适用于上游设备（如[2.2.2 1. 图5](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/Smart_Link_Monitor_Link_White_Paper-6W100/?CHID=949153#_Ref16693182)中的Device A、Device B和Device D）支持Smart Link功能，能够识别Flush报文的情况。

图5 Smart Link运行机制示意图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562912_x_Img_x_png_4_1238955_30005_0.png)

为了实现快速链路切换，需要在Device C上开启Flush报文发送功能，在上游设备所有处于双上行网络上的端口开启接收处理Flush报文功能。

(2)   Device C发生链路切换后，会从新的转发链路上发送Flush报文，即从端口Port B发送Flush报文。Flush报文的VLAN Bitmap字段填充链路切换前组内处于转发状态的Port A所在Smart Link组的保护VLAN ID，Control VLAN ID字段填充Smart Link组配置的发送控制VLAN ID。

(3)   当上游设备收到Flush报文时，判断该Flush报文的发送控制VLAN是否在收到报文的端口配置的接收控制VLAN列表中。如果不在接收控制VLAN列表中，设备对该Flush报文不做处理，直接转发；如果在接收控制VLAN列表中，设备将提取Flush报文中的VLAN Bitmap数据，将设备在这些VLAN内学习到的MAC转发表项及ARP表项删除。

此后，如果Device A收到目的设备为Device C的数据报文，对于需要进行二层转发的报文，Device A会通过二层广播方式进行转发；对于需要进行三层转发的报文，设备会通过ARP探测方式先更新ARP表项，然后将报文转发出去。这样，数据流量就可以正确地进行发送。

通过Flush报文通知设备更新的机制无须等到表项老化后再进行更新，可以大大减少表项更新所需时间。一般情况下，链路的整个切换过程可在毫秒级的时间内完成的，基本无流量丢失。

![说明: 说明](https://resource.h3c.com/cn/201910/25/20191025_4562913_x_Img_x_png_5_1238955_30005_0.png)

·   为了保证Flush报文在发送控制VLAN内正确传送，请确保双上行网络上的所有端口都属于发送控制VLAN。否则，Flush报文将发送或转发失败。

·   建议用户以保留Tag的方式发送Flush报文，若想以去掉Tag的方式发送Flush报文，需确保对端端口缺省VLAN和发送控制VLAN一致，否则将导致Flush报文不在发送控制VLAN内传送。

 

#### 2. 自动通过流量更新表项

这种方式适用于与不支持Smart Link功能的设备（包括其他厂商设备）对接的情况，需要有上行流量触发。

·   如果没有来自Device C的上行流量去触发Device A的MAC及ARP表项更新，那么当Device A收到目的设备为Device C的数据报文时，Device A仍会通过Port A转发出去，但报文已经不能到达Device C，流量中断，直到其MAC或ARP表项自动老化。

·   如果Device C有上行流量要发送，但由于Device C的MAC及ARP表项也是错误的，所以直到其表项自动老化、重新学习后，流量才能被发送出去。当上行流量通过Port B到达设备Device A后，Device A会更新自己的MAC及ARP表项，那么当Device A再收到目的设备为Device C的数据报文时，Device A会通过Port B转发出去，报文就可以经由Device D到达Device C。

### 2.2.3 链路恢复处理机制 

Smart Link组支持抢占模式和非抢占模式，不同模式下的链路恢复机制不同：

·   如果Smart Link组配置为抢占模式：

¡   Smart Link组配置为角色抢占模式，当主链路故障恢复后，主端口将抢占为转发状态，从端口则进入待命状态。只有当主链路故障时，从端口才会从待命状态切换到转发状态。

¡   Smart Link组配置为角色速率抢占模式：

\-   指定速率抢占阈值（**threshold** *threshold-value*）时，如果主从端口的接口速率差值大于等于接口速率较小值的threshold-value%，则接口速率大的端口为转发状态。

\-   未指定速率抢占阈值时，接口速率大的端口为转发状态。

·   如果Smart Link组配置为非抢占模式，当主链路故障恢复后，从端口将继续处于转发状态，主端口继续处于待命状态，这样可以保持流量的稳定。

如[图6](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/Smart_Link_Monitor_Link_White_Paper-6W100/?CHID=949153#_Ref16687526)所示，当Device C的端口Port A的链路恢复后：

·   如果该Smart Link组配置为角色抢占模式，则端口Port B将阻塞并切换到待命状态，而端口Port A将抢占到转发状态。

·   如果配置为非抢占模式，端口Port A仍将继续处于待命状态，不进行流量切换，从而保持流量稳定。

图6 Smart Link链路恢复处理机制示意图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562914_x_Img_x_png_6_1238955_30005_0.png)

 

## 2.3 通过Smart Link实现流量的负载分担

在同一个双上行链路组网中，可能同时存在多个VLAN的数据流量，Smart Link可以实现流量的负载分担，即不同VLAN的流量沿不同的路径进行转发。通过把上行链路的端口分别配置为两个Smart Link组的成员（每个Smart Link组的保护VLAN不同），且端口在不同组中的转发状态不同，这样就能实现不同Smart Link组保护VLAN的流量转发路径不同，从而达到负载分担的目的。

如[图7](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/Smart_Link_Monitor_Link_White_Paper-6W100/?CHID=949153#_Ref16685580)所示，在Device C上创建两个Smart Link组，每个Smart Link组保护的VLAN不同，但均配置为角色抢占模式。Smart Link组1的主端口为Port A，从端口为Port B，保护VLAN为VLAN 1～10；Smart Link组2的主端口为Port B，从端口为Port A，保护VLAN为VLAN 11～20。两个Smart Link组中的主端口均处于转发状态。这样，VLAN 1～10的流量将沿着蓝色线条所表示的链路进行传输，VLAN 11～20的流量将沿着红色线条所表示的链路进行传输，从而实现VLAN流量的负载分担。

图7 Smart Link负载分担机制示意图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562915_x_Img_x_png_7_1238955_30005_0.png)

 

在实现负载分担时，建议将Smart Link组配置为角色抢占模式或速率抢占模式，否则无法保证流量按照用户的想法一直在两条链路上进行分担。因为，如果配置为非抢占模式，刚开始可以实现流量分流，但链路故障后所有流量将集中在同一条链路上传输，链路恢复后流量继续在同一条链路上传输，这样就无法达到负载分担的目的。

## 2.4 应用限制

·   开启了STP和RRPP功能的端口不能作为Smart Link组的成员端口。

·   聚合组成员端口和业务环回组成员端口不能作为Smart Link组的成员端口。

# 3 Monitor Link概述

## 3.1 产生背景

Monitor Link是一种接口联动方案，通过监控设备的上行接口，根据其up/down状态的变化来触发下行接口up/down状态的变化，从而触发下游设备上的拓扑协议进行链路的切换。

图8 Monitor Link技术产生背景组网图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562916_x_Img_x_png_8_1238955_30005_0.png)

 

如[图8](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/Smart_Link_Monitor_Link_White_Paper-6W100/?CHID=949153#_Ref520215938)所示，Device C上配置了Smart Link功能用于链路冗余备份，Port A为主端口，Port B为从端口。当端口Port A所在主链路出现故障时，流量在毫秒级的时间内切换到端口Port B所在的从链路上，从而实现了高效可靠的链路备份和快速收敛性能。

但是，当Device B的上行接口Port A所在链路出现故障时，配置Smart Link组的设备Device C由于其主端口Port A所在链路并未发生故障，所以此时不会出现Smart Link组内的链路切换。但实际上Device C上的流量已经无法通过端口Port A的链路上行到Device A，流量就此中断。为了解决这类问题，Monitor Link技术应运而生。

## 3.2 技术优点

Monitor Link是对Smart Link技术的有力补充。Monitor Link用于监控上行链路，以达到让下行链路同步上行链路状态的目的，使Smart Link的备份作用更加完善。

# 4 Monitor Link技术实现

## 4.1 概念介绍

### 4.1.1 Monitor Link组

Monitor Link组也称为监控链路组，由一个或多个上行和下行接口组成。下行接口的状态随上行接口状态的变化而变化。如[图9](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/Smart_Link_Monitor_Link_White_Paper-6W100/?CHID=949153#_Ref520216018)所示，Device A的端口Port A、Port B和Port C组成了一个Monitor Link组。

图9 Monitor Link概念介绍示意图

 ![img](https://resource.h3c.com/cn/201910/25/20191025_4562917_x_Img_x_png_9_1238955_30005_0.png)

 

### 4.1.2 上行接口

上行接口（Uplink Port）是Monitor Link组中的监控对象，是通过命令行指定的Monitor Link组的一种端口角色。Monitor Link组的上行接口可以是以太网端口（电口或光口）或聚合接口。

如[图9](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/Smart_Link_Monitor_Link_White_Paper-6W100/?CHID=949153#_Ref520216018)所示，Device A的端口Port A为该设备上配置的Monitor Link组的上行接口。

如果多个端口被配置为Monitor Link组的上行接口，则Monitor Link组的下行接口状态由处于up状态的上行接口个数决定：

·   Monitor Link组中状态为up的上行接口个数小于上行接口阈值时，Monitor Link组就处于down状态，并将强制使其所有下行接口的状态都变为down。

·   Monitor Link组中状态为up的上行接口个数大于或等于上行接口阈值时，Monitor Link组的状态就恢复为up，并使其所有下行接口的状态都恢复为up。

·   当Monitor Link组的上行接口未指定时，则认为上行接口故障，所有下行接口都将被关闭。

### 4.1.3 下行接口

下行接口（Downlink Port）是Monitor Link组中的监控者，是通过命令行指定的Monitor Link组的另外一种端口角色。Monitor Link组的下行接口可以是以太网端口（电口或光口）或聚合接口。

如[图9](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/Smart_Link_Monitor_Link_White_Paper-6W100/?CHID=949153#_Ref520216018)所示，Device A的端口Port B和Port C为该设备上配置的Monitor Link组的两个下行接口。

当Monitor Link组的上行接口恢复正常时，Monitor Link只会开启由上行接口故障而阻塞的下行接口，不能开启手工关闭的下行接口。并且某个下行接口故障对上行接口和其他下行接口没有影响。

 

## 4.2 运行机制

如[图10](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/Smart_Link_Monitor_Link_White_Paper-6W100/?CHID=949153#_Ref520216058)所示，在Device C上配置了Smart Link组。其中，Port A为主端口处于转发状态，Port B为从端口。为了防止出现因Device B的端口Port A所在链路故障所引起Device C的流量无法上行的现象，在Device B上配置了Monitor Link组，并指定端口Port A为上行接口，Port B为下行接口。

图10 Monitor Link运行机制示意图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562906_x_Img_x_png_10_1238955_30005_0.png)

 

当Device B的上行接口Port A所在链路出现故障时，Monitor Link组强制关闭该组的下行接口Port B，从而触发Device C上Smart Link组的链路切换。

当Device B的上行接口Port A所在链路故障恢复时，下行接口Port B也将被开启，如果Device C上Smart Link组配置为角色抢占模式，则同样会触发Device C上Smart Link组的链路切换，否则等待下一次链路切换。

这样，Monitor Link技术配合Smart Link技术实现了高效可靠的链路备份和快速收敛性能。

## 4.3 应用限制

聚合组成员端口和业务环回组成员端口不能作为Monitor Link组的成员端口。

# 5 典型组网应用

## 5.1 Smart Link与Monitor Link配合组网

如[图11](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/Smart_Link_Monitor_Link_White_Paper-6W100/?CHID=949153#_Ref520216088)所示，典型的双上行组网是Smart Link及Monitor Link技术的主要应用场景。

图11 Smart Link与Monitor Link配合组网图

 ![img](https://resource.h3c.com/cn/201910/25/20191025_4562907_x_Img_x_png_11_1238955_30005_0.png) 

 

在该组网环境中，通过在Device C和Device D配置多个Smart Link组并保护不同的VLAN，这些VLAN的流量分别沿双上行链路的不同路径转发，实现负载分担的目的。当Device B与Device C或Device D与Device E之间的链路出现故障时，Smart Link组迅速感知并进行链路的切换。为了使Device C（或Device D）能直接感知Device A与Device B（或Device E）之间的链路故障，还需要在Device B（或Device E）上配置了Monitor Link组，端口Port A作为上行接口，端口Port B和Port C分别作为对应的下行接口。

Monitor Link组一旦检测到上行接口所在链路故障，将强制关闭下行接口，从而触发Device C和Device D上的Smart Link组内的链路切换。当上行接口或链路故障恢复时，下行接口将自动开启，从而使Device C（或Device D）能够迅速感知Device A与Device B（或Device E）之间链路状态的变化。

## 5.2 Smart Link与Monitor Link级联组网

在如[图12](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/Smart_Link_Monitor_Link_White_Paper-6W100/?CHID=949153#_Ref520216130)所示的组网中，通过使用Smart Link及Monitor Link技术进行备用链路的级联，可以达到更加可靠的链路备份的目的。

具体的实现方法为：将一个Smart Link组所有成员端口作为一个Monitor Link组的上行接口，而该Monitor Link组下行接口的对端端口为另外一个Smart Link组的主端口或者从端口。

图12 Smart Link级联组网图

 ![img](https://resource.h3c.com/cn/201910/25/20191025_4562908_x_Img_x_png_12_1238955_30005_0.png)

 

各设备Smart Link与Monitor Link配置情况如[表1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/Smart_Link_Monitor_Link_White_Paper-6W100/?CHID=949153#_Ref520213763)所示。

表1 Smart Link与Monitor Link配置一览表

| Device       | Smart Link Group 1 | Monitor Link Group 1 |                      |        |
| ------------ | ------------------ | -------------------- | -------------------- | ------ |
| Primary Port | Secondary Port     | Uplink Port          | Downlink Port        |        |
| Device C     | Port A             | Port B               | Port A、Port B       | Port C |
| Device J     | Port A             | Port B               | Port A、Port B       | Port C |
| Device F     | Port A             | Port B               | 未创建Monitor Link组 |        |

 

## 5.3 Smart Link与RRPP混合组网

在如[图13](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/Smart_Link_Monitor_Link_White_Paper-6W100/?CHID=949153#_Ref520216170)所示的组网中，Smart Link和RRPP混合应用。其中，Device A、Device B、Device D和Device E上开启了RRPP协议提供链路冗余备份，Device C上配置Smart Link组。

如果通过配置STP来实现链路备份的话，要求Device B、Device D和Device C相连的所有端口都开启STP功能。因为Device B和Device D相连的两个端口已经开启了RRPP功能，不能再开启STP 功能，所以Device C上的链路备份可以通过配置Smart Link组来实现，这样比在Device B、Device C和Device D上配置RRPP子环更简单方便，同时还适用于Device C不支持RRPP的场合。

图13 Smart Link与RRPP混合组网图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562909_x_Img_x_png_13_1238955_30005_0.png)