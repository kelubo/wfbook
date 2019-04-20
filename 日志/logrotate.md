# logrotate

logrotate可以自动对日志进行截断（或轮循）、压缩以及删除旧的日志文件。

默认centos系统安装自带logrotate，如果没有安装可以使用yum安装，安装方法如下:

```
yum -y install logrotate crontabs
```

软件包信息说明：

```
[root@localhost ~]# rpm -ql logrotate
/etc/cron.daily/logrotate
/etc/logrotate.conf
/etc/logrotate.d
```

logrotate的配置文件是/etc/logrotate.conf，通常不需要对它进行修改。日志文件的轮循设置在独立的配置文件中，放在/etc/logrotate.d/目录下。

## 工作原理

1. cron daemon会自动执行**/etc/cron.xxx**目录下的任务。

2. 这个会触发**/etc/cron.xxx/*yyy***文件，logrotate会执行命令

   `/etc/sbin/logrotate /etc/logrotate.conf`

3. **/etc/logrotate.conf** 包含了**/etc/logrotate.d**目录下的所有脚本。

## 参数

各个配置的具体含义：

- **/var/log/tomcat/xxxx** - 日志的路径
- **daily** - 日志文件轮循周期。可用值为 daily，weekly 或 yearly 。
- **rotate** - 保留最多七个文件
- **compress** - 压缩分割后的文件
- **size** - 当catalina.out大于5M时分割
- 
- rotate 5: 一次将存储5个归档日志。对于第六个归档，时间最久的归档将被删除。
- compress: 在轮循任务完成后，已轮循的归档将使用gzip进行压缩。
- delaycompress:总是与compress选项一起用，delaycompress选项指示logrotate不要将最近的归档压缩，压缩 将在下一次轮循周期进行。这在你或任何软件仍然需要读取最新归档时很有用。
- missingok: 在日志轮循期间，任何错误将被忽略，例如“文件无法找到”之类的错误。
- notifempty: 如果日志文件为空，轮循不会进行。
- create 644 root root: 以指定的权限创建全新的日志文件，同时logrotate也会重命名原始日志文件。
- postrotate/endscript:在所有其它指令完成后，postrotate和endscript里面指定的命令将被执行。在这种情 
  况下，rsyslogd进程将立即再次读取其配置并继续运行。

## 实例

1.新建一个文件

在/etc/logrotate.d/ 目录下新建一个文件，命名随意。

```
1 /etc/logrotate.d/tomcat
```

2.复制下面的语句至上文新建的文件中

```
/var/log/tomcat/catalina.out {
  copytruncate
  daily
  rotate 7
  compress
  missingok
  size 5M
  delaycompress
  notifempty
  create 644 root root
  postrotate
     /usr/bin/killall -HUP rsyslogd
  endscript
}
```

## 手动执行logrotate

执行以下语句来手动运行cron任务

```
/usr/sbin/logrotate /etc/logrotate.conf
```

![返回主页](https://www.cnblogs.com/Skins/custom/images/logo.gif)







配置文件说明

- 1. 

上面的模板是通用的，而配置参数则根据你的需求进行调整，不是所有的参数都是必要的。

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
/var/log/log_file {
    size=50M
    rotate 5
    dateext
    create 644 root root
    postrotate
        /usr/bin/killall -HUP rsyslogd
    endscript
}
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

在上面的配置文件中，我们只想要轮询一个日志文件，size=50M指定日志文件大小可以增长到50MB,dateext指 
示让旧日志文件以创建日期命名。

手动运行logrotate
logrotate可以在任何时候从命令行手动调用。
调用/etc/lograte.d/下配置的所有日志：

```
[root@localhost ~]# logrotate /etc/logrotate.conf 
```

要为某个特定的配置调用logrotate：

```
[root@localhost ~]# logrotate /etc/logrotate.d/log_file 
```

排障过程中的最佳选择是使用‘-d’选项以预演方式运行logrotate。要进行验证，不用实际轮循任何日志文件， 
可以模拟演练日志轮循并显示其输出。

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
[root@localhost ~]# logrotate -d /etc/logrotate.d/log_file
```

reading config file /etc/logrotate.d/log_file
reading config info for /var/log/log_file

Handling 1 logs

rotating pattern: /var/log/log_file monthly (5 rotations)
empty log files are not rotated, old logs are removed
considering log /var/log/log_file
log does not need rotating
not running postrotate script, since no logs were rotated

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

正如我们从上面的输出结果可以看到的，logrotate判断该轮循是不必要的。如果文件的时间小于一天，这就会发生了。

强制轮循即使轮循条件没有满足，我们也可以通过使用‘-f’选项来强制logrotate轮循日志文件，‘-v’参数提供了详细的输出。

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
[root@localhost ~]# logrotate -vf /etc/logrotate.d/log_file 

reading config file /etc/logrotate.d/log_file
reading config info for /var/log/log_file 

Handling 1 logs

rotating pattern: /var/log/log_file  forced from command line (5 rotations)
empty log files are not rotated, old logs are removed
considering log /var/log/log_file
  log needs rotating
rotating log /var/log/log_file, log->rotateCount is 5
dateext suffix '-20180503'
glob pattern '-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
previous log /var/log/log_file.1 does not exist
renaming /var/log/log_file.5.gz to /var/log/log_file.6.gz (rotatecount 5, logstart 1, i 5), 
old log /var/log/log_file.5.gz does not exist
renaming /var/log/log_file.4.gz to /var/log/log_file.5.gz (rotatecount 5, logstart 1, i 4), 
old log /var/log/log_file.4.gz does not exist
renaming /var/log/log_file.3.gz to /var/log/log_file.4.gz (rotatecount 5, logstart 1, i 3), 
old log /var/log/log_file.3.gz does not exist
renaming /var/log/log_file.2.gz to /var/log/log_file.3.gz (rotatecount 5, logstart 1, i 2), 
old log /var/log/log_file.2.gz does not exist
renaming /var/log/log_file.1.gz to /var/log/log_file.2.gz (rotatecount 5, logstart 1, i 1), 
old log /var/log/log_file.1.gz does not exist
renaming /var/log/log_file.0.gz to /var/log/log_file.1.gz (rotatecount 5, logstart 1, i 0), 
old log /var/log/log_file.0.gz does not exist
log /var/log/log_file.6.gz doesn't exist -- won't try to dispose of it
fscreate context set to unconfined_u:object_r:var_log_t:s0
renaming /var/log/log_file to /var/log/log_file.1
creating new /var/log/log_file mode = 0644 uid = 0 gid = 0
running postrotate script
set default create context
    
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

logrotate定时任务
logrotate需要的cron任务应该在安装时就自动创建了，我把cron文件的内容贴出来，以供大家参考。

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
[root@localhost ~]# cat /etc/cron.daily/logrotate 

    #!/bin/sh
    
    /usr/sbin/logrotate /etc/logrotate.conf
    EXITVALUE=$?
    if [ $EXITVALUE != 0 ]; then
        /usr/bin/logger -t logrotate "ALERT exited abnormally with [$EXITVALUE]"
    fi
    exit 0
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

logrotate生产应用：

为nginx设置日志切割、防止日志文件过大

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
    [root@localhost ~]# cat /etc/logrotate.d/nginx 
    
/var/log/nginx/*.log {
    daily
    rotate 5
    missingok
    notifempty
    create 644 www www
    postrotate
      if [ -f /application/nginx/logs/nginx.pid ]; then
          kill -USR1 `cat /application/nginx/logs/nginx.pid`
      fi
endscript
}
  
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

logrotate工具对于防止因庞大的日志文件而耗尽存储空间是十分有用的。配置完毕后，进程是全自动的，可以长 
时间在不需要人为干预下运行。本教程重点关注几个使用logrotate的几个基本样例，你也可以定制它以满足你的 
需求。

常见配置参数小结：

1. daily ：指定转储周期为每天
2. weekly ：指定转储周期为每周
3. monthly ：指定转储周期为每月
4. rotate count ：指定日志文件删除之前转储的次数，0指没有备份，5 指保留5 个备份
5. tabooext [+] list：让logrotate不转储指定扩展名的文件，缺省的扩展名是：.rpm-orig, .rpmsave, 
   v, 和 ~
6. missingok：在日志轮循期间，任何错误将被忽略，例如“文件无法找到”之类的错误。
7. size size：当日志文件到达指定的大小时才转储，bytes(缺省)及KB(sizek)或MB(sizem)
8. compress： 通过gzip压缩转储以后的日志
9. nocompress： 不压缩
10. copytruncate：用于还在打开中的日志文件，把当前日志备份并截断
11. nocopytruncate： 备份日志文件但是不截断
12. create mode owner group ： 转储文件，使用指定的文件模式创建新的日志文件
13. nocreate： 不建立新的日志文件
14. delaycompress： 和 compress 一起使用时，转储的日志文件到下一次转储时才压缩
15. nodelaycompress： 覆盖 delaycompress选项，转储同时压缩。
16. errors address ： 专储时的错误信息发送到指定的Email 地址
17. ifempty ：即使是空文件也转储，这个是logrotate 的缺省选项。
18. notifempty ：如果是空文件的话，不转储
19. *mail address ： 把转储的日志文件发送到指定的E-mail地址*
20. nomail ： 转储时不发送日志文件
21. olddir directory：储后的日志文件放入指定的目录，必须和当前日志文件在同一个文件系统
22. noolddir： 转储后的日志文件和当前日志文件放在同一个目录下
23. prerotate/endscript： 在转储以前需要执行的命令可以放入这个对，这两个关键字必须单独成行

 

Linux下的crontab定时执行任务命令详解：

在LINUX中，周期执行的任务一般由cron这个守护进程来处理[ps -ef|grep cron]。cron读取一个或多个配置文件，这些配置文件中包含了命令行及其调用时间。
cron的配置文件称为“crontab”，是“cron table”的简写。

一、cron服务
　　cron是一个linux下 的定时执行工具，可以在无需人工干预的情况下运行作业。
　　service crond start //启动服务
　　service crond stop //关闭服务
　　service crond restart //重启服务
　　service crond reload //重新载入配置
　　service crond status //查看服务状态

二、cron在3个地方查找配置文件：
1、/var/spool/cron/ 这个目录下存放的是每个用户包括root的crontab任务，每个任务以创建者的名字命名，比如tom建的crontab任务对应的文件就是/var/spool/cron/tom。一般一个用户最多只有一个crontab文件。

三、/etc/crontab 这个文件负责安排由系统管理员制定的维护系统以及其他任务的crontab:

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
[root@localhost cron]# cat /etc/crontab 
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root
HOME=/

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

MAILTO=root：是说，当 /etc/crontab 这个档案中的例行性命令发生错误时，会将错误讯息或者是屏幕显示的讯息传给谁？由于 root 并无法再用户端收信，因此，我通常都將这个 e-mail 改成自己的账号，好让我随时了解系统的状态！

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
[root@localhost cron]# cat /etc/cron.d/0hourly 
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root
HOME=/
01 * * * * root run-parts /etc/cron.hourly
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

01 root run-parts /etc/cron.hourly：在 #run-parts  这一行以后的命令，我们可以发现，五个数字后面接的是 root  ，这一行代表的是『执行的级别为root身份』当然，你也可以将这一行改为成其他的身份！而 run-parts代表后面接的  /etc/cron.hourly  是『一个目录内（/etc/cron.hourly）的所有可执行文件』，也就是说，每个小时的01分，系统会以root身份去/etc/cron.hourly这个目录下执行所有可执行的文件！后面三行也是类似的意思！你可以到  /etc/ 底下去看看，系统本来就预设了这4个目录！**你可以将每天需要执行的命令直接写到/etc/cron.daily即可，还不需要使用到crontab -e的程式！**

四、/etc/cron.d/ 这个目录用来存放任何要执行的crontab文件或脚本。

五、权限
crontab权限问题到/etc下一看，文件cron.allow和cron.deny是否存在
用法如下： 
1、如果两个文件都不存在，则只有root用户才能使用crontab命令。 
2、如果cron.allow存在但cron.deny不存在，则只有列在cron.allow文件里的用户才能使用crontab命令，如果root用户也不在里面，则root用户也不能使用crontab。 
3、如果cron.allow不存在, cron.deny存在，则只有列在cron.deny文件里面的用户不能使用crontab命令，其它用户都能使用。 
4、如果两个文件都存在，则列在cron.allow文件中而且没有列在cron.deny中的用户可以使用crontab，如果两个文件中都有同一个用户，以cron.allow文件里面是否有该用户为准，如果cron.allow中有该用户，则可以使用crontab命令。

AIX 中 普通用户默认都有 crontab 权限，如果要限制用户使用 crontab ,就需要编辑/etc/cron.deny 
HP-UNIX 中默认普通用户没得crontab 权限 ，要想放开普通用户的crontab 权限可以编

六、创建cron脚本
第一步：写cron脚本文件,命名为crontest.cron。
15,30,45,59 echo "xgmtest....." >> xgmtest.txt 表示，每隔15分钟，执行打印一次命令 
第二步：添加定时任务。执行命令 "crontab crontest.cron"
第三步："crontab -l" 查看定时任务是否成功或者检测/var/spool/cron下是否生成对应cron脚本

注意：这操作是直接替换该用户下的crontab，而不是新增

七、crontab用法 
crontab命令用于安装、删除或者列出用于驱动cron后台进程的表格。用户把需要执行的命令序列放到crontab文件中以获得执行。每个用户都可以有自己的crontab文件。/var/spool/cron下的crontab文件不可以直接创建或者直接修改。该crontab文件是通过crontab命令创建的

在crontab文件中如何输入需要执行的命令和时间。该文件中每行都包括六个域，其中前五个域是指定命令被执行的时间，最后一个域是要被执行的命令。每个域之间使用空格或者制表符分隔。格式如下： 
minute hour day-of-month month-of-year day-of-week commands 合法值 00-59 00-23 01-31 01-12 0-6 (0 is sunday) 除了数字还有几个个特殊的符号就是"*"、"/"和"-"、","，*代表所有的取值范围内的数字，"/"代表每的意思,"/5"表示每5个单位，"-"代表从某个数字到某个数字,","分开几个离散的数字。
-l 在标准输出上显示当前的crontab。 
-r 删除当前的crontab文件。 
-e 使用VISUAL或者EDITOR环境变量所指的编辑器编辑当前的crontab文件。当结束编辑离开时，编辑后的文件将自动安装。

八、例子： 
每天早上6点 
0 6 * echo "Good morning." >> /tmp/test.txt //注意单纯echo，从屏幕上看不到任何输出，因为cron把任何输出都email到root的信箱了。

每两个小时 
0 */2* echo "Have a break now." >> /tmp/test.txt

晚上11点到早上8点之间每两个小时和早上八点 
0 23-7/2，8 * echo "Have a good dream" >> /tmp/test.txt

每个月的4号和每个礼拜的礼拜一到礼拜三的早上11点 
0 11 4 * 1-3 command line

1月1日早上4点 
0 4 1 1 * command line SHELL=/bin/bash PATH=/sbin:/bin:/usr/sbin:/usr/bin MAILTO=root //如果出现错误，或者有数据输出，数据作为邮件发给这个帐号 HOME=/

每小时执行/etc/cron.hourly内的脚本
01 root run-parts /etc/cron.hourly
每天执行/etc/cron.daily内的脚本
02 4 * root run-parts /etc/cron.daily

每星期执行/etc/cron.weekly内的脚本
22 4 0 root run-parts /etc/cron.weekly

每月去执行/etc/cron.monthly内的脚本 
42 4 1 root run-parts /etc/cron.monthly

注意: "run-parts"这个参数了，如果去掉这个参数的话，后面就可以写要运行的某个脚本名，而不是文件夹名。 　

每天的下午4点、5点、6点的5 min、15 min、25 min、35 min、45 min、55 min时执行命令。 
5，15，25，35，45，55 16，17，18 * command

每周一，三，五的下午3：00系统进入维护状态，重新启动系统。
00 15 1，3，5 shutdown -r +5

每小时的10分，40分执行用户目录下的innd/bbslin这个指令： 
10，40 innd/bbslink

每小时的1分执行用户目录下的bin/account这个指令： 
1 bin/account

每天早晨三点二十分执行用户目录下如下所示的两个指令（每个指令以;分隔）： 
20 3 * （/bin/rm -f expire.ls logins.bad;bin/expire$#@62;expire.1st）　　

每年的一月和四月，4号到9号的3点12分和3点55分执行/bin/rm -f expire.1st这个指令，并把结果添加在mm.txt这个文件之后（mm.txt文件位于用户自己的目录位置）。 
12,55 3 4-9 1,4 * /bin/rm -f expire.1st$#@62;$#@62;mm.txt