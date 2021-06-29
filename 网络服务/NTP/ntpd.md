# ntpd

[TOC]

## 安装

```bash
# CentOS
yum install ntp

systemctl stop ntpd.service
systemctl start ntpd.service

systemctl enable ntpd.service
systemctl disable ntpd.service
```

## Server

### 配置文件 /etc/ntp.conf

```bash
# For more information about this file, see the man pages
# ntp.conf(5), ntp_acc(5), ntp_auth(5), ntp_clock(5), ntp_misc(5), ntp_mon(5).
 
driftfile /var/lib/ntp/drift
# ??记录系统时间与 BIOS 时间偏差的文件。??和上层NTP服务器的频率误差记录文件。??需要确认。两个资料说明不同

# Permit time synchronization with our time source, but do not
# permit the source to query or modify the service on this system.
# 禁止其他计算机修改或查询本机的 NTP 服务
#restrict default nomodify notrap nopeer noquery
restrict -4 default kod notrap nomodify nopeer noquery
restrict -6 default kod notrap nomodify nopeer noquery 
# Permit all access over the loopback interface.  This could
# be tightened as well, but to do so would effect some of
# the administrative functions.
# 允许本地回环地址访问 NTP 服务器
restrict 127.0.0.1
restrict -6 ::1
# Hosts on local network are less restricted.
# 设置允许访问 NTP 服务器的网络
#restrict 192.168.1.0 mask 255.255.255.0 nomodify notrap
######################################################################################
# restrict -- 控制相关权限
# 格式：
# restrict [目标IP地址|主机名] mask [子网掩码] [参数]
# IP 地址也可以是 default ，default 就是指所有的 IP
# 如不指定参数，表示不受限制。
# ignore：     关闭所有的 NTP 联机服务，拒绝所有数据包，包括使用 ntpq 和 ntpdc 查询
# kod：        访问违规时发送 KoD 包。阻止 Kiss of Death 包(KOD是一种DOS攻击方法)对服务器的破坏。
# nomodify：   客户端不能更改服务端的时间参数，但是客户端可以通过服务端进行网络校时。
# noquery：    不提供客户端的时间查询：用户端不能使用 ntpq，ntpc 等命令来查询 ntp 服务器
# notrust：    客户端除非通过认证，否则该客户端来源将被视为不信任子网
# notrap：     不提供 trap 远程事件登陆：拒绝为匹配的主机提供模式 6 控制消息陷阱服务。
#              陷阱服务是 ntpdq 控制消息协议的子系统，用于远程事件日志记录程序。
# nopeer：     用于阻止主机尝试与服务器对等，并允许欺诈性服务器控制时钟
# noserve：    拒绝除 ntpq 和 ntpdc 查询的所有包
# ntpport：    对源端口为标准NTP端口的数据包进行响应
# limited：    拒绝访问，如果数据包超过了diacard设置的速率。对 ntpq 和 ntpdc 不起作用。
# lowpriotrap：降低匹配主机的traps优先级。一个服务器所能维护的traps数量是有限的。当前数量是3。
#              traps通常按照“先来先服务，后来被拒绝”的法则处理。该项修改了规则，允许后来的
#              （正常优先级）请求优先于低优先级的traps被处理。
# version：    拒绝不匹配当前NTP版本的包。
# rithm：      通过允许低优先级traps拒绝普通优先级traps后来的请求。
# restrict -6 表示 IPV6 地址的权限设置。
######################################################################################
 
# Use public servers from the pool.ntp.org project.
# Please consider joining the pool (http://www.pool.ntp.org/join.html).
# server：指定 ntp 服务器
# 格式：
# server host [key n] [version n] [prefer] [mode n] [minpoll n] [maxpoll n] [iburst]
# key： 表示所有发往服务器的报文包含有秘钥加密的认证信息，n是32位的整数，表示秘钥号。
# version：表示发往上层服务器的报文使用的版本号，n默认是3，可以是1或者2。
# prefer： 优先使用该时间服务器
# mode：   指定数据报文mode字段的值。
# burst：  当一个远程NTP服务器可用时，向它发送一系列的并发包进行检测。一般不允许使用。这个选项不仅在轮询间隔发送大量包（明显又是八个），而且也会在服务器能正常使用时这样做。如果在高层服务器持续发送包，甚至是它们在正常应答时，可能会因为使用 “burst” 选项而被拉黑。显然，连接服务器的频率造成了它的负载差异（和少量的带宽占用）。
# iburst： 如果在一个标准的轮询间隔内没有应答，客户端会发送一定数量的包（采用突发方式接连发送8个报文，时间间隔为2秒）给 NTP 服务器。如果在短时间内呼叫 NTP 服务器几次，没有出现可辨识的应答，那么本地时间将不会变化。
# 参数minpoll和maxpoll指定NTP消息的最小和最大轮询间隔（以秒为单位）。
# 默认minpoll 6 maxpoll 10，表示的时间间隔分别为2的6次（64秒）方和2的10次方（1024秒）  
# minpoll最小可设置为3（2的3次方=8s），maxpoll最大可设置为17（2的17次方=36.4h）
# 根据连接 NTP 服务器的规则，不应该分别修改其默认的 64 秒和 1024 秒。
server 202.120.2.101 prefer iburst minpoll 1 maxpoll 8
server 0.pool.ntp.org
server 1.pool.ntp.org
server 2.pool.ntp.org
server 3.pool.ntp.org

#slewalways yes

# 设置NTP广播方式
#broadcast 192.168.1.255 autokey        # broadcast server
#broadcastclient                        # broadcast client
#broadcast 224.0.1.1 autokey            # multicast server
#multicastclient 224.0.1.1              # multicast client
#manycastserver 239.255.254.254         # manycast server
#manycastclient 239.255.254.254 autokey # manycast client

# 在没有上层 NTP 服务器的情况下，使用本地时钟作为 NTP 时间源提供时间同步服务。
#server 127.127.1.0
#fudge  127.127.1.0 stratum 10

# Enable public key cryptography.
#crypto

# Key file containing the keys and key identifiers used when operating
# with symmetric key cryptography. 
# 使用对称加密时，密钥文件包含所用的密钥和密钥标识符。
keys /etc/ntp/keys
 
# Specify the key identifiers which are trusted.
# 指定哪些是可信任的密钥标识符。
#trustedkey 4 8 42
 
# Specify the key identifier to use with the ntpdc utility.
#requestkey 8
 
# Specify the key identifier to use with the ntpq utility.
#controlkey 8

# tinker [ allan allan | dispersion dispersion | freq freq | huffpuff huffpuff | panic panic | step step | stepout stepout ]
tinker dispersion 100
tinker step 1800
tinker stepout 3600
includefile /etc/ntp/crypto/pw

filegen loopstats file loopstats type day enable
filegen peerstats file peerstats type day enable
filegen clockstats file clockstats type day enable
 
# Enable writing of statistics records.
# 启用统计记录的写入。
#statistics clockstats cryptostats loopstats peerstats
 
# Disable the monitoring facility to prevent amplification attacks using ntpdc
# monlist command when default restrict does not include the noquery flag. See
# CVE-2013-5211 for more details.
# Note: Monitoring will not be disabled with the limited restriction flag.
disable monitor

# log
logfile /var/log/ntp
# log 级别,可选 info、event 或 all
logconfig all
```

### 配置文件 /etc/ntp/stpe-tickers

当ntpd服务启动时，会自动与该文件中记录的上层NTP服务进行时间校对。

```bash
less /etc/ntp/step-tickers 

# List of servers used for initial synchronization.
server 192.168.7.49 prefer
server 0.rhel.pool.ntp.org
server 1.rhel.pool.ntp.org 
server 2.rhel.pool.ntp.org 
server 3.rhel.pool.ntp.org 
```

**ntp.conf 和 step-tickers区别：** 

step-tickers is used by ntpdate  where as ntp.conf is the configuration file for the ntpd daemon. ntpdate is initially run to set the clock before ntpd to make sure time is  within 1000 sec. ntp will not run if the time difference between the  server and client by more then 1000 sec ( or there about). The start up  script will read step-tickers for servers to be polled by ntpdate. 

### 配置文件 /etc/sysconfig/ntpd 

ntp服务，默认只会同步系统时间。同步硬件时间，在/etc/sysconfig/ntpd文件中，添加 SYNC_HWCLOCK=yes 这样，就可以让硬件时间与系统时间一起同步。 

```bash
#允许BIOS与系统时间同步，也可以通过 hwclock -w 命令。
SYNC_HWCLOCK=yes 
```

**官方参数解析：**

- 基本参数：http://doc.ntp.org/4.2.6/confopt.html
- 复杂参数：http://doc.ntp.org/4.2.6/miscopt.html 

## Client
### timedatectl

timedatectl 替代 ntpdate。默认情况下，timedatectl 在系统启动的时候会立刻同步时间，并在稍后网络连接激活后通过 socket 再次检查一次。

如果已安装了 ntpdate / ntp，timedatectl 会退而使用之前的设置。这样确保了两个时间同步服务不会相互冲突，同时在升级的时候还保留原本的行为和配置。但这也意味着从旧版本的发行版升级时 ntp/ntpdate 仍会安装，因此会导致新的基于 systemd 的时间服务被禁用。

### timesyncd

在最新的 Ubuntu 版本中，timesyncd 替代了 ntpd 的客户端的部分。默认情况下 timesyncd 会定期检测并同步时间。它还会在本地存储更新的时间，以便在系统重启时做时间单步调整。

通过 timedatectl 和 timesyncd 设置的当前时间状态和时间配置，可以使用 timedatectl status 命令来进行确认。

```bash
timedatectl status
      Local time: Fri 2016-04-29 06:32:57 UTC
  Universal time: Fri 2016-04-29 06:32:57 UTC
        RTC time: Fri 2016-04-29 07:44:02
       Time zone: Etc/UTC (UTC, +0000)
 Network time on: yes
NTP synchronized: no
 RTC in local TZ: no
```

如果安装了 NTP，并用它替代 timedatectl 来同步时间，则 NTP synchronized 将被设置为 yes。

timedatectl 和 timesyncd 用来获取时间的 nameserver 可以通过 /etc/systemd/timesyncd.conf 来指定，另外在 /etc/systemd/timesyncd.conf.d/ 下还有灵活的附加配置文件。

### ntpdate

设置本地日期和时间。它从指定的每个服务器获得了一些样本，并应用标准 NTP 时钟过滤器和选择算法来选择最好的样本。

```bash
# CentOS
yum install ntpdate
```

 

```bash
ntpdate [选项] [NTP服务器]

-e <延迟时间>	指定延迟认证处理的时间秒数。常规值范围是0.0001到0.003
-t <超时时间>	指定等待服务器响应的超时值
-v             显示详细内容
-q             只查询，不设置时钟
-d             启用调试模式，其中的ntpdate将经历所有步骤，但不调整本地时钟
-k <密钥文件>	指定认证密钥文件作为字符串的密钥文件的路径。默认是/etc/ntp/keys
-u			   指定ntpdate使用传出数据包的无特权的端口
```

### ntpq

查询ntpd工作状态的命令

```bash
ntpq -p
     remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================
 202.120.2.101.d .XFAC.          16 u    -   64    0    0.000    0.000   0.000
 61-216-153-104. 118.163.81.63    3 u  30d 1024    0   78.465   34.438   0.000
 85.199.214.100  .GPS.            1 u    7   64  377  166.829    0.220   0.123
 210.72.145.44   .INIT.          16 u    -   64    0    0.000    0.000   0.000
+ntp1.ams1.nl.le 130.133.1.10     2 u   39   64   17  164.059    4.156  28.802
*sircabirus.von- 36.224.68.195    2 u   42   64   17  200.129   -2.154   5.885
-ntp2.flashdance 194.58.202.148   2 u   40   64   15  326.854   -2.366  29.832

# st 指的就是 stratum
# remote：即NTP主机的IP或主机名称。最左边的符号，“+”代表目前正在使用中的上层NTP，“*”表示也有连上线，不过是作为次要联机的NTP主机。??有异常??
# t：本地NTP服务器与远程NTP服务器的通信方式，u: 单播； b: 广播； l: 本地。
# refid：参考的上一层NTP主机的地址
# st：即stratum阶层，值越小表示ntp serve的精准度越高；
# when：几秒前曾做过时间同步更新的操作；
# Poll表示，每隔多少毫秒与ntp server同步一次；
# reach：已经向上层NTP服务器要求更新的次数；是一个八进制数字，指出源的可存取性。
# delay：网络传输过程钟延迟的时间；
# offset：时间补偿的结果；是源时钟与本地时钟的时间差（毫秒）
# jitter：??本地与remote同步的时间源的平均偏差（多个时间样本中的 offset的偏差，单位是毫秒），这个数值的绝对值越小，主机的时间就越精确 ??系统时间与bios时间差 ??异常

# NTP服务端重启后，客户机要等5分钟再与其进行时间同步，否则会提示“no server suitable for synchronization found”错误。等待的时间可以通过命令 watch ntpq -p 来监控。 
```

### ntpstat

```bash
ntpstat
synchronised to NTP server (85.199.214.101) at stratum 2
   time correct to within 91 ms
   polling server every 1024 s
```

### ntptime

这个使用特殊程序描述一个内核模型精确计时显示，他调用ntp_gettime()读取和显示时间相关的内核变量。类似的显示可以使用ntpdc程序的kerninfo命令。

```bash
ntptime

ntp_gettime() returns code 0 (OK)
  time de5061d9.7034f000  Mon, Mar 12 2018 10:18:01.438, (.438308),
  maximum error 116705 us, estimated error 7753 us, TAI offset 0
ntp_adjtime() returns code 0 (OK)
  modes 0x0 (),
  offset 0.000 us, frequency -13.286 ppm, interval 1 s,
  maximum error 116705 us, estimated error 7753 us,
  status 0x0 (),
  time constant 4, precision 1.000 us, tolerance 500 ppm,
```

**需要关注的数据：**

- maximum error：最大误差
- offset：系统时间偏移量

### 同步硬件时钟

1. 通过 `hwclock -w `命令。
2. 修改/etc/sysconfig/ntpd（见上文 server 配置文件相关内容。）

### ntpd和ntpdate的区别

ntpd不仅仅是时间同步服务器，它还可以做客户端与标准时间服务器进行同步时间。在实际同步时间时，是一点点的校准过来时间的，最终把时间慢慢的校正对（平滑同步）。ntpdate会立即同步，不会考虑其他程序是否会阵痛（“跃变”），在生产环境中慎用ntpdate，也正如此两者不可同时运行。NTPD 在和时间服务器的同步过程中，会把 BIOS 计时器的振荡频率偏差——或者说 Local Clock 的自然漂移(drift)——记录下来。这样即使网络有问题，本机仍然能维持一个相当精确的走时。 

“跃变”的危害： 
- 这样做不安全。ntpdate的设置依赖于ntp服务器的安全性，攻击者可以利用一些软件设计上的缺陷，拿下ntp服务器并令与其同步的服务器执行某些消耗性的任务。由于ntpdate采用的方式是跳变，跟随它的服务器无法知道是否发生了异常（时间不一样的时候，唯一的办法是以服务器为准）。
- 这样做不精确。一旦ntp服务器宕机，跟随它的服务器也就会无法同步时间。与此不同，ntpd不仅能够校准计算机的时间，而且能够校准计算机的时钟。
- 这样做不够优雅。由于是跳变，而不是使时间变快或变慢，依赖时序的程序会出错（例如，如果ntpdate发现你的时间快了，则可能会经历两个相同的时刻，对某些应用而言，这是致命的）。唯一一个可以令时间发生跳变的点，是计算机刚刚启动，但还没有启动很多服务的那个时候。

## FAQ

1. 假如我的时间比服务器快，NTP 会导致我的时钟往后调整吗？

   不会的，NTP使用一种相对平滑的方式来调整，它会让时钟的频率变慢，并最终和服务器保持同步。

2. NTP什么时候会失效？

   如果你的时间和服务器相差太多，超过17分钟，那么NTP认为你的时钟有问题，可能会拒绝同步。因此开启NTP之前，请手工调整下时钟(或者用 `ntpdate`手工同步一次，记得要关闭`ntpd`服务)，保证相差不会太多。

## 防火墙配置

```bash
iptables -I INPUT -p udp --dport 123 -j ACCEPT
```

## PPS 支持

从 Ubuntu 16.04 开始，ntp 支持 PPS 规范，给 ntp 提供了本地时间源，以提供更高的精度。查看下边列出的链接来获取更多配置信息。
