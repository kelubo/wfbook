# Automatic Server Discovery Schemes 自动服务器发现方案

Last update: November 23, 2022 17:49 UTC ([1b4d24aef](https://git.nwtime.org/websites/ntpwww/commit/1b4d24aef65c630791ad0f89d6c09ec258781c2c))
最后更新： 2022年11月23日 17：49 UTC （ 1b4d24aef）



  ![gif](https://www.ntp.org/documentation/pic/alice51.gif)

[from *Alice’s Adventures in Wonderland*, Lewis Carroll
摘自《爱丽丝梦游仙境》，刘易斯·卡罗尔](https://www.ntp.org/reflib/pictures/)



Make sure who your friends are.
确定你的朋友是谁。

------

#### Table of Contents 目录

- [Introduction 介绍](https://www.ntp.org/documentation/4.2.8-series/discover/#introduction)
- [Association Management 协会管理](https://www.ntp.org/documentation/4.2.8-series/discover/#association-management)
- [Broadcast/Multicast Scheme
  广播/组播方案](https://www.ntp.org/documentation/4.2.8-series/discover/#broadcastmulticast-scheme)
- [Manycast Scheme 组播方案](https://www.ntp.org/documentation/4.2.8-series/discover/#manycast-scheme)
- [Server Pool Scheme 服务器池方案](https://www.ntp.org/documentation/4.2.8-series/discover/#server-pool-scheme)

------

#### Introduction 介绍

This page describes the automatic server discovery schemes provided in  NTPv4. There are three automatic server discovery schemes:  broadcast/multicast, many cast, and server pool, which are described on  this page. The broadcast/multicast and many cast schemes utilize the  ubiquitous broadcast or one-to-many paradigm native to IPv4 and IPv6.  The server pool scheme uses DNS to resolve addresses of multiple  volunteer servers scattered throughout the world.
本页介绍 NTPv4 中提供的自动服务器发现方案。有三种自动服务器发现方案：广播/多播、多播和服务器池，本页对此进行了介绍。广播/组播和许多投射方案利用 IPv4 和 IPv6 原生的无处不在的广播或一对多范式。服务器池方案使用 DNS 来解析分散在世界各地的多个志愿者服务器的地址。

All three schemes work in much the same way and might be described as *grab-n'-prune.* Through one means or another they grab a number of associations either  directly or indirectly from the configuration file, order them from best to worst according to the NTP mitigation algorithms, and prune the  surplus associations.
这三种方案的工作方式大致相同，可以描述为 grab-n'-prune。通过这样或那样的方式，他们直接或间接地从配置文件中获取许多关联，根据 NTP 缓解算法将它们从最好到最差排序，并修剪剩余的关联。

------

#### Association Management 协会管理

All schemes use an iterated process to discover new preemptable client  associations as long as the total number of client associations is less  than the `maxclock` option of the `tos` command. The `maxclock` default is 10, but it should be changed in typical configuration to some lower number, usually two greater than the `minclock` option of the same command.
所有方案都使用迭代过程来发现新的可抢占客户端关联，只要客户端关联的总数小于 `tos` 命令 `maxclock` 的选项即可。默认值为 `maxclock` 10，但在典型配置中应将其更改为更低的数字，通常比同一命令 `minclock` 的选项大 2。

All schemes use a stratum filter to select just those servers with stratum  considered useful. This can avoid large numbers of clients ganging up on a small number of low-stratum servers and avoid servers below or above  specified stratum levels. By default, servers of all strata are  acceptable; however, the `tos` command can be used to restrict the acceptable range from the `floor` option, inclusive, to the `ceiling` option, exclusive. Potential servers operating at the same stratum as the client will be avoided, unless the `cohort` option is present. Additional filters can be supplied using the methods described on the [Authentication Support](https://www.ntp.org/documentation/4.2.8-series/authentic/) page.
所有方案都使用层过滤器来选择那些具有层被认为有用的服务器。这样可以避免大量客户端在少量低层服务器上联合使用，并避免低于或高于指定层级别的服务器。默认情况下，所有层的服务器都是可以接受的;但是，该 `tos` 命令可用于将可接受的范围从“ `floor` 选项”（包含）限制为 `ceiling` “选项（独占）”。除非存在该 `cohort` 选项，否则将避免在与客户端在同一层运行的潜在服务器。可以使用“身份验证支持”页上所述的方法提供其他筛选器。

The pruning process uses a set of unreach counters, one for each  association created by the configuration or discovery processes. At each poll interval, the counter is increased by one. If an acceptable packet arrives for a persistent (configured) or ephemeral  (broadcast/multicast) association, the counter is set to zero. If an  acceptable packet arrives for a preemptable (manycast, pool) association and survives the selection and clustering algorithms, the counter is  set to zero. If the counter reaches an arbitrary threshold of 10, the  association becomes a candidate for pruning.
修剪过程使用一组 unreach 计数器，每个计数器对应由配置或发现过程创建的每个关联。在每个轮询间隔内，计数器增加  1。如果为持久性（已配置）或临时性（广播/组播）关联到达可接受的数据包，则计数器设置为零。如果可接受的数据包到达可抢占（manycast、池）关联并在选择和聚类算法中幸存下来，则计数器设置为零。如果计数器达到任意阈值 10，则该关联将成为修剪的候选对象。

The pruning algorithm is very simple. If an ephemeral or preemptable  association becomes a candidate for pruning, it is immediately  demobilized. If a persistent association becomes a candidate for  pruning, it is not demobilized, but its poll interval is set at the  maximum. The pruning algorithm design avoids needless discovery/prune  cycles for associations that wander in and out of the survivor list, but otherwise have similar characteristics.
修剪算法非常简单。如果一个短暂的或可抢占的关联成为修剪的候选者，它就会立即复员。如果持久关联成为修剪的候选关联，则不会将其移除，但其轮询间隔设置为最大值。修剪算法设计避免了对徘徊在幸存者列表中和徘徊但具有相似特征的关联进行不必要的发现/修剪周期。

Following is a summary of each scheme. Note that reference to option applies to the commands described on the [Configuration Options](https://www.ntp.org/documentation/4.2.8-series/confopt/) page. See that page for applicability and defaults.
以下是每个方案的摘要。请注意，对选项的引用适用于“配置选项”页上描述的命令。请参阅该页面，了解适用性和默认值。

------

#### Broadcast/Multicast Scheme 广播/组播方案

A broadcast server generates messages continuously at intervals by  default 64 s and time-to-live by default 127. These defaults can be  overridden by the `minpoll` and `ttl` options, respectively. Not all kernels support the `ttl` option. A broadcast client responds to the first message received by  waiting a randomized interval to avoid implosion at the server. It then  polls the server in client/server mode using the `iburst` option in order to quickly authenticate the server, calibrate the  propagation delay and set the client clock. This normally results in a  volley of six client/server exchanges at 2-s intervals during which both the synchronization and cryptographic protocols run concurrently.
广播服务器默认以 64 秒的间隔连续生成消息，默认以 127 秒的间隔生成消息。这些默认值可以分别被 `minpoll` 和 `ttl` 选项覆盖。并非所有内核都支持该 `ttl` 选项。广播客户端通过等待随机间隔来响应收到的第一条消息，以避免服务器发生内爆。然后，它使用该 `iburst` 选项在客户端/服务器模式下轮询服务器，以便快速验证服务器、校准传播延迟并设置客户端时钟。这通常会导致以 2 秒的间隔进行六次客户端/服务器交换，在此期间同步协议和加密协议同时运行。

Following the volley, the server continues in listen-only mode and sends no  further messages. If for some reason the broadcast server does not  respond to these messages, the client will cease transmission and  continue in listen-only mode with a default propagation delay. The  volley can be avoided by using the `broadcastdelay` command with nonzero argument.
在凌空抽射之后，服务器继续处于仅侦听模式，并且不再发送任何消息。如果由于某种原因广播服务器没有响应这些消息，客户端将停止传输并继续以仅侦听模式进行，并具有默认传播延迟。通过使用带有非零参数的命令 `broadcastdelay` ，可以避免凌空抽射。

A server is configured in broadcast mode using the `broadcast` command and specifying the broadcast address of a local interface. If  two or more local interfaces are installed with different broadcast  addresses, a `broadcast` command is needed for each address. This provides a way to limit  exposure in a firewall, for example. A broadcast client is configured  using the `broadcastclient` command.
使用 `broadcast` 命令在广播模式下配置服务器并指定本地接口的广播地址。如果安装了两个或多个具有不同广播地址的本地接口，则每个地址都需要一个 `broadcast` 命令。例如，这提供了一种限制防火墙暴露的方法。使用以下 `broadcastclient` 命令配置广播客户端。

NTP multicast mode can be used to extend the scope using IPv4 multicast or  IPv6 broadcast with defined span. The IANA has assigned IPv4 multicast  address 224.0.1.1 and IPv6 address FF05::101 (site local) to NTP, but  these addresses should be used only where the multicast span can be  reliably constrained to protect neighbor networks. In general,  administratively scoped IPv4 group addresses should be used, as  described in [RFC 2365](https://www.rfc-editor.org/rfc/rfc2365.html), or GLOP group addresses, as described in [RFC 2770](https://www.rfc-editor.org/rfc/rfc2770.html).
NTP 组播模式可用于使用 IPv4 组播或具有定义跨度的 IPv6 广播来扩展范围。IANA 已将 IPv4 组播地址 224.0.1.1 和  IPv6 地址 FF05：：101（站点本地）分配给 NTP，但这些地址只能在组播跨度可以可靠地限制以保护邻居网络的情况下使用。通常，应使用  RFC 2365 中所述的管理范围的 IPv4 组地址，或 RFC 2770 中所述的 GLOP 组地址。

A multicast server is configured using the `broadcast` command, but specifying a multicast address instead of a broadcast address. A multicast client is configured using the `multicastclient` command specifying a list of one or more multicast addresses. Note that there is a subtle distinction between the IPv4 and IPv6 address  families. The IPv4 broadcast or mulitcast mode is determined by the IPv4 class. For IPv6 the same distinction can be made using the link-local  prefix FF02 for each interface and site-local prefix FF05 for all  interfaces.
使用该 `broadcast` 命令配置组播服务器，但指定组播地址而不是广播地址。使用指定一个或多个组播地址列表 `multicastclient` 的命令配置组播客户端。请注意，IPv4 和 IPv6 地址系列之间存在细微的区别。IPv4 广播或多播模式由 IPv4 类确定。对于 IPv6，可以使用链路本地前缀 FF02 对每个接口和站点本地前缀 FF05 进行相同的区分。

It is possible and frequently useful to configure a host as both broadcast client and broadcast server. A number of hosts configured this way and  sharing a common broadcast address will automatically organize  themselves in an optimum configuration based on stratum and  synchronization distance.
将主机配置为广播客户端和广播服务器是可能的，而且经常很有用。以这种方式配置并共享公共广播地址的许多主机将根据层和同步距离自动组织成最佳配置。

Since an intruder can impersonate a broadcast server and inject false time  values, broadcast mode should always be cryptographically authenticated. By default, a broadcast association will not be mobilized unless  cryptographically authenticated. If necessary, the `auth` option of the `disable` command will disable this feature. The feature can be selectively enabled using the `notrust` option of the `restrict` command.
由于入侵者可以模拟广播服务器并注入虚假的时间值，因此广播模式应始终进行加密身份验证。默认情况下，除非经过加密身份验证，否则不会调动广播关联。如有必要， `disable` 该命令 `auth` 的选项将禁用此功能。可以使用 `restrict` 命令 `notrust` 的选项有选择地启用该功能。

With symmetric key cryptography each broadcast server can use the same or  different keys. In one scenario on a broadcast LAN, a set of broadcast  clients and servers share the same key along with another set that share a different key. Only the clients with matching key will respond to a  server broadcast. Further information is on the [Authentication Support](https://www.ntp.org/documentation/4.2.8-series/authentic/) page.
通过对称密钥加密，每个广播服务器都可以使用相同或不同的密钥。在广播 LAN 上的一个场景中，一组广播客户端和服务器共享相同的密钥，以及另一组共享不同密钥的广播客户端和服务器。只有具有匹配密钥的客户端才会响应服务器广播。有关详细信息，请参阅身份验证支持页面。

Public key cryptography can be used with some restrictions. If multiple  servers belonging to different secure groups share the same broadcast  LAN, the clients on that LAN must have the client keys for all of them.  This scenario is illustrated in the example on the [Autokey Public Key Authentication](https://www.ntp.org/documentation/4.2.8-series/autokey/) page.
公钥加密的使用有一些限制。如果属于不同安全组的多台服务器共享同一广播 LAN，则该 LAN 上的客户端必须具有所有客户端的客户端密钥。“自动密钥公钥身份验证”页上的示例演示了此方案。

------

#### Manycast Scheme 组播方案

Manycast is an automatic server discovery and configuration paradigm new to  NTPv4. It is intended as a means for a client to troll the nearby  network neighborhood to find cooperating servers, validate them using  cryptographic means and evaluate their time values with respect to other servers that might be lurking in the vicinity. It uses the grab-n'-drop paradigm with the additional feature that active means are used to grab additional servers should the number of associations fall below the `maxclock` option of the `tos` command.
Manycast 是 NTPv4  新增的自动服务器发现和配置范例。它旨在作为客户端拖曳附近网络邻居以查找合作服务器的一种手段，使用加密手段验证它们，并评估它们相对于可能潜伏在附近的其他服务器的时间值。它使用 grab-n'-drop 范式，并具有附加功能，即如果关联数量低于 `tos` 命令 `maxclock` 选项，则使用活动手段来获取其他服务器。

The manycast paradigm is not the anycast paradigm described in [RFC 1546](https://www.rfc-editor.org/rfc/rfc1546.html), which is designed to find a single server from a clique of servers  providing the same service. The manycast paradigm is designed to find a  plurality of redundant servers satisfying defined optimality criteria.
manycast 范式不是 RFC 1546 中描述的任播范式，后者旨在从提供相同服务的服务器组中查找单个服务器。manycast 范式旨在查找满足定义的最优性标准的多个冗余服务器。

A manycast client is configured using the `manycastclient` configuration command, which is similar to the `server` configuration command. It sends ordinary client mode messages, but with a broadcast address rather than a unicast address and sends only if  less than `maxclock` associations remain and then only at the minimum feasible rate and  minimum feasible time-to-live (TTL) hops. The polling strategy is  designed to reduce as much as possible the volume of broadcast messages  and the effects of implosion due to near-simultaneous arrival of  manycast server messages. There can be as many manycast client  associations as different addresses, each one serving as a template for  future unicast client/server associations.
使用 `manycastclient` 配置命令配置多播客户端，该命令类似于 `server` 配置命令。它发送普通的客户端模式消息，但使用广播地址而不是单播地址，并且仅在剩余关联少 `maxclock` 于关联时发送，然后仅以最小可行速率和最小可行生存时间 （TTL）  跃点发送。轮询策略旨在尽可能减少广播消息的数量，以及由于几乎同时到达的多播服务器消息而导致的内爆影响。可以有与不同地址一样多的多播客户端关联，每个多播客户端关联都可作为将来单播客户端/服务器关联的模板。

A manycast server is configured using the `manycastserver` command, which listens on the specified broadcast address for manycast  client messages. If a manycast server is in scope of the current TTL and is itself synchronized to a valid source and operating at a stratum  level equal to or lower than the manycast client, it replies with an  ordinary unicast server message.
使用以下 `manycastserver` 命令配置多播服务器，该命令侦听指定的广播地址以侦听多播客户端消息。如果组播服务器在当前 TTL 的范围内，并且其本身与有效源同步，并且在等于或低于组播客户端的层级别运行，则它将使用普通的单播服务器消息进行回复。

The manycast client receiving this message mobilizes a preemptable client  association according to the matching manycast client template. This  requires the server to be cryptographically authenticated and the server stratum to be less than or equal to the client stratum.
接收此消息的 manycast 客户端根据匹配的 manycast 客户端模板调动可抢占的客户端关联。这要求对服务器进行加密身份验证，并且服务器层小于或等于客户端层。

It is possible and frequently useful to configure a host as both manycast  client and manycast server. A number of hosts configured this way and  sharing a common multicast group address will automatically organize  themselves in an optimum configuration based on stratum and  synchronization distance.
将主机配置为manycast客户端和manycast服务器是可能的，并且经常很有用。以这种方式配置并共享公共组播组地址的多个主机将根据层和同步距离自动以最佳配置进行组织。

The use of cryptograpic authentication is always a good idea in any server  discovery scheme. Both symmetric key and public key cryptography can be  used in the same scenarios as described above for the broadast/multicast scheme.
在任何服务器发现方案中，使用加密身份验证始终是一个好主意。对称密钥和公钥加密都可以在上述 broadast/multicast 方案的相同方案中使用。

#### Server Pool Scheme 服务器池方案

The idea of targeting servers on a random basis to distribute and balance  the load is not a new one; however, the NTP pool scheme puts this on  steroids. At present, several thousand operators around the globe have  volunteered their servers for public access. In general, NTP is a  lightweight service and servers used for other purposes don’t mind an  additional small load. The trick is to randomize over the population and minimize the load on any one server while retaining the advantages of  multiple servers using the NTP mitigation algorithms.
随机定位服务器以分配和平衡负载的想法并不新鲜;然而，NTP池计划将其置于类固醇上。目前，全球已有数千家运营商自愿将他们的服务器提供给公众访问。通常，NTP 是一种轻量级服务，用于其他目的的服务器不介意额外的小负载。诀窍是随机化人口并最大程度地减少任何一台服务器上的负载，同时保留使用 NTP  缓解算法的多台服务器的优势。

To support this service, custom DNS software is used by pool.ntp.org and  its subdomains to discover a random selection of participating servers  in response to a DNS query. The client receiving this list mobilizes  some or all of them, similar to the manycast discovery scheme, and  prunes the excess. Unlike `manycastclient`, cryptographic authentication is not required. The pool scheme solicits a single server at a time, compared to `manycastclient` which solicits all servers within a multicast TTL range simultaneously. Otherwise, the pool server discovery scheme operates as manycast does.
为了支持此服务，pool.ntp.org 及其子域使用自定义 DNS 软件来发现随机选择的参与服务器以响应 DNS 查询。接收此列表的客户端会调动其中的部分或全部，类似于 manycast 发现方案，并修剪多余的部分。与 不同 `manycastclient` ，不需要加密身份验证。池方案一次请求单个服务器，而 `manycastclient` 池方案同时请求组播 TTL 范围内的所有服务器。否则，池服务器发现方案将像 manycast 一样运行。

The pool scheme is configured using one or more `pool` commands with DNS names indicating the pool from which to draw. The `pool` command can be used more than once; duplicate servers are detected and  discarded. In principle, it is possible to use a configuration file  containing a single line `pool pool.ntp.org`. The [NTP Pool Project](https://www.ntppool.org/en/use.html) offers instructions on using the pool with the `server` command, which is suboptimal but works with older versions of `ntpd` predating the `pool` command. With recent `ntpd`, consider replacing the multiple `server` commands in their example with a single `pool` command.
池方案使用一个或多个 `pool` 命令进行配置，这些命令的 DNS 名称指示要从中提取的池。该 `pool` 命令可以多次使用;检测到并丢弃重复的服务器。原则上，可以使用包含单行 `pool pool.ntp.org` 的配置文件。NTP 池项目提供了有关将池与 `server` 命令一起使用的说明，该命令不是最佳的，但适用于早于命令 `pool` 的旧 `ntpd` 版本。对于最近的 `ntpd` ，请考虑将其示例中的多个 `server` 命令替换为单个 `pool` 命令。