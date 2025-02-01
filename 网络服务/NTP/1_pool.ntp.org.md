### Introduction

### Active Servers

- ​                                 			                                 			[非洲](https://www.ntppool.org/zone/africa)                                                                94 		
- ​                                 			                                 			[亚洲](https://www.ntppool.org/zone/asia)                                                                335 		
- ​                                 			                                 			[欧洲](https://www.ntppool.org/zone/europe)                                                                2999 		
- ​                                 			                                 			[北美](https://www.ntppool.org/zone/north-america)                                                                1088 		
- ​                                 			                                 			[Oceania](https://www.ntppool.org/zone/oceania)                                                                182 		
- ​                                 			                                 			[南美](https://www.ntppool.org/zone/south-america)                                                                71 		
- ​                                 			                                 			[全球](https://www.ntppool.org/zone/@)                                                                4379 		
- ​                                 			                                 			[所有库服务器](https://www.ntppool.org/zone/)                                                                4746 		

As of 2024-06-13

pool.ntp.org 是一个以时间服务器的大虚拟集群为上百万的客户端提供可靠的 [易用的](https://www.ntppool.org/zh/use.html) 网络时间协议（NTP）服务的项目 

NTP池正在为世界各地成百上千万的系统提供服务。  它是绝大多数主流Linux发行版和许多网络设备的默认“时间服务器” (请参阅 [服务供应商的信息](https://www.ntppool.org/zh/vendors.html)).

由于用户的数量庞大，我们需要更多的服务器。如果您有一台具有静态IP地址并且一直处于联网状态的服务器，请考虑 [ 将其加入我们的系统](https://www.ntppool.org/zh/join.html).

这个项目由 [Ask Bjørn Hansen](http://www.askask.com/) 与 [邮件列表](https://www.ntppool.org/mailinglists.html)中的一大群贡献者开发与维持. 这个系统的源代码可 [在此获取](http://github.com/abh/ntppool).

“总线”服务器的主机和带宽由 [Develooper网](http://develooper.com/) 和 [NetActuate](https://www.netactuate.com/)提供.

### 我能如何使用 pool.ntp.org？

​	如果您只是想通过网络校准您计算机上的时钟，这个（ntpd 程序的）设置文件 (来自 [ntp.org 发行的](http://www.ntp.org), 在任何支持的操作系统上 -例如 **Linux, \*BSD, Windows 和甚至是更多的小众的操作系统**) 真是非常简单： 

```
driftfile /var/lib/ntp/ntp.drift

server 0.pool.ntp.org
server 1.pool.ntp.org
server 2.pool.ntp.org
server 3.pool.ntp.org
```

​	期中 0, 1, 2 and 3.pool.ntp.org 域名解析将会每小时更新，随机指向一系列服务器。   确认您的计算机时间设置得合理(和“真实”时间相差几分钟) - 您能使用 `ntpdate pool.ntp.org`或者您只需使用 `date` 命令来将它的时间设置成和您的手表一样。 接下来运行ntpd，并且等候一段时间（这可能花费大约半小时！），在这之后 `ntpq -pn` 应该会输出类似下面的结果： 

```
$ ntpq -pn
     remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================
+81.6.42.224     193.5.216.14     2 u   68 1024  377  158.995   51.220  50.287
*217.162.232.173 130.149.17.8     2 u  191 1024  176   79.245    3.589  27.454
-129.132.57.95   131.188.3.222    3 u  766 1024  377   22.302   -2.928   0.508
```

​	IP地址可能会不同，因为您被随机分配了时间服务器。 重要的是其中有一行以星号 (`*`)开头这就意味着您的计算机已经从网络上获取了时间  - 您再也不用为它担心了！ 

​	您可以从 `pool.ntp.org`进行查询 (或者 `0.pool.ntp.org`, `1.pool.ntp.org`，等等) 它们通常会返回您的国家（或是靠近您的国家的）的服务器的IP地址。 对大多数用户，这将能取得最佳的结果。 

您也能使用 [洲际空间](https://www.ntppool.org/zone/@) （比如 [欧洲](https://www.ntppool.org/zone/europe), [南美洲](https://www.ntppool.org/zone/north-america), [大洋洲](https://www.ntppool.org/zone/oceania) 或者 [亚洲](https://www.ntppool.org/zone/asia).pool.ntp.org）, 以及国家空间 (像是瑞士的  ch.pool.ntp.org) - 对所有的这些时区, 您也能使用 0, 1 or 2 前缀，正如 0.ch.pool.ntp.org 一样。 注意，您的国家可能不存在这方面空间或者空间里只包含一至二台时间服务器。 

​	如果您正在使用  **Windows 的最新版本**您可以使用系统内置的ntp客户端： 以管理员权限在命令行运行如下指令：

```
w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org"
```

​	这在Windows 2003及之后的版本中被支持。 如果您使用旧版的Windows，您可以尝试如下指令：

```
net time /setsntp:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org"
```

​	作为管理员，右键任务栏的时钟，选择“更改日期和时间设置...”，并且在“Internet时间”选项卡下输入服务器名也能达到同样的效果。 

​	Meinberg 制作了 [windows版的ntp精灵](http://www.meinberg.de/english/sw/ntp.htm)的接口。 

​	如果您的Windows 系统是一个域的一部分，您可能不能够独立地更新您的计算机时间。  	更多有关在Windows 系统上设置时间的信息，请参阅 [Windows 时间服务是如何工作的](http://technet.microsoft.com/en-us/library/cc773013(WS.10).aspx). 

### 附加注意事项

请考虑 NTP 池 是否适合您使用。 如果是商用、组织 或是 人的生命依赖正确的时间，或是时间错误将会有害的情形，您不应简单地依赖Internet。 	NTP 池 总体来说非常优质，但是它是一个由志愿者利用闲暇时间运行的服务 	请与您的设备和服务供应商交流，以了解有关您获得本地可靠时间服务的方法。 	您也可以参考我们的 [服务条款](https://www.ntppool.org/tos.html).         我们向您推荐来自         [Meinberg](http://www.meinbergglobal.com/english/products/ntp-time-server.htm)的时间服务器,        但您也能从        [End Run](http://www.endruntechnologies.com/NTP-Servers/gps-cdma-ntp.htm),        [Spectracom](http://spectracom.com/products-services/precision-timing#anchor-2172)        或是其他的站点找到时间服务器。        

如果您有静态IP地址，并且有理想的网络连接条件 （带宽并不怎么重要，但它应当稳定并且负载不太重），请考虑为服务器池贡献您的服务器。 它不会花费您多于几百Byte的流量，但是您将帮助这个项目存活下来！ 请 [阅读“加入页面”](https://www.ntppool.org/join.html) 来获取更多信息。 

如果您的Internet提供商拥有时间服务器，或者您知道您附近的优质时间服务器 ，您应该使用它们而不是这个清单中的服务器 - 您将可能使用更少的网络资源来获得更准确的时间。   如果您只知道一台您附近的时间服务器，您当然能使用它以及清单中的两台来对时。

很偶然的情况下，您可能会两次被分配到同一台时间服务器 - 只要重启ntp服务器，通常就会解决这个问题。如果您使用国家空间，请注意它在项目中可能只有一台时钟服务器 - 这样的话您最好还是使用洲际空间。  您能 [浏览空间](https://www.ntppool.org/zone) 来确定每个空间里我们到底有多少台服务器。

请友善对待。 许多服务器都是志愿者提供，并且几乎所有的时间服务器是真实的文件或邮件服务器， 它们只是恰巧顺带运行ntp。 所以请不要在您的设置中使用多于4台服务器，并且不要使用 `burst` 或者是 `minpoll`捣乱 - 那么做只会使志愿者的时间服务器增加负载。

请确认您计算机上的 *时区设置* 正确. ntpd 本身并不会对时区设置进行任何修改，它只是在内部使用UTC

如果您正使用pool.ntp.org来校准一个网络的时间，请将您网络中的一台计算机设置为时钟服务器，并且让其他计算机向它获取与校准时间。 （您将需要阅读一些内容 - 但是它们并不困难。并且 [comp.protocols.time.ntp 新闻组](news:comp.protocols.time.ntp)将一直与你同在。）

### 我如何才能加入 pool.ntp.org?

​	首先：感谢您对我们的兴趣。由于NTP池的使用增长迅猛， 为了使每个人都能轻松使用，我们唯一的方法就是增加服务器池中参与项目的服务器数量。 

​	您的电脑 **必须拥有一个静态IP地址** 与永久性的互联网连接。这将是非常重要的： 您的IP地址不发生改变或者只是极少改变（一年改变一次或更少）。 项目所需的带宽相对较少。每个客户端将只发送一些UDP包 并且请求频率少于20分钟一次。 

​	目前大多数服务器每秒获取大约5-15个NTP包， 一天中的几次峰值将会是每秒60-120个数据包。 这大致相当于10-15Kbit每秒，峰值时50-120Kbit每秒。 这个项目稳步获取更多的时间服务器，所以每一台服务器的负载不会极具增加。 在普通条件下，您可能需要最少384-512Kbit的（上行和下行）带宽。 

​	这是一些具有流量/负载图表的服务器：  

​	加入计划的服务器不能把 `pool.ntp.org` 用作上游服务器，而是需要手动设置一些[好的服务器](http://support.ntp.org/bin/view/Servers/StratumTwoTimeServers)(这些服务器 **可以** 从池中选取。 重要的是它们是被静态选择的，而不是在每台服务器重启后动态分配的，这将有助于提供可接受品质的服务)。 注意，对于你的服务器是1层或者是2层（stratum 1 or 2）的我们没有要求 - 正如这个项目是最大程度上分散负载，对于为什么 3层或者是4层的服务器（stratum 3 or 4）不应该加入，我想我们不必解释。 

​	我们有一个包含 [服务器加入NTP池的设置建议](https://www.ntppool.org/join/configuration.html)的页面. 

最后，我必须强调：加入NTP池的行为是一个 **长期承诺**。  我们很乐意当您的形势改变时将你退出池，但是由于ntp 客户端的操作机理， **访问流量完全消失可能要耗费数周、数月，甚至数年！**. 

​	如果以上条款您完全没问题，请登陆 [服务器管理](https://www.ntppool.org/manage) 页面，并且申请将您的服务器加入计划。 如果您对这个系统有任何问题，请给我发送电子邮件： [ask@develooper.com](mailto:ask@develooper.com). 

​	我想邀请您订阅 [网页博客](https://news.ntppool.org/atom.xml) 以及可能的话还有 [池邮件列表](https://lists.ntp.org/listinfo/pool). 

​	如果您能把您的服务器80端口的请求重定向到项目的官方页面`https://www.ntppool.org`，那将是极好的（不过可能也不太现实）。 如果您的服务器运行Apache，您可以按下列方法把您的服务器80端口的请求重定向到项目的官方页面： 

```
    <VirtualHost *:80>
       ServerName pool.ntp.org
       ServerAlias *.pool.ntp.org *.ntppool.org
       Redirect permanent / https://www.ntppool.org/
    </VirtualHost>
```

​	重申一下，如果您正在运行web服务器。这个项目的官方地址是以“www”开头的 - 但是有时人们偷懒只打了  `pool.ntp.org` 随后会因为获得一个随机页面而感到惊讶。 

​	一旦被加入池中，服务器将每隔一段时间被监控可用性和精确性。 您能在 [web前端](https://www.ntppool.org/zh/scores) 或是 [服务器管理](https://www.ntppool.org/manage)页面上查看您服务器的表现。 

### 服务器加入NTP池的设置建议

[support.ntp.org](http://support.ntp.org/)上的[支持页面](http://support.ntp.org/bin/view/Support/WebHome) 有着许多有用的信息。

如果您只是想要 *使用* NTP池, 请参阅 [池的用法](https://www.ntppool.org/use.html) 页面。

[comp.protocols.time.ntp](http://groups.google.com/group/comp.protocols.time.ntp) 新闻组是您与ntpd 软件一起获得帮助的最佳途径。

如果您将要把您的服务器加入NTP池，下方是一些特别重要的注意事项：

#### 管理层查询

您应注意使默认设置中的“管理层查询”（"management queries"）不被允许，由于ntpd会将“非查询”（"noquery"）选项加入默认的“限制”（"restrict"）行，例如：

```
restrict default kod limited nomodify notrap nopeer noquery
restrict -6 default kod limited nomodify notrap nopeer noquery
```

为使诸如 "ntpq -c pe" 之类的命令在本地（localhost）正常工作，您可以添加下列代码：

```
restrict 127.0.0.1
restrict -6 ::1
```

#### 建立大约5个服务器

为了正常工作，ntpd需要与至少3台服务器通讯，因为（“有一个手表的人知道时间；但是如果一个人有两个手表，他就不能确定时间”）。

对于池中的服务器，我们建议设置不少于4台服务器，也不多于7台。

#### 请不要使用 *.pool.ntp.org 的服务器

如果您想把您的服务器加入池中，为使池的服务达到最佳水平，您不应该在设置中使用*.pool.ntp.org的别名。

为使池保持稳健，如果所有的池操作者“手动选取”（"hand pick"）（相对于网络中）（(network wise)）的优质本地时间服务器的话，那将会更好。 NTP.org 的wiki页面有一个 [公共服务器清单](http://support.ntp.org/bin/view/Servers/WebHome).

#### 使用标准的 ntpd

我们一直支持软件多样性，但是很大一部分有关“它不工作”的问题出现在 ntpd 以外的其他软件中。

您能在任何遵循NTP协议的软件中*使用* 这个池，但如果您想加入池中，我们推荐您使用 [ntpd](http://support.ntp.org/bin/view/Main/SoftwareDownloads).

#### 请勿使用本地时钟驱动！

NTP池中的服务器不应有本地时钟驱动的设置。

## Audience for this document 本文档的受众

​	Anyone distributing an appliance, operating system or some other kind of software using NTP. 
任何使用 NTP 分发设备、操作系统或其他类型的软件的人。

- Appliance vendors (Netgear, D-Link, Linksys, ...)
  设备供应商（Netgear、D-Link、Linksys 等）
- Operating System vendors (Debian, RedHat, FreeBSD, m0n0wall, ...)
  操作系统供应商 （Debian， RedHat， FreeBSD， m0n0wall， ...）
- Software vendors 软件供应商



## Why use NTP? 为什么使用NTP？

​	From [What is NTP?](http://www.ntp.org/ntpfaq/NTP-s-def.htm) at ntp.org. 
从什么是 NTP？在 ntp.org。

> Time usually just advances. If you have communicating programs running on  different computers, time still should even advance if you switch from  one computer to another. Obviously if one system is ahead of the others, the others are behind that particular one. From the perspective of an  external observer, switching between these systems would cause time to  jump forward and back, a non-desirable effect.
> 时间通常只是前进。如果您在不同的计算机上运行通信程序，那么如果您从一台计算机切换到另一台计算机，时间仍然应该提前。显然，如果一个系统领先于其他系统，那么其他系统就会落后于该特定系统。从外部观察者的角度来看，在这些系统之间切换会导致时间向前和向后跳跃，这是一种不受欢迎的效果。
>
> As a consequence, isolated networks may run their own wrong time, but as  soon as you connect to the Internet, effects will be visible. Just  imagine some EMail message arrived five minutes before it was sent, and  there even was a reply two minutes before the message was sent.
> 因此，孤立的网络可能会运行错误的时间，但一旦您连接到互联网，效果就会显现出来。试想一下，一些 EMail 消息在发送前五分钟到达，甚至在消息发送前两分钟才有回复。
>
> Even on a single computer some applications have trouble when the time jumps backwards. For example, database systems using transactions and crash  recovery like to know the time of the last good state.
> 即使在一台计算机上，当时间向后跳跃时，某些应用程序也会出现问题。例如，使用事务和崩溃恢复的数据库系统喜欢知道上次良好状态的时间。
>
> Therefore, air traffic control was one of the first applications for NTP.
> 因此，空中交通管制是NTP的首批应用之一。



## Basic guidelines 基本准则

NTP is a service typically running quietly in the background. When servers  are chosen they will typically remain in the configuration "forever". If the client traffic causes trouble for the  server it is extremely difficult to mitigate if not carefully planned for in advance. 
NTP 是一种通常在后台安静运行的服务。选择服务器后，它们通常会“永远”保留在配置中。如果客户端流量给服务器带来麻烦，如果不事先仔细规划，则很难缓解。

​	A couple of examples in the past years are [Flawed Routers Flood University of Wisconsin Internet Time Server](http://www.cs.wisc.edu/~plonka/netgear-sntp/) in 2003 and the [D-Link misconfiguration incident](http://people.freebsd.org/~phk/dlink/) in 2006. 
过去几年的几个例子是 2003 年威斯康星大学互联网时间服务器的有缺陷路由器洪水和 2006 年的 D-Link 错误配置事件。

 You must get approval from the server operator before you hardcode any IP addresses or hostnames. This is easy to get if your own organization runs the NTP servers you are planning to use. In most other cases you will not get it. 
在对任何 IP 地址或主机名进行硬编码之前，必须获得服务器操作员的批准。如果您自己的组织运行您计划使用的 NTP 服务器，则很容易获得此功能。在大多数其他情况下，你不会得到它。

 Do not use the standard **pool.ntp.org** names as a default configuration in your system. The NTP Pool can offer services for you, but it must be setup in advance (see below).
请勿在系统中使用标准 pool.ntp.org 名称作为默认配置。NTP 池可以为您提供服务，但必须提前设置（见下文）。

​	Typically the best solution is for your organization to setup your own  cluster of NTP servers, for example ntp1.example.com, ntp2.example.com  and ntp3.example.com and use those as the default in your configuration. 
通常，最佳解决方案是组织设置自己的 NTP 服务器群集，例如 ntp1.example.com、ntp2.example.com 和 ntp3.example.com，并在配置中使用这些服务器作为默认服务器。



## What the NTP Pool can offer NTP 池可以提供什么

 The NTP Pool Project was started in 2003 as a response to the rapidly  increasing resource consumption at the popular NTP servers and the problem of these servers then  closing their operations.  Today it has grown to be central to the  operation of millions of systems around the world. 
NTP 池项目于 2003 年启动，以应对流行的 NTP 服务器资源消耗的迅速增加以及这些服务器随后关闭其操作的问题。如今，它已发展成为全球数百万个系统运行的核心。

​	Rather than establish and maintain your own cluster of NTP servers or  negotiate with individual server operators to use their server, you can  use the NTP Pool. 
您可以使用 NTP 池，而不是建立和维护自己的 NTP 服务器集群，或与单个服务器运营商协商使用其服务器。



### Get your vendor zone 获取您的供应商专区

To allow you to use the pool as the default time service in your application, we will set you up with special hostnames, for example `0.vendor.pool.ntp.org`, `1.vendor.pool.ntp.org`,        `2.vendor.pool.ntp.org` and `3.vendor.pool.ntp.org`.
为了允许您将池用作应用程序中的默认时间服务，我们将为您设置特殊的主机名，例如 `0.vendor.pool.ntp.org` 、 `1.vendor.pool.ntp.org` 和 `2.vendor.pool.ntp.org` `3.vendor.pool.ntp.org` 。

​	You **must absolutely not use the default pool.ntp.org zone names** as the default configuration in your application or appliance. 
绝对不能使用默认 pool.ntp.org 区域名称作为应用程序或设备中的默认配置。

​	    You can [             apply for a vendor zone](https://manage.ntppool.org/manage/vendor) here on the site. 
您可以在网站上申请供应商专区。

​	If you have an open source ntpd implementation or an operating system including ntpd, we ask that you make a reference in the configuration file or documentation encouraging people to [join 	the pool](https://www.ntppool.org/join.html). 
如果您有开源的 ntpd 实现或包含 ntpd 的操作系统，我们要求您在配置文件或文档中引用鼓励人们加入池。

​	If you are a commercial / closed-source vendor we will ask for a [small contribution](https://www.ntppool.org/vendors/contribute.html) to help scaling the pool to meet demands. 
如果您是商业/闭源供应商，我们将要求您提供少量捐款，以帮助扩展池以满足需求。

​	Questions?  Email [ask@develooper.com](mailto:ask@develooper.com). 
问题？电子邮件 ask@develooper.com。



### Pool Capacity 泳池容量

The pool is currently keeping the time of an estimated 5-15 million systems accurate.
该池目前保持估计的 5-1500 万个系统的时间准确。

With our technology and expertise we can vastly expand the number of supported systems with relatively modest contributions.
凭借我们的技术和专业知识，我们可以以相对适度的贡献大大扩展受支持系统的数量。

### Implementation specifics 实施细节

​		You can choose either to implement a full ntpd server or a simpler SNTP implementation. 		A few more pointers and ground-rules: 
您可以选择实现完整的 ntpd 服务器或更简单的 SNTP 实现。还有一些提示和基本规则：

- Only use the pool.ntp.org hostnames designated to you (typically {0,1,2,3}.{vendor}.pool.ntp.org)
  仅使用指定给您的 pool.ntp.org 主机名（通常为 {0,1,2,3}）。供应商}.pool.ntp.org）
- Do implement handling of the "KoD" response
  务必实现对“KoD”响应的处理
- Don't send excessively frequent queries.  Reasonable query intervals are  typically from once or twice a day to a 4-5 times an hour depending on  the application.  Really consider how often the device will need "fresh  time".  A standard ntpd or openntpd server works, too.
  不要发送过于频繁的查询。合理的查询间隔通常为每天一次或两次，每小时 4-5 次，具体取决于应用程序。真正考虑设备需要“新鲜时间”的频率。标准的 ntpd 或 openntpd 服务器也可以工作。
- Do have your devices query the NTP servers at random times of the day.   For example every 43200 seconds since boot is good, at midnight every  day is bad.
  请让您的设备在一天中的随机时间查询 NTP 服务器。例如，自开机以来每 43200 秒一次是好的，每天午夜是坏的。
- Do re-query DNS for a new NTP server IP address if one of the current NTP  servers stops responding, though not more often than once per hour.
  如果当前 NTP 服务器之一停止响应，请重新查询 DNS 以获取新的 NTP 服务器 IP 地址，但频率不超过每小时一次。
- Read the [new SNTP RFC](http://www.faqs.org/rfc/rfc4330.txt) if you are implementing an SNTP client.
  如果要实现 SNTP 客户端，请阅读新的 SNTP RFC。

​		We can refer you to consultants with vast expertise in the NTP  protocol and time-keeping applications who can help.  Just email Ask  Bjørn Hansen at [ask@develooper.com](mailto:ask@develooper.com). 
我们可以将您推荐给在NTP协议和计时应用方面具有丰富专业知识的顾问，他们可以提供帮助。只需发送电子邮件至 Ask Bjørn Hansen，地址为 ask@develooper.com。



## Open source projects 开源项目

​	Open Source projects are of course particularly welcome to use the pool in their default setup, but we ask that you [get a vendor zone](https://www.ntppool.org/zh/vendors.html#vendor-zone) when using the pool as a default configuration. 
当然，特别欢迎开源项目在其默认设置中使用池，但我们要求您在使用池作为默认配置时获得供应商区域。



## Vendor FAQ 供应商常见问题

​	Most questions should be answered elsewhere on the page.  Here are some that didn't fit in above. 
大多数问题应该在页面上的其他地方回答。以下是一些不适合上面的内容。

- Why use special hostnames for vendors? 为什么要为供应商使用特殊主机名？

  The special hostnames allows us some control of the traffic so we can optimize our load distribution and match clients to the best servers.  It also gives better options for continuing support in case of problems with segments of the client population.  (See the links in the [basic guidelines](https://www.ntppool.org/zh/vendors.html#basic-guidelines) section).   特殊的主机名允许我们对流量进行一些控制，因此我们可以优化负载分布并将客户端与最佳服务器相匹配。它还为在客户群体出现问题时继续提供支持提供了更好的选择。（请参阅基本指南部分中的链接）。