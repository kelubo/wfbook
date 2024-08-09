# iscsi.conf(5) - Linux man page iscsi.conf（5） - Linux 手册页

## Name 名字

iscsi.conf - iSCSI Driver Configuration 
iscsi.conf - iSCSI 驱动程序配置

## Synopsis 概要

**/etc/iscsi.conf**

## Description 描述

<iframe id="aswift_0" name="aswift_0" style="left: 0px; top: 0px; border: 0px; width: 336px; height: 280px;" sandbox="allow-forms allow-popups allow-popups-to-escape-sandbox allow-same-origin allow-scripts allow-top-navigation-by-user-activation" width="336" height="280" frameborder="0" marginwidth="0" marginheight="0" vspace="0" hspace="0" allowtransparency="true" scrolling="no" src="https://googleads.g.doubleclick.net/pagead/ads?client=ca-pub-5823754184406795&amp;output=html&amp;h=280&amp;slotname=7130739364&amp;adk=1862536188&amp;adf=3894714692&amp;pi=t.ma~as.7130739364&amp;w=336&amp;abgtt=3&amp;lmt=1721184794&amp;format=336x280&amp;url=https%3A%2F%2Flinux.die.net%2Fman%2F5%2Fiscsi.conf&amp;wgl=1&amp;dt=1721184793378&amp;bpp=1&amp;bdt=2430&amp;idt=1387&amp;shv=r20240715&amp;mjsv=m202407110101&amp;ptt=9&amp;saldr=aa&amp;abxe=1&amp;cookie_enabled=1&amp;eoidce=1&amp;correlator=567021950639&amp;frm=20&amp;pv=2&amp;ga_vid=1072547417.1721184793&amp;ga_sid=1721184793&amp;ga_hid=1381227637&amp;ga_fc=1&amp;ga_wpids=UA-50820-6&amp;u_tz=480&amp;u_his=2&amp;u_h=1080&amp;u_w=1920&amp;u_ah=1032&amp;u_aw=1920&amp;u_cd=24&amp;u_sd=1&amp;adx=546&amp;ady=264&amp;biw=1920&amp;bih=947&amp;scr_x=0&amp;scr_y=0&amp;eid=44759875%2C44759926%2C44759837%2C95331688%2C95334524%2C95334828%2C95337027%2C95337868%2C31085242%2C95336267%2C95337367&amp;oid=2&amp;pvsid=2409848710687045&amp;tmod=460061922&amp;uas=0&amp;nvt=1&amp;ref=https%3A%2F%2Flinux.die.net%2Fman%2F5%2Fiscsi.conf%3F__cf_chl_tk%3D1TAqU3AsZRbr75Fgxw2R7i5E3KZwCiTAPidP9RJM1Dg-1721184776-0.0.1.1-4521&amp;fc=640&amp;brdim=-1928%2C-8%2C-1928%2C-8%2C1920%2C0%2C1936%2C1048%2C1920%2C947&amp;vis=2&amp;rsz=%7C%7CleEr%7C&amp;abl=CS&amp;pfx=0&amp;fu=0&amp;bc=31&amp;bz=1.01&amp;ifi=1&amp;uci=a!1&amp;fsb=1&amp;dtd=1399" data-google-container-id="a!1" tabindex="0" title="Advertisement" aria-label="Advertisement" data-google-query-id="CJfzsIGJrYcDFU3HFgUdzc4Esg" data-load-complete="true"></iframe>

This manual page describes the format of /etc/iscsi.conf file. This file is a simple text file that 'iscsid' uses to locate iSCSI targets and configure various  operational parameters. Comments are marked by lines beginning with '#'. The conf file can have entries related to following categories: 
本手册页介绍了 /etc/iscsi.conf 文件的格式。此文件是一个简单的文本文件，“iscsid”使用它来定位 iSCSI 目标并配置各种操作参数。注释以“#”开头的行标记。conf 文件可以包含与以下类别相关的条目：

A) Target Discovery via 'SendTargets' mechanism.
A） 通过“SendTargets”机制发现目标。
 B) Target Discovery via SLP mechanism.
B） 通过 SLP 机制发现目标。
 C) Authentication settings.
C） 身份验证设置。
 D) Digest settings. D） 摘要设置。
 E) Connection timeouts. E） 连接超时。
 F) Session timeouts. F） 会话超时。
 G) Error handling timeouts.
G） 错误处理超时。
 H) iSCSI Operational Parameters.
h） iSCSI 操作参数。
 I) TCP settings. I） TCP 设置。
 J) Per Target settings
J） 按目标设置
 K) Per Subnet settings.
K） 每个子网设置。
 L) Enable/Disable Targets or portals.
L） 启用/禁用目标或门户。
 M) Keeping Discovery Session Alive 
m） 保持发现会话的活力

## Options of Category A: A类选项：

**DiscoveryAddress=<address>** IP address or hostname to use for target discovery. A TCP port number may be specified by appending a colon  followed by the port number. This entry must start in the first column,  and must not contain any whitespace. **TargetIpAddr=<address>** A synonym for DiscoveryAddress. 
DiscoveryAddress=<address> 用于目标发现的 IP 地址或主机名。可以通过在端口号后跟冒号后跟来指定 TCP  端口号。此条目必须从第一列开始，并且不得包含任何空格。TargetIpAddr=<address> DiscoveryAddress 的同义词。

## Options of Category B: B类选项：

**SLPMulticast=all|none|IP1,IP2,...** Specify the usage of SLP discovery mechanism for target discovery using Multicast. Valid options are : 
SLPMulticast=all|none|IP1，IP2,...指定使用多播发现目标的 SLP 发现机制的用法。有效选项包括：

- **all 都**

  Use all network interfaces on the host machine to multicast SLP queries.  使用主机上的所有网络接口对 SLP 查询进行多播。

- **none 没有**

  Do not use SLP multicast.  不要使用 SLP 组播。

- **list of IP address IP地址列表**

  specify a list of IP addresses on the host machine to be used to multicast SLP queries. **SLPUnicast=<address>** Specify the IP address to which SLP queries for discovering targets can be unicasted. **PollInterval=<time>** Specify the interval between successive SLP queries. An interval of  zero means the query should be sent only once. If no value is specified, a  default time of 300 seconds will be used. The time value can be  specified as either **300s** for seconds or **5m** for minutes or **1h** for hours. 指定主机上用于多播 SLP 查询的 IP 地址列表。SLPUnicast=<address> 指定可以单播用于发现目标的 SLP 查询的 IP  地址。PollInterval=<time> 指定连续 SLP  查询之间的间隔。零的间隔表示查询应仅发送一次。如果未指定任何值，则将使用 300 秒的默认时间。时间值可以指定为 300 秒，分钟为 5  米，小时为 1 小时。

## Options of Category C: C类选项：

**IncomingUsername=<user>** Specify the CHAP authentication user name that should be received from target during authentication of target by initiator. **IncomingPassword=<pass>** Specify the CHAP authentication password that should be received from target during authentication of target by initiator. **OutgoingUsername=<user>** Specify the CHAP authentication user name that should be sent by initiator during authentication of initiator by target. **OutgoingPassword=<pass>** Specify the CHAP authentication password that should be sent by initiator during authentication of initiator by target. **Username=<user>** Synonym for OutgoingUsername. **Password=<pass>** Synonym for OutgoingPassword. 
IncomingUsername=<user> 指定在发起方对目标进行身份验证期间应从目标接收的 CHAP 身份验证用户名。IncomingPassword=<pass>  指定启动器对目标进行身份验证期间应从目标接收的 CHAP 身份验证密码。OutgoingUsername=<user>  指定在目标对发起方进行身份验证期间应由发起方发送的 CHAP 身份验证用户名。OutgoingPassword=<pass>  指定在目标对发起方进行身份验证期间应由发起方发送的 CHAP 身份验证密码。username=<user>  OutgoingUsername 的同义词。password=<pass> OutgoingPassword 的同义词。

## Note: 注意：

IncomingPassword has to be different from OutgoingPassword. It is possible to have initiator authentication alone, both initiator and target authentication but not target authentication alone. 
IncomingPassword 必须与 OutgoingPassword 不同。可以单独使用启动器身份验证，包括启动器和目标身份验证，但不能单独使用目标身份验证。

The maximum length for the incoming or outgoing password or username is 256 characters. 
传入或传出密码或用户名的最大长度为 256 个字符。

## Options of Category D: D类选项：

**HeaderDigest=always|never|prefer-on|prefer-off**

Specify how to negotiate the use of CRC32C checks to detect the corruption of  iSCSI PDU header and data. The available options are: 
指定如何协商使用 CRC32C 检查来检测 iSCSI PDU 标头和数据的损坏。可用选项包括：

- **always 总是**

  require digests, and fail to login if the target requires no digests.  需要摘要，如果目标不需要摘要，则无法登录。

- **never 从不**

  require no digests, and fail to login if the target requires digests.  不需要摘要，如果目标需要摘要，则无法登录。

- **prefer-on 首选**

  prefer digests, but login with no digests if the target refuses to use digests.  首选摘要，但如果目标拒绝使用摘要，则不使用摘要登录。

- **prefer-off 首选关闭**

  prefer no digests, but login with digests if the target insists on using them. 不喜欢摘要，但如果目标坚持使用摘要，请使用摘要登录。

## Note: 注意：

If the HeaderDigest option is not specified in the conf file then a default value of 'prefer-off' is taken by the driver. 
如果未在 conf 文件中指定 HeaderDigest 选项，则驱动程序将采用默认值“prefer-off”。

## Options of Category E: E类选项：

**LoginTimeout=<secs>** Specify the time in seconds to wait for a login PDU to be sent or received before failing the login on a particular  connection. If this entry is not present in the conf file, a default  value of 15 secs is taken by driver. 
LoginTimeout=<secs> 指定在特定连接上登录失败之前等待发送或接收登录 PDU 的时间（以秒为单位）。如果 conf 文件中不存在此条目，则驱动程序将采用默认值 15 秒。

The below mentioned timeouts, IdleTimeout and ActiveTimeout determine when a ping has to be sent so as to determine the status of the connection.  'ping' will be sent only if there is no inbound traffic from target even after  the timeout. **IdleTimeout=<secs>** Specify the time in secs. This timeout will be used if there are no active tasks in the session. If this entry  is not present in the conf file, a default value of 60 seconds is taken  by the driver. **ActiveTimeout=<secs>** Specify the time in secs. This timeout will be used if there are active tasks in the session. If this entry is not present in the conf file, a default value of 5 seconds is taken by the driver. **PingTimeout=<secs>** Specify the time in seconds to wait for a ping response before declaring the session as dead and attempting a re-establishment.  If this entry is not present in the conf file, a default value of 5  seconds is taken by the driver. 
下面提到的超时、IdleTimeout 和 ActiveTimeout 确定何时必须发送  ping，以确定连接的状态。只有在超时后没有来自目标的入站流量时，才会发送“ping”。IdleTimeout=<secs>  指定时间（以秒为单位）。如果会话中没有活动任务，则将使用此超时。如果 conf 文件中不存在此条目，则驱动程序将采用默认值 60  秒。ActiveTimeout=<secs> 指定时间（以秒为单位）。如果会话中有活动任务，则将使用此超时。如果 conf  文件中不存在此条目，则驱动程序将采用默认值 5 秒。PingTimeout=<secs>  指定在宣布会话失效并尝试重新建立会话之前等待 ping 响应的时间（以秒为单位）。如果 conf 文件中不存在此条目，则驱动程序将采用默认值 5 秒。

## Options of Category F: F类选项：

The session timeout settings in iSCSI driver are tuned to maintain data  integrity under non ideal conditions. This value can be tuned based on the type of situation. Refer README for description of timeout settings and  recommended timeout settings under different situations. **ConnFailTimeout=<secs>** Specify the time in seconds to wait for a session re-establishment. If a session is not re-established in 'ConnFailTimeout' seconds then I/Os on the session will be failed immediately without honoring the timeout associated with the SCSI command. By default the timeout value is 0 which means no timeout. 
iSCSI  驱动程序中的会话超时设置经过调整，可在非理想条件下保持数据完整性。此值可以根据情况类型进行调整。有关不同情况下的超时设置和建议超时设置的说明，请参阅自述文件。ConnFailTimeout=<secs> 指定等待重新建立会话的时间（以秒为单位）。如果会话未在“ConnFailTimeout”秒内重新建立，则会话上的 I/O  将立即失败，而不遵循与 SCSI 命令关联的超时。默认情况下，超时值为 0，表示没有超时。

## Options of Category G: G类选项：

**AbortTimeout=<secs>** Specify the time in seconds to wait for an abort to complete before declaring the abort as failed. If an entry is not  specified in the conf file, then a default value of 10 seconds is taken  by driver. **ResetTimeout=<secs>** Specify the time in seconds to wait for a reset to complete before declaring the reset as failed. If an entry is not specified in the conf file, then a default value of 30 seconds is taken by driver. 
AbortTimeout=<secs> 指定在将中止声明为失败之前等待中止完成的时间（以秒为单位）。如果未在 conf 文件中指定条目，则驱动程序将采用默认值 10  秒。ResetTimeout=<secs> 指定在宣布重置失败之前等待重置完成的时间（以秒为单位）。如果未在 conf  文件中指定条目，则驱动程序将采用默认值 30 秒。

## Options of Category H: H类选项：

The default values of these settings have already been tuned for optimal performance in iSCSI driver. Hence these should not be normally modified. **InitialR2T=yes|no** Specify the initiator's preference for InitialR2T text key. Valid options are: 
这些设置的默认值已经过调整，以便在 iSCSI 驱动程序中获得最佳性能。因此，通常不应修改这些内容。InitialR2T=yes|no 指定启动器对 InitialR2T 文本键的首选项。有效选项包括：

- **yes 是的**

  initiator must wait for an R2T before transmitting data.  启动器在传输数据之前必须等待 R2T。

- **no 不**

  initiator has an implied Initial R2T for 'FirstBurstLength' at offset 0. If not  specified in conf file, a default value of 'no' is assumed. **ImmediateData=yes|no** Specify the initiator's preference for ImmediateData text key. Valid options are:  启动器在偏移量为 0 处具有“FirstBurstLength”的隐含初始 R2T。如果未在 conf 文件中指定，则假定默认值为“no”。ImmediateData=yes|no 指定发起方对 ImmediateData 文本键的首选项。有效选项包括：

- **yes 是的**

  initiator sends unsolicited data with the iSCSI command PDU. If not specified in conf file, a default value of 'yes' is assumed.  发起方使用 iSCSI 命令 PDU 发送未经请求的数据。如果未在 conf 文件中指定，则假定默认值为“yes”。

- **no 不**

  initiator does not send unsolicited data with the iSCSI command PDU **MaxRecvDataSegmentLength=<bytes>** Specify the maximum no of bytes, initiator can receive in the data segment of an iSCSI PDU. The value  specified must be in the range <512 to (2^24 -1)>. If not  specified in the conf file, a default value of 128 kb is assumed. **FirstBurstLength=<bytes>** Specify the number of bytes of unsolicited data, the initiator can  send. The value specified must be in the range <512 to (2^24 - 1)>. If not  specified in the conf file, a default value of 256 kb is assumed. **MaxBurstLength=<bytes>** Specify the maximum SCSI payload that the initiator can receive/send in a Data-In or a solicited Data-Out iSCSI sequence. The value specified must be in the range <512 to (2^24-1)>. If not specified in the conf file, a default value of (16 * 1024 * 1024) -  1024 is taken. 启动器不发送未经请求的数据 使用 iSCSI 命令 PDU MaxRecvDataSegmentLength=<bytes> 指定启动器可以在 iSCSI  PDU 的数据段中接收的最大字节数。指定的值必须在 <512 到 （2^24 -1）> 范围内。如果未在 conf  文件中指定，则假定默认值为 128 kb。FirstBurstLength=<bytes>  指定发起方可以发送的未经请求的数据的字节数。指定的值必须在 <512 到 （2^24 - 1）> 范围内。如果未在 conf  文件中指定，则假定默认值为 256 kb。MaxBurstLength=<bytes> 指定启动器可以在 Data-In 或请求的  Data-Out iSCSI 序列中接收/发送的最大 SCSI 有效负载。指定的值必须在 <512 到 （2^24-1）>  范围内。如果未在 conf 文件中指定，则采用默认值 （16 * 1024 * 1024） - 1024。

## Options of Category I: 第一类选项：

**TCPWindowSize=<number>** Specify the TCP Window size to be set for the TCP socket used for iSCSI connection. If not specified in the conf file, a default value of 256 kb is taken. 
TCPWindowSize=<number> 指定要为用于 iSCSI 连接的 TCP 套接字设置的 TCP 窗口大小。如果未在 conf 文件中指定，则采用默认值 256 kb。

## Note: 注意：

\- Configuration entries of category C to category I and category L,M can be global across all target connections.
\- 从类别 C 到类别 I 和类别 L，M 的配置条目可以在所有目标连接中全局显示。
 \- Entries of category D to H and category L can be specified for a particular target.
\- 可以为特定目标指定类别 D 至 H 和类别 L 的条目。
 \- Entries of category E,G,I can be specified per subnet.
\- 可以按子网指定类别 E、G、I 的条目。
 \- Entries of category C,E and M can be specified per DiscoveryAddress.
\- 可以按 DiscoveryAddress 指定类别 C、E 和 M 的条目。
 \- Entries of category C can be specifed per SLP entry(SLPMulticast or SLPUnicast).
\- 可以按 SLP 条目（SLPMulticast 或 SLPUnicast）指定 C 类条目。
 \- The parameters are global if they appear before any DiscoveryAddress  or TargetName or Subnet or SLP entries. The global entries need to start at column 1.
\- 如果参数出现在任何 DiscoveryAddress 或 TargetName 或 Subnet 或 SLP 条目之前，则这些参数是全局参数。全局条目需要从第 1 列开始。
 \- Entries of category C under DiscoveryAddress are applicable to all targets discovered on this address.
\- DiscoveryAddress 下的 C 类条目适用于在此地址上发现的所有目标。
 \- Entries of category E and M under DiscoveryAddress are applicable only to the DiscoverySession.
\- DiscoveryAddress 下的类别 E 和 M 条目仅适用于 DiscoverySession。
 \- Entries that appear below a 'TargetName' entry apply for that particular target.
\- 出现在“TargetName”条目下方的条目适用于该特定目标。
 \- If they appear below a 'Subnet' entry then they apply for sessions using that portals that fall into the subnet.
\- 如果它们出现在“子网”条目下方，则它们会使用属于子网的门户申请会话。
 \- Entries of category C under SLP entries are applicable for targets discovered through SLP on the interfaces mentioned.
\- SLP 条目下的 C 类条目适用于通过 SLP 在上述接口上发现的目标。
 \- Settings which are specific to a 'DiscoveryAddress' or 'TargetName' or 'Subnet' or 'SLP' entry should NOT start at column 1 i.e., they have to be indented by atlease one whitespace character.
\- 特定于“DiscoveryAddress”或“TargetName”或“Subnet”或“SLP”条目的设置不应从第 1 列开始，即它们必须缩进一个空格字符。

The formats for TargetName and subnet entries are given below. 
下面给出了 TargetName 和子网条目的格式。

## Options of Category J: J类选项：

**TargetName=<name>** <name> is iSCSI Target name in iqn or eui format. Target specific settings should be entered below the respective  TargetName entry. These target-specific settings will be applicable for  all iSCSI sessions to the target. 
TargetName=<name> <name> 是 iqn 或 eui 格式的 iSCSI 目标名称。目标特定设置应在相应的 TargetName 条目下方输入。这些特定于目标的设置将适用于与目标的所有 iSCSI 会话。

## Options of Category K: K类选项：

**Subnet=<subnet address>** Subnet settings apply to sessions to a network portal in one of the specified subnets, or whose address matches one of the specified addresses. Subnet takes the "address" and  "netmask" values in the format specified below. Subnet=10.4.100.0/24 **Address=<a.b.c.d>** Address is a shorthand to Subnet values with a netmask of 32. Example: Address=10.4.100.0 
Subnet=<subnet address>  子网设置适用于指向指定子网之一中的网络门户的会话，或者其地址与指定地址之一匹配的会话。子网采用下面指定格式的“address”和“netmask”值。Subnet=10.4.100.0/24 Address=<a.b.c.d> Address 是网络掩码为 32 的子网值的简写。示例：address=10.4.100.0

## Options of Category L: L类选项：

**Enabled=yes|no** The above parameter can be used to globally enable or disable targets or to selectively enable targets or portals under the Targetname or Address/Subnet option. Valid options are: 
Enabled=yes|no 上述参数可用于全局启用或禁用目标，或者在 Targetname 或 Address/Subnet 选项下有选择地启用目标或门户。有效选项包括：

- **yes 是的**

  TargetNames or portals mentioned after this line will be enabled by default  默认情况下，将启用此行后面提到的 TargetNames 或门户

- **no 不**

  TargetNames portals mentioned after this  在此之后提到的 TargetNames 门户line will be disabled by default 默认情况下，该行将被禁用

## Options of Category M: M类选项：

**Continuous=yes|no** Specify whether discovery session should be kept alive or not after doing the discovery. Valid options are: 
Continuous=yes|no 指定在执行发现后是否应保持发现会话处于活动状态。有效选项包括：

- **yes 是的**

  iSCSI initiator waits for IdleTimeout(60 seconds, default) to get a NOP-IN  from target. If initiator gets a NOP-IN from target during IdleTimeout  then initiator replies with NOP-OUT. But if initiator does not get a NOP-IN  from target during Idletimeout then it sends NOP-OUT and expects NOP-IN  response from target within PingTimeout(5 seconds, default). If target does not  respond within PingTimeout then initiator assumes the connection has  been inadvertently broken, drops the current discovery session and attempts to establish a  new discovery session.  iSCSI 启动器等待 IdleTimeout（60 秒，默认值）从目标获取 NOP-IN。如果发起方在 IdleTimeout 期间从目标获得  NOP-IN，则发起方将回复 NOP-OUT。但是，如果启动器在 Idletimeout 期间没有从目标获得 NOP-IN，则它会发送  NOP-OUT 并期望在 PingTimeout（5 秒，默认值）内从目标获得 NOP-IN 响应。如果目标在 PingTimeout  中没有响应，则启动器假定连接已无意中断，删除当前发现会话并尝试建立新的发现会话。

- **no 不**

  iSCSI initiator closes the connection and will not attempt to establish a new one. **SendAsyncText=yes|no** Specify whether async event notification needs to be sent by the target. Valid options are:  iSCSI 启动器将关闭连接，并且不会尝试建立新连接。SendAsyncText=yes|no 指定目标是否需要发送异步事件通知。有效选项包括：

- **yes 是的**

  Target sends vendor specific async messages when target configuration changes. The events can be target becoming available or unavailable, portal  being added or removed.  当目标配置发生更改时，Target 会发送特定于供应商的异步消息。事件可以是目标变得可用或不可用，也可以是正在添加或删除门户。

- **no 不**

  Async events are not sent when this option is specified. If SendAsyncText  entry is not present in the conf file then a default value of 'yes' is  taken by the driver. 指定此选项时，不会发送异步事件。如果 conf 文件中不存在 SendAsyncText 条目，则驱动程序将采用默认值“yes”。

## Scope of Settings 设置范围

As mentioned above,configuration entries can be specified as either global values or per DiscoveryAddress or per target or per subnet or per SLP  entry. The following paragraph explains the scope of these settings and precedence  for conflicting entries. 
如上所述，配置条目可以指定为全局值、每个 DiscoveryAddress、每个目标、每个子网或每个 SLP 条目。以下段落介绍了这些设置的范围以及冲突条目的优先级。

If entries begin at column 1 of the conf file then they will be the  global. If entries need to be made specific to DiscoveryAddress or  target or subnet or SLP entry they have to appear after the corresponding 'DiscoveryAddress' or 'TargetName' or 'Subnet' entry and should NOT begin at first column  (i.e., they have to be indented). For simplicity we refer to them as local entries.  If there is a conflict of entries between global and local, then local  ones will be used. Consider the example below: 
如果条目从 conf 文件的第 1 列开始，则它们将是全局的。如果需要特定于 DiscoveryAddress 或目标、子网或 SLP  条目，则它们必须出现在相应的“DiscoveryAddress”或“TargetName”或“Subnet”条目之后，并且不应从第一列开始（即，它们必须缩进）。为简单起见，我们将它们称为本地条目。如果全局和本地之间的条目冲突，则将使用本地条目。请看下面的例子：

OutgoingUsername=alice 传出用户名=alice
 OutgoingPassword=wonderland1342
传出密码=wonderland1342
 LoginTimeout=20 登录超时 = 20
 DiscoveryAddress=192.168.250.230
发现地址 = 192.168.250.230
   OutgoingUsername=bob 传出用户名=bob

   OutgoingPassword=nyet1234
传出密码 = nyet1234

LoginTimeout=15 登录超时 = 15
 DiscoveryAddress=192.168.250.240 
发现地址 = 192.168.250.240

In the above example, OutgoingUsername will be "bob" and OutgoingPassword  will be "nyet1234" for all targets discovered under 192.168.250.230.  (Local values override global ones). LoginTimeout used will be 20. 
在上面的示例中，对于在 192.168.250.230 下发现的所有目标，OutgoingUsername 将为“bob”，OutgoingPassword 将为“nyet1234”。（局部值覆盖全局值）。使用的 LoginTimeout 将为 20。

In case of DiscoveryAddress 192.168.250.240, "alice" and "wonderland1342"  are the username and passwords used for authentication, however the  logintimeout used is 15. 'LoginTimeout=20' had scope till another global  'LoginTimeout=' appeared. 
对于 DiscoveryAddress  192.168.250.240，“alice”和“wonderland1342”是用于身份验证的用户名和密码，但使用的登录时间是  15。“LoginTimeout=20”具有范围，直到出现另一个全局“LoginTimeout=”。

If there is a conflict between 'local' entries under 'TargetName' and  entries under 'Subnet' then local entries under 'Subnet' entry will be  considered. 
如果“TargetName”下的“本地”条目与“子网”下的条目之间存在冲突，则将考虑“子网”条目下的本地条目。

Consider the example below:
请看下面的例子：
 LoginTimeout=25 登录超时 = 25
 Subnet=192.168.250.0/24 子网=192.168.250.0/24
   LoginTimeout=20 登录超时 = 20

TargetName= iqn.1987-05.com.cisco:00.01c82dc85b33.fc8disk1
目标名称= iqn.1987-05.com.cisco：00.01c82dc85b33.fc8disk1
   LoginTimeout=30 登录超时 = 30

In the above case lets assume that Target '  iqn.1987-05.com.cisco:00.01c82dc85b33.fc8disk1' is reachable through  192.168.250.230. The 'LoginTimeout' to be used in this case will be 20 seconds. 
在上述情况下，假设目标“iqn.1987-05.com.cisco：00.01c82dc85b33.fc8disk1”可通过192.168.250.230访问。在这种情况下使用的“LoginTimeout”将为 20 秒。

## Files 文件

- /etc/iscsi.conf

   

## See Also 另见

***[iscsid](https://linux.die.net/man/8/iscsid)**(8) iSCID（8）*

## Referenced By 引用者

**[iscsi-ls](https://linux.die.net/man/1/iscsi-ls)**(1) ISCSI-LS（1）