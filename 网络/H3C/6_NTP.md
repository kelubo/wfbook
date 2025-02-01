# NTP

[TOC]

## 组网需求

为了通过 NTP 实现 Device B 与 Device A 的时间同步，要求：

* 在 Device A 上设置本地时钟作为参考时钟，层数为 2；
* 配置 Device B 和 Device C 工作在客户端模式，指定 Device A 为 NTP 服务器。

 ![](../../Image/2/20230328_8774684_x_Img_x_png_0_1816240_30005_0.png)

 

## 配置思路

(1)   配置 A、B、C 设备的 IP 地址并开启 NTP 服务。

(2)   配置 A 设备的本地时钟作为参考时钟，层数为 2 。

(3)   配置 A 设备为 B、C 设备的 NTP 服务器。

## 配置步骤

### Device A的配置

配置接口 Vlan-interface2 的 IP 地址。

```
<DeviceA> system-view
[DeviceA] interface Vlan-interface 2
[DeviceA-Vlan-interface2] ip address 1.0.1.11 24
[DeviceA-Vlan-interface2] quit
```

开启 NTP 服务。

```
[DeviceA] ntp-service enable
```

设置本地时钟作为参考时钟，层数为 2 。

```
[DeviceA] ntp-service refclock-master 2
```

### Device B的配置

配置接口 Vlan-interface2 的 IP 地址。

```
<DeviceB> system-view
[DeviceB] interface Vlan-interface2
[DeviceB-Vlan-interface2] ip address 1.0.1.12 24
[DeviceB-Vlan-interface2] quit
```

开启 NTP 服务。

```
<DeviceB> system-view
[DeviceB] ntp-service enable
```

配置通过 NTP 协议获取时间。

```
[DeviceB] clock protocol ntp
```

设置 NTP Server 为 Device B 的 NTP 服务器。

```
[DeviceB] ntp-service unicast-server 1.0.1.11
```

### Device C的配置

配置接口 Vlan-interface2 的 IP 地址。

```
<DeviceC> system-view
[DeviceC] interface Vlan-interface2
[DeviceC-Vlan-interface2] ip address 1.0.1.13 24
[DeviceC-Vlan-interface2] quit
```

开启 NTP 服务。

```
<DeviceC> system-view
[DeviceC] ntp-service enable
```

配置通过 NTP 协议获取时间。

```
[DeviceC] clock protocol ntp
```

设置 NTP Server 为 Device C 的 NTP 服务器。

```
[DeviceC] ntp-service unicast-server 1.0.1.11
```

## 验证配置

完成上述配置后，Device B 和 Device C 向 Device A 进行时间同步。以 Device B 为例查看 NTP 状态。可以看出，Device B 已经与 Device A 同步，层数比 Device A 的层数大 1，为 3。

```
[DeviceB] display ntp-service status
 Clock status: synchronized
 Clock stratum: 3
 System peer: 1.0.1.11
 Local mode: client
 Reference clock ID: 1.0.1.11
 Leap indicator: 00
 Clock jitter: 0.000977 s
 Stability: 0.000 pps
 Clock precision: 2^-10
 Root delay: 0.00383 ms
 Root dispersion: 16.26572 ms
 Reference time: d0c6033f.b9923965 Wed, Dec 29 2019 18:58:07.724
 System poll interval: 64 s
```

查看 Device B 的 NTP 服务的所有 IPv4 会话信息，可以看到 Device B 与 Device A 建立了会话。

```
[DeviceB] display ntp-service sessions

source     reference    stra reach poll now offset delay disper
********************************************************************************
[12345]1.0.1.11    127.127.1.0    2  255 64  15  -4.0 0.0038 16.262
Notes: 1 source(master), 2 source(peer), 3 selected, 4 candidate, 5 configured.
 Total sessions: 1
```

## 配置文件

Device A：

```
#

 interface Vlan-interface2

 ip address 1.0.1.11 24

 quit

 ntp-service enable

 ntp-service refclock-master 2

#
```

Device B：

```
#

 interface Vlan-interface2

 ip address 1.0.1.12 24

 quit

 ntp-service enable

 clock protocol ntp

 ntp-service unicast-server 1.0.1.11

#
```

Device C：

```
#

interface Vlan-interface2

 ip address 1.0.1.13 24

#

 ntp-service enable

 clock protocol ntp

 ntp-service unicast-server 1.0.1.11

#
```

