# IGMP snooping快速配置指南

## 1.1 简介

本案例介绍如何配置IGMP snooping。

## 1.2 组网需求

如[图1](https://www.h3c.com/cn/d_202303/1816256_30005_0.htm#_Ref79001870)所示，在一个没有三层设备的纯二层网络环境中，组播源Source向组播组224.1.1.1发送组播数据，Host A和Host B是组播组224.1.1.1的接收者（Receiver），Host  C不是组播组224.1.1.1的接收者。所有接收者均使用IGMPv2，保持所有交换机上都运行版本2的IGMP  Snooping不变，并选择距组播源较近的Switch A来充当IGMP Snooping查询器。

为防止组播数据在二层网络中广播，在Switch B上开启IGMP snooping，使组播数据仅发送给指定接收者（Host A和Host B）。

图1 IGMP snooping配置组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774748_x_Img_x_png_0_1816256_30005_0.png)

 

## 1.3 配置步骤

#### 1. 配置Switch A

\# 开启设备的IGMP Snooping特性。

<SwitchA> system-view

[SwitchA] igmp-snooping

[SwitchA-igmp-snooping] quit

\# 创建VLAN 100，把端口GigabitEthernet1/0/1和GigabitEthernet1/0/2添加到该VLAN中；在该VLAN内使能IGMP Snooping。

[SwitchA] vlan 100

[SwitchA-vlan100] port gigabitethernet 1/0/1 to gigabitethernet 1/0/2

[SwitchA-vlan100] igmp-snooping enable

\# 在VLAN 100内开启IGMP Snooping查询器。

[SwitchA-vlan100] igmp-snooping querier

[SwitchA-vlan100] quit

\# 保存配置，防止配置丢失

[SwitchA] save

#### 2. 配置Switch B

\# 开启设备的IGMP Snooping特性。

<SwitchB> system-view

[SwitchB] igmp-snooping

[SwitchB-igmp-snooping] quit

\# 创建VLAN 100，把端口GigabitEthernet1/0/1到GigabitEthernet1/0/4添加到该VLAN中；在该VLAN内使能IGMP Snooping。

[SwitchB] vlan 100

[SwitchB-vlan100] port gigabitethernet 1/0/1 to gigabitethernet 1/0/4

[SwitchB-vlan100] igmp-snooping enable

[SwitchB-vlan100] quit

## 1.4 验证配置

\# 显示Switch B上IGMP Snooping组播组的信息。

<SwitchB> display igmp-snooping group 

Total 2 entries.

 

VLAN 100: Total 2 entries.

 (0.0.0.0, 224.1.1.1)

  Host ports (2 in total):

   GE1/0/2              (00:03:23)

   GE1/0/3              (00:03:23)

连接Host C的端口GE1/0/4不在IGMP snooping组播组信息中，组播数据将不会发送给Host C。

## 1.5 配置文件

#### 1. Switch A的配置

\#

igmp-snooping

\#

vlan 100

 igmp-snooping enable

 igmp-snooping querier

\#

interface GigabitEthernet1/0/1

 port access vlan 100

\#

interface GigabitEthernet1/0/2

 port access vlan 100

\#

#### 2. Switch B的配置

\#

igmp-snooping

\#

vlan 100

 igmp-snooping enable

\#

interface GigabitEthernet1/0/1

 port access vlan 100

\#

interface GigabitEthernet1/0/2

 port access vlan 100

\#

interface GigabitEthernet1/0/3

 port access vlan 100

\#

interface GigabitEthernet1/0/4

 port access vlan 100

\#