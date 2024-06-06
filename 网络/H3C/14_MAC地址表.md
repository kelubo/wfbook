#  配置静态MAC地址表项

## 1.1 简介

本案例介绍静态MAC地址表项的配置方法。

## 1.2 组网需求

某个企业网络如[图1](https://www.h3c.com/cn/d_202303/1816248_30005_0.htm#_Ref81485817)所示，企业网络内的用户通过Switch A与服务器或外部网络进行通信。该网络的组网需求如下：

·   VLAN 100的用户群需要访问服务器。

·   如果有非法用户从其他接口假冒服务器的MAC地址发送报文，则服务器的MAC地址将在其他接口学到，导致用户不能与服务器正常通信，还会导致一些重要用户信息被窃取。为提高服务器安全性，在Switch A上配置一条静态MAC地址表项，将服务器MAC地址0033-0033-0033与接口GE1/0/2绑定。

图1 静态MAC地址表项组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774711_x_Img_x_png_0_1816248_30005_0.png)

 

## 1.3 配置步骤

对Switch A进行配置：

\# 创建VLAN 100。

<Switch A> system-view

[Switch A] vlan 100

[Switch A-vlan100] quit

\# 将GigabitEthernet1/0/2加入VLAN 100。

[Switch A] interface gigabitethernet 1/0/2

[Switch A-GigabitEthernet1/0/2] port access vlan 100

[Switch A-GigabitEthernet1/0/2] quit

\# 将Switch A连接下级交换机的端口GigabitEthernet1/0/3的链路类型配置为Trunk，并允许VLAN 100的报文通过。

[Switch A] interface gigabitethernet 1/0/3

[Switch A-GigabitEthernet1/0/3] port link-type trunk

[Switch A-GigabitEthernet1/0/3] port trunk permit vlan 100

[Switch A-GigabitEthernet1/0/3] quit

\# 增加一个静态MAC地址表项，目的地址为0033-0033-0033，出接口为GigabitEthernet1/0/2，且该接口属于VLAN 100。

[Switch A] mac-address static 0033-0033-0033 interface gigabitethernet 1/0/2 vlan 100

## 1.4 验证配置

(1)   假设VLAN 100的某个用户处于10.0.0.0/24网段，该用户能够和Server互通。

\# VLAN 100的某个用户执行Ping操作，检查10.0.0.9是否可达。

<Switch A> ping 10.0.0.9

Ping 10.0.0.9 (10.0.0.9): 56 data bytes, press CTRL+C to break

56 bytes from 10.0.0.9: icmp_seq=0 ttl=254 time=2.137 ms

56 bytes from 10.0.0.9: icmp_seq=1 ttl=254 time=2.051 ms

56 bytes from 10.0.0.9: icmp_seq=2 ttl=254 time=1.996 ms

56 bytes from 10.0.0.9: icmp_seq=3 ttl=254 time=1.963 ms

56 bytes from 10.0.0.9: icmp_seq=4 ttl=254 time=1.991 ms

 

--- Ping statistics for 10.0.0.9 ---

5 packet(s) transmitted, 5 packet(s) received, 0.0% packet loss

round-trip min/avg/max/std-dev = 1.963/2.028/2.137/0.062 ms

(2)   查看Switch A的MAC地址表项信息，验证配置是否成功。

[Switch A] display mac-address

MAC Address   VLAN ID  State      Port/NickName      Aging

0033-0033-0033  100    Static      GE1/0/2         N

## 1.5 配置文件

\#

vlan 100

\#

interface GigabitEthernet1/0/2

 port access vlan 100

 mac-address static 0033-0033-0033 vlan 100

\#

interface GigabitEthernet1/0/3

 port link-type trunk

 port trunk permit vlan 1 100

\#

## 1.6 相关资料

·   产品配套“二层技术-以太网交换配置指导”中的“MAC地址表”。

·   产品配套“二层技术-以太网交换命令参考”中的“MAC地址表”。



 

# 2 配置VLAN的MAC地址数学习上限

## 2.1 简介

本案例介绍VLAN的MAC地址数学习上限的配置方法。

## 2.2 组网需求

如[图2](https://www.h3c.com/cn/d_202303/1816248_30005_0.htm#_Ref126846259)所示，用户网络1和用户网络2均使用VLAN 100，通过Switch A与外部网络进行通信。如果MAC地址表过于庞大，可能导致Switch A的转发性能下降。为保证Switch A的转发性能，在Switch A上配置VLAN 100的MAC地址数学习上限为1024。

图2 VLAN的MAC地址数学习上限组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774712_x_Img_x_png_1_1816248_30005_0.png)

 

## 2.3 配置步骤

对Switch A进行配置：

\# 创建VLAN 100。

<Switch A> system-view

[Switch A] vlan 100

[Switch A-vlan100] quit

\# 将GigabitEthernet1/0/1的链路类型配置为Trunk，并允许VLAN 100的报文通过。

[Switch A] interface gigabitethernet 1/0/1

[Switch A-GigabitEthernet1/0/1] port link-type trunk

[Switch A-GigabitEthernet1/0/1] port trunk permit vlan 100

[Switch A-GigabitEthernet1/0/1] quit

\# 将GigabitEthernet1/0/2的链路类型配置为Trunk，并允许VLAN 100的报文通过。

[Switch A] interface gigabitethernet 1/0/2

[Switch A-GigabitEthernet1/0/2] port link-type trunk

[Switch A-GigabitEthernet1/0/2] port trunk permit vlan 100

[Switch A-GigabitEthernet1/0/2] quit

\# 配置VLAN 100的MAC地址数学习上限为1024。

[Switch A] vlan 100

[Switch A-vlan100] mac-address max-mac-count 1024

[Switch A-vlan100] quit

## 2.4 验证配置

\# 在VLAN 100视图下执行**display this**命令查看配置是否生效。

[Switch A] vlan 100

[Switch A-vlan100] display this

\#

mac-address max-mac-count 1024

\#

Return

## 2.5 配置文件

\#

vlan 100

 mac-address max-mac-count 1024

\#

interface GigabitEthernet1/0/1

 port link-mode bridge

 port link-type trunk

 port trunk permit vlan 1 100

\#

interface GigabitEthernet1/0/2

 port link-mode bridge

 port link-type trunk

 port trunk permit vlan 1 100

\#

## 2.6 相关资料

·   产品配套“二层技术-以太网交换配置指导”中的“MAC地址表”。

·   产品配套“二层技术-以太网交换命令参考”中的“MAC地址表”。



 

# 3 配置接口的MAC地址数学习上限

## 3.1 简介

本案例介绍端口的MAC地址数学习上限的配置方法。

## 3.2 组网需求

如[图3](https://www.h3c.com/cn/d_202303/1816248_30005_0.htm#_Ref126846267)所示，Switch A是运营商网络的边缘设备，LAN Switch 3是公司的接入交换机，LAN Switch 1和LAN Switch  2是该公司内两个部门的接入交换机（部门网络 1使用VLAN 100，部门网络 2使用VLAN 200）。公司网络通过LAN Switch  3与Switch A相连访问外部网络。如果MAC地址表过于庞大，可能导致Switch A的转发性能下降。为保证Switch A的转发性能，在Switch A上配置端口GE1/0/1的MAC地址数学习上限为2048。

图3 接口的MAC地址数学习上限组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774713_x_Img_x_png_2_1816248_30005_0.png)

 

## 3.3 配置步骤

对Switch A进行配置：

\# 创建VLAN 100、200。

<Switch A> system-view

[Switch A] vlan 100 200

\# 将GigabitEthernet1/0/1的链路类型配置为Trunk，并允许VLAN 100、200的报文通过。

[Switch A] interface gigabitethernet 1/0/1

[Switch A-GigabitEthernet1/0/1] port link-type trunk

[Switch A-GigabitEthernet1/0/1] port trunk permit vlan 100 200

[Switch A-GigabitEthernet1/0/1] quit

\# 配置VLAN 100的MAC地址数学习上限为1024。

[Switch A] interface gigabitethernet 1/0/1

[Switch A-GigabitEthernet1/0/1]mac-address max-mac-count 1024

[Switch A-GigabitEthernet1/0/1] quit

## 3.4 验证配置

\# 在VLAN 100视图下执行**display this**命令查看配置是否生效。

[Switch A] interface gigabitethernet 1/0/1

[Switch A-GigabitEthernet1/0/1] display this

\#

interface GigabitEthernet1/0/1

 port link-mode bridge

 port link-type trunk

 port trunk permit vlan 1 100 200

 mac-address max-mac-count 1024

\#

return

## 3.5 配置文件

\#

vlan 100

\#

vlan 200

\#

interface GigabitEthernet1/0/1

 port link-mode bridge

 port link-type trunk

 port trunk permit vlan 1 100 200

 mac-address max-mac-count 1024

\#