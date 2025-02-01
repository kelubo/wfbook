## Triple认证简介

为了在设备的同一端口上实现接入不同类型的认证用户，满足客户需求，我司推出了Triple认证方案。作为一种混合认证方案，Triple认证是指在接入用户的二层端口上同时开启802.1X认证、MAC地址认证和Web认证功能，该方案允许选用其中任意一种方式进行认证的终端均可通过该端口接入网络，从而提高认证环境部署的灵活性。

## 1.2 Triple认证典型组网

在终端形式多样的网络环境中，不同终端支持的接入认证方式有所不同。如[图1-1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Triple-3507/?CHID=688366#_Ref100087078)所示，有的终端只能进行MAC地址认证（比如打印机终端）；有的终端安装了802.1X客户端软件，可以进行802.1X认证；有的终端只希望通过Web访问进行认证。为了灵活地适应这种网络环境中的多种认证需求，需要在接入用户的端口上部署Triple认证，使得用户可以选择任何一种适合的认证机制来进行认证，且只需要成功通过一种方式的认证即可实现接入，无需通过多种认证。

图1-1 Triple认证典型应用组网图

![img](https://resource.h3c.com/cn/202205/09/20220509_7178392_x_Img_x_png_0_1605744_30005_0.png)

 

# 2 Triple认证方案支持的认证技术简介

## 2.1 802.1X

802.1X协议是一种基于端口的网络接入控制协议，即在局域网接入设备的端口上对所接入的用户和设备进行认证，以便控制用户设备对网络资源的访问。

### 2.1.1 802.1X认证系统

802.1X系统中包括三个实体：客户端（Client）、设备端（Device）和认证服务器（Authentication server），如[图2-1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Triple-3507/?CHID=688366#_Ref182021314)所示。

图2-1 802.1X体系结构图

![img](https://resource.h3c.com/cn/202205/09/20220509_7178393_x_Img_x_png_1_1605744_30005_0.png)

 

·   客户端是请求接入局域网的用户终端，由局域网中的设备端对其进行认证。客户端上必须安装支持802.1X认证的客户端软件。

·   设备端是局域网中控制客户端接入的网络设备，位于客户端和认证服务器之间，为客户端提供接入局域网的端口（物理端口或逻辑端口），并通过与认证服务器的交互来对所连接的客户端进行认证。

·   认证服务器用于对客户端进行认证、授权和计费，通常为RADIUS（Remote Authentication Dial-In User Service，远程认证拨号用户服务）服务器。认证服务器根据设备端发送来的客户端认证信息来验证客户端的合法性，并将验证结果通知给设备端，由设备端决定是否允许客户端接入。在一些规模较小的网络环境中，认证服务器的角色也可以由设备端来代替，即由设备端对客户端进行本地认证、授权和计费。

![说明](https://resource.h3c.com/cn/202205/09/20220509_7178404_x_Img_x_png_2_1605744_30005_0.png)

LDAP（Lightweight Directory Access Protocol，轻量级目录访问协议）服务器也能用于对客户端进行认证授权，但LDAP服务器不能提供计费服务。本白皮书内关于远程认证服务器的相关内容都将以RADIUS服务器为例进行介绍。

 

### 2.1.2 802.1X认证报文的交互机制

802.1X系统使用EAP（Extensible Authentication Protocol，可扩展认证协议）来实现客户端、设备端和认证服务器之间认证信息的交互。EAP是一种C/S模式的认证框架，它可以支持多种认证方法，例如MD5-Challenge、EAP-TLS（Extensible Authentication Protocol -Transport Layer Security，可扩展认证协议-传输层安全）、PEAP（Protected Extensible Authentication Protocol，受保护的扩展认证协议）等。在客户端与设备端之间，EAP报文使用EAPOL（Extensible Authentication Protocol over LAN，局域网上的可扩展认证协议）封装格式承载于数据帧中传递。在设备端与RADIUS服务器之间，EAP报文的交互有EAP中继和EAP终结两种处理机制。

#### 1. EAP中继

设备端对收到的EAP报文进行中继，使用EAPOR（EAP over RADIUS）封装格式将其承载于RADIUS报文中发送给RADIUS服务器。

图2-2 EAP中继原理示意图

![img](https://resource.h3c.com/cn/202205/09/20220509_7178410_x_Img_x_png_3_1605744_30005_0.png)

 

该处理机制下，EAP认证过程在客户端和RADIUS服务器之间进行。RADIUS服务器作为EAP服务器来处理客户端的EAP认证请求，设备相当于一个中继，仅对EAP报文做中转。

#### 2. EAP终结

设备对EAP认证过程进行终结，将收到的EAP报文中的客户端认证信息封装在标准的RADIUS报文中，与服务器之间采用PAP（Password Authentication Protocol，密码认证协议）或CHAP（Challenge Handshake Authentication Protocol，质询握手认证协议）方法进行认证。

图2-3 EAP终结原理示意图

![img](https://resource.h3c.com/cn/202205/09/20220509_7178411_x_Img_x_png_4_1605744_30005_0.png)

 

#### 3. EAP中继与EAP终结的对比

表2-1 EAP中继与EAP终结的对比

| 报文交互方式 | 优势                                                    | 局限性                                                       |
| ------------ | ------------------------------------------------------- | ------------------------------------------------------------ |
| EAP中继      | ·   支持多种EAP认证方法  ·   设备端的配置和处理流程简单 | 一般来说需要RADIUS服务器支持EAP-Message和Message-Authenticator属性，以及客户端采用的EAP认证方法 |
| EAP终结      | 对RADIUS服务器无特殊要求，支持PAP认证和CHAP认证即可     | ·   仅能支持MD5-Challenge类型的EAP认证以及iNode 802.1X客户端发起的“用户名+密码”方式的EAP认证  ·   设备端处理相对复杂 |

 

### 2.1.3 报文格式

#### 1. EAP

EAP报文格式如[图2-4](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Triple-3507/?CHID=688366#_Ref451863268)所示。

图2-4 EAP报文格式

![img](https://resource.h3c.com/cn/202205/09/20220509_7178412_x_Img_x_png_5_1605744_30005_0.png)

 

·   Code：EAP报文的类型，包括Request（1）、Response（2）、Success（3）和Failure（4）。

·   Identifier：用于匹配Request消息和Response消息的标识符。

·   Length：EAP报文的长度，包含Code、Identifier、Length和Data域，单位为字节。

·   Data：EAP报文的内容，该字段仅在EAP报文的类型为Request和Response时存在，它由类型域和类型数据两部分组成，例如，类型域为1表示Identity类型，类型域为4表示MD5 challenge类型。

#### 2. EAPOL

EAPOL是802.1X协议定义的一种承载EAP报文的封装技术，主要用于在局域网中传送客户端和设备端之间的EAP协议报文。EAPOL数据包的格式如[图2-5](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Triple-3507/?CHID=688366#_Ref128557043)所示。

图2-5 EAPOL数据包格式

![img](https://resource.h3c.com/cn/202205/09/20220509_7178413_x_Img_x_png_6_1605744_30005_0.png)

 

·   PAE Ethernet Type：表示协议类型。EAPOL的协议类型为0x888E。

·   Protocol Version：表示EAPOL数据帧的发送方所支持的EAPOL协议版本号。

·   Type：表示EAPOL数据帧类型。目前设备上支持的EAPOL数据帧类型见[表2-2](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Triple-3507/?CHID=688366#_Ref163464878)。

表2-2 EAPOL数据帧类型

| 类型值 | 数据帧类型   | 说明                                            |
| ------ | ------------ | ----------------------------------------------- |
| 0x00   | EAP-Packet   | 认证信息帧，用于承载客户端和设备端之间的EAP报文 |
| 0x01   | EAPOL-Start  | 认证发起帧，用于客户端向设备端发起认证请求      |
| 0x02   | EAPOL-Logoff | 退出请求帧，用于客户端向设备端发起下线请求      |

 

·   Length：表示数据域的长度，也就是Packet Body字段的长度，单位为字节。当EAPOL数据帧的类型为EAPOL-Start或EAPOL-Logoff时，该字段值为0，表示后面没有Packet Body字段。

·   Packet Body：数据域的内容。

#### 3. EAP报文在RADIUS中的封装

RADIUS为支持EAP认证增加了两个属性：EAP-Message（EAP消息）和Message-Authenticator（消息认证码）。在含有EAP-Message属性的数据包中，必须同时包含Message-Authenticator属性。关于RADIUS报文格式的介绍请参见“安全配置指导”中的“AAA”的RADIUS协议简介部分。

·   EAP-Message

如[图2-6](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Triple-3507/?CHID=688366#_Ref128557078)所示，EAP-Message属性用来封装EAP报文，Value域最长253字节，如果EAP报文长度大于253字节，可以对其进行分片，依次封装在多个EAP-Message属性中。

图2-6 EAP-Message属性封装

![img](https://resource.h3c.com/cn/202205/09/20220509_7178414_x_Img_x_png_7_1605744_30005_0.png)

 

·   Message-Authenticator

如[图2-7](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Triple-3507/?CHID=688366#_Ref376941050)所示，Message-Authenticator属性用于在EAP认证过程中验证携带了EAP-Message属性的RADIUS报文的完整性，避免报文被篡改。如果接收端对接收到的RADIUS报文计算出的完整性校验值与报文中携带的Message-Authenticator属性的Value值不一致，该报文会被认为无效而丢弃。

图2-7 Message-Authenticator属性封装

![img](https://resource.h3c.com/cn/202205/09/20220509_7178415_x_Img_x_png_8_1605744_30005_0.png)

 

### 2.1.4 802.1X的认证方式

目前设备支持两种方式的802.1X认证，通过RADIUS服务器进行远程认证和在接入设备上进行本地认证。

#### 1. RADIUS服务器认证方式进行802.1X认证

设备端支持采用EAP中继方式或EAP终结方式与远端RADIUS服务器交互。以下关于802.1X认证过程的描述，都以客户端主动发起认证为例。

(1)   EAP中继方式

这种方式是IEEE 802.1X标准规定的，将EAP承载在其它高层协议中，如EAP over RADIUS，以便EAP报文穿越复杂的网络到达认证服务器。一般来说，需要RADIUS服务器支持EAP属性：EAP-Message和Message-Authenticator。

如[图2-8](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Triple-3507/?CHID=688366#_Ref128557111)所示，以MD5-Challenge类型的EAP认证为例，具体认证过程如下。

图2-8 IEEE 802.1X认证系统的EAP中继方式认证流程

![img](https://resource.h3c.com/cn/202205/09/20220509_7178416_x_Img_x_png_9_1605744_30005_0.png)

 

a.   当用户需要访问外部网络时打开802.1X客户端程序，输入用户名和密码，发起连接请求。此时，客户端程序将向设备端发出认证请求帧（EAPOL-Start），开始启动一次认证过程。

b.   设备端收到认证请求帧后，将发出一个Identity类型的请求帧（EAP-Request/Identity）要求用户的客户端程序发送输入的用户名。

c.   客户端程序响应设备端发出的请求，将用户名信息通过Identity类型的响应帧（EAP-Response/Identity）发送给设备端。

d.   设备端将客户端发送的响应帧中的EAP报文封装在RADIUS报文（RADIUS Access-Request）中发送给认证服务器进行处理。

e.   RADIUS服务器收到设备端转发的用户名信息后，将该信息与数据库中的用户名列表对比，找到该用户名对应的密码信息，用随机生成的一个MD5 Challenge对密码进行加密处理，同时将此MD5 Challenge通过RADIUS Access-Challenge报文发送给设备端。

f.   设备端将RADIUS服务器发送的MD5 Challenge转发给客户端。

g.   客户端收到由设备端传来的MD5 Challenge后，用该Challenge对密码进行加密处理，生成EAP-Response/MD5 Challenge报文，并发送给设备端。

h.   设备端将此EAP-Response/MD5 Challenge报文封装在RADIUS报文（RADIUS Access-Request）中发送给RADIUS服务器。

i.   RADIUS服务器将收到的已加密的密码信息和本地经过加密运算后的密码信息进行对比，如果相同，则认为该用户为合法用户，并向设备端发送认证通过报文（RADIUS Access-Accept）。

j.   设备收到认证通过报文后向客户端发送认证成功帧（EAP-Success），并将端口改为授权状态，允许用户通过端口访问网络。

k.   用户在线期间，设备端会通过向客户端定期发送握手报文的方法，对用户的在线情况进行监测。

l.   客户端收到握手报文后，向设备发送应答报文，表示用户仍然在线。缺省情况下，若设备端发送的两次握手请求报文都未得到客户端应答，设备端就会让用户下线，防止用户因为异常原因下线而设备无法感知。

m.   客户端可以发送EAPOL-Logoff帧给设备端，主动要求下线。

n.   设备端把端口状态从授权状态改变成未授权状态，并向客户端发送EAP-Failure报文。

![说明](https://resource.h3c.com/cn/202205/09/20220509_7178394_x_Img_x_png_10_1605744_30005_0.png)

EAP中继方式下，需要保证在客户端和RADIUS服务器上选择一致的EAP认证方法，而在设备上，只需要通过dot1x authentication-method eap命令启动EAP中继方式即可。

 

(2)   EAP终结方式

这种方式将EAP报文在设备端终结并映射到RADIUS报文中，利用标准RADIUS协议完成认证、授权和计费。设备端与RADIUS服务器之间可以采用PAP或者CHAP认证方法。如[图2-9](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Triple-3507/?CHID=688366#_Ref128557165)所示，以CHAP认证为例，具体的认证流程如下。

图2-9 IEEE 802.1X认证系统的EAP终结方式认证流程

![img](https://resource.h3c.com/cn/202205/09/20220509_7178395_x_Img_x_png_11_1605744_30005_0.png)

 

a.   当用户需要访问外部网络时打开802.1X客户端程序，输入用户名和密码，发起连接请求。此时，客户端程序将向设备端发出认证请求帧（EAPOL-Start），开始启动一次认证过程。

b.   设备端收到认证请求帧后，将发出一个Identity类型的请求帧（EAP-Request/Identity）要求用户的客户端程序发送输入的用户名。

c.   客户端程序响应设备端发出的请求，将用户名信息通过Identity类型的响应帧（EAP-Response/Identity）发送给设备端。

d.   设备端收到用户名信息后，会随机生成一个MD5 Challenge，并发送给客户端。

e.   客户端收到由设备端传来的MD5 Challenge后，用该Challenge对密码进行加密处理，生成EAP-Response/MD5 Challenge报文，并发送给设备端。

f.   设备端与服务器间采用CHAP认证方式，将CHAP-Response/MD5 Challenge报文封装在RADIUS报文（RADIUS Access-Request）中发送给RADIUS服务器。

g.   RADIUS服务器将收到的已加密的密码信息和自己数据库里经过加密运算后的密码信息进行对比，如果相同，则认为该用户为合法用户，并向设备端发送认证通过报文（RADIUS Access-Accept）。

h.   设备收到认证通过报文后向客户端发送认证成功帧（EAP-Success），并将端口改为授权状态，允许用户通过端口访问网络。

i.   后续流程与EAP中继一致。

EAP终结方式与EAP中继方式的认证流程相比，不同之处在于用来对用户密码信息进行加密处理的MD5 challenge由设备端生成，之后设备端会把用户名、MD5 challenge和客户端加密后的密码信息一起发送给RADIUS服务器，进行相关的认证处理。

#### 2. 本地认证方式进行802.1X认证

在一些规模较小的网络环境中，认证服务器的角色也可以由设备端来代替，即由设备端对客户端进行本地认证。当选用本地认证方式进行802.1X认证时，需要在设备上手动添加认证的用户名和密码，用户登录后，如果用户名和密码匹配成功，则可以访问网络。

### 2.1.5 802.1X的认证触发方式

802.1X的认证过程可以由客户端主动发起，也可以由设备端发起。

#### 1. 客户端主动触发方式

·   组播触发：客户端主动向设备端发送EAPOL-Start报文来触发认证，该报文目的地址为组播MAC地址01-80-C2-00-00-03。

·   广播触发：客户端主动向设备端发送EAPOL-Start报文来触发认证，该报文的目的地址为广播MAC地址。该方式可解决由于网络中有些设备不支持上述的组播报文，而造成设备端无法收到客户端认证请求的问题。

![说明](https://resource.h3c.com/cn/202205/09/20220509_7178396_x_Img_x_png_12_1605744_30005_0.png)

目前，iNode的802.1X客户端可支持广播触发方式。

 

#### 2. 设备端主动触发方式

设备端主动触发方式用于支持不能主动发送EAPOL-Start报文的客户端。设备主动触发认证的方式分为以下两种：

·   组播触发：设备每隔一定时间（可配置，缺省为30秒）主动向客户端组播发送Identity类型的EAP-Request帧来触发认证。

·   单播触发：当设备收到源MAC地址未知的报文时，主动向该MAC地址单播发送Identity类型的EAP-Request帧来触发认证。若设备端在设置的时长内没有收到客户端的响应，则重发该报文。

## 2.2 MAC地址认证

MAC地址认证是一种基于二层端口和MAC地址对用户的网络访问权限进行控制的认证方法，无需安装客户端软件。设备在启动了MAC地址认证的端口上首次检测到用户的MAC地址以后，启动对该用户的认证操作。认证过程中，不需要用户手动输入用户名或密码。若该用户认证成功，则允许其通过端口访问网络资源，否则该用户的MAC地址就被设置为静默MAC。在静默时间内，来自此MAC地址的用户报文到达时，设备直接做丢弃处理，以防止非法MAC短时间内的重复认证。

### 2.2.1 MAC地址认证用户的账号格式

MAC地址认证用户使用的账号格式分为以下几种：

·   MAC地址账号：设备使用源MAC地址作为用户认证时的用户名和密码，或者使用MAC地址作为用户名，并配置密码。以使用源MAC地址作为用户认证时的用户名和密码为例，如[图2-10](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Triple-3507/?CHID=688366#_Ref451457531)所示。

·   固定用户名账号：

¡   通用固定用户名：所有MAC地址认证用户均使用设备上指定的一个固定用户名和密码替代用户的MAC地址作为身份信息进行认证，如[图2-11](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Triple-3507/?CHID=688366#_Ref451069339)所示。由于同一个端口下可以有多个用户进行认证，因此这种情况下端口上的所有MAC地址认证用户均使用同一个固定用户名进行认证，服务器端仅需要配置一个用户账户即可满足所有认证用户的认证需求，适用于接入客户端比较可信的网络环境。

¡   专用固定用户名：MAC地址认证还支持对特定MAC地址范围的用户单独设置用户名和密码（例如对指定OUI的MAC地址单独设置用户名和密码），相当于对指定MAC地址范围的用户使用固定用户名和密码。服务器端需要根据设备配置的账号创建对应的账号。如[图2-12](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Triple-3507/?CHID=688366#_Ref18484655)所示。

图2-10 MAC地址账号的MAC地址认证示意图

![img](https://resource.h3c.com/cn/202205/09/20220509_7178397_x_Img_x_png_13_1605744_30005_0.png)

 

图2-11 通用固定用户名账号的MAC地址认证示意图

![img](https://resource.h3c.com/cn/202205/09/20220509_7178398_x_Img_x_png_14_1605744_30005_0.png)

 

图2-12 专用固定用户名账号的MAC地址认证示意图

![img](https://resource.h3c.com/cn/202205/09/20220509_7178399_x_Img_x_png_15_1605744_30005_0.png)

 

### 2.2.2 MAC地址认证的认证方式

目前设备支持两种方式的MAC地址认证，通过RADIUS服务器或LDAP服务器进行远程认证和在接入设备上进行本地认证。以下远程认证介绍以RADIUS服务器为例。

#### 1. RADIUS服务器认证方式进行MAC地址认证

当选用RADIUS服务器认证方式进行MAC地址认证时，设备作为RADIUS客户端，与RADIUS服务器配合完成MAC地址认证操作：

·   若采用MAC地址账号，如果未配置密码，则设备将检测到的用户MAC地址作为用户名和密码发送给RADIUS服务器进行验证；如果配置了密码，则设备将检测到的用户MAC地址作为用户名，配置的密码作为密码发送给RADIUS服务器进行验证。

·   若采用固定用户名账号，则设备将一个已经在本地指定的MAC地址认证用户使用的固定用户名和对应的密码作为待认证用户的用户名和密码，发送给RADIUS服务器进行验证。

RADIUS服务器完成对该用户的认证后，认证通过的用户可以访问网络。

设备与服务器之间采用PAP或CHAP方法进行认证。如[图2-13](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Triple-3507/?CHID=688366#_Ref100158345)所示，以CHAP认证为例，具体的MAC地址认证流程如下。

图2-13 MAC地址认证流程

![img](https://resource.h3c.com/cn/202205/09/20220509_7178400_x_Img_x_png_16_1605744_30005_0.png)

 

(1)   接入设备收到终端发送的源MAC未知的报文（通常为ARP或DHCP广播报文），触发MAC地址认证。

(2)   设备端使用随机生成的MD5 Challenge对用户MAC地址和密码进行加密处理，然后将处理结果和MD5 Challenge一同封装在RADIUS认证请求报文中发送给RADIUS服务器。

(3)   RADIUS服务器使用收到的MD5 Challenge对本地数据库中对应用户的MAC地址和密码同样进行加密处理，如果与设备端的值相同，则向设备发送认证通过报文。

(4)   设备收到认证通过报文后通知用户上线成功，允许用户通过端口访问网络。

#### 2. 本地认证方式进行MAC地址认证

当选用本地认证方式进行MAC地址认证时，直接在设备上完成对用户的认证。需要在设备上配置本地用户名和密码：

·   若采用MAC地址账号，如果未配置密码，则设备将检测到的用户MAC地址作为待认证用户的用户名和密码与配置的本地用户名和密码进行匹配。如果配置了密码，则设备将检测到的用户MAC地址作为用户名，配置的密码作为密码与配置的本地用户名和密码进行匹配。

·   若采用固定用户名账号，则设备将一个已经在本地指定的MAC地址认证用户使用的固定用户名和对应的密码作为待认证用户的用户名和密码与配置的本地用户名和密码进行匹配。

用户名和密码匹配成功后，用户可以访问网络。

## 2.3 Web认证

Web认证是一种在二层接口上通过网页方式对用户身份合法性进行认证的认证方法。在接入设备的二层接口上开启Web认证功能后，未认证用户上网时，接入设备强制用户登录到特定站点，用户可免费访问其中的Web资源；当用户需要访问该特定站点之外的Web资源时，必须在接入设备上进行认证，认证通过后可访问特定站点之外的Web资源。

### 2.3.1 Web认证系统

Web认证的典型组网方式如[图2-14](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Triple-3507/?CHID=688366#_Ref142364199)所示，它由四个基本要素组成：认证客户端、接入设备、Web认证 Web服务器、Portal认证服务器和AAA认证服务器。

图2-14 Web认证系统组成示意图

 ![img](https://resource.h3c.com/cn/202205/09/20220509_7178401_x_Img_x_png_17_1605744_30005_0.png)

 

#### 2. 认证客户端

用户终端的客户端系统，为运行HTTP/HTTPS协议的浏览器，发起Web认证。

#### 3. 接入设备

提供接入服务的设备，主要有三方面的作用：

·   在认证之前，将用户的所有不符合免认证规则的HTTP/HTTPS请求都重定向到认证页面。

·   在认证过程中，与AAA服务器交互，完成身份认证/授权/计费的功能。

·   在认证通过后，允许用户访问被授权的网络资源。

#### 4. Web认证Web服务器

负责向认证客户端提供认证页面及其免费Web资源，获取认证客户端的用户名、密码等认证信息。Web认证Web服务器包括本地Web服务器和远程Web服务器两种类型。本地Web服务器一般集成在接入设备中，远程Web服务器为Portal Web服务器。

#### 5. Portal认证服务器

Web认证使用Portal认证服务器作为认证服务器，用于与接入设备交互认证客户端的认证信息。

#### 6. AAA认证服务器

与接入设备进行交互，完成对用户的认证、授权和计费。目前支持的AAA认证服务器包括RADIUS服务器和LDAP服务器：

·   RADIUS可支持对Web认证用户进行认证、授权和计费。

·   LDAP服务器可支持对Web认证用户进行认证。

### 2.3.2 Web认证的认证方式

#### 1. CHAP/PAP认证方式

CHAP/PAP认证方式的Web认证的具体认证过程如[图2-15](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Triple-3507/?CHID=688366#_Ref473100766)所示。

图2-15 Web认证（CHAP/PAP认证方式）流程

![img](https://resource.h3c.com/cn/202205/09/20220509_7178402_x_Img_x_png_18_1605744_30005_0.png)

 

(1)   Web认证用户首次访问Web资源的HTTP/HTTPS请求报文经过开启了Web认证功能的二层接口时，若此HTTP/HTTPS报文请求的内容为认证页面或设定的免费访问地址中的Web资源，则接入设备允许此HTTP/HTTPS报文通过；若请求的内容为其他Web资源，则接入设备将此HTTP/HTTPS报文重定向到认证页面，用户在认证页面上输入用户名和密码来进行认证。

(2)   Web认证Web服务器将用户输入的信息提交给Portal认证服务器进行认证。

(3)   Portal认证服务器与接入设备之间进行CHAP认证交互。若采用PAP认证则直接进入下一步骤。采用哪种认证交互方式由Portal认证服务器决定。

(4)   Portal认证服务器将用户输入的用户名和密码组装成认证请求报文发往接入设备，同时开启定时器等待认证应答报文。

(5)   接入设备与RADIUS服务器之间进行RADIUS协议报文的交互，对用户身份进行验证。

(6)   接入设备向Portal认证服务器发送认证应答报文，表示认证成功或者认证失败。

(7)   Portal认证服务器向客户端发送认证成功或认证失败报文，通知客户端认证成功（上线）或失败。

(8)   若认证成功，Portal认证服务器还会向接入设备发送认证应答确认。

#### 2. EAP认证方式

EAP认证仅能与iMC的Portal认证服务器以及iNode Portal客户端配合使用，且仅使用远程Portal认证服务器的Web认证支持该功能。

传统的基于用户名和口令的用户身份验证方式存在一定的安全问题，无法满足对接入用户身份可靠性要求较高的网络需求，而基于数字证书的用户身份验证方式因其能够保证数据在传输过程中的安全性和完整性，往往被用来建立更为安全和可靠的网络接入认证机制。

EAP支持多种基于数字证书的认证方式（例如EAP-TLS），它可以与Web认证相互配合，共同为用户提供基于数字证书的接入认证服务。

图2-16 EAP认证方式的Web认证流程

![img](https://resource.h3c.com/cn/202205/09/20220509_7178403_x_Img_x_png_19_1605744_30005_0.png)

 

(1)   客户端发起EAP认证请求，向Portal服务器发送EAP认证请求报文。

(2)   Portal认证服务器向接入设备发送Web认证请求报文，同时开启定时器等待Web认证应答报文，该认证请求报文中包含若干个EAP-Message属性，这些属性用于封装客户端发送的EAP报文。

(3)   接入设备接收到Web认证请求报文后，与RADIUS服务器进行认证报文交互，对用户身份进行验证。

(4)   接入设备根据RADIUS服务器的回应信息向Portal认证服务器发送证书请求报文，该报文中同样会包含若干个EAP-Message属性，携带RADIUS服务器的证书信息。

(5)   Portal认证服务器接收到证书请求报文后，向客户端发送EAP认证回应报文，直接将RADIUS服务器响应报文中的EAP-Message属性值透传给客户端。

(6)   客户端通过数字证书验证RADIUS服务器身份的合法性后，继续发起EAP认证请求，后续认证过程与第一个EAP认证请求报文的交互过程类似。

(7)   同步骤（2）。

(8)   同步骤（3）。

(9)   收到RADIUS服务器发送的认证通过响应报文后，接入设备向Portal认证服务器发送认证应答报文，该报文的EAP-Message属性中封装了EAP认证成功或失败报文。

(10)   Portal认证服务器根据认证应答报文中的认证结果通知客户端上线成功或失败。

(11)   若认证成功，Portal认证服务器还会向接入设备发送认证应答确认。

# 3 Triple认证方案的工作机制

## 3.1 Triple认证触发方式

当端口上同时开启了802.1X认证、MAC地址认证和Web认证功能后，不同类型的终端报文可触发不同的认证过程：

·   有两类终端报文可以触发802.1X认证：

¡   终端使用系统自带的802.1X客户端或者第三方客户端软件发送EAP协议报文。

¡   当接入设备开启单播触发功能时，终端发送源MAC地址未知的报文后，设备会主动向该MAC地址单播发送Identity类型的EAP-Request帧来触发802.1X认证。

·   触发MAC地址认证：终端发送源MAC未知的报文（通常为ARP或DHCP广播报文）。

·   触发Web认证：终端发送HTTP报文。

## 3.2 Triple认证顺序

当端口开启多种认证方式时，对于同一终端，具体的认证情况如下：

·   该终端某一种认证方式失败后，仍会按照指定的认证顺序尝试其它方式的认证。

·   该终端通过某一种认证方式成功上线后，会根据当前通过的认证方式决定是否尝试其它方式的认证。

目前设备上支持两种认证顺序：

·   缺省情况下，终端的认证顺序为：802.1X->MAC地址认证->Web认证

·   通过配置可更改终端的认证顺序为：MAC地址认证->802.1X->Web认证

#### 1. 802.1X->MAC地址认证->Web认证

·   当802.1X单播触发功能处于开启状态时，任意源MAC未知的终端报文都将先触发802.1X认证：

¡   如果802.1X认证成功，则该终端后续将不再进行其它方式的认证。

¡   如果802.1X认证失败，则会根据[3.1 ](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Triple-3507/?CHID=688366#_Ref96779921)[Triple认证触发方式](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Triple-3507/?CHID=688366#_Ref96779921)进行其它方式的认证。

·   当802.1X单播触发功能处于关闭状态时，根据[3.1 ](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Triple-3507/?CHID=688366#_Ref96779921)[Triple认证触发方式](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Triple-3507/?CHID=688366#_Ref96779921)，不同类型的终端报文可触发不同的认证过程：

¡   如果终端触发802.1X认证且成功上线，则该终端后续将不再进行其它方式的认证。

¡   如果终端未触发802.1X或802.1X认证失败，当终端触发MAC地址认证且成功上线时，该终端后续将不能再触发Web认证，但仍可以通过EAP协议报文触发802.1X认证。如果后续终端能够触发802.1X认证且成功上线，则端口上生成的802.1X认证用户信息会覆盖已存在的MAC地址认证用户信息。否则，用户依然保持MAC地址认证在线，且允许再次触发802.1X认证，但不能再触发Web认证。

¡   如果终端未触发802.1X及MAC地址认证或802.1X及MAC地址均认证失败，当终端触发Web认证且成功上线时，该终端后续将不再进行其它方式的认证。

#### 2. MAC地址认证->802.1X->Web认证

当端口的认证顺序配置为MAC地址认证、802.1X认证和Web认证后，任意源MAC未知的终端报文，都将先触发MAC地址认证：

·   如果MAC地址认证成功，则终端不能再触发Web认证，但仍可以通过EAP协议报文触发802.1X认证。如果后续终端能够触发802.1X认证且成功上线，则端口上生成的802.1X认证用户信息会覆盖已存在的MAC地址认证用户信息。否则，用户依然保持MAC地址认证在线，且允许再次触发802.1X认证，但不能再触发Web认证。

·   如果MAC地址认证失败，终端能够触发802.1X认证且成功上线，则该终端后续将不再进行其它方式的认证。

·   如果MAC地址认证认证失败且未触发802.1X或MAC地址认证及802.1X均认证失败，终端能够触发Web认证且成功上线，则该终端后续将不再进行其它方式的认证。

## 3.3 Triple认证支持授权ISP域

对于有线802.1X、MAC地址、Web认证用户，为了实现灵活的用户访问权限控制，设备支持通过设置不同类型的ISP域，允许处于不同阶段的用户拥有不同的网络访问权限。

![注意](https://resource.h3c.com/cn/202205/09/20220509_7178405_x_Img_x_png_20_1605744_30005_0.png)

Triple认证的前域、失败域、逃生域和Guest VLAN/VSI、Auth-fail VLAN/VSI、Critical VLAN/VSI、Critical微分段属于两种配置策略，不能同时使用。

 

### 3.3.1 ISP域类型

#### 1. 认证前域

认证前域是指，允许802.1X用户、MAC地址认证用户和Web认证用户在进入认证过程前所处的ISP域。接口上配置了认证前域时，在此接口上接入的认证用户将被授予指定认证前域内配置的相关授权属性（目前包括ACL、VLAN、VSI和微分段），并根据授权信息获得相应的网络访问权限。若此用户后续认证成功，则会被AAA服务器下发新的授权信息。

#### 2. 认证域

认证域是指用户认证上线时使用的ISP域，用户使用域中配置的认证方案完成认证。

#### 3. RADIUS服务器不可达逃生域

在用户认证过程中，如果出现认证方案下的所有RADIUS服务器不可达状况，设备发出的RADIUS认证请求报文将无法得到回应，从而影响用户正常上线。通过在当前认证域下配置逃生域，可以在这种情况发生时，保证用户能够“逃离”当前域，在新域中进行上线。通常情况下，逃生行为只是一个应急措施，因此用户可以无需再次认证而直接上线。

不同的组网环境中，对于用户因为RADIUS服务器不可达切换到逃生域后，任一服务器又恢复可达时的处理策略有所不同：

·   如果希望用户重新进行认证/授权/计费，则可以直接使其下线。

·   如果希望用户保持在线，且无需重新认证，可配置一个逃生恢复域。当RADIUS服务器服务器恢复可达时，用户将从逃生域进入逃生恢复域。

·   如果希望对用户直接重新认证，且无需用户感知，则可以配置重认证。

#### 4. RADIUS服务器逃生恢复域

逃生恢复域是指，认证服务器恢复可达后，用户可以加入的ISP域。用户是否加入该域，由具体的策略配置决定。目前，逃生恢复域必须与认证域同名。

#### 5. URL不可达逃生域

在用户认证过程中，当RADIUS服务器下发的重定向URL指定的Web服务器不可达时，用户将无法到达指定的Web页面完成认证，从而无法正常上线。配置URL不可达逃生域后，在重定向URL不可达时，用户可以在逃生域中上线，并访问其中的资源。当URL由不可达变为可达，用户从逃生域中下线，可以重新触发认证上线。

本特性仅适用于MAC地址认证和Web认证用户。

#### 6. 认证失败域

缺省情况下，用户认证失败后将会直接下线。但如果希望用户在首次认证失败后，还有机会尝试其它的授权/计费方案，则可以使其保持在线，并转至配置的认证失败域内重新进行授权/计费。

以下情况不会采用认证失败域：

·   因认证超时导致的认证失败，例如认证服务器无响应等。

·   因认证域的状态为block而引起的认证失败。

#### 7. 认证成功域

当认证域内的接入用户通过802.1X认证、MAC地址认证及Web认证中的任一方式认证成功上线时，则把该认证域称为认证成功域，认证服务器可以向该认证成功域下发授权属性为用户授权。

### 3.3.2 加域时机

不同认证方式下用户加入ISP域的时机不同，具体加域时机如[表3-1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Triple-3507/?CHID=688366#_Ref96992989)所示。

表3-1 不同认证方式下用户加入ISP域的时机

| 认证方式    | 前域                                                         | 逃生域                                      | 失败域/成功域                              |
| ----------- | ------------------------------------------------------------ | ------------------------------------------- | ------------------------------------------ |
| 802.1X      | ·   首次接入触发认证：  ¡   协议报文触发认证：收到EAP协议报文后加入前域  ¡   配置了单播触发认证：收到源MAC未知的报文后加入前域  ·   认证失败且未配置失败域时加入  ·   服务器不可达且未配置逃生域时加入 | 接入设备探测到“认证服务器或URL不可达”后加入 | 收到认证服务器返回的“认证失败”的结果后加入 |
| MAC地址认证 | MAC地址认证用户加入前域的时机分为如下两种情况：  ·   认证失败且未配置失败域时加入  ·   服务器不可达且未配置逃生域时加入 |                                             |                                            |
| Web认证     | 收到源MAC未知的报文后加入前域                                |                                             |                                            |

 

### 3.3.3 切域原则

当配置了全部类型的ISP域时，Triple认证用户在认证过程中ISP域间的切换如[图3-1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Triple-3507/?CHID=688366#_Ref100072368)所示。

![说明](https://resource.h3c.com/cn/202205/09/20220509_7178406_x_Img_x_png_21_1605744_30005_0.png)

MAC地址认证用户接入网络后直接发起认证，不会立刻加入前域，[图3-1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Triple-3507/?CHID=688366#_Ref100072368)的切换示意图请结合[表3-1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Triple-3507/?CHID=688366#_Ref96992989)加域时机具体情况具体分析。

 

图3-1 ISP域间切换示意图

![img](https://resource.h3c.com/cn/202205/09/20220509_7178407_x_Img_x_png_22_1605744_30005_0.png)

 

Triple认证场景下会开启三种认证方式，但接入用户最终只会通过一种接入认证方式上线，用户以何种认证身份加入ISP域与ISP域和认证方式的优先级有关。

当802.1X或者MAC地址认证用户进入任何一种ISP域（前域、失败域、逃生域或成功域）后，均不会再触发Web认证，因此以下切域原则仅针对802.1X和MAC地址认证使用场景：

·   同一接入认证方式下，ISP域的优先级由高到低为：认证成功域->认证服务器不可达逃生域->URL不可达逃生域->认证失败域->认证前域。

·   802.1X认证的优先级高于MAC地址认证，即同一用户通过802.1X认证上线后，不会再进行MAC地址认证，端口上生成的802.1X认证用户信息会覆盖已存在的MAC地址认证用户信息。

·   设备会根据认证用户所处状态、ISP域及认证方式的优先级进行认证域的选择：

a.   首先根据ISP域的优先级选择用户加入的域。例如，用户首先进行MAC地址认证，认证失败，但仍未进行802.1X认证，如果此时同时配置了认证失败域和认证前域，则用户会以MAC地址认证用户身份加入认证失败域。

b.   同一ISP域类型，则根据接入方式的优先级决定用户类型。例如，用户MAC地址认证失败后加入认证失败域，如果同一用户触发802.1X认证后同样认证失败，则会以802.1X用户身份重新加入认证失败域。

![注意](https://resource.h3c.com/cn/202205/09/20220509_7178408_x_Img_x_png_23_1605744_30005_0.png)

802.1X前域用户不会替换MAC地址认证前域用户，即MAC地址认证前域用户在线时，通过EAP协议报文或者未知源MAC报文触发802.1X认证后，不会再以802.1X前域用户身份上线。

 

c.   用户从高优先级域切换到低优先级域，接入认证方式不变。例如，MAC地址认证用户加入失败域后，删除失败域配置后，重认证时如果同时触发了802.1X认证，MAC地址认证失败后也只会以MAC地址认证身份加入前域。

## 3.4 Triple认证支持微分段下发

 

#### 1. 授权微分段

微分段可用于对网络中的接入用户进行基于分组的精细化访问控制。当用户通过Triple认证方案中的任一认证后，如果远程认证服务器为用户下发了微分段，则设备会根据下发的授权微分段对用户所在端口的数据流进行过滤，该用户可以访问该微分段所在分组内的网络资源。

#### 2. 服务器不可达微分段

用户在认证过程中若因所有认证服务器不可达导致认证失败，则端口将用户加入已配置的Critical 微分段中。

本特性仅802.1X和MAC地址认证支持。

## 3.5 Triple认证支持VSI下发

本特性仅802.1X和MAC地址认证支持。

### 3.5.1 授权VSI

远程认证服务器/接入设备可以向通过远程/本地认证的用户所在的端口下发授权VSI，端口将用户加入对应的授权VSI中。

### 3.5.2 认证失败的VSI

用户认证失败后，端口将认证失败的用户加入已配置的认证失败的VSI中：

·   对于802.1X认证用户，认证失败的VSI为端口上配置的802.1X Auth-Fail VSI。

·   对于MAC地址认证用户，认证失败的VSI为端口上配置的MAC地址认证Guest VSI。

如果MAC地址认证失败的用户再进行802.1X认证且认证失败，用户会立刻离开已加入的MAC地址认证的Guest VSI，而加入端口上配置的802.1X Auth-Fail VSI。

### 3.5.3 服务器不可达VSI

用户在认证过程中若因服务器不可达导致认证失败，则端口将用户加入已配置的服务器不可达VSI中：

·   对于802.1X认证用户，服务器不可达VSI为端口上配置的802.1X Critical VSI。

·   对于MAC地址认证用户，服务器不可达VSI为端口上配置的MAC地址认证Critical VSI。

如果MAC地址认证失败的用户再进行802.1X认证且认证失败，用户会立刻离开已加入的MAC地址认证的Critical VSI而加入端口上配置的802.1X Critical VSI。

## 3.6 Triple认证支持VLAN下发

### 3.6.1 授权VLAN

远程认证服务器/接入设备可以向通过远程/本地认证的用户所在的端口下发授权VLAN，端口将用户加入对应的授权VLAN中。

### 3.6.2 认证失败的VLAN

用户认证失败后，端口将认证失败的用户加入已配置的认证失败的VLAN中：

·   对于802.1X认证用户，认证失败的VLAN为端口上配置的802.1X Auth-Fail VLAN。

·   对于Web认证用户，认证失败的VLAN为端口上配置的Web Auth-Fail VLAN。

·   对于MAC地址认证用户，认证失败的VLAN为端口上配置的MAC地址认证Guest VLAN。

如果MAC地址认证失败的用户再进行802.1X认证且认证失败，用户会立刻离开已加入的MAC地址认证的Guest VLAN，而加入端口上配置的802.1X Auth-Fail VLAN。

### 3.6.3 服务器不可达VLAN

用户在认证过程中若因服务器不可达导致认证失败，则端口将用户加入已配置的服务器不可达VLAN中：

·   对于802.1X认证用户，服务器不可达VLAN为端口上配置的802.1X Critical VLAN。

·   对于Web认证用户，服务器不可达VLAN为端口上配置的Web Auth-Fail VLAN。

·   对于MAC地址认证用户，服务器不可达VLAN为端口上配置的MAC地址认证Critical VLAN。

端口支持同时配置多种服务器不可达VLAN，用户因服务器不可达导致认证失败后加入各VLAN的情况如下：

·   若用户没有进行802.1X认证，则用户加入最后一次认证失败的服务器不可达VLAN。

·   如果Web认证或MAC地址认证失败的用户再进行802.1X认证且认证失败，用户会立刻离开已加入的Web Auth-Fail VLAN或MAC地址认证的Critical VLAN而加入端口上配置的802.1X Critical VLAN。

## 3.7 Triple认证支持重认证

重认证是指设备周期性对端口上在线的认证用户发起认证，以检测用户连接状态的变化、确保用户的正常在线，并及时更新服务器下发的授权属性（例如ACL、VLAN等）。

不同认证域内的用户重认证方式不同：

·   认证逃生域和认证成功域内的用户仍以相同的接入认证方式进行重认证，例如以MAC地址认证用户身份加入逃生域内的用户重认证时只能进行MAC地址认证。

·   认证前域和认证失败域内的用户以新上线用户身份触发认证，根据认证结果决定最终上线的用户类型。认证前域和认证失败域内的Web认证用户不支持重认证。

# 4 典型组网应用

如[图4-1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Public/00-Public/Learn_Technologies/White_Paper/Triple-3507/?CHID=688366#_Ref96996268)所示，用户通过接入设备Device接入网络，要求在Device的二层端口上对所有用户进行统一认证，且只要用户通过802.1X认证、MAC地址认证、Web认证中的任何一种认证，即可接入网络。

图4-1 Triple认证典型组网

![img](https://resource.h3c.com/cn/202205/09/20220509_7178409_x_Img_x_png_24_1605744_30005_0.png)

 