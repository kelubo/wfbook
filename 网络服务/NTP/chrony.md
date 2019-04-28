# chrony

由两个程序组成，分别是chronyd和chronyc。

chronyd是一个后台运行的守护进程，用于调整内核中运行的系统时钟和时钟服务器同步。它确定计算机增减时间的比率，并对此进行补偿。

chronyc提供了一个用户界面，用于监控性能并进行多样化的配置。它可以在chronyd实例控制的计算机上工作，也可以在一台不同的远程计算机上工作。

## 安装

1.安装Chrony

系统默认已经安装，如未安装，请执行以下命令安装：

```
# yum install chrony -y
```

2.启动并加入开机自启动

```
# systemctl enable  chronyd.service
# systemctl restart chronyd.service
```

3.Firewalld设置

```
# firewall-cmd --add-service=ntp --permanent
# firewall-cmd --reload
```

## 配置

配置文件：/etc/chrony.conf

```
$ cat /etc/chrony.conf

# 使用pool.ntp.org项目中的公共服务器。以server开，理论上想添加多少时间服务器都可以。
# Please consider joining the pool (http://www.pool.ntp.org/join.html).
server 0.centos.pool.ntp.org iburst
server 1.centos.pool.ntp.org iburst
server 2.centos.pool.ntp.org iburst
server 3.centos.pool.ntp.org iburst

# 根据实际时间计算出服务器增减时间的比率，然后记录到一个文件中，在系统重启后为系统做出最佳时间补偿调整。
driftfile /var/lib/chrony/drift

# chronyd根据需求减慢或加速时间调整，使得系统逐步纠正所有时间偏差。
# 在某些情况下系统时钟可能漂移过快，导致时间调整用时过长。
# 该指令强制chronyd调整时期，大于某个阀值时步进调整系统时钟。
# 只有在因chronyd启动时间超过指定的限制时（可使用负值来禁用限制）没有更多时钟更新时才生效。
makestep 1.0 3

# 将启用一个内核模式，在该模式中，系统时间每11分钟会拷贝到实时时钟（RTC）。
rtcsync

# Enable hardware timestamping on all interfaces that support it.
# 通过使用hwtimestamp指令启用硬件时间戳
#hwtimestamp eth0
#hwtimestamp eth1
#hwtimestamp *

# Increase the minimum number of selectable sources required to adjust
# the system clock.
#minsources 2

# 指定一台主机、子网，或者网络以允许或拒绝NTP连接到扮演时钟服务器的机器
#allow 192.168.0.0/16
#deny 192.168/16

# Serve time even if not synchronized to a time source.
local stratum 10

# 指定包含NTP验证密钥的文件。
#keyfile /etc/chrony.keys

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



## 使用chronyc

通过运行chronyc命令来修改设置，命令如下：

**accheck** - 检查NTP访问是否对特定主机可用

**activity** - 该命令会显示有多少NTP源在线/离线

**add server** - 手动添加一台新的NTP服务器。

**clients** - 在客户端报告已访问到服务器

**delete** - 手动移除NTP服务器或对等服务器

**settime** - 手动设置守护进程时间

**tracking** - 显示系统时间信息

查看当前系统时区：

```
$ timedatectl
      Local time: Fri 2018-2-29 13:31:04 CST
  Universal time: Fri 2018-2-29 05:31:04 UTC
        RTC time: Fri 2018-2-29 08:17:20
       Time zone: Asia/Shanghai (CST, +0800)
     NTP enabled: yes
NTP synchronized: yes
 RTC in local TZ: no
      DST active: n/a

如果你当前的时区不正确，请按照以下操作设置。

查看所有可用的时区：

$ timedatectl list-timezones

筛选式查看在亚洲S开的上海可用时区：

$ timedatectl list-timezones |  grep  -E "Asia/S.*"

Asia/Sakhalin
Asia/Samarkand
Asia/Seoul
Asia/Shanghai
Asia/Singapore
Asia/Srednekolymsk

设置当前系统为Asia/Shanghai上海时区：

$ timedatectl set-timezone Asia/Shanghai

设置完时区后，强制同步下系统时钟：

$ chronyc -a makestep
200 OK
```



```shell
查看时间同步源：
$ chronyc sources -v

查看时间同步源状态：

$ chronyc sourcestats -v

设置硬件时间

硬件时间默认为UTC：

$ timedatectl set-local-rtc 1

启用NTP时间同步：

$ timedatectl set-ntp yes

校准时间服务器：

$ chronyc tracking
```