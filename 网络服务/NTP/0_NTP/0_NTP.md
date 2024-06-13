# NTP

[TOC]

## 概述

NTP（Network Time Protocol ，网络时间协议）广泛用于将计算机同步到 Internet  时间服务器或其他来源，例如无线电或卫星接收器或电话调制解调器服务。可以提供高精准度的时间校正（LAN 上与标准时间差小于 1 毫秒，WAN 上几毫秒），且可介由加密确认的方式来防止恶意的协议攻击。

NTP 确保了全球、海底甚至太空中数十亿台设备的可靠性。精确的计时对于许多已经彻底改变并对我们的日常生活至关重要的应用至关重要：卫星、GPS、5G、金融服务、医疗保健等。

NTP 项目生成 NTP 标准的开源参考实现，维护实现文档，并开发用于在系统之间通信时间的协议和算法标准。

Network Time Foundation 为 NTP 项目提供支持。了解更多关于基金会在 https://www.nwtime.org/ 的工作。

典型的 NTP 配置利用多个冗余服务器和不同的网络路径来实现高精度和可靠性。

是在分组交换、延迟时间可变的数据网络上进行时钟同步的网络协议。

由特拉华大学 (University of Delaware) 的 David L. Mills 设计。自 1985 年以来，NTP 是目前仍在使用的最古老的互联网协议之一。

NTP 只考虑 UTC 时间，不考虑时区，不考虑夏令时等。

* **协    议：** UDP
* **端口号：** 123

此发行版是 [RFC-5905“网络时间协议版本 4：协议和算法规范”](https://www.ntp.org/reflib/rfc/rfc5905.txt) 的实现。

n framework in which substantially all the runtime NTP operations and most features can be tested and  evaluated. This has been very useful in exploring in vitro response to  unusual circumstances or over time periods impractical in vivo. Details  are on the [Network Time Protocol (NTP) Simulator](https://www.ntp.org/documentation/4.2.8-series/ntpdsim/) page.
该发行版包括一个仿真框架，在该框架中，可以测试和评估几乎所有运行时 NTP 操作和大多数功能。这对于探索体外对异常情况或体内不切实际的反应非常有用。有关详细信息，请参阅网络时间协议 （NTP） 模拟器页面。

## 工作原理

 ![](..\..\Image\n\NTP.jpg)

NTP Query   3

NTP Reply    4

### 时间延迟计算

 ![](..\..\Image\n\ntpgongshi0)

时间偏移 `θ` 定义为：

 ![](..\..\Image\n\ntpgongshi1)

往返延迟 `δ` 为：

 ![](..\..\Image\n\ntpgongshi2)

其中：

* `t0`  请求数据包传输的客户端时间戳，
* `t1`  请求数据包回复的服务器时间戳，
* `t2`  响应数据包传输的服务器时间戳，
* `t3`  响应数据包回复的客户端时间戳。

`t1` , `t2` 是属于同一个时钟的，因此它们的差值是有意义的，同理，`t3` , `t0` 的差值也是有意义的。

`t3 - t0` 是数据包传输的全部时间，服务器处理的时间是 `t2 - t1`, 那么**往返**网络传输时间就是 `δ=(t3 - t0) - (t2 - t1)`。

现在假设网络延迟是对称的，那么**单程**网络延时就是 `δ/2`,也就是 `[(t3 - t0) - (t2 - t1)]/2`。

现在假设这个差值为 `θ` ，考虑从 `t2 => t3` 的过程，从服务器 `t2` 时刻开始，经过网络延时(`δ/2`,单程延时)到达 `t3` ,但是 `t3` 是客户端的时间，`t3 + θ` 对应的就是服务器的时间，那么它们应该是相等的。

`t2 + δ/2 = t3 + θ`，计算`θ`,得到

 ![](../../Image/n/ntpgongshi3)

例如上面图中的 `θ=(135 - 231 + 137 - 298)/2`=`-(257/2)`,客户端比服务器快，时间是负值。

客户端会同时请求好几个服务器，进行统计分析，过滤不合理的值，并从最好的三个剩余候选中导出估算的时间偏移，然后调整时钟频率以逐渐减小偏移。

## 层次 stratum

使用一种树状的，半分层的时间源系统。每一层叫做 `stratum`。每个 stratum 都有一个编号，`0 - 15`，`16` 被用来标记设备未同步。一般情况下，第 `n+1` 层 stratum 从第 `n` 层同步时间。

- stratum 0:

  一般用硬件实现，例如原子钟（如铯、铷）、GPS 时钟或其他无线电时钟。也被称为**参考（基准）时钟(reference clocks)**。

- stratum 1:
   这一层是计算机，它们的系统时间和连接其上的 stratum 0 设备保持同步，误差在几个微秒。
   本层计算机可能与其他同层的计算机对等相连，以进行完整性检查和备份。它们也被称为**主要（primary）时间服务器**。这一层对互联网是不可见的，虽然它们是部署在互联网上的。
- stratum 2:
   从 stratum1 机器同步时间。stratum2 的计算机将查询 stratum 1 服务器。stratum 2 计算机也可能与其他 stratum 2 计算机对等相连，为对等组中的所有设备提供更稳定的时间。
- stratum 3:
   这些计算机与 stratum 2 的服务器同步。使用与 stratum 2 相同的算法进行对等和数据采样，并可以自己作为服务器担任阶 stratum 4 计算机，以此类推。

 ![](..\..\Image\n\ntpstratum)

对于提供 `network time service provider` 的主机来说，stratum 的设定要尽可能准确。而作为局域网的 `time service provider`，通常将 stratum 设置为 `10` 。ntpd 对下层 client 来说是 service server ，对于上层 server 来说是 client 。

## 同步时间间隔

与软件有关。Linux 下 ntpd 在不稳定的时候为 64 秒，随着稳定程度的提高，会逐渐变成 128 秒、256 秒......成倍增长，最长时间可达 1024 秒。

## 客户端运行模式

1. step 模式

   校准工作一气呵成。ntpd 默认在客户端与服务端时间相差大于 128 毫秒时采用该运行模式。

2. slew 模式

   校准是慢条斯理的完成。ntpd 默认在客户端与服务端时间相差小于 128 毫秒时采用该运行模式。
## 服务器工作模式

1. 广播/多播方式

   适用于局域网，服务器周期性地以广播/多播的方式将时间信息传送给其他网络中的服务器。配置简单，精度不高。

2. 对称方式

   适用于配置冗余的 NTP 服务器。该服务器可以提供时间给其他服务器，也可以从其他服务器获取时间。

3. 客户端/服务器方式

   与对称方式相似，不提供给其他服务器时间信息，适用于一台服务器接收上层服务器时间信息，并提供时间信息给下层的用户。

## 实现

* ntpd
* chrony
* open-ntp
* Ntimed

## 国内常用NTP服务器地址及IP

```bash
                             210.72.145.44      国家授时中心服务器
                             133.100.11.8       日本 福冈大学  
time-a.nist.gov              129.6.15.28        NIST, Gaithersburg, Maryland   
time-b.nist.gov              129.6.15.29        NIST, Gaithersburg, Maryland   
time-a.timefreq.bldrdoc.gov  132.163.4.101      NIST, Boulder, Colorado   
time-b.timefreq.bldrdoc.gov  132.163.4.102      NIST, Boulder, Colorado   
time-c.timefreq.bldrdoc.gov  132.163.4.103      NIST, Boulder, Colorado   
utcnist.colorado.edu         128.138.140.44     University of Colorado, Boulder   
time.nist.gov                192.43.244.18      NCAR, Boulder, Colorado   
time-nw.nist.gov             131.107.1.10       Microsoft, Redmond, Washington   
nist1.symmetricom.com        69.25.96.13        Symmetricom, San Jose, California   
nist1-dc.glassey.com         216.200.93.8       Abovenet, Virginia   
nist1-ny.glassey.com         208.184.49.9       Abovenet, New York City   
nist1-sj.glassey.com         207.126.98.204     Abovenet, San Jose, California   
nist1.aol-ca.truetime.com    207.200.81.113     TrueTime, AOL facility, Sunnyvale, California   
nist1.aol-va.truetime.com    64.236.96.53       TrueTime, AOL facility, Virginia  
————————————————————————————————————  
ntp.sjtu.edu.cn              202.120.2.101      上海交通大学网络中心NTP服务器地址
s1a.time.edu.cn					    			北京邮电大学  
s1b.time.edu.cn 								清华大学  
s1c.time.edu.cn 								北京大学  
s1d.time.edu.cn									东南大学  
s1e.time.edu.cn 								清华大学  
s2a.time.edu.cn 								清华大学  
s2b.time.edu.cn 								清华大学  
s2c.time.edu.cn 								北京邮电大学  
s2d.time.edu.cn 								西南地区网络中心  
s2e.time.edu.cn 								西北地区网络中心  
s2f.time.edu.cn 								东北地区网络中心  
s2g.time.edu.cn 								华东南地区网络中心  
s2h.time.edu.cn 								四川大学网络管理中心  
s2j.time.edu.cn 								大连理工大学网络中心  
s2k.time.edu.cn 								CERNET桂林主节点  
s2m.time.edu.cn 								北京大学
```
