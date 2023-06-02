KiCad - 是一个GPL的EDA软件包。包括一个工程管理器和四个主要程序:kicad - 工程管理器。eeschema - 原理图编辑器。cvpcb - [元件](https://bbs.elecfans.com/zhuti_yuanjian_1.html)封装关联选择器。pcbnew - PCB布线程序。gerbview - Gerber(光绘文件)查看器。       

这就是主界面了图中最右数第2个是PCB编辑器，可以计算导线宽度。上图就是一个工程的结构。      ![5.jpg](https://bbs.elecfans.com/data/attachment/forum/201701/11/171122bniazxbinnioana0.jpg)



 ![6.png](https://bbs.elecfans.com/data/attachment/forum/201701/11/171123h6ncr3h5svjshr3s.png)                                                                                  



### 建立原理图库

以最终完成一个[STM32](https://bbs.elecfans.com/zhuti_stm32_1.html)[开发板](https://bbs.elecfans.com/try.html)为目标一步一步学习KiCAD的使用方法。在这次学习中我们先学会建立原理的库。首先我们建立一个文件夹存放我们的工程，不过要注意这个路径要是英文的，不能有中文。建好文件夹后打开软件，如下图所示先新建一个工程，存放到我们刚才建的文件夹里。  ![img](https://bbs.elecfans.com/data/attachment/forum/201701/12/221052sdbnkfv31akzbugn.jpg)        之后我们在回到刚才新建的文件夹里会看到生成三个文件，分别是[PCB](https://bbs.elecfans.com/zhuti_pads_1.html)文件、工程文件、原理图文件。  ![img](https://bbs.elecfans.com/data/attachment/forum/201701/12/221052ubkksrnnok25k6zc.png)        我们顺便在这里再创建一个文件夹，命名为LIB，存放原理图库。  ![img](https://bbs.elecfans.com/data/attachment/forum/201701/12/221053a3h8udk3ccke08e3.png)          然后就可以打开主界面的原理图库选项。如下图所示。  ![img](https://bbs.elecfans.com/data/attachment/forum/201701/12/221053gz39e50gyis0io0h.jpg)          打开之后是这样的。  ![img](https://bbs.elecfans.com/data/attachment/forum/201701/12/221054f0nv1ijzbz0j0f07.jpg)        我们可以看到最左边的四个选项由上到下依次是选择界面是否加上格点、单位inch、单位mm、是否显示打十字光标。这些都是作为辅助画图用的。最右边就是一些画图的工具。    现在我们先新建一个[元件](https://bbs.elecfans.com/zhuti_yuanjian_1.html)。操作如下图所示。  ![img](https://bbs.elecfans.com/data/attachment/forum/201701/12/221055ppxa88glkr8pgzae.png)        我们新建元件要对应相应元件的Datasheet。以建立W25Q16BV为例，  ![img](https://bbs.elecfans.com/data/attachment/forum/201701/12/221055dsosdz9we9vi90fd.png)            其他按默认设置即可。其中第二项U为元件的参考编号，因为这次画的是个芯片，因此我们采用通用的U。下图为此元件的datasheet，我们按照这个画即可。   ![img](https://bbs.elecfans.com/data/attachment/forum/201701/12/221056hh3ozf3hzemzimi2.jpg)            点击确定之后我们看到界面中出现了元件名与参考编号重叠现象。   ![img](https://bbs.elecfans.com/data/attachment/forum/201701/12/221056jwc9nd05zd00e99e.png)            我们可以通过快捷键将其分开并布置好。方法是：将鼠标光标放到文字上，按键盘的M，即可实现移动。将此布置好后我们就开始画元件的结构图了。看界面的左右边。  ![img](https://bbs.elecfans.com/data/attachment/forum/201701/12/221057l08rjexoee1zj5y0.png)        主要用到了引脚和元件外框这两个选项，我们先在图中画一个矩形框，代表元件。然后点引脚，此时光标会变成铅笔状，在点击一下会出现属性选项。  ![img](https://bbs.elecfans.com/data/attachment/forum/201701/12/221057e8fb9xkb7i2espep.png)            我们主要编辑引脚名称和引脚编号，其他选择默认即可。我们在datasheet中看到引脚1位cs非，这里在设置是输入~CS~，即可显示出CS非的效果。将所有引脚都放置结束后我们发现我们画的元件可能会是这样。  ![img](https://bbs.elecfans.com/data/attachment/forum/201701/12/221057pe9ll7k7bb39b8wb.png)        矩形框太小了，我们同样可以通过快捷键改变矩形框的大小，方法是：将光标放到矩形框的一角，按G，拖动鼠标即可。这样我们就画完了第一个元件，之后我们要做的就是保存到原理图库。方法如下：点击保存元件到新库。  ![img](https://bbs.elecfans.com/data/attachment/forum/201701/12/221058zwbsws9sxdt4honq.jpg)        选择路径为我们之前建立的LIB文件，命名为mypcb.lib。  ![img](https://bbs.elecfans.com/data/attachment/forum/201701/12/221059nd4mmu5oqm5x3xm4.jpg)        然后再点设置选择元件库选项。  ![img](https://bbs.elecfans.com/data/attachment/forum/201701/12/221059sz3laeafjhopte73.jpg)         ![img](https://bbs.elecfans.com/data/attachment/forum/201701/12/221100qve7y37ezfqtbqia.jpg)        点击添加，找到我们建立的元件库mypcb.  ![img](https://bbs.elecfans.com/data/attachment/forum/201701/12/221101nyyhchxnmtxncljl.png)         ![img](https://bbs.elecfans.com/data/attachment/forum/201701/12/221102sixampvj8jfeg1fm.jpg)        按照上图中两个红圈内一定要选择正确，一个是库选择对，另一个是路径要对。然后我们在回到界面选择打开当前库。  ![img](https://bbs.elecfans.com/data/attachment/forum/201701/12/221103zsyjd3373pye4y3d.png)           ![img](https://bbs.elecfans.com/data/attachment/forum/201701/12/221103ud414jtkr0ppknnj.png)        选择我们建立的库文件。之后会在顶部出现我们建立库的路径。  ![img](https://bbs.elecfans.com/data/attachment/forum/201701/12/221104a1l9ovjjodj9sw96.png)        这样我们就成功的添加了原理图库。    接下来就可以继续画其他元件了，当画完一个后我们分别按下图所示选项进行保存。分别如下图所示。  ![img](https://bbs.elecfans.com/data/attachment/forum/201701/12/221104zf8wxhhvxv8zzw78.png)        我们同样可以选择库浏览，来浏览我们画的元件。  ![img](https://bbs.elecfans.com/data/attachment/forum/201701/12/221105b0a1f0x11gvv1oao.jpg)          如果我们不想要这个元件了，可以选择删除选项对元件删除操作。  ![img](https://bbs.elecfans.com/data/attachment/forum/201701/12/221106xfefsicke3oecraa.png)        至此，我们就学会了KiCAD原理图库的使用。最后总结几个快捷方式：E：编辑R：旋转G：拖动矩形边界M：移动同样我们也可以使用鼠标右键单击，同样可以实现以上操作。       最后的最后，我们在习惯了AD的Ctrl+鼠标滚轮以及右键实现自如缩放随意拖动后遇到这个心软件也总是不经意的这样操作，但是却没有任何反应。如果我们画一个比较大的芯片，比如100引脚的stm32时总是先用鼠标滚轮缩放进行移动操作，很不方便。今天我就发现了一个很好的方法，实现任意拖动，就是按住鼠标的滚轮，然后就可以自如移动了。怎么样今天是不是收获很大？        ![24.jpg](https://bbs.elecfans.com/data/attachment/forum/201701/12/221105hsuv2bfbgtgcffiy.jpg)

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/000/25/28/67_avatar_middle.jpg)](https://bbs.elecfans.com/user/252867/)                                                                            [760484457](https://bbs.elecfans.com/user/252867/)                                        *2017-3-17 14:49:11*                                                                                                                                                                                                    [                                                                                                                                                                                           *9*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1107184&pid=5538100)                                                                                                                                                                                        [一天一地 发表于 2017-2-19 22:21](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&pid=5477521&ptid=1107184)  问一下CS上面的横划线怎么弄的      前后各加一个：～ |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |



#             KiCAD教程（3），建立建立PCB元件封装库        

| 我们制作一块板子要有所需要的[元件](https://bbs.elecfans.com/zhuti_yuanjian_1.html)的封装，KiCAD自带有丰富的封装库，但是对于一些特殊的元器件还是需要我们手动画封装。  如下图操作，打开封装库。  ![img](https://bbs.elecfans.com/data/attachment/forum/201701/13/195818yqho9houhpu2fcfu.jpg)        界面的最右边分别是焊盘、边框灯选项，还有选择的层。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        以接插件WJ301为例，画出元件封装如下图。其中元件的边框要选择顶层丝印层。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        画完以后效果如上图所示。之后点如下图按键。建立一个新库。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        名称设置为my[PCB](https://bbs.elecfans.com/zhuti_pads_1.html)。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        然后点设置选择封装库管理。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        如下图所示，第一步添加库，第二部，设置名称为mypcb,第三部设置路径为：{KIPRJMOD}/mypcb.pretty  这三点如果设置错了就打不开自己建立的库。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        之后我们回到编辑器界面，选择当前工作库。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        添加我们新建的库。点确定就OK了。点击打开封装浏览器，就可以查看软件自带的元件库，以及自己建立的库。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        最后要说明的是，其实这个过程很简单，但是关键是要细心。有一点设置错，我们就可能不能打开自己建立的库，尤其是路径要对照文中设置正确。  第 |
| ------------------------------------------------------------ |
|                                                              |

|      |
| ---- |
|      |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/001/29/91/43_avatar_middle.jpg)](https://bbs.elecfans.com/user/1299143/)                                                                            [lee](https://bbs.elecfans.com/user/1299143/)                                        *2018-3-7 14:43:52*                                                                                                                                                                                                    [                                                                                                                                                                                           *3*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1107411&pid=6632583)                                                                                                                                                                                    这个封装库管理应该 **使用添加引导** 添加进去，不然库路径不知道怎么来的。 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/001/33/49/21_avatar_middle.jpg)](https://bbs.elecfans.com/user/1334921/)                                                                            [137429822](https://bbs.elecfans.com/user/1334921/)                                        *2018-3-19 10:37:30*                                                                                                                                                                                                    [                                                                                                                                                                                           *4*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1107411&pid=6661455)                                                                                                                                                                                    原件的属性怎么添加？还有就是边框是丝印层 那原件的焊接位置就是焊接曾了对把？ |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |



#             KiCAD教程（4），制作贴片元件封装        

[![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708/)[spark_zhang](https://bbs.elecfans.com/user/2164708/)

*2017-1-14 17:17:34**![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/wacth.png)*15388

​        

![推荐](https://bbs.elecfans.com/static/image/stamp/006.gif)

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.19082912719088396&amp;zoneid=223&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1107481_1_1.html" scrolling="no" width="728" height="90" frameborder="0"></iframe>

| 建立好自己的[PCB](https://bbs.elecfans.com/zhuti_pads_1.html)[元件](https://bbs.elecfans.com/zhuti_yuanjian_1.html)库后，就可以自己花元件的封装了。虽然软件自带有很多封装，但我们还是要学一下怎么画的。  首先学习画贴片元件的封装，以贴片AT24C02为例，我们先打开芯片数据手册，找到芯片封装尺寸。如下图所示。   ![img](https://bbs.elecfans.com/data/attachment/forum/201701/14/171520u1ryf1111t79x2nn.jpg)          数据手册里包含了芯片尺寸等信息。因此我们在画元件封装时一定要按数据手册里的尺寸画，但是实际情况是为了容易焊接，一般我们给芯片的焊盘都留有一定的裕度，也就是比标定的要长一点。  画好封装后如下图所示。其中芯片的图形边框一定要在顶层丝印层。双击焊盘或者光标放到焊盘上按E可以对焊盘的属性进行编辑。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        这样画好封装后就可以保存了。但是这并没有结束，我们还要给封装添加3D模型。具体操作如  ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)        这样我们就成功添加了芯片的3D模型。点击视图-查看3D效果，可以对添加的3D模型进行查看。如下图为最终调整结果。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        如果形状不是这样的，出现了偏差，我们可以返回进行调整，调整方法如下图所示，可以调节Ｘ,Y,Z 轴的偏移量以及旋转角度。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        至此，我们就成功的建立了第一个贴片封装，其他的还有宽体贴片封装的画法跟这个基本一样。主要掌握方法就是实际尺寸比datasheet上的尺寸大一点就行，但不要大的太多，以免贴片焊不上去。总之是画的多了就有经验了。关键在于多练习，多看看别人画的封装。  第一次写教程，难免有些不足之处，还望大神看了多多指正。我想着是开一系列帖子，然后名字按这个标题1,2,3.。。排下去。如果大家有好建议可以留言。我再做适当的改正。本系列教程都是原创，如果个别地方侵犯到谁的权益，请联系我！ |
| ------------------------------------------------------------ |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708/)                                                                            [spark_zhang](https://bbs.elecfans.com/user/2164708/)                                        *2017-1-19 20:52:38*                                                                                                                                                                                                    [                                                                                                                                                                                           *9*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1107481&pid=5438163)                                                                                                                                                                                        [zhixiaoyuhong 发表于 2017-1-19 12:11](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&pid=5437166&ptid=1107481)  楼主，kicad可不可以加step格式的自己画的3d模型？      可以，不过我不会画3D模型![img](https://bbs.elecfans.com/static/image/smiley/default/biggrin.gif)，用的都是自带的 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/000/39/35/95_avatar_middle.jpg)](https://bbs.elecfans.com/user/393595/)                                                                            [海洋](https://bbs.elecfans.com/user/393595/)                                        *2017-1-20 18:33:45*                                                                                                                                                                                                    [                                                                                                                                                                                           *10*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1107481&pid=5439723)                                                                                                                                                                                        [spark_zhang 发表于 2017-1-19 20:52](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&pid=5438163&ptid=1107481)  可以，不过我不会画3D模型，用的都是自带的      跟着楼主帖子，下了kicad准备学，结果刚装上，想把原理图A4页面换成A2的，结果每次都卡死。不知道楼主有木有遇到？ |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https:                                               |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708/)                                                                            [spark_zhang](https://bbs.elecfans.com/user/2164708/)                                        *2017-1-21 10:00:11*                                                                                                                                                                                                    [                                                                                                                                                                                           *14*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1107481&pid=5440189)                                                                                                                                                                                        [zhixiaoyuhong 发表于 2017-1-21 09:33](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&pid=5440170&ptid=1107481)  是这样，但又卡死了。。。      这种情况还真没遇到过。是不是安装的问题？不过对于软件卡死的问题我后面会介绍解决方法。这里跟你说下，你照着设置一下，如果还不行可能就是安装问题了。  1 打开封装编辑器，找到封装管理。   ![img](https://bbs.elecfans.com/static/image/common/none.gif)          2 在电脑中找到这个路径。其中appdata文件夹是隐藏的，显示隐藏即可。   ![img](https://bbs.elecfans.com/static/image/common/none.gif)          3 找到这个文件，用记事本打开   ![img](https://bbs.elecfans.com/static/image/common/none.gif)          4 编辑替换，这里要替换的为两项内容。  （1）将type_Github替换为type_KiCAD  （2）将${KIGITHUB}替换为${KISYSMOD}  5 保存退出 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/000/39/35/95_avatar_middle.jpg)](https://bbs.elecfans.com/user/393595/)                                                                            [海洋](https://bbs.elecfans.com/user/393595/)                                        *2017-2-13 14:52:26*                                                                                                                                                                                                    [                                                                                                                                                                                           *17*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1107481&pid=5465460)                                                                                                                                                                                        [spark_zhang 发表于 2017-1-21 10:00](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&pid=5440189&ptid=1107481)  这种情况还真没遇到过。是不是安装的问题？不过对于软件卡死的问题我后面会介绍解决方法。这里跟你说下，你照着设置一下，如果还不行可能就是安装问题了。  1 打开封装编辑器，找到封装管理。      按照楼主的说法，果然好了！谢谢楼主！！！期待楼主大作。。。最好能详细讲讲gerber生成以及注意事项啥的，多谢多谢。。。 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |



#             KiCAD教程（5），自带库中元件封装修改为己所用        

[![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708/)[spark_zhang](https://bbs.elecfans.com/user/2164708

| 前面讲了在KiCAD 中如何画出自己所需的[元件](https://bbs.elecfans.com/zhuti_yuanjian_1.html)封装。但是并不是所有元件都要我们一个个手动画，这样就太麻烦了。下面介绍一个利用已有库快速建立自己的元件封装。    首先还是从需求说起，现在需要一个SOP16封装的元件。当然我们可以根据datasheet上一天线一个焊盘的画出封装，这样并不难，但是带费劲。怎样才能快速的画出来呢？下面就要说道说道了。都还记得我们之前画过SOP8的封装吧？对，原理就是在SOP8的基础上修改成SOP16。  首先还是打开我们自己建立的库文件。如下图所示，点击导入选项。  ![img](https://bbs.elecfans.com/data/attachment/forum/201701/15/204558bh7ersxiqk5ky0z7.jpg)        找到我们建立的[PCB](https://bbs.elecfans.com/zhuti_pads_1.html)封装库文件夹，选择之前建好的SOP8元件的封装。如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        点确认后返回主界面，下图就是我之前已经画好的SOP8的封装。我们要做的就是再添加8个焊盘，这样就变成SOP16的封装了。就这样，很简单吧！  ![img](https://bbs.elecfans.com/static/image/common/none.gif)          修改完后是这样的！  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        然后点击工具栏的“导出”选项。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)        改好名字好保存到我们自己建立的PCB库里。最后在点一下保存，记得修改名字！就这样方便快速的建立了SOP16的封装。  是不是还不过瘾？那我们就再画个100引脚的封装吧！什么？100引脚，太多了，手都要画残啊！！！  哈哈哈哈哈。。。。此画非彼画！有捷径当然要走捷径。这次我们就要好好利用一下软件自带的封装库了。  还按上述方法，导入，找到QFP100的封装。路径就是你软件安装的路径。我的路径是：**D:\ProgramFiles\KiCad\share\kicad\modules\Housings_QFP.pretty****。**    如下图所示，找到100引脚的封装文件。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)         打开后如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)          看！这不就画完了吗！先别着急导出保存，我们还要再改动一点，就是在芯片的第一引脚出加一个标识。如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        这样才算完整的画完，接下来就可以保存，。  记得我们再画原理图库的时候用过AMS1117。对，还是用这个方法快速画出此芯片的封装。    具体方法如下图所示  ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)        打开封装后就是下图这个样子了，画的还挺好看！！！！但是你有没有发现有一点问题呢？对，就是我用红框标出来的引脚。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        么？没看出来？那我们再看看DATAsheet上是怎么写的吧！  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        datasheet上只标了三个引脚。但是经过实际测量，最上边的那个引脚其实是跟引脚2相连的。因此，我们还要在封装里把引脚4改成2.这样SOT223的封装就画完了，下图就是修改后的封装。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        然后就是导出，修改名字，保存了。  经过我上面的讲解是不是又学习到一个新的技能！    对了，还有一点忘了说了。我们前面讲SOP8的封装修改成SOP16后还要记得将3D模型也改一下！  ![img](https://bbs.elecfans.com/static/image/common/none.gif)         点击封装属性，按下图的步骤，先移除之前的8引脚的3D模型，然后添加16引脚封装的3D模型，最后入步骤三所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        之后通过对形状偏移以及形状旋转的调整就得到完整的3D模型了。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        讲到这里你以为就这样结束了？  别着急啊，下面才是结晶！！！！！我们画引脚封装的时候有时候要计算两焊盘的距离以便正确放置。但是你以为软件的网格是当摆设的吗？？naive！  看到没，这都是一些标准的距离，是可以选择的。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        一般贴片引脚距离5mils也就是0.127mm的间距，我们直接选择，将格点设置为0.127mm，这样我们直接按格点放置就可以了是不是很方便！    最后祝大家学习愉快！！！ |
| ------------------------------------------------------------ |
|                                                              |

|                                                              |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/29/06/01_avatar_middle.jpg)](https://bbs.elecfans.com/user/2290601/)                                                                            [KYE_CQS](https://bbs.elecfans.com/user/2290601/)                                        *2017-1-22 18:59:17*                                                                                                                                                                                                    [                                                                                                                                                                                           *3*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1107540&pid=5442035)                                                                                                                                                                                    谢谢大家的分享。谢谢。 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/29/06/01_avatar_middle.jpg)](https://bbs.elecfans.com/user/2290601/)                                                                            [KYE_CQS](https://bbs.elecfans.com/user/2290601/)                                        *2017-2-3 17:37:40*                                                                                                                                                                                                    [                                                                                                                                                                                           *4*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1107540&pid=5449317)                                                                                                                                                                                    谢谢大家的分享。 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/29/06/01_avatar_middle.jpg)](https://bbs.elecfans.com/user/2290601/)                                                                            [KYE_CQS](https://bbs.elecfans.com/user/2290601/)                                        *2017-2-4 18:15:20*                                                                                                                                                                                                    [                                                                                                                                                                                           *5*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1107540&pid=5450582)                                                                                                                                                                                    谢谢详细的解读，谢谢。 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/001/61/61/18_avatar_middle.jpg)](https://bbs.elecfans.com/user/1616118/)                                                                            [勇工](https://bbs.elecfans.com/user/1616118/)                                        *2018-9-14 09:20:54*                                                                                                                                                                                                    [                                                                                                                                                                                           *6*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1107540&pid=7083492)                                                                                                                                                                                    8脚 到16脚 是自己手动添加另外8个脚？ |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/93/71/06_avatar_middle.jpg)](https://bbs.elecfans.com/user/2937106/)                                                                            [李可想](https://bbs.elecfans.com/user/2937106/)                                        *2018-11-23 19:26:18*                                                                                                                                                                                                    [                                                                                                                                                                                           *7*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1107540&pid=7228696)                                                                                                                                                                                    您好，请问，封装库出来之后，怎么和自己画的原理图库绑定起来呢，就是和ad的集成库类似的功能。 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.p                                                                                   [举报](javascript:;) |
|                                                              |



#             KiCAD教程（6），自锁开关原理图、封装及开发板电源部分电路        

| 首先还是要看下自锁开关长什么样子，如下图所示为KFT8.0自锁开关。  ![img](https://bbs.elecfans.com/data/attachment/forum/201701/16/201654dalhrltllxgltxac.jpg)        原理嘛也没啥好说的，就是开关嘛！这里的重点是如何画出来。    还是要先找到DATASHEET，看看他的封装尺寸多大。如下图所示为此自锁开关封装。  ![img](https://bbs.elecfans.com/data/attachment/forum/201701/16/201655fa70dh2943kx98d0.jpg)        图中我已经标的很清楚了，这就是重点。其一：引脚直径1mm其二：引脚间距2.5mm其三：引脚纵向间距3.0mm其四：引脚排列是2*3    这样原理图的基本外形就心里有数了！接下来我们看看这个自锁开关内部是怎么连接的。先把datasheet局部放大。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        仔细看图中实线虚线是怎么连的，解释的通俗易懂点就是实线部分是开关松开后的内部接线，虚线是开关按下后的接线。这下就可以看出1和6引脚是公共端。开关的进线接3,4.出线端接2,5.然后就可以画原理图和封装了。    打开软件，进入我们自建的原理图库。下图是我自己画的，这样看起来比较直观。怎么开心怎么画吧。。。。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        然后保存就可以关闭了。之后我们画自锁开关的封装。    打开自己建的[PCB](https://bbs.elecfans.com/zhuti_pads_1.html)库，按照datasheet里的形状画好。下图是我自己画的。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        这里要注意的是引脚的孔径设置为1mm,引脚的焊盘可以稍微大一点，设置为1.8mm。引脚的X轴2.5mm，Y轴间距为3mm。另外这里焊盘的编号一定要与原理图里的顺序一样。    就这么简单，自锁开关的原理图和封装都画好了。前面讲了那么多原理图及封装的画法，现在大家差不多对这个软件也有了一定的了解了吧！但是这只是刚开始，我们要想学会这个软件，首先还是要从实际的使用中学习，光看不用过几天还是会忘。因此这次要从一个案例开始，我们的目的是要画[单片机](https://bbs.elecfans.com/zhuti_mcu_1.html)的[开发板](https://bbs.elecfans.com/try.html)，从最基本的[元件](https://bbs.elecfans.com/zhuti_yuanjian_1.html)开始画，相信到开发板画完后大家也就学会并掌握了KiCAD的使用。    废话不多说，打开软件，进入原理图界面。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        我们看见面的最右边工具栏。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        图中标注的1位放置元件选项，2位[电源](https://bbs.elecfans.com/zhuti_power_1.html)选项，3位连接线选项。  首先我们要明确开发板的电源是通过USB线与电脑相连。也就是我们需要一个USB接口。    我们先补充一点关于USB的知识，USB基本有三种封装，分别为USB-A，USB-B，MINI-USB。如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)        我们这次用的是MINI-USB。因此我们就点击放置元件选项，  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        输入USB就过滤出三个选项，我们选择第三个，点确定即可。然后我们双击元件，或点E打开元件的属性。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        如图中所示，点击制定封装。打开下图所示界面。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        找到Connect并点击，此时切记，由于第一次打开时比较慢，点击一次后稍等即可，切忌再点其他选线，否则软件可能会死掉，你还要重新打开！我们稍等片刻后出来右半部分选项，找到USB-MINI，然后点“将封装放置到[电路](https://bbs.elecfans.com/zhuti_dianlu_1.html)板”选项。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        点确定后我们就设置好了USB的封装。接下来点击放置电源端口，给USB接上电源，如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        由于开发板芯片用到的是3.3V，因此我们还要画5V转3,3V电路。芯片我们用到的是AMS1117-3.3。我们直接按下图所示画好就OK了。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        从左边讲起，首先是5V电源接入，通过一个自恢复保险。这里我们选择500mA。其实物图如下所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        这个是0805封装的。我们接入保险的目的是为了放置开发板电路短路后对我们电脑造成危害。当电流大于500mA时保险断开，这样就有效的保护了电脑。    这个元件我们软件自带的库里也有，点击放置元件，输入FUSE。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        我们选择第二个，点击确定即可。放置好元件后，双击给自恢复保险添加封装。因为我们选择的0805的封装，因此我们可以选择0805的电阻封装文件作为自恢复保险的封装。方法还是如上所述。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        最后点击确定即可。    然后放置自锁开关，再讲AMS1117及滤波电容放上去即可。电容有两种，一种是带电极的电解电容，另一种是没有电极的电容。分别如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)        其封装分别如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)        然后我们再把原理图补充完整，其中有源电容选择220UF，10V。无源电容选择0.1UF。  至此，原理图电源部分就完成了！  最后祝大家学习愉快！！！ |
| ------------------------------------------------------------ |
|                                                              |

|      |
| ---- |
|      |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/001/32/27/45_avatar_middle.jpg)](https://bbs.elecfans.com/user/1322745/)                                                                            [王栋春](https://bbs.elecfans.com/user/1322745/)                                        *2017-1-16 21:13:03*                                                                                                                                                                                                    [                                                                                                                                                                                                                                                   沙发                                                                                                                                                                                                                                        ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1107758&pid=5432384)                                                                                                                                                                                    非常好的资料 学习了 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708/)                                                                            [spark_zhang](https://bbs.elecfans.com/user/2164708/)                                        *2017-1-17 20:41:41*                                                                                                                                                                                                    [                                                                                                                                                                                                                                                   板凳                                                                                                                                                                                                                                        ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1107758&pid=5434361)                                                                                                                                                                                        [王栋春 发表于 2017-1-16 21:13](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&pid=5432384&ptid=1107758)  非常好的资料 学习了      多谢支持 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/28/32/56_avatar_middle.jpg)](https://bbs.elecfans.com/user/2283256/)                                                                            [灰太狼印](https://bbs.elecfans.com/user/2283256/)                                        *2017-1-23 10:31:34*                                                                                                                                                                                                    [                                                                                                                                                                                           *3*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1107758&pid=5442612)                                                                                                                                                                                    谢楼主分享 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| 头像被屏蔽                                                                                                                                [                                                                                                                                                                                           *4*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1107758&pid=5459397)                                                                                                                                                                                   提示: *作者被禁止或删除 内容自动屏蔽* |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/58/44/00_avatar_middle.jpg)](https://bbs.elecfans.com/user/2584400/)                                                                            [wwkk](https://bbs.elecfans.com/user/2584400/)                                        *2017-8-3 10:51:24*                                                                                                                                                                                                    [                                                                                                                                                                                           *5*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1107758&pid=5883829)                                                                                                                                                                                    ![img](https://bbs.elecfans.com/static/image/smiley/default/handshake.gif) |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |



#             KiCAD教程（7），单片机最小系统

| 制作一个[单片机](https://bbs.elecfans.com/zhuti_mcu_1.html)[开发板](https://bbs.elecfans.com/try.html)首先要做的就是先把单片机最小系统画出来，然后在最小系统的基础上添加其他外围器件。那么接下来我们就要开始学怎么画一个[STM32](https://bbs.elecfans.com/zhuti_stm32_1.html)的最小系统。  首先我们整理下思路，我们也许之前接触过51单片机，其最小系统无非就是外接上[电源](https://bbs.elecfans.com/zhuti_power_1.html)，添加晶振[电路](https://bbs.elecfans.com/zhuti_dianlu_1.html)，复位电路。其实STM32的最小系统也就这么多东西，只不过可能引脚比较多罢了！接下来我们就要进入正题了！  还是打开原理图编辑器，点击放置[元件](https://bbs.elecfans.com/zhuti_yuanjian_1.html)。  ![img](https://bbs.elecfans.com/data/attachment/forum/201701/17/204743us6hqzl2slzcq2al.png)        输入STM32，找到我们之前画的元件。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        点击确定，放到原理图上。然后我们开始画外围元件。  首先画单片机的晶振。STM32有两个外部晶振，一个是8M，一个32.768K。  其画法如下图所示。怎样找到晶振呢？方法还是点击放置元件。然后输入Crystal就可以了。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        下面是晶振电路  ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)        有人会问为什么我们店电容会选择这么大的呢？有什么依据？当然有依据。我们打开stm32的datasheet。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        看到没，人家写的很清楚，上图是对于8M的晶振，人家要求只要在5pF-25pF之间即可，而且两个电容的大小要相同。所以，我们就在我们的原理图中选择使用22pF电容。  对于32.768K的晶振电路，人家是这样说的。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        也是要求在5-15pF即可，而且还强烈推荐使用15pF。    接下来就是把电源部分画上了，如下图所示，在电源部分添加去耦电容。大小为0.1uF。参考电压我们采用模拟电源3.3V，同时要接上模拟地。因为电路中同时又数字电源与模拟电源，因此我们采用一个0欧电阻将其隔离。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)         然后我们开始画最小系统的复位电路。也很简单，如下图所示。接下来是供电部分。如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        CR1220是一个备用纽扣电池。接两个二极管是为了不使备用电源的电流倒流进外电源或外电源倒流到纽扣电池。也是出于对电源的保护。    至此呢，单片机的最小系统也就画好了。            [4.png](javascript:;) *(23.34 KB, 下载次数: 46)*            ![4.png](https://bbs.elecfans.com/static/image/common/none.gif)          [8.png](javascript:;) *(26.93 KB, 下载次数: 48)*            ![8.png](https://bbs.elecfans.com/static/image/common/none.gif) |
| ------------------------------------------------------------ |
| [只看该作者](https://bbs.elecfans.com/forum.php?mod=viewthread&tid=1107888&page=1&authorid=2164708)                                                                                                                                                                [*![分享](https://bbs.elecfans.com/static/image/common/collection.png)淘帖*](https://bbs.elecfans.com/forum.php?mod=collection&action=edit&op=addthread&tid=1107888)                                                                                                    [举报](javascript:;)                                                                                                                                                                                                                                                                                                                                                                                                   相关推荐                                                                                                                                                                                                                                                                                                                                                                [                                                     • 单片机最小系统是指什么                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         6768*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2258810_1_1.html)                                                                                                                                                                                    [                                                     • 单片机最小系统、IO口模式介绍                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         1064*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2205309_1_1.html)                                                                                                                                                                                    [                                                     • 为什么称为单片机最小系统呢                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         1116*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2205296_1_1.html)                                                                                                                                                                                    [                                                     • 浅析单片机最小系统                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         525*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2194349_1_1.html)                                                                                                                                                                                    [                                                     • 单片机最小系统                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/d_load.png)                                                         47*                                                                                                                                                               ](https://www.elecfans.com/soft/33/2021/202112291768672.html)                                                                                                                                                                                    [                                                     • 单片机最小系统                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/d_load.png)                                                         31*                                                                                                                                                               ](https://www.elecfans.com/soft/33/2021/202111231743508.html)                                                                                                                                                                                    [                                                     • 基于51单片机的最小系统焊接图 浅谈单片机最小系统                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         44378*                                                                                                                                                               ](https://www.elecfans.com/d/773107.html)                                                                                                                                                                                    [                                                     • 单片机最小系统板制作方法                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         22015*                                                                                                                                                               ](https://www.elecfans.com/d/734635.html)                                                                                                                                                                                    [                                                     • 单片机最小系统                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         888*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2126438_1_1.html)                                                                                                                                                                                    [                                                     • 什么是单片机最小系统？                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         739*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2122382_1_1.html)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          *2* 条评论                                                                                                                        [只看该作者](https://bbs.elecfans.com/forum.php?mod=viewthread&tid=1107888&page=1&authorid=2164708) |

|      |
| ---- |
|      |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/25/55/66_avatar_middle.jpg)](https://bbs.elecfans.com/user/2255566/)                                                                            [姬房有](https://bbs.elecfans.com/user/2255566/)                                        *2017-1-19 09:32:04*                                                                                                                                                                                                    [                                                                                                                                                                                                                                                   沙发                                                                                                                                                                                                                                        ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1107888&pid=5436739)                                                                                                                                                                                    介绍的很详细 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/55/29/26_avatar_middle.jpg)](https://bbs.elecfans.com/user/2552926/)                                                                            [赵佳楠](https://bbs.elecfans.com/user/2552926/)                                        *2018-4-24 20:34:11*                                                                                                                                                                                                    [                                                                                                                                                                                                                                                   板凳                                                                                                                                                                                                                                        ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1107888&pid=6737123)                                                                                                                                                                                    哪画了STM32？前面的教程没有啊 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

### 评论

[B](javascript:;) [Color](javascript:;)   [Link](javascript:;) [Quote](javascript:;) [Code](javascript:;) [Smilies](javascript:;)     您需要登录后才可以回帖 [登录/注册](javascript:;)



声明：本文内容及配图由入驻作者撰写或者入驻合作网站授权转载。文章观点仅代表作者本人，不代表电子发烧友网立场。文章及其配图仅供工程师学习之用，如有内容图片侵权或者其他问题，请联系本站作侵删。 [侵权投诉](https://www.elecfans.com/about/tousu.html)

​    

[                             发经验                         ](https://bbs.elecfans.com/forum.php?mod=post&action=newthread&fid=1339&special=7)

[![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708)

[spark_zhang](https://bbs.elecfans.com/user/2164708) 





技术员 

积分：167经验：101

- 主题

  ##### 22

- 文章

  ##### 0

- 粉丝

  ##### 43

+关注

发私信

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.2052489616551847&amp;zoneid=242&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1107888_1_1.html" scrolling="no" width="300" height="250" frameborder="0"></iframe>

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.8538817787328469&amp;zoneid=781&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1107888_1_1.html" scrolling="no" width="300" height="125" frameborder="0"></iframe>

### 直播

[查看更多 >>](https://t.elecfans.com/live)

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

RISC-V 开发平台 Milk-V Pioneer 发布会

2023/4/15 15:00  回顾

![img](https://file.elecfans.com/web2/M00/3F/EF/poYBAGJqh3-AFAm_AAGpPtG2eAM315.png)

国产EDA软件新星03期-Venus智能建库工具介绍

2023/4/13 19:00  回顾

![img](https://file.elecfans.com/web2/M00/43/F3/pYYBAGKCLNCAfe1iAAEAAYXz0ZQ341.png)

【新品发布】IFX新款开发板发布与上手培训

2023/4/12 15:00  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

【开源芯片系列讲座】RISC-V计算软件栈与高性能计算进展

2023/4/7 20:00  回顾

![img](https://file.elecfans.com/web2/M00/01/14/pYYBAGDBfdOAAsnuAADpn0dJLuQ131.png)

开放原子开源基金会“源聚一堂”开源技术沙龙

2023/4/7 09:00  回顾

![img](https://file.elecfans.com/web2/M00/13/37/pYYBAGEwm8iACBfmAAEbdg3hPPo606.png)

《OpenHarmony“芯”进展》系列直播课——LoongArch专场

2023/4/4 18:55  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【OpenHarmony】2023开放原子校源行（北京站）

2023/4/2 09:24  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

OpenHarmony知识赋能No.28-OpenHarmony系统的驱动架构解析

2023/3/30 18:55  回顾

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座03期-T507-H 处理器音频接口的详细讲解

2023/5/25 19:00 报名中

![img](https://file.elecfans.com/web1/M00/CE/20/o4YBAF-iaBOAfClHAADS3eM3IVY279.jpg)

【创龙分享】国产工业嵌入式处理器架构解析

2023/5/25 19:00 报名中

![img](https://file.elecfans.com/web2/M00/01/14/pYYBAGDBfdOAAsnuAADpn0dJLuQ131.png)

OpenHarmony创新赛赛事宣讲会

2023/5/31 14:30 报名中

![img](https://file.elecfans.com/web2/M00/61/AB/pYYBAGL7hJaACg3NAAAX92fOR8889.jpeg)

开源硬件系列08期：片上网络的过去、现在和将来

2023/5/31 19:30 报名中

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座02期-NXP i.MX 9352处理器的I3C接口详解

2023/5/18 19:00  回顾

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座01期-基于rpmsg的多核异构产品双核通信应用实现

2023/5/11 19:00  回顾

![img](https://file.elecfans.com/web2/M00/72/74/pYYBAGNR9yCABb_lAAANs78gSRY396.jpg)

《RK3588 PCB设计指导白皮书》线上发布&实战解读

2023/5/11 13:50  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

开源芯片系列讲座第09期：RISC-V软硬件协同设计全流程软件栈

2023/5/10 15:00  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

OpenHarmony知识赋能No.29-DAYU200分布式应用开发

2023/5/4 19:00  回顾

![img](https://file.elecfans.com/web2/M00/61/AB/pYYBAGL7hJaACg3NAAAX92fOR8889.jpeg)

开源硬件系列07期：基于生成器方法学的CGRA(可重构计算)设计

2023/4/27 19:30  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【2023】OpenHarmony开发者大会：技术论坛

2023/4/19 14:00  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【2023】OpenHarmony开发者大会：主论坛

2023/4/19 09:35  回顾

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.9144777046209299&amp;zoneid=224&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1107888_1_1.html" scrolling="no" width="300" height="600" frameborder="0"></iframe>

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.9275833869076527&amp;zoneid=678&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1107888_1_1.html" scrolling="no" width="300" height="255" frameborder="0"></iframe>

​                    

广告![img](https://bbs.elecfans.com/static/image/ad/ad_close.png)[![img](https://file.elecfans.com/web2/M00/A6/D6/pYYBAGRnDtqAO7mSAAJXTJBhXM8305.jpg)](https://smt.hqchip.com/online.html?from=Pltdb)

[关闭](javascript:;)

##                  站长推荐                ![上一条](https://bbs.elecfans.com/static/image/common/pic_nv_prev.gif) *4/7* ![下一条](https://bbs.elecfans.com/static/image/common/pic_nv_next.gif)            

- [【开发板试用】](https://bbs.elecfans.com/collection_444_1.html)        

  开发板试用是电子发烧友网打造的一个开发板试用平台，与众多工程师分享你的创意

[查看 »](https://bbs.elecfans.com/collection_444_1.html)

- 华秋（原“华强聚丰”）：

  电子发烧友

  华秋开发

  华秋电路(原"华强PCB")

  华秋商城(原"华强芯城")

  华秋智造



- 设计技术

  [可编程逻辑](https://www.elecfans.com/pld/)

  [电源/新能源](https://www.elecfans.com/article/83/)

  [MEMS/传感技术](https://www.elecfans.com/article/88/142/)

  [测量仪表](https://www.elecfans.com/article/85/)

  [嵌入式技术](https://www.elecfans.com/emb/)

  [制造/封装](https://www.elecfans.com/article/90/155/)

  [模拟技术](https://www.elecfans.com/analog/)

  [RF/无线](https://www.elecfans.com/tongxin/rf/)

  [接口/总线/驱动](https://www.elecfans.com/emb/jiekou/)

  [处理器/DSP](https://www.elecfans.com/emb/dsp/)

  [EDA/IC设计](https://www.elecfans.com/bandaoti/eda/)

  [存储技术](https://www.elecfans.com/consume/cunchujishu/)

  [光电显示](https://www.elecfans.com/xianshi/)

  [EMC/EMI设计](https://www.elecfans.com/emc_emi/)

  [连接器](https://www.elecfans.com/connector/)

- 行业应用

  [LEDs ](https://www.elecfans.com/led/)

  [汽车电子](https://www.elecfans.com/qichedianzi/)

  [音视频及家电](https://www.elecfans.com/video/)

  [通信网络](https://www.elecfans.com/tongxin/)

  [医疗电子](https://www.elecfans.com/yiliaodianzi/)

  [人工智能](https://www.elecfans.com/rengongzhineng/)

  [虚拟现实](https://www.elecfans.com/vr/)

  [可穿戴设备](https://www.elecfans.com/wearable/)

  [机器人](https://www.elecfans.com/jiqiren/)

  [安全设备/系统](https://www.elecfans.com/application/Security/)

  [军用/航空电子](https://www.elecfans.com/application/Military_avionics/)

  [移动通信](https://www.elecfans.com/application/Communication/)

  [工业控制](https://www.elecfans.com/kongzhijishu/)

  [便携设备](https://www.elecfans.com/consume/bianxiedianzishebei/)

  [触控感测](https://www.elecfans.com/consume/chukongjishu/)

  [物联网](https://www.elecfans.com/iot/)

  [智能电网](https://www.elecfans.com/dianyuan/diandongche_xinnenyuan/)

  [区块链](https://www.elecfans.com/blockchain/)

  [新科技](https://www.elecfans.com/xinkeji/)

- 特色内容

  [专栏推荐](https://www.elecfans.com/d/column/)

  [学院](https://t.elecfans.com/)

  [设计资源](https://bbs.elecfans.com/group_716)

  [设计技术](https://www.elecfans.com/technical/)

  [电子百科](https://www.elecfans.com/baike/)

  [电子视频](https://www.elecfans.com/dianzishipin/)

  [元器件知识](https://www.elecfans.com/yuanqijian/)

  [工具箱](https://www.elecfans.com/tools/)

  [VIP会员](https://www.elecfans.com/vip/#choose)

- 社区

  [小组](https://bbs.elecfans.com/group/)

  [论坛](https://bbs.elecfans.com/)

  [问答](https://bbs.elecfans.com/ask.html)

  [评测试用](https://bbs.elecfans.com/try.html)

- [企业服务](https://q.elecfans.com/)

  [产品](https://q.elecfans.com/p/)

  [资料](https://q.elecfans.com/soft/)

  [文章](https://q.elecfans.com/d/)

  [方案](https://q.elecfans.com/sol/)

  [企业](https://q.elecfans.com/c/)

- 供应链服务

  [硬件开发](https://www.elecfans.com/kf/)

  [华秋电路](https://www.hqpcb.com/)

  [华秋商城](https://www.hqchip.com/)

  [华秋智造](https://smt.hqchip.com/)

  [nextPCB](https://www.nextpcb.com/)

  [BOM配单](https://www.hqchip.com/bom.html)

- 媒体服务

  [网站广告](https://www.elecfans.com/help/service.html)

  [在线研讨会](https://webinar.elecfans.com/)

  [活动策划](https://event.elecfans.com/)

  [新闻发布](https://www.elecfans.com/news/)

  [新品发布](https://www.elecfans.com/xinpian/ic/)

  [小测验](https://www.elecfans.com/quiz/)

  [设计大赛](https://www.elecfans.com/contest/)

- 华秋

  [关于我们](https://www.elecfans.com/about/)

  [投资关系](https://www.hqchip.com/help/factsheet.html)

  [新闻动态](https://www.hqchip.com/help/news/lists.html)

  [加入我们](https://www.elecfans.com/about/zhaopin.html)

  [联系我们](https://www.elecfans.com/about/contact.html)

  [侵权投诉](https://bbs.elecfans.com/about/tousu.html)

- 社交网络

  [微博](https://weibo.com/elecfanscom)

- 移动端

  [发烧友APP](https://www.elecfans.com/app/)

  [硬声APP](https://yingsheng.elecfans.com/app?eleclog)

  [WAP](https://m.elecfans.com/)

- 联系我们

  广告合作

  王婉珠：[wangwanzhu@elecfans.com](mailto:wangwanzhu@elecfans.com)

  内容合作

  黄晶晶：[huangjingjing@elecfans.com](mailto:huangjingjing@elecfans.com)

  内容合作（海外）

  张迎辉：[mikezhang@elecfans.com](mailto:mikezhang@elecfans.com)

  供应链服务 PCB/IC/PCBA

  江良华：[lanhu@huaqiu.com](mailto:lanhu@huaqiu.com)

  投资合作

  曾海银：[zenghaiyin@huaqiu.com](mailto:zenghaiyin@huaqiu.com)

  社区合作

  刘勇：[liuyong@huaqiu.com](mailto:liuyong@huaqiu.com)

- 关注我们的微信

  

- 下载发烧友APP

  

- 电子发烧友观察

  

[               ![华秋电子](https://www.elecfans.com/static/footer/image/footer-01-default.png)                          ](https://www.huaqiu.com/)

​                      [                           ![华秋发烧友](https://www.elecfans.com/static/footer/image/footer-02-default.png)                                                  ](https://www.elecfans.com/)                  

​                      [                           ![华秋电路](https://www.elecfans.com/static/footer/image/footer-03-default.png)                                                  ](https://www.hqpcb.com/)                  

​                      [                           ![华秋商城](https://www.elecfans.com/static/footer/image/footer-04-default.png)                                                  ](https://www.hqchip.com/)                  

​                      [                           ![华秋智造](https://www.elecfans.com/static/footer/image/footer-05-default.png)                                                  ](https://smt.hqchip.com/)                  

​                      [                           ![NextPCB](https://www.elecfans.com/static/footer/image/footer-06-default.png)                                                  ](https://www.nextpcb.com/)                  

- [华秋简介](https://www.huaqiu.com/about/groupoverview)
- [企业动态](https://www.huaqiu.com/news)
- [联系我们](https://www.huaqiu.com/about/contactus)
- [企业文化](https://www.huaqiu.com/about/corporateculture)
- [企业宣传片](https://www.huaqiu.com/about/promotionalfilm)
- [加入我们](https://www.huaqiu.com/jobs)

版权所有 © 深圳华秋电子有限公司 

[电子发烧友](https://www.elecfans.com/)[**（电路图）**](https://www.elecfans.com/)[粤公网安备 44030402000349 号](https://www.beian.gov.cn/ode=440304portal/registerSystemInfo?recordc02000366)[电信与信息服务业务经营许可证：粤 B2-20160233](https://www.elecfans.com/about/edi.html)[           ![工商网监认证](https://skin.elecfans.com/images/ebsIcon.png)工商网监       ](http://szcert.ebs.org.cn/c6db625a-ba09-414a-bba4-f57240baac9c6)[粤ICP备 14022951 号](https://beian.miit.gov.cn/#/Integrated/index)

- ![time](https://bbs.elecfans.com/template/elecfans_201508/images/time.png)[最新主题](https://bbs.elecfans.com/default.php?view=default)
- ![recommend](https://bbs.elecfans.com/template/elecfans_201508/images/zan.png)[推荐主题](https://bbs.elecfans.com/default.php?view=recommend)
- ![hot](https://bbs.elecfans.com/template/elecfans_201508/images/re.png)[热门主题](https://bbs.elecfans.com/default.php?view=hot)
- ![post](https://bbs.elecfans.com/template/elecfans_201508/images/me.png) [我的帖子](javascript:;)

- **-**[技术社区](https://bbs.elecfans.com/forum.php?gid=1411)

  [HarmonyOS技术社区](https://bbs.elecfans.com/harmonyos)  [RISC-V MCU技术社区](https://bbs.elecfans.com/riscvmcu)

- **-**[OpenHarmony开源社区](https://bbs.elecfans.com/forum.php?gid=1510)

  [OpenHarmony开源社区](https://bbs.elecfans.com/zhuti_1511_1.html)

- **-**[嵌入式论坛](https://bbs.elecfans.com/forum.php?gid=3)

  [ARM技术论坛](https://bbs.elecfans.com/zhuti_arm_1.html)  [STM32/STM8技术论坛](https://bbs.elecfans.com/zhuti_stm32_1.html)  [RT-Thread嵌入式技术论坛](https://bbs.elecfans.com/zhuti_emb_1.html)  [单片机/MCU论坛](https://bbs.elecfans.com/zhuti_mcu_1.html)  [RISC-V技术论坛](https://bbs.elecfans.com/zhuti_risc_1.html)  [瑞芯微Rockchip开发者社区](https://bbs.elecfans.com/zhuti_1179_1.html)  [FPGA|CPLD|ASIC论坛](https://bbs.elecfans.com/zhuti_fpga_1.html)  [DSP论坛](https://bbs.elecfans.com/zhuti_DSP_1.html)

- **-**[电路图及DIY](https://bbs.elecfans.com/forum.php?gid=48)

- **-**[电源技术论坛](https://bbs.elecfans.com/forum.php?gid=752)

- **-**[综合技术与应用](https://bbs.elecfans.com/forum.php?gid=345)

- **-**[无线通信论坛](https://bbs.elecfans.com/forum.php?gid=6)

- **-**[EDA设计论坛](https://bbs.elecfans.com/forum.php?gid=1)

- **-**[测试测量论坛](https://bbs.elecfans.com/forum.php?gid=32)

- **-**[招聘/交友/外包/交易/杂谈](https://bbs.elecfans.com/forum.php?gid=27)

- **-**[官方社区](https://bbs.elecfans.com/forum.php?gid=829)

![time](https://bbs.elecfans.com/template/elecfans_201508/images/time.png) ![recommend](https://bbs.elecfans.com/template/elecfans_201508/images/zan.png) ![hot](https://bbs.elecfans.com/template/elecfans_201508/images/re.png) ![post](https://bbs.elecfans.com/template/elecfans_201508/images/me.png)

—
—
—

版
块
导
航



展开

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.01773991824388732&amp;zoneid=1029&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1107888_1_1.html" width="450" height="30" frameborder="0"></iframe>

*╳*

[![img](https://file.elecfans.com/web2/M00/7A/5B/poYBAGNx6JGAUvqIAACqaQrGZnQ426.png)](http://hqpcb.com/act/68cengban.html?fsydbtl)

[![电子技术论坛](https://bbs.elecfans.com/static/image/common/logo_new.png)](https://bbs.elecfans.com/)

- ​                            [首页](http://www.elecfans.com/)                                                    
- ​                            [论坛](https://bbs.elecfans.com/default.php)                                                                                                                                                
- ​                            [版块](https://bbs.elecfans.com/)                                                                                                                                                
- ​                            [小组](https://bbs.elecfans.com/group)                                                                                                                                                
- ​                            [活动](https://bbs.elecfans.com/zhuti_online_1.html)                                                                                                                                                
- ​                            [专栏](https://www.elecfans.com/d/)                                                                                                                                                
- ​                            [视频](https://www.elecfans.com/v/)                                                                                                                                                
- ​                            [问答](https://bbs.elecfans.com/ask/)                                                                                                                                                
- ​                            [下载](https://bbs.elecfans.com/soft/)                                                                                                                                                
- ​                            [学院](https://t.elecfans.com/)                                                                                                                                                
- ​                            [更多](javascript:;)                                                                                                                                                

|      |      |
| ---- | ---- |
|      |      |



​                                发 帖                             

- [登录/注册](javascript:;)

​                                                                                

- ![bread](https://bbs.elecfans.com/template/elecfans_201508/images/bread_img.png)[电子发烧友论坛](https://bbs.elecfans.com/forum.php)/

- ​        [EDA设计论坛](https://bbs.elecfans.com/forum.php?gid=1)/            

- ​        [KiCad EDA 中文论坛](https://bbs.elecfans.com/zhuti_kicad_1.html)                                

- /

  KiCAD教程（8），单片机引脚引出到端口

#             KiCAD教程（8），单片机引脚引出到端口        

[![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708/)[spark_zhang](https://bbs.elecfans.com/user/2164708/)

*2017-1-18 20:40:42**![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/wacth.png)*13672[单片机](https://www.elecfans.com/tags/单片机/)

​        

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.3675968429775929&amp;zoneid=223&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1108024_1_1.html" scrolling="no" width="728" height="90" frameborder="0"></iframe>

| *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zhichi.png)*                                                                                         0                                                                                                                             ![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/favorite.png)                        3                                                                                                                                                                                                                                                         我们都见过[单片机](https://bbs.elecfans.com/zhuti_mcu_1.html)[开发板](https://bbs.elecfans.com/try.html)，开发板顾名思义就是最大程度的使用单片机，学习单片机的各个功能。所以，我们要将单片机的所有IO引脚全部引出来。说起来简单，也不是随便哪个引脚接到排针上就可以了。这也是有讲究的！首先我们先看[STM32](https://bbs.elecfans.com/zhuti_stm32_1.html)单片机的引脚分布图。我们用到的是100引脚封装的单片机。一般都是讲单片机放到开发板的中间，将排针放到开发板的两侧，因此为了方便走线，单片机一般也都是倾斜45度放置，也就是单片机的四个边，每两个边连接一排排针。所以就将单片机从对角线一分两半，按这样的方法分开连接。如下图所示。   ![img](https://bbs.elecfans.com/data/attachment/forum/201701/18/203832knf5f6xdegzwgoo5.jpg)            从上图我们可以清楚的看出单片机被一分为二了。并且为了连接方便，我们把PE0和PE1分到了左半边，PB10和PB11分到了右半边。其中PC14和PC15由于带有连接玩不晶振作用，而且其IO的驱动能力特别小，因此就不作为单独的IO口引出，所以大家可以数一下左半部分有34个IO口，右半部分有44个IO口。这样我们在原理图中需要两个插排，一个是2*17，一个是2*22。  我们大脑中有了一个基本规划后就开始画原理图了。打开软件，还是选择放置[元件](https://bbs.elecfans.com/zhuti_yuanjian_1.html)选项。如下图所示，选择接插件。分别找到2*17和2*22的接插件。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)        放置好排针后，我们用网络标号将其与单片机连接。此时也要注意，单片机的相应引脚也要标上同样的网络标号，这样才表示相应的引脚连接成功。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)        这样我们原理图就放好了。接下来就是给原件添加封装了。我们单片机的封装之前画过，排针的封装也要重新画一下。    打开我们[PCB](https://bbs.elecfans.com/zhuti_pads_1.html)封装编辑器，添加我们自己的库。然后选择新建封装。下图为双排针的封装尺寸。其中钻孔的直径为1.02mm,排针的间距为2.54mm。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        因此我们只需将焊盘钻孔设置为1.02mm,  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        将图纸的网格宽度设置为1.27mm,这样我们只需每隔两个网格放置一个焊盘即可。如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        为了方便找到第一引脚，一般情况下将1引脚焊盘设置为方形。用同样的方法，我们画2*22的引脚封装，如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        之后保存关闭即可。    接下来打开原理图，双击排针给排针添加引脚封装即可。分别如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)        我们添加完封装后，会在原件上显示封装的名字，这是我们可以用鼠标点住封装名字，然后点E编辑，选择不可见。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        至此，单片机的排针就画好了！  最后祝大家学习愉快！！！ |
| ------------------------------------------------------------ |
| [只看该作者](https://bbs.elecfans.com/forum.php?mod=viewthread&tid=1108024&page=1&authorid=2164708)                                                                                                                                                                [*![分享](https://bbs.elecfans.com/static/image/common/collection.png)淘帖*](https://bbs.elecfans.com/forum.php?mod=collection&action=edit&op=addthread&tid=1108024)                                                                                                    [举报](javascript:;)                                                                                                                                                                                                                                                                                                                                                                                                   相关推荐                                                                                                                                                                                                                                                                                                                                                                [                                                     • 单片机端口对LED灯的控制方法                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         1638*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2258824_1_1.html)                                                                                                                                                                                    [                                                     • 谈一谈STM32单片机端口复用和端口重映射                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         1436*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2258041_1_1.html)                                                                                                                                                                                    [                                                     • 基于STC8系列单片机的核心板设计                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         1013*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2254162_1_1.html)                                                                                                                                                                                    [                                                     • 单片机的引脚介绍                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         1054*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2200671_1_1.html)                                                                                                                                                                                    [                                                     • 基于89C51单片机的8位端口检测8独立按键源程序                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/d_load.png)                                                         0*                                                                                                                                                               ](https://www.elecfans.com/soft/33/2023/202305112079320.html)                                                                                                                                                                                    [                                                     • 使用单片机实现8位端口检测8独立按键的C语言实例免费下载                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/d_load.png)                                                         13*                                                                                                                                                               ](https://www.elecfans.com/soft/6/2020/202011201388500.html)                                                                                                                                                                                    [                                                     • 如何设计一个节约单片机端口资源的键盘电路                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         3300*                                                                                                                                                               ](https://www.elecfans.com/d/1208706.html)                                                                                                                                                                                    [                                                     • 单片机的引脚图及引脚功能_单片机简易编程                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         38844*                                                                                                                                                               ](https://www.elecfans.com/d/998418.html)                                                                                                                                                                                    [                                                     • AT89C51单片机的P2端口接有8只LED                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         3497*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2123132_1_1.html)                                                                                                                                                                                    [                                                     • 请问TPS74401中EN引脚能当做IO口引出到MCU上吗？                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         1809*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_1760635_1_1.html)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          *1* 条评论                                                                                                                        [只看该作者](https://bbs.elecfans.com/forum.php?mod=viewthread&tid=1108024&page=1&authorid=2164708) |

|      |
| ---- |
|      |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/25/55/67_avatar_middle.jpg)](https://bbs.elecfans.com/user/2255567/)                                                                            [辛太励](https://bbs.elecfans.com/user/2255567/)                                        *2017-1-19 09:32:58*                                                                                                                                                                                                    [                                                                                                                                                                                                                                                   沙发                                                                                                                                                                                                                                        ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1108024&pid=5436741)                                                                                                                                                                                    非常有用的资料 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/001/01/76/13_avatar_middle.jpg)](https://bbs.elecfans.com/user/1017613/)                                                                            [林宝](https://bbs.elecfans.com/user/1017613/)                                        *2019-12-2 18:22:59*                                                                                                                                                                                                    [                                                                                                                                                                                                                                                   板凳                                                                                                                                                                                                                                        ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1108024&pid=7945361)                                                                                                                                                                                    "谢谢楼主分享，路过看看" |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

### 评论

[B](javascript:;) [Color](javascript:;)   [Link](javascript:;) [Quote](javascript:;) [Code](javascript:;) [Smilies](javascript:;)     您需要登录后才可以回帖 [登录/注册](javascript:;)



声明：本文内容及配图由入驻作者撰写或者入驻合作网站授权转载。文章观点仅代表作者本人，不代表电子发烧友网立场。文章及其配图仅供工程师学习之用，如有内容图片侵权或者其他问题，请联系本站作侵删。 [侵权投诉](https://www.elecfans.com/about/tousu.html)

​    

[                             发经验                         ](https://bbs.elecfans.com/forum.php?mod=post&action=newthread&fid=1339&special=7)

[![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708)

[spark_zhang](https://bbs.elecfans.com/user/2164708) 





技术员 

积分：167经验：101

- 主题

  ##### 22

- 文章

  ##### 0

- 粉丝

  ##### 43

+关注

发私信

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.6174791204162209&amp;zoneid=242&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1108024_1_1.html" scrolling="no" width="300" height="250" frameborder="0"></iframe>

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.569185517122191&amp;zoneid=781&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1108024_1_1.html" scrolling="no" width="300" height="125" frameborder="0"></iframe>

### 直播

[查看更多 >>](https://t.elecfans.com/live)

![img](https://file.elecfans.com/web2/M00/43/F3/pYYBAGKCLNCAfe1iAAEAAYXz0ZQ341.png)

【新品发布】IFX新款开发板发布与上手培训

2023/4/12 15:00  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

【开源芯片系列讲座】RISC-V计算软件栈与高性能计算进展

2023/4/7 20:00  回顾

![img](https://file.elecfans.com/web2/M00/01/14/pYYBAGDBfdOAAsnuAADpn0dJLuQ131.png)

开放原子开源基金会“源聚一堂”开源技术沙龙

2023/4/7 09:00  回顾

![img](https://file.elecfans.com/web2/M00/13/37/pYYBAGEwm8iACBfmAAEbdg3hPPo606.png)

《OpenHarmony“芯”进展》系列直播课——LoongArch专场

2023/4/4 18:55  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【OpenHarmony】2023开放原子校源行（北京站）

2023/4/2 09:24  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

OpenHarmony知识赋能No.28-OpenHarmony系统的驱动架构解析

2023/3/30 18:55  回顾

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座03期-T507-H 处理器音频接口的详细讲解

2023/5/25 19:00 报名中

![img](https://file.elecfans.com/web1/M00/CE/20/o4YBAF-iaBOAfClHAADS3eM3IVY279.jpg)

【创龙分享】国产工业嵌入式处理器架构解析

2023/5/25 19:00 报名中

![img](https://file.elecfans.com/web2/M00/01/14/pYYBAGDBfdOAAsnuAADpn0dJLuQ131.png)

OpenHarmony创新赛赛事宣讲会

2023/5/31 14:30 报名中

![img](https://file.elecfans.com/web2/M00/61/AB/pYYBAGL7hJaACg3NAAAX92fOR8889.jpeg)

开源硬件系列08期：片上网络的过去、现在和将来

2023/5/31 19:30 报名中

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座02期-NXP i.MX 9352处理器的I3C接口详解

2023/5/18 19:00  回顾

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座01期-基于rpmsg的多核异构产品双核通信应用实现

2023/5/11 19:00  回顾

![img](https://file.elecfans.com/web2/M00/72/74/pYYBAGNR9yCABb_lAAANs78gSRY396.jpg)

《RK3588 PCB设计指导白皮书》线上发布&实战解读

2023/5/11 13:50  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

开源芯片系列讲座第09期：RISC-V软硬件协同设计全流程软件栈

2023/5/10 15:00  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

OpenHarmony知识赋能No.29-DAYU200分布式应用开发

2023/5/4 19:00  回顾

![img](https://file.elecfans.com/web2/M00/61/AB/pYYBAGL7hJaACg3NAAAX92fOR8889.jpeg)

开源硬件系列07期：基于生成器方法学的CGRA(可重构计算)设计

2023/4/27 19:30  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【2023】OpenHarmony开发者大会：技术论坛

2023/4/19 14:00  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【2023】OpenHarmony开发者大会：主论坛

2023/4/19 09:35  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

RISC-V 开发平台 Milk-V Pioneer 发布会

2023/4/15 15:00  回顾

![img](https://file.elecfans.com/web2/M00/3F/EF/poYBAGJqh3-AFAm_AAGpPtG2eAM315.png)

国产EDA软件新星03期-Venus智能建库工具介绍

2023/4/13 19:00  回顾

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.5144043748916477&amp;zoneid=224&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1108024_1_1.html" scrolling="no" width="300" height="600" frameborder="0"></iframe>

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.2687326066262651&amp;zoneid=678&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1108024_1_1.html" scrolling="no" width="300" height="255" frameborder="0"></iframe>

​                    

广告![img](https://bbs.elecfans.com/static/image/ad/ad_close.png)[![img](https://file.elecfans.com/web2/M00/A6/17/poYBAGRlm9mAE1NyAAKVQhm_F6A861.png)](https://t.elecfans.com/live/2334.html?from=Pltdb)

[关闭](javascript:;)

##                  站长推荐                ![上一条](https://bbs.elecfans.com/static/image/common/pic_nv_prev.gif) *3/7* ![下一条](https://bbs.elecfans.com/static/image/common/pic_nv_next.gif)            

- [【线下会议】汽车电子：时下最火热的赛道之一！](https://www.elecfans.com/activity/Automotive-202306/index.html?elecfans_source=textlink8)        

  此次汽车电子创新技术研讨会，邀请汽车生态圈的合作伙伴，共话未来汽车智能化发展趋势，技术和解决方案。 2023汽车电子创新技术研讨会>> 立即报名

[查看 »](https://www.elecfans.com/activity/Automotive-202306/index.html?elecfans_source=textlink8)

- 华秋（原“华强聚丰”）：

  电子发烧友

  华秋开发

  华秋电路(原"华强PCB")

  华秋商城(原"华强芯城")

  华秋智造



- 设计技术

  [可编程逻辑](https://www.elecfans.com/pld/)

  [电源/新能源](https://www.elecfans.com/article/83/)

  [MEMS/传感技术](https://www.elecfans.com/article/88/142/)

  [测量仪表](https://www.elecfans.com/article/85/)

  [嵌入式技术](https://www.elecfans.com/emb/)

  [制造/封装](https://www.elecfans.com/article/90/155/)

  [模拟技术](https://www.elecfans.com/analog/)

  [RF/无线](https://www.elecfans.com/tongxin/rf/)

  [接口/总线/驱动](https://www.elecfans.com/emb/jiekou/)

  [处理器/DSP](https://www.elecfans.com/emb/dsp/)

  [EDA/IC设计](https://www.elecfans.com/bandaoti/eda/)

  [存储技术](https://www.elecfans.com/consume/cunchujishu/)

  [光电显示](https://www.elecfans.com/xianshi/)

  [EMC/EMI设计](https://www.elecfans.com/emc_emi/)

  [连接器](https://www.elecfans.com/connector/)

- 行业应用

  [LEDs ](https://www.elecfans.com/led/)

  [汽车电子](https://www.elecfans.com/qichedianzi/)

  [音视频及家电](https://www.elecfans.com/video/)

  [通信网络](https://www.elecfans.com/tongxin/)

  [医疗电子](https://www.elecfans.com/yiliaodianzi/)

  [人工智能](https://www.elecfans.com/rengongzhineng/)

  [虚拟现实](https://www.elecfans.com/vr/)

  [可穿戴设备](https://www.elecfans.com/wearable/)

  [机器人](https://www.elecfans.com/jiqiren/)

  [安全设备/系统](https://www.elecfans.com/application/Security/)

  [军用/航空电子](https://www.elecfans.com/application/Military_avionics/)

  [移动通信](https://www.elecfans.com/application/Communication/)

  [工业控制](https://www.elecfans.com/kongzhijishu/)

  [便携设备](https://www.elecfans.com/consume/bianxiedianzishebei/)

  [触控感测](https://www.elecfans.com/consume/chukongjishu/)

  [物联网](https://www.elecfans.com/iot/)

  [智能电网](https://www.elecfans.com/dianyuan/diandongche_xinnenyuan/)

  [区块链](https://www.elecfans.com/blockchain/)

  [新科技](https://www.elecfans.com/xinkeji/)

- 特色内容

  [专栏推荐](https://www.elecfans.com/d/column/)

  [学院](https://t.elecfans.com/)

  [设计资源](https://bbs.elecfans.com/group_716)

  [设计技术](https://www.elecfans.com/technical/)

  [电子百科](https://www.elecfans.com/baike/)

  [电子视频](https://www.elecfans.com/dianzishipin/)

  [元器件知识](https://www.elecfans.com/yuanqijian/)

  [工具箱](https://www.elecfans.com/tools/)

  [VIP会员](https://www.elecfans.com/vip/#choose)

- 社区

  [小组](https://bbs.elecfans.com/group/)

  [论坛](https://bbs.elecfans.com/)

  [问答](https://bbs.elecfans.com/ask.html)

  [评测试用](https://bbs.elecfans.com/try.html)

- [企业服务](https://q.elecfans.com/)

  [产品](https://q.elecfans.com/p/)

  [资料](https://q.elecfans.com/soft/)

  [文章](https://q.elecfans.com/d/)

  [方案](https://q.elecfans.com/sol/)

  [企业](https://q.elecfans.com/c/)

- 供应链服务

  [硬件开发](https://www.elecfans.com/kf/)

  [华秋电路](https://www.hqpcb.com/)

  [华秋商城](https://www.hqchip.com/)

  [华秋智造](https://smt.hqchip.com/)

  [nextPCB](https://www.nextpcb.com/)

  [BOM配单](https://www.hqchip.com/bom.html)

- 媒体服务

  [网站广告](https://www.elecfans.com/help/service.html)

  [在线研讨会](https://webinar.elecfans.com/)

  [活动策划](https://event.elecfans.com/)

  [新闻发布](https://www.elecfans.com/news/)

  [新品发布](https://www.elecfans.com/xinpian/ic/)

  [小测验](https://www.elecfans.com/quiz/)

  [设计大赛](https://www.elecfans.com/contest/)

- 华秋

  [关于我们](https://www.elecfans.com/about/)

  [投资关系](https://www.hqchip.com/help/factsheet.html)

  [新闻动态](https://www.hqchip.com/help/news/lists.html)

  [加入我们](https://www.elecfans.com/about/zhaopin.html)

  [联系我们](https://www.elecfans.com/about/contact.html)

  [侵权投诉](https://bbs.elecfans.com/about/tousu.html)

- 社交网络

  [微博](https://weibo.com/elecfanscom)

- 移动端

  [发烧友APP](https://www.elecfans.com/app/)

  [硬声APP](https://yingsheng.elecfans.com/app?eleclog)

  [WAP](https://m.elecfans.com/)

- 联系我们

  广告合作

  王婉珠：[wangwanzhu@elecfans.com](mailto:wangwanzhu@elecfans.com)

  内容合作

  黄晶晶：[huangjingjing@elecfans.com](mailto:huangjingjing@elecfans.com)

  内容合作（海外）

  张迎辉：[mikezhang@elecfans.com](mailto:mikezhang@elecfans.com)

  供应链服务 PCB/IC/PCBA

  江良华：[lanhu@huaqiu.com](mailto:lanhu@huaqiu.com)

  投资合作

  曾海银：[zenghaiyin@huaqiu.com](mailto:zenghaiyin@huaqiu.com)

  社区合作

  刘勇：[liuyong@huaqiu.com](mailto:liuyong@huaqiu.com)

- 关注我们的微信

  

- 下载发烧友APP

  

- 电子发烧友观察

  

[               ![华秋电子](https://www.elecfans.com/static/footer/image/footer-01-default.png)                          ](https://www.huaqiu.com/)

​                      [                           ![华秋发烧友](https://www.elecfans.com/static/footer/image/footer-02-default.png)                                                  ](https://www.elecfans.com/)                  

​                      [                           ![华秋电路](https://www.elecfans.com/static/footer/image/footer-03-default.png)                                                  ](https://www.hqpcb.com/)                  

​                      [                           ![华秋商城](https://www.elecfans.com/static/footer/image/footer-04-default.png)                                                  ](https://www.hqchip.com/)                  

​                      [                           ![华秋智造](https://www.elecfans.com/static/footer/image/footer-05-default.png)                                                  ](https://smt.hqchip.com/)                  

​                      [                           ![NextPCB](https://www.elecfans.com/static/footer/image/footer-06-default.png)                                                  ](https://www.nextpcb.com/)                  

- [华秋简介](https://www.huaqiu.com/about/groupoverview)
- [企业动态](https://www.huaqiu.com/news)
- [联系我们](https://www.huaqiu.com/about/contactus)
- [企业文化](https://www.huaqiu.com/about/corporateculture)
- [企业宣传片](https://www.huaqiu.com/about/promotionalfilm)
- [加入我们](https://www.huaqiu.com/jobs)

版权所有 © 深圳华秋电子有限公司 

[电子发烧友](https://www.elecfans.com/)[**（电路图）**](https://www.elecfans.com/)[粤公网安备 44030402000349 号](https://www.beian.gov.cn/ode=440304portal/registerSystemInfo?recordc02000366)[电信与信息服务业务经营许可证：粤 B2-20160233](https://www.elecfans.com/about/edi.html)[           ![工商网监认证](https://skin.elecfans.com/images/ebsIcon.png)工商网监       ](http://szcert.ebs.org.cn/c6db625a-ba09-414a-bba4-f57240baac9c6)[粤ICP备 14022951 号](https://beian.miit.gov.cn/#/Integrated/index)

- ![time](https://bbs.elecfans.com/template/elecfans_201508/images/time.png)[最新主题](https://bbs.elecfans.com/default.php?view=default)
- ![recommend](https://bbs.elecfans.com/template/elecfans_201508/images/zan.png)[推荐主题](https://bbs.elecfans.com/default.php?view=recommend)
- ![hot](https://bbs.elecfans.com/template/elecfans_201508/images/re.png)[热门主题](https://bbs.elecfans.com/default.php?view=hot)
- ![post](https://bbs.elecfans.com/template/elecfans_201508/images/me.png) [我的帖子](javascript:;)

- **-**[技术社区](https://bbs.elecfans.com/forum.php?gid=1411)

  [HarmonyOS技术社区](https://bbs.elecfans.com/harmonyos)  [RISC-V MCU技术社区](https://bbs.elecfans.com/riscvmcu)

- **-**[OpenHarmony开源社区](https://bbs.elecfans.com/forum.php?gid=1510)

  [OpenHarmony开源社区](https://bbs.elecfans.com/zhuti_1511_1.html)

- **-**[嵌入式论坛](https://bbs.elecfans.com/forum.php?gid=3)

  [ARM技术论坛](https://bbs.elecfans.com/zhuti_arm_1.html)  [STM32/STM8技术论坛](https://bbs.elecfans.com/zhuti_stm32_1.html)  [RT-Thread嵌入式技术论坛](https://bbs.elecfans.com/zhuti_emb_1.html)  [单片机/MCU论坛](https://bbs.elecfans.com/zhuti_mcu_1.html)  [RISC-V技术论坛](https://bbs.elecfans.com/zhuti_risc_1.html)  [瑞芯微Rockchip开发者社区](https://bbs.elecfans.com/zhuti_1179_1.html)  [FPGA|CPLD|ASIC论坛](https://bbs.elecfans.com/zhuti_fpga_1.html)  [DSP论坛](https://bbs.elecfans.com/zhuti_DSP_1.html)

- **-**[电路图及DIY](https://bbs.elecfans.com/forum.php?gid=48)

- **-**[电源技术论坛](https://bbs.elecfans.com/forum.php?gid=752)

- **-**[综合技术与应用](https://bbs.elecfans.com/forum.php?gid=345)

- **-**[无线通信论坛](https://bbs.elecfans.com/forum.php?gid=6)

- **-**[EDA设计论坛](https://bbs.elecfans.com/forum.php?gid=1)

- **-**[测试测量论坛](https://bbs.elecfans.com/forum.php?gid=32)

- **-**[招聘/交友/外包/交易/杂谈](https://bbs.elecfans.com/forum.php?gid=27)

- **-**[官方社区](https://bbs.elecfans.com/forum.php?gid=829)

![time](https://bbs.elecfans.com/template/elecfans_201508/images/time.png) ![recommend](https://bbs.elecfans.com/template/elecfans_201508/images/zan.png) ![hot](https://bbs.elecfans.com/template/elecfans_201508/images/re.png) ![post](https://bbs.elecfans.com/template/elecfans_201508/images/me.png)

—
—
—

版
块
导
航



展开

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.48346372229628476&amp;zoneid=1029&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1108024_1_1.html" width="450" height="30" frameborder="0"></iframe>

*╳*

[![img](https://file.elecfans.com/web2/M00/7A/5B/poYBAGNx6JGAUvqIAACqaQrGZnQ426.png)](http://hqpcb.com/act/68cengban.html?fsydbtl)

[![电子技术论坛](https://bbs.elecfans.com/static/image/common/logo_new.png)](https://bbs.elecfans.com/)

- ​                            [首页](http://www.elecfans.com/)                                                    
- ​                            [论坛](https://bbs.elecfans.com/default.php)                                                                                                                                                
- ​                            [版块](https://bbs.elecfans.com/)                                                                                                                                                
- ​                            [小组](https://bbs.elecfans.com/group)                                                                                                                                                
- ​                            [活动](https://bbs.elecfans.com/zhuti_online_1.html)                                                                                                                                                
- ​                            [专栏](https://www.elecfans.com/d/)                                                                                                                                                
- ​                            [视频](https://www.elecfans.com/v/)                                                                                                                                                
- ​                            [问答](https://bbs.elecfans.com/ask/)                                                                                                                                                
- ​                            [下载](https://bbs.elecfans.com/soft/)                                                                                                                                                
- ​                            [学院](https://t.elecfans.com/)                                                                                                                                                
- ​                            [更多](javascript:;)                                                                                                                                                

|      |      |
| ---- | ---- |
|      |      |



​                                发 帖                             

- [登录/注册](javascript:;)

​                                                                                

- ![bread](https://bbs.elecfans.com/template/elecfans_201508/images/bread_img.png)[电子发烧友论坛](https://bbs.elecfans.com/forum.php)/

- ​        [EDA设计论坛](https://bbs.elecfans.com/forum.php?gid=1)/            

- ​        [KiCad EDA 中文论坛](https://bbs.elecfans.com/zhuti_kicad_1.html)                                

- /

  KiCAD教程（9），单片机串口下载电路及仿真器电路 ...

#             KiCAD教程（9），单片机串口下载电路及仿真器电路        

[![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708/)[spark_zhang](https://bbs.elecfans.com/user/2164708/)

*2017-1-19 21:06:08*![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png) 10852[单片机](https://www.elecfans.com/tags/单片机/)[仿真器](https://www.elecfans.com/tags/仿真器/)[KiCAD](https://www.elecfans.com/tags/KiCAD/)

​        

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.14991425985051365&amp;zoneid=223&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1108156_1_1.html" scrolling="no" width="728" height="90" frameborder="0"></iframe>

| *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zhichi.png)*                                                                                         0                                                                                                                             ![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/favorite.png)                        5                                                                                                                                                                                                                                                         `当然[单片机](https://bbs.elecfans.com/zhuti_mcu_1.html)的下载程序的方式有很多，本次要讲的是用串口下载的[电路](https://bbs.elecfans.com/zhuti_dianlu_1.html)。首先打开我们之前画的原理图，还记得上次我们画[电源](https://bbs.elecfans.com/zhuti_power_1.html)部分添加了一个USB吗？对，就是通过这个USB接口连接。串口下载我们用到的是CH340G芯片，先将次芯片放到USB的旁边。除了用到这个芯片，我们还需要一个晶振，以及晶振电路的两个电容，芯片电源接的去耦电容一个，将这些[元件](https://bbs.elecfans.com/zhuti_yuanjian_1.html)都放置好，我们就开始接线了。   ![img](https://bbs.elecfans.com/data/attachment/forum/201701/19/210316rjajdeaivdveze1v.png)          如上图所示，将线接好后，再更改一下选取电容值，其中12M晶振电路中我们采用22pF，去耦电容采用0.1uF。  接下来我们又要用到网络标号了，这个串口电路我们采用串口1，因此找到单片机的串口1引脚，分别标上TXD_1和RXD_1.。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)         然后我们再画一个双排针，这样，通过一个双排针再加上跳线帽就可以选择通断了。如下图就是跳线帽。我们选择添加元件，找到2*7的双排针。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        放置后按下图所示放好网络标号。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        这样我们可以通过跳线帽选择接通与断开。    由于单片机正常工作时，BOOT0是低电平，CH340正常工作时14引脚是高电平，因此我们需要一个三极管接到14引脚，起到反向作用。三极管我们选择npn。如下图所示，注意引脚编号，不要选错了。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        具体型号选择s8050.datasheet如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        正因为如此，我们画原理图的时候才要注意引脚的编号。具体的连接如下图所示。记住要在基级加上限流电阻。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        这样有了三极管电路，如果14引脚为高电平，则三极管导通，即使三极管有压降，也是很低的，BOOT0_CTR相当于接地了。    最后就是给原件添加封装了。这个我们之前讲过，电容电阻还是选择0603的封装。CH340G的封装我们之前画过，因此直接添加就行，晶振的封装我们选择直插的。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        三极管的封装选择如下图。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        现在就差双排插针的封装了，这个需要我们自己画，画法还跟之前讲的一样。打开[PCB](https://bbs.elecfans.com/zhuti_pads_1.html)封装。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        引脚间距选择2.5mm。钻孔1.02，焊盘1.6.保存后再原理图中添加即可。这样我们串口下载电路就画好了！ 除了上次讲的用串口下载的方法之外，还可以通过JTAG下载。它长什么样呢？下图是老顽童[开发板](https://bbs.elecfans.com/try.html)中JTAG接口。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        也就是需要一个20引脚的牛角座。  大家可以访问这个网站：http://www.rationmcu.com/stm32/2125.html 详细的了解下JTAG。由于本次介绍的是原理图的画法，因此我们直接将原理图贴出来，照此话出来即可！  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        打开原理图，先放置一个2*10引脚的双排针。按照上图将线接好。上图中左边部分9个引脚要接地。这时候注意画线的时候要一个一个画，不然是连不上的。当出现蓝色的小黑点时才表明交叉线是接上的。右边是用网络标号连接的，对应还应该在单片机上做好网络标号。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)        就这么简单，JTAG电路就接好了！最后还要给双排针添加封装，这个我们还需要自己画，方法还跟之前讲的一样。画好后保存在原理图中添加封装接口！  `  ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif) |
| ------------------------------------------------------------ |
| [只看该作者](https://bbs.elecfans.com/forum.php?mod=viewthread&tid=1108156&page=1&authorid=2164708)                                                                                                                                                                [*![分享](https://bbs.elecfans.com/static/image/common/collection.png)淘帖*](https://bbs.elecfans.com/forum.php?mod=collection&action=edit&op=addthread&tid=1108156)                                                                                                    [举报](javascript:;)                                                                                                                                                                                                                                                                                                                                                                                                   相关推荐                                                                                                                                                                                                                                                                                                                                                                [                                                     • 单片机仿真器的相关资料下载                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         1163*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2200561_1_1.html)                                                                                                                                                                                    [                                                     • 单片机仿真器是什么？有何作用                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         3299*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2194025_1_1.html)                                                                                                                                                                                    [                                                     • Proteus软件—单片机仿真器软件                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         3418*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_1652355_1_1.html)                                                                                                                                                                                    [                                                     • 单片机下载程序电路原理分享                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         6084*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_528865_1_1.html)                                                                                                                                                                                    [                                                     • 串口，USB，USB转串口，串口驱动，仿真器下载程序                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/d_load.png)                                                         1*                                                                                                                                                               ](https://www.elecfans.com/soft/33/2021/202112041752007.html)                                                                                                                                                                                    [                                                     • 单片机与PC机串口通讯仿真的程序和电路图免费下载                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/d_load.png)                                                         35*                                                                                                                                                               ](https://www.elecfans.com/soft/33/2020/202005261222417.html)                                                                                                                                                                                    [                                                     • 单片机仿真器的介绍及应用                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         1221*                                                                                                                                                               ](https://www.elecfans.com/bandaoti/eda/20180715710508.html)                                                                                                                                                                                    [                                                     • 什么是单片机仿真器_单片机仿真器有什么用_单片机仿真器怎么用                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         15751*                                                                                                                                                               ](https://www.elecfans.com/dianzichangshi/20180416662521.html)                                                                                                                                                                                    [                                                     • atmage128 AVR单片机 JTAG仿真器下载正常 仿真时出错                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         2023*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_412728_1_1.html)                                                                                                                                                                                    [                                                     • 单片机的硬件仿真123                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         3174*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_405640_1_1.html) |
|                                                              |

### 评论

[B](javascript:;) [Color](javascript:;)   [Link](javascript:;) [Quote](javascript:;) [Code](javascript:;) [Smilies](javascript:;)     您需要登录后才可以回帖 [登录/注册](javascript:;)



声明：本文内容及配图由入驻作者撰写或者入驻合作网站授权转载。文章观点仅代表作者本人，不代表电子发烧友网立场。文章及其配图仅供工程师学习之用，如有内容图片侵权或者其他问题，请联系本站作侵删。 [侵权投诉](https://www.elecfans.com/about/tousu.html)

​    

[                             发经验                         ](https://bbs.elecfans.com/forum.php?mod=post&action=newthread&fid=1339&special=7)

[![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708)

[spark_zhang](https://bbs.elecfans.com/user/2164708) 





技术员 

积分：167经验：101

- 主题

  ##### 22

- 文章

  ##### 0

- 粉丝

  ##### 43

+关注

发私信

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.9760515886672264&amp;zoneid=242&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1108156_1_1.html" scrolling="no" width="300" height="250" frameborder="0"></iframe>

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.39923532920572&amp;zoneid=781&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1108156_1_1.html" scrolling="no" width="300" height="125" frameborder="0"></iframe>

### 直播

[查看更多 >>](https://t.elecfans.com/live)

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

OpenHarmony知识赋能No.28-OpenHarmony系统的驱动架构解析

2023/3/30 18:55  回顾

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座03期-T507-H 处理器音频接口的详细讲解

2023/5/25 19:00 报名中

![img](https://file.elecfans.com/web1/M00/CE/20/o4YBAF-iaBOAfClHAADS3eM3IVY279.jpg)

【创龙分享】国产工业嵌入式处理器架构解析

2023/5/25 19:00 报名中

![img](https://file.elecfans.com/web2/M00/01/14/pYYBAGDBfdOAAsnuAADpn0dJLuQ131.png)

OpenHarmony创新赛赛事宣讲会

2023/5/31 14:30 报名中

![img](https://file.elecfans.com/web2/M00/61/AB/pYYBAGL7hJaACg3NAAAX92fOR8889.jpeg)

开源硬件系列08期：片上网络的过去、现在和将来

2023/5/31 19:30 报名中

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座02期-NXP i.MX 9352处理器的I3C接口详解

2023/5/18 19:00  回顾

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座01期-基于rpmsg的多核异构产品双核通信应用实现

2023/5/11 19:00  回顾

![img](https://file.elecfans.com/web2/M00/72/74/pYYBAGNR9yCABb_lAAANs78gSRY396.jpg)

《RK3588 PCB设计指导白皮书》线上发布&实战解读

2023/5/11 13:50  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

开源芯片系列讲座第09期：RISC-V软硬件协同设计全流程软件栈

2023/5/10 15:00  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

OpenHarmony知识赋能No.29-DAYU200分布式应用开发

2023/5/4 19:00  回顾

![img](https://file.elecfans.com/web2/M00/61/AB/pYYBAGL7hJaACg3NAAAX92fOR8889.jpeg)

开源硬件系列07期：基于生成器方法学的CGRA(可重构计算)设计

2023/4/27 19:30  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【2023】OpenHarmony开发者大会：技术论坛

2023/4/19 14:00  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【2023】OpenHarmony开发者大会：主论坛

2023/4/19 09:35  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

RISC-V 开发平台 Milk-V Pioneer 发布会

2023/4/15 15:00  回顾

![img](https://file.elecfans.com/web2/M00/3F/EF/poYBAGJqh3-AFAm_AAGpPtG2eAM315.png)

国产EDA软件新星03期-Venus智能建库工具介绍

2023/4/13 19:00  回顾

![img](https://file.elecfans.com/web2/M00/43/F3/pYYBAGKCLNCAfe1iAAEAAYXz0ZQ341.png)

【新品发布】IFX新款开发板发布与上手培训

2023/4/12 15:00  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

【开源芯片系列讲座】RISC-V计算软件栈与高性能计算进展

2023/4/7 20:00  回顾

![img](https://file.elecfans.com/web2/M00/01/14/pYYBAGDBfdOAAsnuAADpn0dJLuQ131.png)

开放原子开源基金会“源聚一堂”开源技术沙龙

2023/4/7 09:00  回顾

![img](https://file.elecfans.com/web2/M00/13/37/pYYBAGEwm8iACBfmAAEbdg3hPPo606.png)

《OpenHarmony“芯”进展》系列直播课——LoongArch专场

2023/4/4 18:55  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【OpenHarmony】2023开放原子校源行（北京站）

2023/4/2 09:24  回顾

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.4158239071948513&amp;zoneid=224&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1108156_1_1.html" scrolling="no" width="300" height="600" frameborder="0"></iframe>

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.22916277782294325&amp;zoneid=678&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1108156_1_1.html" scrolling="no" width="300" height="255" frameborder="0"></iframe>

​                    

广告![img](https://bbs.elecfans.com/static/image/ad/ad_close.png)[![img](https://file.elecfans.com/web2/M00/A6/D6/pYYBAGRnDtqAO7mSAAJXTJBhXM8305.jpg)](https://smt.hqchip.com/online.html?from=Pltdb)

[关闭](javascript:;)

##                  站长推荐                ![上一条](https://bbs.elecfans.com/static/image/common/pic_nv_prev.gif) *7/7* ![下一条](https://bbs.elecfans.com/static/image/common/pic_nv_next.gif)            

- [【免费领取】](https://url.elecfans.com/u/260fc9c6fe)        

  华秋电子将联合瑞芯微、凡亿重磅发布《RK3588 PCB设计指导白皮书》，免费下载！

[查看 »](https://url.elecfans.com/u/260fc9c6fe)

- 华秋（原“华强聚丰”）：

  电子发烧友

  华秋开发

  华秋电路(原"华强PCB")

  华秋商城(原"华强芯城")

  华秋智造



- 设计技术

  [可编程逻辑](https://www.elecfans.com/pld/)

  [电源/新能源](https://www.elecfans.com/article/83/)

  [MEMS/传感技术](https://www.elecfans.com/article/88/142/)

  [测量仪表](https://www.elecfans.com/article/85/)

  [嵌入式技术](https://www.elecfans.com/emb/)

  [制造/封装](https://www.elecfans.com/article/90/155/)

  [模拟技术](https://www.elecfans.com/analog/)

  [RF/无线](https://www.elecfans.com/tongxin/rf/)

  [接口/总线/驱动](https://www.elecfans.com/emb/jiekou/)

  [处理器/DSP](https://www.elecfans.com/emb/dsp/)

  [EDA/IC设计](https://www.elecfans.com/bandaoti/eda/)

  [存储技术](https://www.elecfans.com/consume/cunchujishu/)

  [光电显示](https://www.elecfans.com/xianshi/)

  [EMC/EMI设计](https://www.elecfans.com/emc_emi/)

  [连接器](https://www.elecfans.com/connector/)

- 行业应用

  [LEDs ](https://www.elecfans.com/led/)

  [汽车电子](https://www.elecfans.com/qichedianzi/)

  [音视频及家电](https://www.elecfans.com/video/)

  [通信网络](https://www.elecfans.com/tongxin/)

  [医疗电子](https://www.elecfans.com/yiliaodianzi/)

  [人工智能](https://www.elecfans.com/rengongzhineng/)

  [虚拟现实](https://www.elecfans.com/vr/)

  [可穿戴设备](https://www.elecfans.com/wearable/)

  [机器人](https://www.elecfans.com/jiqiren/)

  [安全设备/系统](https://www.elecfans.com/application/Security/)

  [军用/航空电子](https://www.elecfans.com/application/Military_avionics/)

  [移动通信](https://www.elecfans.com/application/Communication/)

  [工业控制](https://www.elecfans.com/kongzhijishu/)

  [便携设备](https://www.elecfans.com/consume/bianxiedianzishebei/)

  [触控感测](https://www.elecfans.com/consume/chukongjishu/)

  [物联网](https://www.elecfans.com/iot/)

  [智能电网](https://www.elecfans.com/dianyuan/diandongche_xinnenyuan/)

  [区块链](https://www.elecfans.com/blockchain/)

  [新科技](https://www.elecfans.com/xinkeji/)

- 特色内容

  [专栏推荐](https://www.elecfans.com/d/column/)

  [学院](https://t.elecfans.com/)

  [设计资源](https://bbs.elecfans.com/group_716)

  [设计技术](https://www.elecfans.com/technical/)

  [电子百科](https://www.elecfans.com/baike/)

  [电子视频](https://www.elecfans.com/dianzishipin/)

  [元器件知识](https://www.elecfans.com/yuanqijian/)

  [工具箱](https://www.elecfans.com/tools/)

  [VIP会员](https://www.elecfans.com/vip/#choose)

- 社区

  [小组](https://bbs.elecfans.com/group/)

  [论坛](https://bbs.elecfans.com/)

  [问答](https://bbs.elecfans.com/ask.html)

  [评测试用](https://bbs.elecfans.com/try.html)

- [企业服务](https://q.elecfans.com/)

  [产品](https://q.elecfans.com/p/)

  [资料](https://q.elecfans.com/soft/)

  [文章](https://q.elecfans.com/d/)

  [方案](https://q.elecfans.com/sol/)

  [企业](https://q.elecfans.com/c/)

- 供应链服务

  [硬件开发](https://www.elecfans.com/kf/)

  [华秋电路](https://www.hqpcb.com/)

  [华秋商城](https://www.hqchip.com/)

  [华秋智造](https://smt.hqchip.com/)

  [nextPCB](https://www.nextpcb.com/)

  [BOM配单](https://www.hqchip.com/bom.html)

- 媒体服务

  [网站广告](https://www.elecfans.com/help/service.html)

  [在线研讨会](https://webinar.elecfans.com/)

  [活动策划](https://event.elecfans.com/)

  [新闻发布](https://www.elecfans.com/news/)

  [新品发布](https://www.elecfans.com/xinpian/ic/)

  [小测验](https://www.elecfans.com/quiz/)

  [设计大赛](https://www.elecfans.com/contest/)

- 华秋

  [关于我们](https://www.elecfans.com/about/)

  [投资关系](https://www.hqchip.com/help/factsheet.html)

  [新闻动态](https://www.hqchip.com/help/news/lists.html)

  [加入我们](https://www.elecfans.com/about/zhaopin.html)

  [联系我们](https://www.elecfans.com/about/contact.html)

  [侵权投诉](https://bbs.elecfans.com/about/tousu.html)

- 社交网络

  [微博](https://weibo.com/elecfanscom)

- 移动端

  [发烧友APP](https://www.elecfans.com/app/)

  [硬声APP](https://yingsheng.elecfans.com/app?eleclog)

  [WAP](https://m.elecfans.com/)

- 联系我们

  广告合作

  王婉珠：[wangwanzhu@elecfans.com](mailto:wangwanzhu@elecfans.com)

  内容合作

  黄晶晶：[huangjingjing@elecfans.com](mailto:huangjingjing@elecfans.com)

  内容合作（海外）

  张迎辉：[mikezhang@elecfans.com](mailto:mikezhang@elecfans.com)

  供应链服务 PCB/IC/PCBA

  江良华：[lanhu@huaqiu.com](mailto:lanhu@huaqiu.com)

  投资合作

  曾海银：[zenghaiyin@huaqiu.com](mailto:zenghaiyin@huaqiu.com)

  社区合作

  刘勇：[liuyong@huaqiu.com](mailto:liuyong@huaqiu.com)

- 关注我们的微信

  

- 下载发烧友APP

  

- 电子发烧友观察

  

[               ![华秋电子](https://www.elecfans.com/static/footer/image/footer-01-default.png)                          ](https://www.huaqiu.com/)

​                      [                           ![华秋发烧友](https://www.elecfans.com/static/footer/image/footer-02-default.png)                                                  ](https://www.elecfans.com/)                  

​                      [                           ![华秋电路](https://www.elecfans.com/static/footer/image/footer-03-default.png)                                                  ](https://www.hqpcb.com/)                  

​                      [                           ![华秋商城](https://www.elecfans.com/static/footer/image/footer-04-default.png)                                                  ](https://www.hqchip.com/)                  

​                      [                           ![华秋智造](https://www.elecfans.com/static/footer/image/footer-05-default.png)                                                  ](https://smt.hqchip.com/)                  

​                      [                           ![NextPCB](https://www.elecfans.com/static/footer/image/footer-06-default.png)                                                  ](https://www.nextpcb.com/)                  

- [华秋简介](https://www.huaqiu.com/about/groupoverview)
- [企业动态](https://www.huaqiu.com/news)
- [联系我们](https://www.huaqiu.com/about/contactus)
- [企业文化](https://www.huaqiu.com/about/corporateculture)
- [企业宣传片](https://www.huaqiu.com/about/promotionalfilm)
- [加入我们](https://www.huaqiu.com/jobs)

版权所有 © 深圳华秋电子有限公司 

[电子发烧友](https://www.elecfans.com/)[**（电路图）**](https://www.elecfans.com/)[粤公网安备 44030402000349 号](https://www.beian.gov.cn/ode=440304portal/registerSystemInfo?recordc02000366)[电信与信息服务业务经营许可证：粤 B2-20160233](https://www.elecfans.com/about/edi.html)[           ![工商网监认证](https://skin.elecfans.com/images/ebsIcon.png)工商网监       ](http://szcert.ebs.org.cn/c6db625a-ba09-414a-bba4-f57240baac9c6)[粤ICP备 14022951 号](https://beian.miit.gov.cn/#/Integrated/index)

- ![time](https://bbs.elecfans.com/template/elecfans_201508/images/time.png)[最新主题](https://bbs.elecfans.com/default.php?view=default)
- ![recommend](https://bbs.elecfans.com/template/elecfans_201508/images/zan.png)[推荐主题](https://bbs.elecfans.com/default.php?view=recommend)
- ![hot](https://bbs.elecfans.com/template/elecfans_201508/images/re.png)[热门主题](https://bbs.elecfans.com/default.php?view=hot)
- ![post](https://bbs.elecfans.com/template/elecfans_201508/images/me.png) [我的帖子](javascript:;)

- **-**[技术社区](https://bbs.elecfans.com/forum.php?gid=1411)

  [HarmonyOS技术社区](https://bbs.elecfans.com/harmonyos)  [RISC-V MCU技术社区](https://bbs.elecfans.com/riscvmcu)

- **-**[OpenHarmony开源社区](https://bbs.elecfans.com/forum.php?gid=1510)

  [OpenHarmony开源社区](https://bbs.elecfans.com/zhuti_1511_1.html)

- **-**[嵌入式论坛](https://bbs.elecfans.com/forum.php?gid=3)

  [ARM技术论坛](https://bbs.elecfans.com/zhuti_arm_1.html)  [STM32/STM8技术论坛](https://bbs.elecfans.com/zhuti_stm32_1.html)  [RT-Thread嵌入式技术论坛](https://bbs.elecfans.com/zhuti_emb_1.html)  [单片机/MCU论坛](https://bbs.elecfans.com/zhuti_mcu_1.html)  [RISC-V技术论坛](https://bbs.elecfans.com/zhuti_risc_1.html)  [瑞芯微Rockchip开发者社区](https://bbs.elecfans.com/zhuti_1179_1.html)  [FPGA|CPLD|ASIC论坛](https://bbs.elecfans.com/zhuti_fpga_1.html)  [DSP论坛](https://bbs.elecfans.com/zhuti_DSP_1.html)

- **-**[电路图及DIY](https://bbs.elecfans.com/forum.php?gid=48)

- **-**[电源技术论坛](https://bbs.elecfans.com/forum.php?gid=752)

- **-**[综合技术与应用](https://bbs.elecfans.com/forum.php?gid=345)

- **-**[无线通信论坛](https://bbs.elecfans.com/forum.php?gid=6)

- **-**[EDA设计论坛](https://bbs.elecfans.com/forum.php?gid=1)

- **-**[测试测量论坛](https://bbs.elecfans.com/forum.php?gid=32)

- **-**[招聘/交友/外包/交易/杂谈](https://bbs.elecfans.com/forum.php?gid=27)

- **-**[官方社区](https://bbs.elecfans.com/forum.php?gid=829)

![time](https://bbs.elecfans.com/template/elecfans_201508/images/time.png) ![recommend](https://bbs.elecfans.com/template/elecfans_201508/images/zan.png) ![hot](https://bbs.elecfans.com/template/elecfans_201508/images/re.png) ![post](https://bbs.elecfans.com/template/elecfans_201508/images/me.png)

—
—
—

版
块
导
航



展开

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.24741628211008404&amp;zoneid=1029&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1108156_1_1.html" width="450" height="30" frameborder="0"></iframe>

*╳*

[![img](https://file.elecfans.com/web2/M00/7A/5B/poYBAGNx6JGAUvqIAACqaQrGZnQ426.png)](http://hqpcb.com/act/68cengban.html?fsydbtl)

[![电子技术论坛](https://bbs.elecfans.com/static/image/common/logo_new.png)](https://bbs.elecfans.com/)

- ​                            [首页](http://www.elecfans.com/)                                                    
- ​                            [论坛](https://bbs.elecfans.com/default.php)                                                                                                                                                
- ​                            [版块](https://bbs.elecfans.com/)                                                                                                                                                
- ​                            [小组](https://bbs.elecfans.com/group)                                                                                                                                                
- ​                            [活动](https://bbs.elecfans.com/zhuti_online_1.html)                                                                                                                                                
- ​                            [专栏](https://www.elecfans.com/d/)                                                                                                                                                
- ​                            [视频](https://www.elecfans.com/v/)                                                                                                                                                
- ​                            [问答](https://bbs.elecfans.com/ask/)                                                                                                                                                
- ​                            [下载](https://bbs.elecfans.com/soft/)                                                                                                                                                
- ​                            [学院](https://t.elecfans.com/)                                                                                                                                                
- ​                            [更多](javascript:;)                                                                                                                                                

|      |      |
| ---- | ---- |
|      |      |



​                                发 帖                             

- [登录/注册](javascript:;)

​                                                                                

- ![bread](https://bbs.elecfans.com/template/elecfans_201508/images/bread_img.png)[电子发烧友论坛](https://bbs.elecfans.com/forum.php)/

- ​        [EDA设计论坛](https://bbs.elecfans.com/forum.php?gid=1)/            

- ​        [KiCad EDA 中文论坛](https://bbs.elecfans.com/zhuti_kicad_1.html)                                

- /

  KiCAD教程（10），开发板EEPROM电路及FLASH电路 ...

#             KiCAD教程（10），开发板EEPROM电路及FLASH电路        

[![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708/)[spark_zhang](https://bbs.elecfans.com/user/2164708/)

*2017-1-20 15:47:51*![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png) 7622[仿真器](https://www.elecfans.com/tags/仿真器/)[单片机](https://www.elecfans.com/tags/单片机/)[eeprom](https://www.elecfans.com/tags/eeprom/)

​        

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.4468393406060738&amp;zoneid=223&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1108244_1_1.html" scrolling="no" width="728" height="90" frameborder="0"></iframe>

| *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zhichi.png)*                                                                                         0                                                                                                                             ![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/favorite.png)                        5                                                                                                                                                                                                                                                         制作一款[开发板](https://bbs.elecfans.com/try.html)，EEPROM肯定缺一不可！接下来我们 讲讲[STM32](https://bbs.elecfans.com/zhuti_stm32_1.html)的EEPROM[电路](https://bbs.elecfans.com/zhuti_dianlu_1.html)是怎么画的。EEPROM我们采用Atmel的AT24CXX芯片。这个芯片的原理图我们之前画过。因此直接打开原理图，找到之前画的AT24C02芯片，然后放置即可，如下图所示。  ![img](https://bbs.elecfans.com/data/attachment/forum/201701/20/154510qzmgfjmudww01y3g.png)        放置到原理图上后按下图所示进行接线，在这里我们还是用了双排针，通过跳线帽选择是否使用这个芯片。讲到这里，我们可以稍微补充一点EEPROM的知识，关于硬件方面的，首先我们应该知道EEPROM使用I2C协议与[单片机](https://bbs.elecfans.com/zhuti_mcu_1.html)进行[通信](https://bbs.elecfans.com/zhuti_wireless_1.html)。I2C协议用到的两根线一根为SCL时钟线，另一根为SDA数据线。因此我们将这个接口与双排针相连。双排针的另一端接到单片机的I2C接口，我们选择I2C1.另外还要注意的是对于芯片[电源](https://bbs.elecfans.com/zhuti_power_1.html)的解法，我们之前画过好几个芯片，都是在VCC端接上了一个去耦电容，至于为什么要这样接，是很有讲究的。这次大家先记住，我会在之后专门讲一下去耦电容与旁路电容的知识。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        相应的单片机接口处我们还用网络标号进行标注。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        这样电路接线部分就连完了。接下来给芯片添加封装。方法呢之前也讲过了，这里也就不赘述了，我要说明一点的是AT24C02选择之前画的SOP8的封装就可以了，电容还是选择0603.  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        添加完保存即可！这样EEPROM电路就画完了。EEPROM使用的是I2C通信协议，接下来画的FLASH芯片采用的就是SPI通信协议。这样我们开发板中就可以学会两种通信协议的使用，废话不多说。画法跟上面的一样，先将之前我们自己画的W25Q16芯片放到原理图中，这个芯片就是FLASH芯片。  与单片机的连接还是使用双排针连接，我们使用这个芯片时用跳线帽连上即可！如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        由于使用SPI通信，因此也要找到单片机上相对应的SPI引脚，并用网络标号标注。选择使用SPI1.如下图所示，分别为PA4-PA7.  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        用网络标号标注即可。最后添加封装。芯片的封装我们采用之前画的宽体SOP8,即WSOP8.  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        双排针还是需要自己画，画法也是很简单的，之前都讲过了这里不再赘述。将所有封装添加好后保存即可！ |
| ------------------------------------------------------------ |
| [只看该作者](https://bbs.elecfans.com/forum.php?mod=viewthread&tid=1108244&page=1&authorid=2164708)                                                                                                                                                                [*![分享](https://bbs.elecfans.com/static/image/common/collection.png)淘帖*](https://bbs.elecfans.com/forum.php?mod=collection&action=edit&op=addthread&tid=1108244)                                                                                                    [举报](javascript:;)                                                                                                                                                                                                                                                                                                                                                                                                   相关推荐                                                                                                                                                                                                                                                                                                                                                                [                                                     • 制作一个基于ATtiny13的迷你开发板                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         1208*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2302442_1_1.html)                                                                                                                                                                                    [                                                     • 【武汉芯源CW32F030CX STARTKIT开发板免费试用体验】 硬件电路及其功能测试                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         715*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2297466_1_1.html)                                                                                                                                                                                    [                                                     • 使用KiCAD EDA进行mini SR=TM32电路板的设计教程                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         1027*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2292486_1_1.html)                                                                                                                                                                                    [                                                     • 开发板温度模块电路是如何去设计的                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         810*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2115236_1_1.html)                                                                                                                                                                                    [                                                     • 兆易创新GD32F450ZI-mbed开发板电路原理图                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/d_load.png)                                                         0*                                                                                                                                                               ](https://www.elecfans.com/soft/v22296.html)                                                                                                                                                                                    [                                                     • 兆易创新GD32E103VB-mbed开发板电路原理图                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/d_load.png)                                                         0*                                                                                                                                                               ](https://www.elecfans.com/soft/v22294.html)                                                                                                                                                                                    [                                                     • 米尔科技开发板系统更新和执行文件方案                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         1905*                                                                                                                                                               ](https://www.elecfans.com/d/1094840.html)                                                                                                                                                                                    [                                                     • 如何选择单片机开发板                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         16562*                                                                                                                                                               ](https://www.elecfans.com/d/1107708.html)                                                                                                                                                                                    [                                                     • FPGA开发板，初学小白必备！                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         1721*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_1999503_1_1.html)                                                                                                                                                                                    [                                                     • MCU电路里面加的EEPROM和FLASH有什么用                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         7328*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_1712108_1_1.html) |
|                                                              |

### 评论

[B](javascript:;) [Color](javascript:;)   [Link](javascript:;) [Quote](javascript:;) [Code](javascript:;) [Smilies](javascript:;)     您需要登录后才可以回帖 [登录/注册](javascript:;)



声明：本文内容及配图由入驻作者撰写或者入驻合作网站授权转载。文章观点仅代表作者本人，不代表电子发烧友网立场。文章及其配图仅供工程师学习之用，如有内容图片侵权或者其他问题，请联系本站作侵删。 [侵权投诉](https://www.elecfans.com/about/tousu.html)

​    

[                             发经验                         ](https://bbs.elecfans.com/forum.php?mod=post&action=newthread&fid=1339&special=7)

[![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708)

[spark_zhang](https://bbs.elecfans.com/user/2164708) 





技术员 

积分：167经验：101

- 主题

  ##### 22

- 文章

  ##### 0

- 粉丝

  ##### 43

+关注

发私信

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.12913184626330798&amp;zoneid=242&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1108244_1_1.html" scrolling="no" width="300" height="250" frameborder="0"></iframe>

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.7122195055560698&amp;zoneid=781&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1108244_1_1.html" scrolling="no" width="300" height="125" frameborder="0"></iframe>

### 直播

[查看更多 >>](https://t.elecfans.com/live)

![img](https://file.elecfans.com/web1/M00/CE/20/o4YBAF-iaBOAfClHAADS3eM3IVY279.jpg)

【创龙分享】国产工业嵌入式处理器架构解析

2023/5/25 19:00 报名中

![img](https://file.elecfans.com/web2/M00/01/14/pYYBAGDBfdOAAsnuAADpn0dJLuQ131.png)

OpenHarmony创新赛赛事宣讲会

2023/5/31 14:30 报名中

![img](https://file.elecfans.com/web2/M00/61/AB/pYYBAGL7hJaACg3NAAAX92fOR8889.jpeg)

开源硬件系列08期：片上网络的过去、现在和将来

2023/5/31 19:30 报名中

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座02期-NXP i.MX 9352处理器的I3C接口详解

2023/5/18 19:00  回顾

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座01期-基于rpmsg的多核异构产品双核通信应用实现

2023/5/11 19:00  回顾

![img](https://file.elecfans.com/web2/M00/72/74/pYYBAGNR9yCABb_lAAANs78gSRY396.jpg)

《RK3588 PCB设计指导白皮书》线上发布&实战解读

2023/5/11 13:50  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

开源芯片系列讲座第09期：RISC-V软硬件协同设计全流程软件栈

2023/5/10 15:00  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

OpenHarmony知识赋能No.29-DAYU200分布式应用开发

2023/5/4 19:00  回顾

![img](https://file.elecfans.com/web2/M00/61/AB/pYYBAGL7hJaACg3NAAAX92fOR8889.jpeg)

开源硬件系列07期：基于生成器方法学的CGRA(可重构计算)设计

2023/4/27 19:30  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【2023】OpenHarmony开发者大会：技术论坛

2023/4/19 14:00  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【2023】OpenHarmony开发者大会：主论坛

2023/4/19 09:35  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

RISC-V 开发平台 Milk-V Pioneer 发布会

2023/4/15 15:00  回顾

![img](https://file.elecfans.com/web2/M00/3F/EF/poYBAGJqh3-AFAm_AAGpPtG2eAM315.png)

国产EDA软件新星03期-Venus智能建库工具介绍

2023/4/13 19:00  回顾

![img](https://file.elecfans.com/web2/M00/43/F3/pYYBAGKCLNCAfe1iAAEAAYXz0ZQ341.png)

【新品发布】IFX新款开发板发布与上手培训

2023/4/12 15:00  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

【开源芯片系列讲座】RISC-V计算软件栈与高性能计算进展

2023/4/7 20:00  回顾

![img](https://file.elecfans.com/web2/M00/01/14/pYYBAGDBfdOAAsnuAADpn0dJLuQ131.png)

开放原子开源基金会“源聚一堂”开源技术沙龙

2023/4/7 09:00  回顾

![img](https://file.elecfans.com/web2/M00/13/37/pYYBAGEwm8iACBfmAAEbdg3hPPo606.png)

《OpenHarmony“芯”进展》系列直播课——LoongArch专场

2023/4/4 18:55  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【OpenHarmony】2023开放原子校源行（北京站）

2023/4/2 09:24  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

OpenHarmony知识赋能No.28-OpenHarmony系统的驱动架构解析

2023/3/30 18:55  回顾

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座03期-T507-H 处理器音频接口的详细讲解

2023/5/25 19:00 报名中

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.6620736667987136&amp;zoneid=224&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1108244_1_1.html" scrolling="no" width="300" height="600" frameborder="0"></iframe>

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.5213520172132582&amp;zoneid=678&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1108244_1_1.html" scrolling="no" width="300" height="255" frameborder="0"></iframe>

​                    

广告![img](https://bbs.elecfans.com/static/image/ad/ad_close.png)[![img](https://file.elecfans.com/web2/M00/A6/17/poYBAGRlm9mAE1NyAAKVQhm_F6A861.png)](https://t.elecfans.com/live/2334.html?from=Pltdb)

[关闭](javascript:;)

##                  站长推荐                ![上一条](https://bbs.elecfans.com/static/image/common/pic_nv_prev.gif) *7/7* ![下一条](https://bbs.elecfans.com/static/image/common/pic_nv_next.gif)            

- [【免费领取】](https://url.elecfans.com/u/260fc9c6fe)        

  华秋电子将联合瑞芯微、凡亿重磅发布《RK3588 PCB设计指导白皮书》，免费下载！

[查看 »](https://url.elecfans.com/u/260fc9c6fe)

- 华秋（原“华强聚丰”）：

  电子发烧友

  华秋开发

  华秋电路(原"华强PCB")

  华秋商城(原"华强芯城")

  华秋智造



- 设计技术

  [可编程逻辑](https://www.elecfans.com/pld/)

  [电源/新能源](https://www.elecfans.com/article/83/)

  [MEMS/传感技术](https://www.elecfans.com/article/88/142/)

  [测量仪表](https://www.elecfans.com/article/85/)

  [嵌入式技术](https://www.elecfans.com/emb/)

  [制造/封装](https://www.elecfans.com/article/90/155/)

  [模拟技术](https://www.elecfans.com/analog/)

  [RF/无线](https://www.elecfans.com/tongxin/rf/)

  [接口/总线/驱动](https://www.elecfans.com/emb/jiekou/)

  [处理器/DSP](https://www.elecfans.com/emb/dsp/)

  [EDA/IC设计](https://www.elecfans.com/bandaoti/eda/)

  [存储技术](https://www.elecfans.com/consume/cunchujishu/)

  [光电显示](https://www.elecfans.com/xianshi/)

  [EMC/EMI设计](https://www.elecfans.com/emc_emi/)

  [连接器](https://www.elecfans.com/connector/)

- 行业应用

  [LEDs ](https://www.elecfans.com/led/)

  [汽车电子](https://www.elecfans.com/qichedianzi/)

  [音视频及家电](https://www.elecfans.com/video/)

  [通信网络](https://www.elecfans.com/tongxin/)

  [医疗电子](https://www.elecfans.com/yiliaodianzi/)

  [人工智能](https://www.elecfans.com/rengongzhineng/)

  [虚拟现实](https://www.elecfans.com/vr/)

  [可穿戴设备](https://www.elecfans.com/wearable/)

  [机器人](https://www.elecfans.com/jiqiren/)

  [安全设备/系统](https://www.elecfans.com/application/Security/)

  [军用/航空电子](https://www.elecfans.com/application/Military_avionics/)

  [移动通信](https://www.elecfans.com/application/Communication/)

  [工业控制](https://www.elecfans.com/kongzhijishu/)

  [便携设备](https://www.elecfans.com/consume/bianxiedianzishebei/)

  [触控感测](https://www.elecfans.com/consume/chukongjishu/)

  [物联网](https://www.elecfans.com/iot/)

  [智能电网](https://www.elecfans.com/dianyuan/diandongche_xinnenyuan/)

  [区块链](https://www.elecfans.com/blockchain/)

  [新科技](https://www.elecfans.com/xinkeji/)

- 特色内容

  [专栏推荐](https://www.elecfans.com/d/column/)

  [学院](https://t.elecfans.com/)

  [设计资源](https://bbs.elecfans.com/group_716)

  [设计技术](https://www.elecfans.com/technical/)

  [电子百科](https://www.elecfans.com/baike/)

  [电子视频](https://www.elecfans.com/dianzishipin/)

  [元器件知识](https://www.elecfans.com/yuanqijian/)

  [工具箱](https://www.elecfans.com/tools/)

  [VIP会员](https://www.elecfans.com/vip/#choose)

- 社区

  [小组](https://bbs.elecfans.com/group/)

  [论坛](https://bbs.elecfans.com/)

  [问答](https://bbs.elecfans.com/ask.html)

  [评测试用](https://bbs.elecfans.com/try.html)

- [企业服务](https://q.elecfans.com/)

  [产品](https://q.elecfans.com/p/)

  [资料](https://q.elecfans.com/soft/)

  [文章](https://q.elecfans.com/d/)

  [方案](https://q.elecfans.com/sol/)

  [企业](https://q.elecfans.com/c/)

- 供应链服务

  [硬件开发](https://www.elecfans.com/kf/)

  [华秋电路](https://www.hqpcb.com/)

  [华秋商城](https://www.hqchip.com/)

  [华秋智造](https://smt.hqchip.com/)

  [nextPCB](https://www.nextpcb.com/)

  [BOM配单](https://www.hqchip.com/bom.html)

- 媒体服务

  [网站广告](https://www.elecfans.com/help/service.html)

  [在线研讨会](https://webinar.elecfans.com/)

  [活动策划](https://event.elecfans.com/)

  [新闻发布](https://www.elecfans.com/news/)

  [新品发布](https://www.elecfans.com/xinpian/ic/)

  [小测验](https://www.elecfans.com/quiz/)

  [设计大赛](https://www.elecfans.com/contest/)

- 华秋

  [关于我们](https://www.elecfans.com/about/)

  [投资关系](https://www.hqchip.com/help/factsheet.html)

  [新闻动态](https://www.hqchip.com/help/news/lists.html)

  [加入我们](https://www.elecfans.com/about/zhaopin.html)

  [联系我们](https://www.elecfans.com/about/contact.html)

  [侵权投诉](https://bbs.elecfans.com/about/tousu.html)

- 社交网络

  [微博](https://weibo.com/elecfanscom)

- 移动端

  [发烧友APP](https://www.elecfans.com/app/)

  [硬声APP](https://yingsheng.elecfans.com/app?eleclog)

  [WAP](https://m.elecfans.com/)

- 联系我们

  广告合作

  王婉珠：[wangwanzhu@elecfans.com](mailto:wangwanzhu@elecfans.com)

  内容合作

  黄晶晶：[huangjingjing@elecfans.com](mailto:huangjingjing@elecfans.com)

  内容合作（海外）

  张迎辉：[mikezhang@elecfans.com](mailto:mikezhang@elecfans.com)

  供应链服务 PCB/IC/PCBA

  江良华：[lanhu@huaqiu.com](mailto:lanhu@huaqiu.com)

  投资合作

  曾海银：[zenghaiyin@huaqiu.com](mailto:zenghaiyin@huaqiu.com)

  社区合作

  刘勇：[liuyong@huaqiu.com](mailto:liuyong@huaqiu.com)

- 关注我们的微信

  

- 下载发烧友APP

  

- 电子发烧友观察

  

[               ![华秋电子](https://www.elecfans.com/static/footer/image/footer-01-default.png)                          ](https://www.huaqiu.com/)

​                      [                           ![华秋发烧友](https://www.elecfans.com/static/footer/image/footer-02-default.png)                                                  ](https://www.elecfans.com/)                  

​                      [                           ![华秋电路](https://www.elecfans.com/static/footer/image/footer-03-default.png)                                                  ](https://www.hqpcb.com/)                  

​                      [                           ![华秋商城](https://www.elecfans.com/static/footer/image/footer-04-default.png)                                                  ](https://www.hqchip.com/)                  

​                      [                           ![华秋智造](https://www.elecfans.com/static/footer/image/footer-05-default.png)                                                  ](https://smt.hqchip.com/)                  

​                      [                           ![NextPCB](https://www.elecfans.com/static/footer/image/footer-06-default.png)                                                  ](https://www.nextpcb.com/)                  

- [华秋简介](https://www.huaqiu.com/about/groupoverview)
- [企业动态](https://www.huaqiu.com/news)
- [联系我们](https://www.huaqiu.com/about/contactus)
- [企业文化](https://www.huaqiu.com/about/corporateculture)
- [企业宣传片](https://www.huaqiu.com/about/promotionalfilm)
- [加入我们](https://www.huaqiu.com/jobs)

版权所有 © 深圳华秋电子有限公司 

[电子发烧友](https://www.elecfans.com/)[**（电路图）**](https://www.elecfans.com/)[粤公网安备 44030402000349 号](https://www.beian.gov.cn/ode=440304portal/registerSystemInfo?recordc02000366)[电信与信息服务业务经营许可证：粤 B2-20160233](https://www.elecfans.com/about/edi.html)[           ![工商网监认证](https://skin.elecfans.com/images/ebsIcon.png)工商网监       ](http://szcert.ebs.org.cn/c6db625a-ba09-414a-bba4-f57240baac9c6)[粤ICP备 14022951 号](https://beian.miit.gov.cn/#/Integrated/index)

- ![time](https://bbs.elecfans.com/template/elecfans_201508/images/time.png)[最新主题](https://bbs.elecfans.com/default.php?view=default)
- ![recommend](https://bbs.elecfans.com/template/elecfans_201508/images/zan.png)[推荐主题](https://bbs.elecfans.com/default.php?view=recommend)
- ![hot](https://bbs.elecfans.com/template/elecfans_201508/images/re.png)[热门主题](https://bbs.elecfans.com/default.php?view=hot)
- ![post](https://bbs.elecfans.com/template/elecfans_201508/images/me.png) [我的帖子](javascript:;)

- **-**[技术社区](https://bbs.elecfans.com/forum.php?gid=1411)

  [HarmonyOS技术社区](https://bbs.elecfans.com/harmonyos)  [RISC-V MCU技术社区](https://bbs.elecfans.com/riscvmcu)

- **-**[OpenHarmony开源社区](https://bbs.elecfans.com/forum.php?gid=1510)

  [OpenHarmony开源社区](https://bbs.elecfans.com/zhuti_1511_1.html)

- **-**[嵌入式论坛](https://bbs.elecfans.com/forum.php?gid=3)

  [ARM技术论坛](https://bbs.elecfans.com/zhuti_arm_1.html)  [STM32/STM8技术论坛](https://bbs.elecfans.com/zhuti_stm32_1.html)  [RT-Thread嵌入式技术论坛](https://bbs.elecfans.com/zhuti_emb_1.html)  [单片机/MCU论坛](https://bbs.elecfans.com/zhuti_mcu_1.html)  [RISC-V技术论坛](https://bbs.elecfans.com/zhuti_risc_1.html)  [瑞芯微Rockchip开发者社区](https://bbs.elecfans.com/zhuti_1179_1.html)  [FPGA|CPLD|ASIC论坛](https://bbs.elecfans.com/zhuti_fpga_1.html)  [DSP论坛](https://bbs.elecfans.com/zhuti_DSP_1.html)

- **-**[电路图及DIY](https://bbs.elecfans.com/forum.php?gid=48)

- **-**[电源技术论坛](https://bbs.elecfans.com/forum.php?gid=752)

- **-**[综合技术与应用](https://bbs.elecfans.com/forum.php?gid=345)

- **-**[无线通信论坛](https://bbs.elecfans.com/forum.php?gid=6)

- **-**[EDA设计论坛](https://bbs.elecfans.com/forum.php?gid=1)

- **-**[测试测量论坛](https://bbs.elecfans.com/forum.php?gid=32)

- **-**[招聘/交友/外包/交易/杂谈](https://bbs.elecfans.com/forum.php?gid=27)

- **-**[官方社区](https://bbs.elecfans.com/forum.php?gid=829)

![time](https://bbs.elecfans.com/template/elecfans_201508/images/time.png) ![recommend](https://bbs.elecfans.com/template/elecfans_201508/images/zan.png) ![hot](https://bbs.elecfans.com/template/elecfans_201508/images/re.png) ![post](https://bbs.elecfans.com/template/elecfans_201508/images/me.png)

—
—
—

版
块
导
航



展开

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.8618280255906504&amp;zoneid=1029&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1108244_1_1.html" width="450" height="30" frameborder="0"></iframe>

*╳*

[![img](https://file.elecfans.com/web2/M00/7A/5B/poYBAGNx6JGAUvqIAACqaQrGZnQ426.png)](http://hqpcb.com/act/68cengban.html?fsydbtl)

[![电子技术论坛](https://bbs.elecfans.com/static/image/common/logo_new.png)](https://bbs.elecfans.com/)

- ​                            [首页](http://www.elecfans.com/)                                                    
- ​                            [论坛](https://bbs.elecfans.com/default.php)                                                                                                                                                
- ​                            [版块](https://bbs.elecfans.com/)                                                                                                                                                
- ​                            [小组](https://bbs.elecfans.com/group)                                                                                                                                                
- ​                            [活动](https://bbs.elecfans.com/zhuti_online_1.html)                                                                                                                                                
- ​                            [专栏](https://www.elecfans.com/d/)                                                                                                                                                
- ​                            [视频](https://www.elecfans.com/v/)                                                                                                                                                
- ​                            [问答](https://bbs.elecfans.com/ask/)                                                                                                                                                
- ​                            [下载](https://bbs.elecfans.com/soft/)                                                                                                                                                
- ​                            [学院](https://t.elecfans.com/)                                                                                                                                                
- ​                            [更多](javascript:;)                                                                                                                                                

|      |      |
| ---- | ---- |
|      |      |



​                                发 帖                             

- [登录/注册](javascript:;)

​                                                                                

- ![bread](https://bbs.elecfans.com/template/elecfans_201508/images/bread_img.png)[电子发烧友论坛](https://bbs.elecfans.com/forum.php)/

- ​        [EDA设计论坛](https://bbs.elecfans.com/forum.php?gid=1)/            

- ​        [KiCad EDA 中文论坛](https://bbs.elecfans.com/zhuti_kicad_1.html)                                

- /

  KiCAD教程（11），单片机485,232，CAN通信电路 ...

#             KiCAD教程（11），单片机485,232，CAN通信电路        

[![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708/)[spark_zhang](https://bbs.elecfans.com/user/2164708/)

*2017-1-21 10:13:19*![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png) 7527

​        

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.49656192518564113&amp;zoneid=223&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1108296_1_1.html" scrolling="no" width="728" height="90" frameborder="0"></iframe>

| *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zhichi.png)*                                                                                         0                                                                                                                             ![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/favorite.png)                        3                                                                                                                                                                                                                                                          *本帖最后由 spark_zhang 于 2017-1-21 10:15 编辑*     首先是485[通信](https://bbs.elecfans.com/zhuti_wireless_1.html)[电路](https://bbs.elecfans.com/zhuti_dianlu_1.html)。在原理图中将SP3485芯片放好后，可以看到饮片有八个引脚。其中第1引脚和4引脚分别是接收和发送引脚，2、3引脚是控制485发送和接收的引脚。如果2、3引脚都为低电平，则为接收状态，[单片机](https://bbs.elecfans.com/zhuti_mcu_1.html)可以接收外部数据。如果都为高电平则为发送状态即单片机可以发送数据。因此在接线时将2、 3引脚接到一起。同样通过双排针与单片机连接。因此大家如下图连接即可。   ![img](https://bbs.elecfans.com/data/attachment/forum/201701/21/100654vyx8t7pt6jthp8py.png)          我们在之前已经用过了串口1，因此这次使用串口2。用网络标号标注即可。芯片的6、 7引脚就是向外输出的引脚，通过比较A、B的高低确定输出高电平还是低电平。因此为了使输出稳定，我们要添加上拉和下拉电阻。接口我们采用WJ301.如下图所示。   ![img](https://bbs.elecfans.com/static/image/common/none.gif)          在画的时候还使用1*2的排针。最后在对应的单片机的串口2引脚处用网络标号标好。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        最后添加封装。SP3485使用sop8封装，WJ301需要再画一个。打开datasheet。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        按照上面的尺寸，在[元件](https://bbs.elecfans.com/zhuti_yuanjian_1.html)封装里画出即可，这里引脚间距5mm。钻孔1.3mm焊盘2.5mm即可。最后保存添加。    下面是232串口电路，接口分别如下图所示分为两种一种公头，一种母头。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)        第一个为公头第二个为母头我们[开发板](https://bbs.elecfans.com/try.html)上用的是母头。接下来开始画电路。还是讲SP3232芯片放好，打开数据手册。我们按下图画即可。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        画完后如下图所示。对于不好接线的地方，可以用网络标号标注。9针穿扩2和3引脚分别接到232芯片的7、 8引脚。这次使用的是单片机的串口3.因此还用双排针连接。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        找到单片机的串口3引脚，用网络标号标注。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        接下来就是添加封装了。这次重点讲的是9针串口的封装。这个封装软件自带库里有，但是需要修改后才能使用。因此打开[PCB](https://bbs.elecfans.com/zhuti_pads_1.html)封装库，加载DB9MC封装，  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        其3D效果如下图  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        但是我们板子上需要将头往外伸出去。因此需要把这个封装的外形改一下，加载的方法之前也讲过！改成如下图所示即可。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        具体尺寸左右两边的长度改成12.8mm。最后得到的3D效果如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        这样就达到了我们所需要的目的。保存到自己建的库即可。最后添加封装。其他添加封装方法之前已讲过，不再赘述。     [STM32](https://bbs.elecfans.com/zhuti_stm32_1.html)单片机有三个CAN通信接口，其中一个是引脚复用，另外两个是重映射。 PA11，PA12引脚为复用引脚，但是之前我们画USB接口时已经被占用了，因此只能使用重映射接口了。我们选择PB8和PB9引脚。确定好单片机引脚后就可以开始画电路了。    打开原理图，找到SN65HVD230芯片。按下图所示将电路连接好。   ![img](https://bbs.elecfans.com/static/image/common/none.gif)        芯片的[电源](https://bbs.elecfans.com/zhuti_power_1.html)部分还是要接上去耦电容。关于去耦电容我之前专门发过一个推送，不懂的可以再看看。  芯片的1，4引脚还是通过双排针与单片机相连。但是你也可能会问，为什么这里画的是单排针呢？这里就有一个小技巧了。还记得我们用的是单片机的哪个引脚吗？PB8、 PB9.。再看看我们引脚引出接口的双排针。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        看到没，可以利用双排针的1,2引脚直接与CAN芯片的单排针相连，这也算个小技巧吧。    之后是添加封装。芯片选择SOP8，电容电阻选择0603，左边的双排针我们需要自己画一个。画法也很简单，跟前面的一样。右边的接口时CAN的引出线，这个要接我们之前画过的WJ301封装。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        最后记得，还要在单片机上放好CAN的网络标号。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        至此，CAN通信的电路已经画完了！ |
| ------------------------------------------------------------ |
| [只看该作者](https://bbs.elecfans.com/forum.php?mod=viewthread&tid=1108296&page=1&authorid=2164708)                                                                                                                                                                [*![分享](https://bbs.elecfans.com/static/image/common/collection.png)淘帖*](https://bbs.elecfans.com/forum.php?mod=collection&action=edit&op=addthread&tid=1108296)                                                                                                    [举报](javascript:;)                                                                                                                                                                                                                                                                                           相关推荐                                                                                                                                                                                                                                                                                                                                                                [                                                     • 基于RT1052单片机485通信问题                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         623*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2237727_1_1.html)                                                                                                                                                                                    [                                                     • STM32单片机与RS485是怎样通信的                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         2426*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2142498_1_1.html)                                                                                                                                                                                    [                                                     • 请问单片机串口同时接232和485会有冲突吗？                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         3503*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_1853082_1_1.html)                                                                                                                                                                                    [                                                     • PIC单片机用max485和电脑通信问题                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         3503*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_1100882_1_1.html)                                                                                                                                                                                    [                                                     • 单片机串口通信485modbus                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/d_load.png)                                                         114*                                                                                                                                                               ](https://www.elecfans.com/soft/33/2016/20160701426209.html)                                                                                                                                                                                    [                                                     • PC 机与单片机通信(RS232 协议)                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/d_load.png)                                                         63*                                                                                                                                                               ](https://www.elecfans.com/soft/161/2016/20160424415658.html)                                                                                                                                                                                    [                                                     • 如何实现PC机与51系列单片机的通信                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         5430*                                                                                                                                                               ](https://www.elecfans.com/emb/danpianji/20190420915520.html)                                                                                                                                                                                    [                                                     • 基于嵌入式WinCE设备与LPC935单片机CAN通信设计                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         743*                                                                                                                                                               ](https://www.elecfans.com/emb/danpianji/20180228640680.html)                                                                                                                                                                                    [                                                     • pic单片机485通信问题                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         3744*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_1099170_1_1.html)                                                                                                                                                                                    [                                                     • 关于单片机串口TTL转232                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         9540*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_506158_1_1.html) |
|                                                              |

### 评论

[B](javascript:;) [Color](javascript:;)   [Link](javascript:;) [Quote](javascript:;) [Code](javascript:;) [Smilies](javascript:;)     您需要登录后才可以回帖 [登录/注册](javascript:;)



声明：本文内容及配图由入驻作者撰写或者入驻合作网站授权转载。文章观点仅代表作者本人，不代表电子发烧友网立场。文章及其配图仅供工程师学习之用，如有内容图片侵权或者其他问题，请联系本站作侵删。 [侵权投诉](https://www.elecfans.com/about/tousu.html)

​    

[                             发经验                         ](https://bbs.elecfans.com/forum.php?mod=post&action=newthread&fid=1339&special=7)

[![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708)

[spark_zhang](https://bbs.elecfans.com/user/2164708) 





技术员 

积分：167经验：101

- 主题

  ##### 22

- 文章

  ##### 0

- 粉丝

  ##### 43

+关注

发私信

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.06307634636358705&amp;zoneid=242&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1108296_1_1.html" scrolling="no" width="300" height="250" frameborder="0"></iframe>

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.39911668121269883&amp;zoneid=781&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1108296_1_1.html" scrolling="no" width="300" height="125" frameborder="0"></iframe>

### 直播

[查看更多 >>](https://t.elecfans.com/live)

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座02期-NXP i.MX 9352处理器的I3C接口详解

2023/5/18 19:00  回顾

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座01期-基于rpmsg的多核异构产品双核通信应用实现

2023/5/11 19:00  回顾

![img](https://file.elecfans.com/web2/M00/72/74/pYYBAGNR9yCABb_lAAANs78gSRY396.jpg)

《RK3588 PCB设计指导白皮书》线上发布&实战解读

2023/5/11 13:50  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

开源芯片系列讲座第09期：RISC-V软硬件协同设计全流程软件栈

2023/5/10 15:00  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

OpenHarmony知识赋能No.29-DAYU200分布式应用开发

2023/5/4 19:00  回顾

![img](https://file.elecfans.com/web2/M00/61/AB/pYYBAGL7hJaACg3NAAAX92fOR8889.jpeg)

开源硬件系列07期：基于生成器方法学的CGRA(可重构计算)设计

2023/4/27 19:30  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【2023】OpenHarmony开发者大会：技术论坛

2023/4/19 14:00  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【2023】OpenHarmony开发者大会：主论坛

2023/4/19 09:35  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

RISC-V 开发平台 Milk-V Pioneer 发布会

2023/4/15 15:00  回顾

![img](https://file.elecfans.com/web2/M00/3F/EF/poYBAGJqh3-AFAm_AAGpPtG2eAM315.png)

国产EDA软件新星03期-Venus智能建库工具介绍

2023/4/13 19:00  回顾

![img](https://file.elecfans.com/web2/M00/43/F3/pYYBAGKCLNCAfe1iAAEAAYXz0ZQ341.png)

【新品发布】IFX新款开发板发布与上手培训

2023/4/12 15:00  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

【开源芯片系列讲座】RISC-V计算软件栈与高性能计算进展

2023/4/7 20:00  回顾

![img](https://file.elecfans.com/web2/M00/01/14/pYYBAGDBfdOAAsnuAADpn0dJLuQ131.png)

开放原子开源基金会“源聚一堂”开源技术沙龙

2023/4/7 09:00  回顾

![img](https://file.elecfans.com/web2/M00/13/37/pYYBAGEwm8iACBfmAAEbdg3hPPo606.png)

《OpenHarmony“芯”进展》系列直播课——LoongArch专场

2023/4/4 18:55  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【OpenHarmony】2023开放原子校源行（北京站）

2023/4/2 09:24  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

OpenHarmony知识赋能No.28-OpenHarmony系统的驱动架构解析

2023/3/30 18:55  回顾

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座03期-T507-H 处理器音频接口的详细讲解

2023/5/25 19:00 报名中

![img](https://file.elecfans.com/web1/M00/CE/20/o4YBAF-iaBOAfClHAADS3eM3IVY279.jpg)

【创龙分享】国产工业嵌入式处理器架构解析

2023/5/25 19:00 报名中

![img](https://file.elecfans.com/web2/M00/01/14/pYYBAGDBfdOAAsnuAADpn0dJLuQ131.png)

OpenHarmony创新赛赛事宣讲会

2023/5/31 14:30 报名中

![img](https://file.elecfans.com/web2/M00/61/AB/pYYBAGL7hJaACg3NAAAX92fOR8889.jpeg)

开源硬件系列08期：片上网络的过去、现在和将来

2023/5/31 19:30 报名中

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.7157368694199722&amp;zoneid=224&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1108296_1_1.html" scrolling="no" width="300" height="600" frameborder="0"></iframe>

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.7115859758182737&amp;zoneid=678&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1108296_1_1.html" scrolling="no" width="300" height="255" frameborder="0"></iframe>

​                    

广告![img](https://bbs.elecfans.com/static/image/ad/ad_close.png)[![img](https://file.elecfans.com/web2/M00/A6/17/poYBAGRlm9mAE1NyAAKVQhm_F6A861.png)](https://t.elecfans.com/live/2334.html?from=Pltdb)

[关闭](javascript:;)

##                  站长推荐                ![上一条](https://bbs.elecfans.com/static/image/common/pic_nv_prev.gif) *7/7* ![下一条](https://bbs.elecfans.com/static/image/common/pic_nv_next.gif)            

- [【免费领取】](https://url.elecfans.com/u/260fc9c6fe)        

  华秋电子将联合瑞芯微、凡亿重磅发布《RK3588 PCB设计指导白皮书》，免费下载！

[查看 »](https://url.elecfans.com/u/260fc9c6fe)

- 华秋（原“华强聚丰”）：

  电子发烧友

  华秋开发

  华秋电路(原"华强PCB")

  华秋商城(原"华强芯城")

  华秋智造



- 设计技术

  [可编程逻辑](https://www.elecfans.com/pld/)

  [电源/新能源](https://www.elecfans.com/article/83/)

  [MEMS/传感技术](https://www.elecfans.com/article/88/142/)

  [测量仪表](https://www.elecfans.com/article/85/)

  [嵌入式技术](https://www.elecfans.com/emb/)

  [制造/封装](https://www.elecfans.com/article/90/155/)

  [模拟技术](https://www.elecfans.com/analog/)

  [RF/无线](https://www.elecfans.com/tongxin/rf/)

  [接口/总线/驱动](https://www.elecfans.com/emb/jiekou/)

  [处理器/DSP](https://www.elecfans.com/emb/dsp/)

  [EDA/IC设计](https://www.elecfans.com/bandaoti/eda/)

  [存储技术](https://www.elecfans.com/consume/cunchujishu/)

  [光电显示](https://www.elecfans.com/xianshi/)

  [EMC/EMI设计](https://www.elecfans.com/emc_emi/)

  [连接器](https://www.elecfans.com/connector/)

- 行业应用

  [LEDs ](https://www.elecfans.com/led/)

  [汽车电子](https://www.elecfans.com/qichedianzi/)

  [音视频及家电](https://www.elecfans.com/video/)

  [通信网络](https://www.elecfans.com/tongxin/)

  [医疗电子](https://www.elecfans.com/yiliaodianzi/)

  [人工智能](https://www.elecfans.com/rengongzhineng/)

  [虚拟现实](https://www.elecfans.com/vr/)

  [可穿戴设备](https://www.elecfans.com/wearable/)

  [机器人](https://www.elecfans.com/jiqiren/)

  [安全设备/系统](https://www.elecfans.com/application/Security/)

  [军用/航空电子](https://www.elecfans.com/application/Military_avionics/)

  [移动通信](https://www.elecfans.com/application/Communication/)

  [工业控制](https://www.elecfans.com/kongzhijishu/)

  [便携设备](https://www.elecfans.com/consume/bianxiedianzishebei/)

  [触控感测](https://www.elecfans.com/consume/chukongjishu/)

  [物联网](https://www.elecfans.com/iot/)

  [智能电网](https://www.elecfans.com/dianyuan/diandongche_xinnenyuan/)

  [区块链](https://www.elecfans.com/blockchain/)

  [新科技](https://www.elecfans.com/xinkeji/)

- 特色内容

  [专栏推荐](https://www.elecfans.com/d/column/)

  [学院](https://t.elecfans.com/)

  [设计资源](https://bbs.elecfans.com/group_716)

  [设计技术](https://www.elecfans.com/technical/)

  [电子百科](https://www.elecfans.com/baike/)

  [电子视频](https://www.elecfans.com/dianzishipin/)

  [元器件知识](https://www.elecfans.com/yuanqijian/)

  [工具箱](https://www.elecfans.com/tools/)

  [VIP会员](https://www.elecfans.com/vip/#choose)

- 社区

  [小组](https://bbs.elecfans.com/group/)

  [论坛](https://bbs.elecfans.com/)

  [问答](https://bbs.elecfans.com/ask.html)

  [评测试用](https://bbs.elecfans.com/try.html)

- [企业服务](https://q.elecfans.com/)

  [产品](https://q.elecfans.com/p/)

  [资料](https://q.elecfans.com/soft/)

  [文章](https://q.elecfans.com/d/)

  [方案](https://q.elecfans.com/sol/)

  [企业](https://q.elecfans.com/c/)

- 供应链服务

  [硬件开发](https://www.elecfans.com/kf/)

  [华秋电路](https://www.hqpcb.com/)

  [华秋商城](https://www.hqchip.com/)

  [华秋智造](https://smt.hqchip.com/)

  [nextPCB](https://www.nextpcb.com/)

  [BOM配单](https://www.hqchip.com/bom.html)

- 媒体服务

  [网站广告](https://www.elecfans.com/help/service.html)

  [在线研讨会](https://webinar.elecfans.com/)

  [活动策划](https://event.elecfans.com/)

  [新闻发布](https://www.elecfans.com/news/)

  [新品发布](https://www.elecfans.com/xinpian/ic/)

  [小测验](https://www.elecfans.com/quiz/)

  [设计大赛](https://www.elecfans.com/contest/)

- 华秋

  [关于我们](https://www.elecfans.com/about/)

  [投资关系](https://www.hqchip.com/help/factsheet.html)

  [新闻动态](https://www.hqchip.com/help/news/lists.html)

  [加入我们](https://www.elecfans.com/about/zhaopin.html)

  [联系我们](https://www.elecfans.com/about/contact.html)

  [侵权投诉](https://bbs.elecfans.com/about/tousu.html)

- 社交网络

  [微博](https://weibo.com/elecfanscom)

- 移动端

  [发烧友APP](https://www.elecfans.com/app/)

  [硬声APP](https://yingsheng.elecfans.com/app?eleclog)

  [WAP](https://m.elecfans.com/)

- 联系我们

  广告合作

  王婉珠：[wangwanzhu@elecfans.com](mailto:wangwanzhu@elecfans.com)

  内容合作

  黄晶晶：[huangjingjing@elecfans.com](mailto:huangjingjing@elecfans.com)

  内容合作（海外）

  张迎辉：[mikezhang@elecfans.com](mailto:mikezhang@elecfans.com)

  供应链服务 PCB/IC/PCBA

  江良华：[lanhu@huaqiu.com](mailto:lanhu@huaqiu.com)

  投资合作

  曾海银：[zenghaiyin@huaqiu.com](mailto:zenghaiyin@huaqiu.com)

  社区合作

  刘勇：[liuyong@huaqiu.com](mailto:liuyong@huaqiu.com)

- 关注我们的微信

  

- 下载发烧友APP

  

- 电子发烧友观察

  

[               ![华秋电子](https://www.elecfans.com/static/footer/image/footer-01-default.png)                          ](https://www.huaqiu.com/)

​                      [                           ![华秋发烧友](https://www.elecfans.com/static/footer/image/footer-02-default.png)                                                  ](https://www.elecfans.com/)                  

​                      [                           ![华秋电路](https://www.elecfans.com/static/footer/image/footer-03-default.png)                                                  ](https://www.hqpcb.com/)                  

​                      [                           ![华秋商城](https://www.elecfans.com/static/footer/image/footer-04-default.png)                                                  ](https://www.hqchip.com/)                  

​                      [                           ![华秋智造](https://www.elecfans.com/static/footer/image/footer-05-default.png)                                                  ](https://smt.hqchip.com/)                  

​                      [                           ![NextPCB](https://www.elecfans.com/static/footer/image/footer-06-default.png)                                                  ](https://www.nextpcb.com/)                  

- [华秋简介](https://www.huaqiu.com/about/groupoverview)
- [企业动态](https://www.huaqiu.com/news)
- [联系我们](https://www.huaqiu.com/about/contactus)
- [企业文化](https://www.huaqiu.com/about/corporateculture)
- [企业宣传片](https://www.huaqiu.com/about/promotionalfilm)
- [加入我们](https://www.huaqiu.com/jobs)

版权所有 © 深圳华秋电子有限公司 

[电子发烧友](https://www.elecfans.com/)[**（电路图）**](https://www.elecfans.com/)[粤公网安备 44030402000349 号](https://www.beian.gov.cn/ode=440304portal/registerSystemInfo?recordc02000366)[电信与信息服务业务经营许可证：粤 B2-20160233](https://www.elecfans.com/about/edi.html)[           ![工商网监认证](https://skin.elecfans.com/images/ebsIcon.png)工商网监       ](http://szcert.ebs.org.cn/c6db625a-ba09-414a-bba4-f57240baac9c6)[粤ICP备 14022951 号](https://beian.miit.gov.cn/#/Integrated/index)

- ![time](https://bbs.elecfans.com/template/elecfans_201508/images/time.png)[最新主题](https://bbs.elecfans.com/default.php?view=default)
- ![recommend](https://bbs.elecfans.com/template/elecfans_201508/images/zan.png)[推荐主题](https://bbs.elecfans.com/default.php?view=recommend)
- ![hot](https://bbs.elecfans.com/template/elecfans_201508/images/re.png)[热门主题](https://bbs.elecfans.com/default.php?view=hot)
- ![post](https://bbs.elecfans.com/template/elecfans_201508/images/me.png) [我的帖子](javascript:;)

- **-**[技术社区](https://bbs.elecfans.com/forum.php?gid=1411)

  [HarmonyOS技术社区](https://bbs.elecfans.com/harmonyos)  [RISC-V MCU技术社区](https://bbs.elecfans.com/riscvmcu)

- **-**[OpenHarmony开源社区](https://bbs.elecfans.com/forum.php?gid=1510)

  [OpenHarmony开源社区](https://bbs.elecfans.com/zhuti_1511_1.html)

- **-**[嵌入式论坛](https://bbs.elecfans.com/forum.php?gid=3)

  [ARM技术论坛](https://bbs.elecfans.com/zhuti_arm_1.html)  [STM32/STM8技术论坛](https://bbs.elecfans.com/zhuti_stm32_1.html)  [RT-Thread嵌入式技术论坛](https://bbs.elecfans.com/zhuti_emb_1.html)  [单片机/MCU论坛](https://bbs.elecfans.com/zhuti_mcu_1.html)  [RISC-V技术论坛](https://bbs.elecfans.com/zhuti_risc_1.html)  [瑞芯微Rockchip开发者社区](https://bbs.elecfans.com/zhuti_1179_1.html)  [FPGA|CPLD|ASIC论坛](https://bbs.elecfans.com/zhuti_fpga_1.html)  [DSP论坛](https://bbs.elecfans.com/zhuti_DSP_1.html)

- **-**[电路图及DIY](https://bbs.elecfans.com/forum.php?gid=48)

- **-**[电源技术论坛](https://bbs.elecfans.com/forum.php?gid=752)

- **-**[综合技术与应用](https://bbs.elecfans.com/forum.php?gid=345)

- **-**[无线通信论坛](https://bbs.elecfans.com/forum.php?gid=6)

- **-**[EDA设计论坛](https://bbs.elecfans.com/forum.php?gid=1)

- **-**[测试测量论坛](https://bbs.elecfans.com/forum.php?gid=32)

- **-**[招聘/交友/外包/交易/杂谈](https://bbs.elecfans.com/forum.php?gid=27)

- **-**[官方社区](https://bbs.elecfans.com/forum.php?gid=829)

![time](https://bbs.elecfans.com/template/elecfans_201508/images/time.png) ![recommend](https://bbs.elecfans.com/template/elecfans_201508/images/zan.png) ![hot](https://bbs.elecfans.com/template/elecfans_201508/images/re.png) ![post](https://bbs.elecfans.com/template/elecfans_201508/images/me.png)

—
—
—

版
块
导
航



展开

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.7025203770799878&amp;zoneid=1029&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1108296_1_1.html" width="450" height="30" frameborder="0"></iframe>

*╳*

[![img](https://file.elecfans.com/web2/M00/7A/5B/poYBAGNx6JGAUvqIAACqaQrGZnQ426.png)](http://hqpcb.com/act/68cengban.html?fsydbtl)

[![电子技术论坛](https://bbs.elecfans.com/static/image/common/logo_new.png)](https://bbs.elecfans.com/)

- ​                            [首页](http://www.elecfans.com/)                                                    
- ​                            [论坛](https://bbs.elecfans.com/default.php)                                                                                                                                                
- ​                            [版块](https://bbs.elecfans.com/)                                                                                                                                                
- ​                            [小组](https://bbs.elecfans.com/group)                                                                                                                                                
- ​                            [活动](https://bbs.elecfans.com/zhuti_online_1.html)                                                                                                                                                
- ​                            [专栏](https://www.elecfans.com/d/)                                                                                                                                                
- ​                            [视频](https://www.elecfans.com/v/)                                                                                                                                                
- ​                            [问答](https://bbs.elecfans.com/ask/)                                                                                                                                                
- ​                            [下载](https://bbs.elecfans.com/soft/)                                                                                                                                                
- ​                            [学院](https://t.elecfans.com/)                                                                                                                                                
- ​                            [更多](javascript:;)                                                                                                                                                

|      |      |
| ---- | ---- |
|      |      |



​                                发 帖                             

- [登录/注册](javascript:;)

​                                                                                

- ![bread](https://bbs.elecfans.com/template/elecfans_201508/images/bread_img.png)[电子发烧友论坛](https://bbs.elecfans.com/forum.php)/

- ​        [EDA设计论坛](https://bbs.elecfans.com/forum.php?gid=1)/            

- ​        [KiCad EDA 中文论坛](https://bbs.elecfans.com/zhuti_kicad_1.html)                                

- /

  KiCAD教程（12），单片机SD卡接口电路、USB通信接口与摄 ...

#             KiCAD教程（12），单片机SD卡接口电路、USB通信接口与摄像头接口、TFT液晶屏电路        

[![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708/)[spark_zhang](https://bbs.elecfans.com/user/2164708/)

*2017-2-6 16:47:08*![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png) 9037[液晶屏](https://www.elecfans.com/tags/液晶屏/)[单片机](https://www.elecfans.com/tags/单片机/)[摄像头](https://www.elecfans.com/tags/摄像头/)[TFT](https://www.elecfans.com/tags/TFT/)[KiCAD](https://www.elecfans.com/tags/KiCAD/)

​        

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.8277540071725213&amp;zoneid=223&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109273_1_1.html" scrolling="no" width="728" height="90" frameborder="0"></iframe>

| *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zhichi.png)*                                                                                         0                                                                                                                             ![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/favorite.png)                        4                                                                                                                                                                                                                                                         `[单片机](https://bbs.elecfans.com/zhuti_mcu_1.html)[开发板](https://bbs.elecfans.com/try.html)上用的是大的SD卡座。就是长这样，如下图所示。打开datasheet。  ![img](https://bbs.elecfans.com/data/attachment/forum/201702/06/164331bvrvobhw2djd2bjs.jpg)        上图中我们按第一个图画原理图，第二个图画封装。    打开自己建立的[元件](https://bbs.elecfans.com/zhuti_yuanjian_1.html)库。按下图画即可。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        画完以后保存，再打开我们的原理图，将刚画的的SD卡放置。    接下来就是连接引脚了。由于SD卡是插拔是，当我们不用时，会把SD卡拔出，此时也不会占用单片机引脚。因此就不用像之前那样用双排针了。单片机关于SD卡的引脚如下图所示。我们要做的工作就是用网络标号标出即可。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)        相应的我们在SD卡上也要标出。顺便将[电源](https://bbs.elecfans.com/zhuti_power_1.html)、地也画好。如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        另外。除了CK之外，其他5个引脚都要连上上拉电阻，不然没办法工作。接好后如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        上拉电阻选择10K。最后要添加封装了。电阻电容还是选择0603的封装。SD卡的封装需要自己画。本文第二个图中datasheet已经将尺寸标准的很明确了，只需按照标注的画即可。打开封装库，载入我们的封装库。  画完后的封装如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        需要注意的是下图中红色圆圈标注的地方是固定SD大用的，分别为四个焊盘和两个钻孔。SD卡的引脚是从右向左分别为1-11.  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        画好后保存即可。然后再原理图 中添加封装。这样SD卡[电路](https://bbs.elecfans.com/zhuti_dianlu_1.html)就画完了。本次要讲的是[STM32](https://bbs.elecfans.com/zhuti_stm32_1.html)开发板USB[通信](https://bbs.elecfans.com/zhuti_wireless_1.html)接口电路与摄像头接口电路。由于这两部分都比较简单，所以放到一块讲。     首先说USB电路，前面我们将电源的时候使用的USB接口接外部电源供电的。用的是MINI型，这次的USB通信依旧用的MINI型。不过要用到USB的两根数据线了。我们STM32单片机只能作为从机进行通信，也就是将电脑设置为主机，这是其一。第二点，STM32单片机自带有USB接口。如下图所示，我们直接用网络标号连接即可。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        USB的接口端我们在D+引脚出接上上拉电阻。这是由USB物理通信协议决定的。协议规定在D+端接上拉电阻，其设置为全速模式。在D-端接上拉电阻设置为低速模式。因此我们在D+端加上拉电阻。据图电路图如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        然后给原件添加封装。依旧按之前讲的即可。这样USB通信电路就完成了。  接下来画摄像头接口电路，一般的摄像头用的是OV系列，因此我们在写网络标号时前缀上OV。首先要放置2*9的双排针。我们用到的引脚依次为PE0-PE6，PC0-PC7.依次在双排针和单片机因脚伤标出。如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)        然后之添加封装，2*9双排针的封装我们之前没有画过，因此还需要手动画。画法跟之前的一样，这里就不赘述了。要注意的就是引脚间距2.54mm，钻孔设置为0.82即可。画完后如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        之后保存，添加即可。这样USB通信电路和摄像头接口电路就画完了。 我们用STM32的FSMC总线驱动液晶屏。至于原因嘛，这里简单说下，如下图所示是STM32单片机的FSMC内存块。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)          外部的液晶屏可以当做图中的第一个NOR FLASH，因此写FSMC程序的时候也就直接用NOR FLASH程序写就可以了。这里仅仅是稍微说明下，我们主要是要画TFT驱动电路。只用知道用的STM32的FSMC引脚就行了，详细的介绍会在程序说明里讲。       前提还有一点，由于我们所使用的的液晶屏的电路是已经设计好的。因此在设计开发板电路的时候，引脚的的位置也是固定的，不是自己想怎么画就怎么画。一定要按照液晶屏电路上引脚接口画。这里原理图的电路我已经画好了，大家只需按照图中接法放置好网络标号即可。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        这里需要一个2*16的双排针，然后还要切记，在FSMC-NE1和PSMC-CS引脚处添加上啦电阻，因为这两个引脚都是片选引脚。单片机的IO口如果没有定义的画上电后电平是不定的，因此需要接一个上啦电阻将片选引脚的电平固定一下，以防止误选中。这一点是要注意的，不仅是在TFT电路，其他电路也需要这样做，只要他有片选引脚。    最后就是在单片机接口上放置对应的网络标号，这里我也已经放好，大家只需按下图所示放置即可。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)        最后别忘了添加封装。这样开发板的TFT电路就画好。 `  ![img](https://bbs.elecfans.com/static/image/common/none.gif) |
| ------------------------------------------------------------ |
| [只看该作者](https://bbs.elecfans.com/forum.php?mod=viewthread&tid=1109273&page=1&authorid=2164708)                                                                                                                                                                [*![分享](https://bbs.elecfans.com/static/image/common/collection.png)淘帖*](https://bbs.elecfans.com/forum.php?mod=collection&action=edit&op=addthread&tid=1109273)                                                                                                    [举报](javascript:;)                                                                                                                                                                                                                                                                                                                                                                                                   相关推荐                                                                                                                                                                                                                                                                                                                                                                [                                                     • TFT-lcd液晶屏接口类型之ttl接口相关资料分享                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         1429*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2261812_1_1.html)                                                                                                                                                                                    [                                                     • STM32单片机如何实现连接USB摄像头                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         5848*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2125496_1_1.html)                                                                                                                                                                                    [                                                     • 彩色液晶屏接口及其驱动电路                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         2939*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_1695434_1_1.html)                                                                                                                                                                                    [                                                     • STM32液晶屏接口和SD卡接口设计                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         3908*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_1610770_1_1.html)                                                                                                                                                                                    [                                                     • STM32单片机实现连接USB摄像头                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/d_load.png)                                                         117*                                                                                                                                                               ](https://www.elecfans.com/soft/33/2021/202111181739687.html)                                                                                                                                                                                    [                                                     • 51单片机与SD卡接口设计                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/d_load.png)                                                         410*                                                                                                                                                               ](https://www.elecfans.com/soft/study/mcu/2012/20120409267281.html)                                                                                                                                                                                    [                                                     • 单片机的I/O接口电路的扩展                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         7632*                                                                                                                                                               ](https://www.elecfans.com/d/1237338.html)                                                                                                                                                                                    [                                                     • fireflyAIO-3288C主板MIPI CSI摄像头接口简介                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         4610*                                                                                                                                                               ](https://www.elecfans.com/d/1099992.html)                                                                                                                                                                                    [                                                     • 【小梅哥FPGA】【AC6102】FPGA+USB3.0+千兆以太网+2Gb DDR2+ LVDS 高速开发板                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         24051*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_1144900_1_1.html)                                                                                                                                                                                    [                                                     • KiCAD教程（13），单片机开发板按键、LED灯、蜂鸣器、摄像头接口以及无线通信模块电路                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         14112*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_1109477_1_1.html) |
|                                                              |

### 评论

[B](javascript:;) [Color](javascript:;)   [Link](javascript:;) [Quote](javascript:;) [Code](javascript:;) [Smilies](javascript:;)     您需要登录后才可以回帖 [登录/注册](javascript:;)



声明：本文内容及配图由入驻作者撰写或者入驻合作网站授权转载。文章观点仅代表作者本人，不代表电子发烧友网立场。文章及其配图仅供工程师学习之用，如有内容图片侵权或者其他问题，请联系本站作侵删。 [侵权投诉](https://www.elecfans.com/about/tousu.html)

​    

[                             发经验                         ](https://bbs.elecfans.com/forum.php?mod=post&action=newthread&fid=1339&special=7)

[![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708)

[spark_zhang](https://bbs.elecfans.com/user/2164708) 





技术员 

积分：167经验：101

- 主题

  ##### 22

- 文章

  ##### 0

- 粉丝

  ##### 43

+关注

发私信

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.2590676560112717&amp;zoneid=242&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109273_1_1.html" scrolling="no" width="300" height="250" frameborder="0"></iframe>

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.27507927292239887&amp;zoneid=781&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109273_1_1.html" scrolling="no" width="300" height="125" frameborder="0"></iframe>

### 直播

[查看更多 >>](https://t.elecfans.com/live)

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

开源芯片系列讲座第09期：RISC-V软硬件协同设计全流程软件栈

2023/5/10 15:00  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

OpenHarmony知识赋能No.29-DAYU200分布式应用开发

2023/5/4 19:00  回顾

![img](https://file.elecfans.com/web2/M00/61/AB/pYYBAGL7hJaACg3NAAAX92fOR8889.jpeg)

开源硬件系列07期：基于生成器方法学的CGRA(可重构计算)设计

2023/4/27 19:30  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【2023】OpenHarmony开发者大会：技术论坛

2023/4/19 14:00  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【2023】OpenHarmony开发者大会：主论坛

2023/4/19 09:35  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

RISC-V 开发平台 Milk-V Pioneer 发布会

2023/4/15 15:00  回顾

![img](https://file.elecfans.com/web2/M00/3F/EF/poYBAGJqh3-AFAm_AAGpPtG2eAM315.png)

国产EDA软件新星03期-Venus智能建库工具介绍

2023/4/13 19:00  回顾

![img](https://file.elecfans.com/web2/M00/43/F3/pYYBAGKCLNCAfe1iAAEAAYXz0ZQ341.png)

【新品发布】IFX新款开发板发布与上手培训

2023/4/12 15:00  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

【开源芯片系列讲座】RISC-V计算软件栈与高性能计算进展

2023/4/7 20:00  回顾

![img](https://file.elecfans.com/web2/M00/01/14/pYYBAGDBfdOAAsnuAADpn0dJLuQ131.png)

开放原子开源基金会“源聚一堂”开源技术沙龙

2023/4/7 09:00  回顾

![img](https://file.elecfans.com/web2/M00/13/37/pYYBAGEwm8iACBfmAAEbdg3hPPo606.png)

《OpenHarmony“芯”进展》系列直播课——LoongArch专场

2023/4/4 18:55  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【OpenHarmony】2023开放原子校源行（北京站）

2023/4/2 09:24  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

OpenHarmony知识赋能No.28-OpenHarmony系统的驱动架构解析

2023/3/30 18:55  回顾

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座03期-T507-H 处理器音频接口的详细讲解

2023/5/25 19:00 报名中

![img](https://file.elecfans.com/web1/M00/CE/20/o4YBAF-iaBOAfClHAADS3eM3IVY279.jpg)

【创龙分享】国产工业嵌入式处理器架构解析

2023/5/25 19:00 报名中

![img](https://file.elecfans.com/web2/M00/01/14/pYYBAGDBfdOAAsnuAADpn0dJLuQ131.png)

OpenHarmony创新赛赛事宣讲会

2023/5/31 14:30 报名中

![img](https://file.elecfans.com/web2/M00/61/AB/pYYBAGL7hJaACg3NAAAX92fOR8889.jpeg)

开源硬件系列08期：片上网络的过去、现在和将来

2023/5/31 19:30 报名中

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座02期-NXP i.MX 9352处理器的I3C接口详解

2023/5/18 19:00  回顾

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座01期-基于rpmsg的多核异构产品双核通信应用实现

2023/5/11 19:00  回顾

![img](https://file.elecfans.com/web2/M00/72/74/pYYBAGNR9yCABb_lAAANs78gSRY396.jpg)

《RK3588 PCB设计指导白皮书》线上发布&实战解读

2023/5/11 13:50  回顾

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.5453223962157037&amp;zoneid=224&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109273_1_1.html" scrolling="no" width="300" height="600" frameborder="0"></iframe>

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.5405493152781615&amp;zoneid=678&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109273_1_1.html" scrolling="no" width="300" height="255" frameborder="0"></iframe>

​                    

广告![img](https://bbs.elecfans.com/static/image/ad/ad_close.png)[![img](https://file.elecfans.com/web2/M00/A6/17/poYBAGRlm9mAE1NyAAKVQhm_F6A861.png)](https://t.elecfans.com/live/2334.html?from=Pltdb)

[关闭](javascript:;)

##                  站长推荐                ![上一条](https://bbs.elecfans.com/static/image/common/pic_nv_prev.gif) *1/7* ![下一条](https://bbs.elecfans.com/static/image/common/pic_nv_next.gif)            

- [【开源硬件项目分享】](https://bbs.elecfans.com/collection_435_1.html)        

  本专辑集合了许多开源硬件项目分享给大家，欢迎大家一起来讨论和分享各自的开源项目！>> 立即预约

[查看 »](https://bbs.elecfans.com/collection_435_1.html)

- 华秋（原“华强聚丰”）：

  电子发烧友

  华秋开发

  华秋电路(原"华强PCB")

  华秋商城(原"华强芯城")

  华秋智造



- 设计技术

  [可编程逻辑](https://www.elecfans.com/pld/)

  [电源/新能源](https://www.elecfans.com/article/83/)

  [MEMS/传感技术](https://www.elecfans.com/article/88/142/)

  [测量仪表](https://www.elecfans.com/article/85/)

  [嵌入式技术](https://www.elecfans.com/emb/)

  [制造/封装](https://www.elecfans.com/article/90/155/)

  [模拟技术](https://www.elecfans.com/analog/)

  [RF/无线](https://www.elecfans.com/tongxin/rf/)

  [接口/总线/驱动](https://www.elecfans.com/emb/jiekou/)

  [处理器/DSP](https://www.elecfans.com/emb/dsp/)

  [EDA/IC设计](https://www.elecfans.com/bandaoti/eda/)

  [存储技术](https://www.elecfans.com/consume/cunchujishu/)

  [光电显示](https://www.elecfans.com/xianshi/)

  [EMC/EMI设计](https://www.elecfans.com/emc_emi/)

  [连接器](https://www.elecfans.com/connector/)

- 行业应用

  [LEDs ](https://www.elecfans.com/led/)

  [汽车电子](https://www.elecfans.com/qichedianzi/)

  [音视频及家电](https://www.elecfans.com/video/)

  [通信网络](https://www.elecfans.com/tongxin/)

  [医疗电子](https://www.elecfans.com/yiliaodianzi/)

  [人工智能](https://www.elecfans.com/rengongzhineng/)

  [虚拟现实](https://www.elecfans.com/vr/)

  [可穿戴设备](https://www.elecfans.com/wearable/)

  [机器人](https://www.elecfans.com/jiqiren/)

  [安全设备/系统](https://www.elecfans.com/application/Security/)

  [军用/航空电子](https://www.elecfans.com/application/Military_avionics/)

  [移动通信](https://www.elecfans.com/application/Communication/)

  [工业控制](https://www.elecfans.com/kongzhijishu/)

  [便携设备](https://www.elecfans.com/consume/bianxiedianzishebei/)

  [触控感测](https://www.elecfans.com/consume/chukongjishu/)

  [物联网](https://www.elecfans.com/iot/)

  [智能电网](https://www.elecfans.com/dianyuan/diandongche_xinnenyuan/)

  [区块链](https://www.elecfans.com/blockchain/)

  [新科技](https://www.elecfans.com/xinkeji/)

- 特色内容

  [专栏推荐](https://www.elecfans.com/d/column/)

  [学院](https://t.elecfans.com/)

  [设计资源](https://bbs.elecfans.com/group_716)

  [设计技术](https://www.elecfans.com/technical/)

  [电子百科](https://www.elecfans.com/baike/)

  [电子视频](https://www.elecfans.com/dianzishipin/)

  [元器件知识](https://www.elecfans.com/yuanqijian/)

  [工具箱](https://www.elecfans.com/tools/)

  [VIP会员](https://www.elecfans.com/vip/#choose)

- 社区

  [小组](https://bbs.elecfans.com/group/)

  [论坛](https://bbs.elecfans.com/)

  [问答](https://bbs.elecfans.com/ask.html)

  [评测试用](https://bbs.elecfans.com/try.html)

- [企业服务](https://q.elecfans.com/)

  [产品](https://q.elecfans.com/p/)

  [资料](https://q.elecfans.com/soft/)

  [文章](https://q.elecfans.com/d/)

  [方案](https://q.elecfans.com/sol/)

  [企业](https://q.elecfans.com/c/)

- 供应链服务

  [硬件开发](https://www.elecfans.com/kf/)

  [华秋电路](https://www.hqpcb.com/)

  [华秋商城](https://www.hqchip.com/)

  [华秋智造](https://smt.hqchip.com/)

  [nextPCB](https://www.nextpcb.com/)

  [BOM配单](https://www.hqchip.com/bom.html)

- 媒体服务

  [网站广告](https://www.elecfans.com/help/service.html)

  [在线研讨会](https://webinar.elecfans.com/)

  [活动策划](https://event.elecfans.com/)

  [新闻发布](https://www.elecfans.com/news/)

  [新品发布](https://www.elecfans.com/xinpian/ic/)

  [小测验](https://www.elecfans.com/quiz/)

  [设计大赛](https://www.elecfans.com/contest/)

- 华秋

  [关于我们](https://www.elecfans.com/about/)

  [投资关系](https://www.hqchip.com/help/factsheet.html)

  [新闻动态](https://www.hqchip.com/help/news/lists.html)

  [加入我们](https://www.elecfans.com/about/zhaopin.html)

  [联系我们](https://www.elecfans.com/about/contact.html)

  [侵权投诉](https://bbs.elecfans.com/about/tousu.html)

- 社交网络

  [微博](https://weibo.com/elecfanscom)

- 移动端

  [发烧友APP](https://www.elecfans.com/app/)

  [硬声APP](https://yingsheng.elecfans.com/app?eleclog)

  [WAP](https://m.elecfans.com/)

- 联系我们

  广告合作

  王婉珠：[wangwanzhu@elecfans.com](mailto:wangwanzhu@elecfans.com)

  内容合作

  黄晶晶：[huangjingjing@elecfans.com](mailto:huangjingjing@elecfans.com)

  内容合作（海外）

  张迎辉：[mikezhang@elecfans.com](mailto:mikezhang@elecfans.com)

  供应链服务 PCB/IC/PCBA

  江良华：[lanhu@huaqiu.com](mailto:lanhu@huaqiu.com)

  投资合作

  曾海银：[zenghaiyin@huaqiu.com](mailto:zenghaiyin@huaqiu.com)

  社区合作

  刘勇：[liuyong@huaqiu.com](mailto:liuyong@huaqiu.com)

- 关注我们的微信

  

- 下载发烧友APP

  

- 电子发烧友观察

  

[               ![华秋电子](https://www.elecfans.com/static/footer/image/footer-01-default.png)                          ](https://www.huaqiu.com/)

​                      [                           ![华秋发烧友](https://www.elecfans.com/static/footer/image/footer-02-default.png)                                                  ](https://www.elecfans.com/)                  

​                      [                           ![华秋电路](https://www.elecfans.com/static/footer/image/footer-03-default.png)                                                  ](https://www.hqpcb.com/)                  

​                      [                           ![华秋商城](https://www.elecfans.com/static/footer/image/footer-04-default.png)                                                  ](https://www.hqchip.com/)                  

​                      [                           ![华秋智造](https://www.elecfans.com/static/footer/image/footer-05-default.png)                                                  ](https://smt.hqchip.com/)                  

​                      [                           ![NextPCB](https://www.elecfans.com/static/footer/image/footer-06-default.png)                                                  ](https://www.nextpcb.com/)                  

- [华秋简介](https://www.huaqiu.com/about/groupoverview)
- [企业动态](https://www.huaqiu.com/news)
- [联系我们](https://www.huaqiu.com/about/contactus)
- [企业文化](https://www.huaqiu.com/about/corporateculture)
- [企业宣传片](https://www.huaqiu.com/about/promotionalfilm)
- [加入我们](https://www.huaqiu.com/jobs)

版权所有 © 深圳华秋电子有限公司 

[电子发烧友](https://www.elecfans.com/)[**（电路图）**](https://www.elecfans.com/)[粤公网安备 44030402000349 号](https://www.beian.gov.cn/ode=440304portal/registerSystemInfo?recordc02000366)[电信与信息服务业务经营许可证：粤 B2-20160233](https://www.elecfans.com/about/edi.html)[           ![工商网监认证](https://skin.elecfans.com/images/ebsIcon.png)工商网监       ](http://szcert.ebs.org.cn/c6db625a-ba09-414a-bba4-f57240baac9c6)[粤ICP备 14022951 号](https://beian.miit.gov.cn/#/Integrated/index)

- ![time](https://bbs.elecfans.com/template/elecfans_201508/images/time.png)[最新主题](https://bbs.elecfans.com/default.php?view=default)
- ![recommend](https://bbs.elecfans.com/template/elecfans_201508/images/zan.png)[推荐主题](https://bbs.elecfans.com/default.php?view=recommend)
- ![hot](https://bbs.elecfans.com/template/elecfans_201508/images/re.png)[热门主题](https://bbs.elecfans.com/default.php?view=hot)
- ![post](https://bbs.elecfans.com/template/elecfans_201508/images/me.png) [我的帖子](javascript:;)

- **-**[技术社区](https://bbs.elecfans.com/forum.php?gid=1411)

  [HarmonyOS技术社区](https://bbs.elecfans.com/harmonyos)  [RISC-V MCU技术社区](https://bbs.elecfans.com/riscvmcu)

- **-**[OpenHarmony开源社区](https://bbs.elecfans.com/forum.php?gid=1510)

  [OpenHarmony开源社区](https://bbs.elecfans.com/zhuti_1511_1.html)

- **-**[嵌入式论坛](https://bbs.elecfans.com/forum.php?gid=3)

  [ARM技术论坛](https://bbs.elecfans.com/zhuti_arm_1.html)  [STM32/STM8技术论坛](https://bbs.elecfans.com/zhuti_stm32_1.html)  [RT-Thread嵌入式技术论坛](https://bbs.elecfans.com/zhuti_emb_1.html)  [单片机/MCU论坛](https://bbs.elecfans.com/zhuti_mcu_1.html)  [RISC-V技术论坛](https://bbs.elecfans.com/zhuti_risc_1.html)  [瑞芯微Rockchip开发者社区](https://bbs.elecfans.com/zhuti_1179_1.html)  [FPGA|CPLD|ASIC论坛](https://bbs.elecfans.com/zhuti_fpga_1.html)  [DSP论坛](https://bbs.elecfans.com/zhuti_DSP_1.html)

- **-**[电路图及DIY](https://bbs.elecfans.com/forum.php?gid=48)

- **-**[电源技术论坛](https://bbs.elecfans.com/forum.php?gid=752)

- **-**[综合技术与应用](https://bbs.elecfans.com/forum.php?gid=345)

- **-**[无线通信论坛](https://bbs.elecfans.com/forum.php?gid=6)

- **-**[EDA设计论坛](https://bbs.elecfans.com/forum.php?gid=1)

- **-**[测试测量论坛](https://bbs.elecfans.com/forum.php?gid=32)

- **-**[招聘/交友/外包/交易/杂谈](https://bbs.elecfans.com/forum.php?gid=27)

- **-**[官方社区](https://bbs.elecfans.com/forum.php?gid=829)

![time](https://bbs.elecfans.com/template/elecfans_201508/images/time.png) ![recommend](https://bbs.elecfans.com/template/elecfans_201508/images/zan.png) ![hot](https://bbs.elecfans.com/template/elecfans_201508/images/re.png) ![post](https://bbs.elecfans.com/template/elecfans_201508/images/me.png)

—
—
—

版
块
导
航



展开

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.9759932166078519&amp;zoneid=1029&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109273_1_1.html" width="450" height="30" frameborder="0"></iframe>

*╳*

[![img](https://file.elecfans.com/web2/M00/7A/5B/poYBAGNx6JGAUvqIAACqaQrGZnQ426.png)](http://hqpcb.com/act/68cengban.html?fsydbtl)

[![电子技术论坛](https://bbs.elecfans.com/static/image/common/logo_new.png)](https://bbs.elecfans.com/)

- ​                            [首页](http://www.elecfans.com/)                                                    
- ​                            [论坛](https://bbs.elecfans.com/default.php)                                                                                                                                                
- ​                            [版块](https://bbs.elecfans.com/)                                                                                                                                                
- ​                            [小组](https://bbs.elecfans.com/group)                                                                                                                                                
- ​                            [活动](https://bbs.elecfans.com/zhuti_online_1.html)                                                                                                                                                
- ​                            [专栏](https://www.elecfans.com/d/)                                                                                                                                                
- ​                            [视频](https://www.elecfans.com/v/)                                                                                                                                                
- ​                            [问答](https://bbs.elecfans.com/ask/)                                                                                                                                                
- ​                            [下载](https://bbs.elecfans.com/soft/)                                                                                                                                                
- ​                            [学院](https://t.elecfans.com/)                                                                                                                                                
- ​                            [更多](javascript:;)                                                                                                                                                

|      |      |
| ---- | ---- |
|      |      |



​                                发 帖                             

- [登录/注册](javascript:;)

​                                                                                

- ![bread](https://bbs.elecfans.com/template/elecfans_201508/images/bread_img.png)[电子发烧友论坛](https://bbs.elecfans.com/forum.php)/

- ​        [EDA设计论坛](https://bbs.elecfans.com/forum.php?gid=1)/            

- ​        [KiCad EDA 中文论坛](https://bbs.elecfans.com/zhuti_kicad_1.html)                                

- /

  KiCAD教程（13），单片机开发板按键、LED灯、蜂鸣器、摄 ...

#             KiCAD教程（13），单片机开发板按键、LED灯、蜂鸣器、摄像头接口以及无线通信模块电路        

[![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708/)[spark_zhang](https://bbs.elecfans.com/user/2164708/)

*2017-2-7 20:49:31**![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/wacth.png)*14112[单片机](https://www.elecfans.com/tags/单片机/)[蜂鸣器](https://www.elecfans.com/tags/蜂鸣器/)[LED灯](https://www.elecfans.com/tags/LED灯/)[高电平](https://www.elecfans.com/tags/高电平/)

​        

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.5621697023594106&amp;zoneid=223&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109477_1_1.html" scrolling="no" width="728" height="90" frameborder="0"></iframe>

| *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zhichi.png)*                                                                                         0                                                                                                                             ![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/favorite.png)                        4                                                                                                                                                                                                                                                         `现在看看我们的[单片机](https://bbs.elecfans.com/zhuti_mcu_1.html)的引脚是不是大部分都已经被用上了？没错，我们的目的是将所有引脚都用上，一个都不浪费。既然做[开发板](https://bbs.elecfans.com/try.html)，就要把没个引脚都试试才行嘛！  这次要说的就是开发板的按键、LED灯以及蜂鸣器[电路](https://bbs.elecfans.com/zhuti_dianlu_1.html)。这几个电路都很简单，但是又不可或缺。所以还是好认真画，认真学习的！  首先就是按键电路。按键我们设置4个，分别为WAKUP：单片机唤醒按键，RESET：单片机复位按键，还有两个KEY1，KEY2辅助按键。唤醒按键是将单片机从低功耗睡眠状态唤醒。因此接的是高电平，其他三个按键分别接的是地。还有这次我们选择的按键是非自锁的按键，也就是按下去接通，松开又断开了。如下图所示。   ![img](https://bbs.elecfans.com/data/attachment/forum/201702/07/202501b4ghhgh4wwbhyg46.jpg)          电路也很简单，大家只需按下图画即可。   ![img](https://bbs.elecfans.com/static/image/common/none.gif)          单片机上对应的网络标号为别如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)        就这样按键电路就画好，接下来是画按键的封装。我们打开datasheet.大家搜的时候记得是6*6*6的，也就是长宽高都是6mm的。下图为按键的封装及内部街连接图。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        大家看图的时候注意一下右下角的内部接线图，也就是1、2 引脚是接到一起的，3、 4引脚是接到一起的。因此在画封装引脚标号的时候也要按这个画，如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        焊盘尺寸以及间距上面图中都标注的很清楚，这里就不赘述了，大家拿着要求画就可以了。     接下来就是发光二极管电路。这个我们设置两个，能做基本演示就可以了，没必要做那么多。因此我们只需点原理图上放置两个LED即可。还有就是LED电路的驱动方法的问题。他有两种驱动电路，一种是LED一端接地，另一端通过单片机引脚驱动LED。另一种是单片机一端接[电源](https://bbs.elecfans.com/zhuti_power_1.html)，另一端接单片机引脚。由于单片机的驱动能力比较弱，因此选择第二种接法。而且LED不能直接与电源相接，这样会使LED烧掉的，因此要加一个限流电阻。最后还是用双排针接好。如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        之后就是添加封装了，前面也讲过了，这里就不赘述了。    最后将蜂鸣器电路。蜂鸣器我们选择有源的，就是通过频率控制发声的。如下图所示。用的是9*5.5的3V有源蜂鸣器。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        驱动蜂鸣器还是用的三极管驱动。由于之前用的是NPN的，因此这里继续使用NPN型。具体电路如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        还是要给三极管添加一个限流电阻，并采用单排针与单片机相连。    接下来是画蜂鸣器的封装，还是看datasheet。如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        其中较长的引脚是正极，具体尺寸按上图所示画出即可。画完后如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        至此，单片机开发板的按键、LED灯以及蜂鸣器电路就画好了。讲到这里我们单片机开发板原理图电路基本快讲完了，这是原理图设计部分的最后一点电路。也就是两个接口电路，都很简单。再看看我们的单片机引脚，基本都用完了。这里将剩下的引脚都与摄像头电路的接口相连。如下图所示。放置一个2*9的双排针。并添加引脚标号。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        并在单片机引脚上也标注好。如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)        然后再画一个2*9双排针的封装，一个摄像头接口电路就画好了。    接下来画无线[通信](https://bbs.elecfans.com/zhuti_wireless_1.html)模块的接口电路。首先我们要知道我们选择的模块是NRF24L01模块，模块的接口是固定的，所以这就制约了我们画接口电路时引脚也都不能随意画了。如下图所示为NRF24L01模块。然后在原理图中放置一个2*4的双排针。由于这个模块的控制是通过SPI接口实现的，因此还需要使用单片机的SPI1接口，如下图所示为具体连接图。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)        由于引脚不够用了，所以就使用了摄像头接口的引脚，也就是使用摄像头时不能用无线通信了。    至此单片机开发板电路全部已经设计完了。  `  ![img](https://bbs.elecfans.com/static/image/common/none.gif) |
| ------------------------------------------------------------ |
| [只看该作者](https://bbs.elecfans.com/forum.php?mod=viewthread&tid=1109477&page=1&authorid=2164708)                                                                                                                                                                [*![分享](https://bbs.elecfans.com/static/image/common/collection.png)淘帖*](https://bbs.elecfans.com/forum.php?mod=collection&action=edit&op=addthread&tid=1109477)                                                                                                    [举报](javascript:;)                                                                                                                                                                                                                                                                                                                                                                                                   相关推荐                                                                                                                                                                                                                                                                                                                                                                [                                                     • 如何通过串口通信对单片机开发板上的led和蜂鸣器进行控制？                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         1447*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2216146_1_1.html)                                                                                                                                                                                    [                                                     • STM32单片机如何实现连接USB摄像头                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         5848*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2125496_1_1.html)                                                                                                                                                                                    [                                                     • 请问这个摄像头与STM32单片机连接的图像采集电路图哪有问题？                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         3833*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_1758800_1_1.html)                                                                                                                                                                                    [                                                     • 请问下图这个摄像头电路图哪有问题？                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         3222*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_1758777_1_1.html)                                                                                                                                                                                    [                                                     • STM32单片机实现连接USB摄像头                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/d_load.png)                                                         117*                                                                                                                                                               ](https://www.elecfans.com/soft/33/2021/202111181739687.html)                                                                                                                                                                                    [                                                     • 使用51单片机开发板控制LED闪烁灯的实验和程序免费下载                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/d_load.png)                                                         3*                                                                                                                                                               ](https://www.elecfans.com/soft/33/2019/20190423918264.html)                                                                                                                                                                                    [                                                     • 微雪电子STM32 Cortex M7开发板介绍                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         970*                                                                                                                                                               ](https://www.elecfans.com/d/1106190.html)                                                                                                                                                                                    [                                                     • Firefly-RK3128开发板摄像头的介绍                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         2778*                                                                                                                                                               ](https://www.elecfans.com/d/1099881.html)                                                                                                                                                                                    [                                                     • 单片机开发                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         3855*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_1311507_1_1.html)                                                                                                                                                                                    [                                                     • KiCAD教程（12），单片机SD卡接口电路、USB通信接口与摄像头接口、TFT液晶屏电路                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         9038*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_1109273_1_1.html)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          *5* 条评论                                                                                                                        [只看该作者](https://bbs.elecfans.com/forum.php?mod=viewthread&tid=1109477&page=1&authorid=2164708) |

|      |
| ---- |
|      |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/000/14/75/93_avatar_middle.jpg)](https://bbs.elecfans.com/user/147593/)                                                                            [houjue](https://bbs.elecfans.com/user/147593/)                                        *2017-2-7 21:25:59*                                                                                                                                                                                                    [                                                                                                                                                                                                                                                   沙发                                                                                                                                                                                                                                        ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109477&pid=5455875)                                                                                                                                                                                    一直在关注楼主的教程，辛苦了！ |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/001/89/68/46_avatar_middle.jpg)](https://bbs.elecfans.com/user/1896846/)                                                                            [尧建堂](https://bbs.elecfans.com/user/1896846/)                                        *2017-2-7 21:57:07*                                                                                                                                                                                                    [                                                                                                                                                                                                                                                   板凳                                                                                                                                                                                                                                        ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109477&pid=5455935)                                                                                                                                                                                    资料还可以。多谢楼主分享。 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/001/32/27/45_avatar_middle.jpg)](https://bbs.elecfans.com/user/1322745/)                                                                            [王栋春](https://bbs.elecfans.com/user/1322745/)                                        *2017-2-7 22:07:46*                                                                                                                                                                                                    [                                                                                                                                                                                           *3*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109477&pid=5455951)                                                                                                                                                                                    学习了 楼主讲的非常详细 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708/)                                                                            [spark_zhang](https://bbs.elecfans.com/user/2164708/)                                        *2017-2-10 13:26:41*                                                                                                                                                                                                    [                                                                                                                                                                                           *4*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109477&pid=5461305)                                                                                                                                                                                        [houjue 发表于 2017-2-7 21:25](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&pid=5455875&ptid=1109477)  一直在关注楼主的教程，辛苦了！      多谢支持！！！ |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/003/32/33/41_avatar_middle.jpg)](https://bbs.elecfans.com/user/3323341/)                                                                            [刘佩琦](https://bbs.elecfans.com/user/3323341/)                                        *2019-4-15 20:39:17*                                                                                                                                                                                                    [                                                                                                                                                                                           *5*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109477&pid=7501578)                                                                                                                                                                                    楼主厉害，那个用作连接按键的引脚如何确定啊？ |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

### 评论

[B](javascript:;) [Color](javascript:;)   [Link](javascript:;) [Quote](javascript:;) [Code](javascript:;) [Smilies](javascript:;)     您需要登录后才可以回帖 [登录/注册](javascript:;)



声明：本文内容及配图由入驻作者撰写或者入驻合作网站授权转载。文章观点仅代表作者本人，不代表电子发烧友网立场。文章及其配图仅供工程师学习之用，如有内容图片侵权或者其他问题，请联系本站作侵删。 [侵权投诉](https://www.elecfans.com/about/tousu.html)

​    

[                             发经验                         ](https://bbs.elecfans.com/forum.php?mod=post&action=newthread&fid=1339&special=7)

[![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708)

[spark_zhang](https://bbs.elecfans.com/user/2164708) 





技术员 

积分：167经验：101

- 主题

  ##### 22

- 文章

  ##### 0

- 粉丝

  ##### 43

+关注

发私信

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.5388659415032676&amp;zoneid=242&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109477_1_1.html" scrolling="no" width="300" height="250" frameborder="0"></iframe>

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.8243285008300948&amp;zoneid=781&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109477_1_1.html" scrolling="no" width="300" height="125" frameborder="0"></iframe>

### 直播

[查看更多 >>](https://t.elecfans.com/live)

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【2023】OpenHarmony开发者大会：技术论坛

2023/4/19 14:00  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【2023】OpenHarmony开发者大会：主论坛

2023/4/19 09:35  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

RISC-V 开发平台 Milk-V Pioneer 发布会

2023/4/15 15:00  回顾

![img](https://file.elecfans.com/web2/M00/3F/EF/poYBAGJqh3-AFAm_AAGpPtG2eAM315.png)

国产EDA软件新星03期-Venus智能建库工具介绍

2023/4/13 19:00  回顾

![img](https://file.elecfans.com/web2/M00/43/F3/pYYBAGKCLNCAfe1iAAEAAYXz0ZQ341.png)

【新品发布】IFX新款开发板发布与上手培训

2023/4/12 15:00  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

【开源芯片系列讲座】RISC-V计算软件栈与高性能计算进展

2023/4/7 20:00  回顾

![img](https://file.elecfans.com/web2/M00/01/14/pYYBAGDBfdOAAsnuAADpn0dJLuQ131.png)

开放原子开源基金会“源聚一堂”开源技术沙龙

2023/4/7 09:00  回顾

![img](https://file.elecfans.com/web2/M00/13/37/pYYBAGEwm8iACBfmAAEbdg3hPPo606.png)

《OpenHarmony“芯”进展》系列直播课——LoongArch专场

2023/4/4 18:55  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【OpenHarmony】2023开放原子校源行（北京站）

2023/4/2 09:24  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

OpenHarmony知识赋能No.28-OpenHarmony系统的驱动架构解析

2023/3/30 18:55  回顾

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座03期-T507-H 处理器音频接口的详细讲解

2023/5/25 19:00 报名中

![img](https://file.elecfans.com/web1/M00/CE/20/o4YBAF-iaBOAfClHAADS3eM3IVY279.jpg)

【创龙分享】国产工业嵌入式处理器架构解析

2023/5/25 19:00 报名中

![img](https://file.elecfans.com/web2/M00/01/14/pYYBAGDBfdOAAsnuAADpn0dJLuQ131.png)

OpenHarmony创新赛赛事宣讲会

2023/5/31 14:30 报名中

![img](https://file.elecfans.com/web2/M00/61/AB/pYYBAGL7hJaACg3NAAAX92fOR8889.jpeg)

开源硬件系列08期：片上网络的过去、现在和将来

2023/5/31 19:30 报名中

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座02期-NXP i.MX 9352处理器的I3C接口详解

2023/5/18 19:00  回顾

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座01期-基于rpmsg的多核异构产品双核通信应用实现

2023/5/11 19:00  回顾

![img](https://file.elecfans.com/web2/M00/72/74/pYYBAGNR9yCABb_lAAANs78gSRY396.jpg)

《RK3588 PCB设计指导白皮书》线上发布&实战解读

2023/5/11 13:50  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

开源芯片系列讲座第09期：RISC-V软硬件协同设计全流程软件栈

2023/5/10 15:00  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

OpenHarmony知识赋能No.29-DAYU200分布式应用开发

2023/5/4 19:00  回顾

![img](https://file.elecfans.com/web2/M00/61/AB/pYYBAGL7hJaACg3NAAAX92fOR8889.jpeg)

开源硬件系列07期：基于生成器方法学的CGRA(可重构计算)设计

2023/4/27 19:30  回顾

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.5249738775141994&amp;zoneid=224&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109477_1_1.html" scrolling="no" width="300" height="600" frameborder="0"></iframe>

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.3687874397501054&amp;zoneid=678&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109477_1_1.html" scrolling="no" width="300" height="255" frameborder="0"></iframe>

​                    

广告![img](https://bbs.elecfans.com/static/image/ad/ad_close.png)[![img](https://file.elecfans.com/web2/M00/A6/D6/pYYBAGRnDtqAO7mSAAJXTJBhXM8305.jpg)](https://smt.hqchip.com/online.html?from=Pltdb)

[关闭](javascript:;)

##                  站长推荐                ![上一条](https://bbs.elecfans.com/static/image/common/pic_nv_prev.gif) *3/7* ![下一条](https://bbs.elecfans.com/static/image/common/pic_nv_next.gif)            

- [【线下会议】汽车电子：时下最火热的赛道之一！](https://www.elecfans.com/activity/Automotive-202306/index.html?elecfans_source=textlink8)        

  此次汽车电子创新技术研讨会，邀请汽车生态圈的合作伙伴，共话未来汽车智能化发展趋势，技术和解决方案。 2023汽车电子创新技术研讨会>> 立即报名

[查看 »](https://www.elecfans.com/activity/Automotive-202306/index.html?elecfans_source=textlink8)

- 华秋（原“华强聚丰”）：

  电子发烧友

  华秋开发

  华秋电路(原"华强PCB")

  华秋商城(原"华强芯城")

  华秋智造



- 设计技术

  [可编程逻辑](https://www.elecfans.com/pld/)

  [电源/新能源](https://www.elecfans.com/article/83/)

  [MEMS/传感技术](https://www.elecfans.com/article/88/142/)

  [测量仪表](https://www.elecfans.com/article/85/)

  [嵌入式技术](https://www.elecfans.com/emb/)

  [制造/封装](https://www.elecfans.com/article/90/155/)

  [模拟技术](https://www.elecfans.com/analog/)

  [RF/无线](https://www.elecfans.com/tongxin/rf/)

  [接口/总线/驱动](https://www.elecfans.com/emb/jiekou/)

  [处理器/DSP](https://www.elecfans.com/emb/dsp/)

  [EDA/IC设计](https://www.elecfans.com/bandaoti/eda/)

  [存储技术](https://www.elecfans.com/consume/cunchujishu/)

  [光电显示](https://www.elecfans.com/xianshi/)

  [EMC/EMI设计](https://www.elecfans.com/emc_emi/)

  [连接器](https://www.elecfans.com/connector/)

- 行业应用

  [LEDs ](https://www.elecfans.com/led/)

  [汽车电子](https://www.elecfans.com/qichedianzi/)

  [音视频及家电](https://www.elecfans.com/video/)

  [通信网络](https://www.elecfans.com/tongxin/)

  [医疗电子](https://www.elecfans.com/yiliaodianzi/)

  [人工智能](https://www.elecfans.com/rengongzhineng/)

  [虚拟现实](https://www.elecfans.com/vr/)

  [可穿戴设备](https://www.elecfans.com/wearable/)

  [机器人](https://www.elecfans.com/jiqiren/)

  [安全设备/系统](https://www.elecfans.com/application/Security/)

  [军用/航空电子](https://www.elecfans.com/application/Military_avionics/)

  [移动通信](https://www.elecfans.com/application/Communication/)

  [工业控制](https://www.elecfans.com/kongzhijishu/)

  [便携设备](https://www.elecfans.com/consume/bianxiedianzishebei/)

  [触控感测](https://www.elecfans.com/consume/chukongjishu/)

  [物联网](https://www.elecfans.com/iot/)

  [智能电网](https://www.elecfans.com/dianyuan/diandongche_xinnenyuan/)

  [区块链](https://www.elecfans.com/blockchain/)

  [新科技](https://www.elecfans.com/xinkeji/)

- 特色内容

  [专栏推荐](https://www.elecfans.com/d/column/)

  [学院](https://t.elecfans.com/)

  [设计资源](https://bbs.elecfans.com/group_716)

  [设计技术](https://www.elecfans.com/technical/)

  [电子百科](https://www.elecfans.com/baike/)

  [电子视频](https://www.elecfans.com/dianzishipin/)

  [元器件知识](https://www.elecfans.com/yuanqijian/)

  [工具箱](https://www.elecfans.com/tools/)

  [VIP会员](https://www.elecfans.com/vip/#choose)

- 社区

  [小组](https://bbs.elecfans.com/group/)

  [论坛](https://bbs.elecfans.com/)

  [问答](https://bbs.elecfans.com/ask.html)

  [评测试用](https://bbs.elecfans.com/try.html)

- [企业服务](https://q.elecfans.com/)

  [产品](https://q.elecfans.com/p/)

  [资料](https://q.elecfans.com/soft/)

  [文章](https://q.elecfans.com/d/)

  [方案](https://q.elecfans.com/sol/)

  [企业](https://q.elecfans.com/c/)

- 供应链服务

  [硬件开发](https://www.elecfans.com/kf/)

  [华秋电路](https://www.hqpcb.com/)

  [华秋商城](https://www.hqchip.com/)

  [华秋智造](https://smt.hqchip.com/)

  [nextPCB](https://www.nextpcb.com/)

  [BOM配单](https://www.hqchip.com/bom.html)

- 媒体服务

  [网站广告](https://www.elecfans.com/help/service.html)

  [在线研讨会](https://webinar.elecfans.com/)

  [活动策划](https://event.elecfans.com/)

  [新闻发布](https://www.elecfans.com/news/)

  [新品发布](https://www.elecfans.com/xinpian/ic/)

  [小测验](https://www.elecfans.com/quiz/)

  [设计大赛](https://www.elecfans.com/contest/)

- 华秋

  [关于我们](https://www.elecfans.com/about/)

  [投资关系](https://www.hqchip.com/help/factsheet.html)

  [新闻动态](https://www.hqchip.com/help/news/lists.html)

  [加入我们](https://www.elecfans.com/about/zhaopin.html)

  [联系我们](https://www.elecfans.com/about/contact.html)

  [侵权投诉](https://bbs.elecfans.com/about/tousu.html)

- 社交网络

  [微博](https://weibo.com/elecfanscom)

- 移动端

  [发烧友APP](https://www.elecfans.com/app/)

  [硬声APP](https://yingsheng.elecfans.com/app?eleclog)

  [WAP](https://m.elecfans.com/)

- 联系我们

  广告合作

  王婉珠：[wangwanzhu@elecfans.com](mailto:wangwanzhu@elecfans.com)

  内容合作

  黄晶晶：[huangjingjing@elecfans.com](mailto:huangjingjing@elecfans.com)

  内容合作（海外）

  张迎辉：[mikezhang@elecfans.com](mailto:mikezhang@elecfans.com)

  供应链服务 PCB/IC/PCBA

  江良华：[lanhu@huaqiu.com](mailto:lanhu@huaqiu.com)

  投资合作

  曾海银：[zenghaiyin@huaqiu.com](mailto:zenghaiyin@huaqiu.com)

  社区合作

  刘勇：[liuyong@huaqiu.com](mailto:liuyong@huaqiu.com)

- 关注我们的微信

  

- 下载发烧友APP

  

- 电子发烧友观察

  

[               ![华秋电子](https://www.elecfans.com/static/footer/image/footer-01-default.png)                          ](https://www.huaqiu.com/)

​                      [                           ![华秋发烧友](https://www.elecfans.com/static/footer/image/footer-02-default.png)                                                  ](https://www.elecfans.com/)                  

​                      [                           ![华秋电路](https://www.elecfans.com/static/footer/image/footer-03-default.png)                                                  ](https://www.hqpcb.com/)                  

​                      [                           ![华秋商城](https://www.elecfans.com/static/footer/image/footer-04-default.png)                                                  ](https://www.hqchip.com/)                  

​                      [                           ![华秋智造](https://www.elecfans.com/static/footer/image/footer-05-default.png)                                                  ](https://smt.hqchip.com/)                  

​                      [                           ![NextPCB](https://www.elecfans.com/static/footer/image/footer-06-default.png)                                                  ](https://www.nextpcb.com/)                  

- [华秋简介](https://www.huaqiu.com/about/groupoverview)
- [企业动态](https://www.huaqiu.com/news)
- [联系我们](https://www.huaqiu.com/about/contactus)
- [企业文化](https://www.huaqiu.com/about/corporateculture)
- [企业宣传片](https://www.huaqiu.com/about/promotionalfilm)
- [加入我们](https://www.huaqiu.com/jobs)

版权所有 © 深圳华秋电子有限公司 

[电子发烧友](https://www.elecfans.com/)[**（电路图）**](https://www.elecfans.com/)[粤公网安备 44030402000349 号](https://www.beian.gov.cn/ode=440304portal/registerSystemInfo?recordc02000366)[电信与信息服务业务经营许可证：粤 B2-20160233](https://www.elecfans.com/about/edi.html)[           ![工商网监认证](https://skin.elecfans.com/images/ebsIcon.png)工商网监       ](http://szcert.ebs.org.cn/c6db625a-ba09-414a-bba4-f57240baac9c6)[粤ICP备 14022951 号](https://beian.miit.gov.cn/#/Integrated/index)

- ![time](https://bbs.elecfans.com/template/elecfans_201508/images/time.png)[最新主题](https://bbs.elecfans.com/default.php?view=default)
- ![recommend](https://bbs.elecfans.com/template/elecfans_201508/images/zan.png)[推荐主题](https://bbs.elecfans.com/default.php?view=recommend)
- ![hot](https://bbs.elecfans.com/template/elecfans_201508/images/re.png)[热门主题](https://bbs.elecfans.com/default.php?view=hot)
- ![post](https://bbs.elecfans.com/template/elecfans_201508/images/me.png) [我的帖子](javascript:;)

- **-**[技术社区](https://bbs.elecfans.com/forum.php?gid=1411)

  [HarmonyOS技术社区](https://bbs.elecfans.com/harmonyos)  [RISC-V MCU技术社区](https://bbs.elecfans.com/riscvmcu)

- **-**[OpenHarmony开源社区](https://bbs.elecfans.com/forum.php?gid=1510)

  [OpenHarmony开源社区](https://bbs.elecfans.com/zhuti_1511_1.html)

- **-**[嵌入式论坛](https://bbs.elecfans.com/forum.php?gid=3)

  [ARM技术论坛](https://bbs.elecfans.com/zhuti_arm_1.html)  [STM32/STM8技术论坛](https://bbs.elecfans.com/zhuti_stm32_1.html)  [RT-Thread嵌入式技术论坛](https://bbs.elecfans.com/zhuti_emb_1.html)  [单片机/MCU论坛](https://bbs.elecfans.com/zhuti_mcu_1.html)  [RISC-V技术论坛](https://bbs.elecfans.com/zhuti_risc_1.html)  [瑞芯微Rockchip开发者社区](https://bbs.elecfans.com/zhuti_1179_1.html)  [FPGA|CPLD|ASIC论坛](https://bbs.elecfans.com/zhuti_fpga_1.html)  [DSP论坛](https://bbs.elecfans.com/zhuti_DSP_1.html)

- **-**[电路图及DIY](https://bbs.elecfans.com/forum.php?gid=48)

- **-**[电源技术论坛](https://bbs.elecfans.com/forum.php?gid=752)

- **-**[综合技术与应用](https://bbs.elecfans.com/forum.php?gid=345)

- **-**[无线通信论坛](https://bbs.elecfans.com/forum.php?gid=6)

- **-**[EDA设计论坛](https://bbs.elecfans.com/forum.php?gid=1)

- **-**[测试测量论坛](https://bbs.elecfans.com/forum.php?gid=32)

- **-**[招聘/交友/外包/交易/杂谈](https://bbs.elecfans.com/forum.php?gid=27)

- **-**[官方社区](https://bbs.elecfans.com/forum.php?gid=829)

![time](https://bbs.elecfans.com/template/elecfans_201508/images/time.png) ![recommend](https://bbs.elecfans.com/template/elecfans_201508/images/zan.png) ![hot](https://bbs.elecfans.com/template/elecfans_201508/images/re.png) ![post](https://bbs.elecfans.com/template/elecfans_201508/images/me.png)

—
—
—

版
块
导
航



展开

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.8081857993290852&amp;zoneid=1029&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109477_1_1.html" width="450" height="30" frameborder="0"></iframe>

*╳*

[![img](https://file.elecfans.com/web2/M00/7A/5B/poYBAGNx6JGAUvqIAACqaQrGZnQ426.png)](http://hqpcb.com/act/68cengban.html?fsydbtl)

[![电子技术论坛](https://bbs.elecfans.com/static/image/common/logo_new.png)](https://bbs.elecfans.com/)

- ​                            [首页](http://www.elecfans.com/)                                                    
- ​                            [论坛](https://bbs.elecfans.com/default.php)                                                                                                                                                
- ​                            [版块](https://bbs.elecfans.com/)                                                                                                                                                
- ​                            [小组](https://bbs.elecfans.com/group)                                                                                                                                                
- ​                            [活动](https://bbs.elecfans.com/zhuti_online_1.html)                                                                                                                                                
- ​                            [专栏](https://www.elecfans.com/d/)                                                                                                                                                
- ​                            [视频](https://www.elecfans.com/v/)                                                                                                                                                
- ​                            [问答](https://bbs.elecfans.com/ask/)                                                                                                                                                
- ​                            [下载](https://bbs.elecfans.com/soft/)                                                                                                                                                
- ​                            [学院](https://t.elecfans.com/)                                                                                                                                                
- ​                            [更多](javascript:;)                                                                                                                                                

|      |      |
| ---- | ---- |
|      |      |



​                                发 帖                             

- [登录/注册](javascript:;)

​                                                                                

- ![bread](https://bbs.elecfans.com/template/elecfans_201508/images/bread_img.png)[电子发烧友论坛](https://bbs.elecfans.com/forum.php)/

- ​        [EDA设计论坛](https://bbs.elecfans.com/forum.php?gid=1)/            

- ​        [KiCad EDA 中文论坛](https://bbs.elecfans.com/zhuti_kicad_1.html)                                

- /

  KiCAD教程（14），单片机原理图整理与查错 ...

#             KiCAD教程（14），单片机原理图整理与查错

| *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zhichi.png)*                                                                                         0                                                                                                                             ![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/favorite.png)                        5                                                                                                                                                                                                                                                         做这个教程有一二十天了，从最开始的软件安装到一步步的教大家怎么画[元件](https://bbs.elecfans.com/zhuti_yuanjian_1.html)，画封装以及最后的画一个[开发板](https://bbs.elecfans.com/try.html)。到目前为止一个完整的[STM32](https://bbs.elecfans.com/zhuti_stm32_1.html)开发板原理图彻底画完了。一些基本的常用模块基本也都添加了，下图就是我将整个原理图整理了一下，最后的结果。  ![img](https://bbs.elecfans.com/data/attachment/forum/201702/08/203327yrs76spqum9yqu2l.png)            大家也可以稍微的整理一下，这样看着也舒服。对了，还要说一下就是KICAD这个软件是不能用中文标注的，所示只能写上英文了。  最后在整理完后就需要检查一下原理图有没有错误的地方，比如哪个元件没有导入封装，或者元件的标号有错误什么的。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        点如上图所示的形如一个甲壳虫的选项，弹出下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        点运行即可，如果有错误会显示，大家只需按照错误提醒改就可以了！  上面是执行规则检查，下面介绍[PCB](https://bbs.elecfans.com/zhuti_pads_1.html)元件封装检查。按下图所示进行操作。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        之后会出现如下图所示内容，大家不要急着点，这个可能要反应个十几秒。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        中间的部分列出了原理图中所用到的所有原件的信息，如果此元件没有添加封装，后边就没有显示。这样就便于检查封装信息是否完整。  之前在讲每一个模块的时候都是添加完元件然后再添加封装。其实大家可以先不添加封装，当把原理图全部完成后再通过这里能够快速添加封装。  最后，还要再说一点。有的情况是再打开CVPCB时出现卡死的情况。这点是由于软件本身的原因，大家可以通过如下方法进行设置即可解决。  **1** **打开封装编辑器，找到封装管理。**  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        **2 在电脑中找到这个路径。其中appdata文件夹是隐藏的，显示隐藏即可。**  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        **3** **找到这个文件，用记事本打开**  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        **4** **编辑替换，这里要替换的为两项内容。**（1）将type_Github替换为type_KiCAD（2）将${KIGITHUB}替换为${KISYSMOD}**5** **保存退出**  设置完后即可解决卡死问题 |
| ------------------------------------------------------------ |
| [只看该作者](https://bbs.elecfans.com/forum.php?mod=viewthread&tid=1109660&page=1&authorid=2164708)                                                                                                                                                                [*![分享](https://bbs.elecfans.com/static/image/common/collection.png)淘帖*](https://bbs.elecfans.com/forum.php?mod=collection&action=edit&op=addthread&tid=1109660)                                                                                                    [举报](javascript:;)                                                                                                                                                                                                                                                                                                                                                                                                   相关推荐                                                                                                                                                                                                                                                                                                                                                                [                                                     • 如何在KiCad中导入Altium Designer的原理图/PCB                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         43*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2358057_1_1.html)                                                                                                                                                                                    [                                                     • 51单片机流水灯从原理图到PCB转化  精选资料分享                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         5609*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2123092_1_1.html)                                                                                                                                                                                    [                                                     • ct107d单片机板原理图                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         1099*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2121687_1_1.html)                                                                                                                                                                                    [                                                     • KiCAD教程（8），单片机引脚引出到端口                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         13673*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_1108024_1_1.html)                                                                                                                                                                                    [                                                     • 51单片机矩阵键盘的原理图                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/d_load.png)                                                         58*                                                                                                                                                               ](https://www.elecfans.com/soft/33/2021/202112291767967.html)                                                                                                                                                                                    [                                                     • 51单片机整理                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/d_load.png)                                                         13*                                                                                                                                                               ](https://www.elecfans.com/soft/33/2021/202111171738732.html)                                                                                                                                                                                    [                                                     • 单片机的引脚图及引脚功能_单片机简易编程                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         38844*                                                                                                                                                               ](https://www.elecfans.com/d/998418.html)                                                                                                                                                                                    [                                                     • KiCad在原理图这部分如何使用？                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         10059*                                                                                                                                                               ](https://www.elecfans.com/bandaoti/eda/20181014798031.html)                                                                                                                                                                                    [                                                     • 单片机原理图                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         2352*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_473834_1_1.html)                                                                                                                                                                                    [                                                     • 51单片机原理图                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         3760*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_346250_1_1.html)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          *2* 条评论                                                                                                                        [只看该作者](https://bbs.elecfans.com/forum.php?mod=viewthread&tid=1109660&page=1&authorid=2164708) |

|      |
| ---- |
|      |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/25/55/63_avatar_middle.jpg)](https://bbs.elecfans.com/user/2255563/)                                                                            [周棠亨](https://bbs.elecfans.com/user/2255563/)                                        *2017-2-10 17:16:02*                                                                                                                                                                                                    [                                                                                                                                                                                                                                                   沙发                                                                                                                                                                                                                                        ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109660&pid=5461957)                                                                                                                                                                                    谢谢楼主整理，学习了 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708/)                                                                            [spark_zhang](https://bbs.elecfans.com/user/2164708/)                                        *2017-2-11 13:11:19*                                                                                                                                                                                                    [                                                                                                                                                                                                                                                   板凳                                                                                                                                                                                                                                        ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109660&pid=5462886)                                                                                                                                                                                        [初级少校 发表于 2017-2-10 17:16](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&pid=5461957&ptid=1109660)  谢谢楼主整理，学习了      多谢支持！！！！ |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

### 评论

[B](javascript:;) [Color](javascript:;)   [Link](javascript:;) [Quote](javascript:;) [Code](javascript:;) [Smilies](javascript:;)     您需要登录后才可以回帖 [登录/注册](javascript:;)



声明：本文内容及配图由入驻作者撰写或者入驻合作网站授权转载。文章观点仅代表作者本人，不代表电子发烧友网立场。文章及其配图仅供工程师学习之用，如有内容图片侵权或者其他问题，请联系本站作侵删。 [侵权投诉](https://www.elecfans.com/about/tousu.html)

​    

[                             发经验                         ](https://bbs.elecfans.com/forum.php?mod=post&action=newthread&fid=1339&special=7)

[![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708)

[spark_zhang](https://bbs.elecfans.com/user/2164708) 





技术员 

积分：167经验：101

- 主题

  ##### 22

- 文章

  ##### 0

- 粉丝

  ##### 43

+关注

发私信

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.2849366501870916&amp;zoneid=242&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109660_1_1.html" scrolling="no" width="300" height="250" frameborder="0"></iframe>

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.7103027551060539&amp;zoneid=781&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109660_1_1.html" scrolling="no" width="300" height="125" frameborder="0"></iframe>

### 直播

[查看更多 >>](https://t.elecfans.com/live)

![img](https://file.elecfans.com/web2/M00/3F/EF/poYBAGJqh3-AFAm_AAGpPtG2eAM315.png)

国产EDA软件新星03期-Venus智能建库工具介绍

2023/4/13 19:00  回顾

![img](https://file.elecfans.com/web2/M00/43/F3/pYYBAGKCLNCAfe1iAAEAAYXz0ZQ341.png)

【新品发布】IFX新款开发板发布与上手培训

2023/4/12 15:00  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

【开源芯片系列讲座】RISC-V计算软件栈与高性能计算进展

2023/4/7 20:00  回顾

![img](https://file.elecfans.com/web2/M00/01/14/pYYBAGDBfdOAAsnuAADpn0dJLuQ131.png)

开放原子开源基金会“源聚一堂”开源技术沙龙

2023/4/7 09:00  回顾

![img](https://file.elecfans.com/web2/M00/13/37/pYYBAGEwm8iACBfmAAEbdg3hPPo606.png)

《OpenHarmony“芯”进展》系列直播课——LoongArch专场

2023/4/4 18:55  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【OpenHarmony】2023开放原子校源行（北京站）

2023/4/2 09:24  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

OpenHarmony知识赋能No.28-OpenHarmony系统的驱动架构解析

2023/3/30 18:55  回顾

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座03期-T507-H 处理器音频接口的详细讲解

2023/5/25 19:00 报名中

![img](https://file.elecfans.com/web1/M00/CE/20/o4YBAF-iaBOAfClHAADS3eM3IVY279.jpg)

【创龙分享】国产工业嵌入式处理器架构解析

2023/5/25 19:00 报名中

![img](https://file.elecfans.com/web2/M00/01/14/pYYBAGDBfdOAAsnuAADpn0dJLuQ131.png)

OpenHarmony创新赛赛事宣讲会

2023/5/31 14:30 报名中

![img](https://file.elecfans.com/web2/M00/61/AB/pYYBAGL7hJaACg3NAAAX92fOR8889.jpeg)

开源硬件系列08期：片上网络的过去、现在和将来

2023/5/31 19:30 报名中

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座02期-NXP i.MX 9352处理器的I3C接口详解

2023/5/18 19:00  回顾

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座01期-基于rpmsg的多核异构产品双核通信应用实现

2023/5/11 19:00  回顾

![img](https://file.elecfans.com/web2/M00/72/74/pYYBAGNR9yCABb_lAAANs78gSRY396.jpg)

《RK3588 PCB设计指导白皮书》线上发布&实战解读

2023/5/11 13:50  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

开源芯片系列讲座第09期：RISC-V软硬件协同设计全流程软件栈

2023/5/10 15:00  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

OpenHarmony知识赋能No.29-DAYU200分布式应用开发

2023/5/4 19:00  回顾

![img](https://file.elecfans.com/web2/M00/61/AB/pYYBAGL7hJaACg3NAAAX92fOR8889.jpeg)

开源硬件系列07期：基于生成器方法学的CGRA(可重构计算)设计

2023/4/27 19:30  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【2023】OpenHarmony开发者大会：技术论坛

2023/4/19 14:00  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【2023】OpenHarmony开发者大会：主论坛

2023/4/19 09:35  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

RISC-V 开发平台 Milk-V Pioneer 发布会

2023/4/15 15:00  回顾

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.6196709742901086&amp;zoneid=224&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109660_1_1.html" scrolling="no" width="300" height="600" frameborder="0"></iframe>

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.047623075191117636&amp;zoneid=678&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109660_1_1.html" scrolling="no" width="300" height="255" frameborder="0"></iframe>

​                    

广告![img](https://bbs.elecfans.com/static/image/ad/ad_close.png)[![img](https://file.elecfans.com/web2/M00/A6/D6/pYYBAGRnDtqAO7mSAAJXTJBhXM8305.jpg)](https://smt.hqchip.com/online.html?from=Pltdb)

[关闭](javascript:;)

##                  站长推荐                ![上一条](https://bbs.elecfans.com/static/image/common/pic_nv_prev.gif) *7/7* ![下一条](https://bbs.elecfans.com/static/image/common/pic_nv_next.gif)            

- [【免费领取】](https://url.elecfans.com/u/260fc9c6fe)        

  华秋电子将联合瑞芯微、凡亿重磅发布《RK3588 PCB设计指导白皮书》，免费下载！

[查看 »](https://url.elecfans.com/u/260fc9c6fe)

- 华秋（原“华强聚丰”）：

  电子发烧友

  华秋开发

  华秋电路(原"华强PCB")

  华秋商城(原"华强芯城")

  华秋智造



- 设计技术

  [可编程逻辑](https://www.elecfans.com/pld/)

  [电源/新能源](https://www.elecfans.com/article/83/)

  [MEMS/传感技术](https://www.elecfans.com/article/88/142/)

  [测量仪表](https://www.elecfans.com/article/85/)

  [嵌入式技术](https://www.elecfans.com/emb/)

  [制造/封装](https://www.elecfans.com/article/90/155/)

  [模拟技术](https://www.elecfans.com/analog/)

  [RF/无线](https://www.elecfans.com/tongxin/rf/)

  [接口/总线/驱动](https://www.elecfans.com/emb/jiekou/)

  [处理器/DSP](https://www.elecfans.com/emb/dsp/)

  [EDA/IC设计](https://www.elecfans.com/bandaoti/eda/)

  [存储技术](https://www.elecfans.com/consume/cunchujishu/)

  [光电显示](https://www.elecfans.com/xianshi/)

  [EMC/EMI设计](https://www.elecfans.com/emc_emi/)

  [连接器](https://www.elecfans.com/connector/)

- 行业应用

  [LEDs ](https://www.elecfans.com/led/)

  [汽车电子](https://www.elecfans.com/qichedianzi/)

  [音视频及家电](https://www.elecfans.com/video/)

  [通信网络](https://www.elecfans.com/tongxin/)

  [医疗电子](https://www.elecfans.com/yiliaodianzi/)

  [人工智能](https://www.elecfans.com/rengongzhineng/)

  [虚拟现实](https://www.elecfans.com/vr/)

  [可穿戴设备](https://www.elecfans.com/wearable/)

  [机器人](https://www.elecfans.com/jiqiren/)

  [安全设备/系统](https://www.elecfans.com/application/Security/)

  [军用/航空电子](https://www.elecfans.com/application/Military_avionics/)

  [移动通信](https://www.elecfans.com/application/Communication/)

  [工业控制](https://www.elecfans.com/kongzhijishu/)

  [便携设备](https://www.elecfans.com/consume/bianxiedianzishebei/)

  [触控感测](https://www.elecfans.com/consume/chukongjishu/)

  [物联网](https://www.elecfans.com/iot/)

  [智能电网](https://www.elecfans.com/dianyuan/diandongche_xinnenyuan/)

  [区块链](https://www.elecfans.com/blockchain/)

  [新科技](https://www.elecfans.com/xinkeji/)

- 特色内容

  [专栏推荐](https://www.elecfans.com/d/column/)

  [学院](https://t.elecfans.com/)

  [设计资源](https://bbs.elecfans.com/group_716)

  [设计技术](https://www.elecfans.com/technical/)

  [电子百科](https://www.elecfans.com/baike/)

  [电子视频](https://www.elecfans.com/dianzishipin/)

  [元器件知识](https://www.elecfans.com/yuanqijian/)

  [工具箱](https://www.elecfans.com/tools/)

  [VIP会员](https://www.elecfans.com/vip/#choose)

- 社区

  [小组](https://bbs.elecfans.com/group/)

  [论坛](https://bbs.elecfans.com/)

  [问答](https://bbs.elecfans.com/ask.html)

  [评测试用](https://bbs.elecfans.com/try.html)

- [企业服务](https://q.elecfans.com/)

  [产品](https://q.elecfans.com/p/)

  [资料](https://q.elecfans.com/soft/)

  [文章](https://q.elecfans.com/d/)

  [方案](https://q.elecfans.com/sol/)

  [企业](https://q.elecfans.com/c/)

- 供应链服务

  [硬件开发](https://www.elecfans.com/kf/)

  [华秋电路](https://www.hqpcb.com/)

  [华秋商城](https://www.hqchip.com/)

  [华秋智造](https://smt.hqchip.com/)

  [nextPCB](https://www.nextpcb.com/)

  [BOM配单](https://www.hqchip.com/bom.html)

- 媒体服务

  [网站广告](https://www.elecfans.com/help/service.html)

  [在线研讨会](https://webinar.elecfans.com/)

  [活动策划](https://event.elecfans.com/)

  [新闻发布](https://www.elecfans.com/news/)

  [新品发布](https://www.elecfans.com/xinpian/ic/)

  [小测验](https://www.elecfans.com/quiz/)

  [设计大赛](https://www.elecfans.com/contest/)

- 华秋

  [关于我们](https://www.elecfans.com/about/)

  [投资关系](https://www.hqchip.com/help/factsheet.html)

  [新闻动态](https://www.hqchip.com/help/news/lists.html)

  [加入我们](https://www.elecfans.com/about/zhaopin.html)

  [联系我们](https://www.elecfans.com/about/contact.html)

  [侵权投诉](https://bbs.elecfans.com/about/tousu.html)

- 社交网络

  [微博](https://weibo.com/elecfanscom)

- 移动端

  [发烧友APP](https://www.elecfans.com/app/)

  [硬声APP](https://yingsheng.elecfans.com/app?eleclog)

  [WAP](https://m.elecfans.com/)

- 联系我们

  广告合作

  王婉珠：[wangwanzhu@elecfans.com](mailto:wangwanzhu@elecfans.com)

  内容合作

  黄晶晶：[huangjingjing@elecfans.com](mailto:huangjingjing@elecfans.com)

  内容合作（海外）

  张迎辉：[mikezhang@elecfans.com](mailto:mikezhang@elecfans.com)

  供应链服务 PCB/IC/PCBA

  江良华：[lanhu@huaqiu.com](mailto:lanhu@huaqiu.com)

  投资合作

  曾海银：[zenghaiyin@huaqiu.com](mailto:zenghaiyin@huaqiu.com)

  社区合作

  刘勇：[liuyong@huaqiu.com](mailto:liuyong@huaqiu.com)

- 关注我们的微信

  

- 下载发烧友APP

  

- 电子发烧友观察

  

[               ![华秋电子](https://www.elecfans.com/static/footer/image/footer-01-default.png)                          ](https://www.huaqiu.com/)

​                      [                           ![华秋发烧友](https://www.elecfans.com/static/footer/image/footer-02-default.png)                                                  ](https://www.elecfans.com/)                  

​                      [                           ![华秋电路](https://www.elecfans.com/static/footer/image/footer-03-default.png)                                                  ](https://www.hqpcb.com/)                  

​                      [                           ![华秋商城](https://www.elecfans.com/static/footer/image/footer-04-default.png)                                                  ](https://www.hqchip.com/)                  

​                      [                           ![华秋智造](https://www.elecfans.com/static/footer/image/footer-05-default.png)                                                  ](https://smt.hqchip.com/)                  

​                      [                           ![NextPCB](https://www.elecfans.com/static/footer/image/footer-06-default.png)                                                  ](https://www.nextpcb.com/)                  

- [华秋简介](https://www.huaqiu.com/about/groupoverview)
- [企业动态](https://www.huaqiu.com/news)
- [联系我们](https://www.huaqiu.com/about/contactus)
- [企业文化](https://www.huaqiu.com/about/corporateculture)
- [企业宣传片](https://www.huaqiu.com/about/promotionalfilm)
- [加入我们](https://www.huaqiu.com/jobs)

版权所有 © 深圳华秋电子有限公司 

[电子发烧友](https://www.elecfans.com/)[**（电路图）**](https://www.elecfans.com/)[粤公网安备 44030402000349 号](https://www.beian.gov.cn/ode=440304portal/registerSystemInfo?recordc02000366)[电信与信息服务业务经营许可证：粤 B2-20160233](https://www.elecfans.com/about/edi.html)[           ![工商网监认证](https://skin.elecfans.com/images/ebsIcon.png)工商网监       ](http://szcert.ebs.org.cn/c6db625a-ba09-414a-bba4-f57240baac9c6)[粤ICP备 14022951 号](https://beian.miit.gov.cn/#/Integrated/index)

- ![time](https://bbs.elecfans.com/template/elecfans_201508/images/time.png)[最新主题](https://bbs.elecfans.com/default.php?view=default)
- ![recommend](https://bbs.elecfans.com/template/elecfans_201508/images/zan.png)[推荐主题](https://bbs.elecfans.com/default.php?view=recommend)
- ![hot](https://bbs.elecfans.com/template/elecfans_201508/images/re.png)[热门主题](https://bbs.elecfans.com/default.php?view=hot)
- ![post](https://bbs.elecfans.com/template/elecfans_201508/images/me.png) [我的帖子](javascript:;)

- **-**[技术社区](https://bbs.elecfans.com/forum.php?gid=1411)

  [HarmonyOS技术社区](https://bbs.elecfans.com/harmonyos)  [RISC-V MCU技术社区](https://bbs.elecfans.com/riscvmcu)

- **-**[OpenHarmony开源社区](https://bbs.elecfans.com/forum.php?gid=1510)

  [OpenHarmony开源社区](https://bbs.elecfans.com/zhuti_1511_1.html)

- **-**[嵌入式论坛](https://bbs.elecfans.com/forum.php?gid=3)

  [ARM技术论坛](https://bbs.elecfans.com/zhuti_arm_1.html)  [STM32/STM8技术论坛](https://bbs.elecfans.com/zhuti_stm32_1.html)  [RT-Thread嵌入式技术论坛](https://bbs.elecfans.com/zhuti_emb_1.html)  [单片机/MCU论坛](https://bbs.elecfans.com/zhuti_mcu_1.html)  [RISC-V技术论坛](https://bbs.elecfans.com/zhuti_risc_1.html)  [瑞芯微Rockchip开发者社区](https://bbs.elecfans.com/zhuti_1179_1.html)  [FPGA|CPLD|ASIC论坛](https://bbs.elecfans.com/zhuti_fpga_1.html)  [DSP论坛](https://bbs.elecfans.com/zhuti_DSP_1.html)

- **-**[电路图及DIY](https://bbs.elecfans.com/forum.php?gid=48)

- **-**[电源技术论坛](https://bbs.elecfans.com/forum.php?gid=752)

- **-**[综合技术与应用](https://bbs.elecfans.com/forum.php?gid=345)

- **-**[无线通信论坛](https://bbs.elecfans.com/forum.php?gid=6)

- **-**[EDA设计论坛](https://bbs.elecfans.com/forum.php?gid=1)

- **-**[测试测量论坛](https://bbs.elecfans.com/forum.php?gid=32)

- **-**[招聘/交友/外包/交易/杂谈](https://bbs.elecfans.com/forum.php?gid=27)

- **-**[官方社区](https://bbs.elecfans.com/forum.php?gid=829)

![time](https://bbs.elecfans.com/template/elecfans_201508/images/time.png) ![recommend](https://bbs.elecfans.com/template/elecfans_201508/images/zan.png) ![hot](https://bbs.elecfans.com/template/elecfans_201508/images/re.png) ![post](https://bbs.elecfans.com/template/elecfans_201508/images/me.png)

—
—
—

版
块
导
航



展开

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.8370694374688609&amp;zoneid=1029&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109660_1_1.html" width="450" height="30" frameborder="0"></iframe>

*╳*

[![img](https://file.elecfans.com/web2/M00/7A/5B/poYBAGNx6JGAUvqIAACqaQrGZnQ426.png)](http://hqpcb.com/act/68cengban.html?fsydbtl)

[![电子技术论坛](https://bbs.elecfans.com/static/image/common/logo_new.png)](https://bbs.elecfans.com/)

- ​                            [首页](http://www.elecfans.com/)                                                    
- ​                            [论坛](https://bbs.elecfans.com/default.php)                                                                                                                                                
- ​                            [版块](https://bbs.elecfans.com/)                                                                                                                                                
- ​                            [小组](https://bbs.elecfans.com/group)                                                                                                                                                
- ​                            [活动](https://bbs.elecfans.com/zhuti_online_1.html)                                                                                                                                                
- ​                            [专栏](https://www.elecfans.com/d/)                                                                                                                                                
- ​                            [视频](https://www.elecfans.com/v/)                                                                                                                                                
- ​                            [问答](https://bbs.elecfans.com/ask/)                                                                                                                                                
- ​                            [下载](https://bbs.elecfans.com/soft/)                                                                                                                                                
- ​                            [学院](https://t.elecfans.com/)                                                                                                                                                
- ​                            [更多](javascript:;)                                                                                                                                                

|      |      |
| ---- | ---- |
|      |      |



​                                发 帖                             

- [登录/注册](javascript:;)

​                                                                                

- ![bread](https://bbs.elecfans.com/template/elecfans_201508/images/bread_img.png)[电子发烧友论坛](https://bbs.elecfans.com/forum.php)/

- ​        [EDA设计论坛](https://bbs.elecfans.com/forum.php?gid=1)/            

- ​        [KiCad EDA 中文论坛](https://bbs.elecfans.com/zhuti_kicad_1.html)                                

- /

  KiCAD教程（15），生成网络表盒、PCB边框设计及安装孔设 ...

#             KiCAD教程（15），生成网络表盒、PCB边框设计及安装孔设置        

[![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708/)[spark_zhang](https://bbs.elecfans.com/user/2164708/)

*2017-2-8 20:45:19**![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/wacth.png)*18923[PCB](https://www.elecfans.com/tags/PCB/)

​        

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.5365586953871687&amp;zoneid=223&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109661_1_1.html" scrolling="no" width="728" height="90" frameborder="0"></iframe>

| *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zhichi.png)*                                                                                         0                                                                                                                             ![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/favorite.png)                        3                                                                                                                                                                                                                                                         如果在上一讲中你的原理图检查已经没有错误了，并且所有[元件](https://bbs.elecfans.com/zhuti_yuanjian_1.html)的封装也都正确添加。那么恭喜你可以进入下一步：[PCB](https://bbs.elecfans.com/zhuti_pads_1.html)设计了。  首先还是打开我们之前设计好的原理图，在导入PCB之前，先要在原理图中生成**网络表。**如下图所示进行操作。  ![img](https://bbs.elecfans.com/data/attachment/forum/201702/08/204127sqdonv915fyngnoy.png)        点击完之后出现如下对话框。  ![img](https://bbs.elecfans.com/data/attachment/forum/201702/08/204127fmsfsvfkvvskif78.png)        选择**生成。**之后弹出保存目录，保存即可。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)          这样在原理图中就生成好了网络表。然后我们再回到软件主页面，选择**PCB****编辑器，**并打开**。**  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        接下来就是读取刚才保存的网络表格了。如下图所示，点击**读取网络表格**。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)        上图中红色圈出的就是刚才保存网络表格的路径。然后选择读**取当先网络表格**即可。如果出现错误，就会在信息栏里以红色字体提示。如果没有错误，点击关闭即可。然后所有的元件都已导入PCB中。如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        然后下一步就是画PCB的边框以及给PCB放置安装孔，元件的摆放以及布线了。这个以后会一步一步的讲。前面我们已将把所有原件都导入PCB了，这次就可以正式画PCB板了。首先打开软件，这个软件的PCB界面跟AD还有点不同，他的原点在红色外框的左上角。因此我们计算坐标的时候就以此为基准，这点大家一定要了解。然后再来讲怎么设计边框。首先我们要明确一点，我们设计的[开发板](https://bbs.elecfans.com/try.html)的大小是多少？有时我们会根据元件的摆放来自己定义板子的大小；但有时是板子边框是确定的，我们就不能随意发挥了！然后再回到我们的PCB图上，画PCB的边框是再[电路](https://bbs.elecfans.com/zhuti_dianlu_1.html)边界这个层，如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        首先是要选择好层，然后选择用那种线，看软件界面右边，有个虚线的选项，我们用的就是这个线。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        接下来就是画边框了，这里我们定义开发板的大小为138*108mm。大家可以根据端点的坐标计算长度。最后画完后是这样的。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        另外，一般都是将开发板的四个角改成弧形的。这里可以设计在四个角画四分之一个圆，改成弧形。我们可以放置一个半径为3mm的圆。这样先改变边框的长度上下都减小3mm.然后选择圆形圆弧。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        分别在四个角画半径为3的弧即可，画完后如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        边框画好后，还要在四个角放置安装孔，为了固定开发板，因此要打四个半径为3mm的孔。因为我们用的是3mm的螺钉，大家也可以将半径适当放大，这里我设置为3.3mm。安装孔怎么放呢？其实这需要我们在封装库里画。只需画一个半径为3.3mm的焊盘即可。如下图所示，  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        切记，这个是再PCB封装库里画的，画完后要导入PCB。名字我命名为kong.回到PCB图，点击添加封装。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        找到我们的库，然后选择刚才画的安装孔即可，分别在四个角放置。位置呢大家可以自己设置，我这里设置的是距离边框3.5mm。 |
| ------------------------------------------------------------ |
| [只看该作者](https://bbs.elecfans.com/forum.php?mod=viewthread&tid=1109661&page=1&authorid=2164708)                                                                                                                                                                [*![分享](https://bbs.elecfans.com/static/image/common/collection.png)淘帖*](https://bbs.elecfans.com/forum.php?mod=collection&action=edit&op=addthread&tid=1109661)                                                                                                    [举报](javascript:;)                                                                                                                                                                                                                                                                                                                                                                                                   相关推荐                                                                                                                                                                                                                                                                                                                                                                [                                                     • KiCad拼版神器KiKit的安装与使用                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         154*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2357856_1_1.html)                                                                                                                                                                                    [                                                     • KiCAD原理图、PCB中文帮助手册                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         110*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2357542_1_1.html)                                                                                                                                                                                    [                                                     • 自制一个数字转速表                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         844*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2302443_1_1.html)                                                                                                                                                                                    [                                                     • KiCad 安装                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         23878*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2273226_1_1.html)                                                                                                                                                                                    [                                                     • 基于Kicad制的PCB板                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/d_load.png)                                                         2*                                                                                                                                                               ](https://www.elecfans.com/soft/Mec/2022/202212271967114.html)                                                                                                                                                                                    [                                                     • kicad设计的fpga12层PCB原文件                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/d_load.png)                                                         7*                                                                                                                                                               ](https://www.elecfans.com/soft/22/163/2022/202209301900716.html)                                                                                                                                                                                    [                                                     • KiCad的基本使用                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         2103*                                                                                                                                                               ](https://www.elecfans.com/d/1907511.html)                                                                                                                                                                                    [                                                     • 浅谈PCB设计中散热孔的配置                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         17354*                                                                                                                                                               ](https://www.elecfans.com/article/80/2020/202004011195537.html)                                                                                                                                                                                    [                                                     • CAD软件中怎么设置设备表？CAD设置设备表教程                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         5968*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2068631_1_1.html)                                                                                                                                                                                    [                                                     • Altium Designer中怎么由网络表生成PCB                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         5392*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_1817376_1_1.html)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          *5* 条评论                                                                                                                        [只看该作者](https://bbs.elecfans.com/forum.php?mod=viewthread&tid=1109661&page=1&authorid=2164708) |

|      |
| ---- |
|      |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/25/55/64_avatar_middle.jpg)](https://bbs.elecfans.com/user/2255564/)                                                                            [吕钢格](https://bbs.elecfans.com/user/2255564/)                                        *2017-2-10 17:16:47*                                                                                                                                                                                                    [                                                                                                                                                                                                                                                   沙发                                                                                                                                                                                                                                        ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109661&pid=5461959)                                                                                                                                                                                    学习，学习 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/39/39/61_avatar_middle.jpg)](https://bbs.elecfans.com/user/2393961/)                                                                            [ai_niu](https://bbs.elecfans.com/user/2393961/)                                        *2017-2-10 23:37:50*                                                                                                                                                                                                    [                                                                                                                                                                                                                                                   板凳                                                                                                                                                                                                                                        ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109661&pid=5462470)                                                                                                                                                                                    学习了 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/36/93/25_avatar_middle.jpg)](https://bbs.elecfans.com/user/2369325/)                                                                            [奕凡321](https://bbs.elecfans.com/user/2369325/)                                        *2017-3-31 09:33:34*                                                                                                                                                                                                    [                                                                                                                                                                                           *3*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109661&pid=5570610)                                                                                                                                                                                    学习中！！！！![img](https://bbs.elecfans.com/static/image/smiley/fashaoyou/1.gif) |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/000/89/16/75_avatar_middle.jpg)](https://bbs.elecfans.com/user/891675/)                                                                            [zxlpcb](https://bbs.elecfans.com/user/891675/)                                        *2018-5-2 10:33:49*                                                                                                                                                                                                    [                                                                                                                                                                                           *4*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109661&pid=6749282)                                                                                                                                                                                    能自定义坐标原点就好了。。 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/003/64/67/41_avatar_middle.jpg)](https://bbs.elecfans.com/user/3646741/)                                                                            [张老三](https://bbs.elecfans.com/user/3646741/)                                        *2022-11-26 21:38:44*                                                                                                                                                                                                    [                                                                                                                                                                                           *5*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109661&pid=8825652)                                                                                                                                                                                    直接画孔不知道行不行 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

### 评论

[B](javascript:;) [Color](javascript:;)   [Link](javascript:;) [Quote](javascript:;) [Code](javascript:;) [Smilies](javascript:;)     您需要登录后才可以回帖 [登录/注册](javascript:;)



声明：本文内容及配图由入驻作者撰写或者入驻合作网站授权转载。文章观点仅代表作者本人，不代表电子发烧友网立场。文章及其配图仅供工程师学习之用，如有内容图片侵权或者其他问题，请联系本站作侵删。 [侵权投诉](https://www.elecfans.com/about/tousu.html)

​    

[                             发经验                         ](https://bbs.elecfans.com/forum.php?mod=post&action=newthread&fid=1339&special=7)

[![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708)

[spark_zhang](https://bbs.elecfans.com/user/2164708) 





技术员 

积分：167经验：101

- 主题

  ##### 22

- 文章

  ##### 0

- 粉丝

  ##### 43

+关注

发私信

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.7650596487272615&amp;zoneid=242&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109661_1_1.html" scrolling="no" width="300" height="250" frameborder="0"></iframe>

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.781094299767655&amp;zoneid=781&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109661_1_1.html" scrolling="no" width="300" height="125" frameborder="0"></iframe>

### 直播

[查看更多 >>](https://t.elecfans.com/live)

![img](https://file.elecfans.com/web2/M00/13/37/pYYBAGEwm8iACBfmAAEbdg3hPPo606.png)

《OpenHarmony“芯”进展》系列直播课——LoongArch专场

2023/4/4 18:55  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【OpenHarmony】2023开放原子校源行（北京站）

2023/4/2 09:24  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

OpenHarmony知识赋能No.28-OpenHarmony系统的驱动架构解析

2023/3/30 18:55  回顾

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座03期-T507-H 处理器音频接口的详细讲解

2023/5/25 19:00 报名中

![img](https://file.elecfans.com/web1/M00/CE/20/o4YBAF-iaBOAfClHAADS3eM3IVY279.jpg)

【创龙分享】国产工业嵌入式处理器架构解析

2023/5/25 19:00 报名中

![img](https://file.elecfans.com/web2/M00/01/14/pYYBAGDBfdOAAsnuAADpn0dJLuQ131.png)

OpenHarmony创新赛赛事宣讲会

2023/5/31 14:30 报名中

![img](https://file.elecfans.com/web2/M00/61/AB/pYYBAGL7hJaACg3NAAAX92fOR8889.jpeg)

开源硬件系列08期：片上网络的过去、现在和将来

2023/5/31 19:30 报名中

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座02期-NXP i.MX 9352处理器的I3C接口详解

2023/5/18 19:00  回顾

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座01期-基于rpmsg的多核异构产品双核通信应用实现

2023/5/11 19:00  回顾

![img](https://file.elecfans.com/web2/M00/72/74/pYYBAGNR9yCABb_lAAANs78gSRY396.jpg)

《RK3588 PCB设计指导白皮书》线上发布&实战解读

2023/5/11 13:50  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

开源芯片系列讲座第09期：RISC-V软硬件协同设计全流程软件栈

2023/5/10 15:00  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

OpenHarmony知识赋能No.29-DAYU200分布式应用开发

2023/5/4 19:00  回顾

![img](https://file.elecfans.com/web2/M00/61/AB/pYYBAGL7hJaACg3NAAAX92fOR8889.jpeg)

开源硬件系列07期：基于生成器方法学的CGRA(可重构计算)设计

2023/4/27 19:30  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【2023】OpenHarmony开发者大会：技术论坛

2023/4/19 14:00  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【2023】OpenHarmony开发者大会：主论坛

2023/4/19 09:35  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

RISC-V 开发平台 Milk-V Pioneer 发布会

2023/4/15 15:00  回顾

![img](https://file.elecfans.com/web2/M00/3F/EF/poYBAGJqh3-AFAm_AAGpPtG2eAM315.png)

国产EDA软件新星03期-Venus智能建库工具介绍

2023/4/13 19:00  回顾

![img](https://file.elecfans.com/web2/M00/43/F3/pYYBAGKCLNCAfe1iAAEAAYXz0ZQ341.png)

【新品发布】IFX新款开发板发布与上手培训

2023/4/12 15:00  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

【开源芯片系列讲座】RISC-V计算软件栈与高性能计算进展

2023/4/7 20:00  回顾

![img](https://file.elecfans.com/web2/M00/01/14/pYYBAGDBfdOAAsnuAADpn0dJLuQ131.png)

开放原子开源基金会“源聚一堂”开源技术沙龙

2023/4/7 09:00  回顾

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.0575306114895745&amp;zoneid=224&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109661_1_1.html" scrolling="no" width="300" height="600" frameborder="0"></iframe>

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.4721067284330427&amp;zoneid=678&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109661_1_1.html" scrolling="no" width="300" height="255" frameborder="0"></iframe>

​                    

广告![img](https://bbs.elecfans.com/static/image/ad/ad_close.png)[![img](https://file.elecfans.com/web2/M00/A6/D6/pYYBAGRnDtqAO7mSAAJXTJBhXM8305.jpg)](https://smt.hqchip.com/online.html?from=Pltdb)

[关闭](javascript:;)

##                  站长推荐                ![上一条](https://bbs.elecfans.com/static/image/common/pic_nv_prev.gif) *7/7* ![下一条](https://bbs.elecfans.com/static/image/common/pic_nv_next.gif)            

- [【免费领取】](https://url.elecfans.com/u/260fc9c6fe)        

  华秋电子将联合瑞芯微、凡亿重磅发布《RK3588 PCB设计指导白皮书》，免费下载！

[查看 »](https://url.elecfans.com/u/260fc9c6fe)

- 华秋（原“华强聚丰”）：

  电子发烧友

  华秋开发

  华秋电路(原"华强PCB")

  华秋商城(原"华强芯城")

  华秋智造



- 设计技术

  [可编程逻辑](https://www.elecfans.com/pld/)

  [电源/新能源](https://www.elecfans.com/article/83/)

  [MEMS/传感技术](https://www.elecfans.com/article/88/142/)

  [测量仪表](https://www.elecfans.com/article/85/)

  [嵌入式技术](https://www.elecfans.com/emb/)

  [制造/封装](https://www.elecfans.com/article/90/155/)

  [模拟技术](https://www.elecfans.com/analog/)

  [RF/无线](https://www.elecfans.com/tongxin/rf/)

  [接口/总线/驱动](https://www.elecfans.com/emb/jiekou/)

  [处理器/DSP](https://www.elecfans.com/emb/dsp/)

  [EDA/IC设计](https://www.elecfans.com/bandaoti/eda/)

  [存储技术](https://www.elecfans.com/consume/cunchujishu/)

  [光电显示](https://www.elecfans.com/xianshi/)

  [EMC/EMI设计](https://www.elecfans.com/emc_emi/)

  [连接器](https://www.elecfans.com/connector/)

- 行业应用

  [LEDs ](https://www.elecfans.com/led/)

  [汽车电子](https://www.elecfans.com/qichedianzi/)

  [音视频及家电](https://www.elecfans.com/video/)

  [通信网络](https://www.elecfans.com/tongxin/)

  [医疗电子](https://www.elecfans.com/yiliaodianzi/)

  [人工智能](https://www.elecfans.com/rengongzhineng/)

  [虚拟现实](https://www.elecfans.com/vr/)

  [可穿戴设备](https://www.elecfans.com/wearable/)

  [机器人](https://www.elecfans.com/jiqiren/)

  [安全设备/系统](https://www.elecfans.com/application/Security/)

  [军用/航空电子](https://www.elecfans.com/application/Military_avionics/)

  [移动通信](https://www.elecfans.com/application/Communication/)

  [工业控制](https://www.elecfans.com/kongzhijishu/)

  [便携设备](https://www.elecfans.com/consume/bianxiedianzishebei/)

  [触控感测](https://www.elecfans.com/consume/chukongjishu/)

  [物联网](https://www.elecfans.com/iot/)

  [智能电网](https://www.elecfans.com/dianyuan/diandongche_xinnenyuan/)

  [区块链](https://www.elecfans.com/blockchain/)

  [新科技](https://www.elecfans.com/xinkeji/)

- 特色内容

  [专栏推荐](https://www.elecfans.com/d/column/)

  [学院](https://t.elecfans.com/)

  [设计资源](https://bbs.elecfans.com/group_716)

  [设计技术](https://www.elecfans.com/technical/)

  [电子百科](https://www.elecfans.com/baike/)

  [电子视频](https://www.elecfans.com/dianzishipin/)

  [元器件知识](https://www.elecfans.com/yuanqijian/)

  [工具箱](https://www.elecfans.com/tools/)

  [VIP会员](https://www.elecfans.com/vip/#choose)

- 社区

  [小组](https://bbs.elecfans.com/group/)

  [论坛](https://bbs.elecfans.com/)

  [问答](https://bbs.elecfans.com/ask.html)

  [评测试用](https://bbs.elecfans.com/try.html)

- [企业服务](https://q.elecfans.com/)

  [产品](https://q.elecfans.com/p/)

  [资料](https://q.elecfans.com/soft/)

  [文章](https://q.elecfans.com/d/)

  [方案](https://q.elecfans.com/sol/)

  [企业](https://q.elecfans.com/c/)

- 供应链服务

  [硬件开发](https://www.elecfans.com/kf/)

  [华秋电路](https://www.hqpcb.com/)

  [华秋商城](https://www.hqchip.com/)

  [华秋智造](https://smt.hqchip.com/)

  [nextPCB](https://www.nextpcb.com/)

  [BOM配单](https://www.hqchip.com/bom.html)

- 媒体服务

  [网站广告](https://www.elecfans.com/help/service.html)

  [在线研讨会](https://webinar.elecfans.com/)

  [活动策划](https://event.elecfans.com/)

  [新闻发布](https://www.elecfans.com/news/)

  [新品发布](https://www.elecfans.com/xinpian/ic/)

  [小测验](https://www.elecfans.com/quiz/)

  [设计大赛](https://www.elecfans.com/contest/)

- 华秋

  [关于我们](https://www.elecfans.com/about/)

  [投资关系](https://www.hqchip.com/help/factsheet.html)

  [新闻动态](https://www.hqchip.com/help/news/lists.html)

  [加入我们](https://www.elecfans.com/about/zhaopin.html)

  [联系我们](https://www.elecfans.com/about/contact.html)

  [侵权投诉](https://bbs.elecfans.com/about/tousu.html)

- 社交网络

  [微博](https://weibo.com/elecfanscom)

- 移动端

  [发烧友APP](https://www.elecfans.com/app/)

  [硬声APP](https://yingsheng.elecfans.com/app?eleclog)

  [WAP](https://m.elecfans.com/)

- 联系我们

  广告合作

  王婉珠：[wangwanzhu@elecfans.com](mailto:wangwanzhu@elecfans.com)

  内容合作

  黄晶晶：[huangjingjing@elecfans.com](mailto:huangjingjing@elecfans.com)

  内容合作（海外）

  张迎辉：[mikezhang@elecfans.com](mailto:mikezhang@elecfans.com)

  供应链服务 PCB/IC/PCBA

  江良华：[lanhu@huaqiu.com](mailto:lanhu@huaqiu.com)

  投资合作

  曾海银：[zenghaiyin@huaqiu.com](mailto:zenghaiyin@huaqiu.com)

  社区合作

  刘勇：[liuyong@huaqiu.com](mailto:liuyong@huaqiu.com)

- 关注我们的微信

  

- 下载发烧友APP

  

- 电子发烧友观察

  

[               ![华秋电子](https://www.elecfans.com/static/footer/image/footer-01-default.png)                          ](https://www.huaqiu.com/)

​                      [                           ![华秋发烧友](https://www.elecfans.com/static/footer/image/footer-02-default.png)                                                  ](https://www.elecfans.com/)                  

​                      [                           ![华秋电路](https://www.elecfans.com/static/footer/image/footer-03-default.png)                                                  ](https://www.hqpcb.com/)                  

​                      [                           ![华秋商城](https://www.elecfans.com/static/footer/image/footer-04-default.png)                                                  ](https://www.hqchip.com/)                  

​                      [                           ![华秋智造](https://www.elecfans.com/static/footer/image/footer-05-default.png)                                                  ](https://smt.hqchip.com/)                  

​                      [                           ![NextPCB](https://www.elecfans.com/static/footer/image/footer-06-default.png)                                                  ](https://www.nextpcb.com/)                  

- [华秋简介](https://www.huaqiu.com/about/groupoverview)
- [企业动态](https://www.huaqiu.com/news)
- [联系我们](https://www.huaqiu.com/about/contactus)
- [企业文化](https://www.huaqiu.com/about/corporateculture)
- [企业宣传片](https://www.huaqiu.com/about/promotionalfilm)
- [加入我们](https://www.huaqiu.com/jobs)

版权所有 © 深圳华秋电子有限公司 

[电子发烧友](https://www.elecfans.com/)[**（电路图）**](https://www.elecfans.com/)[粤公网安备 44030402000349 号](https://www.beian.gov.cn/ode=440304portal/registerSystemInfo?recordc02000366)[电信与信息服务业务经营许可证：粤 B2-20160233](https://www.elecfans.com/about/edi.html)[           ![工商网监认证](https://skin.elecfans.com/images/ebsIcon.png)工商网监       ](http://szcert.ebs.org.cn/c6db625a-ba09-414a-bba4-f57240baac9c6)[粤ICP备 14022951 号](https://beian.miit.gov.cn/#/Integrated/index)

- ![time](https://bbs.elecfans.com/template/elecfans_201508/images/time.png)[最新主题](https://bbs.elecfans.com/default.php?view=default)
- ![recommend](https://bbs.elecfans.com/template/elecfans_201508/images/zan.png)[推荐主题](https://bbs.elecfans.com/default.php?view=recommend)
- ![hot](https://bbs.elecfans.com/template/elecfans_201508/images/re.png)[热门主题](https://bbs.elecfans.com/default.php?view=hot)
- ![post](https://bbs.elecfans.com/template/elecfans_201508/images/me.png) [我的帖子](javascript:;)

- **-**[技术社区](https://bbs.elecfans.com/forum.php?gid=1411)

  [HarmonyOS技术社区](https://bbs.elecfans.com/harmonyos)  [RISC-V MCU技术社区](https://bbs.elecfans.com/riscvmcu)

- **-**[OpenHarmony开源社区](https://bbs.elecfans.com/forum.php?gid=1510)

  [OpenHarmony开源社区](https://bbs.elecfans.com/zhuti_1511_1.html)

- **-**[嵌入式论坛](https://bbs.elecfans.com/forum.php?gid=3)

  [ARM技术论坛](https://bbs.elecfans.com/zhuti_arm_1.html)  [STM32/STM8技术论坛](https://bbs.elecfans.com/zhuti_stm32_1.html)  [RT-Thread嵌入式技术论坛](https://bbs.elecfans.com/zhuti_emb_1.html)  [单片机/MCU论坛](https://bbs.elecfans.com/zhuti_mcu_1.html)  [RISC-V技术论坛](https://bbs.elecfans.com/zhuti_risc_1.html)  [瑞芯微Rockchip开发者社区](https://bbs.elecfans.com/zhuti_1179_1.html)  [FPGA|CPLD|ASIC论坛](https://bbs.elecfans.com/zhuti_fpga_1.html)  [DSP论坛](https://bbs.elecfans.com/zhuti_DSP_1.html)

- **-**[电路图及DIY](https://bbs.elecfans.com/forum.php?gid=48)

- **-**[电源技术论坛](https://bbs.elecfans.com/forum.php?gid=752)

- **-**[综合技术与应用](https://bbs.elecfans.com/forum.php?gid=345)

- **-**[无线通信论坛](https://bbs.elecfans.com/forum.php?gid=6)

- **-**[EDA设计论坛](https://bbs.elecfans.com/forum.php?gid=1)

- **-**[测试测量论坛](https://bbs.elecfans.com/forum.php?gid=32)

- **-**[招聘/交友/外包/交易/杂谈](https://bbs.elecfans.com/forum.php?gid=27)

- **-**[官方社区](https://bbs.elecfans.com/forum.php?gid=829)

![time](https://bbs.elecfans.com/template/elecfans_201508/images/time.png) ![recommend](https://bbs.elecfans.com/template/elecfans_201508/images/zan.png) ![hot](https://bbs.elecfans.com/template/elecfans_201508/images/re.png) ![post](https://bbs.elecfans.com/template/elecfans_201508/images/me.png)

—
—
—

版
块
导
航



展开

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.48881091888115746&amp;zoneid=1029&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109661_1_1.html" width="450" height="30" frameborder="0"></iframe>

*╳*

[![img](https://file.elecfans.com/web2/M00/7A/5B/poYBAGNx6JGAUvqIAACqaQrGZnQ426.png)](http://hqpcb.com/act/68cengban.html?fsydbtl)

[![电子技术论坛](https://bbs.elecfans.com/static/image/common/logo_new.png)](https://bbs.elecfans.com/)

- ​                            [首页](http://www.elecfans.com/)                                                    
- ​                            [论坛](https://bbs.elecfans.com/default.php)                                                                                                                                                
- ​                            [版块](https://bbs.elecfans.com/)                                                                                                                                                
- ​                            [小组](https://bbs.elecfans.com/group)                                                                                                                                                
- ​                            [活动](https://bbs.elecfans.com/zhuti_online_1.html)                                                                                                                                                
- ​                            [专栏](https://www.elecfans.com/d/)                                                                                                                                                
- ​                            [视频](https://www.elecfans.com/v/)                                                                                                                                                
- ​                            [问答](https://bbs.elecfans.com/ask/)                                                                                                                                                
- ​                            [下载](https://bbs.elecfans.com/soft/)                                                                                                                                                
- ​                            [学院](https://t.elecfans.com/)                                                                                                                                                
- ​                            [更多](javascript:;)                                                                                                                                                

|      |      |
| ---- | ---- |
|      |      |



​                                发 帖                             

- [登录/注册](javascript:;)

​                                                                                

- ![bread](https://bbs.elecfans.com/template/elecfans_201508/images/bread_img.png)[电子发烧友论坛](https://bbs.elecfans.com/forum.php)/

- ​        [EDA设计论坛](https://bbs.elecfans.com/forum.php?gid=1)/            

- ​        [KiCad EDA 中文论坛](https://bbs.elecfans.com/zhuti_kicad_1.html)                                

- /

  KiCAD教程（16），单片机开发板PCB元件摆放及补充 ...

#             KiCAD教程（16），单片机开发板PCB元件摆放及补充        

[![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708/)[spark_zhang](https://bbs.elecfans.com/user/2164708/)

*2017-2-9 16:26:10**![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/wacth.png)*22209[单片机](https://www.elecfans.com/tags/单片机/)

​        

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.9167085004124755&amp;zoneid=223&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109802_1_1.html" scrolling="no" width="728" height="90" frameborder="0"></iframe>

| *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zhichi.png)*                                                                                         0                                                                                                                             ![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/favorite.png)                        4                                                                                                                                                                                                                                                         我们刚导入到[PCB](https://bbs.elecfans.com/zhuti_pads_1.html)原理图中的[元件](https://bbs.elecfans.com/zhuti_yuanjian_1.html)看起来很乱，需要我们一个一个找好摆放到PCB板上。  ![img](https://bbs.elecfans.com/data/attachment/forum/201702/09/162021xdnfnupgwylypl3u.png)        首先全选所有元件，把元件放到PCB边框的外边。然后根据画的原理图按模块找到并摆放到PCB边框中。    可以按快捷键Ctrl+F，然后输入你要找的元件名称。如下图所示。  ![img](https://bbs.elecfans.com/data/attachment/forum/201702/09/162022rd9o9j9j9cuvozd9.png)        然后回车就可以找到元件了。按这个方法把所有元件都摆放好，如下图所示。先放一个大概的位置，这里不用精确放置，因为我们在最后布线的时候还会要做一些微调。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        大家按我这样摆放就行。还有一点就是我们的[单片机](https://bbs.elecfans.com/zhuti_mcu_1.html)上边是要放液晶屏的，因此双排针的位置不要离单片机太近，不然液晶屏就放不下了。    在上图中也许大家会问，单片机是怎么倾斜45度放置的？这里做一个演示，双击单片机  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        在旋转里选择其他，然后输入3150.由于他的单位是0.1度，所以向右旋转45度就是3600-450=3150.这样，双排针的引线就好画了。之后的大家可以自己 摆放，回复“**PCB**”可以得到PCB的底板图，大家可以按照这个放置即可。首先我们要把双排针放整齐，这样开起来也美观。这里以液晶屏的插排为中心，使两侧双排针都隔着相同的距离，但是也不要离得太近。因为我们中间要放置液晶屏，2.8寸或3.2寸。下图为良种液晶屏的尺寸。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)        3.2吋                                          2.8吋只要大于液晶屏的宽度即可。  第二点就是给液晶屏放置安装孔，上面两个图上已经标好了两种屏幕的安装孔的位置尺寸。画完后如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        第三点就是液晶屏的引脚双排针的问题。我们液晶屏的第一个引脚的位置如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        但是我们[开发板](https://bbs.elecfans.com/try.html)上的第一个引脚的位置跟这个不一样，这就意味着如果我们不改动开发板，这个液晶屏就没办法使用，因此需要在原理图中进行改动。  右键点击开发板中的双排针，选择用封装编辑器打开，之后打开我们PCB库，然后重新画一个双排针，如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        把第一引脚放到上面。然后保存，选择更新当前封装到PCB。如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        这样就改好了。 |
| ------------------------------------------------------------ |
| [只看该作者](https://bbs.elecfans.com/forum.php?mod=viewthread&tid=1109802&page=1&authorid=2164708)                                                                                                                                                                [*![分享](https://bbs.elecfans.com/static/image/common/collection.png)淘帖*](https://bbs.elecfans.com/forum.php?mod=collection&action=edit&op=addthread&tid=1109802)                                                                                                    [举报](javascript:;)                                                                                                                                                                                                                                                                                                                                                                                                   相关推荐                                                                                                                                                                                                                                                                                                                                                                [                                                     • 请问图中单片机开发板上红圈中的那个元件是什么？                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         1604*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_1861127_1_1.html)                                                                                                                                                                                    [                                                     • 单片机开发板PCB                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         2937*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_1659420_1_1.html)                                                                                                                                                                                    [                                                     • 16套51单片机开发板资料共享下载，拼命整理                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         5387*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_1637303_1_1.html)                                                                                                                                                                                    [                                                     • 基于51单片机的开发板与PCB原理图                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         6254*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_1617851_1_1.html)                                                                                                                                                                                    [                                                     • 简单51单片机开发板的电路设计                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/d_load.png)                                                         86*                                                                                                                                                               ](https://www.elecfans.com/soft/33/2021/202107221667830.html)                                                                                                                                                                                    [                                                     • 51单片机开发板原理图下载                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/d_load.png)                                                         12*                                                                                                                                                               ](https://www.elecfans.com/soft/49/52/2021/202105201616844.html)                                                                                                                                                                                    [                                                     • 新手学习单片机如何选择开发板                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         7036*                                                                                                                                                               ](https://www.elecfans.com/d/1107738.html)                                                                                                                                                                                    [                                                     • 如何选择单片机开发板                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         16562*                                                                                                                                                               ](https://www.elecfans.com/d/1107708.html)                                                                                                                                                                                    [                                                     • MC Dev Board开发板案例文件(原理图+PCB+3D库) 新手练习必备                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         27726*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_1131144_1_1.html)                                                                                                                                                                                    [                                                     • KiCAD教程（17），单片机开发板引脚布线                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         21279*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_1109898_1_1.html)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          *7* 条评论                                                                                                                        [只看该作者](https://bbs.elecfans.com/forum.php?mod=viewthread&tid=1109802&page=1&authorid=2164708) |

|      |
| ---- |
|      |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/001/32/27/45_avatar_middle.jpg)](https://bbs.elecfans.com/user/1322745/)                                                                            [王栋春](https://bbs.elecfans.com/user/1322745/)                                        *2017-2-9 21:03:03*                                                                                                                                                                                                    [                                                                                                                                                                                                                                                   沙发                                                                                                                                                                                                                                        ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109802&pid=5460302)                                                                                                                                                                                    好资料呀  感谢楼主分享 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708/)                                                                            [spark_zhang](https://bbs.elecfans.com/user/2164708/)                                        *2017-2-10 13:26:04*                                                                                                                                                                                                    [                                                                                                                                                                                                                                                   板凳                                                                                                                                                                                                                                        ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109802&pid=5461304)                                                                                                                                                                                        [王栋春 发表于 2017-2-9 21:03](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&pid=5460302&ptid=1109802)  好资料呀  感谢楼主分享      多谢支持！！！ |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/001/32/27/45_avatar_middle.jpg)](https://bbs.elecfans.com/user/1322745/)                                                                            [王栋春](https://bbs.elecfans.com/user/1322745/)                                        *2017-2-10 20:07:34*                                                                                                                                                                                                    [                                                                                                                                                                                           *3*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109802&pid=5462175)                                                                                                                                                                                        [spark_zhang 发表于 2017-2-10 13:26](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&pid=5461304&ptid=1109802)  多谢支持！！！      不客气 期待更多资料分享 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/000/39/35/95_avatar_middle.jpg)](https://bbs.elecfans.com/user/393595/)                                                                            [海洋](https://bbs.elecfans.com/user/393595/)                                        *2017-2-14 09:10:49*                                                                                                                                                                                                    [                                                                                                                                                                                           *4*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109802&pid=5466763)                                                                                                                                                                                    多谢分享。。。。 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/36/93/25_avatar_middle.jpg)](https://bbs.elecfans.com/user/2369325/)                                                                            [奕凡321](https://bbs.elecfans.com/user/2369325/)                                        *2017-3-31 09:34:23*                                                                                                                                                                                                    [                                                                                                                                                                                           *5*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109802&pid=5570611)                                                                                                                                                                                    不错的帖子！！！！！ |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/003/32/70/25_avatar_middle.jpg)](https://bbs.elecfans.com/user/3327025/)                                                                            [陈向东](https://bbs.elecfans.com/user/3327025/)                                        *2022-1-2 13:52:45*                                                                                                                                                                                                    [                                                                                                                                                                                           *6*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109802&pid=8660243)                                                                                                                                                                                    PCB，很好的帖子，学习一下 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/003/93/46/81_avatar_middle.jpg)](https://bbs.elecfans.com/user/3934681/)                                                                            [Uther](https://bbs.elecfans.com/user/3934681/)                                        *2022-1-7 08:54:33*                                                                                                                                                                                                    [                                                                                                                                                                                           *7*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109802&pid=8665747)                                                                                                                                                                                    谢谢楼主分享!希望能继续！ |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

### 评论

[B](javascript:;) [Color](javascript:;)   [Link](javascript:;) [Quote](javascript:;) [Code](javascript:;) [Smilies](javascript:;)     您需要登录后才可以回帖 [登录/注册](javascript:;)



声明：本文内容及配图由入驻作者撰写或者入驻合作网站授权转载。文章观点仅代表作者本人，不代表电子发烧友网立场。文章及其配图仅供工程师学习之用，如有内容图片侵权或者其他问题，请联系本站作侵删。 [侵权投诉](https://www.elecfans.com/about/tousu.html)

​    

[                             发经验                         ](https://bbs.elecfans.com/forum.php?mod=post&action=newthread&fid=1339&special=7)

[![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708)

[spark_zhang](https://bbs.elecfans.com/user/2164708) 





技术员 

积分：167经验：101

- 主题

  ##### 22

- 文章

  ##### 0

- 粉丝

  ##### 43

+关注

发私信

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.7369033238871108&amp;zoneid=242&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109802_1_1.html" scrolling="no" width="300" height="250" frameborder="0"></iframe>

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.9947898692853118&amp;zoneid=781&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109802_1_1.html" scrolling="no" width="300" height="125" frameborder="0"></iframe>

### 直播

[查看更多 >>](https://t.elecfans.com/live)

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

OpenHarmony知识赋能No.28-OpenHarmony系统的驱动架构解析

2023/3/30 18:55  回顾

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座03期-T507-H 处理器音频接口的详细讲解

2023/5/25 19:00 报名中

![img](https://file.elecfans.com/web1/M00/CE/20/o4YBAF-iaBOAfClHAADS3eM3IVY279.jpg)

【创龙分享】国产工业嵌入式处理器架构解析

2023/5/25 19:00 报名中

![img](https://file.elecfans.com/web2/M00/01/14/pYYBAGDBfdOAAsnuAADpn0dJLuQ131.png)

OpenHarmony创新赛赛事宣讲会

2023/5/31 14:30 报名中

![img](https://file.elecfans.com/web2/M00/61/AB/pYYBAGL7hJaACg3NAAAX92fOR8889.jpeg)

开源硬件系列08期：片上网络的过去、现在和将来

2023/5/31 19:30 报名中

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座02期-NXP i.MX 9352处理器的I3C接口详解

2023/5/18 19:00  回顾

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座01期-基于rpmsg的多核异构产品双核通信应用实现

2023/5/11 19:00  回顾

![img](https://file.elecfans.com/web2/M00/72/74/pYYBAGNR9yCABb_lAAANs78gSRY396.jpg)

《RK3588 PCB设计指导白皮书》线上发布&实战解读

2023/5/11 13:50  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

开源芯片系列讲座第09期：RISC-V软硬件协同设计全流程软件栈

2023/5/10 15:00  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

OpenHarmony知识赋能No.29-DAYU200分布式应用开发

2023/5/4 19:00  回顾

![img](https://file.elecfans.com/web2/M00/61/AB/pYYBAGL7hJaACg3NAAAX92fOR8889.jpeg)

开源硬件系列07期：基于生成器方法学的CGRA(可重构计算)设计

2023/4/27 19:30  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【2023】OpenHarmony开发者大会：技术论坛

2023/4/19 14:00  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【2023】OpenHarmony开发者大会：主论坛

2023/4/19 09:35  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

RISC-V 开发平台 Milk-V Pioneer 发布会

2023/4/15 15:00  回顾

![img](https://file.elecfans.com/web2/M00/3F/EF/poYBAGJqh3-AFAm_AAGpPtG2eAM315.png)

国产EDA软件新星03期-Venus智能建库工具介绍

2023/4/13 19:00  回顾

![img](https://file.elecfans.com/web2/M00/43/F3/pYYBAGKCLNCAfe1iAAEAAYXz0ZQ341.png)

【新品发布】IFX新款开发板发布与上手培训

2023/4/12 15:00  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

【开源芯片系列讲座】RISC-V计算软件栈与高性能计算进展

2023/4/7 20:00  回顾

![img](https://file.elecfans.com/web2/M00/01/14/pYYBAGDBfdOAAsnuAADpn0dJLuQ131.png)

开放原子开源基金会“源聚一堂”开源技术沙龙

2023/4/7 09:00  回顾

![img](https://file.elecfans.com/web2/M00/13/37/pYYBAGEwm8iACBfmAAEbdg3hPPo606.png)

《OpenHarmony“芯”进展》系列直播课——LoongArch专场

2023/4/4 18:55  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【OpenHarmony】2023开放原子校源行（北京站）

2023/4/2 09:24  回顾

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.11251117893993079&amp;zoneid=224&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109802_1_1.html" scrolling="no" width="300" height="600" frameborder="0"></iframe>

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.7065451465286532&amp;zoneid=678&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109802_1_1.html" scrolling="no" width="300" height="255" frameborder="0"></iframe>

​                    

广告![img](https://bbs.elecfans.com/static/image/ad/ad_close.png)[![img](https://file.elecfans.com/web2/M00/A6/D6/pYYBAGRnDtqAO7mSAAJXTJBhXM8305.jpg)](https://smt.hqchip.com/online.html?from=Pltdb)

[关闭](javascript:;)

##                  站长推荐                ![上一条](https://bbs.elecfans.com/static/image/common/pic_nv_prev.gif) *2/7* ![下一条](https://bbs.elecfans.com/static/image/common/pic_nv_next.gif)            

- [【电子工程师软件设计全集】](https://www.elecfans.com/topic/hotsoft/)        

  汇聚了电子工程师常用设计软件，欢迎下载

[查看 »](https://www.elecfans.com/topic/hotsoft/)

- 华秋（原“华强聚丰”）：

  电子发烧友

  华秋开发

  华秋电路(原"华强PCB")

  华秋商城(原"华强芯城")

  华秋智造



- 设计技术

  [可编程逻辑](https://www.elecfans.com/pld/)

  [电源/新能源](https://www.elecfans.com/article/83/)

  [MEMS/传感技术](https://www.elecfans.com/article/88/142/)

  [测量仪表](https://www.elecfans.com/article/85/)

  [嵌入式技术](https://www.elecfans.com/emb/)

  [制造/封装](https://www.elecfans.com/article/90/155/)

  [模拟技术](https://www.elecfans.com/analog/)

  [RF/无线](https://www.elecfans.com/tongxin/rf/)

  [接口/总线/驱动](https://www.elecfans.com/emb/jiekou/)

  [处理器/DSP](https://www.elecfans.com/emb/dsp/)

  [EDA/IC设计](https://www.elecfans.com/bandaoti/eda/)

  [存储技术](https://www.elecfans.com/consume/cunchujishu/)

  [光电显示](https://www.elecfans.com/xianshi/)

  [EMC/EMI设计](https://www.elecfans.com/emc_emi/)

  [连接器](https://www.elecfans.com/connector/)

- 行业应用

  [LEDs ](https://www.elecfans.com/led/)

  [汽车电子](https://www.elecfans.com/qichedianzi/)

  [音视频及家电](https://www.elecfans.com/video/)

  [通信网络](https://www.elecfans.com/tongxin/)

  [医疗电子](https://www.elecfans.com/yiliaodianzi/)

  [人工智能](https://www.elecfans.com/rengongzhineng/)

  [虚拟现实](https://www.elecfans.com/vr/)

  [可穿戴设备](https://www.elecfans.com/wearable/)

  [机器人](https://www.elecfans.com/jiqiren/)

  [安全设备/系统](https://www.elecfans.com/application/Security/)

  [军用/航空电子](https://www.elecfans.com/application/Military_avionics/)

  [移动通信](https://www.elecfans.com/application/Communication/)

  [工业控制](https://www.elecfans.com/kongzhijishu/)

  [便携设备](https://www.elecfans.com/consume/bianxiedianzishebei/)

  [触控感测](https://www.elecfans.com/consume/chukongjishu/)

  [物联网](https://www.elecfans.com/iot/)

  [智能电网](https://www.elecfans.com/dianyuan/diandongche_xinnenyuan/)

  [区块链](https://www.elecfans.com/blockchain/)

  [新科技](https://www.elecfans.com/xinkeji/)

- 特色内容

  [专栏推荐](https://www.elecfans.com/d/column/)

  [学院](https://t.elecfans.com/)

  [设计资源](https://bbs.elecfans.com/group_716)

  [设计技术](https://www.elecfans.com/technical/)

  [电子百科](https://www.elecfans.com/baike/)

  [电子视频](https://www.elecfans.com/dianzishipin/)

  [元器件知识](https://www.elecfans.com/yuanqijian/)

  [工具箱](https://www.elecfans.com/tools/)

  [VIP会员](https://www.elecfans.com/vip/#choose)

- 社区

  [小组](https://bbs.elecfans.com/group/)

  [论坛](https://bbs.elecfans.com/)

  [问答](https://bbs.elecfans.com/ask.html)

  [评测试用](https://bbs.elecfans.com/try.html)

- [企业服务](https://q.elecfans.com/)

  [产品](https://q.elecfans.com/p/)

  [资料](https://q.elecfans.com/soft/)

  [文章](https://q.elecfans.com/d/)

  [方案](https://q.elecfans.com/sol/)

  [企业](https://q.elecfans.com/c/)

- 供应链服务

  [硬件开发](https://www.elecfans.com/kf/)

  [华秋电路](https://www.hqpcb.com/)

  [华秋商城](https://www.hqchip.com/)

  [华秋智造](https://smt.hqchip.com/)

  [nextPCB](https://www.nextpcb.com/)

  [BOM配单](https://www.hqchip.com/bom.html)

- 媒体服务

  [网站广告](https://www.elecfans.com/help/service.html)

  [在线研讨会](https://webinar.elecfans.com/)

  [活动策划](https://event.elecfans.com/)

  [新闻发布](https://www.elecfans.com/news/)

  [新品发布](https://www.elecfans.com/xinpian/ic/)

  [小测验](https://www.elecfans.com/quiz/)

  [设计大赛](https://www.elecfans.com/contest/)

- 华秋

  [关于我们](https://www.elecfans.com/about/)

  [投资关系](https://www.hqchip.com/help/factsheet.html)

  [新闻动态](https://www.hqchip.com/help/news/lists.html)

  [加入我们](https://www.elecfans.com/about/zhaopin.html)

  [联系我们](https://www.elecfans.com/about/contact.html)

  [侵权投诉](https://bbs.elecfans.com/about/tousu.html)

- 社交网络

  [微博](https://weibo.com/elecfanscom)

- 移动端

  [发烧友APP](https://www.elecfans.com/app/)

  [硬声APP](https://yingsheng.elecfans.com/app?eleclog)

  [WAP](https://m.elecfans.com/)

- 联系我们

  广告合作

  王婉珠：[wangwanzhu@elecfans.com](mailto:wangwanzhu@elecfans.com)

  内容合作

  黄晶晶：[huangjingjing@elecfans.com](mailto:huangjingjing@elecfans.com)

  内容合作（海外）

  张迎辉：[mikezhang@elecfans.com](mailto:mikezhang@elecfans.com)

  供应链服务 PCB/IC/PCBA

  江良华：[lanhu@huaqiu.com](mailto:lanhu@huaqiu.com)

  投资合作

  曾海银：[zenghaiyin@huaqiu.com](mailto:zenghaiyin@huaqiu.com)

  社区合作

  刘勇：[liuyong@huaqiu.com](mailto:liuyong@huaqiu.com)

- 关注我们的微信

  

- 下载发烧友APP

  

- 电子发烧友观察

  

[               ![华秋电子](https://www.elecfans.com/static/footer/image/footer-01-default.png)                          ](https://www.huaqiu.com/)

​                      [                           ![华秋发烧友](https://www.elecfans.com/static/footer/image/footer-02-default.png)                                                  ](https://www.elecfans.com/)                  

​                      [                           ![华秋电路](https://www.elecfans.com/static/footer/image/footer-03-default.png)                                                  ](https://www.hqpcb.com/)                  

​                      [                           ![华秋商城](https://www.elecfans.com/static/footer/image/footer-04-default.png)                                                  ](https://www.hqchip.com/)                  

​                      [                           ![华秋智造](https://www.elecfans.com/static/footer/image/footer-05-default.png)                                                  ](https://smt.hqchip.com/)                  

​                      [                           ![NextPCB](https://www.elecfans.com/static/footer/image/footer-06-default.png)                                                  ](https://www.nextpcb.com/)                  

- [华秋简介](https://www.huaqiu.com/about/groupoverview)
- [企业动态](https://www.huaqiu.com/news)
- [联系我们](https://www.huaqiu.com/about/contactus)
- [企业文化](https://www.huaqiu.com/about/corporateculture)
- [企业宣传片](https://www.huaqiu.com/about/promotionalfilm)
- [加入我们](https://www.huaqiu.com/jobs)

版权所有 © 深圳华秋电子有限公司 

[电子发烧友](https://www.elecfans.com/)[**（电路图）**](https://www.elecfans.com/)[粤公网安备 44030402000349 号](https://www.beian.gov.cn/ode=440304portal/registerSystemInfo?recordc02000366)[电信与信息服务业务经营许可证：粤 B2-20160233](https://www.elecfans.com/about/edi.html)[           ![工商网监认证](https://skin.elecfans.com/images/ebsIcon.png)工商网监       ](http://szcert.ebs.org.cn/c6db625a-ba09-414a-bba4-f57240baac9c6)[粤ICP备 14022951 号](https://beian.miit.gov.cn/#/Integrated/index)

- ![time](https://bbs.elecfans.com/template/elecfans_201508/images/time.png)[最新主题](https://bbs.elecfans.com/default.php?view=default)
- ![recommend](https://bbs.elecfans.com/template/elecfans_201508/images/zan.png)[推荐主题](https://bbs.elecfans.com/default.php?view=recommend)
- ![hot](https://bbs.elecfans.com/template/elecfans_201508/images/re.png)[热门主题](https://bbs.elecfans.com/default.php?view=hot)
- ![post](https://bbs.elecfans.com/template/elecfans_201508/images/me.png) [我的帖子](javascript:;)

- **-**[技术社区](https://bbs.elecfans.com/forum.php?gid=1411)

  [HarmonyOS技术社区](https://bbs.elecfans.com/harmonyos)  [RISC-V MCU技术社区](https://bbs.elecfans.com/riscvmcu)

- **-**[OpenHarmony开源社区](https://bbs.elecfans.com/forum.php?gid=1510)

  [OpenHarmony开源社区](https://bbs.elecfans.com/zhuti_1511_1.html)

- **-**[嵌入式论坛](https://bbs.elecfans.com/forum.php?gid=3)

  [ARM技术论坛](https://bbs.elecfans.com/zhuti_arm_1.html)  [STM32/STM8技术论坛](https://bbs.elecfans.com/zhuti_stm32_1.html)  [RT-Thread嵌入式技术论坛](https://bbs.elecfans.com/zhuti_emb_1.html)  [单片机/MCU论坛](https://bbs.elecfans.com/zhuti_mcu_1.html)  [RISC-V技术论坛](https://bbs.elecfans.com/zhuti_risc_1.html)  [瑞芯微Rockchip开发者社区](https://bbs.elecfans.com/zhuti_1179_1.html)  [FPGA|CPLD|ASIC论坛](https://bbs.elecfans.com/zhuti_fpga_1.html)  [DSP论坛](https://bbs.elecfans.com/zhuti_DSP_1.html)

- **-**[电路图及DIY](https://bbs.elecfans.com/forum.php?gid=48)

- **-**[电源技术论坛](https://bbs.elecfans.com/forum.php?gid=752)

- **-**[综合技术与应用](https://bbs.elecfans.com/forum.php?gid=345)

- **-**[无线通信论坛](https://bbs.elecfans.com/forum.php?gid=6)

- **-**[EDA设计论坛](https://bbs.elecfans.com/forum.php?gid=1)

- **-**[测试测量论坛](https://bbs.elecfans.com/forum.php?gid=32)

- **-**[招聘/交友/外包/交易/杂谈](https://bbs.elecfans.com/forum.php?gid=27)

- **-**[官方社区](https://bbs.elecfans.com/forum.php?gid=829)

![time](https://bbs.elecfans.com/template/elecfans_201508/images/time.png) ![recommend](https://bbs.elecfans.com/template/elecfans_201508/images/zan.png) ![hot](https://bbs.elecfans.com/template/elecfans_201508/images/re.png) ![post](https://bbs.elecfans.com/template/elecfans_201508/images/me.png)

—
—
—

版
块
导
航



展开

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.8115419284513637&amp;zoneid=1029&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109802_1_1.html" width="450" height="30" frameborder="0"></iframe>

*╳*

[![img](https://file.elecfans.com/web2/M00/7A/5B/poYBAGNx6JGAUvqIAACqaQrGZnQ426.png)](http://hqpcb.com/act/68cengban.html?fsydbtl)

[![电子技术论坛](https://bbs.elecfans.com/static/image/common/logo_new.png)](https://bbs.elecfans.com/)

- ​                            [首页](http://www.elecfans.com/)                                                    
- ​                            [论坛](https://bbs.elecfans.com/default.php)                                                                                                                                                
- ​                            [版块](https://bbs.elecfans.com/)                                                                                                                                                
- ​                            [小组](https://bbs.elecfans.com/group)                                                                                                                                                
- ​                            [活动](https://bbs.elecfans.com/zhuti_online_1.html)                                                                                                                                                
- ​                            [专栏](https://www.elecfans.com/d/)                                                                                                                                                
- ​                            [视频](https://www.elecfans.com/v/)                                                                                                                                                
- ​                            [问答](https://bbs.elecfans.com/ask/)                                                                                                                                                
- ​                            [下载](https://bbs.elecfans.com/soft/)                                                                                                                                                
- ​                            [学院](https://t.elecfans.com/)                                                                                                                                                
- ​                            [更多](javascript:;)                                                                                                                                                

|      |      |
| ---- | ---- |
|      |      |



​                                发 帖                             

- [登录/注册](javascript:;)

​                                                                                

- ![bread](https://bbs.elecfans.com/template/elecfans_201508/images/bread_img.png)[电子发烧友论坛](https://bbs.elecfans.com/forum.php)/

- ​        [EDA设计论坛](https://bbs.elecfans.com/forum.php?gid=1)/            

- ​        [KiCad EDA 中文论坛](https://bbs.elecfans.com/zhuti_kicad_1.html)                                

- /

  KiCAD教程（17），单片机开发板引脚布线

#             KiCAD教程（17），单片机开发板引脚布线        

[![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708/)[spark_zhang](https://bbs.elecfans.com/user/2164708/)

*2017-2-10 13:33:16**![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/wacth.png)*21279[单片机](https://www.elecfans.com/tags/单片机/)

​        

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.2220674028146683&amp;zoneid=223&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109898_1_1.html" scrolling="no" width="728" height="90" frameborder="0"></iframe>

| *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zhichi.png)*                                                                                         0                                                                                                                             ![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/favorite.png)                        4                                                                                                                                                                                                                                                         前面已经将整个[PCB](https://bbs.elecfans.com/zhuti_pads_1.html)中的[元件](https://bbs.elecfans.com/zhuti_yuanjian_1.html)位置摆放好了。从现在开始正式布线了。我们[开发板](https://bbs.elecfans.com/try.html)[单片机](https://bbs.elecfans.com/zhuti_mcu_1.html)的引脚既与双排针接口连接，也与开发板中的模块相连，因此我们布线的基本思路是先把单片机引脚的线接到双排针上，然后从双排针引出线接到各个模块。这一节里我就先说说单片机与双排针的接线。  [电路](https://bbs.elecfans.com/zhuti_dianlu_1.html)板可以分成单层板、双层板、四层板。。。。（都是双数），我们这个KICAD最多可以画32层的板子。对于单层板，只有顶层一层布线，对于双层板分为顶层和底层，两层布线。双层板以后的多层板的层都是介于顶层和底层之间进行布线。这里我们画的单片机开发板使用的是双层设计。也就是分为顶层和底层进行布线。进行布线的层在这个软件中被翻译为顶层铜层和底层铜层。然后我们看到的元件的标号是印在丝印层上的，这里要首先明白，对于详细的层的概念大家可以自行百度。在这一节主要就说说顶层、底层和丝印层。丝印层刚才也说了，是元件标号和放置文字用的，在画元件的封装时如果是贴片元件，那么焊盘就是放在顶层，元件标号就在顶层丝印层。同样这话PCB板是，我们走的铜线也是顶层（或底层）。因此在走线之前先要选对层。  ![img](https://bbs.elecfans.com/data/attachment/forum/201702/10/133207n0p9mmk1grnmjnkc.png)        上图中从上到下的三个箭头依次指的是顶层，底层和丝印层。只需要鼠标在对应层前面点一下即切换到相应层。用方框框起的是布线选项。选择这一项才能在PCB中画线。    然后设置设计规则，如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)         ![img](https://bbs.elecfans.com/static/image/common/none.gif)        对于线宽我们添加三种线宽，分别是0.3mm、0.5mm、1mm。在第一项设置中设置的默认线宽为0.25.这里不同的线宽用于画不同类型的走线。最宽的1mm我们是用来画[电源](https://bbs.elecfans.com/zhuti_power_1.html)的走线的。这个之后会讲到。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        上图中可以方便的选择前面设置的不同线宽。我们首先选择默认的0.25mm.然后把单片机分为左右两侧，分别从两侧的中间开始布线。这样布线便于如果修改，如果从两边开始布线，若中间的线走不了了，还要删掉两侧的线重新布。     具体布线方法就是选择布线选项后点击单片机的一个引脚，然后拖动鼠标会引出一根红线，同时这个引脚对应的双排针引脚会高亮显示，然后拖到对应引脚即可。再点一下鼠标左键就放置成功了。这里需要大家多练习才能掌握技巧方法。如下图所示是我布线后的结果，当然大家可以自己画的更美观一些。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        最后可以教大家一个布线小技巧，我们拖动走线改变方向后会出现一个折线，如果这个折线是你的理想路径，你可以点击一下鼠标左键，则这个折线之前的线就被固定了。然后可以拖着线继续走。 |
| ------------------------------------------------------------ |
| [只看该作者](https://bbs.elecfans.com/forum.php?mod=viewthread&tid=1109898&page=1&authorid=2164708)                                                                                                                                                                [*![分享](https://bbs.elecfans.com/static/image/common/collection.png)淘帖*](https://bbs.elecfans.com/forum.php?mod=collection&action=edit&op=addthread&tid=1109898)                                                                                                    [举报](javascript:;)                                                                                                                                                                                                                                                                                                                                                                                                   相关推荐                                                                                                                                                                                                                                                                                                                                                                [                                                     • 单片机开发板如何实现接地                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         3669*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2210246_1_1.html)                                                                                                                                                                                    [                                                     • 单片机自学需要买开发板嘛                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         1069*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2200664_1_1.html)                                                                                                                                                                                    [                                                     • 怎么使用STC单片机开发板？                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         1036*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2169057_1_1.html)                                                                                                                                                                                    [                                                     • 如何去选择单片机开发板                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         493*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2123374_1_1.html)                                                                                                                                                                                    [                                                     • 单片机开发板引脚图                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/d_load.png)                                                         26*                                                                                                                                                               ](https://www.elecfans.com/soft/33/2021/202111131735530.html)                                                                                                                                                                                    [                                                     • 简单51单片机开发板的电路设计                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/d_load.png)                                                         86*                                                                                                                                                               ](https://www.elecfans.com/soft/33/2021/202107221667830.html)                                                                                                                                                                                    [                                                     • 新手学习单片机如何选择开发板                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         7036*                                                                                                                                                               ](https://www.elecfans.com/d/1107738.html)                                                                                                                                                                                    [                                                     • 如何选择单片机开发板                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         16562*                                                                                                                                                               ](https://www.elecfans.com/d/1107708.html)                                                                                                                                                                                    [                                                     • 单片机开发板引脚图 精选资料分享                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         723*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_2120380_1_1.html)                                                                                                                                                                                    [                                                     • KiCAD教程（20），单片机开发板其他模块布线                                                                                                                                                                      *![img](https://bbs.elecfans.com/template/elecfans_201805/images/u59.png)                                                         12960*                                                                                                                                                               ](https://bbs.elecfans.com/jishu_1110047_1_1.html)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          *9* 条评论                                                                                                                        [只看该作者](https://bbs.elecfans.com/forum.php?mod=viewthread&tid=1109898&page=1&authorid=2164708) |

|      |
| ---- |
|      |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/000/14/75/93_avatar_middle.jpg)](https://bbs.elecfans.com/user/147593/)                                                                            [houjue](https://bbs.elecfans.com/user/147593/)                                        *2017-2-10 23:46:28*                                                                                                                                                                                                    [                                                                                                                                                                                                                                                   沙发                                                                                                                                                                                                                                        ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109898&pid=5462478)                                                                                                                                                                                    不错的教程，正在学习中。谢谢楼主的分享与心得！ |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/39/41/46_avatar_middle.jpg)](https://bbs.elecfans.com/user/2394146/)                                                                            [李福庆](https://bbs.elecfans.com/user/2394146/)                                        *2017-2-11 09:16:37*                                                                                                                                                                                                    [                                                                                                                                                                                                                                                   板凳                                                                                                                                                                                                                                        ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109898&pid=5462559)                                                                                                                                                                                    赞 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708/)                                                                            [spark_zhang](https://bbs.elecfans.com/user/2164708/)                                        *2017-2-11 13:12:12*                                                                                                                                                                                                    [                                                                                                                                                                                           *3*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109898&pid=5462887)                                                                                                                                                                                        [houjue 发表于 2017-2-10 23:46](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&pid=5462478&ptid=1109898)  不错的教程，正在学习中。谢谢楼主的分享与心得！      多谢支持！！！ |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/000/39/35/95_avatar_middle.jpg)](https://bbs.elecfans.com/user/393595/)                                                                            [海洋](https://bbs.elecfans.com/user/393595/)                                        *2017-2-14 08:59:39*                                                                                                                                                                                                    [                                                                                                                                                                                           *4*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109898&pid=5466749)                                                                                                                                                                                    漂亮，多谢分享，期待大作。。。 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/07/83/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2078308/)                                                                            [UniqueMouse](https://bbs.elecfans.com/user/2078308/)                                        *2017-3-9 11:27:56*                                                                                                                                                                                                    [                                                                                                                                                                                           *5*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109898&pid=5517683)                                                                                                                                                                                    最近正在尝试用kicad，学习了。 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/36/93/25_avatar_middle.jpg)](https://bbs.elecfans.com/user/2369325/)                                                                            [奕凡321](https://bbs.elecfans.com/user/2369325/)                                        *2017-3-31 09:35:12*                                                                                                                                                                                                    [                                                                                                                                                                                           *6*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109898&pid=5570615)                                                                                                                                                                                    果断收藏了！！！多谢楼主分享！！ |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/003/62/79/19_avatar_middle.jpg)](https://bbs.elecfans.com/user/3627919/)                                                                            [张青](https://bbs.elecfans.com/user/3627919/)                                        *2020-1-23 09:06:52*                                                                                                                                                                                                    [                                                                                                                                                                                           *7*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109898&pid=7979632)                                                                                                                                                                                    不错不错，用起来很简单 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/003/65/65/63_avatar_middle.jpg)](https://bbs.elecfans.com/user/3656563/)                                                                            [xudaweb](https://bbs.elecfans.com/user/3656563/)                                        *2020-5-27 09:50:51*                                                                                                                                                                                                    [                                                                                                                                                                                           *8*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109898&pid=8122388)                                                                                                                                                                                    看看是什么好东西 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/004/01/23/91_avatar_middle.jpg)](https://bbs.elecfans.com/user/4012391/)                                                                            [aguanguan](https://bbs.elecfans.com/user/4012391/)                                        *2020-10-16 13:51:05*                                                                                                                                                                                                    [                                                                                                                                                                                           *9*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1109898&pid=8259566)                                                                                                                                                                                    谢谢楼主 我很需要 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

### 评论

[B](javascript:;) [Color](javascript:;)   [Link](javascript:;) [Quote](javascript:;) [Code](javascript:;) [Smilies](javascript:;)     您需要登录后才可以回帖 [登录/注册](javascript:;)



声明：本文内容及配图由入驻作者撰写或者入驻合作网站授权转载。文章观点仅代表作者本人，不代表电子发烧友网立场。文章及其配图仅供工程师学习之用，如有内容图片侵权或者其他问题，请联系本站作侵删。 [侵权投诉](https://www.elecfans.com/about/tousu.html)

​    

[                             发经验                         ](https://bbs.elecfans.com/forum.php?mod=post&action=newthread&fid=1339&special=7)

[![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708)

[spark_zhang](https://bbs.elecfans.com/user/2164708) 





技术员 

积分：167经验：101

- 主题

  ##### 22

- 文章

  ##### 0

- 粉丝

  ##### 43

+关注

发私信

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.631691800699121&amp;zoneid=242&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109898_1_1.html" scrolling="no" width="300" height="250" frameborder="0"></iframe>

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.260526958605113&amp;zoneid=781&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109898_1_1.html" scrolling="no" width="300" height="125" frameborder="0"></iframe>

### 直播

[查看更多 >>](https://t.elecfans.com/live)

![img](https://file.elecfans.com/web1/M00/CE/20/o4YBAF-iaBOAfClHAADS3eM3IVY279.jpg)

【创龙分享】国产工业嵌入式处理器架构解析

2023/5/25 19:00 报名中

![img](https://file.elecfans.com/web2/M00/01/14/pYYBAGDBfdOAAsnuAADpn0dJLuQ131.png)

OpenHarmony创新赛赛事宣讲会

2023/5/31 14:30 报名中

![img](https://file.elecfans.com/web2/M00/61/AB/pYYBAGL7hJaACg3NAAAX92fOR8889.jpeg)

开源硬件系列08期：片上网络的过去、现在和将来

2023/5/31 19:30 报名中

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座02期-NXP i.MX 9352处理器的I3C接口详解

2023/5/18 19:00  回顾

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座01期-基于rpmsg的多核异构产品双核通信应用实现

2023/5/11 19:00  回顾

![img](https://file.elecfans.com/web2/M00/72/74/pYYBAGNR9yCABb_lAAANs78gSRY396.jpg)

《RK3588 PCB设计指导白皮书》线上发布&实战解读

2023/5/11 13:50  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

开源芯片系列讲座第09期：RISC-V软硬件协同设计全流程软件栈

2023/5/10 15:00  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

OpenHarmony知识赋能No.29-DAYU200分布式应用开发

2023/5/4 19:00  回顾

![img](https://file.elecfans.com/web2/M00/61/AB/pYYBAGL7hJaACg3NAAAX92fOR8889.jpeg)

开源硬件系列07期：基于生成器方法学的CGRA(可重构计算)设计

2023/4/27 19:30  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【2023】OpenHarmony开发者大会：技术论坛

2023/4/19 14:00  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【2023】OpenHarmony开发者大会：主论坛

2023/4/19 09:35  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

RISC-V 开发平台 Milk-V Pioneer 发布会

2023/4/15 15:00  回顾

![img](https://file.elecfans.com/web2/M00/3F/EF/poYBAGJqh3-AFAm_AAGpPtG2eAM315.png)

国产EDA软件新星03期-Venus智能建库工具介绍

2023/4/13 19:00  回顾

![img](https://file.elecfans.com/web2/M00/43/F3/pYYBAGKCLNCAfe1iAAEAAYXz0ZQ341.png)

【新品发布】IFX新款开发板发布与上手培训

2023/4/12 15:00  回顾

![img](https://file.elecfans.com/web2/M00/4F/CB/pYYBAGLEKpKAY8rkAAA0fDAXrKc188.jpg)

【开源芯片系列讲座】RISC-V计算软件栈与高性能计算进展

2023/4/7 20:00  回顾

![img](https://file.elecfans.com/web2/M00/01/14/pYYBAGDBfdOAAsnuAADpn0dJLuQ131.png)

开放原子开源基金会“源聚一堂”开源技术沙龙

2023/4/7 09:00  回顾

![img](https://file.elecfans.com/web2/M00/13/37/pYYBAGEwm8iACBfmAAEbdg3hPPo606.png)

《OpenHarmony“芯”进展》系列直播课——LoongArch专场

2023/4/4 18:55  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

【OpenHarmony】2023开放原子校源行（北京站）

2023/4/2 09:24  回顾

![img](https://file.elecfans.com/web2/M00/26/E9/poYBAGHAQeWAIv95AAASKst1sLs673.png)

OpenHarmony知识赋能No.28-OpenHarmony系统的驱动架构解析

2023/3/30 18:55  回顾

![img](https://file.elecfans.com/web1/M00/CE/37/pIYBAF-f86KANS-nAAA5zepTPW0214.png)

飞凌嵌入式系列讲座03期-T507-H 处理器音频接口的详细讲解

2023/5/25 19:00 报名中

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.7629459706474665&amp;zoneid=224&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109898_1_1.html" scrolling="no" width="300" height="600" frameborder="0"></iframe>

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.2845032392399316&amp;zoneid=678&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109898_1_1.html" scrolling="no" width="300" height="255" frameborder="0"></iframe>

​                    

广告![img](https://bbs.elecfans.com/static/image/ad/ad_close.png)[![img](https://file.elecfans.com/web2/M00/A6/D6/pYYBAGRnDtqAO7mSAAJXTJBhXM8305.jpg)](https://smt.hqchip.com/online.html?from=Pltdb)

[关闭](javascript:;)

##                  站长推荐                ![上一条](https://bbs.elecfans.com/static/image/common/pic_nv_prev.gif) *4/7* ![下一条](https://bbs.elecfans.com/static/image/common/pic_nv_next.gif)            

- [【开发板试用】](https://bbs.elecfans.com/collection_444_1.html)        

  开发板试用是电子发烧友网打造的一个开发板试用平台，与众多工程师分享你的创意

[查看 »](https://bbs.elecfans.com/collection_444_1.html)

- 华秋（原“华强聚丰”）：

  电子发烧友

  华秋开发

  华秋电路(原"华强PCB")

  华秋商城(原"华强芯城")

  华秋智造



- 设计技术

  [可编程逻辑](https://www.elecfans.com/pld/)

  [电源/新能源](https://www.elecfans.com/article/83/)

  [MEMS/传感技术](https://www.elecfans.com/article/88/142/)

  [测量仪表](https://www.elecfans.com/article/85/)

  [嵌入式技术](https://www.elecfans.com/emb/)

  [制造/封装](https://www.elecfans.com/article/90/155/)

  [模拟技术](https://www.elecfans.com/analog/)

  [RF/无线](https://www.elecfans.com/tongxin/rf/)

  [接口/总线/驱动](https://www.elecfans.com/emb/jiekou/)

  [处理器/DSP](https://www.elecfans.com/emb/dsp/)

  [EDA/IC设计](https://www.elecfans.com/bandaoti/eda/)

  [存储技术](https://www.elecfans.com/consume/cunchujishu/)

  [光电显示](https://www.elecfans.com/xianshi/)

  [EMC/EMI设计](https://www.elecfans.com/emc_emi/)

  [连接器](https://www.elecfans.com/connector/)

- 行业应用

  [LEDs ](https://www.elecfans.com/led/)

  [汽车电子](https://www.elecfans.com/qichedianzi/)

  [音视频及家电](https://www.elecfans.com/video/)

  [通信网络](https://www.elecfans.com/tongxin/)

  [医疗电子](https://www.elecfans.com/yiliaodianzi/)

  [人工智能](https://www.elecfans.com/rengongzhineng/)

  [虚拟现实](https://www.elecfans.com/vr/)

  [可穿戴设备](https://www.elecfans.com/wearable/)

  [机器人](https://www.elecfans.com/jiqiren/)

  [安全设备/系统](https://www.elecfans.com/application/Security/)

  [军用/航空电子](https://www.elecfans.com/application/Military_avionics/)

  [移动通信](https://www.elecfans.com/application/Communication/)

  [工业控制](https://www.elecfans.com/kongzhijishu/)

  [便携设备](https://www.elecfans.com/consume/bianxiedianzishebei/)

  [触控感测](https://www.elecfans.com/consume/chukongjishu/)

  [物联网](https://www.elecfans.com/iot/)

  [智能电网](https://www.elecfans.com/dianyuan/diandongche_xinnenyuan/)

  [区块链](https://www.elecfans.com/blockchain/)

  [新科技](https://www.elecfans.com/xinkeji/)

- 特色内容

  [专栏推荐](https://www.elecfans.com/d/column/)

  [学院](https://t.elecfans.com/)

  [设计资源](https://bbs.elecfans.com/group_716)

  [设计技术](https://www.elecfans.com/technical/)

  [电子百科](https://www.elecfans.com/baike/)

  [电子视频](https://www.elecfans.com/dianzishipin/)

  [元器件知识](https://www.elecfans.com/yuanqijian/)

  [工具箱](https://www.elecfans.com/tools/)

  [VIP会员](https://www.elecfans.com/vip/#choose)

- 社区

  [小组](https://bbs.elecfans.com/group/)

  [论坛](https://bbs.elecfans.com/)

  [问答](https://bbs.elecfans.com/ask.html)

  [评测试用](https://bbs.elecfans.com/try.html)

- [企业服务](https://q.elecfans.com/)

  [产品](https://q.elecfans.com/p/)

  [资料](https://q.elecfans.com/soft/)

  [文章](https://q.elecfans.com/d/)

  [方案](https://q.elecfans.com/sol/)

  [企业](https://q.elecfans.com/c/)

- 供应链服务

  [硬件开发](https://www.elecfans.com/kf/)

  [华秋电路](https://www.hqpcb.com/)

  [华秋商城](https://www.hqchip.com/)

  [华秋智造](https://smt.hqchip.com/)

  [nextPCB](https://www.nextpcb.com/)

  [BOM配单](https://www.hqchip.com/bom.html)

- 媒体服务

  [网站广告](https://www.elecfans.com/help/service.html)

  [在线研讨会](https://webinar.elecfans.com/)

  [活动策划](https://event.elecfans.com/)

  [新闻发布](https://www.elecfans.com/news/)

  [新品发布](https://www.elecfans.com/xinpian/ic/)

  [小测验](https://www.elecfans.com/quiz/)

  [设计大赛](https://www.elecfans.com/contest/)

- 华秋

  [关于我们](https://www.elecfans.com/about/)

  [投资关系](https://www.hqchip.com/help/factsheet.html)

  [新闻动态](https://www.hqchip.com/help/news/lists.html)

  [加入我们](https://www.elecfans.com/about/zhaopin.html)

  [联系我们](https://www.elecfans.com/about/contact.html)

  [侵权投诉](https://bbs.elecfans.com/about/tousu.html)

- 社交网络

  [微博](https://weibo.com/elecfanscom)

- 移动端

  [发烧友APP](https://www.elecfans.com/app/)

  [硬声APP](https://yingsheng.elecfans.com/app?eleclog)

  [WAP](https://m.elecfans.com/)

- 联系我们

  广告合作

  王婉珠：[wangwanzhu@elecfans.com](mailto:wangwanzhu@elecfans.com)

  内容合作

  黄晶晶：[huangjingjing@elecfans.com](mailto:huangjingjing@elecfans.com)

  内容合作（海外）

  张迎辉：[mikezhang@elecfans.com](mailto:mikezhang@elecfans.com)

  供应链服务 PCB/IC/PCBA

  江良华：[lanhu@huaqiu.com](mailto:lanhu@huaqiu.com)

  投资合作

  曾海银：[zenghaiyin@huaqiu.com](mailto:zenghaiyin@huaqiu.com)

  社区合作

  刘勇：[liuyong@huaqiu.com](mailto:liuyong@huaqiu.com)

- 关注我们的微信

  

- 下载发烧友APP

  

- 电子发烧友观察

  

[               ![华秋电子](https://www.elecfans.com/static/footer/image/footer-01-default.png)                          ](https://www.huaqiu.com/)

​                      [                           ![华秋发烧友](https://www.elecfans.com/static/footer/image/footer-02-default.png)                                                  ](https://www.elecfans.com/)                  

​                      [                           ![华秋电路](https://www.elecfans.com/static/footer/image/footer-03-default.png)                                                  ](https://www.hqpcb.com/)                  

​                      [                           ![华秋商城](https://www.elecfans.com/static/footer/image/footer-04-default.png)                                                  ](https://www.hqchip.com/)                  

​                      [                           ![华秋智造](https://www.elecfans.com/static/footer/image/footer-05-default.png)                                                  ](https://smt.hqchip.com/)                  

​                      [                           ![NextPCB](https://www.elecfans.com/static/footer/image/footer-06-default.png)                                                  ](https://www.nextpcb.com/)                  

- [华秋简介](https://www.huaqiu.com/about/groupoverview)
- [企业动态](https://www.huaqiu.com/news)
- [联系我们](https://www.huaqiu.com/about/contactus)
- [企业文化](https://www.huaqiu.com/about/corporateculture)
- [企业宣传片](https://www.huaqiu.com/about/promotionalfilm)
- [加入我们](https://www.huaqiu.com/jobs)

版权所有 © 深圳华秋电子有限公司 

[电子发烧友](https://www.elecfans.com/)[**（电路图）**](https://www.elecfans.com/)[粤公网安备 44030402000349 号](https://www.beian.gov.cn/ode=440304portal/registerSystemInfo?recordc02000366)[电信与信息服务业务经营许可证：粤 B2-20160233](https://www.elecfans.com/about/edi.html)[           ![工商网监认证](https://skin.elecfans.com/images/ebsIcon.png)工商网监       ](http://szcert.ebs.org.cn/c6db625a-ba09-414a-bba4-f57240baac9c6)[粤ICP备 14022951 号](https://beian.miit.gov.cn/#/Integrated/index)

- ![time](https://bbs.elecfans.com/template/elecfans_201508/images/time.png)[最新主题](https://bbs.elecfans.com/default.php?view=default)
- ![recommend](https://bbs.elecfans.com/template/elecfans_201508/images/zan.png)[推荐主题](https://bbs.elecfans.com/default.php?view=recommend)
- ![hot](https://bbs.elecfans.com/template/elecfans_201508/images/re.png)[热门主题](https://bbs.elecfans.com/default.php?view=hot)
- ![post](https://bbs.elecfans.com/template/elecfans_201508/images/me.png) [我的帖子](javascript:;)

- **-**[技术社区](https://bbs.elecfans.com/forum.php?gid=1411)

  [HarmonyOS技术社区](https://bbs.elecfans.com/harmonyos)  [RISC-V MCU技术社区](https://bbs.elecfans.com/riscvmcu)

- **-**[OpenHarmony开源社区](https://bbs.elecfans.com/forum.php?gid=1510)

  [OpenHarmony开源社区](https://bbs.elecfans.com/zhuti_1511_1.html)

- **-**[嵌入式论坛](https://bbs.elecfans.com/forum.php?gid=3)

  [ARM技术论坛](https://bbs.elecfans.com/zhuti_arm_1.html)  [STM32/STM8技术论坛](https://bbs.elecfans.com/zhuti_stm32_1.html)  [RT-Thread嵌入式技术论坛](https://bbs.elecfans.com/zhuti_emb_1.html)  [单片机/MCU论坛](https://bbs.elecfans.com/zhuti_mcu_1.html)  [RISC-V技术论坛](https://bbs.elecfans.com/zhuti_risc_1.html)  [瑞芯微Rockchip开发者社区](https://bbs.elecfans.com/zhuti_1179_1.html)  [FPGA|CPLD|ASIC论坛](https://bbs.elecfans.com/zhuti_fpga_1.html)  [DSP论坛](https://bbs.elecfans.com/zhuti_DSP_1.html)

- **-**[电路图及DIY](https://bbs.elecfans.com/forum.php?gid=48)

- **-**[电源技术论坛](https://bbs.elecfans.com/forum.php?gid=752)

- **-**[综合技术与应用](https://bbs.elecfans.com/forum.php?gid=345)

- **-**[无线通信论坛](https://bbs.elecfans.com/forum.php?gid=6)

- **-**[EDA设计论坛](https://bbs.elecfans.com/forum.php?gid=1)

- **-**[测试测量论坛](https://bbs.elecfans.com/forum.php?gid=32)

- **-**[招聘/交友/外包/交易/杂谈](https://bbs.elecfans.com/forum.php?gid=27)

- **-**[官方社区](https://bbs.elecfans.com/forum.php?gid=829)

![time](https://bbs.elecfans.com/template/elecfans_201508/images/time.png) ![recommend](https://bbs.elecfans.com/template/elecfans_201508/images/zan.png) ![hot](https://bbs.elecfans.com/template/elecfans_201508/images/re.png) ![post](https://bbs.elecfans.com/template/elecfans_201508/images/me.png)

—
—
—

版
块
导
航



展开

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.8915717761790558&amp;zoneid=1029&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109898_1_1.html" width="450" height="30" frameborder="0"></iframe>

*╳*

[![img](https://file.elecfans.com/web2/M00/7A/5B/poYBAGNx6JGAUvqIAACqaQrGZnQ426.png)](http://hqpcb.com/act/68cengban.html?fsydbtl)

[![电子技术论坛](https://bbs.elecfans.com/static/image/common/logo_new.png)](https://bbs.elecfans.com/)

- ​                            [首页](http://www.elecfans.com/)                                                    
- ​                            [论坛](https://bbs.elecfans.com/default.php)                                                                                                                                                
- ​                            [版块](https://bbs.elecfans.com/)                                                                                                                                                
- ​                            [小组](https://bbs.elecfans.com/group)                                                                                                                                                
- ​                            [活动](https://bbs.elecfans.com/zhuti_online_1.html)                                                                                                                                                
- ​                            [专栏](https://www.elecfans.com/d/)                                                                                                                                                
- ​                            [视频](https://www.elecfans.com/v/)                                                                                                                                                
- ​                            [问答](https://bbs.elecfans.com/ask/)                                                                                                                                                
- ​                            [下载](https://bbs.elecfans.com/soft/)                                                                                                                                                
- ​                            [学院](https://t.elecfans.com/)                                                                                                                                                
- ​                            [更多](javascript:;)                                                                                                                                                

|      |      |
| ---- | ---- |
|      |      |



​                                发 帖                             

- [登录/注册](javascript:;)

​                                                                                

- ![bread](https://bbs.elecfans.com/template/elecfans_201508/images/bread_img.png)[电子发烧友论坛](https://bbs.elecfans.com/forum.php)/

- ​        [EDA设计论坛](https://bbs.elecfans.com/forum.php?gid=1)/            

- ​        [KiCad EDA 中文论坛](https://bbs.elecfans.com/zhuti_kicad_1.html)                                

- /

  KiCAD教程（18），单片机开发板电源部分、EEPROM电路、C ...

#             KiCAD教程（18），单片机开发板电源部分、EEPROM电路、CAN通信电路及蜂鸣器电路布线        

[![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708/)[spark_zhang](https://bbs.elecfans.com/user/2164708/)

*2017-2-10 13:40:03**![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/wacth.png)*10758[蜂鸣器](https://www.elecfans.com/tags/蜂鸣器/)[电源](https://www.elecfans.com/tags/电源/)[单片机](https://www.elecfans.com/tags/单片机/)[eeprom](https://www.elecfans.com/tags/eeprom/)

​        

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.7490771045611807&amp;zoneid=223&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1109899_1_1.html" scrolling="no" width="728" height="90" frameborder="0"></iframe>

| *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zhichi.png)*                                                                                         0                                                                                                                             ![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/favorite.png)                        3                                                                                                                                                                                                                                                         在画[电源](https://bbs.elecfans.com/zhuti_power_1.html)部分线路之前先放上这一部分的原理图。如下图所示。  ![img](https://bbs.elecfans.com/data/attachment/forum/201702/10/133747hzzqiw5cv9l5oivi.png)        这个图我做了一点小修改，就是在5V电源部分。在之前的[电路](https://bbs.elecfans.com/zhuti_dianlu_1.html)中我们双排针引出的5V电源是直接放置的电源接口。这里我用了标号代替，这是因为我们电源部分引入5V后先是通过自恢复保险丝，然后才接入电路，如果我还是用电源接口的话双排针的输出电源就没有经过保险丝，而且开关也不可控，因此在开关后放置5V的标号，同样在双排针处也放置5V标号。这里改动完后还是按照之前讲的方法，重新导入一下网络表格修改一下[PCB](https://bbs.elecfans.com/zhuti_pads_1.html)。    画完后如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        我们还要在双排针处做一下标记，选择到顶层丝印层，然后将电源与地标出。[元件](https://bbs.elecfans.com/zhuti_yuanjian_1.html)的布局是随之走线在不断的变化，总之就是怎么方便走线怎么布局。图中蓝色的线是布在了底层，因为顶层已经无法布线，因此只能选择底层布线。同样先选择到底层铜层，然后再布线。    我们还看到U3芯片里面有个过孔，这里有一组快捷键可以快速使用过孔布线。当引出一根线时，如果想要通过过孔，鼠标在拉线的同时按键盘的V，就直接通过过孔在底层布线了。 首先我们要布的是EEPROM电路。在布线钱需要先打开原理图做一点小修改。找到该模块电路，我们需要将双排针换一个方向，选中双排针将其从电路中拖出，然后按键盘中的“X”键，双排针就上下翻转了一下。再拖回原电路。最后如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        然后还是按之前讲过的方法，重新导入PCB。给各个元件位置摆放好就可以画线，这个画线依个人习惯，怎么好看怎么布。如下图所示是我的布线。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        顶层走不了先可以选择底层，因为都是双排针，因此不需要走过孔，如果顶层是贴片元件则需要打一个过孔。其实后两个电路布线方法与之前讲的都一样，这里只是贴一下我布好线后的图。下图为CAN[通信](https://bbs.elecfans.com/zhuti_wireless_1.html)线路的布线。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        P8单排针需要与双排针精确定位，以防止跳线帽接不上，因此需要更改P8的x,y坐标与双排针对其。这里大家可以根据自己PCB上的坐标自行修改。    最后一部分就是蜂鸣器的电路的，如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        现在这三部分电路已经布好了，大家可以参考一下。 |
| ------------------------------------------------------------ |
|                                                              |



​        

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.04491945201120329&amp;zoneid=223&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1110045_1_1.html" scrolling="no" width="728" height="90" frameborder="0"></iframe>

| *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zhichi.png)*                                                                                         0                                                                                                                             ![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/favorite.png)                        3                                                                                                                                                                                                                                                         如果大家看了之前的教程会发现，越往后内容越来越少。其实这并不是我不想写，而是相对于这个[开发板](https://bbs.elecfans.com/try.html)而言，对这个软件的使用方法前面也已经都讲过了，再往后就是重复性工作，没有新的知识。但是又不能不讲，因为在画每个模块的[PCB](https://bbs.elecfans.com/zhuti_pads_1.html)时也会遇到一些小问题，这就需要随机应变了。再者大家时间都有限，每次放太多内容可能一时半会搞不定。所以每天放一点点，任务不多也不累。而且天天接触也不会过几天就忘。  废话就先说这么多，下面开始介绍画USB[通信](https://bbs.elecfans.com/zhuti_wireless_1.html)接口的线。如下图所示。  ![img](https://bbs.elecfans.com/data/attachment/forum/201702/11/131806c2ipcjnspppcqpc5.jpg)        还有一点就是画完一个接口后还要标上引脚号，这样易于区分。  同时也把LED[电路](https://bbs.elecfans.com/zhuti_dianlu_1.html)画完。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        然后是RS232电路。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        最后一点小技巧就是在添加文字时我都将其设置为1.2，但是如果每添加一次都要重新设置。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        这里大家可以选择尺寸设置里的文字设置。在这里设置好宽度高度，之后就不用再设置了。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        今天之所以讲这么多电路，因为画线的方法前面也都讲过了。这里就是让大家有个参照。看一下我画的电路。    首先是红外发射部分：  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        这里看到P7双排针还是要再换一个方向，方法还是在原理图中用X快捷键，这一点之前讲过。    然后是FLASH电路：  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        还是要记得在双排针处标上标号。    RS485电路：  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        85通信电路由于使用的是差分信号，因此还需要分别标上A、B接口。    最后是[仿真](https://bbs.elecfans.com/zhuti_proteus_1.html)器电路：  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        这个布的线有些长，中间还要打一个过孔。这主要是方便后面的布线，还要注意一点这里的地线都先不画。因为最后要覆铜，把覆铜设为地，可以通过过孔来连接。 |
| ------------------------------------------------------------ |
|                                                              |

|      |
| ---- |
|      |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/25/55/68_avatar_middle.jpg)](https://bbs.elecfans.com/user/2255568/)                                                                            [张览秀](https://bbs.elecfans.com/user/2255568/)                                        *2017-2-13 11:56:48*                                                                                                                                                                                                    [                                                                                                                                                                                                                                                   沙发                                                                                                                                                                                                                                        ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1110045&pid=5465142)                                                                                                                                                                                    谢谢分享 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/000/39/35/95_avatar_middle.jpg)](https://bbs.elecfans.com/user/393595/)                                                                            [海洋](https://bbs.elecfans.com/user/393595/)                                        *2017-2-14 09:27:29*                                                                                                                                                                                                    [                                                                                                                                                                                                                                                   板凳                                                                                                                                                                                                                                        ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1110045&pid=5466803)                                                                                                                                                                                    不错不错，学习了。。。 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/34/55/54_avatar_middle.jpg)](https://bbs.elecfans.com/user/2345554/)                                                                            [liuzhaoxin1020](https://bbs.elecfans.com/user/2345554/)                                        *2017-2-14 10:23:28*                                                                                                                                                                                                    [                                                                                                                                                                                           *3*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1110045&pid=5466939)                                                                                                                                                                                    不错的文件，值得收藏 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/002/34/55/54_avatar_middle.jpg)](https://bbs.elecfans.com/user/2345554/)                                                                            [liuzhaoxin1020](https://bbs.elecfans.com/user/2345554/)                                        *2017-2-14 10:24:41*                                                                                                                                                                                                    [                                                                                                                                                                                           *4*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1110045&pid=5466943)                                                                                                                                                                                    不错的文件，值得收藏 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |

| [![img](https://avatar.elecfans.com/uc_server/data/avatar/000/89/16/75_avatar_middle.jpg)](https://bbs.elecfans.com/user/891675/)                                                                            [zxlpcb](https://bbs.elecfans.com/user/891675/)                                        *2018-5-2 10:32:51*                                                                                                                                                                                                    [                                                                                                                                                                                           *5*#                                                                                                                                                                               ](https://bbs.elecfans.com/forum.php?mod=redirect&goto=findpost&ptid=1110045&pid=6749281)                                                                                                                                                                                    能自定义众标原点就好了。 |
| ------------------------------------------------------------ |
|                                                              |
| **![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zan.png)\*赞                                                                                                                                                                                                                         [![img](https://bbs.elecfans.com/template/elecfans_201805/images/u138.png)回复](javascript:;)*                                                                                                                                                                                                                                                                                                                  [举报](javascript:;) |
|                                                              |



#             KiCAD教程（20），单片机开发板其他模块布线        

[![img](https://avatar.elecfans.com/uc_server/data/avatar/002/16/47/08_avatar_middle.jpg)](https://bbs.elecfans.com/user/2164708/)[spark_zhang](https://bbs.elecfans.com/user/2164708/)

*2017-2-11 13:25:55**![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/wacth.png)*12960[单片机](https://www.elecfans.com/tags/单片机/)

​        

<iframe src="https://www1.elecfans.com/www/delivery/myafr.php?target=_blank&amp;cb=0.9972625479311837&amp;zoneid=223&amp;prefer=https%3A%2F%2Fbbs.elecfans.com%2Fjishu_1110047_1_1.html" scrolling="no" width="728" height="90" frameborder="0"></iframe>

| *![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/zhichi.png)*                                                                                         0                                                                                                                             ![img](https://bbs.elecfans.com/template/elecfans_201805/images/zl_icon/favorite.png)                        3                                                                                                                                                                                                                                                         前面讲了很多布线技巧，同时也完成了一些模块的布线。在这之后剩下的模块布线方法也大同小异，因此我就在这片文章中全部介绍完。在接下来的布线过程中，我们只需要先关注信号线，[电源](https://bbs.elecfans.com/zhuti_power_1.html)以及地可以先不用布，到最后所有信号线布完后再连接电源与地，这一点前面也介绍过，最后板子要覆铜，覆的铜接的是地，因此最后的地线可以通过打过孔相连。接下来是每一个模块的布线结果，大家可以按照我的走线方法布线，也可以按自己的方式布线，总之能相连即可，我的图只是给大家一个参考。**1** **[仿真](https://bbs.elecfans.com/zhuti_proteus_1.html)器接口布线**  ![img](https://bbs.elecfans.com/data/attachment/forum/201702/11/132325rt77t0c971r23el3.jpg)        **2 RTC****电池座以及[单片机](https://bbs.elecfans.com/zhuti_mcu_1.html)去耦电容布线**  ![img](https://bbs.elecfans.com/data/attachment/forum/201702/11/132325wbksc62kskyv277s.jpg)           ![img](https://bbs.elecfans.com/static/image/common/none.gif)        **3 SD****卡座布线**  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        **4** **照相机接口布线**  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        **5 NRF24L01****接口布线**  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        **6 TFT****接口布线**  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        **7** **按键布线**  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        **8 3.3V****电源与****GND****布线**    完成以上布线后大家可以看到整个板子的所有接线基本都已连接完，最后还会剩余几条线大家可以自行布好。然后就可以连接3.3V电源的线了。在整个[PCB](https://bbs.elecfans.com/zhuti_pads_1.html)中我们随便找一条3.3V接线，然后按住Ctrl键同时鼠标左键点击电源线就可以显示所有连接电源线的引脚，也就是高亮显示。效果如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        然后大家就可以进行电源线的布线了。  同理GND线也按上述方法高亮显示。如下图所示。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        最后我们需要检查一下是否有未连接的线。如下图所示，点击执行设计规则检查。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        在弹出的对话框中不需改动，默认即可，如下图所示。点击执行就会报告出有问题的接线或者未接线。  ![img](https://bbs.elecfans.com/static/image/common/none.gif)        最后按照提示进行修改即可。 |
| ------------------------------------------------------------ |
|                                                              |

​                    


