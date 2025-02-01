# Rate Management and the Kiss-o'-Death Packet 速率管理和 Kiss-o'-Death 数据包

Last update: May 3, 2023 17:13 UTC ([e8077bcf6](https://git.nwtime.org/websites/ntpwww/commit/e8077bcf69e59dfa15456e620ae92c5781aaf9aa))
最后更新： May 3， 2023 17：13 UTC （ e8077bcf6）



  ![gif](https://www.ntp.org/documentation/pic/boom4.gif)

[from *Pogo*, Walt Kelly 与Pogo， Walt Kelly相比](https://www.ntp.org/reflib/pictures/)



Our junior managers and the administrators.
我们的初级经理和行政人员。

------

#### Table of Contents 目录

- [Introduction 介绍](https://www.ntp.org/documentation/4.2.8-series/rate/#introduction)
- [Minimum Headway Time 最短前进时间](https://www.ntp.org/documentation/4.2.8-series/rate/#minimum-headway-time)
- [Minimum Average Headway Time
  最短平均前进时间](https://www.ntp.org/documentation/4.2.8-series/rate/#minimum-average-headway-time)
- [The Kiss of Death Packet
  死亡之吻包](https://www.ntp.org/documentation/4.2.8-series/rate/#the-kiss-of-death-packet)
- [References 引用](https://www.ntp.org/documentation/4.2.8-series/rate/#references)

------

#### Introduction 介绍

This page describes the various rate management provisions in NTPv4. Some  national time metrology laboratories, including NIST and USNO, use the  NTP reference implementation in their very busy public time servers.  They operate multiple servers behind load-balancing devices to support  aggregate rates up to ten thousand packets per second. The servers need  to defend themselves against all manner of broken client implementations that can clog the server and network infrastructure. On the other hand, friendly clients need to avoid configurations that can result in  unfriendly behavior.
本页介绍 NTPv4  中的各种费率管理规定。一些国家时间计量实验室，包括NIST和USNO，在其非常繁忙的公共时间服务器中使用NTP参考实现。它们在负载平衡设备后面运行多个服务器，以支持高达每秒一万个数据包的聚合速率。服务器需要保护自己免受各种损坏的客户端实现的影响，这些实现可能会阻塞服务器和网络基础设施。另一方面，友好的客户端需要避免可能导致不友好行为的配置。

A review of past client abuse incidence shows the most frequent scenario  is a broken client that attempts to send packets at rates of one per  second or more. On one occasion due to a defective client design [1](https://www.ntp.org/documentation/4.2.8-series/rate/#myfootnote1), over 750,000 clients demonstrated this abuse. There have been occasions where this abuse has persisted for days at a time. These scenarios are  the most damaging, as they can threaten not only the victim server but  the network infrastructure as well.
对过去客户端滥用事件的回顾表明，最常见的情况是客户端中断，它试图以每秒一个或更高的速率发送数据包。有一次，由于客户端设计 [1](https://www.ntp.org/documentation/4.2.8-series/rate/#myfootnote1) 有缺陷，超过750,000名客户端表现出这种滥用行为。有时，这种虐待行为一次持续数天。这些场景最具破坏性，因为它们不仅会威胁受害者服务器，还会威胁网络基础设施。

There are several features in the reference implementation designed to defend the servers and network against accidental or intentional flood attack. Other features are used to insure that the client is a good citizen,  even if configured in unfriendly ways. The ground rules are:
参考实现中有几个功能旨在保护服务器和网络免受意外或故意的洪水攻击。其他功能用于确保客户端是一个好公民，即使以不友好的方式配置也是如此。基本规则是：

- Send at the lowest rate consistent with the expected accuracy requirements.
  以符合预期精度要求的最低速率发送。
- Maintain strict guard time and minimum average headway time, even if multiple  burst options and/or the Autokey protocol are operating.
  保持严格的保护时间和最小的平均前进时间，即使多个突发选项和/或自动密钥协议正在运行。
- When the first packet of a burst is sent to a server, do not send further  packets until the first packet has been received from the server.
  当突发的第一个数据包发送到服务器时，在从服务器收到第一个数据包之前，不要再发送其他数据包。
- Upon receiving a [Kiss-o'-Death packet](https://www.ntp.org/documentation/4.2.8-series/rate/#the-kiss-of-death-packet) (KoD), immediately reduce the sending rate.
  收到 Kiss-o'-Death 数据包 （KoD） 后，立即降低发送速率。

Rate management involves four algorithms to manage resources: (1) poll rate  control, (2) burst control, (3) average headway time and (4) guard time. The first two algorithms are described on the [Poll Program](https://www.ntp.org/documentation/4.2.8-series/poll/) page; the remaining two are described in following sections.
速率管理涉及四种管理资源的算法：（1） 轮询速率控制，（2） 突发控制，（3） 平均前进时间和 （4） 保护时间。前两种算法在投票程序页面上进行了描述;其余两个将在以下各节中介绍。

------

#### Minimum Headway Time 最短前进时间

The headway is defined for each source as the interval between the last  packet sent or received and the next packet for that source. The minimum receive headway is defined as the guard time. In the reference  implementation, if the receive headway is less than the guard time, the  packet is discarded. The guard time defaults to 2 s, but this can be  changed using the `minimum` option of the [`discard`](https://www.ntp.org/documentation/4.2.8-series/accopt/) command. By design, the minimum interval between `burst` and `iburst` packets sent by any client is 2 s, which does not violate this  constraint. Packets sent by other implementations that violate this  constraint will be dropped and a KoD packet returned, if enabled.
每个源的进度定义为发送或接收的最后一个数据包与该源的下一个数据包之间的间隔。最小接收距离定义为保护时间。在参考实现中，如果接收进度小于保护时间，则丢弃数据包。保护时间默认为 2 秒，但可以使用 `discard` 命令 `minimum` 的选项进行更改。根据设计，任何客户端发送的数据包之间的 `burst`  `iburst` 最小间隔为 2 秒，这不违反此约束。如果启用，则违反此约束的其他实现发送的数据包将被丢弃并返回 KoD 数据包。

------

#### Minimum Average Headway Time 最短平均前进时间

There are two features in the reference implementation to manage the minimum  average headway time between one packet and the next, and thus the  maximum average rate for each source. The transmit throttle limits the  rate for transmit packets, while the receive discard limits the rate for receive packets. These features make use of a pair of counters: a  client output counter for each association and a server input counter  for each distinct client IP address. For each packet received, the input counter increments by a value equal to the minimum average headway  (MAH) and then decrements by one each second. For each packet  transmitted, the output counter increments by the MAH and then  decrements by one each second. The default MAH is 8 s, but this can be  changed using the `average` option of the [`discard`](https://www.ntp.org/documentation/4.2.8-series/accopt/) command.
参考实现中有两个功能，用于管理一个数据包和下一个数据包之间的最小平均前进时间，从而管理每个源的最大平均速率。传输限制限制传输数据包的速率，而接收丢弃限制接收数据包的速率。这些功能使用一对计数器：每个关联的客户端输出计数器和每个不同的客户端 IP 地址的服务器输入计数器。对于接收的每个数据包，输入计数器按等于最小平均头程 （MAH）  的值递增，然后每秒递减一个。对于传输的每个数据包，输出计数器按 MAH 递增，然后每秒递减一个。默认 MAH 为 8 秒，但可以使用 `discard` 命令 `average` 的选项进行更改。

If the `iburst` or `burst` options are present, the poll algorithm sends a burst of packets  instead of a single packet at each poll opportunity. The NTPv4  specification requires that bursts contain no more than eight packets.  Starting from an output counter value of zero, the maximum counter  value, called the ceiling, can be no more than eight times the MAH.  However, if the burst starts with a counter value other than zero, there is a potential to exceed the ceiling. This can result from protocol  restarts and/or Autokey protocol operations. In these cases the poll  algorithm throttles the output rate by computing an additional headway  time so that the next packet sent will not exceed the ceiling. Designs  such as this are often called leaky buckets.
如果存在 `iburst` or `burst` 选项，则轮询算法会在每个轮询机会发送突发数据包，而不是单个数据包。NTPv4 规范要求突发包含不超过 8  个数据包。从输出计数器值为零开始，最大计数器值（称为上限）不能超过MAH的八倍。但是，如果突发以非零的反值开始，则有可能超过上限。这可能是由于协议重启和/或自动键协议操作导致的。在这些情况下，轮询算法通过计算额外的前进时间来限制输出速率，以便发送的下一个数据包不会超过上限。诸如此类的设计通常被称为漏水桶。

The reference implementation uses a special most-recently used (MRU) list  of entries, one entry for each distinct client IP address found. Each  entry includes the IP address, input counter and process time at the  last packet arrival. As each packet arrives, the IP source address is  compared to the IP address in each entry in turn. If a match is found  the entry is removed and inserted first on the list. If the IP source  address does not match any entry, a new entry is created and inserted  first, possibly discarding the last entry if the list is full. Observers will note this is the same algorithm used for page replacement in  virtual memory systems. However, in the virtual memory algorithm the  entry of interest is the last, whereas here the entry of interest is the first.
参考实现使用特殊的最近使用的 （MRU） 条目列表，找到的每个不同的客户端 IP 地址都有一个条目。每个条目都包括最后一次数据包到达时的 IP  地址、输入计数器和处理时间。当每个数据包到达时，将 IP 源地址依次与每个条目中的 IP  地址进行比较。如果找到匹配项，则该条目将被删除并首先插入列表中。如果 IP  源地址与任何条目都不匹配，则首先创建一个新条目并插入，如果列表已满，则可能会丢弃最后一个条目。观察者会注意到，这与虚拟内存系统中用于页面替换的算法相同。但是，在虚拟内存算法中，感兴趣的条目是最后一个，而在这里，感兴趣的条目是第一个。

The input counter for the first entry on the MRU list, representing the  current input packet, is decreased by the interval since the entry was  last referenced, but not below zero. If the input counter is greater  than the ceiling, the packet is discarded. Otherwise, the counter is  increased by the MAH and the packet is processed. The result is, if the  client maintains an average headway greater than the ceiling and  transmits no more than eight packets in a burst, the input counter will  not exceed the ceiling. Packets sent by other implementations that  violate this constraint will be dropped and a KoD packet returned, if  enabled.
MRU  列表中第一个条目的输入计数器（表示当前输入数据包）会按上次引用该条目的时间间隔减少，但不低于零。如果输入计数器大于上限，则丢弃数据包。否则，计数器将增加 MAH 并处理数据包。结果是，如果客户端保持大于上限的平均头程，并且在突发中传输不超过 8  个数据包，则输入计数器不会超过上限。如果启用，则违反此约束的其他实现发送的数据包将被丢弃并返回 KoD 数据包。

The reference implementation has a maximum MRU list size of a few hundred  entries. The national time servers operated by NIST and USNO have an  aggregate packet rate in the thousands of packets per second from many  thousands of customers. Under these conditions, the list overflows after only a few seconds of traffic. However, analysis shows that the vast  majority of the abusive traffic is due to a tiny minority of the  customers, some of which send at over one packet per second. This means  that the few seconds retained on the list is sufficient to identify and  discard by far the majority of the abusive traffic.
参考实现的最大 MRU  列表大小为几百个条目。由NIST和USNO运营的国家时间服务器具有来自数千个客户的每秒数千个数据包的总数据包速率。在这些情况下，列表仅在几秒钟的流量后溢出。然而，分析表明，绝大多数滥用流量是由于极少数客户造成的，其中一些客户每秒发送超过一个数据包。这意味着在列表中保留的几秒钟足以识别和丢弃迄今为止的大部分滥用流量。

------

#### The Kiss-of-Death Packet 死亡之吻包

Ordinarily, packets denied service are simply dropped with no further action except incrementing statistics counters. Sometimes a more proactive response  is needed to cause the client to slow down. A special packet has been  created for this purpose called the kiss-o'-death (KoD) packet. KoD  packets have leap indicator 3, stratum 0 and the reference identifier  set to a four-octet ASCII code. At present, only one code `RATE` is sent by the server if the `limited` and `kod` flags of the [`restrict`](https://www.ntp.org/documentation/4.2.8-series/accopt/) command are present and either the guard time or MAH time are violated.
通常，数据包被拒绝的服务只是被丢弃，除了递增统计计数器外，没有进一步的操作。有时需要更主动的响应来使客户端放慢速度。为此目的创建了一个特殊的数据包，称为 kiss-o'-death （KoD） 数据包。KoD 数据包具有闰示符 3、第 0 层和设置为四个八位字节 ASCII  码的引用标识符。目前，如果 `restrict` 存在命令的 `limited` 和 `kod` 标志，并且违反了保护时间或 MAH 时间，则服务器只发送一个代码 `RATE` 。

A client receiving a KoD packet is expected to slow down; however, no  explicit mechanism is specified in the protocol to do this. In the  reference implementation, the server sets the poll field of the KoD  packet to the greater of (a) the server MAH and (b) client packet poll  field. In response to the KoD packet, the client sets the peer poll  interval to the maximum of (a) the client MAH and (b) the server packet  poll field. This automatically increases the headway for following  client packets.
接收 KoD 数据包的客户端预计会变慢;但是，协议中没有指定明确的机制来执行此操作。在参考实现中，服务器将 KoD 数据包的轮询字段设置为 （a）  服务器 MAH 和 （b） 客户端数据包轮询字段中的较大值。为了响应 KoD 数据包，客户端将对等轮询间隔设置为 （a） 客户端 MAH 和  （b） 服务器数据包轮询字段的最大值。这会自动增加后续客户端数据包的进度。

In order to make sure the client notices the KoD packet, the server sets  the receive and transmit timestamps to the transmit timestamp of the  client packet. Thus, even if the client ignores all except the  timestamps, it cannot do any useful time computations. KoD packets  themselves are rate limited to no more than one packet per guard time,  in order to defend against flood attacks.
为了确保客户端注意到 KoD 数据包，服务器将接收和发送时间戳设置为客户端数据包的传输时间戳。因此，即使客户端忽略除时间戳之外的所有时间，它也无法进行任何有用的时间计算。KoD 数据包本身的速率限制为每次保护时间不超过一个数据包，以防御洪水攻击。

------

#### References 引用

1  Mills, D.L., J. Levine, R. Schmidt and D. Plonka. Coping with overload on the Network Time Protocol public servers. *Proc. Precision Time and Time Interval (PTTI) Applications and Planning Meeting* (Washington DC, December 2004), 5-16. Paper: [PDF](https://www.ntp.org/reflib/papers/ptti/ptti04a.pdf), Slides:[PDF](https://www.ntp.org/reflib/brief/ptti/ptti04.pdf)
1 米尔斯，DL，J.莱文，R.施密特和D.普隆卡。应对网络时间协议公共服务器上的过载。精确时间和时间间隔 （PTTI） 应用和规划会议（华盛顿特区，2004 年 12 月），第 5-16 页。纸张：PDF，幻灯片：PDF