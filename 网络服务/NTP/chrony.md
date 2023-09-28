# chrony

[TOC]

## 概述

**chrony** 是 NTP 的一种实现。可以使用 chrony :

- 将系统时钟与 NTP 服务器同步。
- 将系统时钟与参考时钟同步，如 GPS 接收器。
- 将系统时钟与手动时间输入同步。
- 作为 NTPv4(RFC 5905) 服务器或对等服务器，为网络中的其他计算机提供时间服务。

chrony 包括 chronyd 和 chronyc 。

chronyd 是一个后台运行的守护进程，用于调整内核中运行的系统时钟和时钟服务器同步。它确定计算机增减时间的比率，并对此进行补偿。

chronyc 提供了一个用户界面，用于监控性能并进行多样化的配置。在默认情况下，`chronyd` 只接受来自本地 chronyc 实例的命令，但它也可以被配置为接受来自远程主机的监控命令。应该限制远程访问。

## 安装

1.安装 Chrony

系统默认已经安装，如未安装，请执行以下命令安装：

```bash
yum install chrony -y
dnf install chrony
```

chrony 守护进程的默认位置为 `/usr/sbin/chronyd`。chronyc 命令行工具将安装到 `/usr/bin/chronyc` 。 				

2.启动并加入开机自启动

```bash
systemctl enable  chronyd.service
systemctl restart chronyd.service
```

3.Firewalld设置

```bash
firewall-cmd --add-service=ntp --permanent
firewall-cmd --reload
```

## 配置

配置文件：/etc/chrony.conf

```bash
cat /etc/chrony.conf

# These servers were defined in the installation:
server 0.centos.pool.ntp.org iburst
server 1.centos.pool.ntp.org iburst
server 2.centos.pool.ntp.org iburst
server 3.centos.pool.ntp.org iburst
# Use public servers from the pool.ntp.org project.
# Please consider joining the pool (http://www.pool.ntp.org/join.html).
# 使用 pool.ntp.org 项目中的公共服务器。以 server 开头，理论上想添加多少时间服务器都可以。

# Record the rate at which the system clock gains/losses time.
# 根据实际时间计算出服务器增减时间的比率，然后记录到一个文件中，在系统重启后为系统做出最佳时间补偿调整。
driftfile /var/lib/chrony/drift

# chronyd根据需求减慢或加速时间调整，使得系统逐步纠正所有时间偏差。
# 在某些情况下系统时钟可能漂移过快，导致时间调整用时过长。
# 该指令强制chronyd调整时期，大于某个阀值时步进调整系统时钟。
# 只有在因chronyd启动时间超过指定的限制时（可使用负值来禁用限制）没有更多时钟更新时才生效。
# Allow the system clock to be stepped in the first three updates
# if its offset is larger than 1 second.
makestep 1.0 3

# Enable kernel synchronization of the real-time clock (RTC).
# 将启用一个内核模式，在该模式中，系统时间每11分钟会拷贝到实时时钟（RTC）。
rtcsync

# Enable hardware timestamping on all interfaces that support it.
# 通过使用 hwtimestamp 指令启用硬件时间戳
#hwtimestamp *

# Increase the minimum number of selectable sources required to adjust
# the system clock.
#minsources 2

# Allow NTP client access from local network.
# 指定一台主机、子网，或者网络以允许或拒绝 NTP 连接到扮演时钟服务器的机器
#allow 192.168.0.0/16

# Serve time even if not synchronized to a time source.
#local stratum 10

# Specify file containing keys for NTP authentication.
# 指定包含 NTP 验证密钥的文件。
keyfile /etc/chrony.keys

# Get TAI-UTC offset and leap seconds from the system tz database.
leapsectz right/UTC

# Specify directory for log files.
# 指定日志文件的目录。
logdir /var/log/chrony

# Select which information is logged.
#log measurements statistics tracking
```



**stratumweight** - 该指令设置当chronyd从可用源中选择同步源时，每个层应该添加多少距离到同步距离。默认情况下，CentOS中设置为0，让chronyd在选择源时忽略源的层级。

**cmdallow / cmddeny** - 跟上面相类似，可以指定哪个IP地址或哪台主机可以通过chronyd使用控制命令。

**bindcmdaddress** - 该指令允许限制chronyd监听哪个网络接口的命令包（由chronyc执行）。该指令通过cmddeny机制提供了一个除上述限制以外可用的额外的访问控制等级。

```shell
bindcmdaddress 127.0.0.1
bindcmdaddress ::1
```

## 管理 chrony

检查 `chronyd` 的状态：

```bash
systemctl status chronyd

chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled)
   Active: active (running) since Wed 2013-06-12 22:23:16 CEST; 11h ago
```

启动 `chronyd`：

```none
systemctl start chronyd
```

要确保 `chronyd` 在系统启动时自动启动：

```bash
systemctl enable chronyd
```

停止 `chronyd`：

```bash
systemctl stop chronyd
```

关闭 `chronyd` 在系统启动时自动启动：

```bash
systemctl disable chronyd
```



## 使用 chronyc

```bash
# 强制同步系统时钟
chronyc -a makestep

# 查看时间同步源
chronyc sources -v

# 查看时间同步源状态
chronyc sourcestats -v

# 校准时间服务器
chronyc tracking
```

**accheck** - 检查NTP访问是否对特定主机可用

**activity** - 该命令会显示有多少NTP源在线/离线

**add server** - 手动添加一台新的NTP服务器。

**clients** - 在客户端报告已访问到服务器

**delete** - 手动移除NTP服务器或对等服务器

**settime** - 手动设置守护进程时间

**tracking** - 显示系统时间信息

### 交互模式

要在互动模式中使用命令行工具 chronyc 来更改本地 `chronyd` 实例，以 root 用户身份输入以下命令：

```bash
chronyc
```

chronyc 命令提示符如下所示：

```bash
chronyc>
```

要列出所有的命令，请输入 `help`。

> 注意
>
> 使用 **chronyc** 所做的更改不具有持久性，它们会在 `chronyd` 重启后丢失。要使更改有持久性，修改 `/etc/chrony.conf`。 			

 	

## 检查是否同步 chrony

运行以下命令检查 **chrony** 跟踪：

```bash
chronyc tracking

Reference ID    : CB00710F (foo.example.net)
Stratum         : 3
Ref time (UTC)  : Fri Jan 27 09:49:17 2017
System time     :  0.000006523 seconds slow of NTP time
Last offset     : -0.000006747 seconds
RMS offset      : 0.000035822 seconds
Frequency       : 3.225 ppm slow
Residual freq   : 0.000 ppm
Skew            : 0.129 ppm
Root delay      : 0.013639022 seconds
Root dispersion : 0.001100737 seconds
Update interval : 64.2 seconds
Leap status     : Normal
```

sources 命令显示 `chronyd` 正在访问的当前时间源的信息。

```bash
chronyc sources

210 Number of sources = 3
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
#* GPS0                          0   4   377    11   -479ns[ -621ns] /-  134ns
^? a.b.c                         2   6   377    23   -923us[ -924us] +/-   43ms
^ d.e.f                         1   6   377    21  -2629us[-2619us] +/-   86ms
```

可以使用可选参数 -v 来包括详细信息。在这种情况下，会输出额外的标头行显示字段含义的信息。 				

`sourcestats` 命令显示目前被 `chronyd` 检查的每个源的偏移率和误差估算过程的信息。

```bash
chronyc sourcestats

210 Number of sources = 1
Name/IP Address            NP  NR  Span  Frequency  Freq Skew  Offset  Std Dev
===============================================================================
abc.def.ghi                11   5   46m     -0.001      0.045      1us    25us
```

可以使用可选参数 `-v` 来包括详细信息。在这种情况下，会输出额外的标头行显示字段含义的信息。

## 29.3. 手动调整系统时钟

​				下面的流程描述了如何手动调整系统时钟。 		

**流程**

1. ​						要立即调整系统时钟，绕过单机进行的任何调整，以 `root` 身份运行以下命令： 				

   

   ```none
   # chronyc makestep
   ```

​				如果使用了 `rtcfile` 指令，则不应该手动调整实时时钟。随机调整会影响 **chrony** 测量实时时钟漂移速率的需要。 		

## 29.4. 禁用 chrony 分配程序脚本

​				`chrony` 分配程序脚本管理 NTP 服务器的在线和离线状态。作为系统管理员，您可以禁用分配程序脚本，使 `chronyd` 持续轮询服务器。 		

​				如果在系统中启用 NetworkManager 来管理网络配置，NetworkManager 会在接口重新配置过程中执行 `chrony` 分配程序脚本，停止或启动操作。但是，如果您在 NetworkManager 之外配置某些接口或路由，您可能会遇到以下情况： 		

1. ​						当没有路由到 NTP 服务器的路由时，分配程序脚本可能会运行，从而导致 NTP 服务器切换到离线状态。 				
2. ​						如果您稍后建立路由，脚本默认不会再次运行，NTP 服务器将保持离线状态。 				

​				要确保 `chronyd` 可以与您的 NTP 服务器同步（有单独的受管接口），请禁用分配程序脚本。 		

**先决条件**

- ​						您在系统中安装了 NetworkManager 并启用它。 				
- ​						根访问权限 				

**流程**

1. ​						要禁用 `chrony` 分配程序脚本，请创建一个到 `/dev/null` 的符号链接： 				

   

   ```none
   # ln -s /dev/null /etc/NetworkManager/dispatcher.d/20-chrony-onoffline
   ```

   注意

   ​							在此更改后，NetworkManager 无法执行分配程序脚本，NTP 服务器始终保持在线状态。 					

## 29.5. 在隔离的网络中为系统设定 chrony

​				 对于从未连接到互联网的网络，一台计算机被选为主计时服务器。其他计算机是服务器的直接客户端，也可以是客户端的客户端。在服务器上，必须使用系统时钟的平均偏移率手动设置 drift 文件。如果服务器被重启，它将从周围的系统获得时间，并计算设置系统时钟的平均值。之后它会恢复基于 drift 文件的调整。当使用  settime 命令时会自动更新 `drift` 文件。 		

​				以下流程描述了如何为隔离的网络中的系统设置 **chrony**。 		

**流程**

1. ​						在选择为服务器的系统中，以 `root` 用户身份运行一个文本编辑器，编辑 `/etc/chrony.conf`，如下所示： 				

   

   ```none
   driftfile /var/lib/chrony/drift
   commandkey 1
   keyfile /etc/chrony.keys
   initstepslew 10 client1 client3 client6
   local stratum 8
   manual
   allow 192.0.2.0
   ```

   ​						其中 `192.0.2.0` 是允许客户端连接的网络或者子网地址。 				

2. ​						在选择成为服务器客户端的系统上，以 `root` 用户身份运行一个文本编辑器来编辑 `/etc/chrony.conf`，如下所示： 				

   

   ```none
   server ntp1.example.net
   driftfile /var/lib/chrony/drift
   logdir /var/log/chrony
   log measurements statistics tracking
   keyfile /etc/chrony.keys
   commandkey 24
   local stratum 10
   initstepslew 20 ntp1.example.net
   allow 192.0.2.123
   ```

   ​						其中 `192.0.2.123` 是服务器的地址，`ntp1.example.net` 是服务器的主机名。带有此配置的客户端如果服务器重启，则与服务器重新同步。 				

​				在不是服务器直接客户端的客户端系统中，`/etc/chrony.conf` 文件应该相同，除了应该省略 `local` 和 `allow` 指令。 		

​				在隔离的网络中，您还可以使用 `local` 指令来启用本地参考模式。该模式可允许 `chronyd` 作为 `NTP` 服务器实时显示同步，即使它从未同步或者最后一次更新时钟早前发生。 		

​				要允许网络中的多个服务器使用相同的本地配置并相互同步，而不让客户端轮询多个服务器，请使用 `local` 指令的 `orphan` 选项启用孤立模式。每一个服务器都需要配置为使用 `local` 轮询所有其他服务器。这样可确保只有最小参考 ID 的服务器具有本地参考活跃状态，其他服务器与之同步。当服务器出现故障时，另一台服务器将接管。 		

## 29.6. 配置远程监控访问

​				**chronyc** 可以通过两种方式访问 `chronyd`: 		

- ​						互联网协议、IPv4 或者 IPv6。 				
- ​						UNIX 域套接字，由 `root` 用户或 `chrony` 用户从本地进行访问。 				

​				默认情况下，**chronyc** 连接到 Unix 域套接字。默认路径为 `/var/run/chrony/chronyd.sock`。如果这个连接失败，比如，当 **chronyc** 在非 root 用户下运行时会发生，**chronyc** 会尝试连接到 127.0.0.1，然后 ::1。 		

​				网络中只允许以下监控命令，它们不会影响 `chronyd` 的行为： 		

- ​						activity 				
- ​						manual list 				
- ​						rtcdata 				
- ​						smoothing 				
- ​						sources 				
- ​						sourcestats 				
- ​						tracking 				
- ​						waitsync 				

​				`chronyd` 接受这些命令的主机集合可以使用 `chronyd` 配置文件中的 `cmdallow` 指令，或者在 **chronyc** 中使用 `cmdallow` 命令配置。默认情况下，仅接受来自 localhost（127.0.0.1 或 ::1）的命令。 		

​				所有其他命令只能通过 Unix 域套接字进行。当通过网络发送时，`chronyd` 会返回 `Notauthorized` 错误，即使它来自 localhost。 		

​				以下流程描述了如何使用 **chronyc** 远程访问 chronyd。 		

**流程**

1. ​						在 `/etc/chrony.conf` 文件中添加以下内容来允许 IPv4 和 IPv6 地址的访问： 				

   

   ```none
   bindcmdaddress 0.0.0.0
   ```

   ​						或者 				

   

   ```none
   bindcmdaddress ::
   ```

2. ​						使用 `cmdallow` 指令允许来自远程 IP 地址、网络或者子网的命令。 				

   ​						在 `/etc/chrony.conf` 文件中添加以下内容： 				

   

   ```none
   cmdallow 192.168.1.0/24
   ```

3. ​						在防火墙中打开端口 323 以从远程系统连接： 				

   

   ```none
   #  firewall-cmd --zone=public --add-port=323/udp
   ```

   ​						另外，您可以使用 `--permanent` 选项永久打开端口 323： 				

   

   ```none
   #  firewall-cmd --permanent --zone=public --add-port=323/udp
   ```

4. ​						如果您永久打开了端口 323，请重新载入防火墙配置： 				

   

   ```none
   firewall-cmd --reload
   ```

**其他资源**

- ​						`chrony.conf(5)` 手册页 				

## 29.7. 使用 RHEL 系统角色管理时间同步

​				您可以使用 `timesync` 角色在多个目标机器上管理时间同步。`timesync` 角色安装和配置 NTP 或 PTP 实现，作为 NTP 或 PTP 客户端来同步系统时钟。 		

警告

​					`timesync 角色`替换了受管主机上给定或检测到的供应商服务的配置。之前的设置即使没有在角色变量中指定，也会丢失。如果没有定义 `timesync_ntp_provider` 变量，唯一保留的设置就是供应商选择。 			

​				以下示例演示了如何在只有一个服务器池的情况下应用 `timesync` 角色。 		

例 29.1. 为单一服务器池应用 timesync 角色的 playbook 示例



```none
---
- hosts: timesync-test
  vars:
    timesync_ntp_servers:
      - hostname: 2.rhel.pool.ntp.org
        pool: yes
        iburst: yes
  roles:
    - rhel-system-roles.timesync
```

​				有关 `timesync` 角色变量的详细参考，请安装 `rhel-system-roles` 软件包，并参阅 `/usr/share/doc/rhel-system-roles/timesync` 目录中的 `README.md` 或 `README.html` 文件。 		

**其他资源**

- ​						[准备控制节点和受管节点以使用 RHEL 系统角色](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/administration_and_configuration_tasks_using_system_roles_in_rhel/assembly_preparing-a-control-node-and-managed-nodes-to-use-rhel-system-roles_administration-and-configuration-tasks-using-system-roles-in-rhel) 				

## 29.8. 其他资源

- ​						`chronyc(1)` 手册页 				
- ​						`chronyd(8)` 手册页 				
- ​						[常见问题解答](https://chrony.tuxfamily.org/faq.html) 				

# 第 30 章 带有 HW 时间戳的 Chrony

​			硬件时间戳是在一些网络接口控制器(NIC)中支持的一种功能，它提供传入和传出数据包的准确的时间戳。`NTP` 时间戳通常由内核及使用系统时钟的 **chronyd** 创建。但是，当启用了 HW 时间戳时，NIC 使用自己的时钟在数据包进入或离开链路层或物理层时生成时间戳。与 `NTP` 一起使用时，硬件时间戳可以显著提高同步的准确性。为了获得最佳准确性，`NTP` 服务器和 `NTP` 客户端都需要使用硬件时间戳。在理想条件下，可达到次微秒级的准确性。 	

​			另一个用于使用硬件时间戳进行时间同步的协议是 `PTP` 	

​			与 `NTP` 不同，`PTP` 依赖于网络交换机和路由器。如果您想要达到同步的最佳准确性，请在带有 `PTP` 支持的网络中使用 `PTP`，在使用不支持这个协议的交换机和路由器的网络上选择 `NTP`。 				

## 30.1. 验证硬件时间戳支持

​				要验证接口是否支持使用 `NTP` 的硬件时间戳，请使用 `ethtool -T` 命令。如果 `ethtool` 列出了 `SOF_TIMESTAMPING_TX_HARDWARE` 和 `SOF_TIMESTAMPING_TX_SOFTWARE` 模式，以及 `HWTSTAMP_FILTER_ ALL` 过滤器模式，则可以使用硬件时间戳的 `NTP`。 		

例 30.1. 在特定接口中验证硬件时间戳支持



```none
# ethtool -T eth0
```

​					输出： 			



```none
Timestamping parameters for eth0:
Capabilities:
        hardware-transmit     (SOF_TIMESTAMPING_TX_HARDWARE)
        software-transmit     (SOF_TIMESTAMPING_TX_SOFTWARE)
        hardware-receive      (SOF_TIMESTAMPING_RX_HARDWARE)
        software-receive      (SOF_TIMESTAMPING_RX_SOFTWARE)
        software-system-clock (SOF_TIMESTAMPING_SOFTWARE)
        hardware-raw-clock    (SOF_TIMESTAMPING_RAW_HARDWARE)
PTP Hardware Clock: 0
Hardware Transmit Timestamp Modes:
        off                   (HWTSTAMP_TX_OFF)
        on                    (HWTSTAMP_TX_ON)
Hardware Receive Filter Modes:
        none                  (HWTSTAMP_FILTER_NONE)
        all                   (HWTSTAMP_FILTER_ALL)
        ptpv1-l4-sync         (HWTSTAMP_FILTER_PTP_V1_L4_SYNC)
        ptpv1-l4-delay-req    (HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ)
        ptpv2-l4-sync         (HWTSTAMP_FILTER_PTP_V2_L4_SYNC)
        ptpv2-l4-delay-req    (HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ)
        ptpv2-l2-sync         (HWTSTAMP_FILTER_PTP_V2_L2_SYNC)
        ptpv2-l2-delay-req    (HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ)
        ptpv2-event           (HWTSTAMP_FILTER_PTP_V2_EVENT)
        ptpv2-sync            (HWTSTAMP_FILTER_PTP_V2_SYNC)
        ptpv2-delay-req       (HWTSTAMP_FILTER_PTP_V2_DELAY_REQ)
```

## 30.2. 启用硬件时间戳

​				要启用硬件时间戳，请使用 `/etc/chrony.conf` 文件中的 `hwtimestamp` 指令。该指令可指定单一接口，也可以指定通配符字符来启用所有支持接口的硬件时间戳。在没有其他应用程序（如 `linuxptp` 软件包中的 **ptp4l** 在接口上使用硬件时间戳）的情况下，请使用通配符规范。在 chrony 配置文件中允许使用多个 `hwtimestamp` 指令。 		

例 30.2. 使用 hwtimestamp 指令启用硬件时间戳



```none
hwtimestamp eth0
hwtimestamp eth1
hwtimestamp *
```

## 30.3. 配置客户端轮询间隔

​				建议为互联网中的服务器使用默认的轮询间隔范围（64-1024秒）。对于本地服务器和硬件时间戳，需要配置一个较短的轮询间隔，以便最小化系统时钟偏差。 		

​				`/etc/chrony.conf` 中的以下指令指定了使用一秒轮询间隔的本地 `NTP` 服务器： 		



```none
server ntp.local minpoll 0 maxpoll 0
```

## 30.4. 启用交错模式

​				`NTP` 服务器不是硬件的 `NTP` 设备，而是运行软件 `NTP` 实现的通用计算机，如 **chrony** ，将在发送数据包后才会获得硬件传输时间戳。此行为可防止服务器在其对应的数据包中保存时间戳。为了使 `NTP` 客户端接收传输后生成的传输时间戳，请将客户端配置为使用 `NTP` 交错模式，方法是在 `/etc/chrony.conf` 的 server 指令中添加 `xleave` 选项： 		



```none
server ntp.local minpoll 0 maxpoll 0 xleave
```

## 30.5. 为大量客户端配置服务器

​				默认服务器配置允许最多几千个客户端同时使用交错模式。要为更多的客户端配置服务器，增大 `/etc/chrony.conf` 中的 `clientloglimit` 指令。这个指令指定了为服务器上客户端访问的日志分配的最大内存大小： 		



```none
clientloglimit 100000000
```

## 30.6. 验证硬件时间戳

​				要校验该接口是否已成功启用了硬件时间戳，请检查系统日志。这个日志应该包含来自 `chronyd` 的每个接口的消息，并成功启用硬件时间戳。 		

例 30.3. 为启用硬件时间戳的接口记录日志信息



```none
chronyd[4081]: Enabled HW timestamping on eth0
chronyd[4081]: Enabled HW timestamping on eth1
```

​				当 `chronyd` 被配置为 `NTP` 客户端或对等的客户端时，您可以使用 `chronyc ntpdata` 命令为每个 `NTP` 源报告传输和接收时间戳模式以及交错模式： 		

例 30.4. 报告每个 NTP 源的传输、接收时间戳以及交集模式



```none
# chronyc ntpdata
```

​					输出： 			



```none
Remote address  : 203.0.113.15 (CB00710F)
Remote port     : 123
Local address   : 203.0.113.74 (CB00714A)
Leap status     : Normal
Version         : 4
Mode            : Server
Stratum         : 1
Poll interval   : 0 (1 seconds)
Precision       : -24 (0.000000060 seconds)
Root delay      : 0.000015 seconds
Root dispersion : 0.000015 seconds
Reference ID    : 47505300 (GPS)
Reference time  : Wed May 03 13:47:45 2017
Offset          : -0.000000134 seconds
Peer delay      : 0.000005396 seconds
Peer dispersion : 0.000002329 seconds
Response time   : 0.000152073 seconds
Jitter asymmetry: +0.00
NTP tests       : 111 111 1111
Interleaved     : Yes
Authenticated   : No
TX timestamping : Hardware
RX timestamping : Hardware
Total TX        : 27
Total RX        : 27
Total valid RX  : 27
```

例 30.5. 报告 NTP 测量的稳定性



```none
# chronyc sourcestats
```

​					启用硬件时间戳后，正常负载下，`NTP` 测量的稳定性应该以十秒或数百纳秒为单位。此稳定性会在 `chronyc sourcestats` 命令的输出结果中的 `Std Dev` 列中报告： 			

​					输出： 			



```none
210 Number of sources = 1
Name/IP Address            NP  NR  Span  Frequency  Freq Skew  Offset  Std Dev
ntp.local                  12   7    11     +0.000      0.019     +0ns    49ns
```

## 30.7. 配置 PTP-NTP 桥接

​				如果网络中有一个高度准确的 Precision Time Protocol (`PTP`)主时间服务器，但没有支持 `PTP` 支持的交换机或路由器，则计算机可能专用于作为 `PTP` 客户端和 stratum-1 `NTP` 服务器。此类计算机需要具有两个或更多个网络接口，并且接近主时间服务器或与它直接连接。这样可保证高度准确的网络同步。 		

​				从 `linuxptp` 软件包中配置 **ptp4l** 和 **phc2sys** 程序，以使用 `PTP` 来同步系统时钟。 		

​				将 `chronyd` 配置为使用其他接口提供系统时间： 		

例 30.6. 将 chronyd 配置为使用其他接口提供系统时间



```none
bindaddress 203.0.113.74
hwtimestamp eth1
local stratum 1
```

# 第 31 章 chrony 中的网络时间安全概述(NTS)

​			Network Time  Security(NTS)是用于网络时间协议(NTP)的身份验证机制，旨在扩展大量客户端。它将验证从服务器计算机接收的数据包在移到客户端机器时是否被取消处理。Network Time Security(NTS)包含 Key  Establishment(NTS-KE)协议，该协议会自动创建在服务器及其客户端中使用的加密密钥。 	

## 31.1. 在客户端配置文件中启用网络时间协议(NTS)

​				默认情况下不启用 Network Time Security(NTS)。您可以在 `/etc/chrony.conf` 中启用 NTS。为此，请执行以下步骤： 		

**先决条件**

- ​						带有 NTS 支持的服务器 				

**流程**

​					在客户端配置文件中： 			

1. ​						除推荐的 `iburst` 选项外，使用 `nts` 选项指定服务器。 				

   

   ```none
   For example:
   server time.example.com iburst nts
   server nts.netnod.se iburst nts
   server ptbtime1.ptb.de iburst nts
   ```

2. ​						要避免在系统引导时重复 Network Time Security-Key Establishment(NTS-KE)会话，请在 `chrony.conf` 中添加以下行（如果不存在）： 				

   

   ```none
   ntsdumpdir /var/lib/chrony
   ```

3. ​						要禁用 `DHCP` 提供的网络时间协议(NTP)服务器的同步，注释掉或删除 `chrony.conf` 中的以下行（如果存在）： 				

   

   ```none
   sourcedir /run/chrony-dhcp
   ```

4. ​						保存您的更改。 				

5. ​						重启 `chronyd` 服务： 				

   

   ```none
   systemctl restart chronyd
   ```

**验证**

- ​						验证 `NTS` 密钥是否已成功建立： 				

  

  ```none
  # chronyc -N authdata
  
  Name/IP address  Mode KeyID Type KLen Last Atmp  NAK Cook CLen
  ================================================================
  time.example.com  NTS     1   15  256  33m    0    0    8  100
  nts.sth1.ntp.se   NTS     1   15  256  33m    0    0    8  100
  nts.sth2.ntp.se   NTS     1   15  256  33m    0    0    8  100
  ```

  ​						`KeyID`、`Type` 和 `KLen` 应带有非零值。如果该值为零，请检查系统日志中来自 `chronyd` 的错误消息。 				

- ​						验证客户端是否正在进行 NTP 测量： 				

  

  ```none
  # chronyc -N sources
  
  MS Name/IP address Stratum Poll Reach LastRx Last sample
  =========================================================
  time.example.com   3        6   377    45   +355us[ +375us] +/-   11ms
  nts.sth1.ntp.se    1        6   377    44   +237us[ +237us] +/-   23ms
  nts.sth2.ntp.se    1        6   377    44   -170us[ -170us] +/-   22ms
  ```

  ​						`Reach` 列中应具有非零值；理想情况是 377。如果值很少为 377 或永远不是 377，这表示 NTP 请求或响应在网络中丢失。 				

**其他资源**

- ​						`chrony.conf(5)` 手册页 				

## 31.2. 在服务器上启用网络时间安全性(NTS)

​				如果您运行自己的网络时间协议(NTP)服务器，您可以启用服务器网络时间协议(NTS)支持来促进其客户端安全地同步。 		

​				如果 NTP 服务器是其它服务器的客户端，即它不是 Stratum 1 服务器，它应使用 NTS 或对称密钥进行同步。 		

**先决条件**

- ​						以 `PEM` 格式的服务器私钥 				
- ​						带有 `PEM` 格式的所需中间证书的服务器证书 				

**流程**

1. ​						在 `chrony.conf`中指定私钥和证书文件 				

   

   ```none
   For example:
   ntsserverkey /etc/pki/tls/private/foo.example.net.key
   ntsservercert /etc/pki/tls/certs/foo.example.net.crt
   ```

2. ​						通过设置组所有权，确保 chrony 系统用户可读密钥和证书文件。 				

   

   ```none
   For example:
   chown :chrony /etc/pki/tls/*/foo.example.net.*
   ```

3. ​						确保 `chrony.conf` 中存在 `ntsdumpdir /var/lib/chrony` 指令。 				

4. ​						重启 `chronyd` 服务： 				

   

   ```none
   systemctl restart chronyd
   ```

   重要

   ​							如果服务器具有防火墙，则需要允许 NTP 和 Network Time Security-Key Establishment(NTS-KE)的 `UDP 123` 和 `TCP 4460` 端口。 					

**验证**

- ​						使用以下命令从客户端机器执行快速测试： 				

  

  ```none
  $ chronyd -Q -t 3 'server
  
  foo.example.net iburst nts maxsamples 1'
  2021-09-15T13:45:26Z chronyd version 4.1 starting (+CMDMON +NTP +REFCLOCK +RTC +PRIVDROP +SCFILTER +SIGND +ASYNCDNS +NTS +SECHASH +IPV6 +DEBUG)
  2021-09-15T13:45:26Z Disabled control of system clock
  2021-09-15T13:45:28Z System clock wrong by 0.002205 seconds (ignored)
  2021-09-15T13:45:28Z chronyd exiting
  ```

  ​						`System clock wrong` 消息指示 NTP 服务器接受 NTS-KE 连接并使用 NTS 保护的 NTP 消息进行响应。 				

- ​						验证 NTS-KE 连接并验证服务器中观察的 NTP 数据包： 				

  

  ```none
  # chronyc serverstats
  
  NTP packets received       : 7
  NTP packets dropped        : 0
  Command packets received   : 22
  Command packets dropped    : 0
  Client log records dropped : 0
  NTS-KE connections accepted: 1
  NTS-KE connections dropped : 0
  Authenticated NTP packets: 7
  ```

  ​						如果 `NTS-KE connections accepted` 和 `Authenticated NTP packets` 项带有一个非零值，这意味着至少有一个客户端能够连接到 NTS-KE 端口并发送经过身份验证的 NTP 请求。 				
