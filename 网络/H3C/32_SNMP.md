##  产生背景

如今，网络与人们的生活和工作联系越来越紧密，但随着网络的普及引发了两大问题：

·   网络规模逐渐增大，网络设备的数量成级数增加，网络管理员很难及时监控所有设备的状态、发现并修复故障。

·   网络设备可能来自不同的厂商，如果每个厂商都提供一套独立的管理接口（比如命令行），将使网络管理变得越来越复杂。

为解决以上两大问题，一套覆盖服务、协议和管理信息库的标准（SNMP）应运而生。

## 1.2 技术优点

SNMP是管理进程（NMS）和代理进程（Agent）之间的通信协议。它规定了在网络环境中对设备进行监视和管理的标准化管理框架、通信的公共语言、相应的安全和访问控制机制。网络管理员使用SNMP功能可以查询设备信息、修改设备的参数值、监控设备状态、自动发现网络故障、生成报告等。

SNMP具有以下技术优点：

·   基于TCP/IP互联网的标准协议，传输层协议一般采用UDP。

·   自动化网络管理。网络管理员可以利用SNMP平台在网络上的节点检索信息、修改信息、发现故障、完成故障诊断、进行容量规划和生成报告。

·   屏蔽不同设备的物理差异，实现对不同厂商产品的自动化管理。SNMP只提供最基本的功能集，使得管理任务与被管设备的物理特性和实际网络类型相对独立，从而实现对不同厂商设备的管理。

·   简单的请求—应答方式和主动通告方式相结合，并有超时和重传机制。

·   报文种类少，报文格式简单，方便解析，易于实现。

·   SNMPv3版本提供了认证和加密安全机制，以及基于用户和视图的访问控制功能，增强了安全性。

# 2 SNMP技术实现

## 2.1 SNMP网络架构

SNMP网络架构由三部分组成：NMS、Agent和MIB。

### 1.2.1 NMS简介

NMS是网络中的管理者，是一个利用SNMP协议对网络设备进行管理和监视的系统。NMS既可以指一台专门用来进行网络管理的服务器，也可以指某个设备中执行管理功能的一个应用程序。

NMS可以向Agent发出请求，查询或修改一个或多个具体的参数值。同时，NMS可以接收Agent主动发送的Trap信息，以获知被管理设备当前的状态。

### 1.2.2 Agent简介

Agent是网络设备中的一个应用模块，用于维护被管理设备的信息数据并响应NMS的请求，把管理数据汇报给发送请求的NMS。

Agent接收到NMS的请求信息后，完成查询或修改操作，并把操作结果发送给NMS，完成响应。同时，当设备发生故障或者其他事件的时候，Agent会主动发送Trap信息给NMS，通知设备当前的状态变化。

### 1.2.3 MIB简介

#### 1. MIB

任何一个被管理的资源都表示成一个对象，称为被管理的对象。MIB是被管理对象的集合。它定义了被管理对象的一系列属性：对象的名称、对象的访问权限和对象的数据类型等。每个Agent都有自己的MIB。MIB也可以看作是NMS和Agent之间的一个接口，通过这个接口，NMS可以对Agent中的每一个被管理对象进行读/写操作，从而达到管理和监控设备的目的。NMS、Agent和MIB之间的关系如[图1](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SNMP_White_Paper-6W100/?CHID=949072#_Ref18002997)所示。

图1 NMS、Agent和MIB关系图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562976_x_Img_x_png_0_1238960_30005_0.png)

 

#### 2. MIB视图

MIB视图是MIB的子集合，配置Agent时用户可以将团体名/用户名与MIB视图绑定，从而限制NMS能够访问的MIB对象。用户可以配置MIB视图内的对象为excluded或included。excluded表示当前视图不包括该MIB子树的所有节点；included表示当前视图包括该MIB子树的所有节点。

#### 3. OID和子树

MIB是以树状结构进行存储的。树的节点表示被管理对象，它可以用从根开始的一条路径唯一地识别，这条路径就称为OID）。如[图2](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SNMP_White_Paper-6W100/?CHID=949072#_Ref22048927)所示。管理对象system可以用一串数字{1.3.6.1.2.1.1}唯一标识，这串数字就是system的OID。

子树可以用该子树根节点的OID来标识。如以private为根节点的子树的OID为private的OID——{1.3.6.1.4}。

图2 MIB树结构示意图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562977_x_Img_x_png_1_1238960_30005_0.png)

 

#### 4. 子树掩码

子树掩码可以和子树OID共同来确定一个视图的范围。子树掩码用十六进制格式表示，转化成二进制后，每个比特位对应OID中的一个小节，其中，

l   1表示精确匹配，即要访问的节点OID与MIB对象子树OID对应小节的值必须相等；

l   0表示通配，即要访问的节点OID与MIB对象子树OID对应小节的值可以不相等。

例如：子树掩码为0xDB（二进制格式为11011011），子树OID为1.3.6.1.6.1.2.1，则对应关系如[图3](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SNMP_White_Paper-6W100/?CHID=949072#_Ref22048943)所示，所确定的视图就包括子树OID为1.3.*.1.6.*.2.1（*表示可为任意数字）的子树下的所有节点。

图3 子树OID与子树掩码对应关系图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562981_x_Img_x_png_2_1238960_30005_0.png)

 

![说明: 说明](https://resource.h3c.com/cn/201910/25/20191025_4562982_x_Img_x_png_3_1238960_30005_0.png)

·   若子树掩码的bit数目大于子树OID的小节数，则匹配时，子树掩码的第一位与子树OID的第一小节对齐，第二位与第二小节对齐，以此类推，子树掩码中多出的bit位将被忽略

·   若子树掩码的bit数目小于子树OID的小节数，则匹配时，子树掩码的第一位与子树OID的第一小节对齐，第二位与第二小节对齐，以此类推，子树掩码中不足的bit位将自动设置为1；

·   如果没有指定子树掩码，则使用缺省子树掩码（全1）。

 

## 2.2 SNMP版本

SNMP主要有SNMPv1、SNMPv2c、SNMPv3几种最常用的版本。

### 1.2.4 SNMPv1

SNMPv1是SNMP协议的最初版本，提供最小限度的网络管理功能。SNMPv1的SMI和MIB都比较简单，且存在较多安全缺陷。

SNMPv1采用团体名认证。团体名的作用类似于密码，用来限制NMS对Agent的访问。如果SNMP报文携带的团体名没有得到NMS/Agent的认可，该报文将被丢弃。

### 1.2.5 SNMPv2c

SNMPv2c也采用团体名认证。在兼容SNMPv1的同时又扩充了SNMPv1的功能：它提供了更多的操作类型（GetBulk操作等）；支持更多的数据类型（Counter32等）；提供了更丰富的错误代码，能够更细致地区分错误。

### 1.2.6 SNMPv3

SNMPv3主要在安全性方面进行了增强，它采用了USM和VACM技术。USM提供了认证和加密功能，VACM确定用户是否允许访问特定的MIB对象以及访问方式。

#### 1. USM（基于用户的安全模型）

USM引入了用户名和组的概念，可以设置认证和加密功能。认证用于验证报文发送方的合法性，避免非法用户的访问；加密则是对NMS和Agent之间传输的报文进行加密，以免被窃听。通过有无认证和有无加密等功能组合，可以为NMS和Agent之间的通信提供更高的安全性。

#### 2. VACM（基于视图的访问控制模型）

VACM技术定义了组、安全等级、上下文、MIB视图、访问策略五个元素，这些元素同时决定用户是否具有访问的权限，只有具有了访问权限的用户才能管理操作对象。在同一个SNMP实体上可以定义不同的组，组与MIB视图绑定，组内又可以定义多个用户。当使用某个用户名进行访问的时候，只能访问对应的MIB视图定义的对象。

## 2.3 SNMP操作

SNMP支持多种操作，主要为以下几种基本操作：

·   Get操作：NMS使用该操作从Agent获取一个或多个参数值。

·   GetNext操作：NMS使用该操作从Agent获取一个或多个参数的下一个参数值。

·   Set操作：NMS使用该操作设置Agent一个或多个参数值。

·   Response操作：Agent返回一个或多个参数值。该操作是前面三种操作的响应。

·   Trap操作：Agent主动发出的操作，通知NMS有某些事情发生。

·   Inform操作：Agent主动发出的操作，通知NMS有某些事情发生。NMS收到Inform报文后，需要给Agent发送确认报文。

缺省情况下，执行前四种操作时设备使用UDP协议采用161端口发送报文，执行Trap和Inform操作时设备使用UDP协议向NMS的162端口发报文。由于收发采用了不同的端口号，所以一台设备可以同时作为Agent和NMS。

## 2.4 SNMP报文

根据SNMP的不同版本和不同操作，定义了以下报文格式：

### 1.2.7 SNMPv1报文

图4 SNMPv1报文格式

![img](https://resource.h3c.com/cn/201910/25/20191025_4562983_x_Img_x_png_4_1238960_30005_0.png)

 

从图4可以看出，SNMP消息主要由Version、Community、SNMP PDU几部分构成。其中，报文中的主要字段定义如下：

·   Version：SNMP版本。

·   Community：团体名，用于Agent与NMS之间的认证。团体名有可读和可写两种，如果是执行Get、GetNext操作，则采用可读团体名进行认证；如果是执行Set操作，则采用可写团体名进行认证。

·   Request ID：用于匹配请求和响应，SNMP给每个请求分配全局唯一的ID。

·   Error status：用于表示在处理请求时出现的状况，包括noError、tooBig、noSuchName、badValue、readOnly、genErr。

·   Error index：差错索引。当出现异常情况时，提供变量绑定列表（Variable bindings）中导致异常的变量的信息。

·   Variable bindings：变量绑定列表，由变量名和变量值对组成。

·   enterprise：Trap源（生成Trap信息的设备）的类型。

·   Agent addr：Trap源的地址。

·   Generic trap：通用Trap类型，包括coldStart、warmStart、linkDown、linkUp、authenticationFailure、egpNeighborLoss、enterpriseSpecific。

·   Specific trap：企业私有Trap信息。

·   Time stamp：上次重新初始化网络实体和产生Trap之间所持续的时间，即sysUpTime对象的取值。

### 1.2.8 SNMPv2c报文

图5 SNMPv2c报文格式

![img](https://resource.h3c.com/cn/201910/25/20191025_4562984_x_Img_x_png_5_1238960_30005_0.png)

 

比较SNMPv1而言，SNMPv2c新增了GetBulk操作报文。GetBulk操作所对应的基本操作类型是GetNext操作，通过对Non repeaters和Max repetitions参数的设定，高效率地从Agent获取大量管理对象数据。

SNMPv2c修改了Trap报文格式。SNMPv2c Trap PUD采用SNMPv1 Get/GetNext/Set PDU的格式，并将sysUpTime和snmpTrapOID作为Variable bindings中的变量来构造报文。

### 1.2.9 SNMPv3报文

SNMPv3修改了消息的格式，但是PDU部分的格式同SNMPv2c是保持一致的。[图6](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SNMP_White_Paper-6W100/?CHID=949072#_Ref22048968)只列出消息格式。

图6 SNMPv3消息格式

![img](https://resource.h3c.com/cn/201910/25/20191025_4562985_x_Img_x_png_6_1238960_30005_0.png)

 

其中，整个SNMPv3消息可以使用认证机制，并对EngineID、ContextName、PDU消息体部分进行加密。RequestID、MaxSize、Flags、SecurityModel、SecurityParameters构成SNMPv3消息头。

报文中的主要字段定义如下：

·   RequestID：请求报文的序列号。

·   MaxSize：消息发送者所能够容纳的消息最大字节，同时也表明了发送者能够接收到的最大字节数。

·   Flags：消息标识位，占一个字节，只有最低的三个比特位有效，比如0x0表示不认证不加密，0x1表示认证不加密，0x3表示认证加密，0x4表示发送report PDU标志等。

·   SecurityModel：消息的安全模型值，取值为0～3。0表示任何模型，1表示采用SNMPv1安全模型，2表示采用SNMPv2c安全模型，3表示采用SNMPv3安全模型。

·   ContextEngineID：唯一识别一个SNMP实体。对于接收消息，该字段确定消息该如何处理；对于发送消息，该字段在发送一个消息请求时由应用提供。

·   ContextName：唯一识别在相关联的上下文引擎范围内部特定的上下文。

SecurityParameters又包括以下主要字段：

·   AuthoritativeEngineID：消息交换中权威SNMP的snmpEngineID，用于SNMP实体的识别、认证和加密。该取值在Trap、Response、Report中是源端的snmpEngineID，对Get、GetNext、GetBulk、Set中是目的端的snmpEngineID。

·   AuthoritativeEngineBoots：消息交换中权威SNMP的snmpEngineBoots。表示从初次配置时开始，SNMP引擎已经初始化或重新初始化的次数。

·   AuthoritativeEngineTime：消息交换中权威SNMP的snmpEngineTime，用于时间窗判断。

·   UserName：用户名，消息代表其正在交换。NMS和Agent配置的用户名必须保持一致。

·   AuthenticationParameters：认证参数，认证运算时所需的密钥。如果没有使用认证则为空。

·   PrivacyParameters：加密参数，加密运算时所用到的参数，比如DES CBC算法中形成初值IV所用到的取值。如果没有使用加密则为空。

## 2.5 SNMP协议原理

### 1.2.10 SNMPv1和SNMPv2c实现机制

SNMPv1/SNMPv2c实现机制基本一致，SNMPv2c丰富了错误码，新增了GetBulk操作。下面以在SNMPv1版本环境执行Get、GetNext和Set操作为例来描述SNMPv1/SNMPv2c的实现机制。

#### 1. Get操作

NMS想要获取被管理设备MIB节点sysName的值（sysName对象在允许访问视图内），使用public为可读团体名，过程如下：

(1)   NMS给Agent发送Get请求，请求报文主要字段将被设置为：Version字段的值为1，Community字段的值为public，PDU里Variable bindings中Name1字段的值为sysName.0。

(2)   Agent给NMS发送Get响应，说明是否获取成功。如果成功，则Response PDU里Variable bindings中Value1字段的值为设备的名字（比如Agent010-H3C）；如果获取失败，则在Error status字段填上出错的原因，在Error index填上出错的位置信息。

图7 Get操作示意图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562986_x_Img_x_png_7_1238960_30005_0.png)

 

#### 2. GetNext操作

NMS想要获取被管理设备MIB节点sysName的下一个节点sysLocation的值（sysName和sysLocation对象都在允许访问视图内），使用public为可读团体名，过程如下：

(1)   NMS给Agent发送GetNext请求，请求报文主要字段将被设置为：Version字段的值为1，Community字段的值为public，PDU里Variable bindings中Name1字段的值为sysName.0。

(2)   Agent给NMS发送GetNext响应。如果成功，则Response PDU里Variable bindings中Name1字段值为sysName.0的下一个节点sysLocation.0， Value1字段的值为（比如Beijing China）；如果获取失败，则在Error status字段填上出错的原因，在Error index填上出错的位置信息。

图8 GetNext操作示意图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562987_x_Img_x_png_8_1238960_30005_0.png)

 

#### 3. Set操作

NMS想要设置被管理设备MIB节点sysName的值为Device01，使用private为可写团体名，过程如下：

(1)   NMS给Agent发送Set请求，请求报文主要字段将被设置为：Version字段的值为1，Community字段的值为private，PDU里Variable bindings中Name1字段的值为sysName.0，Value1字段的值填为Device01。

(2)   Agent给NMS发送Set响应，说明是否设置成功。如果成功，则Response PDU里Variable bindings中Value1字段的值填为设备的新名字（比如Device01）；如果设置失败，则在Error status字段填上出错的原因，在Error index填上出错的位置信息。

图9 Set操作示意图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562988_x_Img_x_png_9_1238960_30005_0.png)

 

#### 4. Trap操作

当设备发生某些异常需要通知NMS时，Agent会主动发出Trap报文。例如：设备某端口网线被拔出，Agent发送linkDown的Trap消息给NMS。Version字段的值为1，Community字段的值为public，PDU中enterprise字段为sysObjectID.0的取值（比如为enterprises.25506），Generic trap字段值为linkDown，Variable bindings字段携带接口相关信息。

图10 Trap操作示意图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562978_x_Img_x_png_10_1238960_30005_0.png)

 

### 1.2.11 SNMPv3实现机制

SNMPv3各操作的实现机制同SNMPv1和SNMPv2c基本一样，其主要区别在于SNMPv3新增加了认证和加密、解密的处理。下面以SNMPv3使用认证和加密方式执行get操作为例来描述其实现机制，过程如下：

(1)   NMS首先发送不带任何认证和加密参数的Get请求，Flags字段设置为0x4，以获取contextEngineID、contextName、AuthoritativeEngineID、AuthoritativeEngineBoots、AuthoritativeEngineTime等相关参数的值。

(2)   Agent解析消息，发送report报文，并携带上述相关参数的值。

(3)   NMS再次给Agent发送Get请求，请求报文主要字段将被设置为：Version字段的值为3，将（2）获取到的参数值填入相应字段，PDU里Variable bindings中Name1字段的值为sysName.0，并且根据配置的认证算法计算出AuthenticationParameters，使用配置的加密算法计算出PrivacyParameters，并使用配置的加密算法对PDU数据进行加密。

(4)   Agent首先对消息进行认证，认证通过后对PDU报文进行解密。解密成功后，则获取sysName.0对象的值，并将Response PDU里Variable bindings中Value1字段的值填为设备的名字（比如Agent010）。如果认证、解密失败或者获取参数值失败，则在Error status字段填上出错的原因，在Error index填上出错的位置信息。最后对PDU进行加密，设置contextEngineID、contextName、AuthoritativeEngineID、AuthoritativeEngineBoots、AuthoritativeEngineTime、AuthenticationParameters、PrivacyParameters等参数，发送响应报文。

图11 SNMPv3 Get操作示意图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562979_x_Img_x_png_11_1238960_30005_0.png)

 

## 2.6 SNMP静默功能

设备使用SNMP静默功能可以自动检测并防御SNMP攻击。

其原理为：用户开启SNMP功能后，设备会自动创建SNMP静默定时器，并统计1分钟内收到的认证失败的SNMP报文的个数：

·   如果个数小于100，则自动重新开始计数。

·   如果个数大于等于100，则认为设备受到了SNMP攻击，SNMP模块会进入静默状态，设备将不再响应收到的任何SNMP报文。静默时间为5分钟，5分钟后，自动重新开始计数。

# 2 H3C实现的技术特色

H3C设备支持SNMPv1、SNMPv2c、SNMPv3三个版本，为了兼容SNMPv3，SNMPv1和SNMPv2c版本也可以配置组、用户和视图，这时，只需要将NMS侧的团体名参数设置为设备上配置的用户名即可。用户可以同时使能多个版本，但需要和NMS侧的版本一致。

# 3 典型组网应用

## 3.1 组网图

如[图12](https://www.h3c.com/cn/Service/Document_Software/Document_Center/Home/Switches/00-Public/Learn_Technologies/White_Paper/SNMP_White_Paper-6W100/?CHID=949072#_Ref18003052)所示，网络中存在不同厂商的设备，以及同一厂商的不同型号的设备。NMS通过SNMP协议对Agent进行监控管理，Agent只接受IP地址为1.1.1.1的NMS的管理，Agent发生故障时能主动向NMS发送告警信息。

图12 SNMP典型组网图

![img](https://resource.h3c.com/cn/201910/25/20191025_4562980_x_Img_x_png_12_1238960_30005_0.png)

 

# 4 参考文献

与SNMP相关的协议规范有：

·   RFC 1155：Structure and Identification of Management Information for TCP/IP-based Internets

·   RFC 2578：Structure of Management Information Version 2 (SMIv2)

·   RFC 2579：Textual Conventions for SMIv2

·   RFC 3411：An Architecture for Describing Simple Network Management Protocol (SNMP) Management Frameworks

·   RFC 3412：Message Processing and Dispatching for the Simple Network Management Protocol (SNMP)

·   RFC 3414：User-based Security Model (USM) for version 3 of the Simple Network Management Protocol (SNMPv3)

·   RFC 3415：View-based Access Control Model (VACM) for the Simple Network Management Protocol (SNMP)

# SNMPv1/v2c配置

## 1.1 简介

本案例介绍SNMPv1/v2c的配置方法。

## 1.2 组网需求

如[图1](https://www.h3c.com/cn/d_202303/1816266_30005_0.htm#_Ref126913811)所示，iMC服务器作为NMS通过SNMPv1/SNMPv2c协议对设备（Agent）进行监控管理，只读团体名为readtest，读写团体名为writetest，并且当设备出现故障时能够主动向NMS发送告警信息。

图1 SNMPv1/v2c功能配置组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774816_x_Img_x_png_0_1816266_30005_0.png)

## 1.3 配置注意事项

·   SNMPv2c与SNMPv1配置方法完全一致，本举例中以配置SNMPv2c为例进行介绍。

·   用户在设备和NMS上配置的SNMP版本号和团体字必须一致，否则，NMS无法对设备进行管理和维护。

·   不同厂商的NMS软件配置方法不同，关于NMS的详细配置，具体请参考NMS的相关手册。本配置举例中，以iMC PLAT 7.0 (E0202)为例进行介绍。

## 1.4 配置步骤

#### 1. Agent的配置

\# 配置接口Vlan-interface2的IP地址。

<Agent> system-view

[Agent] interface Vlan-interface 2

[Agent-Vlan-interface 2] ip address 192.168.100.68 24

[Agent-Vlan-interface 2] quit

\# 设置Agent使用的SNMP版本为v2c、只读团体名为readtest，读写团体名为writetest。

[Agent] snmp-agent sys-info version v2c

[Agent] snmp-agent community read readtest

[Agent] snmp-agent community write writetest

\# 设置设备的联系人和位置信息，以方便维护。

[Agent] snmp-agent sys-info contact Mr.Wang-Tel:3306

[Agent] snmp-agent sys-info location telephone-closet,3rd-floor

\# 设置允许向NMS发送告警信息，使用的团体名为readtest。

[Agent] snmp-agent trap enable

[Agent] snmp-agent target-host trap address udp-domain 192.168.100.4 params securityname readtest v2c

#### 2. NMS的配置

(1)   登录进入iMC管理平台，选择“资源”页签，单击导航树中的[增加设备]菜单项，进入增加设备配置页面。在该页面中输入设备的主机名或IP地址，并点击<配置SNMP参数/设置>链接。

图2 增加设备配置页面

![img](https://resource.h3c.com/cn/202303/28/20230328_8774817_x_Img_x_png_1_1816266_30005_0.png)

 

(2)   进入SNMP参数设置页面配置SNMP参数。

·   设置参数类型为“SNMPv2c”；

·   设置只读团体字为“readtest”；

·   设置读写团体字为“writetest”；

·   其它参数采用缺省值，并单击<确定>按钮完成操作。

图3 SNMP参数设置页面

![img](https://resource.h3c.com/cn/202303/28/20230328_8774821_x_Img_x_png_2_1816266_30005_0.png)

 

(3)   在增加设备配置页面单击<确定>按钮，iMC返回增加设备成功信息。增加设备成功后，用户即可通过iMC对设备进行配置、管理和维护。

图4 增加设备成功页面

![img](https://resource.h3c.com/cn/202303/28/20230328_8774822_x_Img_x_png_3_1816266_30005_0.png)

 

## 1.5 验证配置

\# 完成以上配置之后，在设备上的某个空闲接口执行**shutdown**或**undo** **shutdown**操作，设备会向NMS发送接口状态改变的Trap。

\# 在iMC的“告警>告警浏览>全部告警”页面中会显示上述接口状态改变的Trap信息。

## 1.6 配置文件

\# 

 snmp-agent  

 snmp-agent community write writetest

 snmp-agent community read readtest 

 snmp-agent sys-info contact Mr.Wang-Tel:3306 

 snmp-agent sys-info location telephone-closet,3rd-floor

 snmp-agent sys-info version v2c

 snmp-agent trap enable arp

 snmp-agent trap enable syslog

 snmp-agent target-host trap address udp-domain 192.168.100.4 params securityname readtest v2c

\# 

## 1.7 相关资料

·   产品配套“网络管理和监控配置指导”中的“SNMP”。

·   产品配套“网络管理和监控命令参考”中的“SNMP”。



 

# 2 SNMPv3配置

## 2.1 简介

本案例介绍SNMPv3的配置方法。

## 2.2 组网需求

·   NMS通过SNMPv3只能对Agent的SNMP报文的相关信息进行监控管理，Agent在出现故障时能够主动向NMS发送告警信息，NMS上接收SNMP告警信息的默认UDP端口号为162。

·   NMS与Agent建立SNMP连接时，需要认证，使用的认证算法为SHA-1，认证密码为123456TESTauth&!。NMS与Agent之间传输的SNMP报文需要加密，使用的加密协议为AES，加密密码为123456TESTencr&!。

图2 SNMPv3功能典型配置组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774823_x_Img_x_png_4_1816266_30005_0.png)

 

## 2.3 配置注意事项

·   SNMPv3支持基于RBAC（Role Based Access Control，基于角色的访问控制）和基于VACM（View-based Access Control  Model，基于视图的访问控制模型）两种访问控制方式。本配置举例中，针对同一需求分别给出了两种方式的配置示例，请选择一种作为参考即可。

·   用户在设备和NMS上配置的SNMP版本号和团体字必须一致，否则，NMS无法对设备进行管理和维护。

·   不同厂商的NMS软件配置方法不同，关于NMS的详细配置，具体请参考NMS的相关手册。本配置举例中，以iMC PLAT 7.0 (E0202)为例进行介绍。

·   SNMPv3接收Trap报文的目的主机的安全参数要使用设备已配置的v3用户，且安全模型要一致。

·   SNMPv3的认证密码和加密密码以密文形式保存在配置文件中，密文密码由明文密码和本设备的引擎ID计算后生成。如果要将两台设备的认证密码和加密密码配置为相同值，建议使用明文密码在两台设备上分别手工配置，不要直接拷贝配置文件中的相关配置。因为两台设备的引擎ID不同，会导致密文密码相同，而对应的明文密码不同。

## 2.4 配置步骤

#### 1. 基于RBAC的SNMPv3配置

\# 配置接口Vlan-interface2的IP地址。

<Agent> system-view

[Agent] interface Vlan-interface2

[Agent-Vlan-interface2] ip address 192.168.100.68 24

[Agent-Vlan-interface2] quit

\# 设置Agent使用的SNMP版本为v3。

[Agent] snmp-agent sys-info version v3

\# 创建用户角色test，允许他读写internet子树（OID为“1.3.6.1”）下的所有对象。

[Agent] role name test

[Agent-role-test] rule 1 permit read write oid 1.3.6.1

[Agent-role-test] quit

\# 创建SNMPv3用户managev3user，为其绑定用户角色test，认证算法为SHA-1，明文认证密码为123456TESTauth&!，加密算法为AES，明文加密密码是123456TESTencr&!。

[Agent] snmp-agent usm-user v3 managev3user  user-role test simple authentication-mode sha 123456TESTauth&!  privacy-mode aes128 123456TESTencr&!

\# 配置设备的联系人和位置信息，以方便维护。

[Agent] snmp-agent sys-info contact Mr.Wang-Tel:3306

[Agent] snmp-agent sys-info location telephone-closet,3rd-floor

\# 开启SNMP告警功能。

[Agent] snmp-agent trap enable

\# 设置接收SNMP告警信息的目的主机IP地址，即NMS的IP地址，配置安全认证参数为managev3user。

[Agent] snmp-agent target-host trap address udp-domain 192.168.100.4 params securityname managev3user v3 privacy

#### 2. 基于VACM的SNMPv3配置

\# 配置接口Vlan-interface2的IP地址。

<Agent> system-view

[Agent] interface Vlan-interface2

[Agent-Vlan-interface2] ip address 192.168.100.68 24

[Agent-Vlan-interface2] quit

\# 设置Agent使用的SNMP版本为v3。

<Agent> system-view

[Agent] snmp-agent sys-info version v3

\# 创建MIB视图，名字为mibtest，包含internet子树（OID为“1.3.6.1”）下的所有对象。

[Agent] snmp-agent mib-view included mibtest 1.3.6.1

\# 创建SNMPv3组managev3group，并配置与该组绑定的SNMPv3用户与NMS建立连接时，均进行认证和加密，NMS可以对设备进行读写的视图均为mibtest。

[Agent] snmp-agent group v3 managev3group privacy read-view mibtest write-view mibtest notify-view mibtest

\# 创建SNMPv3用户managev3user，认证算法为SHA-1，明文认证密码为123456TESTauth&!，加密算法为AES，明文加密密码是123456TESTencr&!。

[Agent] snmp-agent usm-user v3 managev3user  managev3group simple authentication-mode sha 123456TESTauth&!  privacy-mode aes128 123456TESTencr&!

\# 配置设备的联系人和位置信息，以方便维护。

[Agent] snmp-agent sys-info contact Mr.Wang-Tel:3306

[Agent] snmp-agent sys-info location telephone-closet,3rd-floor

\# 开启SNMP告警功能。

[Agent] snmp-agent trap enable

\# 设置接收SNMP告警信息的目的主机IP地址，即NMS的IP地址，配置安全认证参数为managev3user。

[Agent] snmp-agent target-host trap address udp-domain 192.168.100.4 params securityname managev3user v3 privacy

#### 3. NMS的配置

\# 配置SNMP模板。

·   登录iMC，选择“系统管理”页签，单击导航树中的[资源管理/SNMP模板]菜单项，进入SNMP模板配置页面，在该页面中单击<增加>按钮，进入增加SNMP模板配置页面。

·   配置SNMP模板的名称为SNMPv3。

·   选择参数类型为SNMPv3 Priv-Aes128 Auth-Sha。

·   配置SNMP用户名为managev3user。

·   明文认证密码为123456TESTauth&!。

·   明文加密密码为123456TESTencr&!。

·   其它参数采用缺省值，并单击<确定>按钮完成操作。

图3 增加SNMP模板页面

![img](https://resource.h3c.com/cn/202303/28/20230328_8774824_x_Img_x_png_5_1816266_30005_0.png)

 

\# 选择“资源”页签，单击导航树中的[资源管理/增加设备]菜单项，进入增加设备配置页面，在该页面中输入设备的主机名或IP地址，并点击<配置SNMP参数/设置>链接。

图4 增加设备页面

![img](https://resource.h3c.com/cn/202303/28/20230328_8774825_x_Img_x_png_6_1816266_30005_0.png)

 

\# 进入SNMP参数设置页面配置SNMP参数。

·   选择“从已有的SNMP参数模板中选取”。

·   选择名称为“SNMPv3”的SNMP模板。

·   单击<确定>按钮完成操作，返回到“增加设备”页面。

图5 SNMP参数设置页面

![img](https://resource.h3c.com/cn/202303/28/20230328_8774826_x_Img_x_png_7_1816266_30005_0.png)

 

·   在“增加设备”页面单击<确定>按钮，iMC返回增加设备成功信息。增加设备成功后，用户即可通过iMC对设备进行配置、管理和维护。

图6 增加设备成功页面

![img](https://resource.h3c.com/cn/202303/28/20230328_8774827_x_Img_x_png_8_1816266_30005_0.png)

 

## 2.5 验证配置

\# 完成以上配置之后，在设备上的某个空闲接口执行**shutdown**或**undo** **shutdown**操作，设备会向NMS发送接口状态改变的Trap。

\# 在iMC的“告警>告警浏览>全部告警”页面中会显示上述接口状态改变的Trap信息。

## 2.6 配置文件

·   基于RBAC的配置文件

\#

 snmp-agent

 snmp-agent sys-info contact Mr.Wang-Tel:3306 

 snmp-agent sys-info location telephone-closet,3rd-floor

 snmp-agent sys-info version v3 

 snmp-agent trap enable arp

 snmp-agent trap enable syslog

 snmp-agent target-host trap address udp-domain 192.168.100.4 params securityname managev3user v3 privacy

 snmp-agent usm-user v3 managev3user user-role test cipher authentication-mode sha $c$3$5JaJZ6gNXlyNRq2FR2ELDT3QQH1exwJRWdYYq7eLfcBewuM5ncM= privacy-mode aes128 $c$3$+bbXZS4+PnsLDyr16OogzBckaLzR6XMDwZQuLBU8RM+dpw==

\# 

role name test

 rule 1 permit read write oid 1.3.6.1

\#

·   基于VACM的配置文件

\#

 snmp-agent

 snmp-agent sys-info contact Mr.Wang-Tel:3306 

 snmp-agent sys-info location telephone-closet,3rd-floor

 snmp-agent sys-info version v3 

 snmp-agent group v3 managev3group privacy read-view mibtest write-view mibtest notify-view mibtest

 snmp-agent mib-view included mibtest internet

 snmp-agent trap enable arp

 snmp-agent trap enable syslog

 snmp-agent target-host trap address udp-domain 192.168.100.4 params securityname managev3user v3 privacy

 snmp-agent usm-user v3 managev3user managev3group cipher authentication-mode sha $c$3$5JaJZ6gNXlyNRq2FR2ELDT3QQH1exwJRWdYYq7eLfcBewuM5ncM= privacy-mode aes128 $c$3$+bbXZS4+PnsLDyr16OogzBckaLzR6XMDwZQuLBU8RM+dpw==

\# 

## 2.7 相关资料

·   产品配套“网络管理和监控配置指导”中的“SNMP”。

·   产品配套“网络管理和监控命令参考”中的“SNMP”。



 

# 3 SNMP应用ACL限制非法网管访问

## 3.1 简介

本案例介绍通过基本ACL实现仅指定的网管能够访问交换机的配置方法。

## 3.2 组网需求

如[图3](https://www.h3c.com/cn/d_202303/1816266_30005_0.htm#_Ref126913872)所示，iMC服务器作为NMS通过SNMPv2c协议对设备（Agent）进行监控管理，只读团体名为readtest，读写团体名为writetest，并且当设备出现故障时能够主动向NMS发送告警信息。

图3 SNMP应用ACL限制非法网管访问组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774828_x_Img_x_png_9_1816266_30005_0.png)

## 3.3 配置注意事项

·   用户在设备和NMS上配置的SNMP版本号和团体字必须一致，否则，NMS无法对设备进行管理和维护。

·   不同厂商的NMS软件配置方法不同，关于NMS的详细配置，具体请参考NMS的相关手册。本配置举例中，以iMC PLAT 7.0 (E0202)为例进行介绍。

## 3.4 配置步骤

#### 1. Agent的配置

\# 配置接口Vlan-interface2的IP地址，Agent使用的SNMP版本为v2c。

<Agent> system-view

[Agent] interface Vlan-interface 2

[Agent-Vlan-interface 2] ip address 192.168.100.68 24

[Agent-Vlan-interface 2] quit

[Agent] snmp-agent sys-info version v2c

[Agent] quit

\# 配置访问限制，只允许IP地址为1.1.1.1的NMS使用该团体名对设备上缺省视图内的MIB对象进行读写操作，禁止其它NMS使用该团体名执行写操作。

[Sysname] acl basic 2001

[Sysname-acl-ipv4-basic-2001] rule permit source 192.168.100.4 0.0.0.0

[Sysname-acl-ipv4-basic-2001] rule deny source any

[Sysname-acl-ipv4-basic-2001] quit

\# 创建MIB视图信息，视图名称为mibtest，通过MIB视图限制网管仅能访问指定的MIB（OID为“1.3.6.1.2.1”）。

[Sysname] snmp-agent mib-view included mibtest 1.3.6.1.2.1

\# 配置只读团体名为readtest，读写团体名为writetest。

[Agent] snmp-agent community read readtest

[Agent] snmp-agent community write writetest

\# 设置设备的联系人和位置信息，以方便维护。

[Agent] snmp-agent sys-info contact Mr.Wang-Tel:3306

[Agent] snmp-agent sys-info location telephone-closet,3rd-floor

\# 设置允许向NMS发送告警信息，使用的团体名为readtest。

[Agent] snmp-agent trap enable

[Agent] snmp-agent target-host trap address udp-domain 192.168.100.4 params securityname readtest v2c

#### 2. NMS的配置

(1)   登录进入iMC管理平台，选择“资源”页签，单击导航树中的[增加设备]菜单项，进入增加设备配置页面。在该页面中输入设备的主机名或IP地址，并点击<配置SNMP参数/设置>链接。

图4 增加设备配置页面

![img](https://resource.h3c.com/cn/202303/28/20230328_8774818_x_Img_x_png_10_1816266_30005_0.png)

 

(2)   进入SNMP参数设置页面配置SNMP参数。

·   设置参数类型为“SNMPv2c”；

·   设置只读团体字为“readtest”；

·   设置读写团体字为“writetest”；

·   其它参数采用缺省值，并单击<确定>按钮完成操作。

图5 SNMP参数设置页面

![img](https://resource.h3c.com/cn/202303/28/20230328_8774819_x_Img_x_png_11_1816266_30005_0.png)

 

(3)   在增加设备配置页面单击<确定>按钮，iMC返回增加设备成功信息。增加设备成功后，用户即可通过iMC对设备进行配置、管理和维护。

图6 增加设备成功页面

![img](https://resource.h3c.com/cn/202303/28/20230328_8774820_x_Img_x_png_12_1816266_30005_0.png)

 

## 3.5 验证配置

\# 完成以上配置之后，在设备上的某个空闲接口执行**shutdown**或**undo** **shutdown**操作，设备会向NMS发送接口状态改变的Trap。

\# 在iMC的“告警>告警浏览>全部告警”页面中会显示上述接口状态改变的Trap信息。

\# 只允许指定IP地址192.168.100.4的网管读写交换机的指定MIB。

## 3.6 配置文件

\# 

 snmp-agent 

 acl basic 2001

 rule permit source 192.168.100.68 0.0.0.0

 rule deny source any

 snmp-agent mib-view included mibtest 1.3.6.1.2.1

 snmp-agent community write writetest

 snmp-agent community read readtest 

 snmp-agent sys-info contact Mr.Wang-Tel:3306 

 snmp-agent sys-info location telephone-closet,3rd-floor

 snmp-agent sys-info version v2c

 snmp-agent trap enable

 snmp-agent target-host trap address udp-domain 192.168.100.4 params securityname readtest v2c

\# 