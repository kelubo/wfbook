# IP Source Guard静态绑定快速配置指南

## 1.1 简介

本案例介绍静态配置绑定表项方式的IP Source Guard的配置方法。

## 1.2 使用限制

加入聚合组或加入业务环回组的端口上不能配置IP Source Guard功能。

## 1.3 组网需求

如图所示，Host A与Host  B分别与Switch B的端口GigabitEthernet1/0/2、GigabitEthernet1/0/1相连；Host C与Switch A的端口GigabitEthernet1/0/2相连。Switch B接到Switch  A的端口GigabitEthernet1/0/1上。各主机均使用静态配置的IP地址。

通过在Switch A和Switch B上配置IPv4静态绑定表项，满足以下各项应用需求：

·   Switch A的端口GigabitEthernet1/0/2上只允许Host C发送的IP报文通过。

·   Switch A的端口GigabitEthernet1/0/1上只允许Host A发送的IP报文通过。

·   Switch B的端口GigabitEthernet1/0/2上只允许Host A发送的IP报文通过。

·   Switch B的端口GigabitEthernet1/0/1上只允许使用IP地址192.168.0.2/24的主机发送的IP报文通过，即允许Host B更换网卡后仍然可以使用该IP地址与Host A互通。

图1 配置IP Source Guard静态绑定组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774757_x_Img_x_png_0_1816259_30005_0.png)

 

## 1.4 配置步骤

#### 1. Switch A的配置

\# 在端口GigabitEthernet1/0/2上配置IPv4动态绑定功能，绑定源IP地址和MAC地址。

<SwitchA> system-view

[SwitchA] interface gigabitethernet 1/0/2

[SwitchA-GigabitEthernet1/0/2] ip verify source ip-address mac-address

\# 配置IPv4静态绑定表项，只允许MAC地址为0001-0203-0405、IP地址为192.168.0.3的Host C发送的IP报文通过端口GigabitEthernet1/0/2。

[SwitchA-GigabitEthernet1/0/2] ip source binding ip-address 192.168.0.3 mac-address 0001-0203-0405

[SwitchA-GigabitEthernet1/0/2] quit

\# 在端口GigabitEthernet1/0/1上配置IPv4端口绑定功能，绑定源IP地址和MAC地址。

[SwitchA] interface gigabitethernet 1/0/1

[SwitchA-GigabitEthernet1/0/1] ip verify source ip-address mac-address

\# 配置IPv4静态绑定表项，只允许MAC地址为0001-0203-0406、IP地址为192.168.0.1的Host A发送的IP报文通过端口GigabitEthernet1/0/1。

[SwitchA-GigabitEthernet1/0/1] ip source binding ip-address 192.168.0.1 mac-address 0001-0203-0406

[SwitchA-GigabitEthernet1/0/1] quit

\# 保存配置

[SwitchA] save

#### 2. 配置Switch B的配置

\# 在端口GigabitEthernet1/0/2上配置IPv4动态绑定功能，绑定源IP地址和MAC地址。

<SwitchB> system-view

[SwitchB] interface gigabitethernet 1/0/2

[SwitchB-GigabitEthernet1/0/2] ip verify source ip-address mac-address

\# 配置IPv4静态绑定表项，只允许MAC地址为0001-0203-0406、IP地址为192.168.0.1的Host A发送的IP报文通过端口GigabitEthernet1/0/2。

[SwitchB-GigabitEthernet1/0/2] ip source binding ip-address 192.168.0.1 mac-address 0001-0203-0406

[SwitchB-GigabitEthernet1/0/2] quit

\# 在端口GigabitEthernet1/0/1上配置IPv4端口绑定功能，绑定源IP地址。

[SwitchB] interface gigabitethernet 1/0/1

[SwitchB-GigabitEthernet1/0/1] ip verify source ip-address

\# 配置IPv4静态绑定表项，只允许IP地址为192.168.0.2的主机发送的IP报文通过端口GigabitEthernet1/0/1。

[SwitchB-GigabitEthernet1/0/1] ip source binding ip-address 192.168.0.2

[SwitchB-GigabitEthernet1/0/1] quit

\# 保存配置

[SwitchB] save

## 1.5 验证配置

\# 在Switch A上显示IPv4静态绑定表项配置成功。

[SwitchA] display ip source binding static

Total entries found: 2

IP Address   MAC Address  Interface        VLAN Type

192.168.0.1   0001-0203-0406 GE1/0/1         N/A Static

192.168.0.3   0001-0203-0405 GE1/0/2         N/A Static

\# 在Switch B上显示IPv4静态绑定表项配置成功。

[SwitchB] display ip source binding static

Total entries found: 2

IP Address   MAC Address  Interface        VLAN Type

192.168.0.1   0001-0203-0406 GE1/0/2         N/A Static

192.168.0.2   N/A      GE1/0/1         N/A Static

## 1.6 配置文件

·   SwitchA

\#

interface GigabitEthernet1/0/1

 port link-mode bridge

 ip verify source ip-address mac-address

 ip source binding ip-address 192.168.0.1 mac-address 0001-0203-0406

\#

interface GigabitEthernet1/0/2

 port link-mode bridge

 ip verify source ip-address mac-address

 ip source binding ip-address 192.168.0.3 mac-address 0001-0203-0405

\#

·   SwitchB

\#

interface GigabitEthernet1/0/1

 port link-mode bridge

 ip verify source ip-address

 ip source binding ip-address 192.168.0.2

\#

interface GigabitEthernet1/0/2

 port link-mode bridge

 ip verify source ip-address mac-address

 ip source binding ip-address 192.168.0.1 mac-address 0001-0203-0406

\#