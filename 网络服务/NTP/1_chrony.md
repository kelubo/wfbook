# chrony

[TOC]

## 概述

**chrony** 是 NTP 的一种实现。可以使用 chrony :

- 将系统时钟与 NTP 服务器同步。
- 将系统时钟与参考时钟同步，如 GPS 接收器。
- 将系统时钟与手动时间输入同步。
- 作为 NTPv4 (RFC 5905) 服务器或对等服务器，为网络中的其他计算机提供时间服务。

它被设计为在各种条件下表现良好，包括间歇性网络连接、严重拥塞的网络、温度变化（普通计算机时钟对温度敏感）以及不连续运行或在虚拟机上运行的系统。

通过互联网同步的两台机器之间的典型精度在几毫秒内；在 LAN 上，精度通常以数十微秒为单位。使用硬件时间戳或硬件参考时钟，可以实现亚微秒级的精度。

chrony 包括 chronyd 和 chronyc 。

* chronyd 是一个后台运行的守护进程，用于调整内核中运行的系统时钟和与时钟服务器同步。它确定计算机增减时间的比率，并对此进行补偿。计算系统时钟的漂移和偏移量，并不断对其进行调整，因此不会出现可能导致日志不一致的大型校正。成本是一点处理能力和内存，但对于现代服务器来说，这通常可以忽略不计。
* chronyc 提供了一个用户界面，用于监控性能并进行多样化的配置。在默认情况下，`chronyd` 只接受来自本地 chronyc 实例的命令，但它也可以被配置为接受来自远程主机的监控命令。应该限制远程访问。

在 `chrony` 、 现在不推荐使用的 `ntpd` 和 `open-ntp` 之间，有很多选择。推荐的解决方案是 `chrony` 。

`chrony` 最初由理查德·科诺（[Richard Curnow](http://www.rc0.org.uk/index.html)）撰写。目前由 Miroslav Lichvar [(PGP key)](https://chrony-project.org/gpgkey-8F375C7E8D0EE125A3D3BD51537E2B76F7680DAC.asc) 维护和开发。

## 安装 `chronyd`

### 支持的操作系统

* Linux
* FreeBSD
* NetBSD
* macOS
* illumos

### 安装

要安装 `chrony` ，请从终端提示符运行以下命令：

```bash
sudo apt install chrony
yum install chrony
dnf install chrony
```

这将提供两个二进制文件：

- `chronyd`
- `chronyc`

chrony 守护进程的默认位置为 `/usr/sbin/chronyd `。chronyc 命令行工具将安装到 `/usr/bin/chronyc` 。

防火墙设置

```bash
# Firewalld
firewall-cmd --add-service=ntp --permanent
firewall-cmd --reload
```

## 配置 `chronyd` 

首先，编辑 `/etc/chrony/chrony.conf` 以添加/删除服务器行。默认情况下，这些服务器配置如下：

```bash
# Use servers from the NTP Pool Project. Approved by Ubuntu Technical Board
# on 2011-02-08 (LP: #104525). See http://www.pool.ntp.org/join.html for
# more information.
pool 0.ubuntu.pool.ntp.org iburst
pool 1.ubuntu.pool.ntp.org iburst
pool 2.ubuntu.pool.ntp.org iburst
pool 3.ubuntu.pool.ntp.org iburst
```

更改配置文件的任何部分后，您需要重新启动 `chrony` ，如下所示：

```bash
sudo systemctl restart chrony.service
```

If you need to force IPv6, there is also `ipv6.ntp.ubuntu.com` which is not configured by default.
如果需要， `2.ubuntu.pool.ntp.org` `ntp.ubuntu.com` 还支持 IPv6。如果需要强制IPv6，还有 `ipv6.ntp.ubuntu.com` 默认未配置的。

### 配置文件 /etc/chrony.conf

>  注意：
>
> 该配置文件由 Ubuntu 、Debian 、CentOS 及 man 手册合并而来。在不同的操作系统中，可能仅有其中部分内容。

```bash
# 此文件配置 chronyd 守护程序。编译位置为 /etc/chrony/chrony.conf。可以在 chronyd 命令行上使用 -f 选项指定其他位置。

# 配置文件中的每个指令都放在单独的行上。这些指令不区分大小写。通常，指令可以按文件中的任何顺序出现，如果多次指定指令，则只有最后一个指令有效。说明中注明了例外情况。

# 配置指令也可以直接在 chronyd 命令行上指定。在这种情况下，每个参数都被解析为一个新行，配置文件将被忽略。虽然支持的指令数量很多，但通常只需要其中的几个。

# 配置文件可能包含注释行。注释行是以零个或多个空格开头，后跟以下任一字符的任何行：！、;、#、%。任何具有此格式的行都将被忽略。

# Welcome to the chrony configuration file. See chrony.conf(5) for more
# information about usable directives.

# Include configuration files found in /etc/chrony/conf.d.
confdir /etc/chrony/conf.d

# Use Debian vendor zone.
pool 2.debian.pool.ntp.org iburst

#server hostname [option]...
# 指令指定可用作时间源的 NTP 服务器。客户端-服务器关系是严格分层的：客户端可以将其系统时间同步到服务器的系统时间，但服务器的系统时间永远不会受到客户端系统时间的影响。此指令可以多次用于指定多个服务器。该指令后面紧跟着服务器的名称或其 IP 地址。它支持以下选项： 

# These servers were defined in the installation:
server 0.centos.pool.ntp.org iburst
server 1.centos.pool.ntp.org iburst
server 2.centos.pool.ntp.org iburst
server 3.centos.pool.ntp.org iburst
# Use public servers from the pool.ntp.org project.
# Please consider joining the pool (http://www.pool.ntp.org/join.html).
# 使用 pool.ntp.org 项目中的公共服务器。以 server 开头，理论上想添加多少时间服务器都可以。

 is strictly hierarchical: a client might synchronise its
           system time to that of the server, but the server’s system time will never be
           influenced by that of a client.

           This directive can be used multiple times to specify multiple servers.

           The directive is immediately followed by either the name of the server, or its IP
           address. It supports the following options:



# Use time sources from DHCP.
sourcedir /run/chrony-dhcp

# Use NTP sources found in /etc/chrony/sources.d.
sourcedir /etc/chrony/sources.d

# Record the rate at which the system clock gains/losses time.
# 根据实际时间计算出服务器增减时间的比率，然后记录到一个文件中，在系统重启后为系统做出最佳时间补偿调整。
# This directive specify the file into which chronyd will store the rate
# information.
driftfile /var/lib/chrony/drift
# Debian
#driftfile /var/lib/chrony/chrony.drift

# chronyd根据需求减慢或加速时间调整，使得系统逐步纠正所有时间偏差。
# 在某些情况下系统时钟可能漂移过快，导致时间调整用时过长。
# 该指令强制chronyd调整时期，大于某个阀值时步进调整系统时钟。
# 只有在因chronyd启动时间超过指定的限制时（可使用负值来禁用限制）没有更多时钟更新时才生效。
# Allow the system clock to be stepped in the first three updates
# if its offset is larger than 1 second.
# Step the system clock instead of slewing it if the adjustment is larger than
# one second, but only in the first three clock updates.
makestep 1.0 3
# Debian
#makestep 1 3

# Enable kernel synchronization of the real-time clock (RTC).
# 将启用一个内核模式，在该模式中，系统时间每11分钟会拷贝到实时时钟（RTC）。
# This directive enables kernel synchronisation (every 11 minutes) of the
# real-time clock. Note that it can't be used along with the 'rtcfile' directive.
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
# This directive specify the location of the file containing ID/key pairs for
# NTP authentication.
keyfile /etc/chrony.keys
# Debian
#keyfile /etc/chrony/chrony.keys

# Get TAI-UTC offset and leap seconds from the system tz database.
# This directive must be commented out when using time sources serving
# leap-smeared time.
leapsectz right/UTC

# Uncomment the following line to turn logging on.
# Select which information is logged.
#log tracking measurements statistics
#log measurements statistics tracking

# Log files location.
# Specify directory for log files.
# 指定日志文件的目录。
logdir /var/log/chrony

# Save NTS keys and cookies.
ntsdumpdir /var/lib/chrony

# Stop bad estimates upsetting machine clock.
maxupdateskew 100.0





           minpoll poll
               This option specifies the minimum interval between requests sent to the server as
               a power of 2 in seconds. For example, minpoll 5 would mean that the polling
               interval should not drop below 32 seconds. The default is 6 (64 seconds), the
               minimum is -6 (1/64th of a second), and the maximum is 24 (6 months). Note that
               intervals shorter than 6 (64 seconds) should generally not be used with public
               servers on the Internet, because it might be considered abuse. A sub-second
               interval will be enabled only when the server is reachable and the round-trip
               delay is shorter than 10 milliseconds, i.e. the server should be in a local
               network.
minpoll poll 此选项指定发送到服务器的请求之间的最小间隔，以 2 的幂为单位（以秒为单位）。例如，minpoll 5 表示轮询间隔不应低于 32 秒。默认值为 6（64 秒），最小值为 -6（1/64 秒），最大值为 24（6 个月）。请注意，小于 6（64 秒）的间隔通常不应用于 Internet 上的公共服务器，因为它可能被视为滥用。只有当服务器可访问且往返延迟短于 10 毫秒时，才会启用亚秒间隔，即服务器应位于本地网络中。maxpoll poll 此选项指定发送到服务器的请求之间的最大间隔，以 2 的幂为单位（以秒为单位）。例如，maxpoll 9 指示轮询间隔应保持在 9（512 秒）或以下。默认值为 10（1024 秒），最小值为 -6（1/64 秒），最大值为 24（6 个月）。iburst 使用此选项，chronyd 将从 4-8 个请求的突发开始，以便更快地进行时钟的第一次更新。每次使用chronyc中的在线命令将源从离线状态切换到在线状态时，它也会重复突发。 burst 使用此选项，chronyd 在无法从服务器获得良好的测量值时，将发送最多 4 个请求的突发。突发中的请求数受当前轮询间隔的限制，以保持平均间隔等于或高于最小间隔，即当前间隔至少需要比最小间隔长两倍，才能允许两个请求的突发。密钥 ID NTP 协议支持消息身份验证代码 （MAC），以防止计算机因向其发送恶意数据包而扰乱其系统时间。MAC 是作为密钥文件中指定的密钥的函数生成的，该密钥文件由 keyfile 指令指定。key 选项指定应使用哪个密钥（ID 在 1 到 2^32-1 范围内）来验证发送到服务器的请求并验证其响应。服务器必须为此号码配置相同的密钥，否则计算机之间将无法建立任何关系。如果服务器运行的是 ntpd，并且密钥使用的哈希函数的输出大小超过 160 位（例如 SHA256），则需要将 version 选项设置为 4 以实现兼容性。nts 此选项启用使用网络时间安全性 （NTS） 机制进行身份验证。与密钥选项不同，服务器和客户端不需要在密钥文件中共享密钥。NTS 具有密钥建立 （NTS-KE） 协议，该协议使用传输层安全性 （TLS） 协议来获取 NTS 身份验证 NTP 数据包所需的密钥和 Cookie。certset ID 此选项指定在启用 nts 选项时应使用哪组受信任的证书来验证服务器的证书。可以使用 ntstrustedcerts 指令指定证书集。 默认设置为 0，默认情况下包含系统默认受信任证书颁发机构的证书。MaxDelay Delay Chronyd 使用到服务器的网络往返延迟来确定特定测量的准确性。较长的往返延迟表示请求或响应或两者都已延迟。如果只有一条消息延迟，则测量误差可能很大。对于往返延迟的微小变化，chronyd在处理测量时使用加权方案。然而，超过一定程度的延迟，测量可能会被破坏到毫无用处。（在无线网络和其他慢速链路上尤其如此，其中长时间的延迟可能表明高度不对称的延迟，这是由于响应等待与某种下载相关的大量数据包造成的）。如果用户知道高于某个级别的往返延迟会导致测量被忽略，则可以使用 maxdelay 选项定义此级别。例如，maxdelay 0.3 表示应忽略往返延迟为 0.3 秒或更长时间的测量值。默认值为 3 秒，最大值为 1000 秒。maxdelayratio ratio 此选项类似于上面的 maxdelay 选项。chronyd会记录它缓冲的先前测量值中的最小往返延迟。如果测量的往返延迟大于指定的比率乘以最小延迟，则将被拒绝。 
           maxpoll poll
               This option specifies the maximum interval between requests sent to the server as
               a power of 2 in seconds. For example, maxpoll 9 indicates that the polling
               interval should stay at or below 9 (512 seconds). The default is 10 (1024
               seconds), the minimum is -6 (1/64th of a second), and the maximum is 24 (6
               months).

           iburst
               With this option, chronyd will start with a burst of 4-8 requests in order to make
               the first update of the clock sooner. It will also repeat the burst every time the
               source is switched from the offline state to online with the online command in
               chronyc.

           burst
               With this option, chronyd will send a burst of up to 4 requests when it cannot get
               a good measurement from the server. The number of requests in the burst is limited
               by the current polling interval to keep the average interval at or above the
               minimum interval, i.e. the current interval needs to be at least two times longer
               than the minimum interval in order to allow a burst with two requests.

           key ID
               The NTP protocol supports a message authentication code (MAC) to prevent computers
               having their system time upset by rogue packets being sent to them. The MAC is
               generated as a function of a key specified in the key file, which is specified by
               the keyfile directive.

               The key option specifies which key (with an ID in the range 1 through 2^32-1)
               should chronyd use to authenticate requests sent to the server and verify its
               responses. The server must have the same key for this number configured, otherwise
               no relationship between the computers will be possible.

               If the server is running ntpd and the output size of the hash function used by the
               key is longer than 160 bits (e.g. SHA256), the version option needs to be set to 4
               for compatibility.

           nts
               This option enables authentication using the Network Time Security (NTS)
               mechanism. Unlike with the key option, the server and client do not need to share
               a key in a key file. NTS has a Key Establishment (NTS-KE) protocol using the
               Transport Layer Security (TLS) protocol to get the keys and cookies required by
               NTS for authentication of NTP packets.

           certset ID
               This option specifies which set of trusted certificates should be used to verify
               the server’s certificate when the nts option is enabled. Sets of certificates can
               be specified with the ntstrustedcerts directive. The default set is 0, which by
               default contains certificates of the system’s default trusted certificate
               authorities.

           maxdelay delay
               chronyd uses the network round-trip delay to the server to determine how accurate
               a particular measurement is likely to be. Long round-trip delays indicate that the
               request, or the response, or both were delayed. If only one of the messages was
               delayed the measurement error is likely to be substantial.

               For small variations in the round-trip delay, chronyd uses a weighting scheme when
               processing the measurements. However, beyond a certain level of delay the
               measurements are likely to be so corrupted as to be useless. (This is particularly
               so on wireless networks and other slow links, where a long delay probably
               indicates a highly asymmetric delay caused by the response waiting behind a lot of
               packets related to a download of some sort).

               If the user knows that round trip delays above a certain level should cause the
               measurement to be ignored, this level can be defined with the maxdelay option. For
               example, maxdelay 0.3 would indicate that measurements with a round-trip delay of
               0.3 seconds or more should be ignored. The default value is 3 seconds and the
               maximum value is 1000 seconds.

           maxdelayratio ratio
               This option is similar to the maxdelay option above. chronyd keeps a record of the
               minimum round-trip delay amongst the previous measurements that it has buffered.
               If a measurement has a round trip delay that is greater than the specified ratio
               times the minimum delay, it will be rejected.

           maxdelaydevratio ratio
               If a measurement has a ratio of the increase in the round-trip delay from the
               minimum delay amongst the previous measurements to the standard deviation of the
               previous measurements that is greater than the specified ratio, it will be
               rejected. The default is 10.0.

           mindelay delay
               This option specifies a fixed minimum round-trip delay to be used instead of the
               minimum amongst the previous measurements. This can be useful in networks with
               static configuration to improve the stability of corrections for asymmetric
               jitter, weighting of the measurements, and the maxdelayratio and maxdelaydevratio
               tests. The value should be set accurately in order to have a positive effect on
               the synchronisation.

           asymmetry ratio
               This option specifies the asymmetry of the network jitter on the path to the
               source, which is used to correct the measured offset according to the delay. The
               asymmetry can be between -0.5 and +0.5. A negative value means the delay of
               packets sent to the source is more variable than the delay of packets sent from
               the source back. By default, chronyd estimates the asymmetry automatically.

           offset offset
               This option specifies a correction (in seconds) which will be applied to offsets
               measured with this source. It’s particularly useful to compensate for a known
               asymmetry in network delay or timestamping errors. For example, if packets sent to
               the source were on average delayed by 100 microseconds more than packets sent from
               the source back, the correction would be -0.00005 (-50 microseconds). The default
               is 0.0.

           minsamples samples
               Set the minimum number of samples kept for this source. This overrides the
               minsamples directive.

           maxsamples samples
               Set the maximum number of samples kept for this source. This overrides the
               maxsamples directive.

           filter samples
               This option enables a median filter to reduce noise in NTP measurements. The
               filter will reduce the specified number of samples to a single sample. It is
               intended to be used with very short polling intervals in local networks where it
               is acceptable to generate a lot of NTP traffic.

           offline
               If the server will not be reachable when chronyd is started, the offline option
               can be specified. chronyd will not try to poll the server until it is enabled to
               do so (by using the online command in chronyc).

           auto_offline
               With this option, the server will be assumed to have gone offline when sending a
               request fails, e.g. due to a missing route to the network. This option avoids the
               need to run the offline command from chronyc when disconnecting the network link.
               (It will still be necessary to use the online command when the link has been
               established, to enable measurements to start.)

           prefer
               Prefer this source over sources without the prefer option.

           noselect
               Never select this source. This is particularly useful for monitoring.

           trust
               Assume time from this source is always true. It can be rejected as a falseticker
               in the source selection only if another source with this option does not agree
               with it.

           require
               Require that at least one of the sources specified with this option is selectable
               (i.e. recently reachable and not a falseticker) before updating the clock.
               Together with the trust option this might be useful to allow a trusted
               authenticated source to be safely combined with unauthenticated sources in order
               to improve the accuracy of the clock. They can be selected and used for
               synchronisation only if they agree with the trusted and required source.

           xleave
               This option enables the interleaved mode of NTP. It enables the server to respond
               with more accurate transmit timestamps (e.g. kernel or hardware timestamps), which
               cannot be contained in the transmitted packet itself and need to refer to a
               previous packet instead. This can significantly improve the accuracy and stability
               of the measurements.

               The interleaved mode is compatible with servers that support only the basic mode.
               Note that even servers that support the interleaved mode might respond in the
               basic mode as the interleaved mode requires the servers to keep some state for
               each client and the state might be dropped when there are too many clients (e.g.
               clientloglimit is too small), or it might be overwritten by other clients that
               have the same IP address (e.g. computers behind NAT or someone sending requests
               with a spoofed source address).

               The xleave option can be combined with the presend option in order to shorten the
               interval in which the server has to keep the state to be able to respond in the
               interleaved mode.

           polltarget target
               Target number of measurements to use for the regression algorithm which chronyd
               will try to maintain by adjusting the polling interval between minpoll and
               maxpoll. A higher target makes chronyd prefer shorter polling intervals. The
               default is 8 and a useful range is from 6 to 60.

           port port
               This option allows the UDP port on which the server understands NTP requests to be
               specified. For normal servers this option should not be required (the default is
               123, the standard NTP port).

           ntsport port
               This option specifies the TCP port on which the server is listening for NTS-KE
               connections when the nts option is enabled. The default is 4460.

           presend poll
               If the timing measurements being made by chronyd are the only network data passing
               between two computers, you might find that some measurements are badly skewed due
               to either the client or the server having to do an ARP lookup on the other party
               prior to transmitting a packet. This is more of a problem with long sampling
               intervals, which might be similar in duration to the lifetime of entries in the
               ARP caches of the machines.

               In order to avoid this problem, the presend option can be used. It takes a single
               integer argument, which is the smallest polling interval for which an extra pair
               of NTP packets will be exchanged between the client and the server prior to the
               actual measurement. For example, with the following option included in a server
               directive:

                   presend 9

               when the polling interval is 512 seconds or more, an extra NTP client packet will
               be sent to the server a short time (2 seconds) before making the actual
               measurement.

               If the presend option is used together with the xleave option, chronyd will send
               two extra packets instead of one.

           minstratum stratum
               When the synchronisation source is selected from available sources, sources with
               lower stratum are normally slightly preferred. This option can be used to increase
               stratum of the source to the specified minimum, so chronyd will avoid selecting
               that source. This is useful with low-stratum sources that are known to be
               unreliable or inaccurate and which should be used only when other sources are
               unreachable.

           version version
               This option sets the NTP version of packets sent to the server. This can be useful
               when the server runs an old NTP implementation that does not respond to requests
               using a newer version. The default version depends on other options. If the
               extfield or xleave option is used, the default version is 4. If those options are
               not used and the key option specifies a key using a hash function with output size
               longer than 160 bits (e.g. SHA256), the default version is 3 for compatibility
               with older chronyd servers. In other cases, the default version is 4.

           copy
               This option specifies that the server and client are closely related, their
               configuration does not allow a synchronisation loop to form between them, and the
               client is allowed to assume the reference ID and stratum of the server. This is
               useful when multiple instances of chronyd are running on one computer (e.g. for
               security or performance reasons), one primarily operating as a client to
               synchronise the system clock and other instances started with the -x option to
               operate as NTP servers for other computers with their NTP clocks synchronised to
               the first instance.

           extfield type
               This option enables an NTPv4 extension field specified by its type as a
               hexadecimal number. It will be included in requests sent to the server and
               processed in received responses if the server supports it. Note that some server
               implementations do not respond to requests containing an unknown extension field
               (chronyd as a server responded to such requests since version 2.0).

               The following extension field can be enabled by this option:

               F323
                   This is an experimental extension field for some improvements that were
                   proposed for the next version of the NTP protocol (NTPv5). The field contains
                   root delay and dispersion in higher resolution and a monotonic receive
                   timestamp, which enables a frequency transfer between the server and client.
                   It can significantly improve stability of the synchronization. Generally, it
                   should be expected to work only between servers and clients running the same
                   version of chronyd.

       pool name [option]...
           The syntax of this directive is similar to that for the server directive, except that
           it is used to specify a pool of NTP servers rather than a single NTP server. The pool
           name is expected to resolve to multiple addresses which might change over time.

           This directive can be used multiple times to specify multiple pools.

           All options valid in the server directive can be used in this directive too. There is
           one option specific to the pool directive:

           maxsources sources
               This option sets the desired number of sources to be used from the pool. chronyd
               will repeatedly try to resolve the name until it gets this number of sources
               responding to requests. The default value is 4 and the maximum value is 16.

           When an NTP source is unreachable, marked as a falseticker, or has a distance larger
           than the limit set by the maxdistance directive, chronyd will try to replace the
           source with a newly resolved address of the name.

           An example of the pool directive is

               pool pool.ntp.org iburst maxsources 3

       peer hostname [option]...
           The syntax of this directive is identical to that for the server directive, except
           that it specifies a symmetric association with an NTP peer instead of a client/server
           association with an NTP server. A single symmetric association allows the peers to be
           both servers and clients to each other. This is mainly useful when the NTP
           implementation of the peer (e.g. ntpd) supports ephemeral symmetric associations and
           does not need to be configured with an address of this host. chronyd does not support
           ephemeral associations.

           This directive can be used multiple times to specify multiple peers.

           The following options of the server directive do not work in the peer directive:
           iburst, burst, nts, presend, copy.

           When using the xleave option, both peers must support and have enabled the interleaved
           mode, otherwise the synchronisation will work in one direction only. When a key is
           specified by the key option to enable authentication, both peers must use the same key
           and the same key number.

           Note that the symmetric mode is less secure than the client/server mode. A
           denial-of-service attack is possible on unauthenticated symmetric associations, i.e.
           when the peer was specified without the key option. An attacker who does not see
           network traffic between two hosts, but knows that they are peering with each other,
           can periodically send them unauthenticated packets with spoofed source addresses in
           order to disrupt their NTP state and prevent them from synchronising to each other.
           When the association is authenticated, an attacker who does see the network traffic,
           but cannot prevent the packets from reaching the other host, can still disrupt the
           state by replaying old packets. The attacker has effectively the same power as a
           man-in-the-middle attacker. A partial protection against this attack is implemented in
           chronyd, which can protect the peers if they are using the same polling interval and
           they never sent an authenticated packet with a timestamp from future, but it should
           not be relied on as it is difficult to ensure the conditions are met. If two hosts
           should be able to synchronise to each other in both directions, it is recommended to
           use two separate client/server associations (specified by the server directive on both
           hosts) instead.

       initstepslew step-threshold [hostname]...
           (This directive is deprecated in favour of the makestep directive.)

           The purpose of the initstepslew directive is to allow chronyd to make a rapid
           measurement of the system clock error at boot time, and to correct the system clock by
           stepping before normal operation begins. Since this would normally be performed only
           at an appropriate point in the system boot sequence, no other software should be
           adversely affected by the step.

           If the correction required is less than a specified threshold, a slew is used instead.
           This makes it safer to restart chronyd whilst the system is in normal operation.

           The initstepslew directive takes a threshold and a list of NTP servers as arguments.
           Each of the servers is rapidly polled several times, and a majority voting mechanism
           used to find the most likely range of system clock error that is present. A step or
           slew is applied to the system clock to correct this error. chronyd then enters its
           normal operating mode.

           An example of the use of the directive is:

               initstepslew 30 foo.example.net bar.example.net baz.example.net

           where 3 NTP servers are used to make the measurement. The 30 indicates that if the
           system’s error is found to be 30 seconds or less, a slew will be used to correct it;
           if the error is above 30 seconds, a step will be used.

           The initstepslew directive can also be used in an isolated LAN environment, where the
           clocks are set manually. The most stable computer is chosen as the primary server and
           the other computers are its clients. If each of the clients is configured with the
           local directive, the server can be set up with an initstepslew directive which
           references some or all of the clients. Then, if the server machine has to be rebooted,
           the clients can be relied on to act analogously to a flywheel and preserve the time
           for a short period while the server completes its reboot.

           The initstepslew directive is functionally similar to a combination of the makestep
           and server directives with the iburst option. The main difference is that the
           initstepslew servers are used only before normal operation begins and that the
           foreground chronyd process waits for initstepslew to finish before exiting. This
           prevent programs started in the boot sequence after chronyd from reading the clock
           before it has been stepped. With the makestep directive, the waitsync command of
           chronyc can be used instead.

       refclock driver parameter[:option]... [option]...
           The refclock directive specifies a hardware reference clock to be used as a time
           source. It has two mandatory parameters, a driver name and a driver-specific
           parameter. The two parameters are followed by zero or more refclock options. Some
           drivers have special options, which can be appended to the driver-specific parameter
           using the : character.

           This directive can be used multiple times to specify multiple reference clocks.

           There are four drivers included in chronyd:

           PPS
               Driver for the kernel PPS (pulse per second) API. The parameter is the path to the
               PPS device (typically /dev/pps?). As PPS refclocks do not supply full time,
               another time source (e.g. NTP server or non-PPS refclock) is needed to complete
               samples from the PPS refclock. An alternative is to enable the local directive to
               allow synchronisation with some unknown but constant offset. The driver supports
               the following option:

               clear
                   By default, the PPS refclock uses assert events (rising edge) for
                   synchronisation. With this option, it will use clear events (falling edge)
                   instead.

               Examples:

                   refclock PPS /dev/pps0 lock NMEA refid GPS
                   refclock SHM 0 offset 0.5 delay 0.2 refid NMEA noselect
                   refclock PPS /dev/pps1:clear refid GPS2

           SHM
               NTP shared memory driver. This driver uses a shared memory segment to receive
               samples from another process (e.g. gpsd). The parameter is the number of the
               shared memory segment, typically a small number like 0, 1, 2, or 3. The driver
               supports the following option:

               perm=mode
                   This option specifies the permissions of the shared memory segment created by
                   chronyd. They are specified as a numeric mode. The default value is 0600
                   (read-write access for owner only).

               Examples:

                   refclock SHM 0 poll 3 refid GPS1
                   refclock SHM 1:perm=0644 refid GPS2

           SOCK
               Unix domain socket driver. It is similar to the SHM driver, but samples are
               received from a Unix domain socket instead of shared memory and the messages have
               a different format. The parameter is the path to the socket, which chronyd creates
               on start. An advantage over the SHM driver is that SOCK does not require polling
               and it can receive PPS samples with incomplete time. The format of the messages is
               described in the refclock_sock.c file in the chrony source code.

               An application which supports the SOCK protocol is the gpsd daemon. The path where
               gpsd expects the socket to be created is described in the gpsd(8) man page. For
               example:

                   refclock SOCK /var/run/chrony.ttyS0.sock

           PHC
               PTP hardware clock (PHC) driver. The parameter is the path to the device of the
               PTP clock which should be used as a time source. If the clock is kept in TAI
               instead of UTC (e.g. it is synchronised by a PTP daemon), the current UTC-TAI
               offset needs to be specified by the offset option. Alternatively, the pps refclock
               option can be enabled to treat the PHC as a PPS refclock, using only the
               sub-second offset for synchronisation. The driver supports the following options:

               nocrossts
                   This option disables use of precise cross timestamping.

               extpps
                   This option enables a PPS mode in which the PTP clock is timestamping pulses
                   of an external PPS signal connected to the clock. The clock does not need to
                   be synchronised, but another time source is needed to complete the PPS
                   samples. Note that some PTP clocks cannot be configured to timestamp only
                   assert or clear events, and it is necessary to use the width option to filter
                   wrong PPS samples.

               pin=index
                   This option specifies the index of the pin to which is connected the PPS
                   signal. The default value is 0.

               channel=index
                   This option specifies the index of the channel for the PPS mode. The default
                   value is 0.

               clear
                   This option enables timestamping of clear events (falling edge) instead of
                   assert events (rising edge) in the PPS mode. This may not work with some
                   clocks.

               Examples:

                   refclock PHC /dev/ptp0 poll 0 dpoll -2 offset -37
                   refclock PHC /dev/ptp1:nocrossts poll 3 pps
                   refclock PHC /dev/ptp2:extpps:pin=1 width 0.2 poll 2

           The refclock directive supports the following options:

           poll poll
               Timestamps produced by refclock drivers are not used immediately, but they are
               stored and processed by a median filter in the polling interval specified by this
               option. This is defined as a power of 2 and can be negative to specify a
               sub-second interval. The default is 4 (16 seconds). A shorter interval allows
               chronyd to react faster to changes in the frequency of the system clock, but it
               might have a negative effect on its accuracy if the samples have a lot of jitter.

           dpoll dpoll
               Some drivers do not listen for external events and try to produce samples in their
               own polling interval. This is defined as a power of 2 and can be negative to
               specify a sub-second interval. The default is 0 (1 second).

           refid refid
               This option is used to specify the reference ID of the refclock, as up to four
               ASCII characters. The default reference ID is composed from the first three
               characters of the driver name and the number of the refclock. Each refclock must
               have a unique reference ID.

           lock refid
               This option can be used to lock a PPS refclock to another refclock, which is
               specified by its reference ID. In this mode received PPS samples are paired
               directly with raw samples from the specified refclock.

           rate rate
               This option sets the rate of the pulses in the PPS signal (in Hz). This option
               controls how the pulses will be completed with real time. To actually receive more
               than one pulse per second, a negative dpoll has to be specified (-3 for a 5Hz
               signal). The default is 1.

           maxlockage pulses
               This option specifies in number of pulses how old can be samples from the refclock
               specified by the lock option to be paired with the pulses. Increasing this value
               is useful when the samples are produced at a lower rate than the pulses. The
               default is 2.

           width width
               This option specifies the width of the pulses (in seconds). It is used to filter
               PPS samples when the driver provides samples for both rising and falling edges.
               Note that it reduces the maximum allowed error of the time source which completes
               the PPS samples. If the duty cycle is configurable, 50% should be preferred in
               order to maximise the allowed error.

           pps
               This options forces chronyd to treat any refclock (e.g. SHM or PHC) as a PPS
               refclock. This can be useful when the refclock provides time with a variable
               offset of a whole number of seconds (e.g. it uses TAI instead of UTC). Another
               time source is needed to complete samples from the refclock.

           offset offset
               This option can be used to compensate for a constant error. The specified offset
               (in seconds) is applied to all samples produced by the reference clock. The
               default is 0.0.

           delay delay
               This option sets the NTP delay of the source (in seconds). Half of this value is
               included in the maximum assumed error which is used in the source selection
               algorithm. Increasing the delay is useful to avoid having no majority in the
               source selection or to make it prefer other sources. The default is 1e-9 (1
               nanosecond).

           stratum stratum
               This option sets the NTP stratum of the refclock. This can be useful when the
               refclock provides time with a stratum other than 0. The default is 0.

           precision precision
               This option sets the precision of the reference clock (in seconds). The default
               value is the estimated precision of the system clock.

           maxdispersion dispersion
               Maximum allowed dispersion for filtered samples (in seconds). Samples with larger
               estimated dispersion are ignored. By default, this limit is disabled.

           filter samples
               This option sets the length of the median filter which is used to reduce the noise
               in the measurements. With each poll about 40 percent of the stored samples are
               discarded and one final sample is calculated as an average of the remaining
               samples. If the length is 4 or more, at least 4 samples have to be collected
               between polls. For lengths below 4, the filter has to be full. The default is 64.

           prefer
               Prefer this source over sources without the prefer option.

           noselect
               Never select this source. This is useful for monitoring or with sources which are
               not very accurate, but are locked with a PPS refclock.

           trust
               Assume time from this source is always true. It can be rejected as a falseticker
               in the source selection only if another source with this option does not agree
               with it.

           require
               Require that at least one of the sources specified with this option is selectable
               (i.e. recently reachable and not a falseticker) before updating the clock.
               Together with the trust option this can be useful to allow a trusted, but not very
               precise, reference clock to be safely combined with unauthenticated NTP sources in
               order to improve the accuracy of the clock. They can be selected and used for
               synchronisation only if they agree with the trusted and required source.

           tai
               This option indicates that the reference clock keeps time in TAI instead of UTC
               and that chronyd should correct its offset by the current TAI-UTC offset. The
               leapsectz directive must be used with this option and the database must be kept up
               to date in order for this correction to work as expected. This option does not
               make sense with PPS refclocks.

           minsamples samples
               Set the minimum number of samples kept for this source. This overrides the
               minsamples directive.

           maxsamples samples
               Set the maximum number of samples kept for this source. This overrides the
               maxsamples directive.

       manual
           The manual directive enables support at run-time for the settime command in chronyc.
           If no manual directive is included, any attempt to use the settime command in chronyc
           will be met with an error message.

           Note that the settime command can be enabled at run-time using the manual command in
           chronyc. (The idea of the two commands is that the manual command controls the manual
           clock driver’s behaviour, whereas the settime command allows samples of manually
           entered time to be provided.)

       acquisitionport port
           By default, chronyd as an NTP client opens a new socket for each request with the
           source port chosen randomly by the operating system. The acquisitionport directive can
           be used to specify the source port and use only one socket (per IPv4 or IPv6 address
           family) for all configured servers. This can be useful for getting through some
           firewalls. It should not be used if not necessary as there is a small impact on
           security of the client. If set to 0, the source port of the permanent socket will be
           chosen randomly by the operating system.

           It can be set to the same port as is used by the NTP server (which can be configured
           with the port directive) to use only one socket for all NTP packets.

           An example of the acquisitionport directive is:

               acquisitionport 1123

           This would change the source port used for client requests to UDP port 1123. You could
           then persuade the firewall administrator to open that port.

       bindacqaddress address
           The bindacqaddress directive specifies a local IP address to which chronyd will bind
           its NTP and NTS-KE client sockets. The syntax is similar to the bindaddress and
           bindcmdaddress directives.

           For each of the IPv4 and IPv6 protocols, only one bindacqaddress directive can be
           specified.

       bindacqdevice interface
           The bindacqdevice directive binds the client sockets to a network device specified by
           the interface name. This can be useful when the local address is dynamic, or to enable
           an NTP source specified with a link-local IPv6 address. This directive can specify
           only one interface and it is supported on Linux only.

           An example of the directive is:

               bindacqdevice eth0

       dscp point
           The dscp directive sets the Differentiated Services Code Point (DSCP) in transmitted
           NTP packets to the specified value. It can improve stability of NTP measurements in
           local networks where switches or routers are configured to prioritise forwarding of
           packets with specific DSCP values. The default value is 0 and the maximum value is 63.

           An example of the directive (setting the Expedited Forwarding class) is:

               dscp 46

       dumpdir directory
           To compute the rate of gain or loss of time, chronyd has to store a measurement
           history for each of the time sources it uses.

           All supported systems, with the exception of macOS 10.12 and earlier, have operating
           system support for setting the rate of gain or loss to compensate for known errors.
           (On macOS 10.12 and earlier, chronyd must simulate such a capability by periodically
           slewing the system clock forwards or backwards by a suitable amount to compensate for
           the error built up since the previous slew.)

           For such systems, it is possible to save the measurement history across restarts of
           chronyd (assuming no changes are made to the system clock behaviour whilst it is not
           running). The dumpdir directive defines the directory where the measurement histories
           are saved when chronyd exits, or the dump command in chronyc is issued.

           If the directory does not exist, it will be created automatically.

           The -r option of chronyd enables loading of the dump files on start. All dump files
           found in the directory will be removed after start, even if the -r option is not
           present.

           An example of the directive is:

               dumpdir /run/chrony

           A source whose IP address is 1.2.3.4 would have its measurement history saved in the
           file /run/chrony/1.2.3.4.dat. History of reference clocks is saved to files named by
           their reference ID in form of refid:XXXXXXXX.dat.

       maxsamples samples
           The maxsamples directive sets the default maximum number of samples that chronyd
           should keep for each source. This setting can be overridden for individual sources in
           the server and refclock directives. The default value is 0, which disables the
           configurable limit. The useful range is 4 to 64.

           As a special case, setting maxsamples to 1 disables frequency tracking in order to
           make the sources immediately selectable with only one sample. This can be useful when
           chronyd is started with the -q or -Q option.

       minsamples samples
           The minsamples directive sets the default minimum number of samples that chronyd
           should keep for each source. This setting can be overridden for individual sources in
           the server and refclock directives. The default value is 6. The useful range is 4 to
           64.

           Forcing chronyd to keep more samples than it would normally keep reduces noise in the
           estimated frequency and offset, but slows down the response to changes in the
           frequency and offset of the clock. The offsets in the tracking and sourcestats reports
           (and the tracking.log and statistics.log files) may be smaller than the actual
           offsets.

       ntsdumpdir directory
           This directive specifies a directory for the client to save NTS cookies it received
           from the server in order to avoid making an NTS-KE request when chronyd is started
           again. The cookies are saved separately for each NTP source in files named by the IP
           address of the NTS-KE server (e.g. 1.2.3.4.nts). By default, the client does not save
           the cookies.

           If the directory does not exist, it will be created automatically.

           An example of the directive is:

               ntsdumpdir /var/lib/chrony

           This directory is used also by the NTS server to save keys.

       ntsrefresh interval
           This directive specifies the maximum interval between NTS-KE handshakes (in seconds)
           in order to refresh the keys authenticating NTP packets. The default value is 2419200
           (4 weeks) and the maximum value is 2^31-1 (68 years).

       ntstrustedcerts [set-ID] file|directory
           This directive specifies a file or directory containing certificates (in the PEM
           format) of trusted certificate authorities (CA) which can be used to verify
           certificates of NTS servers.

           The optional set-ID argument is a number in the range 0 through 2^32-1, which selects
           the set of certificates where certificates from the specified file or directory are
           added. The default ID is 0, which is a set containing the system’s default trusted CAs
           (unless the nosystemcert directive is present). All other sets are empty by default. A
           set of certificates can be selected for verification of an NTS server by the certset
           option in the server or pool directive.

           This directive can be used multiple times to specify one or more sets of trusted
           certificates, each containing certificates from one or more files and/or directories.

           It is not necessary to restart chronyd in order to reload the certificates if they
           change (e.g. after a renewal).

           An example is:

               ntstrustedcerts /etc/pki/nts/foo.crt
               ntstrustedcerts 1 /etc/pki/nts/bar.crt
               ntstrustedcerts 1 /etc/pki/nts/baz.crt
               ntstrustedcerts 2 /etc/pki/nts/qux.crt

       nosystemcert
           This directive disables the system’s default trusted CAs. Only certificates specified
           by the ntstrustedcerts directive will be trusted.

       nocerttimecheck limit
           This directive disables the checks of the activation and expiration times of
           certificates for the specified number of clock updates. It allows the NTS
           authentication mechanism to be used on computers which start with wrong time (e.g. due
           to not having an RTC or backup battery). Disabling the time checks has important
           security implications and should be used only as a last resort, preferably with a
           minimal number of trusted certificates. The default value is 0, which means the time
           checks are always enabled.

           An example of the directive is:

               nocerttimecheck 1

           This would disable the time checks until the clock is updated for the first time,
           assuming the first update corrects the clock and later checks can work with correct
           time.

   Source selection
       authselectmode mode
           NTP sources can be specified with the key or nts option to enable authentication to
           limit the impact of man-in-the-middle attacks. The attackers can drop or delay NTP
           packets (up to the maxdelay and maxdistance limits), but they cannot modify the
           timestamps contained in the packets. The attack can cause only a limited slew or step,
           and also cause the clock to run faster or slower than real time (up to double of the
           maxdrift limit).

           When authentication is enabled for an NTP source, it is important to disable
           unauthenticated NTP sources which could be exploited in the attack, e.g. if they are
           not reachable only over a trusted network. Alternatively, the source selection can be
           configured with the require and trust options to synchronise to the unauthenticated
           sources only if they agree with the authenticated sources and might have a positive
           impact on the accuracy of the clock. Note that in this case the impact of the attack
           is higher. The attackers cannot cause an arbitrarily large step or slew, but they have
           more control over the frequency of the clock and can cause chronyd to report false
           information, e.g. a significantly smaller root delay and dispersion.

           This directive determines the default selection options for authenticated and
           unauthenticated sources in order to simplify the configuration with the configuration
           file and chronyc commands. It sets a policy for authentication.

           Sources specified with the noselect option are ignored (not counted as either
           authenticated or unauthenticated), and they always have only the selection options
           specified in the configuration.

           There are four modes:

           require
               Authentication is strictly required for NTP sources in this mode. If any
               unauthenticated NTP sources are specified, they will automatically get the
               noselect option to prevent them from being selected for synchronisation.

           prefer
               In this mode, authentication is optional and preferred. If it is enabled for at
               least one NTP source, all unauthenticated NTP sources will get the noselect
               option.

           mix
               In this mode, authentication is optional and synchronisation to a mix of
               authenticated and unauthenticated NTP sources is allowed. If both authenticated
               and unauthenticated NTP sources are specified, all authenticated NTP sources and
               reference clocks will get the require and trust options to prevent synchronisation
               to unauthenticated NTP sources if they do not agree with a majority of the
               authenticated sources and reference clocks. This is the default mode.

           ignore
               In this mode, authentication is ignored in the source selection. All sources will
               have only the selection options that were specified in the configuration file, or
               chronyc command. This was the behaviour of chronyd in versions before 4.0.

           As an example, the following configuration using the default mix mode:

               server foo.example.net nts
               server bar.example.net nts
               server baz.example.net
               refclock SHM 0

           is equivalent to the following configuration using the ignore mode:

               authselectmode ignore
               server foo.example.net nts require trust
               server bar.example.net nts require trust
               server baz.example.net
               refclock SHM 0 require trust

       combinelimit limit
           When chronyd has multiple sources available for synchronisation, it has to select one
           source as the synchronisation source. The measured offsets and frequencies of the
           system clock relative to the other sources, however, can be combined with the selected
           source to improve the accuracy of the system clock.

           The combinelimit directive limits which sources are included in the combining
           algorithm. Their synchronisation distance has to be shorter than the distance of the
           selected source multiplied by the value of the limit. Also, their measured frequencies
           have to be close to the frequency of the selected source. If the selected source was
           specified with the prefer option, it can be combined only with other sources specified
           with this option.

           By default, the limit is 3. Setting the limit to 0 effectively disables the source
           combining algorithm and only the selected source will be used to control the system
           clock.

       maxdistance distance
           The maxdistance directive sets the maximum root distance of a source to be acceptable
           for synchronisation of the clock. Sources that have a distance larger than the
           specified distance will be rejected. The distance estimates the maximum error of the
           source. It includes the root dispersion and half of the root delay (round-trip time)
           accumulated on the path to the primary source.

           By default, the maximum root distance is 3 seconds.

           Setting maxdistance to a larger value can be useful to allow synchronisation with a
           server that only has a very infrequent connection to its sources and can accumulate a
           large dispersion between updates of its clock.

       maxjitter jitter
           The maxjitter directive sets the maximum allowed jitter of the sources to not be
           rejected by the source selection algorithm. This prevents synchronisation with sources
           that have a small root distance, but their time is too variable.

           By default, the maximum jitter is 1 second.

       minsources sources
           The minsources directive sets the minimum number of sources that need to be considered
           as selectable in the source selection algorithm before the local clock is updated. The
           default value is 1.

           Setting this option to a larger number can be used to improve the reliability. More
           sources will have to agree with each other and the clock will not be updated when only
           one source (which could be serving incorrect time) is reachable.

       reselectdist distance
           When chronyd selects a synchronisation source from available sources, it will prefer
           the one with the shortest synchronisation distance. However, to avoid frequent
           reselecting when there are sources with similar distance, a fixed distance is added to
           the distance for sources that are currently not selected. This can be set with the
           reselectdist directive. By default, the distance is 100 microseconds.

       stratumweight distance
           The stratumweight directive sets how much distance should be added per stratum to the
           synchronisation distance when chronyd selects the synchronisation source from
           available sources.

           By default, the weight is 0.001 seconds. This means that the stratum of the sources in
           the selection process matters only when the differences between the distances are in
           milliseconds.

   System clock
       clockprecision precision
           The clockprecision directive specifies the precision of the system clock (in seconds).
           It is used by chronyd to estimate the minimum noise in NTP measurements and randomise
           low-order bits of timestamps in NTP responses. By default, the precision is measured
           on start as the minimum time to read the clock.

           The measured value works well in most cases. However, it generally overestimates the
           precision and it can be sensitive to the CPU speed, which can change over time to save
           power. In some cases with a high-precision clocksource (e.g. the Time Stamp Counter of
           the CPU) and hardware timestamping, setting the precision on the server to a smaller
           value can improve stability of clients' NTP measurements. The server’s precision is
           reported on clients by the ntpdata command.

           An example setting the precision to 8 nanoseconds is:

               clockprecision 8e-9

       corrtimeratio ratio
           When chronyd is slewing the system clock to correct an offset, the rate at which it is
           slewing adds to the frequency error of the clock. On all supported systems, with the
           exception of macOS 12 and earlier, this rate can be controlled.

           The corrtimeratio directive sets the ratio between the duration in which the clock is
           slewed for an average correction according to the source history and the interval in
           which the corrections are done (usually the NTP polling interval). Corrections larger
           than the average take less time and smaller corrections take more time, the amount of
           the correction and the correction time are inversely proportional.

           Increasing corrtimeratio improves the overall frequency error of the system clock, but
           increases the overall time error as the corrections take longer.

           By default, the ratio is set to 3, the time accuracy of the clock is preferred over
           its frequency accuracy.

           The maximum allowed slew rate can be set by the maxslewrate directive. The current
           remaining correction is shown in the tracking report as the System time value.

       driftfile file
           One of the main activities of the chronyd program is to work out the rate at which the
           system clock gains or loses time relative to real time.

           Whenever chronyd computes a new value of the gain or loss rate, it is desirable to
           record it somewhere. This allows chronyd to begin compensating the system clock at
           that rate whenever it is restarted, even before it has had a chance to obtain an
           equally good estimate of the rate during the new run. (This process can take many
           minutes, at least.)

           The driftfile directive allows a file to be specified into which chronyd can store the
           rate information. Two parameters are recorded in the file. The first is the rate at
           which the system clock gains or loses time, expressed in parts per million, with gains
           positive. Therefore, a value of 100.0 indicates that when the system clock has
           advanced by a second, it has gained 100 microseconds in reality (so the true time has
           only advanced by 999900 microseconds). The second is an estimate of the error bound
           around the first value in which the true rate actually lies.

           An example of the driftfile directive is:

               driftfile /var/lib/chrony/drift

       fallbackdrift min-interval max-interval
           Fallback drifts are long-term averages of the system clock drift calculated over
           exponentially increasing intervals. They are used to avoid quickly drifting away from
           true time when the clock was not updated for a longer period of time and there was a
           short-term deviation in the drift before the updates stopped.

           The directive specifies the minimum and maximum interval since the last clock update
           to switch between fallback drifts. They are defined as a power of 2 (in seconds). The
           syntax is as follows:

               fallbackdrift 16 19

           In this example, the minimum interval is 16 (18 hours) and the maximum interval is 19
           (6 days). The system clock frequency will be set to the first fallback 18 hours after
           last clock update, to the second after 36 hours, and so on. This might be a good
           setting to cover frequency changes due to daily and weekly temperature fluctuations.
           When the frequency is set to a fallback, the state of the clock will change to ‘Not
           synchronised’.

           By default (or if the specified maximum or minimum is 0), no fallbacks are used and
           the clock frequency changes only with new measurements from NTP sources, reference
           clocks, or manual input.

       leapsecmode mode
           A leap second is an adjustment that is occasionally applied to UTC to keep it close to
           the mean solar time. When a leap second is inserted, the last day of June or December
           has an extra second 23:59:60.

           For computer clocks that is a problem. The Unix time is defined as number of seconds
           since 00:00:00 UTC on 1 January 1970 without leap seconds. The system clock cannot
           have time 23:59:60, every minute has 60 seconds and every day has 86400 seconds by
           definition. The inserted leap second is skipped and the clock is suddenly ahead of UTC
           by one second. The leapsecmode directive selects how that error is corrected. There
           are four options:

           system
               When inserting a leap second, the kernel steps the system clock backwards by one
               second when the clock gets to 00:00:00 UTC. When deleting a leap second, it steps
               forward by one second when the clock gets to 23:59:59 UTC. This is the default
               mode when the system driver supports leap seconds (i.e. all supported systems with
               the exception of macOS 12 and earlier).

           step
               This is similar to the system mode, except the clock is stepped by chronyd instead
               of the kernel. It can be useful to avoid bugs in the kernel code that would be
               executed in the system mode. This is the default mode when the system driver does
               not support leap seconds.

           slew
               The clock is corrected by slewing started at 00:00:00 UTC when a leap second is
               inserted or 23:59:59 UTC when a leap second is deleted. This might be preferred
               over the system and step modes when applications running on the system are
               sensitive to jumps in the system time and it is acceptable that the clock will be
               off for a longer time. On Linux with the default maxslewrate value the correction
               takes 12 seconds.

           ignore
               No correction is applied to the clock for the leap second. The clock will be
               corrected later in normal operation when new measurements are made and the
               estimated offset includes the one second error. This option is particularly useful
               when multiple chronyd instances are running on the system, one controlling the
               system clock and others started with the -x option, which should rely on the first
               instance to correct the system clock and ignore it for the correction of their own
               NTP clock running on top of the system clock.

           When serving time to NTP clients that cannot be configured to correct their clocks for
           a leap second by slewing, or to clients that would correct at slightly different rates
           when it is necessary to keep them close together, the slew mode can be combined with
           the smoothtime directive to enable a server leap smear.

           When smearing a leap second, the leap status is suppressed on the server and the
           served time is corrected slowly by slewing instead of stepping. The clients do not
           need any special configuration as they do not know there is any leap second and they
           follow the server time which eventually brings them back to UTC. Care must be taken to
           ensure they use only NTP servers which smear the leap second in exactly the same way
           for synchronisation.

           This feature must be used carefully, because the server is intentionally not serving
           its best estimate of the true time.

           A recommended configuration to enable a server leap smear is:

               leapsecmode slew
               maxslewrate 1000
               smoothtime 400 0.001024 leaponly

           The first directive is necessary to disable the clock step which would reset the
           smoothing process. The second directive limits the slewing rate of the local clock to
           1000 ppm, which improves the stability of the smoothing process when the local
           correction starts and ends. The third directive enables the server time smoothing
           process. It will start when the clock gets to 00:00:00 UTC and it will take 62500
           seconds (about 17.36 hours) to finish. The frequency offset will be changing by
           0.001024 ppm per second and will reach a maximum of 32 ppm in 31250 seconds. The
           leaponly option makes the duration of the leap smear constant and allows the clients
           to safely synchronise with multiple identically configured leap smearing servers.

           The duration of the leap smear can be calculated from the specified wander as

               duration = sqrt(4 / wander)

       leapsectz timezone
           This directive specifies a timezone in the system timezone database which chronyd can
           use to determine when will the next leap second occur and what is the current offset
           between TAI and UTC. It will periodically check if 23:59:59 and 23:59:60 are valid
           times in the timezone. This normally works with the right/UTC timezone.

           When a leap second is announced, the timezone needs to be updated at least 12 hours
           before the leap second. It is not necessary to restart chronyd.

           This directive is useful with reference clocks and other time sources which do not
           announce leap seconds, or announce them too late for an NTP server to forward them to
           its own clients. Clients of leap smearing servers must not use this directive.

           It is also useful when the system clock is required to have correct TAI-UTC offset.
           Note that the offset is set only when leap seconds are handled by the kernel, i.e.
           leapsecmode is set to system.

           The specified timezone is not used as an exclusive source of information about leap
           seconds. If a majority of time sources announce on the last day of June or December
           that a leap second should be inserted or deleted, it will be accepted even if it is
           not included in the timezone.

           An example of the directive is:

               leapsectz right/UTC

           The following shell command verifies that the timezone contains leap seconds and can
           be used with this directive:

               $ TZ=right/UTC date -d 'Dec 31 2008 23:59:60'
               Wed Dec 31 23:59:60 UTC 2008

       makestep threshold limit
           Normally chronyd will cause the system to gradually correct any time offset, by
           slowing down or speeding up the clock as required. In certain situations, e.g. when
           chronyd is initially started, the system clock might be so far adrift that this
           slewing process would take a very long time to correct the system clock.

           This directive forces chronyd to step the system clock if the adjustment is larger
           than a threshold value, but only if there were no more clock updates since chronyd was
           started than the specified limit. A negative value disables the limit.

           On most systems it is desirable to step the system clock only on boot, before starting
           programs that rely on time advancing monotonically forwards.

           An example of the use of this directive is:

               makestep 0.1 3

           This would step the system clock if the adjustment is larger than 0.1 seconds, but
           only in the first three clock updates.

       maxchange offset start ignore
           This directive sets the maximum allowed offset corrected on a clock update. The check
           is performed only after the specified number of updates to allow a large initial
           adjustment of the system clock. When an offset larger than the specified maximum
           occurs, it will be ignored for the specified number of times and then chronyd will
           give up and exit (a negative value can be used to never exit). In both cases a message
           is sent to syslog.

           An example of the use of this directive is:

               maxchange 1000 1 2

           After the first clock update, chronyd will check the offset on every clock update, it
           will ignore two adjustments larger than 1000 seconds and exit on another one.

       maxclockerror error-in-ppm
           The maxclockerror directive sets the maximum assumed frequency error that the system
           clock can gain on its own between clock updates. It describes the stability of the
           clock.

           By default, the maximum error is 1 ppm.

           Typical values for error-in-ppm might be 10 for a low quality clock and 0.1 for a high
           quality clock using a temperature compensated crystal oscillator.

       maxdrift drift-in-ppm
           This directive specifies the maximum assumed drift (frequency error) of the system
           clock. It limits the frequency adjustment that chronyd is allowed to use to correct
           the measured drift. It is an additional limit to the maximum adjustment that can be
           set by the system driver (100000 ppm on Linux, 500 ppm on FreeBSD, NetBSD, and macOS
           10.13+, 32500 ppm on illumos).

           By default, the maximum assumed drift is 500000 ppm, i.e. the adjustment is limited by
           the system driver rather than this directive.

       maxupdateskew skew-in-ppm
           One of chronyd's tasks is to work out how fast or slow the computer’s clock runs
           relative to its reference sources. In addition, it computes an estimate of the error
           bounds around the estimated value.

           If the range of error is too large, it probably indicates that the measurements have
           not settled down yet, and that the estimated gain or loss rate is not very reliable.

           The maxupdateskew directive sets the threshold for determining whether an estimate
           might be so unreliable that it should not be used. By default, the threshold is 1000
           ppm.

           Typical values for skew-in-ppm might be 100 for NTP sources polled over a wireless
           network, and 10 or smaller for sources on a local wired network.

           It should be noted that this is not the only means of protection against using
           unreliable estimates. At all times, chronyd keeps track of both the estimated gain or
           loss rate, and the error bound on the estimate. When a new estimate is generated
           following another measurement from one of the sources, a weighted combination
           algorithm is used to update the master estimate. So if chronyd has an existing
           highly-reliable master estimate and a new estimate is generated which has large error
           bounds, the existing master estimate will dominate in the new master estimate.

       maxslewrate rate-in-ppm
           The maxslewrate directive sets the maximum rate at which chronyd is allowed to slew
           the time. It limits the slew rate controlled by the correction time ratio (which can
           be set by the corrtimeratio directive) and is effective only on systems where chronyd
           is able to control the rate (i.e. all supported systems with the exception of macOS 12
           or earlier).

           For each system there is a maximum frequency offset of the clock that can be set by
           the driver. On Linux it is 100000 ppm, on FreeBSD, NetBSD and macOS 10.13+ it is 5000
           ppm, and on illumos it is 32500 ppm. Also, due to a kernel limitation, setting
           maxslewrate on FreeBSD, NetBSD, macOS 10.13+ to a value between 500 ppm and 5000 ppm
           will effectively set it to 500 ppm.

           By default, the maximum slew rate is set to 83333.333 ppm (one twelfth).

       tempcomp file interval T0 k0 k1 k2, tempcomp file interval points-file
           Normally, changes in the rate of drift of the system clock are caused mainly by
           changes in the temperature of the crystal oscillator on the motherboard.

           If there are temperature measurements available from a sensor close to the oscillator,
           the tempcomp directive can be used to compensate for the changes in the temperature
           and improve the stability and accuracy of the clock.

           The result depends on many factors, including the resolution of the sensor, the amount
           of noise in the measurements, the polling interval of the time source, the
           compensation update interval, how well the compensation is specified, and how close
           the sensor is to the oscillator. When it is working well, the frequency reported in
           the tracking.log file is more stable and the maximum reached offset is smaller.

           There are two forms of the directive. The first one has six parameters: a path to the
           file containing the current temperature from the sensor (in text format), the
           compensation update interval (in seconds), and temperature coefficients T0, k0, k1,
           k2.

           The frequency compensation is calculated (in ppm) as

               comp = k0 + (T - T0) * k1 + (T - T0)^2 * k2

           The result has to be between -10 ppm and 10 ppm, otherwise the measurement is
           considered invalid and will be ignored. The k0 coefficient can be adjusted to keep the
           compensation in that range.

           An example of the use is:

               tempcomp /sys/class/hwmon/hwmon0/temp2_input 30 26000 0.0 0.000183 0.0

           The measured temperature will be read from the file in the Linux sysfs filesystem
           every 30 seconds. When the temperature is 26000 (26 degrees Celsius), the frequency
           correction will be zero. When it is 27000 (27 degrees Celsius), the clock will be set
           to run faster by 0.183 ppm, etc.

           The second form has three parameters: the path to the sensor file, the update
           interval, and a path to a file containing a list of (temperature, compensation)
           points, from which the compensation is linearly interpolated or extrapolated.

           An example is:

               tempcomp /sys/class/hwmon/hwmon0/temp2_input 30 /etc/chrony.tempcomp

           where the /etc/chrony.tempcomp file could have

               20000 1.0
               21000 0.64
               22000 0.36
               23000 0.16
               24000 0.04
               25000 0.0
               26000 0.04
               27000 0.16
               28000 0.36
               29000 0.64
               30000 1.0

           Valid measurements with corresponding compensations are logged to the tempcomp.log
           file if enabled by the log tempcomp directive.

   NTP server
       allow [all] [subnet]
           The allow directive is used to designate a particular subnet from which NTP clients
           are allowed to access the computer as an NTP server. It also controls access of NTS-KE
           clients when NTS is enabled on the server.

           The default is that no clients are allowed access, i.e. chronyd operates purely as an
           NTP client. If the allow directive is used, chronyd will be both a client of its
           servers, and a server to other clients.

           This directive can be used multiple times.

           Examples of the use of the directive are as follows:

               allow 1.2.3.4
               allow 3.4.5.0/24
               allow 3.4.5
               allow 2001:db8::/32
               allow 0/0
               allow ::/0
               allow

           The first directive allows access from an IPv4 address. The second directive allows
           access from all computers in an IPv4 subnet specified in the CIDR notation. The third
           directive specifies the same subnet using a simpler notation where the prefix length
           is determined by the number of dots. The fourth directive specifies an IPv6 subnet.
           The fifth and sixth directives allow access from all IPv4 and IPv6 addresses
           respectively. The seventh directive allows access from all addresses (both IPv4 or
           IPv6).

           A second form of the directive, allow all, has a greater effect, depending on the
           ordering of directives in the configuration file. To illustrate the effect, consider
           the two examples:

               allow 1.2.3.4
               deny 1.2.3.0/24
               allow 1.2.0.0/16

           and

               allow 1.2.3.4
               deny 1.2.3.0/24
               allow all 1.2.0.0/16

           In the first example, the effect is the same regardless of what order the three
           directives are given in. So the 1.2.0.0/16 subnet is allowed access, except for the
           1.2.3.0/24 subnet, which is denied access, however the host 1.2.3.4 is allowed access.

           In the second example, the allow all 1.2.0.0/16 directive overrides the effect of any
           previous directive relating to a subnet within the specified subnet. Within a
           configuration file this capability is probably rather moot; however, it is of greater
           use for reconfiguration at run-time via chronyc with the allow all command.

           The rules are internally represented as a tree of tables with one level per four bits
           of the IPv4 or IPv6 address. The order of the allow and deny directives matters if
           they modify the same records of one table, i.e. if one subnet is included in the other
           subnet and their prefix lengths are at the same level. For example, 1.2.3.0/28 and
           1.2.3.0/29 are in different tables, but 1.2.3.0/25 and 1.2.3.0/28 are in the same
           table. The configuration can be verified for individual addresses with the accheck
           command in chronyc.

           A hostname can be specified in the directives instead of the IP address, but the name
           must be resolvable when chronyd is started, i.e. the network is already up and DNS is
           working. If the hostname resolves to multiple addresses, only the first address (in
           the order returned by the system resolver) will be allowed or denied.

           Note, if the initstepslew directive is used in the configuration file, each of the
           computers listed in that directive must allow client access by this computer for it to
           work.

       deny [all] [subnet]
           This is similar to the allow directive, except that it denies NTP and NTS-KE client
           access to a particular subnet or host, rather than allowing it.

           The syntax is identical and the directive can be used multiple times too.

           There is also a deny all directive with similar behaviour to the allow all directive.

       bindaddress address
           The bindaddress directive binds the sockets on which chronyd listens for NTP and
           NTS-KE requests to a local address of the computer. On systems other than Linux, the
           address of the computer needs to be already configured when chronyd is started.

           An example of the use of the directive is:

               bindaddress 192.168.1.1

           Currently, for each of the IPv4 and IPv6 protocols, only one bindaddress directive can
           be specified. Therefore, it is not useful on computers which should serve NTP on
           multiple network interfaces.

       binddevice interface
           The binddevice directive binds the NTP and NTS-KE server sockets to a network device
           specified by the interface name. This directive can specify only one interface and it
           is supported on Linux only.

           An example of the directive is:

               binddevice eth0

       broadcast interval address [port]
           The broadcast directive is used to declare a broadcast address to which chronyd should
           send packets in the NTP broadcast mode (i.e. make chronyd act as a broadcast server).
           Broadcast clients on that subnet will be able to synchronise.

           This directive can be used multiple times to specify multiple addresses.

           The syntax is as follows:

               broadcast 32 192.168.1.255
               broadcast 64 192.168.2.255 12123
               broadcast 64 ff02::101

           In the first example, the destination port defaults to UDP port 123 (the normal NTP
           port). In the second example, the destination port is specified as 12123. The first
           parameter in each case (32 or 64 respectively) is the interval in seconds between
           broadcast packets being sent. The second parameter in each case is the broadcast
           address to send the packet to. This should correspond to the broadcast address of one
           of the network interfaces on the computer where chronyd is running.

           You can have more than 1 broadcast directive if you have more than 1 network interface
           onto which you want to send NTP broadcast packets.

           chronyd itself cannot act as a broadcast client; it must always be configured as a
           point-to-point client by defining specific NTP servers and peers. This broadcast
           server feature is intended for providing a time source to other NTP implementations.

           If ntpd is used as the broadcast client, it will try to measure the round-trip delay
           between the server and client with normal client mode packets. Thus, the broadcast
           subnet should also be the subject of an allow directive.

       clientloglimit limit
           This directive specifies the maximum amount of memory that chronyd is allowed to
           allocate for logging of client accesses and the state that chronyd as an NTP server
           needs to support the interleaved mode for its clients. The default limit is 524288
           bytes, which enables monitoring of up to 4096 IP addresses at the same time and
           holding NTP timestamps for up to 4096 clients using the interleaved mode (depending on
           uniformity of their polling interval). The number of addresses and timestamps is
           always a power of 2. The maximum effective value is 2147483648 (2 GB), which
           corresponds to 16777216 addresses and timestamps.

           An example of the use of this directive is:

               clientloglimit 1048576

       noclientlog
           This directive, which takes no arguments, specifies that client accesses are not to be
           logged. Normally they are logged, allowing statistics to be reported using the clients
           command in chronyc. This option also effectively disables server support for the NTP
           interleaved mode.

       local [option]...
           The local directive enables a local reference mode, which allows chronyd operating as
           an NTP server to appear synchronised to real time (from the viewpoint of clients
           polling it), even when it was never synchronised or the last update of the clock
           happened a long time ago.

           This directive is normally used in an isolated network, where computers are required
           to be synchronised to one another, but not necessarily to real time. The server can be
           kept vaguely in line with real time by manual input.

           The local directive has the following options:

           stratum stratum
               This option sets the stratum of the server which will be reported to clients when
               the local reference is active. The specified value is in the range 1 through 15,
               and the default value is 10. It should be larger than the maximum expected stratum
               in the network when external NTP servers are accessible.

               Stratum 1 indicates a computer that has a true real-time reference directly
               connected to it (e.g. GPS, atomic clock, etc.), such computers are expected to be
               very close to real time. Stratum 2 computers are those which have a stratum 1
               server; stratum 3 computers have a stratum 2 server and so on. A value of 10
               indicates that the clock is so many hops away from a reference clock that its time
               is fairly unreliable.

           distance distance
               This option sets the threshold for the root distance which will activate the local
               reference. If chronyd was synchronised to some source, the local reference will
               not be activated until its root distance reaches the specified value (the rate at
               which the distance is increasing depends on how well the clock was tracking the
               source). The default value is 1 second.

               The current root distance can be calculated from root delay and root dispersion
               (reported by the tracking command in chronyc) as:

                   distance = delay / 2 + dispersion

           orphan
               This option enables a special ‘orphan’ mode, where sources with stratum equal to
               the local stratum are assumed to not serve real time. They are ignored unless no
               other source is selectable and their reference IDs are smaller than the local
               reference ID.

               This allows multiple servers in the network to use the same local configuration
               and to be synchronised to one another, without confusing clients that poll more
               than one server. Each server needs to be configured to poll all other servers with
               the local directive. This ensures only the server with the smallest reference ID
               has the local reference active and others are synchronised to it. If that server
               stops responding, the server with the second smallest reference ID will take over
               when its local reference mode activates (root distance reaches the threshold
               configured by the distance option).

               The orphan mode is compatible with the ntpd's orphan mode (enabled by the tos
               orphan command).

           An example of the directive is:

               local stratum 10 orphan distance 0.1

       ntpsigndsocket directory
           This directive specifies the location of the Samba ntp_signd socket when it is running
           as a Domain Controller (DC). If chronyd is compiled with this feature, responses to
           MS-SNTP clients will be signed by the smbd daemon.

           Note that MS-SNTP requests are not authenticated and any client that is allowed to
           access the server by the allow directive, or the allow command in chronyc, can get an
           MS-SNTP response signed with a trust account’s password and try to crack the password
           in a brute-force attack. Access to the server should be carefully controlled.

           An example of the directive is:

               ntpsigndsocket /var/lib/samba/ntp_signd

       ntsport port
           This directive specifies the TCP port on which chronyd will provide the NTS Key
           Establishment (NTS-KE) service. The default port is 4460.

           The port will be open only when a certificate and key is specified by the
           ntsservercert and ntsserverkey directives.

       ntsservercert file
           This directive specifies a file containing a certificate in the PEM format for chronyd
           to operate as an NTS server. The file should also include any intermediate
           certificates that the clients will need to validate the server’s certificate. The file
           needs to be readable by the user under which chronyd is running after dropping root
           privileges.

           This directive can be used multiple times to specify multiple certificates for
           different names of the server.

           The files are loaded only once. chronyd needs to be restarted in order to load a
           renewed certificate. The ntsdumpdir and dumpdir directives with the -r option of
           chronyd are recommended for a near-seamless server operation.

       ntsserverkey file
           This directive specifies a file containing a private key in the PEM format for chronyd
           to operate as an NTS server. The file needs to be readable by the user under which
           chronyd is running after dropping root privileges. For security reasons, it should not
           be readable by other users.

           This directive can be used multiple times to specify multiple keys. The number of keys
           must be the same as the number of certificates and the corresponding files must be
           specified in the same order.

       ntsprocesses processes
           This directive specifies how many helper processes will chronyd operating as an NTS
           server start for handling client NTS-KE requests in order to improve performance with
           multi-core CPUs and multithreading. If set to 0, no helper process will be started and
           all NTS-KE requests will be handled by the main chronyd process. The default value is
           1.

       maxntsconnections connections
           This directive specifies the maximum number of concurrent NTS-KE connections per
           process that the NTS server will accept. The default value is 100. The maximum
           practical value is half of the system FD_SETSIZE constant (usually 1024).

       ntsdumpdir directory
           This directive specifies a directory where chronyd operating as an NTS server can save
           the keys which encrypt NTS cookies provided to clients. The keys are saved to a single
           file named ntskeys. When chronyd is restarted, reloading the keys allows the clients
           to continue using old cookies and avoids a storm of NTS-KE requests. By default, the
           server does not save the keys.

           An example of the directive is:

               ntsdumpdir /var/lib/chrony

           This directory is used also by the NTS client to save NTS cookies.

       ntsntpserver hostname
           This directive specifies the hostname (as a fully qualified domain name) or address of
           the NTP server(s) which is provided in the NTS-KE response to the clients. It allows
           the NTS-KE server to be separated from the NTP server. However, the servers need to
           share the keys, i.e. external key management needs to be enabled by setting ntsrotate
           to 0. By default, no hostname or address is provided to the clients, which means they
           should use the same server for NTS-KE and NTP.

       ntsrotate interval
           This directive specifies the rotation interval (in seconds) of the server key which
           encrypts the NTS cookies. New keys are generated automatically from the /dev/urandom
           device. The server keeps two previous keys to give the clients time to get new cookies
           encrypted by the latest key. The interval is measured as the server’s operating time,
           i.e. the actual interval can be longer if chronyd is not running continuously. The
           default interval is 604800 seconds (1 week). The maximum value is 2^31-1 (68 years).

           The automatic rotation of the keys can be disabled by setting ntsrotate to 0. In this
           case the keys are assumed to be managed externally. chronyd will not save the keys to
           the ntskeys file and will reload the keys from the file when the rekey command is
           issued in chronyc. The file can be periodically copied from another server running
           chronyd (which does not have ntsrotate set to 0) in order to have one or more servers
           dedicated to NTS-KE. The NTS-KE servers need to be configured with the ntsntpserver
           directive to point the clients to the right NTP server.

           An example of the directive is:

               ntsrotate 2592000

       port port
           This option allows you to configure the port on which chronyd will listen for NTP
           requests. The port will be open only when an address is allowed by the allow directive
           or the allow command in chronyc, an NTP peer is configured, or the broadcast server
           mode is enabled.

           The default value is 123, the standard NTP port. If set to 0, chronyd will never open
           the server port and will operate strictly in a client-only mode. The source port used
           in NTP client requests can be set by the acquisitionport directive.

       ratelimit [option]...
           This directive enables response rate limiting for NTP packets. Its purpose is to
           reduce network traffic with misconfigured or broken NTP clients that are polling the
           server too frequently. The limits are applied to individual IP addresses. If multiple
           clients share one IP address (e.g. multiple hosts behind NAT), the sum of their
           traffic will be limited. If a client that increases its polling rate when it does not
           receive a reply is detected, its rate limiting will be temporarily suspended to avoid
           increasing the overall amount of traffic. The maximum number of IP addresses which can
           be monitored at the same time depends on the memory limit set by the clientloglimit
           directive.

           The ratelimit directive supports a number of options (which can be defined in any
           order):

           interval interval
               This option sets the minimum interval between responses. It is defined as a power
               of 2 in seconds. The default value is 3 (8 seconds). The minimum value is -19
               (524288 packets per second) and the maximum value is 12 (one packet per 4096
               seconds). Note that with values below -4 the rate limiting is coarse (responses
               are allowed in bursts, even if the interval between them is shorter than the
               specified interval).

           burst responses
               This option sets the maximum number of responses that can be sent in a burst,
               temporarily exceeding the limit specified by the interval option. This is useful
               for clients that make rapid measurements on start (e.g. chronyd with the iburst
               option). The default value is 8. The minimum value is 1 and the maximum value is
               255.

           leak rate
               This option sets the rate at which responses are randomly allowed even if the
               limits specified by the interval and burst options are exceeded. This is necessary
               to prevent an attacker who is sending requests with a spoofed source address from
               completely blocking responses to that address. The leak rate is defined as a power
               of 1/2 and it is 2 by default, i.e. on average at least every fourth request has a
               response. The minimum value is 1 and the maximum value is 4.

           An example use of the directive is:

               ratelimit interval 1 burst 16

           This would reduce the response rate for IP addresses sending packets on average more
           than once per 2 seconds, or sending packets in bursts of more than 16 packets, by up
           to 75% (with default leak of 2).

       ntsratelimit [option]...
           This directive enables rate limiting of NTS-KE requests. It is similar to the
           ratelimit directive, except the default interval is 6 (1 connection per 64 seconds).

           An example of the use of the directive is:

               ntsratelimit interval 3 burst 1

       smoothtime max-freq max-wander [leaponly]
           The smoothtime directive can be used to enable smoothing of the time that chronyd
           serves to its clients to make it easier for them to track it and keep their clocks
           close together even when large offset or frequency corrections are applied to the
           server’s clock, for example after being offline for a longer time.

           BE WARNED: The server is intentionally not serving its best estimate of the true time.
           If a large offset has been accumulated, it can take a very long time to smooth it out.
           This directive should be used only when the clients are not configured to also poll
           another NTP server, because they could reject this server as a falseticker or fail to
           select a source completely.

           The smoothing process is implemented with a quadratic spline function with two or
           three pieces. It is independent from any slewing applied to the local system clock,
           but the accumulated offset and frequency will be reset when the clock is corrected by
           stepping, e.g. by the makestep directive or the makestep command in chronyc. The
           process can be reset without stepping the clock by the smoothtime reset command.

           The first two arguments of the directive are the maximum frequency offset of the
           smoothed time to the tracked NTP time (in ppm) and the maximum rate at which the
           frequency offset is allowed to change (in ppm per second). leaponly is an optional
           third argument which enables a mode where only leap seconds are smoothed out and
           normal offset and frequency changes are ignored. The leaponly option is useful in a
           combination with the leapsecmode slew directive to allow the clients to use multiple
           time smoothing servers safely.

           The smoothing process is activated automatically when 1/10000 of the estimated skew of
           the local clock falls below the maximum rate of frequency change. It can be also
           activated manually by the smoothtime activate command, which is particularly useful
           when the clock is synchronised only with manual input and the skew is always larger
           than the threshold. The smoothing command can be used to monitor the process.

           An example suitable for clients using ntpd and 1024 second polling interval could be:

               smoothtime 400 0.001

           An example suitable for clients using chronyd on Linux could be:

               smoothtime 50000 0.01

   Command and monitoring access
       bindcmdaddress address
           The bindcmdaddress directive specifies a local IP address to which chronyd will bind
           the UDP socket listening for monitoring command packets (issued by chronyc). On
           systems other than Linux, the address of the interface needs to be already configured
           when chronyd is started.

           This directive can also change the path of the Unix domain command socket, which is
           used by chronyc to send configuration commands. The socket must be in a directory that
           is accessible only by the root or chrony user. The directory will be created on start
           if it does not exist. The compiled-in default path of the socket is
           /run/chrony/chronyd.sock. The socket can be disabled by setting the path to /.

           By default, chronyd binds the UDP sockets to the addresses 127.0.0.1 and ::1 (i.e. the
           loopback interface). This blocks all access except from localhost. To listen for
           command packets on all interfaces, you can add the lines:

               bindcmdaddress 0.0.0.0
               bindcmdaddress ::

           to the configuration file.

           For each of the IPv4, IPv6, and Unix domain protocols, only one bindcmdaddress
           directive can be specified.

           An example that sets the path of the Unix domain command socket is:

               bindcmdaddress /var/run/chrony/chronyd.sock

       bindcmddevice interface
           The bindcmddevice directive binds the UDP command sockets to a network device
           specified by the interface name. This directive can specify only one interface and it
           is supported on Linux only.

           An example of the directive is:

               bindcmddevice eth0

       cmdallow [all] [subnet]
           This is similar to the allow directive, except that it allows monitoring access
           (rather than NTP client access) to a particular subnet or host. (By ‘monitoring
           access’ is meant that chronyc can be run on those hosts and retrieve monitoring data
           from chronyd on this computer.)

           The syntax is identical to the allow directive.

           There is also a cmdallow all directive with similar behaviour to the allow all
           directive (but applying to monitoring access in this case, of course).

           Note that chronyd has to be configured with the bindcmdaddress directive to not listen
           only on the loopback interface to actually allow remote access.

       cmddeny [all] [subnet]
           This is similar to the cmdallow directive, except that it denies monitoring access to
           a particular subnet or host, rather than allowing it.

           The syntax is identical.

           There is also a cmddeny all directive with similar behaviour to the cmdallow all
           directive.

       cmdport port
           The cmdport directive allows the port that is used for run-time monitoring (via the
           chronyc program) to be altered from its default (323). If set to 0, chronyd will not
           open the port, this is useful to disable chronyc access from the Internet. (It does
           not disable the Unix domain command socket.)

           An example shows the syntax:

               cmdport 257

           This would make chronyd use UDP 257 as its command port. (chronyc would need to be run
           with the -p 257 switch to inter-operate correctly.)

       cmdratelimit [option]...
           This directive enables response rate limiting for command packets. It is similar to
           the ratelimit directive, except responses to localhost are never limited and the
           default interval is -4 (16 packets per second).

           An example of the use of the directive is:

               cmdratelimit interval 2

   Real-time clock (RTC)
       hwclockfile file
           The hwclockfile directive sets the location of the adjtime file which is used by the
           hwclock program on Linux. chronyd parses the file to find out if the RTC keeps local
           time or UTC. It overrides the rtconutc directive.

           The compiled-in default value is '/etc/adjtime'.

           An example of the directive is:

               hwclockfile /etc/adjtime

       rtcautotrim threshold
           The rtcautotrim directive is used to keep the RTC close to the system clock
           automatically. When the system clock is synchronised and the estimated error between
           the two clocks is larger than the specified threshold, chronyd will trim the RTC as if
           the trimrtc command in chronyc was issued. The trimming operation is accurate to only
           about 1 second, which is the minimum effective threshold.

           This directive is effective only with the rtcfile directive.

           An example of the use of this directive is:

               rtcautotrim 30

           This would set the threshold error to 30 seconds.

       rtcdevice device
           The rtcdevice directive sets the path to the device file for accessing the RTC. The
           default path is /dev/rtc.

       rtcfile file
           The rtcfile directive defines the name of the file in which chronyd can save
           parameters associated with tracking the accuracy of the RTC.

           An example of the directive is:

               rtcfile /var/lib/chrony/rtc

           chronyd saves information in this file when it exits and when the writertc command is
           issued in chronyc. The information saved is the RTC’s error at some epoch, that epoch
           (in seconds since January 1 1970), and the rate at which the RTC gains or loses time.

           So far, the support for real-time clocks is limited; their code is even more
           system-specific than the rest of the software. You can only use the RTC facilities
           (the rtcfile directive and the -s command-line option to chronyd) if the following
           three conditions apply:

            1. You are running Linux.

            2. The kernel is compiled with extended real-time clock support (i.e. the /dev/rtc
               device is capable of doing useful things).

            3. You do not have other applications that need to make use of /dev/rtc at all.

       rtconutc
           chronyd assumes by default that the RTC keeps local time (including any daylight
           saving changes). This is convenient on PCs running Linux which are dual-booted with
           Windows.

           If you keep the RTC on local time and your computer is off when daylight saving
           (summer time) starts or ends, the computer’s system time will be one hour in error
           when you next boot and start chronyd.

           An alternative is for the RTC to keep Universal Coordinated Time (UTC). This does not
           suffer from the 1 hour problem when daylight saving starts or ends.

           If the rtconutc directive appears, it means the RTC is required to keep UTC. The
           directive takes no arguments. It is equivalent to specifying the -u switch to the
           Linux hwclock program.

           Note that this setting is overridden by the hwclockfile file and is not relevant for
           the rtcsync directive.

       rtcsync
           The rtcsync directive enables a mode where the system time is periodically copied to
           the RTC and chronyd does not try to track its drift. This directive cannot be used
           with the rtcfile directive.

           On Linux, the RTC copy is performed by the kernel every 11 minutes.

           On macOS, chronyd will perform the RTC copy every 60 minutes when the system clock is
           in a synchronised state.

           On other systems this directive does nothing.

   Logging
       log [option]...
           The log directive indicates that certain information is to be logged. The log files
           are written to the directory specified by the logdir directive. A banner is
           periodically written to the files to indicate the meanings of the columns.

           rawmeasurements
               This option logs the raw NTP measurements and related information to a file called
               measurements.log. An entry is made for each packet received from the source. This
               can be useful when debugging a problem. An example line (which actually appears as
               a single line in the file) from the log file is shown below.

                   2016-11-09 05:40:50 203.0.113.15    N  2 111 111 1111  10 10 1.0 \
                      -4.966e-03  2.296e-01  1.577e-05  1.615e-01  7.446e-03 CB00717B 4B D K

               The columns are as follows (the quantities in square brackets are the values from
               the example line above):

                1. Date [2015-10-13]

                2. Hour:Minute:Second. Note that the date-time pair is expressed in UTC, not the
                   local time zone. [05:40:50]

                3. IP address of server or peer from which measurement came [203.0.113.15]

                4. Leap status (N means normal, + means that the last minute of the current month
                   has 61 seconds, - means that the last minute of the month has 59 seconds, ?
                   means the remote computer is not currently synchronised.) [N]

                5. Stratum of remote computer. [2]

                6. RFC 5905 tests 1 through 3 (1=pass, 0=fail) [111]

                7. RFC 5905 tests 5 through 7 (1=pass, 0=fail) [111]

                8. Tests for maximum delay, maximum delay ratio and maximum delay dev ratio,
                   against defined parameters, and a test for synchronisation loop (1=pass,
                   0=fail) [1111]

                9. Local poll [10]

                10. Remote poll [10]

                11. ‘Score’ (an internal score within each polling level used to decide when to
                   increase or decrease the polling level. This is adjusted based on number of
                   measurements currently being used for the regression algorithm). [1.0]

                12. The estimated local clock error (theta in RFC 5905). Positive indicates that
                   the local clock is slow of the remote source. [-4.966e-03]

                13. The peer delay (delta in RFC 5905). [2.296e-01]

                14. The peer dispersion (epsilon in RFC 5905). [1.577e-05]

                15. The root delay (DELTA in RFC 5905). [1.615e-01]

                16. The root dispersion (EPSILON in RFC 5905). [7.446e-03]

                17. Reference ID of the server’s source as a hexadecimal number. [CB00717B]

                18. NTP mode of the received packet (1=active peer, 2=passive peer, 4=server,
                   B=basic, I=interleaved). [4B]

                19. Source of the local transmit timestamp (D=daemon, K=kernel, H=hardware). [D]

                20. Source of the local receive timestamp (D=daemon, K=kernel, H=hardware). [K]

           measurements
               This option is identical to the rawmeasurements option, except it logs only valid
               measurements from synchronised sources, i.e. measurements which passed the RFC
               5905 tests 1 through 7. This can be useful for producing graphs of the source’s
               performance.

           statistics
               This option logs information about the regression processing to a file called
               statistics.log. An example line (which actually appears as a single line in the
               file) from the log file is shown below.

                   2016-08-10 05:40:50 203.0.113.15     6.261e-03 -3.247e-03 \
                        2.220e-03  1.874e-06  1.080e-06 7.8e-02  16   0   8  0.00

               The columns are as follows (the quantities in square brackets are the values from
               the example line above):

                1. Date [2015-07-22]

                2. Hour:Minute:Second. Note that the date-time pair is expressed in UTC, not the
                   local time zone. [05:40:50]

                3. IP address of server or peer from which measurement comes [203.0.113.15]

                4. The estimated standard deviation of the measurements from the source (in
                   seconds). [6.261e-03]

                5. The estimated offset of the source (in seconds, positive means the local clock
                   is estimated to be fast, in this case). [-3.247e-03]

                6. The estimated standard deviation of the offset estimate (in seconds).
                   [2.220e-03]

                7. The estimated rate at which the local clock is gaining or losing time relative
                   to the source (in seconds per second, positive means the local clock is
                   gaining). This is relative to the compensation currently being applied to the
                   local clock, not to the local clock without any compensation. [1.874e-06]

                8. The estimated error in the rate value (in seconds per second). [1.080e-06].

                9. The ratio of |old_rate - new_rate| / old_rate_error. Large values indicate the
                   statistics are not modelling the source very well. [7.8e-02]

                10. The number of measurements currently being used for the regression algorithm.
                   [16]

                11. The new starting index (the oldest sample has index 0; this is the method
                   used to prune old samples when it no longer looks like the measurements fit a
                   linear model). [0, i.e. no samples discarded this time]

                12. The number of runs. The number of runs of regression residuals with the same
                   sign is computed. If this is too small it indicates that the measurements are
                   no longer represented well by a linear model and that some older samples need
                   to be discarded. The number of runs for the data that is being retained is
                   tabulated. Values of approximately half the number of samples are expected.
                   [8]

                13. The estimated or configured asymmetry of network jitter on the path to the
                   source which was used to correct the measured offsets. The asymmetry can be
                   between -0.5 and +0.5. A negative value means the delay of packets sent to the
                   source is more variable than the delay of packets sent from the source back.
                   [0.00, i.e. no correction for asymmetry]

           tracking
               This option logs changes to the estimate of the system’s gain or loss rate, and
               any slews made, to a file called tracking.log. An example line (which actually
               appears as a single line in the file) from the log file is shown below.

                   2017-08-22 13:22:36 203.0.113.15     2     -3.541      0.075 -8.621e-06 N \
                               2  2.940e-03 -2.084e-04  1.534e-02  3.472e-04  8.304e-03

               The columns are as follows (the quantities in square brackets are the values from
               the example line above) :

                1. Date [2017-08-22]

                2. Hour:Minute:Second. Note that the date-time pair is expressed in UTC, not the
                   local time zone. [13:22:36]

                3. The IP address of the server or peer to which the local system is
                   synchronised. [203.0.113.15]

                4. The stratum of the local system. [2]

                5. The local system frequency (in ppm, positive means the local system runs fast
                   of UTC). [-3.541]

                6. The error bounds on the frequency (in ppm). [0.075]

                7. The estimated local offset at the epoch, which is normally corrected by
                   slewing the local clock (in seconds, positive indicates the clock is fast of
                   UTC). [-8.621e-06]

                8. Leap status (N means normal, + means that the last minute of this month has 61
                   seconds, - means that the last minute of the month has 59 seconds, ? means the
                   clock is not currently synchronised.) [N]

                9. The number of combined sources. [2]

                10. The estimated standard deviation of the combined offset (in seconds).
                   [2.940e-03]

                11. The remaining offset correction from the previous update (in seconds,
                   positive means the system clock is slow of UTC). [-2.084e-04]

                12. The total of the network path delays to the reference clock to which the
                   local clock is ultimately synchronised (in seconds). [1.534e-02]

                13. The total dispersion accumulated through all the servers back to the
                   reference clock to which the local clock is ultimately synchronised (in
                   seconds). [3.472e-04]

                14. The maximum estimated error of the system clock in the interval since the
                   previous update (in seconds). It includes the offset, remaining offset
                   correction, root delay, and dispersion from the previous update with the
                   dispersion which accumulated in the interval. [8.304e-03]

           rtc
               This option logs information about the system’s real-time clock. An example line
               (which actually appears as a single line in the file) from the rtc.log file is
               shown below.

                   2015-07-22 05:40:50     -0.037360 1       -0.037434\
                             -37.948  12   5  120

               The columns are as follows (the quantities in square brackets are the values from
               the example line above):

                1. Date [2015-07-22]

                2. Hour:Minute:Second. Note that the date-time pair is expressed in UTC, not the
                   local time zone. [05:40:50]

                3. The measured offset between the RTC and the system clock in seconds. Positive
                   indicates that the RTC is fast of the system time [-0.037360].

                4. Flag indicating whether the regression has produced valid coefficients. (1 for
                   yes, 0 for no). [1]

                5. Offset at the current time predicted by the regression process. A large
                   difference between this value and the measured offset tends to indicate that
                   the measurement is an outlier with a serious measurement error. [-0.037434]

                6. The rate at which the RTC is losing or gaining time relative to the system
                   clock. In ppm, with positive indicating that the RTC is gaining time.
                   [-37.948]

                7. The number of measurements used in the regression. [12]

                8. The number of runs of regression residuals of the same sign. Low values
                   indicate that a straight line is no longer a good model of the measured data
                   and that older measurements should be discarded. [5]

                9. The measurement interval used prior to the measurement being made (in
                   seconds). [120]

           refclocks
               This option logs the raw and filtered reference clock measurements to a file
               called refclocks.log. An example line (which actually appears as a single line in
               the file) from the log file is shown below.

                   2009-11-30 14:33:27.000000 PPS2    7 N 1  4.900000e-07 -6.741777e-07  1.000e-06

               The columns are as follows (the quantities in square brackets are the values from
               the example line above):

                1. Date [2009-11-30]

                2. Hour:Minute:Second.Microsecond. Note that the date-time pair is expressed in
                   UTC, not the local time zone. [14:33:27.000000]

                3. Reference ID of the reference clock from which the measurement came. [PPS2]

                4. Sequence number of driver poll within one polling interval for raw samples, or
                   - for filtered samples. [7]

                5. Leap status (N means normal, + means that the last minute of the current month
                   has 61 seconds, - means that the last minute of the month has 59 seconds). [N]

                6. Flag indicating whether the sample comes from PPS source. (1 for yes, 0 for
                   no, or - for filtered sample). [1]

                7. Local clock error measured by reference clock driver, or - for filtered
                   sample. [4.900000e-07]

                8. Local clock error with applied corrections. Positive indicates that the local
                   clock is slow. [-6.741777e-07]

                9. Assumed dispersion of the sample. [1.000e-06]

           tempcomp
               This option logs the temperature measurements and system rate compensations to a
               file called tempcomp.log. An example line (which actually appears as a single line
               in the file) from the log file is shown below.

                   2015-04-19 10:39:48  2.8000e+04  3.6600e-01

               The columns are as follows (the quantities in square brackets are the values from
               the example line above):

                1. Date [2015-04-19]

                2. Hour:Minute:Second. Note that the date-time pair is expressed in UTC, not the
                   local time zone. [10:39:48]

                3. Temperature read from the sensor. [2.8000e+04]

                4. Applied compensation in ppm, positive means the system clock is running faster
                   than it would be without the compensation. [3.6600e-01]

           An example of the directive is:

               log measurements statistics tracking

       logbanner entries
           A banner is periodically written to the log files enabled by the log directive to
           indicate the meanings of the columns.

           The logbanner directive specifies after how many entries in the log file should be the
           banner written. The default is 32, and 0 can be used to disable it entirely.

       logchange threshold
           This directive sets the threshold for the adjustment of the system clock that will
           generate a syslog message. Clock errors detected via NTP packets, reference clocks, or
           timestamps entered via the settime command of chronyc are logged.

           By default, the threshold is 1 second.

           An example of the use is:

               logchange 0.1

           which would cause a syslog message to be generated if a system clock error of over 0.1
           seconds starts to be compensated.

       logdir directory
           This directive specifies the directory for writing log files enabled by the log
           directive. If the directory does not exist, it will be created automatically.

           An example of the use of this directive is:

               logdir /var/log/chrony

       mailonchange email threshold
           This directive defines an email address to which mail should be sent if chronyd
           applies a correction exceeding a particular threshold to the system clock.

           An example of the use of this directive is:

               mailonchange root@localhost 0.5

           This would send a mail message to root if a change of more than 0.5 seconds were
           applied to the system clock.

           This directive cannot be used when a system call filter is enabled by the -F option as
           the chronyd process will not be allowed to fork and execute the sendmail binary.

   Miscellaneous
       confdir directory...
           The confdir directive includes configuration files with the .conf suffix from a
           directory. The files are included in the lexicographical order of the file names.

           Multiple directories (up to 10) can be specified with a single confdir directive. In
           this case, if multiple directories contain a file with the same name, only the first
           file in the order of the specified directories will be included. This enables a
           fragmented configuration where existing fragments can be replaced by adding files to a
           different directory.

           This directive can be used multiple times.

           An example of the directive is:

               confdir /etc/chrony/chrony.d

       sourcedir directory...
           The sourcedir directive is identical to the confdir directive, except the
           configuration files have the .sources suffix, they can only specify NTP sources (i.e.
           the server, pool, and peer directives), they are expected to have all lines terminated
           by the newline character, and they can be reloaded by the reload sources command in
           chronyc. It is particularly useful with dynamic sources like NTP servers received from
           a DHCP server, which can be written to a file specific to the network interface by a
           networking script.

           This directive can be used multiple times.

           An example of the directive is:

               sourcedir /var/run/chrony-dhcp

       include pattern
           The include directive includes a configuration file, or multiple configuration files
           if a wildcard pattern is specified. Unlike with the confdir directive, the full name
           of the files needs to be specified and at least one file is required to exist.

           This directive can be used multiple times.

           An example of the directive is:

               include /etc/chrony/chrony.d/*.conf

       hwtimestamp interface [option]...
           This directive enables hardware timestamping of NTP packets sent to and received from
           the specified network interface. The network interface controller (NIC) uses its own
           clock to accurately timestamp the actual transmissions and receptions, avoiding
           processing and queueing delays in the kernel, network driver, and hardware. This can
           significantly improve the accuracy of the timestamps and the measured offset, which is
           used for synchronisation of the system clock. In order to get the best results, both
           sides receiving and sending NTP packets (i.e. server and client, or two peers) need to
           use HW timestamping. If the server or peer supports the interleaved mode, it needs to
           be enabled by the xleave option in the server or the peer directive.

           This directive is supported on Linux 3.19 and newer. The NIC must support HW
           timestamping, which can be verified with the ethtool -T command. The list of
           capabilities should include SOF_TIMESTAMPING_RAW_HARDWARE,
           SOF_TIMESTAMPING_TX_HARDWARE, and SOF_TIMESTAMPING_RX_HARDWARE. Receive filter
           HWTSTAMP_FILTER_ALL, or HWTSTAMP_FILTER_NTP_ALL, is necessary for timestamping of
           received NTP packets. Timestamping of packets received on bridged and bonded
           interfaces is supported on Linux 4.13 and newer. When chronyd is running, no other
           process (e.g. a PTP daemon) should be working with the NIC clock.

           If the kernel supports software timestamping, it will be enabled for all interfaces.
           The source of timestamps (i.e. hardware, kernel, or daemon) is indicated in the
           measurements.log file if enabled by the log measurements directive, and the ntpdata
           report in chronyc.

           This directive can be used multiple times to enable HW timestamping on multiple
           interfaces. If the specified interface is *, chronyd will try to enable HW
           timestamping on all available interfaces.

           The hwtimestamp directive has the following options:

           minpoll poll
               This option specifies the minimum interval between readings of the NIC clock. It’s
               defined as a power of two. It should correspond to the minimum polling interval of
               all NTP sources and the minimum expected polling interval of NTP clients. The
               default value is 0 (1 second) and the minimum value is -6 (1/64th of a second).

           minsamples samples
               This option specifies the minimum number of readings kept for tracking of the NIC
               clock. The default value is 2.

           maxsamples samples
               This option specifies the maximum number of readings kept for tracking of the NIC
               clock. The default value is 16.

           precision precision
               This option specifies the assumed precision of reading of the NIC clock. The
               default value is 100e-9 (100 nanoseconds).

           txcomp compensation
               This option specifies the difference in seconds between the actual transmission
               time at the physical layer and the reported transmit timestamp. This value will be
               added to transmit timestamps obtained from the NIC. The default value is 0.

           rxcomp compensation
               This option specifies the difference in seconds between the reported receive
               timestamp and the actual reception time at the physical layer. This value will be
               subtracted from receive timestamps obtained from the NIC. The default value is 0.

           nocrossts
               Some hardware can precisely cross timestamp the NIC clock with the system clock.
               This option disables the use of the cross timestamping.

           rxfilter filter
               This option selects the receive timestamping filter. The filter can be one of the
               following:

               all
                   Enables timestamping of all received packets.

               ntp
                   Enables timestamping of received NTP packets.

               ptp
                   Enables timestamping of received PTP packets.

               none
                   Disables timestamping of received packets.

               The most specific filter for timestamping of NTP packets supported by the NIC is
               selected by default. Some NICs can timestamp PTP packets only. By default, they
               will be configured with the none filter and expected to provide hardware
               timestamps for transmitted packets only. Timestamping of PTP packets is useful
               with NTP-over-PTP enabled by the ptpport directive. Forcing timestamping of all
               packets with the all filter could be useful if the NIC supported both the all and
               ntp filters, and it should timestamp both NTP and PTP packets, or NTP packets on a
               different UDP port.

           Examples of the directive are:

               hwtimestamp eth0
               hwtimestamp eth1 txcomp 300e-9 rxcomp 645e-9
               hwtimestamp *

       keyfile file
           This directive is used to specify the location of the file containing symmetric keys
           which are shared between NTP servers and clients, or peers, in order to authenticate
           NTP packets with a message authentication code (MAC) using a cryptographic hash
           function or cipher.

           The format of the directive is shown in the example below:

               keyfile /etc/chrony/chrony.keys

           The argument is simply the name of the file containing the ID-key pairs. The format of
           the file is shown below:

               10 tulip
               11 hyacinth
               20 MD5 ASCII:crocus
               25 SHA1 HEX:933F62BE1D604E68A81B557F18CFA200483F5B70
               30 AES128 HEX:7EA62AE64D190114D46D5A082F948EC1
               31 AES256 HEX:37DDCBC67BB902BCB8E995977FAB4D2B5642F5B32EBCEEE421921D97E5CBFE39
                ...

           Each line consists of an ID, optional type, and key.

           The ID can be any positive integer in the range 1 through 2^32-1.

           The type is a name of a cryptographic hash function or cipher which is used to
           generate and verify the MAC. The default type is MD5, which is always supported. If
           chronyd was built with enabled support for hashing using a crypto library (nettle,
           nss, or libtomcrypt), the following functions are available: MD5, SHA1, SHA256,
           SHA384, SHA512. Depending on which library and version is chronyd using, some of the
           following hash functions and ciphers may also be available: SHA3-224, SHA3-256,
           SHA3-384, SHA3-512, TIGER, WHIRLPOOL, AES128, AES256.

           The key can be specified as a string of ASCII characters not containing white space
           with an optional ASCII: prefix, or as a hexadecimal number with the HEX: prefix. The
           maximum length of the line is 2047 characters. If the type is a cipher, the length of
           the key must match the cipher (i.e. 128 bits for AES128 and 256 bits for AES256).

           It is recommended to use randomly generated keys, specified in the hexadecimal format,
           which are at least 128 bits long (i.e. they have at least 32 characters after the HEX:
           prefix). chronyd will log a warning to syslog on start if a source is specified in the
           configuration file with a key shorter than 80 bits.

           The recommended key types are AES ciphers and SHA3 hash functions. MD5 should be
           avoided unless no other type is supported on the server and client, or peers.

           The keygen command of chronyc can be used to generate random keys for the key file. By
           default, it generates 160-bit MD5 or SHA1 keys.

           For security reasons, the file should be readable only by root and the user under
           which chronyd is normally running (to allow chronyd to re-read the file when the rekey
           command is issued by chronyc).

       lock_all
           The lock_all directive will lock the chronyd process into RAM so that it will never be
           paged out. This can result in lower and more consistent latency. The directive is
           supported on Linux, FreeBSD, NetBSD, and illumos.

       pidfile file
           Unless chronyd is started with the -Q option, it writes its process ID (PID) to a
           file, and checks this file on startup to see if another chronyd might already be
           running on the system. By default, the file used is /run/chrony/chronyd.pid. The
           pidfile directive allows the name to be changed, e.g.:

               pidfile /run/chronyd.pid

       ptpport port
           The ptpport directive enables chronyd to send and receive NTP messages contained in
           PTP event messages (NTP-over-PTP) to enable hardware timestamping on NICs which cannot
           timestamp NTP packets, but can timestamp unicast PTP packets. The port recognized by
           the NICs is 319 (PTP event port). The default value is 0 (disabled).

           The NTP-over-PTP support is experimental. The protocol and configuration can change in
           future. It should be used only in local networks and expected to work only between
           servers and clients running the same version of chronyd.

           The PTP port will be open even if chronyd is not configured to operate as a server or
           client. The directive does not change the default protocol of specified NTP sources.
           Each NTP source that should use NTP-over-PTP needs to be specified with the port
           option set to the PTP port. To actually enable hardware timestamping on NICs which can
           timestamp PTP packets only, the rxfilter option of the hwtimestamp directive needs to
           be set to ptp.

           An example of client configuration is:

               server foo.example.net minpoll 0 maxpoll 0 xleave port 319
               hwtimestamp * rxfilter ptp
               ptpport 319

       sched_priority priority
           On Linux, FreeBSD, NetBSD, and illumos, the sched_priority directive will select the
           SCHED_FIFO real-time scheduler at the specified priority (which must be between 0 and
           100). On macOS, this option must have either a value of 0 (the default) to disable the
           thread time constraint policy or 1 for the policy to be enabled.

           On systems other than macOS, this directive uses the pthread_setschedparam() system
           call to instruct the kernel to use the SCHED_FIFO first-in, first-out real-time
           scheduling policy for chronyd with the specified priority. This means that whenever
           chronyd is ready to run it will run, interrupting whatever else is running unless it
           is a higher priority real-time process. This should not impact performance as chronyd
           resource requirements are modest, but it should result in lower and more consistent
           latency since chronyd will not need to wait for the scheduler to get around to running
           it. You should not use this unless you really need it. The pthread_setschedparam(3)
           man page has more details.

           On macOS, this directive uses the thread_policy_set() kernel call to specify real-time
           scheduling. As noted above, you should not use this directive unless you really need
           it.

       user user
           The user directive sets the name of the system user to which chronyd will switch after
           start in order to drop root privileges.

           On Linux, chronyd needs to be compiled with support for the libcap library. On macOS,
           FreeBSD, NetBSD and illumos chronyd forks into two processes. The child process
           retains root privileges, but can only perform a very limited range of privileged
           system calls on behalf of the parent.

           The compiled-in default value is _chrony.


maxdelaydevratio ratio 如果测量值的往返延迟从先前测量值之间的最小延迟增加到先前测量值的标准偏差大于指定比率，则该测量值将被拒绝。默认值为 10.0。mindelay delay 此选项指定要使用的固定最小往返延迟，而不是先前测量中的最小延迟。这在具有静态配置的网络中非常有用，可以提高非对称抖动校正、测量加权以及 maxdelayratio 和 maxdelaydevratio 测试的稳定性。应准确设置该值，以便对同步产生积极影响。不对称比率 此选项指定源路径上网络抖动的不对称性，用于根据延迟校正测得的偏移。不对称性可以在 -0.5 和 +0.5 之间。负值表示发送到源的数据包的延迟比从源发送回的数据包的延迟变化更大。默认情况下，chronyd 会自动估计不对称性。偏移偏移量 此选项指定校正（以秒为单位），该校正将应用于使用此源测量的偏移量。补偿网络延迟或时间戳错误中的已知不对称性特别有用。例如，如果发送到源的数据包平均延迟 100 微秒，则校正为 -0.00005（-50 微秒）。默认值为 0.0。minsamples samples 设置为此源保留的最小样本数。这将覆盖 minsamples 指令。maxsamples samples 设置为此源保留的最大样本数。这将覆盖 maxsamples 指令。 滤波器样本 此选项使中值滤波器能够降低 NTP 测量中的噪声。过滤器会将指定数量的样本减少到单个样本。它旨在以非常短的轮询间隔在本地网络中使用，其中可以生成大量 NTP 流量。离线 如果在启动 chronyd 时无法访问服务器，则可以指定离线选项。chronyd 不会尝试轮询服务器，直到它被启用（通过使用 chronyc 中的 online 命令）。auto_offline 使用此选项时，当发送请求失败时，例如由于缺少网络路由，将假定服务器已脱机。此选项避免了在断开网络链路连接时从 chronyc 运行脱机命令的需要。（建立链路后，仍需要使用联机命令，以便开始测量。首选 首选此源，而不是没有首选选项的源。noselect 从不选择此源。这对于监视特别有用。trust 假设来自此源的时间始终为 true。仅当具有此选项的另一个源不同意它时，它才能在源选择中被拒绝为虚假代码。require 在更新时钟之前，要求至少一个使用此选项指定的源是可选的（即最近可访问的，而不是虚假的）。与信任选项一起，这可能有助于允许受信任的身份验证源与未经身份验证的源安全地组合在一起，以提高时钟的准确性。仅当它们与受信任和必需的源一致时，才能选择它们并用于同步。xleave 此选项启用 NTP 的交错模式。 它使服务器能够使用更准确的传输时间戳（例如内核或硬件时间戳）进行响应，这些时间戳不能包含在传输的数据包本身中，而需要引用前一个数据包。这可以显著提高测量的准确性和稳定性。交错模式与仅支持基本模式的服务器兼容。请注意，即使是支持交错模式的服务器也可能在基本模式下做出响应，因为交错模式要求服务器为每个客户端保留一些状态，并且当客户端太多时，状态可能会被丢弃（例如，clientloglimit 太小），或者它可能会被具有相同 IP 地址的其他客户端覆盖（例如，NAT 后面的计算机或使用欺骗源地址发送请求的人）。xleave 选项可以与 presend 选项结合使用，以缩短服务器必须保持状态才能在交错模式下响应的间隔。polltarget target 用于回归算法的目标测量值，chronyd 将尝试通过调整 minpoll 和 maxpoll 之间的轮询间隔来维护该算法。更高的目标使 chronyd 更喜欢更短的轮询间隔。默认值为 8，有用范围为 6 到 60。port port 此选项允许指定服务器在其上理解 NTP 请求的 UDP 端口。对于普通服务器，不应要求此选项（默认值为 123，标准 NTP 端口）。ntsport 端口 此选项指定启用 nts 选项时服务器侦听 NTS-KE 连接的 TCP 端口。默认值为 4460。 预发送轮询 如果 chronyd 进行的时序测量是在两台计算机之间传递的唯一网络数据，您可能会发现某些测量值严重偏斜，因为客户端或服务器必须在传输数据包之前对另一方进行 ARP 查找。这更像是长采样间隔的问题，采样间隔的持续时间可能与计算机的 ARP 缓存中条目的生存期相似。为了避免此问题，可以使用 presend 选项。它采用单个整数参数，这是在实际测量之前将在客户端和服务器之间交换一对额外 NTP 数据包的最小轮询间隔。例如，在服务器指令中包含以下选项：presend 9 当轮询间隔为 512 秒或更长时间时，将在进行实际测量之前的短时间（2 秒）向服务器发送额外的 NTP 客户端数据包。如果 presend 选项与 xleave 选项一起使用，chronyd 将发送两个额外的数据包，而不是一个。层层 当从可用源中选择同步源时，通常略微首选具有较低层的源。此选项可用于将源的层增加到指定的最小值，因此 chronyd 将避免选择该源。这对于已知不可靠或不准确的低层来源很有用，并且只有在无法访问其他来源时才应使用。版本版本 此选项设置发送到服务器的数据包的 NTP 版本。当服务器运行的旧 NTP 实现不响应使用较新版本的请求时，这可能很有用。默认版本取决于其他选项。 如果使用 extfield 或 xleave 选项，则默认版本为 4。如果未使用这些选项，并且 key 选项使用输出大小超过 160 位的哈希函数（例如 SHA256）指定密钥，则默认版本为 3，以便与较旧的 chronyd 服务器兼容。在其他情况下，默认版本为 4。copy 此选项指定服务器和客户端密切相关，它们的配置不允许在它们之间形成同步循环，并且允许客户端采用服务器的引用 ID 和层。当 chronyd 的多个实例在一台计算机上运行时（例如出于安全或性能原因），其中一台主要作为客户端运行以同步系统时钟，而其他实例以 -x 选项启动，作为其他计算机的 NTP 服务器运行，其 NTP 时钟与第一个实例同步。extfield 类型 此选项启用 NTPv4 扩展字段，该扩展字段由其类型指定为十六进制数。如果服务器支持它，它将包含在发送到服务器的请求中，并在收到的响应中进行处理。请注意，某些服务器实现不响应包含未知扩展字段的请求（chronyd 作为服务器从 2.0 版开始响应此类请求）。此选项可以启用以下扩展字段： F323 这是一个实验性扩展字段，用于为下一版本的 NTP 协议 （NTPv5） 提出的一些改进。该字段包含更高分辨率的根延迟和色散以及单调接收时间戳，从而实现服务器和客户端之间的频率传输。它可以显着提高同步的稳定性。 通常，它应该只在运行相同版本的 chronyd 的服务器和客户端之间工作。池名称 [选项]...此指令的语法与服务器指令的语法类似，只不过它用于指定 NTP 服务器池而不是单个 NTP 服务器。池名称应解析为多个地址，这些地址可能会随时间而更改。此指令可以多次用于指定多个池。server 指令中有效的所有选项也可以在此指令中使用。有一个特定于 pool 指令的选项： maxsources sources 此选项设置要从池中使用的所需源数。chronyd 将反复尝试解析该名称，直到它获得此数量的源响应请求。默认值为 4，最大值为 16。当 NTP 源无法访问、标记为 falseticker 或距离大于 maxdistance 指令设置的限制时，chronyd 将尝试将源替换为新解析的名称地址。pool 指令的一个示例是 pool pool.ntp.org iburst maxsources 3 peer hostname [option]...此指令的语法与服务器指令的语法相同，只是它指定与 NTP 对等体的对称关联，而不是与 NTP 服务器的客户端/服务器关联。单个对称关联允许对等方彼此既是服务器又是客户端。当对等体的 NTP 实现（例如 ntpd）支持临时对称关联并且不需要使用此主机的地址进行配置时，这主要有用。Chronyd 不支持临时关联。此指令可以多次用于指定多个对等体。 server 指令的以下选项在对等指令中不起作用：iburst、burst、nts、presend、copy。使用 xleave 选项时，两个对等体都必须支持并启用交错模式，否则同步将仅在一个方向上工作。当密钥选项指定密钥以启用身份验证时，两个对等方必须使用相同的密钥和相同的密钥编号。请注意，对称模式不如客户端/服务器模式安全。对未经身份验证的对称关联可能会进行拒绝服务攻击，即当指定对等体时没有密钥选项时。如果攻击者看不到两台主机之间的网络流量，但知道它们正在相互对等，则可以定期向它们发送带有欺骗性源地址的未经身份验证的数据包，以破坏它们的 NTP 状态并阻止它们相互同步。对关联进行身份验证后，即使看到网络流量，但无法阻止数据包到达其他主机的攻击者仍可以通过重播旧数据包来破坏状态。攻击者实际上具有与中间人攻击者相同的权力。chronyd 中实现了针对此攻击的部分保护，如果对等方使用相同的轮询间隔，并且他们从未发送过带有未来时间戳的经过身份验证的数据包，则可以保护它们，但不应依赖它，因为很难确保满足条件。如果两台主机应该能够在两个方向上相互同步，则建议改用两个单独的客户端/服务器关联（由两台主机上的服务器指令指定）。initstepslew step-threshold [主机名]...（此指令已弃用，取而代之的是 makestep 指令。） initstepslew 指令的目的是允许 chronyd 在启动时快速测量系统时钟错误，并在正常操作开始之前通过步进来校正系统时钟。由于这通常仅在系统启动序列中的适当点执行，因此该步骤不会对任何其他软件产生不利影响。如果所需的校正小于指定的阈值，则改用回摆率。这使得在系统正常运行时重新启动chronyd变得更加安全。initstepslew 指令采用阈值和 NTP 服务器列表作为参数。每个服务器都会被快速轮询几次，并且多数投票机制用于查找存在的最可能的系统时钟错误范围。对系统时钟施加步进或摆率以纠正此错误。然后 chronyd 进入其正常操作模式。使用指令的一个示例是：initstepslew 30 foo.example.net bar.example.net baz.example.net 其中 3 个 NTP 服务器用于进行测量。30 表示如果发现系统的错误在 30 秒或更短的时间内，将使用回转来纠正它;如果错误大于 30 秒，则将使用步长。initstepslew 指令也可用于隔离的 LAN 环境，其中时钟是手动设置的。选择最稳定的计算机作为主服务器，其他计算机作为其客户端。如果每个客户端都配置了本地指令，则可以使用引用部分或全部客户端的 initstepslew 指令来设置服务器。然后，如果必须重新启动服务器计算机，则可以依靠客户端来充当飞轮，并在服务器完成重新启动时保留一小段时间。 initstepslew 指令在功能上类似于带有 iburst 选项的 makestep 和 server 指令的组合。主要区别在于，initstepslew 服务器仅在正常操作开始之前使用，而前台 chronyd 进程等待 initstepslew 完成后再退出。这可以防止在chronyd之后的引导序列中启动的程序在步进之前读取时钟。使用 makestep 指令，可以改用 chronyc 的 waitsync 命令。refclock 驱动程序参数[：option]...[选项]...refclock 指令指定要用作时间源的硬件参考时钟。它有两个必需参数：驱动程序名称和特定于驱动程序的参数。这两个参数后面跟着零个或多个 refclock 选项。某些驱动程序具有特殊选项，可以使用 ： 字符将这些选项追加到特定于驱动程序的参数。此指令可以多次用于指定多个参考时钟。chronyd 中包含四个驱动程序： 内核 PPS（每秒脉冲）API 的 PPS 驱动程序。该参数是 PPS 设备的路径（通常为 /dev/pps？由于 PPS 参考时钟不提供全时，因此需要另一个时间源（例如 NTP 服务器或非 PPS 参考时钟）来完成 PPS 参考时钟的样本。另一种方法是启用本地指令，以允许与一些未知但恒定的偏移量同步。驱动程序支持以下选项：清除 默认情况下，PPS refclock 使用断言事件 （上升沿） 进行同步。使用此选项，它将改用清除事件（下降沿）。示例：refclock PPS /dev/pps0 lock NMEA refid GPS refclock SHM 0 offset 0.5 delay 0.2 refid NMEA noselect refclock PPS /dev/pps1：clear refid GPS2 SHM NTP 共享内存驱动程序。 此驱动程序使用共享内存段从另一个进程（例如 gpsd）接收样本。该参数是共享内存段的编号，通常为小数字，如 0、1、2 或 3。驱动程序支持以下选项： perm=mode 此选项指定 chronyd 创建的共享内存段的权限。它们被指定为数字模式。默认值为 0600（仅对所有者进行读写访问）。示例：refclock SHM 0 poll 3 refid GPS1 refclock SHM 1：perm=0644 refid GPS2 SOCK Unix 域套接字驱动程序。它类似于 SHM 驱动程序，但样本是从 Unix 域套接字而不是共享内存接收的，并且消息具有不同的格式。该参数是 chronyd 在启动时创建的套接字的路径。与 SHM 驱动程序相比，SOCK 的一个优点是不需要轮询，并且可以接收时间不完整的 PPS 样本。消息的格式在 chrony 源代码的 refclock_sock.c 文件中进行了描述。支持 SOCK 协议的应用程序是 gpsd 守护程序。gpsd 期望创建套接字的路径在 gpsd（8） 手册页中描述。例如：refclock SOCK /var/run/chrony.ttyS0.sock PHC PTP 硬件时钟 （PHC） 驱动程序。该参数是 PTP 时钟设备的路径，应用作时间源。如果时钟保持在 TAI 而不是 UTC 中（例如，它由 PTP 守护程序同步），则需要通过偏移选项指定当前的 UTC-TAI 偏移量。或者，可以启用 pps refclock 选项，将 PHC 视为 PPS refclock，仅使用亚秒偏移进行同步。驱动程序支持以下选项： nocrossts 此选项禁用精确的交叉时间戳。 extpps 此选项启用 PPS 模式，在该模式下，PTP 时钟对连接到时钟的外部 PPS 信号的脉冲进行时间戳。时钟不需要同步，但需要另一个时间源来完成 PPS 采样。请注意，某些 PTP 时钟不能配置为仅对断言或清除事件进行时间戳，并且必须使用 width 选项来过滤错误的 PPS 样本。pin=index 此选项指定连接 PPS 信号的引脚的索引。默认值为 0。channel=index 此选项指定 PPS 模式的通道索引。默认值为 0。clear 此选项允许在 PPS 模式下对清除事件（下降沿）而不是断言事件（上升沿）进行时间戳。这可能不适用于某些时钟。示例： refclock PHC /dev/ptp0 轮询 0 dpoll -2 偏移量 -37 refclock PHC /dev/ptp1：nocrossts 轮询 3 pps refclock PHC /dev/ptp2：extpps：pin=1 宽度 0.2 轮询 2 refclock 指令支持以下选项： 轮询轮询 refclock 驱动程序生成的时间戳不会立即使用，但会由中值筛选器在此选项指定的轮询间隔内存储和处理它们。这被定义为 2 的幂，并且可以是负数以指定亚秒间隔。默认值为 4（16 秒）。较短的间隔允许chronyd对系统时钟频率的变化做出更快的反应，但如果样本有很大的抖动，它可能会对其准确性产生负面影响。dpoll dpoll 某些驱动程序不侦听外部事件，并尝试在自己的轮询间隔内生成样本。这被定义为 2 的幂，并且可以是负数以指定亚秒间隔。默认值为 0（1 秒）。 refid refid 此选项用于指定 refclock 的引用 ID，最多为 4 个 ASCII 字符。默认引用 ID 由驱动程序名称的前三个字符和 refclock 的编号组成。每个 refclock 必须具有唯一的参考 ID。 lock refid 此选项可用于将 PPS refclock 锁定到另一个 refclock，该参考时钟由其参考 ID 指定。在此模式下，接收到的 PPS 样本直接与来自指定参考时钟的原始样本配对。速率 此选项设置 PPS 信号中的脉冲速率（以 Hz 为单位）。此选项控制脉冲的实时完成方式。为了实际接收每秒一个以上的脉冲，必须指定负dpoll（5Hz信号为-3）。默认值为 1。最大锁定脉冲 此选项以脉冲数为单位，指定从锁定选项指定的参考时钟中采样的年龄，以便与脉冲配对。当样品的产生速率低于脉冲时，增加此值非常有用。默认值为 2。width width 此选项指定脉冲的宽度（以秒为单位）。当驱动器为上升沿和下降沿提供样本时，它用于过滤 PPS 样本。请注意，它减少了完成 PPS 样本的时间源的最大允许误差。如果占空比是可配置的，则应首选 50%，以最大限度地提高允许误差。pps 此选项强制 chronyd 将任何 refclock（例如 SHM 或 PHC）视为 PPS refclock。当 refclock 提供具有整数秒数的可变偏移量的时间时（例如，它使用 TAI 而不是 UTC），这可能很有用。需要另一个时间源来完成来自参考时钟的采样。偏移偏移 此选项可用于补偿恒定误差。 指定的偏移量（以秒为单位）应用于参考时钟产生的所有样本。默认值为 0.0。延迟延迟 此选项设置源的 NTP 延迟（以秒为单位）。该值的一半包含在源选择算法中使用的最大假设误差中。增加延迟有助于避免在源选择中没有多数或使其更喜欢其他源。默认值为 1e-9（1 纳秒）。stratum stratum 此选项设置 refclock 的 NTP 层。当 refclock 提供非 0 层的时间时，这可能很有用。默认值为 0。precision precision 此选项设置参考时钟的精度（以秒为单位）。默认值是系统时钟的估计精度。最大分散度 过滤样品的最大允许扩散度（以秒为单位）。估计离散度较大的样品将被忽略。默认情况下，此限制处于禁用状态。滤波器样本 此选项设置中值滤波器的长度，用于降低测量中的噪声。每次轮询时，大约40%的存储样本被丢弃，最终一个样本被计算为剩余样本的平均值。如果长度为 4 或更多，则在两次投票之间必须至少收集 4 个样本。对于低于 4 的长度，过滤器必须已满。默认值为 64。首选 首选此源，而不是没有首选选项的源。noselect 从不选择此源。这对于监控或不太准确但用 PPS 参考时钟锁定的源很有用。trust 假设来自此源的时间始终为 true。仅当具有此选项的另一个源不同意它时，它才能在源选择中被拒绝为虚假代码。 require 在更新时钟之前，要求至少一个使用此选项指定的源是可选的（即最近可访问的，而不是虚假的）。与信任选项一起，这对于允许受信任但不是非常精确的参考时钟与未经身份验证的 NTP 源安全地组合以提高时钟的准确性非常有用。仅当它们与受信任和必需的源一致时，才能选择它们并用于同步。tai 此选项表示参考时钟以 TAI 而不是 UTC 格式保存时间，并且 chronyd 应通过当前的 TAI-UTC 偏移量校正其偏移量。leapsectz 指令必须与此选项一起使用，并且数据库必须保持最新，以便此更正按预期工作。此选项对 PPS 参考时钟没有意义。minsamples samples 设置为此源保留的最小样本数。这将覆盖 minsamples 指令。maxsamples samples 设置为此源保留的最大样本数。这将覆盖 maxsamples 指令。manual manual 指令在运行时启用对 chronyc 中的 settime 命令的支持。如果没有包含手动指令，则任何在chronyc中使用settime命令的尝试都会遇到错误消息。请注意，可以在运行时使用 chronyc 中的手动命令启用 settime 命令。（这两个命令的思想是，手动命令控制手动时钟驱动程序的行为，而 settime 命令允许提供手动输入的时间样本。acquisitionport 端口 默认情况下，chronyd 作为 NTP 客户端会为每个请求打开一个新套接字，其源端口由操作系统随机选择。 acquisitionport 指令可用于指定源端口，并且对所有配置的服务器仅使用一个套接字（每个 IPv4 或 IPv6 地址系列）。这对于通过某些防火墙很有用。如果没有必要，则不应使用它，因为对客户端的安全性影响很小。如果设置为 0，则操作系统将随机选择永久套接字的源端口。它可以设置为与 NTP 服务器使用的端口相同的端口（可以使用 port 指令进行配置），以便仅对所有 NTP 数据包使用一个套接字。acquisitionport 指令的一个示例是： acquisitionport 1123 这会将用于客户端请求的源端口更改为 UDP 端口 1123。然后，您可以说服防火墙管理员打开该端口。bindacqaddress 地址 bindacqaddress 指令指定一个本地 IP 地址，chronyd 将绑定其 NTP 和 NTS-KE 客户端套接字。语法类似于 bindaddress 和 bindcmdaddress 指令。对于每个 IPv4 和 IPv6 协议，只能指定一个 bindacqaddress 指令。bindacqdevice 接口 bindacqdevice 指令将客户端套接字绑定到接口名称指定的网络设备。当本地地址是动态的，或者启用使用链路本地 IPv6 地址指定的 NTP 源时，这可能很有用。此指令只能指定一个接口，并且仅在 Linux 上受支持。该指令的一个示例是： bindacqdevice eth0 dscp point dscp 指令将传输的 NTP 数据包中的差分服务代码点 （DSCP） 设置为指定值。它可以提高本地网络中 NTP 测量的稳定性，其中交换机或路由器配置为优先转发具有特定 DSCP 值的数据包。 默认值为 0，最大值为 63。指令（设置 Expedited Forwarding 类）的一个示例是： dscp 46 dumpdir 目录 为了计算时间的增益或损失率，chronyd 必须存储它使用的每个时间源的测量历史记录。除 macOS 10.12 及更低版本外，所有受支持的系统都支持操作系统设置增益或损耗率以补偿已知错误。（在 macOS 10.12 及更早版本上，chronyd 必须通过定期将系统时钟向前或向后摆动适当的量来模拟这种能力，以补偿自上次摆动以来产生的错误。对于此类系统，可以在 chronyd 重新启动时保存测量历史记录（假设系统时钟行为在未运行时没有更改）。dumpdir 指令定义了在 chronyd 退出时保存测量历史记录的目录，或者在 chronyc 中发出 dump 命令。如果该目录不存在，则会自动创建该目录。chronyd 的 -r 选项允许在启动时加载转储文件。启动后，目录中找到的所有转储文件都将被删除，即使 -r 选项不存在也是如此。该指令的一个示例是： dumpdir /run/chrony IP 地址为 1.2.3.4 的源的测量历史记录将保存在文件 /run/chrony/1.2.3.4.dat 中。参考时钟的历史记录以refid:XXXXXXXX.dat的形式保存到按其参考 ID 命名的文件中。maxsamples samples maxsamples 指令设置 chronyd 应为每个源保留的默认最大样本数。对于服务器和 refclock 指令中的单个源，可以覆盖此设置。默认值为 0，禁用可配置限制。 有用范围是 4 到 64。作为特殊情况，将 maxsamples 设置为 1 会禁用频率跟踪，以便仅使用一个样本即可立即选择源。当使用 -q 或 -Q 选项启动 chronyd 时，这可能很有用。minsamples samples minsamples 指令设置 chronyd 应为每个源保留的默认最小样本数。对于服务器和 refclock 指令中的单个源，可以覆盖此设置。默认值为 6。有用范围是 4 到 64。强制chronyd保留比通常保留的更多的样本可以减少估计频率和偏移的噪声，但会减慢对时钟频率和偏移变化的响应速度。跟踪和 sourcestats 报告（以及 tracking.log 和 statistics.log 文件）中的偏移量可能小于实际偏移量。ntsdumpdir 目录 此指令指定一个目录，供客户端保存从服务器接收的 NTS cookie，以避免在再次启动 chronyd 时发出 NTS-KE 请求。每个NTP源的cookie分别保存在以NTS-KE服务器的IP地址命名的文件中（例如1.2.3.4.nts）。默认情况下，客户端不保存 cookie。如果该目录不存在，则会自动创建该目录。该指令的一个示例是： ntsdumpdir /var/lib/chrony NTS 服务器也使用此目录来保存密钥。ntsrefresh interval 此指令指定 NTS-KE 握手之间的最大间隔（以秒为单位），以便刷新对 NTP 数据包进行身份验证的密钥。默认值为 2419200（4 周），最大值为 2^31-1（68 年）。 ntstrustedcerts [set-ID] file|directory 此指令指定一个文件或目录，其中包含受信任的证书颁发机构 （CA） 的证书（PEM 格式），可用于验证 NTS 服务器的证书。可选的 set-ID 参数是 0 到 2^32-1 范围内的数字，用于选择添加指定文件或目录中的证书的证书集。默认 ID 为 0，它是包含系统默认受信任 CA 的集合（除非存在 nosystemcert 指令）。默认情况下，所有其他集都是空的。可以通过 server 或 pool 指令中的 certset 选项选择一组证书来验证 NTS 服务器。此指令可以多次用于指定一组或多组受信任的证书，每组证书都包含来自一个或多个文件和/或目录的证书。如果证书发生更改（例如，在续订后），则无需重新启动chronyd即可重新加载证书。例如： ntstrustedcerts /etc/pki/nts/foo.crt ntstrustedcerts 1 /etc/pki/nts/bar.crt ntstrustedcerts 1 /etc/pki/nts/baz.crt ntstrustedcerts 2 /etc/pki/nts/qux.crt nosystemcert 此指令禁用系统的默认受信任 CA。只有 ntstrustedcerts 指令指定的证书才受信任。nocerttimecheck limit 此指令禁用对指定时钟更新数的证书的激活和过期时间的检查。它允许在以错误时间启动的计算机上使用 NTS 身份验证机制（例如，由于没有 RTC 或备用电池）。禁用时间检查具有重要的安全隐患，应仅作为最后的手段使用，最好使用最少数量的受信任证书。 默认值为 0，表示始终启用时间检查。该指令的一个示例是： nocerttimecheck 1 这将禁用时间检查，直到时钟首次更新，假设第一次更新更正时钟，并且以后的检查可以使用正确的时间。源选择 authselectmode 模式 可以使用 key 或 nts 选项指定 NTP 源，以启用身份验证以限制中间人攻击的影响。攻击者可以丢弃或延迟 NTP 数据包（最高达到 maxdelay 和 maxdistance 限制），但无法修改数据包中包含的时间戳。攻击只能导致有限的摆率或步进，还会导致时钟比实时运行得更快或更慢（最多是最大漂移限制的两倍）。当为 NTP 源启用身份验证时，必须禁用可能在攻击中被利用的未经身份验证的 NTP 源，例如，如果它们只能通过受信任的网络访问。或者，可以使用 require 和 trust 选项配置源选择，以便仅当它们与经过身份验证的源一致并且可能对时钟的精度产生积极影响时，才与未经身份验证的源同步。请注意，在这种情况下，攻击的影响更高。攻击者不能造成任意大的步进或摆动，但他们对时钟频率有更多的控制权，并可能导致chronyd报告错误信息，例如根延迟和分散明显更小。此指令确定已验证和未验证源的默认选择选项，以便使用配置文件和 chronyc 命令简化配置。它设置身份验证策略。 使用 noselect 选项指定的源将被忽略（不计为已验证或未验证），并且它们始终仅具有配置中指定的选择选项。有四种模式： 需要 在此模式下，NTP 源严格需要身份验证。如果指定了任何未经身份验证的 NTP 源，它们将自动获取 noselect 选项，以防止它们被选中进行同步。首选 在此模式下，身份验证是可选的，并且是首选。如果至少为一个 NTP 源启用了它，则所有未经身份验证的 NTP 源都将获得 noselect 选项。mix 在此模式下，身份验证是可选的，并且允许同步到经过身份验证和未经身份验证的 NTP 源的混合。如果同时指定了经过身份验证的 NTP 源和未经身份验证的 NTP 源，则所有经过身份验证的 NTP 源和参考时钟都将获得 require 和 trust 选项，以防止与未经身份验证的 NTP 源同步（如果它们与大多数经过身份验证的源和参考时钟不一致）。这是默认模式。ignore 在此模式下，在源选择中忽略身份验证。所有源将仅具有配置文件或 chronyc 命令中指定的选择选项。这是 chronyd 在 4.0 之前版本中的行为。例如，以下配置使用默认混合模式：服务器 foo.example.net nts 服务器 bar.example.net nts 服务器 baz.example.net refclock SHM 0 等效于使用忽略模式的以下配置：authselectmode ignore 服务器 foo.example.net nts 需要信任服务器 bar.example.net nts 需要信任服务器 baz.example。net refclock SHM 0 require trust combinelimit limit 当 chronyd 有多个源可用于同步时，它必须选择一个源作为同步源。但是，系统时钟相对于其他源的测量偏移和频率可以与所选源相结合，以提高系统时钟的精度。combinelimit 指令限制了组合算法中包含的源。它们的同步距离必须短于所选源的距离乘以限制值。此外，它们的测量频率必须接近所选源的频率。如果所选源是使用 prefer 选项指定的，则只能将其与使用此选项指定的其他源组合。默认情况下，限制为 3。将限制设置为 0 会有效地禁用源组合算法，并且仅使用选定的源来控制系统时钟。maxdistance 距离 maxdistance 指令将源的最大根距离设置为时钟同步可接受。距离大于指定距离的源将被拒绝。距离估计源的最大误差。它包括根色散和在通往主源的路径上累积的根延迟（往返时间）的一半。默认情况下，最大根距离为 3 秒。将 maxdistance 设置为更大的值对于允许与服务器同步非常有用，因为服务器与其源的连接非常少，并且可以在其时钟更新之间累积很大的分散。maxjitter 抖动 maxjitter 指令设置源选择算法不拒绝的最大允许抖动源。 这可以防止与根距离较小但时间变化太大的源同步。默认情况下，最大抖动为 1 秒。minsources 源 minsources 指令设置在更新本地时钟之前，需要在源选择算法中被视为可选的源的最小数量。默认值为 1。将此选项设置为更大的数字可用于提高可靠性。更多的源必须相互同意，当只有一个源（可能服务于不正确的时间）时，时钟将不会更新。reselectdist 距离 当chronyd从可用源中选择同步源时，它将首选同步距离最短的源。但是，为了避免在存在具有相似距离的源时频繁重新选择，将为当前未选择的源的距离添加固定距离。这可以使用 reselectdist 指令进行设置。默认情况下，距离为 100 微秒。stratumweight 距离 stratumweight 指令设置当 chronyd 从可用源中选择同步源时，每个层应将多少距离添加到同步距离上。默认情况下，权重为 0.001 秒。这意味着，只有当距离之间的差异以毫秒为单位时，选择过程中的源层才重要。系统时钟精度精度 clockprecision 指令指定系统时钟的精度（以秒为单位）。chronyd 使用它来估计 NTP 测量中的最小噪声，并在 NTP 响应中随机化时间戳的低阶位。默认情况下，精度在启动时作为读取时钟的最短时间进行测量。 在大多数情况下，测量值效果很好。但是，它通常会高估精度，并且可能对 CPU 速度很敏感，CPU 速度会随着时间的推移而变化以节省功耗。在某些情况下，使用高精度时钟源（例如 CPU 的时间戳计数器）和硬件时间戳，将服务器上的精度设置为较小的值可以提高客户端 NTP 测量的稳定性。服务器的精度由 ntpdata 命令在客户端上报告。将精度设置为 8 纳秒的示例如下： clockprecision 8e-9 corrtimeratio ratio 当 chronyd 摆动系统时钟以校正偏移时，它摆动的速率会增加时钟的频率误差。在所有受支持的系统上，除 macOS 12 及更早版本外，都可以控制此速率。corrtimeratio 指令设置根据源历史记录进行平均校正的时钟摆动持续时间与进行校正的时间间隔（通常是 NTP 轮询间隔）之间的比率。大于平均值的校正花费的时间更少，更小的校正花费的时间更多，校正量和校正时间成反比。增加 corrtimeratio 可改善系统时钟的总体频率误差，但随着校正时间的延长，总时间误差会增加。默认情况下，该比率设置为 3，时钟的时间精度优于其频率精度。允许的最大压摆率可以通过 maxslewrate 指令设置。当前剩余校正在跟踪报告中显示为系统时间值。driftfile 文件 chronyd 程序的主要活动之一是计算出系统时钟相对于实时增加或失去时间的速率。 每当chronyd计算出增益或损失率的新值时，都希望将其记录在某处。这允许chronyd在重新启动时开始以该速率补偿系统时钟，甚至在它有机会在新运行期间获得同样好的速率估计之前。（此过程至少需要几分钟。driftfile 指令允许指定一个文件，chronyd 可以在其中存储速率信息。文件中记录了两个参数。首先是系统时钟增加或失去时间的速率，以百万分之一表示，增益为正。因此，值 100.0 表示当系统时钟前进一秒时，它在现实中增加了 100 微秒（因此实际时间仅前进了 999900 微秒）。第二个是围绕第一个值的误差边界的估计值，真实速率实际位于该值中。driftfile 指令的一个示例是： driftfile /var/lib/chrony/drift fallbackdrift min-interval max-interval 回退漂移是在呈指数增长的间隔内计算的系统时钟漂移的长期平均值。它们用于避免在较长时间内未更新时钟时快速偏离真实时间，并且在更新停止之前漂移存在短期偏差。该指令指定自上次时钟更新以来的最小和最大间隔，以在回退漂移之间切换。它们被定义为 2 的幂（以秒为单位）。语法如下： fallbackdrift 16 19 在此示例中，最小间隔为 16（18 小时），最大间隔为 19（6 天）。系统时钟频率将设置为上次时钟更新后 18 小时的第一次回退，36 小时后设置为第二次回退，依此类推。 这可能是一个很好的设置，可以覆盖由于每日和每周温度波动而导致的频率变化。当频率设置为回退时，时钟的状态将更改为“不同步”。默认情况下（或者如果指定的最大值或最小值为 0），则不使用回退，并且时钟频率仅随着来自 NTP 源、参考时钟或手动输入的新测量而改变。leapsecmode 模式 闰秒是一种偶尔应用于 UTC 的调整，以使其接近平均太阳时。插入闰秒时，6 月或 12 月的最后一天会多出一秒 23：59：60。对于计算机时钟来说，这是一个问题。Unix 时间定义为自 1970 年 1 月 1 日 00：00：00 UTC 以来不含闰秒的秒数。根据定义，系统时钟不能有时间 23：59：60，每分钟有 60 秒，每天有 86400 秒。插入的闰秒被跳过，时钟突然比 UTC 提前一秒。leapsecmode 指令选择如何纠正该错误。有四个选项： 系统 插入闰秒时，内核在时钟达到 00：00：00 UTC 时将系统时钟向后退一秒。删除闰秒时，当时钟达到 UTC 时间 23：59：59 时，闰秒会向前移动一秒。这是系统驱动程序支持闰秒（即除 macOS 12 及更早版本外的所有受支持系统）的默认模式。step 这类似于系统模式，只是时钟是以 chronyd 而不是内核为步进的。避免在系统模式下执行的内核代码中的错误可能很有用。这是系统驱动程序不支持闰秒时的默认模式。 回转 当插入闰秒时，回转从 00：00：00 UTC 开始，或者在删除闰秒时从 23：59：59 UTC 开始，对时钟进行校正。当系统上运行的应用程序对系统时间的跳转很敏感，并且时钟关闭的时间更长是可以接受的，这可能优于系统和步进模式。在具有默认 maxslewrate 值的 Linux 上，更正需要 12 秒。ignore 不对闰秒的时钟进行校正。在正常操作中，当进行新的测量时，时钟将在稍后进行校正，并且估计的偏移量包括一秒误差。当系统上运行多个 chronyd 实例时，此选项特别有用，其中一个控制系统时钟，另一个以 -x 选项启动，该选项应依赖第一个实例来校正系统时钟，并忽略它来校正运行在系统时钟之上的自己的 NTP 时钟。当向无法配置为通过回摆将其时钟校正为闰秒的 NTP 客户端提供时间时，或者向需要使它们保持靠近时以略微不同的速率校正的客户端提供时间时，可以将回摆模式与 smoothtime 指令结合使用，以启用服务器飞跃拖尾。当拖尾闰秒时，服务器上的闰秒状态会被抑制，并且通过回转而不是步进来缓慢校正服务时间。客户端不需要任何特殊配置，因为他们不知道有任何闰秒，并且它们遵循服务器时间，最终将它们带回 UTC。必须注意确保他们只使用 NTP 服务器，这些服务器以完全相同的方式涂抹闰秒进行同步。 必须谨慎使用此功能，因为服务器故意不提供其对真实时间的最佳估计。启用服务器跳跃拖尾的推荐配置如下： leapsecmode slew maxslewrate 1000 smoothtime 400 0.001024 leaponly 第一个指令是禁用时钟步长所必需的，这将重置平滑过程。第二个指令将本地时钟的压摆率限制为 1000 ppm，这提高了局部校正开始和结束时平滑过程的稳定性。第三个指令启用服务器时间平滑过程。它将在时钟到达 00：00：00 UTC 时开始，需要 62500 秒（约 17.36 小时）才能完成。频率偏移将以每秒 0.001024 ppm 的速度变化，并将在 31250 秒内达到最大 32 ppm。leaponly 选项使跳跃拖尾的持续时间恒定，并允许客户端安全地与多个配置相同的飞跃拖尾服务器同步。闰拖尾的持续时间可以从指定的 wander 计算为 duration = sqrt（4 / wander） leapsectz 时区 此指令指定系统时区数据库中的时区，chronyd 可以使用该时区来确定下一个闰秒何时出现以及 TAI 和 UTC 之间的当前偏移量是多少。它将定期检查 23：59：59 和 23：59：60 是否为时区的有效时间。这通常适用于正确的/UTC 时区。当宣布闰秒时，时区需要在闰秒前至少 12 小时更新。没有必要重新启动chronyd。此指令对于参考时钟和其他不宣布闰秒的时间源很有用，或者宣布闰秒的时间太晚，NTP 服务器无法将它们转发到自己的客户端。 跳跃拖尾服务器的客户端不得使用此指令。当需要系统时钟具有正确的 TAI-UTC 偏移量时，它也很有用。请注意，仅当内核处理闰秒时才设置偏移量，即 leapsecmode 设置为 system。指定的时区不用作有关闰秒的独家信息来源。如果大多数时间源在 6 月或 12 月的最后一天宣布应插入或删除闰秒，则即使闰秒未包含在时区中，也会被接受。该指令的一个示例是： leapsectz right/UTC 以下 shell 命令验证时区是否包含闰秒，并且可以与此指令一起使用： $ TZ=right/UTC date -d 'Dec 31 2008 23：59：60' Wed Dec 31 23：59：60 UTC 2008 makestep 阈值限制 通常 chronyd 将导致系统逐渐纠正任何时间偏移， 根据需要减慢或加快时钟。在某些情况下，例如，当chronyd最初启动时，系统时钟可能会漂移得太远，以至于这个回转过程需要很长时间来纠正系统时钟。如果调整大于阈值，则此指令强制 chronyd 步进系统时钟，但前提是自 chronyd 启动以来没有比指定限制更多的时钟更新。负值禁用限制。在大多数系统上，最好只在启动时步进系统时钟，然后再启动依赖于时间单调前进的程序。使用此指令的一个示例是： makestep 0.1 3 如果调整大于 0.1 秒，这将步进系统时钟，但仅在前三个时钟更新中。maxchange offset start ignore 此指令设置在时钟更新时校正的最大允许偏移量。 只有在指定数量的更新之后才执行检查，以允许对系统时钟进行较大的初始调整。当发生大于指定最大值的偏移量时，它将被忽略指定的次数，然后 chronyd 将放弃并退出（可以使用负值从不退出）。在这两种情况下，都会向 syslog 发送一条消息。使用此指令的一个示例是： maxchange 1000 1 2 在第一次时钟更新后，chronyd 将检查每次时钟更新的偏移量，它将忽略两个大于 1000 秒的调整，并在另一个调整时退出。maxclockerror error-in-ppm maxclockerror 指令设置系统时钟在时钟更新之间可以自行获得的最大假定频率误差。它描述了时钟的稳定性。默认情况下，最大误差为 1 ppm。对于使用温度补偿晶体振荡器的低质量时钟，以 ppm 为单位的误差的典型值可能为 10，对于高质量时钟，误差 0.1。maxdrift drift-in-ppm 此指令指定系统时钟的最大假定漂移（频率误差）。它限制了chronyd用于校正测量漂移的频率调整。这是系统驱动程序可以设置的最大调整的附加限制（Linux 上为 100000 ppm，FreeBSD、NetBSD 和 macOS 10.13+ 上为 500 ppm，illumos 上为 32500 ppm）。默认情况下，最大假定漂移为 500000 ppm，即调整受系统驱动程序而不是此指令的限制。maxupdateskew skew-in-ppm chronyd 的任务之一是计算计算机的时钟相对于其参考源的运行速度。此外，它还计算围绕估计值的误差边界的估计值。 如果误差范围过大，则可能表明测量尚未稳定下来，并且估计的增益或损失率不是很可靠。maxupdateskew 指令设置阈值，用于确定估计值是否非常不可靠，以至于不应使用。默认情况下，阈值为 1000 ppm。对于通过无线网络轮询的 NTP 源，偏斜 ppm 的典型值可能为 100，对于本地有线网络上的源，偏斜 ppm 的典型值可能为 10 或更小。应该指出的是，这并不是防止使用不可靠估计的唯一手段。在任何时候，chronyd都会跟踪估计的收益或损失率，以及估计的误差限制。当在来自其中一个源的另一个测量值后生成新估计值时，将使用加权组合算法来更新主值估计值。因此，如果 chronyd 具有现有的高度可靠的主估计值，并且生成了具有较大误差范围的新估计值，则现有主估计值将在新的主估计值中占主导地位。maxslewrate rate-in-ppm maxslewrate 指令设置允许 chronyd 压摆时间的最大速率。它限制了由校正时间比（可通过 corrtimeratio 指令设置）控制的压摆率，并且仅在 chronyd 能够控制速率的系统（即除 macOS 12 或更早版本外的所有受支持系统）上有效。对于每个系统，驱动器可以设置时钟的最大频率偏移。在 Linux 上是 100000 ppm，在 FreeBSD、NetBSD 和 macOS 10.13+ 上是 5000 ppm，在 illumos 上是 32500 ppm。此外，由于内核限制，在 FreeBSD、NetBSD、macOS 10 上设置 maxslewrate。13+ 设置为 500 ppm 和 5000 ppm 之间的值将有效地将其设置为 500 ppm。默认情况下，最大压摆率设置为 83333.333 ppm（十二分之一）。tempcomp 文件间隔 T0 k0 k1 k2，tempcomp 文件间隔点-文件 通常，系统时钟漂移速率的变化主要是由于主板上晶体振荡器温度的变化引起的。如果振荡器附近的传感器提供温度测量值，则可以使用 tempcomp 指令来补偿温度变化并提高时钟的稳定性和精度。结果取决于许多因素，包括传感器的分辨率、测量中的噪声量、时间源的轮询间隔、补偿更新间隔、补偿的指定程度以及传感器与振荡器的接近程度。当它工作正常时，tracking.log文件中报告的频率更稳定，最大达到的偏移量更小。该指令有两种形式。第一个参数有六个参数：包含传感器当前温度的文件路径（文本格式）、补偿更新间隔（以秒为单位）和温度系数 T0、k0、k1、k2。频率补偿的计算方法（以 ppm 为单位）为 comp = k0 + （T - T0） * k1 + （T - T0）^2 * k2 结果必须在 -10 ppm 和 10 ppm 之间，否则测量将被视为无效并被忽略。可以调整 k0 系数以保持补偿在该范围内。使用示例如下： tempcomp /sys/class/hwmon/hwmon0/temp2_input 30 26000 0.0 0.000183 0.0 测量的温度将每 30 秒从 Linux sysfs 文件系统中的文件中读取一次。 当温度为 26000 （26 摄氏度） 时，频率校正将为零。当它达到 27000（27 摄氏度）时，时钟将设置为运行速度加快 0.183 ppm，依此类推。第二种形式有三个参数：传感器文件的路径、更新间隔和包含（温度、补偿）点列表的文件的路径，补偿从中线性插值或外推。例如：tempcomp /sys/class/hwmon/hwmon0/temp2_input 30 /etc/chrony.tempcomp，其中 /etc/chrony.tempcomp 文件可以有 20000 1.0 21000 0.64 22000 0.36 23000 0.16 24000 0.04 25000 0.0 26000 0.04 27000 0.16 28000 0.36 29000 0.64 30000 1.0 如果 log tempcomp 指令启用了，则具有相应补偿的有效测量值将记录到 tempcomp.log 文件中。NTP 服务器允许 [all] [子网] allow 指令用于将允许 NTP 客户端从该子网访问计算机的特定子网指定为 NTP 服务器。当在服务器上启用 NTS 时，它还控制对 NTS-KE 客户端的访问。默认情况下不允许任何客户端访问，即 chronyd 纯粹作为 NTP 客户端运行。如果使用 allow 指令，chronyd 既是其服务器的客户端，又是其他客户端的服务器。此指令可以多次使用。该指令的使用示例如下： allow 1.2.3.4 allow 3.4.5.0/24 allow 3.4.5 allow 2001：db8：：/32 allow 0/0 allow ：：/0 allow 第一个指令允许从 IPv4 地址进行访问。第二个指令允许从 CIDR 表示法中指定的 IPv4 子网中的所有计算机进行访问。第三个指令使用更简单的表示法指定相同的子网，其中前缀长度由点数决定。第四个指令指定 IPv6 子网。 第五和第六条指令分别允许从所有 IPv4 和 IPv6 地址进行访问。第七条指令允许从所有地址（IPv4 或 IPv6）进行访问。指令的第二种形式 allow all 具有更大的效果，具体取决于配置文件中指令的顺序。为了说明效果，请考虑两个示例： allow 1.2.3.4 deny 1.2.3.0/24 allow 1.2.0.0/16 and allow 1.2.3.4 deny 1.2.3.0/24 allow all 1.2.0.0/16 在第一个示例中，无论三个指令的给出顺序如何，效果都是相同的。因此，允许访问 1.2.0.0/16 子网，但 1.2.3.0/24 子网除外，该子网被拒绝访问，但允许主机 1.2.3.4 访问。在第二个示例中，allow all 1.2.0.0/16 指令将覆盖与指定子网中的子网相关的任何先前指令的效果。在配置文件中，此功能可能没有实际意义;但是，它更有助于在运行时通过 chronyc 使用 allow all 命令进行重新配置。这些规则在内部表示为表树，每 4 位 IPv4 或 IPv6 地址有一个级别。如果 allow 和 deny 指令修改一个表的相同记录，即如果一个子网包含在另一个子网中并且它们的前缀长度处于同一级别，则 allow 和 deny 指令的顺序很重要。例如，1.2.3.0/28 和 1.2.3.0/29 位于不同的表中，但 1.2.3.0/25 和 1.2.3.0/28 位于同一表中。可以使用chronyc中的accheck命令验证单个地址的配置。可以在指令中指定主机名而不是 IP 地址，但是在启动 chronyd 时，该名称必须是可解析的，即网络已经启动并且 DNS 正在工作。 如果主机名解析为多个地址，则仅允许或拒绝第一个地址（按系统解析程序返回的顺序）。注意，如果在配置文件中使用了 initstepslew 指令，则该指令中列出的每台计算机都必须允许此计算机进行客户端访问才能使其正常工作。deny [all] [subnet] 这与 allow 指令类似，不同之处在于它拒绝 NTP 和 NTS-KE 客户端对特定子网或主机的访问，而不是允许它。语法是相同的，指令也可以多次使用。还有一个 deny all 指令，其行为与 allow all 指令类似。bindaddress 地址 bindaddress 指令将 chronyd 侦听 NTP 和 NTS-KE 请求的套接字绑定到计算机的本地地址。在 Linux 以外的系统上，启动 chronyd 时需要已经配置了计算机的地址。该指令的使用示例如下： bindaddress 192.168.1.1 目前，对于每个 IPv4 和 IPv6 协议，只能指定一个 bindaddress 指令。因此，在应在多个网络接口上提供 NTP 的计算机上，它没有用。binddevice 接口 binddevice 指令将 NTP 和 NTS-KE 服务器套接字绑定到接口名称指定的网络设备。此指令只能指定一个接口，并且仅在 Linux 上受支持。该指令的一个示例是： binddevice eth0 broadcast interval address [port] broadcast 指令用于声明一个广播地址，chronyd 应该在 NTP 广播模式下向该地址发送数据包（即使 chronyd 充当广播服务器）。该子网上的广播客户端将能够同步。此指令可以多次用于指定多个地址。 语法如下： broadcast 32 192.168.1.255 broadcast 64 192.168.2.255 12123 broadcast 64 ff02：：101 在第一个示例中，目标端口默认为 UDP 端口 123（普通 NTP 端口）。在第二个示例中，目标端口指定为 12123。每种情况下的第一个参数（分别为 32 或 64）是发送广播数据包之间的间隔（以秒为单位）。在每种情况下，第二个参数是要将数据包发送到的广播地址。这应该对应于运行chronyd的计算机上其中一个网络接口的广播地址。如果要向其发送 NTP 广播数据包的网络接口超过 1 个，则可以有 1 个以上的广播指令。chronyd 本身不能充当广播客户端;必须始终通过定义特定的 NTP 服务器和对等方将其配置为点对点客户端。此广播服务器功能旨在为其他 NTP 实现提供时间源。如果使用 ntpd 作为广播客户端，它将尝试使用正常客户端模式数据包测量服务器和客户端之间的往返延迟。因此，广播子网也应是 allow 指令的主题。clientloglimit limit 此指令指定 chronyd 被允许为记录客户端访问分配的最大内存量，以及 chronyd 作为 NTP 服务器支持其客户端的交错模式所需的状态。默认限制为 524288 字节，这样可以同时监视多达 4096 个 IP 地址，并使用交错模式为多达 4096 个客户端保留 NTP 时间戳（取决于其轮询间隔的均匀性）。地址和时间戳的数量始终是 2 的幂。 最大有效值为 2147483648 （2 GB），对应16777216地址和时间戳。使用此指令的一个示例是： clientloglimit 1048576 noclientlog 此指令不带任何参数，指定不记录客户端访问。通常，它们会被记录下来，允许使用 chronyc 中的 clients 命令报告统计信息。此选项还有效地禁用服务器对 NTP 交错模式的支持。本地 [选项]...本地指令启用本地引用模式，该模式允许作为 NTP 服务器运行的 chronyd 显示为实时同步（从轮询它的客户端的角度来看），即使它从未同步或时钟的最后一次更新发生在很久以前。该指令通常用于隔离网络，其中计算机需要相互同步，但不一定是实时的。通过手动输入，服务器可以模糊地与实时保持一致。本地指令具有以下选项： stratum stratum 此选项设置服务器的层，当本地引用处于活动状态时，该层将报告给客户端。指定的值在 1 到 15 的范围内，默认值为 10。当外部 NTP 服务器可访问时，它应大于网络中的最大预期层。第 1 层表示具有直接连接到其的真实实时参考的计算机（例如 GPS、原子钟等），此类计算机预计非常接近实时。第 2 层计算机是具有第 1 层服务器的计算机;第 3 层计算机具有第 2 层服务器，依此类推。值为 10 表示时钟与参考时钟相距甚远，以至于其时间相当不可靠。 距离距离 此选项设置根距离的阈值，该阈值将激活局部参照。如果chronyd已同步到某个源，则在根距离达到指定值之前，不会激活本地参考（距离增加的速率取决于时钟跟踪源的程度）。默认值为 1 秒。当前根距离可以根据根延迟和根离散（由 chronyc 中的跟踪命令报告）计算为：距离 = 延迟 / 2 + 离散孤儿 此选项启用特殊的“孤立”模式，其中层等于局部层的源被假定为不提供实时服务。除非没有其他可选择的源，并且其引用 ID 小于本地引用 ID，否则将忽略它们。这允许网络中的多个服务器使用相同的本地配置并相互同步，而不会混淆轮询多个服务器的客户端。每个服务器都需要配置为使用 local 指令轮询所有其他服务器。这可确保只有具有最小引用 ID 的服务器具有活动的本地引用，而其他引用则同步到该引用。如果该服务器停止响应，则当其本地引用模式激活时，具有第二小引用 ID 的服务器将接管（根距离达到距离选项配置的阈值）。孤立模式与 ntpd 的孤立模式兼容（由 tos orphan 命令启用）。该指令的一个示例是： local stratum 10 orphan distance 0.1 ntpsigndsocket directory 此指令指定 Samba ntp_signd 套接字作为域控制器 （DC） 运行时的位置。 如果使用此功能编译 chronyd，则对 MS-SNTP 客户端的响应将由 smbd 守护程序签名。请注意，MS-SNTP 请求未经过身份验证，任何允许通过 allow 指令或 chronyc 中的 allow 命令访问服务器的客户端都可以获取使用信任帐户密码签名的 MS-SNTP 响应，并尝试在暴力攻击中破解密码。应仔细控制对服务器的访问。该指令的一个示例是： ntpsigndsocket /var/lib/samba/ntp_signd ntsport port 此指令指定 chronyd 将在其上提供 NTS 密钥建立 （NTS-KE） 服务的 TCP 端口。默认端口为 4460。仅当 ntsservercert 和 ntsserverkey 指令指定证书和密钥时，端口才会打开。ntsservercert 文件 此指令指定一个包含 PEM 格式证书的文件，以便 chronyd 作为 NTS 服务器运行。该文件还应包括客户端验证服务器证书所需的任何中间证书。删除 root 权限后，运行 chronyd 的用户需要可读取该文件。此指令可以多次用于为服务器的不同名称指定多个证书。文件仅加载一次。需要重新启动 chronyd 才能加载续订的证书。建议使用带有 chronyd 的 -r 选项的 ntsdumpdir 和 dumpdir 指令来实现近乎无缝的服务器操作。ntsserverkey 文件 此指令指定一个包含 PEM 格式私钥的文件，以便 chronyd 作为 NTS 服务器运行。删除 root 权限后，运行 chronyd 的用户需要可读取该文件。出于安全原因，其他用户不应读取它。 此指令可以多次用于指定多个键。密钥数必须与证书数相同，并且必须按相同的顺序指定相应的文件。ntsprocesses 进程 此指令指定有多少个帮助程序进程将作为 NTS 服务器启动，用于处理客户端 NTS-KE 请求，以提高多核 CPU 和多线程的性能。如果设置为 0，则不会启动辅助进程，所有 NTS-KE 请求都将由主 chronyd 进程处理。默认值为 1。maxntsconnections connections 此指令指定 NTS 服务器将接受的每个进程的最大并发 NTS-KE 连接数。默认值为 100。最大实用值是系统FD_SETSIZE常数的一半（通常为 1024）。ntsdumpdir 目录 此指令指定一个目录，在该目录中，作为 NTS 服务器运行的 chronyd 可以保存用于加密提供给客户端的 NTS cookie 的密钥。密钥将保存到名为 ntskeys 的单个文件中。当 chronyd 重新启动时，重新加载密钥允许客户端继续使用旧的 cookie，并避免 NTS-KE 请求的风暴。默认情况下，服务器不保存密钥。该指令的一个示例是： ntsdumpdir /var/lib/chrony NTS 客户端也使用此目录来保存 NTS cookie。ntsntpserver 主机名 此指令指定 NTP 服务器的主机名（作为完全限定的域名）或地址，该服务器在对客户端的 NTS-KE 响应中提供。它允许将 NTS-KE 服务器与 NTP 服务器分开。但是，服务器需要共享密钥，即需要通过将 ntsrotate 设置为 0 来启用外部密钥管理。 默认情况下，不会向客户端提供主机名或地址，这意味着它们应将同一服务器用于 NTS-KE 和 NTP。ntsrotate interval 此指令指定用于加密 NTS cookie 的服务器密钥的轮换间隔（以秒为单位）。新密钥会从 /dev/urandom 设备自动生成。服务器保留两个以前的密钥，以便客户端有时间获取由最新密钥加密的新 cookie。该间隔以服务器的运行时间来衡量，即如果 chronyd 没有连续运行，则实际间隔可能会更长。默认间隔为 604800 秒（1 周）。最大值为 2^31-1（68 年）。可以通过将 ntsrotate 设置为 0 来禁用按键的自动旋转。在这种情况下，假定密钥在外部进行管理。chronyd 不会将密钥保存到 ntskeys 文件中，而是在 chronyc 中发出 rekey 命令时从文件中重新加载密钥。可以定期从运行 chronyd（未将 ntsrotate 设置为 0）的另一台服务器复制该文件，以便有一台或多台专用于 NTS-KE 的服务器。NTS-KE 服务器需要使用 ntsntpserver 指令进行配置，以将客户端指向正确的 NTP 服务器。该指令的一个示例是： ntsrotate 2592000 port port 此选项允许您配置 chronyd 将侦听 NTP 请求的端口。仅当 chronyc 中的 allow 指令或 allow 命令允许地址、配置 NTP 对等体或启用广播服务器模式时，端口才会打开。默认值为 123，即标准 NTP 端口。如果设置为 0，chronyd 将永远不会打开服务器端口，并将严格在仅限客户端的模式下运行。NTP 客户端请求中使用的源端口可以通过 acquisitionport 指令进行设置。 ratelimit [选项]...此指令启用 NTP 数据包的响应速率限制。其目的是减少配置错误或损坏的 NTP 客户端的网络流量，这些客户端轮询服务器过于频繁。这些限制适用于单个 IP 地址。如果多个客户端共享一个 IP 地址（例如，NAT 后面的多个主机），则其流量总和将受到限制。如果检测到客户端在未收到回复时提高了轮询速率，则其速率限制将暂时暂停，以避免增加总流量。可以同时监控的最大 IP 地址数取决于 clientloglimit 指令设置的内存限制。ratelimit 指令支持许多选项（可以按任何顺序定义）： interval interval 此选项设置响应之间的最小间隔。它被定义为 2 秒的幂。默认值为 3（8 秒）。最小值为 -19（每秒 524288 个数据包），最大值为 12（每 4096 秒一个数据包）。请注意，当值低于 -4 时，速率限制是粗略的（允许在突发中响应，即使它们之间的间隔短于指定的间隔）。突发响应 此选项设置突发中可以发送的最大响应数，暂时超过间隔选项指定的限制。这对于在启动时进行快速测量的客户端很有用（例如，带有 iburst 选项的 chronyd）。默认值为 8。最小值为 1，最大值为 255。泄漏率 此选项设置随机允许响应的速率，即使超出了间隔和突发选项指定的限制也是如此。 这是防止使用欺骗源地址发送请求的攻击者完全阻止对该地址的响应所必需的。泄漏率定义为 1/2 的幂，默认为 2，即平均每四个请求中至少有一个响应。最小值为 1，最大值为 4。该指令的一个示例用法是： ratelimit interval 1 burst 16 这将使平均每 2 秒发送数据包超过一次的 IP 地址的响应率降低，或者以超过 16 个数据包的突发方式发送数据包，最多可降低 75%（默认泄漏为 2）。ntsratelimit [选项]...此指令启用 NTS-KE 请求的速率限制。它类似于 ratelimit 指令，但默认间隔为 6（每 64 秒 1 个连接）。使用该指令的一个示例是： ntsratelimit interval 3 burst 1 smoothtime max-freq max-wander [leaponly] smoothtime 指令可用于平滑 chronyd 为其客户端服务的时间，使他们更容易跟踪它并保持他们的时钟靠近，即使对服务器的时钟应用了较大的偏移或频率校正， 例如，在离线时间较长之后。请注意：服务器故意不提供其对真实时间的最佳估计。如果累积了较大的偏移量，则可能需要很长时间才能将其平滑。仅当客户端未配置为轮询另一个 NTP 服务器时，才应使用此指令，因为它们可能会拒绝此服务器作为虚假代码或无法完全选择源。平滑过程是通过具有两个或三个部分的二次样条函数实现的。 它独立于应用于本地系统时钟的任何回摆，但当时钟通过步进校正时，累积的偏移和频率将被重置，例如通过chronyc中的makestep指令或makestep命令。该过程可以通过 smoothtime reset 命令在不步进时钟的情况下重置。该指令的前两个参数是平滑时间到跟踪的 NTP 时间的最大频率偏移量（以 ppm 为单位）和允许频率偏移量变化的最大速率（以 ppm 每秒为单位）。LeapOnly 是可选的第三个参数，它启用一种模式，在该模式中，仅平滑闰秒并忽略正常偏移和频率变化。leaponly 选项与 leapsecmode slew 指令结合使用时很有用，允许客户端安全地使用多个时间平滑服务器。当本地时钟的估计偏差的 1/10000 低于最大频率变化率时，将自动激活平滑过程。它也可以通过 smoothtime activate 命令手动激活，当时钟仅与手动输入同步且偏移始终大于阈值时，这特别有用。平滑命令可用于监视过程。适用于使用 ntpd 和 1024 秒轮询间隔的客户端的示例可以是： smoothtime 400 0.001 适合在 Linux 上使用 chronyd 的客户端的示例可以是： smoothtime 50000 0.01 命令和监视访问 bindcmdaddress 地址 bindcmdaddress 指令指定一个本地 IP 地址，chronyd 将监听监视命令数据包（由 chronyc 发出）的 UDP 套接字绑定到该地址。在 Linux 以外的系统上，启动 chronyd 时需要已经配置了接口的地址。 此指令还可以更改 Unix 域命令套接字的路径，chronyc 使用该套接字发送配置命令。套接字必须位于只有 root 用户或长期用户才能访问的目录中。如果该目录不存在，则将在启动时创建该目录。套接字的编译默认路径为 /run/chrony/chronyd.sock。可以通过将路径设置为 / 来禁用套接字。默认情况下，chronyd 将 UDP 套接字绑定到地址 127.0.0.1 和 ：：1（即环回接口）。这将阻止除 localhost 之外的所有访问。要侦听所有接口上的命令数据包，可以在配置文件中添加以下行：bindcmdaddress 0.0.0.0 bindcmdaddress ：：。对于每个 IPv4、IPv6 和 Unix 域协议，只能指定一个 bindcmdaddress 指令。设置 Unix 域命令套接字路径的示例如下： bindcmdaddress /var/run/chrony/chronyd.sock bindcmddevice 接口 bindcmddevice 指令将 UDP 命令套接字绑定到接口名称指定的网络设备。此指令只能指定一个接口，并且仅在 Linux 上受支持。该指令的一个示例是： bindcmddevice eth0 cmdallow [all] [subnet] 这类似于 allow 指令，不同之处在于它允许监视对特定子网或主机的访问（而不是 NTP 客户端访问）。（“监视访问”是指 chronyc 可以在这些主机上运行，并从此计算机上的 chronyd 中检索监视数据。语法与 allow 指令相同。还有一个 cmdallow all 指令，其行为与 allow all 指令类似（当然，在这种情况下适用于监视访问）。 请注意，chronyd 必须配置为 bindcmdaddress 指令，使其不仅在环回接口上侦听，才能实际允许远程访问。cmddeny [all] [subnet] 这类似于 cmdallow 指令，只是它拒绝监视对特定子网或主机的访问，而不是允许它。语法是相同的。还有一个 cmddeny all 指令，其行为与 cmdallow all 指令类似。cmdport port cmdport 指令允许将用于运行时监视的端口（通过 chronyc 程序）从默认值 （323） 更改。如果设置为 0，chronyd 将不会打开端口，这对于禁用来自 Internet 的 chronyc 访问很有用。（它不会禁用 Unix 域命令套接字。示例显示了语法： cmdport 257 这将使 chronyd 使用 UDP 257 作为其命令端口。（chronyc 需要与 -p 257 开关一起运行才能正确互操作。cmdratelimit [选项]...此指令启用命令数据包的响应速率限制。它类似于 ratelimit 指令，只是对 localhost 的响应从不受到限制，默认间隔为 -4（每秒 16 个数据包）。该指令的一个使用示例是： cmdratelimit 间隔 2 实时时钟 （RTC） hwclockfile 文件 hwclockfile 指令设置 Linux 上的 hwclock 程序使用的 adjtime 文件的位置。chronyd 解析文件以了解 RTC 是否保留本地时间或 UTC。它覆盖了 rtconutc 指令。编译的默认值为 '/etc/adjtime'。该指令的一个示例是： hwclockfile /etc/adjtime rtcautotrim threshold rtcautotrim 指令用于使 RTC 自动接近系统时钟。 当系统时钟同步并且两个时钟之间的估计误差大于指定的阈值时，chronyd 将修剪 RTC，就像发出了 chronyc 中的 trimrtc 命令一样。微调操作精确到只有大约 1 秒，这是最小有效阈值。此指令仅对 rtcfile 指令有效。使用此指令的一个示例是：rtcautotrim 30 这会将阈值错误设置为 30 秒。rtcdevice 设备 rtcdevice 指令设置用于访问 RTC 的设备文件的路径。默认路径为 /dev/rtc。rtcfile 文件 rtcfile 指令定义了文件的名称，chronyd 可以在其中保存与跟踪 RTC 准确性相关的参数。该指令的一个示例是：rtcfile /var/lib/chrony/rtc chronyd 在退出时和 chronyc 中发出 writertc 命令时将信息保存在此文件中。保存的信息是 RTC 在某个纪元、该纪元（自 1970 年 1 月 1 日以来以秒为单位）的误差，以及 RTC 获得或失去时间的速率。到目前为止，对实时时钟的支持是有限的;他们的代码甚至比软件的其他部分更特定于系统。只有在满足以下三个条件的情况下，才能使用 RTC 工具（rtcfile 指令和 chronyd 的 -s 命令行选项）： 1. 您运行的是 Linux。2. 内核是用扩展的实时时钟支持编译的（即 /dev/rtc 设备能够做一些有用的事情）。3. 您根本没有其他需要使用 /dev/rtc 的应用程序。默认情况下，rtconutc chronyd 假定 RTC 保留本地时间（包括任何夏令时更改）。这在运行 Linux 且使用 Windows 双启动的 PC 上非常方便。 如果将 RTC 保持在本地时间，并且计算机在夏令时（夏令时）开始或结束时处于关闭状态，则下次启动并启动 chronyd 时，计算机的系统时间将错误一小时。另一种方法是让 RTC 保持世界协调时间 （UTC）。这不会受到夏令时开始或结束时的 1 小时问题的影响。如果出现 rtconutc 指令，则表示需要 RTC 来保持 UTC。该指令不接受任何参数。它等同于指定 Linux hwclock 程序的 -u 开关。请注意，此设置被 hwclockfile 文件覆盖，与 rtcsync 指令无关。rtcsync rtcsync 指令启用一种模式，在该模式下，系统时间定期复制到 RTC，并且 chronyd 不会尝试跟踪其漂移。此指令不能与 rtcfile 指令一起使用。在 Linux 上，内核每 11 分钟执行一次 RTC 复制。在 macOS 上，当系统时钟处于同步状态时，chronyd 将每 60 分钟执行一次 RTC 复制。在其他系统上，此指令不执行任何操作。日志记录日志 [选项]...log 指令指示要记录某些信息。日志文件将写入 logdir 指令指定的目录。会定期向文件写入一个横幅，以指示列的含义。原始测量值 此选项将原始 NTP 测量值和相关信息记录到名为 measurements.log 的文件中。为从源接收的每个数据包创建一个条目。这在调试问题时非常有用。日志文件中的示例行（实际上在文件中显示为单行）如下所示。2016-11-09 05：40：50 203.0.113.15 N 2 111 111 1111 10 10 1.0 \ -4.966e-03 2.296e-01 1.577e-05 1.615e-01 7.446E-03 CB00717B 4B D K 列如下（方括号中的数量是上面示例行中的值）： 1. 日期 [2015-10-13] 2.时：分：秒。请注意，日期-时间对以 UTC 表示，而不是本地时区。[05:40:50] 3.测量来源的服务器或对等体的 IP 地址 [203.0.113.15] 4.闰窕状态（N 表示正常，+ 表示当月最后一分钟有 61 秒，- 表示当月最后一分钟有 59 秒，？ 表示远程计算机当前未同步。[N] 5.远程计算机的层。[2] 6.RFC 5905 测试 1 到 3（1 = 通过，0 = 失败） [111] 7.RFC 5905 测试 5 到 7（1 = 通过，0 = 失败） [111] 8.根据定义的参数测试最大延迟、最大延迟比和最大延迟开发比，以及同步循环测试（1=通过，0=失败）[1111] 9.本地民意调查 [10] 10.远程投票 [10] 11.“分数”（每个轮询级别内的内部分数，用于决定何时增加或减少轮询级别。这是根据当前用于回归算法的测量数量进行调整的。[1.0] 12.估计的本地时钟误差（RFC 5905 中的 theta）。正值表示远程源的本地时钟较慢。[-4.966E-03] 13.对等延迟（RFC 5905 中的增量）。[2.296E-01] 14.对等色散（RFC 5905 中的 epsilon）。[1.577E-05] 15.根延迟（RFC 5905 中的 DELTA）。[1.615E-01] 16.根部分散（RFC 5905 中的 EPSILON）。[7.446E-03] 17.服务器源的引用 ID 为十六进制数。[CB00717B] 18.接收数据包的 NTP 模式（1 = 主动对等体，2 = 被动对等体，4 = 服务器，B=基本对等体，I=交错）。[4B] 19.本地传输时间戳的来源（D=守护进程，K=内核，H=硬件）。[D] 20. 本地接收时间戳的来源（D=守护进程，K=内核，H=硬件）。[K] 测量值 此选项与原始测量值选项相同，只是它仅记录来自同步源的有效测量值，即通过 RFC 5905 测试 1 到 7 的测量值。这对于生成源性能图非常有用。统计 此选项将有关回归处理的信息记录到名为 statistics.log 的文件中。日志文件中的示例行（实际上在文件中显示为单行）如下所示。2016-08-10 05：40：50 203.0.113.15 6.261e-03 -3.247e-03 \ 2.220e-03 1.874e-06 1.080e-06 7.8e-02 16 0 8 0.00 列如下（方括号中的数量是上面示例行中的值）： 1. 日期 [2015-07-22] 2.时：分：秒。请注意，日期-时间对以 UTC 表示，而不是本地时区。[05:40:50] 3.用于测量的服务器或对等体的 IP 地址 [203.0.113.15] 4.测量值与源的估计标准偏差（以秒为单位）。[6.261E-03] 5.源的估计偏移量（以秒为单位，在本例中为正表示本地时钟估计为快）。[-3.247E-03]6. 偏移估计值的估计标准差（以秒为单位）。[2.220E-03] 7.本地时钟相对于源获得或失去时间的估计速率（以秒/秒为单位，正表示本地时钟正在增加）。这是相对于当前应用于本地时钟的补偿而言的，而不是与没有任何补偿的本地时钟有关。[1.874E-06] 8.速率值中的估计误差（以秒/秒为单位）。[1.080E-06]. 9.|old_rate - new_rate|/ old_rate_error。 较大的值表示统计数据未很好地对源进行建模。[7.8E-02] 10.当前用于回归算法的测量值数。[16] 11.新的起始指数（最老的样本的指数为 0;这是当测量值不再适合线性模型时用于修剪旧样本的方法）。[0，即这次没有丢弃样品] 12.运行次数。计算具有相同符号的回归残差的运行次数。如果这太小，则表明测量值不再由线性模型很好地表示，并且需要丢弃一些较旧的样本。将保留的数据的运行次数制成表格。预计值约为样本数的一半。[8] 13.源路径上网络抖动的估计或配置不对称性，用于校正测量的偏移。不对称性可以在 -0.5 和 +0.5 之间。负值表示发送到源的数据包的延迟比从源发送回的数据包的延迟变化更大。[0.00，即不对不对称进行校正] 跟踪 此选项将对系统增益或损失率估计值的更改以及所做的任何摆率记录到名为 tracking.log 的文件中。日志文件中的示例行（实际上在文件中显示为单行）如下所示。2017-08-22 13：22：36 203.0.113.15 2 -3.541 0.075 -8.621e-06 N \ 2 2.940e-03 -2.084e-04 1.534e-02 3.472e-04 8.304e-03 列如下（方括号中的数量是上面示例行中的值）： 1. 日期 [2017-08-22] 2.时：分：秒。请注意，日期-时间对以 UTC 表示，而不是本地时区。[13:22:36] 3. 本地系统同步到的服务器或对等体的 IP 地址。[203.0.113.15] 4.本地系统的层。[2] 5.本地系统频率（以 ppm 为单位，正数表示本地系统在 UTC 运行速度很快）。[-3.541]6. 频率的误差范围（以 ppm 为单位）。[0.075] 7.纪元处估计的局部偏移量，通常通过摆动本地时钟来校正（以秒为单位，正数表示时钟速度快于UTC）。[-8.621E-06]8. 闰状态（N 表示正常，+ 表示本月最后一分钟有 61 秒，- 表示本月的最后一分钟有 59 秒，？ 表示时钟当前未同步。[N] 9.组合源的数量。[2] 10.组合偏移的估计标准差（以秒为单位）。[2.940E-03] 11.上次更新的剩余偏移校正（以秒为单位，正值表示系统时钟低于 UTC）。[-2.084E-04] 12.网络路径延迟到本地时钟最终同步到的参考时钟的总和（以秒为单位）。[1.534E-02] 13.通过所有服务器累积的总色散回到本地时钟最终同步的参考时钟（以秒为单位）。[3.472E-04] 14.自上次更新以来的时间间隔内系统时钟的最大估计误差（以秒为单位）。它包括偏移量、剩余偏移校正、根延迟和上一次更新的色散，以及区间内累积的色散。[8.304E-03] RTC 此选项记录有关系统实时时钟的信息。下面显示了 rtc.log 文件中的示例行（实际上在文件中显示为一行）。2015-07-22 05:40:50 -0.037360 1 -0.037434\ -37.948 12 5 120 各栏如下（方括号内的数量为上述示例行中的值）： 1. 日期 [2015-07-22] 2.时：分：秒。请注意，日期-时间对以 UTC 表示，而不是本地时区。[05:40:50] 3.RTC和系统时钟之间的测量偏移，以秒为单位。正值表示 RTC 在系统时间 [-0.037360] 中速度快。4. 指示回归是否产生了有效系数的标志。（1 表示是，0 表示否）。[1] 5.回归过程预测的当前时间的偏移量。该值与测量偏移量之间的较大差异往往表明测量值是具有严重测量误差的异常值。[-0.037434]6. RTC 相对于系统时钟损失或增加时间的速率。以 ppm 为单位，正表示 RTC 正在增加时间。[-37.948]7. 回归中使用的测量次数。[12] 8.同一符号的回归残差的运行次数。低值表示直线不再是测量数据的良好模型，应丢弃较旧的测量值。[5] 9.进行测量之前使用的测量间隔（以秒为单位）。[120] refclocks 此选项将原始和滤波后的参考时钟测量值记录到名为 refclocks.log 的文件中。日志文件中的示例行（实际上在文件中显示为单行）如下所示。2009-11-30 14：33：27.000000 PPS2 7 N 1 4.900000e-07 -6.741777e-07 1.000e-06 列如下（方括号中的数量是上面示例行中的值）： 1. 日期 [2009-11-30] 2.小时：分钟：秒.微秒。请注意，日期-时间对以 UTC 表示，而不是本地时区。[14:33:27.000000] 3. 测量来源的参考时钟的参考 ID。[缴费品2]4. 对于一个轮询间隔内，原始样本或 - 对于过滤样本，驱动程序轮询的序列号。[7] 5.闰状态（N 表示正常，+ 表示当月最后一分钟有 61 秒，- 表示当月最后一分钟有 59 秒）。[N] 6.指示样品是否来自 PPS 来源的标志。（1 表示是，0 表示否，或 - 表示过滤样品）。[1] 7.通过参考时钟驱动器测量的本地时钟误差，或者对于滤波样本进行-测量。[4.900000E-07] 8.应用校正的本地时钟错误。正值表示本地时钟较慢。[-6.741777E-07]9.假设样品的分散性。[1.000e-06] tempcomp 此选项将温度测量值和系统速率补偿记录到名为 tempcomp.log 的文件中。日志文件中的示例行（实际上在文件中显示为单行）如下所示。2015-04-19 10：39：48 2.8000e+04 3.6600e-01 列如下（方括号中的数量是上面示例行中的值）： 1. 日期 [2015-04-19] 2.时：分：秒。请注意，日期-时间对以 UTC 表示，而不是本地时区。[10:39:48] 3.从传感器读取温度。[2.8000e+04]4. 应用补偿单位 ppm，正表示系统时钟运行速度比没有补偿时快。[3.6600e-01] 该指令的一个示例是： 日志度量 统计信息 跟踪 logbanner 条目 定期将横幅写入 log 指令启用的日志文件中，以指示列的含义。logbanner 指令指定在日志文件中写入的条幅数之后。默认值为 32,0 可用于完全禁用它。 logchange threshold 此指令设置将生成 syslog 消息的系统时钟调整的阈值。通过 NTP 数据包、参考时钟或通过 chronyc 的 settime 命令输入的时间戳检测到的时钟错误将被记录下来。默认情况下，阈值为 1 秒。使用的一个例子是：logchange 0.1，如果系统时钟错误超过 0.1 秒开始得到补偿，则会导致生成 syslog 消息。logdir 目录 此指令指定 log 指令启用的用于写入日志文件的目录。如果该目录不存在，则会自动创建该目录。使用此指令的一个示例是： logdir /var/log/chrony mailonchange email threshold 此指令定义了如果 chronyd 对系统时钟应用超过特定阈值的更正，则应将邮件发送到该电子邮件地址。使用此指令的一个示例是： mailonchange root@localhost 0.5 如果对系统时钟应用了超过 0.5 秒的更改，这将向 root 发送邮件消息。当 -F 选项启用系统调用过滤器时，不能使用此指令，因为不允许 chronyd 进程分叉和执行 sendmail 二进制文件。杂项 confdir 目录...confdir 指令包含目录中带有 .conf 后缀的配置文件。这些文件按文件名的字典顺序包含在内。可以使用单个 confdir 指令指定多个目录（最多 10 个）。在这种情况下，如果多个目录包含同名文件，则仅包含指定目录顺序的第一个文件。这将启用分段配置，其中可以通过将文件添加到其他目录来替换现有片段。 此指令可以多次使用。该指令的一个示例是：confdir /etc/chrony/chrony.d sourcedir directory...sourcedir 指令与 confdir 指令相同，只是配置文件具有 .sources 后缀，它们只能指定 NTP 源（即服务器、池和对等指令），它们应所有行都以换行符结尾，并且可以通过 chronyc 中的 reload sources 命令重新加载。它对于动态源（如从 DHCP 服务器接收的 NTP 服务器）特别有用，这些源可以通过网络脚本写入特定于网络接口的文件。此指令可以多次使用。该指令的一个示例是： sourcedir /var/run/chrony-dhcp include pattern include 指令包括一个配置文件，如果指定了通配符模式，则包含多个配置文件。与 confdir 指令不同，需要指定文件的全名，并且至少需要存在一个文件。此指令可以多次使用。该指令的一个例子是：include /etc/chrony/chrony.d/*.conf hwtimestamp interface [option]...此指令启用发送到指定网络接口和从指定网络接口接收的 NTP 数据包的硬件时间戳。网络接口控制器 （NIC） 使用自己的时钟来准确标记实际传输和接收的时间，从而避免内核、网络驱动程序和硬件中的处理和排队延迟。这可以显著提高时间戳和测量偏移的精度，用于系统时钟的同步。为了获得最佳结果，接收和发送NTP数据包的双方（即服务器和客户端，或两个对等体）都需要使用硬件时间戳。 如果服务器或对等体支持交错模式，则需要通过服务器中的 xleave 选项或对等指令来启用。此指令在 Linux 3.19 及更高版本上受支持。网卡必须支持硬件时间戳，这可以通过 ethtool -T 命令进行验证。功能列表应包括 SOF_TIMESTAMPING_RAW_HARDWARE、SOF_TIMESTAMPING_TX_HARDWARE 和 SOF_TIMESTAMPING_RX_HARDWARE。接收过滤器HWTSTAMP_FILTER_ALL（HWTSTAMP_FILTER_NTP_ALL）对于接收到的 NTP 数据包进行时间戳是必需的。Linux 4.13 及更高版本支持对桥接和绑定接口上接收的数据包进行时间戳。当 chronyd 运行时，没有其他进程（例如 PTP 守护进程）应该与 NIC 时钟一起工作。如果内核支持软件时间戳，则将为所有接口启用它。如果日志测量指令启用了时间戳（即硬件、内核或守护程序），则时间戳的来源会在 measurements.log 文件中指示，而 ntpdata 报告则在 chronyc 中指示。此指令可以多次使用，以在多个接口上启用硬件时间戳。如果指定的接口是*，chronyd将尝试在所有可用接口上启用硬件时间戳。hwtimestamp 指令具有以下选项： minpoll poll 此选项指定 NIC 时钟读数之间的最小间隔。它被定义为 2 的幂。它应对应于所有 NTP 源的最小轮询间隔和 NTP 客户端的最小预期轮询间隔。默认值为 0（1 秒），最小值为 -6（1/64 秒）。minsamples samples 此选项指定为跟踪 NIC 时钟而保留的最小读数数。默认值为 2。 maxsamples samples 此选项指定为跟踪 NIC 时钟而保留的最大读数数。默认值为 16。precision precision 此选项指定 NIC 时钟读取的假定精度。默认值为 100e-9（100 纳秒）。txcomp 补偿 此选项指定物理层的实际传输时间与报告的传输时间戳之间的秒差。此值将添加到传输从 NIC 获取的时间戳。默认值为 0。rxcomp 补偿 此选项指定报告的接收时间戳与物理层的实际接收时间之间的秒差。将从从 NIC 获取的接收时间戳中减去此值。默认值为 0。nocrossts 某些硬件可以精确地将 NIC 时钟与系统时钟的时间戳交叉。此选项禁止使用交叉时间戳。rxfilter filter 此选项选择接收时间戳筛选器。筛选器可以是以下选项之一： all 启用所有接收的数据包的时间戳。ntp 启用接收的 NTP 数据包的时间戳。ptp 启用接收到的 PTP 数据包的时间戳。none 禁用接收数据包的时间戳。默认情况下，NIC 支持的 NTP 数据包时间戳的最具体筛选器处于选中状态。某些 NIC 只能对 PTP 数据包进行时间戳。默认情况下，它们将配置无过滤器，并应仅为传输的数据包提供硬件时间戳。PTP 数据包的时间戳对于 ptpport 指令启用的 NTP-over-PTP 非常有用。 如果 NIC 同时支持 all 和 ntp 过滤器，并且它应该同时为 NTP 和 PTP 数据包或不同 UDP 端口上的 NTP 数据包添加时间戳，则使用 all 筛选器强制对所有数据包进行时间戳可能很有用。该指令的示例包括： hwtimestamp eth0 hwtimestamp eth1 txcomp 300e-9 rxcomp 645e-9 hwtimestamp * keyfile file 此指令用于指定包含对称密钥的文件的位置，这些密钥在 NTP 服务器和客户端或对等方之间共享，以便使用加密哈希函数或密码通过消息身份验证代码 （MAC） 对 NTP 数据包进行身份验证。指令的格式如下例所示： keyfile /etc/chrony/chrony.keys 参数只是包含 ID 密钥对的文件的名称。文件格式如下图所示： 10 郁金香 11 风信子 20 MD5 ASCII：番红花 25 SHA1 十六进制：933F62BE1D604E68A81B557F18CFA200483F5B70 30 AES128 十六进制：7EA62AE64D190114D46D5A082F948EC1 31 AES256 十六进制：37DDCBC67BB902BCB8E995977FAB4D2B5642F5B32EBCEEE421921D97E5CBFE39 ...每行都由一个 ID、可选类型和键组成。ID 可以是 1 到 2^32-1 范围内的任何正整数。类型是用于生成和验证 MAC 的加密哈希函数或密码的名称。默认类型为 MD5，始终受支持。如果 chronyd 是在使用加密库（nettle、nss 或 libtomcrypt）支持哈希的情况下构建的，则可以使用以下函数：MD5、SHA1、SHA256、SHA384、SHA512。根据 chronyd 使用的库和版本，以下一些哈希函数和密码也可能可用：SHA3-224、SHA3-256、SHA3-384、SHA3-512、TIGER、WHIRLPOOL、AES128、AES256。 该键可以指定为不包含带有可选 ASCII： 前缀的空格的 ASCII 字符字符串，也可以指定为带有 HEX： 前缀的十六进制数。该行的最大长度为 2047 个字符。如果类型是密码，则密钥的长度必须与密码匹配（即 AES128 为 128 位，AES256 为 256 位）。建议使用以十六进制格式指定的随机生成的密钥，这些密钥的长度至少为 128 位（即它们在十六进制：前缀后至少有 32 个字符）。如果在配置文件中指定了密钥短于 80 位的源，chronyd 将在启动时向 syslog 记录警告。推荐的密钥类型是 AES 密码和 SHA3 哈希函数。除非服务器和客户端或对等方不支持其他类型，否则应避免使用 MD5。chronyc 的 keygen 命令可用于为密钥文件生成随机密钥。默认情况下，它生成 160 位 MD5 或 SHA1 密钥。出于安全原因，该文件应该只能由 root 和通常运行 chronyd 的用户读取（以允许 chronyd 在 chronyc 发出 rekey 命令时重新读取文件）。lock_all lock_all 指令会将 chronyd 进程锁定到 RAM 中，这样它就永远不会被分页。这可以导致更低、更一致的延迟。该指令在 Linux、FreeBSD、NetBSD 和 illumos 上受支持。pidfile 文件 除非使用 -Q 选项启动 chronyd，否则它会将其进程 ID （PID） 写入文件，并在启动时检查此文件以查看系统上是否已运行另一个 chronyd。默认情况下，使用的文件是 /run/chrony/chronyd.pid。pidfile 指令允许更改名称，例如：pidfile /run/chronyd。pid ptpport 端口 ptpport 指令使 chronyd 能够发送和接收 PTP 事件消息 （NTP-over-PTP） 中包含的 NTP 消息，以在 NIC 上启用硬件时间戳，这些 NIC 不能为 NTP 数据包添加时间戳，但可以为单播 PTP 数据包添加时间戳。NIC 识别的端口为 319（PTP 事件端口）。默认值为 0（禁用）。NTP-over-PTP 支持是实验性的。协议和配置将来可能会更改。它应该只在本地网络中使用，并且只能在运行相同版本的 chronyd 的服务器和客户端之间工作。即使 chronyd 未配置为作为服务器或客户端运行，PTP 端口也将打开。该指令不会更改指定 NTP 源的默认协议。每个应使用 NTP-over-PTP 的 NTP 源都需要指定将端口选项设置为 PTP 端口。要在只能对 PTP 数据包进行时间戳的 NIC 上实际启用硬件时间戳，需要将 hwtimestamp 指令的 rxfilter 选项设置为 ptp。客户端配置的一个示例是： server foo.example.net minpoll 0 maxpoll 0 xleave port 319 hwtimestamp * rxfilter ptp ptpport 319 sched_priority优先级 在 Linux、FreeBSD、NetBSD 和 illumos 上，sched_priority 指令将以指定的优先级（必须在 0 到 100 之间）选择SCHED_FIFO实时调度器。在 macOS 上，此选项的值必须为 0（默认值）才能禁用线程时间约束策略，或者必须具有 1 才能启用策略。在 macOS 以外的系统上，此指令使用 pthread_setschedparam（） 系统调用来指示内核对具有指定优先级的 chronyd 使用SCHED_FIFO先进先出的实时调度策略。 这意味着每当chronyd准备好运行时，它就会运行，中断其他正在运行的任何事情，除非它是更高优先级的实时进程。这应该不会影响性能，因为 chronyd 资源需求适中，但它应该会导致更低、更一致的延迟，因为 chronyd 不需要等待调度程序来运行它。除非你真的需要它，否则你不应该使用它。pthread_setschedparam（3） 手册页提供了更多详细信息。在 macOS 上，此指令使用 thread_policy_set（） 内核调用来指定实时调度。如上所述，除非确实需要，否则不应使用此指令。user user user user 设置系统用户的名称，chronyd 在启动后将切换到该用户名，以便删除 root 权限。在 Linux 上，chronyd 需要编译时支持 libcap 库。在 macOS 上， FreeBSD， NetBSD 和 illumos chronyd 分叉为两个进程。子进程保留根权限，但只能代表父进程执行非常有限的特权系统调用。编译的默认值为 _chrony。

EXAMPLES

   NTP client with permanent connection to NTP servers
       This section shows how to configure chronyd for computers that are connected to the
       Internet (or to any network containing true NTP servers which ultimately derive their time
       from a reference clock) permanently or most of the time.

       To operate in this mode, you will need to know the names of the NTP servers you want to
       use. You might be able to find names of suitable servers by one of the following methods:

       •   Your institution might already operate servers on its network. Contact your system
           administrator to find out.

       •   Your ISP probably has one or more NTP servers available for its customers.

       •   Somewhere under the NTP homepage there is a list of public stratum 1 and stratum 2
           servers. You should find one or more servers that are near to you. Check that their
           access policy allows you to use their facilities.

       •   Use public servers from the pool.ntp.org <https://www.pool.ntp.org/> project.

       Assuming that your NTP servers are called foo.example.net, bar.example.net and
       baz.example.net, your chrony.conf file could contain as a minimum:

           server foo.example.net
           server bar.example.net
           server baz.example.net

       However, you will probably want to include some of the other directives. The driftfile,
       makestep and rtcsync might be particularly useful. Also, the iburst option of the server
       directive is useful to speed up the initial synchronisation. The smallest useful
       configuration file would look something like:

           server foo.example.net iburst
           server bar.example.net iburst
           server baz.example.net iburst
           driftfile /var/lib/chrony/drift
           makestep 1.0 3
           rtcsync

       When using a pool of NTP servers (one name is used for multiple servers which might change
       over time), it is better to specify them with the pool directive instead of multiple
       server directives. The configuration file could in this case look like:

           pool pool.ntp.org iburst
           driftfile /var/lib/chrony/drift
           makestep 1.0 3
           rtcsync

       If the servers (or pool) support the Network Time Security (NTS) authentication mechanism
       and chronyd is compiled with NTS support, the nts option will enable a secure
       synchronisation to the servers. The configuration file could look like:

           server foo.example.net iburst nts
           server bar.example.net iburst nts
           server baz.example.net iburst nts
           driftfile /var/lib/chrony/drift
           makestep 1.0 3
           rtcsync

   NTP client with infrequent connection to NTP servers
       This section shows how to configure chronyd for computers that have occasional connections
       to NTP servers. In this case, you will need some additional configuration to tell chronyd
       when the connection goes up and down. This saves the program from continuously trying to
       poll the servers when they are inaccessible.

       Again, assuming that your NTP servers are called foo.example.net, bar.example.net and
       baz.example.net, your chrony.conf file would now contain:

           server foo.example.net offline
           server bar.example.net offline
           server baz.example.net offline
           driftfile /var/lib/chrony/drift
           makestep 1.0 3
           rtcsync

       The offline keyword indicates that the servers start in an offline state, and that they
       should not be contacted until chronyd receives notification from chronyc that the link to
       the Internet is present. To tell chronyd when to start and finish sampling the servers,
       the online and offline commands of chronyc need to be used.

       To give an example of their use, assuming that pppd is the program being used to connect
       to the Internet and that chronyc has been installed at /usr/bin/chronyc, the script
       /etc/ppp/ip-up would include:

           /usr/bin/chronyc online

       and the script /etc/ppp/ip-down would include:

           /usr/bin/chronyc offline

       chronyd's polling of the servers would now only occur whilst the machine is actually
       connected to the Internet.

   Isolated networks
       This section shows how to configure chronyd for computers that never have network
       connectivity to any computer which ultimately derives its time from a reference clock.

       In this situation, one computer is selected to be the primary timeserver. The other
       computers are either direct clients of the server, or clients of clients.

       The local directive enables a local reference mode, which allows chronyd to appear
       synchronised even when it is not.

       The rate value in the server’s drift file needs to be set to the average rate at which the
       server gains or loses time. chronyd includes support for this, in the form of the manual
       directive and the settime command in the chronyc program.

       If the server is rebooted, chronyd can re-read the drift rate from the drift file.
       However, the server has no accurate estimate of the current time. To get around this, the
       system can be configured so that the server can initially set itself to a ‘majority-vote’
       of selected clients' times; this allows the clients to ‘flywheel’ the server while it is
       rebooting.

       The smoothtime directive is useful when the clocks of the clients need to stay close
       together when the local time is adjusted by the settime command. The smoothing process
       needs to be activated by the smoothtime activate command when the local time is ready to
       be served. After that point, any adjustments will be smoothed out.

       A typical configuration file for the server (called ntp.local) might be (assuming the
       clients and the server are in the 192.168.165.x subnet):

           initstepslew 1 client1 client3 client6
           driftfile /var/lib/chrony/drift
           local stratum 8
           manual
           allow 192.168.165.0/24
           smoothtime 400 0.01
           rtcsync

       For the clients that have to resynchronise the server when it restarts, the configuration
       file might be:

           server ntp.local iburst
           driftfile /var/lib/chrony/drift
           allow 192.168.165.0/24
           makestep 1.0 3
           rtcsync

       The rest of the clients would be the same, except that the allow directive is not
       required.

       If there is no suitable computer to be designated as the primary server, or there is a
       requirement to keep the clients synchronised even when it fails, the orphan option of the
       local directive enables a special mode where the server is selected from multiple
       computers automatically. They all need to use the same local configuration and poll one
       another. The server with the smallest reference ID (which is based on its IP address) will
       take the role of the primary server and others will be synchronised to it. When it fails,
       the server with the second smallest reference ID will take over and so on.

       A configuration file for the first server might be (assuming there are three servers
       called ntp1.local, ntp2.local, and ntp3.local):

           initstepslew 1 ntp2.local ntp3.local
           server ntp2.local
           server ntp3.local
           driftfile /var/lib/chrony/drift
           local stratum 8 orphan
           manual
           allow 192.168.165.0/24
           rtcsync

       The other servers would be the same, except the hostnames in the initstepslew and server
       directives would be modified to specify the other servers. Their clients might be
       configured to poll all three servers.

   RTC tracking
       This section considers a computer which has occasional connections to the Internet and is
       turned off between ‘sessions’. In this case, chronyd relies on the computer’s RTC to
       maintain the time between the periods when it is powered up. It assumes that Linux is run
       exclusively on the computer. Dual-boot systems might work; it depends what (if anything)
       the other system does to the RTC. On 2.6 and later kernels, if your motherboard has a
       HPET, you will need to enable the HPET_EMULATE_RTC option in your kernel configuration.
       Otherwise, chronyd will not be able to interact with the RTC device and will give up using
       it.

       When the computer is connected to the Internet, chronyd has access to external NTP servers
       which it makes measurements from. These measurements are saved, and straight-line fits are
       performed on them to provide an estimate of the computer’s time error and rate of gaining
       or losing time.

       When the computer is taken offline from the Internet, the best estimate of the gain or
       loss rate is used to free-run the computer until it next goes online.

       Whilst the computer is running, chronyd makes measurements of the RTC (via the /dev/rtc
       interface, which must be compiled into the kernel). An estimate is made of the RTC error
       at a particular RTC second, and the rate at which the RTC gains or loses time relative to
       true time.

       When the computer is powered down, the measurement histories for all the NTP servers are
       saved to files, and the RTC tracking information is also saved to a file (if the rtcfile
       directive has been specified). These pieces of information are also saved if the dump and
       writertc commands respectively are issued through chronyc.

       When the computer is rebooted, chronyd reads the current RTC time and the RTC information
       saved at the last shutdown. This information is used to set the system clock to the best
       estimate of what its time would have been now, had it been left running continuously. The
       measurement histories for the servers are then reloaded.

       The next time the computer goes online, the previous sessions' measurements can contribute
       to the line-fitting process, which gives a much better estimate of the computer’s gain or
       loss rate.

       One problem with saving the measurements and RTC data when the machine is shut down is
       what happens if there is a power failure; the most recent data will not be saved. Although
       chronyd is robust enough to cope with this, some performance might be lost. (The main
       danger arises if the RTC has been changed during the session, with the trimrtc command in
       chronyc. Because of this, trimrtc will make sure that a meaningful RTC file is saved after
       the change is completed).

       The easiest protection against power failure is to put the dump and writertc commands in
       the same place as the offline command is issued to take chronyd offline; because chronyd
       free-runs between online sessions, no parameters will change significantly between going
       offline from the Internet and any power failure.

       A final point regards computers which are left running for extended periods and where it
       is desired to spin down the hard disc when it is not in use (e.g. when not accessed for 15
       minutes). chronyd has been planned so it supports such operation; this is the reason why
       the RTC tracking parameters are not saved to disc after every update, but only when the
       user requests such a write, or during the shutdown sequence. The only other facility that
       will generate periodic writes to the disc is the log rtc facility in the configuration
       file; this option should not be used if you want your disc to spin down.

       To illustrate how a computer might be configured for this case, example configuration
       files are shown.

       For the chrony.conf file, the following can be used as an example.

           server foo.example.net maxdelay 0.4 offline
           server bar.example.net maxdelay 0.4 offline
           server baz.example.net maxdelay 0.4 offline
           logdir /var/log/chrony
           log statistics measurements tracking
           driftfile /var/lib/chrony/drift
           makestep 1.0 3
           maxupdateskew 100.0
           dumpdir /var/lib/chrony
           rtcfile /var/lib/chrony/rtc

       pppd is used for connecting to the Internet. This runs two scripts /etc/ppp/ip-up and
       /etc/ppp/ip-down when the link goes online and offline respectively.

       The relevant part of the /etc/ppp/ip-up file is:

           /usr/bin/chronyc online

       and the relevant part of the /etc/ppp/ip-down script is:

           /usr/bin/chronyc -m offline dump writertc

       chronyd is started during the boot sequence with the -r and -s options. It might need to
       be started before any software that depends on the system clock not jumping or moving
       backwards, depending on the directives in chronyd's configuration file.

       For the system shutdown, chronyd should receive a SIGTERM several seconds before the final
       SIGKILL; the SIGTERM causes the measurement histories and RTC information to be saved.

   Public NTP server
       chronyd can be configured to operate as a public NTP server, e.g. to join the pool.ntp.org
       <https://www.pool.ntp.org/en/join.html> project. The configuration is similar to the NTP
       client with permanent connection, except it needs to allow client access from all
       addresses. It is recommended to find at least four good servers (e.g. from the pool, or on
       the NTP homepage). If the server has a hardware reference clock (e.g. a GPS receiver), it
       can be specified by the refclock directive.

       The amount of memory used for logging client accesses can be increased in order to enable
       clients to use the interleaved mode even when the server has a large number of clients,
       and better support rate limiting if it is enabled by the ratelimit directive. The system
       timezone database, if it is kept up to date and includes the right/UTC timezone, can be
       used as a reliable source to determine when a leap second will be applied to UTC. The -r
       option with the dumpdir directive shortens the time in which chronyd will not be able to
       serve time to its clients when it needs to be restarted (e.g. after upgrading to a newer
       version, or a change in the configuration).

       The configuration file could look like:

           server foo.example.net iburst
           server bar.example.net iburst
           server baz.example.net iburst
           server qux.example.net iburst
           makestep 1.0 3
           rtcsync
           allow
           clientloglimit 100000000
           leapsectz right/UTC
           driftfile /var/lib/chrony/drift
           dumpdir /run/chrony


 永久连接到 NTP 服务器的 NTP 客户端 本节介绍如何为永久或大部分时间连接到 Internet（或连接到任何包含真正 NTP 服务器的网络，这些服务器最终从参考时钟获取时间）的计算机配置 chronyd。若要在此模式下运行，需要知道要使用的 NTP 服务器的名称。您可以通过以下方法之一找到合适的服务器名称： • 您的机构可能已经在其网络上运行服务器。请与系统管理员联系以了解情况。• 您的 ISP 可能有一台或多台 NTP 服务器可供其客户使用。• 在 NTP 主页下方的某个地方，有一个公共层 1 和层 2 服务器的列表。您应该找到离您最近的一台或多台服务器。检查他们的访问策略是否允许您使用他们的设施。• 使用 pool.ntp.org <https://www.pool.ntp.org/> 项目中的公共服务器。假设您的 NTP 服务器被称为 foo.example.net、bar.example.net 和 baz.example.net，您的 chrony.conf 文件至少可以包含： 服务器 foo.example.net 服务器 bar.example.net 服务器 baz.example.net 但是，您可能希望包含一些其他指令。driftfile、makestep 和 rtcsync 可能特别有用。此外，server 指令的 iburst 选项对于加快初始同步非常有用。最小的有用配置文件如下所示：服务器 foo.example.net iburst 服务器 bar.example.net iburst 服务器 baz.example.net iburst driftfile /var/lib/chrony/drift makestep 1。0 3 rtcsync 使用 NTP 服务器池时（一个名称用于多个服务器，可能会随时间而更改），最好使用 pool 指令而不是多个服务器指令来指定它们。在这种情况下，配置文件可能如下所示： pool pool.ntp.org iburst driftfile /var/lib/chrony/drift makestep 1.0 3 rtcsync 如果服务器（或池）支持网络时间安全 （NTS） 身份验证机制，并且 chronyd 是使用 NTS 支持编译的，则 nts 选项将启用与服务器的安全同步。配置文件可能如下所示： 服务器 foo.example.net iburst nts 服务器 bar.example.net iburst nts 服务器 baz.example.net iburst nts driftfile /var/lib/chrony/drift makestep 1.0 3 rtcsync NTP 客户端，与 NTP 服务器的连接不频繁 本节介绍如何为偶尔连接到 NTP 服务器的计算机配置 chronyd。在这种情况下，您将需要一些额外的配置来告诉 chronyd 连接何时启动和关闭。这样可以避免程序在服务器无法访问时不断尝试轮询服务器。同样，假设您的 NTP 服务器被称为 foo.example.net、bar.example.net 和 baz.example.net，您的 chrony.conf 文件现在将包含： 服务器 foo.example.net 离线服务器 bar.example.net 离线服务器 baz.example.net 离线 driftfile /var/lib/chrony/drift makestep 1.0 3 rtcsync offline 关键字指示服务器以脱机状态启动，并且在 chronyd 收到来自 chronyc 的通知之前，不应联系它们，指出存在指向 Internet 的链接。要告诉 chronyd 何时开始和完成对服务器的采样，需要使用 chronyc 的在线和离线命令。 举个例子来说明它们的使用，假设 pppd 是用于连接到 Internet 的程序，并且 chronyc 已安装在 /usr/bin/chronyc 中，则脚本 /etc/ppp/ip-up 将包括： /usr/bin/chronyc online，脚本 /etc/ppp/ip-down 将包括： /usr/bin/chronyc 离线 chronyd 对服务器的轮询现在只会在机器实际连接到 Internet 时发生。隔离网络 本节介绍如何为从未与任何计算机建立网络连接的计算机配置 chronyd，这些计算机最终从参考时钟获取时间。在这种情况下，选择一台计算机作为主时间服务器。其他计算机要么是服务器的直接客户端，要么是客户端的客户端。本地指令启用本地引用模式，即使 chronyd 不同步，它也允许它看起来同步。服务器偏移文件中的速率值需要设置为服务器获得或失去时间的平均速率。Chronyd 以 Chronyc 程序中的手动指令和 setTime 命令的形式支持此功能。如果服务器重新启动，chronyd 可以从漂移文件中重新读取漂移率。但是，服务器没有对当前时间的准确估计。为了解决这个问题，可以对系统进行配置，以便服务器最初可以将自己设置为所选客户端时间的“多数票”;这允许客户端在服务器重新启动时“飞轮”服务器。当客户端的时钟需要保持紧密时，当 settime 命令调整本地时间时，smoothtime 指令非常有用。当本地时间准备好提供时，需要通过 smoothtime activate 命令激活平滑过程。 在此之后，任何调整都将被平滑。服务器的典型配置文件（称为 ntp.local）可能是（假设客户端和服务器位于 192.168.165.x 子网中）： initstepslew 1 client1 client3 client6 driftfile /var/lib/chrony/drift local stratum 8 manual allow 192.168.165.0/24 smoothtime 400 0.01 rtcsync 对于在服务器重新启动时必须重新同步服务器的客户端，配置文件可能是： 服务器 ntp.local iburst driftfile /var/lib/chrony/drift allow 192.168.165.0/24 makestep 1.0 3 rtcsync 其余的客户端将是相同的，只是不需要 allow 指令。如果没有合适的计算机被指定为主服务器，或者即使客户端发生故障也需要保持客户端同步，则本地指令的孤立选项将启用一种特殊模式，在该模式下自动从多台计算机中选择服务器。它们都需要使用相同的本地配置并相互轮询。具有最小引用 ID（基于其 IP 地址）的服务器将充当主服务器的角色，其他服务器将同步到主服务器。当它发生故障时，具有第二小引用 ID 的服务器将接管，依此类推。第一台服务器的配置文件可能是（假设有三台服务器分别称为 ntp1.local、ntp2.local 和 ntp3.local）： initstepslew 1 ntp2.local ntp3.local 服务器 ntp2.local 服务器 ntp3.local driftfile /var/lib/chrony/drift local stratum 8 orphan manual allow 192.168.165.0/24 rtcsync 其他服务器是相同的，除了 initstepslew 中的主机名和 server 指令将被修改以指定其他服务器。他们的客户端可能配置为轮询所有三个服务器。 RTC 跟踪 本节考虑偶尔连接到 Internet 并在“会话”之间关闭的计算机。在这种情况下，chronyd 依靠计算机的 RTC 来维持其通电时间段之间的时间。它假定 Linux 以独占方式在计算机上运行。双引导系统可能会起作用;这取决于另一个系统对 RTC 做了什么（如果有的话）。在 2.6 及更高版本的内核上，如果您的主板具有 HPET，则需要在内核配置中启用HPET_EMULATE_RTC选项。否则，chronyd 将无法与 RTC 设备交互并放弃使用它。当计算机连接到互联网时，chronyd可以访问外部NTP服务器进行测量。这些测量值被保存下来，并对它们进行直线拟合，以提供计算机的时间误差和时间增失率的估计值。当计算机从 Internet 脱机时，增益或丢失率的最佳估计值用于自由运行计算机，直到它下次联机。当计算机运行时，chronyd 对 RTC 进行测量（通过 /dev/rtc 接口，该接口必须编译到内核中）。估计特定 RTC 秒的 RTC 误差，以及 RTC 相对于真实时间获得或失去时间的速率。当计算机断电时，所有NTP服务器的测量历史记录都将保存到文件中，并且RTC跟踪信息也将保存到文件中（如果已指定rtcfile指令）。如果分别通过 chronyc 发出 dump 和 writertc 命令，这些信息也会被保存。 当计算机重新启动时，chronyd 会读取当前 RTC 时间和上次关机时保存的 RTC 信息。此信息用于将系统时钟设置为最佳估计值，以估计其时间（如果系统保持连续运行）现在的时间。然后重新加载服务器的测量历史记录。下次计算机上线时，前一次会话的测量值可以有助于线路拟合过程，从而更好地估计计算机的增益或损耗率。机器关闭时保存测量值和 RTC 数据的一个问题是，如果发生电源故障，会发生什么情况;不会保存最新数据。尽管chronyd足够强大，可以应对这种情况，但可能会损失一些性能。（如果在会话期间更改了 RTC，则会出现主要危险，其中 trimrtc 命令在 chronyc 中。因此，trimrtc 将确保在更改完成后保存有意义的 RTC 文件。最简单的电源故障保护措施是将 dump 和 writertc 命令放在发出脱机命令以使 chronyd 脱机的同一位置;由于 chronyd 在在线会话之间自由运行，因此在从 Internet 离线和任何电源故障之间不会发生任何参数显着变化。最后一点是关于长时间运行的计算机，以及希望在不使用时（例如，15 分钟未访问时）降低硬盘速度的计算机。Chronyd 已经规划好了，所以它支持这样的操作;这就是为什么RTC跟踪参数在每次更新后都不会保存到光盘中，而仅在用户请求此类写入时或在关机序列期间保存到光盘上的原因。 唯一会生成定期写入光盘的其他工具是配置文件中的 log rtc 工具;如果您希望光盘降速，则不应使用此选项。为了说明如何针对这种情况配置计算机，下面显示了示例配置文件。对于chrony.conf文件，可以使用以下内容作为示例。服务器 foo.example.net maxdelay 0.4 离线服务器 bar.example.net maxdelay 0.4 离线服务器 baz.example.net maxdelay 0.4 离线 logdir /var/log/chrony 日志统计 测量 跟踪 driftfile /var/lib/chrony/drift makestep 1.0 3 maxupdateskew 100.0 dumpdir /var/lib/chrony rtcfile /var/lib/chrony/rtc pppd 用于连接到 Internet。当链接分别联机和脱机时，这将运行两个脚本 /etc/ppp/ip-up 和 /etc/ppp/ip-down。/etc/ppp/ip-up 文件的相关部分是：/usr/bin/chronyc online，/etc/ppp/ip-down 脚本的相关部分是：/usr/bin/chronyc -m 离线转储 writertc chronyd 在引导序列期间使用 -r 和 -s 选项启动。它可能需要在任何依赖于系统时钟不跳转或向后移动的软件之前启动，具体取决于 chronyd 配置文件中的指令。对于系统关闭，chronyd 应该在最终 SIGKILL 之前几秒钟收到 SIGTERM;SIGTERM 会保存测量历史记录和 RTC 信息。公共NTP服务器chronyd可以配置为作为公共NTP服务器运行，例如加入 pool.ntp.org <https://www.pool.ntp.org/en/join.html>项目。该配置类似于具有永久连接的 NTP 客户端，只是它需要允许来自所有地址的客户端访问。建议找到至少四个好的服务器（例如 从池中，或在 NTP 主页上）。如果服务器具有硬件参考时钟（例如 GPS 接收器），则可以通过 refclock 指令指定。可以增加用于记录客户端访问的内存量，以便即使服务器具有大量客户端，客户端也可以使用交错模式，并且如果通过 ratelimit 指令启用它，则更好地支持速率限制。如果系统时区数据库保持最新并包含正确的/UTC 时区，则可以用作确定何时将闰秒应用于 UTC 的可靠来源。带有 dumpdir 指令的 -r 选项缩短了 chronyd 在需要重新启动时（例如，在升级到较新版本或更改配置后）无法为其客户端提供时间的时间。配置文件可能如下所示：服务器 foo.example.net iburst 服务器 bar.example.net iburst 服务器 baz.example.net iburst 服务器 qux.example.net iburst makestep 1。0 3 rtcsync allow clientloglimit 1000000000 leapsectz right/UTC driftfile /var/lib/chrony/drift dumpdir /run/chrony
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

```bash
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

## 启用提供网络时间协议

若要启用提供 NTP，至少需要设置 `allow` 规则。这将控制要 `chrony` 向哪些客户端/网络提供 NTP。

例如：

```bash
allow 1.2.3.4
```

## Pulse-Per-Second (PPS) 每秒脉冲支持

`Chrony` supports various PPS types natively. It can use kernel PPS API as well  as Precision Time Protocol (PTP) hardware clocks. Most general GPS  receivers can be leveraged via GPSD. The latter (and potentially more)  can be accessed via **SHM** or via a **socket** (recommended). All of the above can be used to augment `chrony` with additional high quality time sources for better accuracy, jitter,  drift, and longer- or shorter-term accuracy. Usually, each kind of clock type is good at one of those, but non-perfect at the others. For more  details on configuration see some of the external PPS/GPSD resources  listed below.
 `Chrony` 原生支持各种 PPS 类型。它可以使用内核 PPS API 以及精确时间协议 （PTP） 硬件时钟。大多数通用 GPS 接收器都可以通过 GPSD 使用。后者（可能还有更多）可以通过 SHM 或套接字（推荐）访问。以上所有功能都可用于 `chrony` 增强额外的高质量时间源，以获得更好的精度、抖动、漂移以及长期或短期精度。通常，每种时钟类型都擅长其中一种，但在其他方面并不完美。有关配置的更多详细信息，请参阅下面列出的一些外部 PPS/GPSD 资源。

> **Note**: 注意：
>  As of the release of 20.04, there was a bug which - until fixed - you might want to [add this content]`(https://bugs.launchpad.net/ubuntu/+source/gpsd/+bug/1872175/comments/21)  to your `/etc/apparmor.d/local/usr.sbin.gpsd`.
> 从 20.04 版本开始，存在一个错误，在修复之前，您可能需要 [添加此内容] `(https://bugs.launchpad.net/ubuntu/+source/gpsd/+bug/1872175/comments/21)  to your ` /etc/apparmor.d/local/usr.sbin.gpsd'。

### Example configuration for GPSD to feed `chrony` GPSD 馈电 `chrony` 的示例配置

For the installation and setup you will first need to run the following command in your terminal window:
对于安装和设置，您首先需要在终端窗口中运行以下命令：

```bash
sudo apt install gpsd chrony
```

However, since you will want to test/debug your setup (especially the GPS reception), you should also install:
但是，由于您需要测试/调试您的设置（尤其是 GPS 接收），因此您还应该安装：

```auto
sudo apt install pps-tools gpsd-clients
```

GPS devices usually communicate via serial interfaces. The most common type these days are USB GPS devices, which have a serial converter behind  USB. If you want to use one of these devices for PPS then please be  aware that the majority do not signal PPS via USB. Check the [GPSD hardware](https://gpsd.gitlab.io/gpsd/hardware.html) list for details. The examples below were run with a Navisys GR701-W.
GPS设备通常通过串行接口进行通信。如今最常见的类型是 USB GPS 设备，它在 USB 后面有一个串行转换器。如果您想将这些设备之一用于 PPS，请注意，大多数设备不会通过 USB 向 PPS  发出信号。有关详细信息，请查看 GPSD 硬件列表。以下示例使用 Navisys GR701-W 运行。

When plugging in such a device (or at boot time) `dmesg` should report a serial connection of some sort, as in this example:
插入此类设备时（或在启动时） `dmesg` 应报告某种串行连接，如以下示例所示：

```plaintext
[   52.442199] usb 1-1.1: new full-speed USB device number 3 using xhci_hcd
[   52.546639] usb 1-1.1: New USB device found, idVendor=067b, idProduct=2303, bcdDevice= 4.00
[   52.546654] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   52.546665] usb 1-1.1: Product: USB-Serial Controller D
[   52.546675] usb 1-1.1: Manufacturer: Prolific Technology Inc. 
[   52.602103] usbcore: registered new interface driver usbserial_generic
[   52.602244] usbserial: USB Serial support registered for generic
[   52.609471] usbcore: registered new interface driver pl2303
[   52.609503] usbserial: USB Serial support registered for pl2303
[   52.609564] pl2303 1-1.1:1.0: pl2303 converter detected
[   52.618366] usb 1-1.1: pl2303 converter now attached to ttyUSB0
```

We see in this example that the device appeared as `ttyUSB0`. So that `chrony` later accepts being fed time information by this device, we have to set it up in `/etc/chrony/chrony.conf` (please replace `USB0` with whatever applies to your setup):
在此示例中，我们看到设备显示为 `ttyUSB0` .以便 `chrony` 以后接受此设备提供的时间信息，我们必须将其设置在 `/etc/chrony/chrony.conf` （请 `USB0` 替换为适用于您的设置的任何内容）：

```auto
refclock SHM 0 refid GPS precision 1e-1 offset 0.9999 delay 0.2
refclock SOCK /var/run/chrony.ttyUSB0.sock refid PPS
```

Next, we need to restart `chrony` to make the socket available and have it waiting.
接下来，我们需要重新启动 `chrony` 以使套接字可用并等待它。

```auto
sudo systemctl restart chrony
```

We then need to tell `gpsd` which device to manage. Therefore, in `/etc/default/gpsd` we set:
然后，我们需要告诉 `gpsd` 要管理哪个设备。因此，在我们 `/etc/default/gpsd` 设置：

```auto
DEVICES="/dev/ttyUSB0"
```

It should be noted that since the *default* use-case of `gpsd` is, well, for *gps position tracking*, it will normally not consume any CPU since it is just waiting on a **socket** for clients. Furthermore, the client will tell `gpsd` what it requests, and `gpsd` will only provide what is asked for.
应该注意的是，由于默认用例 `gpsd` 是 对于 gps 位置跟踪，它通常不会消耗任何 CPU，因为它只是在客户端的套接字上等待。此外，客户会说出 `gpsd` 它的要求，并且 `gpsd` 只会提供所要求的。

For the use case of `gpsd` as a PPS-providing-daemon, you want to set the option to:
对于作为 PPS 提供守护程序的 `gpsd` 用例，您需要将选项设置为：

- Immediately start (even without a client connected). This can be set in `GPSD_OPTIONS` of `/etc/default/gpsd`:
  立即启动（即使没有连接客户端）。这可以设置在以下位置 `/etc/default/gpsd` ： `GPSD_OPTIONS` 
  - `GPSD_OPTIONS="-n"`
- Enable the service itself and not wait for a client to reach the socket in the future:
  启用服务本身，而不是等待客户端将来到达套接字：
  - `sudo systemctl enable /lib/systemd/system/gpsd.service`

Restarting `gpsd` will now initialize the PPS from GPS and in `dmesg` you will see:
重新启动现在 `gpsd` 将从 GPS 初始化 PPS，您将看到 `dmesg` ：

```plaintext
 pps_ldisc: PPS line discipline registered
 pps pps0: new PPS source usbserial0
 pps pps0: source "/dev/ttyUSB0" added
```

If you have multiple PPS sources, the tool `ppsfind` may be useful to help identify which PPS belongs to which GPS. In our example, the command `sudo ppsfind /dev/ttyUSB0` would return the following:
如果您有多个 PPS 源，该工具 `ppsfind` 可能有助于识别哪个 PPS 属于哪个 GPS。在我们的示例中，该命令 `sudo ppsfind /dev/ttyUSB0` 将返回以下内容：

```plaintext
pps0: name=usbserial0 path=/dev/ttyUSB0
```

Now we have completed the basic setup. To proceed, we now need our GPS to get a lock. Tools like `cgps` or `gpsmon` need to report a 3D “fix” in order to provide accurate data. Let’s run the command `cgps`, which in our case returns:
现在我们已经完成了基本设置。要继续，我们现在需要我们的 GPS 来获得锁。工具喜欢 `cgps` 或 `gpsmon` 需要报告 3D“修复”以提供准确的数据。让我们运行命令，在我们的例子中，该命令 `cgps` 返回：

```plaintext
...
│ Status:         3D FIX (7 secs) ...
```

You would then want to use `ppstest` in order to check that you are really receiving PPS data. So, let us run the command `sudo ppstest /dev/pps0`, which will produce an output like this:
然后，您需要使用 `ppstest` 以检查您是否真的在接收 PPS 数据。因此，让我们运行命令 `sudo ppstest /dev/pps0` ，它将生成如下输出：

```plaintext
trying PPS source "/dev/pps0"
found PPS source "/dev/pps0"
ok, found 1 source(s), now start fetching data...
source 0 - assert 1588140739.099526246, sequence: 69 - clear  1588140739.999663721, sequence: 70
source 0 - assert 1588140740.099661485, sequence: 70 - clear  1588140739.999663721, sequence: 70
source 0 - assert 1588140740.099661485, sequence: 70 - clear  1588140740.999786664, sequence: 71
source 0 - assert 1588140741.099792447, sequence: 71 - clear  1588140740.999786664, sequence: 71
```

Ok, `gpsd` is now running, the GPS reception has found a fix, and it has fed this into `chrony`. Let’s check on that from the point of view of `chrony`.
好的， `gpsd` 现在正在运行，GPS 接收已找到修复程序，并且已将其输入 `chrony` .让我们从 的角度 `chrony` 来检查一下。

Initially, before `gpsd` has started or before it has a lock, these sources will be new and  “untrusted” - they will be marked with a “?” as shown in the example  below. If your devices remain in the “?” state (even after some time)  then `gpsd` is not feeding any data to `chrony` and you will need to debug why.
最初，在启动之前 `gpsd` 或锁定之前，这些源将是新的和“不受信任的” - 它们将标记为“？”，如下面的示例所示。如果您的设备仍处于“？”状态（即使在一段时间后），则 `gpsd` 不会向其 `chrony` 提供任何数据，您将需要调试原因。

```plaintext
chronyc> sources
210 Number of sources = 10
MS Name/IP address         Stratum Poll Reach LastRx Last sample               
===============================================================================
#? GPS                           0   4     0     -     +0ns[   +0ns] +/-    0ns
#? PPS                           0   4     0     -     +0ns[   +0ns] +/-    0ns
```

Over time, `chrony` will classify all of the unknown sources as “good” or “bad”.
随着时间的流逝， `chrony` 将所有未知来源分类为“好”或“坏”。
 In the example below, the raw GPS had too much deviation (± 200ms) but the PPS is good (± 63us).
在下面的示例中，原始 GPS 的偏差太大（± 200 毫秒），但 PPS 良好（± 63us）。

```plaintext
chronyc> sources
210 Number of sources = 10
MS Name/IP address        Stratum Poll Reach LastRx Last sample
===============================================================================
#x GPS                         0    4   177    24 -876ms[ -876ms] +/- 200ms
#- PPS                         0    4   177    21 +916us[ +916us] +/- 63us
^- chilipepper.canonical.com   2    6    37    53  +33us[ +33us]  +/- 33ms
```

Finally, after a while it used the hardware PPS input (as it was better):
最后，过了一会儿，它使用了硬件 PPS 输入（因为它更好）：

```plaintext
chronyc> sources
210 Number of sources = 10
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
#x GPS                           0   4   377    20   -884ms[ -884ms] +/-  200ms
#* PPS                           0   4   377    18  +6677ns[  +52us] +/-   58us
^- alphyn.canonical.com          2   6   377    20  -1303us[-1258us] +/-  114ms
```

The PPS might also be OK – but used in a combined way with the selected server, for example. See `man chronyc` for more details about how these combinations can look:
PPS 也可能没问题，但可以与所选服务器结合使用。有关这些组合的外观的更多详细信息，请参阅 `man chronyc` ：

```plaintext
chronyc> sources
210 Number of sources = 11
MS Name/IP address         Stratum Poll Reach LastRx Last sample               
===============================================================================
#? GPS                           0   4     0     -     +0ns[   +0ns] +/-    0ns
#+ PPS                           0   4   377    22   +154us[ +154us] +/- 8561us
^* chilipepper.canonical.com     2   6   377    50   -353us[ -300us] +/-   44ms
```

If you’re wondering if your SHM-based GPS data is any good, you can check on that as well. `chrony` will not only tell you if the data is classified as good or bad – using `sourcestats` you can also check the details:
如果您想知道基于 SHM 的 GPS 数据是否有用，您也可以检查一下。 `chrony` 不仅会告诉您数据是好是坏 - 您还可以检查 `sourcestats` 详细信息：

```plaintext
chronyc> sourcestats
210 Number of sources = 10
Name/IP Address            NP  NR  Span  Frequency  Freq Skew  Offset  Std Dev
==============================================================================
GPS                        20   9   302     +1.993     11.501   -868ms  1208us
PPS                         6   3    78     +0.324      5.009  +3365ns    41us
golem.canonical.com        15  10   783     +0.859      0.509   -750us   108us
```

You can also track the raw data that `gpsd` or other `ntpd`-compliant reference clocks are sending via shared memory by using `ntpshmmon`. Let us run the command `sudo ntpshmmon -o`, which should provide the following output:
您还可以使用 `ntpshmmon` 跟踪其他符合参考时钟的参考时钟通过共享内存发送的原始数据。 `gpsd` `ntpd` 让我们运行命令，该命令 `sudo ntpshmmon -o` 应提供以下输出：

```plaintext
ntpshmmon: version 3.20
#      Name          Offset       Clock                 Real                 L Prc
sample NTP1          0.000223854  1588265805.000223854  1588265805.000000000 0 -10
sample NTP0          0.125691783  1588265805.125999851  1588265805.000308068 0 -20
sample NTP1          0.000349341  1588265806.000349341  1588265806.000000000 0 -10
sample NTP0          0.130326636  1588265806.130634945  1588265806.000308309 0 -20
sample NTP1          0.000485216  1588265807.000485216  1588265807.000000000 0 -10
```

## NTS 支持

In Chrony 4.0 (which first appeared in Ubuntu 21.04 Hirsute) support for [Network Time Security “NTS”](https://www.networktimesecurity.org/) was added.
在 Chrony 4.0（首次出现在 Ubuntu 21.04 Hirsute 中）中，添加了对网络时间安全“NTS”的支持。

### NTS server NTS 服务器

To set up your server with NTS you’ll need certificates so that the server can authenticate itself and, based on that, allow the encryption and  verification of NTP traffic.
要使用 NTS 设置服务器，您需要证书，以便服务器可以自行进行身份验证，并在此基础上允许对 NTP 流量进行加密和验证。

In addition to the `allow` statement that any `chrony` (while working as an NTP server) needs there are two mandatory config  entries that will be needed. Example certificates for those entries  would look like:
除了任何 `chrony` （在作为 NTP 服务器工作时）需要 `allow` 的声明之外，还需要两个必需的配置条目。这些条目的示例证书如下所示：

```plaintext
ntsservercert /etc/chrony/fullchain.pem
ntsserverkey /etc/chrony/privkey.pem
```

It is important to note that for isolation reasons `chrony`, by default, runs as user and group `_chrony`. Therefore you need to grant access to the certificates for that user, by running the following command:.
需要注意的是，出于隔离原因 `chrony` ，默认情况下，以 user 和 group `_chrony` 的身份运行。因此，您需要通过运行以下命令来授予该用户对证书的访问权限：

```bash
sudo chown _chrony:_chrony /etc/chrony/*.pem
```

Then restart `chrony` with `systemctl restart chrony` and it will be ready to provide NTS-based time services.
然后重新启动 `chrony`  `systemctl restart chrony` ，它将准备好提供基于 NTS 的时间服务。

A running `chrony` server measures various statistics. One of them counts the number of  NTS connections that were established (or dropped) – we can check this  by running `sudo chronyc -N serverstats`, which shows us the statistics:
正在运行 `chrony` 的服务器测量各种统计信息。其中一个计算已建立（或丢弃）的 NTS 连接数 – 我们可以通过运行 `sudo chronyc -N serverstats` 来检查这一点，它向我们显示统计信息：

```plaintext
NTP packets received       : 213
NTP packets dropped        : 0
Command packets received   : 117
Command packets dropped    : 0
Client log records dropped : 0
NTS-KE connections accepted: 2
NTS-KE connections dropped : 0
Authenticated NTP packets  : 197
```

There is also a per-client statistic which can be enabled by the `-p` option of the `clients` command.
还有一个每个客户端的统计信息，可以通过 `clients` 命令 `-p` 的选项来启用。

```bash
sudo chronyc -N clients -k
```

This provides output in the following form:
这将按以下形式提供输出：

```plaintext
    Hostname                      NTP   Drop Int IntL Last  NTS-KE   Drop Int  Last
    ===============================================================================
    10.172.196.173                197      0  10   -   595       2      0   5   48h
    ...
```

For more complex scenarios there are many more advanced options for configuring NTS. These are documented in [the `chrony` man page](https://manpages.ubuntu.com/manpages/en/man5/chrony.conf.5.html).
对于更复杂的方案，有许多用于配置 NTS 的更高级选项。 `chrony` 手册页中记录了这些内容。

> **Note**: *About certificate placement*
> 注意：关于证书放置
>  Chrony, by default, is isolated via AppArmor and uses a number of `protect*` features of `systemd`. Due to that, there are not many paths `chrony` can access for the certificates. But `/etc/chrony/*` is allowed as read-only and that is enough.
> 默认情况下，Chrony 通过 AppArmor 进行隔离，并使用 的 `systemd` 多种 `protect*` 功能。因此，证书 `chrony` 可以访问的路径并不多。但 `/etc/chrony/*` 允许只读，这就足够了。
>  Check `/etc/apparmor.d/usr.sbin.chronyd` if you want other paths or allow custom paths in `/etc/apparmor.d/local/usr.sbin.chronyd`.
> 检查 `/etc/apparmor.d/usr.sbin.chronyd` 是否需要其他路径或允许自定义 `/etc/apparmor.d/local/usr.sbin.chronyd` 路径。

### NTS 客户端

The client needs to specify `server` as usual (`pool` directives do not work with NTS). Afterwards, the server address options can be listed and it is there that `nts` can be added. For example:
客户端需要像往常一样指定 `server` （ `pool` 指令不适用于 NTS）。之后，可以列出服务器地址选项，并且 `nts` 可以添加服务器地址。例如：

```plaintext
server <server-fqdn-or-IP> iburst nts
```

One can check the `authdata` of the connections established by the client using `sudo chronyc -N authdata`, which will provide the following information:
可以使用 检查客户端建立 `authdata` 的连接 `sudo chronyc -N authdata` ，这将提供以下信息：

```plaintext
Name/IP address             Mode KeyID Type KLen Last Atmp  NAK Cook CLen
=========================================================================
<server-fqdn-or-ip>          NTS     1   15  256  48h    0    0    8  100
```

Again, there are more advanced options documented in [the man page](https://manpages.ubuntu.com/manpages/en/man5/chrony.conf.5.html). Common use cases are specifying an explicit trusted certificate.
同样，手册页中还记录了更高级的选项。常见用例是指定显式受信任证书。

> **Bad Clocks and secure time syncing - “A Chicken and Egg” problem
> 坏时钟和安全时间同步 - “先有鸡还是先有蛋”的问题**
>  There is one problem with systems that have very bad clocks. NTS is  based on TLS, and TLS needs a reasonably correct clock. Due to that, an  NTS-based sync might fail. On hardware affected by this problem, one can consider using the `nocerttimecheck` option which allows the user to set the number of times that the time can be synced without checking validation and expiration.
> 时钟非常糟糕的系统存在一个问题。NTS 基于 TLS，而 TLS 需要一个相当正确的时钟。因此，基于 NTS 的同步可能会失败。在受此问题影响的硬件上，可以考虑使用该 `nocerttimecheck` 选项，该选项允许用户设置可以同步时间的次数，而无需检查验证和过期。

## References 引用

- [Chrony FAQ Chrony 常见问题](https://chrony.tuxfamily.org/faq.html)
- [ntp.org: home of the Network Time Protocol project
  ntp.org：网络时间协议项目的所在地](http://www.ntp.org/)
- [pool.ntp.org: project of virtual cluster of timeservers
  pool.ntp.org：时间服务器虚拟集群项目](http://www.pool.ntp.org/)
- [Freedesktop.org info on timedatectl
  Freedesktop.org timedatectl的信息](https://www.freedesktop.org/software/systemd/man/timedatectl.html)
- [Freedesktop.org info on systemd-timesyncd service
  Freedesktop.org 有关 systemd-timesyncd 服务的信息](https://www.freedesktop.org/software/systemd/man/systemd-timesyncd.service.html#)
- [Feeding chrony from GPSD
  从 GPSD 喂食 chrony](https://gpsd.gitlab.io/gpsd/gpsd-time-service-howto.html#_feeding_chrony_from_gpsd)
- See the [Ubuntu Time](https://help.ubuntu.com/community/UbuntuTime) wiki page for more information.
  有关详细信息，请参阅 Ubuntu Time wiki 页面。





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

## 网络时间安全概述(NTS)

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

## 对比

### `chrony` 与 `ntpd`

`chrony` 和 `ntpd` 是网络时间协议 （NTP） 的两种不同实现。

`chrony` is a newer implementation, which was designed to work well in a wider range of conditions. It can usually synchronise the system clock faster and with better time accuracy. It has many features, but it does not implement some of the less useful NTP modes like broadcast client or multicast server/client.
 `chrony` 是一种较新的实现，旨在在更广泛的条件下运行良好。它通常可以更快地同步系统时钟，并具有更好的时间精度。它具有许多功能，但它没有实现一些不太有用的 NTP 模式，如广播客户端或组播服务器/客户端。

If your computer is connected to the Internet only for few minutes at a time, the network connection is often congested, you turn your computer off or suspend it frequently, the clock is not very stable (e.g. there are rapid changes in the temperature or it is a virtual machine), or you want to use NTP on an isolated network with no hardware reference clocks in sight, `chrony` will probably work better for you.
如果您的计算机一次只连接到 Internet 几分钟，网络连接经常拥塞，您经常关闭或挂起计算机，时钟不是很稳定（例如温度快速变化或它是虚拟机），或者您想在没有硬件参考时钟的隔离网络上使用 NTP， `chrony` 可能会更适合您。

### 1.2. Should I prefer `chrony` over `timesyncd` if I do not need to run a server? 1.2. 如果我不需要运行服务器，我应该更喜欢 `chrony` 吗 `timesyncd` ？

Generally, yes. 一般来说，是的。

`systemd-timesyncd` is a very simple NTP client included in the `systemd` suite. It lacks almost all features of `chrony` and other advanced client implementations listed on the [comparison page](https://chrony-project.org/comparison.html). One of its main limitations is that it cannot poll multiple servers at the same time and detect servers having incorrect time (falsetickers in the NTP terminology). It should be used only with trusted reliable servers, ideally in local network.
 `systemd-timesyncd` 是一个非常简单的NTP客户端， `systemd` 包含在套件中。它缺少比较页面上列出的 `chrony` 几乎所有功能和其他高级客户端实现。它的主要限制之一是它不能同时轮询多个服务器并检测时间不正确的服务器（NTP 术语中的 falsetickers）。它只能与受信任的可靠服务器一起使用，最好是在本地网络中。

Using `timesyncd` with `pool.ntp.org` is problematic. The pool is very robust as a whole, but the individual servers run by volunteers cannot be relied on. Occasionally, servers drift away or make a step to distant past or future due to misconfiguration, problematic implementation, and other bugs (e.g. in firmware of a GPS receiver). The pool monitoring system detects such servers and quickly removes them from the pool DNS, but clients like `timesyncd` cannot recover from that. They follow the server as long as it claims to be synchronised. They need to be restarted in order to get a new address from the pool DNS.
使用 `timesyncd` with `pool.ntp.org` 是有问题的。池整体上非常强大，但不能依赖志愿者运行的单个服务器。有时，由于配置错误、有问题的实现和其他错误（例如，在 GPS  接收器的固件中），服务器会偏离或向遥远的过去或未来迈出一步。池监控系统检测到此类服务器并快速将它们从池 DNS 中删除，但客户端无法 `timesyncd` 从中恢复。只要服务器声称是同步的，它们就会跟随服务器。它们需要重新启动才能从池 DNS 中获取新地址。

Note that the complexity of NTP and clock synchronisation is on the client side. The amount of code in `chrony` specific to NTP server is very small and it is disabled by default. If it was removed, it would not significantly reduce the amount of memory or storage needed.
请注意，NTP 和时钟同步的复杂性在客户端。 `chrony` 特定于 NTP 服务器的代码量非常小，默认情况下处于禁用状态。如果将其删除，则不会显着减少所需的内存或存储量。

## 2. Configuration issues 2. 配置问题

### 2.1. What is the minimum recommended configuration for an NTP client? 2.1. NTP 客户端的最低推荐配置是什么？

First, the client needs to know which NTP servers it should ask for the current time. They are specified by the `server` or `pool` directive. The `pool` directive is used with names that resolve to multiple addresses of different servers. For reliable operation, the client should have at least three servers.
首先，客户端需要知道当前时间应该请求哪些 NTP 服务器。它们由 `server` or `pool` 指令指定。该 `pool` 指令与解析为不同服务器的多个地址的名称一起使用。为了可靠运行，客户端应至少有三台服务器。

The `iburst` option enables a burst of requests to speed up the initial synchronisation.
该 `iburst` 选项允许大量请求以加快初始同步。

To stabilise the initial synchronisation on the next start, the estimated drift of the system clock is saved to a file specified by the `driftfile` directive.
为了在下次启动时稳定初始同步，系统时钟的估计漂移被保存到 `driftfile` 指令指定的文件中。

If the system clock can be far from the true time after boot for any reason, `chronyd` should be allowed to correct it quickly by stepping instead of slewing, which would take a very long time. The `makestep` directive does that.
如果系统时钟由于任何原因与启动后的真实时间相去甚远， `chronyd` 则应允许通过步进而不是回转来快速纠正它，这将需要很长时间。该 `makestep` 指令就是这样做的。

In order to keep the real-time clock (RTC) close to the true time, so the system time is reasonably close to the true time when it is initialised on the next boot from the RTC, the `rtcsync` directive enables a mode in which the system time is periodically copied to the RTC. It is supported on Linux and macOS.
为了使实时时钟 （RTC） 接近真实时间，使系统时间合理地接近下次从 RTC 启动时初始化时的真实时间，该 `rtcsync` 指令启用了一种模式，在该模式下，系统时间定期复制到 RTC。它在 Linux 和 macOS 上受支持。

If you wanted to use public NTP servers from the [pool.ntp.org](https://www.pool.ntp.org/) project, the minimal *chrony.conf* file could be:
如果要使用 pool.ntp.org 项目中的公共 NTP 服务器，则最小的 chrony.conf 文件可以是：

```
pool pool.ntp.org iburst
driftfile /var/lib/chrony/drift
makestep 1 3
rtcsync
```

### 2.2. How do I make an NTP server? 2.2. 如何制作NTP服务器？

By default, `chronyd` does not operate as an NTP server. You need to add an `allow` directive to the *chrony.conf* file in order for `chronyd` to open the server NTP port and respond to client requests.
默认情况下，`chronyd` 不作为 NTP 服务器运行。您需要向 chrony.conf 文件添加指令 `allow` ，以便 `chronyd` 打开服务器 NTP 端口并响应客户端请求。

```
allow 192.168.1.0/24
```

An `allow` directive with no specified subnet allows access from all IPv4 and IPv6 addresses.
没有指定子网的 `allow` 指令允许从所有 IPv4 和 IPv6 地址进行访问。

### 2.3. Should all computers on a LAN be clients of an external server? 2.3. LAN 上的所有计算机都应该是外部服务器的客户端吗？

It depends on the requirements. Usually, the best configuration is to make one computer the server, with the others as clients of it. Add a `local` directive to the server’s *chrony.conf* file. This configuration will be better because
这取决于要求。通常，最好的配置是将一台计算机作为服务器，而其他计算机作为服务器的客户端。将 `local` 指令添加到服务器的 chrony.conf 文件中。这种配置会更好，因为

- the load on the external connection is less
  外部连接上的负载较小
- the load on the external NTP server(s) is less
  外部 NTP 服务器上的负载较小
- if your external connection goes down, the computers on the LAN will maintain a common time with each other.
  如果外部连接断开，LAN 上的计算机将彼此保持公共时间。

### 2.4. Must I specify servers by IP address if DNS is not available on `chronyd` start? 2.4. 如果 DNS 在启动时 `chronyd` 不可用，我必须按 IP 地址指定服务器吗？

No, `chronyd` will keep trying to resolve the names specified by the `server`, `pool`, and `peer` directives in an increasing interval until it succeeds. The `online` command can be issued from `chronyc` to force `chronyd` to try to resolve the names immediately.
否， `chronyd` 将继续尝试以递增的时间间隔解析 `server` 、 `pool` 和 `peer` 指令指定的名称，直到成功。可以从 `chronyc` to force `chronyd` 发出 `online` 命令，以尝试立即解析名称。

### 2.5. How can I make `chronyd` more secure? 2.5. 如何提高 `chronyd` 安全性？

If you do not need to use `chronyc`, or you want to run `chronyc` only under the root or *chrony* user (which can access `chronyd` through a Unix domain socket), you can disable the IPv4 and IPv6 command sockets (by default listening on localhost) by adding `cmdport 0` to the configuration file.
如果您不需要使用 `chronyc` ，或者您只想在 root 或 chrony 用户（可以通过 Unix 域套接字访问 `chronyd` ）下运行 `chronyc` ，则可以通过添加到 `cmdport 0` 配置文件来禁用 IPv4 和 IPv6 命令套接字（默认侦听 localhost）。

You can specify an unprivileged user with the `-u` option, or the `user` directive in the *chrony.conf* file, to which `chronyd` will switch after start in order to drop root privileges. The configure script has a `--with-user` option, which sets the default user. On Linux, `chronyd` needs to be compiled with support for the `libcap` library. On other systems, `chronyd` forks into two processes. The child process retains root privileges, but can only perform a very limited range of privileged system calls on behalf of the parent.
您可以使用 chrony.conf 文件中的 `-u` 选项或 `user` 指令指定非特权用户，启动后将切换到该 `chronyd` 用户以删除 root 权限。configure 脚本有一个 `--with-user` 选项，用于设置默认用户。在 Linux 上， `chronyd` 需要在支持 `libcap` 库的情况下进行编译。在其他系统上， `chronyd` 分叉分为两个进程。子进程保留根权限，但只能代表父进程执行非常有限的特权系统调用。

Also, if `chronyd` is compiled with support for the Linux secure computing (seccomp) facility, you can enable a system call filter with the `-F` option. It will significantly reduce the kernel attack surface and possibly prevent kernel exploits from the `chronyd` process if it is compromised. It is recommended to enable the filter only when it is known to work on the version of the system where `chrony` is installed as the filter needs to allow also system calls made from libraries that `chronyd` is using (e.g. libc) and different versions or implementations of the libraries might make different system calls. If the filter is missing some system call, `chronyd` could be killed even in normal operation.
此外，如果 `chronyd` 编译时支持 Linux 安全计算 （seccomp） 工具，则可以使用该 `-F` 选项启用系统调用筛选器。它将大大减少内核攻击面 `chronyd` ，并可能防止内核攻击进程受到损害。建议仅在已知在安装的系统 `chrony` 版本上工作时启用过滤器，因为过滤器还需要允许从正在使用的库 `chronyd` （例如 libc）进行的系统调用，并且库的不同版本或实现可能会进行不同的系统调用。如果过滤器缺少某些系统调用， `chronyd` 即使在正常操作中也可能被终止。

### 2.6. How can I make the system clock more secure? 2.6. 如何使系统时钟更安全？

An NTP client synchronising the system clock to an NTP server is susceptible to various attacks, which can break applications and network protocols relying on accuracy of the clock (e.g. DNSSEC, Kerberos, TLS, WireGuard).
将系统时钟同步到 NTP 服务器的 NTP 客户端容易受到各种攻击，这些攻击可能会破坏依赖于时钟准确性的应用程序和网络协议（例如 DNSSEC、Kerberos、TLS、WireGuard）。

Generally, a man-in-the-middle (MITM) attacker between the client and server can
通常，客户端和服务器之间的中间人 （MITM） 攻击者可以

- make fake responses, or modify real responses from the server, to create an arbitrarily large time and frequency offset, make the server appear more accurate, insert a leap second, etc.
  做出虚假响应，或修改来自服务器的真实响应，以创建任意大的时间和频率偏移，使服务器看起来更准确，插入闰秒等。
- delay the requests and/or responses to create a limited time offset and temporarily also a limited frequency offset
  延迟请求和/或响应以创建有限的时间偏移量，并暂时产生有限的频率偏移量
- drop the requests or responses to prevent updates of the clock with new measurements
  放弃请求或响应，以防止使用新的测量值更新时钟
- redirect the requests to a different server
  将请求重定向到其他服务器

The attacks can be combined for a greater effect. The attacker can delay packets to create a significant frequency offset first and then drop all subsequent packets to let the clock quickly drift away from the true time. The attacker might also be able to control the server’s clock.
这些攻击可以组合在一起以获得更大的效果。攻击者可以延迟数据包，首先创建显着的频率偏移，然后丢弃所有后续数据包，让时钟快速偏离真实时间。攻击者还可能控制服务器的时钟。

Some attacks cannot be prevented. Monitoring is needed for detection, e.g. the reachability register in the `sources` report shows missing packets. The extent to which the attacker can control the client’s clock depends on its configuration.
有些攻击是无法预防的。需要监控才能进行检测，例如， `sources` 报告中的可达性寄存器显示丢失的数据包。攻击者可以控制客户端时钟的程度取决于其配置。

Enable authentication to prevent `chronyd` from accepting modified, fake, or redirected packets. It can be enabled with a symmetric key specified by the `key` option, or Network Time Security (NTS) by the `nts` option (supported since `chrony` version 4.0). The server needs to support the selected authentication mechanism. Symmetric keys have to be configured on both client and server, and each client must have its own key (one per server).
启用身份验证以防止 `chronyd` 接受修改、伪造或重定向的数据包。它可以通过 `key` 选项指定的对称密钥启用，也可以通过 `nts` 选项启用网络时间安全 （NTS）（从 4.0 版开始 `chrony` 支持）。服务器需要支持所选的身份验证机制。必须在客户端和服务器上配置对称密钥，并且每个客户端必须有自己的密钥（每个服务器一个）。

The maximum offset that the attacker can insert in an NTP measurement by delaying packets can be limited by the `maxdelay` option. The default value is 3 seconds. The measured delay is reported as the peer delay in the `ntpdata` report and `measurements` log. Set the `maxdelay` option to a value larger than the maximum value that is normally observed. Note that the delay can increase significantly even when not under an attack, e.g. when the network is congested or the routing has changed.
攻击者可以通过延迟数据包在 NTP 测量中插入的最大偏移量可以受到该 `maxdelay` 选项的限制。默认值为 3 秒。测得的延迟在 `ntpdata` 报告和 `measurements` 日志中报告为对等延迟。将该 `maxdelay` 选项设置为大于通常观察到的最大值的值。请注意，即使没有受到攻击，延迟也会显着增加，例如，当网络拥塞或路由已更改时。

The maximum accepted change in time offset between clock updates can be limited by the `maxchange` directive. Larger changes in the offset will be ignored or cause `chronyd` to exit. Note that the attacker can get around this limit by splitting the offset into multiple smaller offsets and/or creating a large frequency offset. When this directive is used, `chronyd` will have to be restarted after a successful attack. It will not be able to recover on its own. It must not be restarted automatically (e.g. by the service manager).
时钟更新之间时间偏移的最大可接受变化可以由 `maxchange` 指令限制。偏移量中的较大变化将被忽略或导致 `chronyd` 退出。请注意，攻击者可以通过将偏移量拆分为多个较小的偏移量和/或创建较大的频率偏移量来绕过此限制。使用此指令时， `chronyd` 必须在攻击成功后重新启动。它将无法自行恢复。它不能自动重新启动（例如，由服务管理器重新启动）。

The impact of a large accepted time offset can be reduced by disabling clock steps, i.e. by not using the `makestep` and `initstepslew` directives. The offset will be slowly corrected by speeding up or slowing down the clock at a rate which can be limited by the `maxslewrate` directive. Disabling clock steps completely is practical only if the clock cannot gain a larger error on its own, e.g. when the computer is shut down or suspended, and the `maxslewrate` limit is large enough to correct an expected error in an acceptable time. The `rtcfile` directive with the `-s` option can be used to compensate for the RTC drift.
通过禁用时钟步长（即不使用 `makestep` and `initstepslew` 指令），可以减少大容量接受时间偏移的影响。偏移量将通过加快或减慢时钟的速度来缓慢校正，该速率可以受到 `maxslewrate` 指令的限制。完全禁用时钟步长是可行的，只有当时钟本身无法获得更大的误差时，例如，当计算机关闭或挂起时， `maxslewrate` 并且限制足够大，可以在可接受的时间内纠正预期的错误。带有该 `-s` 选项的 `rtcfile` 指令可用于补偿RTC漂移。

A more practical approach is to enable `makestep` for a limited number of clock updates (the 2nd argument of the directive) and limit the offset change in all updates by the `maxchange` directive. The attacker will be able to make only a limited step and only if the attack starts in a short window after booting the computer, or when `chronyd` is restarted without the `-R` option.
更实用的方法是启用 `makestep` 有限数量的时钟更新（指令的第二个参数），并限制 `maxchange` 指令所有更新中的偏移量变化。攻击者只能执行有限的步骤，并且仅在启动计算机后的短窗口内开始攻击，或者在没有 `-R` 该选项的情况下重新启动攻击时 `chronyd` 。

The frequency offset can be limited by the `maxdrift` directive. The measured frequency offset is reported in the drift file, `tracking` report, and `tracking` log. Set `maxdrift` to a value larger than the maximum absolute value that is normally observed. Note that the frequency of the clock can change due to aging of the crystal, differences in calibration of the clock source between reboots, migrated virtual machine, etc. A typical computer clock has a drift smaller than 100 parts per million (ppm), but much larger drifts are possible (e.g. in some virtual machines).
频率偏移可以由 `maxdrift` 指令限制。测得的频率偏移在漂移文件、 `tracking` 报告和 `tracking` 日志中报告。设置为 `maxdrift` 大于通常观察到的最大绝对值的值。请注意，时钟的频率可能会因晶体老化、重新启动之间时钟源校准的差异、迁移的虚拟机等原因而改变。典型的计算机时钟的漂移小于百万分之 100 （ppm），但漂移可能要大得多（例如在某些虚拟机中）。

Use only trusted servers, which you expect to be well configured and managed, using authentication for their own servers, etc. Use multiple servers, ideally in different locations. The attacker will have to deal with a majority of the servers in order to pass the source selection and update the clock with a large offset. Use the `minsources` directive to increase the required number of selectable sources to make the selection more robust.
仅使用您希望配置和管理良好的受信任服务器，对自己的服务器使用身份验证等。使用多台服务器，最好位于不同的位置。攻击者必须与大多数服务器打交道，才能通过源选择并更新具有较大偏移量的时钟。使用指令 `minsources` 增加所需的可选源数量，以使选择更加可靠。

Do not specify servers as peers. The symmetric mode is less secure than the client/server mode. If not authenticated, it is vulnerable to off-path denial-of-service attacks, and even when it is authenticated, it is still susceptible to replay attacks.
不要将服务器指定为对等方。对称模式不如客户端/服务器模式安全。如果未经身份验证，则容易受到路径外拒绝服务攻击，即使经过身份验证，它仍然容易受到重放攻击。

Mixing of authenticated and unauthenticated servers should generally be avoided. If mixing is necessary (e.g. for a more accurate and stable synchronisation to a closer server which does not support authentication), the authenticated servers should be configured as trusted and required to not allow the unauthenticated servers to override the authenticated servers in the source selection. Since `chrony` version 4.0, the selection options are enabled in such a case automatically. This behaviour can be disabled or modified by the `authselectmode` directive.
通常应避免混合使用经过身份验证的服务器和未经身份验证的服务器。如果需要混合（例如，为了更准确、更稳定地同步到不支持身份验证的更近的服务器），则应将经过身份验证的服务器配置为受信任的服务器，并且要求不允许未经身份验证的服务器覆盖源选择中的经过身份验证的服务器。从 4.0 版开始 `chrony` ，在这种情况下会自动启用选择选项。 `authselectmode` 指令可以禁用或修改此行为。

An example of a client configuration limiting the impact of the attacks could be
限制攻击影响的客户端配置的一个示例可能是

```
server ntp1.example.net iburst nts maxdelay 0.1
server ntp2.example.net iburst nts maxdelay 0.2
server ntp3.example.net iburst nts maxdelay 0.05
server ntp4.example.net iburst nts maxdelay 0.1
server ntp5.example.net iburst nts maxdelay 0.1
minsources 3
maxchange 100 0 0
makestep 0.001 1
maxdrift 100
maxslewrate 100
driftfile /var/lib/chrony/drift
ntsdumpdir /var/lib/chrony
rtcsync
```

### 2.7. How can I improve the accuracy of the system clock with NTP sources? 2.7. 如何使用NTP源提高系统时钟的精度？

Select NTP servers that are well synchronised, stable and close to your network. It is better to use more than one server. Three or four is usually recommended as the minimum, so `chronyd` can detect servers that serve false time and combine measurements from multiple sources.
选择同步良好、稳定且靠近您的网络的 NTP 服务器。最好使用多个服务器。通常建议至少使用三到四个，因此 `chronyd` 可以检测提供错误时间的服务器并合并来自多个来源的测量值。

If you have a network card with hardware timestamping supported on Linux, it can be enabled by the `hwtimestamp` directive. It should make local receive and transmit timestamps of NTP packets much more stable and accurate.
如果您的网卡在 Linux 上支持硬件时间戳，则可以通过 `hwtimestamp` 指令启用它。它应该使 NTP 数据包的本地接收和传输时间戳更加稳定和准确。

The `server` directive has some useful options: `minpoll`, `maxpoll`, `polltarget`, `maxdelay`, `maxdelayratio`, `maxdelaydevratio`, `xleave`, `filter`.
该 `server` 指令有一些有用的选项： `minpoll` 、、 `maxpoll` 、 `polltarget` `maxdelay` `maxdelayratio` `maxdelaydevratio` `xleave` `filter` 。

The first three options set the minimum and maximum allowed polling interval, and how should be the actual interval adjusted in the specified range. Their default values are 6 (64 seconds) for `minpoll`, 10 (1024 seconds) for `maxpoll` and 8 (samples) for `polltarget`. The default values should be used for general servers on the Internet. With your own NTP servers, or if you have permission to poll some servers more frequently, setting these options for shorter polling intervals might significantly improve the accuracy of the system clock.
前三个选项设置允许的最小和最大轮询间隔，以及在指定范围内调整的实际间隔应如何。它们的默认值为 `minpoll` 6（64 秒）、10（1024 秒） `maxpoll` 和 `polltarget` 8（样本）。默认值应用于 Internet 上的常规服务器。对于您自己的 NTP 服务器，或者如果您有权更频繁地轮询某些服务器，则将这些选项设置为更短的轮询间隔可能会显著提高系统时钟的准确性。

The optimal polling interval depends mainly on two factors, stability of the network latency and stability of the system clock (which mainly depends on the temperature sensitivity of the crystal oscillator and the maximum rate of the temperature change).
最佳轮询间隔主要取决于两个因素，网络时延的稳定性和系统时钟的稳定性（主要取决于晶体振荡器的温度灵敏度和温度变化的最大速率）。

Generally, if the `sourcestats` command usually reports a small number of samples retained for a source (e.g. fewer than 16), a shorter polling interval should be considered. If the number of samples is usually at the maximum of 64, a longer polling interval might work better.
通常，如果 `sourcestats` 命令通常报告为源保留的少量样本（例如少于 16 个），则应考虑较短的轮询间隔。如果样本数通常为最大 64 个，则更长的轮询间隔可能效果更好。

An example of the directive for an NTP server on the Internet that you are allowed to poll frequently could be
允许您经常轮询的 Internet 上 NTP 服务器的指令示例可能是

```
server ntp.example.net minpoll 4 maxpoll 6 polltarget 16
```

An example using shorter polling intervals with a server located in the same LAN could be
使用位于同一局域网中的服务器使用较短轮询间隔的示例可能是

```
server ntp.local minpoll 2 maxpoll 4 polltarget 30
```

The maxdelay options are useful to ignore measurements with an unusually large delay (e.g. due to congestion in the network) and improve the stability of the synchronisation. The `maxdelaydevratio` option could be added to the example with local NTP server
maxdelay 选项可用于忽略具有异常大延迟的测量值（例如，由于网络拥塞）并提高同步的稳定性。该 `maxdelaydevratio` 选项可以添加到具有本地 NTP 服务器的示例中

```
server ntp.local minpoll 2 maxpoll 4 polltarget 30 maxdelaydevratio 2
```

If your server supports the interleaved mode (e.g. it is running `chronyd`), the `xleave` option should be added to the `server` directive to enable the server to provide the client with more accurate transmit timestamps (kernel or preferably hardware). For example:
如果您的服务器支持交错模式（例如，它正在运行 `chronyd` ），则应将该 `xleave` 选项添加到 `server` 指令中，以使服务器能够为客户端提供更准确的传输时间戳（内核或最好是硬件）。例如：

```
server ntp.local minpoll 2 maxpoll 4 xleave
```

When combined with local hardware timestamping, good network switches, and even shorter polling intervals, a sub-microsecond accuracy and stability of a few tens of nanoseconds might be possible. For example:
当与本地硬件时间戳、良好的网络交换机以及更短的轮询间隔相结合时，亚微秒级的精度和几十纳秒的稳定性可能是可能的。例如：

```
server ntp.local minpoll 0 maxpoll 0 xleave
hwtimestamp eth0
```

For best stability, the CPU should be running at a constant frequency (i.e. disabled power saving and performance boosting). Energy-Efficient Ethernet (EEE) should be disabled in the network. The switches should be configured to prioritize NTP packets, especially if the network is expected to be heavily loaded. The `dscp` directive can be used to set the Differentiated Services Code Point in transmitted NTP packets if needed.
为了获得最佳稳定性，CPU 应以恒定频率运行（即禁用省电和性能提升）。应在网络中禁用节能以太网 （EEE）。交换机应配置为优先处理 NTP 数据包，尤其是在预计网络负载过重时。如果需要，该 `dscp` 指令可用于在传输的 NTP 数据包中设置差分服务代码点。

If it is acceptable for NTP clients in the network to send requests at a high rate, a sub-second polling interval can be specified. A median filter can be enabled in order to update the clock at a reduced rate with more stable measurements. For example:
如果网络中的 NTP 客户端可以接受以高速率发送请求，则可以指定亚秒轮询间隔。可以启用中值滤波器，以便以更低的速率更新时钟，并进行更稳定的测量。例如：

```
server ntp.local minpoll -6 maxpoll -6 filter 15 xleave
hwtimestamp eth0 minpoll -6
```

Since `chrony` version 4.3, the minimum `minpoll` is -7 and a filter using a long-term estimate of a delay quantile can be enabled by the `maxdelayquant` option to replace the default `maxdelaydevratio` filter, which is sensitive to outliers corrupting the minimum delay. For example:
从版本 4.3 开始 `chrony` ，最小 `minpoll` 值为 -7，并且可以通过替换默认滤波器的选项来启用 `maxdelayquant` 使用延迟分位数的长期估计值的滤波器，该 `maxdelaydevratio` 滤波器对破坏最小延迟的异常值很敏感。例如：

```
server ntp.local minpoll -7 maxpoll -7 filter 31 maxdelayquant 0.3 xleave
```

Since version 4.2, `chronyd` supports an NTPv4 extension field containing an additional timestamp to enable frequency transfer and significantly improve stability of synchronisation. It can be enabled by the `extfield F323` option. For example:
从版本 4.2 开始， `chronyd` 支持包含额外时间戳的 NTPv4 扩展字段，以实现频率传输并显着提高同步的稳定性。它可以通过选项 `extfield F323` 启用。例如：

```
server ntp.local minpoll 0 maxpoll 0 xleave extfield F323
```

Since version 4.5, `chronyd` can apply corrections from PTP one-step end-to-end transparent clocks (e.g. network switches) to significantly improve accuracy of synchronisation in local networks. It requires the PTP transport to be enabled by the `ptpport` directive, HW timestamping, and the `extfield F324` option. For example:
从 4.5 版开始， `chronyd` 可以应用 PTP 一步到端透明时钟（例如网络交换机）的校正，以显着提高本地网络同步的准确性。它要求通过 `ptpport` 指令、硬件时间戳和 `extfield F324` 选项启用 PTP 传输。例如：

```
server ntp.local minpoll -4 maxpoll -4 xleave extfield F323 extfield F324 port 319
ptpport 319
hwtimestamp eth0 minpoll -4
```

### 2.8. Does `chronyd` have an ntpdate mode? 2.8. 有 ntpdate 模式吗 `chronyd` ？

Yes. With the `-q` option `chronyd` will set the system clock once and exit. With the `-Q` option it will print the measured offset without setting the clock. If you do not want to use a configuration file, NTP servers can be specified on the command line. For example:
是的。使用该 `-q` 选项 `chronyd` 将设置系统时钟一次并退出。使用该 `-Q` 选项，它将在不设置时钟的情况下打印测量的偏移量。如果不想使用配置文件，可以在命令行上指定 NTP 服务器。例如：

```
# chronyd -q 'pool pool.ntp.org iburst'
```

The command above would normally take about 5 seconds if the servers were well synchronised and responding to all requests. If not synchronised or responding, it would take about 10 seconds for `chronyd` to give up and exit with a non-zero status. A faster configuration is possible. A single server can be used instead of four servers, the number of measurements can be reduced with the `maxsamples` option to one (supported since `chrony` version 4.0), and a timeout can be specified with the `-t` option. The following command would take only up to about one second.
如果服务器同步良好并响应所有请求，则上述命令通常需要大约 5 秒。如果没有同步或响应，大约需要 10 秒才能 `chronyd` 放弃并以非零状态退出。可以进行更快的配置。可以使用单个服务器而不是四台服务器，可以使用 `maxsamples` 选项将测量次数减少到一个（从 4.0 版开始 `chrony` 支持），并且可以使用该 `-t` 选项指定超时。以下命令最多只需大约一秒钟。

```
# chronyd -q -t 1 'server pool.ntp.org iburst maxsamples 1'
```

It is not recommended to run `chronyd` with the `-q` option periodically (e.g. from a cron job) as a replacement for the daemon mode, because it performs significantly worse (e.g. the clock is stepped and its frequency is not corrected). If you must run it this way and you are using a public NTP server, make sure `chronyd` does not always start around the first second of a minute, e.g. by adding a random sleep before the `chronyd` command. Public servers typically receive large bursts of requests around the first second as there is a large number of NTP clients started from cron with no delay.
不建议定期使用该 `-q` 选项（例如从 cron 作业）运行 `chronyd` 该选项作为守护程序模式的替代品，因为它的性能明显更差（例如，时钟是步进的，其频率未被校正）。如果必须以这种方式运行它，并且使用的是公共 NTP 服务器，请确保 `chronyd` 并不总是在一分钟的第一秒左右启动，例如， `chronyd` 在命令之前添加随机睡眠。公共服务器通常会在第一秒左右收到大量突发请求，因为有大量 NTP 客户端从 cron 启动，没有延迟。

### 2.9. Can `chronyd` be configured to control the clock like `ntpd`? 2.9. 可以 `chronyd` 配置为控制时钟，如 `ntpd` ？

It is not possible to perfectly emulate `ntpd`, but there are some options that can configure `chronyd` to behave more like `ntpd` if there is a reason to prefer that.
不可能完美地模拟 `ntpd` ，但是如果有理由更喜欢它，有一些选项可以配置 `chronyd` 为表现得更像 `ntpd` 。

In the following example the `minsamples` directive slows down the response to changes in the frequency and offset of the clock. The `maxslewrate` and `corrtimeratio` directives reduce the maximum frequency error due to an offset correction and the `maxdrift` directive reduces the maximum assumed frequency error of the clock. The `makestep` directive enables a step threshold and the `maxchange` directive enables a panic threshold. The `maxclockerror` directive increases the minimum dispersion rate.
在以下示例中，该 `minsamples` 指令减慢了对时钟频率和偏移变化的响应速度。 `maxslewrate` “和”指令通过偏移校正减小了最大频率误差，而该 `corrtimeratio`  `maxdrift` 指令则减小了时钟的最大假定频率误差。该 `makestep` 指令启用步进阈值，该 `maxchange` 指令启用紧急阈值。该 `maxclockerror` 指令提高了最小色散率。

```
minsamples 32
maxslewrate 500
corrtimeratio 100
maxdrift 500
makestep 0.128 -1
maxchange 1000 1 1
maxclockerror 15
```

Note that increasing `minsamples` might cause the offsets in the `tracking` and `sourcestats` reports/logs to be significantly smaller than the actual offsets and be unsuitable for monitoring.
请注意，增加 `minsamples` 可能会导致 `tracking` 和 `sourcestats` reports/日志中的偏移量明显小于实际偏移量，并且不适合监视。

### 2.10. Can NTP server be separated from NTP client? 2.10. NTP服务器可以与NTP客户端分离吗？

Yes, it is possible to run multiple instances of `chronyd` on a computer at the same time. One can operate primarily as an NTP client to synchronise the system clock and another as a server for other computers. If they use the same filesystem, they need to be configured with different pidfiles, Unix domain command sockets, and any other file or directory specified in the configuration file. If they run in the same network namespace, they need to use different NTP and command ports, or bind the ports to different addresses or interfaces.
是的，可以同时在一台计算机上运行多个 `chronyd` 实例。一个可以主要作为 NTP 客户端来同步系统时钟，另一个可以作为其他计算机的服务器运行。如果它们使用相同的文件系统，则需要使用不同的  pidfile、Unix 域命令套接字以及配置文件中指定的任何其他文件或目录来配置它们。如果它们在同一个网络命名空间中运行，则需要使用不同的  NTP 和命令端口，或者将端口绑定到不同的地址或接口。

The server instance should be started with the `-x` option to prevent it from adjusting the system clock and interfering with the client instance. It can be configured as a client to synchronise its NTP clock to other servers, or the client instance running on the same computer. In the latter case, the `copy` option (added in `chrony` version 4.1) can be used to assume the reference ID and stratum of the client instance, which enables detection of synchronisation loops with its own clients.
服务器实例应使用以下 `-x` 选项启动，以防止其调整系统时钟并干扰客户端实例。它可以配置为客户端，以将其 NTP 时钟同步到其他服务器或在同一台计算机上运行的客户端实例。在后一种情况下，该 `copy` 选项（在 4.1 版中 `chrony` 添加）可用于假定客户端实例的引用 ID 和层，从而可以检测与其自己的客户端的同步循环。

On Linux, starting with `chrony` version 4.0, it is possible to run multiple server instances sharing a port to better utilise multiple cores of the CPU. Note that for rate limiting and client/server interleaved mode to work well it is necessary that all packets received from the same address are handled by the same server instance.
在 Linux 上，从 `chrony` 4.0 版开始，可以运行共享一个端口的多个服务器实例，以更好地利用 CPU 的多个内核。请注意，要使速率限制和客户端/服务器交错模式正常工作，必须由同一服务器实例处理从同一地址接收的所有数据包。

An example configuration of the client instance could be
客户端实例的示例配置可以是

```
pool pool.ntp.org iburst
allow 127.0.0.1
port 11123
driftfile /var/lib/chrony/drift
makestep 1 3
rtcsync
```

and configuration of the first server instance could be
第一个服务器实例的配置可以是

```
server 127.0.0.1 port 11123 minpoll 0 maxpoll 0 copy
allow
cmdport 11323
bindcmdaddress /var/run/chrony/chronyd-server1.sock
pidfile /var/run/chronyd-server1.pid
driftfile /var/lib/chrony/drift-server1
```

### 2.11. How can `chronyd` be configured to minimise downtime during restarts? 2.11. 如何 `chronyd` 配置以最大程度地减少重启期间的停机时间？

The `dumpdir` directive in *chrony.conf* provides `chronyd` a location to save a measurement history of the sources it uses when the service exits. The `-r` option then enables `chronyd` to load state from the dump files, reducing the synchronisation time after a restart.
chrony.conf 中的 `dumpdir` 指令提供了一个 `chronyd` 位置，用于保存服务退出时它使用的源的测量历史记录。然后，该 `-r` 选项允许 `chronyd` 从转储文件加载状态，从而减少重新启动后的同步时间。

Similarly, the `ntsdumpdir` directive provides a location for `chronyd` to save NTS cookies received from the server to avoid making a NTS-KE request when `chronyd` is started. When operating as an NTS server, `chronyd` also saves cookies keys to this directory to allow clients to continue to use the old keys after a server restart for a more seamless experience.
同样，该 `ntsdumpdir` 指令提供了一个位置，用于 `chronyd` 保存从服务器接收的 NTS cookie，以避免在启动时 `chronyd` 发出 NTS-KE 请求。当作为 NTS 服务器运行时， `chronyd` 还会将 cookie 密钥保存到此目录，以允许客户端在服务器重新启动后继续使用旧密钥，以获得更无缝的体验。

On Linux systems, [systemd socket activation](https://www.freedesktop.org/software/systemd/man/latest/sd_listen_fds.html) provides a mechanism to reuse server sockets across `chronyd` restarts, so that client requests will be buffered until the service is again able to handle the requests. This allows for zero-downtime service restarts, simplified dependency logic at boot, and on-demand service spawning (for instance, for separated server `chronyd` instances run with the `-x` flag).
在 Linux 系统上，systemd 套接字激活提供了一种在重新启动时 `chronyd` 重用服务器套接字的机制，以便缓冲客户端请求，直到服务能够再次处理请求。这允许零停机时间的服务重启、简化启动时的依赖关系逻辑以及按需服务生成（例如，对于使用标志运行的 `-x` 分离服务器 `chronyd` 实例）。

Socket activation is supported since `chrony` version 4.5. The service manager (systemd) creates sockets and passes file descriptors to them to the process via the `LISTEN_FDS` environment variable. Before opening new sockets, `chronyd` first checks for and attempts to reuse matching sockets passed from the service manager. For instance, if an IPv4 datagram socket bound on `bindaddress` and `port` is available, it will be used by the NTP server to accept incoming IPv4 requests.
从版本 4.5 开始 `chrony` 支持套接字激活。服务管理器 （systemd） 创建套接字，并通过 `LISTEN_FDS` 环境变量将文件描述符传递给进程。在打开新套接字之前， `chronyd` 请首先检查并尝试重用从服务管理器传递的匹配套接字。例如，如果 IPv4 数据报套接字绑定 `bindaddress` 且 `port` 可用，则 NTP 服务器将使用它来接受传入的 IPv4 请求。

An example systemd socket unit is below, where `chronyd` is configured with `bindaddress 0.0.0.0`, `bindaddress ::`, `port 123`, and `ntsport 4460`.
下面是一个示例 systemd 套接字单元，其中 `chronyd` 配置了 `bindaddress 0.0.0.0` 、 `bindaddress ::` 、 `port 123` 和 `ntsport 4460` 。

```
[Unit]
Description=chronyd server sockets

[Socket]
Service=chronyd.service
# IPv4 NTP server
ListenDatagram=0.0.0.0:123
# IPv6 NTP server
ListenDatagram=[::]:123
# IPv4 NTS-KE server
ListenStream=0.0.0.0:4460
# IPv6 NTS-KE server
ListenStream=[::]:4460
BindIPv6Only=ipv6-only

[Install]
WantedBy=sockets.target
```

### 2.12. Should be a leap smear enabled on NTP server? 2.12. 是否应该在NTP服务器上启用跳跃拖尾？

With the `smoothtime` and `leapsecmode` directives it is possible to enable a server leap smear in order to hide leap seconds from clients and force them to follow a slow server’s adjustment instead.
使用 `smoothtime` and `leapsecmode` 指令，可以启用服务器跳跃拖尾，以便对客户端隐藏闰秒，并强制它们遵循缓慢的服务器调整。

This feature should be used only in local networks and only when necessary, e.g. when the clients cannot be configured to handle the leap seconds as needed, or their number is so large that configuring them all would be impractical. The clients should use only one leap-smearing server, or multiple identically configured leap-smearing servers. Note that some clients can get leap seconds from other sources (e.g. with the `leapsectz` directive in `chrony`) and they will not work correctly with a leap smearing server.
此功能应仅在本地网络中使用，并且仅在必要时使用，例如，当客户端无法配置为根据需要处理闰秒时，或者它们的数量太大以至于将它们全部配置是不切实际的。客户端应仅使用一个跳跃拖尾服务器，或多个配置相同的跳跃拖尾服务器。请注意，某些客户端可以从其他来源获取闰秒（例如，使用 中的 `leapsectz` `chrony` 指令），并且它们将无法与闰拖尾服务器一起正常工作。

### 2.13. How should `chronyd` be configured with `gpsd`? 2.13. 应该 `chronyd` 如何配置 `gpsd` ？

A GPS or other GNSS receiver can be used as a reference clock with `gpsd`. It can work as one or two separate time sources for each connected receiver. The first time source is based on timestamping of messages sent by the receiver. Typically, it is accurate to milliseconds. The other source is much more accurate. It is timestamping a pulse-per-second (PPS) signal, usually connected to a serial port (e.g. DCD pin) or GPIO pin.
GPS 或其他 GNSS 接收器可用作参考 `gpsd` 时钟。它可以作为每个连接的接收器的一个或两个单独的时间源。第一个时间源基于接收方发送的消息的时间戳。通常，它精确到毫秒。另一个来源要准确得多。它对每秒脉冲 （PPS） 信号进行时间戳，通常连接到串行端口（例如 DCD 引脚）或 GPIO 引脚。

If the PPS signal is connected to the serial port which is receiving messages from the GPS/GNSS receiver, `gpsd` should detect and use it automatically. If it is connected to a GPIO pin, or another serial port, the PPS device needs to be specified on the command line as an additional data source. On Linux, the `ldattach` utility can be used to create a PPS device for a serial device.
如果 PPS 信号连接到从 GPS/GNSS 接收器接收消息的串行端口， `gpsd` 则应自动检测并使用它。如果它连接到 GPIO 引脚或其他串行端口，则需要在命令行上将 PPS 设备指定为附加数据源。在 Linux 上，该 `ldattach` 实用程序可用于为串行设备创建 PPS 设备。

The PPS-based time source provided by `gpsd` is available as a `SHM 1` refclock, or other odd number if `gpsd` is configured with multiple receivers, and also as `SOCK /var/run/chrony.DEV.sock` where `DEV` is the name of the serial device (e.g. ttyS0).
提供的 `gpsd` 基于PPS的时间源可作为 `SHM 1` 参考时钟使用，如果 `gpsd` 配置有多个接收器，则可用作其他奇数，也可以用作 `SOCK /var/run/chrony.DEV.sock`  `DEV` 串行设备的名称（例如ttyS0）。

The message-based time source is available as a `SHM 0` refclock (or other even number) and since `gpsd` version 3.25 also as `SOCK /var/run/chrony.clk.DEV.sock` where `DEV` is the name of the serial device.
基于消息的时间源可作为 `SHM 0` 参考时钟（或其他偶数）使用，从 3.25 版本开始 `gpsd` ，也可以用作 `SOCK /var/run/chrony.clk.DEV.sock` 串行设备的名称。 `DEV` 

The SOCK refclocks should be preferred over SHM for better security (the shared memory segment needs to be created by `chronyd` or `gpsd` with an expected owner and permissions before an untrusted application or user has a chance to create its own in order to feed `chronyd` with false measurements). `gpsd` needs to be started after `chronyd` in order to connect to the socket.
为了获得更好的安全性，应优先使用 SOCK refclocks（共享内存段需要由 `chronyd` 预期的所有者和权限创建， `gpsd` 或者具有预期的所有者和权限，然后不受信任的应用程序或用户才有机会创建自己的存储器，以便 `chronyd` 提供错误的测量值）。 `gpsd` 需要启动后 `chronyd` 才能连接到套接字。

With `chronyd` and `gpsd` both supporting PPS, there are two different recommended configurations:
对于 `chronyd` 支持 PPS 且 `gpsd` 两者都支持 PPS，有两种不同的推荐配置：

```
# First option
refclock SOCK /var/run/chrony.ttyS0.sock refid GPS

# Second option
refclock PPS /dev/pps0 lock NMEA refid GPS
refclock SOCK /var/run/chrony.clk.ttyS0.sock offset 0.5 delay 0.1 refid NMEA noselect
```

They both have some advantages:
它们都有一些优点：

- `SOCK` can be more accurate than `PPS` if `gpsd` corrects for the sawtooth error provided by the receiver in serial data
   `SOCK` 可以比 `PPS` if `gpsd` 更准确地纠正接收器在串行数据中提供的锯齿错误
- `PPS` can be used with higher PPS rates (specified by the `rate` option), but it requires a second refclock or another time source to pair pulses with seconds, and the `SOCK` offset needs to be specified [correctly](https://chrony-project.org/faq.html#using-pps-refclock) to compensate for the message delay, while `gpsd` can apply HW-specific information
   `PPS` 可以与更高的 PPS 速率一起使用（由 `rate` 选项指定），但它需要第二个参考时钟或其他时间源来将脉冲与秒配对，并且需要正确指定 `SOCK` 偏移以补偿消息延迟，同时 `gpsd` 可以应用特定于硬件的信息

If the PPS signal is not available, or cannot be used for some reason, the only option is the message-based timing
如果 PPS 信号不可用，或由于某种原因无法使用，则唯一的选择是基于消息的定时

```
refclock SOCK /var/run/chrony.clk.ttyS0.sock offset 0.5 delay 0.1 refid GPS
```

or the SHM equivalent if using `gpsd` version before 3.25
或 SHM 等效版本（如果使用 `gpsd` 3.25 之前的版本）

```
refclock SHM 0 offset 0.5 delay 0.1 refid GPS
```

### 2.14. Does `chrony` support PTP? 2.14. 是否 `chrony` 支持PTP？

No, the Precision Time Protocol (PTP) is not supported as a protocol for synchronisation of clocks and there are no plans to support it. It is a complex protocol, which shares some issues with the NTP broadcast mode. One of the main differences between NTP and PTP is that PTP was designed to be easily supported in hardware (e.g. network switches and routers) in order to make more stable and accurate measurements. PTP relies on the hardware support. NTP does not rely on any support in the hardware, but if it had the same support as PTP, it could perform equally well.
不可以，不支持精确时间协议 （PTP） 作为时钟同步协议，并且没有计划支持它。这是一个复杂的协议，与 NTP 广播模式存在一些问题。NTP 和 PTP  之间的主要区别之一是，PTP 被设计为易于在硬件（例如网络交换机和路由器）中提供支持，以便进行更稳定和准确的测量。PTP 依赖于硬件支持。NTP 不依赖于硬件中的任何支持，但如果它具有与 PTP 相同的支持，它的性能同样出色。

On Linux, `chrony` supports hardware clocks that some NICs have for PTP. They are called PTP hardware clocks (PHC). They can be used as reference clocks (specified by the `refclock` directive) and for hardware timestamping of NTP packets (enabled by the `hwtimestamp` directive) if the NIC can timestamp other packets than PTP, which is usually the case at least for transmitted packets. The `ethtool -T` command can be used to verify the timestamping support.
在 Linux 上， `chrony` 支持某些 NIC 用于 PTP 的硬件时钟。它们被称为 PTP 硬件时钟 （PHC）。如果 NIC 可以对 PTP 以外的其他数据包进行时间戳，则它们可以用作参考时钟（由 `refclock` 指令指定）和 NTP 数据包的硬件时间戳（由 `hwtimestamp` 指令启用），这通常至少对于传输的数据包是这样。该 `ethtool -T` 命令可用于验证时间戳支持。

As an experimental feature added in version 4.2, `chrony` can use PTP as a transport for NTP messages (NTP over PTP) to enable hardware timestamping on hardware which can timestamp PTP packets only. It can be enabled by the `ptpport` directive. Since version 4.5, `chrony` can also apply corrections provided by PTP one-step end-to-end transparent clocks to reach the accuracy of ordinary PTP clocks. The application of PTP corrections can be enabled by the `extfield F324` option.
作为 4.2 版中添加的一项实验性功能， `chrony` 可以使用 PTP 作为 NTP 消息的传输（NTP over PTP），以在只能对 PTP 数据包进行时间戳的硬件上启用硬件时间戳。它可以通过 `ptpport` 指令启用。从4.5版本开始， `chrony` 还可以应用PTP一步到端透明时钟提供的校正，以达到普通PTP时钟的精度。PTP校正的应用可以通过该 `extfield F324` 选项启用。

### 2.15. How can I avoid using wrong PHC refclock? 2.15. 如何避免使用错误的PHC参考时钟？

If your system has multiple PHC devices, normally named by `udev` as */dev/ptp0*, */dev/ptp1*, and so on, their order can change randomly across reboots depending on the order of initialisation of their drivers. If a PHC refclock is specified by this name, `chronyd` could be using a wrong refclock after reboot. To prevent that, you can configure `udev` to create a stable symlink for `chronyd` with a rule like this (e.g. written to */etc/udev/rules.d/80-phc.rules*):
如果您的系统有多个 PHC 设备（通常以 `udev` /dev/ptp0、/dev/ptp1 等命名），则它们的顺序可能会在重新启动时随机更改，具体取决于其驱动程序的初始化顺序。如果 PHC refclock 由此名称指定， `chronyd` 则可能在重新启动后使用了错误的 refclock。为了防止这种情况，您可以配置 `udev` 为使用这样的规则创建一个 `chronyd` 稳定的符号链接（例如，写入 /etc/udev/rules.d/80-phc.rules）：

```
KERNEL=="ptp[0-9]*", DEVPATH=="/devices/pci0000:00/0000:00:01.2/0000:02:00.0/ptp/*", SYMLINK+="ptp-i350-1"
```

You can get the full *DEVPATH* of an existing PHC device with the `udevadm info` command. You will need to execute the `udevadm trigger` command, or reboot the system, for these changes to take effect.
您可以使用该 `udevadm info` 命令获取现有 PHC 设备的完整 DEVPATH。您需要执行命令 `udevadm trigger` 或重新启动系统，才能使这些更改生效。

### 2.16. Why are client log records dropped before reaching `clientloglimit`? 2.16. 为什么客户端日志记录在到达 `clientloglimit` 之前被丢弃？

The number of dropped client log records reported by the `serverstats` command can be increasing before the number of clients reported by the `clients` command reaches the maximum value corresponding to the memory limit set by the `clientloglimit` directive.
在 `clients` 命令报告的客户端数达到 `clientloglimit` 指令设置的内存限制对应的最大值之前， `serverstats` 该命令报告的已删除客户端日志记录数可能会增加。

This is due to the design of the data structure keeping the client records. It is a hash table which can store only up to 16 colliding addresses per slot. If a slot has more collisions and the table already has the maximum size, the oldest record will be dropped and replaced by the new client.
这是由于保存客户记录的数据结构的设计。它是一个哈希表，每个插槽最多只能存储 16 个冲突地址。如果插槽的冲突较多，并且表已具有最大大小，则将删除最旧的记录并由新客户端替换。

Note that the size of the table is always a power of two and it can only grow. The limit set by the `clientloglimit` directive takes into account that two copies of the table exist when it is being resized. This means the actual memory usage reported by `top` and other utilities can be significantly smaller than the limit even when the maximum number of records is used.
请注意，表的大小始终是 2 的幂，并且只能增大。 `clientloglimit` 指令设置的限制考虑了在调整表大小时存在两个表副本。这意味着，即使使用了最大记录数，其他 `top` 实用程序报告的实际内存使用量也可能明显小于限制。

The absolute maximum number of client records kept at the same time is 16777216.
同时保留的客户端记录的绝对最大数为 16777216。

### 2.17. What happened to the `commandkey` and `generatecommandkey` directives? 2.17. `commandkey` 和 `generatecommandkey` 指令发生了什么变化？

They were removed in version 2.2. Authentication is no longer supported in the command protocol. Commands that required authentication are now allowed only through a Unix domain socket, which is accessible only by the root and *chrony* users. If you need to configure `chronyd` remotely or locally without the root password, please consider using ssh and/or sudo to run `chronyc` under the root or *chrony* user on the host where `chronyd` is running.
它们在 2.2 版中被删除。命令协议中不再支持身份验证。现在只允许通过 Unix 域套接字进行身份验证的命令，只有 root 用户和 chrony 用户才能访问该套接字。如果您需要在没有 root 密码的情况下进行远程或本地配置 `chronyd` ，请考虑使用 ssh 和/或 sudo 在运行的 `chronyd` 主机上的 root 用户或 chrony 用户下运行 `chronyc` 。

## 3. Computer is not synchronising 3.计算机不同步

This is the most common problem. There are a number of reasons, see the following questions.
这是最常见的问题。原因有很多，请看以下问题。

### 3.1. Behind a firewall? 3.1. 在防火墙后面？

Check the `Reach` value printed by the `chronyc`'s `sources` command. If it is zero, it means `chronyd` did not get any valid responses from the NTP server you are trying to use. If there is a firewall between you and the server, the requests sent to the UDP port 123 of the server or responses sent back from the port might be blocked. Try using a tool like `wireshark` or `tcpdump` to see if you are getting any responses from the server.
检查 `chronyc` 的命令 `sources` 打印的 `Reach` 值。如果为零，则表示 `chronyd` 未从您尝试使用的 NTP 服务器获得任何有效响应。如果您和服务器之间有防火墙，则发送到服务器的 UDP 端口 123 的请求或从该端口发回的响应可能会被阻止。尝试使用像 or `tcpdump` 这样的 `wireshark` 工具，看看你是否从服务器那里得到任何响应。

When `chronyd` is receiving responses from the servers, the output of the `sources` command issued few minutes after `chronyd` start might look like this:
当接收来自服务器的响应时 `chronyd` ，启动几分钟后 `chronyd` 发出 `sources` 的命令的输出可能如下所示：

```
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
^* ntp1.example.net              2   6   377    34   +484us[ -157us] +/-   30ms
^- ntp2.example.net              2   6   377    34    +33ms[  +32ms] +/-   47ms
^+ ntp3.example.net              3   6   377    35  -1397us[-2033us] +/-   60ms
```

### 3.2. Are NTP servers specified with the `offline` option? 3.2. NTP服务器是否指定了该 `offline` 选项？

Check that the `chronyc`'s `online` and `offline` commands are used appropriately (e.g. in the system networking scripts). The `activity` command prints the number of sources that are currently online and offline. For example:
检查 `chronyc` 's `online` 和 `offline` 命令的使用是否正确（例如，在系统网络脚本中）。该 `activity` 命令打印当前处于联机和脱机状态的源数。例如：

```
200 OK
3 sources online
0 sources offline
0 sources doing burst (return to online)
0 sources doing burst (return to offline)
0 sources with unknown address
```

### 3.3. Is name resolution working correctly? 3.3. 名称解析是否正常工作？

NTP servers specified by their hostname (instead of an IP address) have to have their names resolved before `chronyd` can send any requests to them. If the `activity` command prints a non-zero number of sources with unknown address, there is an issue with the resolution. Typically, a DNS server is specified in */etc/resolv.conf*. Make sure it is working correctly.
由其主机名（而不是 IP 地址）指定的 NTP 服务器必须先解析其名称，然后 `chronyd` 才能向其发送任何请求。如果该 `activity` 命令打印的地址未知的源数不为零，则分辨率存在问题。通常，DNS 服务器在 /etc/resolv.conf 中指定。确保它工作正常。

Since `chrony` version 4.0, you can run `chronyc -N sources -a` command to print all sources, even those that do not have a known address yet, with their names as they were specified in the configuration. This can be useful to verify that the names specified in the configuration are used as expected.
从版本 4.0 开始 `chrony` ，您可以运行 `chronyc -N sources -a` 命令来打印所有源，即使是那些还没有已知地址的源，以及它们在配置中指定的名称。这对于验证配置中指定的名称是否按预期使用非常有用。

### 3.4. Is `chronyd` allowed to step the system clock? 3.4. 是否 `chronyd` 允许步进系统时钟？

By default, `chronyd` adjusts the clock gradually by slowing it down or speeding it up. If the clock is too far from the true time, it will take a long time to correct the error. The `System time` value printed by the `chronyc`'s `tracking` command is the remaining correction that needs to be applied to the system clock.
默认情况下， `chronyd` 通过减慢或加快时钟来逐渐调整时钟。如果时钟与真实时间相差太远，则需要很长时间才能纠正错误。 `chronyc` `tracking` 的命令打印的 `System time` 值是需要应用于系统时钟的剩余校正。

The `makestep` directive can be used to allow `chronyd` to step the clock. For example, if *chrony.conf* had
该 `makestep` 指令可用于允许 `chronyd` 步进时钟。例如，如果 chrony.conf 有

```
makestep 1 3
```

the clock would be stepped in the first three updates if its offset was larger than one second. Normally, it is recommended to allow the step only in the first few updates, but in some cases (e.g. a computer without an RTC or virtual machine which can be suspended and resumed with an incorrect time) it might be necessary to allow the step on any clock update. The example above would change to
如果时钟的偏移量大于 1 秒，则时钟将在前三次更新中步进。通常，建议仅在前几次更新中允许该步骤，但在某些情况下（例如，没有 RTC 的计算机或虚拟机可能会以不正确的时间暂停和恢复），可能需要允许任何时钟更新的步骤。上面的示例将更改为

```
makestep 1 -1
```

### 3.5. Using NTS? 3.5. 使用NTS？

The Network Time Security (NTS) mechanism uses Transport Layer Security (TLS) to establish the keys needed for authentication of NTP packets.
网络时间安全 （NTS） 机制使用传输层安全性 （TLS） 来建立对 NTP 数据包进行身份验证所需的密钥。

Run the `authdata` command to check whether the key establishment was successful:
执行 `authdata` 命令，检查密钥建立是否成功：

```
# chronyc -N authdata
Name/IP address             Mode KeyID Type KLen Last Atmp  NAK Cook CLen
=========================================================================
ntp1.example.net             NTS     1   15  256  33m    0    0    8  100
ntp2.example.net             NTS     1   15  256  33m    0    0    8  100
ntp3.example.net             NTS     1   15  256  33m    0    0    8  100
```

The KeyID, Type, and KLen columns should have non-zero values. If they are zero, check the system log for error messages from `chronyd`. One possible cause of failure is a firewall blocking the client’s connection to the server’s TCP port 4460.
KeyID、Type 和 KLen 列应具有非零值。如果它们为零，请检查系统日志中是否有来自 `chronyd` 的错误消息。失败的一个可能原因是防火墙阻止了客户端与服务器的 TCP 端口 4460 的连接。

Another possible cause of failure is a certificate that is failing to verify because the client’s clock is wrong. This is a chicken-and-egg problem with NTS. You might need to manually correct the date, or temporarily disable NTS, in order to get NTS working. If your computer has an RTC and it is backed up by a good battery, this operation should be needed only once, assuming the RTC will be set periodically with the `rtcsync` directive, or compensated with the `rtcfile` directive and the `-s` option.
失败的另一个可能原因是证书无法验证，因为客户端的时钟错误。这是 NTS 的先有鸡还是先有蛋的问题。您可能需要手动更正日期或暂时禁用 NTS，才能使 NTS 正常工作。如果您的计算机具有 RTC  并且它由良好的电池备份，则此操作应该只需要一次，假设 RTC 将使用 `rtcsync` 指令定期设置，或者使用 `rtcfile` 指令和 `-s` 选项进行补偿。

If the computer does not have an RTC or battery, you can use the `-s` option without `rtcfile` directive to restore time of the last shutdown or reboot from the drift file. The clock will start behind the true time, but if the computer was not shut down for too long and the server’s certificate was not renewed too close to its expiration, it should be sufficient for the time checks to succeed.
如果计算机没有 RTC 或电池，则可以使用 without `rtcfile` directive `-s` 选项从漂移文件恢复上次关机或重新启动的时间。时钟将晚于真实时间开始，但如果计算机没有关闭太久，并且服务器的证书没有在接近到期时续订，则时间检查成功应该就足够了。

If you run your own server, you can use a self-signed certificate covering all dates where the client can start (e.g. years 1970-2100). The certificate needs to be installed on the client and specified with the `ntstrustedcerts` directive. The server can have multiple names and certificates. To avoid trusting a certificate for too long, a new certificate can be added to the server periodically (e.g. once per year) and the client can have the server name and trusted certificate updated automatically (e.g. using a package repository, or a cron script downloading the files directly from the server over HTTPS). A client that was shut down for years will still be able to synchronise its clock and perform the update as long as the server keeps the old certificate.
如果您运行自己的服务器，则可以使用涵盖客户端可以启动的所有日期（例如 1970-2100 年）的自签名证书。证书需要安装在客户端上，并使用 `ntstrustedcerts`  指令指定。服务器可以有多个名称和证书。为了避免信任证书的时间过长，可以定期（例如每年一次）将新证书添加到服务器，并且客户端可以自动更新服务器名称和受信任的证书（例如，使用软件包存储库，或通过HTTPS直接从服务器下载文件的cron脚本）。关闭多年的客户端仍将能够同步其时钟并执行更新，只要服务器保留旧证书。

As a last resort, you can disable the time checks by the `nocerttimecheck` directive. This has some important security implications. To reduce the security risk, you can use the `nosystemcert` and `ntstrustedcerts` directives to disable the system’s default trusted certificate authorities and trust only a minimal set of selected authorities needed to validate the certificates of used NTP servers.
作为最后的手段，您可以禁用指令 `nocerttimecheck` 的时间检查。这具有一些重要的安全隐患。为了降低安全风险，可以使用 `nosystemcert` and `ntstrustedcerts` 指令禁用系统的默认受信任证书颁发机构，并仅信任验证已用 NTP 服务器的证书所需的一组最小的选定颁发机构。

### 3.6. Using a Windows NTP server? 3.6. 使用 Windows NTP 服务器？

A common issue with Windows NTP servers is that they report a very large root dispersion (e.g. three seconds or more), which causes `chronyd` to ignore the server for being too inaccurate. The `sources` command might show a valid measurement, but the server is not selected for synchronisation. You can check the root dispersion of the server with the `chronyc`'s `ntpdata` command.
Windows NTP 服务器的一个常见问题是，它们报告的根分散非常大（例如三秒或更长时间），这会导致 `chronyd` 忽略服务器，因为服务器太不准确。该 `sources` 命令可能会显示有效的测量值，但未选择服务器进行同步。您可以使用 `chronyc` 的命令 `ntpdata` 检查服务器的根分散度。

The `maxdistance` value needs to be increased in *chrony.conf* to enable synchronisation to such a server. For example:
需要在 chrony.conf 中增加该 `maxdistance` 值才能同步到此类服务器。例如：

```
maxdistance 16.0
```

### 3.7. An unreachable source is selected? 3.7. 选择了无法访问的源？

When `chronyd` is configured with multiple time sources, it tries to select the most accurate and stable sources for synchronisation of the system clock. They are marked with the *** or *+* symbol in the report printed by the `sources` command.
当配置了多个时间源时 `chronyd` ，它会尝试选择最准确和最稳定的源来同步系统时钟。它们在 `sources` 命令打印的报告中标有 * 或 + 符号。

When the best source (marked with the *** symbol) becomes unreachable (e.g. NTP server stops responding), `chronyd` will not immediately switch to the second best source in an attempt to minimise the error of the clock. It will let the clock run free for as long as its estimated error (in terms of root distance) based on previous measurements is smaller than the estimated error of the second source, and there is still an interval which contains some measurements from both sources.
当最佳信号源（标有*符号）变得无法访问时（例如NTP服务器停止响应）， `chronyd` 不会立即切换到第二最佳信号源，以尽量减少时钟误差。只要时钟基于先前测量的估计误差（以根距离表示）小于第二个源的估计误差，并且仍然有一个间隔包含来自两个源的一些测量值，它就会让时钟自由运行。

If the first source was significantly better than the second source, it can take many hours before the second source is selected, depending on its polling interval. You can force a faster reselection by increasing the clock error rate (`maxclockerror` directive), shortening the polling interval (`maxpoll` option), or reducing the number of samples (`maxsamples` option).
如果第一个源明显优于第二个源，则可能需要数小时才能选择第二个源，具体取决于其轮询间隔。您可以通过增加时钟错误率（ `maxclockerror` 指令）、缩短轮询间隔（ `maxpoll` 选项）或减少样本数（ `maxsamples` 选项）来强制更快地重新选择。

### 3.8. Does selected source drop new measurements? 3.8. 选定的来源会丢弃新的测量值吗？

`chronyd` can drop a large number of successive NTP measurements if they are not passing some of the NTP tests. The `sources` command can report for a selected source the fully-reachable value of 377 in the Reach column and at the same time a LastRx value that is much larger than the current polling interval. If the source is online, this indicates that a number of measurements was dropped. You can use the `ntpdata` command to check the NTP tests for the last measurement. Usually, it is the test C which fails.
 `chronyd` 如果 NTP 测量未通过某些 NTP 测试，则可能会丢弃大量连续的 NTP 测量值。该 `sources` 命令可以报告所选源的 Reach 列中完全可访问的值 377，同时报告比当前轮询间隔大得多的 LastRx 值。如果源处于联机状态，则表示删除了许多测量值。您可以使用该 `ntpdata` 命令检查上次测量的 NTP 测试。通常，失败的是测试 C。

This can be an issue when there is a long-lasting increase in the measured delay, e.g. due to a routing change in the network. Unfortunately, `chronyd` does not know for how long it should wait for the delay to come back to the original values, or whether it is a permanent increase and it should start from scratch.
当测量的延迟长期增加时，例如由于网络中的路由更改，这可能是一个问题。不幸的是， `chronyd` 不知道延迟应该等待多长时间才能恢复到原始值，或者它是否是永久性增加，它应该从头开始。

The test C is an adaptive filter. It can take many hours before it accepts a measurement with the larger delay, and even much longer before it drops all measurements with smaller delay, which determine an expected delay used by the test. You can use the `reset sources` command to drop all measurements immediately (available in chrony 4.0 and later). If this issue happens frequently, you can effectively disable the test by setting the `maxdelaydevratio` option to a very large value (e.g. 1000000), or speed up the recovery by increasing the clock error rate with the `maxclockerror` directive.
测试 C 是自适应滤波器。它可能需要数小时才能接受具有较大延迟的测量值，甚至需要更长的时间才能放弃所有具有较小延迟的测量值，这决定了测试使用的预期延迟。您可以使用该 `reset sources` 命令立即删除所有测量值（在 chrony 4.0 及更高版本中可用）。如果此问题经常发生，您可以通过将 `maxdelaydevratio` 选项设置为非常大的值（例如 1000000）来有效地禁用测试，或者通过使用 `maxclockerror` 指令提高时钟错误率来加快恢复速度。

### 3.9. Using a PPS reference clock? 3.9. 使用PPS参考时钟？

A pulse-per-second (PPS) reference clock requires a non-PPS time source to determine which second of UTC corresponds to each pulse. If it is another reference clock specified with the `lock` option in the `refclock` directive, the offset between the two reference clocks must be smaller than 0.4 seconds (0.2 seconds with `chrony` versions before 4.1) in order for the PPS reference clock to work. With NMEA reference clocks it is common to have a larger offset. It needs to be corrected with the `offset` option.
每秒脉冲 （PPS） 参考时钟需要非 PPS 时间源来确定 UTC 的哪一秒对应于每个脉冲。如果它是 `refclock` 使用指令 `lock` 中的选项指定的另一个参考时钟，则两个参考时钟之间的偏移量必须小于 0.4 秒（4.1 之前 `chrony` 的版本为 0.2 秒），PPS 参考时钟才能工作。对于NMEA参考时钟，通常具有较大的偏移量。它需要用选项 `offset` 进行更正。

One approach to find out a good value of the `offset` option is to configure the reference clocks with the `noselect` option and compare them to an NTP server. For example, if the `sourcestats` command showed
找出该 `offset` 选项的良好值的一种方法是使用该 `noselect` 选项配置参考时钟，并将它们与NTP服务器进行比较。例如，如果 `sourcestats` 命令显示

```
Name/IP Address            NP  NR  Span  Frequency  Freq Skew  Offset  Std Dev
==============================================================================
PPS0                        0   0     0     +0.000   2000.000     +0ns  4000ms
NMEA                       58  30   231    -96.494     38.406   +504ms  6080us
ntp1.example.net            7   3   200     -2.991     16.141   -107us   492us
```

the offset of the NMEA source would need to be increased by about 0.504 seconds. It does not have to be very accurate. As long as the offset of the NMEA reference clock stays below the limit, the PPS reference clock should be able to determine the seconds corresponding to the pulses and allow the samples to be used for synchronisation.
NMEA 源的偏移量需要增加约 0.504 秒。它不必非常准确。只要NMEA参考时钟的偏移量保持在限值以下，PPS参考时钟就应该能够确定与脉冲对应的秒数，并允许使用样本进行同步。

## 4. Issues with `chronyc` 4. 问题 `chronyc` 

### 4.1. I keep getting the error `506 Cannot talk to daemon` 4.1. 我不断收到错误 `506 Cannot talk to daemon` 

When accessing `chronyd` remotely, make sure that the *chrony.conf* file (on the computer where `chronyd` is running) has a `cmdallow` entry for the computer you are running `chronyc` on and an appropriate `bindcmdaddress` directive. This is not necessary for localhost.
 `chronyd` 远程访问时，请确保 chrony.conf 文件（在 `chronyd` 运行的计算机上）具有运行计算机 `chronyc` 的 `cmdallow` 条目和相应的 `bindcmdaddress` 指令。对于localhost来说，这不是必需的。

Perhaps `chronyd` is not running. Try using the `ps` command (e.g. on Linux, `ps -auxw`) to see if it is running. Or try `netstat -a` and see if the UDP port 323 is listening. If `chronyd` is not running, you might have a problem with the way you are trying to start it (e.g. at boot time).
也许 `chronyd` 没有运行。尝试使用命令 `ps` （例如在 Linux 上） `ps -auxw` 查看它是否正在运行。或者尝试 `netstat -a` 查看 UDP 端口 323 是否正在侦听。如果 `chronyd` 未运行，则可能是尝试启动它的方式有问题（例如，在启动时）。

Perhaps you have a firewall set up in a way that blocks packets on the UDP port 323. You need to amend the firewall configuration in this case.
也许您设置了防火墙，以阻止 UDP 端口 323 上的数据包。在这种情况下，您需要修改防火墙配置。

### 4.2. I keep getting the error `501 Not authorised` 4.2. 我不断收到错误 `501 Not authorised` 

This error indicates that `chronyc` sent the command to `chronyd` using a UDP socket instead of the Unix domain socket (e.g. */var/run/chrony/chronyd.sock*), which is required for some commands. For security reasons, only the root and *chrony* users are allowed to access the socket.
此错误表示 `chronyd` 使用 UDP 套接字 `chronyc` 而不是 Unix 域套接字（例如 /var/run/chrony/chronyd.sock）将命令发送到，这是某些命令所必需的。出于安全原因，只允许 root 用户和 chrony 用户访问套接字。

It is also possible that the socket does not exist. `chronyd` will not create the socket if the directory has a wrong owner or permissions. In this case there should be an error message from `chronyd` in the system log.
套接字也可能不存在。 `chronyd` 如果目录具有错误的所有者或权限，则不会创建套接字。在这种情况下，系统日志中应该有一条错误消息 `chronyd` 。

### 4.3. What is the reference ID reported by the `tracking` command? 4.3. `tracking` 命令报告的引用 ID 是什么？

The reference ID is a 32-bit value used in NTP to prevent synchronisation loops.
引用 ID 是 NTP 中用于防止同步循环的 32 位值。

In `chrony` versions before 3.0 it was printed in the quad-dotted notation, even if the reference source did not actually have an IPv4 address. For IPv4 addresses, the reference ID is equal to the address, but for IPv6 addresses it is the first 32 bits of the MD5 sum of the address. For reference clocks, the reference ID is the value specified with the `refid` option in the `refclock` directive.
在 `chrony` 3.0 之前的版本中，它以四点表示法打印，即使参考源实际上没有 IPv4 地址。对于 IPv4 地址，引用 ID 等于地址，但对于 IPv6 地址，它是地址的 MD5 总和的前 32 位。对于参考时钟，参考 ID 是使用 `refclock` 指令 `refid` 中的选项指定的值。

Since version 3.0, the reference ID is printed as a hexadecimal number to avoid confusion with IPv4 addresses.
从版本 3.0 开始，引用 ID 打印为十六进制数，以避免与 IPv4 地址混淆。

If you need to get the IP address of the current reference source, use the `-n` option to disable resolving of IP addresses and read the second field (printed in parentheses) on the `Reference ID` line.
如果需要获取当前参考源的 IP 地址，请使用 `-n` 禁用 IP 地址解析的选项并阅读 `Reference ID` 行上的第二个字段（打印在括号中）。

### 4.4. Is the `chronyc` / `chronyd` protocol documented anywhere? 4.4. `chronyc` / `chronyd` 协议是否记录在任何地方？

Only by the source code. See *cmdmon.c* (`chronyd` side) and *client.c* (`chronyc` side).
仅通过源代码。请参阅 cmdmon.c（ `chronyd` 端）和 client.c（ `chronyc` 端）。

Note that this protocol is not compatible with the mode 6 or mode 7 protocol supported by `ntpd`, i.e. the `ntpq` or `ntpdc` utility cannot be used to monitor `chronyd`, and `chronyc` cannot be used to monitor `ntpd`.
请注意，该协议与 `ntpd` 支持的模式 6 或模式 7 协议不兼容，即 `ntpq` or `ntpdc` 实用程序不能用于监控 `chronyd` ，也不能 `chronyc` 用于监控 `ntpd` 。

## 5. Real-time clock issues 5. 实时时钟问题

### 5.1. What is the real-time clock (RTC)? 5.1. 什么是实时时钟（RTC）？

This is the clock which keeps the time even when your computer is turned off. It is used to initialise the system clock on boot. It normally does not drift more than few seconds per day.
这是即使在计算机关闭时也能保持时间的时钟。它用于初始化启动时的系统时钟。它通常每天漂移不超过几秒钟。

There are two approaches how `chronyd` can work with it. One is to use the `rtcsync` directive, which tells `chronyd` to enable a kernel mode which sets the RTC from the system clock every 11 minutes. `chronyd` itself will not touch the RTC. If the computer is not turned off for a long time, the RTC should still be close to the true time when the system clock will be initialised from it on the next boot.
有两种方法可以 `chronyd` 使用它。一种是使用指令 `rtcsync` ，该指令告诉 `chronyd` 启用内核模式，该模式每 11 分钟从系统时钟设置 RTC。 `chronyd` 本身不会接触 RTC。如果计算机长时间未关闭，则 RTC 仍应接近下次启动时从它初始化系统时钟的真实时间。

The other option is to use the `rtcfile` directive, which tells `chronyd` to monitor the rate at which the RTC gains or loses time. When `chronyd` is started with the `-s` option on the next boot, it will set the system time from the RTC and also compensate for the drift it has measured previously. The `rtcautotrim` directive can be used to keep the RTC close to the true time, but it is not strictly necessary if its only purpose is to set the system clock when `chronyd` is started on boot. See the documentation for details.
另一种选择是使用指令 `rtcfile` ，该指令告诉 `chronyd` 监视 RTC 获得或失去时间的速率。当在下次启动时使用该 `-s` 选项启动时 `chronyd` ，它将从 RTC 设置系统时间，并补偿之前测量的漂移。该 `rtcautotrim` 指令可用于使 RTC 接近真实时间，但如果其唯一目的是在启动时 `chronyd` 设置系统时钟，则并非绝对必要。有关详细信息，请参阅文档。

### 5.2. Does `hwclock` have to be disabled? 5.2. `hwclock` 必须禁用吗？

The `hwclock` program is run by default in the boot and/or shutdown scripts in some Linux installations. With the kernel RTC synchronisation (`rtcsync` directive), the RTC will be set also every 11 minutes as long as the system clock is synchronised. If you want to use `chronyd`'s RTC monitoring (`rtcfile` directive), it is important to disable `hwclock` in the shutdown procedure. If you do not do that, it will overwrite the RTC with a new value, unknown to `chronyd`. At the next reboot, `chronyd` started with the `-s` option will compensate this (wrong) time with its estimate of how far the RTC has drifted whilst the power was off, giving a meaningless initial system time.
默认情况下， `hwclock` 该程序在某些 Linux 安装的引导和/或关闭脚本中运行。使用内核 RTC 同步（ `rtcsync` 指令），只要系统时钟同步，RTC 也将每 11 分钟设置一次。如果要使用 `chronyd` 的 RTC 监控（ `rtcfile` 指令），请务必在关机过程中禁用 `hwclock` 。如果不这样做，它将用一个未知 `chronyd` 的新值覆盖 RTC。在下次重新启动时， `chronyd` 从 `-s` 该选项开始将补偿这个（错误的）时间，并估计 RTC 在电源关闭时漂移了多远，从而给出毫无意义的初始系统时间。

There is no need to remove `hwclock` from the boot process, as long as `chronyd` is started after it has run.
无需从启动过程中删除 `hwclock` ，只要 `chronyd` 在启动过程运行后启动即可。

### 5.3. I just keep getting the `513 RTC driver not running` message 5.3. 我只是不断收到 `513 RTC driver not running` 消息

For the real-time clock support to work, you need the following three things
要使实时时钟支持正常工作，您需要以下三件事

- an RTC in your computer
  计算机中的 RTC
- a Linux kernel with enabled RTC support
  启用了 RTC 支持的 Linux 内核
- an `rtcfile` directive in your *chrony.conf* file
  chrony.conf 文件中的 `rtcfile` 指令

### 5.4. I get `Could not open /dev/rtc, Device or resource busy` in my syslog file 5.4. 我进入 `Could not open /dev/rtc, Device or resource busy` 我的 syslog 文件

Some other program running on the system might be using the device.
系统上运行的其他程序可能正在使用该设备。

### 5.5. When I start `chronyd`, the log says `Could not enable RTC interrupt : Invalid argument` (or it may say `disable`) 5.5. 当我开始时 `chronyd` ，日志说 `Could not enable RTC interrupt : Invalid argument` （或者它可能会说 `disable` ）

Your real-time clock hardware might not support the required ioctl requests:
您的实时时钟硬件可能不支持所需的 ioctl 请求：

- `RTC_UIE_ON`
- `RTC_UIE_OFF`

A possible solution could be to build the Linux kernel with support for software emulation instead; try enabling the following configuration option when building the Linux kernel:
一个可能的解决方案是构建支持软件仿真的 Linux 内核;在构建 Linux 内核时，请尝试启用以下配置选项：

- `CONFIG_RTC_INTF_DEV_UIE_EMUL`

### 5.6. What if my computer does not have an RTC or backup battery? 5.6. 如果我的电脑没有 RTC 或备用电池怎么办？

In this case you can still use the `-s` option to set the system clock to the last modification time of the drift file, which should correspond to the system time when `chronyd` was previously stopped. The initial system time will be increasing across reboots and applications started after `chronyd` will not observe backward steps.
在这种情况下，您仍然可以使用该 `-s` 选项将系统时钟设置为漂移文件的上次修改时间，该时间应与之前停止时 `chronyd` 的系统时间相对应。重新启动后的初始系统时间将增加，之后 `chronyd` 启动的应用程序不会观察到向后步骤。

## 6. NTP-specific issues 6. NTP 特定问题

### 6.1. Can `chronyd` be driven from broadcast/multicast NTP servers? 6.1. 是否可以 `chronyd` 从广播/组播NTP服务器驱动？

No, the broadcast/multicast client mode is not supported and there is currently no plan to implement it. While this mode can simplify configuration of clients in large networks, it is inherently less accurate and less secure (even with authentication) than the ordinary client/server mode.
不支持广播/组播客户端模式，目前没有计划实现它。虽然此模式可以简化大型网络中客户端的配置，但与普通客户端/服务器模式相比，它本质上不那么准确且安全性较低（即使使用身份验证）。

When configuring a large number of clients in a network, it is recommended to use the `pool` directive with a DNS name which resolves to addresses of multiple NTP servers. The clients will automatically replace the servers when they become unreachable, or otherwise unsuitable for synchronisation, with new servers from the pool.
在网络中配置大量客户端时，建议使用带有 DNS 名称的 `pool` 指令，该名称解析为多个 NTP 服务器的地址。当服务器无法访问或不适合同步时，客户端将自动将服务器替换为池中的新服务器。

Even with very modest hardware, an NTP server can serve time to hundreds of thousands of clients using the ordinary client/server mode.
即使使用非常适度的硬件，NTP 服务器也可以使用普通的客户端/服务器模式为数十万个客户端提供时间。

### 6.2. Can `chronyd` transmit broadcast NTP packets? 6.2. 可以传输广播NTP数据包吗 `chronyd` ？

Yes, the `broadcast` directive can be used to enable the broadcast server mode to serve time to clients in the network which support the broadcast client mode (it is not supported in `chronyd`). Note that this mode should generally be avoided. See the previous question.
是的，该 `broadcast` 指令可用于使广播服务器模式能够为网络中支持广播客户端模式的客户端提供时间（在 中 `chronyd` 不受支持）。请注意，通常应避免使用此模式。请参阅上一个问题。

### 6.3. Can `chronyd` keep the system clock a fixed offset away from real time? 6.3. 能否 `chronyd` 使系统时钟保持固定偏移量，远离实时？

Yes. Starting from version 3.0, an offset can be specified by the `offset` option for all time sources in the *chrony.conf* file.
是的。从版本 3.0 开始，可以通过 chrony.conf 文件中所有时间源的 `offset` 选项指定偏移量。

### 6.4. What happens if the network connection is dropped without using `chronyc`'s `offline` command first? 6.4. 如果网络连接在未先使用 `chronyc` 的命令 `offline` 的情况下断开，会发生什么情况？

`chronyd` will keep trying to access the sources that it thinks are online, and it will take longer before new measurements are actually made and the clock is corrected when the network is connected again. If the sources were set to offline, `chronyd` would make new measurements immediately after issuing the `online` command.
 `chronyd` 将继续尝试访问它认为在线的来源，并且在实际进行新的测量并在再次连接网络时校正时钟之前需要更长的时间。如果源设置为脱机， `chronyd` 则在发出 `online` 命令后将立即进行新的测量。

Unless the network connection lasts only few minutes (less than the maximum polling interval), the delay is usually not a problem, and it might be acceptable to keep all sources online all the time.
除非网络连接仅持续几分钟（小于最大轮询间隔），否则延迟通常不是问题，并且始终保持所有源在线可能是可以接受的。

### 6.5. Why is an offset measured between two computers synchronised to each another? 6.5. 为什么两台计算机之间的偏移量是相互同步的？

When two computers are synchronised to each other using the client/server or symmetric NTP mode, there is an expectation that NTP measurements between the two computers made on both ends show an average offset close to zero.
当两台计算机使用客户端/服务器或对称 NTP 模式相互同步时，预计两台计算机之间的 NTP 测量值在两端进行，平均偏移量接近于零。

With `chronyd` that can be expected only when the interleaved mode is enabled by the `xleave` option. Otherwise, `chronyd` will use different transmit timestamps (e.g. daemon timestamp vs kernel timestamp) for serving time and synchronisation of its own clock, which will cause the other computer to measure a significant offset.
只有当 `xleave` 该选项启用交错模式时，才能预期 `chronyd` 。否则， `chronyd` 将使用不同的传输时间戳（例如守护进程时间戳与内核时间戳）来提供时间和同步自己的时钟，这将导致另一台计算机测量显着的偏移量。

## 7. Operation 7. 操作

### 7.1. What clocks does `chronyd` use? 7.1. 使用 `chronyd` 什么时钟？

There are several different clocks used by `chronyd`:
有几种不同的时钟使用 `chronyd` ：

- **System clock:** software clock maintained by the kernel. It is the main clock used by applications running on the computer. It is synchronised by `chronyd` to its NTP clock, unless started with the **-x** option.
  系统时钟：由内核维护的软件时钟。它是计算机上运行的应用程序使用的主时钟。它与 NTP 时钟同步 `chronyd` ，除非以 -x 选项启动。
- **NTP clock:** software clock (virtual) based on the system clock and internal to `chronyd`. It keeps the best estimate of the true time according to the configured time sources, which is served to NTP clients unless time smoothing is enabled by the **smoothtime** directive. The **System time** value in the `tracking` report is the current offset between the system and NTP clock.
  NTP时钟：软件时钟（虚拟）基于系统时钟和内部时钟 `chronyd` 。它根据配置的时间源保留真实时间的最佳估计值，除非 smoothtime 指令启用了时间平滑，否则将提供给 NTP 客户端。 `tracking` 报告中的系统时间值是系统和 NTP 时钟之间的电流偏移量。
- **Real-time clock (RTC):** hardware clock keeping time even when the computer is turned off. It is used by the kernel to initialise the system clock on boot and also by `chronyd` to compensate for its measured drift if configured with the `rtcfile` directive and started with the `-s` option. The clock can be kept accurate only by stepping enabled by the `rtcsync` or `rtcautotrim` directive.
  实时时钟 （RTC）：硬件时钟保持时间，即使在计算机关闭时也是如此。内核使用它来初始化引导时的系统时钟，如果使用 `rtcfile` 指令配置并使用 `-s` 选项启动，则 `chronyd` 还可以补偿其测量的漂移。只有通过 `rtcsync` or `rtcautotrim` 指令启用步进才能保持时钟准确。
- **Reference clock:** hardware clock used as a time source. It is specified by the `refclock` directive.
  参考时钟：用作时间源的硬件时钟。它由 `refclock` 指令指定。
- **NIC clock (also known as PTP hardware clock):** hardware clock timestamping packets received and transmitted by a network device specified by the **hwtimestamp** directive. The clock is expected to be running free. It is not synchronised by `chronyd`. Its offset is tracked relative to the NTP clock in order to convert the hardware timestamps.
  NIC 时钟（也称为 PTP 硬件时钟）：由 hwtimestamp 指令指定的网络设备接收和传输的数据包的硬件时钟时间戳。预计时钟将免费运行。它与 不同步 `chronyd` 。其偏移量相对于NTP时钟进行跟踪，以便转换硬件时间戳。
