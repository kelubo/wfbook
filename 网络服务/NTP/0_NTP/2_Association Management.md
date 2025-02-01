# Association Management 协会管理

Last update: November 23, 2022 17:49 UTC ([1b4d24aef](https://git.nwtime.org/websites/ntpwww/commit/1b4d24aef65c630791ad0f89d6c09ec258781c2c))
最后更新： 2022年11月23日 17：49 UTC （ 1b4d24aef）



  ![gif](https://www.ntp.org/documentation/pic/alice51.gif)

[from *Alice’s Adventures in Wonderland*, Lewis Carroll
摘自《爱丽丝梦游仙境》，刘易斯·卡罗尔](https://www.ntp.org/reflib/pictures/)



Make sure who your friends are.
确定你的朋友是谁。

------

#### Table of Contents 目录

- [Association Modes 关联模式](https://www.ntp.org/documentation/4.2.8-series/assoc/#association-modes)
- [Client/Server Mode 客户端/服务器模式](https://www.ntp.org/documentation/4.2.8-series/assoc/#clientserver-mode)
- [Symmetric Active/Passive Mode
  对称主动/被动模式](https://www.ntp.org/documentation/4.2.8-series/assoc/#symmetric-activepassive-mode)
- [Broadcast/Multicast Modes
  广播/组播模式](https://www.ntp.org/documentation/4.2.8-series/assoc/#broadcastmulticast-modes)
- [Manycast and Pool Modes
  多播和池模式](https://www.ntp.org/documentation/4.2.8-series/assoc/#manycast-and-pool-modes)
- [Poll Interval Management
  轮询间隔管理](https://www.ntp.org/documentation/4.2.8-series/assoc/#poll-interval-management)
- [Burst Options 突发选项](https://www.ntp.org/documentation/4.2.8-series/assoc/#burst-options)

------

#### Association Modes 关联模式

This page describes the various modes of operation provided in NTPv4. There are three types of associations in NTP: *persistent*, *preemptable* and *ephemeral*. Persistent associations are mobilized by a configuration command and  never demobilized. Preemptable associations, which are new to NTPv4, are mobilized by a configuration command which includes the `preempt` option or upon arrival of an automatic server discovery packet. They  are demobilized by timeout or when preempted by a “better” server, as  described on the [Automatic Server Discovery Schemes](https://www.ntp.org/documentation/4.2.8-series/discover/) page. Ephemeral associations are mobilized upon arrival of broadcast or multicast server packets and demobilized by timeout.
本页介绍 NTPv4 中提供的各种操作模式。NTP 中有三种类型的关联：持久性关联、抢占关联和短暂关联。持久性关联由配置命令调动，并且永远不会复员。NTPv4 中新增的可抢占关联由包含 `preempt` 选项的配置命令或在自动服务器发现数据包到达时进行调动。它们会因超时或被“更好的”服务器抢占而复员，如“自动服务器发现方案”页上所述。临时关联在广播或组播服务器数据包到达时被调动，并通过超时被解除。

Ordinarily, successful mobilization of ephemeral associations requires the server  to be cryptographically authenticated to the client. This can be done  using either symmetric key or Autokey public key cryptography, as  described on the [Authentication Support](https://www.ntp.org/documentation/4.2.8-series/authentic/) page.
通常，成功调动临时关联需要对服务器进行加密身份验证。这可以使用对称密钥或自动密钥公钥加密来完成，如“身份验证支持”页中所述。

There are three principal modes of operation in NTP: client/server, symmetric active/passive and broadcast/multicast. There are three automatic  server discovery schemes in NTP: broadcast/multicast, manycast and pool  described on the [Automatic Server Discovery Schemes](https://www.ntp.org/documentation/4.2.8-series/discover/) page. In addition, the [burst options](https://www.ntp.org/documentation/4.2.8-series/assoc/#burst-options) and [orphan mode](https://www.ntp.org/documentation/4.2.8-series/orphan/) can be used in appropriate cases.
NTP 中有三种主要操作模式：客户端/服务器、对称主动/被动和广播/组播。NTP 中有三种自动服务器发现方案：广播/组播、manycast 和 pool，详见“自动服务器发现方案”页。此外，突发选项和孤立模式可以在适当的情况下使用。

Following is a summary of the operations in each mode. Note that reference to option applies to the commands described on the [Server Commands and Options](https://www.ntp.org/documentation/4.2.8-series/confopt/) page. See that page for applicability and defaults.
以下是每种模式下的操作摘要。请注意，对选项的引用适用于“服务器命令和选项”页上描述的命令。请参阅该页面，了解适用性和默认值。

------

#### Client/Server Mode 客户端/服务器模式

Client/server mode is the most common configuration in the Internet today. It  operates in the classic remote-procedure-call (RPC) paradigm with  stateless servers and stateful clients. In this mode a host sends a  client (mode 3) request to the specified server and expects a server  (mode 4) reply at some future time. In some contexts this would be  described as a “pull” operation, in that the host pulls the time and  related values from the server.
客户端/服务器模式是当今 Internet 中最常见的配置。它以经典的远程过程调用 （RPC）  范式运行，具有无状态服务器和有状态客户端。在此模式下，主机向指定的服务器发送客户端（模式 3）请求，并期望服务器（模式  4）在将来的某个时间进行回复。在某些情况下，这将被描述为“拉取”操作，因为主机从服务器拉取时间和相关值。

A host is configured in client mode using the `server` (sic) command and specifying the server DNS name or IPv4 or IPv6 address; the server requires no prior configuration. The `iburst` option described later on this page is recommended for clients, as this speeds up initial synchronization from several minutes to several  seconds. The `burst` option described later on this page can be useful to reduce jitter on very noisy dial-up or ISDN network links.
使用 `server` （sic） 命令在客户端模式下配置主机并指定服务器 DNS 名称或 IPv4 或 IPv6 地址;服务器不需要事先配置。建议客户端使用 `iburst` 本页后面介绍的选项，因为这会将初始同步速度从几分钟缩短到几秒钟。本页后面介绍的 `burst` 选项可用于减少非常嘈杂的拨号或 ISDN 网络链路上的抖动。

Ordinarily, the program automatically manages the poll interval between the default minimum and maximum values. The `minpoll` and `maxpoll` options can be used to bracket the range. Unless noted otherwise, these options should not be used with reference clock drivers.
通常，程序会自动管理默认最小值和最大值之间的轮询间隔。 `minpoll` 和 `maxpoll` 选项可用于括号化范围。除非另有说明，否则这些选项不应与参考时钟驱动器一起使用。

------

#### Symmetric Active/Passive Mode 对称主动/被动模式

Symmetric active/passive mode is intended for configurations where a clique of  low-stratum peers operate as mutual backups for each other. Each peer  operates with one or more primary reference sources, such as a reference clock, or a set of secondary (stratum, 2) servers known to be reliable  and authentic. Should one of the peers lose all reference sources or  simply cease operation, the other peers will automatically reconfigure  so that time and related values can flow from the surviving peers to all hosts in the subnet. In some contexts this would be described as a  “push-pull” operation, in that the peer either pulls or pushes the time  and related values depending on the particular configuration.
对称主动/被动模式适用于低层对等体集团作为彼此的相互备份运行的配置。每个对等体都使用一个或多个主要参考源（例如参考时钟）或一组已知可靠且真实的辅助（第 2  层）服务器进行操作。如果其中一个对等体丢失所有引用源或只是停止操作，其他对等体将自动重新配置，以便时间和相关值可以从幸存的对等体流向子网中的所有主机。在某些情况下，这将被描述为“推拉”操作，因为对等体根据特定配置拉取或推送时间和相关值。

A symmetric active peer sends a symmetric active (mode 1) message to a  designated peer. If a matching configured symmetric active association  is found, the designated peer returns a symmetric active message. If no  matching association is found, the designated peer mobilizes a ephemeral symmetric passive association and returns a symmetric passive (mode 2)  message. Since an intruder can impersonate a symmetric active peer and  cause a spurious symmetric passive association to be mobilized,  symmetric passive mode should always be cryptographically validated.
对称活动对等体向指定的对等体发送对称活动（模式  1）消息。如果找到匹配的配置对称活动关联，则指定的对等方将返回对称活动消息。如果未找到匹配的关联，则指定的对等体将调动临时对称被动关联并返回对称被动（模式 2）消息。由于入侵者可以模拟对称活动对等体并导致调动虚假的对称被动关联，因此应始终对对称被动模式进行加密验证。

A peer is configured in symmetric active mode using the `peer` command and specifying the other peer DNS name or IPv4 or IPv6 address. The `burst` and `iburst` options should not be used in symmetric modes, as this can upset the  intended symmetry of the protocol and result in spurious duplicate or  dropped messages.
使用命令 `peer` 在对称活动模式下配置对等体，并指定其他对等体 DNS 名称或 IPv4 或 IPv6 地址。 `burst` 不应在对称模式下使用 and `iburst` 选项，因为这可能会破坏协议的预期对称性，并导致虚假重复或丢弃的消息。

As symmetric modes are most often used as root servers for moderate to  large subnets where rapid response is required, it is generally best to  set the minimum and maximum poll intervals of each root server to the  same value using the `minpoll` and `maxpoll` options.
由于对称模式最常用作需要快速响应的中型到大型子网的根服务器，因此通常最好使用 `minpoll` and `maxpoll` 选项将每个根服务器的最小和最大轮询间隔设置为相同的值。

------

#### Broadcast/Multicast Modes 广播/组播模式

NTP broadcast and multicast modes are intended for configurations involving one or a few servers and a possibly very large client population.  Broadcast mode can be used with Ethernet, FDDI and WiFi spans  interconnected by hubs or switches. Ordinarily, broadcast packets do not extend beyond a level-3 router. Where service is intended beyond a  level-3 router, multicast mode can be used. Additional information is on the [Automatic NTP Configuration Options](https://www.ntp.org/documentation/4.2.8-series/discover/) page.
NTP 广播和组播模式适用于涉及一台或多台服务器以及可能非常大的客户端群的配置。广播模式可用于通过集线器或交换机互连的以太网、FDDI 和 WiFi  跨度。通常，广播数据包不会超出 3 级路由器。如果服务超出 3 级路由器，则可以使用组播模式。其他信息位于“自动 NTP 配置选项”页上。

A server is configured to send broadcast or multicast messages using the `broadcast` command and specifying the subnet address for broadcast or the  multicast group address for multicast. A broadcast client is enabled  using the [`broadcastclient`](https://www.ntp.org/documentation/4.2.8-series/confopt/#auxiliary-commands) command, while a multicast client is enabled using the [`multicastclient`](https://www.ntp.org/documentation/4.2.8-series/confopt/#auxiliary-commands) command and specifying the multicast group address. Multiple commands  of either type can be used. However, the association is not mobilized  until the first broadcast or multicast message is actually received.
服务器配置为使用命令 `broadcast` 发送广播或多播消息，并指定用于广播的子网地址或用于多播的组播组地址。使用命令 `broadcastclient` 启用广播客户端，而使用命令 `multicastclient` 并指定组播组地址启用组播客户端。可以使用任一类型的多个命令。但是，在实际收到第一个广播或多播消息之前，不会调动关联。

------

#### Manycast and Pool Modes 多播和池模式

Manycast and pool modes are automatic discovery and configuration paradigms new  to NTPv4. They are intended as a means for a client to troll the nearby  network neighborhood to find cooperating willing servers, validate them  using cryptographic means and evaluate their time values with respect to other servers that might be lurking in the vicinity. The intended  result is that each client mobilizes ephemeral client associations with  some number of the “best” of the nearby servers, yet automatically  reconfigures to sustain this number of servers should one or another  fail. Additional information is on the [Automatic Server Discovery Schemes](https://www.ntp.org/documentation/4.2.8-series/discover/) page.
多播和池模式是 NTPv4  中新增的自动发现和配置范例。它们旨在作为客户端在附近的网络邻域中寻找愿意合作的服务器的一种手段，使用加密手段验证它们，并评估它们相对于可能潜伏在附近的其他服务器的时间值。预期的结果是，每个客户端都与附近一些“最佳”服务器一起移动临时客户端关联，但在一台或另一台服务器发生故障时自动重新配置以维持此数量的服务器。其他信息位于“自动服务器发现方案”页上。

------

#### Poll Interval Management 轮询间隔管理

NTP uses an intricate heuristic algorithm to automatically control the poll interval for maximum accuracy consistent with minimum network overhead. The algorithm measures the incidental offset and jitter to determine  the best poll interval. When `ntpd` starts, the interval is the default minimum 64 s. Under normal  conditions when the clock discipline has stabilized, the interval  increases in steps to the default maximum 1024 s. In addition, should a  server become unreachable after some time, the interval increases in  steps to the maximum in order to reduce network overhead. Additional  information about the algorithm is on the [Poll Program](https://www.ntp.org/documentation/4.2.8-series/poll/) page.
NTP 使用复杂的启发式算法来自动控制轮询间隔，以实现最大精度和最小的网络开销。该算法测量偶然偏移和抖动，以确定最佳轮询间隔。启动时 `ntpd` ，间隔为默认最小值 64 秒。在正常情况下，当时钟规则稳定时，间隔会逐步增加到默认最大值 1024 秒。此外，如果服务器在一段时间后无法访问，则间隔将以步长增加到最大，以减少网络开销。有关该算法的其他信息，请参阅“投票程序”页面。

The default poll interval range is suitable for most conditions, but can be changed using options on the [Server Commands and Options](https://www.ntp.org/documentation/4.2.8-series/confopt/) and [Miscellaneous Options](https://www.ntp.org/documentation/4.2.8-series/miscopt/) pages. However, when using maximum intervals much larger than the  default, the residual clock frequency error must be small enough for the discipline loop to capture and correct. The capture range is 500 PPM  with a 64-s interval decreasing by a factor of two for each interval  doubling. At a 36-hr interval, for example, the capture range is only  0.24 PPM.
默认轮询间隔范围适用于大多数情况，但可以使用“服务器命令和选项”和“其他选项”页面上的选项进行更改。但是，当使用比默认间隔大得多的最大间隔时，残余时钟频率误差必须足够小，以便规范环路捕获和校正。捕获范围为 500 PPM，每增加一个间隔，64 秒的间隔就会减少 2 倍。例如，在 36 小时的间隔内，捕获范围仅为 0.24 PPM。

In the NTPv4 specification and reference implementation, the poll interval is expressed in log2 units, properly called the *poll exponent.* It is constrained by the lower limit `minpoll` and upper limit `maxpoll` options of the [`server`](https://www.ntp.org/documentation/4.2.8-series/confopt/#server-command-options) command. The limits default to 6 (64 s) and 10 (1024 s), respectively, which are appropriate for the vast majority of cases.
在 NTPv4 规范和参考实现中，轮询间隔以对数 2 单位表示，正确地称为轮询指数。它受 `server` 命令的下限 `minpoll` 和上限 `maxpoll` 选项的约束。限制分别默认为 6（64 秒）和 10（1024 秒），适用于绝大多数情况。

As a rule of thumb, the expected errors increase by a factor of two as the poll interval increases by a factor of four. The poll interval  algorithm slowly increases the poll interval when jitter dominates the  error budget, but quickly reduces the interval when wander dominates it. More information about this algorithm is on the [How NTP Works](https://www.ntp.org/documentation/4.2.8-series/warp/) page.
根据经验，当轮询间隔增加四倍时，预期误差会增加两倍。当抖动主导误差预算时，轮询间隔算法会缓慢增加轮询间隔，但当漂移占主导地位时，轮询间隔会迅速减少。有关此算法的详细信息，请参阅 NTP 的工作原理页。

There is normally no need to change the poll limits, as the poll interval is  managed automatically as a function of prevailing jitter and wander. The most common exceptions are the following.
通常不需要更改轮询限制，因为轮询间隔是作为当前抖动和漂移的函数自动管理的。最常见的例外情况如下。

- With fast, lightly loaded LANs and modern processors, the nominal Allan  intercept is about 500 s. In these cases the expected errors can be  further reduced using a poll exponent of 4 (16 s). In the case of the  pulse-per-second (PPS) driver, this is the recommended value.
  使用快速、轻负载的 LAN 和现代处理器，标称 Allan 截距约为 500 秒。在这些情况下，可以使用轮询指数 4（16 秒）进一步减少预期误差。对于每秒脉冲 （PPS） 驱动程序，这是建议的值。
- With symmetric modes the most stable behavior results when both peers are  configured in symmetric active mode with matching poll intervals of 6  (64 s).
  在对称模式下，当两个对等体都配置为对称活动模式时，匹配轮询间隔为 6（64 秒），则会产生最稳定的行为。
- The poll interval should not be modified for reference clocks, with the  single exception the ACTS telephone modem driver. In this case the  recommended minimum and maximum intervals are 12 (1.1 hr) and 17 (36  hr), respectively.
  不应修改参考时钟的轮询间隔，但 ACTS 电话调制解调器驱动程序除外。在这种情况下，建议的最小和最大间隔分别为 12 （1.1 小时） 和 17 （36 小时）。

------

#### Burst Options 突发选项

Occasionally it is necessary to send packets temporarily at intervals less than the poll interval. For instance, with the `burst` and `iburst` options of the [`server`](https://www.ntp.org/documentation/4.2.8-series/confopt/#server-command-options) command, the poll program sends a burst of several packets at 2-s  intervals. In either case the poll program avoids sending needless  packets if the server is not responding. The client begins a burst with a single packet. When the first packet is received from the server, the  client continues with the remaining packets in the burst. If the first  packet is not received within 64 s, it will be sent again for two  additional retries before beginning backoff. The result is to minimize  network load if the server is not responding. Additional details are on  the [Poll Program](https://www.ntp.org/documentation/4.2.8-series/poll/) page.
有时需要以小于轮询间隔的时间间隔临时发送数据包。例如，使用 `server` 命令的 `burst` and `iburst` 选项，轮询程序以 2  秒的间隔发送多个数据包的突发。无论哪种情况，如果服务器没有响应，轮询程序都会避免发送不必要的数据包。客户端以单个数据包开始突发。当从服务器接收到第一个数据包时，客户端将继续处理突发中的其余数据包。如果在 64  秒内未收到第一个数据包，则在开始回退之前，将再次发送该数据包以进行两次额外的重试。结果是，如果服务器没有响应，则可以最大程度地减少网络负载。其他详细信息请见投票计划页面。

There are two burst options where a single poll event triggers a burst. They should be used only with the `server` and `pool` commands, but not with reference clock drivers nor symmetric mode  peers. In both modes, received server packets update the clock filter,  which selects the best (most accurate) time values. When the last packet in the burst is sent, the next received packet updates the system  variables and adjusts the system clock as if only a single packet  exchange had occurred.
有两个突发选项，其中单个轮询事件触发突发。它们只能与 `server` and `pool`  命令一起使用，而不能与参考时钟驱动器或对称模式对等体一起使用。在这两种模式下，接收到的服务器数据包都会更新时钟过滤器，该过滤器会选择最佳（最准确）的时间值。当发送突发中的最后一个数据包时，下一个接收的数据包会更新系统变量并调整系统时钟，就好像只进行了一次数据包交换一样。

The `iburst` option is useful where the system clock must be set quickly or when the network attachment requires an initial calling or training sequence, as in PPP or ISDN services. In general, this option is recommended for `server` and `pool` commands. A burst is sent only when the server is unreachable; in  particular, when first starting up. Ordinarily, the clock is set within a few seconds after the first received packet. See the [Clock State Machine](https://www.ntp.org/documentation/4.2.8-series/clock/) page for further details about the startup behavior.
当必须快速设置系统时钟或网络连接需要初始呼叫或训练序列时，如在 PPP 或 ISDN 服务中，该 `iburst` 选项非常有用。通常，建议对 `server` 和 `pool` 命令使用此选项。仅当服务器无法访问时，才会发送突发;特别是在第一次启动时。通常，时钟在收到第一个数据包后的几秒钟内设置。有关启动行为的更多详细信息，请参阅时钟状态机页面。

The `burst` option is useful in cases of severe network jitter or when the network  attachment requires an initial calling or training sequence. This option is recommended when the minimum poll exponent is larger than 10 (1024  s). A burst is sent only when the server is reachable. The number of  packets in the burst is determined by the poll interval so that the  average interval between packets (headway) is no less than the minimum  poll interval for the association.
该 `burst` 选项在网络抖动严重或网络连接需要初始呼叫或训练序列时非常有用。当最小轮询指数大于 10 （1024 秒） 时，建议使用此选项。仅当服务器可访问时，才会发送突发。突发中的数据包数由轮询间隔确定，因此数据包之间的平均间隔（头距）不小于关联的最小轮询间隔。