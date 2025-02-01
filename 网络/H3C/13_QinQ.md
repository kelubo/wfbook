# 配置QinQ基本组网

## 1.1 简介

本案例介绍QinQ的配置方法。

## 1.2 组网需求

如[图1-1](https://www.h3c.com/cn/d_202303/1816247_30005_0.htm#_Ref81484619)所示，CE 1和CE 2是同一公司两个分支机构的接入交换机，PE A和PE  B是运营商网络的边缘设备，通过运营商网络进行通信，公司内业务使用的VLAN为VLAN 2，运营商网络中可用的VLAN资源为VLAN  200。通过配置QinQ功能，实现两个分支机构之间通过运营商网络进行通信。

图1-1 QinQ基本组网图

![img](https://resource.h3c.com/cn/202303/28/20230328_8774709_x_Img_x_png_0_1816247_30005_0.png)

 

## 1.3 配置注意事项

开启QinQ功能的端口，需要配置端口的缺省VLAN为QinQ封装的外层VLAN（SVLAN）。

## 1.4 配置步骤

### 1.4.1 CE 1的配置

\# 创建VLAN 2。

<CE 1> system-view

[CE 1] vlan 2

[CE 1-vlan2] quit

\# 配置端口GigabitEthernet 1/0/2和GigabitEthernet 1/0/3为Access端口，允许VLAN 2的报文通过。

[CE 1] interface range gigabitethernet 1/0/2 to gigabitethernet 1/0/3

[CE 1-if-range] port access vlan 2

[CE 1-if-range] quit

\# 配置端口GigabitEthernet 1/0/1为Trunk端口，允许VLAN 2的报文通过。

[CE 1] interface gigabitethernet 1/0/1

[CE 1-GigabitEthernet1/0/1] port link-type trunk

[CE 1-GigabitEthernet1/0/1] port trunk permit vlan 2

[CE 1-GigabitEthernet1/0/1] quit

### 1.4.2 CE 2的配置

CE 2的配置与CE 1相同，此处不做赘述。

### 1.4.3 PE A的配置

\# 创建VLAN 2和VLAN 200。

<PE A> system-view

[PE A] vlan 2

[PE A-vlan2] quit

[PE A] vlan 200

[PE A-vlan200] quit

\# 配置端口GigabitEthernet 1/0/1为Trunk端口，允许VLAN 2和VLAN 200的报文通过。

[PE A] interface gigabitethernet 1/0/1

[PE A-GigabitEthernet1/0/1] port link-type trunk

[PE A-GigabitEthernet1/0/1] port trunk permit vlan 2 200

\# 配置端口GigabitEthernet 1/0/1的PVID为VLAN 200。

[PE A-GigabitEthernet1/0/1] port trunk pvid vlan 200

\# 开启端口GigabitEthernet 1/0/1的QinQ功能。

[PE A-GigabitEthernet1/0/1] qinq enable

[PE A-GigabitEthernet1/0/1] quit

\# 配置端口GigabitEthernet 1/0/2为Trunk端口，允许VLAN 200的报文通过。

[PE A] interface gigabitethernet 1/0/2

[PE A-GigabitEthernet1/0/2] port link-type trunk

[PE A-GigabitEthernet1/0/2] port trunk permit vlan 200

[PE A-GigabitEthernet1/0/2] quit

### 1.4.4 PE B的配置

PE B的配置与PE A相同，此处不做赘述。

## 1.5 验证配置

同一公司中，分别属于两个分支机构的两台PC互相进行Ping操作，可以Ping通，且这两台PC能够互相学习到对方的MAC地址。可见业务VLAN信息能够跨越运营商网络进行透明传输。例如：

\# 在Site 1分支的PC执行Ping操作，检查Site 2分支的PC是否可达。

C:\Users\usera>ping 192.168.1.2

 

正在 Ping 192.168.1.2 具有 32 字节的数据:

来自 192.168.1.2 的回复: 字节=32 时间=28ms TTL=253

来自 192.168.1.2 的回复: 字节=32 时间=27ms TTL=253

来自 192.168.1.2 的回复: 字节=32 时间=27ms TTL=253

来自 192.168.1.2 的回复: 字节=32 时间=26ms TTL=253

 

192.168.1.2 的 Ping 统计信息:

  数据包: 已发送 = 4，已接收 = 4，丢失 = 0 (0% 丢失)，

往返行程的估计时间(以毫秒为单位):

最短 = 26ms，最长 = 28ms，平均 = 27ms

\# 在CE 1上查看MAC地址表，发现学习到了Site 2分支设备的MAC地址。

<Sysname> display mac-address vlan 2

MAC Address   VLAN ID  State      Port/Nickname      Aging

0003-2d00-5761  2     Learned     GE1/0/1          Y

## 1.6 配置文件

·   CE 1

\#

vlan 2

\#

interface GigabitEthernet1/0/1

 port link-type trunk

 port trunk permit vlan 1 to 2

\#

interface GigabitEthernet1/0/2

 port access vlan 2

\#

interface GigabitEthernet1/0/3

 port access vlan 2

·   CE 2

\#

vlan 2

\#

interface GigabitEthernet1/0/1

 port link-type trunk

 port trunk permit vlan 1 to 2

\#

interface GigabitEthernet1/0/2

 port access vlan 2

\#

interface GigabitEthernet1/0/3

 port access vlan 2

·   PE A

\#

vlan 2

\#

Vlan 200

\#

interface GigabitEthernet1/0/1

 port link-type trunk

 port trunk permit vlan 1 to 2 200

 port trunk pvid vlan 200

 qinq enable

\#

interface GigabitEthernet1/0/2

 port link-type trunk

 port trunk permit vlan 1 200

·   PE B

\#

vlan 2

\#

Vlan 200

\#

interface GigabitEthernet1/0/1

 port link-type trunk

 port trunk permit vlan 1 to 2 200

 port trunk pvid vlan 200

 qinq enable

\#

interface GigabitEthernet1/0/2

 port link-type trunk

 port trunk permit vlan 1 200

\#