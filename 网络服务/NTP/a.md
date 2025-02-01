`timesyncd` and `timedatectl` will generally do the right thing in keeping your time in sync.  However, if you also want to serve NTP information then you need an NTP  server.
 `timesyncd` 并且 `timedatectl` 通常会做正确的事情来保持您的时间同步。但是，如果您还想提供 NTP 信息，则需要一个 NTP 服务器。

## 查看 `chrony` 状态

可以使用 `chronyc` 查询 `chrony` 守护程序的状态。例如，若要获取当前可用和选定时间源的概述，请运行 `chronyc sources` ，它提供如下输出：

```bash
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

还可以使用该 `chronyc sourcestats` 命令，该命令将生成如下输出：

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

One note, however: the Raspberry Pi does not come with a hardware clock, so NTP is required to keep the clock ticking. You may want to install a real time clock (RTC) as well, such as the ChronoDot. The GPS board has an RTC, which is battery backed, so that’s good enough for me. Unfortunately, the kernel can’t see the GPS RTC as a separate hardware device. This isn’t necessarily a problem; if the antenna loses connection to the orbiting satellites, then the GPS RTC will keep ticking away, giving the Pi its time, and NTP will continue to keep the clock corrected, so long as you keep an Internet connection running.

The Hardware Setup
The completed setup will look something like this, including the pin breakout. Note that the GPS PPS output connects to pin #23 on the Raspberry Pi, and the GPS TXD connects to the Raspberry PI RXD. 5V power to VIN, and GND to GND. If you want, you can connect another cable from the GPS RXD to the Raspberry PI TXD, for troubleshooting (not shown). The breadboard back has a sticky adhesive backing that I applied to the case, so it remains permanently fixed.

Completed Raspberry Pi with GPS, breadboard and case assembled.
Breadboard pin breakout

You should note that you will need to solder the both battery house and the small breadboard breakout pins to the GPS breakout board. This isn’t too difficult, but if you have zero experience soldering, you will want to get familiar with how to tin and solder first, before attempting this build.

Operating System Setup
Rather than using the stock Raspbian, we will be using a fork from Adafruit called “Occidentalis“. The latest version as of this post is “v0.2”. It still uses the Raspbian repositories, but comes with some additional packages pre-installed. Download the image, and write the image to an SD card:

# dd if=/path/to/occidentalis.img of=/dev/sdz

I’m not a big fan of setting up the HDMI and keyboard on the physical Raspberry Pi. So if you’re like me, you’ll want to SSH to it immediately. I wrote a blog post on my personal blog about masquerading ethernet interfaces, so that can help here. Mount the SD card, edit the “/etc/network/interfaces” file, and setup the virtual interface as described in that blog post. Then, when booting up the Raspberry Pi, you can insert an ethernet cable from your laptop to your Pi, and SSH directly.

Install Custom Kernel
Unfortunately, and this royally sucks, the default kernel shipped with Raspbian does not support PPS over any of the hardware pins. Further, the Raspbian kernel does not ship with a PPS module at all. So, we need to use a custom kernel. It sucks, because the kernel is old. Rolling your own custom kernel, means you’re a super villian. However, someone has already done the heavy lifting for us, and it shouldn’t be too difficult to apply the same patches to more modern kernels. However, we’ll just stick with his 3.1 kernel for this post.

Open up a terminal, and as root, install Git then clone his respository:

# apt-get install git

# git clone https://github.com/davidk/adafruit-raspberrypi-linux-pps.git

Now copy over the new kernel and kernel modules:

# cd adafruit-raspberrypi-linux-pps

# cp kernel.img /boot/kernel.img.pps

# cp -a modules/* /lib/modules

Make sure that the “pps-gpio” module is loaded on each boot by making it persistent. Add it to the “/etc/modules” config file by running the following command (make sure you’re appending STDOUT):

# echo 'pps-gpio' >> /etc/modules

Modify the “/boot/config.txt” to reflect the new kernel. Add the following line at the end of that file:

kernel=kernel.img.pps
gpu_mem=16

Reboot, and verify that you are in the right kernel, and that the “pps-gpio” module is loaded:

# uname -a

Linux ntp.example.com 3.1.9adafruit-pps+ #21 PREEMPT Sun Sep 2 10:57:58 PDT 2012 armv6l GNU/Linux

# lsmod | grep pps-gpio

pps_gpio                2314  0
pps_core                7808  2 pps_gpio,pps_ldisc

Compile NTP
The default Raspbian NTP package does not enable ATOM support, which we’ll need to take advantage of. As such, we’ll need to custom-compile NTP. Thankfully, Debian makes this easy. Pull up a terminal, and as root, edit the “/etc/apt/sources.list” file, and add the following line:

deb-src http://mirrordirector.raspbian.org/raspbian/ wheezy main contrib non-free rpi

Now, in your terminal as root, type the following commands:

# apt-get update

# apt-get build-dep ntp

# apt-get source ntp

# cd ntp-4.2.6.p5+dfsg

Now modify the “debian/rules” file, and add “--enable-ATOM” to the configure statement. Also modify the “debian/changelog” file, and append “pps” to the version number. Now build and install the package (this will take a while):

# dpkg-buildpackage -b

# cd ../

# dpkg -i ntp_4.2.6.p5+dfsg-2pps_armhf.deb ntp-doc_4.2.6.p5+dfsg-2pps_all.deb

Configure NTP
NTP uses the local address at 127.127.0.0/16 (see http://www.eecis.udel.edu/~mills/ntp/html/refclock.html#list for more information). Our Adafruit GPS module is a generic NMEA GPS, so it will be using driver 20, or 127.127.20.0. Add the following lines to the “/etc/ntp.conf” configuration file:

server 127.127.20.0 mode 17 noselect
fudge 127.127.20.0 flag1 0 time2 0

This disables PPS processing, and sets the GPS clock as “noselect”, while using other servers to actively set the system clock. This will allow you to figure out the right time for “time2” to fudge. Due to the latency of the signal being carried across the antenna cable, as well as the breadboard cables, when the time arrives to NTP, it will already be slow. So, we need to make adjustments for this.

After making those changes to your “/etc/ntp.conf” configuration file, let NTP run for 24 hours or so to stabilize the local time. Eventually, you’ll see output that may look like something similar to:

# ntpq -pn

```
 remote           refid      st t when poll reach   delay   offset  jitter
```

==============================================================================
 127.127.20.0    .GPS.            0 l   23   64  377    0.000  -726.44   6.518

In the above output, this tells me that it takes 726 milliseconds to deliver the time from the tip of the antenna to NTP (I have an SMA extension cable to get the antenna on the roof). So, I need to fudge the time by that value. So, as a result, remodify the “/etc/ntp.conf” configuration file, make the change, and restart NTP (notice the change also from “noselect” to “iburst”, as well as enabling PPS processing):

server 127.127.20.0 mode 17 iburst
fudge 127.127.20.0 flag1 1 time2 0.726

After making the change, restart NTP. Let it sit for a bit, and you should see output such that your GPS antenna has very little offset, and very little jitter:

# ntpq -pn

```
 remote           refid      st t when poll reach   delay   offset  jitter
```

==============================================================================
o127.127.20.0    .GPS.            0 l   62   64  377    0.000    0.021   0.003

Finally, we will also need to take into account leap seconds, adjusting our clock as necessary. Create the following shell script, and install it into “/usr/local/bin/leap-seconds.sh”:

#!/bin/sh
cd /etc/ntp
wget ftp://time.nist.gov/pub/leap-seconds.list &> /dev/null
service ntp restart &> /dev/null

Then, create an entry in root’s crontab(5):

0 0 31 6,12 * /usr/local/bin/leap-seconds.sh

Make sure it’s executable:

# chmod a+x /usr/local/bin/leap-seconds.sh

Now modify the “/etc/ntp.conf” configuration file one more time, and add the following line at the top of the file:

# leap seconds file

leapfile /etc/ntp/leap-seconds.list

Restart NTP.

Additional NTP Configuration
It is strongly recommended that your NTP configuration includes additional servers as part of the NTP algorithm to adjust the clock. Even though your GPS antenna will be largely responsible for the time your NTP server serves to the network, you should still use additional NTP servers to synchronize from. NTP allows you to configure up to 10 active servers in your /etc/ntp.conf configuration file. These servers will aide in the clustering algorithm for determining the more accurate time. In general, for this setup, you can expect about an average accuracy of about 60 microseconds from the One True Time, which should be good enough for most applications.

Below is my full /etc/ntp.conf configuration file after all is said and done:

# acls

restrict default kod nomodify notrap nopeer noquery
restrict -6 default kod nomodify notrap nopeer noquery
restrict 127.0.0.1
restrict -6 ::1

# logs

leapfile /etc/ntp/leap-seconds.list
driftfile /var/lib/ntp/ntp.drift
statsdir /var/log/ntpstats/
statistics loopstats peerstats clockstats
filegen loopstats file loopstats type day enable
filegen peerstats file peerstats type day enable
filegen clockstats file clockstats type day enable

# nmea source

server 127.127.20.0 mode 17 iburst
fudge 127.127.20.0 flag1 1 time2 0.728

# additional servers

server 198.60.22.240 iburst
server 137.190.2.4 iburst
server 131.188.3.221 iburst
server 216.218.192.202 iburst

Conclusion
This build isn’t for the faint of heart. It requires a great deal of patience, partly due to compiling software on a single core ARM chip, and partly due to waiting for your GPS antenna to converge. It requires a steady hand with a soldering iron, and a brief understanding of some elecrical engineering. With that said, it certainly isn’t an extremely difficult build.

But, having a stratum 1 NTP server built from a Rasberry Pi can be very rewarding. It draws less than 1 Watt of power, boots up quickly, and the GPS module locks into the satellites quickly. My only concern would be the SD card, which has a limited number of writes. Due to logging the NTP data, it could wear out the SD card faster than normal. Of course, you have backups, but it may be worth considering putting the /var/log/ directory on an iSCSI mount or more stable disk, to lengthen the life of the SD card.