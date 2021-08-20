# FreeSWITCH

我们已经步入了一个新的时代。当前，VoIP已开始成为语音通信的主导并将在全世界范围内引领一场革命，而SIP（Session Initiation Protocal，会话初始协议）必将是这场革命的核心。

就像电子邮件一样，它用于文字通信，经过二十几年的发展，到现在几乎是人人都有一个Email地址了。而在不久的将来，每个人也将会拥有一个用于语音通信的SIP地址。随着互联网的高速发展，数据流量的成本会越来越低，而且，随着3G、4G及WiMax无线网络的发展，网络更将无处不在，各种新型的SIP电话及可以运行在各种移动设备上的SIP客户端可以让你以极低的成本与世界上任何一个角落的人通信。

## 为什么写一本书？

“大多数关于操作系统的图书均重理论而轻实践，而本书则在这两者之间进行了较好的折中。”  -- Andrew S.Tanenbaum

从第一次读Tanenbaum的《操作系统设计与实现》到现在已经好多年了，可这句写在前言里的话还记忆犹新。在学校里，也学习过程控交换网、移动通信的知识，但只有肤浅的理解。毕业后，我到电信局(这个名字也许太老了。中国电信业在短短的几年内经过了数次重组改制，我离开时叫网通，电信局是我刚参加工作时的名字。)工作，负责程控交换机的维护。在工作中我学到了PSTN网络交换的各种技术，掌握了七号信令系统(SS7)，算是做到了理论与实践相结合。那时候，VoIP还是很新的东西，由于网络条件的限制，国内也少有人用。2007年底，我开始接触Asterisk。阅读了《Asterisk,  电话未来之路》，并买了一个单口的语音卡，实现了VoiceMail，PSTN网关，SIP中继等各种功能。能在自己电脑上就能实现这些有趣的东西，让我非常兴奋。后来，我加入Idapted  Inc.，做一种一对一的网络教学平台。最初的后台语音系统也使用Asterisk。但不久后转到FreeSWITCH。虽然当时FreeSWITCH还是不到1.0的Beta版，但已经显出了比Asterisk高几倍的性能，并且相当的稳定。

FreeSWITCH的主要作者Anthony  Minessal曾有多年的Asterisk开发经验，后来由于他提的一些设想未得到团队其它成员的支持，便独立开发了FreeSWITCH，并以开源软件发布。FreeSWITCH主要使用C、C++开发。为了不“重复发明轮子”，它使用了大量的成熟的第三方软件库，功能丰富，可伸缩性强，并可以使用Lua、Javascript、Perl等多种嵌入式语言控制呼叫流程。另外，它还提供Socket接口，可以使用任何语言进行二次开发或与其它系统进行集成。最重要的是，它有一个非常友好、活跃的社区支持。如果你想到一项功能，可能过几天就实现了；如果你发现一个Bug，提交给开发者，通常第二天就修好了。FreeSWITCH是极少数的trunk代码比最新的发行版更稳定的项目之一。而与此相对的很多商业系统却常常需要很长的修复周期。

当然，我们在使用过程中也遇到不少问题，除了向开发者提交Bug外，我们也提交一些Patch，这不仅能在一定程度上能让FreeSWITCH按我们期望的方式工作，而且，也可以为开源事业做一点点贡献，从而也可以获得一些成就感。而这也正是我们最喜欢开源软件的原因。

[FreeSWITH的文档](http://www.freeswitch.org.cn/2010/04/30/freeswitch-zhong-wen-wen-dang.html)非常丰富，它采用wiki系统，都是来自众多FreeSWITCH爱好者和实践者的奉献。不过，对于初学者来说，查阅起来还不是很方便。因此freeswitch-users邮件列表中也多次有人提到希望能有一本能系统地介绍FreeSWITCH的书。好像也已经有人在写，只是还没有见到。

FreeSWITCH在美国及其它国家已有很多的应用，但国内的用户还很少。2009年下半年，我创办了[FreeSWITCH-CN](http://www.freeswitch.org.cn)，希望能跟更多说中文的朋友一起学习和交流。我曾经设想能找一些志同道合者把所有wiki资料都翻译成中文的。但由于各种原因一直未能实现。随着中文社区的日益发展壮大，越来越多的人向我提问问题，而我也没有太多的时间一一作答。与此同时，我在学习和使用的过程中积累了好多经验，因此，便有了自己写一本书的计划。

当然，上面提到，或者有人在写一本英文的书，但我相信我不是在重复发明轮子。我发现，好多人问问题时，并不是因为不懂FreeSWITCH，而是对一些基本理论或概念理解不清。当然，我不会像教科书上那样照本宣科的讲理论，事实上，我也讲不了。我只是希望能结合多年的工作经验，用一些比较通俗的语言把问题解释清楚，让与我遇到同样问题的朋友少走弯路。

## 章节与内容安排

以什么风格来写呢？曾听人说过，“写作的难处不是考虑该写些什么，而是需要决定什么不应该写进书里。”我深有感触。FreeSWITCH 官方  Wiki  上有几百页的资料，该从何写起呢？如果只是盲目照抄的话，只不过是相当于做了些翻译工作，也没什么意思；如果只是将一些功能及参数机械地罗列出来，那也不过相当于一个中文版的 Wiki。所以，我最后决定写成一个由浅入深步步摔推进的教程。

当然，在最初几章我还是介绍了一些基本概念及背景知识，这主要是给没有电信背景的人看的，另外，对从电路交换转到 VoIP来的读者也会很有帮助。这些内容是不能舍弃的。

接下来应该是安装和配置。笔者看到有不少的图书，在讲一个软件时，将整个的安装过程都会用图一步一步的列出来，有的甚至从如何安装 Linux  起，所有的步骤都抓了图。窃以为那真是太没必要，事实上，这几年在邮件列表中看到大家问得比较多的问题是“我装上了  FreeSWITCH，该怎么用啊？”，而不是“谁能告诉我怎么安装 FreeSWITCH啊？”  所以，如何取舍就显页易见了。本书仅在第二章中提到了如何安装，或许以后如果觉得不够，可以加一个附录，但绝对不会把如何安装 FreeSWITCH  单独作为一章。

实战部分，会以实际的例子讲配置，穿插讲解基本概念。如果有需要罗列的命令参考，在附录中给出。

附录也很重要。除重要的参考资料，背景知识等，还收集了一些我所知道的奇闻轶事。

另外，FreeSWITCH 一直处理很活跃的开发中，所以，某些章节可能刚写完就过时了，最新、最权威的参考还是官方的 Wiki。但是，本书所阐述的基本架构、理念，尤其是历史永远不会进时。

鉴于本书的内容安排，本书适合顺序阅读。

## 谁适合阅读本书？

- 学生。我看过一些学校的教材，大部分只是讲VoIP原理及SIP协议等，很枯燥。
- 教师。显而易见，你希望你的学生能理论与实践相结合。
- FreeSWITCH 初学者。本书肯定对你有帮助。
- FreeSWTICH 高级用户，开发人员。如果你喜欢 FreeSWITCH，也一定会喜欢这本书。
- VoIP爱好者，开发人员。他山之石，可以攻玉。即使你不使用FreeSWITCH，本书也会对你有帮助。
- 电信企业的维护人员、销售人员、决策人员。相信本书能使你更了解客户需求，以及如何才能为客户提供更好的服务。
- 其它企业管理人员。如果你知道电信业务其实还可以提供许多你所不知道的功能和业务，你肯定能很好地加以利用，带来的是效率、节省的是成本。
- 其它人员。开卷有益，而且，你会对你天天离不开的电话、手机，以及新兴的网络电话、即时通讯工具等有一个更好的了解，从而增加工作效率。

## 排版约定

本书是使用[Markdown](http://daringfireball.net/projects/markdown/)标记语言来写的，它比较简单，因此不能像 Latex 那样实现复杂的排版和交叉引用，但作为电子书，也差不多够用了。

命令，程序输出等都使用 HTML 的 PRE 标签。

本书插图由 yed，XMind生成，呼叫流程图就直接用了纯文本。

本书使用[Discount](http://www.pell.portland.or.us/~orc/Code/markdown/)转换成HTML。

为方便读者，书中术语首次出现时尽量给出英文及中文全称，如SIP（Session Initiation Protocal，会话初始协议）。

由于水平所限，存在错误在所难免，欢迎广大F友批评指正。

本书现在只是一个草稿，会不定期做改动，即使大的改动也不一定发布通知。

## 版权声名

[![img](http://i.creativecommons.org/l/by-nc-nd/2.5/cn/88x31.png)](http://creativecommons.org/licenses/by-nc-nd/2.5/cn/)

本书内容采用 [知识共享 署名-非商业性使用-禁止演绎 2.5 中国大陆(CC-BY-NC-ND)][Licence] 授权.任何形式的转载均需加入本授权协议链接（或文本）以及指向本站的链接。

协议地址：http://creativecommons.org/licenses/by-nc-nd/2.5/cn/legalcode 
 本文地址：http://www.freeswitch.org.cn/document

[Licence](http://creativecommons.org/licenses/by-nc-nd/2.5/cn/legalcode)

## 致谢

FreeSWITCHTM是https://freeswitch.org的注册商标。 感谢Anthony Minessal及他的团队给我们提供了如此优秀的软件；同时感谢 FreeSWITCH 社区所有成员的热心帮助。本书的一些资料和例子来自FreeSWITCH [Wiki](http://wiki.freeswitch.org.cn/)及[邮件列表](http://www.freeswitch.org.cn/2014/09/16/google-groups.html)，不能一一查证原作者，在此一并致谢。



# 第一章 PSTN 与 VoIP

[[Book](http://www.freeswitch.org.cn/tags.html#Book)] 

说起VoIP，也许大家对网络电话更熟悉一些。其英文原意是Voice Over  IP，即承载于IP网上的语音通信。大家熟悉家庭用来上网的ADSL吧，也许有些人还记得前些年用过的吱吱叫的老“猫”。技术日新月异，前面的技术都是用电话线上网，现在，VoIP技术使我们可以在网上打电话，生活就是这样。

所谓温故而知新，在了解任何东西以前，我们都最好了解一下其历史，以做到心中有数。在了解VoIP之前，我们需要先看一下PSTN，那在PSTN之前呢？

## PSTN起源

PSTN(Public Switched Telephone Network)的全称是公共交换电话网，就是我们现在打电话所使用的电话网络。

第一次语音传输是亚历山大·贝尔(Alexander Granham  Bell)在1876年用振铃电路实现的。在那之前，普遍认为烽火台是最早的远程通信方式。其实峰火台不仅具备通信的完整要素(通信双方，通信线路及中继器)，而且还是无线通信。当时的没有电话号码，相互通话的用户之间必须有物理线路连接；并且，在同一时间只有一个用户可以讲话(半双工)。发话方通过话音的振动激励电炭精麦克风而转换成电信号，电信号传到远端后通过振动对方的扬声器发声，从而传到对方的耳朵里。

由于每对通话的个体之间都需要单独的物理线路，如果整个电话网上有10个人，而你想要与另个9个人通话，你家就需要铺设9对电话线。同时整个电话网上就需要 *10 x (10-1) / 2 = 45* 对电话线。

当电话用户数量增加的时候，为每对通话的家庭之间铺设电话线是不可能的。因此一种称为交换机（Switch）的设备诞生了。它位于整个电话网的中间用于连接每个用户，用户想打电话时先拿起电话连接到管理交换机的接线员，由接线员负责接通到对方的线路。这便是最早的电话交换网。

由于技术的进步，电子交换机替代了人工交换机，便出现了现代意义的PSTN。随着通信网络的进一步扩大，便出现了许许多多的交换机。交换机间通过中继线（Trunk）相连。有时一个用户与另一个用户通话需要穿越多台交换机。

后来出现了移动电话（当移动电话小到可以拿在手里的时候就开始叫“手机”），专门用于对移动电话进行交换的通信网络称移动网，而原来的程控交换网则叫固定电话网，简称固网。简单来说，移动网就是在普通固网的基础上增加了许多基站（Base Station，可以简单理解为天线），并增加了归属位置寄存器（HLR，Home Location  Register）和拜访位置寄存器（VLR，Visitor Location  Register），以用户记录用户的位置（在哪个天线的覆盖范围内）、支持异地漫游等。移动交换中心称之为MSC（Mobile Switch  Center）。

## 模拟与数字信号

现实中的一切都是模拟的。模拟量（Analog）是连续的变化的，如温度、声音等。早期的电话网是基于模拟交换的。模拟信号对于人类交流来讲非常理想，但它很容易引入噪声。如果通话双方距离很远的话，由于信号的衰减，需要对信号进行放大。问题是信号中经常混入线路的噪音，放大信号的同时也放大的噪音，导致信噪比（信号量与噪声的比例）下降，严重时会难以分辨。

数字（Digital）信号是不连续的（离散的）。它是按一定的时间间隔（单位时间内抽样的次数称为频率）对模拟信号进行抽样得出的一些离散值。根据[抽样定理](http://zh.wikipedia.org/wiki/采样定理)，当抽样频率是最高模拟信号频率的两倍时，就能够完全还原原来的模拟信号。

## PCM

PCM（Pulse Code Modulattion）的全称是脉冲编码调制。它是一种通用的将模拟信号转换成以0和1表示的数字信号的方法。

一般来说，人的声音频率范围在 *300Hz ~ 3400Hz* 之间， 通过滤波器对超过 *4000Hz* 的频率过滤出去，便得到 *4000Hz* 内的模拟信号。然后根据抽样定理，使用 *8000Hz* 进行抽样，便得到离散的数字信号。

通过使用压缩算法（实际为压扩法，因为有的部分压缩有的是扩张的。目的是给小信号更多的比特位数以提高语音质量），可以将每一个抽样值压缩到8个比特。这样就得到 *8 x 8000 = 64000bit* （通常称为64kbit/s。注意，通常来说，对于二进制数，1kbit=1024bit，但此处的k=1000）的信号。通常我们就简称为64k。

PCM通常有两种压缩方式：A律和μ律。其中北美使用μ律，我国和欧洲使用A律。这两种压缩方法很相似，都采用8bit的编码获得12bit到13bit的语音质量。但在低信噪比的情况下，μ律比A律略好。

## 我国电话网结构

![img](http://commondatastorage.googleapis.com/freeswitch.org.cn/images/1-1.png)

图中主体部分为一地市级电话网的结构。通常，话机（如c）通过一对电话线连接到距离最近的交换机上，该交换机称为端局交换机（一般以区或县为单位）。端局交换机通过局间中继线连接到汇接局。为了保证安全，汇接局通常会成对出现，平常实行负荷分担，一台汇接局出现故障时与之配对的汇接局承担所有话务。长途电话需要通过长途局与其它长途局相连。但根据话务量要求，汇接局也可以直接与其它长途局开通高速直达中继。为节省用户线，在一些人口比较集中的地方（如学校、小区），端局下会再设模块局或接入网，用户则就近接入的模块局上。

智能网一般用于实现电话卡、预付费或400/800类业务，而近几年新布署的NGN（Next Generation Network，下一代网络，一般指软交换。）则支持更灵活、更复杂的业务。

## 时分复用与局间中继

### 时分复用

通过将多个信道以时分复用的方式合并到一条电路上，可以减少局间中继线的数量。通过将32个64k的信道利用时分复用合并到一条2M（ *64k x 32 = 2.048M*  ，通俗来说就直接叫一个2M）电路上，称为一个E1（在北美和日本，是24个64k复用，称为T1，速率是1.544M）。在E1中，每一个信道称作一个时隙。其中，除0时隙固定传同步时钟，其它31个时隙最多可以同时支持31路电话（如果使用隨路信令，则使用第16时隙传送，这时最多支持30路电话）。

### 局间中继

这些连接交换机(局)的2M电路就称为局间中继。随着话务量的增加，交换机之间的电路越开越多，目前通常的做法是将63个2M合并到一个155M（ *2 x 63 + P = 155*，其中P是电路复用的开销）的光路（光纤）上。

## 信令

用户设备（如话机）与端局交换机之间，以及交换机与交换机之间需要进行通信。这些通信所包含的信息包括（但不限于）用户、中继线状态，主、被叫号码，中继路由的选择等。我们把这些消息称为信令（Signaling）。

### 用户线信令

用户线信令是从用户话机到端局交换机之间传送的信令。对于普通的话机，线路上传送的是模拟信号，信令只能在电话线路上传送，这种信令称为带内信令。话机通过电压变化来传递摘、挂机信号；通过DTMF（Dual Tone Multi  Frequency，双音多频。话机上每个数字或字母都可以发送一个低频和一个高频信号相结合的正弦波，交换机经过解码即可知道对应的话机按键）传送要拨叫的电话号码。另外，也可以通过移频键控（FSK,Frequency Shift-keying）技术支持来电显示（Caller ID或CLIP，Caller Line Identification  Presentation，主叫线路识别提示）。

与普通电话不同，ISDN（Integrated Service Digital  Network，综合业务数字网）在用户线上传送的是数字信号。它的基本速率接口使用144k的2B+D信道--两个64k的B信道及一个16k的D信道。由于其信令在话路（B信道）以外的D信道传送，这种信令称为带外信令。

实际上，2B+D的ISDN并没有发挥出它应有的作用，在国内已很少有人使用。

### 局间信令

局间信令主要在局间中继上传送。一般一条信令链路通常只占用一个64k的时隙。一条信令消息通常只有几十或上百个字节，一条64k的电路足矣容纳成千上万路电话所需要的信令。但随着技术的进步，话务量的上涨以及更多增值业务的出现，完成一次通话需要更多的信令消息，因此出现了2M速率的信令链路，即整个E1链路上全部传送信令。

局间信令也分为带内信令和带外信令。带内信令又称为随路信令，它是在跟话路同一个2M上传送的，通常使用第16时隙。带外信令则是在独立的专门用于传送信令链路的2M中继上传送的，与带内信令相比，它更加灵活。我国的电话网络中有专门的信令网并使用7号信令（SS7, Signaling System No. 7）。

### 七号信令

SS7是目前我国使用的主要的信令方式

```
用户A          a交换机        b交换机         用户B
   |             |             |             |
   |   摘机              
   |------------>|             |             |
   |   拨号音              
   |<------------|             |             |
   |   拨号            IAM          振铃    
   |------------>|------------>|------------>|
   |   回铃音           ACM      
   |<------------|<------------|             |
   |   通话            ANM           接听
   |<------------|<------------|<------------|
   |   ...       |             |             |
   |   ...       |             |             |
   |   挂机            REL           送催挂音   
   |------------>|------------>|------------>|
   |                  RLC
   |             |<------------|<------------| 
   |             |             |             |
```

我们来看一次简单的固定电话的通话流程。如图。用户A摘机，与其相连的a交换机根据电压变化检测到A摘机后，即送拨号音，同时启动收号程序。A开始拨号，待a交换机号码收齐后，即查找路由，发送IAM（初始地址消息）给b交换机。b向话机B振铃，同时向a发ACM（地址全消息），a向A送回铃音。这时如果B接听电话，则b向a发送ANM（应答计费消息），A与B开始通话，同时a对A计费。通话完毕，任何一方挂机，则本端交换机（如a）向对端b发送REL（释放消息），b向a回RLC（确认，释放完成），并向B送催挂音（啫啫啫...）。

上面在交换机a与b之间传递的为七号信令中的TUP（Telephone User Part，电话用户部分）部分。目前，由于ISUP（ISDN User Part，ISDN用户部分）能与ISDN互联并提供比TUP更多的能力和服务，已基本取代TUP而成为我国七号信令网上主要的信令方式。

## 电路交换与分组交换

Todo.

## VoIP

维基百科上是这样说的:

IP电话(简称VoIP，源自英语Voice over Internet  Protocol；又名宽带电话或网络电话)是一种透过互联网或其他使用IP技术的网络，来实现新型的电话通讯。过去IP电话主要应用在大型公司的内联网内，技术人员可以复用同一个网络提供数据及语音服务，除了简化管理，更可提高生产力。随着互联网日渐普及，以及跨境通讯数量大幅飙升，IP电话亦被应用在长途电话业务上。由于世界各主要大城市的通信公司竞争日剧，以及各国电信相关法令松绑，IP电话也开始应用于固网通信，其低通话成本、低建设成本、易扩充性及日渐优良化的通话质量等主要特点，被目前国际电信企业看成是传统电信业务的有力竞争者。详细内容参见[维基百科上的 IP 电话](http://zh.wikipedia.org/wiki/IP电话)。

目前，VoIP呼叫控制协议主要有SIP、H323，以及MGCP与H.248/MEGACO等。H323是由ITU-T（国际电信联盟）定义的多媒体信息如何在分组交换网络上承载的建议书。它是一个相当复杂的协议，使用起来很不灵活。而SIP则是IETF（互联网工程任务组）开发的（RFC3261），它是一种类似HTTP的基于文本的协议，很容易实现和扩展，被普遍认为是VoIP信令的未来。





​					[![FreeSWITCH权威指南](http://www.freeswitch.org.cn/images/FSDG.jpg) 					
FreeSWITCH权威指南](http://book.dujinfang.com) 				
 				![FreeSWITCH-CN微信公众账号](http://www.freeswitch.org.cn/images/qrcode_for_FreeSWITCH-CN-wechat.jpg) 				
微信公众账号 				
FreeSWITCH-CN 			



​					[![img](http://www.freeswitch.org.cn/images/xyt-logo.png)](http://x-y-t.com) 			



​				 			 			我准备写一本关于FreeSWITCH的书，由于最近很忙，只写了个第二章，初学FreeSWITCH的朋友可以做个参考，也顺便提提意见。

# 第二章 FreeSWITCH 初步

## 什么是 FreeSWITCH ？

FreeSWITCH  是一个开源的电话交换平台，它具有很强的可伸缩性–从一个简单的软电话客户端到运营商级的软交换设备几乎无所不能。能原生地运行于Windows、Max OS X、Linux、BSD 及 solaris  等诸多32/64位平台。可以用作一个简单的交换引擎、一个PBX，一个媒体网关或媒体支持IVR的服务器等。 它支持SIP、H323、Skype、Google Talk等协议，并能很容易地与各种开源的PBX系统如sipXecs、Call  Weaver、Bayonne、YATE及Asterisk等通信。 FreeSWITCH 遵循RFC并支持很多高级的SIP特性，如  presence、BLF、SLA以及TCP、TLS和sRTP等。它也可以用作一个SBC进行透明的SIP代理（proxy）以支持其它媒体如T.38等。FreeSWITCH 支持宽带及窄带语音编码，电话会议桥可同时支持8、12、16、24、32及48kHZ的语音.  而在传统的电话网络中，要做到三方通话或多方通话需要通过专门的芯片来处理，其它像预付费，彩铃等业务在PSTN网络中都需要依靠智能网(IN)才能实现，而且配置起来相当不灵活。

## 快速体验

FreeSWITCH 的功能确实非常丰富和强大，在进一步学习之前我们先来做一个完整的体验。FreeSWITCH 默认的配置是一个SOHO  PBX(家用电话小交换机)，那么我们本章的目标就是从0安装，实现分机互拨电话，测试各种功能，并通过添加一个SIP-PSTN网关拨打PSTN电话。这样，即使你没有任何使用经验，你也应该能顺利走完本章，从而建立一个直接的认识。在体验过程中，你会遇到一点稍微复杂的配置，如果不能完全理解，也不用担心，我们在后面会详细的介绍。当然，如果你是一个很有经验的 FreeSWITCH 用户，那么大可跳过本章。

## 安装FreeSWITCH基本系统

在本文写作时，最新的版本1.2.0-RC2。FreeSWITCH支持32位及64位的Linux、 Mac OS  X、BSD、Solaris、Windows等众多平台。某些平台上有编译好的安装包，但本人强烈建议从源代码进行安装，因为 FreeSWITCH  更新非常快，而已编译好的版本通常都比较旧。你可以下载源码包，也可以直接从git仓库中取得最新的代码。与其它项目不同的是，其git的主（master）分支代码通常比稳定的发布版更稳定。而且，当你需要技术支持时，开发人员也通常建议你先升级到git中最新的代码，再看是不是仍有问题。

Windows用户可以直接下载安装文件 http://files.freeswitch.org/windows/installer/ （再提醒一下，版本比较旧，如果从源代码安装的话，需要Visual Studio 2008或2010）。安装完成执行 *c:\freeswitch\freeswitch.exe* 便可启动，其配置文件都在 *c:\freeswitch\conf\*。

以下假定你使用 Linux 平台，并假定你有 Linux 的基本知识。如何从头安装 Linux  超出了本书的范围，而且，你也可以很容易的从网上找到这样的资料。一般来说，任何发行套件都是可以的，但是，有些发行套件的内核、文件系统、编译环境，LibC 版本会有一些问题。所以，如果你在遇到问题后想获得社区支持，最好选择一种大家都熟悉的发行套件。FreeSWITCH 开发者使用的平台是  CentOS 5.2/5.3（使用CentOS 5.8 也没有问题，有人也成功地在CentOS 6  上成功安装部署，但版本并不总是越新越好），社区中也有许多人在使用 Ubuntu 和 Debian，如果你想用于生产环境，建议使用  LTS（Long Term Support） 的版本，即 Ubuntu8.04/10.04/12.04 或 Debian  Stable。在安装之前，我们需要先准备一些环境—FreeSWITCH 可以以普通用户权限运行，但为了简单起见，以下所有操作均用 root  执行(这不是一个好习惯，但在此，让我们专注于FreeSWITCH而不是Linux）：

CentOS:

```
yum install -y subversion autoconf automake libtool gcc-c++
yum install -y ncurses-devel make libtiff-devel libjpeg-devel
```

Ubuntu:

```
apt-get -y install build-essential automake autoconf git-core wget libtool
apt-get -y install libncurses5-dev libtiff-dev libjpeg-dev zlib1g-dev
```

以下三种安装方式任选其一，默认安装位置在/usr/local/freeswitch。安装过程中会下载源代码目录，请保留，以便以后升级及安装配置其它组件。值得一提的是，CentOS默认的软件仓库中可能没有git，如下你需要使用git安装，则可以先安装 rpmforge （http://pkgs.repoforge.org/rpmforge-release/），然后再安装 git。

### 最快安装（推荐）

```
wget http://www.freeswitch.org/eg/Makefile && make install
```

以上命令会下载一个 Makefile，然后使用 make 执行安装过程。安装过程中它会从 Git 仓库中获取代码，实际上执行的操作跟下一种安装方式相同。

### 从 Git 仓库安装：

从代码库安装能让你永远使用最新的版本:

```
git clone git://git.freeswitch.org/freeswitch.git
cd freeswitch
./bootstrap.sh
./configure
make install
```

这是在在 Linux 上从源代码安装软件的标准过程。首先第1行使用git工具从软件仓库中下载最新的源代码，第3行执行bootstrap.sh初始化一些编译环境，第4行配置编译环境，第5行编译安装。

### 解压缩源码包安装:

```
wget http://files.freeswitch.org/freeswitch-1.2.rc2.tar.bz2
tar xvjf http://files.freeswitch.org/freeswitch-1.2.rc2.tar.bz2
cd freeswitch-1.2
./configure
make install
```

与上一种方法不同的是，它不需要执行过bootstrap.sh（打包前已经执行过了，因而不需要automake和autoconf工具），便可以直接配置安装。

## 安装声音文件

在以下例子中我们需要一些声音文件，而安装这些声音文件也异常简单。你只需在源代码目录中执行：

```
make sounds-install
make moh-install
```

以下高质量的声音文件可选择安装。FreeSWITCH支持8、16、32及48kHz的语音，很少有其它电话系统支持如此多的抽样频率（普通电话是8K，更高频率意味着更好的通话质量）。

```
make cd-sounds-install
make cd-moh-install
```

安装完成后，会显示一个有用的帮助，

```
+---------- FreeSWITCH install Complete ----------+
+ FreeSWITCH has been successfully installed.     +
+                                                 +
+       Install sounds:                           +
+       (uhd-sounds includes hd-sounds, sounds)   +
+       (hd-sounds includes sounds)               +
+       ------------------------------------      +
+                make cd-sounds-install           +
+                make cd-moh-install              +
+                                                 +
+                make uhd-sounds-install          +
+                make uhd-moh-install             +
+                                                 +
+                make hd-sounds-install           +
+                make hd-moh-install              +
+                                                 +
+                make sounds-install              +
+                make moh-install                 +
+                                                 +
+       Install non english sounds:               +
+       replace XX with language                  +
+       (ru : Russian)                            +
+       ------------------------------------      +
+                make cd-sounds-XX-install        +
+                make uhd-sounds-XX-install       +
+                make hd-sounds-XX-install        +
+                make sounds-XX-install           +
+                                                 +
+       Upgrade to latest:                        +
+       ----------------------------------        +
+                make current                     +
+                                                 +
+       Rebuild all:                              +
+       ----------------------------------        +
+                make sure                        +
+                                                 +
+       Install/Re-install default config:        +
+       ----------------------------------        +
+                make samples                     +
+                                                 +
+       Additional resources:                     +
+       ----------------------------------        +
+       http://www.freeswitch.org                 +
+       http://wiki.freeswitch.org                +
+       http://jira.freeswitch.org                +
+       http://lists.freeswitch.org               +
+                                                 +
+       irc.freenode.net / #freeswitch            +
+-------------------------------------------------+
```

至此，已经安装完了。在Unix类操作系统上，其默认的安装位置是/usr/local/freeswtich，下文所述的路径全部相对于该路径。两个常用的命令是 bin/freeswitch 和 bin/fs_cli，为了便于使用，建议将这两个命令做符号链接放到你的搜索路径中，如：

```
ln -sf /usr/local/freeswitch/bin/freeswitch /usr/local/bin/
ln -sf /usr/local/freeswitch/bin/fs_cli /usr/local/bin/
```

当然，如果 /usr/local/bin 不在你的搜索路径中，可以把上面 /usr/local/bin 换成 /usr/bin/。 另外你也可以修改你的PATH环境变量以包含该路径。

接下来就应该可以启动了，通过在终端中执行freeswitch命令(如果你已做符号链接的话，否则要执行/usr/local/freeswitch/bin/freeswitch)可以将其启动到前台，启动过程中会有许多log输出，第一次启动时会有一些错误和警告，可以不用理会。启动完成后会进入到系统控制台(以下称称FS-Con)。并显示类似的提示符“freeswitch@internal>”(以下简作 “FS> ”)。通过在FS-Con中输入shutdown命令可以关闭FreeSWITCH。

如果您想将FreeSWITCH启动到后台(daemon，服务模式)，可以使用freeswitch -nc (No  console)。后台模式没有控制台，如果这时想控制FreeSWITCH，可以使用客户端软件fs_cli连接。注意，在fs_cli中需要使用  fsctl shutdown 命令关闭 FreeSWITCH。当然，也可以直接在 Linux 提示符下通过 freeswitch -stop  命令关闭。如果不想退出 FreeSWITCH 服务，只退出fs_cli客户端，则需要输入 /exit，或Ctrl +  D，或者，直接关掉终端窗口。

### 连接SIP软电话

FreeSWITCH最典型的应用是作为一个服务器(它实际上是一个背靠背的用户代理，B2BUA)，并用电话客户端软件（一般叫软电话）连接到它。虽然 FreeSWITCH 支持 IAX、H323、Skype、Gtalk 等众多通信协议，但其最主要的协议还是  SIP。支持SIP的软电话有很多，最常用的是 X-Lite 和 Zoiper。这两款软电话都支持 Linux、MacOSX 和  Windows平台，免费使用但是不开源。在 Linux 上你还可以使用 ekiga 软电话。

强烈建议在同一局域网上的其它机器上安装软电话，并确保麦克风和耳机可以正常工作  。当然，如果你没有多余的机器做这个实验，那么你也可以在同一台机器上安装。只是需要注意，软电话不要占用 UDP 5060 端口，因为  FreeSWITCH 默认要使用该端口，这是新手常会遇到的一个问题。你可以通过先启动 FreeSWITCH  再启动软电话来避免该问题，另外有些软电话允许你修改本地监听端口。

通过输入以下命令可以知道 FreeSWITCH 监听在哪个IP地址上，记住这个 IP 地址(:5060以前的部分)，下面要用到：

```
netstat -an | grep 5060
```

FreeSWITCH 默认配置了 *1000 ~ 1019* 共 20 个用户，你可以随便选择一个用户进行配置：

在 X-Lite 上点右键，选 Sip Account Settings…，点Add添加一个账号，填入以下参数(Zoiper 可参照配置)：

```
Display Name: 1000
User name: 1000
Password: 1234
Authorization user name: 1000
Domain: 你的IP地址，就是刚才你记住的那个
```

其它都使用默认设置，点 OK 就可以了。然后点 Close 关闭 Sip Account 设置窗口。这时 X-Lite 将自动向  FreeSWITCH 注册。注册成功后会显示”Ready. Your username is  1000”，另外，左侧的“拨打电话”（Dial）按钮会变成绿色的。如下图。

![img](http://commondatastorage.googleapis.com/freeswitch.org.cn/images/2-1.png)

激动人心的时刻就要来了。输入“9664”按回车（或按绿色拨打电话按钮），就应该能听到保持音乐(MOH, Music on  Hold)。如果听不到也不要气馁，看一下 FS-Con 中有没有提示什么错误。如果有“File Not  Found”之类的提示，多半是声音文件没有安装，重新查看 make moh-install 是否有错误。接下来，可以依次试试拨打以下号码：

```
------------------
号码        |   说明
----------------------
9664      |   保持音乐
9196      |   echo，回音测试 
9195      |   echo，回音测试，延迟5秒
9197      |   milliwatte extension，铃音生成 
9198      |   TGML 铃音生成示例
5000      |   示例IVR
4000      |   听取语音信箱
33xx      |   电话会议，48K(其中xx可为00-99，下同)
32xx      |   电话会议，32K
31xx      |   电话会议，16K
30xx      |   电话会议，8K
2000-2002 |   呼叫组
1000-1019 |   默认分机号

表一： 默认号码及说明
```

详情见 http://wiki.freeswitch.org/wiki/Default_Dialplan_QRF。

另外，也许你想尝试注册另外一个SIP用户并在两者间通话。最好是在同一个局域网中的另外一台机器上启动另一个 X-Lite ，并使用 1001 注册，注册完毕后就可以在 1000 上呼叫 1001，或在 1001 上呼叫 1000  。当然，你仍然可以在同一台机器上做这件事（比方说用Zoiper注册为1001），需要注意的是，由于你机器上只有一个声卡，两者可能会争用声音设备。特别是在Linux上，有些软件会独占声音设备。如果同时也有一个USB接口的耳机，那就可以设置不同的软件使用不同的声音设备。

## 配置简介

FreeSWITCH配置文件默认放在 conf/， 它由一系列XML配置文件组成。最顶层的文件是freeswitch.xml，系统启动时它依次装入其它一些XML文件并最终组成一个大的XML文件。

```
文件                                |    说明
---------------------------------------------------
vars.xml                          | 一些常用变量
dialplan/default.xml              | 缺省的拨号计划
directory/default/*.xml           | SIP用户，每用户一个文件
sip_profiles/internal.xml         | 一个SIP profile，或称作一个SIP-UA，监听在本地IP及端口5060，一般供内网用户使用
sip_profiles/externa.xml          | 另一个SIP-UA，用作外部连接，端口5080
autoload_configs/modules.conf.xml | 配置当FreeSWITCH启动时自动装载哪些模块
```

## 添加一个新的SIP用户

FreeSWITCH默认设置了20个用户(1000-1019)，如果你需要更多的用户，或者想通过添加一个用户来学习FreeSWITCH配置，只需要简单执行以下三步：

- 在 conf/directory/default/ 增加一个用户配置文件
- 修改拨号计划(Dialplan)使其它用户可以呼叫到它
- 重新加载配置使其生效

如果想添加用户Jack，分机号是1234。只需要到 conf/directory/default 目录下，将 1000.xml 拷贝到  1234.xml。打开1234.xml，将所有1000都改为1234。并把 effective_caller_id_name 的值改为  Jack，然后存盘退出。如：

```
<variable name="effective_caller_id_name" value="Jack"/>
```

接下来，打开 conf/dialplan/default.xml，找到 <condition field=”destination_number”
 expression=”^(10[01][0-9])$”> 一行，改为 <condition  field=”destination_number”   expression=”^(10[01][0-9]|1234)$”>。熟悉正则表达式的人应该知道，“^(10[01][0-9])$”匹配被叫号码1000-1019。因此我们修改之后的表达式就多匹配了一个1234。FreeSWITCH使用Perl兼容的正则表达式(PCRE)。

现在，回到FS-Con，或启动fs_cli，执行 reloadxml 命令或按快捷键F6，使新的配置生效。

找到刚才注册为1001的那个软电话(或启动一个新的，如果你有足够的机器的话)，把1001都改为1234然后重新注册，则可以与1000相互进行拨打测试了。如果没有多台机器，在同一台机器上运行多个软电话可能有冲突，这时，也可以直接进在FreeSWITCH控制台上使用命令进行测试：

```
FS> sofia status profile internal  (显示多少用户已注册）
FS> originate sofia/internal/1000 &echo  (拨打1000并执行echo程序）
FS> originate user/1000 &echo  (同上）
FS> originate sofia/internal/1000 9999    (相当于在软电话1000上拨打9999)
FS> originate sofia/internal/1000 9999 XML default   (同上)
```

其中，echo() 程序一个很简单的程序，它只是将你说话的内容原样再放给你听，在测试时很有用，在本书中，我们会经常用它来测试。

## FreeSWITCH用作软电话

FreeSWITCH也可以简单的用作一个软电话，如X-Lite. 虽然相比而言比配置X-Lite略微麻烦一些，但你会从中得到更多好处：FreeSWITCH是开源的，更强大、灵活。关键是它是目前我所知道的唯一支持CELT高清通话的软电话。

FreeSWITCH使用mod_portaudio支持你本地的声音设备。该模块默认是不编译的。到你的源代码树下，执行：

```
make mod_portaudio
make mod_portaudio-install
```

其它的模块也可以依照上面的方式进行重新编译和安装。然后到FS-Con中，执行:

```
FS> load mod_portaudio
```

如果得到“Cannot find an input device”之类的错误可能是你的声卡驱动有问题。如果是提示“+OK”就是成功了，接着执行：

```
FS> pa devlist

API CALL [pa(devlist)] output:
0;Built-in Microphone;2;0;
1;Built-in Speaker;0;2;r
2;Built-in Headphone;0;2;
3;Logitech USB Headset;0;2;o
4;Logitech USB Headset;1;0;i
```

以上是在我笔记本上的输出，它列出了所有的声音设备。其中，3和4最后的“o”和“i”分别代表声音输出(out)和输入(in)设备。在你的电脑上可能不一样，如果你想选择其它设备，可以使用命令：

```
FS> pa indev #0
FS> pa outdev #2
```

以上命令会选择我电脑上内置的麦克风和耳机。

接下来你就可以有一个可以用命令行控制的软电话了，酷吧？

```
FS> pa looptest    (回路测试，echo)
FS> pa call 9999
FS> pa call 1000
FS> pa hangup
```

如上所示，你可以呼叫刚才试过的所有号码。现在假设想从SIP分机1000呼叫到你，那需要修改拨号计划(Dialplan)。用你喜欢的编辑器编辑以下文件放到conf/dialplan/default/portaudio.xml

```
<include>
  <extension name="call me">
    <condition field="destination_number" expression="^(me|12345678)$">
      <action application="bridge" data="portaudio"/>
    </condition>
  </extension>
</include>
```

然后，在FS-Con中按“F6”或输入以下命令使之生效：

```
FS> reloadxml
```

在分机1000上呼叫“me”或“12345678”(你肯定想为自己选择一个更酷的号码)，然后在FS-Con上应该能看到类似“[DEBUG] mod_portaudio.c:268 BRRRRING! BRRRRING! call  1”的输出（如果看不到的话按“F8”能得到详细的Log），这说明你的软电话在振铃。多打几个回车，然后输入“pa  answer”就可以接听电话了。“pa hangup”可以挂断电话。

当然，你肯定希望在振铃时能听到真正的振铃音而不是看什么BRRRRRING。好办，选择一个好听一声音文件(.wav格式)，编辑conf/autoload_configs/portaudio.conf.xml，修改下面一行：

```
<param name="ring-file" value="/home/your_name/your_ring_file.wav"/>
```

然后重新加载模块：

```
FS> reloadxml
FS> reload mod_portaudio
```

再打打试试，看是否能听到振铃音了？

如果你用不惯字符界面，可以看一下FreeSWITCH-Air(http://www.freeswitch.org.cn/download)，它为 FreeSWITCH  提供一个简洁的软电话的图形界面。另外，如果你需要高清通话，除需要设置相关的语音编解码器(codec)外，你还需要有一幅好的耳机才能达到最好的效果。本人使用的是一款USB耳机。

## 配置SIP网关拨打外部电话

如果你在某个运营商拥有SIP账号，你就可以配置上拨打外部电话了。该SIP账号（或提供该账号的设备）在 FreeSWITCH  中称为SIP网关（Gateway）。添加一个网关只需要在 conf/sip_profiles/external/  创建一个XML文件，名字可以随便起，如gw1.xml。

```
<gateway name="gw1"> 
	<param name="realm" value="SIP服务器地址，可以是IP或IP:端口号"/>
	<param name="username" value="SIP用户名"/>
	<param name="password" value="密码"/>
	<param name="register" value="true" />
</gateway>
```

如果你的SIP网关还需要其它参数，可以参阅同目录下的 example.xml，但一般来说上述参数就够了。你可以重启 FreeSWITCH，或者执行以下命令使用之生效。

```
FS> sofia profile external rescan reloadxml
```

然后显示一下状态：

```
FS> sofia status
```

如果显示 gateway gw1 的状态是 REGED ，则表明正确的注册到了网关上。你可以先用命令试一下网关是否工作正常：

```
FS> originate sofia/gateway/gw1/xxxxxx &echo()
```

以上命令会通过网关 gw1 呼叫号码 xxxxxx（可能是你的手机号），被叫号码接听电话后，FreeSWITCH 会执行 echo() 程序，你应该能听到自己的回音。

### 从某一分机上呼出

如果网关测试正常，你就可以配置从你的SIP软电话或portaudio呼出了。由于我们是把 FreeSWITCH 当作 PBX  用，我们需要选一个出局字冠。常见的 PBX 一般是内部拨小号，打外部电话就需要加拨 0 或先拨 9  。当然，这是你自己的交换机，你可以用任何你喜欢的数字（甚至是字母）。 继续修改拨号计划，创建新XML文件：  conf/dialplan/default/call_out.xml :

```
<include>
  <extension name="call out">
    <condition field="destination_number" expression="^0(\d+)$">
      <action application="bridge" data="sofia/gateway/gw1/$1"/>
    </condition>
  </extension>
</include>
```

其中，(\d+)为正则表达式，匹配 0 后面的所有数字并存到变量 $1 中。然后通过 bridge 程序通过网关 gw1 打出该号码。当然，建立该XML后需要在Fs-Con中执行 reloadxml 使用之生效。

### 呼入电话处理。

如果你的 SIP 网关支持呼入，那么你需要知道呼入的 DID 。 DID的全称是 Direct Inbound  Dial，即直接呼入。一般来说，呼入的 DID 就是你的 SIP 号码，如果你不知道，也没关系，后面你会学会如何得到。 编辑以下XML文件放到  conf/dialplan/public/my_did.xml

```
<include>
  <extension name="public_did">
    <condition field="destination_number" expression="^(你的DID)$">
      <action application="transfer" data="1000 XML default"/>
    </condition>
  </extension>
</include>
```

reloadxml 使之生效。上述配置会将来话直接转接到分机 1000 上。在后面的章节你会学到如何更灵活的处理呼入电话，如转接到语音菜单或语音信箱等。

## 小结

其实本章涵盖了从安装、配置到调试、使用的相当多的内容，如果你能顺利走到这儿，你肯定对 FreeSWITCH  已经受不释手了。如果你卡在了某处，或某些功能未能实现，也不是你的错，主要是因为 FreeSWITCH  博大精深，我不能在短短的一章内把所有的方面解释清楚。在后面的章节中，你会学到更多的基本概念、更加深入地了解 FreeSWITCH  的哲学，学到更多的调试技术和技巧，解决任何问题都会是小菜一碟了。

本文参考自http://www.freeswitch.org/node/202，但非翻译作品，且已通知原作者。

![img](http://www.dujinfang.com/seven.jpg)

七歌
微信扫一扫

# 第三章 PSTN 与 PBX 业务

[[Book](http://www.freeswitch.org.cn/tags.html#Book)] 

在继续学习 FreeSWITCH 之前，我们有必要了解一下传统的电话网所能提供的服务。这些服务有的是你已经熟悉的，有的也可能没听说过。有一些业务在 VoIP 中实现起来就异常简单，而有一些业务已经不需要了。

## PSTN 业务

### POTS

除为用户提供基本的话音通话外，PSTN 还能提供一些附加的业务，这些业务在国外称为普通老式电话业务（POTS，Plain Old  Telephone  Service），而在国内，我们称之为新业务，当然，这还是沿用数前的叫法。这些业务有的是收费的，有的是不收费的，而这些新业务号码通常以 *  开头。古老的话机是转盘式的（就是电影上蒋介石用的那种话机），使用脉冲方式拨号，只能拨0～9的号码，现在在民间已极少再使用。现在的话机多为按键式，使双音频方式拨号，有0～9及*和#字键。其中，*字键通常读作“星”，但有些运营商的话务员读作“米”。另外有的话机上有A、B、C、D键，很少用到。在某些新业务中（如三方通话），会用到话机上的叉簧，快速拍一下以给交换机传递信号，某些话机上有 Flash 键或 R 键或闪断键能实现相同的功能。下面仅列举几种典型的业务：

- 缩位拨号。通过事先登记的代码拨叫长号码，如 **1 则可以拨叫指定的 12345678
- 呼叫转移。基本的有三种：无条件转移，即任何来电转移至事先登记的号码；遇忙转移，若被叫忙，则转移；无应答转移，若指定时间内无应答，则转移。其中无条件转移的登记方式为 **57\*电话号码#*，取消方式为 *#57#*。登记成功后，所有到该话机的来电会转到所登记的电话号码。如在话机A上操作  **57*B#，则所有对A的呼叫都会转移到B上。适用于将家里或办公室电话转移到手机上的情况。运营商也经常使用该功能作一些特殊的业务，如改号通知。他们通过后台操作将某一号码转移至特定的语音平台，则可以实现“您拨的电话已改号，新的号码是XXX”的功能。
- 立即热线。拿机电话不用拨号即自动拨打某号码，如某些银行的自助服务等。还有一类似的功能叫延迟热线。
- 呼叫等待。被叫忙时，主叫仍听正常的回铃音（或个性化的语音提示：请不要挂机，您拨打的电话正在通话中...），而交换机会通过特殊的提示音提示有新电话呼入，被叫可选择是否接听，或在两者间切换。
- 三方通话。通过比较复杂的操作实现三方通话，某些交换机支持最多5方的多方通话（会议电话）。
- 来电显示。

### 商务业务

运营商的大部分收入还是来自于商务业务。

#### 模拟中继线

模拟中继线又称为用户小交换机，它主要提供号码连选功能。典型应用是提供一个总机号（又称引示号）及若干条中继线。当有人拨号总机号时，交换机会根据指定的策略选择一条空闲的中继线呼入。而用户端通常会接PBX设备，下设分机。当用户呼出时，通过用户端的PBX设备选择一条空闲的线路，用户可选择是否显示总机号。

#### 数字中继线

如果用户需要的中线继数量较多时，数字中继线能提供更稳定的服务，设备通常支持2M的一号信令或30B+D的ISDN信令。

#### 虚拟网

虚拟网又称商务组（BCG，Business Call Group）或汇线通（Centrex）业务。虚拟网主要提供在无需用户端PBX设备的情况下，实现网内（组）电话互拨小号，通常小号间的通话是免费的，但要比普通电话多收月租费。

#### 立即计费

传统的PSTN需要通过额外的系统来计算通话费用，通常需要有一段时间的滞后。而立即计费主要用于酒店等需要立即计费的场合。

#### VPN

VPN(Virtual Private Network)的全称是虚拟专用网，有别于Internet上的VPN。它主要是用在连接大型企业在不同城市的分支机构，实现公司内部互拨小号。

### 其它增值业务

传统的语音业务所带来的收入比例越来越低，因此，各大运营商都纷纷推出基于数据库和计算机系统的各种增值业务以扩大收入。这些业务包括预付费业务（电话卡类业务等），800、400业务以及彩铃、电话秘书台（语音信箱）等。

## PBX 业务

PBX（Private Branch eXchange）的全称是专用小交换机。企业使用 PBX  的好处是可以自己控制内部呼叫，而且内部通话免费。它通常可以提供呼叫保持、自动选线、呼叫转移、呼叫转接等基本功能，比较高级的小交换机还可以提供自动总机、三方通话、语音信箱等。

PBX 的上端通过模拟或数字中继线连接到PSTN，而下端则直接接话机。

#### 中继线

由于 FreeSWITCH 缺省配置可以用作一个PBX，深入理解PBX是非常必要的。下面，我们以模拟中继线为例，通过一则故事进行说明。

TODO（图）。

我们刚开了一个公司，需要 7 部电话，于是申请了 7 条模拟中继线。上文已经指出，实际上就是 7 条普通的电话线，只是在 PSTN  交换机端有特殊的数据设置，将其逻辑上分为一个组，并为该组设一个总机号。我们有幸选到了一个很酷的号码 --   88888888（它可以是一个虚拟的号码，或者是其中某一条中继线的号码）。而其它的中继线号则可能是，44440001 ～  44440007。现在，我们把这 7 条线都接上话机。如果有人呼叫 88888888，则 PSTN 交换机会从 7  条线中选择一条空闲的线呼入，因此某个电话会振铃。一般来说，交换机有两种选线策略──顺序选线和循环选线。所谓顺序选，就是每次都从 44440001 开始，寻找一条空闲的线路进行呼入；而循环选则是每次都从上一次呼叫的下一个开始选起，使用这种选线方式，每个话机接到的电话数会比较平均。

为了维护企业形象，当有人呼出时，不管是从哪个分机呼出，都显示总机号 88888888. 当然，也可以显示单线的号码（如44440004），这个要在 PSTN 交换机端设置，一旦设置后，用户端不能动态更改。

一个月后，公司发展到 21 个人，因此，需要 21 部电话。但由于不会所有人同时打电话，因此我们买了一个小交换机。把原来的 7  条中线线接到小交换机上，而每个人都有一个分机号，从 601 到 621 。当客户打总机号时， PSTN  仍然会选择一条线进入小交换机，这时候，选线方式已经不像以前那样重要，因为现在是小交换机在接电话，对它来说， 7  条线哪条都一样。就这样，小交换机接了电话，并播放“您好，欢迎致电XX公司，请直拨分机号，查号请拨 0  ”，如果客户按某一分机号，则对应分机振铃，电话接通。

有了小交换机，内部通话就免费了。但增加了另外一个问题，就是如果拨打外线，则需要先拨一个特殊的数字，一般是 0 或 9  。有的小交换机会送二次拨号音，即你拿起电话，听小交换机的拨号音，拨了 0 之后，则听到 PSTN  交换机的拨号音，证明你是要拨打外线了。总之，小交换机会选择一条中继线对外呼叫。

其中，21 : 7 称为集线比。即 3 比 1 。集线比是由话务量决定的，如果同时通话的人数比较多，那我们可能考虑把中继线增加到12条，集线比就降为 2 比 1。

即使增加了线路，也经常会遇到这样的情况，由于打进来的电话太多，占用了太多的线路，经常一个电话都打不出，因此，我们联系电信部门，将中继线分为两组，其中4条只进不出，4条只出不进，4条能出能进。在电信术语中，分别叫做单出，单入和双向，而北京则称发专、受专和双向，需要指出，对电信部门来说，出和入跟我们是相反的，因为我们（小交换机）的出，则上他们（PSTN 交换机）的入。当然，这种分配方式降低了总体线路的使用率，为此，我们把每个都增加到5条，总共15条。

又过了几天，有客户反映这样的情况，打电话经常无人接听，需要打好几遍；而同时，内部也有人反映往外打电话时有时拨 0  没反应，再试一次就好了。最直接判断是某条线断了，因为，如果有一条线断了，交换机仍会向对方送回铃音，跟没人接听一样。但到底是哪条线断了，却不好查。因为双方都是自动选线。当然，最直接的办法是将每条线都从小交换机上拨下来，接上话机试一试。某些小交换机也支持指定端口拨打功能，即在拨打真正号码前先拨几个特殊的数字可以选择从指定的线路出去。实际上还有一种方法。一般来说，每条单线的号码也都是可以呼入的，只是外人不知道而已。只需要依次拨打所有的单线号码就可以知道哪条线是断了。当然，这依赖于交换机的设置，有些城市默认设置单线是不允许呼入的。

几天后，老板又通过关系搞到了一个新号码 66666666  ，该号码并未加入中继线组，而是直接到老板办公桌上。但为了拨打内线，他不得不把办公桌上放两部电话，另一部专门打内线。后来技术人员小张仔细阅读了说明书，发现该小交换机功能还比较强，就进行了以下设置。将 66666666  这个号码接到小交换机上，进行特殊设置，只有老板打出时才走这个端口；而对于打入的电话，也不播放“欢迎致电XX公司…”，而是直接向老板电话振铃。这种拨入方式叫做 DID，即对内直接呼叫（Direct Inbound Dial）。

接下来，随着公司的发展，加入的中继线条数越来越多，而维护起来更加麻烦，因为，如果其中有一条线断了，在很长的一段时间内你根本不知道，即使知道了，要找到那条线也非常麻烦。后来，当公司发展到 100 人的时候，公司终于购买了新设备，并将中继线换成了两条 E1 数字线路，可同时支持 60 路电话。

公司发展一帆风顺，电话量也越来越多，公司有了很多分支机构，也有了更多客户，需要更复杂的语音菜单及更智能的分配策略，而更换专门的电话系统不仅价格昂贵，而且跟现有业务系统的集成难度很大。在综合考虑了多种解决方案以后，技术人员开始学习 FreeSWITCH ……





​					[![FreeSWITCH权威指南](http://www.freeswitch.org.cn/images/FSDG.jpg) 					
FreeSWITCH权威指南](http://book.dujinfang.com) 				
 				![FreeSWITCH-CN微信公众账号](http://www.freeswitch.org.cn/images/qrcode_for_FreeSWITCH-CN-wechat.jpg) 				
微信公众账号 				
FreeSWITCH-CN 			



​					[![img](http://www.freeswitch.org.cn/images/xyt-logo.png)](http://x-y-t.com) 			

# 第四章 SIP

[[book](http://www.freeswitch.org.cn/tags.html#book)] 

在继续学习 FreeSWITCH 之前我们有必要来学习一下 SIP 协议，因为它是 FreeSWITCH 的核心。但即使如此，讲清楚  SIP 必然需要很大篇幅，本书是关于 FreeSWITCH 的，而重点不是 SIP。因此，我将仅就理解 FreeSWITCH  必需的一些概念加以通俗的解释，更严肃一些的请参阅其它资料或 RFC（Request For Comments）。

## SIP 的概念和相关元素

会话初始协议（Session Initiation Protocol）是一个控制发起、修改和终结交互式多媒体会话的信令协议。它是由  IETF（Internet Engineering Task Force，Internet工程任务组）在 RFC 2543 中定义的。最早发布于 1999 年 3 月，后来在 2002 年 6 月又发布了一个新的标准 RFC 2361。

SIP 是一个基于文本的协议，在这一点上与 HTTP 和 SMTP 相似。我们来对比一个简单的 SIP 请求与 HTTP 请求：

```
GET /index.html HTTP/1.1

INVITE sip:seven@freeswitch.org.cn SIP/2.0
```

请求由三部分组成。在 HTTP 中， GET 指明一个获取资源（文件）的动作，而 /index.html  则是资源的地址，最后是协议版本号。而在 SIP 中，INVITE 表示发起一次请求，seven@freeswitch.org.cn  为请求的地址，称为 SIP URI，最后也是版本号。其中，SIP URI很类似一个电子邮件，其格式为“协议:名称@主机”。与 HTTP 和  HTTPS 相对应，有 SIP 和  SIPS，后者是加密的；名称可以是一串数字的电话号码，也可以是字母表示的名称；而主机可以是一个域名，也可以是一个IP地址。

SIP 是一个对等的协议，类似  P2P。不像传统电话那样必须有一个中心的交换机，它可以在不需要服务器的情况下进行通信，只要通信双方都彼此知道对方地址（或者，只有一方知道另一方地址），如下图，bob 给 alice 发送一个 INVITE 请求，说“Hi, 一起吃饭吧...”，alice 说"好的，OK"，电话就通了。

![img](http://commondatastorage.googleapis.com/freeswitch.org.cn/images/4-1.png)

在 SIP 网络中，alice 和 bob 都叫做用户代理（UA, User Agent）。UA 是在 SIP 网络中发起或响应 SIP  处理的逻辑功能。UA是有状态的，也就是说，它维护会话（或称对话）的状态。UA 有两种功能：一种是 UAC（UA  Client用户代理客户端），它是发起 SIP 请求的一方，如上图的 bob。另一种是 UAS（UA  Server），它是接受请求并发送响应的一方，如上图中的 alice。由于 SIP 是对等的，如果 alice 呼叫 bob 时（有时候  alice 也主动叫 bob 一起吃饭），alice 就称为 UAC，而 bob 则执行 UAS的功能。一般来说，UA 都会实现上述两种功能。

设想 bob 和 alice 是经人介绍认识的，而他们还不熟悉，bob 想请 alice  吃饭就需要一个中间人（M）传话，而这个中间人就叫代理服务器（Proxy Server）。还有另一种中间人叫做重定向服务器（Redirect  Server），它类似于这样的方式工作──中间人 M 告诉 bob，我也不知道 alice  在哪里，但我老婆知道，要不然我告诉你我老婆的电话，你直接问她吧，我老婆叫 W。这样，M 就成了一个重定向服务器，而他老婆 W  则是真正的代理服务器。这两种服务器都是 UAS，它们主要是提供一对欲通话的 UA  之间的路由选择功能。具有这种功能的设备通常称为边界会话控制器（SBC，Session Border Controller）。

还有一种 UAS 叫做注册服务器。试想这样一种情况，alice 还是个学生，没有自己的手机，但它又希望 bob  能随时找到她，于是当她在学校时就告诉中间人 M 说她在学校，如果有事打她可以打宿舍的电话；而当她回家时也通知 M 说有事打家里电话。只要  alice 换一个新的位置，它就要向 M 重新“注册”新位置的电话，以让 M 能随时找到她，这时候 M 就是一个注册服务器。

最后一种叫做背靠背用户代理（B2BUA，Back-to-Back UA）。需要指出，其实 RFC 3261 并没有定义  B2BUA的功能，它只是一对 UAS 和 UAC的串联。FreeSWITCH 就是一个典型的 B2BUA，事实上，B2BUA  的概念会贯穿本书始终，所以，在此我们需要多花一点笔墨来解释。

我们来看上述故事的另一个版本：M 和 W 是一对恩爱夫妻。M 认识 bob 而 W 认识 alice。M 和 W  有意搓合两个年轻人，但见面时由于两人太腼腆而互相没留电话号码。事后 bob 相知道 alice 对他感觉如何，于是打电话问 M，M 不认识  alice，就转身问老婆 W （注意这次 M 没有直接把 W 电话给 bob），W 接着打电话给 alice，alice 说印象还不错，W  就把这句话告诉 M， M 又转过身告诉 bob。 M 和 W 一个面向 bob，一个对着 alice，他们两个合在一起，称作  B2BUA。在这里，bob 是 UAC，因为他发起请求；M 是 UAS，因为他接受 bob 的请求并为他服务；我们把 M 和 W  看做一个整体，他们背靠着背（站着坐着躺着都行），W 是 UAC，因为她又向 alice 发起了请求，最后 alice 是 UAS。其实这里UAC 和 UAS 的概念也不是那么重要，重要的是要理解这个**背靠背的用户代理**。因为事情还没有完，bob 一听说  alice 对他印象还不错，心花怒放，便想请 alice 吃饭，他告诉 M， M 告诉 W， W 又告诉 alice，alice 问去哪吃，W  又只好问 M， M 再问 bob…… 在这对年轻人挂断电话这前， M 和 W 只能“背对背”的工作。

![img](http://commondatastorage.googleapis.com/freeswitch.org.cn/images/4-2.png)

从上图可以看出，四个人其实全是 UA。从上面故事可以看出，虽然 FreeSWITCH 是  B2BUA，但也可以经过特殊的配置，实现一些代理服务器和重定向服务器的功能，甚至也可以从中间劈开，两边分别作为一个普通的 UA  来工作。这没有什么奇怪的，在 SIP 世界中，所有 UA 都是平等的。具体到实物，则 M 和 W  就组成了实现软交换功能的交换机，它们对外说的语言是 SIP，而在内部，它们则使用自己家的语言沟通。bob 和 alice  就分别成了我们常见的软电话，或者硬件的 SIP 电话。

## SIP 注册

不像普通的固定电话网中，电话的地址都是固定的。因特网是开放的，alice 的 UA 可能在家也可能在学校，或者，在世界是任何角落，只要能上网，它就能与世界通信。为了让我们的  FreeSWITCH 服务器能找到它，它必须向服务器进行注册。通常的注册流程是：

```
Alice                          FreeSWITCH 
  |                                |
  |           REGISTER             |
  |------------------------------->|
  |   SIP/2.0 401 Unauthorized     |
  |<-------------------------------|
  |           REGISTER             |
  |------------------------------->|
  |   SIP/2.0 200 OK               |
  |                                |
```

我们用真正的注册流程进行说明。下面的 SIP 消息是在真正的 FreeSWITCH 中 trace 出来的。其中 FreeSWITCH  服务器的 IP 地址是 192.168.4.4，使用默认的端口号 5060，在这里，我们使用的是 UDP 协议。 alice 使用的 UAC 是 Zoiper，端口号是 5090（在我写作时它与 FreeSWITCH 在同一台机器上，所以不能再使用端口  5060）。其中每个消息短横线之间的内容都是 FreeSWITCH 中输出的调试信息，不是 SIP 的一部分。

```
------------------------------------------------------------------------
recv 584 bytes from udp/[192.168.4.4]:5090 at 12:30:57.916812:
------------------------------------------------------------------------
REGISTER sip:192.168.4.4;transport=UDP SIP/2.0
Via: SIP/2.0/UDP 192.168.4.4:5090;branch=z9hG4bK-d8754z-d9ed3bbae47e568b-1---d8754z-;rport
Max-Forwards: 70
Contact: <sip:alice@192.168.4.4:5090;rinstance=d42207a765c0626b;transport=UDP>
To: <sip:alice@192.168.4.4;transport=UDP>
From: <sip:alice@192.168.4.4;transport=UDP>;tag=9c709222
Call-ID: NmFjNzA3MWY1MDI3NGViMjY1N2QwZDlmZWQ5ZGY2OGE.
CSeq: 1 REGISTER
Expires: 3600
Allow: INVITE, ACK, CANCEL, BYE, NOTIFY, REFER, MESSAGE, OPTIONS, INFO, SUBSCRIBE
User-Agent: Zoiper rev.5415
Allow-Events: presence
Content-Length: 0
```

recv 表明 FreeSWITCH 收到来自 alice 的消息。我们前面已经说进，SIP 是纯文本的协议，类似 HTTP，所以很容易阅读。

- 第一行的 REGISTER 表示是一条注册消息。
- Via 是 SIP 的消息路由，如果 SIP 经过好多代理服务器转发，则会有多条 Via 记录。
- Max-forwards 指出消息最多可以经过多少次转发，主要是为了防止产生死循环。
- Contact 是 alice 家的地址，本例中，FreeSWITCH 应该能在 192.168.4.4 这台机器上的 5090 端口找到她。
- To 和 From 先不管。
- Call-ID 是本次 SIP 会话（Session）的标志。
- CSeq 是一个序号，由于 UDP 是不可靠的协议，在不可靠的网络上可能丢包，所以有些包需要重发，该序号则可以防止重发引起的消息重复。
- Expires 是说明本次注册的有效期，单位是秒。在本例中，alice 应该在一小时内再次向 FreeSWITCH 注册，防止  FreeSWITCH 忘掉她。实际上，大部分 UA 的实现都会在几十秒内就重新发一次注册请求，这在 NAT 的网络中有助于保持连接。
- Allow 是说明 alice 的 UA 所能支持的功能，某些 UA 功能丰富，而某些 UA 仅有有限的功能。
- User-Agent 是 UA 的型号。
- Allow-Events 则是说明她允许哪些事件通知。
- Content-Length 是消息体（Body）的长度，在这里，只有消息头（Header），没有消息体，因此长度为 0 。

.    ------------------------------------------------------------------------    send 664 bytes to udp/[192.168.4.4]:5090 at 12:30:57.919364:    ------------------------------------------------------------------------    SIP/2.0 401 Unauthorized    Via: SIP/2.0/UDP 192.168.4.4:5090;branch=z9hG4bK-d8754z-d9ed3bbae47e568b-1---d8754z-;rport=5090    From: <sip:alice@192.168.4.4;transport=UDP>;tag=9c709222    To: <sip:alice@192.168.4.4;transport=UDP>;tag=QFXyg6gcByvUH    Call-ID: NmFjNzA3MWY1MDI3NGViMjY1N2QwZDlmZWQ5ZGY2OGE.    CSeq: 1 REGISTER    User-Agent: FreeSWITCH-mod_sofia/1.0.trunk-16981M    Allow: INVITE, ACK, BYE, CANCEL, OPTIONS, MESSAGE, UPDATE, INFO, REGISTER, REFER,        NOTIFY, PUBLISH, SUBSCRIBE    Supported: timer, precondition, path, replaces    WWW-Authenticate: Digest realm="192.168.4.4",        nonce="62fb812c-71d2-4a36-93d6-e0008e6a63ee", algorithm=MD5, qop="auth"    Content-Length: 0

FreeSWITCH 需要验证 alice 的身分才允许她注册。在 SIP 中，没有发明新的认证方式，而是使用已有的 HTTP  摘要（Digest）方式来认证。401 消息表示未认证，它是 FreeSWITCH 对 alice  的响应。同时，它在本端生成一个认证摘要（WWW-Authenticate），一齐发送给 alice。

```
------------------------------------------------------------------------
recv 846 bytes from udp/[192.168.4.4]:5090 at 12:30:57.921011:
------------------------------------------------------------------------
REGISTER sip:192.168.4.4;transport=UDP SIP/2.0
Via: SIP/2.0/UDP 192.168.4.4:5090;branch=z9hG4bK-d8754z-dae1693be9f8c10d-1---d8754z-;rport
Max-Forwards: 70
Contact: <sip:alice@192.168.4.4:5090;rinstance=d42207a765c0626b;transport=UDP>
To: <sip:alice@192.168.4.4;transport=UDP>
From: <sip:alice@192.168.4.4;transport=UDP>;tag=9c709222
Call-ID: NmFjNzA3MWY1MDI3NGViMjY1N2QwZDlmZWQ5ZGY2OGE.
CSeq: 2 REGISTER
Expires: 3600
Allow: INVITE, ACK, CANCEL, BYE, NOTIFY, REFER, MESSAGE, OPTIONS, INFO, SUBSCRIBE
User-Agent: Zoiper rev.5415
Authorization: Digest username="alice",realm="192.168.4.4",
    nonce="62fb812c-71d2-4a36-93d6-e0008e6a63ee",
    uri="sip:192.168.4.4;transport=UDP",response="32b5ddaea8647a3becd25cb84346b1c3",
    cnonce="b4c6ac7e57fc76b85df9440994e2ede8",nc=00000001,qop=auth,algorithm=MD5
Allow-Events: presence
Content-Length: 0
```

alice 收到带有摘要的 401 后，后新发起注册请求，这一次，加上了根据收到的摘要和它自己的密码生成的认证信息（Authorization）。并且，你可以看到，CSeq 序号变成了 2。

```
------------------------------------------------------------------------
send 665 bytes to udp/[192.168.4.4]:5090 at 12:30:57.936940:
------------------------------------------------------------------------
SIP/2.0 200 OK
Via: SIP/2.0/UDP 192.168.4.4:5090;branch=z9hG4bK-d8754z-dae1693be9f8c10d-1---d8754z-;rport=5090
From: <sip:alice@192.168.4.4;transport=UDP>;tag=9c709222
To: <sip:alice@192.168.4.4;transport=UDP>;tag=rrpQj11F86jeD
Call-ID: NmFjNzA3MWY1MDI3NGViMjY1N2QwZDlmZWQ5ZGY2OGE.
CSeq: 2 REGISTER
Contact: <sip:alice@192.168.4.4:5090;rinstance=d42207a765c0626b;transport=UDP>;expires=3600
Date: Tue, 27 Apr 2010 12:30:57 GMT
User-Agent: FreeSWITCH-mod_sofia/1.0.trunk-16981M
Allow: INVITE, ACK, BYE, CANCEL, OPTIONS, MESSAGE, UPDATE, INFO, REGISTER, REFER,
    NOTIFY, PUBLISH, SUBSCRIBE
Supported: timer, precondition, path, replaces
Content-Length: 0
```

FreeSWITCH 收到带有认证的注册消息后，核实 alice 身份，认证通过，回应 200 OK。 如果失败，则回应 403 Forbidden 或其它失败消息，如下。

```
------------------------------------------------------------------------
send 542 bytes to udp/[192.168.4.4]:5090 at 13:22:49.195554:
------------------------------------------------------------------------
SIP/2.0 403 Forbidden
Via: SIP/2.0/UDP 192.168.4.4:5090;branch=z9hG4bK-d8754z-d447f43b66912a1b-1---d8754z-;rport=5090
From: <sip:alice@192.168.4.4;transport=UDP>;tag=c097e17f
To: <sip:alice@192.168.4.4;transport=UDP>;tag=yeecX364pvryj
Call-ID: ZjkxMGJmMjE4Y2ZiNjU5MzM5NDZkMTE5NzMzMzM0Mjc.
CSeq: 2 REGISTER
User-Agent: FreeSWITCH-mod_sofia/1.0.trunk-16981M
Allow: INVITE, ACK, BYE, CANCEL, OPTIONS, MESSAGE, UPDATE, INFO, REGISTER, REFER,
    NOTIFY, PUBLISH, SUBSCRIBE
Supported: timer, precondition, path, replaces
Content-Length: 0           
```

你可以看到，alice 的密码是不会直接在 SIP 中传送的，因而一定程序上保证了安全（当然还是会有中间人，重放之类的攻击，我们留到后面讨论）。

## SIP 呼叫流程

### UA 间直接呼叫

上面我们说过，SIP 的 UA  是平等的，如果一方知道另一方的地址，就可以通信。我们先来做一个实验。在笔者的机器上，我启动了两个软电话（UA）， 一个是 bob 的  X-Lite（左），另一个是 alice 是 Zoiper。它们的 IP 地址都是 192.168.4.4，而端口号分别是 26000 和  5090，当 bob 呼叫 alice 时，它只需直接呼叫 alice 的  SIP  地址：sip:alice@192.168.4.4:5090。如图，alice 的电话正在振铃：

![img](http://commondatastorage.googleapis.com/freeswitch.org.cn/images/4-4.png)

详细的呼叫流程图为：

```
bob               alice
|                     |
|    INVITE           |
|-------------------->|
|    100 Trying       |
|<--------------------|
|    180 Ringing      |
|<--------------------|
|    200 OK           |
|<--------------------|
|    ACK              |
|-------------------->|
|                     |
|<---RTP------------->|
|<---RTP------------->|
|<---RTP------------->|
|    ...              |
|                     |
|    BYE              |
|<--------------------|
|    200 OK           |
|-------------------->|
|                     |
```

首先 bob 向 alice 发送 INVITE 请求建立 SIP 连接，alice 的 UA 回 100 Trying  说我收到你的请求了，先等会，接着 alice 的电话开始振铃，并给对回消息 180 Ringing 说我这边已经振铃了，alice  一会就过来接电话，bob 的 UA 收到该消息后可以播放回铃音。接着 alice 接了电话，她发送 200 OK 消息给 bob，该消息是对  INVITE 消息的最终响应，而先前的 100 和 180 消息都是临时状态，只是表明呼叫进展的情况。 bob 收到 200 后向 alice 回 ACK 证实消息。 INVITE - 200 - ACK 完成三次握手，它们合在一起称作一个对话（Dialogue）。这时候 bob 已经在跟 alice 能通话了，他们通话的内容（语音数据）是在SIP之外的 RTP 包中传递的，我们后面再详细讨论。

最后，alice 挂断电话，向 bob 送 BYE 消息，bob 收到 BYE 后回送 200 OK，通话完毕。其中 BYE 和 200 OK 也是一个对话，而上面的所有消息，称作一个会话（Session）。

反过来也一样，alice 可以直接呼叫 bob 的地址： sip:bob@192.168.4.4:26000。

上面描述了一个最简单的 SIP 呼叫流程。实际上，SIP 还有其它一些消息，它们大致可分为请求和响应两类。请求由 UAC 发出，到达  UAS 后， UAS 回送响应消息。某些响应消息需要证实（ACK），以完成三次握手。其中请求消息包括  INVITE、ACK、OPTIOS、BYE、CANCEL、REGISTER 以及一些扩展  re-INVITE、PRACK、SUBSCRIBE、NOTIFY、UPDATE、MESSAGE、REFER等。而响应消息则都包含一个状态码。跟  HTTP 响应类似，状态码有三位数字组成。其中，1xx 组的响应为临时状态，表明呼叫进展的情况；2xx 表明请求已成功处理；3xx 表明 SIP 请求需要转向到另一个 UAS 处理；4xx 表明请求失败，这种失败一般是由客户端或网络引起的，如密码错误等；5xx 为服务器内部错误；6xx  为更严重的错误。

### 通过 B2BUA 呼叫

在真实世界中，bob 和 alice 肯定要经常改变位置，那么它们的 SIP 地址也会相应改变，并且，如果他们之中有一个或两个处于 NAT 的网络中时，直接通信就更困难了。所以，他们通常会借助于一个服务器来相互通信。通过注册到服务器上，他们都可以获得一个服务器上的 SIP  地址。注册服务器的地址一般是不变的，因此他们的 SIP 地址就不会发生变化，因而，他们总是能够进行通信。

我们让他们两个都注册到 FreeSWITCH 上。上面已经说过，FreeSWITCH 监听的端口是 SIP 默认的端口 5060。bob 和 alice 注册后，他们分别获得了一个服务器的地址（SIP URI）：sip:bob@192.168.4.4 和  sip:alice@192.168.4.4（默认的端口号 5060 可以省略）。

下面是 bob 呼叫 alice 的流程。需要指出，如果 bob 只是发起呼叫而不接收呼叫，他并不需要向 FreeSWITCH 注册（有些软交换服务器需要先注册才能发起呼叫，但 SIP 是不强制这么做的）。

```
------------------------------------------------------------------------
recv 1118 bytes from udp/[192.168.4.4]:26000 at 13:31:39.938891:
------------------------------------------------------------------------
INVITE sip:alice@192.168.4.4 SIP/2.0
Via: SIP/2.0/UDP 192.168.4.4:26000;branch=z9hG4bK-d8754z-56adad736231f024-1---d8754z-;rport
Max-Forwards: 70
Contact: <sip:bob@192.168.4.4:26000>
To: "alice"<sip:alice@192.168.4.4>
From: "Bob"<sip:bob@192.168.4.4>;tag=15c8325a
Call-ID: YWEwYjNlZTZjOWZjNDg3ZjU3MjQ3MTA1ZmQ1MDM5YmQ.
CSeq: 1 INVITE
Allow: INVITE, ACK, CANCEL, OPTIONS, BYE, REFER, NOTIFY, MESSAGE, SUBSCRIBE, INFO
Content-Type: application/sdp
User-Agent: X-Lite release 1014k stamp 47051
Content-Length: 594
```

上面的消息中省略了 SDP 的内容，我们将留到以后再探讨。bob 的 UAC 通过 INVITE 消息向 FreeSWITCH  发起请求。bob 的 UAC 用的是 X-Lite（User-Agent），它运行在端口 26000 上（实际上，它默认在端口也是  5060，但由于在我的实验环境下它也是跟 FreeSWITCH 运行在一台机器上，已被占用，因此它需要选择另一个端口）。其中，From  为主叫用户的地址，To 为被叫用户的地址。此时 FreeSWITCH 作为一个 UAS 接受请求并进行响应。它得知 bob 要呼叫  alice，需要在自己的数据库中查找 alice 是否已在服务器上注册，好知道应该怎么找到 alice。但在此之前，它先通知 bob  它已经收到了他的请求。

```
------------------------------------------------------------------------
send 345 bytes to udp/[192.168.4.4]:26000 at 13:31:39.940278:
------------------------------------------------------------------------
SIP/2.0 100 Trying
Via: SIP/2.0/UDP 192.168.4.4:26000;branch=z9hG4bK-d8754z-56adad736231f024-1---d8754z-;rport=26000
From: "Bob"<sip:bob@192.168.4.4>;tag=15c8325a
To: "alice"<sip:alice@192.168.4.4>
Call-ID: YWEwYjNlZTZjOWZjNDg3ZjU3MjQ3MTA1ZmQ1MDM5YmQ.
CSeq: 1 INVITE
User-Agent: FreeSWITCH-mod_sofia/1.0.trunk-16981M
Content-Length: 0        
```

FreeSWITCH 通过 100 Trying 消息告诉 bob “我已经收到你的消息了，别着急，我正在联系 alice 呢...” 该消息称为呼叫进展消息。

```
------------------------------------------------------------------------
send 826 bytes to udp/[192.168.4.4]:26000 at 13:31:39.943392:
------------------------------------------------------------------------
SIP/2.0 407 Proxy Authentication Required
Via: SIP/2.0/UDP 192.168.4.4:26000;branch=z9hG4bK-d8754z-56adad736231f024-1---d8754z-;rport=26000
From: "Bob"<sip:bob@192.168.4.4>;tag=15c8325a
To: "alice" <sip:alice@192.168.4.4>;tag=B4pem31jHgtHS
Call-ID: YWEwYjNlZTZjOWZjNDg3ZjU3MjQ3MTA1ZmQ1MDM5YmQ.
CSeq: 1 INVITE
User-Agent: FreeSWITCH-mod_sofia/1.0.trunk-16981M
Accept: application/sdp
Allow: INVITE, ACK, BYE, CANCEL, OPTIONS, MESSAGE, UPDATE, INFO, REGISTER, REFER,
    NOTIFY, PUBLISH, SUBSCRIBE
Supported: timer, precondition, path, replaces
Allow-Events: talk, presence, dialog, line-seize, call-info, sla,
    include-session-description, presence.winfo, message-summary, refer
Proxy-Authenticate: Digest realm="192.168.4.4",
    nonce="31c5c3e0-cc6e-46c8-a661-599b0c7f87d8", algorithm=MD5, qop="auth"
Content-Length: 0
```

但就在此时，FreeSWITCH 发现 bob 并不是授权用户，因而它需要确认 bob 的身份。它通过发送带有 Digest 验证信息的 407 消息来通知 bob（注意，这里与注册流程中的 401 不同）。

```
------------------------------------------------------------------------
recv 319 bytes from udp/[192.168.4.4]:26000 at 13:31:39.945314:
------------------------------------------------------------------------
ACK sip:alice@192.168.4.4 SIP/2.0
Via: SIP/2.0/UDP 192.168.4.4:26000;branch=z9hG4bK-d8754z-56adad736231f024-1---d8754z-;rport
To: "alice" <sip:alice@192.168.4.4>;tag=B4pem31jHgtHS
From: "Bob"<sip:bob@192.168.4.4>;tag=15c8325a
Call-ID: YWEwYjNlZTZjOWZjNDg3ZjU3MjQ3MTA1ZmQ1MDM5YmQ.
CSeq: 1 ACK
Content-Length: 0
```

bob 回送 ACK 证实消息向 FreeSWITCH 证实已收到认证要求。并重新发送 INVITE，这次，附带了验证信息。

```
------------------------------------------------------------------------
recv 1376 bytes from udp/[192.168.4.4]:26000 at 13:31:39.945526:
------------------------------------------------------------------------
INVITE sip:alice@192.168.4.4 SIP/2.0
Via: SIP/2.0/UDP 192.168.4.4:26000;branch=z9hG4bK-d8754z-87d60b47b6627c3a-1---d8754z-;rport
Max-Forwards: 70
Contact: <sip:bob@192.168.4.4:26000>
To: "alice"<sip:alice@192.168.4.4>
From: "Bob"<sip:bob@192.168.4.4>;tag=15c8325a
Call-ID: YWEwYjNlZTZjOWZjNDg3ZjU3MjQ3MTA1ZmQ1MDM5YmQ.
CSeq: 2 INVITE
Allow: INVITE, ACK, CANCEL, OPTIONS, BYE, REFER, NOTIFY, MESSAGE, SUBSCRIBE, INFO
Content-Type: application/sdp
Proxy-Authorization: Digest username="bob",realm="192.168.4.4",
    nonce="31c5c3e0-cc6e-46c8-a661-599b0c7f87d8",
    uri="sip:alice@192.168.4.4",response="327887635344405bcd545da06763c466",
    cnonce="c164b74f625ff2161bd8d47dba3a0ee2",nc=00000001,qop=auth,
    algorithm=MD5
User-Agent: X-Lite release 1014k stamp 47051
Content-Length: 594
```

这里也省略了 SDP 消息体。

```
------------------------------------------------------------------------
send 345 bytes to udp/[192.168.4.4]:26000 at 13:31:39.946349:
------------------------------------------------------------------------
SIP/2.0 100 Trying
Via: SIP/2.0/UDP 192.168.4.4:26000;branch=z9hG4bK-d8754z-87d60b47b6627c3a-1---d8754z-;rport=26000
From: "Bob"<sip:bob@192.168.4.4>;tag=15c8325a
To: "alice"<sip:alice@192.168.4.4>
Call-ID: YWEwYjNlZTZjOWZjNDg3ZjU3MjQ3MTA1ZmQ1MDM5YmQ.
CSeq: 2 INVITE
User-Agent: FreeSWITCH-mod_sofia/1.0.trunk-16981M
Content-Length: 0
```

FreeSWITCH 重新回 100 Trying，告诉 bob 呼叫进展情况。

至此，bob 与 FreeSWITCH 之间的通信已经初步建立，这种通信的通道称作一个信道（channel）。该信道是由 bob 的 UA 和 FreeSWITCH 的一个 UA 构成的，我们称它为 FreeSWITCH 的一条腿，叫做 a-leg。

接下来 FreeSWITCH 要建立另一条腿，称为 b-leg。它通过查打本地数据库，得到了 alice 的位置，接着启动一个 UA（用作 UAC），向 alice 发送 INVITE 消息。如下：

```
------------------------------------------------------------------------
send 1340 bytes to udp/[192.168.4.4]:5090 at 13:31:40.028988:
------------------------------------------------------------------------
INVITE sip:alice@192.168.4.4:5090;rinstance=e7d5364c81f2b879;transport=UDP SIP/2.0
Via: SIP/2.0/UDP 192.168.4.4;rport;branch=z9hG4bKey90QUyHZQXNN
Route: <sip:alice@192.168.4.4:5090>;rinstance=e7d5364c81f2b879;transport=UDP
Max-Forwards: 69
From: "Bob" <sip:bob@192.168.4.4>;tag=Dp9ZQS3SB26pg
To: <sip:alice@192.168.4.4:5090;rinstance=e7d5364c81f2b879;transport=UDP>
Call-ID: 0d74ac35-cca4-122d-81a2-2990e5b2bd3e
CSeq: 130069214 INVITE
Contact: <sip:mod_sofia@192.168.4.4:5060>
User-Agent: FreeSWITCH-mod_sofia/1.0.trunk-16981M
Allow: INVITE, ACK, BYE, CANCEL, OPTIONS, MESSAGE, UPDATE, INFO, REGISTER, REFER,
    NOTIFY, PUBLISH, SUBSCRIBE
Supported: timer, precondition, path, replaces
Allow-Events: talk, presence, dialog, line-seize, call-info, sla,
    include-session-description, presence.winfo, message-summary, refer
Content-Type: application/sdp
Content-Disposition: session
Content-Length: 313
X-FS-Support: update_display
Remote-Party-ID: "Bob" <sip:bob@192.168.4.4>;party=calling;screen=yes;privacy=off
```

你可以看到，该INVITE 的 Call-ID 与前面的不同，说明这是另一个 SIP 会话（Session）。另外，它还多了一个  Remote-Party-ID，它主要是用来支持来电显示。因为，在 alice 的话机上，希望显示 bob 的号码，显示呼叫它的那个 UA（负责 b-leg的那个 UA）没什么意义。与普通的 POTS 电话不同，在 SIP 电话中，不仅能显示电话号码（这里是  bob），还能显示一个可选的名字（“Bob”）。这也说明了 FreeSWITCH 这个 B2BUA 本身是一个整体，它虽然是以一个单独的 UA  呼叫 alice，但还是跟负责 bob 的那个 UA 有联系--就是这种背靠背的串联。

```
------------------------------------------------------------------------
recv 309 bytes from udp/[192.168.4.4]:5090 at 13:31:40.193634:
------------------------------------------------------------------------
SIP/2.0 100 Trying
Via: SIP/2.0/UDP 192.168.4.4;rport=5060;branch=z9hG4bKey90QUyHZQXNN
To: <sip:alice@192.168.4.4:5090;rinstance=e7d5364c81f2b879;transport=UDP>
From: "Bob" <sip:bob@192.168.4.4>;tag=Dp9ZQS3SB26pg
Call-ID: 0d74ac35-cca4-122d-81a2-2990e5b2bd3e
CSeq: 130069214 INVITE
Content-Length: 0
```

跟上面的流程差不多，alice回的呼叫进展。此时，alice 的 UA 开始振铃。

```
------------------------------------------------------------------------
recv 431 bytes from udp/[192.168.4.4]:5090 at 13:31:40.193816:
------------------------------------------------------------------------
SIP/2.0 180 Ringing
Via: SIP/2.0/UDP 192.168.4.4;rport=5060;branch=z9hG4bKey90QUyHZQXNN
Contact: <sip:alice@192.168.4.4:5090;rinstance=e7d5364c81f2b879;transport=UDP>
To: <sip:alice@192.168.4.4:5090;rinstance=e7d5364c81f2b879;transport=UDP>;tag=3813e926
From: "Bob"<sip:bob@192.168.4.4>;tag=Dp9ZQS3SB26pg
Call-ID: 0d74ac35-cca4-122d-81a2-2990e5b2bd3e
CSeq: 130069214 INVITE
User-Agent: Zoiper rev.5415
Content-Length: 0
```

180也是呼叫进展消息，它说明，我这边已经准备好了，alice 的电话已经响了，她听到了一会就会接听。

```
send 1125 bytes to udp/[192.168.4.4]:26000 at 13:31:40.270533:
------------------------------------------------------------------------
SIP/2.0 183 Session Progress
Via: SIP/2.0/UDP 192.168.4.4:26000;branch=z9hG4bK-d8754z-87d60b47b6627c3a-1---d8754z-;rport=26000
From: "Bob"<sip:bob@192.168.4.4>;tag=15c8325a
To: "alice" <sip:alice@192.168.4.4>;tag=cDg7NyjpeSg4m
Call-ID: YWEwYjNlZTZjOWZjNDg3ZjU3MjQ3MTA1ZmQ1MDM5YmQ.
CSeq: 2 INVITE
Contact: <sip:alice@192.168.4.4:5060;transport=udp>
User-Agent: FreeSWITCH-mod_sofia/1.0.trunk-16981M
Accept: application/sdp
Allow: INVITE, ACK, BYE, CANCEL, OPTIONS, MESSAGE, UPDATE, INFO, REGISTER, REFER,
    NOTIFY, PUBLISH, SUBSCRIBE
Supported: timer, precondition, path, replaces
Allow-Events: talk, presence, dialog, line-seize, call-info, sla,
    include-session-description, presence.winfo, message-summary, refer
Content-Type: application/sdp
Content-Disposition: session
Content-Length: 267
Remote-Party-ID: "alice" <sip:alice@192.168.4.4>
```

FreeSWITCH 在收到 alice 的 180 Ringing 消息后，便告诉 bob 呼叫进展情况，183 与 180 不同的是，它包含 SDP，即接下来它会向 bob 发送 RTP 的媒体流，就是回铃音。

```
------------------------------------------------------------------------
recv 768 bytes from udp/[192.168.4.4]:5090 at 13:31:43.251980:
------------------------------------------------------------------------
SIP/2.0 200 OK
Via: SIP/2.0/UDP 192.168.4.4;rport=5060;branch=z9hG4bKey90QUyHZQXNN
Contact: <sip:alice@192.168.4.4:5090;rinstance=e7d5364c81f2b879;transport=UDP>
To: <sip:alice@192.168.4.4:5090;rinstance=e7d5364c81f2b879;transport=UDP>;tag=3813e926
From: "Bob"<sip:bob@192.168.4.4>;tag=Dp9ZQS3SB26pg
Call-ID: 0d74ac35-cca4-122d-81a2-2990e5b2bd3e
CSeq: 130069214 INVITE
Allow: INVITE, ACK, CANCEL, BYE, NOTIFY, REFER, MESSAGE, OPTIONS, INFO, SUBSCRIBE
Content-Type: application/sdp
User-Agent: Zoiper rev.5415
Content-Length: 226
```

alice 接听电话以后，其 UA 向 FreeSWITCH 送 200 OK，即应答消息。

```
------------------------------------------------------------------------
send 436 bytes to udp/[192.168.4.4]:5090 at 13:31:43.256692:
------------------------------------------------------------------------
ACK sip:alice@192.168.4.4:5090;rinstance=e7d5364c81f2b879;transport=UDP SIP/2.0
Via: SIP/2.0/UDP 192.168.4.4;rport;branch=z9hG4bKF72SSpFNv0K8g
Max-Forwards: 70
From: "Bob" <sip:bob@192.168.4.4>;tag=Dp9ZQS3SB26pg
To: <sip:alice@192.168.4.4:5090;rinstance=e7d5364c81f2b879;transport=UDP>;tag=3813e926
Call-ID: 0d74ac35-cca4-122d-81a2-2990e5b2bd3e
CSeq: 130069214 ACK
Contact: <sip:mod_sofia@192.168.4.4:5060>
Content-Length: 0
```

FreeSWITCH 向 alice 回送证实消息，证实已经知道了。至此，b-leg已经完全建立完毕，多半这时 alice 已经开始说话了：“Hi, bob，你好……”

```
------------------------------------------------------------------------
send 1135 bytes to udp/[192.168.4.4]:26000 at 13:31:43.293311:
------------------------------------------------------------------------
SIP/2.0 200 OK
Via: SIP/2.0/UDP 192.168.4.4:26000;branch=z9hG4bK-d8754z-87d60b47b6627c3a-1---d8754z-;rport=26000
From: "Bob"<sip:bob@192.168.4.4>;tag=15c8325a
To: "alice" <sip:alice@192.168.4.4>;tag=cDg7NyjpeSg4m
Call-ID: YWEwYjNlZTZjOWZjNDg3ZjU3MjQ3MTA1ZmQ1MDM5YmQ.
CSeq: 2 INVITE
Contact: <sip:alice@192.168.4.4:5060;transport=udp>
User-Agent: FreeSWITCH-mod_sofia/1.0.trunk-16981M
Allow: INVITE, ACK, BYE, CANCEL, OPTIONS, MESSAGE, UPDATE, INFO, REGISTER, REFER,
    NOTIFY, PUBLISH, SUBSCRIBE
Supported: timer, precondition, path, replaces
Allow-Events: talk, presence, dialog, line-seize, call-info, sla,
    include-session-description, presence.winfo, message-summary, refer
Session-Expires: 120;refresher=uas
Min-SE: 120
Content-Type: application/sdp
Content-Disposition: session
Content-Length: 267
Remote-Party-ID: "alice" <sip:alice@192.168.4.4>
```

与此同时，它也给 bob 送应答消息，告诉他电话已经接通了，可以跟 alice 说话了。在需要计费的情况下，应该从此时开始对 bob 的电话计费。bob 的 UA 收到该消息后启动麦克风让 bob 讲话。

```
------------------------------------------------------------------------
recv 697 bytes from udp/[192.168.4.4]:26000 at 13:31:43.413025:
------------------------------------------------------------------------
ACK sip:alice@192.168.4.4:5060;transport=udp SIP/2.0
Via: SIP/2.0/UDP 192.168.4.4:26000;branch=z9hG4bK-d8754z-ef53864320037c04-1---d8754z-;rport
Max-Forwards: 70
Contact: <sip:bob@192.168.4.4:26000>
To: "alice"<sip:alice@192.168.4.4>;tag=cDg7NyjpeSg4m
From: "Bob"<sip:bob@192.168.4.4>;tag=15c8325a
Call-ID: YWEwYjNlZTZjOWZjNDg3ZjU3MjQ3MTA1ZmQ1MDM5YmQ.
CSeq: 2 ACK
Proxy-Authorization: Digest username="bob",realm="192.168.4.4",
    nonce="31c5c3e0-cc6e-46c8-a661-599b0c7f87d8",
    uri="sip:alice@192.168.4.4",response="327887635344405bcd545da06763c466",
    cnonce="c164b74f625ff2161bd8d47dba3a0ee2",nc=00000001,qop=auth,
    algorithm=MD5
User-Agent: X-Lite release 1014k stamp 47051
Content-Length: 0
```

bob 在收到应答消息后也需要回送证实消息。至此 a-leg 也建立完毕。双方正常通话。

[][][][][][] **此处省略 5000 字** [][][][][]

```
------------------------------------------------------------------------
recv 484 bytes from udp/[192.168.4.4]:5090 at 13:31:49.949240:
------------------------------------------------------------------------
BYE sip:mod_sofia@192.168.4.4:5060 SIP/2.0
Via: SIP/2.0/UDP 192.168.4.4:5090;branch=z9hG4bK-d8754z-2146ae0ddd113efe-1---d8754z-;rport
Max-Forwards: 70
Contact: <sip:alice@192.168.4.4:5090;rinstance=e7d5364c81f2b879;transport=UDP>
To: "Bob"<sip:bob@192.168.4.4>;tag=Dp9ZQS3SB26pg
From: <sip:alice@192.168.4.4:5090;rinstance=e7d5364c81f2b879;transport=UDP>;tag=3813e926
Call-ID: 0d74ac35-cca4-122d-81a2-2990e5b2bd3e
CSeq: 2 BYE
User-Agent: Zoiper rev.5415
Content-Length: 0
```

终于聊完了，alice 挂断电话，发送 BYE 消息。

```
------------------------------------------------------------------------
send 543 bytes to udp/[192.168.4.4]:5090 at 13:31:49.950425:
------------------------------------------------------------------------
SIP/2.0 200 OK
Via: SIP/2.0/UDP 192.168.4.4:5090;branch=z9hG4bK-d8754z-2146ae0ddd113efe-1---d8754z-;rport=5090
From: <sip:alice@192.168.4.4:5090;rinstance=e7d5364c81f2b879;transport=UDP>;tag=3813e926
To: "Bob"<sip:bob@192.168.4.4>;tag=Dp9ZQS3SB26pg
Call-ID: 0d74ac35-cca4-122d-81a2-2990e5b2bd3e
CSeq: 2 BYE
User-Agent: FreeSWITCH-mod_sofia/1.0.trunk-16981M
Allow: INVITE, ACK, BYE, CANCEL, OPTIONS, MESSAGE, UPDATE, INFO, REGISTER, REFER,
    NOTIFY, PUBLISH, SUBSCRIBE
Supported: timer, precondition, path, replaces
Content-Length: 0
```

FreeSWITCH 返回 OK，b-leg 释放完毕。

```
------------------------------------------------------------------------
send 630 bytes to udp/[192.168.4.4]:26000 at 13:31:50.003165:
------------------------------------------------------------------------
BYE sip:bob@192.168.4.4:26000 SIP/2.0
Via: SIP/2.0/UDP 192.168.4.4;rport;branch=z9hG4bKggvjUH0rS99tc
Max-Forwards: 70
From: "alice" <sip:alice@192.168.4.4>;tag=cDg7NyjpeSg4m
To: "Bob" <sip:bob@192.168.4.4>;tag=15c8325a
Call-ID: YWEwYjNlZTZjOWZjNDg3ZjU3MjQ3MTA1ZmQ1MDM5YmQ.
CSeq: 130069219 BYE
Contact: <sip:alice@192.168.4.4:5060;transport=udp>
User-Agent: FreeSWITCH-mod_sofia/1.0.trunk-16981M
Allow: INVITE, ACK, BYE, CANCEL, OPTIONS, MESSAGE, UPDATE, INFO, REGISTER, REFER,
    NOTIFY, PUBLISH, SUBSCRIBE
Supported: timer, precondition, path, replaces
Reason: Q.850;cause=16;text="NORMAL_CLEARING"
Content-Length: 0
```

接下来 FreeSWITCH 给 bob 发送 BYE，通知要拆线了。出于对 bob 负责，它包含了挂机原因（Hangup Cause），此处 NOMAL_CLEARING 表示正常释放。

```
------------------------------------------------------------------------
recv 367 bytes from udp/[192.168.4.4]:26000 at 13:31:50.111765:
------------------------------------------------------------------------
SIP/2.0 200 OK
Via: SIP/2.0/UDP 192.168.4.4;rport=5060;branch=z9hG4bKggvjUH0rS99tc
Contact: <sip:bob@192.168.4.4:26000>
To: "Bob"<sip:bob@192.168.4.4>;tag=15c8325a
From: "alice"<sip:alice@192.168.4.4>;tag=cDg7NyjpeSg4m
Call-ID: YWEwYjNlZTZjOWZjNDg3ZjU3MjQ3MTA1ZmQ1MDM5YmQ.
CSeq: 130069219 BYE
User-Agent: X-Lite release 1014k stamp 47051
Content-Length: 0
```

bob 回送 OK，a-leg 释放完毕，通话结束。从下图可以很形象地看出 FreeSWITCH 的两条“腿”-- a-leg 和 b-leg。

![img](http://commondatastorage.googleapis.com/freeswitch.org.cn/images/4-3.png)

整个呼叫流程图示如下：

```
bob (UAC)           [ UAS-UAC ]          (UAS) alice
 |                     |   |                     |
 |   INVITE            |   |                     |
 |-------------------->|   |                     |
 |   100 Trying        |   |                     |
 |<--------------------|   |                     |
 |   407 Authentication Required                 |
 |<--------------------|   |                     |
 |   ACK               |   |                     |
 |-------------------->|   |                     |
 |   INVITE            |   |                     |
 |-------------------->|   |                     |
 |   100 Trying        |   |    INVITE           |
 |<--------------------<   >-------------------->|
 |                     |   |    100 Trying       |
 |                     |   |<--------------------|
 |   183 Progress      |   |    180 Ringing      |
 |<--------------------<   |<--------------------|
 |                     |   |    200 OK           |
 |                     |   |<--------------------|
 |   200 OK            |   |    ACK              |
 |<--------------------<   >-------------------->|
 |   ACK               |   |                     |
 |-------------------->|   |                     |
 |                                               |
 |                Call Connected                 |
 |                                               |
 |                     |   |     BYE             |
 |                     |   |<--------------------|
 |   BYE               |   |    200 OK           |
 |<--------------------<   >-------------------->|
 |   200 OK            |   |                     |
 |-------------------->|   |                     |
 |                     |   |                     |
```

从流程图可以看出，右半部分跟上一节“UA间直接呼叫”一样，而左半部分也类似。这就更好的说明了实际上有 4 个 UA （两对）参与到了通信中，并且，有两个 Session。

## 再论 SIP URI

上面我们介绍了一些 FreeSWITCH 的基本概念，并通过一个真正的呼叫流程讲解了一下 SIP。由于实验中所有 UA 都 运行在一台机器上，这可能会引起迷惑，如果我们有三台服务器，那么情况可能是：

```
                    /---------------\
                    |  FreeSWITCH   |
                    |  192.168.0.1  |
                    \ --------------/
sip:bob@192.168.0.1    /          \     sip:alice@192.168.0.1
                      /            \
                     /              \
  /-----------------\               /-----------------\
  |  bob            |               |  alice          |
  |  192.168.0.100  |               |  192.168.0.200  |
  \-----------------/               \-----------------/

  sip:bob@192.168.0.100                sip:alice@192.168.0.200
```

alice 注册到 FreeSWITCH，bob呼叫她时，使用她的服务器地址，即  sip:alice@192.168.0.1，FreeSWITCH 接到请求后，查找本地数据库，发现 alice 的实际地址是  sip:alice@192.168.0.200，便可以建立呼叫。

SIP URI 除使用 IP 地址外，也可以使用域名，如 sip:alice@freeswitch.org.cn。更高级也更复杂的配置则需要 DNS 的 SRV 记录，在此就不做讨论了。





​					[![FreeSWITCH权威指南](http://www.freeswitch.org.cn/images/FSDG.jpg) 					
FreeSWITCH权威指南](http://book.dujinfang.com) 				
 				![FreeSWITCH-CN微信公众账号](http://www.freeswitch.org.cn/images/qrcode_for_FreeSWITCH-CN-wechat.jpg) 				
微信公众账号 				
FreeSWITCH-CN 			



​					[![img](http://www.freeswitch.org.cn/images/xyt-logo.png)](http://x-y-t.com) 			



​				 			 			

# 第五章 FreeSWITCH 架构

[[book](http://www.freeswitch.org.cn/tags.html#book)] 

从来章开始，我们正式开始我们的 FreeSWITCH 之旅。今后我们不再用单独的章节来讲述VoIP中的其它要素和概念，而是在用到时穿插于各个章节之中。

## 总体结构

FreeSWITCH 由一个稳定的核心及外围模块组成，如下图：

![FreeSWITCH架构示意图](http://www.freeswitch.org.cn/images/fs-structure.png)

FreeSWITCH  使用线程模型来处理并发请求，每个连接都在单独的线程中进行处理。这不仅能提供最大强度的并发，更重要的是，即使某路电话发生问题，也只影响到它所在的线程，而不会影响到其它电话。FreeSWITCH  的核心非常短小精悍，这也是保持稳定的关键。所有其它功能都在外围的模块中。模块是可以动态加载（以及卸载）的，在实际应用中可以只加载用到的模块。外围模块通过核心提供的 Public API 与核心进行通信，而核心则通过回调机制执行外围模块中的代码。

## 核心

FS Core 是 FreeSWITCH  的核心，它包含了关键的数据结构和复杂的代码，但这些代码只出现在核心中，并保持了最大限度的重用。外围模块只能通过 API  调用核心的功能，因而核心运行在一个受保护的环境中，核心代码都经过精心的编码和严格的测试，最大限度地保持了系统整体的稳定。

核心代码保持了最高度的抽象，因而它可以调用不同功能，不同协议的模块。同时，良好的 API 也使得编写不同的外围模块非常容易。

## 数据库

FreeSWITCH 的核心除了使用内部的队列、哈希表存储数据外，也使用外部的 SQL 数据库存储数据。当前，系统的核心数据库使用  SQLite，默认的存储位置是 db/core.db 。  使用外部数据库的好处是--查询数据不用锁定内存数据结构，这不仅能提供性能，而且降低了死锁的风险，保证了系统稳定。命令 show  calls、show channels 等都是直接从数据库中读取内容并显示的。由于 SQLite 会进行读锁定，因此不建议直接读取核心数据库。

系统对数据库操作做了优化，在高并发状态时，核心会尽量将几百条 SQL  一齐执行，这大大提高了性能。但在低并发的状态下执行显得稍微有点慢，如一个 channel 已经建立了，但还不能在 show channels  中显示；或者，一个 channel 已经 destroy 了，还显示在 show channels  中。但由于这些数据只用于查询，而不用于决策，所以一般没什么问题。

除核心数据库外，系统也支持使用 ODBC 方式连接其它数据库，如 PostgreSQL、MySQL等。某些模块，如  mod_sofia、mod_fifo等都有自己的数据库（表）。如果在 *nix 类系统上使用 ODBC，需要安装  UnixODBC，并进行正确的配置，如果编译安装的话还需要开发包 unixodbc-devel（CentOS） 或  unixodbc-dev（Debian/Ubuntu）。由于 PostgreSQL、MySQL 等都是 Client-Server  的结构，因此，外部程序可以直接查询数据（但需要清楚数据的准确性，可能会比 FreeSWITCH 核心中的数据有所滞后）。

## 模块

FreeSWITCH 主要分为以下几个部分：

### 终点

End Points 是终结 FreeSWITCH 的地方，也就是说再往外走就超出 FreeSWITCH  的控制了。它主要包含了不同呼叫控制协议的接口，如 SIP， TDM 硬件，H323 以及 Google Talk 等。这使得  FreeSWITCH 可以与众多不同的电话系统进行通信。如，可以使用 mod_skypopen 与 Skype  网络进行通信。另外，前面也讲过，它还可以通过 portaudio 驱动本地声卡，用作一个软电话。

### 拨号计划

Dialplan 主要是为了查找电话路由，主要的是 XML 描述的，但它也支持 Asterisk 格式的配置文件。另外它也持 ENUM 查询。

### XML 接口

XML Interface 支持多种获取 XML 配置的方式，它可以是本地的配置文件，或从数据库中读取，甚至是一个能动态返回 XML 的远程 HTTP 服务器。

### 编解码器

FreeSWITCH 支持最广泛的 Codec，除了大多数 VoIP 系统支持的 G711、G722、G729、GSM 外，它还支持 iLBC，BV16/32、SILK、CELT等。它可以同时桥接不同采样频率的电话，以及电话会议等。

### 语音识别

支持语音自动识别（ASR）及文本-语音转换（TTS）。

### 文件格式

支持不同的声音文件格式，如 wav，mp3等。

### 日志

日志可以写到控制台、日志文件、系统日志（syslog）以及远程的日志服务器。

### 嵌入式语言

通过 swig 包装支持多种脚本语本语言控制呼叫流程，如 Lua、Javascript、Perl等。

### 事件套接字

使用 Event Socket 可以使用任何其它语言通过 Socket 方式控制呼叫流程、扩展 FreeSWITCH 功能。

## 目录结构

在 *nix 类系统上，FreeSWITCH 默认的安装位置是 */usr/local/freeswitch*，在 Windows 上可能是 *C:\freeswitch*，目录结构大致相同。

```
bin         可执行程序
db          系统数据库（sqlite），FreeSWITCH 把呼叫信息存放到数据库里以便在查询时无需对核心数据结构加锁
htdocs      HTTP Web srver 根目录
lib         库文件
mod         可加载模块
run         运行目录，存放 PID
sounds      声音文件，使用 playback() 时默认的寻找路径
grammar     语法
include     头文件
log         日志，CDR 等
recordings  录音，使用 record() 时默认的存放路径
scripts     嵌入式语言写的脚本，如使用 lua()、luarun()、jsrun 等默认寻找的路径
storage     语言留言（Voicemail）的录音
conf        配置文件，详见下节
```

## 配置文件

配置文件由许多 XML  文件组成。在系统装载时，XML解析器会将所有XML文件组织在一起，并读入内存，称为XML注册表。这种设计的好处在于其非常高的可扩展性。由于XML文档本身非常适合描述复杂的数据结构，在 FreeSWITCH 中 就可以非常灵活的使用这些数据。并且，外部应用程序也可以很简单地生成XML，FreeSWITCH  在需要时可以动态的装载这些 XML。另外，系统还允许在某些 XML  节点上安装回调程序(函数)，当这些节点的数据变化时，系统便自动调用这些回调程序。

使用 XML 唯一的不足就是手工编辑这些 XML 比较困难，但正如[其作者所言](http://www.freeswitch.org/node/123)，他绝对不是 XML 的粉丝，但这一缺点与它所带来的好处相比是微不足道的。而且，将来也许会有图形化的配置工具，到时候只所高级用户会去看这些XML了。

### 目录结构

配置文件的的目录结构如下（其中结尾有 “/” 的为目录）：

```
autoload_configs/
dialplan/
directory/
extensions.conf
freeswitch.xml
fur_elise.ttml
jingle_profiles/
lang/
mime.types
notify-voicemail.tpl
sip_profiles/
tetris.ttml
vars.xml
voicemail.tpl
web-vm.tpl
```

其中最重要的是 freeswitch.xml，就是它将所有配置文件“粘”到一起。只要有一点 XML  知识，这些配置是很容易看懂的。其中，X-PRE-PROCESS标签称为预处理命令，它用来设置一些变量和装入其它配置文件。在 XML  加载阶段，FreeSWITCH 的 XML 解析器会先将预处理命令进行展开，生成一个大的 XML 文件  log/freeswitch.xml.fsxml。该文件是一个内存镜像，用户不应该手工编辑它。但它对调试非常有用，假设你不慎弄错了某个标签，又不知道它在哪个地方，FreeSWITCH 在加载时就报 XML 的某一行出错，在该文件中就行容易找到。

整个XML文件分为几个重要的部分：configuration  （配置）、dialplan （拨号计划）、directory（用户目录）及phrase（分词）。每一部分又分别装入不同的 XML。

```
小知识：XML
XML由标签(Tag)和属性构成。<tag> 和 </tag>组成一对标签，如果该标签有相关属性，刚以
<tag attr="value"></tag> 形式指定。有些标签无须配对，则必须以 “/>”关闭该标签定义，
如<other\_tag attr="value"/>。
```

### freeswitch.xml

```
<?xml version="1.0"?>
<document type="freeswitch/xml">
    <!-- #comment 这是一个配置文件，本行是注释 -->

    <X-PRE-PROCESS cmd="include" data="vars.xml"/>

    <section name="configuration" description="Various Configuration">
        <X-PRE-PROCESS cmd="include" data="autoload_configs/*.xml"/>
    </section>
</document>
```

上面是一个精减了的 freeswitch.xml。它的根是 *document*，在 *document* 中，有许多 *section*，每个 *section* 都对应一部分功能。其中有两个 X-PRE-PROCESS 预处理指令，它们的作用是将 *data* 参数指定的文件包含（*include*）到本文件中来。由于它是一个预处理指令，FreeSWITCH 在加载阶段只对其进行简单替换，并不进行语法分析，因此，对它进行注释是没有效果的，这是一个新手常犯的错误。假设 vars.xml 的内容如下，它是一个合法的 XML：

```
<!-- this is vars.xml -->
<var>xxxxx</var>
```

若你在调试阶段想把一条 X-PRE-PROCESS 指令注释掉：

```
<!-- <X-PRE-PROCESS cmd="include" data="vars.xml"/> -->
```

当 FreeSWITCH 预处理时，还没有到达 XML 解析阶段，也就是说它还不认识 XML 注释语法，而仅会机械地将预处理指令替换为 vars.xml 里的内容：

```
<!-- <!-- this is vars.xml -->
<var>xxxxx</var> -->                                                  
```

由于 XML 的注释不能嵌套，因此便产生错误的XML。解决办法是破坏掉 X-PRE-PROCESS 的定义，如我常用下面两种方法：

```
<xX-PRE-PROCESS cmd="include" data="vars.xml"/>
<XPRE-PROCESS cmd="include" data="vars.xml"/>
```

由于 FreeSWITCH 不认识 xX-PRE-PROCESS 及 XPRE-PROCESS，因此它会忽略掉该行，相当于注释掉了。

### vars.xml

vars.xml 主要通过 X-PRE-PROCESS 指令定义了一些全局变量。全局变量以 *$${var}* 表示，临时变量以 *${var}* 表示。有些变量是系统在运行时自动获取的，如默认情况下 *$${base_dir}*=/usr/local/freeswitch, *$${local_ip_v4}*=你机器的IP地址等。

### autoload_configs 目录

autoload_configs目录下面的各种配置文件会在系统启动时装入。一般来说都是模块级的配置文件，每个模块对应一个。文件名一般以 *模块名.conf.xxml* 方式命名。其中 *modules.conf.xml* 决定了 FreeSWITCH 启动时自动加载哪些模块。

### dialplan 目录

定义 XML 拨号计划，我们会有专门的章节讲解拨号计划。

### directory 目录

它里面的配置文本决定了 FreeSWITCH 作为注册服务器时哪些用户可以注册上来。FreeSWITCH  支持多个域（Domain），每个域可以写到一个 XML 文件里。默认的配置包括一个 default.xml，里面定义了 1000 ~ 1019  一共 20 个用户。

### sip_profiles

它定义了 SIP 配置文件，实际上它是由 mod_sofia 模块在 autoload_configs/sofia.conf.xml 中加载的。但由于它本身比较复杂又是核心的功能，因此单列了一个目录。我们将会在后面加以详细解释。

## XML 用户目录

XML 用户目录决定了哪些用户可以注册到 FreeSWITCH 上。当然，SIP 并不要求一定要注册才可以打电话，但是用户认证仍需要在用户目录中配置。

用户目录的默认配置文件在 conf/directory/，系统自带的配置文件为 default.xml（其中 dial-string 一行由于排版要求人工换行，实际上不应该有换行）：

```
<domain name="$${domain}">
  <params>
    <param name="dial-string" value="{presence_id=${dialed_user}@${dialed_domain}}
        ${sofia_contact(${dialed_user}@${dialed_domain})}"/>
  </params>

  <variables>
    <variable name="record_stereo" value="true"/>
    <variable name="default_gateway" value="$${default_provider}"/>
    <variable name="default_areacode" value="$${default_areacode}"/>
    <variable name="transfer_fallback_extension" value="operator"/>
  </variables>

</domain>
```

该配置文件决定了哪些用户能注册到 FreeSWITCH 中。一般来说，所有用户都应该属于同一个 domain（除非你想使用多  domain，后面我们会有例子）。这里的 $${domain} 全局变量是在 vars.xml 中设置的，它默认是主机的 IP  地址，但也可以修改，使用一个域名。params 中定义了该 domain 中所有用户的公共参数。在这里只定义了一个  dial-string，这是一个至关重要的参数。当你在使用 user/user_name 或 sofia/internal/user_name  这样的呼叫字符串时，它会扩展成实际的 SIP 地址。其中 sofia_contact 是一个  API，它会根据用户的注册地址扩展成相应的呼叫字符串。

variables 则定义了一些公共变量，在用户做主叫或被叫时，这些变量会绑定到相应的 Channel 上形成 Channel Variable。

在 domain 中还定义了许多组（group），组里面包含很多用户（user）。

```
<groups>
  <group name="default">
    <users>
      <X-PRE-PROCESS cmd="include" data="default/*.xml"/>
    </users>
  </group>
</groups>               
```

在这里，组名 default 并没有什么特殊的意义，它只是随便起的，你可以修改成任何值。在用户标签里，又使用预处理指令装入了 default/ 目录中的所有 XML 文件。你可以看到，在 default/ 目录中，每个用户都对应一个文件。

你也可以定义其它的用户组，组中的用户并不需要是完整的 XML 节点，也可以是一个指向一个已存在用户的“指针”，如下图，使用 type="pointer" 可以定义指针。

```
  <group name="sales">
    <users>
      <user id="1000" type="pointer"/>
      <user id="1001" type="pointer"/>
      <user id="1002" type="pointer"/>
    </users>
  </group>
```

虽然我们这里设置了组，但使用组并不是必需的。如果你不打算使用组，可以将用户节点（users）直接放到 domain 的下一级。但使用组可以支持像群呼、代接等业务。使用 group_call 可以同时或顺序的呼叫某个组的用户。

实际用户相关的设置也很直观，下面显示了 alice 这个用户的设置：

```
<user id="alice">
  <params>
    <param name="password" value="$${default_password}"/>
    <param name="vm-password" value="alice"/>
  </params>
  <variables>
    <variable name="toll_allow" value="domestic,international,local"/>
    <variable name="accountcode" value="alice"/>
    <variable name="user_context" value="default"/>
    <variable name="effective_caller_id_name" value="Extension 1000"/>
    <variable name="effective_caller_id_number" value="1000"/>
    <variable name="outbound_caller_id_name" value="$${outbound_caller_name}"/>
    <variable name="outbound_caller_id_number" value="$${outbound_caller_id}"/>
    <variable name="callgroup" value="techsupport"/>
  </variables>
</user>
```

由上面可以看到，实际上 params 和 variables 可以出现在 user 节点中，也可以出现在 group 或 domain 中。 当它们有重复时，优先级顺序为 user，group，domain。

当然，用户目录还有一些更复杂的设置，我们留待以后再做研究。

## 呼叫流程及相关概念

再复习一下，FreeSWITCH是一个B2BUA，我们还是以第四章中的图为例：

![img](http://commondatastorage.googleapis.com/freeswitch.org.cn/images/4-3.png)

主要呼叫流程有以下两种：

- bob 向 FreeSWITCH 发起呼叫，FreeSWTICH 接着启动另一个 UA 呼叫 alice，两者通话；
- FreeSWITCH 同时呼叫 bob 和 alice，两者接电话后 FreeSWITCH 将 a-leg 和 b-leg 桥接（bridge）到一起，两者通话。

其中第二种又有一种变种。如市场上有人利用上、下行通话的不对称性卖电话回拨卡获取不正当利润：bob 呼叫  FreeSWITCH，FreeSWITCH 不应答，而是在获取 bob 的主叫号码后直接挂机；然后 FreeSWITCH 回拨 bob；bob  接听后 FreeSWITCH 启动一个 IVR 程序指示 bob 输入 alice 的号码；然后 FreeSWITCH 呼叫 Alice……

在实际应用中，由于涉及回铃音、呼叫失败等，实际情况要复杂的多。

### Session 与 Channel

对每一次呼叫，FreeSWITCH 都会启动一个 Session（会话，它包含SIP会话，SIP会在每对UAC-UAS之间生成一个 SIP Session），用于控制整个呼叫，它会一直持续到通话结束。其中，每个 Session 都控制着一个 Channel（信道），Channel  是一对 UA 间通信的实体，相当于 FreeSWITCH 的一条腿（leg），每个 Channel 都有一个唯一的  UUID。另外，Channel 上可以绑定一些呼叫参数，称为 Channel Variable（信道变量）。Channel  中可能包含媒体（音频或视频流），也可能不包含。通话时，FreeSWITCH 的作用是将两个 Channel（a-leg 和  b-leg，通常先创建的或占主动的叫 a-leg）桥接（bridge）到一起，使双方可以通话。

通话中，媒体（音频或视频）数据流在 RTP 包中传送（不同于 SIP， RTP是另外的协议）。一般来说，Channel是双向的，因此，媒体流会有发送（Send/Write）和接收（Receive/Read）两个方向。

### 回铃音与 Early Media

```
A  ------ |a 交换机 | ---X--- | 交换机 b| -------- B
```

为了便于说明，我们假定A与B不在同一台服务器上（如在PSTN通话中可能不在同一座城市），中间需要经过多级服务器的中转。

假设上图是在 PSTN 网络中，A 呼叫 B，B 话机开始振铃，A 端听回铃音（Ring Back Tone）。在早期，B  端所在的交换机只给 A 端交换机送地址全（ACM）信号，证明呼叫是可以到达 B 的，A 端听到的回铃音铃流是由 A  端所在的交换机生成并发送的。但后来，为了在 A 端能听到 B 端特殊的回铃音（如“您拨打的电话正在通话中…” 或 “对方暂时不方便接听您的电话” 尤其是现代交换机支持各种个性化的彩铃 - Ring Back Color Tone 等），回铃音就只能由 B 端交换机发送。在 B  接听电话前，回铃音和彩铃是不收费的（不收取本次通话费。彩铃费用一般是在 B 端以月租或套餐形式收取的）。这些回铃音就称为 Early  Media(早期媒体)。它是由 SIP 的183(带有SDP)消息描述的。

理论上讲，B 接听电话后交换机 b 可以一直不向 a 交换机发送应答消息，而将真正的话音数据伪装成 Early Media，以实现“免费通话”。

### Channel Variable

在每一个 Channel 上都可以设置好多 Variable，称为信道变量。FreeSWITCH 呼叫过程中，会根据这些变量控制 Channel 的行为。

#### $${var} 与 ${var}

${var} 是在 dialplan、application 或 directory 中设置的变量，它会影响呼叫流程并且可以动态的改变。而 $${var} 则是全局的变量，它仅在预处理阶段（系统启动时，或重新装载 -  reloadxml时）被求值。后者一般用于设置一些系统一旦启动就不会轻易改变的量，如 $${domain} 或  $${local_ip_v4}等。所以，两者最大的区别是，$${var} 只求值一次，而 ${var}  则在每次执行时求值（如一个新电话进来时）。

#### $variable_xxxx

你会发现，有些变量在显示时（可以使用dp_tools 中的 info()  显示，后面会讲到）是以“variable_”开头的，但在实际引用时要去掉这开头的“variable_”。如“variable_user_name”，引用时要使用“${user_name}”。http://wiki.freeswitch.org/wiki/Channel_Variables#variable_xxxx 列举了一些常见的变量显示与引用时的对应关系。

#### 给 Variable 赋值

在 dialplan 中，有两个程序可以给 Variable 赋值：

```
<action application="set" data="my_var=my_value"/>
<action application="export" data="my_var=my_value"/>
```

以上两条命令都可以设置 my_var 变量的值为 my_value。不同的是 -- set 程序仅会作用于“当前”的 Channel  （a-leg），而 export 程序则会将变量设置到两个 Channel （a-leg 和 b-leg）上，如果当时 b-leg  还没有创建，则会在创建时设置。另外，export 还可以只将变量设置到 b-leg 上：

```
<action appliction="export" data="nolocal:my_var=my_value"/>
```

在实际应用中，如果 a-leg 上已经有一些变量的值（如 var1、var2、var3），而想同时把这些变量都复制到 b-leg 上，可以使用以下几种办法：

```
<action application="export" data="var1=$var1"/>
<action application="export" data="var2=$var2"/>
<action application="export" data="var3=$var3"/>
```

或者使用如下等价的方式：

```
<action application="set" data="export_vars=var1,var2,var3">
```

所以，其实 set 也具有能往 b-leg 上赋值的能力，其实，它和 export 一样，都是操作 export_vars 这个特殊的变量。

#### 取消 Variable 定义

取消 Variable 定义只需对它赋一个特殊的值_undef_”：

```
<action application="set" data="var1=_undef_">
```

#### 截取 Variable 的一部分

可以使用特殊的语法取一个 Variable 的子串，格式是“${var:位置:长度}”。其中 “位置” 从 0  开始计烽，若为负数则从字符串尾部开始计数；如果“长度”为 0 或小于  0，则会从当前“位置”一直取到字符串结尾（或开头，若“位置”为负的话）。例如 var 的值为 1234567890，那么：

```
${var}      = 1234567890
${var:0:1}  = 1
${var:1}    = 234567890
${var:-4}   = 7890
${var:-4:2} = 78
${var:4:2}  = 56
```

## 小结

本章描述了 FreeSWITCH 的架构。到这里，读者应该对 FreeSWITCH  有了一个总体的了解。我们也提到了一些基本元素和概念，简单介绍了配置文件的基本结构，由于脱离了实际单讲配置会比较抽象，因此，我们把具体的配置也写到后面的章节里，即，用到时再说。





​					[![FreeSWITCH权威指南](http://www.freeswitch.org.cn/images/FSDG.jpg) 					
FreeSWITCH权威指南](http://book.dujinfang.com) 				
 				![FreeSWITCH-CN微信公众账号](http://www.freeswitch.org.cn/images/qrcode_for_FreeSWITCH-CN-wechat.jpg) 				
微信公众账号 				
FreeSWITCH-CN 			



​					[![img](http://www.freeswitch.org.cn/images/xyt-logo.png)](http://x-y-t.com) 			



​				 			 			第六章 运行 FreeSWITCH

[[book](http://www.freeswitch.org.cn/tags.html#book)] 

读到本章，你应该对 FreeSWITCH 有了一个比较全面的了解，迫切地想实验它强大的功能了。让我们从最初的运行开始，一步一步进入 FreeSWITCH 的神秘世界。

## 命令行参数

一般来说，FreeSWITCH 不需要任何命令行参数就可以启动，但在某些情况下，你需要以一些特殊的参数启动。在此，仅作简单介绍。如果你知道是什么意思，那么你就可以使用，如果不知道，多半你用不到。

使用 freeswitch -help 或 freeswitch --help 会显示以下信息：

```
-nf                    -- no forking
-u [user]              -- 启动后以非 root 用户 user 身份运行
-g [group]             -- 启动后以非 root 组 group 身份运行
-help                  -- 显示本帮助信息
-version               -- 显示版本信息
-waste                 -- 允许浪费内存，FreeSWITCH 仅需 240K 的栈空间
                          你可以使用 ulimit -s 240 限制栈空间使用，或使用该选择忽略警告信息
-core                  -- 出错时进行内核转储
-hp                    -- 以高优先级运行
-vg                    -- 在 valgrind 下运行，调试内存泄露时使用
-nosql                 -- 不使用 SQL，show channels 类的命令将不能显示结果
-heavy-timer           -- 更精确的时钟。可能会更精确，但对系统要求更高
-nonat                 -- 如果路由器支持 uPnP 或 NAT-PMP，则 FreeSWITCH 
                          可以自动解决 NAT 穿越问题。如果路由器不支持，则该选项可以使启动更快
-nocal                 -- 关闭时钟核准。FreeSWTICH 理想的运行环境是 1000 Hz 的内核时钟
                          如果你的内核时钟小于 1000 Hz 或在虚拟机上，可以尝试关闭该选项
-nort                  -- 关闭实时时钟
-stop                  -- 关闭 FreeSWTICH，它会在 run 目录中查找 PID文件
-nc                    -- 启动到后台模式，没有控制台
-c                     -- 启动到控制台，默认
-conf [confdir]        -- 指定其它的配置文件所在目录，须与 -log、 -db 合用
-log [logdir]          -- 指定其它的日志目录
-run [rundir]          -- 指定其它存放 PID 文件的运行目录
-db [dbdir]            -- 指定其它数据库目录
-mod [moddir]          -- 指定其它模块目录
-htdocs [htdocsdir]    -- 指定其它 HTTP 根目录
-scripts [scriptsdir]  -- 指定其它脚本目录
```

## 系统启动脚本

在学习调试阶段，你可以启动到前台，而系统真正运行时，你可以使用 -nc 参数启动到后台，然后通过查看 log/freeswitch.log 跟踪系统运行情况（你可以用 tail -f 命令实时跟踪，我一般使用 less）。

一般情况下，启动到前台更容易调试，但你又不想在每次关闭 Terminal 时停止 FreeSWITCH，那么，你可以借助 [screen](http://wiki.freeswitch.org/wiki/Freeswitch_In_Screen) 来实现。

在真正的生产系统上，你需要它能跟系统一起启动。在 *nix 系统上，启动脚本一般放在  /etc/init.d/。你可以在系统源代码目录下找到不同系统启动脚本 debian/freeswitch.init 及  build/freeswitch.init.*，参考使用。在 Windows 上，你也可以注册为 Windows 服务，参见附录中的 FAQ。

## 控制台与命令客户端

系统不带参数会启动到控制台，在控制台上你可以输入各种命令以控制或查询 FreeSWITCH 的状态。试试输入以下命令：

```
version           -- 显示当前版本
status            -- 显示当前状态
sofia status      -- 显示 sofia 状态
help              -- 显示帮助
```

为了调试方便，FreeSWITCH 还在 conf/autoload_configs/switch.conf.xml  中定义了一些控制台快捷键。你可以通过F1-F12来使用它们（不过，在某些操作系统上，有些快捷键可能与操作系统的相冲突，那你就只直接输入这些命令或重新定义他们了）。

```
<cli-keybindings>
  <key name="1" value="help"/>
  <key name="2" value="status"/>
  <key name="3" value="show channels"/>
  <key name="4" value="show calls"/>
  <key name="5" value="sofia status"/>
  <key name="6" value="reloadxml"/>
  <key name="7" value="console loglevel 0"/>
  <key name="8" value="console loglevel 7"/>
  <key name="9" value="sofia status profile internal"/>
  <key name="10" value="sofia profile internal siptrace on"/>
  <key name="11" value="sofia profile internal siptrace off"/>
  <key name="12" value="version"/>
</cli-keybindings>
```

FreeSWITCH 是 Client-Server结构，不管 FreeSWITCH 运行在前台还是后台，你都可以使用客户端软件 fs_cli 连接 FreeSWITCH.

fs_cli 是一个类似 Telnet 的客户端（也类似于 Asterisk 中的 asterisk -r命令），它使用  FreeSWITCH 的 ESL（Event Socket Library）库与 FreeSWITCH 通信。当然，需要加载模块  mod_event_socket。该模块是默认加载的。

正常情况下，直接输入 bin/fs_cli 即可连接上，并出现系统提示符。如果出现：    [ERROR] libs/esl/fs_cli.c:652 main() Error Connecting [Socket Connection Error] 这样的错误，说明 FreeSWITCH 没有启动或 mod_event_socket 没有正确加载，请检查TCP端口8021端口是否处于监听状态或被其它进程占用。

fs_cli 也支持很多命令行参数，值得一提的是 -x 参数，它允许执行一条命令后退出，这在编写脚本程序时非常有用（如果它能支持管道会更有用，但是它不支持）：

```
bin/fs\_cli -x "version"
bin/fs\_cli -x "status"
```

其它的参数都可以通过配置文件来实现，在这里就不多说了。可以参见：http://wiki.freeswitch.org/wiki/Fs_cli

使用fs_cli，不仅可以连接到本机的 FreeSWITCH，也可以连接到其它机器的 FreeSWITCH 上（或本机另外的 FreeSWITCH 实例上），通过在用户主目录下编辑配置文件 **.fs_cli_conf**（注意前面的点“.”），可以定义要连接的多个机器：

```
[server1]
host     => 192.168.1.10
port     => 8021
password => secret_password
debug    => 7

[server2]
host     => 192.168.1.11
port     => 8021
password => someother_password
debug    => 0
```

注意：如果要连接到其它机器，要确保 FreeSWITCH 的 Event Socket 是监听在真实网卡的 IP 地址上，而不是127.0.0.1。另外，在UNIX中，以点开头的文件是隐藏文件，普通的 *ls* 命令是不能列出它的，可以使用 *ls -a*。

一旦配置好，就可以这样使用它：

```
bin/fs_cli server1
bin/fs_cli server2
```

在 fs_cli 中，有几个特殊的命令，它们是以 “/” 开头的，这些命令并不直接发送到 FreeSWITCH，而是先由 fs_cli 处理。/quit、/bye、/exit、Ctrl + D 都可以退出 fs_cli；/help是帮助。

其它一些 “/”开头的指令与 Event Socket 中相关的命令相同，如：

```
/event       -- 开启事件接收
/noevents    -- 关闭事件接收
/nixevent    -- 除了特定一种外，开启所有事件
/log         -- 设置 log 级别，如 /log info 或 /log debug 等 
/nolog       -- 关闭 log
/filter      -- 过滤事件
```

另外，一些“重要”命令不能直接在 fs_cli 中执行，如 shutdown 命令，在控制台上可以直接执行，但在 fs_cli中，需要执行 fsctl shutdown。

除此之外，其它命令都与直接在 FreeSWITCH 控制台上执行是一样的。它也支持快捷键，最常用的快捷键是 F6（reloadxml）、F7（关闭 log输出）、F8（开启 debug 级别的 log 输出）。

在 *nix上，两者都通过 libeditline 支持[命令行编辑功能](http://wiki.freeswitch.org/wiki/Mod_console#Command-Line_Editing)。可以通过上、下箭头查看命令历史。

## 发起呼叫

可以在 FreeSWITCH 中使用 originate 命令发起一次呼叫，如果用户 1000 已经注册，那么：

```
originate user/alice &echo
```

上述命令在呼叫 1000 这个用户后，便执行 echo 这个程序。echo 是一个回音程序，即它会把任何它“听到”的声音（或视频）再返回（说）给对方。因此，如果这时候用户 1000 接了电话，无论说什么都能听到自己的声音。

### 呼叫字符串

上面的例子中，user/alice 称为呼叫字符串，或呼叫 URL。user  是一种特殊的呼叫字符串。我们先来复习一下第四章的场景。FreeSWITCH UA 的地址为 192.168.4.4:5050，alice UA  的地址为 192.168.4.4:5090，bob UA 的地址为 192.168.4.4:26000。若 alice 已向  FreeSWITCH 注册，在 FreeSWITCH 中就可以看到她的注册信息：

```
freeswitch@du-sevens-mac-pro.local> sofia status profile internal reg


Registrations:
=============================================================================================
Call-ID:        ZTRkYjdjYzY0OWFhNDRhOGFkNDUxMTdhMWJhNjRmNmE.
User:           alice@192.168.4.4
Contact:        "Alice" <sip:alice@192.168.4.4:5090;rinstance=a86a656037ccfaba;transport=UDP>
Agent:          Zoiper rev.5415
Status:         Registered(UDP)(unknown) EXP(2010-05-02 18:10:53)
Host:           du-sevens-mac-pro.local
IP:             192.168.4.4
Port:           5090
Auth-User:      alice
Auth-Realm:     192.168.4.4
MWI-Account:    alice@192.168.4.4

=============================================================================================
```

FreeSWITCH 根据 Contact 字段知道 alice 的 SIP 地址  sip:alice@192.168.4.4:5090。当使用 originate 呼叫 user/alice 这个地址时，FreeSWITCH  便查找本地数据库，向 alice 的地址 sip:alice@192.168.4.4:5090 发送 INVITE  请求（实际的呼叫字符串是由用户目录中的 dial-string 参数决定的）。

### API 与 APP

在上面的例子中，originate 是一个命令（Command），它用于控制 FreeSWITCH 发起一个呼叫。FreeSWITCH  的命令不仅可以在控制台上使用，也可以在各种嵌入式脚本、Event Socket （fs_cli 就是使用了 ESL库）或 HTTP RPC  上使用，所有命令都遵循一个抽像的接口，因而这些命令又称 API Commands。

echo() 则是一个程序（Application，简称 APP），它的作用是控制一个 Channel 的一端。我们知道，一个  Channel 有两端，在上面的例子中，alice 是一端，别一端就是 echo()。电话接通后相当于 alice 在跟 echo()  这个家伙在通话。另一个常用的 APP 是 park()

```
originate user/alice &park()                                     
```

我们初始化了一个呼叫，在 alice 接电话后对端必须有一个人在跟也讲话，否则的话，一个 Channel  只有一端，那是不可思议的。而如果这时 FreeSWITCH 找不到一个合适的人跟 alice  通话，那么它可以将该电话“挂起”，park()便是执行这个功能，它相当于一个 Channel 特殊的一端。

park() 的用户体验不好，alice 不知道要等多长时间才有人接电话，由于她听不到任何声音，实际上她在奇怪电话到底有没有接通。相对而言，另一个程序 hold()则比较友好，它能在等待的同时播放保持音乐（MOH， Music on Hold）。

```
originate user/alice &hold()               
```

当然，你也可以直接播放一个特定的声音文件：

```
originate user/alice &playback(/root/welcome.wav)                                     
```

或者，直接录音：    originate user/alice &record(/root/voice_of_alice.wav)

以上的例子实际上都只是建立一个 Channel，相当于 FreeSWITCH 作为一个 UA 跟 alice 通话。它是个一条腿（one  leg，只有a-leg）的通话。在大多数情况下，FreeSWITCH 都是做为一个 B2BUA 来桥接两个 UA 进行通话话的。在 alice  接听电话以后，bridge()程序可以再启动一个 UA 呼叫 bob：

```
originate user/alice &bridge(user/bob)
```

终于，alice 和 bob 可以通话了。我们也可以用另一个方式建立他们之音的通话：

```
originate user/alice &park()
originate user/bob &park()
show channels
uuid_bridge <alice_uuid> <bob_uuid>
```

在这里，我们分别呼叫 alice 和 bob，并把他们暂时 park 到一个地方。通过命令 show channels 我们可以知道每个  Channel 的 UUID，然后使用 uuid_bridge 命令将两个 Channel  桥接起来。与上一种方式不同，上一种方式实际上是先桥接，再呼叫 bob。

上面，我们一共学习了两条命令（API），originate 和 uuid_bridge。以及几个程序（APP） -  echo、park、bridge等。细心的读者可以会发现，uuid_bridge API 和 bridge APP  有些类似，我也知道他们一个是先呼叫后桥接，另一个是先桥接后呼叫，那么，它们到底有什么本质的区别呢？

**简单来说，一个 APP 是一个程序（Application），它作为一个 Channel 一端与另一端的 UA  进行通信，相当于它工作在 Channel 内部；而一个 API 则是独立于一个 Channel 之外的，它只能通过 UUID 来控制一个  Channel（如果需要的话）。**

这就是 API 与 APP 最本质的区别。通常，我们在控制台上输入的命令都是 API；而在 dialplan 中执行的程序都是  APP（dialplan 中也能执行一些特殊的 API）。大部分公用的 API 都是在 mod_commands 模块中加载的；而 APP 则在 mod_dptools 中，因而 APP 又称为拨号计划工具（Dialplan Tools）。某些模块（如 mod_sofia）有自己的的  API 和 APP。

某些 APP 有与其对应的 API，如上述的 bridge/uuid_bridge，还有  transfer/uuid_transfer、playback/uuid_playback等。UUID 版本的 API 都是在一个  Channel 之外对 Channel 进行控制的，它们应用于不能参与到通话中却又想对正在通话的 Channel做点什么的场景中。例如  alice 和 bob 正在畅聊，有个坏蛋使用 uuid_kill 将电话切断，或使用 uuid_broadcast  给他们广播恶作剧音频，或者使用 uuid_record 把他们谈话的内容录音等。

## 命令行帮助

在本章的最后，我们来学习一个如何使用 FreeSWITCH 的命令行帮助。

使用 help 命令可以列出所有命令的帮助信息。某些命令，也有自己的帮助信息，如 sofia：

```
freeswitch@du-sevens-mac-pro.local> sofia help

USAGE:
--------------------------------------------------------------------------------
sofia help
sofia profile <profile_name> [[start|stop|restart|rescan] 
    [reloadxml]|flush_inbound_reg [<call_id>] [reboot]|[register|unregister]
....
```

其中，用尖括号（< >）括起来的表示要输入的参数，而用方括号（[ ]）括起来的则表示可选项，该参数可以有也可以没有。用竖线（|）分开的参数列表表示“或”的关系，即只能选其一。

FreeSWITCH 的命令参数没有统一的解析函数，而都是由命令本身的函数负责解析的，因而不是很规范，不同的命令可能有不同的风格。所以使用时，除使用帮助信息外，最好还是查阅一下 Wiki 上的帮助（http://wiki.freeswitch.org/wiki/Mod_commands），那里大部分命令都有相关的例子。关于 APP，则可以参考 http://wiki.freeswitch.org/wiki/Mod_dptools。本书的附录中也有相应的中文参考。

## 小结

本章介绍了如何启动与控制 FreeSWTICH，并提到了几个常用的命令。另外，本章还着重讲述了 APP 与 API 的区别，搞清楚这些概念对后面的学习是很有帮助的。





​					[![FreeSWITCH权威指南](http://www.freeswitch.org.cn/images/FSDG.jpg) 					
FreeSWITCH权威指南](http://book.dujinfang.com) 				
 				![FreeSWITCH-CN微信公众账号](http://www.freeswitch.org.cn/images/qrcode_for_FreeSWITCH-CN-wechat.jpg) 				
微信公众账号 				
FreeSWITCH-CN 			



​					[![img](http://www.freeswitch.org.cn/images/xyt-logo.png)](http://x-y-t.com) 			



​				 			 			第七章 SIP 模块 - mod_sofia

[[book](http://www.freeswitch.org.cn/tags.html#book)] 

SIP 模块是 FreeSWITCH 的主要模块，所以，值得拿出专门一章来讲解。

在前几章时里，你肯定见过几次 sofia 这个词，只是或许还不知道是什么意思。是这样的，[Sofia-SIP](http://sofia-sip.sourceforge.net/) 是由诺基亚公司开发的 SIP 协议栈，它以开源的许可证 LGPL 发布，为了避免重复发明轮子，FreeSWITCH 便直接使用了它。

在 FreeSWITCH 中，实现一些互联协议接口的模块称为 Endpoint。FreeSWITH 支持很多的 Endpoint， 如  SIP、H232等。那么实现 SIP 的模块为什么不支持叫 mod_sip呢？这是由于 FreeSWITCH 的 Endpoint  是一个抽象的概念，你可以用任何的技术来实现。实际上 mod_sofia 只是对 Sofia-SIP 库的一个粘合和封装。除 Sofia-SIP  外，还有很多开源的 SIP 协议栈，如 pjsip、osip 等。最初选型的时候，FreeSWITCH 的开发团队也对比过许多不同的 SIP  协议栈，最终选用了 Sofia-SIP。FreeSWITCH 是一个高度模块化的结构，如果你不喜欢，可以自己实现 mod_pjsip 或  mod_osip 等，它们是互不影响的。这也正是 FreeSWITCH 架构设计的精巧之处。

Sofia-SIP 遵循 RFC3261 标准，因而 FreeSWITCH 也是。

## 配置文件

Sofia 的配置文件是 conf/autoload_configs/sofia.conf.xml，不过，你一般不用直接修改它，因为它实际上直接使用一条预处理指令装入了 conf/sip_profiles/ 目录中的 XML 文件：

```
    <X-PRE-PROCESS cmd="include" data="../sip_profiles/*.xml"/>
```

所以，从现在起，可以认为所有的 Sofia 配置文件都在 conf/sip_profiles/ 中。

Sofia 支持多个 profile，而一个 profile 相当于一个 SIP UA，在启动后它会监听一个 “IP地址:端口”  对。读到这里细心的读者或许会发现我们前面的一个错误。我们在讲 B2BUA 的概念时，实际上只用到了一个 profile，也就是一个  UA，但我们还是说 FreeSWITCH 启动了两个 UA（一对背靠背的 UA）来为 alice 和 bob  服务。是的，从物理上来讲，它确实只是一个 UA，但由于它同时支持多个 Session，在逻辑上就是相当于两个  UA，为了不使用读者太纠结于这种概念问题中，我在前面没有太多的分析。但到了本章，你应该非常清楚 UA 的含义了。

FreeSWITCH 默认的配置带了三个 profile（也就是三个 UA），在这里，我们不讨论 IPv6，因此只剩下 internal 和 external 两个。 internal 和 external 的区别就是一个运行在 5060 端口上，另一个是在 5080  端口上。当然，还有其它区别，我们慢慢讲。

### internal.xml

internel.xml 定义了一个 profile，在本节，我们以系统默认的配置逐行来解释：

```
<profile name="internal">
```

profile 的名字就叫 internal，这个名字本身并没有特殊的意义，也不需要与文件名相同，你可以改成任何你喜欢的名字，只是需要记住它，因为很多地方要使用这个名字。

```
  <aliases>
    <!--   <alias name="default"/>  -->
  </aliases>
```

如果你喜欢，可以为该 profile 起一个别名。注意默认是加了注释的，也就是说不起作用。再说一遍，“\<!--  -->”在 XML 中的含义是注释。

```
  <gateways>
    <X-PRE-PROCESS cmd="include" data="internal/*.xml"/>
  </gateways>
```

即然 profile 是一个 UA，它就可以注册到别的 SIP 服务器上去，它要注册的 SIP 服务器就称为 Gateway。我们一般不在 internal 这个 profile 上使用 Gateway，这个留到 external 时再讲。

```
  <domains>
    <!--<domain name="$${domain}" parse="true"/>-->
    <domain name="all" alias="true" parse="false"/> 
  </domains>
```

定义该 profile 所属的 domain。它可以是 IP 地址，或一个 DNS 域名。需要注意，直接在 hosts 文件中设置的 IP-域名可能不好用。

```
  <settings>
```

settings 部分设置 profile 的参数。

```
    <!--<param name="media-option" value="resume-media-on-hold"/> -->
```

如果 FreeSWITCH 是没有媒体（no media）的，那么如果设置了该参数，当你在话机上按下 hold 键时，FreeSWITCH 将会回到有媒体的状态。

那么什么叫有媒体无媒体呢？如下图，bob 和 alice 通过 FreeSWITCH 使用 SIP  接通了电话，他们谈话的语音（或视频）数据要通过 RTP 包传送的。RTP 可以 像 SIP 一样经过 FreeSWITCH 转发，但是，RTP  占用很大的带宽，如果 FreeSWITCH 不需要“偷听”他们谈话的话，为了节省带宽，完全可以让 RTP 直接在两者间传送，这种情况对  FreeSWITCH 来讲就是没有 media 的，在 FreeSWITCH 中也称 bypass media（绕过媒体）。

```
                FreeSWITCH
          SIP /            \ SIP
            /                \
        bob  ------RTP------  alice
```

.        

Attended Transfer 称为出席转移，它需要 media 才能完成工作。但如果在执行 att-xfer 之前没有媒体，该参数能让 att-xfer 执行时有 media，转移结束后再回到 bypass media 状态。

```
    <!-- <param name="user-agent-string" value="FreeSWITCH Rocks!"/> -->
```

不用解释，就是设置 SIP 消息中显示的 User-Agent 字段。

```
    <param name="debug" value="0"/>
```

debug 级别。

```
    <!-- <param name="shutdown-on-fail" value="true"/> -->
```

由于各种原因（如端口被占用，IP地址错误等），都可能造成 UA 在初始化时失败，该参数在失败时会停止 FreeSWITCH。

```
    <param name="sip-trace" value="no"/>
```

是否开启 SIP 消息跟踪。另外，也可以在控制台上用以下命令开启和关闭 sip-trace：

```
sofia profile internal siptrace on
sofia profile internal siptrace off
```

.        

是否将认证错误写入日志。

```
    <param name="context" value="public"/>
```

context 是 dialplan 中的环境。在此指定来话要落到 dialplan 的哪个 context  环境中。需要指出，如果用户注册到该 profile 上（或是经过认证的用户，即本地用户），则用户目录（directory）中设置的 contex 优先级要比这里高。

```
    <param name="rfc2833-pt" value="101"/>
```

设置 SDP 中 RFC2833 的值。RFC2833 是传递 DTMF 的标准。

```
    <param name="sip-port" value="$${internal_sip_port}"/>
```

监听的 SIP 端口号，变量 internal_sip_port 在 vars.xml 中定义，默认是 5060。

```
    <param name="dialplan" value="XML"/>
```

设置对应默认的 dialplan。我们后面会专门讲 dialplan。

```
    <param name="dtmf-duration" value="2000"/>
```

设置 DTMF 的时长。

```
    <param name="inbound-codec-prefs" value="$${global_codec_prefs}"/>
```

支持的来话语音编码，用于语音编码协商。global_codec_prefs 是在 vars.xml中定义的。

```
    <param name="outbound-codec-prefs" value="$${global_codec_prefs}"/>
```

支持的去话语音编码。

```
    <param name="rtp-timer-name" value="soft"/>
```

RTP 时钟名称

```
    <param name="rtp-ip" value="$${local_ip_v4}"/>
```

RTP 的 IP 地址，仅支持 IP 地址而不支持域名。虽然 RTP 标准说应该域名，但实际情况是域名解析有时不可靠。

```
    <param name="sip-ip" value="$${local_ip_v4}"/>
```

SIP 的 IP。不支持域名。

```
    <param name="hold-music" value="$${hold_music}"/>
```

UA 进行 hold 状态时默认播放的音乐。

```
    <param name="apply-nat-acl" value="nat.auto"/>
```

使用哪个 NAT ACL。

```
    <!-- <param name="extended-info-parsing" value="true"/> -->
```

扩展 INFO 解析支持。

```
    <!--<param name="aggressive-nat-detection" value="true"/>-->
```

NAT穿越，检测 SIP 消息中的 IP 地址与实际的 IP 地址是否相符，详见 NAT穿越。

```
    <!--
    There are known issues (asserts and segfaults) when 100rel is enabled.
    It is not recommended to enable 100rel at this time.
    -->
    <!--<param name="enable-100rel" value="true"/>-->
```

该功能暂时还不推荐使用。

```
    <!--<param name="enable-compact-headers" value="true"/>-->
```

支持压缩 SIP 头。

```
    <!--<param name="enable-timer" value="false"/>-->
```

开启、关闭 SIP 时钟。

```
    <!--<param name="minimum-session-expires" value="120"/>-->
```

SIP 会话超时值，在 SIP 消息中设置 Min-SE。

```
    <param name="apply-inbound-acl" value="domains"/>
```

对来话采用哪个 ACL。详见 ACL。

```
    <param name="local-network-acl" value="localnet.auto"/>
```

默认情况下，FreeSWITCH 会自动检测本地网络，并创建一条 localnet.auto ACL 规则。

```
    <!--<param name="apply-register-acl" value="domains"/>-->
```

对注册请求采用哪个 ACL。

```
    <!--<param name="dtmf-type" value="info"/>-->
```

DTMF 收号的类型。有三种方式，info、inband、rfc2833。

- info 方式是采用 SIP 的 INFO 消息传送 DTMF 按键信息的，由于 SIP 和 RTP 是分开走的，所以，可能会造成不同步。

- inband 是在 RTP 包中象普通语音数据那样进行带内传送，由于需要对所有包进行鉴别和提取，需要占用更多的资源。

- rfc2833 也是在带内传送，但它的 RTP 包有特殊的标记，因而比 inband 方式节省资源。它是在 RFC2833 中定义的。

  ```
    <!-- 'true' means every time 'first-only' means on the first register -->
    <!--<param name="send-message-query-on-register" value="true"/>-->
  ```

如何发送请求消息。true 是每次都发送，而 first-only 只是首次注册时发送。

```
<!--<param name="caller-id-type" value="rpid|pid|none"/>-->
```

设置来电显示的类型，rpid 将会在 SIP 消息中设置 Remote-Party-ID，而 pid 则会设置 P-*-Identity，如果不需要这些，可以设置成 none。

```
    <param name="record-path" value="$${recordings_dir}"/>
```

录音文件的默认存放路径。

```
    <param name="record-template" value="${caller_id_number}.${target_domain}.${strftime(%Y-%m-%d-%H-%M-%S)}.wav"/>
```

录音文件名模板。

```
    <param name="manage-presence" value="true"/>
```

是否支持列席。

```
    <!--<param name="manage-shared-appearance" value="true"/>-->
```

是否支持 SLA - Shared Line Apperance。

```
    <!--<param name="dbname" value="share_presence"/>-->
    <!--<param name="presence-hosts" value="$${domain}"/>-->
```

这两个参数用以在多个 profile 间共享列席信息。

```
    <!-- This setting is for AAL2 bitpacking on G726 -->
    <!-- <param name="bitpacking" value="aal2"/> -->

    <!--<param name="max-proceeding" value="1000"/>-->
```

最大的开放对话（SIP Dialog）数。

```
    <!--session timers for all call to expire after the specified seconds -->
    <!--<param name="session-timeout" value="120"/>-->
```

会话超时时间。

```
    <!-- Can be 'true' or 'contact' -->
    <!--<param name="multiple-registrations" value="contact"/>-->
```

是否支持多点注册，可以是 contact 或 true。开启多点注册后多个 UA 可以注册上来，有人呼叫这些 UA 时所有 UA 都会振铃。

```
    <!--set to 'greedy' if you want your codec list to take precedence -->
    <param name="inbound-codec-negotiation" value="generous"/>
```

SDP 中的语音编协商，如果设成 greedy，则自己提供的语音编码列表会有优先权.

```
    <!-- if you want to send any special bind params of your own -->
    <!--<param name="bind-params" value="transport=udp"/>-->

    <!--<param name="unregister-on-options-fail" value="true"/>-->
```

为了 NAT 穿越或 keep alive，如果 FreeSWITCH 向其它网关注册时，可以周期性地发一些 OPTIONS 包，相当于 ping 功能。该参数说明当 ping 失败时是否自动取消注册。

```
    <param name="tls" value="$${internal_ssl_enable}"/>
```

是否支持 TLS，默认否。

```
    <!-- additional bind parameters for TLS -->
    <param name="tls-bind-params" value="transport=tls"/>
    <!-- Port to listen on for TLS requests. (5061 will be used if unspecified) -->
    <param name="tls-sip-port" value="$${internal_tls_port}"/>
    <!-- Location of the agent.pem and cafile.pem ssl certificates (needed for TLS server) -->
    <param name="tls-cert-dir" value="$${internal_ssl_dir}"/>
    <!-- TLS version ("sslv23" (default), "tlsv1"). NOTE: Phones may not work with TLSv1 -->
    <param name="tls-version" value="$${sip_tls_version}"/>
```

下面都是与 TLS 有关的参数，略。

```
    <!--<param name="rtp-autoflush-during-bridge" value="false"/>-->
```

该选项默认为 true。即在桥接电话是是否自动 flush 媒体数据（如果套接字上已有数据时，它会忽略定时器睡眠，能有效减少延迟）。

```
    <!--<param name="rtp-rewrite-timestamps" value="true"/>-->
```

是否透传 RTP 时间戳。

```
    <!--<param name="pass-rfc2833" value="true"/>-->
```

是否透传 RFC2833 DTMF 包。

```
    <!--<param name="odbc-dsn" value="dsn:user:pass"/>-->
```

使用 ODBC 数据库代替默认的 SQLite。

```
    <!--<param name="inbound-bypass-media" value="true"/>-->
```

将所有来电设置为媒体绕过。

```
    <!--<param name="inbound-proxy-media" value="true"/>-->
```

将所有来电设置为媒体透传。

```
    <!--Uncomment to let calls hit the dialplan *before* you decide if the codec is ok-->
    <!--<param name="inbound-late-negotiation" value="true"/>-->
```

对所有来电来讲，晚协商有助于在协商媒体编码之前，先前电话送到 Dialplan，因而在 Dialplan 中可以进行个性化的媒体协商。

```
    <!-- <param name="accept-blind-reg" value="true"/> -->     
```

该选项允许任何电话注册，而不检查用户和密码及其它设置。

```
    <!-- <param name="accept-blind-auth" value="true"/> -->
```

与上一条类似，该选项允许任何电话通过认证。

```
    <!-- <param name="suppress-cng" value="true"/> -->
```

抑制 CNG。

```
    <param name="nonce-ttl" value="60"/>
```

SIP 认证中 nonce 的生存时间。

```
    <!--<param name="disable-transcoding" value="true"/>-->
```

禁止译码，如果该项为 true 则在 bridge 其它电话时，只提供与 a-leg 兼容或相同的语音编码列表进行协商，以避免译码。

```
    <!--<param name="manual-redirect" value="true"/> -->     
```

允许在 Dialplan 中进行人工转向。

```
    <!--<param name="disable-transfer" value="true"/> -->
```

禁止转移。

```
    <!--<param name="disable-register" value="true"/> -->
```

禁止注册。

```
    <!-- Used for when phones respond to a challenged ACK with method INVITE in the hash -->
    <!--<param name="NDLB-broken-auth-hash" value="true"/>-->
    <!-- add a ;received="<ip>:<port>" to the contact when replying to register for nat handling -->
    <!--<param name="NDLB-received-in-nat-reg-contact" value="true"/>-->

    <param name="auth-calls" value="$${internal_auth_calls}"/>
```

是否对电话进行认证。

```
    <!-- Force the user and auth-user to match. -->


    <param name="inbound-reg-force-matching-username" value="true"/>
```

强制用户与认证用户必须相同。

```
    <param name="auth-all-packets" value="false"/>
```

在认证时，对所有 SIP 消息都进行认证，而不是仅针对 INVITE 消息。

```
    <!-- external_sip_ip
      Used as the public IP address for SDP.
      Can be an one of:
           ip address            - "12.34.56.78"
           a stun server lookup  - "stun:stun.server.com"
           a DNS name            - "host:host.server.com"
           auto                  - Use guessed ip.
           auto-nat              - Use ip learned from NAT-PMP or UPNP
       -->
    <param name="ext-rtp-ip" value="auto-nat"/>
    <param name="ext-sip-ip" value="auto-nat"/>
```

设置 NAT 环境中公网的 RTP IP。该设置会影响 SDP 中的 IP 地址。有以下几种可能：

- 一个IP 地址，如 12.34.56.78

- 一个 stun 服务器，它会使用 stun 协议获得公网 IP， 如 stun:stun.server.com

- 一个 DNS 名称，如 host:host.server.com

- auto ， 它会自动检测 IP 地址

- auto-nat，如果路由器支持 NAT-PMP 或 UPNP，则可以使用这些协议获取公网 IP。

  ```
    <param name="rtp-timeout-sec" value="300"/>
  ```

指定的时间内 RTP 没有数据传送，则挂机。

```
    <param name="rtp-hold-timeout-sec" value="1800"/>
```

RTP 处理保持状态的最大时长。

```
    <!-- <param name="vad" value="in"/> -->
    <!-- <param name="vad" value="out"/> -->
    <!-- <param name="vad" value="both"/> -->
```

语音活动状态检测，有三种可能，可设为入、出，或双向，通常来说“出”（out）是一个比较好的选择。

```
    <!--<param name="alias" value="sip:10.0.1.251:5555"/>-->
```

给本 sip profile 设置别名。

```
    <!--all inbound reg will look in this domain for the users -->
    <param name="force-register-domain" value="$${domain}"/>
    <!--force the domain in subscriptions to this value -->
    <param name="force-subscription-domain" value="$${domain}"/>
    <!--all inbound reg will stored in the db using this domain -->
    <param name="force-register-db-domain" value="$${domain}"/>
    <!--force suscription expires to a lower value than requested-->
    <!--<param name="force-subscription-expires" value="60"/>-->
```

以上选项默认是起作用的，这有助于默认的例子更好的工作。它们会在注册及订阅时在数据库中写入同样的域信息。如果你在使用一个 FreeSWITCH 支持多个域时，不要选这些选项。

```
    <!--<param name="enable-3pcc" value="true"/>-->                               
```

该选项有两个值，true 或 poxy。 true 则直接接受 3pcc 来电；如果选 proxy，则会一直等待电话应答后才回送接受。

```
    <!-- use at your own risk or if you know what this does.-->
    <!--<param name="NDLB-force-rport" value="true"/>-->
```

在 NAT 时强制 rport。除非你很了解该参数，否则后果自负。

```
    <param name="challenge-realm" value="auto_from"/>
```

设置 SIP Challenge 是使用的 realm 字段是从哪个域获取，auto_from 和 auto_to 分别是从 from 和 to 中获取，除了这两者，也可以是任意的值，如 freeswitch.org.cn。

```
    <!--<param name="disable-rtp-auto-adjust" value="true"/>-->
```

大多数情况下，为了更好的穿越 NAT，FreeSWITCH 会自动调整 RTP 包的 IP 地址，但在某些情况下（尤其是在 mod_dingaling 中会有多个候选 IP），FreeSWITCH 可能会改变本来正确的 IP 地址。该参数禁用此功能。

```
    <!--<param name="inbound-use-callid-as-uuid" value="true"/>-->
```

在 FreeSWITCH 是，每一个 Channel 都有一个 UUID， 该 UUID 是由系统生成的全局唯一的。对于来话，你可以使用 SIP 中的 callid 字段来做 UUID. 在某些情况下对于信令的跟踪分析比较有用。

```
    <!--<param name="outbound-use-uuid-as-callid" value="true"/>-->
```

与上一个参数差不多，只是在去话时可以使用 UUID 作为 callid。

```
    <!--<param name="rtp-autofix-timing" value="false"/>-->
```

RTP 自动定时。如果语音质量有问题，可以尝试将该值设成 false。

```
    <!--<param name="pass-callee-id" value="false"/>-->
```

默认情况下 FreeSWITCH 会设置额外的 X- SIP 消息头，在 SIP 标准中，所有 X- 打头的消息头都是应该忽略的。但并不是所有的实现都符合标准，所以在对方的网关不支持这种 SIP 头时，该选项允许你关掉它。

```
    <!-- clear clears them all or supply the name to add or the name prefixed with ~ to remove
     valid values:

     clear
     CISCO_SKIP_MARK_BIT_2833
     SONUS_SEND_INVALID_TIMESTAMP_2833

    -->
    <!--<param name="auto-rtp-bugs" data="clear"/>-->
```

某些运营商的设备不符合标准。为了最大限度的支持这些设备，FreeSWITCH 在这方面进行了妥协。使用该参数时要小心。

```
     <!-- the following can be used as workaround with bogus SRV/NAPTR records -->
     <!--<param name="disable-srv" value="false" />-->
     <!--<param name="disable-naptr" value="false" />-->
```

这两个参数可以规避 DNS 中某些错误的 SRV 或 NAPTR 记录。

最后的这几个参数允许根据需要调整 sofia 库中底层的时钟，一般情况下不需要改动。

```
    <!-- The following can be used to fine-tune timers within sofia's transport layer 
         Those settings are for advanced users and can safely be left as-is -->

    <!-- Initial retransmission interval (in milliseconds).
        Set the T1 retransmission interval used by the SIP transaction engine. 
        The T1 is the initial duration used by request retransmission timers A and E (UDP) as well as response retransmission timer G.   -->
    <!-- <param name="timer-T1" value="500" /> -->

    <!--  Transaction timeout (defaults to T1 * 64).
        Set the T1x64 timeout value used by the SIP transaction engine.
        The T1x64 is duration used for timers B, F, H, and J (UDP) by the SIP transaction engine. 
        The timeout value T1x64 can be adjusted separately from the initial retransmission interval T1. -->
    <!-- <param name="timer-T1X64" value="32000" /> -->


    <!-- Maximum retransmission interval (in milliseconds).
        Set the maximum retransmission interval used by the SIP transaction engine. 
        The T2 is the maximum duration used for the timers E (UDP) and G by the SIP transaction engine. 
        Note that the timer A is not capped by T2. Retransmission interval of INVITE requests grows exponentially 
        until the timer B fires.  -->
    <!-- <param name="timer-T2" value="4000" /> -->

    <!--
        Transaction lifetime (in milliseconds).
        Set the lifetime for completed transactions used by the SIP transaction engine. 
        A completed transaction is kept around for the duration of T4 in order to catch late responses. 
        The T4 is the maximum duration for the messages to stay in the network and the duration of SIP timer K. -->
    <!-- <param name="timer-T4" value="4000" /> -->

  </settings>
</profile>
```

### external.xml

它是另一个 UA 配置文件，它默认使用端口 5080。你可以看到，大部分参数都与 internal.xml 相同。最大的不同是  auth-calls 参数。在 internal.xml 中，auth-calls 默认是 true；而在 external.xml 中，默认是 false。也就是说，发往 5060 端口的 SIP 消息（一般只有 INVITE 消息）需要认证，而发往 5080  的消息则不需要认证。我们一般把本地用户都注册到 5060 上，所以，它们打电话时要经过认证，保证只有在们用户 directory  中配置的用户能打电话。而 5080 则不同，任何人均可以向该端口发送 SIP 请求。

TODO.

### gateway

TODO.

## NAT 问题

TODO.				 			 			

# 认识拨号计划 - Dialplan

[[book](http://www.freeswitch.org.cn/tags.html#book)] 

拨号计划是 FreeSWITCH 中至关重要的一部分。它的主要作用就是对电话进行路由（从这一点上来说，相当于一个路由表）。说的简明一点，就是当一个用户拨号时，对用户所拨的号码进行分析，进而决定下一步该做什么。当然，实际上，它所能做的比你想象的要强大的多。

我们在第二章中已经提到过修改过拨号计划，单从配置文件看，还算比较简单直观。实际上，它的概念也不是很复杂。如果你理解正则表达式，那你应该能看懂系统自带的大部分的配置。但是，在实际应用中，有许多问题还是常常令初学者感到疑惑。主要的问题是，要理解 Dialplan，还需要了解 FS 是怎样工作的（第五章），API 与 APP 的区别等。

通过本章，我们除了要了解 Dialplan 的基本概念和运作方式，还要以理论与实践相结合的方式来进行学习，使用初学者能快速上手，有经验的人也能学到新的维护和调试技巧。

## XML Dialplan

Dialplan 是 FreeSWITCH 中一个抽象的部分，它可以支持多种不同的格式，如类似 Asterisk 的格式（由 mod_dialplan_asterisk提供）。但在实际使用中，用的最多的还是 XML 格式。下面，我们就先讨论这种格式。

### 配置文件的结构

拨号计划的配置文件在 conf/dialplan 中，在前面的章节中我们讲过，它们是在 freeswitch.xml 中，由以下装入的。

```
<X-PRE-PROCESS cmd="include" data="dialplan/*.xml"/>
```

拨号计划由多个 Context （上下文/环境）组成。每个 Context 中有多个 Extension （分支，在简单的 PBX  中也可以认为是分机号，但很显然，Extension 涵盖的内容远比分机号多）。所以，Context 就是多个 Extension  的逻辑集合，它相当于一个分组，一个 Context 中的 Extension 与其它 Context 中的 Extension  在逻辑上是隔离的。

下面是 Dialplan 的完整结构：

```
<?xml version="1.0"?>
<document type="freeswitch/xml">
  <section name="dialplan" description="Regex/XML Dialplan">
    <context name="default">
         <extension name="Test Extension">
         </extension>
    </context>
  </section>
</document>
```

Extension 相当于路由表中的表项，其中，每一个 Extension 都有一个 name 属性。它可以是任何合法的字符串，本身对呼叫流程没有任何影响，但取一个好听的名字，有助于你在查看 Log 时发现它。

在 Extension 中可以对一些 condition （条件）进行判断，如果满足测试条件所指定的表达式，则执行相对应的 action （动作）。

例如，我们将下列 Extension 配置加入到 conf/dialplan/default.xml 中。并作为第一个 Extension。

```
<extension name="My Echo Test">
  <condition field="destination_number" expression="^echo|1234$">
    <action application="echo" data=""/>
  </condition>
</extension>
```

FreeSWITCH 安装时，提供了很多例子，为了避免与提供的例子冲突，强列建议在学习时把自己写的 Extension  写在最前面。当然我说的最前面并不是 default.xml 的第一行，而是放到第一个 Extension  的位置，就是以下语句的后面（你通常能在第13-14行找到它们）：

```
<include>
  <context name="default">
```

用你喜欢的编译器编辑好并存盘后，在 FreeSWITCH 命令行上（Console 或 fs_cli）执行 reloadxml 或按  F6键，使 FreeSWITCH 重新读入你修改过的配置文件。并按 F8 键将 log 级别设置为  DEBUG，以看到详细日志.然后，将软电话注册上，并拨叫 1234 或 echo  （大部分软电话都能呼叫字母，如Zoiper，X-lite可以使用空格键切换数字和字母）。

你将会看到很多 Log, 注意如下的行：

```
Processing Seven <1000>->1234 in context default
parsing [default->My Echo Test] continue=false
Regex (PASS) [Echo Test] destination_number(1234) =~ /^echo|1234$/ break=on-false
Action echo()
```

在我的终端上，上面的第一行是以绿色显示的。当然，为了排版方便，我省去了 Log 中的日期以及其它不关键的一些信息。

第一行，Processing 说明是在处理 Dialplan，**Seven** 是我的的 SIP 名字，**1000** 是我的分机号， **1234** 是我所拨叫的号码，这里，我直接拨叫了 1234。它完整意思是说，呼叫已经达到路由阶段，要从 XML Dialplan 中查找路由，该呼叫来自 Seven，分机号是1000，它所呼叫的被叫号码是 1234 （或 echo，如果你拨叫 echo 的话）。

第二行，呼叫进入 parsing (解析XML) 阶段，它首先找到 XML 中的一个 Context，这里是 **default**（它是在 user directory 中定义的，看第五章。user directory 中有一项  ， 说明，如果 1000 这个用户发起呼叫，则它的 context 就是 default，所以要从 XML Dialplan 中的 default 这个 Context 查起）。它首先找到的第一个 Extension 的 name 是 **My Echo Test**（还记得吧？我们我们把它放到了 Dialplan 的最前面）。continue=false 的意思我们后面再讲。

第三行，由于该 Extension 中有一个 Condition，它的测试条件是 **destination_number**，也就是被叫号码，所以， FreeSWITCH 测试被叫号码（这里是 1234）是否与配置文件中的正则表达式相匹配。 **^echo|1234$** 是正则表达式，它匹配 echo 或 1234。所以这里匹配成功，Log 中显示 Regex (PASS)。 当然既然匹配成功了，它就开始执行动作 echo（它是一个 APP），所以你就听到了自己的声音。

这是最简单的路由查找。前面我已经说了，系统自带了一些 Dialplan 的例子，也许在第二章你已经测试过了。下面，我们试一下系统自带的 echo 的例子。这次，我呼叫的是 9196。在 Log 中，还是从绿色的行开始看：

```
Processing Seven <1000>->9196 in context default
parsing [default->My Echo Test] continue=false
Regex (FAIL) [Echo Test] destination_number(9196) =~ /^echo|1234$/ break=on-false
parsing [default->unloop] continue=false
Regex (PASS) [unloop] ${unroll_loops}(true) =~ /^true$/ break=on-false
Regex (FAIL) [unloop] ${sip_looped_call}() =~ /^true$/ break=on-false
parsing [default->tod_example] continue=true
Date/Time Match (FAIL) [tod_example] break=on-false
parsing [default->holiday_example] continue=true
Date/Time Match (FAIL) [holiday_example] break=on-false
parsing [default->global-intercept] continue=false
Regex (FAIL) [global-intercept] destination_number(9196) =~ /^886$/ break=on-false
parsing [default->group-intercept] continue=false
Regex (FAIL) [group-intercept] destination_number(9196) =~ /^\*8$/ break=on-false
parsing [default->intercept-ext] continue=false
Regex (FAIL) [intercept-ext] destination_number(9196) =~ /^\*\*(\d+)$/ break=on-false
parsing [default->redial] continue=false
Regex (FAIL) [redial] destination_number(9196) =~ /^(redial|870)$/ break=on-false
parsing [default->global] continue=true
Regex (FAIL) [global] ${call_debug}(false) =~ /^true$/ break=never

[][][][][][] 此处省略五百字...

parsing [default->fax_receive] continue=false
Regex (FAIL) [fax_receive] destination_number(9196) =~ /^9178$/ break=on-false
parsing [default->fax_transmit] continue=false
Regex (FAIL) [fax_transmit] destination_number(9196) =~ /^9179$/ break=on-false
parsing [default->ringback_180] continue=false
Regex (FAIL) [ringback_180] destination_number(9196) =~ /^9180$/ break=on-false
parsing [default->ringback_183_uk_ring] continue=false
Regex (FAIL) [ringback_183_uk_ring] destination_number(9196) =~ /^9181$/ break=on-false
parsing [default->ringback_183_music_ring] continue=false
Regex (FAIL) [ringback_183_music_ring] destination_number(9196) =~ /^9182$/ break=on-false
parsing [default->ringback_post_answer_uk_ring] continue=false
Regex (FAIL) [ringback_post_answer_uk_ring] destination_number(9196) =~ /^9183$/ break=on-false
parsing [default->ringback_post_answer_music] continue=false
Regex (FAIL) [ringback_post_answer_music] destination_number(9196) =~ /^9184$/ break=on-false
parsing [default->ClueCon] continue=false
Regex (FAIL) [ClueCon] destination_number(9196) =~ /^9191$/ break=on-false
parsing [default->show_info] continue=false
Regex (FAIL) [show_info] destination_number(9196) =~ /^9192$/ break=on-false
parsing [default->video_record] continue=false
Regex (FAIL) [video_record] destination_number(9196) =~ /^9193$/ break=on-false
parsing [default->video_playback] continue=false
Regex (FAIL) [video_playback] destination_number(9196) =~ /^9194$/ break=on-false
parsing [default->delay_echo] continue=false
Regex (FAIL) [delay_echo] destination_number(9196) =~ /^9195$/ break=on-false
parsing [default->echo] continue=false
Regex (PASS) [echo] destination_number(9196) =~ /^9196$/ break=on-false
Action answer() 
Action echo()
```

你可以看到，前面的正则表达式匹配都没有成功（Regex (FAIL)），只是到最后匹配到 ^9196$才成功（你看到 Regex (PASS)了），成功后先应答（answer），然后执行 echo。

在这一节里，我们花了很多篇幅来讲解如此简单的问题。但实际上，我是想让你知道，这一节最重要的不是讲 Dialplan，而是告诉你如何看  Log。在邮件列表上，大多数新手遇到的问题都可以很轻松的从 Log  中看出来，但他们不知道怎么看，或者是看了也不理解。所以，在这里，我想请你再看一下我们的第一个例子。**永远记住：遇到 Dialplan 的问题，按F8打开DEBUG级别的日志，从绿色的行开始看起（当然，如果你的终端不能显示颜色，那么，从 Processing 一行看起）**。我们的第一个例子虽然只有短短的四行 Log，但是它包含了所有你需要的信息。

### 默认的配置文件结构

系统默认提供的配置文件包含三个 Context：default、features和 public，它们分别在三个 XML  文件中。default 是默认的 dialplan，一般来说注册用户都可以使用它来打电话，如拨打其它分机或外部电话等。而 public  则是接收外部呼叫，因为从外部进来的呼叫是不可信的，所以要进行更严格的控制。如，你肯定不想从外部进来的电话再通过你的网关进行国内或国际长途呼叫。

当然，这么说不是绝对的，等你熟悉了 Dialplan 的概念之后，可以发挥你的想象力进行任何有创意的配置。

其中，在 default 和 public 中，又通过 INCLUDE 预处理指令分别加入了 default/ 和 include/  目录中的所有 XML 文件。 这些目录中的文件仅包含一些额外的 Extension。由于 Dialplan  在处理是时候是顺序处理的，所以，一定要注意这些文件的装入顺序。通常，这些文件都按文件名排序，如 00_，01_等等。如果你新加入  Extension，可以在这些目录里创建文件。但要注意，这些文件的优先级比直接写在如 default.xml  中低。我前面已经说过，由于你不熟悉系统提供的默认的 Dialplan，很可能出现与系统冲突的情况。当然，你已经学会如何查看  Log，所以能很容易的找到问题所在。但在本书中，我还是坚持将新加的 Extension 加在 Dialplan 中的最前面，以便于说明问题。

实际上，由于在处理 Dialplan 时要对每一项进行正则表达式匹配，是非常影响效率的。所以，在生产环境中，往往要删除这些默认的 Dialplan，而只配置有用的部分。但我们还不能删，因为里面有好多例子我们可以学习。

### 正则表达式

Dialplan 使用 Perl 兼容的正则表达式（PCRE, Perl-compatible regular expressions）匹配。熟悉编程的同学肯定已经很熟悉它了，为了方便不熟悉的同学，在这里仅作简单介绍：

```
^1234$         ^ 匹配字符串开头，$ 匹配结尾，所以本表达式严格匹配 1234
^1234|5678$    | 是或的意思，表示匹配 1234 或 5678
^123[0-9]$     [ ] 表式匹配其中的任意一个字符，其中的 - 是省略的方式，表示 0 到 9，它等于 [0123456789]
               也就是说它会匹配 1230，1231，1232 ... 1239
^123\d$        同上，\d 等于 [0-9]
^123\d+$       + 号表示1个或多个它前面的字符，因为 + 前面是 \d，所以它就等于1个或多个数字，实际上，
               它匹配任何以123开头的至少4位数的数字串，如1230，12300，12311，123456789等
^123\d*$       *号与+号的不同在于，它匹配0个或多个前面的字符。
               所以，它匹配以123开头的至少3位数的数字串，如 123，123789
^123           跟上面一样，由于没有结尾的$，它匹配任何以123开头的数字串，但除此之外，它还匹配后面是字母的情况，如 123abc
123$           匹配任何以123结尾的字符串
^123\d{5}$     {5}表示精确匹配5位，包含它前面的一个字符。在这里，它匹配以123开头的所有8位的电话号码
^123(\d+)$     ( )在匹配中不起作用，跟^123\d+是相同的，但它对匹配结果有作用，
               匹配结果中除123之外的数字都将存储在$1这个变量中，在下一步使用
^123(\d)(\d+)$ 如果用它跟12345678匹配，则匹配成功，结果是 $1 = 4， $2 = 5678
```

简单的正则表达式比较容易理解，更深入的学习请查阅相关资料。正则表达式功能很强大，但配置不当也容易出现错误，轻者造成电话不通，重者可能会造成误拨或套拨，带来经济损失。

### 信道变量 - Channel Variables

在 FreeSWITCH 中，每一次呼叫都由一条或多条“腿”(Call Leg)组成，其中的一条腿又称为一个  Channel（信道），每一个 Channel 都有好多属性，用于标识 Channel 的状态，性能等，这些属性称为 Channel  Variable（信道变量），简写为 Channel Var 或 Chan Var 或 Var。

通过使用 info 这个 APP，可以查看所有的 Channel Var。我们先修改一下 Dialplan。

```
<extension name="Show Channel Variable">
  <condition field="destination_number" expression="^1235$">
    <action application="info" data=""/>
  </condition>
</extension>
```

加入 default.xml 中，为了复习上一节的内容，我们这一次加入 My Echo Test 这一 Extension  的后面，存盘，然后在 FreeSWITCH 命令行上执行 reloadxml。从软电话上呼叫 1235，可以看到有很多  Log输出，还是从绿色的行开始看:

```
Processing Seven <1000>->1235 in context default
parsing [default->Echo Test] continue=false
Regex (FAIL) [Echo Test] destination_number(1235) =~ /^echo|1234$/ break=on-false
parsing [default->Show Channel Variable] continue=false
Regex (PASS) [Show Channel Variable] destination_number(1235) =~ /^1235$/ break=on-false
Action info() 
...
EXECUTE sofia/internal/1000@192.168.7.10 info()
2010-10-23 09:46:31.662281 [INFO] mod_dptools.c:1171 CHANNEL_DATA:
Channel-State: [CS_EXECUTE]
Channel-Call-State: [RINGING]
Channel-State-Number: [4]
Channel-Name: [sofia/internal/1000@192.168.7.10]
Unique-ID: [cfea988b-2dc4-42ec-b731-2cd7ea864fc6]
Caller-Direction: [inbound]
Caller-Username: [1000]
Caller-Dialplan: [XML]
Caller-Caller-ID-Name: [Seven]
Caller-Caller-ID-Number: [1000]
Caller-Network-Addr: [192.168.7.10]
Caller-ANI: [1000]
Caller-Destination-Number: [1235]
variable_direction: [inbound]
variable_uuid: [cfea988b-2dc4-42ec-b731-2cd7ea864fc6]
variable_sip_local_network_addr: [123.130.140.154]
variable_remote_media_ip: [123.130.140.154]
variable_remote_media_port: [8000]
variable_sip_use_codec_name: [PCMA]
variable_sip_use_codec_rate: [8000]
variable_sip_use_codec_ptime: [20]
variable_read_codec: [PCMA]
variable_read_rate: [8000]
variable_write_codec: [PCMA]
variable_write_rate: [8000]
variable_endpoint_disposition: [RECEIVED]
variable_current_application: [info]
```

为节省篇幅，我们删去了一部分。

可以看到，由于我们呼叫的是 1235，它在第三行测试 My Echo Test 的 1234 的时候失败了，接在接下来测试  1235的时候成功了，便执行相对应的 Action - info 这个APP。它的作用就是把所有 Channel Variables 都打印到  Log 中。

所有的 Channel Variable 都是可以在 Dialplan 中访问的，使用格式是 ${变量名}，如 ${destination_number}。将下列配置加入 Dialplan 中（存盘，reloadxml 不用再说了吧？）:

```
<extension name="Accessing Channel Variable">
  <condition field="destination_number" expression="^1236(\d+)$">
    <action application="log" data="INFO Hahaha, I know you called ${destination_number}"/>
    <action application="log" data="INFO The Last few digists is $1"/>
    <action application="log" data="ERR This is not actually an error, just jocking"/>
    <action application="hangup"/>
  </condition>
</extension>
```

这次我们呼叫 1236789，看看结果：

```
Processing Seven <1000>->1236789 in context default
parsing [default->Echo Test] continue=false
Regex (FAIL) [Echo Test] destination_number(1236789) =~ /^echo|1234$/ break=on-false
parsing [default->Show Channel Variable] continue=false
Regex (FAIL) [Show Channel Variable] destination_number(1236789) =~ /^1235$/ break=on-false
parsing [default->Accessing Channel Variable] continue=false
Regex (PASS) [Accessing Channel Variable] destination_number(1236789) =~ /^1236(\d+)$/ break=on-false
Action log(INFO Hahaha, I know you called ${destination_number}) 
Action log(NOTICE The Last few digists is 789) 
Action log(ERR This is not actually an error, just jocking) 
Action hangup() 

[DEBUG] switch_core_state_machine.c:157 sofia/internal/1000@192.168.7.10 Standard EXECUTE

EXECUTE sofia/internal/1000@192.168.7.10 log(INFO Hahaha, I know you called 1236789)
[INFO] mod_dptools.c:1152 Hahaha, I know you called 1236789
EXECUTE sofia/internal/1000@192.168.7.10 log(NOTICE The Last few digists is 789)
[NOTICE] mod_dptools.c:1152 The Last few digists is 789
EXECUTE sofia/internal/1000@192.168.7.10 log(ERR This is not actually an error, just jocking)
[ERR] mod_dptools.c:1152 This is not actually an error, just jocking
EXECUTE sofia/internal/1000@192.168.7.10 hangup()
```

跟前面一样，我们还是从绿色的行开始看。这一次，1236789 匹配了正则表达式 ^1236(\d+)，并将 789 存储在变量 $1  中。然后在 8-11 行看到它解析出的四个 Action（三个 log 一个 hangup）。到这里为止，Channel  的状态一直没有变，还处在路由查找的阶段。在所有 Dialplan 解析完成后，Channel 状态才进行 Standard Execute  阶段。理解这一点是非常重要的，我们后面再做详细说明，但是在这里你要记住路由查找（解析）和执行分属于不同的阶段。当 Channel  状态进入执行阶段后，它才开始依次执行所有的 Action。log() 的作用就是将信息写到 Log 中，它的第一个参数是 leglevel，就是 Log 的级别，有 INFO、Err、DEBUG等，不同的级别在彩色的终端上能以不同的颜色显示。（详细的级别请参考http://wiki.freeswitch.org/wiki/Mod_logfile#Log_Levels）。

你肯定看到彩色的 Log 了，同时也看到了用 $ 表示的 Channel Variable 被替换成了相应的值。

同时你也看到，这次实验我们特意增加了几个 Action。一个 Action 通常有两个参数，一个是 application，代表要执行的 APP，另一个是 data，就是 APP 的参数，当 APP 没有参数时，data也可能省略。

一个 Action 必须是一个合法的 XML 标签，在前面，你看到的 context，extension 等都是成对出现的，如  。但由于 Action 比较简单，一般彩用简写的形式来关闭标签，即 。注意大于号前面的“/”，如果不小漏掉，在 reloadxml 时将会出现类似“+OK [[error near line 3371]: unexpected closing tag  ]” 的错误，而实际的错误位置又通常不是出错的那一行。这是在编辑 XML  文件时经常遇到的问题，又比较难于查找。因此在修改时要多加小心，并推荐使用具有语法高亮的功能的编辑器来编辑。

读到这里，你或许还有疑问，既然我们在 info APP 的输出里没看到  destination_number这一变量，它到底是从哪里来的呢？是这样的，它在 info 中的输出是  Caller-Destination-Number，但你在引用的时候就需要使用 destination_number。还有一些变量，在 info 中的输出是 variable_xxxx，如 variable_domain_name，而实际引用时要去掉 variable_  前缀。不要紧张，这里有一份对照表： http://wiki.freeswitch.org/wiki/Channel_Variables#Info_Application_Variable_Names_.28variable_xxxx.29

### 测试条件 - Conditions

### 动作与反动作 - Action & Anti-Action

### 工作机制进阶

### 实例解析

...

以上的论述应该涵盖了 Dialplan 的所有概念，当然，要活学活用，还需要一些经验。下面，我们讲几个真实的例子。这些例子大部分来自默认的配置文件。

#### Local_Extension

我们要看的第一个例子是 Local_Extension。 FreeSWITCH 默认的配置提供了 1000 - 1019 共 20 个 SIP 账号，密码都是 1234 。

```
<extension name="Local_Extension">
    <condition field="destination_number" expression="^(10[01][0-9])$">
    //actions
    </condition>
</extension>
```

这个框架说明，用正则表达式 (10[01][0-9])$ 来匹配被叫号码，它匹配所有  1000 - 1019 这 20 个号码。

这里我们假设在 SIP 客户端上，用 1000 和 1001 分别注册到了 FreeSWITCH 上，则 1000 呼叫 1001  时，FreeSWITCH 会建立一个 Channel，该 Channel 构成一次呼叫的 a-leg（一条腿）。初始化完毕后，Channel  进入 ROUTING 状态，即进入 Dialplan。由于被叫号码 1001 与这里的正则表达式匹配，所以，会执行下面这些  Action。另外，由于我们在正则表达式中使用了 “( )”，因此，匹配结果会放入变量 $1 中，因此，在这里，$1 = 1001。

```
<action application="set" data="dialed_extension=$1"/>
<action application="export" data="dialed_extension=$1"/>
```

set 和 export 都是设置一个变量，该变量的名字是 dialed_extension，值是 1001。

关于 set 和 export 的区别我们在前面已经讲过了。这里再重复一次： set 是将变量设置到当前的 Channel 上，即  a-leg。而 export 则也将变量设置到 b-leg 上。当然，这里 b-leg 还不存在。所以在这里它对该 Channel 的影响与  set 其实是一样的。因此，使用 set 完全是多余的。但是除此之外，export 还设置了一个特殊的变量，叫  export_vars，它的值是dialed_extension。所以，实际上。上面的第二行就等价于下面的两行：

```
<action application="set" data="dialed_extension=$1"/>
<action application="set" data="export_vars=dialed_extension"/>


<!-- bind_meta_app can have these args <key> [a|b|ab] [a|b|o|s] <app> -->
<action application="bind_meta_app" data="1 b s execute_extension::dx XML features"/>
<action application="bind_meta_app" data="2 b s record_session::$${recordings_dir}/${caller_id_number}.${strftime(%Y-%m-%d-%H-%M-%S)}.wav"/>
<action application="bind_meta_app" data="3 b s execute_extension::cf XML features"/>
<action application="bind_meta_app" data="4 b s execute_extension::att_xfer XML features"/>
```

bind_meta_app 的作用是在该 Channel 是绑定 DTMF。上面四行分别绑定了 1、2、3、4 四个按键，它们都绑定到了 b-leg上。注意，这时候 b-leg 还不存在。所以，请记住这里，我们下面再讲。

```
<action application="set" data="ringback=${us-ring}"/>
```

设置回铃音是美音（不同国家的回铃音是有区别的），${us-ring} 的值是在 vars.xml 中设置的。

```
<action application="set" data="transfer_ringback=$${hold_music}"/>
```

设置呼叫转移时，用户听到的回铃音。

```
<action application="set" data="call_timeout=30"/>
```

设置呼叫超时。

```
<action application="set" data="hangup_after_bridge=true"/>
<!--<action application="set" data="continue_on_fail=NORMAL_TEMPORARY_FAILURE,USER_BUSY,NO_ANSWER,TIMEOUT,NO_ROUTE_DESTINATION"/> -->
<action application="set" data="continue_on_fail=true"/>

这些变量影响呼叫流程，详细说明见下面的 bridge。

<action application="hash" data="insert/${domain_name}-call_return/${dialed_extension}/${caller_id_number}"/>
<action application="hash" data="insert/${domain_name}-last_dial_ext/${dialed_extension}/${uuid}"/>
<action application="hash" data="insert/${domain_name}-last_dial_ext/${called_party_callgroup}/${uuid}"/>
<action application="hash" data="insert/${domain_name}-last_dial_ext/global/${uuid}"/>
```

hash 是内存中的哈希表数据结构。它可以设置一个键-值对（Key-Value pair）。如，上面最后一行上向  ${domain_name}-last_dial_ext 这个哈希表中插入 global 这么一个键，它的值是 ${uuid}，就是本  Channel 的唯一标志。

不管是上面的 set， 还是 hash，都是保存一些数据为后面做准备的。

```
<action application="set" data="called_party_callgroup=${user_data(${dialed_extension}@${domain_name} var callgroup)}"/>
<!--<action application="export" data="nolocal:sip_secure_media=${user_data(${dialed_extension}@${domain_name} var sip_secure_media)}"/>-->
```

这一行默认是注释掉的，因此不起作用。 nolocal 的作用我们已前也讲到过，它告诉 export 只将该变量设置到 b-leg 上，而不要设置到 a-leg 上。

```
<action application="hash" data="insert/${domain_name}-last_dial/${called_party_callgroup}/${uuid}"/>
```

还是 hash.

```
<action application="bridge" data="{sip_invite_domain=$${domain}}user/${dialed_extension}@${domain_name}"/>
```

bridge 是最关键的部分。其实上面除 bridge 以外的 action 都可以省略，只是会少一些功能。

回忆一下第四章中的内容。用户 1000 其实是一个 SIP UA（UAC），它向 FreeSWITCH（作为UAS） 发送一个  INVITE 请求。然后 FreeSWITCH 建立一个 Channel，从 INVITE  请求中找到被叫号码（destination_number=1001），然后在 Dialplan 中查找 1001 就一直走到这里。

bridge 的作用就是把 FreeSWITCH 作为一个 SIP UAC，再向 1001 这个 SIP UA（UAS）发起一个  INVITE 请求，并建立一个 Channel。这就是我们的 b-leg。1001 开始振铃，bridge 把回铃音传回到  1000，因此，1000 就能听到回铃音（如果 1001 有自己的回铃音，则 1000 能听到，否则，将会听到默认的回铃音  ${us-ring}）。

当然，实际的情况比我们所说的要复杂，因为在呼叫之前。FreeSWITCH 首先要查找 1001 这个用户是否已经注册，否则，会直接返回 USER_NOT_REGISTERED，而不会建立 b-leg。

bridge 的参数是一个标准的呼叫字符串（Dial string），以前我们也讲到过。domain 和 domain_name  都是预设的变量，默认就是服务器的 IP 地址。user 是一个特殊的 endpoint，它指本地用户。所以，呼叫字符串翻译出来就是（假设 IP 是 192.168.7.2）：

```
{sip_invite_domain=192.168.7.2}user/1001@192.168.7.2
```

其中，“{ }”里是设置变量，由于 bridge 在这里要建立 b-leg，因此，这些变量只会建立在 b-leg 上。与 set 是不一样的。但它等价于下面的 export ：

```
<action application="export" value="nolocal:sip_invite_domain=192.168.7.2"/>
<action application="bridge" value="user/1001@192.168.7.2"/>
```

好了，到此为止电话路由基本上就完成了，我们已经建立了 1000 到 1001 之间的呼叫，就等 1001 接电话了。接下来会有几种情况：

- 被叫应答
- 被叫忙
- 被叫无应答
- 被叫拒绝
- 其它情况 ...

我们先来看一下被叫应答的情况。1001 接电话，与 1000 畅聊。在这个时候 bridge 是阻塞的，也就是说，bridge 这个  APP 会一直等待两者挂机（或者其它错误）后才返回，才有可能继续执行下面的 Action。好吧，让我们休息一下，等他们两个聊完吧。

最后，无论哪一方挂机，bridge 就算结束了。如果 1000 先挂机，则 FreeSWITCH 会将挂机原因发送给 1001，一般是  NORMAL_RELEASE（正常释放）。同时 Dialplan 就再也没有往下执行的必要的，因此会发送计费信息，并销售 a-leg 。

如果 1001 先挂机，b-leg 就这样消失了。但 a-leg 依然存在，所以还有戏看。

b-leg 会将挂机原因传到 a-leg。在 a-leg 决定是否继续往下执行之前，会检查一些变量。其中，我们在前面设置了  hangup_after_bridge=true。它的意思是，如果 bridge 正常完成后，就挂机。因此，a-leg  到这里就释放了，它的挂机原因是参考 b-leg 得出的。

但由于种种原因 1001 可能没接电话。1001 可能会拒接（CAlL_REJECTED，但多数 SIP UA都会在用户拒接时返回  USER_BUSY）、忙（USER__BUSY）、无应答（NO_ANSWER 或  NO_USER_RESPONSE）等。出现这些情况时，FreeSWITCH 认为这是不成功的 bridge，因此  hangup_after_bridge 变量就不管用了。这时候它会检查另一个变量 continue_on_fail。由于我们上面设置的  continue_on_fail=true，因此在 bridge 失败（fail）后会继续执行下面的 Action。

这里值得说明的是，通过给 continue_on_fail 不同的值，可以决定在什么情况下继续。如：

```
<action application="set" data="continue_on_fail=USER_BUSY,NO_ANSWER"/>
```

将只在用户忙和无应答的情况下继续。其它的值有：NORMAL_TEMPORARY_FAILURE（临时故障）、TIMEOUT（超时，一般时SIP超时）、NO_ROUTE_DESTINATION（没有路由）等。

```
<action application="answer"/>
```

最后，无论什么原因导致 bridge 失败（我们没法联系上 1001），我们都决定继续执行. 首先 FreeSWITCH 给 1000 回送应答消息。这时非常重要的。

```
<action application="sleep" data="1000"/>
<action application="voicemail" data="default ${domain_name} ${dialed_extension}"/>
```

接下来，暂停一秒，并转到 1001 的语音信箱。语音信箱的知识等我们以后再讲。另外，默认配置中使用的是 loopback endpoint 转到 voicemail，为了方便说明，我直接改成了 voicemail。

#### 回声

没什么好解释的，如果拨 9196，就能听到自己的回声

```
<extension name="echo">
    <condition field="destination_number" expression="^9196$">
        <action application="answer"/>
        <action application="echo"/>
    </condition>
</extension>
```

#### 延迟回声

与 echo 基本一样，但回声会有一定延迟，5000 是毫秒数。

```
<extension name="delay_echo">
    <condition field="destination_number" expression="^9195$">
        <action application="answer"/>
        <action application="delay_echo" data="5000"/>
    </condition>
</extension>
```

## 内连拨号计划 - Inline Dialplan

首先，Inline dialplan 与上面我们讲的 Action 中的 inline 参数是不同的。

XML Dialplan 支持非常丰富的功能，但在测试或编写程序时，我们经常用到一些临时的，或者是很简单的  Dialplan，如果每次都需要修改 XML，不仅麻烦，而且执行效率也会有所折扣。所以，我们需要一种短小、轻便的 Dialplan  以便更高效地完成任务。而且，通过使用 Inline dialplan，也可以很方便的在脚本中生成动态的 Dialplan 而无需使用复杂的  reloadxml 以及 mod_xml_curl 技术等。

（略）

# 嵌入式脚本

[[book](http://www.freeswitch.org.cn/tags.html#book)] 

前面已经说了，FreeSWITCH  支持使用你喜欢的各种程序语言来控制呼叫流程。你不仅可以用它们写出灵活多样的IVR，给用户带来更好的体验，更重要的是你可以通过它们很好地与你的业务进行无缝集成，以节省你的后台业务处理及管理成本。

使用程序语言来做这些事情有两种方式：第一种是嵌入式脚本，第二种是独立的程序。如果使用后者，理论上讲，你可以使用任何你喜欢的语言，只要该语言支持 TCP Socket。关于使用  Socket 方式来控制 FreeSWITCH 的编程方法我们将在下一章讲解。本章主要关注嵌入式脚本。

## 什么是嵌入式脚本？

其实前面我们学到的 XML dialplan 已经体现了其非凡的配置能力，它配合 FreeSWITCH  提供的各种 App  也可以认为是一种脚本。当然，毕竟 XML 是一种描述语言，功能还有限。FreeSWITCH  通过嵌入其它语言的解析器支持很多流行的编程语言。

一般来说，编程语言分为两种：编译型语言（如C）和解释型语言（如 javascript，perl 等）。使用解释型语言编写出来的脚本不需要编译，因而非常灵活方便。典型地，FreeSWITCH 支持的语言有：

- Lua
- Javascript
- Python
- Perl
- Java

其它脚本语言如 Php, Ruby 以前是支持的，由于它们有内存及性能问题，且没有志愿者维护，现在已经被列为 [Unsupported](http://fisheye.freeswitch.org/browse/Unsupported) 了。

## 应用场景

一般来说，这些嵌入式脚本主要用于写 IVR，即主要用来控制一路通话的呼叫流程。虽然它们也可以控制多路通话（在后面我们也会讲到这样的例子，但这不是他们擅长的功能。

当然，这里说的一路通话不是说它们只能控制唯一一路通话。以 Lua 为例，你可以把呼叫路由到一个 lua  脚本，当有电话进来时，FreeSWITCH 会为每一路通话启动一个线程，控制每一路通话的 lua 脚本则在相应的线程内执行，互不干扰。Java  语言需要 Java 的虚拟机环境，比这个要复杂些。

## Lua

这是一门小众语言，听起来，它可能不像其它语言（如  Java）那样“如雷贯耳”，但由于其优雅的语法及小巧的身段受到很多开发者的青睐，尤其是在游戏领域（我相信有很多人知道它是缘于2010年一则新闻中说一个14岁的少年用它编出了 iPhone 上的名为 Bubble Ball 的游戏，该游戏下载量曾一度超过史上最流行的“愤怒的小鸟”）。

在 FreeSWITCH  中，[Lua 模块](http://wiki.freeswitch.org/wiki/Mod_lua)是默认加载的。在所有嵌入式脚本语言中，它是最值得推荐的语言。首先它非常轻量级，mod_lua.so 经过减肥(strip)后只有272K；另外，它的语法也是相的的简单。有人做过对比说，在嵌入式的脚本语言里，如果 Python 得 2  分，Perl 拿 4，Javascript 得 5, 则  Lua 语言可得 10 分。可见一斑。

另外， Lua  模块的文档也是最全的。写其它语言的程序好多时候都需要参照 Lua 模块的文档。

### 语法简介

[Lua](http://www.lua.org) 语言的注释为 “--” 开头（单行），或 “--[[ ]]”（多行）。

Lua 变量不需要类型声明

Lua 支持类似面向对象的编程，所有对象都是一个 Table(Lua 中独有的概念)。

Lua 支持尾递归、闭包。

详细的资料请参阅有关资料，底线是 -- 如果你会其它编程语言，在 30 分钟内就能学会它。

### 将电话路由到 Lua 脚本

在 dialplan XML 中，使用

```
 <action application="lua" data="test.lua"/>
```

便可将进入 dialplan 的电话交给 lua 脚本接管。脚本的默认路径是安装路径的  scripts/  目录下，当然你也可以指定绝对路径，如 /tmp/test.lua。需要注意在 windows 下目录分隔符是用 "\"  ，所以有时候需要两个，如“c:\test\test.lua”。

### Session 相关函数

FreeSWITCH 会自动生成一个 session 对象（实际上是一个 table），因而可以使用  Lua 面象对象的特性编程，如以下脚本放播放欢迎声音(来自 [Hello Lua](http://wiki.freeswitch.org/wiki/Mod_lua#Hello_Lua)) 。

```
 -- answer the call
 session:answer();

 -- sleep a second
 session:sleep(1000);

 -- play a file
 session:streamFile("/tmp/hello-lua.wav");

 -- hangup
 session:hangup();
```

大部分跟 session  有关的函数是跟 FreeSWITCH 中的 App 是一一对应的，如上面的 answer()、hangup() 等，特别的， streamFile() 对应 playback() App 。如果没有对应的函数，也可以通过  session:execute() 来执行相关的 App，如 session:execute("playback",  "/tmp/sound.wav") 等价于 session:streamFile("/tmp/sound.wav")。

需要注意，lua 脚本执行完毕后默认会挂断电话，所以上面的 Hello Lua 例子中不需要明确的  session:hangup()。如果想在 lua 脚本执行完毕后继续执行 dialplan 中的后续流程，则需要在脚本开始处执行

```
 session:setAutoHangup(false)
```

如下列场景，test.lua 执行完毕后（假设没有 session:hangup()，主叫也没有挂机），如果没有 setAutoHangup(false)，则后续的 playback 动作得不到执行。

```
 <extension name="eavesdrop">
      <condition field="destination_number" expression="^1234$">
           <action application="answer"/>
           <action application="lua" data="test.lua"/>
           <action application="playback" data="lua-script-complete.wav"/>
      </condition>
 </extension>
```

更多的函数可以参考相关的 wiki 文档：http://wiki.freeswitch.org/wiki/Mod_lua

### 非 Session 函数

Lua 脚本中也可以使用跟 sesion 不相关的函数，最典型的是 freeswitch.consoleLog()，用于输出日志，如：

```
 freeswitch.consoleLog("NOTICE", "Hello lua log!\n")
```

另外一个是 freeswitch.API，它允许你执行任意 API，如

```
 api = freeswitch.API(); 
 reply = api:executeString("sofia", "status");
```

### 独立的 Lua 脚本

独立的 Lua 脚本可以直接在控制台终端上(使用 luarun)执行，这种脚本大部分可用于执行一些非  Session 相关的功能，后面我们会讲到相关例子。

### 数据库

在 Lua 中，可以使用 [LuaSQL](http://www.keplerproject.org/luasql/) 连接各种关系型数据库，但据说 LuaSQL 与某些版本的数据库驱动结合有内存泄漏问题，配置起来也比较复杂。

另一种连接数据库的方式是直接使用  freeswitch.Dbh。它可以直接通过 FreeSWITCH  内部的数据库连接句柄来连接 sqlite 数据库或任何支持 ODBC 的数据库。

（略）

## Javascript

相对于 Lua来说, 大家可能对 Javascript 更熟悉一些。Javascript 是 Web 浏览器上最主流的编程语言，它最早是设计出来用于配合 HTML 渲染页面用的，近几年由于 [Node.js](http://nodejs.org) 的发展使它在服务器端的应用也已发扬光大。它遵循 [EMCAScript](http://zh.wikipedia.org/wiki/ECMAScript) 标准。

（略）

## 其它脚本语言

其它脚本语言的使用也类似，读者可参照使用。值得一提的是，FreeSWITCH 有一个 mod_managed 模块支持 Windows  .NET 架构下的语言（F#, VB.NET, C#, IronRuby, IronPython, JScript.NET），通过 mono  也可以支持其它平台（如 Linux ）。





​					[![FreeSWITCH权威指南](http://www.freeswitch.org.cn/images/FSDG.jpg) 					
FreeSWITCH权威指南](http://book.dujinfang.com) 				
 				![FreeSWITCH-CN微信公众账号](http://www.freeswitch.org.cn/images/qrcode_for_FreeSWITCH-CN-wechat.jpg) 				
微信公众账号 				
FreeSWITCH-CN 			



​					[![img](http://www.freeswitch.org.cn/images/xyt-logo.png)](http://x-y-t.com) 			



​		Event Socket

[[book](http://www.freeswitch.org.cn/tags.html#book)] 

# 第十章 Event Socket

相信好多读者都已经等待本章好久了。Event Socket 是操控 FreeSWITCH 的瑞士军刀。它可以通过 Socket  使用FreeSWITCH提供的所有 App 和 API函数。由于使用 Socket,  它几乎可以跟任何语言开发的程序通信（只要它支持Socket），也就是说，它几乎可以跟任何系统进行集成。

FreeSWITCH 使用 [swig](http://www.swig.org/)  来支持多语言。简单来讲，FreeSWITCH用C语言写了一些库函数，通过swig包装成其它语言接口。现在已知支持的语言有 C、 Perl、  Php、 Python、 Ruby、 Lua、 Java、 Tcl、以及由 managed 支持的 .Net 平台语言如 C#, VB.NET  等。

值得一提的是，Event Socket 并没有提供什么新的功能，它只是提供了一个开发接口，所有的通道处理及媒体控制还都是由 FreeSWITCH 提供的 App 和 API 来完成的。当然，读到这里没有必要失望，我这么说只是希望读者能更专注于这个**接口**的概念，以便更好地理解这里的逻辑。

## 架构

[Event Socket](http://wiki.freeswitch.org/wiki/Event_Socket) 有两种模式，内连（inbound）模式和外连（outbound）模式。注意，这里所说的内外是针对 FreeSWITCH 而言的。

#### C 客户端示例

在源代码目录 libs/esl/ 有个 test_client.c ，运行它后会使用 inbound 模式连接 FreeSWITCH。

```
int main(void)
{
        // 初始化 handle
        esl_handle_t handle = 0;

        // 连接服务器，如果成功 handle  就代表这个连接了，参数意义都很明显
        esl_connect(&handle, "localhost", 8021, NULL, "ClueCon");

        // 发送一个命令，并接收返回值
        esl_send_recv(&handle, "api status\n\n");

        // last_sr_event 应该是 last server response event，即针对上面命令的响应
        // 如果在此之前收到事件（在本例中不会，因为没有订阅），事件会存到一个队列里，不会发生竞争条件

        if (handle.last_sr_event && handle.last_sr_event->body) {
                // 打印返回结果
                printf("%s\n", handle.last_sr_event->body);
        } else {
                // 对于 api 和 bgapi 来说（上面已经将命令写死了），应该不会走到这里；
                // 但其它命令可能会到这里
                printf("%s\n", handle.last_sr_reply);
        }

        // 断开连接
        esl_disconnect(&handle);
        return 0;
}
```

#### C 服务器示例

同样的目录中有一个 testserver.c，运行于 *outbound* 模式，它是多线程的，每次有电话进来时，通过 *dialplan* 路由到 *socket*，FreeSWITCH 便向它发起一个连接

我们先从 *main()* 函数开始看。第 n 行把 log 级别开到最大，这样能看到详细的 log，包括所有协议的细节。 然后它通过 *esl_listen_threaded 启动一个 socket 监听 8084 端口。如果有连接到来时，它便回调* mycallback* 函数。		 			 			

# 用FreeSWITCH实现IVR

[[freeswitch](http://www.freeswitch.org.cn/tags.html#freeswitch)] 

IVR的全称的Interactive Voice Response，就是我们经常说的电话语音菜单。FreeSWITCH支持非常强大的语音菜单──你可以写简单的XML，或更灵活的Lua，当然还有Event Socket，Erlang Socket等等。

这里，简单介绍一下XML。其实语音菜单说来也简单，说难也难。让我们先来一个感性的认识--其实，FreeSWITCH默认的配置已包含了一个功能齐全的例子，随便拿起一个分机，拨5000，就可以听到菜单提示了，当然，默认的提示是英文的，大意是说欢迎来到FreeSWITCH，拨1进入FreeSWITCH会议；拨2进入回音（echo）程序，这时候可以听到自己的回音；拨3听等待音乐（MOH，Music on Hold），拨4会转到FreeSWITCH开发者Brian  West的SIP电话上；拨5你会听到一只尖叫的猴子；拨6进入下级菜单；拨9重听，拨1000-1019之间的号码则会转到对应分机。

## 最简单的菜单

感受这些之后，让我们先来配置一种最简单的情形。一些廉价的企业小交换机通常只能提供这点功能──“您好，欢迎致电XX公司，请直拨分机号，查号请拨0”。在此，我们假定使用FreeSWITCH的默认配置，分机号为1000-1019，前台分机号为0，拨0则转人工台，查号或转接其它分机。

系统默认的配置文件存放在/usr/local/freesiwtch/conf/autoload_configs/ivr.conf，配置文件是XML格式，菜单放到 中，而每一个

即是一个菜单。并且，每个menu应该有一个唯一的名字（name），以便在拨号计划（dialplan）中引用。



```
<configuration name="ivr.conf" description="IVR menus">
  <menus>
    <menu name="demo_ivr">
    </menu>
  </menus>
</configuration>
```

好，我们先来实现上述最简单的menu：

```
<menu name="welcome"
    greet-long="custom/welcome.wav"
    greet-short="custom/welcom_short.wav"
    invalid-sound="ivr/ivr-that_was_an_invalid_entry.wav"
    exit-sound="voicemail/vm-goodbye.wav"
    timeout="15000"
    max-failures="3"
    max-timeouts="3"
    inter-digit-timeout="2000"
    digit-len="4">

    <entry action="menu-exec-app" digits="0" param="transfer 1000 XML default"/>
    <entry action="menu-exec-app" digits="/^(10[01][0-9])$/" param="transfer $1 XML default"/> 
</menu>
```

我们指定菜单的名字是welcome，greet-long即为最开始播放的语音--“您好，欢迎致电XX公司，请直拨分机号，查号请拨0”，该语音文件默认的位置应该是/usr/local/freeswitch/sounds/，所以，您应该事先把声音文件录好，放到custom/welcome.wav（当然，你也可以使用其它路径，如/home/your_name/ivr/welcome.wav）。并且，由于PSTN交换机都是使用PCM编码，所以，welcome.wav文件的格式应为单声道，8000HZ。

如果用户长时间没有按键，刚应重新提示拨号，但重新提示应该简短，如“请直拨分机号，查号请拨0”。所以，可以录制这么一个声音文件放到custom/welcome_short.wav。

invalid-sound：如果用户按错了键，则会使用该提示。如果你安装时指定了make sounds-install，则该文件应该用默认存在的，只是它是英文的，如果你需要中文的提示，可以自己录一个放到custom中。

exit-sound：不说也知道，最后菜单退出时（一般时超时），会提示Good Bye。

timeout指定超时时间；max-failures容忍用户按键错误的次数。max-timeouts即最大超时次数。inter-digit-timeout为两次按键的最大间隔（毫秒），如用户拨分机号1001时，如果拨了10，等2秒，然后再按01，这时系统收到的号码为10，则会提示错误 invalid-sound。

digit-len说明菜单项的长度，在本例中，用户分机号为4位。

该menu中有两个选项，第一个是在用户按0时, menu-exec-app执行一个命令（参见[mod_command](http://wiki.freeswitch.org/wiki/Mod_command)），在此处它执行transfer，将来话转到分机1000。

如果来电用户知道分机号，则可以直接拨分机号，而不用经过前台转接，节约时间。在该例中，正则表达式"/^(10[01][0-9])$/" 会匹配用户输入1000-1019之间的分机。

以上菜单设定好后，需要在控制台中执行 reloadxml （或按F6）才可以配置生效。

配置完成后就可以在控制台上进行测试：

```
FS> originate user/1001 &ivr(welcome)
```

测试成功后，当然，你可能需要先把用户来话转到语音菜单。根据配置不同，用户来话的接听有多种配置方式，一般来说，来话会先到达public dialplan，所以，你可以在conf/dialplan/public.xml中加入一个extension:

```
<extension name="incoming_call">
  <condition field="destination_number" expression="^你的DID号码$">
<action application="answer" data=""/>
<action application="sleep" data="1000"/>
<action application="ivr" data="welcome"/>
  </condition>
</extension>
```

这样，如果有外部呼叫进来，就可以听到语音菜单了。

## 默认菜单简介

明白了以上简单的菜单，就很容易理解更复杂一点的配置了。系统默认提供了一个名字demo_ivr的菜单。最初的语音提示greet-long/greet-short是用phrase实现的。phrase是用XML定义的一些短语，最终也是播放声音文件，但在多语言系统中会更灵活。在此，我们不讨论phrase，你可以简单的认为它就是一个声音文件。

菜单选项大多都是根据用户按键使用menu-exec-app执行相应的命令，上面已经讲到了。menu-sub表示会执行一个下级菜单，这样，在下级菜单中（此外是demo_ivr_submenu）便可以用menu-top来返回上级菜单。

基本上就这么多。通过设置多级菜单，以及与dialplan配合，根据不同的情况进行跳转，可以实现相当复杂的一些功能。如果这些还不够，可以尝试一下更高级的LUA菜单或Event Socket。

## 调试

打开控制台或fs_cli，按F8将loglevel调到debug状态，能看到详细的执行过程。如果看到红色的（如果你的控制台不支持彩色，看ERROR的吧），可能是配置错误，不过一般会是声音文件找不到之类的，检查相应路径下是否有对应的声音文件。





​					[![FreeSWITCH权威指南](http://www.freeswitch.org.cn/images/FSDG.jpg) 					
FreeSWITCH权威指南](http://book.dujinfang.com) 				
 				![FreeSWITCH-CN微信公众账号](http://www.freeswitch.org.cn/images/qrcode_for_FreeSWITCH-CN-wechat.jpg) 				
微信公众账号 				
FreeSWITCH-CN 			



​					[![img](http://www.freeswitch.org.cn/images/xyt-logo.png)](http://x-y-t.com) 			



​				 			 			

# 一个在FreeSWITCH中外呼的Lua脚本

[[freeswitch](http://www.dujinfang.com/tags.html#freeswitch)] 

一个在FreeSWITCH中外呼的脚本

前几天，一个朋友问我能否实现在FS中外呼，然后放一段录音，我说当然能，写个简单的脚本就行。但后来他说还要知道呼叫是否成功，我说，那就需要复杂一点了。

当然，这个应用很简单，就没必要使用event_socket那些复杂的东东。写了一个Lua脚本，基本能满足要求了。

思路是将待呼号码放到一个文件(number_file_name)中，每个一行，然后用Lua依次读每一行，呼通后播放file_to_play，结果写到log_file_name中。为保证对方应该后才开始播放，需要ignore_early_media参数，否则，对方传回铃音或彩铃时播放就会开始，而那不是我们想要的。

```
prefix = "{ignore_early_media=true}sofia/gateway/cnc/"
number_file_name = "/usr/local/freeswitch/scripts/number.txt"
file_to_play = "/usr/local/freeswitch/sounds/custom/8000/sound.wav"
log_file_name = "/usr/local/freeswitch/log/dialer_log.txt"
```

简单起见，包装一个函数：

```
function debug(s)
	freeswitch.consoleLog("notice", s .. "\n")
end
```

定义呼叫函数。freeswitch.Session会呼叫一个号码，并一直等待对方应答。然后，streamFile播放一段声音，挂机。最后，函数返回挂机原因 hangup_cause。

```
function call_number(number)
	dial_string = prefix .. tostring(number);
	
	debug("calling " .. dial_string);
	session = freeswitch.Session(dial_string);

	if session:ready() then
		session:sleep(1000)
		session:streamFile(file_to_play)
		session:hangup()
	end
	-- waiting for hangup               
	while session:ready() do
		debug("waiting for hangup " .. number)
		session:sleep(1000)
	end
    
	return session:hangupCause()
end
```

实际的代码是从这里开始执行的。首先打开存放电话号码的文件（准备读），和呼叫日志（准备写，追加）。

然后是无限循环(while)，每次读取一行，当读到空行或文件尾时，退出。

`while` 循环中，读到的每一行实际上是一个号码，调用上面定义的`call_number`进行呼叫，并将呼叫结果写到`log_file`中。

```
number_file = io.open(number_file_name, "r")
log_file = io.open(log_file_name, "a+")

while true do

	line = number_file:read("*line")
	if line == "" or line == nil then break end

	hangup_cause = call_number(line)
	log_file:write(os.date("%H:%M:%S ") .. line .. " " .. hangup_cause .. "\n")
end
```

很简单，很强大，是吧？

将脚本存到scripts目录中（通常是/usr/local/freeswitch/scripts/)，起名叫dialer.lua，在FreeSWITCH控制台或fs_cli中执行：

```
luarun dialer.lua
```

完整的脚本：

- http://fisheye.freeswitch.org/browse/freeswitch-contrib.git/seven/lua/dialer.lua

另外还有一个 batch_dialer:

- http://fisheye.freeswitch.org/browse/freeswitch-contrib.git/seven/lua/batch_dialer.lua
- FreeSWITCH提供的API：http://wiki.freeswitch.org/wiki/Mod_lua
- Lua语言：http://www.lua.org/

![img](http://www.dujinfang.com/seven.jpg)

七歌
微信扫一扫

# 使用Erlang建立IVR实现复杂业务逻辑

[[ivr](http://www.freeswitch.org.cn/tags.html#ivr)] [[erlang](http://www.freeswitch.org.cn/tags.html#erlang)] 

曾写过一篇[使用XML实现IVR](http://www.freeswitch.org.cn/blog/past/2010/3/21/yong-freeswitchshi-xian-ivr/) 。但当你要实现更复杂、更智能的业务逻辑时，你免不了跟数据库或其它系统交互。我们曾用Ruby借助event_socket实现过比较复杂的功能，但当业务变得更加复杂时，我们使用Erlang重写了整个逻辑。

## 什么是 Erlang ?

[Erlang](http://www.erlang.org/)是一种函数式编程语言，它天生支持高并发，高可靠性的编程。

## 为什么使用 Erlang ?

Erlang 最初就是设计用来编写电信程序的，它具有OTP（开放电信平台）库，使用它可以很容易地实现FSM（有限状态机）。

我们的PBX服务器运行在办公室里，但当有电话进来时它需要到国外的一台服务器上取数据，并以此来选择坐席。呼叫过程中，它也需要更新远程的数据。我们使用HTTP与远程服务器交互。如此长距离的通信不仅会有很大的延时，而且经常会失败。FreeSWITCH本身有mod_http及mod_curl模块，并且其它嵌入式脚本语言也都有HTTP支持，但我们认为Erlang会更加健壮。而且，通过使用Erlang的轻量级进程，当一有电话进来时，我们可以一边启动IVR拨放欢迎词，一边spawn一个新进程到远程HTTP上取数据。当IVR运行到需要数据进行决策时，绝大多数情况下这些数据已经有了。即使获取数据失败，我们也可以以默认的方式进行路由。这样，客户就不会感觉到任何延迟。

## 实现

我们使用[mod_erlang_socket](http://wiki.freeswitch.org/wiki/Mod_erlang_event)的outbound模式。当有电话进来时，FreeSWITCH会通过dialplan立即把控制权交给Erlang。

```
<extension name="icall_fsm">
  <condition field="destination_number" expression="^fsm$">
    <action application="erlang" data="icall:fsm acd@192.168.1.27"/>
  </condition>
</extension>
```

其中，Erlang程序acd运行在节点192.168.1.27上，FreeSWITCH会使用RPC调用执行icall:fsm()并在Erlang中启动一个有限状态机，它接下来会控制呼叫流程，实现进行状态转移，直到呼叫结束。并且，在呼叫过程中我们还通过db_pbx模块与数据库及远程HTTP交互。Erlang实现的FSM代码真的非常好看。

```
-module(icall). 
-behaviour(gen_fsm).

-export([start/0, stop/0, fsm/1, init/1, welcome/2, handle_info/3, handle_event/3, terminate/3]).
-export([welcome_wait_playback/2, main_menu/2, main_menu_wait_dtmf/2, call_hst/2, call_sales/2, call_cc/2, call_extn/2, 
    call_cellphone/2, final_loop/2]).

-import(freeswitch_msg, [get_var/2, get_var/3, sendmsg/3]).

start() -> gen_fsm:start(icall_fsm, [], []). 
stop() ->  gen_fsm:send_all_state_event(self(), stop).
fsm(Ref) ->
    {ok, NewPid} = ?MODULE:start(),
    {Ref, NewPid}.


%% send a stop this will end up in "handle_event" 
% stop() -> gen_fsm:send_all_state_event(hello, stopit). 
%% -- interface end 
% This initialisation routine gets called 
init(State) -> 
    io:format("icall_fsm init ~p, PID: ~p~n", [State, self()]),
    {ok, welcome, []}. 

%% The state machine
welcome([], []) ->
    {next_state, welcome, []};
% welcome(UUID, []) ->
%   {next_state, welcome, [UUID]};
welcome({call, {event, [UUID | Data]}}, []) -> 
    CallerID = get_var("Channel-Caller-ID-Number", Data, "00000000"),
    Pid = self(),
    spawn(fun() -> fetch_cc_extn_from_crm(Pid, CallerID) end),
    io:format("New call from [~p]~n", [CallerID]),
    db_pbx:new_call(UUID, Data),
    sendmsg(UUID, playback, "new_sales/1000.wav"),
    {next_state, welcome_wait_playback, UUID}.

welcome_wait_playback({call_event, {event, [UUID | Data]} }, UUID) ->
    Name = get_var("Event-Name", Data),
    App = get_var("Application", Data),

    error_logger:info_msg("welcome_wait_playback: Pid ~p: UUID ~p, Event ~p~n",[self(), UUID, Name]),

    case Name of
        "CHANNEL_EXECUTE_COMPLETE" when App =:= "playback" ->
            NextState = route_time_condition(UUID),
            gen_fsm:send_event(self(), UUID),
            {next_state, NextState, UUID};
        _ ->
            {next_state, welcome_wait_playback, UUID}
    end.

main_menu(UUID, UUID) ->
    sendmsg(UUID, play_and_get_digits, "1 1 3 5000 # new_sales/1001.wav new_sales/9004.wav menu_number [1-5]"),
    db_pbx:log(UUID, "MainMenu", ""),
    gen_fsm:send_event(self(), {call_event, {event, [UUID]}}),
    {next_state, main_menu_wait_dtmf, UUID}.
main_menu_wait_dtmf({call_event, {event, [UUID | Data]} }, UUID) ->
    Name = get_var("Event-Name", Data),
    App = get_var("Application", Data),

    error_logger:info_msg("Pid ~p: UUID ~p, Event ~p, State: main_menu_wait_dtmf~n",[self(), UUID, Name]),

    case Name of
        "CHANNEL_EXECUTE_COMPLETE" when App =:= "play_and_get_digits" ->
            MenuNumber = get_var("variable_menu_number", Data),
            db_pbx:log(UUID, "MainMenu", MenuNumber),
            case MenuNumber of
                "1" -> 
                    gen_fsm:send_event(self(), UUID),
                    {next_state, call_hst, UUID};
                "5" -> 
                    %<min> <max> <tries> <timeout> <terminators> <file> <invalid_file> <var_name> <regexp>
                    sendmsg(UUID, play_and_get_digits, "3 3 3 5000 # new_sales/2002.wav new_sales/9004.wav extn_number [68]\\d\\d"),
                    {next_state, call_extn, no_extn};
                X when X == "2"; X == "3"; X == "4" ->
                    gen_fsm:send_event(self(), UUID),
                    {next_state, call_sales, UUID};
                _ ->
                    sendmsg(UUID, playback, "new_sales/9003.wav"),
                    timer:sleep(5000),
                    sendmsg(UUID, hangup, ""),
                    {next_state, final_loop, UUID}
            end;
        _ ->
            {next_state, main_menu_wait_dtmf, UUID}         
    end.

call_hst(UUID, UUID) ->
    transfer(UUID, "fifo_hst"),
    {next_state, final_loop, UUID}.

call_cellphone(UUID, UUID) ->
    transfer(UUID, "fifo_cellphone"),
    {next_state, final_loop, UUID}.

call_sales(UUID, UUID) ->
    case get(cc_extn) of 
        undefined ->
            transfer(UUID, "fifo_sales"),
            db_pbx:log(UUID, "SalesFifo", ""),
            {next_state, final_loop, UUID};
        Extn ->
            play_intransfer(UUID),
            sendmsg(UUID, set, "ringback=${us-ring}"),
            sendmsg(UUID, set, "continue_on_fail=true"),
            sendmsg(UUID, set, "hangup_after_bridge=true"),
            sendmsg(UUID, bridge, "user/" ++ Extn),
            db_pbx:log(UUID, "CallCC", Extn),
            {next_state, call_cc, Extn}
    end.

call_cc({call_event, {event, [UUID | Data]} }, Extn) ->
    Name = get_var("Event-Name", Data),
    App = get_var("Application", Data),

    error_logger:info_msg("Pid ~p: UUID ~p, Event ~p, Extn ~p~n",[self(), UUID, Name, Extn]),

    case Name of
        "CHANNEL_EXECUTE_COMPLETE" when App =:= "bridge" ->
            HangupCause = get_var("variable_originate_disposition", Data),
            DialedUser = get_var("variable_dialed_user", Data),
            sendmsg(UUID, play_and_get_digits, "1 1 2 5000 # new_sales/8" ++ Extn ++
                ".wav new_sales/9004.wav cc_menu_number [12]"),
            db_pbx:log(UUID, "CCFailure", HangupCause),
            {next_state, call_cc, Extn};
        "CHANNEL_EXECUTE_COMPLETE" when App =:= "play_and_get_digits" ->
            CCMenuNumber = get_var("variable_cc_menu_number", Data),
            case CCMenuNumber of
                "1" -> sendmsg(UUID, transfer, "Playcell_" ++ Extn);
                "2" -> sendmsg(UUID, transfer, "VM_" ++ Extn);
                _ -> sendmsg(UUID, transfer, "Quit")
            end,
            {next_state, final_loop, UUID};
        _ -> 
            {next_state, call_cc, Extn}
    end.

call_extn({call_event, {event, [UUID | Data]} }, no_extn) ->
    Name = get_var("Event-Name", Data),
    App = get_var("Application", Data),

    error_logger:info_msg("Pid ~p: UUID ~p, Event ~p, State: call_extn",[self(), UUID, Name]),

    case Name of
        "CHANNEL_EXECUTE_COMPLETE" when App =:= "play_and_get_digits" ->
            Extn = get_var("variable_extn_number", Data),
            db_pbx:log(UUID, "CallExtn", Extn),
            gen_fsm:send_event(self(), UUID),
            {next_state, call_extn, Extn};
        _ ->
            {next_state, call_extn, no_extn}
    end;

call_extn(UUID, Extn) ->
    io:format("Calling extn: ~p~n", [Extn]),
    % sendmsg(UUID, set, "campon=true"),
    sendmsg(UUID, set, "ringback=${us-ring}"),
    sendmsg(UUID, set, "continue_on_fail=true"),
    sendmsg(UUID, set, "hangup_after_bridge=true"),
    DialString = "user/" ++ Extn,
    sendmsg(UUID, bridge, DialString),
    {next_state, call_cc, Extn}.


final_loop({call_event, {event, [UUID | Data]} }, UUID) ->
    Name = get_var("Event-Name", Data),

    error_logger:info_msg("final_loop Pid ~p: UUID ~p, Event ~p~n",[self(), UUID, Name]),

    {next_state, final_loop, UUID};
final_loop(UUID, UUID) ->
    {next_state, final_loop, UUID}.

handle_info({cc_extn, error}, State, Data) ->
    {next_state, State, Data};
handle_info({cc_extn, Extn}, State, Data) ->
    put(cc_extn, Extn),
    io:format("Found CC Extn: ~p~n", [Extn]),
    {next_state, State, Data};
handle_info(call_hangup, State, Args) ->
    io:format("Hangup ~p ~p ~n", [State, Args]),
    {stop, normal, State};
handle_info({E, {event, [UUID | Data]}} = Event, State, StateData) ->
    Name = get_var("Event-Name", Data),
    App = list_to_atom(get_var("Application", Data, "undefined")),

    error_logger:info_msg("handle_info: ~p ~p ~p ~p~n~p~n",[self(), UUID, Name, State, StateData]),

    case Name of
        "CHANNEL_HANGUP_COMPLETE"->
            db_pbx:hangup(UUID, Data),
            % {next_state, final_loop, UUID};
            {stop, normal, UUID};
        "CUSTOM" ->
            SubClass = get_var("Event-Subclass", Data),
            Action = get_var("FIFO-Action", Data),

            io:format("Fifo: ~p ~p~n", [SubClass, Action]),

            case SubClass of
                "fifo::info" when Action =:= "bridge-caller" ->
                    db_pbx:process(UUID, Data);
                _ -> ok
            end,
            {next_state, State, StateData};
        _ ->
            List = [welcome, welcome_wait_playback, main_menu_wait_dtmf, call_cc, call_extn],
            case lists:any(fun(Elem) -> Elem =:= State end, List) of
                true ->
                    gen_fsm:send_event(self(), Event);
                _ -> ok
            end,
            {next_state, State, StateData}
    end;
handle_info(Info, State, Data) ->
    io:format("Got Other Info: ~p ~p ~p ~n", [Info, State, Data]).

handle_event(stop, _StateName, StateData) ->  
    {stop, normal, StateData}.
terminate(normal, _StateName, _StateData) ->  
    io:format("Stop with reason: normal ~p ~p~n", [_StateName, _StateData]),
    ok;
terminate(Reason, _StateName, _StateData) ->
    io:format("Stop with reason: ~p ~p ~p~n", [Reason, _StateName, _StateData]),
    ok.


%% private

route_time_condition(UUID) ->
    case db_pbx:get_time_condition("sales_icall") of
        {Action, Args} ->
            case Action of
                % "idp_acd:" ++ ErlAction ->
                %   Fun = list_to_atom(ErlAction),
                %   db_pbx:log(UUID, "TimeCondition", ErlAction ++ " " ++ Args),
                %   ?MODULE:Fun(UUID, Args);
                Action -> 
                    db_pbx:log(UUID, "TimeCondition", Action ++ " " ++ Args), 
                    sendmsg(UUID, list_to_atom(Action), Args),
                    final_loop
            end;
        _ ->
            {Date, {Hour, Min, _Sec}} = erlang:localtime(),
            Weekday = calendar:day_of_the_week(Date),
            route_work_time(UUID, Weekday, Hour, Min)
    end.    

route_work_time(UUID, Weekday, Hour, Min)
    when Weekday > 5 andalso Hour > 10 andalso (Hour < 20 orelse ( Min < 30 andalso Hour < 21) ) ->
    db_pbx:log(UUID, "Weekend", "10:00 - 20:30"),
    main_menu;
route_work_time(UUID, Weekday, Hour, Min) when Hour > 9 andalso (Hour < 20 orelse (Min < 30 andalso Hour < 21 ))->
    db_pbx:log(UUID, "Workday", "Weekend 9:00 - 20:30"),
    main_menu;
route_work_time(UUID, _Weekday, Hour, Min) when (Hour > 21 orelse (Hour > 20 andalso Min > 30)) andalso Hour < 23 ->
    db_pbx:log(UUID, "Time", "20:30 - 23:00"),
    call_hst;
route_work_time(UUID, _Weekday, _Hour, _Min) ->
    db_pbx:log(UUID, "NonWorktime", "Cellphone"),
    call_cellphone.

transfer(UUID, Dest) ->
    transfer(UUID, Dest, "XML", "new_sales").
transfer(UUID, Dest, Dialplan, Context) ->
    sendmsg(UUID, transfer, Dest ++ " " ++ Dialplan ++ " " ++ Context).

play_intransfer(UUID) ->
    sendmsg(UUID, playback, "new_sales/1002.wav"),
    timer:sleep(3000).

fetch_cc_extn_from_crm(Pid, CallerID) ->
    Extn = case helpers:http_fetch(?CRM_APP, "/voip/cdrs?caller_id=" ++ CallerID) of
        {error, _} -> error;
        Number -> Number
    end,

     Pid ! {cc_extn, Extn}.
```

## 其它讨论

1）  Erlang在这里是完全异步的。所以，当你通知FreeSWITCH执行一个application时（如playback），你必须等待收到CHANEL_EXECUTE_COMPLETE事件再进行下一步操作。这比起直接在dialplan或lua脚本中要麻烦一些，但正因为你是异步的，你可以随时终止正在执行的application。当然，如果你非要同步并且你知道某程序要执行多长时间时（如你知道要playback的声音文件的长度），你也可以用timer:sleep延时一下。

2）当我们觉得不再需要Erlang的特性时，我们会把流程转到dialplan，毕竟修改XML要容易些。

3）mod_fifo在Erlang中不能很好工作，除非你在fifo结束时将流程transfer到其它地方。因为channel在送到Erlang关是park的，而fifo中bridge到另一分机时无法解除park状态。这也是为什么我们在最后都送流程再送回dialplan。

4）代码已经很清晰了，但我想，如果有时间能现写个gen_fs_behaviour之类的东东把FreeSWITCH的事件消息包装一下会更好看。

本文也有一个英文版本：http://www.dujinfang.com/past/2010/4/22/build-a-complex-hence-powerful-freeswitch-ivr-in-erlang/

# 在FreeSWITCH中执行长期运行的嵌入式脚本–Lua语言例子

[[freeswitch](http://www.dujinfang.com/tags.html#freeswitch)] 

众所周知，FreeSWITCH中可以使用嵌入式的脚本语言javascript、lua等来控制呼叫流程。而更复杂一点操作可能就需要使用[Event Socket](http://wiki.freeswitch.org/wiki/Event_Socket)了。其实不然，嵌入式的脚本也可以一直运行，并可以监听所有的Event，就像使用Event Socket起一个单独的Daemon一样。

这里我们以lua为例来讲一下都有哪些限制以及如何解决。

首先，在控制台或fs_cli中执行一个Lua脚本有两种方式，lua和luarun。二者的不同就是lua是在当前线程中运行的，所以，它会阻塞；而luarun会spawn一个新的线程，不会阻塞当前的线程执行。

另外，你也可以写到lua.conf配置文件中，这样它就能随FreeSWITCH一起启动。

```
  
```

脚本后面可以加参数，如 luarun test.lua arg1 arg2，在脚本中，就可以通过argv[1], argv[2]来获得参数的值。而argv[0]是脚本的名字。

如果要让脚本一直运行，脚本中必须有一个无限循环。你可以这样做：

```
 while true do  -- Sleep for 500 milliseconds  freeswitch.msleep(500);  freeswitch.consoleLog("info", "blah..."); end 
```

但这样的脚本是无法终止的，由于FreeSWITCH使用swig支持这些嵌入式语言，而有些语言没有退出机制，所以，所有语言的退出机制都没有在FreeSWITCH中实现，即使unload相关的语言模块也不行，也是因为如此，为了避免产生问题，所有语言模块也都不能unload。

另外，使用freeswitch.msleep() 也不安全，Wiki上说: Do not use this on a session-based script or bad things will happen。

既然是长期运行的脚本，那，为什么为停止呢？是的，大部分时间你不需要，但，如果你想修改脚本，总不会每次都重启FreeSWITCH吧？尤其是在调试的时候。

那，还有别的办法吗？

我们可以使用事件机制构造另一个循环：

```
 con = freeswitch.EventConsumer("all");                                                                          for e in (function() return con:pop(1) end) do  freeswitch.consoleLog("info", "event\n" .. e:serialize("xml")); end 
```

上面的代码中，con被初始化成一个事件消费者。它会一直阻塞并等待FreeSWITCH发出一个事件，并打印该事件的XML表示。当然，事件总会有的。如每个电话初始化、挂机等都会有相应的事件。除此之外，FreeSWITCH内部也会毎20秒发出一个heartbeat事件，这样你就可以定时执行一些任务。

当然如果使用 con:pop(0)也可以变成无阻塞的，但你必须在循环内部执行一些sleep()以防止脚本占用太多的资源。

通过这种方法，你应该就能想到办法让脚本退出了。那就是，另外执行一个脚本触发一个custom的事件，当该脚本监测到特定的custom事件后退出。当然你也可以不退出，比方说，打印一些信息以用于调试。

我写了一个gateway_report.lua脚本。就用了这种技术。思路是：监听所有事件。如果收到hangup，则判断是通过哪个gateway出去的，并计算一些统计信息。如果需要保存这些信息，可以有以下几种方式：

1）fire_event，即触发另一个事件，这样，如果有其它程序监听，就可以收到这个事件，从而可以进行处理，如存入数据库等。

2）http_post，发一个HTTP post请求到一个HTTP server，HTTP server接收到请求后进行下一步处理。其中，http_post是无阻塞的，以提高效率，即只发请求，而不等待处理结果。

3）db，可以通过luasql直接写到数据库，未完全实现

4）当然你也可以直接通过io.open写到一个本地文件，未实现…

由于这种脚本会在FreeSWITCH内部执行，需要消耗FreeSWITCH的资源，因此，在大话务量（确切来说是“大事件量”）的情况下还是应该用Event Socket。

完整的代码在 http://svn.freeswitch.org/svn/freeswitch/trunk/seven/lua/gateway_report.lua

其它参考资料：

- FreeSWITCH提供的API：http://wiki.freeswitch.org/wiki/Mod_lua
- Lua语言：http://www.lua.org/

![img](http://www.dujinfang.com/seven.jpg)

七歌
微信扫一扫

[Seven's Blog](http://www.dujinfang.com/)

- [所有文章](http://www.dujinfang.com/posts.html)
- [所有标签](http://www.dujinfang.com/tags)
- [订阅Feed](http://www.dujinfang.com/feed.xml)
- [关于我](http://www.dujinfang.com/about.html)

# 在 FreeSWITCH 中使用 google translate 进行文本语音转换

[[freeswitch](http://www.dujinfang.com/tags.html#freeswitch)] [[tips](http://www.dujinfang.com/tags.html#tips)] 

今天，偶然发现 google translate 一个很酷的功能，TTS。

在浏览器中输入 http://translate.google.com/translate_tts?q=hello+and+welcome+to+w+w+w+dot+dujinfang+dot+com&tl=en 然后立即就可以播放声音。

又试了一下这个，呵呵 http://translate.google.com/translate_tts?q=欢迎光临七哥的博客&tl=zh ，也好用。

我在Mac上分别用 Safari, Chrome 和 FireFox 都测试通过。

那么，能不能在 FreeSWITCH 里用呢？当然，FreeSWITCH 通过 mod_shout 支持 mp3！

默认的 FreeSWITCH 中 mod_shout 是不编译的，所以需要自己编译。到源代码目录下，执行

```
make mod_shout-install
```

就装好了（当然，前提是你已经用源代码安装了 FreeSWTICH 的情况，参见  [电子书第二章](http://www.dujinfang.com/past/2010/4/14/freeswitch-chu-bu/)）。

在 FreeSWITCH 命令行上装入模块：

```
load mod_shout
```

测试一下：

```
originate user/1000 &playback(shout://translate.google.com/translate_tts?q=hello+and+welcome+to+www+dot+dujinfang+dot+com&tl=en)
```

太爽了。但中文的没有成功，不知道为什么。

当然你也可以写到 [Dialplan](http://www.freeswitch.org.cn/blog/past/2010/10/22/ren-shi-bo-hao-ji-hua-dialplan/) 中，然后呼叫 1234 试一下 :D（为了排版方便，我换行了，记着shout 那一行别断行）

```
<extension name="Free_Google_Text_To_Speech">
     <condition field="destination_number" expression="^1234$">
      <action application="answer" data=""/>
      <action application="playback"
                   data="shout://translate.google.com/translate_tts?
                   q=hello+and+welcome+to+www+dot+dujinfang+dot+com&tl=en"/>
     </condition>
</extension>
```

![img](http://www.dujinfang.com/seven.jpg)

七歌
微信扫一扫





![img](moz-extension://1155a503-0288-4264-b3d3-9db326ed66e8/assets/img/T.cb83a013.svg)



------

​			Content and Copyright(©) by Seven Du All Rights Reserved! 保留所有权利，转载请加入本站链接！

# 多台 FreeSWITCH 服务器级联

[[trunk](http://www.freeswitch.org.cn/tags.html#trunk)] 

其实，只要你吃透了前些章节的内容，做 FreeSWITCH 级联是没有任何问题的。但这个问题还常常被众网友问到，我就索性再写一篇。

## 双机级联

假设你有两台 FreeSWITCH 机器， 分别为A和B，同样IP分别为 192.168.1.A 和  192.168.1.B。每台机器均为默认配置，也就是说在每台机器上 1000 ～ 1019 这 20  个号码可以互打电话。位于同一机器上的用户称为“网内用户”，如果需要与其它机器上的用户通信，则其它机器上的用户就称为“网外用户”。

现在你需要在两台机器之间的用户互拨，因此你想了一种拨号方案。如果A1000想拨打B1000，则B1000相对于A1000来说就是“网外用户”。就一般的企业PBX而言，一般拨打外网用户就需要加一个特殊的号码，比方说“0”。这样，“0”就称为“出局字冠。

好了，我们规定，不管是A用户还是B上的用户，拨打外网用户均需要加0. 下面我们仅配置A打B，把B打A的情况留给读者练习。

在A机上，把以下 dialplan 片断加到 default.xml 中：

```
<extension name="B">
  <condition field="destination_number" expression="^0(.*)$">
    <action application="bridge" data="sofia/external/sip:$1@192.168.1.B:5080"/>
  </condition>
</extension>
```

其中，expression= 后面的正则表示式表示匹配以0开头的号码，“吃”掉0后，把剩下的号码送到B机的5080端口上。

所以，如果用户1000在A上拨 01000，将会发送 INVITE sip:1000@192.168.1.B:5080  到B上。B收到后，由于5080端口默认走public dialplan，所以查找  public.xml，找到1000后将电话最终接续到B机的1000用户。

除了SIP外，我还在两台机器上分别加了两块E1板卡，中间用交叉线直连，这样的话，我希望拨9开头就走E1到对端，设置如下：

```
<extension name="B_E1">
  <condition field="destination_number" expression="^9(.*)$">
    <action application="bridge" data="freetdm/1/a/$1"/>
  </condition>
</extension>
```

## 汇接模式

```
                             |  汇接局  X |
                            /      |       \
                           /       |        \
                         A         B         C
```

其实你搞定了第一种模式以后，这种汇接模式也就很简单了。无非你需要动一动脑子做一下拨号计划，比方说到A拨0，B拨1，到C拨2之类的。然后在汇接局配置相关的 dialplan 就OK了。

遇到 dialplan 的问题还是再看一下第八章，还是那句话，使用 F8 打开详细的 LOG，打一个电话，从绿色的行开始看。

## 安全性

上面的方法只使用5080端口从 public dialplan  做互通，而发送到5080端口的INVITE是不需要鉴权的，这意味着，你任何人均可以向它发送INVITE从而按你设定的路由规则打电话。这在第一种模式下问题可能不大，因为你的public dialplan  仅将外面的来话路由到本地用户。但在汇接局模式下，你可能将一个来话再转接到其它外部网关中去，那你就需要好好考虑一下安全问题了，因为你肯定不希望全世界的人都用你的网关打免费电话。

一般说来，解决这个问题有两种方式，那就是让所有来话都经过认证鉴权后再进行路由（本地用户发到5060端口上都是需要鉴权的）。

考虑双机级联的情况，你只需要在A上配置一个到B的网关（将下列内容存成XML文件放到 conf/sip_profiles/external/b.xml）：

```
<include>
        <gateway name="b">
                <param name="realm" value="192.168.1.B"/>
                <param name="username" value="1000"/>
                <param name="password" value="1234"/>
        </gateway>
</include>
```

同时把A上的 dialplan 改成：

```
<extension name="B">
  <condition field="destination_number" expression="^0(.*)$">
    <action application="bridge" data="sofia/gateway/b/$1"/>
  </condition>
</extension>
```

这样，A上的用户可以呼通所有B上的用户，从B的用户来看，好像所有电话都是从本机的1000这个用户打进来的（这就是网关的概念，因为对于B来说，A机就相当于一个普通的SIP用户1000。当然你从A上理解，B就是给你提供了一条SIP中继，如果在B上解决了“主叫号码透传”以后，B就相法于一条真正的中继了）。如果这么说理解有难度的话，想像一下B是联通或电信的服务器网关，你是不能控制的，而它只给了你一个网关的IP，用户名，和密码，你把它配到你的A上，就可以呼通电信能呼通的任何固定电话或手机了。





​					[![FreeSWITCH权威指南](http://www.freeswitch.org.cn/images/FSDG.jpg) 					
FreeSWITCH权威指南](http://book.dujinfang.com) 				
 				![FreeSWITCH-CN微信公众账号](http://www.freeswitch.org.cn/images/qrcode_for_FreeSWITCH-CN-wechat.jpg) 				
微信公众账号 				
FreeSWITCH-CN 			



​					[![img](http://www.freeswitch.org.cn/images/xyt-logo.png)](http://x-y-t.com) 			



# FreeSWITCH背后的故事(译)

[[freeswitch](http://www.dujinfang.com/tags.html#freeswitch)] 

本文由Anthony Minessale写于2007年5月。来自 [www.freeswitch.org](http://www.freeswitch.org/node/60)。翻译它是因为我觉得永远都不会过时… –Seven

我开发FreeSWITCH已经近两年的时间了。在我们第一个发行版即将发布的黎明之际，我想花一点时间来与大家分享一下软件背后的故事，并透露一点即将到来的消息。本故事也将会登在 [OST Magazine](http://www.ostelephony.com/)第一期上。呵，去下载一份吧，免费的！

写FreeSWITCH的想法诞生于2005年春的一次Asterisk开发者大会上。当时，我为Asterisk  1.2版贡献了大量的代码和新特性，并为其以后的发展提了好多思路。我们都认为在当时的Asterisk代码树中存在很严重的限制，并且面临着一些问题──修正一些问题时不仅会牺牲很多特性，而且还会花大量的时间。一种思路是建立新的代码分支，通过将大家已经熟悉的代码分开，新的分支就不会影响Asterisk用户的使用，从而能减轻好多开发的压力。问题是开发者都不希望将精力分散到同一份代码的两的版本上，因为那样他们就不得不将BUG修正和代码修改在两个分支间拷来拷去。我的建议是：在一个单独的代码库上从头创建一个Asterisk 2.0的分支，等一切就绪后再对外发布。我想那个想法确实打动了一些开发人员，但现实是，由于讨论的时间过长，最终大家都失去了兴趣。不过，我没有。

很明显，我是唯一一个认真考虑这一问题的。接下来我用了几天的时间在做一个白日梦──如何设计一个新的电话系统。之后，我再也无法抑制，便创建了一个新的目录开始从头写choir.c。是的，Choir是我为该工程的选的第一个名字。我希望不同的通信部件能够步调一致地协同工作，就像教堂的唱诗班那样优雅和谐（perfect  harmony）。我又用了5天时间把我想到的点子都组织到几个文件里。最初的努力并不能装配成一个电话交换机。我知道，我需要创建一个稳定的核心，并应该能跨平台。所以最简单的是使用Apache APR库来搭建一个基本的子系统，让它能够动态装载共享模块并悠闲地停在屏幕上等待shutdown命令。实现这些代码用了另外6个月的时间。

在那5天里，我知道了写一个达到那种要求的可伸缩性程序并不是一件简单的事情。我最初的目标是捡起那些Asterisk丢掉的东西并加以改善。但随着思考的深入，我越来越觉得，实际上我想改进的是最基础的设计和功能。最终我得出结论，Asterisk不能实现一些我期望的功能是因为它不是我所需要的那种软件。也就在那时，我知道我不是要编写另外一个PBX，而是要开发一个完全不同级别的应用程序。我用了后续的几个月时间组织了第一届ClueCon年会来讨论如何合理的设计Choir。我希望在继续写任何代码之前能确信我有正确的计划。从这一点上说我仍在做相当的一部分Asterisk开发，并且我也在我写的一些第三方模块中来实验我的想法。另外，我也让我的同事们花了相当多的时间来争论在电话领域里如何“正确”地做事情，这也算是一种前瞻性吧。

在那年的ClueCon会议上，我有幸遇到一些在电话领域里很有影响力的开发者，并把很多灵感带回了家。同时，Asterisk阵营中的关系开始有些紧张，因为有几个开发者也打算建立新的分支。新的项目称为OpenPBX（现在叫Call  Weaver），从某种意义上讲它引起了Asterisk社区的一次严重地分裂。最初，OpenPBX把我的许多第三方Asterisk模块加入到他们的新代码中，并就如何增强稳定性方面咨询我的建议。其中有一点，甚至他们还来看我是如何在我的新项目中实现的。可能我们能再打起精神来重写那些老的计划，但最终没有实现。不过，我想，最意义深远的一刻是──当有人问到我：“多长时间以后它才能打电话呢？”我不知道，所以我决定搞清楚。简短的回答是一星期。

与我想达到的目标相比，能打电话只是一个小小的胜利。我还有很多要做的事情。这一点不起眼的业绩得不到太多关注。好消息是，这一项目最终上路了。我深居简出，用了三个月时间试图能做出点能吸引公众眼球的东西。那段时间，项目的名字曾改为Pandora并最终成为FreeSWITCH。2006年1月我们公开的SVN仓库和一个邮件列表上线了。那时仅有几个模块和一个很短的特性列表。但我们有了一个可以工作的内核，它能够在包括Mac OS X，Linux和BSD的几个UNIX变种上编译和运行，并能在Microsoft Windows上以一个控制台程序运行。

随着时间的推移，我们也越加有动力。有时也停下来犯几个错误，然后继续前进，写几个新的模块。在试验了四个不同的SIP终点模块后，我们决定使用Sofia SIP。也曾试验过5个不同的RTP协议栈，最终决定还是我们自己写。同时我也开发了mod_dingaling来做与Google  Talk的接口，以及一个多特性的会议桥。在第一年里，我主要关注如何在使核心尽量稳定的基础上，提供几个外部接口以便于其它模块的开发。如用于IVR的嵌入式的javascript，一个XML-RPC接口和一个用于远程控制和事件监控的基于TCP的Socket的接口。

第二年的ClueCon大会，那一天仿佛就是我白日梦醒来的日子。我第一次向我的同行们演示了FreeSWITCH。近九个月后，在距离第一个想法两年之际，第三届ClueCon一个月前，我们达到了开发的BETA阶段──FreeSWITCH  1.0发布在际了。我们也吸引了一些勇敢的开发者一道。他们已经把FreeSWITCH用于生产系统，并给我们提供了保证我们第一个发布版本成功的很重要的反馈。

在发布之前，最后一点工作是我新写的一个叫做OpenZAP的开源的TDM抽象库。使用BSD协议的mod_openzap模块将取代当时特定于Sangoma的mod_wanpipe，并提供Sangoma及其它几种TDM硬件（只需要开发对应的模块）支持。OpenZAP也将为模拟和ISDN信令提供一个简单的接口。OpenZAP的指导思想是──应用程序能使用同样的API去控制任何它所支持的TDM硬件。它提供一种方式能将所有不同的特性规范化。如果一种卡缺少某种特性，那么它就能以软件的形式实现，不管是在OpenZAP库中还是在与生产商硬件API通信的接口程序中。

我们在如此短的时间内做这么多事听起来好像是不可能的，但我想，最终，还是像格言里说的：“需要是发明之母。”接下来的路还很长。但我想就此机会感谢所有曾经帮助我们走了这么远的人。下面列表中是所有在我们AUTHORS文件中的人：

- Anthony Minessale II (就是我!)
- Michael Jerris (我们极具价值的编译专家和跨平台专家 cross-platformologist， [呵，这个词是我创造的])
- Brian K. West (我们挚爱的Mac权威，没有他的帮助，我们将寸步难行)
- Joshua Colp (帮助我们做了第一个SIP模块，虽然现在我们已经不用了)
- Michal “cypromis” Bielicki (他从第一天就加入进来了，感谢信任！)
- James Martelletti (把mono集成进了FreeSWITCH.)
- Johny Kadarisman (帮我们弄好了python模块)
- Yossi Neiman (写了mod_cdr收集通话详单)
- Stefan Knoblich (在我们的SIP之旅上帮助甚多)
- Justin Unger (找到很多BUG)
- Paul D. Tinsley (SIP presence以及其它好的建议)
- Ken Rice (为什么有这个名字？它给了我们做了很多测试和补丁)
- Neal Horman (在会议模块上有巨大贡献)
- Michael Murdock (我们CopperCom的朋友，有大量反馈和补丁)
- Matt Klein (大量SIP帮助，将帮我们确保FreeSWITCH运行于FreeBSD.)
- Justin Cassidy (幕后工作者，确保一切正常)
- Bret McDanel (敢吃螃蟹的人，试验了绝大多数的功能，最早发现了很多隐藏的BUG，我指的是得活节彩蛋！)

​				 			 			

# FreeSWITCH 与 Asterisk

[[旧闻](http://www.freeswitch.org.cn/tags.html#旧闻)] 

FreeSWITCH vs Asterisk FreeSWITCH 与 Asterisk 比较

Anthony Minssale/文 [Seven](http://www.dujinfang.com/)/译

VoIP通信，与传统的电话技术相比，不仅仅在于绝对的资费优势，更重要的是很容易地通过开发相应的软件，使其与企业的业务逻辑紧密集成。Asterisk作为开源VoIP软件的代表，以其强大的功能及相对低廉的建设成本，受到了全世界开发者的青睐。而FreeSWITCH作为VoIP领域的新秀，在性能、稳定性及可伸缩性等方面则更胜一筹。本文原文在http://www.freeswitch.org/node/117， 发表于2008年4月，相对日新月异的技术来讲，似乎有点过时。但本文作为FreeSWITCH背后的故事，仍很有翻译的必要。因此，本人不揣鄙陋，希望与大家共读此文，请不吝批评指正。  --译者注

FreeSWITCH 与 Asterisk 两者有何不同？为什么又重新开发一个新的应用程序呢？最近，我听到很多这样的疑问。  为此，我想对所有在该问题上有疑问的电话专家和爱好者们解释一下。我曾有大约三年的时间用在开发 Asterisk 上，并最终成为了  FreeSWITCH 的作者。因此，我对两者都有相当丰富的经验。首先，我想先讲一点历史以及我在 Asterisk  上的经验；然后，再来解释我开发FreeSWITCH的动机以及我是如何以另一种方式实现的。

我从2003年开始接触  Asterisk，当时它还不到1.0版。那时对我来讲，VoIP还是很新的东西。我下载并安装了它，几分钟后，从插在我电脑后面的电话机里传出了电话拨号音，这令我非常兴奋。接下来，我花了几天的时间研究拨号计划，绞尽脑汁的想能否能在连接到我的Linux  PC上的电话上实现一些好玩的东西。由于做过许多Web开发，因此我积累了好多新鲜的点子，比如说根据来电显示号码与客户电话号码的对应关系来猜想他们为什么事情打电话等。我也想根据模式匹配来做我的拨号计划，并着手编写我的第一个模块。最初，我做的第一个模块是app_perl，现在叫做res_perl，当时曾用它在Asterisk中嵌入了一个Perl5的解释器。现在我已经把它从我的系统中去掉了。

后来我开始开发一个Asterisk驱动的系统架构，用于管理我们的呼入电话队列。我用app_queue和现在叫做AMI（大写字母总是看起来比较酷）的管理接口开发了一个原型。它确实非常强大。你可以从一个T1线路的PSTN号码呼入，并进入一个呼叫队列，坐席代表也呼入该队列，从而可以对客户进行服务。非常酷！我一边想一边看着我的可爱的Web页显示着所有的队列以及他们的登录情况。并且它还能周期性的自动刷新。令人奇怪的是，有一次我浏览器一角上的小图标在过了好长时间后仍在旋转。那是我第一次听说一个词，一个令我永远无法忘记的词 -- 死锁。

那是第一次，但决不是最后一次。那一天，我几乎学到了所有关于GNU调试器的东西，而那只是许多问题的开始。队列程序的死锁，管理器的死锁。控制台的死锁开始还比较少，后来却成了一个永无休止的过程。现在，我非常熟悉“段错误(Segmentation  Fault)”这个词，它真是一个计算机开发者的玩笑。经过一年的辛勤排错，我发现我已出乎意料的非常精通C语言并且有绝地战士般的调试技巧。我有了一个分布于七台服务器、运行于DS3 TDM信道的服务平台。与此同时，我也为这一项目贡献了大量的代码，其中有好多是我具有明确版权的完整文件(http://www.cluecon.com/anthm.html)。

到了2005年，我已经俨然成了非常有名的Asterisk开发者。他们甚至在CREDITS文件以及《Asterisk，电话未来之路》这本书中感谢我。在Asterisk代码树中我不仅有大量的程序，而且还有一些他们不需要或者不想要的代码，我把它们收集到了我的网站上。(至今仍在 http://www.freeswitch.org/node/50)

Asterisk 使用模块化的设计方式。一个中央核心调入称为模块的共享目标文件以扩展功能。模块用于实现特定的协议（如SIP）、程序（如个性化的IVR）和其它外部接口（如管理接口）等。

Asterisk的核心是多线程的，但它非常保守。仅仅用于初始化的信道以及执行一个程序的信道才有线程。任何呼叫的B端都与A端都处于同一线程。当某些事件发生时（如一次转移呼叫必须首先转移到一个称作伪信道的线程模式），该操作把一个信道所有内部数据从一个动态内存对象中分离出来，放入另一个信道中。它的实现在代码注释中被注明是“肮脏的”[1]。反向操作也是如此，当销毁一个信道时，需要先克隆一个新信道，才能挂断原信道。同时也需要修改CDR的结构以避免将它视为一个新的呼叫。因此，对于一个呼叫，在呼叫转移时经常会看到3或4个信道同时存在。

这种操作成了从另一个线程中取出一个信道事实上的方法，同时它也正是开发者许许多多头痛的源头。这种不确定的线程模式是我决定着手重写这一应用程序的原因之一。

Asterisk使用线性链表管理活动的信道。链表通过一种结构体将一系列动态内存串在一起，这种结构体本身就是链表中的一个成员，并有一个指针指向它自己，以使它能链接无限的对象并能随时访问它们。这确实是一项非常有用的编程技术，但是，在多线程应用中它非常难于管理。在线程中必须使用一个信号量（互斥体，一种类似交通灯的东西）来确保在同一时刻只有一个线程可以对链表进行写操作，否则当一个线程遍历链表时，另一个线程可能会将元素移出。甚至还有比这更严重的问题 ─  当一个线程正在销毁或监听一个信道的同时，若有另外一个线程访问该链表时，会出现“段错误”。“段错误”在程序里是一种非常严重的错误，它会造成进程立即终止，这就意味着在绝大多数情况下会中断所有通话。我们所有人都看到过“防止初始死锁”[2]这样一个不太为人所知的信息，它试图锁定一个信道，在10次不成功之后，就会继续往下执行。

管理接口（或AMI）有一个概念，它将用于连接客户端的套接字(socket)传给程序，从而使你的模块可以直接访问它。或者说，更重要的是你可以写入任何你想写入的东西，只要你所写入的东西符合Manager Events所规定的格式（协议）。但遗憾的是，这种格式没有很好的结构，因而很难解析。

Asterisk的核心与某些模块有密切的联系。由于核心使用了一些模块中的二进制代码，当它所依赖的某个模块出现问题，Asterisk就根本无法启动。如果你想打一个电话，至少在 Asterisk 1.2中，除使用app_dial和res_features外你别无选择，这是因为建立一个呼叫的代码和逻辑实际上是在app _ dial中，而不是在核心里。同时，桥接语音的顶层函数实际上包含在res_features中。

Asterisk的API没有保护，大多数的函数和数据结构都是公有的，极易导致误用或被绕过。其核心非常混乱，它假设每个信道都必须有一个文件描述符，尽管实际上某些情况下并不需要。许多看起来是一模一样的操作，却使用不同的算法和杰然不同的方式来实现，这种重复在代码中随处可见。

这仅仅是我在Asterisk中遇到的最多的问题一个简要的概括。作为一个程序员，我贡献了大量的时间，并贡献了我的服务器来作为CVS代码仓库和Bug跟踪管理服务器。我曾负责组织每周电话会议来计划下一步的发展，并试图解决我在上面提到过的问题。问题是，当你对着长长的问题列表，思考着需要花多少时间和精力来删除或重写多少代码时，解决这些问题的动力就渐渐的没有了。值得一提的是，没有几个人同意我的提议并愿意同我一道做一个2.0的分支来重写这些代码。所以在2005年夏天我决定自己来。

在开始写FreeSWITCH时，我主要专注于一个核心系统，它包含所有的通用函数，即受到保护又能提供给高层的应用。像Asterisk一样，我从Apache  Web服务器上得到很多启发，并选择了一种模块化的设计。第一天，我做的最基本的工作就是让每一个信道有自己的线程，而不管它要做什么。该线程会通过一个状态机与核心交互。这种设计能保证每一个信道都有同样的、可预测的路径和状态钩子，同时可以通过覆盖向系统增加重要的功能。这一点也类似其它面向对象的语言中的类继承。

做到这点其实不容易，容我慢慢讲。在开发FreeSWITCH的过程中我也遇到了段错误和死锁（在前面遇到的多，后来就少了）。但是，我从核心开始做起，并从中走了出来。由于所有信道都有它们自己的线程，有时候你需要与它们进行交互。我通过使用一个读、写锁，使得可以从一个散列表（哈希）中查找信道而不必遍历一个线性链表，并且能绝对保证当一个外部线程引用到它时，一个信道无法被访问也不能消失。这就保证了它的稳定，也不需要像Asterisk中“Channel Masquerades”之类的东西了。

FreeSWITCH核心提供的的大多数函数和对象都是有保护的，这通过强制它们按照设计的方式运行来实现。任何可扩展的或者由一个模块来提供方法或函数都有一个特定的接口，从而避免了核心对模块的依赖性。

整个系统采用清晰分层的结构，最核心的函数在最底层，其它函数分布在各层并随着层数和功能的增加而逐渐减少。

例如，我们可以写一个大的函数，打开一个任意格式的声音文件向一个信道中播放声音。而其上层的API只需用一个简单的函数向一个信道中播放文件，这样就可以将其作为一个精减的应用接口函数扩展到拨号计划模块。因此，你可以从你的拨号计划中，也可以在你个性化的C程序中执行同样的playback函数，甚至你也可以自己写一个模块，手工打开文件，并使用模块的文件格式类服务而无需关注它的代码。

FreeSWITCH由几个模块接口组成，列表如下：

拨号计划(Dialplan)： 实现呼叫状态，获取呼叫数据并进行路由。

终点(Endpoint)： 为不同协议实现的接口，如SIP，TDM等。

自动语音识别/文本语音转换(ASR/TTS)： 语音识别及合成。

目录服务(Directory)： LDAP类型的数据库查询。

事件(Events)： 模块可以触发核心事件，也可以注册自己的个性事件。这些事件可以在以后由事件消费者解析。

事件句柄(Event handlers)： 远程访问事件和CDR。

格式(Formats)： 文件模式如wav。

日志(Loggers)： 控制台或文件日志。

语言(Languages)： 嵌入式语言，如Python和JavaScript。

语音(Say)： 从声音文件中组织话语的特定的语言模块。

计时器(Timers)： 可靠的计时器，用于间隔计时。

应用(Applications)： 可以在一次呼叫中执行的程序，如语音信箱(Voicemail）。

FSAPI(FreeSWITCH 应用程序接口）： 命令行程序，XML RPC函数，CGI类型的函数，带输入输出原型的拨号计划函数变量。

XML： 到核心XML的钩子可用于实时地查询和创建基于XML的CDR。

所有的FreeSWITCH模块都协同工作并仅仅通过核心API或内部事件相互通信。我们非常小心地实现它以保证它能正常工作，并避免其它外部模块引起不期望的问题。

FreeSWITCH的事件系统用于记录尽可能多的信息。在设计时，我假设大多数的用户会通过一个个性化的模块远程接入FreeSWITCH来收集数据。所以，在FreeSWITCH中发生的每一个重要事情都会触发一个事件。事件的格式非常类似于一个电子邮件，它具有一个事件头和一个事件主体。事件可被序列化为一个标准的Text格式或XML格式。任何数量的模块均可以连接到事件系统上接收在线状态，呼叫状态及失败等事件。事件树内部的mod_event_socket可提供一个TCP连接，事件可以通过它被消费或记入日志。另外，还可以通过此接口发送呼叫控制命令及双向的音频流。该套接字可以通过一个正在进行的呼叫进行向外连接(Outbound)或从一个远程机器进行向内（Inbound)连接。

FreeSWITCH中另一个重要的概念是中心化的XML注册表。当FreeSWITCH装载时，它打开一个最高层的XML文件，并将其送入一个预处理器。预处理器可以解析特殊的指令来包含其它小的XML文件以及设置全局变量等。在此处设置的全局变量可以在后续的配置文件中引用。

如，你可以这样用预处理指令设置全局变量：

```
<X-PRE-PROCESS cmd="set" data="moh_uri=local_stream://moh"/>
```

现在，在文件中的下一行开始你就可以使用 $$(moh_uri}，它将在后续的输出中被替换为 local_stream://moh。处理完成后XML注册表将装入内存，以供其它模块及核心访问。它有以下几个重要部分：

配置文件： 配置数据用于控制程序的行为。

拨号计划： 一个拨号计划的XML表示可以用于 mod _ dialplan _ xml，用以路由呼叫和执行程序。

分词： 可标记的IVR分词是一些可以“说”多种语言的宏。

目录： 域及用户的集合，用于注册及账户管理。

通过使用XML钩子模块，你可以绑定你的模块来实时地查询XML注册表，收集必要的信息，以及返回到呼叫者的静态文件中。这样你可以像一个WEB浏览器和一个CGI程序一样，通过同一个模型来控制动态的SIP注册，动态语音邮件及动态配置集群。

通过使用嵌入式语言，如Javascript, Java, Python和Perl等，可以使用一个简单的高级接口来控制底层的应用。

FreeSWITCH工程的第一步是建立一个稳定的核心，在其上可以建立可扩展性的应用。我很高兴的告诉大家在2008年5月26日将完成FreeSWITCH 1.0 PHOENIX版。有两位敢吃螃蟹的人已经把还没到1.0版的FreeSWITCH  用于他们的生产系统。根据他们的使用情况来看，我们在同样的配置下能提供Asterisk 10倍的性能。

我希望这些解释能足够概括FreeSWICH和Asterisk的不同之处以及我为何决定开始FreeSWITCH项目。我将永远是一个Asterisk开发者，因为我已深深的投入进去。并且，我也希望他们在以后的Asterisk开发方面有新的突破。我甚至还收集了很多过去曾经以为已经丢失的代码，放到我个人的网站上供大家使用， 也算是作为我对引导我进入电话领域的这一工程的感激和美好祝愿吧。

Asterisk是一个开源的PBX，而FreeSWITCH则是一个开源的软交换机。与其它伟大的软件如 Call  Weaver、Bayonne、sipX、OpenSER以及更多其它开源电话程序相比，两者还有很大发展空间。我每年都期望能参加在芝加哥召开的  ClueCon大会，并向其它开发者展示和交流这些项目(http://www.cluecon.com)。

我们所有人都可以相互激发和鼓励以推进电话系统的发展。你可以问的最重要的问题是：“它是完成该功能的最合适的工具吗？”

------

[1] / *XXX This is a seriously wacked out operation. We're essentially putting the guts of the clone channel into the original channel. Start by killing off the original channel's backend. I'm not sure we're going to keep this function, because while the features are nice, the cost is very high in terms of pure nastiness. XXX* /

[2] Avoiding initial deadlock





​					[![FreeSWITCH权威指南](http://www.freeswitch.org.cn/images/FSDG.jpg) 					
FreeSWITCH权威指南](http://book.dujinfang.com) 				
 				![FreeSWITCH-CN微信公众账号](http://www.freeswitch.org.cn/images/qrcode_for_FreeSWITCH-CN-wechat.jpg) 				
微信公众账号 				
FreeSWITCH-CN 			



​					[![img](http://www.freeswitch.org.cn/images/xyt-logo.png)](http://x-y-t.com) 			



​				 			 			