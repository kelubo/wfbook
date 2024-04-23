# chrony

[TOC]

## 概述

**chrony** 是 NTP 的一种实现。可以使用 chrony :

- 将系统时钟与 NTP 服务器同步。
- 将系统时钟与参考时钟同步，如 GPS 接收器。
- 将系统时钟与手动时间输入同步。
- 作为 NTPv4(RFC 5905) 服务器或对等服务器，为网络中的其他计算机提供时间服务。

chrony 包括 chronyd 和 chronyc 。

chronyd 是一个后台运行的守护进程，用于调整内核中运行的系统时钟和时钟服务器同步。它确定计算机增减时间的比率，并对此进行补偿。

chronyc 提供了一个用户界面，用于监控性能并进行多样化的配置。在默认情况下，`chronyd` 只接受来自本地 chronyc 实例的命令，但它也可以被配置为接受来自远程主机的监控命令。应该限制远程访问。



# 如何使用 chrony 为网络时间协议提供服务

`timesyncd` and `timedatectl` will generally do the right thing in keeping your time in sync.  However, if you also want to serve NTP information then you need an NTP  server.
 `timesyncd` 并且 `timedatectl` 通常会做正确的事情来保持您的时间同步。但是，如果您还想提供 NTP 信息，则需要一个 NTP 服务器。

Between `chrony`, the now-deprecated `ntpd`, and `open-ntp`, there are plenty of options. The solution we recommend is `chrony`.
在 `chrony` 、 现在不推荐使用的 `ntpd` 和 `open-ntp` 之间，有很多选择。我们推荐的解决方案是 `chrony` 。

The NTP daemon `chronyd` calculates the drift and offset of your system clock and continuously  adjusts it, so there are no large corrections that could lead to  inconsistent logs, for instance. The cost is a little processing power  and memory, but for a modern server this is usually negligible.
NTP 守护程序 `chronyd` 会计算系统时钟的漂移和偏移量，并不断对其进行调整，因此不会出现可能导致日志不一致的大型校正。成本是一点处理能力和内存，但对于现代服务器来说，这通常可以忽略不计。

## Install `chronyd` 安装 `chronyd` 

To install `chrony`, run the following command from a terminal prompt:
要安装 `chrony` ，请从终端提示符运行以下命令：

```bash
sudo apt install chrony
```

This will provide two binaries:
这将提供两个二进制文件：

- `chronyd` - the actual daemon to sync and serve via the Network Time Protocol
   `chronyd` - 通过网络时间协议同步和提供的实际守护进程
- `chronyc` - command-line interface for the `chrony` daemon
   `chronyc` - `chrony` 守护程序的命令行界面

## Configure `chronyd` 配置 `chronyd` 

Firstly, edit `/etc/chrony/chrony.conf` to add/remove server lines. By default these servers are configured:
首先，编辑 `/etc/chrony/chrony.conf` 以添加/删除服务器行。默认情况下，这些服务器配置如下：

```plaintext
# Use servers from the NTP Pool Project. Approved by Ubuntu Technical Board
# on 2011-02-08 (LP: #104525). See http://www.pool.ntp.org/join.html for
# more information.
pool 0.ubuntu.pool.ntp.org iburst
pool 1.ubuntu.pool.ntp.org iburst
pool 2.ubuntu.pool.ntp.org iburst
pool 3.ubuntu.pool.ntp.org iburst
```

See `man chrony.conf` for more details on the configuration options available. After changing any part of the config file you need to restart `chrony`, as follows:
有关可用配置选项的更多详细信息，请参阅 `man chrony.conf` 。更改配置文件的任何部分后，您需要重新启动 `chrony` ，如下所示：

```bash
sudo systemctl restart chrony.service
```

Of the pool, `2.ubuntu.pool.ntp.org` and `ntp.ubuntu.com` also support IPv6, if needed. If you need to force IPv6, there is also `ipv6.ntp.ubuntu.com` which is not configured by default.
如果需要， `2.ubuntu.pool.ntp.org` `ntp.ubuntu.com` 还支持 IPv6。如果需要强制IPv6，还有 `ipv6.ntp.ubuntu.com` 默认未配置的。

## Enable serving the Network Time Protocol 启用提供网络时间协议

You can install `chrony` (above) and configure special Hardware (below) for a local synchronisation
您可以安装 `chrony` （上图）和配置特殊硬件（下图）以实现本地同步
 and as-installed that is the default to stay on the secure and conservative side. But if you want to *serve* NTP you need adapt your configuration.
安装后，这是默认设置，以保持安全和保守的一面。但是，如果要为 NTP 提供服务，则需要调整配置。

To enable serving NTP you’ll need to at least set the `allow` rule. This controls which clients/networks you want `chrony` to serve NTP to.
若要启用提供 NTP，至少需要设置 `allow` 规则。这将控制要 `chrony` 向哪些客户端/网络提供 NTP。

An example would be:
例如：

```plaintext
allow 1.2.3.4
```

See the section “NTP server” in the [man page](http://manpages.ubuntu.com/manpages/jammy/man5/chrony.conf.5.html) for more details on how you can control and restrict access to your NTP server.
有关如何控制和限制对 NTP 服务器的访问的更多详细信息，请参见手册页中的“NTP 服务器”部分。

## View `chrony` status 查看 `chrony` 状态

You can use `chronyc` to see query the status of the `chrony` daemon. For example, to get an overview of the currently available and selected time sources, run `chronyc sources`, which provides output like this:
您可以使用 `chronyc` 查询 `chrony` 守护程序的状态。例如，若要获取当前可用和选定时间源的概述，请运行 `chronyc sources` ，它提供如下输出：

```plaintext
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
^+ gamma.rueckgr.at              2   8   377   135  -1048us[-1048us] +/-   29ms
^- 2b.ncomputers.org             2   8   377   204  -1141us[-1124us] +/-   50ms
^+ www.kashra.com                2   8   377   139  +3483us[+3483us] +/-   18ms
^+ stratum2-4.NTP.TechFak.U>     2   8   377   143  -2090us[-2073us] +/-   19ms
^- zepto.mcl.gg                  2   7   377     9   -774us[ -774us] +/-   29ms
^- mirrorhost.pw                 2   7   377    78   -660us[ -660us] +/-   53ms
^- atto.mcl.gg                   2   7   377     8   -823us[ -823us] +/-   50ms
^- static.140.107.46.78.cli>     2   8   377     9  -1503us[-1503us] +/-   45ms
^- 4.53.160.75                   2   8   377   137    -11ms[  -11ms] +/-  117ms
^- 37.44.185.42                  3   7   377    10  -3274us[-3274us] +/-   70ms
^- bagnikita.com                 2   7   377    74  +3131us[+3131us] +/-   71ms
^- europa.ellipse.net            2   8   377   204   -790us[ -773us] +/-   97ms
^- tethys.hot-chilli.net         2   8   377   141   -797us[ -797us] +/-   59ms
^- 66-232-97-8.static.hvvc.>     2   7   377   206  +1669us[+1686us] +/-  133ms
^+ 85.199.214.102                1   8   377   205   +175us[ +192us] +/-   12ms
^* 46-243-26-34.tangos.nl        1   8   377   141   -123us[ -106us] +/-   10ms
^- pugot.canonical.com           2   8   377    21    -95us[  -95us] +/-   57ms
^- alphyn.canonical.com          2   6   377    23  -1569us[-1569us] +/-   79ms
^- golem.canonical.com           2   7   377    92  -1018us[-1018us] +/-   31ms
^- chilipepper.canonical.com     2   8   377    21  -1106us[-1106us] +/-   27ms
```

You can also make use of the `chronyc sourcestats` command, which produces output like this:
您还可以使用该 `chronyc sourcestats` 命令，该命令将生成如下输出：

```plaintext
210 Number of sources = 20
Name/IP Address            NP  NR  Span  Frequency  Freq Skew  Offset  Std Dev
==============================================================================
gamma.rueckgr.at           25  15   32m     -0.007      0.142   -878us   106us
2b.ncomputers.org          26  16   35m     -0.132      0.283  -1169us   256us
www.kashra.com             25  15   32m     -0.092      0.259  +3426us   195us
stratum2-4.NTP.TechFak.U>  25  14   32m     -0.018      0.130  -2056us    96us
zepto.mcl.gg               13  11   21m     +0.148      0.196   -683us    66us
mirrorhost.pw               6   5   645     +0.117      0.445   -591us    19us
atto.mcl.gg                21  13   25m     -0.069      0.199   -904us   103us
static.140.107.46.78.cli>  25  18   34m     -0.005      0.094  -1526us    78us
4.53.160.75                25  10   32m     +0.412      0.110    -11ms    84us
37.44.185.42               24  12   30m     -0.983      0.173  -3718us   122us
bagnikita.com              17   7   31m     -0.132      0.217  +3527us   139us
europa.ellipse.net         26  15   35m     +0.038      0.553   -473us   424us
tethys.hot-chilli.net      25  11   32m     -0.094      0.110   -864us    88us
66-232-97-8.static.hvvc.>  20  11   35m     -0.116      0.165  +1561us   109us
85.199.214.102             26  11   35m     -0.054      0.390   +129us   343us
46-243-26-34.tangos.nl     25  16   32m     +0.129      0.297   -307us   198us
pugot.canonical.com        25  14   34m     -0.271      0.176   -143us   135us
alphyn.canonical.com       17  11  1100     -0.087      0.360  -1749us   114us
golem.canonical.com        23  12   30m     +0.057      0.370   -988us   229us
chilipepper.canonical.com  25  18   34m     -0.084      0.224  -1116us   169us
```

Certain `chronyc` commands are privileged and cannot be run via the network without explicitly allowing them. See the **Command and monitoring access** section in `man chrony.conf` for more details. A local admin can use `sudo` since this will grant access to the local admin socket `/var/run/chrony/chronyd.sock`.
某些 `chronyc` 命令是特权命令，如果不明确允许它们，则无法通过网络运行。有关详细信息，请参阅“ `man chrony.conf` 命令和监视访问”部分。本地管理员可以使用 `sudo` ，因为这将授予对本地管理套接字的访问权限 `/var/run/chrony/chronyd.sock` 。

## Pulse-Per-Second (PPS) support 每秒脉冲 （PPS） 支持

`Chrony` supports various PPS types natively. It can use kernel PPS API as well  as Precision Time Protocol (PTP) hardware clocks. Most general GPS  receivers can be leveraged via GPSD. The latter (and potentially more)  can be accessed via **SHM** or via a **socket** (recommended). All of the above can be used to augment `chrony` with additional high quality time sources for better accuracy, jitter,  drift, and longer- or shorter-term accuracy. Usually, each kind of clock type is good at one of those, but non-perfect at the others. For more  details on configuration see some of the external PPS/GPSD resources  listed below.
 `Chrony` 原生支持各种 PPS 类型。它可以使用内核 PPS API 以及精确时间协议 （PTP） 硬件时钟。大多数通用 GPS 接收器都可以通过 GPSD 使用。后者（可能还有更多）可以通过 SHM 或套接字（推荐）访问。以上所有功能都可用于 `chrony` 增强额外的高质量时间源，以获得更好的精度、抖动、漂移以及长期或短期精度。通常，每种时钟类型都擅长其中一种，但在其他方面并不完美。有关配置的更多详细信息，请参阅下面列出的一些外部 PPS/GPSD 资源。

> **Note**: 注意：
>  As of the release of 20.04, there was a bug which - until fixed - you might want to [add this content]`(https://bugs.launchpad.net/ubuntu/+source/gpsd/+bug/1872175/comments/21)  to your `/etc/apparmor.d/local/usr.sbin.gpsd`.
> 从 20.04 版本开始，存在一个错误，在修复之前，您可能需要 [添加此内容] `(https://bugs.launchpad.net/ubuntu/+source/gpsd/+bug/1872175/comments/21)  to your ` /etc/apparmor.d/local/usr.sbin.gpsd'。

### Example configuration for GPSD to feed `chrony` GPSD 馈电 `chrony` 的示例配置

For the installation and setup you will first need to run the following command in your terminal window:
对于安装和设置，您首先需要在终端窗口中运行以下命令：

```bash
sudo apt install gpsd chrony
```

However, since you will want to test/debug your setup (especially the GPS reception), you should also install:
但是，由于您需要测试/调试您的设置（尤其是 GPS 接收），因此您还应该安装：

```auto
sudo apt install pps-tools gpsd-clients
```

GPS devices usually communicate via serial interfaces. The most common type these days are USB GPS devices, which have a serial converter behind  USB. If you want to use one of these devices for PPS then please be  aware that the majority do not signal PPS via USB. Check the [GPSD hardware](https://gpsd.gitlab.io/gpsd/hardware.html) list for details. The examples below were run with a Navisys GR701-W.
GPS设备通常通过串行接口进行通信。如今最常见的类型是 USB GPS 设备，它在 USB 后面有一个串行转换器。如果您想将这些设备之一用于 PPS，请注意，大多数设备不会通过 USB 向 PPS  发出信号。有关详细信息，请查看 GPSD 硬件列表。以下示例使用 Navisys GR701-W 运行。

When plugging in such a device (or at boot time) `dmesg` should report a serial connection of some sort, as in this example:
插入此类设备时（或在启动时） `dmesg` 应报告某种串行连接，如以下示例所示：

```plaintext
[   52.442199] usb 1-1.1: new full-speed USB device number 3 using xhci_hcd
[   52.546639] usb 1-1.1: New USB device found, idVendor=067b, idProduct=2303, bcdDevice= 4.00
[   52.546654] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   52.546665] usb 1-1.1: Product: USB-Serial Controller D
[   52.546675] usb 1-1.1: Manufacturer: Prolific Technology Inc. 
[   52.602103] usbcore: registered new interface driver usbserial_generic
[   52.602244] usbserial: USB Serial support registered for generic
[   52.609471] usbcore: registered new interface driver pl2303
[   52.609503] usbserial: USB Serial support registered for pl2303
[   52.609564] pl2303 1-1.1:1.0: pl2303 converter detected
[   52.618366] usb 1-1.1: pl2303 converter now attached to ttyUSB0
```

We see in this example that the device appeared as `ttyUSB0`. So that `chrony` later accepts being fed time information by this device, we have to set it up in `/etc/chrony/chrony.conf` (please replace `USB0` with whatever applies to your setup):
在此示例中，我们看到设备显示为 `ttyUSB0` .以便 `chrony` 以后接受此设备提供的时间信息，我们必须将其设置在 `/etc/chrony/chrony.conf` （请 `USB0` 替换为适用于您的设置的任何内容）：

```auto
refclock SHM 0 refid GPS precision 1e-1 offset 0.9999 delay 0.2
refclock SOCK /var/run/chrony.ttyUSB0.sock refid PPS
```

Next, we need to restart `chrony` to make the socket available and have it waiting.
接下来，我们需要重新启动 `chrony` 以使套接字可用并等待它。

```auto
sudo systemctl restart chrony
```

We then need to tell `gpsd` which device to manage. Therefore, in `/etc/default/gpsd` we set:
然后，我们需要告诉 `gpsd` 要管理哪个设备。因此，在我们 `/etc/default/gpsd` 设置：

```auto
DEVICES="/dev/ttyUSB0"
```

It should be noted that since the *default* use-case of `gpsd` is, well, for *gps position tracking*, it will normally not consume any CPU since it is just waiting on a **socket** for clients. Furthermore, the client will tell `gpsd` what it requests, and `gpsd` will only provide what is asked for.
应该注意的是，由于默认用例 `gpsd` 是 对于 gps 位置跟踪，它通常不会消耗任何 CPU，因为它只是在客户端的套接字上等待。此外，客户会说出 `gpsd` 它的要求，并且 `gpsd` 只会提供所要求的。

For the use case of `gpsd` as a PPS-providing-daemon, you want to set the option to:
对于作为 PPS 提供守护程序的 `gpsd` 用例，您需要将选项设置为：

- Immediately start (even without a client connected). This can be set in `GPSD_OPTIONS` of `/etc/default/gpsd`:
  立即启动（即使没有连接客户端）。这可以设置在以下位置 `/etc/default/gpsd` ： `GPSD_OPTIONS` 
  - `GPSD_OPTIONS="-n"`
- Enable the service itself and not wait for a client to reach the socket in the future:
  启用服务本身，而不是等待客户端将来到达套接字：
  - `sudo systemctl enable /lib/systemd/system/gpsd.service`

Restarting `gpsd` will now initialize the PPS from GPS and in `dmesg` you will see:
重新启动现在 `gpsd` 将从 GPS 初始化 PPS，您将看到 `dmesg` ：

```plaintext
 pps_ldisc: PPS line discipline registered
 pps pps0: new PPS source usbserial0
 pps pps0: source "/dev/ttyUSB0" added
```

If you have multiple PPS sources, the tool `ppsfind` may be useful to help identify which PPS belongs to which GPS. In our example, the command `sudo ppsfind /dev/ttyUSB0` would return the following:
如果您有多个 PPS 源，该工具 `ppsfind` 可能有助于识别哪个 PPS 属于哪个 GPS。在我们的示例中，该命令 `sudo ppsfind /dev/ttyUSB0` 将返回以下内容：

```plaintext
pps0: name=usbserial0 path=/dev/ttyUSB0
```

Now we have completed the basic setup. To proceed, we now need our GPS to get a lock. Tools like `cgps` or `gpsmon` need to report a 3D “fix” in order to provide accurate data. Let’s run the command `cgps`, which in our case returns:
现在我们已经完成了基本设置。要继续，我们现在需要我们的 GPS 来获得锁。工具喜欢 `cgps` 或 `gpsmon` 需要报告 3D“修复”以提供准确的数据。让我们运行命令，在我们的例子中，该命令 `cgps` 返回：

```plaintext
...
│ Status:         3D FIX (7 secs) ...
```

You would then want to use `ppstest` in order to check that you are really receiving PPS data. So, let us run the command `sudo ppstest /dev/pps0`, which will produce an output like this:
然后，您需要使用 `ppstest` 以检查您是否真的在接收 PPS 数据。因此，让我们运行命令 `sudo ppstest /dev/pps0` ，它将生成如下输出：

```plaintext
trying PPS source "/dev/pps0"
found PPS source "/dev/pps0"
ok, found 1 source(s), now start fetching data...
source 0 - assert 1588140739.099526246, sequence: 69 - clear  1588140739.999663721, sequence: 70
source 0 - assert 1588140740.099661485, sequence: 70 - clear  1588140739.999663721, sequence: 70
source 0 - assert 1588140740.099661485, sequence: 70 - clear  1588140740.999786664, sequence: 71
source 0 - assert 1588140741.099792447, sequence: 71 - clear  1588140740.999786664, sequence: 71
```

Ok, `gpsd` is now running, the GPS reception has found a fix, and it has fed this into `chrony`. Let’s check on that from the point of view of `chrony`.
好的， `gpsd` 现在正在运行，GPS 接收已找到修复程序，并且已将其输入 `chrony` .让我们从 的角度 `chrony` 来检查一下。

Initially, before `gpsd` has started or before it has a lock, these sources will be new and  “untrusted” - they will be marked with a “?” as shown in the example  below. If your devices remain in the “?” state (even after some time)  then `gpsd` is not feeding any data to `chrony` and you will need to debug why.
最初，在启动之前 `gpsd` 或锁定之前，这些源将是新的和“不受信任的” - 它们将标记为“？”，如下面的示例所示。如果您的设备仍处于“？”状态（即使在一段时间后），则 `gpsd` 不会向其 `chrony` 提供任何数据，您将需要调试原因。

```plaintext
chronyc> sources
210 Number of sources = 10
MS Name/IP address         Stratum Poll Reach LastRx Last sample               
===============================================================================
#? GPS                           0   4     0     -     +0ns[   +0ns] +/-    0ns
#? PPS                           0   4     0     -     +0ns[   +0ns] +/-    0ns
```

Over time, `chrony` will classify all of the unknown sources as “good” or “bad”.
随着时间的流逝， `chrony` 将所有未知来源分类为“好”或“坏”。
 In the example below, the raw GPS had too much deviation (± 200ms) but the PPS is good (± 63us).
在下面的示例中，原始 GPS 的偏差太大（± 200 毫秒），但 PPS 良好（± 63us）。

```plaintext
chronyc> sources
210 Number of sources = 10
MS Name/IP address        Stratum Poll Reach LastRx Last sample
===============================================================================
#x GPS                         0    4   177    24 -876ms[ -876ms] +/- 200ms
#- PPS                         0    4   177    21 +916us[ +916us] +/- 63us
^- chilipepper.canonical.com   2    6    37    53  +33us[ +33us]  +/- 33ms
```

Finally, after a while it used the hardware PPS input (as it was better):
最后，过了一会儿，它使用了硬件 PPS 输入（因为它更好）：

```plaintext
chronyc> sources
210 Number of sources = 10
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
#x GPS                           0   4   377    20   -884ms[ -884ms] +/-  200ms
#* PPS                           0   4   377    18  +6677ns[  +52us] +/-   58us
^- alphyn.canonical.com          2   6   377    20  -1303us[-1258us] +/-  114ms
```

The PPS might also be OK – but used in a combined way with the selected server, for example. See `man chronyc` for more details about how these combinations can look:
PPS 也可能没问题，但可以与所选服务器结合使用。有关这些组合的外观的更多详细信息，请参阅 `man chronyc` ：

```plaintext
chronyc> sources
210 Number of sources = 11
MS Name/IP address         Stratum Poll Reach LastRx Last sample               
===============================================================================
#? GPS                           0   4     0     -     +0ns[   +0ns] +/-    0ns
#+ PPS                           0   4   377    22   +154us[ +154us] +/- 8561us
^* chilipepper.canonical.com     2   6   377    50   -353us[ -300us] +/-   44ms
```

If you’re wondering if your SHM-based GPS data is any good, you can check on that as well. `chrony` will not only tell you if the data is classified as good or bad – using `sourcestats` you can also check the details:
如果您想知道基于 SHM 的 GPS 数据是否有用，您也可以检查一下。 `chrony` 不仅会告诉您数据是好是坏 - 您还可以检查 `sourcestats` 详细信息：

```plaintext
chronyc> sourcestats
210 Number of sources = 10
Name/IP Address            NP  NR  Span  Frequency  Freq Skew  Offset  Std Dev
==============================================================================
GPS                        20   9   302     +1.993     11.501   -868ms  1208us
PPS                         6   3    78     +0.324      5.009  +3365ns    41us
golem.canonical.com        15  10   783     +0.859      0.509   -750us   108us
```

You can also track the raw data that `gpsd` or other `ntpd`-compliant reference clocks are sending via shared memory by using `ntpshmmon`. Let us run the command `sudo ntpshmmon -o`, which should provide the following output:
您还可以使用 `ntpshmmon` 跟踪其他符合参考时钟的参考时钟通过共享内存发送的原始数据。 `gpsd` `ntpd` 让我们运行命令，该命令 `sudo ntpshmmon -o` 应提供以下输出：

```plaintext
ntpshmmon: version 3.20
#      Name          Offset       Clock                 Real                 L Prc
sample NTP1          0.000223854  1588265805.000223854  1588265805.000000000 0 -10
sample NTP0          0.125691783  1588265805.125999851  1588265805.000308068 0 -20
sample NTP1          0.000349341  1588265806.000349341  1588265806.000000000 0 -10
sample NTP0          0.130326636  1588265806.130634945  1588265806.000308309 0 -20
sample NTP1          0.000485216  1588265807.000485216  1588265807.000000000 0 -10
```

## NTS Support NTS 支持

In Chrony 4.0 (which first appeared in Ubuntu 21.04 Hirsute) support for [Network Time Security “NTS”](https://www.networktimesecurity.org/) was added.
在 Chrony 4.0（首次出现在 Ubuntu 21.04 Hirsute 中）中，添加了对网络时间安全“NTS”的支持。

### NTS server NTS 服务器

To set up your server with NTS you’ll need certificates so that the server can authenticate itself and, based on that, allow the encryption and  verification of NTP traffic.
要使用 NTS 设置服务器，您需要证书，以便服务器可以自行进行身份验证，并在此基础上允许对 NTP 流量进行加密和验证。

In addition to the `allow` statement that any `chrony` (while working as an NTP server) needs there are two mandatory config  entries that will be needed. Example certificates for those entries  would look like:
除了任何 `chrony` （在作为 NTP 服务器工作时）需要 `allow` 的声明之外，还需要两个必需的配置条目。这些条目的示例证书如下所示：

```plaintext
ntsservercert /etc/chrony/fullchain.pem
ntsserverkey /etc/chrony/privkey.pem
```

It is important to note that for isolation reasons `chrony`, by default, runs as user and group `_chrony`. Therefore you need to grant access to the certificates for that user, by running the following command:.
需要注意的是，出于隔离原因 `chrony` ，默认情况下，以 user 和 group `_chrony` 的身份运行。因此，您需要通过运行以下命令来授予该用户对证书的访问权限：

```bash
sudo chown _chrony:_chrony /etc/chrony/*.pem
```

Then restart `chrony` with `systemctl restart chrony` and it will be ready to provide NTS-based time services.
然后重新启动 `chrony`  `systemctl restart chrony` ，它将准备好提供基于 NTS 的时间服务。

A running `chrony` server measures various statistics. One of them counts the number of  NTS connections that were established (or dropped) – we can check this  by running `sudo chronyc -N serverstats`, which shows us the statistics:
正在运行 `chrony` 的服务器测量各种统计信息。其中一个计算已建立（或丢弃）的 NTS 连接数 – 我们可以通过运行 `sudo chronyc -N serverstats` 来检查这一点，它向我们显示统计信息：

```plaintext
NTP packets received       : 213
NTP packets dropped        : 0
Command packets received   : 117
Command packets dropped    : 0
Client log records dropped : 0
NTS-KE connections accepted: 2
NTS-KE connections dropped : 0
Authenticated NTP packets  : 197
```

There is also a per-client statistic which can be enabled by the `-p` option of the `clients` command.
还有一个每个客户端的统计信息，可以通过 `clients` 命令 `-p` 的选项来启用。

```bash
sudo chronyc -N clients -k
```

This provides output in the following form:
这将按以下形式提供输出：

```plaintext
    Hostname                      NTP   Drop Int IntL Last  NTS-KE   Drop Int  Last
    ===============================================================================
    10.172.196.173                197      0  10   -   595       2      0   5   48h
    ...
```

For more complex scenarios there are many more advanced options for configuring NTS. These are documented in [the `chrony` man page](https://manpages.ubuntu.com/manpages/en/man5/chrony.conf.5.html).
对于更复杂的方案，有许多用于配置 NTS 的更高级选项。 `chrony` 手册页中记录了这些内容。

> **Note**: *About certificate placement*
> 注意：关于证书放置
>  Chrony, by default, is isolated via AppArmor and uses a number of `protect*` features of `systemd`. Due to that, there are not many paths `chrony` can access for the certificates. But `/etc/chrony/*` is allowed as read-only and that is enough.
> 默认情况下，Chrony 通过 AppArmor 进行隔离，并使用 的 `systemd` 多种 `protect*` 功能。因此，证书 `chrony` 可以访问的路径并不多。但 `/etc/chrony/*` 允许只读，这就足够了。
>  Check `/etc/apparmor.d/usr.sbin.chronyd` if you want other paths or allow custom paths in `/etc/apparmor.d/local/usr.sbin.chronyd`.
> 检查 `/etc/apparmor.d/usr.sbin.chronyd` 是否需要其他路径或允许自定义 `/etc/apparmor.d/local/usr.sbin.chronyd` 路径。

### NTS client NTS 客户端

The client needs to specify `server` as usual (`pool` directives do not work with NTS). Afterwards, the server address options can be listed and it is there that `nts` can be added. For example:
客户端需要像往常一样指定 `server` （ `pool` 指令不适用于 NTS）。之后，可以列出服务器地址选项，并且 `nts` 可以添加服务器地址。例如：

```plaintext
server <server-fqdn-or-IP> iburst nts
```

One can check the `authdata` of the connections established by the client using `sudo chronyc -N authdata`, which will provide the following information:
可以使用 检查客户端建立 `authdata` 的连接 `sudo chronyc -N authdata` ，这将提供以下信息：

```plaintext
Name/IP address             Mode KeyID Type KLen Last Atmp  NAK Cook CLen
=========================================================================
<server-fqdn-or-ip>          NTS     1   15  256  48h    0    0    8  100
```

Again, there are more advanced options documented in [the man page](https://manpages.ubuntu.com/manpages/en/man5/chrony.conf.5.html). Common use cases are specifying an explicit trusted certificate.
同样，手册页中还记录了更高级的选项。常见用例是指定显式受信任证书。

> **Bad Clocks and secure time syncing - “A Chicken and Egg” problem
> 坏时钟和安全时间同步 - “先有鸡还是先有蛋”的问题**
>  There is one problem with systems that have very bad clocks. NTS is  based on TLS, and TLS needs a reasonably correct clock. Due to that, an  NTS-based sync might fail. On hardware affected by this problem, one can consider using the `nocerttimecheck` option which allows the user to set the number of times that the time can be synced without checking validation and expiration.
> 时钟非常糟糕的系统存在一个问题。NTS 基于 TLS，而 TLS 需要一个相当正确的时钟。因此，基于 NTS 的同步可能会失败。在受此问题影响的硬件上，可以考虑使用该 `nocerttimecheck` 选项，该选项允许用户设置可以同步时间的次数，而无需检查验证和过期。

## References 引用

- [Chrony FAQ Chrony 常见问题](https://chrony.tuxfamily.org/faq.html)
- [ntp.org: home of the Network Time Protocol project
  ntp.org：网络时间协议项目的所在地](http://www.ntp.org/)
- [pool.ntp.org: project of virtual cluster of timeservers
  pool.ntp.org：时间服务器虚拟集群项目](http://www.pool.ntp.org/)
- [Freedesktop.org info on timedatectl
  Freedesktop.org timedatectl的信息](https://www.freedesktop.org/software/systemd/man/timedatectl.html)
- [Freedesktop.org info on systemd-timesyncd service
  Freedesktop.org 有关 systemd-timesyncd 服务的信息](https://www.freedesktop.org/software/systemd/man/systemd-timesyncd.service.html#)
- [Feeding chrony from GPSD
  从 GPSD 喂食 chrony](https://gpsd.gitlab.io/gpsd/gpsd-time-service-howto.html#_feeding_chrony_from_gpsd)
- See the [Ubuntu Time](https://help.ubuntu.com/community/UbuntuTime) wiki page for more information.
  有关详细信息，请参阅 Ubuntu Time wiki 页面。



## 安装

1.安装 Chrony

系统默认已经安装，如未安装，请执行以下命令安装：

```bash
yum install chrony -y
dnf install chrony
```

chrony 守护进程的默认位置为 `/usr/sbin/chronyd`。chronyc 命令行工具将安装到 `/usr/bin/chronyc` 。 				

2.启动并加入开机自启动

```bash
systemctl enable  chronyd.service
systemctl restart chronyd.service
```

3.Firewalld设置

```bash
firewall-cmd --add-service=ntp --permanent
firewall-cmd --reload
```

## 配置

配置文件：/etc/chrony.conf

```bash
cat /etc/chrony.conf

# These servers were defined in the installation:
server 0.centos.pool.ntp.org iburst
server 1.centos.pool.ntp.org iburst
server 2.centos.pool.ntp.org iburst
server 3.centos.pool.ntp.org iburst
# Use public servers from the pool.ntp.org project.
# Please consider joining the pool (http://www.pool.ntp.org/join.html).
# 使用 pool.ntp.org 项目中的公共服务器。以 server 开头，理论上想添加多少时间服务器都可以。

# Record the rate at which the system clock gains/losses time.
# 根据实际时间计算出服务器增减时间的比率，然后记录到一个文件中，在系统重启后为系统做出最佳时间补偿调整。
driftfile /var/lib/chrony/drift

# chronyd根据需求减慢或加速时间调整，使得系统逐步纠正所有时间偏差。
# 在某些情况下系统时钟可能漂移过快，导致时间调整用时过长。
# 该指令强制chronyd调整时期，大于某个阀值时步进调整系统时钟。
# 只有在因chronyd启动时间超过指定的限制时（可使用负值来禁用限制）没有更多时钟更新时才生效。
# Allow the system clock to be stepped in the first three updates
# if its offset is larger than 1 second.
makestep 1.0 3

# Enable kernel synchronization of the real-time clock (RTC).
# 将启用一个内核模式，在该模式中，系统时间每11分钟会拷贝到实时时钟（RTC）。
rtcsync

# Enable hardware timestamping on all interfaces that support it.
# 通过使用 hwtimestamp 指令启用硬件时间戳
#hwtimestamp *

# Increase the minimum number of selectable sources required to adjust
# the system clock.
#minsources 2

# Allow NTP client access from local network.
# 指定一台主机、子网，或者网络以允许或拒绝 NTP 连接到扮演时钟服务器的机器
#allow 192.168.0.0/16

# Serve time even if not synchronized to a time source.
#local stratum 10

# Specify file containing keys for NTP authentication.
# 指定包含 NTP 验证密钥的文件。
keyfile /etc/chrony.keys

# Get TAI-UTC offset and leap seconds from the system tz database.
leapsectz right/UTC

# Specify directory for log files.
# 指定日志文件的目录。
logdir /var/log/chrony

# Select which information is logged.
#log measurements statistics tracking
```



**stratumweight** - 该指令设置当chronyd从可用源中选择同步源时，每个层应该添加多少距离到同步距离。默认情况下，CentOS中设置为0，让chronyd在选择源时忽略源的层级。

**cmdallow / cmddeny** - 跟上面相类似，可以指定哪个IP地址或哪台主机可以通过chronyd使用控制命令。

**bindcmdaddress** - 该指令允许限制chronyd监听哪个网络接口的命令包（由chronyc执行）。该指令通过cmddeny机制提供了一个除上述限制以外可用的额外的访问控制等级。

```shell
bindcmdaddress 127.0.0.1
bindcmdaddress ::1
```

## 管理 chrony

检查 `chronyd` 的状态：

```bash
systemctl status chronyd

chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled)
   Active: active (running) since Wed 2013-06-12 22:23:16 CEST; 11h ago
```

启动 `chronyd`：

```none
systemctl start chronyd
```

要确保 `chronyd` 在系统启动时自动启动：

```bash
systemctl enable chronyd
```

停止 `chronyd`：

```bash
systemctl stop chronyd
```

关闭 `chronyd` 在系统启动时自动启动：

```bash
systemctl disable chronyd
```



## 使用 chronyc

```bash
# 强制同步系统时钟
chronyc -a makestep

# 查看时间同步源
chronyc sources -v

# 查看时间同步源状态
chronyc sourcestats -v

# 校准时间服务器
chronyc tracking
```

**accheck** - 检查NTP访问是否对特定主机可用

**activity** - 该命令会显示有多少NTP源在线/离线

**add server** - 手动添加一台新的NTP服务器。

**clients** - 在客户端报告已访问到服务器

**delete** - 手动移除NTP服务器或对等服务器

**settime** - 手动设置守护进程时间

**tracking** - 显示系统时间信息

### 交互模式

要在互动模式中使用命令行工具 chronyc 来更改本地 `chronyd` 实例，以 root 用户身份输入以下命令：

```bash
chronyc
```

chronyc 命令提示符如下所示：

```bash
chronyc>
```

要列出所有的命令，请输入 `help`。

> 注意
>
> 使用 **chronyc** 所做的更改不具有持久性，它们会在 `chronyd` 重启后丢失。要使更改有持久性，修改 `/etc/chrony.conf`。 			

 	

## 检查是否同步 chrony

运行以下命令检查 **chrony** 跟踪：

```bash
chronyc tracking

Reference ID    : CB00710F (foo.example.net)
Stratum         : 3
Ref time (UTC)  : Fri Jan 27 09:49:17 2017
System time     :  0.000006523 seconds slow of NTP time
Last offset     : -0.000006747 seconds
RMS offset      : 0.000035822 seconds
Frequency       : 3.225 ppm slow
Residual freq   : 0.000 ppm
Skew            : 0.129 ppm
Root delay      : 0.013639022 seconds
Root dispersion : 0.001100737 seconds
Update interval : 64.2 seconds
Leap status     : Normal
```

sources 命令显示 `chronyd` 正在访问的当前时间源的信息。

```bash
chronyc sources

210 Number of sources = 3
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
#* GPS0                          0   4   377    11   -479ns[ -621ns] /-  134ns
^? a.b.c                         2   6   377    23   -923us[ -924us] +/-   43ms
^ d.e.f                         1   6   377    21  -2629us[-2619us] +/-   86ms
```

可以使用可选参数 -v 来包括详细信息。在这种情况下，会输出额外的标头行显示字段含义的信息。 				

`sourcestats` 命令显示目前被 `chronyd` 检查的每个源的偏移率和误差估算过程的信息。

```bash
chronyc sourcestats

210 Number of sources = 1
Name/IP Address            NP  NR  Span  Frequency  Freq Skew  Offset  Std Dev
===============================================================================
abc.def.ghi                11   5   46m     -0.001      0.045      1us    25us
```

可以使用可选参数 `-v` 来包括详细信息。在这种情况下，会输出额外的标头行显示字段含义的信息。

## 29.3. 手动调整系统时钟

​				下面的流程描述了如何手动调整系统时钟。 		

**流程**

1. ​						要立即调整系统时钟，绕过单机进行的任何调整，以 `root` 身份运行以下命令： 				

   

   ```none
   # chronyc makestep
   ```

​				如果使用了 `rtcfile` 指令，则不应该手动调整实时时钟。随机调整会影响 **chrony** 测量实时时钟漂移速率的需要。 		

## 29.4. 禁用 chrony 分配程序脚本

​				`chrony` 分配程序脚本管理 NTP 服务器的在线和离线状态。作为系统管理员，您可以禁用分配程序脚本，使 `chronyd` 持续轮询服务器。 		

​				如果在系统中启用 NetworkManager 来管理网络配置，NetworkManager 会在接口重新配置过程中执行 `chrony` 分配程序脚本，停止或启动操作。但是，如果您在 NetworkManager 之外配置某些接口或路由，您可能会遇到以下情况： 		

1. ​						当没有路由到 NTP 服务器的路由时，分配程序脚本可能会运行，从而导致 NTP 服务器切换到离线状态。 				
2. ​						如果您稍后建立路由，脚本默认不会再次运行，NTP 服务器将保持离线状态。 				

​				要确保 `chronyd` 可以与您的 NTP 服务器同步（有单独的受管接口），请禁用分配程序脚本。 		

**先决条件**

- ​						您在系统中安装了 NetworkManager 并启用它。 				
- ​						根访问权限 				

**流程**

1. ​						要禁用 `chrony` 分配程序脚本，请创建一个到 `/dev/null` 的符号链接： 				

   

   ```none
   # ln -s /dev/null /etc/NetworkManager/dispatcher.d/20-chrony-onoffline
   ```

   注意

   ​							在此更改后，NetworkManager 无法执行分配程序脚本，NTP 服务器始终保持在线状态。 					

## 29.5. 在隔离的网络中为系统设定 chrony

​				 对于从未连接到互联网的网络，一台计算机被选为主计时服务器。其他计算机是服务器的直接客户端，也可以是客户端的客户端。在服务器上，必须使用系统时钟的平均偏移率手动设置 drift 文件。如果服务器被重启，它将从周围的系统获得时间，并计算设置系统时钟的平均值。之后它会恢复基于 drift 文件的调整。当使用  settime 命令时会自动更新 `drift` 文件。 		

​				以下流程描述了如何为隔离的网络中的系统设置 **chrony**。 		

**流程**

1. ​						在选择为服务器的系统中，以 `root` 用户身份运行一个文本编辑器，编辑 `/etc/chrony.conf`，如下所示： 				

   

   ```none
   driftfile /var/lib/chrony/drift
   commandkey 1
   keyfile /etc/chrony.keys
   initstepslew 10 client1 client3 client6
   local stratum 8
   manual
   allow 192.0.2.0
   ```

   ​						其中 `192.0.2.0` 是允许客户端连接的网络或者子网地址。 				

2. ​						在选择成为服务器客户端的系统上，以 `root` 用户身份运行一个文本编辑器来编辑 `/etc/chrony.conf`，如下所示： 				

   

   ```none
   server ntp1.example.net
   driftfile /var/lib/chrony/drift
   logdir /var/log/chrony
   log measurements statistics tracking
   keyfile /etc/chrony.keys
   commandkey 24
   local stratum 10
   initstepslew 20 ntp1.example.net
   allow 192.0.2.123
   ```

   ​						其中 `192.0.2.123` 是服务器的地址，`ntp1.example.net` 是服务器的主机名。带有此配置的客户端如果服务器重启，则与服务器重新同步。 				

​				在不是服务器直接客户端的客户端系统中，`/etc/chrony.conf` 文件应该相同，除了应该省略 `local` 和 `allow` 指令。 		

​				在隔离的网络中，您还可以使用 `local` 指令来启用本地参考模式。该模式可允许 `chronyd` 作为 `NTP` 服务器实时显示同步，即使它从未同步或者最后一次更新时钟早前发生。 		

​				要允许网络中的多个服务器使用相同的本地配置并相互同步，而不让客户端轮询多个服务器，请使用 `local` 指令的 `orphan` 选项启用孤立模式。每一个服务器都需要配置为使用 `local` 轮询所有其他服务器。这样可确保只有最小参考 ID 的服务器具有本地参考活跃状态，其他服务器与之同步。当服务器出现故障时，另一台服务器将接管。 		

## 29.6. 配置远程监控访问

​				**chronyc** 可以通过两种方式访问 `chronyd`: 		

- ​						互联网协议、IPv4 或者 IPv6。 				
- ​						UNIX 域套接字，由 `root` 用户或 `chrony` 用户从本地进行访问。 				

​				默认情况下，**chronyc** 连接到 Unix 域套接字。默认路径为 `/var/run/chrony/chronyd.sock`。如果这个连接失败，比如，当 **chronyc** 在非 root 用户下运行时会发生，**chronyc** 会尝试连接到 127.0.0.1，然后 ::1。 		

​				网络中只允许以下监控命令，它们不会影响 `chronyd` 的行为： 		

- ​						activity 				
- ​						manual list 				
- ​						rtcdata 				
- ​						smoothing 				
- ​						sources 				
- ​						sourcestats 				
- ​						tracking 				
- ​						waitsync 				

​				`chronyd` 接受这些命令的主机集合可以使用 `chronyd` 配置文件中的 `cmdallow` 指令，或者在 **chronyc** 中使用 `cmdallow` 命令配置。默认情况下，仅接受来自 localhost（127.0.0.1 或 ::1）的命令。 		

​				所有其他命令只能通过 Unix 域套接字进行。当通过网络发送时，`chronyd` 会返回 `Notauthorized` 错误，即使它来自 localhost。 		

​				以下流程描述了如何使用 **chronyc** 远程访问 chronyd。 		

**流程**

1. ​						在 `/etc/chrony.conf` 文件中添加以下内容来允许 IPv4 和 IPv6 地址的访问： 				

   

   ```none
   bindcmdaddress 0.0.0.0
   ```

   ​						或者 				

   

   ```none
   bindcmdaddress ::
   ```

2. ​						使用 `cmdallow` 指令允许来自远程 IP 地址、网络或者子网的命令。 				

   ​						在 `/etc/chrony.conf` 文件中添加以下内容： 				

   

   ```none
   cmdallow 192.168.1.0/24
   ```

3. ​						在防火墙中打开端口 323 以从远程系统连接： 				

   

   ```none
   #  firewall-cmd --zone=public --add-port=323/udp
   ```

   ​						另外，您可以使用 `--permanent` 选项永久打开端口 323： 				

   

   ```none
   #  firewall-cmd --permanent --zone=public --add-port=323/udp
   ```

4. ​						如果您永久打开了端口 323，请重新载入防火墙配置： 				

   

   ```none
   firewall-cmd --reload
   ```

**其他资源**

- ​						`chrony.conf(5)` 手册页 				

## 29.7. 使用 RHEL 系统角色管理时间同步

​				您可以使用 `timesync` 角色在多个目标机器上管理时间同步。`timesync` 角色安装和配置 NTP 或 PTP 实现，作为 NTP 或 PTP 客户端来同步系统时钟。 		

警告

​					`timesync 角色`替换了受管主机上给定或检测到的供应商服务的配置。之前的设置即使没有在角色变量中指定，也会丢失。如果没有定义 `timesync_ntp_provider` 变量，唯一保留的设置就是供应商选择。 			

​				以下示例演示了如何在只有一个服务器池的情况下应用 `timesync` 角色。 		

例 29.1. 为单一服务器池应用 timesync 角色的 playbook 示例



```none
---
- hosts: timesync-test
  vars:
    timesync_ntp_servers:
      - hostname: 2.rhel.pool.ntp.org
        pool: yes
        iburst: yes
  roles:
    - rhel-system-roles.timesync
```

​				有关 `timesync` 角色变量的详细参考，请安装 `rhel-system-roles` 软件包，并参阅 `/usr/share/doc/rhel-system-roles/timesync` 目录中的 `README.md` 或 `README.html` 文件。 		

**其他资源**

- ​						[准备控制节点和受管节点以使用 RHEL 系统角色](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html/administration_and_configuration_tasks_using_system_roles_in_rhel/assembly_preparing-a-control-node-and-managed-nodes-to-use-rhel-system-roles_administration-and-configuration-tasks-using-system-roles-in-rhel) 				

## 29.8. 其他资源

- ​						`chronyc(1)` 手册页 				
- ​						`chronyd(8)` 手册页 				
- ​						[常见问题解答](https://chrony.tuxfamily.org/faq.html) 				

# 第 30 章 带有 HW 时间戳的 Chrony

​			硬件时间戳是在一些网络接口控制器(NIC)中支持的一种功能，它提供传入和传出数据包的准确的时间戳。`NTP` 时间戳通常由内核及使用系统时钟的 **chronyd** 创建。但是，当启用了 HW 时间戳时，NIC 使用自己的时钟在数据包进入或离开链路层或物理层时生成时间戳。与 `NTP` 一起使用时，硬件时间戳可以显著提高同步的准确性。为了获得最佳准确性，`NTP` 服务器和 `NTP` 客户端都需要使用硬件时间戳。在理想条件下，可达到次微秒级的准确性。 	

​			另一个用于使用硬件时间戳进行时间同步的协议是 `PTP` 	

​			与 `NTP` 不同，`PTP` 依赖于网络交换机和路由器。如果您想要达到同步的最佳准确性，请在带有 `PTP` 支持的网络中使用 `PTP`，在使用不支持这个协议的交换机和路由器的网络上选择 `NTP`。 				

## 30.1. 验证硬件时间戳支持

​				要验证接口是否支持使用 `NTP` 的硬件时间戳，请使用 `ethtool -T` 命令。如果 `ethtool` 列出了 `SOF_TIMESTAMPING_TX_HARDWARE` 和 `SOF_TIMESTAMPING_TX_SOFTWARE` 模式，以及 `HWTSTAMP_FILTER_ ALL` 过滤器模式，则可以使用硬件时间戳的 `NTP`。 		

例 30.1. 在特定接口中验证硬件时间戳支持



```none
# ethtool -T eth0
```

​					输出： 			



```none
Timestamping parameters for eth0:
Capabilities:
        hardware-transmit     (SOF_TIMESTAMPING_TX_HARDWARE)
        software-transmit     (SOF_TIMESTAMPING_TX_SOFTWARE)
        hardware-receive      (SOF_TIMESTAMPING_RX_HARDWARE)
        software-receive      (SOF_TIMESTAMPING_RX_SOFTWARE)
        software-system-clock (SOF_TIMESTAMPING_SOFTWARE)
        hardware-raw-clock    (SOF_TIMESTAMPING_RAW_HARDWARE)
PTP Hardware Clock: 0
Hardware Transmit Timestamp Modes:
        off                   (HWTSTAMP_TX_OFF)
        on                    (HWTSTAMP_TX_ON)
Hardware Receive Filter Modes:
        none                  (HWTSTAMP_FILTER_NONE)
        all                   (HWTSTAMP_FILTER_ALL)
        ptpv1-l4-sync         (HWTSTAMP_FILTER_PTP_V1_L4_SYNC)
        ptpv1-l4-delay-req    (HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ)
        ptpv2-l4-sync         (HWTSTAMP_FILTER_PTP_V2_L4_SYNC)
        ptpv2-l4-delay-req    (HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ)
        ptpv2-l2-sync         (HWTSTAMP_FILTER_PTP_V2_L2_SYNC)
        ptpv2-l2-delay-req    (HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ)
        ptpv2-event           (HWTSTAMP_FILTER_PTP_V2_EVENT)
        ptpv2-sync            (HWTSTAMP_FILTER_PTP_V2_SYNC)
        ptpv2-delay-req       (HWTSTAMP_FILTER_PTP_V2_DELAY_REQ)
```

## 30.2. 启用硬件时间戳

​				要启用硬件时间戳，请使用 `/etc/chrony.conf` 文件中的 `hwtimestamp` 指令。该指令可指定单一接口，也可以指定通配符字符来启用所有支持接口的硬件时间戳。在没有其他应用程序（如 `linuxptp` 软件包中的 **ptp4l** 在接口上使用硬件时间戳）的情况下，请使用通配符规范。在 chrony 配置文件中允许使用多个 `hwtimestamp` 指令。 		

例 30.2. 使用 hwtimestamp 指令启用硬件时间戳



```none
hwtimestamp eth0
hwtimestamp eth1
hwtimestamp *
```

## 30.3. 配置客户端轮询间隔

​				建议为互联网中的服务器使用默认的轮询间隔范围（64-1024秒）。对于本地服务器和硬件时间戳，需要配置一个较短的轮询间隔，以便最小化系统时钟偏差。 		

​				`/etc/chrony.conf` 中的以下指令指定了使用一秒轮询间隔的本地 `NTP` 服务器： 		



```none
server ntp.local minpoll 0 maxpoll 0
```

## 30.4. 启用交错模式

​				`NTP` 服务器不是硬件的 `NTP` 设备，而是运行软件 `NTP` 实现的通用计算机，如 **chrony** ，将在发送数据包后才会获得硬件传输时间戳。此行为可防止服务器在其对应的数据包中保存时间戳。为了使 `NTP` 客户端接收传输后生成的传输时间戳，请将客户端配置为使用 `NTP` 交错模式，方法是在 `/etc/chrony.conf` 的 server 指令中添加 `xleave` 选项： 		



```none
server ntp.local minpoll 0 maxpoll 0 xleave
```

## 30.5. 为大量客户端配置服务器

​				默认服务器配置允许最多几千个客户端同时使用交错模式。要为更多的客户端配置服务器，增大 `/etc/chrony.conf` 中的 `clientloglimit` 指令。这个指令指定了为服务器上客户端访问的日志分配的最大内存大小： 		



```none
clientloglimit 100000000
```

## 30.6. 验证硬件时间戳

​				要校验该接口是否已成功启用了硬件时间戳，请检查系统日志。这个日志应该包含来自 `chronyd` 的每个接口的消息，并成功启用硬件时间戳。 		

例 30.3. 为启用硬件时间戳的接口记录日志信息



```none
chronyd[4081]: Enabled HW timestamping on eth0
chronyd[4081]: Enabled HW timestamping on eth1
```

​				当 `chronyd` 被配置为 `NTP` 客户端或对等的客户端时，您可以使用 `chronyc ntpdata` 命令为每个 `NTP` 源报告传输和接收时间戳模式以及交错模式： 		

例 30.4. 报告每个 NTP 源的传输、接收时间戳以及交集模式



```none
# chronyc ntpdata
```

​					输出： 			



```none
Remote address  : 203.0.113.15 (CB00710F)
Remote port     : 123
Local address   : 203.0.113.74 (CB00714A)
Leap status     : Normal
Version         : 4
Mode            : Server
Stratum         : 1
Poll interval   : 0 (1 seconds)
Precision       : -24 (0.000000060 seconds)
Root delay      : 0.000015 seconds
Root dispersion : 0.000015 seconds
Reference ID    : 47505300 (GPS)
Reference time  : Wed May 03 13:47:45 2017
Offset          : -0.000000134 seconds
Peer delay      : 0.000005396 seconds
Peer dispersion : 0.000002329 seconds
Response time   : 0.000152073 seconds
Jitter asymmetry: +0.00
NTP tests       : 111 111 1111
Interleaved     : Yes
Authenticated   : No
TX timestamping : Hardware
RX timestamping : Hardware
Total TX        : 27
Total RX        : 27
Total valid RX  : 27
```

例 30.5. 报告 NTP 测量的稳定性



```none
# chronyc sourcestats
```

​					启用硬件时间戳后，正常负载下，`NTP` 测量的稳定性应该以十秒或数百纳秒为单位。此稳定性会在 `chronyc sourcestats` 命令的输出结果中的 `Std Dev` 列中报告： 			

​					输出： 			



```none
210 Number of sources = 1
Name/IP Address            NP  NR  Span  Frequency  Freq Skew  Offset  Std Dev
ntp.local                  12   7    11     +0.000      0.019     +0ns    49ns
```

## 30.7. 配置 PTP-NTP 桥接

​				如果网络中有一个高度准确的 Precision Time Protocol (`PTP`)主时间服务器，但没有支持 `PTP` 支持的交换机或路由器，则计算机可能专用于作为 `PTP` 客户端和 stratum-1 `NTP` 服务器。此类计算机需要具有两个或更多个网络接口，并且接近主时间服务器或与它直接连接。这样可保证高度准确的网络同步。 		

​				从 `linuxptp` 软件包中配置 **ptp4l** 和 **phc2sys** 程序，以使用 `PTP` 来同步系统时钟。 		

​				将 `chronyd` 配置为使用其他接口提供系统时间： 		

例 30.6. 将 chronyd 配置为使用其他接口提供系统时间



```none
bindaddress 203.0.113.74
hwtimestamp eth1
local stratum 1
```

# 第 31 章 chrony 中的网络时间安全概述(NTS)

​			Network Time  Security(NTS)是用于网络时间协议(NTP)的身份验证机制，旨在扩展大量客户端。它将验证从服务器计算机接收的数据包在移到客户端机器时是否被取消处理。Network Time Security(NTS)包含 Key  Establishment(NTS-KE)协议，该协议会自动创建在服务器及其客户端中使用的加密密钥。 	

## 31.1. 在客户端配置文件中启用网络时间协议(NTS)

​				默认情况下不启用 Network Time Security(NTS)。您可以在 `/etc/chrony.conf` 中启用 NTS。为此，请执行以下步骤： 		

**先决条件**

- ​						带有 NTS 支持的服务器 				

**流程**

​					在客户端配置文件中： 			

1. ​						除推荐的 `iburst` 选项外，使用 `nts` 选项指定服务器。 				

   

   ```none
   For example:
   server time.example.com iburst nts
   server nts.netnod.se iburst nts
   server ptbtime1.ptb.de iburst nts
   ```

2. ​						要避免在系统引导时重复 Network Time Security-Key Establishment(NTS-KE)会话，请在 `chrony.conf` 中添加以下行（如果不存在）： 				

   

   ```none
   ntsdumpdir /var/lib/chrony
   ```

3. ​						要禁用 `DHCP` 提供的网络时间协议(NTP)服务器的同步，注释掉或删除 `chrony.conf` 中的以下行（如果存在）： 				

   

   ```none
   sourcedir /run/chrony-dhcp
   ```

4. ​						保存您的更改。 				

5. ​						重启 `chronyd` 服务： 				

   

   ```none
   systemctl restart chronyd
   ```

**验证**

- ​						验证 `NTS` 密钥是否已成功建立： 				

  

  ```none
  # chronyc -N authdata
  
  Name/IP address  Mode KeyID Type KLen Last Atmp  NAK Cook CLen
  ================================================================
  time.example.com  NTS     1   15  256  33m    0    0    8  100
  nts.sth1.ntp.se   NTS     1   15  256  33m    0    0    8  100
  nts.sth2.ntp.se   NTS     1   15  256  33m    0    0    8  100
  ```

  ​						`KeyID`、`Type` 和 `KLen` 应带有非零值。如果该值为零，请检查系统日志中来自 `chronyd` 的错误消息。 				

- ​						验证客户端是否正在进行 NTP 测量： 				

  

  ```none
  # chronyc -N sources
  
  MS Name/IP address Stratum Poll Reach LastRx Last sample
  =========================================================
  time.example.com   3        6   377    45   +355us[ +375us] +/-   11ms
  nts.sth1.ntp.se    1        6   377    44   +237us[ +237us] +/-   23ms
  nts.sth2.ntp.se    1        6   377    44   -170us[ -170us] +/-   22ms
  ```

  ​						`Reach` 列中应具有非零值；理想情况是 377。如果值很少为 377 或永远不是 377，这表示 NTP 请求或响应在网络中丢失。 				

**其他资源**

- ​						`chrony.conf(5)` 手册页 				

## 31.2. 在服务器上启用网络时间安全性(NTS)

​				如果您运行自己的网络时间协议(NTP)服务器，您可以启用服务器网络时间协议(NTS)支持来促进其客户端安全地同步。 		

​				如果 NTP 服务器是其它服务器的客户端，即它不是 Stratum 1 服务器，它应使用 NTS 或对称密钥进行同步。 		

**先决条件**

- ​						以 `PEM` 格式的服务器私钥 				
- ​						带有 `PEM` 格式的所需中间证书的服务器证书 				

**流程**

1. ​						在 `chrony.conf`中指定私钥和证书文件 				

   

   ```none
   For example:
   ntsserverkey /etc/pki/tls/private/foo.example.net.key
   ntsservercert /etc/pki/tls/certs/foo.example.net.crt
   ```

2. ​						通过设置组所有权，确保 chrony 系统用户可读密钥和证书文件。 				

   

   ```none
   For example:
   chown :chrony /etc/pki/tls/*/foo.example.net.*
   ```

3. ​						确保 `chrony.conf` 中存在 `ntsdumpdir /var/lib/chrony` 指令。 				

4. ​						重启 `chronyd` 服务： 				

   

   ```none
   systemctl restart chronyd
   ```

   重要

   ​							如果服务器具有防火墙，则需要允许 NTP 和 Network Time Security-Key Establishment(NTS-KE)的 `UDP 123` 和 `TCP 4460` 端口。 					

**验证**

- ​						使用以下命令从客户端机器执行快速测试： 				

  

  ```none
  $ chronyd -Q -t 3 'server
  
  foo.example.net iburst nts maxsamples 1'
  2021-09-15T13:45:26Z chronyd version 4.1 starting (+CMDMON +NTP +REFCLOCK +RTC +PRIVDROP +SCFILTER +SIGND +ASYNCDNS +NTS +SECHASH +IPV6 +DEBUG)
  2021-09-15T13:45:26Z Disabled control of system clock
  2021-09-15T13:45:28Z System clock wrong by 0.002205 seconds (ignored)
  2021-09-15T13:45:28Z chronyd exiting
  ```

  ​						`System clock wrong` 消息指示 NTP 服务器接受 NTS-KE 连接并使用 NTS 保护的 NTP 消息进行响应。 				

- ​						验证 NTS-KE 连接并验证服务器中观察的 NTP 数据包： 				

  

  ```none
  # chronyc serverstats
  
  NTP packets received       : 7
  NTP packets dropped        : 0
  Command packets received   : 22
  Command packets dropped    : 0
  Client log records dropped : 0
  NTS-KE connections accepted: 1
  NTS-KE connections dropped : 0
  Authenticated NTP packets: 7
  ```

  ​						如果 `NTS-KE connections accepted` 和 `Authenticated NTP packets` 项带有一个非零值，这意味着至少有一个客户端能够连接到 NTS-KE 端口并发送经过身份验证的 NTP 请求。 				
