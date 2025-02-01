
RF Signal Generator

This signal generator is intended for realignment of radio receivers. The unit is cheap and fairly basic, but perfectly adequate for its intended purpose. However, the output is not a pure sine wave, so the unit may not be suited for more exacting electronic development work.

This photo was kindly supplied by Richard Hanes. Richard added an extra frequency band (up to 30MHz) as detailed towards the end of this article.

The unit covers a frequency range of 150KHz to 12MHz over five ranges (shown below). It is therefore suited to the alignment of RF and IF sections of AM (MW and LW) sets, as well as the IF sections of FM (VHF) circuits. It may also be used for RF alignment of SW circuits from 25 to 49 metres.

Range


Frequency


Inductor Value

A


150KHz - 500KHz


2.2mH

B


350KHz - 1MHz


470uH

C


750KHz - 2.25MHz


100uH

D


1.6MHz - 5MHz


22uH

E


3.5MHz - 12MHz


4.7uH

The output may be amplitude modulated by an internal 800Hz audio tone (approx. 30% modulation) or by an external signal. The output level is adjustable in two ranges up to a maximum of about 4V pk-pk. The unit is mains powered.

Circuit Description

If the diagrams on this page are not clear enough, you can download higher resolution copies. See the foot of this page for details.

TR1 is a high gain FET (Field Effect Transistor) and is configured as a Colpitts style oscillator. The oscillation frequency is set by the variable capacitor (C1+C2) and the five pairs of switched inductors. There is significant overlap between the ranges, due to the limited range of readily available inductors. However even by using specially would inductors, four frequency bands would have been needed to cover the range.

Circuit Diagram

The RF output is buffered by TR2, which is configured as an emitter follower. The output signal is developed across R6, and passes to the output sockets via variable and switched attenuater circuits.

The signal is amplitude modulated by varying the supply voltage to the oscillator circuit. This is carried out by TR3, which is an emitter follower. C10 decouples the feed at RF.

It should be noted that this modulation method does cause a small amount of unwanted frequency modulation as well as the desired amplitude modulation. If the unit was being used for listening to music on a radio this could cause a slight shrillness to the sound. However the arrangement has the advantage that it does not distort the RF waveform, which is important for alignment. It is also simpler to implement and gives consistent results - important requirements for this sort of project. As with any design there are always better ways of doing things, but this would result in a more expensive design that was more difficult to construct, and would not offer any significant advantages in practice.

SW2 selects either the internal or an external modulation signal. If no modulation is required, the switch is set to the external position with no signal applied to SK3. To give reasonable modulation the external signal should be about 1.5V RMS (4V pk-pk). If a music signal is used, the bandwidth should not extend above about 8KHz due to the limits of AM broadcasting. C10 will roll-off the higher frequencies to some extent. The selected modulation signal is buffered by TR4 and made available on SK4. This is useful for triggering an oscilloscope.

TR5 is configured in an R-C oscillator circuit. The frequency is set by C15, C16, C17, R19, R20 and R21 to about 800Hz. If you wish to alter the frequency, note that altering the value of R19 will affect the biasing of the transistor. Any variations should be carried out by changing the values of the capacitors rather than the resistors. R14 and C13 act as a filter to remove any distortion on the output.

The circuit is powered from a regulated 15V supply, and consumes about 30mA. IC1 is a standard three-pin 100mA regulator, fed by the full-wave rectified supply from a small mains transformer.

Update

John Shepherd has built this project and made the following comments:

    I had to reduce the value of R18 to 180K to get it to oscillate reliably.
    
    Also is the value of C13 right at 22nF - seems a bit high and it attenuates the signal too much on my version.

The audio oscillator is quite particular about the types of capacitor used for C15, 16 and 17. I used ceramic discs - and with these 220K for R18 was fine. Maybe the resistor needs to be adjusted to suit the transistor used?

22nF is the value I used for C13 - it is intended to improve the waveshape and will attenuate the signal a bit.

Has anyone else had the same problems as John?

Construction

The prototype was constructed on a piece of plain matrix board. Stripboard is not suitable because of the capacitance between adjacent tracks. A PCB could be designed, but this should follow the same general layout as the matrix board.

Circuit Board and Wiring

In the diagram the components and wires on the top face of the board are shown in black, while the underside connections are grey. Much of the circuit board wiring can be carried out using the component leadout wires, with pieces of tinned copper wire added where these are not long enough.

Note that there is an error on the above diagram. TR2 should be shown as a D shaped package the same as the others (with the flat face towards TR1).

John Shepherd has designed a PCB for this project. The files are available to download from this website, the link is at the bottom of this page. Doug Baird added:

    On the PCB, there seems to be a pad missing for the pot that is at the front of the board. I am including a PCB that I did. Sorry about taking the audacity to use the one there, then modify it but I am sending it along as a gif attachment. Use it if you like.

Doug's PCB file is also available below.

The unit should be built into a suitable metal cabinet to give adequate screening. This should be earthed via the earth wire of three-core mains flex.

C1+C2 is a Jackson Type-O air spaced variable capacitor. This is the most expensive component in the unit, costing around £15. However valve radio enthusiasts should be able to salvage something suitable from a scrap set.

You may wish to arrange a suitable pointer and scale if you intend to calibrate the unit. A suitable ball reduction drive and pointer (also made by Jackson) are available from Maplin and other suppliers. Alternatively, you may be able to use the scale and pointer arrangement from a scrap set.

The inductors are mounted on the rear of the rotary switch as shown. This should be positioned close to the variable capacitor to keep the wire lengths to a minimum. In addition, the circuit board should be positioned to give a minimum wire length to the variable capacitor and switch.

Thanks to Gary Tempest for these comments:

    Built the sig gen. You might want to point out to others that coil positioning is critical. I used a sub-miniature switch and everthing very tight and short. NOT GOOD. The coils, even ones not in use, couple to those that are and 'pull' giving strange effects. Also, if the two coils for the highest frequency range are placed along side each other you only get about 10 MHz max. Move them apart by 10 mm and you get up to 12 MHz. Because positioning affects the calibration, before completing this I fixed coils and 'front end' wiring (tuning cap etc.) with clear silicon sealer.

Richard Hanes agrees:

    I would support Gary's comments. The coils need to be laid out radially from a standard size switch or there is all manner of interaction. Your diagram, while presumably intended to be pictorial, is close to the optimum physical!

The transformer should be mounted towards the back of the case, well away from the RF tuning components. If a transformer with flying leads is used, these may be joined to the mains flex with a choc-block connector.

It may be worth including the Audio Output Level Indicator (shown elsewhere on this web site) in the same case. The two units would generally be used together so this could be a useful combination.

Accurate Calibration

For accurate calibration, a frequency calibrator or accurate oscilloscope is required. The unit may be set for various frequencies and these should be marked on the scale. Mark the scale every 5KHz between 400 and 500KHz if possible, so that the AM IF frequency (typically 455KHz, 465KHz or 470KHz) may be accurately set. Also, make every 0.1MHz between 10.4MHz and 11MHz, to allow the FM IF of 10.7MHz to be accurately set.

Alternatively, a good quality Short Wave receiver with digital readout may be used. With the internal modulation switched on, connect the unit to the receiver aerial connection. Set the receiver to the required frequency and adjust the signal generator frequency until the tone is heard.

Alternative Calibration

If none of these items are available, you should be able to adjust part of the range with a normal broadcast radio, as described above. If you have a good quality Hi-Fi receiver with a digital readout this would be better, otherwise use a set where the calibration is known to be good.

If the receiver does not have an external aerial connection, connect a coil of a few turns of wire about 6" (150mm) in diameter to the signal generator output, and position this close to the receiver.

You should be able to pick up the third harmonic of the frequencies between the MW and LW bands, at the appropriate position on the MW band. Thus, you should be able to tune in the third harmonic of 400KHz at 1200KHz.

Between 450KHz and 480KHz you could hit the IF frequency of the radio. This is generally fairly obvious, as the radio's tuning control will have little effect. It is also possible for the unit to beat with the radio's local oscillator, so do not be too concerned if the results do not seem to make sense. If it does not seem to work properly, try using a different radio.

You will not be able to calibrate frequencies above the top of the MW band (about 1600KHz) by this method. However for most radio alignment work this will not be a problem.

For alignment of VHF sets you will need to know the position of the IF (10.7MHz). Connect the unit to the aerial of an FM radio, turn the modulation off and set the output level to maximum. Tune the set to a weaker station on FM, and then adjust the signal generator frequency around the top band. When the IF of the set (invariably 10.7MHz) is found the reception should become much weaker or disappear altogether. This works better with some radios than others - and is generally more effective on cheap transistor sets.

Parts List

Resistors (all 5% 0.25W or better)


Capacitors

R1


1K2


C1+C2


365pF + 365pF Variable

R2


47K


C3,6,7,9,11,12


100nF

R3,10,12


22K


C4,5


100pF

R4


10K


C8


100nF 160V

R5


2K2


C10


2.2nF

R6,13,17


470R


C13


22nF

R7


150R


C14


1uF

R8


1K0


C15,16,17


4.7nF

R9


68R


C18


100uF

R11,14


15K


C19


100nF

R15


100R


C20


1000uF

R16


4K7


R18


220K


Miscellaneous

R19,20,21


27K


SW1,2


SPDT Toggle or Slide Switch

VR1


1K0 Lin Pot


SW3+SW4


2 Pole 6 Way Rotary Switch (1 off)


X1


15-0-15V 100mA Transformer

Inductors


SK1,2,3,4,5


4mm Socket or Binding Post

L1,2


2.2mH


Metal case

L3,4


470uH


Plain matrix board

L5,6


100uH


Tinned copper wire

L7,8


22uH


Knobs

L9,10


4.7uH


Materials for pointer


Mains flex

Semiconductors


13A plug with 3A fuse

D1,2


1N4002


Choc-block connector

TR1


BF244A


TR2,3,4,5


BC548C


IC1


78L15


High resolution copies of the circuit and layout diagrams (in .GIF, CorelDRAW 7 and ISIS Lite formats) are available for download in a ZIP file. File size is 267K. To download a copy Click Here.

The artwork files for a PCB for this project, designed by John Shepherd (in .GIF and Ares Lite formats) are available for download in a ZIP file. File size is 25K. To download a copy Click Here.

A version of the PCB layout by Doug Baird, which includes a pad apparently missing on the above one, is available as a GIF file. To view and save a copy Click Here.

Note that ISIS Lite and ARES Lite are unlimited shareware products. The unregistered versions don't expire but do nag you about registering. Registration is about £30 for both products together, which adds extra features and removes the nagging. They are available from http://www.proteuslite.com.

Variations

Richard Hanes has constructed a version with an additional range covering 10-30MHz:

    The variable capacitor that I had to hand was only 275+275pF so I used twice your values for the lower ranges and added 1u0H for the top range. (I also used BF256A for the FET - my guess is that it makes little difference, but I don't have a BF244 to try). Values and frequencies covered are as follows:

4m7H 	140 - 350 KHz
1m0H 	300 - 800 KHz
220uH 	0.65 - 1.8 MHz
47uH 	1.5 - 4.6 MHz
10uH 	3.0 - 10.5 MHz
1u0H 	10 - 34 MHz

    I found that a 470K gate resistor (R2) gave more consistent levels across ranges (possibly associated with the higher impedance of my tuned components).
    
    I would support Gary's comments (as reproduced on the website). The coils need to be laid out radially from a standard size switch or there is all manner of interaction. Your diagram, while presumably intended to be pictorial, is close to the optimum physical! To get to 30+MHz the leads must be kept short and thick, as is usual at these frequencies. I found 18swg tinned copper supported the components nicely and worked well.
    
    The unit is built into a standard die-cast box about 7" x 5" x 2" with external plug-top psu (the latter being an oddball supplying 19VAC at 100mA).
    
    I have made some minor tweaks in the attenuator department to give me the ranges shown and to "peak" the response at the top end (as the level does otherwise fall several dBs up at 30MHz). Its not a precision generator, but it is excellent for the intended purpose and considering the cost!!!

The "oddball" power supply adaptor that Richard used probably originally belonged to a modem. Many Hayes modems, from the days when 28k was fast, came with AC adaptors producing around this voltage. The adaptors are still useful, but the modems aren't!

<- Previous

Projects Menu

Next ->

Home
This website, including all text and images not otherwise credited, is copyright © 1997 - 2006 Paul Stenning.
No part of this website may be reproduced in any form without prior written permission from Paul Stenning.
All details are believed to be accurate, but no liability can be accepted for any errors.
The types of equipment discussed on this website may contain high voltages and/or operate at high temperatures.
Appropriate precautions must always be taken to minimise the risk of accidents.
Last updated 14th April 2006.





作者：Pavinberg
链接：https://zhuanlan.zhihu.com/p/716963359
来源：知乎
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。



起因就是我发现大部分人对 SSH 只会基本的 ssh user@ip 的方式登录服务器，至多再会个配置免密，而对 SSH config 几乎不了解。事实上 SSH 可以灵活批量配置服务器信息，配置跳板等等。本文努力普及一些使用细节，希望有一天大家都熟练了 SSH config，以后我就可以直接给别人发送 SSH config 配置项而不需要作任何解释了。

## SSH config

SSH config 作用就是可以把 SSH 相关的信息都记录到一个配置文件，可以简化操作、节约时间。

SSH config 有一个系统级的，一个用户级的。一般普通用户只关注用户级的。文件路径为 `~/.ssh/config` 。

### 基本写法

一般一个服务器写成一小段，形如：

```text
Host Server1
    Hostname 172.16.0.1
    User zhangsan
    Port 22
    ServerAliveInterval 180
    IdentityFile ~/.ssh/secret_key.pem
```

这段的含义为有一个服务器：

1. 我们为它起了个名字叫 Server1
2. 它的 IP 是 172.16.0.1（也可以填 Hostname）
3. 我在上面的用户名是 zhangsan
4. SSH 服务监听端口号为 22（即默认值，也可以不写这一行）
5. ServerAliveInterval 180 表示在建立连接后，每 180 秒客户端会向服务器发送一个心跳，避免用户长时间没操作连接中断
6. 最后一行表示使用一个专用的密钥，如果没有专用的密钥则删除该行即可。

登录这台服务器的话，输入：

```console
$ ssh Server1
```

拷贝文件（反过来就是从服务器往本地下载文件）：

```console
$ scp /path/to/local/file Server1:/path/to/remote/
```

可以看到，这样的好处有：（1）简洁，不需要记忆 IP 地址、端口号。（2）可以保持连接。

配置免密也相同，输入以下命令并输入密码：

```console
$ ssh-copy-id Server1
```

### 通配符

如果有一批服务器都是相同的配置，更是可以用通配符统一处理：

```text
Host Server*
    User zhangsan
    Port 22
    ServerAliveInterval 180

Host Server1
    Hostname 172.16.0.1

Host Server2
    Hostname 172.16.0.2

Host Server3
    Hostname 172.16.0.3
```

相信读者已经猜到其中的含义。第一段表示所有名字为 Server 开头的服务器，他们的用户名都是 zhangsan，端口都是 22，同时都有保持连接的心跳。然后下面列了 3 台服务器，我们只需要指定它们的 IP 地址。

### 多文件管理

如果需要管理非常多的服务器，全写到一个文件里会很乱很难维护，也不方便共享。事实上，`~/.ssh/config` 中支持引用其它文件。我一般习惯新建一个这样的配置 `~/.ssh/config-cluster-shanghai `，在其中编写类似上文的内容。然后在 `~/.ssh/config ` 的开头加入如下一行即可：

```text
Include config-cluster-shanghai
```

事实上这里也可以用通配符，比如：

```text
Include config-*
```

这样 `~/.ssh/` 目录下的所有 `config- ` 开头的文件都会被引用到。

### 跳板

 很多集群需要跳板机才可登录，我们需要先登录跳板机，再从跳板机登录内部机器。这会引入两个麻烦，一是登录要两次，如果配置 SSH config 还需要在跳板机也配置一份儿；二是拷贝文件十分麻烦，要拷贝两次。

对此可以这样写配置：

```text
Host Jumper
    Hostname 1.2.3.4
    User zhangsan

Host Server*
    User zhangsan
    ProxyJump Jumper
    ServerAliveInterval 180

Host Server1
    Hostname 172.16.0.1

Host Server2
    Hostname 172.16.0.2
```

第一段为跳板机的登录方式，第二段中新增了一个 ProxyJump 字段，表示所有 Server 开头的服务器，在登录的时候都要从 Jumper 这个服务器跳转一下。这时候我们想登录 172.16.0.1，只需要直接输入：

```console
$ ssh Server1
$ scp /path/to/local/file Server1:/path/to/remote/
```

注意一个细节是，这种配置下我们是直接从本地登录内部服务器，所以在配置免密时，是需要把本地的公钥放到内部服务器的。

## SCP 服务器间拷贝文件

scp 的基本用法相信大家都会，上文也多次提到。但如果想在两台服务器之间拷贝文件，事实上是可以在本地执行 scp 的：

```console
$ scp Server1:/path/to/file Server2:/path/to/file2
```

这个命令要求 Server1 可以直接访问 Server2。如果不满足这个条件，可以用本机转发，只需要增加一个参数 `-3`  表示用本地机器当转发机：

```console
$ scp -3 Server1:/path/to/file Server2:/path/to/file2
```

------

根据评论区的一些其它建议，额外补充两个实用辅助工具，一并推荐给大家。

## tssh

[tssh](https://link.zhihu.com/?target=https%3A//trzsz.github.io/ssh.html) 可以理解成是 OpenSSH 的一个升级版客户端。它的主要能力有：

1. 快速在 SSH config 里搜索服务器
2. 更高效方便地传文件
3. 以一种简单的加密方式记住服务器密码

### 基本用法

安装方式参见[官网](https://link.zhihu.com/?target=https%3A//trzsz.github.io/ssh.html)，基本上主流包管理器都可以直接安装。在使用时，直接把 ssh 替换成 tssh 即可。在不加服务器名字直接输入 tssh 时，会弹出机器列表，按下 "/" 可以搜索文本（支持 Vim 键位）：

![img](https://pica.zhimg.com/v2-a682c622a8eaa81b5141192363a11536_1440w.jpg)

### 记住密码

偶尔会遇到服务器不允许你把自己的公钥上传，这时可以使用记住密码的功能。输入以下命令，并输入密码：

```bash
$ tssh --enc-secret
Password or secret to be encoded: ***

Encoded secret for configuration: 7f28291d196d1955afa8f24a0395d8dbd3a3951fc7a79ba3ac681e5113825c
```

将它生成的这一长串 hash code 保存到你的 SSH config 中，例如，如果它是 Server1 的密码：

```text
Host Server1
    Hostname 172.16.0.1
    User zhangsan
    #!! encPassword 7f28291d196d1955afa8f24a0395d8dbd3a3951fc7a79ba3ac681e5113825c
```

所有 #!! 开头的注释会被 tssh 特殊处理，它会读取其中的字段。这样我们就没有明文保存密码。**不过这个方式是对称加密，安全性相对低，还是建议大家优先用 SSH 公钥而不是这种对称加密。**

同时，记得把 config 文件配置合理的权限：

```bash
$ chmod 700 ~/.ssh && chmod 600 ~/.ssh/password ~/.ssh/config
```

### 传输文件

tssh 有基于 trzsz 的文件传输功能。这个功能需要服务器上安装 trzsz。trzsz 有多种语言的实现，以 Go 语言实现的版本为例，可以参照[官网](https://link.zhihu.com/?target=https%3A//trzsz.github.io/go)中提示，直接用包管理器安装。

此外，一种比较通用的方式是用 release 安装，在 [GitHub Release](https://link.zhihu.com/?target=https%3A//github.com/trzsz/trzsz-go/releases) 上下载合适平台的 release 文件到本地，例如 [trzsz_1.1.8_linux_x86_64.tar.gz](https://link.zhihu.com/?target=https%3A//github.com/trzsz/trzsz-go/releases/download/v1.1.8/trzsz_1.1.8_linux_x86_64.tar.gz)  ，放到本地位置 `/path/to/trzsz_1.1.8_linux_x86_64.tar.gz`。 

对想安装的服务器执行以下命令：

```bash
$ tssh --install-trzsz --trzsz-bin-path /path/to/trzsz_1.1.8_linux_x86_64.tar.gz <host>
```

例如想在 Server1 上安装，就执行：

```bash
$ tssh --install-trzsz --trzsz-bin-path /path/to/trzsz_1.1.8_linux_x86_64.tar.gz Server1
```

它会安装两个命令到服务器的 `~/.local/bin/trz` 和 `~/.local/tsz` 。可以考虑修改环境变量便于方便调用，例如如果你使用 bash：

```bash
$ echo 'export PATH="$HOME/.local/bin:PATH"' >> ~/.bashrc
$ source ~/.bashrc
```

 如果想上传文件到服务器，就在服务器上输入 `trz` ，随后会弹出一个文件管理器让你选文件。想要下载文件就输入 `tsz <file on server>` 。（记住一定要用 tssh 登录服务器才可以使用这个功能，直接 ssh 到服务器上会不可用）。

## clustershell

想要批量操作服务器，比较经典的工具有 pssh 和 pdsh，同时也有功能强大的 [Ansible](https://link.zhihu.com/?target=https%3A//www.ansible.com/)。clustershell 是我最近体验很好的工具，相比 pssh 和 pdsh 的功能更加强大，具备批量 **interactive shell、集群分组、输出聚合、输出对比**等功能。相比 Ansible 部署方便，使用简单，用法好记忆，擅长互动。因此非常适合集群快速批量操作、集群测试和临时维护。

安装方式请参考[官网](https://link.zhihu.com/?target=https%3A//clustershell.readthedocs.io/en/latest/install.html)。

### 快速配置

我总结了一个简单的使用方式是构建一个这样的目录，例如放在 `~/clustershell`：

```text
clustershell
├── groups.conf
└── groups.d
    └── servers.cfg
```

设置环境变量：

```bash
$ echo 'export CLUSTERSHELL_CFGDIR=$HOME/clustershell"' >> ~/.bashrc
$ source ~/.bashrc
```

`groups.conf` 编写以下内容不用动：

```yaml
# ClusterShell node groups main configuration file
#
# Please see `man 5 groups.conf` and
# http://clustershell.readthedocs.org/en/latest/config.html#node-groups
# for further details.
#
# NOTE: This is a simple group configuration example file, not a
#       default config file. Please edit it to fit your own needs.
#
[Main]

# Default group source
default: servers

# Group source config directory list (space separated, use quotes if needed).
# Examples are provided. Copy them from *.conf.example to *.conf to enable.
#
# $CFGDIR is replaced by the highest priority config directory found.
# Default confdir value enables both system-wide and user configuration.
confdir: $CFGDIR/groups.conf.d

# New in 1.7, autodir defines a directory list (space separated, use quotes if
# needed) where group data files will be auto-loaded.
# Only *.yaml file are loaded. Copy *.yaml.example files to enable.
# Group data files avoid the need of external calls for static config files.
#
# $CFGDIR is replaced by the highest priority config directory found.
# Default autodir value enables both system-wide and user configuration.
autodir: $CFGDIR/groups.d

# Sections below also define group sources.
#
# NOTE: /etc/clustershell/groups is deprecated since version 1.7, thus if it
#       doesn't exist, the "local.cfg" file from autodir will be used.
#
# See the documentation for $CFGDIR, $SOURCE, $GROUP and $NODE upcall special
# variables. Please remember that they are substitued before the shell command
# is effectively executed.
#
[servers]
# flat file "group: nodeset" based group source using $CFGDIR/groups.d/servers.cfg
# with backward support for /etc/clustershell/groups
map: [ -f $CFGDIR/groups ] && f=$CFGDIR/groups || f=$CFGDIR/groups.d/servers.cfg; sed -n 's/^$GROUP:\(.*\)/\1/p' $f
all: [ -f $CFGDIR/groups ] && f=$CFGDIR/groups || f=$CFGDIR/groups.d/servers.cfg; sed -n 's/^all:\(.*\)/\1/p' $f
list: [ -f $CFGDIR/groups ] && f=$CFGDIR/groups || f=$CFGDIR/groups.d/servers.cfg; sed -n 's/^\([0-9A-Za-z_-]*\):.*/\1/p' $f
```

`groups.d/servers.conf` 编写：

```yaml
# ClusterShell groups config servers.cfg
#
# Replace /etc/clustershell/groups
#
# Note: file auto-loaded unless /etc/clustershell/groups is present
#
# See also groups.d/cluster.yaml.example for an example of multiple
# sources single flat file setup using YAML syntax.
#
# Feel free to edit to fit your needs.
all: 172.16.0.[1-8]
```

`all` 字段列出你的服务器列表，可以是 IP、Hostname 或者 SSH config 中的 Host 代称。

 如果服务器很多，IP 无规律，可以使用 clustershell 包自带的 `cluset` 工具帮忙。例如你有一个 IP 列表，就可以输入 `cluset -f` （ `-f` 表示 fold，折叠 IP 的意思） ，然后一行一行输入 IP，按 `Ctrl-D` 结束。或者如果你把 IP 保存到了一个文件 `iplist` 中，也可以：

```bash
$ cat iplist
172.16.0.1
172.16.0.2
172.16.0.3
172.16.0.4
$ cluset -f < iplist
172.16.0.[1-4]
```

### 基本使用与服务器分组

在 `groups.d/servers.cfg` 中增加新的字段即可：

```yaml
# ...
all: 172.16.0.[1-8]
group1: 172.16.0.[1-4]
group2: 172.16.0.[5-8]
```

输入以下命令对不同的服务器操作：

```bash
# 对所有服务器操作
$ clush -a echo Hello

# 对 group1 操作
$ clush -g group1 echo Hello
```

### 输出聚合

这个功能非常实用。只需要加上 `-b` 这个 flag，就会自动把输出相同的服务器合并输出：

```bash
$ clush -g group1 -b echo Hello
---------------
172.16.0.[1-4]
---------------
Hello
```

### Interactive Shell

不加具体的命令时，可以进入 Interactive Shell，例如：

```bash
$ clush -g group1 -b
Enter 'quit' to leave this interactive mode
Working with nodes: 172.16.0.[1-4]
clush> 
```

然后就可以当一个正常的 Shell 使用。其中还有一些[特殊命令](https://link.zhihu.com/?target=https%3A//clustershell.readthedocs.io/en/latest/tools/clush.html%23single-character-interactive-commands)：

![img](https://pic1.zhimg.com/v2-8dd304fb2d151f89af0733cbbc6f9510_1440w.jpg)

### 临时使用部分节点

```bash
$ clush -w 172.16.0.[2-5] -b echo Hello
```

### 输出 diff

```bash
$ clush -w 172.16.0.[2-5] --diff ls
```

### 文件分发和收集

[分发](https://link.zhihu.com/?target=https%3A//clustershell.readthedocs.io/en/latest/tools/clush.html%23file-copying-mode)文件（`-v` 表示 verbose，多输出一些日志），只有一个路径时，会分发到所有机器的相同路径：

```bash
$ clush -v -w 172.16.0.[2-5] --copy /tmp/foo
$ clush -v -w 172.16.0.[2-5] --copy /tmp/foo /tmp/bar
```

[收集](https://link.zhihu.com/?target=https%3A//clustershell.readthedocs.io/en/latest/tools/clush.html%23reverse-file-copying-mode)文件，会自动添加后缀：

```bash
$ clush -v -w 172.16.0.[2-5] --rcopy /tmp/foo
$ ls /tmp/foo.*
/tmp/foo.172.16.0.2 /tmp/foo.172.16.0.3 /tmp/foo.172.16.0.4 /tmp/foo.172.16.0.5
```



## [搞DDR必懂的关键技术笔记：深入探究DDR物理结构](https://zhuanlan.zhihu.com/p/713042976)

[![now](https://picx.zhimg.com/50/v2-7f38a1ce02c863f41d703d90cf3dcfd7_l.jpg?source=b6762063)](https://www.zhihu.com/people/now-88-1)

[now](https://www.zhihu.com/people/now-88-1)

冥想

128 人赞同了该文章

## **引言**

这篇文章的目的就是来看看芯片的物理结构，拿LPDDR5举例。

通过逐步深入探讨LPDDR5内存的**物理结构**，到文章结束时，您将清晰了解与LPDDR5内存相关的关键术语，包括：

- LPDDR5 IOs：命令总线（CA）、数据总线（DQ/DQS）、芯片选择（CS）、时钟（CK）
   
- Bank和Bank组架构
   
- Rank和页面大小
   
- LPDDR5内存通道
   
- x16/x32/x64宽度的解释
   

我们将从单个DRAM存储单元开始，逐步探索它是如何构成焊接在PCB上的完整内存封装的。

![img](https://picx.zhimg.com/v2-9423ab1f90ddb0e5c952fd9d48c808d9_1440w.jpg)

图0：从存储单元到存储封装

## **LPDDR5内存芯片**

### **单个存储单元**



![img](https://pic1.zhimg.com/v2-a4c127902462d846b2d3a30512c25fb6_1440w.jpg)

 在最底层，一个位本质上是一个电容器，用于存储电荷，而晶体管则作为开关。由于电容器会随时间放电，信息最终会消失，除非电容器被定期“刷新”。

>  这就是DRAM中“D”的来源——它指的是“动态”，与SRAM中的“静态”相对应。
>  

![img](https://pic3.zhimg.com/v2-37c5f61d2cce5c9b18ddc42e9a765e88_1440w.jpg)

### **Bank, Rows and Columns**



![img](https://pic3.zhimg.com/v2-abc8954059de50094f2a7dbae6dee5ec_1440w.jpg)

 当你放大一级视图时，你会注意到存储单元被排列成行和列的网格状。

**这样的存储单元网格被称为一个Bank**。Bank还有一个结构叫做感测放大器（Sense Amps）。

在读操作期间，首先会激活一行并将其加载到感测放大器中。

>  之前讲过哦：
>  

- **[搞DDR，你必须得看看我的这篇笔记](https://link.zhihu.com/?target=https%3A//mp.weixin.qq.com/s%3F__biz%3DMzUyOTY5NzkwNg%3D%3D%26mid%3D2247499905%26idx%3D1%26sn%3D0ff71ca88db96df46cd7737cfe879c1c%26chksm%3Dfa5f9d9ccd28148a949b406e9a8e7b09c7798d2e61d7b3ef25d0b66fdd2192abb9143ec2ec26%26payreadticket%3DHHmEk1v_ke3WLiL9zTAMF4zQb7El4fLiqNNv70LRP0Fnhhx3QJjNGPMPBeIAhAwvGmwiypE%23rd)**

然后，使用列地址来读取相应的列位。

在LPDDR5中，

- 每个Bank的一行包含1KB（8192位）的数据。
   
- 每行中的这1KB数据被排列成64列，每列128位。[64 x 128位 = 8192位]
   
- 因此，每次读/写访问都会指定一个行地址和一个列地址，Bank会返回128位的数据。这个数字很重要，我们将在下一节中再次提及它。
   

![img](https://pic3.zhimg.com/v2-1bba48fd69dacc79303293b002594e1a_1440w.jpg)

图2：存储器阵列

### **LPDDR5 Bank架构**



![img](https://pic4.zhimg.com/v2-687e9800458c5c0170bfae83608dc587_1440w.jpg)

 再放大一级视图，每个LPDDR5芯片都有32个这样的Bank块。这32个块可以以3种不同的配置进行排列。

- Bank组模式

**也称为BG模式**。在这里，32个Bank块被组织成2组，每组4个Bank组，每个Bank组包含4个Bank。[2x4x4=32]。

在下面的图3中，请注意Y轴上的BG0、1、2、3和X轴上的Bank0、1、2、3。 在读/写操作期间，提供的Bank地址会激活2个Bank，并访问总共256位的数据（请记住，每个行和列地址在一个Bank内访问128位的数据）。

>  记得之前我们讲过那个寻址的路线没，一共多少个线，然后不断地分配总线数量。用来做片选。
>  

- 16 Bank模式

在此模式下，32个Bank块被组织成2组，每组16个Bank。[2 x 16 = 32]。

此模式与Bank组模式之间的区别在于，访问Bank的时序参数在这两种模式之间是不同的。

您稍后会看到，16 Bank模式只能在低于3200 Mbps的速度下运行，而BG模式则在大于3200 Mbps的速度下运行。

- 8 Bank模式 在这里，32个Bank块被组织成4组，每组8个Bank。[4 x 8 = 32]。因此，在读/写操作期间，提供的Bank地址会激活4个Bank，并访问总共512位的数据。

![img](https://pic1.zhimg.com/v2-68e6afb7baf8834e6c49169864969a68_1440w.jpg)

图3：LPDDR5 Bank架构

>  那为什么有3种Bank模式而不是只有一种？ 
>  

LPDDR5提供多种Bank模式以适应不同的操作速度（如3200Mbps、5400Mbps、6400Mbps等）和不同的数据访问宽度（256位和512位）。**Bank模式的选择是在初始化期间通过在模式寄存器MR3中设置一个参数来完成的**（默认设置是16 Bank模式）。

因此，您选择哪种配置取决于两个因素：

1. 速度等级 - 存储器以什么速度运行？

1. 原生突发长度 - 每次操作您想要读取/写入多少位数据？

让我们详细看看这些。

>  速度等级
>  

- 如果存储器以> 3200Mb/s的速度运行，则只能使用Bank组模式。
- 如果存储器以<= 3200Mb/s的速度运行，则只能使用16 Bank模式。
- 8 Bank模式可以在所有速度下访问。

>   指的是在单次突发传输中能够连续传输的数据单元（如字节或字）的数量。这个参数对于提高数据传输效率和性能至关重要。具体来说，原生突发长度定义了在一个突发传输周期内，内存能够连续、无中断地处理的数据量。  当进行突发传输时，只要指定了起始地址和突发长度，内存就会依次自动对后续的相应数量的存储单元进行读/写操作，而无需控制器在每个数据单元传输之间重新指定地址。这种方式减少了地址信号的开销，从而提高了数据传输的速率和效率。  在LPDDR5等高速内存标准中，原生突发长度的具体值取决于内存的设计规格和性能要求。较长的突发长度可以在单个传输周期内处理更多的数据，从而提高数据传输的吞吐量；而较短的突发长度则可能更适合于对功耗有严格要求的应用场景。 此外，原生突发长度还与内存的其他参数（如突发大小、总线宽度等）密切相关。这些参数共同决定了内存的数据传输性能和效率。
>  

------

>  原生突发长度
>  

- 在**16 Bank模式**和**Bank组模式**下，一次读操作会并行激活2个Bank，并访问256位的数据（请记住，每个Bank返回128位的数据）。在LPDDR5中，数据总线宽度为16位（DQ[15:0]）。因此，这256位的数据随后会以16个数据块的形式突发传输出来，每个数据块包含16位数据（16x16=256）。这也被称为BL16或突发长度16。
   
- 在8 Bank模式下，如图3所示，每次读/写操作会激活4个Bank，并总共获取512位的数据。这些数据随后会以32个节拍的形式突发传输出来，每个节拍包含16位数据（32x16=512）。这被称为突发长度32。
   

>  示例：如果您的系统设计为以6400Mb/s的速度运行（这是LPDDR5支持的最高速度），并且您需要以256位为单位的数据访问，那么您会选择Bank组模式。
>  
>  **Note**：在Bank组模式下，您也可以实现BL32（突发长度32），但这稍微复杂一些，并且会对数据进行一些交织处理。如果您想要突发长度为32，那么直接使用8 Bank模式会更好。
>  

### **页大小（Page Size）**

**页大小是指当一行被激活时，加载到感测放大器中的位数。**

- 在16 Bank模式和Bank组模式下，页大小为2KB。
- 在8 Bank模式下，页大小为4KB。

>  我们是如何得出这些数字的？
>  

在图2中，我们看到Bank中的**每一行存储1KB的数据**（以64列、每列128位的方式排列）；

![img](https://pic3.zhimg.com/v2-1bba48fd69dacc79303293b002594e1a_1440w.jpg)

图2：存储器阵列

并且，从图3中我们可以看到，在16 Bank模式和Bank组模式下，**两行会同时被激活以总共获取256位的数据**。因此，从内存芯片的角度来看，**两行被激活，所以总页大小为2x1KB = 2KB。**

由此推断，**在8 Bank模式下，一次访问会激活4个Bank，因此页大小为4KB**。

### **密度**

到目前为止，我们已经讨论了LPDDR5内存芯片的物理结构，**但是内存芯片的容量是多少，它能存储多少位数据呢？**

LPDDR5内存芯片是按照特定的容量制造的，从JEDEC规范中指定的2Gb到32Gb不等。

一个2Gb容量的芯片和一个32Gb容量的芯片之间的**主要区别在于每个Bank中的行数**。

下表显示了以Bank组模式（BG模式）运行的内存所需的地址位数。

>  表1：x16 DQ 模式寻址
>  

| Memory Density    | 2Gb     | 8Gb     | 16Gb    | 32Gb    |
| ----------------- | ------- | ------- | ------- | ------- |
| Number of Rows    | 8192    | 32,768  | 65,536  | 131,072 |
| Number of Cols    | 64      | 64      | 64      | 64      |
| Row Address Bits  | R0-R12  | R0-R14  | R0-R15  | R0-R16  |
| Col Address Bits  | C0-C5   | C0-C5   | C0-C5   | C0-C5   |
| Bank Address Bits | BA0-BA1 | BA0-BA1 | BA0-BA1 | BA0-BA1 |
| BG Address Bits   | BG0-BG1 | BA0-BA1 | BA0-BA1 | BA0-BA1 |
| Page Size         | 2KB     | 2KB     | 2KB     | 2KB     |
| Array Pre-Fetch   | 256b    | 256b    | 256b    | 256b    |

**计算一个2Gb芯片的总密度：**

>  4 (BG) x 4 (Banks) x 8192 (rows) x 64 (cols) x 256b (each col) = 2,147,483,648 = 2Gb
>  

再给你整个图放这里！

![img](https://pic4.zhimg.com/v2-687e9800458c5c0170bfae83608dc587_1440w.jpg)

![img](https://pic3.zhimg.com/v2-fae075e7312016f1746099e9eeba49c0_1440w.jpg)

## **说说参数**

DRAM芯片相当于一栋装满文件柜的大楼

- Bank组（Bank Group）相当于楼层号，用于识别你需要的文件所在的楼层
   
- Bank地址（Bank Address）相当于楼层内的文件柜编号，用于识别你需要的文件所在的具体文件柜
   
- 行地址（Row Address）相当于文件柜中的抽屉编号，用于识别文件所在的具体抽屉。将数据读取到感测放大器（Sense Amplifiers）中相当于打开/抽出文件抽屉。
   
- 列地址（Col Address）相当于抽屉内文件的编号，用于识别抽屉内具体文件的编号。
   
- 当你想读取另一行数据时，你需要先将当前文件放回抽屉并关闭它，然后再打开下一个抽屉。这相当于预充电（PRECHARGE）操作。
   

## **x8 DQ 模式**

LPDDR5 接口有 16 个 DQ（数据）引脚。因此，默认情况下，内存以所谓的 x16 DQ 模式运行。

但是，你可以禁用 8 个 DQ 引脚，并将内存置于 x8 DQ 模式。

在这种模式下，在一次读或写访问期间，只有一个 Bank 被激活（而不是 2 个）。作为回报，你得到的是一个容量更大的内存，即与 x16 模式相比，每个 Bank 看起来的行数是 x16 模式的两倍。（我们将访问宽度减半，因此，正如你所期望的，深度加倍。）

------

>  我先解释一下这个 “容量更大”
>  

在LPDDR5或其他DRAM技术中，将接口从x16 DQ模式切换到x8  DQ模式实际上并不直接增加物理上的存储容量（即芯片上存储单元的总数）。然而，从逻辑和访问效率的角度来看，它给人一种“容量更大”的错觉，这主要是因为改变了数据访问的方式和Bank的利用率。

具体来说，当在x16  DQ模式下工作时，内存接口可以并行处理更多的数据（因为有两个Bank可以同时被激活，并且每个Bank的访问宽度是16位），这提高了数据传输的吞吐量。但是，在x8 DQ模式下，虽然一次只能激活一个Bank，并且访问宽度减半（每个Bank的访问宽度现在是8位），但这允许在逻辑上更深入地访问内存。

这里的“容量更大”主要体现在以下几个方面：

1. **更深的Row寻址空间**：由于一次只能激活一个Bank，并且访问宽度减半，因此每个Bank在逻辑上看起来像是拥有更多的Row。这是因为当访问宽度减少时，为了保持相同的总数据传输速率，需要访问更多的Row来填充数据通道。这并不意味着物理上增加了Row的数量，而是改变了数据访问的粒度。
    
2. **Bank利用率**：在x16 DQ模式下，两个Bank可以同时被激活，这可能导致在某些情况下，一个Bank在等待另一个Bank完成操作时被闲置。而在x8 DQ模式下，虽然牺牲了并行性，但确保了每次只有一个Bank被完全利用，从而可能提高了某些特定工作负载下的整体效率。
    
3. **灵活性和优化**：在某些应用场景中，比如对延迟敏感的应用，减少并行性和增加深度可能是一个有利的权衡。这是因为较深的Row寻址空间可以减少PRECHARGE和ACTIVATE命令的频率，这些命令在DRAM操作中可能会引入相对较长的延迟。
    

![img](https://pic3.zhimg.com/v2-b99b404c3ed7734b2fe90a597ef6459e_1440w.jpg)

图四: x8 DQ Mode

>  表2：x8 DQ 模式寻址
>  

| Memory Density    | 2Gb     | 8Gb     | 16Gb    | 32Gb    |
| ----------------- | ------- | ------- | ------- | ------- |
| Number of Rows    | 16,384  | 65,536  | 131,072 | 262,144 |
| Number of Cols    | 64      | 64      | 64      | 64      |
| Row Address Bits  | R0-R13  | R0-R15  | R0-R16  | R0-R17  |
| Col Address Bits  | C0-C5   | C0-C5   | C0-C5   | C0-C5   |
| Bank Address Bits | BA0-BA1 | BA0-BA1 | BA0-BA1 | BA0-BA1 |
| BG Address Bits   | BG0-BG1 | BA0-BA1 | BA0-BA1 | BA0-BA1 |
| Page Size         | 1KB     | 1KB     | 1KB     | 1KB     |
| Array Pre-Fetch   | 128b    | 128b    | 128b    | 128b    |

在上面的表格中，请注意与表1相比，Array Pre-Fetch和Page Size减半了，而行数（Number of Rows）加倍了。

>  x16模式与x8模式的设置是通过模式寄存器MR8来完成的。
>  

## **LPDDR5 内存通道**

![img](https://pic1.zhimg.com/v2-beecdd0262f099050738387ddcf7d850_1440w.jpg)

>  表3：LPDDR5 输入/输出（IOs）
>  

```text
|
```

| Pin                      | Width | Type                          | Description                                                  |
| ------------------------ | ----- | ----------------------------- | ------------------------------------------------------------ |
| RESET_n                  | 1     | Input                         | Reset pin                                                    |
| CK_t, CK_c               | 1     | Input                         | Differential clock                                           |
| CS[1:0]                  | 2     | Input                         | Chip Select. Think of this as the enable/valid pin. The rest of the command bus is valid only when this is high. |
| CA[6:0]                  | 7     | Input                         | Address bus. This is used to select which BankGroup,Bank,Row,Col to access. |
| DQ[15:0]                 | 16    | InOut                         | Bidirectional data bus                                       |
| WCK[1:0]_t, WCK[1:0]_c   | 2     | Input                         | Differential clocks used for WRITE data capture and READ data output |
| DMI[1:0]                 | 2     | InOut                         | Data mask inversion. This IO has several functions such as DataMask (DM),  DataBusInversion (DBI), or Link ECC based on the mode register setting. |
| RDQS[1:0]_t, RDQS[1:0]_c | 1     | RDQS_t: Inout, RDQS_c: Output | Read Data Strobe                                             |

### **秩（Ranks）、宽度级联（Width Cascading）和深度级联（Depth Cascading）**

一个通道可以由一个或多个LPDDR5内存芯片组成**。在下图中，我展示了如何配置多个2Gb内存芯片来增加通道中的总内存容量。**

- 2Gb通道容量：这很简单。只需将一个2Gb内存芯片连接到LPDDR5的IOs上。
   
- 4Gb通道容量：在这里，我们有两个2Gb芯片，它们被“深度级联”，也称为2秩（Rank）配置。通过设置芯片选择0（CS0引脚）来访问芯片A，而芯片B则通过CS1引脚来选择。但是，由于一次只有一个芯片选择引脚处于活动状态，**因此两个芯片共享相同的地址和数据总线。**
   
- 8Gb通道容量：在这里，我们有四个2Gb芯片。与4Gb容量类似，这里也有2秩。**但在每个秩内部，我们有两个“宽度级联”的芯片，即每个芯片都被配置为x8宽度模式**。
   

![img](https://pic1.zhimg.com/v2-931887bf03ec4d540fd20f19a30d6260_1440w.jpg)

图5：LPDDR5 通道

## **LPDDR5 内存封装**

![img](https://pica.zhimg.com/v2-6287f2887298077e6b9d79bd99979a68_1440w.jpg)

图6：x64 4通道LPDDR5封装

最后，我们再将视角拉远一点，现在我们看到的是整个LPDDR5内存设备封装。这是你可以从美光（Micron）或三星（Samsung）等供应商那里购买的产品。

通常，一个内存封装包含多个通道。这使得内存制造商能够创建具有不同宽度和容量的内存设备，以满足各种应用的需求。

在供应商的产品目录中，典型的宽度和容量包括：

- 容量：4GB、8GB、16GB等
   
- 宽度：x16（1通道）、x32（2通道）、x64（4通道）。每个通道都是独立可访问的，并且拥有自己的CA和DQ引脚集。
   

## **SoC-LPDDR5 接口**

既然我们已经了解了LPDDR5内存的外观，那么我将以讨论处理器或SoC如何对内存进行读写来结束本文。

为了与LPDDR5内存通信，SoC、ASIC、FPGA或处理器需要一个控制器和一个PHY。这三个实体——控制器、PHY和LPDDR5内存设备——共同构成了LPDDR5内存子系统。

![img](https://pic4.zhimg.com/v2-0a0b4bd47e90b2d8ae0da906a38eb1eb_1440w.jpg)

图7：LPDDR5内存子系统

## **LPDDR5 接口**

如前所述，下表描述了PHY与单个LPDDR5内存通道之间的接口。这些IO是PCB上的物理走线。

| Pin                      | Width | Type                          | Description                                                  |
| ------------------------ | ----- | ----------------------------- | ------------------------------------------------------------ |
| RESET_n                  | 1     | Input                         | Reset pin                                                    |
| CK_t, CK_c               | 1     | Input                         | Differential clock                                           |
| CS                       | 1     | Input                         | Chip Select. Think of this as the enable/valid pin. The rest of the command bus is valid only when this is high. |
| CA[6:0]                  | 7     | Input                         | Address bus. This is used to select which BankGroup,Bank,Row,Col to access. |
| DQ[15:0]                 | 16    | InOut                         | Bidirectional data bus                                       |
| WCK[1:0]_t, WCK[1:0]_c   | 2     | Input                         | Differential clocks used for WRITE data capture and READ data output |
| DMI[1:0]                 | 2     | InOut                         | Data mask inversion. This IO has several functions such as DataMask (DM),  DataBusInversion (DBI), or Link ECC based on the mode register setting. |
| RDQS[1:0]_t, RDQS[1:0]_c | 1     | RDQS_t: Inout, RDQS_c: Output | Read Data Strobe                                             |

## **DFI 接口**

**控制器可以被视为逻辑层面的核心**。**它是一个复杂的状态机，确保在执行读取、写入或刷新操作时严格遵守LPDDR5协议**。而另一方面，**PHY则代表物理层面，包含了所有必要的模拟组件，以确保时钟、地址和数据信号在内存与PHY之间能够可靠地传输。**

参考前面的图7，PHY和控制器通过一个定义明确的标准接口——即DFI接口——进行通信。通过这个接口，PHY可以向控制器报告其当前状态，比如是否处于初始化阶段、校准阶段，或者是否已准备好执行读取/写入操作。

## **控制器接口**

**访问DDR内存需要精确的步骤和时序控制**。例如，为了将数据写入内存，需要向内存发送一系列命令来激活正确的bank、行和列，然后在精确的时间点（称为写入延迟）发送数据。此外，在所有这些操作之间，内存还需要以固定的周期进行刷新，以防止数据丢失。

控制器通过抽象化这些复杂的步骤和时序控制，**提供了一个简单的接口（如AXI）**，使得我们可以更容易地发出写入或读取指令。

除了提供一个简单的内存访问接口外，**控制器还具备多种智能功能（如地址重排序），这些功能有助于SoC/处理器最大化内存带宽**。这一点非常重要，因为内存通常是笔记本电脑、手机或复杂ASIC（如TPU）性能瓶颈的所在。

>  点赞超200，更Training！
>  

## **推荐阅读**

- **[搞DDR，你必须得看看我的这篇笔记（一）：DRAM](https://link.zhihu.com/?target=https%3A//mp.weixin.qq.com/s%3F__biz%3DMzUyOTY5NzkwNg%3D%3D%26mid%3D2247499731%26idx%3D1%26sn%3Ded6d2d9c7c1394cb2e14e06d816ca6d3%26chksm%3Dfa5fa2cecd282bd83fc7b03b9ced81f340106c4eff24584cdb43f67951cd8b79a0103d9ac5e8%26payreadticket%3DHIRmBy507MIugzZMMmmuQ0AWO4p3txZaIfjD8aztw7CoTccSKWTcw99cdX4632pLwKgKzgI%23rd)**
   
- **[搞DDR，你必须得看看我的这篇笔记（二）：DDRC](https://link.zhihu.com/?target=https%3A//mp.weixin.qq.com/s%3F__biz%3DMzUyOTY5NzkwNg%3D%3D%26mid%3D2247499810%26idx%3D1%26sn%3D645237902019cbbdbcf8b10a809ce99d%26chksm%3Dfa5f9d3fcd281429ef86e0978187565eff36f00e65b4056e9630d568cd6446354a402a8f2c44%26payreadticket%3DHPE0wn7SohYJRH0lQwSlb-zec4XZDS94KHrAWJ5y4DH3rszLagMHRmlEiL4t4Oifq-uLZYc%23rd)**
   
- **[搞DDR，你是可以看看我的这篇笔记（三）：DDRPHY](https://link.zhihu.com/?target=https%3A//mp.weixin.qq.com/s%3F__biz%3DMzUyOTY5NzkwNg%3D%3D%26mid%3D2247499837%26idx%3D1%26sn%3Dd6a26437743137ba2c7e2af35fdd35b4%26chksm%3Dfa5f9d20cd281436f50709e2f8c7cba68d9d525f3488540b15b0ee4a059eef96448aa1438499%26token%3D84940425%26lang%3Dzh_CN%23rd)**
   
- **[搞DDR，你必须得看看我的这篇笔记（总结篇）](https://link.zhihu.com/?target=https%3A//mp.weixin.qq.com/s%3F__biz%3DMzUyOTY5NzkwNg%3D%3D%26mid%3D2247499905%26idx%3D1%26sn%3D0ff71ca88db96df46cd7737cfe879c1c%26chksm%3Dfa5f9d9ccd28148a949b406e9a8e7b09c7798d2e61d7b3ef25d0b66fdd2192abb9143ec2ec26%26payreadticket%3DHMFCrV2B0r_Iz2RraVfQjksHCi-gHbyo5F7EY1mOA-MdLJDMhpecfl8-t8lOL5gZ2OyLCCI%23rd)**
   
- **[搞DDR必懂的关键技术笔记：ODT](https://link.zhihu.com/?target=https%3A//mp.weixin.qq.com/s%3F__biz%3DMzUyOTY5NzkwNg%3D%3D%26mid%3D2247500207%26idx%3D1%26sn%3Deea78433813d7202f302f8299bdba83c%26chksm%3Dfa5f9cb2cd2815a447601a59254e217f83662c877cf08811e11b628b4f4066c6e0a469b12096%26payreadticket%3DHJsZjEEG-deG7cFtMIE2hakjJn7nbERQyTQM_NLliRXX0SYohpXr1RTNhTzKofee-jNXne0%23rd)**
   
- **[搞DDR必懂的关键技术笔记：Initialization, Training ， Calibration](https://link.zhihu.com/?target=https%3A//mp.weixin.qq.com/s%3F__biz%3DMzUyOTY5NzkwNg%3D%3D%26mid%3D2247500248%26idx%3D1%26sn%3D503c5f59d1676950ec7013635fe170dc%26chksm%3Dfa5f9cc5cd2815d3de2d22fafda69e3870403f23bcb765c088a4f20eb56dc7079dd305212038%26token%3D851425450%26lang%3Dzh_CN%23rd)**





## **前言**

很难用一篇文章去完全的了解UEFI，这篇文章的目标是希望能让不了解的朋友看完后达到下面几个目标：

- UEFI是什么：概念
- UFEI用来干什么：应用
- UEFI有些什么东西：架构
- UEFI重点场景：启动
- UEFI学习资料：推荐

通过这几个部分，咱们能一起搭建起一个关于UEFI简要知识框架。那么以后对哪些方面感兴趣，让我知道，咱们再一起学习一下，去继续丰富关于UEFI。

>  话不多说，上菜！
>  

## **UEFI是什么？**

这就不得不提提BIOS。

### **传统BIOS**

为了更好地理解UEFI，我们首先需要回顾一下历史。自20世纪80年代以来，计算机一直在使用BIOS。

当我们提到BIOS时，根据上下文的不同，它可能代表不同的含义：

1. **BIOS标准**：这是一个广泛的概念，指的是一种在计算机启动时初始化硬件并加载操作系统引导程序的标准接口。
    
2. **具体的BIOS实现**——即特定于主板的固件（“ASUS $motherboard_name BIOS”）：
    

- 这是由主板制造商编写或授权的代码。
- 当计算机开机时，硬件被设置为开始执行BIOS。这是CPU需要知道的全部内容，即CPU不需要了解驱动器、文件系统或操作系统。BIOS负责初始化硬件，加载引导加载程序（如GRUB或Windows Boot Manager），然后引导加载程序负责加载并启动操作系统。

简而言之，BIOS是计算机启动过程中的一个重要环节，它负责在操作系统加载之前初始化硬件，并为操作系统的启动提供必要的环境。**而UEFI（统一可扩展固件接口）是BIOS的现代替代品，提供了更多的功能和更好的安全性。**

### **BIOS作为标准**

作为一个标准，BIOS定义了以下内容：

1. 一个硬编码的内存位置，计算机在开机时CPU将从该位置开始执行BIOS代码。

1. 磁盘位置，操作系统制造商可以在这些位置放置其引导加载程序以启动其操作系统。

1. 应用程序接口（APIs）用于：

- 从硬盘和软盘读写数据（因此不是所有程序都需要直接处理IDE/SATA等总线）

  读取键盘按键 => BIOS是一个硬件抽象层。

- 

1. 其他许多功能

通过这些方式，BIOS为以下对象提供了API：

1. 操作系统制造商

1. CPU制造商

1. 应用程序开发人员。不过，现在这些API的使用已经不多了，因为：

- 开发人员与操作系统的硬件抽象API进行交互，甚至操作系统本身也不使用太多的BIOS API（因为它们直接控制硬件以获得更高级别的访问权限，这样就很不安全了）
- 即使在DOS时代，应用程序开发人员也可能使用DOS API进行抽象，而不是直接使用BIOS。

### **BIOS作为实现**

你可能熟悉更新主板BIOS的过程。待刷新的BIOS是特定于主板的（即不存在适用于所有主板的单一BIOS），因为BIOS的实现是特定于主板的。

我并不完全了解制造商特有的所有内容，但我猜测不同主板的芯片组会有所不同，比如内存控制器的初始化和处理、内置图形处理器等。

### **BIOS的工作原理**

x86  CPU被设计为从一个硬编码的内存位置（0xFFFFFFF0）开始执行代码。这个内存位置由主板的BIOS代码ROM提供支持。在电气上，很容易将不同的地址空间分开，其中某些位置从RAM读取，而某些位置则从BIOS ROM等读取。要更深入地了解这一概念在电气上的实现，请观看此视频。

以下是一个过于简化的视图：

![img](https://picx.zhimg.com/v2-a51293ab21e72e5d86d34511baae37ef_1440w.jpg)

BIOS负责实际启动你的操作系统。

在BIOS设置中，**你通常可以配置启动顺序，如CD-ROM、硬盘1、硬盘2等，以及它们的任何组合。BIOS会根据你的启动顺序偏好找到第一个可启动项。**

### **传统BIOS的局限性**

由于引导加载程序大小的限制，大多数操作系统不得不使用复杂的链式启动过程。

### **传统BIOS启动过程**

对于硬盘来说，存在一个引导扇区。引导扇区，或者更具体地说，是主引导记录（MBR），它包含引导加载程序，并且其大小限制实际上是440字节，**因此仅凭这个大小的引导加载程序绝对无法加载现代操作系统。**

通常，**MBR中的引导加载程序会将控制权传递给活动分区的引导加载程序**（VBR，卷引导记录），但它**也有相同的大小限制。**

加载操作系统至少意味着引导加载程序必须从磁盘读取内核（Linux/Windows等）并将其控制权交给它。内核更加智能，能够理解各种文件系统，如NTFS/FAT等。

但是，为了让引导加载程序从磁盘读取内核，**它必须知道如何遍历文件系统以访问内核。**因此，引导加载程序会从文件系统的根目录读取并链式加载一个“第二阶段”（这是一个更简单的任务）——一个可以更大、因此可以包含更复杂代码的文件。

在Windows中，这个第二阶段过去被称为NTLDR（“NT加载程序”），它位于你的 `C:`驱动器的根目录下。



![img](https://pic2.zhimg.com/v2-ff65f9e0e4500ef7fe1d6264f6000ecb_1440w.jpg)

 以下是关于传统BIOS和旧版Windows版本的启动过程：

![img](https://pic4.zhimg.com/v2-6106a8c9aafada3946d26811c77e8173_1440w.jpg)

如你所见，有很多箭头——引导加载程序组件分布在各个地方。有三个不同的特定于Windows的位置用于开始加载实际的内核。只要其中一个组件出错，你就会得到一个无法启动的系统。

Linux（链式GRUB）的情况也大致相同。

搞了这么多的BIOS？你的标题是UEFI欸，你别着急，继续看。

## **BIOS VS UEFI**

其实大家对BIOS不陌生，到这里呢，我们来对通过一个对比引出我们的主角UEFI。

BIOS 代表基本输入输出系统（Basic Input/Output System），是我们在上述启动过程中提到的固件。

它存储在可擦除可编程只读存储器（EPROM, Erasable Programmable Read-Only Memory）中，这使得制造商可以轻松地推送更新。

![img](https://pic4.zhimg.com/v2-39ab12fc3956351473befe506a47b093_1440w.jpg)

BIOS 提供了许多辅助功能，这些功能允许读取附加存储设备的引导扇区并在屏幕上打印信息。您可以在启动过程的初始阶段通过按 Del、F2 或 F10 键来访问 BIOS。

UEFI 代表统一可扩展固件接口（Unified Extensible Firmware Interface）。它与 BIOS 执行相同的任务，但有一个基本区别：**它将所有关于初始化和启动的数据存储在 .efi 文件中，而不是存储在固件上。**

![img](https://pic3.zhimg.com/v2-a8dccb35328735edeb0e41432ae8fbe2_1440w.jpg)

这个 .efi 文件存储在硬盘上一个名为 EFI 系统分区（EFI System Partition, ESP）的特殊分区中。这个 ESP 分区还包含引导加载程序。

UEFI 被设计用来克服旧版 BIOS 的许多限制，包括：

- UEFI 支持高达 9 泽它字节（Zettabytes）的驱动器大小，而 BIOS 仅支持 2.2 太字节（Terabytes）。
   
- UEFI 提供更快的启动时间。
   
- UEFI 具有独立的驱动程序支持，而 BIOS 的驱动程序支持存储在 ROM 中，因此更新 BIOS 固件有点困难。
   
- UEFI 提供类似“安全启动”（Secure Boot）的安全功能，这可以防止计算机从未经授权/未签名的应用程序启动。这有助于防止  rootkit，但也会妨碍双系统启动，因为它将其他操作系统视为未签名的应用程序。目前，只有 Windows 和 Ubuntu  是已签名的操作系统（如果我有误，请告诉我）。
   
- UEFI 以 32 位或 64 位模式运行，而 BIOS 以 16 位模式运行。因此，UEFI 能够提供图形用户界面（GUI, Graphical User Interface），允许使用鼠标进行导航，而 BIOS 仅允许使用键盘进行导航。
   

当然您可能不需要 UEFI

尽管所有现代计算机都默认配备了 UEFI，但您可能选择使用 BIOS 而不是 UEFI 的原因有几个：

- 如果您是初学者，并且不关心与任何类型的固件打交道，那么 BIOS 适合您。
- 如果您每个硬盘或分区的容量小于 2TB，那么您可以使用 BIOS。
- BIOS 允许在不更改任何设置的情况下运行多个操作系统。从现代的角度来看，这可能是一个安全问题，但对用户来说没有麻烦。
- BIOS 向操作系统提供系统信息。因此，如果您的操作系统以 16 位模式运行，它不需要编写与硬件交互的代码。它可以直接使用 BIOS 提供的方法。否则，如果操作系统切换到 32 位或 64 位模式，则需要提供自己的与硬件交互的子程序。
- 如果您更喜欢使用键盘和基于文本的界面而不是使用鼠标和图形用户界面的导航，那么 BIOS 适合您。

UEFI 考虑到了这些限制，并提供了传统模式（Legacy mode）。在该模式下，您可以像拥有 BIOS 固件一样运行所有内容。但请记住，英特尔已宣布从 2020 年起将不再支持传统 BIOS。

以下是一个简化的表格，展示了UEFI和BIOS之间的主要对比结果：

|                  | UEFI                                                         | BIOS                                   |
| ---------------- | ------------------------------------------------------------ | -------------------------------------- |
| 基本概念         | 统一可扩展固件接口                                           | 基本输入输出系统                       |
| 数据存储方式     | 数据存储在非易失性存储器中，以.efi文件形式组织               | 数据直接存储在ROM中                    |
| 启动速度         | 更快，使用更高效的算法和数据结构                             | 较慢，受限于16位代码和存储限制         |
| 硬盘容量支持     | 支持高达9泽它字节的驱动器大小                                | 仅支持最大2.2太字节的硬盘              |
| 用户界面         | 提供图形用户界面（GUI），支持鼠标导航                        | 通常仅提供基于文本的界面，支持键盘导航 |
| 安全功能         | 支持安全启动（Secure Boot），防止未经授权/未签名的应用程序启动 | 不具备或仅具备有限的安全功能           |
| 代码模式         | 以32位或64位模式运行                                         | 以16位模式运行                         |
| 模块化与可扩展性 | 支持模块化设计，易于更新和扩展                               | 较为封闭，更新和扩展较为困难           |
| 未来支持         | 逐渐成为主流，英特尔已宣布不再支持传统BIOS                   | 传统BIOS正在逐渐被UEFI取代             |

>  请注意，这个表格是对UEFI和BIOS之间主要区别的简化概述，并未涵盖所有细节。在实际应用中，两者之间可能还存在其他差异和特性。
>  

是时候进入正题了！

## **UEFI？**

前面我们知道了由于传统BIOS的局限性，人们开发了一种新标准，**称为UEFI（通常简称为“EFI”）**。UEFI执行传统BIOS曾经执行过的相同任务（以及更多任务），但接口（标准，“API”）不同。

**我们现在有了一个专用的分区，它足够大，可以包含整个操作系统的引导加载程序**，因此我们不必将多个部分连接在一起，而无需使用微小的引导扇区。

UEFI还为我们提供了网络引导、安全启动等安全功能。

>  UEFI 不是 BIOS
>  

有时使用的术语“UEFI BIOS”是不正确的（即使我的主板制造商华硕也使用它），因为 UEFI 和 BIOS 都是固件的子类型——即它们是独立、不同、独立的固件标准：

![img](https://pica.zhimg.com/v2-8b4d27b5e8220ac889715069493062a4_1440w.jpg)

### **UEFI概念**

统一可扩展固件接口（UEFI）是一种现代固件接口，它取代了个人计算机上的传统BIOS（基本输入输出系统）。UEFI作为操作系统与计算机硬件组件之间的关键纽带，促进了初始化过程，并为操作系统与系统固件之间的交互提供了标准化方式。

与旧版BIOS相比，UEFI提供了多项优势，包括支持更大容量的存储设备、更快的启动速度、增强的安全功能和更友好的用户界面。开发UEFI的主要动机之一是克服BIOS的局限性，并为固件开发提供一个更加灵活和可扩展的平台。

![img](https://pic3.zhimg.com/v2-8e50402ca68091ec20a8cbaaa5f1d294_1440w.jpg)

为了更好地理解UEFI，我们可以考虑一个涉及计算机启动过程的例子。在配备UEFI固件的系统中，当计算机通电时，启动过程开始。UEFI固件控制系统并启动加电自检（POST），这是一个诊断过程，用于检查硬件组件的完整性。POST成功完成后，UEFI固件会查找可启动设备。

在UEFI系统中，固件与UEFI启动管理器交互，后者是一个负责加载操作系统的软件组件。启动管理器会查阅UEFI启动变量，这些变量包含有关可用启动选项及其优先级的信息。这些变量存储在非易失性存储器中，用户或系统管理员可以对其进行修改以自定义启动配置。

假设计算机在固态硬盘（SSD）上安装了操作系统。UEFI固件在启动管理器的帮助下，定位SSD上EFI系统分区（ESP）中存储的UEFI引导加载程序。UEFI引导加载程序是一个小程序，它了解文件系统并知道如何将操作系统内核加载到内存中。

一旦UEFI引导加载程序加载了操作系统内核，控制权便转移给操作系统，并向用户呈现用户界面。在整个过程中，UEFI促进了硬件与软件之间的通信，确保了顺畅且高效的启动体验。

因此，UEFI是一种关键的固件接口，为固件开发提供了标准化和可扩展的框架，从而实现了性能提升、对大容量存储设备的支持以及增强的安全功能。从BIOS到UEFI的转变标志着系统固件发展的一次重大进步。

### **EFI 系统分区**

作为 Windows 用户，您可能已经注意到有一个神秘的“系统保留”分区：

![img](https://pic3.zhimg.com/v2-8235681e522bd4dbffea1a9d596478be_1440w.jpg)

这是 ESP（EFI 系统分区）——一个用于启动符合 EFI 的系统的分区。

ESP 通常是一个采用 FAT32 格式化的分区，最小空间为 100MB，一些指南建议为 512MB。

该分区包含 **EFI 应用程序**，这些应用程序通常位于自己的目录中。可能包含多个 EFI 应用程序，因为您可能安装了多个操作系统。**在我的思维模型中，我将这些目录视为每个操作系统的“插槽”。**

如果您想的话，可以使用基本的 Linux 内置工具（如 、

 mkfs.fat -F 32）从头开始创建此分区。只需确保将分区类型设置为 EFI 系统即可！

幸运的是，ESP 并不神奇——它只是一个包含文件的分区，并且某些文件路径具有特殊含义（如果未指示启动选择，则默认启动的 EFI 应用程序）。

### **EFI 变量**

EFI（Extensible Firmware  Interface，可扩展固件接口）是现代计算机系统中用来替代传统BIOS的一种新标准。在EFI的世界里，有一些特别的“变量”被存储在主板的非易失性随机访问存储器（NVRAM）中。这些变量就像是电脑的小记事本，存储着一些重要的设置和信息。

其中，有一个特别重要的变量叫做“默认启动项”（“BootCurrent”），它就像是一个指针或者地址，指向了另一个变量。这个被指向的变量呢，其实就是一个具体的启动项，里面包含了要启动的EFI应用程序（比如操作系统）的完整路径，就像是你手机上的某个APP的存储位置一样。

不仅如此，这些启动项变量还很贴心，它们还能额外存储一些参数，就像是你打开APP时可以设置的一些选项。对于Linux系统来说，有一个特别的EFI应用程序叫做EFI  stub，它可以直接从EFI环境启动Linux内核，而不需要传统的引导加载程序（如GRUB）。在这个场景下，EFI变量里就会包含Linux内核启动时需要的一些命令行参数，比如指定根文件系统所在的分区。而如果使用GRUB这样的引导加载程序，这些参数就会写在GRUB的配置文件中，而不是EFI变量里。

最棒的是，这些EFI变量是可以从操作系统内部直接修改的，这意味着，如果你想改变启动顺序或者添加新的启动项，不再需要像以前那样重启电脑，然后进入BIOS设置界面去操作了。你只需要在操作系统里找到相应的工具或命令，就可以轻松完成这些任务，大大简化了操作过程。

### **EFI 的启动过程**

![img](https://pic2.zhimg.com/v2-619d71d4cb1f530eb42bf5acf89c7363_1440w.jpg)

主板的固件基本上总是存储在闪存中（这样它就可以被升级）。EFI 变量的存储也需要闪存，因为如果它们不能被更改，那么它们就称不上是真正的“变量”。

### **EFI 变量的影响**

让我们用更简单的语言来解释关于EFI变量的一些关键点：

### **EFI变量是什么？**

EFI（现在常被称为UEFI，即统一可扩展固件接口）变量是存储在计算机中的小数据块，它们包含了一些重要的设置和信息，比如启动时的配置参数、操作系统需要的特殊指令等。这些变量对于确保计算机和操作系统能够顺利启动和运行非常重要。

### **为什么EFI变量会影响驱动器和新主板的兼容性？**

当你把一个硬盘（我们称之为驱动器）从一台电脑换到另一台时，可能会遇到问题。这是因为每台电脑的主板（负责计算机启动和硬件交互的核心部件）上都有自己的EFI变量。这些变量里可能包含了一些特定的设置或参数，是启动操作系统时必需的。如果新主板没有这些特定的设置，那么系统可能无法正常工作。

### **Linux EFI stub是个啥？**

Linux EFI stub是一个特殊的启动方式，它允许Linux内核直接作为EFI应用程序来启动，而不需要传统的启动加载器（如GRUB）。虽然这听起来很酷，但它需要一些额外的参数来告诉内核如何启动，这些参数就存储在EFI变量中。

你可能会想，为什么不把所有的EFI变量都放在驱动器上的一个地方（比如ESP）呢？这样换电脑时不是更方便吗？但实际上，这样做会有安全风险，因为驱动器可以被随意更换，如果它决定了计算机的启动方式，那就可能被恶意利用。所以，EFI变量大部分还是存储在主板上的一个特殊区域（NVRAM），这样更安全。

不同的主板制造商可能会用不同的方式来存储EFI变量，这意味着它们的格式可能不同。对于大多数用户来说，这不是问题，因为操作系统和EFI固件会处理这些细节。但是，如果你在虚拟机或特殊环境中工作，并需要手动设置这些变量，那就可能会遇到麻烦，因为你需要知道如何与特定主板的EFI固件交互。

EFI变量是计算机启动过程中的重要部分，它们包含了启动系统所需的关键信息和设置。由于这些变量可能依赖于特定的主板和固件，所以在更换硬件或进行特殊配置时需要格外注意。对于大多数用户来说，这些变量是自动管理的，但了解它们的工作原理可以帮助你更好地理解和解决启动问题。

## **UEFI的架构**

UEFI的设计是建立在几个关键概念之上的：

1. **利用现有的“表格式”接口**：为了节省大家在操作系统和固件上已经投入的时间和资源，UEFI采用了许多现有的标准。这些标准在支持特定处理器的平台上很常见。如果你想要你的平台符合UEFI的标准，那么你就需要实现这些标准。简单来说，UEFI没有从头开始创造新的东西，而是把大家已经熟悉的、好用的东西整合了进来。（更多细节，你可以查看参考资料。）
    
2. **系统分区**：系统分区就像是一个特殊的区域，它有一个特别的文件系统。这个区域可以让不同的公司或组织安全地共享数据，同时满足不同的需求。有了这个系统分区，我们可以在不增加太多额外存储空间需求的情况下，让平台变得更加强大和灵活。
    
3. **启动服务**：启动服务就像是在启动电脑时提供的一些工具和接口，它们可以帮助我们更好地使用设备和系统功能。这些服务通过“句柄”和“协议”来与设备交互，这样我们就可以更容易地使用现有的BIOS代码，而不需要担心具体的实现细节。
    
4. **运行时服务**：这些服务是在电脑正常运行时提供的。它们确保操作系统可以轻松地访问和使用平台的基本硬件资源。这些服务被设计成非常基础且必要的，以确保操作系统的稳定运行。
    

下面的图表展示了UEFI的主要部分，以及它们与平台硬件和操作系统软件之间的关系。

![img](https://pic2.zhimg.com/v2-fb7406105d16c2e9973479a66180992b_1440w.jpg)

本图展示了符合UEFI规范的系统各组件之间的交互，这些组件用于完成平台和操作系统的启动。

平台固件能够从系统分区中获取操作系统加载程序映像。该规范支持多种大容量存储设备类型，包括磁盘、CD-ROM和DVD，以及通过网络进行远程启动。通过可扩展的协议接口，可以添加其他启动媒体类型。

一旦启动，操作系统加载程序将继续引导完整的操作系统。

![img](https://pic1.zhimg.com/v2-638e57ca0edafb2ad3d4c5e00dffee80_1440w.jpg)

**第一段**：  UEFI让平台固件变得更加强大，方法是通过加载UEFI驱动程序和应用程序。一旦这些驱动程序和应用程序被加载，它们就可以使用UEFI提供的所有运行时和启动服务。这就像给你的电脑平台固件增加了很多新功能，而这些新功能都是按照UEFI的规则来运行的。你可以看看上面的启动顺序图，它展示了这一切是如何工作的。

**第二段**：  UEFI还做了一件很酷的事情，它把操作系统加载程序和平台固件的启动菜单合并成了一个统一的平台固件菜单。这样，你就可以在这个菜单里选择任何支持UEFI启动服务的启动介质上的任何分区上的UEFI操作系统加载程序。UEFI操作系统加载程序还可以在用户界面上显示多个选项，让你有更多的选择。而且，如果你还想用老式的启动方式（比如从A盘或C盘启动），UEFI也支持在平台固件启动菜单中加入这些选项。

**第三段**：  UEFI支持从包含UEFI操作系统加载程序或UEFI定义的系统分区的介质启动。如果你想从硬盘这样的块设备启动，那么UEFI要求必须有一个UEFI定义的系统分区。不过，UEFI并不会改变分区的第一个扇区，这意味着你可以创建一种既能在老式架构上启动，又能在UEFI平台上启动的介质。这样，无论你的电脑支持哪种启动方式，你都可以轻松地使用它。

都到这里了，那就再好好多聊聊启动。

## **UEFI启动**

![img](https://pic4.zhimg.com/v2-b4303810d6fdb244251d9bd38133d893_1440w.jpg)

UEFI 包含六个主要的启动步骤，这些步骤在平台的启动和初始化过程中都扮演着至关重要的角色。所有这些步骤加在一起，我们通常称之为“平台初始化”（Platform Initialization，简称 PI）。

下面我会简要介绍每个阶段，希望能帮助您对这个过程有一个基本的了解。

>  DXE 和 RT 这两个阶段，对于初学者比较重要。
>  

非常抱歉，我之前的翻译中可能存在一些不够准确的地方。让我再次尝试，确保每个阶段的描述都更加准确：

**安全阶段（SEC）**  这是UEFI启动流程的首要阶段，主要用于：初始化一个临时的内存存储区域，作为系统信任链的起点，并向Pre-EFI初始化（PEI）阶段提供必要的信息。这个信任链的起点确保了在平台初始化（PI）过程中执行的任何代码都经过加密验证（即数字签名），从而建立一个“安全启动”的环境。

**Pre-EFI初始化阶段（PEI）** 这是启动流程的第二阶段，它仅利用CPU当前的资源来调度Pre-EFI初始化模块（PEIM）。这些模块负责执行关键的启动操作初始化，如内存初始化，同时也允许将控制权传递给驱动程序执行环境（DXE）。

**驱动程序执行环境（DXE）** 在DXE阶段，系统的大部分初始化工作都会发生。在PEI阶段，DXE操作所需的内存已经被分配和初始化。当控制权传递给DXE时，DXE调度器会被激活。调度器负责加载和执行硬件驱动程序、运行时服务和任何操作系统启动所需的启动服务。

**启动设备选择（BDS）** 一旦DXE调度器完成了所有DXE驱动程序的执行，控制权就会传递给BDS。这个阶段负责初始化控制台设备和任何剩余的必需设备。然后，它会加载并执行选定的启动项，为瞬态系统加载（TSL）阶段做准备。

**瞬态系统加载（TSL）** 在这个阶段，PI流程处于启动设备选择和将控制权移交给主操作系统之间的过渡阶段。此时，可能会调用一个应用程序（如UEFI  shell），或者（更常见的是）运行一个引导加载程序来准备最终的操作系统环境。引导加载程序通常负责通过调用ExitBootServices()来终止UEFI启动服务。但是，操作系统本身也可以执行这一操作，比如带有CONFIG_EFI_STUB的Linux内核。

**运行时（RT）** 这是最后的阶段，也是操作系统接管系统的时刻。尽管此时UEFI的启动服务已经不再可用，但UEFI的运行时服务仍然保留给操作系统使用，例如用于查询和写入NVRAM中的变量。

**系统管理模式（SMM）** SMM是一个与运行时阶段分开存在的模式，它可以在SMI（系统管理中断）被触发时进入。然而，在这个介绍中，我们不会深入讨论SMM。

### **UEFI 启动 Flow (Windos)**

![img](https://pic3.zhimg.com/v2-7fd7d96098ef2567ccf6391048f89a9e_1440w.jpg)

以下是Windows计算机启动的顺序阶段：

1. 预启动（PreBoot）

计算机的固件启动加电自检（POST），并加载固件设置。当检测到有效的系统磁盘时，此预启动过程结束。固件读取主引导记录（MBR），然后启动Windows启动管理器。

1. Windows启动管理器

Windows启动管理器在Windows启动分区上查找并启动Windows加载程序（Winload.exe）。

1. Windows操作系统加载程序

加载启动Windows内核所必需的基本驱动程序，然后内核开始运行。

1. Windows NT操作系统内核

内核将系统注册表配置单元和标记为BOOT_START的其他驱动程序加载到内存中。

内核将控制权传递给会话管理器进程（Smss.exe），该进程初始化系统会话，并加载和启动未标记为BOOT_START的设备和驱动程序。

![img](https://pica.zhimg.com/v2-418a6882f6ff40075b53d4df0391b106_1440w.jpg)

从内核（ntoskrnl.exe）到执行LogonUi.exe（提示用户交互的进程）的Windows启动过程的简化版本。它被分为五个步骤。

1. **加载操作系统内核**
    
2. **初始化内核**
    
3. **启动子系统**
    
4. **启动会话0**
    
5. **启动会话1**
    

>  就不详细展开了。想了解，点个赞，下次咱们聊。
>  

### **UEFI 启动 Flow (Linux)**



![img](https://picx.zhimg.com/v2-627d775040dd6dd09544669227678a61_1440w.jpg)

 你是否曾经好奇过，当你按下Linux机器的电源按钮时，背后发生了什么？

1️⃣ BIOS + UEFI

- 基本输入输出系统（BIOS）或统一可扩展固件接口（UEFI）是计算机开机时首先运行的程序，负责硬件的初始化以及从选定的启动设备加载引导加载程序。

2️⃣ 主引导记录（Master Boot Loader, MBR）

- MBR是硬盘的第一个扇区，包含了用于加载操作系统引导加载程序（如GRUB）的指令。

MBR（主引导记录）是硬盘的初始（主要）扇区，它标识了操作系统的位置，以完成启动过程。

MBR的位置取决于您的硬件，它可能位于/dev/hda或/dev/sda。

它是一个512字节的映像，包含代码以及一个简短的分区表，这些都有助于加载/执行GRUB（引导加载程序）。

3️⃣ 引导加载程序（Boot Loader）

- 引导加载程序（如GRUB）负责加载操作系统内核到内存中。它允许用户选择启动哪个操作系统（如果安装了多个的话）。

Linux有多个引导加载程序，其中最常见的是GRUB和LILO，而GRUB2是最新版本之一。

当你启动计算机时，通常首先看到的是GRand Unified Boot loader（GRUB）。

它由一个简单的菜单组成，该菜单使用键盘显示选项，以便你选择要启动的内核（如果你安装了多个内核映像）。

在双系统启动时，GRUB2允许你选择要启动的操作系统。

![img](https://pic3.zhimg.com/v2-b3e3d034c5dbedff6d2858f48edf30b0_1440w.jpg)

4️⃣ 内核（Kernel）

- 内核是操作系统的核心，负责管理硬件、提供基本服务（如进程调度、内存管理等），并作为用户程序与硬件之间的桥梁。



![img](https://pic4.zhimg.com/v2-5bb9100b194f4aa88fd274bca2f55641_1440w.jpg)

 内核完全控制你系统中的一切，因此被称为操作系统的核心。

内核是自解压的，并以压缩格式存储以节省空间。

一旦选定的内核被加载到内存中并开始执行，它会在执行任何有用任务之前先解压自己。

一旦由引导加载程序加载，内核会挂载根文件系统并初始化/sbin/init程序，该程序通常被称为init。

5️⃣ 初始RAM磁盘-initramfs镜像

- initramfs是一个在内核启动过程中被挂载为根文件系统的临时内存文件系统。它包含了启动过程中内核所需的驱动程序和脚本。

初始RAM磁盘是一个初始/临时的根文件系统，它在真正的根文件系统可用之前被挂载。

这个initramfs映像嵌入在内核中，并包含挂载真正根文件系统所需的最小二进制文件、模块和程序。

6️⃣ /sbin/init（也称为init）[父进程]

- init是系统启动后运行的第一个用户空间程序，它是所有其他用户空间进程的父进程。它负责启动系统上的其他进程，并根据配置文件（如/etc/inittab或systemd的配置）设置运行级别。

一旦加载，init是内核首先执行的命令之一。

这个程序管理剩余的启动过程，并为用户设置环境。

基本上，在这个阶段，系统会执行在系统初始化期间所需的一切操作：检查文件系统、配置时钟、初始化串行端口等。

除了启动系统外，init命令还有助于保持系统正常运行并正确关闭系统。

7️⃣ 使用Getty的命令行界面

- Getty是一个用于打开文本登录会话的程序。在系统启动后，它会为每个终端或虚拟控制台启动一个登录会话。

Getty是“get tty”（tty-电传打字机）的缩写，它是一个在主机上运行的UNIX程序，用于管理物理或虚拟终端。

Getty会打开TTY行，设置它们的模式，打印登录提示符，获取用户名，然后为用户启动登录过程。

之后，用户在通过身份验证后可以开始使用系统。

8️⃣ systemd

- systemd是现代Linux系统上的系统和服务管理器，负责初始化系统、管理系统服务、启动守护进程等。它取代了传统的init系统，并提供了更丰富的功能和更好的性能。

上述提到的顺序启动方法相当传统，属于UNIX的System V变体，之后发生了用systemd替代systemv这一有争议的事件。

一方面，SysVinit（传统的init系统-System V）遵循顺序过程；另一方面，systemd则利用了现代多处理器/多核计算机的并行处理能力。

>  注意：systemd在加载后由内核初始化，之后systemd启动所需的依赖项并处理其余部分。
>  

systemd通过同时/并行启动多个进程来简化启动过程并缩短启动时间。

9️⃣ X Windows系统

- X Windows系统（现在通常被称为[http://X.org](https://link.zhihu.com/?target=http%3A//X.org) Server）是Linux上广泛使用的图形服务器，它负责显示图形用户界面（GUI）。在X Windows系统启动后，用户可以运行图形应用程序，并通过鼠标和键盘与系统进行交互。

X Windows系统是一个开源的客户端-服务器系统，它实现了窗口化的图形用户界面（GUI）。

它也被称为X；它为GUI环境提供了基本结构，包括在显示设备上绘制和移动窗口的能力，以及与鼠标和键盘通信的能力。

Linux的启动过程非常灵活且不断改进，支持广泛的处理器和硬件平台。上述列出的所有内容并不一定完全准确地描述了您机器的启动过程；有些阶段甚至可以通过一些调整来跳过。

到这里，你说我们这搞安全的不聊几句关于安全启动的，好像说不过去。

## **UEFI安全启动**

**安全启动、Windows与密钥管理**

**UEFI（统一可扩展固件接口）规范**核心定义了一个称为**安全启动**的固件执行认证流程。作为行业标准，安全启动详细规定了平台固件如何管理证书、验证固件，以及操作系统如何与此验证过程进行交互。

**安全启动**基于**公钥基础设施（PKI）流程，在允许任何模块执行前，先对其进行严格认证。这些模块广泛包括固件驱动程序、选项ROM、磁盘上的UEFI驱动程序、UEFI应用程序或UEFI引导加载程序。通过执行前的镜像认证机制，安全启动有效降低了如rootkit等预启动恶意软件攻击的风险。在Windows 8及更高版本中，微软依赖于UEFI安全启动作为其可信启动安全架构**的关键组成部分，旨在为客户提升平台安全性。

**对于Windows 8及更高版本的客户端PC，以及Windows Server 2016，安全启动是强制要求**的，这一规定明确体现在Windows硬件兼容性要求中。

**安全启动流程的工作原理简述如下**（如图1所示）：

1. **固件启动组件**：固件首先验证操作系统加载程序（如Windows或其他受信任的操作系统）的可信度。
    
2. **Windows启动组件**：包括BootMgr、WinLoad及Windows内核启动过程。这些组件会逐一验证各自组件的签名。任何未通过验证的组件将被阻止加载，并触发安全启动修复机制。
    
3. **防病毒与反恶意软件软件初始化**：此阶段会检查这些软件是否拥有微软颁发的特殊签名，以确保其为受信任的关键启动驱动程序，并在启动过程中尽早启动。
    
4. **关键启动驱动程序初始化**：WinLoad在执行安全启动验证时，会检查所有关键启动驱动程序的签名。
    
5. **其他操作系统初始化**
    
6. **Windows登录屏幕**
    

![img](https://pic1.zhimg.com/v2-6176a64cb3dca49fdd0cbbdeb6fe239e_1440w.jpg)

**UEFI安全启动的实施**是微软自Windows 8.1以来引入的**可信启动架构**的重要一环。随着恶意软件漏洞利用技术的不断发展，将启动路径作为首选攻击向量的趋势日益明显。

由于恶意软件能够阻止防病毒产品完全加载，从而使其失效，因此这类攻击尤为难以防范。然而，通过Windows可信启动架构及其与安全启动共同建立的**信任根**，客户可以确保在操作系统本身加载之前，仅有经过签名和认证的“已知良好”代码及引导加载程序能够执行，从而有效防止启动路径中的恶意代码执行。

## **UEFI的资料**

最后分享一点资料。资料太多，反而会选择困难症状，所以我就各推荐一个吧，用于系统学习、小部分了解、以及实际 操作。

### **文档**

- UEFI/2.10：[https://uefi.org/specs/UEFI/2.10/02_Overview.html](https://link.zhihu.com/?target=https%3A//uefi.org/specs/UEFI/2.10/02_Overview.html)

### **博客**

- 知乎：老狼

### **实操**



![img](https://pica.zhimg.com/v2-448304d1e58a6a0d635cb79c064750b8_1440w.jpg)

 英特尔最初发布了原始EFI规范的开源实现，即EFI开发工具包（EDK）。在UEFI和PI的开发过程中，这个开源项目继续发展为EDK2。该项目的主要目标是针对固件开发人员开发、测试和调试UEFI驱动程序、可选ROM和应用程序。

推荐的开发工具的简短列表：

- EDK2

首先是EDK2项目，它被描述为“一个现代的、功能丰富的、跨平台的固件开发环境，用于[[http://www.uefi.org](https://link.zhihu.com/?target=http%3A//www.uefi.org)]的UEFI和PI规范。”EDK2项目由许多同样为UEFI规范做出贡献的同一批人（以及社区志愿者）开发和维护。

这非常有帮助，因为EDK2保证包含最新的UEFI协议（假设您使用的是主分支）。除此之外，还有无数高质量的项目供您参考。一个例子是开放虚拟机固件（OVMF）。这是一个旨在为虚拟机提供UEFI支持的项目，它的文档非常齐全。

EDK2的一个主要缺点是第一次设置构建环境的过程——这是一个漫长而艰巨的过程，即使他们有“开始使用EDK2”指南尽可能简化这个过程，对于新手来说仍然可能感到困惑。

- VisualUefi

VisualUefi项目旨在允许在Visual Studio内部进行EDK2开发。我们建议您开始开发时，使用EDK2命令行中的构建工具而不是这个项目，以让您熟悉平台。

此外，VisualUefi提供的头文件和库是完整EDK2库的一个子集，因此您可能会发现您需要的不是所有东西都容易获取。然而，与EDK2相比，它的设置要简单得多，因此通常受到热衷于使用Visual Studio的用户的青睐。

- 调试

关于调试，有几个选项可供您选择，每个选项都有其优缺点。这些将在下面列出，您最喜欢哪一个由您自己决定。在本系列的第二部分中，我们将向您展示如何调试一个示例驱动程序，所以在此之前，您可能想要安装所有这些（或者一个也不安装！）以帮助您做出明智的决定： + QEMU -  一个多平台模拟器（尽管在Linux上最好），由于它是一个模拟器而不是虚拟机，因此提供了最好的调试设施。它的设置相当复杂，而且与它的同类相比，它也相当慢。 + VirtualBox - 一个好的多平台解决方案，除了由于非易失性随机存取存储器（NVRAM）仿真相当差劲而遭受内存丢失的问题。 +  VMware -  提供良好的性能和正确工作的NVRAM仿真。如果客户机和主机都是Windows，它与WinDbg配合使用进行TSL和RT阶段的调试效果非常好。

------

写长文的缺点就是，有时候一个点聊的尽兴了，容易那部分变得臃肿。都知道缺点了，改正应该就不远了。

AnyWay，下次聊！

## [来，一块来了解下PCIe Switch](https://zhuanlan.zhihu.com/p/11888184041)

[![树哥谈芯](https://pic1.zhimg.com/50/v2-3507a92ef3d891319e8e53df6d794dfb_l.jpg?source=b6762063)](https://www.zhihu.com/people/conv-43)

[树哥谈芯](https://www.zhihu.com/people/conv-43)

前沿智能探索者/芯片领域践行者

54 人赞同了该文章

![来，一块来了解下PCIe Switch](https://picx.zhimg.com/v2-d926efef29c9e8658df35a2a90d65ff3_720w.jpg?source=7e7ef6e2&needBackground=1)

【按】曾经就在去年，以博通SS26为代表的PCle Switch芯片需求异常多，不仅现货少，报价还从**5500美元飙到20000美元**！这是个什么鬼，我们一块来看看

![img](https://pic3.zhimg.com/v2-34dc2ba0b72a398d60bfe4c0108e5010_1440w.jpg)

在今天的信息化和智能化社会，PCIe（Peripheral Component Interconnect Express）技术已经成为计算机硬件中不可或缺的一部分。PCIe (Peripheral  Component Interconnect Express)  ，简称PCI-E，官方简称PCIe，是继ISA和PCI总线之后的第三代I/O总线，是一种设备高速连接标准，具备数据传输速率高，抗干扰能力强，传输距离远，功耗低等优点。

PCIe  Switch，顾名思义，是一种硬件设备，它在PCIe总线中扮演着交通枢纽的角色。它不仅可以扩展系统的连接能力，允许多个设备通过单个PCIe端口接入，还能实现设备间的数据交换和通信。在高性能计算、服务器集群、数据中心等场景中，PCIe Switch的作用愈发凸显。

## ① PCIe总线的拓扑结构

PCIe采用的是树形拓扑结构， 一般由根组件(Root Complex)，交换设备(Switch)，终端设备(Endpoint)等类型的PCIe设备组成

Root Complex: 根桥设备，是PCIe最重要的一个组成部件； Root Complex主要负责PCIe报文的解析和生成。RC接受来自CPU的IO指令，生成对应的PCIe报文，或者接受来自设备的PCIe TLP报文，解析数据传输给CPU或者内存。

Switch: PCIe的转接器设备，目的是扩展PCIe总线。和PCI并行总线不同，PCIe的总线采用了高速差分总线，并采用端到端的连接方式,  因此在每一条PCIe链路中两端只能各连接一个设备，  如果需要挂载更多的PCIe设备，那就需要用到switch转接器。switch在linux下不可见，软件层面可以看到的是switch的上行口（upstream port， 靠近RC的那一侧) 和下行口(downstream port)。

一般而言，一个switch 只有一个upstream port， 可以有多个downstream port.

PCIe endponit: PCIe终端设备，是PCIe树形结构的叶子节点。比如网卡，NVME卡，显卡都是PCIe ep设备。



![img](https://pic2.zhimg.com/v2-85666f60fd70572e397a747bb484ba81_1440w.jpg)

全球PCIe交换芯片（PCIe Switch）核心厂商包括Broadcom、Microchip和Texas  Instruments等，前三大厂商占有全球大约80%的份额。亚太是最大的市场，占有大约75%的份额。产品类型而言，PCIe  3.0是最大的细分，占有大约47%的份额。就下游来说，企业级是最大的下游领域，占有约45%的份额。

 根据不同产品类型，PCIe交换芯片细分为：PCIe 2.0、PCIe 3.0、PCIe 4.0、PCIe 5.0、PCIe 6.0

## ② PCIe Switch芯片

PCIe Switch，即PCIe开关或PCIe交换机，主要作用是实现 PCIe 设备互联，像服务器要实现CPU、GPU等组件互联，就离不开它。

有了PCle Switch，PCle从端对端的连接，变成多条总线连接，有效拓展了链路，形成一个高速的PCIe互联网络，从而实现多设备通信。

PCle Switch的高可拓展性、低功耗、低延迟、高可靠性、高灵活性等优势，使之广泛应用于机器学习、人工智能、超融合部署和存储系统中。



![img](https://pica.zhimg.com/v2-47a9c3ad75fbd27c28c488329204d8d8_1440w.jpg)

英伟达A100、H100等GPU可以分PCle和NVLink两种版本，GPU互联时用的是不同通道。PCle版本的GPU互联便是通过PCIe通道完成的，借助PCIe switch，系统可以实现CPU-GPU，GPU-GPU的连接。

## ③ PCIE Switch内部结构图



![img](https://picx.zhimg.com/v2-947704a4472775bbbdfd4db52bedeb87_1440w.jpg)

## ④ PCIe Switch的六大核心功能

**连接多个设备**：PCIe Switch打破了传统的一对一连接方式，允许多个设备同时连接到主机系统，极大地扩展了系统的连接性。



![img](https://pic4.zhimg.com/v2-f932f30b40528aa18ea99517648698f1_1440w.jpg)

**数据交换**：在PCIe Switch的支持下，设备之间可以直接进行数据传输，无需经过主机处理器，从而提高了数据传输效率。



![img](https://pic1.zhimg.com/v2-17f088956f9219f9c6973ed1867cbd9c_1440w.jpg)

**动态分配**：PCIe Switch支持带宽和资源的动态分配。根据设备的需求和系统的负载情况，它可以实时调整设备间的通信速率和优先级，确保数据传输的顺畅进行。

**NTB（Non-Transparent Bridge）**技术：NTB技术使得两个或多个系统之间能够直接通信，无需经过中间转换设备。这不仅提高了数据传输的效率，还降低了系统复杂性。



![img](https://pica.zhimg.com/v2-333b84e64317aa91a6742c5a98e9faf0_1440w.jpg)

**Peer to Peer通信**：Peer to Peer通信模式使得设备之间可以直接进行数据交换，无需通过主机系统。这种通信方式减少了数据传输的延迟，提高了系统的响应速度。



![img](https://picx.zhimg.com/v2-d37de91ea0adcfb0726066a72adf4841_1440w.jpg)

**IO虚拟化支持**：PCIe Switch支持多根IO虚拟化（MRIOV）和单根IO虚拟化（SRIOV）。MRIOV允许多个根端系统共享单个PCIe设备，而SRIOV则允许单个PCIe设备被划分为多个虚拟功能，实现资源的灵活分配和管理。

## ⑤PCIe Switch的详细工作原理



![img](https://pic2.zhimg.com/v2-a8ec40576640c581199de37727e0696d_1440w.jpg)

要了解PCIe Switch的工作原理，我们首先需要了解Virtual Switch的概念。Virtual Switch是将一个物理PCIe  Switch划分为多个虚拟Switch，实现多个Host共用一个Switch的功能。这些Virtual  Switch之间互不干扰，保证了数据传输的安全性和稳定性。

在配置方面，Virtual Switch可以是静态的也可以是动态的。静态配置需要在BIOS枚举前完成初始化，而动态分配则可以根据系统的实时需求进行带宽和资源的调整。动态分配的实现需要确保在修改配置时，相关的设备处于停止状态，以避免数据丢失或系统崩溃。

Peer to Peer通信是PCIe Switch内部实现高效数据传输的关键技术。通过卸载CPU和RAM之间的压力，Peer to Peer通信使得设备间可以直接进行数据传输，从而提高了数据传输的效率和系统的响应速度。



![img](https://pic2.zhimg.com/v2-b250e27dbec907df006240cfa87293e3_1440w.jpg)

## ⑥PCIe桥接器与NTB：连接世界的桥梁

PCIe桥接器是一种用于连接和转发PCI Express总线的设备。它可以将不同的PCIe总线连接起来，实现设备之间的通信和数据交换。在复杂的系统架构中，PCIe桥接器扮演着至关重要的角色。

NTB（Non-Transparent  Bridge）是PCIe桥接器的一种特殊类型。它允许两个主机系统通过PCIe总线进行直接通信，无需经过任何中间设备。NTB技术通过将每个主机呈现为对另一个主机的设备，实现了主机间的透明通信。这使得远程机器可以生成中断、访问内存范围以及执行直接内存访问（DMA）等操作，极大地提高了数据传输的效率和灵活性。



![img](https://picx.zhimg.com/v2-3abed8044ffaa0158ef14d5550308501_1440w.jpg)

在SoC（System on a  Chip）配置中，NTB技术得到了广泛应用。通过配置具有多个PCI端点（EP）实例的SoC，NTB功能可以将一个EP控制器的事务路由到另一个EP控制器，从而实现HOST1和HOST2之间的通信。这种通信方式不仅提高了数据传输的效率，还降低了系统的复杂性和成本。

## ⑦SR-IOV：虚拟化环境中的性能利器

SR-IOV（Single Root I/O Virtualization）是一种用于提高虚拟化环境中网络和存储设备性能的技术。在虚拟化环境中，多个虚拟机共享物理资源，而SR-IOV技术则允许单个物理设备在多个虚拟机之间共享，同时保持高性能和低延迟。



![img](https://pica.zhimg.com/v2-16608bfc603c782cf00ae469f9dec098_1440w.jpg)

SR-IOV通过在物理设备上创建多个虚拟功能（Virtual  Functions，VFs）来实现资源的共享。每个VF都可以被分配给一个虚拟机，使得虚拟机可以直接访问物理设备，绕过虚拟交换机和虚拟机监视器（如Hypervisor）。这种直接访问的方式减少了数据传输的延迟，提高了系统的响应速度。

SR-IOV技术的优势在于它提供了更高的I/O性能和更低的延迟。由于虚拟机可以直接访问物理设备，无需经过额外的虚拟化层，因此数据传输的效率得到了显著提升。此外，SR-IOV还支持热插拔和动态资源分配，使得系统可以根据实际需求进行灵活的资源配置和管理。

在实际应用中，SR-IOV技术已经广泛应用于各种虚拟化场景，如云计算、大数据处理等。通过利用SR-IOV技术，企业可以构建更高效、更灵活的IT基础设施，



![img](https://pic3.zhimg.com/v2-d105b2216cb843664f20c472cedfda84_1440w.jpg)

## ⑧选择PCIe Switch时考虑


**1. 带宽和通道数**
选择 PCIe 互连交换机时，主要考虑因素是带宽和通道数。最先进的交换机提供 256 个通道，总带宽为 2,048  GB/s，为高速数据传输和可扩展性奠定了坚实的基础。此设置支持多个设备并确保它们之间的高效通信，减少瓶颈并提高整体系统性能。根据 PCI-SIG 的报告，PCIe 5.0 标准每通道支持高达 32 GT/s，显着提高了数据传输速率，凸显了高带宽交换机对于现代应用的重要性。

**2. 可扩展性**
可扩展性是确保您的投资面向未来的另一个关键因素。确保您选择的 PCIe 交换机能够随着系统的增长容纳更多设备和更高的带宽需求。例如，具有 256  个通道的交换机可提供显着的可扩展性，允许在不影响性能的情况下进行广泛的扩展。随着数据中心的发展和应用程序的要求越来越高，对可扩展 PCIe  基础设施的需求变得更加迫切，这凸显了选择能够随着您的需求而增长的交换机的重要性。

**3. 延迟**
低延迟对于需要实时数据处理的应用程序至关重要，例如金融交易平台、高性能计算 (HPC) 和数据中心工作负载。评估交换机的延迟特性以确保其满足您的应用程序的要求。高品质交换机提供最小的延迟  (<100ns)，确保高效、及时的数据传输。与前代产品相比，新一代 PCIe 5.0  交换机可以实现更低的延迟，从而增强对延迟敏感的应用程序的性能。

**4、兼容性**
与现有硬件和软件的兼容性对于避免集成问题至关重要。检查是否符合最新的 PCIe 标准（例如 PCIe 4.0 或 PCIe  5.0），并确保交换机向后兼容旧设备。这种兼容性可确保无缝集成并最大限度地提高当前基础设施的效用。 PCI-SIG  的兼容性指南强调了确保新交换机与现有系统无缝协作的重要性，以避免代价高昂的升级和停机。
**5. 可靠性和冗余性**
可靠性是不容协商的，尤其是在关键任务环境中。寻找具有内置冗余功能的交换机，例如热插拔组件和纠错码 (ECC) 支持。这些功能增强了系统弹性，最大限度地减少停机时间并确保数据完整性。 PCIe 交换机中 ECC  和冗余的实施对于在高风险环境中保持数据完整性和系统正常运行时间至关重要。

**6. 电源效率**
电源效率是现代数据中心和企业环境中日益受到关注的问题。选择能够平衡性能与功耗的 PCIe 交换机。高效的电源管理可降低运营成本并符合可持续发展目标。如今，下一代 PCIe 交换机的设计考虑了电源效率，这对于减少数据中心的整体能源足迹至关重要。
**7. 管理和监控能力**
有效的管理和监控能力对于保持最佳性能至关重要。选择具有高级管理功能的交换机，例如远程监控、诊断工具和用户友好的界面。这些功能简化了维护、故障排除和性能调整。远程管理和监控 PCIe 交换机的能力可以显着提高运营效率并降低维护成本。

**8. 面向未来**
随着数据密集型应用程序的不断发展，使您的基础设施面向未来变得越来越重要。同时支持 PCIe 和 CXL（Compute Express Link）标准的混合交换机提供了引人注目的解决方案。 CXL  是一种开放标准互连，旨在通过在数据中心 CPU、GPU 和其他加速器之间提供高速、低延迟的通信来增强这些组件的性能和效率。通过集成对 PCIe 和 CXL 的支持，混合交换机可确保与当前 PCIe 设备的兼容性，同时支持采用下一代支持 CXL  的硬件。这种双重支持最大限度地提高了灵活性和可扩展性，允许随着新技术的出现而无缝升级和扩展。此外，此类混合交换机可以优化资源利用率、提高内存一致性并减少延迟，使其成为寻求领先技术进步的数据中心和 HPC 环境的理想选择。
投资合适的 PCIe  Switch不仅仅是为了满足当今的要求；还为了满足需求。这是关于准备您的基础设施以支持下一代技术进步。选择正确的 PCIe  互连交换机是影响系统性能、可扩展性和可靠性的关键决策。通过仔细考虑所有变量，您可以做出明智的选择，以满足您当前的需求和未来的增长。

【参考文献】

1. [https://blog.51cto.com/u_16213563/11501101](https://link.zhihu.com/?target=https%3A//blog.51cto.com/u_16213563/11501101)
2. [PCIe Switch全解析：一文让你秒懂！ (webzonl.com)](https://link.zhihu.com/?target=https%3A//www.webzonl.com/cms/700.html)
3. [Selecting the Right PCIe Interconnect Switch for Today, and Tomorrow (technative.io)](https://link.zhihu.com/?target=https%3A//technative.io/selecting-the-right-pcie-interconnect-switch-for-today-and-tomorrow/)

# 至强Xeon工作站CPU介绍，洋垃圾为何大行其道

[![haidescs](https://picx.zhimg.com/v2-286c7b27e584abe3cf4326fcef8f2000_l.jpg?source=172ae18b)](https://www.zhihu.com/people/haidescs)

[haidescs](https://www.zhihu.com/people/haidescs)

[![知乎知识会员](https://pic1.zhimg.com/v2-57fe7feb4813331d5eca02ef731e12c9.jpg?source=88ceefae)](https://www.zhihu.com/kvip/purchase)

结构化金融与Fintech，还得教书

创作声明：包含 AI 辅助创作



23 人赞同了该文章



课堂上的结论和支撑材料，主要是与智能计算相关的选型、架构和算法方面的问题。以下材料部分来自于[ChatGPT-4o](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=ChatGPT-4o&zhida_source=entity)

、Kimi、通义千问2.5，然后我再看看改改。 

侵删！

![img](https://pic1.zhimg.com/v2-44ef509c9588594d61abdad55d6c59fa_1440w.jpg)

## 一， Sandy Bridge：V1版，由二代酷睿诞生的E3/[E5神教](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=E5神教&zhida_source=entity)

Sandy Bridge架构是英特尔在2011年推出的一个重要微架构，它带来了显著的性能提升和效率改进。以下是基于Sandy Bridge架构的Xeon E3、E5系列处理器的详细信息。需要注意的是，在Sandy Bridge时期，并没有[至强W系列](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=至强W系列&zhida_source=entity)和[Scalable](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=Scalable&zhida_source=entity)

系列。

### *Xeon E3-1200系列 (Sandy Bridge)*

1. *名称：Xeon E3-1200 v1，发布年代：2011年Q1，架构名称：Sandy Bridge，nm工艺：32nm*
2. *改进点：引入了环形总线架构，提升了内存控制器性能，支持AVX指令集。*
3. *插槽类型：[LGA 1155](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=LGA+1155&zhida_source=entity)*

*主板芯片组：C204, C206等*

*缓存配置：8MB L3 Cache（以E3-1275为例）*

*[PCIe 通道](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=PCIe+通道&zhida_source=entity)*

1. *数量：16条PCI-E 2.0通道*
2. *市场评价：受到桌面级工作站用户的欢迎，提供了良好的性价比。*
3. *不足：核心数相对较少，最高为四核，对于多任务处理有一定限制。*
4. *核心数最多的型号：E3-1285（4核）*
5. *频率最高的型号：E3-1270（3.4GHz基础频率，睿频可达3.8GHz）*
6. *同时代的 AMD 和 Intel 消费级 CPU：AMD FX-8150, Intel Core i7-2600K*
7. *具体发布时间：2011年1月*

### *[Xeon E5](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=Xeon+E5&zhida_source=entity)*

### *-2600/[1600系列](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=1600系列&zhida_source=entity)*

###  *(Sandy Bridge-EP)*

1. *名称：Xeon E5-2600/E5-1600 v1，发布年代：2012年Q1，架构名称：Sandy Bridge-EP，nm工艺：32nm*
2. *改进点：最多支持8个核心，支持双路配置，增强了RAS特性，提高了内存带宽和支持的内存容量。*
3. *插槽类型：[LGA 2011](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=LGA+2011&zhida_source=entity)*

1. *主板芯片组：C602/C600等*
2. *缓存配置：20MB Intel Smart Cache（以E5-2690为例）*
3. *PCIe 通道数量：40条PCI-E 3.0通道*
4. *市场评价：广泛应用于数据中心和高性能计算环境，得到了企业用户的认可。*
5. *不足：功耗较高，尤其是高核心数型号。*
6. *核心数最多的型号：E5-2690（8核）*
7. *频率最高的型号：E5-2690（2.9GHz基础频率，睿频可达3.8GHz）*
8. *同时代的 AMD 和 Intel 消费级 CPU：AMD Opteron 6200系列, Intel Core i7-3960X*
9. *具体发布时间：2012年3月*

### *Xeon Scalable系列 (Sandy Bridge)*

- *适用性：Xeon Scalable系列是在之后的[Skylake](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=Skylake&zhida_source=entity)*

- *架构下推出的，因此在Sandy Bridge时期并不存在。*

### *至强W系列 (Sandy Bridge)*

- *适用性：在Sandy Bridge时期并没有至强W系列的产品。*

综上所述，Sandy Bridge架构期间有Xeon E3-1200 v1和Xeon E5-2600/E5-1600 v1系列处理器，但没有至强W系列和Xeon Scalable系列的产品。这些处理器代表了当时的技术前沿，为后来的产品奠定了基础。

| 指令集类别                                                   | 描述                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Intel 64 (x86-64)                                            | 支持 64 位扩展，能够访问更大的内存空间。                     |
| SSE4.1 / SSE4.2                                              | 提供增强的多媒体、加密、数据处理等性能，针对不同的运算加速。 |
| AVX                                                          | 更强大的 SIMD 扩展，支持 256 位向量，提升浮点计算效率。      |
| FMA                                                          | 浮点乘法加法融合操作，能够加速浮点计算，尤其是在科学计算中。 |
| [AES-NI](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=AES-NI&zhida_source=entity) |                                                              |

| 硬件加速 AES 加密与解密操作，提高加密算法效率。 |                                                              |
| ----------------------------------------------- | ------------------------------------------------------------ |
| CLMUL                                           | 加速乘法运算，常用于加密和校验和计算。                       |
| X87                                             | 早期的[浮点指令集](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=浮点指令集&zhida_source=entity) |

| ，确保兼容性。                                               |                                                   |
| ------------------------------------------------------------ | ------------------------------------------------- |
| MMX                                                          | SIMD 扩展，优化多媒体计算（不常用，但仍然支持）。 |
| Intel VT-x / [VT-d](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=VT-d&zhida_source=entity) |                                                   |

| 硬件虚拟化技术，支持高效虚拟化和 I/O 虚拟化。                |
| ------------------------------------------------------------ |
| Intel [TSX](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=TSX&zhida_source=entity) |

提供事务性同步扩展，用于高效的并行计算。

### 总结：

![img](https://pica.zhimg.com/v2-922ad51597ab2a71ecd85b172ddb95a2_1440w.jpg)

------

## 二，[Ivy Bridge](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=Ivy+Bridge&zhida_source=entity)

## ：终于走到了Bridge的彼岸，看到了桃花源

Ivy Bridge架构是英特尔在2012年推出的一个微架构，作为Sandy  Bridge的继任者，它带来了工艺上的进步（从32nm到22nm）和一些性能上的改进。以下是基于Ivy Bridge架构的Xeon  E3、E5系列处理器的详细信息。需要注意的是，在Ivy Bridge时期，并没有至强W系列和Scalable系列。

### *Xeon E3-1200 v2系列 (Ivy Bridge)*

1. *名称：Xeon E3-1200 v2，发布年代：2012年Q3，架构名称：Ivy Bridge，nm工艺：22nm*
2. *改进点：采用更先进的22nm制程技术，提升了单线程性能，支持DDR3L低电压内存，集成显卡性能显著提升。*
3. *插槽类型：LGA 1155*
4. *[主板芯片组](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=3&q=主板芯片组&zhida_source=entity)*

*：C206, C222等*

*缓存配置：8MB L3 Cache（以E3-1275 v2为例）*

*PCIe 通道数量：16条PCI-E 3.0通道*

*市场评价：受到桌面级工作站用户的欢迎，提供了更好的性价比和能效比。*

*不足：核心数仍然有限，最高为四核，对于多任务处理有一定限制。*

*核心数最多的型号：E3-1285 v2（4核）*

*频率最高的型号：E3-1275 v2（3.5GHz基础频率，睿频可达3.9GHz）*

*同时代的 AMD 和 Intel 消费级 CPU：[AMD FX-8350](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=AMD+FX-8350&zhida_source=entity)*

1. *, Intel Core i7-3770K*
2. *具体发布时间：2012年9月*

### *Xeon E5-2600/1600 v2系列 (Ivy Bridge-EP)*

1. *名称：Xeon E5-2600/E5-1600 v2，发布年代：2013年Q1，架构名称：Ivy Bridge-EP，nm工艺：22nm*
2. *改进点：采用了更先进的22nm制程技术，增加了对更多内存通道的支持，增强了RAS特性，提高了内存带宽和支持的内存容量。*
3. *插槽类型：LGA 2011*
4. *主板芯片组：C602/C600等*
5. *缓存配置：25MB Intel Smart Cache（以E5-2697 v2为例）*
6. *PCIe 通道数量：40条PCI-E 3.0通道*
7. *市场评价：广泛应用于数据中心和高性能计算环境，得到了企业用户的认可。*
8. *不足：功耗较高，尤其是高核心数型号；与上一代相比，架构变化不大，性能提升主要来自于制程优化。*
9. *核心数最多的型号：E5-2697 v2（12核）*
10. *频率最高的型号：E5-2637 v2（3.5GHz基础频率，睿频可达3.8GHz）*
11. *同时代的 AMD 和 Intel 消费级 CPU：AMD Opteron 6300系列, Intel Core i7-4960X*
12. *具体发布时间：2013年3月*

### *Xeon Scalable系列 (Ivy Bridge)*

- *适用性：Xeon Scalable系列是在之后的Skylake架构下推出的，因此在Ivy Bridge时期并不存在。*

### *至强W系列 (Ivy Bridge)*

- *适用性：在Ivy Bridge时期并没有至强W系列的产品。*

综上所述，Ivy Bridge架构期间有Xeon E3-1200 v2和Xeon E5-2600/E5-1600 v2系列处理器，但没有至强W系列和Xeon  Scalable系列的产品。这些处理器代表了当时的技术前沿，进一步巩固了英特尔在服务器和工作站市场的地位。

### **总结**

| 特性       | Sandy Bridge                | Ivy Bridge                       |
| ---------- | --------------------------- | -------------------------------- |
| 制程       | 32nm                        | 22nm                             |
| AVX        | 支持 AVX1.0                 | 支持 AVX1.0，性能更优            |
| FMA        | 支持 FMA                    | 支持 FMA，性能更优               |
| AES-NI     | 支持 AES-NI                 | 支持 AES-NI，性能提升            |
| CLMUL      | 支持 CLMUL                  | 支持 CLMUL                       |
| TSX        | 不支持                      | 支持 TSX，提升并行计算性能       |
| 集成显卡   | Intel HD Graphics 2000/3000 | Intel HD Graphics 4000，性能提升 |
| PCIe       | PCIe 2.0                    | PCIe 3.0，带宽提升               |
| 虚拟化技术 | 支持 VT-x 和 VT-d           | 支持 VT-x 和 VT-d，性能更好      |
| 总性能     | 基本性能良好，但功耗较高    | 性能提升，功耗更低               |

Ivy Bridge 在多方面进行了优化，尤其是性能和能效上，相比于 Sandy Bridge 有着显著的提升。通过更先进的 22nm 制程，Ivy Bridge 提供了更低的功耗、更高的性能和对更多现代技术的支持。

![img](https://picx.zhimg.com/v2-05cacfb11947cc46dfe183bbe22a86f5_1440w.jpg)

------

## 三，[Haswell](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=Haswell&zhida_source=entity)

## ：初代Well，非常Well

Haswell架构是英特尔在2013年推出的一个重要微架构，它带来了显著的性能提升和效率改进。以下是基于Haswell架构的Xeon E3、E5系列处理器的详细信息。需要注意的是，在Haswell时期，并没有至强W系列和Scalable系列。

### *Xeon E3-1200 v3系列 (Haswell)*

1. *名称：Xeon E3-1200 v3，发布年代：2013年Q4，架构名称：Haswell，nm工艺：22nm*
2. *改进点：引入了对DDR3L内存的支持，增强了集成显卡性能，提升了单线程和多线程性能，支持更多[PCIe通道](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=PCIe通道&zhida_source=entity)*

*。*

*插槽类型：[LGA 1150](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=LGA+1150&zhida_source=entity)*

1. *主板芯片组：C226, C230等*
2. *缓存配置：8MB L3 Cache（以E3-1275 v3为例）*
3. *PCIe 通道数量：16条PCI-E 3.0通道*
4. *市场评价：受到桌面级工作站用户的欢迎，提供了良好的性价比和能效比。*
5. *不足：核心数相对有限，最高为四核，对于需要大量多线程处理的应用有一定限制。*
6. *核心数最多的型号：E3-1285L v3（4核）*
7. *频率最高的型号：E3-1231 v3（3.4GHz基础频率，睿频可达3.7GHz）*
8. *同时代的 AMD 和 Intel 消费级 CPU：AMD A10-7850K, Intel Core i7-4790K*
9. *具体发布时间：2013年10月*

### *Xeon E5-2600 v3系列 (Haswell-EP)*

1. *名称：Xeon E5-2600 v3，发布年代：2014年Q3，架构名称：Haswell-EP，nm工艺：22nm*
2. *改进点：最多支持18个核心，支持DDR4内存，增强了AVX 2.0指令集，提高了内存带宽和支持的内存容量。*
3. *插槽类型：LGA 2011-v3*
4. *主板芯片组：C612等*
5. *缓存配置：45MB Intel Smart Cache（以E5-2699 v3为例）*
6. *PCIe 通道数量：40条PCI-E 3.0通道*
7. *市场评价：广泛应用于数据中心和高性能计算环境，得到了企业用户的认可。*
8. *不足：功耗较高，尤其是高核心数型号；价格昂贵。*
9. *核心数最多的型号：E5-2699 v3（18核）*
10. *频率最高的型号：E5-2667 v3（3.2GHz基础频率，睿频可达3.6GHz）*
11. *同时代的 AMD 和 Intel 消费级 CPU：AMD FX-9590, Intel Core i7-4790K*
12. *具体发布时间：2014年9月*

### *Xeon Scalable系列 (Haswell)*

- *适用性：Xeon Scalable系列是在之后的Skylake架构下推出的，因此在Haswell时期并不存在。*

### *至强W系列 (Haswell)*

- *适用性：在Haswell时期并没有至强W系列的产品。*

综上所述，Haswell架构期间有Xeon E3-1200 v3和Xeon E5-2600 v3系列处理器，但没有至强W系列和Xeon  Scalable系列的产品。这些处理器代表了当时的技术前沿，进一步巩固了英特尔在服务器和工作站市场的地位，并为后续产品的发展奠定了基础。

| 指令集特性                                                   | Sandy Bridge           | Haswell                                              | 改进或新增功能                                           |
| ------------------------------------------------------------ | ---------------------- | ---------------------------------------------------- | -------------------------------------------------------- |
| AVX                                                          | 支持 AVX1.0            | 支持 AVX1.0 和 AVX2.0                                | AVX2.0 引入了对256位整数和浮点数向量的支持，提升计算性能 |
| FMA                                                          | 不支持                 | 支持 FMA3（Fused Multiply-Add）                      | 引入 FMA3 指令集，加速浮点数乘加运算，提升计算效率       |
| AES-NI                                                       | 支持 AES-NI            | 支持 AES-NI                                          | 无重大差异，但Haswell在整体性能和效率上有所提升          |
| CLMUL                                                        | 支持 CLMUL             | 支持 CLMUL                                           | 无重大差异，支持加速乘法运算，尤其在加密算法中使用       |
| TSX                                                          | 不支持                 | 支持 TSX（Transactional Synchronization Extensions） | 引入TSX支持，改善并行程序的事务级同步性能                |
| AVX-512                                                      | 不支持                 | 不支持                                               | AVX-512 在后续架构（如Skylake）中才引入                  |
| BMI1/BMI2                                                    | 支持 BMI1，未支持 BMI2 | 支持 BMI1 和 BMI2                                    | Haswell支持BMI2（位操作指令集增强），提高位操作效率      |
| [RDRAND](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=RDRAND&zhida_source=entity) |                        |                                                      |                                                          |

| 支持                                                         | 支持   | 两者均支持硬件随机数生成，增强加密操作 |                                       |
| ------------------------------------------------------------ | ------ | -------------------------------------- | ------------------------------------- |
| Intel SGX                                                    | 不支持 | 支持 Intel SGX                         | 引入Intel SGX，提供硬件隔离和加密支持 |
| Intel [MPX](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=MPX&zhida_source=entity) |        |                                        |                                       |

| 不支持 | 支持 Intel MPX | 引入MPX，提升内存保护，防止溢出攻击 |
| ------ | -------------- | ----------------------------------- |
|        |                |                                     |

![img](https://pic3.zhimg.com/v2-0a9c1ef9c93085bd4dd195fd764c3ddc_1440w.jpg)

------

## 四，[Broadwell](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=Broadwell&zhida_source=entity)

## ：更加Well的一代

Broadwell架构是英特尔在2014-2016年间推出的微架构，主要采用了14nm制程技术。以下是基于Broadwell架构的Xeon E3、E5系列处理器的详细信息。需要注意的是，在Broadwell时期，并没有至强W系列和Scalable系列。

### *Xeon E3-1200 v4系列 (Broadwell)*

1. *名称：Xeon E3-1200 v4，发布年代：2015年Q2，架构名称：Broadwell，nm工艺：14nm*
2. *改进点：采用更先进的14nm制程技术，提升了单线程性能，支持DDR4内存，增强了集成显卡性能。*
3. *插槽类型：[LGA 1151](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=LGA+1151&zhida_source=entity)*

1. *主板芯片组：C232, C236等*
2. *缓存配置：8MB L3 Cache（以E3-1275 v4为例）*
3. *PCIe 通道数量：16条PCI-E 3.0通道*
4. *市场评价：受到桌面级工作站用户的欢迎，提供了良好的性价比和能效比。*
5. *不足：核心数相对有限，最高为四核，对于需要大量多线程处理的应用有一定限制。*
6. *核心数最多的型号：E3-1285 v4（4核）*
7. *频率最高的型号：E3-1231 v4（3.4GHz基础频率，睿频可达3.8GHz）*
8. *同时代的 AMD 和 Intel 消费级 CPU：AMD Ryzen 7 1800X, Intel Core i7-6700K*
9. *具体发布时间：2015年3月*

### *Xeon E5-2600 v4系列 (Broadwell-EP)*

1. *名称：Xeon E5-2600 v4，发布年代：2016年Q2，架构名称：Broadwell-EP，nm工艺：14nm*
2. *改进点：最多支持22个核心，进一步优化了功耗表现，支持更多内存通道（最多六个），提高了内存带宽和支持的内存容量。*
3. *插槽类型：LGA 2011-v3*
4. *主板芯片组：C612等*
5. *缓存配置：55MB Intel Smart Cache（以E5-2699 v4为例）*
6. *PCIe 通道数量：40条PCI-E 3.0通道*
7. *市场评价：广泛应用于数据中心和高性能计算环境，得到了企业用户的认可。*
8. *不足：价格昂贵，TDP较高，尤其是高核心数型号。*
9. *核心数最多的型号：E5-2699 v4（22核）*
10. *频率最高的型号：E5-2697A v4（3.6GHz基础频率，睿频可达3.8GHz）*
11. *同时代的 AMD 和 Intel 消费级 CPU：AMD Ryzen 7 1800X, Intel Core i7-6700K*
12. *具体发布时间：2016年4月*

### *Xeon Scalable系列 (Broadwell)*

- *适用性：Xeon Scalable系列是在之后的Skylake架构下推出的，因此在Broadwell时期并不存在。*

### *至强W系列 (Broadwell)*

- *适用性：在Broadwell时期并没有至强W系列的产品。*

综上所述，Broadwell架构期间有Xeon E3-1200 v4和Xeon E5-2600 v4系列处理器，但没有至强W系列和Xeon  Scalable系列的产品。这些处理器代表了当时的技术前沿，进一步巩固了英特尔在服务器和工作站市场的地位，并为后续产品的发展奠定了基础。

| 指令集特性 | Haswell架构                                          | Broadwell架构                                        | 改进或新增功能                                   |
| ---------- | ---------------------------------------------------- | ---------------------------------------------------- | ------------------------------------------------ |
| AVX        | 支持 AVX1.0 和 AVX2.0                                | 支持 AVX1.0 和 AVX2.0                                | 两者相同，AVX2支持对256位整数和浮点数向量的支持  |
| FMA        | 支持 FMA3（Fused Multiply-Add）                      | 支持 FMA3                                            | 无变化，FMA3继续加速浮点数运算，提升科学计算性能 |
| AES-NI     | 支持 AES-NI                                          | 支持 AES-NI                                          | 无变化，继续加速AES加解密操作                    |
| CLMUL      | 支持 CLMUL                                           | 支持 CLMUL                                           | 无变化，支持加速乘法运算，尤其在加密算法中使用   |
| TSX        | 支持 TSX（Transactional Synchronization Extensions） | 支持 TSX（Transactional Synchronization Extensions） | 无变化，支持硬件事务同步                         |
| AVX-512    | 不支持                                               | 不支持                                               | 两者均不支持，AVX-512指令集在Skylake开始支持     |
| BMI1/BMI2  | 支持 BMI1 和 BMI2                                    | 支持 BMI1 和 BMI2                                    | 无变化，优化位操作，如位设置、清除和加密运算     |
| RDRAND     | 支持硬件随机数生成指令                               | 支持硬件随机数生成指令                               | 无变化，增强加密算法的安全性和性能               |
| Intel SGX  | 不支持                                               | 支持 Intel SGX                                       | Broadwell新增对Intel SGX的支持，用于提高安全性   |
| Intel MPX  | 不支持                                               | 支持 Intel MPX                                       | Broadwell新增对Intel MPX的支持，用于内存保护     |

![img](https://picx.zhimg.com/v2-6821df111a8470de83b632c53525f10b_1440w.jpg)

------

## 五，Skylake：初代Lake，最全的一代，E5退出历史舞台，Scalable在混乱中接替

Skylake架构是英特尔在2015-2017年间推出的一个重要微架构，它带来了显著的性能提升和效率改进。以下是基于Skylake架构的Xeon E3、E5、W系列以及Scalable系列处理器的详细信息。

### *Xeon E3-1200 v5系列 (Skylake)*

1. *名称：Xeon E3-1200 v5，发布年代：2017年Q1，架构名称：Skylake，nm工艺：14nm*
2. *改进点：支持DDR4内存，集成显卡性能大幅提升，TDP降低，增加了对更多PCIe通道的支持。*
3. *插槽类型：LGA 1151*
4. *主板芯片组：C232, C236等*
5. *缓存配置：8MB L3 Cache（以E3-1275 v5为例）*
6. *PCIe 通道数量：16条PCI-E 3.0通道*
7. *市场评价：受到桌面级工作站用户的欢迎，提供了良好的性价比和能效比。*
8. *不足：核心数相对有限，最高为四核，对于需要大量多线程处理的应用有一定限制。*
9. *核心数最多的型号：E3-1285L v5（4核）*
10. *频率最高的型号：E3-1231 v5（3.4GHz基础频率，睿频可达3.9GHz）*
11. *同时代的 AMD 和 Intel 消费级 CPU：AMD Ryzen 7 1800X, Intel Core i7-7700K*
12. *具体发布时间：2017年3月*

### *Xeon E5-2600 v4系列 (Skylake-EP)*

- *适用性：实际上没有官方定义的“v4”版本基于Skylake架构，Xeon E5系列在此期间已过渡到Xeon Scalable系列。*

### *Xeon Scalable系列 ([Skylake-SP](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=Skylake-SP&zhida_source=entity)*

### *)*

1. *名称：[Xeon Platinum](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=Xeon+Platinum&zhida_source=entity)*

1. */Gold/Silver/Bronze，发布年代：2017年Q3起，架构名称：Skylake-SP，nm工艺：14nm*
2. *改进点：引入了新的命名体系，提高了安全性特性，增强了网络和存储加速功能，支持更多的核心数和更大的缓存，支持更高的内存带宽。*
3. *插槽类型：LGA 3647*
4. *主板芯片组：C620系列等*
5. *缓存配置：根据具体型号而定，最高可达38.5MB Intel Smart Cache。*
6. *PCIe 通道数量：最多48条PCI-E 3.0通道*
7. *市场评价：广泛应用于数据中心和高性能计算环境，得到了企业用户的认可。*
8. *不足：价格较高，功耗较大。*
9. *核心数最多的型号：Platinum 8280（28核）*
10. *频率最高的型号：Gold 6258R（2.7GHz基础频率，睿频可达4.0GHz）*
11. *同时代的 AMD 和 Intel 消费级 CPU：AMD EPYC 7000系列, Intel Core i9-7980XE*
12. *具体发布时间：2017年7月开始陆续推出*

### *Xeon W系列 (Skylake-X)*

1. *名称：Xeon W-2100/W-2100M，发布年代：2017年Q4，架构名称：Skylake-X，nm工艺：14nm*
2. *改进点：专为工作站设计，支持多达18个核心，具备更强的多线程处理能力，支持更高的内存带宽。*
3. *插槽类型：LGA 2066*
4. *主板芯片组：C422等*
5. *缓存配置：24.75MB Intel Smart Cache（以W-2195为例）*
6. *PCIe 通道数量：44条PCI-E 3.0通道*
7. *市场评价：受到了专业创作者和工程师的好评，适合高端工作站用户。*
8. *不足：成本较高，平台复杂度增加。*
9. *核心数最多的型号：W-2195（18核）*
10. *频率最高的型号：W-2123（3.6GHz基础频率，睿频可达4.5GHz）*
11. *同时代的 AMD 和 Intel 消费级 CPU：AMD Ryzen Threadripper 1950X, Intel Core i9-7980XE*
12. *具体发布时间：2017年10月*

综上所述，Skylake架构期间有Xeon E3-1200 v5、Xeon W系列以及Xeon Scalable系列处理器，但没有官方定义的Xeon E5  v4基于Skylake架构的产品。这些处理器代表了当时的技术前沿，进一步巩固了英特尔在服务器、工作站市场的地位，并为后续产品的发展奠定了基础。

| 指令集特性     | Broadwell架构                                        | Skylake架构                                          | 改进或新增功能                                            |
| -------------- | ---------------------------------------------------- | ---------------------------------------------------- | --------------------------------------------------------- |
| AVX            | 支持 AVX1.0 和 AVX2.0                                | 支持 AVX1.0、AVX2.0 和 AVX-512                       | 新增对AVX-512指令集的支持，提升高性能计算性能             |
| FMA            | 支持 FMA3（Fused Multiply-Add）                      | 支持 FMA3                                            | 无变化，继续加速浮点数运算，提升科学计算性能              |
| AES-NI         | 支持 AES-NI                                          | 支持 AES-NI                                          | 无变化，继续加速AES加解密操作                             |
| CLMUL          | 支持 CLMUL                                           | 支持 CLMUL                                           | 无变化，支持加速乘法运算，尤其在加密算法中使用            |
| TSX            | 支持 TSX（Transactional Synchronization Extensions） | 支持 TSX（Transactional Synchronization Extensions） | 无变化，支持硬件事务同步                                  |
| AVX-512        | 不支持                                               | 支持 AVX-512                                         | 新增对AVX-512指令集的支持，提升大规模浮点数和整数运算性能 |
| BMI1/BMI2      | 支持 BMI1 和 BMI2                                    | 支持 BMI1 和 BMI2                                    | 无变化，优化位操作，如位设置、清除和加密运算              |
| RDRAND         | 支持硬件随机数生成指令                               | 支持硬件随机数生成指令                               | 无变化，增强加密算法的安全性和性能                        |
| Intel SGX      | 支持 Intel SGX                                       | 支持 Intel SGX                                       | 无变化，继续提供硬件加密支持                              |
| Intel MPX      | 支持 Intel MPX                                       | 支持 Intel MPX                                       | 无变化，防止内存溢出问题                                  |
| Intel DL Boost | 不支持                                               | 支持 Intel DL Boost（仅限部分Skylake处理器）         | 新增对深度学习推理加速的支持，提高AI应用性能              |

![img](https://pic3.zhimg.com/v2-a530797ccdaa393331be53b2b33f3ed2_1440w.jpg)

------

## 六，[Kaby Lake](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=Kaby+Lake&zhida_source=entity)

## ：为了移动而逝去的一代

Kaby Lake架构是英特尔在2016-2017年间推出的微架构，主要应用于消费级市场，特别是在笔记本电脑和桌面平台上。然而，在服务器和工作站领域，英特尔并没有推出基于Kaby Lake架构的Xeon E3、E5、W系列或Scalable系列处理器。

### 概述

对于Xeon E3、E5、W系列以及Scalable系列，英特尔选择了继续使用和改进之前的架构（如Broadwell和Skylake），而不是采用Kaby  Lake架构。这是因为服务器和工作站市场更注重多线程性能、核心数、缓存大小以及对专业工作负载的支持，而这些方面Kaby  Lake相比其前代产品并没有显著改进。

![img](https://pic3.zhimg.com/v2-3f1088a8b5d7d11355dcc1b5ab635b64_1440w.jpg)

------

## 七，[Coffee Lake](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=Coffee+Lake&zhida_source=entity)

## ：E后面没有3了，从此面一代新人换旧人

Coffee Lake架构是英特尔在2017-2018年间推出的微架构，主要用于消费级市场。然而，在服务器和工作站领域，英特尔并没有推出基于Coffee  Lake架构的Xeon E5或Scalable系列处理器。不过，英特尔确实推出了基于Coffee  Lake架构的E系列处理器用于代替E3系列，也就是传说中的Xeon E3 v6系列，并且没有基于Coffee Lake架构的Xeon  W系列处理器。以下是基于Coffee Lake架构的E系列（Xeon E3 v6系列）处理器的详细信息。

### *Xeon E-2100/E-2200系列 (Coffee Lake)*

1. *名称：Xeon E-2100/E-2200，发布年代：2018年Q1-Q4，架构名称：Coffee Lake，nm工艺：14nm*
2. *改进点：增加了核心数（最多6个核心），相较于上一代产品提升了多线程性能。支持DDR4内存，提供了更高的内存带宽。集成显卡性能有所提升，支持Intel UHD Graphics 630。*
3. *插槽类型：LGA 1151*
4. *主板芯片组：C246, C232等*
5. *缓存配置：9MB L3 Cache（以E-2288G为例）*
6. *PCIe 通道数量：16条PCI-E 3.0通道*
7. *市场评价：受到了桌面级工作站用户的欢迎，特别是在图形设计、视频编辑等领域表现良好。由于性价比高，也适合中小企业使用。*
8. *不足：对于需要更多核心数的专业应用来说，6核可能仍然有限。功耗相对较高，特别是对于高频型号。*
9. *核心数最多的型号：E-2288G（6核）*
10. *频率最高的型号：E-2288G（3.7GHz基础频率，睿频可达5.0GHz）*
11. *同时代的 AMD 和 Intel 消费级 CPU：AMD：[Ryzen 7 2700X](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=Ryzen+7+2700X&zhida_source=entity)*

1. *、Intel：Core i7-8700K*
2. *具体发布时间：2018年陆续推出，其中E-2100系列在2018年初，E-2200系列在2018年末*

### *Xeon Scalable系列 (Coffee Lake)*

- *适用性：Xeon Scalable系列采用了Skylake-SP和后续的[Cascade Lake](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=Cascade+Lake&zhida_source=entity)*

- *-SP架构，因此没有基于Coffee Lake架构的产品。*

### *Xeon W系列 (Coffee Lake)*

- *适用性：没有基于Coffee Lake架构的Xeon W系列处理器。* 

综上所述，Coffee Lake架构期间只E系列（Xeon E3 v6系列）的Xeon E-2100/E-2200系列处理器，而没有Xeon  E5、W系列或Scalable系列处理器基于该架构的产品。这些处理器主要面向入门级工作站和小型企业用户，提供了一定程度上的性能提升和更好的性价比。

| 指令集特性     | Skylake架构                                          | Coffee Lake架构                                      | 改进或新增功能                                        |
| -------------- | ---------------------------------------------------- | ---------------------------------------------------- | ----------------------------------------------------- |
| AVX            | 支持 AVX1.0 和 AVX2.0                                | 支持 AVX1.0、AVX2.0 和 AVX-512                       | 无变化，但部分处理器支持AVX-512，适用于更高负载的任务 |
| FMA            | 支持 FMA3（Fused Multiply-Add）                      | 支持 FMA3                                            | 无变化，继续加速浮点数运算，提升科学计算性能          |
| AES-NI         | 支持 AES-NI                                          | 支持 AES-NI                                          | 无变化，继续加速AES加解密操作                         |
| CLMUL          | 支持 CLMUL                                           | 支持 CLMUL                                           | 无变化，支持加速乘法运算，尤其在加密算法中使用        |
| TSX            | 支持 TSX（Transactional Synchronization Extensions） | 支持 TSX（Transactional Synchronization Extensions） | 无变化，继续支持硬件事务同步                          |
| AVX-512        | 支持 AVX-512（仅限部分处理器）                       | 支持 AVX-512                                         | 无变化，但更多处理器支持此指令集，提升高性能计算任务  |
| BMI1/BMI2      | 支持 BMI1 和 BMI2                                    | 支持 BMI1 和 BMI2                                    | 无变化，优化位操作，如位设置、清除和加密运算          |
| RDRAND         | 支持硬件随机数生成指令                               | 支持硬件随机数生成指令                               | 无变化，增强加密算法的安全性和性能                    |
| Intel SGX      | 支持 Intel SGX                                       | 支持 Intel SGX                                       | 无变化，继续提供硬件加密支持                          |
| Intel DL Boost | 不支持                                               | 支持 Intel DL Boost（仅限部分Coffee Lake处理器）     | 新增对深度学习推理加速的支持，提高AI应用性能          |

![img](https://pic4.zhimg.com/v2-b20d668f7d0df8bebf3193a0da949ab5_1440w.jpg)

------

## 八，Whiskey Lake：为了移动而“又”逝去的一代

Whiskey Lake架构是英特尔在2018年推出的微架构，主要用于移动平台的U系列处理器。对于服务器和工作站领域，英特尔并没有推出基于Whiskey Lake架构的Xeon E3、E5、W系列或Scalable系列处理器。

### 概述

- 适用性：没有基于Whiskey Lake架构的Xeon E3、E5、W系列或Scalable系列处理器。

![img](https://pic3.zhimg.com/v2-9df7b5728f3d21fe1ff8db7aee1d89e0_1440w.jpg)

------

## 九，Cascade Lake：被分割的三代人，Coffee只有E，Cascade只有Scalable和W

Cascade Lake架构是英特尔在2019年推出的一个重要微架构，主要用于服务器和数据中心市场。以下是基于Cascade Lake架构的Xeon  E3（已被重新命名为Xeon E系列）、E5（已被重新命名为Xeon Scalable系列）、W系列的详细信息。

### *Xeon E-2200系列 (Cascade Lake)*

- *适用性：没有基于Cascade Lake架构的E系列处理器。*

### *Xeon Scalable系列 (Cascade Lake-SP)*

1. *名称：Xeon Platinum/Gold/Silver/Bronze，发布年代：2019年Q2-Q4，架构名称：Cascade Lake-SP，nm工艺：14nm*
2. *改进点：支持更多的核心数（最多28个核心），增强了多线程处理能力。提高了安全性特性，如Intel Optane DC持久内存支持。增强了网络和存储加速功能。改进了AI推理性能，支持bfloat16数据格式。*
3. *插槽类型：LGA 3647*
4. *主板芯片组：C620系列等*
5. *缓存配置：根据具体型号而定，最高可达38.5MB Intel Smart Cache。*
6. *PCIe 通道数量：最多48条PCI-E 3.0通道*
7. *市场评价：广泛应用于数据中心和高性能计算环境，得到了企业用户的认可。*
8. *不足：价格较高，功耗较大。对于某些非AI工作负载，可能不是最优选择。*
9. *核心数最多的型号：Platinum 9282（56核）*
10. *频率最高的型号：Gold 6258R（2.7GHz基础频率，睿频可达4.0GHz）*
11. *同时代的 AMD 和 Intel 消费级 CPU：AMD：EPYC 7002系列，Intel：Core i9-9980XE*
12. *具体发布时间：2019年陆续推出，其中部分型号在2019年初发布*

### *Xeon W系列 (Cascade Lake-W)*

1. *名称：Xeon W-3200/W-2200，发布年代：2019年Q4，架构名称：Cascade Lake-W，nm工艺：14nm*
2. *改进点：最多支持28个核心，大幅增强了多线程处理能力。提供了更高的内存带宽和支持的内存容量。支持更多的PCIe通道，提高了扩展性。*
3. *插槽类型：LGA 4189（W-3200）/LGA 3647（W-2200）*
4. *主板芯片组：C621等*
5. *缓存配置：最大38.5MB Intel Smart Cache（以W-3275为例）*
6. *PCIe 通道数量：最多64条PCI-E 3.0通道*
7. *市场评价：受到了专业创作者和工程师的好评，适合高端工作站用户。*
8. *不足：成本较高，平台复杂度增加。功耗较大，尤其是高核心数型号。*
9. *核心数最多的型号：W-3275（28核）*
10. *频率最高的型号：W-2295（3.0GHz基础频率，睿频可达4.5GHz）*
11. *同时代的 AMD 和 Intel 消费级 CPU：AMD：Ryzen Threadripper 3990X，Intel：Core i9-9980XE*
12. *具体发布时间：2019年11月*

综上所述，Cascade Lake架构期间推出了Xeon E-2200系列、Xeon W系列以及Xeon Scalable系列处理器。这些处理器代表了当时的技术前沿，进一步巩固了英特尔在服务器、工作站市场的地位，并为后续产品的发展奠定了基础。

| 指令集特性            | Coffee Lake架构                                      | Cascade Lake架构                                     | 改进或新增功能                                               |
| --------------------- | ---------------------------------------------------- | ---------------------------------------------------- | ------------------------------------------------------------ |
| AVX                   | 支持 AVX1.0 和 AVX2.0                                | 支持 AVX1.0、AVX2.0 和 AVX-512                       | 无变化，但更多处理器支持AVX-512，适用于更高负载的任务        |
| FMA                   | 支持 FMA3（Fused Multiply-Add）                      | 支持 FMA3                                            | 无变化，继续加速浮点数运算，提升科学计算性能                 |
| AES-NI                | 支持 AES-NI                                          | 支持 AES-NI                                          | 无变化，继续加速AES加解密操作                                |
| CLMUL                 | 支持 CLMUL                                           | 支持 CLMUL                                           | 无变化，支持加速乘法运算，尤其在加密算法中使用               |
| TSX                   | 支持 TSX（Transactional Synchronization Extensions） | 支持 TSX（Transactional Synchronization Extensions） | 无变化，继续支持硬件事务同步                                 |
| AVX-512               | 支持 AVX-512（仅限部分处理器）                       | 支持 AVX-512                                         | 无变化，但Cascade Lake的支持范围更广，特别是在数据中心处理器上 |
| BMI1/BMI2             | 支持 BMI1 和 BMI2                                    | 支持 BMI1 和 BMI2                                    | 无变化，优化位操作，如位设置、清除和加密运算                 |
| RDRAND                | 支持硬件随机数生成指令                               | 支持硬件随机数生成指令                               | 无变化，增强加密算法的安全性和性能                           |
| Intel SGX             | 支持 Intel SGX                                       | 支持 Intel SGX                                       | 无变化，继续提供硬件加密支持                                 |
| Intel DL Boost        | 支持 Intel DL Boost（仅限部分Coffee Lake处理器）     | 支持 Intel DL Boost（仅限部分Cascade Lake处理器）    | 无变化，增强对深度学习推理任务的加速支持                     |
| Intel Optane DC       | 不支持                                               | 支持 Intel Optane DC Persistent Memory               | 新增，提高大内存负载、低延迟访问的性能                       |
| DDI (Data Direct I/O) | 不支持                                               | 支持 DDI（Data Direct I/O），提高数据中心I/O性能     | 新增，提高数据中心和大规模并行计算的性能                     |

![img](https://pic1.zhimg.com/v2-96c381673b9736bfbf5acfe8039f7aa0_1440w.jpg)

------

## 十，[Ice Lake](https://zhida.zhihu.com/search?content_id=251491023&content_type=Article&match_order=1&q=Ice+Lake&zhida_source=entity)

## ：只剩Scalable的最后一代

Ice Lake架构是英特尔在2019年推出的微架构，最初应用于移动平台的U系列和Y系列处理器。随后，英特尔推出了基于Ice Lake架构的Xeon  Scalable处理器，主要用于服务器和数据中心市场。以下是基于Ice Lake架构的Xeon E3、E5（已被重新命名为Xeon  Scalable系列）、W系列以及Scalable系列处理器的详细信息。

### Xeon E系列 (Ice Lake时期)

对于Xeon E系列，在Ice Lake时期并没有推出新的E系列处理器。Xeon E系列在Ice Lake时期继续使用Coffee Lake架构的产品，直到后来的更新。

### *Xeon Scalable系列 (Ice Lake-SP)*

1. *名称：Xeon Platinum/Gold/Silver/Bronze，发布年代：2020年Q4 - 2021年Q1，架构名称：Ice Lake-SP，nm工艺：10nm*
2. *改进点：支持更多的核心数（最多40个核心），增强了多线程处理能力。提高了安全性特性，如Intel Software Guard Extensions (SGX) 和 Intel Total Memory Encryption  (TME)。增强了网络和存储加速功能。改进了AI推理性能，支持bfloat16数据格式，并引入了DL  Boost技术。支持更快的内存类型（DDR4-3200）和更高的内存容量。*
3. *插槽类型：LGA 4189*
4. *主板芯片组：C621等*
5. *缓存配置：根据具体型号而定，最高可达77MB Intel Smart Cache。*
6. *PCIe 通道数量：最多64条PCI-E 4.0通道*
7. *市场评价：广泛应用于数据中心和高性能计算环境，得到了企业用户的认可。特别是在AI推理和安全应用方面表现突出。*
8. *不足：价格较高，功耗较大。对于某些非AI工作负载，可能不是最优选择。*
9. *核心数最多的型号：Platinum 8380（40核）*
10. *频率最高的型号：Gold 6358P（2.9GHz基础频率，睿频可达4.0GHz）*
11. *同时代的 AMD 和 Intel 消费级 CPU：AMD：EPYC 7003系列（Milan）,Intel：Core i9-10980XE*
12. *具体发布时间：2020年10月开始陆续推出*

### Xeon W系列 (Ice Lake时期)

在Ice Lake时期，**Xeon W系列并没有直接采用Ice Lake架构**，而是继续使用之前的架构产品。因此，在Ice Lake时期，Xeon W系列的主要特点仍然基于Skylake-X或Cascade Lake架构。

### 总结

- **Xeon Scalable系列**确实推出了基于**Ice Lake-SP架构**的处理器，这些处理器主要面向服务器和数据中心市场。
- **Xeon W系列**和**Xeon E系列**在Ice Lake时期没有直接采用Ice Lake架构，而是继续使用之前的架构产品。

| 指令集特性      | Cascade Lake架构                                     | Ice Lake架构                                                 | 改进或新增功能                                        |
| --------------- | ---------------------------------------------------- | ------------------------------------------------------------ | ----------------------------------------------------- |
| AVX             | 支持 AVX1.0 和 AVX2.0                                | 支持 AVX1.0、AVX2.0 和 AVX-512                               | 无变化，但更多处理器支持AVX-512，适用于更高负载的任务 |
| FMA             | 支持 FMA3（Fused Multiply-Add）                      | 支持 FMA3                                                    | 无变化，继续加速浮点数运算，提升科学计算性能          |
| AES-NI          | 支持 AES-NI                                          | 支持 AES-NI                                                  | 无变化，继续加速AES加解密操作                         |
| CLMUL           | 支持 CLMUL                                           | 支持 CLMUL                                                   | 无变化，支持加速乘法运算，尤其在加密算法中使用        |
| TSX             | 支持 TSX（Transactional Synchronization Extensions） | 支持 TSX（Transactional Synchronization Extensions）         | 无变化，继续支持硬件事务同步                          |
| AVX-512         | 支持 AVX-512（仅限部分处理器）                       | 支持 AVX-512                                                 | 新增，改进了对向量并行优化和复杂计算的加速            |
| BMI1/BMI2       | 支持 BMI1 和 BMI2                                    | 支持 BMI1 和 BMI2                                            | 无变化，优化位操作，如位设置、清除和加密运算          |
| RDRAND          | 支持硬件随机数生成指令                               | 支持硬件随机数生成指令                                       | 无变化，增强加密算法的安全性和性能                    |
| Intel SGX       | 支持 Intel SGX                                       | 支持 Intel SGX                                               | 无变化，继续提供硬件加密支持                          |
| Intel DL Boost  | 支持 Intel DL Boost（仅限部分Cascade Lake处理器）    | 支持 Intel DL Boost（仅限部分Ice Lake处理器）                | 无变化，增强对深度学习推理任务的加速支持              |
| Intel Optane DC | 不支持                                               | 支持 Intel Optane DC Persistent Memory                       | 新增，提高大内存负载、低延迟访问的性能                |
| VNNI            | 不支持                                               | 支持 VNNI（Vector Neural Network Instructions），加速神经网络推理处理 | 新增，提高神经网络推理效率，特别是在AI应用中非常重要  |
| Intel Flex IT   | 不支持                                               | 支持 Flex IT（Flexible Instruction Trace），增强多线程支持   | 新增，提升高负载多线程计算场景中的性能                |

### **指令集之间的差异和关键改进总结**

![img](https://pica.zhimg.com/v2-4a80ba1c0fabe7592e97651b58af9b20_1440w.jpg)

------

## 总结语：E和W会不会从此成为洋垃圾的代名词？？？

截至2024年底，英特尔尚未推出基于Tiger Lake架构的Xeon E3、E5、W系列或Scalable系列处理器。Tiger Lake架构主要应用于消费级市场，特别是笔记本电脑和其他移动设备中的U系列和H系列处理器。

### 概述

- 适用性：没有基于Tiger Lake架构的Xeon E、W系列或Scalable系列处理器。

![img](https://pic4.zhimg.com/v2-c0153fcb115aac31278ea9180b811679_1440w.jpg)



编辑于 2024-12-14 10:56・IP 属地浙江

### 内容所属专栏

- ![智能计算：框架&算法](https://picx.zhimg.com/v2-f111d7ee1c41944859e975a712c0883b_l.jpg?source=172ae18b)

  ## [智能计算：框架&算法](https://www.zhihu.com/column/c_1763731262546956288)

  囤积一些智能计算的故事和材料

# 深入GPU硬件架构及运行机制

[![夕殿萤飞思悄然](https://pic1.zhimg.com/v2-ad3c66592a9048dc0837984d51be5d6d_l.jpg?source=172ae18b)](https://www.zhihu.com/people/ada-30-73)

[夕殿萤飞思悄然](https://www.zhihu.com/people/ada-30-73)

对酒当歌我只愿开心到老

1114 人赞同了该文章



我觉得这篇文章写得特别好，就转载过来。转载转载。。。

如果作者觉得侵犯著作权，我马上就删。。。。。

[深入GPU硬件架构及运行机制 - 0向往0 - 博客园](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html)

[www.cnblogs.com/timlly/p/11471507.html![img](https://pic3.zhimg.com/v2-4198a4724b1eda602a9dd4bd07a4f69a_180x120.jpg)](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html)

目录

- [一、导言](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23%E4%B8%80%E3%80%81%E5%AF%BC%E8%A8%80)
  - [1.1 为何要了解GPU？](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%2311-%E4%B8%BA%E4%BD%95%E8%A6%81%E4%BA%86%E8%A7%A3gpu%EF%BC%9F)
  - [1.2 内容要点](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%2312-%E5%86%85%E5%AE%B9%E8%A6%81%E7%82%B9)
  - [1.3 带着问题阅读](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%2313-%E5%B8%A6%E7%9D%80%E9%97%AE%E9%A2%98%E9%98%85%E8%AF%BB)



- [二、GPU概述](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23%E4%BA%8C%E3%80%81gpu%E6%A6%82%E8%BF%B0)
  - [2.1 GPU是什么？](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%2321-gpu%E6%98%AF%E4%BB%80%E4%B9%88%EF%BC%9F)
  - [2.2 GPU历史](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%2322-gpu%E5%8E%86%E5%8F%B2)
    - [2.2.1 NV GPU发展史](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23221-nv-gpu%E5%8F%91%E5%B1%95%E5%8F%B2)
    - [2.2.2 NV GPU架构发展史](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23222-nv-gpu%E6%9E%B6%E6%9E%84%E5%8F%91%E5%B1%95%E5%8F%B2)



- [2.3 GPU的功能](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%2323-gpu%E7%9A%84%E5%8A%9F%E8%83%BD)



- [三、GPU物理架构](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23%E4%B8%89%E3%80%81gpu%E7%89%A9%E7%90%86%E6%9E%B6%E6%9E%84)
  - [3.1 GPU宏观物理结构](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%2331-gpu%E5%AE%8F%E8%A7%82%E7%89%A9%E7%90%86%E7%BB%93%E6%9E%84)
  - [3.2 GPU微观物理结构](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%2332-gpu%E5%BE%AE%E8%A7%82%E7%89%A9%E7%90%86%E7%BB%93%E6%9E%84)
    - [3.2.1 NVidia Tesla架构](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23321-nvidia-tesla%E6%9E%B6%E6%9E%84)
    - [3.2.2 NVidia Fermi架构](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23322-nvidia-fermi%E6%9E%B6%E6%9E%84)
    - [3.2.3 NVidia Maxwell架构](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23323-nvidia-maxwell%E6%9E%B6%E6%9E%84)
    - [3.2.4 NVidia Kepler架构](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23324-nvidia-kepler%E6%9E%B6%E6%9E%84)
    - [3.2.5 NVidia Turing架构](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23325-nvidia-turing%E6%9E%B6%E6%9E%84)



- [3.3 GPU架构的共性](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%2333-gpu%E6%9E%B6%E6%9E%84%E7%9A%84%E5%85%B1%E6%80%A7)



- [四、GPU运行机制](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23%E5%9B%9B%E3%80%81gpu%E8%BF%90%E8%A1%8C%E6%9C%BA%E5%88%B6)
  - [4.1 GPU渲染总览](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%2341-gpu%E6%B8%B2%E6%9F%93%E6%80%BB%E8%A7%88)
  - [4.2 GPU逻辑管线](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%2342-gpu%E9%80%BB%E8%BE%91%E7%AE%A1%E7%BA%BF)
  - [4.3 GPU技术要点](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%2343-gpu%E6%8A%80%E6%9C%AF%E8%A6%81%E7%82%B9)
    - [4.3.1 SIMD和SIMT](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23431-simd%E5%92%8Csimt)
    - [4.3.2 co-issue](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23432-co-issue)
    - [4.3.3 if - else语句](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23433-if---else%E8%AF%AD%E5%8F%A5)
    - [4.3.4 Early-Z](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23434-early-z)
    - [4.3.5 统一着色器架构（Unified shader Architecture）](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23435-%E7%BB%9F%E4%B8%80%E7%9D%80%E8%89%B2%E5%99%A8%E6%9E%B6%E6%9E%84%EF%BC%88unified-shader-architecture%EF%BC%89)
    - [4.3.6 像素块（Pixel Quad）](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23436-%E5%83%8F%E7%B4%A0%E5%9D%97%EF%BC%88pixel-quad%EF%BC%89)



- [4.4 GPU资源机制](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%2344-gpu%E8%B5%84%E6%BA%90%E6%9C%BA%E5%88%B6)
  - [4.4.1 内存架构](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23441-%E5%86%85%E5%AD%98%E6%9E%B6%E6%9E%84)
  - [4.4.2 GPU Context和延迟](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23442-gpu-context%E5%92%8C%E5%BB%B6%E8%BF%9F)
  - [4.4.3 CPU-GPU异构系统](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23443-cpu-gpu%E5%BC%82%E6%9E%84%E7%B3%BB%E7%BB%9F)
  - [4.4.4 GPU资源管理模型](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23444-gpu%E8%B5%84%E6%BA%90%E7%AE%A1%E7%90%86%E6%A8%A1%E5%9E%8B)
  - [4.4.5 CPU-GPU数据流](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23445-cpu-gpu%E6%95%B0%E6%8D%AE%E6%B5%81)
  - [4.4.6 显像机制](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23446-%E6%98%BE%E5%83%8F%E6%9C%BA%E5%88%B6)



- [4.5 Shader运行机制](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%2345-shader%E8%BF%90%E8%A1%8C%E6%9C%BA%E5%88%B6)
- [4.6 利用扩展例证](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%2346-%E5%88%A9%E7%94%A8%E6%89%A9%E5%B1%95%E4%BE%8B%E8%AF%81)



- [五、总结](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23%E4%BA%94%E3%80%81%E6%80%BB%E7%BB%93)
  - [5.1 CPU vs GPU](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%2351-cpu-vs-gpu)
  - [5.2 渲染优化建议](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%2352-%E6%B8%B2%E6%9F%93%E4%BC%98%E5%8C%96%E5%BB%BA%E8%AE%AE)
  - [5.3 GPU的未来](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%2353-gpu%E7%9A%84%E6%9C%AA%E6%9D%A5)
  - [5.4 结语](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%2354-%E7%BB%93%E8%AF%AD)



- [特别说明](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23%E7%89%B9%E5%88%AB%E8%AF%B4%E6%98%8E)
- [参考文献](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23%E5%8F%82%E8%80%83%E6%96%87%E7%8C%AE)



 
**一、导言**
对于大多数图形渲染开发者，GPU是既熟悉又陌生的部件，熟悉的是每天都需要跟它打交道，陌生的是GPU就如一个黑盒，不知道其内部硬件架构，更无从谈及其运行机制。
本文以NVIDIA作为主线，将试图全面且深入地剖析GPU的硬件架构及运行机制，主要涉及PC桌面级的GPU，不会覆盖移动端、专业计算、[图形工作站](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=图形工作站&zhida_source=entity)

级别的GPU。
若要通读本文，要求读者有一定图形学的基础，了解GPU[渲染管线](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=渲染管线&zhida_source=entity)

，最好写过HLSL、GLSL等shader代码。
**1.1 为何要了解GPU？**
了解GPU硬件架构和理解运行机制，笔者认为好处多多，总结出来有：

- 理解GPU其物理结构和运行机制，GPU由黑盒变白盒。
- 更易找出渲染瓶颈，写出高效率shader代码。
- 紧跟时代潮流，了解最前沿渲染技术！
- 技多不压身！

**1.2 内容要点**
本文的内容要点提炼如下：

- GPU简介、历史、特性。
- GPU硬件架构。
- GPU和CPU的协调调度机制。
- GPU缓存结构。
- GPU渲染管线。
- GPU运行机制。
- GPU优化技巧。

**1.3 带着问题阅读**
适当带着问题去阅读技术文章，通常能加深理解和记忆，阅读本文可带着以下问题：
1、GPU是如何与CPU协调工作的？
2、GPU也有[缓存机制](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=缓存机制&zhida_source=entity)

吗？有几层？它们的速度差异多少？
3、GPU的渲染流程有哪些阶段？它们的功能分别是什么？
4、[Early-Z技术](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=Early-Z技术&zhida_source=entity)

是什么？发生在哪个阶段？这个阶段还会发生什么？会产生什么问题？如何解决？
5、SIMD和SIMT是什么？它们的好处是什么？co-issue呢？
6、GPU是并行处理的么？若是，硬件层是如何设计和实现的？
7、GPC、TPC、SM是什么？Warp又是什么？它们和Core、Thread之间的关系如何？
8、顶点着色器（VS）和像素着色器（PS）可以是同一处理单元吗？为什么？
9、像素着色器（PS）的最小处理单位是1像素吗？为什么？会带来什么影响？
10、Shader中的if、for等语句会降低渲染效率吗？为什么？
11、如下图，渲染相同面积的图形，三角形数量少（左）的还是数量多（右）的效率更快？为什么？

![img](https://pica.zhimg.com/v2-194986889f4cfd4f3a103b968f73cdba_1440w.jpg)


12、GPU Context是什么？有什么作用？
13、造成渲染瓶颈的问题很可能有哪些？该如何避免或优化它们？
如果阅读完本文，能够非常清晰地回答以上所有问题，那么，恭喜你掌握到本文的精髓了！
 
**二、GPU概述**
**2.1 GPU是什么？**
**GPU**全称是**Graphics Processing Unit**，图形处理单元。它的功能最初与名字一致，是专门用于绘制图像和处理图元数据的特定芯片，后来渐渐加入了其它很多功能。

![img](https://picx.zhimg.com/v2-f00767850726ceed684672377575a401_1440w.jpg)


*NVIDIA GPU芯片实物图*。
我们日常讨论GPU和显卡时，经常混为一谈，严格来说是有所区别的。GPU是显卡（Video card、Display card、Graphics card）最核心的部件，但除了GPU，显卡还有扇热器、通讯元件、与主板和显示器连接的各类插槽。
对于PC桌面，生产GPU的厂商主要有两家：

- **NVIDIA**：英伟达，是当今首屈一指的[图形渲染技术](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=图形渲染技术&zhida_source=entity)

的引领者和GPU生产商佼佼者。NVIDIA的产品俗称N卡，代表产品有[GeForce系列](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=GeForce系列&zhida_source=entity)

- 、GTX系列、RTX系列等。

![img](https://pic2.zhimg.com/v2-c7a1fde0dbf89bbac18350f4e9a4c279_1440w.jpg)



- **AMD**：既是CPU生产商，也是GPU生产商，它家的显卡俗称A卡。代表产品有Radeon系列。

![img](https://pica.zhimg.com/v2-015aa33bb434e891a80c732889664cc0_1440w.jpg)



当然，NVIDIA和AMD也都生产移动端、图形工作站类型的GPU。此外，生产移动端显卡的厂商还有ARM、Imagination Technology、高通等公司。
**2.2 GPU历史**
GPU自从上世纪90年代出现雏形以来，经过20多年的发展，已经发展成不仅仅是渲染图形这么简单，还包含了数学计算、[物理模拟](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=物理模拟&zhida_source=entity)

、AI运算等功能。
**2.2.1 NV GPU发展史**
以下是GPU发展节点表：

- **1995 – NV1**

![img](https://pic1.zhimg.com/v2-29a01baae0b3772fdad2510f1ea20604_1440w.jpg)


*NV1的渲染画面及其特性。*

- **1997 – Riva 128 (NV3), DX3**
- **1998 – Riva TNT (NV4), DX5**
  - 32位颜色, 24位Z缓存, 8位模板缓存
  - 双纹理, [双线性过滤](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=双线性过滤&zhida_source=entity)

- 每时钟2像素 (2 ppc)



- **1999 - [GeForce 256](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=GeForce+256&zhida_source=entity)**

**（NV10）**

- **固定管线**，支持DirectX 7.0
- **硬件T&L**（Transform & lighting，[坐标变换](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=坐标变换&zhida_source=entity)

和光照）

立方体环境图（Cubemaps）

DOT3 – bump mapping

2倍[各向异性过滤](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=各向异性过滤&zhida_source=entity)

三线性过滤

DXT[纹理压缩](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=纹理压缩&zhida_source=entity)

- 4ppc
- **引入“GPU”术语**

![img](https://pic4.zhimg.com/v2-90665a1fd1538c5f081bec7aad058d19_1440w.jpg)


*NV10的渲染画面及其特性。*

- **2001 - GeForce 3**
  - DirectX 8.0
  - Shader Model 1.0
  - **可编程渲染管线**
    - [顶点着色器](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=2&q=顶点着色器&zhida_source=entity)

- 像素着色器



- 3D纹理
- 硬件阴影图
- 8倍各向异性过滤
- [多采样抗锯齿](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=多采样抗锯齿&zhida_source=entity)

- （MSAA）
- 4 ppc

![img](https://pica.zhimg.com/v2-eb4d617c88a897bdb84582842acf7ace_1440w.jpg)


*NV20的渲染画面及其特性。*

- **2003 - GeForce FX系列（NV3x）**
  - DirectX 9.0
  - Shader Model 2.0
    - 256顶点操作指令
    - 32纹理 + 64算术像素操作指令



- Shader Model 2.0a
  - 256顶点操作指令
  - 512像素操作指令



- **[着色语言](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=着色语言&zhida_source=entity)**

- HLSL
- CGSL
- GLSL



![img](https://pic1.zhimg.com/v2-129d63a0e1a82322a09ecad895b39fc0_1440w.jpg)



*NV30的渲染画面及其特性。*

- **2004 - GeForce 6系列 (NV4x)**
  - DirectX 9.0c
  - Shader Model 3.0
  - **动态流控制**
    - 分支、循环、声明等



- 顶点纹理读取
- 高动态范围（HDR）
  - 64位渲染纹理（Render Target）
  - FP16*4 [纹理过滤](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=纹理过滤&zhida_source=entity)

- 和混合



![img](https://pica.zhimg.com/v2-1d5d40b5aeaa92bbdcadded6eb07f2c4_1440w.jpg)



*NV40的渲染画面及其特性。*

- **2006 - GeForce 8系列 (G8x)**
  - DirectX 10.0
  - Shader Model 4.0
    - 几何着色器（Geometry Shaders）
    - 没有上限位（No caps bits）
    - **统一的着色器（Unified Shaders）**



- Vista系统全新驱动
- 基于GPU计算的CUDA问世
- GPU计算能力以GFLOPS计量。

![img](https://pic3.zhimg.com/v2-867ad7a3f3bccbab206699a773dcfe90_1440w.jpg)


*NV G80的渲染画面及其特性。*

- **2010 - GeForce 405（GF119）**
  - DirectX 11.0
    - **曲面细分（Tessellation）**
      - 外壳着色器（Hull Shader）
      - 镶嵌单元（tessellator）
      - [域着色器](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=域着色器&zhida_source=entity)

- （Domain Shader）



- **计算着色器（Compute Shader）**
  - 支持Stream Output



![img](https://pic4.zhimg.com/v2-93589c113a09c3fcd7b2e8b067bcbab1_1440w.jpg)


*DirectX 11的渲染管线。*

- 多线程支持
- 改进的纹理压缩



- **Shader Model 5.0**
  - 更多指令、存储单元、寄存器
  - 面向对象着色语言
  - 曲面细分
  - 计算着色器





- **2014 - GeForceGT 710（GK208）**
  - DirectX 12.0
    - 轻量化驱动层
    - 硬件级多线程渲染支持



- 更完善的硬件资源管理



- **2016 - GeForceGTX 1060 6GB**
  - 首次支持RTX和DXR技术，即**支持光线追踪**
  - 引入RT Core（光线追踪核心）

![img](https://pic2.zhimg.com/v2-3d3949862b7cc0ffd56a507f50e33a39_1440w.jpg)


*支持RTX光线追踪的显卡列表。*

- **2018 - TITAN RTX（TU102）**
  - DirectX 12.1，OpenGL 4.5
  - 6GPC，36TPC，72SM，72RT Core，...
  - 8K分辨率，1770MHz主频，24G显存，384位带宽

![img](https://pica.zhimg.com/v2-498ca0cfde9614a8eaccc446ea181382_1440w.jpg)





从上面可以看出来，GPU硬件是伴随着图形API标准、游戏一起发展的，并且它们形成了相互相成、相互促进的良性关系。
**2.2.2 NV GPU架构发展史**
众所周知，CPU的发展符合摩尔定律：每18个月速度翻倍。

![img](https://picx.zhimg.com/v2-7baec45c4dbaeb5a38ffd6a386d78545_1440w.jpg)


*处理芯片晶体管数量符合[摩尔定律](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=2&q=摩尔定律&zhida_source=entity)*

*，图右是摩尔本人，Intel的创始人*
而NVIDIA创始人**[黄仁勋](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=黄仁勋&zhida_source=entity)**

在很多年前曾信誓旦旦地说，GPU的速度和功能要超越摩尔定律，每6个月就翻一倍。NV的GPU发展史证明，他确实做到了！GPU的提速幅率远超CPU：

![img](https://pica.zhimg.com/v2-e2add84307f9c6f2a8b9947edca4d04a_1440w.jpg)


NVIDIA GPU架构历经多次变革，从起初的Tesla发展到最新的Turing架构，发展史可分为以下时间节点：

- **2008 - Tesla**
  Tesla最初是给计算处理单元使用的，应用于早期的CUDA系列显卡芯片中，并不是真正意义上的普通图形处理芯片。
- **2010 - Fermi**
  Fermi是第一个完整的GPU计算架构。首款可支持与共享存储结合纯cache层次的GPU架构，支持ECC的GPU架构。
- **2012 - Kepler**
  Kepler相较于Fermi更快，效率更高，性能更好。
- **2014 - Maxwell**
  其全新的[立体像素全局光照](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=立体像素全局光照&zhida_source=entity)

 (VXGI) 技术首次让游戏 GPU 能够提供实时的动态全局光照效果。基于 Maxwell 架构的 [GTX 980](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=GTX+980&zhida_source=entity) 和 970 GPU 采用了包括多帧采样抗锯齿 (MFAA)、动态超级分辨率 (DSR)、VR Direct 以及[超节能设计](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=超节能设计&zhida_source=entity)

在内的一系列新技术。

**2016 - Pascal**
Pascal 架构将处理器和数据集成在同一个程序包内，以实现更高的计算效率。[1080系列](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=1080系列&zhida_source=entity)

、1060系列基于Pascal架构

**2017 - Volta**
Volta 配备640 个Tensor 核心，每秒可提供超过100 兆次[浮点运算](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=浮点运算&zhida_source=entity)

- (TFLOPS) 的深度学习效能，比前一代的Pascal 架构快5 倍以上。
- **2018 - Turing**
  Turing 架构配备了名为 RT Core 的专用光线追踪处理器，能够以高达每秒 10 Giga Rays 的速度对光线和声音在 3D  环境中的传播进行加速计算。Turing 架构将实时光线追踪运算加速至上一代 NVIDIA Pascal™ 架构的 25 倍，并能以高出 CPU  30 多倍的速度进行电影效果的最终帧渲染。2060系列、2080系列显卡也是跳过了Volta直接选择了Turing架构。

下图是部分GPU架构的发展历程：

![img](https://pic1.zhimg.com/v2-c1e1e4dd317dbb9df6086589a57cbff4_1440w.jpg)


**2.3 GPU的功能**
现代GPU除了绘制图形外，还担当了很多额外的功能，综合起来如下几方面：

- **图形绘制。**
  这是GPU最传统的拿手好戏，也是最基础、最核心的功能。为大多数PC桌面、移动设备、图形工作站提供图形处理和绘制功能。
- **物理模拟。**
  GPU硬件集成的物理引擎（PhysX、Havok），为游戏、电影、教育、科学模拟等领域提供了成百上千倍性能的物理模拟，使得以前需要长时间计算的物理模拟得以实时呈现。
- **海量计算。**
  计算着色器及流输出的出现，为各种可以[并行计算](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=并行计算&zhida_source=entity)

的海量需求得以实现，CUDA就是最好的例证。

**AI运算。**
近年来，人工智能的崛起推动了GPU集成了AI Core[运算单元](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=运算单元&zhida_source=entity)

，反哺AI运算能力的提升，给各行各业带来了计算能力的提升。

**其它计算。**
[音视频编解码](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=音视频编解码&zhida_source=entity)

、加解密、科学计算、[离线渲染](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=离线渲染&zhida_source=entity)

- 等等都离不开现代GPU的并行计算能力和海量吞吐能力。


**三、GPU物理架构**
**3.1 GPU宏观物理结构**
由于纳米工艺的引入，GPU可以将数以亿记的晶体管和电子器件集成在一个小小的芯片内。从宏观物理结构上看，现代大多数桌面级GPU的大小跟数枚硬币同等大小，部分甚至比一枚硬币还小（下图）。

![img](https://pic3.zhimg.com/v2-e75304ecbc995270a315bc5db9b28460_1440w.jpg)


*高通骁龙853显示芯片比硬币还小*
当GPU结合散热风扇、PCI插槽、HDMI接口等部件之后，就组成了显卡（下图）。

![img](https://pica.zhimg.com/v2-498ca0cfde9614a8eaccc446ea181382_1440w.jpg)


显卡不能独立工作，需要装载在主板上，结合CPU、内存、显存、显示器等硬件设备，组成完整的PC机。

![img](https://pic4.zhimg.com/v2-ae94e18bd5453bf31a7c88a90a1023b5_1440w.jpg)


*搭载了显卡的主板。*
**3.2 GPU微观物理结构**
GPU的微观结构因不同厂商、不同架构都会有所差异，但核心部件、概念、以及运行机制大同小异。下面将展示部分架构的GPU微观物理结构。
**3.2.1 NVidia Tesla架构**

![img](https://pica.zhimg.com/v2-c7a59138805ad7310466d2c73b8bc62c_1440w.jpg)


Tesla微观架构总览图如上。下面将阐述它的特性和概念：

- 拥有7组TPC（Texture/Processor Cluster，纹理处理簇）
- 每个TPC有两组SM（Stream Multiprocessor，流多处理器）
- 每个SM包含：
  - 6个SP（Streaming Processor，流处理器）
  - 2个SFU（Special Function Unit，[特殊函数](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=特殊函数&zhida_source=entity)

- 单元）
- L1缓存、MT Issue（多线程指令获取）、C-Cache（常量缓存）、共享内存



- 除了TPC核心单元，还有与显存、CPU、系统内存交互的各种部件。

**3.2.2 NVidia Fermi架构**

![img](https://pic3.zhimg.com/v2-02dc1051fe942d08b324c4279529b8be_1440w.jpg)


Fermi架构如上图，它的特性如下：

- 拥有16个SM
- 每个SM：
  - 2个Warp（线程束）
  - 两组共32个Core
  - 16组加载存储单元（LD/ST）
  - 4个特殊函数单元（SFU）



- 每个Warp：
  - 16个Core
  - Warp编排器（Warp Scheduler）
  - 分发单元（Dispatch Unit）



- 每个Core：
  - 1个FPU（浮点数单元）
  - 1个ALU（[逻辑运算单元](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=逻辑运算单元&zhida_source=entity)

- ）



**3.2.3 NVidia Maxwell架构**

![img](https://pic3.zhimg.com/v2-7a1d0568e6e7d80c93fb2dd0b5bbe84a_1440w.jpg)


采用了Maxwell的GM204，拥有4个GPC，每个GPC有4个SM，对比Tesla架构来说，在处理单元上有了很大的提升。
**3.2.4 NVidia Kepler架构**

![img](https://pica.zhimg.com/v2-1f98249cbfb5ae25d89ebee14f4b5df2_1440w.jpg)


Kepler除了在硬件有了提升，有了更多处理单元之外，还将SM升级到了SMX。SMX是改进的架构，支持动态创建[渲染线程](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=渲染线程&zhida_source=entity)

（下图），以降低延迟。

![img](https://pic4.zhimg.com/v2-af327e53b5541c82f4ba2a568baf2f4f_1440w.jpg)


**3.2.5 NVidia Turing架构**

![img](https://pic4.zhimg.com/v2-940f43d36b0b2d84b84992d055cb41dd_1440w.jpg)


上图是采纳了Turing架构的TU102 GPU，它的特点如下：

- 6 GPC（图形处理簇）
- 36 TPC（[纹理处理簇](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=2&q=纹理处理簇&zhida_source=entity)

- ）
- 72 SM（流多处理器）
- 每个GPC有6个TPC，每个TPC有2个SM
- 4,608 CUDA核
- 72 RT核
- 576 Tensor核
- 288 纹理单元
- 12x32位 GDDR6内存控制器 (共384位)

单个SM的结构图如下：

![img](https://pic4.zhimg.com/v2-fab1bba5b9860f6984cd22bebaf34ac7_1440w.jpg)


每个SM包含：

- 64 CUDA核
- 8 Tensor核
- 256 KB寄存器文件

TU102 GPU芯片实物图：

![img](https://pica.zhimg.com/v2-b5194c17865b68dace11e9c38bf95f50_1440w.jpg)


**3.3 GPU架构的共性**
纵观上一节的所有GPU架构，可以发现它们虽然有所差异，但存在着很多相同的概念和部件：

- GPC
- TPC
- Thread
- SM、SMX、SMM
- Warp
- SP
- Core
- ALU
- FPU
- SFU
- ROP
- Load/Store Unit
- L1 Cache
- L2 Cache
- Memory
- Register File

以上各个部件的用途将在下一章详细阐述。
GPU为什么会有这么多层级且有这么多雷同的部件？答案是GPU的任务是天然并行的，现代GPU的架构皆是以高度并行能力而设计的。
 
**四、GPU运行机制**
**4.1 GPU渲染总览**
由上一章可得知，现代GPU有着相似的结构，有很多相同的部件，在运行机制上，也有很多共同点。下面是Fermi架构的运行机制总览图：

![img](https://pic3.zhimg.com/v2-7692eb02eeeb3ba83c0ea285944acec8_1440w.jpg)


从Fermi开始NVIDIA使用类似的原理架构，使用一个Giga Thread Engine来管理所有正在进行的工作，GPU被划分成多个GPCs(Graphics Processing  Cluster)，每个GPC拥有多个SM（SMX、SMM）和一个光栅化引擎(Raster  Engine)，它们其中有很多的连接，最显著的是Crossbar，它可以连接GPCs和其它功能性模块（例如ROP或其他子系统）。
程序员编写的shader是在SM上完成的。每个SM包含许多为线程执行数学运算的Core（核心）。例如，一个线程可以是顶点或像素着色器调用。这些Core和其它单元由Warp Scheduler驱动，Warp Scheduler管理一组32个线程作为Warp（线程束）并将要执行的指令移交给Dispatch  Units。
GPU中实际有多少这些单元（每个GPC有多少个SM，多少个GPC  ......）取决于芯片配置本身。例如，GM204有4个GPC，每个GPC有4个SM，但Tegra  X1有1个GPC和2个SM，它们均采用Maxwell设计。SM设计本身（内核数量，指令单位，[调度程序](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=调度程序&zhida_source=entity)

......）也随着时间的推移而发生变化，并帮助使芯片变得如此高效，可以从高端台式机扩展到笔记本电脑移动。

![img](https://pica.zhimg.com/v2-3fe702c62ce53860114145ce43fdd890_1440w.jpg)


如上图，对于某些GPU（如Fermi部分型号）的单个SM，包含：

- 32个运算核心 （Core，也叫流处理器Stream Processor）
- 16个LD/ST（load/store）模块来加载和存储数据
- 4个SFU（Special function units）执行特殊数学运算（sin、cos、log等）
- 128KB寄存器（Register File）
- 64KB L1缓存
- 全局内存缓存（Uniform Cache）
- 纹理读取单元
- 纹理缓存（Texture Cache）
- PolyMorph Engine：多边形引擎负责属性装配（attribute Setup）、顶点拉取(VertexFetch)、[曲面细分](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=3&q=曲面细分&zhida_source=entity)

- 、栅格化（这个模块可以理解专门处理顶点相关的东西）。
- 2个Warp Schedulers：这个模块负责warp调度，一个warp由32个线程组成，warp调度器的指令通过Dispatch Units送到Core执行。
- 指令缓存（Instruction Cache）
- 内部链接网络（Interconnect Network）

**4.2 GPU逻辑管线**
了解上一节的部件和概念之后，可以深入阐述GPU的渲染过程和步骤。下面将以Fermi家族的SM为例，进行逻辑管线的详细说明。

![img](https://pic2.zhimg.com/v2-8792c13419695fd5ca051208c427dbe7_1440w.jpg)


1、程序通过图形API(DX、GL、WEBGL)发出drawcall指令，指令会被推送到驱动程序，驱动会检查指令的合法性，然后会把指令放到GPU可以读取的Pushbuffer中。
2、经过一段时间或者显式调用flush指令后，驱动程序把Pushbuffer的内容发送给GPU，GPU通过主机接口（Host Interface）接受这些命令，并通过前端（Front End）处理这些命令。
3、在图元分配器(Primitive Distributor)中开始工作分配，处理indexbuffer中的顶点产生三角形分成批次(batches)，然后发送给多个PGCs。这一步的理解就是提交上来n个三角形，分配给这几个PGC同时处理。

![img](https://pic2.zhimg.com/v2-50303aa1b93bf72a00ec057ce4ef6fc1_1440w.jpg)


4、在GPC中，每个SM中的Poly Morph Engine负责通过三角形索引(triangle indices)取出三角形的数据(vertex data)，即图中的Vertex Fetch模块。
5、在获取数据之后，在SM中以32个线程为一组的线程束(Warp)来调度，来开始处理顶点数据。Warp是典型的单指令多线程（SIMT，SIMD单指令多数据的升级）的实现，也就是32个线程同时执行的指令是一模一样的，只是线程数据不一样，这样的好处就是一个warp只需要一个套逻辑对指令进行解码和执行就可以了，芯片可以做的更小更快，之所以可以这么做是由于GPU需要处理的任务是天然并行的。
6、SM的warp调度器会按照顺序分发指令给整个warp，单个warp中的线程会锁步(lock-step)执行各自的指令，如果线程碰到不激活执行的情况也会被遮掩(be masked  out)。被遮掩的原因有很多，例如当前的指令是if(true)的分支，但是当前线程的数据的条件是false，或者循环的次数不一样（比如for循环次数n不是常量，或被break提前终止了但是别的还在走），因此在shader中的分支会显著增加时间消耗，在一个warp中的分支除非32个线程都走到if或者else里面，否则相当于所有的分支都走了一遍，线程不能独立执行指令而是以warp为单位，而这些warp之间才是独立的。
7、warp中的指令可以被一次完成，也可能经过多次调度，例如通常SM中的LD/ST(加载存取)单元数量明显少于基础数学操作单元。
8、由于某些指令比其他指令需要更长的时间才能完成，特别是内存加载，warp调度器可能会简单地切换到另一个没有内存等待的[warp](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=13&q=warp&zhida_source=entity)

，这是GPU如何克服内存读取延迟的关键，只是简单地切换活动线程组。为了使这种切换非常快，调度器管理的所有warp在寄存器文件中都有自己的寄存器。这里就会有个矛盾产生，shader需要越多的寄存器，就会给warp留下越少的空间，就会产生越少的warp，这时候在碰到[内存延迟](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=内存延迟&zhida_source=entity)

的时候就会只是等待，而没有可以运行的warp可以切换。

![img](https://pic2.zhimg.com/v2-397d5557995e266de6de6f84a707daf1_1440w.jpg)


9、一旦warp完成了vertex-shader的所有指令，运算结果会被Viewport Transform模块处理，三角形会被裁剪然后准备[栅格化](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=2&q=栅格化&zhida_source=entity)

，GPU会使用L1和L2缓存来进行vertex-shader和pixel-shader的数据通信。

![img](https://pic4.zhimg.com/v2-7dff80a4d5562c1195c5660e7894d0e5_1440w.jpg)


10、接下来这些三角形将被分割，再分配给多个GPC，三角形的范围决定着它将被分配到哪个光栅引擎(raster engines)，每个raster  engines覆盖了多个屏幕上的tile，这等于把三角形的渲染分配到多个tile上面。也就是像素阶段就把按三角形划分变成了按显示的像素划分了。

![img](https://picx.zhimg.com/v2-18e19ba271539f61c70012e4fa2cc059_1440w.jpg)


11、SM上的Attribute Setup保证了从vertex-shader来的数据经过插值后是pixel-shade是可读的。
12、GPC上的光栅引擎(raster engines)在它接收到的三角形上工作，来负责这些这些三角形的像素信息的生成（同时会处理裁剪Clipping、背面剔除和Early-Z剔除）。
13、32个像素线程将被分成一组，或者说8个2x2的像素块，这是在像素着色器上面的最小工作单元，在这个像素线程内，如果没有被三角形覆盖就会被遮掩，SM中的warp调度器会管理像素着色器的任务。
14、接下来的阶段就和vertex-shader中的逻辑步骤完全一样，但是变成了在像素着色器线程中执行。 由于不耗费任何性能可以获取一个像素内的值，导致锁步执行非常便利，所有的线程可以保证所有的指令可以在同一点。

![img](https://pic1.zhimg.com/v2-31d741448fdceb7f60776c2d44943e4e_1440w.jpg)


15、最后一步，现在像素着色器已经完成了颜色的计算还有深度值的计算，在这个点上，我们必须考虑三角形的原始api顺序，然后才将数据移交给ROP(render output unit，渲染输入单元)，一个ROP内部有很多ROP单元，在ROP单元中处理深度测试，和[framebuffer](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=framebuffer&zhida_source=entity)

的混合，深度和颜色的设置必须是[原子操作](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=原子操作&zhida_source=entity)，否则两个不同的三角形在同一个像素点就会有冲突和错误。
**4.3 GPU技术要点**
由于上一节主要阐述GPU内部的工作流程和机制，为了简洁性，省略了很多知识点和过程，本节将对它们做进一步补充说明。
**4.3.1 SIMD和SIMT**
**SIMD**（Single Instruction Multiple Data）是单指令多数据，在GPU的ALU单元内，一条指令可以处理多维向量（一般是4D）的数据。比如，有以下shader指令：
float4 c = a + b; // a, b都是float4类型
对于没有SIMD的处理单元，需要4条指令将4个float数值相加，汇编[伪代码](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=伪代码&zhida_source=entity)

如下：
ADD c.x, a.x, b.x ADD c.y, a.y, b.y ADD c.z, a.z, b.z ADD c.w, a.w, b.w
但有了SIMD技术，只需一条指令即可处理完：
SIMD_ADD c, a, b

![img](https://pic2.zhimg.com/v2-6b025fbde867f0f6b128d18d35cc842b_1440w.jpg)


**SIMT**（Single Instruction Multiple Threads，[单指令多线程](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=2&q=单指令多线程&zhida_source=entity)

）是SIMD的升级版，可对GPU中单个SM中的多个Core同时处理同一指令，并且每个Core存取的数据可以是不同的。
SIMT_ADD c, a, b
上述指令会被同时送入在单个SM中被编组的所有Core中，同时执行运算，但`a`、`b` 、`c`的值可以不一样：

![img](https://pic4.zhimg.com/v2-8f3ded6ad285664c7e5e51bd864302bb_1440w.jpg)


**4.3.2 co-issue**
**co-issue**是为了解决SIMD运算单元无法充分利用的问题。例如下图，由于float数量的不同，ALU利用率从100%依次下降为75%、50%、25%。

![img](https://pic3.zhimg.com/v2-873d8450740bac583bf7eaa5438e9d8c_1440w.jpg)


为了解决着色器在低维向量的利用率低的问题，可以通过合并1D与3D或2D与2D的指令。例如下图，`DP3`指令用了3D数据，`ADD`指令只有1D数据，co-issue会自动将它们合并，在同一个ALU只需一个指令周期即可执行完。

![img](https://pic3.zhimg.com/v2-3e61da9d87e30e1b3bb4d827519c3374_1440w.png)


但是，对于向量运算单元（Vector ALU），如果其中一个变量既是操作数又是存储数的情况，无法启用co-issue技术：

![img](https://pic2.zhimg.com/v2-d0cc5d11753b686238569a7240a98c65_1440w.jpg)


于是**标量指令着色器**（Scalar Instruction Shader）应运而生，它可以有效地组合任何向量，开启co-issue技术，充分发挥SIMD的优势。
**4.3.3 if - else语句**

![img](https://pic1.zhimg.com/v2-35bb7dd6c5027bc3a7c23e54867b6736_1440w.jpg)


如上图，SM中有8个ALU（Core），由于SIMD的特性，每个ALU的数据不一样，导致`if-else`语句在某些ALU中执行的是`true`分支（黄色），有些ALU执行的是`false`分支（灰蓝色），这样导致很多ALU的执行周期被浪费掉了（即masked out），拉长了整个执行周期。最坏的情况，同一个SM中只有1/8（8是同一个SM的线程数，不同架构的GPU有所不同）的利用率。
同样，`for`循环也会导致类似的情形，例如以下shader代码：
void func(int count, int breakNum) { 	for(int i=0; i<count; ++i) 	{ 		if  (i == breakNum) 			break; 		else 			// do something 	} }
由于每个ALU的`count`不一样，加上有`break`分支，导致最快执行完shader的ALU可能是最慢的N分之一的时间，但由于SIMD的特性，最快的那个ALU依然要等待最慢的ALU执行完毕，才能接下一组指令的活！也就白白浪费了很多时间周期。
**4.3.4 Early-Z**
早期GPU的渲染管线的深度测试是在像素着色器之后才执行（下图），这样会造成很多本不可见的像素执行了耗性能的像素着色器计算。

![img](https://pic2.zhimg.com/v2-66f0dce870467f23e4020f9e27c307d5_1440w.jpg)


后来，为了减少像素着色器的额外消耗，将深度测试提至像素着色器之前（下图），这就是Early-Z技术的由来。

![img](https://pica.zhimg.com/v2-f831036ab1712134a60ee6cd3e2a00e4_1440w.jpg)


Early-Z技术可以将很多无效的像素提前剔除，避免它们进入耗时严重的像素着色器。Early-Z剔除的最小单位不是1像素，而是**像素块**（pixel quad，2x2个像素，详见[4.3.6 ](#4.3.6 像素块（pixel quad）)）。
但是，以下情况会导致Early-Z失效：

- **开启Alpha Test**：由于Alpha Test需要在像素着色器后面的Alpha Test阶段比较，所以无法在像素着色器之前就决定该像素是否被剔除。
- **开启Alpha Blend**：启用了Alpha混合的像素很多需要与frame buffer做混合，无法执行深度测试，也就无法利用Early-Z技术。
- **开启Tex Kill**：即在[shader代码](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=4&q=shader代码&zhida_source=entity)

- 中有像素摒弃指令（DX的discard，OpenGL的clip）。
- **关闭深度测试**。Early-Z是建立在深度测试看开启的条件下，如果关闭了深度测试，也就无法启用Early-Z技术。
- **开启Multi-Sampling**：多采样会影响周边像素，而Early-Z阶段无法得知周边像素是否被裁剪，故无法提前剔除。
- 以及其它任何导致需要混合后面颜色的操作。

此外，Early-Z技术会导致一个问题：**深度数据冲突**（depth data hazard）。

![img](https://pica.zhimg.com/v2-1eb37359abb581e3fc26e110d61f3178_1440w.jpg)


例子要结合上图，假设数值深度值5已经经过Early-Z即将写入Frame  Buffer，而深度值10刚好处于Early-Z阶段，读取并对比当前缓存的深度值15，结果就是10通过了Early-Z测试，会覆盖掉比自己小的深度值5，最终frame buffer的深度值是错误的结果。
避免深度数据冲突的方法之一是在写入深度值之前，再次与frame buffer的值进行对比：

![img](https://pic2.zhimg.com/v2-6ff9920e1ea288df93b00f7c023abc1f_1440w.jpg)


**4.3.5 统一着色器架构（Unified shader Architecture）**
在早期的GPU，顶点着色器和像素着色器的硬件结构是独立的，它们各有各的寄存器、运算单元等部件。这样很多时候，会造成顶点着色器与像素着色器之间任务的不平衡。对于顶点数量多的任务，像素着色器空闲状态多；对于像素多的任务，顶点着色器的空闲状态多（下图）。

![img](https://pica.zhimg.com/v2-3fd6917f9d3ecf2df58a8507a14af05a_1440w.jpg)


于是，为了解决VS和PS之间的不平衡，引入了统一着色器架构（Unified shader Architecture）。用了此架构的GPU，VS和PS用的都是相同的Core。也就是，同一个Core既可以是VS又可以是PS。

![img](https://pic2.zhimg.com/v2-d5ac6924f35d2eeff626c444bfe27be3_1440w.jpg)


这样就解决了不同类型着色器之间的不平衡问题，还可以减少GPU的硬件单元，压缩物理尺寸和耗电量。此外，VS、PS可还可以和其它着色器（几何、曲面、计算）统一为一体。

![img](https://pic2.zhimg.com/v2-d5ed3cfea6be88e9abfe85a5d031d82d_1440w.jpg)


**4.3.6 像素块（Pixel Quad）**
上一节步骤13提到：
32个像素线程将被分成一组，或者说8个**2x2的像素块**，这是在**像素着色器上面的最小工作单元**，在这个像素线程内，如果没有被三角形覆盖就会被遮掩，SM中的warp调度器会管理像素着色器的任务。
也就是说，在像素着色器中，会将相邻的四个像素作为不可分隔的一组，送入同一个SM内4个不同的Core。
为什么像素着色器处理的最小单元是2x2的像素块？
笔者推测有以下原因：
1、简化和加速像素分派的工作。
2、精简SM的架构，减少硬件单元数量和尺寸。
3、降低功耗，提高效能比。
4、无效像素虽然不会被存储结果，但可辅助有效像素求导函数。详见[4.6 利用扩展例证](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23%E5%88%A9%E7%94%A8%E6%89%A9%E5%B1%95%E4%BE%8B%E8%AF%81)。
这种设计虽然有其优势，但同时，也会激化过绘制（Over Draw）的情况，损耗额外的性能。比如下图中，白色的三角形只占用了3个像素（绿色），按我们普通的思维，只需要3个Core绘制3次就可以了。

![img](https://pic4.zhimg.com/v2-2e86dd6a76086b0a6a2fea25df098ca9_1440w.jpg)


但是，由于上面的3个像素分别占据了不同的像素块（橙色分隔），实际上需要占用12个Core绘制12次（下图）。

![img](https://pic1.zhimg.com/v2-750a8f6433a8b093a8df3fe2079e8656_1440w.jpg)


这就会额外消耗300%的硬件性能，导致了更加严重的过绘制情况。
更多详情可以观看虚幻官方的视频教学：[实时渲染深入探究](https://link.zhihu.com/?target=https%3A//learn.unrealengine.com/course/2504896)。
**4.4 GPU资源机制**
本节将阐述GPU的内存访问、资源管理等机制。
**4.4.1 内存架构**
部分架构的GPU与CPU类似，也有多级缓存结构：寄存器、L1缓存、L2缓存、GPU显存、系统显存。

![img](https://pic2.zhimg.com/v2-9b50594bceccea8eac535a071b98337d_1440w.jpg)


它们的存取速度从寄存器到系统内存依次变慢：

| 存储类型 | 寄存器 | 共享内存 | L1缓存 | L2缓存 | 纹理、常量缓存 | 全局内存 |
| -------- | ------ | -------- | ------ | ------ | -------------- | -------- |
|          |        |          |        |        |                |          |


由此可见，shader直接访问寄存器、L1、L2缓存还是比较快的，但访问纹理、常量缓存和全局内存非常慢，会造成很高的延迟。
上面的多级缓存结构可被称为“CPU-Style”，还存在GPU-Style的内存架构：

![img](https://pic3.zhimg.com/v2-781a843db18a7287eff97df8bd2bf8a0_1440w.jpg)


这种架构的特点是ALU多，GPU上下文（Context）多，吞吐量高，依赖高带宽与系统内存交换数据。
**4.4.2 GPU Context和延迟**
由于SIMT技术的引入，导致很多同一个SM内的很多Core并不是独立的，当它们当中有部分Core需要访问到纹理、常量缓存和全局内存时，就会导致非常大的卡顿（Stall）。
例如下图中，有4组上下文（Context），它们共用同一组运算单元ALU。

![img](https://pic4.zhimg.com/v2-db97749ee6b9bbee11a03d6be5d4b2c1_1440w.jpg)


假设第一组Context需要访问缓存或内存，会导致2~3个周期的延迟，此时调度器会激活第二组Context以利用ALU：

![img](https://pic2.zhimg.com/v2-b846fd5373dbe2ecb147e77cd0997e37_1440w.jpg)


当第二组Context访问缓存或内存又卡住，会依次激活第三、第四组Context，直到第一组Context恢复运行或所有都被激活：

![img](https://pic1.zhimg.com/v2-37750f0b46838827df58b51637dbe7ee_1440w.jpg)


延迟的后果是每组Context的总体执行时间被拉长了：

![img](https://pic1.zhimg.com/v2-3cc916313b53b4db6d303c49ea1b3e5c_1440w.jpg)


但是，越多Context可用就越可以提升运算单元的吞吐量，比如下图的18组Context的架构可以最大化地提升吞吐量：

![img](https://pic3.zhimg.com/v2-fc73fae635ecc0002287e0d5c1077b52_1440w.jpg)


**4.4.3 CPU-GPU异构系统**
根据CPU和GPU是否共享内存，可分为两种类型的CPU-GPU架构：

![img](https://pic3.zhimg.com/v2-c4adde277777afc74c1e8f5122b6302c_1440w.jpg)


上图左是**分离式架构**，CPU和GPU各自有独立的缓存和内存，它们通过PCI-e等总线通讯。这种结构的缺点在于 PCI-e 相对于两者具有低带宽和高延迟，数据的传输成了其中的性能瓶颈。目前使用非常广泛，如PC、智能手机等。
上图右是**耦合式架构**，CPU 和 GPU 共享内存和缓存。AMD 的 APU 采用的就是这种结构，目前主要使用在游戏主机中，如 PS4。
在存储管理方面，分离式结构中 CPU 和 GPU 各自拥有独立的内存，两者共享一套[虚拟地址](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=虚拟地址&zhida_source=entity)

空间，必要时会进行内存拷贝。对于耦合式结构，GPU 没有独立的内存，与 GPU 共享系统内存，由 MMU 进行存储管理。
**4.4.4 GPU资源管理模型**
下图是分离式架构的资源管理模型：

![img](https://pic2.zhimg.com/v2-e7a7107e8ac65f36be9e8d84488bd9a9_1440w.jpg)



- **MMIO（Memory Mapped IO）**
  - CPU与GPU的交流就是通过MMIO进行的。CPU 通过 MMIO 访问 GPU 的寄存器状态。
  - DMA传输大量的数据就是通过MMIO进行命令控制的。
  - I/O端口可用于间接访问MMIO区域，像Nouveau等[开源软件](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=开源软件&zhida_source=entity)

- 从来不访问它。



- **GPU Context**
  - GPU Context代表了GPU计算的状态。
  - 在GPU中拥有自己的虚拟地址。
  - GPU 中可以并存多个活跃态下的Context。



- **GPU Channel**
  - 任何命令都是由CPU发出。
  - 命令流（command stream）被提交到硬件单元，也就是GPU Channel。
  - 每个GPU Channel关联一个context，而一个GPU Context可以有多个GPU channel。
  - 每个GPU Context 包含相关channel的 GPU Channel Descriptors ， 每个 Descriptor 都是 GPU 内存中的一个对象。
  - 每个 GPU Channel Descriptor 存储了 Channel 的设置，其中就包括 Page Table 。
  - 每个 GPU Channel 在GPU内存中分配了唯一的命令缓存，这通过MMIO对CPU可见。
  - GPU Context Switching 和命令执行都在GPU硬件内部调度。



- **GPU Page Table**
  - GPU Context在虚拟基地空间由Page Table隔离其它的Context 。
  - GPU Page Table隔离CPU Page Table，位于GPU内存中。
  - GPU Page Table的物理地址位于 GPU Channel Descriptor中。
  - GPU Page Table不仅仅将 GPU虚拟地址转换成GPU内存的物理地址，也可以转换成CPU的物理地址。因此，GPU Page Table可以将GPU虚拟地址和CPU内存地址统一到GPU统一虚拟地址空间来。



- **PCI-e BAR**
  - GPU 设备通过PCI-e总线接入到主机上。 Base Address Registers(BARs) 是 MMIO的窗口，在GPU启动时候配置。
  - GPU的[控制寄存器](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=控制寄存器&zhida_source=entity)

- 和内存都映射到了BARs中。
- GPU设备内存通过映射的MMIO窗口去配置GPU和访问GPU内存。



- **PFIFO Engine**
  - PFIFO是GPU命令提交通过的一个特殊的部件。
  - PFIFO维护了一些独立命令队列，也就是Channel。
  - 此命令队列是Ring Buffer，有PUT和GET的指针。
  - 所有访问Channel控制区域的执行指令都被PFIFO 拦截下来。
  - GPU驱动使用Channel Descriptor来存储相关的Channel设定。
  - PFIFO将读取的命令转交给PGRAPH Engine。



- **BO**
  - Buffer Object (BO)，内存的一块(Block)，能够用于存储纹理（Texture）、[渲染目标](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=渲染目标&zhida_source=entity)

（Render Target）、着色代码（shader code）等等。

Nouveau和Gdev经常使用BO。
Nouveau是一个自由及[开放源代码](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=开放源代码&zhida_source=entity)

显卡[驱动程序](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=3&q=驱动程序&zhida_source=entity)，是为NVidia的显卡所编写。
Gdev是一套丰富的开源软件，用于NVIDIA的GPGPU技术，包括[设备驱动程序](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=设备驱动程序&zhida_source=entity)

- 。



更多详细可以阅读论文：[Data Transfer Matters for GPU Computing](https://link.zhihu.com/?target=http%3A//www.ertl.jp/~shinpei/papers/icpads13.pdf)。
**4.4.5 CPU-GPU数据流**
下图是分离式架构的CPU-GPU的[数据流程图](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=数据流程图&zhida_source=entity)

：

![img](https://pic2.zhimg.com/v2-5b09b5526b10b3a4116c73f0a8f30ee3_1440w.jpg)


1、将主存的处理数据复制到显存中。
2、CPU指令驱动GPU。
3、GPU中的每个运算单元并行处理。此步会从显存存取数据。
4、GPU将显存结果传回主存。
**4.4.6 显像机制**

- **水平和[垂直同步](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=垂直同步&zhida_source=entity)**

- **信号**
  在早期的CRT显示器，电子枪从上到下逐行扫描，扫描完成后显示器就呈现一帧画面。然后电子枪回到初始位置进行下一次扫描。为了同步显示器的显示过程和系统的视频控制器，显示器会用硬件时钟产生一系列的定时信号。

![img](https://picx.zhimg.com/v2-3e3fa32e7b7236ab29e6e29df8e8b949_1440w.jpg)


当电子枪换行进行扫描时，显示器会发出一个水平同步信号（horizonal synchronization），简称 **HSync**
当一帧画面绘制完成后，电子枪回复到原位，准备画下一帧前，显示器会发出一个垂直同步信号（vertical synchronization），简称 **VSync**。
显示器通常以固定频率进行刷新，这个刷新率就是 VSync 信号产生的频率。虽然现在的显示器基本都是液晶显示屏了，但其原理基本一致。
CPU将计算好显示内容提交至 GPU，GPU 渲染完成后将渲染结果存入帧缓冲区，视频控制器会按照 VSync 信号逐帧读取帧缓冲区的数据，经过数据转换后最终由显示器进行显示。

![img](https://pic1.zhimg.com/v2-a6c20d32f4f9cfa2a8047e91c4d65364_1440w.jpg)



- **双缓冲**
  在单缓冲下，帧缓冲区的读取和刷新都都会有比较大的效率问题，经常会出现相互等待的情况，导致帧率下降。
  为了解决效率问题，GPU 通常会引入两个缓冲区，即 **双缓冲机制**。在这种情况下，GPU 会预先渲染一帧放入一个缓冲区中，用于视频控制器的读取。当下一帧渲染完毕后，GPU 会直接把视频控制器的指针指向第二个缓冲器。

![img](https://picx.zhimg.com/v2-58c88c01930f8621406973cb151e2967_1440w.jpg)



- **垂直同步**
  双缓冲虽然能解决效率问题，但会引入一个新的问题。当视频控制器还未读取完成时，即屏幕内容刚显示一半时，GPU 将新的一帧内容提交到帧缓冲区并把两个缓冲区进行交换后，视频控制器就会把新的一帧数据的下半段显示到屏幕上，造成[画面撕裂](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=画面撕裂&zhida_source=entity)

- 现象：

![img](https://pic1.zhimg.com/v2-e03e5040c49eeea6a8f5d67ca6c56f58_1440w.jpg)


为了解决这个问题，GPU 通常有一个机制叫做**垂直同步**（简写也是V-Sync），当开启垂直同步后，GPU 会等待显示器的 VSync 信号发出后，才进行新的一帧渲染和缓冲区更新。这样能解决画面撕裂现象，也增加了画面流畅度，但需要消费更多的计算资源，也会带来部分延迟。

**4.5 Shader运行机制**
Shader代码也跟传统的C++等语言类似，需要将面向人类的高级语言（GLSL、HLSL、CGSL）通过编译器转成面向机器的二进制指令，二进制指令可转译成汇编代码，以便技术人员查阅和调试。

![img](https://pic1.zhimg.com/v2-cb2311a3213ef171427b400fa8703870_1440w.png)


由高级语言编译成[汇编指令](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=汇编指令&zhida_source=entity)

的过程通常是在离线阶段执行，以减轻运行时的消耗。
在执行阶段，CPU端将shader二进制指令经由PCI-e推送到GPU端，GPU在执行代码时，会用Context将指令分成若干Channel推送到各个Core的存储空间。
对现代GPU而言，可编程的阶段越来越多，包含但不限于：顶点着色器（Vertex Shader）、曲面细分控制着色器（Tessellation Control Shader）、几何着色器（Geometry Shader）、像素/[片元着色器](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=片元着色器&zhida_source=entity)

（Fragment Shader）、计算着色器（Compute Shader）、...

![img](https://pica.zhimg.com/v2-4e4c642970cf19681f99614c0e9ebffc_1440w.jpg)


这些着色器形成流水线式的并行化的渲染管线。下面将配合具体的例子说明。
下段是计算漫反射的经典代码：
sampler mySamp; Texture2D<float3> myTex; float3 lightDir;  float4  diffuseShader(float3 norm, float2 uv) { 	float3 kd; 	kd =  myTex.Sample(mySamp, uv); 	kd *= clamp( dot(lightDir, norm), 0.0, 1.0);  return float4(kd, 1.0); }
经过编译后成为[汇编代码](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=2&q=汇编代码&zhida_source=entity)

：
<diffuseShader>: sample r0, v4, t0, s0 mul    r3, v0, cb0[0] madd   r3, v1, cb0[1], r3  madd   r3, v2, cb0[2], r3 clmp   r3, r3, l(0.0), l(1.0) mul    o0, r0,  r3 mul    o1, r1, r3 mul    o2, r2, r3 mov    o3, l(1.0)
在执行阶段，以上汇编代码会被GPU推送到执行上下文（Execution Context），然后ALU会逐条获取（Detch）、解码（Decode）汇编指令，并执行它们。

![img](https://pic2.zhimg.com/v2-6b261bbe88e8cfcb8f7fceaf515de793_1440w.jpg)


以上示例图只是单个ALU的执行情况，实际上，GPU有几十甚至上百个执行单元在同时执行[shader指令](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=2&q=shader指令&zhida_source=entity)

：

![img](https://pic4.zhimg.com/v2-6e80019193d38351a2d4d8e878cfa6a1_1440w.jpg)


对于SIMT架构的GPU，汇编指令有所不同，变成了SIMT特定指令代码：
<VEC8_diffuseShader>:  VEC8_sample vec_r0, vec_v4, t0, vec_s0  VEC8_mul    vec_r3, vec_v0,  cb0[0]  VEC8_madd   vec_r3, vec_v1, cb0[1], vec_r3  VEC8_madd   vec_r3,  vec_v2, cb0[2], vec_r3 VEC8_clmp   vec_r3, vec_r3, l(0.0), l(1.0)   VEC8_mul    vec_o0, vec_r0, vec_r3  VEC8_mul    vec_o1, vec_r1, vec_r3   VEC8_mul    vec_o2, vec_r2, vec_r3  VEC8_mov    o3, l(1.0)
并且Context以Core为单位组成共享的结构，同一个Core的多个ALU共享一组Context：

![img](https://pic2.zhimg.com/v2-74165dd53515025d7de9302ba55352e1_1440w.jpg)


如果有多个Core，就会有更多的ALU同时参与shader计算，每个Core执行的数据是不一样的，可能是顶点、图元、像素等任何数据：

![img](https://pic1.zhimg.com/v2-6cef64b2caa7f6bc470ca7b5c84aacb2_1440w.jpg)


**4.6 利用扩展例证**
[NV shader thread group](https://link.zhihu.com/?target=https%3A//www.opengl.org/registry/specs/NV/shader_thread_group.txt)提供了OpenGL的扩展，可以查询[GPU线程](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=GPU线程&zhida_source=entity)

、Core、SM、Warp等硬件相关的属性。如果要开启次此扩展，需要满足以下条件：

- OpenGL 4.3+；
- GLSL 4.3+；
- 支持OpenGL 4.3+的NV显卡；

并且此扩展只在NV部分5代着色器内起作用：
This extension interacts with NV_gpu_program5
This extension interacts with NV_compute_program5
This extension interacts with NV_tessellation_program5
下面是具体的字段和代表的意义：
// 开启扩展 #extension GL_NV_shader_thread_group : require     (or enable)   WARP_SIZE_NV	// 单个线程束的线程数量 WARPS_PER_SM_NV	// 单个SM的线程束数量 SM_COUNT_NV		// SM数量  uniform uint  gl_WarpSizeNV;	// 单个线程束的线程数量 uniform uint   gl_WarpsPerSMNV;	// 单个SM的线程束数量 uniform uint  gl_SMCountNV;		// SM数量  in  uint  gl_WarpIDNV;		// 当前线程束id in uint  gl_SMIDNV;			// 当前线程束所在的SM  id，取值[0, gl_SMCountNV-1] in uint  gl_ThreadInWarpNV;	// 当前线程id，取值[0,  gl_WarpSizeNV-1]  in uint  gl_ThreadEqMaskNV;	// 是否等于当前线程id的位域掩码。 in  uint  gl_ThreadGeMaskNV;	// 是否大于等于当前线程id的位域掩码。 in uint   gl_ThreadGtMaskNV;	// 是否大于当前线程id的位域掩码。 in uint  gl_ThreadLeMaskNV;	//  是否小于等于当前线程id的位域掩码。 in uint  gl_ThreadLtMaskNV;	// 是否小于当前线程id的位域掩码。  in  bool  gl_HelperThreadNV;	// 当前线程是否协助型线程。
上述所说的协助型线程`gl_HelperThreadNV`是指在处理2x2的像素块时，那些未被图元覆盖的像素着色器线程将被标记为`gl_HelperThreadNV = true`，它们的结果将被忽略，也不会被存储，但可辅助一些计算，如导数`dFdx`和`dFdy`。为了防止理解有误，贴出原文：
The variable gl_HelperThreadNV specifies if the current thread is a helper  thread. In implementations supporting this extension, fragment shader  invocations may be arranged in SIMD thread groups of 2x2 fragments  called "quad". When a fragment shader instruction is executed on a quad, it's possible that some fragments within the quad will execute the  instruction even if they are not covered by the primitive. Those threads are called helper threads. Their outputs will be discarded and they  will not execute global store functions, but the intermediate values  they compute can still be used by thread group sharing functions or by  fragment derivative functions like dFdx and dFdy.
利用以上字段，可以编写特殊shader代码转成颜色信息，以便可视化窥探GPU的工作机制和流程。

![img](https://pic3.zhimg.com/v2-70f01c04fec375b7f2eb9ba0a294a492_1440w.jpg)


*利用NV扩展字段，可视化了顶点着色器、像素着色器的SM、Warp id，为我们查探GPU的工作机制和流程提供了途径。*
下面正式进入验证阶段，将以Geforce RTX 2060作为验证对象，具体信息如下：
操作系统： Windows 10 Pro, 64-bit
DirectX 版本： 12.0
GPU 处理器： GeForce RTX 2060
驱动程序版本： 417.71
Driver Type: Standard
Direct3D API 版本： 12
Direct3D 功能级别：12_1
CUDA 核心： 1920
核心时钟： 1710 MHz
内存数据速率： 14.00 Gbps
内存接口： 192-位
内存带宽： 336.05 GB/秒
全部可用的图形内存：22494MB
专用视频内存： 6144 MB GDDR6
系统视频内存： 0MB
共享系统内存： 16350MB
视频 BIOS 版本： 90.06.3F.00.73
IRQ： Not used
总线： PCI Express x16 Gen3
首先在应用程序创建包含两个三角形的顶点数据：
// set up vertex data (and buffer(s)) and configure vertex [attributes](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=attributes&zhida_source=entity)

 const float HalfSize = 1.0f; float vertices[] = { 	-HalfSize,  -HalfSize, 0.0f, // left bottom 	HalfSize, -HalfSize, 0.0f,  // right  bottom 	-HalfSize,  HalfSize, 0.0f, // top left  	-HalfSize,  HalfSize,  0.0f, // top left 	HalfSize, -HalfSize, 0.0f,  // right bottom 	 HalfSize,  HalfSize, 0.0f,  // top right };
渲染采用的顶点着色器非常简单：
\#version 430 core  layout (location = 0) in [vec3](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=vec3&zhida_source=entity)

 aPos;  void main() { 	gl_Position = vec4(aPos, 1.0f); }
片元着色器也是寥寥数行：
\#version 430 core  out vec4 FragColor;  void main() { 	FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f); }
绘制出来的原始画面如下：

![img](https://pica.zhimg.com/v2-911e2a2bbbaad2f8bed78c96d8870750_1440w.jpg)


紧接着，修改片元着色器，加入扩展所需的代码，并修改颜色计算：
\#version 430 core #extension GL_NV_shader_thread_group : require  uniform uint   gl_WarpSizeNV;	// 单个线程束的线程数量 uniform uint  gl_WarpsPerSMNV;	//  单个SM的线程束数量 uniform uint  gl_SMCountNV;		// SM数量  in uint  gl_WarpIDNV;		 // 当前线程束id in uint  gl_SMIDNV;			// 当前线程所在的SM id，取值[0, gl_SMCountNV-1]  in uint  gl_ThreadInWarpNV;	// 当前线程id，取值[0, gl_WarpSizeNV-1]  out vec4  FragColor;  void main() { 	// SM id 	float lightness = gl_SMIDNV /  gl_SMCountNV; 	FragColor = vec4(lightness); }
由上面的代码渲染的画面如下：

![img](https://picx.zhimg.com/v2-dcb3408a16dd9160c94bb78bd0689fb7_1440w.jpg)


从上面可分析出一些信息：

- 画面共有32个亮度色阶，也就是Geforce RTX 2060有32个SM。
- 单个SM每次渲染16x16为单位的像素块，也就是每个SM有256个Core。
- SM之间不是顺序分配像素块，而是无序分配。
- 不同三角形的接缝处出现断层，说明同一个像素块如果分属不同的三角形，就会分配到不同的SM进行处理。由此推断，**相同面积的区域，如果所属的三角形越多，就会导致分配给SM的次数越多，消耗的渲染性能也越多**。

接着修改片元着色器的颜色计算代码以显示Warp id：
// warp id float lightness = gl_WarpIDNV / gl_WarpsPerSMNV; FragColor = [vec4](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=6&q=vec4&zhida_source=entity)

(lightness);
得到如下画面：

![img](https://pic4.zhimg.com/v2-72671702d39cb35cc4fd3a61b2f5edfd_1440w.jpg)


由此可得出一些信息或推论：

- 画面共有32个亮度色阶，也就是每个SM有32个Warp，每个Warp有8个Core。
- 每个色块像素是4x8，由于每个Warp有8个Core，由此推断每个Core单次要处理2x2的最小单元像素块。
- 也是无序分配像素块。
- 三角形接缝处出现断层，同SM的推断一致。

再修改片元着色器的颜色计算代码以显示线程id：
// thread id float lightness = gl_ThreadInWarpNV / gl_WarpSizeNV; FragColor = vec4(lightness);
得到如下画面：

![img](https://pic1.zhimg.com/v2-5c772d29497755079f0cd1b768607398_1440w.jpg)


为了方便分析，用Photoshop对中间局部放大10倍，得到以下画面：

![img](https://picx.zhimg.com/v2-7f9e28bcf8908ff477d4d4411e21e04d_1440w.jpg)


结合上面两幅图，也可以得出一些结论：

- 相较SM、线程束，线程分布图比较规律。说明同一个Warp的线程分布是规律的。
- 三角形接缝处出现紊乱，说明是不同的Warp造成了不同的线程。
- 画面有32个色阶，说明单个Warp有32个线程。
- 每个像素独占一个亮度色阶，与周边相邻像素都不同，说明每个线程只处理一个像素。

再次说明，以上画面和结论是基于Geforce RTX 2060，不同型号的GPU可能会不一样，得到的结果和推论也会有所不同。
更多NV扩展可参见OpenGL官网：[NV extensions](https://link.zhihu.com/?target=https%3A//www.khronos.org/registry/OpenGL/extensions/NV/)。
 
**五、总结**
**5.1 CPU vs GPU**
CPU和GPU的差异可以描述在下面表格中：

|      | CPU  | GPU  |
| ---- | ---- | ---- |
|      |      |      |


它们之间的差异（缓存、核心数量、内存、线程数等）可用下图展示出来：

![img](https://pic4.zhimg.com/v2-b782be687d466cb360b010a1daabb2a5_1440w.jpg)


**5.2 渲染优化建议**
由上章的分析，可以很容易给出渲染优化建议：

- **减少CPU和GPU的数据交换：**
  - 合批（Batch）
  - 减少顶点数、三角形数
  - [视锥裁剪](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=视锥裁剪&zhida_source=entity)

- BVH
- Portal
- BSP
- OSP



- 避免每帧提交Buffer数据
  - CPU版的粒子、动画会每帧修改、提交数据，可移至GPU端。



- 减少渲染状态设置和查询
  - 例如：`glGetUniformLocation`会从GPU内存查询状态，耗费很多时间周期。
  - 避免每帧设置、查询渲染状态，可在初始化时缓存状态。



- 启用GPU Instance
- 开启LOD
- 避免从显存读数据



- **减少过绘制：**
  - 避免Tex Kill操作
  - 避免Alpha Test
  - 避免Alpha Blend
  - 开启深度测试
    - Early-Z
    - 层次Z缓冲（Hierarchical Z-Buffering，HZB）



- 开启裁剪：
  - 背面裁剪
  - 遮挡裁剪
  - 视口裁剪
  - 剪切矩形（scissor rectangle）



- 控制物体数量
  - 粒子数量多且面积小，由于像素块机制，会加剧过绘制情况
  - 植物、沙石、毛发等也如此





- **Shader优化：**
  - 避免if、switch分支语句
  - 避免`for`[循环语句](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=循环语句&zhida_source=entity)

- ，特别是循环次数可变的
- 减少纹理采样次数
- 禁用`clip`或`discard`操作
- 减少复杂数学函数调用



更多优化技巧可阅读：

- [移动游戏性能优化通用技法](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/10463467.html)。
- [GPU Programming Guide](https://link.zhihu.com/?target=http%3A//developer.download.nvidia.com/GPU_Programming_Guide/GPU_Programming_Guide_G80.pdf)。
- [Real-Time Rendering Resources](https://link.zhihu.com/?target=http%3A//www.realtimerendering.com/)。

**5.3 GPU的未来**
从章节[2.2 GPU历史](#2.2 GPU历史)可以得出一些结论，也可以推测GPU发展的趋势：

- **硬件升级**。更多运算单元，更多存储空间，更高并发，更高带宽，更低延时。。。
- **Tile-Based Rendering的集成**。基于瓦片的渲染可以一定程度降低带宽和提升光照计算效率，目前部分移动端及桌面的GPU已经引入这个技术，未来将有望成为常态。

![img](https://picx.zhimg.com/v2-8c27fb9a373400378aad0798657de66b_1440w.jpg)



- **3D内存技术**。目前大多数传统的内存是2D的，3D内存则不同，在物理结构上是3D的，类似立方体结构，集成于芯片内。可获得几倍的访问速度和效能比。

![img](https://pic2.zhimg.com/v2-e2e5600fef48b43a3835d5767d2d0939_1440w.jpg)



- **GPU愈加可编程化**。GPU天生是并行且相对固定的，未来将会开放越来越多的shader可供编程，而CPU刚好相反，将往并行化发展。也就是说，未来的GPU越来越像CPU，而CPU越来越像GPU。难道它们应验了古语：合久必分，分久必合么？

![img](https://pic3.zhimg.com/v2-319c9e79ced72e564cdede5b5a6cc572_1440w.jpg)



- **实时光照追踪的普及**。基于Turing架构的GPU已经加入大量RT Core、HVB、AI降噪等技术，**Hybrid Rendering Pipeline**就是此架构的光线追踪渲染管线，能够同时结合[光栅化器](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=光栅化器&zhida_source=entity)

、RT Core、Compute Core执行[混合渲染](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=混合渲染&zhida_source=entity)

- ：

![img](https://pica.zhimg.com/v2-7cc6d922418764fae362ac6fbe5cce0e_1440w.jpg)


Hybrid Rendering Pipeline相当于光线追踪渲染管线和光栅化渲染管线的合体：

![img](https://pic3.zhimg.com/v2-8ed13ba18f0519b3d930c7cc62690cf2_1440w.jpg)



- **数据并发提升、深度神经网络、GPU计算单元等普及及提升**。

![img](https://pic4.zhimg.com/v2-2649b81f6ef0172ce10aa59169df0edf_1440w.jpg)



- **AI降噪和AI抗锯齿**。AI降噪已经在部分RTX系列的光线追踪版本得到应用，而AI抗锯齿（Super Res）可用于超高分辨率的视频图像抗锯齿：

![img](https://pic3.zhimg.com/v2-7cdd2269056a7ab07690b365363078d4_1440w.jpg)



- **基于任务和[网格着色器](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=网格着色器&zhida_source=entity)**

**的渲染管线**。基于任务和网格着色器的渲染管线（Graphics Pipeline with Task and Mesh Shaders）与传统的[光栅化](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=4&q=光栅化&zhida_source=entity)

- 渲染光线有着很大的差异，它以线程组（Thread Group）、任务着色器（Task shader）和网格着色器（Mesh shader）为基础，形成一种全新的渲染管线：

![img](https://picx.zhimg.com/v2-e6c8308f6cf854e1a170ec8307960b33_1440w.jpg)


关于此技术的更多详情可阅读：[NVIDIA Turing Architecture Whitepaper](https://link.zhihu.com/?target=https%3A//www.nvidia.com/content/dam/en-zz/Solutions/design-visualization/technologies/turing-architecture/NVIDIA-Turing-Architecture-Whitepaper.pdf)。

- **[可变速率着色](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=可变速率着色&zhida_source=entity)**

- **（Variable Rate Shading）**。可变利率着色技术可判断画面区域的重要性（或由应用程序指定），然后根据画面区域的重要性程度采用不同的着色分辨率精度，可以显著降低功耗，提高着色效率。

![img](https://pic4.zhimg.com/v2-411ed37714cf40b20d68cec5ed6a0e15_1440w.jpg)


**5.4 结语**
本文系统地讲解了GPU的历史、发展、工作流程，以及部分过程的细化说明和用到的各种技术，我们从中可以看到GPU架构的动机、机制、瓶颈，以及未来的发展。
希望看完本文，大家能很好地回答导言提出的问题：[1.3 带着问题阅读](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11471507.html%23%E5%B8%A6%E7%9D%80%E9%97%AE%E9%A2%98%E9%98%85%E8%AF%BB)。如果不能全部回答，也没关系，回头看相关章节，总能找到答案。
如果想更深入地了解GPU的设计细节、实现细节，可阅读GPU厂商定期发布的[白皮书](https://zhida.zhihu.com/search?content_id=167487986&content_type=Article&match_order=1&q=白皮书&zhida_source=entity)

和各大高校、机构发布的论文。推荐一个GPU解说视频：[A trip through the Graphics Pipeline 2011: Index](https://link.zhihu.com/?target=https%3A//fgiesen.wordpress.com/2011/07/09/a-trip-through-the-graphics-pipeline-2011-index/)，虽然是多年前的视频，但比较系统、全面地讲解了GPU的机制和技术。
 
**特别说明**

- 感谢所有参考文献的作者们！
- **原创文章，未经许可，禁止转载！**


**参考文献**

- [Real-Time Rendering Resources](https://link.zhihu.com/?target=http%3A//www.realtimerendering.com/)
- [Life of a triangle - NVIDIA's logical pipeline](https://link.zhihu.com/?target=https%3A//developer.nvidia.com/content/life-triangle-nvidias-logical-pipeline)
- [NVIDIA Pascal Architecture Whitepaper](https://link.zhihu.com/?target=https%3A//images.nvidia.com/content/pdf/tesla/whitepaper/pascal-architecture-whitepaper.pdf)
- [NVIDIA Turing Architecture Whitepaper](https://link.zhihu.com/?target=https%3A//www.nvidia.com/content/dam/en-zz/Solutions/design-visualization/technologies/turing-architecture/NVIDIA-Turing-Architecture-Whitepaper.pdf)
- [Pomegranate: A Fully Scalable Graphics Architecture](https://link.zhihu.com/?target=http%3A//graphics.stanford.edu/papers/pomegranate/pomegranate.pdf)
- [Performance Optimization Guidelines and the GPU Architecture behind them](https://link.zhihu.com/?target=http%3A//on-demand.gputechconf.com/gtc/2013/video/S3466-Performance-Optimization-Guidelines-GPU-Architecture-Details.mp4)
- [A trip through the Graphics Pipeline 2011](https://link.zhihu.com/?target=https%3A//fgiesen.wordpress.com/2011/07/09/a-trip-through-the-graphics-pipeline-2011-index/)
- [Graphic Architecture introduction and analysis](https://link.zhihu.com/?target=https%3A//nielshagoort.com/2019/03/12/exploring-the-gpu-architecture/)
- [Exploring the GPU Architecture](https://link.zhihu.com/?target=https%3A//nielshagoort.com/2019/03/12/exploring-the-gpu-architecture/)
- [Introduction to GPU Architecture](https://link.zhihu.com/?target=http%3A//haifux.org/lectures/267/Introduction-to-GPUs.pdf)
- [An Introduction to Modern GPU Architecture](https://link.zhihu.com/?target=http%3A//download.nvidia.com/developer/cuda/seminar/TDCI_Arch.pdf)
- [GPU TECHNOLOGY: PAST, PRESENT, FUTURE](https://link.zhihu.com/?target=https%3A//www.nvidia.com.tw/content/PDF/GTC/keynote/marc-hamilton-nvidia-keynote.pdf)
- [GPU Computing & Architectures](https://link.zhihu.com/?target=http%3A//www.eziobartocci.com/intro_1.pdf)
- [NVIDIA VOLTA](https://link.zhihu.com/?target=https%3A//www.nvidia.com/zh-tw/data-center/volta-gpu-architecture/)
- [NVIDIA TURING](https://link.zhihu.com/?target=https%3A//www.nvidia.cn/design-visualization/technologies/turing-architecture/)
- [Graphics processing unit](https://link.zhihu.com/?target=https%3A//en.wikipedia.org/wiki/Graphics_processing_unit)
- [GPU并行架构及渲染优化](https://zhuanlan.zhihu.com/p/61358167)
- [渲染优化-从GPU的结构谈起](https://zhuanlan.zhihu.com/p/58694744)
- [GPU Architecture and Models](https://link.zhihu.com/?target=https%3A//www.cs.utah.edu/~jeffp/teaching/MCMD/S20-GPU.pdf)
- [Introduction to and History of GPU Algorithms](https://link.zhihu.com/?target=https%3A//www.cs.utah.edu/~jeffp/teaching/MCMD/GPU-intro.pdf)
- [GPU Architecture Overview](https://link.zhihu.com/?target=https%3A//insujang.github.io/2017-04-27/gpu-architecture-overview/)
- [计算机那些事(8)——图形图像渲染原理](https://link.zhihu.com/?target=http%3A//chuquan.me/2018/08/26/graphics-rending-principle-gpu/)
- [GPU Programming Guide GeForce 8 and 9 Series](https://link.zhihu.com/?target=http%3A//developer.download.nvidia.com/GPU_Programming_Guide/GPU_Programming_Guide_G80.pdf)
- [GPU的工作原理](https://zhuanlan.zhihu.com/p/34675934)
- [NVIDIA显示核心列表](https://link.zhihu.com/?target=https%3A//zh.wikipedia.org/wiki/NVIDIA%E9%A1%AF%E7%A4%BA%E6%A0%B8%E5%BF%83%E5%88%97%E8%A1%A8)
- [DirectX](https://link.zhihu.com/?target=https%3A//zh.wikipedia.org/wiki/DirectX)
- [高级着色器语言](https://link.zhihu.com/?target=https%3A//zh.wikipedia.org/wiki/%E9%AB%98%E7%BA%A7%E7%9D%80%E8%89%B2%E5%99%A8%E8%AF%AD%E8%A8%80)
- [探究光线追踪技术及UE4的实现](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/11366199.html)
- [移动游戏性能优化通用技法](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/p/10463467.html)
- [NV shader thread group](https://link.zhihu.com/?target=https%3A//www.opengl.org/registry/specs/NV/shader_thread_group.txt)
- [实时渲染深入探究](https://link.zhihu.com/?target=https%3A//learn.unrealengine.com/course/2504896)
- [NVIDIA GPU 硬件介绍](https://link.zhihu.com/?target=http%3A//juniorprincewang.github.io/2018/07/14/NVIDIA-GPU-%E7%A1%AC%E4%BB%B6%E4%BB%8B%E7%BB%8D/)
- [Data Transfer Matters for GPU Computing](https://link.zhihu.com/?target=http%3A//www.ertl.jp/~shinpei/papers/icpads13.pdf)
- [Slang – A Shader Compilation System](https://link.zhihu.com/?target=http%3A//graphics.cs.cmu.edu/projects/slang/he18_slang.pdf)
- [Graphics Shaders - Theory and Practice 2nd Edition](https://link.zhihu.com/?target=http%3A//cs.uns.edu.ar/cg/clasespdf/GraphicShaders.pdf)





分类: [C/C++/Lua](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/category/1409894.html), [计算机图形学](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/category/1409892.html)
**标签:** **[GPU](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/tag/GPU/),** **[shader](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/tag/shader/),** **[glsl](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/tag/glsl/),** **[hlsl](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/timlly/tag/hlsl/)**

发布于 2021-03-15 06:52

### 内容所属专栏

- ![用你听得懂的话讲科普](https://pic1.zhimg.com/v2-f111d7ee1c41944859e975a712c0883b_l.jpg?source=172ae18b)

  ## [用你听得懂的话讲科普](https://www.zhihu.com/column/c_1187264588697001984)
