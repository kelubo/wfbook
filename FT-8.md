FT-8

数字模式，来自JT-9和JT-65的发明人K1JT，被称为FT-8(由Franke-Taylor设计，8FSK调制)。一种弱信号模式，不如JT-65/9那么灵敏，但当语音和CW不能工作时，它肯定会起作用。



出现了一种名为PSK31的数字模式。一种低带宽慢速数字协议，使用计算机的声卡进行发送和接收。计算机可以从您未发现的数据中提取数据。有一些错误纠正和其他技术特性使PSK31可能比摩尔斯电码更好地处理弱信号的操作，即使是非常熟练的操作员也是如此。

还有其他类似的数字模式，但大多数都没有像PSK31那样真正流行起来。直到FT8出现了。

FT8也是一种数字模式。它专门设计用于在流星散射或EME月反射通信等非常糟糕的情况下，在这些环境中可以运行良好。**为了最大化成功机会，每个FT8数据包保存13个字符，需要13秒才能发送。**协议取决于高度同步的时钟，每分钟分为15秒的时隙。由于这种**FT8通联是高度结构化的，而且时间短暂**，就像发推特一样。

因为信息是数字的并且格式有限，所以典型的交换是一个操作调用CQ。另一位操作员在其显示屏中注意到并点击了第一个工作站。现在他们的计算机交换位置和信号强度等基本信息。然后通联完成。                                                                                                                                                                                                                            



![img](https://mmbiz.qpic.cn/mmbiz_jpg/rpPgWGGewEsHjia3oSfhYttXicF74cSUUrz1P0on113PecqRf4Iaf8qWVIj6admuic81velBGFTTb1s579Cuiaug9Q/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

漫画作者：9A3VIS



这是Joe Taylor K1JT开发的一系列数字模式中的最新产品，它允许使用非常微弱的信号进行双向无线电通联，通常低于本底噪声。

大约一年前，FT8来到了身边。它与传统的其他模式的主要区别在于“过快”的速度：**从JT65的50秒减少到仅需要15秒**。我也相信FT8在我们的通联中占有一席之地。

FT8的另一个奇妙之处在于它首次将客观信号报告给了业余无线电爱好者。 

这让我想到另一个问题：频谱使用问题。 （我在这里打折FT8中最少使用的DXpedition模式。）在许多波段中，业余无线电使用频谱的压力被重新分配给其他更“有价值”的用途。到目前为止，我们已经能够证明，**特别是在重大比赛期间，我们的频谱会变得多么繁忙**，这有助于保持我们目前的频率范围。如果我们都开始在3kHz带宽内使我们的通联高于单个点频率，那么我们可能会对此产生重大伤害。

解决方案是什么？如上所述，**我完全支持FT8背后的基本原理，特别是它在高噪声区域以及传播困难的频段中的应用。****特别是如果它可以捕捉和鼓励新人的想象力，或者在暂时厌倦传统模式通联的老火腿，我们必须支持其使用。**

我真正喜欢的是，**当您开始接收具有正数dB的信号报告时，软件应该提醒您关闭并尝试其他模式，因为频段已经足够开放。** 然而，我怀疑我们会看到这一点，所以我们作为操作员可以考虑模式的更广泛的影响，以及何时/是否适合使用。                                                                                                                                                   

FT8模式的一个收发时序是15秒，远远快于JT65等模式的1分钟时序，这样看来完成一个完整的QSO只需要15×7=105秒。1分钟零45秒，这在原来连一次握手都完成不了。这样快的时序也使得FT8摆脱了“老头乐”的称号，至少要是全靠手动选择回复内容的话，像我这种反应速度非常“老头”的人是跟不上的。

这种模式设计出来本来是为了6米等传播转瞬即逝的波段的通联使用，但是现在大部分人都把它用在更低的频段上面，这就像是JT65的历史一样，而未来FT8会不会成为另一种主流的模式，以至于替代JT65呢？

（特别提醒一下，如果你使用JTAlert软件的话，也别忘记去官方网站升级它哦。不然的话是没办法继续上传HamSpot的。）



史蒂夫（K9AN）和K1JT为WSJT-X开发了一种潜在的新模式。他们称之为“FT8”模式（Franke-Taylor设计，8-FSK调制）。

FT8的重要特征：

- T/R序列长度：15秒
- 消息长度：75位+ 12位CRC 
- FEC码：LDPC（174,87）
- 调制：8-FSK，键控速率=音调间距= 5.86 Hz 
- 波形：连续相位，恒定包络
- 占用带宽：47 Hz 
- 同步：三个7×7 Costas阵列（Tx的开始，中间和结束）
- 传输持续时间：79 * 2048/12000 = 13.48 s 
- 解码阈值：-20 dB（可能是-24具有AP解码，TBD）
- 操作行为：类似于JT9，JT65的HF使用
- 多解码器：发现和解码通带中的所有FT8信号
- 手动启动QSO后可自动排序

与较为慢速的模式JT9，JT65，QRA64相比较：FT8的灵敏度要低几个dB，但完成QSO的速度要快很多，只有原来的四分之一。带宽占用比JT9高但只有JT65A的四分之一，比QRA64的二分之一略少。 与快速模式JT9E-H相比较：FT8的灵敏度更高，带宽要小得多，使用垂直瀑布图，并提供多重解码。 尚未实现之处：他们计划在QSO期间实现信号减法，二次解码，并在积分过程中使用已知信息。

​                                                                                                                                                                                                                                                            D4D套件初探

套件D4D与知名度极高的CW套件“皮鞋”、“蛙鸣”同宗同源，出自国内知名无线电爱好者BD6CR之手，是一款DSB模式FT8 QRPp收发信机套件。

![img](http://5b0988e595225.cdn.sohucs.com/images/20190610/0b818fe7b0ec4821a222a12795fbe37a.png)

一个AM信号的频域表示

提到DSB（在这里，指的是DSB-SC  双边带抑制载波调幅）。在频域上来看，AM调制的信号有着上边带、下边带和载波三个尖峰，而SSB调制的信号将某一个边带以及载波滤去，仅留下剩余的一个边带信号进行传送。FT8正是采用了上边带的方式进行信号传递。而DSB则是一种包含了上下边带的传输模式，它相比于AM模式少去了传递载波所需的功率消耗，因此拥有了更多的功率用来传输实际用来携带信息的边带信号。而相比于单边带收发信机来说，在个人DIY中，DSB收发信机又避免了采用晶体滤波器所带来的组装难度提升。唯一的缺点就是：在发射所需上边带信号时，相应的下边带信号也会随着一起发射。

![img](http://5b0988e595225.cdn.sohucs.com/images/20190610/87a5ea5187874058a3611275d27e99b1.png)

DSB信号的产生原理，D4D即采用此原理

D4D是一款非常简单的QRPp FT8  DSB套件。其接收部分采用直接变频方式，接收到的信号直接与本振的FT8工作频率混频，变频至音频域并送至计算机的声卡输入，而发射部分，计算机所产生的音频信号与本振通过602混频，产生DSB信号，并通过C1162功率放大，滤波器滤波后送往天线。该机本振采用晶体振荡器并引入一个简单的加热电阻用来保持晶体温度，因此可以满足FT8的频率稳定性需求。收发切换方面，该机有一个简单的VOX电路，因此不需要外加收发控制输入。在使用12V供电时，该机的输出功率约为1.5W，但考虑到DSB两个边带的问题，其输出功率还要打一个对折。

据设计者BD6CR称，该机的灵感来源自使用白炽灯泡作为天线进行FT8通联的美国火腿W6LG，既然这样妥协的天线都能够靠FT8的解码能力来弥补，那么架构简单、功率微小的DIY机器也能够通过FT8的解码能力和各位电台站中优良的天线来进行有效的通联，而D4D由此而生。由于其为DSB模式调制，在能够与其他USB调制的电台通信时，也会在发射时产生一个不需要的LSB信号。但对于一台发射功率仅有1W的机器来说，这一问题无足轻重。

![img](http://5b0988e595225.cdn.sohucs.com/images/20190610/9b6d03058ab34fdca7aa1418a7ca2afa.png)

笔者使用D4D和FT-818进行的“左右互搏”，两者均使用假负载，没有信号被实际发射入空中

该机由于采用直接变频的方式，且输入信号直接引入NE602，其高频增益仅靠602固有的增益。因此在接收时收到微弱信号的能力略欠缺。但作为一款QRPp机器，学会与大台工作、避开复杂的环境以及掌握QRP的一般操作能力是操作者所必须拥有的。这个问题并不致命。而FT8这种模式所提供的弱信号操作能力也为其提供了非常可观的通联机会

> 该机规格：
>
> 支持频段：晶体控频 单频点 可选（14.074 10.130 7.074 3.573.） 作者表示更多的晶振选项将在以后推出。
>
> 尺寸：103x66x27mm
>
> 重量：165g
>
> 供电：10~14V，推荐电压14V
>
> 发射功率：0.5~1.5W@12V