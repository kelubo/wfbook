# NTP

stratum  


“iburst” 选项作用是如果在一个标准的轮询间隔内没有应答，客户端会发送一定数量的包（八个包而不是通常的一个）给 NTP 服务器。如果在短时间内呼叫 NTP 服务器几次，没有出现可辨识的应答，那么本地时间将不会变化。

不像 “iburst” ，按照 NTP 服务器的通用规则， “burst” 选项一般不允许使用（所以不要用它！）。这个选项不仅在轮询间隔发送大量包（明显又是八个），而且也会在服务器能正常使用时这样做。如果你在高层服务器持续发送包，甚至是它们在正常应答时，你可能会因为使用 “burst” 选项而被拉黑。

显然，你连接服务器的频率造成了它的负载差异（和少量的带宽占用）。使用 “minpoll” 和 “maxpoll” 选项可以本地设置频率。然而，根据连接 NTP 服务器的规则，你不应该分别修改其默认的 64 秒和 1024 秒。

此外，需要提出的是客户应该重视那些请求时间的服务器发出的“亲一下就死（死亡之吻）” （KOD）消息。如果 NTP 服务器不想响应某个特定的请求，就像路由和防火墙技术那样，那么它最有可能的就是简单地遗弃或吞没任何相关的包。

换句话说，接受到这些数据的服务器并不需要特别处理这些包，简单地丢弃这些它认为这不值得回应的包即可。你可以想象，这并不是特别好的做法，有时候礼貌地问客户是否中止或停止比忽略请求更为有效。因此，这种特别的包类型叫做 KOD 包。如果一个客户端被发送了这种不受欢迎的 KOD 包，它应该记住这个发回了拒绝访问标志的服务器。

如果从该服务器收到不止一个 KOD 包，客户端会猜想服务器上发生了流量限速的情况（或类似的）。这种情况下，客户端一般会写入本地日志，提示与该服务器的交流不太顺利，以备将来排错之用。

牢记，出于显而易见的原因，关键在于 NTP 服务器的架构应该是动态的。因此，不要给你的 NTP 配置硬编码 IP 地址是非常重要的。通过使用 DNS 域名，个别服务器断开网络时服务仍能继续进行，而 IP 地址空间也能重新分配，并且可引入简单的负载均衡（具有一定程度的弹性）。

请别忘了我们也需要考虑呈指数增长的物联网（IoT），这最终将包括数以亿万计的新装置，意味着这些设备都需要保持正确时间。硬件卖家无意（或有意）设置他们的设备只能与一个提供者的（甚至一个） NTP 服务器连接终将成为过去，这是一个非常麻烦的问题。

你可能会想象，随着买入和上线更多的硬件单元，NTP 基础设施的拥有者大概不会为相关的费用而感到高兴，因为他们正被没有实际收入所困扰。这种情形并非杞人忧天。头疼的问题多呢 -- 由于 NTP 流量导致基础架构不堪重负 -- 这在过去几年里已发生过多次。



3、ntp的配置文件
   vi /etc/ntp.conf
   server  10.48.3.182 minpoll 4 maxpoll 4 prefer
   server  10.48.3.192 minpoll 4 maxpoll 4
   slewalways yes //缓慢调整
4、校正时间（注意是否停应用）
   ntpdate 10.48.3.182
5、等待，重启ntp服务
   service ntpd start
6、将ntp服务加入开机启动项中
   chkconfig ntpd on
7、验证修改成功 ntpdate –d 10.48.3.182



 当前虚拟化遍布企业的每个角落中，在给我们带来好处的同时也带来了一些麻烦，比如正在使用的ESXi，虚拟机的系统时间有时候是不一样的，这样很糟糕比如会给mysql数据库或者日志等等造成影响，当我们手动更改时间这样是徒劳的，由于是虚拟机即使用hwclock -w 命令也无法把系统时间写入宿主机 bios，下次重启虚拟机时间又变了，有没有什么一劳永逸的方法那？答案是使用 NTP服务器！

Network Time Protocol（NTP）是用来使计算机时间同步化的一种协议，它可以使计算机对其服务器或时钟源（如石英钟，GPS等等)做同步化，它可以提供高精准度的时间校正（LAN上与标准间差小于1毫秒，WAN上几十毫秒），且可介由加密确认的方式来防止恶毒的协议攻击。

安装

原来 NTP服务器，是使用了Network Time Protocol Daemon（UDP 123 port），Linux下的 NTP 服务器安装是非常简单的，yum install ntp 就可以了。



相关配置文件

/etc/ntp.conf
NTP服务的主要配置文件，所有的更改全部在这里。

/usr/share/zoneinfo
由 tzdata 所提供，规定了各主要时区的时间设定文件，例如中国的时区设置文件是/usr/share/zoneinfo/Asia/Chongqing。

/etc/sysconfig/clock
Linux的主要时区设定文件。每次启动后Linux操作系统会自动读取这个文件来设定系统预设要显示的时间。如这个文件内容为”ZONE=Asia/Chongqing”，则表示Linux操作系统的时间设定使用/usr/share/zoneinfo/Asia/Chongqing这个文件。

/etc/localtime   
本地系统的时间设定文件，如果clock文件中规定了使用的时间设定文件为/usr/share/zoneinfo/Asia/Chongqing，Linux操作系统就会将Chongqing那个文件复制一份为/etc/localtime，所以系统的时间显示就会以Chongqing那个时间设定文件为准。



相关的命令
/bin/date
这个我们最经常使用了，更改及输出日期与时间命令。

/sbin/hwclock
使用hwclock才能将修改过后的时间写入BIOS 。

/usr/sbin/ntpd
NTP服务的守护进程，配置文件为/etc/ntp.conf 。

/usr/sbin/ntpdate
用来连接NTP服务器命令，比如ntpdate 192.168.6.51 。

/usr/sbin/ntpq
NTP查询命令。

设置NTP服务器

就如前边说的NTP配置文档只有一个 /etc/ntp.conf，看看我的ntp.conf

#红字的是我添加的，其它为默认！

    grep -Ev '^$|^#' /etc/ntp.conf  
    restrict default kod nomodify notrap nopeer noquery
    restrict -6 default kod nomodify notrap nopeer noquery
    restrict 131.107.13.100                         //允许该NTP服务器进入
    restrict 114.80.81.1                            //没有任何何參數的話，這表示『该 IP或网段不受任何限制』
    restrict 202.118.1.199
    restrict 127.0.0.1  
    restrict -6 ::1
    restrict 192.168.0.0 mask 255.255.0.0 nomodify  //该网段可以进行校时
    restrict 0.0.0.0 mask 0.0.0.0 notrust           //拒绝没有认证的用户端
    server time-nw.nist.gov prefer                  //prefer 该服务器优先
    server 0.rhel.pool.ntp.org
    server 1.rhel.pool.ntp.org
    server 2.rhel.pool.ntp.org
    fudge   127.127.1.0 stratum 10   
    driftfile /var/lib/ntp/drift
    keys /etc/ntp/keys

别忘了启动NTP服务器

/etc/init.d/ntp start



客户端测试

对了客户端只需要是用ntpdate命令即可，192.168.6.51 为ntp 服务器ip 地址，就这么就简单！



相关命令

    ntpstat   //列出我们的NTP 服务器是否与上层连接。
    synchronised to NTP server (131.107.13.100) at stratum 2  
       time correct to within 461 ms
       polling server every 64 s


    ntpq -p  //列出目前我们的NTP服务器 与上层NTP服务器 的状态，* 代表目前正在使用的上层 NTP服务器
         remote           refid      st t when poll reach   delay   offset  jitter
    ==============================================================================
    *131.107.13.100  .ACTS.           1 u   30   64   67  237.165    1.539  20.382
     202.118.1.199   202.112.31.197   2 u   33   64   63  163.526   91.844  10.208



上边只是简单设置，没有考虑安全方面如认证等等，如需更详细请参考这里。

权限管理使用 restrict 公式如下：
restrict IP mask [参数] / restrict 192.168.0.0 mask 255.255.0.0 nomodify

其中参数主要有底下这些：

    * ignore：拒绝所有类型的NTP的连线;
    * nomodfiy：用户端不能使用NTPC与ntpq这两支程式来修改伺服器的时间参数，但使用者端仍可透过这部主机来进行网路校时的;
    * noquery：用户端不能够使用ntpq，NTPC等指令来查询发表伺服器，等于不提供的NTP的网路校时幂;
    * notrap：不提供陷阱这个远端事件邮箱（远程事件日志）的功能。
    * notrust：拒绝没有认证的用户端。

如果你没有在参数的地方加上任何参数的话，这表示“该IP或网段不受任何限制的”的意思喔！一般来说，我们可以先关闭NTP的使用权限，然后再一个一个的启用允许登入的网段。







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
     remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================
 127.127.20.0    .GPS.            0 l   23   64  377    0.000  -726.44   6.518

In the above output, this tells me that it takes 726 milliseconds to deliver the time from the tip of the antenna to NTP (I have an SMA extension cable to get the antenna on the roof). So, I need to fudge the time by that value. So, as a result, remodify the “/etc/ntp.conf” configuration file, make the change, and restart NTP (notice the change also from “noselect” to “iburst”, as well as enabling PPS processing):

server 127.127.20.0 mode 17 iburst
fudge 127.127.20.0 flag1 1 time2 0.726

After making the change, restart NTP. Let it sit for a bit, and you should see output such that your GPS antenna has very little offset, and very little jitter:

# ntpq -pn
     remote           refid      st t when poll reach   delay   offset  jitter
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
