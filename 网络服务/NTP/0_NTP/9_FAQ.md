# FAQ 和 HOWTO

[TOC]

## 概述

------

#### 4.1.5 Which Operating Systems are supported? 4.1.5 支持哪些操作系统？

The implementation described in [4.3.2 UNIX Systems](https://www.ntp.org/ntpfaq/ntp-s-def-impl/#432-unix-systems) works for most popular UNIX operating systems, including AIX, FreeBSD, HP-UX, Linux, NetBSD, OpenBSD, and Solaris.
4.3.2 UNIX Systems 中描述的实现适用于大多数流行的 UNIX 操作系统，包括 AIX、FreeBSD、HP-UX、Linux、NetBSD、OpenBSD 和 Solaris。

Meinberg provides a [GUI installer](https://www.meinbergglobal.com/english/sw/ntp.htm#ntp_stable) for Window XP and later.
Meinberg 为 Window XP 及更高版本提供了 GUI 安装程序。

For more detailed information see [Section 4.3](https://www.ntp.org/ntpfaq/ntp-s-def-impl/).
有关详细信息，请参见第 4.3 节。

------

#### 4.1.6 How many NTP servers are available in the Internet? 4.1.6 Internet 中有多少台 NTP 服务器可用？

According to [A Survey of the NTP Network](https://www.ntp.org/reflib/reports/ntp-survey99-minar.pdf)(1999) there were at least 175,000 hosts running NTP in the Internet. Among these there were over 300 valid *stratum-1* servers. In addition there were over 20,000 servers at stratum 2, and over 80,000 servers at stratum 3.
根据 NTP 网络调查（1999 年），互联网上至少有 175,000 台主机运行 NTP。其中有 300 多个有效的 stratum-1 服务器。此外，第 2 层有 20,000 多台服务器，第 3 层有 80,000 多台服务器。

------

#### 4.1.7 Which version of NTP should I use? 4.1.7 我应该使用哪个版本的 NTP？

[RFC 5905 Network Time Protocol Version 4: Protocol and Algorithms Specification](https://www.ntp.org/reflib/rfc/rfc5905.txt) is the current standard, obsoleting [RFC 1305 Network Time Protocol (Version 3) Specification, Implementation and Analysis](https://www.ntp.org/reflib/rfc/rfc1305/rfc1305b.pdf).
RFC 5905 网络时间协议第 4 版：协议和算法规范是当前标准，已过时 RFC 1305 网络时间协议（第 3 版）规范、实现和分析。

It is recommended to run the latest [series](https://www.ntp.org/documentation/4.2.8-series/) and patch level (currently 4.2.8p15) to ensure the system has the latest features and security fixes.
建议运行最新的系列和补丁级别（当前为 4.2.8p15），以确保系统具有最新的功能和安全修复。

If you are worried about compatibility issues, older client versions can  generally talk to newer version servers automagically as newer servers  know how to answer older client queries, but the other direction  requires manual configuration using [the `version` keyword](https://www.ntp.org/documentation/4.2.8-series/confopt/#server-command-options).
如果您担心兼容性问题，较旧的客户端版本通常可以自动与较新版本的服务器通信，因为较新的服务器知道如何回答较旧的客户端查询，但另一个方向需要使用 `version` 关键字进行手动配置。

See also [Section 6.4 Compatibility](https://www.ntp.org/ntpfaq/ntp-s-compat/).
另请参见第 6.4 节 兼容性。

------

#### 4.1.8 What’s the difference between xntp and ntp? 4.1.8 xntp 和 ntp 有什么区别？

Obviously the difference is an `x`, and its meaning some years ago was (according to [Professor David L. Mills](https://www.nwtime.org/tribute-to-david-l-mills/)):
显然，区别在于， `x` 几年前它的含义是（根据 David L. Mills 教授的说法）：

Dennis Fergusson intended the `x` as “experimental”. I got maybe twenty messages over the years suggesting the `x` was not appropriate for code in use over a decade and I dropped it for NTPv4. See the paper on [NTP history](https://www.ntp.org/reflib/memos/hist.txt).
丹尼斯·弗格森（Dennis Fergusson）打算将其 `x` 作为“实验性”。这些年来，我收到了大约二十条消息，表明它 `x` 不适合十多年来使用的代码，我将其用于 NTPv4。请参阅有关 NTP 历史的论文。

In practice `xntp` refers to an implementation of version three or older while `ntp` refers to implementations of version four or later.
在实践中 `xntp` 是指版本三或更早版本的实现，而 `ntp` 是指版本四或更高版本的实现。

# 4.2 History 4.2 历史

Last update: June 27, 2022 16:22 UTC ([1a7aee0a0](https://git.nwtime.org/websites/ntpwww/commit/1a7aee0a0bed1662a9f219fcaea42e57cff5d0b3))
最后更新： 2022年6月27日 16：22 UTC （ 1a7aee0a0）

This section summarizes the history of NTP in a few words. Most material has been taken from a draft of [A Brief History of NTP Time: Confessions of an Internet Timekeeper](https://www.ntp.org/reflib/memos/hist.txt) by Professor David L. Mills.
本节用几句话总结了 NTP 的历史。大多数材料摘自David L. Mills教授的《NTP时间简史：互联网计时员的自白》的草稿。

------

The first NTP implementation started around 1980 with an accuracy of only  several hundred milliseconds. That very first implementation was  documented in Internet Engineering Note [IEN-173](https://www.ntp.org/reflib/rfc/ien-173.txt). Later the first specification appeared in [RFC 778](https://www.rfc-editor.org/rfc/rfc778), but it was still named *Internet Clock Service*. At that time clock synchronization was needed for the HELLO routing protocol. NTP was introduced in [RFC 958](https://www.rfc-editor.org/rfc/rfc958) for the first time, mainly describing the packets seen on the network  as well as some basic calculations involved. Early versions of NTP did  not compensate any frequency error.
第一个 NTP 实现始于 1980 年左右，精度仅为几百毫秒。第一个实现记录在互联网工程说明 IEN-173 中。后来，第一个规范出现在 RFC  778 中，但它仍然被命名为 Internet Clock Service。当时，HELLO 路由协议需要时钟同步。NTP 首次在 RFC  958 中引入，主要描述在网络上看到的数据包以及涉及的一些基本计算。早期版本的 NTP 没有补偿任何频率误差。

The first complete specification of the protocol and accompanying algorithms for NTP version 1 appeared 1988 in [RFC 1059](https://www.ntp.org/reflib/rfc/rfc1059.txt). That version already had symmetric operation mode as well as client-server mode.
NTP 版本 1 的协议和随附算法的第一个完整规范出现在 1988 年的 RFC 1059 中。该版本已经具有对称操作模式以及客户端-服务器模式。

Version 2 introducing symmetric-key authentication (using DES-CBC) was described in [RFC 1119](https://www.ntp.org/reflib/rfc/rfc1119/rfc1119b.pdf) only about one year later. About the same time another time sychronization protocol named *Digital Time Synchronization Service* (DTSS) was presented by Digital Equipment Corporation. At that time the software named `xntp` was written by Dennis Fergusson at the University of Toronto. That  software evolved to the software distribution that is publically  available now.
大约一年后，RFC 1119 中描述了引入对称密钥身份验证（使用 DES-CBC）的版本 2。大约在同一时间，数字设备公司提出了另一种名为数字时间同步服务（DTSS）的时间同步协议。当时命名 `xntp` 的软件是由多伦多大学的丹尼斯·弗格森（Dennis Fergusson）编写的。该软件演变为现在公开可用的软件发行版。

Combining the good ideas of DTSS with those of NTP produced a new specification for NTP version 3, namely [RFC 1305](https://www.ntp.org/reflib/rfc/rfc1305/rfc1305b.pdf), in 1992. That version introduced formal correctness principles [`esterror` and `maxerror`](https://www.ntp.org/ntpfaq/ntp-s-algo-kernel/#522-monitoring) and revised algorithms. Furthermore, broadcast mode was added to the protocol.
1992 年，将 DTSS 的好想法与 NTP 的好想法相结合，为 NTP 版本 3 制定了新的规范，即 RFC 1305。该版本引入了形式正确性原则 `esterror` ， `maxerror` 并修订了算法。此外，协议中还添加了广播模式。

While NTP per se only deals with adjusting the operating system’s clock,  there was some parallel research on improving time keeping within the  operating system’s kernel. [RFC 1589 A kernel model for precision timekeeping](https://www.ntp.org/reflib/rfc/rfc1589.txt) described a new implementation and interface in 1994. That  implementation could keep time with a precision of up to one  microsecond.
虽然 NTP 本身只涉及调整操作系统的时钟，但有一些关于改进操作系统内核内计时的并行研究。RFC 1589 1994 年，用于精确计时的内核模型描述了一种新的实现和接口。这种实现可以保持时间的精度高达一微秒。

The specification and the implementation has been continuously improved. The first new specification was [RFC 2030 Simple Network Time Protocol (SNTP) version 4 for IPv4, IPv6 and OSI](https://www.ntp.org/reflib/rfc/rfc2030.txt).
规范和实现不断改进。第一个新规范是 RFC 2030 简单网络时间协议 （SNTP） 版本 4，用于 IPv4、IPv6 和 OSI。

External pulses can be used to calibrate and stabilize the operating system’s  clock. Therefore an operating system interface (API) has been designed  and documented in [RFC 2783 Pulse-per-second API for Unix-like operating systems, version 1](https://www.ntp.org/reflib/rfc/rfc2783.txt), published in 1999.
外部脉冲可用于校准和稳定操作系统的时钟。因此，操作系统接口 （API） 已设计并记录在 1999 年发布的 RFC 2783 类 Unix 操作系统的脉冲每秒 API 第 1 版中。

NTPv4, defined in [RFC 5909](https://www.ntp.org/reflib/rfc/rfc5905.txt) provides features regarding automatic configuration (manycast mode),  reliability, Internet traffic reduction, and authentication using  public-key cryptography. Its kernel clock model can keep time with a  precision of up to one nanosecond.
RFC 5909 中定义的 NTPv4 提供了有关自动配置（组播模式）、可靠性、减少 Internet 流量和使用公钥加密进行身份验证的功能。它的内核时钟模型可以以高达一纳秒的精度保持时间。

# 4.3. Implementations and Platforms 4.3. 实现和平台

Last update: April 22, 2024 18:49 UTC ([7e7bd5857](https://git.nwtime.org/websites/ntpwww/commit/7e7bd5857f893277639b3765bf9347c4c6faa447))
最后更新： 2024年4月22日 18：49 UTC （ 7e7bd5857）

This section discusses implementations of NTP for various platforms.
本节讨论适用于各种平台的 NTP 实现。

For platforms and operating systems other than those mentioned here, there  may be software available. Maybe there are binary program packages  available for your computer system. A good starting point is to search  this website. Specific products are presented in [Section 8.3](https://www.ntp.org/ntpfaq/ntp-s-trbl-spec/).
对于此处提到的平台和操作系统以外的平台和操作系统，可能有可用的软件。也许有适用于您的计算机系统的二进制程序包。一个好的起点是搜索这个网站。具体产品在第 8.3 节中介绍。

4.3.1 [Official Providers](https://www.ntp.org/ntpfaq/ntp-s-def-impl/#431-official-providers)
4.3.1 官方供应商 
 4.3.2 [UNIX Systems](https://www.ntp.org/ntpfaq/ntp-s-def-impl/#432-unix-systems) 4.3.2 UNIX 系统
 4.3.3 [Microsoft Windows](https://www.ntp.org/ntpfaq/ntp-s-def-impl/#433-microsoft-windows)

------

#### 4.3.1 Official Providers 4.3.1 官方供应商

Several national time keepers allow reading the time via NTP:
一些国家计时员允许通过 NTP 读取时间：

- [NIST](https://www.nist.gov/time-frequency) (USA) NIST（美国）
- [USNO](https://www.cnmoc.usff.navy.mil/Our-Commands/United-States-Naval-Observatory/Precise-Time-Department/Network-Time-Protocol-NTP/) (USA) USNO （美国）
- [PTB](https://www.ptb.de/cms/en/ptb/fachabteilungen/abtq/gruppe-q4/ref-q42/time-synchronization-of-computers-using-the-network-time-protocol-ntp.html) (Germany) PTB （德国）

------

#### 4.3.2 UNIX Systems 4.3.2 UNIX 系统

The reference implementation of the NTP client and server is [available for free](https://downloads.nwtime.org/ntp/). The software is available as C source and it runs on most  UNIX-compatible operating systems. The software consists of the  following components:
NTP 客户端和服务器的参考实现是免费提供的。该软件可作为 C 源代码使用，可在大多数 UNIX 兼容操作系统上运行。该软件由以下组件组成：

- ntpd NTPD的

  A daemon process that is both client and server. 既是客户端又是服务器的守护进程。

- ntpdate NTPData（英语：NTPDATE）

  A utility to set the time once, similar to the popular `rdate` command. 一个用于设置一次时间的实用程序，类似于流行的 `rdate` 命令。

- ntpq, ntpdc NTPQ、NTPDC

  Monitoring and control programs that communicate via UDP with `ntpd`. 通过 UDP 与 `ntpd` .

- ntptrace

  A utility to back-trace the current system time, starting from the local server. 用于从本地服务器开始回溯当前系统时间的实用程序。

- documentation 文档

  The [documentation](https://www.ntp.org/documentation/4.2.8-series/) for the software is definitely worth reading. 该软件的文档绝对值得一读。

- scripts 脚本

  There are also several scripts that might be useful or at least a source of ideas if you want to run and monitor NTP. 如果要运行和监视 NTP，还有一些脚本可能很有用，或者至少是一些想法的来源。

------

#### 4.3.3 Microsoft Windows

NTP is the default time synchronization protocol used by the Windows Time  service in Windows Server 2012 and higher, Windows 10 or later, and  Azure Stack HCI. In addition, SNTP support is included for backwards  compatibility with older clients. Refer to [How the Windows Time Service Works](https://learn.microsoft.com/en-us/windows-server/networking/windows-time-service/how-the-windows-time-service-works) for more information.
NTP 是 Windows Server 2012 及更高版本、Windows 10 或更高版本以及 Azure Stack HCI 中的  Windows 时间服务使用的默认时间同步协议。此外，还包括 SNTP 支持，以便向后兼容旧客户端。有关详细信息，请参阅 Windows  时间服务的工作原理。

Meinberg provides a [GUI installer](https://www.meinbergglobal.com/english/sw/ntp.htm#ntp_stable) of the latest NTP version for Window XP and later.
Meinberg 为 Window XP 及更高版本提供了最新 NTP 版本的 GUI 安装程序。

# How does it work? 5. 它是如何工作的？

Last update: June 27, 2022 16:22 UTC ([1a7aee0a0](https://git.nwtime.org/websites/ntpwww/commit/1a7aee0a0bed1662a9f219fcaea42e57cff5d0b3))
最后更新： 2022年6月27日 16：22 UTC （ 1a7aee0a0）

This section will try to explain how NTP will construct and maintain a working time synchronization network.
本节将尝试解释NTP将如何构建和维护工作时间同步网络。

#### 5.1 Basic Concepts 5.1 基本概念

To help understand the details of planning, configuring, and maintaining  NTP, some basic concepts are presented here. The focus in this section  is on theory.
为了帮助理解规划、配置和维护 NTP 的详细信息，此处介绍了一些基本概念。本节的重点是理论。

5.1.1 [Time References](https://www.ntp.org/ntpfaq/ntp-s-algo/#511-time-references) 5.1.1 时间参考
 5.1.1.1 [What is a reference clock?](https://www.ntp.org/ntpfaq/ntp-s-algo/#5111-what-is-a-reference-clock)
5.1.1.1 什么是参考时钟？
 5.1.1.2 [How will NTP use a reference clock?](https://www.ntp.org/ntpfaq/ntp-s-algo/#5112-how-will-ntp-use-a-reference-clock)
5.1.1.2 NTP如何使用参考时钟？
 5.1.1.3 [How will NTP know about Time Sources?](https://www.ntp.org/ntpfaq/ntp-s-algo/#5113-how-will-ntp-know-about-time-sources)
5.1.1.3 NTP如何知道时间源？
 5.1.1.4 [What happens if the Reference Time changes?](https://www.ntp.org/ntpfaq/ntp-s-algo/#5114-what-happens-if-the-reference-time-changes)
5.1.1.4 如果参考时间发生变化会怎样？
 5.1.1.5 [What is a stratum 1 Server?](https://www.ntp.org/ntpfaq/ntp-s-algo/#5115-what-is-a-stratum-1-server)
5.1.1.5 什么是第 1 层服务器？
 5.1.2 [Time Exchange](https://www.ntp.org/ntpfaq/ntp-s-algo/#512-time-exchange) 5.1.2 时间交换
 5.1.2.1 [How is Time synchronized?](https://www.ntp.org/ntpfaq/ntp-s-algo/#5121-how-is-time-synchronized)
5.1.2.1 时间是如何同步的？
 5.1.2.2 [Which Network Protocols are used by NTP?](https://www.ntp.org/ntpfaq/ntp-s-algo/#5122-which-network-protocols-are-used-by-ntp)
5.1.2.2 NTP使用哪些网络协议？
 5.1.2.3 [How is Time encoded in NTP?](https://www.ntp.org/ntpfaq/ntp-s-algo/#5123-how-is-time-encoded-in-ntp)
5.1.2.3 NTP中的时间是如何编码的？
 5.1.2.4 [When are the Servers polled?](https://www.ntp.org/ntpfaq/ntp-s-algo/#5124-when-are-the-servers-polled)
5.1.2.4 何时轮询服务器？
 5.1.3 [Performance](https://www.ntp.org/ntpfaq/ntp-s-algo/#513-performance) 5.1.3 性能
 5.1.3.1 [How accurate will my Clock be?](https://www.ntp.org/ntpfaq/ntp-s-algo/#5131-how-accurate-will-my-clock-be)
5.1.3.1 我的时钟有多准确？
 5.1.3.2 [How frequently will the System Clock be updated?](https://www.ntp.org/ntpfaq/ntp-s-algo/#5132-how-frequently-will-the-system-clock-be-updated)
5.1.3.2 系统时钟多久更新一次？
 5.1.3.3 [How frequently are Correction Values updated?](https://www.ntp.org/ntpfaq/ntp-s-algo/#5133-how-frequently-are-correction-values-updated)
5.1.3.3 校正值多久更新一次？
 5.1.3.4 [What is the Limit for the Number of Clients?](https://www.ntp.org/ntpfaq/ntp-s-algo/#5134-what-is-the-limit-for-the-number-of-clients)
5.1.3.4 客户端数量的限制是多少？
 5.1.4 [Robustness](https://www.ntp.org/ntpfaq/ntp-s-algo/#514-robustness) 5.1.4 鲁棒性
 5.1.4.1 [What is the stratum?](https://www.ntp.org/ntpfaq/ntp-s-algo/#5141-what-is-the-stratum)
5.1.4.1 什么是地层？
 5.1.4.2 [How are Synchronization Loops avoided?](https://www.ntp.org/ntpfaq/ntp-s-algo/#5142-how-are-synchronization-loops-avoided)
5.1.4.2 如何避免同步循环？
 5.1.5 [Tuning](https://www.ntp.org/ntpfaq/ntp-s-algo/#515-tuning) 5.1.5 调优
 5.1.5.1 [What is the allowed range for minpoll and maxpoll?](https://www.ntp.org/ntpfaq/ntp-s-algo/#5151-what-is-the-allowed-range-for-minpoll-and-maxpoll)
5.1.5.1 minpoll 和 maxpoll 的允许范围是多少？
 5.1.5.2 [What is the best polling Interval?](https://www.ntp.org/ntpfaq/ntp-s-algo/#5152-what-is-the-best-polling-interval)
5.1.5.2 最佳轮询间隔是多少？
 5.1.6 [Operating System Clock Interface](https://www.ntp.org/ntpfaq/ntp-s-algo/#516-operating-system-clock-interface)
5.1.6 操作系统时钟接口
 5.1.6.1 [How will NTP discipline my Clock?](https://www.ntp.org/ntpfaq/ntp-s-algo/#5161-how-will-ntp-discipline-my-clock)
5.1.6.1 NTP 将如何约束我的时钟？

------

#### 5.1.1 Time References 5.1.1 时间参考

#### 5.1.1.1 What is a reference clock? 5.1.1.1 什么是参考时钟？

A *reference clock* is some device or machinery that spits out the current time. The special thing about these things is *accuracy*: reference clocks must accurately follow some time standard.
参考时钟是吐出当前时间的某种设备或机械。这些东西的特别之处在于精度：参考时钟必须准确地遵循某种时间标准。

Typical candidates for reference clocks are very expensive cesium clocks.  Cheaper, and thus more popular, clocks are receivers for some time  signals broadcasted by national standard agencies. A typical example  would be a GPS (Global Positioning System) receiver that gets the time  from satellites. These satellites in turn have a cesium clock that is  periodically corrected to provide maximum accuracy.
参考钟的典型候选者是非常昂贵的铯钟。更便宜，因此更受欢迎的时钟是国家标准机构广播的某些时间信号的接收器。一个典型的例子是从卫星获取时间的 GPS（全球定位系统）接收器。这些卫星又有一个铯钟，该铯钟会定期校正以提供最大的精度。

Less expensive (and accurate) reference clocks use one of the terrestrial broadcasts known as DCF77, MSF, and WWV.
较便宜（且准确）的参考时钟使用称为 DCF77、MSF 和 WWV 的地面广播之一。

In NTP these time references are named *stratum 0*, the highest possible quality. Each system that has its time  synchronized to some reference clock can also be a time reference for  other systems, but the stratum will increase for each synchronization.
在 NTP 中，这些时间参考被命名为 stratum 0，即可能的最高质量。每个系统的时间与某个参考时钟同步，也可以是其他系统的时间参考，但每次同步时，层数都会增加。

------

#### 5.1.1.2 How will NTP use a reference clock? 5.1.1.2 NTP如何使用参考时钟？

A reference clock will provide the current time. NTP will compute some  additional statistical values that describe the quality of time it sees. [Among these values](https://www.ntp.org/ntpfaq/ntp-s-sw-clocks-quality/) are: *offset* (or *phase*), *jitter* (or *dispersion*), *frequency error*, and *stability*. Each NTP server maintains an estimate of the quality of its reference clocks and of itself.
参考时钟将提供当前时间。NTP 将计算一些额外的统计值，用于描述它所看到的时间质量。这些值包括：偏移（或相位）、抖动（或色散）、频率误差和稳定性。每个NTP服务器都维护其参考时钟和自身质量的估计。

------

#### 5.1.1.3 How will NTP know about Time Sources? 5.1.1.3 NTP如何知道时间源？

There are serveral ways an NTP client knows which NTP servers to use:
NTP 客户端可以通过多种方式知道要使用哪些 NTP 服务器：

- Servers to be polled can be configured manually.
  可以手动配置要轮询的服务器。
- Servers can send the time directly to a *peer*.
  服务器可以将时间直接发送给对等方。
- Servers may send out the time using multicast or broadcast addresses.
  服务器可以使用多播或广播地址发送时间。

------

#### 5.1.1.4 What happens if the Reference Time changes? 5.1.1.4 如果参考时间发生变化会怎样？

Ideally the reference time is the same everywhere in the world. Once  synchronized, there should not be any unexpected changes between the  clock of the operating system and the reference clock. Therefore, NTP  has no special methods to handle the situation.
理想情况下，参考时间在世界任何地方都是相同的。同步后，操作系统的时钟和参考时钟之间不应有任何意外变化。因此，NTP没有特殊的方法来处理这种情况。

Instead, `ntpd`’s reaction will depend on the offset between the local clock and the reference time. For a tiny offset `ntpd` will adjust the local clock as usual; for small and larger offsets, `ntpd` will reject the reference time for a while. In the latter case the  operation system’s clock will continue with the last corrections  effective while the new reference time is being rejected. After some  time, small offsets (significantly less than a second) will be *slewed* (adjusted slowly), while larger offsets will cause the clock to be *stepped* (set anew). Huge offsets are rejected, and `ntpd` will terminate itself, believing something very strange must have happened.
相反， `ntpd` 的反应将取决于本地时钟和参考时间之间的偏移。对于微小的偏移 `ntpd` 量，将像往常一样调整本地时钟;对于较小的偏移量和较大的偏移量， `ntpd` 将暂时拒绝参考时间。在后一种情况下，操作系统的时钟将继续进行最后的修正，同时新的参考时间被拒绝。一段时间后，小的偏移量（明显小于一秒）将被摆动（缓慢调整），而较大的偏移量将导致时钟步进（重新设置）。巨大的偏移被拒绝，并 `ntpd` 会自行终止，相信一定发生了一些非常奇怪的事情。

This algorithm is also applied when `ntpd` is started for the first time or after reboot.
首次启动或重新启动后 `ntpd` 也会应用此算法。

------

#### 5.1.1.5 What is a stratum 1 Server? 5.1.1.5 什么是第 1 层服务器？

A server operating at *stratum 1* belongs to the class of best NTP servers available, because it has a [reference clock](https://www.ntp.org/ntpfaq/ntp-s-algo/#5111-what-is-a-reference-clock) attached to it. As accurate reference clocks are expensive, only a few of these servers are publicly available.
在第 1 层运行的服务器属于可用的最佳 NTP 服务器类别，因为它附加了一个参考时钟。由于精确的参考时钟很昂贵，因此这些服务器中只有少数是公开的。

In addition to having a precise and well-maintained and calibrated  reference clock, a stratum 1 server should be highly available as other  systems may rely on its time service. Maybe that’s the reason why not  every NTP server with a reference clock is publicly available.
除了具有精确、维护良好和校准的参考时钟外，第 1 层服务器还应该具有高可用性，因为其他系统可能依赖于其时间服务。也许这就是为什么不是每个带有参考时钟的NTP服务器都是公开可用的。

------

#### 5.1.2 Time Exchange 5.1.2 时间交换

#### 5.1.2.1 How is Time synchronized? 5.1.2.1 时间是如何同步的？

Time can be passed from one time source to another, typically starting from a reference clock connected to a stratum 1 server. Servers synchronized  to a stratum 1 server will be *stratum 2*. Generally the stratum of a server will be one more than the [stratum of its reference](https://www.ntp.org/ntpfaq/ntp-s-algo/#5141-what-is-the-stratum).
时间可以从一个时间源传递到另一个时间源，通常从连接到第 1 层服务器的参考时钟开始。同步到第 1 层服务器的服务器将是第 2 层服务器。通常，服务器的层将比其引用的层多一个。

Synchronizing a client to a network server consists of several packet exchanges where each exchange is a request and reply pair. When sending out a request,  the client inserts its own time (*originate timestamp*) into the packet being sent. When a server receives the packet, it inserts its own time (*receive timestamp*) into the packet, and the packet is returned after putting a *transmit timestamp* into the packet. When receiving the reply, the receiver will once more  log its own receipt time to estimate the travelling time of the packet.  The travelling time (*delay*) is estimated to be half of “the total delay minus remote processing time”, assuming symmetrical delays.
将客户端同步到网络服务器由多个数据包交换组成，其中每个交换都是一个请求和应答对。发送请求时，客户端将自己的时间（原始时间戳）插入到正在发送的数据包中。当服务器收到数据包时，它会在数据包中插入自己的时间（接收时间戳），并在数据包中放入传输时间戳后返回数据包。当收到回复时，接收方将再次记录自己的接收时间，以估计数据包的传输时间。旅行时间（延迟）估计为“总延迟减去远程处理时间”的一半，假设对称延迟。

Those time differences can be used to estimate the time offset between both machines, as well as the *dispersion* (maximum offset error). The shorter and more symmetric the round-trip time, the more accurate the estimate of the current time.
这些时间差可用于估计两台机器之间的时间偏移以及色散（最大偏移误差）。往返时间越短、越对称，对当前时间的估计就越准确。

Time is not believed until several packet exchanges have taken place, each  passing a set of sanity checks. Only if the replies from a server  satisfy the conditions defined in the protocol specification, is the  server considered valid. Time cannot be synchronized from a server that  is considered invalid by the protocol. Some essential values are put  into multi-stage filters for statistical purposes to improve and  estimate the quality of the samples from each server. All used servers  are evaluated for a consistent time. In case of disagreements, the  largest set of agreeing servers (*truechimers*) is used to produce a combined reference time, thereby declaring other servers as invalid (*falsetickers*).
在发生几次数据包交换之前，时间是不确定的，每次都通过了一组健全性检查。只有当来自服务器的回复满足协议规范中定义的条件时，服务器才被视为有效。无法从协议认为无效的服务器同步时间。出于统计目的，将一些基本值放入多级过滤器中，以提高和估计每个服务器的样本质量。所有使用的服务器都会在一致的时间内进行评估。在出现分歧的情况下，使用最大的同意服务器集（truechimers）来生成组合参考时间，从而将其他服务器声明为无效（falsetickers）。

Usually it takes about five minutes (five good samples) until a NTP server is  accepted as a synchronization source. Interestingly, this is also true  for local reference clocks that have no delay at all by definition.
通常，NTP 服务器被接受为同步源大约需要五分钟（五个好的样本）。有趣的是，根据定义，完全没有延迟的本地参考时钟也是如此。

After initial synchronization, the quality estimate of the client usually  improves over time. As a client becomes more accurate, one or more  potential servers may be considered invalid after some time.
初始同步后，客户端的质量估计通常会随着时间的推移而提高。随着客户端变得更加准确，一个或多个潜在的服务器可能会在一段时间后被视为无效。

------

#### 5.1.2.2 Which Network Protocols are used by NTP? 5.1.2.2 NTP使用哪些网络协议？

NTP uses UDP packets for data transfer because of the fast connection setup and response times. The official port number for NTP (that `ntpd` and `ntpdate` listen and talk to) is `123`.
NTP 使用 UDP 数据包进行数据传输，因为连接设置和响应时间快。NTP 的官方端口号（即 `ntpd` 和 `ntpdate` listen and talk to）是 `123` 。

The reference implementation supports the NTP protocol on port 123. It does not support the Time Protocol ([RFC 868](https://www.rfc-editor.org/rfc/rfc868)) on port 37. NTP is newer and more precise than the older Time protocol.
参考实现支持端口 123 上的 NTP 协议。它不支持端口 37 上的时间协议 （RFC 868）。NTP 比旧的 Time 协议更新、更精确。

------

#### 5.1.2.3 How is Time encoded in NTP? 5.1.2.3 NTP中的时间是如何编码的？

There was a nice answer from Don Payette in news://comp.protocols.time.ntp, slightly adapted:
唐·帕耶特（Don Payette）在 news://comp.protocols.time.ntp 中有一个很好的答案，略有改编：

The NTP timestamp is a 64 bit binary value with an implied fraction point  between the two 32 bit halves. If you take all the bits as a 64 bit  unsigned integer, stick it in a floating point variable with at least 64 bits of mantissa (usually double) and do a floating point divide by 2^32, you’ll get the right answer.
NTP 时间戳是一个 64 位二进制值，在两个 32 位半部分之间有一个隐含的小数点。如果你把所有的位都当作一个 64 位无符号整数，把它放在一个至少有 64 位尾数（通常是双精度）的浮点变量中，然后做一个浮点除以 2 ^ 32，你会得到正确的答案。

As an example the 64 bit binary value:
例如，64 位二进制值：

```
00000000000000000000000000000001 10000000000000000000000000000000
```

equals a decimal 1.5. The multipliers to the right of the point are 1/2, 1/4, 1/8, 1/16, etc.
等于小数点 1.5。点右边的乘数是 1/2、1/4、1/8、1/16 等。

To get the 200 picoseconds, take a one and divide it by 2^32 (`4294967296`), you get `0.00000000023283064365386962890625` or about `233E-12` seconds. A picosecond is `1E-12` seconds.
要获得 200 皮秒，取一个 1 并将其除以 2 ^ 32 （ `4294967296` ），得到 `0.00000000023283064365386962890625` 或大约 `233E-12` 秒。皮秒是 `1E-12` 秒。

In addition one should know that the epoch for NTP starts in year `1900` while the epoch in UNIX starts in `1970`. Therefore the following values both correspond to `2000-08-31_18:52:30.735861`
此外，应该知道 NTP 的纪元从年 `1900` 开始，而 UNIX 的纪元从 `1970` .因此，以下值都对应于 `2000-08-31_18:52:30.735861` 

```
UNIX: 39aea96e.000b3a75
        00111001 10101110 10101001 01101110.
        00000000 00001011 00111010 01110101
NTP:  bd5927ee.bc616000
        10111101 01011001 00100111 11101110.
        10111100 01100001 01100000 00000000
```

------

#### 5.1.2.4 When are the Servers polled? 5.1.2.4 何时轮询服务器？

When polling servers, a similar algorithm as described in [Q: 5.1.3.3.](https://www.ntp.org/ntpfaq/ntp-s-algo/#5133-how-frequently-are-correction-values-updated) is used. Basically the *jitter* (white phase noise) should not exceed the *wander* (random walk frequency noise). The polling interval tries to be close to the point where the total noise is minimal, known as *Allan intercept*, and the interval is always a power of two. The minimum and maximum allowable exponents can be specified using [`minpoll` and `maxpoll`](https://www.ntp.org/ntpfaq/ntp-s-algo/#5151-what-is-the-allowed-range-for-minpoll-and-maxpoll) respectively. If a local reference clock with low jitter is selected to synchronize the system clock, remote servers may be polled more  frequently than without a local reference clock (after version 4.1.0) of `ntpd`. The intended purpose is to detect a faulty reference clock in time.
轮询服务器时，采用与Q：5.1.3.3中描述的类似算法。被使用。基本上，抖动（白相噪声）不应超过漂移（随机游走频率噪声）。轮询间隔试图接近总噪声最小的点，称为艾伦截距，并且间隔始终是 2 的幂。最小和最大允许指数可以分别使用 `minpoll` 和 `maxpoll` 指定。如果选择具有低抖动的本地参考时钟来同步系统时钟，则远程服务器的轮询频率可能比没有本地参考时钟（版本 4.1.0 之后）的 `ntpd` 频率更高。其目的是及时检测有故障的参考时钟。

------

#### 5.1.3 Performance 5.1.3 性能

#### 5.1.3.1 How accurate will my Clock be? 5.1.3.1 我的时钟有多准确？

For a general discussion see [Section 3](https://www.ntp.org/ntpfaq/ntp-s-sw-clocks/). Also keep in mind that corrections are applied gradually, so it may  take up to three hours until the frequency error is compensated (see  Figure 5.1a).
有关一般性讨论，请参见第 3 节。还要记住，校正是逐步应用的，因此可能需要长达三个小时才能补偿频率误差（参见图 5.1a）。

**Figure 5.1a: Initial Run of NTP
图 5.1a.. NTP 的初始运行**



  ![img](https://www.ntp.org/ntpfaq/ntp35f-init.png)



The final achievable accuracy depends on the time source being used.  Basically, no client can be more accurate than its server. In addition,  the quality of the network connection also influences the final  accuracy. Slow and non-predictable networks with varying delays are bad  for good time synchronization.
最终可达到的精度取决于所使用的时间源。基本上，没有客户端比其服务器更准确。此外，网络连接的质量也会影响最终的精度。具有不同延迟的缓慢且不可预测的网络不利于良好的时间同步。

A time difference of less than 128ms between server and client is  required to maintain NTP synchronization. The typical accuracy on the  Internet ranges from about 5ms to 100ms, possibly varying with network  delays. A survey by Professor David L. Mills suggests that 90% of the  NTP servers have network delays below 100ms, and about 99% are  synchronized within one second to the *synchronization peer*.
服务器和客户端之间的时间差小于 128 毫秒才能保持 NTP 同步。互联网上的典型精度范围约为 5 毫秒到 100 毫秒，可能随网络延迟而变化。David L. Mills  教授的一项调查表明，90% 的 NTP 服务器的网络延迟低于 100 毫秒，大约 99% 的服务器在一秒内与同步对等体同步。

With PPS synchronization an accuracy of 50μs and a stability below 0.1 PPM  is achievable on a Pentium PC running Linux. However, there are some  hardware facts to consider. Judah Levine wrote:
通过PPS同步，在运行Linux的奔腾PC上可以实现50μs的精度和低于0.1 PPM的稳定性。但是，需要考虑一些硬件事实。犹大·莱文（Judah Levine）写道：

In addition, the FreeBSD system I have been playing with has a clock  oscillator with a temperature coefficient of about 2 PPM per degree C.  This results in time dispersions on the order of lots of microseconds  per hour (or lots of nanoseconds per second) due solely to the cycling  of the room heating/cooling system. This is pretty good by PC standards. I have seen a lot worse.
此外，我一直在玩的 FreeBSD 系统有一个时钟振荡器，其温度系数约为每摄氏度 2 PPM。这仅由于房间供暖/制冷系统的循环导致每小时（或每秒数纳秒）的时间色散。按照 PC 标准，这是相当不错的。我见过更糟糕的情况。

[Terje Mathisen](mailto:Terje.Mathisen@hda.hydro.com) wrote in reply to a question about the actual offsets achievable: “I found that 400 of the servers had offsets below 2ms, (…)”
Terje Mathisen在回答有关实际可实现的偏移量的问题时写道：“我发现400台服务器的偏移量低于2ms，（...）”

David Dalton wrote about the same subject:
大卫·道尔顿（David Dalton）写了关于同一主题的文章：

The true answer is: It All Depends…..
真正的答案是：这完全取决于.....

Mostly, it depends on your networking. Sure, you can get your machines within a few milliseconds of each other if they are connected to each other with Ethernet connections and not too many routers hops in between. If all  the machines are on the same quiet subnet, NTP can easily keep them  within one millisecond all the time. But what happens if your network  get congested? What happens if you have a broadcast storm (say 1,000  broadcast packets per second) that causes your CPU to go over 100% load  average just examining and discarding the broadcast packets? What  happens if one of your routers loses its mind? Your local system time  could drift well outside the “few milliseconds” window in situations  like these.
大多数情况下，这取决于您的网络。当然，如果机器通过以太网连接相互连接，并且中间没有太多的路由器跳跃，则可以在几毫秒内获得机器。如果所有计算机都位于同一个安静子网上，则 NTP 可以轻松地将它们始终保持在一毫秒以内。但是，如果您的网络拥塞怎么办？如果遇到广播风暴（例如每秒 1,000 个广播数据包），导致  CPU 在检查和丢弃广播数据包时超过 100%  的平均负载，会发生什么情况？如果您的一台路由器失去理智会怎样？在这种情况下，您的本地系统时间可能会偏离“几毫秒”窗口。

------

#### 5.1.3.2 How frequently will the System Clock be updated? 5.1.3.2 系统时钟多久更新一次？

As time should be a continuous and steady stream, `ntpd` updates the clock in small quantities. However, to keep up with clock  errors, such corrections have to be applied frequently. If `adjtime()` is used, `ntpd` will update the system clock every second. If `ntp_adjtime()` is available, the operating system can compensate clock errors automatically, requiring only infrequent updates. See also [Section 5.2](https://www.ntp.org/ntpfaq/ntp-s-algo-kernel/) and [Q: 5.1.6.1.](https://www.ntp.org/ntpfaq/ntp-s-algo/#5161-how-will-ntp-discipline-my-clock).
由于时间应该是连续和稳定的流， `ntpd` 因此少量更新时钟。但是，为了跟上时钟误差，必须经常应用此类校正。如果 `adjtime()` 使用， `ntpd` 将每秒更新一次系统时钟。如果 `ntp_adjtime()` 可用，操作系统可以自动补偿时钟错误，只需要不频繁的更新。另请参见第 5.2 节和问：5.1.6.1.。

------

#### 5.1.3.3 How frequently are Correction Values updated? 5.1.3.3 校正值多久更新一次？

NTP maintains an internal clock quality indicator. If the clock seems  stable, updates to the correction parameters happen less frequently. If  the clock seems instable, more frequent updates are scheduled. Sometimes the update interval is also termed *stiffness* of the PLL, because only small changes are possible for long update intervals.
NTP 维护内部时钟质量指示器。如果时钟看起来稳定，则校正参数的更新频率较低。如果时钟看起来不稳定，则会安排更频繁的更新。有时，更新间隔也称为PLL的刚度，因为对于较长的更新间隔，只能进行微小的变化。

There’s a decision value named *poll adjust* that can be queried with `ntpdc`’s `loopinfo` command. A value of `-30` means to decrease the polling interval, while a value of `30` means to increase it within the bounds of `minpoll` and `maxpoll`. The value of `watchdog timer` is the time since the last update.
有一个名为 poll adjust 的决策值，可以使用 `ntpdc` 的命令 `loopinfo` 进行查询。值 的 `-30` 均值用于减小轮询间隔，而值 的 `30` 值表示在 `minpoll` 和 `maxpoll` 的范围内增加轮询间隔。的 `watchdog timer` 值是自上次更新以来的时间。

```
ntpdc> loopinfo
offset:               -0.000102 s
frequency:            16.795 ppm
poll adjust:          6
watchdog timer:       63 s
```

------

#### 5.1.3.4 What is the Limit for the Number of Clients? 5.1.3.4 客户端数量的限制是多少？

The limit depends on several factors, like speed of the main processor and network bandwidth, but the limit is quite high. [Terje Mathisen](mailto:Terje.Mathisen@hda.hydro.com) once presented a calculation:
限制取决于几个因素，例如主处理器的速度和网络带宽，但限制非常高。泰耶·马蒂森（Terje Mathisen）曾经提出过一个计算：

2 packets/256 seconds * 500 K machines -> 4 K packets/second (half in each direction).
2 个数据包/256 秒 * 500 K 台机器 -> 4 K 个数据包/秒（每个方向一半）。

Packet size is close to minimum, definitely less than 128 bytes even with cryptographic authentication:
数据包大小接近最小值，即使使用加密身份验证也绝对小于 128 字节：

4 K * 128 -> 512 KB/s.
4 K * 128 -> 512 KB/秒。

So, as long as you had a dedicated 100 Mbit/s full duplex leg from the  central switch for each server, it should see average networks load of  maximim 2-3%.
因此，只要每台服务器的中央交换机都有一个专用的 100 Mbit/s 全双工支路，平均网络负载就应该达到最大 2-3%。

------

#### 5.1.4 Robustness 5.1.4 鲁棒性

#### 5.1.4.1 What is the stratum? 5.1.4.1 什么是地层？

The *stratum* is a measure for synchronization distance. Opposed to *jitter* or *delay* the stratum is a more static measure. Basically from the perspective of a client, it is the number of servers to a reference clock. So a  reference clock itself appears at stratum 0, while the closest servers  are at stratum 1. On the network there is no valid NTP message with  stratum 0.
地层是同步距离的量度。与抖动或延迟相反，分层是一种更静态的措施。基本上从客户端的角度来看，它是参考时钟的服务器数量。因此，参考时钟本身出现在第 0 层，而最近的服务器位于第 1 层。在网络上，没有层为 0 的有效 NTP 消息。

A server synchronized to a stratum `n` server will be running at stratum `n` + 1. The upper limit for stratum is `15`. The purpose of stratum is to avoid synchronization loops by preferring servers with a lower stratum.
与 stratum 服务器同步的服务器将在 stratum `n` `n` + 1 运行。地层的上限是 `15` 。stratum 的目的是通过优先选择具有较低层的服务器来避免同步循环。

------

#### 5.1.4.2 How are Synchronization Loops avoided? 5.1.4.2 如何避免同步循环？

In a synchonization loop, the time derived from one source along a  specific path of servers is used as reference time again within such a  path. This may cause an excessive accumulation of errors that is to be  avoided. Therefore NTP uses different means to accomplish that:
在同步循环中，从服务器特定路径上的一个源派生的时间再次用作该路径中的参考时间。这可能会导致要避免的错误过度积累。因此，NTP 使用不同的方法来实现此目的：

- The Internet address of a time source is used as *reference identifier* to avoid duplicates. The reference identifier is limited to 32 bits.
  时间源的 Internet 地址用作引用标识符，以避免重复。引用标识符限制为 32 位。
- The [stratum](https://www.ntp.org/ntpfaq/ntp-s-algo/#5141-what-is-the-stratum) is used to form an acyclic synchronization network.
  该地层用于形成非循环同步网络。

More precisely, according to Professor David L. Mills, the algorithm finds a shortest path spanning tree with metric based on synchronization  distance dominated by hop count. The reference identifier provides  additional information to avoid neighbor loops under conditions where  the topology is changing rapidly. Looping is a well known problem for  routing algorithms. See any textbook on computer network routing  algorithms, such as [Data Networks by Bertsekas and Gallagher](https://web.mit.edu/dimitrib/www/datanets.html).
更准确地说，根据 David L. Mills  教授的说法，该算法找到了一个最短路径生成树，其度量基于由跳数主导的同步距离。引用标识符提供附加信息，以避免在拓扑快速变化的条件下出现邻居环路。循环是路由算法的一个众所周知的问题。请参阅任何有关计算机网络路由算法的教科书，例如 Bertsekas 和 Gallagher 的 Data Networks。

In IPv6 the reference ID field is a timestamp that can be used for the same purpose.
在 IPv6 中，引用 ID 字段是可用于相同目的的时间戳。

------

#### 5.1.5 Tuning 5.1.5 调优

#### 5.1.5.1. What is the allowed range for minpoll and maxpoll? 5.1.5.1. minpoll 和 maxpoll 的允许范围是多少？

The default polling value after restart of NTP is the value specified by `minpoll`. The default values for `minpoll` and `maxpoll` are `6` (64 seconds) and `10` (1024 seconds) respectively.
重新启动 NTP 后的默认轮询值是 指定的 `minpoll` 值。 `minpoll` 和 `maxpoll` 的默认值分别为 `6` （64 秒）和 `10` （1024 秒）。

For NTPv4 the smallest and largest allowable polling values are `4` (16 seconds) and `17` (1.5 days) respectively. These values come from the include file `ntp.h`. The revised kernel discipline automatically switches to FLL mode if the update interval is longer than 2048 seconds. Below 256 seconds PLL mode is used, and in between these limits the mode can be selected using the `STA_FLL` bit.
对于 NTPv4，允许的最小和最大轮询值分别为 `4` （16 秒） 和 `17` （1.5 天）。这些值来自 include 文件 `ntp.h` 。如果更新间隔超过 2048 秒，则修改后的内核规则会自动切换到 FLL 模式。低于 256 秒使用 PLL 模式，在这些限制之间可以使用 `STA_FLL` 位选择模式。

------

#### 5.1.5.2 What is the best polling Interval? 5.1.5.2 最佳轮询间隔是多少？

There is none. Short polling intervals update the parameters frequently and  are sensitive to jitter and random errors. Long intervals may require  larger corrections with significant errors between the updates. However, there seems to be an optimum between those two. For common operating  system clocks this value happens to be close to the default maximum  polling time, 1024s. See also [Q: 5.1.3.1](https://www.ntp.org/ntpfaq/ntp-s-algo/#5131-how-accurate-will-my-clock-be).
没有。较短的轮询间隔会频繁更新参数，并且对抖动和随机误差很敏感。较长的间隔可能需要更大的更正，并且更新之间存在重大误差。然而，这两者之间似乎有一个最佳状态。对于常见的操作系统时钟，此值恰好接近默认的最大轮询时间 1024 秒。另见问：5.1.3.1。

------

#### 5.1.6 Operating System Clock Interface 5.1.6 操作系统时钟接口

#### 5.1.6.1 How will NTP discipline my Clock? 5.1.6.1 NTP 将如何约束我的时钟？

In order to keep the right time, `ntpd` must make adjustments to the system clock. Different operating systems  provide different means, but the most popular ones are listed below.
为了保持正确的时间， `ntpd` 必须对系统时钟进行调整。不同的操作系统提供不同的方法，但下面列出了最流行的方法。

Basically there are four mechanisms (system calls) an NTP implementation can use to discipline the system clock:
基本上，NTP 实现可以使用四种机制（系统调用）来规范系统时钟：

- `settimeofday(2)` to step (set) the time. This method is used if the time if off by more than 128ms.
   `settimeofday(2)` 步进（设置）时间。如果关闭时间超过 128 毫秒，则使用此方法。
- `adjtime(2)` to slew (gradually change) the time. Slewing the time means to change  the virtual frequency of the software clock to make the clock go faster  or slower until the requested correction is achieved. Slewing the clock  for a larger amount of time may require some time. For example standard  Linux adjusts the time with a rate of 0.5ms per second.
   `adjtime(2)` 回转（逐渐改变）时间。回摆时间意味着改变软件时钟的虚拟频率，使时钟走得更快或更慢，直到达到请求的校正。将时钟回转较长时间可能需要一些时间。例如，标准 Linux 以每秒 0.5 毫秒的速率调整时间。
- `ntp_adjtime(2)` to control several parameters of the software clock, also known as [kernel discipline](https://www.ntp.org/ntpfaq/ntp-s-algo-kernel/). These parameters can:
   `ntp_adjtime(2)` 控制软件时钟的多个参数，也称为内核规则。这些参数可以：
  - Adjust the offset of the software clock, possibly correcting the virtual frequency as well.
    调整软件时钟的偏移量，可能还会校正虚拟频率。
  - Adjust the virtual frequency of the software clock directly.
    直接调整软件时钟的虚拟频率。
  - Enable or disable [PPS event processing](https://www.ntp.org/ntpfaq/ntp-s-algo-kernel/#524-pps-processing).
    启用或禁用 PPS 事件处理。
  - Control processing of leap seconds.
    控制闰秒的处理。
  - Read and set some related characteristic values of the clock.
    读取并设置时钟的一些相关特征值。
- `hardpps()` is a function that is only called from an interrupt service routine inside the operating system. If enabled, `hardpps()` will update the frequency and offset correction of the kernel clock in response to an external signal (see also [Section 6.2.4](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#624-pps-synchronization)).
   `hardpps()` 是仅从操作系统内部的中断服务例程调用的函数。如果启用， `hardpps()` 将更新内核时钟的频率和偏移校正以响应外部信号（另请参阅第 6.2.4 节）。



# 5.2. The Kernel Discipline 5.2. 内核规则

Last update: April 3, 2024 16:42 UTC ([f170361b7](https://git.nwtime.org/websites/ntpwww/commit/f170361b72193f7af81935c6c0a4afda96793f0d))
最后更新： 2024年4月3日 16：42 UTC （ f170361b7）

In addition to the NTP protocol specification, there exists a description for a kernel clock model ([RFC 1589](https://www.ntp.org/reflib/rfc/rfc1589.txt)) that is discussed here.
除了 NTP 协议规范之外，还存在此处讨论的内核时钟模型 （RFC 1589） 的描述。

5.2.1 [Basic Functionality](https://www.ntp.org/ntpfaq/ntp-s-algo-kernel/#521-basic-functionality)
5.2.1 基本功能
 5.2.1.1 [What is special about the Kernel Clock?](https://www.ntp.org/ntpfaq/ntp-s-algo-kernel/#5211-what-is-special-about-the-kernel-clock)
5.2.1.1 内核时钟有什么特别之处？
 5.2.1.2 [Does my Operating System have the Kernel Discipline?](https://www.ntp.org/ntpfaq/ntp-s-algo-kernel/#5212-does-my-operating-system-have-the-kernel-discipline)
5.2.1.2 我的操作系统有内核规则吗？
 5.2.1.3 [How can I verify the Kernel Discipline?](https://www.ntp.org/ntpfaq/ntp-s-algo-kernel/#5213-how-can-i-verify-the-kernel-discipline)
5.2.1.3 如何验证内核规则？  
 5.2.2 [Monitoring](https://www.ntp.org/ntpfaq/ntp-s-algo-kernel/#522-monitoring) 5.2.2 监控
 5.2.3 [PPS Processing](https://www.ntp.org/ntpfaq/ntp-s-algo-kernel/#523-pps-processing) 5.2.3 PPS处理
 5.2.3.1 [What is PPS Processing?](https://www.ntp.org/ntpfaq/ntp-s-algo-kernel/#5231-what-is-pps-processing)
5.2.3.1 什么是PPS处理？
 5.2.3.2 [How is PPS Processing related to the Kernel Discipline?](https://www.ntp.org/ntpfaq/ntp-s-algo-kernel/#5232-how-is-pps-processing-related-to-the-kernel-discipline)
5.2.3.2 PPS处理与内核规则有什么关系？
 5.2.3.3 [What does hardpps() do?](https://www.ntp.org/ntpfaq/ntp-s-algo-kernel/#5233-what-does-hardpps-do)
5.2.3.3 hardpps（） 有什么作用？

------

#### 5.2.1 Basic Functionality 5.2.1 基本功能

#### 5.2.1.1 What is special about the Kernel Clock? 5.2.1.1 内核时钟有什么特别之处？

NTP keeps precision time by [applying small adjustments to system clock periodically](https://www.ntp.org/ntpfaq/ntp-s-algo/#5161-how-will-ntp-discipline-my-clock). However, some clock implementations do not allow small corrections to  be applied to the system clock, and there is no standard interface to  monitor the system clock’s quality.
NTP 通过定期对系统时钟进行小幅调整来保持精确的时间。但是，某些时钟实现不允许对系统时钟进行小的校正，并且没有标准接口来监控系统时钟的质量。

[RFC 1589](https://www.ntp.org/reflib/rfc/rfc1589.txt) defines a clock model with the following features :
RFC 1589 定义了一个具有以下功能的时钟模型：

- Two new system calls to query and control the clock: `ntp_gettime()` and `ntp_adjtime()`.
  两个用于查询和控制时钟的新系统调用： `ntp_gettime()` 和 `ntp_adjtime()` 。

- The clock keeps time with a precision of one microsecond. The nanokernel  keeps time using even fractional nanoseconds. In real life operating  systems there are clocks that are much worse.
  时钟以 1 微秒的精度保持时间。纳米内核甚至使用小数纳秒来保持时间。在现实生活中的操作系统中，有些时钟要糟糕得多。

- Time can be corrected in quantities of one microsecond, or even fractional  microseconds using the nanokernel, and repetitive corrections  accumulate. The UNIX system call `adjtime()` does not accumulate successive corrections.
  使用纳米核可以以一微秒甚至小数微秒的数量校正时间，并累积重复校正。UNIX 系统调用 `adjtime()` 不会累积连续的更正。

- The clock model maintains additional parameters that can be queried or controlled. Among these are:

  
  时钟模型维护可查询或控制的其他参数。其中包括：

  - A *clock synchronization status* that shows the state of the clock machinery (`TIME_OK`).
    显示时钟机器状态的时钟同步状态 （ `TIME_OK` ）。
  - Several *clock control and status bits* that control and show the state of the machinery (`STA_PLL`). This includes automatic handling of announced leap seconds.
    几个时钟控制和状态位，用于控制和显示机器的状态 （ `STA_PLL` ）。这包括自动处理宣布的闰秒。
  - Correction values for *clock offset* and *frequency* that are automatically applied.
    自动应用的时钟偏移和频率校正值。
  - Other control and monitoring values like *precision*, *estimated error*, and *frequency tolerance*.
    其他控制和监控值，如精度、估计误差和频率容差。

- Corrections to the clock can be automatically maintained and applied.
  可以自动维护和应用时钟校正。

Applying corrections automatically within the operating system kernel no longer  requires periodic corrections through an application program.
在操作系统内核中自动应用更正不再需要通过应用程序进行定期更正。

------

#### 5.2.1.2 Does my Operating System have the Kernel Discipline? 5.2.1.2 我的操作系统有内核规则吗？

If you can find an include file named `timex.h` that contains a structure named `timex` and constants like `STA_PLL` and `STA_UNSYNC`, you probably have the kernel discipline implemented. To make sure, try using the `ntp_gettime()` system call.
如果能找到一个名为 `timex.h` include 的文件，该文件包含一个名为 `timex` `STA_PLL` 和 `STA_UNSYNC` 的常量的结构，则可能已实现内核规则。为确保这一点，请尝试使用 `ntp_gettime()` 系统调用。

------

#### 5.2.1.3 How can I verify the Kernel Discipline? 5.2.1.3 如何验证内核规则？

The following guidelines were presented by [Professor David L. Mills](https://www.nwtime.org/tribute-to-david-l-mills/):
David L. Mills教授提出了以下指南：

Feedback loops and in particular phase-lock loops and I go way, way back since  the first time I built one as part of a frequency synthesizer project as a grad student in 1959. All the theory I could dredge up then convinced me they were evil, non-linear things and tamed only by experiment,  breadboard and cut-and-try. Not so now, of course, but the cut-and-try  still lives on. The essential lessons I learned back then and have  forgotten and relearned every ten years or so are:
反馈环路，特别是锁相环路，早在1959年我作为研究生第一次作为频率合成器项目的一部分构建一个反馈环路以来，我就可以追溯到很久以前。当时我能挖掘出的所有理论都让我相信它们是邪恶的、非线性的东西，只能通过实验、面包板和切割和尝试来驯服。当然，现在不是这样，但剪裁和尝试仍然存在。我当时学到的重要教训是：

1. Carefully calibrate the frequency to the control voltage and never forget it.
   仔细将频率校准到控制电压tage 永远不要忘记它。
2. Don’t try to improve performance by cranking up the gain beyond the phase crossover.
   不要试图通过提高超过相位分频的增益来提高性能。
3. Keep the loop delay much smaller than the time constant.
   保持循环延迟远小于时间常数。
4. For the first couple of decade re-learns, the critters were analog and with short time constants so I could watch it with a scope. The last couple  of re-learns were digital with time constants of days. So, another  lesson:
   在重新学习的头十年里，这些小动物是模拟的，时间常数很短，所以我可以用瞄准镜观察它。最后几次重新学习是数字化的，时间常数为天。所以，另一个教训：

There is nothing in an analog loop that can’t be done in a digital loop  except debug it with a pair of headphones and a good test oscillator.  Yes, I did say headphones.
在模拟环路中，没有什么是数字环路中不能完成的，除了用一副耳机和一个好的测试振荡器进行调试。是的，我确实说过耳机。

So, this nonsense leads me to a couple of simple experiments:
所以，这个废话让我想到了几个简单的实验：

1. First, open the loop (`kill ntpd`). Using `ntptime`, zero the frequency and offset. Measure the frequency offset, which could take a day.
   首先，打开循环 （ `kill ntpd` ）。使用 `ntptime` ，将频率和偏移量归零。测量频率偏移，这可能需要一天时间。
2. Then, do the same thing with a known offset via `ntptime` of say 50 PPM. You now have really and truly calibrated the VFO gain.
   然后，用已知的偏 `ntptime` 移量（例如 50 PPM）执行相同的操作。您现在已经真正校准了 VFO 增益。
3. Next, close the loop after forcing the local clock maybe 100 ms offset. Watch the offset-time characteristic. Make sure it crosses zero in about 3000 s and overshoots about 5 percent. That with a time constant of 6 in the current nanokernel.
   接下来，在强制本地时钟偏移 100 毫秒后关闭环路。观察偏移时间特征。确保它在大约 3000 秒内越过零并超过大约 5%。在当前的纳米内核中，时间常数为 6。

In very simple words, step 1 means that you measure the error of your  clock without any correction. You should see a linear increase for the  offset. Step 2 says you should then try a correction with a fixed  offset. Finally, step 3 applies corrections using varying frequency  corrections.
简单来说，步骤 1 意味着您在不进行任何校正的情况下测量时钟的误差。您应该会看到偏移量呈线性增加。第 2 步说您应该尝试使用固定偏移量进行校正。最后，步骤 3 使用不同频率的校正应用校正。

------

#### 5.2.2 Monitoring 5.2.2 监控

Most of the values are described in [Q: 6.2.4.2.1](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#62421-so-i-think-i-have-all-required-components-ready-how-will-i-see-that-everything-is-working). The remaining values of interest are:
大多数值在Q：6.2.4.2.1中描述。感兴趣的其余值为：

- time 时间

  The current time. 当前时间。

- maxerror 最大错误

  The maximum error (set by an application program, increases automatically). 最大误差（由应用程序设置，自动增加）。

- esterror

  The estimated error (set by an application program like `ntpd`). 估计误差（由应用程序设置，如 `ntpd` ）。

- offset 抵消

  The additional remaining correction to the system clock. 对系统时钟的额外剩余校正。

- freq 频率

  The automatic periodic correction to the system clock. Positive values make the clock go faster while negative values slow it down. 对系统时钟的自动定期校正。正值使时钟走得更快，而负值会减慢时钟的速度。

- constant 不断

  Stiffness of the control loop. This value controls how a correction to the system clock is weighted. Large values cause only small corrections to be  made. 控制回路的刚度。此值控制如何对系统时钟的校正进行加权。较大的值只会导致进行小的更正。

- status 地位

  The set of control bits in effect. Some bits can only be read, while others can be also set by a privileged application. The most important bits  are: 生效的控制位集。有些位只能读取，而其他位也可以由特权应用程序设置。最重要的部分是：

| Bit            | Description 描述                                             |
| -------------- | ------------------------------------------------------------ |
| `STA_PLL`      | The PLL (Phase Locked Loop) is enabled. Automatic corrections are applied only if this flag is set. PLL （锁相环）已启用。仅当设置了此标志时，才会应用自动更正。 |
| `STA_FLL`      | The FLL (Frequency Locked Loop) is enabled. This flag is set when the time  offset is not believed to be good. Usually this is the case for long  sampling intervals or after a bad sample has been detected by `xntpd`. FLL（频率锁定环路）已启用。当时间偏移量被认为不好时，将设置此标志。通常，对于较长的采样间隔或检测到 `xntpd` 不良样品后，会出现这种情况。 |
| `STA_UNSYNC`   | The system time is not synchronized. This flag is usually controlled by an  application program, but the operating system may also set it. 系统时间不同步。此标志通常由应用程序控制，但操作系统也可以设置它。 |
| `STA_FREQHOLD` | This flag disables updates to the `freq` component. The flag is usually set during initial synchronization. 此标志禁用对组件的 `freq` 更新。该标志通常在初始同步期间设置。 |

------

#### 5.2.3 PPS Processing 5.2.3 PPS处理

#### 5.2.3.1 What is PPS Processing? 5.2.3.1 什么是PPS处理？

During normal time synchronization, the server time stamps are compared about  every 20 minutes to compute the required corrections for frequency and  offset. With PPS processing, a similar thing is done every second.  Therefore it’s just time synchronization on a smaller scale. The idea is to keep the system clock tightly coupled with the external reference  clock providing the PPS signal.
在正常时间同步期间，大约每 20 分钟比较一次服务器时间戳，以计算所需的频率和偏移校正。使用 PPS 处理，每秒都会发生类似的事情。因此，它只是较小规模的时间同步。其思路是使系统时钟与提供PPS信号的外部参考时钟紧密耦合。

------

#### 5.2.3.2 How is PPS Processing related to the Kernel Discipline? 5.2.3.2 PPS处理与内核规则有什么关系？

PPS processing can be done in application programs, but it makes much more  sense when done in the operating system kernel. When polling a time  source every 20 minutes, an offset of 5ms is rather small, but when  polling a signal every second, an offset of 5ms is very high. Therefore a high accuracy is required for PPS processing. Application programs  usually can’t fulfil these demands.
PPS 处理可以在应用程序中完成，但在操作系统内核中完成时更有意义。当每 20 分钟轮询一次时间源时，5 毫秒的偏移量相当小，但当每秒轮询一次信号时，5 毫秒的偏移量非常高。因此，PPS加工需要高精度。应用程序通常无法满足这些要求。

The kernel clock model includes algorithms to discipline the clock through  an external pulse, the PPS. The additional requirements consist of two  mechanisms: capturing an external event with high accuracy, and applying that event to the clock model. The first is solved using the [PPS API](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#62451-what-is-that-pps-api), while the second is implemented mostly in a routine named `hardpps()` which is called every time when an external PPS event has been detected.
内核时钟模型包括通过外部脉冲 PPS 对时钟进行约束的算法。附加要求包括两种机制：高精度捕获外部事件，并将该事件应用于时钟模型。第一个是使用 PPS API 解决的，而第二个主要在名为 `hardpps()` THE TIME 的例程中实现，每次检测到外部 PPS 事件时都会调用该例程。

------

#### 5.2.3.3 What does hardpps() do? 5.2.3.3 hardpps（） 有什么作用？

`hardpps()` is called with two parameters, the absolute time of the event, and the  time relative to the last pulse. Both times are measured by the system  clock.
 `hardpps()` 使用两个参数调用，即事件的绝对时间和相对于最后一个脉冲的时间。这两个时间都是由系统时钟测量的。

The first value is used to minimize the difference between the system  clock’s start of a second and the external event, while the second value is used to minimize the difference in clock frequency. Normally `hardpps()` just monitors (`STA_PPSSIGNAL`, PPS frequency, stability and jitter) the external events, but does not apply corrections to the system clock.
第一个值用于最小化系统时钟开始秒与外部事件之间的差异，而第二个值用于最小化时钟频率的差异。通常 `hardpps()` 只监控（ `STA_PPSSIGNAL` PPS频率、稳定性和抖动）外部事件，但不对系统时钟进行校正。

**Figure 5.2a: PPS Synchronization
图 5.2a.. PPS 同步**



  ![img](https://www.ntp.org/ntpfaq/hardpps.png)



`hardpps()` can minimize the differences of both frequency and offset between the system clock and an external reference.
 `hardpps()` 可以较大限度地减小系统时钟和外部基准之间的频率和失调差异。

Flag `STA_PPSFREQ` enables periodic updates to the clock’s frequency correction. Stable  clocks require only small and infrequent updates while bad clocks  require frequent and large updates. The value passed as parameter is  reduced to be a small value around zero, and then it is added to an  accumulated value. After a specific amount of values has been added (at  the end of a calibration interval), the total amount is divided by the  length of the calibration interval, giving a new frequency correction.
Flag `STA_PPSFREQ` 允许定期更新时钟的频率校正。稳定的时钟只需要小的和不频繁的更新，而坏的时钟需要频繁和大的更新。作为参数传递的值被简化为一个接近零的小值，然后将其添加到累积值中。在添加特定数量的值后（在校准间隔结束时），将总量除以校准间隔的长度，从而给出新的频率校正。

When flag `STA_PPSTIME` is set, the start of a second is moved towards the PPS event, reducing  the needed offset correction. The time offset given as argument to the  routine will be put into a three-stage median filter to reduce spikes  and to compute the jitter. Then an averaged value is applied as offset  correction.
设置标志 `STA_PPSTIME` 后，秒的开始将移至 PPS 事件，从而减少所需的偏移校正。作为例程参数给出的时间偏移量将被放入三级中值滤波器中，以减少尖峰并计算抖动。然后应用平均值作为偏移校正。

In addition to these direct manipulations, `hardpps()` also detects, signals, and filters various error conditions. The length of the calibration interval is also adjusted automatically. As the  limit for a bad calibration is ridiculously high (about 500 PPM per  calibration), the calibration interval normally is always at its  configured maximum.
除了这些直接操作外， `hardpps()` 还可以检测、发出信号和过滤各种错误情况。校准间隔的长度也会自动调整。由于错误校准的限值高得离谱（每次校准约 500 PPM），校准间隔通常始终处于其配置的最大值。

# 5.3. NTP in real Life 5.3. 现实生活中的NTP

Last update: April 3, 2024 16:42 UTC ([f170361b7](https://git.nwtime.org/websites/ntpwww/commit/f170361b72193f7af81935c6c0a4afda96793f0d))
最后更新： 2024年4月3日 16：42 UTC （ f170361b7）

This section discusses how well the theory applies to real life situations.
本节讨论该理论在现实生活中的适用程度。

5.3.1 [What if I write my own SNTP Server?](https://www.ntp.org/ntpfaq/ntp-s-algo-real/#531-what-if-i-write-my-own-sntp-server)
5.3.1 如果我编写自己的SNTP服务器怎么办？
 5.3.2 [Why should I have more than one clock?](https://www.ntp.org/ntpfaq/ntp-s-algo-real/#532-why-should-i-have-more-than-one-clock)
5.3.2 为什么我应该有多个时钟？
 5.3.3 [Does the reference time depend on all configured servers, or is it based on which ever responds first?](https://www.ntp.org/ntpfaq/ntp-s-algo-real/#533-does-the-reference-time-depend-on-all-configured-servers-or-is-it-based-on-which-ever-responds-first)
5.3.3 参考时间是否取决于所有配置的服务器，还是取决于哪个服务器最先响应？
 5.3.4 [What happens during a Leap Second?](https://www.ntp.org/ntpfaq/ntp-s-algo-real/#534-what-happens-during-a-leap-second)
5.3.4 闰秒期间会发生什么？

------

#### 5.3.1 What if I write my own SNTP Server? 5.3.1 如果我编写自己的SNTP服务器怎么办？

There is a quote (with partial omissions) on that subject by [Professor David L. Mills](https://www.nwtime.org/tribute-to-david-l-mills/):
David L. Mills教授引用了一段关于这个主题的引文（部分省略）：

(…) The SNTP specification forbids operation as a server unless a primary server connected to a reference clock. (…)
(…)SNTP 规范禁止作为服务器运行，除非主服务器连接到参考时钟。(…)

Running SNTP as a server is probably the single most serious hazard in the  universe. You might not agree with the particular engineering design in  my clock mitigation and discipline algorithms and security model but it  is absolutely imperative that the correctness assertions be religiously  observed. Even so, folks have come to expect a certain level of  performance from the “standard” distribution which the algorithms are  designed to achieve. These algorithms have purposely been omitted from  the SNTP specification on the understanding that a SNTP server will  always have a reference source and a SNTP client will never function as a server to dependent clients.
将SNTP作为服务器运行可能是宇宙中最严重的危险。你可能不同意我的时钟缓解和纪律算法和安全模型中的特定工程设计，但绝对必须虔诚地遵守正确性断言。即便如此，人们还是开始期望算法旨在实现的“标准”分布具有一定程度的性能。这些算法特意从 SNTP 规范中省略，因为 SNTP 服务器将始终具有引用源，而 SNTP 客户端永远不会用作依赖客户端的服务器。

I’ve had a lotta years thinking about these models. There should be only two models. One, represented by SNTP, is intended for casual PCs and  workstations where simplicity and ubiquity is intended. It has similar  functionality as `date` and `rdate` and is totally stateless. The other, represented by NTP, is a widely  understood, thoroughly researched and verified engineering design. The  design should include a definitive specification and be rigidly  implemented to spec so folks have a high level of confidence it does  what the spec requires. I want only one such spec, not a plurality of  specs and implementations that are not completely interoperable. The NTP subnet is not a community of distinct servers, but a intimately  intertwined real-time coupled oscillators. Get one of these things wrong and large portions of the subnet could become unstable. Heck it happens once in a while, notwithstanding the recent bug.
我花了很多年时间思考这些模型。应该只有两个模型。一种以 SNTP 为代表，适用于旨在实现简单性和无处不在的休闲 PC 和工作站。它具有与 `date` 和 `rdate`  类似的功能，并且完全无状态。另一个以NTP为代表，是一种被广泛理解、经过深入研究和验证的工程设计。设计应该包括一个明确的规范，并严格按照规范实施，这样人们就有高度的信心去做规范的要求。我只想要一个这样的规范，而不是多个不能完全互操作的规范和实现。NTP  子网不是一个由不同服务器组成的社区，而是一个紧密交织的实时耦合振荡器。如果其中一项操作出错，子网的大部分可能会变得不稳定。哎呀，它偶尔会发生一次，尽管最近有错误。

Okay, tune for minimum flame. We are obviously not to that degree of rigor  now. There are very, very many places where a definitive spec would  contain options - should the huff-‘n-puff filter be required? What I  have been working on the last few years is to push the envelope to test  as many different ideas as feasible and then decide as a group which  should be in the core spec and which should be optional.
好的，调到最小的火焰。我们现在显然没有达到那种严谨的程度。在很多地方，一个明确的规范都会包含选项--是否应该需要huff-'n-puff过滤器？在过去的几年里，我一直在做的是挑战极限，尽可能多地测试不同的想法，然后作为一个小组决定哪些应该在核心规范中，哪些应该是可选的。

You may suggest there is nothing wrong with a SNTP subnet of clients and  servers which is wholly contained and where synchronization is never  leaked to the NTP subnet. I have no problem with this should it be  practical. Past experience with undisciplined local clocks leaking to  the NTP subnet suggests this will happen with SNTP servers. I don’t  think it is a good idea to provide a SNTP capability that casually  invites newbie folks to disregard the spec. If we really do want to  provide such a capability, there should be a serious disclaimer  published in conspicuous places. How would it be if a stratum-2 SNTP  server sneaked in the list of public servers? (…)
您可能会建议完全包含的客户端和服务器的 SNTP 子网没有任何问题，并且同步永远不会泄漏到 NTP 子网。如果它是可行的，我对此没有问题。过去无规律的本地时钟泄漏到 NTP  子网的经验表明，SNTP 服务器会发生这种情况。我不认为提供 SNTP  功能是一个好主意，它随便邀请新手忽略规范。如果我们真的想提供这样的功能，应该在显眼的地方发布一个严肃的免责声明。如果 stratum-2  SNTP 服务器潜入公共服务器列表会怎样？(…)

------

#### 5.3.2 Why should I have more than one clock? 5.3.2 为什么我应该有多个时钟？

NTP likes to estimate the errors of all clocks. Therefore all NTP servers  return the time together with an estimate of the current error. When  using multiple time servers, NTP also wants these servers to agree on  some time, meaning there must be one error interval where the correct  time must be.
NTP喜欢估计所有时钟的误差。因此，所有 NTP 服务器都会返回时间以及当前错误的估计值。当使用多个时间服务器时，NTP 还希望这些服务器在某个时间达成一致，这意味着必须有一个错误间隔，其中必须有正确的时间。

[The 1999 survey](https://www.ntp.org/reflib/reports/ntp-survey99-minar.pdf) suggests that not all NTP servers work as designed in theory. In fact  there was a high percentage of stratum-1 servers with a bad time. Over  30% of the active stratum-1 servers had a clock error of over 10  seconds, and a few even had an error of more than a year. The author of  the survey says: “Only 28% of the stratum 1 clocks found appear to  actually be useful.”
1999 年的调查表明，并非所有 NTP 服务器都按理论设计工作。事实上，有很大一部分 stratum-1 服务器的时间不好。超过 30% 的活跃  stratum-1 服务器的时钟误差超过 10 秒，少数甚至超过一年。该调查的作者说：“只有28%的1层时钟似乎实际上是有用的。

Time sources that are reachable and have a *dispersion* smaller than the maximum become *candidates* for time synchronization, thus contributing an error interval. In [RFC 1305](https://www.ntp.org/reflib/rfc/rfc1305/rfc1305b.pdf) section 4.2 the algorithms are treated in greater detail.
可访问且离散小于最大值的时间源将成为时间同步的候选者，从而产生误差间隔。在 RFC 1305 第 4.2 节中，算法将得到更详细的处理。

If these candidates pass another validation test, they become *survivors*. Basically all values must lie within the error interval the majority of candidates defines. All other time sources are called *falsetickers* subsequently.
如果这些候选人通过了另一个验证测试，他们将成为幸存者。基本上，所有值都必须位于大多数候选人定义的误差区间内。所有其他时间源随后称为虚假代码。

Among the survivors those with significant high dispersion are removed and tagged as *outlyers*.
在幸存者中，那些具有显着高度分散的人被移除并标记为外围者。

The final synchronization source is the survivor with the smallest dispersion.
最终的同步源是离散最小的幸存者。

From this description: 从这个描述中：

- Just one time source will always be trusted.
  只有一个来源将始终是可信的。
- Two time sources cannot be split into two parties where one has a majority.
  两个时间来源不能分为两个政党，其中一个政党占多数。
- For a three-server configuration a failing server will cause the two-server problem to appear.
  对于三服务器配置，发生故障的服务器将导致出现双服务器问题。

------

#### 5.3.3 Does the reference time depend on all configured servers, or is it based on which ever responds first? 5.3.3 参考时间是否取决于所有配置的服务器，还是取决于哪个服务器最先响应？

Neither of these is true since multiple time sources will be selected and  combined to get an estimate of the time. Some criteria are:
这两种情况都不是真的，因为将选择并组合多个时间源以获得时间的估计值。一些标准是：

- Is the configured server *reachable* (does it respond to queries)?
  配置的服务器是否可访问（是否响应查询）？
- Do replies of the server satisfy basic sanity checks: delay, offset,  jitter (dispersion), and stratum? Basically, lower values are preferred.
  服务器的回复是否满足基本的健全性检查：延迟、偏移、抖动（色散）和分层？基本上，较低的值是首选。
- If a configured server gets that far, it will be called a candidate.  Candidates are ordered by jitter; the one with the lowest jitter will be the new time reference, but all the others will contribute to the  estimated time as well.
  如果配置的服务器走到这一步，它将被称为候选服务器。候选人按抖动排序;抖动最低的那个将是新的时间参考，但所有其他参考也将对估计时间产生影响。

------

#### 5.3.4 What happens during a Leap Second? 5.3.4 闰秒期间会发生什么？

The theory of leap seconds in explained in [Q: 2.4](https://www.ntp.org/ntpfaq/ntp-s-time/#24-what-happens-during-a-leap-second). In reality there are two cases to consider:
闰秒理论在Q：2.4中解释。实际上，有两种情况需要考虑：

- If the operating system implements the [kernel discipline](https://www.ntp.org/ntpfaq/ntp-s-algo-kernel/), `ntpd` will announce insertion and deletion of leap seconds to the kernel. The kernel will handle the leap seconds without further action necessary.
  如果操作系统实现了内核规则， `ntpd` 则将宣布插入和删除内核的闰秒。内核将处理闰秒，无需进一步操作。
- If the operating system does not implement the kernel discipline, the  clock will show an error of one second relative to NTP’s time  immediately after the leap second. The situation will be handled just  like an unexpected change of time: the operating system will continue  with the wrong time for some time, but eventually `ntpd` will *step* the time. Effectively this will cause the correction for leap seconds to be applied too late.
  如果操作系统未实现内核规则，则时钟将在闰秒之后立即显示相对于 NTP 时间的一秒误差。这种情况的处理方式就像时间的意外变化一样：操作系统将在一段时间内以错误的时间继续运行，但最终会 `ntpd` 步进时间。实际上，这将导致闰秒的校正应用得太晚。

# 5.4. Encryption 5.4. 加密

Last update: June 27, 2022 16:22 UTC ([1a7aee0a0](https://git.nwtime.org/websites/ntpwww/commit/1a7aee0a0bed1662a9f219fcaea42e57cff5d0b3))
最后更新： 2022年6月27日 16：22 UTC （ 1a7aee0a0）

This section discusses the use of encryption and related technology for NTP.
本节讨论 NTP 的加密和相关技术的使用。

Providing or enabling the use of encryption in software was considered harmful by the USA. However electronic commerce is only possibly with safe data  exchange, so use of encryption has become a bit more allowed. NTP  version 4 includes no cryptography, from the viewpoint of government  regulations, and introduces MD5 keys.
美国认为在软件中提供或允许使用加密是有害的。然而，电子商务只有通过安全的数据交换才有可能，因此加密的使用变得更加允许。从政府法规的角度来看，NTP 版本 4 不包括加密，并引入了 MD5 密钥。

As MD5 is heavily used in digital signatures, MD5 is not considered as  cryptography, despite the fact that digital signatures actually *do* use encryption.
由于 MD5 在数字签名中被大量使用，因此 MD5 不被视为密码学，尽管数字签名实际上确实使用加密。

------

5.4.1 [What is Encryption used for in NTP?](https://www.ntp.org/ntpfaq/ntp-s-algo-crypt/#541-what-is-encryption-used-for-in-ntp)
5.4.1 NTP中的加密用途是什么？
 5.4.1.1 [How is Authenticity verified?](https://www.ntp.org/ntpfaq/ntp-s-algo-crypt/#5411-how-is-authenticity-verified)
5.4.1.1 如何验证真实性？
 5.4.1.2 [Where are authenticated Messages used in NTP?](https://www.ntp.org/ntpfaq/ntp-s-algo-crypt/#5412-where-are-authenticated-messages-used-in-ntp)
5.4.1.2 经过身份验证的消息在 NTP 中的什么位置使用？
 5.4.1.3 [How is Performance affected by Encryption?](https://www.ntp.org/ntpfaq/ntp-s-algo-crypt/#5413-how-is-performance-affected-by-encryption)
5.4.1.3 加密对性能有何影响？
 5.4.2 [The Basics of Autokey](https://www.ntp.org/ntpfaq/ntp-s-algo-crypt/#542-the-basics-of-autokey)
5.4.2 自动密钥的基础知识
 5.4.2.1 [Authentic and Proventic](https://www.ntp.org/ntpfaq/ntp-s-algo-crypt/#5421-authentic-and-proventic)
5.4.2.1 真实和原始
 5.4.2.2 [Secure Group and Trusted Host](https://www.ntp.org/ntpfaq/ntp-s-algo-crypt/#5422-secure-group-and-trusted-host)
5.4.2.2 安全组和受信任主机
 5.4.2.3 [Identity Schemes](https://www.ntp.org/ntpfaq/ntp-s-algo-crypt/#5423-identity-schemes)
5.4.2.3 身份方案
 5.4.2.4 [Proventic Trail](https://www.ntp.org/ntpfaq/ntp-s-algo-crypt/#5424-proventic-trail) 5.4.2.4 普罗旺斯小径
 5.2.4.5 [Session Keys](https://www.ntp.org/ntpfaq/ntp-s-algo-crypt/#5425-session-keys) 5.2.4.5 会话密钥

------

#### 5.4.1 What is Encryption used for in NTP? 5.4.1 NTP中的加密用途是什么？

Basically NTP uses encryption only for integrity checking and authentication:
基本上，NTP 仅将加密用于完整性检查和身份验证：

- Symmetric keys (shared secrets) are used to prove authenticity of data received over the network.
  对称密钥（共享密钥）用于证明通过网络接收的数据的真实性。
- Key pairs are used where establishing shared secrets is difficult. The autokey mechanism uses key pairs.
  密钥对用于难以建立共享密钥的情况。自动密钥机制使用密钥对。

------

#### 5.4.1.1 How is Authenticity verified? 5.4.1.1 如何验证真实性？

Cryptographic hash functions like MD5 have the following properties:
加密哈希函数（如 MD5）具有以下属性：

- A large amount of input data produces a small fingerprint (output data).
  大量的输入数据会产生一个小的指纹（输出数据）。
- Different input creates different output.
  不同的输入会产生不同的输出。
- It’s not possible to construct some input matching a specific output other  than by brute force, or trying at least as many combinations of input  that correspond to the key space of the output.
  除了通过蛮力或尝试至少与输出的关键空间相对应的输入组合之外，不可能构造与特定输出匹配的某些输入。

The sender computes a *fingerprint* consisting of public data plus some secret data (the *symmetric key*), and adds it to the data being transferred. The recipient uses the received data plus the *shared secret* to compute its own fingerprint in the same way as the sender. Providing a correct fingerprint implies that the sender knows the shared secret,  and that the data received wan’t changed during transmission.
发送方计算由公共数据和一些秘密数据（对称密钥）组成的指纹，并将其添加到正在传输的数据中。接收方使用接收到的数据和共享密钥以与发送方相同的方式计算自己的指纹。提供正确的指纹意味着发送者知道共享密钥，并且接收到的数据在传输过程中不会更改。

While the above procedure is not considered to be data encryption, the following procedure using *key pairs* is: the sender computes a fingerprint of the public data only, but then encrypts that fingerprint with its secret *private key* of the key pair. Message plus encrypted fingerprint are sent. The recipient decrypts the fingerprint using its *public key* and compares it the fingerprint computed locally from the public data.  If both are the same, it is believed that it’s only possible to send the correct encrypted fingerpint when knowing the secret key.
虽然上述过程不被视为数据加密，但使用密钥对的以下过程是：发送方仅计算公共数据的指纹，然后使用密钥对的秘密私钥加密该指纹。发送消息和加密指纹。接收方使用其公钥解密指纹，并将其与从公共数据本地计算的指纹进行比较。如果两者相同，则认为只有在知道密钥的情况下才能发送正确的加密指纹。

Refer to [this article](https://en.wikipedia.org/wiki/RSA_(cryptosystem)) for an overview of the mathematical properties and generation of key pairs.
有关密钥对的数学属性和生成的概述，请参阅本文。

------

#### 5.4.1.2 Where are authenticated Messages used in NTP? 5.4.1.2 经过身份验证的消息在 NTP 中的什么位置使用？

The uses of authenticated messages in NTP are:
NTP 中经过身份验证的消息的用途包括：

- Remote configuration commands.
  远程配置命令。
- Time messages (authentication is optional).
  时间消息（身份验证是可选的）。

------

#### 5.4.1.3 How is Performance affected by Encryption? 5.4.1.3 加密对性能有何影响？

Strong cryptography is computationally expensive. Furthermore, the time  required to complete the computations may depend on the actual values  being processed in a non-predictable way.
强加密在计算上是昂贵的。此外，完成计算所需的时间可能取决于以不可预测的方式处理的实际值。

NTP tries to avoid cryptography whenever possibe. MD5 is believed to  require almost constant CPU cycles, while public key algorithms are  known to require significantly more, and a varying number of CPU cycles.
NTP 尽可能避免加密。MD5 被认为需要几乎恒定的 CPU 周期，而公钥算法需要的 CPU 周期要多得多，并且需要不同数量的 CPU 周期。

------

#### 5.4.2 The Basics of Autokey 5.4.2 自动密钥的基础知识

Symmetric key encryption requires a secure channel to exchange secret keys. Every NTP client needs a secret key for authenticating the time messages from a server. Public key cryptography and X.509 version 3 certificates are  used for the [Autokey](https://www.ntp.org/reflib/rfc/rfc5906.txt) authentication schema that is summarized below. See [Q: 6.2.2.6](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6226-how-do-i-use-public-key-authentication-autokey) for configuration details.
对称密钥加密需要一个安全通道来交换密钥。每个 NTP 客户端都需要一个密钥来验证来自服务器的时间消息。公钥加密和 X.509 版本 3 证书用于自动密钥身份验证架构，如下所述。有关配置详细信息，请参见 Q： 6.2.2.6。

As public key algorithms are computationally expensive, those algorithms are not used for every packet being exchanged.
由于公钥算法的计算成本很高，因此这些算法不会用于交换的每个数据包。

------

#### 5.4.2.1 Authentic and Proventic 5.4.2.1 真实和原始

In [NTP Security Model](https://www.ntp.org/reflib/brief/autokey/autokey.pdf) the phrases are defined like this:
在 NTP 安全模型中，短语的定义如下：

- authentic 真实

  A client is authentic if it can reliably verify the credentials of at least one server and the integrity of its messages. 如果客户端能够可靠地验证至少一台服务器的凭据及其消息的完整性，则该客户端是真实的。

- proventic 普罗旺蒂克

  A client is proventic if there exists a path to a trusted server where each node is authentic. 如果存在指向受信任服务器的路径，其中每个节点都是真实的，则客户端是 proventic。

------

#### 5.4.2.2 Secure Group and Trusted Host 5.4.2.2 安全组和受信任主机

A *secure group* defines a subset of the NTP network that uses a common *security model*, *authentication protocol*, and *identity scheme*. Each member of a group has *identity parameters* and a *group key* provided by some *trusted agent*.
安全组定义使用通用安全模型、身份验证协议和身份方案的 NTP 网络子集。组的每个成员都有标识参数和由某些受信任代理提供的组密钥。

Each secure group has at least one *trusted host* that operates as *certificate authority* at the lowest stratum of the group.
每个安全组至少有一个受信任的主机，该主机在组的最低层作为证书颁发机构运行。

A *primary group* includes at least one trusted primary server (stratum 1).
主组包括至少一个受信任的主服务器（第 1 层）。

------

#### 5.4.2.3 Identity Schemes 5.4.2.3 身份方案

*Identity Schemes* are methods to prove the identity of a remote system, helping to prevent *man-in-the-middle attacks*. In [NTP Security Algorithms](https://www.ntp.org/reflib/brief/secalgor/secalgor.pdf) and [NTP Security Model](https://www.ntp.org/reflib/brief/autokey/autokey.pdf) the following identity schemes are mentioned:
身份方案是证明远程系统身份的方法，有助于防止中间人攻击。在 NTP 安全算法和 NTP 安全模型中，提到了以下身份方案：

- **Private Certificate (PC):** much like private keys, requiring a secret channel to distribute keys.
  私有证书 （PC）：与私钥非常相似，需要一个秘密通道来分发密钥。
- **Trusted Certificate (TC):** uses a trusted authority (TA) and certificate chains.
  可信证书 （TC）：使用受信任的颁发机构 （TA） 和证书链。
- **Schnorr Identity Scheme (IFF):** uses DSA principles.
  Schnorr Identity Scheme （IFF）：使用 DSA 原则。
- **Guillou-Quisquater Identity Scheme (GQ):** based on RSA principles.
  Guillou-Quisquater 身份方案 （GQ）：基于 RSA 原则。
- **Mu-Varadharajan Identity Scheme (MV):** based on DSA principles, but does not require trusted clients.
  Mu-Varadharajan 身份方案 （MV）：基于 DSA 原则，但不需要受信任的客户端。

All schemes use relatively small keys (few bits), so those keys must be  refreshed regularly. Even though certificates are valid for one year  after creation, the keys should be re-created on a shorter interval.  Using the NTP timestamp as the certificate’s serial number ensures  uniqueness. Thus signatures are only generated when the host’s time is  considered synchronized.
所有方案都使用相对较小的密钥（少量位），因此必须定期刷新这些密钥。即使证书在创建后一年内有效，也应在较短的时间间隔内重新创建密钥。使用 NTP 时间戳作为证书的序列号可确保唯一性。因此，只有当主机的时间被认为是同步的时，才会生成签名。

------

#### 5.4.2.4 Proventic Trail 5.4.2.4 普罗旺斯小径

According to [NTP Security Protocol](https://www.ntp.org/reflib/brief/secproto/secproto.pdf), a *proventic trail* (certificate trail) is a cryptographically verified sequence of NTP servers ending at a trusted host.
根据 NTP 安全协议，proventic 跟踪（证书跟踪）是以受信任主机结尾的 NTP 服务器经过加密验证的序列。

------

#### 5.4.2.5 Session Keys 5.4.2.5 会话密钥

According to [NTP Security Protocol](https://www.ntp.org/reflib/brief/secproto/secproto.pdf), *session keys* are 128 bits (16 octets). Session keys are created as lists of keys, and the last key in the list is digitally signed. See [RFC 2104 HMAC: Keyed-Hashing for Message Authentication](https://www.rfc-editor.org/rfc/rfc2104) for basics.
根据 NTP 安全协议，会话密钥为 128 位（16 个八位字节）。会话密钥创建为密钥列表，列表中的最后一个密钥经过数字签名。有关基础知识，请参阅 RFC 2104 HMAC：消息身份验证的密钥哈希。

# 6. Configuration 6. 配置

Last update: April 3, 2024 16:42 UTC ([f170361b7](https://git.nwtime.org/websites/ntpwww/commit/f170361b72193f7af81935c6c0a4afda96793f0d))
最后更新： 2024年4月3日 16：42 UTC （ f170361b7）

Configuration is a manual procedure that is necessary to get a running NTP system.
配置是获取正在运行的 NTP 系统所必需的手动过程。

6.1 [Basic Configuration](https://www.ntp.org/ntpfaq/ntp-s-config/#61-basic-configuration) 6.1 基本配置
 6.1.1 [Can’t I just run ntpdate?](https://www.ntp.org/ntpfaq/ntp-s-config/#611-cant-i-just-run-ntpdate)
6.1.1 我不能只运行ntpdate吗？
 6.1.2 [Recommended Minimum](https://www.ntp.org/ntpfaq/ntp-s-config/#612-recommended-minimum)
6.1.2 建议的最小值
 6.1.2.1 [What is the minimum configuration?](https://www.ntp.org/ntpfaq/ntp-s-config/#6121-what-is-the-minimum-configuration)
6.1.2.1 最低配置是多少？
 6.1.2.2 [Is the minimum configuration a typical one?](https://www.ntp.org/ntpfaq/ntp-s-config/#6122-is-the-minimum-configuration-a-typical-one)
6.1.2.2 最低配置是典型的配置吗？
 6.1.2.3 [What is the correct Pseudo IP Address for my reference clock?](https://www.ntp.org/ntpfaq/ntp-s-config/#6123-what-is-the-correct-pseudo-ip-address-for-my-reference-clock)
6.1.2.3 参考时钟的正确伪IP地址是多少？
 6.1.2.4 [What is a drift file?](https://www.ntp.org/ntpfaq/ntp-s-config/#6124-what-is-a-drift-file)
6.1.2.4 什么是漂移文件？
 6.1.2.5 [Should I use IP addresses or host names?](https://www.ntp.org/ntpfaq/ntp-s-config/#6125-should-i-use-ip-addresses-or-host-names)
6.1.2.5 我应该使用 IP 地址还是主机名？
 6.1.3 [Running an isolated Network](https://www.ntp.org/ntpfaq/ntp-s-config/#613-running-an-isolated-network)
6.1.3 运行隔离网络
 6.1.3.1 [Can I use my system clock as reference clock?](https://www.ntp.org/ntpfaq/ntp-s-config/#6131-can-i-use-my-system-clock-as-reference-clock)
6.1.3.1 我可以使用我的系统时钟作为参考时钟吗？
 6.1.3.2 [Can I avoid manual time adjustments in a network without reference clock?](https://www.ntp.org/ntpfaq/ntp-s-config/#6132-can-i-avoid-manual-time-adjustments-in-a-network-without-reference-clock)
6.1.3.2 在没有参考时钟的网络中，我是否可以避免手动调整时间？
 6.1.4 [Recommended Goodies](https://www.ntp.org/ntpfaq/ntp-s-config/#614-recommended-goodies)
6.1.4 推荐的好东西
 6.1.4.1 [How can I configure the amount of logging information?](https://www.ntp.org/ntpfaq/ntp-s-config/#6141-how-can-i-configure-the-amount-of-logging-information)
6.1.4.1 如何配置日志记录信息量？
 6.1.4.2 [How can I speed up initial Synchronization?](https://www.ntp.org/ntpfaq/ntp-s-config/#6142-how-can-i-speed-up-initial-synchronization)
6.1.4.2 如何加快初始同步速度？
 6.1.4.3 [How do I configure remote administration?](https://www.ntp.org/ntpfaq/ntp-s-config/#6143-how-do-i-configure-remote-administration)
6.1.4.3 如何配置远程管理？
 6.1.4.4 [How do I use authentication keys?](https://www.ntp.org/ntpfaq/ntp-s-config/#6144-how-do-i-use-authentication-keys)
6.1.4.4 如何使用身份验证密钥？
 6.1.4.5 [What are all the different Keys used for?](https://www.ntp.org/ntpfaq/ntp-s-config/#6145-what-are-all-the-different-keys-used-for)
6.1.4.5 所有不同的密钥是用来做什么的？
 6.1.4.6 [How do I use autokey?](https://www.ntp.org/ntpfaq/ntp-s-config/#6146-how-do-i-use-autokey)
6.1.4.6 如何使用自动密钥？
 6.1.5 [Miscellaneous Hints](https://www.ntp.org/ntpfaq/ntp-s-config/#615-miscellaneous-hints)
6.1.5 其他提示
 6.1.5.1 [What is the preferred etiquette when synchronizing to a public server?](https://www.ntp.org/ntpfaq/ntp-s-config/#6151-what-is-the-preferred-etiquette-when-synchronizing-to-a-public-server)
6.1.5.1 同步到公共服务器时的首选礼仪是什么？
 6.1.5.2 [Where can I find public Time Servers?](https://www.ntp.org/ntpfaq/ntp-s-config/#6152-where-can-i-find-public-time-servers)
6.1.5.2 在哪里可以找到公共时间服务器？

------

#### 6.1 Basic Configuration 6.1 基本配置

This section discusses basic configuration issues for `ntpd`, hopefully covering what 90% of users need.
本节讨论 的基本 `ntpd` 配置问题，希望涵盖 90% 的用户需要的内容。

------

#### 6.1.1 Can’t I just run ntpdate? 6.1.1 我不能只运行ntpdate吗？

`ntpdate` sets the system clock once and mostly in a brute way. As real clocks drift, you need periodic corrections. You can run `ntpdate` in a `cron` job hourly or daily, but your machine won’t be an NTP server.
 `ntpdate` 设置系统时钟一次，而且主要是以粗暴的方式设置。当真正的时钟漂移时，您需要定期校正。您可以每小时或每天在 `cron` 作业中运行 `ntpdate` ，但您的计算机不会是 NTP 服务器。

In contrast, `ntpd` learns and remembers the clock drift and corrects it autonomously, even if there is no reachable server. Therefore large clock steps can be  avoided while the machine is synchronized to some reference clock. In  addition `ntpd` will maintain error estimates and statistics, and can offer NTP service for other machines. Last, but not least, `ntpdate` cannot query a local reference clock.
相反，即使没有可访问的服务器， `ntpd` 也可以学习和记住时钟漂移并自动纠正它。因此，当机器与某个参考时钟同步时，可以避免较大的时钟步长。此外 `ntpd` ，还将维护误差估计和统计，并可以为其他机器提供NTP服务。最后但并非最不重要的一点是， `ntpdate` 无法查询本地参考时钟。

In addition, there are plans to put the functionality of `ntpdate` into `ntpd`. Let me quote [Professor David L. Mills](https://www.nwtime.org/tribute-to-david-l-mills/):
此外，还有计划将 的功能 `ntpdate` 放入 `ntpd` .让我引用David L. Mills教授的话：

Our zeal to deprecate `ntpdate` and friends like that is based entirely on our wish to eliminate redundant maintenance. The `ntpdate` program was crafted many years ago as a ripoff of `xntpd` with poorly adapted I/O, outdated algorithms and poor debugging support. If we can satisfy folks that `ntpd` with appropriate command line switch is the answer to their collective prayers, then we will scrap `ntpdate` and friend. It is in principle easy to modify `ntpd` to “quickly” set the clock; however, please do understand our reluctance to do that for the following reasons.
我们热衷于弃用 `ntpdate` 和这样的朋友，完全基于我们消除冗余维护的愿望。该 `ntpdate` 程序是多年前精心制作的，是 I/O 适应性差、算法过时和调试支持差的剽窃 `xntpd` 。如果我们能让人们满意， `ntpd` 通过适当的命令行切换是他们集体祈祷的答案，那么我们将报废 `ntpdate` 并成为朋友。原则上很容易修改 `ntpd` 为“快速”设置时钟;但是，出于以下原因，请理解我们不愿意这样做。

Most folks who use `ntpdate` call it from a `cron` job at intervals of maybe a day. You would be surprised at how many do  this at the stroke of midnight. We have observed little fireballs of  congestion when that occurs, especially at the NIST and USNO servers  which even in the best of times with polite `xntpd/ntpd` suffer an aggregate load of well over 40 packets per second. We really  don’t want clients to create volleys of congestion by transmitting as  fast as the network will allow.
大多数使用 `ntpdate` 的人可能每隔一天就从 `cron` 工作中调用它。你会惊讶于有多少人在午夜时分这样做。当这种情况发生时，我们观察到很少的拥塞火球，尤其是在NIST和USNO服务器上，即使在礼貌 `xntpd/ntpd` 的最佳时期，它们的总负载也远远超过每秒40个数据包。我们真的不希望客户端通过网络允许的传输速度来制造一连串的拥塞。

The thrust of recent work on the NTPv4 protocols has not (with emphasis)  been to improve accuracy - the nanokernel development is tangential and  the only interlocking agenda has been to adapt the PPS interface to a  standard acceptable to the kernel-mongers for the Alpha, SPARC and Intel platforms. However, it is indeed fair to characterize the work specific to NTPv4 as concentrating on the error mitigation algorithms to deal  with the extraordinary range of network path characteristics encountered today. There also have been many incremental improvements, such as  burst mode, that have resulted from various bug reports and suggestions.
最近关于NTPv4协议的工作重点不是（强调）提高准确性 -  纳米内核的开发是切线的，唯一的环环相扣的议程是使PPS接口适应Alpha，SPARC和Intel平台的内核贩子可以接受的标准。但是，将特定于  NTPv4  的工作描述为专注于错误缓解算法，以处理当今遇到的异常广泛的网络路径特征，这确实是公平的。还有许多增量改进，例如突发模式，这些改进是由各种错误报告和建议引起的。

An absolutely vital requirement in our view is to protect against  accidental or malicious servers that may result in excessive time  errors. The only true defense against falsetickers is to have at least  three different servers (a Byzantine defense requires at least four) and an effective mitigation algorithm, such as the one now used in NTP and  refined over the last eight years. Note that accuracy is not an issue  here, only the separation of the truechimers from the falsetickers.
在我们看来，一个绝对重要的要求是防止可能导致过多时间错误的意外或恶意服务器。唯一真正的防御虚假代码是拥有至少三个不同的服务器（拜占庭防御至少需要四个）和一个有效的缓解算法，例如现在用于 NTP 并在过去八年中改进的算法。请注意，准确性在这里不是问题，只是将真嵌合物与假嵌合物分开。

Now, the first measurement when the `ntpd` is first started is almost certainly a terrible one. There are many  reasons for this - ARP caching in the routers, flow setup at various  points and circuit setup (ISDN). The only real solution for that is to  use more than one sample. The measurements made some years ago and  revealed in an RFC suggest that a window of eight samples is a good  compromise between effectiveness (more samples) and closed-loop  transient response (fewer samples).
现在，第一次开始时的第一次测量几乎可以肯定是一次糟糕的测量 `ntpd` 。造成这种情况的原因有很多 - 路由器中的 ARP 缓存、各个点的流设置和电路设置 （ISDN）。唯一真正的解决方案是使用多个样本。几年前进行的测量结果在RFC中显示，8个样本的窗口是有效性（更多样本）和闭环瞬态响应（更少样本）之间的良好折衷方案。

So, I think most folks would agree that some number of different servers is necessary and that some number of samples should be collected before  the mitigation algorithms do set the clock. You get to select the former in the configuration file (or use manycast to do that automatically).  How many samples to wait before the mitigation algorithms actually set  the clock depends on the quality of the estimated accuracy. The  parameters selected as the result of experience result in about four  samples, depending on the network jitter.
所以，我认为大多数人都会同意，一定数量的不同服务器是必要的，并且在缓解算法设置时钟之前应该收集一定数量的样本。您可以在配置文件中选择前者（或使用 manycast  自动执行此操作）。在缓解算法实际设置时钟之前要等待多少个样本取决于估计精度的质量。根据经验选择的参数会产生大约四个样本，具体取决于网络抖动。

So, let’s say that as the result of several years experience and algorithm  refinement we agree on four servers and four samples. The question is  what is the interval between samples? As delivered from shrinkwrap, the  initial interval is 64 s, but does usually increase to 1024 s. That  results in about a four minute delay before the clock is set, which  might be too long for some, but does protect the many public servers on  the net now. So what’s the deal? You can reduce that interval to a few  seconds using burst mode. While this does provide more snappy response,  it increases the aggregate client insult to the server by a factor of  eight and should be used sparingly.
因此，假设经过几年的经验和算法改进，我们同意使用四台服务器和四个样本。问题是样本之间的间隔是多少？从收缩包装中交付时，初始间隔为 64 秒，但通常会增加到 1024  秒。这导致在设置时钟之前有大约四分钟的延迟，这对某些人来说可能太长了，但现在确实保护了网络上的许多公共服务器。那么这是怎么回事呢？您可以使用突发模式将该间隔缩短到几秒钟。虽然这确实提供了更敏捷的响应，但它会将客户端对服务器的聚合侮辱增加八倍，应谨慎使用。

However, this is not the only consideration. When multiple servers are involved, it is not a good idea to poll them at the same time. Therefore, `ntpd` randomized the initial volley when first coming up. This results in an  average delay of about 30 s before anything useful happens. Worse than  that, `ntpd` has to wait until a majority of the configured servers have showed up and with at least four good samples.
然而，这并不是唯一的考虑因素。当涉及多个服务器时，同时轮询它们不是一个好主意。因此， `ntpd` 在第一次出现时随机化了初始截击。这导致在发生任何有用的事情之前平均延迟约 30 秒。更糟糕的是， `ntpd` 必须等到大多数配置的服务器都出现并且至少有四个好的样本。

You can see from the above why we believe `ntpdate` is such a poor network citizen and at least some idea of its  vulnerabilities. You can also see where the compromises are and possibly how changing some of the parameters might benefit your cause. We could  disable the initial randomization, increase the quality tolerance so  fewer samples will set the clock, go into burst mode initially and once  the clock is set back off to normal mode, etc., etc. Right now,  parameter selection is a black art; I would suspect making them  configurable will result in some very bad choices and may result in  serious server insult. Once upon a time (with NTPv1) a bug resulted in  some servers volleying continuously as fast as the net would allow. The  bug was discovered only after the network monitoring center reported  that NTP was the single largest source of traffic in the Internet.
从上面可以看出为什么我们认为 `ntpdate`  是一个如此糟糕的网络公民，并且至少对其漏洞有所了解。您还可以查看妥协的位置，以及更改某些参数可能如何使您的事业受益。我们可以禁用初始随机化，提高质量容差，这样就会有更少的样本来设置时钟，最初进入突发模式，一旦时钟被设置回正常模式，等等。现在，参数选择是一门黑色艺术;我怀疑使它们可配置会导致一些非常糟糕的选择，并可能导致严重的服务器侮辱。曾几何时（使用  NTPv1），一个错误导致一些服务器以网络允许的速度连续凌空抽射。只有在网络监控中心报告NTP是Internet中最大的单一流量来源后，才发现该漏洞。

The issues of whether and how to step the clock have been debated more or  less continuously for the twenty years of NTP evolution. One clique  believes the clock should never be set backward under any circumstances. Their punishment is to suffer up to some hours while the clock torques  to acceptable offset at half a millisecond per second, which is the  maximum rate most kernels can tolerate and the limiting assumption which is at the very heart of the formal correctness principles supported by  the design. During the torque interval network clocks cannot be assumed  synchronized, so network makes, archiving, etc., can fail, even if local applications may survive. The `-g` option was designed to behave this way, but its use is not recommended.
在NTP发展的二十年中，是否以及如何步调时钟的问题或多或少地一直在争论。一个集团认为，在任何情况下都不应该倒退。他们的惩罚是遭受长达几个小时的痛苦，而时钟以每秒半毫秒的速度扭矩到可接受的偏移量，这是大多数内核可以容忍的最大速率，也是设计支持的形式正确性原则的核心。在转矩间隔期间，网络时钟不能假设是同步的，因此即使本地应用程序可以生存，网络制作、存档等也可能失败。该 `-g` 选项设计为以这种方式运行，但不建议使用它。

A complicating fact is that, once an error greater than 125 ms is  discovered, the question is whether to believe it. Our experience with  radio clocks is that it may take several minutes or more to obtain  initial synchronization. This and the fact that very noisy paths to some remote spots on the globe can result in huge spikes from time to time  suggest that the clock should not be stepped until a consistent offset  has been observed for a sanity interval, currently 15 minutes.  Considerable experience suggests this is a good compromise time, but  your agenda might be better served using some other value. What should  it be?
一个复杂的事实是，一旦发现大于 125  毫秒的错误，问题就是是否相信它。我们对无线电时钟的经验是，可能需要几分钟或更长时间才能获得初始同步。这一点以及通往地球上一些偏远地点的非常嘈杂的路径不时导致巨大峰值的事实表明，在观察到一个理智间隔（目前为 15  分钟）的一致偏移之前，不应步进时钟。相当多的经验表明，这是一个很好的折衷时机，但使用其他一些价值可能会更好地服务于您的议程。它应该是什么？

In the vast majority of cases, once the clock is reliably set and the  frequency stabilizes, the clock does not need to be stepped again, even  after reboot and sometimes even when the power is cycled. The current  NTP behavior is to step the clock if necessary when `ntpd` is started and the clock has never been set, then to obey the `-g` option after that. This was done as the result of suggestions made some time back.
在绝大多数情况下，一旦时钟可靠设置并且频率稳定，时钟就不需要再次步进，即使在重新启动后，有时甚至在电源循环时也是如此。当前的 NTP 行为是在启动且从未设置时钟时，如有必要 `ntpd` ，则步进时钟，然后遵循该 `-g` 选项。这是根据前段时间提出的建议而完成的。

Obviously, keeping most folks happy with any one set of rules may not be  acceptable by other folks. The intent feverishly pursued is to avoid  configured little nits in favor of an adaptive approach where the daemon figures things out on its own and without configured appeasement. It  may be possible to satisfy more that some folks crave by continued  enhancement and re-engineering of intricate behavior, but the above  ground rules must be respected.(…)
显然，让大多数人对任何一套规则感到满意可能是其他人无法接受的。狂热追求的意图是避免配置的小虱子，转而采用自适应方法，在这种方法中，守护进程会自行解决问题，而无需配置绥靖。通过不断增强和重新设计复杂的行为，也许可以满足一些人渴望的更多，但必须遵守上述基本规则。(…)

To avoid a biased impression, lets quote [Per Hedeland](mailto:per@erix.ericsson.se) as well:
为了避免有偏见的印象，让我们也引用 Per Hedeland 的话：

99.9999% of NTP users don’t care one iota whether `ntpdate` does such a lousy job that the clock ends up just within 50 ms of the  correct time instead of 5 or 0.005. On the other hand they care a lot if the boot has to be delayed - for how long? 5 x 64 seconds? - just to  allow `ntpd` to get a good enough fix that it is prepared to step the clock. And  they care a lot, though they may not know it, if various applications  (which may be many more than “some database servers”) run into problems  because the clock is stepped after they’ve started instead of before.
99.9999% 的 NTP 用户并不关心是否 `ntpdate` 做得如此糟糕，以至于时钟最终只在正确时间的 50 毫秒内，而不是 5 或 0.005。另一方面，他们非常关心启动是否必须延迟 - 多长时间？5 x 64 秒？- 只是为了得到 `ntpd` 一个足够好的修复，它已经准备好步进时钟。他们非常关心，尽管他们可能不知道，如果各种应用程序（可能比“某些数据库服务器”多得多）遇到问题，因为时钟是在它们启动之后而不是之前步进的。

------

#### 6.1.2 Recommended Minimum 6.1.2 建议的最小值

#### 6.1.2.1 What is the minimum configuration? 6.1.2.1 最低配置是多少？

The minimum configuration for `ntpd` only needs one reference clock. Reference clocks use *pseudo IP addresses* in `ntpd`. Thus your configuration file could look like this:
最低 `ntpd` 配置只需要一个参考时钟。参考时钟在 中使用伪 `ntpd` IP 地址。因此，您的配置文件可能如下所示：

```
server 127.127.8.0 mode 5	# GENERIC DCF77 AM
```

> **Note:** Some reference clock drivers require special device files to be  created. These files are used to talk to the reference clock. See the [corresponding documentation of the driver](https://www.ntp.org/documentation/4.2.8-series/refclock/#list-of-reference-clock-drivers).
> 注意：某些参考时钟驱动程序需要创建特殊的器件文件。这些文件用于与参考时钟通信。请参阅驱动程序的相应文档。

In reality one would add several other configuration items, such as a [drift file](https://www.ntp.org/ntpfaq/ntp-s-config/#6124-what-is-a-drift-file), additional servers, remote monitoring and configuration, logging, and access restrictions.
实际上，人们会添加其他几个配置项，例如漂移文件、其他服务器、远程监控和配置、日志记录和访问限制。

------

#### 6.1.2.2 Is the minimum configuration a typical one? 6.1.2.2 最低配置是典型的配置吗？

Besides being functional, real configurations differ from the one shown in the [minimum configuration example](https://www.ntp.org/ntpfaq/ntp-s-config/#6121-what-is-the-minimum-configuration). Most NTP servers have no reference clocks, but use lower [stratum](https://www.ntp.org/ntpfaq/ntp-s-algo/#5141-what-is-the-stratum) servers as time references. Public time servers can be found [here](https://support.ntp.org/Servers). [Courtesy](https://www.ntp.org/ntpfaq/ntp-s-config/#6151-what-is-the-preferred-etiquette-when-synchronizing-to-a-public-server) suggests to inform the maintainers of the time server that you are  using their service. As an advantage, they might inform you if their  service is going to be down. There is almost no difference in the  configuration:
除了功能之外，实际配置与最小配置示例中显示的配置不同。大多数 NTP  服务器没有参考时钟，但使用较低层的服务器作为时间参考。公共时间服务器可以在这里找到。礼貌建议通知时间服务器的维护者您正在使用他们的服务。作为一个优势，他们可能会通知您他们的服务是否会关闭。配置几乎没有区别：

```
server 132.199.176.10	# some NTP server's IP address
# You might add the EMail address of the contact person
```

[Configuring multiple servers](https://www.ntp.org/ntpfaq/ntp-s-algo-real/#532-why-should-i-have-more-than-one-clock) improves the quality of the time as it allows NTP to select the best time sources from a set of available ones.
配置多个服务器可以提高时间质量，因为它允许 NTP 从一组可用时间源中选择最佳时间源。

------

#### 6.1.2.3 What is the correct Pseudo IP Address for my reference clock? 6.1.2.3 参考时钟的正确伪IP地址是多少？

The various drivers for reference clocks are selected using IPv4 adresses  which consist of four bytes that are separated by a dot. The individual  bytes are: `127.127.*Clock Type.Unit Number*`.
参考时钟的各种驱动程序使用 IPv4 地址进行选择，IPv4 地址由四个字节组成，用点分隔。各个字节为： `127.127.*Clock Type.Unit Number*` 。

The supported clock types are listed [here](https://www.ntp.org/documentation/4.2.8-series/refclock/#list-of-reference-clock-drivers). Usually it does not make sense, but if you want to connect more than  one clock of a type, you can do so by using different unit numbers. The  driver maps these unit numbers to one or more device files. The exact  name of the device file can be found in the description of the  individual reference clock’s driver.
此处列出了支持的时钟类型。通常这没有意义，但是如果要连接一种类型的多个时钟，则可以使用不同的单元号来实现。驱动程序将这些单元号映射到一个或多个设备文件。器件文件的确切名称可在各个参考时钟驱动器的描述中找到。

------

#### 6.1.2.4 What is a drift file? 6.1.2.4 什么是漂移文件？

When running, `ntpd` learns about the drift of the system clock relative to the reference clock. To make `ntpd` remember the drift, you must add the following item to your configuration file (it will be updated every hour):
运行时， `ntpd` 了解系统时钟相对于参考时钟的漂移。要记住 `ntpd` 漂移，您必须将以下项目添加到您的配置文件中（它将每小时更新一次）：

```
driftfile /etc/ntp.drift        # remember the drift of the local clock
```

When using a drift file, `ntpd` will use the last written value as initial frequency correction after  restart. That way the best correction is set up much faster Without a  drift file the initial frequency correction is always zero.
使用漂移文件时， `ntpd` 将使用最后一个写入值作为重新启动后的初始频率校正。这样，最佳校正的设置速度要快得多：如果没有漂移文件，初始频率校正始终为零。

[Mark Martinec](mailto:mark.martinec@ijs.si) contributed:
Mark Martinec 做出了贡献：

On a Cisco router running IOS one can save the current frequency offset estimate to a nonvolatile memory with `copy running-config startup-config`, to make sure router starts up with a good frequency estimate after a  reset. Do that manually after a day or two of a stable router operation  with its NTP synchronized, and perhaps a few more times per year during  seasons changes if router is operating in non-air-conditioned  environment. This operation saves the current frequency estimate as a  configuration line `ntp clock-period *xxxx*`.
在运行IOS的Cisco路由器上，可以使用 将当前频率偏移估计值保存到非 `copy running-config startup-config` 易失性存储器中，以确保路由器在复位后以良好的频率估计值启动。在路由器稳定运行一两天并同步其 NTP 后手动执行此操作，如果路由器在非空调环境中运行，则在季节变化期间每年可能再执行几次。此操作将当前频率估计值保存为配置行 `ntp clock-period *xxxx*` 。

------

#### 6.1.2.5 Should I use IP addresses or host names? 6.1.2.5 我应该使用 IP 地址还是主机名？

During startup `ntpd` resolves symbolic addresses to numeric addresses using the resolver  service. However there are some differences worth considering:
在启动 `ntpd` 期间，使用解析器服务将符号地址解析为数字地址。但是，有一些差异值得考虑：

- If a symbolic name has multiple IP addresses, you may wish to explicitly select one.
  如果一个符号名称具有多个 IP 地址，您可能希望显式选择一个。
- Using numeric addresses does not require a correct configuration of a  resolver, and it may avoid making a connection to the Internet.
  使用数字地址不需要正确配置解析器，并且可以避免与 Internet 建立连接。
- Many service providers use *aliases* or *logical host names* when providing services. When using names like `ntp-1-a` for an NTP server, the service provider may map the logical name to a  different machine, possibly without informing any clients. So if you use host names in your configuration file, you have to restart or [reconfigure](https://www.ntp.org/ntpfaq/ntp-s-config/#6144-how-do-i-use-authentication-keys) `ntpd`.
  许多服务提供商在提供服务时使用别名或逻辑主机名。当使用类似 `ntp-1-a` NTP 服务器的名称时，服务提供商可能会将逻辑名称映射到其他计算机，可能不通知任何客户端。因此，如果在配置文件中使用主机名，则必须重新启动或重新配置 `ntpd` 。

------

#### 6.1.3 Running an isolated Network 6.1.3 运行隔离网络

If you are not permanently connected to the Internet, you may need a different configuration. This is discussed here.
如果您没有永久连接到 Internet，则可能需要其他配置。本文将对此进行讨论。

#### 6.1.3.1 Can I use my system clock as reference clock? 6.1.3.1 我可以使用我的系统时钟作为参考时钟吗？

In short: you can, [but you should not](https://www.ntp.org/ntpfaq/ntp-s-refclk/#711-what-is-lcl-the-local-clock).
简而言之：你可以，但你不应该。

> **Warning**: Using the free-running system clock means that your NTP server  announces that time as reference time to any client, no matter how wrong it is. Especially when connected to the Internet this can cause severe  confusion.
> 警告：使用自由运行的系统时钟意味着您的 NTP 服务器将该时间宣布为任何客户端的参考时间，无论它有多错误。特别是当连接到互联网时，这可能会导致严重的混乱。

A [survey](https://www.ntp.org/reflib/reports/ntp-survey99-minar.pdf) discovered that about 95% of bad stratum-1 servers had configured `LCL`, the local clock, as time reference. So please don’t make the same mistake!
一项调查发现，大约 95% 的坏 stratum-1 服务器配置 `LCL` 了本地时钟作为时间参考。所以请不要犯同样的错误！

------

#### 6.1.3.2 Can I avoid manual time adjustments in a network without reference clock? 6.1.3.2 在没有参考时钟的网络中，我是否可以避免手动调整时间？

If you have a MODEM and you can afford the telephone costs, you can use the following configuration to call NIST (thanks to [William R. Pennock](mailto:bill.pennock@transquest.com)):
如果您有调制解调器并且您能负担得起电话费用，则可以使用以下配置呼叫 NIST（感谢 William R. Pennock）：

```
# NIST Automated Computer Time Service. This driver calls a special
# telephone number in Boulder, CO, to fetch the time directly from the
# NIST cesium farm. The details of the complicated calling program are
# in html/refclock.htm. The Practical Peripherals 9600SA modem
# does not work correctly with the ACTS echo-delay scheme for
# automatically calculating the propagation delay, so the fudge flag2 is
# set to disable the feature. Instead, we add a fudge time1 of 65.0 ms
# so that the driver time agrees with th e1-pps signal to within 1 ms.
# The phone command specifies three alternate telephone numbers,   
# including AT modem command prefix, which will be tried one after the
# other at each measurement attempt. In this case, a cron job is used to
# set fudge flag1, causing a measurement attempt, every six hours.
server 127.127.18.1
fudge 127.127.18.1 time1 0.0650 flag2 1
phone atdt813034944774 atdt813034944785 atdt813034944774
```

------

### 6.1.4 Recommended Goodies 6.1.4 推荐的好东西

The topics discussed here are not strictly needed for a working configuration, but they are quite nice to have.
这里讨论的主题对于工作配置来说并不是严格需要的，但它们非常好。

------

#### 6.1.4.1 How can I configure the amount of logging information? 6.1.4.1 如何配置日志记录信息量？

When starting to run `ntpd` you should have a more verbose logging than set up by default. You might start with the following line:
开始运行 `ntpd` 时，您应该有一个比默认设置的更详细的日志记录。您可以从以下行开始：

```
logconfig =syncevents +peerevents +sysevents +allclock
```

Or, you might enable full logging to ensure`/etc/syslog.conf` captures all messages:
或者，您可以启用完整日志记录以确保 `/etc/syslog.conf` 捕获所有消息：

```
logconfig =all
```

------

#### 6.1.4.2 How can I speed up initial Synchronization? 6.1.4.2 如何加快初始同步速度？

[Several packet exchanges are needed](https://www.ntp.org/ntpfaq/ntp-s-algo/#5121-how-is-time-synchronized) before time can be corrected. Therefore the obvious trick is to speed up packet exchanges. See [Q: 5.1.2.4.](https://www.ntp.org/ntpfaq/ntp-s-algo/#5124-when-are-the-servers-polled) for a general discussion of the polling algorithm. The `iburst` keyword can be used to quickly set up the registers of the receive  filter when they are empty. Typically this is true for a restart, or  when the connection to a server was down for a longer period. When used, the data should be available within 30 seconds.
在纠正时间之前，需要多次数据包交换。因此，显而易见的诀窍是加快数据包交换。见问：5.1.2.4。对轮询算法进行一般性讨论。该 `iburst` 关键字可用于在接收滤波器为空时快速设置寄存器。通常，重新启动或与服务器的连接中断较长时间时，情况确实如此。使用时，数据应在 30 秒内可用。

If the local clock does not have a good estimate for the current time, using option `-g` on the command line may also speed up the time until `ntpd` sets the clock for the first time. Furthermore that option will also allow suspiciously huge initial correction.
如果本地时钟对当前时间没有很好的估计，则使用命令行上的选项 `-g` 也可能会加快时间，直到 `ntpd` 首次设置时钟。此外，该选项还将允许可疑的巨大初始修正。

These modifications are intended as a replacement for `ntpdate` in NTPv4. A script named `ntp-wait` will wait until `ntpd` has set the time of the local host for the first time.
这些修改旨在替代 NTPv4 `ntpdate` 中的内容。名为 `ntp-wait` 的脚本将等待，直到 `ntpd` 首次设置本地主机的时间。

------

#### 6.1.4.3 How do I configure remote administration? 6.1.4.3 如何配置远程管理？

One of the nice features of NTP is remote monitoring and configuration. You can add or remove reference clocks at runtime without having to restart `ntpd`. Normally this doesn’t work until you specify authentication  information. Authentication in NTP works with keys. First your  configuration needs to specify the location of the keys file and key IDs of the keys to use:
NTP 的一个很好的功能是远程监控和配置。您可以在运行时添加或删除参考时钟 `ntpd` ，而无需重新启动。通常，在指定身份验证信息之前，这不起作用。NTP 中的身份验证使用密钥。首先，您的配置需要指定密钥文件的位置以及要使用的密钥的密钥 ID：

```
### Authentication section ###
keys /etc/ntp.keys
trustedkey 1 2 15
requestkey 15
controlkey 15
```

This tells `ntpd` to trust keys `1` and `2` when receiving time information. Key `15` is trusted for queries and configuration changes (`requestkey` is used by `ntpdc` while `controlkey` is used by `ntpq`).
这告诉 `ntpd` 信任密钥 `1` 和 `2` 接收时间信息时。密钥 `15` 受信任，用于查询和配置更改 `ntpq` （ `requestkey` 由 `ntpdc` 使用 ，而 `controlkey` 由 使用 ）。

> **Note:** Even though `controlkey` and `requestkey` are explicitly specified, you still must add the key IDs to `trustedkey`.
> 注： 即使 `controlkey` 显式指定了 和 `requestkey` ，您仍必须将 `trustedkey` 密钥 ID 添加到 。

By default, the keys themselves are configured in the file `/etc/ntp.keys`. Since `ntpd` runs as a priviledged process, only the priviledged user (root) needs access to this file.
默认情况下，密钥本身在文件中 `/etc/ntp.keys` 配置。由于 `ntpd` 作为特权进程运行，因此只有特权用户（root）需要访问此文件。

> **Note:** Password are stored unencrypted in the keyfile. Therefore no other user should have read or write access to that file or write access to its  directory.
> 注意：密码以未加密的方式存储在密钥文件中。因此，任何其他用户都不应具有对该文件的读写访问权限或对其目录的写入访问权限。

[Cryptographic Data Files](https://www.ntp.org/documentation/4.2.8-series/keygen/#cryptographic-data-files) provides an example for `/etc/ntp.keys` and explains the meaning of each column in the file.
加密数据文件提供了文件中 `/etc/ntp.keys` 每一列的示例并解释了其含义。

------

#### 6.1.4.4 How do I use authentication keys? 6.1.4.4 如何使用身份验证密钥？

NTP provides *dynamic reconfiguration*, meaning you can change the configuration of your servers using the protocol itself and the `ntpq` command. As this works over the network, there’s no need to log in or  to walk around. Even more, it works the same on all operating systems.
NTP 提供动态重新配置，这意味着您可以使用协议本身和 `ntpq` 命令更改服务器的配置。由于这可以通过网络工作，因此无需登录或四处走动。更重要的是，它在所有操作系统上的工作方式都是一样的。

To prevent everybody from changing the configuration of an NTP server,  configuration items are protected by an authentication algorithm.
为了防止每个人都更改 NTP 服务器的配置，配置项目受身份验证算法保护。

------

#### 6.1.4.5 What are all the different Keys used for? 6.1.4.5 所有不同的密钥是用来做什么的？

In addition to the example given in [Q: 6.1.4.3](https://www.ntp.org/ntpfaq/ntp-s-config/#6143-how-do-i-configure-remote-administration), [Professor David L. Mills](https://www.nwtime.org/tribute-to-david-l-mills/) states:
除了Q：6.1.4.3中给出的例子外，David L. Mills教授还指出：

Control keys are for the `ntpq` program and request keys are for the `ntpdc` program. The key file(s) define the cryptographic keys, but these must be activated individually using the `trustedkey` command. That last is so a single key file can be shared among a bunch  of servers, but only certain ones used between pairwise symmetric mode  servers. You are invited to cut this paragraph and paste it on the  refrigerator door if it eases confusion.
控制键用于程序， `ntpq` 请求键用于 `ntpdc` 程序。密钥文件定义加密密钥，但必须使用命令 `trustedkey` 单独激活这些密钥。最后一种情况是，单个密钥文件可以在一堆服务器之间共享，但只能在成对对称模式服务器之间使用某些密钥文件。如果可以缓解混淆，请您剪下这一段并将其粘贴在冰箱门上。

------

#### 6.1.4.6 How do I use autokey? 6.1.4.6 如何使用自动密钥？

NTPv4 manages authentication keys using the autokey mechanism. The following procedure had been given by [Professor David L. Mills](https://www.nwtime.org/tribute-to-david-l-mills/):
NTPv4 使用自动密钥机制管理身份验证密钥。David L. Mills教授给出了以下程序：

1. A broadcast server needs to have a line like `broadcast 128.4.2.255 autokey`.
   广播服务器需要有类似 `broadcast 128.4.2.255 autokey` 的行。
2. The clients simply have `broadcastclient`.
   客户只是有 `broadcastclient` .

Replace `broadcast` with `multicast` and follow `autokey` with `ttl 5` or something like that. As for the crypto questions, refer to [Autonomous Authentication](https://www.ntp.org/reflib/autokey/) and  [Q: 6.2.2.6.](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6226-how-do-i-use-public-key-authentication-autokey).
替换 `broadcast` 为 `multicast` 并跟随 `autokey` 或 `ttl 5` 类似的东西。至于加密问题，请参阅自主身份验证和Q：6.2.2.6.。

------

#### 6.1.5 Miscellaneous Hints 6.1.5 其他提示

#### 6.1.5.1 What is the preferred etiquette when synchronizing to a public server? 6.1.5.1 同步到公共服务器时的首选礼仪是什么？

If the [listing](https://support.ntp.org/Servers) says to notify before before using a server, then you should send email and wait until you get an affirmative reply before using that server.
如果列表显示在使用服务器之前通知，那么您应该发送电子邮件并等到收到肯定的回复后再使用该服务器。

Some public timeservers are listed as [OpenAccess](https://support.ntp.org/Servers/OpenAccess) with no notice required.
一些公共时间服务器被列为 OpenAccess，无需通知。

You should probably have no more than three of your timeservers using any  individual public timeserver. Let all of your internal clients be served by those three or three-groups-of-three.
使用任何单独的公共时间服务器的时间服务器可能不超过三个。让所有内部客户都由这三个或三个小组提供服务。

The most popular time servers are overloaded, recommending that you should  avoid them if possible. The official etiquette is described in [Rules of Engagement](https://support.ntp.org/Servers/RulesOfEngagement).
最流行的时间服务器过载，建议您尽可能避免使用它们。官方礼仪在交战规则中有所描述。

------

#### 6.1.5.2 Where can I find public Time Servers? 6.1.5.2 在哪里可以找到公共时间服务器？

Additionally, NIST (the United States National Instute of Standards and Technology) has a [list of public time servers](https://tf.nist.gov/tf-cgi/servers.cgi). Their policy statement implies that their Internet time servers are open access to everyone.
此外，NIST（美国国家标准与技术研究所）有一个公共时间服务器列表。他们的政策声明意味着他们的互联网时间服务器对所有人开放访问。

# 6.2. Advanced Configuration 6.2. 高级配置

Last update: April 3, 2024 16:42 UTC ([f170361b7](https://git.nwtime.org/websites/ntpwww/commit/f170361b72193f7af81935c6c0a4afda96793f0d))
最后更新： 2024年4月3日 16：42 UTC （ f170361b7）

This section discusses advanced configuration options that are probably not  needed for the average user. If you want to provide time service to a  larger community, consider some of these topics.
本节讨论普通用户可能不需要的高级配置选项。如果您想为更大的社区提供时间服务，请考虑其中一些主题。

6.2.1 [Server Selection](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#621-server-selection) 6.2.1 服务器选择
 6.2.1.1 [What is the rule of thumb for number of servers to synchronize to?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6211-what-is-the-rule-of-thumb-for-number-of-servers-to-synchronize-to)
6.2.1.1 要同步到的服务器数量的经验法则是什么？
 6.2.1.2 [Should the servers be a mix of primary and secondary servers?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6212-should-the-servers-be-a-mix-of-primary-and-secondary-servers)
6.2.1.2 服务器是否应该混合使用主服务器和辅助服务器？
 6.2.1.3 [How should I provide NTP services for a huge network?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6213-how-should-i-provide-ntp-services-for-a-huge-network)
6.2.1.3 如何为庞大的网络提供NTP服务？
 6.2.2 [Authentication](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#622-authentication) 6.2.2 身份验证
 6.2.2.1 [Why Authentication?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6221-why-authentication)
6.2.2.1 为什么要进行身份验证？
 6.2.2.2 [How is Authentication applied?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6222-how-is-authentication-applied)
6.2.2.2 如何应用身份验证？
 6.2.2.3 [How do I create a key?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6223-how-do-i-create-a-key)
6.2.2.3 如何创建密钥？
 6.2.2.4 [How does Authentication work?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6224-how-does-authentication-work)
6.2.2.4 身份验证如何工作？
 6.2.2.5 [Can I add Authentication without restarting ntpd?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6225-can-i-add-authentication-without-restarting-ntpd)
6.2.2.5 是否可以在不重新启动 ntpd 的情况下添加身份验证？
 6.2.2.6 [How do I use Public-Key Authentication (autokey)?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6226-how-do-i-use-public-key-authentication-autokey)
6.2.2.6 如何使用公钥身份验证（自动密钥）？
 6.2.3 [Broadcasting, Multicasting, and Manycasting](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#623-broadcasting-multicasting-and-manycasting)
6.2.3 广播、组播和组播
 6.2.3.1 [How do I configure a Broadcast Server?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6231-how-do-i-configure-a-broadcast-server)
6.2.3.1 如何配置广播服务器？
 6.2.3.2 [How do I configure a Broadcast Client?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6232-how-do-i-configure-a-broadcast-client)
6.2.3.2 如何配置广播客户端？
 6.2.3.3 [Why doesn’t Broadcasting work with LCL?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6233-why-doesnt-broadcasting-work-with-lcl)
6.2.3.3 为什么 Broadcasting 不能与 LCL 一起使用？
 6.2.3.4 [How do I configure Multicast Servers and Clients?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6234-how-do-i-configure-multicast-servers-and-clients)
6.2.3.4 如何配置组播服务器和客户端？ 
 6.2.3.5 [What is Manycasting?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6235-what-is-manycasting)
6.2.3.5 什么是Manycasting？
 6.2.4. [PPS Synchronization](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#624-pps-synchronization)
6.2.4. PPS同步 
 6.2.4.1 [Which components are required to use PPS synchronization?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6241-which-components-are-required-to-use-pps-synchronization)
6.2.4.1 PPS同步需要哪些组件？
 6.2.4.2 [What changes are required in ntp.conf?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6242-what-changes-are-required-in-ntpconf)
6.2.4.2 ntp.conf 需要哪些更改？
 6.2.4.3 [How do I verify that everything is working?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6243-how-do-i-verify-that-everything-is-working)
6.2.4.3 如何验证一切正常？
 6.2.4.4 [Special Drivers](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6244-special-drivers) 6.2.4.4 特殊驱动程序
 6.2.4.4.1 [What is a PPS peer?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#62441-what-is-a-pps-peer)
6.2.4.4.1 什么是PPS对等体？
 6.2.4.4.2 [How do I use PPS with the Motorola Oncore driver?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#62442-how-do-i-use-pps-with-the-motorola-oncore-driver)
6.2.4.4.2 如何将 PPS 与 Motorola Oncore 驱动程序配合使用？
 6.2.4.4.3 [How do I use PPS with the NMEA driver?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#62443-how-do-i-use-pps-with-the-nmea-driver)
6.2.4.4.3 如何在 NMEA 驱动程序中使用 PPS？
 6.2.4.5 [What is the PPS API?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6245-what-is-the-pps-api)
6.2.4.5 什么是 PPS API？
 6.2.4.6 [What is the shortest Width for a Pulse connected to the DCD Pin of an RS-232 Interface?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6246-what-is-the-shortest-width-for-a-pulse-connected-to-the-dcd-pin-of-an-rs-232-interface)
6.2.4.6 连接到RS-232接口DCD引脚的脉冲的最短宽度是多少？
 6.2.5 [Automatic Configuration](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#625-automatic-configuration)
6.2.5 自动配置
 6.2.5.1 [How can I define the address of an NTP server in a BOOTP reply?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6251-how-can-i-define-the-address-of-an-ntp-server-in-a-bootp-reply)
6.2.5.1 如何在BOOTP应答中定义NTP服务器的地址？
 6.2.5.2 [How do I use information about NTP servers given in a BOOTP reply?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6252-how-do-i-use-information-about-ntp-servers-given-in-a-bootp-reply)
6.2.5.2 如何使用 BOOTP 回复中提供的有关 NTP 服务器的信息？
 6.2.6 [Offering Time Service](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#626-offering-time-service)
6.2.6 提供时间服务
 6.2.6.1 [Is there any way to configure ntpd to attach to a specific Interface?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6261-is-there-any-way-to-configure-ntpd-to-attach-to-a-specific-interface)
6.2.6.1 有没有办法将 ntpd 配置为附加到特定接口？
 6.2.6.2 [Should Access be restricted?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6262-should-access-be-restricted)
6.2.6.2 访问是否应该受到限制？
 6.2.6.3 [What should be done before announcing public NTP service?](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6263-what-should-be-done-before-announcing-public-ntp-service)
6.2.6.3 在宣布公共NTP服务之前应该做什么？

------

#### 6.2.1. Server Selection 6.2.1. 服务器选择

#### 6.2.1.1. What is the rule of thumb for number of servers to synchronize to? 6.2.1.1. 要同步到的服务器数量的经验法则是什么？

It is entirely up to you and your tolerance for outages. Obviously you  have some tolerance, or you would be buying GPS receivers and installing your own stratum-1 servers. But three is a good place to start, and you can progress to three-groups-of-three if you feel the need. Remember  that network outages are at least as likely as timeserver outages. If  you only have one network path to the outside world, adding a more  timeservers doesn’t really improve reliability as your ISP is the  single-point-of-failure.
这完全取决于您和您对中断的容忍度。显然你有一定的容忍度，否则你会购买GPS接收器并安装自己的stratum-1服务器。但是三人组是一个很好的起点，如果你觉得有必要，你可以发展到三人一组。请记住，网络中断的可能性至少与时间服务器中断的可能性相同。如果您只有一条通往外界的网络路径，那么添加更多的时间服务器并不能真正提高可靠性，因为您的 ISP 是单点故障。

------

#### 6.2.1.2. Should the servers be a mix of primary and secondary servers? 6.2.1.2. 服务器是否应该混合使用主服务器和辅助服务器？

Probably not. The secondaries are good enough for almost everybody. If you care  about the small differences in accuracy/precision between the primaries  and the secondaries (and you must be close enough, topology-wise, to  even *see* the difference) then you should buy some GPS receivers.
可能不是。中学对几乎所有人来说都足够好。如果您关心初级和辅助之间的精度/精度的微小差异（并且您必须足够接近，拓扑方面，甚至可以看到差异），那么您应该购买一些 GPS 接收器。

------

#### 6.2.1.3. How should I provide NTP services for a huge network? 6.2.1.3. 如何为庞大的网络提供NTP服务？

For a huge network you should provide enough redundancy while avoiding a  single point of failure. The following discussion will be based on  Figure 6.2a, a configuration that is frequently recommended. I’m not  saying it’s the only possible configuration, but let’s just have a  closer look.
对于庞大的网络，您应该提供足够的冗余，同时避免单点故障。下面的讨论将基于图 6.2a，这是经常推荐的配置。我并不是说这是唯一可能的配置，但让我们仔细看看。

**Figure 6.2a: Configuration for a huge Network
图 6.2a.. 大型网络的配置**

```
 1a  1b     1c  1d     1e  1f      outside
. \ / ...... \ / ...... \ / ..............
   2a ---p--- 2b ---p--- 2c        inside
  /|\        /|\        /|\
 / | \      / | \      / | \
3a 3b 3c   3e 3f 3g   3h 3i 3j

Key: 1 = stratum-1, 2 = stratum-2, 3 = stratum-3, p = peer
```

The example configuration uses six stratum-1 servers (`1a` … `1f`) to synchronize three stratum-2 servers (`2a` … `2c`). All servers at stratum two are peers to each other. Each of these  stratum-2 servers serve three stratum-3 servers. Clients will be using  the servers at stratum three.
示例配置使用六个 stratum-1 服务器 （ `1a` ... `1f` ） 同步三个 Stratum-2 服务器 （ `2a` ... `2c` ）。第二层的所有服务器都是彼此的对等体。这些 Stratum-2 服务器中的每一个都服务于三个 Stratum-3 服务器。客户端将使用第三层的服务器。

Having [more than one reference server configured](https://www.ntp.org/ntpfaq/ntp-s-algo-real/#532-why-should-i-have-more-than-one-clock) increases reliability and stability of the client. That is why there  are two servers for each of the stratum-2 servers. Distributing time  horizontally (peering) reduces the amount of traffic to the stratum-1  servers while giving additional redundancy for the stratum-2 servers.  The extra layer of stratum-2 servers helps to distribute the load  created by lower levels (stratum-3).
配置多个引用服务器可提高客户端的可靠性和稳定性。这就是为什么每个 stratum-2 服务器都有两台服务器的原因。水平分配时间（对等互连）可减少到 stratum-1 服务器的流量，同时为 stratum-2 服务器提供额外的冗余。stratum-2 服务器的额外层有助于分配较低级别 （stratum-3） 产生的负载。

If you have a reference clock, you would probably arrange peering with one or more stratum-1 servers. For most networks you can probably leave out the third layer (stratum-3) completely.
如果您有参考时钟，则可能会安排与一个或多个 stratum-1 服务器的对等互连。对于大多数网络，您可能可以完全省略第三层（第 3 层）。

There’s an additional comment by David Dalton:
大卫·道尔顿（David Dalton）还发表了另一条评论：

But my advice is this: if your stratum-N peers all use the same ISP to get  to the outside world, then peers are mostly pointless. Your  single-point-of-failure is the network path, not the stratum-1 machines  themselves. Building huge redundancy into your hierarchy can get very  expensive very quickly. Think hard about how much redundancy you really  need.
但我的建议是：如果你的 Stratum-N 对等方都使用相同的 ISP 来访问外部世界，那么对等方大多毫无意义。单点故障是网络路径，而不是第 1 层计算机本身。在层次结构中构建巨大的冗余会很快变得非常昂贵。仔细想想你真正需要多少冗余。

And another comment from [Mark Martinec](mailto:mark.martinec@ijs.si):
马克·马丁内克（Mark Martinec）的另一条评论：

I don’t find the Figure 6.2a a good idea. It has a big problem in that  stratum-3 servers in the picture all have a single point of failure in  their single reference stratum-2 NTP server, not to mention it throws  away all the fancy NTP algorithms.
我不认为图 6.2a 是个好主意。它有一个很大的问题，因为图片中的 stratum-3 服务器在其单参考 stratum-2 NTP 服务器中都存在单点故障，更不用说它抛弃了所有花哨的 NTP 算法。

As a fix (and to make it cleaner/leaner), one could strike out the  stratum-3 layer completely from the picture and say that each of the  company clients will use *all three* peered company stratum-2 servers as their reference.
作为修复（并使其更简洁/更精简），可以从图片中完全删除 stratum-3 层，并说每个公司客户都将使用所有三个对等的公司 stratum-2 服务器作为他们的参考。

If one really needs more fanout (doubtful), one can put back the stratum-3 layer, but with each stratum-3 server referenced to *each* of the company stratum-2 servers.
如果确实需要更多的扇出（值得怀疑），可以放回 stratum-3 层，但每个 stratum-3 服务器都引用到每个公司的 stratum-2 服务器。

------

#### 6.2.2. Authentication 6.2.2. 身份验证

#### 6.2.2.1. Why Authentication? 6.2.2.1. 为什么要进行身份验证？

Most users of NTP do not need authentication as the protocol contains  several filters against bad time. However, there is still  authentication, and its use seems to become more common. Some reasons  might be:
NTP 的大多数用户不需要身份验证，因为该协议包含多个针对不良时间的过滤器。但是，仍然有身份验证，并且它的使用似乎变得更加普遍。一些原因可能是：

- You only want to use time from trusted sources.
  您只想使用来自可信来源的时间。
- An attacker may broadcast wrong time stamps.
  攻击者可能会广播错误的时间戳。
- An attacker may disguise as another time server.
  攻击者可能伪装成其他时间服务器。

------

#### 6.2.2.2. How is Authentication applied? 6.2.2.2. 如何应用身份验证？

NTP uses keys to implement authentication. These keys are used when exchanging data between two machines. As shown in [Q: 6.1.4.3](https://www.ntp.org/ntpfaq/ntp-s-config/#6143-how-do-i-configure-remote-administration) and [Q: 6.1.4.4](https://www.ntp.org/ntpfaq/ntp-s-config/#6144-how-do-i-use-authentication-keys), one of the uses has to do with remote administration. When configuring a `server` or `peer`, an authentication key can be specified:
NTP 使用密钥来实现身份验证。在两台计算机之间交换数据时，会使用这些密钥。如 Q： 6.1.4.3 和 Q： 6.1.4.4 所示，其中一个用途与远程管理有关。配置 `server` 或 `peer` 时，可以指定身份验证密钥：

```
peer 128.100.49.105 key 22
peer 128.8.10.1     key 4
peer 192.35.82.50   key 6

# path for key file
keys /usr/local/etc/ntp.keys

trustedkey 4 6 14 15 22 # define trusted keys
requestkey 15    # key (7) for accessing server variables
controlkey 15    # key (6) for accessing server variables
```

The keyword `key` specifies the key to be used when talking to the specified server.
关键字 `key` 指定与指定服务器通信时要使用的密钥。

------

#### 6.2.2.3. How do I create a key? 6.2.2.3. 如何创建密钥？

`ntp-keygen` is used to create keys. Refer to its [documentation](https://www.ntp.org/documentation/4.2.8-series/keygen/) for a complete description and command line options.
 `ntp-keygen` 用于创建密钥。有关完整的描述和命令行选项，请参阅其文档。

[Q: 6.1.4.3](https://www.ntp.org/ntpfaq/ntp-s-config/#6143-how-do-i-configure-remote-administration) provides a remote configuration example.
问：6.1.4.3 提供了一个远程配置示例。

------

#### 6.2.2.4. How does Authentication work? 6.2.2.4. 身份验证如何工作？

Basically authentication is a digital signature, and no data encryption (if there is any difference at all). The usual data packet plus the key is used  to build a non-reversible magic number that is appended to the packet.  The receiver (having the same key) does the same computation and  compares the result. If the results match, authentication suceeded.
基本上，身份验证是一种数字签名，没有数据加密（如果有任何区别的话）。通常的数据包加上密钥用于构建附加到数据包的不可逆幻数。接收器（具有相同的密钥）执行相同的计算并比较结果。如果结果匹配，则身份验证成功。

------

#### 6.2.2.5. Can I add Authentication without restarting ntpd? 6.2.2.5. 是否可以在不重新启动 ntpd 的情况下添加身份验证？

Yes and No. You can dynamically add servers that use authentication keys, and you can trust or un-trust any key using `ntpdc`. You can also re-read the keyfile using the `readkeys` command. Unfortunately you need to configure basic authentication before using any of these commands.
是的，也不是。您可以动态添加使用身份验证密钥的服务器，并且可以使用 信任或不信任任何密钥 `ntpdc` 。您也可以使用命令 `readkeys` 重新读取密钥文件。遗憾的是，在使用任何这些命令之前，您需要配置基本身份验证。

------

#### 6.2.2.6. How do I use Public-Key Authentication (autokey)? 6.2.2.6. 如何使用公钥身份验证（自动密钥）？

Refer to the examples in [Autokey Public-Key-Authentication](https://www.ntp.org/documentation/4.2.8-series/autokey/) and [Q: 6.1.4.6](https://www.ntp.org/ntpfaq/ntp-s-config/#6146-how-do-i-use-autokey).
请参阅 Autokey Public-Key-Authentication 和 Q： 6.1.4.6 中的示例。

The following example includes [advice](https://support.ntp.org/Support/ConfiguringAutokeyDev) from [Professor David L. Mills](https://www.nwtime.org/tribute-to-david-l-mills/):
以下示例包括 David L. Mills 教授的建议：

> Ensure you have a working NTP configuration before configuring Autokey!
> 在配置 Autokey 之前，请确保您具有有效的 NTP 配置！

**Configure NTP Servers 配置 NTP 服务器**

1. Generate a trusted certificate for each group member using `ntp-keygen -T` as described in [Configuration - Authentication Schemes](https://www.ntp.org/documentation/4.2.8-series/autokey/#configuration---authentication-schemes).
   使用 `ntp-keygen -T` 配置 - 身份验证方案中所述为每个组成员生成受信任的证书。
2. Make the group keys with the `-I` option on a trusted host or trusted agent.
   使用受信任主机或受信任代理上的 `-I` 选项创建组密钥。
3. Make the client keys from the group keys and distribute to the clients. Use  an arbitrary file name, preferably the name of the group.
   从组密钥创建客户端密钥并分发给客户端。使用任意文件名，最好是组的名称。

**Configure NTP Clients 配置 NTP 客户端**

1. Create a directory for the client’s NTP keys (e.g. `/etc/ntp`). That directory should only be readable by root.
   为客户端的 NTP 密钥创建目录（例如 `/etc/ntp` ）。该目录只能由 root 读取。
2. In each client’s `/etc/ntp.conf` file, append `autokey` to the `server` entry. Then append the `ident` option to the client’s `server` entry with the same name as the installed client keys.
   在每个客户端 `/etc/ntp.conf` 的文件中，追加 `autokey` 到 `server` 条目。然后，使用与已安装的客户端密钥同名的选项将 `ident` 该选项附加到客户端 `server` 的条目中。
3. For broadcast clients, use the `ident` option in the `crypto` command instead.
   对于广播客户端，请改用 `crypto` 命令中的 `ident` 选项。

------

#### 6.2.3. Broadcasting, Multicasting, and Manycasting 6.2.3. 广播、组播和组播

With broadcasting and multicasting several clients can be addressed with a single packet transmitted by the server.
通过广播和组播，可以使用服务器传输的单个数据包对多个客户端进行寻址。

------

#### 6.2.3.1. How do I configure a Broadcast Server? 6.2.3.1. 如何配置广播服务器？

A line like `broadcast 128.4.2.255` enables periodic sending of broadcast packets containing the current  time as long as the server’s clock is synchronized. The period may be  influenced by the `minpoll` option. Packet forwarding can be limited by specifying the `ttl` option. Make sure you are using the correct broadcast address for your subnet.
只要服务器的时钟同步，像这样的 `broadcast 128.4.2.255` 线路就可以定期发送包含当前时间的广播数据包。该周期可能会受到 `minpoll` 期权的影响。可以通过指定 `ttl` 选项来限制数据包转发。请确保为子网使用正确的广播地址。

------

#### 6.2.3.2 How do I configure a Broadcast Client? 6.2.3.2 如何配置广播客户端？

Using the line `broadcastclient` will enable listening to broadcasts. As anybody can send out any  broadcasts, use of authentication is strongly advised. In NTPv4 the  client will actively query a broadcasting server to calibrate the delay. More details can be found in [Association Management](https://www.ntp.org/documentation/4.2.8-series/assoc/#broadcastmulticast-modes).
使用该线路 `broadcastclient` 将启用收听广播。由于任何人都可以发送任何广播，因此强烈建议使用身份验证。在 NTPv4 中，客户端将主动查询广播服务器以校准延迟。更多详细信息可以在协会管理中找到。

------

#### 6.2.3.3 Why doesn’t Broadcasting work with LCL? 6.2.3.3 为什么 Broadcasting 不能与 LCL 一起使用？

Before continuing, make sure you read and understood [Q: 7.1.1](https://www.ntp.org/ntpfaq/ntp-s-refclk/#711-what-is-lcl-the-local-clock) and [Q: 6.1.3.1.](https://www.ntp.org/ntpfaq/ntp-s-config/#6131-can-i-use-my-system-clock-as-reference-clock). As you shouldn’t broadcast bad time, a `prefer` keyword is required when using `LCL`.
在继续之前，请确保您已阅读并理解 Q： 7.1.1 和 Q： 6.1.3.1.。由于您不应该广播糟糕的时间， `prefer` 因此在使用 `LCL` .

------

#### 6.2.3.4 How do I configure Multicast Servers and Clients? 6.2.3.4 如何配置组播服务器和客户端？

Multicasting is configured just like broadcasting, but instead of using a broadcast address, a *multicast group address* (class D) is used.
组播的配置与广播类似，但不使用广播地址，而是使用组播组地址（D 类）。

------

#### 6.2.3.5 What is Manycasting? 6.2.3.5 什么是Manycasting？

This is an explanation by [Professor David L. Mills](https://www.nwtime.org/tribute-to-david-l-mills/): “Manycast only works in multicast mode. It uses an expanding-ring  search by adjusting the TTL field. This doesn’t make sense in broadcast  mode, since broadcast packets do not span subnets. It might in fact be  useful to implement manycast in broadcast mode without the search, but  that is rather far down the to-do list.” (…) “Only the `*` and `+` tattletales indicate a candidate survivor. Note that one of your  servers is in process of going away, another coming onboard. This is a  normal situation when first coming up and when the signatures are  refreshed once per day. I assume you are using autokey; if not, no  promises at all.”
这是David L. Mills教授的解释：“Manycast只能在组播模式下工作。它通过调整 TTL  字段来使用扩展环搜索。这在广播模式下没有意义，因为广播数据包不跨子网。事实上，在没有搜索的情况下在广播模式下实现 manycast  可能很有用，但这在待办事项列表中相当靠后。(…)“只有 `*` 和 `+` tattletales 表示候选幸存者。请注意，您的一台服务器正在关闭，另一台服务器即将加入。这是第一次出现时的正常情况，也是每天刷新一次签名时的正常情况。我假设您正在使用自动密钥;如果没有，就根本没有承诺。

So basically it’s a mechanism to automatically configure servers on a  nearby network. Compared to broadcasting and multicasting, manycasting  uses the normal `server` keyword, but with a multicast group address (class D) on the client. Manycast servers use the keyword `manycastserver`. As for broadcasts and multicasts, manycast associations on the client may come and go over time.
因此，基本上它是一种在附近网络上自动配置服务器的机制。与广播和组播相比，manycasting 使用 normal `server` 关键字，但在客户端上使用组播组地址（D 类）。Manycast 服务器使用关键字 `manycastserver` 。至于广播和多播，客户端上的许多播种关联可能会随着时间的推移而来来去去。

------

#### 6.2.4. PPS Synchronization 6.2.4. PPS同步

[PPS (Pulse-per-Second)](https://www.ntp.org/documentation/4.2.8-series/pps/) synchronization is an option that is neither necessary nor available  for all operating systems. Still it brings many benefits if used, so  it’s discussed here.
PPS（每秒脉冲）同步是一个选项，对于所有操作系统来说都不是必需的，也不可用。尽管如此，如果使用它仍然会带来许多好处，因此在这里进行讨论。

Network connections can suffer from random delays. Even for local reference  clocks the exact point in time to which some time message belongs is  difficult to determine. Delays imposed by the operating system are  another issue to deal with.
网络连接可能会受到随机延迟的影响。即使对于本地参考时钟，也很难确定某些时间消息所属的确切时间点。操作系统施加的延迟是另一个需要处理的问题。

Some means to improve the situation were thought of:
想到了一些改善这种情况的方法：

- The operating system could be modified to capture the time of some external event more precisely. Among such events could be characters received at a serial port or some [signal edge](https://en.wikipedia.org/wiki/Signal_edge) detected on a digital input.
  可以修改操作系统以更精确地捕获某些外部事件的时间。在这些事件中，可以在串行端口接收到字符，也可以在数字输入上检测到某些信号边沿。
- If such external events arrive periodically with high precision, the time  stamps could be used to determine the frequency error of the associated  computer clock.
  如果此类外部事件定期高精度到达，则时间戳可用于确定相关计算机时钟的频率误差。
- If the external event arrived exactly at the time when a new second  starts, the time stamps could be used to correct the offset of the  associated computer clock.
  如果外部事件恰好在新秒开始的时间到达，则可以使用时间戳来校正相关计算机时钟的偏移量。

Basically, this is what the PPS discussion is about.
基本上，这就是 PPS 讨论的内容。

------

#### 6.2.4.1 Which components are required to use PPS synchronization? 6.2.4.1 PPS同步需要哪些组件？

The following items are needed in order to use PPS synchronization:
要使用 PPS 同步，需要以下项目：

- You need a high precision signal that can be connected to the computer  running NTP. Usual sources of PPS signals are quality reference clocks  that feature such an output.
  您需要一个可以连接到运行 NTP 的计算机的高精度信号。PPS信号的常用源是具有这种输出的质量参考时钟。

- Your operating system must support processing of PPS signals. Most operating systems that come with source code (such as Linux and FreeBSD) already  support PPS processing or can be modified to do so.
  您的操作系统必须支持处理 PPS 信号。大多数带有源代码的操作系统（如 Linux 和 FreeBSD）已经支持 PPS 处理，或者可以对其进行修改。

  Most operating systems supporting PPS have a programming interface to read  timestamps and also implement the NTP kernel clock model with special  PPS processing options. See also [Q: 5.2.3.3](https://www.ntp.org/ntpfaq/ntp-s-algo-kernel/#5233-what-does-hardpps-do).
  大多数支持 PPS 的操作系统都有一个编程接口来读取时间戳，并且还通过特殊的 PPS 处理选项实现 NTP 内核时钟模型。另见问题：5.2.3.3。

- The NTP software must be configured to recognize and use PPS processing.  Usually the software’s autoconfigure process will detect the presence of PPS processing capabilities.
  NTP 软件必须配置为识别和使用 PPS 处理。通常，软件的自动配置过程将检测 PPS 处理功能的存在。

- Finally you should edit `ntp.conf` to work with PPS.
  最后，您应该编辑 `ntp.conf` 以使用 PPS。

------

#### 6.2.4.2 What changes are required in ntp.conf? 6.2.4.2 ntp.conf 需要哪些更改？

Unfortunately PPS processing is a [little messy](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6245-what-is-the-pps-api). Example 6.2a demonstrates the entries in `/etc/ntp.conf` which work with PPSkit-1.0.0 on my Linux PC.
不幸的是，PPS处理有点混乱。例 6.2a 演示了在我的 Linux PC 上使用 PPSkit-1.0.0 的条目 `/etc/ntp.conf` 。

**Example 6.2a: Using a PPS Signal
例 6.2a.. 使用 PPS 信号**

```
server 127.127.8.1 mode 135 prefer	# Meinberg GPS167 with PPS
fudge 127.127.8.1 time1 0.0042		# relative to PPS for my hardware

server 127.127.22.1 			# PPS
fudge 127.127.22.1 flag3 1		# enable PPS API
```

When starting, the following things happen:
启动时，会发生以下情况：

1. The clock `GENERIC(1)` becomes reachable while PPS is used to update the kernel variables described in [Q: 6.2.4.3](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6243-how-do-i-verify-that-everything-is-working).
   当 PPS 用于更新 Q： 6.2.4.3 中描述的内核变量时，时钟 `GENERIC(1)` 变得可访问。
2. The configured clock is selected as synchronization source, and `status` changes to `0x2143` after a while. At that time `PPS(1)` also becomes reachable. During that time `status` changes to `0x2107`, and `offset` shows current offsets from PPS.
   配置的时钟被选为同步源，并在 `status` 一段时间后更改为 `0x2143` 同步源。那时 `PPS(1)` 也可以到达。在此期间，将 `status` 更改为 `0x2107` ，并 `offset` 显示 PPS 的电流偏移量。
3. Eventually `PPS(1)` becomes PPS peer.
   最终 `PPS(1)` 成为 PPS 对等体。

------

#### 6.2.4.3 How do I verify that everything is working? 6.2.4.3 如何验证一切正常？

The pleasant part of this answer is that there are tools included in the  standard NTP software that makes this an easy task. The less pleasant  part is that there is no single way to enable PPS detection for each  operating system. However the [PPS API](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6245-what-is-the-pps-api) may change things in a positive way.
这个答案令人愉快的部分是，标准 NTP 软件中包含一些工具，使这成为一项简单的任务。不太令人愉快的部分是，没有单一的方法可以为每个操作系统启用 PPS 检测。但是，PPS API 可能会以积极的方式改变事情。

Let’s start with the easier part using standard tools:
让我们从使用标准工具的简单部分开始：

1. There are two means to look at the NTP kernel clock: `ntptime` and `ntpdc -c kerninfo`. As `ntptime` is a little more verbose, let’s consider it.
   有两种方法可以查看 NTP 内核时钟： `ntptime` 和 `ntpdc -c kerninfo` 。由于 `ntptime` 有点啰嗦，让我们考虑一下。

   ```
   windl@elf:~ >ntptime
   ntp_gettime() returns code 0 (OK)
     time bd6b9cf2.9c3c6c60  Thu, Sep 14 2000 20:52:34.610, (.610297702),
     maximum error 3480 us, estimated error 0 us.
   ntp_adjtime() returns code 0 (OK)
     modes 0x0 (),
     offset 1.658 us, frequency 17.346 ppm, interval 128 s,
     maximum error 3480 us, estimated error 0 us,
     status 0x2107 (PLL,PPSFREQ,PPSTIME,PPSSIGNAL,NANO),
     time constant 6, precision 3.530 us, tolerance 496 ppm,
     pps frequency 17.346 ppm, stability 0.016 ppm, jitter 1.378 us,
     intervals 57, jitter exceeded 29, stability exceeded 0, errors 0.
   ```

   The above command has been run on Linux version 2.2.16 with PPSkit-1.0.0.  That combination features PPS processing and a kernel clock using  nanoseconds.
   上述命令已在 Linux 版本 2.2.16 和 PPSkit-1.0.0 上运行。该组合具有 PPS 处理和使用纳秒的内核时钟。

   The first thing you should look at is the `status1` (`0x2107` in our case). The magic words in parentheses explain the meaning of the individual bits. The important bit for now is `PPSSIGNAL`. That bit is set directly by the operating system and says a PPS signal has been detected.
   您应该查看的第一件事是 `status1` （ `0x2107` 在我们的例子中）。括号中的魔术词解释了各个位的含义。现在重要的一点是 `PPSSIGNAL` .该位由操作系统直接设置，并表示已检测到 PPS 信号。

2. Now that pulses are detected, let’s see whether they are good ones. For  that purpose we read some additional numbers about the kernel clock’s  calibration process:
   现在检测到脉冲，让我们看看它们是否是好的脉冲。为此，我们阅读了有关内核时钟校准过程的一些其他数字：

   - `intervals 57` says that there were 57 calibration intervals. When PPS pulses are  arriving, this number should increase. Each frequency adjustment  requires a good calibration interval. The length of the current  calibration interval can be found as `interval 128 s` (128 seconds is the default maximum length). Remaining numbers count abnormal conditions as explained below.
      `intervals 57` 表示有 57 个校准间隔。当PPS脉冲到达时，这个数字应该增加。每次频率调整都需要良好的校准间隔。当前校准间隔的长度可以确定为 `interval 128 s` （默认最大长度为 128 秒）。其余数字计算异常情况，如下所述。

   - `jitter exceeded 29` means that there were 29 pulses that arrived at a time when they were  not considered good; however, completely bad pulses are not counted  here. This can mean that the pulses were out of range, or that the  system clock was read badly when the pulses arrived. The algorithm  dynamically adjusts the threshold for jitter. Occasional jitter is  allowed and should not worry you. If significant jitter is detected, the flag `PPSJITTER` is set.
      `jitter exceeded 29` 意味着有 29 个脉冲在它们被认为不好的时候到达;但是，这里不计算完全坏的脉冲。这可能意味着脉冲超出范围，或者当脉冲到达时系统时钟读取错误。该算法动态调整抖动阈值。偶尔的抖动是允许的，不应该让您担心。如果检测到明显的抖动，则设置标志 `PPSJITTER` 。

   - `stability exceeded 0` is the number of calibration intervals that would result in a  correction larger than considered valid, where the default limit is  quite high.
      `stability exceeded 0` 是将导致校正大于认为有效的校准间隔数，其中默认限制非常高。

     Validity is a bit fuzzy, but it means that the frequency change would be more  than the tolerance. You can find the tolerance coded into your operating system from `tolerance 496 ppm`, but it’s not guaranteed that the value is specific to your hardware.
     效度有点模糊，但这意味着频率变化将超过容差。您可以从 `tolerance 496 ppm` 中找到编码到操作系统中的容差，但不能保证该值特定于您的硬件。

     Stability should not be exceeded during normal operating conditions. Upon detection of that error the flag `PPSWANDER` is set.
     在正常操作条件下不应超过稳定性。检测到该错误后，将设置该标志 `PPSWANDER` 。

   - `errors 0` indicates the number of calibration intervals where pulses were missing or completely out of bounds. In these cases the flag `PPSERROR` is set. During normal operation that number should not increase.
      `errors 0` 表示脉冲缺失或完全越界的校准间隔数。在这些情况下，将设置标志 `PPSERROR` 。在正常操作期间，该数字不应增加。

   Those numbers are only reset when the machine is booted.
   这些数字仅在计算机启动时重置。

3. If you did not find an error, your PPS configuration should work! You can inspect some additional performance indicators:
   如果您没有发现错误，您的 PPS 配置应该可以正常工作！您可以检查一些其他性能指标：

   - `stability 0.016 ppm` is an averaged value for the last frequency corrections made  (instability). Basically a small value indicates that both your  operating system’s clock and your external PPS signal are stable.  Remember that [temperature changes affect the average PC](https://www.ntp.org/ntpfaq/ntp-s-algo/#5131-how-accurate-will-my-clock-be). The sample above was taken after running the system for about one hour; you should expect a value below `0.1 ppm` for a stable system.
      `stability 0.016 ppm` 是上次频率校正（不稳定性）的平均值。基本上，一个小值表示操作系统的时钟和外部 PPS 信号都很稳定。请记住，温度变化会影响普通 PC。上面的样本是在系统运行约一小时后采集的;对于稳定的系统，您应该期望以下 `0.1 ppm` 值。
   - `jitter 1.378 us` is also an averaged value. It indicates how much the individual pulses  vary from second to second, as measured by the operating system’s clock. This value will vary due to system load and interrupt latency. A few  microseconds are probably fine, but a few milliseconds definitely are  not!
      `jitter 1.378 us` 也是一个平均值。它指示各个脉冲在每秒之间变化的程度，由操作系统的时钟测量。此值将因系统负载和中断延迟而变化。几微秒可能没问题，但几毫秒绝对不行！

This completes the basic checks for PPS configuration. In the case above the NTP daemon is also working and using the data provided from the  operating system kernel. I’ll complete the description of the remaining  output:
这样就完成了对 PPS 配置的基本检查。在上述情况下，NTP 守护程序也在工作并使用操作系统内核提供的数据。我将完成其余输出的描述：

- `pps frequency 17.346 ppm` indicates the current correction value for the clock frequency derived  from the PPS signal. Positive values indicate the clock is too slow  compared to the PPS. If flag `PPSFREQ` is set, that frequency correction is used for correcting the kernel  clock. The NTP daemon will set this flag if the PPS parameters seem  valid.
   `pps frequency 17.346 ppm` 指示从 PPS 信号得出的时钟频率的电流校正值。正值表示与 PPS 相比，时钟太慢。如果设置了标志 `PPSFREQ` ，则该频率校正用于校正内核时钟。如果 PPS 参数看起来有效，NTP 守护程序将设置此标志。

- `offset 1.658 us` shows the last measured offset correction for the system clock. If flag `PPSTIME` is set, that offset is derived from the offset of the PPS pulse every second, and otherwise it’s updated through `ntp_adjtime()` from the application. A positive value for `offset` means that the system clock is behind the reference time.
   `offset 1.658 us` 显示系统时钟的最后一次测量偏移校正。如果设置了标志 `PPSTIME` ，则该偏移量是从每秒 PPS 脉冲的偏移量派生的，否则将从应用程序更新 `ntp_adjtime()` 。正值表示 `offset` 系统时钟落后于参考时间。

  PPS pulses add further corrections while the kernel clock tries to consume  this offset by correcting the time accordingly. Formerly the offset was  updated every 16 seconds by the kernel, but recently it’s updated every  second.
  PPS 脉冲会添加进一步的校正，而内核时钟则试图通过相应地校正时间来消耗此偏移。以前，内核每 16 秒更新一次偏移量，但最近每秒更新一次。

------

#### 6.2.4.4 Special Drivers 6.2.4.4 特殊驱动程序

#### 6.2.4.4.1. What is a PPS peer? 6.2.4.4.1. 什么是PPS对等体？

Even when the kernel clock uses PPS signals to calibrate, the NTP daemon  will still use the usual offsets of some reference clock. As it is  desirable to use the offsets of the PPS pulses, there is a pseudo clock  driver to do that. That driver needs to know the interface specific to  the platform to get the time stamps of the PPS pulses.
即使内核时钟使用 PPS 信号进行校准，NTP 守护程序仍将使用某些参考时钟的通常偏移量。由于需要使用PPS脉冲的偏移，因此有一个伪时钟驱动器来做到这一点。该驱动程序需要知道特定于平台的接口，以获取 PPS 脉冲的时间戳。

That driver is called [PPS](https://www.ntp.org/documentation/drivers/driver22/) and can be configured just as any other reference clock. The difference is that PPS can only be used in combination with another preferred time reference. As soon as the preferred time reference is used for  synchronization, the `PPS` driver becomes reachable, and it will eventually be used as [primary synchronization source](https://www.ntp.org/ntpfaq/ntp-s-algo-real/#532-why-should-i-have-more-than-one-clock). A PPS peer will be handled specially so that other time offsets are not considered. The command `ntpq -c peer -c as -c rl` will print something like:
该驱动器称为 PPS，可以像任何其他参考时钟一样进行配置。不同之处在于，PPS只能与另一个首选时间参考结合使用。一旦首选时间引用用于同步， `PPS` 驱动程序就会变得可访问，并且最终将用作主同步源。PPS 对等体将专门处理，因此不考虑其他时间偏移。该命令 `ntpq -c peer -c as -c rl` 将打印如下内容：

```
remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================
+GENERIC(1)      .GPS.            0 l   48   64  377    0.000    0.025   0.001
oPPS(1)          .PPS.            0 l   17   64  377    0.000    0.027   0.000

ind assID status  conf reach auth condition  last_event cnt
===========================================================
  1 57300  9434   yes   yes  none  candidat   reachable  3
  2 57301  9714   yes   yes  none  pps.peer   reachable  1

status=2194 leap_none, sync_atomic/PPS, 9 events, event_peer/strat_chg,
version="ntpd 4.0.99k Sun Sep 10 19:22:28 MEST 2000 (5)",
processor="i586", system="Linux2.2.16-NANO", leap=00, stratum=1,
precision=-16, rootdelay=0.000, rootdispersion=1.831, peer=57301,
refid=PPS, reftime=bd6b94f2.272b8844  Thu, Sep 14 2000 20:18:26.153,
poll=6, clock=bd6b952d.da89dadf  Thu, Sep 14 2000 20:19:25.853, state=4,
phase=0.005, frequency=16.984, jitter=0.000, stability=0.043
```

------

#### 6.2.4.4.2 How do I use PPS with the Motorola Oncore driver? 6.2.4.4.2 如何将 PPS 与 Motorola Oncore 驱动程序配合使用？

Considering the configuration below, John Hay wrote:
考虑到下面的配置，John Hay 写道：

(…)The Oncore driver directly manages the PPS stuff, so you only need the first line (`server 127.127.30.0 prefer`) in the config file. The rest is not needed to have a functional Oncore refclock.
(…)Oncore 驱动程序直接管理 PPS 内容，因此您只需要配置文件中的第一行 （ `server 127.127.30.0 prefer` ）。其余的不需要有一个正常的 Oncore 参考时钟。

```
server 127.127.30.0 prefer
fudge 127.127.30.0 stratum 0

server 127.127.22.1                     # PPS
fudge 127.127.22.1 flag3 1              # enable PPS module
```

> **Note:** As documented in [PPS Clock Discipline](https://www.ntp.org/documentation/drivers/driver8/#fudge-factors), `flag2` controls the edge of the PPS signal being used, obsoleting the `pps` keyword.
> 注意：如PPS时钟规则中所述， `flag2` 控制正在使用的PPS信号的边缘，使 `pps` 关键字过时。

Maybe it should also be noted here that a *site survey* can take significant time to finish. [Terje Mathisen](mailto:Terje.Mathisen@hda.hydro.com) says: “My survey (under Linux) took about 36 hours, I also gave up a couple of times before allowing it to run to completion.”
也许这里还应该注意，现场调查可能需要很长时间才能完成。Terje Mathisen 说：“我的调查（在 Linux 下）花了大约 36 个小时，在让它运行完成之前，我也放弃了几次。

------

#### 6.2.4.4.3 How do I use PPS with the NMEA driver? 6.2.4.4.3 如何在 NMEA 驱动程序中使用 PPS？

An [NMEA driver](https://www.ntp.org/documentation/drivers/driver20/) is included in NTPv4. That means that for PPS processing we don’t need the `PPS` driver or `pps` command in `ntp.conf`.
NMEA 驱动程序包含在 NTPv4 中。这意味着对于 PPS 处理，我们不需要 `ntp.conf` 中的 `PPS` 驱动程序或 `pps` 命令。

Here is sample `ntp.conf`:
下面是示例 `ntp.conf` ：

```
server 127.127.20.0     # NMEA driver
fudge  flag3 1          # enable kernel PPS discipline
```

------

#### 6.2.4.5 What is the PPS API? 6.2.4.5 什么是 PPS API？

As seen above, the programming interface specific to the operating system  and platform is a messy thing. Therefore some people decided to make a  common programming interface named PPS API. In March 2000 that draft was accepted as an [RFC 2783](https://www.ntp.org/reflib/rfc/rfc2783.txt). The functions of the API include:
如上所述，特定于操作系统和平台的编程接口是一件混乱的事情。因此，一些人决定制作一个名为 PPS API 的通用编程接口。2000年3月，该草案被接受为RFC 2783。API的功能包括：

- Routines to enable capturing of external events on a specified device (if supported).
  用于在指定设备上启用外部事件捕获的例程（如果支持）。
- Routines to query the last captured time stamps and associated event counters.
  用于查询上次捕获的时间戳和关联的事件计数器的例程。
- Routines to change operating parameters like compensating for processing delays and selecting polarity of the PPS signal.
  用于更改操作参数的例程，例如补偿处理延迟和选择 PPS 信号的极性。
- Routines to control automatic processing of detected events by a *kernel consumer* in the kernel of the operating system.
  用于控制操作系统内核中的内核使用者自动处理检测到的事件的例程。

[RFC 2783](https://www.ntp.org/reflib/rfc/rfc2783.txt) indicates that: “Several available implementations of this API are [listed](https://www.ntp.org/ppsapi/ppsimplist/). Note that not all of these implementations correspond to the current version of the specification”.
RFC 2783 指出：“列出了此 API 的几个可用实现。请注意，并非所有这些实现都与规范的当前版本相对应“。

------

#### 6.2.4.6 What is the shortest Width for a Pulse connected to the DCD Pin of an RS-232 Interface? 6.2.4.6 连接到RS-232接口DCD引脚的脉冲的最短宽度是多少？

That depends. The higher the quality your serial port is, the longer pulses  will be needed. This is because of the ESD protection of the chip.
那要看情况。串行端口的质量越高，需要的脉冲就越长。这是因为芯片的ESD保护。

26 usec should be about the bit time for a 38400 serial line, so you could connect it to the RxD line instead and see if you receive characters  that way when the port is set for 38400 or faster.
26 usec 应该大约是 38400 串行线路的位时间，因此您可以将其连接到 RxD 线路，并在端口设置为 38400 或更快时查看是否以这种方式接收字符。

Another thing to try is to configure the serial port for 115200. Some chips  base their deglitching on the baud rate, often requiring a full symbol  before they react.
要尝试的另一件事是为 115200 配置串行端口。一些芯片的去毛刺基于波特率，通常需要一个完整的符号才能做出反应。

------

#### 6.2.5 Automatic Configuration 6.2.5 自动配置

If many systems have to be configured in a similar way, there is a desire  to automate the process. We try to give some useful hints here.
如果许多系统必须以类似的方式进行配置，则希望实现该过程的自动化。我们尝试在这里提供一些有用的提示。

------

#### 6.2.5.1 How can I define the address of an NTP server in a BOOTP reply? 6.2.5.1 如何在BOOTP应答中定义NTP服务器的地址？

The BOOTP protocol is defined in [RFC 1048](https://www.rfc-editor.org/rfc/rfc1048) (obsoleted by [RFC 2132](https://www.rfc-editor.org/rfc/rfc2132)). Marc Brett contributed:
BOOTP 协议在 RFC 1048 中定义（已被 RFC 2132 淘汰）。Marc Brett 贡献：

Time ([RFC 868](https://www.rfc-editor.org/rfc/rfc868)) servers may be specified in the *Vendor Extensions field*, Code `4`.
时间 （ RFC 868） 服务器可以在 Vendor Extensions 字段的 Code `4` 中指定 。

NTP servers may be specified in the *Application and Service Parameters*, Code `42`.
NTP 服务器可以在应用程序和服务参数代码中指定 `42` 。

In some popular `bootpd`, time servers are specified with `ts=`, but NTP servers are specified with `nt=`. The latter allows a list of Internet addresses to be specified.
在一些流行的 `bootpd` 中，时间服务器被指定为 `ts=` ，但 NTP 服务器被指定为 `nt=` 。后者允许指定 Internet 地址列表。

------

#### 6.2.5.2 How do I use information about NTP servers given in a BOOTP reply? 6.2.5.2 如何使用 BOOTP 回复中提供的有关 NTP 服务器的信息？

If you are using Microsoft Windows, check whether your DHCP client  software or NTP software supports this feature. If not, you are probably out of luck.
如果您使用的是 Microsoft Windows，请检查您的 DHCP 客户端软件或 NTP 软件是否支持此功能。如果没有，你可能不走运了。

If you are using a UNIX system, you may be able to install the needed  code.Exactly what is needed depends on the operating system, but if you  are comfortable editing scripts, it shouldn’t be too hard.
如果您使用的是 UNIX 系统，则可以安装所需的代码。确切需要什么取决于操作系统，但如果您喜欢编辑脚本，那么它应该不会太难。

In general, UNIX systems implement BOOTP DHCP via a client daemon which  handles the interaction with the DHCP server. Often, the daemon itself  does not set up the network interface’s address or do any other work  based on the DHCP reply. Instead, it stores the information and  activates an initialization script to use that information to adjust the computer’s configuration.
通常，UNIX 系统通过客户端守护程序实现 BOOTP DHCP，该守护程序处理与 DHCP  服务器的交互。通常，守护程序本身不会设置网络接口的地址，也不会根据 DHCP  回复执行任何其他工作。相反，它会存储信息并激活初始化脚本，以使用该信息来调整计算机的配置。

Your first job is to identify the correct script. Start by tracking down the script that brings up the interface during normal startup. That script  will have code which activates the DHCP client, and thus must also  arrange to activate the script that implements the configuration  provided by DHCP.
您的第一项工作是确定正确的脚本。首先跟踪在正常启动期间显示界面的脚本。该脚本将具有激活 DHCP 客户端的代码，因此还必须安排激活实现 DHCP 提供的配置的脚本。

------

#### 6.2.6. Offering Time Service 6.2.6. 提供时间服务

This section presents some guidelines for offering time service to others.
本节介绍一些向他人提供时间服务的准则。

------

#### 6.2.6.1. Is there any way to configure ntpd to attach to a specific Interface? 6.2.6.1. 有没有办法将 ntpd 配置为附加到特定接口？

By default, `ntpd` listens on all virtual IP addresses. Use `-L` to configure `ntpd` to not listen on virtual IPs.
默认情况下， `ntpd` 侦听所有虚拟 IP 地址。用于 `-L` 配置 `ntpd` 为不侦听虚拟 IP。

------

#### 6.2.6.2. Should Access be restricted? 6.2.6.2. 访问是否应该受到限制？

If you don’t want to have clients, don’t offer the service. But as you  want to offer NTP service to others, you should not be afraid of  clients. Let me quote from an article in news://comp.protocols.time.ntp  written by David Dalton about the subject whether queries with `ntpq` and `ntpdc` should be allowed:
如果您不想拥有客户，请不要提供服务。但是，当您想为他人提供NTP服务时，您不应该害怕客户。让我引用大卫·道尔顿 （David Dalton） 在 news://comp.protocols.time.ntp 年写的一篇关于该主题的文章，该主题是否允许查询 `ntpq` 和 `ntpdc` 是否应该允许：

I am somewhat new to the security concerns of public timeservers. Only in the past few weeks did I upgrade my public timeserver to stratum-1 with a Trimble Palisade GPS receiver. It doesn’t have a lot of security  right now, but the `ntpdc` reconfiguration functions are restricted. I’m soliciting advice about  how to protect myself, although I don’t depend on that public timeserver in any way.
我对公共时间服务器的安全问题有点陌生。直到最近几周，我才使用 Trimble Palisade GPS 接收器将我的公共时间服务器升级到 stratum-1。它现在没有太多的安全性，但 `ntpdc` 重新配置功能受到限制。我正在征求有关如何保护自己的建议，尽管我不以任何方式依赖该公共时间服务器。

I agree with you that there is no substitute for long-term data for  evaluating the stability of a timeserver and the network between  yourself and the timeserver.
我同意你的看法，长期数据是无法替代的，用于评估时间服务器以及您与时间服务器之间的网络的稳定性。

But the query tools allow one to make evaluations without spending a lot of time, because the timeservers themselves have already collected the  long-term data. I always want to run `ntpq -p` or `ntpdc -p` on a remote timeserver before committing to it. Very handy.
但是查询工具允许人们在不花费大量时间的情况下进行评估，因为时间服务器本身已经收集了长期数据。在提交之前，我总是想在远程时间服务器上运行 `ntpq -p` 或 `ntpdc -p` 运行。非常方便。

Even long-term statistics (gathered by your own client) won’t tell you  anything about how well the remote server is configured. How many  reference clocks does it have? Which reference clocks? How many  stratum-1 servers does it have in case the clock(s) fail(s)? Which one  of these candidates would you prefer?
即使是长期统计信息（由您自己的客户端收集）也不会告诉您有关远程服务器配置情况的任何信息。它有多少个参考时钟？哪些参考时钟？它有多少个 layerum-1 服务器以防时钟出现故障？您更喜欢这些候选人中的哪一位？

```
EXAMPLE ONE (BAD)
 -----------------
 [444] ntpq -p fubar.net
  remote      refid      st t when poll reach   delay   offset    disp
 =========================================================================
 *WWVB_SPEC       .WWVB.      0 l   18   16  377     0.00    0.301    1.69
  LOCAL(1)        LOCAL(1)    0 l    1   16  377     0.00    0.000   10.01
 
 EXAMPLE TWO (NOT BAD)
 ---------------------
 [170] ntpq  -p fubar2.net
  remote      refid      st t when poll reach   delay   offset    disp
 =========================================================================
 *WWVB_SPEC(      .WWVB.      0 l   30   16  377     0.00    0.140    2.01
  LOCAL(1)        LOCAL(1)   10 l   13   16  377     0.00    0.000   10.01
 +hpxxxxxxxx      .GPS.       1 u   11   16  376     0.99   -0.708    0.35
 +hpxxxxxxxx      .GPS.       1 u   49   64  377     4.97   -2.680    0.81
  hpxxxxxxxx      xxxxxxxx    3 u  206 1024  377     4.70   -3.010    9.69
  hpxxxxxxxx      xxxxxxxx    3 u   29 1024  377     2.88   -4.287    0.17
 
 EXAMPLE THREE (OUTSTANDING)
 ---------------------------
 [169] ntpq  -p ntp2.usno.navy.mil
  remote      refid      st t when poll reach   delay   offset    disp
 =========================================================================
 +GPS_VME(0)     .USNO.       0 l   15   16  377     0.00   -0.007    0.02
 *GPS_VME(1)     .USNO.       0 l   14   16  377     0.00    0.003    0.02
 +GPS_VME(2)     .USNO.       0 l   13   16  377     0.00    0.028    0.02
 +tick.usno      .USNO.       1 u   45   64  376     1.65    0.032    0.64
 -tock.usno      .USNO.       1 u   16   64  377     1.48   -0.072    0.47
 x204.34.19      .USNO.       1 u   24   64  377   226.88    3.924    1.77
 x204.34.19      .USNO.       1 u 1014 1024  376   249.76   10.737   26.49
  navobs1.g      0.0.0.0     16 -    - 1024    0     0.00    0.000 16000.0
```

That article continues: 那篇文章继续说：

You and I might agree that a handheld consumer-grade GPS receiver putting  out NMEA data to a small workstation with 500 milliseconds dispersion is a poor excuse for a stratum-1 public timeserver, but that doesn’t stop  somebody from offering such a server for public use. No sanity checking  or evaluation is done on the machines listed at UDelaware (AFAIK).
你和我可能都同意，手持式消费级 GPS 接收器将 NMEA 数据输出到 500 毫秒色散的小型工作站是 stratum-1  公共时间服务器的一个糟糕的借口，但这并不能阻止有人提供这样的服务器供公众使用。未对 UDelaware （AFAIK）  中列出的计算机进行健全性检查或评估。

Here is what my handheld GPS receiver (400 dollars) looked like:
这是我的手持式 GPS 接收器（400 美元）的样子：

```
[179] ntpq  -p gpstime.net
  remote      refid      st t when poll reach   delay   offset    disp
 =========================================================================
 *GPS_NMEA        .GPS.       0 l    1   64  377     0.00  -226.243  420.08
```

Here is a stratum-2 timeserver that has a good pedigree (HP-UX) and is  synching to a stratum-1 timeserver that has an HP GPS clock, but the  stratum-2 machine is having problems because the network is *very* congested and it has no backup sources:
这是一个具有良好血统 （HP-UX） 的 stratum-2 时间服务器，并且正在同步到具有 HP GPS 时钟的 stratum-1 时间服务器，但 stratum-2 机器有问题，因为网络非常拥塞并且没有备份源：

```
  remote            refid      st t when poll reach  delay   offset disp
 ==========================================================================
  big_srv         17.8.5.7      2 u    3  512   17   312.87 -249.15 1960.85
```

Here are some results from well configured public timeservers that I have  surveyed at various times. It is interesting to work your way through  the stratum-1 list at UDelaware and see a lot of timeservers this way.
以下是我在不同时间调查过的配置良好的公共时间服务器的一些结果。在 UDelaware 的 stratum-1 列表中工作并以这种方式看到很多时间服务器是很有趣的。

```
[165] ntpq  -p ntp-cup.external.hp.com
  remote      refid      st t when poll reach   delay   offset    disp
 =========================================================================
 *REFCLK(29,1)    .GPS.       0 l   21   32  377     0.00    0.014    0.02
 +bigben.cac.wash .USNO.      1 u  115  128  377    38.48   -0.292    0.46
 +clepsydra.dec.c .GPS.       1 u    2  128  377     6.94    0.044    0.21
 -clock.isc.org   .GOES.      1 u  381 1024  377     6.29   -3.159    0.11
  hpsdlo.sdd.hp.c bigben.ash  2 u   25   32  125    53.68   -9.817    3.69
 -tick.ucla.edu   .USNO.      1 u   70  128  377    19.18   -0.894    0.38
 -usno.pa-x.dec.c .USNO.      1 u   39  128  377     7.05   -0.434    0.26
```

So there are valid arguments for allowing some standard queries from  prospective or active NTP clients. On the other hand there are also  arguments for restricting access:
因此，有有效的论据允许来自潜在或活动 NTP 客户端的某些标准查询。另一方面，也有限制访问的论点：

- [Configuration changes](https://www.ntp.org/ntpfaq/ntp-s-config/#6144-how-do-i-use-authentication-keys) should be restricted to machines within the own administrative domain at least.
  配置更改应至少限制在自己的管理域中的计算机。
- You might consider the possibility that a security hole is found in some  software which could be exploited to do bad things to your server.  Therefore you could restrict or enable certain ranges of IP addresses.
  您可能会考虑在某些软件中发现安全漏洞的可能性，这些漏洞可能会被利用来对您的服务器做坏事。因此，您可以限制或启用某些范围的 IP 地址。

------

#### 6.2.6.3. What should be done before announcing public NTP service? 6.2.6.3. 在宣布公共NTP服务之前应该做什么？

As with any service offered in the Internet, there is a potential to do something stupid. You are strongly advised to do some [monitoring](https://www.ntp.org/ntpfaq/ntp-s-trouble/#81-monitoring) of your server before going public.
与互联网上提供的任何服务一样，有可能做一些愚蠢的事情。强烈建议您在公开之前对您的服务器进行一些监控。

Once you are satisfied with the performance data, you should also consider the following questions:
一旦您对性能数据感到满意，您还应该考虑以下问题：

- Does the server have an offset and stability better or equal to other servers at the same stratum?
  服务器的偏移量和稳定性是否优于或等于同一层的其他服务器？
- Does the server have redundant or highly available time sources (reference clocks or peers)?
  服务器是否具有冗余或高可用性时间源（参考时钟或对等体）？
- Did you arrange peering with at least one other server at the same or at an even better stratum?
  您是否安排了与至少一台其他服务器的对等互连，或者处于同一层或更好的层？
- Do you want to serve possibly hundreds of unknown clients?
  您想为数百个未知客户提供服务吗？
- Does the Internet connection satisfy the demands for NTP service (good network response times and very few dropped packets)?
  互联网连接是否满足NTP服务的需求（良好的网络响应时间和很少的丢包）？
- Is the server machine highly available? Does it start up automatically  after a failure? Is there a contact person in case of problems?
  服务器计算机是否高可用性？故障后会自动启动吗？有问题有联系人吗？
- Are there plans to continue the service for at least six months?
  是否有计划继续服务至少六个月？

If you answered any of these questions with “No”, reconsider the decision to offer public time service.
如果您对这些问题中的任何一个回答为“否”，请重新考虑提供公共时间服务的决定。



# 6.3. Various Tricks 6.3. 各种技巧

Last update: June 27, 2022 16:22 UTC ([1a7aee0a0](https://git.nwtime.org/websites/ntpwww/commit/1a7aee0a0bed1662a9f219fcaea42e57cff5d0b3))
最后更新： 2022年6月27日 16：22 UTC （ 1a7aee0a0）

6.3.1 [Mixing Time Protocols](https://www.ntp.org/ntpfaq/ntp-s-config-tricks/#631-mixing-time-protocols)
6.3.1 混合时间协议
 6.3.2 [Avoiding Time Steps](https://www.ntp.org/ntpfaq/ntp-s-config-tricks/#632-avoiding-time-steps)
6.3.2 避免时间步长 
 6.3.3 [Using the Echo Feature in PPS API](https://www.ntp.org/ntpfaq/ntp-s-config-tricks/#633-using-the-echo-feature-in-pps-api)
6.3.3 在 PPS API 中使用回显功能

------

#### 6.3.1 Mixing Time Protocols 6.3.1 混合时间协议

> **Note:** Mixing different time protocols is generally deprecated, because it can invalidate some assumptions necessary for proper operation of any time  protocol.
> 注意：通常不推荐混合不同的时间协议，因为它可能会使任何时间协议正常运行所需的某些假设无效。

However, sometimes there is a need for NTP to utilize a server that is using a  different Time protocol. The short and possibly unpleasant answer is:  “Run NTP on that server!”.
但是，有时 NTP 需要使用使用不同时间协议的服务器。简短且可能令人不快的答案是：“在该服务器上运行 NTP！

Alternately, you need a modified configuration to prevent clock adjustments  originating from NTP. This example is thanks to Marc Brett:
或者，您需要修改配置以防止源自 NTP 的时钟调整。这个例子要感谢 Marc Brett：

**Example 6.3a: Using TimeServ and NTP on Windows NT
例 6.3a.. 在 Windows NT 上使用 TimeServ 和 NTP**

In this example, an old Windows NT server is using TimeServ for clock  synchronization, and checks the USNO clock via modem. I also want to  synchronize some UNIX servers, but NTP via Internet is not possible.
在此示例中，旧的 Windows NT 服务器使用 TimeServ 进行时钟同步，并通过调制解调器检查 USNO 时钟。我还想同步一些 UNIX 服务器，但无法通过 Internet 进行 NTP。

Disable NTP from adjusting the local clock on the Windows NT server using:
使用以下方法禁用 NTP 调整 Windows NT 服务器上的本地时钟：

```
server 127.127.1.0
fudge  127.127.1.0 stratum 4
driftfile %windir%\ntp.drift
disable ntp
```

------

#### 6.3.2 Avoiding Time Steps 6.3.2 避免时间步长

(Answer by Marc Brett) NTP works with up to 1000 seconds of offset, but when  the error is “big”, where big is defined as 128 ms (!), it will by  default step the clock.
（回答者 Marc Brett）NTP 最多可处理 1000 秒的偏移，但当误差为“大”时，其中 big 定义为 128 毫秒 （！），默认情况下它将步进时钟。

It is possible to tell it to always slew the clock though. The solution  given refers to the following description: “The clock is ahead by over  20 minutes and it seems to drift forward 6 seconds a week. I would like  to bring it back about 30 seconds a week until it’s synchronized.”
不过，可以告诉它总是在回转时钟。给出的解决方案参考了以下描述：“时钟领先了 20 多分钟，它似乎每周向前漂移 6 秒。我想每周将它带回大约 30 秒，直到它同步。

1. Install `ntpd` with no reference clocks except the local clock (`127.127.0.1`), fudge stratum to 10 or something like that.
   安装 `ntpd` 时除了本地时钟 （ `127.127.0.1` ）、软糖层到 10 或类似的东西之外，没有参考时钟。

2. Make a fake `ntp.drift` file containing a value which would correct for your drift rate (about `-10.0`), plus a value big enough to bring it back in line within a week: `-(20 * 60) * 1e6 / (86400 * 7) = -1984`.
   制作一个假 `ntp.drift` 文件，其中包含一个可以纠正您的漂移率（大约 `-10.0` ）的值，以及一个足够大的值，使其在一周内恢复正常： `-(20 * 60) * 1e6 / (86400 * 7) = -1984` 。

   Since this number is too large (greater than `500 ppm`), I suspect that you’ll have to settle for using `-500` in `ntp.drift`, and allow up to four weeks for your clock to be approximately correct of slightly slow.
   由于这个数字太大（大于 `500 ppm` ），我怀疑您将不得不满足于使用 `-500` `ntp.drift` ，并允许最多四个星期的时间让您的时钟大致正确或稍慢。

   (I believe a negative number in `ntp.drift` will indeed slow the clock down, can anyone verify this?)
   （我相信负 `ntp.drift` 数确实会减慢时钟的速度，谁能验证这一点？

3. At that time you can insert a proper NTP server in your `ntp.conf` file and restart the daemon.
   此时，您可以在 `ntp.conf` 文件中插入适当的 NTP 服务器并重新启动守护程序。

An alternative solution suggests (I assume that there is a chance of  simply taking the server offline for 30 minutes sometime during the next few weeks):
另一种解决方案建议（我假设在接下来的几周内的某个时候，有可能简单地让服务器离线 30 分钟）：

1. Shutdown 关闭
2. Set the BIOS clock
   设置 BIOS 时钟
3. Restart 重新启动

------

#### 6.3.3 Using the Echo Feature in PPS API 6.3.3 在 PPS API 中使用回显功能

This answer provided by [Vladimir Smotlacha](mailto:vs@cesnet.cz) was rephrased by the editor.
弗拉基米尔·斯莫特拉查（Vladimir Smotlacha）提供的这个答案被编辑改写了。

The Linux implementation of the PPS API contains the echo feature for the  serial ports. The principle is quite simple: an event on the DCD line  causes the interrupt routine to generate an event also on the RTS line  after getting the event’s timestamp. With some external device like a  two channel oscilloscope or counter one can measure the difference  between the original signal and its echo. About half of the time is the  delay between creation of the event and getting its timestamp. That way  one can estimate the delay and jitter between real PPS signal and its  timestamps.
PPS API 的 Linux 实现包含串行端口的回显功能。原理很简单：DCD 线上的事件在获取事件的时间戳后，会导致中断例程在 RTS  线上也生成一个事件。使用一些外部设备，如双通道示波器或计数器，可以测量原始信号与其回波之间的差异。大约一半的时间是创建事件和获取其时间戳之间的延迟。这样，就可以估计实际PPS信号与其时间戳之间的延迟和抖动。

An utility named `ppsctl` (formerly named `enable_pps`) can be used to activate echo on a port by additionally specifying `-e*X*`, where `*X*` is either `a` (assert) or `c` (clear). The utility just sets the flags as described in [RFC 2783](https://www.ntp.org/reflib/rfc/rfc2783.txt). The Linux implementation will always clear the RTS bit in the UART if  an event becomes active, and it will clear the bit when the DCD line  changes back to the inactive state. Therefore you cannot have an echo  for both events.
一个名为 `ppsctl` （formerly named `enable_pps` ） 的实用程序可用于激活端口上的回显，方法是另外指定 `-e*X*` ，其中 `*X*` 是 `a` （assert） 或 `c` （clear）。该实用程序仅按照 RFC 2783 中所述设置标志。如果事件变为活动状态，Linux 实现将始终清除 UART 中的 RTS 位，并且当 DCD 线路变回非活动状态时，它将清除该位。因此，您不能同时对这两个事件都有回声。

**Example 6.3b: Measurements and Statistics of PPS Echo Delay
例 6.3b.. PPS 回波延迟的测量和统计**

The following graphs are the result of PPS echo delay measurement during  normal operation of an NTP server (about 120 clients). The first PC is a standard Pentium 150MHz (UDMA disk, kernel 2.2.17, NTP 4.0.99k), the  second is DELL 1400 (Pentium III 860MHz, SCSI disk, kernel 2.2.18, NTP  4.0.99k36). Source of PPS signal was a Garmin GPS35, and a universal  counter SR 620 (Stanford Research Systems) was used for measurements.  Root Allan variance of PPS signal derived from GPS is 43 nanoseconds.
下图是NTP服务器（约120个客户端）正常运行期间的PPS回波延迟测量结果。第一台PC是标准的Pentium 150MHz（UDMA磁盘，内核2.2.17，NTP 4.0.99k），第二台是DELL 1400（Pentium III  860MHz，SCSI磁盘，内核2.2.18，NTP 4.0.99k36）。PPS 信号源是 Garmin GPS35，并使用通用计数器 SR  620（斯坦福研究系统）进行测量。来自 GPS 的 PPS 信号的根艾伦方差为 43 纳秒。

| Machine 机器 | Mean 意味 着 | Root Allan Variance 根艾伦方差 | Standard Deviation 标准差 |
| ------------ | ------------ | ------------------------------ | ------------------------- |
| P150         | 11.02        | 0.83                           | 0.95                      |
| P850         | 8.31         | 0.34                           | 0.36                      |



  ![img](https://www.ntp.org/ntpfaq/pps-delay.png)



**The graph shows the raw measurements for the delay round-trip time.
该图显示了延迟往返时间的原始测量值。**



  ![img](https://www.ntp.org/ntpfaq/pps-distrib.png)



**The graph shows the distribution of the delay samples.
该图显示了延迟样本的分布。**

When varying the system load for the P150 with a kernel compilation (varying I/O and CPU load), the delay increased by roughly 15 microseconds.  Plain CPU load (simple loop) only adds an extra delay of 7μs, while disk I/O adds up to 30μs. IDE disks without using DMA add up to 100μs of  extra delay.
当使用内核编译（改变 I/O 和 CPU 负载）改变 P150 的系统负载时，延迟增加了大约 15 微秒。普通 CPU 负载（简单循环）仅增加 7μs  的额外延迟，而磁盘 I/O 增加多达 30μs。不使用 DMA 的 IDE 磁盘会增加多达 100μs 的额外延迟。

# 6.4. Compatibility 6.4. 兼容性

Last update: April 3, 2024 16:42 UTC ([f170361b7](https://git.nwtime.org/websites/ntpwww/commit/f170361b72193f7af81935c6c0a4afda96793f0d))
最后更新： 2024年4月3日 16：42 UTC （ f170361b7）

An ideal world has no compatibility issues. This section deals with known incompatibilities.
理想的世界没有兼容性问题。本节介绍已知的不兼容问题。

6.4.1 [The Kernel PLL](https://www.ntp.org/ntpfaq/ntp-s-compat/#641-the-kernel-pll) 6.4.1 内核 PLL
 6.4.1.1 [How many different kernel models and implementations exist?](https://www.ntp.org/ntpfaq/ntp-s-compat/#6411-how-many-different-kernel-models-and-implementations-exist)
6.4.1.1 有多少种不同的内核模型和实现？
 6.4.1.2 [What’s new in each Version?](https://www.ntp.org/ntpfaq/ntp-s-compat/#6412-whats-new-in-each-version)
6.4.1.2 每个版本有什么新功能？
 6.4.1.3 [Are the individual kernel models compatible?](https://www.ntp.org/ntpfaq/ntp-s-compat/#6413-are-the-individual-kernel-models-compatible)
6.4.1.3 各个内核模型是否兼容？
 6.4.1.4 [Is the Linux implementation different?](https://www.ntp.org/ntpfaq/ntp-s-compat/#6414-is-the-linux-implementation-different)
6.4.1.4 Linux 实现有什么不同吗？

------

#### 6.4.1 The Kernel PLL 6.4.1 内核 PLL

#### 6.4.1.1 How many different kernel models and implementations exist? 6.4.1.1 有多少种不同的内核模型和实现？

There are two major versions for the kernel PLL: the model for NTPv3, and the model for NTPv4.
内核 PLL 有两个主要版本：NTPv3 模型和 NTPv4 模型。

------

#### 6.4.1.2 What’s new in each Version? 6.4.1.2 每个版本有什么新功能？

The history of the earlier kernel clock models is somewhat obscure. The basic features are described in [Q: 5.2.1.1](https://www.ntp.org/ntpfaq/ntp-s-algo-kernel/#5211-what-is-special-about-the-kernel-clock).
早期内核时钟模型的历史有些模糊不清。基本功能在Q：5.2.1.1中描述。

The clock model designed for NTPv4 has these features:
专为 NTPv4 设计的时钟模型具有以下功能：

- Timestamps are represented with 64 bits (instead of 32) to represent a  sub-nanosecond resolution. There is also a new interface to control  these nanoseconds. The higher precision results in a more continuous  flow of time.
  时间戳用 64 位（而不是 32 位）表示，以表示亚纳秒级分辨率。还有一个新界面来控制这些纳秒。精度越高，时间流就越连续。
- A new status bit, `STA_MODE`, controls a hybrid PLL/FLL mode, avoiding instabilities.
  新的状态位 `STA_MODE` ，控制混合 PLL/FLL 模式，避免不稳定。
- The minimum interval between adjustments has been reduced from 16 seconds  to one second, while the maximum interval has been extended from about  one hour to 36 hours. Unfortunately `constant` has an [incompatible meaning](https://www.ntp.org/ntpfaq/ntp-s-compat/#6413-are-the-individual-kernel-models-compatible).
  调整之间的最小间隔从 16 秒减少到 1 秒，而最大间隔从大约 1 小时延长到 36 小时。不幸的是， `constant` 具有不相容的含义。
- PPS processing has been significantly revised. The calibration range has  been extended, and the robustness towards spikes and jitter has been  improved. Sampling intervals have been reduced to achieve a faster  response to offset and frequency errors.
  PPS处理已进行了重大修订。校准范围已扩展，并且对尖峰和抖动的鲁棒性已得到改善。采样间隔已缩短，以实现对失调和频率误差的更快响应。

Revision 3 of the nanokernel introduced a shorter default calibration interval  when correcting the frequency with PPS. At the same time the maximum  interval can be adjusted using `MOD_PPSMAX`. Selection of PLL and FLL mode is done automatically now.
纳米内核的修订版 3 在使用 PPS 校正频率时引入了更短的默认校准间隔。同时，可以使用 `MOD_PPSMAX` 调整最大间隔。现在自动选择PLL和FLL模式。

Revision 4 of the nanokernel features more direct response to PPS offset errors, more realistic error estimates, and a new mode bit (`MOD_TAI`) to define the offset between UTC and TAI.
纳米内核的修订版 4 具有对 PPS 偏移误差的更直接响应、更真实的误差估计以及用于定义 UTC 和 TAI 之间偏移的新模式位 （ `MOD_TAI` ）。

A later revision featured a longer default calibration interval for PPS and a partial state reset when `STA_PLL` is cleared.
后来的修订版具有更长的 PPS 默认校准间隔和清除时 `STA_PLL` 的部分状态复位。

------

#### 6.4.1.3 Are the individual kernel models compatible? 6.4.1.3 各个内核模型是否兼容？

The most recent version known as nanokernel has different semantics for the `time_constant`. When used with the old version 3 `xntpd` daemon, the PLL has a tendency to oscillate, because the damping is too low.
称为 nanokernel 的最新版本对 `time_constant` .当与旧版本 3 `xntpd` 守护程序一起使用时，PLL 有振荡的趋势，因为阻尼太低。

When the old kernel implementation is used with the new version 4 daemon,  the PLL is too stiff, causing a slow adjustment to frequency changes.
当旧内核实现与新版本 4 守护进程一起使用时，PLL 过于僵硬，导致频率变化调整缓慢。

When the NTPv4 daemon sets the `STA_NANO` bit, the old NTPv3 daemon gets completely confused by nanoseconds which are believed to be microseconds. As it seems, the daemon does not clear `STA_NANO` during startup, so the only solution is to reboot or clear that flag by other means.
当 NTPv4 守护程序设置位时 `STA_NANO` ，旧的 NTPv3 守护程序会完全被纳秒混淆，纳秒被认为是微秒。看起来，守护程序在启动过程中不会清除 `STA_NANO` ，因此唯一的解决方案是通过其他方式重新启动或清除该标志。

[Professor David L. Mills](https://www.nwtime.org/tribute-to-david-l-mills/) wrote:
David L. Mills教授写道：

The old and new kernel code use different time constant ranges. The current `ntpd` and API do understand and adjust accordingly. The old `xntpd` will probably be off by a factor of 16 in the time constant. That is absolutely certain to cause unstable operation.
新旧内核代码使用不同的时间常量范围。当前 `ntpd` 和 API 确实理解并相应地进行调整。旧的 `xntpd` 可能会在时间常数中偏离 16 倍。这绝对会导致运行不稳定。

If you have an even older implementation, you probably can’t compile the daemon, or the daemon will not use the kernel PLL.
如果你有一个更旧的实现，你可能无法编译守护程序，或者守护程序不会使用内核 PLL。

------

#### 6.4.1.4 Is the Linux implementation different? 6.4.1.4 Linux 实现有什么不同吗？

Yes, it is. One reason is that the original nanokernel was found to be broken with respect to `STA_PPSWANDER`. According to [Professor David L. Mills](https://www.nwtime.org/tribute-to-david-l-mills/) the current nanokernel is no longer showing that defect:
是的，它是。一个原因是发现原始纳米内核相对于 `STA_PPSWANDER` .根据David L. Mills教授的说法，目前的纳米内核不再显示出这种缺陷：

Professor David L. Mills wrote: “`MAXWANDER` is 100 in the current nanokernel, not 500. This value was adjusted due to simulation experience.”
David L. Mills教授写道：“ `MAXWANDER` 在当前的纳米核中是100，而不是500。这个值是根据仿真经验调整的。

When used with a PPS signal, the Linux implementation (as of PPSkit-0.7) also computes uncommon values for `tolerance` as I explained to Professor David L. Mills:
当与 PPS 信号一起使用时，Linux 实现（从 PPSkit-0.7 开始）也会计算不常见的值， `tolerance` 正如我向 David L. Mills 教授解释的那样：

Another feature is that the maximum error is limited in Linux: it’s either 16s  or 2s, depending on your version of the kernel. Whenever that value is  reached, the `STA_UNSYNC` flag is set in the kernel clock.
另一个特点是最大错误在 Linux 中受到限制：它是 16 秒或 2 秒，具体取决于您的内核版本。每当达到该值时，都会在内核时钟中设置该 `STA_UNSYNC` 标志。

# 7. Reference Clocks 7. 参考时钟

Last update: July 4, 2023 16:28 UTC ([fd17d3567](https://git.nwtime.org/websites/ntpwww/commit/fd17d3567b5058729431cb8644929c68278416ec))
最后更新： 2023年7月4日 16：28 UTC （ fd17d3567）

7.1 [What is LCL, the Local Clock?](https://www.ntp.org/ntpfaq/ntp-s-refclk/#71-what-is-lcl-the-local-clock)
7.1 什么是LCL，本地时钟？
 7.2 [GPS Receivers](https://www.ntp.org/ntpfaq/ntp-s-refclk/#72-gps-receivers) 7.2 GPS接收器
 7.2.1 [What should I know about various GPS Receivers?](https://www.ntp.org/ntpfaq/ntp-s-refclk/#721-what-should-i-know-about-various-gps-receivers)
7.2.1 关于各种GPS接收器，我应该知道些什么？
 7.2.2 [What are PDOP, TDOP, and GDOP?](https://www.ntp.org/ntpfaq/ntp-s-refclk/#722-what-are-pdop-tdop-and-gdop)
7.2.2 什么是 PDOP、TDOP 和 GDOP？
 7.2.3 [What is NMEA?](https://www.ntp.org/ntpfaq/ntp-s-refclk/#723-what-is-nmea)
7.2.3 什么是NMEA？
 7.2.4 [What is TSIP?](https://www.ntp.org/ntpfaq/ntp-s-refclk/#724-what-is-tsip)
7.2.4 什么是TSIP？
 7.3 [DCF77 Receivers](https://www.ntp.org/ntpfaq/ntp-s-refclk/#73-dcf77-receivers) 7.3 DCF77接收器
 7.3.1 [What should I know about DCF77 Receivers?](https://www.ntp.org/ntpfaq/ntp-s-refclk/#731-what-should-i-know-about-dcf77-receivers)
7.3.1 关于 DCF77 接收器，我应该了解什么？
 7.3.2 [What can make my DCF77 Receiver fail?](https://www.ntp.org/ntpfaq/ntp-s-refclk/#732-what-can-make-my-dcf77-receiver-fail)
7.3.2 什么会导致我的 DCF77 接收器出现故障？
 7.4 [Other Receivers](https://www.ntp.org/ntpfaq/ntp-s-refclk/#74-other-receivers) 7.4 其他接收器
 7.4.1 [What can make my MSF Receiver fail?](https://www.ntp.org/ntpfaq/ntp-s-refclk/#741-what-can-make-my-msf-receiver-fail)
7.4.1 什么会导致我的 MSF 接收器出现故障？
 7.4.2 [How can I find a low-cost Receiver for Low-Frequency Transmissions?](https://www.ntp.org/ntpfaq/ntp-s-refclk/#742-how-can-i-find-a-low-cost-receiver-for-low-frequency-transmissions)
7.4.2 如何找到用于低频传输的低成本接收器？
 7.5 [Products](https://www.ntp.org/ntpfaq/ntp-s-refclk/#75-products) 7.5 产品
 7.5.1 [Where can I find a reference clock for NTP?](https://www.ntp.org/ntpfaq/ntp-s-refclk/#751-where-can-i-find-a-reference-clock-for-ntp)
7.5.1 在哪里可以找到NTP的参考时钟？

------

The NTP software supports different kinds of [reference clocks](https://www.ntp.org/ntpfaq/ntp-s-algo/#5111-what-is-a-reference-clock). This section presents various reference clocks.
NTP软件支持不同类型的参考时钟。本节介绍各种参考时钟。

According to a [survey](https://www.ntp.org/reflib/reports/ntp-survey99-minar.pdf), the most popular real reference clocks are:
根据一项调查，最受欢迎的真实参考时钟是：

- [GPS](https://www.ntp.org/ntpfaq/ntp-s-related/#91-gps/)
- [DCF77 DCF77型](https://en.wikipedia.org/wiki/DCF77)
- [WWVB 世界大循环](https://en.wikipedia.org/wiki/WWVB)

While not the cheapest solution, GPS offers high accuracy without a lot of  trickery. DCF77 on the other hand offers very cheap solutions at  moderate accuracy.
虽然不是最便宜的解决方案，但 GPS 提供了高精度，没有太多技巧。另一方面，DCF77 以中等精度提供非常便宜的解决方案。

More information on reference clocks can be found in [Reference Clock](https://www.ntp.org/documentation/4.2.8-series/refclock/) and [NIST’s list of receiver manufacturers](https://www.nist.gov/pml/time-and-frequency-division/time-distribution/radio-station-wwv/manufacturers-time-and-frequency).
有关参考时钟的更多信息，请参阅参考时钟和NIST的接收机制造商列表。

------

#### 7.1 What is LCL, the Local Clock? 7.1 什么是LCL，本地时钟？

The [LCL](https://www.ntp.org/documentation/drivers/driver1/) is not an actual reference clock; instead it simply refers to the  system time on the current machine. Therefore it should never be used,  except when the system time is synchronized by some means not visible by `ntpd`.
LCL不是实际的参考时钟;相反，它只是指当前计算机上的系统时间。因此，永远不应该使用它，除非系统时间通过某种不可见 `ntpd` 的方式同步。

On an isolated network one might set the time manually from time to time. Together with a frequency adjustment available as a [fudge factor](https://www.ntp.org/documentation/drivers/driver1/#fudge-factors) one may achieve an accuracy of a few seconds per week.
在隔离网络上，可能会不时手动设置时间。再加上频率调整作为软糖系数，每周可以达到几秒钟的精度。

If you think you really must use LCL, here is how:
如果您认为真的必须使用 LCL，请按以下步骤操作：

```
server 127.127.1.1		# LCL, local clock
fudge  127.127.1.1 stratum 12	# increase stratum
```

------

#### 7.2 GPS Receivers 7.2 GPS接收器

#### 7.2.1 What should I know about various GPS Receivers? 7.2.1 关于各种GPS接收器，我应该知道些什么？

GPS receivers have high accuracy, are simple to install, rather immune  against electromagnetic noise, and they only need an antenna with free  view to the sky, preferrably as much of the hemisphere as possible. Most calibration happens automatically.
GPS接收器精度高，安装简单，对电磁噪声免疫，并且只需要一个可以自由看到天空的天线，最好是尽可能多地看到半球。大多数校准都是自动进行的。

[GPS](https://www.ntp.org/ntpfaq/ntp-s-related/#91-gps), the Global Positioning System, a satellite based navigation aid  originally developed for military use in the USA, can provide the  receiver with accurate data about the current position, elevation, and  time. Unfortunately many of these receivers were not designed with  accurate time-keeping in mind. Therefore the time information provided  in a stream of serial data sometimes is freely floating within one  second, thereby losing the precision of the receiver. [Accurate time](https://www.ntp.org/ntpfaq/ntp-s-algo/#5131-how-accurate-will-my-clock-be) is needed in the receiver to calculate the exact position.
GPS，即全球定位系统，是一种基于卫星的导航辅助设备，最初在美国开发用于军事用途，可以为接收器提供有关当前位置、高度和时间的准确数据。不幸的是，这些接收器中的许多在设计时都没有考虑到准确的计时。因此，串行数据流中提供的时间信息有时会在一秒钟内自由浮动，从而失去接收器的精度。接收器需要准确的时间来计算确切的位置。

Fortunately there are also receivers that were designed for precision timekeeping. Among these are:
幸运的是，还有一些专为精确计时而设计的接收器。其中包括：

**Table 7.2a: Supported GPS receivers
表 7.2a.. 支持的 GPS 接收器**

| Manufacturer 制造者                           | Model                                           | Driver/Mode 驱动程序/模式                                    | Interface 接口                     | PPS available 提供缴费灵 |
| --------------------------------------------- | ----------------------------------------------- | ------------------------------------------------------------ | ---------------------------------- | ------------------------ |
| Arbiter 仲裁人                                | 1088A/B 1088A/乙                                | [11](https://www.ntp.org/documentation/drivers/driver11/)    | serial; 9600 baud 串行;9600 波特率 | Y                        |
| Austron 奥斯特朗                              | GPS-AS2201                                      | [10](https://www.ntp.org/documentation/drivers/driver10/)    | serial; 9600 baud 串行;9600 波特率 | Y                        |
| Garmin Garmin的                               | GPS35(25) 全球定位系统35（25）                  | [20](https://www.ntp.org/documentation/drivers/driver20/)    | serial, 4800 baud 串行，4800 波特  | Y (TTL) Y （TTL）        |
| [GPSclock GPS时钟](http://www.gpsclock.com/)  | 200                                             | [20](https://www.ntp.org/documentation/drivers/driver20/) (patched) 20 （已修补） | serial; 4800 baud 串行;4800 波特   | Y                        |
| Hewlett Packard 惠普                          | 58503A                                          | [26](https://www.ntp.org/documentation/drivers/driver26/)    | serial; 9600 baud 串行;9600 波特率 | Y                        |
| Magnavox 马格纳沃克斯                         | GPS-MX4200                                      | [9](https://www.ntp.org/documentation/drivers/driver9/)      | serial; 4800 baud 串行;4800 波特   | Y                        |
| [Meinberg 迈因伯格](https://www.meinberg.de/) | GPS166, GPS167 全球定位系统166、全球定位系统167 | [8](https://www.ntp.org/documentation/drivers/driver8/)      | serial; 9600 baud 串行;9600 波特率 | Y                        |
| Trak(?) 特拉克（？）                          | 8810, 8820                                      | [2](https://www.ntp.org/documentation/drivers/driver2/)      | serial; 9600 baud 串行;9600 波特率 | Y                        |
| Trimble 特林布尔                              | Acutime 2000a 敏锐度 2000 a                     | [8](https://www.ntp.org/documentation/drivers/driver8/), [10](https://www.ntp.org/documentation/drivers/driver10/), [29](https://www.ntp.org/documentation/drivers/driver29/) | TSIP                               | Y (TTL) Y （TTL）        |
| Trimble 特林布尔                              | Palisadeb 栅栏 b                                | [8](https://www.ntp.org/documentation/drivers/driver8/), [10](https://www.ntp.org/documentation/drivers/driver10/), [29](https://www.ntp.org/documentation/drivers/driver29/) | serial; 串行;                      | ?                        |
| Trimble 特林布尔                              | SV6b SV6 b 型                                   | [8](https://www.ntp.org/documentation/drivers/driver8/), [9](https://www.ntp.org/documentation/drivers/driver9/), [10](https://www.ntp.org/documentation/drivers/driver10/) | TAIP, TSIP TAIP、TSIP              | Y                        |

**a** This SmartAntenna is the replacement for both, the SV6 and the  Palisade.
 a 这款 SmartAntenna 是 SV6 和 Palisade 的替代品。

**b** The device is no longer manufactured.
 b 该设备不再生产。

------

#### 7.2.2 What are PDOP, TDOP, and GDOP? 7.2.2 什么是 PDOP、TDOP 和 GDOP？

These dilution parameters qualify the accuracy of a GPS receiver. The  following is a translation of an explanation given by Martin Burnicki:  “The *dilution* values have no units, and they are computed from the position of the  satellites relative to the position of the receiver’s antenna. Small  values express high precision. The values are computed using an  inversion of a 4x4 matrix containing the cosinus values of the angles  between the antenna and the satellites. There are four values `dx`, `dy`, `dz`, and `dt` that contribute to the dilution values in the following manner:”
这些稀释参数限定了 GPS 接收器的精度。以下是马丁·伯尼基（Martin  Burnicki）给出的解释的翻译：“稀释值没有单位，它们是根据卫星相对于接收器天线位置的位置计算得出的。小值表示高精度。这些值是使用 4x4  矩阵的反转计算的，该矩阵包含天线和卫星之间角度的余弦值。有四个值 `dx` 、 `dy` 、 `dz` 和 `dt` 以下列方式对稀释值有贡献：”

**Table 7.2b: Dilution of Precision
表 7.2b：精密度稀释**

| Parameter 参数  | Value 价值                                                   |
| --------------- | ------------------------------------------------------------ |
| Horizontal 水平 | HDOP = sqrt(dx^2 + dy^2) HDOP = 平方（dx ^ 2 + dy ^ 2）      |
| Vertical 垂直   | VDOP = dz                                                    |
| Position 位置   | PDOP = sqrt(dx^2 + dy^2 + dz^2) PDOP = 平方（dx ^ 2 + dy ^ 2 + dz ^ 2） |
| Time 时间       | TDOP = dt                                                    |
| General 常规    | GDOP = sqrt(dx^2 + dy^2 + dz^2 + dt^2) GDOP = 平方（dx ^ 2 + dy ^ 2 + dz ^ 2 + dt ^ 2） |

------

#### 7.2.3 What is NMEA? 7.2.3 什么是NMEA？

Many GPS receivers use a standardized format of output called [NMEA 0183](https://en.wikipedia.org/wiki/NMEA_0183). The acronym stands for National Marine Electronics Association which  indicates the intended purpose of the protocol: the navigation of ships.
许多 GPS 接收器使用称为 NMEA 0183 的标准化输出格式。首字母缩略词代表国家海洋电子协会，表示该协议的预期目的：船舶航行。

NMEA defines several message types, each message being an ASCII string transmitted at 4800 baud. Each message starts with `$` char and ends with `<CR><LF>`. A five-digit message identifier (for instance `$GPRMC`) specifies source and type of the message. Parameters for that message are separated by a `,` (comma).
NMEA 定义了几种消息类型，每种消息都是以 4800 波特率传输的 ASCII 字符串。每条消息都以 `$` char 开头，以 `<CR><LF>` .五位消息标识符（例如 `$GPRMC` ）指定消息的来源和类型。该消息的参数用逗 `,` 号分隔。

For the purpose of keeping time, the `GPRMC` (GPS recommended minimum data) message contains the current time in  second resolution, receiver status, latitude, longitude, speed over  ground, heading (track), date, magnetic variation in degrees, and a  checksum. That message is either sent automatically every second, or  upon request.
为了保持时间， `GPRMC` （GPS 建议的最小数据）消息包含以秒分辨率表示的当前时间、接收机状态、纬度、经度、地面速度、航向（航迹）、日期、以度为单位的磁变化和校验和。该消息要么每秒自动发送一次，要么根据请求发送。

Message type `GPGSA` contains the receiver’s mode, number of satellites, and quality of the  solution (dilution of precision, DOP). Precise information about the  position can be found in the `GPGGA` message.
消息类型 `GPGSA` 包含接收方的模式、卫星数量和解决方案的质量（精度稀释，DOP）。有关该职位的准确信息可以在 `GPGGA` 消息中找到。

NMEA is commonly used together with [PPS](https://www.ntp.org/ntpfaq/ntp-s-algo-kernel/#523-pps-processing) because the messages seem to be sent with low accuracy regarding the start of a second.
NMEA 通常与 PPS 一起使用，因为消息似乎在一秒钟的开始时以低精度发送。

------

#### 7.2.4 What is TSIP? 7.2.4 什么是TSIP？

TSIP stands for Trimble Standard Interface Protocol, and it is used in products from [Trimble](https://www.trimble.com/en). The documented binary protocol exchanges packets over serial lines.  This allows embedded devices to be monitored, queried and controlled  exclusively by TSIP, not needing any switches or displays.
TSIP 代表 Trimble 标准接口协议，它用于 Trimble 的产品中。记录的二进制协议通过串行线路交换数据包。这允许嵌入式设备仅由TSIP监控、查询和控制，而不需要任何开关或显示器。

------

#### 7.3 DCF77 Receivers 7.3 DCF77接收器

#### 7.3.1 What should I know about DCF77 Receivers? 7.3.1 关于 DCF77 接收器，我应该了解什么？

In comparison to GPS, DCF77 receivers are inexpensive and they don’t need an antenna with a view at the sky.
与 GPS 相比，DCF77 接收器价格低廉，而且不需要可以看到天空的天线。

Germany has a highly accurate clock and a long-wave transmitter that sends out  time data at 77.5kHz. This service is commonly known as DCF77. Time is  taken from the German UTC contributor [PTB](https://www.ptb.de/cms/en.html) (Physikalisch Technische Bundesanstalt) in Braunschweig. The sender  located in Mainflingen (50:01N 9:00E) (near Frankfurt am Main) can be  received even in a distance of up to 1000km as the waves easily pass  obstacles in the line of sight. The delay of the signal, a few  milliseconds, caused by the distance between transmitter and receiver  should be compensated manually.
德国拥有高精度时钟和长波发射器，可以 77.5kHz 的频率发送时间数据。此服务通常称为 DCF77。时间取自布伦瑞克的德国UTC贡献者PTB（Physikalisch  Technische Bundesanstalt）。位于Mainflingen（50：01N  9：00E）（美因河畔法兰克福附近）的发送者甚至可以在长达1000公里的距离内接收，因为海浪很容易通过视线中的障碍物。由发射器和接收器之间的距离引起的信号延迟（几毫秒）应手动补偿。

Since the demodulation of the time signal can be done easily using cheap  receivers, these receivers are quite popular in Germany. Receivers are  typically powered from a serial port. The output signal carries pulses  of 100 and 200ms, starting at the beginning of a second, and encoding  one bit. There is no pulse for the last second of each minute. Those can be fed into an UART that decodes the pulses as characters received at  50 baud. The best signal quality can be achieved if the antenna of the  receiver is oriented tangential to the transmitter’s antenna.
由于使用廉价的接收器可以很容易地对时间信号进行解调，因此这些接收器在德国非常受欢迎。接收器通常由串行端口供电。输出信号携带 100 和 200  毫秒的脉冲，从一秒开始，编码一位。每分钟的最后一秒没有脉搏。这些可以被输入到UART中，该UART将脉冲解码为以50波特接收的字符。如果接收机的天线与发射机的天线相切，则可以获得最佳信号质量。

Because of the simple AM modulation, the demodulation is sensitive to spikes  and varying receive conditions. Accuracy is typically only around 3ms.  Trying to make the resolution higher will increase the receiver’s  sensitivity to noise and spikes. There’s also a FM modulation  (pseudo-random phase noise) in the signal that can be decoded by  sophisticated and expensive receivers. These receivers can achieve a  resolution of 50μs.
由于AM调制简单，解调对尖峰和不同的接收条件很敏感。精度通常只有 3 毫秒左右。尝试提高分辨率会增加接收器对噪声和尖峰的灵敏度。信号中还有一个FM调制（伪随机相位噪声），可以由复杂而昂贵的接收器解码。这些接收器可以达到50μs的分辨率。

> As [Mark Martinec](mailto:mark.martinec@ijs.si) points out, it’s actually PSK (phase shift keying). Refer to [Time and Frequency Dissemination with DCF77](https://www.ptb.de/cms/fileadmin/internet/fachabteilungen/abteilung_4/4.4_zeit_und_frequenz/pdf/2011_PTBMitt_50a_DCF77_engl.pdf) for the technical details.
> 正如 Mark Martinec 所指出的，它实际上是 PSK（相移键控）。有关技术详细信息，请参阅使用 DCF77 的时间和频率传播。

The data format transmits 59 bits per minute: one every second, except for  the last second of the minute. Therefore it takes at least one minute  until the time and date have been successfully transmitted. As the data  format has little redundancy, most receivers wait until two consistent  time messages have been decoded without error. Typically it takes  between two and three minutes until the receiver is synchronized.
数据格式每分钟传输 59 位：每秒传输 1 位，最后一秒除外。因此，在成功传输时间和日期之前，至少需要一分钟。由于数据格式几乎没有冗余，因此大多数接收方会等到两条一致的时间消息被解码而没有错误。通常，接收器需要两到三分钟才能同步。

------

#### 7.3.2 What can make my DCF77 Receiver fail? 7.3.2 什么会导致我的 DCF77 接收器出现故障？

Occasionally the huge antenna and its backup are turned off for maintenance. There  are a few other reasons why DCF77 reception may be impossible. The  following list possibly applies to other low-frequency receivers (like  MSF) as well:
有时，巨大的天线及其备份会因维护而关闭。DCF77 接收可能是不可能的还有其他一些原因。以下列表可能也适用于其他低频接收器（如 MSF）：

- The sending antenna may be turned off during thunderstorms to avoid the risk of electrical damage.
  在雷雨天气期间，发送天线可能会关闭，以避免电气损坏的风险。

- Lightning itself may cause spikes on the received signal.
  闪电本身可能会导致接收信号出现尖峰。

- High-power devices like refrigerators or ovens may cause spikes on the received signal when turned on or off.
  冰箱或烤箱等高功率设备在打开或关闭时可能会导致接收信号出现尖峰。

- Changes in the atmosphere or ionosphere, especially during sunrise and sunset, can influence the signal.
  大气或电离层的变化，特别是在日出和日落期间，会影响信号。

- Electrical equipment close to the receiver’s antenna may distort the signal. Such equipment can be:

  
  靠近接收器天线的电气设备可能会使信号失真。此类设备可以是：

  - video recorders (even when operating in standby mode)
    录像机（即使在待机模式下运行）
  - TV sets 电视机
  - computer monitors operating at lower resolutions; specifically multi-sync  monitors when switching frequencies can cause short spikes on the signal
    以较低分辨率运行的计算机显示器;具体而言，当开关频率可能导致信号出现短尖峰时，多同步监视器
  - uninterruptible power supplies (especially those made by MGE UPS Systems, like the Comet S31 10kVA)
    不间断电源（尤其是MGE UPS系统制造的电源，如Comet S31 10kVA）
  - switching power supplies (operating near 60kHz)
    开关电源（工作频率接近60kHz）

- Metal parts close to the ferrite loopstick may detune it.
  靠近铁氧体环的金属部件可能会使其失谐。

- Huge metal constructions can have a negative impact on the signal reception inside (Faraday shield).
  巨大的金属结构会对内部的信号接收产生负面影响（法拉第盾）。

------

#### 7.4 Other Receivers 7.4 其他接收器

#### 7.4.1 What can make my MSF Receiver fail? 7.4.1 什么会导致我的 MSF 接收器出现故障？

See [Q: 7.3.2](https://www.ntp.org/ntpfaq/ntp-s-refclk/#732-what-can-make-my-dcf77-receiver-fail) for some basics.
有关一些基础知识，请参见问：7.3.2。

------

#### 7.4.2 How can I find a low-cost Receiver for Low-Frequency Transmissions? 7.4.2 如何找到用于低频传输的低成本接收器？

[Markus Kuhn](mailto:mgk25@cl.cam.ac.uk) has set up a [page](https://www.cl.cam.ac.uk/~mgk25/time/lf-clocks/) describing low-frequency time standards (WWVB, MSF, DCF77) and receiver designs.
马库斯·库恩（Markus Kuhn）建立了一个页面，描述了低频时间标准（WWVB，MSF，DCF77）和接收机设计。

------

#### 7.5 Products 7.5 产品

This section will provide rudimentary resources to find a reference clock for NTP.
本节将提供基本资源，以查找 NTP 的参考时钟。

------

#### 7.5.1 Where can I find a reference clock for NTP? 7.5.1 在哪里可以找到NTP的参考时钟？

The easiest way to find a suitable reference clock seems to be the following:
找到合适的参考时钟的最简单方法似乎如下：

- Use one of the models mentioned in the documentation or [Table 7.2a](https://www.ntp.org/ntpfaq/ntp-s-refclk/#721-what-should-i-know-about-various-gps-receivers).
  使用文档或表 7.2a 中提到的模型之一。
- Use a model that someone else is already using with success.
  使用其他人已经成功使用的模型。

# 8. Troubleshooting 8. 故障排除

Last update: June 27, 2022 16:22 UTC ([1a7aee0a0](https://git.nwtime.org/websites/ntpwww/commit/1a7aee0a0bed1662a9f219fcaea42e57cff5d0b3))
最后更新： 2022年6月27日 16：22 UTC （ 1a7aee0a0）

If you have set up your software, you usually want to know whether it  works. This section discusses topics related to configuration,  monitoring, troubleshooting, and debugging of NTP.
如果您已经设置了软件，您通常想知道它是否有效。本节讨论与 NTP 的配置、监视、故障排除和调试相关的主题。

8.1 [Monitoring](https://www.ntp.org/ntpfaq/ntp-s-trouble/#81-monitoring) 8.1 监控
 8.1.1 [How do I confirm my NTP server is working fine?](https://www.ntp.org/ntpfaq/ntp-s-trouble/#811-how-do-i-confirm-my-ntp-server-is-working-fine)
8.1.1 如何确认我的NTP服务器工作正常？
 8.1.2 [How do I use peerstats and loopstats?](https://www.ntp.org/ntpfaq/ntp-s-trouble/#812-how-do-i-use-peerstats-and-loopstats)
8.1.2 如何使用 peerstats 和 loopstats？
 8.1.3 [How can I see the Time Difference between Client and Server?](https://www.ntp.org/ntpfaq/ntp-s-trouble/#813-how-can-i-see-the-time-difference-between-client-and-server)
8.1.3 如何查看客户端和服务器之间的时差？
 8.1.4 [What does 257 mean as value for reach?](https://www.ntp.org/ntpfaq/ntp-s-trouble/#814-what-does-257-mean-as-value-for-reach)
8.1.4 257 作为覆盖面价值是什么意思？
 8.1.5 [How do I use statistics files?](https://www.ntp.org/ntpfaq/ntp-s-trouble/#815-how-do-i-use-statistics-files)
8.1.5 如何使用统计文件？

------

#### 8.1 Monitoring 8.1 监控

Without any doubt, troubleshooting requires monitoring. Somehow you must find  out that something is wrong before you wonder how to fix it.
毫无疑问，故障排除需要监控。不知何故，您必须先发现有问题，然后才能想知道如何解决它。

------

#### 8.1.1 How do I confirm my NTP server is working fine? 8.1.1 如何确认我的NTP服务器工作正常？

One of the quickest commands to verify that `ntpd` is still up and running is `ntpq -p`. That command will show all configured peers together with their performance data.
验证是否 `ntpd` 仍在启动和运行的最快命令之一是 `ntpq -p` 。该命令将显示所有已配置的对等体及其性能数据。

As the above command requires periodic invocation to monitor performance, it is also recommended to enable statistic files in `ntpd`.
由于上述命令需要定期调用来监视性能，因此还建议在 `ntpd` 中启用统计信息文件。

------

#### 8.1.2 How do I use peerstats and loopstats? 8.1.2 如何使用 peerstats 和 loopstats？

I use the following lines in `/etc/ntp.conf` to enable loopfilter statistics. New files are created every day, and the current files are available as `/var/log/ntp/peers` and `/var/log/ntp/loops`. Older files are archived as `/var/log/ntp/peers*YYYYMMDD*` and `/var/log/ntp/loops.*YYYYMMDD*`:
我使用以下行 `/etc/ntp.conf` 来启用循环过滤器统计信息。每天都会创建新文件，当前文件以 `/var/log/ntp/peers` 和 `/var/log/ntp/loops` 的形式提供。较旧的文件存档为 `/var/log/ntp/peers*YYYYMMDD*` 和 `/var/log/ntp/loops.*YYYYMMDD*` ：

```
statistics loopstats
statsdir /var/log/ntp/
filegen peerstats file peers type day link enable
filegen loopstats file loops type day link enable
```

Usually I only monitor the `loops` file. Table 8.1a lists the individual fields of each file.
通常我只监控 `loops` 文件。表 8.1a 列出了每个文件的各个字段。

**Table 8.1a: Statistic Files
表 8.1a.. 统计信息文件**

| File Type 文件类型 | List of Fields 字段列表                                      |
| ------------------ | ------------------------------------------------------------ |
| `loopstats`        | day, second, offset, drift compensation, estimated error, stability, polling interval 日、秒、偏移、漂移补偿、估计误差、稳定性、轮询间隔 |
| `peerstats`        | day, second, address, status, offset, delay, dispersion, skew (variance) 天、秒、地址、状态、偏移量、延迟、离散、偏斜（方差） |

------

#### 8.1.3 How can I see the Time Difference between Client and Server? 8.1.3 如何查看客户端和服务器之间的时差？

(By [Terje Mathisen](mailto:Terje.Mathisen@hda.hydro.com)) Normally `ntpd` maintains an estimate of the time offset. To inspect these offsets, you can use the following commands:
（作者：Terje Mathisen）通常 `ntpd` 保持对时间偏移的估计。若要检查这些偏移量，可以使用以下命令：

- `ntpq -p` will display the offsets for each reachable server in milliseconds (`ntpdc -p` uses seconds instead).
   `ntpq -p` 将以毫秒为单位显示每个可访问服务器的偏移量（ `ntpdc -p` 改用秒）。
- `ntpdc -c loopinfo` will display the combined offset in seconds, as seen at the last poll. If supported, `ntpdc -c kerninfo` will display the current remaining correction, just as `ntptime` does.
   `ntpdc -c loopinfo` 将在几秒钟内显示组合偏移量，如上次轮询所示。如果支持， `ntpdc -c kerninfo` 将显示当前剩余的校正，就像 `ntptime` 一样。

The first command can be used to check what `ntpd` thinks the offset and jitter is currently, relative to the  preferred/current server. The second command can tell you something  about the estimated offset/error all the way to the stratum 1 source. [Q: 8.1.2](https://www.ntp.org/ntpfaq/ntp-s-trouble/#812-how-do-i-use-peerstats-and-loopstats) describes a way to collect such data automatically.
第一个命令可用于检查 `ntpd` 相对于首选/当前服务器的当前偏移和抖动。第二个命令可以告诉您有关估计偏移/误差的信息，一直到第 1 层源。问：8.1.2 描述了一种自动收集此类数据的方法。

If a [PPS](https://www.ntp.org/ntpfaq/ntp-s-algo-kernel/#5231-what-is-pps-processing) source is [active](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#624-pps-synchronization), the offset displayed with the second choice is updated periodically, maybe every second.
如果 PPS 源处于活动状态，则显示的第二个选项的偏移量会定期更新，可能每秒更新一次。

Sometimes things are wrong and you may want to compare time offsets directly. An easy way is to use `ntpdate -d *server*` to compare the local system time with the time taken from `*server*`.
有时事情是错误的，您可能想直接比较时间偏移。一种简单的方法是将 `ntpdate -d *server*` 本地系统时间与从 获取 `*server*` 的时间进行比较。

------

#### 8.1.4 What does 257 mean as value for reach? 8.1.4 257 作为覆盖面价值是什么意思？

(Inspired by [Martin Burnicki](mailto:martin.burnicki@meinberg.de)) The value displayed in column `reach` is octal, and it represents the *reachability register*. One digit in the range of `0` to `7` represents three bits. The initial value of that register is `0`, and after every poll that register is shifted left by one position. If  the corresponding time source sent a valid response, the rightmost bit  is set.
（灵感来自Martin Burnicki）列 `reach` 中显示的值为八进制，表示可达性寄存器。 `0` to `7` 范围内的一位数字表示三位。该寄存器的初始值为 `0` ，每次轮询后，该寄存器都会向左移动一个位置。如果相应的时间源发送了有效的响应，则设置最右边的位。

During a normal startup the registers values are these: `0`, `1`, `3`, `7`, `17`, `37`, `77`, `177`, `377`
在正常启动期间，寄存器值如下： `0` 、、 `1` 、 `3` `7` `17` `37` `77` `177` `377` 

Thus `257` in the dual system is `10101111`, saying that two valid responses were not received during the last eight polls. However, the last four polls worked fine.
因此 `257` ，在双重系统中 `10101111` ，表示在过去八次民意调查中没有收到两个有效的回答。然而，最后四次民意调查运作良好。

------

#### 8.1.5 How do I use statistics files? 8.1.5 如何使用统计文件？

You can do a lot of useful things with statistic files before you remove them. For example there is a utility named `summary.pl` written in Perl to compute mean values and standard deviation (RMS)  from the loopfilter and peer statistics. It will also show exceptional  conditions found in these files. Here’s a short example output of `summary.pl --dir=/var/log/ntp --start=19990518 --end=19990604`:
在删除统计信息文件之前，您可以对它们执行许多有用的操作。例如，有一个用 Perl 编写的名为 `summary.pl` Utility 的实用程序，用于计算 loopfilter 和对等统计数据的平均值和标准差 （RMS）。它还将显示在这些文件中发现的特殊情况。下面是一个简短的示例输出 `summary.pl --dir=/var/log/ntp --start=19990518 --end=19990604` ：

```
loops.19990518
loop 110, -30+/-36.5, rms 6.7, freq 14.95+/-1.149, var 0.612
loops.19990519
loop 113, -26+/-40.3, rms 6.9, freq 12.95+/-3.240, var 1.378
loops.19990520
loop 107, -7+/-32.0, rms 5.7, freq 13.04+/-3.253, var 1.579
loops.19990522
loop 190, 3+/-18.5, rms 2.9, freq 15.48+/-3.715, var 0.604
loops.19990523
loop 146, -5+/-9.2, rms 1.9, freq 15.77+/-0.716, var 0.305
loops.19990604
loop 73, -27+/-29.8, rms 6.9, freq 16.81+/-0.327, var 0.140
```

Still another utility named `plot_summary.pl` can be used to make plots with these summary data. As an alternative you could plot the loopfilter file directly with `gnuplot` using the command `plot "/var/log/ntp/loops"` using 2:3 with linespoints.
还有另一个名为的 `plot_summary.pl` 实用程序可用于使用这些汇总数据绘制图。或者，您可以使用带有线点的 2：3 命令 `plot "/var/log/ntp/loops"` 直接 `gnuplot` 绘制 loopfilter 文件。

> [The “GNU” in gnuplot](http://www.gnuplot.info/faq/index.html#x1-70001.2) is NOT related to the Free Software Foundation, the naming is just a  coincidence (and a long story). Thus gnuplot is not covered by the Gnu  copyleft, but rather by its own copyright statement, included in all  source code files.
> gnuplot 中的“GNU”与自由软件基金会无关，命名只是一个巧合（而且说来话长）。因此，gnuplot 不受 Gnu copyleft 的约束，而是包含在所有源代码文件中的自己的版权声明。

Figure 8.1a was produced with a little more complicated command. It shows `yerrorbars` with the estimated errors for offset and frequency respectively.
图 8.1a 是使用稍微复杂的命令生成的。它分别 `yerrorbars` 显示了偏移和频率的估计误差。

**Figure 8.1a: Plot of estimated Offset and Frequency Error (DCF77)
图 8.1a：估计失调和频率误差图 （DCF77）**



  ![img](https://www.ntp.org/ntpfaq/loopstat.png)



The reference clock, the antenna, and the computer system were located in an office room without air conditioning.
参考时钟、天线和计算机系统位于没有空调的办公室内。

Now that we are looking at numbers and graphs, let us compare the data of a GPS clock (using PPS) with a typical low-cost clock (not using PPS).  Figure 8.1b shows a very small offset for the GPS clock. The frequency  is continuously adjusted. In comparison, the DCF77 clock shows a high  variation for the offset, but the frequency is adjusted less  drastically. Figure 8.1a shows values between those, using a better  DCF77 receiver with PPS.
现在我们正在查看数字和图表，让我们将 GPS 时钟（使用 PPS）的数据与典型的低成本时钟（不使用 PPS）进行比较。图 8.1b 显示了 GPS  时钟的非常小的偏移量。频率不断调整。相比之下，DCF77时钟的偏移变化很大，但频率调整幅度较小。图 8.1a 显示了使用更好的带 PPS 的  DCF77 接收器时的这些值。

**Figure 8.1b: Comparing Offset and Frequency Error of DCF77 and GPS
图 8.1b.. 比较 DCF77 和 GPS 的偏移和频率误差**



  ![img](https://www.ntp.org/ntpfaq/GPSvsDCF.png)





# 8.2. General Issues 8.2. 一般问题

Last update: April 3, 2024 16:42 UTC ([f170361b7](https://git.nwtime.org/websites/ntpwww/commit/f170361b72193f7af81935c6c0a4afda96793f0d))
最后更新： 2024年4月3日 16：42 UTC （ f170361b7）

This section discusses problems that are independent of a specific operating system.
本节讨论与特定操作系统无关的问题。

8.2.1 [Starting, running, querying](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#821-starting-running-querying)
8.2.1 启动、运行、查询
 8.2.1.1 [How can I check that ntpd is up and running?](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#8211-how-can-i-check-that-ntpd-is-up-and-running)
8.2.1.1 如何检查 ntpd 是否已启动并运行？
 8.2.1.2 [Why does ntpd only run for about 10 to 20 minutes??](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#8212-why-does-ntpd-only-run-for-about-10-to-20-minutes)
8.2.1.2 为什么 ntpd 只运行大约 10 到 20 分钟？
 8.2.2 [Cabling and Interfacing](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#822-cabling-and-interfacing)
8.2.2 布线和接口
 8.2.2.1 [Why does my Serial Interface hang when I connect a PPS Signal to DCD?](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#8221-why-does-my-serial-interface-hang-when-i-connect-a-pps-signal-to-dcd)
8.2.2.1 为什么将PPS信号连接到DCD时串行接口挂起？
 8.2.2.2 [Why is the PPS API only detecting one Edge?](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#8222-why-is-the-pps-api-only-detecting-one-edge)
8.2.2.2 为什么 PPS API 只检测一个 Edge？
 8.2.3 [Exchanging Time](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#823-exchanging-time) 8.2.3 交换时间
 8.2.3.1 [Is a remote server providing time?](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#8231-is-a-remote-server-providing-time)
8.2.3.1 远程服务器是否提供时间？
 8.2.3.2 [My server is up and running, but it is unusable for clients](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#8232-my-server-is-up-and-running-but-it-is-unusable-for-clients)
8.2.3.2 我的服务器已启动并运行，但对客户端不可用 
 8.2.4 [Cryptography](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#824-cryptography) 8.2.4 密码学
 8.2.4.1 [No time received when using autokey](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#8241-no-time-received-when-using-autokey)
8.2.4.1 使用自动密钥时未收到时间
 8.2.5 [Time Errors](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#825-time-errors) 8.2.5 时间错误
 8.2.5.1 [Why does my server change time references quite frequently?](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#8251-why-does-my-server-change-time-references-quite-frequently)
8.2.5.1 为什么我的服务器经常更改时间参考？
 8.2.5.2 [My server periodically loses synchronization](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#8252-my-server-periodically-loses-synchronization)
8.2.5.2 我的服务器周期性失去同步
 8.2.5.3 [Why does my system step several times a day?](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#8253-why-does-my-system-step-several-times-a-day)
8.2.5.3 为什么我的系统一天要走好几次？
 8.2.6 [Other](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#826-other) 8.2.6 其他
 8.2.6.1 [How do I set the correct value for tick?](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#8261-how-do-i-set-the-correct-value-for-tick)
8.2.6.1 如何设置正确的刻度值？
 8.2.6.2 [How do I set the precision?](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#8262-how-do-i-set-the-precision)
8.2.6.2 如何设置精度？
 8.2.6.3 [ntpd periodically opens a dial-out connection. Can I avoid that?](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#8263-ntpd-periodically-opens-a-dial-out-connection-can-i-avoid-that)
8.2.6.3 NTPD 定期打开拨出连接。我能避免这种情况吗？
 8.2.6.4 [Any more Hints?](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#8264-any-more-hints)
8.2.6.4 还有什么提示吗？
 8.2.7 [Errors and Warnings](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#827-errors-and-warnings)
8.2.7 错误和警告
 8.2.7.1 [ntpq: read: connection refused](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#8271-ntpq-read-connection-refused)
8.2.7.1 NTPQ：读取：连接被拒绝
 8.2.7.2 [127.0.0.1: timed out, nothing received, Request timed out](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#8272-127001-timed-out-nothing-received-request-timed-out)
8.2.7.2 127.0.0.1：超时，未收到任何消息，请求超时
 8.2.7.3 [ntpdate: no server suitable for synchronization found](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#8273-ntpdate-no-server-suitable-for-synchronization-found)
8.2.7.3 ntpdate：未找到适合同步的服务器
 8.2.7.4 [configure: keyword “precision” unknown, line ignored](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#8274-configure-keyword-precision-unknown-line-ignored)
8.2.7.4 配置：关键字“precision”未知，行忽略
 8.2.7.5 [Previous time adjustment didn’t complete](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#8275-previous-time-adjustment-didnt-complete)
8.2.7.5 上一次时间调整未完成
 8.2.7.6 [sendto: Overlapped I/O operation is in progress.](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#8276-sendto-overlapped-io-operation-is-in-progress)
8.2.7.6 sendto：正在执行重叠的 I/O 操作。

------

#### 8.2.1 Starting, running, querying 8.2.1 启动、运行、查询

#### 8.2.1.1 How can I check that ntpd is up and running? 8.2.1.1 如何检查 ntpd 是否已启动并运行？

The easiest command to verify that `ntpd` is still running is `ntpq -p`. This command will contact `ntpd` on the local host, and it will list all configured servers together with some health status. If `ntpd` is not running, the typical error message is `ntpq: read: Connection refused`.
验证是否 `ntpd` 仍在运行的最简单命令是 `ntpq -p` 。此命令将在本地主机上联系 `ntpd` ，并将列出所有已配置的服务器以及一些运行状况。如果 `ntpd` 未运行，则典型的错误消息为 `ntpq: read: Connection refused` 。

If your are logged in to a UNIX machine, you can use `ps` to look for the daemon.
如果您登录到 UNIX 计算机，则可以使用它来 `ps` 查找守护程序。

------

#### 8.2.1.2 Why does ntpd only run for about 10 to 20 minutes? 8.2.1.2 为什么 ntpd 只运行大约 10 到 20 分钟？

`ntpd` expects that the system time has been set closely to the real time, for example by using `ntpdate`. If the [reference time is significantly off](https://www.ntp.org/ntpfaq/ntp-s-algo/#5114-what-happens-if-the-reference-time-changes), `ntpd` waits up to 20 minutes until it sets the time.
 `ntpd` 期望系统时间已设置得与实时时间非常接近，例如通过使用 `ntpdate` .如果参考时间明显偏离， `ntpd` 则最多等待 20 分钟，直到设置时间。

However, if the time is off by more than some magic amount of roughly 20 minutes, `ntpd` refuses to set the system time, and it terminates instead. To confirm what is going on, look into `syslog` or into the logfile you configured.
但是，如果时间偏离了大约 20 分钟的神奇量， `ntpd` 则拒绝设置系统时间，而是终止。若要确认正在发生的情况，请查看 `syslog` 或查看您配置的日志文件。

Either set your system clock with `ntpdate` before starting `ntpd`, or try the `-g` switch for `ntpd`. Or just set the time manually.
在启动之前设置系统时钟， `ntpdate` 或尝试 `-g` 切换 `ntpd` 。 `ntpd` 或者只是手动设置时间。

------

#### 8.2.2 Cabling and Interfacing 8.2.2 布线和接口

#### 8.2.2.1 Why does my Serial Interface hang when I connect a PPS Signal to DCD? 8.2.2.1 为什么将PPS信号连接到DCD时串行接口挂起？

Sometimes drivers misinterpret the meaning of DCD to be a MODEM status. When using the `stty -a` command, the port used should have `clocal` set (preferrably together with `-hupcl`). When using a standard modem cable, make sure that the DCD pin is not connected to some other output of the reference clock.
有时，驾驶员会将 DCD 的含义误解为 MODEM 状态。使用该 `stty -a` 命令时，使用的端口应已 `clocal` 设置（最好与 `-hupcl` 一起设置）。使用标准调制解调器电缆时，请确保 DCD 引脚未连接到参考时钟的其他输出。

------

#### 8.2.2.2 Why is the PPS API only detecting one Edge? 8.2.2.2 为什么 PPS API 只检测一个 Edge？

First, the PPS API is not required to provide an implementation that can detect both edges of a pulse. See function `time_pps_getcap()` in the description of the API.
首先，不需要 PPS API 来提供可以检测脉冲两个边沿的实现。请参阅 API 描述中的函数 `time_pps_getcap()` 。

Second, the hardware [may not be responding fast enough](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6246-what-is-the-shortest-width-for-a-pulse-connected-to-the-dcd-pin-of-an-rs-232-interface) about timing on a serial port.
其次，硬件对串行端口上的时序响应速度可能不够快。

Finally, even if the hardware can send an interrupt for the edge being detected  first, the CPU may be still busy handling the interrupt when the  hardware detects the other edge. That may cause the second interrupt to  be missed, or the interrupt handler being called for the first interrupt sees a hardware state that corresponds to the second interrupt  condition, thereby reporting the wrong event and ignoring the edge that  originally triggered the interrupt.
最后，即使硬件可以为首先检测到的 Edge 发送中断，当硬件检测到另一个 Edge 时，CPU  可能仍在忙于处理中断。这可能会导致错过第二个中断，或者为第一个中断调用的中断处理程序看到与第二个中断条件相对应的硬件状态，从而报告错误事件并忽略最初触发中断的边缘。

------

#### 8.2.3 Exchanging Time 8.2.3 交换时间

#### 8.2.3.1 Is a remote server providing time? 8.2.3.1 远程服务器是否提供时间？

The procedure to check a remote server is identical to debugging a local  server, but some commands may be restricted. To check a remote server  with `ntpq`, add the desired host name or IP address to the command line.
检查远程服务器的过程与调试本地服务器的过程相同，但某些命令可能会受到限制。要检查 `ntpq` 远程服务器，请将所需的主机名或 IP 地址添加到命令行。

There is another command named `ntptrace` to follow a complete synchronization path from the local or specified server to the reference clock. [ntptrace](https://www.ntp.org/documentation/4.2.8-series/ntptrace/) provides a usage example and explanation of the trace output.
还有另一个名为 `ntptrace` “遵循从本地或指定服务器到参考时钟的完整同步路径”的命令。ntptrace 提供了跟踪输出的使用示例和说明。

------

#### 8.2.3.2 My server is up and running, but it is unusable for clients 8.2.3.2 我的服务器已启动并运行，但对客户端不可用

Probably you have made no mistakes, but simply have to wait for about five  minutes until the server synchronizes to a time reference for the first  time. If you changed the `minpoll` parameter, the wait time may change accordingly.
可能您没有犯任何错误，只需等待大约五分钟，直到服务器第一次同步到时间参考。如果更改了 `minpoll` 参数，等待时间可能会相应更改。

If you have waited for more than 20 minutes since starting `ntpd`, it’s time to monitor `ntpd`. First, verify the daemon is [still running](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#8211-how-can-i-check-that-ntpd-is-up-and-running). Check `syslog` for messages from `ntpd`. Log messages are influenced by the `logconfig` statement in `/etc/ntp.conf` and by`/etc/syslog.conf`.
如果自启动 `ntpd` 以来已经等待了 20 分钟以上，是时候监控 `ntpd` 了。首先，验证守护程序是否仍在运行。检查 `syslog` 来自 `ntpd` 的消息。日志消息受 in `/etc/ntp.conf` 和 by `/etc/syslog.conf` 语 `logconfig` 句的影响。

If you still don’t know what’s going wrong, contact `ntpd` with `ntpq` and `ntpdc`. One of the easiest ways to get a first impression of the daemon’s status is:
如果您仍然不知道出了什么问题， `ntpd` 请联系 `ntpq` 和 `ntpdc` 。获得守护进程状态第一印象的最简单方法之一是：

1. Run `ntpq -p` on the host where `ntpd` is running, or specify the host name at the end of the command line for a remote host (`ntpq -p *hostname*`). This command will show the number and status of configured or used time references.
   在正在运行的 `ntpd` 主机上运行 `ntpq -p` ，或在命令行末尾指定远程主机的主机名 `ntpq -p *hostname*` （ ）。此命令将显示已配置或使用的时间引用的数量和状态。
2. Run `ntpq -c as` to see what `ntpd` thinks of these time references.
   运行 `ntpq -c as` 以查看这些时间参考的看法 `ntpd` 。

If the above does not explain your problem, use `ntpq -p` to quickly inspect configured time sources, reachability, delay, and dispersion. Reachability should be `377` (an octal value) for full reachability. The delay should be positive,  but small, depending on your network technology. Dispersion should be  below `1000` (1 second) for at least one server. One of the servers should be marked with a `*`.
如果上述方法不能解释您的问题，请用于 `ntpq -p` 快速检查配置的时间源、可达性、延迟和分散。可达性应为 `377` （八进制值）以获得完全可达性。延迟应该是正的，但很小，具体取决于您的网络技术。至少一台服务器的离散应低于 `1000` （1 秒）。其中一台服务器应标有 `*` .

Here’s an example from David Dalton:
以下是 David Dalton 的一个例子：

```
remote  refid   st t when poll reach   delay   offset    disp
=========================================================================
*WWVB_SPEC(1)  .WWVB.  0 l  114   64  377     0.00   37.623   12.77  
 relay.hp.com    listo 2 u  225  512  377     6.93   34.052   10.79  
 cosl4.cup.hp.co listo 2 u  226  512  377     4.18   29.385   13.21  
 paloalto.cns.hp listo 2 u  235  512  377     9.80   33.487   11.61  
 chelmsford.cns. listo 2 u  233  512  377    88.79   30.462    9.66  
 atlanta.cns.hp. listo 2 u  231  512  377    67.44   32.909   12.86  
 colorado.cns.hp listo 2 u  233  512  377    43.70   30.077   18.63  
 boise.cns.hp.co listo 2 u  224  512  377    33.42   31.682    8.54
```

------

#### 8.2.4 Cryptography 8.2.4 密码学

#### 8.2.4.1 No time received when using autokey 8.2.4.1 使用自动密钥时未收到时间

The first place to check is the system log file or (if configured) `ntpd`’s log file. Here’s a sample of successful configuration between `ltgpsdemo`, an external timeserver (Meinberg LANTIME) synchronized to GPS and PPS, and `elf`, a client running Linux with no kernel modifications (SUSE Linux 9.2). Right after startup, the client displays a `refid` of `.INIT.` like this:
首先要检查的是系统日志文件或（如果已配置） `ntpd` 的日志文件。下面是同步到 GPS 和 PPS 的外部时间服务器 （Meinberg LANTIME） 和 `elf` 运行 Linux 且未修改内核的客户端 （SUSE Linux 9.2） 之间的 `ltgpsdemo` 成功配置示例。启动后，客户端会立即显示如下 `refid` 所示： `.INIT.` 

```
ntpq> pe
     remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================
 GENERIC(1)      .GPS.            0 l    4   64    1    0.000   -0.719   0.001
 PPS(1)          .PPS.           16 l    -   64    0    0.000    0.000 4000.00
 ltgpsdemo       .INIT.          16 u    3   64    0    0.000    0.000 4000.00
ntpq>
```

The host key should be displayed with `rl` in `ntpq`:
主机键应显示 `rl` 在： `ntpq` 

```
ntpq> rl
assID=0 status=c027 sync_alarm, sync_unspec, 2 events, event_clock_excptn,
version="ntpd 4.2.0a@1.1190-r Fri Apr 29 11:06:00 UTC 2005 (1)"?,
processor="i686", system="Linux/2.6.8-24.17-default", leap=11,
stratum=16, precision=-20, rootdelay=0.000, rootdispersion=0.210,
peer=0, refid=INIT,
reftime=00000000.00000000  Thu, Feb  7 2036  7:28:16.000, poll=6,
clock=0xc6ab46c3.01a1016c, state=1, offset=0.000, frequency=100.730,
noise=0.001, jitter=0.001, stability=0.000, hostname="elf",
signature="md5WithRSAEncryption", flags=0x80001, hostkey=3333113513,
cert="elf elf 0x0 3333113513"
ntpq>
```

The details of the encryption status can be seen in the field `flash` when using the command `rl` on the desired association:
在所需关联上使用命令 `rl` 时，可以在字段 `flash` 中查看加密状态的详细信息：

```
ntpq> rl &3
assID=41910 status=e000 unreach, conf, auth, no events,
srcadr=ltgpsdemo, srcport=123, dstadr=10.0.0.2, dstport=123, leap=11,
stratum=16, precision=-20, rootdelay=0.000, rootdispersion=0.000,
refid=INIT, reach=000, unreach=1, hmode=3, pmode=0, hpoll=6, ppoll=10,
flash=400 not_proventic, keyid=817784215, ttl=0, offset=0.000,
delay=0.000, dispersion=0.000, jitter=4000.000,
reftime=00000000.00000000  Thu, Feb  7 2036  7:28:16.000,
org=c6ab46b7.85c91d14  Mon, Aug 15 2005 18:52:07.522,
rec=c6ab46b7.85e7210b  Mon, Aug 15 2005 18:52:07.523,
xmt=c6ab46b7.859ae924  Mon, Aug 15 2005 18:52:07.521,
filtdelay=     0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00,
filtoffset=    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00,
filtdisp=   16000.0 16000.0 16000.0 16000.0 16000.0 16000.0 16000.0 16000.0,
hostname="ltgpsdemo", signature="md5WithRSAEncryption", flags=0x80021,
identity="ltgpsdemo"
ntpq>
```

If everything works fine, the client should have received the server’s certificate after a while. Once again, use the command `rl` to check:
如果一切正常，客户端应该在一段时间后收到服务器的证书。再次使用命令 `rl` 检查：

```
ntpq> rl
(...)
signature="md5WithRSAEncryption", flags=0x80001, hostkey=3333113513,
cert="ltgpsdemo ltgpsdemo 0x3 3333112788",
cert="elf elf 0x1 3333113513"
ntpq>
```

Again, a little later, the `rl` should display a `flash` value of zero:
同样，稍后，应 `rl` 显示 `flash` 值为零：

```
ntpq> rl &3
assID=41910 status=f014 reach, conf, auth, 1 event, event_reach,
srcadr=ltgpsdemo, srcport=123, dstadr=10.0.0.2, dstport=123, leap=00,
stratum=1, precision=-18, rootdelay=0.000, rootdispersion=440.033,
refid=GPS, reach=001, unreach=3, hmode=3, pmode=4, hpoll=6, ppoll=6,
flash=00 ok, keyid=2001415940, ttl=0, offset=-0.417, delay=0.624,
dispersion=7937.503, jitter=0.001,
reftime=c6ab4708.097efe0c  Mon, Aug 15 2005 18:53:28.037,
org=c6ab473a.abebe165  Mon, Aug 15 2005 18:54:18.671,
rec=c6ab473a.ac1ba7fc  Mon, Aug 15 2005 18:54:18.672,
xmt=c6ab473a.a58b60f2  Mon, Aug 15 2005 18:54:18.646,
filtdelay=     0.62    0.00    0.00    0.00    0.00    0.00    0.00    0.00,
filtoffset=   -0.42    0.00    0.00    0.00    0.00    0.00    0.00    0.00,
filtdisp=      0.01 16000.0 16000.0 16000.0 16000.0 16000.0 16000.0 16000.0,
hostname="ltgpsdemo", signature="md5WithRSAEncryption",
valid="3333112795:3364648795", flags=0x80721, identity="ltgpsdemo"
ntpq>
```

Then `ntpq`’s command `pe` shows the usual `refid`:
然后 `ntpq` 的命令 `pe` 显示通常 `refid` 的：

```
ntpq> pe
     remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================
 GENERIC(1)      .GPS.            0 l   38   64    7    0.000   -1.193   0.528
 PPS(1)          .PPS.           16 l    -   64    0    0.000    0.000 4000.00
 ltgpsdemo       .GPS.            1 u   33   64    1    0.624   -0.417   0.001
ntpq>
```

Eventually the status displays will look like this:
最终，状态显示将如下所示：

```
ntpq> rl
assID=0 status=04b7 leap_none, sync_uhf_clock, 11 events, event_clock_excptn,
version="ntpd 4.2.0a@1.1190-r Fri Apr 29 11:06:00 UTC 2005 (1)"?,
processor="i686", system="Linux/2.6.8-24.17-default", leap=00,
stratum=1, precision=-20, rootdelay=0.000, rootdispersion=3.051,
peer=41908, refid=GPS,
reftime=c6ab5610.098298cc  Mon, Aug 15 2005 19:57:36.037, poll=10,
clock=0xc6ab562d.bc703298, state=4, offset=-0.437, frequency=99.839,
noise=0.147, jitter=0.203, stability=0.173, hostname="elf",
signature="md5WithRSAEncryption", flags=0x80001, hostkey=3333113513,
refresh=3333113784, cert="elf ltgpsdemo 0x3 3333113513",
cert="ltgpsdemo ltgpsdemo 0x3 3333112788",
cert="elf elf 0x3 3333113513"
ntpq> pe
     remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================
*GENERIC(1)      .GPS.            0 l   45   64  377    0.000   -0.437   0.203
 PPS(1)          .PPS.           16 l    -   64    0    0.000    0.000 4000.00
+ltgpsdemo       .PPS.            1 u  116  512  377    0.500    0.349   0.106
ntpq> as

ind assID status  conf reach auth condition  last_event cnt
===========================================================
  1 41908  9685   yes   yes  none  sys.peer  clock expt  8
  2 41909  8000   yes   yes  none    reject
  3 41910  f414   yes   yes   ok   candidat   reachable  1
ntpq> rl &3
assID=41910 status=f414 reach, conf, auth, sel_candidat, 1 event, event_reach,
srcadr=ltgpsdemo, srcport=123, dstadr=10.0.0.2, dstport=123, leap=00,
stratum=1, precision=-18, rootdelay=0.000, rootdispersion=2.289,
refid=PPS, reach=377, unreach=0, hmode=3, pmode=4, hpoll=10, ppoll=9,
flash=00 ok, keyid=3240968593, ttl=0, offset=0.349, delay=0.500,
dispersion=9.760, jitter=0.106,
reftime=c6ab55b0.fdf7e803  Mon, Aug 15 2005 19:56:00.992,
org=c6ab55c9.2f12b1b2  Mon, Aug 15 2005 19:56:25.183,
rec=c6ab55c9.2f1d4f9c  Mon, Aug 15 2005 19:56:25.184,
xmt=c6ab55c9.2edd0528  Mon, Aug 15 2005 19:56:25.183,
filtdelay=     0.55    0.62    0.50    0.54    0.54    0.58    0.54    0.56,
filtoffset=    0.11    0.26    0.35    0.36    0.38    0.42    0.43    0.40,
filtdisp=      0.00    3.84    7.71    9.65   11.55   13.46   14.45   15.42,
hostname="ltgpsdemo", signature="md5WithRSAEncryption",
valid="3333112795:3364648795", flags=0x83f21, identity="ltgpsdemo"
ntpq>
```

------

#### 8.2.5 Time Errors 8.2.5 时间错误

#### 8.2.5.1 Why does my server change time references quite frequently? 8.2.5.1 为什么我的服务器经常更改时间参考？

Ideally, the quality of a time reference is a static feature. In reality,  quality can vary over time. In fact this behaviour is so frequent that  it has a name of its own: *clock hopping*.
理想情况下，时间参考的质量是一个静态特征。实际上，质量会随着时间而变化。事实上，这种行为非常频繁，以至于它有自己的名字：时钟跳跃。

Clock hopping can be avoided by deterministic network delays, but usually you can’t do anything about that. The other solution is to select a *preferred* time source that is used as long as it seems reasonable, even if other sources have better quality. Refer to [Mitigation Rules and the prefer Keyword](https://www.ntp.org/documentation/4.2.8-series/prefer/) for more information.
时钟跳跃可以通过确定性网络延迟来避免，但通常您对此无能为力。另一种解决方案是选择首选的时间源，只要它看起来合理，即使其他源具有更好的质量。有关详细信息，请参阅缓解规则和 prefer 关键字。

------

#### 8.2.5.2 My server periodically loses synchronization 8.2.5.2 我的服务器周期性失去同步

The typical reason is that system time and the time received from a  reference disagree. This can be caused when the local clock drifts badly and needs a significant *drift correction*. It can also occur when the the NTP server cannot decide between random  variations in network delay or variations in the time reference itself.  This is why it is recommended to configure several independent time  references.
典型的原因是系统时间和从引用接收的时间不一致。当本地时钟漂移严重且需要进行重大漂移校正时，可能会导致这种情况。当 NTP 服务器无法在网络延迟的随机变化或时间引用本身的变化之间做出决定时，也会发生这种情况。因此，建议配置多个独立的时间参考。

Keep an eye on the [*reachability register*](https://www.ntp.org/ntpfaq/ntp-s-trouble/#814-what-does-257-mean-as-value-for-reach), on [`delay`](https://www.ntp.org/ntpfaq/ntp-s-trouble/#812-how-do-i-use-peerstats-and-loopstats), and on `dispersion` (`jitter`).
密切关注可达性寄存器、on `delay` 和 on `dispersion` （ `jitter` ）。

------

#### 8.2.5.3 Why does my system step several times a day? 8.2.5.3 为什么我的系统一天要走好几次？

This is an indicator that `ntpd` has problems controlling the system clock. Most likely the frequency of timer interrupts is either too fast or too slow. Another possibility is a broken interface between `ntpd` and the operating system. In any case the problem is serious. If you suspect the first problem, you should [adjust the value of `tick`](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#8261-how-do-i-set-the-correct-value-for-tick) to compensate the error.
这是一个在控制系统时钟时 `ntpd` 出现问题的指标。最有可能的是，定时器中断的频率要么太快，要么太慢。另一种可能性是操作系统之间的 `ntpd` 接口损坏。无论如何，问题很严重。如果怀疑是第一个问题，则应调整 的 `tick` 值以补偿误差。

> As adjustments to `tick` are not possible for every operating system, it’s deprecated in  general. The suggested solution is to use suitable hardware for time  servers.
> 由于无法对每个操作系统进行 `tick` 调整，因此通常不推荐使用。建议的解决方案是为时间服务器使用合适的硬件。

If you are using the [kernel discipline](https://www.ntp.org/ntpfaq/ntp-s-algo/#5161-how-will-ntp-discipline-my-clock) and suspect the second problem, use `adjtime()` instead.
如果您正在使用内核规则并怀疑第二个问题，请改用 `adjtime()` 。

Usually `ntpd` can compensate small and even not-so-small errors, but in this case the clock is too bad to be adjusted by the NTP algorithm. Any clock error  of more than one minute per day is definitely too large to be corrected  by NTP.
通常 `ntpd` 可以补偿小的甚至不那么小的误差，但在这种情况下，时钟太差了，无法通过NTP算法进行调整。每天任何超过一分钟的时钟误差肯定太大，无法通过 NTP 进行纠正。

**Example 8.2a: Entries in logfile from ntpd
例 8.2a.. ntpd 日志文件中的条目**

```
 9 Jun 21:56:53 ntpd[116]: time reset (step) 0.706052 s
 9 Jun 23:51:04 ntpd[116]: time reset (step) 0.821992 s
10 Jun 01:57:31 ntpd[116]: time reset (step) 0.720290 s
10 Jun 03:47:25 ntpd[116]: time reset (step) 0.855968 s
```

This means that in the period from `9 Jun 21:56:53` (excluding) to `10 Jun 03:47:25` (including), that is during 21032 seconds, `ntpd` added 2.398250 seconds (do *not* include the amount added during the first time step). Thus in each second 114.0286 microseconds should have been added.
这意味着在从 `9 Jun 21:56:53` （不包括）到 `10 Jun 03:47:25` （包括）的时间段内，即在 21032 秒期间， `ntpd` 增加了 2.398250 秒（不包括第一个时间步长期间添加的量）。因此，每秒应该增加 114.0286 微秒。

You get a more accurate calculation when you do *not* run `ntpd`. Start the measurement by synchronizing your system to a NTP server using `ntpdate -b -s -p 4 -t 0.1 NTPserver`. Complete the measurement with the same command after a few hours.
当你不运行 `ntpd` 时，你会得到更准确的计算。通过使用 `ntpdate -b -s -p 4 -t 0.1 NTPserver` 将系统同步到 NTP 服务器来开始测量。几个小时后使用相同的命令完成测量。

In your `/var/log/messages` (`syslog` file) file you will have 2 lines like:
在您的 `/var/log/messages` （ `syslog` file） 文件中，您将有 2 行，如下所示：

```
Jun 9 15:00:47 NTPclient ntpdate[334]: step time server 10.0.0.1 offset 0.009416 sec
Jun 9 21:40:23 NTPclient ntpdate[515]: step time server 10.0.0.1 offset 2.718281 sec
```

Use this information to compute the number of microseconds to add to `tick`.
使用此信息可计算要添加到 `tick` 的微秒数。

For some operating systems there is a `tickadj` utility that can be used to change the value of `tick`. See [Section 3](https://www.ntp.org/ntpfaq/ntp-s-sw-clocks/) and [Q: 8.2.6.1](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#8261-how-do-i-set-the-correct-value-for-tick) for a discussion on how to compute the necessary adjustment.
对于某些操作系统，有一个 `tickadj` 实用程序可用于更改 `tick` 的值。有关如何计算必要调整的讨论，请参见第 3 节和 Q：8.2.6.1。

------

#### 8.2.6 Other 8.2.6 其他

#### 8.2.6.1 How do I set the correct value for tick? 8.2.6.1 如何设置正确的刻度值？

Here is a procedure taken from an article by Andrew Hood:
以下是安德鲁·胡德（Andrew Hood）的一篇文章中的过程：

1. Watch the value in `ntp.drift` and when it seems to stabilise continue at the next step.
   观察价值 `ntp.drift` ，当它似乎稳定下来时，继续下一步。
2. Run `tickadj` without any options to get the value of tick.
   在没有任何选项的情况下运行 `tickadj` 以获取 tick 的值。
3. Calculate a new value of `tick` as `newtick = oldtick*(1+drift/2^20)`.
   计算 `tick` as `newtick = oldtick*(1+drift/2^20)` 的新值。
4. Run `tickadj` with the new value of `tick`.
    `tickadj` 使用新值 `tick` 运行。
5. Restart from the beginning.
   从头开始重新启动。

- **Example 8.2b: Correcting the value of tick 例 8.2b.. 更正刻度值**

  Here are the specific commands for Linux. 以下是 Linux 的特定命令。

```
cat /etc/ntp.drift
269.799
tickadj
tick = 10000
echo 'scale=7; t=10000*(1+269.799/2^20)+0.5; scale=0; t/1' | bc
10003
tickadj 10003
```

The author points out that it can also be done with one single command:
作者指出，也可以通过一个命令来完成：

```
echo "scale=7; `tickadj`; drift=`cat /etc/ntp.drift`; t=tick*(1+(drift)/2^20)+0.5; scale=0;t/1" | bc
10003
```

**Example 8.2c: Changing nsec_per_tick
例 8.2c.. 更改nsec_per_tick**

For the Solaris operating system the variable `nsec_per_tick` is in nanoseconds and can be modified using `adb` (thanks to Thomas Tornblom):
对于Solaris操作系统，该变量 `nsec_per_tick` 以纳秒为单位，可以使用 `adb` （感谢Thomas Tornblom）进行修改：

The command `echo 'nsec_per_tick/W 0t10000900' |adb -w -k` makes the clock faster by 90 PPM, i.e. a drift value of 97 can be reduced to 7.
该命令 `echo 'nsec_per_tick/W 0t10000900' |adb -w -k` 使时钟速度加快 90 PPM，即漂移值 97 可以降低到 7。

For FreeBSD there are two sysctls that you can use, `machdep.i8254_freq` and `machdep.tsc_freq`. Use the one that is being used on your machine to tell FreeBSD what the frequency of your clock is. (according to John Hay)
对于 FreeBSD，您可以使用两个 sysctl， `machdep.i8254_freq` 以及 `machdep.tsc_freq` .使用机器上正在使用的那个来告诉 FreeBSD 你的时钟频率是多少。（根据约翰·海伊的说法）

Changing the value of `tick` is considered an obsolete technology by [Professor David L. Mills](https://www.nwtime.org/tribute-to-david-l-mills/), and the `tickadj` utility will probably be missing in future releases of the NTP  software. Even now the latest kernel clock model silently resets the  values of `tick` to the default value when a PPS signal is detected.
David L. Mills教授认为，更改值 `tick` 是一种过时的技术，并且该 `tickadj` 实用程序可能会在NTP软件的未来版本中丢失。即使是现在，最新的内核时钟模型也会在检测到 PPS 信号时将 的 `tick` 值静默地重置为默认值。

With this new strategy clock errors of up to 500 PPM can be corrected by the kernel clock machinery. Severely broken machines that really need `tickadj` should probably not run NTP.
通过这种新策略，内核时钟机制可以纠正高达500 PPM的时钟误差。真正需要 `tickadj` 的严重损坏的机器可能不应该运行 NTP。

------

#### 8.2.6.2 How do I set the precision? 8.2.6.2 如何设置精度？

New implementations of NTP determine the precision automatically and do not allow setting it. This is a great benefit as you do not have to  determine the value prior to setting it.
NTP 的新实现会自动确定精度，并且不允许设置它。这是一个很大的好处，因为您不必在设置值之前确定它。

This is valid for the system clock and for reference clock drivers.
这对于系统时钟和参考时钟驱动程序有效。

------

#### 8.2.6.3 ntpd periodically opens a dial-out connection. Can I avoid that? 8.2.6.3 NTPD 定期打开拨出连接。我能避免这种情况吗？

Originally NTP has not been designed with dial-up connections in mind. Therefore  it does not care very much about when to send out packets.
最初，NTP 在设计时并未考虑拨号连接。因此，它不太关心何时发送数据包。

If you have defined an external `server` or `peer`, `ntpd` will periodically poll it. The [polling interval](https://www.ntp.org/ntpfaq/ntp-s-algo/#5124-when-are-the-servers-polled) is limited by the [settings `minpoll` and `maxpoll`](https://www.ntp.org/ntpfaq/ntp-s-algo/#5151-what-is-the-allowed-range-for-minpoll-and-maxpoll). The virtual stability of the system clock determines whether the polling interval is reduced or increased.
如果定义了外部 `server` 或 `peer` ， `ntpd` 则将定期轮询它。轮询间隔受设置 `minpoll` 和 `maxpoll` 的限制。系统时钟的虚拟稳定性决定了轮询间隔是减少还是增加。

However, increasing the polling interval may be a sub-optimal solution: `ntpd` will take longer for the initial synchronization, and it may become unable to catch up with the clock’s drift.
但是，增加轮询间隔可能是一个次优解决方案： `ntpd` 初始同步需要更长的时间，并且可能无法赶上时钟的漂移。

For some operating systems you may be able to select what types of packets are allowed to open a dial-up connection.
对于某些操作系统，您可以选择允许打开拨号连接的数据包类型。

The following solution for FreeBSD and NetBSD was donated by [Eric W. Bates](mailto:ericx@vineyard.net). As [chunkeey](mailto:chunkeey@web.de) pointed out, the solution will also work for Linux, where the preferred directory may be `/etc/ppp/ip-up.d` and `/etc/ppp/ip-down.d` as all the scripts found there are executed.
以下 FreeBSD 和 NetBSD 的解决方案是由 Eric W. Bates 捐赠的。正如 chunkeey 所指出的，该解决方案也适用于 Linux，首选目录可能位于 `/etc/ppp/ip-up.d` 其中，并且 `/etc/ppp/ip-down.d` 在那里找到的所有脚本都会被执行。

When using `PPP` on `FreeBSD` or `NetBSD`, I configured my `pppd` options to ignore traffic on the NTP port (snippet):
使用 `PPP` on `FreeBSD` 或 `NetBSD` 时，我将 `pppd` 选项配置为忽略 NTP 端口上的流量（代码段）：

```
### demand dialing options
demand                          # only actually connect ppp on demand
holdoff         10              # after connection drops, wait 10 seconds before dialing again
idle            1500            # drop connection after 25 minutes of no traffic
active-filter   'not port ntp'  # don't regard ntp packets as link activity
```

Then in the scripts `ip-up` and `ip-down` I start and stop `ntpd` (respectively):
然后在脚本中 `ip-up` ， `ip-down` 我分别开始和停止 `ntpd` ：

```
# Start any IP activity here that should only run while the modem is connected
/usr/sbin/ntpd -p /var/run/ntpd.pid

# During boot, when pppd is first initialized a connection is always
# made (not clear why -- named?), but when ntpd is started at that
# time it does not write the PID file (not clear why -- filesystem not
# writable?); so there is a case where the PID file is not readable.

PIDFILE=/var/run/ntpd.pid
if [ -r $PIDFILE ]; then
    kill -TERM $(cat $PIDFILE)
    rm $PIDFILE
else
    # Get the process ID (do the "grep -v" to exclude this search from the result.
    kill -TERM $(ps ax | grep ntpd | grep -v grep | cut -c 1-5)
fi
```

This results in a `ppp0` interface which is configured at boot and dials only when there is demand for IP on its route. Upon dial-up `NTP` is started and the sync traffic does not prevent the dial-up from  timing out, allowing the modem to hang up. Upon hang-up, the NTP daemon  is stopped.
这导致 `ppp0` 接口在启动时配置，并且仅在其路由上有 IP 需求时才拨号。拨号 `NTP` 启动后，同步流量不会阻止拨号超时，从而允许调制解调器挂断。挂断后，NTP 守护程序将停止。

This has worked nicely for me for some years. I recognize that frequent connect/disconnects tend to mess with `ntpd`’s ability to sync, but my work habits are such that once the PPP is up  and live, it tends to stay up for long periods. Good enough for a  workstation at home.
这对我来说已经很有效了几年。我认识到频繁的连接/断开连接往往会扰乱 `ntpd` 同步能力，但我的工作习惯是这样的，一旦 PPP 启动并生效，它往往会长时间保持正常状态。对于家里的工作站来说已经足够了。

------

#### 8.2.6.4 Any more Hints? 8.2.6.4 还有什么提示吗？

Try the suggestions in [NTP Debugging Techniques](https://www.ntp.org/documentation/4.2.8-series/debug/).
请尝试 NTP 调试技术中的建议。

------

#### 8.2.7 Errors and Warnings 8.2.7 错误和警告

This section deals with messages that are not too obvious in their meaning.
本节处理含义不太明显的消息。

#### 8.2.7.1 ntpq: read: connection refused 8.2.7.1 NTPQ：读取：连接被拒绝

This message typically indicates that a connection could not be made because the [service is not available](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#8211-how-can-i-check-that-ntpd-is-up-and-running).
此消息通常表示由于服务不可用而无法建立连接。

------

#### 8.2.7.2 127.0.0.1: timed out, nothing received, Request timed out 8.2.7.2 127.0.0.1：超时，未收到任何消息，请求超时

No response was received within the timeout interval. Either the network  dropped the request or the answer, or it delayed it considerably, or the server did not respond. One reason for the latter would be a  configuration line like this:
在超时间隔内未收到任何响应。要么是网络放弃了请求或答案，要么是大大延迟了请求或答案，要么是服务器没有响应。后者的一个原因是这样的配置行：

```
restrict default ignore
```

------

#### 8.2.7.3 ntpdate: no server suitable for synchronization found 8.2.7.3 ntpdate：未找到适合同步的服务器

If you see that message in your log file, the system time was not set by `ntpdate`. There are several possible reasons:
如果您在日志文件中看到该消息，则系统时间不是由 设置的 `ntpdate` 。有以下几个可能的原因：

- `ntpdate` failed to communicate through UDP port 123. This could be caused by  some packet filtering or by firewalls. Unfortunately, using option `-d` to turn on debugging also changes the port `ntpdate` uses.
   `ntpdate` 无法通过 UDP 端口 123 进行通信。这可能是由某些数据包过滤或防火墙引起的。遗憾的是，使用选项 `-d` 打开调试也会更改端口 `ntpdate` 的使用。
- If `ntpdate` works with option `-d`, you should try option `-u` to use an unpriviledged port. In any case you should check your packet filtering.
  如果 `ntpdate` 与 option `-d` 一起使用，您应该尝试使用无特权端口的选项 `-u` 。在任何情况下，您都应该检查数据包过滤。

------

#### 8.2.7.4 configure: keyword “precision” unknown, line ignored 8.2.7.4 配置：关键字“precision”未知，行忽略

The [keyword `precision`](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#8262-how-do-i-set-the-precision) is no longer known by the configuration parser. Most likely you are  using a configuration file intended for an old version of NTP.
配置分析程序不再知道该关键字 `precision` 。最有可能的是，您使用的是用于旧版本 NTP 的配置文件。

------

#### 8.2.7.5 Previous time adjustment didn’t complete 8.2.7.5 上一次时间调整未完成

Using `adjtime()` your system clock can be corrected by [some amount of time](https://www.ntp.org/ntpfaq/ntp-s-algo/#5161-how-will-ntp-discipline-my-clock). Normally `ntpd` will only use small amounts that can be applied within one second.  However, if you disallow time steps, the last correction may be  incomplete and `ntpd` is unable to apply another correction until the last one is finished. This is what the message says.
使用 `adjtime()` 系统时钟可以纠正一定时间。通常 `ntpd` 只会使用少量，可以在一秒钟内使用。但是，如果不允许时间步长，则最后一次更正可能不完整，并且 `ntpd` 在最后一次更正完成之前无法应用另一次更正。这就是消息所说的。

------

#### 8.2.7.6 sendto: Overlapped I/O operation is in progress. 8.2.7.6 sendto：正在执行重叠的 I/O 操作。

The exact cause of this message is not clear, but it seems some non-NTP applications also use port `123`. The IP address `192.0.0.192` is a strong indication for this.
此消息的确切原因尚不清楚，但似乎某些非 NTP 应用程序也使用 端口 `123` .IP 地址 `192.0.0.192` 是这方面的一个强烈迹象。

John Hay contributed the output of `nslookup 192.0.0.192`, namely `192.0.0.0-is-used-for-printservices-discovery----illegally.iana.net`, and [Professor David L. Mills](https://www.nwtime.org/tribute-to-david-l-mills/) stated: “Port 123 was assigned well before 1985 as per documented, but  was in use probably from 1982.” This means the address is not registered officially, and it should not be used. Also it seems some software for  printers or printing is using that address together with NTP’s port  number.
John Hay 贡献了 `nslookup 192.0.0.192` 的 `192.0.0.0-is-used-for-printservices-discovery----illegally.iana.net` 成果，David L. Mills 教授说：“根据记录，123 号端口早在 1985 年之前就被分配了，但可能从 1982 年开始使用。这意味着该地址没有正式注册，不应使用。此外，似乎一些用于打印机或打印的软件正在将该地址与 NTP 的端口号一起使用。

Despite worrying some system administrator the message indicates no trouble.  Specifically no printer is known to need a NTP server to operate, nor do printers and NTP servers harm each other.
尽管担心某些系统管理员，但该消息表明没有问题。具体而言，没有已知的打印机需要 NTP 服务器才能运行，打印机和 NTP 服务器也不会相互伤害。

# 8.3. Troubleshooting Specific Products 8.3. 对特定产品进行故障排除

Last update: April 3, 2024 16:42 UTC ([f170361b7](https://git.nwtime.org/websites/ntpwww/commit/f170361b72193f7af81935c6c0a4afda96793f0d))
最后更新： 2024年4月3日 16：42 UTC （ f170361b7）

8.3.1 [PC Hardware](https://www.ntp.org/ntpfaq/ntp-s-trbl-spec/#831-pc-hardware) 8.3.1 电脑硬件
 8.3.1.1 [How accurate is the CMOS clock?](https://www.ntp.org/ntpfaq/ntp-s-trbl-spec/#8311-how-accurate-is-the-cmos-clock)
8.3.1.1 CMOS时钟的精度如何？
 8.3.1.2 [How can I set the CMOS clock?](https://www.ntp.org/ntpfaq/ntp-s-trbl-spec/#8312-how-can-i-set-the-cmos-clock)
8.3.1.2 如何设置CMOS时钟？
 8.3.1.3 [How can I read or write the CMOS clock?](https://www.ntp.org/ntpfaq/ntp-s-trbl-spec/#8313-how-can-i-read-or-write-the-cmos-clock)
8.3.1.3 如何读取或写入CMOS时钟？
 8.3.1.4 [How can SMM affect Interrupt Processing?](https://www.ntp.org/ntpfaq/ntp-s-trbl-spec/#8314-how-can-smm-affect-interrupt-processing)
8.3.1.4 SMM如何影响中断处理？
 8.3.2 [Linux](https://www.ntp.org/ntpfaq/ntp-s-trbl-spec/#832-linux) 8.3.2 Linux操作系统
 8.3.2.1 [What does set_rtc_mmss: can’t update from 54 to 5 mean?](https://www.ntp.org/ntpfaq/ntp-s-trbl-spec/#8321-what-does-set_rtc_mmss-cant-update-from-54-to-5-mean)
8.3.2.1 set_rtc_mmss： can't update from 54 to 5 是什么意思？
 8.3.2.2 [Why does my Linux system lose several milliseconds every once in a while.](https://www.ntp.org/ntpfaq/ntp-s-trbl-spec/#8322-why-does-my-linux-system-lose-several-milliseconds-every-once-in-a-while)
8.3.2.2 为什么我的 Linux 系统每隔一段时间就会损失几毫秒。
 8.3.4 [Serial Port](https://www.ntp.org/ntpfaq/ntp-s-trbl-spec/#834-serial-port) 8.3.4 串口
 8.3.4.1 [Do Multiport Serial Cards cause Trouble?](https://www.ntp.org/ntpfaq/ntp-s-trbl-spec/#8341-do-multiport-serial-cards-cause-trouble)
8.3.4.1 多端口串口卡会引起问题吗？
 8.3.4.2 [Why does my DCF77 Receiver not get Power from the serial Port?](https://www.ntp.org/ntpfaq/ntp-s-trbl-spec/#8342-why-does-my-dcf77-receiver-not-get-power-from-the-serial-port)
8.3.4.2 为什么我的DCF77接收器无法从串口获得电源？
 8.3.5 [Oncore Compatibles](https://www.ntp.org/ntpfaq/ntp-s-trbl-spec/#835-oncore-compatibles)
8.3.5 Oncore 兼容产品
 8.3.5.1 [Will the M12 work with the Oncore driver?](https://www.ntp.org/ntpfaq/ntp-s-trbl-spec/#8351-will-the-m12-work-with-the-oncore-driver)
8.3.5.1 M12 可以与 Oncore 驱动程序一起使用吗？
 8.3.5.2 [Why is the UT+ reporting clk_noreply?](https://www.ntp.org/ntpfaq/ntp-s-trbl-spec/#8352-why-is-the-ut-reporting-clk_noreply)
8.3.5.2 为什么UT+报告clk_noreply？
 8.3.6 [Solaris](https://www.ntp.org/ntpfaq/ntp-s-trbl-spec/#836-solaris) 8.3.6 索拉里斯  
 8.3.6.1 [What is dosyncdr?](https://www.ntp.org/ntpfaq/ntp-s-trbl-spec/#8361-what-is-dosyncdr)
8.3.6.1 什么是dosyncdr？
 8.3.6.2 [What causes occasional 2s Time Steps?](https://www.ntp.org/ntpfaq/ntp-s-trbl-spec/#8362-what-causes-occasional-2s-time-steps)
8.3.6.2 什么原因导致偶尔出现 2s 时间步长？
 8.3.7 [Trimble Clocks](https://www.ntp.org/ntpfaq/ntp-s-trbl-spec/#837-trimble-clocks) 8.3.7 Trimble 时钟
 8.3.7.1 [Only one Edge of my Trimble Acutime’s PPS Pulse is detected](https://www.ntp.org/ntpfaq/ntp-s-trbl-spec/#8371-only-one-edge-of-my-trimble-acutimes-pps-pulse-is-detected)
8.3.7.1 仅检测到 Trimble Acutime 的 PPS 脉冲的一个边缘

------

#### 8.3.1. PC Hardware 8.3.1. PC硬件

#### 8.3.1.1 How accurate is the CMOS clock? 8.3.1.1 CMOS时钟的精度如何？

The CMOS real time clock (RTC) is responsible for preserving the date and time while the PC is turned off.
CMOS实时时钟（RTC）负责在PC关闭时保留日期和时间。

Some people say the CMOS RTC is much more accurate than the timer interrupt  in terms of frequency error. Actually I don’t know, but I have one  concrete example: a PC used a stratum 1 server with PPS had a hardware  fault, and it had been powered off for about 18 days. When running, the  typical frequency error was 15 to 17 PPM and when the system was  rebooted the RTC clock was off by 18 seconds. That would be an error of  roughly 12 PPM.
有人说，就频率误差而言，CMOS RTC比定时器中断要准确得多。其实我不知道，但我有一个具体的例子：一台使用带有 PPS 的第 1 层服务器的 PC  出现硬件故障，并且已经关闭了大约 18 天。运行时，典型的频率误差为 15 至 17 PPM，当系统重新启动时，RTC 时钟关闭 18  秒。这将是大约 12 PPM 的误差。

------

#### 8.3.1.2 How can I set the CMOS clock? 8.3.1.2 如何设置CMOS时钟？

Basically `ntpd` only sets the system time of the operating system. Therefore setting  the CMOS clock is the responsibility of the operating system and its  associated tools. To make things worse, typical PC operating systems and the BIOS set the RTC to local time, while UNIX-like operating systems  set the RTC to UTC.
基本上 `ntpd` 只设置操作系统的系统时间。因此，设置CMOS时钟是操作系统及其相关工具的责任。更糟糕的是，典型的 PC 操作系统和 BIOS 将 RTC 设置为本地时间，而类 UNIX 操作系统将 RTC 设置为 UTC。

**Example 8.3a: Linux 例 8.3a.. Linux**

In Linux the RTC is either not updated at all, or just the minutes and  seconds. The related kernel code has been revised several times, with  different behaviour. Setting the system time manually does not update  the RTC. Only if the `STA_UNSYNC` bit is cleared, the kernel will periodically update the RTC from the system time. Typically this happens every 11 minutes.
在 Linux 中，RTC 要么根本不更新，要么只更新分钟和秒。相关的内核代码已经过多次修改，具有不同的行为。手动设置系统时间不会更新 RTC。只有当 `STA_UNSYNC` 该位被清除时，内核才会从系统时间定期更新 RTC。通常，这每 11 分钟发生一次。

With the optional PPSkit-0.9.0 kernel patch the RTC is updated just like in  other PC operating systems. In addition the automatic periodic update  can be disabled completely (see the documentation that comes with the  product).
使用可选的 PPSkit-0.9.0 内核补丁，RTC 会像在其他 PC 操作系统中一样进行更新。此外，可以完全禁用自动定期更新（请参阅产品附带的文档）。

There is also a user-space program to set the RTC, but it requires special privileges. Typically the utility is named `hwclock`.
还有一个用户空间程序来设置 RTC，但它需要特殊权限。通常，该实用程序名为 `hwclock` 。

------

#### 8.3.1.3 How can I read or write the CMOS clock? 8.3.1.3 如何读取或写入CMOS时钟？

There are several possibilities for Linux besides using the BIOS:
除了使用 BIOS 之外，Linux 还有几种可能性：

- You can read the clock using `cat /proc/rtc` (if `CONFIG_RTC` is set), or `hwclock --show` (`hwclock` is a newer replacement for the older `clock` program). C programmers could use the `ioctl()` interface and `RTC_RD_TIME` (see `/usr/include/linux/mc146818rtc.h` and `/usr/src/linux/Documentation/rtc.txt`).
  您可以使用 `cat /proc/rtc` （如果 `CONFIG_RTC` 已设置）或 `hwclock --show` （ `hwclock` 是旧 `clock` 程序的较新替代品）读取时钟。C 程序员可以使用 `ioctl()` 接口 和 `RTC_RD_TIME` （参见 `/usr/include/linux/mc146818rtc.h` 和 `/usr/src/linux/Documentation/rtc.txt` ）。
- You can set the clock using either `hwclock --set` (possibly with `--utc`) or the `ioctl()` interface and `RTC_SET_TIME`.
  您可以使用（ `hwclock --set` 可能带有 `--utc` ）或 `ioctl()` 接口和 `RTC_SET_TIME` 来设置时钟。
- The kernel will normally read the clock during boot (when it does not know  the timezone yet) and when APM had been active. When the kernel PLL is  used, the system time will be written to the clock periodically. Setting or adjusting the time by other means will not update the hardware  clock.
  内核通常会在启动期间（当它还不知道时区时）和 APM 处于活动状态时读取时钟。当使用内核PLL时，系统时间将定期写入时钟。通过其他方式设置或调整时间不会更新硬件时钟。

------

#### 8.3.1.4 How can SMM affect Interrupt Processing? 8.3.1.4 SMM如何影响中断处理？

Let me quote an explanation written by [Poul-Henning Kamp](mailto:phk@freebsd.dk) from the newsgroup:
让我引用新闻组的 Poul-Henning Kamp 写的一段解释：

I was gathering some data for [Professor David L. Mills](https://www.nwtime.org/tribute-to-david-l-mills/) today and they looked lousy to put it mildly; every 300-400 seconds I  had a 40-50 microsecond peak in my data. After some debugging I know  know what it was: the SMM mode interrupts to the BIOS.
我今天正在为David L. Mills教授收集一些数据，委婉地说，他们看起来很糟糕;每 300-400 秒，我的数据中就会有一个 40-50 微秒的峰值。经过一些调试，我知道它是什么：SMM模式中断了BIOS。

This machine is brand new, and I had never put a PPS signal on it before. It uses the PIIX4 chip from Intel and appearantly the SMM BIOS gets called at regular (but not very precise) intervals to monitor temperatures and fans and whats not.
这台机器是全新的，我以前从未在上面安装过 PPS 信号。它使用英特尔的PIIX4芯片，并且似乎定期（但不是很精确）调用SMM BIOS来监控温度和风扇等等。

Needless to say, this could not be disabled in the BIOS setup.
毋庸置疑，这无法在BIOS设置中禁用。

I found out I could disable the SMI output from the PIIX4 to the CPU by clearing bit zero in the `GLBCTL` register in the third function of the 82371AB chip. You need to find the IO base address from register `0x40` in the PCI header, and add the `0x28` to that address. For my motherboard that ended up being `0xe428`, your mileage will vary, and you should “Do The Right Thing” to find this location.
我发现我可以通过清除 82371AB 芯片第三个功能 `GLBCTL` 寄存器中的零位来禁用从 PIIX4 到 CPU 的 SMI 输出。您需要从 PCI 标头的寄存器 `0x40` 中找到 IO 基址，并将其添加到 `0x28` 该地址。对于我的主板，最终是 `0xe428` ，您的里程会有所不同，您应该“做正确的事”才能找到此位置。

Needless to say, the SMM BIOS will not be able to check if your CPU is able to  make toast if you disable it this way, so you’d better know what you’re  doing.
毋庸置疑，如果您以这种方式禁用 SMM BIOS，它将无法检查您的 CPU 是否能够制作 toast，因此您最好知道自己在做什么。

------

#### 8.3.2 Linux 8.3.2 Linux操作系统

#### 8.3.2.1 What does set_rtc_mmss: can’t update from 54 to 5 mean? 8.3.2.1 set_rtc_mmss： can't update from 54 to 5 是什么意思？

The function `set_rtc_mmss()` updates minutes and seconds of the CMOS clock from system time. It does not update the hour or date to avoid problems with timezones.(The Linux kernel has no idea about the effective timezone or daylight saving  time.) The message shown was added to make users and implementers aware  of the problem that not all time updates will succeed.
该功能 `set_rtc_mmss()` 根据系统时间更新CMOS时钟的分钟和秒。它不会更新小时或日期以避免时区问题。（Linux 内核不知道有效时区或夏令时。添加显示的消息是为了让用户和实现者意识到并非所有时间更新都会成功的问题。

Imagine the system time is 17:56:23 while the CMOS clock is already at  18:03:45. Updating just minutes and seconds would set the hardware clock to 18:56:23, a wrong value. The solution for this problem is either to  wait a few minutes, or to install a kernel patch that fixes the problem. Normally a wrong time in the hardware clock will not show up until  after reboot, or maybe after APM slowed down your system.
假设系统时间是17：56：23，而CMOS时钟已经是18：03：45。仅更新分钟和秒会将硬件时钟设置为  18：56：23，这是一个错误的值。此问题的解决方案是等待几分钟，或者安装修复该问题的内核补丁。通常，硬件时钟中的错误时间直到重新启动后才会显示出来，或者可能在 APM 减慢系统速度之后。

------

#### 8.3.2.2 Why does my Linux system lose several milliseconds every once in a while. 8.3.2.2 为什么我的 Linux 系统每隔一段时间就会损失几毫秒。

You are using `/sbin/kerneld` for automatic module loading. Several modules do not take good care of  the time during initialization. If you can spare the memory, please load the modules at boot time.
您正在用于 `/sbin/kerneld` 自动模块加载。一些模块在初始化期间没有很好地照顾时间。如果可以节省内存，请在启动时加载模块。

The original contributor remarks: “This once occured to me. The sound  system was demand loaded. A small application told the time every 15  minutes (saytime running in cron). The ntp logging showed me that  something strange happened every 15 minutes. I found out it was the  loading of the sound module every 15 minutes.”
最初的撰稿人评论说：“这曾经发生在我身上。音响系统是按需加载的。一个小应用程序每 15 分钟告诉一次时间（比如在 cron 中运行的时间）。ntp 日志记录显示每 15 分钟就会发生一些奇怪的事情。我发现这是每 15 分钟加载一次声音模块。

In addition removal of modules also seems to block interrupts.
此外，移除模块似乎也会阻止中断。

Another reason for lost interrupts are closely connected with the use of IDE  drives that are operated in polled mode (PIO), and not im DMA mode.  Still another reason can be a BIOS that disables interrupts when APM  routines are called.
中断丢失的另一个原因与使用在轮询模式（PIO）下运行的IDE驱动器密切相关，而不是在DMA模式下运行。另一个原因可能是 BIOS 在调用 APM 例程时禁用中断。

------

#### 8.3.4 Serial Port 8.3.4 串口

#### 8.3.4.1 Do Multiport Serial Cards cause Trouble? 8.3.4.1 多端口串口卡会引起问题吗？

Multiport serial cards are usually optimized for throughput, not for low latency. Therefore, some reference clock drivers may cause trouble.
多端口串行卡通常针对吞吐量进行优化，而不是针对低延迟进行优化。因此，某些参考时钟驱动程序可能会引起问题。

In case you are already in trouble, and using a standard serial port is  not an option, you can only try to find out what’s wrong:
如果您已经遇到麻烦，并且无法使用标准串行端口，则只能尝试找出问题所在：

- `cat /proc/tty/driver/serial` will show some essential information about the serial ports.
   `cat /proc/tty/driver/serial` 将显示有关串行端口的一些基本信息。
- Depending on the driver, `ntpq`’s `cl` command may show some useful information like the last received time code or error counters.
  根据驱动程序的不同， `ntpq` 的命令 `cl` 可能会显示一些有用的信息，例如上次接收的时间代码或错误计数器。
- To see what `ntpd` is doing, you can use `strace -p *pid*` to attach to `ntpd`.
  要查看正在执行的操作 `ntpd` ，可以使用 `strace -p *pid*` 附加到 `ntpd` .

------

#### 8.3.4.2 Why does my DCF77 Receiver not get Power from the serial Port? 8.3.4.2 为什么我的DCF77接收器无法从串口获得电源？

Somewhere in the code cleanup between NTPv3 and NTPv4, the code to set the modem  lines of the serial port got lost. The port has to be set up in a  special way to provide power to the receiver.
在 NTPv3 和 NTPv4 之间的代码清理中，用于设置串行端口调制解调器线路的代码丢失了。端口必须以特殊方式设置，以便为接收器供电。

For my receiver the command `setserialbits /dev/refclock-0 -rts` turns on power while `ntpd` is running. Some receivers care about polarity, some don’t. You might try substituting `-rts` with `-dtr`.
对于我的接收器，该命令 `setserialbits /dev/refclock-0 -rts` 在运行时 `ntpd` 打开电源。有些接收器关心极性，有些则不关心。您可以尝试 `-rts` 用 `-dtr` 替换 。

For the [RAWDCF PARSE driver](https://www.ntp.org/documentation/drivers/driver8/) there is a `mode 14`, that turns on power on the port, but my receiver (and others, too) had  errors about every 10 seconds. I have reported the problem to the  original author.
对于 RAWDCF PARSE 驱动程序，有一个 `mode 14` ，可以打开端口的电源，但我的接收器（以及其他接收器）大约每 10 秒就会出错一次。我已向原作者报告了该问题。

------

#### 8.3.5 Oncore Compatibles 8.3.5 Oncore 兼容产品

#### 8.3.5.1 Will the M12 work with the Oncore driver? 8.3.5.1 M12 可以与 Oncore 驱动程序一起使用吗？

It seems this product speaks a different protocol than the original  hardware. To complicate matters, Gary Sanders found out that “If you got your eval kit from Synergy Systems, the PPS output on the eval board is inverted from the older Oncores(…)”. To really confuse the users “(…)  Synergy has a simple wiring change on the eval board to fix it. The  boards that are currently shipping have this fix incorporated.”
似乎该产品使用的协议与原始硬件不同。更复杂的是，Gary Sanders发现，“如果您从Synergy  Systems获得评估套件，则评估板上的PPS输出与较旧的Oncores（...）相反”。真正让用户感到困惑“（...Synergy  在评估板上进行了简单的接线更改来修复它。当前发货的主板已合并此修复程序。

[Mark Martinec](mailto:mark.martinec@ijs.si) contributed: “I just stumbled across the specs of the 12-channel GPS  receiver Motorola Oncore M12. Its acquisition time (time to first fix)  for cold start is less than 60 seconds typical.
Mark Martinec 表示：“我刚刚偶然发现了 12 通道 GPS 接收器摩托罗拉 Oncore M12 的规格。其冷启动采集时间（首次修复时间）通常小于 60 秒。

------

#### 8.3.5.2 Why is the UT+ reporting clk_noreply? 8.3.5.2 为什么UT+报告clk_noreply？

According to the documentation [driver 30](https://www.ntp.org/documentation/drivers/driver30/) should work for the UT+ “as long as they support the Motorola Binary  Protocol”. Furthermore the documentation recommends: “When first  starting to use the driver you should definitely review the information  written to the `clockstats` file to verify that the driver is running correctly.”
根据文档，驱动程序 30 应该适用于 UT+，“只要它们支持摩托罗拉二进制协议”。此外，文档建议：“首次开始使用驱动程序时，您绝对应该查看写入 `clockstats` 文件的信息，以验证驱动程序是否正常运行。

Unfortunately some essential documentation can only be found in the source file (`ntpd/refclock_oncore.c`). Some anonymous person wrote in news://comp.protocols.time.ntp:
不幸的是，一些基本文档只能在源文件 （ `ntpd/refclock_oncore.c` ） 中找到。一位匿名人士在 news://comp.protocols.time.ntp 中写道：

(…) When the GPS is in (navigation mode), the driver simply discards the timestamp, resulting in the `clk_noreply`. The clock *did* indeed reply, but the driver just threw it away with no messages to inform me about what it was doing.
(…)当 GPS 处于（导航模式）时，驾驶员只需丢弃时间戳，从而导致 `clk_noreply` .时钟确实回复了，但司机只是把它扔掉了，没有消息告诉我它在做什么。

(…) yes, the GPS is indeed in Navigation mode. The Oncore driver *does* change the mode, even though the code comment quoted above says “don’t do anything to change it” (mode `0`).
(…)是的，GPS确实处于导航模式。Oncore 驱动程序确实更改了模式，即使上面引用的代码注释说“不要做任何事情来更改它”（模式 `0` ）。

(…) So I start using mode `1` instead, which initializes the Oncore with a user-supplied position and then switches into Position Hold mode. Now in this new mode I am *still* getting `clk_noreply`, but now these messages are alternated with `clk_badtime`.
(…)因此，我开始使用模式，该模式 `1` 使用用户提供的位置初始化 Oncore，然后切换到位置保持模式。现在在这个新模式下，我仍然得到 `clk_noreply` ，但现在这些消息与 `clk_badtime` 交替出现。

(…) The binary code is getting decoded just fine. I can print out hours,  minutes, seconds. (…) I discover that clocktime fails because it thinks  that the time offset between the GPS and my computer’s clock is more  than half a day!
(…)二进制代码被解码得很好。我可以打印出小时、分钟、秒。(…)我发现时钟时间失败，因为它认为 GPS 和我的计算机时钟之间的时间偏移量超过半天！

(…) I do `ntpdate` to fix the clock, then run NTP. Hey, it works! HalleleujahPraiseTheLord.
(…)我这样做 `ntpdate` 是为了修复时钟，然后运行NTP。嘿，它有效！哈利路亚赞美主。

------

#### 8.3.6 Solaris 8.3.6 索拉里斯

#### 8.3.6.1 What is dosyncdr? 8.3.6.1 什么是dosyncdr？

There’s a kernel variable named `dosyncdr` that influences how the kernel keeps time. Generally it’s neither  necessary nor recommended to change the value from the default. Only in  Solaris 2.5.1 (where NTP was not officially supported) it was necessary  to set `dosyncdr` manually to `0`.
有一个名为内核变量 `dosyncdr` 的内核变量，它会影响内核保持时间的方式。通常，既没有必要也不建议更改默认值。只有在 Solaris 2.5.1（官方不支持 NTP）中，才需要手动设置为 `dosyncdr` `0` 。

[Michael Sinatra](mailto:msinatra@uclink4.berkeley.edu) wrote in news://comp.protocols.time.ntp:
迈克尔·辛纳屈（Michael Sinatra）在 news://comp.protocols.time.ntp 中写道：

My understanding is, after Solaris 2.6 this is “not necessary at all” . In the past you needed to put `set dosynctodr=0` in `/etc/system`; now, you are NOT supposed to do that. Moreover, you are NOT supposed to use `tickadj`.
我的理解是，在 Solaris 2.6 之后，这“完全没有必要”。过去，您需要投入 `set dosynctodr=0` `/etc/system` ;现在，你不应该这样做。此外，您不应该使用 `tickadj` .

------

#### 8.3.6.2 What causes occasional 2s Time Steps? 8.3.6.2 什么原因导致偶尔出现 2s 时间步长？

After some experiments, [Thomas Schulz](mailto:schulz@adi.com) found out:
经过一番实验，托马斯·舒尔茨发现：

This behavior is normal for Solaris when NTP is not running. This wandering  is due to Solaris correcting the system clock from the hardware clock  (the TODR). The hardware clock is assumed to be the more accurate one  (and it is). This correction is done whenever the two clocks are more  than about 1.5 to 2 seconds apart. You will see this behavior on any  Solaris system if you wait long enough. This correction is not done if  NTP is running. Of course on a system with a very bad clock this  behavior will be much more obvious than on one with a better clock (no  Sparc has a good clock).
当 NTP 未运行时，Solaris 会出现此行为。这种徘徊是由于 Solaris 根据硬件时钟 （TODR）  校正了系统时钟。假定硬件时钟是更准确的时钟（确实如此）。每当两个时钟相距超过 1.5 到 2  秒时，就会进行此校正。如果等待的时间足够长，您将在任何 Solaris 系统上看到此行为。如果 NTP  正在运行，则不会执行此更正。当然，在时钟非常糟糕的系统上，这种行为将比在时钟更好的系统上明显得多（没有 Sparc 有好的时钟）。

------

#### 8.3.7 Trimble Clocks 8.3.7 Trimble 时钟

#### 8.3.7.1 Only one Edge of my Trimble Acutime’s PPS Pulse is detected 8.3.7.1 仅检测到 Trimble Acutime 的 PPS 脉冲的一个边缘

If the device uses very short pulses (like 1 microsecond), the hardware or software may have trouble processing the pulse correctly: see [Q: 8.2.2.2.](https://www.ntp.org/ntpfaq/ntp-s-trbl-general/#8222-why-is-the-pps-api-only-detecting-one-edge) and [Q: 6.2.4.6](https://www.ntp.org/ntpfaq/ntp-s-config-adv/#6246-what-is-the-shortest-width-for-a-pulse-connected-to-the-dcd-pin-of-an-rs-232-interface). Recent clocks feature a programmable pulse width. Using 100 or 200  milliseconds as width will assist you finding the right edge, assuming  that the first edge is the more accurate one.
如果设备使用非常短的脉冲（如 1 微秒），硬件或软件可能无法正确处理脉冲：请参见 Q：8.2.2.2。问：6.2.4.6。最近的时钟具有可编程脉冲宽度。使用 100 或 200 毫秒作为宽度将帮助您找到正确的边，假设第一条边是更准确的边。

# 9. Background and Related Information 9. 背景及相关信息

Last update: April 3, 2024 16:42 UTC ([f170361b7](https://git.nwtime.org/websites/ntpwww/commit/f170361b72193f7af81935c6c0a4afda96793f0d))
最后更新： 2024年4月3日 16：42 UTC （ f170361b7）

This section presents some background information and other related stuff that one may find interesting or entertaining.
本节介绍了一些背景信息和其他相关内容，人们可能会觉得有趣或有趣。

------

9.1 [Miscellaneous](https://www.ntp.org/ntpfaq/ntp-s-related/#91-miscellaneous) 9.1 其他
 9.1.1 [What is Mills-speak?](https://www.ntp.org/ntpfaq/ntp-s-related/#911-what-is-mills-speak)
9.1.1 什么是米尔斯语？
 9.1.2 [How can I convert a date to NTP format?](https://www.ntp.org/ntpfaq/ntp-s-related/#912-how-can-i-convert-a-date-to-ntp-format)
9.1.2 如何将日期转换为NTP格式？
 9.1.3 [How can I convert an NTP Timestamp to UNIX Time?](https://www.ntp.org/ntpfaq/ntp-s-related/#913-how-can-i-convert-an-ntp-timestamp-to-unix-time)
9.1.3 如何将 NTP 时间戳转换为 UNIX 时间？
 9.1.4 [Where can I find more Information?](https://www.ntp.org/ntpfaq/ntp-s-related/#914-where-can-i-find-more-information)
9.1.4 在哪里可以找到更多信息？
 9.2 [GPS](https://www.ntp.org/ntpfaq/ntp-s-related/#92-gps) 9.2 全球定位系统
 9.2.1 [Selective Availability revisited](https://www.ntp.org/ntpfaq/ntp-s-related/#921-selective-availability-revisited)
9.2.1 重新审视选择性可用性

------

#### 9.1 Miscellaneous 9.1 其他

#### 9.1.1 What is Mills-speak? 9.1.1 什么是米尔斯语？

Most people using NTP know that it has been invented by [Professor David L. Mills](https://www.nwtime.org/tribute-to-david-l-mills/). So they frequently address him to solve their problems. Unfortunately  they mostly don’t know about Mills-speak, the language used by the  aforementioned person. To avoid some disappointment, I’ll give a small  example of Mills-speak.
大多数使用NTP的人都知道它是由David L. Mills教授发明的。所以他们经常找他来解决他们的问题。不幸的是，他们大多不了解米尔斯语，即上述人使用的语言。为了避免一些失望，我将举一个米尔斯说话的小例子。

**Example 9.1a: Mills-speak
例 9.1a.. Mills-speak**

Someone once had the misconception that the thing referred to as “nanokernel”  was a kernel even smaller than a “microkernel”. Forwarding the problem  to [Professor David L. Mills](https://www.nwtime.org/tribute-to-david-l-mills/), the answer was:
曾经有人误以为所谓的“纳米核”是比“微核”还要小的核。将问题转发给David L. Mills教授，答案是：

“A nanokernel is a species of korn. Korn is grown on Jupiter as a dietary  supplement by the Nanos, a prehistoric people of predominantly aquatic  descent. The ancient enemy of the Nanos are the Micros, who also grow a  variety of korn. Their variety is closely related to the eggplant of  today, although we know the eggplant is distantly related to chickens.  In Micro mythology, chickens farm fields of eggplants that are specially grafted to korn and eventually evolve and emerge as hackers. Both Nanos and Micros prize hackers, which when planted in fields of chicken  manure greatly vex the environmental authorities, since the confluence  of the two peoples generally degenerate to clouds of messy, smelly swamp gas.”
“纳米仁是一种科恩。Korn 是 Nanos 在木星上种植的膳食补充剂，Nanos 是一个以水生为主的史前民族。Nanos 的宿敌是 Micros，他们也种植各种  korn。它们的品种与今天的茄子密切相关，尽管我们知道茄子与鸡的关系很远。在微观神话中，鸡在田地里种植茄子，这些茄子被专门嫁接到korn上，最终进化并成为黑客。Nanos 和 Micros 都奖励黑客，当黑客种植在鸡粪田里时，环境当局会非常恼火，因为这两个民族的汇合通常会退化为凌乱、臭气熏天的沼泽气体云。

Another example follows.
下面是另一个示例。

> **Note:** I’m not sure what question this answer refers to, but it could be  referring to the fact that some black box NTP servers exist that use  Linux as operating system. If you can correct me, please do!
> 注意：我不确定这个答案指的是什么问题，但它可能指的是存在一些使用 Linux 作为操作系统的黑匣子 NTP 服务器。如果你能纠正我，请做！

Ulrich, 乌尔里希，

Fancy that; when you pop the cover off the CPU chip, a little guy with pointy ears and a pitchfork snarls back at you. Like the time I popped the lid off a digital wristwatch and found a little Micky Mouse etched in the  silicon.
看中了;当你从CPU芯片上弹出盖子时，一个尖耳朵和干草叉的小家伙向你咆哮。就像我掀开数字手表的盖子，发现硅片上刻着一只小米奇老鼠。

Dave 戴夫

Still another one dealing with specifications of clock errors:
还有另一个处理时钟错误规范的问题：

Colin, 科林

A little clarification. 12 PPM = 12 parts per million = 12 microseconds  per second = 43 milliseconds per day = 0.602 seconds per fortnight. Most computer clocks have systematic frequency errors less than 100 PPM, but some considerably more. These errors are due to the manufacturing  tolerance and each clock oscillator is different.
稍微澄清一下。12 PPM = 百万分之 12 = 每秒 12 微秒 = 每天 43 毫秒 = 每两周 0.602 秒。大多数计算机时钟的系统频率误差小于 100 PPM，但有些甚至更高。这些误差是由于制造公差造成的，并且每个时钟振荡器都不同。

Computer clocks are like a cat who never remembers where it has been, only steps ahead in more or less random directions. The cat has a general idea in  which direction leads to food, just not a precise idea of how to get  there. Mathematically, this represents random walk frequency noise. The  important fact about this is that predictions of future cat directions  get worse more rapidly as future time recedes.
计算机时钟就像一只猫，它永远不记得自己去过哪里，只是在或多或少随机的方向上向前迈进。猫有一个通向食物的大致概念，只是没有关于如何到达那里的确切想法。从数学上讲，这表示随机游走频率噪声。关于这一点的重要事实是，随着未来时间的消退，对未来猫方向的预测会更快地变得更糟。

The “after one year” has to do with crystal aging characteristics. The cat  gets old and starts steering more to one direction than the other.  Really clever clock discipline algorithms attempt to learn the  particular cat aging characteristic and compensate for it. Unless you  are talking about oven controlled quartz or rubidium or cesium, this is  not something we do with computer cats.
“一年后”与晶体老化特性有关。猫变老了，开始转向一个方向而不是另一个方向。真正聪明的时钟纪律算法试图学习特定的猫衰老特征并对其进行补偿。除非你说的是烤箱控制的石英或铷或铯，否则这不是我们对电脑猫做的事情。

This brings up the notion of specifications “after one day”. Whoever said  that doesn’t understand cats. The cat forgets just about everything  after maybe an hour. Anything said after one day applies equally after  one hour as the cat wanders. The really ugly bottom line is that,  considering the cat’s memory, it doesn’t make sense to try to discipline the feline by averaging things over much more than a thousand seconds  or so. Lots and lots of professional folks who should know better don’t  understand this.
这就提出了“一天后”规范的概念。谁这么说就不懂猫。猫大概一个小时后就忘记了一切。一天后说的任何话在猫徘徊一小时后同样适用。真正丑陋的底线是，考虑到猫的记忆力，试图通过平均超过一千秒左右的东西来训练猫是没有意义的。很多很多应该更了解的专业人士不明白这一点。

Most folks, including me, characterize each clock oscillator in terms of what is called [Allan deviation](https://www.ntp.org/reflib/brief/algor/algor.pdf). The bottom line is that most computer clocks can steer to something  like 1 PPM relative to its intrinsic frequency error and without outside discipline as long as nothing violent temperature-wise is happening.
大多数人，包括我，都用所谓的艾伦偏差来描述每个时钟振荡器。底线是，大多数计算机时钟可以相对于其固有频率误差控制到1 PPM左右，并且无需外部纪律，只要没有发生剧烈的温度。

Dave 戴夫

> As [David Craggs](mailto:dcraggs@gotadsl.co.uk) (and others) pointed out, the calculation is obviously wrong: 12 PPM  correspond to 43 ms per hour, and not per day. Likewise an error of  0.602 s per fortnight corresponds to a frequency error of 0.49 PPM.
> 正如大卫·克拉格斯（David Craggs）和其他人所指出的那样，计算显然是错误的：12 PPM对应于每小时43毫秒，而不是每天。同样，每两周 0.602 秒的误差对应于 0.49 PPM 的频率误差。

------

#### 9.1.2 How can I convert a date to NTP format? 9.1.2 如何将日期转换为NTP格式？

NTP uses seconds since `1900`, while UNIX uses seconds since `1970`. The following routine by [Tom Van Baak](mailto:tvb@veritas.com) will convert the times accordingly:
NTP 使用 seconds since `1900` ，而 UNIX 使用 seconds since `1970` 。汤姆·范·巴克 （Tom Van Baak） 的以下例程将相应地转换时间：

```
/*
 * Return Modified Julian Date given calendar year,
 * month (1-12), and day (1-31). See sci.astro FAQ.
 * - Valid for Gregorian dates from 17-Nov-1858.
 */

long
DateToMjd (int y, int m, int d)
{
    return
        367 * y
        - 7 * (y + (m + 9) / 12) / 4
        - 3 * ((y + (m - 9) / 7) / 100 + 1) / 4
        + 275 * m / 9
        + d
        + 1721028
        - 2400000;
}

/*
 * Calculate number of seconds since 1-Jan-1900.
 * - Ignores UTC leap seconds.
 */

__int64
SecondsSince1900 (int y, int m, int d)
{
    long Days;

    Days = DateToMjd(y, m, d) - DateToMjd(1900, 1, 1);
    return (__int64)Days * 86400;
}
```

------

#### 9.1.3 How can I convert an NTP Timestamp to UNIX Time? 9.1.3 如何将 NTP 时间戳转换为 UNIX 时间？

The following Perl code presented by [Terje Mathisen](mailto:Terje.Mathisen@hda.hydro.com) (slightly improved by Ulrich Windl) will do the job:
以下由 Terje Mathisen 提供的 Perl 代码（由 Ulrich Windl 略有改进）将完成这项工作：

```
# usage: perl n2u.pl timestamp
# timestamp is either decimal: [0-9]+.?[0-9]*
# or hex: (0x)?[0-9]+.?(0x)?[0-9]*

# Seconds between 1900-01-01 and 1970-01-01
my $NTP2UNIX = (70 * 365 + 17) * 86400;

my $timestamp = shift;
die "Usage perl n2u.pl timestamp (with or without decimals)\n"
    unless ($timestamp ne "");

my ($i, $f) = split(/\./, $timestamp, 2);
$f ||= 0;
if ($i =~ /^0x/) {
    $i = oct($i);
    $f = ($f =~ /^0x/) ? oct($f) / 2 ** 32 : "0.$f";
} else {
    $i = int($i);
    $f = $timestamp - $i;
}

my $t = $i - $NTP2UNIX;
while ($t < 0) {
    $t += 65536.0 * 65536.0;
}

my ($year, $mon, $day, $h, $m, $s) = (gmtime($t))[5, 4, 3, 2, 1, 0];
$s += $f;

printf("%d-%02d-%02d %02d:%02d:%06.3f\n",
       $year + 1900, $mon+1, $day, $h, $m, $s);
```

------

#### 9.1.4 Where can I find more Information? 9.1.4 在哪里可以找到更多信息？

There are various sources of information about NTP. The following list is  definitely not complete, but probably a good starting point:
关于 NTP 的信息来源多种多样。以下列表肯定不完整，但可能是一个很好的起点：

- This NTP website has a lot of information about NTP and related topics.
  这个 NTP 网站有很多关于 NTP 和相关主题的信息。
- There is also the [NTP Support Wiki](https://support.ntp.org).
  还有 NTP 支持 Wiki。
- One of the oldest sources of useful information is the [NTP questions mailing list](https://lists.ntp.org/questions/). That list is visited by many beginners as well as a few experts, and occasionally even the father of NTP posted a note there.
  有用的信息最古老的来源之一是 NTP 问题邮件列表。许多初学者和一些专家都访问了该列表，有时甚至 NTP 之父也会在那里张贴一张纸条。
- The page [Time, with focus on NTP and Slovenia](https://www.ijs.si/time/) contains a good summary of time synchronization using NTP as well as  valuable references. The author allowed inclusion of his material into  this FAQ. I really appreciate that.
  “时间”页面，重点关注NTP和斯洛文尼亚，其中包含使用NTP进行时间同步的良好摘要以及有价值的参考资料。作者允许将他的材料包含在本常见问题解答中。我真的很感激。
- Technical papers by [Professor David L. Mills](https://www.nwtime.org/tribute-to-david-l-mills/) are available in the [Reference Library](https://www.ntp.org/reflib/).
  David L. Mills教授的技术论文可在参考图书馆找到。
- Various [RFCs deal with NTP](https://www.ntp.org/reflib/rfc/). While newer RFCs obsolete older ones, it might still be interesting to read the older ones.
  各种 RFC 处理 NTP。虽然较新的 RFC 淘汰了较旧的 RFC，但阅读较旧的 RFC 可能仍然很有趣。

**Table 9.1a: Some RFCs related to NTP
表 9.1a.. 与 NTP 相关的一些 RFC**

| RFC Number RFC编号 | Date 日期                   | Title or Description 标题或描述                              |
| ------------------ | --------------------------- | ------------------------------------------------------------ |
| 956                | September 1985 1985 年 9 月 | [Algorithms for synchronizing network clocks 用于同步网络时钟的算法](https://www.rfc-editor.org/rfc/rfc956) |
| 957                | September 1985 1985 年 9 月 | [Experiments in network clock synchronization 网络时钟同步实验](https://www.rfc-editor.org/rfc/rfc957) |
| 958                | September 1985 1985 年 9 月 | [Network Time Protocol (NTP) 网络时间协议 （NTP）](https://www.rfc-editor.org/rfc/rfc958) |
| 1059               | July 1988 1988 年 7 月      | [Network Time Protocol (version 1) - specification and implementation 网络时间协议（版本 1）- 规范和实现](https://www.ntp.org/reflib/rfc/rfc1059.txt) |
| 1119               | September 1989 1989 年 9 月 | [Network Time Protocol (version 2) - specification and implementation 网络时间协议（第 2 版）- 规范和实现](https://www.ntp.org/reflib/rfc/rfc1119/rfc1119b.pdf) |
| 1305               | March 1992 1992 年 3 月     | [Network Time Protocol (Version 3) - Specification, Implementation and Analysis 网络时间协议（第 3 版）- 规范、实现和分析](https://www.ntp.org/reflib/rfc/rfc1305/rfc1305b.pdf) |
| 1589               | March 1994 1994 年 3 月     | [A Kernel Model for Precision Timekeeping 精确计时的核心模型](https://www.ntp.org/reflib/rfc/rfc1589.txt) |
| 2030               | October 1996 1996 年 10 月  | [Simple Network Time Protocol (SNTP) version 4 for IPv4, IPv6 and OSI](https://www.ntp.org/reflib/rfc/rfc2030.txt). Obsoletes [RFC 1361](https://www.ntp.org/reflib/rfc/rfc1361.txt) and [RFC 1769](https://www.ntp.org/reflib/rfc/rfc1769.txt). 适用于 IPv4、IPv6 和 OSI 的简单网络时间协议 （SNTP） 版本 4。已过时的 RFC 1361 和 RFC 1769。 |
| 2783               | March 2000 2000 年 3 月     | [Pulse-Per-Second API for UNIX-like Operating Systems, Version 1.0 用于类 UNIX 操作系统的每秒脉冲 API 版本 1.0](https://www.ntp.org/reflib/rfc/rfc2783.txt) |

- Never underestimate the usefulness of Internet Search Engines like Google.  Take the time once to learn how to search efficiently, and benefit from  that knowledge every time.
  永远不要低估谷歌等互联网搜索引擎的有用性。花一次时间学习如何有效地搜索，并每次都从这些知识中受益。

------

#### 9.2 GPS 9.2 全球定位系统

This section tries to give some information about GPS.
本节尝试提供有关 GPS 的一些信息。

The Navstar Global Positioning System (GPS) was developed in the seventies  by U.S. military forces to supply position and time information all over the world. The system (to be precise: the GPS Space Segment) consists  of 28 satellites (also termed Space Vehicles) orbiting the earth in six  groups with four satellites in each group, roughly 20000km above the  surface (12 hour orbits). Current Kepler data can be found [here](https://celestrak.org/NORAD/elements/gps-ops.txt). There is also some visualization software named [WXtrack](https://www.satsignal.eu/software/wxtrack.htm).
Navstar全球定位系统（GPS）是由美国军队在七十年代开发的，用于向世界各地提供位置和时间信息。该系统（准确地说：GPS空间段）由28颗卫星（也称为太空飞行器）组成，分为六组绕地球运行，每组有四颗卫星，距离地面约20000公里（12小时轨道）。当前的开普勒数据可以在这里找到。还有一些名为WXtrack的可视化软件。

Each satellite has four atomic clocks (two Cesium, two Rubidium) for very  high precision timing on board. (The very first and the latest  satellites lack one Cesium clock.) Currently it is controlled by the  United States Air Force Space Command, Second Space Wing, Satellite  Control Squadron located at the Falcon Air Force Base in Colorado. The  satellites are monitored and controlled from four additional terrestial  stations: Hawaii, Ascension Island, Kwajalein, and Diego Garcia.
每颗卫星都有四个原子钟（两个铯，两个铷），用于在机上进行非常高精度的计时。（第一颗和最新的卫星没有一个铯钟。目前，它由位于科罗拉多州猎鹰空军基地的美国空军太空司令部第二太空联队卫星控制中队控制。这些卫星由另外四个地面站进行监测和控制：夏威夷、阿森松岛、夸贾林和迪戈加西亚。

To maintain the specified accuracy, most of the satellites require daily  updates of their data, but some of them can receive and store  corrections for several days. Under normal conditions the attitude error of the satellites is within 0.5°, and the error on the surface is 16m.  If no corrections are uploaded for 14 days, the positioning error on the surface will increase to 425m. After 180 days the error will be 10km.  If a satellite operates without current correction data, it is in *extended operation*.
为了保持指定的精度，大多数卫星需要每天更新其数据，但其中一些卫星可以接收和存储数天的校正。正常情况下，卫星的姿态误差在0.5°以内，地面误差在16m以内。如果 14 天内没有上传校正，则表面的定位误差将增加到 425m。180 天后，误差为 10  公里。如果卫星在没有当前校正数据的情况下运行，则它处于扩展运行状态。

The carrier used by the satellites to broadcast is 1.57542GHz, and the  basic information consists of a pseudo-random noise code of 1023 bits,  sent within 1ms (clocked at 1.023MHz). The noise code is specific for  each satellite, modulating the base carrier to produce a spread-spectrum signal. Transmission starts at the beginning of a new millisecond. This allows setting the receiver’s clock modulo to 1ms. The pseudo code can  be used to lock the receiver within up to 10ns, depending on the noise  of the signal. When using the carrier phase, the phase in the receiver  could be correlated as close as 1ps.
卫星用于广播的载波为1.57542GHz，基本信息由1023位的伪随机噪声码组成，发送时间为1ms（时钟频率为1.023MHz）。噪声代码特定于每颗卫星，调制基载波以产生扩频信号。传输从新的毫秒开始。这允许将接收器的时钟模设置为 1ms。伪代码可用于在长达 10ns 的时间内锁定接收器，具体取决于信号的噪声。当使用载波相位时，接收器中的相位可以相关到接近1ps。

Due to the military origin of GPS, the data is sent in a way that will not  allow obvious decoding. For example, one bit stream is combined with a  pseudo-random number sequence that spans seven days. Fortunately most of the secrets are explained today.
由于GPS的军事起源，数据的发送方式不允许明显的解码。例如，一个比特流与一个跨越 7 天的伪随机数序列相结合。幸运的是，今天大部分的秘密都得到了解释。

Basically the system works as follows:
基本上，该系统的工作原理如下：

- All satellites are tightly synchronized clocks with well-defined orbits,  defined in almanacs. Each satellite has an unique identification and  frequency that allows them to send the same signal down to earth  synchronously.
  所有卫星都是紧密同步的时钟，具有明确定义的轨道，在年历中定义。每颗卫星都有独特的标识和频率，使它们能够同步向地球发送相同的信号。

- Depending on the position of the satellite and the location of a receiver on  earth (and some other parameters like ionospheric delay), the signals  from the satellites arrive at different times.
  根据卫星的位置和接收器在地球上的位置（以及电离层延迟等其他一些参数），来自卫星的信号在不同的时间到达。

- The receivers know the exact position of every satellite using the almanac  or the ephemeris data of the satellite. Both are a collection of  parameters that describe the orbit of a satellite in terms of time. Each satellite broadcasts the almanac and the ephemeris periodically  together with the time.
  接收器使用卫星的年历或星历数据知道每颗卫星的确切位置。两者都是以时间形式描述卫星轨道的参数的集合。每颗卫星都会定期广播年历和星历以及时间。

- Initially every receiver has to get a rough estimate of its position, the current time, and the almanac. This process takes about 15 minutes to complete, frequently referred to as *cold boot*. Initially the receiver just listens to any satellite to get the current time, the satellite’s ephemeris, and the almanac. The almanac enables  the receiver to concentrate on satellites that are within view, while  the ephemeris helps to compensate for the delay and other distortions of the time signal.
  最初，每个接收器都必须对其位置、当前时间和年历进行粗略估计。此过程大约需要 15  分钟才能完成，通常称为冷启动。最初，接收器只是收听任何卫星以获取当前时间、卫星的星历和年历。年历使接收器能够专注于视野范围内的卫星，而星历表有助于补偿时间信号的延迟和其他失真。

  If the receiver has a battery-buffered clock and RAM to save time, position, and almanac, it can perform a *warm boot*. During that procedure the receiver computes the visibility of the  satellites using the almanac, the time, and the last position of the  receiver. This simplifies the procedure of tuning to the right  satellites.
  如果接收器具有电池缓冲时钟和 RAM 以节省时间、位置和年历，则可以执行热启动。在此过程中，接收机使用年历、时间和接收机的最后位置来计算卫星的能见度。这简化了调谐到正确卫星的过程。

- Using the signals from three satellites, the receiver can determine its position relative to these satellites (*2D mode*, without elevation), already giving a rather exact time. With four or  more satellites being received, the elevation can be computed as well (*3D mode*).
  使用来自三颗卫星的信号，接收器可以确定其相对于这些卫星的位置（2D模式，无仰角），已经给出了相当准确的时间。接收到四颗或更多卫星时，也可以计算高程（3D模式）。

  If a stationary receiver knows its position, it can provide accurate  timing information with just one satellite in view, assuming the  position does not change. If more satellites are in view, the GPS  receiver can better calculate time approximation using overdetermined  timing mode (limited to the number of receiver channels).
  如果静止接收机知道它的位置，它就可以提供准确的定时信息，只要能看到一颗卫星，假设位置没有改变。如果视野中有更多的卫星，GPS接收机可以使用超定定时模式（限制为接收机信道数）更好地计算时间近似值。

- Even if the main purpose of GPS is getting the exact position, it is  necessary to get the correct time first. When receiving four satellites  or more, it is possible to uniquely determine the exact position of the  receiver (imagine the intersection of spheres with a satellite at each  center).
  即使GPS的主要目的是获得确切的位置，也必须首先获得正确的时间。当接收四颗或更多卫星时，可以唯一地确定接收器的确切位置（想象一下球体与每个中心的卫星的交集）。

- Depending on the exact position of satellites and the receive conditions, the  achievable accuracy may vary, independent from the distortion that is  added to the public signals. As the needed correction data are not  publically accessible, this feature is named *Selective Availability* (SA).
  根据卫星的确切位置和接收条件，可实现的精度可能会有所不同，这与添加到公共信号的失真无关。由于所需的校正数据不可公开访问，因此此功能被命名为选择性可用性 （SA）。

The system offers two classes of precision:
该系统提供两类精度：

- High precision (Precision Positioning Service, P-code) for military use only (16m both horizontal and vertical).
  高精度（精确定位服务，P 代码）仅供军事使用（水平和垂直均为 16m）。

- Rough resolution (Coarse Acquisition, C/A-code, Standard Positioning Service) for public use (100m horizontal, 165m vertical). This service may be  shut down or distorted in time of a crisis (or maybe whenever the  military forces like to do so).
  供公众使用的粗略分辨率（粗略采集、C/A 代码、标准定位服务）（水平 100 米，垂直 165 米）。这项服务可能会在危机发生时（或者可能在军队愿意这样做的时候）被关闭或扭曲。

  The precision may be further degraded by Selective Availability (SA) which  was implemented in 1991, and turned off on May 2, 2000 at 0400 UTC.
  1991 年实施的选择性可用性 （SA） 可能会进一步降低精度，并于 2000 年 5 月 2 日 0400 UTC 关闭。

Although derived from [UTC](https://www.ntp.org/ntpfaq/ntp-s-time/#22-what-is-utc), as presented by the U.S. Naval Observatory master clock, the UTC(USNO  MC), GPS time does not include leap seconds found in UTC, but the data  stream provides the difference from UTC in seconds. At the time of  writing the difference is 18s. While the difference between UTC and GPS  time will change over time, there’s a fixed offset between TAI and GPS  time (19 seconds).
虽然源自美国海军天文台主时钟 UTC（USNO MC） 的 UTC，但 GPS 时间不包括 UTC 中的闰秒，但数据流提供了与 UTC  的差异（以秒为单位）。在撰写本文时，差异是 18 秒。虽然 UTC 和 GPS 时间之间的差异会随时间而变化，但 TAI 和 GPS  时间之间存在固定偏移量（19 秒）。

The latest versions of the GPS Interface Control Documents (ICDs) and Interface Specifications (ISs) are available from https://www.gps.gov/technical/icwg/.
最新版本的 GPS 接口控制文档 （ICD） 和接口规范 （IS） 可从 https://www.gps.gov/technical/icwg/ 获得。

**Example 9.2a: A Glance at the GPS Sky
例 9.2a.. GPS 天空一瞥**

At the time of writing I could see five out of nine visible satellites, the best candidates being `24`, `5`, `4`, and `9`. From Table 9.2a you can see that my window is in the east, and that I  have a rather nice view out there. From these data, GPS receiver  computed my position as `49° 11' 42" N, 12° 16' 12" E, 260m`.
在撰写本文时，我可以看到九颗可见卫星中的五颗，最好的候选卫星是 `24` 、 `5` 、和 `4` `9` 。从表9.2a中，您可以看到我的窗户在东边，而且那里的景色相当不错。根据这些数据，GPS接收器计算出我的位置 `49° 11' 42" N, 12° 16' 12" E, 260m` 为。

**Table 9.2a: GPS Satellites
表9.2a.. GPS卫星**

| Number 数 | Elevation 海拔 | Azimuth 方位角 | Distance 距离     | Doppler Effect 多普勒效应 |
| --------- | -------------- | -------------- | ----------------- | ------------------------- |
| 4         | 24°            | 50°            | 23357km 23357公里 | -1.151kHz -1.151k赫兹     |
| 5         | 63°            | 80°            | 20737km 20737公里 | -1.462kHz -1.462k赫兹     |
| 9         | 27°            | 146°           | 23212km 23212公里 | -3.446kHz -3.446k赫兹     |
| 24        | 34°            | 94°            | 22594km 22594公里 | +1.237kHz +1.237k赫兹     |

**Example 9.2b: The Effects of Selective Availability
例 9.2b.. 选择性可用性的影响**

Most GPS receivers are unable to compensate for Selective Availability. As a virtually changing position causes time offsets (roughly 3ns per  meter), it’s interesting what the effects of SA are. For my GPS167 from  Meinberg I examined the `gps_position(LLA)` that the clock driver showed. The following graphic shows the changing position over time, including a smoothed path.
大多数 GPS 接收器无法补偿选择性可用性。由于虚拟位置变化会导致时间偏移（大约每米 3 纳秒），因此 SA 的影响很有趣。对于我的 Meinberg 的 GPS167，我检查了时钟驱动器显示的内容 `gps_position(LLA)` 。下图显示了随时间变化的位置，包括平滑路径。



  ![img](https://www.ntp.org/ntpfaq/GPS167_XY.png)



These position changes have a comparatively small effect on time accuracy,  but if one considers the computed altitude, the huge changes can  accumulate to a few hundred nanoseconds. The following graph shows the  varying altitude over time.
这些位置变化对时间精度的影响相对较小，但如果考虑计算出的高度，巨大的变化可以累积到几百纳秒。下图显示了随时间变化的高度。



  ![img](https://www.ntp.org/ntpfaq/GPS167_Z.png)



Finally, the following figure combines the three coordinates in space to give you an impression on how accurate GPS is:
最后，下图将空间中的三个坐标组合在一起，让您了解GPS的精确度：



  ![img](https://www.ntp.org/ntpfaq/GPS167_XYZ.png)



------

#### 9.2.1 Selective Availability revisited 9.2.1 重新审视选择性可用性

On May 1st, 2000 there was an announcement about turning off Selective Availability (SA). The document titled *President Clinton: Improving the Civilian Global Positioning System (GPS)* quotes Bill Clinton: “The decision to discontinue Selective  Availability is the latest measure in an ongoing effort to make GPS more responsive to civil and commercial users worldwide. –This increase in  accuracy will allow new GPS applications to emerge and continue to  enhance the lives of people around the world.”
2000 年 5 月 1 日，发布了有关关闭选择性可用性 （SA）  的公告。题为《克林顿总统：改进民用全球定位系统（GPS）》的文件引用了比尔·克林顿的话：“停止选择性可用性的决定是使GPS对全球民用和商业用户更加敏感的持续努力的最新措施。精度的提高将使新的GPS应用出现，并继续改善世界各地人们的生活。

However the algorithm that is used for SA is not explained, and it seems SA has just been replaced by more selective availability. “New technologies  demonstrated by the military enable the U.S. to degrade the GPS signal  on a regional basis. GPS users worldwide would not be affected by  regional, security-motivated, GPS degradations, and businesses reliant  on GPS could continue to operate at peak efficiency.” Pay attention to  the wording (…) “could continue to operate (…)").
但是，没有解释用于 SA 的算法，似乎 SA  刚刚被更具选择性的可用性所取代。“军方展示的新技术使美国能够在区域基础上降低GPS信号。全球GPS用户不会受到区域性、安全动机、GPS性能下降的影响，依赖GPS的企业可以继续以最高效率运营。注意措辞（...“可以继续运行（...）”）。

# Common Terms and Acronyms 常用术语和缩略语

Last update: April 3, 2024 16:42 UTC ([f170361b7](https://git.nwtime.org/websites/ntpwww/commit/f170361b72193f7af81935c6c0a4afda96793f0d))
最后更新： 2024年4月3日 16：42 UTC （ f170361b7）

- anal-retentive programmer 肛门保留程序员

  Probably the opposite of the famous “real programmer”, used by [Professor David L. Mills](https://www.nwtime.org/tribute-to-david-l-mills/). 可能与David L. Mills教授使用的著名的“真正的程序员”相反。

- AM

  Amplitude Modulation. Information is encoded in the strength of the signal. 调幅。信息以信号的强度进行编码。

- APM

  Automatic Power Management, a feature found in modern PCs to reduce power  consumption if the system is idle. APM consists of hardware and  software. 自动电源管理，这是现代 PC 中的一项功能，可在系统空闲时降低功耗。APM 由硬件和软件组成。

- DES

  Data Encryption Standard, defined in *Federal Information Processing Standards Publication 46* dated 1977 January 15. DES is an algorithm to encrypt a 64 bit value  using a 56 bit key, giving 64 bit. Once developed and published to make  secure communication possible, not allowed to be exported from USA  (except in books about computer science), finally obsoleted by newer  algorithms using a longer key. DES is not considered secure any more,  and there were rumours about some back-door in the algorithm, but that’s another story. 数据加密标准，定义于 1977 年 1 月 15 日的联邦信息处理标准出版物 46。DES 是一种使用 56 位密钥加密 64 位值的算法，提供 64  位。一旦开发和发布以使安全通信成为可能，就不允许从美国出口（除了关于计算机科学的书籍），最终被使用更长密钥的更新算法所淘汰。DES不再被认为是安全的，并且有传言说算法中有一些后门，但那是另一回事了。

- ESD

  Electrostatic Discharge. 静电放电。

- FM

  Frequency Modulation. Information is encoded in the frequency of the signal. 调频。信息以信号的频率进行编码。

- IETF IETF公司

  Internet Engineering Task Force, people that try to establish acceptable standards for the Internet community. 互联网工程任务组，试图为互联网社区建立可接受的标准的人。

- IRIG IRIG公司

  Inter-Range Instrumentation Group, an early attempt to synchronize time for instruments. Inter-Range Instrumentation Group，这是同步仪器时间的早期尝试。

- LAN

  Local Area Network. Generally a high speed Ethernet network. 局域网。一般为高速以太网网络。

- MD5

  MD5 is an acronym for Message Digest #5, a strong one-way hash function designed by Ronald L. Rivest and described in [RFC 1321](https://www.ntp.org/reflib/rfc/rfc1321.txt). The result is 128 bits wide. MD5 是 Message Digest #5 的首字母缩写词，这是一个由 Ronald L. Rivest 设计并在 RFC 1321 中描述的强单向哈希函数。结果是 128 位宽。

- NTP

  Network Time Protocol, a protocol to exchange and synchronize time on computer networks. 网络时间协议，一种在计算机网络上交换和同步时间的协议。

- PPM

  Part Per Million, a measure for tiny quantities, usually used instead of percent. 百万分之一，微量的度量，通常用于代替百分比。

- PPS

  Pulse Per Second is a method to fine-tune frequency and offset errors using NTP. 每秒脉冲是一种使用 NTP 微调频率和失调误差的方法。

- Real Programmer 真正的程序员

  Real Programmers writing self-modifying FORTRAN code to save a clock cycle or two in a loop no longer exist. 真正的程序员编写自我修改的FORTRAN代码以在循环中节省一两个时钟周期已不复存在。

- RFC

  Request For Comments, a document describing an informal Internet standard. Numbers for RFCs are assigned by the IETF. 征求意见，描述非正式互联网标准的文档。RFC 的编号由 IETF 分配。

- SA

  Selective Availability, sometimes also called dither, the fact that the GPS  information available to the public is made inexact by some non-obvious  method. See also [Section 9.2](https://www.ntp.org/ntpfaq/ntp-s-related/#92-gps). 选择性可用性，有时也称为抖动，即通过一些不明显的方法使公众可用的 GPS 信息变得不精确。另请参阅第 9.2 节。