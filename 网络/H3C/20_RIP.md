# RIP基本功能配置

## 1.1 简介

本案例介绍RIP基本功能的配置方法。

## 1.2 组网需求

如[图1](https://www.h3c.com/cn/d_202303/1816254_30005_0.htm#_Ref80966663)所示，要求所有交换机均运行RIP-2协议，Host A和Host B两台主机能互相通信。

图1 RIP基本配置组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774744_x_Img_x_png_0_1816254_30005_0.png)

 

## 1.3 配置步骤

#### 1. 配置Host A和Host B

为Host A配置IP地址为30.1.1.2，掩码为255.255.255.0，网关地址为30.1.1.1。

为Host B配置IP地址为40.1.1.2，掩码为255.255.255.0，网关地址为40.1.1.1。

#### 2. 配置Switch A

\# 创建VLAN，在VLAN中加入对应的端口，并配置各VLAN接口的IP地址。

<SwitchA> system-view

[SwitchA] vlan 100

[SwitchA-vlan100] port gigabitethernet 1/0/1

[SwitchA-vlan100] quit

[SwitchA] vlan 300

[SwitchA-vlan300] port gigabitethernet 1/0/2

[SwitchA-vlan300] quit

[SwitchA] interface vlan-interface 100

[SwitchA-Vlan-interface100] ip address 10.1.1.1 24

[SwitchA-Vlan-interface100] quit

[SwitchA] interface vlan-interface 300

[SwitchA-Vlan-interface300] ip address 30.1.1.1 24

[SwitchA-Vlan-interface300] quit

\# 配置RIP-2。

[SwitchA] rip

[SwitchA-rip-1] network 10.1.1.0

[SwitchA-rip-1] network 30.1.1.0

[SwitchA-rip-1] version 2

[SwitchA-rip-1] undo summary

[SwitchA-rip-1] quit

\# 保存配置。

[SwitchA] save force

#### 3. 配置Switch B

\# 创建VLAN，在VLAN中加入对应的端口，并配置各VLAN接口的IP地址。

<SwitchB> system-view

[SwitchB] vlan 100

[SwitchB-vlan100] port gigabitethernet 1/0/1

[SwitchB-vlan100] quit

[SwitchB] vlan 200

[SwitchB-vlan200] port gigabitethernet 1/0/2

[SwitchB-vlan200] quit

[SwitchB] interface vlan-interface 100

[SwitchB-Vlan-interface100] ip address 10.1.1.2 24

[SwitchB-Vlan-interface100] quit

[SwitchB] interface vlan-interface 200

[SwitchB-Vlan-interface200] ip address 20.1.1.1 24

[SwitchB-Vlan-interface200] quit

\# 配置RIP-2。

[SwitchB] rip

[SwitchB-rip-1] network 10.1.1.0

[SwitchB-rip-1] network 20.1.1.0

[SwitchB-rip-1] version 2

[SwitchB-rip-1] undo summary

[SwitchB-rip-1] quit

\# 保存配置。

[SwitchB] save force

#### 4. 配置Switch C

\# 创建VLAN，在VLAN中加入对应的端口，并配置各VLAN接口的IP地址。

<SwitchC> system-view

[SwitchC] vlan 200

[SwitchC-vlan200] port gigabitethernet 1/0/1

[SwitchC-vlan200] quit

[SwitchC] vlan 400

[SwitchC-vlan400] port gigabitethernet 1/0/2

[SwitchC-vlan400] quit

[SwitchC] interface vlan-interface 200

[SwitchC-Vlan-interface200] ip address 20.1.1.2 24

[SwitchC-Vlan-interface200] quit

[SwitchC] interface vlan-interface 400

[SwitchC-Vlan-interface400] ip address 40.1.1.1 24

[SwitchC-Vlan-interface400] quit

\# 配置RIP-2。

[SwitchC] rip

[SwitchC-rip-1] network 20.1.1.0

[SwitchC-rip-1] network 40.1.1.0

[SwitchC-rip-1] version 2

[SwitchC-rip-1] undo summary

[SwitchC-rip-1] quit

\# 保存配置。

[SwitchC] save force

## 1.4 验证配置

\# 查看Switch A的RIP路由表信息。

[SwitchA] display rip 1 route

 Route Flags: R - RIP, T - TRIP

​       P - Permanent, A - Aging, S - Suppressed, G - Garbage-collect

​       D - Direct, O - Optimal, F - Flush to RIB

 \----------------------------------------------------------------------------

 Peer 10.1.1.2 on Vlan-interface100

   Destination/Mask    Nexthop      Cost  Tag   Flags  Sec

   20.1.1.0/24       10.1.1.2     1    0    RAOF  27

   40.1.1.0/24       10.1.1.2     2    0    RAOF  27

 Local route

   Destination/Mask    Nexthop      Cost  Tag   Flags  Sec

   10.1.1.0/24       0.0.0.0      0    0    RDOF  -

   30.1.1.0/24       0.0.0.0      0    0    RDOF  -

\# 查看Switch B的RIP路由表信息。

[SwitchB] display rip 1 route

 Route Flags: R - RIP, T - TRIP

​       P - Permanent, A - Aging, S - Suppressed, G - Garbage-collect

​       D - Direct, O - Optimal, F - Flush to RIB

 \----------------------------------------------------------------------------

 Peer 10.1.1.1 on Vlan-interface100

   Destination/Mask    Nexthop      Cost  Tag   Flags  Sec

   30.1.1.0/24       10.1.1.1     1    0    RAOF  0

 Peer 20.1.1.2 on Vlan-interface200

   Destination/Mask    Nexthop      Cost  Tag   Flags  Sec

   40.1.1.0/24       20.1.1.2     1    0    RAOF  9

 Local route

   Destination/Mask    Nexthop      Cost  Tag   Flags  Sec

   20.1.1.0/24       0.0.0.0      0    0    RDOF  -

   10.1.1.0/24       0.0.0.0      0    0    RDOF  -

\# 查看Switch C的RIP路由表信息。

[SwitchC] display rip 1 route

 Route Flags: R - RIP, T - TRIP

​       P - Permanent, A - Aging, S - Suppressed, G - Garbage-collect

​       D - Direct, O - Optimal, F - Flush to RIB

 \----------------------------------------------------------------------------

 Peer 20.1.1.1 on Vlan-interface200

   Destination/Mask    Nexthop      Cost  Tag   Flags  Sec

   10.1.1.0/24       20.1.1.1     1    0    RAOF  32

   30.1.1.0/24       20.1.1.1     2    0    RAOF  32

 Local route

   Destination/Mask    Nexthop      Cost  Tag   Flags  Sec

   20.1.1.0/24       0.0.0.0      0    0    RDOF  -

   40.1.1.0/24       0.0.0.0      0    0    RDOF  -

\# 在Host A上使用ping命令验证Host B是否可达（假定主机安装的操作系统为Windows XP）。

C:\Documents and Settings\Administrator>ping 40.1.1.2

 

Pinging 40.1.1.2 with 32 bytes of data:

 

Reply from 40.1.1.2: bytes=32 time=1ms TTL=126

Reply from 40.1.1.2: bytes=32 time=1ms TTL=126

Reply from 40.1.1.2: bytes=32 time=1ms TTL=126

Reply from 40.1.1.2: bytes=32 time=1ms TTL=126

 

Ping statistics for 40.1.1.2:

  Packets: Sent = 4, Received = 4, Lost = 0 (0% loss),

Approximate round trip times in milli-seconds:

  Minimum = 1ms, Maximum = 1ms, Average = 1ms

## 1.5 配置文件

·   Switch A： 

\#

rip 1

 undo summary

 version 2

 network 10.0.0.0

 network 30.0.0.0

\#

vlan 100

\#

vlan 300

\#

interface Vlan-interface100

 ip address 10.1.1.1 255.255.255.0

\#

interface Vlan-interface300

 ip address 30.1.1.1 255.255.255.0

\#

interface GigabitEthernet1/0/1

 port link-mode bridge

 port access vlan 100

\#

interface GigabitEthernet1/0/2

 port link-mode bridge

 port access vlan 300

\#

·   Switch B ：

\#

rip 1

 undo summary

 version 2

 network 10.0.0.0

 network 20.0.0.0

\#

vlan 100

\#

vlan 200

\#

interface Vlan-interface100

 ip address 10.1.1.2 255.255.255.0

\#

interface Vlan-interface200

 ip address 20.1.1.1 255.255.255.0

\#

interface GigabitEthernet1/0/1

 port link-mode bridge

 port access vlan 100

\#

interface GigabitEthernet1/0/2

 port link-mode bridge

 port access vlan 200

\#

·   Switch C ：

\#

rip 1

 undo summary

 version 2

 network 20.0.0.0

 network 40.0.0.0

\#

vlan 200

\#

vlan 400

\#

interface Vlan-interface200

 ip address 20.1.1.2 255.255.255.0

\#

interface Vlan-interface400

 ip address 40.1.1.1 255.255.255.0

\#

interface GigabitEthernet1/0/1

 port link-mode bridge

 port access vlan 200

\#

interface GigabitEthernet1/0/2

 port link-mode bridge

 port access vlan 400

\#