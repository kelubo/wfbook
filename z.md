mscan meteo
频率及发送时间：查找 HF-FAX网站： http://www.hffax.de
中国的一些频率：
北京时间:
上午 09:10  13.987MHz
     09:30  13.8985Mhz(该频率信号较好)
下午 15:10  13.987Mhz
     15:30  13.8985Mhz
  USB模式，可以接受比较清楚的卫星云图，可以很好的反映和预测天气。
在我国接收比较好的有JMH,BMF,和HLL电台。

将收音机音频输出连接至计算机声卡输入端，实在不行用耳机对着麦克也行
在对应频率，打开SSB接收模式，等着吧
使用解调软件解调出数据就可以了
为了达到较好的接收效果，实际接收频率要比表中提供的频率低1.5-2.0kHz，也可以以频谱的那个小窗口做参考，使频谱落在两个黄点之间。
除卫星云图和测试图象外，用的是二值图（频谱集中在+400/-400Hz上），而卫星云图则是16级或者4级灰度的灰度图。
    使用HFFAX文件传输的长度基本是没有限制的，但是慢扫描电视(SSTV)一般是彩色的，图象尺寸很小。而高频电传(HFFAX)的BMP文件大约在1~4M。

下面是台湾业余无线电爱好者接收的具体步骤：
准备软件: JvComm32
短波收音机: SANGEAN ATS-803A 约调在 LSB和USB 中间
频率 : 04616KHz 05250KHz 08140KHz 13900KHz 18560KHz
使用 USB MODE 频率为 04614.1KHz 05248.1KHz 08138.1KHz 13898.1KHz 18558.1KHz
接收 Call:BMB　Name:Tai-pei Meteo　ITU:TAI　RPM/IOC:120/576　
UTC:01:20,07:20,13:20,19:20
UTC 时间换算为中原标准时间方法为减八小时.
频率及发送时间可查找 HF-FAX http://www.hffax.de
1.安装完成 JvComm32
2.点击开启 JvComm32(图JvComm32.bmp)
3.设定音卡点击
　于 内设定
　　Interface type: Sound Card
　　Data rate: 随着机器的不同需要做调整
　　Sound card select:
　　SSTV : 依实际状况来设定
　　FM/TTY: 依实际状况来设定(我是使用 Microphone 放在短波收音机上而已)
　　AM: 依实际状况来设定
　　然后点击 OK(图 Config.bmp)
4.点击 Mode 选取 2 FAX(图 FAX.bmp)
　(点击后出现 FAX-RX Window 视窗与 Spectrum视窗)
　若没出现 Spectrum 视窗可点击 即会出现或消失
5.调整短波收音机的频率到(图 TONE.mbp) 的位置
　平时没有传送资料时先调至该位置上
　尽量将声音大小控制在绿色的区段内(图 mid.bmp)
6.点击 Receive Continuously 可以在来不及从头开始接收时; 可接收后续的图.
    电传打字(TTY)接收传送气象电码及大型传真机接收卫星云图,大部分都是用有线电专线或微波传输,只有当地气象资料是由SSB无线电传送,再交由气象值班人员绘制气象图,提供有关人员参考。

传输方式属于RTTY，其实我们还可以用PL-600接收业余频段的图像数据
教你如何辨别RTTY http://zuji.51.net/bcl/download/sstv.wav

在这里
http://mscan.com/download/SetupMscanMeteo.exe

中越战争的年代，估计该台（站）还没有全固态的发射机。

关于真空管的寿命，海底电缆中继的小信号管子，设计寿命是100,000小时数量级的。

76发射机早期采用的FU-100F，后期采用的FU-728F，设计寿命也就是500和2000小时。

军用发射管『寿终正寝』的标准是输出功率和跨导降低为额定值的80%，并非彻底无放大能力、无输出。

不排除那个台（站）的发射机经过特殊技术改造：
1、发射的间歇，断掉屏压和帘栅压，管子黑灯丝（只加20%额定灯丝电压）热后备。
2、需要发射的时候，灯丝喂饱，高压加足，数秒内就能输出额定功率。

每天只发射几分钟，一只管子扛十几年理论上也不是没有可能。


俺这有一本瞄5型雷达的操作条令手册，有一条就是战斗值班的间隙可以打开热备开关，而不加高压。还特别提示，长此以往容易导致阴极中毒，不可长时间如此。

原因嘛，大概是因为氧化物（碳酸钡涂层加热分解排气制成）阴极经过“激活”后，内部残留少量金属钡原子，变为n型半导体。金属钡原子的存在，改变了半导体的能级分布，在禁带内生成“杂质能级”，这个能级很接近半导体的导带，所以载流子逸出功变小。氧化钡半导体的表面因为没有像裸金属阴极表面那样暴露在金属表面的正离子及由它形成的位垒，所以也使n型半导体的逸出功变小。氧化物阴极的放射能力取决于阴极表面钡的浓度。表面钡一方面不断蒸发，另一方面由内部的氧化钡分解和扩散得到不断补充，实现一个动态平衡。灯丝功率过小的时候，阴极表面得不到钡原子补充，但电子管阳极却大力“抽取”阴极的电子就会使阴极中毒，电子管就不好使了。不对之处还请指正!





# 八种在 Linux 上生成随机密码的方法 

利用像 `openssl`, [dd](https://kerneltalks.com/commands/learn-dd-command-with-examples/), `md5sum`, `tr`, `urandom` 这样的原生命令和 mkpasswd，randpw，pwgen，spw，gpg，xkcdpass，diceware，revelation，keepaasx，passwordmaker 这样的第三方工具。

其实这些方法就是生成一些能被用作密码的随机字母字符串。随机密码可以用于新用户的密码，不管用户基数有多大，这些密码都是独一无二的。话不多说，让我们来看看 8 种不同的在 Linux 上生成随机密码的方法吧。

### 使用 mkpasswd 实用程序生成密码

`mkpasswd` 在基于 RHEL 的系统上随 `expect` 软件包一起安装。在基于 Debian 的系统上 `mkpasswd` 则在软件包 `whois` 中。直接安装 `mkpasswd` 软件包将会导致错误：

- RHEL 系统：软件包 mkpasswd 不可用。
- Debian 系统：错误：无法定位软件包 mkpasswd。

所以按照上面所述安装他们的父软件包，就没问题了。

运行 `mkpasswd` 来获得密码

```
root@kerneltalks# mkpasswd << on RHELzt*hGW65croot@kerneltalks# mkpasswd teststring << on UbuntuXnlrKxYOJ3vik
```

这个命令在不同的系统上表现得不一样，所以工作方式各异。你也可以通过参数来控制长度等选项，可以查阅 man 手册来探索。

### 使用 openssl 生成密码

几乎所有 Linux 发行版都包含 openssl。我们可以利用它的随机功能来生成可以用作密码的随机字母字符串。

```
root@kerneltalks # openssl rand -base64 10nU9LlHO5nsuUvw==
```

这里我们使用 `base64` 编码随机函数，最后一个数字参数表示长度。

### 使用 urandom 生成密码

设备文件 `/dev/urandom` 是另一个获得随机字符串的方法。我们使用 `tr` 功能并裁剪输出来获得随机字符串，并把它作为密码。

```
root@kerneltalks # strings /dev/urandom |tr -dc A-Za-z0-9 | head -c20; echoUiXtr0NAOSIkqtjK4c0X
```

### 使用 dd 命令生成密码

我们甚至可以使用 `/dev/urandom` 设备配合 [dd 命令](https://kerneltalks.com/commands/learn-dd-command-with-examples/) 来获取随机字符串。

```
root@kerneltalks# dd if=/dev/urandom bs=1 count=15|base64 -w 015+0 records in15+0 records out15 bytes (15 B) copied, 5.5484e-05 s, 270 kB/sQMsbe2XbrqAc2NmXp8D0
```

我们需要将结果通过 `base64` 编码使它能被人类可读。你可以使用数值来获取想要的长度。想要获得更简洁的输出的话，可以将“标准错误输出”重定向到 `/dev/null`。简洁输出的命令是：

```
root@kerneltalks # dd if=/dev/urandom bs=1 count=15 2>/dev/null|base64 -w 0F8c3a4joS+a3BdPN9C++
```

### 使用 md5sum 生成密码

另一种获取可用作密码的随机字符串的方法是计算 MD5 校验值！校验值看起来确实像是随机字符串组合在一起，我们可以用作密码。确保你的计算源是个变量，这样的话每次运行命令时生成的校验值都不一样。比如 `date` ！[date 命令](https://kerneltalks.com/commands/date-time-management-using-timedatectl-command/) 总会生成不同的输出。

```
root@kerneltalks # date |md5sum4d8ce5c42073c7e9ca4aeffd3d157102  -
```

在这里我们将 `date` 命令的输出通过 `md5sum` 得到了校验和！你也可以用 [cut 命令](https://kerneltalks.com/linux/cut-command-examples/) 裁剪你需要的长度。

### 使用 pwgen 生成密码

`pwgen` 软件包在类似 [EPEL 软件仓库](https://kerneltalks.com/package/how-to-install-epel-repository/)（LCTT 译注：企业版 Linux 附加软件包）中。`pwgen` 更专注于生成可发音的密码，但它们不在英语词典中，也不是纯英文的。标准发行版仓库中可能并不包含这个工具。安装这个软件包然后运行 `pwgen` 命令行。Boom !

```
root@kerneltalks # pwgenthu8Iox7 ahDeeQu8 Eexoh0ai oD8oozie ooPaeD9t meeNeiW2 Eip6ieph Ooh1tietcootad7O Gohci0vo wah9Thoh Ohh3Ziur Ao1thoma ojoo6aeW Oochai4v ialaiLo5aic2OaDa iexieQu8 Aesoh4Ie Eixou9ph ShiKoh0i uThohth7 taaN3fuu Iege0aeZcah3zaiW Eephei0m AhTh8guo xah1Shoo uh8Iengo aifeev4E zoo4ohHa fieDei6caorieP7k ahna9AKe uveeX7Hi Ohji5pho AigheV7u Akee9fae aeWeiW4a tiex8Oht
```

你的终端会呈现出一个密码列表！你还想要什么呢？好吧。你还想再仔细探索的话， `pwgen` 还有很多自定义选项，这些都可以在 man 手册里查阅到。

### 使用 gpg 工具生成密码

GPG 是一个遵循 OpenPGP 标准的加密及签名工具。大部分 gpg 工具都预先被安装好了（至少在我的 RHEL7 上是这样）。但如果没有的话你可以寻找 `gpg` 或 `gpg2` 软件包并[安装](https://kerneltalks.com/tools/package-installation-linux-yum-apt/)它。

使用下面的命令以从 gpg 工具生成密码。

```
root@kerneltalks # gpg --gen-random --armor 1 12mL8i+PKZ3IuN6a7a
```

这里我们传了生成随机字节序列选项（`--gen-random`），质量为 1（第一个参数），次数 12 （第二个参数）。选项 `--armor` 保证以 `base64` 编码输出。

### 使用 xkcdpass 生成密码

著名的极客幽默网站 [xkcd](https://xkcd.com/)，发表了一篇非常有趣的文章，是关于好记但又复杂的密码的。你可以在[这里](https://xkcd.com/936/)阅读。所以 `xkcdpass` 工具就受这篇文章启发，做了这样的工作！这是一个 Python 软件包，可以在[这里](https://pypi.python.org/pypi/xkcdpass/)的 Python 的官网上找到它。

![img](https://dn-linuxcn.qbox.me/data/attachment/album/201802/06/235825mza9bbbbpypzj99h.png)

所有的安装使用说明都在上面那个页面提及了。这里是安装步骤和我的测试 RHEL 服务器的输出，以供参考。

```
root@kerneltalks # wget https://pypi.python.org/packages/b4/d7/3253bd2964390e034cf0bba227db96d94de361454530dc056d8c1c096abc/xkcdpass-1.14.3.tar.gz#md5=5f15d52f1d36207b07391f7a25c7965f--2018-01-23 19:09:17--  https://pypi.python.org/packages/b4/d7/3253bd2964390e034cf0bba227db96d94de361454530dc056d8c1c096abc/xkcdpass-1.14.3.tar.gzResolving pypi.python.org (pypi.python.org)... 151.101.32.223, 2a04:4e42:8::223Connecting to pypi.python.org (pypi.python.org)|151.101.32.223|:443... connected.HTTP request sent, awaiting response... 200 OKLength: 871848 (851K) [binary/octet-stream]Saving to: ‘xkcdpass-1.14.3.tar.gz’100%[==============================================================================================================================>] 871,848     --.-K/s   in 0.01s2018-01-23 19:09:17 (63.9 MB/s) - ‘xkcdpass-1.14.3.tar.gz’ saved [871848/871848]root@kerneltalks # tar -xvf xkcdpass-1.14.3.tar.gzxkcdpass-1.14.3/xkcdpass-1.14.3/examples/xkcdpass-1.14.3/examples/example_import.pyxkcdpass-1.14.3/examples/example_json.pyxkcdpass-1.14.3/examples/example_postprocess.pyxkcdpass-1.14.3/LICENSE.BSDxkcdpass-1.14.3/MANIFEST.inxkcdpass-1.14.3/PKG-INFOxkcdpass-1.14.3/README.rstxkcdpass-1.14.3/setup.cfgxkcdpass-1.14.3/setup.pyxkcdpass-1.14.3/tests/xkcdpass-1.14.3/tests/test_list.txtxkcdpass-1.14.3/tests/test_xkcdpass.pyxkcdpass-1.14.3/tests/__init__.pyxkcdpass-1.14.3/xkcdpass/xkcdpass-1.14.3/xkcdpass/static/xkcdpass-1.14.3/xkcdpass/static/eff-longxkcdpass-1.14.3/xkcdpass/static/eff-shortxkcdpass-1.14.3/xkcdpass/static/eff-specialxkcdpass-1.14.3/xkcdpass/static/fin-kotusxkcdpass-1.14.3/xkcdpass/static/ita-wikixkcdpass-1.14.3/xkcdpass/static/legacyxkcdpass-1.14.3/xkcdpass/static/spa-michxkcdpass-1.14.3/xkcdpass/xkcd_password.pyxkcdpass-1.14.3/xkcdpass/__init__.pyxkcdpass-1.14.3/xkcdpass.1xkcdpass-1.14.3/xkcdpass.egg-info/xkcdpass-1.14.3/xkcdpass.egg-info/dependency_links.txtxkcdpass-1.14.3/xkcdpass.egg-info/entry_points.txtxkcdpass-1.14.3/xkcdpass.egg-info/not-zip-safexkcdpass-1.14.3/xkcdpass.egg-info/PKG-INFOxkcdpass-1.14.3/xkcdpass.egg-info/SOURCES.txtxkcdpass-1.14.3/xkcdpass.egg-info/top_level.txtroot@kerneltalks # cd xkcdpass-1.14.3root@kerneltalks # python setup.py installrunning installrunning bdist_eggrunning egg_infowriting xkcdpass.egg-info/PKG-INFOwriting top-level names to xkcdpass.egg-info/top_level.txtwriting dependency_links to xkcdpass.egg-info/dependency_links.txtwriting entry points to xkcdpass.egg-info/entry_points.txtreading manifest file 'xkcdpass.egg-info/SOURCES.txt'reading manifest template 'MANIFEST.in'writing manifest file 'xkcdpass.egg-info/SOURCES.txt'installing library code to build/bdist.linux-x86_64/eggrunning install_librunning build_pycreating buildcreating build/libcreating build/lib/xkcdpasscopying xkcdpass/xkcd_password.py -> build/lib/xkcdpasscopying xkcdpass/__init__.py -> build/lib/xkcdpasscreating build/lib/xkcdpass/staticcopying xkcdpass/static/eff-long -> build/lib/xkcdpass/staticcopying xkcdpass/static/eff-short -> build/lib/xkcdpass/staticcopying xkcdpass/static/eff-special -> build/lib/xkcdpass/staticcopying xkcdpass/static/fin-kotus -> build/lib/xkcdpass/staticcopying xkcdpass/static/ita-wiki -> build/lib/xkcdpass/staticcopying xkcdpass/static/legacy -> build/lib/xkcdpass/staticcopying xkcdpass/static/spa-mich -> build/lib/xkcdpass/staticcreating build/bdist.linux-x86_64creating build/bdist.linux-x86_64/eggcreating build/bdist.linux-x86_64/egg/xkcdpasscopying build/lib/xkcdpass/xkcd_password.py -> build/bdist.linux-x86_64/egg/xkcdpasscopying build/lib/xkcdpass/__init__.py -> build/bdist.linux-x86_64/egg/xkcdpasscreating build/bdist.linux-x86_64/egg/xkcdpass/staticcopying build/lib/xkcdpass/static/eff-long -> build/bdist.linux-x86_64/egg/xkcdpass/staticcopying build/lib/xkcdpass/static/eff-short -> build/bdist.linux-x86_64/egg/xkcdpass/staticcopying build/lib/xkcdpass/static/eff-special -> build/bdist.linux-x86_64/egg/xkcdpass/staticcopying build/lib/xkcdpass/static/fin-kotus -> build/bdist.linux-x86_64/egg/xkcdpass/staticcopying build/lib/xkcdpass/static/ita-wiki -> build/bdist.linux-x86_64/egg/xkcdpass/staticcopying build/lib/xkcdpass/static/legacy -> build/bdist.linux-x86_64/egg/xkcdpass/staticcopying build/lib/xkcdpass/static/spa-mich -> build/bdist.linux-x86_64/egg/xkcdpass/staticbyte-compiling build/bdist.linux-x86_64/egg/xkcdpass/xkcd_password.py to xkcd_password.pycbyte-compiling build/bdist.linux-x86_64/egg/xkcdpass/__init__.py to __init__.pyccreating build/bdist.linux-x86_64/egg/EGG-INFOcopying xkcdpass.egg-info/PKG-INFO -> build/bdist.linux-x86_64/egg/EGG-INFOcopying xkcdpass.egg-info/SOURCES.txt -> build/bdist.linux-x86_64/egg/EGG-INFOcopying xkcdpass.egg-info/dependency_links.txt -> build/bdist.linux-x86_64/egg/EGG-INFOcopying xkcdpass.egg-info/entry_points.txt -> build/bdist.linux-x86_64/egg/EGG-INFOcopying xkcdpass.egg-info/not-zip-safe -> build/bdist.linux-x86_64/egg/EGG-INFOcopying xkcdpass.egg-info/top_level.txt -> build/bdist.linux-x86_64/egg/EGG-INFOcreating distcreating 'dist/xkcdpass-1.14.3-py2.7.egg' and adding 'build/bdist.linux-x86_64/egg' to itremoving 'build/bdist.linux-x86_64/egg' (and everything under it)Processing xkcdpass-1.14.3-py2.7.eggcreating /usr/lib/python2.7/site-packages/xkcdpass-1.14.3-py2.7.eggExtracting xkcdpass-1.14.3-py2.7.egg to /usr/lib/python2.7/site-packagesAdding xkcdpass 1.14.3 to easy-install.pth fileInstalling xkcdpass script to /usr/binInstalled /usr/lib/python2.7/site-packages/xkcdpass-1.14.3-py2.7.eggProcessing dependencies for xkcdpass==1.14.3Finished processing dependencies for xkcdpass==1.14.3
```

现在运行 `xkcdpass` 命令，将会随机给出你几个像下面这样的字典单词：

```
root@kerneltalks # xkcdpassbroadside unpadded osmosis statistic cosmetics lugged
```

你可以用这些单词作为其他命令，比如 `md5sum` 的输入，来获取随机密码（就像下面这样），甚至你也可以用每个单词的第 N 个字母来生成你的密码！

```
root@kerneltalks # xkcdpass |md5sum45f2ec9b3ca980c7afbd100268c74819  -root@kerneltalks # xkcdpass |md5sumad79546e8350744845c001d8836f2ff2  -
```

或者你甚至可以把所有单词串在一起作为一个超长的密码，不仅非常好记，也不容易被电脑程序攻破。

Linux 上还有像 [Diceware](http://world.std.com/%7Ereinhold/diceware.html)、 [KeePassX](https://www.keepassx.org/)、 [Revelation](https://packages.debian.org/sid/gnome/revelation)、 [PasswordMaker](https://passwordmaker.org/) 这样的工具