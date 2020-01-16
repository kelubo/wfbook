# ZFS

Z 文件系统(Zettabyte File System，ZFS）

历史  

由 Matthew Ahrens 和 Jeff Bonwick 在 2001  年开发的。ZFS 是作为 太阳微系统(Sun MicroSystem) 公司的 OpenSolaris 的下一代文件系统而设计的。

在 2008  年，ZFS 被移植到了 FreeBSD 。同一年，一个移植 ZFS 到 Linux 的项目也启动了。然而，由于 ZFS 是 通用开发和发布许可证  (Common Development and Distribution License)（CDDL）许可的，它和 GNU 通用公共许可证  不兼容，因此不能将它迁移到 Linux 内核中。为了解决这个问题，绝大多数 Linux 发行版提供了一些方法来安装 ZFS　。

在甲骨文公司收购太阳微系统公司之后不久，OpenSolaris 就闭源了，这使得 ZFS 的之后的开发也变成闭源的了。许多 ZFS  开发者对这件事情非常不满。 三分之二的 ZFS 核心开发者 ，包括 Ahrens 和  Bonwick，因为这个决定而离开了甲骨文公司。2013 年 9 月创立了 OpenZFS 这一项目。该项目引领着  ZFS 的开源开发。



特性 。比如：

- 存储池
- 写时拷贝
- 快照
- 数据完整性验证和自动修复
- RAID-Z
- 最大单个文件大小为 16 EB（1 EB = 1024 PB）
- 最大 256 千万亿（256*1015 ）的 ZB（1 ZB = 1024 EB）的存储



存储池

![img](..\Image\z\ZFS)



RAID-Z 

RAID-Z 是 RAID-5 的一个变种，不过它克服了 RAID-5 的写漏洞：意外重启之后，数据和校验信息会变得不同步。为了使用 基本级别的 RAID-Z  （RAID-Z1），需要至少三块磁盘，其中两块用来存储数据，另外一块用来存储 奇偶校验信息 。而 RAID-Z2  需要至少两块磁盘存储数据以及两块磁盘存储校验信息。RAID-Z3 需要至少两块磁盘存储数据以及三块磁盘存储校验信息。另外，只能向 RAID-Z  池中加入偶数倍的磁盘，而不能是奇数倍的。

## 安装

**CentOS 7**

```bash
yum install epel-release -y
yum install http://download.zfsonlinux.org/epel/zfs-release.el6.noarch.rpm -y
yum install kernel-devel zfs -y
modprobe zfs
```

**Ubuntu**

```bash
# Ubuntu 16.04 LTS
sudo apt install zfs
# Ubuntu 17.04 及以后
sudo apt install zfsutils
```









ZFS 消除了建立传统 RAID 阵列的需要。 相反，可以创建 ZFS 池，甚至可以随时将驱动器添加到这些池中。 ZFS 池的行为操作与 RAID 几乎完全相同，但功能内置于文件系统中。

ZFS 也可以替代 LVM，使您能够动态地进行分区和管理分区，而无需处理底层的细节，也不必担心相关的风险。

是一个 CoW文件系统。ZFS 会创建文件的校验和，并允许您将这些文件回滚到以前的工作版本。

当你安装好程序后，可以使用 ZFS 提供的工具创建 ZFS 驱动器和分区。

创建池

![640?wx_fmt=jpeg](https://ss.csdn.net/p?https://mmbiz.qpic.cn/mmbiz_jpg/W9DqKgFsc6956XoXx8N3KZYibfj0DHLxOjNsVqxicUWwDO3wv5GS5XxicEQSfzK9NANWWL5XNw6T6DXzUZ2lYmMJA/640?wx_fmt=jpeg)

*Create ZFS Pool*

在 ZFS 中，池大致相当于 RAID 。 它们很灵活且易于操作。

RAID0

RAID0 只是把你的硬盘集中到一个池子里面，就像一个巨大的驱动器一样。 它可以提高你的驱动器速度，但是如果你的驱动器有损坏，你可能会失丢失数据。

要使用 ZFS 实现 RAID0，只需创建一个普通的池。

```

```

1. `sudo zpool create your-pool /dev/sdc /dev/sdd`

RAID1（镜像）

您可以在 ZFS 中使用 `mirror` 关键字来实现 RAID1 功能。 

```

```

1. `sudo zpool create your-pool mirror /dev/sdc /dev/sdd`

RAID5/RAIDZ1

ZFS  将 RAID5 功能实现为 RAIDZ1。 RAID5 要求驱动器至少是 3 个。并允许您通过将备份奇偶校验数据写入驱动器空间的 1/n（n  是驱动器数），留下的是可用的存储空间。 如果一个驱动器发生故障，阵列仍将保持联机状态，但应尽快更换发生故障的驱动器

```

```

1. `sudo zpool create your-pool raidz1 /dev/sdc /dev/sdd /dev/sde`

RAID6/RAIDZ2

RAID6 与 RAID5 几乎完全相同，但它至少需要四个驱动器。 它将奇偶校验数据加倍，最多允许两个驱动器损坏，而不会导致阵列关闭

```

```

1. `sudo zpool create your-pool raidz2 /dev/sdc /dev/sdd /dev/sde /dev/sdf`

RAID10（条带化镜像）

RAID10  旨在通过数据条带化提高存取速度和数据冗余来成为一个两全其美的解决方案。 你至少需要四个驱动器，但只能使用一半的空间。  您可以通过在同一个池中创建两个镜像来创建 RAID10 中的池（LCTT 译注：这里也与原文略有出入，原文是驱动器的数目是四的倍数，根据  wiki， RAID10 至少需要四个驱动器）。

```

```

1. `sudo zpool create your-pool mirror /dev/sdc /dev/sdd mirror /dev/sde /dev/sdf`

池的操作

![640?wx_fmt=jpeg](https://ss.csdn.net/p?https://mmbiz.qpic.cn/mmbiz_jpg/W9DqKgFsc6956XoXx8N3KZYibfj0DHLxOct4xJwotQztn89c7Hdn0d3KJfBic0AKYCWvI1y6j3GqNRMyV9q2vV9A/640?wx_fmt=jpeg)

*ZFS pool Status*

还有一些管理工具，一旦你创建了你的池，你就必须使用它们来操作。 首先，检查你的池的状态。

```

```

1. `sudo zpool status`

更新

当你更新 ZFS 时，你也需要更新你的池。 当您检查它们的状态时，您的池会通知您任何更新。 要更新池，请运行以下命令。

```

```

1. `sudo zpool upgrade your-pool`

你也可以更新全部池。

```

```

1. `sudo zpool upgrade -a`

添加驱动器

您也可以随时将驱动器添加到池中。 告诉 `zpool` 池的名称和驱动器的位置，它会处理好一切。

```

```

1. `sudo zpool add your-pool /dev/sdx`

其它的一些想法

![640?wx_fmt=jpeg](https://ss.csdn.net/p?https://mmbiz.qpic.cn/mmbiz_jpg/W9DqKgFsc6956XoXx8N3KZYibfj0DHLxO6vk8FQqPLY1J6MW9ic865b4RdI90kXicibT41iaEK7rd1NiaOoVJdoYnRYg/640?wx_fmt=jpeg)

*ZFS in File Browser*

ZFS 会在您的池的根文件系统中创建一个目录。 您可以使用 GUI 文件管理器或 CLI 按名称浏览它们。

ZFS 非常强大，还有很多其它的东西可以用它来做，但这些都是基础。 这是一个优秀的存储负载文件系统，即使它只是一个用于文件的硬盘驱动器的 RAID 阵列。 ZFS 在 NAS 系统上也非常出色。

无论 ZFS 的稳定性和可靠性如何，在您的硬盘上实施新的功能时，最好备份您的数据。

------

via: https://www.maketecheasier.com/use-zfs-filesystem-ubuntu-linux/

作者：Nick Congleton[3] 译者：amwps290 校对：wxy

本文由 LCTT 原创编译，Linux中国 荣誉推出

LCTT 译者![640?wx_fmt=jpeg](https://ss.csdn.net/p?https://mmbiz.qpic.cn/mmbiz_jpg/W9DqKgFsc6956XoXx8N3KZYibfj0DHLxO067HokdkVTmbd591xJLcs7ornMAnxPkmtbZVq573pdFT8Juibao9NcQ/640?wx_fmt=jpeg)**3**

< 左右滑动查看相关文章 >

[![640?wx_fmt=png](https://ss.csdn.net/p?https://mmbiz.qpic.cn/mmbiz_png/W9DqKgFsc6956XoXx8N3KZYibfj0DHLxOUF3YVjYLibdWVcqq6nOXOHc6NQTqYcANS5P6TC9iaHzFBOkZaNzF0DOg/640?wx_fmt=png)](http://mp.weixin.qq.com/s?__biz=MjM5NjQ4MjYwMQ==&mid=401566830&idx=2&sn=54351cb594a40baac5fddc64cc2e8b68&scene=21#wechat_redirect)[![640?wx_fmt=png](https://ss.csdn.net/p?https://mmbiz.qpic.cn/mmbiz_png/W9DqKgFsc6956XoXx8N3KZYibfj0DHLxOk9uRWK2B7aBicRh0buHY5FAibvgwrBXm6BXJscLPhq2UAyoUWJUyTticw/640?wx_fmt=png)](http://mp.weixin.qq.com/s?__biz=MjM5NjQ4MjYwMQ==&mid=416862057&idx=2&sn=d030331c7b74068a04f06a6eff816260&scene=21#wechat_redirect)[![640?wx_fmt=png](https://ss.csdn.net/p?https://mmbiz.qpic.cn/mmbiz_png/W9DqKgFsc6956XoXx8N3KZYibfj0DHLxOZOunpXa7SotRibKqZlxU3Dic5ruedlyJq3CmY3icSYayrZpPicHhgjaE8A/640?wx_fmt=png)](http://mp.weixin.qq.com/s?__biz=MjM5NjQ4MjYwMQ==&mid=2664607339&idx=4&sn=df4f6e23e990613eee68e16b965139b0&scene=21#wechat_redirect)[![640?wx_fmt=png](https://ss.csdn.net/p?https://mmbiz.qpic.cn/mmbiz_png/W9DqKgFsc6956XoXx8N3KZYibfj0DHLxOxAia07plKhrLba1kITMS9icxZrKafCR3IWHp12ibT4RicXVbksD6LxQ2IA/640?wx_fmt=png)](http://mp.weixin.qq.com/s?__biz=MjM5NjQ4MjYwMQ==&mid=2664608778&idx=3&sn=0cabecace3a843bb3eb085c30a590c3a&chksm=bdce8f4c8ab9065a82423f2d0f77790f51bf5e4bff9580a666e66c40213531e11991198e7485&scene=21#wechat_redirect)![640?wx_fmt=gif](https://ss.csdn.net/p?https://mmbiz.qpic.cn/mmbiz_png/W9DqKgFsc6956XoXx8N3KZYibfj0DHLxOzmFhqdgMwkG96KjPgCmicVc7ibMJT2C2HRZz3hKJSTRCknhib5dFpSDEQ/640?wx_fmt=gif)



原文链接请访问“原文链接





​                                                          插座电源滤波器   XD3B-6A EMI FILTER             1688热销                   

![img](https://kunyu.csdn.net/1.png?p=58&a=402&c=0&k=&d=1&t=3)





 			[ 				![img](https://g.csdnimg.cn/static/user-img/anonymous-User-img.png) 			](javascript:void(0);) 		

 			 			 			 		



 		



[ 		 				哪一种 *Ubuntu* 官方版本最适合你？ | *Linux* *中国*		 		 			 				 				 					阅读数  					4万+ 				 			 		](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/78980206)

 			[ 				我认为帮助新用户决定选择对他们来说哪个特色版本最好可能是至关重要的。毕竟，从一开始就选择一个不合适的发行版是一种不太理想的体验。--JackWallen本文导航◈ Ubuntu17%◈ Kubuntu... 			](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/78980206) 			 									博文 											[来自：	 技术无边](https://blog.csdn.net/F8qG7f9YD02Pe) 												 		

[ 		 				*ZFS**文件系统*基本*使用*		 		 			 				 				 					阅读数  					1194 				 			 		](https://blog.csdn.net/u012089451/article/details/11644449)

 			[ 				ZFS文件系统          ZFS是一款128bit文件系统，总容量是现有64bit文件系统的1.84x1019倍，其支持的单个存储卷容量达到16EiB（264byte，即16x1024x102... 			](https://blog.csdn.net/u012089451/article/details/11644449) 			 									博文 											[来自：	 Alex的专栏](https://blog.csdn.net/u012089451) 												 		

[ 		 				如*何在**Ubuntu*中安装*使用**ZFS**文件系统*		 		 			 				 				 					阅读数  					19 				 			 		](https://blog.csdn.net/weixin_34409703/article/details/90309840)

 			[ 				Linux操作系统支持和可用的文件系统类型非常多，既然这些文件系统都可以正常工作，我们为什么要去尝试一个新的文件系统呢?其实，不同Linux文件系统类型并不完全相同，不然也不用搞出这么多种类来了。其中... 			](https://blog.csdn.net/weixin_34409703/article/details/90309840) 			 									博文 											[来自：	 weixin_34409703的博客](https://blog.csdn.net/weixin_34409703) 												 		

[ 		 				*使用**ZFS*的十条理由 - *ZFS*特性介绍		 		 			 				 				 					阅读数  					4968 				 			 		](https://blog.csdn.net/laoeyu/article/details/921133)

 			[ 				上个月，SunMicrosystems公司正式发布ZFS（ZettabyteFileSystem）文件系统。ZFS是第一个128位的文件系统，同时ZFS又被SunMicrosystems称作史上最后一... 			](https://blog.csdn.net/laoeyu/article/details/921133) 			 									博文 											[来自：	 老饿鱼的地盘](https://blog.csdn.net/laoeyu) 												 		

<iframe id="iframeu3491668_0" name="iframeu3491668_0" src="https://pos.baidu.com/lcvm?conwid=852&amp;conhei=60&amp;rdid=3491668&amp;dc=3&amp;exps=110011&amp;psi=baf6daaca7ec074f0a1b80a4dd100e4f&amp;di=u3491668&amp;dri=0&amp;dis=0&amp;dai=1&amp;ps=8277x407&amp;enu=encoding&amp;dcb=___adblockplus&amp;dtm=HTML_POST&amp;dvi=0.0&amp;dci=-1&amp;dpt=none&amp;tsr=0&amp;tpr=1567997008302&amp;ti=%E5%A6%82%E4%BD%95%E5%9C%A8%20Ubuntu%20%E4%B8%8A%E4%BD%BF%E7%94%A8%20ZFS%20%E6%96%87%E4%BB%B6%E7%B3%BB%E7%BB%9F%20%7C%20Linux%20%E4%B8%AD%E5%9B%BD%20-%20%E6%8A%80%E6%9C%AF%E6%97%A0%E8%BE%B9%20-%20CSDN%E5%8D%9A%E5%AE%A2&amp;ari=2&amp;dbv=0&amp;drs=1&amp;pcs=1263x589&amp;pss=1286x9547&amp;cfv=0&amp;cpl=0&amp;chi=1&amp;cce=true&amp;cec=UTF-8&amp;tlm=1567997008&amp;prot=2&amp;rw=606&amp;ltu=https%3A%2F%2Fblog.csdn.net%2FF8qG7f9YD02Pe%2Farticle%2Fdetails%2F79329762&amp;ltr=https%3A%2F%2Fwww.baidu.com%2Flink%3Furl%3D2hRvY1DO5loujOGgS7k-dc3XUXUa-YsqjS1HZm0ANfzlCarqfvypn6AYTx7NRinIP5iek8yzVIf4kUkbrkGVkDbCohOFAvEZV_OgZKjPGka%26wd%3D%26eqid%3D9116d7f700002fde000000025d75b82e&amp;ecd=1&amp;uc=1280x680&amp;pis=-1x-1&amp;sr=1280x720&amp;tcn=1567997008&amp;qn=a99dec705d498482&amp;dpv=a99dec705d498482&amp;tt=1567997008208.105.106.108" vspace="0" hspace="0" marginwidth="0" marginheight="0" scrolling="no" style="border:0;vertical-align:bottom;margin:0;width:852px;height:60px" allowtransparency="true" width="852" height="60" frameborder="0" align="center,center"></iframe>
![img]()

[ 		 				*ubuntu* samba共享文件夹的搭建		 		 			 				 				 					阅读数  					2354 				 			 		](https://blog.csdn.net/bai_and_hao_1314/article/details/82223820)

 			[ 				博主最近到了要找工作的时间，而一般技术岗的岗位都会要求要会一点linux的，所以博主最近就下了ubuntu，然后在上面码代码，但有时博主想将在ubuntu上写的代码拿到windows上，然后发现不能直... 			](https://blog.csdn.net/bai_and_hao_1314/article/details/82223820) 			 									博文 											[来自：	 bai_and_hao_1314的博客](https://blog.csdn.net/bai_and_hao_1314) 												 		

[ 		 				*Ubuntu* 16.04 下*ZFS**文件系统*怎么启用 TRIM		 		 				11-21 		 		 			最近强迫症越来越严重， 总感觉 SSD要挂了， 刚好看到 Ubuntu支持ZFS， 并且本子上刚好是3块SSD， 就把全部硬盘给格了， 把系统装在了 RAIDZ 的 ZFS 上， 感觉还不错。 现在机 							论坛 					 	](https://bbs.csdn.net/topics/392051563)

[ 		 				如*何在*Centos7上安装和*使用**ZFS*		 		 			 				 				 					阅读数  					9575 				 			 		](https://blog.csdn.net/linuxnews/article/details/51286358)

 			[ 				导读ZFS文件系统的英文名称为ZettabyteFileSystem,也叫动态文件系统（DynamicFileSystem）,是第一个128位文件系统。最初是由Sun公司为Solaris10操作系统开... 			](https://blog.csdn.net/linuxnews/article/details/51286358) 			 									博文 											[来自：	 Linux运维的博客](https://blog.csdn.net/linuxnews) 												 		

[ 			 				 					 						运行在*linux*下的*ZFS*					 					12-30 				 				 						zfs on linux,运行在linux下的ZFS,不是solaris哦				 				下载 			 		](https://download.csdn.net/download/mmylau/4945386)

[ 		 				*ZFS*		 		 			 				 				 					阅读数  					5463 				 			 		](https://blog.csdn.net/anghlq/article/details/6427020)

 			[ 				Solaris10最新版：使用ZFS的十条理由-ZFS特性介绍上个月，SunMicrosystems公司正式发布ZFS（ZettabyteFileSystem）文件系统。ZFS是第一个128位的文件系... 			](https://blog.csdn.net/anghlq/article/details/6427020) 			 									博文 											[来自：	 ang639](https://blog.csdn.net/anghlq) 												 		

[              		如*何在**Ubuntu*中安装*使用**ZFS**文件系统* - weixin_34409703..._CSDN博客                                                            6-26                                                      ](https://blog.csdn.net/weixin_34409703/article/details/90309840)

[              		...是什么,为什么要*使用* *ZFS*? | *Linux* *中国* - 技术无边..._CSDN博客                                                            4-3                                                      ](https://blog.csdn.net/f8qg7f9yd02pe/article/details/82836037)

<iframe src="https://adaccount.csdn.net/#/preview/552?m=btpEbAJctfbtvHEAnJnctSJmUpnHSSictLtitcAJoJoHLXtpSALQnJpESJSHJntApppSSvpEtvEEDAAiHSnipQWtiJbLbcLHDQLQ&amp;k=" scrolling="no" width="100%" height="75px" frameborder="0"></iframe>
![img]()

[ 		 				Solaris *ZFS*根*文件系统*环境中设置交换区大小		 		 			 				 				 					阅读数  					162 				 			 		](https://blog.csdn.net/li1121567428/article/details/83539772)

 			[ 				在SolarisZFS根文件系统环境中设置交换区大小1、确定当前交换区文件及大小#zpoollistNAMESIZEALLOCFREECAPDEDUPHEALTHALTROOTrpool278G92.... 			](https://blog.csdn.net/li1121567428/article/details/83539772) 			 									博文 											[来自：	 li1121567428的博客](https://blog.csdn.net/li1121567428) 												 		

[              		*Linux* 中的 & | *Linux* *中国* - 技术无边 - CSDN博客                                                            3-9                                                      ](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/88149102)

[              		如何启动进入 *Linux* 命令行 | *Linux* *中国* - 技术无边 - CSDN博客                                                            9-2                                                      ](http://blog.csdn.net/F8qG7f9YD02Pe/article/details/79314601)

[ 		 				初学者指南：*ZFS* 是什么，为什么要*使用* *ZFS*？ | *Linux* *中国*		 		 			 				 				 					阅读数  					1139 				 			 		](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/82836037)

 			[ 				今天，我们来谈论一下ZFS，一个先进的文件系统。我们将讨论ZFS从何而来，它是什么，以及为什么它在科技界和企业界如此受欢迎。--JohnPaul有用的原文链接请...... 			](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/82836037) 			 									博文 											[来自：	 技术无边](https://blog.csdn.net/F8qG7f9YD02Pe) 												 		

[![Alex-Mahone](https://avatar.csdn.net/4/5/8/3_u012089451.jpg)](https://blog.csdn.net/u012089451)关注

[Alex-Mahone](https://blog.csdn.net/u012089451)



 33篇文章

 排名:千里之外



[![weixin_34409703](https://avatar.csdn.net/B/3/2/3_weixin_34409703.jpg)](https://blog.csdn.net/weixin_34409703)关注

[weixin_34409703](https://blog.csdn.net/weixin_34409703)



 4518篇文章

 排名:千里之外



[![laoeyu](https://avatar.csdn.net/0/3/4/3_laoeyu.jpg)](https://blog.csdn.net/laoeyu)关注

[laoeyu](https://blog.csdn.net/laoeyu)



 50篇文章

 排名:千里之外



[              		*Linux* 入门十法 | *Linux* *中国* - 技术无边 - CSDN博客                                                            8-10                                                      ](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/96662489)

[              		为*Linux* 选择打印机 | *Linux* *中国* - 技术无边 - CSDN博客                                                            11-26                                                      ](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/84452530)

[ 		 				在*Linux*上*使用*原生*ZFS**文件系统*		 		 			 				 				 					阅读数  					3787 				 			 		](https://blog.csdn.net/opendba/article/details/5998500)

 			[ 				   目前我们公司的greenplum是建立在Solars上ZFS上的，听数据仓库部门反映，当有硬盘出现问题时，ZFS会hang住。由于目前oracle收购了sun公司，而oracle也关闭了Open... 			](https://blog.csdn.net/opendba/article/details/5998500) 			 									博文 											[来自：	 opendba的专栏](https://blog.csdn.net/opendba) 												 		

[ 		 				吐槽*zfs*on*linux*的缺点		 		 			 				 				 					阅读数  					2621 				 			 		](https://blog.csdn.net/shenyanxxxy/article/details/9788171)

 			[ 				自己用zfsonlinux已经一段时间了，其中有非常多的感受难以言表。1.zfsonlinux加入了一个spl层。本身是借助spl层，spl默默的为zfs提供了很多的函数调用支持，所以你只是了解zfs... 			](https://blog.csdn.net/shenyanxxxy/article/details/9788171) 			 									博文 											[来自：	 shenyanxxxy的专栏](https://blog.csdn.net/shenyanxxxy) 												 		

[              		...中不*使用* CD 命令进入目录/文件夹? | *Linux* *中国* - ..._CSDN博客                                                            5-20                                                      ](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/88968568)

[              		如*何在* *Linux* 上管理字体 | *Linux* *中国* - 技术无边 - CSDN博客                                                            7-8                                                      ](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/84948842)

[ 		 				*Ubuntu* PPA *使用*指南 | *Linux* *中国*		 		 			 				 				 					阅读数  					168 				 			 		](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/86582273)

 			[ 				一篇涵盖了在Ubuntu和其他Linux发行版中使用PPA的几乎所有问题的深入的文章。--AbhishekPrakash致谢译自| itsfoss.co...... 			](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/86582273) 			 									博文 											[来自：	 技术无边](https://blog.csdn.net/F8qG7f9YD02Pe) 												 		

<iframe src="https://adaccount.csdn.net/#/preview/260?m=SpcpEbQQJtSJHALtLcLSpDLyHcLAQppmciHtbXAcbHDnnbXQiEELEHtEQSWAcppcpinfnmnnnbSLnynpbiipSyXLvipiHcLpQtSQ&amp;k=" scrolling="no" width="100%" height="75px" frameborder="0"></iframe>
![img]()

[              		如*何在* *Ubuntu* 登录屏幕上启用轻击 | *Linux* *中国* - 技..._CSDN博客                                                            8-29                                                      ](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/98403962)

[ 		 				*Ubuntu*下安装配置rsync		 		 			 				 				 					阅读数  					1万+ 				 			 		](https://blog.csdn.net/zpf336/article/details/51659666)

 			[ 				Rsync（remotesynchronize）是一个远程数据同步工具，可以使用“Rsync算法”同步本地和远程主机之间的文件。Rsync的好处是只同步两个文件不同的部分，相同的部分不在传递。类似于增... 			](https://blog.csdn.net/zpf336/article/details/51659666) 			 									博文 											[来自：	 三丰的专栏](https://blog.csdn.net/zpf336) 												 		

[ 		 				在*linux*中安装*zfs*的方法		 		 			 				 				 					阅读数  					1218 				 			 		](https://blog.csdn.net/shenyanxxxy/article/details/9788137)

 			[ 				今天由于要测试自己的代码，需要在其他机器上安装zfsonlinux。安装报错，现总结如下。安装的是zfs-0.6.11版本需要安装zlib库以及uuidapt-getinstall zlib1g-de... 			](https://blog.csdn.net/shenyanxxxy/article/details/9788137) 			 									博文 											[来自：	 shenyanxxxy的专栏](https://blog.csdn.net/shenyanxxxy) 												 		

[ 		 				立刻停止*使用*AUFS，开启Overlay！		 		 			 				 				 					阅读数  					2561 				 			 		](https://blog.csdn.net/sisiy2015/article/details/49739727)

 			[ 				阅读全文，了解为何停止使用AUFS！ 			](https://blog.csdn.net/sisiy2015/article/details/49739727) 			 									博文 											[来自：	 sisiy2015的博客](https://blog.csdn.net/sisiy2015) 												 		

[ 		 				*Ubuntu*环境的Tmux第一次上手		 		 			 				 				 					阅读数  					5246 				 			 		](https://blog.csdn.net/qq_33447234/article/details/53462055)

 			[ 				啦啦啦啦不想上数据库应用这门课 			](https://blog.csdn.net/qq_33447234/article/details/53462055) 			 									博文 											[来自：	 回忆专用小马甲的博客](https://blog.csdn.net/qq_33447234) 												 		

[ 		 				*ZFS* On *Linux* 现状，是否足够稳定了？		 		 			 				 				 					阅读数  					20 				 			 		](https://blog.csdn.net/weixin_33882443/article/details/90537230)

 			[ 				ZFSonLinux是否稳定了？代码递交数排在第二位的ZFSOnLinux项目开发者RichardYao的回答是“是的”——根据你对稳定的定义而定。稳定的意义是模糊的，其中一种意义是“做好了在生产环境... 			](https://blog.csdn.net/weixin_33882443/article/details/90537230) 			 									博文 											[来自：	 weixin_33882443的博客](https://blog.csdn.net/weixin_33882443) 												 		

​                                                          别再玩假传奇了！这款传奇爆率9.8，你找到充值入口算我输！             贪玩游戏 · 顶新                   

![img]()

[ 		 				LVM与*ZFS*		 		 			 				 				 					阅读数  					79 				 			 		](https://blog.csdn.net/weixin_34102807/article/details/92858789)

 			[ 				LVM用的不多，前期自己的NAS还是samba@centos6.5后来全部做成zfs@zfs@linux了.LVM只是一种管理工具，称不上文件系统，并且不具备冗余性，基本上就有点像一个大容器，把所有的... 			](https://blog.csdn.net/weixin_34102807/article/details/92858789) 			 									博文 											[来自：	 weixin_34102807的博客](https://blog.csdn.net/weixin_34102807) 												 		

[ 		 				如*何在* *Linux* 中不*使用* CD 命令进入目录/文件夹？ | *Linux* *中国*		 		 			 				 				 					阅读数  					80 				 			 		](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/88968568)

 			[ 				众所周知，如果没有cd命令，我们无法Linux中切换目录。这个没错，但我们有一个名为shopt的Linux内置命令能帮助我们解决这个问题。--Mages...... 			](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/88968568) 			 									博文 											[来自：	 技术无边](https://blog.csdn.net/F8qG7f9YD02Pe) 												 		

[ 		 				软磁盘阵列*ZFS*部署raid全过程[centos 7\]		 		 			 				 				 					阅读数  					2044 				 			 		](https://blog.csdn.net/shepherd2010/article/details/73104796)

 			[ 				1.背景一台老服务器（hpproliant）开机出现“slot4smartarrayinitializing"，刚开始以为阵列卡出了故障，开机进入阵列设置里，显示磁盘”RECOVERING"。最后排查... 			](https://blog.csdn.net/shepherd2010/article/details/73104796) 			 									博文 											[来自：	 坚不萌](https://blog.csdn.net/shepherd2010) 												 		

[ 		 				快捷教程：如*何在*命令行上编辑文件 | *Linux* *中国*		 		 			 				 				 					阅读数  					2280 				 			 		](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/79766706)

 			[ 				此次教程中，我们将向您展示三种命令行编辑文件的方式。本文一共覆盖了三种命令行编辑器，vi（或vim）、nano和emacs。--FalkoTimme,HimanshuArora有用的原文链接请访问文末... 			](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/79766706) 			 									博文 											[来自：	 技术无边](https://blog.csdn.net/F8qG7f9YD02Pe) 												 		

[ 		 				*ZFS**文件系统*的特点以及调优		 		 			 				 				 					阅读数  					75 				 			 		](https://blog.csdn.net/iteye_15479/article/details/81770816)

 			[ 				RecordSizeRecordSize也就是通常所说的文件系统的blocksize。ZFS采用的是动态的RecordSize，也就是说ZFS会根据文件大小选择*适合*的512字节的整数倍作为存储的块... 			](https://blog.csdn.net/iteye_15479/article/details/81770816) 			 									博文 											[来自：	 渴死的火烈鸟](https://blog.csdn.net/iteye_15479) 												 		

​                                                          老公自从吃了它，每天晚上要搞我好几次！             晨韵 · 猎媒                   

![img]()

[ 		 				如*何在* *Ubuntu* 登录屏幕上启用轻击 | *Linux* *中国*		 		 			 				 				 					阅读数  					53 				 			 		](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/98403962)

 			[ 				轻击（taptoclick）选项在Ubuntu18.04GNOME桌面的登录屏幕上不起作用。在本教程中，你将学习如何在Ubuntu登录屏幕上启用“轻击”。...... 			](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/98403962) 			 									博文 											[来自：	 技术无边](https://blog.csdn.net/F8qG7f9YD02Pe) 												 		

[ 		 				Stratis 从 *ZFS*、Btrfs 和 LVM 学到哪些 | *Linux* *中国*		 		 			 				 				 					阅读数  					275 				 			 		](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/80749685)

 			[ 				当一个函数F调用另一个函数作为它的结束动作时，就发生了一个尾调用。--GustavoDuarte有用的原文链接请访问文末的“原文链接”获得可点击的文内链接、全尺寸...... 			](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/80749685) 			 									博文 											[来自：	 技术无边](https://blog.csdn.net/F8qG7f9YD02Pe) 												 		

[ 		 				LVM - 很好很强大		 		 			 				 				 					阅读数  					69 				 			 		](https://blog.csdn.net/robbin/article/details/83320226)

 			[ 				LVM(LogicVolumeManagement,逻辑卷管理)，是传统商业Unix就带有的一项高级磁盘管理工具，异常强大。后来LVM移植到了Linux操作系统上，尽管不像原来Unix版本那么强大，但... 			](https://blog.csdn.net/robbin/article/details/83320226) 			 									博文 											[来自：	 robbin的专栏](https://blog.csdn.net/robbin) 												 		

[ 		 				*ZFS* -世界上最高级的*文件系统*之一		 		 			 				 				 					阅读数  					451 				 			 		](https://blog.csdn.net/weixin_34168880/article/details/86061928)

 			[ 				https://www.oschina.net/news/44302/openzfs_launch_announcementhttps://en.wikipedia.org/wiki/ZFSZFS是世... 			](https://blog.csdn.net/weixin_34168880/article/details/86061928) 			 									博文 											[来自：	 weixin_34168880的博客](https://blog.csdn.net/weixin_34168880) 												 		

[ 		 				*zfs*简介		 		 			 				 				 					阅读数  					409 				 			 		](https://blog.csdn.net/zhangxinji/article/details/83823469)

 			[ 				(翻译《ZFSOn-DiskSpecification》，由于是2006年给出的文档，与当前ZFS系统肯定有很多的不同，但是也是一份相当有帮助的ZFS学习文档) 1.1虚拟设备 ZFS存储池是由一个虚... 			](https://blog.csdn.net/zhangxinji/article/details/83823469) 			 									博文 											[来自：	 zhangxinji的专栏](https://blog.csdn.net/zhangxinji) 												 		

<iframe id="iframeu3600856_0" name="iframeu3600856_0" src="https://pos.baidu.com/lcvm?conwid=852&amp;conhei=66&amp;rdid=3600856&amp;dc=3&amp;exps=110011&amp;psi=baf6daaca7ec074f0a1b80a4dd100e4f&amp;di=u3600856&amp;dri=0&amp;dis=0&amp;dai=2&amp;ps=10673x407&amp;enu=encoding&amp;dcb=___adblockplus&amp;dtm=HTML_POST&amp;dvi=0.0&amp;dci=-1&amp;dpt=none&amp;tsr=0&amp;tpr=1567997008302&amp;ti=%E5%A6%82%E4%BD%95%E5%9C%A8%20Ubuntu%20%E4%B8%8A%E4%BD%BF%E7%94%A8%20ZFS%20%E6%96%87%E4%BB%B6%E7%B3%BB%E7%BB%9F%20%7C%20Linux%20%E4%B8%AD%E5%9B%BD%20-%20%E6%8A%80%E6%9C%AF%E6%97%A0%E8%BE%B9%20-%20CSDN%E5%8D%9A%E5%AE%A2&amp;ari=2&amp;dbv=0&amp;drs=1&amp;pcs=1263x589&amp;pss=1286x10726&amp;cfv=0&amp;cpl=0&amp;chi=1&amp;cce=true&amp;cec=UTF-8&amp;tlm=1567997010&amp;prot=2&amp;rw=606&amp;ltu=https%3A%2F%2Fblog.csdn.net%2FF8qG7f9YD02Pe%2Farticle%2Fdetails%2F79329762&amp;ltr=https%3A%2F%2Fwww.baidu.com%2Flink%3Furl%3D2hRvY1DO5loujOGgS7k-dc3XUXUa-YsqjS1HZm0ANfzlCarqfvypn6AYTx7NRinIP5iek8yzVIf4kUkbrkGVkDbCohOFAvEZV_OgZKjPGka%26wd%3D%26eqid%3D9116d7f700002fde000000025d75b82e&amp;ecd=1&amp;uc=1280x680&amp;pis=-1x-1&amp;sr=1280x720&amp;tcn=1567997010&amp;qn=e99546ac1a520320&amp;tt=1567997008208.2055.2056.2056" vspace="0" hspace="0" marginwidth="0" marginheight="0" scrolling="no" style="border:0;vertical-align:bottom;margin:0;width:852px;height:66px" allowtransparency="true" width="852" height="66" frameborder="0" align="center,center"></iframe>
![img]()

[ 		 				初学者指南：*ZFS* 是什么，为什么要*使用* *ZFS*？		 		 			 				 				 					阅读数  					13 				 			 		](https://blog.csdn.net/weixin_30371469/article/details/96625435)

 			[ 				作者：JohnPaul译者：LCTTLvFeng今天，我们来谈论一下ZFS，一个先进的文件系统。我们将讨论ZFS从何而来，它是什么，以及为什么它在科技界和企业界如此受欢迎。虽然我是一个美国人，但我更喜... 			](https://blog.csdn.net/weixin_30371469/article/details/96625435) 			 									博文 											[来自：	 weixin_30371469的博客](https://blog.csdn.net/weixin_30371469) 												 		

[ 		 				如*何在* *Ubuntu* 16.04 强制 APT 包管理器*使用* IPv4 | *Linux* *中国*		 		 			 				 				 					阅读数  					7270 				 			 		](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/82879401)

 			[ 				在搜索了一番谷歌后，我意识到Ubuntu镜像站点有时无法通过IPv6访问。--Sk有用的原文链接请访问文末的“原文链接”获得可点击的文内链接、全尺寸原图和相关文...... 			](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/82879401) 			 									博文 											[来自：	 技术无边](https://blog.csdn.net/F8qG7f9YD02Pe) 												 		

[ 		 				*ZFS* 设置指南(二)		 		 			 				 				 					阅读数  					614 				 			 		](https://blog.csdn.net/captainow/article/details/5414539)

 			[ 				 ZFS设置指南翻译自2010年3月http://www.solarisinternals.com/wiki/index.php/ZFS_Configuration_Guide翻译者：上海锋群网络技术... 			](https://blog.csdn.net/captainow/article/details/5414539) 			 									博文 											[来自：	 captainow的专栏](https://blog.csdn.net/captainow) 												 		

[ 		 				*Linux*,*zfs*耗内存的原因剖析		 		 			 				 				 					阅读数  					2256 				 			 		](https://blog.csdn.net/shenyanxxxy/article/details/9788077)

 			[ 				有些时候大家可能觉得Linux系统刚刚启动的时候没什么操作，为什么这么耗内存。最最常见的回答就是Linux会将很多的东西cache到内存当中。这么说是笼统的。  linux的cache有很多种，lin... 			](https://blog.csdn.net/shenyanxxxy/article/details/9788077) 			 									博文 											[来自：	 shenyanxxxy的专栏](https://blog.csdn.net/shenyanxxxy) 												 		

[ 		 				*ZFS**文件系统*（5） --  标准的奇偶校验RAID		 		 			 				 				 					阅读数  					1682 				 			 		](https://blog.csdn.net/liuyun2113/article/details/9961289)

 			[ 				标准的奇偶校验RAID要理解RAIDZ，那么就得首先理解那些基本的RAID，比如RAID-5和RAID-6,让我们来看看RAID-5的布局，你至少需要3个磁盘来实现，在其中的2个磁盘上，数据的条带化的... 			](https://blog.csdn.net/liuyun2113/article/details/9961289) 			 									博文 											[来自：	 腾飞吧，海绵宝宝](https://blog.csdn.net/liuyun2113) 												 		

​                                                          中医教你，如何去除静脉曲张！！！             随游 · 猎媒                   

![img]()

[ 		 				*ZFS**文件系统*介绍和挂载		 		 			 				 				 					阅读数  					1772 				 			 		](https://blog.csdn.net/happyblogs/article/details/6844286)

 			[ 				ZFS文件系统介绍和挂载  作者：文子   撰写日期：2011-09-28博客链接：http://biwenjuan.blog.163.com/blog一、ZFS文件系统介绍1.1简介  ZFS文件系... 			](https://blog.csdn.net/happyblogs/article/details/6844286) 			 									博文 												 		

[ 			 				 					 						*ZFS*中文手册					 					04-17 				 				 						Oracle® Solaris 管理:ZFS 文件系统 中文版 同样适用OpenZFS				 				下载 			 		](https://download.csdn.net/download/zhanghedong526/10356208)

[ 		 				搭建一台文件服务器		 		 			 				 				 					阅读数  					2万+ 				 			 		](https://blog.csdn.net/qq_32331997/article/details/77477508)

 			[ 				搭建一台文件服务器 			](https://blog.csdn.net/qq_32331997/article/details/77477508) 			 									博文 											[来自：	 莫失莫忘的博客](https://blog.csdn.net/qq_32331997) 												 		

[ 		 				*ZFS*十大最佳功能		 		 			 				 				 					阅读数  					36 				 			 		](https://blog.csdn.net/iteye_20954/article/details/81795681)

 			[ 				Source:http://tech.sina.com.cn/b/2009-11-30/09223635032.shtmlSun在2005年推出了开源文件系统ZFS，最初Sun是为OpenSolari... 			](https://blog.csdn.net/iteye_20954/article/details/81795681) 			 									博文 											[来自：	 编程开发资料库](https://blog.csdn.net/iteye_20954) 												 		

[ 		 				如何选择*文件系统*：EXT4、Btrfs 和 XFS		 		 			 				 				 					阅读数  					3万+ 				 			 		](https://blog.csdn.net/u014743697/article/details/54089297)

 			[ 				老实说，人们最不曾思考的问题之一是他们的个人电脑中使用了什么文件系统。Windows和MacOSX用户更没有理由去考虑，因为对于他们的操作系统，只有一种选择，那就是NTFS和HFS+。... 			](https://blog.csdn.net/u014743697/article/details/54089297) 			 									博文 											[来自：	 流風餘韻的专栏](https://blog.csdn.net/u014743697) 												 		

​                                                          陈小春哭诉：塔山土豪怒砸2亿请他代言这款0充值传奇！真经典！             贪玩游戏 · 顶新                   

![img]()

[ 		 				快速掌握sinox2014激动人心的*ZFS*和RAID技术		 		 			 				 				 					阅读数  					4666 				 			 		](https://blog.csdn.net/sinox2010p1/article/details/38704845)

 			[ 				Sinox2014引入激动人心的zfs系统以及其支持的RAID，让用户快速打造廉价的高可靠性文件服务器。ZFS文件系统的英文名称为ZettabyteFileSystem,也叫动态文件系统（Dynami... 			](https://blog.csdn.net/sinox2010p1/article/details/38704845) 			 									博文 											[来自：	 欢迎来到最伟大的操作系统官方博客](https://blog.csdn.net/sinox2010p1) 												 		

[ 		 				*ZFS**文件系统*		 		 			 				 				 					阅读数  					18 				 			 		](https://blog.csdn.net/lxneng/article/details/83456174)

 			[ 				ZFS文件系统　　ZFS文件系统的英文名称为ZettabyteFileSystem,也叫动态文件系统（DynamicFileSystem）,是第一个128位文件系统。　　ZFS是基于存储池的，与典型的... 			](https://blog.csdn.net/lxneng/article/details/83456174) 			 									博文 											[来自：	 LOSTBOY's Blog](https://blog.csdn.net/lxneng) 												 		

[ 		 				如*何在* *Ubuntu* 上安装 Cinnamon 桌面环境 | *Linux* *中国*		 		 			 				 				 					阅读数  					727 				 			 		](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/82920534)

 			[ 				这篇教程将会为你展示如何在Ubuntu上安装Cinnamon桌面环境。--AbhishekPrakash有用的原文链接请访问文末的“原文链接”获得可点击的文内...... 			](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/82920534) 			 									博文 											[来自：	 技术无边](https://blog.csdn.net/F8qG7f9YD02Pe) 												 		

[ 		 				如何弄清 *Linux* 系统运行何种系统管理程序 | *Linux* *中国*		 		 			 				 				 					阅读数  					57 				 			 		](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/84039046)

 			[ 				Linux系统中主要有三种有名而仍在使用的初始化系统。大多数Linux发行版都使用其中之一。--PrakashSubramanian有用的原文链接请访问文末的“...... 			](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/84039046) 			 									博文 											[来自：	 技术无边](https://blog.csdn.net/F8qG7f9YD02Pe) 												 		

[ 		 				*ZFS**文件系统*（6） -- 自我恢复RAID		 		 			 				 				 					阅读数  					4707 				 			 		](https://blog.csdn.net/liuyun2113/article/details/9966031)

 			[ 				自我恢复RAID    这个给了我一个简单而又强大的理由，让我立马为之折服，ZFS可以自动的检测发生的错误，而且，可以自我修复这些错误。假设有一个时刻，磁盘阵列中的数据是错误的，不管是什么原因造成的，... 			](https://blog.csdn.net/liuyun2113/article/details/9966031) 			 									博文 											[来自：	 腾飞吧，海绵宝宝](https://blog.csdn.net/liuyun2113) 												 		

<iframe id="iframeu4623113_0" name="iframeu4623113_0" src="https://pos.baidu.com/lcvm?conwid=962&amp;conhei=84&amp;rdid=4623113&amp;dc=3&amp;exps=110011&amp;psi=baf6daaca7ec074f0a1b80a4dd100e4f&amp;di=u4623113&amp;dri=0&amp;dis=0&amp;dai=3&amp;ps=12089x407&amp;enu=encoding&amp;dcb=___adblockplus&amp;dtm=HTML_POST&amp;dvi=0.0&amp;dci=-1&amp;dpt=none&amp;tsr=0&amp;tpr=1567997008302&amp;ti=%E5%A6%82%E4%BD%95%E5%9C%A8%20Ubuntu%20%E4%B8%8A%E4%BD%BF%E7%94%A8%20ZFS%20%E6%96%87%E4%BB%B6%E7%B3%BB%E7%BB%9F%20%7C%20Linux%20%E4%B8%AD%E5%9B%BD%20-%20%E6%8A%80%E6%9C%AF%E6%97%A0%E8%BE%B9%20-%20CSDN%E5%8D%9A%E5%AE%A2&amp;ari=2&amp;dbv=0&amp;drs=1&amp;pcs=1263x589&amp;pss=1286x12142&amp;cfv=0&amp;cpl=0&amp;chi=1&amp;cce=true&amp;cec=UTF-8&amp;tlm=1567997011&amp;prot=2&amp;rw=606&amp;ltu=https%3A%2F%2Fblog.csdn.net%2FF8qG7f9YD02Pe%2Farticle%2Fdetails%2F79329762&amp;ltr=https%3A%2F%2Fwww.baidu.com%2Flink%3Furl%3D2hRvY1DO5loujOGgS7k-dc3XUXUa-YsqjS1HZm0ANfzlCarqfvypn6AYTx7NRinIP5iek8yzVIf4kUkbrkGVkDbCohOFAvEZV_OgZKjPGka%26wd%3D%26eqid%3D9116d7f700002fde000000025d75b82e&amp;ecd=1&amp;uc=1280x680&amp;pis=-1x-1&amp;sr=1280x720&amp;tcn=1567997012&amp;qn=d636e7c849b8c815&amp;tt=1567997008208.3313.3314.3314" vspace="0" hspace="0" marginwidth="0" marginheight="0" scrolling="no" style="border:0;vertical-align:bottom;margin:0;width:962px;height:84px" allowtransparency="true" width="962" height="84" frameborder="0" align="center,center"></iframe>
![img]()

[ 		 				详谈Lustre背后的故事，*ZFS*前世和今生		 		 			 				 				 					阅读数  					467 				 			 		](https://blog.csdn.net/BtB5e6Nsu1g511Eg5XEg/article/details/80788258)

 			[ 				   故事还得从SUN和Solaris说起。曾经有一个服务器巨头，它的名字叫SUN(SunMicrosystems)，给IT界带来过无限光明，无论是占据应用开发半...... 			](https://blog.csdn.net/BtB5e6Nsu1g511Eg5XEg/article/details/80788258) 			 									博文 											[来自：	 架构师技术联盟](https://blog.csdn.net/BtB5e6Nsu1g511Eg5XEg) 												 		

[ 		 				*ZFS**文件系统*介绍		 		 			 				 				 					阅读数  					2704 				 			 		](https://blog.csdn.net/changyanmanman/article/details/23202267)

 			[ 				什么是ZFS？ZFS(ZettabyteFileSystem)是由SUN公司的JeffBonwick领导设计的一种基于Solaris的文件系统，最初发布于20014年9月14日。SUN被Oracle收... 			](https://blog.csdn.net/changyanmanman/article/details/23202267) 			 									博文 											[来自：	 changyanmanman的专栏](https://blog.csdn.net/changyanmanman) 												 		

[ 		 				从零开始：Prometheus		 		 			 				 				 					阅读数  					2万+ 				 			 		](https://blog.csdn.net/qq_37843943/article/details/80510976)

 			[ 				Prometheus自定义监控SpringBoot项目一、关于PrometheusPrometheus是一套开源的监控系统，它将所有信息都存储为时间序列数据；因此实现一种Profiling监控方式，实... 			](https://blog.csdn.net/qq_37843943/article/details/80510976) 			 									博文 											[来自：	 ary的博客](https://blog.csdn.net/qq_37843943) 												 		

[ 		 				*ZFS*常用命令		 		 			 				 				 					阅读数  					4440 				 			 		](https://blog.csdn.net/wh62592855/article/details/6196790)

 			[ 				1.创建pool和ZFS文件系统：.创建文件系统，挂载在/export/home下    #zfs createtank/home   #zfs setmountpoint=/export/homet... 			](https://blog.csdn.net/wh62592855/article/details/6196790) 			 									博文 											[来自：	 朝着梦想 渐行前进](https://blog.csdn.net/wh62592855) 												 		

[ 		 				*ZFS*学习		 		 			 				 				 					阅读数  					7534 				 			 		](https://blog.csdn.net/dong976209075/article/details/7906687)

 			[ 				ZFS（ZettabyteFileSystem）源自于SunMicrosystems为Solaris操作系统开发的文件系统。ZFS是一个具有高存储容量、文件系统与卷管理概念整合、崭新的磁盘逻辑结构的轻... 			](https://blog.csdn.net/dong976209075/article/details/7906687) 			 									博文 											[来自：	 dong976209075的专栏](https://blog.csdn.net/dong976209075) 												 		

<iframe id="iframeu4623747_0" name="iframeu4623747_0" src="https://pos.baidu.com/lcvm?conwid=962&amp;conhei=84&amp;rdid=4623747&amp;dc=3&amp;exps=110011&amp;psi=baf6daaca7ec074f0a1b80a4dd100e4f&amp;di=u4623747&amp;dri=0&amp;dis=0&amp;dai=4&amp;ps=12583x407&amp;enu=encoding&amp;dcb=___adblockplus&amp;dtm=HTML_POST&amp;dvi=0.0&amp;dci=-1&amp;dpt=none&amp;tsr=0&amp;tpr=1567997008302&amp;ti=%E5%A6%82%E4%BD%95%E5%9C%A8%20Ubuntu%20%E4%B8%8A%E4%BD%BF%E7%94%A8%20ZFS%20%E6%96%87%E4%BB%B6%E7%B3%BB%E7%BB%9F%20%7C%20Linux%20%E4%B8%AD%E5%9B%BD%20-%20%E6%8A%80%E6%9C%AF%E6%97%A0%E8%BE%B9%20-%20CSDN%E5%8D%9A%E5%AE%A2&amp;ari=2&amp;dbv=0&amp;drs=1&amp;pcs=1263x589&amp;pss=1286x12636&amp;cfv=0&amp;cpl=0&amp;chi=1&amp;cce=true&amp;cec=UTF-8&amp;tlm=1567997011&amp;prot=2&amp;rw=606&amp;ltu=https%3A%2F%2Fblog.csdn.net%2FF8qG7f9YD02Pe%2Farticle%2Fdetails%2F79329762&amp;ltr=https%3A%2F%2Fwww.baidu.com%2Flink%3Furl%3D2hRvY1DO5loujOGgS7k-dc3XUXUa-YsqjS1HZm0ANfzlCarqfvypn6AYTx7NRinIP5iek8yzVIf4kUkbrkGVkDbCohOFAvEZV_OgZKjPGka%26wd%3D%26eqid%3D9116d7f700002fde000000025d75b82e&amp;ecd=1&amp;uc=1280x680&amp;pis=-1x-1&amp;sr=1280x720&amp;tcn=1567997012&amp;qn=0dc48143562e9908&amp;tt=1567997008208.3770.3771.3772" vspace="0" hspace="0" marginwidth="0" marginheight="0" scrolling="no" style="border:0;vertical-align:bottom;margin:0;width:962px;height:84px" allowtransparency="true" width="962" height="84" frameborder="0" align="center,center"></iframe>
![img]()

[ 		 				*zfs* 简单*使用*		 		 			 				 				 					阅读数  					4864 				 			 		](https://blog.csdn.net/Jack_Fun/article/details/9177025)

 			[ 				Linux服务器ZFS文件系统使用攻略      ZFS(ZettabyteFileSystem)作为一个全新的文件系统，全面抛弃传统FileSystem+VolumeManager+Storage(... 			](https://blog.csdn.net/Jack_Fun/article/details/9177025) 			 									博文 											[来自：	 Jack_Fun的专栏](https://blog.csdn.net/Jack_Fun) 												 		

​                                                                  [                         c# linq原理](https://www.csdn.net/gather_1b/NtjaMgxsLWRvd25sb2Fk.html)                                                                                       [                         c# 装箱有什么用](https://www.csdn.net/gather_1a/NtjaMgysLWRvd25sb2Fk.html)                                                                                       [                         c#集合 复制](https://www.csdn.net/gather_12/NtjaMgzsLWRvd25sb2Fk.html)                                                                                       [                         c# 一个字符串分组](https://www.csdn.net/gather_16/NtjaMg0sLWRvd25sb2Fk.html)                                                                                       [                         c++和c#哪个就业率高](https://www.csdn.net/gather_26/NtjaMg1sLWJsb2cO0O0O.html)                                                                                       [                         c# 批量动态创建控件](https://www.csdn.net/gather_1c/NtjaMg2sLWRvd25sb2Fk.html)                                                                                       [                         c# 模块和程序集的区别](https://www.csdn.net/gather_1a/NtjaMg3sLWRvd25sb2Fk.html)                                                                                       [                         c# gmap 截图](https://www.csdn.net/gather_14/NtjaMg4sLWRvd25sb2Fk.html)                                                                                       [                         c# 验证码图片生成类](https://www.csdn.net/gather_14/NtjaQgwsLWRvd25sb2Fk.html)                                                                                       [                         c# 再次尝试 连接失败](https://www.csdn.net/gather_16/NtjaQgxsLWRvd25sb2Fk.html)                                                              

​             [               ![img](https://avatar.csdn.net/0/C/B/3_f8qg7f9yd02pe.jpg)                               ![img](https://g.csdnimg.cn/static/user-reg-year/2x/2.png)                           ](https://blog.csdn.net/F8qG7f9YD02Pe)                      

​                 [技术无边](https://blog.csdn.net/F8qG7f9YD02Pe)             

[TA的个人主页 >](https://me.csdn.net/F8qG7f9YD02Pe)

​             [私信](https://www.csdn.net/apps/download/?code=app_1564993662&callback=csdnapp%3A%2F%2Fweb%3Furl%3Dhttps%3A%2F%2Fapp.csdn.net%2Fother%3Fusername%3DF8qG7f9YD02Pe)         

​                                                  关注                                      

- [原创](https://blog.csdn.net/f8qg7f9yd02pe?t=1)

  [1555](https://blog.csdn.net/f8qg7f9yd02pe?t=1)

- 粉丝

  575

- 喜欢

  426

- 评论

  174

- 等级：

  ​                 [                                                                                    ](https://blog.csdn.net/home/help.html#level)             

- 访问：

  ​                 93万+            

- 积分：

  ​                 8402            

- 排名：

  4414

勋章：

​                           ![img](https://g.csdnimg.cn/static/user-medal/chizhiyiheng.svg)                                                   

​                           ![img](https://g.csdnimg.cn/static/user-medal/1024huodong.svg)                                                   

​                           ![img](https://g.csdnimg.cn/static/user-medal/qinxiebiaobing_l4_t4.svg)                                                   

<iframe id="iframeu3032528_0" name="iframeu3032528_0" src="https://pos.baidu.com/lcvm?conwid=300&amp;conhei=250&amp;rdid=3032528&amp;dc=3&amp;exps=110011&amp;psi=baf6daaca7ec074f0a1b80a4dd100e4f&amp;di=u3032528&amp;dri=0&amp;dis=0&amp;dai=5&amp;ps=336x75&amp;enu=encoding&amp;dcb=___adblockplus&amp;dtm=HTML_POST&amp;dvi=0.0&amp;dci=-1&amp;dpt=none&amp;tsr=0&amp;tpr=1567997008302&amp;ti=%E5%A6%82%E4%BD%95%E5%9C%A8%20Ubuntu%20%E4%B8%8A%E4%BD%BF%E7%94%A8%20ZFS%20%E6%96%87%E4%BB%B6%E7%B3%BB%E7%BB%9F%20%7C%20Linux%20%E4%B8%AD%E5%9B%BD%20-%20%E6%8A%80%E6%9C%AF%E6%97%A0%E8%BE%B9%20-%20CSDN%E5%8D%9A%E5%AE%A2&amp;ari=2&amp;dbv=0&amp;drs=1&amp;pcs=1263x589&amp;pss=1286x12891&amp;cfv=0&amp;cpl=0&amp;chi=1&amp;cce=true&amp;cec=UTF-8&amp;tlm=1567997012&amp;prot=2&amp;rw=606&amp;ltu=https%3A%2F%2Fblog.csdn.net%2FF8qG7f9YD02Pe%2Farticle%2Fdetails%2F79329762&amp;ltr=https%3A%2F%2Fwww.baidu.com%2Flink%3Furl%3D2hRvY1DO5loujOGgS7k-dc3XUXUa-YsqjS1HZm0ANfzlCarqfvypn6AYTx7NRinIP5iek8yzVIf4kUkbrkGVkDbCohOFAvEZV_OgZKjPGka%26wd%3D%26eqid%3D9116d7f700002fde000000025d75b82e&amp;ecd=1&amp;uc=1280x680&amp;pis=-1x-1&amp;sr=1280x720&amp;tcn=1567997013&amp;qn=6bb2f2334f1fa091&amp;tt=1567997008208.4403.4404.4405" vspace="0" hspace="0" marginwidth="0" marginheight="0" scrolling="no" style="border:0;vertical-align:bottom;margin:0;width:300px;height:250px" allowtransparency="true" width="300" height="250" frameborder="0" align="center,center"></iframe>
![img](https://kunyu.csdn.net/1.png?p=56&a=76&c=0&k=&d=1&t=3)

### 最新文章

- ​                 [                                         5 个开源的速读应用 | Linux 中国                ](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/100613204)             
- ​                 [                                         从 Yum 更新中排除特定/某些包的三种方法 | Linux 中国                ](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/100613201)             
- ​                 [                                         Bash shell 的诞生 | Linux 中国                ](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/100613199)             
- ​                 [                                         如何更改 Linux 终端颜色主题 | Linux 中国                ](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/100588878)             
- ​                 [                                         5 个 Ansible 运维任务 | Linux 中国                ](https://blog.csdn.net/F8qG7f9YD02Pe/article/details/100588876)             

### 归档

- ​                 [                     2019年9月                    20篇                 ](https://blog.csdn.net/f8qg7f9yd02pe/article/month/2019/09)             
- ​                 [                     2019年8月                    110篇                 ](https://blog.csdn.net/f8qg7f9yd02pe/article/month/2019/08)             
- ​                 [                     2019年7月                    119篇                 ](https://blog.csdn.net/f8qg7f9yd02pe/article/month/2019/07)             
- ​                 [                     2019年6月                    109篇                 ](https://blog.csdn.net/f8qg7f9yd02pe/article/month/2019/06)             
- ​                 [                     2019年5月                    119篇                 ](https://blog.csdn.net/f8qg7f9yd02pe/article/month/2019/05)             
- ​                 [                     2019年4月                    128篇                 ](https://blog.csdn.net/f8qg7f9yd02pe/article/month/2019/04)             
- ​                 [                     2019年3月                    119篇                 ](https://blog.csdn.net/f8qg7f9yd02pe/article/month/2019/03)             
- ​                 [                     2019年2月                    100篇                 ](https://blog.csdn.net/f8qg7f9yd02pe/article/month/2019/02)             
- ​                 [                     2019年1月                    118篇                 ](https://blog.csdn.net/f8qg7f9yd02pe/article/month/2019/01)             
- ​                 [                     2018年12月                    141篇                 ](https://blog.csdn.net/f8qg7f9yd02pe/article/month/2018/12)             
- ​                 [                     2018年11月                    149篇                 ](https://blog.csdn.net/f8qg7f9yd02pe/article/month/2018/11)             
- ​                 [                     2018年10月                    144篇                 ](https://blog.csdn.net/f8qg7f9yd02pe/article/month/2018/10)             
- ​                 [                     2018年9月                    128篇                 ](https://blog.csdn.net/f8qg7f9yd02pe/article/month/2018/09)             
- ​                 [                     2018年8月                    106篇                 ](https://blog.csdn.net/f8qg7f9yd02pe/article/month/2018/08)             
- ​                 [                     2018年7月                    122篇                 ](https://blog.csdn.net/f8qg7f9yd02pe/article/month/2018/07)             
- ​                 [                     2018年6月                    90篇                 ](https://blog.csdn.net/f8qg7f9yd02pe/article/month/2018/06)             
- ​                 [                     2018年5月                    68篇                 ](https://blog.csdn.net/f8qg7f9yd02pe/article/month/2018/05)             
- ​                 [                     2018年4月                    161篇                 ](https://blog.csdn.net/f8qg7f9yd02pe/article/month/2018/04)             
- ​                 [                     2018年3月                    136篇                 ](https://blog.csdn.net/f8qg7f9yd02pe/article/month/2018/03)             
- ​                 [                     2018年2月                    123篇                 ](https://blog.csdn.net/f8qg7f9yd02pe/article/month/2018/02)             
- ​                 [                     2018年1月                    140篇                 ](https://blog.csdn.net/f8qg7f9yd02pe/article/month/2018/01)             
- ​                 [                     2017年12月                    98篇                 ](https://blog.csdn.net/f8qg7f9yd02pe/article/month/2017/12)             

​         展开     

### 热门文章

- ​                                                 哪一种 Ubuntu 官方版本最适合你？ | Linux 中国                    

  阅读数 48559

- ​                                                 直接保存文件至 Google Drive 并用十倍的速度下载回来 | Linux 中国                    

  阅读数 21291

- ​                                                 微服务和容器：需要去防范的 5 个“坑” | Linux 中国                    

  阅读数 20842

- ​                                                 每位 Ubuntu 18.04 用户都应该知道的快捷键 | Linux 中国                    

  阅读数 18453

- ​                                                 Linux 中 4 个简单的找出进程 ID（PID）的方法 | Linux 中国                    

  阅读数 14477

### 最新评论

- 解密 ACRN：一个专为物联网而设...

  ​                     [qq_33406883：](https://my.csdn.net/qq_33406883)文不对题吧？                

- 直接保存文件至 Google Dr...

  ​                     [NICK1224112287：](https://my.csdn.net/NICK1224112287)要钱                

- 在你开始使用 Kali Linux...

  ​                     [qq_45091530：](https://my.csdn.net/qq_45091530)我还正准备安装呢![img](https://g.csdnimg.cn/static/face/monkey/2.gif)![img](https://g.csdnimg.cn/static/face/monkey/2.gif)，我现在有点慌                

- 如何在 Linux 中查看已挂载的...

  ​                     [CYLiberty：](https://my.csdn.net/CYLiberty)老哥，白底荧光绿看得眼睛不干嘛？                

- Linux 下如何修改用户名（同时...

  ​                     [qq_43463634：](https://my.csdn.net/qq_43463634)你好   修改家目录这条是怎么用的，我怎么一直出错，显示用户被进程17669占用                

<iframe id="iframeu3163270_0" name="iframeu3163270_0" src="https://pos.baidu.com/lcvm?conwid=300&amp;conhei=250&amp;rdid=3163270&amp;dc=3&amp;exps=110011&amp;psi=baf6daaca7ec074f0a1b80a4dd100e4f&amp;di=u3163270&amp;dri=0&amp;dis=0&amp;dai=6&amp;ps=1962x75&amp;enu=encoding&amp;dcb=___adblockplus&amp;dtm=HTML_POST&amp;dvi=0.0&amp;dci=-1&amp;dpt=none&amp;tsr=0&amp;tpr=1567997008302&amp;ti=%E5%A6%82%E4%BD%95%E5%9C%A8%20Ubuntu%20%E4%B8%8A%E4%BD%BF%E7%94%A8%20ZFS%20%E6%96%87%E4%BB%B6%E7%B3%BB%E7%BB%9F%20%7C%20Linux%20%E4%B8%AD%E5%9B%BD%20-%20%E6%8A%80%E6%9C%AF%E6%97%A0%E8%BE%B9%20-%20CSDN%E5%8D%9A%E5%AE%A2&amp;ari=2&amp;dbv=0&amp;drs=1&amp;pcs=1263x589&amp;pss=1286x12891&amp;cfv=0&amp;cpl=0&amp;chi=1&amp;cce=true&amp;cec=UTF-8&amp;tlm=1567997012&amp;prot=2&amp;rw=606&amp;ltu=https%3A%2F%2Fblog.csdn.net%2FF8qG7f9YD02Pe%2Farticle%2Fdetails%2F79329762&amp;ltr=https%3A%2F%2Fwww.baidu.com%2Flink%3Furl%3D2hRvY1DO5loujOGgS7k-dc3XUXUa-YsqjS1HZm0ANfzlCarqfvypn6AYTx7NRinIP5iek8yzVIf4kUkbrkGVkDbCohOFAvEZV_OgZKjPGka%26wd%3D%26eqid%3D9116d7f700002fde000000025d75b82e&amp;ecd=1&amp;uc=1280x680&amp;pis=-1x-1&amp;sr=1280x720&amp;tcn=1567997013&amp;qn=351b683cd0ed47a0&amp;tt=1567997008208.4660.4660.4660" vspace="0" hspace="0" marginwidth="0" marginheight="0" scrolling="no" style="border:0;vertical-align:bottom;margin:0;width:300px;height:250px" allowtransparency="true" width="300" height="250" frameborder="0" align="center,center"></iframe>
![img](https://kunyu.csdn.net/1.png?p=57&a=77&c=0&k=&d=1&t=3)

[![CSDN学院](https://csdnimg.cn/pubfooter/images/edu-QR.png)](https://edu.csdn.net?utm_source=csdn_footer)

CSDN学院

![CSDN企业招聘](https://csdnimg.cn/pubfooter/images/job-QR.png)

CSDN企业招聘



[kefu@csdn.net](mailto:webmaster@csdn.net)



*客服论坛*

[关于我们](https://www.csdn.net/company/index.html#about)[招聘](https://www.csdn.net/company/index.html#recruit)[广告服务](https://www.csdn.net/company/index.html#contact)            [            网站地图](https://www.csdn.net/gather/A)



[*百度提供站内搜索*](https://zn.baidu.com/cse/home/index) [京ICP备19004658号](http://www.miibeian.gov.cn/publish/query/indexFirst.action)

©1999-2019 北京创新乐知网络技术有限公司 

[经营性网站备案信息](https://csdnimg.cn/cdn/content-toolbar/csdn-ICP.png)        *网络110报警服务*

[北京互联网违法和不良信息举报中心](http://www.bjjubao.org/)

[中国互联网举报中心](http://www.12377.cn/)[家长监护](https://download.csdn.net/index.php/tutelage/)[版权申诉](https://blog.csdn.net/blogdevteam/article/details/90369522)

-  			

-  					 				

   				

   			 					

-  					 				

   										

-  			 				 				 					 				 					 				 			 		

- ​          				 					 				 				 			

-  				[ 					 						 					 					 				](https://blog.csdn.net/f8qg7f9yd02pe/article/details/79329761) 			

-  			[ 				 					 				 				 			](https://blog.csdn.net/f8qg7f9yd02pe/article/details/79329763) 		



[![img](https://g.csdnimg.cn/side-toolbar/1.4/images/vip.png)VIP
免广告](https://mall.csdn.net/vip)                      ![img](https://g.csdnimg.cn/side-toolbar/1.6/images/qr.png)       手



#查看当前存储池挂载状态
zfs list

#查看当前存储池状态
zpool status

#使用 sdb、sdc、sdd 这几块硬盘创建一个名为 senra-zfs的池
zpool create senra-zfs sdb sdc sdd
#可以使用-f启用强制模式，这个在正常的创建中没有必要，如果碰到你要创建raidz或者mirror类型的池，那么这个可以帮助你忽略由于添加的硬盘容量不相等导致的错误提示

#查看存储池 senra-zfs 的一些信息
zpool get all senra-zfs

#将硬盘 sde 添加到池 senra-zfs 中
zpool add senra-zfs sde

#使用硬盘 sdf 替换 senra-zfs 池中的 sde
zpool replace senra-zfs sde sdf

#检测池 senra-zfs 是否存在问题
zpool scrub senra-zfs

#查看池 senra-zfs 的IO使用状况，可以加 -v 来详细到池所拥有的每块磁盘
zpool iostat senra-zfs





 	**管理**  

 ZFS主要有两个工具，zpool和ZFS。zpool处理使用磁盘实用程序创建和维护ZFS池负责数据的创建和维护。 

 	**zpool utility**  

 创建和销毁池 首先验证可用的磁盘创建一个存储池。 

```
[root@li1467-130 ~]# ls -l /dev/sd*
brw-rw---- 1 root disk 8,  0  Mar 16 08:12 /dev/sda
brw-rw---- 1 root disk 8, 16 Mar 16 08:12 /dev/sdb
brw-rw---- 1 root disk 8, 32 Mar 16 08:12 /dev/sdc
brw-rw---- 1 root disk 8, 48 Mar 16 08:12 /dev/sdd
brw-rw---- 1 root disk 8, 64 Mar 16 08:12 /dev/sde
brw-rw---- 1 root disk 8, 80 Mar 16 08:12 /dev/sdf
```

 创建一个池的驱动器。 

```
zpool create  [root@li1467-130 ~]# zpool status
pool: zfspool
state: ONLINE
scan: none requested
config:
NAME STATE READ WRITE CKSUM
zfspool ONLINE 0 0 0
sdc ONLINE 0 0 0
sdd ONLINE 0 0 0
sde ONLINE 0 0 0
sdf ONLINE 0 0 0
errors: No known data errors
```

 验证如果池创建成功。 

```
[root@li1467-130 ~]# df -h
Filesystem    Size   Used      Avail  Use%   Mounted on
/dev/sda      19G    1.4G        17G      8%      /
devtmpfs    488M        0      488M      0%     /dev
tmpfs          497M        0      497M      0%    /dev/shm
tmpfs          497M    50M     447M     11%   /run
tmpfs          497M         0     497M      0%   /sys/fs/cgroup
tmpfs          100M         0     100M      0%   /run/user/0
zfspool         3.7G         0       3.7G      0%  /zfspoolv
```

 如你所见,使用zpool创造了一个池的名字zfspool大小3.7 GB的空间,同时挂载在/ zfspool。 用命令 'zpool destroy' 销毁一个地址池： 

```
zpool destroy 
[root@li1467-130 ~]# zpool destroy zfspool
[root@li1467-130 ~]# zpool status
no pools available
```

 现在让我们尝试创建一个简单的镜像池。 

```
zpool create   mirror  ... 
```

 通过重复关键字的驱动器我们可以创建多个镜像。 

```
[root@li1467-130 ~]# zpool create -f mpool mirror sdc sdd mirror sde sdf
[root@li1467-130 ~]# zpool status
pool: mpool
state: ONLINE
scan: none requested
config:
NAME STATE READ WRITE CKSUM
mpool ONLINE 0 0 0
mirror-0 ONLINE 0 0 0
sdc ONLINE 0 0 0
sdd ONLINE 0 0 0
mirror-1 ONLINE 0 0 0
sde ONLINE 0 0 0
sdf ONLINE 0 0 0
errors: No known data errors
```

 在上面的例子中,我们创建了每两个磁盘镜像池。 同样的,我们可以创建一个raidz池。 

```
[root@li1467-130 ~]# zpool create -f rpool raidz sdc sdd sde sdf
[root@li1467-130 ~]# zpool status
pool: rpool
state: ONLINE
scan: none requested
config:
NAME STATE READ WRITE CKSUM
rpool ONLINE 0 0 0
raidz1-0 ONLINE 0 0 0
sdc ONLINE 0 0 0
sdd ONLINE 0 0 0
sde ONLINE 0 0 0
sdf ONLINE 0 0 0
errors: No known data errors
```

 	**在ZFS池管理设备**  

 一旦创建一个池,从池中可以添加或删除热备件和缓存设备,从镜像池和替换设备中连接或者分离。但是冗余和raidz设备不能从池中删除。我们将看到如何在这一节中执行这些操作。 我首先创建一个池称为“testpool”组成的两个设备,sdc和sdd。另一个设备sde将被添加到这里。 

```
[root@li1467-130 ~]# zpool create -f testpool sdc sdd
[root@li1467-130 ~]# zpool add testpool sde
[root@li1467-130 ~]# zpool status
pool: testpool
state: ONLINE
scan: none requested
config:
NAME STATE READ WRITE CKSUM
testpool ONLINE 0 0 0
sdc ONLINE 0 0 0
sdd ONLINE 0 0 0
sde ONLINE 0 0 0
errors: No known data errors
```

 正如前面提到的，我不能删除这个新添加的设备,因为它不是一个冗余或raidz池。 

```
[root@li1467-130 ~]# zpool remove testpool sde
cannot remove sde: only inactive hot spares, cache, top-level, or log devices can be removed
```

 但我可以在这个池添加一个空闲磁盘和删除它。 

```
[root@li1467-130 ~]# zpool add testpool spare sdf
[root@li1467-130 ~]# zpool status
pool: testpool
state: ONLINE
scan: none requested
config:
NAME STATE READ WRITE CKSUM
testpool ONLINE 0 0 0
sdc ONLINE 0 0 0
sdd ONLINE 0 0 0
sde ONLINE 0 0 0
spares
sdf AVAIL
errors: No known data errors
[root@li1467-130 ~]# zpool remove testpool sdf
[root@li1467-130 ~]# zpool status
pool: testpool
state: ONLINE
scan: none requested
config:
NAME        STATE       READ  WRITE   CKSUM
testpool    ONLINE       0          0               0
sdc            ONLINE       0           0               0
sdd            ONLINE      0            0               0
sde            ONLINE      0            0               0
errors: No known data errors
```

 同样的,我们可以使用attach命令附加磁盘镜像或非镜像的池和detach命令从镜像磁盘池来分离。 

```
zpool attach    
zpool detach  
```

 当设备发生故障或损坏,我们可以使用replace命令替换它。 

```
zpool replace    
```

 在镜像配置当中我们将爆力的测试一个设备。 

```
[root@li1467-130 ~]# zpool create -f testpool mirror sdd sde
```

 这将创建一个镜像磁盘池组成的SDD和SDE。现在，让我们故意损坏SDD写零到磁盘中。 

```
[root@li1467-130 ~]# dd if=/dev/zero of=/dev/sdd
dd: writing to ‘/dev/sdd’: No space left on device
2048001+0 records in
2048000+0 records out
1048576000 bytes (1.0 GB) copied, 22.4804 s, 46.6 MB/s
```

 我们将使用“scrub”命令来检测这种损坏。 

```
[root@li1467-130 ~]# zpool scrub testpool
[root@li1467-130 ~]# zpool status
pool: testpool
state: ONLINE
status: One or more devices could not be used because the label is missing or
invalid. Sufficient replicas exist for the pool to continue
functioning in a degraded state.
action: Replace the device using 'zpool replace'.
see: http://zfsonlinux.org/msg/ZFS-8000-4J
scan: scrub repaired 0 in 0h0m with 0 errors on Fri Mar 18 09:59:40 2016
config:
NAME STATE READ WRITE CKSUM
testpool ONLINE 0 0 0
mirror-0 ONLINE 0 0 0
sdd UNAVAIL 0 0 0 corrupted data
sde ONLINE 0 0 0
errors: No known data errors
```

 现在我们用SDC替换SDD。 

```
[root@li1467-130 ~]# zpool replace testpool sdd sdc; zpool status
pool: testpool
state: ONLINE
scan: resilvered 83.5K in 0h0m with 0 errors on Fri Mar 18 10:05:17 2016
config:
NAME STATE READ WRITE CKSUM
testpool ONLINE 0 0 0
mirror-0 ONLINE 0 0 0
replacing-0 UNAVAIL 0 0 0
sdd UNAVAIL 0 0 0 corrupted data
sdc ONLINE 0 0 0
sde ONLINE 0 0 0
errors: No known data errors
[root@li1467-130 ~]# zpool status
pool: testpool
state: ONLINE
scan: resilvered 74.5K in 0h0m with 0 errors on Fri Mar 18 10:00:36 2016
config:
NAME STATE READ WRITE CKSUM
testpool ONLINE 0 0 0
mirror-0 ONLINE 0 0 0
sdc ONLINE 0 0 0
sde ONLINE 0 0 0
errors: No known data errors
```

 	**池的迁移**  

 我们可以使用导出和导入命令在不同的主机之间迁移存储池。对于这个，在池中使用的磁盘应该从两个系统中可用。 

```
[root@li1467-130 ~]# zpool export testpool
[root@li1467-130 ~]# zpool status
no pools available
```

 zpool import命令列出所有可以利用的池。执行这个系统命令,你想要导入的池。 

```
[root@li1467-131 ~]# zpool import
pool: testpool
id: 3823664125009563520
state: ONLINE
action: The pool can be imported using its name or numeric identifier.
config:
testpool ONLINE
sdc ONLINE
sdd ONLINE
sde ONLINE
```

 现在导入要求的池。 

```
[root@li1467-131 ~]# zpool import testpool
[root@li1467-131 ~]# zpool status
pool: testpool
state: ONLINE
scan: none requested
config:
NAME STATE READ WRITE CKSUM
testpool ONLINE 0 0 0
sdc ONLINE 0 0 0
sdd ONLINE 0 0 0
sde ONLINE 0 0 0
errors: No known data errors
```

 	**iostat**  

 Iostat命令可以验证池设备IO统计。 

```
[root@li1467-130 ~]# zpool iostat -v testpool
capacity          operations                        bandwidth
pool          alloc      free            read     write             read   write
----------    -----     -----            -----     -----                -----   -----
testpool    1.80M  2.86G        22            27               470K  417K
sdc             598K   975M           8              9               200K  139K
sdd             636K  975M            7              9                135K  139K
sde             610K   975M           6              9                 135K 139K
----------   -----     -----           -----          -----               -----  -----
```

 	**zfs utility**  

 我们现在会移动到ZFS utility。在这里，我们将看看如何创建、销毁数据集、文件系统压缩、配额和快照。 

 	**创建和销毁文件系统**  

 ZFS文件系统可以使用ZFS创建命令创建 

```
zfs create 
[root@li1467-130 ~]# zfs create testpool/students
[root@li1467-130 ~]# zfs create testpool/professors
[root@li1467-130 ~]# df -h
Filesystem                    Size             Used          Avail          Use%          Mounted on
/dev/sda                       19G              1.4G          17G             8%                     /
devtmpfs                   488M                  0      488M             0%                    /dev
tmpfs                          497M                  0       497M            0%                   /dev/shm
tmpfs                          497M            50M       447M           11%                  /run
tmpfs                          497M                 0        497M            0%                /sys/fs/cgroup
testpool                       2.8G                  0         2.8G            0%               /testpool
tmpfs                          100M                  0        100M            0%             /run/user/0
testpool/students     2.8G                   0         2.8G             0%            /testpool/students
testpool/professors  2.8G                   0         2.8G             0%           /testpool/professors
```

 从上面的输出注意到，在文件系统创建时尽管没有挂载点,挂载点创建时使用相同的路径关系池。 ZFS创建允许使用-o选项可以指定使用像挂载点，压缩、定额、执行等。 你可以列出可用的文件系统使用ZFS的列表： 

```
[root@li1467-130 ~]# zfs list
NAME                           USED     AVAIL     REFER    MOUNTPOINT
testpool                         100M       2.67G       19K         /testpool
testpool/professors        31K     1024M   20.5K        /testpool/professors
testpool/students        1.57M     98.4M   1.57M      /testpool/students
```

 我们用销毁选项销毁文件系统。 zfs destroy 

 	**压缩**  

 现在我们将了解在ZFS怎样压缩，在我们开始使用压缩之前,我们需要使它使用“设置压缩”。 

```
zfs set  
```

 一旦这样做，压缩和解压缩将以透明模式发生在文件系统上面。 在我们的示例中,我将使学生目录使用lz4压缩算法压缩。 

```
[root@li1467-130 ~]# zfs set compression=lz4 testpool/students
```

 我现在要复制一个文件到该文件系统大小15m，并检查它的大小。 

```
[root@li1467-130 /]# cd /var/log
[root@li1467-130 log]# du -h secure
15M secure
[root@li1467-130 ~]# cp /var/log/secure /testpool/students/
[root@li1467-130 students]# df -h .
Filesystem               Size     Used   Avail    Use%      Mounted on
testpool/students   100M   1.7M   99M        2%      /testpool/students
```

 注意，使用文件系统的大小仅为1.7m，文件大小为15m，我们可以检查压缩比。 

```
[root@li1467-130 ~]# zfs get compressratio testpool
NAME      PROPERTY         VALUE            SOURCE
testpool    compressratio     9.03x     
```

 配额和预订 让我用一个真实的例子来解释配额。假设我们有一个要求，在一所大学，以限制磁盘空间使用的文件系统为教授和学生。让我们假设我们需要分配给教授和学生分为1GB和100MB。我们可以利用“配额”在ZFS来满足这一要求。配额确保文件系统使用的磁盘空间的数量不超过规定的限度。保留有助于在实际分配和保证所需的磁盘空间的数量是可用的文件系统。 

```
zfs set quota= 
zfs set reservation= 
[root@li1467-130 ~]# zfs set quota=100M testpool/students
[root@li1467-130 ~]# zfs set reservation=100M testpool/students
[root@li1467-130 ~]# zfs list
NAME                          USED      AVAIL    REFER    MOUNTPOINT
testpool                        100M       2.67G       19K        /testpool
testpool/professors      19K       2.67G        19K       /testpool/professors
testpool/students      1.57M       98.4M    1.57M    /testpool/students
[root@li1467-130 ~]# zfs set quota=1G testpool/professors
[root@li1467-130 ~]# zfs list
NAME                           USED     AVAIL    REFER    MOUNTPOINT
testpool                         100M     2.67G       19K          /testpool
testpool/professors       19K    1024M       19K         /testpool/professors
testpool/students       1.57M    98.4M    1.57M       /testpool/students
```

 在上面的例子中，我们已经给教授和学生为1GB与100MB。观察ZFS列表结果，最初，他们有2.67gb每个的大小和设置配额，价值也随之发生了相应的变化。 

 	**快照**  

 快照是在某个时间点的ZFS文件系统的只读副本。他们不在ZFS池消耗任何额外的空间。我们可以回滚到相同的状态，在稍后的阶段，按用户要求或仅提取一个单一的或一组文件。 我现在就从我们前面的例子，然后在在testpool/professors把这个文件系统快照创建一些目录和文件。 

```
[root@li1467-130 ~]# cd /testpool/professors/
[root@li1467-130 professors]# mkdir maths physics chemistry
[root@li1467-130 professors]# cat > qpaper.txt
Question paper for the year 2016-17
[root@li1467-130 professors]# ls -la
total 4
drwxr-xr-x  5  root root    6   Mar 19 10:34 .
drwxr-xr-x  4  root root    4   Mar 19 09:59 ..
drwxr-xr-x  2  root root    2   Mar 19 10:33 chemistry
drwxr-xr-x  2  root root    2   Mar 19 10:32 maths
drwxr-xr-x  2  root root    2   Mar 19 10:32 physics
-rw-r--r--     1  root root  36   Mar 19 10:35 qpaper.txt
```

 快照,可以使用下面的语法: 

```
zfs snapshot 
[root@li1467-130 professors]# zfs snapshot testpool/professors@03-2016
[root@li1467-130 professors]# zfs list -t snapshot
NAME                                             USED         AVAIL     REFER     MOUNTPOINT
testpool/professors@03-2016       0                -                20.5K   
```

 我现在将删除创建的文件和提取的快照。 

```
[root@li1467-130 professors]# rm -rf qpaper.txt
[root@li1467-130 professors]# ls
chemistry maths physics
[root@li1467-130 professors]# cd .zfs
[root@li1467-130 .zfs]# cd snapshot/03-2016/
[root@li1467-130 03-2016]# ls
chemistry maths physics qpaper.txt
[root@li1467-130 03-2016]# cp -a qpaper.txt /testpool/professors/
[root@li1467-130 03-2016]# cd /testpool/professors/
[root@li1467-130 professors]# ls
chemistry maths physics qpaper.txt
```

 已删除的文件返回其位置。 我们可以列出所有可用的快照使用ZFS的列表： 

```
[root@li1467-130 ~]# zfs list -t snapshot
NAME                                             USED     AVAIL    REFER    MOUNTPOINT
testpool/professors@03-2016    10.5K       -              20.5K       -
```

 最后,让我们使用zfs摧毁命令销毁快照： 

```
zfs destroy 
 
[root@li1467-130 ~]# zfs destroy testpool/professors@03-2016
[root@li1467-130 ~]# zfs list -t snapshot
no datasets available
```







### ZFS 与其他文件系统有哪些区别？

设计初衷是：处理海量存储和避免数据损坏。ZFS 可以处理 256 千万亿的 ZB 数据。（这就是 ZFS 的 Z）且它可以处理最大 16 EB 的文件。

ZFS 为磁盘上的每个文件分配一个校验和。它会不断的校验文件的状态和校验和。如果发现文件被损坏了，它就会尝试修复文件。

注：请谨记 ZFS 的数据保护特性会导致性能下降。

#### 创建一个 ZFS 池

**这段仅针对拥有多个磁盘的系统。如果你只有一个磁盘，Ubuntu 会在安装的时候自动创建池。**

在创建池之前，你需要为池找到磁盘的 id。你可以用命令 `lsblk` 查询出这个信息。

为三个磁盘创建一个基础池，用以下命令：

```
sudo zpool create pool-test /dev/sdb /dev/sdc /dev/sdd
```

请记得替换 `pool-test` 为你选择的的命名。

这个命令将会设置“无冗余 RAID-0 池”。这意味着如果一个磁盘被破坏或有故障，你将会丢失数据。如果你执行以上命令，还是建议做一个常规备份。

你可以用下面命令将另一个磁盘增加到池中：

```
sudo zpool add pool-name /dev/sdx
```

#### 查看 ZFS 池的状态

你可以用这个命令查询新建池的状态：

```
sudo zpool status pool-test
```

![Zpool 状态](https://img.linux.net.cn/data/attachment/album/201911/21/081614bkaa04jjkjgsjxyj.png)

*Zpool 状态*

#### 镜像一个 ZFS 池

为确保数据的安全性，你可以创建镜像。镜像意味着每个磁盘包含同样的数据。使用镜像设置，你可能会丢失三个磁盘中的两个，并且仍然拥有所有信息。

要创建镜像你可以用下面命令：

```
sudo zpool create pool-test mirror /dev/sdb /dev/sdc /dev/sdd
```

#### 创建 ZFS 用于备份恢复的快照

快照允许你创建一个后备，以防某个文件被删除或被覆盖。比如，我们创建一个快照，当在用户主目录下删除一些目录后，然后把它恢复。

首先，你需要找到你想要的快照数据集。你可以这样做：

```
zfs list
```

![Zfs List](https://img.linux.net.cn/data/attachment/album/201911/21/081616d4qfpf5l50fwal0a.png)

*Zfs List*

你可以看到我的家目录位于 `rpool/USERDATA/johnblood_uwcjk7`。

我们用下面命令创建一个名叫 `1910` 的快照：

```
sudo zfs snapshot rpool/USERDATA/johnblood_uwcjk7@1019
```

快照很快创建完成。现在你可以删除 `Downloads` 和 `Documents` 目录。

现在你用以下命令恢复快照：

```
sudo zfs rollback rpool/USERDATA/johnblood_uwcjk7@1019
```

回滚的时间长短取决于有多少信息改变。现在你可以查看家目录，被删除的目录（和它的内容）将会被恢复过来。

