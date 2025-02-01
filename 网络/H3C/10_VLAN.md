# VLAN

## 基于端口的 VLAN

### 组网需求

如[图1](https://www.h3c.com/cn/d_202303/1816244_30005_0.htm#_Ref79678597)所示，Host A和Host C属于部门A，但是通过不同的设备接入公司网络；Host B和Host  D属于部门B，也通过不同的设备接入公司网络。为了通信的安全性，以及避免广播报文泛滥，公司网络中使用VLAN技术来隔离部门间的二层流量。其中部门A使用VLAN 100，部门B使用VLAN 200。现要求同一VLAN内的主机能够互通，即Host A和Host C能够互通，Host B和Host  D能够互通。

图1 基于端口的VLAN组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774699_x_Img_x_png_0_1816244_30005_0.png)

 

## 1.3 配置步骤

#### 1. Device A的配置

\# 创建VLAN 100，并将GigabitEthernet1/0/1加入VLAN 100

<DeviceA> system-view

[DeviceA] vlan 100

[DeviceA-vlan100] port gigabitEthernet 1/0/1

[DeviceA-vlan100] quit

\# 创建VLAN 200，并将GigabitEthernet1/0/2加入VLAN 200

[DeviceA] vlan 200

[DeviceA-vlan200] port GigabitEthernet 1/0/2

[DeviceA-vlan200] quit

\# 为了使Device A上VLAN 100和VLAN 200的报文能发送给Device B，将GigabitEthernet 1/0/2的链路类型配置为Trunk，并允许VLAN 100和VLAN 200的报文通过。

[DeviceA] interface gigabitEthernet 1/0/3

[DeviceA-GigabitEthernet1/0/3] port link-type trunk

[DeviceA-GigabitEthernet1/0/3] port trunk permit vlan 100 200

[DeviceA-GigabitEthernet1/0/3] quit

\# 保存配置

[DeviceA] save force

#### 2. Device B的配置

\# 创建VLAN 100，并将GigabitEthernet1/0/1加入VLAN 100

<DeviceB> system-view

[DeviceB] vlan 100

[DeviceB-vlan100] port gigabitEthernet 1/0/1

[DeviceB-vlan100] quit

\# 创建VLAN 200，并将GigabitEthernet1/0/2加入VLAN 200

[DeviceB] vlan 200

[DeviceB-vlan200] port gigabitEthernet 1/0/2

[DeviceB-vlan200] quit

\# 为了使Device B上VLAN 100和VLAN 200的报文能发送给Device A，将GigabitEthernet 1/0/3的链路类型配置为Trunk，并允许VLAN 100和VLAN 200的报文通过。

[DeviceB] interface gigabitEthernet 1/0/3

[DeviceB-GigabitEthernet1/0/3] port link-type trunk

[DeviceB-GigabitEthernet1/0/3] port trunk permit vlan 100 200

[DeviceB-GigabitEthernet1/0/3] quit

\# 保存配置

[DeviceB] save force

\# 将Host A和Host C配置在一个网段，例如192.168.100.0/24；将Host B和Host D配置在一个网段，比如192.168.200.0/24。

## 1.4 验证配置

\# 显示Device A上VLAN的配置信息。

<DeviceA> display vlan 100

 VLAN ID: 100

 VLAN type: Static

 Route interface: Not configured

 Description: VLAN 0100

 Name: VLAN 0100

 Tagged ports:

  GigabitEthernet1/0/3(D)

 Untagged ports: 

  GigabitEthernet1/0/1(D)

<DeviceA> display vlan 200

 VLAN ID: 200

 VLAN type: Static

 Route interface: Not configured

 Description: VLAN 0200

 Name: VLAN 0200

 Tagged ports:

  GigabitEthernet1/0/3(D)

 Untagged ports:

  GigabitEthernet1/0/2(D)

\# 显示Device B上VLAN的配置信息。

<DeviceB> display vlan 100

 VLAN ID: 100

 VLAN type: Static

 Route interface: Not configured

 Description: VLAN 0100

 Name: VLAN 0100

 Tagged ports:

  GigabitEthernet1/0/3(D)

 Untagged ports: 

GigabitEthernet1/0/1(D) 

<DeviceB> display vlan 200

 VLAN ID: 200

 VLAN type: Static

 Route interface: Not configured

 Description: VLAN 0200

 Name: VLAN 0200

 Tagged ports:

  GigabitEthernet1/0/3(D)

 Untagged ports:

  GigabitEthernet1/0/2(D)

## 1.5 配置文件

·   Device A： 

\#

vlan 100

\#

vlan 200

\#

interface GigabitEthernet1/0/1

 port link-mode bridge

 port access vlan 100

\#

interface GigabitEthernet1/0/2

 port link-mode bridge

 port access vlan 200

\#

interface GigabitEthernet1/0/3

 port link-mode bridge

 port link-type trunk

 port trunk permit vlan 1 100 200

·   #Device B ：

vlan 100

\#

vlan 200

\#

interface GigabitEthernet1/0/1

 port link-mode bridge

 port access vlan 100

\#

interface GigabitEthernet1/0/2

 port link-mode bridge

 port access vlan 200

\#

interface GigabitEthernet1/0/3

 port link-mode bridge

 port link-type trunk

 port trunk permit vlan 1 100 200 

## Super VLAN

### 组网需求

·   VLAN 2中的用户通过Device A的GigabitEthernet1/0/1接入网络，VLAN 3中的用户通过Device A的GigabitEthernet1/0/2接入网络。VLAN 2中有30个用户，VLAN 3中有50个用户。

·   Device A的GigabitEthernet1/0/3和Device B的GigabitEthernet1/0/1属于VLAN 20。

·   VLAN 20中的终端用户都使用192.168.2.0/24 网段的IP地址，使用192.168.2.1作为网关地址。

现要求通过配置Super VLAN功能实现以下应用需求：

·   VLAN 2和VLAN 3中的终端用户都使用192.168.1.0/24网段的IP地址以节省IP地址资源，使用192.168.1.1作为网关地址。

·   VLAN 2、VLAN 3、VLAN 20中的终端用户二层隔离，三层互通。

![img](https://resource.h3c.com/cn/202303/28/20230328_8774700_x_Img_x_png_1_1816244_30005_0.png)

 

## 2.3 配置注意事项

由于Super VLAN中不能包含物理端口，由此若某VLAN中已经包含物理端口，则该VLAN不能被配置为Super VLAN。

## 2.4 配置步骤

#### 1. Device A的配置

\# 创建Super VLAN 10。

<DeviceA> system-view

[DeviceA] vlan 10

[DeviceA-vlan10] supervlan

[DeviceA-vlan10] quit

\# 创建VLAN 2并将端口GigabitEthernet1/0/1加入VLAN 2。

[DeviceA] vlan 2

[DeviceA-vlan2] port gigabitethernet 1/0/1

[DeviceA-vlan2] quit

\# 创建VLAN 3并将端口GigabitEthernet1/0/2加入VLAN 3。

[DeviceA] vlan 3

[DeviceA-vlan3] port gigabitethernet 1/0/2

[DeviceA-vlan3] quit

\# 将Super VLAN 10和Sub VLAN 2和Sub VLAN 3关联。

[DeviceA] vlan 10

[DeviceA-vlan10] subvlan 2 3

[DeviceA-vlan10] quit

\# 配置Super VLAN 10对应的VLAN接口的IP地址和本地代理ARP功能。

[DeviceA] interface vlan-interface 10

[DeviceA-Vlan-interface10] ip address 192.168.1.1 24

[DeviceA-Vlan-interface10] local-proxy-arp enable

[DeviceA-Vlan-interface10] quit

\# 创建VLAN 20。

[DeviceA] vlan 20

[DeviceA-vlan20] quit

\# 将端口GigabitEthernet1/0/3配置为Trunk端口并允许VLAN 20通过，取消允许VLAN 1通过。

[DeviceA] interface gigabitethernet 1/0/3

[DeviceA-GigabitEthernet1/0/3] port link-type trunk

[DeviceA-GigabitEthernet1/0/3] undo port trunk permit vlan 1

[DeviceA-GigabitEthernet1/0/3] port trunk permit vlan 20

[DeviceA-GigabitEthernet1/0/3] quit

\# 配置VLAN 20对应的VLAN接口的IP地址。

[DeviceA] interface Vlan-interface 20

[DeviceA-Vlan-interface20] ip address 192.168.2.1 24

[DeviceA-Vlan-interface20] quit

\# 保存配置

[DeviceA] save force

#### 2. Device B的配置

\# 创建VLAN 20。

[DeviceB] vlan 20

[DeviceB-vlan20] quit

\# 将端口GigabitEthernet1/0/1配置为Trunk端口并允许VLAN 20通过，取消允许VLAN 1通过。

[DeviceB] interface gigabitethernet 1/0/1

[DeviceB-GigabitEthernet1/0/1] port link-type trunk

[DeviceB-GigabitEthernet1/0/1] undo port trunk permit vlan 1

[DeviceB-GigabitEthernet1/0/1] port trunk permit vlan 20

[DeviceB-GigabitEthernet1/0/1] quit

\# 将端口GigabitEthernet1/0/2加入VLAN 20。

[DeviceB] vlan 20

[DeviceB-vlan20] port gigabitethernet 1/0/2

[DeviceB-vlan20] quit

\# 保存配置

[DeviceB] save force

## 2.5 验证配置

\# 显示Device A上Super VLAN的配置信息。

<DeviceA> display supervlan

 Super VLAN ID: 10

 Sub-VLAN ID: 2-3

 

 VLAN ID: 10

 VLAN type: Static

 It is a super VLAN.

 Route interface: Configured

 IPv4 address: 192.168.1.1

 IPv4 subnet mask: 255.255.255.0

 Description: VLAN 0010

 Name: VLAN 0010

 Tagged ports:  None

 Untagged ports: None

 

 VLAN ID: 2

 VLAN type: Static

 It is a sub-VLAN.

 Route interface: Configured

 IPv4 address: 192.168.1.1

 IPv4 subnet mask: 255.255.255.0

 Description: VLAN 0002

 Name: VLAN 0002

 Tagged ports:  None

 Untagged ports:

  GigabitEthernet1/0/1

 

 VLAN ID: 3

 VLAN type: Static

 It is a sub-VLAN.

 Route interface: Configured

 IPv4 address: 192.168.1.1

 IPv4 subnet mask: 255.255.255.0

 Description: VLAN 0003

 Name: VLAN 0003

 Tagged ports:  None

 Untagged ports:

GigabitEthernet1/0/2

\# 显示Device A上VLAN 20的配置信息。

<DeviceA> display vlan 20

 VLAN ID: 20

 VLAN type: Static

 Route interface: Configured

 IPv4 address: 192.168.2.1

 IPv4 subnet mask: 255.255.255.0

 Description: VLAN 0020

 Name: VLAN 0020

 Tagged ports:

  GigabitEthernet1/0/3

 Untagged ports: None

\# 显示Device B上VLAN 20的配置信息。

<DeviceA> display vlan 20

 VLAN ID: 20

 VLAN type: Static

 Route interface: Not configured

 Description: VLAN 0020

 Name: VLAN 0020

 Tagged ports:

  GigabitEthernet1/0/1

 Untagged ports:

  GigabitEthernet1/0/2

## 2.6 配置文件

·   Device A ： 

\#

vlan 2

\#

vlan 3

\#

vlan 10

 supervlan

 subvlan 2 3

\#

vlan 20

\#

interface Vlan-interface10

 ip address 192.168.1.1 255.255.255.0

 local-proxy-arp enable

\#

interface Vlan-interface20

 ip address 192.168.2.1 255.255.255.0

\#

interface GigabitEthernet1/0/1

 port link-mode bridge

 port access vlan 2

\#

interface GigabitEthernet1/0/2

 port link-mode bridge

 port access vlan 3

\#

interface GigabitEthernet1/0/3

 port link-mode bridge

 port link-type trunk

 undo port trunk permit vlan 1

 port trunk permit vlan 20

·   #Device B ：

\#

vlan 20

\#

interface GigabitEthernet1/0/1

 port link-mode bridge

 port link-type trunk

 undo port trunk permit vlan 1

 port trunk permit vlan 20

\#

interface GigabitEthernet1/0/2

 port link-mode bridge

 port access vlan 20

\#

 

## Voice VLAN

### 组网需求

为了保障语音数据能够优先转发，需要将语音电话和Laptop地址区分开，将语音电话地址设置成192.168.2.0网段划分到VLAN2，将Laptop地址设置成192.168.10.0网段划分到VLAN10，路由器作为DHCP服务器给语音电话和Laptop下发IP地址。

![img](https://resource.h3c.com/cn/202303/28/20230328_8774701_x_Img_x_png_2_1816244_30005_0.png)

 

## 3.3 配置步骤

#### 1. Swtich的配置

\# 开启POE，为话机供电。

<Switch> system-view 

[Switch] interface gigabitEthernet1/0/1

[Switch-GigabitEthernet1/0/1] poe enable

[Switch-GigabitEthernet1/0/1] quit

\# 创建话机所属VLAN2以及PC所属VLAN10

[Switch] vlan 2

[Switch-vlan2] quit

[Switch] vlan 10

[Switch-vlan10] quit

\# 设置允许通过的OUI地址为MAC地址前缀为6ca8-4900-0000，即当报文的前缀为6ca8-4900-0000时，设备会把它当成语音报文来处理

[Switch] voice-vlan mac-address 6ca8-4900-0000 mask ffff-ff00-0000 description avaya

\# 将端口GigabitEthernet1/0/1设定为Hybrid端口，开启端口Voice VLAN功能

[Switch] interface gigabitEthernet 1/0/1

[Switch-GigabitEthernet1/0/1] port link-type hybrid

[Switch-GigabitEthernet1/0/1] voice-vlan 2 enable

\# 设置PC所属vlan为vlan10

[Switch-GigabitEthernet1/0/1] port hybrid pvid vlan 10

[Switch-GigabitEthernet1/0/1] port hybrid vlan 10 untagged

[SWITCH-GigabitEthernet1/0/1] quit

\#设备连接dhcp服务器的接口GigabitEthernet 1/0/2，允许VLAN2、LAN10通过

[Switch] interface gigabitEthernet 1/0/2

[Switch-GigabitEthernet1/0/2] port link-type trunk

[Switch-GigabitEthernet1/0/2] port trunk permit vlan 2 10

[Switch-GigabitEthernet1/0/2] quit

\# 保存配置

[Switch] save force

#### 2. Router的配置

\# 创建VLAN2、VLAN10及其对应的VLAN接口，为该虚接口配置IP地址

<Router> system-view

[Router] vlan 2

[Router-vlan2] quit

[Router] vlan 10

[Router-vlan10] quit

[Router] interface Vlan-interface 2

[Router-Vlan-interface2] ip address 192.168.2.1 255.255.255.0

[Router-Vlan-interface2] quit

[Router] interface Vlan-interface 10

[Router-Vlan-interface10] ip address 192.168.10.1 255.255.255.0

[Router-Vlan-interface10] quit

\# 设备连接交换机的接口GigabitEthernet 1/0/1，允许VLAN2、VLAN10通过

[Router] interface GigabitEthernet 1/0/1

[Router-GigabitEthernet1/0/1] port link-type trunk

[Router-GigabitEthernet1/0/1] port trunk permit vlan 2 10

[Router-GigabitEthernet1/0/1] quit

\# 开启DHCP服务。

[Router] dhcp enable

\# 设置话机VLAN2的DHCP地址池

[Router] dhcp server ip-pool vlan2

[Router-dhcp-pool-vlan2] network 192.168.2.0 mask 255.255.255.0

[Router-dhcp-pool-vlan2] gateway-list 192.168.2.1

[Router-dhcp-pool-vlan2] quit

\# 设置Laptop VLAN10的DHCP地址池

[Router] dhcp server ip-pool vlan10

[Router-dhcp-pool-vlan10] network 192.168.10.0 mask 255.255.255.0

[Router-dhcp-pool-vlan10] gateway-list 192.168.10.1

[Router-dhcp-pool-vlan10] dns-list 114.114.114.114

[Router-dhcp-pool-vlan10] quit

\# 保存配置

[Router] save force

## 3.4 验证配置

\# 交换机上查验证结果，查看话机是否加入到VLAN2

<Switch> display mac-address 

MAC Address VLAN ID STATE Port/Nickname AGING 

3897-d630-676b 10 Learned GE1/0/2 Y

3897-d630-676b 2 Learned GE1/0/2 Y

6ca8-4986-6d59 2 Learned GE1/0/1 Y

0068-eb95-3683 10 Learned GE1/0/1 Y 

\# 查看voice vlan 配置是否生效

<Switch> display voice-vlan mac-address

Oui Address Mask Description

0003-6b00-0000 ffff-ff00-0000 Cisco phone

00e0-7500-0000 ffff-ff00-0000 Polycom phone

6ca8-4900-0000 ffff-ff00-0000 avaya

\# 默认voice vlan为auto(自动模式)

<Switch> display voice-vlan state 

Current Voice VLANs: 1

Voice VLAN security mode: Security

Voice VLAN aging time: 1440 minutes

Voice VLAN enabled port and its mode:

PORT VLAN MODE COS DSCP

\--------------------------------------------------------------------

GE1/0/1 2 AUTO 6 46

\# DHCP服务器上查看话机和PC获取IP地址

%Sep 1 09:19:59:333 2021 DHCP DHCPS/5/DHCPS_ALLOCATE_IP: DHCP server information: Server IP = 192.168.2.1, DHCP client IP = 192.168.2.2, DHCP client hardware address = 6ca8-4986-6d59, DHCP client lease = 86400.

<Router> display dhcp server ip-in-use all

Pool utilization: 0.59%

IP address Client-identifier/ Lease expiration Type

Hardware address

192.168.2.2 6ca8-4986-6d59 Aug 31 2021 09:19:59 Auto:COMMITTED

192.168.10.4 0068-eb95-3683 Aug 31 2021 09:19:42 Auto:COMMITTED

## 3.5 配置文件

·   Switch ：

\#

 voice-vlan mac-address 6ca8-4900-0000 mask ffff-ff00-0000 description avaya

\#

vlan 2

\#

vlan 10

\#

interface GigabitEthernet1/0/1

 port link-mode bridge

 port link-type hybrid

 port hybrid vlan 10 untagged

 port hybrid pvid vlan 10

 voice-vlan 2 enable

 poe enable

\#

interface GigabitEthernet1/0/2

 port link-mode bridge

 port link-type trunk

 port trunk permit vlan 2 10

·   Router ：

\#

vlan 2

\#

vlan 10

\#

dhcp server ip-pool vlan2

 gateway-list 192.168.2.1

 network 192.168.2.0 255.255.255.0

\#

dhcp server ip-pool vlan10

 gateway-list 192.168.10.1

 network 192.168.10.0 255.255.255.0

 dns-list 114.114.114.114

\#

interface Vlan-interface2

 ip address 192.168.2.1 255.255.255.0

\#

interface Vlan-interface10

 ip address 192.168.10.1 255.255.255.0

\#

interface GigabitEthernet1/0/1

 port link-mode bridge

 port link-type trunk

 port trunk permit vlan 2 10

## Private VLAN

## 4.1 简介

本案例介绍Private VLAN的配置方法。

## 4.2 组网需求

如[图3](https://www.h3c.com/cn/d_202303/1816244_30005_0.htm#_Ref395260133)所示：

·   汇聚层设备Device A为接入设备Device B分配了VLAN 10，网关接口VLAN-interface10可以和所有用户互通，以便用户可以通过Device  A来访问外部网络。Device B连接的所有用户均处于同一网段10.0.0.0/24。

·   Host A和B属于销售部，Host C和D属于财务部。为保证安全，需要使不同部门之间二层隔离，同部门的用户之间则可以互通。

现由于Device A不能为Device B分配更多VLAN，要求通过Private VLAN功能实现：

·   Device A只需识别VLAN 10。

·   Device B在Primary VLAN 10下为各部门配置不同的Secondary VLAN，使部门间二层隔离。

图3 Private VLAN典型配置举例组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774702_x_Img_x_png_3_1816244_30005_0.png)

 

## 4.3 配置注意事项

·   Private VLAN功能只需要在接入设备Device B上配置。

·   系统缺省VLAN（VLAN 1）不支持Private VLAN相关配置。

## 4.4 配置步骤

#### 1. Dvice B的配置

\# 配置VLAN 10为Primary VLAN。

<DeviceB> system-view

[DeviceB] vlan 10

[DeviceB-vlan10] private-vlan primary

[DeviceB-vlan10] quit

\# 创建Secondary VLAN 201、202。

[DeviceB] vlan 201 to 202

\# 建立Primary VLAN 10和Secondary VLAN 201、202的映射关系。

[DeviceB] vlan 10

[DeviceB-vlan10] private-vlan secondary 201 to 202

[DeviceB-vlan10] quit

\# 配置上行端口GigabitEthernet1/0/1在VLAN 10中工作在promiscuous模式。

[DeviceB] interface gigabitethernet 1/0/1

[DeviceB-GigabitEthernet1/0/1] port private-vlan 10 promiscuous

[DeviceB-GigabitEthernet1/0/1] quit

\# 将下行端口GigabitEthernet1/0/2、GigabitEthernet1/0/3添加到VLAN 201，GigabitEthernet1/0/4、GigabitEthernet1/0/5添加到VLAN 202，并配置它们工作在host模式。

[DeviceB] interface range gigabitethernet 1/0/2 to gigabitethernet 1/0/3

[DeviceB-if-range] port access vlan 201

[DeviceB-if-range] port private-vlan host

[DeviceB-if-range] quit

[DeviceB] interface range gigabitethernet 1/0/4 to gigabitethernet 1/0/5

[DeviceB-if-range] port access vlan 202

[DeviceB-if-range] port private-vlan host

[DeviceB-if-range] quit

\# 保存配置

[DeviceB] save force

#### 2. Dvice A的配置

\# 创建VLAN 10。将接口GigabitEthernet1/0/1加入VLAN 10。

<DeviceA> system-view

[DeviceA] vlan 10

[DeviceA-vlan10] quit

[DeviceA] interface gigabitethernet 1/0/1

[DeviceA-GigabitEthernet1/0/1] port access vlan 10

[DeviceA-GigabitEthernet1/0/1] quit

\# 配置网关接口VLAN-interface10。

[DeviceA] interface vlan-interface 10

[DeviceA-Vlan-interface10] ip address 10.0.0.1 24

[DeviceA-Vlan-interface10] quit

\# 保存配置

[DeviceA] save force

## 4.5 验证配置

\# Device A可以ping通任意用户。查看ARP表，可以看到所有用户均属于VLAN 10。

[DeviceA] display arp

 Type: S-Static  D-Dynamic  O-Openflow  R-Rule  M-Multiport I-Invalid

IP address   MAC address  VLAN/VSI name Interface        Aging Type

10.0.0.2    0e9e-0671-0302 10      GE1/0/1         1062 D

10.0.0.3    0e9e-09f7-0402 10      GE1/0/1         1052 D

10.0.0.4    0e9e-0d94-0502 10      GE1/0/1         1164 D

10.0.0.5    0e9e-1263-0602 10      GE1/0/1         1109 D

\# 显示Device B上的Private VLAN配置情况。

<DeviceB> display private-vlan

 Primary VLAN ID: 10

 Secondary VLAN ID: 201-202

 

 VLAN ID: 10

 VLAN type: Static

 Private VLAN type: Primary

 Route interface: Not configured

 Description: VLAN 0010

 Name: VLAN 0010

 Tagged ports:

  None

 Untagged ports:

  GigabitEthernet1/0/1(U)      GigabitEthernet1/0/2(U)

  GigabitEthernet1/0/3(U)      GigabitEthernet1/0/4(U)

  GigabitEthernet1/0/5(U)

 

 VLAN ID: 201

 VLAN type: Static

 Private VLAN type: Secondary

 Route interface: Not configured

 Description: VLAN 0201

 Name: VLAN 0201

 Tagged ports:

  None

 Untagged ports:

  GigabitEthernet1/0/1(U)      GigabitEthernet1/0/2(U)

  GigabitEthernet1/0/3(U)

 

 VLAN ID: 202

 VLAN type: Static

 Private VLAN type: Secondary

 Route interface: Not configured

 Description: VLAN 0202

 Name: VLAN 0202

 Tagged ports:

  None

 Untagged ports:

  GigabitEthernet1/0/1(U)      GigabitEthernet1/0/4(U)

  GigabitEthernet1/0/5(U)

可以看到，工作在promiscuous模式的端口GigabitEthernet1/0/1和工作在host模式的端口GigabitEthernet1/0/2～GigabitEthernet1/0/5均以Untagged方式允许VLAN报文通过。

\# Host A、B之间可以互相ping通，Host C、D之间可以互相ping通。Host A、B与Host C、D之间均不能ping通。

## 4.6 配置文件

·   Device A： 

\#

vlan 10

\#

interface Vlan-interface10

 ip address 10.0.0.1 255.255.255.0

\#

interface GigabitEthernet1/0/1

 port link-mode bridge

 port access vlan 10

\#

·   Device B ：

\#

vlan 10

 private-vlan primary

 private-vlan secondary 201 to 202

\#

vlan 201 to 202

\#

interface GigabitEthernet1/0/1

 port link-mode bridge

 port link-type hybrid

 undo port hybrid vlan 1

 port hybrid vlan 10 201 to 202 untagged

 port hybrid pvid vlan 10

 port private-vlan 10 promiscuous

\#

interface GigabitEthernet1/0/2

 port link-mode bridge

 port link-type hybrid

 undo port hybrid vlan 1

 port hybrid vlan 10 201 untagged

 port hybrid pvid vlan 201

 port private-vlan host

\#

interface GigabitEthernet1/0/3

 port link-mode bridge

 port link-type hybrid

 undo port hybrid vlan 1

 port hybrid vlan 10 201 untagged

 port hybrid pvid vlan 201

 port private-vlan host

\#

interface GigabitEthernet1/0/4

 port link-mode bridge

 port link-type hybrid

 undo port hybrid vlan 1

 port hybrid vlan 10 202 untagged

 port hybrid pvid vlan 202

 port private-vlan host

\#

interface GigabitEthernet1/0/5

 port link-mode bridge

 port link-type hybrid

 undo port hybrid vlan 1

 port hybrid vlan 10 202 untagged

 port hybrid pvid vlan 202

 port private-vlan host

\#