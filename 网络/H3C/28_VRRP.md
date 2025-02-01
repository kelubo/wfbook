# 概述

![说明](https://resource.h3c.com/cn/201911/20/20191120_4598563_x_Img_x_png_0_1244593_30005_0.png)

本文中的路由器表示网络中支持作为网关的路由器和交换机设备。

 

## 1.1 产生背景

随着Internet的发展，人们对网络可靠性的要求越来越高。特别是对于终端用户来说，能够实时与网络其他设备保持联系是非常重要的。如[图1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/VRRP_White_Paper-6W100/?CHID=949160#_Ref19777159)所示，主机通常通过设置默认网关来与外部网络联系。主机将发送给外部网络的报文发送给网关，由网关传递给外部网络，从而实现主机与外部网络的通信。

图1 常用局域网组网图

![img](https://resource.h3c.com/cn/201911/20/20191120_4598564_x_Img_x_png_1_1244593_30005_0.png)

 

正常的情况下，主机完全信赖网关的工作，但是当网关出现故障时，主机与外部的通信就会中断。要解决网络中断的问题，可以依靠再添加网关的方式解决，不过由于大多数主机只允许配置一个默认网关，此时需要网络管理员进行手工干预网络配置，才能使得主机使用新的网关进行通信。也可以通过动态路由协议（如RIP、OSPF）或IRDP来解决上述问题，然而，这些协议由于配置过于复杂、或安全性能不高等原因都不能满足用户的需求。

为了更好地解决网络中断的问题，网络开发者提出了VRRP，它既不需要改变组网情况，也不需要在主机上做任何配置，只需要在相关路由器上配置极少的几条命令，就能实现下一跳网关的备份，并且不会给主机带来任何负担。和其他方法比较起来，VRRP更加能够满足用户的需求。

## 1.2 技术优势

VRRP是一种容错协议，它保证当主机的下一跳路由器出现故障时，由另一台路由器来代替出现故障的路由器进行工作，从而保持网络通信的连续性和可靠性。

VRRP具有如下优点：

·   简化网络管理。在具有多播或广播能力的局域网（如以太网）中，借助VRRP能在某台设备出现故障时仍然提供高可靠的缺省链路，有效避免单一链路发生故障后网络中断的问题，而无需修改动态路由协议、路由发现协议等配置信息，也无需修改主机的默认网关配置。

·   适应性强。VRRP报文封装在IP报文中，支持各种上层协议。

·   网络开销小。VRRP只定义了一种报文——VRRP通告报文，并且只有处于Master状态的路由器可以发送VRRP报文。

# 2 VRRP技术实现

## 2.1 概念介绍

·   虚拟路由器：由一个Master路由器和多个Backup路由器组成。主机将虚拟路由器当作默认网关。

·   VRID：虚拟路由器的标识。具有相同VRID的一组路由器构成一个虚拟路由器。

·   Master路由器：虚拟路由器中承担报文转发任务的路由器。

·   Backup路由器：Master路由器出现故障时，能够代替Master路由器工作的路由器。

·   虚拟转发器：在VRRP负载均衡模式下，为了使备份组中的路由器能够转发主机发送的流量，需要在路由器上创建虚拟转发器。

·   虚拟IP地址：虚拟路由器的IP地址。一个虚拟路由器可以拥有一个或多个IP地址。

·   IP地址拥有者：接口IP地址与虚拟IP地址相同的路由器被称为IP地址拥有者。

·   虚拟MAC地址，取值包括：

¡   VRRP标准协议模式下，一个虚拟路由器拥有一个虚拟MAC地址。IPv4网络中，虚拟MAC地址的格式为00-00-5E-00-01-{VRID}；IPv6网络中，虚拟MAC地址的格式为00-00-5E-00-02-{VRID}。

¡   VRRP负载均衡模式下，一个虚拟转发器拥有一个虚拟MAC地址。IPv4网络中，虚拟MAC地址的格式为：00-0F-E2-FF-0{VRID}{VFID}，IPv6网络中，虚拟MAC地址的格式为：00-0F-E2-FF-4{VRID}{VFID}。

·   优先级：VRRP根据优先级来确定虚拟路由器中每台路由器的角色。

## 2.2 虚拟路由器简介

VRRP将局域网内的一组路由器划分在一起，形成一个VRRP备份组，它在功能上相当于一台虚拟路由器，使用虚拟路由器号进行标识。以下使用虚拟路由器代替VRRP备份组进行描述。

虚拟路由器有自己的虚拟IP地址和虚拟MAC地址，它的外在表现形式和实际的物理设备完全一样。局域网内的主机将虚拟路由器的IP地址设置为默认网关，通过虚拟路由器与外部网络进行通信。

虚拟路由器是工作在实际的物理设备之上的。它由多个实际的设备组成，包括一个Master路由器和多个Backup路由器。Master路由器正常工作时，局域网内的主机通过Master路由器与外界通信。当Master路由器出现故障时，所有的Backup路由器将选举出一个新的Master路由器，接替转发报文的工作，如[图2](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/VRRP_White_Paper-6W100/?CHID=949160#_Ref169961566)所示。

图2 虚拟路由器组网图

![img](https://resource.h3c.com/cn/201911/20/20191120_4598567_x_Img_x_png_2_1244593_30005_0.png)

 

## 2.3 VRRP工作过程

VRRP的工作过程为：

(1)   虚拟路由器中的路由器根据优先级选举出Master路由器。Master路由器通过发送免费ARP报文，将自己的虚拟MAC地址通知给与它连接的设备和主机，从而承担报文转发任务。

(2)   Master路由器周期性发送VRRP报文，以公布其配置信息（优先级等）和工作状况。

(3)   如果Master路由器出现故障，虚拟路由器中的Backup路由器将根据优先级重新选举新的Master路由器。

(4)   虚拟路由器状态切换时，Master路由器由一台设备切换为另一台设备，新的Master路由器会发送一个携带虚拟路由器的MAC地址和虚拟IP地址信息的免费ARP报文，使连接它的主机和设备更新ARP信息。网络中的主机和设备感知不到Master路由器已经切换到另外一台设备。

(5)   Backup路由器的优先级高于Master路由器时，由Backup路由器的工作方式（抢占方式和非抢占方式）决定是否重新选举Master：

¡   非抢占方式：如果Backup路由器工作在非抢占方式下，则只要Master路由器没有出现故障，Backup路由器即使随后被配置了更高的优先级也不会成为Master路由器。

¡   抢占方式：如果Backup路由器工作在抢占方式下，当它收到VRRP报文后，会将自己的优先级与通告报文中的优先级进行比较。如果自己的优先级比当前的Master路由器的优先级高，就会主动抢占成为Master路由器；否则，将保持Backup状态。

由此可见，为了保证Master路由器和Backup路由器能够协调工作，VRRP需要实现以下功能：

·   Master路由器的选举；

·   Master路由器状态的通告；

·   为了提高安全性，VRRP还提供了认证功能。

下面将从上述三个方面详细介绍VRRP的工作过程。

### 2.3.1 Master路由器的选举

VRRP根据优先级来确定虚拟路由器中每台路由器的角色（Master路由器或Backup路由器）。优先级越高，则越有可能成为Master路由器。

初始创建的路由器工作在Backup状态，通过VRRP报文的交互获知虚拟路由器中其他成员的优先级：

·   如果VRRP报文中Master路由器的优先级高于自己的优先级，则路由器保持在Backup状态。

·   如果VRRP报文中Master路由器的优先级低于自己的优先级，采用抢占工作方式的路由器将抢占成为Master状态，周期性地发送VRRP报文；采用非抢占工作方式的路由器仍保持Backup状态。

·   如果在一定时间内没有收到VRRP报文，则路由器切换为Master状态。

VRRP优先级的取值范围为0～255（数值越大表明优先级越高），可配置的范围是1～254。优先级0为系统保留给路由器放弃Master角色时使用，255则是系统保留给IP地址拥有者使用。当路由器为IP地址拥有者时，其优先级始终为255。因此，当虚拟路由器内存在IP地址拥有者时，只要其工作正常，其角色就一直是Master路由器。

由于网络故障原因造成VRRP备份组中存在多台Master路由器时，这些Master路由器会根据优先级和配置VRRP备份组的接口的IP地址选举出一个Master路由器：优先级高的路由器成为Master路由器；优先级低的成为Backup路由器；如果优先级相同，则接口IP地址大的成为Master路由器。

### 2.3.2 Master路由器状态的通告

Master路由器周期性地发送VRRP报文，在虚拟路由器中公布其配置信息（优先级等）和工作状况。Backup路由器通过接收到VRRP报文的情况来判断Master路由器是否工作正常。

Master路由器主动放弃Master地位（如Master路由器退出虚拟路由器）时，会发送优先级为0的VRRP报文，致使Backup路由器快速切换为Master路由器。这个切换的时间称为Skew time，计算方式为：（256－Backup路由器的优先级）/256，单位为秒。

当Master路由器发生网络故障而不能发送VRRP报文的时候，Backup路由器并不能立即知道其工作状况。Backup路由器等待一段时间之后，如果还没有接收到VRRP报文，那么会认为Master路由器无法正常工作，而把自己升级为Master路由器，周期性发送VRRP报文。如果此时多个Backup路由器竞争Master路由器的位置，将通过优先级来选举Master路由器。Backup路由器默认等待的时间（Master_Down_Interval）的取值为：（3×VRRP报文的发送时间间隔）＋Skew time，单位为秒。

Backup路由器延迟切换Master路由器可以避免虚拟路由器中的设备频繁进行主备状态转换，让Backup路由器有足够的时间搜集必要的信息（如路由信息）。管理员配置抢占延迟时间后，Backup路由器接收到优先级低于本地优先级的通告报文后，不会立即抢占成为Master路由器，而是等待抢占延迟时间后，才会重新选举新的Master路由器。

### 2.3.3 认证方式

VRRP提供了三种认证方式：

·   无认证：不进行任何VRRP报文的合法性认证，不提供安全性保障。

·   简单字符认证：在一个有可能受到安全威胁的网络中，可以将认证方式设置为简单字符认证。发送VRRP报文的路由器将认证字填入到VRRP报文中，而收到VRRP报文的路由器会将收到的VRRP报文中的认证字和本地配置的认证字进行比较。如果认证字相同，则认为接收到的报文是合法的VRRP报文；否则，认为接收到的报文是一个非法报文。

·   MD5认证：在一个非常不安全的网络中，可以将认证方式设置为MD5认证。发送VRRP报文的路由器利用认证字和MD5算法对VRRP报文进行加密，加密后的报文保存在Authentication Header（认证头）中。收到VRRP报文的路由器会利用认证字解密报文，检查该报文的合法性。

VRRP包括VRRPv2和VRRPv3两个版本，只有VRRPv2版本支持配置认证功能，VRRPv3版本不支持配置认证功能。

# 3 Comware实现的技术特色

## 3.1 VRRP负载均衡模式

在VRRP标准协议模式中，只有Master路由器可以转发报文，Backup路由器处于监听状态，无法转发报文。虽然创建多个备份组可以实现多台路由器之间的负载分担，但是局域网内的主机需要手工设置不同的网关，增加了配置的复杂性。

VRRP负载均衡模式在VRRP提供的虚拟网关冗余备份功能基础上，增加了负载均衡功能。其实现原理为：将一个虚拟IP地址与多个虚拟MAC地址对应，VRRP备份组中的每台路由器都对应一个虚拟MAC地址；使用不同的虚拟MAC地址应答主机的ARP（IPv4网络中）/ND（IPv6网络中）请求，从而使得不同主机的流量发送到不同的路由器，VRRP备份组中的每台路由器都能转发流量。在VRRP负载均衡模式中，只需创建一个VRRP备份组，就可以实现备份组中多台路由器之间的负载分担，避免了标准协议模式下VRRP备份组中Backup路由器始终处于空闲状态、网络资源利用率不高的问题。

VRRP负载均衡模式以VRRP标准协议模式为基础，VRRP标准协议模式中的工作机制（如Master路由器的选举、抢占、监视功能等），VRRP负载均衡模式均支持。VRRP负载均衡模式还在此基础上，增加了新的工作机制。

### 3.1.1 虚拟MAC地址的分配

VRRP负载均衡模式中，Master路由器负责为备份组中的路由器分配虚拟MAC地址，并为来自不同主机的ARP/ND请求，应答不同的虚拟MAC地址，从而实现流量在多台路由器之间分担。备份组中的Backup路由器不会应答主机的ARP/ND请求。

以IPv4网络为例，VRRP负载均衡模式的具体工作过程为：

(1)   Master路由器为备份组中的路由器（包括Master自身）分配虚拟MAC地址。如[图3](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/VRRP_White_Paper-6W100/?CHID=949160#_Ref256672545)所示，虚拟IP地址为10.1.1.1/24的备份组中，Router A作为Master路由器，Router B作为Backup路由器。Router A为自己分配的虚拟MAC地址为000f-e2ff-0011，为Router B分配的虚拟MAC地址为000f-e2ff-0012。

图3 Master分配虚拟MAC地址

![img](https://resource.h3c.com/cn/201911/20/20191120_4598568_x_Img_x_png_3_1244593_30005_0.png)

 

(2)   Master路由器接收到主机发送的目标IP地址为虚拟IP地址的ARP请求后，根据负载均衡算法使用不同的虚拟MAC地址应答主机的ARP请求。如[图4](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/VRRP_White_Paper-6W100/?CHID=949160#_Ref256673699)所示，Host A发送ARP请求获取网关10.1.1.1对应的MAC地址时，Master路由器（即Router A）使用Router A的虚拟MAC地址应答该请求；Host B发送ARP请求获取网关10.1.1.1对应的MAC地址时，Master路由器使用Router B的虚拟MAC地址应答该请求。

图4 Master应答ARP请求

![img](https://resource.h3c.com/cn/201911/20/20191120_4598569_x_Img_x_png_4_1244593_30005_0.png)

 

(3)   通过使用不同的虚拟MAC地址应答主机的ARP请求，可以实现不同主机的流量发送给不同的路由器。如[图5](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/VRRP_White_Paper-6W100/?CHID=949160#_Ref260035760)所示，Host A认为网关的MAC地址为Router A的虚拟MAC地址，从而保证Host A的流量通过Router A转发；Host B认为网关的MAC地址为Router B的虚拟MAC地址，从而保证Host B的流量通过Router B转发。

图5 主机通过不同路由器转发流量

![img](https://resource.h3c.com/cn/201911/20/20191120_4598570_x_Img_x_png_5_1244593_30005_0.png)

 

Master路由器回复的ARP应答报文中，以太网数据帧头部的源MAC地址与ARP报文中的源MAC地址不一致。如果在Master/Backup路由器和主机之间部署了二层设备，则该二层设备上的配置具有如下限制：

·   不能开启ARP报文源MAC地址一致性检查功能；

·   如果开启了ARP Detection功能，则不能开启ARP报文有效性检查功能的源MAC地址检查模式。

### 3.1.2 虚拟转发器

#### 1. 虚拟转发器的创建

虚拟MAC地址的分配，实现了不同主机将流量发送给VRRP备份组中不同的路由器。为了使备份组中的路由器能够转发主机发送的流量，需要在路由器上创建虚拟转发器。每个虚拟转发器都对应备份组的一个虚拟MAC地址，负责转发目的MAC地址为该虚拟MAC地址的流量。

虚拟转发器的创建过程为：

(1)   VRRP备份组中的路由器获取到Master路由器为其分配的虚拟MAC地址后，创建该MAC地址对应的虚拟转发器，该路由器称为此虚拟MAC地址对应虚拟转发器的VF Owner（Virtual Forwarder Owner，虚拟转发器拥有者）。

(2)   VF Owner将虚拟转发器的信息通告给VRRP备份组内其它的路由器。

(3)   VRRP备份组内的路由器接收到虚拟转发器信息后，在本地创建对应的虚拟转发器。

由此可见，VRRP备份组中的路由器上不仅需要创建Master路由器为其分配的虚拟MAC地址对应的虚拟转发器，还需要创建其它路由器通告的虚拟MAC地址对应的虚拟转发器。

#### 2. 虚拟转发器的权重和优先级

虚拟转发器的权重标识了虚拟转发器的转发能力。权重值越高，虚拟转发器的转发能力越强。当权重低于一定的值——失效下限时，虚拟转发器无法再为主机转发流量。

虚拟转发器的优先级用来决定虚拟转发器的状态：不同路由器上同一个虚拟MAC地址对应的虚拟转发器中，优先级最高的虚拟转发器处于Active状态，称为AVF（Active Virtual Forwarder，动态虚拟转发器），负责转发流量；其它虚拟转发器处于Listening状态，称为LVF（Listening Virtual Forwarder，监听虚拟转发器），监听AVF的状态，不转发流量。虚拟转发器的优先级取值范围为0～255，其中，255保留给VF Owner使用。如果VF Owner的权重高于或等于失效下限，则VF Owner的优先级为最高值255。

设备根据虚拟转发器的权重计算虚拟转发器的优先级：

·   如果权重高于或等于失效下限，且设备是VF Owner，则虚拟转发器的优先级为最高值255；

·   如果权重高于或等于失效下限，且设备不是VF Owner，则虚拟转发器的优先级为权重/（本地AVF的数目＋1）；

·   如果权重低于失效下限，则虚拟转发器的优先级为0。

#### 3. 虚拟转发器备份

备份组中不同路由器上同一个虚拟MAC地址对应的虚拟转发器之间形成备份关系。当为主机转发流量的虚拟转发器或其对应的路由器出现故障后，可以由其它路由器上备份的虚拟转发器接替其为主机转发流量。

图6 虚拟转发器

![img](https://resource.h3c.com/cn/201911/20/20191120_4598571_x_Img_x_png_6_1244593_30005_0.png)

 

[图6](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/VRRP_White_Paper-6W100/?CHID=949160#_Ref260993618)举例说明了备份组中每台路由器上的虚拟转发器信息及其备份关系。Master路由器Router A为自己、Router B和Router C分配的虚拟MAC地址分别为000f-e2ff-0011、000f-e2ff-0012和000f-e2ff-0013。这些虚拟MAC地址对应的虚拟转发器分别为VF 1、VF 2和VF 3。在Router A、Router B和Router C上都创建了这三个虚拟转发器，并形成备份关系。例如，Router A、Router B和Router C上的VF 1互相备份：

·   Router A为VF 1的VF Owner，Router A上VF 1的虚拟转发器优先级为最高值255。因此，Router A上的VF 1作为AVF，负责转发目的MAC地址为虚拟MAC地址000f-e2ff-0011的流量。

·   Router B和Router C上VF 1的虚拟转发器优先级为：权重255/（本地AVF数目1＋1）＝127，低于Router A上VF 1的优先级。因此，Router B和Router C上的VF 1作为LVF，监视Router A上VF 1的状态。

·   当Router A上的VF 1出现故障时，将从Router B和Router C上的VF 1中选举出虚拟转发器优先级最高的LVF作为AVF，负责转发目的MAC地址为虚拟MAC地址000f-e2ff-0011的流量。如果LVF的优先级相同，则LVF所在设备接口MAC地址大的成为AVF。

虚拟转发器始终工作在抢占模式。对于不同路由器上互相备份的LVF和AVF，如果LVF接收到AVF发送的虚拟转发器信息中虚拟转发器优先级低于本地虚拟转发器假设变成AVF后的优先级，则LVF将会抢占成为AVF。

#### 4. 虚拟转发器的定时器

虚拟转发器的AVF出现故障后，接替其工作的新的AVF将为该VF创建Redirect Timer和Timeout Timer两个定时器。

·   Redirect Timer：VF重定向定时器。该定时器超时前，Master路由器还会采用该VF对应的虚拟MAC地址应答主机的ARP/ND请求；该定时器超时后，Master路由器不再采用该VF对应的虚拟MAC地址应答主机的ARP/ND请求。如果VF Owner在Redirect Timer超时前恢复，则VF Owner可以迅速参与流量的负载分担。

·   Timeout Timer：VF生存定时器，即AVF接替VF Owner工作的期限。该定时器超时前，备份组中的路由器上都保留该VF，AVF负责转发目的MAC地址为该VF对应虚拟MAC地址的报文；该定时器超时后，备份组中的路由器上都删除该VF，不再转发目的MAC地址为该VF对应虚拟MAC地址的报文。

#### 5. 虚拟转发器监视功能

AVF负责转发目的MAC地址为虚拟转发器MAC地址的流量，当AVF连接的上行链路出现故障时，如果不能及时通知LVF接替其工作，局域网中以此虚拟转发器MAC地址为网关MAC地址的主机将无法访问外部网络。

虚拟转发器的监视功能可以解决上述问题。利用NQA、BFD等监测AVF连接的上行链路的状态，并通过Track功能在虚拟转发器和NQA/BFD之间建立联动。当上行链路出现故障，Track项的状态变为Negative，虚拟转发器的权重将降低指定的数额，以便虚拟转发器优先级更高的路由器抢占成为AVF，接替其转发流量。

### 3.1.3 VRRP负载均衡模式的报文

VRRP标准协议模式中只定义了一种报文——VRRP通告报文，且只有Master路由器周期性发送该报文，Backup路由器不会发送VRRP通告报文。

为了实现VRRP负载均衡功能的正常运行，VRRP负载均衡模式中定义了四种报文：

·   Advertisement报文：不仅用于通告本路由器上备份组的状态，还用于通告本路由器上处于Active状态的虚拟转发器信息。Master和Backup路由器均周期性发送该报文。

·   Request报文：处于Backup状态的路由器如果不是VF Owner，则发送Request报文，请求Master路由器为其分配虚拟MAC地址。

·   Reply报文：Master路由器接收到Request报文后，将通过Reply报文为Backup路由器分配虚拟MAC地址。收到Reply报文后，Backup路由器会创建虚拟MAC地址对应的虚拟转发器，该路由器称为此虚拟转发器的拥有者。

·   Release报文：VF Owner的失效时间达到一定值后，接替其工作的路由器将发送Release报文，通知备份组中的路由器删除VF Owner对应的虚拟转发器。

### 3.1.4 应用限制

因为Master路由器会使用不同的虚拟MAC地址应答主机的ARP（IPv4网络中）/ND（IPv6网络中）请求，所以回复的ARP/ND应答报文中的以太网数据帧头部的源MAC地址与ARP/ND报文中的源MAC地址不一致。如果在Master/Backup路由器和主机之间部署了二层设备，则该二层设备上的配置具有如下限制：

·   不能开启ARP/ND报文源MAC地址一致性检查功能。

·   如果开启了ARP Detection功能，则不能开启ARP报文有效性检查功能的源MAC地址检查模式。

## 3.2 监视上行链路

VRRP网络传输功能有时需要额外的技术来完善其工作。例如，Master路由器到达某网络的链路突然断掉时，主机无法通过此Master路由器远程访问该网络。此时，可以通过监视指定接口上行链路功能，解决这个问题。当Master路由器发现上行链路出现故障后，主动降低自己的优先级（使Master路由器的优先级低于Backup路由器），并立即发送VRRP报文。Backup路由器接收到优先级比自己低的VRRP报文后，等待Skew Time切换为新的Master路由器。从而，使得能够到达此网络的Backup路由器充当VRRP新的Master路由器，协助主机完成网络通讯。

VRRP可以直接监视连接上行链路的接口状态。当连接上行链路的接口down时，将Master路由器降低指定的优先级。VRRP优先级最低可以降低到1。

VRRP可以利用NQA技术监视上行链路连接的远端主机或者网络状况。例如，Master设备上启动NQA的ICMP-echo探测功能，探测远端主机的可达性。当ICMP-echo探测失败时，它可以通知本设备探测结果，达到降低VRRP优先级的目的。

VRRP也可以利用BFD技术监视上行链路连接的远端主机或者网络状况。由于BFD的检测时间可以到达毫秒级，通过BFD能够快速检测到链路状态的变化，达到快速抢占的目的。例如，可以在Master路由器上使用BFD技术监视上行设备的物理状态，在上行设备发生故障之后，快速检测到该变化，并降低Master路由器的优先级，致使Backup路由器等待Skew Time后，抢占成为新的Master路由器。

## 3.3 Backup监视Master工作状态

Backup路由器在Master路由器故障之后，正常情况下需要等待Master_Down_Interval才能切换为新的Master路由器，这段时间内主机将无法正常通信，因为此时没有Master路由器为其转发报文。利用Backup路由器监听Master工作状态功能，可以解决此问题，确保网络通信不会中断。

Backup路由器监视Master路由器采用的是具有快速检测功能的BFD技术。在Backup设备上使用该技术监视Master路由器的状态，一旦Master路由器发生故障，Backup路由器就可以自动切换成为新的Master路由器，将切换时间缩短到毫秒级。

## 3.4 VRRP管理备份组功能

### 3.4.1 功能简介

设备上配置多个VRRP备份组承担流量转发时，因为每个VRRP备份组都需要单独维护自己的状态机，所以会产生大量VRRP报文，对网络和CPU性能都造成大量负荷。通过将VRRP备份组分为管理备份组和成员备份组，当成员备份组关联管理备份组后，成员备份组就不再发送VRRP通告报文进行设备间的主备协商，其设备主备状态与管理备份组保持一致，从而大大减少了VRRP通告报文对网络带宽和CPU处理性能的影响。

### 3.4.2 配置限制和指导

·   VRRP管理备份组需要配置路由器在备份组中的优先级、抢占方式及监视功能等功能，保证可以正常选举出Master设备，VRRP成员备份组不需要配置上述功能。

·   在VRRP标准协议模式和负载均衡模式下均可配置成员备份组关联管理备份组功能，但只有在VRRP标准协议模式下配置才会起作用。

·   VRRP备份组无法同时作为管理备份组和成员备份组。

·   如果VRRP备份组所关联的管理备份组不存在，则该VRRP备份组始终处于Inactive状态。

·   如果VRRP备份组在关联管理备份组前处于Inactive或Initialize状态，关联的管理备份组处于除Inactive状态的其他状态，则关联之后该VRRP备份组状态保持不变。

·   由于成员备份组不主动发送VRRP报文，可能导致下游设备上的MAC表项不正确，建议同时配置vrrp send-gratuitous-arp命令配置IPv4 VRRP Master路由器定时发送免费ARP报文。

# 4 典型组网案例

## 4.1 主备备份

主备备份方式表示业务仅由Master路由器承担。当Master路由器出现故障时，才会由选举出来的Backup路由器接替它工作。如[图7](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/VRRP_White_Paper-6W100/?CHID=949160#_Ref112125195)中所示。

图7 主备备份VRRP

![img](https://resource.h3c.com/cn/201911/20/20191120_4598572_x_Img_x_png_7_1244593_30005_0.png)

 

初始情况下，Device A是Master路由器并承担转发任务，Device B和Device C是Backup路由器且都处于就绪监听状态。如果Device A发生故障，则虚拟路由器内处于Backup状态的Device B和Device C路由器将根据优先级选出一个新的Master路由器，这个新Master路由器继续为网络内的主机转发数据。

## 4.2 多备份组负载分担

在路由器的一个接口上可以创建多个虚拟路由器，使该路由器在一个虚拟路由器中作为Master路由器，在其他的虚拟路由器中作为Backup路由器。

负载分担方式是指多台路由器同时承担业务。负载分担方式需要两个或者两个以上的虚拟路由器，每个虚拟路由器都包括一个Master路由器和若干个Backup路由器，各虚拟路由器的Master路由器各不相同，如[图8](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/VRRP_White_Paper-6W100/?CHID=949160#_Ref90201081)所示。

图8 负载分担VRRP

![img](https://resource.h3c.com/cn/201911/20/20191120_4598573_x_Img_x_png_8_1244593_30005_0.png)

 

在[图8](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/VRRP_White_Paper-6W100/?CHID=949160#_Ref128127180)中，有三个虚拟路由器存在：

·   虚拟路由器1：Device A作为Master路由器，Device B和Device C作为Backup路由器。

·   虚拟路由器2：Device B作为Master路由器，Device A和Device C作为Backup路由器。

·   虚拟路由器3：Device C作为Master路由器，Device A和Device B作为Backup路由器。

为了实现业务流量在Device A、Device B和Device C之间进行负载分担，需要将局域网内的主机的默认网关分别设置为虚拟路由器1、2和3。在配置优先级时，需要确保三个虚拟路由器中各路由器的VRRP优先级形成一定的交叉，使得一台路由器尽可能不同时充当2个Master路由器。

## 4.3 负载均衡

VRRP负载均衡模式中，只需要配置一个虚拟路由器，虚拟路由器会选举出一个Master路由器，用于分配虚拟转发器的虚拟MAC地址，并使用不同的虚拟MAC地址应答主机的ARP（IPv4网络中）/ND（IPv6网络中）请求。使虚拟路由器中的每个路由器都能承担转发任务。

图9 VRRP负载均衡模式组网图

![img](https://resource.h3c.com/cn/201911/20/20191120_4598574_x_Img_x_png_9_1244593_30005_0.png)

 

在[图9](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/VRRP_White_Paper-6W100/?CHID=949160#_Ref128127180)中，Device A 分别用AVF 1、AVF 2和AVF 3的虚拟MAC地址应答主机的ARP/ND请求，将主机的流量分担给Device A、Device B和Device C，实现负载均衡。每个路由器上都会创建自己的转发器，并创建LVF来监听其他路由器上的转发器。当其中的任意一台路由器发生故障后，其他路由器上处于监听状态的转发器会根据权重选举出一个转发器接管报文转发工作。当Master路由器发生故障时，其他路由器除了接管转发器的转发任务以外，还会选举出新的Master路由器来应答主机的ARP/ND请求，并为新加入的路由器分配虚拟MAC地址。

## 4.4 Master使用BFD/NQA监视上行链路

VRRP可以通过BFD或NQA等快速检测协议监视一些上行敏感链路，使得Master路由器快速地发现网络故障，降低自身的优先级，从而保证上行链路工作正常的Backup路由器能够接替它的工作。

图10 Master监视上行链路

![img](https://resource.h3c.com/cn/201911/20/20191120_4598565_x_Img_x_png_10_1244593_30005_0.png)

 

如[图10](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/VRRP_White_Paper-6W100/?CHID=949160#_Ref172787805)所示，缺省情况下，Device A作为Master路由器，承担转发任务；Device B为Backup路由器，处于就绪监听状态。Device A使用BFD监视上行到达Internet的链路状态。如果Device A的上行链路发生故障，Device A可以在毫秒级时间内感知到网络变化，立即发送低优先级的VRRP报文给Device B。如果此时Device B的优先级高于报文中的优先级，那么它将在Skew Time时间之后切换为新的Master路由器，之后由这个新的Master路由器为网络内的主机转发报文。

## 4.5 Backup使用BFD监视Master状态

为了保证网络传输的稳定性，可以在Backup路由器上使用BFD技术监视Master的状态，使得Master路由器发生故障时，Backup路由器能够立即切换为新的Master路由器。

图11 Backup监视Master状态

![img](https://resource.h3c.com/cn/201911/20/20191120_4598566_x_Img_x_png_11_1244593_30005_0.png)

 

如[图11](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/VRRP_White_Paper-6W100/?CHID=949160#_Ref172788152)所示，初始情况下，Device A作为Master路由器，承担报文转发任务；Device B是Backup路由器，处于就绪监听状态。Device B使用BFD监视Device A上IP地址10.1.1.1的可达性。如果Device A发生故障，Device B可以立即通过BFD感知到对端的变化，主动切换成为新的Master设备。之后，Device B作为新Master路由器为网络内的主机转发数据。

# 5 附录

## 5.1 参考文献

·   RFC 3768：Virtual Router Redundancy Protocol (VRRP)



# 配置IPv4 VRRP单备份组

## 1.1 简介

本案例介绍IPv4 VRRP单备份组的配置方法。

## 1.2 组网需求

如[图1](https://www.h3c.com/cn/d_202303/1816262_30005_0.htm#_Ref82185846)所示，Host A需要访问Internet上的Host B，Host A所在网络的出口处部署了两台设备。现要求使用VRRP单备份组功能，将这两台设备组成一台虚拟路由器，作为Host A的缺省网关。具体应用需求如下：

·   在正常情况下，由Device A承担网关功能，转发Host A发送至外网的流量；

·   当Device A或者Device A的上行接口出现故障时，由Device B接替Device A承担网关功能；

·   当Device A或者Device A的上行接口故障恢复后，由Device A继续承担网关功能。

图1 VRRP单备份组配置组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774796_x_Img_x_png_0_1816262_30005_0.png)

 

## 1.3 配置注意事项

·   备份组的虚拟IP地址不能为全零地址（0.0.0.0）、广播地址（255.255.255.255）、环回地址、非A/B/C类地址和其它非法IP地址（如0.0.0.1）。

·   IPv4 VRRP既可以使用VRRPv2版本，也可以使用VRRPv3版本（缺省情况使用VRRPv3）。请确保IPv4 VRRP备份组中的所有设备上配置的IPv4 VRRP版本一致，否则备份组无法正常工作。

·   建议将备份组的虚拟IP地址和备份组中设备下行接口的IP地址配置为同一网段，否则可能导致局域网内的主机无法访问外部网络。

·   对于同一个VRRP备份组的成员设备，必须保证虚拟路由器的IP地址配置完全一样。

·   用户在配置降低优先级幅度时，需要确保降低后的优先级比备份组内其他设备的优先级要低，确保备份组内有其他设备被选为Master。

## 1.4 配置步骤

#### 1. 配置Device A

\# 创建VLAN 2，并将接口GigabitEthernet1/0/1加入到VLAN 2中

<DeviceA> system-view

[DeviceA] vlan 2

[DeviceA-vlan2] port gigabitethernet 1/0/1

[DeviceA-vlan2] quit

\# 创建VLAN接口2，并将接口IP地址配置为10.1.1.1/24。

[DeviceA] interface vlan-interface 2

[DeviceA-Vlan-interface2] ip address 10.1.1.1 255.255.255.0

\# 创建VRRP备份组1，并配置备份组1的虚拟IP地址为10.1.1.111。

[DeviceA-Vlan-interface2] vrrp vrid 1 virtual-ip 10.1.1.111

\# 设置Device A在备份组1中的优先级为110，高于Device B的优先级100，以保证Device A成为Master负责转发流量。

[DeviceA-Vlan-interface2] vrrp vrid 1 priority 110

\# 设置Device A工作在抢占方式，以保证Device A故障恢复后，能再次抢占成为Master，即只要Device A正常工作，就由Device A负责转发流量。为了避免频繁地进行状态切换，配置抢占延迟时间为5000厘秒。

[DeviceA-Vlan-interface2] vrrp vrid 1 preempt-mode delay 5000

[DeviceA-Vlan-interface2] quit

\# 创建和上行端口GigabitEthernet1/0/2关联的Track项1。

[DeviceA] track 1 interface gigabitethernet 1/0/2

[DeviceA-track-1] quit

\# 配置监视Track项1，Track项的状态为Negative时，Device A在VRRP备份组中的优先级降低的数值为50。

[DeviceA] interface vlan-interface 2

[DeviceA-Vlan-interface2] vrrp vrid 1 track 1 priority reduced 50

[DeviceA-Vlan-interface2] quit

#### 2. 配置Device B

\# 配置VLAN2。

<DeviceB> system-view

[DeviceB] vlan 2

[DeviceB-Vlan2] port gigabitethernet 1/0/1

[DeviceB-vlan2] quit

[DeviceB] interface vlan-interface 2

[DeviceB-Vlan-interface2] ip address 10.1.1.2 255.255.255.0

\# 创建备份组1，并配置备份组1的虚拟IP地址为10.1.1.111。

[DeviceB-Vlan-interface2] vrrp vrid 1 virtual-ip 10.1.1.111

\# 设置Device B在备份组1中的优先级为100。

[DeviceB-Vlan-interface2] vrrp vrid 1 priority 100

## 1.5 验证配置

\# 配置完成后，在Host A上可以ping通Host B。

\# 通过display vrrp verbose命令查看配置后的结果，显示Device A上VRRP备份组1的详细信息。

[DeviceA-Vlan-interface2] display vrrp verbose

IPv4 Virtual Router Information:

 Running mode : Standard

 Total number of virtual routers : 1

  Interface Vlan-interface2

   VRID      : 1          Adver Timer : 100

   Admin Status  : Up          State    : Master

   Config Pri   : 110         Running Pri : 110

   Preempt Mode  : Yes          Delay Time  : 5000

   Auth Type   : Not supported

   Version     : 3

   Virtual IP    : 10.1.1.111

   Virtual MAC   : 0000-5e00-0101

   Master IP     : 10.1.1.1

  VRRP Track Information:

   Track Object  : 1          State : Positive  Pri Reduced : 50

\# 通过display vrrp verbose命令查看配置后的结果，显示Device B上VRRP备份组1的详细信息。

[DeviceB-Vlan-interface2] display vrrp verbose

IPv4 Virtual Router Information:

 Running mode : Standard

 Total number of virtual routers : 1

  Interface Vlan-interface2

   VRID      : 1          Adver Timer : 100

   Admin Status  : Up          State    : Backup

   Config Pri   : 100         Running Pri : 100

   Preempt Mode  : Yes         Delay Time  : 0

   Become Master : 401ms left

   Auth Type     : Not supported

   Version     : 3

   Virtual IP    : 10.1.1.111

   Master IP     : 10.1.1.1

以上显示信息表示在VRRP备份组1中Device A为Master，Device B为Backup，Host A发送给Host B的报文通过Device A转发。

\# Device A出现故障后，在Host A上仍然可以ping通Host B。

\# 通过display vrrp verbose命令查看Device B上VRRP备份组的详细信息，Device A出现故障后，显示Device B上VRRP备份组1的详细信息。

[DeviceB-Vlan-interface2] display vrrp verbose

IPv4 Virtual Router Information:

 Running Mode : Standard

 Total number of virtual routers : 1

  Interface Vlan-interface2

   VRID      : 1          Adver Timer : 100

   Admin Status  : Up          State    : Master

   Config Pri   : 100         Running Pri : 100

   Preempt Mode  : Yes         Delay Time  : 0

   Auth Type     : Not supported

   Version     : 3

   Virtual IP    : 10.1.1.111

   Master IP     : 10.1.1.2

以上显示信息表示Device A出现故障后，Device B成为Master，Host A发送给Host B的报文通过Device B转发。

\# Device A故障恢复后，显示Device A上VRRP备份组1的详细信息。

[DeviceA-Vlan-interface2] display vrrp verbose

IPv4 Virtual Router Information:

 Running Mode   : Standard

 Total number of virtual routers : 1

  Interface Vlan-interface2

   VRID      : 1          Adver Timer : 100

   Admin Status  : Up          State    : Master

   Config Pri   : 110         Running Pri : 110

   Preempt Mode  : Yes         Delay Time  : 5000

   Auth Type   : Not supported

   Version     : 3

   Virtual IP    : 10.1.1.111

   Virtual MAC   : 0000-5e00-0101

   Master IP     : 10.1.1.1

  VRRP Track Information:

   Track Object  : 1          State : Positive  Pri Reduced : 50

以上显示信息表示Device A故障恢复后，Device A会抢占成为Master，Host A发送给Host B的报文仍然通过Device A转发。

## 1.6 配置文件

·   Device A：

\#

vlan 2

\#

interface Vlan-interface2

 ip address 10.1.1.1 255.255.255.0

 vrrp vrid 1 virtual-ip 10.1.1.111

 vrrp vrid 1 priority 110

 vrrp vrid 1 preempt-mode delay 5000

 vrrp vrid 1 track 1 priority reduced 50

\#

interface GigabitEthernet1/0/1

 port link-mode bridge

 port access vlan 2

\#

 track 1 interface Ten-GigabitEthernet1/0/2

\#

·   Device B的配置文件：

\#

vlan 2

\#

interface Vlan-interface2

 ip address 10.1.1.2 255.255.255.0

 vrrp vrid 1 virtual-ip 10.1.1.111

 vrrp vrid 1 priority 100

\#

interface Ten-GigabitEthernet1/0/1

 port link-mode bridge

 port access vlan 2

\#