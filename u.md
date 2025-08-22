2016 年十大顶级开源项目

Atom

Eclipse Che

FreeCAD

GnuCash

KMyMoney

Kodi

MyCollab

OpenAPS

OpenHAB

OpenToonz

Roundcube



在上个世纪70年代，贝尔实验室的 [Ken Thompson](http://genius.cat-v.org/ken-thompson/) 和 [Dennis M. Ritchie](http://genius.cat-v.org/dennis-ritchie/) 合作发明了 [UNIX](http://doc.cat-v.org/unix/) 操作系统，同时 [Dennis M. Ritchie](http://genius.cat-v.org/dennis-ritchie/) 为了解决 [UNIX](http://doc.cat-v.org/unix/) 系统的移植性问题而发明了 C 语言，贝尔实验室的 [UNIX](http://doc.cat-v.org/unix/) 和 C 语言两大发明奠定了整个现代IT行业最重要的软件基础（目前的三大桌面操作系统的中[Linux](http://www.linux.org/)和[Mac OS X](http://www.apple.com/cn/osx/)都是源于 [UNIX](http://doc.cat-v.org/unix/) 系统，两大移动平台的操作系统 iOS 和 Android 也都是源于 [UNIX](http://doc.cat-v.org/unix/) 系统。C 系家族的编程语言占据统治地位达几十年之久）。在 [UNIX](http://doc.cat-v.org/unix/) 和 C 语言发明40年之后，目前已经在 Google 工作的 [Ken Thompson](http://genius.cat-v.org/ken-thompson/) 和 [Rob Pike](http://genius.cat-v.org/rob-pike/)（他们在贝尔实验室时就是同事）、还有[Robert Griesemer](http://research.google.com/pubs/author96.html)（设计了 V8 引擎和 HotSpot 虚拟机）一起合作，为了解决在21世纪多核和网络化环境下越来越复杂的编程问题而发明了 Go 语言。从 Go 语言库早期代码库日志可以看出它的演化历程（ Git 用 `git log --before={2008-03-03} --reverse` 命令查看）：

![img](https://golang-china.github.io/gopl-zh/images/go-log04.png)

从早期提交日志中也可以看出，Go 语言是从 [Ken Thompson](http://genius.cat-v.org/ken-thompson/) 发明的 B 语言、[Dennis M. Ritchie](http://genius.cat-v.org/dennis-ritchie/) 发明的 C 语言逐步演化过来的，是 C 语言家族的成员，因此很多人将 Go 语言称为 21 世纪的 C 语言。纵观这几年来的发展趋势，Go 语言已经成为云计算、云存储时代最重要的基础编程语言。

在 C 语言发明之后约5年的时间之后（1978年），[Brian W. Kernighan](http://www.cs.princeton.edu/~bwk/) 和 [Dennis M. Ritchie](http://genius.cat-v.org/dennis-ritchie/) 合作编写出版了C语言方面的经典教材《[The C Programming Language](http://s3-us-west-2.amazonaws.com/belllabs-microsite-dritchie/cbook/index.html)》，该书被誉为 C 语言程序员的圣经，作者也被大家亲切地称为 [K&R](https://en.wikipedia.org/wiki/K%26R)。同样在 Go 语言正式发布（2009 年）约 5 年之后（2014 年开始写作，2015 年出版），由 Go 语言核心团队成员 [Alan A. A. Donovan](https://github.com/adonovan) 和 [K&R](https://en.wikipedia.org/wiki/K%26R) 中的 [Brian W. Kernighan](http://www.cs.princeton.edu/~bwk/) 合作编写了Go语言方面的经典教材《[The Go Programming Language](http://gopl.io)》。Go 语言被誉为 21 世纪的 C 语言，如果说 [K&R](https://en.wikipedia.org/wiki/K%26R) 所著的是圣经的旧约，那么 D&K 所著的必将成为圣经的新约。该书介绍了 Go  语言几乎全部特性，并且随着语言的深入层层递进，对每个细节都解读得非常细致，每一节内容都精彩不容错过，是广大 Gopher 的必读书目。大部分  Go 语言核心团队的成员都参与了该书校对工作，因此该书的质量是可以完全放心的。

同时，单凭阅读和学习其语法结构并不能真正地掌握一门编程语言，必须进行足够多的编程实践——亲自编写一些程序并研究学习别人写的程序。要从利用  Go 语言良好的特性使得程序模块化，充分利用 Go 的标准函数库以 Go  语言自己的风格来编写程序。书中包含了上百个精心挑选的习题，希望大家能先用自己的方式尝试完成习题，然后再参考官方给出的解决方案。



微波炉电路图及工作原理

在使用微波炉进行食物加热时大家知道微波炉的工作原理是什么吗？说到微波炉原理图比较专业的人员应该都了解这是什么东西，有了微波炉原理图我们就能够大致的了解到微波炉在进行工作时有哪些元件在进行工作，同时当微波炉出现问题的时候我们也能够更好的进行维修。下面小编就来为大家介绍一下微波炉原理图和微波炉工作原理吧！　 

  微波炉按功能分为微波加热型和微波烧烤型；按控制类型分为机械型和微电脑型。微波炉微波系统结构示意图如右图所示，其工作原理如下：控制电路根据用户设置的火力，将AC220V电压加到高压变压器的初级，其次级输出3V～4V和1800V～2230V两组交流电压。3V～4V交流电压直接给磁控管灯丝供电；1800V～2230V交流电压经高压电容、高压二极管倍压整流滤波后，变为3600V～4500V的负直流电压，加到磁控管阴极。当磁控管具备灯丝电压，且阳极（接地）与阴极之间的电压差大于3500V时，就产生2450MHz超高频电磁波，即微波，快速震动食品内的蛋白质、脂类、糖类及水等物质的分子，使之相互碰撞、挤压、摩擦，重新排列组合。简而言之，微波炉是靠食品内部的摩擦生热来进行烹调的。

[![格兰仕微波炉电路图及工作原理（超详解析其工作原理）](https://cdn.smoxo.cn/wp-content/uploads/2021/2/IFBjaq.jpg)](https://cdn.smoxo.cn/wp-content/uploads/2021/2/IFBjaq.jpg) 

  磁控管发射微波的强度（即功率）与阴阳极电压差及发射时间成正比。实际上，工厂是通过高压变压器的高压输出值来设计微波的额定输出功率的。用户设置火力，就是改变控制电路给高压变压器提供AC220V电源的时间，从而控制了烹调时微波炉的实际输出功率。在最高火力挡时，控制电路始终给高压变压器初级供电，磁控管连续发射微波，此时输出功率最大；而在非最高火力时，控制电路则以30s为一个周期，间歇性给高压变压器初级供电，使磁控管间歇性发射微波，微波炉平均输出功率将低于最大功率。　　

 电路原理简析

[![格兰仕微波炉电路图及工作原理（超详解析其工作原理）](https://cdn.smoxo.cn/wp-content/uploads/2021/2/zQVZR3.jpg)](https://cdn.smoxo.cn/wp-content/uploads/2021/2/zQVZR3.jpg) 

  机械式微波炉的电控部分主要由四部分组成，一是市电供给部分，由电源插头，市电保险丝FUSE，开关和电线等组成；二是升压部分，主要由升压变压器T组成；三是整流部分，由高压保险丝H.V．FUSE，高压二极管D，高压电容器C等组成；四是微波产生部分，主要由磁控管和波导装置组成，如上图所示。

[![格兰仕微波炉电路图及工作原理（超详解析其工作原理）](https://cdn.smoxo.cn/wp-content/uploads/2021/2/y22mIb.jpg)](https://cdn.smoxo.cn/wp-content/uploads/2021/2/y22mIb.jpg) 

 在该电路中一共有以下三个电流回路：

 一是市电回路，220V交流电经保险丝、电机、升压变压器初级后流回插座。二是灯丝回路，升压变压器的一个次级绕组输出约3V交流电，供给磁控管灯丝。只有灯丝加热阴极，阴极才能发射电子。上面两个回路流的是交流电。第三个回路是高压回路，流的是高频高压脉动直流电。

[![格兰仕微波炉电路图及工作原理（超详解析其工作原理）](https://cdn.smoxo.cn/wp-content/uploads/2021/2/bARbAv.jpg)](https://cdn.smoxo.cn/wp-content/uploads/2021/2/bARbAv.jpg) 

 **1、220V市电回路**

  当关上炉门后，定时器打开。S3被下门钩推开，呈开路状态，在电路里不起作用，此时市电电路中的电流如下图所示，干路电流标为I，各并联支路里电流标为i。干路里电流I回路如下：电源L→FUSE→第一闩锁开关Sl→定时开关S4→五个并联支路(iL、il-i4)→第二闩锁开关S2→热继电器S6→回到电源线N，则电流I=il,+il+i2+i3+i4。

[![格兰仕微波炉电路图及工作原理（超详解析其工作原理）](https://cdn.smoxo.cn/wp-content/uploads/2021/2/rY7Nbe.jpg)](https://cdn.smoxo.cn/wp-content/uploads/2021/2/rY7Nbe.jpg) 

 【提示】（1）上述五个支路里任一个短路，总电流就会增大，从而出现烧保险管故障。其中，变压器短路尤为常见。（2）在此电路中，干路上的元器件的连接多采用接插件，只要有一处断开，总电流就为0，微波炉不工作。

[![格兰仕微波炉电路图及工作原理（超详解析其工作原理）](https://cdn.smoxo.cn/wp-content/uploads/2021/2/YjUVje.jpg)](https://cdn.smoxo.cn/wp-content/uploads/2021/2/YjUVje.jpg)



​	[微波](https://bbs.elecfans.com/zhuti_rf_1.html)炉是利用食物在微波场中吸收微波能量而使自身加热的烹饪器具。在微波炉微波发生器产生的微波在微波炉腔建立起微波电场，并采取一定的措施使这一微波电场在炉腔中尽量均匀分布，将食物放入该微波电场中，由控制中心控制其烹饪时间和微波电场强度，来进行各种各样的烹饪过程。

​	其工作原理如下：控制电路根据用户设置的火力，将AC220V电压加到高压变压器的初级，其次级输出3V～4V和1800V～2230V两组交流电压。3V～4V交流电压直接给磁控管灯丝供电；1800V～2230V交流电压经高压[电容](https://www.elecfans.com/tags/电容/)、高压[二极管](https://www.elecfans.com/tags/二极管/)倍压整流滤波后，变为3600V～4500V的负直流电压，加到磁控管阴极。当磁控管具备灯丝电压，且阳极（接地）与阴极之间的电压差大于3500V时，就产生2450MHz超高频电磁波，即微波，快速震动食品内的蛋白质、脂类、糖类及水等物质的分子，使之相互碰撞、挤压、摩擦，重新排列组合。简而言之，微波炉是靠食品内部的摩擦生热来进行烹调的。

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.763610616429383&amp;zoneid=813&amp;prefer=https%3A%2F%2Fwww.elecfans.com%2Fd%2F1064540.html" scrolling="no" width="655" height="302" frameborder="0"></iframe>

​	微波炉原理图是微波炉的核心电路图，在进行微波炉维修时它所起到的作用是非常大的，下面我们就主要来看看在微波炉原理图中它的具体元件有着什么样的作用。

​	![微波炉的工作原理和原理图解析](http://file.elecfans.com/web1/M00/A5/6C/pIYBAF1t1yKAOV_RAACg5Pl_UAw173.jpg)

​	F1：保险，它的作用主要是限制整机[电流](https://www.elecfans.com/tags/电流/)。当微波炉S1、S2开关损坏的时候，它就会出现短接的现象，同时S3开关接通。

​	ST：热保护器。ST主要所起到的作用就是进行温度保护。热保护器一把一般是安装在磁控管的外壳上，通过监控磁控管的温度，防止温度过高将磁控管损坏。

​	S4：定时开关。定时开关是决定整个微波炉是否工作的总电源开关。

​	S1、S2：门锁监控开关。在微波炉原理图中，它所起到的作用主要是防止微波炉泄露。在微波炉门关闭不严或者是微波炉门被卡住的情况下，微波炉部分就不会进行工作。

​	S4、S5：S4、S5是功率控制器中两个独立开关，在工作过程中单独受控，在进行功率控制时，进行串联工作。

​	M1：火力调节[电机](https://bbs.elecfans.com/zhuti_dianji_1.html)。M1和S4、S5组成微波炉功率控制的总成，在器件实物中还有一个档位调节控制预期组成一个整体。

​	L1 、L2、 L3： L1 、L2、 L3组成了大功率升压变压器， L1 大功率变压器初级接220V交流，L2大功率变压器次级输出2000V左右交流高压，L3 大功率变压器另外一组次级，输出4V左右的交流电压。

​	微波炉维修注意事项

​	因过量微波对人体有害，所以微波炉使用手册一般标有“不要暴露在微波发生器或其他传导微波能部件所发射的辐射中”。这就要求维修中做到下列三点：

​	1.打开微波炉外壳上电试机或维修前，应拔掉高压变压器初级一个插头;

​	2.检查非炉门故障和检修非炉门开关部位时，不要拧动、拆卸炉门开关固定螺丝;

​	3.修自动启动故障机时，不要在炉门打开情况下试机。

​	微波系统的任一器件均工作在高压或大电流状态。拆装时可能触及到250V以上电压的部件有：磁控管、高压变压器、高压二极管、高压二极管、高压保险丝。因此，在微波炉运行状态时，维修或接近这些电路均是相当危险的，并禁止测试高压电路中的电压，包括磁控管的灯丝电压。

# 格兰仕微波炉电路图及工作原理（微波炉的结构组）

​                                                                                                            [云韵](https://www.wzy2.com/user-center/yunying)                                                                        •                                                                                                    2022年3月11日 17:15:57                                                                •                                [投稿](https://www.wzy2.com/tougao)                                                            

​	**一、微波炉各电路之间的联系**

​	微波炉主要由保护装置、微波发射装置、转盘装置、烧烤装置、机械控制装置、[电脑](https://www.wzy2.com/tag/dn)控制装置等部分构成，规格型号虽有不同，但各部件的连接方式基本相同。下图为典型微波炉的连接电路图。

​	[![微波炉的结构组成电路图及保护装置](https://p9.toutiaoimg.com/origin/tos-cn-i-qvj2lq49k0/7f97ec2591154243bb6b802898048bbc?from=pc)](https://p9.toutiaoimg.com/origin/tos-cn-i-qvj2lq49k0/7f97ec2591154243bb6b802898048bbc?from=pc)

​	当关好微波炉门，将微波炉通电后，220V的电压通过微波炉保护装置后，由低压变压器经整流滤波电路为控制电路（微电脑）提供低压直流电压，当按动电脑控制装置的启动按钮后，继电器RY1、RY2动作为其风扇电动机提供所需工作电压，使其风扇电动机开始转动，微波炉转盘装置及微波发射装置也开始工作，当按动烧烤按钮后，微波炉的烧烤装置开始工作。

​	**二、保护装置部件的结构特点**

​	微波炉的保护装置主要用来确保微波炉在工作过程中的安全。各保护元件对微波炉起到的保护作用也各不相同，当保护装置中的元件出现故障时，应对其进行检修并代换。

​	下图所示为微波炉保护装置的结构图，从图中可看出，微波炉保护装置主要由温度保护器、门开关组件、风扇及风扇电动机组件、照明灯等构成。

​	[![微波炉的结构组成电路图及保护装置](https://p9.toutiaoimg.com/origin/tos-cn-i-qvj2lq49k0/7223cfad3ab240c7964d242f79f0eb4c?from=pc)](https://p9.toutiaoimg.com/origin/tos-cn-i-qvj2lq49k0/7223cfad3ab240c7964d242f79f0eb4c?from=pc)

​	**1、保险管**

​	保险管（熔断器）属于微波炉的电路保护装置，当微波炉接通电源开始工作后，交流220V电压经插头送入微波炉中首先要经过保险管，当微波炉中的电流有过流、过载的情况时，保险管就会烧断，起到保护电路的作用，从而实现对整个微波炉进行保护的作用。下图所示为保险管的实物图，在微波炉中保险管（熔断器）通常安装在靠近电源供电线附近的支架上。

​	[![微波炉的结构组成电路图及保护装置](https://p9.toutiaoimg.com/origin/tos-cn-i-qvj2lq49k0/8b8fba54555246228014b2f29a741c9c?from=pc)](https://p9.toutiaoimg.com/origin/tos-cn-i-qvj2lq49k0/8b8fba54555246228014b2f29a741c9c?from=pc)

​	该保险管的型号规格标注在支架上，其规格为“10A/250V”，其中“10A”表示该保险管的额定电流为10A, “250V”表示保险管的额定电压为250V。

​	**2、温度保护器**

​	温度保护器也属于微波炉的电路保护装置，当微波炉的炉腔内的温度过高，达到温度保护器的感应温度时，温度保护器就会自动断开，起到保护电路的作用，从而实现对整个微波炉进行保护的作用。温度保护器主要由感温面、接线端和外壳等组成。从图中可看出，温度保护器的感温面上标有该温度保护器的规格型号。

​	[![微波炉的结构组成电路图及保护装置](https://p9.toutiaoimg.com/origin/tos-cn-i-qvj2lq49k0/a6102216cf624d8f9830c8712f181ab0?from=pc)](https://p9.toutiaoimg.com/origin/tos-cn-i-qvj2lq49k0/a6102216cf624d8f9830c8712f181ab0?from=pc)

​	在微波炉中，常用的温度保护器的内部主要由双金属片和触点开关等构成，由于双金属片感温特性不同，因此，在不同的工作温度状态下，双金属片的工作状态也不相同，下图所示为温度保护器的内部结构图。

​	从图中可看出，在常温状态下，双金属片的凸面向下，触点开关处于闭合状态，当微波炉炉腔内的温度升高，并达到双金属片的感应温度时，双金属片凸面反转向上, 同时推动触点开关下移，从而使触点开关断开。

​	[![微波炉的结构组成电路图及保护装置](https://p9.toutiaoimg.com/origin/tos-cn-i-qvj2lq49k0/d1dd76f71ae84bb492f57f289f941ac5?from=pc)](https://p9.toutiaoimg.com/origin/tos-cn-i-qvj2lq49k0/d1dd76f71ae84bb492f57f289f941ac5?from=pc)

​	在有些微波炉中使用一个温度保护器同时监测微波炉的磁控管温度和烧烤温度，而有些微波炉中使用两个温度保护器，一个用于监测磁控管温度，另一个用于监测烧烤温度。

![怎样拆下微波炉并重新组装其磁控管电源](http://file.elecfans.com/web1/M00/A8/7E/o4YBAF2OYgWAHtGMAAC8AllDYGE257.jpg)